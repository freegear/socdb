/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 1999 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : Sdram_CAS1_2.c,v
--  File Revision          : 1.3
--
--  Release Information    : PrimeCell(TM)-PL170-REL2v2
--
-- ---------------------------------------------------------------------------*/
/******************************************************************************/
/* Purpose : This file verifies the SDRAM Controller functionality.           */
/*           The tb_Sdram_CAS1.v testbench needs to be used to run this       */
/*           vector set.                                                      */
/******************************************************************************/

/******************************************************************************/
/*** This C code file is used to generate BusTalk vectors.                  ***/
/*** BusTalk vectors are applied to the AMBA AHB bus.                       ***/
/***                                                                        ***/
/*** Files required for compilation:                                        ***/
/***   makefile, busheader.h, busmacros.h, busmacros.c,                     ***/
/***   config.h, addargs_script,                                            ***/
/***   Sdram_CAS1_2.c,Sdram_CAS1.h                                          ***/
/***                                                                        ***/
/*** Usage: make <testname> e.g. make Sdram_CAS1_2                          ***/
/***                                                                        ***/
/*** To create .bif/.sim formatted vectors from the BusTalk code (default)  ***/
/***   make <testname> e.g. make Sdram_CAS1_2                               ***/
/*** This will create testname.bif and testname.sim in the ../invec         ***/
/***   directory                                                            ***/
/***                                                                        ***/
/******************************************************************************/
 
/******************************************************************************/
/*** For more information on the Sdram, please refer to AMBA SDRAM PL170    ***/
/*** Technical Reference Manual                                             ***/
/******************************************************************************/

/******************************************************************************/
/*** Include common BusTalk files                                           ***/
/******************************************************************************/
#include "busmacros.h"
#include "busheader.h"
#include "config.h"
#include <stdio.h>
#include <stdarg.h>
#include <stdlib.h>
#include <time.h>
#include <string.h>
#include "Sdram_CAS1.h"

/******************************************************************************/
/************************* Function declarations ******************************/
/******************************************************************************/
/* SDRAM Functions */
void  WORDWrite(unsigned long,unsigned,unsigned*);
void  HWORDWrite(unsigned long,unsigned,unsigned*);
void  BYTEWrite(unsigned long,unsigned,unsigned*);
void  WORDRead(unsigned long,unsigned,unsigned*);
void  HWORDRead(unsigned long,unsigned,unsigned*);
void  BYTERead(unsigned long,unsigned,unsigned*);
void  datagen(unsigned,unsigned,unsigned*);
void  test_sequence(char*,char*,unsigned,unsigned long,unsigned*,
                    unsigned,char*,char*,unsigned,unsigned long,unsigned*);
void  sequence_of_transactions(unsigned long,unsigned*,unsigned long,unsigned*);
void  WaitLoop(int);
void  Memory_Tests();
void  Random_Test();
void  DegrantTest(int);
void  WordTrans(unsigned long, int, char BurstType[7], unsigned*, int,
                int, int, int, int);
void  WordRd(unsigned long, unsigned,char BurstType[7],unsigned*);
void  HWordTrans(unsigned long, int, char BurstType[7], unsigned*, int,
                 int, int, int, int);
void  HWordRd(unsigned long,unsigned,char BurstType[7],unsigned*);
void  ByteTrans(unsigned long, int, char BurstType[7], unsigned*, int, 
                int, int, int, int);
void  ByteRd(unsigned long,unsigned,char BurstType[7],unsigned*);
void  HBURSTTest();
void  RandHBURST();
void  LongHBURST(int);
void  DetHBURST();
void  FQWAccessLoop();
void  AHBPortFQWAccess(int);

int32 Addrgen(void);
int32 AddrgenBoundary(void);
int32 pagegen(int, int);
int32 colgen (int, int);
int32 AddrSwapAHB(int, int, int, int, int);
int32 DevBankCalc(int); 

/******************************************************************************/
/******************************* Global Variables *****************************/
/******************************************************************************/
unsigned byteset1[65536];
unsigned byteset2[65536];
unsigned byteset3[65536];
unsigned long data;
unsigned writebuffer = NO_OF_WRITE_BUFFERS;
unsigned readbuffer  = NO_OF_READ_BUFFERS;
unsigned checkpoint;

/******************************************************************************/
/******************************* Global Constants *****************************/
/******************************************************************************/
#define SEED 77

/* #define RANDOM */

/******************************************************************************/
/********************************  MAIN  **************************************/
/******************************************************************************/

int main() 
{

  time_t seed;

  TestStart(ZERO);

  /* Start of Compliance test program */

  /* Seed the random function */
  #ifdef RANDOM
    time(&seed);
  #else
    seed = SEED;
  #endif

  srand(seed);

  /* Assert Reset */
  RES(LOW,0x1,0x1);

  C("PORT 2 - WAIT FOR INITIALISATION");
  WaitLoop(0x400);

  C("FIVE QUADWORD ACCESSES - PORT 2");
  FQWAccessLoop();

  WaitLoop(0x100);

  C("MIXED LONG BURST ACCESSES - PORT 2");
  LongHBURST(29);

  C("MEMORY TESTS - PORT 2");
  Memory_Tests();

  C("RANDOM TESTS - PORT 2");
  Random_Test();

  /* Seeding the rand() function */
  srand(seed);

  C(" HBURST TESTS - PORT 2");
  HBURSTTest();

  C(" RANDOM HBURST TESTS - PORT 2");
  RandHBURST();

  C(" LONG HBURST TESTS - PORT 2");
  LongHBURST(35);

  C(" DETERMINISTIC HBURST TESTS - PORT 2");
  DetHBURST();

  C("DEGRANT TESTS - PORT 2");
  DegrantTest(0);

  C("BUSY DEGRANT TESTS - PORT 2");
  DegrantTest(1);

  C("END OF PORT 2 TESTS");

  WaitLoop(0x10);

  return 0;

}

/****************************************************************************/
/***************************** Memory Read/Write Tests **********************/
/****************************************************************************/
void Memory_Tests()
{
/*

 Summary : Memory_Tests
 ========================
 This will test the following functionality:
      
 o Single data transfers with different bus sizes (as word, 
   half word and byte).
 o Two, three and four data transfers to check for the 
   functionality of the design in a burst transfer.
 o It also takes care of switching between the write buffers
   and checking for the same functionality as mentioned above.
 o There are sequence of transactions that will meet various
   read hit / read miss / write hit / write miss with the
   number of clocks between two accesses varying with different
   values to check that the design handles all the transactions.

*/

 unsigned long addr,tempaddr,addr1,addr2;
 unsigned SDDev1,SDBnk1,SDPg1,SDDev2,SDBnk2,SDPg2;
 
 int i,j,k,wrbuf,x;
 char message[100];
 
 addr = AddrSwapAHB(0, 0, 0, 0x40, ADDRMAP) | SDRAMBase;
 addr1 = addr;

 /* Configure the testbench such that the default byte-alignment is used */
 /* ie. Little Endian                                                    */
 WaitLoop(2); 
 HSEN(LITTLE);
 
 C("SINGLE DATA TRANSFERS - PORT 2");

 /* To switch the buffers in the two buffer case */
 for(wrbuf=1;wrbuf<3;wrbuf++) 
 {
   /* This is to test all the words in a quadword */
   for(i=1;i<4;i++) 
   {
     /* This indicates word/hword/byte write access */
     for(j=1;j<2;j++) 
     {
       /* This indicates word/hword/byte read access */
       for(k=1;k<2;k++)
       {
         if(j==1)
         {
           /* This makes a hit to the write buffer */
           WORDWrite(addr,1,byteset1);
           for (x=0;x<4;x++)
           {
             HSA(addr,IDLE,SINGLE,OK,WRD);
             HSR(,,MaskAll,MaskAll);
           }
         }
         else if(j==2)
         {
           HWORDWrite(addr,1,byteset1);
           for (x=0;x<4;x++)
           {
             HSA(addr+2,IDLE,SINGLE,OK,HWRD);
             HSR(,,MaskAll,MaskAll);
           }
         }
         else
         {
           BYTEWrite(addr,1,byteset1);
           for (x=0;x<4;x++)
           {
             HSA(addr+1,IDLE,SINGLE,OK,BYTE);
             HSR(,,MaskAll,MaskAll);
           }
           BYTEWrite(addr+1,1,byteset1);
           for (x=0;x<4;x++)
           {
             HSA(addr+2,IDLE,SINGLE,OK,BYTE);
             HSR(,,MaskAll,MaskAll);
           }
           BYTEWrite(addr+2,1,byteset1);
           for (x=0;x<4;x++)
           {
             HSA(addr+3,IDLE,SINGLE,OK,BYTE);
             HSR(,,MaskAll,MaskAll);
           }
           BYTEWrite(addr+3,1,byteset1);
         }
         for (x=0;x<4;x++)
         {
           HSA(addr,IDLE,SINGLE,OK,BYTE);
           HSR(,,MaskAll,MaskAll);
         }
         if(k==1)
         {
           /* This makes a hit to the read buffer */
           WORDRead(addr,1,byteset1);
         }
         else if(k==2)
         {
           HWORDRead(addr,1,byteset1);
           for (x=0;x<4;x++)
           {
             HSA(addr+2,IDLE,SINGLE,OK,HWRD);
             HSR(,,MaskAll,MaskAll);
           }
           HWORDRead(addr+2,1,byteset1);
         }
         else
         {
           BYTERead(addr,1,byteset1);
           for (x=0;x<4;x++)
           {
             HSA(addr+1,IDLE,SINGLE,OK,BYTE);
             HSR(,,MaskAll,MaskAll);
           }
           BYTERead(addr+1,1,byteset1);
           for (x=0;x<4;x++)
           {
             HSA(addr+2,IDLE,SINGLE,OK,BYTE);
             HSR(,,MaskAll,MaskAll);
           }
           BYTERead(addr+2,1,byteset1);
           for (x=0;x<4;x++)
           {
             HSA(addr+3,IDLE,SINGLE,OK,BYTE);
             HSR(,,MaskAll,MaskAll);
           }
           BYTERead(addr+3,1,byteset1);
         }
         addr = addr + 4;
         for (x=0;x<4;x++)
         {
           HSA(addr,IDLE,SINGLE,OK,WRD);
           HSR(,,MaskAll,MaskAll);
         }
       }
     }
   }
   /* The following writes are to different quadword. so that it should
      switch the buffers in the two write buffer case */
   if(writebuffer == 2)
   { 
     C("SWAPPING THE WRITE BUFFERS - PORT 2");
     WORDWrite(addr,1,byteset1);
     for (x=0;x<4;x++)
     {
       HSA(addr,IDLE,SINGLE,OK,WRD);
       HSR(,,MaskAll,MaskAll);
     }
     WORDWrite(addr+20,1,byteset2);
     for (x=0;x<4;x++)
     {
       HSA(addr+20,IDLE,SINGLE,OK,WRD);
       HSR(,,MaskAll,MaskAll);
     }
     WORDRead(addr+20,1,byteset2);
   }
   else
   {
     break;
   }
 }
 
 C("TWO DATA TRANSFERS - PORT 2");
 addr = addr1 + 0X20;

 /* To switch the buffers in the two buffer case */
 for(wrbuf=1;wrbuf<3;wrbuf++)
 {
   /* The following tests quad word 0 and 1 */
   
   WORDWrite(addr,2,byteset1);
   for (x=0;x<4;x++)
   {
     HSA(addr,IDLE,SINGLE,OK,WRD);
     HSR(,,MaskAll,MaskAll);
   }
   WORDRead(addr,2,byteset1);
   for (x=0;x<4;x++)
   {
     HSA(addr,IDLE,SINGLE,OK,WRD);
     HSR(,,MaskAll,MaskAll);
   }
   
   addr = addr + 4;
   /* The following tests quad word 1 and 2 */
   WORDWrite(addr,2,byteset1);
   for (x=0;x<4;x++)
   {
     HSA(addr,IDLE,SINGLE,OK,WRD);
     HSR(,,MaskAll,MaskAll);
   }
   WORDRead(addr,2,byteset1);
   for (x=0;x<4;x++)
   {
     HSA(addr,IDLE,SINGLE,OK,WRD);
     HSR(,,MaskAll,MaskAll);
   }
   
   addr = addr + 4;
   WORDWrite(addr,2,byteset1);
   for (x=0;x<4;x++)
   {
     HSA(addr,IDLE,SINGLE,OK,WRD);
     HSR(,,MaskAll,MaskAll);
   }
   WORDRead(addr,2,byteset1);
   for (x=0;x<4;x++)
   {
     HSA(addr,IDLE,SINGLE,OK,WRD);
     HSR(,,MaskAll,MaskAll);
   }
   
   /* The following writes are to different quadword. so that it should
      switch the buffers in the two write buffer case */
   if(writebuffer == 2)
   {
     C("SWAPPING THE WRITE BUFFERS - PORT 2");
     WORDWrite(addr,1,byteset1);
     for (x=0;x<4;x++)
     {
       HSA(addr,IDLE,SINGLE,OK,WRD);
       HSR(,,MaskAll,MaskAll);
     }
     WORDWrite(addr+20,1,byteset2);
     for (x=0;x<4;x++)
     {
       HSA(addr+20,IDLE,SINGLE,OK,WRD);
       HSR(,,MaskAll,MaskAll);
     }
     WORDRead(addr+20,1,byteset2);
     for (x=0;x<4;x++)
     {
       HSA(addr,IDLE,SINGLE,OK,WRD);
       HSR(,,MaskAll,MaskAll);
     }
     addr = addr1 + 0x40;
   }
   else
   {
     break;
   }
 }
 
 C("THREE DATA TRANSFERS - PORT 2");
 addr = addr1 + 0X40;
 /* The following tests quad word 0,1 and 2 */

 /* To switch the buffers in the two buffer case */
 for(wrbuf=1;wrbuf<3;wrbuf++)
 {
   WORDWrite(addr,3,byteset1);
   for (x=0;x<4;x++)
   {
     HSA(addr,IDLE,SINGLE,OK,WRD);
     HSR(,,MaskAll,MaskAll);
   }
   WORDRead(addr,3,byteset1);
 
   addr = addr + 4;
   WORDWrite(addr,3,byteset1);
   for (x=0;x<4;x++)
   {
     HSA(addr,IDLE,SINGLE,OK,WRD);
     HSR(,,MaskAll,MaskAll);
   }
   WORDRead(addr,3,byteset1);
 
   /* The following writes are to different quadword. so that it should
      switch the buffers in the two write buffer case */
   if(writebuffer == 2)
   {
     C("SWAPPING THE WRITE BUFFERS - PORT 2");
     WORDWrite(addr,1,byteset1);
     for (x=0;x<4;x++)
     {
       HSA(addr,IDLE,SINGLE,OK,WRD);
       HSR(,,MaskAll,MaskAll);
     }
     WORDWrite(addr+20,1,byteset2);
     for (x=0;x<4;x++)
     {
       HSA(addr+20,IDLE,SINGLE,OK,WRD);
       HSR(,,MaskAll,MaskAll);
     }
     WORDRead(addr+20,1,byteset2);
   }
   else
   {
     break;
   }
 }
 
 C("FOUR DATA TRANSFERS - PORT 2");
 addr = addr1;
 /* The following tests quad word 0,1,2 and 3 */

 /* To switch the buffers in the two buffer case */
 for(wrbuf=1;wrbuf<3;wrbuf++) 
 {
   WORDWrite(addr,4,byteset1);
   for (x=0;x<4;x++)
   {
     HSA(addr,IDLE,SINGLE,OK,WRD);
     HSR(,,MaskAll,MaskAll);
   }
   WORDRead(addr,4,byteset1);
   /* The following writes are to different quadword. so that it should
      switch the buffers in the two write buffer case */
   if(writebuffer == 2)
   {
     C("SWAPPING THE WRITE BUFFERS - PORT 2");
     WORDWrite(addr,1,byteset1);
     for (x=0;x<4;x++)
     {
       HSA(addr,IDLE,SINGLE,OK,WRD);
       HSR(,,MaskAll,MaskAll);
     }
     WORDWrite(addr+20,1,byteset2);
     for (x=0;x<4;x++)
     {
       HSA(addr+20,IDLE,SINGLE,OK,WRD);
       HSR(,,MaskAll,MaskAll);
     }
     WORDRead(addr+20,1,byteset2);
   }
   else
   {
     break;
   }
 }
 addr = addr + 4;
 
 C("START OF SEQUENCE OF TRANSACTIONS - PORT 2");

 addr1 = AddrSwapAHB(1, 0, 2, 0, ADDRMAP) | SDRAMBase;
 addr2 = AddrSwapAHB(1, 1, 3, 0, ADDRMAP) | SDRAMBase;

 sequence_of_transactions(addr1 + 0x60,byteset1,addr2 + 0x60,byteset1);
 for (i = 0; i < 4; i++)
 {
   HSA(addr1,IDLE,SINGLE,OK,WRD,0x7FFFFFFF, , ,0);
   HSR(,,MaskAll,MaskAll);
 }
} 

/****************************************************************************/
/**************************** Data Array Generation *************************/
/****************************************************************************/
void datagen(unsigned position,unsigned size,unsigned *bytedata)
{
/*

 Summary : datagen
 =================
 This function generates bytewide random data. The inputs are the
 starting address, number of data and the array to store the data.

*/

 unsigned i;
 char message[100];

 for(i=position;i<(position+size);i++)
 {
   bytedata[i] = (rand() % 256);
 }
}
 
/****************************************************************************/
/******************************* Word Write *********************************/
/****************************************************************************/
void WORDWrite(unsigned long address,unsigned datacount,unsigned *bytedata)
{
/*

 Summary : WORDWrite
 ===================
 This function generates the AHB slave test bench instructions for
 a wordwide write access. The starting address of the write access
 is the input address. The number of data transfers in the write
 access is same as the input datacount and the data is stored in
 the respective address of the bytedata array input.

*/

 unsigned start=0;
 unsigned index=0;
 unsigned i=0;
 
 C("Writing full word - PORT 2");
 
 start   = ((address/4) % (8*8192));
 index   = 4*start;
 address = (address/4) * 4;
 HSA(address,NSEQ,INCR,OK,WRD,0x7FFFFFFF, , ,0);
 datagen(index,4,bytedata);
 data = bytedata[index+3]*16777216+
        bytedata[index+2]*65536   +
        bytedata[index+1]*256     +
        bytedata[index];
 HSW(,data);
 address  = address + 4;
 for(i = 1; i < (datacount - 1); i++)
 {
   index=4*(i+start);
   datagen(index,4,bytedata);
   data = bytedata[index+3]*16777216+
          bytedata[index+2]*65536   +
          bytedata[index+1]*256     +
          bytedata[index];
   HSW(,data);
 }
}
 
/****************************************************************************/
/******************************* Halfword Write *****************************/
/****************************************************************************/
void HWORDWrite(unsigned long address,unsigned datacount,unsigned *bytedata)
{
/*

 Summary : HWORDWrite
 ====================
 This function generates the AHB slave test bench instructions for
 a half-wordwide write access. The starting address of the write access
 is the input address. The number of data transfers in the write
 access is same as the input datacount and the data is stored in
 the respective address of the bytedata array input.

*/

 unsigned start=0;
 unsigned index=0;
 unsigned i=0;
 
 C("Writing Half word - PORT 2");
 
 start = (address/2) % 16384;
 address = (address/2) * 2;
 for(i=start;i<(start+datacount);i++)
 {
   index = 2*i;
   datagen(index,2,bytedata);
   if(i%2)
   {
     data = bytedata[index+1]*16777216+
            bytedata[index]*65536     +
            (rand() % 256)*256        +
            (rand() % 256);
     data = bytedata[index+1]*256 +
            bytedata[index];
   }
   else
   {
     data =(rand() % 256)*16777216+
           (rand() % 256)*65536   +
           bytedata[index+1]*256  +
           bytedata[index];
     data = bytedata[index+1]*256 +
             bytedata[index];
   }
   HSA(address,NSEQ,INCR,OK,HWRD,0x7FFFFFFF, , ,0);
   HSW(,data);
   address = address + 2;
 }
 HSA(address,IDLE,INCR,OK,HWRD,0x7FFFFFFF, , ,0);
 HSR(,,MaskAll,MaskAll);
}
 
