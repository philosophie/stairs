module Stairs
  module Util
    module FileMutation
      class << self
        def replace_or_append(pattern, string, filename)
          if File.exists? filename
            contents = File.read filename
            if contents =~ pattern
              contents.sub! pattern, string
              write contents, filename
              return
            end
          end

          write_line string, filename
        end

        def remove(pattern, filename)
          return unless File.exists? filename

          contents = File.read filename
          if contents =~ pattern
            contents.slice!(pattern)
            write contents, filename
          end
        end

        def write_line(string, filename)
          File.open filename, "a+" do |file|
            # ensure file ends with newline before appending
            last_line = file.each_line.reduce("") { |m, l| m = l }
            file.puts "" unless last_line == "" || last_line =~ /(.*)\n/

            file.puts string
          end
        end

        def write(string, filename)
          File.open filename, "w+" do |file|
            file.puts string
          end
        end
      end
    end
  end
end
