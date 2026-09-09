/*----------------------------------------------------------
	File Name   : apinand.c 
	Description : MMCSD test code
	Created by  : SHMT SoC Team
-----------------------------------------------------------*/

/*/////////////////////////////////////////////////////////
        INCLUDE
///////////////////////////////////////////////////////// */
#include "sysinc.h"
#include "Commonmacro.h"
#include "lib.h"
#include "irq.h"
//#include "mmcsd.h"
#include "global.h"
#include "dmac.h"
#include "uart.h"


/*/////////////////////////////////////////////////////////
        REGISTER CONFIGURATION
///////////////////////////////////////////////////////// */

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
#define TACLS       (0x1Ul)<<6
#define TRWLP       (0x1Ul)<<3
#define TRWHP       (0x1Ul)<<0

// NFCTRL
#define NFCTRLRST   (0x1Ul)<<13
#define FIFOLEVEL   (0x7Ul)<<10
//#define FIFOLEVEL   (0x0Ul)<<10
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
#define NFSTATVALID ((0x1Ul)<<24)
#define WREND       ((0x1Ul)<<7)
#define RDEND       ((0x1Ul)<<6)
#define WRFIFOREADY ((0x1Ul)<<5)
#define RDFIFOREADY ((0x1Ul)<<4)
#define RNBDETECT1  ((0x1Ul)<<3)
#define RNBDETECT0  ((0x1Ul)<<2)


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

//#define DPRINTF(fmt, args...)	UartPrintf(fmt, ##args)
//#define DPRINTF(fmt, args...)	UartPrintf(fmt, ##args)

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
#define TLEN4096       4096 
#define TLEN2048       2048
#define TLEN1024       1024 
#define TLEN512        512 
#define NFDATA_ADDR     NFCTRL_BASEADDR+0x04

//
#define IRQ_NAND        19


#define RDMOD_ERASE     0
#define RDMOD_READ      1

#define WRMOD_NORMAL    0
#define WRMOD_ECCTEST   1
/*/////////////////////////////////////////////////////////
        FUNCTION DECLARATION
///////////////////////////////////////////////////////// */
void Nand_test(void);
void Reset(void);
void NandInit(void);
void IdRead(smtUint8 transSize);
void BlockErase(smtUint16 blockAddr,smtUint16 pageAddr);

void CacheRead(smtUint16 blockAddr,smtUint16 pageAddr,smtUint16 colAddr,smtUint16 readSize,smtUint8 transSize);

void PageRead(smtUint16 blockAddr,smtUint16 pageAddr,smtUint16 colAddr,smtUint16 readSize,smtUint8 transSize);
void PageWrite(smtUint16 blockAddr,smtUint16 pageAddr,smtUint16 colAddr,smtUint32 writeSize,smtUint8 transSize);
void TwoPlaneBlockErase(smtUint16 blockAddr0,smtUint16 pageAddr0,smtUint16 blockAddr1,smtUint16 pageAddr1);
void AutoEccWrTest(void);
void EccTest(void);   
void Correctable(smtUint32 src,smtUint8 bit,smtUint8 sectNum);

void DataRead(smtUint16 readSize,smtUint8 transSize,smtUint8 readMode);
void DataWrite(smtUint16 writeSize,smtUint8 transSize,smtUint8 writeMod);

void DmaRead(smtUint16 blockAddr,smtUint16 pageAddr,smtUint16 colAddr,smtUint16 readSize);
void DmaWrite(smtUint16 blockAddr,smtUint16 pageAddr,smtUint16 colAddr,smtUint16 writeSize);

void SingleOperation(void);
void ReadStatus(void);

static void NandIntHandler(smtUint32 IRQ);

extern void DMACEnable(smtUint8 channel);
extern void DMACDisable(smtUint8 channel);
extern void DMACNoDescrp(smtUint8 channel, smtUint32 SrcAddr, smtBoolean SrcIncrease, smtUint8 SWidth,
	      	smtUint32 DestAddr,  smtBoolean DstIncrease, smtUint8 DWidth, smtUint8 TransSize, smtUint16 TotalSize);

/*/////////////////////////////////////////////////////////
        VARIABLE DECLARATION
///////////////////////////////////////////////////////// */
smtUint32 readBuf[2112];
smtUint32 bufCnt=0,rnum=0,wnum=0;
smtUint8 level;
/*/////////////////////////////////////////////////////////
        FUNCTION
///////////////////////////////////////////////////////// */
#define ECC256 1
#define PAGESIZE 1 //0 : 512page 1 : 2048page
#define ERR2BIT 1 //
#define TWO8BITNAND 0

void NandTest()
{
    int i;
	GPIOWrite(0x2222);
    

    NandInit();
//*** Function sim 용     
//    SingleOperation();
//*******************

//    Reset();
//    IdRead(BYTE);
//    FullErase();

    BlockErase(0,0);//(BlockAddr,PageAddr);
    //SingleOperation();

    //AutoEccWrTest();
    //EccTest();   
    NandInit();
 

    DPRINTF("NFCONF %x \n",SMT_READ(NFCONF));
    if(PAGESIZE==0){ //512 page test
        PageRead(0,3,0,512,WORD);//(BlockAddr,PageAddr,ColumnAddr,WriteSize,TransSize)
        DataRead(512,WORD,RDMOD_ERASE);

        PageWrite(0,3,0,528,WORD);
        DataWrite(528,WORD,WRMOD_NORMAL);

        PageRead(0,3,0,512,WORD);
        DataRead(512,WORD,RDMOD_READ);
    
        //while(1);
        BlockErase(0,0);//(BlockAddr,PageAddr);
        PageRead(0,1,0,512,WORD);//(BlockAddr,PageAddr,ColumnAddr,WriteSize,TransSize)
        DataRead(512,WORD,RDMOD_ERASE);
        //while(1);
/*
        DmaWrite(0,2,0,512);//(BlockAddr,PageAddr,ColumnAddr,WriteValue,WriteSize)
        DmaRead(0,2,0,512);//(BlockAddr,PageAddr,ColumnAddr,ReadSize)
        
        RequestIRQ(IRQ_NAND,NandIntHandler);
        Enable_IRQ();
        SMT_WRITE(NFCTRL,0x7<<10|RNBINTEN0|WRENDINTEN|RDENDINTEN|FIFOINTEN);
        level=7;

        PageWrite(0,5,0,512,WORD);
        PageRead(0,5,0,512,WORD);

        while((SMT_READ(NFSTAT)&RDEND!=RDEND));
        SMT_WRITE(NFSTAT,RDEND);
        DPRINTF("512 Page Test End!\n");
*/        
    }
    else{ //2048 page Test
        PageRead(0,3,0,2112,WORD);
        DataRead(2112,WORD,RDMOD_ERASE);
       
        PageWrite(0,3,0,2112,WORD);
        DataWrite(2112,WORD,WRMOD_NORMAL);

        PageRead(0,3,0,2112,WORD);
        DataRead(2112,WORD,RDMOD_READ);

        BlockErase(0,0);//(BlockAddr,PageAddr);
        PageRead(0,1,0,2112,WORD);//(BlockAddr,PageAddr,ColumnAddr,WriteSize,TransSize)
        DataRead(2112,WORD,RDMOD_ERASE);
/*
        DmaWrite(0,2,0,2048);//(BlockAddr,PageAddr,ColumnAddr,WriteValue,WriteSize)
        DmaRead(0,2,0,2048);//(BlockAddr,PageAddr,ColumnAddr,ReadSize)
        
        RequestIRQ(IRQ_NAND,NandIntHandler);
        Enable_IRQ();
        SMT_WRITE(NFCTRL,0x7<<10|RNBINTEN0|WRENDINTEN|RDENDINTEN|FIFOINTEN);
        level=7;

        PageWrite(0,5,0,2112,WORD);
        PageRead(0,5,0,2112,WORD);

        while((SMT_READ(NFSTAT)&RDEND!=RDEND));
        SMT_WRITE(NFSTAT,RDEND);
        DPRINTF("2048 page Test End!\n");
*/        
    }

//    CacheRead(0,0,0,2112,WORD);// MICRON simulation전용
//    TwoPlaneBlockErase(0,0,1,0);//(BlockAddr0,PageAddr0,BlockAddr1,PageAddr1)



    
}
/*-----------------------------------------------------------------------
    Function name   : ReadStatus()
    Prototype       : void ReadStatus(void)
    Return          : 
    Argument        :
    Comments        : 
-----------------------------------------------------------------------*/ 
void ReadStatus()
{
    SMT_WRITE(NFOPER,READSTATUS|(0x1<<8)|0x41);
    SMT_WRITE(NFOPER,0x30<<24|0x30<<16|0x30<<8|0x70);

    while((SMT_READ(NFSTAT)&NFSTATVALID)!=NFSTATVALID);
    DPRINTF("Nand flash status %x\n",NFSTAT);   
    SMT_WRITE(NFSTAT,NFSTATVALID);

}
/*-----------------------------------------------------------------------
    Function name   : SingleOperation()
    Prototype       : void SingleOperation(void)
    Return          : 
    Argument        :
    Comments        : Function Simultion 용
-----------------------------------------------------------------------*/ 
void SingleOperation(void)
{
    smtUint32 readData;
    smtUint16 readSize;
    smtUint8  transSize;

    readSize=2112;
    transSize=2;

    SMT_WRITE(NFSTAT,SMT_READ(NFSTAT));
    SMT_WRITE(NFOPER,readSize<<17|NOP|transSize<<12|(0x6<<8)|0x41);
    SMT_WRITE(NFOPER,0x00<<24|0x00<<16|0x00<<8|0x80);
    SMT_WRITE(NFOPER,0x0);
    SMT_WRITE(NFOPER,readSize<<17|WRITEDATA|transSize<<12|(0x0<<8)|0x41);
    DataWrite(2112,WORD,WRMOD_NORMAL);
    SMT_WRITE(NFOPER,readSize<<17|RNBWAIT|NOP|transSize<<12|(0x1<<8)|0x41);
    SMT_WRITE(NFOPER,0x00<<24|0x00<<16|0x00<<8|0x10);
    
    
    // Only One Cmd
    SMT_WRITE(NFOPER,readSize<<17|RNBWAIT|NOP|transSize<<12|(0x7<<8)|0x41);
    SMT_WRITE(NFOPER,0x00<<24|0x00<<16|0x00<<8|0x00);
    SMT_WRITE(NFOPER,PAGERDCMD2<<16);

    SMT_WRITE(NFOPER,readSize<<17|READDATA|transSize<<12|(0x0<<8)|0x41);
    DataRead(2112,WORD,RDMOD_ERASE);





    /*
    readData=SMT_READ(NFCTRL);
    SMT_WRITE(NFCTRL,0xffffffff); // Controller Reset
    SMT_WRITE(NFCTRL,readData);
    */
}
/*-----------------------------------------------------------------------
    Function name   : CacheRead()
    Prototype       : void CacheRead(smtUint16 blockAddr,smtUint16 pageAddr,smtUint16 colAddr,
                                     smtUint16 readSize,smtUint8 transSize);

    Return          : 
    Argument        :
    Comments        : Micron Simultion 용임
-----------------------------------------------------------------------*/ 
void CacheRead(smtUint16 blockAddr,smtUint16 pageAddr,smtUint16 colAddr,smtUint16 readSize,smtUint8 transSize)
{
    int i,j;
    smtUint8 addr1;
    smtUint8 addr2;
    smtUint8 addr3;
    smtUint8 addr4;
    smtUint8 addr5;
    
    addr1 = colAddr & 0xff;
    addr2 = (colAddr>>8) & 0xf;
    addr3 = (pageAddr & 0x3f) | ((blockAddr & 0x3)<<6);
    addr4 = (blockAddr>>2)&0xff;
    addr5 = (blockAddr>>10)&0xff;

    SMT_WRITE(NFOPER,RNBWAIT|readSize<<17|NOP|transSize<<12|(0x7<<8)|0x41);
    SMT_WRITE(NFOPER,addr3<<24|addr2<<16|addr1<<8|PAGERDCMD1);
    SMT_WRITE(NFOPER,PAGERDCMD2<<16|addr5<<8|addr4);

    SMT_WRITE(NFOPER,readSize<<17|READDATA|transSize<<12|(0x1<<8)|0x41);
    SMT_WRITE(NFOPER,CACHERDCMD1);
    DataRead(2112,WORD,RDMOD_READ);

    SMT_WRITE(NFOPER,readSize<<17|READDATA|transSize<<12|(0x1<<8)|0x41);
    SMT_WRITE(NFOPER,CACHERDCMD2);
    DataRead(2112,WORD,RDMOD_READ);

}

