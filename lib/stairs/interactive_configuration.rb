module Stairs
  class InteractiveConfiguration < Stairs::Step
    title "Configuration"
    description "Interactive prompt for configuring Stairs"

    def run!
      if Stairs.configuration.use_defaults
        use_recommended_adapter!
      else
        configure_env_adapter
      end
    end

    private

    def configure_env_adapter
      require_installed_adapter!

      choice prompt do |yes|
        if yes
          use_recommended_adapter!
        else
          select_env_adapter
        end
      end
    end

    def select_env_adapter
      choice "Which would you prefer?", adapter_names do |name|
        adapter_class = Stairs::EnvAdapters::ADAPTERS[name.to_sym]
        Stairs.configuration.env_adapter = adapter_class.new
      end
    end

    def use_recommended_adapter!
      Stairs.configuration.env_adapter = recommended_adapter.new
    end

    def recommended_adapter
      @recommended_adapter ||= Stairs::EnvAdapters.recommended_adapter
    end

    def recommended_adapter_name
      Stairs::EnvAdapters.name_for_adapter_class(recommended_adapter)
    end

    def prompt
      "".tap do |message|
        message << "Looks like you're using #{recommended_adapter_name} to "
        message << "manage environment variables. Is this correct?"
      end
    end

    def adapter_names
      @adapter_names ||= Stairs::EnvAdapters::ADAPTERS.map { |n, _a| n.to_s }
    end

    def require_installed_adapter!
      unless recommended_adapter
        abort <<-MSG
          Please install a supported ENV variable manager:
          #{adapter_names.join(", ")}
        MSG
      end
    end
  end
end
