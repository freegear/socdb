/*******************************************
	デバイス情報表示/ダンプ表示関数群
********************************************/

#include <stdio.h>
#include "typedef.h"
#include "iodef.h"
#include "ide_bios.h"

/* INQUIRYデータ表示 */
void ide_print_atapi_inquiry(UBYTE *buff)
{
	int i;
	printf(" Device Type : %d\n",buff[0]&31);
	printf(" ISO Version : %d\n",(buff[2]>>6)&3);
	printf(" ECMA Version : %d\n",(buff[2]>>3)&7);
	printf(" ATAPI ANSI Version : %d\n",buff[2]&3);
	printf(" ATAPI Transport Version : %d\n",(buff[3]>>4)&15);
	printf(" Response Data Format : %d\n",buff[3]&15);
	printf(" Vender Identification : '");
	for(i=8;i<=15;i++){
		printf("%c",buff[i]);
	}
	printf("'\n");
	printf(" Product Identification : '");
	for(i=16;i<=31;i++){
		printf("%c",buff[i]);
	}
	printf("'\n");
/*	printf(" Product Revision Level : %c%c%c%c\n",buff[32],buff[33],buff[34],buff[35]); */
	printf(" Product Revision Level : %02X %02X %02X %02X\n",buff[32],buff[33],buff[34],buff[35]);
}

/* ATAPIデバイス種別表示 */
void ide_print_atapi_device(int value)
{
	printf(" Word0 bit12~8  ");
	switch(value) {
		case 0:
			printf("00h Direct-access device\n");
			break;
		case 1:
			printf("01h Sequential-access device\n");
			break;
		case 2:
			printf("02h Printer device\n");
			break;
		case 3:
			printf("03h Processor device\n");
			break;
		case 4:
			printf("04h Write-once device\n");
			break;
		case 5:
			printf("05h CD-ROM/DVD-ROM device\n");
			break;
		case 6:
			printf("06h Scanner device\n");
			break;
		case 7:
			printf("07h Optical memory device\n");
			break;
		case 8:
			printf("08h Medium changer device\n");
			break;
		case 9:
			printf("09h Communications device\n");
			break;
		case 10:
		case 11:
			printf("0A-0Bh Reserved for ACS IT8 (Graphic arts pre-press devices)\n");
			break;
		case 12:
			printf("0Ch Array controller device\n");
			break;
		case 13:
			printf("0Dh Enclosure services device\n");
			break;
		case 14:
			printf("0Eh Reduced block command devices\n");
			break;
		case 15:
			printf("0Fh Optical card reader/writer device\n");
			break;
		case 0x1f:
			printf("1Fh Unknown or no device type\n");
			break;
		default:
			printf("%2Xh Reserved\n",value);
			break;
	}
}

/* モデル/ファームウェアバージョン/シリアルナンバ名表示 */
void ide_print_device_name(UWORD *buffer)
{
	int i;

	printf(" Model number : '");
	for(i=0;i<20;i++){
		printf("%c",(buffer[27+i] >> 8) & 0xff);
		printf("%c",buffer[27+i] & 0xff);
	}
	printf("'\n");
	printf(" Firmware revision : '");
	for(i=0;i<4;i++){
		printf("%c",(buffer[23+i] >> 8) & 0xff);
		printf("%c",buffer[23+i] & 0xff);
	}
	printf("'\n");
	printf(" Serial number : '");
	for(i=0;i<10;i++){
		printf("%c",(buffer[10+i] >> 8) & 0xff);
		printf("%c",buffer[10+i] & 0xff);
	}
	printf("'\n");
}