/*-----------------------------------------------------------------------
    Function name   : EccTest()
    Prototype       : void EccTest();
    Return          : 
    Argument        :
    Comments        : ECC Funtion Test
-----------------------------------------------------------------------*/ 

void EccTest()
{
    smtUint32 writeLEcc_a0,writeLEcc_a1,writeLEcc_a2,writeLEcc_a3;
    smtUint32 writeLEcc_b0,writeLEcc_b1,writeLEcc_b2,writeLEcc_b3;
    smtUint32 writeHEcc_a0,writeHEcc_a1,writeHEcc_a2,writeHEcc_a3;
    smtUint32 writeHEcc_b0,writeHEcc_b1,writeHEcc_b2,writeHEcc_b3;

    smtUint32 readLEcc_a0,readLEcc_a1,readLEcc_a2,readLEcc_a3;
    smtUint32 readLEcc_b0,readLEcc_b1,readLEcc_b2,readLEcc_b3;
    smtUint32 readHEcc_a0,readHEcc_a1,readHEcc_a2,readHEcc_a3;
    smtUint32 readHEcc_b0,readHEcc_b1,readHEcc_b2,readHEcc_b3;

    smtUint32 calcLEcc_a0,calcLEcc_a1,calcLEcc_a2,calcLEcc_a3;
    smtUint32 calcLEcc_b0,calcLEcc_b1,calcLEcc_b2,calcLEcc_b3;
    smtUint32 calcHEcc_a0,calcHEcc_a1,calcHEcc_a2,calcHEcc_a3;
    smtUint32 calcHEcc_b0,calcHEcc_b1,calcHEcc_b2,calcHEcc_b3;

    smtUint32 writeSEcc0,writeSEcc1,writeSEcc2,writeSEcc3;
    smtUint32 writeSEcc4,writeSEcc5,writeSEcc6,writeSEcc7;
    smtUint16 readSEcc0,readSEcc1,readSEcc2,readSEcc3;
    smtUint16 readSEcc4,readSEcc5,readSEcc6,readSEcc7;
    smtUint16 calcSEcc0,calcSEcc1,calcSEcc2,calcSEcc3;
    smtUint16 calcSEcc4,calcSEcc5,calcSEcc6,calcSEcc7;

    if(ECC256){ SMT_WRITE(NFCTRL,FIFOLEVEL|AUTOECCWR);}
    else      { SMT_WRITE(NFCTRL,FIFOLEVEL|ECC512EN|AUTOECCWR);}

    if(PAGESIZE){
        PageWrite(0,1,0,2112,HALFWORD);
        DataWrite(2112,HALFWORD,WRMOD_NORMAL);
    }
    else{
        PageWrite(0,1,0,528,HALFWORD);
        DataWrite(528,HALFWORD,WRMOD_NORMAL);
    }
 //   while(1);
    if(ECC256){ //256ECC
        writeLEcc_a0  = SMT_READ(ECCSECTOR0);  writeLEcc_b0  = SMT_READ(ECCSECTOR1);
        writeLEcc_a1  = SMT_READ(ECCSECTOR2);  writeLEcc_b1  = SMT_READ(ECCSECTOR3);
        writeLEcc_a2  = SMT_READ(ECCSECTOR4);  writeLEcc_b2  = SMT_READ(ECCSECTOR5);
        writeLEcc_a3  = SMT_READ(ECCSECTOR6);  writeLEcc_b3  = SMT_READ(ECCSECTOR7);
        writeHEcc_a0  = SMT_READ(ECCSECTOR8);  writeHEcc_b0  = SMT_READ(ECCSECTOR9);
        writeHEcc_a1  = SMT_READ(ECCSECTOR10); writeHEcc_b1  = SMT_READ(ECCSECTOR11);
        writeHEcc_a2  = SMT_READ(ECCSECTOR12); writeHEcc_b2  = SMT_READ(ECCSECTOR13);
        writeHEcc_a3  = SMT_READ(ECCSECTOR14); writeHEcc_b3  = SMT_READ(ECCSECTOR15);
    }
    else{ //512ECC
        writeLEcc_a0  = SMT_READ(ECCSECTOR0); 
        writeLEcc_a1  = SMT_READ(ECCSECTOR2); 
        writeLEcc_a2  = SMT_READ(ECCSECTOR4); 
        writeLEcc_a3  = SMT_READ(ECCSECTOR6); 
    }

    writeSEcc0 = SMT_READ(SECCSECTOR0);
    writeSEcc1 = SMT_READ(SECCSECTOR1);
    writeSEcc2 = SMT_READ(SECCSECTOR2);
    writeSEcc3 = SMT_READ(SECCSECTOR3);
    writeSEcc4 = SMT_READ(SECCSECTOR4);
    writeSEcc5 = SMT_READ(SECCSECTOR5);
    writeSEcc6 = SMT_READ(SECCSECTOR6);
    writeSEcc7 = SMT_READ(SECCSECTOR7);

    if(PAGESIZE){
        PageWrite(0,2,0,2112,HALFWORD);
        DataWrite(2112,HALFWORD,WRMOD_ECCTEST);
    }
    else{
        PageWrite(0,2,0,528,HALFWORD);
        DataWrite(528,HALFWORD,WRMOD_ECCTEST);
    }

    if(ECC256){
        readLEcc_a0  = SMT_READ(ECCSECTOR0);  readLEcc_b0  = SMT_READ(ECCSECTOR1);
        readLEcc_a1  = SMT_READ(ECCSECTOR2);  readLEcc_b1  = SMT_READ(ECCSECTOR3);
        readLEcc_a2  = SMT_READ(ECCSECTOR4);  readLEcc_b2  = SMT_READ(ECCSECTOR5);
        readLEcc_a3  = SMT_READ(ECCSECTOR6);  readLEcc_b3  = SMT_READ(ECCSECTOR7);
        readHEcc_a0  = SMT_READ(ECCSECTOR8);  readHEcc_b0  = SMT_READ(ECCSECTOR9);
        readHEcc_a1  = SMT_READ(ECCSECTOR10); readHEcc_b1  = SMT_READ(ECCSECTOR11);
        readHEcc_a2  = SMT_READ(ECCSECTOR12); readHEcc_b2  = SMT_READ(ECCSECTOR13);
        readHEcc_a3  = SMT_READ(ECCSECTOR14); readHEcc_b3  = SMT_READ(ECCSECTOR15);
    }
    else{ //512ECC
        readLEcc_a0  = SMT_READ(ECCSECTOR0); 
        readLEcc_a1  = SMT_READ(ECCSECTOR2); 
        readLEcc_a2  = SMT_READ(ECCSECTOR4); 
        readLEcc_a3  = SMT_READ(ECCSECTOR6); 
    }
    readSEcc0 = SMT_READ(SECCSECTOR0);
    readSEcc1 = SMT_READ(SECCSECTOR1);
    readSEcc2 = SMT_READ(SECCSECTOR2);
    readSEcc3 = SMT_READ(SECCSECTOR3);
    readSEcc4 = SMT_READ(SECCSECTOR4);
    readSEcc5 = SMT_READ(SECCSECTOR5);
    readSEcc6 = SMT_READ(SECCSECTOR6);
    readSEcc7 = SMT_READ(SECCSECTOR7);
 
    calcLEcc_a0  = writeLEcc_a0 ^ readLEcc_a0; calcHEcc_a0  = writeHEcc_a0 ^ readHEcc_a0;
    calcLEcc_a1  = writeLEcc_a1 ^ readLEcc_a1; calcHEcc_a1  = writeHEcc_a1 ^ readHEcc_a1;
    calcLEcc_a2  = writeLEcc_a2 ^ readLEcc_a2; calcHEcc_a2  = writeHEcc_a2 ^ readHEcc_a2;
    calcLEcc_a3  = writeLEcc_a3 ^ readLEcc_a3; calcHEcc_a3  = writeHEcc_a3 ^ readHEcc_a3;

    calcLEcc_b0  = writeLEcc_b0 ^ readLEcc_b0; calcHEcc_b0  = writeHEcc_b0 ^ readHEcc_b0;
    calcLEcc_b1  = writeLEcc_b1 ^ readLEcc_b1; calcHEcc_b1  = writeHEcc_b1 ^ readHEcc_b1;
    calcLEcc_b2  = writeLEcc_b2 ^ readLEcc_b2; calcHEcc_b2  = writeHEcc_b2 ^ readHEcc_b2;
    calcLEcc_b3  = writeLEcc_b3 ^ readLEcc_b3; calcHEcc_b3  = writeHEcc_b3 ^ readHEcc_b3;

    calcSEcc0 = writeSEcc0 ^ readSEcc0;
    calcSEcc1 = writeSEcc1 ^ readSEcc1;
    calcSEcc2 = writeSEcc2 ^ readSEcc2;
    calcSEcc3 = writeSEcc3 ^ readSEcc3;
    calcSEcc4 = writeSEcc4 ^ readSEcc4;
    calcSEcc5 = writeSEcc5 ^ readSEcc5;
    calcSEcc6 = writeSEcc6 ^ readSEcc6;
    calcSEcc7 = writeSEcc7 ^ readSEcc7;

    DPRINTF("\n*****ECC TEST*****\n");   

    DPRINTF("writeLEcc_a0 [%8x] XOR readLEcc_a0 [%8x] = [%8x]\n",writeLEcc_a0,readLEcc_a0,calcLEcc_a0);   
    DPRINTF("writeLEcc_a1 [%8x] XOR readLEcc_a1 [%8x] = [%8x]\n",writeLEcc_a1,readLEcc_a1,calcLEcc_a1);   
    DPRINTF("writeLEcc_a2 [%8x] XOR readLEcc_a2 [%8x] = [%8x]\n",writeLEcc_a2,readLEcc_a2,calcLEcc_a2);   
    DPRINTF("writeLEcc_a3 [%8x] XOR readLEcc_a3 [%8x] = [%8x]\n",writeLEcc_a3,readLEcc_a3,calcLEcc_a3);   

    DPRINTF("writeLEcc_b0 [%8x] XOR readLEcc_b0 [%8x] = [%8x]\n",writeLEcc_b0,readLEcc_b0,calcLEcc_b0);   
    DPRINTF("writeLEcc_b1 [%8x] XOR readLEcc_b1 [%8x] = [%8x]\n",writeLEcc_b1,readLEcc_b1,calcLEcc_b1);   
    DPRINTF("writeLEcc_b2 [%8x] XOR readLEcc_b2 [%8x] = [%8x]\n",writeLEcc_b2,readLEcc_b2,calcLEcc_b2);   
    DPRINTF("writeLEcc_b3 [%8x] XOR readLEcc_b3 [%8x] = [%8x]\n",writeLEcc_b3,readLEcc_b3,calcLEcc_b3);   

    DPRINTF("writeHEcc_a0 [%8x] XOR readHEcc_a0 [%8x] = [%8x]\n",writeHEcc_a0,readHEcc_a0,calcHEcc_a0);   
    DPRINTF("writeHEcc_a1 [%8x] XOR readHEcc_a1 [%8x] = [%8x]\n",writeHEcc_a1,readHEcc_a1,calcHEcc_a1);   
    DPRINTF("writeHEcc_a2 [%8x] XOR readHEcc_a2 [%8x] = [%8x]\n",writeHEcc_a2,readHEcc_a2,calcHEcc_a2);   
    DPRINTF("writeHEcc_a3 [%8x] XOR readHEcc_a3 [%8x] = [%8x]\n",writeHEcc_a3,readHEcc_a3,calcHEcc_a3);   

    DPRINTF("writeHEcc_b0 [%8x] XOR readHEcc_b0 [%8x] = [%8x]\n",writeHEcc_b0,readHEcc_b0,calcHEcc_b0);   
    DPRINTF("writeHEcc_b1 [%8x] XOR readHEcc_b1 [%8x] = [%8x]\n",writeHEcc_b1,readHEcc_b1,calcHEcc_b1);   
    DPRINTF("writeHEcc_b2 [%8x] XOR readHEcc_b2 [%8x] = [%8x]\n",writeHEcc_b2,readHEcc_b2,calcHEcc_b2);   
    DPRINTF("writeHEcc_b3 [%8x] XOR readHEcc_b3 [%8x] = [%8x]\n",writeHEcc_b3,readHEcc_b3,calcHEcc_b3);   

    DPRINTF("  writeSEcc0 [%8x] XOR   readSEcc0 [%8x] = [%8x]\n",writeSEcc0,readSEcc0,calcSEcc0);   
    DPRINTF("  writeSEcc1 [%8x] XOR   readSEcc1 [%8x] = [%8x]\n",writeSEcc1,readSEcc1,calcSEcc1);   
    DPRINTF("  writeSEcc2 [%8x] XOR   readSEcc2 [%8x] = [%8x]\n",writeSEcc2,readSEcc2,calcSEcc2);   
    DPRINTF("  writeSEcc3 [%8x] XOR   readSEcc3 [%8x] = [%8x]\n",writeSEcc3,readSEcc3,calcSEcc3);   
    DPRINTF("  writeSEcc4 [%8x] XOR   readSEcc4 [%8x] = [%8x]\n",writeSEcc4,readSEcc4,calcSEcc4);   
    DPRINTF("  writeSEcc5 [%8x] XOR   readSEcc5 [%8x] = [%8x]\n",writeSEcc5,readSEcc5,calcSEcc5);   
    DPRINTF("  writeSEcc6 [%8x] XOR   readSEcc6 [%8x] = [%8x]\n",writeSEcc6,readSEcc6,calcSEcc6);   
    DPRINTF("  writeSEcc7 [%8x] XOR   readSEcc7 [%8x] = [%8x]\n",writeSEcc7,readSEcc7,calcSEcc7);   

    calcSEcc0 = (calcSEcc0 & 0xff) | (calcSEcc0 & 0x300);
    calcSEcc1 = (calcSEcc1 & 0xff) | (calcSEcc1 & 0x300);
    calcSEcc2 = (calcSEcc2 & 0xff) | (calcSEcc2 & 0x300);
    calcSEcc3 = (calcSEcc3 & 0xff) | (calcSEcc3 & 0x300);
/*
    DPRINTF("calcSEcc [%x] \n",calcSEcc0);   
    DPRINTF("calcSEcc [%x] \n",calcSEcc1);   
    DPRINTF("calcSEcc [%x] \n",calcSEcc2);   
    DPRINTF("calcSEcc [%x] \n",calcSEcc3);   
*/
    if(PAGESIZE==0){ /////////// 512 Page size ////////////
        if(ECC256==0){ // 512 ECC ENABLE
            if(calcLEcc_a0!=0) Correctable(calcLEcc_a0,24,0);                else DPRINTF("NO ERROR \n");
            if(calcHEcc_a0!=0 && TWO8BITNAND) Correctable(calcHEcc_a0,24,8); else DPRINTF("NO ERROR \n");
        }else{ // 256 ECC ENABLE
            if(calcLEcc_a0!=0) Correctable(calcLEcc_a0,24,0);                else DPRINTF("NO ERROR \n");
            if(calcLEcc_b0!=0) Correctable(calcLEcc_b0,24,1);                else DPRINTF("NO ERROR \n");
            if(calcHEcc_a0!=0 && TWO8BITNAND) Correctable(calcHEcc_a0,24,8); else DPRINTF("NO ERROR \n");
            if(calcHEcc_b0!=0 && TWO8BITNAND) Correctable(calcHEcc_b0,24,9); else DPRINTF("NO ERROR \n");
        }
    }
    else{ /////////// 2048 Page size ////////////
        if(ECC256==0){  // 512 ECC ENABLE
            if(TWO8BITNAND==0){
                if(calcLEcc_a0!=0) Correctable(calcLEcc_a0,24,0);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_a1!=0) Correctable(calcLEcc_a1,24,1);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_a2!=0) Correctable(calcLEcc_a2,24,2);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_a3!=0) Correctable(calcLEcc_a3,24,3);  else DPRINTF("NO ERROR \n");
            }else{
                if(calcLEcc_a0!=0) Correctable(calcLEcc_a0,24,0);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_a1!=0) Correctable(calcLEcc_a1,24,2);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_a2!=0) Correctable(calcLEcc_a2,24,4);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_a3!=0) Correctable(calcLEcc_a3,24,6);  else DPRINTF("NO ERROR \n");
                if(calcHEcc_a0!=0) Correctable(calcHEcc_a0,24,8);  else DPRINTF("NO ERROR \n");
                if(calcHEcc_a1!=0) Correctable(calcHEcc_a1,24,7);  else DPRINTF("NO ERROR \n");
                if(calcHEcc_a2!=0) Correctable(calcHEcc_a2,24,7);  else DPRINTF("NO ERROR \n");
                if(calcHEcc_a3!=0) Correctable(calcHEcc_a3,24,7);  else DPRINTF("NO ERROR \n");
            }
        }else{ // 256 ECC ENABLE
            if(TWO8BITNAND==0){
                if(calcLEcc_a0!=0) Correctable(calcLEcc_a0,24,0);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_b0!=0) Correctable(calcLEcc_b0,24,1);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_a1!=0) Correctable(calcLEcc_a1,24,2);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_b1!=0) Correctable(calcLEcc_b1,24,3);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_a2!=0) Correctable(calcLEcc_a2,24,4);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_b2!=0) Correctable(calcLEcc_b2,24,5);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_a3!=0) Correctable(calcLEcc_a3,24,6);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_b3!=0) Correctable(calcLEcc_b3,24,7);  else DPRINTF("NO ERROR \n");
            }else{
                if(calcLEcc_a0!=0) Correctable(calcLEcc_a0,24,0);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_b0!=0) Correctable(calcLEcc_b0,24,1);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_a1!=0) Correctable(calcLEcc_a1,24,2);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_b1!=0) Correctable(calcLEcc_b1,24,3);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_a2!=0) Correctable(calcLEcc_a2,24,4);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_b2!=0) Correctable(calcLEcc_b2,24,5);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_a3!=0) Correctable(calcLEcc_a3,24,6);  else DPRINTF("NO ERROR \n");
                if(calcLEcc_b3!=0) Correctable(calcLEcc_b3,24,7);  else DPRINTF("NO ERROR \n");
                if(calcHEcc_a0!=0) Correctable(calcHEcc_a0,24,8);  else DPRINTF("NO ERROR \n");
                if(calcHEcc_b0!=0) Correctable(calcHEcc_b0,24,9);  else DPRINTF("NO ERROR \n");
                if(calcHEcc_a1!=0) Correctable(calcHEcc_a1,24,10); else DPRINTF("NO ERROR \n");
                if(calcHEcc_b1!=0) Correctable(calcHEcc_b1,24,11); else DPRINTF("NO ERROR \n");
                if(calcHEcc_a2!=0) Correctable(calcHEcc_a2,24,12); else DPRINTF("NO ERROR \n");
                if(calcHEcc_b2!=0) Correctable(calcHEcc_b2,24,13); else DPRINTF("NO ERROR \n");
                if(calcHEcc_a3!=0) Correctable(calcHEcc_a3,24,14); else DPRINTF("NO ERROR \n");
                if(calcHEcc_b3!=0) Correctable(calcHEcc_b3,24,15); else DPRINTF("NO ERROR \n");
            }
        }
    }
    if(calcSEcc0!=0) Correctable(calcSEcc0,16,0); else DPRINTF("NO ERROR \n");
    if(calcSEcc1!=0) Correctable(calcSEcc1,16,1); else DPRINTF("NO ERROR \n");
    if(calcSEcc2!=0) Correctable(calcSEcc2,16,2); else DPRINTF("NO ERROR \n");
    if(calcSEcc3!=0) Correctable(calcSEcc3,16,3); else DPRINTF("NO ERROR \n");
    
}

