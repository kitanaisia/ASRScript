#!/bin/sh

################################################################################
#	書き起こしテキストから言語モデルを作成する
#	【入力】
#		$1:書き起こしテキストファイル名(拡張子つけても付けなくてもOK)
#		$2:語彙数
#	【出力】
#		$1を"hoge.txt"とすると，以下のファイルが出力される
#	    	hoge.freq         :単語頻度ファイル
#       	hoge.vocab        :語彙ファイル
#       	hoge.id2gram      :2gramの出現頻度ファイル
#       	hoge.id3gram      :3gramの出現頻度ファイル
#       	hoge.revid3gram   :rev3gramの出現頻度ファイル
#       	hoge.2gram.arpa   :2gram確率
#       	hoge.rev3gram.arpa:3gram確率
#       	hoge.bingram      :バイナリnグラム確率
#	【注意】
#		2gram,3gramの組み合わせが膨大であるとき，/usr/tmpあたりに
#		一時ファイルを保存する．その際，パーミッションが必要になるので，
#		このシェルスクリプトの実行時に，
#			$ sudo ./text2bingram
#		とすることを推奨する．
################################################################################

#変数定義
name=`echo $1|cut -d"." -f1`
wfreq=$name".freq"						#単語頻度リスト
vocab=$name".vocab"						#語彙リスト		
id2gram=$name".id2gram"					#2グラム出現回数
id3gram=$name".id3gram"					#3グラム出現回数
revid3gram=$name".revid3gram"			#ReverseID3グラム
ccs="csj.ccs"							#CCSに記載されている単語は，Julius出力結果に出さないよ
biGramArpa=$name".2gram.arpa"			#スムージングした2グラム
tryGramArpa=$name".3gram.arpa"			#スムージングした3グラム
revTryGramArpa=$name".rev3gram.arpa"	#スムージングした逆向き3グラム
output=$name".bingram"					#julius用言語モデル

#実行シェルコマンド
text2wfreq $1 ${wfreq}
wfreq2vocab -top $2 ${wfreq} ${vocab}                                                       #語彙ファイル作成
text2idngram -n 2 -vocab ${vocab} $1 ${id2gram}												#2gram出現回数計算
text2idngram -n 3 -vocab ${vocab} $1 ${id3gram}												#3gram出現回数計算
reverseidngram ${id3gram} ${revid3gram}														#逆向き3gram出現回数計算
idngram2lm -idngram ${revid3gram} -vocab ${vocab} -context ${ccs} -arpa ${revTryGramArpa}	#逆向き3gram確率の計算
idngram2lm -idngram ${id3gram} -vocab ${vocab} -context ${ccs} -arpa ${tryGramArpa}			#3gram確率の計算
idngram2lm -n 2 -idngram ${id2gram} -vocab ${vocab} -context ${ccs} -arpa ${biGramArpa}		#2gram確率の計算
mkbingram -nlr ${biGramArpa} -nrl ${revTryGramArpa} ${output}								#バイナリnグラムの作成
