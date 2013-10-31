module Stairs
  class Step
    def run!
      stairs_info "== Running #{step_title}"
      run
      stairs_info "== Completed #{step_title}"
    end

    attr_writer :step_title, :step_description

    class_attribute :step_title, :step_description

    def self.title(title)
      self.step_title = title
    end

    def self.description(description)
      self.step_description = description
    end

    def step_title
      @step_title || self.class.step_title
    end

    def step_description
      @step_description || self.class.step_description
    end

    # Prompt user to provide input
    def provide(prompt, options={})
      options.reverse_merge! required: true, default: nil
      required = options[:required] && !options[:default]

      prompt << " (leave blank for #{options[:default]})" if options[:default]
      prompt << ": "

      Stairs::Util::CLI.collect(prompt.blue, required: required) ||
        options[:default]
    end

    # Prompt user to make a choice
    def choice(*args, &block)
      Choice.new(*args, &block).run
    end

    def bundle
      stairs_info "== Running bundle"
      system "bundle"
      stairs_info "== Completed bundle"
    end

    def rake(task)
      stairs_info "== Running #{task}"
      system "rake #{task}"
      stairs_info "== Completed #{task}"
    end

    # Set or update env var
    def env(name, value)
      ENV[name] = value
      Stairs.configuration.env_adapter.set name, value
    end

    # Replace contents of file
    def write(string, filename)
      Util::FileMutation.write(string, filename)
    end

    # Append line to file
    def write_line(string, filename)
      Util::FileMutation.write_line(string, filename)
    end

    # Embed a step where step_name is a symbol that can be resolved to a class
    # in Stairs::Steps or a block is provided to be executed in an instance
    # of Step
    def setup(step_name, &block)
      if block_given?
        Step.new.tap do |step|
          step.define_singleton_method :run, &block
          step.step_title = step_name.to_s.titleize
        end.run!
      else
        klass = "Stairs::Steps::#{step_name.to_s.camelize}".constantize
        klass.new.run!
      end
    end

    def finish(message)
      puts "== All done!".green
      puts message.green
    end

    def stairs_info(message)
      puts message.light_black
    end

    private

    class Choice
      # TODO: shouldn't care about case?
      def initialize(question, choices=%w[Y N], &block)
        @question = question
        @choices = choices
        @block = block
      end

      def run
        block.call processed_response if block
        processed_response
      end

      private

      attr_reader :question, :choices, :block

      def prompt
        "#{question} (#{choices.join("/")}): "
      end

      def processed_response
        @processed_response ||= case response
        when "Y"
          true
        when "N"
          false
        else
          response
        end
      end

      def response
        @reponse ||= Stairs::Util::CLI.collect prompt.blue do |value, i|
          choices.include? value
        end
      end
    end
  end
end
