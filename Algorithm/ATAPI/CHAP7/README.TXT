Interface増刊 TECH I Vol.10『ATA(IDE)/ATAPIの徹底研究』付属CD-ROM

第7章 UltraDMA転送の制御プログラムの基礎

このディレクトリには以下のファイルを収録しています。

 <UDMA>  PC/AT互換機用UltraDMA転送サンプルプログラム


　<UDMA>ディレクトリにはUltraDMA転送サンプルプログラムを収録しています。
　ATATEST.C　UltraDMA転送サンプルプログラム
　ATATEST.EXE　UltraDMA転送サンプルプログラム実行形式ファイル
　MK.BAT　コンパイル用バッチファイル
　PCIFUNC.H/PCIFUNC.OBJ　PCI BIOSコールライブラリ(TECHI Vol.3参照)
　MEMFUNC.H/MEMFUNC.OBJ　ハイメモリアクセスライブラリ(TECHI Vol.3参照)
　IRQFUNC.H/IRQFUNC.OBJ　割り込み処理エントリライブラリ(TECHI Vol.3参照)

　このプログラムは、Intel82801BA(ICH2)用のソースになっています。Intel82371AB(PIIX4)で動作させる場合は、ソースの先頭のコメント行を書き換えて、コンパイルしなおしてください。
　なお、ICH2およびPIIX4以外のチップセットでは動作確認は行っていません。
