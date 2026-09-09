/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2001 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : SmcCommon.c.rca
--  File Revision          : 1.10
--
--  Release Information    : PrimeCell(TM)-PL092-REL1v1
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           This file contains global variables and common functions
--           used by other tests.
--
-- --=========================================================================*/

/******************************************************************************/
/***************************** Global Variables *******************************/
/******************************************************************************/

int32 SMCTrMEMBData[8] = {0x0000, 0x0000, 0x0000, 0x0000,
                          0x0000, 0x0000, 0x0000, 0x0000};

int ENDIANNESS;

/******************************************************************************/
/***************************** Common Functions *******************************/
/******************************************************************************/

void WaitLoop(int cyc)
{
  /*
     Summary: Inserts Wait Loops
     ===========================
     This function performs the following:

     o  Inserts programmed number of idle cycles.
  */

  int i;

  for (i = 0; i < cyc; i++)
  {
    HSA(SMCTrMCREQD, IDLE, INCR, , WRD); /** Addr has to be changed to ZERO **/
    HSR( , ZERO, , MaskAll, ,WaitLoop_1);
  }
}

void WriteReadTests(int32 TestData)
{
  /*
     Summary: Write-Read Tests
     =========================
     This performs performs the following:

     o  Writes and expects the same data in case of the R/W registers.

     o  Writes and expects the default data in case of the Read-only
        registers.
  */
  
  int32 RdData;

  /** Performing Write-Read Tests on IDLE Cycle control Registers **/
  C("Performing Write-Read Tests on IDCY Registers");
  RdData = TestData & 0x0000000F;
  HSA(SMBIDCYR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBIDCYR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_1);

  HSA(SMBIDCYR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBIDCYR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_2);

  HSA(SMBIDCYR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBIDCYR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_3);

  HSA(SMBIDCYR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBIDCYR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_4);

  HSA(SMBIDCYR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBIDCYR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_5);

  HSA(SMBIDCYR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBIDCYR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_6);

  HSA(SMBIDCYR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBIDCYR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_7);

  HSA(SMBIDCYR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBIDCYR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_8);

  /** Performing Write-Read Tests on Wait State 1 Control Registers **/
  C("Performing Write-Read Tests on WST1 Registers");
  RdData = TestData & 0x0000001F;
  HSA(SMBWST1R0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWST1R0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_9);

  HSA(SMBWST1R1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWST1R1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_10);

  HSA(SMBWST1R2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWST1R2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_11);

  HSA(SMBWST1R3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWST1R3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_12);

  HSA(SMBWST1R4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWST1R4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_13);

  HSA(SMBWST1R5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWST1R5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_14);

  HSA(SMBWST1R6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWST1R6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_15);

  HSA(SMBWST1R7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWST1R7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_16);

  /** Performing Write-Read Tests on Wait State 2 Control Registers **/
  C("Performing Write-Read Tests on WST2 Registers");
  RdData = TestData & 0x0000001F;
  HSA(SMBWST2R0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWST2R0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_17);

  HSA(SMBWST2R1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWST2R1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_18);

  HSA(SMBWST2R2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWST2R2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_19);

  HSA(SMBWST2R3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWST2R3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_20);

  HSA(SMBWST2R4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWST2R4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_21);

  HSA(SMBWST2R5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWST2R5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_22);

  HSA(SMBWST2R6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWST2R6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_23);

  HSA(SMBWST2R7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWST2R7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_24);

  /** Performing Write-Read Tests on Output Enable Assertion Delay Control **/
  /** Registers **/
  C("Performing Write-Read Tests on WSTOEN Registers");
  RdData = TestData & 0x0000000F;
  HSA(SMBWSTOENR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTOENR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_25);

  HSA(SMBWSTOENR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTOENR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_26);

  HSA(SMBWSTOENR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTOENR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_27);

  HSA(SMBWSTOENR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTOENR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_28);

  HSA(SMBWSTOENR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTOENR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_29);

  HSA(SMBWSTOENR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTOENR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_30);

  HSA(SMBWSTOENR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTOENR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_31);

  HSA(SMBWSTOENR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTOENR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_32);

  /** Performing Write-Read Tests on Write Enable Delay Assertion Control **/
  /** Registers **/
  C("Performing Write-Read Tests on WSTWEN Registers");
  RdData = TestData & 0x0000000F;
  HSA(SMBWSTWENR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTWENR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_33);

  HSA(SMBWSTWENR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTWENR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_34);

  HSA(SMBWSTWENR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTWENR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_35);

  HSA(SMBWSTWENR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTWENR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_36);

  HSA(SMBWSTWENR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTWENR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_37);

  HSA(SMBWSTWENR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTWENR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_38);

  HSA(SMBWSTWENR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTWENR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_39);

  HSA(SMBWSTWENR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTWENR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_40);

  /** Performing Write-Read Tests on Control Registers **/
  C("Performing Write-Read Tests on BCR Registers");
  RdData = TestData & 0x000000FF;
  HSA(SMBCR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  /** Writing into the Trickbox MEMT Register to avoid Multiple CS assertion **/
  HSA(SMCTrMEMT_0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData << 4);
  HSA(SMBCR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_41);

  HSA(SMBCR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  /** Writing into the Trickbox MEMT Register to avoid Multiple CS assertion **/
  HSA(SMCTrMEMT_1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData << 4);
  HSA(SMBCR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_42);

  HSA(SMBCR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  /** Writing into the Trickbox MEMT Register to avoid Multiple CS assertion **/
  HSA(SMCTrMEMT_2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData << 4);
  HSA(SMBCR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_43);

  HSA(SMBCR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  /** Writing into the Trickbox MEMT Register to avoid Multiple CS assertion **/
  HSA(SMCTrMEMT_3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData << 4);
  HSA(SMBCR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_44);

  HSA(SMBCR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  /** Writing into the Trickbox MEMT Register to avoid Multiple CS assertion **/
  HSA(SMCTrMEMT_4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData << 4);
  HSA(SMBCR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_45);

  HSA(SMBCR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  /** Writing into the Trickbox MEMT Register to avoid Multiple CS assertion **/
  HSA(SMCTrMEMT_5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData << 4);
  HSA(SMBCR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_46);

  HSA(SMBCR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  /** Writing into the Trickbox MEMT Register to avoid Multiple CS assertion **/
  HSA(SMCTrMEMT_6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData << 4);
  HSA(SMBCR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_47);

  HSA(SMBCR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  /** Writing into the Trickbox MEMT Register to avoid Multiple CS assertion **/
  HSA(SMCTrMEMT_7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData << 4);
  HSA(SMBCR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_48);

  /** Performing Write-Read Tests on Status Registers **/
  C("Performing Write-Read Tests on BSR Registers");
  HSA(SMBSR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBSR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR0, , NoMask, ,WriteReadTests_49);

  HSA(SMBSR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBSR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR1, , NoMask, ,WriteReadTests_50);

  HSA(SMBSR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBSR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR2, , NoMask, ,WriteReadTests_51);

  HSA(SMBSR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBSR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR3, , NoMask, ,WriteReadTests_52);

  HSA(SMBSR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBSR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR4, , NoMask, ,WriteReadTests_53);

  HSA(SMBSR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBSR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR5, , NoMask, ,WriteReadTests_54);

  HSA(SMBSR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBSR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR6, , NoMask, ,WriteReadTests_55);

  HSA(SMBSR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBSR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR7, , NoMask, ,WriteReadTests_56);

  /** Performing Write-Read Tests on Read Only Registers **/
  C("Performing Write-Read Tests on Read Only Registers");
  HSA(SMCPeriphID0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMCPeriphID0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMCPeriphID0, , NoMask, ,WriteReadTests_49);

  HSA(SMCPeriphID1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMCPeriphID1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMCPeriphID1, , NoMask, ,WriteReadTests_50);

  HSA(SMCPeriphID2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMCPeriphID2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMCPeriphID2, , NoMask, ,WriteReadTests_51);

  HSA(SMCPeriphID3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMCPeriphID3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMCPeriphID3, , NoMask, ,WriteReadTests_52);

  HSA(SMCPCellID0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMCPCellID0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMCPCellID0, , NoMask, ,WriteReadTests_53);

  HSA(SMCPCellID1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMCPCellID1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMCPCellID1, , NoMask, ,WriteReadTests_54);

  HSA(SMCPCellID2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMCPCellID2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMCPCellID2, , NoMask, ,WriteReadTests_55);

  HSA(SMCPCellID3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMCPCellID3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMCPCellID3, , NoMask, ,WriteReadTests_56);

  /** Performing Write-Read Tests on an address other than the functional **/
  /** registers **/
  HSA(SMCCR_BASE + 0xE4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMCCR_BASE + 0xE4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , ZERO, , NoMask, ,ResetTests_69);
}

void ConfigureMemory(int BankNo, int32 SMCTrIDCYDat, int32 SMCTrWST1Dat,
                     int32 SMCTrWST2Dat, int32 SMCTrMEMTDat,
                     int32 SMCTrMEMBDat, int32 SMCTrCS2OENDat,
                     int32 SMCTrCS2WENDat, int32 SMCTrCSPOLDat)
{
  /*
     Summary: Memory model Configuration
     ===================================
     This performs performs the following:

     o  Configures Memory model (TrickMem) to the parameters specified by the
        arguments
  */
  int32 SMCTrIDCY, SMCTrWST1, SMCTrWST2, SMCTrMEMT, SMCTrMEMB, SMCTrCS2OEN,
        SMCTrCS2WEN, SMCTrCSPOL;

  switch (BankNo)
  {
    case 0 : SMCTrIDCY   = SMCTrIDCY_0;
             SMCTrWST1   = SMCTrWST1_0;
             SMCTrWST2   = SMCTrWST2_0;
             SMCTrMEMT   = SMCTrMEMT_0;
             SMCTrMEMB   = SMCTrMEMB_0;
             SMCTrCS2OEN = SMCTrCS2OEN_0;
             SMCTrCS2WEN = SMCTrCS2WEN_0;
             SMCTrCSPOL  = SMCTrCSPOL_0; break;

    case 1 : SMCTrIDCY   = SMCTrIDCY_1;
             SMCTrWST1   = SMCTrWST1_1;
             SMCTrWST2   = SMCTrWST2_1;
             SMCTrMEMT   = SMCTrMEMT_1;
             SMCTrMEMB   = SMCTrMEMB_1;
             SMCTrCS2OEN = SMCTrCS2OEN_1;
             SMCTrCS2WEN = SMCTrCS2WEN_1;
             SMCTrCSPOL  = SMCTrCSPOL_1; break;

    case 2 : SMCTrIDCY   = SMCTrIDCY_2;
             SMCTrWST1   = SMCTrWST1_2;
             SMCTrWST2   = SMCTrWST2_2;
             SMCTrMEMT   = SMCTrMEMT_2;
             SMCTrMEMB   = SMCTrMEMB_2;
             SMCTrCS2OEN = SMCTrCS2OEN_2;
             SMCTrCS2WEN = SMCTrCS2WEN_2;
             SMCTrCSPOL  = SMCTrCSPOL_2; break;

    case 3 : SMCTrIDCY   = SMCTrIDCY_3;
             SMCTrWST1   = SMCTrWST1_3;
             SMCTrWST2   = SMCTrWST2_3;
             SMCTrMEMT   = SMCTrMEMT_3;
             SMCTrMEMB   = SMCTrMEMB_3;
             SMCTrCS2OEN = SMCTrCS2OEN_3;
             SMCTrCS2WEN = SMCTrCS2WEN_3;
             SMCTrCSPOL  = SMCTrCSPOL_3; break;

    case 4 : SMCTrIDCY   = SMCTrIDCY_4;
             SMCTrWST1   = SMCTrWST1_4;
             SMCTrWST2   = SMCTrWST2_4;
             SMCTrMEMT   = SMCTrMEMT_4;
             SMCTrMEMB   = SMCTrMEMB_4;
             SMCTrCS2OEN = SMCTrCS2OEN_4;
             SMCTrCS2WEN = SMCTrCS2WEN_4;
             SMCTrCSPOL  = SMCTrCSPOL_4; break;

    case 5 : SMCTrIDCY   = SMCTrIDCY_5;
             SMCTrWST1   = SMCTrWST1_5;
             SMCTrWST2   = SMCTrWST2_5;
             SMCTrMEMT   = SMCTrMEMT_5;
             SMCTrMEMB   = SMCTrMEMB_5;
             SMCTrCS2OEN = SMCTrCS2OEN_5;
             SMCTrCS2WEN = SMCTrCS2WEN_5;
             SMCTrCSPOL  = SMCTrCSPOL_5; break;

    case 6 : SMCTrIDCY   = SMCTrIDCY_6;
             SMCTrWST1   = SMCTrWST1_6;
             SMCTrWST2   = SMCTrWST2_6;
             SMCTrMEMT   = SMCTrMEMT_6;
             SMCTrMEMB   = SMCTrMEMB_6;
             SMCTrCS2OEN = SMCTrCS2OEN_6;
             SMCTrCS2WEN = SMCTrCS2WEN_6;
             SMCTrCSPOL  = SMCTrCSPOL_6; break;

    case 7 : SMCTrIDCY   = SMCTrIDCY_7;
             SMCTrWST1   = SMCTrWST1_7;
             SMCTrWST2   = SMCTrWST2_7;
             SMCTrMEMT   = SMCTrMEMT_7;
             SMCTrMEMB   = SMCTrMEMB_7;
             SMCTrCS2OEN = SMCTrCS2OEN_7;
             SMCTrCS2WEN = SMCTrCS2WEN_7;
             SMCTrCSPOL  = SMCTrCSPOL_7; break;
  }

  /** Write into the selected Bank **/
  HSA(SMCTrMEMT, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMCTrMEMTDat);
  HSA(SMCTrIDCY, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMCTrIDCYDat);
  HSA(SMCTrWST1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMCTrWST1Dat);
  HSA(SMCTrWST2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMCTrWST2Dat);
  HSA(SMCTrMEMB, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMCTrMEMBDat);
  HSA(SMCTrCS2OEN, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMCTrCS2OENDat);
  HSA(SMCTrCS2WEN, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMCTrCS2WENDat);
  HSA(SMCTrCSPOL, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMCTrCSPOLDat);
}

void ConfigureUUT(int BankNo, int32 SMBIDCYData, int32 SMBWST1Data,
                  int32 SMBWST2Data, int32 SMBWSTOENData, int32 SMBWSTWENData,
                  int32 SMBCRData, int32 SMCTrCS2WTData, int32 SMCTrCEWTData)
{
  /*
     Summary: SMC Configuration
     ==========================
     This performs performs the following:

     o  Programs the SMC to the parameters specified by the arguments
  */

  int32 SMBCR, SMBIDCY, SMBWST1, SMBWST2, SMBWSTOEN, SMBWSTWEN;
  int32 SMCTrCS2WT, SMCTrCEWT;
  switch(BankNo)
  {
    case 0 : SMBIDCY = SMBIDCYR0;
             SMBWST1 = SMBWST1R0;
             SMBWST2 = SMBWST2R0;
             SMBWSTOEN = SMBWSTOENR0;
             SMBWSTWEN = SMBWSTWENR0;
             SMBCR = SMBCR0;
             SMCTrCS2WT = SMCTrCS2WTR0;
             SMCTrCEWT = SMCTrCEWTR0; break;

    case 1 : SMBIDCY = SMBIDCYR1;
             SMBWST1 = SMBWST1R1;
             SMBWST2 = SMBWST2R1;
             SMBWSTOEN = SMBWSTOENR1;
             SMBWSTWEN = SMBWSTWENR1;
             SMBCR = SMBCR1;
             SMCTrCS2WT = SMCTrCS2WTR1;
             SMCTrCEWT = SMCTrCEWTR1; break;

    case 2 : SMBIDCY = SMBIDCYR2;
             SMBWST1 = SMBWST1R2;
             SMBWST2 = SMBWST2R2;
             SMBWSTOEN = SMBWSTOENR2;
             SMBWSTWEN = SMBWSTWENR2;
             SMBCR = SMBCR2;
             SMCTrCS2WT = SMCTrCS2WTR2;
             SMCTrCEWT = SMCTrCEWTR2; break;

    case 3 : SMBIDCY = SMBIDCYR3;
             SMBWST1 = SMBWST1R3;
             SMBWST2 = SMBWST2R3;
             SMBWSTOEN = SMBWSTOENR3;
             SMBWSTWEN = SMBWSTWENR3;
             SMBCR = SMBCR3;
             SMCTrCS2WT = SMCTrCS2WTR3;
             SMCTrCEWT = SMCTrCEWTR3; break;

    case 4 : SMBIDCY = SMBIDCYR4;
             SMBWST1 = SMBWST1R4;
             SMBWST2 = SMBWST2R4;
             SMBWSTOEN = SMBWSTOENR4;
             SMBWSTWEN = SMBWSTWENR4;
             SMBCR = SMBCR4;
             SMCTrCS2WT = SMCTrCS2WTR4;
             SMCTrCEWT = SMCTrCEWTR4; break;

    case 5 : SMBIDCY = SMBIDCYR5;
             SMBWST1 = SMBWST1R5;
             SMBWST2 = SMBWST2R5;
             SMBWSTOEN = SMBWSTOENR5;
             SMBWSTWEN = SMBWSTWENR5;
             SMBCR = SMBCR5;
             SMCTrCS2WT = SMCTrCS2WTR5;
             SMCTrCEWT = SMCTrCEWTR5; break;

    case 6 : SMBIDCY = SMBIDCYR6;
             SMBWST1 = SMBWST1R6;
             SMBWST2 = SMBWST2R6;
             SMBWSTOEN = SMBWSTOENR6;
             SMBWSTWEN = SMBWSTWENR6;
             SMBCR = SMBCR6;
             SMCTrCS2WT = SMCTrCS2WTR6;
             SMCTrCEWT = SMCTrCEWTR6; break;

    case 7 : SMBIDCY = SMBIDCYR7;
             SMBWST1 = SMBWST1R7;
             SMBWST2 = SMBWST2R7;
             SMBWSTOEN = SMBWSTOENR7;
             SMBWSTWEN = SMBWSTWENR7;
             SMBCR = SMBCR7;
             SMCTrCS2WT = SMCTrCS2WTR7;
             SMCTrCEWT = SMCTrCEWTR7; break;
  }

  /** Write into the selected Bank Configuration register (SMBCRx)          **/
  HSA(SMBIDCY, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBIDCYData);
  HSA(SMBWST1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBWST1Data);
  HSA(SMBWST2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBWST2Data);
  HSA(SMBWSTOEN, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBWSTOENData);
  HSA(SMBWSTWEN, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBWSTWENData);

  /** Add Waitn and WaitPol information to the SMCTrCS2WTData **/
  SMCTrCS2WTData = SMCTrCS2WTData | ((SMBCRData & 0x6) << 23);
  HSA(SMCTrCS2WT, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMCTrCS2WTData);
  HSA(SMCTrCEWT, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMCTrCEWTData);
  HSA(SMBCR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBCRData);
}

void ToggleSMADDR(int32 SMCTrMEMBase, int32 SMCTrMemAddr)
{
  /*
     Summary: Toggle SMADDR Lines
     ============================
     This performs performs the following:

     o  Writes to a Memory location through the SMC and verifies through both
        the SMC and AHB Read.
  */

  int32 MemAddr, AHBAddr;

  MemAddr = SMCTrMEMBase + 0x00000AAA;
  AHBAddr = SMCTrMemAddr + 0x00000AAA;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , DataA);

  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , DataA, , NoMask, ,ToggleSMADDR_1);
}

void SingleWriteRead(int BankNo, int Burst, int32 Offset, char hsize,
                     int32 Data)
{
  /*
     Summary: Single Write-Read
     ==========================
     This performs performs the following:

     o  Writes to a Memory location through the SMC and verifies through both
        the SMC and AHB Read.
  */

  int32 MemAddr, BSRAddr;
  char* beat[8] = {"sin", "inc", "in4", "in8", "in16", "wr4", "wr8", "w16"};

  switch(BankNo)
  {
    case 0 : MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + Offset;
             BSRAddr = SMBSR0;
    case 1 : MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + Offset;
             BSRAddr = SMBSR1;
    case 2 : MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11) + Offset;
             BSRAddr = SMBSR2;
    case 3 : MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11) + Offset;
             BSRAddr = SMBSR3;
    case 4 : MemAddr = SMCMEM_4 + (SMCTrMEMBData[4] << 11) + Offset;
             BSRAddr = SMBSR4;
    case 5 : MemAddr = SMCMEM_5 + (SMCTrMEMBData[5] << 11) + Offset;
             BSRAddr = SMBSR5;
    case 6 : MemAddr = SMCMEM_6 + (SMCTrMEMBData[6] << 11) + Offset;
             BSRAddr = SMBSR6;
    case 7 : MemAddr = SMCMEM_7 + (SMCTrMEMBData[7] << 11) + Offset;
             BSRAddr = SMBSR7;
  }

  /** Writing via SMC **/
  HSA(MemAddr, NSEQ, beat[Burst], , hsize, , 0x1, , , , ,);
  HSW( , Data);

  /** Reading via SMC **/
  HSA(MemAddr, NSEQ, beat[Burst], , hsize, , 0x1, , , , ,);
  HSR( , Data, , NoMask, , SingleWriteRead_1);

  HSA(BSRAddr, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , ZERO, , NoMask, , SingleWriteRead_1);
}

void BurstWriteRead(int BankNo, int Burst, int32 Offset, int hsize, int msize,
                    int32 Data)
{
  /*
     Summary: Burst Write-Read
     =========================
     This performs performs the following:

     o  Writes to a Memory location through the SMC and verifies through both
        the SMC and AHB Read.
  */

  int32 MemAddr, AHBAddr, AHBRdData1, AHBRdData2, AHBRdData3, AHBRdData4;
  int32 TempData, TestData, ReadMask;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "in16", "wr4", "wr8", "w16"};
  char* SizeStr[3] = {"BYTE", "HALFWORD", "WORD"};
  char* BurstStr[8] = {"SINGLE", "INCR", "INCR4", "INCR8", "INCR16", "WRAP4",
                       "WRAP8", "WRAP16"};
  char PrintStr[75];
  int Shift[3] = {8, 16, 32};
  int32 Mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int i, BeatsNo;

  switch(BankNo)
  {
    case 0 : MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + Offset;
             AHBAddr = SMCTrMEMR_0 + Offset; break;
    case 1 : MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + Offset;
             AHBAddr = SMCTrMEMR_1 + Offset; break;
    case 2 : MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11) + Offset;
             AHBAddr = SMCTrMEMR_2 + Offset; break;
    case 3 : MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11) + Offset;
             AHBAddr = SMCTrMEMR_3 + Offset; break;
    case 4 : MemAddr = SMCMEM_4 + (SMCTrMEMBData[4] << 11) + Offset;
             AHBAddr = SMCTrMEMR_4 + Offset; break;
    case 5 : MemAddr = SMCMEM_5 + (SMCTrMEMBData[5] << 11) + Offset;
             AHBAddr = SMCTrMEMR_5 + Offset; break;
    case 6 : MemAddr = SMCMEM_6 + (SMCTrMEMBData[6] << 11) + Offset;
             AHBAddr = SMCTrMEMR_6 + Offset; break;
    case 7 : MemAddr = SMCMEM_7 + (SMCTrMEMBData[7] << 11) + Offset;
             AHBAddr = SMCTrMEMR_7 + Offset; break;
  }

  switch(Burst)
  {
    case 0 : BeatsNo = 1;  break;
    case 1 : BeatsNo = 1;  break;
    case 2 : BeatsNo = 4;  break;
    case 3 : BeatsNo = 8;  break;
    case 4 : BeatsNo = 16; break;
    case 5 : BeatsNo = 4;  break;
    case 6 : BeatsNo = 8;  break;
    case 7 : BeatsNo = 16; break;
  }

  sprintf(PrintStr,
          "Does Burst Write-Reads with HSIZE = %s, MSIZE = %s, BURST = %s",
          SizeStr[hsize], SizeStr[msize], BurstStr[Burst]);
  C(PrintStr);

  /** Writing via SMC **/
  TempData = Data;
  if (ENDIANNESS == 0)
  {
    TestData = TempData & Mask[hsize];
  } else
  {
    TestData = (TempData << 3*Shift[hsize]) &
               (Mask[hsize] << 3*Shift[hsize]);
  }

  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
  HSW( , TestData);
  for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      TestData = TempData & Mask[hsize];
    } else
    {
      TestData = (TempData << (3-i%4)*Shift[hsize]) &
                 (Mask[hsize] << (3-i%4)*Shift[hsize]);
    }
    HSW( , TestData);
  }

  /** Reading via SMC **/
  TempData = Data;
  if (ENDIANNESS == 0)
  {
    ReadMask = Mask[hsize];
    TestData = TempData & ReadMask;
  } else
  {
    ReadMask = (Mask[hsize] << 3*Shift[hsize]);
    TestData = (TempData << 3*Shift[hsize]) & ReadMask;
  }

  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
  HSR( , TestData, , ReadMask, ,BurstWriteRead_1);
  for (i = 1, TempData++; i < BeatsNo; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      ReadMask = (Mask[hsize] << i*Shift[hsize]);
      TestData = (TempData << i*Shift[hsize]) & ReadMask;
    } else
    {
      ReadMask = (Mask[hsize] << (3-i%4)*Shift[hsize]);
      TestData = (TempData << (3-i%4)*Shift[hsize]) & ReadMask;
    }
    HSR( , TestData, , ReadMask, ,BurstWriteRead_2);
  }

  /** Verifying via AHB **/
  TempData = Data;
  switch (size[msize])
  {
    case 'b': switch (size[hsize])
    {
      case 'b' : for (i=0; i<BeatsNo; i++, TempData++, AHBAddr+=4)
                 {
                   AHBRdData1 = (TempData & Mask[msize]);
                   HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , ,);
                   HSR( , AHBRdData1, , NoMask, ,BurstWriteRead_3);
                 } break;
      case 'h' : for (i=0; i<BeatsNo; i++, TempData++, AHBAddr+=4)
                 {
                   if (ENDIANNESS == 0)
                   {
                     AHBRdData1 = (TempData & Mask[msize]);
                     AHBRdData2 = (TempData >> 8 & Mask[msize]);
                   } else
                   {
                     AHBRdData2 = (TempData & Mask[msize]);
                     AHBRdData1 = (TempData >> 8 & Mask[msize]);
                   }
                   HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , ,);
                   HSR( , AHBRdData1, , Mask[msize], ,BurstWriteRead_4);
                   AHBAddr+=4;
                   HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , ,);
                   HSR( , AHBRdData2, , Mask[msize], ,BurstWriteRead_5);
                 } break;
      case 'w' : for (i=0; i<BeatsNo; i++, TempData++, AHBAddr+=4)
                 {
                   if (ENDIANNESS == 0)
                   {
                     AHBRdData1 = (TempData & Mask[msize]);
                     AHBRdData2 = (TempData >> 8 & Mask[msize]);
                     AHBRdData3 = (TempData >> 16 & Mask[msize]);
                     AHBRdData4 = (TempData >> 24 & Mask[msize]);
                   } else
                   {
                     AHBRdData4 = (TempData & Mask[msize]);
                     AHBRdData3 = (TempData >> 8 & Mask[msize]);
                     AHBRdData2 = (TempData >> 16 & Mask[msize]);
                     AHBRdData1 = (TempData >> 24 & Mask[msize]);
                   }
                   HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , ,);
                   HSR( , AHBRdData1, , Mask[msize], ,BurstWriteRead_6);
                   AHBAddr+=4;
                   HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , ,);
                   HSR( , AHBRdData2, , Mask[msize], ,BurstWriteRead_7);
                   AHBAddr+=4;
                   HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , ,);
                   HSR( , AHBRdData3, , Mask[msize], ,BurstWriteRead_8);
                   AHBAddr+=4;
                   HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , ,);
                   HSR( , AHBRdData4, , Mask[msize], ,BurstWriteRead_9);
                 } break;
      default : break;
     
    } break;
    case 'h' : switch (size[hsize])
    {
      case 'b' : for (i=0; i<BeatsNo; i+=2, TempData++, AHBAddr+=4)
                 {
                   if (ENDIANNESS == 0)
                   {
                     ReadMask = NoMask;
                     AHBRdData1 = (TempData & Mask[hsize]) |
                                  ((++TempData << 8) & (Mask[hsize] << 8));
                     if (BeatsNo < 2)
                     {
                       ReadMask = Mask[hsize];
                       AHBRdData1 = AHBRdData1 & ReadMask;
                     }
                   } else
                   {
                     ReadMask = NoMask;
                     AHBRdData1 = ((TempData << 8) & (Mask[hsize] << 8)) |
                                  (++TempData & Mask[hsize]);
                     if (BeatsNo < 2)
                     {
                       ReadMask = Mask[hsize] << 8;
                       AHBRdData1 = AHBRdData1 & ReadMask;
                     }
                   }
                     HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , ,);
                     HSR( , AHBRdData1, , ReadMask, ,BurstWriteRead_10);
                 } break;
      case 'h' : for (i=0; i<BeatsNo; i++, TempData++, AHBAddr+=4)
                 {
                   AHBRdData1 = (TempData & Mask[msize]);
                   HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , ,);
                   HSR( , AHBRdData1, , Mask[msize], ,BurstWriteRead_11);
                 } break;
      case 'w' : for (i=0; i<BeatsNo; i++, TempData++, AHBAddr+=4)
                 {
                   if (ENDIANNESS == 0)
                   {
                     AHBRdData1 = (TempData & Mask[msize]);
                     AHBRdData2 = (TempData >> 16 & Mask[msize]);
                   } else
                   {
                     AHBRdData2 = (TempData & Mask[msize]);
                     AHBRdData1 = (TempData >> 16 & Mask[msize]);
                   }
                   HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , ,);
                   HSR( , AHBRdData1, , Mask[msize], ,BurstWriteRead_12);
                   AHBAddr+=4;
                   HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , ,);
                   HSR( , AHBRdData2, , Mask[msize], ,BurstWriteRead_13);
                 } break;
      default : break;
    } break;
    case 'w' : switch (size[hsize])
    {
      case 'b' : for (i=0; i<BeatsNo; i+=4, TempData++, AHBAddr+=4)
                 {
                   if (ENDIANNESS == 0)
                   {
                     ReadMask = NoMask;
                     AHBRdData1 = (TempData & Mask[hsize]) |
                                  ((++TempData << 8) & (Mask[hsize] << 8)) |
                                  ((++TempData << 16) & (Mask[hsize] << 16)) |
                                  ((++TempData << 24) & (Mask[hsize] << 24));
                     if (BeatsNo < 4)
                     {
                       ReadMask = Mask[hsize];
                       AHBRdData1 = AHBRdData1 & ReadMask;
                     }
                   } else
                   {
                     ReadMask = NoMask;
                     AHBRdData1 = ((TempData << 24) & (Mask[hsize] << 24)) |
                                  ((++TempData << 16) & (Mask[hsize] << 16)) |
                                  ((++TempData << 8) & (Mask[hsize] << 8)) |
                                  (++TempData & Mask[hsize]);
                     if (BeatsNo < 4)
                     {
                       ReadMask = Mask[hsize] << 24;
                       AHBRdData1 = AHBRdData1 & ReadMask;
                     }
                   }
                   HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , ,);
                   HSR( , AHBRdData1, , ReadMask, ,BurstWriteRead_14);
                 } break;
      case 'h' : for (i=0; i<BeatsNo; i+=2, TempData++, AHBAddr+=4)
                 {
                   if (ENDIANNESS == 0)
                   {
                     ReadMask = NoMask;
                     AHBRdData1 = (TempData & Mask[hsize]) |
                                  ((++TempData << 16) & (Mask[hsize] << 16));
                       if (BeatsNo < 4)
                       {
                         ReadMask = Mask[hsize];
                         AHBRdData1 = AHBRdData1 & ReadMask;
                       }
                   } else
                   {
                     ReadMask = NoMask;
                     AHBRdData1 = ((TempData << 16) & (Mask[hsize] << 16)) |
                                  (++TempData & Mask[hsize]);
                       if (BeatsNo < 4)
                       {
                         ReadMask = Mask[hsize] << 16;
                         AHBRdData1 = AHBRdData1 & ReadMask;
                       }
                   }
                   HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , ,);
                   HSR( , AHBRdData1, , ReadMask, ,BurstWriteRead_15);
                 } break;
      case 'w' : for (i=0; i<BeatsNo; i++, TempData++, AHBAddr+=4)
                 {
                   AHBRdData1 = (TempData & Mask[msize]);
                   HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , ,);
                   HSR( , AHBRdData1, , NoMask, ,BurstWriteRead_16);
                 } break;
    } break;
    default : break;
  } 
}

