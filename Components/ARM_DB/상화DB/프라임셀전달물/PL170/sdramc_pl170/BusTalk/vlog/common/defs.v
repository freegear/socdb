// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1999, 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// 
// ---------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name           : defs.v,v
// File Revision       : 1.3
// 
// Release Information : PrimeCell(TM)-PL170-REL2v2
// 
// ---------------------------------------------------------------------
// Purpose             : Cycle type definitions, etc.
// --=================================================================--

`timescale 1ns/1ps

`define T_RESET_R_IDLE        2'd0
`define T_RESET_R_DEL         2'd1
`define T_RESET_R_RES         2'd2
`define T_CYCLE_C_IDLE        4'd0
`define T_CYCLE_C_SR          4'd1
`define T_CYCLE_C_SW          4'd2
`define T_CYCLE_C_SPLIT	      4'd3
`define T_CYCLE_C_ENDIAN      4'd4
`define T_CYCLE_C_RES         4'd5
`define T_CYCLE_C_VR          4'd6
`define T_CYCLE_C_VW          4'd7
`define T_CYCLE_C_END         4'd8
`define T_GET_G_IDLE          1'd0
`define T_GET_G_GET           1'd1
`define T_EDGE_RISING         1'd0
`define T_EDGE_FALLING        1'd1
`define T_V_DRV_SEL_V_IDLE    2'd0
`define T_V_DRV_SEL_V_COUNT   2'd1
`define T_V_DRV_SEL_V_READ    2'd2
`define T_V_DRV_SEL_V_WRITE   2'd3

`define T_RESP_OK             "ok"
`define T_RESP_ERROR          "er"
`define T_RESP_RETRY          "re"
`define T_RESP_SPLIT          "sp"

`define T_SIZE_BYTE           "b"
`define T_SIZE_HWRD           "h"
`define T_SIZE_WRD            "w"
`define T_SIZE_DWRD           "r"

`define T_TRANS_IDLE          "i"
`define T_TRANS_BUSY          "b"
`define T_TRANS_NSEQ          "n"
`define T_TRANS_SEQ           "s"

`define T_BURST_SINGLE        "sin"
`define T_BURST_INCR          "inc"
`define T_BURST_INCR4         "in4"
`define T_BURST_INCR8         "in8"
`define T_BURST_INCR16        "i16"
`define T_BURST_WRAP4         "wr4"
`define T_BURST_WRAP8         "wr8"
`define T_BURST_WRAP16        "w16"

`define T_PROT_UO             "uo"
`define T_PROT_UD             "ud"
`define T_PROT_SO             "so"
`define T_PROT_SD             "sd"

`define T_SUPPMSG             "t"
`define T_NOSUPPMSG           "f"

`define T_ENDIAN_LITTLE       "l"
`define T_ENDIAN_BIG          "b"
`define T_ENDIAN_DISABLE      "d"

`define BIG                    1'b1
`define LITTLE                 1'b0

`define TRUE                   1'b1
`define FALSE                  1'b0

`define MAX_WAIT_STATE         10000
`define MAXINT                 2147483647
// --============================= End ===============================--
