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
--  File Name              : SsmcCommon.c.rca
--  File Revision          : 1.9
--
--  Release Information    : PrimeCell(TM)-PL093-r0p3-00rel0
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

int32 SSMCTrMEMBData[8] = {0x0000, 0x0000, 0x0000, 0x0000,
                          0x0000, 0x0000, 0x0000, 0x0000};

int32 SMBCRData[8] = {0x00000,0x00000,0x00000,0x00000,0x00000,
                          0x00000,0x00000,0x00000};

int32 SSMCTrCS2WTRData[8] = {0x0000, 0x0000, 0x0000, 0x0000,
                          0x0000, 0x0000, 0x0000, 0x0000};

int32 SSMCCRDATA, SMMEMCLKRATIODATA, SSMCTrBurstWTData;

int ENDIANNESS;

char Message[100];

char report[100];


/******************************************************************************/
/***************************** Common Functions *******************************/
/******************************************************************************/
void msg_info(char *message)
{
  /* Summary:
     ========
     If the constant INFO is set to '1' in Dmac.h file, this will print
     informative messages during testing.
  */
  if (INFO == 1)
    C(message);
}


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
    HSA(SSMCTrExtMux, IDLE, INCR, , WRD); /** Addr has to be changed to ZERO **/
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
  
  int32 RdData, WrData, MemAddr;

  /** PERFORMING WRITE-READ TESTS ON IDLE CYCLE CONTROL REGISTERS **/
  sprintf(Message,"PERFORMING WRITE-READ TESTS ON SMBIDCYRx REGISTERS");
  msg_info(Message);
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

  /** PERFORMING WRITE-READ TESTS ON READ WAIT STATE CONTROL REGISTERS **/
  sprintf(Message,"PERFORMING WRITE-READ TESTS ON SMBWSTRDRx REGISTERS");
  msg_info(Message);  
  RdData = TestData & 0x0000001F;
  HSA(SMBWSTRDR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTRDR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_9);

  HSA(SMBWSTRDR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTRDR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_10);

  HSA(SMBWSTRDR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTRDR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_11);

  HSA(SMBWSTRDR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTRDR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_12);

  HSA(SMBWSTRDR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTRDR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_13);

  HSA(SMBWSTRDR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTRDR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_14);

  HSA(SMBWSTRDR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTRDR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_15);

  HSA(SMBWSTRDR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTRDR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_16);

  /** PERFORMING WRITE-READ TESTS ON WRITE  WAIT STATE CONTROL REGISTERS **/
  sprintf(Message,"PERFORMING WRITE-READ TESTS ON SMBWSTWRRx REGISTERS");
  msg_info(Message);  
  RdData = TestData & 0x0000001F;
  HSA(SMBWSTWRR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTWRR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_17);

  HSA(SMBWSTWRR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTWRR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_18);

  HSA(SMBWSTWRR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTWRR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_19);

  HSA(SMBWSTWRR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTWRR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_20);

  HSA(SMBWSTWRR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTWRR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_21);

  HSA(SMBWSTWRR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTWRR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_22);

  HSA(SMBWSTWRR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTWRR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_23);

  HSA(SMBWSTWRR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTWRR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_24);

  /** PERFORMING WRITE-READ TESTS ON OUTPUT ENABLE ASSERTION DELAY CONTROL
      Registers **/
  sprintf(Message,"PERFORMING WRITE-READ TESTS ON SMBWSTOENRx REGISTERS");
  msg_info(Message);  
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

  /** PERFORMING WRITE-READ TESTS ON WrITE ENABLE DELAY ASSERTION CONTROL
      REGISTERS **/
  sprintf(Message,"PERFORMING WRITE-READ TESTS ON SMBWSTWENRx REGISTERS");
  msg_info(Message);  
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

  /** PERFORMING WRITE-READ TESTS ON CONTROL REGISTERS **/
  sprintf(Message,"PERFORMING WRITE-READ TESTS ON SMBCR REGISTERS");
  msg_info(Message);  
  RdData = TestData & 0x003F7F7F;
  WrData = TestData & 0x003F7F7F;
  HSA(SMBCR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , WrData);
  HSA(SMBCR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_41);

  HSA(SMBCR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , WrData);
  HSA(SMBCR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_42);

  HSA(SMBCR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , WrData);
  HSA(SMBCR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_43);

  HSA(SMBCR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , WrData);
  HSA(SMBCR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_44);

  HSA(SMBCR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , WrData);
  HSA(SMBCR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_45);

  HSA(SMBCR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , WrData);
  HSA(SMBCR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_46);

  HSA(SMBCR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , WrData);
  HSA(SMBCR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_47);

  HSA(SMBCR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , WrData);
  HSA(SMBCR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_48);

  /** PERFORMING WRITE-READ TESTS ON STATUS REGISTERS **/
  sprintf(Message,"PERFORMING WRITE-READ TESTS ON SMBSRx REGISTERS");
  msg_info(Message);  
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

  
  /** PERFORMING WRITE-READ TESTS ON BURSTREAD WAIT STATE CONTROL REGISTERS **/
  sprintf(Message,"PERFORMING WRITE-READ TESTS ON SMBWSTBRDRx REGISTERS");
  msg_info(Message);  
  RdData = TestData & 0x0000001F;
  HSA(SMBWSTBRDR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTBRDR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_57);

  HSA(SMBWSTBRDR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTBRDR1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_58);

  HSA(SMBWSTBRDR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTBRDR2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_59);

  HSA(SMBWSTBRDR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTBRDR3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_60);

  HSA(SMBWSTBRDR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTBRDR4, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_61);

  HSA(SMBWSTBRDR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTBRDR5, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_62);

  HSA(SMBWSTBRDR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTBRDR6, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_63);

  HSA(SMBWSTBRDR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTBRDR7, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_64);

  /** PERFORMING READ TESTS ON READ ONLY SSMCSR REGISTER **/
  sprintf(Message,"PERFORMING WRITE-READ TESTS ON SSMCSR REGISTER");
  msg_info(Message);  
  HSA(SSMCSR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCSR, , NoMask, ,WriteReadTests_65);

  /** PERFORMING WRITE-READ TESTS ON READ/WRITE SSMCCR REGISTER **/
  sprintf(Message,"PERFORMING WRITE-READ TESTS ON SSMCCR REGISTER");
  msg_info(Message);  
  RdData = TestData & 0x00000007;
  HSA(SSMCCR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SSMCCR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData , , 0x00000006, ,WriteReadTests_66);

  /** PERFORMING WRITE-READ TESTS ON READ/WRITE SSMCITCR REGISTER **/
  sprintf(Message,"PERFORMING WRITE-READ TESTS ON SSMCITCR REGISTER");
  msg_info(Message);  
  RdData = TestData & 0x00000001;
  HSA(SSMCITCR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SSMCITCR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,WriteReadTests_67);

  /** PERFORMING WRITE-READ TESTS ON READ/WRITE SSMCITIP REGISTER **/
  sprintf(Message,"PERFORMING WRITE-READ TESTS ON SSMCITIP REGISTER");
  msg_info(Message); 
  HSA(SSMCITCR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x00000001);
  RdData = TestData & 0x0000007F;                       
  HSA(SSMCITIP, NSEQ, INCR, , WRD, , 0x1, , , , ,);     
  HSW( , TestData);                                     
  HSA(SSMCITIP, NSEQ, INCR, , WRD, , 0x1, , , , ,);     
  HSR( , RdData, , NoMask, ,WriteReadTests_68);         

  /** PERFORMING WRITE-READ TESTS ON READ/WRITE SSMCITOP REGISTER **/
  sprintf(Message,"PERFORMING WRITE-READ TESTS ON SSMCITOP REGISTER");
  msg_info(Message);  
  RdData = TestData & 0x00000003;                       
  HSA(SSMCITOP, NSEQ, INCR, , WRD, , 0x1, , , , ,);    
  HSW( , TestData);                                     
  HSA(SSMCITOP, NSEQ, INCR, , WRD, , 0x1, , , , ,);   
  HSR( , RdData, , NoMask, ,WriteReadTests_69);        

  HSA(SSMCITCR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , 0x00000000);

  /** PERFORMING WRITE-READ TESTS ON READ ONLY REGISTERS **/
  sprintf(Message,"PERFORMING WRITE-READ TESTS ON READ ONLY REGISTERS");
  msg_info(Message);  
  HSA(SSMCPeriphID0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SSMCPeriphID0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCPeriphID0, , NoMask, ,WriteReadTests_71);

  HSA(SSMCPeriphID1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SSMCPeriphID1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCPeriphID1, , NoMask, ,WriteReadTests_72);

  HSA(SSMCPeriphID2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SSMCPeriphID2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCPeriphID2, , NoMask, ,WriteReadTests_73);

  HSA(SSMCPeriphID3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SSMCPeriphID3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCPeriphID3, , NoMask, ,WriteReadTests_74);

  HSA(SSMCPCellID0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SSMCPCellID0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCPCellID0, , NoMask, ,WriteReadTests_75);

  HSA(SSMCPCellID1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SSMCPCellID1, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCPCellID1, , NoMask, ,WriteReadTests_76);

  HSA(SSMCPCellID2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SSMCPCellID2, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCPCellID2, , NoMask, ,WriteReadTests_77);

  HSA(SSMCPCellID3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SSMCPCellID3, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SSMCPCellID3, , NoMask, ,WriteReadTests_78);

  /** BUSERROR TEST **/
  sprintf(Message,"PERFORMING BUS E_R_R_O_R TEST ON DIFFERENT REGISTERS");
  msg_info(Message);  
  HSA(SMBIDCYR0, NSEQ, INCR, ERROR, HWRD, , 0x1, , , , ,);  
  HSW( , TestData);                                         

  HSA(SMBIDCYR0, NSEQ, INCR, ERROR, HWRD, , 0x1, , , , ,);        
  HSR( , RdData, , NoMask, ,WriteReadERRORTest_80);           

  HSA(SMBWSTRDR5, NSEQ, INCR, ERROR, BYTE, , 0x1, , , , ,);
  HSW( , 0x55555555);

  /** PERFORMING BURST ACCESSES ON BANK O **/
  sprintf(Message,"PERFORMING BURST WRITES ON BANK 0  REGISTERS");
  msg_info(Message);  
  HSA(SMBIDCYR0, NSEQ, INCR4, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSW( , TestData);
  HSW( , TestData);
  HSW( , TestData);

  HSA(SMBWSTWENR0, NSEQ, INCR4, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSW( , TestData & 0x001F1F3F);
  HSW( , TestData);
  HSW( , TestData);

  sprintf(Message,"PERFORMING BURST READS ON BANK 0 REGISTERS");
  msg_info(Message);  
  RdData = TestData & 0x0000000F;
  HSA(SMBIDCYR0, NSEQ, INCR8, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_81);
  RdData = TestData & 0x0000001F;
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_82);
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_83);
  RdData = TestData & 0x0000000F;
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_84);
  RdData = TestData & 0x0000000F;
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_85);
  RdData = TestData & 0x001F1F3F;
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_86);
  HSR( , RST_SMBSR0, , NoMask, ,BurstWriteReadTests_87);
  RdData = TestData & 0x0000001F;
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_88);

  /** Performing N-S-I-N-S-S-S-S on Bank 0 registers  **/
  sprintf(Message,"Performing N-S-I-N-S-S-S-S on Bank 0 registers");
  msg_info(Message);  
  HSA(SMBIDCYR0, NSEQ, INCR4, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSW( , TestData);
  HSA(SMBWSTWRR0, IDLE, INCR4, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSA(SMBWSTOENR0, NSEQ, INCR4, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSW( , TestData);
  HSW( , TestData & 0x001F1F3F);
  HSW( , TestData);
  
  RdData = TestData & 0x0000000F;
  HSA(SMBIDCYR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_89);

  RdData = TestData & 0x0000001F;
  HSA(SMBWSTRDR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_90);

  RdData = TestData & 0x0000000F;
  HSA(SMBWSTOENR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_91);

  RdData = TestData & 0x0000000F;
  HSA(SMBWSTWENR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_92);

  RdData = TestData & 0x001F1F3F;
  HSA(SMBCR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_93);

  HSA(SMBSR0, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , RST_SMBSR0, , NoMask, ,BurstWriteReadTests_94);

  /** Inserting BUSY in Burst Rd N-S-B-B-S-S on Bank0 registers **/
  sprintf(Message,"Performing N-S-B-B-S-S on Bank0 registers");
  msg_info(Message);  
  HSA(SMBIDCYR0, NSEQ, INCR4, , WRD, , 0x1, , , , ,);
  HSW( , TestData);
  HSW( , TestData);
  HSW( , TestData);
  HSW( , TestData);
  
  RdData = TestData & 0x0000000F;
  HSA(SMBIDCYR0, NSEQ, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_95);
  RdData = TestData & 0x0000001F;
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_96);
  HSA(SMBWSTWRR0, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_97);
  HSA(SMBWSTWRR0, BUSY, INCR4, , WRD, , 0x1, , , , ,);
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_98);
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_99);
  RdData = TestData & 0x0000000F;
  HSR( , RdData, , NoMask, ,BurstWriteReadTests_100);

}