void AHBFillMem(int BankNo, int32 Offset, int BlockSize, int32 FillData)
{
  /*
     Summary: Write into Memory through AHB side
     ===========================================
     This performs performs the following :

     o  Writes into the Memory bank 'BankNo' through the AHB side.
     o  Starts from 'Offset' away from the Base Address.
     o  Fills 'BlockSize' number of words.
     o  Starting from 'StartData', the memory is filled in an incrementing
        fashion (i.e. StartData, StartData+1, StartData+2, ..).
  */
     
  int i;
  int32 AHBAddr;

  switch(BankNo)
  {
    case 0 : AHBAddr = SMCTrMEMR_0 + Offset; break;
    case 1 : AHBAddr = SMCTrMEMR_1 + Offset; break;
    case 2 : AHBAddr = SMCTrMEMR_2 + Offset; break;
    case 3 : AHBAddr = SMCTrMEMR_3 + Offset; break;
    case 4 : AHBAddr = SMCTrMEMR_4 + Offset; break;
    case 5 : AHBAddr = SMCTrMEMR_5 + Offset; break;
    case 6 : AHBAddr = SMCTrMEMR_6 + Offset; break;
    case 7 : AHBAddr = SMCTrMEMR_7 + Offset; break;
  }

  HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , FillData);
  for (i=0; i<BlockSize; i++)
    HSW( , FillData);

}

