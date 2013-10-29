module Stairs
  class InteractiveConfiguration < Stairs::Step
    title "Configuration"
    description "Interactive prompt for configuring Stairs"

    def run!
      adapter_class = Stairs::EnvAdapters.recommended_adapter
      adapter_name = Stairs::EnvAdapters.name_for_adapter_class(adapter_class)

      choice "Looks like you're using #{adapter_name} to manage environment variables. Is this correct?" do |yes|
        if yes
          Stairs.configuration.env_adapter = adapter_class.new
        else
          choice "Which would you prefer?", Stairs::EnvAdapters::ADAPTERS.map { |n,_a| n.to_s } do |name|
            adapter_class = Stairs::EnvAdapters::ADAPTERS[name.to_sym]
            Stairs.configuration.env_adapter = adapter_class.new
          end
        end
      end
    end
  end
end