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
-- File Name              : Dmac8ChannelTests.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This file contains Eight channel test cases.
-- --=========================================================================*/

/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** ChannelSetup                               DmacCommon.c                ***/
/*** SlaveRespPrgm                              DmacCommon.c                ***/
/*** ReqRegConfig8                              DmacCommon.c                ***/
/*** ConfigRegPrgm8                             DmacCommon.c                ***/
/*** SbValue                                    DmacCommon.c                ***/
/*** DbValue                                    DmacCommon.c                ***/
/*** SwValue                                    DmacCommon.c                ***/
/*** DwValue                                    DmacCommon.c                ***/
/*** SmValue                                    DmacCommon.c                ***/
/*** DmValue                                    DmacCommon.c                ***/
/*** SiValue                                    DmacCommon.c                ***/
/*** DiValue                                    DmacCommon.c                ***/
/*** Poll                                       DmacCommon.c                ***/
/*** EightChTest1                               DmacCommon.c                ***/
/*** EightChTest4                               DmacCommon.c                ***/
/*** EightChTest5                               DmacCommon.c                ***/
/******************************************************************************/

void Dmac8ChannelTests()
{
  /*
    Overview : Dmac8ChannelTests
    ============================
    The function is used to test the implementation of eight-channel priority of
    DMA Controller. The eight channel parameters are defined by using structure
    EightChPara. The data generation method, sub data method, Number of
    Programmed response, channel to be enable first are defined in structure
    EightChPara. The function calls ChannelSetup function eight times to
    program the all eight channels. The channel parameters are passed as
    function argument to ChannelSetup function. The slave peripherals are 
    programmed for programmed responses by calling SlaveRespPrgm function. The
    function programs DMACGRANTCNT0/1 register for request based grand toggle
    method. The DMACREQCONFIG register is programmed by calling ReqRegConfig8
    function. The all channels are enabled by enabling channel enable bit in
    DmacCxConfig register. The function calls ConfigRegPrgm8 function to enable
    all eight channels. The ConfigRegPrgm8 function enables channel first as
    indicated in WhichChEnableFirst(Which channel enable first) parameter and
    then it enables remaining channels. It calls test functions depending on
    test number(i.e. if test no is DMAC_8CH_1 then it calls FourChTest1
    function and so on).
  */

  /* Eight channel test case parameters */
  struct ChannelPara Channel1[] =  {
     0, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        1, 2, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     0, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     0, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        11,12, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     0, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        1, 2, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     0, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        1, 2, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR
    }; 

  struct ChannelPara Channel2[] =  {
     1, M2PDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, 3, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     1, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     1, M2PDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, 13, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     1, M2PDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, 3, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     1, M2PDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 1, 0xA0020200,
        MASTER2, NA, 3, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO,
        ADDRINCR, ADDRINCR
    }; 

  struct ChannelPara Channel3[] =  {
     2, P2MSP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        4, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     2, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     2, P2MSP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        14, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     2, P2MSP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        4, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     2, P2MSP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 1, 0xA0020210,
        MASTER2, 4, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO,
        ADDRINCR, ADDRINCR
    }; 

  struct ChannelPara Channel4[] =  {
     3, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     3, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     3, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     3, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     3, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR
    }; 

  struct ChannelPara Channel5[] =  {
     4, P2PDP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        5, 6, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     4, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     4, P2PDP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        15, 6, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     4, P2PDP, 32, 32, 16, 16, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        11, 9, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     4, P2PDP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        5, 6, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR
     }; 

  struct ChannelPara Channel6[] =  {
     5, M2PDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, 7, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     5, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     5, M2PDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, 7, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     5, M2PDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, 7, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     5, M2PDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, 7, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR
     }; 

  struct ChannelPara Channel7[] =  {
     6, P2MSP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        8, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     6, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     6, P2MSP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        8, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     6, P2MSP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        10, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     6, P2MSP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        8, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR
     }; 

  struct ChannelPara Channel8[] =  {
     7, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     7, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     7, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
     7, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,
    7, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 1, 0xA0020220,
        ZERO, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO,
        ADDRINCR, ADDRINCR
    }; 

  struct EightChPara EightChTests[] = {
     &Channel1[0], &Channel2[0], &Channel3[0], &Channel4[0], &Channel5[0],
       &Channel6[0], &Channel7[0],&Channel8[0], 3, ADDRBASED, INCREMENT, ZERO,
       ZERO,

     &Channel1[1], &Channel2[1], &Channel3[1], &Channel4[1], &Channel5[1],
       &Channel6[1],&Channel7[1],&Channel8[1], 4, ADDRBASED, INCREMENT, ZERO,
       ZERO,

     &Channel1[2], &Channel2[2], &Channel3[2], &Channel4[2], &Channel5[2],
       &Channel6[2],&Channel7[2],&Channel8[2], 3, ADDRBASED, INCREMENT, 1,
       2,

     &Channel1[3], &Channel2[3], &Channel3[3], &Channel4[3], &Channel5[3],
       &Channel6[3],&Channel7[3],&Channel8[3], 3, ADDRBASED, INCREMENT, 1,
       1,

     &Channel1[4], &Channel2[4], &Channel3[4], &Channel4[4], &Channel5[4],
       &Channel6[4],&Channel7[4],&Channel8[4], 3, ADDRBASED, INCREMENT, ZERO,
       ZERO

    };

  /* Defining test number and its channel parameters */
  struct EightChTotalCases EightChTest[] = {
     "DMAC_8CH_1", &EightChTests[0],
     "DMAC_8CH_2", &EightChTests[1],
     "DMAC_8CH_3", &EightChTests[2],
     "DMAC_8CH_4", &EightChTests[3],
     "DMAC_8CH_5", &EightChTests[4],
     "ENDOFTEST",  &EightChTests[0]
    };

  struct EightChTotalCases *TestCases = EightChTest;

  int32 Addr;
  int32 *RegAddr;
  int   SrcReqCount = 0x00000000;
  int   DestReqCount = 0x00000000;
  int32 MaskValue;
  int32 SrcPeriphValue, DestPeriphValue;
  int32 TempPerpMaster;
  char  Message[100];

  while (TestCases->TestNo != "ENDOFTEST")
  {
     /* Extract channel information */
     struct ChannelPara *Channel1Info = TestCases->EightChData->FirstChannel;
     struct ChannelPara *Channel2Info = TestCases->EightChData->SecondChannel;
     struct ChannelPara *Channel3Info = TestCases->EightChData->ThirdChannel;
     struct ChannelPara *Channel4Info = TestCases->EightChData->FourthChannel;
     struct ChannelPara *Channel5Info = TestCases->EightChData->FifthChannel;
     struct ChannelPara *Channel6Info = TestCases->EightChData->SixthChannel;
     struct ChannelPara *Channel7Info = TestCases->EightChData->SeventhChannel;
     struct ChannelPara *Channel8Info = TestCases->EightChData->EighthChannel;

     sprintf(Message,"Test No : %s", TestCases->TestNo);
     C(Message);

     sprintf(Message,"FirstChannel : %d", Channel1Info->Channel);
     msg_info(Message);

     sprintf(Message,"FlowControl : %x\nSW : %d\nDW : %d\nSB : %d\nDB : %d "
             "\nTxSize : %d\nSM : %d\nDM : %d",
             Channel1Info->FlowControl,
             Channel1Info->SrcWidth,
             Channel1Info->DestWidth,
             Channel1Info->SrcBurst,
             Channel1Info->DestBurst,
             Channel1Info->TxSize,
             Channel1Info->SrcMaster,
             Channel1Info->DestMaster);
     msg_info(Message);

     sprintf(Message,"SecondChannel : %d", Channel2Info->Channel);
     msg_info(Message);

     sprintf(Message,"FlowControl : %x\nSW : %d\nDW : %d\nSB : %d\nDB : %d "
             "\nTxSize : %d\nSM : %d\nDM : %d",
             Channel2Info->FlowControl,
             Channel2Info->SrcWidth,
             Channel2Info->DestWidth,
             Channel2Info->SrcBurst,
             Channel2Info->DestBurst,
             Channel2Info->TxSize,
             Channel2Info->SrcMaster,
             Channel2Info->DestMaster);
     msg_info(Message);

     sprintf(Message,"ThirdChannel : %d", Channel3Info->Channel);
     msg_info(Message);

     sprintf(Message,"FlowControl : %x\nSW : %d\nDW : %d\nSB : %d\nDB : %d "
             "\nTxSize : %d\nSM : %d\nDM : %d",
             Channel3Info->FlowControl,
             Channel3Info->SrcWidth,
             Channel3Info->DestWidth,
             Channel3Info->SrcBurst,
             Channel3Info->DestBurst,
             Channel3Info->TxSize,
             Channel3Info->SrcMaster,
             Channel3Info->DestMaster);
     msg_info(Message);

     sprintf(Message,"FourthChannel : %d", Channel4Info->Channel);
     msg_info(Message);

     sprintf(Message,"FlowControl : %x\nSW : %d\nDW : %d\nSB : %d\nDB : %d "
             "\nTxSize : %d\nSM : %d\nDM : %d",
             Channel4Info->FlowControl,
             Channel4Info->SrcWidth,
             Channel4Info->DestWidth,
             Channel4Info->SrcBurst,
             Channel4Info->DestBurst,
             Channel4Info->TxSize,
             Channel4Info->SrcMaster,
             Channel4Info->DestMaster);
     msg_info(Message);

     sprintf(Message,"FifthChannel : %d", Channel5Info->Channel);
     msg_info(Message);

     sprintf(Message,"FlowControl : %x\nSW : %d\nDW : %d\nSB : %d\nDB : %d "
             "\nTxSize : %d\nSM : %d\nDM : %d",
             Channel5Info->FlowControl,
             Channel5Info->SrcWidth,
             Channel5Info->DestWidth,
             Channel5Info->SrcBurst,
             Channel5Info->DestBurst,
             Channel5Info->TxSize,
             Channel5Info->SrcMaster,
             Channel5Info->DestMaster);
     msg_info(Message);

     sprintf(Message,"SixthChannel : %d", Channel6Info->Channel);
     msg_info(Message);

     sprintf(Message,"FlowControl : %x\nSW : %d\nDW : %d\nSB : %d\nDB : %d "
             "\nTxSize : %d\nSM : %d\nDM : %d",
             Channel6Info->FlowControl,
             Channel6Info->SrcWidth,
             Channel6Info->DestWidth,
             Channel6Info->SrcBurst,
             Channel6Info->DestBurst,
             Channel6Info->TxSize,
             Channel6Info->SrcMaster,
             Channel6Info->DestMaster);
     msg_info(Message);

     sprintf(Message,"SeventhChannel : %d", Channel7Info->Channel);
     msg_info(Message);

     sprintf(Message,"FlowControl : %x\nSW : %d\nDW : %d\nSB : %d\nDB : %d "
             "\nTxSize : %d\nSM : %d\nDM : %d",
             Channel7Info->FlowControl,
             Channel7Info->SrcWidth,
             Channel7Info->DestWidth,
             Channel7Info->SrcBurst,
             Channel7Info->DestBurst,
             Channel7Info->TxSize,
             Channel7Info->SrcMaster,
             Channel7Info->DestMaster);
     msg_info(Message);

     sprintf(Message,"EighthChannel : %d", Channel8Info->Channel);
     msg_info(Message);

     sprintf(Message,"FlowControl : %x\nSW : %d\nDW : %d\nSB : %d\nDB : %d "
             "\nTxSize : %d\nSM : %d\nDM : %d",
             Channel8Info->FlowControl,
             Channel8Info->SrcWidth,
             Channel8Info->DestWidth,
             Channel8Info->SrcBurst,
             Channel8Info->DestBurst,
             Channel8Info->TxSize,
             Channel8Info->SrcMaster,
             Channel8Info->DestMaster);
     msg_info(Message);

     /* Clear pending interrupts if any */
     Write(DMACIntTCClr, 0x000000FF);
     Write(DMACIntErrClr, 0x000000FF);

     /* Programming Channel 1 */
     ChannelSetup(Channel1Info, TestCases->EightChData->DataGenMethod,
                                TestCases->EightChData->DataMethod);

     /* Programming Channel 2 */
     ChannelSetup(Channel2Info, TestCases->EightChData->DataGenMethod,
                                TestCases->EightChData->DataMethod);

     /* Programming Channel 3 */
     ChannelSetup(Channel3Info, TestCases->EightChData->DataGenMethod,
                                TestCases->EightChData->DataMethod);

     /* Programming Channel 4 */
     ChannelSetup(Channel4Info, TestCases->EightChData->DataGenMethod,
                                TestCases->EightChData->DataMethod);

     /* Programming Channel 5 */
     ChannelSetup(Channel5Info, TestCases->EightChData->DataGenMethod,
                                TestCases->EightChData->DataMethod);

     /* Programming Channel 6 */
     ChannelSetup(Channel6Info, TestCases->EightChData->DataGenMethod,
                                TestCases->EightChData->DataMethod);

     /* Programming Channel 7 */
     ChannelSetup(Channel7Info, TestCases->EightChData->DataGenMethod,
                                TestCases->EightChData->DataMethod);

     /* Programming Channel 8 */
     ChannelSetup(Channel8Info, TestCases->EightChData->DataGenMethod,
                                TestCases->EightChData->DataMethod);

     /* Program slave peripheral for programmed responses */
     if (TestCases->EightChData->IsAnyPrgmResp)
       SlaveRespPrgm(EightChPrgmRespPar, TestCases->TestNo,
                     TestCases->EightChData->NoOfPrgmResp);


      /* Programming GrantCount Register */
      if (Channel1Info->SrcMaster  == MASTER2 ||
          Channel1Info->DestMaster == MASTER2 ||
          Channel2Info->SrcMaster  == MASTER2 ||
          Channel2Info->DestMaster == MASTER2 ||
          Channel3Info->SrcMaster  == MASTER2 ||
          Channel3Info->DestMaster == MASTER2 ||
          Channel4Info->SrcMaster  == MASTER2 ||
          Channel4Info->DestMaster == MASTER2 ||
          Channel5Info->SrcMaster  == MASTER2 ||
          Channel5Info->DestMaster == MASTER2 ||
          Channel6Info->SrcMaster  == MASTER2 ||
          Channel6Info->DestMaster == MASTER2 ||
          Channel7Info->SrcMaster  == MASTER2 ||
          Channel7Info->DestMaster == MASTER2 ||
          Channel8Info->SrcMaster  == MASTER2 ||
          Channel8Info->DestMaster == MASTER2)
         Write(DMACGRANTCNT1, GrantReqBased | Count12);

      if (Channel1Info->SrcMaster  == MASTER1 ||
          Channel1Info->DestMaster == MASTER1 ||
          Channel2Info->SrcMaster  == MASTER1 ||
          Channel2Info->DestMaster == MASTER1 ||
          Channel3Info->SrcMaster  == MASTER1 ||
          Channel3Info->DestMaster == MASTER1 ||
          Channel4Info->SrcMaster  == MASTER1 ||
          Channel4Info->DestMaster == MASTER1 || 
          Channel5Info->SrcMaster  == MASTER1 ||
          Channel5Info->DestMaster == MASTER1 ||
          Channel6Info->SrcMaster  == MASTER1 ||
          Channel6Info->DestMaster == MASTER1 ||
          Channel7Info->SrcMaster  == MASTER1 ||
          Channel7Info->DestMaster == MASTER1 ||
          Channel8Info->SrcMaster  == MASTER1 ||
          Channel8Info->DestMaster == MASTER1)
        Write(DMACGRANTCNT0, GrantReqBased | Count12);

     /* Programming DMACREQREG register */
     ReqRegConfig8(TestCases);

     /* Programming ChXConfigData Register */
     ConfigRegPrgm8(TestCases);

     /* Call respective function for that tests */
     if (TestCases->TestNo == "DMAC_8CH_1")
       EightChTest1(TestCases);
     else if (TestCases->TestNo == "DMAC_8CH_2")
     {
       WaitLoop(80);
       MaskValue  = 0x00000001;
       /* Polling Channel Enable bit of Channel 7 */
       Poll(ConfigRegs[Channel8Info->Channel], 0x00000000, MaskValue);
       WaitLoop(1);

     }
     else if (TestCases->TestNo == "DMAC_8CH_3")
       EightChTest1(TestCases);
     else if (TestCases->TestNo == "DMAC_8CH_4")
       EightChTest4(TestCases);
     else if (TestCases->TestNo == "DMAC_8CH_5")
       EightChTest5(TestCases);

     sprintf(Message," End Of %s Test", TestCases->TestNo);
     C(Message);

     TestCases++;
  }
  /* Clear grant registers */
  Write(DMACGRANTCNT0, 0x00000000);
  Write(DMACGRANTCNT1, 0x00000000);
}

/************************** End of Eight Channel Tests ************************/