/****************************************************************************/
/********************************** Byte Write ******************************/
/****************************************************************************/
void BYTEWrite(unsigned long address,unsigned datacount,unsigned *bytedata)
{
/*

 Summary : BYTEWrite
 ===================
 This function generates the AHB slave test bench instructions for
 a bytewide write access. The starting address of the write access
 is the input address. The number of data transfers in the write
 access is same as the input datacount and the data is stored in
 the respective address of the bytedata array input.

*/

 unsigned start=0;
 unsigned index=0;
 unsigned i=0;
 unsigned position=0;
 
 C("Writing Byte - PORT 2");
 
 start = (address % 32768);
 for(i=start;i<(start+datacount);i++)
 {
   index = i;
   datagen(index,1,bytedata);
   position = i%4;
   if(position==3)
   {
     data = bytedata[index]*16777216 +
            (rand() % 256)*65536     +
            (rand() % 256)*256       +
            (rand() % 256);
   }
   else if(position==2)
   {
     data = (rand() % 256)*16777216 +
            bytedata[index]*65536   +
            (rand() % 256)*256      +
            (rand() % 256);
   }
   else if(position==1)
   {
     data = (rand() % 256)*16777216 +
            (rand() % 256)*65536    +
            bytedata[index]*256     +
            (rand() % 256);
   }
   else
   {
     data = (rand() % 256)*16777216 +
            (rand() % 256)*65536    +
            (rand() % 256)*256      +
            bytedata[index];
   }
   data = bytedata[index];
   HSA(address,NSEQ,INCR,OK,BYTE,0x7FFFFFFF, , ,0);
   HSW(,data);
   address = address + 1;
 }
 HSA(address,IDLE,INCR,OK,BYTE,0x7FFFFFFF, , ,0);
 HSR(,,MaskAll,MaskAll);
}
 
/****************************************************************************/
/******************************* Word Read **********************************/
/****************************************************************************/
void WORDRead(unsigned long address,unsigned datacount,unsigned *bytedata)
{
/*

 Summary : WORDRead
 ==================
 This function generates the AHB slave test bench instructions for
 a wordwide read access. The starting address of the read access
 is the input address. The number of data transfers in the read
 access is same as the input datacount and the data is stored in
 the respective address of the bytedata array input.

*/

 unsigned start=0;
 unsigned index=0;
 unsigned i=0;
 
 C("Reading full word - PORT 2");
 
 start=((address/4) % 8192);
 index=4*start;
 address = (address/4) * 4;
 HSA(address,NSEQ,INCR,OK,WRD,0x7FFFFFFF, , ,0);
 data = (bytedata[index+3]*16777216)+
        (bytedata[index+2]*65536)   +
        (bytedata[index+1]*256)     +
        bytedata[index];
 HSR(,data,MaskAll,0xFFFFFFF);
 address = address + 4;
 for(i=1;i<(datacount-1);i++)
 {
   index=4*(i+start);
   data = (bytedata[index+3]*16777216)+
          (bytedata[index+2]*65536)   +
          (bytedata[index+1]*256)     +
          bytedata[index];
   HSR(,data,MaskAll,0xFFFFFFF);
 }
}
 
/****************************************************************************/
/******************************* Halfword Read ******************************/
/****************************************************************************/
void HWORDRead(unsigned long address,unsigned datacount,unsigned *bytedata)
{
/*

 Summary : HWORDRead
 ===================
 This function generates the AHB slave test bench instructions for
 a half-wordwide read access. The starting address of the read access
 is the input address. The number of data transfers in the read
 access is same as the input datacount and the data is stored in
 the respective address of the bytedata array input.

*/

 unsigned start=0;
 unsigned index=0;
 unsigned i=0;
 
 C("Reading Half word - PORT 2");
 
 start = ((address/2) % 16384);
 index = 2*start;
 address = (address/2) * 2;
 for(i=start;i<(start+datacount);i++)
 {
   data = (bytedata[index+1]*16777216)+
          (bytedata[index]*65536)     +
          (bytedata[index+1]*256)     +
          bytedata[index];
   HSA(address,NSEQ,INCR,OK,HWRD,0x7FFFFFFF, , ,0);
   HSR(,data,MaskAll,0xFFFFFFF);
   index = index + 2;
   address = address + 2;
 }
}
 
/****************************************************************************/
/********************************** Byte Read *******************************/
/****************************************************************************/
void BYTERead(unsigned long address,unsigned datacount,unsigned *bytedata)
{
/*

 Summary : BYTERead
 ==================
 This function generates the AHB slave test bench instructions for
 a bytewide read access. The starting address of the read access
 is the input address. The number of data transfers in the read
 access is same as the input datacount and the data is stored in
 the respective address of the bytedata array input.

*/

 unsigned start=0;
 unsigned index=0;
 unsigned i=0;
 
 C("Reading Byte - PORT 2");
 
 start = (address % 32768);/* Address bits 0 to 12 are extracted */
 index = start;
 for(i=start;i<(start+datacount);i++)
 {
   data = (bytedata[index]*16777216)+
          (bytedata[index]*65536)   +
          (bytedata[index]*256)     +
          bytedata[index];
   HSA(address,NSEQ,INCR,OK,BYTE,0x7FFFFFFF, , ,0);
   HSR(,data,MaskAll,0xFFFFFFF);
   index = index + 1;
   address = address + 1;
 }
}

/****************************************************************************/
/***************************** Sequence of Transactions *********************/
/****************************************************************************/
void sequence_of_transactions(unsigned long address1,unsigned *bytedata1,
                              unsigned long address2,unsigned *bytedata2)
{
/*

 Summary : sequence_of_transactions
 ==================================
 This function generates a sequence of read and write transactions
 to the memory with various address, bus size, burst and number of
 clocks between two successive transactions. This is to test the
 ability of the design to handle various transactions on the bus.

*/

 int i,j,k;
 int check = 0;
 char message[80];

 /* This is used to have a stable data in the memory before 
    starting the following tests */
 WORDWrite(address1,8,bytedata1); 

 /* This is used to have a stable data in the memory before 
    starting the following tests */
 WORDWrite(address2,8,bytedata2); 

 /* The following test cases are targeted  */
 /* WriteHit(empty buffer) - WriteHit(Valid Data)
    WriteHit(Valid Data) - Read Access hits write buffer
    Read - Read hit to read buffer
    Read - Write access hits the read buffer
 */

 for(i=1;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","word",i,address1,bytedata1,k,
                     "write","word",j,address1,bytedata1);
       test_sequence("read","word",i,address1,bytedata1,k,
                     "read","word",j,address1,bytedata1);

       /* This will switch the write buffer in the two write buffer case */
       if(writebuffer == 2)
       {
         WORDWrite(address1+10,1,byteset3);
         WORDRead(address1+10,1,byteset3);
       }

     }
   }
 }

 /* The following test cases are targeted  */
 /* WriteHit(empty buffer) - WriteMiss
    Write - Read access that does not hit the write buffer
    Read  - Read Misss to the read buffer
    Read  - Write access that does not hit the read buffer
 */
 /* In the two write buffer case, this will switch the buffers
    due to the write miss transactions.   */

 for(i=1;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","word",i,address1,bytedata1,k,
                     "write","word",j,address2,bytedata2);
       test_sequence("read","word",i,address1,bytedata1,k,
                     "read","word",j,address2,bytedata2);
     }
   }
 }

 /* Following are the test cases targeted */
 /* The bus size changes for the successive transactions */
 /* WriteHit(empty buffer) - WriteHit(Valid Data)
    WriteHit(Valid Data) - Read Access hits write buffer
    Read - Read hit to read buffer
    Read - Write access hits the read buffer
 */
 for(i=1;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","word",i,address2,bytedata2,k,
                     "write","half_word",j,address2,bytedata2);
       test_sequence("read","word",i,address2,bytedata2,k,
                     "read","half_word",j,address2,bytedata2);
       /*This will switch the write buffer in the two write buffer case */
       if(writebuffer == 2)
       {
         WORDWrite(address1+10,1,byteset3);
         WORDRead(address1+10,1,byteset3);
       }
     }
   }
 }

 /* Following are the test cases targeted */
 /* The bus size changes for successive transactions */
 /* WriteHit(empty buffer) - WriteMiss
    Write - Read access that does not hit the write buffer
    Read  - Read Misss to the read buffer
    Read  - Write access that does not hit the read buffer
 */
 /* In the two write buffer case, this will switch the buffers
    due to the write miss transactions.   */

 for(i=1;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","word",i,address2,bytedata2,k,
                     "write","half_word",j,address1,bytedata1);
       test_sequence("read","word",i,address2,bytedata2,k,
                     "read","half_word",j,address1,bytedata1);
     }
   }
 }

 /* Following test cases are targeted */
 /* The bus size is different for successive transactions */
 /* WriteHit(empty buffer) - WriteHit(Valid Data)
    WriteHit(Valid Data) - Read Access hits write buffer
    Read - Read hit to read buffer
    Read - Write access hits the read buffer
 */
 for(i=2;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","word",i,address1,bytedata1,k,
                     "write","byte",j,address1,bytedata1);
       test_sequence("read","word",i,address1,bytedata1,k,
                     "read","byte",j,address1,bytedata1);
       /*This will switch the write buffer in the two write buffer case */
       if(writebuffer == 2)
       {
         WORDWrite(address1+10,1,byteset3);
         WORDRead(address1+10,1,byteset3);
       }
     }
   }
 }

 /* Following test cases are targeted */
 /* The bus sizes are different for successive transactions */
 /* WriteHit (empty buffer) - WriteMiss
    Write - Read access hit to the write buffer
    Read - ReadMiss to the read buffer
    Read - Write access hit to the read buffer
 */

 for(i=2;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","word",i,address1,bytedata1,k,
                     "write","byte",j,address2,bytedata2);
       test_sequence("read","word",i,address2,bytedata2,k,
                     "read","byte",j,address1,bytedata1);
      }
    }
 }

 /* This is used to verify the stable data in the memory */
 WORDRead(address1,8,bytedata1);

 /* This is used to verify the stable data in the memory */
 WORDRead(address2,8,bytedata2);

 /* This is used to have a stable data in the memory before 
    starting the following tests */
 HWORDWrite(address1+0x55,16,bytedata1); 

 /* This is used to have a stable data in the memory before 
    starting the following tests */
 HWORDWrite(address2+0x55,16,bytedata2); 

 /* Following test cases are targeted */
 /* The bus sizes are different for successive transactions */
 /* Write - WriteHit to write buffer
    Write - Read access hit the write buffer
    Read  - Read access hit the read buffer
    Read  - Write access hit the read buffer
 */

 for(i=2;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","half_word",i,address1+0x55,bytedata1,k,
                     "write","word",j,address1+0x55,bytedata1);
       test_sequence("read","half_word",i,address1+0x55,bytedata1,k,
                     "read","word",j,address1+0x55,bytedata1);
       /*This will switch the write buffer in the two write buffer case */
       if(writebuffer == 2)
       {
         WORDWrite(address1+10,1,byteset3);
         WORDRead(address1+10,1,byteset3);
       }
     }
   }
 }

 /* Following test cases are targeted */
 /* The bus sizes are different for successive transactions */
 /* Write - WriteMiss to the write buffer
          Write - ReadMiss to the write buffer
          Read  - ReadMiss to the read buffer
          Read  - WriteMiss to the read buffer 
 */

 for(i=2;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","half_word",i,address1+0x55,bytedata1,k,
                     "write","word",j,address2+0x55,bytedata2);
       test_sequence("read","half_word",i,address1+0x55,bytedata1,k,
                     "read","word",j,address2+0x55,bytedata2);
     }
   }
 }

 /* Following test cases are targeted */
 /* Write - WriteHit to the write buffer
    Write - ReadHit to the write buffer
    Read  - ReadHit to the read buffer
    Read  - WriteHit to the read buffer
 */

 for(i=1;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","half_word",i,address2+0x55,bytedata2,k,
                     "write","half_word",j,address2+0x55,bytedata2);
       test_sequence("read","half_word",i,address2+0x55,bytedata2,k,
                     "read","half_word",j,address2+0x55,bytedata2);
       /*This will switch the write buffer in the two write buffer case */
       if(writebuffer == 2)
       {
         WORDWrite(address1+10,1,byteset3);
         WORDRead(address1+10,1,byteset3);
       }
     }
   }
 }


 /* Following test cases are targeted */
 /* Write - WriteMiss to the write buffer
    Write - ReadMiss to the write buffer
    Read  - ReadMiss to the read buffer
    Read  - WriteMiss to the read buffer
 */

 for(i=2;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","half_word",i,address2+0x55,bytedata2,k,
                     "write","half_word",j,address1+0x55,bytedata1);
       test_sequence("read","half_word",i,address2+0x55,bytedata2,k,
                     "read","half_word",j,address1+0x55,bytedata1);
     }
   }
 }

 /* Following test cases are targeted */
 /* The bus sizes are different for successive transactions */
 /* Write - WriteMiss to the write buffer
    Write - ReadHit to the write buffer
    Read  - ReadMiss to the read buffer
    Write - WriteHit to the read buffer
 */

 for(i=1;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","half_word",i,address1+0x55,bytedata1,k,
                     "write","byte",j,address2+0x55,bytedata2);
       test_sequence("read","half_word",i,address2+0x55,bytedata2,k,
                     "read","byte",j,address1+0x55,bytedata1);
     }
   }
 }

 /* Following test cases are targeted */
 /* The bus sizes are different for successive transactions */
 /* Write - WriteMiss to the write buffer
    Write - ReadHit to the write buffer
    Read  - ReadMiss to the read buffer
    Read  - WriteHit to the read buffer
 */

 for(i=2;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","half_word",i,address2+0x55,bytedata2,k,
                     "write","byte",j,address1+0x55,bytedata1);
       test_sequence("read","half_word",i,address1+0x55,bytedata1,k,
                     "read","byte",j,address2+0x55,bytedata2);
     }
   }
 }

 /* This is used to verify the stable data in the memory */
 HWORDRead(address1+0x55,16,bytedata1);

 /* This is used to verify the stable data in the memory */
 HWORDRead(address2+0x55,16,bytedata2);

 /* This is used to have a stable data in the memory before 
    starting the following tests */
 BYTEWrite(address1+0xAA,32,bytedata1); 

 /* This is used to have a stable data in the memory before 
    starting the following tests */
 BYTEWrite(address2+0xAA,32,bytedata2); 

 /* Following test cases are targeted */
 /* The bus sizes are different for successive transactions */
 /* Write - WriteHit to the write buffer
    Write - ReadHit to the write buffer
    Read  - ReadHit to the read buffer
    Read  - WriteHit to the read buffer
 */
 for(i=1;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","byte",i,address1+0xAA,bytedata1,k,
                     "write","word",j,address1+0xAA,bytedata1);
       test_sequence("read","byte",i,address1+0xAA,bytedata1,k,
                     "read","word",j,address1+0xAA,bytedata1);
       /*This will switch the write buffer in the two write buffer case */
       if(writebuffer == 2)
       {
         WORDWrite(address1+10,1,byteset3);
         WORDRead(address1+10,1,byteset3);
       }
     }
   }
 }


 /* Following test cases are targeted */
 /* The bus sizes are different for successive transactions */
 /* Write - WriteMiss to the write buffer
    Write - ReadMiss to the write buffer
    Read  - ReadMiss to the read buffer
    Read  - WriteMiss to the read buffer
 */

 for(i=2;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","byte",i,address1+0xAA,bytedata1,k,
                     "write","word",j,address2+0xAA,bytedata2);
       test_sequence("read","byte",i,address1+0xAA,bytedata1,k,
                     "read","word",j,address2+0xAA,bytedata2);
     }
   }
 }


 /* Following test cases are targeted */
 /* The bus sizes are different for successive transactions */
 /* Write - WriteMiss to the write buffer
    Write - ReadHit to the write buffer
    Read  - ReadMiss to the read buffer
    Read  - WriteHit to the read buffer
 */

 for(i=1;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","byte",i,address1+0xAA,bytedata1,k,
                     "write","half_word",j,address2+0xAA,bytedata2);
       test_sequence("read","byte",i,address2+0xAA,bytedata2,k,
                     "read","half_word",j,address1+0xAA,bytedata1);
     }
   }
 }

 /* Following test cases are targeted */
 /* The bus sizes are different for successive transactions */
 /* Write - WriteHit to the write buffer
    Write - ReadHit to the write buffer
    Read  - ReadHit to the read buffer
    Read  - WriteHit to the read buffer
 */

 for(i=1;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","byte",i,address2+0xAA,bytedata2,k,
                     "write","half_word",j,address2+0xAA,bytedata2);
       test_sequence("read","byte",i,address2+0xAA,bytedata2,k,
                     "read","half_word",j,address2+0xAA,bytedata2);
       /*This will switch the write buffer in the two write buffer case */
       if(writebuffer == 2)
       {
         WORDWrite(address1+10,1,byteset3);
         WORDRead(address1+10,1,byteset3);
       }
     }
   }
 }

 /* Following test cases are targeted */
 /* Write - WriteMiss to the write buffer
    Write - ReadMiss to the write buffer
    Read  - ReadMiss to the read buffer
    Read  - WriteMiss to the read buffer
 */

 for(i=1;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","byte",i,address2+0xAA,bytedata2,k,
                     "write","byte",j,address1+0xAA,bytedata1);
       test_sequence("read","byte",i,address2+0xAA,bytedata2,k,
                     "read","byte",j,address1+0xAA,bytedata1);
     }
   }
 }


 /* Following test cases are targeted */
 /* Write - WriteMiss to the write buffer
    Write - ReadHit to the write buffer
    Read  - ReadMiss to the read buffer
    Read  - WriteHit to the read buffer
 */

 for(i=2;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","byte",i,address2+0xAA,bytedata2,k,
                     "write","byte",j,address1+0xAA,bytedata1);
       test_sequence("read","byte",i,address1+0xAA,bytedata1,k,
                     "read","byte",j,address2+0xAA,bytedata2);
       /*This will switch the write buffer in the two write buffer case */
       if(writebuffer == 2)
       {
         WORDWrite(address1+10,1,byteset3);
         WORDRead(address1+10,1,byteset3);
       }
     }
   }
 }


 /* This is used to verify the stable data in the memory */
 BYTERead(address1+0xAA,32,bytedata1);

 /* This is used to verify the stable data in the memory */
 BYTERead(address2+0xAA,32,bytedata2);


 /* This is used to have a stable data in the memory before 
    starting the following tests */
 WORDWrite(address1+0x100,8,bytedata1); 

 /* This is used to have a stable data in the memory before 
    starting the following tests */
 WORDWrite(address2+0x100,8,bytedata2); 

 for(i=1;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","word",i,address1+0x100,bytedata1,k,
                     "read","word",j,address1+0x100,bytedata1);
       test_sequence("read","word",i,address2+0x100,bytedata2,k,
                     "write","word",j,address2+0x100,bytedata2);
     }
   }
 }

 for(i=2;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","word",i,address1+0x100,bytedata1,k,
                     "read","word",j,address2+0x100,bytedata2);
       test_sequence("read","word",i,address1+0x100,bytedata1,k,
                     "write","word",j,address2+0x100,bytedata2);
     }
   }
 }


 for(i=1;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","word",i,address2+0x100,bytedata2,k,
                     "read","half_word",j,address2+0x100,bytedata2);
       test_sequence("read","word",i,address1+0x100,bytedata1,k,
                     "write","half_word",j,address1+0x100,bytedata1);
     }
   }
 }


 for(i=2;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","word",i,address2+0x100,bytedata2,k,
                     "read","half_word",j,address2+0x100,bytedata2);
       test_sequence("read","word",i,address2+0x100,bytedata2,k,
                     "write","half_word",j,address2+0x100,bytedata2);
       /*This will switch the write buffer in the two write buffer case */
       if(writebuffer == 2)
       {
         WORDWrite(address1+10,1,byteset3);
         WORDRead(address1+10,1,byteset3);
       }
     }
   }
 }


 for(i=1;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","word",i,address1+0x100,bytedata1,k,
                     "read","byte",j,address2+0x100,bytedata2);
       test_sequence("read","word",i,address1+0x100,bytedata1,k,
                     "write","byte",j,address2+0x100,bytedata2);
     }
   }
 }


 for(i=2;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","word",i,address1+0x100,bytedata1,k,
                     "read","byte",j,address1+0x100,bytedata1);
       test_sequence("read","word",i,address2+0x100,bytedata2,k,
                     "write","byte",j,address2+0x100,bytedata2);
     }
   }
 }


 /* This is used to verify the stable data in the memory */
 WORDRead(address1+0x100,8,bytedata1);

 /* This is used to verify the stable data in the memory */
 HWORDRead(address2+0x100,8,bytedata2);

 /* This is used to have a stable data in the memory before 
    starting the following tests */
 WORDWrite(address1+0x155,8,bytedata1); 

 /* This is used to have a stable data in the memory before 
    starting the following tests */
 WORDWrite(address2+0x155,8,bytedata2); 

 for(i=1;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","half_word",i,address1+0x155,bytedata1,k,
                     "read","word",j,address1+0x155,bytedata1);
       test_sequence("read","half_word",i,address1+0x155,bytedata1,k,
                     "write","word",j,address1+0x155,bytedata1);
       /*This will switch the write buffer in the two write buffer case */
       if(writebuffer == 2)
       {
         WORDWrite(address1+10,1,byteset3);
         WORDRead(address1+10,1,byteset3);
       }
     }
   }
 }

 for(i=2;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","half_word",i,address1+0x155,bytedata1,k,
                     "read","word",j,address2+0x155,bytedata2);
       test_sequence("read","half_word",i,address1+0x155,bytedata1,k,
                     "write","word",j,address2+0x155,bytedata2);
     }
   }
 }

 for(i=1;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","half_word",i,address2+0x155,bytedata2,k,
                     "read","half_word",j,address2+0x155,bytedata2);
       test_sequence("read","half_word",i,address1+0x155,bytedata1,k,
                     "write","half_word",j,address1+0x155,bytedata1);
     }
   }
 }


 for(i=1;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","half_word",i,address1+0x155,bytedata1,k,
                     "read","half_word",j,address2+0x155,bytedata2);
       test_sequence("read","half_word",i,address2+0x155,bytedata2,k,
                     "write","half_word",j,address1+0x155,bytedata1);
       /*This will switch the write buffer in the two write buffer case */
       if(writebuffer == 2)
       {
         WORDWrite(address1+10,1,byteset3);
         WORDRead(address1+10,1,byteset3);
       }
     }
   }
 }

 for(i=2;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","half_word",i,address1+0x155,bytedata1,k,
                     "read","byte",j,address2+0x155,bytedata2);
       test_sequence("read","half_word",i,address1+0x155,bytedata1,k,
                     "write","byte",j,address1+0x155,bytedata1);
       /*This will switch the write buffer in the two write buffer case */
       if(writebuffer == 2)
       {
         WORDWrite(address1+10,1,byteset3);
         WORDRead(address1+10,1,byteset3);
       }
     }
   }
 }

 for(i=2;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","half_word",i,address1+0x155,bytedata1,k,
                     "read","byte",j,address2+0x155,bytedata2);
       test_sequence("read","half_word",i,address2+0x155,bytedata2,k,
                     "write","byte",j,address2+0x155,bytedata2);
     }
   }
 }


 /* This is used to verify the stable data in the memory */
 WORDRead(address1+0x155,8,bytedata1);

 /* This is used to verify the stable data in the memory */
 HWORDRead(address2+0x155,8,bytedata2);

 /* This is used to have a stable data in the memory before 
    starting the following tests */
 WORDWrite(address1+0x1B0,8,bytedata1); 

 /* This is used to have a stable data in the memory before 
    starting the following tests */
 WORDWrite(address2+0x1B0,8,bytedata2); 

 for(i=1;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","byte",i,address1+0x1B0,bytedata1,k,
                     "read","word",j,address2+0x1B0,bytedata2);
       test_sequence("read","byte",i,address2+0x1B0,bytedata2,k,
                     "write","word",j,address2+0x1B0,bytedata2);
     }
   }
 }

 for(i=1;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","byte",i,address1+0x1B0,bytedata1,k,
                     "read","word",j,address1+0x1B0,bytedata1);
       test_sequence("read","byte",i,address1+0x1B0,bytedata1,k,
                     "write","word",j,address2+0x1B0,bytedata2);
     }
   }
 }

 for(i=2;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","byte",i,address1+0x1B0,bytedata1,k,
                     "read","half_word",j,address2+0x1B0,bytedata2);
       test_sequence("read","byte",i,address1+0x1B0,bytedata1,k,
                     "write","half_word",j,address2+0x1B0,bytedata2);
     }
   }
 }

 for(i=2;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","byte",i,address1+0x1B0,bytedata1,k,
                     "read","half_word",j,address2+0x1B0,bytedata2);
       test_sequence("read","byte",i,address2+0x1B0,bytedata2,k,
                     "write","half_word",j,address1+0x1B0,bytedata1);
       /*This will switch the write buffer in the two write buffer case */
       if(writebuffer == 2)
       {
         WORDWrite(address1+10,1,byteset3);
         WORDRead(address1+10,1,byteset3);
       }
     }
   }
 }

 for(i=1;i<5;i=i+2)
 {
   for(j=1;j<5;j=j+2)
   {
     for(k=1;k<5;k=k+2)
     {
       test_sequence("write","byte",i,address1+0x1B0,bytedata1,k,
                     "read","byte",j,address2+0x1B0,bytedata2);
       test_sequence("read","byte",i,address2+0x1B0,bytedata2,k,
                     "write","byte",j,address1+0x1B0,bytedata1);
       /*This will switch the write buffer in the two write buffer case */
       if(writebuffer == 2)
       {
         WORDWrite(address1+10,1,byteset3);
         WORDRead(address1+10,1,byteset3);
       }
     }
   }
 }

 for(i=2;i<5;i=i+2)
 {
   for(j=2;j<5;j=j+2)
   {
     for(k=2;k<5;k=k+2)
     {
       test_sequence("write","byte",i,address1+0x1B0,bytedata1,k,
                     "read","byte",j,address1+0x1B0,bytedata1);
       test_sequence("read","byte",i,address1+0x1B0,bytedata1,k,
                     "write","byte",j,address1+0x1B0,bytedata1);
       /*This will switch the write buffer in the two write buffer case */
       if(writebuffer == 2)
       {
         WORDWrite(address1+10,1,byteset3);
         WORDRead(address1+10,1,byteset3);
       }
     }
   }
 }

 /* This is used to verify the stable data in the memory */
 WORDRead(address1+0x1B0,8,bytedata1);

 /* This is used to verify the stable data in the memory */
 HWORDRead(address2+0x1B0,8,bytedata2);
 for (i=0;i<4;i++)
 {
   HSA(address2,IDLE,SINGLE,OK,WRD,0x7FFFFFFF, , ,0);
   HSR(,,MaskAll,MaskAll);
 }
} 

