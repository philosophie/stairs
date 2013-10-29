module Stairs
  module Util
    module FileUtils
      class << self
        def replace_or_append(pattern, string, filename)
          if File.exists? filename
            contents = File.read filename
            if contents.index pattern
              contents.sub! pattern, string
              write contents, filename
              return
            end
          end

          write_line string, filename
        end

        def write_line(string, filename)
          File.open filename, "a" do |file|
            file.puts string
          end
        end

        def write(string, filename)
          File.truncate filename, 0 if File.exists? filename
          write_line string, filename
        end
      end
    end
  end
end