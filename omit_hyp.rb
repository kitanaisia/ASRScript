#!/usr/bin/ruby 
$KCODE="utf-8"
$LOAD_PATH.push("./lib/")

# ====================================================================================================
# 音声認識結果のhypファイルを，先頭からword_limit単語だけ出力する
# ====================================================================================================
require "vital"
require "tfidf"
require "pmi"

word_limit = 300
hyp_dir = "./asrResultWithScore/"
output_path = "./asrResult_shortWithScore/"

file_list = getFileList(hyp_dir, "listup")
file_list.each {|file_name|
    hyp_array = parseHyp(File::read(hyp_dir + file_name))

    hyp = hyp_array[0].split(" ")
    score = hyp_array[1]

    output = open(output_path + file_name[0..(file_name.length - 5)] + ".txt", "w")   
    output.puts "<s> " + hyp[0..(word_limit) - 1].join(" ") + " </s>"
    output.puts "cmscore 1.000 " + score[0..(word_limit) - 1].join(" ") + " 1.000"
    output.close
}
