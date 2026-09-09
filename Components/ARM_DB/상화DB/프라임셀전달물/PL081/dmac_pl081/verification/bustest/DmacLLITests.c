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
-- File Name              :  DmacLLITests.c.rca
-- File Revision          :  1.5
--
-- Release Information    : PrimeCell(TM)-PL081-REL1v0
--
-- -----------------------------------------------------------------------------
-- Purpose :
--           This file contains LLI test cases.
-- --=========================================================================*/

/******************************************************************************/
/************************* List of Functions Called ***************************/
/******************************************************************************/
/*** Function name                              Located in                  ***/
/*** ---------------------------------------------------------------------- ***/
/*** AddrGen                                    DmacCommon.c                ***/
/*** ChannelPrgm                                DmacCommon.c                ***/
/*** SlaveRespPrgm                              DmacCommon.c                ***/
/*** LLIPrgm                                    DmacCommon.c                ***/
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

void DmacLLITests()
{
  /* Overview: LLI Tests
     =========================
     This function is used to test the implementation of LLI block. The
     structure LLITestPara defines test parameters. The memory module is
     selected depending on Source/Destination AHB master and LLI master. The
     function programs DMACREQCONFIG register. The function evaluates source
     address, destination address, CxLLIReg and CxControlreg data to program
     the channel. The channel is programmed by calling ChannelPrgm function. The
     Source address, Destination address, CxLLIReg and CxControlReg data are 
     passed as arguments to ChannelPrgm function. After programming the channel,
     function programs LLI slave block. To determine LLI block parameters, it
     calls AddrGen function to determine source and destination address. The 
     function programs memory module for programmed responses. It polls channel
     enable bit for going low. The above procedure is repeated for remaining
     LLI test cases.
  */

  char Message[100];
  int IntrTcEnable = 1;
  int IntrTcMask   = 0;
  int ErrorMask    = 0;

  /* Defining test Parameters */
  struct LLITestPara {
     int   SrcMaster;
     int   DestMaster;
     int32 LLIMaster;
     int   SrcWidth;
     int   DestWidth;
     char* SrcIncr;
     char* DestIncr;
     int   SrcBurst;
     int   DestBurst;
     int32 TxSize;
     int   NoOfLLI;
     int32 SrcAHBResp;
     int32 DestAHBResp;
     int32 NoOfDefResp;
     int32 SrcWaitCyc;
     int32 DestWaitCyc;
     int32 IsAnyPrgmResp;
     int32 NoOfPrgmResp;
    };

  struct LLICases {
     char  *TestNo;
     struct LLITestPara *LLICasePara;
    };

  struct LLITestPara Tests[] = {
     0, 0, 0, 8, 8, "NI", "NI", 1, 1, 4, 1, DEFOKAY, DEFOKAY, ZERO, ZERO, ZERO,
        ZERO, ZERO,  
     0, 1, 1, 16, 16, "NI", "I", 1, 4, 4, 1, DEFOKAY, DEFOKAY, ZERO, ZERO, ZERO,
        ZERO, ZERO,  
     1, 0, 1, 32, 32, "I", "NI", 1, 8, 4, 2, DEFRETRY, DEFOKAY, DEFRSCOUNT3,
        ZERO, ZERO, ZERO, ZERO,
     1, 1, 0, 8, 16, "I", "I", 1, 16, 6, 4, DEFRETRY, DEFRETRY, DEFRSCOUNT1,
        ZERO, ZERO, ZERO, ZERO,
     0, 0, 0, 16, 32, "I", "NI", 1, 32, 8, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     1, 0, 0, 32, 16, "I", "I", 1, 64, 8, 1, DEFOKAY, DEFOKAY, ZERO, ZERO, ZERO,
        ZERO, ZERO,
     0, 1, 1, 16, 8, "NI", "NI", 1, 128, 16, 2, DEFOKAY, DEFSPLIT, DEFRSCOUNT2,
        ZERO, ZERO, ZERO, ZERO,
     1, 1, 1, 8, 32, "NI", "I", 1, 256, 16, 3, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     0, 1, 1, 32, 8, "I", "NI", 4, 1, 8, 3, DEFOKAY, DEFOKAY, ZERO, ZERO, ZERO,
        1, 1,
     0, 0, 0, 32, 32, "I", "I", 4, 4, 8, 2, DEFOKAY, DEFOKAY, ZERO, ZERO, ZERO,
        ZERO, ZERO,
     1, 1, 1, 16, 32, "NI", "NI", 4, 8, 8, 2, DEFOKAY, DEFOKAY, ZERO, DEFWAIT9,
        ZERO, ZERO, ZERO,
     1, 0, 1, 8, 8, "NI", "I", 4, 16, 8, 3, DEFOKAY, DEFOKAY, ZERO, ZERO,
        DEFWAIT5, ZERO, ZERO,
     0, 1, 0, 16, 8, "NI", "NI", 4, 32, 32, 1, DEFOKAY, DEFOKAY, ZERO, DEFWAIT9,
        DEFWAIT8, ZERO, ZERO,
     0, 0, 1, 32, 8, "NI", "I", 4, 64, 16, 2, DEFSPLIT, DEFSPLIT, DEFRSCOUNT3,
        DEFWAIT9, DEFWAIT9, ZERO, ZERO,
     0, 0, 1, 16, 16, "I", "NI", 4, 128, 8, 2, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     1, 1, 0, 8, 32, "I", "I", 4, 256, 4, 2, DEFOKAY, DEFOKAY, ZERO, ZERO, ZERO,
        ZERO, ZERO,
     0, 1, 1, 32, 8, "I", "NI", 8, 1, 8, 3, DEFOKAY, DEFOKAY, ZERO, ZERO, ZERO,
        ZERO, ZERO,
     0, 0, 1, 32, 32, "I", "I", 8, 4, 8, 2, DEFOKAY, DEFOKAY, ZERO, ZERO, ZERO,
        1, 1,
     1, 1, 1, 16, 32, "NI", "NI", 8, 8, 8, 2, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     1, 0, 0, 8, 8, "NI", "I", 8, 16, 16, 1, DEFOKAY, DEFOKAY, ZERO, DEFWAIT4,
        ZERO, ZERO, ZERO,
     0, 1, 0, 16, 8, "NI", "NI", 8, 32, 32, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     0, 0, 1, 32, 8, "NI", "I", 8, 64, 16, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     0, 0, 0, 16, 16, "I", "NI", 8, 128, 16, 2, DEFSPLIT, DEFOKAY, DEFRSCOUNT0,
        ZERO, DEFWAIT9, ZERO, ZERO,
     1, 1, 1, 8, 32, "I", "I", 8, 256, 8, 4, DEFSPLIT, DEFOKAY, DEFRSCOUNT3,
        DEFWAIT5, DEFWAIT9, ZERO, ZERO,
     0, 0, 1, 8, 8, "NI", "NI", 16, 1, 8, 4, DEFOKAY, DEFOKAY, ZERO, DEFWAIT5,
        ZERO, ZERO, ZERO,
     0, 1, 0, 16, 16, "NI", "I", 16, 4, 8, 2, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     1, 0, 1, 32, 32, "I", "NI", 16, 8, 8, 3, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, 1, 1,
     1, 1, 0, 8, 16, "I", "I", 16, 16, 8, 2, DEFOKAY, DEFOKAY, ZERO, ZERO, ZERO,
        ZERO, ZERO,
     0, 0, 1, 16, 32, "I", "NI", 16, 32, 8, 2, DEFRETRY, DEFRETRY, DEFRSCOUNT0,
        DEFWAIT0, DEFWAIT0, ZERO, ZERO,
     1, 0, 0, 32, 16, "I", "I", 16, 64, 8, 1, DEFOKAY, DEFSPLIT, DEFRSCOUNT0,
        DEFWAIT0, DEFWAIT0, ZERO, ZERO,
     0, 1, 1, 16, 8, "NI", "NI", 16, 128, 8, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     1, 1, 0, 8, 32, "NI", "I", 16, 256, 16, 2, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     0, 1, 1, 32, 8, "I", "NI", 32, 1, 16, 2, DEFSPLIT, DEFOKAY, DEFRSCOUNT3,
        ZERO, ZERO, ZERO, ZERO,
     0, 0, 1, 32, 32, "I", "I", 32, 4, 8, 2, DEFOKAY, DEFOKAY, ZERO, ZERO, ZERO,
        ZERO, ZERO,
     1, 1, 1, 16, 32, "NI", "NI", 32, 8, 8, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        DEFWAIT5, ZERO, ZERO,
     1, 0, 0, 8, 8, "NI", "I", 32, 16, 8, 2, DEFOKAY, DEFOKAY, ZERO, ZERO,
        DEFWAIT5, ZERO, ZERO,
     0, 1, 0, 16, 8, "NI", "NI", 32, 32, 8, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, 1, 1,
     0, 0, 1, 32, 8, "NI", "I", 32, 64, 8, 2, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     0, 0, 0, 16, 16, "I", "NI", 32, 128, 8, 1, DEFRETRY, DEFOKAY, DEFRSCOUNT0,
        DEFWAIT15, ZERO, ZERO, ZERO,
     1, 1, 1, 8, 32, "I", "I", 32, 256, 4, 2, DEFOKAY, DEFOKAY, ZERO, DEFWAIT15,
        DEFWAIT12, ZERO, ZERO,
     0, 0, 1, 8, 8, "NI", "NI", 64, 1, 4, 2, DEFOKAY, DEFOKAY, ZERO, DEFWAIT1,
      ZERO, ZERO, ZERO,
     0, 1, 0, 16, 16, "NI", "I", 64, 4, 8, 1, DEFSPLIT, DEFOKAY, DEFRSCOUNT2,
        DEFWAIT1, ZERO, ZERO, ZERO,
     1, 0, 1, 32, 32, "I", "NI", 64, 8, 8, 2, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     1, 1, 0, 8, 16, "I", "I", 64, 16, 16, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     0, 0, 1, 16, 32, "I", "NI", 64, 32, 8, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, 1, 2,
     1, 0, 0, 32, 16, "I", "I", 64, 64, 8, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     0, 1, 1, 16, 8, "NI", "NI", 64, 128, 8, 2, DEFOKAY, DEFOKAY, ZERO,
        DEFWAIT4, DEFWAIT9, ZERO, ZERO,
     1, 1, 0, 8, 32, "NI", "I", 64, 256, 8, 1, DEFSPLIT, DEFSPLIT, DEFRSCOUNT0,
        DEFWAIT2, DEFWAIT2, ZERO, ZERO,
     0, 0, 0, 8, 8, "NI", "NI", 128, 1, 8, 2, DEFOKAY, DEFOKAY, ZERO, ZERO,
        DEFWAIT5, ZERO, ZERO,
     0, 1, 1, 16, 16, "NI", "I", 128, 4, 12, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        DEFWAIT5, ZERO, ZERO,
     1, 0, 1, 32, 32, "I", "NI", 128, 8, 8, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        DEFWAIT9, ZERO, ZERO,
     1, 1, 0, 8, 16, "I", "I", 128, 16, 8, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        DEFWAIT1, ZERO, ZERO,
     0, 0, 0, 16, 32, "I", "NI", 128, 32, 8, 2, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     1, 0, 0, 32, 16, "I", "I", 128, 64, 8, 2, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, 1, 1,
     0, 1, 1, 16, 8, "NI", "NI", 128, 128, 4, 2, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     1, 1, 1, 8, 32, "NI", "I", 128, 256, 16, 4, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     0, 1, 1, 32, 8, "I", "NI", 256, 1, 16, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     0, 0, 0, 32, 32, "I", "I", 256, 4, 16, 1, DEFOKAY, DEFOKAY, ZERO,
        DEFWAIT12, DEFWAIT8, ZERO, ZERO,
     1, 1, 1, 16, 32, "NI", "NI", 256, 8, 16, 1, DEFOKAY, DEFOKAY, ZERO,
        DEFWAIT12, DEFWAIT8, 1, 1,
     1, 0, 1, 8, 8, "NI", "I", 256, 16, 32, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     0, 1, 0, 16, 8, "NI", "NI", 256, 32, 32, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     0, 0, 1, 32, 8, "NI", "I", 256, 64, 32, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     0, 0, 1, 16, 16, "I", "NI", 256, 128, 32, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO,
     1, 1, 0, 8, 32, "I", "I", 256, 256, 32, 1, DEFOKAY, DEFOKAY, ZERO, ZERO,
        ZERO, ZERO, ZERO
    };

  /* Defining programmed responses */
  struct RespPara LLIPrgmPara [] = {
     Mem1, DataControl, WORDControl, 0x02000000, ZERO, ZERO, PGMERROR,
           0x00000004,
     Mem1, DataControl, WORDControl, 0x02000000, ZERO, ZERO, PGMERROR,
           0x00000000,
     Mem1, DataControl, WORDControl, 0x02000000, ZERO, ZERO, PGMERROR,
           0x00000001,
     Mem1, ZERO, BYTEControl, 0x0F000000, PGMRSRSP3, ZERO, PGMRETRY, 0x00000008,
     Mem1, ZERO, WORDControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x00000003,
     Mem0, DataControl, BYTEControl, 0x02000000, PGMRSRSP3, ZERO, PGMRETRY,
           0x00000002,
     Mem1, ZERO, BYTEControl, 0x02000000, PGMRSRSP1, ZERO, PGMSPLIT,
           0x00000004,
     Mem1, ZERO, WORDControl, 0x0F000000, ZERO, ZERO, PGMERROR, 0x00000002,
     Mem0, ZERO, WORDControl, 0x02000000, PGMRSRSP2, ZERO, PGMSPLIT, 0x00000000,
     Mem1, ZERO, HWORDControl, 0x0F000000, PGMRSRSP3, ZERO, PGMRETRY, 0x00000004
    };
  
  /* Defining test case number and it test case parameters */  
  struct LLICases LLITestCases [] = {
     "DMAC_LLI_1",  &Tests[0],
#ifdef TWOMASTERCONFIG
     "DMAC_LLI_2",  &Tests[1],
     "DMAC_LLI_3",  &Tests[2],
     "DMAC_LLI_4",  &Tests[3],
#endif
     "DMAC_LLI_5",  &Tests[4],
#ifdef TWOMASTERCONFIG
     "DMAC_LLI_6",  &Tests[5],
     "DMAC_LLI_7",  &Tests[6],
     "DMAC_LLI_8",  &Tests[7],
     "DMAC_LLI_9",  &Tests[8],
#endif
     "DMAC_LLI_10", &Tests[9],
#ifdef TWOMASTERCONFIG
     "DMAC_LLI_11", &Tests[10],
     "DMAC_LLI_12", &Tests[11],
     "DMAC_LLI_13", &Tests[12],
     "DMAC_LLI_14", &Tests[13],
     "DMAC_LLI_15", &Tests[14],
     "DMAC_LLI_16", &Tests[15],
     "DMAC_LLI_17", &Tests[16],
     "DMAC_LLI_18", &Tests[17],
     "DMAC_LLI_19", &Tests[18],
     "DMAC_LLI_20", &Tests[19],
     "DMAC_LLI_21", &Tests[20],
     "DMAC_LLI_22", &Tests[21],
#endif
     "DMAC_LLI_23", &Tests[22],
#ifdef TWOMASTERCONFIG
     "DMAC_LLI_24", &Tests[23],
     "DMAC_LLI_25", &Tests[24],
     "DMAC_LLI_26", &Tests[25],
     "DMAC_LLI_27", &Tests[26],
     "DMAC_LLI_28", &Tests[27],
     "DMAC_LLI_29", &Tests[28],
     "DMAC_LLI_30", &Tests[29],
     "DMAC_LLI_31", &Tests[30],
     "DMAC_LLI_32", &Tests[31],
     "DMAC_LLI_33", &Tests[32],
     "DMAC_LLI_34", &Tests[33],
     "DMAC_LLI_35", &Tests[34],
     "DMAC_LLI_36", &Tests[35],
     "DMAC_LLI_37", &Tests[36],
     "DMAC_LLI_38", &Tests[37],
#endif
     "DMAC_LLI_39", &Tests[38],
#ifdef TWOMASTERCONFIG
     "DMAC_LLI_40", &Tests[39],
     "DMAC_LLI_41", &Tests[40],
     "DMAC_LLI_42", &Tests[41],
     "DMAC_LLI_43", &Tests[42],
     "DMAC_LLI_44", &Tests[43],
     "DMAC_LLI_45", &Tests[44],
     "DMAC_LLI_46", &Tests[45],
     "DMAC_LLI_47", &Tests[46],
     "DMAC_LLI_48", &Tests[47],
#endif
     "DMAC_LLI_49", &Tests[48],
#ifdef TWOMASTERCONFIG
     "DMAC_LLI_50", &Tests[49],
     "DMAC_LLI_51", &Tests[50],
     "DMAC_LLI_52", &Tests[51],
#endif
     "DMAC_LLI_53", &Tests[52],
#ifdef TWOMASTERCONFIG
     "DMAC_LLI_54", &Tests[53],
     "DMAC_LLI_55", &Tests[54],
     "DMAC_LLI_56", &Tests[55],
     "DMAC_LLI_57", &Tests[56],
#endif
     "DMAC_LLI_58", &Tests[57],
#ifdef TWOMASTERCONFIG
     "DMAC_LLI_59", &Tests[58],
     "DMAC_LLI_60", &Tests[59],
     "DMAC_LLI_61", &Tests[60],
     "DMAC_LLI_62", &Tests[61],
     "DMAC_LLI_63", &Tests[62],
     "DMAC_LLI_64", &Tests[63],
#endif
     "ENDOFTEST",   &Tests[0]
    };

  /* Defining Test number and programmed responses */ 
  struct PrgmCases LLITestPrgmPara [] = {
     "DMAC_LLI_9",  &LLIPrgmPara[0], 
     "DMAC_LLI_18", &LLIPrgmPara[1], 
     "DMAC_LLI_27", &LLIPrgmPara[2], 
     "DMAC_LLI_37", &LLIPrgmPara[3], 
     "DMAC_LLI_45", &LLIPrgmPara[4], 
     "DMAC_LLI_45", &LLIPrgmPara[5], 
     "DMAC_LLI_54", &LLIPrgmPara[6], 
     "DMAC_LLI_59", &LLIPrgmPara[7], 
     "EOFPRGMCASE", &LLIPrgmPara[0]
    };

  int32 SrcAddrMask, DestAddrMask, MaskValue;
  int32 Addr, *RegAddr, CxLLIRegData, CxControlRegData;
  int32 SrcAddr, DestAddr;
  int32 LLIADDRM1 = 0x08000000;
  int32 LLIADDRM2 = 0x10000000;
  int32 LLISlaveAddrM1 = 0xA0010200;
  int32 LLISlaveAddrM2 = 0xA0020200;
  int32 SrcInfo, DestInfo, TempPerpMaster;
  int i = 0;

  struct  LLICases *TestCases = LLITestCases;
 
  while (TestCases->TestNo != "ENDOFTEST")
  {
     struct LLITestPara *TestCasePara = TestCases->LLICasePara;
     struct PrgmCases *LLIPrgmCases = LLITestPrgmPara; 

     sprintf(Message,"Test No : %s", TestCases->TestNo);
     C(Message);

     sprintf(Message," SW : %d\n DW : %d\n SB : %d\n DB : %d\n TxSize :  %d\n"
                     " SM : %d\n DM : %d\n LLIMaster : %d\n NoOfLLI %d\n "
                     " SrcIncr %s\n DestIncr %s ",
             TestCasePara->SrcWidth,
             TestCasePara->DestWidth,
             TestCasePara->SrcBurst,
             TestCasePara->DestBurst,
             TestCasePara->TxSize,
             TestCasePara->SrcMaster,
             TestCasePara->DestMaster,
             TestCasePara->LLIMaster,
             TestCasePara->NoOfLLI,
             TestCasePara->SrcIncr,
             TestCasePara->DestIncr
            );
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

     /* Reset Memory 1 and 2 */ 
     Write(DMACTrMemEn0, MEMORYRESET);
     Write(DMACTrMemEn1, MEMORYRESET);
     Write(DMACTrMemEn0, MEMORYRSTCLR);
     Write(DMACTrMemEn1, MEMORYRSTCLR);

     /* Determine source and destination slave control information */
     SrcInfo = MEMORYENABLE | RANDOM | TestCasePara-> NoOfDefResp |
               TestCasePara->SrcWaitCyc | TestCasePara->SrcAHBResp;

     DestInfo = MEMORYENABLE | RANDOM | TestCasePara-> NoOfDefResp |
                TestCasePara->DestWaitCyc | TestCasePara->DestAHBResp;

     /*
       The TempPerpMaster variable is used to indicate memory module is
       configured for Master2. If the source/Destination memory module is
       configured for master 2, the respective bit is set. This variable is
       used to configure DMACREQCONFIG register.
     */
     TempPerpMaster = 0x00000000;

     /* Selection of memory module for source/destination module */
     /*
        When Source and Destination Master are same :-
             If the source master and destination master is Master2 and LLI
        master is Master2, select Memory module 0 as source slave and Memory
        module 1 is selected as destination/LLI slave module.
             If source and destination master is Master1 and LLI Master is
        master2, select Memory module 0 as source/destination slave module and
        select Memory module 1 as LLI slave block.
             If source master and destination master is Master2 and LLI master
        is Master1, select Memory module 1 as source/destination slave module
        and select Memory module 0 as LLI slave block.  
             If source and destination master is Master1 and LLI master is
        Master1, select Memory module 0 source slave and Memory module 1 is
        selected as destination/LLI slave module.

        When Source and Destination Master are different :-
             If source master is master1, select memory module 0 as source slave
        and select memory module 1 as destination slave module.
             If source master is master2, select memory module 1 as source slave
        and select memory module 0 as destination slave module.
     */

     if (TestCasePara->SrcMaster == TestCasePara->DestMaster)
     {
       if (TestCasePara->LLIMaster == 1)
       {
         /*
           The source master and destination master is Master2 and LLI
           master is Master2, Memory module 0 is selected as source slave and
           Memory module 1 is selected as destination slave module.
         */
         if (TestCasePara->SrcMaster == 1)
         {
           msg_info("Selecting Memory Module 0 as Source slave Peripheral");
           SrcAddr   = AddrGen(0x08000100, 0x0FFFFFFF) & SrcAddrMask;
           TempPerpMaster = TempPerpMaster | PeriphMasterSel[0];

          msg_info("Selecting Memory Module 1 as Destination slave Peripheral");
           DestAddr  = AddrGen(0x10000100, 0x17FFFFFF) & DestAddrMask;
           TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];

           /* Programming Memory Modules */
           Write(DMACTrMemEn0, SrcInfo);
           Write(DMACTrMemData0, 0xC2000003);
           Write(DMACTrMemEn1, DestInfo);
           Write(DMACTrMemData1, 0xC2000003);
         }
         else
         {
           /*
             If source and destination master is Master1 and LLI master is
             Master2, select Memory module 0 as source/destination slave module            */
           msg_info("Selecting Memory Module0 as Source & Destination slave "
                    "  Periph");
           SrcAddr   = AddrGen(0x08000100, 0x0FFFFFFF) & SrcAddrMask;
           DestAddr  = AddrGen(0x08000100, 0x0FFFFFFF) & DestAddrMask;
           TempPerpMaster = TempPerpMaster | 0x00000000;
           TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];

           /* Programming Memory Modules */
           Write(DMACTrMemEn0, SrcInfo);
           Write(DMACTrMemData0, 0xC2000003);
           Write(DMACTrMemEn1, MEMORYENABLE);
         } 
       }
       else
       {
         if (TestCasePara->SrcMaster == 1)
         {
           /*
             If source master and destination master is Master2 and LLI master
             is Master1 select Memory module 1 as source/destination slave
             module.
           */
           msg_info("Selecting Memory Module 1 as Source & Destination slave "
                    " Periph");
           SrcAddr   = AddrGen(0x10000100, 0x17FFFFFF) & SrcAddrMask;
           DestAddr  = AddrGen(0x10000100, 0x17FFFFFF) & DestAddrMask;
           TempPerpMaster = TempPerpMaster | 0x00000000;
           TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];

           /* Programming Memory Modules */
           Write(DMACTrMemEn1, DestInfo);
           Write(DMACTrMemData1, 0xC2000003);
           Write(DMACTrMemEn0, MEMORYENABLE);
         }
         else
         {
           /*
              If source and destination master is Master1 and LLI master is
              Master1, select Memory module 0 source slave and Memory module 1
              is selected as destination/LLI slave module
            */
           msg_info("Selecting Memory Module 0 as Source slave Peripheral");
           SrcAddr   = AddrGen(0x08000100, 0x0FFFFFFF) & SrcAddrMask;

          msg_info("Selecting Memory Module 1 as Destination slave Peripheral");
           DestAddr  = AddrGen(0x10000100, 0x17FFFFFF) & DestAddrMask;
           TempPerpMaster = TempPerpMaster | 0x00000000;
           TempPerpMaster = TempPerpMaster | 0x00000000;

           /* Programming Memory Modules */
           Write(DMACTrMemEn0, SrcInfo);
           Write(DMACTrMemData0, 0xC2000003);
           Write(DMACTrMemEn1, DestInfo);
           Write(DMACTrMemData1, 0xC2000003);
         }
       }
     }
     else
     {
       if (TestCasePara->SrcMaster == 0)
       {
         /*
           The Source and Destination Master are different and source master is
           master1, select memory module 0 as source slave and select memory
           module 1 as destination slave module.
         */
         msg_info("Selecting Memory Module 0 as Source slave Peripheral");
         SrcAddr   = AddrGen(0x08000100, 0x0FFFFFFF) & SrcAddrMask;

         msg_info("Selecting Memory Module 1 as Destination slave Peripheral");
         DestAddr  = AddrGen(0x10000100, 0x17FFFFFF) & DestAddrMask;

         TempPerpMaster = TempPerpMaster | 0x00000000;
         TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];

         /* Programming Memory Modules */
         Write(DMACTrMemEn0, SrcInfo);
         Write(DMACTrMemData0, 0xC2000003);
         Write(DMACTrMemEn1, DestInfo);
         Write(DMACTrMemData1, 0xC2000003);
       }
       else
       {
         /*
           The Source and Destination Master are different and source master is
           master2, select memory module 1 as source slave
           and select memory module 0 as destination slave module.
         */
         msg_info("Selecting Memory Module 1 as Source slave Peripheral");
         SrcAddr   = AddrGen(0x10000100, 0x17FFFFFF) & SrcAddrMask;

         TempPerpMaster = TempPerpMaster | PeriphMasterSel[1];
         TempPerpMaster = TempPerpMaster | 0x00000000;

         msg_info("Selecting Memory Module 0 as Destination slave Peripheral");
         DestAddr  = AddrGen(0x08000100, 0x0FFFFFFF) & DestAddrMask;

         /* Programming Memory Modules */
         Write(DMACTrMemEn1, SrcInfo);
         Write(DMACTrMemData1, 0xC2000003);
         Write(DMACTrMemEn0, DestInfo);
         Write(DMACTrMemData0, 0xC2000003);
       }
     }

     /* TC and Error interrupt mask bits to be included */
     TempPerpMaster =   TempPerpMaster | ItValue(IntrTcMask) |
                        IeValue(ErrorMask);

     /* Configuring DMACREQCONFIG Register */
     Write(DMACREQCONFIG, TempPerpMaster);

     /* Determine Cx LLI register data */
     if (TestCasePara->LLIMaster == 0) 
       CxLLIRegData = LLIADDRM1 | 0x00000000;
     else if (TestCasePara->LLIMaster == 1)
       CxLLIRegData = LLIADDRM2 | 0x00000001;
     else
     {
       CxLLIRegData = 0x00000000; 
       sprintf(Message,"Invalid LLI Master : %d", TestCasePara->LLIMaster);
       msg_info(Message);
     }

     if (TESTCONFIGURATION == "USER")
     {
       IntrTcEnable = TCENABLE;
       IntrTcMask   = TCMASK;
       ErrorMask    = ERRMASK;
     }
     else
     {
       sprintf(Message,"IntrTcEnable is %d",IntrTcEnable);
       debug_info(Message);
       IntrTcEnable = (~IntrTcEnable);
       sprintf(Message,"IntrTcEnable is %d",IntrTcEnable);
       debug_info(Message);
       IntrTcMask   = (~IntrTcMask);
       ErrorMask    = (~ErrorMask);
     }

     /* Determine Cx control register data */
     CxControlRegData =
                        TestCasePara->TxSize             |
                        SbValue(TestCasePara->SrcBurst)  |
                        DbValue(TestCasePara->DestBurst) |
                        SwValue(TestCasePara->SrcWidth)  |
                        DwValue(TestCasePara->DestWidth) |
                        SmValue(TestCasePara->SrcMaster) |
                        DmValue(TestCasePara->DestMaster)|
                        SiValue(TestCasePara->SrcIncr)   |
                        DiValue(TestCasePara->DestIncr)  |
                        TeValue(IntrTcEnable);

     /*  Programming Source, Destination, LLI and Control register */
     ChannelPrgm(CHANNEL, SrcAddr, DestAddr, CxLLIRegData, CxControlRegData);

     /* LLI block Programming */
     if ((TestCasePara->NoOfLLI > 0) && (TestCasePara->NoOfLLI <= 4))
     {
       /*
         If LLI master is Master1, select memory module 0 as LLI slave module.
         If LLI master is master2, select memory module 1 as LLI slave module. 
       */  
       if (TestCasePara->LLIMaster == 0) 
         Addr     = LLISlaveAddrM1;
       else if (TestCasePara->LLIMaster == 1)
         Addr     = LLISlaveAddrM2;

       for (i = TestCasePara->NoOfLLI; i > 0; i--)
       {
         /* Generate source address for next LLI block */ 
         SrcAddr   = AddrGen(SrcAddr,  SrcAddr  | 0x0000FFFF) & SrcAddrMask;

         /* Generate destination address for next LLI block */ 
         DestAddr  = AddrGen(DestAddr, DestAddr | 0x0000FFFF) & DestAddrMask;

         /*
            Determine next LLI address. For last LLI next LLI block address is
            zero.
         */    
         if (i == 1)
           CxLLIRegData = 0x00000000;
         else
           CxLLIRegData = CxLLIRegData + 0x00000010;

         /* Program LLI block */ 
         Write(Addr, SrcAddr);
         Write(Addr + 0x00000004, DestAddr);
         Write(Addr + 0x00000008, CxLLIRegData);
         Write(Addr + 0x0000000C, CxControlRegData);

         Addr = Addr + 0x00000010;
       }
     }
     else
     {
      sprintf(Message,"Number of LLI Programmed is % d", TestCasePara->NoOfLLI);
      msg_info(Message);
     }
     /* Programming Memory for Programmed Response */ 
     if (TestCasePara->IsAnyPrgmResp)
       SlaveRespPrgm(LLIPrgmCases, TestCases->TestNo, TestCasePara->NoOfPrgmResp);

     /* Enable Channel by setting channel bit */
     /* Determine channel register base address */
     RegAddr = ChannelRegisters(CHANNEL);
     Write (*RegAddr + 0x00000010, CHXENABLE);

     /* Poll Channel Enable Bit going low */ 
     MaskValue = 0x00000001;
     Poll(ConfigRegs[CHANNEL], 0x00000000, MaskValue);
     WaitLoop(10);

     sprintf(Message," End Of %s Test", TestCases->TestNo);
     C(Message);

     TestCases++;
  }  
}

/***************************** End of LLI Tests *******************************/