void ConfigureMemory(int BankNo, int32  SSMCTrMEMBDat )

{
  /*
     Summary: Memory model Configuration
     ===================================
     This performs performs the following:

     o  Configures Memory model (TrickMem) to the parameters specified by the
        arguments
  */
   int32 SSMCTrMEMBASE; 

  switch (BankNo)
  {
       case 0 : SSMCTrMEMBASE  =  SSMCTrMEMBase0;
		break; 

       case 1 : SSMCTrMEMBASE  =  SSMCTrMEMBase1;
		break;

       case 2 : SSMCTrMEMBASE  =  SSMCTrMEMBase2;
		break;

       case 3 : SSMCTrMEMBASE  =  SSMCTrMEMBase3;
		break;

       case 4 : SSMCTrMEMBASE  =  SSMCTrMEMBase4;
		break;

       case 5 : SSMCTrMEMBASE  =  SSMCTrMEMBase5;
		break;

       case 6 : SSMCTrMEMBASE  =  SSMCTrMEMBase6;
		break;

       case 7 : SSMCTrMEMBASE  =  SSMCTrMEMBase7;
		break;
       
  }
  /** Write into the selected Bank **/
  HSA(SSMCTrMEMBASE, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SSMCTrMEMBDat);

}

void ConfigureCLKRatio(int32 SSMCCRData)
{
  /* Summary of the ConfigureClkRatio
     =================================
     o This function programs the SSMCCR register and the SSMCTrCR register
       of the Trickbox with the desired clock ratio.
  */

  /** Writing in to SSMCTrCR register with the required clk ratio **/
  HSA(SSMCTrCR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SSMCCRData);

  /** Writing in to SSMCCR register with the required clk ratio **/
  HSA(SSMCCR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SSMCCRData);

}


