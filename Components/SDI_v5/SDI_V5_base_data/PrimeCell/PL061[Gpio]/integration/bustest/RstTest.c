/*----------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--  
--  File Name              : RstTest.c.rca
--  File Revision          : $Revision : 1.1 $
--  Release Information    : PrimeCell(TM)-PL061-REL1v0
--  
------------------------------------------------------------------------------
--   Purpose : This C code file is used to generate BusTalk vectors.
------------------------------------------------------------------------------*/

/******************************************************************************/
/**************************** Reset Test **************************************/
/******************************************************************************/

void RstTest()
{
  /*
   Summary: Reset Test
   ===================
   This test reads all the GPIO registers a/fter reset to verify that they
   initialise to their reset value of zero. The Data Register and GPIORIS are
   not read during this test as the pins are set as inputs on reset.
   Hence the contents of the GPIODATA register will reflect the status
   of the input pins and and the GPIORIS will react to the values driven by 
   external devices.
  */

  /* PSR(0x00000000, NoMask, GPIODATA);      */  /*It depends on GPIN */
  /* PSR(0x00000000, NoMask, GPIORIS,   RIS);*/  /*It depends on GPIN */

  PSR(0x00000000, NoMask, GPIODIR,DIR);
  PSR(0x00000000, NoMask, GPIOIS,IS);
  PSR(0x00000000, NoMask, GPIOIBE,IBE);
  PSR(0x00000000, NoMask, GPIOIEV,IEV);
  PSR(0x00000000, NoMask, GPIOIE,IE);
 
  PSR(0x00000000, NoMask, GPIOMIS,MIS);
  PSR(0x00000000, NoMask, GPIOAFSEL,AFSEL); 

  PSR(0x00000000, NoMask, GPIOITCR,ITCR);
  PSW(0x01, GPIOITCR);             /*To read some Integration Test Registers Integration
                                   test mode must be set                              */
  PSR(0x00000000, NoMask, GPIOITIP1,ITIP1); 
  PSR(0x00000000, NoMask, GPIOITIP2,ITIP2);
  PSR(0x00000000, NoMask, GPIOITOP1,ITOP1); 
  PSR(0x00000000, NoMask, GPIOITOP2,ITOP2); 
  PSR(0x00000000, NoMask, GPIOITOP3,ITOP3);
  PSW(0x00, GPIOITCR);             /*Integration Test Mode Disabled*/  

  PSR(0x00000061, NoMask, GPIOPeriphID0,P_ID0);
  PSR(0x00000010, NoMask, GPIOPeriphID1,P_ID1);
  PSR(0x00000004, NoMask, GPIOPeriphID2,P_ID2);
  PSR(0x00000000, NoMask, GPIOPeriphID3,P_ID3);

  PSR(0x0000000D, NoMask, GPIOPCellID0,O_ID1);
  PSR(0x000000F0, NoMask, GPIOPCellID1,O_ID2);
  PSR(0x00000005, NoMask, GPIOPCellID2,O_ID3);
  PSR(0x000000B1, NoMask, GPIOPCellID3,O_ID4);
}
