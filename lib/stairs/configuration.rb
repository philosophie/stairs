module Stairs
  class Configuration
    attr_accessor :env_adapter
    attr_accessor :use_defaults

    def initialize
      self.use_defaults = false
    end
  end
end
