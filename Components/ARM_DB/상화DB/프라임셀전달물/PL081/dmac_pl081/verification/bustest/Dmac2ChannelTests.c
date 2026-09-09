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
-- File Name              :  Dmac2ChannelTests.c.rca 
-- File Revision          :  1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This file contains Two Channel test cases.
-- --=========================================================================*/

/******************************************************************************/
/********************* List of Functions Called *******************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** ChannelPrgm                                DmacCommon.c                ***/
/*** LLIPrgm                                    DmacCommon.c                ***/
/*** SlavePrgm                                  DmacCommon.c                ***/
/*** AddrGen                                    DmacCommon.c                ***/
/*** AddressSelection                           DmacCommon.c                ***/
/*** DMAREQSET                                  DmacCommon.c                ***/
/*** DMALastReq                                 DmacCommon.c                ***/
/*** SingleChReq                                DmacCommon.c                ***/
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

void Dmac2ChannelTests()
{
  /* Overview: Two Channel Test
     =========================
     The function is used to test the implementation of two-channel priority of
     DMA Controller. The two channel parameters are defined by using structure
     TestParameters. The data generation method, sub data method, Number of
     Programmed response, channel to be enable first and channel whose request
     is to be asserted first are defined in structure TestParameters. If the
     source slave is memory module and if source AHB master is Master1, memory 
     module 0 is selected as source slave module else module 1 is selected. The
     function calls AddressSelction function to determine source peripheral
     address range. It calls AddrGen function to determine source address. The
     TempPerpMaster variable is used to indicate source/destination peripheral
     module is configured to Master2. The function sets respective bit of source
     memory or peripheral if source AHB master is Master2. If the Destination
     slave is memory module and destination AHB master is Master 1 then function
     selects memory module 1 as destination slave module else selects memory
     module 1. The function determines destination peripheral address range and
     destination address. It determine LLI block slave address and also
     determine LLI address to program CxLLIReg. It determine control information
     of CxControl register and calls ChannelPrgm function to program first
     channel. After programming first channel it programs LLI block and slave
     peripherals by calling SlavePrgm function. Above procedure is repeated to 
     program second channel. The GrantCount register is programmed for request 
     based grant toggle mode. The function determines which channel should be 
     enabled first and enables that channel and then enables remained channel.
     The channel whose peripheral request to be asserted first is determined
     and its peripheral DMA requests are asserted. The peripheral requests of
     other channel is asserted. To program peripheral requests, the register
     base address of peripheral is determined by calling SlaveAddressSelction
     function. Function calls function DMAREQSET and DMALastReq or SingleChReq
     depending flow controller of both channel. If the flow controller of both
     channel are P2P flow controller, call DMAREQSET or DMALastReq function
     depending on flow controller. If the flow controller is P2P Destination
     Peripheral or P2P DMAC flow controller, call DMAREQSET function. If flow
     controller is P2P Source peripheral flow controller, call DMALastReq
     function. If both channel flow controller are not P2P flow controller,
     function calls DMALastReq, SingleChReq or DMAREQSET depending on type of
     flow controller. The DMALastReq function is called if flow controller is
     P2M source peripheral or P2P source peripheral flow controller. The
     SingleChReq function is called if flow controller is M2P DMAC or M2P
     destination peripheral flow controller. The DMAREQSET function is called
     if flow controller is P2P Source Peripheral, P2P Destination Peripheral,
     P2P DMAC, P2M DMAC or P2M Source Peripheral flow controller. Once all
     peripheral requests are asserted and cleared, the function polls channel
     enable bit of both channel going low.
  */ 
  char Message[100];
  int  i = 0;
  int32 MaskValue;
  int32 SrcPeriphValue, DestPeriphValue;
  int32 TempPerpMaster;

  /*
    The structure TestParameters is used to define channel parameters of two
    channel, Data generation method, channel to be enabled first and Channel
    whose request is to be asserted first.
  */
  struct TestParameters {
     int   FirstChannel;
     int32 FirstChFlowControl;
     int   FirstChSrcWidth;
     int   FirstChDestWidth;
     int   FirstChSrcBurst;
     int   FirstChDestBurst;
     int32 FirstChTxSize;
     int   FirstChSrcMaster;
     int   FirstChDestMaster;
     int   FirstChNoOfLLI;
     int32 FirstChLLIAddr;
     int32 FirstChLLIMaster;
     int32 FirstChSrcPeriph;
     int32 FirstChDestPeriph;
     int32 FirstChSrcAHBResp;
     int32 FirstChDestAHBResp;
     int32 FirstChSrcWaitCyc;
     int32 FirstChDestWaitCyc;
     int32 FirstChPROT;
     int32 FirstChLOCK;
     int32 FirstChHALT;
     char* FirstChSrcIncr;
     char* FirstChDestIncr;
     int   SecondChannel;
     int32 SecondChFlowControl;
     int   SecondChSrcWidth;
     int   SecondChDestWidth;
     int   SecondChSrcBurst;
     int   SecondChDestBurst;
     int   SecondChTxSize;
     int   SecondChSrcMaster;
     int   SecondChDestMaster;
     int   SecondChNoOfLLI;
     int32 SecondChLLIAddr;
     int32 SecondChLLIMaster;
     int32 SecondChSrcPeriph;
     int32 SecondChDestPeriph;
     int32 SecondChSrcAHBResp;
     int32 SecondChDestAHBResp;
     int32 SecondChSrcWaitCyc;
     int32 SecondChDestWaitCyc;
     int32 SecondChPROT;
     int32 SecondChLOCK;
     int32 SecondChHALT;
     char* SecondChSrcIncr;
     char* SecondChDestIncr;
     int   WhichChEnableFirst;
     int32 DataGenMethod;
     int32 DataMethod;
     int32 IsAnyPrgmResp;
     int32 NoOfPrgmResp;
     int   WhichChReqFirst;
    };

  /*
    The structure TotalCases is used to define Test No and Its Channel
    parameters.
  */
  struct TotalCases {
     char  *TestNo;
     struct TestParameters *CaseParameters;
    };
  
  /* Two channel test cases parameters */       
   struct TestParameters ChannelTestPara[] = {
     0, P2PDMAC, 32, 32, 4, 4, 0x00000001, MASTER1, MASTER1, 0, 0x00000000,
          ZERO, 3, 9, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2PDMAC, 32, 32, 4, 4, 0x00000001, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, 1, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
           0x00000000, ADDRINCR, ADDRINCR, 0, ADDRBASED, INCREMENT, ZERO, ZERO,
           0,

     0, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 0, 0x00000000,
          ZERO, 2, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, INCREMENT, ZERO, ZERO, 0,

     0, P2MSP, 16, 16, 4, 4, 0x00000000, MASTER1, MASTER1, 0, 0x00000000,
          ZERO, 2, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, 8, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, INCREMENT, 1 , 0x00000001, 1,

     0, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, 0x00000000,
          ZERO, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2MDMAC, 32, 32, 4, 4, 0x00000008, MASTER2, MASTER2, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, DECREMENT, ZERO , ZERO, 0,

     0, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 0, 0x00000000,
          ZERO, 2, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, P2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, 10, 15, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, INCREMENT, 1 , 0x00000002, 1,

     0, P2PDMAC, 16, 16, 4, 4, 0x00000001, MASTER1, MASTER1, 0, 0x00000000,
          ZERO, 4, 5, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2PDMAC, 8, 8, 4, 4, 0x00000001, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, 6, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, INCREMENT, ZERO , ZERO, 0,

     0, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010200,
          ZERO, 2, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 1, 0xA0020200,
           1, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, INCREMENT, ZERO , ZERO, 0,

     0, P2MDMAC, 32, 32, 8, 8, 0x00000002, MASTER2, MASTER2, 0, 0x00000000,
          ZERO, 6, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2PDP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 0, 0x00000000,
           ZERO, NA, 15, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, INCREMENT, ZERO , ZERO, 1,

     0, P2MSP, 16, 16, 4, 4, 0x00000000, MASTER1, MASTER1, 0, 0x00000000,
          ZERO, 2, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, 7, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, INCREMENT, 1 , 0x00000001, 1,

     0, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, 0x00000000,
          ZERO, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2MDMAC, 32, 32, 4, 4, 0x00000008, MASTER2, MASTER2, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, INCREMENT, ZERO , ZERO, 0,

     0, P2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 0, 0x00000000,
          ZERO, 13, 5, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2PDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, 1, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR,0, ADDRBASED, INCREMENT, ZERO , ZERO, 1,

     0, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0020200,
          1, 2, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 1, 0xA0020210,
           1, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, DECREMENT, ZERO , ZERO, 0,

     0, P2PDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 1, 0xA0020200,
          1, 12, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0020210,
           1, 1, 2, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, INCREMENT, 1 , 0x00000002, 1,

     0, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, 0x00000000,
          ZERO, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, INCREMENT, 1 , 0x00000001, 0,

     0, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 2, 0xA0010200,
          ZERO, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 1, 0xA0010220,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, ONESCOMP, 0 , 0x00000000, 0,

     0, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010200,
          ZERO, 4, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010210,
           ZERO, NA, 12, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, TWOSCOMP, 0 , 0x00000000, 1,

     0, P2PSP, 32, 32, 8, 8, 0x00000000, MASTER1, MASTER1, 0, 0x00000000,
          ZERO, 4, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, P2MSP, 32, 32, 8, 8, 0x00000000, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, 12, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, DECREMENT, 0 , 0x00000000, 1,

     0, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010200,
          ZERO, 1, 2, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, P2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010210,
           ZERO, 3, 4, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, INCREMENT, 0 , 0x00000000, 1,

     0, P2PDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, 0x00000000,
          ZERO, 12, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, 1, 2, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, DECREMENT, 1 , 0x00000001, 1,

     0, P2PDMAC, 32, 32, 4, 4, 0x00000008, MASTER1, MASTER1, 0, 0x00000000,
          ZERO, 12, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, INCREMENT, 0 , 0x00000000, 0,


     0, P2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010200,
          ZERO, 1, 2, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, P2PDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 1, 0xA0010210,
           ZERO, 3, 4, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, INCREMENT, ZERO , ZERO, 1,

     0, P2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 1, 0xA0020200,
         MASTER2, 1, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, P2MSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0020210,
          MASTER2, 3, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, INCREMENT, ZERO , ZERO, 1,


     0, M2PDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 1, 0xA0010200,
          ZERO, NA, 5, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2PDP, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 1, 0xA0010220,
           ZERO, NA, 1, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, INCREMENT, ZERO , ZERO, 1,

     0, P2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0020200,
          MASTER2, 1, 2, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, P2MSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0020210,
          MASTER2, 3, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, INCREMENT, 1 , 1, 1,

     0, M2MDMAC, 8, 8, 16, 16, 0x00000016, MASTER1, MASTER1, 1, 0xA0010200,
          MASTER1, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR,
        1, M2MDMAC, 8, 8, 16, 16, 0x00000016, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, DECREMENT, 1 , 1, 0,

     0, M2MDMAC, 8, 8, 8, 8, 0x00000008, MASTER1, MASTER1, 1, 0xA0010200,
          MASTER1, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR,
        1, M2MDMAC, 8, 8, 1, 1, 0x00000001, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, DEFWAIT9, DEFWAIT9, pbc, NONLOCK,
           0x00000000, ADDRINCR, ADDRINCR, 1, ADDRBASED, DECREMENT, 1, 1, 0,

     0, M2MDMAC, 8, 8, 16, 16, 0x00000032, MASTER1, MASTER1, 0, 0x00000000,
          ZERO, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2MDMAC, 8, 8, 16, 16, 0x00000032, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, DECREMENT, ZERO , ZERO, 0,

     0, M2MDMAC, 8, 8, 16, 16, 0x00000032, MASTER1, MASTER1, 0, 0x00000000,
          ZERO, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          "NI", "NI",
        1, M2MDMAC, 8, 8, 16, 16, 0x00000032, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, DEFWAIT3, DEFWAIT3, pbc, NONLOCK,
           0x00000000, "NI", "NI", 0, ADDRBASED, DECREMENT, ZERO , ZERO, 0,

     0, M2MDMAC, 8, 8, 16, 16, 0x00000032, MASTER1, MASTER1, 0, 0x00000000,
          ZERO, NA, NA, DEFOKAY, DEFOKAY, DEFWAIT1, DEFWAIT1, pbc, NONLOCK,
          0x00000000, "NI", "NI",
        1, M2MDMAC, 8, 8, 16, 16, 0x00000032, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, DEFWAIT1, DEFWAIT1, pbc, NONLOCK,
           0x00000000, "NI", "NI", 0, ADDRBASED, DECREMENT, ZERO , ZERO, 0,

     1, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010200,
          ZERO, 4, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        0, M2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010210,
           ZERO, NA, 12, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, TWOSCOMP, 0 , 0x00000000, 0,

     1, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010200,
          ZERO, 4, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        0, M2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010210,
           ZERO, NA, 12, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, TWOSCOMP, 0 , 0x00000000, 0,

     1, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010200,
          ZERO, 4, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        0, M2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010210,
           ZERO, NA, 12, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, TWOSCOMP, 0 , 0x00000000, 0,

     1, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010200,
          ZERO, 4, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        0, M2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010210,
           ZERO, NA, 12, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, TWOSCOMP, 0 , 0x00000000, 0,

     1, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010200,
          ZERO, 4, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        0, M2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010210,
           ZERO, NA, 12, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, TWOSCOMP, 0 , 0x00000000, 0,

     0, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010200,
          ZERO, 4, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010210,
           ZERO, NA, 12, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, TWOSCOMP, 0 , 0x00000000, 1,

     0, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010200,
          ZERO, 4, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010210,
           ZERO, NA, 12, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, TWOSCOMP, 0 , 0x00000000, 1,

     0, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010200,
          ZERO, 4, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
          ADDRINCR, ADDRINCR,
        1, M2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 1, 0xA0010210,
           ZERO, NA, 12, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, TWOSCOMP, 0 , 0x00000000, 1,

     0, M2MDMAC, 8, 8, 16, 16, 0x00000016, MASTER1, MASTER1, 1, 0xA0010200,
          MASTER1, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR,
        1, M2MDMAC, 8, 8, 16, 16, 0x00000016, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, DECREMENT, 1 , 1, 0,

     0, M2MDMAC, 8, 8, 8, 8, 0x00000008, MASTER1, MASTER1, 1, 0xA0010200,
          MASTER1, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR,
        1, M2MDMAC, 8, 8, 1, 1, 0x00000001, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, DEFWAIT9, DEFWAIT9, pbc, NONLOCK,
           0x00000000, ADDRINCR, ADDRINCR, 1, ADDRBASED, DECREMENT, 1, 1, 0,

     0, M2MDMAC, 8, 8, 16, 16, 0x00000016, MASTER1, MASTER1, 1, 0xA0010200,
          MASTER1, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR,
        1, M2MDMAC, 8, 8, 16, 16, 0x00000016, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, DECREMENT, 1, 1, 0,

     0, M2MDMAC, 8, 8, 8, 8, 0x00000008, MASTER1, MASTER1, 1, 0xA0010200,
          MASTER1, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR,
        1, M2MDMAC, 8, 8, 1, 1, 0x00000001, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, DEFWAIT9, DEFWAIT9, pbc, NONLOCK,
           0x00000000, ADDRINCR, ADDRINCR, 1, ADDRBASED, DECREMENT, 1, 1, 0,

     0, M2MDMAC, 8, 8, 16, 16, 0x00000016, MASTER1, MASTER1, 1, 0xA0010200,
          MASTER1, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR,
        1, M2MDMAC, 8, 8, 16, 16, 0x00000016, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, DECREMENT, 1, 1, 0,
 
      0, M2MDMAC, 8, 8, 8, 8, 0x00000008, MASTER1, MASTER1, 1, 0xA0010200,
          MASTER1, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR,
        1, M2MDMAC, 8, 8, 1, 1, 0x00000001, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, DEFWAIT9, DEFWAIT9, pbc, NONLOCK,
           0x00000000, ADDRINCR, ADDRINCR, 1, ADDRBASED, DECREMENT, 1, 1, 0,

     0, M2MDMAC, 8, 8, 16, 16, 0x00000016, MASTER1, MASTER1, 1, 0xA0010200,
          MASTER1, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR,
        1, M2MDMAC, 8, 8, 16, 16, 0x00000016, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, DECREMENT, 1, 1, 0,

     0, M2MDMAC, 8, 8, 8, 8, 0x00000008, MASTER1, MASTER1, 1, 0xA0010200,
          MASTER1, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR,
        1, M2MDMAC, 8, 8, 1, 1, 0x00000001, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, DEFWAIT9, DEFWAIT9, pbc, NONLOCK,
           0x00000000, ADDRINCR, ADDRINCR, 1, ADDRBASED, DECREMENT, 1, 1, 0,

     0, M2MDMAC, 8, 8, 16, 16, 0x00000016, MASTER1, MASTER1, 1, 0xA0010200,
          MASTER1, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR,
        1, M2MDMAC, 8, 8, 16, 16, 0x00000016, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, DECREMENT, 1, 1, 0,

     0, M2MDMAC, 8, 8, 8, 8, 0x00000008, MASTER1, MASTER1, 1, 0xA0010200,
          MASTER1, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR,
        1, M2MDMAC, 8, 8, 1, 1, 0x00000001, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, DEFWAIT9, DEFWAIT9, pbc, NONLOCK,
           0x00000000, ADDRINCR, ADDRINCR, 1, ADDRBASED, DECREMENT, 1, 1, 0,

     0, M2MDMAC, 8, 8, 16, 16, 0x00000016, MASTER1, MASTER1, 1, 0xA0010200,
          MASTER1, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR,
        1, M2MDMAC, 8, 8, 16, 16, 0x00000016, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 1, ADDRBASED, DECREMENT, 1 , 1, 0,

     0, M2MDMAC, 8, 8, 8, 8, 0x00000008, MASTER1, MASTER1, 1, 0xA0010200,
          MASTER1, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR,
        1, M2MDMAC, 8, 8, 1, 1, 0x00000001, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, DEFWAIT9, DEFWAIT9, pbc, NONLOCK,
           0x00000000, ADDRINCR, ADDRINCR, 1, ADDRBASED, DECREMENT, 1, 1, 0,

     1, M2MDMAC, 8, 8, 16, 16, 0x00000016, MASTER1, MASTER1, 1, 0xA0010200,
          MASTER1, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR,
        0, M2MDMAC, 8, 8, 16, 16, 0x00000016, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, ZERO, ZERO, pbc, NONLOCK, 0x00000000,
           ADDRINCR, ADDRINCR, 0, ADDRBASED, DECREMENT, 1, 1, 1,

     1, M2MDMAC, 8, 8, 8, 8, 0x00000008, MASTER1, MASTER1, 1, 0xA0010200,
          MASTER1, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR,
        0, M2MDMAC, 8, 8, 1, 1, 0x00000001, MASTER1, MASTER1, 0, 0x00000000,
           ZERO, NA, NA, DEFOKAY,DEFOKAY, DEFWAIT9, DEFWAIT9, pbc, NONLOCK,
          0x00000000, ADDRINCR, ADDRINCR, 0, ADDRBASED, DECREMENT, 0, 1, 1
    };

  /* Defining Test Number and Its Channel Parameters */
  struct TotalCases ChannelTests[] = { 
     {"DMAC_2CH_1",  &ChannelTestPara[0]},
     {"DMAC_2CH_2",  &ChannelTestPara[1]},
     {"DMAC_2CH_3",  &ChannelTestPara[2]},
#ifdef TWOMASTERCONFIG
     {"DMAC_2CH_4",  &ChannelTestPara[3]},
#endif
     {"DMAC_2CH_5",  &ChannelTestPara[4]},
     {"DMAC_2CH_6",  &ChannelTestPara[5]},
#ifdef TWOMASTERCONFIG
     {"DMAC_2CH_7",  &ChannelTestPara[6]},
     {"DMAC_2CH_8",  &ChannelTestPara[7]},
#endif
     {"DMAC_2CH_9",  &ChannelTestPara[8]},
#ifdef TWOMASTERCONFIG
     {"DMAC_2CH_10", &ChannelTestPara[9]},
#endif
    {"DMAC_2CH_11", &ChannelTestPara[10]},
#ifdef TWOMASTERCONFIG
     {"DMAC_2CH_12", &ChannelTestPara[11]},
     {"DMAC_2CH_13", &ChannelTestPara[12]},
#endif
     {"DMAC_2CH_14", &ChannelTestPara[13]},
#ifdef TWOMASTERCONFIG
     {"DMAC_2CH_15", &ChannelTestPara[14]},
#endif
     {"DMAC_2CH_16", &ChannelTestPara[15]},
     {"DMAC_2CH_17", &ChannelTestPara[16]},
#ifdef TWOMASTERCONFIG
     {"DMAC_2CH_18", &ChannelTestPara[17]},
#endif
     {"DMAC_2CH_19", &ChannelTestPara[18]},
     {"DMAC_2CH_20", &ChannelTestPara[19]},
#ifdef TWOMASTERCONFIG
     {"DMAC_2CH_21", &ChannelTestPara[6]},
#endif
     {"DMAC_2CH_22", &ChannelTestPara[20]},
#ifdef TWOMASTERCONFIG
     {"DMAC_2CH_23", &ChannelTestPara[21]},
#endif
     {"DMAC_2CH_24", &ChannelTestPara[22]},
#ifdef TWOMASTERCONFIG
     {"DMAC_2CH_25", &ChannelTestPara[23]},
#endif
     {"DMAC_2CH_26", &ChannelTestPara[24]},
     {"DMAC_2CH_27", &ChannelTestPara[25]},
     {"DMAC_2CH_28", &ChannelTestPara[26]},
     {"DMAC_2CH_29", &ChannelTestPara[27]},
     {"DMAC_2CH_30", &ChannelTestPara[28]},
     {"DMAC_2CH_31", &ChannelTestPara[29]},
     {"DMAC_2CH_32", &ChannelTestPara[30]},
     {"DMAC_2CH_33", &ChannelTestPara[31]},
     {"DMAC_2CH_34", &ChannelTestPara[32]},
     {"DMAC_2CH_35", &ChannelTestPara[33]},
     {"DMAC_2CH_36", &ChannelTestPara[34]},
     {"DMAC_2CH_37", &ChannelTestPara[35]},
     {"DMAC_2CH_38", &ChannelTestPara[36]},
     {"DMAC_2CH_39", &ChannelTestPara[37]},
     {"DMAC_2CH_40", &ChannelTestPara[38]},
     {"DMAC_2CH_41", &ChannelTestPara[39]},
     {"DMAC_2CH_42", &ChannelTestPara[40]},
     {"DMAC_2CH_43", &ChannelTestPara[41]},
     {"DMAC_2CH_44", &ChannelTestPara[42]},
     {"DMAC_2CH_45", &ChannelTestPara[43]},
     {"DMAC_2CH_46", &ChannelTestPara[44]},
     {"DMAC_2CH_47", &ChannelTestPara[45]},
     {"DMAC_2CH_48", &ChannelTestPara[46]},
     {"DMAC_2CH_49", &ChannelTestPara[47]},
     {"DMAC_2CH_50", &ChannelTestPara[48]},
     {"ENDOFTEST",   &ChannelTestPara[0]}
    };
  

  int32 SrcAddr, DestAddr;
  int32 SrcAddrMask, DestAddrMask;
  int32 C1ConfigData; 
  int32 C2ConfigData; 
  int32 CxControlRegData;
  int32 CxLLIRegData;
  int32 Addr, LLIAddr;
  int32 *RegAddr;
  int  FirstChSrcBREQ;
  int  FirstChSrcSREQ;
  int  FirstChSrcLBREQ;
  int  FirstChSrcLSREQ;
  int  FirstChDestBREQ;
  int  FirstChDestSREQ;
  int  FirstChDestLBREQ;
  int  FirstChDestLSREQ;
  int  SecondChSrcBREQ;
  int  SecondChSrcSREQ;
  int  SecondChSrcLBREQ;
  int  SecondChSrcLSREQ;
  int  SecondChDestBREQ;
  int  SecondChDestSREQ;
  int  SecondChDestLBREQ;
  int  SecondChDestLSREQ;
  int  SrcReqCount = 0x00000000;
  int  DestReqCount = 0x00000000;

  struct TotalCases *TwoChannelTests = ChannelTests;
  /* Clear pending interrupts if any */
  Write(DMACIntTCClr, 0x000000FF);
  Write(DMACIntErrClr, 0x000000FF);

  while (TwoChannelTests->TestNo != "ENDOFTEST")
  {
     struct TestParameters *Parameters = TwoChannelTests->CaseParameters;
     struct PrgmCases *PrgmCases = TwoChPrgmRespPar;

     sprintf(Message,"Test No : %s",TwoChannelTests->TestNo);
     C(Message);
     sprintf(Message,"FirstChannel : %d", Parameters->FirstChannel);
     msg_info(Message);
     sprintf(Message,"FlowControl : %x\nSW : %d\nDW : %d\nSB : %d\nDB : %d "
             "\nTxSize : %d\nSM : %d\nDM : %d",
             Parameters->FirstChFlowControl,
             Parameters->FirstChSrcWidth,
             Parameters->FirstChDestWidth,
             Parameters->FirstChSrcBurst,
             Parameters->FirstChDestBurst,
             Parameters->FirstChTxSize,
             Parameters->FirstChSrcMaster,
             Parameters->FirstChDestMaster);
     msg_info(Message);
     sprintf(Message,"SecondChannel : %d", Parameters->SecondChannel);
     msg_info(Message);
     sprintf(Message,"FlowControl : %x\nSW : %d\nDW : %d\nSB : %d\nDB : %d "
             "\nTxSize : %d\nSM : %d\nDM : %d",
             Parameters->SecondChFlowControl,
             Parameters->SecondChSrcWidth,
             Parameters->SecondChDestWidth,
             Parameters->SecondChSrcBurst,
             Parameters->SecondChDestBurst,
             Parameters->SecondChTxSize,
             Parameters->SecondChSrcMaster,
             Parameters->SecondChDestMaster);
     msg_info(Message);
  
     if (TwoChannelTests->TestNo == "DMAC_2CH_28" ||
         TwoChannelTests->TestNo == "DMAC_2CH_29" ||
         TwoChannelTests->TestNo == "DMAC_2CH_30")
       /* Disable Trickbox */
       Write(DMACTRICKEN, 0x00000000);  
     else
       /* Enable Trickbox  */
       Write(DMACTRICKEN, 0x00000001);


     /* Define source and destination address mask */
     SrcAddrMask  = 0xFFFFFF00;
     DestAddrMask = 0xFFFFFF00;

     /*
       The TempPerpMaster variable is used to indicate memory/peripheral modules
       are configured for Master2. If the source/Destination memory/peripheral
       modules are configured for master 2, the respective bits are set. This
       variable is used to configure DMACREQCONFIG register.
     */
     TempPerpMaster = 0x00000000;

     /* First Channel Programming */ 
     if (Parameters->FirstChSrcPeriph == NA)
     {
       /*
         If the source module is memory module and source AHB Master is Master
         1, Program memory module 0 as source slave module else program memory
         module 1 as source slave module.
       */
       if (Parameters->FirstChSrcMaster == MASTER1)
       {
         /* Select memory module 0. Determine source address. */
         msg_info("Selecting Memory Module 0 as Source slave Peripheral");
         SrcAddr   = AddrGen(0x08000100, 0x0FFFFFFF) & SrcAddrMask;
       }
       else
       {
         /* Select memory module 1. Determine source address. */
         msg_info("Selecting Memory Module1 as Source slave Peripheral");
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
       Addr  = AddressSelection(Parameters->FirstChSrcPeriph);

       /* Determine source address */
       SrcAddr  = AddrGen(Addr, Addr | 0x0000FFFF) & SrcAddrMask;

       /*
         If the source AHB master is Master2, set respective peripheral bit of
         TempPerpMaster variable.
       */ 
       if (Parameters->FirstChSrcMaster == MASTER2)
          TempPerpMaster = TempPerpMaster |
                           PeriphMasterSel[(Parameters->FirstChSrcPeriph) +2];

       sprintf(Message,"Source Peripheral : %d", Parameters->FirstChSrcPeriph);
       msg_info(Message);
     }
  
     if (Parameters->FirstChDestPeriph == NA)
     {
       /*
         If the destination module is memory module and destination AHB master
         is Master 1, Program memory module 0 as destination slave module else
         select memory module 1 as destination slave module.
       */
       if (Parameters->FirstChDestMaster == MASTER1)
       {
         /* Select memory module 0. Determine destination address. */
         msg_info("Selecting Memory Module 0 as Destination slave Peripheral");
         DestAddr   = AddrGen(0x08000100, 0x0FFFFFFF) & DestAddrMask;
       }
       else
       {
         /* Select memory module 1. Determine destination address. */
         msg_info("Selecting Memory Module1 as Destination slave Peripheral");
         DestAddr   = AddrGen(0x10000100, 0x17FFFFFF) & DestAddrMask;

         /*
           Set bit 1 to indicate that memory module 1 is configured to Master2
         */
         TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
       }
     }
     else
     {
       /* Determine peripheral address range */
       Addr  = AddressSelection(Parameters->FirstChDestPeriph);
       /* Determine destination address */
       DestAddr = AddrGen(Addr, Addr | 0x0000FFFF) & DestAddrMask;

       sprintf(Message,"Destination Peripheral : %d",
                         Parameters->FirstChDestPeriph);
       msg_info(Message);
      
       /*
         If the destination AHB master is Master2, set respective peripheral
         bit of TempPerpMaster variable.
       */ 
       if (Parameters->FirstChDestMaster == MASTER2)
         TempPerpMaster = TempPerpMaster |
                          PeriphMasterSel[(Parameters->FirstChDestPeriph) +2];
     }

     /* Determine LLI slave address */ 
     LLIAddr   = Parameters->FirstChLLIAddr;

     /*
       If LLI Master is Master 1, select memory module 0 as LLI block else
       select memory module 1.
     */
     if (Parameters->FirstChNoOfLLI > 0)
     { 
       if (Parameters->FirstChLLIMaster == MASTER1)
       {
         /*
           Select memory module 0. Determine LLI address to program CxLLI
           register. Enable Memory Module 0.
         */ 
         CxLLIRegData = (LLIAddr & 0x00000030) | LLIADDRM1;
         Write(DMACTrMemEn0, MEMORYENABLE | ADDRBASED);
       }
       else
       {
         /*
           Select memory module 1. Determine LLI address to program CxLLI
           register. Enable Memory Module 1
         */ 
         CxLLIRegData = (LLIAddr & 0x00000030) | LLIADDRM2 | 0x00000001;
         TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
         Write(DMACTrMemEn1, MEMORYENABLE | ADDRBASED);
       }
     }
     else
       CxLLIRegData = 0x00000000;

     /* Evaluate Control register data for First Channel */
     CxControlRegData =
                        Parameters->FirstChTxSize             |
                        SbValue(Parameters->FirstChSrcBurst)  |
                        DbValue(Parameters->FirstChDestBurst) |
                        SwValue(Parameters->FirstChSrcWidth)  |
                        DwValue(Parameters->FirstChDestWidth) |
                        SmValue(Parameters->FirstChSrcMaster) |
                        DmValue(Parameters->FirstChDestMaster)|
                        SiValue(Parameters->FirstChSrcIncr)   |
                        DiValue(Parameters->FirstChDestIncr);

     /* Programming first Channel Source, Destination, LLI and Control
        register */
     ChannelPrgm(Parameters->FirstChannel, SrcAddr, DestAddr, CxLLIRegData,
                 CxControlRegData);


     /* First Channel LLI Programming */ 
     if (Parameters->FirstChNoOfLLI > 0)
     {
       /* Generate Next LLI Source Address */ 
       SrcAddr   = AddrGen(SrcAddr,  SrcAddr  | 0x0000FFFF) & SrcAddrMask;

       /* Generate Next LLI Destination Address */
       DestAddr  = AddrGen(DestAddr, DestAddr | 0x0000FFFF) & DestAddrMask;

       /* Increment LLI address to next LLI block */
       CxLLIRegData = CxLLIRegData + 0x00000010;

       /*
         Call LLIPrgm function to write LLI parameters and to program next
         LLI block.
       */ 
       LLIPrgm(Parameters->FirstChNoOfLLI, LLIAddr, SrcAddr, DestAddr,
               CxLLIRegData,  CxControlRegData, SrcAddrMask, DestAddrMask); 
     }

     /* Programming slave modules of First Channel */ 
     SlavePrgm(
               Parameters->FirstChFlowControl,
               Parameters->FirstChSrcPeriph,
               Parameters->FirstChDestPeriph,
               Parameters->FirstChSrcAHBResp,
               Parameters->FirstChDestAHBResp,
               Parameters->FirstChSrcWaitCyc,
               Parameters->FirstChDestWaitCyc,
               Parameters->DataGenMethod,
               Parameters->DataMethod,
               Parameters->FirstChSrcMaster,
               Parameters->FirstChDestMaster
              );
               
     /* Second Channel Programming */
     if (Parameters->SecondChSrcPeriph == NA)
     {
       /*
         If the source module is memory module and source AHB master is Master
         1, Program Memory module 0 as Source Slave module else program Memory
         module 1 as Source slave module.
       */
       if (Parameters->SecondChSrcMaster == MASTER1)
       {
         /* Select Memory module 0. Determine source address. */
         msg_info("Selecting Memory Module 0 as Source slave Peripheral");
         SrcAddr   = AddrGen(0x08000100, 0x0FFFFFFF) & SrcAddrMask;
       }
       else
       {
         /* Select memory module 1. Determine source address. */
         msg_info("Selecting Memory Module1 as Source slave Peripheral");
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
       Addr  = AddressSelection(Parameters->SecondChSrcPeriph);

       /* Determine source address range */
       SrcAddr  = AddrGen(Addr, Addr | 0x0000FFFF) & SrcAddrMask;

       /* Set bit 1 to indicate that memory module 1 is configured to Master2 */
       if (Parameters->SecondChSrcMaster == MASTER2)
         TempPerpMaster = TempPerpMaster |
                          PeriphMasterSel[(Parameters->SecondChSrcPeriph) +2];

       sprintf(Message,"Source Peripheral : %d ",
                        Parameters->SecondChSrcPeriph);
       msg_info(Message);
     }
     if (Parameters->SecondChDestPeriph == NA)
     {
       /*
         If the destination module is memory module and destination AHB master
         is Master 1, Program Memory module 0 as Destination slave module else
         select memory module 1 as Destination slave module.
       */
       if (Parameters->SecondChDestMaster == MASTER1)
       {
         /* Select memory module 0. Determine destination address. */
         msg_info("Selecting Memory Module 0 as Destination slave Peripheral");
         DestAddr   = AddrGen(0x08000100, 0x0FFFFFFF) & DestAddrMask;
       }
       else
       {
         /* Select memory module 1. Determine destination address. */
         msg_info("Selecting Memory Module1 as Destination slave Peripheral");
         DestAddr   = AddrGen(0x10000100, 0x17FFFFFF) & DestAddrMask;

         /*
           Set bit 1 to indicate that memory module 1 is configured to Master2
         */
         TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
       }
     }
     else
     {
       /* Determine peripheral address range */
       Addr  = AddressSelection(Parameters->SecondChDestPeriph);

       /* Determine destination address */
       DestAddr = AddrGen(Addr, Addr | 0x0000FFFF) & DestAddrMask;

       sprintf(Message,"Destination Peripheral : %d",
                         Parameters->SecondChDestPeriph);
       msg_info(Message);

       /*
         If the destination AHB master is Master2, set respective peripheral
         bit of TempPerpMaster variable.
       */
       if (Parameters->SecondChDestMaster == MASTER2)
         TempPerpMaster = TempPerpMaster |
                          PeriphMasterSel[(Parameters->SecondChDestPeriph) +2];
     }

     /* Determine LLI slave address */
     LLIAddr   = Parameters->SecondChLLIAddr;

     /*
       If LLI Master is Master 1, select memory module as LLI block else select
       memory module 1.
     */
     if (Parameters->SecondChNoOfLLI > 0)
     {
       if (Parameters->SecondChLLIMaster == MASTER1)
       {
         /*
           Select memory module 0. Determine LLI address to program CxLLI
           register. Enable Memory Module 0.
         */
         CxLLIRegData = (LLIAddr & 0x00000030) | LLIADDRM1;
         Write(DMACTrMemEn0, MEMORYENABLE | ADDRBASED);
       }
       else
       {
         /*
           Select memory module 1. Determine LLI address to program CxLLI
           Register. Enable Memory Module 1.
         */
         CxLLIRegData = (LLIAddr & 0x00000030) | LLIADDRM2 | 0x00000001;
         TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
         Write(DMACTrMemEn1, MEMORYENABLE | ADDRBASED);
       }
     }
     else
       CxLLIRegData = 0x00000000; 

     /* Configure DMACREQCONFIG register */
     Write(DMACREQCONFIG, TempPerpMaster);

     /* Evaluate Control register data for second Channel */
     CxControlRegData =
                        Parameters->SecondChTxSize             |
                        SbValue(Parameters->SecondChSrcBurst)  |
                        DbValue(Parameters->SecondChDestBurst) |
                        SwValue(Parameters->SecondChSrcWidth)  |
                        DwValue(Parameters->SecondChDestWidth) |
                        SmValue(Parameters->SecondChSrcMaster) |
                        DmValue(Parameters->SecondChDestMaster)|
                        SiValue(Parameters->SecondChSrcIncr)   |
                        DiValue(Parameters->SecondChDestIncr)  |
                        Parameters->SecondChPROT;
 
    /* Programming Second Channel Source, Destination, LLI and Control
       register */
     ChannelPrgm(Parameters->SecondChannel, SrcAddr, DestAddr, CxLLIRegData,
                 CxControlRegData);

     /* Second Channel LLI Programming */
     if (Parameters->SecondChNoOfLLI > 0)
     {
       /* Generate Next LLI Source Address */
       SrcAddr      = AddrGen(SrcAddr,  SrcAddr  | 0x0000FFFF) & SrcAddrMask;

       /* Generate Next LLI Destination Address */
       DestAddr     = AddrGen(DestAddr, DestAddr | 0x0000FFFF) & DestAddrMask;

       /* Increment LLI address to next LLI block */
       CxLLIRegData = CxLLIRegData + 0x00000010;

       /*
         Call LLIPrgm Function to write LLI parameters and to program next
         LLI block.
       */
       LLIPrgm(Parameters->SecondChNoOfLLI, LLIAddr, SrcAddr, DestAddr,
               CxLLIRegData, CxControlRegData, SrcAddrMask, DestAddrMask);
     }

     /* Programming slave modules of Second channel */
     SlavePrgm(
               Parameters->SecondChFlowControl,
               Parameters->SecondChSrcPeriph,
               Parameters->SecondChDestPeriph,
               Parameters->SecondChSrcAHBResp,
               Parameters->SecondChDestAHBResp,
               Parameters->SecondChSrcWaitCyc,
               Parameters->SecondChDestWaitCyc,
               Parameters->DataGenMethod,
               Parameters->DataMethod,
               Parameters->SecondChSrcMaster,
               Parameters->SecondChDestMaster
              );

     /* Programming GrantCount Register for request based grant toggle mode */
     if (Parameters->FirstChSrcMaster   == MASTER2 ||
         Parameters->FirstChDestMaster  == MASTER2 ||
         Parameters->SecondChSrcMaster  == MASTER2 ||
         Parameters->SecondChDestMaster == MASTER2)
        Write(DMACGRANTCNT1, GrantReqBased | Count7);

     if (Parameters->FirstChSrcMaster   == MASTER1 ||
         Parameters->FirstChDestMaster  == MASTER1 ||
         Parameters->SecondChSrcMaster  == MASTER1 ||
         Parameters->SecondChDestMaster == MASTER1)
        Write(DMACGRANTCNT0, GrantReqBased | Count7);


     /* Program slave peripheral for programmed responses */
     if (Parameters->IsAnyPrgmResp)
       SlaveRespPrgm(PrgmCases, TwoChannelTests->TestNo,
                     Parameters->NoOfPrgmResp);

     /*
       Determine source peripheral value of first channel for the evaluation
       of first channel CxConfig register data. If the source slave is memory
       module then source peripheral value is zero. If the source slave is
       peripheral module, call SpValue function to determine source peripheral
       value.
     */  
     if (Parameters->FirstChSrcPeriph == NA)
       SrcPeriphValue = 0x00000000;
     else
       SrcPeriphValue = SpValue(Parameters->FirstChSrcPeriph);

     /*
       Determine destination peripheral value of the first channel for the
       evaluation of first channel CxConfig register data. If the destination
       slave is memory module then destination peripheral value is zero. If
       the Destination slave is peripheral module, call DpValue function to
       determine destination peripheral value.
     */  
     if (Parameters->FirstChDestPeriph == NA)
       DestPeriphValue = 0x00000000;
     else
       DestPeriphValue = DpValue(Parameters->FirstChDestPeriph);

     /* Evaluate First Channel CxConfig register data */
     C1ConfigData =
                    SrcPeriphValue                          |
                    DestPeriphValue                         |
                    Parameters->FirstChFlowControl          |
                    Parameters->FirstChLOCK                 |
                    Parameters->FirstChHALT                 |
                    CHXENABLE;

     /*
       Determine source peripheral value of second channel for the evaluation
       of second channel CxConfig register data. If the source slave is memory
       module then source peripheral value is zero. If the source slave is
       peripheral module, call SpValue function to determine source
       peripheral value.
     */  
     if (Parameters->SecondChSrcPeriph == NA)
       SrcPeriphValue = 0x00000000;
     else
       SrcPeriphValue = SpValue(Parameters->SecondChSrcPeriph);

     /*
       Determine destination peripheral value of the second channel for the
       evaluation of second channel CxConfig register data. If the destination
       slave is memory module then destination peripheral value is zero. If
       the Destination slave is peripheral module, call DpValue function to
       determine destination peripheral value.
     */  
     if (Parameters->SecondChDestPeriph == NA)
       DestPeriphValue = 0x00000000;
     else
       DestPeriphValue = DpValue(Parameters->SecondChDestPeriph);

   
     /* Evaluate Second Channel CxConfig register data */
     C2ConfigData =
                    SrcPeriphValue                          |
                    DestPeriphValue                         |
                    Parameters->SecondChFlowControl         |
                    Parameters->SecondChLOCK                |
                    Parameters->SecondChHALT                |
                    CHXENABLE;

     /*
       If first channel is to be enabled first, enable first channel and then
       enable second channel. if Second channel is to be enabled first, enable
       second channel first and then first channel.
     */ 
     if (Parameters->WhichChEnableFirst == Parameters->FirstChannel)
     {
       RegAddr = ChannelRegisters(Parameters->FirstChannel);
       Write (*RegAddr + 0x00000010, C1ConfigData);
       RegAddr = ChannelRegisters(Parameters->SecondChannel);
       Write (*RegAddr + 0x00000010, C2ConfigData);
     }
     else
     {
       RegAddr = ChannelRegisters(Parameters->SecondChannel);
       Write (*RegAddr + 0x00000010, C2ConfigData);
       RegAddr = ChannelRegisters(Parameters->FirstChannel);
       Write (*RegAddr + 0x00000010, C1ConfigData);
     }

     /* Programming DMA requests */
     if ((Parameters->FirstChFlowControl != M2MDMAC) || 
          (Parameters->SecondChFlowControl != M2MDMAC)) 
     { 
       struct PeriphReq *PeriphReq  = TwoChPeriphReq;

       /*
         Initialize Source/Destination request count to zero. It is used to 
         program DMA request register. 
       */     
       SrcReqCount        = 0x00000000;
       DestReqCount       = 0x00000000;

       /* Initialize number of source and destination request count to zero */
       FirstChSrcSREQ     = 0x00000000;
       FirstChSrcBREQ     = 0x00000000;
       FirstChSrcLSREQ    = 0x00000000;
       FirstChSrcLBREQ    = 0x00000000;
       FirstChDestSREQ    = 0x00000000;
       FirstChDestBREQ    = 0x00000000;
       FirstChDestLSREQ   = 0x00000000;
       FirstChDestLBREQ   = 0x00000000;
       SecondChSrcSREQ    = 0x00000000;
       SecondChSrcBREQ    = 0x00000000;
       SecondChSrcLSREQ   = 0x00000000;
       SecondChSrcLBREQ   = 0x00000000;
       SecondChDestSREQ   = 0x00000000;
       SecondChDestBREQ   = 0x00000000;
       SecondChDestLSREQ  = 0x00000000;
       SecondChDestLBREQ  = 0x00000000;

       /* program peripheral requests */
       while (PeriphReq->TestNo != "EOFREQCASE")
       {
          if (PeriphReq->TestNo ==  TwoChannelTests->TestNo)
          {
            /*
              If First channel requests is to be asserted first as indicated
              by which channel request should assert first, assert peripheral
              requests of first channel and then second channel. If Second
              channel requests is to be asserted first, assert second channel
              request and then second channel. 
            */
            if (Parameters->WhichChReqFirst == Parameters->FirstChannel)
            {
              /* Assert first channel request and then second channel */ 
              if (Parameters->FirstChFlowControl != M2MDMAC)
              {
                if ((Parameters->FirstChFlowControl != M2PDMAC)
                       && ( Parameters->FirstChFlowControl != M2PDP))
                {
                  /* Clear source count */
                  SrcReqCount       = 0x00000000;

                  /* Extract number of DMA source requests of first channel */ 
                  FirstChSrcSREQ    = PeriphReq->Request->FirstChSrcSREQ;
                  FirstChSrcBREQ    = PeriphReq->Request->FirstChSrcBREQ;
                  FirstChSrcLSREQ   = PeriphReq->Request->FirstChSrcLSREQ;
                  FirstChSrcLBREQ   = PeriphReq->Request->FirstChSrcLBREQ;
  
                  /* 
                    Check if source SREQ is to be asserted, set SREQ count in 
                    SrcReqCount variable. If there is no SREQ to be asserted
                    check for LSREQ is to be asserted if any. If LSREQ is to be
                    asserted, set LSREQ count in SrcReqCount variable.
                  */    
                  if (FirstChSrcSREQ)
                    SrcReqCount = SrcReqCount | 0x00000004;
                  else if (FirstChSrcLSREQ)
                    SrcReqCount = SrcReqCount | 0x00040000;

                  /*
                    Check if source BREQ is to be asserted, set BREQ count in  
                    SrcReqCount variable. If there is no BREQ to be asserted
                    check for LBREQ is to be asserted if any. If LBREQ is to be
                    asserted, set LBREQ count in SrcReqCount variable.
                  */
                  if (FirstChSrcBREQ)
                    SrcReqCount = SrcReqCount | 0x00000400;
                  else if (FirstChSrcLBREQ)
                    SrcReqCount = SrcReqCount | 0x04000000;

                  sprintf(Message,"Programming DMA Request of Peripheral %d ",
                          Parameters->FirstChSrcPeriph);
                  msg_info(Message);

                  /* Determine register base address of source peripheral */
                  Addr = SlaveAddrSelection(Parameters->FirstChSrcPeriph);
                  Write(Addr + 0x00000008, SrcReqCount);
                }
                if ((Parameters->FirstChFlowControl != P2MDMAC) &&
                    (Parameters->FirstChFlowControl != P2MSP))
                {
                  /* Clear Destination count */
                  DestReqCount      = 0x00000000;

                  /* Extract number of destination DMA requests of first
                     channel */ 
                  FirstChDestSREQ   = PeriphReq->Request->FirstChDestSREQ;
                  FirstChDestBREQ   = PeriphReq->Request->FirstChDestBREQ;
                  FirstChDestLSREQ  = PeriphReq->Request->FirstChDestLSREQ;
                  FirstChDestLBREQ  = PeriphReq->Request->FirstChDestLBREQ;
  
                  /*
                    Check if destination SREQ is to be asserted, set SREQ count
                    in DestReqCount variable. If there is no SREQ to be asserted
                    check for LSREQ is to be asserted if any. If LSREQ is to be
                    asserted, set LSREQ count in DestReqCount variable.
                  */
                  if (FirstChDestSREQ)
                    DestReqCount = DestReqCount | 0x00000004;
                  else if (FirstChDestLSREQ)
                    DestReqCount = DestReqCount | 0x00040000;
   
                  /* 
                    Check if destination BREQ is to be asserted, set BREQ count
                    in DestReqCount variable. If there is no BREQ to be asserted
                    check for LBREQ is to be asserted if any. If LBREQ is to be
                    asserted, set LBREQ count in DestReqCount variable.
                  */
                  if (FirstChDestBREQ)
                    DestReqCount = DestReqCount | 0x00000400;
                  else if (FirstChDestLBREQ)
                    DestReqCount = DestReqCount | 0x04000000;
   
                  sprintf(Message,"Programming DMA Request of Peripheral %d ", 
                          Parameters->FirstChDestPeriph);
                  msg_info(Message);

                  /* Determine register base address of destination
                     peripheral */
                  Addr = SlaveAddrSelection( Parameters->FirstChDestPeriph);
                  Write(Addr + 0x00000008, DestReqCount);
                }
            }

            if (Parameters->SecondChFlowControl != M2MDMAC)
            {
              if ((Parameters->SecondChFlowControl != M2PDMAC) &&
                  (Parameters->SecondChFlowControl != M2PDP))
              {
                /* Clear source count */
                SrcReqCount        = 0x00000000;

                /* Extract number of DMA source requests of second channel */ 
                SecondChSrcSREQ    = PeriphReq->Request->SecondChSrcSREQ;
                SecondChSrcBREQ    = PeriphReq->Request->SecondChSrcBREQ;
                SecondChSrcLSREQ   = PeriphReq->Request->SecondChSrcLSREQ;
                SecondChSrcLBREQ   = PeriphReq->Request->SecondChSrcLBREQ;

                /*
                  Check if source SREQ is to be asserted, set SREQ count in
                  SrcReqCount variable. If there is no SREQ to be asserted
                  check for LSREQ is to be asserted if any. If LSREQ is to be
                  asserted, set LSREQ count in SrcReqCount variable.
                */
                if (SecondChSrcSREQ)
                  SrcReqCount = SrcReqCount | 0x00000004;
                else if (SecondChSrcLSREQ)
                  SrcReqCount = SrcReqCount | 0x00040000;

                /*
                  Check if source BREQ is to be asserted, set BREQ count in
                  SrcReqCount variable. If there is no BREQ to be asserted
                  check for LBREQ is to be asserted if any. If LBREQ is to be
                  asserted, set LBREQ count in SrcReqCount variable.
                */
                if (SecondChSrcBREQ)
                  SrcReqCount = SrcReqCount | 0x00000400;
                else if (SecondChSrcLBREQ)
                  SrcReqCount = SrcReqCount | 0x04000000;
              
                sprintf(Message,"Programming DMA Request of Peripheral %d ",
                        Parameters->SecondChSrcPeriph);
                msg_info(Message);

                /* Determine register base address of source peripheral */
                Addr = SlaveAddrSelection(Parameters->SecondChSrcPeriph);
                Write(Addr + 0x00000008, SrcReqCount);
              }
              if ((Parameters->SecondChFlowControl != P2MDMAC) &&
                  (Parameters->SecondChFlowControl != P2MSP))
              {
                /* Clear Destination count */
                DestReqCount       = 0x00000000;

                /* Extract number of destination DMA requests of second
                   channel */
                SecondChDestSREQ   = PeriphReq->Request->SecondChDestSREQ;
                SecondChDestBREQ   = PeriphReq->Request->SecondChDestBREQ;
                SecondChDestLSREQ  = PeriphReq->Request->SecondChDestLSREQ;
                SecondChDestLBREQ  = PeriphReq->Request->SecondChDestLBREQ;
   
                /*
                  Check if destination SREQ is to be asserted, set SREQ count
                  in DestReqCount variable. If there is no SREQ to be asserted
                  check for LSREQ is to be asserted if any. If LSREQ is to be
                  asserted, set LSREQ count in DestReqCount variable.
                */
                if (SecondChDestSREQ)
                  DestReqCount = DestReqCount | 0x00000004;
                else if (SecondChDestLSREQ)
                  DestReqCount = DestReqCount | 0x00040000;

                /*
                  Check if destination BREQ is to be asserted, set BREQ count
                  in DestReqCount variable. If there is no BREQ to be asserted
                  check for LBREQ is to be asserted if any. If LBREQ is to be
                  asserted, set LBREQ count in DestReqCount variable.
                */ 
                if (SecondChDestBREQ)
                  DestReqCount = DestReqCount | 0x00000400;
                else if (SecondChDestLBREQ)
                  DestReqCount = DestReqCount | 0x04000000;

                sprintf(Message,"Programming DMA Request of Peripheral %d ",
                        Parameters->SecondChDestPeriph);
                msg_info(Message);

                /* Determine register base address of destination peripheral */
                Addr = SlaveAddrSelection(Parameters->SecondChDestPeriph);
                Write(Addr + 0x00000008, DestReqCount);
              }
            }
          }
          else
          {
            /* Assert second channel requests first and then first channel. */
            if (Parameters->SecondChFlowControl != M2MDMAC)
            {
              if ((Parameters->SecondChFlowControl != M2PDMAC) &&
                  (Parameters->SecondChFlowControl != M2PDP))
              {
                /* Clear source count */
                SrcReqCount        = 0x00000000;

                /* Extract number of DMA source requests of second channel */
                SecondChSrcSREQ    = PeriphReq->Request->SecondChSrcSREQ;
                SecondChSrcBREQ    = PeriphReq->Request->SecondChSrcBREQ;
                SecondChSrcLSREQ   = PeriphReq->Request->SecondChSrcLSREQ;
                SecondChSrcLBREQ   = PeriphReq->Request->SecondChSrcLBREQ;

                /*
                  Check if source SREQ is to be asserted, set SREQ count in
                  SrcReqCount variable. If there is no SREQ to be asserted
                  check for LSREQ is to be asserted if any. If LSREQ is to be
                  asserted, set LSREQ count in SrcReqCount variable.
                */
                if (SecondChSrcSREQ)
                  SrcReqCount = SrcReqCount | 0x00000002;
                else if (SecondChSrcLSREQ)
                  SrcReqCount = SrcReqCount | 0x00020000;

                /* 
                  Check if source BREQ is to be asserted, set BREQ count in
                  SrcReqCount variable. If there is no BREQ to be asserted
                  check for LBREQ is to be asserted if any. If LBREQ is to be
                  asserted, set LBREQ count in SrcReqCount variable.
                */ 
                if (SecondChSrcBREQ)
                  SrcReqCount = SrcReqCount | 0x00000200;
                else if (SecondChSrcLBREQ)
                  SrcReqCount = SrcReqCount | 0x02000000;

                sprintf(Message,"Programming DMA Request of Peripheral %d ",
                        Parameters->SecondChSrcPeriph);
                msg_info(Message);
                  
                /* Determine register base address of source peripheral */
                Addr = SlaveAddrSelection(Parameters->SecondChSrcPeriph);
                Write(Addr + 0x00000008, SrcReqCount);
              }
              if ((Parameters->SecondChFlowControl != P2MDMAC) &&
                  (Parameters->SecondChFlowControl != P2MSP))
              {
                /* Clear Destination count */
                DestReqCount       = 0x00000000;

                /* Extract number of destination DMA requests of second
                   channel */
                SecondChDestSREQ   = PeriphReq->Request->SecondChDestSREQ;
                SecondChDestBREQ   = PeriphReq->Request->SecondChDestBREQ;
                SecondChDestLSREQ  = PeriphReq->Request->SecondChDestLSREQ;
                SecondChDestLBREQ  = PeriphReq->Request->SecondChDestLBREQ;
  
                /*
                  Check if destination SREQ is to be asserted, set SREQ count
                  in DestReqCount variable. If there is no SREQ to be asserted
                  check for LSREQ is to be asserted if any. If LSREQ is to be
                  asserted, set LSREQ count in DestReqCount variable.
                */
                if (SecondChDestSREQ)
                  DestReqCount = DestReqCount | 0x00000002;
                else if (SecondChDestLSREQ)
                  DestReqCount = DestReqCount | 0x00020000;

                /*
                  Check if destination BREQ is to be asserted, set BREQ count
                  in DestReqCount variable. If there is no BREQ to be asserted
                  check for LBREQ is to be asserted if any. If LBREQ is to be
                  asserted, set LBREQ count in DestReqCount variable.
                */
                if (SecondChDestBREQ)
                  DestReqCount = DestReqCount | 0x00000200;
                else if (SecondChDestLBREQ)
                  DestReqCount = DestReqCount | 0x02000000;

                sprintf(Message,"Programming DMA Request of Peripheral %d ",
                        Parameters->SecondChDestPeriph);
                msg_info(Message);

                /* Determine register base address of destination peripheral */
                Addr = SlaveAddrSelection(Parameters->SecondChDestPeriph);
                Write(Addr + 0x00000008, DestReqCount);
              }
            }
            if (Parameters->FirstChFlowControl != M2MDMAC)
            {
              if ((Parameters->FirstChFlowControl != M2PDMAC)
                     && ( Parameters->FirstChFlowControl != M2PDP))
              {
                /* Clear source count */
                SrcReqCount        = 0x00000000;

                /* Extract number of DMA source requests of first channel */
                FirstChSrcSREQ    = PeriphReq->Request->FirstChSrcSREQ;
                FirstChSrcBREQ    = PeriphReq->Request->FirstChSrcBREQ;
                FirstChSrcLSREQ   = PeriphReq->Request->FirstChSrcLSREQ;
                FirstChSrcLBREQ   = PeriphReq->Request->FirstChSrcLBREQ;

                /*
                  Check if source SREQ is to be asserted, set SREQ count in
                  SrcReqCount variable. If there is no SREQ to be asserted
                  check for LSREQ is to be asserted if any. If LSREQ is to be
                  asserted, set LSREQ count in SrcReqCount variable.
                */ 
                if (FirstChSrcSREQ)
                  SrcReqCount = SrcReqCount | 0x00000004;
                else if (FirstChSrcLSREQ)
                  SrcReqCount = SrcReqCount | 0x00040000;

                /*
                  Check if source BREQ is to be asserted, set BREQ count in
                  SrcReqCount variable. If there is no BREQ to be asserted
                  check for LBREQ is to be asserted if any. If LBREQ is to be
                  asserted, set LBREQ count in SrcReqCount variable.
                */
                if (FirstChSrcBREQ)
                  SrcReqCount = SrcReqCount | 0x00000400;
                else if (FirstChSrcLBREQ)
                  SrcReqCount = SrcReqCount | 0x04000000;

                sprintf(Message,"Programming DMA Request of Peripheral %d ",
                        Parameters->FirstChSrcPeriph);
                msg_info(Message);

                /* Determine register base address of source peripheral */
                Addr = SlaveAddrSelection(Parameters->FirstChSrcPeriph);
                Write(Addr + 0x00000008, SrcReqCount);
              }
              if ((Parameters->FirstChFlowControl != P2MDMAC) &&
                  (Parameters->FirstChFlowControl != P2MSP))
              {
                /* Clear Destination count */
                DestReqCount       = 0x00000000;
       
                /* Extract number of destination DMA requests of first
                   channel */
                FirstChDestSREQ   = PeriphReq->Request->FirstChDestSREQ;
                FirstChDestBREQ   = PeriphReq->Request->FirstChDestBREQ;
                FirstChDestLSREQ  = PeriphReq->Request->FirstChDestLSREQ;
                FirstChDestLBREQ  = PeriphReq->Request->FirstChDestLBREQ;

                /*
                  Check if destination SREQ is to be asserted, set SREQ count
                  in DestReqCount variable. If there is no SREQ to be asserted
                  check for LSREQ is to be asserted if any. If LSREQ is to be
                  asserted, set LSREQ count in DestReqCount variable.
                */
                if (FirstChDestSREQ)
                  DestReqCount = DestReqCount | 0x00000004;
                else if (FirstChDestLSREQ)
                  DestReqCount = DestReqCount | 0x00040000;

                /*
                  Check if destination BREQ is to be asserted, set BREQ count
                  in DestReqCount variable. If there is no BREQ to be asserted
                  check for LBREQ is to be asserted if any. If LBREQ is to be
                  asserted, set LBREQ count in DestReqCount variable.
                */
                if (FirstChDestBREQ)
                  DestReqCount = DestReqCount | 0x00000400;
                else if (FirstChDestLBREQ)
                  DestReqCount = DestReqCount | 0x04000000;

                sprintf(Message,"Programming DMA Request of Peripheral %d ",
                        Parameters->FirstChDestPeriph);
                msg_info(Message);

                /* Determine register base address of destination peripheral */
                Addr = SlaveAddrSelection( Parameters->FirstChDestPeriph);
                Write(Addr + 0x00000008, DestReqCount);
              }
            }
          } 
          break;
        }
        PeriphReq++;  
       }
     }
     WaitLoop(10);

     if (TwoChannelTests->TestNo == "DMAC_2CH_19" ||
         TwoChannelTests->TestNo == "DMAC_2CH_20" ||
         TwoChannelTests->TestNo == "DMAC_2CH_28" ||
         TwoChannelTests->TestNo == "DMAC_2CH_29" ||
         TwoChannelTests->TestNo == "DMAC_2CH_30")
     {
        if (TwoChannelTests->TestNo == "DMAC_2CH_20")
        {
          /* DMAC HALT Test cases */
          WaitLoop(10);
          /* Determine first channel base address */
          RegAddr = ChannelRegisters(Parameters->FirstChannel);
          /* Set Halt bit of first channel */
          Write (*RegAddr + 0x00000010, C1ConfigData | DMACHALT);
          WaitLoop(40);
          /* Clear Halt of first channel */
          Write (*RegAddr + 0x00000010, C1ConfigData);
        }
        if (TwoChannelTests->TestNo == "DMAC_2CH_28" || 
            TwoChannelTests->TestNo == "DMAC_2CH_29" || 
            TwoChannelTests->TestNo == "DMAC_2CH_30")
        {
          /* DMAC DISABLE Test cases */
          /* Determine first channel base address */
          RegAddr = ChannelRegisters(Parameters->FirstChannel);
          /*Disable first Channel */
          Write (*RegAddr + 0x00000010, C1ConfigData & DMACDISABLE);
          WaitLoop(10);
        }   
     }
     else
     {
       /* Wait till all peripheral requests are asserted and cleared */ 
       while (FirstChSrcBREQ   || FirstChSrcSREQ   || FirstChDestBREQ   ||
              FirstChDestSREQ  || SecondChSrcBREQ  || SecondChSrcSREQ   ||
              SecondChDestBREQ || SecondChDestSREQ || FirstChSrcLBREQ   ||
              FirstChSrcLSREQ  || FirstChDestLBREQ || FirstChDestLSREQ  ||
              SecondChSrcLBREQ || SecondChSrcLSREQ || SecondChDestLBREQ ||
              SecondChDestLSREQ)
       {
          /* 
            If the flow controller of both channel are P2P flow controller,
            call DMAREQSET or DMALastReq function depending on flow controller.
            If the first channel flow controller is P2P destination peripheral
            or P2P DMAC flow controller, call DMAREQSET function. If flow
            controller is P2P source peripheral flow controller, call
            DMALastReq function.
          */  
          if ((Parameters->FirstChFlowControl == P2PDP ||
               Parameters->FirstChFlowControl == P2PSP ||
               Parameters->FirstChFlowControl == P2PDMAC) &&
              (Parameters->SecondChFlowControl == P2PDP ||
               Parameters->SecondChFlowControl == P2PSP ||
               Parameters->SecondChFlowControl == P2PDMAC))
          {
            if (Parameters->FirstChannel < Parameters->SecondChannel)
            {
              /*
                If the first channel is enabled first, check source/destination
                DMA requests of first channel are cleared. Assert source and
                destination peripheral requests of first channel if any. Check
                second channel requests are cleared. Assert source and
                destination request of second channel if any. Call DMAREQSET,
                DMALastReq function depending on flow controller
              */    
              if (Parameters->WhichChEnableFirst == Parameters->FirstChannel)
              {
                /* For First channel */
                if (Parameters->FirstChFlowControl == P2PDP || 
                      Parameters->FirstChFlowControl == P2PDMAC)
                  DMAREQSET(Parameters->FirstChannel, 
                            Parameters-> FirstChSrcPeriph, &FirstChSrcSREQ,
                            &FirstChSrcBREQ, &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                            Parameters->FirstChDestPeriph, &FirstChDestSREQ,
                            &FirstChDestBREQ, &FirstChDestLSREQ,
                            &FirstChDestLBREQ,
                            Parameters->FirstChFlowControl);
                if (Parameters->FirstChFlowControl == P2PSP)
                  DMALastReq(Parameters->FirstChannel,
                             Parameters->FirstChFlowControl,
                             Parameters->FirstChSrcPeriph,
                             &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                             Parameters->FirstChDestPeriph,
                             &FirstChDestBREQ);
                /* For Second channel */
                if (Parameters->SecondChFlowControl == P2PDP || 
                      Parameters->SecondChFlowControl == P2PDMAC)
                  DMAREQSET(Parameters->SecondChannel,
                            Parameters->SecondChSrcPeriph, &SecondChSrcSREQ,
                            &SecondChSrcBREQ, &SecondChSrcLSREQ,
                            &SecondChSrcLBREQ, Parameters->SecondChDestPeriph,
                            &SecondChDestSREQ, &SecondChDestBREQ,
                            &SecondChDestLSREQ, &SecondChDestLBREQ,
                            Parameters->SecondChFlowControl);
  
                if (Parameters->SecondChFlowControl == P2PSP)
                  DMALastReq(Parameters->SecondChannel,
                             Parameters->SecondChFlowControl,
                             Parameters->SecondChSrcPeriph,
                             &SecondChSrcLSREQ, &SecondChSrcLBREQ,
                             Parameters->SecondChDestPeriph,
                             &SecondChDestBREQ);
             
              }
              else
              {
                /* For Second channel */
                if (Parameters->SecondChFlowControl == P2PDP ||
                      Parameters->SecondChFlowControl == P2PDMAC)
                  DMAREQSET(Parameters->SecondChannel,
                            Parameters->SecondChSrcPeriph, &SecondChSrcSREQ,
                            &SecondChSrcBREQ, &SecondChSrcLSREQ,
                            &SecondChSrcLBREQ, Parameters->SecondChDestPeriph,
                            &SecondChDestSREQ, &SecondChDestBREQ,
                            &SecondChDestLSREQ, &SecondChDestLBREQ,
                            Parameters->SecondChFlowControl);
  
                if (Parameters->SecondChFlowControl == P2PSP)
                  DMALastReq(Parameters->SecondChannel,
                             Parameters->SecondChFlowControl,
                             Parameters->SecondChSrcPeriph,
                             &SecondChSrcLSREQ, &SecondChSrcLBREQ,
                             Parameters->SecondChDestPeriph,
                             &SecondChDestBREQ);
  
                /* For First channel */
                if (Parameters->FirstChFlowControl == P2PDP ||
                      Parameters->FirstChFlowControl == P2PDMAC)
                  DMAREQSET(Parameters->FirstChannel,
                            Parameters-> FirstChSrcPeriph, &FirstChSrcSREQ,
                            &FirstChSrcBREQ, &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                            Parameters->FirstChDestPeriph, &FirstChDestSREQ,
                            &FirstChDestBREQ, &FirstChDestLSREQ,
                            &FirstChDestLBREQ,
                            Parameters->FirstChFlowControl);
  
                if (Parameters->FirstChFlowControl == P2PSP)
                  DMALastReq(Parameters->FirstChannel,
                             Parameters->FirstChFlowControl,
                             Parameters->FirstChSrcPeriph,
                             &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                             Parameters->FirstChDestPeriph,
                             &FirstChDestBREQ);
               
              } 
            }
            else
            {
              /*
                If the second channel is enabled first, check source/destination
                DMA requests of second channel are cleared. Assert source and
                destination peripheral requests of second channel if any.
                Check that first channel requests are cleared. Assert source and
                destination request of second channel if any. Call DMAREQSET,
                DMALastReq function depending on flow controller
              */
              if (Parameters->WhichChEnableFirst == Parameters->SecondChannel)
              {
                /* For Second channel */
                if (Parameters->SecondChFlowControl == P2PDP ||
                    Parameters->SecondChFlowControl == P2PDMAC)
                  DMAREQSET(Parameters->SecondChannel,
                            Parameters->SecondChSrcPeriph, &SecondChSrcSREQ,
                            &SecondChSrcBREQ, &SecondChSrcLSREQ,
                            &SecondChSrcLBREQ, Parameters->SecondChDestPeriph,
                            &SecondChDestSREQ, &SecondChDestBREQ,
                            &SecondChDestLSREQ, &SecondChDestLBREQ,
                            Parameters->SecondChFlowControl);
  
                if (Parameters->SecondChFlowControl == P2PSP)
                  DMALastReq(Parameters->SecondChannel,
                             Parameters->SecondChFlowControl,
                             Parameters->SecondChSrcPeriph,
                             &SecondChSrcLSREQ, &SecondChSrcLBREQ,
                             Parameters->SecondChDestPeriph,
                             &SecondChDestBREQ);
  
                /* For First channel */
                if (Parameters->FirstChFlowControl == P2PDP ||
                    Parameters->FirstChFlowControl == P2PDMAC)
                  DMAREQSET(Parameters->FirstChannel,
                            Parameters-> FirstChSrcPeriph, &FirstChSrcSREQ,
                            &FirstChSrcBREQ, &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                            Parameters->FirstChDestPeriph, &FirstChDestSREQ,
                            &FirstChDestBREQ, &FirstChDestLSREQ,
                            &FirstChDestLBREQ,
                            Parameters->FirstChFlowControl);
  
                if (Parameters->FirstChFlowControl == P2PSP)
                  DMALastReq(Parameters->FirstChannel,
                             Parameters->FirstChFlowControl,
                             Parameters->FirstChSrcPeriph,
                             &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                             Parameters->FirstChDestPeriph,
                             &FirstChDestBREQ);
  
              }
              else
              {
                /* For First channel */
                if (Parameters->FirstChFlowControl == P2PDP ||
                    Parameters->FirstChFlowControl == P2PDMAC)
                  DMAREQSET(Parameters->FirstChannel,
                            Parameters-> FirstChSrcPeriph, &FirstChSrcSREQ,
                            &FirstChSrcBREQ, &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                            Parameters->FirstChDestPeriph, &FirstChDestSREQ,
                            &FirstChDestBREQ, &FirstChDestLSREQ,
                            &FirstChDestLBREQ,
                            Parameters->FirstChFlowControl);
  
                if (Parameters->FirstChFlowControl == P2PSP)
                  DMALastReq(Parameters->FirstChannel,
                             Parameters->FirstChFlowControl,
                             Parameters->FirstChSrcPeriph,
                             &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                             Parameters->FirstChDestPeriph,
                             &FirstChDestBREQ);
  
                /* For Second channel */
                if (Parameters->SecondChFlowControl == P2PDP ||
                    Parameters->SecondChFlowControl == P2PDMAC)
                  DMAREQSET(Parameters->SecondChannel,
                            Parameters->SecondChSrcPeriph, &SecondChSrcSREQ,
                            &SecondChSrcBREQ, &SecondChSrcLSREQ,
                            &SecondChSrcLBREQ, Parameters->SecondChDestPeriph,
                            &SecondChDestSREQ, &SecondChDestBREQ,
                            &SecondChDestLSREQ, &SecondChDestLBREQ,
                            Parameters->SecondChFlowControl);
  
                if (Parameters->SecondChFlowControl == P2PSP)
                  DMALastReq(Parameters->SecondChannel,
                             Parameters->SecondChFlowControl,
                             Parameters->SecondChSrcPeriph,
                             &SecondChSrcLSREQ, &SecondChSrcLBREQ,
                             Parameters->SecondChDestPeriph,
                             &SecondChDestBREQ);
              }
            }
          }
          else if (Parameters->FirstChannel < Parameters->SecondChannel)
          {
            /*
              If both channel flow controller are not P2P flow controller,
              call DMALastReq, SingleChReq and DMAREQSET depending on type of
              flow controller. The DMALastReq function is called if flow
              controller is P2M source peripheral or P2P source peripheral flow
              controller. The SingleChReq function is called if flow controller
              is M2P DMAC or M2P destination peripheral flow controller. The 
              DMAREQSET function is called if flow controller is P2P Source
              Peripheral, P2P Destination Peripheral, P2P DMAC, P2M DMAC or P2M
              Source Peripheral flow controller. 
            */
            if (Parameters->WhichChEnableFirst == Parameters->FirstChannel)
            {
              /*
                If the first channel is enabled first, check source/destination
                DMA requests of first channel are cleared. Assert source and
                destination peripheral requests of first channel if any. Check
                second channel requests are cleared. Assert source and
                destination request of second channel if any. Call DMAREQSET,
                DMALastReq or SingleChReq function depending on flow controller
              */

              if (FirstChDestSREQ || FirstChDestBREQ || FirstChDestLBREQ ||
                  FirstChDestLSREQ)
              {
                if (FirstChSrcLSREQ || FirstChSrcLBREQ)
                  DMALastReq(Parameters->FirstChannel,
                             Parameters->FirstChFlowControl,
                             Parameters->FirstChSrcPeriph, 
                             &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                             Parameters->FirstChDestPeriph, 
                             &FirstChDestBREQ);
                else if (FirstChSrcSREQ == 0 && FirstChSrcBREQ == 0)
                  SingleChReq(Parameters->FirstChannel,
                              Parameters->FirstChFlowControl,
                              Parameters->FirstChDestPeriph,
                              &FirstChDestSREQ, &FirstChDestBREQ,
                              &FirstChDestLBREQ, &FirstChDestLSREQ);
                else if ((FirstChSrcSREQ == 0) || (FirstChSrcBREQ == 0))
                  DMAREQSET(Parameters->FirstChannel,
                            Parameters->FirstChSrcPeriph, &FirstChSrcSREQ,
                            &FirstChSrcBREQ, &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                            Parameters->FirstChDestPeriph, &FirstChDestSREQ,
                            &FirstChDestBREQ, &FirstChDestLSREQ, 
                            &FirstChDestLBREQ,
                            Parameters->FirstChFlowControl);
              }
              else if (FirstChSrcSREQ || FirstChSrcBREQ || FirstChSrcLSREQ ||
                       FirstChSrcLBREQ)
              {
                if (FirstChSrcSREQ || FirstChSrcBREQ) 
                  DMAREQSET(Parameters->FirstChannel,
                            Parameters->FirstChSrcPeriph, &FirstChSrcSREQ,
                            &FirstChSrcBREQ, &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                            Parameters->FirstChDestPeriph, &FirstChDestSREQ,
                            &FirstChDestBREQ, &FirstChDestLSREQ, 
                            &FirstChDestLBREQ,
                            Parameters->FirstChFlowControl);
                else if (FirstChSrcLSREQ || FirstChSrcLBREQ)
                  DMALastReq(Parameters->FirstChannel,
                             Parameters->FirstChFlowControl,
                             Parameters->FirstChSrcPeriph, 
                             &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                             Parameters->FirstChDestPeriph, 
                             &FirstChDestBREQ);
              }
              else if (SecondChDestSREQ || SecondChDestBREQ || 
                       SecondChDestLBREQ || SecondChDestLSREQ)
              {
                if (SecondChSrcLSREQ || SecondChSrcLBREQ)
                  DMALastReq(Parameters->SecondChannel,
                             Parameters->SecondChFlowControl,
                             Parameters->SecondChSrcPeriph,
                             &SecondChSrcLSREQ, &SecondChSrcLBREQ,
                             Parameters->SecondChDestPeriph,
                             &SecondChDestBREQ);
                else if (SecondChSrcSREQ == 0 && SecondChSrcBREQ == 0)
                  SingleChReq(Parameters->SecondChannel, 
                              Parameters->SecondChFlowControl,
                              Parameters->SecondChDestPeriph,
                              &SecondChDestSREQ, &SecondChDestBREQ,
                              &SecondChDestLBREQ, &SecondChDestLSREQ); 
                else if ((SecondChSrcSREQ == 0) || (SecondChSrcBREQ == 0))
                  DMAREQSET(Parameters->SecondChannel, 
                            Parameters->SecondChSrcPeriph, &SecondChSrcSREQ,
                            &SecondChSrcBREQ, &SecondChSrcLSREQ,
                            &SecondChSrcLBREQ, Parameters->SecondChDestPeriph,
                            &SecondChDestSREQ, &SecondChDestBREQ,
                            &SecondChDestLSREQ, &SecondChDestLBREQ,
                            Parameters->SecondChFlowControl);
              }
              else if (SecondChSrcSREQ || SecondChSrcBREQ || SecondChSrcLSREQ ||
                       SecondChSrcLBREQ)
              {
                if (SecondChSrcSREQ || SecondChSrcBREQ) 
                  DMAREQSET(Parameters->SecondChannel,
                            Parameters->SecondChSrcPeriph, &SecondChSrcSREQ,
                            &SecondChSrcBREQ, &SecondChSrcLSREQ,
                            &SecondChSrcLBREQ, Parameters->SecondChDestPeriph,
                            &SecondChDestSREQ, &SecondChDestBREQ,
                            &SecondChDestLSREQ, &SecondChDestLBREQ,
                            Parameters->SecondChFlowControl);
                else if (SecondChSrcLSREQ || SecondChSrcLBREQ)
                  DMALastReq(Parameters->SecondChannel,
                             Parameters->SecondChFlowControl,
                             Parameters->SecondChSrcPeriph, 
                             &SecondChSrcLSREQ, &SecondChSrcLBREQ,
                             Parameters->SecondChDestPeriph, 
                             &SecondChDestBREQ);
              }
            }
            else
            {
               /*
                If the second channel is enabled first, check source/destination
                DMA requests of second channel are cleared. Assert source and
                destination peripheral requests of second channel if any. Check
                first channel requests are cleared. Assert source and
                destination request of first channel if any. Call DMAREQSET,
                DMALastReq or SingleChReq function depending on flow controller
              */
              if (SecondChDestSREQ || SecondChDestBREQ || SecondChDestLBREQ ||
                  SecondChDestLSREQ)
              {
                if (SecondChSrcLSREQ || SecondChSrcLBREQ)
                  DMALastReq(Parameters->SecondChannel,
                             Parameters->SecondChFlowControl,
                             Parameters->SecondChSrcPeriph,
                             &SecondChSrcLSREQ, &SecondChSrcLBREQ,
                             Parameters->SecondChDestPeriph,
                             &SecondChDestBREQ);
                else if (SecondChSrcSREQ == 0 && SecondChSrcBREQ == 0)
                  SingleChReq(Parameters->SecondChannel,
                              Parameters->SecondChFlowControl,
                              Parameters->SecondChDestPeriph,
                              &SecondChDestSREQ, &SecondChDestBREQ,
                              &SecondChDestLBREQ, &SecondChDestLSREQ);
                else if ((SecondChSrcSREQ == 0) || (SecondChSrcBREQ == 0))
                  DMAREQSET(Parameters->SecondChannel,
                            Parameters->SecondChSrcPeriph, &SecondChSrcSREQ,
                            &SecondChSrcBREQ, &SecondChSrcLSREQ,
                            &SecondChSrcLBREQ, Parameters->SecondChDestPeriph,
                            &SecondChDestSREQ, &SecondChDestBREQ,
                            &SecondChDestLSREQ, &SecondChDestLBREQ,
                            Parameters->SecondChFlowControl);
              }
              else if (SecondChSrcSREQ || SecondChSrcBREQ || SecondChSrcLSREQ ||
                       SecondChSrcLBREQ)
              {
                if (SecondChSrcSREQ || SecondChSrcBREQ)
                  DMAREQSET(Parameters->SecondChannel,
                            Parameters->SecondChSrcPeriph, &SecondChSrcSREQ,
                            &SecondChSrcBREQ, &SecondChSrcLSREQ,
                            &SecondChSrcLBREQ, Parameters->SecondChDestPeriph,
                            &SecondChDestSREQ, &SecondChDestBREQ,
                            &SecondChDestLSREQ, &SecondChDestLBREQ,
                            Parameters->SecondChFlowControl);
                else if (SecondChSrcLSREQ || SecondChSrcLBREQ)
                  DMALastReq(Parameters->SecondChannel,
                             Parameters->SecondChFlowControl,
                             Parameters->SecondChSrcPeriph,
                             &SecondChSrcLSREQ, &SecondChSrcLBREQ,
                             Parameters->SecondChDestPeriph,
                             &SecondChDestBREQ);
              }
              else if (FirstChDestSREQ || FirstChDestBREQ || FirstChDestLBREQ ||
                       FirstChDestLSREQ)
              {
                if (FirstChSrcLSREQ || FirstChSrcLBREQ)
                  DMALastReq(Parameters->FirstChannel,
                             Parameters->FirstChFlowControl,
                             Parameters->FirstChSrcPeriph,
                             &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                             Parameters->FirstChDestPeriph,
                             &FirstChDestBREQ);
                else if (FirstChSrcSREQ == 0 && FirstChSrcBREQ == 0)
                  SingleChReq(Parameters->FirstChannel,
                              Parameters->FirstChFlowControl,
                              Parameters->FirstChDestPeriph,
                              &FirstChDestSREQ, &FirstChDestBREQ,
                              &FirstChDestLBREQ, &FirstChDestLSREQ);
                else if ((FirstChSrcSREQ == 0) || (FirstChSrcBREQ == 0))
                  DMAREQSET(Parameters->FirstChannel,
                            Parameters->FirstChSrcPeriph, &FirstChSrcSREQ,
                            &FirstChSrcBREQ, &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                            Parameters->FirstChDestPeriph, &FirstChDestSREQ,
                            &FirstChDestBREQ, &FirstChDestLSREQ,
                            &FirstChDestLBREQ,
                            Parameters->FirstChFlowControl);
              }
              else if (FirstChSrcSREQ || FirstChSrcBREQ || FirstChSrcLSREQ ||
                       FirstChSrcLBREQ)
              {
                if (FirstChSrcSREQ || FirstChSrcBREQ)
                  DMAREQSET(Parameters->FirstChannel,
                            Parameters->FirstChSrcPeriph, &FirstChSrcSREQ,
                            &FirstChSrcBREQ, &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                            Parameters->FirstChDestPeriph, &FirstChDestSREQ,
                            &FirstChDestBREQ, &FirstChDestLSREQ,
                            &FirstChDestLBREQ,
                            Parameters->FirstChFlowControl);
                else if (FirstChSrcLSREQ || FirstChSrcLBREQ)
                  DMALastReq(Parameters->FirstChannel,
                             Parameters->FirstChFlowControl,
                             Parameters->FirstChSrcPeriph,
                             &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                             Parameters->FirstChDestPeriph,
                             &FirstChDestBREQ);
              } 
            }
          }
          else if (Parameters->SecondChannel < Parameters->FirstChannel)
          {
             /*
              If both channel flow controller is not P2P flow controller,
              call DMALastReq, SingleChReq and DMAREQSET depending on type of
              flow controller. The DMALastReq function is called if flow
              controller is P2M source peripheral or P2P source peripheral flow
              controller. The SingleChReq function is called if flow controller
              is M2P DMAC or M2P destination peripheral flow controller. The
              DMAREQSET function is called if flow controller is P2P Source
              Peripheral, P2P Destination Peripheral, P2P DMAC, P2M DMAC or P2M
              Source Peripheral flow controller.
            */
            if (Parameters->WhichChEnableFirst == Parameters->SecondChannel)
            {
               /*
                If the second channel is enabled first, check source/destination
                DMA requests of second channel are cleared. Assert source and
                destination peripheral requests of second channel if any. Check
                first channel requests are cleared. Assert source and
                destination request of first channel if any. Call DMAREQSET,
                DMALastReq or SingleChReq function depending on flow controller
              */
              if (SecondChDestSREQ || SecondChDestBREQ || SecondChDestLBREQ ||
                  SecondChDestLSREQ)
              {
                if (SecondChSrcLSREQ || SecondChSrcLBREQ)
                  DMALastReq(Parameters->SecondChannel,
                             Parameters->SecondChFlowControl,
                             Parameters->SecondChSrcPeriph,
                             &SecondChSrcLSREQ, &SecondChSrcLBREQ,
                             Parameters->SecondChDestPeriph,
                             &SecondChDestBREQ);
                else if (SecondChSrcSREQ == 0 && SecondChSrcBREQ == 0)
                  SingleChReq(Parameters->SecondChannel,
                              Parameters->SecondChFlowControl,
                              Parameters->SecondChDestPeriph,
                              &SecondChDestSREQ, &SecondChDestBREQ,
                              &SecondChDestLBREQ, &SecondChDestLSREQ);
                else if ((SecondChSrcSREQ == 0) || (SecondChSrcBREQ == 0))
                  DMAREQSET(Parameters->SecondChannel,
                            Parameters->SecondChSrcPeriph, &SecondChSrcSREQ,
                            &SecondChSrcBREQ, &SecondChSrcLSREQ,
                            &SecondChSrcLBREQ, Parameters->SecondChDestPeriph,
                            &SecondChDestSREQ, &SecondChDestBREQ,
                            &SecondChDestLSREQ, &SecondChDestLBREQ,
                            Parameters->SecondChFlowControl);
              }
              else if (SecondChSrcSREQ || SecondChSrcBREQ || SecondChSrcLSREQ ||
                       SecondChSrcLBREQ)
              {
                if (SecondChSrcSREQ || SecondChSrcBREQ)
                  DMAREQSET(Parameters->SecondChannel,
                            Parameters->SecondChSrcPeriph, &SecondChSrcSREQ,
                            &SecondChSrcBREQ, &SecondChSrcLSREQ,
                            &SecondChSrcLBREQ, Parameters->SecondChDestPeriph,
                            &SecondChDestSREQ, &SecondChDestBREQ,
                            &SecondChDestLSREQ, &SecondChDestLBREQ,
                            Parameters->SecondChFlowControl);
                else if (SecondChSrcLSREQ || SecondChSrcLBREQ)
                  DMALastReq(Parameters->SecondChannel,
                             Parameters->SecondChFlowControl,
                             Parameters->SecondChSrcPeriph,
                             &SecondChSrcLSREQ, &SecondChSrcLBREQ,
                             Parameters->SecondChDestPeriph,
                             &SecondChDestBREQ);
              }
              else if (FirstChDestSREQ || FirstChDestBREQ || FirstChDestLBREQ ||
                       FirstChDestLSREQ)
              {
                if (FirstChSrcLSREQ || FirstChSrcLBREQ)
                  DMALastReq(Parameters->FirstChannel,
                             Parameters->FirstChFlowControl,
                             Parameters->FirstChSrcPeriph,
                             &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                             Parameters->FirstChDestPeriph,
                             &FirstChDestBREQ);
                else if (FirstChSrcSREQ == 0 && FirstChSrcBREQ == 0)
                  SingleChReq(Parameters->FirstChannel,
                              Parameters->FirstChFlowControl,
                              Parameters->FirstChDestPeriph,
                              &FirstChDestSREQ, &FirstChDestBREQ,
                              &FirstChDestLBREQ, &FirstChDestLSREQ);
                else if ((FirstChSrcSREQ == 0) || (FirstChSrcBREQ == 0))
                  DMAREQSET(Parameters->FirstChannel,
                            Parameters->FirstChSrcPeriph, &FirstChSrcSREQ,
                            &FirstChSrcBREQ, &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                            Parameters->FirstChDestPeriph, &FirstChDestSREQ,
                            &FirstChDestBREQ, &FirstChDestLSREQ,
                            &FirstChDestLBREQ,
                            Parameters->FirstChFlowControl);
              }
              else if (FirstChSrcSREQ || FirstChSrcBREQ || FirstChSrcLSREQ ||
                         FirstChSrcLBREQ)
              {
                if (FirstChSrcSREQ || FirstChSrcBREQ)
                  DMAREQSET(Parameters->FirstChannel,
                            Parameters->FirstChSrcPeriph, &FirstChSrcSREQ,
                            &FirstChSrcBREQ, &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                            Parameters->FirstChDestPeriph, &FirstChDestSREQ,
                            &FirstChDestBREQ, &FirstChDestLSREQ,
                            &FirstChDestLBREQ,
                            Parameters->FirstChFlowControl);
                else if (FirstChSrcLSREQ || FirstChSrcLBREQ)
                  DMALastReq(Parameters->FirstChannel,
                             Parameters->FirstChFlowControl,
                             Parameters->FirstChSrcPeriph,
                             &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                             Parameters->FirstChDestPeriph,
                             &FirstChDestBREQ);
              }
            }
            else
            {
              /*
                If the first channel is enabled first, check source/destination
                DMA requests of first channel are cleared. Assert source and
                destination peripheral requests of first channel if any.
                Check that second channel requests are cleared. Assert source
                and destination request of second channel if any. Call
                DMAREQSET, DMALastReq or SingleChReq function depending on
                flow controller
              */
              if (FirstChDestSREQ || FirstChDestBREQ || FirstChDestLBREQ ||
                    FirstChDestLSREQ)
              {
                if (FirstChSrcLSREQ || FirstChSrcLBREQ)
                  DMALastReq(Parameters->FirstChannel,
                             Parameters->FirstChFlowControl,
                             Parameters->FirstChSrcPeriph,
                             &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                             Parameters->FirstChDestPeriph,
                             &FirstChDestBREQ);
                else if (FirstChSrcSREQ == 0 && FirstChSrcBREQ == 0)
                  SingleChReq(Parameters->FirstChannel,
                              Parameters->FirstChFlowControl,
                              Parameters->FirstChDestPeriph,
                              &FirstChDestSREQ, &FirstChDestBREQ,
                              &FirstChDestLBREQ, &FirstChDestLSREQ);
                else if ((FirstChSrcSREQ == 0) || (FirstChSrcBREQ == 0))
                  DMAREQSET(Parameters->FirstChannel,
                            Parameters->FirstChSrcPeriph, &FirstChSrcSREQ,
                            &FirstChSrcBREQ, &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                            Parameters->FirstChDestPeriph, &FirstChDestSREQ,
                            &FirstChDestBREQ, &FirstChDestLSREQ,
                            &FirstChDestLBREQ,
                            Parameters->FirstChFlowControl);
              }
              else if (FirstChSrcSREQ || FirstChSrcBREQ || FirstChSrcLSREQ ||
                         FirstChSrcLBREQ)
              {
                if (FirstChSrcSREQ || FirstChSrcBREQ)
                  DMAREQSET(Parameters->FirstChannel,
                            Parameters->FirstChSrcPeriph, &FirstChSrcSREQ,
                            &FirstChSrcBREQ, &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                            Parameters->FirstChDestPeriph, &FirstChDestSREQ,
                            &FirstChDestBREQ, &FirstChDestLSREQ,
                            &FirstChDestLBREQ,
                            Parameters->FirstChFlowControl);
                else if (FirstChSrcLSREQ || FirstChSrcLBREQ)
                  DMALastReq(Parameters->FirstChannel,
                             Parameters->FirstChFlowControl,
                             Parameters->FirstChSrcPeriph,
                             &FirstChSrcLSREQ, &FirstChSrcLBREQ,
                             Parameters->FirstChDestPeriph,
                             &FirstChDestBREQ);
              }
              else if (SecondChDestSREQ || SecondChDestBREQ ||
                          SecondChDestLBREQ || SecondChDestLSREQ)
              {
                if (SecondChSrcLSREQ || SecondChSrcLBREQ)
                  DMALastReq(Parameters->SecondChannel,
                             Parameters->SecondChFlowControl,
                             Parameters->SecondChSrcPeriph,
                             &SecondChSrcLSREQ, &SecondChSrcLBREQ,
                             Parameters->SecondChDestPeriph,
                             &SecondChDestBREQ);
                else if (SecondChSrcSREQ == 0 && SecondChSrcBREQ == 0)
                  SingleChReq(Parameters->SecondChannel,
                              Parameters->SecondChFlowControl,
                              Parameters->SecondChDestPeriph,
                              &SecondChDestSREQ, &SecondChDestBREQ,
                              &SecondChDestLBREQ, &SecondChDestLSREQ);
                else if ((SecondChSrcSREQ == 0) || (SecondChSrcBREQ == 0))
                  DMAREQSET(Parameters->SecondChannel,
                            Parameters->SecondChSrcPeriph, &SecondChSrcSREQ,
                            &SecondChSrcBREQ, &SecondChSrcLSREQ,
                            &SecondChSrcLBREQ, Parameters->SecondChDestPeriph,
                            &SecondChDestSREQ, &SecondChDestBREQ,
                            &SecondChDestLSREQ, &SecondChDestLBREQ,
                            Parameters->SecondChFlowControl);
              }
              else if (SecondChSrcSREQ || SecondChSrcBREQ || SecondChSrcLSREQ ||
                       SecondChSrcLBREQ)
              {
                if (SecondChSrcSREQ || SecondChSrcBREQ)
                  DMAREQSET(Parameters->SecondChannel,
                            Parameters->SecondChSrcPeriph, &SecondChSrcSREQ,
                            &SecondChSrcBREQ, &SecondChSrcLSREQ,
                            &SecondChSrcLBREQ, Parameters->SecondChDestPeriph,
                            &SecondChDestSREQ, &SecondChDestBREQ,
                            &SecondChDestLSREQ, &SecondChDestLBREQ,
                            Parameters->SecondChFlowControl);
                else if (SecondChSrcLSREQ || SecondChSrcLBREQ)
                  DMALastReq(Parameters->SecondChannel,
                             Parameters->SecondChFlowControl,
                             Parameters->SecondChSrcPeriph,
                             &SecondChSrcLSREQ, &SecondChSrcLBREQ,
                             Parameters->SecondChDestPeriph,
                             &SecondChDestBREQ);
              }
            }
          } 
       }
     }
     /* Poll Channel Enable bit of first channel going low*/
     MaskValue = 0x00000001;
     Poll(ConfigRegs[Parameters->FirstChannel], 0x00000000, MaskValue);
     WaitLoop(2);

     /* Poll Channel Enable bit of first channel going low*/
     Poll(ConfigRegs[Parameters->SecondChannel], 0x00000000, MaskValue);
     WaitLoop(2);

     /* Reset Memory and Peripheral module */
     if (Parameters->FirstChDestPeriph == NA  ||
         Parameters->FirstChSrcPeriph == NA   ||
         Parameters->SecondChDestPeriph == NA ||
         Parameters->SecondChSrcPeriph == NA)
     {
       Write(DMACTrMemEn0, MEMORYRESET);
       Write(DMACTrMemEn1, MEMORYRESET);
       Write(DMACTrMemEn0, MEMORYRSTCLR);
       Write(DMACTrMemEn1, MEMORYRSTCLR);
     }
     if (Parameters->FirstChSrcPeriph != NA)
     {
       Addr  = SlaveAddrSelection(Parameters->FirstChSrcPeriph);
       Write (Addr, PERIPHRESET);
       Write (Addr, PERIPHRSTCLR);
     }
     if (Parameters->FirstChDestPeriph != NA)
     {
       Addr  = SlaveAddrSelection(Parameters->FirstChDestPeriph);
       Write (Addr, PERIPHRESET);
       Write (Addr, PERIPHRSTCLR);
     }
     if (Parameters->SecondChSrcPeriph != NA)
     {
       Addr  = SlaveAddrSelection(Parameters->SecondChSrcPeriph);
       Write (Addr, PERIPHRESET);
       Write (Addr, PERIPHRSTCLR);
     }
     if (Parameters->SecondChDestPeriph != NA)
     {
       Addr  = SlaveAddrSelection(Parameters->SecondChDestPeriph);
       Write (Addr, PERIPHRESET);
       Write (Addr, PERIPHRSTCLR);
     }
     sprintf(Message," End Of %s Test", TwoChannelTests->TestNo);
     C(Message);
     TwoChannelTests++;
  }
  /* Clear grant register */
  Write(DMACGRANTCNT0, 0x00000000);
  Write(DMACGRANTCNT1, 0x00000000);
}

/************************** End of Two Channel Test ***************************/
