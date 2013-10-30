module Stairs
  module EnvAdapters
    class Rbenv
      def self.present?
        `which rbenv-vars`
        $?.success?
      end

      def set(name, value)
        Util::FileMutation.replace_or_append(
          Regexp.new("^#{name}=(.*)$"),
          "#{name}=#{value}",
          ".rbenv-vars",
        )
      end
    end
  end
end