void AHBWriteMem(int BankNo, int32 Offset, int BlockSize, int32 StartData)
{
  /*
     Summary: Write into Memory through AHB side
     ===========================================
     This performs performs the following :

     o  Writes into the Memory bank 'BankNo' through the AHB side.
     o  Starts from 'Offset' away from the Base Address.
     o  Fills 'BlockSize' number of words.
     o  Starting from 'StartData', the memory is filled in an incrementing
        fashion (i.e. StartData, StartData+1, StartData+2, ..).
  */
     
  int i;
  int32 AHBAddr;

  switch(BankNo)
  {
    case 0 : AHBAddr = SMCTrMEMR_0 + Offset; break;
    case 1 : AHBAddr = SMCTrMEMR_1 + Offset; break;
    case 2 : AHBAddr = SMCTrMEMR_2 + Offset; break;
    case 3 : AHBAddr = SMCTrMEMR_3 + Offset; break;
    case 4 : AHBAddr = SMCTrMEMR_4 + Offset; break;
    case 5 : AHBAddr = SMCTrMEMR_5 + Offset; break;
    case 6 : AHBAddr = SMCTrMEMR_6 + Offset; break;
    case 7 : AHBAddr = SMCTrMEMR_7 + Offset; break;
  }

  BlockSize--;
  HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , StartData++);
  for (i=0; i<BlockSize; i++)
    HSW( , StartData++);

}

