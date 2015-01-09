#!/usr/bin/ruby
$KCODE="utf-8"

###############################################################
# CSJ音声認識プログラム
# 【概要】：HTK/Palmkit用に整えられた正解テキストに対して
#			IDを割り振る．
# 【入力】：第一引数	割り振るID名
#			第二引数	正解テキスト名 「正解テキストファイル名」.txt
# 【出力】：正解テキストにIDが割り振られたもの
#			「正解テキストファイル名」.ref
#
# $ ruby makeID.rb A01F0055 source.txt のようにして使う．
###############################################################

# 出力ファイル名設定
directory_path = "/home/hara/Documents/Julius/evalLog/"	#出力ファイルの保存ディレクトリ

# 入力ファイル名の訂正し，出力ファイル名を作成
input_name = ARGV[1]
if input_name =~ /^.*?\/([^\/]+?\.ref)$/
	input_name = input_name.sub(/^.*?\/([^\/]+?\.ref)$/, $1)
end
input_name_length = input_name.length
output_name = input_name[0..(input_name_length-5)] + ".ref"

# 入出力ファイルオープン
correct_text = open(ARGV[1])
ref_text = open(directory_path + output_name, "w")

# 入力文章にIDを付与して出力
sentence_no = 0
correct_text.each_line{|sentence|
	sentence_no += 1                				#ID番号インクリメント
	id = ARGV[0] + format("-%03d", sentence_no)		#付与ID名
	ref_text.puts id                				
	ref_text.puts sentence          				
}

