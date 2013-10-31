module Stairs
  class Script
    def initialize(filename)
      @filename = filename
      @script = File.read(@filename)
    end

    def run!
      puts "= Running script #{filename}".light_black
      run
    end

    private

    def run
      Step.new.instance_eval(script)
    end

    attr_reader :script, :filename
  end
end
