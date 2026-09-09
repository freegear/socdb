/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : RandomRoutines.c.rca
--  File Revision          : 1.5
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Functions used in New Random Test.
--
-- --=========================================================================*/

/******************************************************************************/
/**************************** Random Routines *********************************/
/******************************************************************************/

/*
   A structure to store all the programmable/ readable registers of each memory
   bank.
   TriReg for Trickbox
   SmbReg for UUT
*/
static int MemoryData [8][8192];
static int RemapVal=1;
static int CancelSmWaitEn[8]={0,0,0,0,0,0,0,0};
struct TrickConfig {
              int TriIdCy;   /* Idle Cycle between Rd/Wr (turn around cycles) */
              int TriWSt1;   /* Wait States for Read                          */
              int TriWSt2;   /* Wait States for Write                         */
              int TriMemT;   /* TrickMem Memory Type Register                 */
              int TriMemB;   /* TrickMem Memory addresses base Register       */
              int TriCS2OEn; /* Output Enable Assertion Delay                 */
              int TriCS2WEn; /* Write Enable Assertion Delay                  */
              };

struct UUTConfig {
              int SmbIdCy;   /* Idle Cycle between Rd/Wr (turn around cycles) */
              int SmbWSt1;   /* Wait States for Read                          */
              int SmbWSt2;   /* Wait States for Write                         */
              int SmbWStWEn; /* Write Enable Assertion Delay                  */
              int SmbWStOEn; /* Output Enable Assertion Delay                 */
              int SmbCr;  /* Control Register (Mem Width, Write protect etc.) */
              int SmbSr;  /* Status Register (Errors: Write protect, Timeout) */
              int SmcTrCS2WT; /* External wait enable and SMWAIT assertion    */
              int SmcTrCEWT;  /* SMWAIT deassertion duration                  */ 
              };

/*
  To store the seed values random read and writes for reference.
*/
struct SmbSeed {
               int CrSeed; /* Control seed */
               int RdSeed; /* Read    seed */
               int WrSeed; /* Write   seed */
               };

/* To Store different memory parameters */
struct MemPara {
               int Size;    /* access size  */
               int Address; /* Base Address */
               };

struct TrickConfig TriReg[8];
struct UUTConfig   RtlReg[8];
struct SmbSeed     SeedBank[8];
struct MemPara     MemBank[8];

/* Control reg bits */
enum SmbCrBits  {RTLRBLE, WAITPOL, RTLWAITEN, RTLCSPOL, WP, BM, MW0, MW1};
/* Status reg bits */
enum SmbSrBits  {BUSERR, WRITEPROTERR, WAITTOUTERR, WAITSTATUS};
/* Trick MemT reg bits */
enum TrMemTBits {MEMSIZE0, MEMSIZE1, ROM, BROM, MAXACCERMASK, ACCERMASK, TRIRBLE,
                 TRICSPOL, TRIWAITEN};
enum BankNo     {BANK0, BANK1, BANK2, BANK3, BANK4, BANK5, BANK6, BANK7};
enum RegNo      {IDCY, WST1, WST2, WSTOEN, WSTWEN, CR, SRRD, SRWR, TRCS2WT, 
                 TRCEWT};

enum HSIZE      {BYTESIZE, HWRDSIZE, WRDSIZE, DUMMY};
enum BurstType  {BSINGLE, BINCR, BINCR4, BINCR8, BINCR16, BWRAP4, BWRAP8, BWRAP16};
enum Mask       {BITS4, TrMCREQD, TrGNT2RMREQ};

enum RDWR {RD, WR};


const RegMask[10] = {0x0000000F, 0x0000001F, 0x0000001F, 0x0000000F, 0x0000000F,
                    0x000000FF, 0x0000000F, 0x00000007, 0x00FFFFFF, 0x00FFFFFF};

const WPERRMASK = 0x1 << WRITEPROTERR;
const WPERR     = 0x1 << WRITEPROTERR;
const TRINOBROMROM = 0x7F3;
const RTLNOBROMROM = 0xCF;

char* BurstString[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};

int BigEndian;

/*
  To Initialise all the seeds for all the banks.
*/
void InitSeed(int Seed)
{
  int i;

  BigEndian = 0;

  for(i=0; i<8; i++)
  {
    SeedBank[i].CrSeed = Seed*(i+1);
    SeedBank[i].RdSeed = (Seed+1)*(i+1);
    SeedBank[i].WrSeed = (Seed+2)*(i+1);
  }
}

/* Store the size of memory for future reference */
void WhatIsSize()
{
  int i;

  for(i=0; i<8; i++)
  {
    MemBank[i].Size = ((RtlReg[i].SmbCr >> MW0) & 0x3);
  }
}

/* To Store the Address for easy reference */
void StoreAddress()
{
  MemBank[0].Address = SMCMEM_0;
  MemBank[1].Address = SMCMEM_1;
  MemBank[2].Address = SMCMEM_2;
  MemBank[3].Address = SMCMEM_3;
  MemBank[4].Address = SMCMEM_4;
  MemBank[5].Address = SMCMEM_5;
  MemBank[6].Address = SMCMEM_6;
  MemBank[7].Address = SMCMEM_7;
}

