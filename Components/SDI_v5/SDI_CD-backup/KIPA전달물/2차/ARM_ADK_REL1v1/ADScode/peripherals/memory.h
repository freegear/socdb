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
//  File Name           :memory.h,v
//  File Revision       :1.4
//
//  Release Information :ADK_REL1v1
//
//----------------------------------------------------------------------------
//
//  Purpose             : Definitions for memory tests
//
//--========================================================================--

#ifndef MEMORY_H
#define MEMORY_H

#include "globals.h"

// Test values
#define TEST_VAL_1 0x12345678
#define TEST_VAL_2 0x91827364
#define TEST_VAL_3 0xA1B2C3D4

#define BURST_VAL_0 0x0000FFFF
#define BURST_VAL_1 0xFFFF0000
#define BURST_VAL_2 0x2222ABCD
#define BURST_VAL_3 0x3333E0F0
#define BURST_VAL_4 0x44442342
#define BURST_VAL_5 0x55552485
#define BURST_VAL_6 0x6666A8D5
#define BURST_VAL_7 0x77775831


#define BURST_ARRAY_SIZE 8


// Typedefs
typedef volatile union t_MemUnion
{

  Word w;
  struct {Byte b1,b2,b3,b4;} b;
  struct {HalfWord h1,h2;} h;
  
} MemUnion;

// Data Areas in Memory used for testing
extern MemUnion IntRam;
extern MemUnion ExtRam1;
extern MemUnion ExtRam2;

extern Word ExtRam1Array[BURST_ARRAY_SIZE];
extern Word ExtRam2Array[BURST_ARRAY_SIZE];
extern Word IntRamArray[BURST_ARRAY_SIZE];

extern volatile const Word ExtRom;
extern volatile const Word ExtRomArray[BURST_ARRAY_SIZE];



#endif // defined( MEMORY_H )

// end of file memory.h