require "stairs"

module Stairs
  class Tasks
    include Rake::DSL

    def install!
      desc "Setup the project"
      task :newb do
        Stairs::InteractiveConfiguration.new.run!
        Stairs::Script.new("setup.rb").run!
      end
    end
  end
end

Stairs::Tasks.new.install!