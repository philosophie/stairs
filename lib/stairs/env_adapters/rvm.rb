module Stairs
  module EnvAdapters
    class RVM
      def self.present?
        `which rvm`
        $?.success?
      end

      def set(name, value)
        Util::FileMutation.replace_or_append(
          Regexp.new("^export #{name}=(.*)$"),
          "export #{name}=#{value}",
          ".rvmrc",
        )
      end

      def unset(name)
        Util::FileMutation.remove Regexp.new("^export #{name}=(.*)\n"), ".rvmrc"
      end
    end
  end
end
