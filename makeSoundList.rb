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
#	input_directory_path/$id/以下にある全てのファイルの絶対パスを
#	soundlist_directory_path/$id.txt に出力する
#================================================================================

input_directory_path = "/home/hara/Documents/Julius/voice/"				#
soundlist_directory_path = "/home/hara//Documents/Julius/soundList/"  	#

id_list = getFileList(input_directory_path)						#list up ids
id_list.each {|id|
	output_file = open(soundlist_directory_path + id + ".txt", "w")			#declare output file name
	id_sound_list = getFileList(input_directory_path + id)		#list up id_order (example:A01F0055_001.wav)
	id_sound_list.each {|id_number|
		output_file.puts input_directory_path + id + "/" + id_number
	}
	output_file.close
}