/* デバイス対応モード情報表示 */
void ide_print_device_mode(UWORD *buffer)
{
	int i;

	printf(" Major version number :");
	i=buffer[80];
	if ((i==0)||(i==0xffff)) {
		printf(" ---\n");
	} else {
		printf("\n");
		if (i&0x04) printf("  ATA-2\n");
		if (i&0x08) printf("  ATA-3\n");
		if (i&0x10) printf("  ATA/ATAPI-4\n");
		if (i&0x20) printf("  ATA/ATAPI-5\n");
		if (i&0x40) printf("  ATA/ATAPI-6?\n");
		if (i&0x80) printf("  ATA/ATAPI-7?\n");
	}

	printf(" IORDY supported :");
	if (buffer[49]&0x800) {	/* ワード49 ビット11=1 */
		printf(" yes\n");
	} else {
		printf(" no\n");
	}

	printf(" Advanced PIO modes supported :");
	if (buffer[53] & 2) {	/* ワード53 ビット1=1 ワード64～70有効 */
		i=buffer[64];
		printf("\n");
		if (i&0x01) printf("  mode 3 supported\n");
		if (i&0x02) printf("  mode 4 supported\n");
	} else {
		printf(" ---\n");
	}

	printf(" Multi word DMA supported :");
	i=buffer[63];
	if (i!=0) {
		printf("\n");
		if (i&0x01)  printf("  mode 0 supported\n");
		if (i&0x02)  printf("  mode 1 & below supported\n");
		if (i&0x04)  printf("  mode 2 & below supported\n");
		if (i&0x010) printf("  mode 0  now mode\n");
		if (i&0x020) printf("  mode 1 & below  now mode\n");
		if (i&0x040) printf("  mode 2 & below  now mode\n");
	} else {
		printf(" ---\n");
	}

	printf(" Ultra DMA supports : ");
	if (buffer[53]&0x4) {	/* ワード53 ビット2=1 ワード88が有効 */
		printf("\n");
		i=buffer[88];
		if (i&0x01) printf("  mode 0 supported\n");
		if (i&0x02) printf("  mode 1 & below supported\n");
		if (i&0x04) printf("  mode 2 & below supported\n");
		if (i&0x08) printf("  mode 3 & below supported\n");
		if (i&0x10) printf("  mode 4 & below supported\n");
		if (i&0x20) printf("  mode 5 & below supported\n");
		if (i&0x40) printf("  mode 6 & below supported\n");
		if (i&0x0100) printf("  mode 0  now mode\n");
		if (i&0x0200) printf("  mode 1 & below  now mode\n");
		if (i&0x0400) printf("  mode 2 & below  now mode\n");
		if (i&0x0800) printf("  mode 3 & below  now mode\n");
		if (i&0x1000) printf("  mode 4 & below  now mode\n");
		if (i&0x2000) printf("  mode 5 & below  now mode\n");
		if (i&0x4000) printf("  mode 6 & below  now mode\n");
	} else {
		printf(" ---\n");
	}

	printf(" Command set supported(1) : ");
	i=buffer[82];
	if ((i==0)||(i==0xffff)) {
		printf(" ---\n");
	} else {
		printf("\n");
		if (i&0x200) printf("  DEVICE RESET Command supported\n");
		if (i&0x010) printf("  PACKET Command feature set\n");
		if (i&0x008) printf("  Power Management feature set\n");
		if (i&0x004) printf("  Removable Media feature set\n");
		if (i&0x002) printf("  Security Mode feature set\n");
		if (i&0x001) printf("  SMART feature set\n");
	}

	printf(" Command set supported(2) : ");
	i=buffer[83];
	if ((i==0)||(i==0xffff)) {
		printf(" ---\n");
	} else {
		printf("\n");
		if (i&0x010) printf("  Removable Media Status Notification feature set\n");
		if (i&0x002) printf("  CFA feature set\n");
	}

	i=(buffer[127]&3);	/* ワード127 ビット1:0' */
	if (i!=0) {
		printf(" Removable Media Status Notification feature set bit1,0=%x\n",i);
	}
}

