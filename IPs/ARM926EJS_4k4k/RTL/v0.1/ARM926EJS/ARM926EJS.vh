// -------------------------------------------------------------------------
// This confidential and proprietary software may be used only as authorised
// by a licensing agreement from ARM Limited
//                (c) COPYRIGHT 2003 ARM Limited
//                ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised copies and
// copies may only be made to the extent permitted by a licensing agreement
// from ARM Limited.
// -------------------------------------------------------------------------
//
// File:     ARM926EJS/ARM926EJS.vh
// 
// Purpose : Defines the implementation options used for the
//           default implementation of ARM926EJS.
//           
//           
// -------------------------------------------------------------------------


`ifdef ARM926EJS_vh_already_included
`else
   `define ARM926EJS_vh_already_included


// block level clock gating on by default

//   `define BLOCK_LEVEL_CLOCK_GATING

// for vanilla implementations DATA_CACHE_SIZE, and INSTR_CACHE size
// will be defined to be numeric values. For the default validation model
// the cache sizes can be changed dynamically using the coprocessor trickbox,
// and the ARM926EJS.v has D/ICACHESIZE inputs, which are mapped onto the
// D/ICACHESIZE inputs to the ARM926EJSCore module
//

  `define DATA_CACHE_SIZE 4'b0011

  `define INSTR_CACHE_SIZE 4'b0011


// Define TESTCHIP when using the validation model:

//  `define TESTCHIP

// Define FPGA when using the fpga model:

//  `define FPGA


`endif
