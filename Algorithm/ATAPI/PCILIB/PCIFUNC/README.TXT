PCI BIOSコールライブラリ(PCIFUNC)   Ver.2.0


　Interface1999年3月号の第5章に掲載時より新たな関数が追加されバージョンアップが行われています．最新版の関数一覧は本アーカイブファイル同封の PCIFUNC.TXT を参照してください．
　さらに対応コンパイラとして，LSI C-86試食版以外にTurbo Cにも対応しました．


●アーカイブファイル内容
README.TXT	アーカイブファイル内容説明(このファイル)

PCIFUNC.TXT	PCIFUNC関数説明ファイル
PCIFUNC.H	PCIFUNCヘッダファイル
PCIFUNC.ASM	PCIFUNCアセンブラソースファイル(LSI C-86用)
PCIFUNC.OBJ	PCIFUNCオブジェクトファイル(LSI C-86用)
PCIFUNC2.ASM	PCIFUNCアセンブラソースファイル(Turbo C用)
PCIFUNC2.OBJ	PCIFUNCオブジェクトファイル(Turbo C用)
MK.BAT		PCIFUNCオブジェクト生成用アセンブルバッチファイル

PCITEST.C	PCIFUNC用サンプルソース
MKSMP.BAT	PCIFUNC用サンプルプログラム用コンパイルバッチファイル
PCITESTL.EXE	PCIFUNC用サンプルプログラム(LSI C-86でコンパイルしたもの)
PCITESTT.EXE	PCIFUNC用サンプルプログラム(Turbo Cでコンパイルしたもの)


●PCIFUNCについて
　アセンブルにはTurboアセンブラ 2.01を使用しています．


●PCITESTのコンパイル方法
▲PCITESTL.EXE(LSI C-86試食版)
　IRQTESTL.EXEはLSI C-86試食版でコンパイルしたEXEファイルです．LSI C-86試食版をコンパイルできる環境下で，カレントディレクトリに PCITEST.C PCIFUNC.H PCIFUNC.OBJ MKSMP.BAT を置いて，そこで MKSMP.BAT を実行するとコンパイルされます．

▲PCITESTT.EXE(Turbo C)
　PCITESTTはTurbo C 2.0でコンパイルしたEXEファイルです．Turbo Cをコンパイルできる環境下で，カレントディレクトリに PCITEST.C PCIFUNC.H PCIFUNC.OBJ PCIFUNC2.OBJ MKSMP.BAT を置いて，そこで MKSMP.BAT を実行するとコンパイルされます．


●PCITESTの動作内容
　このプログラムは，そのシステムのPCIバスのバージョンやPCIバスの数などを表示します．
　次にベンダID 8086h デバイスID 7180h のデバイスを検索します．実行中のマシンのCPUがPentiumIIでチップセットがインテル 440LXの場合は，そのデバイスのバス番号/デバイス番号/ファンクション番号を表示します．
　次にVGA互換デバイスを検索して，そのベースアドレスレジスタを表示します．ISAバスのVGAカードを使っている場合はPCIのVGAカードが存在しないので「デバイスが見つかりませんでした．」と表示されるはずです．
　さらに，PCIデバイスのVGAカードを発見した場合は，そのデバイスのベースアドレスレジスタ6本の内容を読み出して表示します．


●バージョンアップ履歴
・1999年1月1日
	初版
・1999年2月10日
	引き数の引き渡しフォーマットにバグがあったのを修正．バグのあった関数は
	これまでのサンプルプログラムでも未使用だった_pciGetIrqRoute()関数
・2000年12月1日
	Turbo C対応(引き数スタック渡方式)対応版正式公開

