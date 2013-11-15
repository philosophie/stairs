module Stairs
  module Steps
    class Facebook < Stairs::Step
      title "Facebook App"
      description "Configure credentials for Facebook app"

      def run
        env id_name, provide("Facebook App ID")
        env secret_name, provide("Facebook App Secret")
      end

      private

      def id_name
        options[:app_id] || "FACEBOOK_ID"
      end

      def secret_name
        options[:app_secret] || "FACEBOOK_SECRET"
      end
    end
  end
end
