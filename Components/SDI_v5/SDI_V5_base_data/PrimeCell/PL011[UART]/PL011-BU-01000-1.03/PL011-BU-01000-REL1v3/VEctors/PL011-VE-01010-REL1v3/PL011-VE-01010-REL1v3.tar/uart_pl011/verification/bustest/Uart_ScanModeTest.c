/*------------------------------------------------------------------------------
--  This confidential and proprietary software may be used only as
--  authorised by a licensing agreement from ARM Limited
--    (C) COPYRIGHT 2000 ARM Limited
--        ALL RIGHTS RESERVED
--  The entire notice above must be reproduced on all authorised
--  copies and copies may only be made to the extent permitted
--  by a licensing agreement from ARM Limited.
--------------------------------------------------------------------------------
--  
--  Version and Release Control Information:
--
--  File Name              : Uart_ScanModeTest.c.rca
--  File Revision          : 1.1
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose: This file has the function ScanModeTest which is called in
   the main file Uart.c
/******************************************************************************/

/******************************************************************************/
/*************************** ScanModeTest *************************************/
/******************************************************************************/

void ScanModeTest(void)
{
  /*
    Summary: Scan Mode Test
    =======================

    This test is for validating the UART scan test hold input. In this, Two
    known data patterns are written into two writable register. A test reset 
    is asserted by setting and clearing the TESTRST bit in the UARTTCR of the
    UART. After this test reset, the two writable registers should be reset to
    their reset values. Now the same test is conducted with SCANMODE pin, 
    driven HIGH. This time the two register should retain the two known data
    patterns.
  
  */

  /* Write some data to two r/w registers */
  PSW(DATA_As, UARTCR_new);
  PSW(DATA_5s, UARTILPR);

  /* Assert Test reset */
  PSW(UART_TESTRST, UARTTCR);

  /* Deassert Test reset in next cycle */
  PSW(0x00, UARTTCR);

  PSR(0x300, UARTCR_newMASK, UARTCR_new,uartcr_new1);
  PSR(0x00, UARTILPR_MASK, UARTILPR,uartilpr1);

  /* Now conduct the same test with scanmode asserted */

  /* Assert Scanmode pin */
  PSW(UT_SET_SCANMODE , UT_SET_PINS);

  /* Write some data to two r/w registers */
  PSW(DATA_As, UARTCR_new);
  PSW(DATA_5s, UARTILPR);

  /* Assert Test reset */
  PSW(UART_TESTRST, UARTTCR);

  /* Deassert Test reset in next cycle */
  PSW(0x00, UARTTCR);

  PSR(DATA_As & UARTCR_newMASK, UARTCR_newMASK, UARTCR_new,uartcr_new2);
  PSR(DATA_5s & UARTILPR_MASK, UARTILPR_MASK, UARTILPR,uartilpr2);

  /* Clean up */

  PSW(IRLP_DIV, UARTILPR);
  PSW(IRLP_DIV, UTILPR);
  PSW(0x00, UARTCR_new);
  PSW(0x0f, UT_SET_PINS);

}