/*-----------------------------------------------------------------------
    Function name   : Correctable()
    Prototype       : void Correctable(smtUint32 src);
    Return          : bit Xor result
    Argument        : src
    Comments        : bit Xor function
-----------------------------------------------------------------------*/ 
void Correctable(smtUint32 src,smtUint8 bitSize,smtUint8 sectNum)
{
    int i,size;
    smtUint32 bitXor,result,srcBack;
    smtUint16 byteNum;
    smtUint8 bitNum;
    
    srcBack = src;
    result = 0;
    
    if(bitSize==24) size=12;
    else size=5;

//    DPRINTF("src=[%x] \n",src);   

    for(i=0;i<size;i++){
        bitXor = src;
//        DPRINTF("bitXor=[%x] \n",bitXor);   
        bitXor ^= src>>1;
        src = src>>2;
        result = result | ((bitXor&0x1)<<i);
//        DPRINTF("bitXor=[%x],result[%x] \n",bitXor,result);   
    }
    DPRINTF("Src[%x] \n",srcBack); 

    if(ECC256){
        if(bitSize==24){
            if(result==0xeff){
                byteNum = ( (srcBack&0x8000  )>>8  | (srcBack&0x2000)>>7   |
                            (srcBack&0x800   )>>6  | (srcBack&0x200 )>>5   |
                            (srcBack&0x80    )>>4  | (srcBack&0x20  )>>3   |
                            (srcBack&0x8     )>>2  | (srcBack&0x2   )>>1
                           );
                bitNum = ( (srcBack&0x800000)>>21 | (srcBack&0x200000)>>20 | (srcBack&0x80000)>>19 ); 
                DPRINTF("Main Area sect [%d]  [%3d]byte ,[%3d]bit Error\n",sectNum,byteNum,bitNum);   
            }
            else DPRINTF(" Not Correction  \n");
        }
        else{
            if(result==0x1f){
                byteNum = ( (srcBack&0x8)>>2 | (srcBack&0x2 )>>1 );
                bitNum = ( (srcBack&0x200)>>7 | (srcBack&0x80)>>6 | (srcBack&0x20)>>5 ); 
                DPRINTF("Spare Area [%3d]byte ,[%3d]bit Error\n",byteNum,bitNum);   
            }
            else DPRINTF(" Not Correction  \n");
        }
    }
    else{
        if(bitSize==24){
            if(result==0xfff){
                byteNum = ( (srcBack&0x20000 )>>9  | 
                            (srcBack&0x8000  )>>8  | (srcBack&0x2000)>>7   |
                            (srcBack&0x800   )>>6  | (srcBack&0x200 )>>5   |
                            (srcBack&0x80    )>>4  | (srcBack&0x20  )>>3   |
                            (srcBack&0x8     )>>2  | (srcBack&0x2   )>>1
                           );
                bitNum = ( (srcBack&0x800000)>>21 | (srcBack&0x200000)>>20 | (srcBack&0x80000)>>19 ); 
                DPRINTF("Main Area sect [%d]  [%3d]byte ,[%3d]bit Error\n",sectNum,byteNum,bitNum);   
            }
            else DPRINTF(" Not Correction  \n");
        }
        else{
            if(result==0x1f){
                byteNum = ( (srcBack&0x8)>>2 | (srcBack&0x2 )>>1 );
                bitNum = ( (srcBack&0x200)>>7 | (srcBack&0x80)>>6 | (srcBack&0x20)>>5 ); 
                DPRINTF("Spare Area [%3d]byte ,[%3d]bit Error\n",byteNum,bitNum);   
            }
            else DPRINTF(" Not Correction  \n");
        }
    }
}

