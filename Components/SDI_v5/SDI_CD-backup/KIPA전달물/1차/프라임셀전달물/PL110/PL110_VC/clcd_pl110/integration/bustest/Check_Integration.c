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
--  File Revision          : 1.4
--
--  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
--
------------------------------------------------------------------------------*/

void IntegationTests(void);
void RegTest(void);
void ResetTest(int32 RegAddr);
void R_WTest(int32 DATA);
void R_oTest(int32 RegAddr);
void R_oTest_ID(int32 RegAddr, int32 DATA);
void Read_Write_Pallete(void);
void IntRegisterTest(void);
void IntRegisterTestSingleBits(void);

void IntegrationTests(void)
{
  RegTest();
  IntRegisterTest();
  IntRegisterTestSingleBits();
  Read_Write_Pallete();
}

/* -------------------------------------------------------------------------
    Register test Function
    This function tests the registers in the CLCD controller for reset test
    and read-write registers, read-only registers.
   -------------------------------------------------------------------------*/

void RegTest(void)
{
  C("REGISTER TESTS");
  C("REGISTER RESET TEST");
  ResetTest(Tim0);
  ResetTest(Tim1);
  ResetTest(Tim2);
  ResetTest(Tim3);
  ResetTest(UpBase);
  ResetTest(LpBase);
  ResetTest(CntrlReg);
  ResetTest(Imsc);
  ResetTest(Ris);
  ResetTest(Mis);
  ResetTest(Icr);
  ResetTest(UpCrntAddr);
  ResetTest(LpCrntAddr);

  R_WTest(0xFFFFFFFF);
  R_WTest(0x55555555);
  R_WTest(0xAAAAAAAA);
  R_WTest(0x00000000);

  C(" CLCD CONTROLLER READ ONLY REGISTERS TEST");
  HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
  HSW(0x0,0x0,,IDLE_CYCLE);
  HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
  HSW(0x0,0x0,,IDLE_CYCLE);
  HSA(CntrlReg,IDLE,SINGLE,OK,WRD);
  HSW(0x0,0x0,,IDLE_CYCLE);
  RES (LOW);

  R_oTest(Ris);
  R_oTest(Mis);
  R_oTest(UpCrntAddr);
  R_oTest(LpCrntAddr);
  R_oTest_ID(PeriphID0, 0x00000010);
  R_oTest_ID(PeriphID1, 0x00000011);
  R_oTest_ID(PeriphID2, 0x00000024);
  R_oTest_ID(PeriphID3, 0x00000000);
  R_oTest_ID(PCellID0,  0x0000000D);
  R_oTest_ID(PCellID1,  0x000000F0);
  R_oTest_ID(PCellID2,  0x00000005);
  R_oTest_ID(PCellID3,  0x000000B1);
}


/*--------------------------------------------------------------------------
          Function to test the reset condition of the registers
  ------------------------------------------------------------------------*/

void  ResetTest(int32 RegAddr)
{
  /* Start of the Reset Test */
  HSA(RegAddr,NSEQ,SINGLE,OK,WRD);
  HSR(,0x00000000,,0xFFFFFFFF,,Read_00s);
}


/*-------------------------------------------------------------------------
         This is for testing write and read operation of the read
              operation of the read and writable registers
  ------------------------------------------------------------------------*/

