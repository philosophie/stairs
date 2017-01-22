module Stairs
  module Util
    module FileMutation
      class << self
        def replace_or_append(pattern, string, filename)
          if File.exist? filename
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
          return unless File.exist? filename

          contents = File.read filename
          return unless contents =~ pattern

          contents.slice!(pattern)
          write contents, filename
        end

        def write_line(string, filename)
          File.open filename, 'a+' do |file|
            # ensure file ends with newline before appending
            last_line = file.each_line.reduce('') { |_m, l| l }
            file.puts '' unless last_line == '' || last_line =~ /(.*)\n/

            file.puts string
          end
        end

        def write(string, filename)
          File.open filename, 'w+' do |file|
            file.puts string
          end
        end
      end
    end
  end
end