/****************************************************************************/
/********************* Sequence of Reads/Writes to Memory *******************/
/****************************************************************************/
void test_sequence(char* xfer1,char* bussize1,unsigned beats1,
                   unsigned long address1,unsigned *bytedata1,
                   unsigned idle,char* xfer2,char* bussize2,unsigned beats2,
                   unsigned long address2,unsigned *bytedata2)
{
/*

 Summary : test_sequence
 =======================
 This function issues two successive transactions on the bus with
 the given parameters such as transfer type (xferx), bus size (bussizex),
 number of data transfers (beatsx), starting address (addressx) and
 the corresponding data arrays (bytedatax). This is used in the function
 sequence_of_transactions() to generate various sequeences. It issues
 all the transactions in terms of WORDWrite(), HWORDWrite(), BYTEWrite(),
 WORDRead(), HWORDRead() and BYTERead() functions.

*/

 int i;
 char message[100];

 /*  Sequence of transactions */
 if(xfer1 == "write")
 {
   /* Memory write 1 */
   if(bussize1 == "word")
   {
     /* Bus size: word */
     WORDWrite(address1,beats1,bytedata1);
   }
   else if(bussize1 == "half_word")
   {
     /* Bus size: half word "); */
     HWORDWrite(address1,beats1,bytedata1);
   }
   else if(bussize1 == "byte")
   {
     /* Bus size: byte */
     BYTEWrite(address1,beats1,bytedata1);
   }
   else
   {
     C("seq: INVALID BUS SIZE - PORT 2");
   }
 }
 else if(xfer1 == "read")
 {
   /* Memory read 1 */
   if(bussize1 == "word")
   {
     /* Bus size: word */
     WORDRead(address1,beats1,bytedata1);
   }
   else if(bussize1 == "half_word")
   {
     /* Bus size: Half word */
     HWORDRead(address1,beats1,bytedata1);
   }
   else if(bussize1 == "byte")
   {
     /* Bus size: Byte */
     BYTERead(address1,beats1,bytedata1);
   }
   else
   {
     C("seq: INVALID BUS SIZE - PORT 2");
   }
 }
 else
 {
   C("seq: INVALID TRANSFER TYPE - PORT 2");
 }

 for (i=0;i<4;i++)
 {
   HSA(address2,IDLE,SINGLE,OK,BYTE,0x7FFFFFFF, , ,0);
   HSR(,,MaskAll,MaskAll, ,idle);
 }

 if(xfer2 == "write")
 {
   /* Memory write 2 */
   if(bussize2 == "word")
   {
     /* Bus size: word */
     WORDWrite(address2,beats2,bytedata2);
   }
   else if(bussize2 == "half_word")
   {
     /* Bus size: Half word */
     HWORDWrite(address2,beats2,bytedata2);
   }
   else if(bussize2 == "byte")
   {
     /* Bus size: Byte */
     BYTEWrite(address2,beats2,bytedata2);
   }
   else
   {
     C("seq: INVALID BUS SIZE"); 
   }
 }
 else if(xfer2 == "read")
 {
   /* Memory read 2 */
   if(bussize2 == "word")
   {
     /* C("seq:       BUS SIZE: WORD"); */
     WORDRead(address2,beats2,bytedata2);
   }
   else if(bussize2 == "half_word")
   {
     /* Bus size: Half word */
     HWORDRead(address2,beats2,bytedata2);
   }
   else if(bussize2 == "byte")
   {
     /* Bus size: Byte */
     BYTERead(address2,beats2,bytedata2);
   }
   else
   {
     C("seq: INVALID BUS SIZE - PORT 2");
   }
 }
 else
 {
   C("seq: INVALID TRANSFER TYPE - PORT 2");
 }

 checkpoint = checkpoint + 1;
 sprintf(message,"Checkpoint : %d - PORT 2",checkpoint);
 C(message);
}

/****************************************************************************/
/***************************** Random Read/Write Tests **********************/
/****************************************************************************/
void Random_Test()
{
/*

 Summary : Random_Test
 =====================
 This function generates a random sequence of transactions. Initially
 it fills 100 locations of wordwide data in the memory in two groups.
 After that it can initiate a random sequence of transactions to any
 of the locations with various parameters such as address, bus size,
 burst size and the number of idle clocks etc.

*/
 
 unsigned long addr;
 unsigned long addr1, addr2, coladdr;
 unsigned *byteset;
 int Xaction,i,j,idlecycle,beats1,beats2;
 char str[300];
 
 /* Configure the testbench such that the default byte-alignment is used */
 /* ie. Little Endian                                                    */
 WaitLoop(2); 
 HSEN(LITTLE);

 C("RANDOM SEQUENCE OF TESTING");
  
 addr1 = AddrSwapAHB(2, 0, 2, 0, ADDRMAP) | SDRAMBase;
 WORDWrite(addr1,100,byteset1);
 WORDRead(addr1,100,byteset1);
  
 addr2 = AddrSwapAHB(2, 0, 3, 0, ADDRMAP) | SDRAMBase;
 WORDWrite(addr2,100,byteset2);
 WORDRead(addr2,100,byteset2);

 for(Xaction = 1;Xaction <= 100;Xaction++)
 {
   coladdr =  (rand() % 80);
   if ((rand() % 2) == 1)
   {
     addr = AddrSwapAHB(2, 0, 2, coladdr, ADDRMAP) | SDRAMBase;
     byteset = byteset1;
   }
   else
   {
     addr = AddrSwapAHB(2, 0, 3, coladdr, ADDRMAP) | SDRAMBase;
     byteset = byteset2;
   }

   i = (rand() % 4)+1;
   j = (rand() % 4)+1;
   beats1 = (rand() % 16) + 1;
   beats2 = (rand() % 16) + 1;
   idlecycle = (rand() % 10) + 1;
   if(i==1)
   {
     WORDWrite(addr,beats1,byteset);
   }
   else if(i==2)
   {
     HWORDWrite(addr,beats1,byteset);
   }
   else
   {
     BYTEWrite(addr,beats1,byteset);
   }
   for (i=0;i<idlecycle-1;i++)
   {
     HSA(addr,IDLE,SINGLE,OK,BYTE,0x7FFFFFFF, , ,0);
     HSR(,,MaskAll,MaskAll);
   }
   if(j==1)
   {
     WORDRead(addr,beats2,byteset);
   }
   else if(j==2)
   {
     HWORDRead(addr,beats2,byteset);
   }
   else
   {
     BYTERead(addr,beats2,byteset);
   }
   addr = addr + 4;
   for (i=0;i<4;i++)
   {
     HSA(addr,IDLE,SINGLE,OK,BYTE,0x7FFFFFFF, , ,0);
     HSR(,,MaskAll,MaskAll);
   }
 }
}

/******************************************************************************/
/**************************  Insert Idle clocks *******************************/
/******************************************************************************/
void WaitLoop(int cycles)
{
/*

 Summary : Idle cycle insertion Loop
 ===================================
 o The number of Idle cycles inserted will be determined by the
   integer 'cycles'

*/
 
 int i;
 
 for (i = 1; i <= cycles; i++)
 {
   HSA(DATA0, IDLE, INCR, , , , , , , , , ,idle);
   HSR(, ZERO, , , ,idlecycle);
 }
}

/****************************************************************************/
/********************** Memory Address Generation Function ******************/
/****************************************************************************/
int32 Addrgen(void)
{
/*

 Summary : Memory Address Generation
 ===================================
 This function generates a random memory address. 

*/

 int Device, DevBank, Bank, Page, col, Address;

 Device = 0;
 DevBank = DevBankCalc(0);
 Bank = rand() % DevBank;
 Page = 0;
 col =  (rand() % 0x20) + 0x40;
 Address = AddrSwapAHB(Device, Bank, Page, col, ADDRMAP);
 return Address;
}

/****************************************************************************/
/******* Memory Address Generation Function for boundary crossing ***********/
/****************************************************************************/
int32 AddrgenBoundary (void)
{
/*

 Summary : Memory Address Generation
 ===================================
 This function generates a random memory address. It mainly targets 
 addresses that will result in crossing of pages and banks in the same 
 device.

*/

 int Device, Bank, Page, col;
 int DevBank, LastBank, LastPage, LastCol, Address, temp;
 char str[1000];

 temp = rand() % 16;
 Device = rand() % 4;
 DevBank = DevBankCalc(Device);
 LastBank = DevBank - 1;
 LastPage = pagegen(Device, 2);
 LastCol = colgen(Device, 2);

 if (temp == 0)
 {
   /* First 16 words of page 2 */
   Bank = 0;
   Page = 2;
   col  = 0xC;
 }
 else if (temp == 1)
 {
   /* First 16 words of page */
   Bank = 0;
   Page = LastPage - 2;
   col  = 0xC;
 }
 else if (temp == 2)
 {
   /* Last QW of page 0, bank 1 */
   Bank = 1;
   Page = 2;
   col  = LastCol - 0x3;
 }
 else if (temp == 3)
 {
   /* Last 8 words of page, bank 1 */
   Bank = 1;
   Page = LastPage - 3;
   col  = LastCol - 0x7; 
 }
 else if (temp == 4)
 {
   /* Last QW of last page, bank 1, Device 0- bank crossing, QW aligned */
   Device = 2;
   Bank = 0;
   Page = pagegen(Device, 2);
   col  = colgen(Device, 2) - 0x3;
 }
 else if (temp == 5)
 {
   /*Last 3 words of last but one page bank 0 - non QW aligned page crossing*/
   Bank = 0;
   Page = LastPage - 3;
   col  = LastCol - 0x2;
 }
 else if (temp == 6)
 {
   /* Last word of bank 0, last page - bank crossing, non QW aligned */
   Device = 2;
   Bank = 0;
   Page = pagegen(Device, 2);
   col = colgen(Device, 2);
 }
 else if (temp == 7)
 {
   /* 16 words of page, bank 0 - starting from QW1 */
   Bank = 0;
   Page = LastPage - 3;
   col  = 0x10;
 }
 else if (temp == 8)
 {
   /* Last 16 words of last page of bank 0 */
   Device = 2;
   Bank = 0;
   Page = pagegen(Device, 2);
   col  = colgen(Device, 2) - 0xF;
 }
 else if (temp == 9)
 {
   /* Last 12 words of page 2, bank 1 - page crossing, non QQW aligned */
   Bank = 1;
   Page = 2;
   col  = LastCol - 0xB;
 }
 else if (temp == 10)
 {
   /* Last 8 words of last page, bank 0 - bank crossing, non QQW aligned */
   Device = 2;
   Bank = 0;
   Page = pagegen(Device, 2);
   col  = colgen(Device, 2) - 0x7;
 }
 else if (temp == 11)
 {
   /* HBURST boundary crossing */ 
   Bank = 1;
   Page = LastPage - 3;
   col  = 0x2;
 }
 else if (temp == 12)
 {
   /* Last QW of page 2, last bank - page crossing*/
   Bank = LastBank;
   Page = 2;
   col  = LastCol - 0x3;
 }
 else if (temp == 13)
 {
   /* Last 3 QWs of page 2 last but one bank - non QQW aligned page crossing*/
   Bank = LastBank - 1;
   Page = 2;
   col  = LastCol - 0xB;
 }
 else if (temp == 14)
 {
   /*Last word, last but third page, last bank - non QW aligned page crossing*/
   Bank = LastBank;
   Page = LastPage - 3;
   col  = LastCol;
 }
 else if (temp == 15)
 {
   /* Second QW of page 3, last but one bank - HBURST boundary crossing */
   Bank = LastBank - 1;
   Page = 3;
   col  = 0x4;
 }

 Address = AddrSwapAHB(Device, Bank, Page, col, ADDRMAP);
 return Address;
}

/******************************************************************************/
/******************************* HBURST Test **********************************/
/******************************************************************************/
void HBURSTTest()
{
/*

 Summary : HBURSTTest
 =====================
 This will test the following functionality:

 o Byte, Half Word & Word data transfers from the AHB port with
   different HBURST types. The temp variable decides the HBURST type.

 o For each HBURST type, there is a random  sequence of Byte, Half word 
   or Word data transfers.

 o The starting address generated for each data transfer are aligned 
   depending upon the data size. Also ensure that the burst 
   will not exceed the 1 K boundary.

 o Busy states are inserted in each data transfer type either after the 
   first NSEQ or after the first SEQ depending upon the value of Position 
   variable. The number of busy states is decided by the variable BusyCnt.
 
 o When the writes are completed the datas are read back using the AHB port.
   For the Half word and Byte reads the corresponding datas are reproduced
   on the remaining lines of the data bus also. 

*/

 unsigned Addr, SDADDR, LoBits, Bound;
 int      temp, j, DataCnt;
 int      BusyCnt = 0;
 int      Position1 = 0, PosnCount1 = 0, Position2 = 0, PosnCount2 = 0;
 int      DataSize= 0, WordSel, HWordSel, ByteSel;
 int      Byte[4]   = {B0, B1, B2, B3};
 int      HWord[2]  = {HW0, HW1};
 int      Word[4]   = {W0, W1, W2, W3};
 char*    Burst[8]  = { SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8, WRAP16,
                        INCR16 };
 
 
 /* Configure the testbench such that the default byte-alignment is used */
 /* ie. Little Endian                                                    */
 WaitLoop(2); 
 HSEN(LITTLE);
 
 for (temp = 0; temp < 8; temp++)
 {
   if (temp == 0)
   {
     DataCnt  = 1;
     C(" Transfer with HBURST type SINGLE ");
   }
   else if (temp == 1)
   {
     DataCnt  = 1;
     C(" Transfer with HBURST type INCR ");
   }
   else if (temp == 2)
   {
     DataCnt = 4;
     C(" Transfer with HBURST type WRAP4 ");
   }
   else if (temp == 3)
   {
     DataCnt = 4;
     C(" Transfer with HBURST type INCR4 ");
   }
   else if (temp == 4)
   {
     DataCnt = 8;
     C(" Transfer with HBURST type WRAP8 ");
   }
   else if (temp == 5)
   {
     DataCnt = 8;
     C(" Transfer with HBURST type INCR8 ");
   }
   else if (temp == 6)
   {
     DataCnt = 16;
     C(" Transfer with HBURST type WRAP16 ");
   }
   else if (temp == 7)
   {
     DataCnt = 16;
     C(" Transfer with HBURST type INCR16 ");
   }
   else 
   {
     DataCnt = 1;
     BusyCnt  = 0;
     Position1 = 0;
     PosnCount1 = 0;
     Position2 = 0;
     PosnCount2 = 0;
   }
 
   for (j = 0; j < 10; j++) 
   {
 
     DataSize   = (rand() % 3) + 1;
     SDADDR     = Addrgen() | SDRAMBase;
     WordSel    = rand() % 4;
     HWordSel   = rand() % 2;
     ByteSel    = rand() % 4;
 
     if ( temp < 2 ) 
     {
       BusyCnt    = 0;
       Position1  = 0;
       PosnCount1 = 0;
       Position2  = 0;
       PosnCount2 = 0;
     }
     else
     {
       BusyCnt    = rand() % 30;
       Position1  = (rand() % (DataCnt - 1));
       PosnCount1 = (rand() % (DataCnt - Position1));
       Position2  = (rand() % (DataCnt - Position1 - PosnCount1)) + 
                    Position1 +
                    PosnCount1;
       PosnCount2 = (rand() % (DataCnt - Position2));
     }
 
     if (DataSize == 1)
     {
 
       C(" Byte Transfer ");
       Addr       = SDADDR + Word[WordSel] + HWord[HWordSel] + Byte[ByteSel];
 
       if (temp % 2 == 1)
       {
         LoBits = Addr & 0x03FF;
         Bound  = LoBits + DataCnt;
         if (Bound > 1024)
           Addr = Addr - DataCnt;
       }
 
       ByteTrans(Addr,DataCnt,Burst[temp],byteset1,BusyCnt,Position1,PosnCount1,
                 Position2, PosnCount2); 
       WaitLoop(0x10);
       ByteRd(Addr,DataCnt,Burst[temp],byteset1);
     }
     else if (DataSize == 2)
     {
 
       C(" Halfword Transfer ");
 
       Addr       = SDADDR + Word[WordSel] + HWord[HWordSel]; 
       if (temp % 2 == 1)
       {
         LoBits = Addr & 0x03FF;
         Bound  = LoBits + (DataCnt * 2);
         if (Bound > 1024)
           Addr = Addr - (DataCnt * 2);
       }
 
       HWordTrans(Addr,DataCnt,Burst[temp],byteset1,BusyCnt,Position1,
                  PosnCount1, Position2, PosnCount2); 
       WaitLoop(0x15);
       HWordRd(Addr,DataCnt,Burst[temp],byteset1);
     }
     else
     {
       C(" Word Transfer ");
 
       Addr       = SDADDR + Word[WordSel]; 
       if (temp % 2 == 1) 
       {
         LoBits = Addr & 0x03FF;
         Bound  = LoBits + (DataCnt * 4);
         if (Bound > 1024)
           Addr = Addr - (DataCnt * 4);
       }
 
       WordTrans(Addr,DataCnt,Burst[temp],byteset1,BusyCnt,Position1,PosnCount1,
                 Position2, PosnCount2); 
       WaitLoop(0x1A);
       WordRd(Addr,DataCnt,Burst[temp],byteset1);
     }
   }
 }
 /* Configure the testbench such that the default byte-alignment */
 /* is over-riden                                                */
 WaitLoop(2);
 HSEN(DISABLE);
}