void R_WTest(int32 DATA)
{
  C(" CLCD  CONTROLLER READ WRITE REGISTER TEST ");
  C(" WRITING TO THE REGISTERS : Non Sequential Writes");
  HSA(Tim0,NSEQ,SINGLE,OK,WRD);
  HSW(,DATA,,TIMING0_WRITE);
  HSA(Tim2,NSEQ,SINGLE,OK,WRD);
  HSW(,DATA,,TIMING2_WRITE);
  HSA(Tim1,NSEQ,SINGLE,OK,WRD);
  HSW(,DATA,,TIMING1_WRITE);
  HSA(Tim3,NSEQ,SINGLE,OK,WRD);
  HSW(,DATA,,TIMING3_WRITE);
  HSA(LpBase,NSEQ,SINGLE,OK,WRD);
  HSW(,DATA,,LPBASE_WRITE);
  HSA(UpBase,NSEQ,SINGLE,OK,WRD);
  HSW(,DATA,,UPBASE_WRITE);
  HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
  HSW(,DATA,,CntrlReg_WRITE);
  HSA(Imsc,NSEQ,SINGLE,OK,WRD);
  HSW(,DATA,,Imsc_WRITE);

  C("READING THE REGISTERS : Non Sequential Reads");
  HSA(Tim0,NSEQ,SINGLE,OK,WRD);
  HSR(,DATA,,0xFFFFFFFC,);
  HSA(Tim2,NSEQ,SINGLE,OK,WRD);
  HSR(,DATA,,0x07FF7FFF,);
  HSA(Tim1,NSEQ,SINGLE,OK,WRD);
  HSR(,DATA,,0xFFFFFFFF,);
  HSA(Tim3,NSEQ,SINGLE,OK,WRD);
  HSR(,DATA,,0x0001007F,);
  HSA(LpBase,NSEQ,SINGLE,OK,WRD);
  HSR(,DATA,,0xFFFFFFFC,);
  HSA(UpBase,NSEQ,SINGLE,OK,WRD);
  HSR(,DATA,,0xFFFFFFFC,);
  HSA(CntrlReg,NSEQ,SINGLE,OK,WRD);
  HSR(,DATA,,0x00013FFF,);
  HSA(Imsc,NSEQ,SINGLE,OK,WRD);
  HSR(,DATA,,0x0000001E,);
}


/*-------------------------------------------------------------------------
        This is the function to test read only registers
  ------------------------------------------------------------------------*/

void R_oTest(int32 RegAddr)
{
  HSA(RegAddr,NSEQ,SINGLE,OK,WRD);
  HSW(,0xFFFFFFFF,,R_OTestWrite);
  HSA(RegAddr,NSEQ,SINGLE,OK,WRD);
  HSR( ,0x00000000,,0xFFFFFFFF,,R_OTestRead);
}


/*-------------------------------------------------------------------------
        This is the function to test read only ID registers
  ------------------------------------------------------------------------*/

void R_oTest_ID(int32 RegAddr, int32 DATA)
{
  HSA(RegAddr,NSEQ,SINGLE,OK,WRD);
  HSW(,~DATA,,R_O_ID_TestWrite);
  HSA(RegAddr,NSEQ,SINGLE,OK,WRD);
  HSR( ,DATA,,0xFFFFFFFF,,R_OTestRead);
}


/*------------------------------------------------------------------------
          This function is a read/write test for the palette
 -------------------------------------------------------------------------*/

void Read_Write_Pallete(void)
{
int32 Data,Address;

C("PALLETE CHECKING");
for(Address = 0x0; Address < 0x1FF; Address = Address + 4)
  {
    Data = 0x01010101 * Address + 0x03020100 ;
    HSA(Pal+Address,NSEQ,INCR,OK,WRD);
    HSW(,Data,,PALLETE_WRITE);
  }
 for(Address = 0x0; Address < 0x1FF; Address = Address + 4)
   {
     Data = 0x01010101 * Address + 0x03020100 ;
     HSA(Pal+Address,NSEQ,INCR,OK,WRD);
     HSR(,Data,,0xFFFFFFFF,,PALLETE_READ);
   }
 for(Address = 0x0; Address < 0x1FF; Address = Address + 4)
   {
     Data = 0x01010101 * Address + 0x03020100 ;
     Data = ~Data;
     HSA(Pal+Address,NSEQ,INCR,OK,WRD);
     HSW(,Data,,PALLETE_WRITE);
   }
 for(Address = 0x0; Address < 0x1FF; Address = Address + 4)
   {
     Data = 0x01010101 * Address + 0x03020100 ;
     Data = ~Data;
     HSA(Pal+Address,NSEQ,INCR,OK,WRD);
     HSR(,Data,,0xFFFFFFFF,,PALLETE_READ);
   }
 C("PALLETE IS CHECKED");
}


