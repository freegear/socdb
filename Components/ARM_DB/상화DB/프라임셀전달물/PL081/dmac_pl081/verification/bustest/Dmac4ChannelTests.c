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
-- File Name              : Dmac4ChannelTests.c.rca
-- File Revision          : 1.4
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0 
--
-- -----------------------------------------------------------------------------
-- Purpose :
-           This file contains four channel test cases.
-- --=========================================================================*/

/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** ChannelSetup                               DmacCommon.c                ***/
/*** SlaveRespPrgm                              DmacCommon.c                ***/
/*** ReqRegConfig4                              DmacCommon.c                ***/
/*** ConfigRegPrgm4                             DmacCommon.c                ***/
/*** SbValue                                    DmacCommon.c                ***/
/*** DbValue                                    DmacCommon.c                ***/
/*** SwValue                                    DmacCommon.c                ***/
/*** DwValue                                    DmacCommon.c                ***/
/*** SmValue                                    DmacCommon.c                ***/
/*** DmValue                                    DmacCommon.c                ***/
/*** SiValue                                    DmacCommon.c                ***/
/*** DiValue                                    DmacCommon.c                ***/
/*** Poll                                       DmacCommon.c                ***/
/*** FourChTest1                                DmacCommon.c                ***/
/*** FourChTest2                                DmacCommon.c                ***/
/*** FourChTest4                                DmacCommon.c                ***/
/*** FourChTest5                                DmacCommon.c                ***/
/*** FourChTest6                                DmacCommon.c                ***/
/*** FourChTest7                                DmacCommon.c                ***/
/*** FourChTest8                                DmacCommon.c                ***/
/******************************************************************************/

