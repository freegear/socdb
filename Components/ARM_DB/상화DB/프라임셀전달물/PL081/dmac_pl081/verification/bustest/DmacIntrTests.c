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
-- File Name              : DmacIntrTests.c.rca
-- File Revision          : 1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--          This file contains Interrupt test cases. 
-- --=========================================================================*/

/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** AddrGen                                    DmacCommon.c                ***/
/*** ChannelPrgm                                DmacCommon.c                ***/
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

void DMACIntTests()
{
  /*
    Overview : DMAC Interrupt Tests
    ===============================
    The function is used to test the implementation of DMACIntTC and DMACIntErr
    interrupts of DMA Controller. It also verifies interrupts can be cleared by
    writing into corresponding clear register. The interrupt test case
    parameters are defined by using structure IntTestPara. The function selects
    memory module 0 as source slave module and memory module 1 as destination
    slave module.  The function determines source, destination address and Cx
    control register control information. The function calls ChannelPrgm
    function to program channel registers. The TempPerpMaster variable
    indicates source/destination module is configured to Master2. The function
    sets respective bit of source/ destination memory module in TempPerpMaster
    variable if source/destination AHB master is Master2. The TempPerpMaster is
    used to program DMACREQCONFIG register. To test DMACIntTc interrupt, set
    IntTCEnable bit in CxControl register and IntTcMask in Cx config register.
    To test DmacIntErr interrupt, set Interrupt Error Mask bit in CxConfig
    register. The DmacIntTc and DmacIntError interrupts are cleared by writing
    in respective clear register. In case of DMACIntTc tests, the function
    waits for transacation to be over. It checks RAWIntTc of channel goes high
    in DMACRawIntTC register. It also checks DmacIntTc and DmacIntStatus of
    channel goes high if IntTCEnable and IntTcMask bits are set. The function
    verifies  RawIntTcStaus, IntTcStatus and IntStatus gets cleared after
    writing in DMACIntTCClr register. In case of DmacIntError tests, memory
    modules are configured to give Default Error response. The function checks
    RawIntError of channel goes high in DMACRawIntErr register. It also checks
    DMACRawIntErr and DMACIntTCStat of channel goes high if Interrupt error
    mask(IntErrMask) is set. It verifies DMACRawIntErr and DMACIntTCStat of
    channel gets cleared by writing one in respective channel bit in
    DMACIntErrClr register. 
  */

  /* Defining test case parameters */ 
  struct IntTestPara {
     int   SrcMaster;
     int   DestMaster;
     int   SrcWidth;
     int   DestWidth;
     char* SrcIncr;
     char* DestIncr;
     int   SrcBurst;
     int   DestBurst;
     int32 TxSize;
     int32 TC_MASK;
     int32 Error_Mask;
    };
  
  struct IntTotalTest {
     char *TestNo;
     struct IntTestPara *TestPara;
    };

  struct IntTestPara IntTestCases[] = {
      0, 0,  8,  8, "NI", "NI", 1, 1, 1,         0,          0,
      0, 0, 16, 16, "NI", "NI", 1, 1, 1, INTTCMASK,          0,
      0, 0, 32, 32,  "I",  "I", 1, 1, 1, INTTCMASK,          0,
      0, 0,  8,  8, "NI", "NI", 1, 1, 1,      ZERO,          0,
      0, 0, 16, 16, "NI", "NI", 1, 1, 1,      ZERO, INTERRMASK,
      0, 0, 32, 32,  "I",  "I", 1, 1, 1,      ZERO, INTERRMASK
     };

  /* Defining test case number and it test parameters */
  struct IntTotalTest IntTests[] = {
     "DMAC_CHNL_INTR_1", &IntTestCases[0],
     "DMAC_CHNL_INTR_2", &IntTestCases[1],
     "DMAC_CHNL_INTR_3", &IntTestCases[2],
     "DMAC_CHNL_INTR_4", &IntTestCases[3],
     "DMAC_CHNL_INTR_5", &IntTestCases[4],
     "DMAC_CHNL_INTR_6", &IntTestCases[5],
     "ENDOFTEST",        &IntTestCases[0]
    };

  int32 SrcAddrMask, DestAddrMask;
  int32 Addr, *RegAddr, CxLLIRegData, CxControlRegData, CxConfigData;
  int32 SrcAddr, DestAddr, IntTc;
  int32 SrcInfo, DestInfo, TempPerpMaster, MaskValue, Mask1, Mask2;
  int i, j;
  char Message[100];

  struct IntTotalTest *TestCases = IntTests;

  while (TestCases->TestNo != "ENDOFTEST")
  {
     struct IntTestPara *TestCasePara = TestCases->TestPara;

     sprintf(Message,"Test No : %s", TestCases->TestNo);
     C(Message);

     sprintf(Message," SW : %d\n DW : %d\n SB : %d\n DB : %d\n TxSize :  %d\n"
                     " SM : %d\n DM : %d\n SrcIncr : %s\n DestIncr : %s\n ",
             TestCasePara->SrcWidth,
             TestCasePara->DestWidth,
             TestCasePara->SrcBurst,
             TestCasePara->DestBurst,
             TestCasePara->TxSize,
             TestCasePara->SrcMaster,
             TestCasePara->DestMaster,
             TestCasePara->SrcIncr,
             TestCasePara->DestIncr
            );
     msg_info(Message);

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

     /* Clear pending interrupts if any */ 
     Write(DMACIntTCClr, 0x000000FF);
     Write(DMACIntErrClr, 0x000000FF);

     for (i = 0; i <2;  i++)
     {
        sprintf (Message,"Channel : %d ", i);
        msg_info(Message);

        msg_info("Selecting Memory Module 0 as Source slave Peripheral");
        SrcAddr   = AddrGen(0x08000100, 0x0FFFFFFF) & SrcAddrMask;

        msg_info("Selecting Memory Module 1 as Destination slave Peripheral");
        DestAddr  = AddrGen(0x10000100, 0x17FFFFFF) & DestAddrMask;

        /* Evaluate source and destination control information of source and 
           destination memory module */
        SrcInfo  = MEMORYENABLE | RANDOM;
        DestInfo = MEMORYENABLE | RANDOM;

        /* Programming Memory Modules */
        /* In case of IntTc test cases, set Default OK responses */  
        if (TestCases->TestNo == "DMAC_CHNL_INTR_1" ||
            TestCases->TestNo == "DMAC_CHNL_INTR_2" ||
            TestCases->TestNo == "DMAC_CHNL_INTR_3")
        {
          Write(DMACTrMemEn0, SrcInfo);
          Write(DMACTrMemData0, 0xC2000003);
          Write(DMACTrMemEn1, DestInfo);
          Write(DMACTrMemData1, 0xC2000003);
        }

        /* In case of IntErr test cases, set Default Error responses */  
        if (TestCases->TestNo == "DMAC_CHNL_INTR_4" ||
            TestCases->TestNo == "DMAC_CHNL_INTR_5" ||
            TestCases->TestNo == "DMAC_CHNL_INTR_6")
        {
          /* Evaluate source and destination control information of source and 
           destination memory module */
          SrcInfo  = MEMORYENABLE | RANDOM;
          DestInfo = MEMORYENABLE | RANDOM | DEFERROR;

          /* Programming Memory Modules */
          Write(DMACTrMemEn0, SrcInfo);
          Write(DMACTrMemData0, 0xC2000003);
          Write(DMACTrMemEn1, DestInfo);
          Write(DMACTrMemData1, 0xC2000003);
        }

        /* Set LLI address to zero */
        CxLLIRegData = 0x00000000;
     
        /*  Set IntTcEnable bit to test IntTc Interrupt behaviour */ 
        if (TestCases->TestNo == "DMAC_CHNL_INTR_1" ||
            TestCases->TestNo == "DMAC_CHNL_INTR_2" ||
            TestCases->TestNo == "DMAC_CHNL_INTR_3")
          IntTc = 0x80000000;
        else 
          IntTc = 0x00000000;

        /* Determine Cx Control register control information */
        CxControlRegData =
                           IntTc                            | 
                           TestCasePara->TxSize             |
                           SbValue(TestCasePara->SrcBurst)  |
                           DbValue(TestCasePara->DestBurst) |
                           SwValue(TestCasePara->SrcWidth)  |
                           DwValue(TestCasePara->DestWidth) |
                           SmValue(TestCasePara->SrcMaster) |
                           DmValue(TestCasePara->DestMaster)|
                           SiValue(TestCasePara->SrcIncr)   |
                           DiValue(TestCasePara->DestIncr);

        /*  Programming Source, Destination, LLI and Control register */
        ChannelPrgm(i, SrcAddr, DestAddr, CxLLIRegData, CxControlRegData);

        /* Configuring DMACREQCONFIG Register */
        TempPerpMaster = 0x00000000;
        if (TestCasePara->SrcMaster == MASTER2)
          TempPerpMaster = TempPerpMaster | PeriphMasterSel[0];
        if (TestCasePara->DestMaster == MASTER2)
          TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
        Write(DMACREQCONFIG, TempPerpMaster);

        /* Programming Config register */ 
        CxConfigData = CHXENABLE | TestCasePara->TC_MASK |
                       TestCasePara-> Error_Mask;
        RegAddr = ChannelRegisters(i);
        Write (*RegAddr + 0x00000010, CxConfigData);

        /* Poll Channel Enable bit  going low */
        Mask2 = 0x00000001;
        Poll(ConfigRegs[i], 0x00000000, Mask2);
        WaitLoop(4);
      
        MaskValue = 0x00000001 << i;
    
        if (TestCases->TestNo == "DMAC_CHNL_INTR_1" || 
            TestCases->TestNo == "DMAC_CHNL_INTR_2" ||  
            TestCases->TestNo == "DMAC_CHNL_INTR_3") 
        {
          /* Check RawIntTCStatus for 1 */
          Poll(DMACRawIntTC, MaskValue, MaskValue);
          WaitLoop(1);
          /* Check RawIntErrStatus for 0 */
          Poll(DMACRawIntErr, 0x00000000, MaskValue);
          WaitLoop(1);
        }
        else
        { 
          /* Check RawIntTCStatus for 0 */
          Poll(DMACRawIntTC, 0x00000000, MaskValue);
          WaitLoop(1);
          /* Check RawIntErrStatus for 1 */
          Poll(DMACRawIntErr, MaskValue, MaskValue);
          WaitLoop(1);
        }

        /* Check IntTcStatus */ 
        if (TestCasePara->TC_MASK == INTTCMASK)
          Poll(DMACIntTCStat, MaskValue, MaskValue);
        else
          Poll(DMACIntTCStat, 0x00000000, MaskValue);

        WaitLoop(1);
        /* Check DMACIntErr Status */
        if (TestCasePara->Error_Mask == INTERRMASK)
          Poll(DMACIntErrStat, MaskValue, MaskValue);
        else
          Poll(DMACIntErrStat, 0x00000000, MaskValue);
         
        WaitLoop(1);
        /* Check IntStatus */ 
        if (TestCasePara->TC_MASK == INTTCMASK ||
            TestCasePara->Error_Mask == INTERRMASK)
          Poll(DMACIntStat, MaskValue, MaskValue);
        else
          Poll(DMACIntStat, 0x00000000, MaskValue);
       
        WaitLoop(1);
        if (TestCases->TestNo != "DMAC_CHNL_INTR_3")
        { 
          Write(DMACIntTCClr, MaskValue);
          WaitLoop(2);
          /* Checking DMACRawIntTC, DMACIntTCStat and DMACIntStat for clear */
          Poll(DMACRawIntTC, 0x00000000, MaskValue);
          WaitLoop(1);
          Poll(DMACIntTCStat, 0x00000000, MaskValue);
          WaitLoop(1);
          if (TestCases->TestNo == "DMAC_CHNL_INTR_5" ||
              TestCases->TestNo == "DMAC_CHNL_INTR_6")
            Poll(DMACIntStat, MaskValue, MaskValue);
          else
            Poll(DMACIntStat, 0x00000000, MaskValue);
          WaitLoop(1);
        }
        if (TestCases->TestNo != "DMAC_CHNL_INTR_6")
        { 
          Write(DMACIntErrClr, MaskValue);
          WaitLoop(2);
          /* Checking DMACRawIntTC, DMACIntTCStat and DMACIntStat for clear */
          Poll(DMACRawIntErr, 0x00000000, MaskValue);
          WaitLoop(1);
          Poll(DMACIntErrStat, 0x00000000, MaskValue);
          WaitLoop(1);
          if (TestCases->TestNo == "DMAC_CHNL_INTR_3")
            Poll(DMACIntStat, MaskValue, MaskValue);
          else 
            Poll(DMACIntStat, 0x00000000, MaskValue);
          WaitLoop(1);
        }
        if (TestCases->TestNo == "DMAC_CHNL_INTR_4" ||
            TestCases->TestNo == "DMAC_CHNL_INTR_5" ||
            TestCases->TestNo == "DMAC_CHNL_INTR_6")
        {
          /* Resetting memory modules */  
          Write(DMACTrMemEn0, MEMORYRESET);
          Write(DMACTrMemEn1, MEMORYRESET);
          Write(DMACTrMemEn0, MEMORYRSTCLR);
          Write(DMACTrMemEn1, MEMORYRSTCLR);
        }
     }
     if (TestCases->TestNo == "DMAC_CHNL_INTR_3")
     {
       /* Check RawIntTc of all channels are set */
       Poll(DMACRawIntTC, 0x00000003, 0x000000FF);
       WaitLoop(1);
       /* Check IntTc of all channels are set */
       Poll(DMACIntTCStat, 0x00000003, 0x000000FF);
       WaitLoop(1);
       /* Check Interrupts of all channels are set */
       Poll(DMACIntStat, 0x00000003, 0x000000FF);
       WaitLoop(1);

       for (j = 0; j< 2; j++)
       {
         /*
           Write 1 into the relevant bit of the DMACIntTCClr clear register
           and check only relevant bit in DMACRawIntTc, DMACIntTcStatus and
           DMACIntStatus register gets cleared
         */
         MaskValue = 0x00000001 << j ;
         Write(DMACIntTCClr, MaskValue);
         WaitLoop(2);
         Mask1 = 0x00000003 << (j+1);
         Mask1 = Mask1 & 0x00000003;
         Poll(DMACRawIntTC, Mask1, Mask1);  
         WaitLoop(1);
         Poll(DMACIntTCStat, Mask1, Mask1);
         WaitLoop(1);
         Poll(DMACIntStat, Mask1, Mask1);
         WaitLoop(1);
       }
     }

     if (TestCases->TestNo == "DMAC_CHNL_INTR_6")
     {
       /* Check RawIntErr of all channels are set */
       Poll(DMACRawIntErr, 0x00000003, 0x000000FF);
       WaitLoop(1);
       /* Check IntErr of all channels are set */
       Poll(DMACIntErrStat, 0x00000003, 0x000000FF);
       WaitLoop(1);
       /* Check Interrupts of all are set */
       Poll(DMACIntStat, 0x00000003, 0x000000FF);
       WaitLoop(1);

       for (j = 0; j< 2; j++)
       {
         /*
           Write 1 into the relevant bit of the DMACIntErrClr clear register
           and check only relevant bit in DMACRawIntErr, DMACIntErrStatus and
           DMACIntStatus registers gets cleared
         */
         MaskValue = 0x00000001 << j;
         Write(DMACIntErrClr, MaskValue);
         WaitLoop(2);
         Mask1 = 0x00000003 << (j + 1);
         Mask1 = Mask1 & 0x00000003;
         Poll(DMACRawIntErr, Mask1, Mask1); 
         WaitLoop(1);
         Poll(DMACIntErrStat, Mask1, Mask1);
         WaitLoop(1);
         Poll(DMACIntStat, Mask1, Mask1);
        WaitLoop(1);
       }
     }
     sprintf(Message," End Of %s Test", TestCases->TestNo);
     C(Message);
     TestCases++;
  }
}
