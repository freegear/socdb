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
*   FILE          : reset_cnt.v
*   AUTHOR        : CORERIVER
*   DESCRIPTION   : 
*   VERSION       : $Revision:$ ($Date:$)
*   COMMENT       :
* 
*********************************************************************/

module reset_cnt(
POR_reset,
ext_reset,
wdt_reset,
final_all_reset,
final_POR_ext_reset
);
input POR_reset;
input ext_reset;
input wdt_reset;
output final_all_reset;
output final_POR_ext_reset;

assign final_all_reset     = ext_reset | POR_reset | wdt_reset;
assign final_POR_ext_reset = ext_reset | POR_reset;
endmodule

