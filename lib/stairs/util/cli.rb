module Stairs
  module Util
    module CLI
      class << self
        def get(prompt)
          print prompt
          response = $stdin.gets.strip
          response.present? ? response : nil
        end

        def collect(*args, &block)
          Collector.new(*args, &block).run
        end
      end

      private

      class Collector
        def initialize(prompt, options={}, &block)
          @prompt = prompt
          @options = options.reverse_merge required: true
          @validator = block
        end

        def run
          times, value = 0, nil

          until valid?(value, times)
            value = CLI.get(prompt.blue)
            times += 1
          end

          value
        end

        private

        def valid?(value, times)
          if validator
            validator.call(value, times)
          else
            !!value || (!options[:required] && times > 0)
          end
        end

        attr_reader :prompt, :options, :validator
      end
    end
  end
end
