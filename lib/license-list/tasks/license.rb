module LicenseList
  module Tasks
    module License
      extend self
      def list
        output_gem_data($stdout)
      end
      def export(file_name)
        if file_name.blank?
          file_name = "license.csv"
        end

        if File.exist?(file_name)
          puts "file #{file_name} already exists"
        else
          puts "writing to #{file_name}"
          File.open(file_name, "w+") do |f|
            output_gem_data(f)
          end
        end
      end

      private

      def output_gem_data(output)
        Gem.loaded_specs.each do |key, spec|
          gem_name = spec.name.gsub('"', '\'')
          licenses = spec.licenses.map do |license|
            license.gsub('"', '\'')
          end.join(',')

          source_code_uri = spec.metadata["source_code_uri"]&.gsub('"', '\'')
          homepage = spec.homepage&.gsub('"', '\'')
          homepage_uri = spec.metadata["homepage_uri"]&.gsub('"', '\'')
          uris = [source_code_uri,homepage_uri,homepage].compact.uniq.join(',')

          output.write("\"#{gem_name}\",\"#{licenses}\",\"#{uris}\"\n")
        end
      end
    end
  end
end
