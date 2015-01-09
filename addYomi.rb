#!/usr/bin/ruby
$KCODE="utf-8"

require "MeCab"
require "nkf"
#=============================================================
#		カタカナをひらがなに直す関数
#	[入力]:カタカナ文字列str
#	[出力]:strをひらがなに直した文字列
#=============================================================
def kanaFilter(str)
	return (str == nil ) ? str : NKF.nkf("-w --hiragana", str)
end
################################################################################
#	CSJのコーパスにおいて，以下の処理を行う
#		1.<s>, </s> で区切る
#		2.MeCabによって形態素毎に区切る
#
################################################################################

#文章を形態素解析する．
mcb_obj = MeCab::Tagger.new("--node-format=%m,%H\\n --eos-format=")
#str = open(Dir::pwd + "/" + ARGV[0])
str = open("/home/hara/Documents/zironKoron/palmkit/zironCorpus.vocab")
str.each_line{|word|
	#<s>,</s>の例外処理
	if word =~ /<s>/
		print "<s>" + "\t" + "silB" + "\n"
	elsif word =~ /<\/s>/
		print "</s>" + "\t" + "silE" + "\n"
	else
		tmp=mcb_obj.parse(word)
		
		#形態素分析結果毎に配列に格納
		y=tmp.split(/\n/)
		
		#各形態素解析結果を要素毎に配列に格納
		size = y.length-1
		for i in 0..size
			y[i] = y[i].split(/,/)
		end
		
		#各形態素ごとに，読みを出力
		for i in 0..size
			target = y[i]
			#形態素そのものの出力
			print target[0]
			print "\t"
			#形態素の読みを出力
			if target.length < 9
				puts kanaFilter( target[0] )
				#puts target[0]
			else
				puts kanaFilter( target[9] )
				#puts target[9]
			end
		end
	end
}
