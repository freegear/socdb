////////////////////////////////////////////////////////////////////////////////
// File          : $HeadURL: file:///ci/svn/USBCTRL/USBIF/trunk/HSXXXIFxx/rtl_v/testmux.v $                                                    
// Author        : $Author: hhsilva $                                                     
// Project       : USBIF                                                    
// Instances     :                                                              
// Creation date :                                                              
////////////////////////////////////////////////////////////////////////////////
// Description:
//
//   Test MUX for PHY + Controller Integration
//
////////////////////////////////////////////////////////////////////////////////
// ChipIdea Microelectronica / IPCS                                             
// TECMAIA, Rua Eng. Frederico Ulrich, n 2650                                   
// 4470/920 MOREIRA MAIA                                                        
// Portugal                                                                     
// Tel: +351 229471010                                                          
// Fax: +351 229471011                                                          
// e_mail: chipidea@chipidea.com                                                
////////////////////////////////////////////////////////////////////////////////
// ISO 9001:2000 / Certified Company                                            
// (C) 2005 Copyright Chipidea(R)                                               
// Chipidea(R) / Microelectronica, S.A. reserves the right to make changes to   
// the information contained herein without notice. No liability shall be       
// incurred as a result of its use or application.                              
////////////////////////////////////////////////////////////////////////////////
// Last modification   :                                                        
// $Date: 2006-10-27 14:23:04 +0100 (Fri, 27 Oct 2006) $                                                                       
// $Revision: 100 $

`timescale 1ns / 1ps

module testmux(
                  ctrl_reset              ,
		  scanmode                ,
                  testmode_enable         ,

                  test_utmi_databus16_8   ,
		  test_utmi_datain        ,
		  test_utmi_txvalid       ,
		  test_utmi_txvalidh      ,
		  test_utmi_reset         ,
		  test_utmi_xcvrselect    ,
		  test_utmi_termselect    ,
		  test_utmi_opmode        ,
		  test_utmi_dmpulldown    ,
		  test_utmi_dppulldown    ,
                  test_utmi_vload         ,
                  test_utmi_vcontrol      ,
                  test_onbist             ,
		  test_utmi_idpullup      ,
		  test_utmi_chrgvbus      ,
		  test_utmi_dischrgvbus   ,


                  test_utmi_xcvr_clk      ,
		  test_utmi_suspend       ,
		  test_utmi_txready       ,
		  test_utmi_dataout       ,
		  test_utmi_rxvalid       ,
		  test_utmi_rxvalidh      ,
		  test_utmi_rxactive      ,
		  test_utmi_rxerror       ,
		  test_utmi_linestate     ,
		  test_utmi_hostdisconnect,
                  test_utmi_vstatus       ,                  
		  test_utmi_avalid        ,
		  test_utmi_bvalid        ,
		  test_utmi_vbusvalid     ,
		  test_utmi_endsession    ,
		  test_utmi_iddig         ,

                  // Serial mode test signals
                  test_ser_onvbuscmp      ,
                  test_ser_ondiffrec      ,
                  test_ser_onserec        ,
                  test_ser_ondrv          ,
                  test_ser_datarpu2       ,
                  test_ser_dppullup       ,
                  test_ser_chrgvbus       ,
                  test_ser_dischrgvbus    ,
                  test_ser_idpullup       ,
                  test_ser_tx_se0         ,
                  test_ser_tx_enable_n    ,
                  test_ser_tx_data        ,
                  test_ser_vbusvalid      ,
                  test_ser_avalid         ,
                  test_ser_bvalid         ,
                  test_ser_sessend        ,
                  test_ser_iddig          ,
                  test_ser_dp             ,
                  test_ser_dm             ,
                  test_ser_rx_rcv         ,

                  // Serial signals from controller
                  ctrl_ser_onvbuscmp      ,
                  ctrl_ser_ondiffrec      ,
                  ctrl_ser_onserec        ,
                  ctrl_ser_ondrv          ,
                  ctrl_ser_datarpu2       ,
                  ctrl_ser_dppullup       ,
                  ctrl_ser_chrgvbus       ,
                  ctrl_ser_dischrgvbus    ,
                  ctrl_ser_idpullup       ,
                  ctrl_ser_tx_se0         ,
                  ctrl_ser_tx_enable_n    ,
                  ctrl_ser_tx_data        ,
                  
                  // Serial signals from/to PHY
                  phy_ser_vbusvalid       ,
                  phy_ser_avalid          ,
                  phy_ser_bvalid          ,
                  phy_ser_sessend         ,
                  phy_ser_iddig           ,
                  phy_ser_dp              ,
                  phy_ser_dm              ,
                  phy_ser_rx_rcv          ,
                  phy_ser_onvbuscmp       ,
                  phy_ser_ondiffrec       ,
                  phy_ser_onserec         ,
                  phy_ser_ondrv           ,
                  phy_ser_datarpu2        ,
                  phy_ser_dppullup        ,
                  phy_ser_chrgvbus        ,
                  phy_ser_dischrgvbus     ,
                  phy_ser_tx_se0          ,
                  phy_ser_tx_enable_n     ,
                  phy_ser_tx_data         ,
                  phy_ser_idpullup        ,

		  ctrl_utmi_databus16_8   ,
		  ctrl_utmi_datain        ,
		  ctrl_utmi_xcvrselect    ,
		  ctrl_utmi_opmode        ,
		  ctrl_utmi_dmpulldown    ,
		  ctrl_utmi_dppulldown    ,
		  ctrl_utmi_txvalid       ,
		  ctrl_utmi_txvalidh      ,
		  ctrl_utmi_reset         ,
		  ctrl_utmi_termselect    ,
		  ctrl_utmi_idpullup      ,
		  ctrl_utmi_chrgvbus      ,
		  ctrl_utmi_dischrgvbus   ,
		  pwrctl_suspend_in       ,

                  phy_utmi_databus16_8    ,
                  phy_utmi_datain         ,
                  phy_utmi_xcvrselect     ,
                  phy_utmi_opmode         ,
                  phy_utmi_vcontrol       ,
		  
                  phy_utmi_txvalid        ,
                  phy_utmi_txvalidh       ,
                  phy_utmi_reset          ,
                  phy_utmi_termselect     ,
                  phy_utmi_dmpulldown     ,
                  phy_utmi_dppulldown     ,
                  phy_utmi_suspend        ,
                  phy_utmi_vload          ,
                  phy_onbist              ,

                  phy_utmi_idpullup       ,
		  phy_utmi_chrgvbus       ,
		  phy_utmi_dischrgvbus    ,

                  phy_utmi_xcvr_clk       ,
		  phy_utmi_txready        ,
                  phy_utmi_dataout        ,
                  phy_utmi_linestate      ,
                  phy_utmi_vstatus        ,
		  phy_utmi_rxvalid        ,
		  phy_utmi_rxvalidh       ,
		  phy_utmi_rxactive       ,
		  phy_utmi_rxerror        ,
		  phy_utmi_hostdisconnect ,
                  phy_utmi_avalid         ,
		  phy_utmi_bvalid         ,
		  phy_utmi_vbusvalid      ,
		  phy_utmi_endsession     ,
		  phy_utmi_iddig
               );

`include "vusb_hs_cfg.v"

