/* --=================================================================--
-- This confidential and proprietary software may be used only as
-- authorised by a licensing agreement from ARM Limited
--   (C) COPYRIGHT 2000 ARM Limited
--       ALL RIGHTS RESERVED
-- The entire notice above must be reproduced on all authorised
-- copies and copies may only be made to the extent permitted
-- by a licensing agreement from ARM Limited.
--
-- ---------------------------------------------------------------------
-- Version and Release Control Information:
--
-- File Name              : Uart_Integ.c.rca
-- File Revision          : 1.3
--
-- Release Information    : PrimeCell(TM)-PL011-REL1v3
--
-- ---------------------------------------------------------------------
-- Purpose : This C code file is used to generate BusTalk vectors.
--             BusTalk vectors are applied to the AMBA APB bus.
--
--   Files required for compilation:
--     makefile, busheader.h, busmacros.h, busmacros.c,
--     config.h, addargs_script,
--     Uart.h, Uart_Integ.c
--
--   Usage: make <testname> e.g. make Uart_Integ
--
--   To create .bif formatted vectors from the BusTalk code (default)
--     make <testname> e.g. make Uart_Integ
--   This will create testname.bif in the ./invec directory
--
-- --=================================================================*/
 
/**********************************************************************/
/*** For more information on the UART, please refer to PL011 AMBA    ***/
/*** UART Block Specification                                        ***/
/**********************************************************************/


void ResetRead(void)
{
  PSR(0x00, UARTRSR_MASK, UARTRSR,uartrsr);
  PSR(0x00, UARTLCR_H_new_MASK, UARTLCR_H_new,uartlcr_h);
  PSR(0x300, UARTCR_newMASK, UARTCR_new,uartcr_new);
  PSR(0x90, 0x1ff, UARTFR,uartfr); 
  PSR(0x00, UARTILPR_MASK, UARTILPR,uartilpr);
  PSR(0x00, UARTIBRD_MASK, UARTIBRD,uartibrd);  
  PSR(0x00, UARTFBRD_MASK, UARTFBRD,uartfbrd);  
  PSR(0x12, UARTIFLS_MASK, UARTIFLS,uartifls);
  PSR(0x00, UARTIMSC_MASK, UARTIMSC,uartimsc);
  PSR(0x00, UARTRIS_MASK, UARTRIS,uartris);
  PSR(0x00, UARTMIS_MASK, UARTMIS,uartmis);
  PSR(0x00, UARTDMACR_MASK, UARTDMACR,uartdma);

  PSR(0x00, UARTTCR_MASK,  UARTTCR,uarttcrread);
  PSR(0x00, UARTITOP_MASK, UARTITOP,uartitopread);
 
  
  PSR(0x11, MASK_IDREG, PeripheralID0,id1);
  PSR(0x10, MASK_IDREG, PeripheralID1,id2);
  PSR(0x04, MASK_IDREG, PeripheralID2,id3);
  PSR(0x00, MASK_IDREG, PeripheralID3,id4);
  PSR(0x0D, MASK_IDREG, PrimeCellID0,id5);
  PSR(0xF0, MASK_IDREG, PrimeCellID1,id6);
  PSR(0x05, MASK_IDREG, PrimeCellID2,id7);
  PSR(0xB1, MASK_IDREG, PrimeCellID3,id8);
  
}


