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
//  File Name           :retarget.c,v
//  File Revision       :1.8
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : This file is a port of retarget.c from the ADS 1.1
//                        rom/ledflash example to use the "tube" provided in  
//                        EASY for output. 
//                                        
//                        This file implements a 'retarget' layer for
//                        low-level I/O. Typically, this would contain your  
//                        own target-dependent implementations of fputc(),     
//                        ferror(), etc. This example provides implementations 
//                        of fputc(), ferror(), _sys_exit(), _ttywrch() and    
//                        __user_initial_stackheap().  
//                        
//                        Documentation on this is contained in the ADS 1.1  
//                        Developer Guide, chapter 6, "Writing Code for ROM".  
//
//--========================================================================--


//------------------------------------------------------------------------
// Includes
//------------------------------------------------------------------------

#include <stdio.h>
#include <rt_misc.h>
#include <rt_sys.h>

#include "tube.h"

//------------------------------------------------------------------------
// Defines and Typedefs
//------------------------------------------------------------------------

struct __FILE { 
  int handle;   
  // Add whatever you need here 
  };

extern unsigned startOfHeap;

//------------------------------------------------------------------------
// Variables
//------------------------------------------------------------------------

FILE __stdout;

//----------------------------------------------------------------------------
// fputc ()
// Writes a character to Tube enabling text output to a text file and 
// simulator display
//----------------------------------------------------------------------------
int fputc(int ch, FILE *f)
{
  // Place your implementation of fputc here
  // e.g. write a character to a UART,
  // or to the debugger console with SWI WriteC
 
  IGNORE( f );
  
  tube = ch;        // output to text file and simulator display
  return ch;
}


//----------------------------------------------------------------------------
// ferror ()
// Returns End-Of-File
//----------------------------------------------------------------------------
int ferror(FILE *f)
{   
  // Your implementation of ferror
  IGNORE( f );  
  return EOF;
}

//----------------------------------------------------------------------------
// _sys_exit ()
// Writes EOT to Tube
//----------------------------------------------------------------------------
void _sys_exit(int return_code)
{
  IGNORE( return_code );
  tube= EOT;
}

//----------------------------------------------------------------------------
// _ttywrch ()
// Writes a character to Tube
//----------------------------------------------------------------------------
void _ttywrch(int ch)
{
  tube = ch;
}

//----------------------------------------------------------------------------
// __user_initial_stackheap ()
// Sets up user stack and heap
//----------------------------------------------------------------------------
__value_in_regs struct __initial_stackheap __user_initial_stackheap(
        unsigned R0, unsigned SP, unsigned R2, unsigned SL)
{
  struct __initial_stackheap config;
    
  IGNORE( R0 );
  IGNORE( R2 );
  IGNORE( SL );
    
  config.heap_base = startOfHeap;
  config.stack_base = SP;


// To place heap_base directly above the ZI area, use e.g:
//    extern unsigned int Image$$ZI$$Limit;
//    config.heap_base = (unsigned int)&Image$$ZI$$Limit;
// (or &Image$$region_name$$ZI$$Limit for scatterloaded images)
//
// To specify the limits for the heap & stack, use e.g:
//    config.heap_limit = SL;
//    config.stack_limit = SL;

  return config;
}


// end of file retarget.c