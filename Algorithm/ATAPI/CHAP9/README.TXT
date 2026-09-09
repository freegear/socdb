Interface増刊 TECH I Vol.10『ATA(IDE)/ATAPIの徹底研究』付属CD-ROM

第9章 SH-3＆SH-4用ATAインターフェースの設計/製作

このディレクトリには以下のファイルを収録しています。

 <SH3>
   <SH3BIG>  SH-3(ビックエンディアン)用ATAホストインターフェース設計データ
   <SH3LIT>  SH-3(リトルエンディアン)用ATAホストインターフェース設計データ
   <SH3ATAI> SH-3用ATA/ATAPIデバイス情報表示プログラム
   <SH3ATAR> SH-3用ATA/ATAPIデバイスセクタリードプログラム
   <SH3ATAW> SH-3用ATA/ATAPIデバイスセクタライトプログラム
   <SH3CDP>  SH-3用CDプレーヤプログラム

 <SH4>
   <SH4BIG>  SH-4(ビックエンディアン)用ATAホストインターフェース設計データ
   <SH4LIT>  SH-4(リトルエンディアン)用ATAホストインターフェース設計データ
   <SH4ATAI> SH-4用ATA/ATAPIデバイス情報表示プログラム
   <SH4ATAR> SH-4用ATA/ATAPIデバイスセクタリードプログラム
   <SH4ATAW> SH-4用ATA/ATAPIデバイスセクタライトプログラム
   <SH4CDP>  SH-4用CDプレーヤプログラム

　SH-3用とSH-4用のディレクトリを分けています。

　<SH3BIG><SH3LIT>や<SH4BIG><SH4LIT>の各ディレクトリには、それぞれのCPUおよびエンディアン用のATAホストインターフェースのハードウェア設計データを収録しています。

　それ以外のディレクトリは、第6章のプログラムをISABaseボードのATAホストインターフェース用に移植したものです。
　ただしファイル名は、SH-3用のものは SH3ATA?.? に、SH-4用のものは SH4ATA?.? に替えています。プライマリ/セカンダリの区別はありません。また割り込み未使用版は用意していません。またI/Oレイヤ関数群もSH用のもの(SH_IO.C)を用意しています。

　SH4.C/SH4.H　SH-4用外部バス初期化関数
　SH3.C/SH3.H　SH-3用外部バス初期化関数
　CPU_INT.C/CPU_INT.H　割り込み処理ベクタ初期化関数
　ISABASE.C/ISABASE.H　ISA Base Board初期化関数
　SH_IO.C　SH用I/Oレイヤ関数群

　SH-3用とSH-4用で同名ファイルの中身は基本的には同じですが、CPU_INT.C/CPU_INT.Hのみ、CPUごとに中身が異なるので注意してください。
