require "balanced"

module Stairs
  module Steps
    class Balanced < Step
      title "Balanced Payments"
      description "Creates a test Marketplace on Balanced"

      def run
        ::Balanced.configure(api_key.secret)

        env "BALANCED_URI", marketplace.uri
        env "BALANCED_KEY", api_key.secret
      end

      private

      def api_key
        @api_key ||= ::Balanced::ApiKey.new.save
      end

      def marketplace
        @marketplace ||= ::Balanced::Marketplace.new.save
      end
    end
  end
end