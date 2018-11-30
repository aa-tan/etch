# TODO: Write documentation for `Etch`
require "json"

module Etch
  VERSION = "0.1.0"
  # TODO: make etchfile hidden
  path = File.expand_path("~/etchfile.json")
  data = {"etchpath" => path, "outpath" => "/usr/local/bin/"}
  # TODO: Move contents to seperate method
  # TODO: Create Setup loop
  class App
    property data
    def initialize
      path = File.expand_path("~/etchfile.json")
      @data = {"etchpath"  => path, "outpath" => "/usr/local/bin/"}
    end
    # TODO: Create build function

    # TODO: Clean up function
    def run_cmd(cmd, args)
      stdout = IO::Memory.new
      stderr = IO::Memory.new
      status = Process.run(cmd, args: args, output: stdout, error: stderr)
      if status.success?
        {status.exit_code, stdout.to_s}
      else
        {status.exit_code, stderr.to_s}
      end
      puts "stdout:\n#{stdout}"
      puts "stderr:\n#{stderr}"
    end

    def setup()
      
    puts "Etchfile missing, setting up..."
    print "Enter path to save crystal application binaries (Default is /usr/local/bin/): "
    input = gets
    if input.nil?
      puts "Invalid input"
    elsif input != ""
        @data["outpath"] = File.expand_path(input.as(String))+"/"
    end
    # TODO: Add option to create new directory if missing
      if File.directory? @data["outpath"]
        puts "Creating new etchfile..."
        etchfile = File.open @data["etchpath"], "w"
      result = JSON.build do |json|
        json.object do
            json.field "etchfile", @data["etchpath"]
            json.field "outpath", @data["outpath"]
        end
      end
      etchfile.print result
      etchfile.close
        puts "Done."
        puts "Don't forget to add the path to your PATH if it is not already there."
    else
      puts "Invalid path"
    end
  else
    # TODO: Error handling for reading etchpath
    content = File.read data["etchpath"]
    puts typeof(content)
    converted = JSON.parse(content)
    puts typeof(converted)
    puts converted
  end

    def build(filename : String)
      outdir = convertToFile filename
      args = ["build", "-o", outdir, "--no-debug", filename]
    stdout = IO::Memory.new
    stderr = IO::Memory.new
      status = Process.run("crystal", args: args, output: stdout, error: stderr)
    if status.success?
      {status.exit_code, stdout.to_s}
    else
      {status.exit_code, stderr.to_s}
    end
    puts "stdout:\n#{stdout}"
    puts "stderr:\n#{stderr}"
  end

    def convertToFile(filename : String)
      return @data["outpath"] + File.basename(filename, File.extname(filename))
    end

    def setPath()
      content = File.read @data["etchpath"]
      path = JSON.parse(content)["outpath"].to_s
      if !File.directory? path
        abort "Error reading output directory. Ensure etchpath is storing a valid directory", 1
      end
      @data["outpath"] = path
    end

  end

end

include Etch
app = App.new
if !File.file? app.data["etchpath"]
  puts "Is this your first time?"
  app.setup
else
  # TODO: Error handling for reading etchpath
  if ARGV.size != 1
    abort "Requires a file", 1
  end
  content = File.read app.data["etchpath"]
  converted = JSON.parse(content)
  app.setPath
  inputFile = File.expand_path ARGV[0]
  if !File.file? inputFile
    abort "Invalid file", 1
  end
  app.build inputFile
  
end
# ARGV.each_with_index {|arg, i| puts "Argument #{i}: #{arg}"}

# The executable name is available as PROGRAM_NAME
# puts "Executable name: #{PROGRAM_NAME}"
