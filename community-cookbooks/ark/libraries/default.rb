# libs

module Opscode
  module Ark
    module ProviderHelpers
      private

      def unpack_type
        case parse_file_extension
        when /tar.gz|tgz/  then "tar_xzf"
        when /tar.bz2|tbz/ then "tar_xjf"
        when /tar.xz|txz/  then "tar_xJf"
        when /zip|war|jar/ then "unzip"
        else fail "Don't know how to expand #{new_resource.url}"
        end
      end

      def parse_file_extension
        if new_resource.extension.nil?
          # purge any trailing redirect
          url = new_resource.url.clone
          url =~ %r{^https?:\/\/.*(.bin|bz2|gz|jar|tbz|tgz|txz|war|xz|zip)(\/.*\/)}
          url.gsub!(Regexp.last_match(2), '') unless Regexp.last_match(2).nil?
          # remove tailing query string
          release_basename = ::File.basename(url.gsub(/\?.*\z/, '')).gsub(/-bin\b/, '')
          # (\?.*)? accounts for a trailing querystring
          Chef::Log.debug("DEBUG: release_basename is #{release_basename}")
          release_basename =~ /^(.+?)\.(jar|tar\.bz2|tar\.gz|tar\.xz|tbz|tgz|txz|war|zip)(\?.*)?/
          Chef::Log.debug("DEBUG: file_extension is #{Regexp.last_match(2)}")
          new_resource.extension = Regexp.last_match(2)
        end
        new_resource.extension
      end

      def unpack_command
        case unpack_type
        when "tar_xzf"
          cmd = tar_command("xzf")
        when "tar_xjf"
          cmd = tar_command("xjf")
        when "tar_xJf"
          cmd = tar_command("xJf")
        when "unzip"
          cmd = unzip_command
        end
        Chef::Log.debug("DEBUG: cmd: #{cmd}")
        cmd
      end

      def tar_command(tar_args)
        cmd = node['ark']['tar']
        cmd += " #{tar_args} "
        cmd += new_resource.release_file
        cmd += tar_strip_args
        cmd
      end

      def unzip_command
        if new_resource.strip_components > 0
          require 'tmpdir'
          tmpdir = Dir.mktmpdir
          strip_dir = '*/' * new_resource.strip_components
          cmd = "unzip -q -u -o #{new_resource.release_file} -d #{tmpdir}"
          cmd += " && rsync -a #{tmpdir}/#{strip_dir} #{new_resource.path}"
          cmd += " && rm -rf #{tmpdir}"
          cmd
        else
          "unzip -q -u -o #{new_resource.release_file} -d #{new_resource.path}"
        end
      end

      def dump_command
        case unpack_type
        when "tar_xzf", "tar_xjf", "tar_xJf"
          cmd = "tar -mxf \"#{new_resource.release_file}\" -C \"#{new_resource.path}\""
        when "unzip"
          cmd = "unzip  -j -q -u -o \"#{new_resource.release_file}\" -d \"#{new_resource.path}\""
        end
        Chef::Log.debug("DEBUG: cmd: #{cmd}")
        cmd
      end

      def cherry_pick_command
        case unpack_type
        when "tar_xzf"
          cmd = cherry_pick_tar_command("xzf")
        when "tar_xjf"
          cmd = cherry_pick_tar_command("xjf")
        when "tar_xJf"
          cmd = cherry_pick_tar_command("xJf")
        when "unzip"
          cmd = "unzip -t #{new_resource.release_file} \"*/#{new_resource.creates}\" ; stat=$? ;"
          cmd += "if [ $stat -eq 11 ] ; then "
          cmd += "unzip  -j -o #{new_resource.release_file} \"#{new_resource.creates}\" -d #{new_resource.path} ;"
          cmd += "elif [ $stat -ne 0 ] ; then false ;"
          cmd += "else "
          cmd += "unzip  -j -o #{new_resource.release_file} \"*/#{new_resource.creates}\" -d #{new_resource.path} ;"
          cmd += "fi"
        end
        Chef::Log.debug("DEBUG: cmd: #{cmd}")
        cmd
      end

      def cherry_pick_tar_command(tar_args)
        cmd = node['ark']['tar']
        cmd += " #{tar_args}"
        cmd += " #{new_resource.release_file}"
        cmd += " -C"
        cmd += " #{new_resource.path}"
        cmd += " #{new_resource.creates}"
        cmd += tar_strip_args
        cmd
      end

      def set_paths
        release_ext = parse_file_extension
        prefix_bin  = new_resource.prefix_bin.nil? ? new_resource.run_context.node['ark']['prefix_bin'] : new_resource.prefix_bin
        prefix_root = new_resource.prefix_root.nil? ? new_resource.run_context.node['ark']['prefix_root'] : new_resource.prefix_root
        if new_resource.prefix_home.nil?
          default_home_dir = ::File.join(new_resource.run_context.node['ark']['prefix_home'], new_resource.name)
        else
          default_home_dir =  ::File.join(new_resource.prefix_home, new_resource.name)
        end
        # set effective paths
        new_resource.prefix_bin = prefix_bin
        new_resource.version ||= "1"  # initialize to one if nil
        new_resource.path       = ::File.join(prefix_root, "#{new_resource.name}-#{new_resource.version}")
        new_resource.home_dir ||= default_home_dir
        Chef::Log.debug("path is #{new_resource.path}")
        new_resource.release_file     = ::File.join(Chef::Config[:file_cache_path],  "#{new_resource.name}-#{new_resource.version}.#{release_ext}")
      end

      def set_put_paths
        release_ext = parse_file_extension
        path = new_resource.path.nil? ? new_resource.run_context.node['ark']['prefix_root'] : new_resource.path
        new_resource.path      = ::File.join(path, new_resource.name)
        Chef::Log.debug("DEBUG: path is #{new_resource.path}")
        new_resource.release_file     = ::File.join(Chef::Config[:file_cache_path],  "#{new_resource.name}.#{release_ext}")
      end

      def set_dump_paths
        release_ext = parse_file_extension
        new_resource.release_file  = ::File.join(Chef::Config[:file_cache_path],  "#{new_resource.name}.#{release_ext}")
      end

      def tar_strip_args
        new_resource.strip_components > 0 ? " --strip-components=#{new_resource.strip_components}" : ""
      end

      def show_deprecations
        if [true, false].include?(new_resource.strip_leading_dir)
          Chef::Log.warn("DEPRECATED: strip_leading_dir attribute was deprecated. Use strip_components instead.")
        end
      end

      # def unpacked?(path)
      #   if new_resource.creates
      #     full_path = ::File.join(new_resource.path, new_resource.creates)
      #   else
      #     full_path = path
      #   end
      #   if ::File.directory? full_path
      #     if ::File.stat(full_path).nlink == 2
      #       false
      #     else
      #       true
      #     end
      #   elsif ::File.exists? full_path
      #     true
      #   else
      #     false
      #   end
      # end
    end
  end
end
