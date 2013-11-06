module Stairs
  module Steps
    class Postgresql < Stairs::Step
      title "PostgreSQL"
      description "Setup database.yml for PostgreSQL"

      def run
        set_database_name
        set_test_database_name
        set_username
        set_password

        write contents, "config/database.yml"
      end

      private

      def set_database_name
        contents.gsub!(
          "{{database_name}}",
          provide("Database name", default: "#{app_name}_development"),
        )
      end

      def set_test_database_name
        contents.gsub!(
          "{{test_database_name}}",
          provide("Test database name", default: "#{app_name}_test"),
        )
      end

      def set_username
        contents.gsub!(
          "{{username}}",
          provide("User", default: `whoami`.strip),
        )
      end

      def set_password
        contents.gsub!(
          "{{password}}",
          provide("Password", default: ""),
        )
      end

      def app_name
        @app_name ||= Rails.application.class.parent_name.downcase
      end

      def contents
        @contents ||= template
      end

      def template
        File.read "#{gem_root}/templates/postgresql/database.yml"
      end

      def gem_root
        "#{File.dirname(__FILE__)}/../../.."
      end
    end
  end
end
