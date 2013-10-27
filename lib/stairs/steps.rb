module Stairs
  module Steps
    autoload :SecretToken, "stairs/steps/secret_token"
    autoload :S3, "stairs/steps/s3"
    autoload :Balanced, "stairs/steps/balanced"
  end
end