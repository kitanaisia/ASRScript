#!/bin/sh


# 引数:text2bingramの過程でできた ---.vocabファイル
# 例: sh mkvocab.sh ./sample_corpus.vocab
#
# 出力:---.dict
# このdictファイルを，さらに整形すればよい．
name=`echo $1|cut -d"." -f1`

cat $1 | nkf -e | kakasi -KH -JH | nkf -w > ${name}.yomi
paste $1 ${name}.yomi > ${name}.paste
perl myYomi2Voca.pl ${name}.paste > ${name}.dict
