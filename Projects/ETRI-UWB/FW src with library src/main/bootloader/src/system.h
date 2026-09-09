#ifndef _SYSTEM_H_
#define	_SYSTEM_H_

// NFOPER  
#define CHIPSEL     (0x1Ul)<<31
#define RNBWAIT     (0x1Ul)<<29 //Option
#define AUTORDSTAT  (0x2Ul)<<29 //Option
#define CONTINUE    (0x3Ul)<<29 //Option
#define PAGE2112    (0x840Ul)<<17
#define PAGE2048    (0x800Ul)<<17
#define PAGE528     (0x210Ul)<<17
#define PAGE512     (0x200Ul)<<17
#define READDATA    (0x0Ul)<<14 //OPMODE
#define READSTATUS  (0x1Ul)<<14 //OPMODE
#define READID      (0x2Ul)<<14 //OPMODE
#define WRITEDATA   (0x3Ul)<<14 //OPMODE
//#define CELLWRITE   (0x4Ul)<<14 //OPMODE
//#define CONTINUE    (0x5ul)<<14 //OPMODE
#define NOP         (0x7Ul)<<14 //OPMODE


#define BYTE        0 //TrasnSize
#define HALFWORD    1 //TransSize
#define WORD        2 //TransSize


// NFCONF
#define TADLTWB     (0xfUl)<<9
#define TACLS       (0x2Ul)<<6
#define TRWLP       (0x2Ul)<<3
#define TRWHP       (0x2Ul)<<0

// NFCTRL
#define NFCTRLRST   (0x1Ul)<<13
#define FIFOLEVEL   (0x7Ul)<<10
#define ECC512EN    (0x1Ul)<<8 // 
#define AUTOECCWR   (0x1Ul)<<7
#define DMAEN       (0x1Ul)<<6
#define WRENDINTEN  (0x1Ul)<<5
#define RDENDINTEN  (0x1Ul)<<4
#define ECCERRINTEN (0x1Ul)<<3
#define FIFOINTEN   (0x1Ul)<<2
#define RNBINTEN1   (0x1Ul)<<1
#define RNBINTEN0   (0x1Ul)<<0

// NFSTAT
#define NFSTATVALID (0x1Ul)<<24
#define WREND       (0x1Ul)<<7
#define RDEND       (0x1Ul)<<6
#define WRFIFOREADY (0x1Ul)<<5
#define RDFIFOREADY (0x1Ul)<<4
#define RNBDETECT1  (0x1Ul)<<3
#define RNBDETECT0  (0x1Ul)<<2


#define PAGEWRCMD1  0x80
#define PAGEWRCMD2  0x10
#define PAGERDCMD1  0x00
#define PAGERDCMD2  0x30
#define RDIDCMD     0x90
#define RDSTATCMD   0x70
#define RESETCMD    0xff
#define BERASECMD1  0x60
#define BERASECMD2  0xd0

// MICRON
#define CACHERDCMD1 0x31
#define CACHERDCMD2 0x3f

#define CACHEWRCMD1 0x80
#define CACHEWRCMD2 0x15

#define DPRINTF(fmt, args...)	UART_printf(fmt, ##args)

//DMAC
#define NANDCHANNEL     1
#define SRCINC          1
#define NOTSRCINC       0
#define DESTINC         1
#define NOTDESTINC      0
    //Trans Size
#define TRANS32BYTE     5
#define TRANS16BYTE     4
#define TRANS8BYTE      3
#define TRANS4BYTE      2
#define TRANS2BYTE      1
#define TRANS1BYTE      0
    //width
#define WIDTHWORD       2
    //Trans Length
#define TLEN2048       2048
#define NFDATA_ADDR     NFCTRL_BASEADDR+0x04


#define RDMOD_ERASE     0
#define RDMOD_READ      1

#define WRMOD_NORMAL    0
#define WRMOD_ECCTEST   1

#endif