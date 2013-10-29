module Stairs
  module EnvAdapters
    class Dotenv
      def self.present?
        defined? ::Dotenv
      end

      def set(name, value)
        Util::FileUtils.replace_or_append(
          Regexp.new("^#{name}=(.*)$"),
          "#{name}=#{value}",
          ".env",
        )
      end
    end
  end
end