void IntegrationTest(void)
{
  C("Integration Test");
  
    /* IntegrationTest:
     ================
     When the UART is used in an AMBA system, it must be ensured that
     all of its pins are correctly connected. Integration vectors
     allow the usr to verify that the UART has been wired into the
     system correctly.
  */

  /* Testing of Intra-Chip inputs (UARTTXDMACLR, UARTRXDMACLR) :
     The procedure is given below.
     - Write a 1 to the ITEN bit in the Control register. This selects
       the test path from the UARTITIP[7:6] register bit to the internal
       UARTTXDMACLR and UARTRXDMACLR signals.
     - Write a 1 and then a 0 to the UARTITIP[7:6] register bits and read
       the same register bit to ensure that the value written is read
       out.

     When integration tests are run in an integrated system '1' and '0'
     are actually written into internal registers of DMA controller so as to
     toggle the UARTTXDMACLR signal connection between the DMA controller and
     the UART.  Read from UARTITIP[7] to verfiy the connectivity.
     Similarly a '1' and '0' are written to the DMA Controolers internal register
     to toggle the UARTRXDMACLR signalconnection betweenn DMAC and the UART.
     Read from the UARTITIP[6] to verify conectivity.
  */ 

  C("Integration Tests for the UART");

  C("Testing Intra Chip Input connection");
  
  /* Enable Integration testing of the UART by setting the ITEN
     bit in the UARTTCR register */
  PSW(0x0001, UARTTCR);
  
  /* Set the UARTTXDMACLR input */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to 
            set the UARTTXDMACLR output signal from the DMA controller */
  PSW(0x80, UARTITIP); 

  /* Read the value on the UARTTXDMACLR input */ 
  PSR(0x80, INTIP_MASK, UARTITIP,int1);

  /* Clear the UARTTXDMACLR input */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to 
            clear the UARTTXDMACLR output signal from the DMA controller */
  PSW(0x00000000, UARTITIP); 

  /* Read the value on the UARTTXDMACLR input */ 
  PSR(0x00000000, INTIP_MASK, UARTITIP,int2);

  
  /* Set the UARTRXDMACLR input */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to 
            set the UARTRXDMACLR output signal from the DMA controller */
  PSW(0x40, UARTITIP); 

  /* Read the value on the UARTRXDMACLR input */ 
  PSR(0x40, INTIP_MASK, UARTITIP,int3);

  /* Clear the UARTRXDMACLR input */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this write with a suitable command to 
            clear the UARTRXDMACLR output signal from the DMA controller */
  PSW(0x00000000, UARTITIP); 

  /* Read the value on the UARTRXDMACLR input */ 
  PSR(0x00000000, INTIP_MASK, UARTITIP,int4);

  /* Testing primary inputs and primary outputs :
     SIRIN, UARTRXD, nUARTDSR, nUARTCTS, nUARTDCD, and nUARTRI are tested
     using the Integration vector trickbox by looping back the primary
     outputs( nSIROUT, UARTTXD, nUARTDTR, nUARTRTS, nUARTOut1 and nUARTOut2.
     '1's and '0's are driven onto the primary output lines via the UARTITOP
     register bits[5:0] and read back via the UARTITIP register bits[5:0].
     When the UARTITOP register is written to, a read is performed to check
     the contents.
  */
  
  C("Testing Primary Input and Primary Output connections");

   PSW(0x0001, UARTTCR);
 
   /* UARTTXD and UARTRXD */
   
  PSW(0x0001, UARTITOP);
  PSR(0x0001, PIP_MASK, UARTITOP, read1);
  PSR(0x0001, PIP_MASK, UARTITIP,int5);

  PSW(0x0000, UARTITOP); 
  PSR(0x0000, PIP_MASK, UARTITOP, read2);
  PSR(0x0000, PIP_MASK, UARTITIP,int6);

  /* nSIROUT and SIRIN */

  PSW(0x0002, UARTITOP); 
  PSR(0x0002, PIP_MASK, UARTITOP, read3);
  PSR(0x0002, PIP_MASK, UARTITIP,int7);

  PSW(0x0000, UARTITOP); 
  PSR(0x0000, PIP_MASK, UARTITOP, read4);
  PSR(0x0000, PIP_MASK, UARTITIP,int8);

  /* nUARTDTR and nUARTDSR */

  PSW(0x0004, UARTITOP);
  PSR(0x0004, PIP_MASK, UARTITOP, read5);
  PI(2);
  PSR(0x0004, PIP_MASK, UARTITIP,int9);

  PSW(0x0000, UARTITOP); 
  PSR(0x0000, PIP_MASK, UARTITOP, read6);
  PI(2);
  PSR(0x0000, PIP_MASK, UARTITIP,int10);

  /* nUARTRTS and nUARTCTS */

  PSW(0x0008, UARTITOP); 
  PSR(0x0008, PIP_MASK, UARTITOP, read7);
  PI(2);
  PSR(0x0008, PIP_MASK, UARTITIP,int11);

  PSW(0x0000, UARTITOP); 
  PSR(0x0000, PIP_MASK, UARTITOP, read8);
  PI(2);
  PSR(0x0000, PIP_MASK, UARTITIP,int12);

  /* nUARTOut1 and nUARTDCD */

  PSW(0x0010, UARTITOP); 
  PSR(0x0010, PIP_MASK, UARTITOP, read9);
  PI(2);
  PSR(0x0010, PIP_MASK, UARTITIP,int13);

  PSW(0x0000, UARTITOP); 
  PSR(0x0000, PIP_MASK, UARTITOP, read10);
  PI(2);
  PSR(0x0000, PIP_MASK, UARTITIP,int14);
  
  /* nUARTOut2 and nUARTRI */

  PSW(0x0020, UARTITOP); 
  PSR(0x0020, PIP_MASK, UARTITOP, read11);
  PI(2);
  PSR(0x0020, PIP_MASK, UARTITIP,int15);

  PSW(0x0000, UARTITOP); 
  PSR(0x0000, PIP_MASK, UARTITOP, read12);
  PI(2);
  PSR(0x0000, PIP_MASK, UARTITIP,int16);
  

  
  /* Testing of Intra-Chip Outputs:
     The procedure is given below.
     - Write a 1 to the ITEN bit in the Control register. This selects 
       the test path from the UARTITOP[15:6] register bits.
     - Write a 1 and then a 0 to the UARTITOP[15:6] register bit and read 
       the same register bit to ensure that the value written is read 
       out.

       When integration tests are run in an integrated system '1' and '0'
       are written to the UARTITOP[15:6] register bits so as to toggle the 
       signal connections between the UART and the DMA Controller/ 
       Interrupt controller. Read from the DMA Controller/ Interrupt 
       controller's internal registers to verify that the value written 
       into the UARTITOP[15:6] register bits is read out through the 
       DMA controller/ Interrupt Controller.
  */ 
 
  C("Testing Intra Chip Output connections");
  PSW(0x00000001, UARTTCR); 

  /* Set the UARTTXDMASREQ bit */
  PSW(0x8000, UARTITOP);

  /* Read the value on the intra-chip outputs of the UART */
  /* NOTE : When the tests are run in an integrated system, the user is
            expected to replace this read(and the following reads with
	    suitable commands to read the values on these lines through
	    the destination peripherals (DMA Controller/Interrupt Controller) */
  PSR(0x8000, INTOP_MASK, UARTITOP,int17);

  /* Clear the UARTTXDMASREQ bit */
  PSW(0x0000, UARTITOP);

  PSR(0x0000, INTOP_MASK, UARTITOP,int18);

  
  /* Set the UARTTXDMABREQ bit */
  PSW(0x4000, UARTITOP);

  /* Read the value on the intra-chip outputs of the UART */
  PSR(0x4000, INTOP_MASK, UARTITOP,int19);

  /* Clear the UARTTXDMABREQ bit */
  PSW(0x0000, UARTITOP);

  PSR(0x0000, INTOP_MASK, UARTITOP,int20);
 
  /* Set the UARTRXDMASREQ bit */
  PSW(0x2000, UARTITOP);

  /* Read the value on the intra-chip outputs of the UART */
  PSR(0x2000, INTOP_MASK, UARTITOP,int21);

  /* Clear the UARTRXDMASREQ bit */
  PSW(0x0000, UARTITOP);

  PSR(0x0000, INTOP_MASK, UARTITOP,int22);

  /* Set the UARTRXDMABREQ bit */
  PSW(0x1000, UARTITOP);

  /* Read the value on the intra-chip outputs of the UART */
  PSR(0x1000, INTOP_MASK, UARTITOP,int23);

  /* Clear the UARTRXDMABREQ bit */
  PSW(0x0000, UARTITOP);

  PSR(0x0000, INTOP_MASK, UARTITOP,int24);

  /* Set the UARTMSINTR bit */
  PSW(0x0800, UARTITOP);

  /* Read the value on the intra-chip outputs of the UART */
  PSR(0x0800, INTOP_MASK, UARTITOP,int25);

  /* Clear the UARTMSINTR bit */
  PSW(0x0000, UARTITOP);

  PSR(0x0000, INTOP_MASK, UARTITOP,int26);

  /* Set the UARTRXINTR bit */
  PSW(0x0400, UARTITOP);

  /* Read the value on the intra-chip outputs of the UART */
  PSR(0x0400, INTOP_MASK, UARTITOP,int27);

  /* Clear the UARTRXINTR bit */
  PSW(0x0000, UARTITOP);

  PSR(0x0000, INTOP_MASK, UARTITOP,int28);

  /* Set the UARTTXINTR bit */
  PSW(0x0200, UARTITOP);

  /* Read the value on the intra-chip outputs of the UART */
  PSR(0x0200, INTOP_MASK, UARTITOP,int29);

  /* Clear the UARTTXINTR bit */
  PSW(0x0000, UARTITOP);

  PSR(0x0000, INTOP_MASK, UARTITOP,int30);

  /* Set the UARTRTINTR bit */
  PSW(0x0100, UARTITOP);

  /* Read the value on the intra-chip outputs of the UART */
  PSR(0x0100, INTOP_MASK, UARTITOP,int31);

  /* Clear the UARTRTINTR bit */
  PSW(0x0000, UARTITOP);

  PSR(0x0000, INTOP_MASK, UARTITOP,int32);

  /* Set the UARTEINTR bit */
  PSW(0x0080, UARTITOP);

  /* Read the value on the intra-chip outputs of the UART */
  PSR(0x0080, INTOP_MASK, UARTITOP,int33);

  /* Clear the UARTEINTR bit */
  PSW(0x0000, UARTITOP);

  PSR(0x0000, INTOP_MASK, UARTITOP,int34);

  /* Set the UARTINTR bit */
  PSW(0x0040, UARTITOP);

  /* Read the value on the intra-chip outputs of the UART */
  PSR(0x0040, INTOP_MASK, UARTITOP,int35);

  /* Clear the UARTINTR bit */
  PSW(0x0000, UARTITOP);

  PSR(0x0000, INTOP_MASK, UARTITOP,int36);


  PSW(0x0000,UARTTCR);

  
}
