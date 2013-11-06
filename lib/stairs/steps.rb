module Stairs
  module Steps
    autoload :SecretToken, "stairs/steps/secret_token"
    autoload :Postgresql, "stairs/steps/postgresql"
    autoload :Facebook, "stairs/steps/facebook"
  end
end
