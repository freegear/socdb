割り込みエントリ処理ライブラリ(IRQFUNC)  Ver.2.0  for PC/AT


　対応コンパイラとして，LSI C-86試食版以外にTurbo Cにも対応しました．


●アーカイブファイル内容
README.TXT	アーカイブファイル内容説明(このファイル)

IRQFUNC.TXT	IRQFUNC関数説明ファイル
IRQFUNC.H	IRQFUNCヘッダファイル
IRQFUNC.ASM	IRQFUNCアセンブラソースファイル(LSI C-86用)
IRQFUNC.OBJ	IRQFUNCオブジェクトファイル(LSI C-86用)
IRQFUNC2.ASM	IRQFUNCアセンブラソースファイル(Turbo C用)
IRQFUNC2.OBJ	IRQFUNCオブジェクトファイル(Turbo C用)
MK.BAT		IRQFUNCオブジェクト生成用アセンブルバッチファイル

IRQTEST.C	IRQFUNC用サンプルソース
MKSMP.BAT	IRQFUNC用サンプルプログラム用コンパイルバッチファイル
IRQTESTL.EXE	IRQFUNC用サンプルプログラム(LSI C-86でコンパイルしたもの)
IRQTESTT.EXE	IRQFUNC用サンプルプログラム(Turbo Cでコンパイルしたもの)


●IRQFUNCについて
　アセンブルにはTurboアセンブラ 2.01を使用しています．


●IRQTESTのコンパイル方法
▲IRQTESTL.EXE(LSI C-86試食版)
　IRQTESTL.EXEはLSI C-86試食版でコンパイルしたEXEファイルです．LSI C-86試食版をコンパイルできる環境下で，カレントディレクトリに IRQTEST.C IRQFUNC.H IRQFUNC.OBJ MKSMP.BAT を置いて，そこで MKSMP.BAT を実行するとコンパイルされます．

▲IRQTESTT.EXE(Turbo C)
　IRQTESTTはTurbo C 2.0でコンパイルしたEXEファイルです．Turbo Cをコンパイルできる環境下で，カレントディレクトリに IRQTEST.C IRQFUNC.H IRQFUNC.OBJ IRQFUNC2.OBJ MKSMP.BAT を置いて，そこで MKSMP.BAT を実行するとコンパイルされます．


●IRQTESTの動作内容
　このプログラムはキーボードからの入力によって，そのキーコードを画面に表示します．キーを押したときと離したとき両方のコードが表示されます．ESCキーを押すとプログラムを終了します．
　PC/AT互換機ではキーボード割り込みがIRQ1に割り当てられているので，このサンプルプログラムでもIRQ1を使っています．まず元のIRQ1のマスク状態を保存します．
　　originalIrqMask=_maskIRQ(1,1);
この保存は，このプログラムを終了するときに状態を復帰させるために必要です．さらにこの次の行で割り込みベクタを書き換えるので，書き換え途中で割り込みが発生しても，あらぬアドレスにジャンプしてしまうことのないように，割り込みをマスクします．ここで使っているIRQの番号が1で，さらにマスクの指定も1なのでちょっと紛らわしいですが，1番目の引き数がIRQ番号で，2番目の引き数が割り込み可(0)/不可(1)のマスク設定です．
　またIRQ12の状態を保存します．
　次に，
　　originalVector=_hookIRQ(1，&keyInterrupt);
により，元のIRQ1の割り込みベクタを保存し，新しい割り込み処理としてkeyInterrupt関数に飛ぶように割り込みをフックします．新しい割り込み処理関数の名前に&がついているのでは，この関数のアドレスを示すためです．そして，
　　_maskIRQ(1,0);
により，さきほどマスクしていたIRQ1を割り込み受付可能に設定します．
　あとはIRQ1の割り込みが発生するたびに，keyInterrupt関数が実行されます．keyInterrupt関数では必要な処理をしたあと，そのまま関数を終了するだけです．
　プログラムを終了するときも手順があります．割り込み処理プログラムがこのプログラムの中にあるので，そのままプログラムを終了してメモリを解放してしまったら，次に別のプログラムがロードされた時点で割り込み処理プログラム領域が破壊されるので，プログラムが暴走してしまいます．プログラムを終了するときは割り込みベクタを解放して元に戻しておく必要があります．
　まず割り込みベクタを再度書き換えるので，
　　_maskIRQ(1,1);
によりIRQ1の割り込みをマスクします．次に，
　　_freeIRQ(1，originalVector);
により，IRQ1に割り込みベクタを解放し，保存しておいた元の割り込みベクタを設定します．そして，
　　_maskIRQ(1，originalIrqMask);
により，元のマスク状態に戻します．IRQ12の状態も戻しておきます．
　これでプログラムを終了すればOKです．



●バージョンアップ履歴
・1999年1月1日
	初版
・2000年12月1日
	Turbo C対応(引き数スタック渡方式)対応版正式公開
