# frozen_string_literal: true

module Travis
  module BuildEnvironment
    class Locale
      class << self
        include Chef::Mixin::ShellOut

        def generate_locales(codes, loc_file)
          locales = []

          locales += load_supported(codes, loc_file) if ::File.exist?(loc_file)

          locales = %w[en_US.UTF-8] if locales.empty?

          locales.each_slice(10) { |batch| run_locale_gen(batch) }
        end

        private

        def load_supported(codes, loc_file)
          locales = []
          loc_re = /^(#{codes.join('|')})/

          ::File.open(loc_file) do |f|
            matching = f.readlines.map(&:strip).select do |l|
              l =~ loc_re && l !~ /@/
            end

            locales += matching.map { |l| l.split.first }
          end

          locales.compact
        end

        def run_locale_gen(locales)
          shell_out!("locale-gen #{locales.join(' ')}")
        end
      end
    end
  end
end