/******************************************************************************/
/*************************** Half Word Transfer *******************************/
/******************************************************************************/
void HWordTrans(unsigned long address,int datacount,char BurstType[7], 
                unsigned bytedata[128], int BusyCnt, int Position1, 
                int PosnCount1, int Position2, int PosnCount2)
{
/*

 Summary : Half Word Transfer
 ============================
 This function can issue Half Word data transfers from the AHB ports in all
 the HBURST types.It can also insert any number of BUSY states in the
 data transfer anywhere in the burst. The BUSY states can be inserted in any
 2 sets of positions in the burst. The positions of the burst where the BUSY
 states are to be inserted are decided by the input arguments Position1 and
 Position2. The number of Positions starting from Position1 where the busy
 states are to be inserted is decided by the input argument PosnCount1.
 Similarly, PosnCount2 decides the number of positions in which the busy
 states are to be inserted starting from Position2. The number of BUSY
 states that are inserted each time is decided by the input argument BusyCnt 

*/

 unsigned index=0;
 unsigned i=0,data;
 int      count = 1, count1, count2;
 int      Mask, k;

 if (datacount != 0)
 {
   HSA(address,NSEQ,BurstType,OK,HWRD,0x7FFFFFFF);

   index = ((address) % 64);

   datagen(index,2,bytedata);
   data  = bytedata[index+1]*256     +
           bytedata[index];

   HSW(,data, ,HWwrite);

   if (datacount > Position1)
   {
     if (Position1 >= 1) 
     {
       for (i = 0; i < Position1; i++)
       {
         if (BurstType == WRAP4) 
         {
           Mask      = address & 0x0007;
           if (Mask == 0x06)
             address = address - 0x06;
           else 
             address = address + 2;
         }
         else if (BurstType == WRAP8) 
         {
           Mask      = address & 0x000F;
           if (Mask == 0x00E)
             address = address - 0x00E;
           else 
             address = address + 2;
         }
         else if (BurstType == WRAP16) 
         {
           Mask      = address & 0x001F;
           if (Mask == 0x01E)
             address = address - 0x01E;
           else 
             address = address + 2;
         }
         else 
           address    = address + 2;

         HSA(address,SEQ,BurstType,OK,HWRD,0x7FFFFFFF);
         index = ((address) % 64);

         datagen(index,2,bytedata);
         data  = bytedata[index+1] * 256 +
                 bytedata[index];

         HSW(,data, ,HWwrite);
         count += 1;
       }
     }
  
     if (PosnCount1 > 0)
     {
       if (BusyCnt != 0)
       {
         for (k = 0; k < BusyCnt; k++)
         {
           HSA(,BUSY, ,OK,HWRD,0x7FFFFFFF, , ,0);
           HSW(,data, ,Busydata);
         }
       }
     }

     if (datacount > 1)
     {
       if (datacount >= (Position1 + PosnCount1))
         count1 = PosnCount1;
       else
       {
         count1 = datacount - Position1 - 1;
         C("Invalid values :Datacount is lesser than (Position1 + PosnCount1)");
       }
       for (i = 1; i< count1; i++)
       {
         if (BurstType == WRAP4) 
         {
           Mask      = address & 0x0007;
           if (Mask == 0x06)
             address = address - 0x06;
           else 
             address = address + 2;
         }
         else if (BurstType == WRAP8) 
         {
           Mask      = address & 0x00F;
           if (Mask == 0x00E)
             address = address - 0x00E;
           else 
             address = address + 2;
         }
         else if (BurstType == WRAP16) 
         {
           Mask      = address & 0x001F;
           if (Mask == 0x01E)
             address = address - 0x01E;
           else 
             address = address + 2;
         }
         else 
           address    = address + 2;

         HSA(address,SEQ,BurstType,OK,HWRD,0x7FFFFFFF);

         index = ((address) % 64);
         datagen(index,2,bytedata);
         data  = bytedata[index+1]*256     +
                 bytedata[index];

         HSW(,data, ,HWwrite);
         count += 1;

         if (BusyCnt != 0)
         {
           for (k = 0; k < BusyCnt; k++)
           {
             HSA(,BUSY, ,OK,HWRD,0x7FFFFFFF, , ,0);
             HSW(,data, ,Busydata);
           }
         }
       }
     }
   }

   for (i = count ; i < (Position2 + 1); i++)
   {
     if (BurstType == WRAP4) 
     {
       Mask      = address & 0x0007;
       if (Mask == 0x06)
         address = address - 0x06;
       else 
         address = address + 2;
     }
     else if (BurstType == WRAP8) 
     {
       Mask      = address & 0x00F;
       if (Mask == 0x00E)
         address = address - 0x00E;
       else 
         address = address + 2;
     }
     else if (BurstType == WRAP16) 
     {
       Mask      = address & 0x001F;
       if (Mask == 0x01E)
         address = address - 0x01E;
       else 
         address = address + 2;
     }
     else 
       address    = address + 2;

     HSA(address,SEQ,BurstType,OK,HWRD,0x7FFFFFFF);

     index = ((address) % 64);
     datagen(index,2,bytedata);
     data  = bytedata[index+1]*256     +
             bytedata[index];

     HSW(,data, ,HWwrite);
     count += 1;
   }
 
   if ((PosnCount2 > 0) && (Position2 < datacount) &&
      (Position2 >= (Position1 + PosnCount1)))
   {
     if (BusyCnt != 0)
     {
       for (k = 0; k < BusyCnt; k++)
       {
         HSA(,BUSY, ,OK,HWRD,0x7FFFFFFF, , ,0);
         HSW(,data, ,Busydata);
       }
     }
   }

   if ((datacount > Position2) && (datacount > count))
   {
     if (Position2 >= (Position1 + PosnCount1))
     {
       if (datacount > (Position2 + PosnCount2))
         count2 = PosnCount2;
       else
       {
         count2 = datacount - Position2 - 1;
         C("Invalid values :Datacount is lesser than (Position2 + PosnCount2)");
       }
       for (i = 1; i< count2; i++)
       {
         if (BurstType == WRAP4) 
         {
           Mask      = address & 0x0007;
           if (Mask == 0x06)
             address = address - 0x06;
           else 
             address = address + 2;
         }
         else if (BurstType == WRAP8) 
         {
           Mask      = address & 0x00F;
           if (Mask == 0x00E)
             address = address - 0x00E;
           else 
             address = address + 2;
         }
         else if (BurstType == WRAP16) 
         {
           Mask      = address & 0x001F;
           if (Mask == 0x01E)
             address = address - 0x01E;
           else 
             address = address + 2;
         }
         else 
           address    = address + 2;

         HSA(address,SEQ,BurstType,OK,HWRD,0x7FFFFFFF);

         index = ((address) % 64);
         datagen(index,2,bytedata);
         data  = bytedata[index+1]*256     +
                 bytedata[index];

         HSW(,data, ,HWwrite);
         count += 1;

         if (BusyCnt != 0)
         {
           for (k = 0; k < BusyCnt; k++)
           {
             HSA(,BUSY, ,OK,HWRD,0x7FFFFFFF, , ,0);
             HSW(,data, ,Busydata);
           }
         }
       }
     }
     else if (PosnCount2 != 0)
     {
       if ((Position1 != Position2) && (PosnCount2 != 0))
         C("Invalid values :Position2 is lesser than Position1");
       else if (Position2 < (Position1 + PosnCount1))
         C("Invalid values :Position2 is lesser than (Position1 + PosnCount1)");
     }
   }

   for (i = count ; i < datacount; i++)
   {
     if (BurstType == WRAP4) 
     {
       Mask      = address & 0x0007;
       if (Mask == 0x06)
         address = address - 0x06;
       else 
         address = address + 2;
     }
     else if (BurstType == WRAP8) 
     {
       Mask      = address & 0x00F;
       if (Mask == 0x00E)
         address = address - 0x00E;
       else 
         address = address + 2;
     }
     else if (BurstType == WRAP16) 
     {
       Mask      = address & 0x001F;
       if (Mask == 0x01E)
         address = address - 0x01E;
       else 
         address = address + 2;
     }
     else 
       address    = address + 2;

     HSA(address,SEQ,BurstType,OK,HWRD,0x7FFFFFFF);

     index = ((address) % 64);
     datagen(index,2,bytedata);
     data  = bytedata[index+1]*256     +
             bytedata[index];

     HSW(,data, ,HWwrite);
   }
 }
}

/****************************************************************************/
/***************************** Half Word Read *******************************/
/****************************************************************************/
void HWordRd(unsigned long address,unsigned datacount,char BurstType[7], 
            unsigned bytedata[128])
{
/*

 Summary : HWordRd
 =================
 This function generates the AHB slave test bench instructions for
 a halfwordwide read access. The starting address of the read access
 is the input address. The number of data transfers in the read
 access is same as the input datacount and the data is stored in
 the respective address of the bytedata array input.
*/

 unsigned index=0;
 unsigned i=0,data;
 int      Mask;

 if (datacount != 0)
 {
   HSA(address,NSEQ,BurstType,OK,HWRD,0x7FFFFFFF);
   index = ((address) % 64);
   data  = (bytedata[index+1]*16777216) +
           (bytedata[index]*65536)      +
           (bytedata[index+1]*256)      +
            bytedata[index];

   HSR(,data,MaskAll,0xFFFFFFFF, ,firstHWdRd);

   for (i = 1; i<datacount ; i++)
   {
     if (BurstType == WRAP4) 
     {
       Mask      = address & 0x0007;
       if (Mask == 0x06)
         address = address - 0x06;
       else 
         address = address + 2;
     }
     else if (BurstType == WRAP8) 
     {
       Mask      = address & 0x00F;
       if (Mask == 0x0E)
         address = address - 0x0E;
       else 
         address = address + 2;
     }
     else if (BurstType == WRAP16) 
     {
       Mask      = address & 0x001F;
       if (Mask == 0x01E)
         address = address - 0x01E;
       else 
         address = address + 2;
     }
     else 
       address    = address + 2;

     HSA(address,SEQ,BurstType,OK,HWRD,0x7FFFFFFF);

     index = (address % 64);
     data  = (bytedata[index+1]*16777216) +
             (bytedata[index]*65536)      +
             (bytedata[index+1]*256)      +
              bytedata[index];

     HSR(,data,MaskAll,0xFFFFFFFF, ,HWordRd);
   }
 }
}

/******************************************************************************/
/****************************   Byte Transfer   *******************************/
/******************************************************************************/
void ByteTrans(unsigned long address,int datacount,char BurstType[7], 
               unsigned bytedata[128], int BusyCnt, int Position1, 
               int PosnCount1, int Position2, int PosnCount2)
{
/*

 Summary : Byte Transfer
 =========================
 This function can issue Byte data transfers from the AHB ports in all
 the HBURST types.It can also insert any number of BUSY states in the
 data transfer anywhere in the burst. The BUSY states can be inserted in any
 2 sets of positions in the burst. The positions of the burst where the BUSY
 states are to be inserted are decided by the input arguments Position1 and
 Position2. The number of Positions starting from Position1 where the busy
 states are to be inserted is decided by the input argument PosnCount1.
 Similarly, PosnCount2 decides the number of positions in which the busy
 states are to be inserted starting from Position2. The number of BUSY
 states that are inserted each time is decided by the input argument BusyCnt

*/

 unsigned index=0;
 unsigned i=0,data;
 int      Mask, k;
 int      count = 1, count1, count2;

 if (datacount != 0)
 {
   HSA(address,NSEQ,BurstType,OK,BYTE,0x7FFFFFFF);
 
   index = ((address) % 64);

   datagen(index,1,bytedata);
   data  = bytedata[index];

   HSW(,data, ,bytewrite);

   if (datacount > Position1)
   {
     if (Position1 >= 1)
     {
       for (i = 0; i < Position1; i++)
       {
         if (BurstType == WRAP4) 
         {
           Mask      = address & 0x003;
           if (Mask == 0x03)
             address = address - 0x03;
           else 
             address = address + 1;
         }
         else if (BurstType == WRAP8) 
         {
           Mask      = address & 0x007;
           if (Mask == 0x07)
             address = address - 0x07;
           else 
             address = address + 1;
         }
         else if (BurstType == WRAP16) 
         {
           Mask      = address & 0x00F;
           if (Mask == 0x0F)
             address = address - 0x0F;
           else 
             address = address + 1;
         }
         else 
           address    = address + 1;

         HSA(address,SEQ,BurstType,OK,BYTE,0x7FFFFFFF);
         index = ((address) % 64);

         datagen(index,1,bytedata);
         data  = bytedata[index];

         HSW(,data, ,bytewrite);
         count += 1;
       }
     }
  
     if (PosnCount1 > 0)
     {
       if (BusyCnt != 0)
       {
         for (k = 0; k < BusyCnt; k++)
         {
           HSA(,BUSY, ,OK,BYTE,0x7FFFFFFF, , ,0);
           HSW(,data, ,Busydata);
         }
       }
     }

     if (datacount > 1)
     {
       if (datacount >= (Position1 + PosnCount1))
         count1 = PosnCount1;
       else
       {
         count1 = datacount - Position1 - 1;
         C("Invalid values :Datacount is lesser than (Position1 + PosnCount1)");
       }
       for (i = 1; i < count1; i++)
       {
         if (BurstType == WRAP4) 
         {
           Mask      = address & 0x003;
           if (Mask == 0x03)
             address = address - 0x03;
           else 
             address = address + 1;
         }
         else if (BurstType == WRAP8) 
         {
           Mask      = address & 0x007;
           if (Mask == 0x07)
             address = address - 0x07;
           else 
             address = address + 1;
         }
         else if (BurstType == WRAP16) 
         {
           Mask      = address & 0x00F;
           if (Mask == 0x0F)
             address = address - 0x0F;
           else 
             address = address + 1;
         }
         else 
           address    = address + 1;

         HSA(address,SEQ,BurstType,OK,BYTE,0x7FFFFFFF);

         index = ((address) % 64);

         datagen(index,1,bytedata);
         data  = bytedata[index];

         HSW(,data, ,bytewrite);
         count += 1;

         if (BusyCnt != 0)
         {
           for (k = 0; k < BusyCnt; k++)
           {
             HSA(,BUSY, ,OK,BYTE,0x7FFFFFFF, , ,0);
             HSW(,data, ,Busydata);
           }
         }
       }
     }
   }

   for (i = count; i < (Position2 + 1); i++)
   {
     if (BurstType == WRAP4) 
     {
       Mask      = address & 0x003;
       if (Mask == 0x03)
         address = address - 0x03;
       else 
         address = address + 1;
     }
     else if (BurstType == WRAP8) 
     {
       Mask      = address & 0x007;
       if (Mask == 0x07)
         address = address - 0x07;
       else 
         address = address + 1;
     }
     else if (BurstType == WRAP16) 
     {
       Mask      = address & 0x00F;
       if (Mask == 0x0F)
         address = address - 0x0F;
       else 
         address = address + 1;
     }
     else 
       address    = address + 1;

     HSA(address,SEQ,BurstType,OK,BYTE,0x7FFFFFFF);

     index = ((address) % 64);

     datagen(index,1,bytedata);
     data  = bytedata[index];

     HSW(,data, ,bytewrite);
     count += 1;
   }
   
   if ((PosnCount2 > 0) && (Position2 < datacount) &&
      (Position2 >= (Position1 + PosnCount1)))
   {
     if (BusyCnt != 0)
     {
       for (k = 0; k < BusyCnt; k++)
       {
         HSA(,BUSY, ,OK,WRD,0x7FFFFFFF, , ,0);
         HSW(,data, ,Busydata);
       }
     }
   }

   if ((datacount > Position2) && (datacount > count))
   {
     if (Position2 >= (Position1 + PosnCount1))
     {
       if (datacount > (Position2 + PosnCount2))
         count2 = PosnCount2;
       else
       {
         count2 = datacount - Position2 - 1;
         C("Invalid values :Datacount is lesser than (Position2 + PosnCount2)");
       }
       for (i = 1; i < count2; i++)
       {
         if (BurstType == WRAP4) 
         {
           Mask      = address & 0x003;
           if (Mask == 0x03)
             address = address - 0x03;
           else 
             address = address + 1;
         }
         else if (BurstType == WRAP8) 
         {
           Mask      = address & 0x007;
           if (Mask == 0x07)
             address = address - 0x07;
           else 
             address = address + 1;
         }
         else if (BurstType == WRAP16) 
         {
           Mask      = address & 0x00F;
           if (Mask == 0x0F)
             address = address - 0x0F;
           else 
             address = address + 1;
         }
         else 
           address    = address + 1;

         HSA(address,SEQ,BurstType,OK,BYTE,0x7FFFFFFF);

         index = ((address) % 64);

         datagen(index,1,bytedata);
         data  = bytedata[index];

         HSW(,data, ,bytewrite);
         count += 1;

         if (BusyCnt != 0)
         {
           for (k = 0; k < BusyCnt; k++)
           {
             HSA(,BUSY, ,OK,BYTE,0x7FFFFFFF, , ,0);
             HSW(,data, ,Busydata);
           }
         }
       }
     }
     else if (PosnCount2 != 0)
     {
       if ((Position1 != Position2) && (PosnCount2 != 0))
         C("Invalid values :Position2 is lesser than Position1");
       else if (Position2 < (Position1 + PosnCount1))
         C("Invalid values :Position2 is lesser than (Position1 + PosnCount1)");
     }
   }

   for (i = count; i < datacount; i++)
   {
     if (BurstType == WRAP4) 
     {
       Mask      = address & 0x003;
       if (Mask == 0x03)
         address = address - 0x03;
       else 
         address = address + 1;
     }
     else if (BurstType == WRAP8) 
     {
       Mask      = address & 0x007;
       if (Mask == 0x07)
         address = address - 0x07;
       else 
         address = address + 1;
     }
     else if (BurstType == WRAP16) 
     {
       Mask      = address & 0x00F;
       if (Mask == 0x0F)
         address = address - 0x0F;
       else 
         address = address + 1;
     }
     else 
       address    = address + 1;

     HSA(address,SEQ,BurstType,OK,BYTE,0x7FFFFFFF);

     index = ((address) % 64);

     datagen(index,1,bytedata);
     data  = bytedata[index];

     HSW(,data, ,bytewrite);
   }
 }
}

