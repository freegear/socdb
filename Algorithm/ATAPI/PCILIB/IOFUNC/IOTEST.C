/*	32ビット I/Oアクセスサンプル IOTEST.C	*/

#include <stdio.h>
#include "iofunc.h"	/* 32ビットI/Oアクセスライブラリヘッダファイル */

void main(void)
{
	unsigned int	IOaddress;
	unsigned long	IOdata,i;

	IOaddress=0x300;
	IOdata=0x12345678;

	_IoWriteLong(IOaddress,IOdata);
	i=_IoReadLong(IOaddress);

	printf("I/O address %04x = %08lx\n",IOaddress,i);
}
