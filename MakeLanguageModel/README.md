# Palmkitインストール
tar -zvxf palmkit-1.0.32.tar.gz  
cd palmkit-1.0.32/src/  
./configure  
make  
sudo make install  

palmkit-1.0.32/binにパスの追加が必要  
.bashrcに以下の要領でパス追加
PATH="$PATH":/path/to/palmkit-1.0.32/bin

# Juliusインストール
tar -zvxf julius-4.3.1.tar.gz  
cd julius-4.3.1/  
./configure  
make  
sudo make install  

# 他のインストールするもの
sudo apt-get install nkf  
sudo apt-get install kakasi  

# 言語モデル作成
sh text2bingram.sh 学習テキストファイル名 語彙数  

大規模コーパスの場合，/usr/tmpに一時ファイルが出力される．
フォルダの有無，アクセス権限に注意．必要あれば，sudoで実行するなど．

# 発音モデル作成
sh mkvocab.sh text2bingram.shでできた.vocabファイル  

最後に，第一エントリの単語を[]でくくって，第二エントリにすればよい  
before  
鼻	h a n a  

after  
鼻 [鼻] h a n a  
