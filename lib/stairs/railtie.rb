module Stairs
  class Railtie < Rails::Railtie
    rake_tasks do
      load "stairs/tasks.rb"
    end
  end
end
