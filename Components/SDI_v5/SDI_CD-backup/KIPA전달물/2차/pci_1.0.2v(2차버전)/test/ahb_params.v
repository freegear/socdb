//----------------------------------------------------------------------
//
// Copyright (c) 2003-2004 CAST, Inc.
//
// Please review the terms of the license agreement before using this
// file.  If you are not an authorized user, please destroy this source
// code file and notify CAST immediately that you inadvertently received
// an unauthorized copy.
//----------------------------------------------------------------------
//
//  Project       : PCI-HBAHB
//
//  File          : ahb_params.v
//
//  Dependencies  : 
//
//  Model Type:   : Synthesizable core
//
//  Description   : AHB Constants Parameters
//
//  Designer      : AS
//
//  QA Engineer   : 
//
//  Creation Date : 15-December-2003
//
//  Last Update   : 30-January-2004
//
//  Version       : 1.0.2V
//----------------------------------------------------------------------
   // HTRANS = Transfer Type
   parameter[1:0] HTRANS_IDLE = 2'b00; 
   parameter[1:0] HTRANS_BUSY = 2'b01; 
   parameter[1:0] HTRANS_NONSEQ = 2'b10; 
   parameter[1:0] HTRANS_SEQ = 2'b11; 
   // HBURST = Burst Type
   parameter[2:0] HBURST_SINGLE = 3'b000; 
   parameter[2:0] HBURST_INCR   = 3'b001; 
   parameter[2:0] HBURST_WRAP4  = 3'b010; 
   parameter[2:0] HBURST_INCR4  = 3'b011; 
   parameter[2:0] HBURST_WRAP8  = 3'b100; 
   parameter[2:0] HBURST_INCR8  = 3'b101; 
   parameter[2:0] HBURST_WRAP16 = 3'b110; 
   parameter[2:0] HBURST_INCR16 = 3'b111; 
   // HRESP = Slave Response
   parameter[1:0] HRESP_OKAY  = 2'b00; 
   parameter[1:0] HRESP_ERROR = 2'b01; 
   parameter[1:0] HRESP_RETRY = 2'b10; 
   parameter[1:0] HRESP_SPLIT = 2'b11; 
   // HSIZE = Transfer Size
   parameter[2:0] HSIZE_1B = 3'b000; // one byte size
   parameter[2:0] HSIZE_2B = 3'b001; // two byte size (WORD)
   parameter[2:0] HSIZE_4B = 3'b010; // four byte size (DWORD)
   parameter[2:0] HSIZE_8B = 3'b011; // eight byte size (QWORD)
