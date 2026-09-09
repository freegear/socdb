/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000-2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : ResetTests.c.rca
--  File Revision          : 1.17
--
--  Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Reset Tests on the SMC.
--
-- --=========================================================================*/

/******************************************************************************/
/********************************* Reset Tests ********************************/
/******************************************************************************/

void ResetTests()
{
  /*
     Summary: Reset Tests
     ====================
     This function performs the following:

     o  All the Registers are read and their reset values are checked.
  */

  /** Performing Reset Tests on IDLE Cycles Control Registers **/
  C("Performing Reset Tests on IDCY Registers");
  HSA(SMBIDCYR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBIDCYR, , NoMask, ,ResetTests_1);

  HSA(SMBIDCYR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBIDCYR, , NoMask, ,ResetTests_2);

  HSA(SMBIDCYR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBIDCYR, , NoMask, ,ResetTests_3);

  HSA(SMBIDCYR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBIDCYR, , NoMask, ,ResetTests_4);

  HSA(SMBIDCYR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBIDCYR, , NoMask, ,ResetTests_5);

  HSA(SMBIDCYR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBIDCYR, , NoMask, ,ResetTests_6);

  HSA(SMBIDCYR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBIDCYR, , NoMask, ,ResetTests_7);

  HSA(SMBIDCYR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBIDCYR, , NoMask, ,ResetTests_8);

  HSA(SMBIDCYR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBIDCYR, , NoMask, ,ResetTests_9);

  /** Performing Reset Tests on Wait State 1 Control Registers **/
  C("Performing Reset Tests on WST1 Registers");
  HSA(SMBWST1R0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST1R, , NoMask, ,ResetTests_10);

  HSA(SMBWST1R1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST1R, , NoMask, ,ResetTests_11);

  HSA(SMBWST1R2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST1R, , NoMask, ,ResetTests_12);

  HSA(SMBWST1R3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST1R, , NoMask, ,ResetTests_13);

  HSA(SMBWST1R4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST1R, , NoMask, ,ResetTests_14);

  HSA(SMBWST1R5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST1R, , NoMask, ,ResetTests_15);

  HSA(SMBWST1R6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST1R, , NoMask, ,ResetTests_16);

  HSA(SMBWST1R7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST1R, , NoMask, ,ResetTests_17);

  HSA(SMBWST1R0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST1R, , NoMask, ,ResetTests_18);

  /** Performing Reset Tests on Wait State 2 Control Registers **/
  C("Performing Reset Tests on WST2 Registers");
  HSA(SMBWST2R0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST2R, , NoMask, ,ResetTests_19);

  HSA(SMBWST2R1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST2R, , NoMask, ,ResetTests_20);

  HSA(SMBWST2R2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST2R, , NoMask, ,ResetTests_21);

  HSA(SMBWST2R3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST2R, , NoMask, ,ResetTests_22);

  HSA(SMBWST2R4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST2R, , NoMask, ,ResetTests_23);

  HSA(SMBWST2R5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST2R, , NoMask, ,ResetTests_24);

  HSA(SMBWST2R6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST2R, , NoMask, ,ResetTests_25);

  HSA(SMBWST2R7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST2R, , NoMask, ,ResetTests_26);

  HSA(SMBWST2R0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWST2R, , NoMask, ,ResetTests_27);

  /** Performing Reset Tests on Output Enable Assertion Delay Control **/
  /** Registers **/
  C("Performing Reset Tests on WSTOEN Registers");
  HSA(SMBWSTOENR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTOENR, , NoMask, ,ResetTests_28);

  HSA(SMBWSTOENR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTOENR, , NoMask, ,ResetTests_29);

  HSA(SMBWSTOENR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTOENR, , NoMask, ,ResetTests_30);

  HSA(SMBWSTOENR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTOENR, , NoMask, ,ResetTests_31);

  HSA(SMBWSTOENR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTOENR, , NoMask, ,ResetTests_32);

  HSA(SMBWSTOENR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTOENR, , NoMask, ,ResetTests_33);

  HSA(SMBWSTOENR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTOENR, , NoMask, ,ResetTests_34);

  HSA(SMBWSTOENR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTOENR, , NoMask, ,ResetTests_35);

  HSA(SMBWSTOENR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTOENR, , NoMask, ,ResetTests_36);

  /** Performing Reset Tests on Write Enable Assertion Delay Control **/
  /** Registers **/
  C("Performing Reset Tests on WSTWEN Registers");
  HSA(SMBWSTWENR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWENR, , NoMask, ,ResetTests_37);

  HSA(SMBWSTWENR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWENR, , NoMask, ,ResetTests_38);

  HSA(SMBWSTWENR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWENR, , NoMask, ,ResetTests_39);

  HSA(SMBWSTWENR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWENR, , NoMask, ,ResetTests_40);

  HSA(SMBWSTWENR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWENR, , NoMask, ,ResetTests_41);

  HSA(SMBWSTWENR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWENR, , NoMask, ,ResetTests_42);

  HSA(SMBWSTWENR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWENR, , NoMask, ,ResetTests_43);

  HSA(SMBWSTWENR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWENR, , NoMask, ,ResetTests_44);

  HSA(SMBWSTWENR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWENR, , NoMask, ,ResetTests_45);

  /** Performing Reset Tests on Control Registers **/
  C("Performing Reset Tests on BCR Registers");
  HSA(SMBCR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBCR0, , NoMask, ,ResetTests_46);

  HSA(SMBCR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBCR1, , NoMask, ,ResetTests_47);

  HSA(SMBCR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBCR2, , NoMask, ,ResetTests_48);

  HSA(SMBCR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBCR3, , NoMask, ,ResetTests_49);

  HSA(SMBCR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBCR4, , NoMask, ,ResetTests_50);

  HSA(SMBCR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBCR5, , NoMask, ,ResetTests_51);

  HSA(SMBCR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBCR6, , NoMask, ,ResetTests_52);

  HSA(SMBCR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBCR7, , NoMask, ,ResetTests_53);

  /** Performing Reset Tests on Status Registers **/
  C("Performing Reset Tests on BSR Registers");
  HSA(SMBSR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR0, , NoMask, ,ResetTests_54);

  HSA(SMBSR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR1, , NoMask, ,ResetTests_55);

  HSA(SMBSR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR2, , NoMask, ,ResetTests_56);

  HSA(SMBSR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR3, , NoMask, ,ResetTests_57);

  HSA(SMBSR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR4, , NoMask, ,ResetTests_58);

  HSA(SMBSR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR5, , NoMask, ,ResetTests_59);

  HSA(SMBSR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR6, , NoMask, ,ResetTests_60);

  HSA(SMBSR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR7, , NoMask, ,ResetTests_61);

  /** Performing Reset Tests on RO External Wait Status Register bit **/
  HSA(SMBEWS, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBEWS, , NoMask, ,ResetTests_61A);

  /** Performing Reset Tests on Read Only Registers **/
  C("Performing Reset Tests on Read Only Registers");
  HSA(SMCPeriphID0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMCPeriphID0, , NoMask, ,ResetTests_62);

  HSA(SMCPeriphID1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMCPeriphID1, , NoMask, ,ResetTests_63);

  HSA(SMCPeriphID2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMCPeriphID2, , NoMask, ,ResetTests_64);

  HSA(SMCPeriphID3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMCPeriphID3, , NoMask, ,ResetTests_65);

  HSA(SMCPCellID0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMCPCellID0, , NoMask, ,ResetTests_66);

  HSA(SMCPCellID1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMCPCellID1, , NoMask, ,ResetTests_67);

  HSA(SMCPCellID2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMCPCellID2, , NoMask, ,ResetTests_68);

  HSA(SMCPCellID3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMCPCellID3, , NoMask, ,ResetTests_69);

  /** Reading an address other than the functional registers returns '0's **/
  HSA(SMCCR_BASE + 0xE4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , ZERO, , NoMask, ,ResetTests_69);
}

/************************************ End *************************************/
