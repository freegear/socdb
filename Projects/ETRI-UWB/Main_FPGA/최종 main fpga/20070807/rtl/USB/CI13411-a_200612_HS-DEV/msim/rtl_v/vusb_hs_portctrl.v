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

    MTI!#!_D1G{W5+UQsdH-7nJ,JxOp<1HXn27?J[Ci71FB!nKNB,e{|D=?2p;o1G]i;i<m?VQaDr\v
    7^+-Q1BQVDXlJN*~Z{P~IG^77#'Q&j,Z}!*5Oe@2D2$Rz?=a7}3zI_7r2vDC#ga<Tp^m$]si_e$U
    J[Wl-<K=nIrCC>epKmTa;Q;oaBGmCTYzT_=kJjGIH,xxxwepYmuR;IOv<+UXC\EEx_!Uu;*@ss,Q
    ZrDkzExQGWH7WnUe~R^E}sC!Q_'Y-7LZN7DjJH$sn%/'V/^Hv]O7RK*mDC72CwCw-V=kUzN>$rIB
    ~CDIQW}3AC7o'k>J],~Bp2]EUpzYBj]I-R[B~BIeO1u#U]D}|'I$@o5C@[[[xEEiG5x?<r3W_c\Z
    Dk?pBpw_~XH$3p}mY1Pe<>A^[7#(,vV\5XI^c-YzYO#X<\R!{*GpZv^<CawK~?ea2WeR>s$+a5!a
    m_'J,W]n5(f=vZ,],oUqvAJw7j'~E3RuuVo3Z[n<AXT~nY-es*+D#<QsCa1,[z\$,Ux+^m7U-sov
    =nm<UQ'WGqo#RpI]',E_;ojTH7.7[KI7'W@vEB}*#Ta=E{TqApxVb-Qz2sjCR>rsAOZ;}4Fx~A@E
    >'vw[QJCeo[~h7v,me$*<QBs,uYY3h#n;TBn+Vo'UUI1Kw\TIkprD*1!m7_@Q7_uVXml1U>olZG<
    rws+JTm\oz\5k>[m1GlRw*";r[DAsRe#jmRreO!,jns-TsQsK*K$oi^T<2xY*J;>5#l~vrDrA'IX
    *mu[v_;He@\CjrOZ$YsOKp}wGo?Y3>eIuBWSvaYX7j_}X}KsYZ>_-}*+u,Q!;$oV#+]~lj2!Q3Iz
    *w,K;IYor<C<eao=2>ZK+=[x17,!lG1BrQ=O-E*$v<jBDeR{]oxH?'z7=tW1am?,Z7l1pawR#\4G
    $@Qzn[1@HQG"wH'\OW<\^>*w}p3xH*arI;u@'sOU65eO7}2vCH*>_v@,JAa>raCm!]?<zRaX>\AK
    un9jRQJwvezkoh}WEJJGuaO7<rkCBp9\H+_aQR7n$W,(}#<GZ{@kyj5K\#QGE{$+u7ZXrK7v,#R*
    Z<TJuG;'Y[=,!i]!-k7TB4'l*D_$jZ/Fdco+_Q@H^#H{=;kQ#l6{zmuQn!*~R__-w52A{Os37Gz)
    ,53$UElUn*A?x7]zADjiTCiI1{CUiwFRG3jTE^?ojQ5(*^wW{D^-_[Ar3pme><WV+<lss+J[2Vr2
    AR?nrajAV=l\~U-!,!Vo\D_*VwQn1+KReA,T^uAZE-!Edp2!nB7K3?QbU<-Vk9aC#vzVT{r_u{x#
    -^wG@I$3o,aHm+u*IC~>ox-,JCC#X@jrk+rjW'{anB;a>nv?-7Bp<X=DJuIe>GC[OU!{I#sH5+?'
    !]7{@}{w1uz*A~Y5jz$Ie\R?$mIT-m2'<@Kx_om5vuH-mw8Z1'WCV#*1W!nqVV~R,H]^[1p'[e;<
    3-B,Z,-<vwQeF?Qm[V?5r{5lQ_HzYl1XjRR}kN}WUZ652G1^Zj~Bb_raTiDa$7JC<lzA'?-jpE}-
    EpaOI#5m'KAuTz\kr7ZskJ5DJXVXX!a5wa(Fhwn{7T+xs*H>A}~'1qzTDrh]U!?wGD'nvBz#5op%
    nTw^G<_l1?ZDneCX^z-?'xoXI5-}oTD^lK\[WU}AABQabBe'5#=D3>5r;4xsm@KRlsj>\[97a<^#
    IOB"j<n_6+IHxQZwBIzCHA^_lHe~}{$5[A'CrwXA>Pd$I1[zU]wVzr!1GxoxK\R}a+I,W$=R@r;w
    {}17ztlEO-}1Q=Vh'nJ]$j,i.7-^l#}v,{ARpVEIu8*x@\'\Q^hx'";j^?O{Gx-x{K|+^7lk$Du=
    ~m,I+U;'e>oOsOYfijUX]s;C[\e'Slm$pezID>}-\'zUvr;<pJDum~{s\I@v-o;vBi[k$I&N~$+p
    YZT-OzT<k'D[V*\U'k*Au,Kxv>{@o$?I}e=j>77~,a[{;$2oKns]'k-=(w{p7}R**LOsK?=,XWG~
    l,JQGCCQpx:[5=[)[>2=E$M02e@HSW<ErvnBoElwv[@X7.r+v,r~JBBiGJ$Z-[s@2[Z5VKg5VwW0
    #_O_:'[n$wo~;}RD7B{EDB?V\5{xW^7wURK;o^__~u1k?DY[Z\]DX|CRIaIH2Yv]AebTo**^1!uB
    !x@oYsRO@*jWQDva}@wu\x3eW<J4~.\eO[s21?#X\1U-K-mYTA!EK#=5!5C'-\Xn3At%m_2]O3R@
    kj{mw5]~IekDo_7Q!-G$<T1wz?{TTeKAZp<O)M2\}2=U~V-Gr,zWH#Ve]DrB>=?[+;nBxU^jkDkO
    wwu*->_BTj\2[GIG'>0S<O$aYJRUVuWWt\'$j]1{e=ksBrI5XvUaH1'ns53Jw;COT+rV^=lTEHT]
    YHEe!1n++z?1KEizTjhu<uD#*'3W[jm1_]E3z-Ae$wn1aH<b"%:*mT@9Q$DBCWUa1eN?HZ}h3Omu
    1VRBa^A'_VO@/l,a,@5KA#XBXi[lHtJ_^$<$U\Xn1r1e2T=u,k*;O\,QUKIwCm>-wG3HBW,ja-EE
    QnC$nT-V]ur1#\_'$1b$W}sAxYZ#\OG<\x@$][7U5X+nsYU^X5}eW1nOmRo:I[-AOQ]khu+;AI]<
    _1<H3l<T#~^,s0eYWZ?RRZmE,#KAvxV_w5LH]rxgG2B>![]?'\GO[T5_Eun]2w-uq[Z3]^Sa|*?~
    p8^{>G*QBnjvG$Zj5i^\U@[wTD#L7T~no7es}[Y]TH}VEn^7_@x^|25o*;<O}]7]_GankA\xk^p-
    ^Vi+AIQ]rXvKnxHQ2Iv,=7_)ksnjz~l],OG~,A$WUT2r{+_#CV!l"KCmTvmjvD7I2!wHZA<Urj[r
    ^}[erU*U*+Oxl;$2X_j,@e7H~hVJ3rs6U<{Xokn=+nO[LGzZ>e}z*/BuOH<\ezgroXz^Gm{>QE;]
    vAr#T]3rOuoHC?{I\$w[xm-]HE^kVCQ-9?a5D$e[<E@7Iz@Yplnmul5z<Ge*^ynA=Ex<J}CUO\t*
    w@u(rH5X1W;,KC{AspUX[JTv7{HD65J5u4#+T!U]-$VV!UE^?IC?z^g?hJTX[OTw*Q*;V,2m5Q\_
    X5W>Gm,vnOsT*rwvI0iswnU[$YjVRw>55JOpl2oHn]{]Ks8x,QY$K=n]jnviB]iaXXuwToW~5~>p
    [m1MV1~Bq_^3k[#o?[q^[p-i1KQ}[o]10+<DmRfCe,}Z*}p(:e*W#Pe-Hrl2+5lCukC2$}W*n''C
    wpr*sCD.zC^O:[w[*'Q*w:!+@#e_{}@\^}OVo7A[+nKl<m\3w-sHpIp_awY*@HY,R~*kxk?rsvRr
    iR/Z'\>77n><^}uH1aY!eMP[Ko$Arzw!_*,^?'=,=5a?juaz]$}GB<vC7>T!e;]$sJ@*-7_V}'+Q
    KImaz3R~qUHTKW^^+l!wV.D$$EJI~$!5w#{\~El5E!S3jG7>7oIvmuJIm=Jm\[^=,!C+\W<^3pA?
    n7=R<-'<$$1uY>WA73[Z^JZu}Wae^=ev$}ASuG<xB}ZI=~CHj?r]#X~u@rJ*,SejepArIT8ET-$v
    _U{v2Dw<5{Q[][>z;p^m7DDp2RB],uTDXAn5?EG{AB,Qr{Rw+OjRZ5GI}TI{a}=VH1u+TUmw$R1I
    !DJO**?v6gvEoYTT;KrGkr[Voij?m;}1+]-1'7zxYHk5pe~]U?]WRTQC,v,[@{alEO#n*HiY^u@L
    ;Y;z=^k~wr<-3EVXU+xEGDQ>'7YnioZQcN'X<lecS#EC70-RQk8gq_vra^skw+r<Qk^'5BVW3rAl
    p.^oCKhT<\=S"l?2-3^TZ{vv?6faDrT,a52]i=>{}jDo23zkHGk$;,x,+lOuQJRq\*?JTzH*D,eJ
    g)5,T]^pZ1]1HVYO!rjoUlG<+z_YRDH}?-j}JB}a*z}ZlZZUzZ$IK\OX\;'H\p\IxUmY]iV!uJkA
    ~@5ADG5pz[jr+u|;[=~J}}#ZX}~^5O{?a^^mRI5i]3pH'i}*_{nzT+;_H@AQ~X-vBEkHXR;KXJH?
    {2!zp,}RHeBUl>!V3_BMKwr!-{~[{{T$>j}}x>o[,#=GX=Q,TrJjsowGj#OnIm75>EC'x}5pRk^=
    fx^E>{]Y+~I@-cQU'U[e{H#>Y<u^5xxnO+O>{!'w^7HUE!uAv-CrpW|{YevEAW{#nGo1U3>sB-[K
    Y'T(]%zj#5Y+A_rm,G\1}wsk+=3HJTaA5^}m]B,si5lV{@wY,D,3r-i-xewEAWv^Ox@>EUQj[p[B
    U*-vipkqrWa^[U1*=uODDwe>wwp{eJO5OE}<AAp#pDe-5r!lThnX-=)Y,>KTU1HHGs']@@5{+xBY
    [{eQ#\2>*jDEPC5mJ@R\2qj#<7;T\^}DW@2xzjjQT-aDWkmY{lC-RiY;]KaQla}@{JXpm#2+;KY<
    ,37zi?\zD;e*H@B,mrY,$QC2x*@{T3A[1Qk1p,U=>={v+Rvw=Q4=j@QB\U{aeK@Co[*eT5j<,*>x
    Pj~;C"+Ua*;'OV!\@aR'AaliZrm}l{WR$5+r@vX7Qp[{$2tj^@*f<e>[@,+{tYOp,Oe2{J<G2R^7
    EQ123Q]zHovOvK]BUUQ[{ol?Ka$*Q_4r=A*F-z#C5]7vOXaUiD1$*=Ak=Z;Crp}p#wQDkl[G:C7,
    !}C[X1X5-R}eIJspOHekT]uW>Is=72p!$K-Hke77AlZ$I@w<C9HLYe^IL1m<l{R}v?*H~{=1j}}7
    {l=7mz=Umr2\wXD~^?XBQ3EGn~\}r}~npR1-!g+-TY5jlWXo}D7pjAV<H?<[a?($511IDAJzBA@Q
    <pEv<->Kp7R*wW3O!m;2'$ooVaus+7[sBvQ@UQ}9G-1DwXC5GVlvQVw7d*~^*'~xswUooYU;mZa=
    I_C1W]G*~O!{-\i*3)#<X+7mo[PpiWl{5vu>[1G#O1GvKXuA7kx!vs>kN4rwoTb2-anxBW2_aApO
    zp[}O<~O}+kco~]O#roEmGYj*[m!B'B{7;_~']Ep>p@RR-zi[!OV[_IjCa]TeQ$j^&XQG'pK@pZ[
    \+kenvSs}Dl[WeE+EawZs3lE]Wm^v^VQO$KtK5*wFq]o}n}5m1HX{_Y[~?H+}XY\]ExlvvJ*sOCK
    e}zVKwqinaKO+n=1[u}oEE[pz7E5n,sOA@2R1]1-vOE}BwQEle*>jlo*gQnHE+]1jpiWOj*O$bZ]
    JH'>mj>A~1?q$IwoIA-wo5*nC]=wvEwjHQCKkHmaB\mzWweJmGnG3p2v}xJ]xTVowIn?Aj?uX*Tx
    l{!+5T$o3vV@}^_5*5e2!Yn5DiBGx[z1~AIu}2$kUn+@[Y3z*{}$zUTY-IQ3[D@+Ba}Y_=$EyzUT
    *CQ+3iQZ,->2p_=$e#Q_\D5Hv_u\G$'XEOo'T=~+^LxCQ!k5*]HD5_7K7oRk7-CiK=H*WCZYmuan
    RJ>EiGk+j-OJaQ\!JnlJO^<A@Tuo1$^Cw}saV~1u{>~v_{}wT\p525THpiJ>s],CJklnZ>YZ-amp
    sA3e}i^Wjl;xT=[;Gn*m5*Q3;wMv;Z1>__\#YY-<aYn3'$E2z<xMK-Cm67>_vlXVVrAaXX[D<~na
    ZVx]}>*Hm{Lw6UH7YX=Qxf'zzXc35+?VT^1rwIKOXDjVzHp*Or?joB'THW[+<j}{aC~;HT3yV>HI
    L'l1U{aYs#$AV!j}[Pj+jnHx1G\=3{/qnIC7K_usW}5aC\*zv>@^IKW1@C~G\Ul@X{Ee\z>7a]{+
    pW^,EJ2A^oIuI\Ro6AjX'/YX<rTxnp?lGs_z]uhNUIH,Cn7EoB#DaDlEe;-,I=,*OC>]5,mZ7?Ev
    }x?_}U$m~Q*#^ae1kROlws{_x?U{vLVD1DSOGe=i+__*XexBKRHvH5>_2D$=vKTu*V2Q-vA*2+mS
    '#_}II'<_GEZ1WKX;=~j_]EXZlAIf~GO@VO[}mzeWrmO^B;!E5\w-G7V@V<ajo2vUUXTZoYVB8-}
    ,RkxEl+as,u\ke1_1XHQuUKG1Z$<\=(OTQOpnGkt!+,24}]Vk|nR^CX^2w>{om5CH3W\,BoDU*jT
    E-fV!Ju$Q+\-v<HaADeyq};e$l$DH5<A#KOu7*@Y=G+pm[-ZrA*sB,>j*_\*TTz<o3{*>DrFw'1$
    }V[{-oJ-*l1ZDwRR7i]T1(*mEi&Ze5I0yi},^6''wBGT@+uQY}@==pKV_up-xX#_lY[q5kKW><]w
    k<{;Now@_R^5T^_xVCl'K2\*X+Q~!eu3-IOwK,Do]_KXJ)2lvHC[-4J71z7n\Da&]+o#%1_<]C_=
    Y<eGDB#[Rp|_$-'1?{OD2v{IlsZQEXl=~~Tzn^HY-B2YrxJGe3E~-ae'J\kzUs{EsjpOaHDDI>p;
    -pY$jEjF>eZnI$JUAEiWlHwJB[+3Q]a$C~\="_J=[x+3BpKAj+,7U>\v!ZUV-J>CX0M?_Orz1JZX
    U~ez5n$z_{HYY7X^-3DA\s+_$<^,+rWZBvUo!d}z2{m[~*DKG\@zm~-[Yp'IvBYQ+$oHrWm{Q#sC
    '-*!uAqUw*#@zB?vi_ZpTGU$WZ7XVZC+$C?+{5;z-T'[K2Jv:7#Z?BAj]?O_ij;V_(}Xw==]T{\1
    1oGf5T-KIj?J!>>V{rpE]>{^]}R?}YU1)#}HZ(#]}#uz_{AUx*n[~V@E{KexwUVEjVaH$-K>Bs!]
    ?Ov?-Ex@$@Q+=YOr\e{Re?{IHz'xT{1immzFv~eU7rHR$x]n,}s;m5H2xIOs7l=5CC\5K$?C0IHH
    *?n*+,s\D6OTlo7A='_!}=IejJ-1U;xVriJv[eI~j1B+K\.dszn'JH+VeK!3zp!,KX}J'O[2*'$B
    ,%5J,RA{{$1$X[oo^o-CRWH{5R+[!sXw5Z[Gje*a'VDQoV#TVTEClaJClIjZH^}J!oA_vWR$D]]#
    ~OE>mn51v_H<V_7<A~LGBT~wa3=e$lWxH1>%2=3J$-*_^X5@n7#=&M$+WrxYiTa1ax,Y2>?53AD3
    $Yu[1zv<DmfkjW\e==\ewzxBuQRRKICT=]u#^pHl{]X>wQl-tO}I^H<wj-XY@oU]**V5>iU*Q$v$
    ]=!V_<[7[~}X_e$p?r[kH@pG!W(lTY#GQA?x#T1_J;2KR[Vl&0O7DaA5\Oj"[7WI-A!+jW;xJt0z
    pm*OXR$V1'-p[7'A7{rUz'vO!lZn$<,O5~,4YD{G{p37ljl^~DZ>p[;++IHp=*-^CYzJrjUs~wZ'
    DEVv~+A~oH!<'e2z!xe}zJ}$e#VG,rHJ9&kQ}UO2o\B'Kuqmx5$#C=@kGK]om$s!'Bjx5J?wT~X#
    OZ[D+KCxwTs*2m]VW's1uj,]GQ}EU-Kv;<QFO}<@<I]3a[sR5IRK]$ejt@vXYB]xV#^E!QsHw2Aj
    {xu1'[UX3JO+T&y~<XJn\^?KAmza}G[rHZ34uQI~KY!CpHv@/5BJp%aUm^\J5Gu1+Cvv$?2xA@[[
    2~^>>Gb*!b^'5m0K=nw^H5J#,_T&jexuGnE',2G*vWlm{Y3RjIKBD-^e~oAIYHv<Ll\G',o=VN~l
    12(5DHB\*eXa\H{D!pK_alz;jT}$mrT?j+sK5}I=UxZzjEop+2IQJQx5[a*rr]B|IhCKY#oJRx7K
    A_aEx*KAK*^ZXULql>2rwEaAp!Gi'^!@{H~;in<AF$[T}12KZJpw$3_r{C+pOp]GTTUXG2DTBl.Z
    };^D=Z;5!w,%BZ>^e=TuR>mEHEpUlO]7]HaH-B*XH=~nz+EnuHpnQ[E-Cw2-IuC^$[rZ)1/,D5z~
    Yw7~7K*OIrkrwOsiz\aHCeOBTCD11_3'YY=$nEQm_^=Zv-I75<#X-jH\D,GW1Z=wr-#3}!I[ie1s
    l]ldxlU{]eZkI}CZKapDO$RKWwa~<B*e#YG@+-EKw]<>wosx_71jY7j@]JXuOUH$k{[Y=wW!rs'v
    ;^~+=GinA1UnjV3#TXrp'i;pExDQ;>uI@Y1*nAW5r{KJ5YOpHrGF~<jE6Oa,pz_u2e2xVvXlRWYv
    p_j3z@s'mh6=i^#ZYm,*=DHIAVpz+I'Y2AOrUHx{>o>ZznQYEA@\DTn+xlTG$T++OvZZ$T;?Qa{Z
    ,~+Y[+w^Y5~<Bv\w{=uQ[1jTe+pEmW@Q5DR1GCHHa$jpFJDC2Zx>zNG@~ZAjJ$Q*5r+-lKM_?eY*
    *lj[Y5~nxpQVZ]K]?w?cm[^_JjB''k5KHn],-]p+VBV]o2,1Qo,sIpll<1Dr}l*zK-YBv7+A,5es
    2C1_RvGsV[TlrY~X5&o]2KOOz3?s{[VAp\nl!n^Qz-v{\na^#aT1<J~,jrJ_AmQ=YlYX]RRzQU|1
    Q*-a^V{!]Hk<or^r7=aCKC;$O5V7,$Xwz\vrAz'3,$7sx,#W8#VJ[IozsNK>;B]=O{n+jkm<]-~[
    Te]$E-zw=+%$4[33Cj>aZ'p_{-5,lnEUlKO<o7>j#R*<p1W{}r+Z3w+luI+3]iX-$a>~a5!RxCxI
    pz<x}eUaCV{Daj~KKflu*=SIk,1~sp>;+K$_*z}lUemj&^n'p's2KClVDpUwn-T*z}z1uSlp~v'g
    ;QXs1TK@^<In+5Zo]UI'oQ*J_jp$z,*]H[YwL^]U=+1QZ5=TDP7[1Y+r72ZxO!^^]Qv=T}'uDe3-
    uCK+}ox7}<vwsm5E7@4YZuE]X7!*R$+3l+l8uwC]j3;w+^%@=<Y[~~u>Il~lZ}!~HV[YR*![3$av
    ;,r3pO+?aBpVi>RPQ;K#>{[i[lsCrDmVk^~sT^>+!UG5_ompm[^V^+5G8Y#+2lQ\w^oT~\,Voz]x
    [<5(oxO5nE-WB;j}}GzI]Tp]C;lpF1!uk_AlKv\}IpXBuvxJV?{,3Ck-3E=xoC!Ke)3,oU?^D\,[
    -j_I~nkwB\li*+dUQD+@>JH}^\+17XG~AO2e1km3>C1N!IUk*RU7pv7n?1VwzV\isJZ3mwY<aE=U
    v,o}'>~*\J[HpUcAG}>SWz_TnoWu-{zz3_\^z{@lLl!KV1Sp]OZVQUC{_H7i<'Iw_wzX1XoEE!-'
    I1G79pu!=7wGxGjW\Y>oJTvcEa;pR=HH]kU+g^[CZ<AxaY'n2$\-FCi_3)uRnHBi3@~$C,[b*-;k
    TH='~[XQA+WQv[#1ujI;U*5<G]<{=p3O5>z}+O!aYXa1[v-UQ2B3IG~k>]a=.Ya+QZss7BIK*,{;
    *j$5{<{>!!n2J$Y\$DN7[neJ>X'\TWmex'[QoeV{UrH$=xn<C7eZ*Vs/VG7o;n5!r[Yj}Ol78IYJ
    R6_%Dnx$)Jsp@+_IW?ODIxWn,I?OeEOH7J1!$R{$ROQ_j^z[K+V*X^*VXuOVxs1aDMkE@AjW2$K+
    uDRa$Z^,j7Cij]eoTr@wZEEa]{oUYO$Zm@E{r'z$^@1|I>X>Xsu>yrHvT*TDvXsko<D#kaX=\I'e
    3,*v{:UCv-K5~VH,rZvYOWeF#]5@luZj5vKRO"vm~>xx@^63U@aQ;-W[s+XQ>*,w7?oL8Gma^BAE
    $\<T?EB*u_~wX^HZZ)9n7Z'Z{wUsiUwQZC#1*v5r;5zKV$,uDa_F=p}'7wo{g}3]$R#HWOrOJmDs
    CQ>e}v{u<z{VK5s\z{*WvU]x$EpY'p$e~BJX}owm]?RnVXHXY[-B^uA5u,n<,#pwp\DTZ1xx-E=*
    1~$Ax]DURE3D~,Q_ueVX^DSw{77^mUHHC$Rs#Gx+QHzV5>>J_~C.Dn+o=AvV9t5^\3$uEWtkS\'n
    vUI$p][lr~sVs~BOxlQo-WeB3pnQe7@RH9oSI{+<Rdm55;G#}D>AnC^!vz@Gr]kVBY'=I[<jnCh\
    _+sTGGsyn=z#\sZ{B2nq,$k>Vn7HaxiYn}<,7XOVDi_K)qAX1B}5<xQ=V![mu_T$zxxl2s/kx;a~
    oVC$;ZW,AA^e^_[CwaRG;v'r!Xagr]7?I-H*9>w-xjTTH}W}ejzuA$k~e^>*TvSji-'s5#up3<TR
    Dl$,ww,&aVsJ;YQu}Z1Zl*^K\zuUDJ!GAI1Cu^E[AvK{!U~'psC-io~KOEx}OxWO:rCU=7mx?'}=
    }rTeZUjVj5G{?$%3ImTSk5]^*#Z5";X,IB@52Zh7zVoIU->#_=ep6ET3Q+5kQ^QW{]!1*E[B[xE_
    5_Q*IzlVmD7B;J5ow5,K=qVjWjkHxG*0>j}G7Bv]|*K^;N[XY,[?msu5D!-[Kb/nv!YU&)1WYCj#
    Tsm+~g|qA=?I7HDT1;$WCk+=E!KjfH{_oL^>;!m<}YD-jXYxn7l@-KbYBV?CKRI[TRJ5Ww!H{5][
    #nsG2z5Je_[^Y<1r'JE]V??ppB3=}HTd)XvQ[^?|D3*oH]B#EiAA[vKJ~G*\;{v}[C>j4ll>[r#+
    z7H2jalCp?.10oD^aI(oZE',{>EvDIvHl7jPLU+w?|'S\<\{UN]^#32Y?W_lm#A]U1Pj~vkoHoAk
    X\DG'5uGY?lB@[x!5w}FTz@x#,>_eu[p']as,IY7115+Jnj[K-e3$vYHQ\'x<j>A}mQI*i{aPW[{
    Z8keWzZD@GS~$K,cH7'2WaTamn\G~G;pH7u38p7},rI{B[CH$+UOo,m_!$*+BGY?HDkOx}z#EL6v
    <TH'j<OouVUW5_1Z*-vNXXDA'awDu[EnC<aa'1V#I5l2s~aW^,k[vUG_#seVRX3[~w3H=9sVvk~=
    GO]z;lr$~epU'+}RV2kB;[el<pJ-}rK{*?B$DK+B]Jiws^jm$ve5!m]GVp2osiP&-V\^H7pp}]mC
    }CinJ+-@ET2CGY@'Ve^l^iAOGVrvQ*jHGies<p$U|#sOH7Y[R~AIQozl#~Ile@qJzC,VD<{_DR?q
    mQ!u,_BBe@l>aa-jV]<^~1oJHCCz1u\W3z#QYoYHqlTJXXY1w7;C77Xx@IsQ1e3Uz&x}l+z1oayx
    ?HZsr;V^Ejv[={osZ\$O3TUD+OohU=Zj]>-'?'ijWDJ}6*YGHwO3DOejI*+G*lVjaCj+G!o\D_[T
    Ij!osHoC+CC^+9>r>zHBA$_Ezswj+YpH@<!\x$5KH!D{GGns!E,$sUJ5W7xBR^IJ\*@,zr$vRUwe
    @;KX;U^^k]j!IWXXTBe}-+Y:wDTJTp!1suGzEnDxaoZBYQh$nOpTxG5oXDwuon_5$2;N_','.vO=
    =X_B^pe{z1Omj]*H]o[WEI<';iv=>K,-{5f@xI<x]k'QlQJ~hJ$1?-^<\V+COrDOYuY]$eKA>ovB
    k?\!O&^[vwpo*COvRox>YiX1!GYWHJr^XAGeYozzQ~?I>'nYnm}!SNB"+75;>|=u3IxaRo2*nj-5
    vZjExn9xO\TC-];,oKoH[5]a<XK}GAJeADspru#pCi~X<51?ooXG?Q$Y>Ja127a5(zvl^G[Kez!}
    Df$olQGCD{iRT;n,'-1Go2H+x@zQC3=#op^zA$IQn1B#G$I12T='xB'>Zs?<Dk2{Cx_i\-1UQEOG
    H>,?KI~U17E-eGOm@v<G@]_,RUBjs[UR}W'>CD<hz3Q@=X{]H7Gr_Ym>1]v2O1lCu-X~ReT5BQQl
    IlZA^k3ZQli's;{o@Tu3#$G3*nGAIvo3\m7K<wA1'?$V>H!T*~'H5R;kp4YBK_e'Uj!<-*=vIzWY
    BT[$<JHQ-a!ImWhEox7l2j@eu~n[aJYL~zV$=EsUvWu#XQri@]B'?]{O)YxVo!XGukY+j?Q=[J=B
    =97O-?+*<\iap]L<lQ==Gs{ZUs-v3JZ=YHr?8oSa_@TCX'isO?]T'np<TQI=a[YO7HTO_1n$^^lx
    !vB#+Js[?z7^CnmsY=oDUW}T<}UQa}}E1{-;]k~]sp+$kn_sx@-[a_\Ns^I}G@C@Uo]K_;12V_+]
    )ka-GrluOuo*T5VQia}@@z]K!Yx3G!eOavoD}ZTuCz~2j[!r2\-$[>X+GBU\e1@K_iA!>@Xr!lA-
    K+9;>Zw7n-GuOOV7UZOlw2wwU]2$[Z-+Ur^Ae@'=xxZCsI{{Dj2QKT+c2}QJ!*zvW]k1Krpi9u7*
    ii7C75DY1[!wz?\n]X\>'G<'nhC=a~KxQKK'<!_;;zan=UuHo^Q!=K?TrQ#7OIs--+2-Vo2\m=Yy
    (s1$QD@J;-jRZ&XORD'e,=EE[weOUp_u*od][H5nIB-2Qoojm=*.!<j?KDTmF6>5@\-{}>V~O}\^
    VxGZolJT_Y+_UIUsz1<[e]su}RwGr<~T-ZI2o-~VaHBZTx\Y}T:Cw~XBU-Qale_ml^K1;jro7UU[
    -~{U7IOap$o3vXQ!CBU!}@;=OnsC~oj|/]kjCsTo]x>j{V]+_1C,$RUapUxm7>\uE[}[+AIV]QwD
    Gxd#E~p_]YieVT+non<^z5$u5^Zkn\eE2n_5_Em]k!^^w~$[WjxTj1vI~lw#xGu9XrkO1sV!DwaI
    E(6?{]@'kvmoHxZ^vZKK$\53DeGWAT~YJB<j?O!ls,YWx~I7]UmD!K]-xp7=a3Jixv7?x{,<V!BX
    -vr_~Dz_UjaU7UavD>X-IYeJ<}$?T>}=zXX^D{m%[;,l}aVwTwV{^DR[={>1l4cGQpH1aD!1m<OI
    '1D*RXW?]x_~xZn#^Y$:,Yx_p<Ga37#T<R[lV}]uwlsu]l'$+U$lV3^vKvwRG?$,WEVvQQl7HUQZ
    _!vA$^[H\3''OwQroi7I3ORpNkpp#.7'?@Hjuo{U~;U*i]95!C{@-DA.Y?<C>\*]iz!Ww+@T'ijk
    4{Gsj3$=e_^{'*K[sju2-n>~rF*~{emRssxMWQA_P_KoKC]2}RWYTov!Y(Z}e^ANYiRAfl=v$h:G
    >B$zWZ{B#Bz(fY[nO@nZB-O!k]^Cx"zG!#';**n5E[Bkr#*{Kxb>'U+IzloV*_U{^v@=RX]'<W2*
    WJpB?5!oO~!s7*^G8QVKun}Qp\_GIx@Xu$s+}~DG=+TpeJ]z,$eH#<w+p)EI!#RKQWZLDkQ5CY=v
    -TJQ!Y^Ip@KwEap'kz\=9^Hjano$nD<+Xl@v->UUr$D3Uppw\vH<v@a>;^]TB#^$]#a\{XV\OGK5
    GBllQapO$U=IzjsTn@n>A-a@7U-Em(>BEjJ^]n7=@5aH$O^[D=-GeHX^,BOzvwk_1'z}p<A,1^w{
    ,uVEH[1Gsv~'p#kor<3^w-u7sjOjRRAY+1QWU!vs+peW$>2or<z*TX6",R5i:R'-~#GROpYE}JeD
    #rnCpH{UGv3z3_77-:YHOWRGO$z_pwppWBB[HO#a!sr?msR)mGCpQ_D-dD?^<3<EVzez$#<UlUO+
    YH=Rl~,5][oikQOQXI-o5jv!e#x*Qo>UZ]Uv=I\~?oTBwQuwl:TzrWvi{^8nB>Ur[J><svsR[[<^
    Q;ZEs-u[-,{Q^XAX,OJpuWQ=KVl[T_\27XnX'2XV3{r^2J;!n7CR2Q-u-@{^O<Ym,$mYm\7=$rED
    O7ia\JmvkKOjeneu_<2BO-})vQn{~CD\a6SxUz3\Z!r$6\XeG][pk<QeOt*B#][jT<rC+U*]$}X*
    Dv;a*!=s>TTQ$X!<QuIXv#K>;aXx~EhEw+1sR2ef,21k~o!}5BBxF]dTTD[5V[5~YBw@r#lL\lix
    ~{5!i15Ix{;TEnJ{7aTsYWE1@_Ii*e<jYpsW2Daww+\U:Dj1B+v^\>,[C<exG>eTuDtue\HmQ}[A
    Xj;87'[YkIXHo?'O'@2pE_i*f$jzi^X[*?+1#K<3rC5iuVf#5Kl.orG=HaeV+E7RTC5e5mDoR-D<
    seZoWO<GV$\Bu7vk<5?*U5;+]>aZ,{~7V3j\@v=$]YX-J7w\]\k2*vVTXE,X7E1<x*3,]_-_:2[i
    7@EuvE{^l}~;\+}<Zw_2a=AZKZ>p3BU+Ci[T\pWuB12DJzQvn}ZjlRZU#Ze;Wc2xwQw,UCZO>-KH
    wJv\Daxjrifo5J2v>{Z('B\1}I[+[O^^-V*eY*RQJ'-eenl2psW7G_H@#*eaEA-R#GljEHueBe=e
    O}~p/Gozz9<TQ3-[$!}BmjBVJI+,#*y5;pG5jCnH-O+mTjXCB]~}{IvC7J^_I^rVu+R~QYa<*Y]X
    G5U&sD\wwXA+Z>-3xBZpIH=+Z_7Y[nYHE-vki7GYJYUX*L{B\~!Bpw?T'[o{}CaEs#AQr=O^}mKU
    TG}J,X8sv-r<j>K,W1Go+7o5C#~O=Ijv-H+G[*x3*@R<E7}<Eo*d'R@GOlvQOre=]Ipl}3D_Cg~H
    >@PN<Ek]Vr-E]eUj
`endprotected
endmodule // module vusb_hs_portctrl