/*-----------------------------------------------------------------------
    Function name   : NandIntHandler()
    Prototype       : static void NandIntHandler(smtUint32 IRQ);
    Return          : 
    Argument        :
    Comments        : nand interrupt Test
-----------------------------------------------------------------------*/ 
static void NandIntHandler(smtUint32 IRQ)
{
    int i=0;
    smtUint32 statusNand;
    smtUint32 data;

    statusNand=SMT_READ(NFSTAT);
    
    if((statusNand & 0x04)==0x04){
        DPRINTF("RnBDetect0 Intrrupt generate\n");
        DPRINTF("status %x \n",SMT_READ(NFSTAT));
        SMT_WRITE(NFSTAT,RNBDETECT0);
        DPRINTF("status %x \n",SMT_READ(NFSTAT));
    }
    if((statusNand & 0x08)==0x08){
        DPRINTF("RnBDetect1 Intrrupt generate\n");
        SMT_WRITE(NFSTAT,RNBDETECT1);
    }
    if((statusNand & 0x10)==0x10){
        //if(rnum==65) DPRINTF("num %d :: RDFIFOREADY Intrrupt generate\n",rnum++);
        DPRINTF(" rnum=%d",rnum++);
        for(i=0;i<level+1;i++){
            data=SMT_READ(NFDATA);
//            if(data!=0xaabbccdd) DPRINTF("Read Error %x",data); //WORD
//            if((data&0xffff)!=0xccdd) DPRINTF("Read Error %x",data); //HALFWORD
            if((data&0xff)!=0xdd) DPRINTF("Read Error %x",data); //BYTE
        }
    }
    if((statusNand & 0x20)==0x20){
        //if(wnum==65) DPRINTF("num %d :: WRFIFOREADY Intrrupt generate\n",wnum++);
        DPRINTF(" wnum=%d",wnum++);
        for(i=0;i<level+1;i++)
            SMT_WRITE(NFDATA,0xaa<<24|0xbb<<16|0xcc<<8|0xdd);
    }
    if((statusNand & 0x40)==0x40){
        DPRINTF("RdEnd Intrrupt generate\n");
        SMT_WRITE(NFSTAT,RDEND);
    }
    if((statusNand & 0x80)==0x80){
        DPRINTF("WrEnd Intrrupt generate\n");
        SMT_WRITE(NFSTAT,WREND);
    }
}