/* -------------------------------------------------------------------------
    Integration Register test Function
    o  All integration registers are written with different patterns and read
        back to verify the readable/writeable bits in a register.
   -------------------------------------------------------------------------*/
void IntRegisterTest()
{
  int i;
  int32 ExpData;
  int32 DataArray[]  = {0x00000000, 0xFFFFFFFF, 0x55555555, 0xAAAAAAAA,
                        0x33333333, 0xCCCCCCCC, 0x0F0F0F0F, 0xF0F0F0F0,
                        0x00FF00FF, 0xFF00FF00, 0x0000FFFF, 0xFFFF0000,
                        0x00000001};
  /* Enable Integration testing of the Clcd by setting the enable
     bit in the ClcdITCR register
  */

  C("Register tests for the Clcd");
  HSA(ClcdITCR, NSEQ, INCR, OK, WRD, , , , ,);
  HSW(,0x00000001);
  i = 0;
  do
  {
    HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,);
    HSW(,DataArray[i]);

    ExpData = MASK_ClcdITOP1 & DataArray[i];

    HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,);
    HSR(,ExpData, ,NoMask);

    HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,);
    HSW(,DataArray[i]);

    ExpData = MASK_ClcdITOP2 & DataArray[i];

    HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,);
    HSR(,ExpData, ,NoMask);

    i = i + 1;
  }
  while (DataArray[i] != 0x00000001);
  /* Exit from test mode */
  HSA(ClcdITCR, NSEQ, INCR, OK, WRD, , , , ,);
  HSW(,0x00000000);

}


/* -------------------------------------------------------------------------
    Integration Register Single Bit test Function

     When the Clcd is used in an AMBA system, it must be ensured that
     all of its intra chips signals are correctly connected. Integration
     vectors allow the user to verify that the Clcd has been wired into the
     system correctly.
   -------------------------------------------------------------------------*/

