/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2002 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : Check_Integration.c.rca
--  File Revision          : 1.1
--  
--  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
--  
------------------------------------------------------------------------------*/


/* function declarations  */
void Check_Integration(void);
void Integration_RegTest(void);
void Integration_ResetTest(int32 RegAddr);
void Integration_R_WTest(int32 DATA);



void Check_Integration(void) 
{
  Integration_RegTest();
}


/* -------------------------------------------------------------------------
    Integration Register test  Function    
    This function tests the Integration test registers in CLCD controller 
    for reset test and read-write registers, read-only registers.
    It has been isolated from the main test as it causes error messages to
    emitted because the device in is "integration" test mode.
    These error messages are only valid when emitted when the device is
    operating in normal mode.
   -------------------------------------------------------------------------*/
void Integration_RegTest(void)
{ 

C("INTEGRATION REGISTER TESTS");

Integration_ResetTest(LcdTCR);
Integration_ResetTest(LcdITOP1);
Integration_ResetTest(LcdITOP2);

Integration_R_WTest(0xFFFFFFFF);
Integration_R_WTest(0x55555555);
Integration_R_WTest(0xAAAAAAAA);
Integration_R_WTest(0x00000000);

}

/*--------------------------------------------------------------------------
          Function to test the reset condition of the registers    
  ------------------------------------------------------------------------*/
void Integration_ResetTest(int32 RegAddr)
{
/*  Start of the Reset Test      */
HSA(RegAddr,NSEQ,SINGLE,OK,WRD);
HSR(,0x00000000,,0xFFFFFFFF,,Read_00s);
}

/*-------------------------------------------------------------------------
         This is for testing write and read operation of the read    
              operation of the read and writable registers              
  ------------------------------------------------------------------------*/
void Integration_R_WTest(int32 DATA)
{
C(" CLCD  CONTROLLER READ WRITE REGISTER TEST ");

/* Put the CLCD into Integration Test Mode */
HSA(LcdTCR,NSEQ,SINGLE,OK,WRD);
HSW(,0x1,,LcdTCR_WRITE);

C(" WRITING TO THE REGISTERS : Non Sequential Writes");
/* Write to the Integration Test registers */
HSA(LcdITOP2,NSEQ,SINGLE,OK,WRD);
HSW(,DATA,,LcdITOP2_WRITE);
HSA(LcdITOP1,NSEQ,SINGLE,OK,WRD);
HSW(,DATA,,LcdITOP1_WRITE);

C("READING THE REGISTERS : Non Sequential Reads");
/* Read from the Integration Test registers */
HSA(LcdITOP2,NSEQ,SINGLE,OK,WRD);
HSR(,DATA,,0x3FFFFFFF,);
HSA(LcdITOP1,NSEQ,SINGLE,OK,WRD);
HSR(,DATA,,0x3F,);

C(" WRITING TO THE REGISTERS : Sequential Writes");
/* Put the CLCD into Integration Test Mode */
HSA(LcdTCR,NSEQ,SINGLE,OK,WRD);
HSW(,0x1,,LcdTCR_WRITE);
/* Write to the Integration Test registers */
HSW(,DATA & 0x3F,,LcdITOP1_WRITE);
HSW(,DATA & 0x3FFFFFFF,,LcdITOP2_WRITE);
/* Put the CLCD into Normal Mode */
HSA(LcdTCR,NSEQ,SINGLE,OK,WRD);
HSW(,0x0,,LcdTCR_WRITE);

C("READING THE REGISTERS : Sequential Reads");
/* Put the CLCD into Integration Test Mode */
HSA(LcdTCR,NSEQ,SINGLE,OK,WRD);
HSW(,0x1,,LcdTCR_WRITE);
/* Read from the Integration Test registers */
HSA(LcdITOP1,NSEQ,SINGLE,OK,WRD);
HSR(,DATA ,,0x3F,);       /* Itop1 */
HSR(,DATA ,,0x3FFFFFFF,); /* Itop2 */

/* Put the CLCD into Normal Mode */
HSA(LcdTCR,NSEQ,SINGLE,OK,WRD);
HSW(,0x0,,LcdTCR_WRITE);
}

/*******************************END******************************************/
