require "stringio"

module MockStdIO
  def follow_prompts(*responses, &block)
    old_stdin = $stdin
    old_stdout = $stdout

    $stdin = StringIO.new("", "r+")
    fake_stdout = StringIO.new
    $stdout = fake_stdout

    responses.each { |r| $stdin << "#{r}\n" }
    $stdin.rewind

    block.call

    fake_stdout.string
  ensure
    $stdin = old_stdin
    $stdout = old_stdout
  end

  def capture_stdout(&block)
    old_stdout = $stdout

    fake_stdout = StringIO.new
    $stdout = fake_stdout

    block.call

    fake_stdout.string
  ensure
    $stdout = old_stdout
  end

  def silence_output
    @orig_stderr = $stderr
    @orig_stdout = $stdout

    # redirect stderr and stdout to /dev/null
    $stderr = File.new("/dev/null", "w")
    $stdout = File.new("/dev/null", "w")
  end

  # Replace stdout and stderr so anything else is output correctly.
  def enable_output
    $stderr = @orig_stderr
    $stdout = @orig_stdout
    @orig_stderr = nil
    @orig_stdout = nil
  end
end