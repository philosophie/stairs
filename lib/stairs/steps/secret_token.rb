require "securerandom"

module Stairs
  module Steps
    class SecretToken < Step
      title "Secret Token"
      description "Generate a secure random secret token"

      def run
        env "SECRET_TOKEN", SecureRandom.hex(64)
      end
    end
  end
end