void SMCReadMem(int BankNo, int32 Offset, int Burst, char hsize,
                int32 StartData)
{
  /*
     Summary: Read from the Memory through SMC
     =========================================
     This performs performs the following :

     o  Reads from the Memory bank 'BankNo' through the SMC.
     o  Starts from 'Offset' away from the Base Address.
  */
     
  int i, BeatsNo;
  int32 MemAddr;
  char* beat[8] = {"sin", "inc", "in4", "in8", "in16", "wr4", "wr8", "w16"};

  switch(Burst)
  {
    case 0 : BeatsNo = 0;  break;
    case 1 : BeatsNo = 0;  break;
    case 2 : BeatsNo = 3;  break;
    case 3 : BeatsNo = 7;  break;
    case 4 : BeatsNo = 15; break;
    case 5 : BeatsNo = 3;  break;
    case 6 : BeatsNo = 8;  break;
    case 7 : BeatsNo = 15; break;
  }
  switch(BankNo)
  {
    case 0 : MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11) + Offset; break;
    case 1 : MemAddr = SMCMEM_1 + (SMCTrMEMBData[1] << 11) + Offset; break;
    case 2 : MemAddr = SMCMEM_2 + (SMCTrMEMBData[2] << 11) + Offset; break;
    case 3 : MemAddr = SMCMEM_3 + (SMCTrMEMBData[3] << 11) + Offset; break;
    case 4 : MemAddr = SMCMEM_4 + (SMCTrMEMBData[4] << 11) + Offset; break;
    case 5 : MemAddr = SMCMEM_5 + (SMCTrMEMBData[5] << 11) + Offset; break;
    case 6 : MemAddr = SMCMEM_6 + (SMCTrMEMBData[6] << 11) + Offset; break;
    case 7 : MemAddr = SMCMEM_7 + (SMCTrMEMBData[7] << 11) + Offset; break;
  }

  HSA(MemAddr, NSEQ, beat[Burst], , hsize, , 0x1, , , , ,);
  HSR( , StartData++, , NoMask, , SMCReadMem_1);

}

