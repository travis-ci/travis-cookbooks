#
# Author:: Seth Chisamore (<schisamo@opscode.com>)
# Copyright:: Copyright (c) 2011-2012 Opscode, Inc.
# License:: Apache License, Version 2.0
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

action :run do
  begin
    # force our script to terminate and return an error code on failure
    # http://blogs.msdn.com/b/powershell/archive/2006/04/25/583241.aspx
    script_file.puts("$ErrorActionPreference = 'Stop'")
    script_file.puts(@new_resource.code)
    script_file.close

    # default flags
    flags = [
      # Hides the copyright banner at startup.
      "-NoLogo",
      # Does not present an interactive prompt to the user.
      "-NonInteractive",
      # Does not load the Windows PowerShell profile.
      "-NoProfile",
      # always set the ExecutionPolicy flag
      # see http://technet.microsoft.com/en-us/library/ee176961.aspx
      "-ExecutionPolicy RemoteSigned",
      # Powershell will hang if STDIN is redirected
      # http://connect.microsoft.com/PowerShell/feedback/details/572313/powershell-exe-can-hang-if-stdin-is-redirected
      "-InputFormat None"
    ]

    # user-provided flags
    unless @new_resource.flags.nil? || @new_resource.flags.empty?
      flags << @new_resource.flags.strip
    end

    cwd = ensure_windows_friendly_path(@new_resource.cwd)
    prefix = @new_resource.interpreter
    command = ensure_windows_friendly_path(script_file.path)

    # Chef::Resource::Execute in Chef >= 0.10.8 has first-class Win32 support
    if Gem::Version.create(Chef::VERSION) >= Gem::Version.create("0.10.8")
      execute.cwd(cwd)
      execute.environment(@new_resource.environment)
    else
      # we have to fake `cwd` and `environment` on older versions of Chef
      prefix = "cd #{@new_resource.cwd} & #{prefix}" if @new_resource.cwd
      command = create_env_wrapper(command, @new_resource.environment)
    end

    command = "#{prefix} #{flags.join(' ')} -Command \"#{command}\""

    execute.command(command)
    execute.creates(@new_resource.creates)
    execute.user(@new_resource.user)
    execute.group(@new_resource.group)
    execute.timeout(@new_resource.timeout)
    execute.returns(@new_resource.returns)
    execute.run_action(:run)

    @new_resource.updated_by_last_action(true)
  ensure
    unlink_script_file
  end
end

private

def execute
  @execute ||= Chef::Resource::Execute.new(@new_resource.name, run_context)
end

def script_file
  @script_file ||= Tempfile.open(['chef-script', '.ps1'])
end

def unlink_script_file
  @script_file && @script_file.close!
end

# take advantage of PowerShell scriptblocks
# to pass scoped environment variables to the
# command.  This is mainly only useful for versions
# of Chef < 0.10.8 when Chef::Resource::Execute
# did not support the 'environment' attribute.
def create_env_wrapper(command, environment)
  if environment
    env_string = environment.map{ |k,v| "$env:#{k}='#{v}'" }.join('; ')
    "& { #{env_string}; #{command} }"
  else
    command
  end
end

def ensure_windows_friendly_path(path)
  if path
    path.gsub(::File::SEPARATOR, ::File::ALT_SEPARATOR)
  else
    path
  end
end
