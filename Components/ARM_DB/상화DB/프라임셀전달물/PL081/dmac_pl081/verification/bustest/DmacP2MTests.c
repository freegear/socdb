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
-- File Name              : DmacP2MTests.c.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Peripheral-to-Memory Dma transfer test code.
-- --=========================================================================*/
 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** AddrGen                                    DmacCommon.c                ***/
/*** CheckStatus                                DmacCommon.c                ***/
/*** P2MDma                                     DmacCommon.c                ***/
/*** P2MSp                                      DmacCommon.c                ***/
/*** PeriphReg                                  DmacCommon.c                ***/
/*** Poll                                       DmacCommon.c                ***/
/*** ProgramResponse                            DmacCommon.c                ***/
/*** SrcPeriphNo                                DmacCommon.c                ***/
/*** Write                                      DmacCommon.c                ***/
/******************************************************************************/
 
void P2MTests()
{
  /*
    Summary: Peripheral-Memory Dma Tests
    ====================================
      o Peripheral-to-Memory(P2M) Dma transfers are tested using this function.
      o The P2M dma transfer test cases are as defined in the block verification
        document. All the test cases written here are used to test the given
        channel, defined by the "CHANNEL" in Dmac.h file.
        The master port for the source and destination of the dma transfer as
        well as the incrementing/non-incrementing nature of the address of the
        source/destination dma transfer are defined by SMASTER, DMASTER, SINCR
        and DINCR respectively. The source peripheral value will be
        internally generated if the constant "TESTCONFIGURATION" is set to
        "DEFAULT" in the Dmac.h file. If the constant "TESTCONFIGURATION", in
        Dmac.h file, is set to "USER", the source peripheral is same
        as defined by SPERIPH in Dmac.h file, for all the test cases. Other
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
    struct parameters *TestParams; };

  struct requestcycles {
    int SRC;
    int BRC;     };

  char *DefaultResponse;
  int i, j, k, x, y, z, OnethirdData, MaxValue;
  int32 SrcAddrMask, DestAddrMask;
  int32 MasterConfig, RegWrAddr;
  int32 WaitCycles, Response, SeedData, RSCount;
  int32 VlsbCount, ControlBase, SourceTxSize;
  int32 RetryResponses, SplitResponses, ErrorResponses;
  int32 AddrOrData, MemRegWrData, PeriphRegWrData;
  int32 AddrOrDataList[64];

  struct parameters *P2MParams;
   
  struct parameters SREQCases[10] = {
     SMASTER, DMASTER,  8,  8, SINC, DINC,  16,   1,  9, 0, 0, pbc, 0,
     SMASTER, DMASTER,  8, 16, SINC, DINC,  16,  16, 10, 0, 0, pbc, 0,
     SMASTER, DMASTER,  8, 32, SINC, DINC,  32,  32, 20, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16,  8, SINC, DINC,   8,   8, 11, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,   8,   1,  8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC,   8,   8, 16, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32,  8, SINC, DINC,   4,   4,  3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC,   8,   8, 12, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC,   4,   1,  5, 0, 0, pbc, 0,
           2, DMASTER, 32, 32, SINC, DINC, 256, 256,  9, 0, 0, pbc, 0};
  
  struct parameters BREQCases[10] = {
     SMASTER, DMASTER,  8,  8, SINC, DINC,  16,   1, 49, 0, 0, pbc, 0,
     SMASTER, DMASTER,  8, 16, SINC, DINC,  16,  16, 16, 0, 0, pbc, 0,
     SMASTER, DMASTER,  8, 32, SINC, DINC,  32,  32, 20, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16,  8, SINC, DINC,   8,   8,  3, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,   8,   1, 29, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC,   8,   8,  6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32,  8, SINC, DINC,   4,   4,  1, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC,   8,   8,  2, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC,   4,   1, 19, 0, 0, pbc, 0,
           2, DMASTER, 32, 32, SINC, DINC, 256, 256, 49, 0, 0, pbc, 0};
  
  struct parameters SBREQCases[10] = {
     SMASTER, DMASTER,  8,  8, SINC, DINC,  16,  16, 79, 0, 0, pbc, 0,
     SMASTER, DMASTER,  8, 16, SINC, DINC,  16,  16, 14, 0, 0, pbc, 0,
     SMASTER, DMASTER,  8, 32, SINC, DINC,  32,  32, 24, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16,  8, SINC, DINC,   8,   8,  7, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,   8,   8, 87, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 32, SINC, DINC,   8,   8,  6, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32,  8, SINC, DINC,   4,   4,  4, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 16, SINC, DINC,   8,   8,  8, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC,   4,   4, 31, 0, 0, pbc, 0,
           2, DMASTER, 32, 32, SINC, DINC, 256, 256, 31, 0, 0, pbc, 0};

  struct parameters P2MSPCases[10] = {
     SMASTER, DMASTER,  8,  8, SINC, DINC,  16,   1, 0, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,   8,   1, 0, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC,   4,   1, 0, 0, 0, pbc, 0,
           2, DMASTER, 32, 32, SINC, DINC, 256, 256, 0, 0, 0, pbc, 0};

  struct requestcycles SREQCycles[5] = {4, 0,
                                        3, 0,
                                        2, 0,
                                        1, 0,
                                        0, 0};

  struct requestcycles BREQCycles[5] = {0, 4,
                                        0, 3,
                                        0, 2,
                                        0, 1,
                                        0, 0};

  struct requestcycles SBREQCycles[11] = {4, 4,
                                          3, 4,
                                          3, 3,
                                          2, 4,
                                          2, 3,
                                          2, 2,
                                          1, 4,
                                          1, 3,
                                          1, 2,
                                          1, 1,
                                          0, 0};

  struct requestcycles REQ0Cycles[1] = {0, 0};

  struct requestcycles REQ4Cycles[2] = {0, 4, 0, 0};
  struct requestcycles REQ5Cycles[2] = {4, 0, 0, 0};
  struct requestcycles REQ6Cycles[2] = {(rand() % 15) + 1, (rand() % 15) + 1,
                                        0, 0};
  struct caselist P2MCaseList[23] = {
     "DMA_P2M_DMAC_1", SREQCases,
     "DMA_P2M_DMAC_2", BREQCases,
     "DMA_P2M_DMAC_3", SBREQCases, 
     "DMA_P2M_DMAC_4", SBREQCases,
     "DMA_P2M_DMAC_5", SBREQCases,
     "DMA_P2M_DMAC_6", SBREQCases,
     "DMA_P2M_SP_1",   P2MSPCases,
     "DMA_P2M_SP_2",   P2MSPCases,
     "DMA_P2M_SP_3",   P2MSPCases,
     "DMA_P2M_SP_4",   P2MSPCases,
     "DMA_P2M_SP_5",   P2MSPCases,
     "DMA_P2M_SP_6",   P2MSPCases,
     "DMA_P2M_SP_7",   P2MSPCases,
     "DMA_P2M_SP_8",   P2MSPCases,
     "DMA_P2M_SP_9",   P2MSPCases,
     "DMA_P2M_SP_10",  P2MSPCases,
     "DMA_P2M_SP_11",  P2MSPCases,
     "DMA_P2M_SP_12",  P2MSPCases,
     "DMA_P2M_SP_13",  P2MSPCases,
     "DMA_P2M_SP_14",  P2MSPCases,
     "DMA_P2M_SP_15",  P2MSPCases,
     "DMA_P2M_SP_16",  P2MSPCases,
     "ENDOFTEST",      SBREQCases};
  
  struct caselist *TestCases = P2MCaseList;
  
  struct requestcycles *PeriphRequests;

  int32 RequestRepeatRate;
  int   DataXfer, SReqAsserted, BReqAsserted;

  i = 0;
  j = 0;

  while (TestCases->CaseNumber != "ENDOFTEST")
  {
    sprintf(report,"Test No : %s",TestCases->CaseNumber);
    C(report);
   
    P2MParams = TestCases->TestParams;
    while (P2MParams->SrcMaster != 2)
    {
      /* The master of the Dmac with which the source peripheral and
         destination memory models will interact are configured
         in the Request Configuration (DMACREQCONFIG) register of the trickbox
         Please note that Memory1 is always fixed as the destination of the DMA
          and SrcPeripheral is fixed as the source peripheral.
         The master configuration for peripheral 0 is bit 2 in the register,
         for peripheral 1 it is bit 3 etc...upto bit 17 for peripheral 15
         Therefore the SMASTER bit is shifted by the SrcPeripheral value here.
         The destination memory is always memory 1. Its master configuration
         is specified in bit 1 of the master configuration register.        */

      if (P2MParams->SrcWidth == 8)
        SrcAddrMask = 0xFFFFFFFF;
      else if (P2MParams->SrcWidth == 16)
        SrcAddrMask = 0xFFFFFFFE;
      else
        SrcAddrMask = 0xFFFFFFFC;
 
      if (P2MParams->DestWidth == 8)
        DestAddrMask = 0xFFFFFFFF;
      else if (P2MParams->DestWidth == 16)
        DestAddrMask = 0xFFFFFFFE;
      else
        DestAddrMask = 0xFFFFFFFC;
 
      /* Generating the request signals at different timings as
         mentioned in the tables in the test document
         i.e., after enabling the channel /
               before enabling the channel but after configuring it/
               before configuring the channel but after setting it up
               etc....                                                */

      if (TestCases->CaseNumber == "DMA_P2M_DMAC_1")
      {
             PeriphRequests = SREQCycles;
      }
      else if (TestCases->CaseNumber == "DMA_P2M_DMAC_2")
      {
             PeriphRequests = BREQCycles;
      }
      else if (TestCases->CaseNumber == "DMA_P2M_DMAC_3")
      {
             PeriphRequests = SBREQCycles;
      }
      else if (TestCases->CaseNumber == "DMA_P2M_DMAC_4")
      {
             PeriphRequests = REQ4Cycles;
      }
      else if (TestCases->CaseNumber == "DMA_P2M_DMAC_5")
      {
             PeriphRequests = REQ5Cycles;
      }
      else if (TestCases->CaseNumber == "DMA_P2M_DMAC_6")
      {
             PeriphRequests = REQ6Cycles;
      }

      if ((TestCases->CaseNumber == "DMA_P2M_DMAC_1") ||
          (TestCases->CaseNumber == "DMA_P2M_DMAC_2") ||
          (TestCases->CaseNumber == "DMA_P2M_DMAC_3") ||
          (TestCases->CaseNumber == "DMA_P2M_DMAC_4") ||
          (TestCases->CaseNumber == "DMA_P2M_DMAC_5") ||
          (TestCases->CaseNumber == "DMA_P2M_DMAC_6"))
      {
        while ((PeriphRequests->SRC != 0) | (PeriphRequests->BRC != 0))
        {
          SrcPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
          Write(DMACREQCONFIG, MasterConfig);

          ProgramResponse("P2M",
                           P2MParams->TxSize,
                           P2MParams->SrcWidth,
                           P2MParams->DestWidth);

          RequestRepeatRate = (PeriphRequests->BRC << 8) +
                              (PeriphRequests->SRC);
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), RequestRepeatRate);
 
          P2MDma(CHANNEL,
                 SrcPeripheral,
                 AddrGen(PeriphLowAddress[SrcPeripheral],
                         PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                 AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
                 P2MParams->LLIAddress,
                 P2MParams->SrcMaster,
                 P2MParams->DestMaster,
                 P2MParams->SrcWidth,
                 P2MParams->DestWidth,
                 P2MParams->SrcInc,
                 P2MParams->DestInc,
                 P2MParams->SrcBurst,
                 P2MParams->DestBurst,
                 P2MParams->TxSize,
                 P2MParams->LLIMaster,
                 P2MParams->Protection,
                 P2MParams->Lock,
                 TCENABLE,
                 TCMASK,
                 ERRMASK);

          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          Write(DMACTrMemEn1, MEMORYRESET);
          PeriphRequests++;
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2M_SP_1")
      {
        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths      */

        if (P2MParams->SrcWidth == P2MParams->DestWidth)
        {
          for (x=1;x<5;x++)
          {
            /* Objective : Assertion of DMALSREQ */

            SrcPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
            Write(DMACREQCONFIG, MasterConfig);

            ProgramResponse("P2M",
                             1,
                             P2MParams->SrcWidth,
                             P2MParams->DestWidth);

            /* Program the request generation register of the peripheral
               such that it raises the DMALSREQ signal at different
               times during the programming of the channel for an P2M transfer
               Bits 23-16 indicates the number of clocks, it takes to raise
               the DMALSREQ signal                                           */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 16));

            P2MSp(CHANNEL,
                  SrcPeripheral,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
                  P2MParams->LLIAddress,
                  P2MParams->SrcMaster,
                  P2MParams->DestMaster,
                  P2MParams->SrcWidth,
                  P2MParams->DestWidth,
                  P2MParams->SrcInc,
                  P2MParams->DestInc,
                  P2MParams->SrcBurst,
                  P2MParams->DestBurst,
                  P2MParams->LLIMaster,
                  P2MParams->Protection,
                  P2MParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
            Write(DMACTrMemEn1, MEMORYRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2M_SP_2")
      {
        for (x=1;x<5;x++)
        {
          /* Objective : Assertion of DMALBREQ */

          SrcPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
          Write(DMACREQCONFIG, MasterConfig);

          ProgramResponse("P2M",
                           P2MParams->SrcBurst,
                           P2MParams->SrcWidth,
                           P2MParams->DestWidth);

          /* Program the request generation register of the peripheral
             such that it raises the DMALBREQ signal at different
             times during the programming of the channel for an P2M transfer
             Bits 31-24 indicates the number of clocks, it takes to raise
             the DMALBREQ signal                                           */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 24));

          P2MSp(CHANNEL,
                SrcPeripheral,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
                P2MParams->LLIAddress,
                P2MParams->SrcMaster,
                P2MParams->DestMaster,
                P2MParams->SrcWidth,
                P2MParams->DestWidth,
                P2MParams->SrcInc,
                P2MParams->DestInc,
                P2MParams->SrcBurst,
                P2MParams->DestBurst,
                P2MParams->LLIMaster,
                P2MParams->Protection,
                P2MParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          Write(DMACTrMemEn1, MEMORYRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2M_SP_3")
      {
        /* Objective : Assertion of DMASREQ followed by DMALSREQ */

        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths and
           when the source width is half of the destination width      */

        if ((P2MParams->SrcWidth == P2MParams->DestWidth) ||
            (P2MParams->SrcWidth == (2*P2MParams->DestWidth)))
        {
          for (x=1;x<5;x++)
          {

            SrcPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
            Write(DMACREQCONFIG, MasterConfig);

            ProgramResponse("P2M",
                             2,
                             P2MParams->SrcWidth,
                             P2MParams->DestWidth);

            /* Program the request generation register of the peripheral
               such that it raises the DMASREQ signal at different
               times during the programming of the channel for an P2M transfer
               Bits 7-0 indicates the number of clocks, it takes to raise
               the DMASREQ signal                                             */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));

            P2MSp(CHANNEL,
                  SrcPeripheral,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
                  P2MParams->LLIAddress,
                  P2MParams->SrcMaster,
                  P2MParams->DestMaster,
                  P2MParams->SrcWidth,
                  P2MParams->DestWidth,
                  P2MParams->SrcInc,
                  P2MParams->DestInc,
                  P2MParams->SrcBurst,
                  P2MParams->DestBurst,
                  P2MParams->LLIMaster,
                  P2MParams->Protection,
                  P2MParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Initiate DMALSREQ request from the peripheral */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((20*x) << 16));

            /* Only if an error is not returned, then the following
               registers can be polled. If an error response is
               returned, then the Dmac does not return CLR/TC signals.
               Therefore only the Channel enable bit is polled        */

            if ((SrcError == 0) && (DestError == 0))
            {
              /* Poll for the DMACSoftSReq bit to be reset
                 after the DMA transfer */
              Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));

              /* Poll for the DMACSoftLSReq bit to be reset
                 after the DMA transfer */
              Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));
            }

            /* Check that the Channel is disabled */
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
            Write(DMACTrMemEn1, MEMORYRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2M_SP_4")
      {
        /* Objective : Assertion of DMASREQ followed by DMALBREQ */

        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths      */

        if (P2MParams->SrcWidth == P2MParams->DestWidth)
        {
          for (x=1;x<5;x++)
          {
            SrcPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
            Write(DMACREQCONFIG, MasterConfig);

            ProgramResponse("P2M",
                            (P2MParams->SrcBurst + 1),
                             P2MParams->SrcWidth,
                             P2MParams->DestWidth);

            /* Program the request generation register of the peripheral
               such that it raises the DMASREQ signal at different
               times during the programming of the channel for an P2M transfer
               Bits 7-0 indicates the number of clocks, it takes to raise
               the DMASREQ signal                                             */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));

            P2MSp(CHANNEL,
                  SrcPeripheral,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
                  P2MParams->LLIAddress,
                  P2MParams->SrcMaster,
                  P2MParams->DestMaster,
                  P2MParams->SrcWidth,
                  P2MParams->DestWidth,
                  P2MParams->SrcInc,
                  P2MParams->DestInc,
                  P2MParams->SrcBurst,
                  P2MParams->DestBurst,
                  P2MParams->LLIMaster,
                  P2MParams->Protection,
                  P2MParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Initiate DMALBREQ request from the peripheral */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((20*x) << 24));

            /* Only if an error is not returned, then the following
               registers can be polled. If an error response is
               returned, then the Dmac does not return CLR/TC signals.
               Therefore only the Channel enable bit is polled        */

            if ((SrcError == 0) && (DestError == 0))
            {
              /* Poll for the DMACSoftSReq bit to be reset
                 after the DMA transfer */
              Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));

              /* Poll for the DMACSoftLBReq bit to be reset
                 after the DMA transfer */
              Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));
            }

            /* Check that the Channel is disabled */
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
            Write(DMACTrMemEn1, MEMORYRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2M_SP_5")
      {
        /* Objective : Assertion of DMABREQ followed by DMALSREQ */

        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths      */

        if (P2MParams->SrcWidth == P2MParams->DestWidth)
        {
          for (x=1;x<5;x++)
          {
            SrcPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
            Write(DMACREQCONFIG, MasterConfig);

            ProgramResponse("P2M",
                            (P2MParams->SrcBurst + 1),
                             P2MParams->SrcWidth,
                             P2MParams->DestWidth);

            /* Program the request generation register of the peripheral
               such that it raises the DMABREQ signal at different
               times during the programming of the channel for an P2M transfer
               Bits 15-8 indicates the number of clocks, it takes to raise
               the DMABREQ signal                                             */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));

            P2MSp(CHANNEL,
                  SrcPeripheral,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
                  P2MParams->LLIAddress,
                  P2MParams->SrcMaster,
                  P2MParams->DestMaster,
                  P2MParams->SrcWidth,
                  P2MParams->DestWidth,
                  P2MParams->SrcInc,
                  P2MParams->DestInc,
                  P2MParams->SrcBurst,
                  P2MParams->DestBurst,
                  P2MParams->LLIMaster,
                  P2MParams->Protection,
                  P2MParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Initiate DMALSREQ request from the peripheral */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((20*x) << 16));

            /* Only if an error is not returned, then the following
               registers can be polled. If an error response is
               returned, then the Dmac does not return CLR/TC signals.
               Therefore only the Channel enable bit is polled        */

            if ((SrcError == 0) && (DestError == 0))
            {
              /* Poll for the DMACSoftBReq bit to be reset
                 after the DMA transfer */
              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

              /* Poll for the DMACSoftLSReq bit to be reset
                 after the DMA transfer */
              Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));
            }

            /* Check that the Channel is disabled */
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
            Write(DMACTrMemEn1, MEMORYRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2M_SP_6")
      {
        for (x=1;x<5;x++)
        {
          /* Objective : Assertion of DMABREQ followed by DMALBREQ */

          SrcPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
          Write(DMACREQCONFIG, MasterConfig);

          ProgramResponse("P2M",
                          (P2MParams->SrcBurst * 2),
                           P2MParams->SrcWidth,
                           P2MParams->DestWidth);

          /* Program the request generation register of the peripheral
             such that it raises the DMABREQ signal at different
             times during the programming of the channel for an P2M transfer
             Bits 15-8 indicates the number of clocks, it takes to raise
             the DMABREQ signal                                             */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));

          P2MSp(CHANNEL,
                SrcPeripheral,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
                P2MParams->LLIAddress,
                P2MParams->SrcMaster,
                P2MParams->DestMaster,
                P2MParams->SrcWidth,
                P2MParams->DestWidth,
                P2MParams->SrcInc,
                P2MParams->DestInc,
                P2MParams->SrcBurst,
                P2MParams->DestBurst,
                P2MParams->LLIMaster,
                P2MParams->Protection,
                P2MParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

          /* Initiate DMALBREQ request from the peripheral */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((20*x) << 24));

          /* Only if an error is not returned, then the following
             registers can be polled. If an error response is
             returned, then the Dmac does not return CLR/TC signals.
             Therefore only the Channel enable bit is polled        */

          if ((SrcError == 0) && (DestError == 0))
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

            /* Poll for the DMACSoftLBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          /* Check that the Channel is disabled */
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          Write(DMACTrMemEn1, MEMORYRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2M_SP_7")
      {
        /* Objective : Assertion of 2 DMASREQ followed by DMALSREQ. */

        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths      */

        if (P2MParams->SrcWidth == P2MParams->DestWidth)
        {
          for (x=1;x<5;x++)
          {
            SrcPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
            Write(DMACREQCONFIG, MasterConfig);

            ProgramResponse("P2M",
                             3,
                             P2MParams->SrcWidth,
                             P2MParams->DestWidth);

            /* Program the request generation register of the peripheral
               such that it raises the DMASREQ signal at different
               times during the programming of the channel for an P2M transfer
               Bits 7-0 indicates the number of clocks, it takes to raise
               the DMASREQ signal                                             */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));

            P2MSp(CHANNEL,
                  SrcPeripheral,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
                  P2MParams->LLIAddress,
                  P2MParams->SrcMaster,
                  P2MParams->DestMaster,
                  P2MParams->SrcWidth,
                  P2MParams->DestWidth,
                  P2MParams->SrcInc,
                  P2MParams->DestInc,
                  P2MParams->SrcBurst,
                  P2MParams->DestBurst,
                  P2MParams->LLIMaster,
                  P2MParams->Protection,
                  P2MParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer.
               After that change the register values immediately so that
               there are 2 SREQ followed by an LSREQ as required */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            }
            else
            {
              WaitLoop(4 * 10 * 16);
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            }

            /* Initiate DMALSREQ request from the peripheral */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((20*x) << 16));

            /* Only if an error is not returned, then the following
               registers can be polled. If an error response is
               returned, then the Dmac does not return CLR/TC signals.
               Therefore only the Channel enable bit is polled        */

            if ((SrcError == 0) && (DestError == 0))
            {
              /* Poll for the DMACSoftSReq bit to be reset
                 after the DMA transfer */
              Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
  
              /* Poll for the DMACSoftLSReq bit to be reset
                 after the DMA transfer */
              Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));
            }

            /* Check that the Channel is disabled */
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
            Write(DMACTrMemEn1, MEMORYRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2M_SP_8")
      {
        for (x=1;x<5;x++)
        {
          /* Objective : Assertion of 2 DMABREQ followed by DMALBREQ. */

          SrcPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
          Write(DMACREQCONFIG, MasterConfig);

          ProgramResponse("P2M",
                          (P2MParams->SrcBurst * 3),
                           P2MParams->SrcWidth,
                           P2MParams->DestWidth);

          /* Program the request generation register of the peripheral
             such that it raises the DMABREQ signal at different
             times during the programming of the channel for an P2M transfer
             Bits 15-8 indicates the number of clocks, it takes to raise
             the DMABREQ signal                                             */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));

          P2MSp(CHANNEL,
                SrcPeripheral,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
                P2MParams->LLIAddress,
                P2MParams->SrcMaster,
                P2MParams->DestMaster,
                P2MParams->SrcWidth,
                P2MParams->DestWidth,
                P2MParams->SrcInc,
                P2MParams->DestInc,
                P2MParams->SrcBurst,
                P2MParams->DestBurst,
                P2MParams->LLIMaster,
                P2MParams->Protection,
                P2MParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
          /* Poll for the DMACSoftBReq bit to be reset
             after the DMA transfer.
             After that change the register values immediately so that
             there are 2 BREQ followed by an LBREQ as required */
          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

          if ((SrcError == 0) && (DestError == 0))
          {
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          }
          else
          {
            WaitLoop(4 * P2MParams->SrcBurst * 16);
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          }

          /* Initiate DMALBREQ request from the peripheral */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((20*x) << 24));

          /* Only if an error is not returned, then the following
             registers can be polled. If an error response is
             returned, then the Dmac does not return CLR/TC signals.
             Therefore only the Channel enable bit is polled        */

          if ((SrcError == 0) && (DestError == 0))
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

            /* Poll for the DMACSoftLBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          /* Check that the Channel is disabled */
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          Write(DMACTrMemEn1, MEMORYRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2M_SP_9")
      {
        /* Objective : Assertion of multiple(11) DMASREQ and DMALSREQ
                       to complete the DMA transfer                   */

        SrcPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
        Write(DMACREQCONFIG, MasterConfig);

        ProgramResponse("P2M",
                         12,
                         P2MParams->SrcWidth,
                         P2MParams->DestWidth);

        /* Program the request generation register of the peripheral
           such that it raises the DMASREQ signal at different
           times during the programming of the channel for an P2M transfer
           Bits 7-0 indicates the number of clocks, it takes to raise
           the DMASREQ signal                                             */
        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), 10);

        P2MSp(CHANNEL,
              SrcPeripheral,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
              P2MParams->LLIAddress,
              P2MParams->SrcMaster,
              P2MParams->DestMaster,
              P2MParams->SrcWidth,
              P2MParams->DestWidth,
              P2MParams->SrcInc,
              P2MParams->DestInc,
              P2MParams->SrcBurst,
              P2MParams->DestBurst,
              P2MParams->LLIMaster,
              P2MParams->Protection,
              P2MParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<10;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
        }
        else
        {
          WaitLoop(4 * 10 * 16);
          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
        }

        /* Initiate DMALSREQ request from the peripheral */
        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (100 << 16));

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));

          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(DMACTrMemEn1, MEMORYRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2M_SP_10")
      {
        /* Objective : Assertion of multiple(12) DMASREQ and DMALBREQ
                       to complete the DMA transfer                   */

        SrcPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
        Write(DMACREQCONFIG, MasterConfig);

        ProgramResponse("P2M",
                        (P2MParams->SrcBurst + 12),
                         P2MParams->SrcWidth,
                         P2MParams->DestWidth);

        /* Program the request generation register of the peripheral
           such that it raises the DMASREQ signal at different
           times during the programming of the channel for an P2M transfer
           Bits 7-0 indicates the number of clocks, it takes to raise
           the DMASREQ signal                                             */
        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), 10);

        P2MSp(CHANNEL,
              SrcPeripheral,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
              P2MParams->LLIAddress,
              P2MParams->SrcMaster,
              P2MParams->DestMaster,
              P2MParams->SrcWidth,
              P2MParams->DestWidth,
              P2MParams->SrcInc,
              P2MParams->DestInc,
              P2MParams->SrcBurst,
              P2MParams->DestBurst,
              P2MParams->LLIMaster,
              P2MParams->Protection,
              P2MParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<11;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
        }
        else
        {
          WaitLoop(4 * 10 * 16);
          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
        }

        /* Initiate DMALBREQ request from the peripheral */
        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (100 << 24));

        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));

          /* Poll for the DMACSoftLBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(DMACTrMemEn1, MEMORYRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2M_SP_11")
      {
        /* Objective : Assertion of multiple(10) DMABREQ and DMALSREQ
                       to complete the DMA transfer                   */

        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths      */

        if (P2MParams->SrcWidth == P2MParams->DestWidth)
        {
          SrcPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
          Write(DMACREQCONFIG, MasterConfig);

          ProgramResponse("P2M",
                         ((P2MParams->SrcBurst * 10) + 1),
                           P2MParams->SrcWidth,
                           P2MParams->DestWidth);

          /* Program the request generation register of the peripheral
             such that it raises the DMABREQ signal at different
             times during the programming of the channel for an P2M transfer
             Bits 15-8 indicates the number of clocks, it takes to raise
             the DMABREQ signal                                             */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (10 << 8));

          P2MSp(CHANNEL,
                SrcPeripheral,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
                P2MParams->LLIAddress,
                P2MParams->SrcMaster,
                P2MParams->DestMaster,
                P2MParams->SrcWidth,
                P2MParams->DestWidth,
                P2MParams->SrcInc,
                P2MParams->DestInc,
                P2MParams->SrcBurst,
                P2MParams->DestBurst,
                P2MParams->LLIMaster,
                P2MParams->Protection,
                P2MParams->Lock,
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
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
            }

            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          }
          else
          {
            WaitLoop(4 * P2MParams->SrcBurst * 16);
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          }

          /* Initiate DMALSREQ request from the peripheral */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (100 << 16));

          /* Only if an error is not returned, then the following
             registers can be polled. If an error response is
             returned, then the Dmac does not return CLR/TC signals.
             Therefore only the Channel enable bit is polled        */

          if ((SrcError == 0) && (DestError == 0))
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

            /* Poll for the DMACSoftLSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          /* Check that the Channel is disabled */
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          Write(DMACTrMemEn1, MEMORYRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2M_SP_12")
      {
        /* Objective : Assertion of multiple(10) DMABREQ and DMALBREQ
                       to complete the DMA transfer                   */

        SrcPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
        Write(DMACREQCONFIG, MasterConfig);

        ProgramResponse("P2M",
                        (P2MParams->SrcBurst * 11),
                         P2MParams->SrcWidth,
                         P2MParams->DestWidth);

        /* Program the request generation register of the peripheral
           such that it raises the DMABREQ signal at different
           times during the programming of the channel for an P2M transfer
           Bits 15-8 indicates the number of clocks, it takes to raise
           the DMABREQ signal                                             */
        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (10 << 8));

        P2MSp(CHANNEL,
              SrcPeripheral,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
              P2MParams->LLIAddress,
              P2MParams->SrcMaster,
              P2MParams->DestMaster,
              P2MParams->SrcWidth,
              P2MParams->DestWidth,
              P2MParams->SrcInc,
              P2MParams->DestInc,
              P2MParams->SrcBurst,
              P2MParams->DestBurst,
              P2MParams->LLIMaster,
              P2MParams->Protection,
              P2MParams->Lock,
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
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
        }
        else
        {
          WaitLoop(4 * P2MParams->SrcBurst * 16);
          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
        }

        /* Initiate DMALBREQ request from the peripheral */
        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (100 << 24));

        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Poll for the DMACSoftBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

          /* Poll for the DMACSoftLBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(DMACTrMemEn1, MEMORYRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2M_SP_13")
      {
        /* Objective : Assertion of multiple(10) DMABREQ followed by
                       multiple (10) DMASREQ and DMALSREQ to complete
                       the DMA transfer                               */

        SrcPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
        Write(DMACREQCONFIG, MasterConfig);

        ProgramResponse("P2M",
                       ((P2MParams->SrcBurst * 10) + 11),
                         P2MParams->SrcWidth,
                         P2MParams->DestWidth);

        /* Program the request generation register of the peripheral
           such that it raises the DMABREQ signal at different
           times during the programming of the channel for an P2M transfer
           Bits 15-8 indicates the number of clocks, it takes to raise
           the DMABREQ signal                                             */
        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (10 << 8));

        P2MSp(CHANNEL,
              SrcPeripheral,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
              P2MParams->LLIAddress,
              P2MParams->SrcMaster,
              P2MParams->DestMaster,
              P2MParams->SrcWidth,
              P2MParams->DestWidth,
              P2MParams->SrcInc,
              P2MParams->DestInc,
              P2MParams->SrcBurst,
              P2MParams->DestBurst,
              P2MParams->LLIMaster,
              P2MParams->Protection,
              P2MParams->Lock,
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
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

          /* Program the register to raise DMASREQ only */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), 10);

          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

          for (x=0;x<10;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
        }
        else
        {
          WaitLoop(4 * (10 + P2MParams->SrcBurst) * 16);
          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
        }

        /* Initiate DMALSREQ request from the peripheral */
        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (100 << 16));

        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */
        if ((SrcError == 0) && (DestError == 0))
        {
          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));

          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(DMACTrMemEn1, MEMORYRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2M_SP_13")
      {
        /* Objective : Assertion of multiple(12) DMASREQ followed by
                       multiple(10) DMABREQ and DMALBREQ
                       to complete the DMA transfer                  */

        SrcPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
        Write(DMACREQCONFIG, MasterConfig);

        ProgramResponse("P2M",
                       ((P2MParams->SrcBurst * 11) + 10),
                         P2MParams->SrcWidth,
                         P2MParams->DestWidth);

        /* Program the request generation register of the peripheral
           such that it raises the DMASREQ signal at different
           times during the programming of the channel for an P2M transfer
           Bits 7-0 indicates the number of clocks, it takes to raise
           the DMASREQ signal                                             */
        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), 10);

        P2MSp(CHANNEL,
              SrcPeripheral,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
              P2MParams->LLIAddress,
              P2MParams->SrcMaster,
              P2MParams->DestMaster,
              P2MParams->SrcWidth,
              P2MParams->DestWidth,
              P2MParams->SrcInc,
              P2MParams->DestInc,
              P2MParams->SrcBurst,
              P2MParams->DestBurst,
              P2MParams->LLIMaster,
              P2MParams->Protection,
              P2MParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<12;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

          /* Program the register to raise DMABREQ only */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (10 << 8));

          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));

          for (x=0;x<10;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
        }
        else
        {
          WaitLoop(4 * (10 + P2MParams->SrcBurst) * 16);
          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
        }

        /* Initiate DMALBREQ request from the peripheral */
        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (100 << 24));

        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Poll for the DMACSoftBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

          /* Poll for the DMACSoftLBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(DMACTrMemEn1, MEMORYRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2M_SP_14")
      {
        /* Objective : Assertion of alternate DMASREQ and DMABREQ followed by
                       DMALBREQ to complete the DMA transfer                  */

        SrcPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
        Write(DMACREQCONFIG, MasterConfig);

        ProgramResponse("P2M",
                       ((P2MParams->SrcBurst * 12) + 12),
                         P2MParams->SrcWidth,
                         P2MParams->DestWidth);

        /* Program the request generation register of the peripheral
           such that it raises the DMASREQ signal at different
           times during the programming of the channel for an P2M transfer
           Bits 7-0 indicates the number of clocks, it takes to raise
           the DMASREQ signal                                             */
        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), 10);

        P2MSp(CHANNEL,
              SrcPeripheral,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
              P2MParams->LLIAddress,
              P2MParams->SrcMaster,
              P2MParams->DestMaster,
              P2MParams->SrcWidth,
              P2MParams->DestWidth,
              P2MParams->SrcInc,
              P2MParams->DestInc,
              P2MParams->SrcBurst,
              P2MParams->DestBurst,
              P2MParams->LLIMaster,
              P2MParams->Protection,
              P2MParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<11;x++)
          {
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
  
            /* Program the register to raise DMABREQ only */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (10 << 8));
  
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
  
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
  
            /* Program the register to raise DMASREQ only */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), 10);
  
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
        }
        else
        {
          WaitLoop(4 * (10 + P2MParams->SrcBurst) * 16);
          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
        }

        /* Initiate DMALBREQ request from the peripheral */
        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (100 << 24));

        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));

          /* Poll for the DMACSoftLBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(DMACTrMemEn1, MEMORYRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2M_SP_15")
      {
        /* Objective : Assertion of alternate DMABREQ and DMASREQ followed by
                       DMALSREQ to complete the DMA transfer                  */

        SrcPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) | (DMASTER << 1);
        Write(DMACREQCONFIG, MasterConfig);

        ProgramResponse("P2M",
                       ((P2MParams->SrcBurst * 12) + 12),
                         P2MParams->SrcWidth,
                         P2MParams->DestWidth);

        /* Program the request generation register of the peripheral
           such that it raises the DMABREQ signal at different
           times during the programming of the channel for an P2M transfer
           Bits 15-8 indicates the number of clocks, it takes to raise
           the DMABREQ signal                                             */
        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (10 << 8));

        P2MSp(CHANNEL,
              SrcPeripheral,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(M1LOWADDRRANGE, M1HIGHADDRRANGE) & DestAddrMask,
              P2MParams->LLIAddress,
              P2MParams->SrcMaster,
              P2MParams->DestMaster,
              P2MParams->SrcWidth,
              P2MParams->DestWidth,
              P2MParams->SrcInc,
              P2MParams->DestInc,
              P2MParams->SrcBurst,
              P2MParams->DestBurst,
              P2MParams->LLIMaster,
              P2MParams->Protection,
              P2MParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);
        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<11;x++)
          {
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Program the register to raise DMASREQ only */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), 10);

            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Program the register to raise DMABREQ only */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (10 << 8));

            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
        }
        else
        {
          WaitLoop(4 * (10 + P2MParams->SrcBurst) * 16);
          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
        }

        /* Initiate DMALSREQ request from the peripheral */
        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (100 << 16));

        /* Only if an error is not returned, then the following
           registers can be polled. If an error response is
           returned, then the Dmac does not return CLR/TC signals.
           Therefore only the Channel enable bit is polled        */

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Poll for the DMACSoftBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));
        }
 
        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(DMACTrMemEn1, MEMORYRESET);
      }
      P2MParams++;
    }
    Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHDISABLE);
    TestCases++;
  }
}
/************************************ End *************************************/
