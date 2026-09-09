/* --=========================================================================--
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2003 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
-- -----------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : ResetTests.c.rca
--  File Revision          : 1.9
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
--  
-- -----------------------------------------------------------------------------
-- Purpose :
--           Routines to perform Reset Tests on the SSMC.
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

  char Message[100];

  /** Performing Reset Tests on IDLE Cycles Control Registers **/
  C("RESETTESTS ON SMBIDCYRx REGISTERS");
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

  
/** Performing Reset Tests on Read Wait State Control Registers **/
  C("RESETTESTS ON SMBWSTRDRx  REGISTERS");
  HSA(SMBWSTRDR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTRDR, , NoMask, ,ResetTests_10);

  HSA(SMBWSTRDR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTRDR, , NoMask, ,ResetTests_11);

  HSA(SMBWSTRDR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTRDR, , NoMask, ,ResetTests_12);

  HSA(SMBWSTRDR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTRDR, , NoMask, ,ResetTests_13);

  HSA(SMBWSTRDR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTRDR, , NoMask, ,ResetTests_14);

  HSA(SMBWSTRDR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTRDR, , NoMask, ,ResetTests_15);

  HSA(SMBWSTRDR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTRDR, , NoMask, ,ResetTests_16);

  HSA(SMBWSTRDR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTRDR, , NoMask, ,ResetTests_17);

  HSA(SMBWSTRDR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTRDR, , NoMask, ,ResetTests_18);


  /** Performing Reset Tests on Write Wait State Control Registers **/
  C("RESETTESTS ON SMBWSTWRRx REGISTERS");
  HSA(SMBWSTWRR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWRR, , NoMask, ,ResetTests_19);

  HSA(SMBWSTWRR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWRR, , NoMask, ,ResetTests_20);

  HSA(SMBWSTWRR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWRR, , NoMask, ,ResetTests_21);

  HSA(SMBWSTWRR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWRR, , NoMask, ,ResetTests_22);

  HSA(SMBWSTWRR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWRR, , NoMask, ,ResetTests_23);

  HSA(SMBWSTWRR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWRR, , NoMask, ,ResetTests_24);

  HSA(SMBWSTWRR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWRR, , NoMask, ,ResetTests_25);

  HSA(SMBWSTWRR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWRR, , NoMask, ,ResetTests_26);

  HSA(SMBWSTWRR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTWRR, , NoMask, ,ResetTests_27);


  /** Performing Reset Tests on Output Enable Assertion Delay Control **/
  /** Registers **/
  C("RESETTESTS ON SMBWSTOENRx REGISTERS");
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
  C("RESETTESTS ON SMBWSTWENRx REGISTERS");
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
  C("RESETTESTS ON SMBCRx REGISTERS");
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
  C("RESETTESTS ON SMBSRx REGISTERS");
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


  /** Performing Reset Tests on Burst Read Wait State Control Registers **/
  C("RESETTESTS ON SMBWSTBRDRx  REGISTERS");
  HSA(SMBWSTBRDR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTBRDR, , NoMask, ,ResetTests_62);

  HSA(SMBWSTBRDR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTBRDR, , NoMask, ,ResetTests_63);
  
  HSA(SMBWSTBRDR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTBRDR, , NoMask, ,ResetTests_64);

  HSA(SMBWSTBRDR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTBRDR, , NoMask, ,ResetTests_65);

  HSA(SMBWSTBRDR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTBRDR, , NoMask, ,ResetTests_66);

  HSA(SMBWSTBRDR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTBRDR, , NoMask, ,ResetTests_67);

  HSA(SMBWSTBRDR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTBRDR, , NoMask, ,ResetTests_68);

  HSA(SMBWSTBRDR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTBRDR, , NoMask, ,ResetTests_69);  
 
  HSA(SMBWSTBRDR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBWSTBRDR, , NoMask, ,ResetTests_70);

  /** Performing Reset Tests on  Control Register bit **/
  C("RESETTESTS ON SSMCCR REGISTER");
  HSA(SSMCCR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCCR, , 0x00000006, ,ResetTests_71);

  /** Performing Reset Tests on SSMC Test Control Register bit **/
  C("RESETTESTS ON SSMCITCR REGISTER");
  HSA(SSMCITCR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCITCR, , NoMask, ,ResetTests_72);

  /** Performing Reset Tests on Read Only Registers **/
  C("RESETTESTS ON READ ONLY REGISTERS");
  
  /** Performing Reset Tests on  External Wait Status Register bit **/
  C("RESETTESTS ON SSMCSR REGISTER");
  HSA(SSMCSR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCSR, , NoMask, ,ResetTests_73);
  
  C("RESETTESTS ON SSMCPeriphID0 REGISTER");
  HSA(SSMCPeriphID0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCPeriphID0, , NoMask, ,ResetTests_74);

  C("RESETTESTS ON SSMCPeriphID1 REGISTER");
  HSA(SSMCPeriphID1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCPeriphID1, , NoMask, ,ResetTests_75);

  C("RESETTESTS ON SSMCPeriphID2 REGISTER");
  HSA(SSMCPeriphID2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCPeriphID2, , NoMask, ,ResetTests_76);

  C("RESETTESTS ON SSMCPeriphID3 REGISTER");
  HSA(SSMCPeriphID3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCPeriphID3, , NoMask, ,ResetTests_77);

  C("RESETTESTS ON SSMCPCellID0 REGISTER");
  HSA(SSMCPCellID0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCPCellID0, , NoMask, ,ResetTests_78);

  C("RESETTESTS ON SSMCPCellID1 REGISTER");
  HSA(SSMCPCellID1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCPCellID1, , NoMask, ,ResetTests_79);

  C("RESETTESTS ON SSMCPCellID2 REGISTER");
  HSA(SSMCPCellID2, NSEQ, INCR, , WRD, , 0x1, , , , );
  HSR( , RST_SSMCPCellID2, , NoMask, ,ResetTests_80);

  C("RESETTESTS ON SSMCPCellID3 REGISTER");
  HSA(SSMCPCellID3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCPCellID3, , NoMask, ,ResetTests_81);
}

/************************************ End *************************************/
