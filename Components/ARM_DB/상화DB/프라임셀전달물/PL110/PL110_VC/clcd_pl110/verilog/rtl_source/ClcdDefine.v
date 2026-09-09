// --=========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2002 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : ClcdDefine.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL110-r1p2-00ltd0
//  
//  ----------------------------------------------------------------------------
//  Purpose                : This file contains the definitions for global 
//                           constants
//
// --=========================================================================--

`define IDLE   2'b00            //  HTRANS IDLE value.
`define BUSY   2'b01            //  HTRANS BUSY value.
`define NSEQ   2'b10            //  HTRANS Non-Sequential value.
`define SEQ    2'b11            //  HTRANS Sequential value.
`define OKAY   2'b00            //  HRESP  for OKAY response value.
`define ERRR   2'b01            //  HRESP  for ERROR response value.
`define RETRY  2'b10            //  HRESP  for RETRY response value.
`define SPLIT  2'b11            //  HRESP  for SPLIT response value.

