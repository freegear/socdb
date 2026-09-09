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
--  File Name              : Uart_Reg_Tests.c.rca
--  File Revision          : 1.8
--
--  Release Information    : PrimeCell(TM)-PL011-REL1v3
--  
------------------------------------------------------------------------------*/

/******************************************************************************/
/* Purpose : This file has the function RegisterTests
             which are called in the main file Uart.c                         */
/******************************************************************************/

/******************************************************************************/
/************************** RegisterTests *************************************/
/******************************************************************************/

void RegisterTests()
{

  /*
    Summary: Register Test
    ======================
    This test checks the following functionalities :
 
    o  All UART registers are read immediately after reset to verify
    that they initialise to values mentioned in the specification.
 
    o  The Read/Writeable registers are written with patterns of 0x55
    and 0xAA. Data is read back and compared with the expected pattern.
   */

  C("Reset Test");
  PSR(0x00, UARTRSR_MASK, UARTRSR,uartrsr);
  PSR(0x00, UARTLCR_H_new_MASK, UARTLCR_H_new,uartlcr_h);
  PSR(0x300, UARTCR_newMASK, UARTCR_new,uartcr_new);
  PSR(0x90, masks[8], UARTFR,uartfr); 
  PSR(0x00, UARTILPR_MASK, UARTILPR,uartilpr);
  PSR(0x00, UARTIBRD_MASK, UARTIBRD,uartibrd);  
  PSR(0x00, UARTFBRD_MASK, UARTFBRD,uartfbrd);  
  PSR(0x12, UARTIFLS_MASK, UARTIFLS, uartifls);
  PSR(0x00, UARTIMSC_MASK, UARTIMSC, uartimsc);
  PSR(0x00, UARTRIS_MASK, UARTRIS, uartris);
  PSR(0x00, UARTMIS_MASK, UARTMIS, uartmis);
  PSR(0x00, UARTDMACR_MASK, UARTDMACR,uartdma);

  PSR(0x11, MASK_IDREG, PeripheralID0);
  PSR(0x10, MASK_IDREG, PeripheralID1);
  PSR(0x24, MASK_IDREG, PeripheralID2);
  PSR(0x00, MASK_IDREG, PeripheralID3);
  PSR(0x0D, MASK_IDREG, PrimeCellID0);
  PSR(0xF0, MASK_IDREG, PrimeCellID1);
  PSR(0x05, MASK_IDREG, PrimeCellID2);
  PSR(0xB1, MASK_IDREG, PrimeCellID3);

    


  /* Test Registers */
  PSR(0x00 , UARTTCR_MASK,  UARTTCR,uarttcr);
  PSR(0x00, UARTITOP_MASK, UARTITOP,uartitopread);
  
  
  C("UART Register Test");  

  PSW(DATA_As, UARTIBRD,uartibrd);
  PSR(DATA_As & UARTIBRD_MASK, UARTIBRD_MASK, UARTIBRD,uartibrd);
  PSW(DATA_5s, UARTIBRD,uartibrd);
  PSR(DATA_5s & UARTIBRD_MASK, UARTIBRD_MASK, UARTIBRD,uartibrd);

  PSW(DATA_As, UARTFBRD,uartfbrd);
  PSR(DATA_As & UARTFBRD_MASK, UARTFBRD_MASK, UARTFBRD,uartfbrd);
  PSW(DATA_5s, UARTFBRD,uartfbrd);
  PSR(DATA_5s & UARTFBRD_MASK, UARTFBRD_MASK, UARTFBRD,uartfbrd);
  
  PSW(DATA_As, UARTLCR_H_new,uartlcr_h_new);
  PSR(DATA_As & UARTLCR_H_new_MASK, UARTLCR_H_new_MASK, UARTLCR_H_new,uartlcr_h_new); 
  PSW(DATA_5s, UARTLCR_H_new,uartlcr_h_new);
  PSR(DATA_5s & UARTLCR_H_new_MASK, UARTLCR_H_new_MASK, UARTLCR_H_new,uartlcr_h_new);
    
  PSW(DATA_As, UARTCR_new,uartcr_new);
  PSR(DATA_As & UARTCR_newMASK, UARTCR_newMASK,  UARTCR_new,uartcr_new);
  PSW(DATA_5s, UARTCR_new,uartcr_new);
  PSR(DATA_5s & UARTCR_newMASK, UARTCR_newMASK,  UARTCR_new,uartcr_new);

  PSW(DATA_As, UARTILPR,uartilpr);
  PSR(DATA_As & UARTILPR_MASK, UARTILPR_MASK, UARTILPR,uartilpr);
  PSW(DATA_5s, UARTILPR,uartilpr);
  PSR(DATA_5s & UARTILPR_MASK, UARTILPR_MASK, UARTILPR,uartilpr);

  PSW(DATA_As, UARTIFLS,uartifls);
  PSR(DATA_As & UARTIFLS_MASK, UARTIFLS_MASK, UARTIFLS,uartifls);
  PSW(DATA_5s, UARTIFLS,uartifls);
  PSR(DATA_5s & UARTIFLS_MASK, UARTIFLS_MASK, UARTIFLS,uartifls);

  PSW(DATA_As, UARTIMSC,uartimsc);
  PSR(DATA_As & UARTIMSC_MASK, UARTIMSC_MASK, UARTIMSC,uartimsc);
  PSW(DATA_5s, UARTIMSC,uartimsc);
  PSR(DATA_5s & UARTIMSC_MASK, UARTIMSC_MASK, UARTIMSC,uartimsc);

  PSW(DATA_As, UARTDMACR,uartdma);    
  PSR(DATA_As & UARTDMACR_MASK, UARTDMACR_MASK, UARTDMACR,uartdma);
  PSW(DATA_5s, UARTDMACR,uartdma);
  PSR(DATA_5s & UARTDMACR_MASK, UARTDMACR_MASK, UARTDMACR,uartdmacr);

  PSW(DATA_As, PeripheralID0);
  PSR(0x11, MASK_IDREG, PeripheralID0);
  PSW(DATA_5s, PeripheralID0);
  PSR(0x11, MASK_IDREG, PeripheralID0);
  
  PSW(DATA_As, PeripheralID1);
  PSR(0x10, MASK_IDREG, PeripheralID1);
  PSW(DATA_5s, PeripheralID1);
  PSR(0x10, MASK_IDREG, PeripheralID1);
  
  PSW(DATA_As, PeripheralID2);
  PSR(0x24, MASK_IDREG, PeripheralID2);
  PSW(DATA_5s, PeripheralID2);
  PSR(0x24, MASK_IDREG, PeripheralID2);
  
  PSW(DATA_As, PeripheralID3);
  PSR(0x00, MASK_IDREG, PeripheralID3);
  PSW(DATA_5s, PeripheralID3);
  PSR(0x00, MASK_IDREG, PeripheralID3);
  
  PSW(DATA_As, PrimeCellID0);
  PSR(0x0D, MASK_IDREG, PrimeCellID0);
  PSW(DATA_5s, PrimeCellID0);
  PSR(0x0D, MASK_IDREG, PrimeCellID0);
  
  PSW(DATA_As, PrimeCellID1);
  PSR(0xF0, MASK_IDREG, PrimeCellID1);
  PSW(DATA_5s, PrimeCellID1);
  PSR(0xF0, MASK_IDREG, PrimeCellID1);
  
  PSW(DATA_As, PrimeCellID2);
  PSR(0x05, MASK_IDREG, PrimeCellID2);
  PSW(DATA_5s, PrimeCellID2);
  PSR(0x05, MASK_IDREG, PrimeCellID2);
  
  PSW(DATA_As, PrimeCellID3);
  PSR(0xB1, MASK_IDREG, PrimeCellID3);
  PSW(DATA_5s, PrimeCellID3);
  PSR(0xB1, MASK_IDREG, PrimeCellID3);
  
   
  /*  Test Registers */

  PSW(DATA_As, UARTTCR,uarttcr);
  PSR(DATA_As & UARTTCR_MASK, UARTTCR_MASK,  UARTTCR,uarttcr);
  PSW(DATA_5s, UARTTCR,uarttcr);
  PSR(DATA_5s & UARTTCR_MASK, UARTTCR_MASK,  UARTTCR,uarttcr);

  
  PSW(DATA_As, UARTITOP,uartitop);
  PSR(DATA_As & UARTITOP_MASK, UARTITOP_MASK,  UARTITOP,uartitop);
  PSW(DATA_5s, UARTITOP,uartitop);
  PSR(DATA_5s & UARTITOP_MASK, UARTITOP_MASK,  UARTITOP,uartitop);


}
