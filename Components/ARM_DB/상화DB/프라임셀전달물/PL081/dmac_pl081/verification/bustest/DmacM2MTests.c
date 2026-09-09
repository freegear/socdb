/* --=========================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000-2001 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- -----------------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : DmacM2MTests.c.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Memory-to-Memory Dma transfer test code.
-- --=========================================================================*/
 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** AddrGen                                    DmacCommon.c                ***/
/*** M2MDma                                     DmacCommon.c                ***/
/*** ProgramResponse                            DmacCommon.c                ***/
/*** Write                                      DmacCommon.c                ***/
/******************************************************************************/
 
void M2MTests()
{
  /*
    Summary: Memory-Memory Dma Tests
    ================================
      o Memory-to-Memory(M2M) Dma transfers are tested using this function.
      o The M2M dma transfer test cases are as defined in the block verification
        document. All the test cases written here are used to test the given
        channel, defined by the "CHANNEL" in Dmac.h file.
        The master port for the source and destination of the dma transfer as
        well as the incrementing/non-incrementing nature of the address of the
        source/destination dma transfer are defined by SMASTER, DMASTER, SINCR
        and DINCR respectively. Other parameters are as defined in the block
        verification document.
      o If the user wants to add any new configuration of the channel to be
        tested, it may be added in the list of parameters and run the test case.
  */

  char report[100];

  struct parameters {
    int   SrcMaster;
    int   DestMaster;
    int   SrcWidth;
    int   DestWidth;
    char  *SrcInc;
    char  *DestInc;
    int   SrcBurst;
    int   DestBurst;
    int   TxSize;
    int32 LLIAddress;
    int   LLIMaster;
    int   Protection;
    int   Lock;
  };
 
  struct caselist {
    char *CaseNumber;
    struct parameters *TestParams;
  };

  char *DefaultResponse;
  int i, j, k, OnethirdData, MaxValue, TransferSize;
  int32 SrcAddrMask, DestAddrMask;
  int32 MasterConfig, RegWrAddr;
  int32 WaitCycles, Response, SeedData, RSCount;
  int32 VlsbCount, ControlBase, SourceTxSize, DestinationTxSize;
  int32 RetryResponses, SplitResponses, ErrorResponses;
  int32 AddrOrData, MemRegWrData;
  int32 AddrOrDataList[64];

  struct parameters *M2MParams;

  /* The parameters corresponds to the list of configurations defined for
     Test number "DMA_M2M_SDT_1" in the block verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters SDT1Cases[19] = {
     SMASTER, DMASTER,  8,  8, SINC, DINC,   1,   1, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16,  8, SINC, DINC,   1,   1, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,   1,   1, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32,  8, SINC, DINC,   1,   1, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC,   1,   1, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC,   1,   1, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER,  8,  8, SINC, DINC,   4,   4, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16,  8, SINC, DINC,   4,   4, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,   4,   4, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32,  8, SINC, DINC,   4,   4, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC,   4,   4, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC,   4,   4, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER,  8,  8, SINC, DINC, 256, 256, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16,  8, SINC, DINC, 256, 256, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC, 256, 256, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32,  8, SINC, DINC, 256, 256, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC, 256, 256, 1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC, 256, 256, 1, 0, 0, pbc, 0,
           2,       2, 32, 32, SINC, DINC, 256, 256, 1, 0, 0, pbc, 0};

  /* The parameters corresponds to the list of configurations defined for
     Test number "DMA_M2M_BDT_1" in the block verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters BDT1Cases[79] = {
     SMASTER, DMASTER, 8, 8, SINC, DINC,   1, 1,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   1, 1,    3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   1, 1,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   4, 1,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   4, 1,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   4, 1,    3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   4, 1,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   4, 1,    5, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   4, 1,    6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   4, 1,    7, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   4, 1,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   4, 1,   16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,    3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,    5, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,    6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,    7, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,    9, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,   10, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,   11, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,   12, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,   13, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,   14, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,   15, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,   16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,   8, 1,   32, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,    3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,    5, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,    6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,    7, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,    9, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   10, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   11, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   12, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   13, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   14, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   15, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   17, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   18, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   19, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   20, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   21, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   22, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   23, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   24, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   25, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   26, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   27, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   28, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   29, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   30, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   31, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   32, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  16, 1,   64, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  32, 1,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  32, 1,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  32, 1,   32, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  32, 1,  128, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  64, 1,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  64, 1,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  64, 1,   64, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  64, 1,  256, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 128, 1,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 128, 1,   16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 128, 1,  128, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 128, 1,  512, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 256, 1,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 256, 1,   32, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 256, 1,  256, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 256, 1, 1024, 0, 0, pbc, 0,
           2, DMASTER, 8, 8, SINC, DINC, 256, 1, 4095, 0, 0, pbc, 0};

  /* The parameters corresponds to the list of configurations defined for
     Test number "DMA_M2M_BDT_2" in the block verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters BDT2Cases[76] = {
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   4,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   4,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   4,    3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   4,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   4,    5, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   4,    6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   4,    7, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   4,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   4,   16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,    3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,    5, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,    6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,    7, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,    9, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,   10, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,   11, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,   12, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,   13, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,   14, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,   15, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,   16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,   8,   32, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,    3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,    5, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,    6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,    7, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,    9, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   10, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   11, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   12, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   13, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   14, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   15, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   17, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   18, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   19, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   20, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   21, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   22, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   23, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   24, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   25, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   26, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   27, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   28, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   29, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   30, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   31, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   32, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  16,   64, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  32,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  32,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  32,   32, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  32,  128, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  64,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  64,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  64,   64, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1,  64,  256, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1, 128,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1, 128,   16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1, 128,  128, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1, 128,  512, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1, 256,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1, 256,   64, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1, 256,  256, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 1, 256, 1024, 0, 0, pbc, 0,
           2, DMASTER, 8, 8, SINC, DINC, 1, 256, 4095, 0, 0, pbc, 0};
 
  /* The parameters corresponds to the list of configurations defined for
     Test number "DMA_M2M_BDT_3" in the block verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters BDT3Cases[22] = {
     SMASTER, DMASTER, 8, 8, SINC, DINC,  4,  4,   1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  4,  4,   3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  4,  4,   4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  4,  4,   7, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  8,  4,   1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  8,  4,   5, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  8,  4,   8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  8,  8,   3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  8,  8,   7, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  8,  8,   8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC,  8,  8,  15, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 16,  4,   2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 16,  4,  12, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 16,  4,  23, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 16,  8,   5, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 16,  8,   8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 16,  8,  15, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 16, 16,  10, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 16, 16,  16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 16, 16, 100, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 8, SINC, DINC, 16, 16, 255, 0, 0, pbc, 0,
           2, DMASTER, 8, 8, SINC, DINC, 16, 16, 255, 0, 0, pbc, 0};

  /* The parameters corresponds to the list of configurations defined for
     Test number "DMA_M2M_BDT_4" in the block verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters BDT4Cases[20] = {
     SMASTER, DMASTER, 8, 16, SINC, DINC,  4,  4,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC,  4,  4,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC,  4,  4,    6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC,  8,  4,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC,  8,  4,    6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC,  8,  4,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC,  8,  8,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC,  8,  8,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC,  8,  8,   18, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC, 16,  4,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC, 16,  4,   10, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC, 16,  4,   50, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC, 16,  8,    6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC, 16,  8,   20, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC, 16,  8,  100, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC, 16, 16,   14, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC, 16, 16,   16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC, 16, 16,  200, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 16, SINC, DINC, 16, 16, 3000, 0, 0, pbc, 0,
           2, DMASTER, 8, 16, SINC, DINC, 16, 16, 3000, 0, 0, pbc, 0};

  /* The parameters corresponds to the list of configurations defined for
     Test number "DMA_M2M_BDT_5" in the block verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters BDT5Cases[18] = {
     SMASTER, DMASTER, 8, 32, SINC, DINC,  4,  4,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 32, SINC, DINC,  4,  4,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 32, SINC, DINC,  8,  4,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 32, SINC, DINC,  8,  4,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 32, SINC, DINC,  8,  4,   12, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 32, SINC, DINC,  8,  8,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 32, SINC, DINC,  8,  8,   16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 32, SINC, DINC,  8,  8,   28, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 32, SINC, DINC, 16,  4,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 32, SINC, DINC, 16,  4,   12, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 32, SINC, DINC, 16,  4,   16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 32, SINC, DINC, 16,  8,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 32, SINC, DINC, 16,  8,   12, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 32, SINC, DINC, 16,  8,   16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 32, SINC, DINC, 16, 16,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 32, SINC, DINC, 16, 16,   16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 8, 32, SINC, DINC, 16, 16, 1024, 0, 0, pbc, 0,
           2, DMASTER, 8, 32, SINC, DINC, 16, 16, 1024, 0, 0, pbc, 0};

  /* The parameters corresponds to the list of configurations defined for
     Test number "DMA_M2M_BDT_6" in the block verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters BDT6Cases[28] = {
     SMASTER, DMASTER, 16, 8, SINC, DINC,  4,  4,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC,  4,  4,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC,  4,  4,    3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC,  4,  4,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC,  4,  4,   15, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC,  8,  4,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC,  8,  4,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC,  8,  4,    6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC,  8,  4,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC,  8,  4,    9, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC,  8,  8,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC,  8,  8,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC,  8,  8,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC,  8,  8,   11, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC,  8,  8,  256, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC, 16,  4,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC, 16,  4,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC, 16,  4,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC, 16,  4,   12, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC, 16,  8,    3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC, 16,  8,    6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC, 16,  8,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC, 16,  8,   16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC, 16,  8,  500, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC, 16, 16,    5, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC, 16, 16,   16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 8, SINC, DINC, 16, 16, 1200, 0, 0, pbc, 0,
           2, DMASTER, 16, 8, SINC, DINC, 16, 16, 1200, 0, 0, pbc, 0};

  /* The parameters corresponds to the list of configurations defined for
     Test number "DMA_M2M_BDT_7" in the block verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters BDT7Cases[25] = {
     SMASTER, DMASTER, 16, 16, SINC, DINC,  4,  4,   1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,  4,  4,   2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,  4,  4,   3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,  4,  4,   4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,  4,  4,   7, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,  4,  4, 255, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,  8,  4,   1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,  8,  4,   5, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,  8,  4,   8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,  8,  4,  15, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,  8,  8,   1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,  8,  8,   4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,  8,  8,   8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,  8,  8,  45, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC, 16,  4,   3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC, 16,  4,   6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC, 16,  4,   8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC, 16,  4, 100, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC, 16,  8,   5, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC, 16,  8,  16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC, 16,  8, 250, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC, 16, 16,   8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC, 16, 16,  16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC, 16, 16, 800, 0, 0, pbc, 0,
           2, DMASTER, 16, 16, SINC, DINC, 16, 16, 800, 0, 0, pbc, 0};

  /* The parameters corresponds to the list of configurations defined for
     Test number "DMA_M2M_BDT_8" in the block verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters BDT8Cases[17] = {
     SMASTER, DMASTER, 16, 32, SINC, DINC,  4, 4,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC,  4, 4,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC,  4, 4,   40, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC,  8, 4,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC,  8, 4,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC,  8, 4,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC,  8, 8,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC,  8, 8,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC,  8, 8,   56, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC, 16, 4,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC, 16, 4,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC, 16, 4,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC, 16, 8,    6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC, 16, 8,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC, 16, 8,   12, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC, 16, 8, 2048, 0, 0, pbc, 0,
           2, DMASTER, 16, 32, SINC, DINC, 16, 8, 2048, 0, 0, pbc, 0};

  /* The parameters corresponds to the list of configurations defined for
     Test number "DMA_M2M_BDT_9" in the block verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters BDT9Cases[16] = {
     SMASTER, DMASTER, 32, 8, SINC, DINC, 4, 4,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 8, SINC, DINC, 4, 4,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 8, SINC, DINC, 4, 4,    3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 8, SINC, DINC, 4, 4,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 8, SINC, DINC, 4, 4,    5, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 8, SINC, DINC, 4, 4,    6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 8, SINC, DINC, 4, 4,    7, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 8, SINC, DINC, 4, 4,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 8, SINC, DINC, 8, 4,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 8, SINC, DINC, 8, 4,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 8, SINC, DINC, 8, 4,   25, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 8, SINC, DINC, 8, 8,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 8, SINC, DINC, 8, 8,    5, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 8, SINC, DINC, 8, 8,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 8, SINC, DINC, 8, 8, 1024, 0, 0, pbc, 0,
           2, DMASTER, 32, 8, SINC, DINC, 8, 8, 1024, 0, 0, pbc, 0};

  /* The parameters corresponds to the list of configurations defined for
     Test number "DMA_M2M_BDT_10" in the block verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters BDT10Cases[16] = {
     SMASTER, DMASTER, 32, 16, SINC, DINC, 4, 4,   1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC, 4, 4,   2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC, 4, 4,   3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC, 4, 4,   4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC, 4, 4,   5, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC, 4, 4,   6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC, 4, 4,   7, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC, 4, 4,   8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC, 8, 4,   1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC, 8, 4,   3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC, 8, 4, 100, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC, 8, 8,   1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC, 8, 8,   8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC, 8, 8, 125, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC, 8, 8, 512, 0, 0, pbc, 0,
           2, DMASTER, 32, 16, SINC, DINC, 8, 8, 512, 0, 0, pbc, 0};

  /* The parameters corresponds to the list of configurations defined for
     Test number "DMA_M2M_BDT_11" in the block verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters BDT11Cases[17] = {
     SMASTER, DMASTER, 32, 32, SINC, DINC, 4, 4,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC, 4, 4,    2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC, 4, 4,    3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC, 4, 4,    4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC, 4, 4,    5, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC, 4, 4,    6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC, 4, 4,    7, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC, 4, 4,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC, 8, 4,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC, 8, 4,    6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC, 8, 4,   38, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC, 8, 8,    1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC, 8, 8,    7, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC, 8, 8,    8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC, 8, 8,  225, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC, 8, 8, 4095, 0, 0, pbc, 0,
           2, DMASTER, 32, 32, SINC, DINC, 8, 8, 4095, 0, 0, pbc, 0};

  /* The parameters corresponds to the list of configurations defined for
     Test number "DMA_M2M_LP_1" in the block verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters LP1Cases[7] = {
     SMASTER, DMASTER, 32, 32, "NI", "NI", 1, 1, 4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, "NI",  "I", 1, 1, 4, 0, 0, pbc, 1,
     SMASTER, DMASTER, 32, 32,  "I", "NI", 1, 1, 4, 0, 0, pbC, 0,
     SMASTER, DMASTER, 32, 32,  "I",  "I", 1, 1, 4, 0, 0, pBc, 0,
     SMASTER, DMASTER, 32, 32, "NI",  "I", 1, 1, 4, 0, 0, Pbc, 0,
     SMASTER, DMASTER, 32, 32,  "I",  "I", 1, 1, 4, 0, 0, PBC, 1,
           2, DMASTER, 32, 32,  "I",  "I", 1, 1, 4, 0, 0, PBC, 1};

  /* The test cases and their corresponding parameters are listed here.
     The user can modify the 'caselist' to run the specific test cases.
     e.g., if the user wants to test only the first test case, the last
     element "ENDOFTEST" of the array may be put next to the SDT_1 test */
  struct caselist M2MCaseList[14] = {
     "DMA_M2M_SDT_1",  SDT1Cases,
     "DMA_M2M_BDT_1",  BDT1Cases,
     "DMA_M2M_BDT_2",  BDT2Cases,
     "DMA_M2M_BDT_3",  BDT3Cases,
     "DMA_M2M_BDT_4",  BDT4Cases,
     "DMA_M2M_BDT_5",  BDT5Cases,
     "DMA_M2M_BDT_6",  BDT6Cases,
     "DMA_M2M_BDT_7",  BDT7Cases,
     "DMA_M2M_BDT_8",  BDT8Cases,
     "DMA_M2M_BDT_9",  BDT9Cases,
     "DMA_M2M_BDT_10", BDT10Cases,
     "DMA_M2M_BDT_11", BDT11Cases,
     "DMA_M2M_LP_1", LP1Cases,
     "ENDOFTEST", SDT1Cases};

  struct caselist *TestCases = M2MCaseList;

  while (TestCases->CaseNumber != "ENDOFTEST")
  {
    sprintf(report,"Test No : %s",TestCases->CaseNumber);
    C(report);
 
    M2MParams = TestCases->TestParams;
    while (M2MParams->SrcMaster != 2)
    {
      /* The master of the Dmac with which the source and destination memory
         models will interact are configured in the Request Configuration
         (DMACREQCONFIG) register of the trickbox.
         Please note that Memory0 is always fixed as the source and Memory1
         is always fixed as the destination of the Dma transfer.             */
      MasterConfig = (DMASTER << 1) | SMASTER;
      Write(DMACREQCONFIG, MasterConfig);

      ProgramResponse("M2M",
                      M2MParams->TxSize,
                      M2MParams->SrcWidth,
                      M2MParams->DestWidth);

      if (M2MParams->SrcWidth == 8)
        SrcAddrMask = 0xFFFFFFFF;
      else if (M2MParams->SrcWidth == 16)
        SrcAddrMask = 0xFFFFFFFE;
      else
        SrcAddrMask = 0xFFFFFFFC;

      if (M2MParams->DestWidth == 8)
        DestAddrMask = 0xFFFFFFFF;
      else if (M2MParams->DestWidth == 16)
        DestAddrMask = 0xFFFFFFFE;
      else
        DestAddrMask = 0xFFFFFFFC;

      /* M2MDma function will program the given channel for a memory-memory
         Dma transfer and waits till the Dma transfer is completed.         */
      M2MDma(CHANNEL,
             AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
             AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
             M2MParams->LLIAddress,
             M2MParams->SrcMaster,
             M2MParams->DestMaster,
             M2MParams->SrcWidth,
             M2MParams->DestWidth,
             M2MParams->SrcInc,
             M2MParams->DestInc,
             M2MParams->SrcBurst,
             M2MParams->DestBurst,
             M2MParams->TxSize,
             M2MParams->LLIMaster,
             M2MParams->Protection,
             M2MParams->Lock,
             TCENABLE,
             TCMASK,
             ERRMASK);

      /* The memory models' registers are reset after the testing. */
      Write(DMACTrMemEn0, MEMORYRESET);
      Write(DMACTrMemEn1, MEMORYRESET);
      M2MParams++;
    }

    /* The memory models are disabled after all the tests. */
    Write(DMACTrMemEn0, MEMORYDISABLE);
    Write(DMACTrMemEn1, MEMORYDISABLE);
    TestCases++;
  }
} 

/************************************ End *************************************/