void Dmac4ChannelTests()
{
  /*
    Overview : Dmac4ChannelTests
    ============================
    The function is used to test the implementation of four-channel priority of
    DMA Controller. The four channel parameters are defined by using structure
    FourChParameters. The data generation method, sub data method, Number of
    Programmed response, channel to be enable first are defined in structure
    FourChParameters. The function calls ChannelSetup function four times to
    program the all four channel. The channel parameters are passed as function
    argument to ChannelSetup function. The slave peripherals are programmed for
    programmed responses by calling SlaveRespPrgm function. The DMACREQCONFIG
    register is programmed by calling ReqRegConfig4 function. The function
    programs DMACGRANTCNT0/1 register for request based grand toggle method. The
    all channels are enabled by enabling channel enable bit in DmacCxConfig
    register. The function calls ConfigRegPrgm4 function to enable all four
    channel. The function programs DMACGRANTCNT0/1 register for request based
    grand toggle method. The ConfigRegPrgm4 function enables channel first as
    indicated in WhichChEnableFirst( Which channel enable first) parameter and
    then it enables remaining three channels. It calls test functions depending
    on test number (i.e. if test no is DMAC_4CH_1 then it calls FourChTest1
    function and so on).  
  */

  /* Four channel test case parameters */
  struct ChannelPara Channel1[] =  {
     0, P2PDMAC, 32, 32, 8, 8, 0x00000001, MASTER1, MASTER1, 0, ZERO, ZERO,
        3, 9, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     0, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 0, ZERO, ZERO,
        1, 3, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     2, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     2, P2PDMAC, 32, 32, 8, 8, 0x00000008, MASTER1, MASTER1, 1, 0xA0010200,
        ZERO, 2, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     0, P2PDMAC, 32, 32, 8, 8, 0x00000008, MASTER2, MASTER2, 0, ZERO, ZERO,
        2, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     1, P2PSP, 32, 32, 4, 8, 0x00000000, MASTER1, MASTER1, 0, ZERO, ZERO,
        1, 3, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     4, M2MDMAC, 32, 32, 8, 8, 0x00000008, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     0, P2PSP, 32, 32, 8, 8, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        7, 13, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR  
       }; 
      

  struct ChannelPara Channel2[] =  {
     1, M2PDP, 32, 32, 4, 4, 0x00000001, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, 1, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     3, P2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 0, ZERO, ZERO,
        2, 4, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     3, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     3, M2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, 10, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     2, M2MDMAC, 32, 32, 4, 4, 0x00000008, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     3, P2PDP, 32, 32, 8, 4, 0x00000000, MASTER1, MASTER1, 0, ZERO, ZERO,
        2, 4, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     5, M2MDMAC, 32, 32, 8, 8, 0x00000010, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     2, M2PDMAC, 32, 32, 8, 8, 0x00000008, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, 11, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR  
       }; 

  struct ChannelPara Channel3[] =  {
     2, P2MSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 0, ZERO, ZERO,
        7, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     4, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 0, ZERO, ZERO,
        6, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     6, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     4, P2MSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 0, ZERO, ZERO,
        6, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     4, P2PDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        6, 10, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     5, P2PSP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 0, ZERO, ZERO,
        6, 8, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     6, M2MDMAC, 32, 32, 4, 4, 0x00000008, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     4, P2MSP, 32, 32, 4, 4, 0x00000000, MASTER2, MASTER2, 0, ZERO, ZERO,
        5, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR  
       }; 

  struct ChannelPara Channel4[] =  {
     3, M2MDMAC, 32, 32, 4, 4, 0x00000008, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     7, P2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 0, ZERO, ZERO,
        11, 13, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     7, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     5, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 1, 0xA0010210,
        ZERO, NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO,
        ADDRINCR, ADDRINCR,  
     6, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO,
        ADDRINCR, ADDRINCR,  
     7, P2PDP, 32, 32, 4, 4, 0x00000000, MASTER1, MASTER1, 0, ZERO, ZERO,
        11, 13, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     7, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER1, MASTER1, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR,  
     7, M2MDMAC, 32, 32, 4, 4, 0x00000004, MASTER2, MASTER2, 0, ZERO, ZERO,
        NA, NA, DEFOKAY, DEFOKAY, ZERO, ZERO, pbc, NONLOCK, ZERO, ADDRINCR,
        ADDRINCR  
       }; 

  struct FourChParameters FourChTests[] = {
     &Channel1[0], &Channel2[0], &Channel3[0], &Channel4[0], 3, ADDRBASED,
        INCREMENT, ZERO, ZERO, 

     &Channel1[1], &Channel2[1], &Channel3[1], &Channel4[1], 7, ADDRBASED,
        INCREMENT, ZERO, ZERO, 

     &Channel1[2], &Channel2[2], &Channel3[2], &Channel4[2], 3, ADDRBASED,
        INCREMENT, ZERO, ZERO, 

     &Channel1[3], &Channel2[3], &Channel3[3], &Channel4[3], 5, ADDRBASED,
        INCREMENT, ZERO, ZERO, 

     &Channel1[4], &Channel2[4], &Channel3[4], &Channel4[4], 6, ADDRBASED,
        DECREMENT, 1, 2, 

     &Channel1[5], &Channel2[5], &Channel3[5], &Channel4[5], 7, ADDRBASED,
        DECREMENT, 1, 1, 

     &Channel1[6], &Channel2[6], &Channel3[6], &Channel4[6], 7, ADDRBASED,
        ONESCOMP, ZERO, ZERO, 

     &Channel1[7], &Channel2[7], &Channel3[7], &Channel4[7], 7, ADDRBASED,
        TWOSCOMP, ZERO, ZERO 
    };

  /* Defining test number and its channel parameters */
  struct FourChTotalCases FourChTest[] = {
     "DMAC_4CH_1", &FourChTests[0], 
     "DMAC_4CH_2", &FourChTests[1], 
     "DMAC_4CH_3", &FourChTests[2],
     "DMAC_4CH_4", &FourChTests[3], 
     "DMAC_4CH_5", &FourChTests[4], 
     "DMAC_4CH_6", &FourChTests[5],
     "DMAC_4CH_7", &FourChTests[6], 
     "DMAC_4CH_8", &FourChTests[7],
     "ENDOFTEST",  &FourChTests[8] 
    };


  struct FourChTotalCases *TestCases = FourChTest;

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
     struct ChannelPara *Channel1Info = TestCases->FourChData->FirstChannel;
     struct ChannelPara *Channel2Info = TestCases->FourChData->SecondChannel;
     struct ChannelPara *Channel3Info = TestCases->FourChData->ThirdChannel;
     struct ChannelPara *Channel4Info = TestCases->FourChData->FourthChannel;

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
   
     /* Clear pending interrupts if any */
     Write(DMACIntTCClr, 0x000000FF);
     Write(DMACIntErrClr, 0x000000FF);

     /* Programming Channel 1 */
     ChannelSetup(Channel1Info, TestCases->FourChData->DataGenMethod,
                                TestCases->FourChData->DataMethod);

     /* Programming Channel 2 */
     ChannelSetup(Channel2Info, TestCases->FourChData->DataGenMethod,
                                TestCases->FourChData->DataMethod);

     /* Programming Channel 3 */
     ChannelSetup(Channel3Info, TestCases->FourChData->DataGenMethod,
                                TestCases->FourChData->DataMethod);

     /* Programming Channel 4 */
     ChannelSetup(Channel4Info, TestCases->FourChData->DataGenMethod,
                                TestCases->FourChData->DataMethod);

     /* Program slave peripheral for programmed responses */
     if (TestCases->FourChData->IsAnyPrgmResp)
       SlaveRespPrgm(FourChPrgmRespPar, TestCases->TestNo, 
                     TestCases->FourChData->NoOfPrgmResp);

     /* Programming DMACREQREG register */ 
     ReqRegConfig4(TestCases);

     /* Programming GrantCount Register */ 
      if (Channel1Info->SrcMaster  == MASTER2 ||
          Channel1Info->DestMaster == MASTER2 ||
          Channel2Info->SrcMaster  == MASTER2 ||
          Channel2Info->DestMaster == MASTER2 ||
          Channel3Info->SrcMaster  == MASTER2 ||
          Channel3Info->DestMaster == MASTER2 ||
          Channel4Info->SrcMaster  == MASTER2 ||
          Channel4Info->DestMaster == MASTER2)
         Write(DMACGRANTCNT1, GrantReqBased | Count12);

      if (Channel1Info->SrcMaster  == MASTER1 ||
          Channel1Info->DestMaster == MASTER1 ||
          Channel2Info->SrcMaster  == MASTER1 ||
          Channel2Info->DestMaster == MASTER1 ||
          Channel3Info->SrcMaster  == MASTER1 ||
          Channel3Info->DestMaster == MASTER1 ||
          Channel4Info->SrcMaster  == MASTER1 ||
          Channel4Info->DestMaster == MASTER1)
         Write(DMACGRANTCNT0, GrantReqBased | Count12); 
    
     /* Programming ChXConfigData Register */ 
     ConfigRegPrgm4(TestCases);  

     /* Call respective function for that tests */ 
     if (TestCases->TestNo == "DMAC_4CH_1") 
       FourChTest1(TestCases);
     else if (TestCases->TestNo == "DMAC_4CH_2") 
       FourChTest2(TestCases);
     else if (TestCases->TestNo == "DMAC_4CH_3") 
     {
       WaitLoop(40);
       MaskValue  = 0x00000001;
       /* Polling Channel Enable bit of Channel 7 going low*/
       Poll(ConfigRegs[Channel4Info->Channel], 0x00000000, MaskValue);
       WaitLoop(1);
     }
     else if (TestCases->TestNo == "DMAC_4CH_4") 
       FourChTest4(TestCases);
     else if (TestCases->TestNo == "DMAC_4CH_5") 
       FourChTest5(TestCases);
     else if (TestCases->TestNo == "DMAC_4CH_6") 
       FourChTest6(TestCases);
     else if (TestCases->TestNo == "DMAC_4CH_7") 
       FourChTest7(TestCases);
     else if (TestCases->TestNo == "DMAC_4CH_8") 
       FourChTest8(TestCases);

     sprintf(Message," End Of %s Test", TestCases->TestNo);
     C(Message); 

     TestCases++;
  }
  /* Clear grant registers */
  Write(DMACGRANTCNT0, 0x00000000);
  Write(DMACGRANTCNT1, 0x00000000);
}

/************************** End of Four Channel Tests *************************/