/* Randomly program MCBUSREQ related registers */
void RandInitMcBusReq()
{
  int Val;
  /* Program the delay value */
  Val = random();
  Val = Val & RegMask[TrMCREQD];
  HSA(SMCTrMCREQD, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , Val);

  /* Program the time between getting grant and deasserting busreq */
  Val = random();
  Val = Val & RegMask[TrGNT2RMREQ];
  HSA(SMCTrGNT2RMREQ, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , Val);

  /* Program MC Address (to be used by SMC as SMADDR when the gnt is given */
  Val = random();
  HSA(SMCTrMCADDR, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
  HSW( , Val);
}

/*
  Randomise all the control values for the all 8 memory banks.
  Store a reference of programmed values for Trick and UUT.
  Program these values using functions ConfigureUUT and ConfigureMemory in
  SmcCommon.c.
*/
void ConfigureBanks(int UseTrickMem)
{
  int i, Cr, Val; 
  int RtlVal, TriVal;
  char PrntStr[120];
  int AllCSPOL;

  Cr       = 0;
  Val      = 0;
  RtlVal   = 0;
  TriVal   = 0;
  AllCSPOL = 0;
  
  /* Configure MCBUSREQ generating trick registers */
  RandInitMcBusReq();

  for(i=0; i<8; i++)
  {
    Cr = SeedBank[i].CrSeed;
    /* Generate a Random number using the control seed. */
    srandom(Cr++);
    Val = random();
    /* RegMask the unwanted bits */
    Val = Val & RegMask[IDCY];
    /* Store the value in the control struct UUTConfig */
    RtlReg[i].SmbIdCy = Val;
    /* Store the value in the control struct TrickConfig */
    TriReg[i].TriIdCy = Val;

    /* Generate a Random number using the control seed. */
    /* srandom(Cr++); */
    Val = random();
    /* RegMask the unwanted bits */
    Val = Val & RegMask[WST1];
    /* Store the value in the control struct UUTConfig */
    RtlReg[i].SmbWSt1 = Val;
    /* Store the value in the control struct TrickConfig */
    TriReg[i].TriWSt1 = Val;

    /* Generate a Random number using the control seed. */
    /* srandom(Cr++); */
    Val = random();
    /* RegMask the unwanted bits */
    Val = Val & RegMask[WST2];
    /* Store the value in the control struct UUTConfig */
    RtlReg[i].SmbWSt2 = Val;
    /* Store the value in the control struct TrickConfig */
    TriReg[i].TriWSt2 = Val;

    /* Generate a Random number using the control seed. */
    /* srandom(Cr++); */
    Val = random();
    /* make sure that WSTOEN is less than or equal to SmbWSt1 TODO */
    Val = Val ? Val%(RtlReg[i].SmbWSt1 + 1) : 0;
    /* RegMask the unwanted bits */
    Val = Val & RegMask[WSTOEN];
    /* Store the value in the control struct UUTConfig */
    RtlReg[i].SmbWStOEn = Val;
    /* Store the value in the control struct TrickConfig */
    TriReg[i].TriCS2OEn = Val;

    /* Generate a Random number using the control seed. */
    /* srandom(Cr++); */
    Val =  random();
    /* make sure that WSTWEN is less than or equal to SmbWSt2 TODO */
    Val = Val ? Val%(RtlReg[i].SmbWSt2 + 1) : 0;
    /* RegMask the unwanted bits */
    Val = Val & RegMask[WSTWEN];
    /* Store the value in the control struct UUTConfig */
    RtlReg[i].SmbWStWEn = Val;
    /* Store the value in the control struct TrickConfig */
    TriReg[i].TriCS2WEn = Val;

    /* Generate a Random number using the control seed. */
    /* srandom(Cr++); */
    /* Generate a random memory width */
    Val = random()%3;
    RtlVal = Val << MW0;
    /* Generate a random chip select*/
    Val = random()%2;
    RtlVal = RtlVal | (Val << RTLCSPOL);
    /* Generate a random Burst Mode enable*/
    Val = random()%2;
    /* RtlVal = RtlVal | (Val << BM); TODO */
    /* Generate a random Write Protect enable*/
    /*Val = random()%2;
    RtlVal = RtlVal | (Val << WP); TODO */
    /* Generate a random WaitEn and WaitPol */
    Val = random();
    Val = Val>>5;
    Val = Val%3;
    RtlVal = RtlVal | (Val << RTLWAITEN);
    /* Set RBLE TODO */
    RtlVal = RtlVal | (0x1 << RTLRBLE);
    /* RegMask the unwanted bits */
    Val = Val & RegMask[CR];
    /* Store the value in the control struct UUTConfig */
    RtlReg[i].SmbCr = RtlVal;

    /* Fabricate the control value for TrickConfig */
    RtlVal = RtlReg[i].SmbCr;
    TriVal = 0;
    /* the width bits in UUT are 6, 7 and in Trick 0, 1 */
    TriVal = RtlVal >> MW0;

    /* Find if the bit n UUT Cr is set, move it to the LSB, and move it 
     * to the respective place of TrMemT reg. */
     
    /* Bit 2 reflects if a memory is ROM - equivalent to WP of UUT Cr. TODO */
/*    TriVal = TriVal | (((RtlVal & (0x1 << WP)) >> WP) << ROM); */

    /* Bit 3 reflects if a memory is in Burst mode - equivalent to BM of UUT 
     * Cr.  TODO */
/*    TriVal = TriVal | (((RtlVal & (0x1 << BM)) >> BM) << BROM); */

    /* Bit 4, 5 are kept zero to enable error display. bit 6 is RBLE. */
    TriVal = TriVal | (((RtlVal & (0x1 << RTLRBLE)) >> RTLRBLE) << TRIRBLE);

    /* Next is bit 7, CS Polarity bit. */
    TriVal = TriVal | (((RtlVal & (0x1 << RTLCSPOL)) >> RTLCSPOL) << TRICSPOL);

    /* Bit 8 - wait enable bit - not there in VP - used in code FIXME */
    TriVal = TriVal | (((RtlVal & (0x1 << RTLWAITEN)) >> RTLWAITEN) << TRIWAITEN);
    
    TriReg[i].TriMemT = TriVal;

    /* Store the value of CSPOL */
    AllCSPOL = AllCSPOL | 
                      (((RtlVal & (0x1 << RTLCSPOL)) >> RTLCSPOL) << i);

    /* Store the base Memory address. */
    /* Time being kept zero TODO      */
    TriReg[i].TriMemB = 0;

    /* Status Reg in UUT is written with write mask to clear all the errors.
     * Note that ConfigureUUT does not write this value, it is to be written/
     * Read independently. 
     */
    RtlReg[i].SmbSr = RegMask[SRWR];

    /* SMWAIT Assertion and deassertion timing */
    /* srandom(Cr++); */
    Val = random();
    /* RegMask the unwanted bits */
    Val = Val & RegMask[TRCS2WT];
    /* Store the value in the control struct UUTConfig */
    RtlReg[i].SmcTrCS2WT = Val;

    /* SMWAIT Assertion and deassertion timing */
    /* srandom(Cr++); */
    Val = random();
    /* RegMask the unwanted bits */
    Val = Val & RegMask[TRCEWT];
    /* Store the value in the control struct UUTConfig */
    RtlReg[i].SmcTrCEWT = Val;
  }

  /* Now program the values */
  for(i=0; i<8; i++)
  {
    ConfigureUUT(i, RtlReg[i].SmbIdCy, RtlReg[i].SmbWSt1, RtlReg[i].SmbWSt2,
                 RtlReg[i].SmbWStOEn, RtlReg[i].SmbWStWEn, RtlReg[i].SmbCr, 
                 RtlReg[i].SmcTrCS2WT, RtlReg[i].SmcTrCEWT);
    
    if(UseTrickMem)
      ConfigureMemory(i, TriReg[i].TriIdCy, TriReg[i].TriWSt1, TriReg[i].TriWSt2,
                    TriReg[i].TriMemT, TriReg[i].TriMemB, TriReg[i].TriCS2OEn,
                    TriReg[i].TriCS2WEn, AllCSPOL);
  }
  WhatIsSize();
  StoreAddress();
}


int IsThisROM(int BankNumber)
{
  int IsWP, IsBROM;

  IsWP   = (RtlReg[BankNumber].SmbCr >> WP) & 0x1;
  IsBROM = (RtlReg[BankNumber].SmbCr >> BM) & 0x1;
  return (IsWP | IsBROM);
}

void InitTrickArray(int BankNumber, int StartAddr, int EndAddr)
{
  int Addr, WData;
  int i;
  int Addr32Bit;

  Addr = StartAddr;

  srandom(Addr);
  Addr32Bit = (Addr & 0x1FFF) >> 2;
  WData = random();

  HSA(Addr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , WData);
  MemoryData[BankNumber][Addr32Bit] = WData; 
  Addr += 4;
  while(Addr <= EndAddr)
  {   
    srandom(Addr);
    Addr32Bit = (Addr & 0x1FFF) >> 2;
    WData = random();
    HSW( , WData);
    MemoryData[BankNumber][Addr32Bit] = WData; 
    Addr += 4;
  }
}

/* To Initialise Word memory */
void InitMemoryWrd(int BankNumber, int StartAddr, int EndAddr)
{
  int Addr, WData;
  int i;
  int Addr32Bit;

  Addr = StartAddr;

  srandom(Addr);
  Addr32Bit = Addr & 0x1FFF;
  WData = random();

  HSA(Addr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , WData);
  MemoryData[BankNumber][Addr32Bit] = WData; 
  while(Addr <= EndAddr)
  {   
    srandom(Addr);
    Addr32Bit = Addr & 0x1FFF;
    WData = random();
    HSW( , WData);
    MemoryData[BankNumber][Addr32Bit] = WData; 
    Addr += 4;
  }
}

/* To Initialise HWord memory */
void InitMemoryHWrd(int BankNumber, int StartAddr, int EndAddr)
{
  int Addr, WData,MaskdWData;
  int i,WordFinder;
  int PresntData,Addr32Bit;
  char PrntStr[120];

  Addr = StartAddr;
  sprintf(PrntStr, "Address received: Start = %x, End = %x", Addr, EndAddr);
  C(PrntStr);

  srandom(Addr);
  WData = random() & 0xFFFF;

  HSA(Addr, NSEQ, INCR, , HWRD, , 0x1, , , , ,);
  HSW( , WData);
  WordFinder = (Addr & 2) >> 1;
  Addr32Bit = (Addr & 0x01FFF);
  switch(WordFinder)
  {
    case 0  : PresntData = MemoryData[BankNumber][Addr32Bit] & (0xFFFF0000);
              MaskdWData = WData & (0x0000FFFF);
              break;
    case 1 :  PresntData = MemoryData[BankNumber][Addr32Bit] & (0x0000FFFF); 
              MaskdWData = WData & (0xFFFF0000);
              break;
    default : break;
  }
  MemoryData[BankNumber][Addr32Bit] = MaskdWData | PresntData; 
  while (Addr <= EndAddr)
  {   
    srandom(Addr);
    WData = random() & 0xFFFF;
    HSW( , WData);
  WordFinder = (Addr & 2) >> 1;
  Addr32Bit = (Addr & 0x1FFF);
  switch(WordFinder)
  {
    case 0  : PresntData = MemoryData[BankNumber][Addr32Bit] & (0xFFFF0000);
              MaskdWData = WData & (0x0000FFFF);
              break;
    case 1 :  PresntData = MemoryData[BankNumber][Addr32Bit] & (0x0000FFFF); 
              MaskdWData = WData & (0xFFFF0000);
              break;
    default : break;
  }
  MemoryData[BankNumber][Addr32Bit] = MaskdWData | PresntData; 
  Addr += 2;
  }
}

/* To Initialise Byte memory */
void InitMemoryByte(int BankNumber, int StartAddr, int EndAddr)
{
  int Addr, WData;
  int MaskdWData;
  int WordFinder;
  int PresntData,Addr32Bit;

  Addr = StartAddr;

  srandom(Addr);
  WData = random() & 0xFF;

  HSA(Addr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSW( , WData);
  WordFinder = (Addr & 3);
  Addr32Bit = (Addr & 0x1FFF);
  switch(WordFinder)
  {
    case 0  : PresntData = MemoryData[BankNumber][Addr32Bit] & (0xFFFFFF00);
              MaskdWData = WData & (0x000000FF);
              break;
    case 1 :  PresntData = MemoryData[BankNumber][Addr32Bit] & (0xFFFF00FF); 
              MaskdWData = WData & (0x0000FF00);
              break;
    case 2 :  PresntData = MemoryData[BankNumber][Addr32Bit] & (0xFF00FFFF); 
              MaskdWData = WData & (0x00FF0000);
              break;
    case 3 :  PresntData = MemoryData[BankNumber][Addr32Bit] & (0x00FFFFFF); 
              MaskdWData = WData & (0xFF000000);
              break;
    default : break;
  }
  MemoryData[BankNumber][Addr32Bit] = MaskdWData | PresntData; 
  while(Addr <= EndAddr)
  {   
    srandom(Addr);
    WData = random() & 0xFF;
    HSW( , WData);
  WordFinder = (Addr & 3);
  Addr32Bit = (Addr & 0x1FFF);
  switch(WordFinder)
  {
    case 0  : PresntData = MemoryData[BankNumber][Addr32Bit] & (0xFFFFFF00);
              MaskdWData = WData & (0x000000FF);
              break;
    case 1 :  PresntData = MemoryData[BankNumber][Addr32Bit] & (0xFFFF00FF); 
              MaskdWData = WData & (0x0000FF00);
              break;
    case 2 :  PresntData = MemoryData[BankNumber][Addr32Bit] & (0xFF00FFFF); 
              MaskdWData = WData & (0x00FF0000);
              break;
    case 3 :  PresntData = MemoryData[BankNumber][Addr32Bit] & (0x0000FFFF); 
              MaskdWData = WData & (0xFF000000);
              break;
    default : break;
  }
  MemoryData[BankNumber][Addr32Bit] = MaskdWData | PresntData; 
  Addr++;
  }
}

/* To write one word into word memory */
void WriteDataWord(int BankNumber, int Address, int OffSet)
{
  /* Address is used as Seed. The nonzero OffSet value makes sure that we write
   * different data from the initial data in later writes. 
   */
  int WData, Seed;
  int Status;
  int SMBSR;

  Seed  = Address+OffSet;
  srandom(Seed);
  WData = random();   /* Genrate a Data randomly */

  if(IsThisROM(BankNumber))
  {
    HSA(Address, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
    HSW(, WData);

    /* Check for write protect error */
    SMBSR = SMCCR_BASE + 28*BankNumber + 24;
    HSA(SMBSR, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
    HSR( , WPERR, , NoMask, ,WriteProtectErr_1);
  }
  else
  {
    HSA(Address, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
    HSW( , WData);
  }
}

/* To write one hword into hword memory */
void WriteDataHWord(int BankNumber, int Address, int OffSet)
{
  /* Address is used as Seed. The nonzero OffSet value makes sure that we write
   * different data from the initial data in later writes. 
   */
  int WData, Seed;
  int Status;
  int SMBSR;
  int Mask_tmp;

  Seed  = Address+OffSet;
  srandom(Seed);
  WData = random() & (0xFFFF << ((Address%4)*8));  /* Genrate a Data randomly */
  Mask_tmp = 0xFFFF << ((Address%4)*8);

  if(IsThisROM(BankNumber))
  {
    HSA(Address, NSEQ, SINGLE, , HWRD, , 0x1, , , , ,);
    HSW(, WData);

    /* Check for write protect error */
    SMBSR = SMCCR_BASE + 28*BankNumber + 24;
    HSA(SMBSR, NSEQ, SINGLE, , HWRD, , 0x1, , , , ,);
    HSR( , WPERR, , Mask_tmp, ,WriteProtectErr_2);
  }
  else
  {
    HSA(Address, NSEQ, SINGLE, , HWRD, , 0x1, , , , ,);
    HSW( , WData);
  }
}

/* To write one byte into byte memory */
void WriteDataByte(int BankNumber, int Address, int OffSet)
{
  /* Address is used as Seed. The nonzero OffSet value makes sure that we write
   * different data from the initial data in later writes. 
   */
  int WData, Seed;
  int Status; /* Find how to read something into a variable TODO */
  int SMBSR;
  int Mask_tmp;

  Mask_tmp = 0xFF << ((Address%4)*8);
  Seed  = Address+OffSet;
  srandom(Seed);
  WData = random() & (0xFF << ((Address%4)*8));   /* Genrate a Data randomly */

  if(IsThisROM(BankNumber))
  {
    HSA(Address, NSEQ, SINGLE, , BYTE, , 0x1, , , , ,);
    HSW(, WData);

    /* Check for write protect error */
    SMBSR = SMCCR_BASE + 28*BankNumber + 24;
    HSA(SMBSR, NSEQ, SINGLE, , BYTE, , 0x1, , , , ,);
    HSR( , WPERR, , Mask_tmp, ,WriteProtectErr_3);
  }
  else
  {
    HSA(Address, NSEQ, SINGLE, , BYTE, , 0x1, , , , ,);
    HSW( , WData);
  }
}

/* To read one byte into word memory */
void ReadDataWord(int BankNumber, int Address, int OffSet)
{
  /* Address is used as Seed. The nonzero OffSet value makes sure that we write
   * different data from the initial data in later writes. So while reading the
   * expected data is generated using the OffSet for nonROM devices.
   */
  int RData, Seed;

  if(IsThisROM(BankNumber))
  {
    Seed  = Address;
  }
  else
  {
    Seed  = Address+OffSet;
  }

  srandom(Seed);
  RData = random();
  HSA(Address, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , RData, , NoMask, ,ReadMismatch_0);
}

/* To read one byte into byte memory */
void ReadDataHWord(int BankNumber, int Address, int OffSet)
{
  /* Address is used as Seed. The nonzero OffSet value makes sure that we write
   * different data from the initial data in later writes. So while reading the
   * expected data is generated using the OffSet for nonROM devices.
   */
  int RData, Seed;
  int Mask_tmp;

  Mask_tmp = 0xFFFF << ((Address%4)*8);
  
  if(IsThisROM(BankNumber))
  {
    Seed  = Address;
  }
  else
  {
    Seed  = Address+OffSet;
  }

  srandom(Seed);
  RData = random() & 0xFFFF;
  HSA(Address, NSEQ, SINGLE, , HWRD, , 0x1, , , , ,);
  HSR( , RData, , Mask_tmp, ,ReadMismatch_1);
}


/* To read one byte into byte memory */
void ReadDataByte(int BankNumber, int Address, int OffSet)
{
  /* Address is used as Seed. The nonzero OffSet value makes sure that we write
   * different data from the initial data in later writes. So while reading the
   * expected data is generated using the OffSet for nonROM devices.
   */
  int RData, Seed;
  int Mask_tmp;

  Mask_tmp = 0xFF << ((Address%4)*8);

  if(IsThisROM(BankNumber))
  {
    Seed  = Address;
  }
  else
  {
    Seed  = Address+OffSet;
  }

  srandom(Seed);
  RData = random() & 0xFF;
  HSA(Address, NSEQ, SINGLE, , BYTE, , 0x1, , , , ,);
  HSR( , RData, , Mask_tmp, ,ReadMismatch_2);
}

/* To Read Word memory Sequentially*/
void SeqReadMemWrd(int BankNumber, int StartAddr, int EndAddr)
{
  int Addr, RData;
  int i;
  char PrntStr[120];

  Addr = StartAddr;
  sprintf(PrntStr, "Address received: Start = %x, End = %x", Addr, EndAddr);
  C(PrntStr);

  srandom(Addr);
  RData = random();

  HSA(Addr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RData, , NoMask, ,ReadSeq_0);
  while(Addr <= EndAddr)
  {   
    srandom(Addr);
    RData = random();
    HSR( , RData, , NoMask, ,ReadSeq_1);
    Addr = Addr + 4;
  }
}

/* To Read HWord memory Sequentially*/
void SeqReadMemHWrd(int BankNumber, int StartAddr, int EndAddr)
{
  int Addr, RData;
  int i;
  char PrntStr[120];
  int Mask_tmp;

  Addr = StartAddr;
  sprintf(PrntStr, "Address received: Start = %x, End = %x", Addr, EndAddr);
  C(PrntStr);

  srandom(Addr);
  RData = random() & 0xFFFF;

  Mask_tmp = 0xFFFF << ((Addr%4)*8);

  HSA(Addr, NSEQ, INCR, , HWRD, , 0x1, , , , ,);
  HSR( , RData, , Mask_tmp, ,ReadSeq_2);
  while(Addr <= EndAddr)
  {   
    srandom(Addr);
    Mask_tmp = 0xFFFF << ((Addr%4)*8);
    RData = (random() & 0xFFFF) << ((Addr%4)*8);
    HSR( , RData, , Mask_tmp, ,ReadSeq_3);
    Addr = Addr + 2;
  }
}

/* To read Byte memory */
void SeqReadMemByte(int BankNumber, int StartAddr, int EndAddr)
{
  int Addr, RData;
  int Mask_tmp;
  char PrntStr[120];

  Addr = StartAddr;
  sprintf(PrntStr, "Address received: Start = %x, End = %x", Addr, EndAddr);
  C(PrntStr);

  srandom(Addr);
  RData = random() & 0xFF;

  Mask_tmp = 0xFF << ((Addr%4)*8);
  HSA(Addr, NSEQ, INCR, , BYTE, , 0x1, , , , ,);
  HSR( , RData, , Mask_tmp, ,ReadSeq_4);
  while(Addr <= EndAddr)
  {   
    srandom(Addr);
    Mask_tmp = 0xFF << ((Addr%4)*8);
    RData = (random() & 0xFF) << ((Addr%4)*8);
    HSR( , RData, , Mask_tmp, ,ReadSeq_5);
    Addr++;
  }
}

/* To write one data into the memory */
void WriteData(int BankNumber, int Size, int Address, int OffSet)
{
  switch(Size)
  {
    case WRDSIZE  : WriteDataWord(BankNumber, Address, OffSet);
                break;
    case HWRDSIZE : WriteDataHWord(BankNumber, Address, OffSet);
                break;
    case        3 : 
    case BYTESIZE : WriteDataByte(BankNumber, Address, OffSet);
                break;
    default   : C("Unrecognised Size in WriteData");
                break;
  }
}

/* To read one data from the memory */
void ReadData(int BankNumber, int Size, int Address, int OffSet)
{
  switch(Size)
  {
    case WRDSIZE  : ReadDataWord(BankNumber, Address, OffSet);
                break;
    case HWRDSIZE : ReadDataHWord(BankNumber, Address, OffSet);
                break;
    case BYTESIZE : ReadDataByte(BankNumber, Address, OffSet);
                break;
    default   : C("Unrecognised Size in ReadData");
                break;
  }
}

/* To initialise the memory */
void InitMemory(int BankNumber, int Size, int StartAddr, int EndAddr)
{
  char PrntStr[120];
  switch(Size)
  {
    case WRDSIZE  : InitMemoryWrd(BankNumber, StartAddr, EndAddr);
                break;
    case HWRDSIZE : InitMemoryHWrd(BankNumber, StartAddr, EndAddr);
                break;
    case BYTESIZE : 
    case        3 : InitMemoryByte(BankNumber, StartAddr, EndAddr);
                break;
    default   : sprintf(PrntStr, "Unrecognised Size %d in memory.", Size);
                C(PrntStr);
                break;
  }
}

/* To sequentially read memory */
void SeqReadMem(int BankNumber, int Size, int StartAddr, int EndAddr)
{
  char PrntStr[120];
  switch(Size)
  {
    case WRDSIZE  : SeqReadMemWrd(BankNumber, StartAddr, EndAddr);
                break;
    case HWRDSIZE : SeqReadMemHWrd(BankNumber, StartAddr, EndAddr);
                break;
    case BYTESIZE : 
    case        3 : SeqReadMemByte(BankNumber, StartAddr, EndAddr);
                break;
    default   : sprintf(PrntStr, "Unrecognised Size %d in memory.", Size);
                C(PrntStr);
                break;
  }
}

/* To program random values in CS2WT and CWEN registers for random assertion and
 * deassertion of SMWAIT signal 
 */
void RandExtWEN(int BankNumber, int Seed)
{
  int Val;
  int SMCTrCS2WT, SMCTrCEWT, SMBCRData;
  int TrCEWTVal,WaitFlag; 
  switch (BankNumber)
  {
    case 0 : SMCTrCS2WT = SMCTrCS2WTR0;
             SMCTrCEWT  = SMCTrCEWTR0;
             SMBCRData  = RtlReg[0].SmbCr;
             break;
    case 1 : SMCTrCS2WT = SMCTrCS2WTR1;
             SMCTrCEWT  = SMCTrCEWTR1;
             SMBCRData  = RtlReg[1].SmbCr;
             break;
    case 2 : SMCTrCS2WT = SMCTrCS2WTR2;
             SMCTrCEWT  = SMCTrCEWTR2;
             SMBCRData  = RtlReg[2].SmbCr;
             break;
    case 3 : SMCTrCS2WT = SMCTrCS2WTR3;
             SMCTrCEWT  = SMCTrCEWTR3;
             SMBCRData  = RtlReg[3].SmbCr;
             break;
    case 4 : SMCTrCS2WT = SMCTrCS2WTR4;
             SMCTrCEWT  = SMCTrCEWTR4;
             SMBCRData  = RtlReg[4].SmbCr;
             break;
    case 5 : SMCTrCS2WT = SMCTrCS2WTR5;
             SMCTrCEWT  = SMCTrCEWTR5;
             SMBCRData  = RtlReg[5].SmbCr;
             break;
    case 6 : SMCTrCS2WT = SMCTrCS2WTR6;
             SMCTrCEWT  = SMCTrCEWTR6;
             SMBCRData  = RtlReg[6].SmbCr;
             break;
    case 7 : SMCTrCS2WT = SMCTrCS2WTR7;
             SMCTrCEWT  = SMCTrCEWTR7;
             SMBCRData  = RtlReg[7].SmbCr;
             break;
    default : break;
  }
  /* srandom(Seed); */
  Val = random();
  /*Val = Val & RegMask[TRCS2WT];*/
  Val = Val & RegMask[WSTOEN];
  Val = Val ? Val : 0x1;
  HSA(SMCTrCEWT, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , Val);
  TrCEWTVal = Val;
  Val = random();
  /*Val = Val & RegMask[TRCEWT];*/
  Val = Val & RegMask[WSTOEN];
  Val = Val ? Val : 0x1;
  Val = Val | ((SMBCRData & 0x6) << 23);
  HSA(SMCTrCS2WT, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , Val);

  Val = random() ;
  Val = (Val & 0x3F) | 0x20;
  WaitFlag = ((SMBWST1Val[BankNumber] <= SMCTrCS2WT) || 
              (SMBWST2Val[BankNumber] <= SMCTrCS2WT)) ? 0x0 : 0x1;
  CancelSmWaitEn[BankNumber] = ((Val & 0x20) && (SMBCRData & 0x4)) && WaitFlag;
  Val = (Val & 0x1F) % TrCEWTVal | (Val & 0x20);
  Val = Val & 0x1F  ? Val : 0x1;
  HSA(SMCTrCNCLWAIT, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSW( , Val);
  
}

/******************************************************************************/
/****************************** InitTransRnd **********************************/
/******************************************************************************/
GenTransRnd(int *trans, int burst, int seed)
{
  /*
     Summary : InitTransRnd
     ======================
     o It generates the sequence of HTRANS randomly and inserts SEQ or NSEQ 
       according to the value of burst and returns trans array.
     o Care is taken to 
       - Start with an NSEQ
       - Insert an NSEQ after an idle
       - Not inserting more than one idle cycle consequtively
  */ 
  int i = 1, cnt = 1, ValRand, Val2Bit, Val1Bit;
  trans[0] = 2;
  while(cnt != burst)
  {
     /*srand(seed++); */
     ValRand = rand();
     Val1Bit = ValRand >> 5;
     Val1Bit = Val1Bit & 0x1;

     /* Generate a random number between 1,2,3. */
     trans[i] = (rand() % 0x00000003) + 1;

     /* if previous cycle is IDLE then make this cycle as NSEQ */
     if(trans[i-1] == 0)
       trans[i] = 2;
     /* else if previous cycle was SEQ or NSEQ then this cycle can be IDLE, BUSY
      * SEQ or NSEQ 
      */
     else if(((trans[i-1] == 2) && (trans[i] == 2)) || 
             ((trans[i-1] == 3) && (trans[i] == 3)))
       trans[i] = Val1Bit ? rand() % 0x00000001 : trans[i];


     /* count number of valid transactions */
     if((trans[i] == 2) || (trans[i] == 3))
       cnt++;

     i++;
  }
  trans[i] = 5;
}

/******************************************************************************/
/******************************* RandSize *************************************/
/******************************************************************************/
int RandSize()
{
   int Size;
   Size = rand () % 3;
   return(Size);
}

/******************************************************************************/
/****************************** RandAddress ***********************************/
/******************************************************************************/
int RandAddress(Size)
{
   int Addr;
   if (Size == 0)
     Addr = (rand () & 0x000001FF);
   else if (Size == 1)
     Addr = (rand () & 0x000001FE);
   else if (Size == 2)
     Addr = (rand () & 0x000001FC);
   else if (Size == 3)
     Addr = (rand () & 0x000001F1); 
   return(Addr);
}
/******************************************************************************/
/***************************** RandChipSel ***********************************/
/******************************************************************************/
int RandChipSel()
{
   int Chip;
   Chip = rand () % 8;
   return(Chip);
}
/******************************************************************************/
/******************************* RandData *************************************/
/******************************************************************************/
int RandData()
{
   int Data;
   Data = rand () % 0x000FFFFF;
   return(Data);
}
/******************************************************************************/
/****************************** RandBurst *************************************/
/******************************************************************************/
int RandBurst()
{
   int Burst;
   Burst = rand () % 0x8;
   return(Burst);
}

/******************************************************************************/
/****************************** RandOper **************************************/
/******************************************************************************/
char RandOper()
{
   int Type;
   char Oper;
   Type = rand () % 0x2;
   if (Type == 0)
     Oper = 'w';
   else
     Oper = 'r';
   return(Oper);
}

/* Assert McBusReq randomly */
void RandMcBusReq()
{
  int Val, i, LoopNo;

  Val = random();

  LoopNo = Val%5;
  for(i=0; i<LoopNo; i++)
  {
    HSA(SMCTrMCBUSR, NSEQ, SINGLE, OK, WRD, , 0x1, , , , ,);
    HSW( , Val);
  }

}

/* Randomly select and write/ read a register of Smc. */
void RandRegAccess()
{
  int RegAddr;
  int RegData;
  int i, LoopNo;

  /* Generate a random data. */
  RegData = random();
  
  /* Access the Registers random number of times ranging between 0 to 5 */
  LoopNo = RegData%6;
  for(i=0; i<LoopNo; i++)
  {
    /* Generate a random address that will fit in the register map */
    RegAddr = random();
    RegAddr = RegAddr % 0xE0;
    RegAddr = RegAddr & 0xFC;
 
    RegAddr = SMCCR_BASE + RegAddr;
 
    HSA(RegAddr, NSEQ, SINGLE, , WRD, 0x1, , , , , ,);
    HSR( , RegData, , , ,RandRegAccess_r0);
  }
  if(LoopNo%2);
  {
    HSA(SMBIDCYR0, NSEQ, INCR, , WRD, 0x1, , , , , ,);
    HSW( , RtlReg[0].SmbIdCy, ,RandRegAccess_w);
    HSA(SMBIDCYR0, IDLE, INCR, , WRD, 0x1, , , , , ,);
    HSW( , 0x0, ,RandRegAccess_w);
    HSA(SMBIDCYR0, NSEQ, INCR, , WRD, 0x1, , , , , ,);
    HSR( , RtlReg[0].SmbIdCy, ,NoMask, ,RandRegAccess_r1);
  }
}

/******************************************************************************/
/***************************** Sequence in Random *****************************/
/******************************************************************************/
void RndSequence(char op, int32 Address, int trans[],char* burst, int size,
              int32 Data,int endian,int BankNumber)
{
  /*
    Summary : Sequence()
    ====================
    It does the following operations

    o It performs memory write operations depending on the parameters(size,
      burst, sequence of transfers, endian, address and data)passed to this
      function.
      Transfers can be specified in an array and 2 will be
      interpreted as NSEQ, 3 as SEQ, 0 as IDLE and 1 as BUSY. Last parameter
      of the array should be '5' indicates the function that the expected
      transfers are complete. hsize can be specified as integer value.
      If size is '0', it'll be interpreted as "BYTE", if '1' then "HWRD"
      and if '2' then "WRD".
      Burst can be specified as described in busheader.h file.
      When endian is 0, transfers will be done in little endian mode and when 1,
      transfers are done in big endian.

    o It reads back the data with the parameters passed to this function and
      verifies the data integrity
  */
  int RandVal;
  int lsb,i,maskpos,hsize,flag,AddrLSB,Addr2BitLSB;
  char PrintStr[75];
  int32 maskval,tempdata;
  int32 mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int htrans;
  int WData,MaskdWData;
  int WordFinder,ArrData;
  int PresntData,Addr32Bit,Address1;
  char sizearr[3] = {'b', 'h', 'w'};
  char* transarr[4] = {"i","b","n","s"};
  char* SizeStr[3] = {"BYTE", "HALFWORD", "WORD"};
  char* response[2] = {"ok","er"}; 
  int shift[3] = {8,16,32};
  int BankNumber_Remap,response_index=0;

  i = 0;
  RandVal = random();
  if (BankNumber == 0) 
    BankNumber_Remap = RemapVal ? BankNumber : 7;
  else
    BankNumber_Remap = BankNumber;

  if(op == 'w')
  {
    sprintf(PrintStr,
        "Perform write operation from the ADDR = %X with HSIZE = %s,BURST = %s",
         Address, SizeStr[size], burst);
    C(PrintStr);
    while(trans[i] != 5)
    {
      AddrLSB = Address & 0x0000000F;
      htrans = trans[i];
      if(htrans == 0 | htrans == 1)
            tempdata = 0x87654321;
      else
      {
        if(endian == 0)
          tempdata = Data++;
        else
        {
          if(size == 0)
            tempdata = Data++ << (3 - (AddrLSB % 4))*shift[size];
          else if(size == 1)
          {
            if((AddrLSB % 4) == 2)
              flag = 0;
            else
              flag = 1;
            tempdata = Data++ << (flag* 16);
          }
          else
            tempdata = Data++;
        }
      }
      response_index = CancelSmWaitEn[BankNumber_Remap] & (htrans >> 1);
      HSA(Address, transarr[htrans], burst, response[response_index], sizearr[size]);
      HSW(,tempdata);
      WData = tempdata;
      if(htrans == 2 | htrans == 3 & CancelSmWaitEn[BankNumber_Remap] != 1)
      {
          if(size == 0)
           {
             WordFinder = (Address & 3);
             Addr32Bit = (Address & 0x1FFF) >> 2;
             switch(WordFinder)
             {
               case 0  : PresntData = MemoryData[BankNumber_Remap][Addr32Bit] & (0xFFFFFF00);
                         MaskdWData = endian ? ((WData & 0xFF000000) >> 24) : WData & (0x000000FF);
                         break;
               case 1 :  PresntData = MemoryData[BankNumber_Remap][Addr32Bit] & (0xFFFF00FF); 
                         MaskdWData = endian ? ((WData & 0xFF0000) >> 8) : (WData & 0xFF) << 8;
                         break;
               case 2 :  PresntData = MemoryData[BankNumber_Remap][Addr32Bit] & (0xFF00FFFF); 
                         MaskdWData = endian ? ((WData & 0xFF00) << 8) : (WData & 0xFF) << 16;
                         break;
               case 3 :  PresntData = MemoryData[BankNumber_Remap][Addr32Bit] & (0x00FFFFFF); 
                         MaskdWData = (WData & 0xFF) << 24;
                         break;
               default : break;
             }
             MemoryData[BankNumber_Remap][Addr32Bit] = MaskdWData | PresntData; 
           }
          else if(size == 1)
          {
            WordFinder = (Address & 2) >> 1;
            Addr32Bit = (Address & 0x1FFF) >> 2;
            switch(WordFinder)
            {
              case 0  : PresntData = MemoryData[BankNumber_Remap][Addr32Bit] & (0xFFFF0000);
                        MaskdWData = endian ? (((WData & 0xFF000000) >> 24) | ((WData & 0x00FF0000) >> 8)) : WData & (0x0000FFFF);
                        break;
              case 1 :  PresntData = MemoryData[BankNumber_Remap][Addr32Bit] & (0x0000FFFF); 
                        MaskdWData = endian ? (((WData & 0xFF00) << 8) | ((WData & 0x00FF) << 24)) : (WData & 0xFFFF) << 16;
                        break;
              default : break;
            }
            MemoryData[BankNumber_Remap][Addr32Bit] = MaskdWData | PresntData; 
          }
          else if(size == 2)
          {
            Addr32Bit = (Address & 0x1FFF) >> 2;
            MemoryData[BankNumber_Remap][Addr32Bit] = endian ? (((WData & 0xFF) << 24) | ((WData & 0xFF00) << 8) | ((WData &0xFF0000) >> 8) | ((WData & 0xFF000000) >> 24)) : WData; 
          }
      }
      if(htrans == 2 | htrans == 3) 
      {
         Address = AddrGenLogic(Address, size, burst);
      }
      i++;

      /* Once a while When the next transfer is NSEQ then access registers
       * randomly and/ or Generate MCBUSREQ.
       */
      if(trans[i] == 2)
      {
        if(RandVal%2)
          RandRegAccess();
        else if ((!(RandVal%3) && !ExtBusMux))
          RandMcBusReq(); 
      }
    }
  }
  else if(op == 'r')
  {
    sprintf(PrintStr,
        "Perform read operation from the ADDR = %X with HSIZE = %s, BURST = %s",
         Address, SizeStr[size], burst);
    C(PrintStr);
    if(size == 0)
    {
       while(trans[i] != 5)
       {
          AddrLSB = Address & 0x0000000F;
          Addr2BitLSB = Address & 3;
          htrans = trans[i];
          /* maskpos = Address & 0x0000000F; */
          maskpos = Address%4;
          if(htrans == 0 | htrans == 1) {
            tempdata = 0x87654321;
          } else
          {
            Address1 = (Address & 0x1FFF) >> 2;
            ArrData = MemoryData[BankNumber_Remap][Address1];
            tempdata = ArrData;
            if(endian == 0)
            {
               tempdata = ArrData;
               maskval = mask[0] << (maskpos*8);
            }
            else
            { 
                 switch (Addr2BitLSB) {
                    case 0  : ArrData = (ArrData & 0xFF) << 24;
                              break;
                    case 1 :  ArrData = (ArrData & 0xFF00) << 8;
                              break;
                    case 2  : ArrData = (ArrData & 0xFF0000) >> 8;
                              break;
                    case 3 :  ArrData = (ArrData & 0xFF000000) >> 24;
                              break;
                    default : break; 
                 }
                 tempdata = ArrData;
                 maskval =  mask[0] << (3 - (AddrLSB % 4))*shift[size];
            }
          }
          response_index = CancelSmWaitEn[BankNumber_Remap] & (htrans >> 1);
          HSA(Address,transarr[htrans], burst, response[response_index],sizearr[size]);
          HSR(,tempdata, ,maskval);
          if(htrans == 2 | htrans == 3)
            Address = AddrGenLogic(Address, size, burst);
          i++;
          /* Once a while When the next transfer is NSEQ then access registers
           * randomly and/ or Generate MCBUSREQ.
           */
          if(trans[i] == 2)
          {
            if(RandVal%2)
              RandRegAccess();
            else if ((!(RandVal%3) && !ExtBusMux))
              RandMcBusReq(); 
          }
       }
    }
    else if(size == 1)
    {
       while(trans[i] != 5)
       {
          AddrLSB = Address & 0x0000000F;
          Addr2BitLSB = Address & 3;
          htrans = trans[i];
          /* maskpos = Address & 0x0000000F; */
          maskpos = Address %4;
          if((maskpos % 4) == 2)
           flag = 1;
          else
           flag = 0;
          if(htrans == 0 | htrans == 1)
            tempdata = 0x12345678;
          else
          {
            Address1 = (Address & 0x1FFF) >> 2;
            ArrData = MemoryData[BankNumber_Remap][Address1];

               tempdata = ArrData; 
            if(endian == 0)
            {
               maskval = mask[1] << (8*maskpos);
            }
            else
            {
                 switch (Addr2BitLSB) {
                    case 0  : ArrData = (ArrData & 0xFFFF) << 16;
                              break;
                    case 2  : ArrData = (ArrData & 0xFFFF0000) >> 16;
                              break;
                    default : break; 
                 }
               tempdata = ArrData; 
              if((AddrLSB % 4) == 2)
                flag = 0;
              else
                flag = 1;
              maskval = mask[1] << (flag * 16);
            }
          }
          response_index = CancelSmWaitEn[BankNumber_Remap] & (htrans >> 1);
          HSA(Address,transarr[htrans], burst, response[response_index], sizearr[size]);
          HSR(,tempdata, ,maskval);
          if(htrans == 2 | htrans == 3)
            Address = AddrGenLogic(Address, size, burst);
          i++;

          /* Once a while When the next transfer is NSEQ then access registers
           * randomly and/ or Generate MCBUSREQ.
           */
          if(trans[i] == 2)
          {
            if(RandVal%2)
              RandRegAccess();
            else if ((!(RandVal%3) && !ExtBusMux))
              RandMcBusReq();   
          }
       }
   }
    else if(size == 2)
    {
       while(trans[i] != 5)
       {
          AddrLSB = Address & 0x0000000F;
          Addr2BitLSB = Address & 3;
          Address1 = (Address & 0x1FFF) >> 2;
          htrans = trans[i];
          if(htrans == 0 | htrans == 1) {
            tempdata = 0x12345678;
          } else {
            ArrData = MemoryData[BankNumber_Remap][Address1];
           tempdata = endian ? (((ArrData & 0xFF) << 24) | ((ArrData & 0xFF00) << 8) | ((ArrData &0xFF0000) >> 8) | ((ArrData & 0xFF000000) >> 24)) : ArrData; 
          }
          response_index = CancelSmWaitEn[BankNumber_Remap] & (htrans >> 1);
          HSA(Address,transarr[htrans], burst, response[response_index],sizearr[size]);
          HSR(,tempdata, ,NoMask);
          if(htrans == 2 | htrans == 3)
            Address = AddrGenLogic(Address, size, burst);
          i++;

          /* Once a while When the next transfer is NSEQ then access registers
           * randomly and/ or Generate MCBUSREQ.
           */
          if(trans[i] == 2)
          {
            if(RandVal%2)
              RandRegAccess();
            else if ((!(RandVal%3) && !ExtBusMux))
              RandMcBusReq(); 
          }
       }
    }
  }
}

/* Returns size of the burst depending on the type of burst */
int GetBurstSize(int BurstType)
{
  switch(BurstType)
  {
    case BSINGLE : return 1;
    case BINCR   : return 10;
    case BINCR4  : return 4;
    case BINCR8  : return 8;
    case BINCR16 : return 16;
    case BWRAP4  : return 4;
    case BWRAP8  : return 8;
    case BWRAP16 : return 16;
  }
}

/* Randomly set/ Reset Remap */
void RandGenRemap()
{
  int Val;
  int WST1Val,WST2Val,Delay;

  Val = random();
  Val = Val%2;
  RemapVal = Val;
  if (RemapVal == 1)
    C("Remap Value is 1");
  else
    { 
     C("Remap Value is 0");
    } 
     WST1Val = (SMBWST1Val[0] > SMBWST1Val[7]) ?
                       SMBWST1Val[0] :SMBWST1Val[7];
     WST2Val = (SMBWST2Val[0] > SMBWST2Val[7]) ?
                       SMBWST2Val[0] :SMBWST2Val[7];
     Delay = WST1Val > WST2Val ? WST1Val : WST2Val;
     WaitLoop((Delay + 0x10));
  HSA(SMCTrREMAP, NSEQ, SINGLE, OK, WRD);
  HSW( , Val);
}

/* Randomise Endianness */
void RandEndian()
{
  int Val;

  Val = random();
  Val = Val%2;
  
  WaitLoop(5);
  
  if(Val == 1)
  {
    C("Configuring the System to BIG ENDIAN Mode");
    HSA(SMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
    HSW( , Val);
    HSEN(DISABLE);
  }
  else
  {
    C("Configuring the System to LITTLE ENDIAN Mode");
    HSEN(LITTLE);
    HSA(SMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
    HSW( , Val);
  }
  BigEndian = Val;
}

void MakeROM(int BankNumber)
{
  int Val, SmbCrAddr, SmcTrMemTAddr;

/* Find where to change the value */
  switch(BankNumber)
  {
    case 0:  SmbCrAddr = SMBCR0; SmcTrMemTAddr = SMCTrMEMT_0; break;
    case 1:  SmbCrAddr = SMBCR1; SmcTrMemTAddr = SMCTrMEMT_1; break;
    case 2:  SmbCrAddr = SMBCR2; SmcTrMemTAddr = SMCTrMEMT_2; break;
    case 3:  SmbCrAddr = SMBCR3; SmcTrMemTAddr = SMCTrMEMT_3; break;
    case 4:  SmbCrAddr = SMBCR4; SmcTrMemTAddr = SMCTrMEMT_4; break;
    case 5:  SmbCrAddr = SMBCR5; SmcTrMemTAddr = SMCTrMEMT_5; break;
    case 6:  SmbCrAddr = SMBCR6; SmcTrMemTAddr = SMCTrMEMT_6; break;
    case 7:  SmbCrAddr = SMBCR7; SmcTrMemTAddr = SMCTrMEMT_7; break;
  }

/* Read the current value of Control register - Trick */
  Val = TriReg[BankNumber].TriMemT;
/* Set the BROM bit */
  Val = Val | (0x1 << ROM);
/* Write back the value */
  TriReg[BankNumber].TriMemT = Val;
  HSA(SmcTrMemTAddr, NSEQ, INCR, OK, WRD)
  HSW( ,Val);

/* Read the current value of Control register - UUT */
  Val = RtlReg[BankNumber].SmbCr;
/* Set the BM bit */
  Val = Val | (0x1 << WP);
/* Write back the value */
  RtlReg[BankNumber].SmbCr = Val;
  HSA(SmbCrAddr, NSEQ, SINGLE, OK, WRD)
  HSW( ,Val);
}

void MakeBROM(int BankNumber)
{
  int Val, SmbCrAddr, SmcTrMemTAddr;

/* Find where to change the value */
  switch(BankNumber)
  {
    case 0:  SmbCrAddr = SMBCR0; SmcTrMemTAddr = SMCTrMEMT_0; break;
    case 1:  SmbCrAddr = SMBCR1; SmcTrMemTAddr = SMCTrMEMT_1; break;
    case 2:  SmbCrAddr = SMBCR2; SmcTrMemTAddr = SMCTrMEMT_2; break;
    case 3:  SmbCrAddr = SMBCR3; SmcTrMemTAddr = SMCTrMEMT_3; break;
    case 4:  SmbCrAddr = SMBCR4; SmcTrMemTAddr = SMCTrMEMT_4; break;
    case 5:  SmbCrAddr = SMBCR5; SmcTrMemTAddr = SMCTrMEMT_5; break;
    case 6:  SmbCrAddr = SMBCR6; SmcTrMemTAddr = SMCTrMEMT_6; break;
    case 7:  SmbCrAddr = SMBCR7; SmcTrMemTAddr = SMCTrMEMT_7; break;
  }

/* Read the current value of Control register - Trick */
  Val = TriReg[BankNumber].TriMemT;
/* Set the BROM bit */
  Val = Val | (0x1 << BROM);
/* Write back the value */
  TriReg[BankNumber].TriMemT = Val;
  HSA(SmcTrMemTAddr, NSEQ, INCR, OK, WRD)
  HSW( ,Val);

/* Read the current value of Control register - UUT */
  Val = RtlReg[BankNumber].SmbCr;
/* Set the BM bit */
  Val = Val | (0x1 << BM);
/* Write back the value */
  RtlReg[BankNumber].SmbCr = Val;
  HSA(SmbCrAddr, NSEQ, SINGLE, OK, WRD)
  HSW( ,Val);

}

void MakeSRAM(int BankNumber)
{
  int Val, SmbCrAddr, SmcTrMemTAddr;

/* Find where to change the value */
  switch(BankNumber)
  {
    case 0:  SmbCrAddr = SMBCR0; SmcTrMemTAddr = SMCTrMEMT_0; break;
    case 1:  SmbCrAddr = SMBCR1; SmcTrMemTAddr = SMCTrMEMT_1; break;
    case 2:  SmbCrAddr = SMBCR2; SmcTrMemTAddr = SMCTrMEMT_2; break;
    case 3:  SmbCrAddr = SMBCR3; SmcTrMemTAddr = SMCTrMEMT_3; break;
    case 4:  SmbCrAddr = SMBCR4; SmcTrMemTAddr = SMCTrMEMT_4; break;
    case 5:  SmbCrAddr = SMBCR5; SmcTrMemTAddr = SMCTrMEMT_5; break;
    case 6:  SmbCrAddr = SMBCR6; SmcTrMemTAddr = SMCTrMEMT_6; break;
    case 7:  SmbCrAddr = SMBCR7; SmcTrMemTAddr = SMCTrMEMT_7; break;
  }

/* Read the current value of Control register - UUT */
  Val = RtlReg[BankNumber].SmbCr;
/* Reset the BM bit; Reset the WP bit */
  Val = Val & RTLNOBROMROM;
/* Write back the value */
  RtlReg[BankNumber].SmbCr = Val;
  HSA(SmbCrAddr, NSEQ, SINGLE, OK, WRD)
  HSW( ,Val);

/* Read the current value of Control register - Trick */
  Val = TriReg[BankNumber].TriMemT;
/* Reset the BROM bit; Reset the ROM bit */
  Val = Val & TRINOBROMROM;
/* Write back the value */
  TriReg[BankNumber].TriMemT = Val;
  HSA(SmcTrMemTAddr, NSEQ, INCR, OK, WRD)
  HSW( ,Val);
}