// Scan muxing signals
input ctrl_reset;
input scanmode;

input testmode_enable;

// Input signals from Test Interface
input           test_utmi_databus16_8   ;
input [15:0]    test_utmi_datain        ;
input           test_utmi_txvalid       ;
input           test_utmi_txvalidh      ;
input           test_utmi_reset         ;
input [1:0]     test_utmi_xcvrselect    ;
input           test_utmi_termselect    ;
input [1:0]     test_utmi_opmode        ;
input           test_utmi_dmpulldown    ;
input           test_utmi_dppulldown    ;
input           test_utmi_suspend       ;
input           test_utmi_vload         ;
input [3:0]     test_utmi_vcontrol      ;
input           test_onbist             ;

input           test_utmi_idpullup      ;
input           test_utmi_chrgvbus      ;
input           test_utmi_dischrgvbus   ;

// Output signals to Test Interface
output          test_utmi_xcvr_clk      ;
output          test_utmi_txready       ;
output [15:0]   test_utmi_dataout       ;
output          test_utmi_rxvalid       ;
output          test_utmi_rxvalidh      ;
output          test_utmi_rxactive      ;
output          test_utmi_rxerror       ;
output [1:0]    test_utmi_linestate     ;
output          test_utmi_hostdisconnect;
output [7:0]    test_utmi_vstatus       ;

output          test_utmi_avalid        ;
output          test_utmi_bvalid        ;
output          test_utmi_vbusvalid     ;
output          test_utmi_endsession    ;
output          test_utmi_iddig         ;

// Serial mode test signals
input                           test_ser_onvbuscmp      ;
input                           test_ser_ondiffrec      ;
input                           test_ser_onserec        ;
input                           test_ser_ondrv          ;
input                           test_ser_datarpu2       ;
input                           test_ser_dppullup       ;
input                           test_ser_chrgvbus       ;
input                           test_ser_dischrgvbus    ;
input                           test_ser_idpullup       ;
input                           test_ser_tx_se0         ;
input                           test_ser_tx_enable_n    ;
input                           test_ser_tx_data        ;
output                          test_ser_vbusvalid      ;
output                          test_ser_avalid         ;
output                          test_ser_bvalid         ;
output                          test_ser_sessend        ;
output                          test_ser_iddig          ;
output                          test_ser_dp             ;
output                          test_ser_dm             ;
output                          test_ser_rx_rcv         ;
   
