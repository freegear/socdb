Interface増刊 TECH I Vol.10『ATA(IDE)/ATAPIの徹底研究』付属CD-ROM

第6章 ATA&ATAPIデバイス制御プログラムの応用

このディレクトリには以下のファイルを収録しています。

 <BIOS>  ATA/ATAPIデバイス制御BIOS
 <ATAIx> PC/AT互換機用ATA/ATAPIデバイス情報表示プログラム
 <ATARx> PC/AT互換機用ATA/ATAPIデバイスセクタリードプログラム
 <ATAWx> PC/AT互換機用ATA/ATAPIデバイスセクタライトプログラム
 <CDPx>  PC/AT互換機用CDプレーヤプログラム

　<BIOS>ディレクトリには、各プログラムで共通で使用しているATA/ATAPIデバイス制御用BIOSのソースを収録しています。それぞれのディレクトリにある同名のファイル名とまったく同じものです。
　IDE_BIOS.C/IDE_BIOS.H  ATA/ATAPIデバイス制御BIOS
　IDEPrint.C/IDEPrint.H  ATA/ATAPIデバイス制御BIOS用IDENTIFY情報表示関数など
　その他、ヘッダファイルなど

　<ATAIx>ディレクトリにはPC/AT互換機用ATA/ATAPIデバイス情報表示プログラムを収録しています。
　ATAIx.C　ATA/ATAPIデバイス情報表示プログラム
　AT_IO.C　PC/AT互換機用I/Oレイヤ関数群
　MKATAI.BAT　コンパイル用バッチファイル
　IRQFUNC.H/IRQFUNC.OBJ　割り込み処理エントリライブラリ(TECHI Vol.3参照)
　ATAI1.EXE　プライマリ用実行形式ファイル(割り込み未使用版)
　ATAI1i.EXE　プライマリ用実行形式ファイル(割り込み使用版)
　ATAI2.EXE　セカンダリ用実行形式ファイル(割り込み未使用版)
　ATAI2i.EXE　セカンダリ用実行形式ファイル(割り込み使用版)

　<ATARx>ディレクトリにはPC/AT互換機用デバイスセクタリードプログラムを収録しています。
　ATARx.C　ATA/ATAPIデバイスセクタリードプログラム
　AT_IO.C　PC/AT互換機用I/Oレイヤ関数群
　MKATAR.BAT　コンパイル用バッチファイル
　IRQFUNC.H/IRQFUNC.OBJ　割り込み処理エントリライブラリ(TECHI Vol.3参照)
　ATAR1.EXE　プライマリ用実行形式ファイル(割り込み未使用版)
　ATAR1i.EXE　プライマリ用実行形式ファイル(割り込み使用版)
　ATAR2.EXE　セカンダリ用実行形式ファイル(割り込み未使用版)
　ATAR2i.EXE　セカンダリ用実行形式ファイル(割り込み使用版)

　<ATAWx>ディレクトリにはPC/AT互換機用デバイスセクタライトプログラムを収録しています。
　ATAWx.C　ATA/ATAPIデバイスセクタライトプログラム
　AT_IO.C　PC/AT互換機用I/Oレイヤ関数群
　MKATAR.BAT　コンパイル用バッチファイル
　IRQFUNC.H/IRQFUNC.OBJ　割り込み処理エントリライブラリ(TECHI Vol.3参照)
　ATAW1.EXE　プライマリ用実行形式ファイル(割り込み未使用版)
　ATAW1i.EXE　プライマリ用実行形式ファイル(割り込み使用版)
　ATAW2.EXE　セカンダリ用実行形式ファイル(割り込み未使用版)
　ATAW2i.EXE　セカンダリ用実行形式ファイル(割り込み使用版)

　<CDPx>ディレクトリにはPC/AT互換機用CDプレーヤプログラムを収録しています。
　CDPLAY.C　CDプレーヤプログラム
　AT_IO.C　PC/AT互換機用I/Oレイヤ関数群
　MKCDP.BAT　コンパイル用バッチファイル
　IRQFUNC.H/IRQFUNC.OBJ　割り込み処理エントリライブラリ(TECHI Vol.3参照)
　CDP1.EXE　プライマリ用実行形式ファイル(割り込み未使用版)
　CDP1i.EXE　プライマリ用実行形式ファイル(割り込み使用版)
　CDP2.EXE　セカンダリ用実行形式ファイル(割り込み未使用版)
　CDP2i.EXE　セカンダリ用実行形式ファイル(割り込み使用版)

注：割り込み使用版では、IDE_atapi_read_subchannel()関数が正常に動作しない、または実行に非常に時間がかかるドライブが確認されています。その場合は割り込み未使用版をお使いください。


　これらプログラムはまだまだ完成度が低い部分があります。ATA/ATAPIデバイスによっては正常に動作しない場合もあります。読者の皆さん自身の手で改良してお使いください。
