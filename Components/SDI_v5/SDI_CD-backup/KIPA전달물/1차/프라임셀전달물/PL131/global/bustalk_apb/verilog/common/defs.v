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
// File Name              : defs.v.rca
// File Revision          : 1.1
//
// Release Information    : PrimeCell(TM)-GLOBAL-REL1v5
//
// ---------------------------------------------------------------------
// Purpose : Cycle type definitions, etc.
//
// --=================================================================--

`define T_CYCLE_C_IDLE           4'd0
`define T_CYCLE_C_PNW            4'd1
`define T_CYCLE_C_PSW            4'd2
`define T_CYCLE_C_PNR            4'd3
`define T_CYCLE_C_PSR            4'd4
`define T_CYCLE_C_PI             4'd5
`define T_CYCLE_C_RES            4'd6
`define T_CYCLE_C_VR             4'd7 
`define T_CYCLE_C_VW             4'd8
`define T_CYCLE_C_END            4'd9
`define T_CYCLE_C_PO             4'd10
`define T_A_DRV_SEL_A_IDLE       1'd0
`define T_A_DRV_SEL_A_ADDR       1'd1
`define T_D_DRV_SEL_D_IDLE       3'd0
`define T_D_DRV_SEL_DR_IDLE      3'd1
`define T_D_DRV_SEL_D_READ       3'd2
`define T_D_DRV_SEL_D_WRITE      3'd3
`define T_D_DRV_SEL_D_RESET      3'd4
`define T_D_DRV_SEL_DR_HIZ       3'd5
`define T_E_DRV_SEL_EN_PH1       2'd0
`define T_E_DRV_SEL_EN_PH2       2'd1
`define T_E_DRV_SEL_EN_PH3       2'd2
`define T_E_DRV_SEL_EN_PH4       2'd3
`define T_V_DRV_SEL_V_IDLE       2'd0
`define T_V_DRV_SEL_V_COUNT      2'd1
`define T_V_DRV_SEL_V_READ       2'd2
`define T_V_DRV_SEL_V_WRITE      2'd3
`define T_GET_G_IDLE             1'd0
`define T_GET_G_GET              1'd1
`define T_RESET_R_IDLE           2'd0
`define T_RESET_R_DEL            2'd1
`define T_RESET_R_RES            2'd2

`define TRICKBOX_ADDR            24'h600000

// --========================= End ===================================--
