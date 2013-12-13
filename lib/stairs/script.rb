module Stairs
  class Script
    def initialize(filename, groups)
      @filename = filename
      @script = File.read(@filename)
      @groups = groups
    end

    def run!
      puts "= Running script #{filename}".light_black
      run
    end

    private

    def run
      Step.new(groups).instance_eval(script)
    end

    attr_reader :script, :filename, :groups
  end
end