/*-----------------------------------------------------------------------
    Function name   : AutoEccWrTest()
    Prototype       : void AutoEccWrTest(void)
    Return          : 
    Argument        :
    Comments        : AutoEccWr Fuction Test
-----------------------------------------------------------------------*/ 
void AutoEccWrTest()
{
    int i,j,addr;
    smtUint32 totalSize;

    smtUint32 readData;
    smtUint32 seccRead0,seccRead1,seccRead2,seccRead3;
    smtUint32 seccRead4,seccRead5,seccRead6,seccRead7;
    
    smtUint32 eccRead0,eccRead1,eccRead2,eccRead3;
    smtUint32 eccRead4,eccRead5,eccRead6,eccRead7;
    smtUint32 eccRead8,eccRead9,eccRead10,eccRead11;
    smtUint32 eccRead12,eccRead13,eccRead14,eccRead15;
    
    smtUint32 LECC_a0=0,LECC_a1=0,LECC_a2=0,LECC_a3=0;
    smtUint32 LECC_b0=0,LECC_b1=0,LECC_b2=0,LECC_b3=0;
    
    smtUint32 HECC_a0=0,HECC_a1=0,HECC_a2=0,HECC_a3=0;
    smtUint32 HECC_b0=0,HECC_b1=0,HECC_b2=0,HECC_b3=0;

    smtUint32 LSECC0=0,LSECC1=0,LSECC2=0,LSECC3=0;
    smtUint32 HSECC0=0,HSECC1=0,HSECC2=0,HSECC3=0;
    
    smtUint8  high8=0;
    smtUint8  low8=0;

    if(ECC256){
        SMT_WRITE(NFCTRL,FIFOLEVEL|AUTOECCWR);
    }
    else{
        SMT_WRITE(NFCTRL,FIFOLEVEL|ECC512EN|AUTOECCWR);
    }
    
    if(PAGESIZE==0){ //512
        PageWrite(0,0,0,528,WORD);
        DataWrite(528,WORD,WRMOD_NORMAL);   
    }
    else{
        PageWrite(0,0,0,2112,WORD);
        DataWrite(2112,WORD,WRMOD_NORMAL);   
    }

    //ECC register read
    eccRead0=SMT_READ(ECCSECTOR0);   eccRead1=SMT_READ(ECCSECTOR1);
    eccRead2=SMT_READ(ECCSECTOR2);   eccRead3=SMT_READ(ECCSECTOR3);
    eccRead4=SMT_READ(ECCSECTOR4);   eccRead5=SMT_READ(ECCSECTOR5);
    eccRead6=SMT_READ(ECCSECTOR6);   eccRead7=SMT_READ(ECCSECTOR7);

    eccRead8=SMT_READ(ECCSECTOR8);   eccRead9=SMT_READ(ECCSECTOR9);
    eccRead10=SMT_READ(ECCSECTOR10); eccRead11=SMT_READ(ECCSECTOR11);
    eccRead12=SMT_READ(ECCSECTOR12); eccRead13=SMT_READ(ECCSECTOR13);
    eccRead14=SMT_READ(ECCSECTOR14); eccRead15=SMT_READ(ECCSECTOR15);

    seccRead0=SMT_READ(SECCSECTOR0); seccRead4=SMT_READ(SECCSECTOR4);
    seccRead1=SMT_READ(SECCSECTOR1); seccRead5=SMT_READ(SECCSECTOR5);
    seccRead2=SMT_READ(SECCSECTOR2); seccRead6=SMT_READ(SECCSECTOR6);
    seccRead3=SMT_READ(SECCSECTOR3); seccRead7=SMT_READ(SECCSECTOR7);
    if(PAGESIZE==0){ //512
        if(TWO8BITNAND==0){
            PageRead(0,0,0,528,BYTE);
        }
        else{
            PageRead(0,0,0,528,HALFWORD);
        }
    }
    else{ //2048
        if(TWO8BITNAND==0){
            PageRead(0,0,0,2112,BYTE);
        }
        else{
            PageRead(0,0,0,2112,HALFWORD);
        }
    }

    DPRINTF(" AutoEccWr Test start \n");    
    if(PAGESIZE==0) totalSize=66;
    else totalSize=264;

    for(j=0;j<totalSize;j++)
    {
        while(((SMT_READ(NFSTAT)&RDFIFOREADY)!=RDFIFOREADY));//RdFIFOReady check
        for(i=0;i<8;i++) {
            readData=SMT_READ(NFDATA);
            
            high8=(readData&0xff00)>>8;
            low8=readData&0xff;

            addr=(j*8)+i;
            //DPRINTF("addr %d :: low8=[%8x] ,high8=[%x]\n",addr,low8,high8);    
            if(PAGESIZE==0){
                     if(addr==518){ LECC_a0=low8;               HECC_a0=high8;}
                else if(addr==519){ LECC_a0=LECC_a0 | low8<<8;  HECC_a0=HECC_a0 | high8<<8;}
                else if(addr==520){ LECC_a0=LECC_a0 | low8<<16; HECC_a0=HECC_a0 | high8<<16;}
                else if(addr==521){ LSECC0=low8;                HSECC0=high8;}
                else if(addr==522){ LSECC0=LSECC0 | low8<<8;    HSECC0=HSECC0 | high8<<8;}
                else if(addr==523 && ECC256){ LECC_b0=low8;               HECC_b0=high8;}  
                else if(addr==524 && ECC256){ LECC_b0=LECC_b0 | low8<<8;  HECC_b0=HECC_b0 | high8<<8;}
                else if(addr==525 && ECC256){ LECC_b0=LECC_b0 | low8<<16; HECC_b0=HECC_b0 | high8<<16;}
            }
            else{
                     if(addr==2056){ LECC_a0=low8;               HECC_a0=high8;}
                else if(addr==2057){ LECC_a0=LECC_a0 | low8<<8;  HECC_a0=HECC_a0 | high8<<8;}
                else if(addr==2058){ LECC_a0=LECC_a0 | low8<<16; HECC_a0=HECC_a0 | high8<<16;}
                else if(addr==2059){ LSECC0=low8;                HSECC0=high8;}
                else if(addr==2060){ LSECC0=LSECC0 | low8<<8;    HSECC0=HSECC0 | high8<<8;}
                else if(addr==2061 && ECC256){ LECC_b0=low8;               HECC_b0=high8;}  
                else if(addr==2062 && ECC256){ LECC_b0=LECC_b0 | low8<<8;  HECC_b0=HECC_b0 | high8<<8;}
                else if(addr==2063 && ECC256){ LECC_b0=LECC_b0 | low8<<16; HECC_b0=HECC_b0 | high8<<16;}

                else if(addr==2072){ LECC_a1=low8;               HECC_a1=high8;}
                else if(addr==2073){ LECC_a1=LECC_a1 | low8<<8;  HECC_a1=HECC_a1 | high8<<8;}
                else if(addr==2074){ LECC_a1=LECC_a1 | low8<<16; HECC_a1=HECC_a1 | high8<<16;}
                else if(addr==2075){ LSECC1=low8;                HSECC1=high8;}
                else if(addr==2076){ LSECC1=LSECC1 | low8<<8;    HSECC1=HSECC1 | high8<<8;}
                else if(addr==2077 && ECC256){ LECC_b1=low8;               HECC_b1=high8;}  
                else if(addr==2078 && ECC256){ LECC_b1=LECC_b1 | low8<<8;  HECC_b1=HECC_b1 | high8<<8;}
                else if(addr==2079 && ECC256){ LECC_b1=LECC_b1 | low8<<16; HECC_b1=HECC_b1 | high8<<16;}

                else if(addr==2088){ LECC_a2=low8;               HECC_a2=high8;}
                else if(addr==2089){ LECC_a2=LECC_a2 | low8<<8;  HECC_a2=HECC_a2 | high8<<8;}
                else if(addr==2090){ LECC_a2=LECC_a2 | low8<<16; HECC_a2=HECC_a2 | high8<<16;}
                else if(addr==2091){ LSECC2=low8;                HSECC2=high8;}
                else if(addr==2092){ LSECC2=LSECC2 | low8<<8;    HSECC2=HSECC2 | high8<<8;}
                else if(addr==2093 && ECC256){ LECC_b2=low8;               HECC_b2=high8;}  
                else if(addr==2094 && ECC256){ LECC_b2=LECC_b2 | low8<<8;  HECC_b2=HECC_b2 | high8<<8;}
                else if(addr==2095 && ECC256){ LECC_b2=LECC_b2 | low8<<16; HECC_b2=HECC_b2 | high8<<16;}

                else if(addr==2104){ LECC_a3=low8;               HECC_a3=high8;}
                else if(addr==2105){ LECC_a3=LECC_a3 | low8<<8;  HECC_a3=HECC_a3 | high8<<8;}
                else if(addr==2106){ LECC_a3=LECC_a3 | low8<<16; HECC_a3=HECC_a3 | high8<<16;}
                else if(addr==2107){ LSECC3=low8;                HSECC3=high8;}
                else if(addr==2108){ LSECC3=LSECC3 | low8<<8;    HSECC3=HSECC3 | high8<<8;}
                else if(addr==2109 && ECC256){ LECC_b3=low8;               HECC_b3=high8;}  
                else if(addr==2110 && ECC256){ LECC_b3=LECC_b3 | low8<<8;  HECC_b3=HECC_b3 | high8<<8;}
                else if(addr==2111 && ECC256){ LECC_b3=LECC_b3 | low8<<16; HECC_b3=HECC_b3 | high8<<16;}
            }

        }
    }
    if(ECC256){
        if(PAGESIZE==0){ //512 Page
            DPRINTF("REG ECCSECTOR0  [%8x] :: READ LECC_a0  [%8x]\n",eccRead0 ,LECC_a0 );    
            DPRINTF("REG ECCSECTOR1  [%8x] :: READ LECC_b0  [%8x]\n",eccRead1 ,LECC_b0 );    
            DPRINTF("REG ECCSECTOR8  [%8x] :: READ HECC_a0  [%8x]\n",eccRead8 ,HECC_a0 );    
            DPRINTF("REG ECCSECTOR9  [%8x] :: READ HECC_b0  [%8x]\n",eccRead9 ,HECC_b0 );    
        }
        else{//2048 Page 
            DPRINTF("REG ECCSECTOR0  [%8x] :: READ LECC_a0  [%8x]\n",eccRead0 ,LECC_a0 );    
            DPRINTF("REG ECCSECTOR1  [%8x] :: READ LECC_b0  [%8x]\n",eccRead1 ,LECC_b0 );    
            DPRINTF("REG ECCSECTOR2  [%8x] :: READ LECC_a1  [%8x]\n",eccRead2 ,LECC_a1 );    
            DPRINTF("REG ECCSECTOR3  [%8x] :: READ LECC_b1  [%8x]\n",eccRead3 ,LECC_b1 );    
            DPRINTF("REG ECCSECTOR4  [%8x] :: READ LECC_a2  [%8x]\n",eccRead4 ,LECC_a2 );    
            DPRINTF("REG ECCSECTOR5  [%8x] :: READ LECC_b2  [%8x]\n",eccRead5 ,LECC_b2 );    
            DPRINTF("REG ECCSECTOR6  [%8x] :: READ LECC_a3  [%8x]\n",eccRead6 ,LECC_a3 );    
            DPRINTF("REG ECCSECTOR7  [%8x] :: READ LECC_b3  [%8x]\n",eccRead7 ,LECC_b3 );    
            DPRINTF("REG ECCSECTOR8  [%8x] :: READ HECC_a0  [%8x]\n",eccRead8 ,HECC_a0 );    
            DPRINTF("REG ECCSECTOR9  [%8x] :: READ HECC_b0  [%8x]\n",eccRead9 ,HECC_b0 );    
            DPRINTF("REG ECCSECTOR10 [%8x] :: READ HECC_a1  [%8x]\n",eccRead10,HECC_a1 );    
            DPRINTF("REG ECCSECTOR11 [%8x] :: READ HECC_b1  [%8x]\n",eccRead11,HECC_b1 );    
            DPRINTF("REG ECCSECTOR12 [%8x] :: READ HECC_a2  [%8x]\n",eccRead12,HECC_a2 );    
            DPRINTF("REG ECCSECTOR13 [%8x] :: READ HECC_b2  [%8x]\n",eccRead13,HECC_b2 );    
            DPRINTF("REG ECCSECTOR14 [%8x] :: READ HECC_a3  [%8x]\n",eccRead14,HECC_a3 );    
            DPRINTF("REG ECCSECTOR15 [%8x] :: READ HECC_b3  [%8x]\n",eccRead15,HECC_b3 );    
        }
    }
    else{
        if(PAGESIZE==0){ //512 Page
            DPRINTF("REG ECCSECTOR0  [%8x] :: READ LECC_a0  [%8x]\n",eccRead0 ,LECC_a0 );    
            DPRINTF("REG ECCSECTOR8  [%8x] :: READ HECC_a0  [%8x]\n",eccRead8 ,HECC_a0 );    
        }
        else{//2048 Page
            DPRINTF("REG ECCSECTOR0  [%8x] :: READ LECC_a0  [%8x]\n",eccRead0 ,LECC_a0 );    
            DPRINTF("REG ECCSECTOR1  [%8x] :: READ LECC_a1  [%8x]\n",eccRead1 ,LECC_a1 );    
            DPRINTF("REG ECCSECTOR2  [%8x] :: READ LECC_a2  [%8x]\n",eccRead2 ,LECC_a2 );    
            DPRINTF("REG ECCSECTOR3  [%8x] :: READ LECC_a3  [%8x]\n",eccRead3 ,LECC_a3 );    
            DPRINTF("REG ECCSECTOR8  [%8x] :: READ HECC_a0  [%8x]\n",eccRead8 ,HECC_a0 );    
            DPRINTF("REG ECCSECTOR9  [%8x] :: READ HECC_a1  [%8x]\n",eccRead9 ,HECC_a1 );    
            DPRINTF("REG ECCSECTOR10 [%8x] :: READ HECC_a2  [%8x]\n",eccRead10,HECC_a2 );    
            DPRINTF("REG ECCSECTOR11 [%8x] :: READ HECC_a3  [%8x]\n",eccRead11,HECC_a3 );    
        }
    }

    DPRINTF("REG SECCSECTOR0 [%8x] :: READ LSECC0   [%8x]\n",seccRead0,LSECC0);    
    DPRINTF("REG SECCSECTOR1 [%8x] :: READ LSECC1   [%8x]\n",seccRead1,LSECC1);    
    DPRINTF("REG SECCSECTOR2 [%8x] :: READ LSECC2   [%8x]\n",seccRead2,LSECC2);    
    DPRINTF("REG SECCSECTOR3 [%8x] :: READ LSECC3   [%8x]\n",seccRead3,LSECC3);  
    if(TWO8BITNAND){
        DPRINTF("REG SECCSECTOR4 [%8x] :: READ HSECC0   [%8x]\n",seccRead4,HSECC0);    
        DPRINTF("REG SECCSECTOR5 [%8x] :: READ HSECC1   [%8x]\n",seccRead5,HSECC1);    
        DPRINTF("REG SECCSECTOR6 [%8x] :: READ HSECC2   [%8x]\n",seccRead6,HSECC2);    
        DPRINTF("REG SECCSECTOR7 [%8x] :: READ HSECC3   [%8x]\n",seccRead7,HSECC3);    
    }
    
    if(ECC256){
        if(TWO8BITNAND==0){
            if(  PAGESIZE==0 && //512 
                (eccRead0==LECC_a0  &&  eccRead1==LECC_b0  &&  eccRead0==LSECC0))
                DPRINTF("AutoEccWr Test OK \n");    
            else if( PAGESIZE==1 && //2048
                (eccRead0==LECC_a0  &&  eccRead2==LECC_a1  &&  eccRead4==LECC_a2  &&  eccRead6==LECC_a3 &&
                 eccRead1==LECC_b0  &&  eccRead3==LECC_b1  &&  eccRead5==LECC_b2  &&  eccRead7==LECC_b3 &&
                 seccRead0==LSECC0  &&  seccRead1==LSECC1  &&  seccRead2==LSECC2  &&  seccRead3==LSECC3 ))
                DPRINTF("AutoEccWr Test OK \n");    
            else
            {
               	GPIOWrite(0xdee2);
                DPRINTF("AutoEccWr Test Fail \n");
                while(1);
            }
        }
        else{//nand x 2
            if(  PAGESIZE==0 && //512 
                 eccRead0==LECC_a0  &&  eccRead1==LECC_b0  &&  seccRead0==LSECC0 &&
                 eccRead8==HECC_a0  &&  eccRead9==HECC_b0  &&  seccRead4==HSECC0 )
                DPRINTF("AutoEccWr Test OK \n");    
            else if( (PAGESIZE==1 &&//2048
                 eccRead0 ==LECC_a0  &&  eccRead2 ==LECC_a1  &&  eccRead4 ==LECC_a2  &&  eccRead6 ==LECC_a3 &&
                 eccRead1 ==LECC_b0  &&  eccRead3 ==LECC_b1  &&  eccRead5 ==LECC_b2  &&  eccRead7 ==LECC_b3 &&
                 eccRead8 ==HECC_a0  &&  eccRead10==HECC_a1  &&  eccRead12==HECC_a2  &&  eccRead14==HECC_a3 &&
                 eccRead9 ==HECC_b0  &&  eccRead11==HECC_b1  &&  eccRead13==HECC_b2  &&  eccRead15==HECC_b3 &&
                 seccRead0==LSECC0   &&  seccRead1==LSECC1   &&  seccRead2==LSECC2   &&  seccRead3==LSECC3  &&
                 seccRead4==HSECC0   &&  seccRead5==HSECC1   &&  seccRead6==HSECC2   &&  seccRead7==HSECC3))
                DPRINTF("AutoEccWr Test OK \n");    
            else
            {
                DPRINTF("AutoEccWr Test Fail \n");
               	GPIOWrite(0xdee2);
                while(1);
            }
        }
    }
    else{
        if(TWO8BITNAND==0){
            if( PAGESIZE==0 && //512
                eccRead0==LECC_a0  &&  seccRead0==LSECC0)
                DPRINTF("AutoEccWr Test OK \n");    
            else if( eccRead0==LECC_a0  &&  eccRead1==LECC_a1  &&  eccRead2==LECC_a2  &&  eccRead3==LECC_a3 &&
                seccRead0==LSECC0  &&  seccRead1==LSECC1  &&  seccRead2==LSECC2  &&  seccRead3==LSECC3 )
                DPRINTF("AutoEccWr Test OK \n");    
            else
            {
                DPRINTF("AutoEccWr Test Fail \n");
               	GPIOWrite(0xdee2);
                while(1);
            }
        }
        else{ //nand x 2
            if( (PAGESIZE==0 && //512
                eccRead0==LECC_a0  &&  eccRead8==HECC_a0  &&
                seccRead0==LSECC0  &&  seccRead4==HSECC0  ) )
                DPRINTF("AutoEccWr Test OK \n");    
            else if( (PAGESIZE==1 && //2048
                eccRead0==LECC_a0  &&  eccRead1==LECC_a1  &&  eccRead2 ==LECC_a2  &&  eccRead3 ==LECC_a3 &&
                eccRead8==HECC_a0  &&  eccRead9==HECC_a1  &&  eccRead10==HECC_a2  &&  eccRead11==HECC_a3 &&
                seccRead0==LSECC0  &&  seccRead1==LSECC1  &&  seccRead2==LSECC2   &&  seccRead3==LSECC3  &&
                seccRead4==HSECC0  &&  seccRead5==HSECC1  &&  seccRead6==HSECC2   &&  seccRead7==HSECC3) )
                DPRINTF("AutoEccWr Test OK \n");    
            else
            {
                DPRINTF("AutoEccWr Test Fail \n");
               	GPIOWrite(0xdee2);
                while(1);
            }
        }
    }

}

