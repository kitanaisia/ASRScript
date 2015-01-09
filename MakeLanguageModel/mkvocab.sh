#!/bin/sh


# $B0z?t(B:text2bingram$B$N2aDx$G$G$-$?(B ---.vocab$B%U%!%$%k(B
# $BNc(B: sh mkvocab.sh ./sample_corpus.vocab
#
# $B=PNO(B:---.dict
# $B$3$N(Bdict$B%U%!%$%k$r!$$5$i$K@07A$9$l$P$h$$!%(B
name=`echo $1|cut -d"." -f1`

cat $1 | nkf -e | kakasi -JH | nkf -w > ${name}.yomi
paste $1 ${name}.yomi > ${name}.paste
perl myYomi2Voca.pl ${name}.paste > ${name}.dict