void ToggleSMCS()
{
  /*
     Summary: Toggle SMCS line of the SMC
     ====================================
     This performs performs the following :

     o  Writes to addresses whose HADDR[28:26] only change
     o  Reads from the AHB side of the Memory and verifies the written data
  */
     
  int i, j, k;
  int32 MemAddr, TestData, BankBase;
  int32 TestWrite[3] = {0x11111111, 0x55555555, 0xAAAAAAAA};
  int32 Offset[3] = {0x00000000, 0x0000000C, 0x000000FC};

  for (i=0; i<3; i++)
  {
    TestData = TestWrite[i];
    for (j=0; j<8; j++)
    {
      switch (j)
      {
        case 0 : BankBase = SMCMEM_0; break;
        case 1 : BankBase = SMCMEM_1; break;
        case 2 : BankBase = SMCMEM_2; break;
        case 3 : BankBase = SMCMEM_3; break;
        case 4 : BankBase = SMCMEM_4; break;
        case 5 : BankBase = SMCMEM_5; break;
        case 6 : BankBase = SMCMEM_6; break;
        case 7 : BankBase = SMCMEM_7; break;
      }
      MemAddr = BankBase + (SMCTrMEMBData[j] << 11) + Offset[i];
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
    }

    /** Verifying the written data from the AHB side **/
    TestData = TestWrite[i];
    for (j=0; j<8; j++)
    {
      switch (j)
      {
        case 0 : BankBase = SMCTrMEMR_0; break;
        case 1 : BankBase = SMCTrMEMR_1; break;
        case 2 : BankBase = SMCTrMEMR_2; break;
        case 3 : BankBase = SMCTrMEMR_3; break;
        case 4 : BankBase = SMCTrMEMR_4; break;
        case 5 : BankBase = SMCTrMEMR_5; break;
        case 6 : BankBase = SMCTrMEMR_6; break;
        case 7 : BankBase = SMCTrMEMR_7; break;
      }
      MemAddr = BankBase + Offset[i];
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSR( , TestData++, , NoMask, ,ToggleSMCS_1);
    }
  }
}

