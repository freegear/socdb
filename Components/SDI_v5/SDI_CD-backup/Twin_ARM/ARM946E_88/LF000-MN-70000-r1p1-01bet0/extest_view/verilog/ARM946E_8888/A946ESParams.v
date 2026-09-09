// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (c) COPYRIGHT 1998-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name           : $RCSfile: A946ESParams.v,v $
// File Revision       : $Revision: 1.2 $
//
// Release Information : $State: Rel $
//-----------------------------------------------------------------------------
// Abstract : Cut-down ARM946ES Parameters file for use when compiling
//            ARM946E_8888 with pre-compiled ARM946E_88 netlist or .lib

// Define DTCM_PRESENT and ITCM_PRESENT if the corresponding TCM is
// present:
  `define DTCM_PRESENT    // Data Tightly Coupled Memory Present
  `define ITCM_PRESENT    // Instruction Tightly Coupled Memory Present

// Set to the address width of the corresponding TCM.
// By default this is set to 11 for an 8K TCM:
  `define RDTCM_ADDR_WIDTH   11 
  `define RITCM_ADDR_WIDTH   11

// End.
