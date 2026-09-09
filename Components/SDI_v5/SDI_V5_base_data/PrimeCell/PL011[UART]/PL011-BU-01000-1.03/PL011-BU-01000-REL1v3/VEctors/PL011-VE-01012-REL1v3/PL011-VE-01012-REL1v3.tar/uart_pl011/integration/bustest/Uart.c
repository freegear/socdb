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
-- File Name              : Uart.c.rca
-- File Revision          : 1.6
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
--     Uart.h, Uart.c, Uart_Integ.c
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

/******************************************************************************/
/***************** System Clock Defines ***************************************/
/******************************************************************************/


#define UARTCLK_PERIOD     10 
#define PCLK_PERIOD        10

unsigned int wait_factor;

#if defined(INTEGRATION_TESTS) || defined(ALL_TESTS) 
#include "UartCommon.c"
#endif

#if defined(INTEGRATION_TESTS) || defined(ALL_TESTS) 
#include "Uart_Integ.c"
#endif

/**********************************************************************/
/********************************  MAIN  ******************************/
/**********************************************************************/

int main()
{

  int32 expr; 

  C("---------------------------------------------------------------------",header);
  C("  This confidential and proprietary software may be used only",header);
  C("  as authorised by a licensing agreement from ARM Limited",header);
  C("    (C) COPYRIGHT 2000 ARM Limited",header);
  C("        ALL RIGHTS RESERVED",header);
  C("  The entire notice above must be reproduced on all authorised copies",header);
  C(" and copies may only be made to the extent permitted by a",header);
  C("  licensing agreement from ARM Limited.",header);
  C("---------------------------------------------------------------------",header);
  C(" ",header);
  C("Version and Release Control Information:",header);
  C(" ",header);
  C("File Name              : Uart.c.rca",header);
  C("File Revision          : 1.6",header);
  C(" ",header);
  C("Release Information    : PrimeCell(TM)-PL011-REL1v3",header);
  C("---------------------------------------------------------------------",header);
   TestStart();
 
   RES(LOW,0x1,0x2);
   PI(0x02);
   PI(10);
   
#if defined(INTEGRATION_TESTS) || defined(ALL_TESTS)
   C("Reset read Test");
   ResetRead();
#endif
   
   
#if defined(INTEGRATION_TESTS) || defined(ALL_TESTS)   
   C("Integration Tests");
   IntegrationTest();
#endif

   
   C("Test End"); 

   TestEnd();
   return 0;

}


/************************************ End *************************************/