void ReadStatus(int BankNo, int32 StatValue)
{
  /*
     Summary: Read the Status of the SMC
     ===================================
     This performs the following :

     o  Reads from the Status registers of the SMC
     o  Expecting the 'StatValue' from the Bank 'BankNo'
     o  From the other banks, expecting 0s
     o  Clears the Status Registers
  */
     
  int i;
  int32 BSRAddr;

  for (i=0; i<8; i++)
  {
    switch(i)
    {
      case 0 : BSRAddr = SMBSR0; break;
      case 1 : BSRAddr = SMBSR1; break;
      case 2 : BSRAddr = SMBSR2; break;
      case 3 : BSRAddr = SMBSR3; break;
      case 4 : BSRAddr = SMBSR4; break;
      case 5 : BSRAddr = SMBSR5; break;
      case 6 : BSRAddr = SMBSR6; break;
      case 7 : BSRAddr = SMBSR7; break;
    }

    if (i == BankNo)
    {
      HSA(BSRAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSR( , StatValue, , NoMask, ,ReadStatus_1);

    } else
    {
      HSA(BSRAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSR( , ZERO, , NoMask, ,ReadStatus_2);
    }
  }
}

void ClrStatus(int BankNo)
{
  /*
     Summary: Clear the Status of the SMC
     ===================================
     This performs the following :

     o  Clears the Status Registers
  */
     
  int i;
  int32 BSRAddr;

  for (i=0; i<8; i++)
  {
    switch(i)
    {
      case 0 : BSRAddr = SMBSR0; break;
      case 1 : BSRAddr = SMBSR1; break;
      case 2 : BSRAddr = SMBSR2; break;
      case 3 : BSRAddr = SMBSR3; break;
      case 4 : BSRAddr = SMBSR4; break;
      case 5 : BSRAddr = SMBSR5; break;
      case 6 : BSRAddr = SMBSR6; break;
      case 7 : BSRAddr = SMBSR7; break;
    }

    if (i == BankNo)
    {
      /** Clear the BSR **/
      HSA(BSRAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSW( , 0x00000007);

      HSA(BSRAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
      HSR( , ZERO, , NoMask, ,ReadStatus_3);
    }
  }
}

void ReadEWS(int32 EWSValue)
{
  /*
     Summary: Read the External Wait Error Status of the SMC
     =======================================================
     This performs the following :

     o  Reads from the SMBEWS Status register of the SMC
     o  Polls for the 'EWSValue'
  */
     
  WaitLoop(1);
  HSA(SMBEWS, NSEQ, SINGLE, , WRD, , 0x0, , , , ,);
  HPO( , EWSValue, , NoMask, , 0xFF,EWSStatus_1);

}

void MemWriteRead(int BankNo, int Burst, int32 Offset, int hsize, int msize,
                     int32 Data)
{
  /*
     Summary: Memory Write-Read
     ==========================
     This performs performs the following:

     o  Writes to a Memory location through the SMC and verifies through
        the SMC.
  */

  int32 MemAddr, TempData, TestData, ReadMask;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "in16", "wr4", "wr8", "w16"};
  int Shift[3] = {8, 16, 32};
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int i, j, BeatsNo;

  switch(BankNo)
  {
    case 0 : MemAddr = SMCMEM_0 + Offset; break;
    case 1 : MemAddr = SMCMEM_1 + Offset; break;
    case 2 : MemAddr = SMCMEM_2 + Offset; break;
    case 3 : MemAddr = SMCMEM_3 + Offset; break;
    case 4 : MemAddr = SMCMEM_4 + Offset; break;
    case 5 : MemAddr = SMCMEM_5 + Offset; break;
    case 6 : MemAddr = SMCMEM_6 + Offset; break;
    case 7 : MemAddr = SMCMEM_7 + Offset; break;
  }

  switch(Burst)
  {
    case 0 : BeatsNo = 1;  break;
    case 1 : BeatsNo = 1;  break;
    case 2 : BeatsNo = 4;  break;
    case 3 : BeatsNo = 8;  break;
    case 4 : BeatsNo = 16; break;
    case 5 : BeatsNo = 4;  break;
    case 6 : BeatsNo = 8;  break;
    case 7 : BeatsNo = 16; break;
  }

  /** Writing via SMC **/
  TempData = Data;
  j = MemAddr & 0x3;
  if (ENDIANNESS == 0)
  {
    TestData = TempData & UnMask[hsize];
  } else
  {
    TestData = (TempData << (3-j%4)*Shift[hsize]) &
               (UnMask[hsize] << (3-j%4)*Shift[hsize]);
  }

  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
  HSW( , TestData);
  for (i = 1, j++, TempData++; i < BeatsNo; i++, j++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      TestData = TempData & UnMask[hsize];
    } else
    {
      TestData = (TempData << (3-j%4)*Shift[hsize]) &
                 (UnMask[hsize] << (3-j%4)*Shift[hsize]);
    }
    HSW( , TestData);
  }

  /** Reading via SMC **/
  TempData = Data;
  j = (MemAddr & 0x3) >> hsize;
  if (ENDIANNESS == 0)
  {
    ReadMask = UnMask[hsize] << j*Shift[hsize];
    TestData = (TempData << j*Shift[hsize]) & ReadMask;
  } else
  {
    ReadMask = (UnMask[hsize] << (3-j%4)*Shift[hsize]);
    TestData = (TempData << (3-j%4)*Shift[hsize]) & ReadMask;
  }

  HSA(MemAddr, NSEQ, beat[Burst], , size[hsize], , 0x1, , , , ,);
  HSR( , TestData, , ReadMask, ,MemWriteRead_1);
  for (i = 1, j++, TempData++; i < BeatsNo; i++, j++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      ReadMask = (UnMask[hsize] << j*Shift[hsize]);
      TestData = (TempData << j*Shift[hsize]) & ReadMask;
    } else
    {
      ReadMask = (UnMask[hsize] << (3-j%4)*Shift[hsize]);
      TestData = (TempData << (3-j%4)*Shift[hsize]) & ReadMask;
    }
    HSR( , TestData, , ReadMask, ,MemWriteRead_2);
  }
}

void ToggleREMAP(int32 Bank0Data, int32 Bank7Data)
{
  /*
     Summary: Toggle REMAP
     =====================
     This performs performs the following:

     o  Tests the performance of the SMC by toggling the REMAP signal
  */

  int i, SMMWCS;
  int32 MemAddr, TestData, TestWrite, TempData, ReadMask;
  int Shift[3] = {8, 16, 32};
  char string[35];
  char size[3] = {'b', 'h', 'w'};
  char* SizeString[3] = {"BYTE", "HALFWORD", "WORD"};
  int32 Mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};

  HSA(SMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ENDIANNESS);

  /** Initialise Bank 0 **/
  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11);
  TestWrite = Bank0Data & Mask[0];
  TempData = TestWrite;
  if (ENDIANNESS == 0)
  {
    TestData = TempData & Mask[0];
  } else
  {
    TestData = (TempData << 3*Shift[0]) &
               (Mask[0] << 3*Shift[0]);
  }
  HSA(MemAddr, NSEQ, INCR, , size[0], , 0x1, , , , ,);
  HSW( , TestData);
  for (i=1, TempData++; i<16; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      TestData = TempData & Mask[0];
    } else
    {
      TestData = (TempData << (3-i%4)*Shift[0]) &
                 (Mask[0] << (3-i%4)*Shift[0]);
    }
    HSW( , TestData);
  }
    
  SMMWCS = 0;
  /** Configure SMMWCS7 input **/
  sprintf(string, "SMMWCS7 is configured as %s", SizeString[SMMWCS]);
  C(string);
  HSA(SMCTrMWCS, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMMWCS);

  /** Clear the REMAP input **/
  C("Clearing REMAP input");
  HSA(SMCTrREMAP, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x0);

  WaitLoop(3);

  /** Apply Reset **/
  C("Applying RESET");
  RES(LOW, , 1);

  WaitLoop(1);

  HSA(SMCTrEndian, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , ENDIANNESS);

  /** Write into Bank 0 **/
  /** Since Bank 7 is shadowed onto Bank 0, Bank 7 will get written into **/
  MemAddr = SMCMEM_0 + (SMCTrMEMBData[0] << 11);
  TestWrite = Bank7Data;
  TempData = TestWrite;
  if (ENDIANNESS == 0)
  {
    TestData = TempData & Mask[SMMWCS];
  } else
  {
    TestData = (TempData << 3*Shift[SMMWCS]) &
               (Mask[SMMWCS] << 3*Shift[SMMWCS]);
  }
  HSA(MemAddr, NSEQ, INCR, , size[SMMWCS], , 0x1, , , , ,);
  HSW( , TestData);
  for (i=1, TempData++; i<16; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      TestData = TempData & Mask[SMMWCS];
    } else
    {
      TestData = (TempData << (3-i%4)*Shift[SMMWCS]) &
                 (Mask[SMMWCS] << (3-i%4)*Shift[SMMWCS]);
    }
    HSW( , TestData);
  }
    
  /** Read from Bank 0 **/
  /** Since Bank 7 is shadowed onto Bank 0, Bank 7 data will be read out **/
  TempData = TestWrite & Mask[SMMWCS];
  if (ENDIANNESS == 0)
  {
    ReadMask = Mask[SMMWCS];
    TestData = TempData & ReadMask;
  } else
  {
    ReadMask = Mask[SMMWCS] << 3*Shift[SMMWCS];
    TestData = (TempData << 3*Shift[SMMWCS]) & ReadMask;
  }
  HSA(MemAddr, NSEQ, INCR, , size[SMMWCS], , 0x1, , , , ,);
  HSR( , TestData, , ReadMask, ,ToggleREMAP_1);
  for (i=1, TempData++; i<16; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      ReadMask = (Mask[SMMWCS] << i*Shift[SMMWCS]);
      TestData = (TempData << i*Shift[SMMWCS]) & ReadMask;
    } else
    {
      ReadMask = (Mask[SMMWCS] << (3-i%4)*Shift[SMMWCS]);
      TestData = (TempData << (3-i%4)*Shift[SMMWCS]) & ReadMask;
    }
    HSR( , TestData, , ReadMask, ,ToggleREMAP_2);
  }

  /** Set the REMAP input **/
  C("Setting REMAP input");
  HSA(SMCTrREMAP, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x1);

  HSA(SMBCR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x0);

  /** Read Bank 0 for unmodified data **/
  TempData = Bank0Data & Mask[0];
  if (ENDIANNESS == 0)
  {
    ReadMask = Mask[0];
    TestData = TempData & ReadMask;
  } else
  {
    ReadMask = Mask[0] << 3*Shift[0];
    TestData = (TempData << 3*Shift[0]) & ReadMask;
  }
  HSA(MemAddr, NSEQ, INCR, , size[0], , 0x1, , , , ,);
  HSR( , TestData, , ReadMask, ,ToggleREMAP_3);
  for (i=1, TempData++; i<16; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      ReadMask = (Mask[0] << i*Shift[0]);
      TestData = (TempData << i*Shift[0]) & ReadMask;
    } else
    {
      ReadMask = (Mask[0] << (3-i%4)*Shift[0]);
      TestData = (TempData << (3-i%4)*Shift[0]) & ReadMask;
    }
    HSR( , TestData, , ReadMask, ,ToggleREMAP_4);
  }

  HSA(SMBCR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x0);
  /** Read Bank 7 for modified data **/
  MemAddr = SMCMEM_7 + (SMCTrMEMBData[7] << 11);
  TempData = TestWrite;
  if (ENDIANNESS == 0)
  {
    ReadMask = Mask[SMMWCS];
    TestData = TempData & ReadMask;
  } else
  {
    ReadMask = Mask[SMMWCS] << 3*Shift[SMMWCS];
    TestData = (TempData << 3*Shift[SMMWCS]) & ReadMask;
  }
  HSA(MemAddr, NSEQ, INCR, , size[SMMWCS], , 0x1, , , , ,);
  HSR( , TestData, , ReadMask, ,ToggleREMAP_5);
  for (i=1, TempData++; i<16; i++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      ReadMask = (Mask[SMMWCS] << i*Shift[SMMWCS]);
      TestData = (TempData << i*Shift[SMMWCS]) & ReadMask;
    } else
    {
      ReadMask = (Mask[SMMWCS] << (3-i%4)*Shift[SMMWCS]);
      TestData = (TempData << (3-i%4)*Shift[SMMWCS]) & ReadMask;
    }
    HSR( , TestData, , ReadMask, ,ToggleREMAP_6);
  }
}

