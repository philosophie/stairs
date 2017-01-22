module Stairs
  class Runner
    def initialize(groups = nil)
      @groups = groups
    end

    def run!
      Stairs::InteractiveConfiguration.new.run!
      Stairs::Script.new('setup.rb', groups).run!
    end

    private

    attr_reader :groups
  end
end