/****************************************************************************/
/*****************************   Byte Read    *******************************/
/****************************************************************************/
void ByteRd(unsigned long address,unsigned datacount,char BurstType[7], 
            unsigned bytedata[128])
{
/*

 Summary : ByteRd
 =================
 This function generates the AHB slave test bench instructions for
 a byte read access. The starting address of the read access
 is the input address. The number of data transfers in the read
 access is same as the input datacount and the data is stored in
 the respective address of the bytedata array input.

*/

 unsigned index=0;
 unsigned i=0,data;
 int      Mask;

 if (datacount != 0)
 {
   HSA(address,NSEQ,BurstType,OK,BYTE,0x7FFFFFFF);
   index = ((address) % 64);
   data  = (bytedata[index]*16777216) +
           (bytedata[index]*65536)    +
           (bytedata[index]*256)      +
            bytedata[index];

   HSR(,data,MaskAll,0xFFFFFFFF, ,firstByteRd);

   for (i = 1; i<datacount ; i++)
   {
     if (BurstType == WRAP4) 
     {
       Mask      = address & 0x003;
       if (Mask == 0x03)
         address = address - 0x03;
       else 
         address = address + 1;
     }
     else if (BurstType == WRAP8) 
     {
       Mask      = address & 0x007;
       if (Mask == 0x07)
         address = address - 0x07;
       else 
         address = address + 1;
     }
     else if (BurstType == WRAP16) 
     {
       Mask      = address & 0x00F;
       if (Mask == 0x0F)
         address = address - 0x0F;
       else 
         address = address + 1;
     }
     else 
       address    = address + 1;

     HSA(address,SEQ,BurstType,OK,BYTE,0x7FFFFFFF);

     index = (address % 64);
     data  = (bytedata[index]*16777216) +
             (bytedata[index]*65536)    +
             (bytedata[index]*256)      +
              bytedata[index];

     HSR(,data,MaskAll,0xFFFFFFFF, ,ByteRd);
   }
 }
}

/******************************************************************************/
/**************************** Random HBURST Test ******************************/
/******************************************************************************/
void RandHBURST()
{
/*

 Summary : RandHBURST
 =====================
 This will test the following functionality:
 
 o Byte, Half Word & Word data transfers from the AHB port with
   different HBURST types. The temp variable decides the HBURST type.

 o The HBURST type is selected at random and the data size is also selected
   at random.

 o The starting address generated for each data transfer are Word or 
   Half word aligned depending upon the transfer. Also ensures that the
   burst will not exceed the 1 K boundary.

 o Busy states are inserted in each data transfer type either after the 
   first NSEQ or after the first SEQ depending upon the value of Position 
   variable. The number of busy states is decided by the variable BusyCnt.
 
 o When the writes are completed the datas are read back using the AHB port.
   For the Half word and Byte reads the corresponding datas are reproduced
   on the remaining lines of the data bus also. 

*/

 unsigned Addr, SDADDR, LoBits, Bound;
 int      temp, j, i, DataCnt;
 int      BusyCnt = 0;
 int      Position1 = 0, PosnCount1 = 0, Position2 = 0, PosnCount2;
 int      DataSize= 0, WordSel, HWordSel, ByteSel;
 int      Byte[4]   = {B0, B1, B2, B3};
 int      HWord[2]  = {HW0, HW1};
 int      Word[4]   = {W0, W1, W2, W3};
 char*    Burst[8]  = { SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8,
                       WRAP16, INCR16 };

 /* Configure the testbench such that the default byte-alignment is used */
 /* ie. Little Endian                                                    */
 WaitLoop(2); 
 HSEN(LITTLE);

 for (i = 0; i < 20; i++) 
 {
   temp  = rand() % 8;

   if (temp == 0)
   {
     DataCnt  = 1;
     C(" Transfer with HBURST type SINGLE ");
   }
   else if (temp == 1)
   {
     DataCnt  = 1;
     C(" Transfer with HBURST type INCR ");
   }
   else if (temp == 2)
   {
     DataCnt = 4;
     C(" Transfer with HBURST type WRAP4 ");
   }
   else if (temp == 3)
   {
     DataCnt = 4;
     C(" Transfer with HBURST type INCR4 ");
   }
   else if (temp == 4)
   {
     DataCnt = 8;
     C(" Transfer with HBURST type WRAP8 ");
   }
   else if (temp == 5)
   {
     DataCnt = 8;
     C(" Transfer with HBURST type INCR8 ");
   }
   else if (temp == 6)
   {
     DataCnt = 16;
     C(" Transfer with HBURST type WRAP16 ");
   }
   else if (temp == 7)
   {
     DataCnt = 16;
     C(" Transfer with HBURST type INCR16 ");
   }
   else 
   {
     DataCnt    = 1;
     BusyCnt    = 0;
     Position1  = 0;
     PosnCount1 = 0;
     Position2  = 0;
     PosnCount2 = 0;
   }

   DataSize   = (rand() % 3) + 1;
   SDADDR     = Addrgen() | SDRAMBase;
   WordSel    = rand() % 4;
   HWordSel   = rand() % 2;
   ByteSel    = rand() % 4;

   if (temp < 2 ) 
   {
     BusyCnt    = 0;
     Position1  = 0;
     PosnCount1 = 0;
     Position2  = 0;
     PosnCount2 = 0;
   }
   else
   {
     BusyCnt    = rand() % 30;
     Position1  = (rand() % (DataCnt - 1));
     PosnCount1 = (rand() % (DataCnt - Position1));
     Position2  = (rand() % (DataCnt - Position1 - PosnCount1)) + 
                  Position1 +
                  PosnCount1;
     PosnCount2 = (rand() % (DataCnt - Position2));
   }

   if (DataSize == 1) 
   {
     C(" Byte Transfer ");
     Addr       = SDADDR + Word[WordSel] + HWord[HWordSel] + Byte[ByteSel];
     if (temp % 2 == 1)
     {
       LoBits = Addr & 0x03FF;
       Bound  = LoBits + DataCnt;
       if (Bound > 1024)
         Addr = Addr - DataCnt;
     }

     ByteTrans(Addr,DataCnt,Burst[temp],byteset1,BusyCnt,Position1, PosnCount1,
               Position2, PosnCount2); 
     WaitLoop(0x10);
     ByteRd(Addr,DataCnt,Burst[temp],byteset1);
   } 
   else if (DataSize == 2)
   {
     C(" Halfword Transfer ");

     Addr       = SDADDR + Word[WordSel] + HWord[HWordSel]; 
     if (temp % 2 == 1)
     {
       LoBits = Addr & 0x03FF;
       Bound  = LoBits + (DataCnt * 2);
       if (Bound > 1024)
         Addr = Addr - (DataCnt * 2);
     }

     HWordTrans(Addr,DataCnt,Burst[temp],byteset1,BusyCnt,Position1,PosnCount1,
                Position2, PosnCount2);
     WaitLoop(0x15);
     HWordRd(Addr,DataCnt,Burst[temp],byteset1);
   }
   else
   {
     C(" Word Transfer ");
     Addr       = SDADDR + Word[WordSel]; 
     if (temp % 2 == 1)
     {
       LoBits = Addr & 0x03FF;
       Bound  = LoBits + (DataCnt * 4);
       if (Bound > 1024)
         Addr = Addr - (DataCnt * 4);
     }

     WordTrans(Addr,DataCnt,Burst[temp],byteset1,BusyCnt,Position1,PosnCount1,
               Position2, PosnCount2); 
     WaitLoop(0x1A);
     WordRd(Addr,DataCnt,Burst[temp],byteset1);
   }
 }

 /* Configure the testbench such that the default byte-alignment */
 /* is over-riden                                                */
 WaitLoop(2);
 HSEN(DISABLE);
}

/******************************************************************************/
/****************************  Long HBURST Test  ******************************/
/******************************************************************************/
void LongHBURST(int count)
{
/*

 Summary : LongHBURST
 =====================
 This will test the following functionality:

  o Byte, Half Word & Word data transfers from the AHB port with
     different HBURST types. The temp variable decides the HBURST type.

  o The HBURST type is selected at random and the data size is also selected
    at random.

  o The starting address generated is such that, each data transfer can cross 
    Segments, Pages and can be QuadWord aligned or non-aligned. Also makes 
    sure that burst will not cross 1 K boundary.

  o Busy states are inserted in each data transfer type either after the 
    first NSEQ or after the first SEQ depending upon the value of Position 
    variable. The number of busy states is decided by the variable BusyCnt.

  o When the writes are completed the datas are read back using the AHB port.
    For the Half word and Byte reads the corresponding datas are reproduced
    on the remaining lines of the data bus also. 

*/

 unsigned Addr, SDADDR, LoBits, Bound;
 int      temp, j, i, DataCnt, rand_rem32;
 int      BusyCnt = 0;
 int      Position1 = 0, PosnCount1 = 1, Position2, PosnCount2;
 int      DataSize= 0, DevSel, WordSel, HWordSel, ByteSel;
 int      Byte[4]   = {B0, B1, B2, B3};
 int      HWord[2]  = {HW0, HW1};
 int      Word[4]   = {W0, W1, W2, W3};
 char*    Burst[8]  = { SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8,
                        WRAP16, INCR16 };


 /* Configure the testbench such that the default byte-alignment is used */
 /* ie. Little Endian                                                    */
 WaitLoop(2); 
 HSEN(LITTLE);

 for (i = 0; i < count; i++) 
 {
   temp  = rand() % 8;
 
   if (temp == 0)
   {
     DataCnt  = 1;
     C(" Transfer with HBURST type SINGLE ");
   }
   else if (temp == 1)
   {
     DataCnt  = 1;
     C(" Transfer with HBURST type INCR ");
   }
   else if (temp == 2)
   {
     DataCnt = 4;
     C(" Transfer with HBURST type WRAP4 ");
   }
   else if (temp == 3)
   {
     DataCnt = 4;
     C(" Transfer with HBURST type INCR4 ");
   }
   else if (temp == 4)
   {
     DataCnt = 8;
     C(" Transfer with HBURST type WRAP8 ");
   }
   else if (temp == 5)
   {
     DataCnt = 8;
     C(" Transfer with HBURST type INCR8 ");
   }
   else if (temp == 6)
   {
     DataCnt = 16;
     C(" Transfer with HBURST type WRAP16 ");
   }
   else if (temp == 7)
   {
     DataCnt = 16;
     C(" Transfer with HBURST type INCR16 ");
   }
   else 
   {
     DataCnt = 1;
     BusyCnt  = 0;
     Position1 = 0;
     PosnCount1 = 0;
     Position2 = 0;
     PosnCount2 = 0;
   }
 
   DataSize   = (rand() % 3) + 1;
   SDADDR     = AddrgenBoundary() | SDRAMBase;
   WordSel    = rand() % 4;
   HWordSel   = rand() % 2;
   ByteSel    = rand() % 4;

   if ( temp < 2 ) 
   {
     BusyCnt  = 0;
     Position1 = 0;
     PosnCount1 = 0;
     Position2 = 0;
     PosnCount2 = 0;
   }
   else
   {
     BusyCnt    = rand() % 30;
     Position1  = (rand() % (DataCnt - 1));
     PosnCount1 = (rand() % (DataCnt - Position1));
     Position2  = (rand() % (DataCnt - Position1 - PosnCount1)) + 
                  Position1 +
                  PosnCount1;
     PosnCount2 = (rand() % (DataCnt - Position2));
   }

   if (DataSize == 1)
   {
     C(" Byte Transfer ");
     Addr       = SDADDR + Word[WordSel] + HWord[HWordSel] + Byte[ByteSel];
     if (temp % 2 == 1)
     {
       LoBits = Addr & 0x03FF;
       Bound  = LoBits + DataCnt;
       if (Bound > 1024)
         Addr = Addr - DataCnt;
     }

     ByteTrans(Addr,DataCnt,Burst[temp],byteset1,BusyCnt,Position1,PosnCount1,
               Position2, PosnCount2); 
     WaitLoop(0x10);
     ByteRd(Addr,DataCnt,Burst[temp],byteset1);
   }
   else if (DataSize == 2)
   {
     C(" Halfword Transfer ");

     Addr       = SDADDR + Word[WordSel] + HWord[HWordSel]; 
     if (temp % 2 == 1)
     {
       LoBits = Addr & 0x03FF;
       Bound  = LoBits + (DataCnt * 2);
       if (Bound > 1024)
         Addr = Addr - (DataCnt * 2);
     }

     HWordTrans(Addr,DataCnt,Burst[temp],byteset1,BusyCnt,Position1,PosnCount1,
                Position2, PosnCount2);
     WaitLoop(0x15);
     HWordRd(Addr,DataCnt,Burst[temp],byteset1);
   }
   else
   {
     C(" Word Transfer ");
     Addr       = SDADDR + Word[WordSel]; 
     if (temp % 2 == 1) 
     {
       LoBits = Addr & 0x03FF;
       Bound  = LoBits + (DataCnt * 4);
       if (Bound > 1024)
         Addr = Addr - (DataCnt * 4);
     }

     WordTrans(Addr,DataCnt,Burst[temp],byteset1,BusyCnt,Position1,PosnCount1,
               Position2, PosnCount2); 
     WaitLoop(0x1A);
     WordRd(Addr,DataCnt,Burst[temp],byteset1);
   }

 }

 /* Configure the testbench such that the default byte-alignment */
 /* is over-riden                                                */
 WaitLoop(2);
 HSEN(DISABLE);
}

/******************************************************************************/
/*********************  Deterministic HBURST Test  ****************************/
/******************************************************************************/
void DetHBURST()
{
/*

 Summary : DetHBURST
 =====================
 This will test the following functionality:
 
 o Word data transfers from the AHB port with different HBURST types. 
   The temp variable decides the HBURST type. The HBURST is selected at
   random.

 o Both the Write and Read buffers are enabled.

 o A Quadword write is made to an address. This is followed by a Longburst
   write to the same starting address. Once the Writes are completed, the 
   data integrity is checked for by reading back the datas using the AHB
   port. 

 o Again a QuadWord write is made to some address. This is followed by 
   WRAP8 or INCR8 write whose last QuadWord address is same as the starting 
   address of the previous Quadword write. The datas are read back to check
   whether the writes occured in the correct sequence.
  
 o The above sequence is repeated once again with a Quadword write followed 
   by a WRAP16 or INCR16 write. The data integrity is checked for by reading
   back the datas once the writes are completed.

*/

 unsigned Addr, SDADDR, LoBits, Bound;
 int      temp, j, i, DataCnt, rand_rem32;
 int      DevSel, BankSel, PageSel, colSel, RandomBank;     
 int      BusyCnt = 0, Position = 0, PosnCount = 0;
 int      DataSize= 0, WordSel;
 int      Byte[4]   = {B0, B1, B2, B3};
 int      HWord[2]  = {HW0, HW1};
 int      Word[4]   = {W0, W1, W2, W3};
 char     str[1000];
 char*    Burst[8]  = { SINGLE, INCR, WRAP4, INCR4, WRAP8, INCR8,
                       WRAP16, INCR16 };

 /* Configure the testbench such that the default byte-alignment is used */
 /* ie. Little Endian                                                    */
 WaitLoop(2); 
 HSEN(LITTLE);

 for (i = 0; i < 15; i++) 
 {
  
   RandomBank = rand() % 2;

   temp  = rand() % 4;

   if (temp == 0)
   {
     DataCnt  = 1;
     C(" Transfer with HBURST type SINGLE ");
   }
   else if (temp == 1)
   {
     DataCnt  = 1;
     C(" Transfer with HBURST type INCR ");
   }
   else if (temp == 2)
   {
     DataCnt = 4;
     C(" Transfer with HBURST type WRAP4 ");
   }
   else if (temp == 3)
   {
     DataCnt = 4;
     C(" Transfer with HBURST type INCR4 ");
   }
   else 
   {
     DataCnt = 1;
   }
 
   if (RandomBank == 0)
   {
     SDADDR     = AddrgenBoundary() | SDRAMBase;
   }
   else
   { 
     DevSel = rand() % 4;
     BankSel = (rand() % DevBankCalc(DevSel));
     PageSel = (rand() % pagegen(DevSel, 2));
     colSel  = (rand() % colgen(DevSel, 2));
     SDADDR  = (AddrSwapAHB(DevSel, BankSel, PageSel, colSel, ADDRMAP)) 
               | SDRAMBase;
   }

   C(" First word write ");

   Addr       = SDADDR; 
   LoBits = Addr & 0x03FF;
   Bound  = LoBits + (16 * 4);
   if (Bound > 1024)
     Addr = Addr - (16 * 4);
 
   WordTrans(Addr,DataCnt,Burst[temp],byteset1,BusyCnt,Position,PosnCount,
             Position, PosnCount); 
 
   temp  = (rand() % 4) + 4;
 
   if (temp == 4)
   {
     DataCnt = 8;
     C(" Transfer with HBURST type WRAP8 ");
   }
   else if (temp == 5)
   {
     DataCnt = 8;
     C(" Transfer with HBURST type INCR8 ");
   }
   else if (temp == 6)
   {
     DataCnt = 16;
    C(" Transfer with HBURST type WRAP16 ");
  }
  else if (temp == 7)
  {
    DataCnt = 16;
    C(" Transfer with HBURST type INCR16 ");
  }
  else 
  {
    DataCnt = 1;
  }

  if (RandomBank == 1)
  { 
    C(" Second word write to a random address");
    DevSel  = rand() % 4;
    BankSel = ((BankSel + 1) % DevBankCalc(DevSel));
    PageSel = (rand() % pagegen(DevSel, 2));
    colSel  = (rand() % colgen(DevSel, 2));
    Addr    = (AddrSwapAHB(DevSel, BankSel, PageSel, colSel, ADDRMAP))
              | SDRAMBase;
    LoBits = Addr & 0x03FF;
    Bound  = LoBits + (16 * 4);
    if (Bound > 1024)
      Addr = Addr - (16 * 4);
  }
  else
    C(" Second word write to the same starting address ");

  WordTrans(Addr,DataCnt,Burst[temp],byteset1,BusyCnt,Position,PosnCount,
            Position, PosnCount); 
  WaitLoop(0x25);

  C(" Second word read ");
  WordRd(Addr,DataCnt,Burst[temp],byteset1);

  temp  = (rand() % 2) + 2;
  SDADDR     = AddrgenBoundary() | SDRAMBase;
  Addr       = SDADDR; 
  LoBits = Addr & 0x03FF;
  Bound  = LoBits + (16 * 4);
  if (Bound > 1024)
    Addr = Addr - (16 * 4);
  LoBits = (Addr - 16) & 0x03FF;
  Bound  = LoBits + (16 * 4);
  if (Bound > 1024)
    Addr = Addr + 16;

  C(" First word write ");
  WordTrans(Addr,4,Burst[temp],byteset1,BusyCnt,Position,PosnCount,
            Position, PosnCount); 

  temp  = (rand() % 2) + 4;
  Addr       = Addr - 16; 

  C(" Second word write whose last Quadword address is the previous address");
  C("Burst size 8");
  WordTrans(Addr,8,Burst[temp],byteset1,BusyCnt,Position, PosnCount,
            Position, PosnCount); 
  WaitLoop(0x25);

  C(" Second word read ");
  WordRd(Addr,8,Burst[temp],byteset1);

  temp  = (rand() % 2) + 2;
  SDADDR     = AddrgenBoundary() | SDRAMBase;
  Addr       = SDADDR; 
  LoBits = Addr & 0x03FF;
  Bound  = LoBits + (16 * 4);
  if (Bound > 1024)
    Addr = Addr - (16 * 4);
  LoBits = (Addr - 48) & 0x03FF;
  Bound  = LoBits + (16 * 4);
  if (Bound > 1024)
    Addr = Addr + 48;

  C(" First word write ");
  WordTrans(Addr,4,Burst[temp],byteset1,BusyCnt,Position, PosnCount, 
            Position, PosnCount); 

  temp  = (rand() % 2) + 6;
  Addr       = Addr - 48; 

  C(" Second word write whose last Quadword address is the previous address");
  C("Burst size 16");
  WordTrans(Addr,16,Burst[temp],byteset1,BusyCnt,Position, PosnCount,
            Position, PosnCount); 
  C("Second word read");
  WaitLoop(0x25);
  WordRd(Addr,16,Burst[temp],byteset1);

 }

 /* Configure the testbench such that the default byte-alignment */
 /* is over-riden                                                */
 WaitLoop(2);
 HSEN(DISABLE);
}

