/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--
--  Version and Release Control Information:
--
--  File Name              : SyBurstWaitTests.c.rca
--  File Revision          : 1.8
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform tests on external wait functionality of the
--           SSMC.
--
-- --=========================================================================*/

/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                                      Located in          ***/
/*** ---------------------------------------------------------------------- ***/
/*** ConfigureMemory                                    SsmcCommon.c        ***/
/*** ConfigureUUT                                       SsmcCommon.c        ***/
/*** SingleWriteRead                                    SsmcCommon.c        ***/
/*** BurstWriteRead                                     SsmcCommon.c        ***/
/******************************************************************************/


/******************************************************************************/
/******************************** SMWAIT Tests ********************************/
/******************************************************************************/

void SyBurstWaitTests()
{
  /*
     Summary: SyyBurstWaitTests
     ==========================
     This function performs the following:

     o  nSMBURSTWAIT signal is asserted and de-asserted in various possible ways
     o  Repeats tests for Burst read and write accesses 
  */

  int n, Hsize, Msize ;
  char* ExpResp = OK;
  int32 SMBCRAddr, SMBWSTRD, SMBWSTWR, SMBWSTBRD, ExtMuxData, SMBLSPOLData;
  int32 SSMCTrCS2WTAddr, SMBSRAddr, MemAddr, TestWrite = 0x00000000;
  int32 BCRData, CS2WTRData, BSRData, WTCNCLData, Mask, MemAddr2;
  int32 TestData = 0x00000000 ;
  int32 AddrMask[3] = {0x3, 0x2, 0x0};
  char report[100];
  char PrtString[75];
  char* BurstString[8] = {"SINGLE", "INCR", "INCR4", "INCR8",
                          "INCR16", "WRAP4", "WRAP8", "WRAP16"};
  char* SizeString[3] = {"BYTE", "HALFWORD", "WORD"};

  struct parameters {
    int   BANKNO;
    int   HSIZE;
    int   MSIZE;
    int   BURSTLENRD;
    int   BURSTLENWR;
    int   HBURST;
    int   BWTMASK;
    int   BEATNO;
    int   BURSTWT;
    int   RBLE;
  };


  struct caselist {
    char *CaseNumber;
    struct parameters *TestParams;
  };


  struct parameters *SyyBurstWaitParams ;

  /* The parameters corresponds to the list of configurations defined for
     Test number "SyyBurstWaitTests" in the block verification document.
     The BANKNO value as '9' indicates the end of the
     configurations, as in the last element of the parameters' list. */

  struct parameters B0Cases[90] = {
  0, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL0,
  0, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL0,
  0, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL0,
  0, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL0,

  0, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL0,
  0, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL0,
  0, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL0,
  0, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL0,
  0, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL0,
  0, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL0,
  0, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL0,
  0, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL0,
  0, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL0,
  0, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL0,
  0, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL0,

  0, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL0,
  0, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL0,
  0, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL0,
  0, 8, MW8, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL0,
  0, 8, MW8, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL0,
  0, 8, MW8, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL0,
  0, 8, MW8, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL0,


  0, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL1,
  0, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL1,
  0, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL1,
  0, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL1,

  0, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL1,
  0, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL1,
  0, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL1,
  0, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL1,
  0, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL1,
  0, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL1,
  0, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL1,
  0, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL1,
  0, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL1,
  0, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL1,
  0, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL1,

  0, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL1,
  0, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL1,
  0, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL1,
  0, 16, MW16, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL1,
  0, 16, MW16, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL1,
  0, 16, MW16, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL1,
  0, 16, MW16, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1,


  0, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL1,
  0, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL1,
  0, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL1,
  0, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL1,

  0, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL1,
  0, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL1,
  0, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL1,
  0, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL1,
  0, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL1,
  0, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL1,
  0, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL1,
  0, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL1,
  0, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL1,
  0, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL1,
  0, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL1,

  0, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL1,
  0, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL1,
  0, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL1,
  0, 32, MW32, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL1,
  0, 32, MW32, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL1,
  0, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL1,
  0, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1,

  9, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_EN, Beat5, SSMCTrBurstWT2, RBL0};


  struct parameters B1Cases[70] = {
  1, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL0,
  1, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL0,
  1, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL0,
  1, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL0,

  1, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL0,
  1, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL0,
  1, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL0,
  1, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL0,
  1, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL0,
  1, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL0,
  1, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL0,
  1, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL0,
  1, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL0,
  1, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL0,
  1, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL0,

  1, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL0,
  1, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL0,
  1, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL0,
  1, 8, MW8, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL0,
  1, 8, MW8, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL0,
  1, 8, MW8, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL0,
  1, 8, MW8, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL0,


  1, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL1,
  1, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL1,
  1, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL1,
  1, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL1,

  1, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL1,
  1, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL1,
  1, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL1,
  1, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL1,
  1, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL1,
  1, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL1,
  1, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL1,
  1, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL1,
  1, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL1,
  1, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL1,
  1, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL1,

  1, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL1,
  1, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL1,
  1, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL1,
  1, 16, MW16, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL1,
  1, 16, MW16, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL1,
  1, 16, MW16, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL1,
  1, 16, MW16, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1,


  1, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL1,
  1, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL1,
  1, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL1,
  1, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL1,

  1, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL1,
  1, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL1,
  1, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL1,
  1, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL1,
  1, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL1,
  1, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL1,
  1, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL1,
  1, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL1,
  1, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL1,
  1, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL1,
  1, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL1,

  1, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL1,
  1, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL1,
  1, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL1,
  1, 32, MW32, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL1,
  1, 32, MW32, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL1,
  1, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL1,
  1, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1,

  9, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1};
                                                    

  struct parameters B2Cases[70] = {
  2, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL0,
  2, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL0,
  2, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL0,
  2, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL0,

  2, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL0,
  2, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL0,
  2, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL0,
  2, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL0,
  2, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL0,
  2, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL0,
  2, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL0,
  2, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL0,
  2, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL0,
  2, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL0,
  2, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL0,

  2, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL0,
  2, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL0,
  2, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL0,
  2, 8, MW8, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL0,
  2, 8, MW8, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL0,
  2, 8, MW8, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL0,
  2, 8, MW8, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL0,


  2, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL1,
  2, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL1,
  2, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL1,
  2, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL1,

  2, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL1,
  2, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL1,
  2, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL1,
  2, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL1,
  2, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL1,
  2, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL1,
  2, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL1,
  2, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL1,
  2, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL1,
  2, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL1,
  2, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL1,

  2, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL1,
  2, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL1,
  2, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL1,
  2, 16, MW16, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL1,
  2, 16, MW16, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL1,
  2, 16, MW16, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL1,
  2, 16, MW16, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1,


  2, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL1,
  2, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL1,
  2, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL1,
  2, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL1,

  2, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL1,
  2, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL1,
  2, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL1,
  2, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL1,
  2, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL1,
  2, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL1,
  2, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL1,
  2, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL1,
  2, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL1,
  2, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL1,
  2, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL1,

  2, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL1,
  2, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL1,
  2, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL1,
  2, 32, MW32, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL1,
  2, 32, MW32, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL1,
  2, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL1,
  2, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1,

  9, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1};


  struct parameters B3Cases[70] = {
  3, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL0,
  3, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL0,
  3, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL0,
  3, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL0,

  3, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL0,
  3, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL0,
  3, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL0,
  3, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL0,
  3, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL0,
  3, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL0,
  3, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL0,
  3, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL0,
  3, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL0,
  3, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL0,
  3, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL0,

  3, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL0,
  3, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL0,
  3, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL0,
  3, 8, MW8, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL0,
  3, 8, MW8, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL0,
  3, 8, MW8, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL0,
  3, 8, MW8, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL0,


  3, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL1,
  3, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL1,
  3, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL1,
  3, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL1,

  3, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL1,
  3, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL1,
  3, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL1,
  3, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL1,
  3, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL1,
  3, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL1,
  3, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL1,
  3, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL1,
  3, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL1,
  3, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL1,
  3, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL1,

  3, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL1,
  3, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL1,
  3, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL1,
  3, 16, MW16, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL1,
  3, 16, MW16, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL1,
  3, 16, MW16, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL1,
  3, 16, MW16, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1,


  3, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL1,
  3, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL1,
  3, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL1,
  3, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL1,

  3, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL1,
  3, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL1,
  3, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL1,
  3, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL1,
  3, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL1,
  3, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL1,
  3, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL1,
  3, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL1,
  3, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL1,
  3, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL1,
  3, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL1,

  3, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL1,
  3, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL1,
  3, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL1,
  3, 32, MW32, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL1,
  3, 32, MW32, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL1,
  3, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL1,
  3, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1,

  9, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1};


  struct parameters B4Cases[70] = {
  4, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL0,
  4, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL0,
  4, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL0,
  4, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL0,

  4, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL0,
  4, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL0,
  4, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL0,
  4, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL0,
  4, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL0,
  4, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL0,
  4, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL0,
  4, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL0,
  4, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL0,
  4, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL0,
  4, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL0,

  4, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL0,
  4, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL0,
  4, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL0,
  4, 8, MW8, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL0,
  4, 8, MW8, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL0,
  4, 8, MW8, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL0,
  4, 8, MW8, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL0,


  4, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL1,
  4, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL1,
  4, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL1,
  4, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL1,

  4, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL1,
  4, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL1,
  4, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL1,
  4, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL1,
  4, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL1,
  4, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL1,
  4, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL1,
  4, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL1,
  4, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL1,
  4, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL1,
  4, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL1,

  4, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL1,
  4, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL1,
  4, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL1,
  4, 16, MW16, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL1,
  4, 16, MW16, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL1,
  4, 16, MW16, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL1,
  4, 16, MW16, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1,


  4, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL1,
  4, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL1,
  4, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL1,
  4, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL1,

  4, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL1,
  4, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL1,
  4, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL1,
  4, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL1,
  4, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL1,
  4, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL1,
  4, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL1,
  4, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL1,
  4, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL1,
  4, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL1,
  4, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL1,

  4, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL1,
  4, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL1,
  4, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL1,
  4, 32, MW32, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL1,
  4, 32, MW32, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL1,
  4, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL1,
  4, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1,

  9, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1};
      

  struct parameters B5Cases[70] = {
  5, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL0,
  5, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL0,
  5, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL0,
  5, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL0,

  5, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL0,
  5, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL0,
  5, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL0,
  5, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL0,
  5, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL0,
  5, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL0,
  5, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL0,
  5, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL0,
  5, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL0,
  5, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL0,
  5, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL0,

  5, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL0,
  5, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL0,
  5, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL0,
  5, 8, MW8, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL0,
  5, 8, MW8, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL0,
  5, 8, MW8, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL0,
  5, 8, MW8, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL0,


  5, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL1,
  5, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL1,
  5, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL1,
  5, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL1,

  5, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL1,
  5, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL1,
  5, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL1,
  5, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL1,
  5, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL1,
  5, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL1,
  5, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL1,
  5, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL1,
  5, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL1,
  5, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL1,
  5, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL1,

  5, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL1,
  5, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL1,
  5, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL1,
  5, 16, MW16, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL1,
  5, 16, MW16, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL1,
  5, 16, MW16, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL1,
  5, 16, MW16, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1,


  5, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL1,
  5, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL1,
  5, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL1,
  5, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL1,

  5, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL1,
  5, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL1,
  5, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL1,
  5, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL1,
  5, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL1,
  5, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL1,
  5, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL1,
  5, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL1,
  5, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL1,
  5, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL1,
  5, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL1,

  5, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL1,
  5, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL1,
  5, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL1,
  5, 32, MW32, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL1,
  5, 32, MW32, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL1,
  5, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL1,
  5, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1,

  9, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1};


  struct parameters B6Cases[70] = {
  6, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL0,
  6, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL0,
  6, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL0,
  6, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL0,

  6, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL0,
  6, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL0,
  6, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL0,
  6, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL0,
  6, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL0,
  6, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL0,
  6, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL0,
  6, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL0,
  6, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL0,
  6, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL0,
  6, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL0,

  6, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL0,
  6, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL0,
  6, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL0,
  6, 8, MW8, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL0,
  6, 8, MW8, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL0,
  6, 8, MW8, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL0,
  6, 8, MW8, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL0,


  6, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL1,
  6, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL1,
  6, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL1,
  6, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL1,

  6, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL1,
  6, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL1,
  6, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL1,
  6, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL1,
  6, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL1,
  6, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL1,
  6, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL1,
  6, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL1,
  6, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL1,
  6, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL1,
  6, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL1,

  6, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL1,
  6, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL1,
  6, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL1,
  6, 16, MW16, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL1,
  6, 16, MW16, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL1,
  6, 16, MW16, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL1,
  6, 16, MW16, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1,


  6, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL1,
  6, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL1,
  6, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL1,
  6, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL1,

  6, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL1,
  6, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL1,
  6, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL1,
  6, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL1,
  6, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL1,
  6, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL1,
  6, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL1,
  6, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL1,
  6, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL1,
  6, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL1,
  6, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL1,

  6, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL1,
  6, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL1,
  6, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL1,
  6, 32, MW32, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL1,
  6, 32, MW32, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL1,
  6, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL1,
  6, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1,

  9, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1};


  struct parameters B7Cases[70] = {
  7, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL0,
  7, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL0,
  7, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL0,
  7, 8, MW8, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL0,

  7, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL0,
  7, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL0,
  7, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL0,
  7, 8, MW8, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL0,
  7, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL0,
  7, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL0,
  7, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL0,
  7, 8, MW8, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL0,
  7, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL0,
  7, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL0,
  7, 8, MW8, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL0,

  7, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL0,
  7, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL0,
  7, 8, MW8, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL0,
  7, 8, MW8, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL0,
  7, 8, MW8, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL0,
  7, 8, MW8, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL0,
  7, 8, MW8, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL0,


  7, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL1,
  7, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL1,
  7, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL1,
  7, 16, MW16, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL1,

  7, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL1,
  7, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL1,
  7, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL1,
  7, 16, MW16, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL1,
  7, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL1,
  7, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL1,
  7, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL1,
  7, 16, MW16, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL1,
  7, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL1,
  7, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL1,
  7, 16, MW16, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL1,

  7, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL1,
  7, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL1,
  7, 16, MW16, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL1,
  7, 16, MW16, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL1,
  7, 16, MW16, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL1,
  7, 16, MW16, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL1,
  7, 16, MW16, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1,


  7, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat0, SSMCTrBurstWT15, RBL1,
  7, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat1, SSMCTrBurstWT15, RBL1,
  7, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat2, SSMCTrBurstWT14, RBL1,
  7, 32, MW32, BLRD4, BLWR4, INC4, BWtMask_DI, Beat3, SSMCTrBurstWT13, RBL1,

  7, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT12, RBL1,
  7, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT12, RBL1,
  7, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT11, RBL1,
  7, 32, MW32, BLRD8, BLWR8,  INC4, BWtMask_DI, Beat3, SSMCTrBurstWT10, RBL1,
  7, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat4,  SSMCTrBurstWT9, RBL1,
  7, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat5,  SSMCTrBurstWT8, RBL1,
  7, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat6,  SSMCTrBurstWT7, RBL1,
  7, 32, MW32, BLRD8, BLWR8,  INC8, BWtMask_DI, Beat7,  SSMCTrBurstWT6, RBL1,
  7, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat3,  SSMCTrBurstWT5, RBL1,
  7, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat5,  SSMCTrBurstWT4, RBL1,
  7, 32, MW32, BLRD8, BLWR8, INC16, BWtMask_DI, Beat7,  SSMCTrBurstWT3, RBL1,

  7, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat0, SSMCTrBurstWT2, RBL1,
  7, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat1, SSMCTrBurstWT2, RBL1,
  7, 32, MW32, BLRDC, BLWRC,  INC4, BWtMask_DI, Beat2, SSMCTrBurstWT1, RBL1,
  7, 32, MW32, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat3, SSMCTrBurstWT1, RBL1,
  7, 32, MW32, BLRDC, BLWRC,  INC8, BWtMask_DI, Beat4, SSMCTrBurstWT2, RBL1,
  7, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat5, SSMCTrBurstWT3, RBL1,
  7, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1,

  9, 32, MW32, BLRDC, BLWRC, INC16, BWtMask_DI, Beat6, SSMCTrBurstWT4, RBL1};




  /* The test cases and their corresponding parameters are listed here.
     The user can modify the 'caselist' to run the specific test cases.
     e.g., if the user wants to test only the first test case, the last
     element "ENDOFTEST" of the array may be put next to the SyyBurstWait_B0
     test */
  struct caselist SyyBurstWaitCaseList[11] = {
       "SyBurstWait_B0",    B0Cases,
       "SyBurstWait_B1",    B1Cases,
       "SyBurstWait_B2",    B2Cases,
       "SyBurstWait_B3",    B3Cases,
       "SyBurstWait_B4",    B4Cases,
       "SyBurstWait_B5",    B5Cases,
       "SyBurstWait_B6",    B6Cases,
       "SyBurstWait_B7",    B7Cases,
       "ENDOFTEST",          B0Cases,
       "ENDOFTEST",          B0Cases
       };


  struct caselist *TestCases = SyyBurstWaitCaseList;
 
 
  /*
      Programming SSMCCR and SSMCTrCR registers. The constants CLKRATIO and
      CLKSTATUS defined in the Ssmc.h set the required  MemClkRatio and
      SMClockEn field bits.
  */
  SSMCCRDATA = CLKRATIO | CLKSTATUS;
  ConfigureCLKRatio(SSMCCRDATA);

  /*
      Programming the SSMCTrBurstWT register to turn the mask ON/OFF and to
      set the BeatNo and BurstWT counts. The constants BWtMask_ON/OFF,
      Beat0 to 15 and SSMCTrBurstWT0 to 15 are defined in Ssmc.h.
  */
  SSMCTrBurstWTData = BWtMask_ON | Beat15 | SSMCTrBurstWT15;
  ConfigureBurstWT(SSMCTrBurstWTData);

  /*
      Programming the SSMCTrWTCNCL register. The constant SMWTCNCLDI/EN
      disables or Enables the SMCANCELWait signal. The constant 
      SMWAITIGNORE_0/1 enables or disables the SMWAITIGNORE respectively and 
      the constants WTCNCL0 to 63 are used to load the CANCEL WAIT count.
  */
  WTCNCLData = SMWTCNCLDI | SMWAITIGNORE_1 | WTCNCL10 ;
  HSA(SSMCTrWTCNCL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,WTCNCLData);

  /** Configuring the system to LITTLE endian mode: Setting ENDIANNESS = 0 **/
  ENDIANNESS = 0;
  HSA(SSMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,ENDIANNESS);
  HSEN(LITTLE);

  /*
      Programming the SSMCTrExtMuxWT register.The constant ExtMuxDI/EN disables
      or enables the  External Mux. The constants ExtMuxAss0 to 15 and
      ExtMuxDAss0 to 15 define the Assertion and Deassertion counts.
  */
  ExtMuxData = ExtMuxAss5 | ExtMuxDAss5 | ExtMuxDI;
  HSA(SSMCTrExtMux, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,ExtMuxData);

  /** Programming the SSMCTrSMBLSPOL register **/
  SMBLSPOLData = SMBLSPOL_0;
  HSA(SSMCTrSMBLSPOL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( ,SMBLSPOLData);
 
  /** CONFIGURING THE SSMC & MEMORY BANKS WITH SMWAIT DISABLED **/ 

  /** Set Bank 0 Memory Type as Synchronous SRAM (32 bits width) **/
  /** ExtWait Disabled **/
  SSMCTrMEMBData[0] = 0x00000000;

  SMBCRData[0] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN | 
		 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI 	  | WRAPRD_DI        | 
		 CRWAITEN_DI      | CRWAITPOL_1      |
                 BIWRITE_DI       | BIREAD_DI        |
		 CRMW32		  | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[0] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR1 | TRWT2DEWT2;

  ConfigureUUT(BANK0, WSTIDCY2, WSTRD0, WSTWR2, WSTOEN0, WSTWEN0, SMBCRData[0],
               SSMCTrCS2WTRData[0], WSTBRD0); 

  ConfigureMemory(BANK0, SSMCTrMEMBData[0]);

  /** Set Bank 1 Memory Type as SynchronousSRAM (32 bits width) **/
  /** ExtWait Disabled **/
  SSMCTrMEMBData[1] = 0x00000000;

  SMBCRData[1] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN | 
		 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI          | WRAPRD_DI        | 
		 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
		 CRMW32           | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[1] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR1 | TRWT2DEWT1;


  ConfigureUUT(BANK1, WSTIDCY9, WSTRD1, WSTWR1, WSTOEN0, WSTWEN0, SMBCRData[1],
               SSMCTrCS2WTRData[1], WSTBRD1);

  ConfigureMemory(BANK1, SSMCTrMEMBData[1]);

  /** Set Bank 2 Memory Type as Synchronous SRAM (32 bits width) **/
  /** ExtWait Disabled **/
  SSMCTrMEMBData[2] = 0x00000000;

  SMBCRData[2] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN | 
		 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI 	  | WRAPRD_DI        | 
		 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
		 CRMW32	 	  | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[2] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK2, WSTIDCY2, WSTRD2, WSTWR2, WSTOEN0, WSTWEN0, SMBCRData[2],
               SSMCTrCS2WTRData[2], WSTBRD2);

  ConfigureMemory(BANK2, SSMCTrMEMBData[2]);

  /** Set Bank 3 Memory Type as Synchronous SRAM (32 bits width) **/
  /** ExtWait Enabled  **/
  SSMCTrMEMBData[3] = 0x00000000;

  SMBCRData[3] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN | 
		 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI 	  | WRAPRD_DI        | 
		 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
		 CRMW32		  | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[3] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK3, WSTIDCY2, WSTRD3, WSTWR3, WSTOEN0, WSTWEN0, SMBCRData[3],
               SSMCTrCS2WTRData[3], WSTBRD3);

  ConfigureMemory(BANK3, SSMCTrMEMBData[3]);

  /** Set Bank 4 Memory Type as Synchronous SRAM (16 bits width) **/
  /** ExtWait Enabled **/
  /** Boundary Case disabled **/
  SSMCTrMEMBData[4] = 0x00000000;

  SMBCRData[4] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN | 
		 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI 	  | WRAPRD_DI        | 
		 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
		 CRMW16		  | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[4] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK4, WSTIDCY2, WSTRD2, WSTWR2, WSTOEN0, WSTWEN0, SMBCRData[4],
               SSMCTrCS2WTRData[4], WSTBRD2);

  ConfigureMemory(BANK4, SSMCTrMEMBData[4]);

  /** Set Bank 5 Memory Type as Synchronous SRAM (16 bits width) **/
  /** ExtWait Enabled **/
  SSMCTrMEMBData[5] = 0x00000000;

  SMBCRData[5] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN | 
		 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI 	  | WRAPRD_DI        | 
		 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
		 CRMW16		  | RBLE_1           | SMBLSPOL_0;

  SSMCTrCS2WTRData[5] = TRWAITEN_DI | TRWAITPOL_1 | TRCS2WTR2 | TRWT2DEWT2;

  ConfigureUUT(BANK5, WSTIDCY2, WSTRD2, WSTWR2, WSTOEN0, WSTWEN0, SMBCRData[5],
               SSMCTrCS2WTRData[5], WSTBRD2);

  ConfigureMemory(BANK5, SSMCTrMEMBData[5]);

  /** Set Bank 6 Memory Type as Synchronous SRAM (8 bits width) **/
  /** ExtWait Enabled **/
  SSMCTrMEMBData[6] = 0x00000000;

  SMBCRData[6] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN | 
		 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI 	  | WRAPRD_DI        | 
		 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
		 CRMW8		  | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[6] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR1 | TRWT2DEWT1;

  ConfigureUUT(BANK6, WSTIDCY2, WSTRD2, WSTWR2, WSTOEN0, WSTWEN0, SMBCRData[6],
               SSMCTrCS2WTRData[6], WSTBRD2);

  ConfigureMemory(BANK6, SSMCTrMEMBData[6]);


  /** Set Bank 7 Memory Type as Synchronous SRAM (8 bits width) **/
  /** ExtWait Enabled, WaitPol = 0 **/
  SSMCTrMEMBData[7] = 0x00000000;

  SMBCRData[7] = CRADDRVALIDWR_EN | CRADDRVALIDRD_EN | 
		 CRSYNCENWR_SY    | CRSYNCENRD_SY    |
                 CRBURSTLENWR4    | CRBURSTLENRD4    |
                 CRBMWRITE_EN     | CRBMREAD_EN      |
                 CRWP_DI 	  | WRAPRD_DI        | 
		 CRWAITEN_DI      | CRWAITPOL_0      |
                 BIWRITE_DI       | BIREAD_DI        |
		 CRMW8		  | RBLE_0           | SMBLSPOL_0;

  SSMCTrCS2WTRData[7] = TRWAITEN_DI | TRWAITPOL_0 | TRCS2WTR1 | TRWT2DEWT1;

  ConfigureUUT(BANK7, WSTIDCY2, WSTRD2, WSTWR2, WSTOEN0, WSTWEN0, SMBCRData[7],
               SSMCTrCS2WTRData[7], WSTBRD2);

  ConfigureMemory(BANK7, SSMCTrMEMBData[7]);


  C("EXECUTNING THE CASELIST OF THE DIFFERENT BANKS"); 
 
   sprintf(report,"EXECUTNING THE CASES IN THE TABLE OF THE INDIVIDUAL BANKS");
   msg_info(report);

  while (TestCases->CaseNumber != "ENDOFTEST")
  {

   sprintf(Message,"TEST NO : %s", TestCases->CaseNumber);
   C(Message);

   SyyBurstWaitParams = TestCases->TestParams;

   while (SyyBurstWaitParams -> BANKNO != 9)
   {
    /* 
     Set the offset for the memory to zero.The offset can be given a new value
     by changing the value of the variable SSMCTrMEMBData 
    */

   /** CONFIGURING THE SSMC & TRICKMEMS WITH BURSTWAIT ENABLED **/

    SSMCTrMEMBData[SyyBurstWaitParams -> BANKNO ] = 0x00000000;
  
  /**  Programming the SSMCTrBurstWT register **/
  SSMCTrBurstWTData = SyyBurstWaitParams -> BWTMASK | 
                      SyyBurstWaitParams -> BEATNO  | 
                      SyyBurstWaitParams -> BURSTWT;
  ConfigureBurstWT(SSMCTrBurstWTData);

    /** CALCULATING THE VALUE FOR THE BCR REGISTER **/  
    /** The control register fields are configured as per the requirement **/
    BCRData     =   CRADDRVALIDWR_EN |
                    CRADDRVALIDRD_EN |
                    CRSYNCENWR_SY   |
                    CRSYNCENRD_SY   |
                    SyyBurstWaitParams -> BURSTLENWR    |
                    SyyBurstWaitParams -> BURSTLENRD    |
                    CRBMWRITE_EN     |
                    CRBMREAD_EN      |
                    SyyBurstWaitParams -> MSIZE |
                    CRWP_DI          |
                    WRAPRD_DI        |
                    CRWAITEN_DI      |
                    CRWAITPOL_0      |
                    BIWRITE_DI       | 
                    BIREAD_DI        |
		    SMBLSPOL_0       |
                    SyyBurstWaitParams -> RBLE;            


    switch (SyyBurstWaitParams -> BANKNO)
    {
      case 0 : SMBCRAddr = SMBCR0;
               MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11);
               break;
      case 1 : SMBCRAddr = SMBCR1;
               MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11);
               break;
      case 2 : SMBCRAddr = SMBCR2;
               MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11);
               break;
      case 3 : SMBCRAddr = SMBCR3;
               MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11);
               break;
      case 4 : SMBCRAddr = SMBCR4;
               MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11);
               break;
      case 5 : SMBCRAddr = SMBCR5;
               MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11);
               break;
      case 6 : SMBCRAddr = SMBCR6;
               MemAddr = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11);
               break;
      case 7 : SMBCRAddr = SMBCR7;
               MemAddr = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11);
               break;

      default : break;
    }

    /** RECONFIGURING THE SMBCR REGISTER **/
    HSA(SMBCRAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
    HSW( ,BCRData);

    /** INITIALLY FILL THE MEMORY BANK WITH 0s **/
    /** FILLING THE MEMORY INITIALLY  WITH ZEROS **/
    AHBFillMem(SyyBurstWaitParams -> BANKNO, 0, 4, 0x00000000);

  /*
      Assign values to Hsize  depending on the HSIZE values in testcases
      Hsize = 0,1,2 when HSIZE = 8,16.32 respectively
  */
  switch(SyyBurstWaitParams -> HSIZE)
  {
    case  8 : Hsize = 0;
              break;

    case 16 : Hsize = 1;
              break;

    case 32 : Hsize = 2;
              break;
  }

  /*
    Assign values to Msize  depending on the MSIZE values in testcases
    Msize = 0,1,2 when MSIZE = 8,16.32 respectively
  */
  switch(SyyBurstWaitParams -> MSIZE)
  {
    case MW8 : Msize = 0;
               break;

    case MW16 : Msize = 1;
                break;

    case MW32 : Msize = 2;
                break;
  }

       sprintf(PrtString, "BURST WR/RDs: MSIZE = %s, HSIZE = %s, HBURST = %s", 
               SizeString[Msize], SizeString[Hsize],
               BurstString[SyyBurstWaitParams -> HBURST]);
      msg_info(PrtString);
      TestData = TestWrite;
      MemWriteRead(SyyBurstWaitParams -> BANKNO, 
                   SyyBurstWaitParams -> HBURST,
                   0x7F8 & AddrMask[Hsize],
                   Hsize,
                   Msize,
                   TestData);

     
      SyyBurstWaitParams++;
   }
   TestCases++;
  }

}



/************************************ End *************************************/