void ROMWriteRead(int BankNo, int Burst, int32 Offset, int hsize, int msize,
                     int32 WriteData, int32 ReadData)
{
  /*
     Summary: ROM Write-Read
     ==========================
     This performs performs the following:

     o  Writes into a ROM through the SMC expecting ERROR response
        and verifies through the SMC for the unmodified data.
  */

  int32 MemAddr, TempData, TestData, ReadMask;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "in16", "wr4", "wr8", "w16"};
  int Shift[3] = {8, 16, 32};
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int i, j, BeatsNo;

  switch(BankNo)
  {
    case 0 : MemAddr = SMCMEM_0 + Offset; break;
    case 1 : MemAddr = SMCMEM_1 + Offset; break;
    case 2 : MemAddr = SMCMEM_2 + Offset; break;
    case 3 : MemAddr = SMCMEM_3 + Offset; break;
    case 4 : MemAddr = SMCMEM_4 + Offset; break;
    case 5 : MemAddr = SMCMEM_5 + Offset; break;
    case 6 : MemAddr = SMCMEM_6 + Offset; break;
    case 7 : MemAddr = SMCMEM_7 + Offset; break;
  }

  switch(Burst)
  {
    case 0 : BeatsNo = 1;  break;
    case 1 : BeatsNo = 1;  break;
    case 2 : BeatsNo = 4;  break;
    case 3 : BeatsNo = 8;  break;
    case 4 : BeatsNo = 16; break;
    case 5 : BeatsNo = 4;  break;
    case 6 : BeatsNo = 8;  break;
    case 7 : BeatsNo = 16; break;
  }

  /** Writing via SMC **/
  TempData = WriteData;
  j = MemAddr & 0x3;
  if (ENDIANNESS == 0)
  {
    TestData = TempData & UnMask[hsize];
  } else
  {
    TestData = (TempData << (3-j%4)*Shift[hsize]) &
               (UnMask[hsize] << (3-j%4)*Shift[hsize]);
  }

  HSA(MemAddr, NSEQ, beat[Burst], ERROR, size[hsize], , 0x1, , , , ,);
  HSW( , TestData);
  for (i = 1, j++, TempData++; i < BeatsNo; i++, j++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      TestData = TempData & UnMask[hsize];
    } else
    {
      TestData = (TempData << (3-j%4)*Shift[hsize]) &
                 (UnMask[hsize] << (3-j%4)*Shift[hsize]);
    }
    HSW( , TestData);
  }

  ReadStatus(BankNo, 0x2);

  ClrStatus(BankNo);

  /** Reading via SMC **/
  TempData = ReadData;
  j = (MemAddr & 0x3) >> msize;
  if (ENDIANNESS == 0)
  {
    ReadMask = UnMask[msize] << j*Shift[msize];
    TestData = (TempData << j*Shift[msize]) & ReadMask;
  } else
  {
    ReadMask = (UnMask[msize] << (3-j%4)*Shift[msize]);
    TestData = (TempData << (3-j%4)*Shift[msize]) & ReadMask;
  }

  HSA(MemAddr, NSEQ, beat[Burst], , size[msize], , 0x1, , , , ,);
  HSR( , TestData, , ReadMask, ,ROMWriteRead_1);
  for (i = 1, j++, TempData++; i < BeatsNo; i++, j++, TempData++)
  {
    if (ENDIANNESS == 0)
    {
      ReadMask = (UnMask[msize] << j*Shift[msize]);
      TestData = (TempData << j*Shift[msize]) & ReadMask;
    } else
    {
      ReadMask = (UnMask[msize] << (3-j%4)*Shift[msize]);
      TestData = (TempData << (3-j%4)*Shift[msize]) & ReadMask;
    }
    HSR( , TestData, , ReadMask, ,ROMWriteRead_2);
  }
}

/************************************ End *************************************/