/****************************************************************************/
/*******************   Page Number Generation *******************************/
/****************************************************************************/
int32 pagegen(int Device, int rand_no)
{
/* 
 
 Summary : Page Number Generation
 ================================
 
 This function returns a page number based on the device number and the random 
 number between 0 and 15 that is passed to it.

*/

 int LastPage, MidPage;

 if ((Device == 0) && ((strcmp(SLOT0, "64M_x16") == 0) || 
     (strcmp(SLOT0, "64M_x8") == 0) || (strcmp(SLOT0, "128M_x16") == 0) ||
     (strcmp(SLOT0, "128M_x8") == 0)))
   LastPage = 4095;
 else if ((Device == 0) && ((strcmp(SLOT0, "64_x32") == 0) ||
          (strcmp(SLOT0, "16M_x16") == 0) || (strcmp(SLOT0, "16M_x8") == 0)))
   LastPage = 2047;
 else if ((Device == 0) && ((strcmp(SLOT0, "256M_x16") == 0) ||
          (strcmp(SLOT0, "256M_x8") == 0)))
   LastPage = 8191;
 
 if ((Device == 1) && ((strcmp(SLOT1, "64M_x16") == 0) || 
     (strcmp(SLOT1, "64M_x8") == 0) || (strcmp(SLOT1, "128M_x16") == 0) ||
     (strcmp(SLOT1, "128M_x8") == 0)))
   LastPage = 4095;
 else if ((Device == 1) && ((strcmp(SLOT1, "64_x32") == 0) ||
          (strcmp(SLOT1, "16M_x16") == 0) || (strcmp(SLOT1, "16M_x8") == 0)))
   LastPage = 2047;
 else if ((Device == 1) && ((strcmp(SLOT1, "256M_x16") == 0) ||
          (strcmp(SLOT1, "256M_x8") == 0)))
   LastPage = 8191;

 if ((Device == 2) && ((strcmp(SLOT2, "64M_x16") == 0) || 
     (strcmp(SLOT2, "64M_x8") == 0) || (strcmp(SLOT2, "128M_x16") == 0) ||
     (strcmp(SLOT2, "128M_x8") == 0)))
   LastPage = 4095;
 else if ((Device == 2) && ((strcmp(SLOT2, "64_x32") == 0) ||
          (strcmp(SLOT2, "16M_x16") == 0) || (strcmp(SLOT2, "16M_x8") == 0)))
   LastPage = 2047;
 else if ((Device == 2) && ((strcmp(SLOT2, "256M_x16") == 0) ||
          (strcmp(SLOT2, "256M_x8") == 0)))
   LastPage = 8191;

 if ((Device == 3) && ((strcmp(SLOT3, "64M_x16") == 0) || 
     (strcmp(SLOT3, "64M_x8") == 0) || (strcmp(SLOT3, "128M_x16") == 0) ||
     (strcmp(SLOT3, "128M_x8") == 0)))
   LastPage = 4095;
 else if ((Device == 3) && ((strcmp(SLOT3, "64_x32") == 0) ||
          (strcmp(SLOT3, "16M_x16") == 0) || (strcmp(SLOT3, "16M_x8") == 0)))
   LastPage = 2047;
 else if ((Device == 3) && ((strcmp(SLOT3, "256M_x16") == 0) ||
          (strcmp(SLOT3, "256M_x8") == 0)))
   LastPage = 8191;

 MidPage = (LastPage + 1)/2;

 switch (rand_no)
 {
   case 0 : return 0;
            break;
   case 1 : return MidPage;
            break;
   case 2 : return LastPage;
            break;
   case 3 : return 1;
            break;
   case 4 : return 55;
            break;
   case 5 : return 100;
            break;
   case 6 : return 111;
            break;
   case 7 : return 171;
            break;
   case 8 : return 284;
            break;
   case 9 : return 555;
            break;
   case 10 : return 786;
            break;
   case 11 : return 777;
            break;
   case 12 : return 1000;
            break;
   case 13 : return 1551;
            break;
   case 14 : return 1111;
            break;
   case 15 : return (LastPage - 1);
            break;
   default: break;
 }
}

/****************************************************************************/
/*******************   Column Number Generation *****************************/
/****************************************************************************/
int32 colgen(int Device, int rand_no)
{
/*

 Summary: Column number generation
 =================================
 
 This function returns a column number based on the device number and the 
 random number between 0 and 15 that is passed to it.
 
*/

 int32 LastCol, MidCol, Last_1;

 if ((Device == 0) && ((strcmp(SLOT0, "64M_x16") == 0) || 
     (strcmp(SLOT0, "64_x32") == 0) || (strcmp(SLOT0, "16M_x16") == 0))) 
   LastCol = 255;
 else if ((Device == 0) && ((strcmp(SLOT0, "64M_x8") == 0) ||
          (strcmp(SLOT0, "128M_x16") == 0) || (strcmp(SLOT0, "16M_x8") == 0) ||
          (strcmp(SLOT0, "256M_x16") == 0)))
   LastCol = 511;
 else if ((Device == 0) && ((strcmp(SLOT0, "128M_x8") == 0) || 
     (strcmp(SLOT0, "256M_x8") == 0))) 
   LastCol = 1023;
 
 if ((Device == 1) && ((strcmp(SLOT1, "64M_x16") == 0) || 
     (strcmp(SLOT1, "64_x32") == 0) || (strcmp(SLOT1, "16M_x16") == 0))) 
   LastCol = 255;
 else if ((Device == 1) && ((strcmp(SLOT1, "64M_x8") == 0) ||
          (strcmp(SLOT1, "128M_x16") == 0) || (strcmp(SLOT1, "16M_x8") == 0) ||
          (strcmp(SLOT1, "256M_x16") == 0)))
   LastCol = 511;
 else if ((Device == 1) && ((strcmp(SLOT1, "128M_x8") == 0) || 
     (strcmp(SLOT1, "256M_x8") == 0))) 
   LastCol = 1023;

 if ((Device == 2) && ((strcmp(SLOT2, "64M_x16") == 0) || 
     (strcmp(SLOT2, "64_x32") == 0) || (strcmp(SLOT2, "16M_x16") == 0))) 
   LastCol = 255;
 else if ((Device == 2) && ((strcmp(SLOT2, "64M_x8") == 0) ||
          (strcmp(SLOT2, "128M_x16") == 0) || (strcmp(SLOT2, "16M_x8") == 0) ||
          (strcmp(SLOT2, "256M_x16") == 0)))
   LastCol = 511;
 else if ((Device == 2) && ((strcmp(SLOT2, "128M_x8") == 0) || 
     (strcmp(SLOT2, "256M_x8") == 0))) 
   LastCol = 1023;

 if ((Device == 3) && ((strcmp(SLOT3, "64M_x16") == 0) || 
     (strcmp(SLOT3, "64_x32") == 0) || (strcmp(SLOT3, "16M_x16") == 0))) 
   LastCol = 255;
 else if ((Device == 3) && ((strcmp(SLOT3, "64M_x8") == 0) ||
          (strcmp(SLOT3, "128M_x16") == 0) || (strcmp(SLOT3, "16M_x8") == 0) ||
          (strcmp(SLOT3, "256M_x16") == 0)))
   LastCol = 511;
 else if ((Device == 3) && ((strcmp(SLOT3, "128M_x8") == 0) || 
     (strcmp(SLOT3, "256M_x8") == 0))) 
   LastCol = 1023;

 MidCol = (LastCol / 0x2);
 Last_1 = (LastCol - 0x10);
 
 switch (rand_no)
 {
   case 0 : return 0;
            break;
   case 1 : return MidCol;
            break;
   case 2 : return LastCol;
            break;
   case 3 : return 10;
            break;
   case 4 : return 55;
            break;
   case 5 : return 100;
            break;
   case 6 : return 111;
            break;
   case 7 : return 171;
            break;
   case 8 : return 135;
            break;
   case 9 : return 168;
            break;
   case 10 : return 222;
            break;
   case 11 : return 77;
            break;
   case 12 : return 100;
            break;
   case 13 : return 51;
            break;
   case 14 : return 11;
            break;
   case 15 : return Last_1;
            break;
   default: break;
 }
}

