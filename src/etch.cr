# TODO: Write documentation for `Etch`
require "json"

module Etch
  VERSION = "0.1.0"
  # TODO: make etchfile hidden
  path = File.expand_path("~/etchfile.json")
  data = {"etchpath" => path, "outpath" => "/usr/local/bin/"}
  # TODO: Move contents to seperate method
  # TODO: Create Setup loop
  if !File.file? data["etchpath"]
    puts "Etchfile missing, setting up..."
    print "Enter path to save crystal application binaries (Default is /usr/local/bin/): "
    input = gets
    if input.nil?
      puts "Invalid input"
    elsif input != ""
      data["outpath"] = File.expand_path(input.as(String).chomp)
    end
    # TODO: Add option to create new directory if missing
    if File.directory? data["outpath"]
      etchfile = File.open data["etchpath"], "w"
      result = JSON.build do |json|
	      json.object do
  	      json.field "etchfile", data["etchpath"]
          json.field "outpath", data["outpath"]
	      end
      end
      etchfile.print result
      etchfile.close
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
end
