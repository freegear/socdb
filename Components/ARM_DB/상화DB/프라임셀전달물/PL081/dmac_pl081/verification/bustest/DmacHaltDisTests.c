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
-- File Name              : DmacHaltDisTests.c.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This file contains Halt/Disable test cases.
-- --=========================================================================*/

/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** ChannelPrgm                                DmacCommon.c                ***/
/*** SlavePrgm                                  DmacCommon.c                ***/
/*** AddrGen                                    DmacCommon.c                ***/
/*** AddressSelection                           DmacCommon.c                ***/
/*** SbValue                                    DmacCommon.c                ***/
/*** DbValue                                    DmacCommon.c                ***/
/*** SwValue                                    DmacCommon.c                ***/
/*** DwValue                                    DmacCommon.c                ***/
/*** SmValue                                    DmacCommon.c                ***/
/*** DmValue                                    DmacCommon.c                ***/
/*** SiValue                                    DmacCommon.c                ***/
/*** DiValue                                    DmacCommon.c                ***/
/*** Poll                                       DmacCommon.c                ***/
/******************************************************************************/

void DMACHaltDisTests()
{
  /*
    Overview : DMACHaltDisTests
    ============================
    The function is used to test the implementation of Halt and Disable
    functionality of DMA Controller. The Halt/Disable test parameters are
    defined by using structure DisableTestPara. If the source slave is memory
    module and if source AHB master is Master1, memory module 0 is selected as
    source slave module else module 1 is selected. The function calls
    AddressSelction function to determine source peripheral address range. It
    calls AddrGen function to determine source address. The TempPerpMaster
    variable indicates source/destination peripheral module is configured to
    Master2. The function sets respective bit of source memory or peripheral if
    source AHB master is Master2. If the Destination slave is memory module and
    destination AHB master is Master 1 then function selects memory module 1 as
    destination slave module else selects memory module 1.  The function
    determines destination peripheral address range and destination address. It
    determine control information of CxControl register and calls ChannelPrgm
    function to program channel. It programs slave peripherals by calling
    SlavePrgm function. The function enables channel by programming DMAC config
    register. The function asserts peripheral requests. To program peripheral
    requests, the register base address of peripheral is determined by calling
    SlaveAddressSelction function. After some source/destination data transfer,
    the function Halts/Disable DMAC. By setting HALT bit in DMAC config
    register, DMAC gets HALT.  The DMAC is disabled by writing zero in channel
    enable bit. After some clock duration, HALT bit is cleared and channel
    enable bit is polled going low. After clearing HALT bit, DMAC should
    complete remaining burst data transfer. If the DMAC is disabled, it aborts
    data transfer. 
  */

  /* Define test parameters */
  struct DisableTestPara {
     int   Channel;
     int32 FlowControl;
     int32 SrcMaster;
     int32 DestMaster;
     int32 SrcWidth;
     int32 DestWidth;
     char* SrcIncr;
     char* DestIncr;
     int32 SrcBurst;
     int32 DestBurst;
     int32 TxSize;
     int32 SrcPeriph;
     int32 DestPeriph;
     int32 DMAC_Disable;
     int32 DMAC_Halt;
    };

  /* Define Test No and It test parameters */
  struct DisableCases {
     char *TestNo;
     struct DisableTestPara *ChannelPara;
    };

  /* Define DMA requests parameters */
  struct DMACReqPara {
     int  SrcSREQ;
     int  SrcBREQ;
     int  SrcLSREQ;
     int  SrcLBREQ;
     int  DestSREQ;
     int  DestBREQ;
     int  DestLSREQ;
     int  DestLBREQ; 
    };

  /* Define Test Number and its number of DMA requests */
  struct DisPeriphReq {
     char *TestNo;
     struct DMACReqPara *ReqPara;
    };

  /* Test Case Parameters */ 
  struct DisableTestPara TestCase[] = {
     0, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, DMACDISABLE, 0,
     1, P2MDMAC, 0, 0, 16, 16, "NI",  "I",  8,  1, 75,    5, NA, DMACDISABLE, 0,
     2, M2PDMAC, 1, 0, 32, 32,  "I", "NI",  4,  1, 50,   NA,  8, DMACDISABLE, 0,
     3, P2PDMAC, 1, 1, 32,  8,  "I",  "I",  4,  4, 25,   12, 10, DMACDISABLE, 0,
     4, P2PSP,   0, 0,  8, 16, "NI", "NI", 16, 16, ZERO,  1,  3, DMACDISABLE, 0,
     5, P2MSP,   0, 1, 16,  8, "NI",  "I",  8,  8, ZERO,  4, NA, DMACDISABLE, 0,
     6, M2PDP,   1, 0, 32, 16,  "I", "NI",  8,  8, ZERO, NA,  9, DMACDISABLE, 0,
     7, P2PDP,   1, 1,  8, 32,  "I",  "I", 32, 32, ZERO,  2,  7, DMACDISABLE, 0,
     0, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, 0, DMACHALT,
     1, P2MDMAC, 0, 0, 16, 16, "NI",  "I",  8,  1, 75,    5, NA, 0, DMACHALT,
     2, M2PDMAC, 1, 0, 32, 32,  "I", "NI",  4,  1, 50,   NA,  8, 0, DMACHALT,
     3, P2PDMAC, 1, 1, 32,  8,  "I",  "I",  4,  4, 25,   12, 10, 0, DMACHALT,
     4, P2PSP,   0, 0,  8, 16, "NI", "NI", 16, 16, ZERO,  1,  3, 0, DMACHALT,
     5, P2MSP,   0, 1, 16,  8, "NI",  "I",  8,  8, ZERO,  4, NA, 0, DMACHALT,
     6, M2PDP,   1, 0, 32, 16,  "I", "NI",  8,  8, ZERO, NA,  9, 0, DMACHALT,
     7, P2PDP,   1, 1,  8, 32,  "I",  "I", 32, 32, ZERO,  2,  7, 0, DMACHALT, 
     0, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16, 16, 100,  NA, NA, DMACDISABLE, 0,
     1, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, DMACDISABLE, 0,
     2, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, DMACDISABLE, 0,
     3, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, DMACDISABLE, 0,
     4, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, DMACDISABLE, 0,
     5, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, DMACDISABLE, 0,
     6, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, DMACDISABLE, 0,
     7, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, DMACDISABLE, 0,
     0, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16, 16, 100,  NA, NA, DMACDISABLE, 0,
     1, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16, 16, 100,  NA, NA, DMACDISABLE, 0,
     2, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16, 16, 100,  NA, NA, DMACDISABLE, 0,
     3, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16, 16, 100,  NA, NA, DMACDISABLE, 0,
     4, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16, 16, 100,  NA, NA, DMACDISABLE, 0,
     5, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16, 16, 100,  NA, NA, DMACDISABLE, 0,
     6, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16, 16, 100,  NA, NA, DMACDISABLE, 0,
     7, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16, 16, 100,  NA, NA, DMACDISABLE, 0,
     1, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16, 16, 100,  NA, NA, DMACDISABLE, 0,
     2, M2MDMAC, 1, 1,  8,  8, "NI", "NI", 16, 16, 100,  NA, NA, DMACDISABLE, 0,
     3, M2MDMAC, 1, 1,  8,  8, "NI", "NI", 16, 16, 100,  NA, NA, DMACDISABLE, 0,
     4, M2MDMAC, 1, 1,  8,  8, "NI", "NI", 16, 16, 100,  NA, NA, DMACDISABLE, 0,
     5, M2MDMAC, 1, 1,  8,  8, "NI", "NI", 16, 16, 100,  NA, NA, DMACDISABLE, 0,
     6, M2MDMAC, 1, 1,  8,  8, "NI", "NI", 16, 16, 100,  NA, NA, DMACDISABLE, 0,
     7, M2MDMAC, 1, 1,  8,  8, "NI", "NI", 16, 16, 100,  NA, NA, DMACDISABLE, 0,
     0, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, DMACDISABLE, 0,
     1, M2MDMAC, 0, 0,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, DMACDISABLE, 0,
     2, M2MDMAC, 1, 1,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, DMACDISABLE, 0,
     3, M2MDMAC, 1, 1,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, DMACDISABLE, 0,
     4, M2MDMAC, 1, 1,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, DMACDISABLE, 0,
     5, M2MDMAC, 1, 1,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, DMACDISABLE, 0,
     6, M2MDMAC, 1, 1,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, DMACDISABLE, 0,
     7, M2MDMAC, 1, 1,  8,  8, "NI", "NI", 16,  1, 100,  NA, NA, DMACDISABLE, 0
    };

  struct DisableCases DisableTestCases [] = {
     "DMAC_DISABLE_1",  &TestCase[0],
     "DMAC_DISABLE_2",  &TestCase[1],
#ifdef MORETHAN2CHS
     "DMAC_DISABLE_3",  &TestCase[2],
     "DMAC_DISABLE_4",  &TestCase[3],
#endif
#ifdef MORETHAN4CHS
     "DMAC_DISABLE_5",  &TestCase[4],
     "DMAC_DISABLE_6",  &TestCase[5],
     "DMAC_DISABLE_7",  &TestCase[6],
     "DMAC_DISABLE_8",  &TestCase[7],
#endif
     "DMAC_HALT_1",     &TestCase[8],
     "DMAC_HALT_2",     &TestCase[9],
#ifdef MORETHAN2CHS
     "DMAC_HALT_3",     &TestCase[10],
     "DMAC_HALT_4",     &TestCase[11],
#endif
#ifdef MORETHAN4CHS
     "DMAC_HALT_5",     &TestCase[12],
     "DMAC_HALT_6",     &TestCase[13],
     "DMAC_HALT_7",     &TestCase[14],
     "DMAC_HALT_8",     &TestCase[15],
#endif
     "DMAC_DISABLE_9",  &TestCase[16],
     "DMAC_DISABLE_10", &TestCase[17],
#ifdef MORETHAN2CHS
     "DMAC_DISABLE_11", &TestCase[18],
     "DMAC_DISABLE_12", &TestCase[19],
#endif
#ifdef MORETHAN4CHS
     "DMAC_DISABLE_13", &TestCase[20],
     "DMAC_DISABLE_14", &TestCase[21],
     "DMAC_DISABLE_15", &TestCase[22],
     "DMAC_DISABLE_16", &TestCase[23],
#endif
     "DMAC_DISABLE_17", &TestCase[24],
     "DMAC_DISABLE_18", &TestCase[25],
#ifdef MORETHAN2CHS
     "DMAC_DISABLE_19", &TestCase[26],
     "DMAC_DISABLE_20", &TestCase[27],
#endif
#ifdef MORETHAN4CHS
     "DMAC_DISABLE_21", &TestCase[28],
     "DMAC_DISABLE_22", &TestCase[29],
     "DMAC_DISABLE_23", &TestCase[30],
     "DMAC_DISABLE_24", &TestCase[31],
#endif
     "DMAC_DISABLE_25", &TestCase[32],
#ifdef MORETHAN2CHS
     "DMAC_DISABLE_26", &TestCase[33],
     "DMAC_DISABLE_27", &TestCase[34],
#endif
#ifdef MORETHAN4CHS
     "DMAC_DISABLE_28", &TestCase[35],
     "DMAC_DISABLE_29", &TestCase[36],
     "DMAC_DISABLE_30", &TestCase[37],
     "DMAC_DISABLE_31", &TestCase[38],
#endif
     "DMAC_DISABLE_32", &TestCase[39],
     "DMAC_DISABLE_33", &TestCase[40],
#ifdef MORETHAN2CHS
     "DMAC_DISABLE_34", &TestCase[41],
     "DMAC_DISABLE_35", &TestCase[42],
#endif
#ifdef MORETHAN4CHS
     "DMAC_DISABLE_36", &TestCase[43],
     "DMAC_DISABLE_37", &TestCase[44],
     "DMAC_DISABLE_38", &TestCase[45],
     "DMAC_DISABLE_39", &TestCase[46],
#endif
     "ENDOFTEST",       &TestCase[0]
    };

  struct DMACReqPara DMARequest [] = {
     0,  1, 0, 0, 0,  0, 0, 0,
     0,  0, 0, 0, 0,  1, 0, 0,
     0, 10, 0, 0, 0,  1, 0, 0,
     0, 10, 0, 0, 0,  0, 0, 0,
     0,  0, 0, 0, 0, 10, 0, 0,
     0,  1, 0, 0, 0, 10, 0, 0
    };

  struct DisPeriphReq DisableTestReq [] = {
     "DMAC_DISABLE_2", &DMARequest[0],
#ifdef MORETHAN2CHS
     "DMAC_DISABLE_3", &DMARequest[1],
     "DMAC_DISABLE_4", &DMARequest[2],
#endif
#ifdef MORETHAN4CHS
     "DMAC_DISABLE_5", &DMARequest[2],
     "DMAC_DISABLE_6", &DMARequest[0],
     "DMAC_DISABLE_7", &DMARequest[1],
     "DMAC_DISABLE_8", &DMARequest[2],
#endif
     "DMAC_HALT_2",    &DMARequest[0],
#ifdef MORETHAN2CHS
     "DMAC_HALT_3",    &DMARequest[1],
     "DMAC_HALT_4",    &DMARequest[2],
#endif
#ifdef MORETHAN4CHS
     "DMAC_HALT_5",    &DMARequest[2],
     "DMAC_HALT_6",    &DMARequest[3],
     "DMAC_HALT_7",    &DMARequest[4],
     "DMAC_HALT_8",    &DMARequest[5],
     "EOFREQCASE",     &DMARequest[0]
#endif
    };

  int32 SrcAddrMask, DestAddrMask;
  int32 Addr, *RegAddr, CxLLIRegData, CxControlRegData, CxConfigData;
  int32 SrcAddr, DestAddr;
  int32 SrcInfo, DestInfo, TempPerpMaster, MaskValue;
  int32 SrcPeriphValue, DestPeriphValue;
  int32 TCCOUNT2 = 0x0, CLRCOUNT2 = 0x0;
  int   SrcBREQ;
  int   SrcSREQ;
  int   SrcLBREQ;
  int   SrcLSREQ;
  int   DestBREQ;
  int   DestSREQ;
  int   DestLBREQ;
  int   DestLSREQ;
  int32 SrcReqCount = 0x00000000;
  int32 DestReqCount = 0x00000000;
  int32 Count = 0x00000000;
  int i = 0;
  char Message[100];
     
  struct DisableCases *TestCases = DisableTestCases;

  /* Disable Trickbox */
  Write(DMACTRICKEN, 0x00000000);

  while (TestCases->TestNo != "ENDOFTEST")
  {
     struct DisableTestPara *TestCasePara = TestCases->ChannelPara;

     sprintf(Message,"Test No : %s", TestCases->TestNo);
     C(Message);

     sprintf(Message," Channel : %d\n FlowControl : %x\nSW : %d\nDW : %d\n"
                      " SB : %d\nDB : %d\nTxSize : %d\nSM : %d\nDM : %d",
             TestCasePara->Channel,
             TestCasePara->FlowControl,
             TestCasePara->SrcWidth,
             TestCasePara->DestWidth,
             TestCasePara->SrcBurst,
             TestCasePara->DestBurst,
             TestCasePara->TxSize,
             TestCasePara->SrcMaster,
             TestCasePara->DestMaster);
     msg_info(Message);

     /* Clear pending interrupts if any */
     Write(DMACIntTCClr, 0x000000FF);
     Write(DMACIntErrClr, 0x000000FF);

     /* Determine source address mask */
     if (TestCasePara->SrcWidth == 8)
       SrcAddrMask = 0xFFFFFFFF;
     else if (TestCasePara->SrcWidth == 16)
       SrcAddrMask = 0xFFFFFFFE;
     else
       SrcAddrMask = 0xFFFFFFFC;

     /* Determine destination address mask */
     if (TestCasePara->DestWidth == 8)
       DestAddrMask = 0xFFFFFFFF;
     else if (TestCasePara->DestWidth == 16)
       DestAddrMask = 0xFFFFFFFE;
     else
       DestAddrMask = 0xFFFFFFFC;

     /*
       The TempPerpMaster variable is used to indicate memory/peripheral module
       is configured for Master2. If the source/Destination memory/peripheral
       module is configured for master 2, the respective bit is set. This
       variable is used to configure DMACREQCONFIG register.
     */
     TempPerpMaster = 0x00000000;

     if (TestCasePara->SrcPeriph == NA)
     {
       /*
         If the Source module is memory module and Source AHB Master is Master
         1, Program Memory module 0 as Source Slave module else program Memory
         module 1 as Source slave module.
       */ 
       if (TestCasePara->SrcMaster == MASTER1)
       {
         /* Selecting Memory module 0. Determine source address. */
         msg_info("Selecting Memory Module 0 as Source slave Peripheral");
         SrcAddr   = AddrGen(0x08000100, 0x0FFFFFFF) & SrcAddrMask;
       }
       else
       {
         /* Selecting Memory module 1. Determine source address. */
         msg_info("Selecting Memory Module1 as Source slave Periph");
         SrcAddr   = AddrGen(0x10000100, 0x17FFFFFF) & SrcAddrMask;
         /*
           Set bit 1 to indicate that memory module 1 is configured to Master2
         */
         TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
       }
     }
     else
     {
       /* Determine peripheral address range */
       Addr  = AddressSelection(TestCasePara->SrcPeriph);
       /* Determine source address */
       SrcAddr  = AddrGen(Addr, Addr | 0x0000FFFF) & SrcAddrMask;
       /*
         If the Source AHB master is Master2, set respective peripheral bit of
         TempPerpMaster variable.
       */
       if (TestCasePara->SrcMaster == MASTER2)
          TempPerpMaster = TempPerpMaster |
                           PeriphMasterSel[(TestCasePara->SrcPeriph) +2];

       sprintf(Message,"Source Peripheral : %d ", TestCasePara->SrcPeriph);
       msg_info(Message);
     }

     if (TestCasePara->DestPeriph == NA)
     {
       /*
         If the Destination module is memory module and Destination AHB Master
         is Master 1, Program Memory module 0 as Destination Slave module else
         select memory module 1 as Destination slave module.
       */
       if (TestCasePara->DestMaster == MASTER1)
       {
         /* Select Memory module 0. Determine destination address. */
         msg_info("Selecting Memory Module 0 as Destination slave Peripheral");
         DestAddr   = AddrGen(0x08000100, 0x0FFFFFFF) & DestAddrMask;
       }
       else
       {
         /* Selecting Memory module 1. Determine destination address. */
         msg_info("Selecting Memory Module1 as Destination slave Periph");
         DestAddr   = AddrGen(0x10000100, 0x17FFFFFF) & DestAddrMask;
         /*
           Set bit 1 to indicate that memory module 1 is configured to
           Master2
         */ 
         TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
       }
     }
     else
     {
       /* Determine peripheral address range */
       Addr  = AddressSelection(TestCasePara->DestPeriph);
       /* Determine destination address */
       DestAddr = AddrGen(Addr, Addr | 0x0000FFFF) & DestAddrMask;
       /*
         If the Destination AHB master is Master2, set respective peripheral
         bit of TempPerpMaster variable.
       */

       sprintf(Message,"Destination Peripheral : %d ",
                         TestCasePara->DestPeriph);
       msg_info(Message);
       if (TestCasePara->DestMaster == MASTER2)
         TempPerpMaster = TempPerpMaster |
                          PeriphMasterSel[(TestCasePara->DestPeriph) +2];
     }

     /* Configure DMACREQCONFIG register */
     Write(DMACREQCONFIG, TempPerpMaster);

     /* Selecting LLI Address to zero */
     CxLLIRegData = 0x00000000;

     /* Evaluate Control register data for First Channel */
     CxControlRegData =
                        TestCasePara->TxSize             |
                        SbValue(TestCasePara->SrcBurst)  |
                        DbValue(TestCasePara->DestBurst) |
                        SwValue(TestCasePara->SrcWidth)  |
                        DwValue(TestCasePara->DestWidth) |
                        SmValue(TestCasePara->SrcMaster) |
                        DmValue(TestCasePara->DestMaster)|
                        SiValue(TestCasePara->SrcIncr)   |
                        DiValue(TestCasePara->DestIncr);


     /*  Programming of Source, Destination, LLI and Control reg */
     ChannelPrgm(TestCasePara->Channel, SrcAddr, DestAddr, CxLLIRegData,
                 CxControlRegData);

     /* Slave Module Programming */
     SlavePrgm(
               TestCasePara->FlowControl,
               TestCasePara->SrcPeriph,
               TestCasePara->DestPeriph,
               DEFOKAY,
               DEFOKAY,
               ZERO,
               ZERO,
               RANDOM,
               INCREMENT,
               TestCasePara->SrcMaster,
               TestCasePara->DestMaster
              );

     /* Programming DMAREQEST */
     if (TestCasePara->FlowControl != M2MDMAC)
     {
       struct DisPeriphReq *PeriphReq  = DisableTestReq;

       /*
         Initialize Source/Destination request count to zero. It is used to
         program DMA request register.
       */
       SrcReqCount        = 0x00000000;
       DestReqCount       = 0x00000000;
       /* Initialize number of  source and destination request count to zero */
       SrcSREQ            = 0x00000000;
       SrcBREQ            = 0x00000000;
       SrcLSREQ           = 0x00000000;
       SrcLBREQ           = 0x00000000;
       DestSREQ           = 0x00000000;
       DestBREQ           = 0x00000000;
       DestLSREQ          = 0x00000000;
       DestLBREQ          = 0x00000000;
      
       /* Program peripheral requests */
       while (PeriphReq->TestNo != "EOFREQCASE")
       {
         if (PeriphReq->TestNo ==  TestCases->TestNo)
         {
           if ((TestCasePara->FlowControl != M2PDMAC)
                  && (TestCasePara->FlowControl != M2PDP))
           {
             SrcSREQ    = PeriphReq->ReqPara->SrcSREQ;
             SrcBREQ    = PeriphReq->ReqPara->SrcBREQ;
             SrcLSREQ   = PeriphReq->ReqPara->SrcLSREQ;
             SrcLBREQ   = PeriphReq->ReqPara->SrcLBREQ;

             if (SrcSREQ)
               SrcReqCount = SrcReqCount | 0x00000005;
             else if (SrcLSREQ)
               SrcReqCount = SrcReqCount | 0x00050000;

             if (SrcBREQ)
               SrcReqCount = SrcReqCount | 0x00000500;
             else if (SrcLBREQ)
               SrcReqCount = SrcReqCount | 0x05000000;

             sprintf(Message,"Programming DMA Request of Peripheral %d ",
                     TestCasePara->SrcPeriph);
             msg_info(Message);

             /* Determine register base address of source peripheral */ 
             Addr = SlaveAddrSelection(TestCasePara->SrcPeriph);
             Write(Addr + 0x00000008, SrcReqCount);
           }
           if ((TestCasePara->FlowControl != P2MDMAC) &&
               (TestCasePara->FlowControl != P2MSP))
           {
             DestSREQ   = PeriphReq->ReqPara->DestSREQ;
             DestBREQ   = PeriphReq->ReqPara->DestBREQ;
             DestLSREQ  = PeriphReq->ReqPara->DestLSREQ;
             DestLBREQ  = PeriphReq->ReqPara->DestLBREQ;

             if (DestSREQ)
               DestReqCount = DestReqCount | 0x00000005;
             else if (DestLSREQ)
               DestReqCount = DestReqCount | 0x00050000;

             if (DestBREQ)
               DestReqCount = DestReqCount | 0x00000500;
             else if (DestLBREQ)
               DestReqCount = DestReqCount | 0x05000000;

             sprintf(Message,"Programming DMA Request of Peripheral %d ",
                     TestCasePara->DestPeriph);
             msg_info(Message);

             /* Determine register base address of destination peripheral */ 
             Addr = SlaveAddrSelection(TestCasePara->DestPeriph);
             Write(Addr + 0x00000008, DestReqCount);
           }
           break;
         }
         PeriphReq++;
       }
     }
     /*
       Determine source and destination peripheral value to evaluate
       CxConfigData Register
     */
     if (TestCasePara->SrcPeriph == NA)
       SrcPeriphValue = 0x00000000;
     else
       SrcPeriphValue = SpValue(TestCasePara->SrcPeriph);

     if (TestCasePara->DestPeriph == NA)
       DestPeriphValue = 0x00000000;
     else
       DestPeriphValue = DpValue(TestCasePara->DestPeriph);

     /* Evaluate control information of CxConfig register */
     CxConfigData =
                    SrcPeriphValue             |
                    DestPeriphValue            |
                    TestCasePara->FlowControl  |
                    CHXENABLE;

     /*
       Determine channel register base address and configure CxConfig register
     */
     RegAddr = ChannelRegisters(TestCasePara->Channel);
     Write (*RegAddr + 0x00000010, CxConfigData);
   
     /* Poll Channel Enable Bit for high */
     MaskValue = 0x00000001;
     Poll(ConfigRegs[TestCasePara->Channel], MaskValue, MaskValue);

     if (TestCasePara->DMAC_Disable == DMACDISABLE)
     {
       /* Disable DMAC */
       WaitLoop(4);
       if (TestCases->TestNo == "DMAC_DISABLE_9" ||
           TestCases->TestNo == "DMAC_DISABLE_17" ||
           TestCases->TestNo == "DMAC_DISABLE_18" ||
           TestCases->TestNo == "DMAC_DISABLE_19" ||
           TestCases->TestNo == "DMAC_DISABLE_20" ||
           TestCases->TestNo == "DMAC_DISABLE_21" ||
           TestCases->TestNo == "DMAC_DISABLE_22" ||
           TestCases->TestNo == "DMAC_DISABLE_23" ||
           TestCases->TestNo == "DMAC_DISABLE_24" ||
           TestCases->TestNo == "DMAC_DISABLE_25" ||
           TestCases->TestNo == "DMAC_DISABLE_26" ||
           TestCases->TestNo == "DMAC_DISABLE_27" ||
           TestCases->TestNo == "DMAC_DISABLE_28" ||
           TestCases->TestNo == "DMAC_DISABLE_29" ||
           TestCases->TestNo == "DMAC_DISABLE_30" ||
           TestCases->TestNo == "DMAC_DISABLE_31"
          ) 
         WaitLoop(10);

       /* Disable DMAC by writing channel enable bit zero */ 
       RegAddr = ChannelRegisters(TestCasePara->Channel);
       Write(*RegAddr + 0x00000010, CxConfigData & DMACDISABLE);

       WaitLoop(10);

     }
     if (TestCasePara->DMAC_Halt == DMACHALT)
     {
       /* HALT DMAC */
       RegAddr = ChannelRegisters(TestCasePara->Channel);
       Write (*RegAddr + 0x00000010, CxConfigData | DMACHALT);
       WaitLoop(70);
       Write (*RegAddr + 0x00000010, CxConfigData);
     }

     if (TestCases->TestNo == "DMAC_HALT_5" || 
         TestCases->TestNo == "DMAC_HALT_6")
     {
       while (SrcBREQ)
       {
         /* Determine expected mask and poll DMACSoftBReq register */
         /* Check source DMAC BREQ request is set */ 
         MaskValue = ReqExpValue[TestCasePara->SrcPeriph];
         Poll(DMACSoftBReq, MaskValue, MaskValue);
         WaitLoop(1);
         if (SrcBREQ == 1)
         {
           /* Assert DMAC LB request */
           Addr = SlaveAddrSelection(TestCasePara->SrcPeriph);
           Write(Addr + 0x00000008, 0x02000000);
         }
         /* Check DMACBREQ going low. Poll DMABREQ Register  */
         MaskValue = ReqExpValue[TestCasePara->SrcPeriph];
         Poll(DMACSoftBReq, 0x0, MaskValue);
         /* Decrement source BREQ count */ 
         SrcBREQ = SrcBREQ - 1; 
         WaitLoop(3);
       }
     }

     if (TestCases->TestNo == "DMAC_HALT_7" ||
         TestCases->TestNo == "DMAC_HALT_8")
     {
       while (DestBREQ)
       {
         /* Check source DMAC BREQ request is set */ 
         /* Determine expected mask and poll DMACSoftBReq register */
         MaskValue = ReqExpValue[TestCasePara->DestPeriph];
         Poll(DMACSoftBReq, MaskValue, MaskValue);
         WaitLoop(1);
         /* Poll DMABREQ  Register */
         if (DestBREQ == 1)
         {
           /* Assert DMAC LB request */
           Addr = SlaveAddrSelection(TestCasePara->DestPeriph);
           Write(Addr + 0x00000008, 0x02000000);
         }
         /* Check DMACBREQ going low. Poll DMABREQ Register  */
         MaskValue = ReqExpValue[TestCasePara->DestPeriph];
         Poll(DMACSoftBReq, 0x0, MaskValue);
         /* Decrement destination BREQ count */ 
         DestBREQ = DestBREQ - 1;
         WaitLoop(3);
       }
      }

     /* Poll Channel Enable bit going low */
     MaskValue = 0x00000001;
     Poll(ConfigRegs[TestCasePara->Channel], 0x00000000, MaskValue);
     WaitLoop(5);
     /* Reset Memory and Peripheral */
     if (TestCasePara->DestPeriph == NA || TestCasePara->SrcPeriph == NA)
     {
       Write(DMACTrMemEn0, MEMORYRESET);
       Write(DMACTrMemEn1, MEMORYRESET);
       Write(DMACTrMemEn0, MEMORYRSTCLR);
       Write(DMACTrMemEn1, MEMORYRSTCLR);
     }
     if (TestCasePara->SrcPeriph != NA)
     {
       Addr  = SlaveAddrSelection(TestCasePara->SrcPeriph);
       Write (Addr, PERIPHRESET);
       Write (Addr, PERIPHRSTCLR);
     }
     if (TestCasePara->DestPeriph != NA)
     {
       Addr  = SlaveAddrSelection(TestCasePara->DestPeriph);
       Write (Addr, PERIPHRESET);
       Write (Addr, PERIPHRSTCLR);
     }
     sprintf(Message," End Of %s Test", TestCases->TestNo);
     C(Message);
     TestCases++;
  }
  /* Enable Trickbox */
  Write(DMACTRICKEN, 0x00000001);
}

/************************** End of Halt/Disable Tests *************************/