/****************************************************************************/
/*******************   Address Swap Function for AHB accesses ***************/
/****************************************************************************/
int32 AddrSwapAHB(int DeviceSel, int BankSel, int PageSel, int colSel, int swap)
{
/*

  Summary: Address Swapping for AHB Port accesses
  ===============================================
  When ADDRMAP is set, this function returns the memory address with the 
  address mapping for the device in that particular slot. If ADDRMAP is not set,
  it returns the memory address for the specified device, bank, page and column
  without any remapping.

*/

 int32 Address;
 int Slot_0, Slot_1, Slot_2, Slot_3;

 if (strcmp(SLOT0,"64M_x16") == 0)
   Slot_0 = 0;
 else if (strcmp(SLOT0, "64M_x8") == 0)
   Slot_0 = 1;
 else if (strcmp(SLOT0, "128M_x16") == 0)
   Slot_0 = 2;
 else if (strcmp(SLOT0, "128M_x8") == 0)
   Slot_0 = 3;
 else if (strcmp(SLOT0, "16M_x16") == 0)
   Slot_0 = 4;
 else if (strcmp(SLOT0, "16M_x8") == 0)
   Slot_0 = 5;
 else if (strcmp(SLOT0, "64_x32") == 0)
   Slot_0 = 6;
 else if (strcmp(SLOT0, "256M_x16") == 0)
   Slot_0 = 7;
 else if (strcmp(SLOT0, "256M_x8") == 0)
   Slot_0 = 8;
 
 if (strcmp(SLOT1, "64M_x16") == 0)
   Slot_1 = 0;
 else if (strcmp(SLOT1, "64M_x8") == 0)
   Slot_1 = 1;
 else if (strcmp(SLOT1, "128M_x16") == 0)
   Slot_1 = 2;
 else if (strcmp(SLOT1, "128M_x8") == 0)
   Slot_1 = 3;
 else if (strcmp(SLOT1, "16M_x16") == 0)
   Slot_1 = 4;
 else if (strcmp(SLOT1, "16M_x8") == 0)
   Slot_1 = 5;
 else if (strcmp(SLOT1, "64_x32") == 0)
   Slot_1 = 6;
 else if (strcmp(SLOT1, "256M_x16") == 0)
   Slot_1 = 7;
 else if (strcmp(SLOT1, "256M_x8") == 0)
   Slot_1 = 8;
 
 if (strcmp(SLOT2, "64M_x16") == 0)
   Slot_2 = 0;
 else if (strcmp(SLOT2, "64M_x8") == 0)
   Slot_2 = 1;
 else if (strcmp(SLOT2, "128M_x16") == 0)
   Slot_2 = 2;
 else if (strcmp(SLOT2, "128M_x8") == 0)
   Slot_2 = 3;
 else if (strcmp(SLOT2, "16M_x16") == 0)
   Slot_2 = 4;
 else if (strcmp(SLOT2, "16M_x8") == 0)
   Slot_2 = 5;
 else if (strcmp(SLOT2, "64_x32") == 0)
   Slot_2 = 6;
 else if (strcmp(SLOT2, "256M_x16") == 0)
   Slot_2 = 7;
 else if (strcmp(SLOT2, "256M_x8") == 0)
   Slot_2 = 8;
 
 if (strcmp(SLOT3, "64M_x16") == 0)
   Slot_3 = 0;
 else if (strcmp(SLOT3, "64M_x8") == 0)
   Slot_3 = 1;
 else if (strcmp(SLOT3, "128M_x16") == 0)
   Slot_3 = 2;
 else if (strcmp(SLOT3, "128M_x8") == 0)
   Slot_3 = 3;
 else if (strcmp(SLOT3, "16M_x16") == 0)
   Slot_3 = 4;
 else if (strcmp(SLOT3, "16M_x8") == 0)
   Slot_3 = 5;
 else if (strcmp(SLOT3, "64_x32") == 0)
   Slot_3 = 6;
 else if (strcmp(SLOT3, "256M_x16") == 0)
   Slot_3 = 7;
 else if (strcmp(SLOT3, "256M_x8") == 0)
   Slot_3 = 8;

 if (EXTBUSWIDTH == 0)
 {
   if(swap)
   {
     switch (DeviceSel)
     {
       case 0 :   
               switch (Slot_0)
               {
                 case 0:
                 case 2:
                 case 6:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel % 2) << 11                   |
                                    (((BankSel >> 1) % 2) << 10)          |
                                    (PageSel << 12)                       | 
                                    (((colSel & 0x100)/0x100) << 24)      |
                                    (((colSel & 0x200)/0x200) << 25)      |
                                    ((colSel & 0xFF) << 2);
         
                          break;
                        }
                 case 1:
                 case 3:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel << 11)                  |
                                    ((PageSel % 2) << 24)            |
                                    ((PageSel/2) << 13)              |
                                    (((colSel & 0x200)/0x200) << 25) |
                                    ((colSel & 0x1FF) << 2);
         
                          break;
                        }
                 case 4: 
                        {
                          Address = DeviceSel << 27                  |
                                    BankSel << 10                    |
                                    (PageSel % 0x400) << 12          |
                                    ((PageSel & 0x400)/0x400) << 11  |
                                    (((colSel & 0x200)/0x200) << 25) |
                                    ((colSel & 0x1FF) << 2);
          
                          break;
                        }
                 case 5:
                        {
                          Address = DeviceSel << 27                  |
                                    BankSel   << 11                  |
                                    PageSel   << 12                  |
                                    (((colSel & 0x200)/0x200) << 25) |
                                    ((colSel & 0x1FF) << 2);
         
                          break;
                        }
                 case 7:
                 case 8:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel % 2) << 12                   |
                                    (((BankSel >> 1) % 2) << 11)          |
                                    (PageSel & 0x001) << 25               |
                                    ((PageSel & 0xFFFE) << 12)            |
                                    (((colSel & 0x200)/0x200) << 26)      |
                                    ((colSel & 0x1FF) << 2);
                          break;
                        }
                default:
                        break;
               }
               break;
       case 1 :   
               switch (Slot_1)
               {
                 case 0:
                 case 2:
                 case 6:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel % 2) << 11                   |
                                    (((BankSel >> 1) % 2) << 10)          |
                                    (PageSel << 12)                       | 
                                    (((colSel & 0x100)/0x100) << 24)      |
                                    (((colSel & 0x200)/0x200) << 25)      |
                                    ((colSel & 0x00FF) << 2);
         
                          break;
                        }
                 case 1:
                 case 3:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel << 11)                  |
                                    ((PageSel % 2) << 24)            |
                                    ((PageSel/2) << 13)              |
                                    (((colSel & 0x200)/0x200) << 25) |
                                    ((colSel & 0x1FF) << 2);
         
                          break;
                        }
                 case 4: 
                        {
                          Address = DeviceSel << 27                  |
                                    BankSel << 10                    |
                                    (PageSel % 0x400) << 12          |
                                    ((PageSel & 0x400)/0x400) << 11  |
                                    (((colSel & 0x200)/0x200) << 25) |
                                    ((colSel & 0x1FF) << 2);
          
                          break;
                        }
                 case 5:
                        {
                          Address = DeviceSel << 27                  |
                                    BankSel   << 11                  |
                                    PageSel   << 12                  |
                                    (((colSel & 0x200)/0x200) << 25) |
                                    ((colSel & 0x1FF) << 2);
         
                          break;
                        }
                 case 7:
                 case 8:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel % 2) << 12                   |
                                    (((BankSel >> 1) % 2) << 11)          |
                                    (PageSel & 0x001) << 25               |
                                    ((PageSel & 0xFFFE) << 12)            |
                                    (((colSel & 0x200)/0x200) << 26)      |
                                    ((colSel & 0x1FF) << 2);
                          break;
                        }
                default:
                        break;
               }
               break;
       case 2 :   
               switch (Slot_2)
               {
                 case 0:
                 case 2:
                 case 6:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel % 2) << 11                   |
                                    (((BankSel >> 1) % 2) << 10)          |
                                    (PageSel << 12)                       | 
                                    (((colSel & 0x100)/0x100) << 24)      |
                                    (((colSel & 0x200)/0x200) << 25)      |
                                    ((colSel & 0x00FF) << 2);
         
                          break;
                        }
                 case 1:
                 case 3:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel << 11)                  |
                                    ((PageSel % 2) << 24)            |
                                    ((PageSel/2) << 13)              |
                                    (((colSel & 0x200)/0x200) << 25) |
                                    ((colSel & 0x1FF) << 2);
         
                          break;
                        }
                 case 4: 
                        {
                          Address = DeviceSel << 27                  |
                                    BankSel << 10                    |
                                    (PageSel % 0x400) << 12          |
                                    ((PageSel & 0x400)/0x400) << 11  |
                                    (((colSel & 0x200)/0x200) << 25) |
                                    ((colSel & 0x1FF) << 2);
          
                          break;
                        }
                 case 5:
                        {
                          Address = DeviceSel << 27                  |
                                    BankSel   << 11                  |
                                    PageSel   << 12                  |
                                    (((colSel & 0x200)/0x200) << 25) |
                                    ((colSel & 0x1FF) << 2);
         
                          break;
                        }
                 case 7:
                 case 8:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel % 2) << 12                   |
                                    (((BankSel >> 1) % 2) << 11)          |
                                    (PageSel & 0x001) << 25               |
                                    ((PageSel & 0xFFFE) << 12)            |
                                    (((colSel & 0x200)/0x200) << 26)      |
                                    ((colSel & 0x1FF) << 2);
                          break;
                        }
                default:
                        break;
               }
               break;
       case 3 :   
               switch (Slot_3)
               {
                 case 0:
                 case 2:
                 case 6:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel % 2) << 11                   |
                                    (((BankSel >> 1) % 2) << 10)          |
                                    (PageSel << 12)                       | 
                                    (((colSel & 0x100)/0x100) << 24)      |
                                    (((colSel & 0x200)/0x200) << 25)      |
                                    ((colSel & 0x00FF) << 2);
         
                          break;
                        }
                 case 1:
                 case 3:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel << 11)                  |
                                    ((PageSel % 2) << 24)            |
                                    ((PageSel/2) << 13)              |
                                    (((colSel & 0x200)/0x200) << 25) |
                                    ((colSel & 0x1FF) << 2);
         
                          break;
                        }
                 case 4: 
                        {
                          Address = DeviceSel << 27                  |
                                    BankSel << 10                    |
                                    (PageSel % 0x400) << 12          |
                                    ((PageSel & 0x400)/0x400) << 11  |
                                    (((colSel & 0x200)/0x200) << 25) |
                                    ((colSel & 0x1FF) << 2);
          
                          break;
                        }
                 case 5:
                        {
                          Address = DeviceSel << 27                  |
                                    BankSel   << 11                  |
                                    PageSel   << 12                  |
                                    (((colSel & 0x200)/0x200) << 25) |
                                    ((colSel & 0x1FF) << 2);
         
                          break;
                        }
                 case 7:
                 case 8:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel % 2) << 12                   |
                                    (((BankSel >> 1) % 2) << 11)          |
                                    (PageSel & 0x001) << 25               |
                                    ((PageSel & 0xFFFE) << 12)            |
                                    (((colSel & 0x200)/0x200) << 26)      |
                                    ((colSel & 0x1FF) << 2);
                          break;
                        }
                default:
                        break;
               }
               break;
      default :
               break;
     }
     return Address;
   }
   else 
   {
     switch (DeviceSel)
     {
       case 0 :
       {
         if((strcmp(SLOT0,"256M_x16") == 0) || (strcmp(SLOT0,"256M_x8") == 0))
         {
           Address = DeviceSel << 27            |
                     ((BankSel >> 1) % 2 << 26) | 
                     (BankSel % 2 << 25)        | 
                      PageSel << 12 | colSel << 2 ;
         }
         else if((strcmp(SLOT0,"16M_x16")== 0) || (strcmp(SLOT0,"16M_x8") == 0))
         {
           Address = DeviceSel << 27            |
                     (BankSel << 25)            | 
                     (BankSel << 23)            |
                     PageSel << 12 | colSel << 2 ;
           Address = Address & 0xFAFFFFFF;
         }
         else
         {
           Address = DeviceSel << 27            |
                     ((BankSel >> 1) % 2 << 25) | 
                     (BankSel % 2 << 24)        | 
                     (BankSel % 2 << 26)        | 
                     PageSel << 12 | colSel << 2 ;
         }
         break;
       }
 
       case 1 :
       {
         if((strcmp(SLOT1,"256M_x16") == 0) || (strcmp(SLOT1,"256M_x8") == 0))
         {
           Address = DeviceSel << 27            |
                     ((BankSel >> 1) % 2 << 26) | 
                     (BankSel % 2 << 25)        | 
                     PageSel << 12 | colSel << 2 ;
         }
         else if((strcmp(SLOT1,"16M_x16") == 0) || (strcmp(SLOT1,"16M_x8")== 0))
         {
           Address = DeviceSel << 27            |
                     (BankSel << 25)            | 
                     (BankSel << 23)            |
                     PageSel << 12 | colSel << 2 ;
           Address = Address & 0xFAFFFFFF;
         }
         else
         {
           Address = DeviceSel << 27            |
                     ((BankSel >> 1) % 2 << 25) | 
                     (BankSel % 2 << 24)        | 
                     (BankSel % 2 << 26)        | 
                     PageSel << 12 | colSel << 2 ;
         }
         break;
       }
 
       case 2 :
       {
         if((strcmp(SLOT2,"256M_x16") == 0) || (strcmp(SLOT2,"256M_x8") == 0))
         {
           Address = DeviceSel << 27            |
                     ((BankSel >> 1) % 2 << 26) | 
                     (BankSel % 2 << 25)        | 
                     PageSel << 12 | colSel << 2 ;
         }
         else if((strcmp(SLOT2,"16M_x16") == 0) || (strcmp(SLOT2,"16M_x8")== 0))
         {
           Address = DeviceSel << 27            |
                     (BankSel << 25)            | 
                     (BankSel << 23)            |
                     PageSel << 12 | colSel << 2 ;
           Address = Address & 0xFAFFFFFF;
         }
         else
         {
           Address = DeviceSel << 27            |
                     ((BankSel >> 1) % 2 << 25) | 
                     (BankSel % 2 << 24)        | 
                     (BankSel % 2 << 26)        | 
                     PageSel << 12 | colSel << 2 ;
         }
         break;
       }
 
       case 3 :
       {
         if((strcmp(SLOT3,"256M_x16") == 0) || (strcmp(SLOT3,"256M_x8") == 0))
         {
           Address = DeviceSel << 27            |
                     ((BankSel >> 1) % 2 << 26) | 
                     (BankSel % 2 << 25)        | 
                     PageSel << 12 | colSel << 2 ;
         }
         else if((strcmp(SLOT3,"16M_x16") == 0) || (strcmp(SLOT3,"16M_x8")== 0))
         {
           Address = DeviceSel << 27            |
                     (BankSel << 25)            | 
                     (BankSel << 23)            |
                     PageSel << 12 | colSel << 2 ;
           Address = Address & 0xFAFFFFFF;
         }
         else
         {
           Address = DeviceSel << 27            |
                     ((BankSel >> 1) % 2 << 25) | 
                     (BankSel % 2 << 24)        | 
                     (BankSel % 2 << 26)        | 
                     PageSel << 12 | colSel << 2 ;
         }
         break;
       }
 
      default :
       break ;
     }
     return Address;
   }
 }
 else
 {
   if(swap)
   {
     switch (DeviceSel)
     {
       case 0 :   
               switch (Slot_0)
               {
                 case 0:
                 case 2:
                 case 6:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel) << 9  |
                                    (PageSel % 0x200) << 12          |
                                    ((PageSel & 0x400)/0x400) << 11  |
                                    ((PageSel & 0x800)/0x800) << 22  |
                                    ((PageSel & 0x200)/0x200) << 21  |
                                    (colSel % 0x100)/2 << 2          |
                                    (colSel / 0x100) << 23;
                          break;
                        }
                 case 1:
                 case 3:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel%2 << 11) |
                                    (BankSel/2 << 10) |
                                    ((PageSel) << 12)           |
                                    (colSel % 0x200)/2 << 2     |
                                    (colSel / 0x200) << 24;      
                         break;
                        }
                 case 4: 
                        {
                          Address = DeviceSel << 27 |
                                    BankSel << 9    |
                                    (PageSel % 0x200) << 12         |
                                    ((PageSel & 0x600)/0x600) << 10 |
                                    (colSel % 0x200)/2 << 2         |
                                    (colSel / 0x200) << 24;
                          break;
                        }
                 case 5:
                        {
                          Address = DeviceSel << 27 |
                                    BankSel   << 10 |
                                    (PageSel % 0x400) << 12         |
                                    ((PageSel & 0x400)/0x400) << 11 | 
                                    (colSel % 0x200)/2 << 2         |
                                    (colSel / 0x200) << 24;
                          break;
                        }
                 case 7:
                 case 8:
                        {
                          Address =  DeviceSel << 27 |
                                     BankSel   << 10 |
                                     PageSel   << 12 |
                                     (colSel % 0x200)/2 << 2      |
                                     (colSel / 0x200) << 25;
                          break;
                        }
                default:
                        break;
                }
                break;
       case 1 :   
               switch (Slot_1)
               {
                 case 0:
                 case 2:
                 case 6:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel) << 9  |
                                    (PageSel % 0x200) << 12          |
                                    ((PageSel & 0x400)/0x400) << 11  |
                                    ((PageSel & 0x800)/0x800) << 22  |
                                    ((PageSel & 0x200)/0x200) << 21  |
                                    (colSel % 0x100)/2 << 2          |
                                    (colSel / 0x100) << 23;
                          break;
                        }
                 case 1:
                 case 3:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel%2 << 11) |
                                    (BankSel/2 << 10) |
                                    ((PageSel) << 12)           |
                                    (colSel % 0x200)/2 << 2     |
                                    (colSel / 0x200) << 24;      
                         break;
                        }
                 case 4: 
                        {
                          Address = DeviceSel << 27 |
                                    BankSel << 9    |
                                    (PageSel % 0x200) << 12         |
                                    ((PageSel & 0x600)/0x600) << 10 |
                                    (colSel % 0x200)/2 << 2         |
                                    (colSel / 0x200) << 24;
                          break;
                        }
                 case 5:
                        {
                          Address = DeviceSel << 27 |
                                    BankSel   << 10 |
                                    (PageSel % 0x400) << 12         |
                                    ((PageSel & 0x400)/0x400) << 11 | 
                                    (colSel % 0x200)/2 << 2         |
                                    (colSel / 0x200) << 24;
                          break;
                        }
                 case 7:
                 case 8:
                        {
                          Address =  DeviceSel << 27 |
                                     BankSel   << 10 |
                                     PageSel   << 12 |
                                     (colSel % 0x200)/2 << 2      |
                                     (colSel / 0x200) << 25;
                          break;
                        }
                default:
                        break;
                }
                break;
       case 2 :   
               switch (Slot_2)
               {
                 case 0:
                 case 2:
                 case 6:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel) << 9  |
                                    (PageSel % 0x200) << 12          |
                                    ((PageSel & 0x400)/0x400) << 11  |
                                    ((PageSel & 0x800)/0x800) << 22  |
                                    ((PageSel & 0x200)/0x200) << 21  |
                                    (colSel % 0x100)/2 << 2          |
                                    (colSel / 0x100) << 23;
                          break;
                        }
                 case 1:
                 case 3:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel%2 << 11) |
                                    (BankSel/2 << 10) |
                                    ((PageSel) << 12)           |
                                    (colSel % 0x200)/2 << 2     |
                                    (colSel / 0x200) << 24;      
                         break;
                        }
                 case 4: 
                        {
                          Address = DeviceSel << 27 |
                                    BankSel << 9    |
                                    (PageSel % 0x200) << 12         |
                                    ((PageSel & 0x600)/0x600) << 10 |
                                    (colSel % 0x200)/2 << 2         |
                                    (colSel / 0x200) << 24;
                          break;
                        }
                 case 5:
                        {
                          Address = DeviceSel << 27 |
                                    BankSel   << 10 |
                                    (PageSel % 0x400) << 12         |
                                    ((PageSel & 0x400)/0x400) << 11 | 
                                    (colSel % 0x200)/2 << 2         |
                                    (colSel / 0x200) << 24;
                          break;
                        }
                 case 7:
                 case 8:
                        {
                          Address =  DeviceSel << 27 |
                                     BankSel   << 10 |
                                     PageSel   << 12 |
                                     (colSel % 0x200)/2 << 2      |
                                     (colSel / 0x200) << 25;
                          break;
                        }
                default:
                        break;
                }
                break;
       case 3 :   
               switch (Slot_3)
               {
                 case 0:
                 case 2:
                 case 6:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel) << 9  |
                                    (PageSel % 0x200) << 12          |
                                    ((PageSel & 0x400)/0x400) << 11  |
                                    ((PageSel & 0x800)/0x800) << 22  |
                                    ((PageSel & 0x200)/0x200) << 21  |
                                    (colSel % 0x100)/2 << 2          |
                                    (colSel / 0x100) << 23;
                          break;
                        }
                 case 1:
                 case 3:
                        {
                          Address = DeviceSel << 27 |
                                    (BankSel%2 << 11) |
                                    (BankSel/2 << 10) |
                                    ((PageSel) << 12)           |
                                    (colSel % 0x200)/2 << 2     |
                                    (colSel / 0x200) << 24;      
                         break;
                        }
                 case 4: 
                        {
                          Address = DeviceSel << 27 |
                                    BankSel << 9    |
                                    (PageSel % 0x200) << 12         |
                                    ((PageSel & 0x600)/0x600) << 10 |
                                    (colSel % 0x200)/2 << 2         |
                                    (colSel / 0x200) << 24;
                          break;
                        }
                 case 5:
                        {
                          Address = DeviceSel << 27 |
                                    BankSel   << 10 |
                                    (PageSel % 0x400) << 12         |
                                    ((PageSel & 0x400)/0x400) << 11 | 
                                    (colSel % 0x200)/2 << 2         |
                                    (colSel / 0x200) << 24;
                          break;
                        }
                 case 7:
                 case 8:
                        {
                          Address =  DeviceSel << 27 |
                                     BankSel   << 10 |
                                     PageSel   << 12 |
                                     (colSel % 0x200)/2 << 2      |
                                     (colSel / 0x200) << 25;
                          break;
                        }
                default:
                        break;
                }
                break;
      default :
               break;
     }
     return Address;
   }
   else 
   {
     switch (DeviceSel)
     {
       case 0 :
       {
         if((strcmp(SLOT0,"256M_x16") == 0) || (strcmp(SLOT0,"256M_x8") == 0))
         {
           Address = DeviceSel << 27            |
                     ((BankSel >> 1) % 2 << 26) | 
                     (BankSel % 2 << 25)        | 
                     PageSel << 11 | (colSel/2) << 2 ;
         }
         else if((strcmp(SLOT0,"16M_x16") == 0) || (strcmp(SLOT0,"16M_x8")== 0))
         {
           Address = DeviceSel << 27            |
                     (BankSel << 25)            | 
                     (BankSel << 23)            |
                     PageSel << 11 | (colSel/2) << 2 ;
 
           Address = Address & 0xFAFFFFFF;
         }
         else
         {
           Address = DeviceSel << 27            |
                     ((BankSel >> 1) % 2 << 25) | 
                     (BankSel % 2 << 24)        | 
                     (BankSel % 2 << 26)        | 
                     PageSel << 11 | (colSel/2) << 2 ;
         }
         break;
       }
 
       case 1 :
       {
         if((strcmp(SLOT1,"256M_x16") == 0) || (strcmp(SLOT1,"256M_x8") == 0))
         {
           Address = DeviceSel << 27            |
                     ((BankSel >> 1) % 2 << 26) | 
                     (BankSel % 2 << 25)        | 
                     PageSel << 11 | (colSel/2) << 2 ;
         }
         else if((strcmp(SLOT1,"16M_x16") == 0) || (strcmp(SLOT1,"16M_x8")== 0))
         {
           Address = DeviceSel << 27            |
                     (BankSel << 25)            | 
                     (BankSel << 23)            |
                     PageSel << 11 | (colSel/2) << 2 ;
 
           Address = Address & 0xFAFFFFFF;
         }
         else
         {
           Address = DeviceSel << 27            |
                     ((BankSel >> 1) % 2 << 25) | 
                     (BankSel % 2 << 24)        | 
                     (BankSel % 2 << 26)        | 
                     PageSel << 11 | (colSel/2) << 2 ;
         }
         break;
       }
 
       case 2 :
       {
         if((strcmp(SLOT2,"256M_x16") == 0) || (strcmp(SLOT2,"256M_x8") == 0))
         {
           Address = DeviceSel << 27            |
                     ((BankSel >> 1) % 2 << 26) | 
                     (BankSel % 2 << 25)        | 
                     PageSel << 11 | (colSel/2) << 2 ;
         }
         else if((strcmp(SLOT2,"16M_x16") == 0) || (strcmp(SLOT2,"16M_x8")== 0))
         {
           Address = DeviceSel << 27            |
                     (BankSel << 25)            | 
                     (BankSel << 23)            |
                     PageSel << 11 | (colSel/2) << 2 ;
 
           Address = Address & 0xFAFFFFFF;
         }
         else
         {
           Address = DeviceSel << 27            |
                     ((BankSel >> 1) % 2 << 25) | 
                     (BankSel % 2 << 24)        | 
                     (BankSel % 2 << 26)        | 
                     PageSel << 11 | (colSel/2) << 2 ;
         }
         break;
       }
 
       case 3 :
       {
         if((strcmp(SLOT3,"256M_x16") == 0) || (strcmp(SLOT3,"256M_x8") == 0))
         {
           Address = DeviceSel << 27            |
                     ((BankSel >> 1) % 2 << 26) | 
                     (BankSel % 2 << 25)        | 
                     PageSel << 11 | (colSel/2) << 2 ;
         }
         else if((strcmp(SLOT3,"16M_x16") == 0) || (strcmp(SLOT3,"16M_x8")== 0))
         {
           Address = DeviceSel << 27            |
                     (BankSel << 25)            | 
                     (BankSel << 23)            |
                     PageSel << 11 | (colSel/2) << 2 ;
 
           Address = Address & 0xFAFFFFFF;
         }
         else
         {
           Address = DeviceSel << 27            |
                     ((BankSel >> 1) % 2 << 25) | 
                     (BankSel % 2 << 24)        | 
                     (BankSel % 2 << 26)        | 
                     PageSel << 11 | (colSel/2) << 2 ;
         }
         break;
       }
 
      default :
               break ;
     }
     return Address;
   } 
 }
}

/****************************************************************************/
/**************** Calculation of number of banks in the device **************/
/****************************************************************************/
int32 DevBankCalc(int Device)
{
/* 
 
 Summary : Calculation  of number of Banks in a Device 
 =====================================================
 
 This function returns the number of banks in a particular device depending 
 on the type of device.

*/

 int DevBank;

 if (((Device == 0) &&
     ((strcmp(SLOT0, "16M_x16") == 0) || (strcmp(SLOT0, "16M_x8") == 0)))
     || ((Device == 1) &&
     ((strcmp(SLOT1, "16M_x16") == 0) || (strcmp(SLOT1, "16M_x8") == 0)))
     || ((Device == 2) &&
     ((strcmp(SLOT2, "16M_x16") == 0) || (strcmp(SLOT2, "16M_x8") == 0)))
     || ((Device == 3) &&
     ((strcmp(SLOT3, "16M_x16") == 0) || (strcmp(SLOT3, "16M_x8") == 0))))
   DevBank = 2;
 else
   DevBank = 4;
 
 return DevBank;
}

