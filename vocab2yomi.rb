#!/usr/bin/ruby
$KCODE="utf-8"

require "Dictionary"
#================================================================================
#【概要】
#	Palmkit出力のvocabファイルに，読み方リストを用いて，読みを付与する
#【引数】
#	ARGV[0]:Palmkit出力の語彙ファイル
#	ARGV[1]:読み方リストファイル.重複が無いようにしてあること．
#================================================================================
vocab_file_path = ARGV[0]
phoneme_list_path = ARGV[1]
#vocab_file_path = "csjCorpus.vocab"
#phoneme_list_path = "phonemeList.txt"

#読み方リストを連想配列の形で構築する．
dictionary = Dictionary.new
dictionary.loadDictionary(Dir::pwd + "/" + phoneme_list_path)

#語彙ファイルから単語を取得し，読み方リストから読み方を取得する
vocab_file = open(Dir::pwd + "/" + vocab_file_path)
vocab_file.each_line{|line|
	if /^(.*?)$/ =~ line 
		word = $1
		dictionary.printWordInformation(word)
	end
}
