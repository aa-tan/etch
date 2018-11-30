# TODO: Write documentation for `Etch`
require "json"

module Etch
  VERSION = "0.1.0"
  # TODO: make etchfile hidden
  # TODO: Create Setup loop
  class App
    property data
    def initialize
      path = File.expand_path("~/.etchfile.json")
      @data = {"etchpath"  => path, "outpath" => "/usr/local/bin/"}
    end
    # TODO: Create build function

    # TODO: Clean up function
    def run_cmd(cmd, args)
      stdout = IO::Memory.new
      stderr = IO::Memory.new
      status = Process.run(cmd, args: args, output: stdout, error: stderr)
      if status.success?
        return {status.exit_code, stdout.to_s, stderr.to_s}
      else
        return {status.exit_code, stdout.to_s, stderr.to_s}
      end
      # puts "Command: #{cmd}\nArguments: #{args}\n"
      # puts "stdout: #{stdout}"
      # puts "stderr: #{stderr}"
    end

    def setup()
      puts "Could not find etchfile, starting set up."
      create_etchfile
      if File.extname(PROGRAM_NAME) == ".tmp"
        puts "Building etch."
        build(validate_file File.expand_path("./"))
      end
    end
      
    def build(fileName : String)
      puts "Starting build..."
      outdir = convert_to_file fileName
      cmd = "crystal"
      args = ["build", "-o", outdir, "--no-debug", fileName]
      if run_cmd(cmd, args)[0] == 0
        puts "Build Successful."
      else
        abort "Build failed.", 1
      end
    end

    def create_etchfile
      puts "Creating new config file in ~/.etchfile.json"
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
        puts "You may need to add the directory to your PATH"
        puts "Finished writing to etchfile"
        return true
      else
        abort "Invalid path, please try again.", 1
      end
    end

    def convert_to_file(fileName : String)
      return @data["outpath"] + File.basename(fileName, File.extname(fileName))
      end

    def set_path
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
