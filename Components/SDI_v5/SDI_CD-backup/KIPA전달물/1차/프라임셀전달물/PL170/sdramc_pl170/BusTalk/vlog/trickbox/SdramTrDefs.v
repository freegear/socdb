//  ----------------------------------------------------------------------------
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : $RCS: $
//  File Revision          : 1.2
//
//  Release Information    : PrimeCell(TM)-PL170-REL2v2
//
//  ----------------------------------------------------------------------------

//  ----------------------------------------------------------------------------
//   Purpose      : Contains Header Information for the TrickBox
//  ----------------------------------------------------------------------------

//  ----------------------------------------------------------------------------
//  Define the Bus Width 
//  ----------------------------------------------------------------------------
`define BusWidth       32

//  ----------------------------------------------------------------------------
//  Range and Width Definitions
//  ----------------------------------------------------------------------------
`define ADDMSB         7  + `BusWidth/64
`define ADDLSB         2  + `BusWidth/64
`define ADDWIDTH       10 + `BusWidth/64

`define PORDelay       1