/*-----------------------------------------------------------------------
    Function name   : DataWrite()
    Prototype       : void DataWrite(smtUint16 writeSize,WORD,smtUint8 writeMode)
    Return          : 
    Argument        :
    Comments        : nand controller initialize
-----------------------------------------------------------------------*/ 
void DataWrite(smtUint16 writeSize,smtUint8 transSize,smtUint8 writeMode)
{

    int i,j;
    smtUint32 wdata0,wdata1,status,dnum;
    smtUint8 data0=0x0;
    smtUint8 data1=0x1;
    smtUint8 data2=0x2;
    smtUint8 data3=0x3;

    smtUint32 compValue,totalSize,sector,byte;
    smtUint8 remain;
    smtUint8 div,bit;
    
    sector=0;
    byte=0;
    bit=6;


    if(transSize==BYTE) div=1;
    else if(transSize==HALFWORD) div=2;
    else if(transSize==WORD) div=4;
    
    if(TWO8BITNAND){
        writeSize=writeSize*2;
        if(ECC256) dnum=256;
        else dnum=512;
    }
    else{
        if(ECC256) dnum=128;
        else dnum=256;
    }

    remain = writeSize%(div*8);
    totalSize = writeSize/(div*8);
    
    //DPRINTF("writeSize=%d :: div=%d :: remain=%d :: totalSize=%d\n",writeSize,div,remain,totalSize);
    
    DPRINTF("-------- Data Write --------\n");
//    DPRINTF("%x\n",((0xfeff<<3)&0xff00)>>8);

    for(j=0;j<totalSize;j++)
    {
        while(((SMT_READ(NFSTAT)&WRFIFOREADY)!=WRFIFOREADY));//WrFIFOReady check
        SMT_WRITE(NFSTAT,0x20);
        for(i=0;i<8;i++)
        {  
            if(writeMode==WRMOD_NORMAL){
                SMT_WRITE(NFDATA,data3<<24|data2<<16|data1<<8|data0);
            }   
            else { // Error generation
                sector=((j*8)+1)/dnum; 
                if(ECC256){
                    if( ((j*8)+i)==(((dnum)*sector)+byte) ){ 
                                        wdata0=(~data0 & (0x1<<bit)) | (data0 & ~(0x1<<bit));
                        if(TWO8BITNAND) wdata1=(~data1 & (0x1<<bit)) | (data1 & ~(0x1<<bit));
                        else            wdata1=data1;
                        DPRINTF(" num %d :::: orignal %x:%x :: invert %x:%x\n",(j*8)+i,data0,data1,wdata0,wdata1);
                    }
                    else{wdata0=data0; wdata1=data1;}
                }
                else{
                    if( (j*i)==(((dnum)*sector)+byte) ){
                                        wdata0=(~data0 & (0x1<<bit)) | (data0 & ~(0x1<<bit));
                        if(TWO8BITNAND) wdata1=(~data1 & (0x1<<bit)) | (data1 & ~(0x1<<bit));
                        else            wdata1=data1;
                        DPRINTF(" num %d :::: orignal %x:%x :: invert %x:%x\n",(j*8)+i,data0,data1,wdata0,wdata1);
                    }
                    else{wdata0=data0; wdata1=data1;}
                }
                SMT_WRITE(NFDATA,wdata1<<8|wdata0);
                
            }
            data0=data0+i;
            data1=data1+i;
            data2=data2+i;
            data3=data3+i;
        }
    }
    if(remain!=0){
        while(((SMT_READ(NFSTAT)&WRFIFOREADY)!=WRFIFOREADY));//WrFIFOReady check
        SMT_WRITE(NFSTAT,0x20);
        for(i=0;i<remain;i++){
            SMT_WRITE(NFDATA,data3<<24|data2<<16|data1<<8|data0);
        }
    }
  	GPIOWrite(0xffff);

    //DPRINTF(" j=%d :: i=%d ||| NAND CmdQ=%d :: FIFO1=%d :: FIFO0=%d\n",j,i,(status&0xf00)>>16,(status&0x0f0)>>8,status&0xf);
    while((SMT_READ(NFSTAT)&WREND)!=WREND);
    SMT_WRITE(NFSTAT,WREND);
    DPRINTF(" NFSTAT %x \n",SMT_READ(NFSTAT));
    status=SMT_READ(NFFIFOSTAT);
    DPRINTF(" Nand Write end \n");
    //DPRINTF(" NAND CmdQ=%d :: FIFO1=%d :: FIFO0=%d\n",(status&0xf00)>>16,(status&0x0f0)>>8,status&0xf);
}

/*-----------------------------------------------------------------------
    Function name   : DataRead()
    Prototype       : void DataRead(smtUint8 readMode)
    Return          : 
    Argument        :
    Comments        : nand controller initialize
-----------------------------------------------------------------------*/ 
void DataRead(smtUint16 readSize,smtUint8 transSize,smtUint8 readMode)
{
    int j,i;
    smtUint8 data0=0x0;
    smtUint8 data1=0x1;
    smtUint8 data2=0x2;
    smtUint8 data3=0x3;

    smtUint32 readData,status;
    smtUint32 compValue,totalSize;
    smtUint8 remain;
    smtUint8 div;
    if(TWO8BITNAND) readSize=readSize*2;

    if(transSize==BYTE) div=1;
    else if(transSize==HALFWORD) div=2;
    else if(transSize==WORD) div=4;

    remain = readSize%(div*8);
    totalSize = readSize/(div*8);
    DPRINTF("div=%d :: remain=%d :: totalSize=%d readSize=%d\n",div,remain,totalSize,readSize);
    DPRINTF("-------- Data Read --------\n");
    
    for(j=0;j<totalSize;j++)
    {
        while(((SMT_READ(NFSTAT)&RDFIFOREADY)!=RDFIFOREADY));//RdFIFOReady check
        for(i=0;i<8;i++) {
            
            readData=SMT_READ(NFDATA);
            //DPRINTF("read data: [%x]\n",readData);
            
            if(readMode==RDMOD_ERASE){
                
                if(transSize==BYTE) compValue=0xff;
                else if(transSize==HALFWORD) compValue=0xffff;
                else if(transSize==WORD) compValue=0xffffffff;
                
                //compValue=0xffffffff;
            }
            else{
                if(transSize==BYTE) compValue=data0;
                else if(transSize==HALFWORD) compValue=data1<<8|data0;
                else if(transSize==WORD) compValue=data3<<24|data2<<16|data1<<8|data0;
            }

            if(readData!=compValue){
                DPRINTF("j=%d,i=%d READ ERROR!!! \n",j,i);    
                DPRINTF("READ VALUE=%x :: COMP VALUE=%x \n",readData,compValue); 
                if(compValue==0xff) GPIOWrite(0xdee4);
                else if(compValue==0xffff) GPIOWrite(0xdee3);
                else if(compValue==0xffffffff) GPIOWrite(0xde2);
               	else GPIOWrite(0xdee1);
                while(1);
            }
            data0=data0+i;
            data1=data1+i;
            data2=data2+i;
            data3=data3+i;
        }
    }
    if(remain!=0){
        while(((SMT_READ(NFSTAT)&RDFIFOREADY)!=RDFIFOREADY));//RdFIFOReady check
        for(i=0;i<(remain);i++){
            readData=SMT_READ(NFDATA);
            //DPRINTF("READ Data[%x] \n",readData);    
            if(readMode==RDMOD_ERASE) compValue=0xffffffff;
            else{
                if(transSize==BYTE) compValue=data0;
                else if(transSize==HALFWORD) compValue=data1<<8|data0;
                else if(transSize==WORD) compValue=data3<<24|data2<<16|data1<<8|data0;
            }

            if(readData!=compValue){
                DPRINTF("j=%d,i=%d READ ERROR!!! \n",j,i);    
                DPRINTF("READ VALUE=%x :: COMP VALUE=%x \n",readData,compValue);    
               	GPIOWrite(0xdee1);
                while(1);
            }
            data0=data0+i;
            data1=data1+i;
            data2=data2+i;
            data3=data3+i;
        }
    }
    DPRINTF("i: [%d]\n",i);
    DPRINTF("NFSTAT : [%x]\n",SMT_READ(NFSTAT));
    DPRINTF("NAND CmdQ=%d :: FIFO1=%d :: FIFO0=%d\n",(status&0xf00)>>16,(status&0x0f0)>>8,status&0xf);
    while((SMT_READ(NFSTAT)&RDEND)!=RDEND); //RdEnd Check
    DPRINTF("NFSTAT : [%x]\n",SMT_READ(NFSTAT));
    SMT_WRITE(NFSTAT,0x40);
    status=SMT_READ(NFFIFOSTAT);
    DPRINTF("NAND CmdQ=%d :: FIFO1=%d :: FIFO0=%d\n",(status&0xf00)>>16,(status&0x0f0)>>8,status&0xf);
    DPRINTF("READ OK \n");    
}
/*-----------------------------------------------------------------------
    Function name   : NandInit()
    Prototype       : void NandInit(void)
    Return          : 
    Argument        :
    Comments        : nand controller initialize
-----------------------------------------------------------------------*/ 
void NandInit()
{

    SMT_WRITE(NFCONF,TADLTWB|TACLS|TRWLP|TRWHP);
    SMT_WRITE(NFCTRL,FIFOLEVEL|RNBINTEN0|WRENDINTEN|RDENDINTEN|FIFOINTEN);
//    SMT_WRITE(NFCTRL,FIFOLEVEL|FIFOINTEN);

    DPRINTF("NFCONF write value : [%x]\n",TADLTWB|TACLS|TRWLP|TRWHP);
    DPRINTF("NFCTRL write value : [%x]\n",FIFOLEVEL);
    DPRINTF("NFCONF : [%x]\n",SMT_READ(NFCONF));
    DPRINTF("NFCTRL : [%x]\n",SMT_READ(NFCTRL));
    DPRINTF("NFSTAT : [%x]\n",SMT_READ(NFSTAT));

}
/*-----------------------------------------------------------------------
    Function name   : Reset()
    Prototype       : void Reset(void)
    Return          : 
    Argument        :
    Comments        : nand flash reset 
-----------------------------------------------------------------------*/ 

