# TODO: Write documentation for `Etch`
require "json"
module Etch
  VERSION = "0.1.0"
  path = ENV["HOME"]+"/etchfile.json"
  data = {"etchpath" => path,"outpath" => "/usr/local/bin/"}
      result = JSON.build do |json|
	      json.object do
  	      json.field "etchfile", data["etchpath"]
          json.field "outpath", data["outpath"]
	      end
      end
  
  path = "etchfile" 
  abort "Missing etchfile", 1 if !File.file? path
  content = File.read path
  puts content
end
