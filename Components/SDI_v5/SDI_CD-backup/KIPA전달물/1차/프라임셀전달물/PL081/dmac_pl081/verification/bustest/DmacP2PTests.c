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
-- File Name              : DmacP2PTests.c.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           Peripheral-to-Peripheral Dma transfer test code.
-- --=========================================================================*/
 
/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** debug_info                                 DmacCommon.c                ***/
/*** AddrGen                                    DmacCommon.c                ***/
/*** CheckStatus                                DmacCommon.c                ***/
/*** DestPeriphNo                               DmacCommon.c                ***/
/*** P2PDma                                     DmacCommon.c                ***/
/*** P2PDp                                      DmacCommon.c                ***/
/*** P2PSp                                      DmacCommon.c                ***/
/*** PeriphReg                                  DmacCommon.c                ***/
/*** Poll                                       DmacCommon.c                ***/
/*** ProgramResponse                            DmacCommon.c                ***/
/*** SrcPeriphNo                                DmacCommon.c                ***/
/*** Write                                      DmacCommon.c                ***/
/******************************************************************************/

void P2PTests()
{
  /*
    Summary: Peripheral-Peripheral Dma Tests
    ====================================
      o Peripheral-to-Peripheral(P2P) Dma transfers are tested using this
        function.
      o The P2P dma transfer test cases are as defined in the block verification
        document. All the test cases written here are used to test the given
        channel, defined by the "CHANNEL" in Dmac.h file.
        The master port for the source and destination of the dma transfer as
        well as the incrementing/non-incrementing nature of the address of the
        source/destination dma transfer are defined by SMASTER, DMASTER, SINCR
        and DINCR respectively. The source and destination peripheral values
        will be internally generated if the constant "TESTCONFIGURATION" is
        set to "DEFAULT" in the Dmac.h file. If the constant
        "TESTCONFIGURATION", in Dmac.h file, is set to "USER", the source and
        destination peripherals are same as defined by SPERIPH and DPERIPH
        respectively, in Dmac.h file, for all the test cases. Other
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
  int DataXfers;

  struct parameters *P2PParams;
 
  /* The parameters corresponds to the list of configurations defined for
     P2P test cases, with Dmac as the flow controller, in the block
     verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters BREQCases[4] = {
     SMASTER, DMASTER,  8,  8, SINC, DINC,  16,  16, 49, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,   8,   4, 49, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC,   4,   1, 49, 0, 0, pbc, 0,
           2, DMASTER, 32, 32, SINC, DINC, 256, 256,  1, 0, 0, pbc, 0};
 
  /* The parameters corresponds to the list of configurations defined for
     P2P test cases, with source/destination peripheral as the flow controller,
     in the block verification document.
     The source/destination master value as '2' indicates the end of the
     configurations, as in the last element of the parameters' list.       */
  struct parameters P2PPeriphCases[10] = {
     SMASTER, DMASTER,  8,  8, SINC, DINC,  16,   1, 0, 0, 0, pbc, 0,
     SMASTER, DMASTER, 16, 16, SINC, DINC,   8,   1, 0, 0, 0, pbc, 0,
     SMASTER, DMASTER, 32, 32, SINC, DINC,   4,   1, 0, 0, 0, pbc, 0,
           2, DMASTER, 32, 32, SINC, DINC, 256, 256, 0, 0, 0, pbc, 0};

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

  /* Test No : DMA_P2P_DMAC_1
     Objective : Source DMASREQ followed by Destination DMABREQ  */

  struct requestcycles SrcREQ1Cycles[11] = {4, 0,
                                            3, 0,
                                            3, 0,
                                            2, 0,
                                            2, 0,
                                            2, 0,
                                            1, 0,
                                            1, 0,
                                            1, 0,
                                            1, 0,
                                            0, 0};

  struct requestcycles DstREQ1Cycles[11] = {0, 5,
                                            0, 5,
                                            0, 4,
                                            0, 5,
                                            0, 4,
                                            0, 3,
                                            0, 5,
                                            0, 4,
                                            0, 3,
                                            0, 2,
                                            0, 0};

  /* Test No : DMA_P2P_DMAC_1A
     Objective : Simultaneous assertion of Source DMASREQ and
                 Destination DMABREQ                           */

  struct requestcycles SrcREQ1ACycles[5] = {4, 0,
                                            3, 0,
                                            2, 0,
                                            1, 0,
                                            0, 0};

  struct requestcycles DstREQ1ACycles[5] = {0, 4,
                                            0, 3,
                                            0, 2,
                                            0, 1,
                                            0, 0};

  /* Test No : DMA_P2P_DMAC_2
     Objective : Destination DMABREQ followed by Source DMASREQ */

  struct requestcycles SrcREQ2Cycles[11] = {5, 0,
                                            5, 0,
                                            4, 0,
                                            5, 0,
                                            4, 0,
                                            3, 0,
                                            5, 0,
                                            4, 0,
                                            3, 0,
                                            2, 0,
                                            0, 0};

  struct requestcycles DstREQ2Cycles[11] = {0, 4,
                                            0, 3,
                                            0, 3,
                                            0, 2,
                                            0, 2,
                                            0, 2,
                                            0, 1,
                                            0, 1,
                                            0, 1,
                                            0, 1,
                                            0, 0};

  /* Test No : DMA_P2P_DMAC_3
     Objective : Source DMABREQ followed by Destination DMABREQ */

  struct requestcycles SrcREQ3Cycles[11] = {0, 4,
                                            0, 3,
                                            0, 3,
                                            0, 2,
                                            0, 2,
                                            0, 2,
                                            0, 1,
                                            0, 1,
                                            0, 1,
                                            0, 1,
                                            0, 0};

  struct requestcycles DstREQ3Cycles[11] = {0, 5,
                                            0, 5,
                                            0, 4,
                                            0, 5,
                                            0, 4,
                                            0, 3,
                                            0, 5,
                                            0, 4,
                                            0, 3,
                                            0, 2,
                                            0, 0};

  /* Test No : DMA_P2P_DMAC_4
     Objective : Simultaneous assertion of Source DMABREQ and
                 Destination DMABREQ                          */

  struct requestcycles SrcREQ4Cycles[5] = {0, 4,
                                           0, 3,
                                           0, 2,
                                           0, 1,
                                           0, 0};

  struct requestcycles DstREQ4Cycles[5] = {0, 4,
                                           0, 3,
                                           0, 2,
                                           0, 1,
                                           0, 0};

  /* Test No : DMA_P2P_DMAC_5
     Objective : Destination DMABREQ followed by Source DMABREQ */

  struct requestcycles SrcREQ5Cycles[11] = {0, 5,
                                            0, 5,
                                            0, 4,
                                            0, 5,
                                            0, 4,
                                            0, 3,
                                            0, 5,
                                            0, 4,
                                            0, 3,
                                            0, 2,
                                            0, 0};

  struct requestcycles DstREQ5Cycles[11] = {0, 4,
                                            0, 3,
                                            0, 3,
                                            0, 2,
                                            0, 2,
                                            0, 2,
                                            0, 1,
                                            0, 1,
                                            0, 1,
                                            0, 1,
                                            0, 0};

  /* Test No : DMA_P2P_DMAC_6
     Objective : Assertion of Source DMASREQ followed by
                 Source DMABREQ followed by Destination DMABREQ */

  struct requestcycles SrcREQ6Cycles[16] = {4, 5,
                                            3, 5,
                                            3, 4,
                                            3, 4,
                                            2, 5,
                                            2, 4,
                                            2, 4,
                                            2, 3,
                                            2, 3,
                                            1, 5,
                                            1, 3,
                                            1, 3,
                                            1, 3,
                                            1, 2,
                                            1, 2,
                                            0, 0};

  struct requestcycles DstREQ6Cycles[16] = {0, 6,
                                            0, 6,
                                            0, 6,
                                            0, 5,
                                            0, 5,
                                            0, 6,
                                            0, 5,
                                            0, 5,
                                            0, 4,
                                            0, 6,
                                            0, 6,
                                            0, 5,
                                            0, 4,
                                            0, 4,
                                            0, 3,
                                            0, 0};

  /* Test No : DMA_P2P_DMAC_7
     Objective : Simultaneous assertion of Source DMASREQ,
                 Source DMABREQ and Destination DMABREQ    */

  struct requestcycles SrcREQ7Cycles[5] = {4, 4,
                                           3, 3,
                                           2, 2,
                                           1, 1,
                                           0, 0};

  struct requestcycles DstREQ7Cycles[5] = {0, 4,
                                           0, 3,
                                           0, 2,
                                           0, 1,
                                           0, 0};

  /* Test No : DMA_P2P_DMAC_8
     Objective : Assertion of Destination DMABREQ followed by
                 Source DMASREQ followed by Source DMABREQ    */

  struct requestcycles SrcREQ8Cycles[17] = {5, 6,
                                            5, 6,
                                            4, 6,
                                            4, 5,
                                            5, 6,
                                            4, 6,
                                            4, 5,
                                            3, 5,
                                            3, 4,
                                            5, 6,
                                            4, 6,
                                            4, 5,
                                            3, 5,
                                            3, 4,
                                            2, 4,
                                            2, 3,
                                            0, 0};

  struct requestcycles DstREQ8Cycles[17] = {0, 4,
                                            0, 3,
                                            0, 3,
                                            0, 3,
                                            0, 5,
                                            0, 2,
                                            0, 2,
                                            0, 2,
                                            0, 2,
                                            0, 2,
                                            0, 1,
                                            0, 1,
                                            0, 1,
                                            0, 1,
                                            0, 1,
                                            0, 1,
                                            0, 0};

  /* Test No : DMA_P2P_DMAC_9
     Objective : Assertion of a combination of Source DMASREQ,
                 Source DMABREQ and Destination DMABREQ        */

  struct requestcycles SrcREQ9Cycles[2] = {0, (rand() % 15) + 1,
                                          0, 0};

  struct requestcycles DstREQ9Cycles[2] = {0, (rand() % 15) + 1,
                                          0, 0};

  /* Test No : DMA_P2P_DMAC_10
     Objective : Assertion of a combination of Source DMASREQ,
                 Source DMABREQ and Destination DMABREQ        */

  struct requestcycles SrcREQ10Cycles[2] = {(rand() % 15) + 1, 0,
                                          0, 0};

  struct requestcycles DstREQ10Cycles[2] = {0, (rand() % 15) + 1,
                                          0, 0};

  /* Test No : DMA_P2P_DMAC_11
     Objective : Random sequence of Source DMASRQ,
                 Source DMABREQ, Destination DMASREQ and
                 Destination DMABREQ assertion           */

  struct requestcycles SrcREQ11Cycles[2] = {(rand() % 15) + 1,
                                            (rand() % 15) + 1,
                                            0, 0};

  struct requestcycles DstREQ11Cycles[2] = {0, (rand() % 15) + 1,
                                            0, 0};

  /* The test cases and their corresponding parameters are listed here.
     The user can modify the 'caselist' to run the specific test cases.
     e.g., if the user wants to test only the first test case, the last
     element "ENDOFTEST" of the array may be put next to the DMAC_1 test */
  struct caselist P2PCaseList[85] = {
    "DMA_P2P_DMAC_1",  BREQCases,
    "DMA_P2P_DMAC_1A", BREQCases,
    "DMA_P2P_DMAC_2",  BREQCases,
    "DMA_P2P_DMAC_3",  BREQCases,
    "DMA_P2P_DMAC_4",  BREQCases,
    "DMA_P2P_DMAC_5",  BREQCases,
    "DMA_P2P_DMAC_6",  BREQCases,
    "DMA_P2P_DMAC_7",  BREQCases,
    "DMA_P2P_DMAC_8",  BREQCases,
    "DMA_P2P_DMAC_9",  BREQCases,
    "DMA_P2P_DMAC_10", BREQCases,
    "DMA_P2P_DMAC_11", BREQCases,
    "DMA_P2P_SP_1",    P2PPeriphCases,
    "DMA_P2P_SP_2",    P2PPeriphCases,
    "DMA_P2P_SP_3",    P2PPeriphCases,
    "DMA_P2P_SP_4",    P2PPeriphCases,
    "DMA_P2P_SP_5",    P2PPeriphCases,
    "DMA_P2P_SP_6",    P2PPeriphCases,
    "DMA_P2P_SP_7",    P2PPeriphCases,
    "DMA_P2P_SP_8",    P2PPeriphCases,
    "DMA_P2P_SP_9",    P2PPeriphCases,
    "DMA_P2P_SP_10",   P2PPeriphCases,
    "DMA_P2P_SP_11",   P2PPeriphCases,
    "DMA_P2P_SP_12",   P2PPeriphCases,
    "DMA_P2P_SP_13",   P2PPeriphCases,
    "DMA_P2P_SP_14",   P2PPeriphCases,
    "DMA_P2P_SP_15",   P2PPeriphCases,
    "DMA_P2P_SP_16",   P2PPeriphCases,
    "DMA_P2P_SP_17",   P2PPeriphCases,
    "DMA_P2P_SP_18",   P2PPeriphCases,
    "DMA_P2P_SP_19",   P2PPeriphCases,
    "DMA_P2P_SP_20",   P2PPeriphCases,
    "DMA_P2P_SP_21",   P2PPeriphCases,
    "DMA_P2P_SP_22",   P2PPeriphCases,
    "DMA_P2P_SP_23",   P2PPeriphCases,
    "DMA_P2P_SP_24",   P2PPeriphCases,
    "DMA_P2P_SP_25",   P2PPeriphCases,
    "DMA_P2P_SP_26",   P2PPeriphCases,
    "DMA_P2P_DP_1",    P2PPeriphCases,
    "DMA_P2P_DP_2",    P2PPeriphCases,
    "DMA_P2P_DP_3",    P2PPeriphCases,
    "DMA_P2P_DP_4",    P2PPeriphCases,
    "DMA_P2P_DP_5",    P2PPeriphCases,
    "DMA_P2P_DP_6",    P2PPeriphCases,
    "DMA_P2P_DP_7",    P2PPeriphCases,
    "DMA_P2P_DP_8",    P2PPeriphCases,
    "DMA_P2P_DP_9",    P2PPeriphCases,
    "DMA_P2P_DP_10",   P2PPeriphCases,
    "DMA_P2P_DP_11",   P2PPeriphCases,
    "DMA_P2P_DP_12",   P2PPeriphCases,
    "DMA_P2P_DP_13",   P2PPeriphCases,
    "DMA_P2P_DP_14",   P2PPeriphCases,
    "DMA_P2P_DP_15",   P2PPeriphCases,
    "DMA_P2P_DP_16",   P2PPeriphCases,
    "DMA_P2P_DP_17",   P2PPeriphCases,
    "DMA_P2P_DP_18",   P2PPeriphCases,
    "DMA_P2P_DP_19",   P2PPeriphCases,
    "DMA_P2P_DP_20",   P2PPeriphCases,
    "DMA_P2P_DP_21",   P2PPeriphCases,
    "DMA_P2P_DP_22",   P2PPeriphCases,
    "DMA_P2P_DP_23",   P2PPeriphCases,
    "DMA_P2P_DP_24",   P2PPeriphCases,
    "DMA_P2P_DP_25",   P2PPeriphCases,
    "DMA_P2P_DP_26",   P2PPeriphCases,
    "DMA_P2P_DP_27",   P2PPeriphCases,
    "DMA_P2P_DP_28",   P2PPeriphCases,
    "DMA_P2P_DP_29",   P2PPeriphCases,
    "DMA_P2P_DP_30",   P2PPeriphCases,
    "DMA_P2P_DP_31",   P2PPeriphCases,
    "DMA_P2P_DP_32",   P2PPeriphCases,
    "DMA_P2P_DP_33",   P2PPeriphCases,
    "DMA_P2P_DP_34",   P2PPeriphCases,
    "DMA_P2P_DP_35",   P2PPeriphCases,
    "DMA_P2P_DP_36",   P2PPeriphCases,
    "DMA_P2P_DP_37",   P2PPeriphCases,
    "DMA_P2P_DP_38",   P2PPeriphCases,
    "DMA_P2P_DP_39",   P2PPeriphCases,
    "DMA_P2P_DP_40",   P2PPeriphCases,
    "DMA_P2P_DP_41",   P2PPeriphCases,
    "DMA_P2P_DP_42",   P2PPeriphCases,
    "DMA_P2P_DP_43",   P2PPeriphCases,
    "DMA_P2P_DP_44",   P2PPeriphCases,
    "ENDOFTEST",       BREQCases    };

  struct caselist *TestCases = P2PCaseList;
 
  struct requestcycles *SrcPeriphRequests;
  struct requestcycles *DstPeriphRequests;
 
  int ChannelNo[8] = {0,1,2,3,4,5,6,7};
 
  int32 RequestRepeatRate;
  int   SrcDataXfer, DstDataXfer;
  int   SrcSReqAsserted, SrcBReqAsserted;
  int   DstSReqAsserted, DstBReqAsserted;
 
  int   SourcePeripheral, DestinationPeripheral;

  SourcePeripheral = 0;
  DestinationPeripheral = 1;
  i = 0;
  j = 0;
  k = 0;

  while (TestCases->CaseNumber != "ENDOFTEST")
  {
    sprintf(report,"Test No : %s",TestCases->CaseNumber);
    C(report);
  
    P2PParams = TestCases->TestParams;

    while (P2PParams->SrcMaster != 2)
    {
      sprintf(report,"Source Master is : %d",P2PParams->SrcMaster);
      debug_info(report);

      if (P2PParams->SrcWidth == 8)
        SrcAddrMask = 0xFFFFFFFF;
      else if (P2PParams->SrcWidth == 16)
        SrcAddrMask = 0xFFFFFFFE;
      else
        SrcAddrMask = 0xFFFFFFFC;
 
      if (P2PParams->DestWidth == 8)
        DestAddrMask = 0xFFFFFFFF;
      else if (P2PParams->DestWidth == 16)
        DestAddrMask = 0xFFFFFFFE;
      else
        DestAddrMask = 0xFFFFFFFC;
 
      /* Generating the request signals at different timings as
         mentioned in the tables in the test document
         i.e., after enabling the channel /
               before enabling the channel but after configuring it/
               before configuring the channel but after setting it up
               etc....                                                */
 
      if (TestCases->CaseNumber == "DMA_P2P_DMAC_1")
      {
        SrcPeriphRequests = SrcREQ1Cycles;
        DstPeriphRequests = DstREQ1Cycles;
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DMAC_1A")
      {
        SrcPeriphRequests = SrcREQ1ACycles;
        DstPeriphRequests = DstREQ1ACycles;
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DMAC_2")
      {
        SrcPeriphRequests = SrcREQ2Cycles;
        DstPeriphRequests = DstREQ2Cycles;
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DMAC_3")
      {
        SrcPeriphRequests = SrcREQ3Cycles;
        DstPeriphRequests = DstREQ3Cycles;
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DMAC_4")
      {
        SrcPeriphRequests = SrcREQ4Cycles;
        DstPeriphRequests = DstREQ4Cycles;
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DMAC_5")
      {
        SrcPeriphRequests = SrcREQ5Cycles;
        DstPeriphRequests = DstREQ5Cycles;
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DMAC_6")
      {
        SrcPeriphRequests = SrcREQ6Cycles;
        DstPeriphRequests = DstREQ6Cycles;
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DMAC_7")
      {
        SrcPeriphRequests = SrcREQ7Cycles;
        DstPeriphRequests = DstREQ7Cycles;
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DMAC_8")
      {
        SrcPeriphRequests = SrcREQ8Cycles;
        DstPeriphRequests = DstREQ8Cycles;
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DMAC_9")
      {
        SrcPeriphRequests = SrcREQ9Cycles;
        DstPeriphRequests = DstREQ9Cycles;
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DMAC_10")
      {
        SrcPeriphRequests = SrcREQ10Cycles;
        DstPeriphRequests = DstREQ10Cycles;
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DMAC_11")
      {
        SrcPeriphRequests = SrcREQ11Cycles;
        DstPeriphRequests = DstREQ11Cycles;
      }

      if ((TestCases->CaseNumber == "DMA_P2P_DMAC_1")  ||
          (TestCases->CaseNumber == "DMA_P2P_DMAC_1A") ||
          (TestCases->CaseNumber == "DMA_P2P_DMAC_2")  ||
          (TestCases->CaseNumber == "DMA_P2P_DMAC_3")  ||
          (TestCases->CaseNumber == "DMA_P2P_DMAC_4")  ||
          (TestCases->CaseNumber == "DMA_P2P_DMAC_5")  ||
          (TestCases->CaseNumber == "DMA_P2P_DMAC_6")  ||
          (TestCases->CaseNumber == "DMA_P2P_DMAC_7")  ||
          (TestCases->CaseNumber == "DMA_P2P_DMAC_8")  ||
          (TestCases->CaseNumber == "DMA_P2P_DMAC_9")  ||
          (TestCases->CaseNumber == "DMA_P2P_DMAC_10") ||
          (TestCases->CaseNumber == "DMA_P2P_DMAC_11"))
      {
        while ((SrcPeriphRequests->SRC != 0) |
               (SrcPeriphRequests->BRC != 0) |
               (DstPeriphRequests->SRC != 0) |
               (DstPeriphRequests->BRC != 0))
        {
          SrcPeriphNo();
          DestPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

          Write(DMACREQCONFIG, MasterConfig);
 
          ProgramResponse("P2P",
                          P2PParams->TxSize,
                          P2PParams->SrcWidth,
                          P2PParams->DestWidth);

          RequestRepeatRate = (SrcPeriphRequests->BRC << 8) +
                              (SrcPeriphRequests->SRC);
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), RequestRepeatRate);

          RequestRepeatRate = (DstPeriphRequests->BRC << 8) +
                              (DstPeriphRequests->SRC);
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), RequestRepeatRate);

          P2PDma(CHANNEL,
                 AddrGen(PeriphLowAddress[SrcPeripheral],
                         PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                 AddrGen(PeriphLowAddress[DestPeripheral],
                         PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                 P2PParams->LLIAddress,
                 SrcPeripheral,
                 DestPeripheral,
                 P2PParams->SrcMaster,
                 P2PParams->DestMaster,
                 P2PParams->SrcWidth,
                 P2PParams->DestWidth,
                 P2PParams->SrcInc,
                 P2PParams->DestInc,
                 P2PParams->SrcBurst,
                 P2PParams->DestBurst,
                 P2PParams->TxSize,
                 P2PParams->LLIMaster,
                 P2PParams->Protection,
                 P2PParams->Lock,
                 TCENABLE,
                 TCMASK,
                 ERRMASK);
 
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          SrcPeriphRequests++;
          DstPeriphRequests++;
        }
      }
      if (TestCases->CaseNumber == "DMA_P2P_SP_1")
      {
        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths      */

        if (P2PParams->SrcWidth == P2PParams->DestWidth)
        {
          for (x=5;x>1;x--)
          {
            for (y=5;y>=x;y--)
            {
              /* Objective : Assertion of Source DMALSREQ followed by
                             Destination DMABREQ                      */

              SrcPeriphNo();
              DestPeriphNo();

              MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                             (DMASTER << (DestPeripheral + 2));

              Write(DMACREQCONFIG, MasterConfig);
 
              sprintf(report,"Source Peripheral is : %d",SrcPeripheral);
              debug_info(report);

              sprintf(report,"Destination Peripheral is : %d",DestPeripheral);
              debug_info(report);

              ProgramResponse("P2P",
                               1,
                               P2PParams->SrcWidth,
                               P2PParams->DestWidth);

              /* Program the request generation of the source and destination
                 peripherals such that the source peripheral initiates the
                 DMALSREQ request and the destination peripheral initiates the
                 DMABREQ request.
                 Bits 23-16 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMALSREQ request.
                 Bits 15-8 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMABREQ request.   */

              Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 16));
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*y) << 8));

              P2PSp(CHANNEL,
                    AddrGen(PeriphLowAddress[SrcPeripheral],
                            PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                    AddrGen(PeriphLowAddress[DestPeripheral],
                            PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                    P2PParams->LLIAddress,
                    SrcPeripheral,
                    DestPeripheral,
                    P2PParams->SrcMaster,
                    P2PParams->DestMaster,
                    P2PParams->SrcWidth,
                    P2PParams->DestWidth,
                    P2PParams->SrcInc,
                    P2PParams->DestInc,
                    P2PParams->SrcBurst,
                    P2PParams->DestBurst,
                    P2PParams->TxSize,
                    P2PParams->LLIMaster,
                    P2PParams->Protection,
                    P2PParams->Lock,
                    TCENABLE,
                    TCMASK,
                    ERRMASK);
        
              if ((SrcError == 0) && (DestError == 0))
              {
                Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

                Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
              }
              else
              {
                Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              }

              Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

              CheckStatus(CHANNEL);

              Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
              Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            }
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_2")
      {
        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths      */

        if (P2PParams->SrcWidth == P2PParams->DestWidth)
        {
          for (x=5;x>1;x--)
          {
            /* Objective : Assertion of Simultaneus Source DMALSREQ and
                           Destination DMABREQ                          */

            SrcPeriphNo();
            DestPeriphNo();


            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            ProgramResponse("P2P",
                             1,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMALSREQ request and the destination peripheral initiates the
               DMABREQ request.
               Bits 23-16 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMALSREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.   */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (((2*x) + 1) << 16));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));

            P2PSp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
      
            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_3")
      {
        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths      */

        if (P2PParams->SrcWidth == P2PParams->DestWidth)
        {
          for (x=5;x>1;x--)
          {
            for (y=5;y>=x;y--)
            {
              /* Objective : Assertion of Destination DMABREQ followed by
                             Source DMALSREQ */

              SrcPeriphNo();
              DestPeriphNo();


              MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

              Write(DMACREQCONFIG, MasterConfig);
 
              ProgramResponse("P2P",
                               1,
                               P2PParams->SrcWidth,
                               P2PParams->DestWidth);

              /* Program the request generation of the source and destination
                 peripherals such that the source peripheral initiates the
                 DMALSREQ request and the destination peripheral initiates the
                 DMABREQ request.
                 Bits 23-16 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMALSREQ request.
                 Bits 15-8 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMABREQ request.   */
              Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*y) << 16));
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));

              P2PSp(CHANNEL,
                    AddrGen(PeriphLowAddress[SrcPeripheral],
                            PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                    AddrGen(PeriphLowAddress[DestPeripheral],
                            PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                    P2PParams->LLIAddress,
                    SrcPeripheral,
                    DestPeripheral,
                    P2PParams->SrcMaster,
                    P2PParams->DestMaster,
                    P2PParams->SrcWidth,
                    P2PParams->DestWidth,
                    P2PParams->SrcInc,
                    P2PParams->DestInc,
                    P2PParams->SrcBurst,
                    P2PParams->DestBurst,
                    P2PParams->TxSize,
                    P2PParams->LLIMaster,
                    P2PParams->Protection,
                    P2PParams->Lock,
                    TCENABLE,
                    TCMASK,
                    ERRMASK);
        
              if ((SrcError == 0) && (DestError == 0))
              {
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
                Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
              }
              else
              {
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
                Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              }

              Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

              CheckStatus(CHANNEL);

              Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
              Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            }
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_4")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Source DMALBREQ followed by
                           Destination DMABREQ                      */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            ProgramResponse("P2P",
                             P2PParams->SrcBurst,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMALBREQ request and the destination peripheral initiates the
               DMABREQ request.
               Bits 31-24 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMALBREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.   */

            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 24));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*y) << 8));

            P2PSp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_5")
      {
        for (x=5;x>1;x--)
        {
          /* Objective : Assertion of Simultaneus Source DMALBREQ and
                         Destination DMABREQ                          */

          SrcPeriphNo();
          DestPeriphNo();


          MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

          Write(DMACREQCONFIG, MasterConfig);
 
          ProgramResponse("P2P",
                           P2PParams->SrcBurst,
                           P2PParams->SrcWidth,
                           P2PParams->DestWidth);

          /* Program the request generation of the source and destination
             peripherals such that the source peripheral initiates the
             DMALBREQ request and the destination peripheral initiates the
             DMABREQ request.
             Bits 31-24 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALBREQ request.
             Bits 15-8 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMABREQ request.         */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (((2*x) + 1) << 24));
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));

          P2PSp(CHANNEL,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                P2PParams->LLIAddress,
                SrcPeripheral,
                DestPeripheral,
                P2PParams->SrcMaster,
                P2PParams->DestMaster,
                P2PParams->SrcWidth,
                P2PParams->DestWidth,
                P2PParams->SrcInc,
                P2PParams->DestInc,
                P2PParams->SrcBurst,
                P2PParams->DestBurst,
                P2PParams->TxSize,
                P2PParams->LLIMaster,
                P2PParams->Protection,
                P2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
          if ((SrcError == 0) && (DestError == 0))
          {
            Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }
          else
          {
            Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          }
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_6")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Destination DMABREQ followed by
                           Source DMALBREQ */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            ProgramResponse("P2P",
                             P2PParams->SrcBurst,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMALBREQ request and the destination peripheral initiates the
               DMABREQ request.
               Bits 31-24 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMALBREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.   */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*y) << 24));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));

            P2PSp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_7")
      {
        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths and
           when the source width is half of the destination width      */

        if ((P2PParams->SrcWidth == P2PParams->DestWidth) ||
            (P2PParams->SrcWidth == (2*P2PParams->DestWidth)))
        {
          for (x=5;x>1;x--)
          {
            for (y=5;y>=x;y--)
            {
              /* Objective : Assertion of Source DMASREQ followed by
                             Destination DMABREQ and completing with
                             Source DMALSREQ                         */

              SrcPeriphNo();
              DestPeriphNo();


              MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                             (DMASTER << (DestPeripheral + 2));

              Write(DMACREQCONFIG, MasterConfig);
 
              ProgramResponse("P2P",
                               2,
                               P2PParams->SrcWidth,
                               P2PParams->DestWidth);

              /* Program the request generation of the source and destination
                 peripherals such that the source peripheral initiates the
                 DMASREQ request and the destination peripheral initiates the
                 DMABREQ request.
                 Bits 7-0 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMASREQ request.
                 Bits 15-8 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMABREQ request.   */

              Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*y) << 8));

              P2PSp(CHANNEL,
                    AddrGen(PeriphLowAddress[SrcPeripheral],
                            PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                    AddrGen(PeriphLowAddress[DestPeripheral],
                            PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                    P2PParams->LLIAddress,
                    SrcPeripheral,
                    DestPeripheral,
                    P2PParams->SrcMaster,
                    P2PParams->DestMaster,
                    P2PParams->SrcWidth,
                    P2PParams->DestWidth,
                    P2PParams->SrcInc,
                    P2PParams->DestInc,
                    P2PParams->SrcBurst,
                    P2PParams->DestBurst,
                    P2PParams->TxSize,
                    P2PParams->LLIMaster,
                    P2PParams->Protection,
                    P2PParams->Lock,
                    TCENABLE,
                    TCMASK,
                    ERRMASK);

              if ((SrcError == 0) && (DestError == 0))
              {
                Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

                /* Assertion of DMALSREQ signal from the source peripheral.
                   Bits 23-16 in the request register of the peripheral
                   indicates the number of clocks, to initiate the DMALSREQ
                   request.       */

                Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((20*x) << 16));

                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

                Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
              }
              else
              {
                Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

                /* Assertion of DMALSREQ signal from the source peripheral.
                   Bits 23-16 in the request register of the peripheral
                   indicates the number of clocks, to initiate the DMALSREQ
                   request.       */

                Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((20*x) << 16));

                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              }

              Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

              CheckStatus(CHANNEL);

              Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
              Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            }
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_8")
      {
        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths and
           when the source width is half of the destination width      */

        if ((P2PParams->SrcWidth == P2PParams->DestWidth) ||
            (P2PParams->SrcWidth == (2*P2PParams->DestWidth)))
        {
          for (x=5;x>1;x--)
          {
            /* Objective : Assertion Simultaneous assertion of Source DMASREQ
                           and Destination DMABREQ, and completing with
                           Source DMALSREQ                                */

            SrcPeriphNo();
            DestPeriphNo();


            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            ProgramResponse("P2P",
                             2,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMASREQ request and the destination peripheral initiates the
               DMABREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.    */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) + 1));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));

            P2PSp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

              if ((SrcError == 0) && (DestError == 0))
              {
                Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

                /* Assertion of DMALSREQ signal from the source peripheral.
                   Bits 23-16 in the request register of the peripheral
                   indicates the number of clocks, to initiate the DMALSREQ
                   request.       */

                Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));

                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

                Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
              }
              else
              {
                Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

                /* Assertion of DMALSREQ signal from the source peripheral.
                   Bits 23-16 in the request register of the peripheral
                   indicates the number of clocks, to initiate the DMALSREQ
                   request.       */

                Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));

                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_9")
      {
        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths and
           when the source width is half of the destination width      */

        if ((P2PParams->SrcWidth == P2PParams->DestWidth) ||
            (P2PParams->SrcWidth == (2*P2PParams->DestWidth)))
        {
          for (x=5;x>1;x--)
          {
            for (y=5;y>=x;y--)
            {
              /* Objective : Assertion Destination DMABREQ followed by
                             and Source DMASREQ, and completing with
                             Source DMALSREQ                         */

              SrcPeriphNo();
              DestPeriphNo();


              MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                             (DMASTER << (DestPeripheral + 2));

              Write(DMACREQCONFIG, MasterConfig);
 
              ProgramResponse("P2P",
                               2,
                               P2PParams->SrcWidth,
                               P2PParams->DestWidth);

              /* Program the request generation of the source and destination
                 peripherals such that the source peripheral initiates the
                 DMASREQ request and the destination peripheral initiates the
                 DMABREQ request.
                 Bits 7-0 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMASREQ request.
                 Bits 15-8 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMABREQ request.    */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));
              Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*y));

              P2PSp(CHANNEL,
                    AddrGen(PeriphLowAddress[SrcPeripheral],
                            PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                    AddrGen(PeriphLowAddress[DestPeripheral],
                            PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                    P2PParams->LLIAddress,
                    SrcPeripheral,
                    DestPeripheral,
                    P2PParams->SrcMaster,
                    P2PParams->DestMaster,
                    P2PParams->SrcWidth,
                    P2PParams->DestWidth,
                    P2PParams->SrcInc,
                    P2PParams->DestInc,
                    P2PParams->SrcBurst,
                    P2PParams->DestBurst,
                    P2PParams->TxSize,
                    P2PParams->LLIMaster,
                    P2PParams->Protection,
                    P2PParams->Lock,
                    TCENABLE,
                    TCMASK,
                    ERRMASK);

              if ((SrcError == 0) && (DestError == 0))
              {
                Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

                /* Assertion of DMALSREQ signal from the source peripheral.
                   Bits 23-16 in the request register of the peripheral
                   indicates the number of clocks, to initiate the DMALSREQ
                   request.       */

                Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));

                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

                Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
              }
              else
              {
                Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

                /* Assertion of DMALSREQ signal from the source peripheral.
                   Bits 23-16 in the request register of the peripheral
                   indicates the number of clocks, to initiate the DMALSREQ
                   request.       */
                Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));

                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              }

              Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

              CheckStatus(CHANNEL);

              Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
              Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            }
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_10")
      {
        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths      */

        if (P2PParams->SrcWidth == P2PParams->DestWidth)
        {
          for (x=5;x>1;x--)
          {
            for (y=5;y>=x;y--)
            {
              /* Objective : Assertion of Source DMABREQ followed by
                             Destination DMABREQ and completing with
                             Source DMALSREQ                         */

              SrcPeriphNo();
              DestPeriphNo();


              MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                             (DMASTER << (DestPeripheral + 2));

              Write(DMACREQCONFIG, MasterConfig);
 
              ProgramResponse("P2P",
                              (P2PParams->SrcBurst + 1),
                               P2PParams->SrcWidth,
                               P2PParams->DestWidth);

              /* Program the request generation of the source and destination
                 peripherals such that the source peripheral initiates the
                 DMABREQ request and the destination peripheral initiates the
                 DMABREQ request.
                 Bits 15-8 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMABREQ request.
                 Bits 15-8 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMABREQ request.   */

              Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*y) << 8));

              P2PSp(CHANNEL,
                    AddrGen(PeriphLowAddress[SrcPeripheral],
                            PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                    AddrGen(PeriphLowAddress[DestPeripheral],
                            PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                    P2PParams->LLIAddress,
                    SrcPeripheral,
                    DestPeripheral,
                    P2PParams->SrcMaster,
                    P2PParams->DestMaster,
                    P2PParams->SrcWidth,
                    P2PParams->DestWidth,
                    P2PParams->SrcInc,
                    P2PParams->DestInc,
                    P2PParams->SrcBurst,
                    P2PParams->DestBurst,
                    P2PParams->TxSize,
                    P2PParams->LLIMaster,
                    P2PParams->Protection,
                    P2PParams->Lock,
                    TCENABLE,
                    TCMASK,
                    ERRMASK);

              if ((SrcError == 0) && (DestError == 0))
              {
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

                /* Assertion of DMALSREQ signal from the source peripheral.
                   Bits 23-16 in the request register of the peripheral
                   indicates the number of clocks, to initiate the DMALSREQ
                   request. */

                Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));

                Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
              }
              else
              {
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

                /* Assertion of DMALSREQ signal from the source peripheral.
                   Bits 23-16 in the request register of the peripheral
                   indicates the number of clocks, to initiate the DMALSREQ
                   request. */

                Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));
              }

              Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

              CheckStatus(CHANNEL);

              Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
              Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            }
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_11")
      {
        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths      */

        if (P2PParams->SrcWidth == P2PParams->DestWidth)
        {
          for (x=5;x>1;x--)
          {
            /* Objective : Assertion Simultaneous assertion of Source DMABREQ
                           and Destination DMABREQ, and completing with
                           Source DMALSREQ                                */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            ProgramResponse("P2P",
                            (P2PParams->SrcBurst + 1),
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMABREQ request and the destination peripheral initiates the
               DMABREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.     */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (((2*x) + 1) << 8));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));

            P2PSp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

              if ((SrcError == 0) && (DestError == 0))
              {
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

                /* Assertion of DMALSREQ signal from the source peripheral.
                   Bits 23-16 in the request register of the peripheral
                   indicates the number of clocks, to initiate the DMALSREQ
                   request. */

                Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));

                Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
              }
              else
              {
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

                /* Assertion of DMALSREQ signal from the source peripheral.
                   Bits 23-16 in the request register of the peripheral
                   indicates the number of clocks, to initiate the DMALSREQ
                   request. */

                Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));
              }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_12")
      {
        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths      */

        if (P2PParams->SrcWidth == P2PParams->DestWidth)
        {
          for (x=5;x>1;x--)
          {
            for (y=5;y>=x;y--)
            {
              /* Objective : Assertion of Destination DMABREQ followed by
                             Source DMABREQ and completing with
                             Source DMALSREQ                              */

              SrcPeriphNo();
              DestPeriphNo();

              MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                             (DMASTER << (DestPeripheral + 2));

              Write(DMACREQCONFIG, MasterConfig);
 
              ProgramResponse("P2P",
                              (P2PParams->SrcBurst + 1),
                               P2PParams->SrcWidth,
                               P2PParams->DestWidth);

              /* Program the request generation of the source and destination
                 peripherals such that the source peripheral initiates the
                 DMABREQ request and the destination peripheral initiates the
                 DMABREQ request.
                 Bits 15-8 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMABREQ request.
                 Bits 15-8 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMABREQ request.     */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));
              Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*y) << 8));

              P2PSp(CHANNEL,
                    AddrGen(PeriphLowAddress[SrcPeripheral],
                            PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                    AddrGen(PeriphLowAddress[DestPeripheral],
                            PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                    P2PParams->LLIAddress,
                    SrcPeripheral,
                    DestPeripheral,
                    P2PParams->SrcMaster,
                    P2PParams->DestMaster,
                    P2PParams->SrcWidth,
                    P2PParams->DestWidth,
                    P2PParams->SrcInc,
                    P2PParams->DestInc,
                    P2PParams->SrcBurst,
                    P2PParams->DestBurst,
                    P2PParams->TxSize,
                    P2PParams->LLIMaster,
                    P2PParams->Protection,
                    P2PParams->Lock,
                    TCENABLE,
                    TCMASK,
                    ERRMASK);

              if ((SrcError == 0) && (DestError == 0))
              {
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

                /* Assertion of DMALSREQ signal from the source peripheral.
                   Bits 23-16 in the request register of the peripheral
                   indicates the number of clocks, to initiate the DMALSREQ
                   request. */

                Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));

                Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
              }
              else
              {
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

                /* Assertion of DMALSREQ signal from the source peripheral.
                   Bits 23-16 in the request register of the peripheral
                   indicates the number of clocks, to initiate the DMALSREQ
                   request. */

                Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));
              }

              Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

              CheckStatus(CHANNEL);

              Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
              Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            }
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_13")
      {
        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths      */

        if (P2PParams->SrcWidth == P2PParams->DestWidth)
        {
          for (x=5;x>1;x--)
          {
            for (y=5;y>=x;y--)
            {
              /* Objective : Assertion of Source DMASREQ followed by
                             Destination DMABREQ and completing with
                             Source DMALBREQ                         */

              SrcPeriphNo();
              DestPeriphNo();

              MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                             (DMASTER << (DestPeripheral + 2));

              Write(DMACREQCONFIG, MasterConfig);
 
              ProgramResponse("P2P",
                              (P2PParams->SrcBurst + 1),
                               P2PParams->SrcWidth,
                               P2PParams->DestWidth);

              /* Program the request generation of the source and destination
                 peripherals such that the source peripheral initiates the
                 DMASREQ request and the destination peripheral initiates the
                 DMABREQ request.
                 Bits 7-0 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMASREQ request.
                 Bits 15-8 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMABREQ request.      */

              Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*y) << 8));

              P2PSp(CHANNEL,
                    AddrGen(PeriphLowAddress[SrcPeripheral],
                            PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                    AddrGen(PeriphLowAddress[DestPeripheral],
                            PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                    P2PParams->LLIAddress,
                    SrcPeripheral,
                    DestPeripheral,
                    P2PParams->SrcMaster,
                    P2PParams->DestMaster,
                    P2PParams->SrcWidth,
                    P2PParams->DestWidth,
                    P2PParams->SrcInc,
                    P2PParams->DestInc,
                    P2PParams->SrcBurst,
                    P2PParams->DestBurst,
                    P2PParams->TxSize,
                    P2PParams->LLIMaster,
                    P2PParams->Protection,
                    P2PParams->Lock,
                    TCENABLE,
                    TCMASK,
                    ERRMASK);

              if ((SrcError == 0) && (DestError == 0))
              {
                Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

                /* Assertion of DMALBREQ signal from the source peripheral.
                   Bits 31-24 in the request register of the peripheral
                   indicates the number of clocks, to initiate the
                   DMALBREQ request.     */
                Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 24));

                Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
              }
              else
              {
                Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

                /* Assertion of DMALBREQ signal from the source peripheral.
                   Bits 31-24 in the request register of the peripheral
                   indicates the number of clocks, to initiate the
                   DMALBREQ request.     */
                Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 24));
              }

              Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

              CheckStatus(CHANNEL);

              Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
              Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            }
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_14")
      {
        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths      */

        if (P2PParams->SrcWidth == P2PParams->DestWidth)
        {
          for (x=5;x>1;x--)
          {
            /* Objective : Assertion Simultaneous assertion of Source DMASREQ
                           and Destination DMABREQ, and completing with
                           Source DMALBREQ  */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            ProgramResponse("P2P",
                            (P2PParams->SrcBurst + 1),
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMASREQ request and the destination peripheral initiates the
               DMABREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request. */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) + 1));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));

            P2PSp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assertion of DMALBREQ signal from the source peripheral.
                 Bits 31-24 in the request register of the peripheral
                 indicates the number of clocks, to initiate the
                 DMALBREQ request.     */
              Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 24));

              Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));

              Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));

              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assertion of DMALBREQ signal from the source peripheral.
                 Bits 31-24 in the request register of the peripheral
                 indicates the number of clocks, to initiate the
                 DMALBREQ request.     */
              Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 24));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_15")
      {
        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths      */

        if (P2PParams->SrcWidth == P2PParams->DestWidth)
        {
          for (x=5;x>1;x--)
          {
            for (y=5;y>=x;y--)
            {
              /* Objective : Assertion of Destination DMABREQ followed by
                             Source DMASREQ and completing with
                             Source DMALBREQ */

              SrcPeriphNo();
              DestPeriphNo();

              MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                             (DMASTER << (DestPeripheral + 2));

              Write(DMACREQCONFIG, MasterConfig);
 
              ProgramResponse("P2P",
                              (P2PParams->SrcBurst + 1),
                               P2PParams->SrcWidth,
                               P2PParams->DestWidth);

              /* Program the request generation of the source and destination
                 peripherals such that the source peripheral initiates the
                 DMASREQ request and the destination peripheral initiates the
                 DMABREQ request.
                 Bits 7-0 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMASREQ request.
                 Bits 15-8 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMABREQ request.      */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));
              Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*y));

              P2PSp(CHANNEL,
                    AddrGen(PeriphLowAddress[SrcPeripheral],
                            PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                    AddrGen(PeriphLowAddress[DestPeripheral],
                            PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                    P2PParams->LLIAddress,
                    SrcPeripheral,
                    DestPeripheral,
                    P2PParams->SrcMaster,
                    P2PParams->DestMaster,
                    P2PParams->SrcWidth,
                    P2PParams->DestWidth,
                    P2PParams->SrcInc,
                    P2PParams->DestInc,
                    P2PParams->SrcBurst,
                    P2PParams->DestBurst,
                    P2PParams->TxSize,
                    P2PParams->LLIMaster,
                    P2PParams->Protection,
                    P2PParams->Lock,
                    TCENABLE,
                    TCMASK,
                    ERRMASK);
        
              if ((SrcError == 0) && (DestError == 0))
              {
                Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

                /* Assertion of DMALBREQ signal from the source peripheral.
                   Bits 31-24 in the request register of the peripheral
                   indicates the number of clocks, to initiate the
                   DMALBREQ request.     */
                Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 24));

                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
                Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
                Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));

                Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
              }
              else
              {
                Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

                /* Assertion of DMALBREQ signal from the source peripheral.
                   Bits 31-24 in the request register of the peripheral
                   indicates the number of clocks, to initiate the
                   DMALBREQ request.     */
                Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 24));

                Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              }

              Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

              CheckStatus(CHANNEL);

              Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
              Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            }
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_16")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Source DMABREQ followed by
                           Destination DMABREQ and completing with
                           Source DMALBREQ                         */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            ProgramResponse("P2P",
                            (P2PParams->SrcBurst * 2),
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMABREQ request and the destination peripheral initiates the
               DMABREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.      */

            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*y) << 8));

            P2PSp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assertion of DMALBREQ signal from the source peripheral.
                 Bits 31-24 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMALSREQ request. */
              Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 24));

              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

              Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));

              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assertion of DMALBREQ signal from the source peripheral.
                 Bits 31-24 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMALSREQ request. */
              Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 24));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_17")
      {
        for (x=5;x>1;x--)
        {
          /* Objective : Assertion Simultaneous assertion of Source DMABREQ
                         and Destination DMABREQ, and completing with
                         Source DMALBREQ                                    */

          SrcPeriphNo();
          DestPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

          Write(DMACREQCONFIG, MasterConfig);
 
          ProgramResponse("P2P",
                          (P2PParams->SrcBurst * 2),
                           P2PParams->SrcWidth,
                           P2PParams->DestWidth);

          /* Program the request generation of the source and destination
             peripherals such that the source peripheral initiates the
             DMABREQ request and the destination peripheral initiates the
             DMABREQ request.
             Bits 15-8 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMABREQ request.
             Bits 15-8 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMABREQ request.         */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (((2*x) + 1) << 8));
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));

          P2PSp(CHANNEL,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                P2PParams->LLIAddress,
                SrcPeripheral,
                DestPeripheral,
                P2PParams->SrcMaster,
                P2PParams->DestMaster,
                P2PParams->SrcWidth,
                P2PParams->DestWidth,
                P2PParams->SrcInc,
                P2PParams->DestInc,
                P2PParams->SrcBurst,
                P2PParams->DestBurst,
                P2PParams->TxSize,
                P2PParams->LLIMaster,
                P2PParams->Protection,
                P2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);

          if ((SrcError == 0) && (DestError == 0))
          {
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            /* Assertion of DMALBREQ signal from the source peripheral.
               Bits 31-24 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMALSREQ request. */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 24));

            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

            Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));

            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }
          else
          {
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            /* Assertion of DMALBREQ signal from the source peripheral.
               Bits 31-24 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMALSREQ request. */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 24));
          }

          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_18")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion Simultaneous assertion of Source DMABREQ
                           and Destination DMABREQ, and completing with
                           Source DMALBREQ                                   */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            ProgramResponse("P2P",
                            (P2PParams->SrcBurst * 2),
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMABREQ request and the destination peripheral initiates the
               DMABREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.  */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (((2*y) << 8) + 1));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));

            P2PSp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assertion of DMALBREQ signal from the source peripheral.
                 Bits 31-24 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMALSREQ request. */
              Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 24));

              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

              Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));

              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assertion of DMALBREQ signal from the source peripheral.
                 Bits 31-24 in the request register of the peripheral indicates
                 the number of clocks, to initiate the DMALSREQ request. */
              Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 24));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_19")
      {
        /* Objective : Assertion of multiple(11) Source DMASREQ and
                       Destination DMABREQ and completing with
                       Source DMALSREQ                         */

        SrcPeriphNo();
        DestPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                       (DMASTER << (DestPeripheral + 2));

        Write(DMACREQCONFIG, MasterConfig);
 
        ProgramResponse("P2P",
                         12,
                         P2PParams->SrcWidth,
                         P2PParams->DestWidth);

        /* Program the request generation of the source and destination
           peripherals such that the source peripheral initiates the
           DMASREQ request and the destination peripheral initiates the
           DMABREQ request.
           Bits 7-0 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMASREQ request.
           Bits 15-8 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMABREQ request.         */

        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), 5);
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (5 << 8));

        P2PSp(CHANNEL,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              P2PParams->LLIAddress,
              SrcPeripheral,
              DestPeripheral,
              P2PParams->SrcMaster,
              P2PParams->DestMaster,
              P2PParams->SrcWidth,
              P2PParams->DestWidth,
              P2PParams->SrcInc,
              P2PParams->DestInc,
              P2PParams->SrcBurst,
              P2PParams->DestBurst,
              P2PParams->TxSize,
              P2PParams->LLIMaster,
              P2PParams->Protection,
              P2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        /* Wait for the assertion of 10 DMASREQ requests from
           the source peripheral by sampling the SoftSREQ register */
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

          /* Assertion of DMALSREQ signal from the source peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));

          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
 
          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
        }
        else
        {
          for (x=0;x<10;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            WaitLoop(32);
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

          /* Assertion of DMALSREQ signal from the source peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_20")
      {
        /* Objective : Assertion of multiple(12) Source DMASREQ and
                       Destination DMABREQ and completing with
                       Source DMALBREQ                         */

        SrcPeriphNo();
        DestPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                       (DMASTER << (DestPeripheral + 2));

        Write(DMACREQCONFIG, MasterConfig);
 
        ProgramResponse("P2P",
                        (P2PParams->SrcBurst + 12),
                         P2PParams->SrcWidth,
                         P2PParams->DestWidth);

        /* Program the request generation of the source and destination
           peripherals such that the source peripheral initiates the
           DMASREQ request and the destination peripheral initiates the
           DMABREQ request.
           Bits 7-0 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMASREQ request.
           Bits 15-8 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMABREQ request.         */

        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), 5);
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (5 << 8));

        P2PSp(CHANNEL,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              P2PParams->LLIAddress,
              SrcPeripheral,
              DestPeripheral,
              P2PParams->SrcMaster,
              P2PParams->DestMaster,
              P2PParams->SrcWidth,
              P2PParams->DestWidth,
              P2PParams->SrcInc,
              P2PParams->DestInc,
              P2PParams->SrcBurst,
              P2PParams->DestBurst,
              P2PParams->TxSize,
              P2PParams->LLIMaster,
              P2PParams->Protection,
              P2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        /* Wait for the assertion of 10 DMASREQ requests from
           the source peripheral by sampling the SoftSREQ register */
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

          /* Assertion of DMALBREQ signal from the source peripheral.
             Bits 31-24 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 24));

          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
 
          /* Poll for the DMACSoftLBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));
 
        }
        else
        {
          for (x=0;x<11;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            WaitLoop(32);
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

          /* Assertion of DMALBREQ signal from the source peripheral.
             Bits 31-24 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 24));
        }
        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_21")
      {
        /* Objective : Assertion of multiple(10) Source DMABREQ and
                       Destination DMABREQ and completing with
                       Source DMALSREQ                         */

        /* The Dmac requires that if the source width is less than the
           destination width, the number of transfers performed by the
           source peripheral should be such that the number of transfers
           multiplied by the source width should be an integral multiple
           of the destination width. Therefore the following case is
           applicable only for equal source and destination widths      */

        if (P2PParams->SrcWidth == P2PParams->DestWidth)
        {
          SrcPeriphNo();
          DestPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

          Write(DMACREQCONFIG, MasterConfig);
 
          ProgramResponse("P2P",
                         ((P2PParams->SrcBurst * 10) + 1),
                           P2PParams->SrcWidth,
                           P2PParams->DestWidth);

          /* Program the request generation of the source and destination
             peripherals such that the source peripheral initiates the
             DMASREQ request and the destination peripheral initiates the
             DMABREQ request.
             Bits 15-8 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMABREQ request.         */

          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (5 << 8));
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), (5 << 8));

          P2PSp(CHANNEL,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                P2PParams->LLIAddress,
                SrcPeripheral,
                DestPeripheral,
                P2PParams->SrcMaster,
                P2PParams->DestMaster,
                P2PParams->SrcWidth,
                P2PParams->DestWidth,
                P2PParams->SrcInc,
                P2PParams->DestInc,
                P2PParams->SrcBurst,
                P2PParams->DestBurst,
                P2PParams->TxSize,
                P2PParams->LLIMaster,
                P2PParams->Protection,
                P2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);

          /* Wait for the assertion of 10 DMABREQ requests from
             the source peripheral by sampling the SoftBREQ register */
          if ((SrcError == 0) && (DestError == 0))
          {
            for (x=0;x<9;x++)
            {
              /* Poll for the DMACSoftBReq bit to be reset
                 after the DMA transfer */
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
            }

            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Assertion of DMALSREQ signal from the source peripheral.
               Bits 23-16 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMALSREQ request.       */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));

            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
 
            /* Poll for the DMACSoftLSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));

            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }
          else
          {
            for (x=0;x<9;x++)
            {
              /* Poll for the DMACSoftBReq bit to be reset
                 after the DMA transfer */
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              WaitLoop(32 * P2PParams->SrcBurst);
            }

            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Assertion of DMALSREQ signal from the source peripheral.
               Bits 23-16 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMALSREQ request.       */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));
          }

          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
          CheckStatus(CHANNEL);

          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_22")
      {
        /* Objective : Assertion of multiple(10) Source DMABREQ and
                       Destination DMABREQ and completing with
                       Source DMALBREQ                         */

        SrcPeriphNo();
        DestPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                       (DMASTER << (DestPeripheral + 2));

        Write(DMACREQCONFIG, MasterConfig);
 
        ProgramResponse("P2P",
                         (P2PParams->SrcBurst * 11),
                          P2PParams->SrcWidth,
                          P2PParams->DestWidth);

        /* Program the request generation of the source and destination
           peripherals such that the source peripheral initiates the
           DMASREQ request and the destination peripheral initiates the
           DMABREQ request.
           Bits 15-8 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMABREQ request.         */

        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (5 << 8));
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (5 << 8));

        P2PSp(CHANNEL,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              P2PParams->LLIAddress,
              SrcPeripheral,
              DestPeripheral,
              P2PParams->SrcMaster,
              P2PParams->DestMaster,
              P2PParams->SrcWidth,
              P2PParams->DestWidth,
              P2PParams->SrcInc,
              P2PParams->DestInc,
              P2PParams->SrcBurst,
              P2PParams->DestBurst,
              P2PParams->TxSize,
              P2PParams->LLIMaster,
              P2PParams->Protection,
              P2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        /* Wait for the assertion of 10 DMABREQ requests from
           the source peripheral by sampling the SoftBREQ register */
        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<9;x++)
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }
  
          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
  
          /* Assertion of DMALBREQ signal from the source peripheral.
             Bits 31-24 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 24));
  
          /* Poll for the DMACSoftBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
   
          /* Poll for the DMACSoftLBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));
        }
        else
        {
          for (x=0;x<9;x++)
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            WaitLoop(32 * P2PParams->SrcBurst);
          }
  
          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
  
          /* Assertion of DMALBREQ signal from the source peripheral.
             Bits 31-24 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 24));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_23")
      {
        /* Objective : Assertion of multiple(10) Source DMABREQ,
                       Source DMASREQ and Destination DMABREQ and
                       completing with Source DMALSREQ            */

        SrcPeriphNo();
        DestPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                       (DMASTER << (DestPeripheral + 2));

        Write(DMACREQCONFIG, MasterConfig);
 
        ProgramResponse("P2P",
                        ((P2PParams->SrcBurst * 10) + 1),
                          P2PParams->SrcWidth,
                          P2PParams->DestWidth);

        /* Program the request generation of the source and destination
           peripherals such that the source peripheral initiates the
           DMASREQ request and the destination peripheral initiates the
           DMABREQ request.
           Bits 15-8 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMABREQ request.         */

        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (5 << 8));
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (5 << 8));

        P2PSp(CHANNEL,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              P2PParams->LLIAddress,
              SrcPeripheral,
              DestPeripheral,
              P2PParams->SrcMaster,
              P2PParams->DestMaster,
              P2PParams->SrcWidth,
              P2PParams->DestWidth,
              P2PParams->SrcInc,
              P2PParams->DestInc,
              P2PParams->SrcBurst,
              P2PParams->DestBurst,
              P2PParams->TxSize,
              P2PParams->LLIMaster,
              P2PParams->Protection,
              P2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        /* Wait for the assertion of 10 DMABREQ requests from
           the source peripheral by sampling the SoftBREQ register */
        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<9;x++)
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

          /* Assert multiple DMASREQ of the source peripheral */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), 3);

          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

          /* Wait for the assertion of 11 DMASREQ requests from
             the source peripheral by sampling the SoftSREQ register */
          for (x=0;x<11;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

          /* Assertion of DMALSREQ signal from the source peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));

          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
 
          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
        }
        else
        {
          for (x=0;x<9;x++)
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            WaitLoop(32 * P2PParams->SrcBurst);
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

          /* Assertion of DMALSREQ signal from the source peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));
        }
        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_24")
      {
        /* Objective : Assertion of multiple(10) Source DMABREQ,
                       multiple (12) Source DMASREQ and Destination DMABREQ and
                       completing with Source DMALBREQ            */

        SrcPeriphNo();
        DestPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                       (DMASTER << (DestPeripheral + 2));

        Write(DMACREQCONFIG, MasterConfig);
 
        ProgramResponse("P2P",
                       ((P2PParams->SrcBurst * 10) + 12),
                         P2PParams->SrcWidth,
                         P2PParams->DestWidth);

        /* Program the request generation of the source and destination
           peripherals such that the source peripheral initiates the
           DMASREQ request and the destination peripheral initiates the
           DMABREQ request.
           Bits 15-8 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMABREQ request.         */

        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (3 << 8));
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (2 << 8));

        P2PSp(CHANNEL,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              P2PParams->LLIAddress,
              SrcPeripheral,
              DestPeripheral,
              P2PParams->SrcMaster,
              P2PParams->DestMaster,
              P2PParams->SrcWidth,
              P2PParams->DestWidth,
              P2PParams->SrcInc,
              P2PParams->DestInc,
              P2PParams->SrcBurst,
              P2PParams->DestBurst,
              P2PParams->TxSize,
              P2PParams->LLIMaster,
              P2PParams->Protection,
              P2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        /* Wait for the assertion of 10 DMABREQ requests from
           the source peripheral by sampling the SoftBREQ register */
        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<10;x++)
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

          /* Assert multiple DMASREQ of the source peripheral */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), 1);

          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));

          /* Wait for the assertion of 10 DMASREQ requests from
             the source peripheral by sampling the SoftSREQ register */
          for (x=0;x<11;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

          /* Assertion of DMALBREQ signal from the source peripheral.
             Bits 31-24 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALBREQ request.       */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (100 << 24));

          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
 
          /* Poll for the DMACSoftLBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
        }
        else
        {
          for (x=0;x<11;x++)
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            WaitLoop(32 * P2PParams->SrcBurst);
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

          /* Assertion of DMALBREQ signal from the source peripheral.
             Bits 31-24 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALBREQ request.       */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (100 << 24));
        }
 
        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_25")
      {
        /* Objective : Assertion of alternate Source DMABREQ,
                       Source DMASREQ, Destination DMABREQ and
                       completing with Source DMALSREQ            */

        SrcPeriphNo();
        DestPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                       (DMASTER << (DestPeripheral + 2));

        Write(DMACREQCONFIG, MasterConfig);
 
        ProgramResponse("P2P",
                       ((P2PParams->SrcBurst * 11) + 12),
                         P2PParams->SrcWidth,
                         P2PParams->DestWidth);

        /* Program the request generation of the source and destination
           peripherals such that the source peripheral initiates the
           DMASREQ request and the destination peripheral initiates the
           DMABREQ request.
           Bits 7-0 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMASREQ request.
           Bits 15-8 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMABREQ request.         */

        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), 15);
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (5 << 8));

        P2PSp(CHANNEL,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              P2PParams->LLIAddress,
              SrcPeripheral,
              DestPeripheral,
              P2PParams->SrcMaster,
              P2PParams->DestMaster,
              P2PParams->SrcWidth,
              P2PParams->DestWidth,
              P2PParams->SrcInc,
              P2PParams->DestInc,
              P2PParams->SrcBurst,
              P2PParams->DestBurst,
              P2PParams->TxSize,
              P2PParams->LLIMaster,
              P2PParams->Protection,
              P2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        /* Wait for the assertion of 10 DMABREQ requests from
           the source peripheral by sampling the SoftBREQ register */
        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<11;x++)
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
  
            /* Assert DMABREQ of the source peripheral */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG),
                             (((rand() % 15) + 1) << 8));
  
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));

            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Assert DMASREQ of the source peripheral */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG),
                             ((rand() % 15) + 1));

            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

          /* Assertion of DMALSREQ signal from the source peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));

          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
 
          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
        }
        else
        {
          for (x=0;x<11;x++)
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            WaitLoop(32);
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

          /* Assertion of DMALSREQ signal from the source peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((200) << 16));
        }
 
        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2P_SP_26")
      {
        /* Objective : Assertion of alternate Source DMABREQ,
                       Source DMASREQ, Destination DMABREQ and
                       completing with Source DMALBREQ            */

        SrcPeriphNo();
        DestPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                       (DMASTER << (DestPeripheral + 2));

        Write(DMACREQCONFIG, MasterConfig);
 
        ProgramResponse("P2P",
                       ((P2PParams->SrcBurst * 13) + 12),
                         P2PParams->SrcWidth,
                         P2PParams->DestWidth);

        /* Program the request generation of the source and destination
           peripherals such that the source peripheral initiates the
           DMASREQ request and the destination peripheral initiates the
           DMABREQ request.
           Bits 7-0 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMASREQ request.
           Bits 15-8 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMABREQ request.         */

        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (12 << 8));
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), (7 << 8));

        P2PSp(CHANNEL,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              P2PParams->LLIAddress,
              SrcPeripheral,
              DestPeripheral,
              P2PParams->SrcMaster,
              P2PParams->DestMaster,
              P2PParams->SrcWidth,
              P2PParams->DestWidth,
              P2PParams->SrcInc,
              P2PParams->DestInc,
              P2PParams->SrcBurst,
              P2PParams->DestBurst,
              P2PParams->TxSize,
              P2PParams->LLIMaster,
              P2PParams->Protection,
              P2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        /* Wait for the assertion of 10 DMABREQ requests from
           the source peripheral by sampling the SoftBREQ register */
        if ((SrcError == 0) && (DestError == 0))
        {
          for (x=0;x<11;x++)
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
  
            /* Assert DMASREQ of the source peripheral */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG),
                             ((rand() % 15) + 1));
  
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
  
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Assert DMABREQ of the source peripheral */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG),
                             (((rand() % 15) + 1) << 8));
  
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
          }
  
          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
  
          /* Assertion of DMALBREQ signal from the source peripheral.
             Bits 31-24 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG),
                           ((((rand() % 8) + 1) * 10) << 24));
  
          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
   
          /* Poll for the DMACSoftLBReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
        }
        else
        {
          for (x=0;x<12;x++)
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            WaitLoop(32);
          }
  
          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
  
          /* Assertion of DMALBREQ signal from the source peripheral.
             Bits 31-24 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG),
                           ((((rand() % 15) + 1) * 10) << 24));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_1")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Destination DMALSREQ followed by
                           Source DMASREQ                      */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) P2PParams->DestWidth/P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMASREQ request and the destination peripheral initiates the
               DMALSREQ request.
               Bits 23-16 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMALSREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.  */

            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*y));

            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
        
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_2")
      {
        for (x=5;x>1;x--)
        {
          /* Objective : Assertion of Simultaneus Destination DMALSREQ and
                         Source DMASREQ                          */

          SrcPeriphNo();
          DestPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

          Write(DMACREQCONFIG, MasterConfig);
 
          DataXfers = (int) P2PParams->DestWidth/P2PParams->SrcWidth;

          if (DataXfers == 0) DataXfers = 1;

          ProgramResponse("P2P",
                           DataXfers,
                           P2PParams->SrcWidth,
                           P2PParams->DestWidth);

          /* Program the request generation of the source and destination
             peripherals such that the source peripheral initiates the
             DMASREQ request and the destination peripheral initiates the
             DMALSREQ request.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.
             Bits 7-0 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMASREQ request.         */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), (((2*x) + 1) << 16));
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));

          P2PDp(CHANNEL,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                P2PParams->LLIAddress,
                SrcPeripheral,
                DestPeripheral,
                P2PParams->SrcMaster,
                P2PParams->DestMaster,
                P2PParams->SrcWidth,
                P2PParams->DestWidth,
                P2PParams->SrcInc,
                P2PParams->DestInc,
                P2PParams->SrcBurst,
                P2PParams->DestBurst,
                P2PParams->TxSize,
                P2PParams->LLIMaster,
                P2PParams->Protection,
                P2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
      
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
          CheckStatus(CHANNEL);

          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_3")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Source DMASREQ followed by
                           Destination DMALSREQ */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) P2PParams->DestWidth/P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMASREQ request and the destination peripheral initiates the
               DMALSREQ request.
               Bits 23-16 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMALSREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.      */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*y) << 16));

            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
        
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_4")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Destination DMALBREQ followed by
                           Source DMASREQ                      */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth * P2PParams->DestBurst)/
                        P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMASREQ request and the destination peripheral initiates the
               DMALBREQ request.
               Bits 31-24 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMALBREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.  */

            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 24));
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*y));

            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
        
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_5")
      {
        for (x=5;x>1;x--)
        {
          /* Objective : Assertion of Simultaneus Destination DMALBREQ and
                         Source DMASREQ                          */

          SrcPeriphNo();
          DestPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

          Write(DMACREQCONFIG, MasterConfig);
 
          DataXfers = (int) (P2PParams->DestWidth * P2PParams->DestBurst)/
                             P2PParams->SrcWidth;

          if (DataXfers == 0) DataXfers = 1;

          ProgramResponse("P2P",
                           DataXfers,
                           P2PParams->SrcWidth,
                           P2PParams->DestWidth);

          /* Program the request generation of the source and destination
             peripherals such that the source peripheral initiates the
             DMASREQ request and the destination peripheral initiates the
             DMALBREQ request.
             Bits 31-24 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALBREQ request.
             Bits 7-0 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMASREQ request.         */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), (((2*x) + 1) << 24));
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));

          P2PDp(CHANNEL,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                P2PParams->LLIAddress,
                SrcPeripheral,
                DestPeripheral,
                P2PParams->SrcMaster,
                P2PParams->DestMaster,
                P2PParams->SrcWidth,
                P2PParams->DestWidth,
                P2PParams->SrcInc,
                P2PParams->DestInc,
                P2PParams->SrcBurst,
                P2PParams->DestBurst,
                P2PParams->TxSize,
                P2PParams->LLIMaster,
                P2PParams->Protection,
                P2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
      
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
          CheckStatus(CHANNEL);

          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_6")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Source DMASREQ followed by
                           Destination DMALBREQ */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth * P2PParams->DestBurst)/
                        P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMASREQ request and the destination peripheral initiates the
               DMALBREQ request.
               Bits 31-24 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMALBREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.     */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*y) << 24));

            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
        
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_7")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Destination DMASREQ followed by
                           Source DMASREQ and completing with Destination
                           DMALSREQ                                       */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth*2)/P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMASREQ request and the destination peripheral initiates the
               DMASREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request. */

            Write(PeriphReg(DestPeripheral, PERIPHREQREG), (2*x));
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*y));

            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));

              Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_8")
      {
        for (x=5;x>1;x--)
        {
          /* Objective : Assertion of Simultaneus Destination DMASREQ and
                         Source DMASREQ and completing with Destination
                         DMALSREQ                                         */
 
          SrcPeriphNo();
          DestPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

          Write(DMACREQCONFIG, MasterConfig);
 
          DataXfers = (int) (P2PParams->DestWidth*2)/P2PParams->SrcWidth;

          if (DataXfers == 0) DataXfers = 1;

          ProgramResponse("P2P",
                           DataXfers,
                           P2PParams->SrcWidth,
                           P2PParams->DestWidth);
 
          /* Program the request generation of the source and destination
             peripherals such that the source peripheral initiates the
             DMASREQ request and the destination peripheral initiates the
             DMALSREQ request.
             Bits 7-0 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMASREQ request.         */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) + 1));
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));
 
          P2PDp(CHANNEL,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                P2PParams->LLIAddress,
                SrcPeripheral,
                DestPeripheral,
                P2PParams->SrcMaster,
                P2PParams->DestMaster,
                P2PParams->SrcWidth,
                P2PParams->DestWidth,
                P2PParams->SrcInc,
                P2PParams->DestInc,
                P2PParams->SrcBurst,
                P2PParams->DestBurst,
                P2PParams->TxSize,
                P2PParams->LLIMaster,
                P2PParams->Protection,
                P2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
 
          if ((SrcError == 0) && (DestError == 0))
          {
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            /* Assert the DMALSREQ from the destination peripheral */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));

            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

            Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
          }
          else
          {
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            /* Assert the DMALSREQ from the destination peripheral */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));
          }

          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_9")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Source DMASREQ followed by
                           Destination DMASREQ and completing with
                           Destination DMALSREQ                     */
 
            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth*2)/P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);
 
            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMASREQ request and the destination peripheral initiates the
               DMASREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request. */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), (2*y));
 
            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
 
            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));

              Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));
            }
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_10")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Destination DMABREQ followed by
                           Source DMASREQ and completing with Destination
                           DMALSREQ                                       */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth *
                              (P2PParams->DestBurst + 1))/
                               P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMASREQ request and the destination peripheral initiates the
               DMABREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.  */

            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*y));

            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));

              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));
            }
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_11")
      {
        for (x=5;x>1;x--)
        {
          /* Objective : Assertion of Simultaneus Destination DMABREQ and
                         Source DMASREQ and completing with Destination
                         DMALSREQ                                         */
 
          SrcPeriphNo();
          DestPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

          Write(DMACREQCONFIG, MasterConfig);
 
          DataXfers = (int) (P2PParams->DestWidth *
                            (P2PParams->DestBurst + 1))/
                             P2PParams->SrcWidth;

          if (DataXfers == 0) DataXfers = 1;

          ProgramResponse("P2P",
                           DataXfers,
                           P2PParams->SrcWidth,
                           P2PParams->DestWidth);
 
          /* Program the request generation of the source and destination
             peripherals such that the source peripheral initiates the
             DMASREQ request and the destination peripheral initiates the
             DMABREQ request.
             Bits 15-8 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMABREQ request.
             Bits 7-0 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMASREQ request.         */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), (((2*x) + 1) << 8));
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));
 
          P2PDp(CHANNEL,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                P2PParams->LLIAddress,
                SrcPeripheral,
                DestPeripheral,
                P2PParams->SrcMaster,
                P2PParams->DestMaster,
                P2PParams->SrcWidth,
                P2PParams->DestWidth,
                P2PParams->SrcInc,
                P2PParams->DestInc,
                P2PParams->SrcBurst,
                P2PParams->DestBurst,
                P2PParams->TxSize,
                P2PParams->LLIMaster,
                P2PParams->Protection,
                P2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
 
          if ((SrcError == 0) && (DestError == 0))
          {
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Assert the DMALSREQ from the destination peripheral */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));

            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

            Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
          }
          else
          {
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Assert the DMALSREQ from the destination peripheral */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));
          }
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_12")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Source DMASREQ followed by
                           Destination DMABREQ and completing with
                           Destination DMALSREQ                     */
 
            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth *
                              (P2PParams->DestBurst + 1))/
                               P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);
 
            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMASREQ request and the destination peripheral initiates the
               DMABREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.  */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*y) << 8));
 
            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
 
            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));

              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));
            }
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_13")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Destination DMASREQ followed by
                           Source DMASREQ and completing with Destination
                           DMALBREQ                                       */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth *
                              (P2PParams->DestBurst + 1))/
                               P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMASREQ request and the destination peripheral initiates the
               DMASREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.  */

            Write(PeriphReg(DestPeripheral, PERIPHREQREG), (2*x));
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*y));

            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALBREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));

              Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALBREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));
            }
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_14")
      {
        for (x=5;x>1;x--)
        {
          /* Objective : Assertion of Simultaneus Destination DMASREQ and
                         Source DMASREQ and completing with Destination
                         DMALBREQ                                         */
 
          SrcPeriphNo();
          DestPeriphNo();


          MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

          Write(DMACREQCONFIG, MasterConfig);
 
          DataXfers = (int) (P2PParams->DestWidth *
                            (P2PParams->DestBurst + 1))/
                             P2PParams->SrcWidth;

          if (DataXfers == 0) DataXfers = 1;

          ProgramResponse("P2P",
                           DataXfers,
                           P2PParams->SrcWidth,
                           P2PParams->DestWidth);
 
          /* Program the request generation of the source and destination
             peripherals such that the source peripheral initiates the
             DMASREQ request and the destination peripheral initiates the
             DMALBREQ request.
             Bits 7-0 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMASREQ request.         */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) + 1));
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));
 
          P2PDp(CHANNEL,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                P2PParams->LLIAddress,
                SrcPeripheral,
                DestPeripheral,
                P2PParams->SrcMaster,
                P2PParams->DestMaster,
                P2PParams->SrcWidth,
                P2PParams->DestWidth,
                P2PParams->SrcInc,
                P2PParams->DestInc,
                P2PParams->SrcBurst,
                P2PParams->DestBurst,
                P2PParams->TxSize,
                P2PParams->LLIMaster,
                P2PParams->Protection,
                P2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
 
          if ((SrcError == 0) && (DestError == 0))
          {
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            /* Assert the DMALBREQ from the destination peripheral */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));

            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

            Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }
          else
          {
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            /* Assert the DMALBREQ from the destination peripheral */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));
          }
 
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
 
          CheckStatus(CHANNEL);

          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_15")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Source DMASREQ followed by
                           Destination DMASREQ and completing with
                           Destination DMALBREQ                     */
 
            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth *
                              (P2PParams->DestBurst + 1))/
                               P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);
 
            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMASREQ request and the destination peripheral initiates the
               DMASREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.  */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), (2*y));
 
            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
 
            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assert the DMALBREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));

              Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assert the DMALBREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
 
            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_16")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Destination DMABREQ followed by
                           Source DMASREQ and completing with Destination
                           DMALBREQ                                       */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth *
                               P2PParams->DestBurst*2)/
                               P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMASREQ request and the destination peripheral initiates the
               DMABREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.   */

            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*y));

            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALBREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));

              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALBREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_17")
      {
        for (x=5;x>1;x--)
        {
          /* Objective : Assertion of Simultaneus Destination DMABREQ and
                         Source DMASREQ and completing with Destination
                         DMALBREQ                                         */
 
          SrcPeriphNo();
          DestPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

          Write(DMACREQCONFIG, MasterConfig);
 
          DataXfers = (int) (P2PParams->DestWidth *
                             P2PParams->DestBurst*2)/
                             P2PParams->SrcWidth;

          if (DataXfers == 0) DataXfers = 1;

          ProgramResponse("P2P",
                           DataXfers,
                           P2PParams->SrcWidth,
                           P2PParams->DestWidth);
 
          /* Program the request generation of the source and destination
             peripherals such that the source peripheral initiates the
             DMASREQ request and the destination peripheral initiates the
             DMABREQ request.
             Bits 15-8 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMABREQ request.
             Bits 7-0 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMASREQ request.         */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), (((2*x) + 1) << 8));
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));
 
          P2PDp(CHANNEL,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                P2PParams->LLIAddress,
                SrcPeripheral,
                DestPeripheral,
                P2PParams->SrcMaster,
                P2PParams->DestMaster,
                P2PParams->SrcWidth,
                P2PParams->DestWidth,
                P2PParams->SrcInc,
                P2PParams->DestInc,
                P2PParams->SrcBurst,
                P2PParams->DestBurst,
                P2PParams->TxSize,
                P2PParams->LLIMaster,
                P2PParams->Protection,
                P2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
 
          if ((SrcError == 0) && (DestError == 0))
          {
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Assert the DMALBREQ from the destination peripheral */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));

            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

            Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }
          else
          {
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Assert the DMALBREQ from the destination peripheral */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));
          }
 
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
 
          CheckStatus(CHANNEL);

          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_18")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Source DMASREQ followed by
                           Destination DMABREQ and completing with
                           Destination DMALBREQ                     */
 
            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth *
                               P2PParams->DestBurst*2)/
                               P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);
 
            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMASREQ request and the destination peripheral initiates the
               DMABREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.  */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), (2*x));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*y) << 8));
 
            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
 
            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assert the DMALBREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));

              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALBREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
 
            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_19")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Destination DMALSREQ followed by
                           Source DMABREQ                      */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) P2PParams->DestWidth/P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMABREQ request and the destination peripheral initiates the
               DMALSREQ request.
               Bits 23-16 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMALSREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.  */

            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*y) << 8));

            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
        
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_20")
      {
        for (x=5;x>1;x--)
        {
          /* Objective : Assertion of Simultaneus Destination DMALSREQ and
                         Source DMABREQ                          */

          SrcPeriphNo();
          DestPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

          Write(DMACREQCONFIG, MasterConfig);
 
          DataXfers = (int) P2PParams->DestWidth/P2PParams->SrcWidth;

          if (DataXfers == 0) DataXfers = 1;

          ProgramResponse("P2P",
                           DataXfers,
                           P2PParams->SrcWidth,
                           P2PParams->DestWidth);

          /* Program the request generation of the source and destination
             peripherals such that the source peripheral initiates the
             DMABREQ request and the destination peripheral initiates the
             DMALSREQ request.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.
             Bits 15-8 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMABREQ request.         */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), (((2*x) + 1) << 16));
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));

          P2PDp(CHANNEL,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                P2PParams->LLIAddress,
                SrcPeripheral,
                DestPeripheral,
                P2PParams->SrcMaster,
                P2PParams->DestMaster,
                P2PParams->SrcWidth,
                P2PParams->DestWidth,
                P2PParams->SrcInc,
                P2PParams->DestInc,
                P2PParams->SrcBurst,
                P2PParams->DestBurst,
                P2PParams->TxSize,
                P2PParams->LLIMaster,
                P2PParams->Protection,
                P2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
      
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_21")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Source DMABREQ followed by
                           Destination DMALSREQ */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) P2PParams->DestWidth/P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMABREQ request and the destination peripheral initiates the
               DMALSREQ request.
               Bits 23-16 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMALSREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.  */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*y) << 16));

            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
        
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_22")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Destination DMALBREQ followed by
                           Source DMABREQ                      */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth *
                               P2PParams->DestBurst)/
                               P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMABREQ request and the destination peripheral initiates the
               DMALBREQ request.
               Bits 31-24 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMALBREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.   */

            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 24));
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*y) << 8));

            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
        
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_23")
      {
        for (x=5;x>1;x--)
        {
          /* Objective : Assertion of Simultaneus Destination DMALBREQ and
                         Source DMABREQ                          */

          SrcPeriphNo();
          DestPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

          Write(DMACREQCONFIG, MasterConfig);
 
          DataXfers = (int) (P2PParams->DestWidth *
                             P2PParams->DestBurst)/
                             P2PParams->SrcWidth;

          if (DataXfers == 0) DataXfers = 1;

          ProgramResponse("P2P",
                           DataXfers,
                           P2PParams->SrcWidth,
                           P2PParams->DestWidth);

          /* Program the request generation of the source and destination
             peripherals such that the source peripheral initiates the
             DMABREQ request and the destination peripheral initiates the
             DMALBREQ request.
             Bits 31-24 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALBREQ request.
             Bits 15-8 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMABREQ request.         */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), (((2*x) + 1) << 24));
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));

          P2PDp(CHANNEL,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                P2PParams->LLIAddress,
                SrcPeripheral,
                DestPeripheral,
                P2PParams->SrcMaster,
                P2PParams->DestMaster,
                P2PParams->SrcWidth,
                P2PParams->DestWidth,
                P2PParams->SrcInc,
                P2PParams->DestInc,
                P2PParams->SrcBurst,
                P2PParams->DestBurst,
                P2PParams->TxSize,
                P2PParams->LLIMaster,
                P2PParams->Protection,
                P2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
      
          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

          CheckStatus(CHANNEL);

          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_24")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Source DMABREQ followed by
                           Destination DMALBREQ */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth *
                               P2PParams->DestBurst)/
                               P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                              DataXfers,
                              P2PParams->SrcWidth,
                              P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMABREQ request and the destination peripheral initiates the
               DMALBREQ request.
               Bits 31-24 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMALBREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.   */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*y) << 24));

            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
        
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_25")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Destination DMASREQ followed by
                           Source DMABREQ and completing with Destination
                           DMALSREQ                                       */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth * 2)/P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMABREQ request and the destination peripheral initiates the
               DMASREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.  */

            Write(PeriphReg(DestPeripheral, PERIPHREQREG), (2*x));
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*y) << 8));

            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));

              Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_26")
      {
        for (x=5;x>1;x--)
        {
          /* Objective : Assertion of Simultaneus Destination DMASREQ and
                         Source DMABREQ and completing with Destination
                         DMALSREQ                                         */
 
          SrcPeriphNo();
          DestPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

          Write(DMACREQCONFIG, MasterConfig);
 
          DataXfers = (int) (P2PParams->DestWidth * 2) / P2PParams->SrcWidth;

          if (DataXfers == 0) DataXfers = 1;

          ProgramResponse("P2P",
                            DataXfers,
                            P2PParams->SrcWidth,
                            P2PParams->DestWidth);
 
          /* Program the request generation of the source and destination
             peripherals such that the source peripheral initiates the
             DMASREQ request and the destination peripheral initiates the
             DMALSREQ request.
             Bits 15-8 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMABREQ request.
             Bits 7-0 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMASREQ request.         */

          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) + 1));
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));
 
          P2PDp(CHANNEL,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                P2PParams->LLIAddress,
                SrcPeripheral,
                DestPeripheral,
                P2PParams->SrcMaster,
                P2PParams->DestMaster,
                P2PParams->SrcWidth,
                P2PParams->DestWidth,
                P2PParams->SrcInc,
                P2PParams->DestInc,
                P2PParams->SrcBurst,
                P2PParams->DestBurst,
                P2PParams->TxSize,
                P2PParams->LLIMaster,
                P2PParams->Protection,
                P2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
 
            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));

              Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));
            }

          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
 
          CheckStatus(CHANNEL);

          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_27")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Source DMABREQ followed by
                           Destination DMASREQ and completing with
                           Destination DMALSREQ                     */
 
            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth * 2) / P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                              DataXfers,
                              P2PParams->SrcWidth,
                              P2PParams->DestWidth);
 
            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMASREQ request and the destination peripheral initiates the
               DMASREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.    */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), (2*y));
 
            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
 
            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));

              Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
 
            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_28")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Destination DMABREQ followed by
                           Source DMABREQ and completing with Destination
                           DMALSREQ                                       */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth *
                              (P2PParams->DestBurst + 1))/
                               P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMABREQ request and the destination peripheral initiates the
               DMABREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.       */

            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*y) << 8));

            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));

              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_29")
      {
        for (x=5;x>1;x--)
        {
          /* Objective : Assertion of Simultaneus Destination DMABREQ and
                         Source DMABREQ and completing with Destination
                         DMALSREQ                                         */
 
          SrcPeriphNo();
          DestPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

          Write(DMACREQCONFIG, MasterConfig);
 
          DataXfers = (int) (P2PParams->DestWidth *
                            (P2PParams->DestBurst + 1))/
                             P2PParams->SrcWidth;

          if (DataXfers == 0) DataXfers = 1;

          ProgramResponse("P2P",
                           DataXfers,
                           P2PParams->SrcWidth,
                           P2PParams->DestWidth);
 
          /* Program the request generation of the source and destination
             peripherals such that the source peripheral initiates the
             DMABREQ request and the destination peripheral initiates the
             DMABREQ request.
             Bits 15-8 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMABREQ request.       */

          Write(PeriphReg(DestPeripheral, PERIPHREQREG), (((2*x) + 1) << 8));
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));
 
          P2PDp(CHANNEL,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                P2PParams->LLIAddress,
                SrcPeripheral,
                DestPeripheral,
                P2PParams->SrcMaster,
                P2PParams->DestMaster,
                P2PParams->SrcWidth,
                P2PParams->DestWidth,
                P2PParams->SrcInc,
                P2PParams->DestInc,
                P2PParams->SrcBurst,
                P2PParams->DestBurst,
                P2PParams->TxSize,
                P2PParams->LLIMaster,
                P2PParams->Protection,
                P2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
 
          if ((SrcError == 0) && (DestError == 0))
          {
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Assert the DMALSREQ from the destination peripheral */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));

            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

            Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
          }
          else
          {
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Assert the DMALSREQ from the destination peripheral */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));
          }

          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
 
          CheckStatus(CHANNEL);

          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_30")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Source DMABREQ followed by
                           Destination DMABREQ and completing with
                           Destination DMALSREQ                     */
 
            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth *
                              (P2PParams->DestBurst + 1))/
                               P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);
 
            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMABREQ request and the destination peripheral initiates the
               DMABREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.       */

            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*y) << 8));
 
            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
 
            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
  
              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));
  
              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
  
              Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
  
              Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
  
              /* Assert the DMALSREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 16));
            }
  
            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
 
            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_31")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Destination DMASREQ followed by
                           Source DMABREQ and completing with Destination
                           DMALBREQ                                       */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth *
                              (P2PParams->DestBurst + 1))/
                               P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMABREQ request and the destination peripheral initiates the
               DMASREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.   */

            Write(PeriphReg(DestPeripheral, PERIPHREQREG), (2*x));
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*y) << 8));

            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALBREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));

              Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALBREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_32")
      {
        for (x=5;x>1;x--)
        {
          /* Objective : Assertion of Simultaneus Destination DMASREQ and
                         Source DMABREQ and completing with Destination
                         DMALBREQ                                         */
 
          SrcPeriphNo();
          DestPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

          Write(DMACREQCONFIG, MasterConfig);
 
          DataXfers = (int) (P2PParams->DestWidth *
                            (P2PParams->DestBurst + 1))/
                             P2PParams->SrcWidth;

          if (DataXfers == 0) DataXfers = 1;

          ProgramResponse("P2P",
                           DataXfers,
                           P2PParams->SrcWidth,
                           P2PParams->DestWidth);
 
          /* Program the request generation of the source and destination
             peripherals such that the source peripheral initiates the
             DMASREQ request and the destination peripheral initiates the
             DMALBREQ request.
             Bits 15-8 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMABREQ request.
             Bits 7-0 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMASREQ request.         */

          Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) + 1));
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));
 
          P2PDp(CHANNEL,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                P2PParams->LLIAddress,
                SrcPeripheral,
                DestPeripheral,
                P2PParams->SrcMaster,
                P2PParams->DestMaster,
                P2PParams->SrcWidth,
                P2PParams->DestWidth,
                P2PParams->SrcInc,
                P2PParams->DestInc,
                P2PParams->SrcBurst,
                P2PParams->DestBurst,
                P2PParams->TxSize,
                P2PParams->LLIMaster,
                P2PParams->Protection,
                P2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
 
          if ((SrcError == 0) && (DestError == 0))
          {
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Assert the DMALBREQ from the destination peripheral */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));

            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

            Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }
          else
          {
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Assert the DMALBREQ from the destination peripheral */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));
          }

          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
 
          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_33")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Source DMABREQ followed by
                           Destination DMASREQ and completing with
                           Destination DMALBREQ                     */
 
            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth *
                              P2PParams->DestBurst*2)/
                              P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);
 
            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMABREQ request and the destination peripheral initiates the
               DMASREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.
               Bits 7-0 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.  */

            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), (2*y));
 
            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
 
            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assert the DMALBREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));

              Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assert the DMALBREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
 
            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_34")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Destination DMABREQ followed by
                           Source DMABREQ and completing with Destination
                           DMALBREQ                                       */

            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth *
                               P2PParams->DestBurst*2)/
                               P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);

            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMABREQ request and the destination peripheral initiates the
               DMABREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMABREQ request.       */

            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*x) << 8));
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*y) << 8));

            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);

            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALBREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));

              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

              /* Assert the DMALBREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_35")
      {
        for (x=5;x>1;x--)
        {
          /* Objective : Assertion of Simultaneus Destination DMABREQ and
                         Source DMABREQ and completing with Destination
                         DMALBREQ                                         */
 
          SrcPeriphNo();
          DestPeriphNo();

          MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                         (DMASTER << (DestPeripheral + 2));

          Write(DMACREQCONFIG, MasterConfig);
 
          DataXfers = (int) (P2PParams->DestWidth *
                             P2PParams->DestBurst*2)/
                             P2PParams->SrcWidth;

          if (DataXfers == 0) DataXfers = 1;

          ProgramResponse("P2P",
                           DataXfers,
                           P2PParams->SrcWidth,
                           P2PParams->DestWidth);
 
          /* Program the request generation of the source and destination
             peripherals such that the source peripheral initiates the
             DMABREQ request and the destination peripheral initiates the
             DMABREQ request.
             Bits 15-8 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMABREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG), (((2*x) + 1) << 8));
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));
 
          P2PDp(CHANNEL,
                AddrGen(PeriphLowAddress[SrcPeripheral],
                        PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                AddrGen(PeriphLowAddress[DestPeripheral],
                        PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                P2PParams->LLIAddress,
                SrcPeripheral,
                DestPeripheral,
                P2PParams->SrcMaster,
                P2PParams->DestMaster,
                P2PParams->SrcWidth,
                P2PParams->DestWidth,
                P2PParams->SrcInc,
                P2PParams->DestInc,
                P2PParams->SrcBurst,
                P2PParams->DestBurst,
                P2PParams->TxSize,
                P2PParams->LLIMaster,
                P2PParams->Protection,
                P2PParams->Lock,
                TCENABLE,
                TCMASK,
                ERRMASK);
 
            if ((SrcError == 0) && (DestError == 0))
          {
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Assert the DMALBREQ from the destination peripheral */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));

            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

            Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }
          else
          {
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Assert the DMALBREQ from the destination peripheral */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));
          }

          Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
 
          CheckStatus(CHANNEL);

          Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
          Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_36")
      {
        for (x=5;x>1;x--)
        {
          for (y=5;y>=x;y--)
          {
            /* Objective : Assertion of Source DMABREQ followed by
                           Destination DMABREQ and completing with
                           Destination DMALBREQ                     */
 
            SrcPeriphNo();
            DestPeriphNo();

            MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                           (DMASTER << (DestPeripheral + 2));

            Write(DMACREQCONFIG, MasterConfig);
 
            DataXfers = (int) (P2PParams->DestWidth *
                               P2PParams->DestBurst*2)/
                               P2PParams->SrcWidth;

            if (DataXfers == 0) DataXfers = 1;

            ProgramResponse("P2P",
                             DataXfers,
                             P2PParams->SrcWidth,
                             P2PParams->DestWidth);
 
            /* Program the request generation of the source and destination
               peripherals such that the source peripheral initiates the
               DMABREQ request and the destination peripheral initiates the
               DMABREQ request.
               Bits 15-8 in the request register of the peripheral indicates
               the number of clocks, to initiate the DMASREQ request.       */

            Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((2*y) << 8));
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((2*x) << 8));
 
            P2PDp(CHANNEL,
                  AddrGen(PeriphLowAddress[SrcPeripheral],
                          PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
                  AddrGen(PeriphLowAddress[DestPeripheral],
                          PeriphHighAddress[DestPeripheral]) & DestAddrMask,
                  P2PParams->LLIAddress,
                  SrcPeripheral,
                  DestPeripheral,
                  P2PParams->SrcMaster,
                  P2PParams->DestMaster,
                  P2PParams->SrcWidth,
                  P2PParams->DestWidth,
                  P2PParams->SrcInc,
                  P2PParams->DestInc,
                  P2PParams->SrcBurst,
                  P2PParams->DestBurst,
                  P2PParams->TxSize,
                  P2PParams->LLIMaster,
                  P2PParams->Protection,
                  P2PParams->Lock,
                  TCENABLE,
                  TCMASK,
                  ERRMASK);
 
            if ((SrcError == 0) && (DestError == 0))
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assert the DMALBREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));

              Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
            }
            else
            {
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
              Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

              /* Assert the DMALBREQ from the destination peripheral */
              Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((200) << 24));
            }

            Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
 
            CheckStatus(CHANNEL);

            Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
            Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
          }
        }
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_37")
      {
        /* Objective : Assertion of multiple(10) Source DMASREQ and
                       Destination DMASREQ and completing with
                       Destination DMALSREQ.                   */

        SrcPeriphNo();
        DestPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                       (DMASTER << (DestPeripheral + 2));

        Write(DMACREQCONFIG, MasterConfig);
 
        DataXfers = (int) (P2PParams->DestWidth * 11) / P2PParams->SrcWidth;

        if (DataXfers == 0) DataXfers = 1;

        ProgramResponse("P2P",
                         DataXfers,
                         P2PParams->SrcWidth,
                         P2PParams->DestWidth);

        /* Program the request generation of the source and destination
           peripherals such that the source peripheral initiates the
           DMASREQ request and the destination peripheral initiates the
           DMABREQ request.
           Bits 7-0 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMASREQ request.      */

        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((rand() % 15) + 1));
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((rand() % 15) + 1));

        P2PDp(CHANNEL,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              P2PParams->LLIAddress,
              SrcPeripheral,
              DestPeripheral,
              P2PParams->SrcMaster,
              P2PParams->DestMaster,
              P2PParams->SrcWidth,
              P2PParams->DestWidth,
              P2PParams->SrcInc,
              P2PParams->DestInc,
              P2PParams->SrcBurst,
              P2PParams->DestBurst,
              P2PParams->TxSize,
              P2PParams->LLIMaster,
              P2PParams->Protection,
              P2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Wait for the assertion of 10 DMASREQ requests from
             the source peripheral by sampling the SoftSREQ register */
          for (x=0;x<9;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Assertion of DMALSREQ signal from the destination peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                           ((((rand() % 8) + 1) * 10) << 16));

          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));
 
          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
        }
        else
        {
          /* Wait for the assertion of 10 DMASREQ requests from
             the source peripheral by sampling the SoftSREQ register */
          for (x=0;x<9;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            WaitLoop(32);
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Assertion of DMALSREQ signal from the destination peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                           ((((rand() % 8) + 1) * 10) << 16));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_38")
      {
        /* Objective : Assertion of multiple(10) Source DMASREQ and
                       Destination DMASREQ and completing with
                       Destination DMALBREQ.                   */

        SrcPeriphNo();
        DestPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                       (DMASTER << (DestPeripheral + 2));

        Write(DMACREQCONFIG, MasterConfig);
 
        DataXfers = (int) (P2PParams->DestWidth *
                          (P2PParams->DestBurst + 10))/
                           P2PParams->SrcWidth;

        if (DataXfers == 0) DataXfers = 1;

        ProgramResponse("P2P",
                         DataXfers,
                         P2PParams->SrcWidth,
                         P2PParams->DestWidth);

        /* Program the request generation of the source and destination
           peripherals such that the source peripheral initiates the
           DMASREQ request and the destination peripheral initiates the
           DMABREQ request.
           Bits 7-0 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMASREQ request.      */

        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((rand() % 15) + 1));
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((rand() % 15) + 1));

        P2PDp(CHANNEL,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              P2PParams->LLIAddress,
              SrcPeripheral,
              DestPeripheral,
              P2PParams->SrcMaster,
              P2PParams->DestMaster,
              P2PParams->SrcWidth,
              P2PParams->DestWidth,
              P2PParams->SrcInc,
              P2PParams->DestInc,
              P2PParams->SrcBurst,
              P2PParams->DestBurst,
              P2PParams->TxSize,
              P2PParams->LLIMaster,
              P2PParams->Protection,
              P2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Wait for the assertion of 10 DMASREQ requests from
             the source peripheral by sampling the SoftSREQ register */
          for (x=0;x<9;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Assertion of DMALSREQ signal from the destination peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                           ((((rand() % 15) + 1) * 10) << 24));

          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));
 
          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
        }
        else
        {
          /* Wait for the assertion of 10 DMASREQ requests from
             the source peripheral by sampling the SoftSREQ register */
          for (x=0;x<9;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            WaitLoop(32);
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Assertion of DMALSREQ signal from the destination peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                           ((((rand() % 15) + 1) * 10) << 24));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_39")
      {
        /* Objective : Assertion of multiple(10) Source DMABREQ and
                       Destination DMABREQ and completing with
                       Destination DMALSREQ.                   */

        SrcPeriphNo();
        DestPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                       (DMASTER << (DestPeripheral + 2));

        Write(DMACREQCONFIG, MasterConfig);
 
        DataXfers = (int) (P2PParams->DestWidth *
                           P2PParams->DestBurst * 10)/
                           P2PParams->SrcWidth;

        if (DataXfers == 0) DataXfers = 1;

        ProgramResponse("P2P",
                         DataXfers,
                         P2PParams->SrcWidth,
                         P2PParams->DestWidth);

        /* Program the request generation of the source and destination
           peripherals such that the source peripheral initiates the
           DMABREQ request and the destination peripheral initiates the
           DMABREQ request.
           Bits 15-8 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMASREQ request.   */

        Write(PeriphReg(SrcPeripheral, PERIPHREQREG),
               (((rand() % 15) + 1) << 8));
        Write(PeriphReg(DestPeripheral, PERIPHREQREG),
               (((rand() % 15) + 1) << 8));

        P2PDp(CHANNEL,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              P2PParams->LLIAddress,
              SrcPeripheral,
              DestPeripheral,
              P2PParams->SrcMaster,
              P2PParams->DestMaster,
              P2PParams->SrcWidth,
              P2PParams->DestWidth,
              P2PParams->SrcInc,
              P2PParams->DestInc,
              P2PParams->SrcBurst,
              P2PParams->DestBurst,
              P2PParams->TxSize,
              P2PParams->LLIMaster,
              P2PParams->Protection,
              P2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Wait for the assertion of 10 DMASREQ requests from
             the source peripheral by sampling the SoftSREQ register */
          for (x=0;x<9;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Assertion of DMALSREQ signal from the destination peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                 ((((rand() % 15) + 1) * 10) << 16));

          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
 
          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
        }
        else
        {
          /* Wait for the assertion of 10 DMASREQ requests from
             the source peripheral by sampling the SoftSREQ register */
          for (x=0;x<9;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            WaitLoop(32 * P2PParams->DestBurst);
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Assertion of DMALSREQ signal from the destination peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                 ((((rand() % 15) + 1) * 10) << 16));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_40")
      {
        /* Objective : Assertion of multiple(10) Source DMABREQ and
                       Destination DMABREQ and completing with
                       Destination DMALBREQ.                   */

        SrcPeriphNo();
        DestPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                       (DMASTER << (DestPeripheral + 2));

        Write(DMACREQCONFIG, MasterConfig);
 
        DataXfers = (int) (P2PParams->DestWidth *
                           P2PParams->DestBurst * 11)/
                           P2PParams->SrcWidth;

        if (DataXfers == 0) DataXfers = 1;

        ProgramResponse("P2P",
                         DataXfers,
                         P2PParams->SrcWidth,
                         P2PParams->DestWidth);

        /* Program the request generation of the source and destination
           peripherals such that the source peripheral initiates the
           DMABREQ request and the destination peripheral initiates the
           DMABREQ request.
           Bits 15-8 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMABREQ request.      */

        Write(PeriphReg(SrcPeripheral, PERIPHREQREG),
                         (((rand() % 15) + 1) << 8));
        Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                         (((rand() % 15) + 1) << 8));

        P2PDp(CHANNEL,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              P2PParams->LLIAddress,
              SrcPeripheral,
              DestPeripheral,
              P2PParams->SrcMaster,
              P2PParams->DestMaster,
              P2PParams->SrcWidth,
              P2PParams->DestWidth,
              P2PParams->SrcInc,
              P2PParams->DestInc,
              P2PParams->SrcBurst,
              P2PParams->DestBurst,
              P2PParams->TxSize,
              P2PParams->LLIMaster,
              P2PParams->Protection,
              P2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Wait for the assertion of 10 DMASREQ requests from
             the source peripheral by sampling the SoftSREQ register */
          for (x=0;x<9;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Assertion of DMALSREQ signal from the destination peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                 ((((rand() % 15) + 1) * 10) << 24));

          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
 
          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
        }
        else
        {
          /* Wait for the assertion of 10 DMASREQ requests from
             the source peripheral by sampling the SoftSREQ register */
          for (x=0;x<9;x++)
          {
            /* Poll for the DMACSoftSReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            WaitLoop(32 * P2PParams->DestBurst);
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Assertion of DMALSREQ signal from the destination peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                 ((((rand() % 15) + 1) * 10) << 24));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_41")
      {
        /* Objective : Assertion of multiple(10) Source DMABREQ,
                       Source DMASREQ, Destination DMASREQ and
                       Destination DMABREQ and completing with
                       Destination DMALSREQ.                   */

        SrcPeriphNo();
        DestPeriphNo();

        MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                       (DMASTER << (DestPeripheral + 2));

        Write(DMACREQCONFIG, MasterConfig);
 
        DataXfers = (int) (P2PParams->DestWidth *
                          (P2PParams->DestBurst*10) + 11) /
                           P2PParams->SrcWidth;

        if (DataXfers == 0) DataXfers = 1;

        ProgramResponse("P2P",
                         DataXfers,
                         P2PParams->SrcWidth,
                         P2PParams->DestWidth);

        /* Program the request generation of the source and destination
           peripherals such that the source peripheral initiates the
           DMABREQ request and the destination peripheral initiates the
           DMASREQ request.
           Bits 15-8 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMABREQ request.
           Bits 7-0 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMASREQ request.      */

        Write(PeriphReg(SrcPeripheral, PERIPHREQREG),
               (((rand() % 15) + 1) << 8));
        Write(PeriphReg(DestPeripheral, PERIPHREQREG),
               ((rand() % 15) + 1));

        P2PDp(CHANNEL,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              P2PParams->LLIAddress,
              SrcPeripheral,
              DestPeripheral,
              P2PParams->SrcMaster,
              P2PParams->DestMaster,
              P2PParams->SrcWidth,
              P2PParams->DestWidth,
              P2PParams->SrcInc,
              P2PParams->DestInc,
              P2PParams->SrcBurst,
              P2PParams->DestBurst,
              P2PParams->TxSize,
              P2PParams->LLIMaster,
              P2PParams->Protection,
              P2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Wait for the assertion of 10 DMABREQ requests from
             the source peripheral by sampling the SoftBREQ register */
          for (x=0;x<9;x++)
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Program the Destination peripheral to initiate BREQ */
          /* Bits 7-0 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMASREQ request.      */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                           (((rand() % 15) + 1) << 8));

          /* Program the Source peripheral to initiate SREQ */
          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          /* Bits 15-8 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMABREQ request.      */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG),
                  ((rand() % 15) + 1));

          for (x=0;x<9;x++)
          {
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          /* Assertion of DMALSREQ signal from the destination peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                 ((((rand() % 15) + 1) * 10) << 16));

          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
 
          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
        }
        else
        {
          /* Wait for the assertion of 10 DMABREQ requests from
             the source peripheral by sampling the SoftBREQ register */
          for (x=0;x<9;x++)
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            WaitLoop(32);
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Assertion of DMALSREQ signal from the destination peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                 ((((rand() % 15) + 1) * 10) << 16));

        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_42")
      {
        /* Objective : Assertion of multiple(10) Source DMABREQ,
                       Source DMASREQ, Destination DMASREQ and
                       Destination DMABREQ and completing with
                       Destination DMALBREQ.                   */

        SrcPeriphNo();
        DestPeriphNo();


        MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                       (DMASTER << (DestPeripheral + 2));

        Write(DMACREQCONFIG, MasterConfig);
 
        DataXfers = (int) (P2PParams->DestWidth *
                          (P2PParams->DestBurst * 11) + 10) /
                           P2PParams->SrcWidth;

        if (DataXfers == 0) DataXfers = 1;

        ProgramResponse("P2P",
                         DataXfers,
                         P2PParams->SrcWidth,
                         P2PParams->DestWidth);

        /* Program the request generation of the source and destination
           peripherals such that the source peripheral initiates the
           DMABREQ request and the destination peripheral initiates the
           DMASREQ request.
           Bits 15-8 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMABREQ request.
           Bits 7-0 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMASREQ request.      */

        Write(PeriphReg(SrcPeripheral, PERIPHREQREG),
                         (((rand() % 15) + 1) << 8));
        Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                         ((rand() % 15) + 1));

        P2PDp(CHANNEL,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              P2PParams->LLIAddress,
              SrcPeripheral,
              DestPeripheral,
              P2PParams->SrcMaster,
              P2PParams->DestMaster,
              P2PParams->SrcWidth,
              P2PParams->DestWidth,
              P2PParams->SrcInc,
              P2PParams->DestInc,
              P2PParams->SrcBurst,
              P2PParams->DestBurst,
              P2PParams->TxSize,
              P2PParams->LLIMaster,
              P2PParams->Protection,
              P2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Wait for the assertion of 10 DMABREQ requests from
             the source peripheral by sampling the SoftBREQ register */
          for (x=0;x<9;x++)
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Program the Destination peripheral to initiate BREQ */
          /* Bits 7-0 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMASREQ request.      */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                           (((rand() % 15) + 1) << 8));

          /* Program the Source peripheral to initiate SREQ */
          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          /* Bits 15-8 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMABREQ request.      */
          Write(PeriphReg(SrcPeripheral, PERIPHREQREG),
                  ((rand() % 15) + 1));

          for (x=0;x<9;x++)
          {
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          /* Assertion of DMALSREQ signal from the destination peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                 ((((rand() % 15) + 1) * 10) << 24));

          /* Poll for the DMACSoftSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
 
          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
        }
        else
        {
          /* Wait for the assertion of 10 DMABREQ requests from
             the source peripheral by sampling the SoftBREQ register */
          for (x=0;x<9;x++)
          {
            /* Poll for the DMACSoftBReq bit to be reset
               after the DMA transfer */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
            WaitLoop(32);
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Assertion of DMALSREQ signal from the destination peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                 ((((rand() % 15) + 1) * 10) << 24));
        }
        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_43")
      {
        /* Objective : Assertion of alternate Source DMASREQ,
                       Source DMABREQ, and alternate
                       Destination DMASREQ, Destination DMABREQ and
                       completing with Destination DMALSREQ.       */

        SrcPeriphNo();
        DestPeriphNo();


        MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                       (DMASTER << (DestPeripheral + 2));

        Write(DMACREQCONFIG, MasterConfig);
 
        DataXfers = (int) (P2PParams->DestWidth *
                          (P2PParams->DestBurst*10) + 11) /
                           P2PParams->SrcWidth;

        if (DataXfers == 0) DataXfers = 1;

        ProgramResponse("P2P",
                         DataXfers,
                         P2PParams->SrcWidth,
                         P2PParams->DestWidth);

        /* Program the request generation of the source and destination
           peripherals such that the source peripheral initiates the
           DMASREQ request and the destination peripheral initiates the
           DMASREQ request.
           Bits 7-0 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMASREQ request.      */

        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((rand() % 15) + 1));
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((rand() % 15) + 1));

        P2PDp(CHANNEL,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              P2PParams->LLIAddress,
              SrcPeripheral,
              DestPeripheral,
              P2PParams->SrcMaster,
              P2PParams->DestMaster,
              P2PParams->SrcWidth,
              P2PParams->DestWidth,
              P2PParams->SrcInc,
              P2PParams->DestInc,
              P2PParams->SrcBurst,
              P2PParams->DestBurst,
              P2PParams->TxSize,
              P2PParams->LLIMaster,
              P2PParams->Protection,
              P2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Wait for the assertion of 10 alternate single and
             burst requests from both source and destination peripherals */
          for (x=0;x<9;x++)
          {
            /* Poll for the single request from the source
               peripheral to be initiated.               */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Program the source peripheral for initiating a burst request */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG),
                             (((rand() % 15) + 1) << 8));

            /* Poll for the single request from the destination
               peripheral to be initiated.               */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            /* Program the destination peripheral for initiating
               a burst request */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                             (((rand() % 15) + 1) << 8));

            /* Poll for both the requests to be serviced by the DMA */
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

            /* Poll for the burst request from the source
               peripheral to be initiated.               */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Program the source peripheral for initiating a single request */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG),
                             ((rand() % 15) + 1));

            /* Poll for the burst request from the destination
               peripheral to be initiated.               */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            /* Program the destination peripheral for initiating
               a single request */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                             ((rand() % 15) + 1));

            /* Poll for both the requests to be serviced by the DMA */
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Assertion of DMALSREQ signal from the destination peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                            ((((rand() % 15) + 1) * 10) << 16));

          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          Poll(DMACSoftLSReq, 0x00000000, (0x00000001 << DestPeripheral));
        }
        else
        {
          for (x=0;x<9;x++)
          {
            WaitLoop(32 * P2PParams->DestBurst);
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Assertion of DMALSREQ signal from the destination peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                            ((((rand() % 15) + 1) * 10) << 16));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);
  
        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      else if (TestCases->CaseNumber == "DMA_P2P_DP_44")
      {
        /* Objective : Assertion of alternate Source DMASREQ,
                       Source DMABREQ, and alternate
                       Destination DMASREQ, Destination DMABREQ and
                       completing with Destination DMALBREQ.       */

        SrcPeriphNo();
        DestPeriphNo();


        MasterConfig = (SMASTER << (SrcPeripheral + 2)) |
                       (DMASTER << (DestPeripheral + 2));

        Write(DMACREQCONFIG, MasterConfig);
 
        DataXfers = (int) (P2PParams->DestWidth *
                          (P2PParams->DestBurst*11) + 10) /
                           P2PParams->SrcWidth;

        if (DataXfers == 0) DataXfers = 1;

        ProgramResponse("P2P",
                         DataXfers,
                         P2PParams->SrcWidth,
                         P2PParams->DestWidth);

        /* Program the request generation of the source and destination
           peripherals such that the source peripheral initiates the
           DMASREQ request and the destination peripheral initiates the
           DMASREQ request.
           Bits 7-0 in the request register of the peripheral indicates
           the number of clocks, to initiate the DMASREQ request.      */

        Write(PeriphReg(SrcPeripheral, PERIPHREQREG), ((rand() % 15) + 1));
        Write(PeriphReg(DestPeripheral, PERIPHREQREG), ((rand() % 15) + 1));

        P2PDp(CHANNEL,
              AddrGen(PeriphLowAddress[SrcPeripheral],
                      PeriphHighAddress[SrcPeripheral]) & SrcAddrMask,
              AddrGen(PeriphLowAddress[DestPeripheral],
                      PeriphHighAddress[DestPeripheral]) & DestAddrMask,
              P2PParams->LLIAddress,
              SrcPeripheral,
              DestPeripheral,
              P2PParams->SrcMaster,
              P2PParams->DestMaster,
              P2PParams->SrcWidth,
              P2PParams->DestWidth,
              P2PParams->SrcInc,
              P2PParams->DestInc,
              P2PParams->SrcBurst,
              P2PParams->DestBurst,
              P2PParams->TxSize,
              P2PParams->LLIMaster,
              P2PParams->Protection,
              P2PParams->Lock,
              TCENABLE,
              TCMASK,
              ERRMASK);

        if ((SrcError == 0) && (DestError == 0))
        {
          /* Wait for the assertion of 10 alternate single and
             burst requests from both source and destination peripherals */
          for (x=0;x<9;x++)
          {
            /* Poll for the single request from the source
               peripheral to be initiated.               */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Program the source peripheral for initiating a burst request */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG),
                             (((rand() % 15) + 1) << 8));

            /* Poll for the single request from the destination
               peripheral to be initiated.               */
            Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            /* Program the destination peripheral for initiating
               a burst request */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                             (((rand() % 15) + 1) << 8));

            /* Poll for both the requests to be serviced by the DMA */
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftSReq, 0x00000000, (0x00000001 << DestPeripheral));

            /* Poll for the burst request from the source
               peripheral to be initiated.               */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));

            /* Program the source peripheral for initiating a single request */
            Write(PeriphReg(SrcPeripheral, PERIPHREQREG),
                             ((rand() % 15) + 1));

            /* Poll for the burst request from the destination
               peripheral to be initiated.               */
            Poll(DMACSoftBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

            /* Program the destination peripheral for initiating
               a single request */
            Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                             ((rand() % 15) + 1));

            /* Poll for both the requests to be serviced by the DMA */
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << SrcPeripheral));
            Poll(DMACSoftBReq, 0x00000000, (0x00000001 << DestPeripheral));
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << SrcPeripheral));
          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Assertion of DMALSREQ signal from the destination peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                            ((((rand() % 15) + 1) * 10) << 24));

          /* Poll for the DMACSoftLSReq bit to be reset
             after the DMA transfer */
          Poll(DMACSoftLBReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));
          Poll(DMACSoftLBReq, 0x00000000, (0x00000001 << DestPeripheral));
        }
        else
        {
          for (x=0;x<9;x++)
          {
            WaitLoop(32 * P2PParams->DestBurst);
          }

          Poll(DMACSoftSReq, 0xFFFFFFFF, (0x00000001 << DestPeripheral));

          /* Assertion of DMALSREQ signal from the destination peripheral.
             Bits 23-16 in the request register of the peripheral indicates
             the number of clocks, to initiate the DMALSREQ request.       */
          Write(PeriphReg(DestPeripheral, PERIPHREQREG),
                            ((((rand() % 15) + 1) * 10) << 24));
        }

        /* Check that the Channel is disabled */
        Poll(ConfigRegs[CHANNEL], 0x00000000, 0x00000001);

        CheckStatus(CHANNEL);

        Write(PeriphReg(SrcPeripheral, PERIPHENREG), PERIPHRESET);
        Write(PeriphReg(DestPeripheral, PERIPHENREG), PERIPHRESET);
      }
      P2PParams++;
    }
    TestCases++;
  }
}
/************************************ End *************************************/
