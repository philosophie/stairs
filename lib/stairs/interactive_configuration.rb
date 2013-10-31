module Stairs
  class InteractiveConfiguration < Stairs::Step
    title "Configuration"
    description "Interactive prompt for configuring Stairs"

    def run!
      choice prompt do |yes|
        if yes
          Stairs.configuration.env_adapter = recommended_adapter.new
        else
          choice "Which would you prefer?", adapter_names do |name|
            adapter_class = Stairs::EnvAdapters::ADAPTERS[name.to_sym]
            Stairs.configuration.env_adapter = adapter_class.new
          end
        end
      end
    end

    private

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
      Stairs::EnvAdapters::ADAPTERS.map { |n, _a| n.to_s }
    end
  end
end