void ConfigureBurstWT(int32 SSMCTrBurstWTDat)
{
  /* 
     Summary of the ConfigureBurstWT 
     ===============================
     o this function programs the SSMCTrBurstWT register of the trick box
       by setting the appropiate bits for the BWtMask, BeatNo, BurstWT
  */

  /** Programming the SSMCTrBurstWT register  **/
  HSA(SSMCTrBurstWT, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SSMCTrBurstWTDat);
   
}

void ConfigureUUT(int BankNo, int32 SMBIDCYData, int32 SMBWSTRDData,
                  int32 SMBWSTWRData, int32 SMBWSTOENData, int32 SMBWSTWENData,
                  int32 SMBCRData, int32 SSMCTrCS2WTData, int32 SMBWSTBRDData)
{
  /*
     Summary: SSMC Configuration
     ==========================
     This performs performs the following:

     o  Programs the SSMC to the parameters specified by the arguments
  */

  int32 SMBCR, SMBIDCY, SMBWSTRD, SMBWSTWR, SMBWSTOEN, SMBWSTWEN, SMBWSTBRD;
  int32 SSMCTrCS2WT;
  switch(BankNo)
  {
    case 0 : SMBIDCY = SMBIDCYR0;
             SMBWSTRD = SMBWSTRDR0;
             SMBWSTWR = SMBWSTWRR0;
             SMBWSTOEN = SMBWSTOENR0;
             SMBWSTWEN = SMBWSTWENR0;
             SMBCR = SMBCR0;
             SMBWSTBRD = SMBWSTBRDR0;
             SSMCTrCS2WT = SSMCTrCS2WTR0;
             break;

    case 1 : SMBIDCY = SMBIDCYR1;
             SMBWSTRD = SMBWSTRDR1;
             SMBWSTWR = SMBWSTWRR1;
             SMBWSTOEN = SMBWSTOENR1;
             SMBWSTWEN = SMBWSTWENR1;
             SMBCR = SMBCR1;
             SMBWSTBRD = SMBWSTBRDR1;
             SSMCTrCS2WT = SSMCTrCS2WTR1;
             break;

    case 2 : SMBIDCY = SMBIDCYR2;
             SMBWSTRD = SMBWSTRDR2;
             SMBWSTWR = SMBWSTWRR2;
             SMBWSTOEN = SMBWSTOENR2;
             SMBWSTWEN = SMBWSTWENR2;
             SMBCR = SMBCR2;
             SMBWSTBRD = SMBWSTBRDR2;
             SSMCTrCS2WT = SSMCTrCS2WTR2;
             break;

    case 3 : SMBIDCY = SMBIDCYR3;
             SMBWSTRD = SMBWSTRDR3;
             SMBWSTWR = SMBWSTWRR3;
             SMBWSTOEN = SMBWSTOENR3;
             SMBWSTWEN = SMBWSTWENR3;
             SMBCR = SMBCR3;
             SMBWSTBRD = SMBWSTBRDR3;
             SSMCTrCS2WT = SSMCTrCS2WTR3;
             break;

    case 4 : SMBIDCY = SMBIDCYR4;
             SMBWSTRD = SMBWSTRDR4;
             SMBWSTWR = SMBWSTWRR4;
             SMBWSTOEN = SMBWSTOENR4;
             SMBWSTWEN = SMBWSTWENR4;
             SMBCR = SMBCR4;
             SMBWSTBRD = SMBWSTBRDR4;
             SSMCTrCS2WT = SSMCTrCS2WTR4;
             break;

    case 5 : SMBIDCY = SMBIDCYR5;
             SMBWSTRD = SMBWSTRDR5;
             SMBWSTWR = SMBWSTWRR5;
             SMBWSTOEN = SMBWSTOENR5;
             SMBWSTWEN = SMBWSTWENR5;
             SMBCR = SMBCR5;
             SMBWSTBRD = SMBWSTBRDR5;
             SSMCTrCS2WT = SSMCTrCS2WTR5;
             break;

    case 6 : SMBIDCY = SMBIDCYR6;
             SMBWSTRD = SMBWSTRDR6;
             SMBWSTWR = SMBWSTWRR6;
             SMBWSTOEN = SMBWSTOENR6;
             SMBWSTWEN = SMBWSTWENR6;
             SMBCR = SMBCR6;
             SMBWSTBRD = SMBWSTBRDR6;
             SSMCTrCS2WT = SSMCTrCS2WTR6;
             break;

    case 7 : SMBIDCY = SMBIDCYR7;
             SMBWSTRD = SMBWSTRDR7;
             SMBWSTWR = SMBWSTWRR7;
             SMBWSTOEN = SMBWSTOENR7;
             SMBWSTWEN = SMBWSTWENR7;
             SMBCR = SMBCR7;
             SMBWSTBRD = SMBWSTBRDR7;
             SSMCTrCS2WT = SSMCTrCS2WTR7;
             break;
  }

  /** Write into the selected Bank Configuration register (SMBCRx)          **/
  HSA(SMBIDCY, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBIDCYData);
  HSA(SMBWSTRD, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBWSTRDData);
  HSA(SMBWSTWR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBWSTWRData);
  HSA(SMBWSTOEN, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBWSTOENData);
  HSA(SMBWSTWEN, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBWSTWENData);
  HSA(SMBWSTBRD, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBWSTBRDData);
  HSA(SSMCTrCS2WT, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SSMCTrCS2WTData);
  HSA(SMBCR, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , SMBCRData);
}