// Serial signals from controller
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_ser_onvbuscmp      ;
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_ser_ondiffrec      ;
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_ser_onserec        ;
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_ser_ondrv          ;
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_ser_datarpu2       ;
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_ser_dppullup       ;
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_ser_chrgvbus       ;
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_ser_dischrgvbus    ;
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_ser_idpullup       ;
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_ser_tx_se0         ;
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_ser_tx_enable_n    ;
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_ser_tx_data        ;
   
// Serial signals from/to PHY
input  [VUSB_HS_NUM_PORT-1:0]   phy_ser_vbusvalid       ;
input  [VUSB_HS_NUM_PORT-1:0]   phy_ser_avalid          ;
input  [VUSB_HS_NUM_PORT-1:0]   phy_ser_bvalid          ;
input  [VUSB_HS_NUM_PORT-1:0]   phy_ser_sessend         ;
input  [VUSB_HS_NUM_PORT-1:0]   phy_ser_iddig           ;
input  [VUSB_HS_NUM_PORT-1:0]   phy_ser_dp              ;
input  [VUSB_HS_NUM_PORT-1:0]   phy_ser_dm              ;
input  [VUSB_HS_NUM_PORT-1:0]   phy_ser_rx_rcv          ;
output [VUSB_HS_NUM_PORT-1:0]   phy_ser_onvbuscmp       ;
output [VUSB_HS_NUM_PORT-1:0]   phy_ser_ondiffrec       ;
output [VUSB_HS_NUM_PORT-1:0]   phy_ser_onserec         ;
output [VUSB_HS_NUM_PORT-1:0]   phy_ser_ondrv           ;
output [VUSB_HS_NUM_PORT-1:0]   phy_ser_datarpu2        ;
output [VUSB_HS_NUM_PORT-1:0]   phy_ser_dppullup        ;
output [VUSB_HS_NUM_PORT-1:0]   phy_ser_chrgvbus        ;
output [VUSB_HS_NUM_PORT-1:0]   phy_ser_dischrgvbus     ;
output [VUSB_HS_NUM_PORT-1:0]   phy_ser_tx_se0          ;
output [VUSB_HS_NUM_PORT-1:0]   phy_ser_tx_enable_n     ;
output [VUSB_HS_NUM_PORT-1:0]   phy_ser_tx_data         ;
output [VUSB_HS_NUM_PORT-1:0]   phy_ser_idpullup        ;

// Input signals from Controller
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_utmi_databus16_8   ;
input  [15:0]                   ctrl_utmi_datain        ;
input  [1:0]                    ctrl_utmi_xcvrselect    ;
input  [1:0]                    ctrl_utmi_opmode        ;
input                           ctrl_utmi_dmpulldown    ;
input                           ctrl_utmi_dppulldown    ;
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_utmi_txvalid       ;
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_utmi_txvalidh      ;
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_utmi_reset         ;
input  [VUSB_HS_NUM_PORT-1:0]   ctrl_utmi_termselect    ;
input                           ctrl_utmi_idpullup      ;
input                           ctrl_utmi_chrgvbus      ;
input                           ctrl_utmi_dischrgvbus   ;

// Input signals from power control circuit
input  [VUSB_HS_NUM_PORT-1:0]   pwrctl_suspend_in       ;