void Reset()
{
//    SMT_WRITE(NFOPER,RNBWAIT|AUTORDSTAT|NOP|WORD|0x2<<8|0xc0);
    SMT_WRITE(NFOPER,AUTORDSTAT|NOP|WORD|0x2<<8|0x03);
    SMT_WRITE(NFOPER,RDSTATCMD<<8|RESETCMD);
    DPRINTF("NFSTAT %x \n",SMT_READ(NFSTAT));
    DPRINTF("NFSTAT %x \n",SMT_READ(NFSTAT));
    DPRINTF("NFSTAT %x \n",SMT_READ(NFSTAT));
    DPRINTF("NFSTAT %x \n",SMT_READ(NFSTAT));
    DPRINTF("NFSTAT %x \n",SMT_READ(NFSTAT));
    DPRINTF("NFSTAT %x \n",SMT_READ(NFSTAT));
    DPRINTF("NFSTAT %x \n",SMT_READ(NFSTAT));
    DPRINTF("NFSTAT %x \n",SMT_READ(NFSTAT));
    SMT_WRITE(NFSTAT,(SMT_READ(NFSTAT)));
    DPRINTF("NFSTAT %x \n",SMT_READ(NFSTAT));
    DPRINTF("NFSTAT %x \n",SMT_READ(NFSTAT));
    DPRINTF("NFSTAT %x \n",SMT_READ(NFSTAT));
    DPRINTF("NFSTAT %x \n",SMT_READ(NFSTAT));
    DPRINTF("NFSTAT %x \n",SMT_READ(NFSTAT));
    while((SMT_READ(NFSTAT)&NFSTATVALID)!=NFSTATVALID);//NFStatValid check
    DPRINTF("NFSTAT %x \n",SMT_READ(NFSTAT));
    SMT_WRITE(NFSTAT,NFSTATVALID|RNBDETECT0);
    DPRINTF("-------- Nand Reset --------\n");
    DPRINTF("NFSTAT %x \n",SMT_READ(NFSTAT));
    
	if((SMT_READ(NFSTAT>>8 & 0x1)==0x0))//NFStatus check
        DPRINTF("Nand Reset OK \n");
    else
        DPRINTF("Nand Reset Fail \n");

}

/*-----------------------------------------------------------------------
    Function name   : BlockErase()
    Prototype       : void BlockErase(void)
    Return          : 
    Argument        :
    Comments        : nand flash block erase
-----------------------------------------------------------------------*/ 
void BlockErase(smtUint16 blockAddr,smtUint16 pageAddr)
{
    smtUint8 rowAddr1;
    smtUint8 rowAddr2;
    smtUint8 rowAddr3;

    rowAddr1 = (pageAddr & 0x3f) | ((blockAddr & 0x3)>>6);
    rowAddr2 = (blockAddr>>2) & 0xff;
    rowAddr3 = (blockAddr>>10) & 0xff;

    if(PAGESIZE==0){ //512
        SMT_WRITE(NFOPER,AUTORDSTAT|NOP|(0x5<<8)|0x19);
        SMT_WRITE(NFOPER,BERASECMD2<<24|rowAddr2<<16|rowAddr1<<8|BERASECMD1);
        SMT_WRITE(NFOPER,RDSTATCMD);
    }
    else{ //2048
        SMT_WRITE(NFOPER,AUTORDSTAT|NOP|(0x6<<8)|0x11);
        SMT_WRITE(NFOPER,rowAddr3<<24|rowAddr2<<16|rowAddr1<<8|BERASECMD1);
        SMT_WRITE(NFOPER,RDSTATCMD<<8|BERASECMD2);
    }
   
    DPRINTF("-------- Nand Erase --------\n");
    while((SMT_READ(NFSTAT)&NFSTATVALID)!=NFSTATVALID);//NFStatValid check
    DPRINTF("Nand status : %x\n",SMT_READ(NFSTAT));
    SMT_WRITE(NFSTAT,NFSTATVALID|RNBDETECT0);
    if((SMT_READ(NFSTAT)&0x10)==0x0)//NFStatus check
        DPRINTF("Nand Erase OK \n");
    else
        DPRINTF("Nand Erase Fail \n");
}
/*-----------------------------------------------------------------------
    Function name   : two_BlockErase()
    Prototype       : void BlockErase(void)
    Return          : 
    Argument        :
    Comments        : nand flash block erase
-----------------------------------------------------------------------*/ 
void TwoPlaneBlockErase(smtUint16 blockAddr0,smtUint16 pageAddr0,smtUint16 blockAddr1,smtUint16 pageAddr1)
{
    smtUint8 rowAddr0_1,rowAddr1_1;
    smtUint8 rowAddr0_2,rowAddr1_2;
    smtUint8 rowAddr0_3,rowAddr1_3;

    rowAddr0_1 = (pageAddr0 & 0x3f) | ((blockAddr0 & 0x3)>>6);
    rowAddr0_2 = (blockAddr0>>2) & 0xff;
    rowAddr0_3 = (blockAddr0>>10) & 0xff;

    rowAddr1_1 = (pageAddr1 & 0x3f) | ((blockAddr1 & 0x3)>>6);
    rowAddr1_2 = (blockAddr1>>2) & 0xff;
    rowAddr1_3 = (blockAddr1>>10) & 0xff;
 
    DPRINTF("-------- TWOPlane Block Erase --------\n");

    SMT_WRITE(NFOPER,CONTINUE|NOP|(0x4<<8)|0x01);
    SMT_WRITE(NFOPER,rowAddr0_3<<24|rowAddr0_2<<16|rowAddr0_1<<8|BERASECMD1);

    SMT_WRITE(NFOPER,AUTORDSTAT|NOP|WORD|(0x6<<8)|0x11);
    SMT_WRITE(NFOPER,rowAddr0_3<<24|rowAddr0_2<<16|rowAddr0_1<<8|BERASECMD1);
    SMT_WRITE(NFOPER,RDSTATCMD<<8|BERASECMD2);

    while((SMT_READ(NFSTAT)&NFSTATVALID)!=NFSTATVALID);//NFStatValid check
    SMT_WRITE(NFSTAT,NFSTATVALID|RNBDETECT0);
    
    if( ((SMT_READ(NFSTAT)>>8) & 0x1)==0x0)//NFStatus check
        DPRINTF("Nand Reset OK \n");
    else
        DPRINTF("Nand Reset Fail \n");

    
}

/*-----------------------------------------------------------------------
    Function name   : IdRead()
    Prototype       : void IdRead(void)
    Return          : 
    Argument        :
    Comments        :  
-----------------------------------------------------------------------*/ 
void IdRead(smtUint8 transSize)
{
    smtUint32 RdData1,RdData2,RdData3,status;

    if(PAGESIZE==0){ //512 page
        SMT_WRITE(NFOPER,0x2<<17|READID|transSize<<12|(0x2<<8)|0x01);
        SMT_WRITE(NFOPER,RDIDCMD);
        while((SMT_READ(NFSTAT)&RDFIFOREADY)!=RDFIFOREADY);//RdFIFOReady check
        DPRINTF("NFSTAT : %x\n",SMT_READ(NFSTAT));
        DPRINTF("-------- Nand ID Read --------\n");
        DPRINTF("Nand 1st ID : %x\n",SMT_READ(NFDATA));
        DPRINTF("Nand 2nd ID : %x\n",SMT_READ(NFDATA));
    }
    else{ //2048
        SMT_WRITE(NFOPER,0x5<<17|READID|BYTE|(0x2<<8)|0x01);
        SMT_WRITE(NFOPER,RDIDCMD);
        while((SMT_READ(NFSTAT)&RDFIFOREADY)!=RDFIFOREADY);//RdFIFOReady check
        DPRINTF("NFSTAT : %x\n",SMT_READ(NFSTAT));
        //SMT_WRITE(NFSTAT,0x10);
        DPRINTF("-------- Nand ID Read --------\n");
        DPRINTF("Nand 1st ID : %x\n",SMT_READ(NFDATA));
        DPRINTF("Nand 2nd ID : %x\n",SMT_READ(NFDATA));
        DPRINTF("Nand 3rd ID : %x\n",SMT_READ(NFDATA));
        DPRINTF("Nand 4th ID : %x\n",SMT_READ(NFDATA));
        DPRINTF("Nand 5th ID : %x\n",SMT_READ(NFDATA));
    }
/*
    status=SMT_READ(NFFIFOSTAT);
    DPRINTF("NFFIFOSTAT=%x :: NAND CmdQ=%d :: FIFO1=%d :: FIFO0=%d\n",status,(status&0xf00)>>16,(status&0x0f0)>>8,status&0xf);
    
    RdData1=SMT_READ(NFDATA);
    RdData2=SMT_READ(NFDATA);
    DPRINTF("-------- Nand ID Read --------\n");
	DPRINTF("Nand 1st ID : %x\n",RdData1&0xff);
	DPRINTF("Nand 1st ID : %x\n",RdData1&0xff);

	DPRINTF("Nand 1st ID : %x\n",RdData1&0xff);
	DPRINTF("Nand 2nd ID : %x\n",(RdData1&0xff00)>>8);
	DPRINTF("Nand 3rd ID : %x\n",(RdData1&0xff0000)>>16);
	DPRINTF("Nand 4th ID : %x\n",(RdData1&0xff000000)>>24);
    DPRINTF("Nand 5th ID : %x\n",RdData2&0xff);
*/
}

