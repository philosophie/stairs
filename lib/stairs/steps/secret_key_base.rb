require 'securerandom'

module Stairs
  module Steps
    class SecretKeyBase < Step
      title 'Secret Token'
      description 'Generate a secure random secret token'

      def run
        env 'SECRET_KEY_BASE', SecureRandom.hex(64)
      end
    end
  end
end