/* IDENTIFY情報表示 */
void IDE_Print_Device_Info(int device, int type, UWORD *buffer)
{
	int i;
	unsigned long l;
	UBYTE INQUIRY_buff[32];
	if (type==DEVICE_NON) {		/* 未接続 */
		printf(" non device\n");
		return;

	} else if (type&DEVICE_ATA) {	/* ATAデバイス */
		if ((buffer[0]&0x8000)==0) printf(" Word0 bit15  ATA device\n");
		if ((buffer[0]&0x80)!=0) printf(" Word0 bit7   Removable media device\n");
		if (buffer[0]==0x848a) printf(" Word0 848Ah  CFA feature set\n");
		ide_print_device_name(buffer);
		ide_print_device_mode(buffer);
		printf(" Logical default cylinders : %u\n",buffer[1]);
		printf(" Logical default heads     : %u\n",buffer[3]);
		printf(" Logical default sectors   : %u\n",buffer[6]);
		if (buffer[53]&1) {	/* ワード53 ビット0=1 ワード54～58が有効 */
			printf(" Logical cylinders : %u\n",buffer[54]);
			printf(" Logical heads     : %u\n",buffer[55]);
			printf(" Logical sectors   : %u\n",buffer[56]);
		}
		l=buffer[61];
		l=(l<<16)+buffer[60];
		printf(" Total number of user addressable sectors [LBA]  %ld\n",l);
		if (type&DEVICE_PEJECT) printf(" Media Power Eject Device\n");
		if (type&DEVICE_LOCK)   printf(" Media Lock/UnLock Device\n");
		return;

	} else if (type&DEVICE_ATAPI) {	/* ATAPIデバイス */
		if ((buffer[0]&0xc000)==0x8000)
			printf(" Word0 bit15~14 ATAPI device\n");
		if ((buffer[0]&0x80)!=0)
			printf(" Word0 bit7     Removable media device\n");
		ide_print_atapi_device((buffer[0]>>8)&0x1f);
		ide_print_device_name(buffer);
		ide_print_device_mode(buffer);
		printf(" ATAPI byte count : %u\n",buffer[126]);
		if (type&DEVICE_PEJECT) printf(" Media Power Eject Device\n");
		if (type&DEVICE_LOCK)   printf(" Media Lock/UnLock Device\n");
		printf("\nINQUIRY ... ");
		i=IDE_atapi_inquiry(device,32,(void *)&INQUIRY_buff);
		if (i==0) {
			printf("success\n");
			ide_print_atapi_inquiry((void *)&INQUIRY_buff);
		} else {
			printf("command packet error(errorcode=%d)\n",i);
		}
		return;

	} else {	/* 不明デバイス */
		printf(" unkown device\n");
		return;
	}
}

/* ATA/ATAPIデバイス制御BIOSのデバイス判定表示 */
void IDE_Print_BIOS_Info(int device, int type, UWORD *buffer)
{
	if ((type&DEVICE_ATA)||(type&DEVICE_ATAPI)) {	/* ATAまたはATAPIデバイス */
		printf("ATA/ATAPI BIOS Information\n");
		if (type&DEVICE_ATA)     printf(" ATA Device\n");
		if (type&DEVICE_ATAPI)   printf(" ATAPI Device\n");
		if (type&DEVICE_REMOV)   printf(" Removable media Drive\n");
		if (type&DEVICE_PEJECT)  printf(" Power Eject supported\n");
		if (type&DEVICE_LOCK)    printf(" Lock/UnLock supported\n");
		if (type&DEVICE_GETMeSt) printf(" GET MEDIA STATUS Command supported\n");
		if (type&DEVICE_HDD)     printf(" HDD\n");
		if (type&DEVICE_CDROM)   printf(" CD-ROM/DVD-ROM Drive\n");
		if (type&DEVICE_MO)      printf(" Magneto Optical Drive\n");
		if (type&DEVICE_LS)      printf(" SuperDisk LS-120/240 Drive\n");
		if (type&DEVICE_ZIP)     printf(" ZIP 100/250 Drive\n");
		if (type&DEVICE_CFA)     printf(" CompactFlash Card\n");
	}
}

