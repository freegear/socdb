/*
	割り込みエントリ処理ライブラリ ヘッダファイル Ver.2.0
*/
unsigned long	_hookIRQ(unsigned int IRQ,void near *CallBackRoutine);
void		_freeIRQ(unsigned int IRQ,unsigned long OriginalVector);
unsigned int	_maskIRQ(unsigned int IRQ,unsigned int maskStatus);
