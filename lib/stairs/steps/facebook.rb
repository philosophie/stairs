module Stairs
  module Steps
    class Facebook < Stairs::Step
      title "Facebook App"
      description "Configure credentials for Facebook app"

      def run
        env "FACEBOOK_ID", provide("Facebook App ID")
        env "FACEBOOK_SECRET", provide("Facebook App Secret")
      end
    end
  end
end