/* IDEコマンドエラー内容表示 */
void IDE_Print_CommandError(int error, int device_type)
{
	if (error<0) {
		if (device_type&DEVICE_ATA) {	/* ATAコマンド発行エラー */
			if (error==-1) printf("Device Selection error\n");
			if (error==-2) printf("Time Out error\n");
			if (error==-3) printf("ATA Command error\n");
		} else {						/* ATAPIパケットコマンド発行エラー */
			if (error==-1) printf("Device Selection error\n");
			if (error==-2) printf("Packet Command Send error\n");
			if (error==-3) printf("Packet Command Send Time Out error\n");
			if (error==-4) printf("Packet Command Complete Time Out error\n");
		}
	} else {
		printf("Command Error (Error Reg. %02Xh)\n",error&0xff);
	}
}

/* IDEディスクアクセスエラー内容表示 */
void IDE_Print_AccessError(int error, int device_type)
{
	if (device_type&DEVICE_ATA) {	/* ATAコマンド発行エラー */
		if (error==-1) printf("Device Selection error\n");
		if (error==-2) printf("Time Out error\n");
		if (error==-3) printf("ATA Command error\n");
	} else {						/* ATAPIパケットコマンド発行エラー */
		if (error==-1) printf("Device Selection error\n");
		if (error==-2) printf("Packet Command Send error\n");
		if (error==-3) printf("Packet Command Send Time Out error\n");
		if (error==-4) printf("Packet Command Complete Time Out error\n");
	}
	if (error>0) {
		if (error&MEDIA_Wp)       printf("Write Protect\n");/* メディアがライトプロテクト状態である */
		if (error&MEDIA_NoDisk)   printf("No Disk\n");		/* メディアがない */
		if (error&MEDIA_Chg)      printf("Media Change\n");	/* メディアがチェンジされた */
		if (error&MEDIA_ChgReq)   printf("Media Change Request\n");	/* メディアチェンジが要求された */
		if (error&MEDIA_NotReady) printf("Not Ready\n");	/* ノットレディ状態 */
		if (error&MEDIA_Error)    printf("Other error\n");	/* 何らかのエラー */
	}
}

/* 16バイトに満たない場合はそこで表示終了 */
void buffer_dump_sub(char *ptr, int len)
{
	unsigned char c;
	int i,l;
	if (len>8) {
		i=8;
	} else {
		i=len;
	}
	for(l=0;l<i;l++){
		printf("%02X ",(UBYTE)*(ptr+l));
	}
	for(;l<8;l++){
		printf("   ");	/* 足りない部分を空白で埋める */
	}
	printf("- ");
	for(l=8;l<len;l++){
		printf("%02X ",(UBYTE)*(ptr+l));
	}
	for(;l<16;l++){
		printf("   ");	/* 足りない部分を空白で埋める */
	}
	printf("| ");
	for (l=0;l<len;l++) {
		c=*(ptr+l);
		if ((c>=0x20)&&(c!=0x7f)) {
			printf("%c",c);
		} else {
			printf(".");
		}
	}
}

/* ダンプ表示関数 */
void Buffer_Dump(void *buff, int len)
{
	unsigned char *ptr;
	int i,l,j;
	j=len%16;
	l=len-j;
	ptr=(unsigned char*)buff;
	printf("      +0 +1 +2 +3 +4 +5 +6 +7   +8 +9 +A +B +C +D +E +F | ---- ASCII -----");
	for(i=0;i<l-1;i=i+16){
		printf("\n%03Xh  ",i);
		buffer_dump_sub(ptr+i,16);
	}
	if (j) {
		printf("\n%03Xh  ",i);
		buffer_dump_sub(ptr+i,j);
	}
	printf("\n");
}
