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
//  File Name           :helloworld.c,v
//  File Revision       :1.4
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : EASY world C Hello World program
//
//--========================================================================--

#include "tube.h"
#include "encache.h"
#include <stdio.h>


#define MESSAGE "Hello, World!\n"


// Function prototypes
int main(void);



//----------------------------------------------------------------------------
// main ()
// Entry point for C code
//----------------------------------------------------------------------------

int main(void)
{
  // Intialise cache if available
  initCache();

  // Display a simple message
  printf (MESSAGE);

}
  

// end of file helloworld.c
