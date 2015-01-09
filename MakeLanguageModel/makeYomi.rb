#!/usr/bin/ruby
$KCODE="utf-8"
require "nkf"			#to use nkf

#=============================================================
#		カタカナをひらがなに直す関数
#	[入力]:カタカナ文字列str
#	[出力]:strをひらがなに直した文字列
#=============================================================
def kanaFilter(str)
	return NKF.nkf("-w --hiragana", str)
end

#=============================================================
#		MoraEntityの謎の記述を取り除く
#	1. a&lt;b&gt;は，aを抽出.特例として(F &lt;VN&gt;)は
#	   相槌なので，単語エントリと同じようにする処理を，別途行う．
#	2. (W a;b),(B a;b) は，bを抽出
#	3. (a b) は，bを抽出
#	4. (?a) は，aを抽出
#	5. xが入っている場合，とりあえずsilにしておく
#
#	*:上記の表記はネストされている場合がある．
#		例) (W ゲンギ)&lt;息&gt;
#	  そのため，入力文字列に対して1~3の表記がないか
#	  再帰的に調べることをする．
#
#	*:再帰的に調べる際に，上の規則はこの順で守られる必要がある．
#	  例えば 1.と2.はデリミタ";"が同じであるし，
#	  2.は3.のパターンの一部である．
#=============================================================
def phoneticTranscriptionFilter(mora)
	##ルール1の特例
	if /\(F &lt;VN&gt;\)/ =~ mora
		substituted_mora = mora.sub(/\(F &lt;VN&gt;\)/, "相槌")
		configured_mora = phoneticTranscriptionFilter(substituted_mora)

	#ルール1
	elsif /(.*?)&lt;(.*?)&gt;/ =~ mora
		substituted_mora = mora.sub(/(.*?)&lt;(.*?)&gt;/, $1)
		configured_mora = phoneticTranscriptionFilter(substituted_mora)

	#ルール2
	elsif /^\([WB] (.*?);(.*?)\)$/ =~ mora
		substituted_mora = mora.sub(/\(W (.*?);(.*?)\)/, $2)
		configured_mora= phoneticTranscriptionFilter(substituted_mora)

	#ルール3
	elsif /\([\w?]* (.*?)\)/ =~ mora
		substituted_mora = mora.sub(/\([\w?]* (.*?)\)/, $1)
		configured_mora = phoneticTranscriptionFilter(substituted_mora)

	#ルール４
	elsif /\(\?(.*?)\)/ =~ mora
		substituted_mora = mora.sub(/\(\?(.*?)\)/, $1)
		#(?)単体が存在する．これはsilとする．
		if substituted_mora == ""
			substituted_mora = "sil"
		end
		configured_mora = phoneticTranscriptionFilter(substituted_mora)

	#ルール5
	#elsif/[×]+,/ =~ mora
	elsif/[×]+,/ =~ mora
		substituted_mora = mora.sub(/[×]+,/, "sil,")
		configured_mora = phoneticTranscriptionFilter(substituted_mora)
	elsif/[×]+([^×]+)/ =~ mora
		substituted_mora = mora.sub(/[×]+([^×]+)/, $1)
		configured_mora = phoneticTranscriptionFilter(substituted_mora)
	elsif/[×]+/ =~ mora
		substituted_mora = mora.sub(/[×]+/, "sil")
		configured_mora = phoneticTranscriptionFilter(substituted_mora)
	
	#上記1-5に当てはまらない場合
	else
		configured_mora = mora
	end

	return configured_mora
end

#========================================================================
#	1.a&lt;b&gt;を取り払う．
#========================================================================
def preConfigure(mora)
	#ルール1の特例
	if /\(F &lt;VN&gt;\)/ =~ mora
		substituted_mora = mora.sub(/\(F &lt;VN&gt;\)/, "相槌")
		configured_mora = preConfigure(substituted_mora)

	elsif /(.*)&lt;(.*?)&gt;/ =~ mora
		substituted_mora = mora.sub(/(.*)&lt;(.*?)&gt;/, $1)
		configured_mora = preConfigure(substituted_mora)

	else
		configured_mora = mora
	end
	return configured_mora
end

#============================================================================
#		CSJ 単語辞書生成プログラム
# 【概要】：file_path以下にあるXMLファイルから
#				言語エントリ	[Julius出力表記]	発音
# 			を抽出する．
#			出力要素とXML要素の対応は以下のようになっている．
#				言語エントリ	：PlainOrthographicTranscription
#				Julius出力表記	：PlainOrthographicTranscription
#				発音			：PhonemeEntity
#
# 【入力】：file_path以下にある全XMLファイル(XML以外があるとエラー)
# 【出力】：単語辞書ファイル dictionary.htkdic
#============================================================================
#puts = phoneticTranscriptionFilter("(F エーット")
#	1.ファイルを読み込む．
file_path = "/home/hara/csj/XML/dest/"
#file_path = "/home/hara/Documents/miniProject/XML/test_group/"
file_tmp = Dir::entries(file_path).sort							#ファイル名を読み込み、ソート
file_tmp.delete_if {|factor| factor == "."|| factor == ".."}	#. .. も読み込まれるので、削除
n_file = file_tmp.length - 1

#	2.要素抽出
for n_doc in 0..n_file
	doc = open(file_path+file_tmp[n_doc])
	print "----------------------------------------------------"
	print file_tmp[n_doc]
	print "----------------------------------------------------\n"
	word_entry=""
	word_phoneme=""

	doc.each_line{|line|
		#新しい単語エントリが見つかった場合．前の単語情報を出力し，新しい単語情報を保管
		if /PhoneticTranscription="(.*?)" PlainOrthographicTranscription="(.*?)"/ =~ line
			#上の正規表現に一致しない行はパスする
			if ($1 == "") && ($2 == "")
				next
			end
			#単語情報を保存
			word_entry << $2
			word_phoneme << $1

			#左括弧がある場合.右括弧がある場合とない場合に分かれる
			if /\(/ =~ word_phoneme
				  #左括弧と右括弧の両方があり，かつ数が等しい場合，フィルタにて括弧を外し，splitで分割し，対応する単語情報と連結し，出力
				  if /\)/ =~ word_phoneme && ( word_phoneme.scan(/\(/).length == word_phoneme.scan(/\)/).length )
					  configured_phoneme = phoneticTranscriptionFilter(word_phoneme) 
					  #splitにて分割
					  divided_word_entry = word_entry.split(",")
					  divided_word_phoneme = configured_phoneme.split(",")
					  #分割した単語情報について，単語エントリと単語の読みを連結して出力
					  number = divided_word_entry.size
					  for i in 0..number-1
						  if divided_word_phoneme[i] == "相槌"
							  divided_word_phoneme[i] = divided_word_entry[i]
						  end
						  word_information = divided_word_entry[i]+"\t"+kanaFilter(divided_word_phoneme[i])
						  puts word_information+" "
					  end

					  word_entry = ""
					  word_phoneme = ""
				  #左括弧はあるけど右括弧がない場合．デリミタ","で区切ってバッファに貯める．
				  else
					  word_entry = word_entry+","
					  word_phoneme = word_phoneme+","
				  end

				  #括弧が存在しない場合
			else
				word_information = word_entry + "\t" + kanaFilter(phoneticTranscriptionFilter(word_phoneme))
				puts word_information+" "

				word_entry = ""
				word_phoneme = ""
			end
		end
	}
end
