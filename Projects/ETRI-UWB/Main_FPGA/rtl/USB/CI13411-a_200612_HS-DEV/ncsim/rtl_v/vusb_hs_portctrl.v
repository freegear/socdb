/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_portctrl.vhdl
-- Date Created: Thu Dec 21 22:42:23 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_portctrl.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Vusb_Hs Port Controller (host version)
// 
// ------------------------------------------------------------------------------
//  ChipIdea Microelectronica - IPCS                                             
//  TECMAIA, Rua Eng. Frederico Ulrich, n 2650                                   
//  4470-920 MOREIRA MAIA                                                        
//  Portugal                                                                     
//  Tel: +351 229471010                                                          
//  Fax: +351 229471011                                                          
//  e_mail: chipidea@chipidea.com                                                
// ------------------------------------------------------------------------------
//  ISO 9001:2000 - Certified Company                                            
//  (C) 2005 Copyright Chipidea(R)                                               
//  Chipidea(R) - Microelectronica, S.A. reserves the right to make changes to   
//  the information contained herein without notice. No liability shall be       
//  incurred as a result of its use or application.                              
// ------------------------------------------------------------------------------
//  Last modification   :                                                        
//  $Date: 2006-05-16 17:13:13 +0100 (Tue, 16 May 2006) $                                                                       
//  $Revision: 58 $                                                                   
module vusb_hs_portctrl (rst,
   rst_a,
   rst_s,
   rst_local_a,
   rst_local,
   pe_clk,
   pe_rst,
   pe_rst_a,
   pe_porst,
   pe_porst_a,
   xcvr_clk,
   xcvr_ser_clk,
   test_mode,
   portctrl_arb_force_bit_stuff,
   portctrl_arb_hst_frame_babble,
   portctrl_arb_pe_busy,
   portctrl_arb_tx_data,
   portctrl_arb_tx_ls,
   portctrl_arb_tx_valid_b_0,
   portctrl_arb_tx_valid_b_1,
   portctrl_arb_tx_valid_b_en,
   portctrl_arb_tx_valid_early,
   portctrl_arb_tx_valid_last,
   portctrl_arb_bus_reset,
   portctrl_arb_clk_valid,
   portctrl_arb_rx_data_0,
   portctrl_arb_rx_data_1,
   portctrl_arb_rx_data_2,
   portctrl_arb_rx_data_3,
   portctrl_arb_rx_data_4,
   portctrl_arb_rx_data_5,
   portctrl_arb_rx_data_6,
   portctrl_arb_rx_data_7,
   portctrl_arb_rx_data_8,
   portctrl_arb_rx_data_9,
   portctrl_arb_rx_data_10,
   portctrl_arb_rx_data_11,
   portctrl_arb_rx_data_12,
   portctrl_arb_rx_data_13,
   portctrl_arb_rx_data_14,
   portctrl_arb_rx_data_15,
   portctrl_arb_rx_err,
   portctrl_arb_rx_valid_b_0,
   portctrl_arb_rx_valid_b_1,
   portctrl_arb_rx_valid_b_2,
   portctrl_arb_speed_sel_0,
   portctrl_arb_speed_sel_1,
   portctrl_arb_suspend,
   portctrl_arb_test_pkt,
   portctrl_arb_test_se0_nak,
   portctrl_arb_tx_ready,
   portctrl_arb_tx_done,
   portctrl_arb_bto,
   portctrl_arb_flow_en,
   portctrl_arb_tt_force_bit_stuff,
   portctrl_arb_tt_hst_frame_babble,
   portctrl_arb_tt_pe_busy,
   portctrl_arb_tt_tx_data,
   portctrl_arb_tt_tx_ls,
   portctrl_arb_tt_tx_valid_b_0,
   portctrl_arb_tt_tx_valid_b_1,
   portctrl_arb_tt_tx_valid_b_en,
   portctrl_arb_tt_tx_valid_early,
   portctrl_arb_tt_tx_valid_last,
   portctrl_arb_tt_clk_valid,
   portctrl_arb_tt_rx_data_0,
   portctrl_arb_tt_rx_data_1,
   portctrl_arb_tt_rx_data_2,
   portctrl_arb_tt_rx_data_3,
   portctrl_arb_tt_rx_data_4,
   portctrl_arb_tt_rx_data_5,
   portctrl_arb_tt_rx_data_6,
   portctrl_arb_tt_rx_data_7,
   portctrl_arb_tt_rx_data_8,
   portctrl_arb_tt_rx_data_9,
   portctrl_arb_tt_rx_data_10,
   portctrl_arb_tt_rx_data_11,
   portctrl_arb_tt_rx_data_12,
   portctrl_arb_tt_rx_data_13,
   portctrl_arb_tt_rx_data_14,
   portctrl_arb_tt_rx_data_15,
   portctrl_arb_tt_rx_err,
   portctrl_arb_tt_rx_valid_b_0,
   portctrl_arb_tt_rx_valid_b_1,
   portctrl_arb_tt_rx_valid_b_2,
   portctrl_arb_tt_tx_ready,
   portctrl_arb_tt_tx_done,
   portctrl_arb_tt_bto,
   portctrl_arb_tt_flow_en,
   portctrl_up_port_owner,
   portctrl_up_data_width,
   portctrl_up_datawr,
   portctrl_up_device_mode,
   portctrl_up_host_mode,
   portctrl_up_phy_select_0,
   portctrl_up_phy_select_1,
   portctrl_up_serial_select,
   portctrl_up_port_power,
   portctrl_up_rd,
   portctrl_up_run,
   portctrl_up_wr_be,
   portctrl_up_wr_tog_en,
   portctrl_up_datard_0,
   portctrl_up_datard_1,
   portctrl_up_datard_2,
   portctrl_up_datard_3,
   portctrl_up_datard_4,
   portctrl_up_datard_5,
   portctrl_up_datard_6,
   portctrl_up_datard_7,
   portctrl_up_datard_8,
   portctrl_up_datard_9,
   portctrl_up_datard_10,
   portctrl_up_datard_11,
   portctrl_up_datard_12,
   portctrl_up_datard_13,
   portctrl_up_datard_14,
   portctrl_up_datard_15,
   portctrl_up_datard_16,
   portctrl_up_datard_17,
   portctrl_up_datard_18,
   portctrl_up_datard_19,
   portctrl_up_datard_20,
   portctrl_up_datard_21,
   portctrl_up_datard_22,
   portctrl_up_datard_23,
   portctrl_up_datard_24,
   portctrl_up_datard_25,
   portctrl_up_datard_26,
   portctrl_up_datard_27,
   portctrl_up_datard_28,
   portctrl_up_datard_29,
   portctrl_up_datard_30,
   portctrl_up_datard_31,
   portctrl_up_port_chg_irq_tog,
   portctrl_up_wr_handshake_tog,
   portctrl_up_suspend,
   ulpi_up_datard_0,
   ulpi_up_datard_1,
   ulpi_up_datard_2,
   ulpi_up_datard_3,
   ulpi_up_datard_4,
   ulpi_up_datard_5,
   ulpi_up_datard_6,
   ulpi_up_datard_7,
   up_ulpi_datawr,
   up_ulpi_addr,
   up_ulpi_rd0wr1,
   up_ulpi_cmd_tog,
   ulpi_up_cmd_handshake,
   up_ulpi_wakeup,
   ulpi_up_wakeup_handshake,
   ulpi_up_sync_state,
   up_portctrl_data_width,
   up_portctrl_port_power,
   up_portctrl_device_mode,
   up_portctrl_host_mode,
   up_portctrl_phy_select_0,
   up_portctrl_phy_select_1,
   up_portctrl_suspend,
   otg_pc_data_pulse,
   otg_id,
   otg_a_vbus_vld,
   otg_a_sess_vld,
   otg_b_sess_vld,
   otg_b_sess_end,
   otg_id_state,
   otg_vbus_chg,
   otg_vbus_dschg,
   otg_dmpulldown,
   otg_data_pulse,
   otg_idpullup,
   otg_autoreset_connect,
   otg_autoreset_proceed,
   otg_autohst2dev_disconnect,
   utmi_reset,
   utmi_xcvrselect_0,
   utmi_xcvrselect_1,
   utmi_termselect,
   utmi_linestate_0,
   utmi_linestate_1,
   utmi_opmode_0,
   utmi_opmode_1,
   utmi_datain_0,
   utmi_datain_1,
   utmi_datain_2,
   utmi_datain_3,
   utmi_datain_4,
   utmi_datain_5,
   utmi_datain_6,
   utmi_datain_7,
   utmi_datain_8,
   utmi_datain_9,
   utmi_datain_10,
   utmi_datain_11,
   utmi_datain_12,
   utmi_datain_13,
   utmi_datain_14,
   utmi_datain_15,
   utmi_txvalid,
   utmi_txvalidh,
   utmi_txready,
   utmi_dataout_0,
   utmi_dataout_1,
   utmi_dataout_2,
   utmi_dataout_3,
   utmi_dataout_4,
   utmi_dataout_5,
   utmi_dataout_6,
   utmi_dataout_7,
   utmi_dataout_8,
   utmi_dataout_9,
   utmi_dataout_10,
   utmi_dataout_11,
   utmi_dataout_12,
   utmi_dataout_13,
   utmi_dataout_14,
   utmi_dataout_15,
   utmi_rxvalid,
   utmi_rxvalidh,
   utmi_rxactive,
   utmi_rxerr,
   utmi_dataoe,
   utmi_ddir,
   utmi_databus16_8,
   utmi_hostdisconnect,
   utmi_dppulldown,
   utmi_dmpulldown,
   utmi_drvvbus,
   utmi_chrgvbus,
   utmi_dischrgvbus,
   utmi_iddig,
   utmi_idpullup,
   utmi_avalid,
   utmi_bvalid,
   utmi_vbusvalid,
   utmi_sessend,
   utmi_fslsserialmode,
   utmi_tx_enable_n,
   utmi_tx_dat,
   utmi_tx_se0,
   utmi_rx_rcv,
   utmi_rx_dm,
   utmi_rx_dp,
   utmi_pwrctl_suspend,
   utmi_phy_enable,
   ulpi_dir,
   ulpi_stp,
   ulpi_nxt,
   ulpi_tx_data_0,
   ulpi_tx_data_1,
   ulpi_tx_data_2,
   ulpi_tx_data_3,
   ulpi_tx_data_4,
   ulpi_tx_data_5,
   ulpi_tx_data_6,
   ulpi_tx_data_7,
   ulpi_tx_data_nxt_0,
   ulpi_tx_data_nxt_1,
   ulpi_tx_data_nxt_2,
   ulpi_tx_data_nxt_3,
   ulpi_tx_data_nxt_4,
   ulpi_tx_data_nxt_5,
   ulpi_tx_data_nxt_6,
   ulpi_tx_data_nxt_7,
   ulpi_tx_data_oe_0,
   ulpi_tx_data_oe_1,
   ulpi_tx_data_oe_2,
   ulpi_tx_data_oe_3,
   ulpi_tx_data_oe_4,
   ulpi_tx_data_oe_5,
   ulpi_tx_data_oe_6,
   ulpi_tx_data_oe_7,
   ulpi_rx_data_0,
   ulpi_rx_data_1,
   ulpi_rx_data_2,
   ulpi_rx_data_3,
   ulpi_rx_data_4,
   ulpi_rx_data_5,
   ulpi_rx_data_6,
   ulpi_rx_data_7,
   ulpi_carkit,
   ulpi_pwrctl_suspend,
   ulpi_phy_enable,
   ser_tx_enable_n,
   ser_tx_dat,
   ser_tx_se0,
   ser_rx_rcv,
   ser_rx_dm,
   ser_rx_dp,
   ser_speed,
   ser_dppullup,
   ser_dppulldown,
   ser_dmpulldown,
   ser_drvvbus,
   ser_chrgvbus,
   ser_dischrgvbus,
   ser_iddig,
   ser_idpullup,
   ser_avalid,
   ser_bvalid,
   ser_vbusvalid,
   ser_sessend,
   ser_pwrctl_suspend,
   ser_phy_enable,
   pwrctl_suspend_clr,
   pwrctl_wakeup,
   vbus_pwr_fault);