void ToggleSMADDR(int32 SSMCTrMEMBase, int32 SSMCTrMemAddr)
{
  /*
     Summary: Toggle SMADDR Lines
     ============================
     This performs performs the following:

     o  Writes to a Memory location through the SSMC and verifies through both
        the SSMC and AHB Read.
  */

  int32 MemAddr, AHBAddr;

  MemAddr = SSMCTrMEMBase + 0x00000AAA;
  AHBAddr = SSMCTrMemAddr + 0x00000AAA;
  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , DataA);

  HSA(MemAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSR( , DataA, , NoMask, ,ToggleSMADDR_1);
}

void SingleWriteRead(int BankNo, int Burst, int32 Offset, char hsize,
                     int32 Data)
{
  /*
     Summary: Single Write Read
     ==========================
     This performs performs the following:

     o  Writes to a Memory location through the SSMC and verifies through both
        the SSMC and AHB Read.
  */

  int32 MemAddr, BSRAddr;
  char* beat[8] = {"sin", "inc", "in4", "in8", "in16", "wr4", "wr8", "w16"};

  switch(BankNo)
  {
    case 0 : MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11) + Offset;
             BSRAddr = SMBSR0;
    case 1 : MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11) + Offset;
             BSRAddr = SMBSR1;
    case 2 : MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + Offset;
             BSRAddr = SMBSR2;
    case 3 : MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11) + Offset;
             BSRAddr = SMBSR3;
    case 4 : MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11) + Offset;
             BSRAddr = SMBSR4;
    case 5 : MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + Offset;
             BSRAddr = SMBSR5;
    case 6 : MemAddr = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11) + Offset;
             BSRAddr = SMBSR6;
    case 7 : MemAddr = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11) + Offset;
             BSRAddr = SMBSR7;
  }

  /** Writing via SSMC **/
  HSA(MemAddr, NSEQ, beat[Burst], , hsize, , 0x1, , , , ,);
  HSW( , Data);

  /** Reading via SSMC **/
  HSA(MemAddr, NSEQ, beat[Burst], , hsize, , 0x1, , , , ,);
  HSR( , Data, , NoMask, ,SingleWriteRead_1);

  HSA(BSRAddr, NSEQ, SINGLE, , WRD, , 0x1, , , , ,);
  HSR( , ZERO, , NoMask, ,SingleWriteRead_1);

}


