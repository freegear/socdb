/*********************************************************************
*
*   This confidential and proprietary software may be used only as
*   authorised by a licensing agreement from CORERIVER Semiconductor
*   Co., Ltd.
*
*   (c) Copyright 2006 CORERIVER Semiconductor Co., Ltd.
*     All Rights Reserved
*
*   The entire notice above must be reproduced on all authorised
*   copies and copies may only be made to the extent permitted
*   by a licensing agreement from CORERIVER Semiconductor Co., Ltd.
*
* -------------------------------------------------------------------
*
*   FILE          : core_top.v
*   AUTHOR        : CORERIVER
*   DESCRIPTION   : 
*   VERSION       : $Revision:$ ($Date:$)
*   COMMENT       :
* 
*********************************************************************/
//--------------------------------------------------
// core_top.v
//--------------------------------------------------
module core_top(

//user special
user_init_pc,
user_init_pc_en, //when "1", PC initial value = user_init_PC. Not 0000h

RESET_pin, //reset interface
final_all_reset,
final_POR_ext_reset, //for WDT_reset generation
wdt_reset,
xrom_addr, //XROM interface
xrom_ce_b,
xrom_oe_b,
xrom_dout,
xram_addr, //XRAM 64Kbyte interface
xram_din,
xram_ce_b,
xram_oe_b,
xram_we_b,
xram_dout,
iram_addr, //IRAM interface
iram_din,
iram_ce_b,
iram_oe_b,
iram_we_b,
iram_dout,
clk_cpu,
clk_peri,
clk_wdt,
WDT_RUN,
pdwn,
idle,
EA,
ALE,
PSEN,
P0_DIN,
P0_DOUT,
P1_DIN,
P1_DOUT,
P2_DIN,
P2_DOUT,
P3_DIN,
P3_DOUT,
INT0_B,
INT1_B,
INT2,
INT3_B,
INT4,
INT5_B,
T0_PIN,
T1_PIN,
T2_PIN,
T2EX_PIN,
T2_OUT,
RX_PIN,
TX_PIN
//V9 PWM1_OUT,
//V9 PWM2_OUT
);
//--------------------------------------------------

//user special
input [15:0] user_init_pc;
input user_init_pc_en;

//reset control
input RESET_pin;
input final_all_reset;
input final_POR_ext_reset;
output wdt_reset;

//XROM 64Kbyte interface
output [15:0] xrom_addr;
output xrom_ce_b;
output xrom_oe_b;
input [7:0] xrom_dout;

//XRAM 64Kbyte interface
output [15:0] xram_addr;
output [7:0] xram_din;
output xram_ce_b;
output xram_oe_b;
output xram_we_b;
input [7:0] xram_dout;

//Internal RAM 256bytes interface
output [7:0] iram_addr;
output [7:0] iram_din;
output iram_ce_b;
output iram_oe_b;
output iram_we_b;
input [7:0] iram_dout;


//clock control
input clk_cpu; //cpu clock
input clk_peri; //peri clock
input clk_wdt; //watch-dog clock
output WDT_RUN; //watch-dog run enable
output pdwn; //Power-down(stop) mode
output idle; //Idle mode

//port control
input EA;
output ALE;
output PSEN;
input [7:0] P0_DIN;
input [7:0] P1_DIN;
input [7:0] P2_DIN;
input [7:0] P3_DIN;
output [7:0] P0_DOUT;
output [7:0] P1_DOUT;
output [7:0] P2_DOUT;
output [7:0] P3_DOUT;

//alternative function
input INT0_B; //external interrupt 0
input INT1_B; //external interrupt 1
input INT2; //external interrupt 2
input INT3_B; //external interrupt 3
input INT4; //external interrupt 4
input INT5_B; //external interrupt 5
input T0_PIN; //Timer 0 input
input T1_PIN; //Timer 1 input
input T2_PIN; //Timer 2 input
input T2EX_PIN; //Timer 2 input
output T2_OUT; //Timer 2 output
input RX_PIN; //Uart RX pin
output TX_PIN; //Uart TX pin
//--------------------------------------------------
endmodule
//--------------------------------------------------
