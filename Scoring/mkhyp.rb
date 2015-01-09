#!/usr/bin/ruby
$KCODE="utf-8"

#================================================================================
#	mkhyp.plに変わる，音声認識結果から認識文及び信頼度を抽出するプログラム
#	以下のような仕様を持つ
#
#	1.wseq1が存在するならば，wseq1とcmscoreを出力
#	2.pass1_best_wordseqが存在するならば，pass1_best_wordseqを出力(cmscoreは多分ない)
#	3.どちらもなければ，<s> </s>をとりあえず出力
#================================================================================

doc = open(ARGV[0]).read().split("------\n")	#split each part
hash = Hash::new()
hash.default = ""

doc.each {|part|
	pass2 = ""
	pass1 = ""
	cmscore = ""
	number = 0		#音声認識の順番がぐちゃぐちゃになった時用．

	#各音声ファイルの認識結果毎に処理
	if part =~ /^###/	#上の方のsystem logを拾わないようにする暫定処理
		#音声認識の整理番号を拾う．
		if part =~ /^Stat: adin_file: input speechfile: .*?-(.*?)\.wav$/
			number = $1.to_i
		end

		#認識文章を拾う
		if part =~ /^wseq1: (.*?)$/
			pass2 = $1 
		elsif part =~ /^pass1_best_wordseq: (.*?)$/
			pass1 = $1
		end

		#認識率を拾う
		if part =~ /^cmscore1: (.*?)$/
			cmscore = $1
		end

		if pass2 != ""
			#puts pass2
			hash[number] = hash[number] + pass2 + "\n"
		elsif pass1 != ""
			#puts pass1
			hash[number] = hash[number] + pass1 + "\n"
		else
			#puts "<s> </s>"
			hash[number] = hash[number] + "<s> </s>\n"
		end

		if cmscore != ""
			#puts "cmscore: " + cmscore
			hash[number] = hash[number] + "cmscore " + cmscore + "\n"
		end
	end
}

for i in 1..doc.length-12
	puts hash[i]
end
