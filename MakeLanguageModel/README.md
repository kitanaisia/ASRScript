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

# 言語モデル作成
sh text2bingram 学習テキストファイル名 語彙数

# 