/****************************************************************************/
/***************************** Bus Degrant Test *****************************/
/****************************************************************************/
void DegrantTest(int Busy)
{
/*

 Summary : Bus Degrant Tests
 ===========================

 In this test, a sequence of idle cycles is inserted in a burst write of each
 burst type in any position. The number of idle cycles is decided randomly.
 After the idle cycles, the burst is rebuilt by using suitable number of
 transfers with burst type INCR. When the writes are completed the data is
 read back using the same type of burst. The idle cycles are introduced after 
 BUSY transfers if the input argument Busy is set.

*/

 int i, j, k, Address, BusyCnt, temp;
 int LoBits, Bound, QWStart;

 C("INCR4 burst termination and rebuild");
 for (k = 0; k < 2; k ++)
 {
   for (i = 1; i < 4; i ++)
   {
     /* INCR4 Burst termination due to degranting */
 
     /* Generate a random address and align it with a QW address */
     Address = (Addrgen() | SDRAMBase) & 0xFFFFFFF0;

     /* Starting address is W0, W1, W2 or W3 depending on random value */
     temp = rand() % 4;
     Address = Address + (4*temp);
 
     /* Check whether the burst will cross a 1KB boundary */
     /* Change the address if it crosses a 1KB boundary */
     LoBits = Address & 0x03FF;
     Bound  = LoBits + 16;
     if (Bound > 1024)
       Address = Address - 16;
 
     if (Busy == 1)
     {
       /* Random number of BUSY transfers */
       BusyCnt = (rand() % 30) + 1;

       /* NSEQ-SEQ-BUSY sequence */
       WordTrans(Address, i, INCR4, byteset1, BusyCnt, i-1, 1, 0, 0);
     }
     else
     {
       /* NSEQ-SEQ sequence */
       WordTrans(Address, i, INCR4, byteset1, 0, 0, 0, 0, 0);
     }
 
     /* Random number of idle cycles during degranting */
     j = (rand() % 16) + 1;
     WaitLoop(j);
 
     /* Rebuild of the burst after getting grant again */
     WordTrans(Address + (4*i), 4 - i, INCR, byteset1, 0, 0, 0, 0, 0);
     
     /* Check data through reads */
     WordRd(Address, 4, INCR4, byteset1);
   }
 }

 C("INCR burst termination and rebuild");
 for (k = 0; k < 2; k++)
 {
   for (i = 1; i < 6; i ++)
   {
     /* INCR burst termination due to degranting */
 
     /* Generate a random address and align it with a QW address */
     Address = (Addrgen() | SDRAMBase) & 0xFFFFFFF0;
 
     /* Starting address is W0, W1, W2 or W3 depending on random value */
     temp = rand() % 4;
     Address = Address + (4*temp);

     /* Check whether the burst will cross a 1KB boundary */
     /* Change the address if it crosses a 1KB boundary */
     LoBits = Address & 0x03FF;
     Bound  = LoBits + 24;
     if (Bound > 1024)
       Address = Address - 24;
 
     if (Busy == 1)
     {
       /* Random number of BUSY transfers */
       BusyCnt = (rand() % 30) + 1;
 
       /* NSEQ-SEQ-BUSY sequence */
       WordTrans(Address, i, INCR, byteset1, BusyCnt, i-1, 1, 0, 0);
     }
     else
     {
       /* NSEQ-SEQ sequence */
       WordTrans(Address, i, INCR, byteset1, 0, 0, 0, 0, 0);
     }
 
     /* Random number of idle cycles during degranting */
     j = (rand() % 16) + 1;
     WaitLoop(j);
 
     /* Rebuild of the burst after getting grant again */
     WordTrans(Address + (4*i), 6 - i, INCR, byteset1, 0, 0, 0, 0, 0);

     /* Check data through reads */
     WordRd(Address, 6, INCR, byteset1);
   }
 }

 C("INCR8 burst termination and rebuild");
 for (k = 0; k < 2; k++)
 {
   for (i = 1; i < 8; i ++)
   {
     /* INCR8 burst termination due to degranting */

     /* Generate a random address and align it with a QW address */
     Address = (Addrgen() | SDRAMBase) & 0xFFFFFFF0;

     /* Starting address is W0, W1, W2 or W3 depending on random value */
     temp = rand() % 4;
     Address = Address + (4*temp);
 
     /* Check whether the burst will cross a 1KB boundary */
     /* Change the address if it crosses a 1KB boundary */
     LoBits = Address & 0x03FF;
     Bound  = LoBits + 32;
     if (Bound > 1024)
       Address = Address - 32;
 
     if (Busy == 1)
     {
       /* Random number of BUSY transfers */
       BusyCnt = (rand() % 30) + 1;
 
       /* NSEQ-SEQ-BUSY sequence */
       WordTrans(Address, i, INCR8, byteset2, BusyCnt, i-1, 1, 0, 0);
     }
     else
     {
       /* NSEQ-SEQ sequence */
       WordTrans(Address, i, INCR8, byteset2, 0, 0, 0, 0, 0);
     }
 
     /* Random number of idle cycles during degranting */
     j = (rand() % 16) + 1;
     WaitLoop(j);
 
     /* Rebuild of the burst after getting grant again */
     WordTrans(Address + (4*i), 8 - i, INCR, byteset2, 0, 0, 0, 0, 0);
 
     /* Check data through reads */
     WordRd(Address, 8, INCR8, byteset2);
   }
 }

 C("INCR16 burst termination and rebuild");
 for (k = 0; k < 2; k++)
 {
   for (i = 1; i < 16; i ++)
   {
     /* INCR16 burst termination due to degranting */
 
     /* Generate a random address and align it with a QW address */
     Address = (Addrgen() | SDRAMBase) & 0xFFFFFFF0;
 
     /* Starting address is W0, W1, W2 or W3 depending on random value */
     temp = rand() % 4;
     Address = Address + (4*temp);
 
     /* Check whether the burst will cross a 1KB boundary */
     /* Change the address if it crosses a 1KB boundary */
     LoBits = Address & 0x03FF;
     Bound  = LoBits + 64;
     if (Bound > 1024)
       Address = Address - 64;
 
     if (Busy == 1)
     {
       /* Random number of BUSY transfers */
       BusyCnt = (rand() % 30) + 1;
 
       /* NSEQ-SEQ-BUSY sequence */
       WordTrans(Address, i, INCR16, byteset1, BusyCnt, i-1, 1, 0, 0);
     }
     else
     {
       /* NSEQ-SEQ sequence */
       WordTrans(Address, i, INCR16, byteset1, 0, 0, 0, 0, 0);
     }
 
     /* Random number of idle cycles during degranting */
     j = (rand() % 16) + 1;
     WaitLoop(j);
 
     /* Rebuild of the burst after getting grant again */
     WordTrans(Address + (4*i), 16 - i, INCR, byteset1, 0, 0, 0, 0, 0);
 
     /* Check data through reads */
     WordRd(Address, 16, INCR16, byteset1);
   }
 }

 C("WRAP4 burst termination and rebuild");
 for (k = 0; k < 2; k ++)
 {
   for (i = 1; i < 4; i ++)
   {
     /* WRAP4 Burst termination due to degranting of the master*/

     /* Generate a random address and align it with a QW address */
     Address = (Addrgen() | SDRAMBase) & 0xFFFFFFF0;
     QWStart   = Address;
 
     /* Starting address is W0, W1 or W2 depending on random value */
     temp = rand() % 3;
     Address = Address + (4*temp);
 
     if (Busy == 1)
     {
       /* Random number of BUSY transfers */
       BusyCnt = (rand() % 30) + 1;
 
       /* NSEQ-SEQ-BUSY sequence */
       WordTrans(Address, i, WRAP4, byteset2, BusyCnt, i-1, 1, 0, 0);
     }
     else
     {
       /* NSEQ-SEQ sequence */
       WordTrans(Address, i, WRAP4, byteset2, 0, 0, 0, 0, 0);
     }
 
     /* Random number of idle cycles during degranting */
     j = (rand() % 16) + 1;
     WaitLoop(j);
 
     /* Rebuild of the burst after getting grant again */
     if ((temp + i ) <= 4)
     {
       /* Burst was interrupted before the address wrapped around */
       WordTrans(Address + (4*i), 4-temp-i, INCR, byteset2, 0, 0, 0, 0, 0);
       WordTrans(Address - (4*temp), temp, INCR, byteset2, 0, 0, 0, 0, 0);
     }
     else
     {
       /* Burst was interrupted after the address wrapped around */
       WordTrans(QWStart + 4*(temp+i-4),(4 - i),INCR,byteset2, 0, 0, 0, 0, 0);
     }

     /* Check data through reads */
     WordRd(Address, 4, WRAP4, byteset2);
   }
 }

 C("WRAP8 burst termination and rebuild");
 for (k = 0; k < 2; k ++)
 {
   for (i = 1; i < 8; i ++)
   {
     /* WRAP8 burst termination due to degranting */

     /* Generate a random address and align it with a QW address */
     Address = (Addrgen() | SDRAMBase) & 0xFFFFFFE0;
     QWStart   = Address;

     /* Starting address is W0, W1, W2 or W3 depending on random value */
     temp = rand() % 4;
     Address = Address + (4*temp);
 
     if (Busy == 1)
     {
       /* Random number of BUSY transfers */
       BusyCnt = (rand() % 30) + 1;
 
       /* NSEQ-SEQ-BUSY sequence */
       WordTrans(Address, i, WRAP8, byteset2, BusyCnt, i-1, 1, 0, 0);
     }
     else
     {
       /* NSEQ-SEQ sequence */
       WordTrans(Address, i, WRAP8, byteset2, 0, 0, 0, 0, 0);
     }

     /* Random number of idle cycles during degranting */
     j = (rand() % 16) + 1;
     WaitLoop(j);
 
     /* Rebuild of the burst after getting grant again */
     if ((temp + i ) <= 8)
     {
       /* Burst was interrupted before the address wrapped around */
       WordTrans(Address + (4*i), 8-temp-i, INCR, byteset2, 0, 0, 0, 0, 0);
       WordTrans(Address - (4*temp), temp, INCR, byteset2, 0, 0, 0, 0, 0);
     }
     else
     {
       /* Burst was interrupted after the address wrapped around */
       WordTrans(QWStart + 4*(temp+i-8),(8 - i),INCR,byteset2, 0, 0, 0, 0, 0);
     }

     /* Check data through reads */
     WordRd(Address, 8, WRAP8, byteset2);
   }
 }

 C("WRAP16 burst termination and rebuild");
 for (k = 0; k < 2; k ++)
 {
   for (i = 1; i < 16; i ++)
   {
     /* WRAP16 burst termination due to degranting */
 
     /* Generate a random address and align it with a QW address */
     Address = (Addrgen() | SDRAMBase) & 0xFFFFFFC0;
     QWStart   = Address;
 
     /* Starting address is W0, W1, W2 or W3 depending on random value */
     temp = rand() % 4;
     Address = Address + (4*temp);
 
     if (Busy == 1)
     {
       /* Random number of BUSY transfers */
       BusyCnt = (rand() % 30) + 1;
 
       /* NSEQ-SEQ-BUSY sequence */
       WordTrans(Address, i, WRAP16, byteset2, BusyCnt, i-1, 1, 0, 0);
     }
     else
     {
       /* NSEQ-SEQ sequence */
       WordTrans(Address, i, WRAP16, byteset2, 0, 0, 0, 0, 0);
     }
 
     /* Random number of idle cycles during degranting */
     j = (rand() % 16) + 1;
     WaitLoop(j);
 
     /* Rebuild of the burst after getting grant again */
     if (temp + i <= 16)
     {
       /* Burst was interrupted before the address wrapped around */
       WordTrans(Address + (4*i), 16-temp-i, INCR, byteset2, 0, 0, 0, 0, 0);
       WordTrans(Address - (4*temp), temp, INCR, byteset2, 0, 0, 0, 0, 0);
     }
     else
     {
       /* Burst was interrupted after the address wrapped around */
       WordTrans(QWStart+4*(temp+i-16), (16 - i),INCR, byteset2, 0, 0, 0, 0, 0);
     }
 
     /* Check data through reads */
     WordRd(Address, 16, WRAP16, byteset2);
   }
 }
}

/******************************************************************************/
/******************************* Word Write  **********************************/
/******************************************************************************/
void WordTrans(unsigned long address,int datacount,char BurstType[7], 
               unsigned bytedata[128], int BusyCnt, int Position1,
               int PosnCount1, int Position2, int PosnCount2)
{
/*

 Summary : Word Write Function
 =============================
 This function can issue Word data transfers from the AHB ports in all
 the HBURST types. It can also insert any number of BUSY states in the 
 data transfer anywhere in the burst. The BUSY states can be inserted in any
 2 sets of positions in the burst. The positions of the burst where the BUSY
 states are to be inserted are decided by the input arguments Position1 and
 Position2. The number of Positions starting from Position1 where the busy 
 states are to be inserted is decided by the input argument PosnCount1. 
 Similarly, PosnCount2 decides the number of positions in which the busy
 states are to be inserted starting from Position2. The number of BUSY 
 states that are inserted each time is decided by the input argument BusyCnt

*/

 unsigned index=0;
 unsigned i=0,data,k;
 int      count = 1, count1, count2;
 int      Mask;
 char     message [1000];

 if (datacount != 0)
 {
   HSA(address,NSEQ,BurstType,OK,WRD,0x7FFFFFFF, , ,0);
 
   index = ((address) % 64);
 
   datagen(index,4,bytedata);
   data  = bytedata[index+3]*16777216+
           bytedata[index+2]*65536   +
           bytedata[index+1]*256     +
           bytedata[index];
 
   HSW(,data);
 
   if (datacount > Position1)
   {
     if (Position1 >= 1) 
     {
       for (i = 0; i < Position1; i++)
       {
         if (BurstType == WRAP4) 
         {
           Mask      = address & 0x000F;
           if (Mask == 0x0C)
             address = address - 0x0C;
           else 
           address = address + 4;
         }
         else if (BurstType == WRAP8) 
         {
           Mask      = address & 0x001F;
           if (Mask == 0x01C)
             address = address - 0x01C;
           else 
             address = address + 4;
         }
         else if (BurstType == WRAP16) 
         {
           Mask      = address & 0x003F;
           if (Mask == 0x03C)
             address = address - 0x03C;
           else 
             address = address + 4;
         }
         else 
           address    = address + 4;

         HSA(address,SEQ,BurstType,OK,WRD,0x7FFFFFFF, , ,0);
         index = ((address) % 64);

         datagen(index,4,bytedata);
         data  = bytedata[index+3]*16777216+
                 bytedata[index+2]*65536   +
                 bytedata[index+1]*256     +
                 bytedata[index];

         HSW(,data);
         count += 1;
       }
     }
  
     if (PosnCount1 > 0)
     { 
       if (BusyCnt != 0)
       {
         for (k = 0; k < BusyCnt; k++) 
         {
           HSA(,BUSY, ,OK,WRD,0x7FFFFFFF, , ,0);
           HSW(,data, ,Busydata);
         }
       }
     }

     if (datacount > 1)
     {
       if (datacount >= (Position1 + PosnCount1))
         count1 = PosnCount1;
       else
       {
         count1 = datacount - Position1 - 1;
         C("Invalid values :Datacount is lesser than (Position1 + PosnCount1)");
       }
       for (i = 1; i < count1; i++)
       {
         if (BurstType == WRAP4) 
         {
           Mask      = address & 0x000F;
           if (Mask == 0x0C)
             address = address - 0x0C;
           else 
             address = address + 4;
         }
         else if (BurstType == WRAP8) 
         {
           Mask      = address & 0x001F;
           if (Mask == 0x01C)
             address = address - 0x01C;
           else 
             address = address + 4;
         }
         else if (BurstType == WRAP16) 
         {
           Mask      = address & 0x003F;
           if (Mask == 0x03C)
             address = address - 0x03C;
           else 
             address = address + 4;
         }
         else 
           address    = address + 4;

         HSA(address,SEQ,BurstType,OK,WRD,0x7FFFFFFF, , ,0);

         index = ((address) % 64);

         datagen(index,4,bytedata);
         data  = bytedata[index+3]*16777216+
                 bytedata[index+2]*65536   +
                 bytedata[index+1]*256     +
                 bytedata[index];

         HSW(,data);
         count += 1;

         if (BusyCnt != 0)
         {
           for (k = 0; k < BusyCnt; k++) 
           {
             HSA(,BUSY, ,OK,WRD,0x7FFFFFFF, , ,0);
             HSW(,data, ,Busydata);
           }
         }
       }
     }
   }

   for (i = count; i < (Position2 + 1); i++)
   {
     if (BurstType == WRAP4) 
     {
       Mask      = address & 0x000F;
       if (Mask == 0x0C)
         address = address - 0x0C;
       else 
         address = address + 4;
     }
     else if (BurstType == WRAP8) 
     {
       Mask      = address & 0x001F;
       if (Mask == 0x01C)
         address = address - 0x01C;
       else 
         address = address + 4;
     }
     else if (BurstType == WRAP16) 
     {
       Mask      = address & 0x003F;
       if (Mask == 0x03C)
         address = address - 0x03C;
       else 
         address = address + 4;
     }
     else 
       address    = address + 4;

     HSA(address,SEQ,BurstType,OK,WRD,0x7FFFFFFF, , ,0);

     index = ((address) % 64);

     datagen(index,4,bytedata);
     data  = bytedata[index+3]*16777216+
             bytedata[index+2]*65536   +
             bytedata[index+1]*256     +
             bytedata[index];

     HSW(,data);
     count += 1;
   }

   if ((PosnCount2 > 0) && (Position2 < datacount) && 
      (Position2 >= (Position1 + PosnCount1)))
   { 
     if (BusyCnt != 0)
     {
       for (k = 0; k < BusyCnt; k++) 
       {
         HSA(,BUSY, ,OK,WRD,0x7FFFFFFF, , ,0);
         HSW(,data, ,Busydata);
       }
     }
   }

   if ((datacount > Position2) && (datacount > count))
   {
     if (Position2 >= (Position1 + PosnCount1)) 
     {
       if (datacount > (Position2 + PosnCount2))
         count2 = PosnCount2;
       else
       {
         count2 = datacount - Position2 - 1;
         C("Invalid values :Datacount is lesser than (Position2 + PosnCount2)");
       }
       for (i = 1; i < count2; i++)
       {
         if (BurstType == WRAP4) 
         {
           Mask      = address & 0x000F;
           if (Mask == 0x0C)
             address = address - 0x0C;
           else 
             address = address + 4;
         }
         else if (BurstType == WRAP8) 
         {
           Mask      = address & 0x001F;
           if (Mask == 0x01C)
             address = address - 0x01C;
           else 
             address = address + 4;
         }
         else if (BurstType == WRAP16) 
         {
           Mask      = address & 0x003F;
           if (Mask == 0x03C)
             address = address - 0x03C;
           else 
             address = address + 4;
         }
         else 
           address    = address + 4;

         HSA(address,SEQ,BurstType,OK,WRD,0x7FFFFFFF, , ,0);

         index = ((address) % 64);

         datagen(index,4,bytedata);
         data  = bytedata[index+3]*16777216+
                 bytedata[index+2]*65536   +
                 bytedata[index+1]*256     +
                 bytedata[index];
  
         HSW(,data);
         count += 1;
 
         if (BusyCnt != 0)
         {
           for (k = 0; k < BusyCnt; k++) 
           {
             HSA(,BUSY, ,OK,WRD,0x7FFFFFFF, , ,0);
             HSW(,data, ,Busydata);
           }
         }
       }
     }
     else if (PosnCount2 != 0)
     {
       if ((Position1 != Position2) && (PosnCount2 != 0))
         C("Invalid values :Position2 is lesser than Position1");
       else if (Position2 < (Position1 + PosnCount1))
         C("Invalid values :Position2 is lesser than (Position1 + PosnCount1)");
     }
   }

   for (i = count; i < datacount; i++)
   {
     if (BurstType == WRAP4) 
     {
       Mask      = address & 0x000F;
       if (Mask == 0x0C)
         address = address - 0x0C;
       else 
         address = address + 4;
     }
     else if (BurstType == WRAP8) 
     {
       Mask      = address & 0x001F;
       if (Mask == 0x01C)
         address = address - 0x01C;
       else 
         address = address + 4;
     }
     else if (BurstType == WRAP16) 
     {
       Mask      = address & 0x003F;
       if (Mask == 0x03C)
         address = address - 0x03C;
       else 
         address = address + 4;
     }
     else 
       address    = address + 4;

     HSA(address,SEQ,BurstType,OK,WRD,0x7FFFFFFF, , ,0);

     index = ((address) % 64);

     datagen(index,4,bytedata);
     data  = bytedata[index+3]*16777216+
             bytedata[index+2]*65536   +
             bytedata[index+1]*256     +
             bytedata[index];

     HSW(,data);
   }
 }
}

/****************************************************************************/
/******************************* Word Read **********************************/
/****************************************************************************/
void WordRd(unsigned long address,unsigned datacount,char BurstType[7], 
            unsigned bytedata[128])
{
/*

 Summary : WordRd
 ================
 This function generates the AHB slave test bench instructions for
 a wordwide read access. The starting address of the read access
 is the input address. The number of data transfers in the read
 access is same as the input datacount and the data is stored in
 the respective address of the bytedata array input.

*/

 unsigned start=0;
 unsigned index=0;
 unsigned i=0,data;
 int      Mask;

 if (datacount != 0)
 {
   HSA(address,NSEQ,BurstType,OK,WRD,0x7FFFFFFF);
   start = ((address) % 64);
   index = start;
   data  = (bytedata[index+3]*16777216)+
           (bytedata[index+2]*65536)   +
           (bytedata[index+1]*256)     +
           bytedata[index];
   HSR(,data,MaskAll,0xFFFFFFFF, ,firstWdRd);

   for (i = 1; i<datacount ; i++)
   {
     if (BurstType == WRAP4) 
     {
       Mask      = address & 0x000F;
       if (Mask == 0x0C)
         address = address - 0x0C;
       else 
         address = address + 4;
     }
     else if (BurstType == WRAP8) 
     {
       Mask      = address & 0x001F;
       if (Mask == 0x01C)
         address = address - 0x01C;
       else 
         address = address + 4;
     }
     else if (BurstType == WRAP16) 
     {
       Mask      = address & 0x003F;
       if (Mask == 0x03C)
         address = address - 0x03C;
       else 
         address = address + 4;
     }
     else 
       address    = address + 4;

     HSA(address,SEQ,BurstType,OK,WRD,0x7FFFFFFF);

     start = ((address) % 64);
     index = start;
     data  = (bytedata[index+3]*16777216)+
             (bytedata[index+2]*65536)   +
             (bytedata[index+1]*256)     +
              bytedata[index];

     HSR(,data,MaskAll,0xFFFFFFFF, ,WordRd);
   }
 }
}

/******************************************************************************/
/**************************   FQW Access Loop   *******************************/
/******************************************************************************/
void FQWAccessLoop(void)
{
/*

 Summary : Five Quadword Access loop
 ===================================
 This function issues five quadword accesses with random starting addresses. 

*/

 int i, Address;
 int ICol;

 C("Address random - PORT 2");
 for (i=0; i < 18; i++)
 {
   Address = AddrgenBoundary() | SDRAMBase;
   AHBPortFQWAccess(Address);
 }
}

/******************************************************************************/
/************************* AHB Port FQW Access   ******************************/
/******************************************************************************/
void AHBPortFQWAccess(int SDADDR) 
{
/*

 Summary : This Function initiates a misaligned INCR16 from Port 3.
 ==================================================================
 o Deterministic Data is written using an INCR16 burst type and starting
   at an misaligned address.
 o The data is read back starting from the word next in order and also from
   the word in order and verfied.

*/

 int Addr, LoBits, Bound;
 int      i,Wordnum;
 unsigned DevSel, rand_rem32;
 unsigned long address;

 /* Checking for 1KB boundary crossing */
 Addr    =  SDADDR ;
 LoBits = Addr & 0x03FF;
 Bound  = LoBits + (DataCnt16 * 4) + 16;
 if (Bound > 1024)
   Addr = Addr - (DataCnt16 * 4) - 16;
 
 address = Addr + 4*QWInc;
 HSA(address,NSEQ,INCR4);
 HSW(,DATA0);
 HSW(,DATA0);
 HSW(,DATA0);
 HSW(,DATA0);
 
 C(" Five QW Transfers - PORT 2");
 for(Wordnum=0;Wordnum<4;Wordnum++)
 {
   address = Addr + Wordnum*WInc;
   HSA(address,NSEQ,INCR16);
   HSW(,DATA3);
   for (i = 1; i < 16; i++)
   {
     address = address + 4;
     HSA(address,SEQ,INCR16);
     if (i%2 == 0)
       HSW(,DATA4);
     else
       HSW(,DATA5);
   }
   WaitLoop(20);

   /* Read Backs from AHB Port starting from the Word next in order */
   address = Addr + (Wordnum+1)*WInc;
   HSA(address,NSEQ,INCR16);
   HSR(,DATA5,,DATA_Fs);
   for(i=1;i<15;i++)
   {
     address = address + 4;
     HSA(address,SEQ,INCR16);
     if (i%2 == 1)
       HSR(,DATA4,,DATA_Fs);
     else
       HSR(,DATA5,,DATA_Fs);
   }
   address = address + 4;
   HSA(address,SEQ,INCR16);
   HSR(,DATA0,,DATA_0s);
   /* The last word is irrelevant and hence masked */

   WaitLoop(20);

   /* Read Backs from AHB Port starting from the same Word */
   address = Addr + Wordnum*WInc ;
   HSA(address,NSEQ,INCR16);
   HSR(,DATA3,,DATA_Fs);
   for(i=1;i<16;i++)
   {
     address = address + 4;
     HSA(address,SEQ,INCR16);
     if (i%2 == 0)
       HSR(,DATA4,,DATA_Fs);
     else
       HSR(,DATA5,,DATA_Fs);
   }
   WaitLoop(20);

 }
}
