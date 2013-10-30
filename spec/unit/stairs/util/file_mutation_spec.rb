require "spec_helper"

describe Stairs::Util::FileMutation do
  let(:filename) { "file.txt" }

  describe ".replace_or_append" do
    context "when the pattern exists in the file" do
      before do
        File.open(filename, "w") do |file|
          file.write("line1\nline2\nline3\n")
        end
      end

      after { File.delete(filename) }

      it "replaces the match and writes back to the file" do
        described_class.replace_or_append /line2/, "newLINE2", filename
        expect(File.read(filename)).to eq "line1\nnewLINE2\nline3\n"
      end
    end

    context "when the pattern does not exist in the file" do
      before do
        File.open(filename, "w") do |file|
          file.write("line1\nline2\nline3\n")
        end
      end

      after { File.delete(filename) }

      it "appends to the end of the file" do
        described_class.replace_or_append /line4/, "line4", filename
        expect(File.read(filename)).to eq "line1\nline2\nline3\nline4\n"
      end
    end
  end

  describe ".write_line" do
    before do
      File.open(filename, "w") do |file|
        file.write("line1\nline2\n")
      end
    end

    after { File.delete(filename) }

    it "appends a line to the bottom of the file" do
      described_class.write_line "line3", filename
      expect(File.read(filename)).to eq "line1\nline2\nline3\n"
    end

    context "when there is no newline at the bottom" do
      before do
        File.delete(filename) if File.exists?(filename)

        File.open(filename, "w") do |file|
          file.write("line1\nline2")
        end
      end

      it "adds a newline before appending the line" do
        described_class.write_line "line3", filename
        expect(File.read(filename)).to eq "line1\nline2\nline3\n"
      end
    end
  end

  describe ".write" do
    context "when the file exists" do
      before do
        File.open(filename, "w") do |file|
          file.write("some content\n")
        end
      end

      after { File.delete(filename) }

      it "replaces the contents of the file and leaves trailing newline" do
        described_class.write "new content", filename
        expect(File.read(filename)).to eq "new content\n"
      end
    end

    context "when the file doesn't exist" do
      after { File.delete(filename) }

      it "creates a file" do
        described_class.write "other content", filename
        expect(File.exists?(filename)).to be_true
      end

      it "writes the contents to the file" do
        described_class.write "my favorite content", filename
        expect(File.read(filename)).to eq "my favorite content\n"
      end
    end
  end
end