module Stairs
  class Runner
    def run!
      Stairs::InteractiveConfiguration.new.run!
      Stairs::Script.new("setup.rb").run!
    end
  end
end
