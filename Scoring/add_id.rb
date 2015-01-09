#!/usr/bin/ruby

##
## add_id.rb:音声認識の仮説ファイルを整形して、IDを付与する
##

$KCODE="UTF-8"
require 'nkf'

hyp_file = File.read(ARGV[1])

i=1
for line in hyp_file
  if /<s>/ =~ line
    puts ARGV[0]+format("-%03d",i)
    i+=1;
  end
  puts line.gsub(/\+.+?\s+/," ").gsub(/<sp>\s/,"").gsub(/。\s|、\s/,"")
end