// Output signals to PHY
output [VUSB_HS_NUM_PORT-1:0]       phy_utmi_databus16_8;
output [15:0]                       phy_utmi_datain     ;
output [1:0]                        phy_utmi_xcvrselect ;
output [1:0]                        phy_utmi_opmode     ;
output [3:0]                        phy_utmi_vcontrol   ;
output [VUSB_HS_NUM_PORT-1:0]       phy_utmi_txvalid    ;
output [VUSB_HS_NUM_PORT-1:0]       phy_utmi_txvalidh   ;
output [VUSB_HS_NUM_PORT-1:0]       phy_utmi_reset      ;
output [VUSB_HS_NUM_PORT-1:0]       phy_utmi_termselect ;
output [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dmpulldown ;
output [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dppulldown ;
output [VUSB_HS_NUM_PORT-1:0]       phy_utmi_suspend    ;
output [VUSB_HS_NUM_PORT-1:0]       phy_utmi_vload      ;
output [VUSB_HS_NUM_PORT-1:0]       phy_onbist          ;

output                              phy_utmi_idpullup   ;
output                              phy_utmi_chrgvbus   ;
output                              phy_utmi_dischrgvbus;

// Input signals from PHY
input  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_xcvr_clk       ;
input  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_txready        ;
input  [15:0]                       phy_utmi_dataout        ;
input  [1:0]                        phy_utmi_linestate      ;
input  [7:0]                        phy_utmi_vstatus        ;
input  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_rxvalid        ;
input  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_rxvalidh       ;
input  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_rxactive       ;
input  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_rxerror        ;
input  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_hostdisconnect ;
input                               phy_utmi_avalid         ;
input                               phy_utmi_bvalid         ;
input                               phy_utmi_vbusvalid      ;
input                               phy_utmi_endsession     ;
input                               phy_utmi_iddig          ;

// Selection of PHY under test signal
wire  [2:0] test_phy_select;
assign      test_phy_select = 3'b000; // Not MPH, will always select first PHY for test interface

// Internal signals
wire [VUSB_HS_NUM_PORT-1:0] i_phy_utmi_reset;
reg  [7:0]                  i_one_hot_phy_select;
wire [7:0]                  one_hot_phy_select;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dataout_15     ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dataout_14     ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dataout_13     ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dataout_12     ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dataout_11     ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dataout_10     ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dataout_9      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dataout_8      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dataout_7      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dataout_6      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dataout_5      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dataout_4      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dataout_3      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dataout_2      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dataout_1      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_dataout_0      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_linestate_1    ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_linestate_0    ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_vstatus_7      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_vstatus_6      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_vstatus_5      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_vstatus_4      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_vstatus_3      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_vstatus_2      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_vstatus_1      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_vstatus_0      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_datain_15      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_datain_14      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_datain_13      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_datain_12      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_datain_11      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_datain_10      ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_datain_9       ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_datain_8       ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_datain_7       ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_datain_6       ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_datain_5       ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_datain_4       ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_datain_3       ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_datain_2       ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_datain_1       ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_datain_0       ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_xcvrselect_1   ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_xcvrselect_0   ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_opmode_1       ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_opmode_0       ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_vcontrol_3     ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_vcontrol_2     ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_vcontrol_1     ;
wire  [VUSB_HS_NUM_PORT-1:0]       phy_utmi_vcontrol_0     ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_datain_0      ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_datain_1      ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_datain_2      ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_datain_3      ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_datain_4      ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_datain_5      ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_datain_6      ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_datain_7      ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_datain_8      ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_datain_9      ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_datain_10     ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_datain_11     ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_datain_12     ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_datain_13     ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_datain_14     ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_datain_15     ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_xcvrselect_0  ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_xcvrselect_1  ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_opmode_0      ;
wire  [VUSB_HS_NUM_PORT-1:0]       ctrl_utmi_opmode_1      ;

// Assign selection of PHY for enabling Test Interface
// The external Test Interface can only access 1 PHY at a time
always@(test_phy_select)
begin
    case(test_phy_select)
        3'b000: i_one_hot_phy_select = 8'b00000001;
        3'b001: i_one_hot_phy_select = 8'b00000010;
        3'b010: i_one_hot_phy_select = 8'b00000100;
        3'b011: i_one_hot_phy_select = 8'b00001000;
        3'b100: i_one_hot_phy_select = 8'b00010000;
        3'b101: i_one_hot_phy_select = 8'b00100000;
        3'b110: i_one_hot_phy_select = 8'b01000000;
        3'b111: i_one_hot_phy_select = 8'b10000000;
    endcase
end

// If Test Interface is disabled, disable access to all PHYs
assign one_hot_phy_select = testmode_enable == 1 ? i_one_hot_phy_select : 8'b00000000;

//////////////////////////////////////////////////////////////////////////
// Assign signals from Controller/Test Interface to PHY
//////////////////////////////////////////////////////////////////////////

// Implode resulting bus to single PHY
assign  phy_utmi_datain[15]     = phy_utmi_datain_15    ;
assign  phy_utmi_datain[14]     = phy_utmi_datain_14    ;
assign  phy_utmi_datain[13]     = phy_utmi_datain_13    ;
assign  phy_utmi_datain[12]     = phy_utmi_datain_12    ;
assign  phy_utmi_datain[11]     = phy_utmi_datain_11    ;
assign  phy_utmi_datain[10]     = phy_utmi_datain_10    ;
assign  phy_utmi_datain[9]      = phy_utmi_datain_9     ;
assign  phy_utmi_datain[8]      = phy_utmi_datain_8     ;
assign  phy_utmi_datain[7]      = phy_utmi_datain_7     ;
assign  phy_utmi_datain[6]      = phy_utmi_datain_6     ;
assign  phy_utmi_datain[5]      = phy_utmi_datain_5     ;
assign  phy_utmi_datain[4]      = phy_utmi_datain_4     ;
assign  phy_utmi_datain[3]      = phy_utmi_datain_3     ;
assign  phy_utmi_datain[2]      = phy_utmi_datain_2     ;
assign  phy_utmi_datain[1]      = phy_utmi_datain_1     ;
assign  phy_utmi_datain[0]      = phy_utmi_datain_0     ;
assign  phy_utmi_xcvrselect[1]  = phy_utmi_xcvrselect_1 ;
assign  phy_utmi_xcvrselect[0]  = phy_utmi_xcvrselect_0 ;
assign  phy_utmi_opmode[1]      = phy_utmi_opmode_1     ;
assign  phy_utmi_opmode[0]      = phy_utmi_opmode_0     ;
assign  phy_utmi_vcontrol[3]    = phy_utmi_vcontrol_3   ;
assign  phy_utmi_vcontrol[2]    = phy_utmi_vcontrol_2   ;
assign  phy_utmi_vcontrol[1]    = phy_utmi_vcontrol_1   ;
assign  phy_utmi_vcontrol[0]    = phy_utmi_vcontrol_0   ;

busmux mux_signal_databus16_8 (.s(one_hot_phy_select), .inn(ctrl_utmi_databus16_8 ), .int(test_utmi_databus16_8  ), .o(phy_utmi_databus16_8 ) );
busmux mux_signal_datain_15   (.s(one_hot_phy_select), .inn(ctrl_utmi_datain_15   ), .int(test_utmi_datain[15]   ), .o(phy_utmi_datain_15   ) );
busmux mux_signal_datain_14   (.s(one_hot_phy_select), .inn(ctrl_utmi_datain_14   ), .int(test_utmi_datain[14]   ), .o(phy_utmi_datain_14   ) );
busmux mux_signal_datain_13   (.s(one_hot_phy_select), .inn(ctrl_utmi_datain_13   ), .int(test_utmi_datain[13]   ), .o(phy_utmi_datain_13   ) );
busmux mux_signal_datain_12   (.s(one_hot_phy_select), .inn(ctrl_utmi_datain_12   ), .int(test_utmi_datain[12]   ), .o(phy_utmi_datain_12   ) );
busmux mux_signal_datain_11   (.s(one_hot_phy_select), .inn(ctrl_utmi_datain_11   ), .int(test_utmi_datain[11]   ), .o(phy_utmi_datain_11   ) );
busmux mux_signal_datain_10   (.s(one_hot_phy_select), .inn(ctrl_utmi_datain_10   ), .int(test_utmi_datain[10]   ), .o(phy_utmi_datain_10   ) );
busmux mux_signal_datain_9    (.s(one_hot_phy_select), .inn(ctrl_utmi_datain_9	 ), .int(test_utmi_datain[9]    ), .o(phy_utmi_datain_9    ) );
busmux mux_signal_datain_8    (.s(one_hot_phy_select), .inn(ctrl_utmi_datain_8	 ), .int(test_utmi_datain[8]    ), .o(phy_utmi_datain_8    ) );
busmux mux_signal_datain_7    (.s(one_hot_phy_select), .inn(ctrl_utmi_datain_7	 ), .int(test_utmi_datain[7]    ), .o(phy_utmi_datain_7    ) );
busmux mux_signal_datain_6    (.s(one_hot_phy_select), .inn(ctrl_utmi_datain_6	 ), .int(test_utmi_datain[6]    ), .o(phy_utmi_datain_6    ) );
busmux mux_signal_datain_5    (.s(one_hot_phy_select), .inn(ctrl_utmi_datain_5	 ), .int(test_utmi_datain[5]    ), .o(phy_utmi_datain_5    ) );
busmux mux_signal_datain_4    (.s(one_hot_phy_select), .inn(ctrl_utmi_datain_4	 ), .int(test_utmi_datain[4]    ), .o(phy_utmi_datain_4    ) );
busmux mux_signal_datain_3    (.s(one_hot_phy_select), .inn(ctrl_utmi_datain_3	 ), .int(test_utmi_datain[3]    ), .o(phy_utmi_datain_3    ) );
busmux mux_signal_datain_2    (.s(one_hot_phy_select), .inn(ctrl_utmi_datain_2	 ), .int(test_utmi_datain[2]    ), .o(phy_utmi_datain_2    ) );
busmux mux_signal_datain_1    (.s(one_hot_phy_select), .inn(ctrl_utmi_datain_1	 ), .int(test_utmi_datain[1]    ), .o(phy_utmi_datain_1    ) );
busmux mux_signal_datain_0    (.s(one_hot_phy_select), .inn(ctrl_utmi_datain_0	 ), .int(test_utmi_datain[0]    ), .o(phy_utmi_datain_0    ) );
busmux mux_signal_txvalid     (.s(one_hot_phy_select), .inn(ctrl_utmi_txvalid	 ), .int(test_utmi_txvalid      ), .o(phy_utmi_txvalid	  ) );
busmux mux_signal_txvalidh    (.s(one_hot_phy_select), .inn(ctrl_utmi_txvalidh	 ), .int(test_utmi_txvalidh     ), .o(phy_utmi_txvalidh    ) );
busmux mux_signal_reset_i     (.s(one_hot_phy_select), .inn(ctrl_utmi_reset	 ), .int(test_utmi_reset        ), .o(i_phy_utmi_reset	  ) );
busmux mux_signal_xcvrselect_1(.s(one_hot_phy_select), .inn(ctrl_utmi_xcvrselect_1), .int(test_utmi_xcvrselect[1]), .o(phy_utmi_xcvrselect_1) );
busmux mux_signal_xcvrselect_0(.s(one_hot_phy_select), .inn(ctrl_utmi_xcvrselect_0), .int(test_utmi_xcvrselect[0]), .o(phy_utmi_xcvrselect_0) );
busmux mux_signal_termselect  (.s(one_hot_phy_select), .inn(ctrl_utmi_termselect  ), .int(test_utmi_termselect   ), .o(phy_utmi_termselect  ) );
busmux mux_signal_opmode_1    (.s(one_hot_phy_select), .inn(ctrl_utmi_opmode_1	 ), .int(test_utmi_opmode[1]    ), .o(phy_utmi_opmode_1    ) );
busmux mux_signal_opmode_0    (.s(one_hot_phy_select), .inn(ctrl_utmi_opmode_0	 ), .int(test_utmi_opmode[0]    ), .o(phy_utmi_opmode_0    ) );
busmux mux_signal_dmpulldown  (.s(one_hot_phy_select), .inn({VUSB_HS_NUM_PORT{ctrl_utmi_dmpulldown}}), .int(test_utmi_dmpulldown   ), .o(phy_utmi_dmpulldown) );
busmux mux_signal_dppulldown  (.s(one_hot_phy_select), .inn({VUSB_HS_NUM_PORT{ctrl_utmi_dppulldown}}), .int(test_utmi_dppulldown   ), .o(phy_utmi_dppulldown) );

busmux mux_signal_suspend     (.s(one_hot_phy_select), .inn(pwrctl_suspend_in	 ), .int(test_utmi_suspend      ), .o(phy_utmi_suspend	  ) );

busmux mux_signal_vload       (.s(i_one_hot_phy_select), .inn({VUSB_HS_NUM_PORT{1'b1}}), .int(test_utmi_vload	   ), .o(phy_utmi_vload       ) );
busmux mux_signal_vcontrol_3  (.s(i_one_hot_phy_select), .inn({VUSB_HS_NUM_PORT{1'b0}}), .int(test_utmi_vcontrol[3]  ), .o(phy_utmi_vcontrol_3  ) );
busmux mux_signal_vcontrol_2  (.s(i_one_hot_phy_select), .inn({VUSB_HS_NUM_PORT{1'b0}}), .int(test_utmi_vcontrol[2]  ), .o(phy_utmi_vcontrol_2  ) );
busmux mux_signal_vcontrol_1  (.s(i_one_hot_phy_select), .inn({VUSB_HS_NUM_PORT{1'b0}}), .int(test_utmi_vcontrol[1]  ), .o(phy_utmi_vcontrol_1  ) );
busmux mux_signal_vcontrol_0  (.s(i_one_hot_phy_select), .inn({VUSB_HS_NUM_PORT{1'b0}}), .int(test_utmi_vcontrol[0]  ), .o(phy_utmi_vcontrol_0  ) );
busmux mux_signal_onbist      (.s(one_hot_phy_select), .inn({VUSB_HS_NUM_PORT{1'b0}}), .int(test_onbist		 ), .o(phy_onbist	    ) );

// Serial muxes
busmux mux_signal_onvbuscmp   (.s(one_hot_phy_select), .inn(ctrl_ser_onvbuscmp), .int(test_ser_onvbuscmp        ), .o(phy_ser_onvbuscmp       ) );
busmux mux_signal_ondiffrec   (.s(one_hot_phy_select), .inn(ctrl_ser_ondiffrec), .int(test_ser_ondiffrec        ), .o(phy_ser_ondiffrec       ) );
busmux mux_signal_onserec     (.s(one_hot_phy_select), .inn(ctrl_ser_onserec  ), .int(test_ser_onserec          ), .o(phy_ser_onserec         ) );
busmux mux_signal_ondrv       (.s(one_hot_phy_select), .inn(ctrl_ser_ondrv    ), .int(test_ser_ondrv            ), .o(phy_ser_ondrv           ) );
busmux mux_signal_datarpu2    (.s(one_hot_phy_select), .inn(ctrl_ser_datarpu2 ), .int(test_ser_datarpu2         ), .o(phy_ser_datarpu2        ) );
busmux mux_signal_dppullup    (.s(one_hot_phy_select), .inn(ctrl_ser_dppullup ), .int(test_ser_dppullup         ), .o(phy_ser_dppullup        ) );
busmux mux_signal_chrgvbus    (.s(one_hot_phy_select), .inn(ctrl_ser_chrgvbus ), .int(test_ser_chrgvbus         ), .o(phy_ser_chrgvbus        ) );
busmux mux_signal_dischrgvbus (.s(one_hot_phy_select), .inn(ctrl_ser_dischrgvbus), .int(test_ser_dischrgvbus    ), .o(phy_ser_dischrgvbus     ) );
busmux mux_signal_idpullup    (.s(one_hot_phy_select), .inn(ctrl_ser_idpullup ), .int(test_ser_idpullup         ), .o(phy_ser_idpullup        ) );
busmux mux_signal_tx_se0      (.s(one_hot_phy_select), .inn(ctrl_ser_tx_se0   ), .int(test_ser_tx_se0           ), .o(phy_ser_tx_se0          ) );
busmux mux_signal_tx_enable_n (.s(one_hot_phy_select), .inn(ctrl_ser_tx_enable_n), .int(test_ser_tx_enable_n    ), .o(phy_ser_tx_enable_n     ) );
busmux mux_signal_tx_data     (.s(one_hot_phy_select), .inn(ctrl_ser_tx_data  ), .int(test_ser_tx_data          ), .o(phy_ser_tx_data         ) );

assign  phy_utmi_idpullup      = testmode_enable ? test_utmi_idpullup	   : ctrl_utmi_idpullup   ;
assign  phy_utmi_chrgvbus      = testmode_enable ? test_utmi_chrgvbus	   : ctrl_utmi_chrgvbus   ;
assign  phy_utmi_dischrgvbus   = testmode_enable ? test_utmi_dischrgvbus   : ctrl_utmi_dischrgvbus;

// Mux scan reset to PHY. inn scan mode, all resets are replaced by "ctrl_reset"
busmux mux_signal_reset       ( .s  ({8{scanmode}}      ),
                                .inn (i_phy_utmi_reset   ),
                                .int (ctrl_reset         ),
                                .o  (phy_utmi_reset     )
                              );

//////////////////////////////////////////////////////////////////////////
// Assign signals from PHY to Test Interface and Controller
//////////////////////////////////////////////////////////////////////////

// Explode bus from single Controller port
assign  phy_utmi_dataout_15     = phy_utmi_dataout[15]  ;
assign  phy_utmi_dataout_14     = phy_utmi_dataout[14]  ;
assign  phy_utmi_dataout_13     = phy_utmi_dataout[13]  ;
assign  phy_utmi_dataout_12     = phy_utmi_dataout[12]  ;
assign  phy_utmi_dataout_11     = phy_utmi_dataout[11]  ;
assign  phy_utmi_dataout_10     = phy_utmi_dataout[10]  ;
assign  phy_utmi_dataout_9      = phy_utmi_dataout[9]   ;
assign  phy_utmi_dataout_8      = phy_utmi_dataout[8]   ;
assign  phy_utmi_dataout_7      = phy_utmi_dataout[7]   ;
assign  phy_utmi_dataout_6      = phy_utmi_dataout[6]   ;
assign  phy_utmi_dataout_5      = phy_utmi_dataout[5]   ;
assign  phy_utmi_dataout_4      = phy_utmi_dataout[4]   ;
assign  phy_utmi_dataout_3      = phy_utmi_dataout[3]   ;
assign  phy_utmi_dataout_2      = phy_utmi_dataout[2]   ;
assign  phy_utmi_dataout_1      = phy_utmi_dataout[1]   ;
assign  phy_utmi_dataout_0      = phy_utmi_dataout[0]   ;
assign  phy_utmi_linestate_1    = phy_utmi_linestate[1] ;
assign  phy_utmi_linestate_0    = phy_utmi_linestate[0] ;
assign  phy_utmi_vstatus_7      = phy_utmi_vstatus[7]   ;
assign  phy_utmi_vstatus_6      = phy_utmi_vstatus[6]   ;
assign  phy_utmi_vstatus_5      = phy_utmi_vstatus[5]   ;
assign  phy_utmi_vstatus_4      = phy_utmi_vstatus[4]   ;
assign  phy_utmi_vstatus_3      = phy_utmi_vstatus[3]   ;
assign  phy_utmi_vstatus_2      = phy_utmi_vstatus[2]   ;
assign  phy_utmi_vstatus_1      = phy_utmi_vstatus[1]   ;
assign  phy_utmi_vstatus_0      = phy_utmi_vstatus[0]   ;
assign  ctrl_utmi_datain_0      = ctrl_utmi_datain[0]   ;
assign  ctrl_utmi_datain_1      = ctrl_utmi_datain[1]   ;
assign  ctrl_utmi_datain_2      = ctrl_utmi_datain[2]   ;
assign  ctrl_utmi_datain_3      = ctrl_utmi_datain[3]   ;
assign  ctrl_utmi_datain_4      = ctrl_utmi_datain[4]   ;
assign  ctrl_utmi_datain_5      = ctrl_utmi_datain[5]   ;
assign  ctrl_utmi_datain_6      = ctrl_utmi_datain[6]   ;
assign  ctrl_utmi_datain_7      = ctrl_utmi_datain[7]   ;
assign  ctrl_utmi_datain_8      = ctrl_utmi_datain[8]   ;
assign  ctrl_utmi_datain_9      = ctrl_utmi_datain[9]   ;
assign  ctrl_utmi_datain_10     = ctrl_utmi_datain[10]  ;
assign  ctrl_utmi_datain_11     = ctrl_utmi_datain[11]  ;
assign  ctrl_utmi_datain_12     = ctrl_utmi_datain[12]  ;
assign  ctrl_utmi_datain_13     = ctrl_utmi_datain[13]  ;
assign  ctrl_utmi_datain_14     = ctrl_utmi_datain[14]  ;
assign  ctrl_utmi_datain_15     = ctrl_utmi_datain[15]  ;
assign  ctrl_utmi_xcvrselect_0  = ctrl_utmi_xcvrselect[0];
assign  ctrl_utmi_xcvrselect_1  = ctrl_utmi_xcvrselect[1];
assign  ctrl_utmi_opmode_0      = ctrl_utmi_opmode[0]   ;
assign  ctrl_utmi_opmode_1      = ctrl_utmi_opmode[1]   ;

assign  test_utmi_xcvr_clk          = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_xcvr_clk        );
assign  test_utmi_txready           = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_txready         );
assign  test_utmi_dataout[15]       = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_dataout_15      );
assign  test_utmi_dataout[14]       = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_dataout_14      );
assign  test_utmi_dataout[13]       = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_dataout_13      );
assign  test_utmi_dataout[12]       = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_dataout_12      );
assign  test_utmi_dataout[11]       = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_dataout_11      );
assign  test_utmi_dataout[10]       = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_dataout_10      );
assign  test_utmi_dataout[9]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_dataout_9       );
assign  test_utmi_dataout[8]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_dataout_8       );
assign  test_utmi_dataout[7]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_dataout_7       );
assign  test_utmi_dataout[6]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_dataout_6       );
assign  test_utmi_dataout[5]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_dataout_5       );
assign  test_utmi_dataout[4]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_dataout_4       );
assign  test_utmi_dataout[3]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_dataout_3       );
assign  test_utmi_dataout[2]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_dataout_2       );
assign  test_utmi_dataout[1]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_dataout_1       );
assign  test_utmi_dataout[0]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_dataout_0       );
assign  test_utmi_rxvalid           = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_rxvalid         );
assign  test_utmi_rxvalidh          = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_rxvalidh        );
assign  test_utmi_rxactive          = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_rxactive        );
assign  test_utmi_rxerror           = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_rxerror         );
assign  test_utmi_linestate[1]      = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_linestate_1     );
assign  test_utmi_linestate[0]      = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_linestate_0     );
assign  test_utmi_hostdisconnect    = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_hostdisconnect  );

assign  test_utmi_vstatus[7]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_vstatus_7       );
assign  test_utmi_vstatus[6]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_vstatus_6       );
assign  test_utmi_vstatus[5]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_vstatus_5       );
assign  test_utmi_vstatus[4]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_vstatus_4       );
assign  test_utmi_vstatus[3]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_vstatus_3       );
assign  test_utmi_vstatus[2]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_vstatus_2       );
assign  test_utmi_vstatus[1]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_vstatus_1       );
assign  test_utmi_vstatus[0]        = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_utmi_vstatus_0       );

assign  test_ser_vbusvalid          = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_ser_vbusvalid        );
assign  test_ser_avalid             = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_ser_avalid           );
assign  test_ser_bvalid             = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_ser_bvalid           );
assign  test_ser_sessend            = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_ser_sessend          );
assign  test_ser_iddig              = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_ser_iddig            );
assign  test_ser_dp                 = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_ser_dp               );
assign  test_ser_dm                 = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_ser_dm               );
assign  test_ser_rx_rcv             = |(i_one_hot_phy_select[VUSB_HS_NUM_PORT-1:0] & phy_ser_rx_rcv           );

assign  test_utmi_avalid            = phy_utmi_avalid         ;
assign  test_utmi_bvalid            = phy_utmi_bvalid         ;
assign  test_utmi_vbusvalid         = phy_utmi_vbusvalid      ;
assign  test_utmi_endsession        = phy_utmi_endsession     ;
assign  test_utmi_iddig             = phy_utmi_iddig          ;

endmodule
