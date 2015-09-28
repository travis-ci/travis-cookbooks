module Travis
  module BuildEnvironment
    class Locale
      class << self
        def generate_locales(codes, loc_file)
          locales = []

          locales += load_supported(codes, loc_file) if ::File.exist?(loc_file)

          locales = %w(en_US en_US.UTF-8) if locales.empty?

          locales.each_slice(100) { |batch| run_locale_gen(batch) }
        end

        private

        def load_supported(codes, loc_file)
          locales = []
          loc_re = /^(#{codes.join('|')})_/

          ::File.open(loc_file) do |f|
            locales += f.readlines.map(&:strip).select { |l| l =~ loc_re }
          end

          locales
        end

        def run_locale_gen(locales)
          cmd = Mixlib::ShellOut.new("locale-gen #{locales.join(' ')}")
          cmd.run_command
          Chef::Log.info(cmd.stdout)
        end
      end
    end
  end
end
