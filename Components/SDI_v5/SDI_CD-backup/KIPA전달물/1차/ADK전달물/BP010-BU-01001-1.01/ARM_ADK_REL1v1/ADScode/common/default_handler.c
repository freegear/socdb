//--========================================================================--
// This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT  2001 ARM Limited
//       ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           :default_handler.c,v
//  File Revision       :1.4
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Default exception handlers
//
//--========================================================================--


#include <stdio.h>
#include <stdlib.h>
#include "default_handler.h"

//----------------------------------------------------------------------------
// These default handlers handle all exceptions, except when alternative 
// handlers have been installed.
// Each Prints a message to the standard output and exits.
//----------------------------------------------------------------------------

void default_reset_Handler(void)
{
  printf( "*** Unexpected Reset exception ***\n" );
  exit(-1);
}
void default_undefined_Handler(void)
{
  printf( "*** Unexpected Undefined exception ***\n" );
  exit(-1);
}
void default_swi_Handler(void)
{
  printf( "*** Unexpected SWI exception ***\n" );
  exit(-1);
}
void default_prefetchAbort_Handler(void)
{
  printf( "*** Unexpected Prefetch Abort exception ***\n" );
  exit(-1);
}
void default_dataAbort_Handler(void)
{
  printf( "*** Unexpected Data Abort exception ***\n" );
  exit(-1);
}
void default_irq_Handler(void)
{
  printf( "*** Unexpected IRQ exception ***\n" );
  exit(-1);
}

void default_fiq_Handler(void)
{
  printf( "*** Unexpected FIQ exception ***\n" );
  exit(-1);
}


  
// end of file default_handler.c