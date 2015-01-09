#!/usr/bin/ruby
$KCODE="utf-8"

library_dir = File::expand_path("./lib/") + "/"
require library_dir + "vital"
require library_dir + "tfidf"
require library_dir + "pmi"

enable_debug_message = false
#================================================================================
#    
#================================================================================

text_path = "/home/hara/Documents/Julius/reference_short/"
output_path = "./display/"

text_list = getFileList(text_path, "listup")
#text_list.each {|id|
    id = "A08M0488.ref"
    text = open(text_path + id).read
    output = open(output_path + id, "w")
    p word_list = text.gsub(/\n/, "").split(/\s[^\s]+?/)
    
#}
