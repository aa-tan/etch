# TODO: Write documentation for `Etch`
module Etch
  VERSION = "0.1.0"
  
  path = "etchfile" 
  abort "Missing etchfile", 1 if !File.file? path
  content = File.read path
  puts content
end