parameter pc_usage = 1'b 0;
parameter fifo_data_depth = 3'b 110;
parameter fifo_addr_width = 2'b 11;

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   rst; 
input   rst_a; 
input   rst_s; 
input   rst_local_a; 
input   rst_local; 
input   pe_clk; 
input   pe_rst; 
input   pe_rst_a; 
input   pe_porst; 
input   pe_porst_a; 
input   xcvr_clk; 
input   xcvr_ser_clk; 
input   test_mode; 
input   portctrl_arb_force_bit_stuff; //  force bit stuff error
input   portctrl_arb_hst_frame_babble; //  protocol engine detected a frame babble (host only)
input   portctrl_arb_pe_busy; //  indicates a transaction is in progress
input   [15:0] portctrl_arb_tx_data; //  tx data
input   portctrl_arb_tx_ls; //  xmit pre-pid for low speed through full speed hub
input   portctrl_arb_tx_valid_b_0; //  tx packet framing
input   portctrl_arb_tx_valid_b_1; //  tx packet framing
input   portctrl_arb_tx_valid_b_en; //  port controller transmit lock
input   portctrl_arb_tx_valid_early; //  start SYNC early
input   portctrl_arb_tx_valid_last; //  last valid
output   portctrl_arb_bus_reset; //  bus reset detected (device only)
output   portctrl_arb_clk_valid; //  30Mhz clock enable
output   portctrl_arb_rx_data_0; //  rx data
output   portctrl_arb_rx_data_1; //  
output   portctrl_arb_rx_data_2; //  
output   portctrl_arb_rx_data_3; //  
output   portctrl_arb_rx_data_4; //  
output   portctrl_arb_rx_data_5; //  
output   portctrl_arb_rx_data_6; //  
output   portctrl_arb_rx_data_7; //  
output   portctrl_arb_rx_data_8; //  
output   portctrl_arb_rx_data_9; //  
output   portctrl_arb_rx_data_10; //  
output   portctrl_arb_rx_data_11; //  
output   portctrl_arb_rx_data_12; //  
output   portctrl_arb_rx_data_13; //  
output   portctrl_arb_rx_data_14; //  
output   portctrl_arb_rx_data_15; //  
output   portctrl_arb_rx_err; //  rx error detected
output   portctrl_arb_rx_valid_b_0; //  rx packet framing
output   portctrl_arb_rx_valid_b_1; //  
output   portctrl_arb_rx_valid_b_2; //  
output   portctrl_arb_speed_sel_0; //  indication of port speed (device only)
output   portctrl_arb_speed_sel_1; //  
output   portctrl_arb_suspend; //  port suspend detected (device only)
output   portctrl_arb_test_pkt; //  send test packet
output   portctrl_arb_test_se0_nak; //  entable test_se0_nak
output   portctrl_arb_tx_ready; //  tx handshake
output   portctrl_arb_tx_done; 
output   portctrl_arb_bto; 
output   portctrl_arb_flow_en; 
input   portctrl_arb_tt_force_bit_stuff; //  force bit stuff error
input   portctrl_arb_tt_hst_frame_babble; //  protocol engine detected a frame babble (host only)
input   portctrl_arb_tt_pe_busy; //  indicates a transaction is in progress    
input   [15:0] portctrl_arb_tt_tx_data; //  tx data
input   portctrl_arb_tt_tx_ls; //  xmit pre-pid for low speed through full speed hub
input   portctrl_arb_tt_tx_valid_b_0; //  tx packet framing
input   portctrl_arb_tt_tx_valid_b_1; //  tx packet framing
input   portctrl_arb_tt_tx_valid_b_en; //  port controller transmit lock
input   portctrl_arb_tt_tx_valid_early; //  start SYNC early
input   portctrl_arb_tt_tx_valid_last; //  last valid
output   portctrl_arb_tt_clk_valid; //  30Mhz clock enable
output   portctrl_arb_tt_rx_data_0; //  rx data
output   portctrl_arb_tt_rx_data_1; //  
output   portctrl_arb_tt_rx_data_2; //  
output   portctrl_arb_tt_rx_data_3; //  
output   portctrl_arb_tt_rx_data_4; //  
output   portctrl_arb_tt_rx_data_5; //  
output   portctrl_arb_tt_rx_data_6; //  
output   portctrl_arb_tt_rx_data_7; //  
output   portctrl_arb_tt_rx_data_8; //  
output   portctrl_arb_tt_rx_data_9; //  
output   portctrl_arb_tt_rx_data_10; //  
output   portctrl_arb_tt_rx_data_11; //  
output   portctrl_arb_tt_rx_data_12; //  
output   portctrl_arb_tt_rx_data_13; //  
output   portctrl_arb_tt_rx_data_14; //  
output   portctrl_arb_tt_rx_data_15; // 
output   portctrl_arb_tt_rx_err; //  rx error detected
output   portctrl_arb_tt_rx_valid_b_0; //  rx packet framing
output   portctrl_arb_tt_rx_valid_b_1; //  
output   portctrl_arb_tt_rx_valid_b_2; //  
output   portctrl_arb_tt_tx_ready; //  tx handshake
output   portctrl_arb_tt_tx_done; //  bto found
output   portctrl_arb_tt_bto; //  bto found
output   portctrl_arb_tt_flow_en; 
input   portctrl_up_port_owner; //  core has been configured (EHCI only)
input   portctrl_up_data_width; //  selects transceiver parallel data bus width
input   [31:0] portctrl_up_datawr; //  register write data
input   portctrl_up_device_mode; //  device mode enable
input   portctrl_up_host_mode; //  host mode enable
input   portctrl_up_phy_select_0; //  characterization logic select
input   portctrl_up_phy_select_1; //  characterization logic select
input   portctrl_up_serial_select; //  use serial phy interface
input   portctrl_up_port_power; //  port power enable
input   portctrl_up_rd; //  register read enable
input   portctrl_up_run; //  port control enable
input   [3:0] portctrl_up_wr_be; //  register write byte enable
input   portctrl_up_wr_tog_en; //  register write enable (toggle)
output   portctrl_up_datard_0; //  register read data
output   portctrl_up_datard_1; //  
output   portctrl_up_datard_2; //  
output   portctrl_up_datard_3; //  
output   portctrl_up_datard_4; //  
output   portctrl_up_datard_5; //  
output   portctrl_up_datard_6; //  
output   portctrl_up_datard_7; //  
output   portctrl_up_datard_8; //  
output   portctrl_up_datard_9; //  
output   portctrl_up_datard_10; //  
output   portctrl_up_datard_11; //  
output   portctrl_up_datard_12; //  
output   portctrl_up_datard_13; //  
output   portctrl_up_datard_14; //  
output   portctrl_up_datard_15; //  
output   portctrl_up_datard_16; //  
output   portctrl_up_datard_17; //  
output   portctrl_up_datard_18; //  
output   portctrl_up_datard_19; //  
output   portctrl_up_datard_20; //  
output   portctrl_up_datard_21; //  
output   portctrl_up_datard_22; //  
output   portctrl_up_datard_23; //  
output   portctrl_up_datard_24; //  
output   portctrl_up_datard_25; //  
output   portctrl_up_datard_26; //  
output   portctrl_up_datard_27; //  
output   portctrl_up_datard_28; //  
output   portctrl_up_datard_29; //  
output   portctrl_up_datard_30; //  
output   portctrl_up_datard_31; //  
output   portctrl_up_port_chg_irq_tog; //  port change interrupt (toggle)
output   portctrl_up_wr_handshake_tog; //  register write enable handshake (toggle)
input   portctrl_up_suspend; 
output   ulpi_up_datard_0; 
output   ulpi_up_datard_1; 
output   ulpi_up_datard_2; 
output   ulpi_up_datard_3; 
output   ulpi_up_datard_4; 
output   ulpi_up_datard_5; 
output   ulpi_up_datard_6; 
output   ulpi_up_datard_7; 
input   [7:0] up_ulpi_datawr; 
input   [7:0] up_ulpi_addr; 
input   up_ulpi_rd0wr1; 
input   up_ulpi_cmd_tog; 
output   ulpi_up_cmd_handshake; 
input   up_ulpi_wakeup; 
output   ulpi_up_wakeup_handshake; 
output   ulpi_up_sync_state; 
input   up_portctrl_data_width; 
input   up_portctrl_port_power; 
input   up_portctrl_device_mode; 
input   up_portctrl_host_mode; 
input   up_portctrl_phy_select_0; 
input   up_portctrl_phy_select_1; 
input   up_portctrl_suspend; 
output   otg_pc_data_pulse; 
output   otg_id; 
output   otg_a_vbus_vld; 
output   otg_a_sess_vld; 
output   otg_b_sess_vld; 
output   otg_b_sess_end; 
input   otg_id_state; 
input   otg_vbus_chg; 
input   otg_vbus_dschg; 
input   otg_dmpulldown; 
input   otg_data_pulse; 
input   otg_idpullup; 
output   otg_autoreset_connect; 
input   otg_autoreset_proceed; 
output   otg_autohst2dev_disconnect; 
output   utmi_reset; 
output   utmi_xcvrselect_0; 
output   utmi_xcvrselect_1; 
output   utmi_termselect; 
input   utmi_linestate_0; 
input   utmi_linestate_1; 
output   utmi_opmode_0; 
output   utmi_opmode_1; 
output   utmi_datain_0; 
output   utmi_datain_1; 
output   utmi_datain_2; 
output   utmi_datain_3; 
output   utmi_datain_4; 
output   utmi_datain_5; 
output   utmi_datain_6; 
output   utmi_datain_7; 
output   utmi_datain_8; 
output   utmi_datain_9; 
output   utmi_datain_10; 
output   utmi_datain_11; 
output   utmi_datain_12; 
output   utmi_datain_13; 
output   utmi_datain_14; 
output   utmi_datain_15; 
output   utmi_txvalid; 
output   utmi_txvalidh; 
input   utmi_txready; 
input   utmi_dataout_0; 
input   utmi_dataout_1; 
input   utmi_dataout_2; 
input   utmi_dataout_3; 
input   utmi_dataout_4; 
input   utmi_dataout_5; 
input   utmi_dataout_6; 
input   utmi_dataout_7; 
input   utmi_dataout_8; 
input   utmi_dataout_9; 
input   utmi_dataout_10; 
input   utmi_dataout_11; 
input   utmi_dataout_12; 
input   utmi_dataout_13; 
input   utmi_dataout_14; 
input   utmi_dataout_15; 
input   utmi_rxvalid; 
input   utmi_rxvalidh; 
input   utmi_rxactive; 
input   utmi_rxerr; 
output   utmi_dataoe; 
output   utmi_ddir; 
output   utmi_databus16_8; 
input   utmi_hostdisconnect; 
output   utmi_dppulldown; 
output   utmi_dmpulldown; 
output   utmi_drvvbus; 
output   utmi_chrgvbus; 
output   utmi_dischrgvbus; 
input   utmi_iddig; 
output   utmi_idpullup; 
input   utmi_avalid; 
input   utmi_bvalid; 
input   utmi_vbusvalid; 
input   utmi_sessend; 
output   utmi_fslsserialmode; 
output   utmi_tx_enable_n; 
output   utmi_tx_dat; 
output   utmi_tx_se0; 
input   utmi_rx_rcv; 
input   utmi_rx_dm; 
input   utmi_rx_dp; 
output   utmi_pwrctl_suspend; 
output   utmi_phy_enable; 
input   ulpi_dir; 
output   ulpi_stp; 
input   ulpi_nxt; 
output   ulpi_tx_data_0; 
output   ulpi_tx_data_1; 
output   ulpi_tx_data_2; 
output   ulpi_tx_data_3; 
output   ulpi_tx_data_4; 
output   ulpi_tx_data_5; 
output   ulpi_tx_data_6; 
output   ulpi_tx_data_7; 
output   ulpi_tx_data_nxt_0; 
output   ulpi_tx_data_nxt_1; 
output   ulpi_tx_data_nxt_2; 
output   ulpi_tx_data_nxt_3; 
output   ulpi_tx_data_nxt_4; 
output   ulpi_tx_data_nxt_5; 
output   ulpi_tx_data_nxt_6; 
output   ulpi_tx_data_nxt_7; 
output   ulpi_tx_data_oe_0; 
output   ulpi_tx_data_oe_1; 
output   ulpi_tx_data_oe_2; 
output   ulpi_tx_data_oe_3; 
output   ulpi_tx_data_oe_4; 
output   ulpi_tx_data_oe_5; 
output   ulpi_tx_data_oe_6; 
output   ulpi_tx_data_oe_7; 
input   ulpi_rx_data_0; 
input   ulpi_rx_data_1; 
input   ulpi_rx_data_2; 
input   ulpi_rx_data_3; 
input   ulpi_rx_data_4; 
input   ulpi_rx_data_5; 
input   ulpi_rx_data_6; 
input   ulpi_rx_data_7; 
output   ulpi_carkit; 
output   ulpi_pwrctl_suspend; 
output   ulpi_phy_enable; 
output   ser_tx_enable_n; 
output   ser_tx_dat; 
output   ser_tx_se0; 
input   ser_rx_rcv; 
input   ser_rx_dm; 
input   ser_rx_dp; 
output   ser_speed; 
output   ser_dppullup; 
output   ser_dppulldown; 
output   ser_dmpulldown; 
output   ser_drvvbus; 
output   ser_chrgvbus; 
output   ser_dischrgvbus; 
input   ser_iddig; 
output   ser_idpullup; 
input   ser_avalid; 
input   ser_bvalid; 
input   ser_vbusvalid; 
input   ser_sessend; 
output   ser_pwrctl_suspend; 
output   ser_phy_enable; 
input   pwrctl_suspend_clr; 
input   pwrctl_wakeup; 
input   vbus_pwr_fault; 
`protected
@e:JCSQV5DT^<;6i4k\:CR5\Z?`24GO1gXEed2Q@eDIA=ahnTTT@K?@3\G@MdIaK
bJ^HHVF[B;\k[fXq\]0VdUOoHdI_FU2jNZ^0oEaV29SnhGleDJ2a=E;ejMP4J=Uh
kZEX<8ph9FZ6SP]Ej]?N33bhAAH98eZlLXP?Bk52YX`C^kUmQV:[Y;hAiQ>Ehl7d
VZ@pJoG?Z^qO;M09m>6<KT9JnH20T5^GDKiDI>j>2b4O@m\BAWpIlO28=EARBORi
mCg_1J8QbCl5fjf59GU94DOJ[hqFRlnSW63Y]DYhf]@ZU`5ZQ:8KoLF:[No9KFM0
jAqo@Z\lX^Z[94_<L9e0V62=ICA9SHU?oaho>HH5FRp[De^>X=Ge=h>^Xc2UOOOj
c`256?1;ZN8M6G]MZipUVL]6`OjB10Zl7V`>Ukeb?k>TXFSm@RCC0D?JZgqPof5<
HH9m^3c4_QJ:[QAVKjhHR=F=YS8BTk98?`7G7F@j0S5=GSKq4P=aNEV\ch7Vginm
^cBm;360\^iTd^8`AK[TId=q@gR4ED4bbW^8SeWciCnc`NN6j4E8d>he`Jdcc`Qq
nbb@=dlnn>?6NTZa^91iEiCEblS5oE>Wmd^nn5<qSJ@27Te@S3j7JClL?:<1K=EE
C<4X\LnaT<Ci7:RqHD`UBSheg@CLGBPY]\SBbJ@:c<ci=K\lgEF9IPBp[k_hADNj
7A`G?@JJ_P?8o`f4GagR[gdHe_o8eZXpTE`cMa`BCg>U`X42A4QeOg:Y9Ol3EO;T
gWa8RnoCp4Y1PTGj7MQ5i`N:C4l8C>JIdbTq<mXAbNA?m>m?M\PHYOeiFIYN`3`a
QK1DT3l<fNM^q^KD[2`K>e7fK?Tn;bT\;KhBdI8?MfINUWF@iBi\^p1C?7<;O45Z
[ibkLYPTd;PhKnJ8B]Z4\_dQ0oZH\bqGA^GQ[3[E8G@3mcbm4K4Vj<UOLP8LU6`L
4=WTbgRqWgn=AL>:`no@GC=?<fCVLAeMeNF`7<YgS9HRUO5nqk3VQchMiD4BhFRo
F:40acoId<B3nn0eZ_P]p>:e9PXOmD2XimhoTOfmN\TU6YWX[PE?Wl52k^G4;qn\
_B;HdB>=kibeV=TF\;Y;hfENU45SMNLnYa]W0HhhQp2E9I4\T?kD0_<`dYiUAP?`
D@nRU8?DkXR\@X6ZSW4Z6p7LAN[cFldL]TmhAm?G;HVG9U1fc[E__Uj<aLf_QOiC
Jp>miiIKBHjd>]R@1TFEgKcn_Hn:BjBD<KPX:RWNej5iqV@5F^IDWcL265HBQL9@
LPf0V^W42>67N3OfI_dDd76p8VLEVTOhCDN85jh0WlK3M?SA;`>G^9QYg:G8p4Xj
1ZU_;>6oJSP<`_Z[<NeO6]H]b0\TJ:VVcXRqVDUReA;?2DaPA4lA72_5P:C2`G`E
IP6[S<m5]XaZY92qbEjTnkDd0CS:JL=LK`B5TidJV?UmOiV>3MnfS5p6oQjn[A6j
cbQO6e`o30R7<F2mcJ_I78a1dbUZTfbMQheCRFDSYAC8Q\V[SlhL]=M]J@NNLPap
Xmk^`ej4X2XeOngYM30mRe;al?7ZNQEZ\\0bpi]i8X:dkM[b8LJkf;G9[;VnR;75
>jb:pH2=I^@O<2D5A[WOkg5WYIVfX9`=\EKdn=M4Nq<dOA7;\bDa\^=a8HmAig;[
\=]KDFFmqcGFFHIBDa[0i8T=JCmF;5OPd5iLV`I\2MY?Dik\BUjkqd:FRgo@o3XY
oVFC\KPPN=BXOGM;oJmiS<6[9Jn^AnHHp4gKchE\<5GfZ6Q?2@8=ND045]9f@o]F
<c00kRW8b;gZqGEJneR<K=gG;DeY8C9BOaQim771BoN8LIYh^?30FCjJpKIZjR?^
TeU9[ibZ<LG0aj3[J^[Tf@3F<F]VC6W9^`S<q\^e>;_IAbIdmU8cnWKbaDFnnL0S
h5531\UK;m8a>C_Ipl^i5ZZW1oj2^MD9lSeV6C5BSfF143SADF?;8ZX29o?9mnZk
i\Vh8bXDGHFb20]q][SEFMXn1A5K5_=MHf=kI=C7jUdCA^_nkG?nDTPMN0\p[\<Y
<;?NE9:S>N5Q2Ul:m2h\FjF9VD7DS3boc\IL5E3q0Q=iIPc:\6R0<4:279AA9_o1
G5FTWFRd><cXZRm7AEipb^Ym<H;m\oh9RH`@a\_n`YO^[<NZW5NE@hZYV5eAiP@p
l_NJ`Og4QXQ2cOPJLKIlR_NUAoT:[PSHmW19JD1Y48cp\5QgIKmlS?JXBnQOFS]=
eRe2?PfS?e6W:L=822Y6DOU9qo@c7m22Rn;CX]T80eUBH3GWDl\cj>>aPbFXf34g
5ljiMpZ;fmc?J77a4H0TV7<=HM4=VA0SD0Td5@Ne];h<`_]RVXp5dWQ8^N^Lo9KO
bImF26C^[0M7ZCgkC_e_RnJ9LELC4Ubqn84TPHZ]2:_lmM:ImQ^B_kF;>SGL@V=3
QL>V20>DK`i0q]ZA<W;KQ4`6C\@`=_hAT4AjoGUE^mRLdH0j3S2KL>7@np^LCLc^
Cb81L8>N7WN[[:0g7;\[:@;ZF9MA0=Z0WV7J:0qUi>\>50d:d172_DCF`=n0j2iW
^PLi<jP?CZ2oh0pGg5@R1<SZ@gSF;P<?PC9Nj74Xg6TF01cLikZI<9Im\_]242pU
RQPFI24lO\FMbjd@LM@;`DG[j\^KZVBchWQe6nWkdV:[i7qHE8X746f\h:3?ZIbD
6im;]:3E5Z>8KOm:919h84]4k\Z7R=qEYUfM=VFc`iCYWUilAIlS;ehGaTUhgXSh
?G`9DeFl:qI@gb\gRMAg0PlFFnfFNk25FnaPZ@GLaaV:go?\EXqi`6a:PJn=8Y=_
Bo5MEqMmlkTFj=hfl:[WH;<3cJfSI=Sf\fPmOAhPRpG5Fc`LeK<Y93JdJIJb@\NK
?Dk=h40i1lOnX]<;F6p5e^WGJn?OLoPPlj?gYB574^Y\l:Fl]F9>S\BpJG=YRgR>
^2<HV_2e`^RKm<G]]LZDB^>=T_iYqLHC`k:3F5]V655<33JL3@daYGT^b`HS:X_W
[p\gXP>]DVcCGPFRi2RhfhaY6UO3bm:Y0J[PEdqjLN<DK9Vb^B?RVGa_l?CbCAoH
M4l[k7gW`oRpT?F@5N]IPg[=E>Xih_9]Q>V]WXQbFC_GD20VpR3LVFDgJJc1g5\a
k=_m]L52<dnQ6V>2SbVNlp38IoTS[@g`a\RVc4PmaYDAh5F7IHaejd8l7d?N3eRG
SF:R:4fTWb5o22<Lh]W3GGE91k]=FOqMY;J_TD9U3TJX1X^IgiUG^lLh0TKkbNhQ
IeoqhlC<CiiAfin>WEmbK_hdl?<6oG[V_BnN=i==p>kg6dfYlNSTl\jl:`]H<>PU
fh27>7m4e^>_eq1D9LW_6FTC_<U3fX6hQ6T:ASfG3cX;i[4cb>UVp_WE=dfWN06_
YT:0A[\jj^d9<NFNehlWgEEo`GAqJe;TO:5iYYQO9nf1=@FHAh^iW;9l8A0Yefjj
bRp`nIg<8UJJOW1hPF7;omTq:A2:CkL_fd^fFL_Y7EhB7mHaP]LIQLfgUFZ25]qB
omF1f[kfjTBb]32JU3Il`7c^iX6biib^E84RJqVYH5I4HQi@1VE_WTBK1]@RUH[d
NfBI`BEDd7\2q?>MHg^2A8`kPAfn>djA2NV>NnGTDl<>1XWHhTBq`J0O@a<MhXak
7SFXmimkecA=D]`lTGO`hgK@Alqd^Cn3]QKOJEDN[iQ56cU]G7U\OaFST][8DCcX
mp4U_>HaaD;^XlAi[VRK\Clk=H6h^]2l:_GEX]a4pDd@>ClZEmeKDIOf8>05O6_7
V2fRbEJ16eb1YLTq<8CfFno7H]a:^2YHi><IB3d0Zm84;]3dFKLLLap9Y5C0:=kE
if[60`j]G0<>6pdRZ2<@X55SQLPQe4NDnELP^62<O\g4IOnFXV9Upb09kZ=R^RQ9
BE?l9@NR7@Zd8Q8F?N8F?@Pe6;mqATbS9]mcgad6P<[^1c`mlV`MZFcH;AbMU]YJ
d<qDlCmBi7h[R>lE]Vj4Sa`VjQG[a:Ijf=;6\1lL`qN`SkW4IPm[fMVhUG\aJj50
DBM5=lqBS:a05n3P3R8oQ3YR^NP3gk<a0K67bf<CWKbBKpFEMNX`R<FCDKBgf\_@
IV:`7;24TDDi62C?h>4WpX]EW9n^^gk3l0`C;0e_oB2kKWbmoYo8EbHbVd<qK0C6
]T[[5<nHjK8UjV>4VkY6i2SYOA[=b6ngWgqR6aG4:<=8>[110kQf3mBE]3Pnh0Jb
dk7hZH]9<pE@MmL2EWIPcX\6R0`\:UVmYL[A<K4_R=doM2BMpgfG61OU=XA\oc\g
_MncOgmhcLTC::CZ[>;kN4eThaF2XZ<LpLWRieIV1dcU;`L5n2JOS`^A]K9H^UEY
noRA3XcB;5V]41]bp]MigWF4=6589\d67O<6^I>@>3WdkLeKp[@?:jfV`IDl?W2l
ba92k6F3i9:e2NLJDVS[4h5NjBlVH1=W`gYqZbC4_@;bB:d\VKYb86`7`n[k1?>L
D3=qN3Rb45\F7H0HUSl0`8nXT6LSghkRdHJqB\ikJMOf4WK5gnnD[kH<^h0>DK]5
PBnq:48^Pa8Mc]Vb]8Z?5=EJ<imBTXoY7cCqDDX^em?JNnai7Sc?\:<KoG1;2VG0
gB2pPTN\D^a_V\le`\c:Go[NJa]JiMBcNDgq`kS0<h5[`B94:4^5HEgWflH\XWGP
U==q[YK8Hk_7AjoiKK\Whocl02I`WPDcjlON2mjVcbpdG=TOEGLK;HHnL9bW0R<`
:`[;Q;e5ChAC`S0eDY\CT[XReV:08]WG;6C?=bgO1qHbk>B4_@SkP>U0YaFk:@o0
lmbMaF<Q26D_<JPeLo1EqPM36W6f]XfOPCSVUd2AEBjkc@N6Zb79oB9qdfgQn<Lk
[V<Uc@4b2HncV5mD\6VG7L]Pq\ocXb?nn9o:7HJQ68npG8YX^:LbM`dHD43QND^9
X=R1^[KdpKPN9GCh@N@=8WU6HI79Ae48;<:4fpGeP[54bM:Pga[Knl1EOj;S>`^Q
YYp8:W]2fRnB8V8Rjn_g]a4p@FQ??`0H^lJ\Vgn5hX8=0Vo4b=0QqQgY\4d;VGd\
[EgZ<Q9nHDW;T=4fdTWN`3XR`]3pN3Qa146A2GKh:cYR1hiD@?ocH:;CJYd>6]NP
7\Q8QM5[p^[fakS?Fa71<b_6B=mYk;_TqcLa5c3e3A3mC2Xbm@EPCQ5Cod@\MWP5
bpk`5eg7KaVmLka9gbF9Ga<54Am_0[PiClplV02hkmGX9B;<B;7L0Tb]K\nJ1\dE
7pffAUPde\6BJhZI`gjhi7?`[a8D_@m8G]<KNnJeU:[8U6<KX86K37c6c758?72_
2iPbZliS1pPcU]kXR`Gh]m>20BfTnmW;`>eg4pnd8U8]d_OY1lRU@Y=14H5H3nWa
apg9Oj[l0kbXESkD`6C37n0dOjjiapZb>cIcASP^2e;>8SEI\m2Re;In0qX91RnJ
GLLRjI0U;>450bC1>li;Zq^B`UO3?Y0GAOh=TU4J`h6U3@lVRpSEMD6<=MbZ>R\H
fNL6LjNmZk`S^CDebM\Oh^X3[igLU<3^SFO[4E8\igq9?XgUfI_UgIk10TVR`_[^
_kGNo;q^PlP\3ID<>_O8[?D;PkA_lJ32lmpY?blfY7m6_jf:0g[`V2C@Y>6Wi6p6
6JU_b4\Va\X6caT32Hh=^jJnTOpHj]QFAMaD1]\RZ?a9_Pd8L=6T07qE636W^Jik
dHUAH5X\M`YZ>JaaaUp04`\n]YJm?CNVbQ80jTT4dkNjnW]qM3]Dc;KXi@LIK]Ci
cU`W6`CE]?==p4cW`V3FCMJW<04TeRb]MknpDC338ImA5U_RS;VKba8\e`@0d]fl
qXB9@Kh<7eKME;hMT0ohlOS]4CIL[pP8mB55\nR\CQMleSPVHNkTVMZ@BFqmUT=9
Z=ce=PLAjcbSgLC::eP16Thqlm5hTAE8>TmKn;S^Z<fTJd?FU1qfU^VQYPMcTJlE
81>g_ZCR@[MaAoq\f1ibFI_cc_?=59Y81eE^FRZpPm1mc>9`BRP8YjAk8a;V^^pB
1\R?FgBF_cI1?IT=\Wlk9E^[He2<K`qVYD9oQV7c4PWcK^gamXAEAiC@=>8hl=Fm
f]mPfUKH[g_K><``hQjF13hiVLU:CYF3B0P8g<qS^HfPM:A6hQZ^7XF_Q45a1UjD
c3B_CpM9L8:^bc`h=XOPWcU7R0NiS;AV8m\dpbgC>h7@WaZNQMVSi0V3@?JAcedp
57f@^N0UO8h5dOh]?_l^46S3H`gpJ;[dnST4^XM2\m]KZ;R]>m?=<OlaGb`qg7X7
mlDhEAcPLF4ZdE6:YL99SH=pjL5HOlofQ\eAXX`<PaA]0TE>?h==^@eFA4Upb]25
hXS4`@8\h?]AnXG6T_Eeh:=^^?^p_@fA;2cRb;[047Y8B:oo42d9q^]iDX?:JFDc
UD;>gPPQIMWphdB?Tde5RABI3QSA?IO<2nEEpgSD@`GJYEifegL6f5\>F4IQhlXm
WBXUgB62p2nIK7M<XaWD;9]18kji`H5jYZmN?=@q]mj8aD0eYFKbQAMb3kEI9R:b
SYTkDRc<lmZEec@PMJ1[5:>jI0qG0[J[KYbk6E51efjG83_qJ;Gg3oe>_\W=0GIN
eEeg<Dk539>Sq=j3`3PnP`a3]Y7kC[;N47a>j?]23p67KUb=eJbS<U>LiiU`fJ]e
A@mlmDqjPWkD`3=SgP\=\C?8Kal_UR>08[CqhVg\Vf\PCh_e2oVWIW:9]a::f:LP
qG=n:K=D279ino99j]TY\CXcUHd4PqD1lF@hd=ciX]f`\jK<U89Ycj@DQ9pV^BEb
CH\21Zn8gL0bL5EHE0EO_G0p<8kYhZIC<5Kc[f832GfChg:87X8Z=22I[gG0em5[
dillJB^1JDMkkm_VdUpON>>db4BGlD4[kOAcIGF6O7e=6Al5WDZBBpT@_2bMVXF`
:YZ;RG6oQlE1G27JjG6dOd\7pE5Q[;fVcn>LcZ3cGcYG<DVfcSlNK7DM3:8pm>AW
ic2fLCQgeeeD:3D\_fmXVgI0KATAmCpD>jRnINPo]c`H2SmRPn?nl_Y]N;\:@NIh
Glp0UdARg3Fjm7G3h?IkH8`OIjVTLVf>FKLb2pTa>^268a:5fPfi9i7E>Ta;BHO]
UDEjcm?hqe;XbXc^Jjh_]mhWh0Bh_n`AKDPXMhP5\a6q85=]j;]:7XB0<=]LYYk5
FRb6NPVEUIOi\cqJTGTIXQ=id?4[BO59LOT0_ZXW3llMhL2podC2S<c@@2=RSn@?
I9BT:>kh_d:dNmkEpPkUijjA4IH\H`SFj[lHmn9gPneS_6[aOpHVO`<WdXllM5=e
9cXWU[?NJaPWk:XSUVq]0`no^`QjBR=lTcmoG0ijCXWfcH\`iboqokE\@XmR4Dgk
D8_>Na84`3>[JZF_k9NaKbil:OpX@k2^AH>2\fB5>?F>bcDgTmFA3kd=V[UqNKYk
mL@ECjQV;nXTAO>dX]N:LY^TTa98pHWMKAU7mncU=JGaJHA\LPJ9EC>BP56UGpbg
;AfC:F?T5l2dK_;X0oA0kQphD4PBV>GVf]nBjFI?iMZS3FVGhd1EOm^p@dZiOU6;
W^aUdX9ba7\TM4a2D6`GDdO7aGHpdYI\JEGT4Wa`RBU`d`hcFd;ahkRD[^p3RQcF
a=\QUG]V7F>?Y_J>1T:_k9@7CpF1AgMXlSJgPW6HNNQhMgbY1pe<jT;KMkDi8U22
C04[T7KcXh?fQ<9m_>MVPcBZV:6n88VSOjp1F@nlO=[=o7PNh:`OHkn>V`qQ<:j?
YC`HI2l_k[500]Y7op]6lF0k@El9;NfGAaTB17BQV6ABq90AcUEkOk4<b`k2flZW
RAKj=i]60qI5F@HhCO7MW7\\a6SE:8?OO]=\ebqU@SHg46TC1TO;OJ@1`SjK>M0p
>1ic@X1hH4EC@5>3ORGbTBoH;Wp20a\ScjdeJ53[X7A2AT^IK7:Z<DH0Xp<Di:Rb
36VYJCoKEK[R34`bql6ajW0cc7<3n5Mjn@;PmeM@5m5q\QZN7NV92ASeo92\RC<_
Y:ZKSEle4dg\c4pd?i1o`ieoiDl]8]6gN<Xdakg_5baqbOZ66H@1ho[TfE4SD`7V
;AH?Q5XRVB93ZPqD\M3iQ^TVGcM7?KeY=>jWETg7Y;WI9Fcp35cRjg0fG=B5S7R\
7T@T;`@DB];Fo8FmhXpGIhYcnE@og@HGO]LNaoJ5\b4^BUH>=:[dLZ9WUZ\MF[2R
Wq?QkfYWT8Q<JBX^qff_V@NFJ>::F15HQ_K:N3=Heb4BdY]d]pTiHhTnm5Ub730k
7[mTI<O@45o29be@c@Ymp57@ZmK]Eo1<dg[L9`VBLnFOB^=NKA7_X;9TZc::JjcQ
1pk5mf?6iX:?dT6Q75?3UQ0k^_bEj7pS00:4U;J@bQeC=25]JLZ7lkBHm[g=oV>W
?neD>S=TVI[qn3>AMaG0SF0bn7BOeVkM:`E8JS9m>L1qalK4D2XcINMUl[<[1Tj0
J<j@XFIN18qT7O]Ec68=I\f]R[QMJX@0FFBp45XBE=YIb[487bTRKWUF5aE_^WI=
?MaKhgp9b8O6cTP7MEUFH\2?l_;UFbeRn848RlSpY8P2Jo^SR\kK1CNoESI6Y`8J
Ug:11C4qa[Eg0:47;Z=W=OF^Rn7<ja1OffSNCPeP>>`<0RDji@SRAdSpZBi[@DC3
fE`iJ8B>eI^AFLdHd2<>S9c;VJI:HAjBN:3GTiXqH^P51B=f4d2<Fk8NobF\?KJE
SC>`gL3`JO^[WQfpmRm<Y]f\dF^i@];=A96a6dJFJ]3@Ilm]pVl1AVRTP`aC<hP[
Pj5=ld`>;n4]jg=nGO12Ygk:U4Kd2qd6b`6B1JgjY\h^C1^0QK\@cQ:BoZOnUR;d
@pYGESCgDKQe2NN6VJ>=]c94a7gNY26fSC5n0qKh39W4N4jIQGZjDgQ=oQG=JBjk
HPg4:C>^hY4RFEeV[]qUO80YHFi[9BG8i7XTEmc]C88`SUhc4=jkF1EWQ@q[YFc[
gQoiNngSFGAd;=JCHSBOKSC9KA4LPcE[1qT>P:2Xj\OFSSU\[Al;fdX5\1;fnXL=
aWiB?qnVKbAP<Ul2\UlI1EUYSiXK]TGM3N3=jd=JqAi_acZP^V3<:Ooh@N3gfQE=
GRbc5PQ]2:b;=R9pJQdRKgI4aGKE]XUVHK]=W5VWH^fT6SOQ;HRAmT7=km1AZ=V6
6afqC0\3<1XBGiaXdk92R2>;MBIjgiYh2UUT543>a\cTNWm;cXe2`?bc\?gMP9qi
@eeZNMcl_;^lXGUS`GEJ7llo?Gg^Pia[;:Wl4U1g4eig]Df>CqYUH1;0`ZPlld`8
L\Xmg9gPhbZBe]jQj3R_pB3d\QFKdVUN0W>2NdZR0m7S2>I@aUg_?RFbDf=8PZJR
GlNXajjq?BefN]]cXT4FnX7n;7a:61PZ81D28jZ`mGe6SMiNL5^UPRTbhBi54hBN
DXK;e5YK_<qmYLbj?eVHTS1YXVI<V654dO:hWF;IF97E?MnqMfHA1aTkNX<UjINf
M2b:RddFYEfdX:[ClAfpQ=O>I\kUUGj<O:m]1RfS_fj[8MEjI]q>6U1QGdBCbc9A
3n]GZM1cbR1OOHEjQAk[Q:SpWn>IDYk=ACW:\9I>H9fT=njJC`S7McV?VkYY87qR
9h5iJH>:o=C6GLJpA0=gB\GYFB4VPgXMV8K:5A[2N2=RB?32_1gk]Xq1La9Ol<>3
CG4>9h;KHoD]@Nl?b8F67mW3kT_q<X984]O:dN[VjM0k5GZ^66PmKUBdGI`4KP\;
?B\Y1b^2nNUiM3q0HiHU\i>j4@MC6a:88@1L1=jFFMS[<doVC1RBk^Q065O`C0Qp
Y6UPM`g9YNPK6C25]hHF`H`UageHM`EfR_TA04nL=;<73SA:0TikgKBep2J>OPOB
ZZeQ]X:F5cC@\2LM@i6FWH1fgqGBCIoh4\>AY<@:8;V96?UWY@N@B0XY`I2lId?J
I6GIYVM@1dq>Sl`[iPQBURHXI=9ZIZo[moYT_Qlj^_O8Siq@\kTDK<X7M9J[3NOW
<CAX[Y3Q9Af6813k9pCVl>;8P_2mTBI0oR14A4116QF1k:pkPooQ8TLAQBj_DNO8
flT9M550dKcD:T]Pl[=V=qM3b1;mmI_LYc585^BhhNO>TT7lN@`>pA<IY_CiKi>F
ago`gNcFJC?_lK^\33Q^iMG]kqDQ7he8[TL<d?@L0oG0W80;`fkfX^F5?m>gX4?W
V:TSq@LI]?EcF]DE3Y6gog9V`P;DI941hofIT<8@RRRcU>JV:jbp1<W>`YWS`]V4
:[]5jF:`NLH:0>6k@8=SqBN8T:`Nl@=6Q4??hT=TX^bjj:QV8I[?fS_V8qB518R]
9<f6?KclB2BMYI]kXJddmKpO4i24DUjn\<C@AgXRge8EW4=AjDoM:CS4;Xp27AXl
R`EB]dVT\QNYZi8AF5K?la@E3\3UNbJpd[F:6=ObKoNTJglDQ8G]JU7QQ7nA_J02
7:5:eLKXFG>`^SiLqG@^mkl3_LnjU^?S6<D_5`L>P^R7TG?XiO80?bbLh>4XLo_h
pnZ^Ub]cXgYMSCH\8\^4ecZOD7Nbo`nY@aY@\:VJY<1pk\WoOhFKhSloi7D4OOVT
W[;Im9K6g\kqj:4R59V>aDnj9bAb1djEmR_U20>6?>RJ8Re7gVg\1?3@E1FqJ4^T
U3TeTUW@:bHM^aad[nE@`oenS6g=jcq@omEhnj^OF=gacDKkF944SmOL6h9PR_Rp
hQ3Ta3O0Gbb@>?T[Co]g6MkN;NCOL>\hOLoUl8UFl1CbW=KHa`nJTYV\Y^\mTM<9
3FJF96Oq>SBN@F=jLaD1i5:Q21NDYKW\a^Vp1aYASTCg\?:@WcCK?i]c@Mc]V[:U
G2TQQY1=pnRYWf=o[FO=:gnNM?6CT6=X]3?DiCSBoYnqLeM\R9R@nG?Nh1J57M2S
=`nNcYXeJDSP[K<M2ZF`gc^QdZXMfhp_fd]Q@m1BTJaWga:0_c?L_X=H2D30mEjR
]6^6[;[8fc\KCh2GopJ>m7EP?UMUT3VNa7beMAnb[L<GV`0U[kYlVCiIcH;<p;\R
@fh]9PgkFnZEhRlDeeBZ8jd3CbL=d^FYen]Pbj;iGO8gpC0fVW4IKE;DD<gaIO6A
M:CYDd0;LCHVdjI0P_=q6\S]IQEnWH7kBfHP43Wj3L1@N[^P2Io0X6B7P9QbFJGQ
:OMp0jS`:56\2SgXKUa81aE7EN2\p;lO9b?09MGOb3K^XZfh^9JRoDK6`gd95Va9
hePhRR?qJ\GY`C[Iaib<<e@<SJm5`2DH3=e2m>ZOCEBd_?9bqXVHUTm4b[mD2@X7
4jPl4<g00[U@<5aDO=RKEpN?XbcaBJ6I[4<mo`Z6c82AG4]M2Kc:Kk=holpNMOBe
]A[VcBfdLecH3_]kQfaV:\NAI\DpCg08ooRe2IMkOT\ZT2fTSVP;ZHLDC=88<H0q
>m?;[hJV>f?kDB?O;]TegUoHdD7dYM>3O5\\hXocC8Uqk4UnSIX06m@7Y`UIQ;7S
mVFAWQag\6mm2K3;m6lSanqhdE7a=JdaGjP^KLi:Tj`?Y?TOS3C0CCI]6FV`T0GL
O6<cQ2Li2MAa[gql^3K0iBIBKXEVdO5]E2Bfc1Z28VBL2^:C[?P_I3K25floJZ>q
l@]d<?:nmK8iFm>=Fi1]:YF:9OZE33:D0F3NWf]Hn9MPS33<P5ERJApEI<oV\9F\
nNJ`ao0=RX3_lknYgiDBKZbVMF1\lpJ8:3BKEBEST2__m\0e6o^=ZQ\LDKQTn84n
58_]=Q^TCF@]EmAaaeSepW0;g54jHGjRQ4kd_IAV7jWU0K:Q9iKjkQ9R\CL95qGa
[7aZeV\7?P?\8Ub18=2K\@DClQ\V0PnY16_S@qJoYL\NOCgOjICQQT43BHZ5gFfo
IPGXKElEQU_IpB2O_G_lfU_mQ;;g2<bUF]X2EiJO0f9HP=6q3@@[K=ok14[d;T65
Z4;ZBP?8Ghig3i_SnZ1HWPAFHSEqI0YkcTU14:R4l@P`A4_nOgW8:EE<8D16Qnjc
dI=o@dqHQlbL^h:_A3MJo6aQKlg=9:Sl`@KOZ?k:ac8`mU[gF6^SLh0I;hUfcDqH
^Xm1aWE5?fd?;<L0m0<e8iHMjY0GNN:h=iK6aiaPLPTAaGkR543E9:j[mWPWD2]N
<?qCF0Z8:ZfN1N0L5D_3?Y^\8oiPmE;R2GCSWiI]7oZkO<FGaE4g_m[R2p3U\^R6
S<=7Lf908g`WSRbfG:[KXVnS]QcjB>\5pJ_<DCKKffPlH2E=OeE7?H5<aN4JTnTJ
O`MFBn2XVXf99j6CjbQ84B[pd^LbRaQcmPoSbX8@EDFKIWD_=J8Ie>qK@HX@WUZO
3jd`@GaWTia=MY]YESW[O[>iWXY^FBmpY5Y92T:ZZ_PMe6GlhNBMbJISR6fIm?S<
EOmFcI1q?e=^i_^9O?KIE`^S<aF`3HPG[>]Ml5<GblqYd2LjCmBAB6D303iYgKd7
BaNq9?AWCSWQlmH7O_g1K:\iKU8m63a>;X9cCQ>ea^qQ07ZmB3hLYIDZJ@=9eL8n
nGJplBG9Va?7hW62g72jn;a_NGckVG3<DKp=CZKcP2AlB5B:d\VNEU:iXEll5Eo@
ao4>8oJo2q12XbmW`_34BTh4dZgaiI37@XbR6F>N<G:Ym@LP[f67eqj0cDB2lN0E
:L<a91jE0cd[iCgWH@01b_jLmKhm3:00p[]oF0:6BHEZie>YOlOQO^[LTdlF=77h
LEQmeFFWpC>PAK]ZD>PNl[00dB^bSTA]PB761SIMQ_34]958;qDJ_o3oMOOL@o=b
Q^PHgCY<BMK]W3=OD_\enq]:=7SQH?T;EJE]6`obj;Y?2gBH1;CPJbZ85lpeAIDF
3Pb<TIJ0]o;k0COd_PpD0WG]DQco_AXL4P::j3?HFLND@^@<jjAh:iGecK3pe=E8
9lb:JbkkZV614;=H\V?ENjn;RFn<3d;Wp^EbO1@aYPV<18h8KC:G0lT0E7A^Vd4e
Ke?UkMKN[Kdq<MT<Sjo_Y\8YQREAn5<0dfCMO^GYE;]pdKXMLAXF?GK6i>Q<<J63
?U`F0UR7\dA4O\f9;@0qULH=XAUfCIPEK1@io>a^COHZI_5NqGoaeV\A0V;OMaEU
04=GEY54Rkjo9H[q68@3K:YQLJH<HECQ54SIE:4\8]T`qWJDdGJ`GffN]a?mm?_M
Mm?Mh\Cl[XZH=^^cgZgB4Ieq4m\DK=Q;:Bak6nCQm76q^;h@L]k81WKo;6S15KV]
ac>UqE_<gJ;4@<K>8J_OJ^<;iZe<\p;Ac4cW5LkQI28FdXGdI;EO`SCDpD5LE9RO
a:Q_7=f?[;2KKIEBF@nopHO;g;e\C2`b;`G<B;T0GMfCaj:OLM:oqeAJMC>`aTjh
fGofGG5OicBXG_O21RA:mSkP7KIF6D8iDnO6YS]6@5bNKK7YeB<pKIC63CJ=R1BW
[4BS@j`=02PQR1EpTXSQj<b3a8_bGi^8;4WAUFS@_jEoH1kcZKlZP84q1hVg[LaT
5Lid8>emINiF\b=JfTlF1Ndk8S_mN6>pBJFbCZoO9IWAb8gY<O[YYE6YVEHnl7QU
<C263\99nn79q7`\UaWL5F@Jb;9H17jK<F<N<bK_Xlehg\JK6gTik:::pVP2?gem
`ESV4B7U925834\0p8G?J@a327XPNaB=]Y2W\6<GTa>C<qcW[F;7V]foD?BVmWSh
>Fbo2fpTEKcHib^Qfo3W`bD\4h_aicB0QZg8i<T9V;m5GfGXgC4OCJ:Y40Tj@E[8
k0=B8ehJoG>Y4FWp_VeWO>L571S>CP_CMmQJ4R8KqhlP8TU5CgF9L;:8@C<k[_di
i;1pK>XRfd95_c=QIK=QF8IG\:iq4BX2BG@?Xa8HAdgY5mZ8KCqEaNV9J?0S_fIN
1fhCW<aNKp=\JCZSo@YW`1YmlaX^W8p28[ZKg`913VeNOYMOmn]B67<b_lZ4Aqc]
gd\33RLng;M`=:[Wi7@2CpcMPoNMDg_hDQ>]FdhTf;a6PqKm49f^37nc75>Y8U6N
6[AQJYk\7f7cASkPn;>1Y;[[J[MJFiY[NpFI22okWi9V5=UeFU>[LT1jVa7_7C;T
;ZP8BnlDg4D837o=;IP2Ub95p=K:;D@n@Jm0@A[mEa3EZ_7cgCjbL@Q9ei5aX6:O
Z71PX>W36@0@^qb2Ig0543:Nhg`gdjn?UgJ6ChJ7]_ToI6=NIDnEbCP>Nm>9gJ`2
hQC@pf=753BT4<JH2gn]526M88UE;FC=MRDP^ZYE>YW8ThM=D46^;:?B11R0qD5]
6RR@b@_NNJGJHjP=L:_[Jh57e3SGIeLe9X1Y4TabkP0PAmWAWOiT;XMq13KD6XZV
3]7WF9SDd0JpLLdQGR;ToY6RUHfS]_eC^oL]F^b`5n@kj^\UAbGT`@Z1ENCii<bY
bF_:@UpCnO\kXG7\HT8TbKD`JcanoFIj=DVKX`N0OD:1nkRJ`FCeU4baXp9e6J2a
gcaME1c7MZVfWhE5W`6DHjeGR:71JSUDW\hXgo>?LH[acXqL`QD1Z5SH?W1Wb4EP
9ZA]A43nKC_NhIM_dRlG6n6O][efXlM0UL1p^iLe4I=holAfPe\jDH2QfHc:M0jm
4fDqJ[MoFR18@51DII_j;VM^Xn^JSiXEQ=Kq[EN>=bfCVKmUOD]Ib6d2L4nGemp4
5c]O<57\jnOQNN<;47a1IWh09olRc[<p4[TL8:I41?L]C5;=948Mlk7q8]fPRKld
]oYC8>MaV??PF[K]e;lqdEn_nKZ@5H7GRWV6jV:Z\FJENK_qgO:C7c]IkU\OKBZ[
62TkLiPj`Wqk4JA^fI>Y9:Xk\KHKARkBK>FEcBFl^qXAK7\k39C]MW3N9?S4IJ_@
RTT>D:I]qR;4>6`[nH>o39?48jBWnpTK_DIe72gM2Unod8CDUFUn[;K8hb^WnWeB
f@k;9IPYDb876pDa=kdSSlU;3VHMFCB3DolGJ\qT3ZV1:QJeHY5760cb2[lN=N\q
nOT@??06dgHa45CnSQ[gRmHpSYfhb7NocC5cF\n]R>dg5>QSX>YqZ6DQ<K1SZ79I
2RKb1GQB_U5mOACpMQoY@OA:NZFeT<VNiT_Y1QZ;ZSb]qC2GBJT66PH9R\Ho@_^d
^8e@Sgh1B^^@0qN=O9N?jiCHkN0W5aYfTA\=9[`[3B?di4<<M=`fS<<iBRSiXGOZ
T_LY:nm?qIMRai8;^lO657hN@8IRWET\\=<_7OSVTqIaIE@9]j1G_gnDDN`4gg`B
;gQMKVO86p[L41C9>TBRDK0icQFT2UCM=hN39J85RYD7_p9>>UnhO;>Vh]OJIDC`
>N1W;gg;Y1glWU]@Zq_I\elgb_D[:GMgc;McdQ]V53T?pTG4PlIhX9n8S=ggeL07
U1_[ln<qHkDo3D>;Y]aab@b6=ge>N`gY4E6jAeqeQ2gLLM\4?1\L>BLQW6Qo@:_i
PGoiiqLj?@42CLi`bCDEgjH@3SW>Q\6?>6pl@0Ff8^R6\B@kQ>Oi73SmNYa0AIcN
l9Vqe0R@^o9S0Iig[9g]p0OHfm5]m7ag3Ge1R?Xoj;eLC9I]PaF\^p`08IOK;APh
2N@PRmWj>m[?mZ;=Ujil96Oo<@LdN4pg=Q7EU3H7gGIoQ=\3HKfa5<OVcB=koZj=
EpM59De:MK<1eh<859k3W6Q^h6iN;D]]>PXSN566T?KeOEKXZnpE;hW@79fZaAcH
:<:3B^hcZV0MOPSfQC>E;eabB59[=PYqQhPF]SEdV^WE`mBim0T6En^h0AO]01XP
S^AP\=57BVp@dH>aP]L1cO7UCjq@hnTOmhqAAOVK0K7kIk3NeSIe:@1?:MXc^IkO
e;T\2Rc7kh>plXj?cW<g9^^1JOaDN:ZAa0gch]Wgl3EeMX@h]NH?qM[=de^BqZP`
0M^TpFfD<:6<qTHh=^jGBOceAUgb:8h<Qb1leccWi3;;_eAO`K1<=qI0J^M>OTX8
=XdICYoUZV2J>7C9__Q=DkhYdOn@bU6QGG1A22`ObCB5@bqj=mFd`h_EON7b7GfR
<?DlTWaMTL1_I<X<\5SmH_nDQG>mA@8qd\go`ONqO2R<R6[p`bZbA3;N@JkE0kk^
<JQ><H<^Bi6:<Cn@\@neCJO_0e7Ikbm0WdnnaCWW27dZ77HWlEOA_EVBHcim3jV1
7;0[<j[i3QL?UCm;`Ro<F72n:ZQ]2P_VpcJJ3Gn1CQdjA^jNag5m]G4aJI[6_lE@
eiQ]jW7P`i9JjYl`_jH3cX_J>jfK>^ana6M6kQOPOdSPU:Wm\G@E:_[O@G;e>dE9
h2^JW[jiWnopTPHO2:<mW]lKYfne^X5APSpkcSMXhJBRoeiH_IL9H`kaRR;SnRNB
9<Rn[S^YR9M7VbDk;Z@9>hT?AJ87gp>TU;o]\PU=]6FP<6ohqB]E4JA5DJ\@9;O6
b;4P@DnlfW<<UV^B3\H2LhRHVqMHZRK=2j9;2^LNpcMHRiNlk<Vm9bUH3D1`]\E`
mkoN\9=>\Q?a==U>_^4^m>DRqY:WTb?R<GKQ?:][;b7`:a8;>Wo3hTEcY4?pTiKZ
T>0pBY9:gMA62Rm<5eIPWXN\GOgOMU\<V0a_4d=MKH1i8O\p\hk2YPNo?NoK6h1E
b`I`:`Fb6E`8b^__3kD=1>_k7eEphS2?`b>p\<FS;=IP0fR2BUa3Hk8;Nnhi1iQY
fcM=lo<3k@C>CFjhjCPnP:0ST?_TUIj7aQSf3:Xekn=p<9fT@HaqCc`gXD1qn;I7
WJQKRV;FVWg^9]aNC85K>MQlmIh_1[5>[O7e1fDq8XCCB@0H4LZPaDMkOXo_WbXl
[MkCBFXFd2k0M]7cHRg\3n5MZ0@6K:p^?0a@iSpMVUZ_YM[3PU]TJA<jR26`V`9;
Oi72\3ZH_;4W1=p7UBLNcfqeL:d;jT0gF[7<\C[mc3ZK?k2IXjFYVHPdICkP7U7c
Q]02XMln;DRN@?d@D92JMJ>TQ2IeQK3@]7YBo7D@lA^K0YdVNCf8VW>L3d7[7X`i
Y?6ef6bkhVpZoHhFc]W`S30jbQm?aekHNXVgk[X_[>O9[U:eAl<FfEPd<F7D><I5
D8J8kYPge8?YSeWij<0nI[g<bafh@gOX<AJ;PA?g]Ef_a@M4Znm6881pI7DYfBk;
bV\A<0Mk:gRN9cqN5ghTZAcNJGnHkJkMIU_WNZRSIg\5L?^@QH?NH>kc0Qo:DD^3
oEREQ;Ynd\LpoiNl4=VXZUTEBPHd9n<J6i73l0>Fo;13g1`d9_MNGKaPS5C5Lo:Y
pXCl\]iD`A5[Q?]4ZhMq0?2<8e0:1S8a417NdCSnEX\W[cqiWfDUgR8o:Cde`[?>
K`NCdW?C@2Bd`hB44hO^L4H2VR?pD\7Sg50L`HF@T_l4BeTIZP[>ebYJdLaVnd_P
cjbp?_e`VFjpV2JH]P=\N_bMIfJgb1T?TlU8O6QmRP34S0D86<p3ba\GfM=61Eo1
SE<WV\2:lO?MFdnS<TOD2aPB3pl5]lW6<q]ce5\lGeJ8:U0eB:3AQKk;VkC`Peq;
hGCji6p;D55J\Kq7mYc3V6JH1;:kkCVh55Hf?3[kkLniTYXEf0mBGpA:8V\_`M3G
1I3OAnD3Qn]7c\eS3CX?kQb6Xdm:l<nc2qPDB?NJgpD623`g@qcg\8mF<UFMeabY
5<CX>5YHAJ2em^b><KgPOaGc@Y7ZSH7hRBD\k1QSE`BLG?h^Db=RA_RNJT:KLHJo
<M_5I[YF?170ES8P>_I7YJS6[4\a4g64qA`Y[B[eTP?SPoh5N=J8h_7Z4mgHS5RD
7P2:WaAIbffcj]a0<if33f9iL4G8?AZGSomlUa\hQgLTal<8gfi1Ad:hag5kgCfM
DBPUb;AEpOJfIi<db\Ta]KHAfk9gL\mp9Hj1glmVaP6eOG7;dV;G=`1L2`XBP?7J
G??qJiQQAcGZ`_<>:IJKc=Gd:G96iH\e[>b[1Q:9[d:>?fcTRl_eO[Am^LOqVS:h
0V?meAlONG476RpVI@O9g94F1lHgUghcT[D0TH^d2q]\hX`<1B<<A_:\<`]0QV93
5d\\^kmTj]JY3q;>7H[QRI`<7A_]h=?O47RAB:WX8LM@BEF:5hYiSQ[dlI^8ApUT
gGlGTRl1EOoY?\ji1M6eWQIfB^OLA2<IpJ@E9JnhqL>5D6j4;Hj<Y;Q7;JZE:ac^
bDQCYL><U@R;]<j2KpJSUJafS=^emDbgP5LSFm5jU65]F2A2k<FT=Qln7cqf]lCb
c:p2b37R?75OAJB?dIJ_B9e:JokAH3[Og[gkRSaKkOUB4@KV?`1\=npmfA9d_;qo
cT7mL[pQAo`U83;iHNXNVXYV5BG=1G8RQ>ji\V^m1_B`6;JpF3=K13D8?WkoFOeB
i7\EE\ZONWONbe3BbGWTSUND8c\8HN=ZpOUB=<1VpNIF^5aRq25Tcc\C9EnfZRhQ
0GR]>6P0H8nN8LhgNV29@C<4XY04AF2J_idPaJ^^HeYm?B=06ibF`k<T[AZJd4Wk
dZ[Y666<>b^8fohG2LFY=@U8=_Y1n3PQeq04[3CKFl7<0;<E]GM7Ek9BIod[m0B`
pUg9\0VWW_l6CCGRO5SGTe4g<L96:\KSNL<DU@;EUECF4U8AYIORn:6eNa]<IJEj
G1\[AQgdA43MGDQiXFhjC]?h\ZF\EYnX]la=AMAQjS=q_e[ajZReV]3AZD;<Kdgf
bmp\NZ8_T[Nc7LCQU<Lj6fQaZaXN0AMm1<`D`ISUo?FI\lHZ3X>@@[3J`P4A1q0A
6YNPW\QOO7iJ4Fm7pbO[6RbDSACRVONIN[nGDIEE?^NRNj@YRhX1F=HDA_Ek]oK`
O;a0c0=qhB_9bVS4LG5HA=_eLiQZ5Mj4YGA1`[P`Q2L5B<Sin:01Q=_dd2pa8aV?
kISGIX=L5BcG_?nA]Ln`\TGQTSX9;3b5];N2<R]9D`EQGhe420H_AGU8SkA14fq;
Y7b2fAncajR[jUIo?T@l`F[TQEAaF8Yc3;]D\C`HSqKl7<ZGdqGaFej\K3>c_=hm
jTA<=?ED@kchUb9=?iV;3l9:eCgY=kH1q:RC=Sbd;@25O\JV7edA\nPKShF\LSXN
@j4R78iCVGdXO]mqU<cmb\<Q[mgWFFe51U`n\]HF<n`4_M6:@><NKU3E5c99o_8k
P\mCMDc2ebXV_iiq>^6<<MWqS:<RDbWpcCAM3h_p>^C9_03\bN;JfR2g1O[53aPT
:eA:d;P8m_Q=[@GO`ZH>[VSI6T]oJ5PH_1Cq[>]`KGNW=Y:H9NK>;eG3GRPN@]OU
?YTlS37b?UX86OREk`p<Xd>nYIpjCKlI_=pFON7DE?6bo1XOSFh@YH70?ni6VhIS
M53eJgmhG2^@dm3>g31j8i38>0DVX_b_ThA2jQncRGp3HE7c<[@8VC2SQ?^OY5n@
A^WSYnSRbD?1mjQLOB:DEWQMFUJVOKSK9mg@8XbfiFR3ZEMTekfi8MT>FDb8c@i8
jml]6lIaBjEMTjdc31ghEaI?Z:?<89Z>2@i@_?q1Xf2@:HP_g;@NLAdA61JcSpOm
F=?R8EO\MPV@B29Bq8RS2i:9N^>?H]FI>A8YM_<Q0;h]of\`mR=Oa@2@8H95LnRq
@P>iYR?^a6>BRonOPkX7o<Jd4ZRX?W]X<0H35Ef<im`W@IY@T>fRpZ=EFXCZ=?Ge
G;dLMK9F9KYFYHNIj61=I8CqQV=WE4Upg[e99X@CXHAo>8`YP4^nFo6I]0DJ0WA_
4jXI>O\N<Lo7ecUPq3jikiH@l>m5SR4hb^D3=5fbHF[bP1i<`XM;k44;RdUOI\AA
bqEoCVnVTL9O6a5YeIl>N8<W8:T<q9EfmD\jq3AGPiS:pCTM[G6bq]cB`]iSbdI<
1M:?l9oUbD`^D>3oeV3?R<Y]Ya24emaMR4:Rc4<RPZ`=[jQ=<8ZNBp4kT0\<Lh=3
Z5dN]@miN8<m9^cS7eKdjAeU^Pd[j>Wb9=Ja24SGXRU<]Yq:RDNfmnJRj\\dFZgN
llJ[LT19DGMRV[V>BDnhVU=jDRHXHe`plF=cocXqZCSNB\kqCXQS[9<4ckC7OBi@
beZGPXT2>2FDklI;`6FPJH3:`=LZKT]TV?YEhbgTGBKXbOD9J6QNhj9Wnc]1hg6C
dmBH[NE^<f7W7n`[c@7:JH3:`=LZKT]TV?YEhbgTGBKX0hLOpQW[ZliQT61=F`h^
fDB`YUnp\3Va\?@>@V8I7g;CY2pn<`VOh\`H@SAI7YJS6[4\cc<OF=FSQPpcD5`7
K\D]1Bk5;ET_F^lQ4P2Ba_ldATfi@;L<Wbh?k8:Hg2qaSgVo92BR9Nd1BL^7e7LO
bDiG0J4dn@O2PGKkbcpE6LKSUKI3P\;?P:`]SAnk2hd_TFhg_SoO?Z:29Y\hW_I[
U\7bEQYY4I;>3Z9p?dTca3Bq^\ghcPoVk^=I_OQQSXGejWL\SR`9YkhDI]1g>X0m
AeEpLHmF5PMKY::6@=WJ_^?maPPT6Xl3XY4b]D88`fmoV[Up8YUlD0WqBoI8bEWp
[FAEF4Tpb=>R^T;;<b8jF6LHA?P>LL_>>L8D=b@447R\;jkTMc02NTjcq<D8H2KZ
?:UmfY?HC?H2idWGN3S?Z>Peljjc83Pf]aD]<7C5dI35>>jqn_X78_Hl;Ve9EWI1
lVcLkjPA`l<G2on;Gk861g\;oYHpjW8^Al4pg1hM=NGpM:KWd_>Ncjc[6^C@9]K2
<HU>:R54b12``T:485cFHMmX1LleGNn=a_Y1YSE3`fAKM6SlmKo78GloVb>\U;K8
e73X1RTR]lg;\P:ZU`\4HMT<5f\XMYD]C[qhNKdbBAf:M?iOcSaVWGX5hq`_6Qi7
F8?BROUZbZChpTMGoh`jQfhiEHB6P7=4@1a\06fnin9lqne]C:3>4dgl5<VM>Sj>
\8[RA7e1Ucj7IE7VVmgCmBhFY:aRJ6le[nMIcJepd30c587:o8Y72H3h\PQC9QI7
I5>]?nPllj9Y]=L<?;fjKb4?@lqWhO6gSJTg=a^]No1APPe_9dF]6Tecl8F\Sq[>
?eBd^pJaEE]P?a[>E<SQiOTmaC7N60ZKbmE1m03>XVXOQe?TflQgqFB_6o7I0I]b
<8kCG@hh=7?CA2Q6G^60e`50?a39NjLA97DqG;4`ZBfpkiPj6mHIc3N>SBgP?4S=
VnI=A_KM[_]cWFLk`hWK2[>@?CnI0YO8ca<G1_1QUkO^9m?jhBRq=kXWJeHp`<mZ
nXgp\V?187CLGWNHJeUC8_9`9XgEY_cHFWR;f6YNUcP\@?Rm?d5bFfKR?bYK^=hp
kTH;6]:lIkEYTmg=jnZ\oHa@5AMGWg7>Ta:<eR^VYTGj`mpCD\aOajp24iT^7;qG
QTgSCc9g7KAEFe5@UGM6\ZlTEn_V:c5ojO:Sm>j@=m?i5_^2<LIi_kA;:Ck5Ii<G
STg8AL\J<eVIXhRb``o`nLOH;3GY7g<FRBF_V_:P<BJAc:h[GR]FF;6QhXpm9Z84
KSV<UcD<hgG3W6?0hqmjY5NPT7WjJ<F3OOJcqUjQBh^VIO<\c79O5ZBp8T;D93RR
doPe63M4boWaBo?94f;cYc:WB15ldd0ScTKN9JF`SZF]Gl^dZb>f9h>7Od58dDdC
3WqXUOeib@h53514Jd\d`]7W;ADg82\m:ALl`;SIgX2iSLmn6aOl^_28LHEm2j=h
gc`@mNHT>?FBhpBeU^\Ef?RZfJ:B5J9fkiBm4X3Y0?EPgHQ?TYbOAB?SfVS]knik
ege62hC9Z=Wc:^[KjR]U>>^6qJe?oo51=n08h<IT]1PXNX5cDoW]YnJM5aRC1Ho:
:<\@i8jip?`14UlCLBMG\ZMR>^2k_f5hWn6@mS^KURFc0:9YR72@B\[kQ]J_GB@:
^;Ckl8]6oZZ6\Lc@[FBpIa`a027HL3V<ZGH@F12dDLnnMS9HMdfn<_9nJ\ULo\c\
QLGdP7=JZT^@3bCBKYUYAOLa_cX2ndpa6S=Vj2Z^h4ID8\aS4_m[^4loVUHAgm^E
;MOP@TW]Q9cg^GTCmU276S?m>niOoUH]IkZo2^3SbpkdKbgHAdL9DYC5gP?YfR<T
T=R3Pc3K8QeJjG3a:W\^mRXlTJl6k[c]TgPAk?I2ZjnEB@:C\H[8pO6jW:3lXTYB
5SPY@_gb>=YBIOdR04F5I]EHN`YoaFd^@OEPSm2P@^EB@BcgMIQNPKDaUYU]Bn8p
4@4GEeHQYL:Agi2[Zf54h?T6?59j5><5Y6R0GQ3bl_m_Q4jC3:Ii=l:jd\h4JN4U
gAl7=]=CI6p1;E=@X[OD_V>]QZ;L;cEdF0S7;hYpDNT]@kR8WE9@TnXP3;Oi58]4
[Z\SWX9DIm2T\n5IQN=>Kda0Gg>QfBldcM6;M\Ed[JH67Mm1[VqAcCC[C`GRo<\2
HIE1jihO_JOBfcFAfm1nkVKSQcTaH<1TbMhcGamUWSJe9jZ:9MeV?H\0@<gF7?Dp
_N8:NF0IN2^=V`]?WL[PPU\NeD;MiT6;\3LVR\Di\`A_Oj0ab@69T57bE_LUEAf>
k0K_eJMD2kdepnCjL;;Uj^:3h?Pmod8495;[ZYRAIDQ[X3gfAG6Gi3akoo?f<cX[
P4941O3h[?7Dj]`QhS0hOYe=op^3267^a<42eZReUP;3G:C=0L8NaC;o_aC6T[8;
o@@VNjQa8d9EIkm5BN08:E]\3S\o@7<g@dH^ORpjGSH>cd0R]_J=gl1MQSYoP\6]
Fk@P<>IL[Y1A0gIQN8QlMCT8j:_]X^14gjlbG=;Hk@CY;C@GCdUpXTS16eE`i:j^
C^m4E[mF9KCOMd_hmY:aMcSIO3a8\CXFEVPO7=hX1>nP9K@jg0aEBcL80B9?LYER
qi?Q8[WB3f1bGTB7k4mWh:D^97kHkcm6BVQe3cYAM6:n6JfURmI]26Y5Kl;@89B9
hPJ@X2\\RI9hJpO\SH3I>V_ClXE@FbTm`@_EY3]ini?<<UV8GF?<jm<ga>>L1Yi?
KdE]]]:K7ZMZX;b`=Ek0h6ck>0pdAfMOjGGb9<I]KQkQnW@0VBAK;>^>=6?h\>p9
AUC7Rh;aiih^BDI>N6=bC5h74<NMRKNLFG0fNQ?Zj`AUlA=FJ1mP=6>WkZG[a[FG
mXhPJZnTlRGp9_]Ai?bj92WiDP@imJ:YN`maEeBdEec0Fgg_H]`V^0e`l=Fl\mJE
kWN]lbNm[^0H`=[=DUkIogEJp5aLaa>cZVIo5bJVO@jPM5=mCT4FVLn<@XI4nbZI
h[6cG\hOgY@lj885eG4OgONV\l3MR57LFhS<SphO;n^7J^OcEFV:XeoCI[[5O>9J
W]^@0]=Z9XO;?I4XXY7WUiPc7E9^:L@XcCT=bEomnVmc2VcS]\qb[YW@HNJ?0?2k
CbZeDX?7n:3n4Qn4Onl1[86_Jb@F2OeLM51c_lTV;?JUEYdo?R23e10Cj2d2BeXq
<GT4=P2]L9B6iYcHkk^HmJGanjo229dChCYl3]`i:HUCG:4F=^o5jJbO1K>>>ke]
lY^TaWMF_>YZqLGE\=D[TGaXQ9DNa]em^LK1NKaU;L0^Rh:7YgOh=n^I`V_NmdCY
d5>2f]K<a6odiJ]k1D4YWnfaRqQA3bEQTD]l8Z:M71_S_3YAIH2[9_LQW5GaaL\j
I^gGfX6::pP^diDAXH7Yj;;JR5=fgT^G`h:=;bmjege@gA2W=X\Dj`Hc8Dd72]Pg
M`a;L:8lHYDQh7nNIAOgmVpj\kCCaSOGLINZcUU[7:503>m;2@2n^:9YfgoQOTYN
X\CaT1\@KNYJE;Z`=9V]oQUb`[R5f8Mh<k8qo:_Q1W:VJ`k0;AmF1RAfO_9HfO>I
1[PZ1lU]6Gl9DTHi?l?a>FWMc>2<MSRGg0_AZ8;KBQ7dZTHEpd1<h=6KJYCWmUmN
Uf:3?i3N8<]hAD4j<mj5Tdb1]==Je?J^la?6K>m`<CKJSi@jBRb0F6387bfeTqaI
cZhd66HcQQL01436H[7cJamj:KQ\VRSI__S[`W<8n43WU;fbeA92Z6n7T[i?ilc0
lof6ZBXYCWpBnXWiafe3a7S<BZ9Gno`5Y5][9n:Z6i]c3JAGo2_l[PSRjGEEeK1b
M<MoVgfU`4>:mT]33U:=fRUpZ?IW?iYBCH8X4lO6:1Lb2B?U7gF?CBgK8G:_`:Y`
]IWUT=oalj[\<@MC9B<e\DV]PZ3<E8E329J:p7IgZR>mmdHYMaU;eT:5b<_oAf;V
cDP]lb<PaiIQhRNahcKEI]eSlJX5?93YhO^Eg2LnQT=N3L;i]^^qW1ILKCeiiY0g
=01hG:mNOkUaBekb^N77Z31QYV>N;60>L9]eeLDAGMcD07CIdOV@NVZB8i:OeRVS
BhqH^c5\7foHlIS`X6Z_\oi<;@UIa9<h_bqgeEj[Z2bUdJc9USVl]bncED;J_O[L
;Q@GOnFLdG5?9EJU]cQDa0=?YCQ5LE489HGn3B_U2Z@^@\Xh\qOlMJ@Q^?S;7\MT
nFm6bBOWFS^e5G@`VI`\VBaXSW_N;]c>CGVRbKQYiC0YGR;U<na7>kVh6J3<NeG9
qO^@8OKQhBgF6c7OFc4<ZL]cY`j=2kQ27C0j0gnZQU863NQ_Sk@b3bSWik;_EYkh
KooXGfO67>XQO7]piEg3^QgUnP:QHd@7=MkoEE`0LG\8h9Ho3h[C;SBV7Q_Go77K
g;j@L]gaXI\M]Z;;o7k:emed1@\QLKp1KJ5[3<\V2O_?<MgI1lTdAT>T59FIId4D
n^lg6ac4B9[6LdRlK8LXgF\k[ch3337S^>Lh?G:C1B>Xnq1PJ=>2UW[gDaX6lmcV
I;jgW_1b]]Pgk8]fRF0CaO^ShJB2nF2SE1Ad4>l50WZi]IFkBG^DS3nMaVQjqdZM
Hg@IjF]Yib@4KJJn7l[8XEAScM:POQ8TS?nfKoVEH6RMfbkZFh9NSlHXTU1g5`W9
c@D]d^\W\2KpboSFe@=XFAZZ[le:75b_d9VYb^G6K5eC<K8=clYijiaB9d4lMR9^
l;<P50?GL\R>b8=MjII5baP2NDpTjX_Y`P8nBd?^KY;YKHLgbbj:NW1Kg\XdRg3g
@05Wc]PDN_cXjDl60b5fI6?U0D`nDqi8856>1Y[aB1TL@LOjh9Xb_GFDmB0HM^VL
O;ThQL<Ok\Dn_]i0>O[BQ;XHm6=JLgD?Q?;FFQ3QH>>>a3q<R\@AFZU`U`g=6ZT`
WRefb\4=7F;EOoRH9HeFf>C\WFW[T0A^LB_F@PB[T5S6[A^U[ji]0;<=W@YZb;gp
K]kW8oCYYEV55d5X=4I`=o;nCC1V4NSl3@A1oSooMQjD6d8=G@RXLi[?`HNQ>>X7
CMX`CQVRe_1Hc\c9pa9Jmf`59@_Fk0T;Ac4J[>5PJKFTMm_nlcO4>\2VREYMC;EC
9^CNk`M:2Acl31;lk7o:[jbioF`bKgoIZpUnNak4[V_4_7F6n1jcU6m5C3LGm?N<
BOf49[Sfm;OOkgJ7fk:9QC]<<e2b[D0JAEGjhWFN;HlQmQc8fBqPc`2ef<;;obX\
:<klD5FRo87i5SWZ]F=WgZa?3TFGiAZk6Z7TN3pii@a7Y\3kENcl@XA^eTm9TF;=
bA037nS4kBCoM>m?kYPlDaRU;\c[f<fGDFB6L0kG555]\UGIm8iPL<<qfWo]k3:4
6\Pa:f:@KdmS6ENgMa6Fb<ZP:RcoBURVGonniORGcYZio6F8o0?R`B8o@bI1Xm<F
?Sog2oF1K42VU9pCLKi<nB=VgN3iCWJW:bcG[[4a8<bBda8985B6O0X2H2BCke1j
[jlBn>H`?1O]1I@Mj91aT;^<dQR12g0bbDPGhqL\@2EdY3X9IlB;]R^m_IPVZ@IB
m[nKlcNn??D9JpQ2iM5`@@2ZDg4Z^D^iS4d_AF9Uf4o?YeD:G6<dH0<3aAYFBE8f
ZKdo9?LCc\lLP1i1HbRS0?]Jc_S`:lAgHf<SqIO:J3Q`W\LTg_KIV?eKMeI?l?:6
Cg]d\8EX<MP<VQDj9XEQ<TI4<afo]_7Q\WoDc]KgeLdSk@3O>@c\gg75Ga3pWnn:
51f>d0WQIlNk>dL^m0Mn707Z2dOE8NV@n8iF5eIFD0b=[0HBRK?M0BEVkj1ON:DD
QhZl9>XbF?8EQ?nP1<qiklPTlGI]9L8M>oI9QD2db\\DLBh0^7U5e0JQjIEC4WWF
[a8b0^\\OOXQKbJU<4ZO05l5>CJJ^90cKJjCEK2Dmq>0=II3H32bM7EW7=f]F:bR
VHhk?nRASbWKY703\i2mNGFWP4]eXAkA_Q^24?1=WKO]<A]XD0<SYI:Gmd=AVJ1X
pT\X0VX>@QdigOcB6n<]CN]=4X[If@8WIi2gDVJNl=>DDScc:ikdbZBZmm8IU08l
?;`C6jfAYdH\fAg4@TgD8ZCpJB8FNTmUVe=c2N=_J0;ZlfCQa]bDfcbUSV23U6j\
YF]SY9Q7F09Lcec0TbnQ9:<miE:1]?R8e]kMjkLMaILS@JpRbIMJcUSRD08:QTNe
h6ln^5K4MEd]AMf0bh_]Ee0pb\k:]TKTD8Hm;CoRdnEgkEJ?>j9F9iLedI>6>6QV
`9FN]Mb5lVmh`[79n>\j1kdkYbU>1cob:OXh\H5`@[9fPnp]c\k`\Y8UYkJb?ie1
[_>Ff@J8X^JoVjCX[agmjflU6RVOUf@UQeH9<>jf>K_5N9NRjAT^\Ejl3TnHMT@i
@jUL2pDLK>mMe[[D40bW^8SeWcGGV4AmIgSA`P:Y^[L1j_378\8AWT6F@mM;9aB7
NhlS3RBOU5X@_;]13KnhV2]fHD76pK;>Dd[fFU2D<LT?8KaV]F51G@T`WT213XPL
fG=?MB6=[F3km?F:l?8]nchZ=?g2_Z]6I3R4lfHoHIIR^Sia8;bp6\T`C8AFCPnV
XjXYVIF71OS0j9MTbkI?GV\EfSP4ZOh;8li5RVdFn3[2MS?<k`gid^ISP5H2DVM<
XOYa2nO@`c8BqbHW38hWaegE@jF7\I6T=hgIb:fVhGo<eLG4A<YhiddQ=9bh;=][
BP@4W1gh6E`6V37UY;DY57HQojH3j2Y6E4jB5pPAgB>al2>LX]Pn3amMI?QJN3iR
TY0\<lmPMH`mQ]H<b4eF:gJ4>mHhZfj14TNEWBE76iO45OmhXCP21ZCFaY8O`hqG
RHR]h7<njPn6AqTBcHPmOeIG>9nF0Vo?05Bi?bK\BPQVBZaEdCednRJg2[la[8Lc
L0WVgV=_6<o=WK5WN9OA?TL33InSE<9b\2ah2<qR1Yh[ZBmP`QgX0UhEMR5gLdHg
OC9]T>53P4OK83?JjlWa:C;dE21`^Y\W97kMaj9WN2@C^[ST<o;X_CVO?dh9Whdq
QkJ^:j^JF7:8J@C^b[em0NaL;A8h=XWeaGULoOa02_DO0V6Z`Ad4S_k^58C3D8YJ
NMFE4Y:aX?YXJYg^5eGL0eTAqLGmcm^bRKdkK_W0Xb`i1Ri5\d2V8lTeaB@1\`9l
3D^dSg7M3KKg>Zb1SH^oPHSNB=<HLEfbAfmkgbSe?Pl=Z0VjHKIK><=pQbFa_Vka
P7>VWI^WB\H2>oG\=L4LaYbTi84oc3M1DmiTB_cYl1U2Q_knam2TY^Q0bBEiD<d?
hf>oE0^ek7`RQW3JFWCSPHp1\enmHDfXd0O1C`k]]Cf4984g;cV5j9_]TIjcSPP6
eWf>2[:T_ag:]99RnC2;D4DL4b=eZR:O]0P^U;DNZCUAIQ^Wc>^RmpM1lfi:mGn1
oH]G_i\OR?21<[\jNDRi?>@LYSZV[]`1C2P4RJ\n4AU>dH_L2fK`jcWX\XZUlT7e
A`h@9V3eIdAlpl=;GEb^ZF3XhDlb1HFOZg4b3^L>4knU?>lRaYhgLPmTVQnZmbd[
\KaX4QS@n4cXnA_160YI1Jl4O;Zej9cnKnhp<dC_[0BUKEhU92mh=>:DfOMHNY`k
@_a9HJiC\5?=IABZM0]EpO9EcTkV\7=YZegi=H6P>je_NW]OIZYKWQ:@2fjP@2l[
I6>L1<>3nFhO=QG_LS7j3m:2ZQB:VM;673m`1=6;dm364;0k6SSqc37oO68Qm^3A
[Eka3mKWPPCG1MM2DF4LEB7_8B@JZgHJ_D1Ln2ENnA[XAd9[8_5P930?1]A]>dJF
I_[\mmVf4IQ5[h>DRoq^cV>VN^E@2EagoieA_mEX?SEc;FCQ<Uj8cHd6XPR15inM
O?odEUNZl\5h=goblMC@m]UKPYgdE3d;X<GUeKql9_j[AA\hmoHgn>[QmMCkQR=5
EBgL<L[@fVXUL83?KNBQ3BX79af@J@4BaB0EONAY=QTDXYU=FQ\DDXMaL\pRIZRd
jQbje]U]iHP=MHEOmUj[bbHafQkC]:kn19bSmpFEYLbC6WdHmeb_aeC6MHG3cJ1<
b[a@bbI:jl3;P\a5@X4GmnYEgeJ3kE5S:=Eli^WGgW0Xh@`De5Qi[9^Dl35hDmE>
d3ERm[RI^_`Tg09ek0KN:K7eHpG5E0iLAcjK_d1l3@1P:a_WU>^38ZQQZ8@kn]LE
kF::0`lh;A5Y]]iJ^G;i`I90SjPi\Y\oD^IN>>SEJek5oOP3>3H:]EF^EJ6I]Pb=
\fM2XSW5OH^SCqabgdSTVA;lZ<`d`5:93b60k>]gkJJom3ZKbX:X24Da[TBUPfLW
YZ7V;X8?kl_I18CWGgKInR;a:g[[`j[=Xq50VYD@0mmN29GTJ64\?QLUDfSP54JJ
YMoj3oOiO2A\RAZdo]R]]Y5gCdGL=k`OjK8>Pf>]]dqBhVI4CpY[m?fo`gcgMOi4
l747Ll=3Un4l4i>Apo`\mJIq6ZLB8\VmP4<oUC?fFH0f[7IDOM6NUeGdV`\q<T3V
C5qC4MJJI]me0:b<E>8cbXL4JdN6maP58Zo?NhW>c6TOMc@5lDj50ZM7UamKC;F\
8P=Z@_=MR<>f2h_<M[lVa^e>U4Fq63mejRqmCJVhFdB7c_=8SM`6JR;`LpM[YVnn
1nkFbT\SE_XKSGo\83j^Mj[f]IL6[QH_fi_VBGRR>EEWV=L`3DM_nNS\2^;kOV5C
GSGmAO<B2O49^Af_Unk@cpFRd2?0q34HA4\51?]Gd69D8F6U;GFo]H:]aNRL8<K4
l@<Z^FShKM`O_=kJ2QB78mf5noH_\U\gqnlMY37q\K<9UV;ngK_:<g0e97AZDh^?
GO1VMa\=lBH6IFD`WIKb?iEW94:b;lYVV8bmH4p\\\>CQqQ1E[g@FYYFgL21=`m2
a_FZ\gkL>C?K@Y[7aTfRJfYO2RM?Xa=GMNY]O^S4VZN98P]iGeR4mDA0Qq1S1Kc5
^mT8`>S^jY];M:QDC85X0h`oSd\h[8aV[5k^5OaHghk^fQn^GLqJ[;^g6p=^LQTb
STCicOPKL6ocZcH?cCe3EXlGaGNBoZb3C^7J^f6[O6nFa5E2De:jK]e4aBN1Tn^<
aF>1Y\PcXS\L[qhFc]LTq]B?^7H=PId_laVV^O:GkhDSY8J^6k@8WDcGCb?i`7:M
W67KUC[;@S?o[WCSXqJTQ?=<d\\;2XVAafRgWLP?4b`P?XhbnVUFCR_bh0Ll`Y3F
0;1@LiPZ>VLoJ>5Z48A`Q>i1fUn6dfGg63LCLcZWqb2>8_6qNo[dNXOocOfWNXfZ
1dkOjY`YcT9L<2a`eWhaVnF2No;A0^]4AOeb2A5mJid9BXbhV?>^N>8Sg1hmaWHZ
20bqa9FEKbpCWL;i[>>=d<7;:IcAa3H<>\1@B5m9>G^9kF0I@Jkmjg=g<YbE?@cd
H1\dZ=Kio:FPC9G^oRJpJiA07Xpa44dP8d`>5CMnn[I1j0dQ9h^P5^>?198QmNN[
J4mQ`:2\5RM[h9@fWeFESoeHmbH8]O?mV77pekgl9`q7AT5=I<YQ>j;WV>;B\[>\
l_NS5MC<Dh`WPJ=]To=c;>R?5I9F^EJ6I]Pb=\f2h8K=G5pdZPQ_<W:NDj>OAfF<
0FEnRhZK=QjSH]Bi^H5TN0_LLAk7SI6e\RZpKYKKDhp8`2idChQ]`FhVLUJTcm8k
QdHdGH9VOoFo5nmHiPd<ZORRB@dCa=CQ180e;N3R8ndqK=OA9]q5bESb5oJnTShf
bejL_K5Yh6=InAm7l^B9LKCebOJ7YWEaSXSJR`Nc7XE<BReK>9KY>]`T4nGGD1pb
LA?7hq0T>kC6WPhoka3]Bfn92gAAU9d2i==VUhAAFPgWJ[n8fNZWQRKQ3nQCQLn?
Ka1BAY1SGJh2bEpBCIYgIpDAc:EOh^=KbHOFNihA;L?M:@nOg_fnP2dGoNM6`MES
[jLoL]EW_]aU<UT1:hScdVkinp4XJ\hS@g^EJOX;Rf6CNG:Yk>8dNh5JiUKg3hUQ
aHO<7cMR]FlfWYWiQlS8NIqihImXjp1G^Mg9[SRFIUTgojjc?Y24OQY4ko6ko^\A
SN7RRGRPC0]:hoL;R:RdW4B@0f;b2=_^YWQ=pKc59Z^p=d9mNM0h4?DABM4a\4MV
eA@T`c^bd2hB>DP886fGYf:9Xe:di80f@o6a_e>>?29ZJI^<lWSS:KW>60D_qWiR
@4?q0Ha\em7_KhfP@RObeZf:RUbWCH_<[\l3ZT\D:U^`OO8RPbV:j91AP:ff63]K
\4Jo;m3`R9pbAW<4WqYhkce5YWhOKXWMa7TZEDO;@8L?:I1eMHPoF8G7C\TXooe0
k`lba=7IGE=ZlknaeHFkcq7NDSl5qB4[W=N897Q]a1oU:1W0ZG?XQn2:\2hdEJA\
Xjip`]SV[7P_>f]]<2NhYOXOHe[g=I`2bCU:I8@JZ==oZ`jcJQKI\RaloU7mpGgD
H2>ph17bUGaeZg>aKGJ3N;N`U[Nf3ZcIBPaR6e7oA0F2aER`9g6]o:iLITGCLD0c
GRodKZgp>[7SRKpL2YLG8g71YMVjAShjWOh]TJOf=\5DYC^M6`X3>kq7[d^lTWdG
l=laFAO`U1d7EBRbcGLD5HH:kU7ToG:W2@15bf3LlQh4aWi5<_WbQgHXK2ZhJ\BB
5fYncc<:71@CPfM\Nomf1O^qkTS[N2qMoM84PFGDYlPTiTUB;:nXm]L14m\4HI0T
JaL:RlT>UL9GP;hAVhaOL=dYQQO77H\[A?oS<LjIhTRW:GMU]PcNhCU6:R]9S8<d
YXq\:;>nDp[74^WMJ>52@TTcTQcA1N\C[cR9hlHfE^LTM0Zk0FaKUU803_P=h\ZK
S9moiBAjj:K3L0kUMTmk6qJ3gb:oKSMgdFUOZe8mFZ>mOnGk4O:_KkV[[O<j3bF3
YqE8PaD1pCg\67=jVJjl8nSYROZ?W;c3T=b_^[2MbFVDYAj]E`dHBK`T8^TnA\k4
T8D^k2[aPm5\Ud5q?SKn89qaKY13]H4j4fNl`c;3cY6[=cUQV[^9fh^>AlW2^UXC
JgdB]>YFaa?c2CgBJb]kR3B^KG?bE0@6keU9<DbkYiq8K3<l5pFD_5gh9fQTj^9=
Y_[hRBT3Y<>G_:HSiMYQUj11cD=GISJkD_\kGH7MGKKZAa_gkfLROJ8iTCP7Z7`@
7:6=jGFf[G_GHq[bNAc1peB1m5COahioTgch_YP2K[P3;CdPlK`GFE4BC31l[9W;
e[\UgJbjcWkLq4<Y?28Ce=9Eg]6WLRbR1Ud>L^i?::XHRX^G\]Jf4`V01B`@D2DS
WLF8[f0af3_SIC_]9[]IDB^EG1BZi7:ASLQ3[I5^\b6pB@@_IAqM1PnK>M9_:;J2
9]>idR50i9Z_M8V@2nESO_h=e??9PYQOBBKKf?83kIG3S=Nn2eiN[\CF:MBRUlim
gUJNf^cY[NPV[CqTZ0_91q31J`I`<FY9kVe>lA_JWf`ULJcZg?8M1M:KR0ml1nXI
HK5jV0]O;^S_W=;0\Gb0VMF;:R3ZFbD3c7_]j_pYaFg64pGM4lco@hJaJBhWAh33
BClKdnMcBL>ZSVeied`R]NO7T2D`fkf;91e`8@WNHUk5ES3[`TIhNe\5<pgie[mf
1h84iQb2f>mLPja>EKBM:jQ8Oqn0J?F<q?IH=Rc>ZVL[Dck1Vn=PePYbdZi6gU8k
BbCM^DB<S?YR>`_mI[H27;NaW=icQM:K>YIg]L0WiqXG@`F7phR4k1C@^TN_1O>e
:Z]3KePUkffC7KH3gI1JJgXELKPjiVTl4:8HgfZPhTPSfm`3a^?G290?aNNQBPLB
KB<kqGFDU9ap=V2elN0@B9`3g]<l`7N=;0]@8b8ZKLTAPlc<I=MPUlTkPo?JY7<K
A=8dQ>ePM=>a=Q:h\iA@`AjeIgq]mn4BhpdmL1W3iN<84MklZW2?opO];U0DEoa_
QU62S>]cZGX70R?14eLFM0[MSHY7jF:61NNoD8=7o[GO8O4>P8>337:^>j^2miWf
Xp8C;H:Eq0jPj_>jDXP@949@idJXCWWl:]SSCo]1K9VMML9nZG>?^B22V0;?2jX[
Uhd?H?G0Bq[e?5i=pJ8_65d:N331bo7`G;>F^?5?BoL_7:?g:97I5CNZSTHhm<lE
`RH7MHo?adSMDFK0OYO;C^Xlm0cYq^>919:=Y4BZWNLhqEl41gTp6kNUbd`62YhT
C?NZ=C11\Q9QZ_>gB396eQd4nc6NDJfNbFAd\SiL:09j1_21fmq61Pa\4p<F5]JO
j9c]c2QPcBALQSLbB[Vjo<8SV^^Ifd\mRN;[2[<2RglUepmXW6NBigTWVLK1Q4AW
SGkoH4S5F9LR_92O]:]=5gIb=B:L3hb_UJlGj::_3C8cFl5179QJq3oaZhCq^6nW
[A3V7K]A<CC`?ZV5VKFM>>n[n:ONUUoHRGUg[4C:J^j5j\PT7o7_i?J:1X^WQl47
4>o>pb<Wancq3n>9_ZO?=\]B7PF\G9g5MCdWFVPHhUX58nF4G:@ZDK5ZkW5eO9Pd
5_kXi\i?[^27Y^HSgBkAq5STQP5qQJ53MW2KK_ST]ehjo1k]ce_?`9<@N>;8\eaW
ZVR99KVo3f=@2JFlcTXlA7Rm0OKC@BKM\@U^q^XdKZYpYZk\mmQID4CW[aW[PGm3
LnmeN3H<k^:KD@KZNKL9Le:3B6@4Be8\C=0K\8kA;^Xk17Xfj?nq^7Re=9B;h?cB
YGbN0Enj6E9Yg_nf9Yii>DZQ:jaiVD0<VD7OmUKpRTQF?bpl=aLod1:<UCiO_@`i
9hH5T^ImA]ZLJdhA2::ABTLl<M;XXYlhn8oYQqKW:Vm4qR>L9RZUIXT`gS9>hGL=
EPRpaRlkcmLo9>Pa`a_f\YW^SeeTf1dmHn?PR?e75>jhTa__4SP:Y?TZB2hCGkcK
470_pl_MS?6pH5DJB^=@Y<iXooXInLdn53lfKDIRK7>cN@2RDT:f<;ab6mZ0j48d
a2XV>n5q[720\1q1n`e<ac9Qn58o9W>lK<5ccPDP>C@Va7hFl;>S9Ge6J?[6R>@2
Yjl]0odF?1Z@EgiK1l\J1q=JEHXlp<5E8WkJ]c9_eL8Xq;QVd05o6RMInU^e`E5;
1B7XT@_>L[YM1Si6\Wchc>c<]PPaLi1AWHjO9DRk@U^I@F`YmQZIb_2M2olkhIML
5I0XnqGS3O:ap\?=Z]ZYQAB[2P5Qlf=l2ZNXd1OD9<2_nI\6FLEN5f4AZdl;QEPb
kOFOo3gHV^CNnpha6]nlqoW^OJ5DZ1FmNGg?\5kXLdid3T<h486haY07n68@W95]
e=@<=g6BHN6oWg8iDoS]Do[1]EcaF4_I\ik]^T4K`aZFnpI1ZXP^Uboj>O]>9X[U
SK;cg`iDZMENgX\m6loC_V?l7Rb<A28Qi;J05h?:pOWjS4^qn2d@RoOFFi`;eac[
BTBBkH]Yn6^SEe1h[n6Ik]7i`6RWm@0kM>kijUZRBGDqWQeOE6pXi9J]e_K]Z<^@
BoX`<i_g7RRYGk`c_aR>BMc<UakXj@\FD370==<JQqZ9_Km7A6LJ3J`dZ[dfgKd4
q]UPn6^qPgkI1;F]MDX>OH^:g7O:PPU:^1;F2Fe`UE8ZZXF6VWgVeFm@m3lZ=]9>
V7RBmTml2ii]56qBjMSZ0qF^_==hB;N2`SFlCSnG?;ZO@oecFebn<kJ=Gl?b<M:E
U\2;Aa`K0H?S>F54TOOSc[[3VS@EhHCDVH<6pcZFZDHp`\0H<^^5Qo1Hno^4gSSk
Nmnl1oI=cR^5HbRk58ka16ok0N`dU_k1`;7H=<7S?15A>@1TXV70cC1eS94JPTRp
MBL=Bib\4?Zn2iieCO1;@O]AC<FC<=I8SY_iI:pGO1;c8p0E7NAIa[UlO[H[0W;c
Mm`]8jWbc2kom2:M;^;h=Sh0ap3h:9[Jp\;lQOSSGMjDV_Y[10e41bDihMOFf:PO
[Z[k2n`=7AUjmm7;d`cAS<S1Cim8p9[kHZ=P?`9PEUd=:GOXX]76O_D;q^;ogGdp
Le6]hWicnW`]h]KJN41iD6ETfJJR=l49VW1:fKNmm219LUV`D<PmkVQiVS0::Gq>
31dfeqO]bkL80nhd?3V^EA<D[f8kobK\78\PT<m16Y<lllPjd5m`\KceaQMYkM0L
<qnO[YVKpWUnIkjJT]anBji>=iH^C;ZH<d74WqKhgGa7:c[>I6_DGG=IK2`bMDg<
0EbnJ@Gkm_>c`dl3McdTFh;:oC6=aKl2EqUgWCb7p6JIA[5JC_[gN[:27LIC:M@;
KdT^MUEal3aFdd6\W907:;e7fbEQKbRp4DXLngqmo=S6cW_U8@9Q\nEgR^FgYOkH
MW7fW2K3G0?i\NHQPj`>k5RC?Ppe<3D`Wpi3`i_kS]j<<dVSY]ea@=]FTeO:FdQC
LQ`if^3>@fci\4doW5LALidXSDpO_JbXjqU?48g@4S<;AS=nPOX@2h]C6Gih=E\L
4`eiM_>\CgT3lB==2LkBFSXkjWR3qCEAag\_T\<;LEEhOLkJXAb_U<J]CaJT`<2V
l^H?Z`AcThIN4n>Y8G;6Qi]6ibXp<JLKKYqfgT:RQ[>aFd7EanG=e6kJ@=jU^J<m
I\KmRg:6HYMMbXS]30igk]@a:pI@5ao^=Sm75lV\FF539Om5J4EITRa\C;nVjOi>
9HRm^9biikST^H98E^58Nb:1Qk^dbq9]0`L7pDH2Nlf=MZ2<?kX<i:Do;J\hQ:Ib
ioW757BME]<UEPFn;>DGAYfakMBZapn6_dZhpF8GaNd0MF>YeE5_nPk0mX62E\U\
Go[4a2\6:kB2NlJ\eaA`[Tc<;n:5E2c^E`>q:`_=D:IDgYYZ\l>W:fZ7>X;gGi:2
360lOQ[G9AED3fk@C;e<q:Ml7:npZX]MG9>eI<QS1NGY^P8J=0]j=KcE0hR\7ABV
l;Y?VLcgG7A2EH^l`QkQqEeY@nEpHd1:V\LCNY;83OCf[dO>jYI^\H>4Onf`3mZ>
P8GUZKo6ieYQhdV?iG>K44TWmaqFNfo>[]6Ge^QiJ=]A7^jDK?_5hCQ[\0C___Hh
1VS;O25g8>]^ZHJpb7eYIAqjh_5_4[SFTm>8GYX3N8bKaZeZgYNkGW5j2@iaj^gX
`ScG07XnE9m3KOLCgLY8oqm2Q\IkqjG3GK_j63C8G3ND;:`Y=jm5hZIEX^^PCM\8
filnah25PL^qX<QoXjpM>X]o_5QOjncOF07qZZ=10b9m:[iKdhR=GKRA^Rhm3WC6
ZnT8<;oaYlDg`[]2_A[SRfEDHbXTi73qRXLB6Qq`8j_F26DjHl02R2EIdMllJon2
lWE4J?iF99[I8mflH>h5=SnL1^?iMp54^Ad^qo3J[kBW=KALkEfI_FFk\IZWcjk3
4=@5Moa5;K2fW4mXXQO2T1jYYilC6eio\U]CBpo[nbG6pDC[P=CajUdd;=ZcAH4e
58Li0j\O:6j_eV4R:_T6@kKWPl93:KeW3c`XcqXPZ1;VImNnZPM\N<_b3^n@EN@D
:@E8_1ULf:8^kcB;^IB\aZ8jJ^`gZGoD=DWap>ZLGDlpG]>59_LCV7WX:_[46\\h
J9cWXYEfifF^O5kJ`FgZbje=n1<3=eJn3lbEa5d^BbP4_7J\7FDKpa;_:U_p2;5N
I^PT@4PEd[Nl7I\TF0O`eSD4RTM6I;hXKCg0Om88bGW=khG<7FAG=VVUSK;IpLi1
CAIp1ZZd[eWjNTW;lQ`a^_U:^=3kbWNJa_m6CCDOH2ZDB?ahlPQoAcTMR2E<n7lG
5B:A]OXI1JJq=`Fb_7CGb9?NRd6EAIhSC=N@JB3lPjgdT>6AA]Io1?VCbB>J4GYq
3L96FI_[2JRNT1LX\03UT3gJ^mMD=1k\Q8E6??A7Un[`Zh1J5ifB_kd;2hYN3mSE
Q]jl70Idl^bR4d\_jDegFHjWaBHGc:flFjT@RoDhXgQRQh2kSlVeCg>Y7^IjC\IL
q3ajeBdYg[f10VJVH6nQ`d9BWaIf>jG;S4^@oob[@JiJ0Hi:Gj@Ke3aVN]bpknGT
V8qk0GETB1DC?1nIA_AL2UeX[gLLJnik6q@1CX\lqXo>1nZC]CVKJg:_U=L]NOU8
m<MUEfJ>4]52pn5iP<b`1?E[VI8h1\`F5Xj2:>Q<MfLVeX8oCN`:19PEHafJI@XW
6J:?6lBU<6VSq=V[5^6qf`N@T55Z_RQJiI>IfKk^NMhi]gATMTa^F;bqAgZ_U9p<
ohbOAI]=Oj?Zf@2O^_QWXHYGCCo]BK]fNBp[bf3]Cq86W13iYgCf_>1eG54>jcij
l;Nfi2PK?G[nioLQ5FqXKaZP5p3EIY;ZI9CM\UY>df4jVd0oAi3M4H55[AZa5j7W
Vhq9aJACbq<<aL6n@N\DPDIF6W:K<dl:YW=9BDOOA6TX:\<0gl<=hk1[gIedP;Z8
0F0cqHRJmcJ0_[H3n=0D0P8TIlDAE1XPYRk@niA[EmdcdUNAnVaq:JO@mEqj99W^
95ECESi>biCh4jlYaRcdS;FO8bYOT_20;`c`?CK[2qhFR8SQph>ch;9kT1J02_mC
9FjX37eQMRB1RM]2L5mKn6n;_A\K7nDpSX?ACoq>FY?NBHP\EV=]=XGF_=IX3Z\e
@DV1NiUh[7W9cOlNX:\\_g:;O0qC`g8AnpSkMMMOB37OVI4PLECJJ\b35KIifTaX
XXOcF<g:0oLlE3mdV7aR^p8_MA9lT_CQ4n4ZCZYBP^i:ebTKeEZ4eFckUcEhGMGb
n<9SBh=^>V?LD`X`6[R`C<1P2NE1q]101>7pKnl=F3M5n2GWD17c?Q@7?DiJHT_P
F`k[J9b:a0G_mc>^ED\dDMZ\b19;W8Rk;:qA@30A<pfeMc0bEJ2hinjaeaN^o7[7
kVAI9_a`Vfed`0Ae98id1c;C<6C>7eminC8cJEEgS_q;NnYYDa4Y^]=K8QP99VG]
d3:bQf:jiZojgAZcBF<NM2fLOOIp4i^IfJqcI>eFhXOJj]CMM6`MEZcnTO;C[I1X
E=iKjBl8\<:2iNMAgS8MemqdnCeYBqWBfG9^^0cZaCGPL0FFWc4o`i6h8bIF=afP
H5FUbg7lSCVhi8iOeq;OmOZhqeA66>];9kfcekkG7Pj^kJ[YOY_gKBRUfWk`RYWf
h5@=A7>pea@DVe]nG@ZJ;7J1CE87qgVV?E6pB2?3aYU3b8o?k`4T>H5dQSmMBiT?
_\JBGdTd4bHj`^1_]Gf0K\8p7RIkASq`A=[^1e[X1PClPYE7TM30_OhU758KLf@\
Oi_T?6DeicEkF]f5o^;h2qPn^CB2qXd1;@lklGm[\T?6DeicEkF]ff;H9dUo5O5?
__]1b@ENHf61bii8pPB>Va2qiUn:hahmhDcF4<hhN\_2S>ebJDS;6_@B\C;J@nQ[
29`Pf39AK\1_ckL[TSeol@TVqCN3_]o7\39<9lMf^LD_9O6_^I]aUbH:A5RpMiac
P2pi5Moe0gA37nJmcg8WenoQG9ign<OKA]5b?M]ofZmVMPm>am6Dl3Bm^L:h=hS?
^S@UO@qL6i19mqDcCI?`RcCA]B=PIgMi2JEN\dIRN7`RNQO>i:dCfN@ANI@R_<oV
WVF9LHgc`c?2?JY<JbUimSL48qd>Q?]dp=\Qa5K71ikgVZH0iYMda^7Ih`k>QHm6
e]PS9?ZL2_7RA1haF<iJcPLaUcl3m9ki\f8kqG]BOE8qI9?_5GG>QF0LfgW1f3XB
h>aIbF0>_G^Ml6F2SX\UO6WAe8eQRKb=PGZOo5h:>H7m;5kkdRMEqliW1RcqX3P9
iF1:SgZ_M;aF1l?:8kpJUh^^o`?=\MC_`=b[:FT0XmHD6P6e`6h0LeF\g;HjN28d
9>kc94[=6POALj??_^k1UCX^8mlQ^ncMP:PqB60cFlqmNHf]h20<;T1C@Oe=BXl1
Jbe^I=3PYH0Wb26^CTJ8SBB[a6Q\?4\KR:2NHU`o2VfqUJHS;>q\^n9b20c2BTAD
Ib0MV;REQnmGk>bNh0VaAh5ac>cUK6A;Q2?J=1?6_f1:]VTf@UHhh]aWRS=qd?j?
XlJBb\5V@[W9RH2flL?HQakhS`82h`_J@S9aMFTo^LYPlWEY56Y>2`a5Fi?YLRZV
f7OqiBImZ<peA_na9V1e:LX?1`gka2LjY\j[E?cjY3[5]Ba`g[N?5Vk=aUF2mehF
YdOo]3M0Yq6LLBngpnR1<W_OLYCEcdELAYhWaOKd^JZFlPLk4JI;Ya3J:d6m0_A@
]8kAb_O`^p]J\iGXq6;8=SjP];GYBfOEaLPF0^:M=N4UdX_h=1bHc8WT^TCD\AjK
<fB7QIj877lOe1Tp1ZLReBql=OR=EPOJ_dQPLd<ifJTJ<\R;C<>;kC_MCSH=DPoQ
HJ8J\k^P7oMLJ4@h]dU1UpFj[W`CqK_[U0[mhPd?\?OHohP;Ul:\n;:cqjO52bX9
U7JW6o3]THU]]^T5M5c;GKf9>8SWb0=gY5a:;YnpTLShVKp;=?Q3FLfiPn4VR_3k
Jb_9G2<J;7:SgO7fPkVU`_3Nh>JoHFfaRmdl_qcX^lNdp0Z0fTZ16c=PF@=U;Pe_
2m>cK_4C>S:RBDSof:b4NEnIcSdjcPPk5X^F24:ekgU_Ip8=cDfeqHA06k]E]>PX
\VT3H5_clUkRR6a;YNHW7ZY7qEY_3dBcBU?UePjS@:]TA3P[MC7:gX]Hne<OZZ6J
BGP[f:0R_JSCd4biQpGAC66hpTaBi@dg[gmbK=hWE@4?ZDhj24Fk_c4io2TDe5dQ
?R58WFFX@Pj<050M7@8cT>hl1WeA[gaF^qO@h4fopKU\SiD2l?JfYmFD0YB\jHYA
5@o1A92NNHNLUbXWGncT@f`?_O2HN]0FQYPj=HAeeX=VMCBpX]8WL2Bc`m`EQanI
ED4YiXVW?]HFXIJ:?Y]d5Kk[XV8_`e:CT@p?0P3Ncq^HaL`jFWmI<`jfhb653Kj@
e75J<DGKa`Oom9^h9>U^L;IRK5;AOmh1MJNCCblOS1q]d2;^Xp0KP@KQlR4dHfOo
bBlZ\GNOEj1Xo46\IIQH4?VP@U6`c;bL1=UcI6@JUZP0\pPAPTV8qC7`L8LReART
7Wk?OOOY62E>TZ<QL<\4I438SdBo9:C;gbmkcnhM8Jafi7[K`6^pNU>T4?p:5aa=
9VeZC6<bVTBlP08c;S_]\5]DgciHg8HPG]XJ9bdo7fB_;<ihRUDYK;<Ag;JY9=q<
T3VCQp3J1?>bFbJC7^;]7cZ7MgH9S^0@AER=Lh>CWPV4kjiTbESK;l;D:WT8Rd29
S=2gAgI6pC62jO\IZ_o]WT:SXjMGGmObZ]IM:7g:BNchRZL28F9SgOM9fnX6aN]E
;]NAif@A[;gmH1TpQj<OnEpO5ZG7Y`UHlMCi2CfNaVo[CG8Qac:6?@HWbkFm5ic[
ldb9ckG>O[iN];njdJ@K3KaoT\XTiqRT7eS=qMb6CjMK5Y2`@;jacJHmSJ@9mncQ
@oOa0H@d@_WjoAE<\Yn[XHAi0kL[KTWf?M6YJ7K=qE<M2j9qBK`VEghfhdZFad:]
=1Apbl<8WG8YWUS_E4]g_LhAi;bVR\cZNBQZ?\1g2KAeBVZM82QX^cV`7LQeglOj
mcZM\^3pa42jg5qmjTm4eISadQ0eMkGUKf2^WjZQPDDV^0:6LO5e32AmO_IVC47M
dBOgcbkD3KcjRp]`X_KQpKIaSH`Vmf@Qa0LMlL30neeK;WEnScO[D[Z6FK70BjXO
T:nNgG?kSM5a]4::qW]7^_MqbcjQ@bV>7FNhD84QaKoD^WcA[HYX6haEIM0EgLhW
LOKgLE[jTPDAHl`VW0@Qc?RYp\ogi_MJ0JHed=R3bXY_mJ_4kBFOCGgBKI7Z>18G
\mHAG9k0pOcQ@d^qKhg]emd>acZ;fTA`Yh<>WYc?l@Oi[SCVoog7bPcQ?f3G_dV`
G0KLO;FG\O@;nRAnqA_bQ:ap=[gXSEY5j^>GFk?3UK9A4P;6cLAbfKB4FR83H7Kb
_e3o_MJE0jgBNGU?\TW^_kpIO81LIpm7idDXUY7=W_:]iDV4QMDhTffGnG4QHO@T
gp<ThP_E>^:OR\Pl4Oh6l52d`hbQ8N[KdEAakJ@PCW[ga5QMkYg]eq=6mAb9pGE2
S_a`Eo_ZV@Lof]C<Fb?HHRDPAem4nInOOD1\]`:OnGW8l\:Dg`7\?B\R`4DPVd8m
m56p^Y^5LapSD9UKUR0e1N]RN:d>9oSlZcaj7nQ_I]af\bOSGG:\I[82US4>3l95
gp5=X2ojqXYGVPb:fi8kT[T1hOTH0;cJ?3DHj\i^I5`08nI^de5?BgcUcRZn`VTJ
gIbiV8>SciAIqm7RCJRpWOKSMdo<]LV^DlJk_H2QmJZ1mYh`:HM[^]8<K;iEcV1l
@5JTfUVY5V5GM6p@P9@RGFbMHn>mS?RiePXQTFXh?IH=X?IjN2P1@kn1ggg=f`6M
eHda7dCnF?cX<iR@O=p9fB@EnqMi5X??CL0cGikhSPd`8h4Eo9`4@Oh@9OIFLbVZ
`fKO6V\:bbQe]lT1111d2NhZfnp95;D:7q__=\>TN[f8:n7JSi0cfM<GjfZD`7\M
;4QE<S\2lbo<a^KQCATelaXC6QiXb]Ro0JqehQHZBq;75QBBd9^0V5>AkT`B?3XK
a]MALfTK\;EA2V_>5NeBE5S?2;3jP29_l6[GZqi`o5R\hIRP0Cbn;dE_2MhhFV_c
ok^4ln0SfEQ5@qVdS:ZJpdX0efU1:43HRDj6X_1G3onboh6MgJ\6gE;O1lScBKY5
7UiHg_mmYmM<gpd=9jk;qZj0hn0<hN0lZ;VXYo]XEf;GBR_SQiQ\0bXnHTk6oFEM
;c0c1T?XjYb<TaELINcpgPBfNdqhEUXN@H[iM^b<a_VhT4<LhHbAMc2=1Kf:OAMh
0ZUeCS99m<2oe;`NDMICLH7oeqWBU]:8?>b;lHgZMZ6[7gK=\kIo`?4<9WDdZihH
[fqe1k33XqemWF[Ka;5X1AS7cB88BH^kV`Y2X<JM1a0gIU[2SmgK7mZiaI\AX=oM
MIn5WqQ?11Djq_[FHA84;3O`YC[Xl3_CH4G4JYRd;ZX:Zj9JXj==aU7O7E];ApVH
16Ibp8]KVcCKkBY5h\bNhDF9BW=5HOCl@7<O5P^4mZ4o^7APWWn]bNcihQOTe4TX
p^MUQlQ8K^ODOXb<lhG8oj58YASCK<0PHqVKjmeDp_G;@S@QoLE<2^1N=2E2;YB`
Z>[k8JA\dODGO3GYKEXlL@RRVFE3Sch?6SRTp>1bHQOq?2aGIJKeS]>>7lPBWM`b
3;fWKPJ356P\CP=6o9F`B8U`YMG72SAAhR07=Jgbi4jDZLhpDeLUU7qhDNXCHkmO
6o>gY95l8]mON?AF\`d=jaWo8fo645:fd\@V3lMPW:j[=2g?A5QX`p3fZk_dpkaF
F<@CWgho2j>BqRYLS0XQd6M2M38GL795OlKXbd=AcBlchi;3>D3U=SHN@XXJ3Fae
24B^bKIN^M8@UjRopL_LLZPpjcjZJ=3Q]fEPdGUJa?POK0MB59<?1IF>AK=7jS3F
RmT>2Q?l\k1Hnmi3dd<P?o:W>_ap7<o1U9qjSU5;T;hLeWF0jGb9<Z>Sk@OLcNVX
DZ7HbchVaTmhP><fV:1>lcqol=k;dqD6[Ji3EoT^Ej0aQ<9DPKJcQ66E@hYFP\cN
YB=Q6ne1KbSMKk`No:G>c^[GdqKM\ZI9pZd59LR^X4VZhQQH:1b6L2=[k8T:hH>g
PYSb1@lgTh9KNlFoI2@jjqkc>TGl5]AUT;5X:URFhAVjRmSj44SOJ4Io0Y[mL3_?
P\mbWiTB;6FP^AM5\M67kJ9oCKIXqUEd4GepKBVdXa;36S@3cS\:UBJDMEJnK<9J
UdaC1jdANL<h4<c0V=IinaG<W^772=JF;Dq[cW]CRqll491oIZMMfYdZG]kR68f:
@YY?=[][c8R\D8>DU5gZlb59\<9lD4J8N:Dg5JXUeWMhHUUM\mQS6T9YqEVZ<]7K
\:N52J=nG@8WX70a45oL3IZRXc:<L<g1YWWFCYGqdB<e4Op6SiIMOi6KO>Rh5Ye]
98:a1e:QmgnEi6iY@6KL2m];\8@1]ILUm@aCGfG6GO;_[b52@;:dP]lG5bq?aK`Y
?pjn6oXKjQW[fce3a`O<CWXncEB:m3WGU\La];17cY^kI^[<K?4Wa;FgcCGbU2\R
UKB3TpVW[l37q?9]GFLNYLn8eQb:04nclJiRcMA[B>PLn0?^\mUae1i;\LIleZFP
c9VR03J5D:m_9I7iq[L]JFeqoIi`<c<2<kJ4C>VdKf?=kf09\N88WbJSZ4<HhRDF
8N^mRA29<bAnDEOmM3iqi`TdM`Sf_5[MmgifXCe`2W=OVHog4h<IYERHO8MC`[Jo
`RD=Y@WVj;EjUSIA1a=dAOPlIF<jq:OXo`:p`jHDE7Y609f;F75]7Jo2i05_YSgE
Z9TJ^F:cOVQeP2e8;gGQ:f[gYT6e1OSk]3S8p<YelLaq66>h5Q`Van\WLY4`3nFD
9G?6@CVXA5fg=g3n3iER=cP0222lJ@A9YX1e<ljfT5h<b4_6]Y277I\qPk`DZ6pD
;I3AnoMh8lYTg7;CE^A29oQT3aFBH03nCd39PTDg1QJiE?\PG7UPci@bKIKmQpe_
j_:6p]ZEbcW1k3UBNU:GEMam6D9V?lHYVl<jekK6U1IMll6UF[_CX:KF^LR_Gho=
f?A7U=CKK6ZUf<?jB@npkF6DAPqPi4dF^PD[EkjZ]0W5KP:NcNOND[l7H_4i\Y:S
>a7<eRCqU[A?P]WZ?g2d`C<>^jdHfD:B3_R^S\E6djC7e0:KIEV?7`IS>GE:MopG
>j4Slq5idN]=U@QfTF<>LbFXKNg`_F<;k@IIlhaic0>04[A@\kfP84bX0q24j<0Y
p6JR7d5Dj4ZMN[>C@=^Ed5X2d_P70Yf7NG^>IfjaR2]mgjkpYFJ9bVpBn]F0?Id9
@hDOaEWo`fPFK<<VE[^5n2RYRiOYc4i=f35g\aL4cNq0ikZScpM9EgPCHAVN\_QR
11^iLH010R77X\Gln?N@Rceh]j8:Mo?34kW`>ZOkp4\l]Z8jR??0R5cc53GX\XA@
h=<YFW@X7=:jnEODZP[pFblHDlqJYb;WLeDoPOKdeOX5<V8;`4VI8G@mNb9>^V2L
?3KZAhcFKY8\QMqFjR1Ggp2\k_Zjc:3S3A52D\fIboJWU734jZY35dSEC9m_Wh;c
I7YnpY<P6U_qnh:NBmkQ_`kkU;>j8NKN0]7naU2GQO6S_1HhV9]1oNmSo5oQp^E6
iX[p<h;==4NQK>66X86]=2cnpYSET>d?1l=U2MZQK[>]XUM8C;NC<VVV>oX\5325
UJL^WbY]_i3\j6kD[pl`VT_Np:QV4=<IRD[HcNFF^^f2hbP\N`ZBPCRkcedH8ZJ8
a]EYZjX_l_cpk9=eT51@NK0GRkYN^0nVKoaRJ7HSl9ZV\P__CS>_2eKb]DaM9=YW
R97fC2S6S5R?697qIM18`B[^bESROIP<1kn]6c7[IYZ86g[Ia3nkbNQFTI7aZJBg
5WZPeQf^_@TjWW7\p;1AjkZ>gfobX`R_QY3R8PWSjN;SYM@:J6KAj^^`e2hFScdE
cYO0KMGdfjc>0AGG_OP4p<N1MP7FAeSbS?@dF=M_2JJ4Img^Uhgb3YbNPTG2^N1h
KRC^fJ2]54h7e]gUqKC[KTIZ_6X26_kKZ]Na=DEBk]3SeHR^e@h070hFnPo>BfW[
_Yn<kaLM<iL7CW@UKKJaq850<km@GlCX2gT_F8c?XQ^d:MDMF:=l9TIekkS]@YC5
HL8?e9::QF_hX29WDmO328]JTg7d\9eTBIWQi]1oFWOM=POi@GNiX;iq4ooAiDlU
IkRaA01Z]NgTfR8kVGd8iNgBVUB4HH7ZBKlk];`=`nBcU3DZLXh;1Kf@4?\NIG@:
eUhj0VkYc_6:oElmTN2Ze?A7LNq2dZkZ;RgHJ0@e>\XKl?R9bi`;;KBNZXD;R:A\
:>1In7>^Y;dbQ08b6YbMCcb[oADgEFOj@@jHQ_:ZHU\aL=0R5S:=Vq>nQMfAeZ3V
I:Yhb^a9@k4?Km:cS07d=LJ354[QMa86jU8AL14<LmG33lYmT4hBmK2LQg0X:7la
I9I`i0C`:DDaqlh7T6OP4dX3]W?pMTcO2aETGKYQbHhLWMX0ai>Oj1M_k95[L8IL
LFeWc`TY?:Xda84Jof?aNM46dVN0M_LWLEAZj`Q?50UP\6G;d>6OhmM[g>q4eCe8
09E]a1B6_OY72XiHm3j`iJF9;SkH]0DBJmLiTM_[32DdDg[@_[nBBnfRk5l43ek;
XDM0HJaj04b3QL][B18?Z8W4CqjM?DOHjYoX:IO89hgU3JlRV<b38[Gh0>iC>\E]
?]6FVnYKGDVG=NO_8JImcCn``UJL[>h2UioVX3mO9Y^3I3WQN?CCp`mRn8]8Ji`K
b6^bNjbb;<^NQZLC2oKon[j:IV3IHW3BMK=;KYHGLY7CZUeLgZfm:?MZ]K0DZmkp
TMkTm\Y^@0SH[dng=;gf=8lCO1@8_<;Qea9Q1jhH36eWTU\VY09a_jhALSi74gC`
N52KcYaZA:V3pJgKUn=K@QCF03QP@BmU^O[2\QSIR]j<Ii=XMc7?QVO7PoNG__<G
6l_[8BJDIjbIFnE=]K_0m0EdAK]Y`S`nE:15ed<TdCj:DYXcT]XeJ[5EhUNI50iq
lbm3`Ad`6]0=Ti<F^U1DlKBh662T]bgM4`]f==DSl^fPjS0L_TjgUTUHdm?b^A:d
U5Q;K4Cdfg^Yb8J8m<eldAE=d:T;n_=o:=aSmUQHG5QDJ^q]P;R1_n[[SKJg2XEd
jfg[X8=__`O6ohef3G`pXgo<bEcnke31Mn>]U?94mn_E2A2oi\7C]G2WK<IZ^[V`
11E]9CQW]Na=DEBk36^RL0E726YPh68jWl^QfWU_8\6Dk0>1>>Oib<52ke>N4DX;
o?pafXZ5LANAa819V;NNg@;=oeif^DDKBj?H\PD_=>]Ah6`_R\dM>5RBf`9OGi@\
InFhcJH>Jegoieln0laLe\XI6NbHV\n\4CJTUQ\2BqCdG\dk0D_0M>GO^4=XNbD5
ck_5^]3o[@[K\gd1\X;QW<T5[o36Vj1BML0iIh<_Qlg9CM1A08OWkYS9m]cKlKYH
hmd9VD[D5n89pZm3;_LM56noeiN]BmUe=AjePCiH>eYIKBki]RalS7?5Lf]G]ISh
]W@7]35f3Q?CMRZ3:Cg^j3U4LLA82ZG`]9NUmP>K>A;cKTYS97872GhqFfnlaM>9
<jMc6^U1MoUZ:Mh<mPEZd6^@Y;46a3nq_9NSNh9YmCfKb]GZjn>4FfRF[V=nXFBU
ba=C3^ehc]5OcW::SO7Jm69@9ALcB0Cbk:62<JH1ML3P:O:56VI:_`52i5:FLl^[
h[^jf[KT6eq5ia?S\eoAjW;Qab0DHA1K\3XM@AU]R`2SI8Qd5cdg>HY^bNGZ4?aQ
hE[CY8IJlFi_Aj7SL9Wl2U3I]D]aV?5@PMIBD;PeIP35G;:B2q;MdiF:UZZ:]HCW
QAHMKh>Yol3UFAki?`mf>oa;7YLcJR7;fkEfFD8c<okI`dh^;9K1h8UnY:>V[Ed8
P`?NBMl^q`7f84?R2YJ<WdB[c9IM]Z>P?O2EA9NQ`bDTE9f^0hRm^ZH`;[hCV[4?
b5WN72=?7^Y]JpholWRlq6AY9bLdKjRTG\d9nC\Pm[Y^HJGfii6pZh>0V`p2g=AF
=VeTi_Yj[o5oUB00h?aM:_nc@K3^6hpSLbl\6p<fcF?@2<U@02o\nmBFDHAnkAgA
F6C5:2MghBWRna78kVBWqhW[L3?G=mGl6:6f[85`ODZYjlA1;_9_=^RFq9?3\C9p
N]aRfZ1;S2^hljE9997dIiQfS>94PMdDFjgiGi[FqlVIC7hIPbRTZC5lo85?3emL
<`h0ReboX5J2EHATfDZTM6j=OVY5Apm?g:eJpk>^o8e:TWB1IXd@=NbIIIG@e8\`
eb4=1l]G[OKbiXoBH^AFnJj=h>87110Qf>3Be>3Mj@ZYjpamF^FapLn=?e>o_`Rb
Y72_Ya=LmIUXem_7g5hcF_mg]UDSD>B=5eSHW\k0g=:mO5ZLK=b5]p14hWVNqiL`
BXR5oRc`_Cga9P<;h^^7dCC>O;GQd?>YB:CbJ9TU?:0GBijJ2[9c4kFBYcAp5gPh
D5qj_EBYClV`V9P<bG8ekIdR1Bb@9hYCfldVQDHhECXJnoLU17g7<X3k<ZmNV:hk
cp9JPfV@qL8l^7JJD3@QhUFNnbbbk[<5CG[FJ:\RObTi3<5__hHQ3G64?@oETq<f
ki@GJ7MgFVLMAEXJBWNES`K<8do6?4^U][93bF4mFJL:3hURdP\7R]q1@nUh`p5c
IHmU0LQT>ia;<IgZTENJcaTf^GnoSnkIJBUW2PVhYIHMH>Q^3`72jo]9jh81qW;A
2\4q6=C?j02hZoH6XASi<1^EbBET3D:P_8^[LJAFe4Y@c43HFZ9:;Z7?PNI>lX9k
n^p?7AVP1p4U68]<NY<MAfEI?AnM0Vj3U?KKAUOTkIPmd:SXl;WgS]PlK5OmRESI
qZ5b8ZJqo;\1Z;m;WTL;3KRC][l1S8k=?>FR?gPMMGkj?4RX:XRC8`d>hLBl]M;p
C;m9gR@LcWP:=<iRb]njTkN3EPc4^K7AZ[?92XdAkWlI97b9d5[:M\Gkif\UeQoT
pZVi4\hqVkVZIjoB<_KIVD5ofX]?Z6CXAQea\F@X0MGJB1gh=Nkh_A`MWZg9=@Ah
p9?3\Cbp`JI:kU=\>8ojWOS:IIQeK35So=E3O\E`YR4=GN>@9ET=eEaaOW5dQoCb
:2VG\;eXqAX<e6\pQoXa423MPa?2__YU::[Si\:5K`726B\WcFXCjogo<XHi>OIj
5_L?@bHAiNgaCobZb^VW\4q4jOhnQpJ22]KY1lmXl>P__<P:ae9@6VE:2I1l59o_
X?PQ=A5eNi`PXT>>`O>D`^bX@G4Pq2LJA?3FM8d1[1bl:\BmLL0mcp1LBPV@qXL>
Mh>KP[dXhJQe5c49X[Q5jSiA^FIn6b08MKAD<<jKo@K_d=AVaNYLg;R0RGop`3mN
eDqa[U5:amA@NNOHBgP3FNO0cc^??e_^^_o`d^FjU<\N\M@`O_QNSkOcBDEZ[kdg
mdp4QeGmk7a\iQ]ZEE0hQ4om;^=B^\k\_XD6D<06[R@VWW:3JHRK16C^J__]BeT3
@>F5TjEZ=q?`X9]BpWOW[`\H3DjkI6HgdU7bIFPIA8XY>F5Dj2U82H`D[N1FRG2Y
fjk^]]C=lh@\C79R2;HDm\Bq_O]Wj3q>V:A;cMnmE_3OnJbDn=R1kI:<TI3hU?c:
PEPg\bf[Qoi8b5PG7jVQ5>7G68D@X\Bp9i7l76fm[a49WOP27e:gVM5]c7[^`D;\
i6D9j8M=IEZW>3T^Qe:p`T=0=9pab7@C41RlGP\UoGjV=O4DG]CiC?_>^nmmV=hb
XN2GC_Nm7;mGeoUN<mSj9d:Xhp5WFbEhpoi]aJQbK^HB@KjiU@6N8c24Sn[k<^<7
QlkHUDGTP;M9?49W;Q5neiAW]1jj2J<MIWd5pH69lc1qo0^QL2oWa9?njf?9JWSn
nk1Ef4WWe[OhW\c>DdB@mdXnS6b6S3mkl`j[>\DIgDT0R35qaX=aQGqC59Y5eoZD
lR=^Ko^<^DI<oI4KRZI7^`X]cp6eVHhTLEogT^GAaJ8R;ChaKATmCTkH;fW_GH[_
;aZgGambiYocZhdb4fB_6HjI7dpJUMRCRqHTB;:RO9ZN7XCgYNF]FOYnXWUo6o<e
So0[H=T_?ofJk1VcXYmZXkUQp4T7JZ<qFoU1AgnmEEmc`cIe`J`0`2mMKGN6^_L5
CF[n<1:`AjABP7pNRZ?_Wq][iZ1af\=ObN7MJkbj[GXIS:jSfOnLn3`4?Wm34OWX
CLH^p4`@T?6pBBlLTV2;8khH[\AT7NRRj5_JLH83Mi5OI=dXhN;U\`2\VI7ihHAJ
lBS0TYiHE5hMbWAnoYap`9G6^\bE>[c[_PY3FEiVZRZhB2:X8ggE3_A;nQ6SdQNm
j\lkZenqdLMbV`p7jGhiod_EQB\gg;j;m=2SY>f;3KI1BGfChDNM\EUD?]amb:6S
H:pXkce0gqlJ]i]CEi;_40aNoGiZfWm=7=LDJN4jN6n6TW7CAXAF]Rf;WlcaLD\h
oRYf81F7\Aa38F\HEGq6?eb<@gOBLK;j\@oK`U=9AUeX=DgY^g_Ej1P4nCLO8JdH
L44LVA7\Ne^qcQ\BBTpQKST^@OM[WZ\77NB8m<]];N<g6Y\0iM5eJ2[1nOip8:Lc
GdqWWQ@f8B4GVbM@R4H=XXR1>0ENK=S3ULXKhnC61pDSXPDlp8RPN3dH2>oG\Ohm
WL^TF<[6<NdIoMJSk2_FW62qUA^OgnpTUO1ZW?ZKM3g]PL<=8cH=MeJbVQXj<kBg
:k1E\e__gF^ckIMV?Q[3D`JR\m[f=RKg6ZFIhB=qQg4MedV]i2ae^\kdHhHPL^Zi
^`c1bSVoFkdc=i1^O1ADT=L:cZ\TY^pFm`FhQpSA5H6khbh`=Ad2A2fQmdAO[oFV
m^m]dUg@=GL3Tdq^CgE6HKBG1]]LZAPXl@KVPhOj>jB>CY;_IlTM=N0c;HIMN=[?
Fon1PhQV5I4UoVZKNCFEW_p;C^fLRp8ife^gO2<n[92fM?o<Qi59R=oEPG[[ffDh
PGUXf4q0^dE;=pcA:^@WYLE?AY<jahXK7dji9C2>jUCXNoK6MZg_<:T6QYaQqPC9
TJTqNnH;fYof_SmJ8TlcfP\ni]];aUjOi@@QMGQVAVbmH_2EXeGSNMUqGEoAnlp[
l9RH599\oTI238^1jPcF_RXCKNDc:XFWL;^JXMjPMP11:ToN[]UO`p63<lX9:>3W
]FT[QVW=6IHDTY]P@2^\ofY9@G;2<4^KndTaDNRc[q@XBRDCqZ23SG[VnmcJlDgi
h^a5OD6k0[4g:k9cFiF:867q^BfSgQq2ZchUf?LjmANkL?I9i>?]R3ZB_:9Jl_[L
KdNj9?UJT70?kXlFm<mjD3YN90j09pIDFVXWpkUgkPZn\W\RYIh0?47hQ8Ned2Cb
0DgYjb^lGTWA>4jl[0:Q@VR6q3j<Fc0iJQoH^@_E1iI>aQS\=Lb7;TABN1h]_SiC
oS\_HfejICKB]AFa7p8TOcR=pYSem4KT2jH<>li`\Z?8F2GLZ3[1R;[6O`_<^d9G
2q0R\@4^pDT?JbY<o8kNin8<`jB=4\J?8[DCa@T1:JHGUGop1]6C3Wq`J1mIA_@3
Z0=[XjRXTiC[_Xm_I@nIRiQWKi<02paRT4:bqH48N]SF?6_7XSa=qP?NhhHAnNFP
V@ojI54l=hme;Dn^>E;B=4V8n]S@imW8;0QbEmDJ]FCq5BJ3HApl]6e554hc?lk[
n3LMAiL:>7CZL47gOVK]L\OH50HpZHmg`Mp2G2WQQXCJmLB3cL\D=bZ:kQAkj3<J
FfNPZiW6:4XeGqPM5X8IQmCmKSKVgb0a\[9]Z0`_hCU@^eK>eS_ZiM@`D3jjAoR0
>=ORK[f^2g^]d=Enm6Am6h@RKmKkD[0a\[O]Ekkk1:?Y^RX3S3]gQ\[B2qd?<B?=
Tlg<NNcPmkk7en8P82PkCYXcQ0_XiFnJO::V3>@Dk>C>SShG:SlEl@GT`H_h<=I[
O6SJ0o:j>XGR5R8iGmPVcNCDLEgb1=OCV`pGYV2S60\D[AhUVccd\874HBQ;5Y87
CVR_3i7AniW2i=m\jn4KIR1`M>4]G3efa2:SJeJhap6MN1QG\flUWPcabR1A;]]Y
SUQ7kPCc][i:^^4f0G=ga:SkAag\eQVGI\C_HnTfGTYgdQ1KNAh7`:3ODXlWTl6I
;2Q8f;8=>c?K\K7jUTp=:FL6=2g7XdTEoH9WL1ao4U^6j??Lb^c51ciZZ12bBkV?
CVdDH7L>k]Mdm7q^7<HSB=?<0NYMl2]L_KC5cnG2lK3B]mhaU4@iKb4f^i1;R`pR
EI[LN?4i@f=l6iR2;e1YiNbh136nA4C0B4FKWA4TPY9B@=fK:d<G6pSke][hd;^`
:oT5?Fmg0k75g3A]:O@^fGiJU3`a;3f8=RBcRq@P1RH6QO[E0LYglP:aS04IOVQR
4_66ZNG6PTFZBbVbZLAV9iL;@ml:3M_VUR;0f\kG95mlUPZebMQaAeU61J:T9YQ3
JfBQpCkhHP2q@fJfYZm52;jXKm_;alMSDK[W4[IV>WlIPP6BVBCelB6B1_>?lFFo
3HSG9a<giFF]p?]=NWA>AD4m4iV68^?Z9XiFRU7cFih[EA`Aq>jJR:?phLSiUTk@
dJRO0PMS_FaJNRGeB<P1HWdN=nSQkg?Zp;3P4jmqlWmBIo<<SM]SRKc99e4?WiO0
:BdM`nKG6HgC;:IQp2SC_Ngp^5bYjhI]gHLJ33Hg`lDd4iRiiTAQn>^>]]2a=KTY
o^oWM:qk>]Q^omSAZEH7KV]RAJ<qeRLnFeqlH3eGYGCU^n\U7=aU=Vn2CV1;YoR5
4h15ESh>6_W>``KV33YJ^kkX<qM6`>]Cpj\HJl12f0Eh0@9`M]7[7d\WVWb@gHGA
e>]RGg8blR>7OHEhe89=HX7?9=_64_8leliTpm8OmEcqo]XFh>fjc_iHVO`=bP1U
PPakQNSe\]8@ZkK8o]7P]GWUbBdNWDen:h:95Ng]aEq9ea\ZXp^O2mLUY3bon?o`
8NLU1P0KHkbhOPQIq3mkMB<hl@c6Q5[EP`SUV7=bdSfgf6@7?m_I@gV@8lf9B=nB
Y^edfWaf8R0>qlRGI0EpAdPPi:2IS9:R3n7K87ZX5bZY1a>@T7>PT^mD;OaZMSJM
SBH<H`k2jhlCgW^pA<3YFYqXhcDi2=O>okeY=J<>?0S@n^S7g4I8\4Z\0X8AH9JX
j=iW9_oB^\J`OKWCk[KbQE;7SSpGJn26kqI;0SKMlk`42X;0MTTjH@QBF2b]2VM4
;B8ffAiKhoYXN:0^g=]BTYHKK\K_0YlofZpLbh[ABNNU9LF9<i0jAL2?^5<STUEj
GGPhRcVliV]m:[ijmn_d^>Rck5[48Kb=]B0M4nq^e`kA<pX=:ZD`=JIiOC6^P@L;
OUI<k;k5Oi8o7kHBm@BAm9I^eTh7Hk0Y>pB4Ue4?q;HgfEf2<:1D9E:`DKTL1CLI
:f4S>8E5PLALbln;UdVA@eEP:1W<cF54]HW[pJ1Coa=p?33YhEND<YA:<>OCRk1J
SMFFeVG\CI<kKhh:o>nJfQT62S7QJa?FkFkM=DL4oBQ\6W]O8Dq^nm3mmqUnBEFo
jQOD8VF[Q\jhAkp\8Jn\FV@jQMU]oV<c_OaQi5RBg`HoZ28NnA[VRnTV;E<UJVM6
?J7_SLMUceeCep9830:`pIaHdOOh5X]a4h:^HN=5WC_KCQG2GPH1ln_0hAb`OF`Y
5[@GNOmJ::h_4=\NIn1<ZdC8TTF3^5K1p1P^_k9q7A25CTIBT2Z4L_h4@DT4lfXc
fGN=o@FfHYm<3fSQR<EkOa__Jc4XmIK[T:nS>Pe^W:7pS5P>_Np9nQFWIW9`:J00
L=I^l5M9oF:HZ4e]J42:@akFGP:`XkUX:4`HBYHXM4:nb6YnkkGfa\qBP15\LiG@
f;VdCT7p3mkQeMpZ]SWL?LYUX8^_`UHTC=LFo8dRRL<jFQo\<aPa7ElEhT3FkU_d
nj`2f`bbYcYQS3h4=W9>d;X;?Y[?BY@p@QbK9Lpj]X`_o6gnZRjZoEZCNc?kgfSc
RgWBnO<d^bTkLYWN>:]ET\2<NH<ORngl4jPWS4>>caYcaLLLU\>XXq9AnO>=qe^<
5_BdkVQn2XbbB?WIka=6n?jFKd^DYBdJKO5XOf7]3lni9JIWaWEf3Q4YWk>UEj?a
@:EAI15QdjJpV8LfbDq8ImTJnUXXHhnVamH^5D_qeY\]P5jo6=GF2dKk^kZ]IQb5
b5:nh8jIA]j7?2H13ga[Y>a@V]3Xb]`dQBZ:E2K0Aac^nOG^q1<8f`Ipl>]56Hak
SAhk9FVEaQZ_D_@mj>edQ:lZ4K___5Idgn4O_m4V=;6Q4U=03_Ha57^[hQO97Tq\
^WfFaqV^`Jc9e1hMOZBD8Ni7V5[_WISWX_>jE:K`YdSE6QhnN`X:K:\3EfnWZFG3
JG>c8Y@mK3Qg@ddORqVlM^L2q9OnIKU`>i5<>YCZDPNmigk95^L\f8kM_3K2bg=D
EEk^o_]NIA^^00[>f\NPQdai3HDAiD^lW_I[pO5^hL6qRl8WkaMmj2BSb`IUP1AA
PagONSV4ccIW:[\GgYUFD_B^LeRQBTP0WdZm1mGA7dJhoG0^;UPAqbgWTF@5akcH
Z]III6YoNgn[CNRGT3hhO:4JpP`X4^KpDJ6hdaZQ\\31I;@6dJ>CFNeFbJ`h\E7b
00_Gd50i`V>5F_nQa2lWllQTRi`Mo8q5RJanDp[H[`aXgno>de<HS>6]JA:LQ[Tk
1_67Kc<[SL?89J_YIKVGaR2lS@MopCZWonlpnXO:PMEUefhTlbY[]E[SK0QZF4KD
?fZog=T8UdHm9@0bG;JK4@gLo`qG8EOXlpO\nZ>Nk`Lndl]Vbbjh:oQAWEfL;OKA
:VLV<?W:798iP]:NBnHi2qC5RUm@:5Ok77l=HLLJd9cQRg27^RFmj`R9[X7JipUo
EAmJp@i<TjgBZU`MAdIcL@=814aiQ;RALnWSYohVC1hHMJRQp[3LC=9p8DgH_>E5
lI:]4g=<2PnCfZ48I9ERHLEih8T8?@FPPdCq@F7a64palgTgfD6BIDJUI?GWZlO<
KOSa7lE6PTPkNMQ6TgVmK=27iq[6[]EcpXhcN059Y6TLW]AQ0\eH7FoR?2@G4GLj
coag2Jk?lGC\ACU^Cqi554D44\hfFhR>>?6bJ;4GW\^C?Y`XkqjBI4ZXpjD87>jV
1R_\Pj`DWi;VMJ62N>4I:@0WWclP:=T8HR\XJPXqBAX>]mpP;I;GjA20[8M>iiYa
@UE1L1:3LGRSY=AMH0mDj6lBlNOGJZNi]f;]^3J>BYm5fWknap>9mM;EdiXgYSZ?
E3>PlLFXLcKe@XLBOHR?4G`\Y]0Xi^=apWm>QDoqH`12=68^Gi6Vk;]anNR[GNZb
Q4b97HgAoO[eoIlb^dL<J?qBg@YUaqN\B@c<C?_0fE4[214AX_;L_9alS[73A8YB
PgR@ATPVdLlH3cqjNcBhJpmPRbQA=Ke`3V]8WCmgGG?aF;2I8M18`^_FZj?Z[V`l
oMV8j2qd3Q1bDpdC8Lj9mFIbeWIV>dGO9:i^a@?NeifDLb2j6I9FfM6\WZS=HTZ7
8R]Hl4>G5=45IO;1Z0=XJhq=UU0GC`:TMNda<;>8YWMO9Ia:g8jKRoBYD1;^V[=p
Lh1Kd^qQ0Q=bfRi^^4POH2;DDhaHj7aE]?D;E;_^CnD`=X5ER5p]nF_EPpSB?=Wc
QXCUXVaZAi:LC55HLbjnfZQ22e>VNbp\PfLeX`Jf[T<eD1ig7iPflSGVOjnSE;?@
VTVOWpF?l2RcqoRR>KNf?dE64ibYA5?XC^7ZZWf@M5nK0a>fFX8kB5YkodW3PW][
;R>R1`fS8ENckpe]66Amp[Z9PjdeE>g@]0CIUKTnj>aj?U<7kfV:]jHh[9A\db3d
c\SLJG@Wg;hq\E1encq:4lH54W_5aPA<XUT8gC\:0DmLi>^1QU]^Eie8alPjB9GL
;noYdNAX6pEN@I6\pRnHbek=XEbGV2D`;2\iURK4D?_l9iddJQ^OLKQ1HkM[5J9i
EHUIgO]>lR0HigI180ASTq`@O2TND]Ca0V3j3MD3Lfc2M0S[`_=CZG4bo8NhfP:9
Gq1col[oqB:1dBV`m34@fmNUT@][\0>_dN>=Ea?[8RhZbo[7cRnJ]p@3An?8@l7n
B7<S]1JQ\]Xg@fEA[hTm]SKlV_VBl@I6Bb?;09:=UmDoq@=<ga4aFRA;66>cd@dB
eTRn=U?Eh;B36\7Y\;@a5=b\SK1HV<PJ1a0p^Egl9[S=2<`Sg0GcUY04c?^hYeCe
X4Ymq=:an3`@i92f[oERTAJfUWfN<]m3BK81C`1BoJ=J^9fa?eO;mej?=`bDYFYS
1\2kMqQlM2IDXLRDE]TMj64P<TY3l;R2@Q^EPM9OQl^QdH2SXMlfH4fe4RGDCAHn
7faG07p[5jS6>>Tb6a0]7WC0HL15aU_OEHIVfoK5ieINM2>cbQ7Zhn`[eHeDd6iS
?5LfmpVAK=8oml<7=?K[\>_P_^AS;KoZ1URLGeFEbphiQGfPTSSkL?kLBH@W6<d;
nP?MLN\hW[38dVVfGOCUd\am4_SM1beSAk5f2O\9p0H_Ma7nbbW9Hi^4K?4XOPA8
laBb0mGbiSPa:mbUY5bgaWmi\QnBUOihSpKnUcm=>gDX7WMNO?ofW;HMC8G^SW6C
R\PO5Bg_Z5@WiPcN_dehR:B`5>pla7ZM]j\>5GCIC4X0Yhada]Qj?^AVRd[Ko4KK
cb\2GN_PojJ>Uk3YNBPpm_HVFiM_B2ll8=nXjKldQR7mNmfoh_ci;5d>LYlN[LL;
cDV3\<fhoL`1qgUFkm9ACf5ZXfBjOZdYd1T\K<K??P75YGk0_gNHBBRm`XVBUjcn
B9[Lip9`g]\^_O30TG8OP[JFfjDo7K7>T<d7oYJN6;MSkn4>mF[Wa26JKTI04ip3
E00?ieOA0JkbQ^IiPRboXOlNCHnDB641XSA=JHNP9;TP0@KNJU>^6_?BNXM]n25=
_`Cq3:TJCW6OTRWk>em2VniZ3m9GJ=PcTne_EKXYf\]13\a1J=a?W3Wg]SiZqM]:
<Z@j1?_b8j8jeP2\_GnnSGAQB\QkibTV^01Wi6J_YJMBl=;:6N0:Vqo<VXfim10K
4<Z\7SJ:0_NHhLWO[1:o8[>QOn@a61b?L`<WR4cKOJQ:ZGq]PcF8Xg^ASkf\jgKY
7k?ME7T2<2Nm^h]gln;@dHZY]T^XlI@7l`YNfhZqKmW8@Ma<?1CXGhfY=gQTk0<J
<XCM797o;ARXOOESgYA@4_RD65A6>S_n9A^q4U`N]Ji=59>efTDoAoG\9KYMBL0M
S5KnZ3b5O>Ojca?9@g2a6YEa\4\1`;4paHGYTBY8NNJO<092D]=l;;GnZ=I\IfGn
:N6WLaENT<CYRnM=;?Z132dChJJq6EQ3fbL^b8hX^R_<F:^C\:E4=jM[^DWg9hIm
N]lW\X1`k0D0\>?2]9qA?d=:MXl?=\5@ccbPW8UX5:LeI9XX5HNP\eZ4bBnUEDbL
;g`Z]?iYVG9C6XqN>T>g>2OAKAMjjg3STTXOMQmY0X>X4\FkAoIn30W<59H]bdkd
BOL6M5ZIC?qnB:;C9RmRg9;KbP2N3BjkY<EN01KSf5f>NU<<NoZaiDNj_2hf\jdK
Tb:OTEpH=@[CQML?;2X`nLV<QcNNn5NJPLLdO60dOS4Za:dO6feUX^jMAY;0Yq=1
2EW@]C6A]h8[h4^TVmIlb9O]nh8PT3M]YAij\@Ad4Yn0p9Fo[H=@I==Rmi_f8i>c
o\<:oNjLB:\GhL>bI4BISnB`1hheVGWhHHOqVY1Zflj[dYI\EAe?BeX`45MHdWbk
N2GHG?B9P4LGE0lS_HcaW\Od8GpS^WYn;[_HBNk[\NVoSBb;kXO>lFCWJ_47clVH
9IV_iMU:?^Oe[`k>;qI<:TZF7c[`M=;k]5ek0^L>V<_olUeH<[QoRSA9d4;I_ma0
RKJ=ZZWdpWj^;G:Tg17j5L^\PeHfH>VDa2Vnee@?mla_g0HL5K>d9f?Eend<4]Dq
1h=:UGHaE<>nXP2m9_7hMENILKW5`d7K`5f8\ZFBT6Rh3A8TI11l7_pK@2XWYBfI
c]]BaH\FW9JM?LKOehYQchJVWH_PBRq>`8@MbT1kRJa^oSd@bM=\^UoP9ObQQX[>
K:;dO3QQB``UC2R\k:WMiq;62oG32j5F_H2I_l\YXldK<fgOiaD5Ho4^Wh^cNO3[
<?dAmPi5JdH6qj<R0EZ=;3`6jLAjeJXDbV7lTeMY6`gkNX0FW694P=7h5UC^Sga2
\H8pY19FlX]B30RFFf\NZkN?2XYScUT9Xl0C9?CK?Fn5RD6HhSi<<V5oJ>jdqc<Q
n1mhWGM8[Qkg2TiY8T=K=H7Zl_^nIdGT4Dncm36F@GL>;o]`L4jVfp40PESReVW2
C=[Sa2ZB<5O3UVa>E5_BhfYSQAEW`3Uh\Ka@IinU838O9hpG;ofjKabR@9_X9mJY
TCO^JNKHL^>51OJ@mA1R?[E@liBMW_@a2<LTR2aj^n@ZH^UpUdRa5T?1Yg:56iZT
YEl]:do3]Rg9>E5HJ;XXig:T42CBa8ZlV8B6oYIPqUBd\maREGIB2KeL2_YLc7Y2
COC3f:F0Fb>FXoSQ^4S]3e\>JiV9_OXkbpio;Jj\N?K>HF[1G6:;DaQTn84n58K5
L0GRb<B>PV^oJJg3Z;b>Uni7XSp1>4KFm0?LP16YZHjO7bTFn10OeDFWK2Lhec?A
X8L^>O?2JI3dI974iPj1KiK]1K?\;lUiFCTDj2aJhpJH7H=d7Uc^WeZ^Y`ZAg9?1
]`VgdYY[XSmIYUaeX[Ok:hAa\lc[T0V9CPeLRP[I>qWh57>N;lmc?64WkqALbAF1
?cMfCLAUK1TSIX^Pc;k4A[CfA98moWAF>>>l_N\d_g:QE_`OjhAUnKBRAq:Q1KA>
1mIX4RO>=Ami^c``J59HAadi?MdHKmmAM6SFLJE?b2hVS<HO6pW_]cI4hZ6UQ`JQ
nH0bT>=?<14S6mK20J99MhW[VEg=d5879A]eqPgFG8bBN^kk?S<_bV0bVW4c7>Jo
V5mUN??BDMC5g8N563Tm`F2Dh8o\J^E^j<O`pNK`Ygg@[GLSiV`c8Q]N;<SH[jO<
5d?1DRSeL5^\MQRTZd189ZD^J>ae[j`RVqUi:4oiR4@FFdKd\hme@XZ?5Ca3PAY>
LR\;8oglo\J]PBH1V3pAf8J^Ncelf]6n5QA5c6S\[2RGbO>PLCe>1a`oY?Z743ZA
8J9oWV3??5qHh=ofKd>j6J:maZD<=b]0_=o9bPDCWjR9_XC2OFf0a4T9Gj4cjPCo
8:mg^2T9_YKW^qC]\>R5L62dhA]d91]hnRTQ>GXX6mGG`nC=DSelZ8A`5WFgRZpR
ho^n=M:XYD4<O:56bh10jYhQU9i2GOpLZXKb=AOo4GD=7RVfSaVATESaK6i<AV:m
?5V9Bk\m0NL:FY@LZIF@`ceE0V`oMJgOg5Ah_`:1AQOqIfaIZkpgK09@f=SHPjaX
Q6@0=EEFUe8Pb1>T_E;]a`qR<gIhkp=jmkhUUiU@fQ9W?UE>?kM3];nT;`EaAZ^o
LoVA18qe?0HB@eam6Em=^0aLU6PdefH0eq?jlaLBqI3\8=HjHd=QJJoKFn^g[Vcc
GBJ1`^_RlEl`nJaJ4qJ4HMKoq4Wjj@LC<SWbff6O9B\XL3cXDDJGNPlc<8gW34WM
SdR\I]9qiP=V6Xp89Z`M^]WU27V_f6^C_M7E:dBE7XCWlK]Xg`1^^BRn0PlS0a4c
1mdFH[]@Q@F\1qng];\1qWe;;\C5K48\kZCHoUdG9SSiR[=L_?6I^gh[OM8gRD`\
2O2a>qTRa`OAKPNHg;\njUnA_mW1ml7W6_69Y97R8>W>q6M<o^WqcfXi^L>OCg@R
lZPhYZ]]_hJ3bl:>;POHDU=\4fcD=2G[MEC7\TOqSQ`im4q:05Y:Q7=E\j>87gXK
dEV\Q7jI7T6WN0^gUK:REG<l4N_Z7QllaI:d=UoZJMU`Bo<ld5VY5MJahfqeh96h
`qiC8J>=fj67]P`FAdnl@^gPo=kiZPXIbl]UY?UOZcWC@>_2Lm]hnL\4=Meh[8`1
pK\Z>kSpnX^20\?KY7BQbA:;Ub:DSL5]pZYZVETmf07BW`JfPCHGENWa>_]Sm1bL
L@hUdaZV>0bMNF5PHG;Ja^o?iXKPXMR9?DnHp>`\ZDCqGE_g?W9IQC0j6?4hM8>=
Q8d@VO:gHMgiVKOaR`j[BoPM6Z1=;D0g=f;MOdOGIRE=>7:q`1Q2<Pp@=0V?A;Zf
<9O8ehcQPD\7YLB9YJ<`h7iP1T^N=ZI[IEXLm\HdDQE\`KD0=JfQ9qk7Gj7Xql^?
3aOIo_Skc30nI\ljLH]UB\WV]=D1NbWEZaW3kQ@P?IWKG?Ik\\_XNZlGqgGR_<mm
<M1n=meQd6GnE6YoNM\1m\@:n7dTfQ3T3lWREWUnCQoJ`qM0[HYapedLUCQTC96]
D^FNV31c0NcdSaDF?^GKYPCmFC4^F`B<JJA\:jNWOgQAN?Q\TgoNV^NWq:l=c;eq
TYKk_91?HhZjAa?_8UY^INOK@F5[j:VkDN@mjDS[:^2Il9U488p1P41@a<]oAXM<
LoeS]N]]DELZ36S2L81656AcJhf`@h5M@d1jDcH6bV3`]C;\Z@;HVDq0[i:HApD2
_?]KJ=o24OZ5[8eD=CN@CZ53WVF7F1RZogm?oY;gg>5WBGm]2?k5IA6l5pdXnHZ=
q1J8dIoNbKRj3NEdCj=G[:H9`2gD4JYffNh`64\k0hUm9AUaY9B0?b\5Y`3B]leN
bADPqTlcQD=p8o4W67_]lW`am\^B47@H9n<IhDM_R=iQWePJEV_>Wj`:KEG2V:_p
5`WIdlqhB8D@<OFIKAm;V2HF?NYVD@I\JQEZfRLcj]ZWW=Be0g:]Ej^J26gd=eJj
6R0OG51d`mYq;hH44JMncJZ1UB5eV;a[QG9fU9`^;U2F>40AL2?c6nTY@o4YCbNB
6_T`8GUqY]H;EPqoh?lb]7L0;GifKOohTFAMS5QaaVj:TJm?GIXQ4VeGdYN]h>4m
`oYf<SojL3L?D>2X1;?bPqDEK<?_pkQ2HE<3MW`gIMQI<:_i5mAcSaX9X]WaNVXg
9`I23Z[4@WQdL1=1<fOmOEZdjVJqnQKaGdp6\l4nU1BR5ckK`7FZ0j[6698YXJ=>
O\N<Lo7agjD`GD9]H?YQ<T2UNTGL[cmQlD9Jh]E[o@DBQEqFYH^^gqXK?3`?ch_n
RT5gX:[5DJo9VVh7_7\kABVBI336<4dO@@\V@N\P:bINS^=iap1T@\B6mSNdca`Q
GKKJfRWF\54IP[X;1T6=Fne9pNA7>7WpSWF5kfk3lBbh;SnHadJ@TWHB4c5dmnQW
QXVFadEj?6hhDR[R0_BSf01jEhabRi<Cp?RUi`Yp_TVE9C[;n]LmkYJL0J^k8GRU
ieGc]m<V0^^>66`HBK2aKi9NZWS<;No]WknINi1kEo63Yj=C?fN=>5q3abodLU2B
EaHc;RBm5=HFeD`CO20;58MdFAWIjG2pl0TZ3?qR\FHGo:dOV]_gjX2T2Phg0EjX
\G?;e1[3cH=6]2J;ij8ZoPH0jGe`Ng8I=lGK^MoiJ_nmed5LK=?j4iFq=36DgHpO
C=B_OVH78iig@Ol5Mm:3MIF<X_h:Q7k8DWiY:@Fj2Z_E2HVo7GCb=c=<^<HG68GQ
n]KK]AnXf1GmQp@:KAAOBX==9;@iS:k=9KK:6J>>jk2J14>T;pk7IjbVqL=3m][=
QFFD<hiD3W=KT\4gdcQ9K;WcDB[T`4@D9b:J7]1H4fB\<F2^cOc=a=;;XacNWZci
TqQbonRUq<n9PneNQ7?P3G:YiXR>hAOG<?[EeIQ[d9CK]:o=hR19KKnAF52aG_@:
GYiC1Vig;UinH5TqLAUTd@cD9E0_P84gUP0JT[O\La=^_]1@BJPK5BG4CQlJnn`B
hGg;[C;ZM4Vmg:\6Y_0:NBpV@jKF>qU0jYIQ9L:A2\mU<RfLBRMX_3oAYENDKZTe
GQPcOQHaNmbY3U=?;EF8VOfL8Dboj=FMY^D;YEA_gq?b2XIhq_N^eUaoV?8MBVIg
C]T5^L=c>=j_S`P:hWePcYd7_lC;mcI`h>6eK05Vd]doUmJgm13QAeKhGX_KqOJ>
IDoq1;4?=c3Y2O74>3IlmXZkel?75fBH<2C;X`8QlMHQZMG2kUU=;`[6N<PPU8RH
dHWLn5NUS;fMp^1R1i=qmInaWLWo=FZg==jdR2CoZgiE[@IRKV;lIZZGiZ9Qgc>o
<c=]>b70L5HS>SMZJ<qiKS\@b_F76`SD<[:^M?]0^4iABKhI:U@ZHHEaid<QFK`^
cScc0mMIiX??JTNp4V_YSlp<FXJ5XVLHjSX@<VJMI?c6V:G]7iFOh[UZc0lGXoaW
RKV=mq5[6@7Xp4okODhJ4F1Na`0[0;d?;7L;P4[\O:oda]3NJ<Y>LgmXGb?lS@9@
Wh=p7g0M9mq_JOk6>GjGMSeAd8:n3fL[OAZ7i;7[IZjM\A2JO;E;:p[cQF0h;`5P
D7FId=mMfjeZ]KPI9CH9M;J[Y1JYj7DHi\X32mm]^qnB_26kp3J`1OH=4_Y?EOKV
k<2YMXXlldE>TEfKEaHIbT`\Um]hn4M?TL=Sqfn=N;dp[DRd_9mQUND:_3UGT34o
k5Gd[Qh^ffTYMfm5LX0Yn6@e_7i\2gSqR8Qe8apSe7a0VU7>IgelGWXILlBZ@HkB
k5ZBHe\gmIQ^0Cp>6a<J1<XGYgG66\k\ckB:UmKaag6fTAnkT<II=7\hG8d79[^V
SdSF_\TAj0\2SAKEncKm[pOSPWeGp6N3li2UX`c[lh<Who_bIaT^l2gGk\]_g`h4
Toid6f]jScSdVAIOp_YI1H0p1;hD<R?J155H75dA>7BJU]>9<CQ@=2XL4lh@of_i
YlihbU^Q_enOHM^UbgX2lQp[HOcL7PoZnc<93WYEFNRWG?2h64d1S9jAocODgSL0
nd@f:]dQ:7:eB1;ja_WLoq6E@?_WpPjda9h;TG@X9Aeo14@_E[@RLhWB9dWk7[[n
A9LRn9`WGj;G]6ak[dUTN>oA>[dmd:eCW]I<DOGjC96q>o[ObDpLi?B@7Q^di`0n
\;ki8NW[CPPnej<6]2<U9UN6_8l8P[=?B8Hq_kBEH?GZjZNPWdInEf?2nePH7JnL
B=2k;H`J6aL[io5jVA1g>E9BMfgIULpdiAVcXpX3l=\93a97D0@@\^0AiYkkIO:g
PXB3h7WOIAU9c?FV_30mD_N9_AlGKPqcUR[`7qNWol9fEZHeAjNHFQc>X@9:dR4J
NU4VodG7A<>[8jXjh5\9qjIHWh7p:;2b>LEj`l8\?Ljac1X_NobTM;9^R0dSZXF\
=:<a2gnB3gHZq<T3VCQpXM]^EN?68aQ`kS3LeVV^SLNd2IWnPN1[:`E9cSmQnmlp
8Shd6:qf@0nQ5ieC[C:B\:H>EjF4K74DNc>MB^Ql6AMb04>Hn^_lUU<0@Y7DYkJk
\E:YXpN=55T;jjG\7?Cm7PhnCbBa\UVLfC^3mnFX@<h@`ZM7SpXYhE`:qe6=aI[i
;EbM_PC4n9DEo^]3N[dZSFIeCk51S]P1=p?hOdNipP_nj[?Pb5=gQmbW>[b0:TnD
ABgUP9>2GZL][cYGN5J^O\1q:34ZVNp0i6=1SjZ6BV1XgPECinJW@P=^Yh=gCW8Z
h?7gVO54oWX7TGOK<Qp=oZ79[VkJRl?bW^9`f_06D\6F^PIn?FW[?JL:E[VOf9Fd
>oJXn8cWe8;`o[q66QI?bpQ\0:1QaC7bnn^<Ymf=86O5cRN94fIhNeaE5qg_V2;2
q\QFKWX=FIK:P3=T;:8QW4N;KYV9[1L\2b>2po<YEYI@8b24d]CAimjd0GIjZe?V
hmDOS5?AS1V=6EW]liD]k<S?<7[gHpHERQP2q?MfmdiiGiUNokkfNZ^a23@fVc8[
k0gVW2Fdd03b3_n7kB0qE4fcJ:qk\BoPbQ\adgJ^Z?OGN1ioUO_foKcTZ\[b7X^2
9Q0Z>9pj:B^U@pFGZo<CGaQR4VodXa1N<H5T>^>=6?[U4p>a_iFlGdPS0X0ddG<c
ic^Pj=c>:SA8e4lddWlZLKMXmqKa\o?9pTV2Kn^SY2J0@OcKokFol<J@]][3D1L=
B48n>aQ:<QXip>2W49Jq^cRfkk?G>Y3X<OBQ@Z>CYhZDmaP=^a_TY6Rq<gXPH^p9
fI:8WcEhXTo`=nVjW2gUnhg;2^1T;n>m7K;nJ?<c:<Jm`q1<V5ZJqY;PH`Z>on\^
U]I?Y\H\jfCMCPnMnm]ODnCd8dVYeXoEKQk8ATK]_m;]fq=>G]I2dlHZnV7mL>NO
@k0S8To8?TbFQQCil122]31G0ZXLn9C`^0l_L]Oc]m]=D1pIhe<Lap9OToY9@GIA
oL:Amb_C[KG^Z;\RPLo[f8e@cVbT7bc;W04l6mP7`2ngp[Hm<k9pCX;:IEojQb<Z
0nT:>b?A\EN6;`MVdh^JM8_KiSNhL:?lF?<aIoU[?Z5X^[_j<QMEXQqSh:>BSENZ
>R=0gY256l0YL>PH89Tdl1QFBg58lJP:HX4hTgIJ1b;1f<lU3MY?7q<UE0io[GlM
]ljaJhC8CER8K>=kmM^:RFe=6A25PHGPOc[_ZJAdROQhP@DER5Ngp:oHJ8k=l8KT
l@bLSnW8;F22`Kh@E?_ml_\P9>\hVmTg=>[h0i0Sc=cem06h[JYpUb@5>:SOCH8[
2MKe3OX?3=NYFBcga=IV^Mm;gl]R2W>BO>IFjRi>4KJC4hMAD:q@Q2i@HlH><45F
[PM1a7M_eT4iH]nc5YJF<E7T`Sm0U?_`5EYjF068:QS?^qjPT>Bh5jCH7`Djfd>W
1l>U@\>74P5H^N58[M:;g]Nb2kN:?QNnFe^`?nJEMW7mqlX7FdgJIm5FY_0L<GXF
7P;JS;Io\E;7E9OB6Z^GPihoaAKaFY9UR[GcGo20K_9pDNDh<k]GR;jT:CXQjLa@
]c4SnaTc@YgDdhcU5PkXHBk<RBkKTU[CIf=6Bbfo^_pQAUaEI00ZV_:1DWX<0Le2
90[XUnLD2W[2]]YOoMfUi5HR;__FOCRJ\0YX_a<aWqcWBVR;g<9on@;b5n2]E31P
4J1F;5G99QlE;e[Wn1UM5kOU5DK1@oniE2pHo;aQCM9Uon`eJM<B7nLdcK40O<PH
PAd7LGeDMJl[`DNjOAfDODZSh:Q\0SdDS2Lj_RQ0dDRp]YM\lAfM6\TfB63c5FAn
[U5X]le7<JNZ7_VAfB43Q\WM\j=`9^8DSJ5BqhRnonCf=^]?7b:_58LCilTe:BK`
QhOlcK7=8k1>YfbKj`cXVXihj5jn>q\L<Q9f\`GfJG52^Nd7hT=J]BV3YCYC;75M
OMQ]80F<JM3V8dmMjm=A4LpO4:=W0ikM4Ynkg@`NIX1J^lgmP1VJe`P]2@>l5Y@;
9M[l3Z0l<A=Dem:qn>T8>]KF=IOk??aK>W=>5X;CNmf``2m?i]6LT6?da>i6J_2j
oV?MhAco5]6>d1EVL9jq<SRX@:@Y4OSH0Hkk`26f4b<dG<6TBR8WBng;e=qHol6e
X?clJ:_3:=]>VDhiKX1o06ff6:cWdP^8AAR8C_ZKJ\B=EkTF408UVWZ<OZ6?Qoq\
GfcB]a?lKRDRKeGS96Y@?VL=\<<_9iQ89GV8H_cjT6^PfmCmFMS`P[AWD0XLo]e4
;Eq6aXC47fiBTXQJOS9?3g2m5]]j=>IGoT_;ba?Cn=AGZFafT9`IV>H_OjNBk[XO
;C6cVPpaTOm_eoI2@GFFC9al`li3;_MV6aLG_b<_U=9g2Ma=8cCd]g9CS5IUX0oT
VgJf1APC>Hph231RV@2eWXCXQXndT=S<fI\lKooUmZ3G[C2Z`Mc]U9TGBMf6;k9X
5bWCLM@J2;ApgQC1hi<cObTlelDD[Eq275WEMG>ek^egHMc8Y^cjnRO=O?JHIY`J
IfY>@L:`h9HJhZ0jA_UYlbGZD9\5kc@q01ZHaagWN6ah3Sfb9Y<c8FNUB<2ZlEL2
OhbCN5m5`C\PH\gcC^F9VgVjUPJ6k\oHpcDe>YJ;SEX7RaJAF]GeA7MDmGNm@OdW
d@Q_3?<10XbC\EW9@D06;I4OWW_O?;_S\pc1l?K?E10^SMEUIQa2e`A=b8D\NNV6
2@:d4T`1;9[b2g6UU??hi?gfC^@:eUfTQfq?eVQe]Fg=0FB>ZiE?:=[>Z7iDhcNU
QMHaMO3gScRMQWPI?4NKdNV]V1=o9kB]W3FqB@K0AI7edgC^F_dh9>gAbI2RC2`d
=87]R`AoTMMHHiH0k6Od[3cGiX0cMj3G^0HPqMjdoJ?I<E6Ql1<<fYLDBoCYd0Gk
lHDF_@NUG;bLHUZU`UFPn5TO4n\:P<bnW=dg?pD8P>aIb0bIlN@5fC32M:<<cUW@
_TW]7?MfI8V8NY9<WUcC]D^>N300M9qm?IbT26^[`RN8oGIVG3>Kb9A\;<4`K\JE
<EI`WJ\_cZn6fA4Y\QXkULOph[=C4bY[QUm6cHE:19]d6Q=bE^a<VQO8<W@GLkfQ
S1qSOb^Fjf2]0c@2B_SOe9Af;nXTDmAF7Tao\cmN=oF4boe?g\9lk?ceV]@q4olS
f68[okakTlMi1>nF[5Xab_CNZU_ZMg6=49><l9fmPcGKX=BQ8:BVqJ^H7lPa02:E
:;89G^o2]iIMA^]9PmkkXQ@;<\7`Y1S[;DP[d;^Bo\;VCqT`18ILYPc@WA9];M_d
`G<6BUT6Gd`l]8AQ0FFJZ1BWJ<52ngcYd3EGkOp^cBm2;QI=J=<;U_T1Rd^cCd4C
\\_6R\N?IV3Be]_3JVoWel1j28FCbkEqoX;aLI8oNI=jn[];:OeA[0jT1S`gLbGF
:iZ=;9UaEfWgK3CG@?Bbf7<[W?;iqEaG0hMPYMXT<eZmE<cK]jH5eQ?Tm6JCb01B
;fH9h_VnE4<\C68UIN0[Hq0Fb2VV[NIJOJIf1@A<LO>bPnSiY]gm;MY`BfNFOFGQ
3^=<Z7`Jp`\JWfg`j@1i]RHoS`^g196NK:cZZ2@_AbDDn9j_BUZ6N\BB6QVFWY<J
_@J`lRaWKOYN^\WjcW8GgWe2i@SHD=Q6kO>j<pQ2U=f7QPj42G7j9FBV4`f_NEg]
7>BDp1P>iGN>lh^EI;gUBITaRSBUGf3<BEoQb=6iHNU@1j7CDjQY^]ZjW7dl5]lm
FTT8eiT7Dceo>qBL1m6WhSQnD\AZB5:i6^LaS:[>LIaM^boGeZ0Qn9STOIU;d:A9
SGI47f>YUnLbHW74mJgaC0XFhb:;^CjVBeXTU\2ZUKpZiDi9[7gKTAb\cHoeSXgb
AqeITHLLk]Nd:\:F>kCnFl_4i>b@NG:Um5_YAGIeb2D:hibKUK51dMQY\D6<RII^
^W4gC`4VJ]dA_O3X0EXlVD<MPUH0VVq=g1@Y=^JD]ZO^K=51]@:3aqOOELe=kW6T
=TiL7W4P8;]I=i^:GNXmS]h^mJ6Vbf=A@@1\hAk`ke1g\UVVGbHCI=[TfeE1g]Uf
=TiL7W4P8;]I=i^:GNXmS]h^^OE2`q;A4i@JZP?LeKo1CbV_SE[K[ZFcTNDSp?gm
IFAjj8C^UTa[?YMEEYQYo8oWU>Q[>d<Pl7T^ca:Q\G?3dK9mfWO5>Nf`YGmV0Imn
KXLL^`d^nTa[?YMEEYQYo8oWU>Q[>d<7H2=bq`6BfPahG\<;BlgYIaS6noQphiTO
XD=B<?Y6o2Qgga??M9`h63Sfb<dCOFdn[]<d_`J^NnaMkfGB9jMAL^I;Ng^O9Gde
;aR17QYEo2Qgga??M9`h63Sfb<dCOF^WX16pgLJP3`A3`VL1L\gATe0aQ;89OX[J
n@>4nYR:ZCb5OTUQ0nCfeBE:A<7Aqgg[jXfiXEVe3]6kA\AaKVgp<>dmJ?9Z[oDU
JKm33fGPS=hJO3>JRKn<XBfChd`ERh[nebnE32XLS2gOVfK4X[0V<[YiQ6q]4]Ub
M\5;FHNRj?U93hQBjoRO@VH:M@CW2Wld;5nl6cNDeJMj^ZlHQ`dk6p4ZS=RU@?;Y
;BPJUAHd=3H7jM4kb`GWI7;c^MkZlQSP<CI8lT81lo=GK;oXXDoQOMp2=6m_^@_O
D;]PL`O9^VDOG4ETbdgFFe@5lbD3;N\hiWliPZh1kSHRYC@mbqfH68;N1AcW4;\h
2U_;ejmSDPQ[oMXEjd^YGOLoF_>d2_7IBQ8;OG`hjq93lCfaRYR8I=4>nhh_Fen@
lfeLPRJjPoP6UYPTeJ[YbV?GKogWb6oWYp^8R@J;b^ae3mK89EBXT[lo8dT]X_1Y
C`7\Q8mV`2n@`aX6W<Qc@n8ZDIT]C3cZcF^HCd:IIlJD]<8JaqiKLe6;od4^1Ei^
J?PHMW_?N;`BAAEWRJiI85nAe16HNhTM>5_:Gqa[`\ioT<Nn[a_JeOQ3lYLBQZoZ
IUQnQ9:ZoQOTAbZQE63o0mOh]AaQmODFFic_Z6kKh>0I0IB\`E:GjAB_Y@4f25?V
;0_Cp6FOFM>VW88I5^_F[mAFnWmRnM\;6kc><[`^2WMFUK6MgMS7\XcET8UDe;]V
<>n[c=bgbST`VQTg9a9eq3MZZ1U_:XNHAf`]Q5:ZGqQ1T2_kl@=cMCQYDiQGdlna
KZC\`>[29HbXBiD3LkRAjE]RV9DJ4;ZeHB:PiA=P:XPJPP0@;]H46RKaeD39cH]h
3E^8Sk0M`=3Xab;HGbe`[i][qPjVT\P=dJ];mYjRa5Ad\U1^JUjl[m6gG<8]^NmT
6qN91k3_i2iSeClkYIk]L9nYFCBNQ8WSN@2O7nTE5A`dGn0JHYbMCTO=9ccd<I[U
Lo;bkWb9\:OYe0e6clV<ccq3=RJ>gAEPd3d`YbhZIXO45hRk?qQ5C[aQidUWXcO:
DX^[`9i`oT3OZX\5:B5O@O<UCdS@iEXYFCkZ[6_U1^mZWRf_?cL[94OdZ3995e8]
<lIWHXMZJ7lfQ6X5nQC6CU>^d5a=UQqK58mSa;<_Noach614<\P2Ml:]i8JLPj15
aG^fClDAJ_P0UY@9j7ZJ916QH0\dfNBYT6HVo>i7ZN5098:p<<B]g[`\Ni_20aJ7
3P>HV7q9[heEIkJ3jINUc6XdL2jbEkkDPfZBPKLVP6[4>9MlClJa[:fXPjS<nY8f
BEihFPR?XNm;gl<NVW?N17hAA5OF>Z@WOn;EPH]FGKfY`Db;X6Upmh52Y0h53nGd
<8Kiml_j[A?PE2NTK<JAd5J]^E]G<2`=<gK]LeC>3M?fROO=oo2N6hoToE5cbd=A
Jd_[pHg_n9UHi=iOCm\d8B0][>[pW=0jYP=M;XSMHmJZLel0h3>o_oX4OoM_7_Dm
U:f42J\OVRE[9@FH=nkCWmQBG4l;jdk:W1^h1VVS3OG_EP:IV2F0UoDRScMZ4WV^
VQhRCJhpind5mF3Q`4FS=IIYNOjB=PY07oFXBY<<QH]qBAK4i19o<L\4[@\TBPam
gJ2`RAli0CVlhIf5;5O^KXhb[CW61S?cl72BU0O[j5?l:hV^b;54?B];L[4ZDYqG
H`4:ai>_m_1f1>g8[ZcES1$
`endprotected
endmodule // module vusb_hs_portctrl

