#!/usr/bin/ruby
$KCODE="utf-8"

#====================================================================================================
#	【概要】
#	ディレクトリのパスを受け取り，ディレクトリ内のファイル名リストを返す
#	【引数】
#	directory_path	:ディレクトリのパス(絶対パス，相対パスは問わない)
#	【戻り値】
#	file_list		:directory_path中の各ファイルの絶対パス(String型)を要素としたArray型配列
#					 ただし，ディレクトリ名は要素としない．
#====================================================================================================

def getFileList(directory_path)
	absolute_path = File::expand_path(directory_path) + "/"										
	file_list = Dir::entries(absolute_path).sort                                                
	file_list.delete_if{|file_name| file_name == "." || file_name == ".."}                      #カレントディレクトリ，ペアレントディレクトリを消す
	#file_list.delete_if{|file_name| File::ftype(absolute_path + file_name) == "directory"}      #ディレクトリを消す

	#ファイル名を絶対パスに
	#for i in 0..(file_list.length-1)
	#	file_list[i] = absolute_path + file_list[i]
	#end
	
	return file_list
end

#================================================================================
#	evaluation/$ID/$ID.sysから，認識精度を抽出する．
#================================================================================
sort_by_ascending_order = false
evaluation_path = "/home/hara/Documents/Julius/evaluation/"

score = Hash::new{|hash,key|hash[key] = 0}
id_list = getFileList(evaluation_path)						#list up ids
id_list.each {|id|
	result_list = getFileList(evaluation_path + id)		#list up id_order (example:A01F0055_001.wav)
	result_list.each {|file_name|
		if file_name =~ /.*?\.sys$/
			sys_file = open(evaluation_path + id + "/" + file_name).read.split("\n")
            if sort_by_ascending_order
                score[id] = sys_file[5].split("\ ")[2].to_f
            else
			    puts id + "\t" + sys_file[5].split("\ ")[2]
            end
		end
	}
}

if sort_by_ascending_order
    score.sort{|a,b|b[1] <=> a[1]}.each {|id_score|
        puts id_score[0] + "\t" + id_score[1].to_s
    }
end