void BurstWriteRead(int BankNo, int Burst, int32 Offset, int hsize, int msize,
                    int32 Data)
{
  /*
     Summary: Burst Write-Read
     =========================
     This performs performs the following:

     o  Writes to a Memory location through the SSMC and verifies through both
        the SSMC and AHB Read.
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
  int Mul[3]   = {24, 16, 0};
  int32 Mask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int i, BeatsNo;

  switch(BankNo)
  {
    case 0 : MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11) + Offset;
             AHBAddr = SSMCTrMEMARRAY0 + Offset; break;
    case 1 : MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11) + Offset;
             AHBAddr = SSMCTrMEMARRAY1 + Offset; break;
    case 2 : MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + Offset;
             AHBAddr = SSMCTrMEMARRAY2 + Offset; break;
    case 3 : MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11) + Offset;
             AHBAddr = SSMCTrMEMARRAY3 + Offset; break;
    case 4 : MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11) + Offset;
             AHBAddr = SSMCTrMEMARRAY4 + Offset; break;
    case 5 : MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + Offset;
             AHBAddr = SSMCTrMEMARRAY5 + Offset; break;
    case 6 : MemAddr = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11) + Offset;
             AHBAddr = SSMCTrMEMARRAY6 + Offset; break;
    case 7 : MemAddr = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11) + Offset;
             AHBAddr = SSMCTrMEMARRAY7 + Offset; break;
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
   " BANKNO = %d, HSIZE = %s, MSIZE = %s, HBURST = %s",
           BankNo, SizeStr[hsize], SizeStr[msize], BurstStr[Burst]);
  msg_info(PrintStr);

  /** Writing via SSMC **/
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

  /** Reading via SSMC **/
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
                   HSR( , AHBRdData1, , Mask[msize], ,BurstWriteRead_3);
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
                     ReadMask = Mask[hsize];
                     AHBRdData1 = (TempData & Mask[hsize]) |
                                  ((++TempData << 8) & (Mask[hsize] << 8));
                     if (BeatsNo < 2)
                     {
                       ReadMask = Mask[hsize];
                       AHBRdData1 = AHBRdData1 & ReadMask;
                     }
                   } else
                   {
                     ReadMask = Mask[hsize];
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
    case 0 : AHBAddr = SSMCTrMEMARRAY0 + Offset; break;
    case 1 : AHBAddr = SSMCTrMEMARRAY1 + Offset; break;
    case 2 : AHBAddr = SSMCTrMEMARRAY2 + Offset; break;
    case 3 : AHBAddr = SSMCTrMEMARRAY3 + Offset; break;
    case 4 : AHBAddr = SSMCTrMEMARRAY4 + Offset; break;
    case 5 : AHBAddr = SSMCTrMEMARRAY5 + Offset; break;
    case 6 : AHBAddr = SSMCTrMEMARRAY6 + Offset; break;
    case 7 : AHBAddr = SSMCTrMEMARRAY7 + Offset; break;
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
    case 0 : AHBAddr = SSMCTrMEMARRAY0 + Offset; break;
    case 1 : AHBAddr = SSMCTrMEMARRAY1 + Offset; break;
    case 2 : AHBAddr = SSMCTrMEMARRAY2 + Offset; break;
    case 3 : AHBAddr = SSMCTrMEMARRAY3 + Offset; break;
    case 4 : AHBAddr = SSMCTrMEMARRAY4 + Offset; break;
    case 5 : AHBAddr = SSMCTrMEMARRAY5 + Offset; break;
    case 6 : AHBAddr = SSMCTrMEMARRAY6 + Offset; break;
    case 7 : AHBAddr = SSMCTrMEMARRAY7 + Offset; break;
  }

  BlockSize--;
  HSA(AHBAddr, NSEQ, INCR, , WRD, , 0x1, , , , ,);
  HSW( , StartData++);
  for (i=0; i<BlockSize; i++)
    HSW( , StartData++);

}