void IntRegisterTestSingleBits()
{
  /* Testing of Intra-Chip input  :
     The procedure is given below.
     - Write a 1 to the ITEN bit in the Control register.

     - Write a 1 and then a 0 to the ClcdITOP1 register bits in sequence
       and read the same register bit to ensure that the value written
       is read out.

     - Write a 1 and then a 0 to the ClcdITOP2 register bits in sequence
       and read the same register bit to ensure that the value written
       is read out.

 NOTE : When the tests are run in an integrated system, the
        user is expected to replace the ITOP register reads with suitable
        commands to read the Clcd's output signals.
  */

  C("Integration Tests for the Clcd");

  /* Enable Integration testing of the Clcd by setting the ITEN
     bit in the ClcdITCR register */

  HSA(ClcdITCR, NSEQ, INCR, OK, WRD, , , , ,);
  HSW(,0x00000001);


  C("Testing Intra Chip Output connection");
  HSA(ClcdITCR, NSEQ, INCR, OK, WRD, , , , ,);
  HSW(,0x00000001);

  /** Set CLCDINTR through the ClcdITOP1 register **/
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000001);
  /* Read the value on CLCDINTR */
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000001, ,0x00000001, ,Read_67);
  /** Reset the CLCDINTR output **/
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLCDINTR */
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000001, ,Read_68);

  /** Set CLCDVCOMPINTR through the ClcdITOP1 register **/
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000002);
  /* Read the value on CLCDVCOMPINTR */
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000002, ,0x00000002, ,Read_67);
  /** Reset the CLCDVCOMPINTR output **/
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLCDVCOMPINTR */
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000002, ,Read_68);

  /** Set CLCDLNBUINTR through the ClcdITOP1 register **/
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000004);
  /* Read the value on CLCDLNBUINTR */
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000004, ,0x00000004, ,Read_67);
  /** Reset the CLCDLNBUINTR output **/
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLCDLNBUINTR */
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000004, ,Read_68);

  /** Set CLCDFUFINTR through the ClcdITOP1 register **/
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000008);
  /* Read the value on CLCDFUFINTR */
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000008, ,0x00000008, ,Read_67);
  /** Reset the CLCDFUFINTR output **/
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLCDFUFINTR */
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000008, ,Read_68);

  /** Set CLCDMBEINTR through the ClcdITOP1 register **/
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000010);
  /* Read the value on CLCDMBEINTR */
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000010, ,0x00000010, ,Read_67);
  /** Reset the CLCDMBEINTR output **/
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLCDMBEINTR */
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000010, ,Read_68);

  /** Set CLCDCLKSEL through the ClcdITOP1 register **/
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000020);
  /* Read the value on CLCDCLKSEL */
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000020, ,0x00000020, ,Read_67);
  /** Reset the CLCDCLKSEL output **/
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLCDCLKSEL */
  HSA(ClcdITOP1, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000020, ,Read_68);


  /** Set CLD[0] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000001);
  /* Read the value on CLD[0] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000001, ,0x00000001, ,Read_67);
  /** Reset the CLD[0] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[0] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000001, ,Read_68);

  /** Set CLD[1] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000002);
  /* Read the value on CLD[1] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000002, ,0x00000002, ,Read_67);
  /** Reset the CLD[1] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[1] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000002, ,Read_68);

  /** Set CLD[2] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000004);
  /* Read the value on CLD[2] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000004, ,0x00000004, ,Read_67);
  /** Reset the CLD[2] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[2] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000004, ,Read_68);

  /** Set CLD[3] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000008);
  /* Read the value on CLD[3] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000008, ,0x00000008, ,Read_67);
  /** Reset the CLD[3] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[3] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000008, ,Read_68);

  /** Set CLD[4] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000010);
  /* Read the value on CLD[4] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000010, ,0x00000010, ,Read_67);
  /** Reset the CLD[4] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[4] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000010, ,Read_68);

  /** Set CLD[5] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000020);
  /* Read the value on CLD[5] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000020, ,0x00000020, ,Read_67);
  /** Reset the CLD[5] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[5] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000020, ,Read_68);

  /** Set CLD[6] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000040);
  /* Read the value on CLD[6] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000040, ,0x00000040, ,Read_67);
  /** Reset the CLD[6] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[6] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000040, ,Read_68);

  /** Set CLD[7] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000080);
  /* Read the value on CLD[7] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000080, ,0x00000080, ,Read_67);
  /** Reset the CLD[7] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[7] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000080, ,Read_68);

  /** Set CLD[8] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000100);
  /* Read the value on CLD[8] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000100, ,0x00000100, ,Read_67);
  /** Reset the CLD[8] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[8] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000100, ,Read_68);

  /** Set CLD[9] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000200);
  /* Read the value on CLD[9] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000200, ,0x00000200, ,Read_67);
  /** Reset the CLD[9] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[9] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000200, ,Read_68);

  /** Set CLD[10] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000400);
  /* Read the value on CLD[10] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000400, ,0x00000400, ,Read_67);
  /** Reset the CLD[10] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[10] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000400, ,Read_68);

  /** Set CLD[11] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000800);
  /* Read the value on CLD[11] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000800, ,0x00000800, ,Read_67);
  /** Reset the CLD[11] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[11] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00000800, ,Read_68);

  /** Set CLD[12] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00001000);
  /* Read the value on CLD[12] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00001000, ,0x00001000, ,Read_67);
  /** Reset the CLD[12] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[12] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00001000, ,Read_68);

  /** Set CLD[13] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00002000);
  /* Read the value on CLD[13] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00002000, ,0x00002000, ,Read_67);
  /** Reset the CLD[13] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[13] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00002000, ,Read_68);

  /** Set CLD[14] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00004000);
  /* Read the value on CLD[14] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00004000, ,0x00004000, ,Read_67);
  /** Reset the CLD[14] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[14] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00004000, ,Read_68);

  /** Set CLD[15] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00008000);
  /* Read the value on CLD[15] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00008000, ,0x00008000, ,Read_67);
  /** Reset the CLD[15] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[15] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00008000, ,Read_68);

  /** Set CLD[16] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00010000);
  /* Read the value on CLD[16] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00010000, ,0x00010000, ,Read_67);
  /** Reset the CLD[16] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[16] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00010000, ,Read_68);

  /** Set CLD[17] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00020000);
  /* Read the value on CLD[17] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00020000, ,0x00020000, ,Read_67);
  /** Reset the CLD[17] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[17] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00020000, ,Read_68);

  /** Set CLD[18] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00040000);
  /* Read the value on CLD[18] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00040000, ,0x00040000, ,Read_67);
  /** Reset the CLD[18] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[18] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00040000, ,Read_68);

  /** Set CLD[19] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00080000);
  /* Read the value on CLD[19] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00080000, ,0x00080000, ,Read_67);
  /** Reset the CLD[19] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[19] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00080000, ,Read_68);

  /** Set CLD[20] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00100000);
  /* Read the value on CLD[20] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00100000, ,0x00100000, ,Read_67);
  /** Reset the CLD[20] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[20] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00100000, ,Read_68);

  /** Set CLD[21] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00200000);
  /* Read the value on CLD[21] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00200000, ,0x00200000, ,Read_67);
  /** Reset the CLD[201 output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[21] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00200000, ,Read_68);

  /** Set CLD[22] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00400000);
  /* Read the value on CLD[22] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00400000, ,0x00400000, ,Read_67);
  /** Reset the CLD[22] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[22] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00400000, ,Read_68);

  /** Set CLD[23] through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00800000);
  /* Read the value on CLD[23] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00800000, ,0x00800000, ,Read_67);
  /** Reset the CLD[23] output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLD[23] */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x00800000, ,Read_68);

  /** Set CLLE through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x01000000);
  /* Read the value on CLLE */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x01000000, ,0x01000000, ,Read_67);
  /** Reset the CLLE output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLLE */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x01000000, ,Read_68);

  /** Set CLAC through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x02000000);
  /* Read the value on CLAC */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x02000000, ,0x02000000, ,Read_67);
  /** Reset the CLAC output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLAC */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x02000000, ,Read_68);

  /** Set CLFP through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x04000000);
  /* Read the value on CLFP */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x04000000, ,0x04000000, ,Read_67);
  /** Reset the CLFP output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLFP */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x04000000, ,Read_68);

  /** Set CLCP through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x08000000);
  /* Read the value on CLCP */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x08000000, ,0x08000000, ,Read_67);
  /** Reset the CLCP output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLCP */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x08000000, ,Read_68);

  /** Set CLLP through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x10000000);
  /* Read the value on CLLP */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x10000000, ,0x10000000, ,Read_67);
  /** Reset the CLLP output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLLP */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x10000000, ,Read_68);

  /** Set CLPOWER through the ClcdITOP2 register **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x20000000);
  /* Read the value on CLPOWER */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x20000000, ,0x20000000, ,Read_67);
  /** Reset the CLPOWER output **/
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSW(,0x00000000);
  /* Read the value on CLPOWER */
  HSA(ClcdITOP2, NSEQ, INCR, OK, WRD, , , , ,0x1);
  HSR(,0x00000000, ,0x20000000, ,Read_68);

  /* Exit from test mode */
  HSA(ClcdITCR, NSEQ, INCR, OK, WRD, , , , ,);
  HSW(,0x00000000);
}
/*******************************END******************************************/
