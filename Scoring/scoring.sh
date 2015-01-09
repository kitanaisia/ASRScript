#!/bin/sh

#================================================================================
# $1.正解テキスト(reference.txt)
# $2.Julius出力の音声認識結果(result.txt)
# $3.ID(A01F0055)
# $4.１パスの2gram or ２パスのngram の指定(1 or 2)
#================================================================================

#変数定義
reference=`echo $1|cut -d"." -f1 | cut -d"/" -f2`
name=`echo $2|cut -d"." -f1 | cut -d"/" -f2`

mkdir evaluation/$3		#評価用ディレクトリにID付ディレクトリ作成
ruby makeID.rb $3 $1	#evalLog/以下に$1.hypを作成
ruby mkhyp.rb $2 > ./evalLog/${name}.hyp
ruby add_id.rb $3 ./evalLog/${name}.hyp > ./evalLog/configured_${name}.hyp
perl align.pl -u morpheme -c -f kanji -r ./evalLog/${reference}.ref ./evalLog/configured_${name}.hyp > ./evaluation/$3/${name}.ali 	#多分ここまでうまくいってる
perl score.pl ./evaluation/$3/${name}.ali
mv ${name}.ali.scr/* ./evaluation/$3/	#できた評価ディレクトリを，評価用ディレクトリ/ID名/以下に
rm -r ${name}.ali.scr
