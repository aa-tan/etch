# TODO: Write documentation for `Etch`
require "json"
module Etch
  VERSION = "0.1.0"
  path = File.expand_path("~/etchfile.json")
  data = {"etchpath" => path,"outpath" => "/usr/local/bin/"}
  if !File.file? data["etchpath"]
    puts "Etchfile missing, setting up..."
    print "Enter path to save crystal application binaries (Default is /usr/local/bin/): "
    input = gets
    if input.nil?
      puts "Invalid input"
    elsif input != ""
      data["outpath"] = File.expand_path(input.as(String).chomp)
    end
    if File.directory? data["outpath"]
      etchfile = File.open data["etchpath"],"w"
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

  end
  
  path = "etchfile" 
  abort "Missing etchfile", 1 if !File.file? path
  content = File.read path
  puts content
end