/*-----------------------------------------------------------------------
    Function name   : PageRead()
    Prototype       : void PageRead(smtUint16 blockAddr,smtUint16 pageAddr,smtUint16 colAddr,smtUint16 readSize,smtUint8 transSize)
    Return          : 
    Argument        :
    Comments        :  
-----------------------------------------------------------------------*/
void PageRead(smtUint16 blockAddr,smtUint16 pageAddr,smtUint16 colAddr,smtUint16 readSize,smtUint8 transSize)
{
    int i,j;
    smtUint8 addr1;
    smtUint8 addr2;
    smtUint8 addr3;
    smtUint8 addr4;
    smtUint8 addr5;
    
    if(PAGESIZE==0){
        addr1 = colAddr & 0xff;
        addr2 = (pageAddr & 0x1f) | ((blockAddr & 0x7)<<5);
        addr3 = (blockAddr & 0x7f1)>>3;

        SMT_WRITE(NFOPER,readSize<<17|READDATA|transSize<<12|(0x5<<8)|0x11);
        SMT_WRITE(NFOPER,addr3<<24|addr2<<16|addr1<<8|PAGERDCMD1);
        SMT_WRITE(NFOPER,PAGERDCMD2<<16);
    }
    else{
        addr1 = colAddr & 0xff;
        addr2 = (colAddr>>8) & 0xf;
        addr3 = (pageAddr & 0x3f) | ((blockAddr & 0x3)<<6);
        addr4 = (blockAddr>>2)&0xff;
        addr5 = (blockAddr>>10)&0xff;

        SMT_WRITE(NFOPER,readSize<<17|READDATA|transSize<<12|(0x7<<8)|0x41);
        SMT_WRITE(NFOPER,addr3<<24|addr2<<16|addr1<<8|PAGERDCMD1);
        SMT_WRITE(NFOPER,PAGERDCMD2<<16|addr5<<8|addr4);
    }    
}

/*-----------------------------------------------------------------------
    Function name   : PageWrite()
    Prototype       : void PageRead(smtUint32 PageSize,smtUint32 Block addr,smtUint32 Pageaddr,smtUint32 writeData,smtUint8 transSize)
    Return          : 
    Argument        :
    Comments        :  
-----------------------------------------------------------------------*/
void PageWrite(smtUint16 blockAddr,smtUint16 pageAddr,smtUint16 colAddr,smtUint32 writeSize,smtUint8 transSize)
{
    int i,j;
    smtUint8 addr1;
    smtUint8 addr2;
    smtUint8 addr3;
    smtUint8 addr4;
    smtUint8 addr5;
    
    if(PAGESIZE==0){
        addr1 = colAddr & 0xff;
        addr2 = (pageAddr & 0x1f) | ((blockAddr & 0x7)<<5);
        addr3 = (blockAddr & 0x7f1)>>3;
    
        //DPRINTF("addr1 %x : addr2 %x : addr3 %x\n",addr1,addr2,addr3);

        SMT_WRITE(NFOPER,AUTORDSTAT|writeSize<<17|WRITEDATA|transSize<<12|(0x6<<8)|0x31);
        SMT_WRITE(NFOPER,addr3<<24|addr2<<16|addr1<<8|PAGEWRCMD1);
        SMT_WRITE(NFOPER,RDSTATCMD<<8|PAGEWRCMD2);
    }
    else{
        addr1 = colAddr & 0xff;
        addr2 = (colAddr>>8) & 0xf;
        addr3 = (pageAddr & 0x3f) | ((blockAddr & 0x3)<<6);
        addr4 = (blockAddr>>2)&0xff;
        addr5 = (blockAddr>>10)&0xff;

        SMT_WRITE(NFOPER,AUTORDSTAT|writeSize<<17|WRITEDATA|transSize<<12|(0x8<<8)|0x41);
        SMT_WRITE(NFOPER,addr3<<24|addr2<<16|addr1<<8|PAGEWRCMD1);
        SMT_WRITE(NFOPER,RDSTATCMD<<24|PAGEWRCMD2<<16|addr5<<8|addr4);
    }
 
/*    
    SMT_WRITE(NFOPER,CONTINUE|writeSize<<17|WRITEDATA|transSize<<12|(0x6<<8)|0x41);
    SMT_WRITE(NFOPER,addr3<<24|addr2<<16|addr1<<8|PAGEWRCMD1);
    SMT_WRITE(NFOPER,addr5<<8|addr4);
    SMT_WRITE(NFOPER,AUTORDSTAT|writeSize<<17|WRITEDATA|transSize<<12|(0x8<<8)|0x41);
    SMT_WRITE(NFOPER,addr3<<24|addr2<<16|addr1<<8|PAGEWRCMD1);
    SMT_WRITE(NFOPER,RDSTATCMD<<24|PAGEWRCMD2<<16|addr5<<8|addr4);
    DataWrite(2112,WORD,WRMOD_NORMAL);
*/    
}

/*-----------------------------------------------------------------------
    Function name   : DmaRead()
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
DMACNoDescrp(smtUint8 channel, smtUint32 SrcAddr, smtBoolean SrcIncrease, smtUint8 SWidth, smtUint32 DestAddr, 
             smtBoolean DstIncrease, smtUint8 DWidth, smtUint8 TransSize, smtUint16 TotalSize);    
-----------------------------------------------------------------------*/
void DmaRead(smtUint16 blockAddr,smtUint16 pageAddr,smtUint16 colAddr,smtUint16 readSize)
{
    int i;

    DPRINTF("-------- DMA Read --------\n");

    DMACEnable(NANDCHANNEL);
    SMT_WRITE(NFSTAT,RDEND);
    SMT_WRITE(NFCTRL,FIFOLEVEL|DMAEN);
    PageRead(blockAddr,pageAddr,colAddr,readSize,WORD);//(BlockAddr,PageAddr,ColumnAddr,ReadSize,TransWidth)    
    //PageRead(blockAddr,pageAddr,colAddr,readSize);//(BlockAddr,PageAddr,ColumnAddr)    
    if(PAGESIZE==0){
        if(TWO8BITNAND) DMACNoDescrp(NANDCHANNEL,NFDATA_ADDR,NOTSRCINC,WIDTHWORD,(unsigned int)readBuf,DESTINC,WIDTHWORD,TRANS32BYTE,TLEN1024);
        else            DMACNoDescrp(NANDCHANNEL,NFDATA_ADDR,NOTSRCINC,WIDTHWORD,(unsigned int)readBuf,DESTINC,WIDTHWORD,TRANS32BYTE,TLEN512);
        while((SMT_READ(NFSTAT)&RDEND)!=RDEND); //RdEnd check
        
        SMT_WRITE(NFSTAT,RDEND|RNBDETECT0);
        for(i=0;i<128;i++){
            //DPRINTF("READ Data[%x] \n",readBuf[i]);    
            if( readBuf[i] != 0xfefefefe){
                DPRINTF("NUM[%d] :: read data [%d] READ ERROR!!! \n",i,readBuf[i]);    
                GPIOWrite(0xeeee);
                while(1);
            }
        }
        DMACDisable(NANDCHANNEL);
    }
    else{
        if(TWO8BITNAND) DMACNoDescrp(NANDCHANNEL,NFDATA_ADDR,NOTSRCINC,WIDTHWORD,(unsigned int)readBuf,DESTINC,WIDTHWORD,TRANS32BYTE,TLEN4096);
        else            DMACNoDescrp(NANDCHANNEL,NFDATA_ADDR,NOTSRCINC,WIDTHWORD,(unsigned int)readBuf,DESTINC,WIDTHWORD,TRANS32BYTE,TLEN2048);
        while((SMT_READ(NFSTAT)&RDEND)!=RDEND); //RdEnd check
        
        SMT_WRITE(NFSTAT,RDEND|RNBDETECT0);
        for(i=0;i<512;i++){
            //DPRINTF("READ Data[%x] \n",readBuf[i]);    
            if( readBuf[i] != 0xfefefefe){
                DPRINTF("NUM[%d] :: read data [%d] READ ERROR!!! \n",i,readBuf[i]);    
                GPIOWrite(0xeeee);
                while(1);
            }
        }
        DMACDisable(NANDCHANNEL);
    }

    DPRINTF("DMA READ OK \n");    
}

/*-----------------------------------------------------------------------
    Function name   : DmaWrite()
    Prototype       : 
    Return          : 
    Argument        :
    Comments        : 
DMACNoDescrp(smtUint8 channel, smtUint32 SrcAddr, smtBoolean SrcIncrease, smtUint8 SWidth, smtUint32 DestAddr, 
             smtBoolean DstIncrease, smtUint8 DWidth, smtUint8 TransSize, smtUint16 TotalSize);    
-----------------------------------------------------------------------*/
void DmaWrite(smtUint16 blockAddr,smtUint16 pageAddr,smtUint16 colAddr,smtUint16 writeSize)
{
    int i;
    
    DPRINTF("-------- DMA Write --------\n");

    readBuf[0]=0xfefefefe;

    DMACEnable(NANDCHANNEL);
    SMT_WRITE(NFSTAT,WREND);
    SMT_WRITE(NFCTRL,FIFOLEVEL|DMAEN);
    
    PageWrite(blockAddr,pageAddr,colAddr,writeSize,WORD);
    if(PAGESIZE==0){
        if(TWO8BITNAND) DMACNoDescrp(NANDCHANNEL,(unsigned int)readBuf,NOTSRCINC,WIDTHWORD,NFDATA_ADDR,NOTDESTINC,WIDTHWORD,TRANS32BYTE,TLEN1024);
        else            DMACNoDescrp(NANDCHANNEL,(unsigned int)readBuf,NOTSRCINC,WIDTHWORD,NFDATA_ADDR,NOTDESTINC,WIDTHWORD,TRANS32BYTE,TLEN512);
        DPRINTF("- Write End Check -\n");
        while((SMT_READ(NFSTAT)&WREND)!=WREND);//WrEnd check
        SMT_WRITE(NFSTAT,WREND|RNBDETECT0);
        DMACDisable(NANDCHANNEL);
        DPRINTF("DMA Write OK \n\n");    
    }
    else{
        if(TWO8BITNAND) DMACNoDescrp(NANDCHANNEL,(unsigned int)readBuf,NOTSRCINC,WIDTHWORD,NFDATA_ADDR,NOTDESTINC,WIDTHWORD,TRANS32BYTE,TLEN4096);
        else            DMACNoDescrp(NANDCHANNEL,(unsigned int)readBuf,NOTSRCINC,WIDTHWORD,NFDATA_ADDR,NOTDESTINC,WIDTHWORD,TRANS32BYTE,TLEN2048);
        DPRINTF("- Write End Check -\n");
        while((SMT_READ(NFSTAT)&WREND)!=WREND);//WrEnd check
        SMT_WRITE(NFSTAT,WREND|RNBDETECT0);
        DMACDisable(NANDCHANNEL);
        DPRINTF("DMA Write OK \n\n");    
    }

}



