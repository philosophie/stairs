module Stairs
  module EnvAdapters
    autoload :Rbenv, 'stairs/env_adapters/rbenv'
    autoload :RVM, 'stairs/env_adapters/rvm'
    autoload :Dotenv, 'stairs/env_adapters/dotenv'

    ADAPTERS = {
      dotenv: Dotenv,
      rbenv: Rbenv,
      rvm: RVM
    }.freeze

    def self.recommended_adapter
      ADAPTERS.values.find(&:present?)
    end

    def self.name_for_adapter_class(adapter)
      ADAPTERS.find { |_n, a| a == adapter }.first
    end
  end
end
