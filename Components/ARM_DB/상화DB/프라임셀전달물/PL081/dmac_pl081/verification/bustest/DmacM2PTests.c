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
-- File Name              : DmacM2PTests.c.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Memory-to-Peripheral Dma transfer test code.
-- --=========================================================================*/
 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** AddrGen                                    DmacCommon.c                ***/
/*** CheckStatus                                DmacCommon.c                ***/
/*** DestPeriphNo                               DmacCommon.c                ***/
/*** M2PDma                                     DmacCommon.c                ***/
/*** M2PDp                                      DmacCommon.c                ***/
/*** PeriphReg                                  DmacCommon.c                ***/
/*** Poll                                       DmacCommon.c                ***/
/*** ProgramResponse                            DmacCommon.c                ***/
/*** Write                                      DmacCommon.c                ***/
/******************************************************************************/
 
void M2PTests()
{
  /*
    Summary: Memory-Peripheral Dma Tests
    ====================================
      o Memory-to-Peripheral(M2P) Dma transfers are tested using this function.
      o The M2P dma transfer test cases are as defined in the block verification
        document. All the test cases written here are used to test the given
        channel, defined by the "CHANNEL" in Dmac.h file.
        The master port for the source and destination of the dma transfer as
        well as the incrementing/non-incrementing nature of the address of the
        source/destination dma transfer are defined by SMASTER, DMASTER, SINCR
        and DINCR respectively. The destination peripheral value will be
        internally generated if teh constant "TESTCONFIGURATION" is set to
        "DEFAULT" in the Dmac.h file. If the constant "TESTCONFIGURATION", in
        Dmac.h file, is set to "USER", the destination peripheral is same
        as defined by DPERIPH in Dmac.h file, for all the test cases. Other
        parameters are as defined in the block verification document.
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
   
  struct caselist                  {
    char *CaseNumber;
    struct parameters *TestParams;
  };

  struct requestcycles {
    int SRC;
    int BRC;
  };

  char *DefaultResponse;
  int i, j, k, x, y, z, OnethirdData, MaxValue;
  int32 SrcAddrMask, DestAddrMask;
  int32 MasterConfig, RegWrAddr;
  int32 WaitCycles, Response, SeedData, RSCount;
  int32 VlsbCount, ControlBase, SourceTxSize;
  int32 RetryResponses, SplitResponses, ErrorResponses;
  int32 AddrOrData, MemRegWrData, PeriphRegWrData;
  int32 AddrOrDataList[64];
 
  struct parameters *M2PParams;
 
  /* The parameters corresponds to the list of configurations defined for
     Test number "DMA_M2P_DMAC_1" in the block verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters BREQCases[10] = {
     SMASTER, DMASTER,  8,  8, SINC, DINC,  16,   1, 49, 0, 0, pbc, 0,
     SMASTER, DMASTER,  8, 16, SINC, DINC,  16,  16, 30, 0, 0, pbc, 0,
     SMASTER, DMASTER,  8, 32, SINC, DINC,  32,  32,  4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16,  8, SINC, DINC,   8,   8, 11, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,   8,   1, 66, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC,   8,   8,  2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32,  8, SINC, DINC,   4,   4, 15, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC,   8,   8,  1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC,   4,   1, 99, 0, 0, pbc, 0,
           2, DMASTER, 32, 32, SINC, DINC, 256, 256, 49, 0, 0, pbc, 0};
  
  /* The parameters corresponds to the list of configurations defined for
     Test numbers "DMA_M2P_DP_1, DMA_M2P_DP_2, DMA_M2P_DP_3, DMA_M2P_DP_3A,
     DMA_M2P_DP_4, DMA_M2P_DP_5, DMA_M2P_DP_6, DMA_M2P_DP_7, DMA_M2P_DP_8,
     DMA_M2P_DP_9, DMA_M2P_DP_10, DMA_M2P_DP_11, DMA_M2P_DP_12, DMA_M2P_DP_13,
     DMA_M2P_DP_14 and DMA_M2P_DP_15" in the block verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters M2PDPCases[10] = {
     SMASTER, DMASTER,  8,  8, SINC, DINC,  16,   1, 49, 0, 0, pbc, 0,
     SMASTER, DMASTER,  8, 16, SINC, DINC,  16,  16, 30, 0, 0, pbc, 0,
     SMASTER, DMASTER,  8, 32, SINC, DINC,  32,  32,  4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16,  8, SINC, DINC,   8,   8, 11, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,   8,   1, 66, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC,   8,   8,  2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32,  8, SINC, DINC,   4,   4, 15, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC,   8,   8,  1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC,   4,   1, 99, 0, 0, pbc, 0,
           2, DMASTER, 32, 32, SINC, DINC, 256, 256, 49, 0, 0, pbc, 0};

  /* The time window during which the request is to be initiated, is programmed
     here. For e.g., 1 means after step 1 as written in the verification
     document. the step 1 may be given as channel setup for the Dma transfer.
     In this case, the request from the peripheral will be initiated after
     setting the channel parameters, but before enabling the channel. There are
     four steps as defined in the test plan.
     The first element of the array, SREQCycles indicates the timing window
     during which the single data request from the destination peripheral
     will be initiated. The secnd element of the array, BREQCycles indicates
     the timing window during which the burst data request from the destination
     peripheral will be initiated. Writing '0' (zero) indicates that the
     request is not initiated at all. In the following case no single data
     request is initiated by the destination peripheral.
     Write (0,0) to indicate end of patterns.                                 */

  struct requestcycles BREQCycles[6] = {0, 10,
                                        0,  4,
                                        0,  3,
                                        0,  2,
                                        0,  1,
                                        0,  0};

  struct requestcycles REQ2Cycles[2] = {(rand() % 15) + 1, (rand() % 15) + 1,
                                        0, 0};

  /* The test cases and their corresponding parameters are listed here.
     The user can modify the 'caselist' to run the specific test cases.
     e.g., if the user wants to test only the first test case, the last
     element "ENDOFTEST" of the array may be put next to the DMAC_1 test */
  struct caselist M2PCaseList[18] = {
     "DMA_M2P_DMAC_1", BREQCases,
     "DMA_M2P_DP_1",   M2PDPCases,
     "DMA_M2P_DP_2",   M2PDPCases,
     "DMA_M2P_DP_3",   M2PDPCases,
     "DMA_M2P_DP_3A",  M2PDPCases,
     "DMA_M2P_DP_4",   M2PDPCases,
     "DMA_M2P_DP_5",   M2PDPCases,
     "DMA_M2P_DP_6",   M2PDPCases,
     "DMA_M2P_DP_7",   M2PDPCases,
     "DMA_M2P_DP_8",   M2PDPCases,
     "DMA_M2P_DP_9",   M2PDPCases,
     "DMA_M2P_DP_10",  M2PDPCases,
     "DMA_M2P_DP_11",  M2PDPCases,
     "DMA_M2P_DP_12",  M2PDPCases,
     "DMA_M2P_DP_13",  M2PDPCases,
     "DMA_M2P_DP_14",  M2PDPCases,
     "DMA_M2P_DP_15",  M2PDPCases,
     "ENDOFTEST",      BREQCases};
  
  int32 RequestRepeatRate;
  int   DataXfer;

  struct caselist *TestCases = M2PCaseList;
  struct requestcycles *PeriphRequests;

  i = 0;
  j = 0;

  while (TestCases->CaseNumber != "ENDOFTEST")
  {
    sprintf(report,"Test No : %s",TestCases->CaseNumber);
    C(report);
   
    M2PParams = TestCases->TestParams;
    while (M2PParams->SrcMaster != 2)
    {
      /* The master of the Dmac with which the source memory and 
         destination peripheral models will interact are configured
         in the Request Configuration (DMACREQCONFIG) register of the trickbox
         Please note that Memory0 is always fixed as the source of the DMA
          and DestPeripheral is fixed as the destination peripheral. 
         The master configuration for peripheral 0 is bit 2 in the register,
         for peripheral 1 it is bit 3 etc...upto bit 17 for peripheral 15
         Therefore the DMASTER bit is shifted by the DestPeripheral value here.
      */
      if (M2PParams->SrcWidth == 8)
        SrcAddrMask = 0xFFFFFFFF;
      else if (M2PParams->SrcWidth == 16)
        SrcAddrMask = 0xFFFFFFFE;
      else
        SrcAddrMask = 0xFFFFFFFC;
  
      if (M2PParams->DestWidth == 8)
        DestAddrMask = 0xFFFFFFFF;
      else if (M2PParams->DestWidth == 16)
        DestAddrMask = 0xFFFFFFFE;
      else
        DestAddrMask = 0xFFFFFFFC;

      /* Generating the request signals at different timings as
         mentioned in the tables in the test document
         i.e., after enabling the channel /
         before enabling the channel but after configuring it/
         before configuring the channel but after setting it up
         etc....                                                */
  
      if (TestCases->CaseNumber == "DMA_M2P_DMAC_1")
      {
        PeriphRequests = BREQCycles;
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DMAC_2")
      {
        PeriphRequests = REQ2Cycles;
      }

      if ((TestCases->CaseNumber == "DMA_M2P_DMAC_1") ||
          (TestCases->CaseNumber == "DMA_M2P_DMAC_2"))
      {
        while ((PeriphRequests->SRC != 0) | (PeriphRequests->BRC != 0))
        {

          DestPeriphNo();

          MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
          Write(DMACREQCONFIG, MasterConfig);
 
          ProgramResponse("M2P",
                          M2PParams->TxSize,
                          M2PParams->SrcWidth,
                          M2PParams->DestWidth);

          RequestRepeatRate = (PeriphRequests->BRC << 8) +
                              (PeriphRequests->SRC);

          Write(PeriphReg(DestPeripheral, PERIPHREQREG), RequestRepeatRate);

          M2PDma(CHANNEL,
                 DestPeripheral,
                 AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
                 AddrGen(PeriphLowAddress[DestPeripheral],
                         PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                 M2PParams->LLIAddress,
                 M2PParams->SrcMaster,
                 M2PParams->DestMaster,
                 M2PParams->SrcWidth,
                 M2PParams->DestWidth,
                 M2PParams->SrcInc,
                 M2PParams->DestInc,
                 M2PParams->SrcBurst,
                 M2PParams->DestBurst,
                 M2PParams->TxSize,
                 M2PParams->LLIMaster,
                 M2PParams->Protection,
                 M2PParams->Lock,
                 TCENABLE,
                 TCMASK,
                 ERRMASK);

          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(DMACTrMemEn0, MEMORYRESET);
          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          PeriphRequests++;
        }
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DP_1")
      {
        for (x=1;x<5;x++)
        {
          /* Objective : Assertion of DMALSREQ */


          DestPeriphNo();

          MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
          Write(DMACREQCONFIG, MasterConfig);
 
          ProgramResponse("M2P",
                          1,
                          M2PParams->SrcWidth,
                          M2PParams->DestWidth);
          /* Program the request generation register of the peripheral
             such that it raises the DMALSREQ signal at different
             times during the programming of the channel for an M2P transfer
             Bits 23-16 indicates the number of clocks, it takes to raise
             the DMALSREQ signal                                             */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 16));

          M2PDp(CHANNEL,
                DestPeripheral,
                AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                M2PParams->LLIAddress,
                M2PParams->SrcMaster,
                M2PParams->DestMaster,
                M2PParams->SrcWidth,
                M2PParams->DestWidth,
                M2PParams->SrcInc,
                M2PParams->DestInc,
                M2PParams->SrcBurst,
                M2PParams->DestBurst,
                M2PParams->LLIMaster,
                M2PParams->Protection,
                M2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
 
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(DMACTrMemEn0, MEMORYRESET);
          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DP_2")
      {
        for (x=1;x<5;x++)
        {
          /* Objective : Assertion of DMALBREQ */


          DestPeriphNo();

          MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
          Write(DMACREQCONFIG, MasterConfig);
 
          ProgramResponse("M2P",
                          M2PParams->SrcBurst,
                          M2PParams->SrcWidth,
                          M2PParams->DestWidth);
          /* Program the request generation register of the peripheral
             such that it raises the DMALBREQ signal at different
             times during the programming of the channel for an M2P transfer.
             Bits 31-24 indicates the number of clocks, it takes to raise
             the DMALBREQ signal.                                            */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 24));
 
          M2PDp(CHANNEL,
                DestPeripheral,
                AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                M2PParams->LLIAddress,
                M2PParams->SrcMaster,
                M2PParams->DestMaster,
                M2PParams->SrcWidth,
                M2PParams->DestWidth,
                M2PParams->SrcInc,
                M2PParams->DestInc,
                M2PParams->SrcBurst,
                M2PParams->DestBurst,
                M2PParams->LLIMaster,
                M2PParams->Protection,
                M2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(DMACTrMemEn0, MEMORYRESET);
          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DP_3")
      {
        for (x=1;x<5;x++)
        {
          /* Objective : Assertion of DMASREQ followed by DMALSREQ */


          DestPeriphNo();

          MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
          Write(DMACREQCONFIG, MasterConfig);
 
          ProgramResponse("M2P",
                          2,
                          M2PParams->SrcWidth,
                          M2PParams->DestWidth);
          /* Program the request generation register of the peripheral
             such that it raises the DMASREQ signal at different
             times during the programming of the channel for an M2P transfer.
             Bits 7-0 indicates the number of clocks, it takes to raise
             the DMASREQ signal.                                            */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), (2*x));

          M2PDp(CHANNEL,
                DestPeripheral,
                AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                M2PParams->LLIAddress,
                M2PParams->SrcMaster,
                M2PParams->DestMaster,
                M2PParams->SrcWidth,
                M2PParams->DestWidth,
                M2PParams->SrcInc,
                M2PParams->DestInc,
                M2PParams->SrcBurst,
                M2PParams->DestBurst,
                M2PParams->LLIMaster,
                M2PParams->Protection,
                M2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Initiate DMALSREQ request from the peripheral */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((20*x) << 16));

          /* Only if an error is not returned, then the following
             registers can be polled. If an error response is
             returned, then the Dmac does not return CLR/TC signals.
             Therefore only the Channel enable bit is polled        */

          if ((SrcError == 0) && (DestError == 0))
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

            /* Poll for the DMACSoftLSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          /* Check that the Channel is disabled */
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(DMACTrMemEn0, MEMORYRESET);
          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DP_3A")
      {
        for (x=1;x<5;x++)
        {
          /* Objective : Assertion of DMASREQ followed by DMALBREQ */


          DestPeriphNo();

          MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
          Write(DMACREQCONFIG, MasterConfig);
 
          ProgramResponse("M2P",
                          (M2PParams->SrcBurst + 1),
                           M2PParams->SrcWidth,
                           M2PParams->DestWidth);

          /* Program the request generation register of the peripheral
             such that it raises the DMASREQ signal at different
             times during the programming of the channel for an M2P transfer
             Bits 7-0 indicates the number of clocks, it takes to raise
             the DMASREQ signal                                             */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), (2*x));
 
          M2PDp(CHANNEL,
                DestPeripheral,
                AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                M2PParams->LLIAddress,
                M2PParams->SrcMaster,
                M2PParams->DestMaster,
                M2PParams->SrcWidth,
                M2PParams->DestWidth,
                M2PParams->SrcInc,
                M2PParams->DestInc,
                M2PParams->SrcBurst,
                M2PParams->DestBurst,
                M2PParams->LLIMaster,
                M2PParams->Protection,
                M2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Initiate DMALBREQ request from the peripheral */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((20*x) << 24));

          /* Only if an error is not returned, then the following
             registers can be polled. If an error response is
             returned, then the Dmac does not return CLR/TC signals.
             Therefore only the Channel enable bit is polled        */

          if ((SrcError == 0) && (DestError == 0))
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

            /* Poll for the DMACSoftLBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          /* Check that the Channel is disabled */
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(DMACTrMemEn0, MEMORYRESET);
          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DP_4")
      {
        for (x=1;x<5;x++)
        {
          /* Objective : Assertion of DMABREQ followed by DMALSREQ */


          DestPeriphNo();

          MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
          Write(DMACREQCONFIG, MasterConfig);
 
          ProgramResponse("M2P",
                          (M2PParams->SrcBurst + 1),
                           M2PParams->SrcWidth,
                           M2PParams->DestWidth);
          /* Program the request generation register of the peripheral
             such that it raises the DMABREQ signal at different
             times during the programming of the channel for an M2P transfer
             Bits 15-8 indicates the number of clocks, it takes to raise
             the DMABREQ signal                                             */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));

          M2PDp(CHANNEL,
                DestPeripheral,
                AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                M2PParams->LLIAddress,
                M2PParams->SrcMaster,
                M2PParams->DestMaster,
                M2PParams->SrcWidth,
                M2PParams->DestWidth,
                M2PParams->SrcInc,
                M2PParams->DestInc,
                M2PParams->SrcBurst,
                M2PParams->DestBurst,
                M2PParams->LLIMaster,
                M2PParams->Protection,
                M2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Initiate DMALSREQ request from the peripheral */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((20*x) << 16));

          /* Only if an error is not returned, then the following
             registers can be polled. If an error response is
             returned, then the Dmac does not return CLR/TC signals.
             Therefore only the Channel enable bit is polled        */

          if ((SrcError == 0) && (DestError == 0))
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

            /* Poll for the DMACSoftLSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          /* Check that the Channel is disabled */
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(DMACTrMemEn0, MEMORYRESET);
          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DP_5")
      {
        for (x=1;x<5;x++)
        {
          /* Objective : Assertion of DMABREQ followed by DMALBREQ */


          DestPeriphNo();

          MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
          Write(DMACREQCONFIG, MasterConfig);
 
          ProgramResponse("M2P",
                          (M2PParams->SrcBurst * 2),
                           M2PParams->SrcWidth,
                           M2PParams->DestWidth);
          /* Program the request generation register of the peripheral
             such that it raises the DMABREQ signal at different
             times during the programming of the channel for an M2P transfer
             Bits 15-8 indicates the number of clocks, it takes to raise
             the DMABREQ signal                                             */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));

          M2PDp(CHANNEL,
                DestPeripheral,
                AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                M2PParams->LLIAddress,
                M2PParams->SrcMaster,
                M2PParams->DestMaster,
                M2PParams->SrcWidth,
                M2PParams->DestWidth,
                M2PParams->SrcInc,
                M2PParams->DestInc,
                M2PParams->SrcBurst,
                M2PParams->DestBurst,
                M2PParams->LLIMaster,
                M2PParams->Protection,
                M2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Initiate DMALBREQ request from the peripheral */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((20*x) << 24));

          /* Only if an error is not returned, then the following
             registers can be polled. If an error response is
             returned, then the Dmac does not return CLR/TC signals.
             Therefore only the Channel enable bit is polled        */

          if ((SrcError == 0) && (DestError == 0))
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

            /* Poll for the DMACSoftLBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          /* Check that the Channel is disabled */
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(DMACTrMemEn0, MEMORYRESET);
          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DP_6")
      {
        for (x=1;x<5;x++)
        {
          /* Objective : Assertion of 2 DMASREQ followed by DMALSREQ. */


          DestPeriphNo();

          MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
          Write(DMACREQCONFIG, MasterConfig);
 
          ProgramResponse("M2P",
                          3,
                          M2PParams->SrcWidth,
                          M2PParams->DestWidth);
          /* Program the request generation register of the peripheral
             such that it raises the DMASREQ signal at different
             times during the programming of the channel for an M2P transfer
             Bits 7-0 indicates the number of clocks, it takes to raise
             the DMASREQ signal                                             */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), (2*x));

          M2PDp(CHANNEL,
                DestPeripheral,
                AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                M2PParams->LLIAddress,
                M2PParams->SrcMaster,
                M2PParams->DestMaster,
                M2PParams->SrcWidth,
                M2PParams->DestWidth,
                M2PParams->SrcInc,
                M2PParams->DestInc,
                M2PParams->SrcBurst,
                M2PParams->DestBurst,
                M2PParams->LLIMaster,
                M2PParams->Protection,
                M2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);

          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer.
             After that change the register values immediately so that
             there are 2 SREQ followed by an LSREQ as required */
          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          if ((SrcError == 0) && (DestError == 0))
          {
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          }
          else
          {
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          }

          /* Initiate DMALSREQ request from the peripheral */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((20*x) << 16));

          /* Only if an error is not returned, then the following
             registers can be polled. If an error response is
             returned, then the Dmac does not return CLR/TC signals.
             Therefore only the Channel enable bit is polled        */

          if ((SrcError == 0) && (DestError == 0))
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

            /* Poll for the DMACSoftLSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          /* Check that the Channel is disabled */
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(DMACTrMemEn0, MEMORYRESET);
          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DP_7")
      {
        for (x=1;x<5;x++)
        {
          /* Objective : Assertion of 2 DMABREQ followed by DMALBREQ. */


          DestPeriphNo();

          MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
          Write(DMACREQCONFIG, MasterConfig);
 
          ProgramResponse("M2P",
                          (M2PParams->SrcBurst * 3),
                           M2PParams->SrcWidth,
                           M2PParams->DestWidth);
          /* Program the request generation register of the peripheral
             such that it raises the DMABREQ signal at different
             times during the programming of the channel for an M2P transfer
             Bits 15-8 indicates the number of clocks, it takes to raise
             the DMABREQ signal                                             */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));

          M2PDp(CHANNEL,
                DestPeripheral,
                AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                M2PParams->LLIAddress,
                M2PParams->SrcMaster,
                M2PParams->DestMaster,
                M2PParams->SrcWidth,
                M2PParams->DestWidth,
                M2PParams->SrcInc,
                M2PParams->DestInc,
                M2PParams->SrcBurst,
                M2PParams->DestBurst,
                M2PParams->LLIMaster,
                M2PParams->Protection,
                M2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
          /* Poll for the DMACSoftBReq bit to be reset
             after the DMA transfer.
             After that change the register values immediately so that
             there are 2 BREQ followed by an LBREQ as required */
          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          if ((SrcError == 0) && (DestError == 0))
          {
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          }
          else
          {
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          }

          /* Initiate DMALBREQ request from the peripheral */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((20*x) << 24));

          /* Only if an error is not returned, then the following
             registers can be polled. If an error response is
             returned, then the Dmac does not return CLR/TC signals.
             Therefore only the Channel enable bit is polled        */

          if ((SrcError == 0) && (DestError == 0))
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

            /* Poll for the DMACSoftLBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          /* Check that the Channel is disabled */
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(DMACTrMemEn0, MEMORYRESET);
          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DP_8")
      {
        /* Objective : Assertion of multiple(10) DMASREQ and DMALSREQ
                       to complete the DMA transfer                   */

        DestPeriphNo();

        MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
        Write(DMACREQCONFIG, MasterConfig);
 
        ProgramResponse("M2P",
                         11,
                         M2PParams->SrcWidth,
                         M2PParams->DestWidth);
        /* Program the request generation register of the peripheral
           such that it raises the DMASREQ signal at different
           times during the programming of the channel for an M2P transfer
           Bits 7-0 indicates the number of clocks, it takes to raise
           the DMASREQ signal                                             */
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), 10);

        M2PDp(CHANNEL,
              DestPeripheral,
              AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              M2PParams->LLIAddress,
              M2PParams->SrcMaster,
              M2PParams->DestMaster,
              M2PParams->SrcWidth,
              M2PParams->DestWidth,
              M2PParams->SrcInc,
              M2PParams->DestInc,
              M2PParams->SrcBurst,
              M2PParams->DestBurst,
              M2PParams->LLIMaster,
              M2PParams->Protection,
              M2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<10;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
        }
        else
        {
          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
        }

        /* Initiate DMALSREQ request from the peripheral */
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (100 << 16));

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(DMACTrMemEn0, MEMORYRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DP_9")
      {
        /* Objective : Assertion of multiple(10) DMASREQ and DMALBREQ
                       to complete the DMA transfer                   */


        DestPeriphNo();

        MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
        Write(DMACREQCONFIG, MasterConfig);
 
        ProgramResponse("M2P",
                        (M2PParams->SrcBurst + 11),
                         M2PParams->SrcWidth,
                         M2PParams->DestWidth);
        /* Program the request generation register of the peripheral
           such that it raises the DMASREQ signal at different
           times during the programming of the channel for an M2P transfer
           Bits 7-0 indicates the number of clocks, it takes to raise
           the DMASREQ signal                                             */
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), 10);

        M2PDp(CHANNEL,
              DestPeripheral,
              AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              M2PParams->LLIAddress,
              M2PParams->SrcMaster,
              M2PParams->DestMaster,
              M2PParams->SrcWidth,
              M2PParams->DestWidth,
              M2PParams->SrcInc,
              M2PParams->DestInc,
              M2PParams->SrcBurst,
              M2PParams->DestBurst,
              M2PParams->LLIMaster,
              M2PParams->Protection,
              M2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<10;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
        }
        else
        {
          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
        }

        /* Initiate DMALBREQ request from the peripheral */
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (100 << 24));

        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

          /* Poll for the DMACSoftLBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(DMACTrMemEn0, MEMORYRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DP_10")
      {
        /* Objective : Assertion of multiple(10) DMABREQ and DMALSREQ
                       to complete the DMA transfer                   */
 

        DestPeriphNo();

        MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
        Write(DMACREQCONFIG, MasterConfig);
 
        ProgramResponse("M2P",
                       ((M2PParams->SrcBurst * 10) + 1),
                         M2PParams->SrcWidth,
                         M2PParams->DestWidth);
        /* Program the request generation register of the peripheral
           such that it raises the DMABREQ signal at different
           times during the programming of the channel for an M2P transfer
           Bits 15-8 indicates the number of clocks, it takes to raise
           the DMABREQ signal                                             */
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (10 << 8));
 
        M2PDp(CHANNEL,
              DestPeripheral,
              AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              M2PParams->LLIAddress,
              M2PParams->SrcMaster,
              M2PParams->DestMaster,
              M2PParams->SrcWidth,
              M2PParams->DestWidth,
              M2PParams->SrcInc,
              M2PParams->DestInc,
              M2PParams->SrcBurst,
              M2PParams->DestBurst,
              M2PParams->LLIMaster,
              M2PParams->Protection,
              M2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);
 
        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<10;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
        }
        else
        {
          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
        }

        /* Initiate DMALSREQ request from the peripheral */
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (100 << 16));

        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Poll for the DMACSoftBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
  
          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(DMACTrMemEn0, MEMORYRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DP_11")
      {
        /* Objective : Assertion of multiple(10) DMABREQ and DMALBREQ
                       to complete the DMA transfer                   */
 

        DestPeriphNo();

        MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
        Write(DMACREQCONFIG, MasterConfig);
 
        ProgramResponse("M2P",
                        (M2PParams->SrcBurst * 11),
                         M2PParams->SrcWidth,
                         M2PParams->DestWidth);
        /* Program the request generation register of the peripheral
           such that it raises the DMABREQ signal at different
           times during the programming of the channel for an M2P transfer
           Bits 15-8 indicates the number of clocks, it takes to raise
           the DMABREQ signal                                             */
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (10 << 8));

        M2PDp(CHANNEL,
              DestPeripheral,
              AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              M2PParams->LLIAddress,
              M2PParams->SrcMaster,
              M2PParams->DestMaster,
              M2PParams->SrcWidth,
              M2PParams->DestWidth,
              M2PParams->SrcInc,
              M2PParams->DestInc,
              M2PParams->SrcBurst,
              M2PParams->DestBurst,
              M2PParams->LLIMaster,
              M2PParams->Protection,
              M2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);
 
        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<10;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
        }
        else
        {
          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
        }

        /* Initiate DMALBREQ request from the peripheral */
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (100 << 24));

        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Poll for the DMACSoftBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

          /* Poll for the DMACSoftLBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(DMACTrMemEn0, MEMORYRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DP_12")
      {
        /* Objective : Assertion of multiple(10) DMABREQ followed by
                       multiple (10) DMASREQ and DMALSREQ to complete
                       the DMA transfer                               */


        DestPeriphNo();

        MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
        Write(DMACREQCONFIG, MasterConfig);
 
        ProgramResponse("M2P",
                       ((M2PParams->SrcBurst * 10) + 11),
                         M2PParams->SrcWidth,
                         M2PParams->DestWidth);
        /* Program the request generation register of the peripheral
           such that it raises the DMABREQ signal at different
           times during the programming of the channel for an M2P transfer
           Bits 15-8 indicates the number of clocks, it takes to raise
           the DMABREQ signal                                             */
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (10 << 8));

        M2PDp(CHANNEL,
              DestPeripheral,
              AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              M2PParams->LLIAddress,
              M2PParams->SrcMaster,
              M2PParams->DestMaster,
              M2PParams->SrcWidth,
              M2PParams->DestWidth,
              M2PParams->SrcInc,
              M2PParams->DestInc,
              M2PParams->SrcBurst,
              M2PParams->DestBurst,
              M2PParams->LLIMaster,
              M2PParams->Protection,
              M2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);
 
        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */
        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<10;x++)
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Program the register to raise DMASREQ only */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), 10);

          for (x=0;x<10;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
        }
        else
        {
          /* When the Memory/Peripheral is programmed to return
             an error response, the sequence of requests mentioned
             in the objective need not be met                      */

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
        }

        /* Initiate DMALSREQ request from the peripheral */
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (100 << 16));

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));
  
          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(DMACTrMemEn0, MEMORYRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DP_13")
      {
        /* Objective : Assertion of multiple(10) DMASREQ followed by
                       multiple(10) DMABREQ and DMALBREQ
                       to complete the DMA transfer                  */
 

        DestPeriphNo();

        MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
        Write(DMACREQCONFIG, MasterConfig);
 
        ProgramResponse("M2P",
                       ((M2PParams->SrcBurst * 11) + 10),
                         M2PParams->SrcWidth,
                         M2PParams->DestWidth);
        /* Program the request generation register of the peripheral
           such that it raises the DMASREQ signal at different
           times during the programming of the channel for an M2P transfer
           Bits 7-0 indicates the number of clocks, it takes to raise
           the DMASREQ signal                                             */
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), 10);

        M2PDp(CHANNEL,
              DestPeripheral,
              AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              M2PParams->LLIAddress,
              M2PParams->SrcMaster,
              M2PParams->DestMaster,
              M2PParams->SrcWidth,
              M2PParams->DestWidth,
              M2PParams->SrcInc,
              M2PParams->DestInc,
              M2PParams->SrcBurst,
              M2PParams->DestBurst,
              M2PParams->LLIMaster,
              M2PParams->Protection,
              M2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);
 
        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<10;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Program the register to raise DMABREQ only */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), (100 << 8));

          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

          for (x=0;x<10;x++)
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
        }
        else
        {
          /* When the Memory/Peripheral is programmed to return
             an error response, the sequence of requests mentioned
             in the objective need not be met                      */

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
        }

        /* Initiate DMALBREQ request from the peripheral */
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (100 << 24));

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Poll for the DMACSoftBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

          /* Poll for the DMACSoftLBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(DMACTrMemEn0, MEMORYRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DP_14")
      {
        /* Objective : Assertion of alternate DMASREQ and DMABREQ followed by
                       DMALBREQ to complete the DMA transfer                  */
 

        DestPeriphNo();

        MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
        Write(DMACREQCONFIG, MasterConfig);
 
        ProgramResponse("M2P",
                       ((M2PParams->SrcBurst * 11) + 10),
                         M2PParams->SrcWidth,
                         M2PParams->DestWidth);
        /* Program the request generation register of the peripheral
           such that it raises the DMASREQ signal at different
           times during the programming of the channel for an M2P transfer
           Bits 7-0 indicates the number of clocks, it takes to raise
           the DMASREQ signal                                             */
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), 10);

        M2PDp(CHANNEL,
              DestPeripheral,
              AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              M2PParams->LLIAddress,
              M2PParams->SrcMaster,
              M2PParams->DestMaster,
              M2PParams->SrcWidth,
              M2PParams->DestWidth,
              M2PParams->SrcInc,
              M2PParams->DestInc,
              M2PParams->SrcBurst,
              M2PParams->DestBurst,
              M2PParams->LLIMaster,
              M2PParams->Protection,
              M2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);
 
        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<10;x++)
          {
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
  
            /* Program the register to raise DMABREQ only */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), (10 << 8));
  
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));
  
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
  
            /* Program the register to raise DMASREQ only */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), 10);
  
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }
        }

        Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

        /* Initiate DMALBREQ request from the peripheral */
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (100 << 24));

        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

          /* Poll for the DMACSoftLBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(DMACTrMemEn0, MEMORYRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_M2P_DP_15")
      {
        /* Objective : Assertion of alternate DMABREQ and DMASREQ followed by
                       DMALSREQ to complete the DMA transfer                  */
 

        DestPeriphNo();

        MasterConfig = (DMASTER << (DestPeripheral + 2)) | SMASTER;
        Write(DMACREQCONFIG, MasterConfig);
 
        ProgramResponse("M2P",
                       ((M2PParams->SrcBurst * 10) + 11),
                         M2PParams->SrcWidth,
                         M2PParams->DestWidth);
        /* Program the request generation register of the peripheral
           such that it raises the DMABREQ signal at different
           times during the programming of the channel for an M2P transfer
           Bits 15-8 indicates the number of clocks, it takes to raise
           the DMABREQ signal                                             */
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (10 << 8));

        M2PDp(CHANNEL,
              DestPeripheral,
              AddrGen(M0LOWADDRRANGE, M0HIGHADDRRANGE) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              M2PParams->LLIAddress,
              M2PParams->SrcMaster,
              M2PParams->DestMaster,
              M2PParams->SrcWidth,
              M2PParams->DestWidth,
              M2PParams->SrcInc,
              M2PParams->DestInc,
              M2PParams->SrcBurst,
              M2PParams->DestBurst,
              M2PParams->LLIMaster,
              M2PParams->Protection,
              M2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);
 
        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<10;x++)
          {
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
  
            /* Program the register to raise DMASREQ only */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), 10);
  
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
  
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            /* Program the register to raise DMABREQ only */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), (10 << 8));

            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));
          }
        }

        Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

        /* Initiate DMALSREQ request from the peripheral */
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (100 << 16));

        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Poll for the DMACSoftBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(DMACTrMemEn0, MEMORYRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      M2PParams++;
    }
    Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHDISABLE);
    TestCases++;
  }
}
/************************************ End *************************************/
