Interface増刊 TECH I Vol.10『ATA(IDE)/ATAPIの徹底研究』付属CD-ROM

第8章 ATAインターフェース搭載PCIボードの設計/製作

このディレクトリには以下のファイルを収録しています。

 <PCIATA>  PCIバス対応ATAホストインターフェース用設計データ
 <PCIATAI> PC/AT互換機用ATA/ATAPIデバイス情報表示プログラム
 <PCIATAR> PC/AT互換機用ATA/ATAPIデバイスセクタリードプログラム
 <PCIATAW> PC/AT互換機用ATA/ATAPIデバイスセクタライトプログラム
 <PCICDP>  PC/AT互換機用CDプレーヤプログラム

　<PCIATA>ディレクトリには、ATAホストインターフェースのハードウェア設計データを収録しています。

　それ以外のディレクトリは、第6章のプログラムをこのPCIバス対応ATAホストインターフェース用に移植したものです。
　ただしファイル名は PCIATA?.? に替えています。プライマリ/セカンダリの区別はありません。またI/Oレイヤ関数群は、第6章のものと同一です。

　PCIFUNC.H/PCIFUNC.OBJ　PCI BIOSコールライブラリ(TECHI Vol.3参照)
　IRQFUNC.H/IRQFUNC.OBJ　割り込み処理エントリライブラリ(TECHI Vol.3参照)

