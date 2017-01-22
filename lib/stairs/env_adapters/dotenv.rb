module Stairs
  module EnvAdapters
    class Dotenv
      def self.present?
        defined? ::Dotenv
      end

      def set(name, value)
        Util::FileMutation.replace_or_append(
          Regexp.new("^#{name}=(.*)$"),
          "#{name}=#{value}",
          '.env'
        )
      end

      def unset(name)
        Util::FileMutation.remove Regexp.new("^#{name}=(.*)\n"), '.env'
      end
    end
  end
end