void SSMCReadMem(int BankNo, int32 Offset, int Burst, char hsize,
                int32 StartData)
{
  /*
     Summary: Read from the Memory through SSMC
     =========================================
     This performs performs the following :

     o  Reads from the Memory bank 'BankNo' through the SSMC.
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
    case 0 : MemAddr = SSMCMEM_0 + (SSMCTrMEMBData[0] << 11) + Offset; break;
    case 1 : MemAddr = SSMCMEM_1 + (SSMCTrMEMBData[1] << 11) + Offset; break;
    case 2 : MemAddr = SSMCMEM_2 + (SSMCTrMEMBData[2] << 11) + Offset; break;
    case 3 : MemAddr = SSMCMEM_3 + (SSMCTrMEMBData[3] << 11) + Offset; break;
    case 4 : MemAddr = SSMCMEM_4 + (SSMCTrMEMBData[4] << 11) + Offset; break;
    case 5 : MemAddr = SSMCMEM_5 + (SSMCTrMEMBData[5] << 11) + Offset; break;
    case 6 : MemAddr = SSMCMEM_6 + (SSMCTrMEMBData[6] << 11) + Offset; break;
    case 7 : MemAddr = SSMCMEM_7 + (SSMCTrMEMBData[7] << 11) + Offset; break;
  }

  HSA(MemAddr, NSEQ, beat[Burst], , hsize, , 0x1, , , , ,);
  HSR( , StartData++, , NoMask, ,SSMCReadMem_1);

}

void SMCS()
{
  /*
     Summary: Toggle SMCS line of the SSMC
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
      sprintf(Message,
    "PERFORMING CHIP SELECT TEST ON BANK %d WITH TESTDATA = %d", j, TestWrite[i]);
      C(Message);
      switch (j)
      {
        case 0 : BankBase = SSMCMEM_0; break;
        case 1 : BankBase = SSMCMEM_1; break;
        case 2 : BankBase = SSMCMEM_2; break;
        case 3 : BankBase = SSMCMEM_3; break;
        case 4 : BankBase = SSMCMEM_4; break;
        case 5 : BankBase = SSMCMEM_5; break;
        case 6 : BankBase = SSMCMEM_6; break;
        case 7 : BankBase = SSMCMEM_7; break;
      }
      MemAddr = BankBase + (SSMCTrMEMBData[j] << 11) + Offset[i];
      HSA(MemAddr, NSEQ, INCR, OK, WRD, , 0x1, , , , ,);
      HSW( , TestData++);
    }

    WaitLoop(10);

    /** Verifying the written data from the AHB side **/
    TestData = TestWrite[i];
    for (j=0; j<8; j++)
    {
      switch (j)
      {
        case 0 : BankBase = SSMCTrMEMARRAY0; break;
        case 1 : BankBase = SSMCTrMEMARRAY1; break;
        case 2 : BankBase = SSMCTrMEMARRAY2; break;
        case 3 : BankBase = SSMCTrMEMARRAY3; break;
        case 4 : BankBase = SSMCTrMEMARRAY4; break;
        case 5 : BankBase = SSMCTrMEMARRAY5; break;
        case 6 : BankBase = SSMCTrMEMARRAY6; break;
        case 7 : BankBase = SSMCTrMEMARRAY7; break;
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
     Summary: Read the Status of the SSMC
     ===================================
     This performs the following :

     o  Reads from the Status registers of the SSMC
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
     Summary: Clear the Status of the SSMC
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

void ReadCSR(int32 CSRValue)
{
  /*
     Summary: Read the External Wait Error Status of the SSMC
     =======================================================
     This performs the following :

     o  Reads from the SSMCSR Status register of the SSMC
     o  Polls for the 'CSRValue'
  */
     
  WaitLoop(1);
  HSA(SSMCSR, NSEQ, SINGLE, , WRD, , 0x0, , , , ,);
  HPO( , CSRValue, , NoMask, , 0xFF,CSRStatus_1);

}

void BusGntWriteRead(int BankNo, int Burst, int32 Offset, int hsize, int msize,
                     int32 Data)
{
  /*
     Summary: Memory Write-Read
     ==========================
     This performs performs the following:

     o  Writes to a Memory location through the SSMC and verifies through
        the SSMC.
  */

  int32 MemAddr, TempData, TestData, ReadMask;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
  int Shift[3] = {8, 16, 32};
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int i, j, BeatsNo;

  switch(BankNo)
  {
    case 0 : MemAddr = SSMCMEM_0 + Offset; break;
    case 1 : MemAddr = SSMCMEM_1 + Offset; break;
    case 2 : MemAddr = SSMCMEM_2 + Offset; break;
    case 3 : MemAddr = SSMCMEM_3 + Offset; break;
    case 4 : MemAddr = SSMCMEM_4 + Offset; break;
    case 5 : MemAddr = SSMCMEM_5 + Offset; break;
    case 6 : MemAddr = SSMCMEM_6 + Offset; break;
    case 7 : MemAddr = SSMCMEM_7 + Offset; break;
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

  /** Writing via SSMC **/
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

  /** Reading via SSMC **/
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
  HSR( , TestData, , ReadMask, ,BusGntTests_1);
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
    HSR( , TestData, , ReadMask, ,BusGntTests_2);
  }
}

void MemWriteRead(int BankNo, int Burst, int32 Offset, int hsize, int msize,
                     int32 Data)
{
  /*
     Summary: Memory Write-Read
     ==========================
     This performs performs the following:

     o  Writes to a Memory location through the SSMC and verifies through
        the SSMC.
  */

  int32 MemAddr, TempData, TestData, ReadMask;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
  int Shift[3] = {8, 16, 32};
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int i, j, BeatsNo;

  switch(BankNo)
  {
    case 0 : MemAddr = SSMCMEM_0 + Offset; break;
    case 1 : MemAddr = SSMCMEM_1 + Offset; break;
    case 2 : MemAddr = SSMCMEM_2 + Offset; break;
    case 3 : MemAddr = SSMCMEM_3 + Offset; break;
    case 4 : MemAddr = SSMCMEM_4 + Offset; break;
    case 5 : MemAddr = SSMCMEM_5 + Offset; break;
    case 6 : MemAddr = SSMCMEM_6 + Offset; break;
    case 7 : MemAddr = SSMCMEM_7 + Offset; break;
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

  /** Writing via SSMC **/
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

  /** Reading via SSMC **/
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


void MemWrite(int BankNo, int Burst, int32 Offset, int hsize, int msize,
                     int32 Data)
{
  /*
     Summary: Memory Write
     =====================
     This performs performs the following:

     o  Writes to a Memory location through the SSMC. 
  */

  int32 MemAddr, TempData, TestData, ReadMask;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
  int Shift[3] = {8, 16, 32};
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int i, j, BeatsNo;

  switch(BankNo)
  {
    case 0 : MemAddr = SSMCMEM_0 + Offset; break;
    case 1 : MemAddr = SSMCMEM_1 + Offset; break;
    case 2 : MemAddr = SSMCMEM_2 + Offset; break;
    case 3 : MemAddr = SSMCMEM_3 + Offset; break;
    case 4 : MemAddr = SSMCMEM_4 + Offset; break;
    case 5 : MemAddr = SSMCMEM_5 + Offset; break;
    case 6 : MemAddr = SSMCMEM_6 + Offset; break;
    case 7 : MemAddr = SSMCMEM_7 + Offset; break;
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

  /** Writing via SSMC **/
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

}


void MemRead(int BankNo, int Burst, int32 Offset, int hsize, int msize,
                     int32 Data)
{
  /*
     Summary: Memory Read
     ====================
     This performs performs the following:

     o  Reads from a Memory location through the SSMC and AHB.
  */

  int32 MemAddr, TempData, TestData, ReadMask;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "i16", "wr4", "wr8", "w16"};
  int Shift[3] = {8, 16, 32};
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int i, j, BeatsNo;

  switch(BankNo)
  {
    case 0 : MemAddr = SSMCMEM_0 + Offset; break;
    case 1 : MemAddr = SSMCMEM_1 + Offset; break;
    case 2 : MemAddr = SSMCMEM_2 + Offset; break;
    case 3 : MemAddr = SSMCMEM_3 + Offset; break;
    case 4 : MemAddr = SSMCMEM_4 + Offset; break;
    case 5 : MemAddr = SSMCMEM_5 + Offset; break;
    case 6 : MemAddr = SSMCMEM_6 + Offset; break;
    case 7 : MemAddr = SSMCMEM_7 + Offset; break;
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


  /** Reading via SSMC **/
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
  HSR( , TestData, , ReadMask, ,MemRead_1);
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
    HSR( , TestData, , ReadMask, ,MemRead_2);
  }
}


void ROMWriteRead(int BankNo, int Burst, int32 Offset, int hsize, int msize,
                     int32 WriteData, int32 ReadData)
{
  /*
     Summary: ROM Write-Read
     ==========================
     This performs performs the following:

     o  Writes into a ROM through the SSMC expecting ERROR response
        and verifies through the SSMC for the unmodified data.
  */

  int32 MemAddr, TempData, TestData, ReadMask;
  char size[3] = {'b', 'h', 'w'};
  char* beat[8] = {"sin", "inc", "in4", "in8", "in16", "wr4", "wr8", "w16"};
  int Shift[3] = {8, 16, 32};
  int32 UnMask[3] = {0x000000FF, 0x0000FFFF, 0xFFFFFFFF};
  int i, j, BeatsNo;

  switch(BankNo)
  {
    case 0 : MemAddr = SSMCMEM_0 + Offset; break;
    case 1 : MemAddr = SSMCMEM_1 + Offset; break;
    case 2 : MemAddr = SSMCMEM_2 + Offset; break;
    case 3 : MemAddr = SSMCMEM_3 + Offset; break;
    case 4 : MemAddr = SSMCMEM_4 + Offset; break;
    case 5 : MemAddr = SSMCMEM_5 + Offset; break;
    case 6 : MemAddr = SSMCMEM_6 + Offset; break;
    case 7 : MemAddr = SSMCMEM_7 + Offset; break;
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

  /** Writing via SSMC **/
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

  /** Reading via SSMC **/
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
