require "highline/import"

module Stairs
  class Step
    def run!
      puts "== Running #{self.class.title}"
      run
    end

    private

    class_attribute :title, :description

    def self.title(title)
      self.title = title
    end

    def self.description(description)
      self.description = description
    end

    # Prompt user to provide input
    def provide(prompt, options={})
      options.reverse_merge! required: true, default: nil
      required = options[:required] && !options[:default]

      prompt << " (leave blank for #{options[:default]})" if options[:default]
      prompt << ": "

      response = ask(prompt) { |q| q.validate = /\S+/ if required }
      response.present? ? response : options[:default]
    end

    # Prompt user to make a choice
    # TODO shouldn't care about case
    def choice(question, choices=["Y", "N"])
      prompt = "#{question} (#{choices.join("/")}): "
      response = ask(prompt) { |q| q.in = choices }

      case response
      when "Y"
        response = true
      when "N"
        response = false
      end

      yield response if block_given?
      response
    end

    def bundle
      puts "== Running bundle"
      system "bundle"
    end

    def rake(task)
      puts "== Running #{task}"
      system "rake #{task}"
    end

    # Set or update env var in .rbenv-vars
    def env(name, value)
      Stairs.configuration.env_adapter.set name, value
    end

    # Replace contents of file
    def write(string, filename)
      Util::FileUtils.write(string, filename)
    end

    # Append line to file
    def write_line(string, filename)
      Util::FileUtils.write_line(string, filename)
    end

    # Embed a step where step_name is a symbol that can be resolved to a class
    # in Stairs::Steps
    def setup(step_name)
      klass = "Stairs::Steps::#{step_name.to_s.camelize}".constantize
      klass.new.run!
    end
  end
end