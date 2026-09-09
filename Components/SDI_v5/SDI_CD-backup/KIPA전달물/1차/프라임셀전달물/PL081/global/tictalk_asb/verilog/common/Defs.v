// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : Defs.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v4
//
// ---------------------------------------------------------------------
// Purpose : Standard definitions for AMBA
//
// --=================================================================--

//---------------------------------------------------------------------
// Constant definitions for BTRAN : transaction type
//---------------------------------------------------------------------

// address transfer
  parameter TRAN_ATRAN   = 2'b00;
// internal transfer
  parameter TRAN_ITRAN   = 2'b01;
// non-sequential transfer
  parameter TRAN_NTRAN   = 2'b10;
// sequential transfer
  parameter TRAN_STRAN   = 2'b11;
// high impedance
  parameter TRAN_HIZ     = 2'bZZ;
// undefined
  parameter TRAN_X       = 2'bXX;


//---------------------------------------------------------------------
// Parameter definitions for BSIZE : Bus Transfer size
//---------------------------------------------------------------------
  parameter SIZE_BYTE    = 2'b00;
  parameter SIZE_HALF    = 2'b01;
  parameter SIZE_WORD    = 2'b10;
  parameter SIZE_HIZ     = 2'bZZ;
  parameter SIZE_X       = 2'bXX;

// --============================== End ==============================--
