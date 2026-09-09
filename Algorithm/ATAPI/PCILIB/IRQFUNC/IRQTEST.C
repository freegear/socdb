/*	割り込みサンプル IRQTEST.C	*/

#include <stdio.h>
#include <dos.h>
#include "irqfunc.h"	/* 割り込み処理エントリライブラリヘッダファイル */

unsigned char keybuf[1024];
unsigned int keyWritePoint;
unsigned int keyReadPoint;

#define inp64()         inp(0x64)

void keyInterrupt()
{
	if (inp64() & 0x01) {
		keybuf[keyWritePoint]=inp(0x60);
		keyWritePoint=(keyWritePoint+1)&1023;
	}
}

void main()
{
unsigned long int original1Vector;
unsigned long int original12Vector;
unsigned int originalIrq1Mask;
unsigned int originalIrq12Mask;
unsigned char readKeyCode;

	keyWritePoint=0;
	keyReadPoint=0;
	originalIrq1Mask=_maskIRQ(1,1);
	original1Vector=_hookIRQ(1,&keyInterrupt);
	printf("IRQ1 original mask %d\n",originalIrq1Mask);

	originalIrq12Mask=_maskIRQ(12,1);
	original12Vector=_hookIRQ(12,&keyInterrupt);
	printf("IRQ12 original mask %d\n",originalIrq12Mask);

	_maskIRQ(1,0);
	_maskIRQ(12,0);

	for(;;){
		if (keyWritePoint != keyReadPoint) {
			readKeyCode=keybuf[keyReadPoint];
			printf("%2.2x",readKeyCode);
			keyReadPoint=(keyReadPoint+1)&1023;
			if (readKeyCode==1) {
				break;
			}
		}
	}

	_maskIRQ(1,1);
	_freeIRQ(1,original1Vector);
	_maskIRQ(1,originalIrq1Mask);
	_maskIRQ(12,1);
	_freeIRQ(12,original12Vector);
	_maskIRQ(12,originalIrq12Mask);

}
