require "stairs/version"
require "active_support/core_ext"
require "colorize"

module Stairs
  autoload :Step, "stairs/step"
  autoload :Script, "stairs/script"
  autoload :Steps, "stairs/steps"
  autoload :EnvAdapters, "stairs/env_adapters"
  autoload :Configuration, "stairs/configuration"
  autoload :InteractiveConfiguration, "stairs/interactive_configuration"
  autoload :Util, "stairs/util"

  class << self
    def configure
      yield(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end
  end
end

require "stairs/railtie" if defined?(Rails)
