#!/usr/bin/ruby
$KCODE="utf-8"

#================================================================================
#	myYomi2voca.plによって作られた単語辞書を，Julius用に整える
#================================================================================

doc = open(Dir::pwd + "/" + ARGV[0])

doc.each_line{|line|
	if /^(.*?)\s+(.*?)$/ =~ line
		puts $1+"\t["+$1+"]\t"+$2
	end
}
