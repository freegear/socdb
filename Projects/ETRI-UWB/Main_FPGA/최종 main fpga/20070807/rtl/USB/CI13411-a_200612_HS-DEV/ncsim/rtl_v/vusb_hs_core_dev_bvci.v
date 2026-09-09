/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- Input file was: vusb_hs_core_dev_bvci.vhdl
-- Date Created: Thu Dec 21 22:43:42 2006

*******************************************************************************/


`timescale 1 ns / 1 ns // timescale for following modules

// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_core_dev_bvci.vhdl $                                
//  Author        : $Author: hhsilva $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    Top level of the all-in-one VUSB 2 core.
// 
//    Interfaces:
// 
//       BVCI Target: t_*
//       BVCI Initiator: i_*
//       AMBA Slave: t_*
//       AMBA Master: i_*
//       Interrupt: interrupt
//       PHY Interface: xcvr_*
//       RX buffer dual port memory: rx_buf*
//       TX buffer dual port memory: rx_buf*
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
//  $Date: 2006-10-03 13:51:19 +0100 (Tue, 03 Oct 2006) $                                                                       
//  $Revision: 339 $                                                                   
module vusb_hs_core_dev_bvci (clk,
   rst,
   aux_clk,
   xcvr_clk,
   xcvr_ser_clk,
   test_mode,
   t_cmdack,
   t_cmdval,
   t_address,
   t_be,
   t_cmd,
   t_wdata,
   t_eop,
   t_rspack,
   t_rspval,
   t_rdata,
   t_reop,
   i_cmdack,
   i_cmdval,
   i_address,
   i_be,
   i_cmd,
   i_wdata,
   i_eop,
   i_rspack,
   i_rspval,
   i_rdata,
   i_reop,
   i_typeinfo,
   i_xtra_in,
   i_xtra_out,
   interrupt,
   utmi_reset,
   utmi_xcvrselect,
   utmi_termselect,
   utmi_linestate,
   utmi_opmode,
   utmi_datain,
   utmi_txvalid,
   utmi_txvalidh,
   utmi_txready,
   utmi_dataout,
   utmi_rxvalid,
   utmi_rxvalidh,
   utmi_rxactive,
   utmi_rxerr,
   utmi_dataoe,
   utmi_ddir,
   utmi_databus16_8,
   utmi_pwrctl_suspend,
   utmi_phy_enable,
   ulpi_dir,
   ulpi_stp,
   ulpi_nxt,
   ulpi_tx_data,
   ulpi_tx_data_nxt,
   ulpi_tx_data_oe,
   ulpi_rx_data,
   ulpi_carkit,
   ulpi_pwrctl_suspend,
   ulpi_phy_enable,
   ser_tx_enable_n,
   ser_tx_dat,
   ser_tx_se0,
   ser_rx_rcv,
   ser_rx_dm,
   ser_rx_dp,
   ser_dppullup,
   ser_pwrctl_suspend,
   ser_phy_enable,
   pwrctl_suspend_clr,
   pwrctl_wakeup,
   sess_valid,
   port_ind_ctl,
   rx_buf_addr_a,
   rx_buf_data_wr_a,
   rx_buf_wr_en_a,
   rx_buf_clk_a,
   rx_buf_addr_b,
   rx_buf_rd_en_b,
   rx_buf_data_rd_b,
   rx_buf_clk_b,
   tx_buf_addr_a,
   tx_buf_data_wr_a,
   tx_buf_wr_en_a,
   tx_buf_clk_a,
   tx_buf_addr_b,
   tx_buf_data_rd_b,
   tx_buf_rd_en_b,
   tx_buf_clk_b);

`include "vusb_hs_pkg.v" 		// file containing translation of VHDL package 'vusb_hs_pkg' 


`include "vusb_hs_cfg.v" 		// file containing translation of VHDL package 'vusb_hs_cfg' 

input   clk; //  system clock
input   rst; //  reset input
input   aux_clk; //  connect same as system clock
input   xcvr_clk; //  transciever clock output
input   xcvr_ser_clk; //  60Mhz Reference clock. (can connect to xcvr_clk if it is 60Mhz)
input   test_mode; //  (0) normal mode ; (1) scan test
output   t_cmdack; //  Target command acknowledge
input   t_cmdval; //  Target command valid
input   [8:0] t_address; //  Target address
input   [3:0] t_be; //  Target byte enables
input   [1:0] t_cmd; //  Target command
input   [31:0] t_wdata; //  Target write data
input   t_eop; //  Target end of packet
input   t_rspack; //  Target response acknowledge
output   t_rspval; //  Target response valid
output   [31:0] t_rdata; //  Target response data
output   t_reop; //  Target response end of packet
input   i_cmdack; //  Initiator command acknowledge
output   i_cmdval; //  Initiator command valid
output   [31:0] i_address; //  Initiator address
output   [3:0] i_be; //  Initiator byte enables
output   [1:0] i_cmd; //  Initiator command
output   [31:0] i_wdata; //  Initiator write data
output   i_eop; //  Initiator end of packet
output   i_rspack; //  Initiator response acknowledge
input   i_rspval; //  Initiator response valid
input   [31:0] i_rdata; //  Initiator response data
input   i_reop; //  Initiator response end of packet
output   [BUS_TYPE_INFO_WIDTH - 1:0] i_typeinfo; //  Initiator type (not for general use; leave open)
input   [15:0] i_xtra_in; //  Initiator input spares  (not for general use; connect to logic 0)
output   [15:0] i_xtra_out; //  Initiator output spares (not for general use; leave open)
output   interrupt; //  Interrupt to the processor
output   utmi_reset; //  Reset out to the transciever
output   utmi_xcvrselect; //  Selects FS or HS transciever operation
output   utmi_termselect; //  Selects FS or HS termination
input   [1:0] utmi_linestate; //  Reflects linestate of DP/DM 
output   [1:0] utmi_opmode; //  Selects the transciever operating mode
output   [15:0] utmi_datain; //  16-bit parallel data output to
output   utmi_txvalid; //  Indicates utmi_tx_data_x[7:0] is valid
output   utmi_txvalidh; //  Indicates utmi_tx_data_x[15:8] is valid
input   utmi_txready; //  Indicates transceiver wait state
input   [15:0] utmi_dataout; //  16-bit parallel data input from
input   utmi_rxvalid; //  Indicates utmi_rx_data_x[7:0] is valid
input   utmi_rxvalidh; //  Indicates utmi_rx_data_x[15:8] is valid
input   utmi_rxactive; //  Indicates the transceiver has
input   utmi_rxerr; //  Indicates receive err
output   utmi_dataoe; //  Controls output enable for link drivers
output   utmi_ddir; //  Not UTMI; Needed for some PHYs which can't control their own drivers
output   utmi_databus16_8; //  Indicates width of xcvr
output   utmi_pwrctl_suspend; //  Suspend output to external power control circuit (do not connect to UTMI suspendm)
output   utmi_phy_enable; //  UTMI phy i/f is selected
input   ulpi_dir; //  see ULPI specification.
output   ulpi_stp; //  see ULPI specification.
input   ulpi_nxt; //  see ULPI specification.
output   [7:0] ulpi_tx_data; //  see ULPI specification.
output   [7:0] ulpi_tx_data_nxt; //  see ULPI specification.
output   [7:0] ulpi_tx_data_oe; //  see ULPI specification.
input   [7:0] ulpi_rx_data; //  see ULPI specification.
output   ulpi_carkit; //  ULPI phy carkit i/f is enabled
output   ulpi_pwrctl_suspend; //  Suspend output to external power control circuit
output   ulpi_phy_enable; //  ULPI phy i/f is selected
output   ser_tx_enable_n; //  transmit output enable
output   ser_tx_dat; //  transmit data
output   ser_tx_se0; //  transmit SE0
input   ser_rx_rcv; //  receive differential
input   ser_rx_dm; //  receive dm input
input   ser_rx_dp; //  receive dp input
output   ser_dppullup; //  enable pullup on dp leg
output   ser_pwrctl_suspend; //  Suspend output to external power control circuit
output   ser_phy_enable; //  Serial phy i/f is selected
output   pwrctl_suspend_clr; //  Suspend clear output to external power control circuit
input   pwrctl_wakeup; //  Suspend wakeup input from external wakeup circuit
input   sess_valid; //  Sense vbus presence on self-powered
output   [1:0] port_ind_ctl; //  can be used for LED indicators
output   [VUSB_HS_RX_ADD - 1:0] rx_buf_addr_a; //  Address bus A
output   [35:0] rx_buf_data_wr_a; //  Data write bus A - bits [35:32] used as a tag
output   rx_buf_wr_en_a; //  Data write enable A
output   rx_buf_clk_a; //  Clock A - connect to pe_clk (see pe_clk notes)
output   [VUSB_HS_RX_ADD - 1:0] rx_buf_addr_b; //  Address bus B
output   rx_buf_rd_en_b; //  Data read enable B
input   [35:0] rx_buf_data_rd_b; //  Data read bus B - bits [35:32] used as a tag
output   rx_buf_clk_b; //  Clock B - Connect to system clock
output   [VUSB_HS_TX_ADD - 1:0] tx_buf_addr_a; //  Address bus A
output   [35:0] tx_buf_data_wr_a; //  Data write bus A - bits [35:32] used as a tag
output   tx_buf_wr_en_a; //  Data write enable A
output   tx_buf_clk_a; //  Clock A - Connect to system clock
output   [VUSB_HS_TX_ADD - 1:0] tx_buf_addr_b; //  Address bus B
input   [35:0] tx_buf_data_rd_b; //  Data read bus B - bits [35:32] used as a tag
output   tx_buf_rd_en_b; //  Data read enable B
output   tx_buf_clk_b; 
//  System clock/resets
wire    t_cmdack; 
wire    t_rspval; 
wire    [31:0] t_rdata; 
//  bus initiator interface
wire    t_reop; 
wire    i_cmdval; 
wire    [31:0] i_address; 
wire    [3:0] i_be; 
wire    [1:0] i_cmd; 
wire    [31:0] i_wdata; 
wire    i_eop; 
wire    i_rspack; 
wire    [BUS_TYPE_INFO_WIDTH - 1:0] i_typeinfo; 
wire    [15:0] i_xtra_out; 
//  USB2 UTMI transceiver interface
wire    interrupt; 
wire    utmi_reset; 
wire    utmi_xcvrselect; 
wire    utmi_termselect; 
wire    [1:0] utmi_opmode; 
wire    [15:0] utmi_datain; 
wire    utmi_txvalid; 
wire    utmi_txvalidh; 
wire    utmi_dataoe; 
wire    utmi_ddir; 
wire    utmi_databus16_8; 
wire    utmi_pwrctl_suspend; 
//  USB2 ULPI transceiver
wire    utmi_phy_enable; 
wire    ulpi_stp; 
wire    [7:0] ulpi_tx_data; 
wire    [7:0] ulpi_tx_data_nxt; 
wire    [7:0] ulpi_tx_data_oe; 
wire    ulpi_carkit; 
wire    ulpi_pwrctl_suspend; 
//  USB1.1 serial transceiver
wire    ulpi_phy_enable; 
wire    ser_tx_enable_n; 
wire    ser_tx_dat; 
wire    ser_tx_se0; 
wire    ser_dppullup; 
wire    ser_pwrctl_suspend; 
//  Power control signals
wire    ser_phy_enable; 
wire    pwrctl_suspend_clr; 
//  Other
wire    [1:0] port_ind_ctl; 
wire    [VUSB_HS_RX_ADD - 1:0] rx_buf_addr_a; 
//                     field for the data
wire    [35:0] rx_buf_data_wr_a; 
wire    rx_buf_wr_en_a; 
wire    rx_buf_clk_a; 
wire    [VUSB_HS_RX_ADD - 1:0] rx_buf_addr_b; 
wire    rx_buf_rd_en_b; 
//                    field for the data
wire    rx_buf_clk_b; 
wire    [VUSB_HS_TX_ADD - 1:0] tx_buf_addr_a; 
//                     field for the data
wire    [35:0] tx_buf_data_wr_a; 
wire    tx_buf_wr_en_a; 
wire    tx_buf_clk_a; 
wire    [VUSB_HS_TX_ADD - 1:0] tx_buf_addr_b; 
//                    field for the data
wire    tx_buf_rd_en_b; 
//  Clock B - Connect to system clock
wire    tx_buf_clk_b; 
wire    t_cmdval_i; 
wire    [8:0] t_address_i; 
wire    [3:0] t_be_i; 
wire    [1:0] t_cmd_i; 
wire    [31:0] t_wdata_i; //  Write Data
wire    t_eop_i; 
wire    t_rspack_i; 
wire    i_cmdack_i; 
wire    i_rspval_i; 
wire    [31:0] i_rdata_i; 
wire    i_reop_i; 
wire    [15:0] i_xtra_in_i; 
// ---------------------------------------------------------------------------
//  vusb_hs_core_dev: System clock domain signals
// ---------------------------------------------------------------------------
//  vusb_hs_core_dev: clock & resets
wire    clk_i; 
wire    rst_s; 
wire    rst_a; 
wire    rst_gen; 
wire    rst_local; 
wire    rst_local_a; 
wire    up_device_mode; 
wire    up_host_mode; 
wire    up_run; 
wire    up_endian; 
wire    up_dev_setup_mode; 
wire    [MEM_BURST_LEN_CNT_WIDTH_WORD - 1:0] up_rx_burst; 
wire    [MEM_BURST_LEN_CNT_WIDTH_WORD - 1:0] up_tx_burst; 
//  vusb_hs_core_dev: uP/dma interface
wire    [8:2] dma_up_addr; 
wire    [31:0] dma_up_datard; 
wire    [31:0] dma_up_datawr; 
wire    [3:0] dma_up_wr; 
wire    [2:0] dma_up_ahbbrst; 
wire    dma_up_async_adv_irq; 
wire    dma_up_frame_roll_irq; 
wire    dma_up_usb_err_irq; 
wire    dma_up_usb_gen_irq; 
wire    dma_up_sys_err_irq; 
wire    dma_up_usb_hstasync_irq; 
wire    dma_up_usb_hstper_irq; 
wire    [13:0] dma_up_hst_frindex; 
wire    dma_up_host_mode; 
wire    dma_up_run; 
wire    dma_up_endian; 
//  vusb_hs_core_dev: uP/tx fifo interface
wire    [8:2] up_txfifo_addr; 
wire    [31:0] up_txfifo_datard; 
wire    [31:0] up_txfifo_datawr; 
wire    up_txfifo_wr_tog_en; 
wire    [3:0] up_txfifo_wr_be; 
wire    up_txfifo_wr_handshake; 
reg     up_txfifo_wr_handshake_s1; 
reg     up_txfifo_wr_handshake_s2; 
//  vusb_hs_core_dev: uP/pe interface
wire    [8:2] up_pe_addr; 
wire    [31:0] up_pe_datard; 
wire    [31:0] up_pe_datawr; 
wire    [3:0] up_pe_wr_be; 
wire    up_pe_wr_tog_en; 
wire    up_pe_wr_handshake; 
reg     up_pe_wr_handshake_s1; 
reg     up_pe_wr_handshake_s2; 
wire    up_pe_dev_sus_irq; 
reg     up_pe_dev_sus_irq_s1; 
reg     up_pe_dev_sus_irq_s2; 
wire    up_pe_dev_rst_irq; 
reg     up_pe_dev_rst_irq_s1; 
reg     up_pe_dev_rst_irq_s2; 
wire    up_pe_sof_irq_tog; 
reg     up_pe_sof_irq_tog_s1; 
reg     up_pe_sof_irq_tog_s2; 
wire    up_pe_dev_nak_irq; 
reg     up_pe_dev_nak_irq_s1; 
reg     up_pe_dev_nak_irq_s2; 
//  vusb_hs_core_dev: uP/OTG interface
wire    [31:0] up_otg_datard; 
wire    [31:0] up_otg_datawr; 
wire    [3:0] up_otg_wr; 
wire    up_otg_irq; 
wire    up_otg_id; 
//  vusb_hs_core_dev: uP/portctrl interface
wire    [0:0] up_portctrl_datard_0; 
wire    [0:0] up_portctrl_datard_1; 
wire    [0:0] up_portctrl_datard_2; 
wire    [0:0] up_portctrl_datard_3; 
wire    [0:0] up_portctrl_datard_4; 
wire    [0:0] up_portctrl_datard_5; 
wire    [0:0] up_portctrl_datard_6; 
wire    [0:0] up_portctrl_datard_7; 
wire    [0:0] up_portctrl_datard_8; 
wire    [0:0] up_portctrl_datard_9; 
wire    [0:0] up_portctrl_datard_10; 
wire    [0:0] up_portctrl_datard_11; 
wire    [0:0] up_portctrl_datard_12; 
wire    [0:0] up_portctrl_datard_13; 
wire    [0:0] up_portctrl_datard_14; 
wire    [0:0] up_portctrl_datard_15; 
wire    [0:0] up_portctrl_datard_16; 
wire    [0:0] up_portctrl_datard_17; 
wire    [0:0] up_portctrl_datard_18; 
wire    [0:0] up_portctrl_datard_19; 
wire    [0:0] up_portctrl_datard_20; 
wire    [0:0] up_portctrl_datard_21; 
wire    [0:0] up_portctrl_datard_22; 
wire    [0:0] up_portctrl_datard_23; 
wire    [0:0] up_portctrl_datard_24; 
wire    [0:0] up_portctrl_datard_25; 
wire    [0:0] up_portctrl_datard_26; 
wire    [0:0] up_portctrl_datard_27; 
wire    [0:0] up_portctrl_datard_28; 
wire    [0:0] up_portctrl_datard_29; 
wire    [0:0] up_portctrl_datard_30; 
wire    [0:0] up_portctrl_datard_31; 
wire    [31:0] up_portctrl_datawr; 
wire    [0:0] up_portctrl_rd; 
wire    [3:0] up_portctrl_wr_be; 
wire    [0:0] up_portctrl_wr_tog_en; 
wire    [0:0] up_portctrl_wr_handshake; 
reg     [0:0] up_portctrl_wr_handshake_s1; 
reg     [0:0] up_portctrl_wr_handshake_s2; 
wire    [0:0] up_portctrl_phy_select_0; 
wire    [0:0] up_portctrl_phy_select_1; 
wire    [0:0] up_portctrl_serial_select; 
wire    [0:0] up_portctrl_port_owner; 
wire    [0:0] up_portctrl_data_width; 
wire    [0:0] up_portctrl_port_power; 
wire    [0:0] up_portctrl_port_chg_irq_tog; 
reg     [0:0] up_portctrl_port_chg_irq_tog_s1; 
reg     [0:0] up_portctrl_port_chg_irq_tog_s2; 
wire    [0:0] up_portctrl_suspend; 
//  vusb_hs_core_dev: uP/ulpi interface
wire    [0:0] up_ulpi_datard_0; 
wire    [0:0] up_ulpi_datard_1; 
wire    [0:0] up_ulpi_datard_2; 
wire    [0:0] up_ulpi_datard_3; 
wire    [0:0] up_ulpi_datard_4; 
wire    [0:0] up_ulpi_datard_5; 
wire    [0:0] up_ulpi_datard_6; 
wire    [0:0] up_ulpi_datard_7; 
wire    [7:0] up_ulpi_datawr; 
wire    [7:0] up_ulpi_addr; 
wire    up_ulpi_rd0wr1; 
wire    [0:0] up_ulpi_cmd_tog; 
wire    [0:0] up_ulpi_wakeup; 
wire    [0:0] up_ulpi_cmd_handshake; 
reg     [0:0] up_ulpi_cmd_handshake_s1; 
reg     [0:0] up_ulpi_cmd_handshake_s2; 
wire    [0:0] up_ulpi_wakeup_handshake; 
reg     [0:0] up_ulpi_wakeup_handshake_s1; 
reg     [0:0] up_ulpi_wakeup_handshake_s2; 
wire    [0:0] up_ulpi_sync_state; 
reg     [0:0] up_ulpi_sync_state_s1; 
reg     [0:0] up_ulpi_sync_state_s2; 
//  vusb_hs_core_dev: dma/pe inteface
wire    [3:0] dma_ep_prime_num; 
wire    dma_ep_prime_rx_tx; 
wire    [10:0] dma_ep_prime_max_pkt_len; 
wire    [2:0] dma_ep_prime_cmd; 
wire    dma_ep_prime_cmd_tog; 
wire    dma_ep_prime_cmd_handshake_tog; 
reg     dma_ep_prime_cmd_handshake_tog_s1; 
reg     dma_ep_prime_cmd_handshake_tog_s2; 
wire    dma_ep_prime_cmd_complete_tog; 
reg     dma_ep_prime_cmd_complete_tog_s1; 
reg     dma_ep_prime_cmd_complete_tog_s2; 
wire    dma_ep_prime_cmd_fail_tog; 
reg     dma_ep_prime_cmd_fail_tog_s1; 
reg     dma_ep_prime_cmd_fail_tog_s2; 
wire    dma_ep_stream_disable; 
//  vusb_hs_core_dev: dma/tx buffer interface
wire    [3:0] dma_tx_tag_wr; 
wire    [31:0] dma_tx_data_wr; 
wire    [15:0] dma_tx_full; 
wire    [15:0] dma_tx_mark_down1; 
wire    [15:0] dma_tx_mark_down2; 
wire    dma_tx_wr; 
wire    [3:0] dma_tx_ep; 
//  vusb_hs_core_dev: dma/rx buffer interface
wire    [3:0] dma_rx_tag; 
wire    [31:0] dma_rx_data; 
wire    dma_rx_empty; 
wire    dma_rx_empty_ctrl; 
wire    dma_rx_mark_up1; 
wire    dma_rx_mark_up2; 
wire    dma_rx_rd; 
wire    [6:0] dma_rx_burst_est; 
//  vusb_hs_core_dev: pe timing strobes
wire    timebase_1us_tog; 
reg     timebase_1us_tog_s1; 
reg     timebase_1us_tog_s2; 
wire    timebase_125us_tog; 
reg     timebase_125us_tog_s1; 
reg     timebase_125us_tog_s2; 
//  vusb_hs_core_dev: otg signals
wire    otg_pc_data_pulse; 
wire    otg_id; 
wire    otg_a_vbus_vld; 
wire    otg_a_sess_vld; 
wire    otg_b_sess_vld; 
wire    otg_b_sess_end; 
wire    otg_id_state; 
wire    otg_vbus_chg; 
wire    otg_vbus_dschg; 
wire    otg_dmpulldown; 
wire    otg_data_pulse; 
wire    otg_idpullup; 
wire    otg_autoreset_connect; 
wire    otg_autoreset_proceed; 
wire    otg_autohst2dev_disconnect; 
wire    otg_autohst2dev_start_reset; 
wire    otg_autohst2dev_set_dev; 
wire    otg_autohst2dev_set_run; 
//  delta delay inputs
wire    [35:0] rx_buf_data_rd_b_i; 
wire    [35:0] tx_buf_data_rd_b_i; 
//  misc. power control
wire    [0:0] utmi_pwrctl_suspend_i; 
wire    [0:0] ulpi_pwrctl_suspend_i; 
wire    [0:0] ser_pwrctl_suspend_i; 
wire    [0:0] pwrctl_suspend_clr_i; 
wire    [0:0] pwrctl_wakeup_i; 
wire    [0:0] pwrctl_wake_cnnt_en_i; 
wire    [0:0] pwrctl_wake_dscnnt_en_i; 
wire    [0:0] pwrctl_wake_ovrcurr_en_i; 
wire    [0:0] port_ind_ctl_0_i; 
wire    [0:0] port_ind_ctl_1_i; 
// ---------------------------------------------------------------------------
//  vusb_hs_core_dev: pe_clk domain signals
// ---------------------------------------------------------------------------
//  vusb_hs_core_dev: resets (pe_clk domain)
wire    pe_clk; 
wire    pe_rst_a; 
reg     pe_rst_a_s1; 
reg     pe_rst_a_s2; 
wire    pe_porst_a; 
reg     pe_porst_a_s1; 
reg     pe_porst_a_s2; 
wire    pe_rst; 
reg     pe_rst_s1; 
reg     pe_rst_s2; 
wire    pe_porst; 
reg     pe_porst_s1; 
reg     pe_porst_s2; 
wire    [8:2] txfifo_up_addr; 
wire    [31:0] txfifo_up_datawr; 
wire    txfifo_up_wr_tog_en; 
reg     txfifo_up_wr_tog_en_s1; 
reg     txfifo_up_wr_tog_en_s2; 
wire    [3:0] txfifo_up_wr_be; 
wire    txfifo_up_wr_handshake; 
//  vusb_hs_core_dev: uP/pe interface (pe_clk domain)
wire    pe_up_host_mode; 
wire    pe_up_dev_setup_mode; 
reg     pe_up_dev_setup_mode_s1; 
reg     pe_up_dev_setup_mode_s2; 
wire    [8:2] pe_up_addr; 
wire    [31:0] pe_up_datard; 
wire    [31:0] pe_up_datawr; 
wire    [3:0] pe_up_wr_be; 
wire    pe_up_wr_tog_en; 
reg     pe_up_wr_tog_en_s1; 
reg     pe_up_wr_tog_en_s2; 
wire    pe_up_wr_handshake; 
wire    pe_up_dev_rst_irq; 
wire    pe_up_sof_irq_tog; 
wire    pe_up_dev_sus_irq; 
wire    pe_up_dev_nak_irq; 
//  vusb_hs_core_dev: uP/portctrl interface (pe_clk domain)
wire    portctrl_up_device_mode; 
wire    portctrl_up_host_mode; 
wire    [0:0] portctrl_up_phy_select_0; 
wire    [0:0] portctrl_up_phy_select_1; 
reg     [0:0] portctrl_up_phy_select_0_s1; 
reg     [0:0] portctrl_up_phy_select_1_s1; 
reg     [0:0] portctrl_up_phy_select_0_s2; 
reg     [0:0] portctrl_up_phy_select_1_s2; 
wire    [0:0] portctrl_up_serial_select; 
reg     [0:0] portctrl_up_serial_select_s1; 
reg     [0:0] portctrl_up_serial_select_s2; 
wire    portctrl_up_port_owner; 
wire    [0:0] portctrl_up_data_width; 
reg     [0:0] portctrl_up_data_width_s1; 
reg     [0:0] portctrl_up_data_width_s2; 
wire    portctrl_up_port_power; 
wire    portctrl_up_run; 
reg     portctrl_up_run_s1; 
reg     portctrl_up_run_s2; 
wire    [0:0] portctrl_up_datard_0; 
wire    [0:0] portctrl_up_datard_1; 
wire    [0:0] portctrl_up_datard_2; 
wire    [0:0] portctrl_up_datard_3; 
wire    [0:0] portctrl_up_datard_4; 
wire    [0:0] portctrl_up_datard_5; 
wire    [0:0] portctrl_up_datard_6; 
wire    [0:0] portctrl_up_datard_7; 
wire    [0:0] portctrl_up_datard_8; 
wire    [0:0] portctrl_up_datard_9; 
wire    [0:0] portctrl_up_datard_10; 
wire    [0:0] portctrl_up_datard_11; 
wire    [0:0] portctrl_up_datard_12; 
wire    [0:0] portctrl_up_datard_13; 
wire    [0:0] portctrl_up_datard_14; 
wire    [0:0] portctrl_up_datard_15; 
wire    [0:0] portctrl_up_datard_16; 
wire    [0:0] portctrl_up_datard_17; 
wire    [0:0] portctrl_up_datard_18; 
wire    [0:0] portctrl_up_datard_19; 
wire    [0:0] portctrl_up_datard_20; 
wire    [0:0] portctrl_up_datard_21; 
wire    [0:0] portctrl_up_datard_22; 
wire    [0:0] portctrl_up_datard_23; 
wire    [0:0] portctrl_up_datard_24; 
wire    [0:0] portctrl_up_datard_25; 
wire    [0:0] portctrl_up_datard_26; 
wire    [0:0] portctrl_up_datard_27; 
wire    [0:0] portctrl_up_datard_28; 
wire    [0:0] portctrl_up_datard_29; 
wire    [0:0] portctrl_up_datard_30; 
wire    [0:0] portctrl_up_datard_31; 
wire    [31:0] portctrl_up_datawr; 
wire    portctrl_up_rd; 
wire    [3:0] portctrl_up_wr_be; 
wire    [0:0] portctrl_up_wr_tog_en; 
reg     [0:0] portctrl_up_wr_tog_en_s1; 
reg     [0:0] portctrl_up_wr_tog_en_s2; 
wire    [0:0] portctrl_up_wr_handshake_tog; 
wire    [0:0] portctrl_up_port_chg_irq_tog; 
wire    [0:0] portctrl_up_suspend; 
reg     [0:0] portctrl_up_suspend_s1; 
reg     [0:0] portctrl_up_suspend_s2; 
//  vusb_hs_core_dev: dma/pe interface (pe_clk domain)
wire    pe_timebase_125us_tog; 
wire    pe_timebase_1us_tog; 
wire    [3:0] pe_ep_prime_num; 
wire    pe_ep_prime_rx_tx; 
wire    [10:0] pe_ep_prime_max_pkt_len; 
wire    [2:0] pe_ep_prime_cmd; 
wire    pe_ep_prime_cmd_tog; 
reg     pe_ep_prime_cmd_tog_s1; 
reg     pe_ep_prime_cmd_tog_s2; 
wire    pe_ep_prime_cmd_handshake_tog; 
wire    pe_ep_prime_cmd_complete_tog; 
wire    pe_ep_prime_cmd_fail_tog; 
wire    pe_ep_stream_disable; 
reg     pe_ep_stream_disable_s1; 
reg     pe_ep_stream_disable_s2; 
//  vusb_hs_core_dev: pe/tx buffer interface (pe_clk domain)
wire    pe_tx_idle; 
wire    [3:0] pe_tx_tag; 
wire    [15:0] pe_tx_data; 
wire    [15:0] pe_tx_empty; 
wire    pe_tx_rd; 
wire    [3:0] pe_tx_ep; 
wire    [3:0] pe_tx_ep_early; 
wire    pe_tx_early_val; 
wire    [15:0] pe_tx_flush; 
//  vusb_hs_core_dev: pe/rx buffer interface (pe_clk domain)
wire    [3:0] pe_rx_tag; 
wire    [15:0] pe_rx_data; 
wire    pe_rx_full; 
wire    pe_rx_wr; 
//  vusb_hs_core_dev: pe/portctrl interface (pe_clk domain)
wire    portctrl_bus_reset; 
wire    portctrl_suspend; 
wire    portctrl_clk_valid; 
wire    portctrl_test_pkt; 
wire    portctrl_test_se0_nak; 
wire    portctrl_force_bit_stuff; 
wire    portctrl_pe_busy; 
wire    [1:0] portctrl_speed_sel; 
wire    portctrl_rx_err; 
wire    [2:0] portctrl_rx_valid_b; 
wire    [15:0] portctrl_rx_data; 
wire    portctrl_tx_ready; 
wire    [1:0] portctrl_tx_valid_b; 
wire    portctrl_tx_valid_early; 
wire    portctrl_tx_valid_last; 
wire    [15:0] portctrl_tx_data; 
wire    portctrl_tx_done; 
wire    portctrl_bto; 
wire    portctrl_flow_en; 
wire    portctrl_arb_bus_reset; 
wire    portctrl_arb_clk_valid; 
wire    portctrl_arb_force_bit_stuff; 
wire    portctrl_arb_hst_frame_babble; 
wire    portctrl_arb_pe_busy; 
wire    portctrl_arb_rx_err; 
wire    portctrl_arb_rx_valid_b_0; 
wire    portctrl_arb_rx_valid_b_1; 
wire    portctrl_arb_rx_valid_b_2; 
wire    portctrl_arb_suspend; 
wire    portctrl_arb_speed_sel_0; 
wire    portctrl_arb_speed_sel_1; 
wire    portctrl_arb_test_pkt; 
wire    portctrl_arb_test_se0_nak; 
wire    portctrl_arb_tx_ready; 
wire    [1:0] portctrl_arb_tx_valid_b; 
wire    portctrl_arb_tx_valid_b_en; 
wire    portctrl_arb_tx_valid_early; 
wire    portctrl_arb_tx_valid_last; 
wire    portctrl_arb_rx_data_0; 
wire    portctrl_arb_rx_data_1; 
wire    portctrl_arb_rx_data_2; 
wire    portctrl_arb_rx_data_3; 
wire    portctrl_arb_rx_data_4; 
wire    portctrl_arb_rx_data_5; 
wire    portctrl_arb_rx_data_6; 
wire    portctrl_arb_rx_data_7; 
wire    portctrl_arb_rx_data_8; 
wire    portctrl_arb_rx_data_9; 
wire    portctrl_arb_rx_data_10; 
wire    portctrl_arb_rx_data_11; 
wire    portctrl_arb_rx_data_12; 
wire    portctrl_arb_rx_data_13; 
wire    portctrl_arb_rx_data_14; 
wire    portctrl_arb_rx_data_15; 
wire    [15:0] portctrl_arb_tx_data; 
wire    portctrl_arb_tx_ls; 
wire    portctrl_arb_tx_done; 
wire    portctrl_arb_bto; 
wire    portctrl_arb_flow_en; 
wire    portctrl_arb_tt_clk_valid; 
wire    portctrl_arb_tt_force_bit_stuff; 
wire    portctrl_arb_tt_hst_frame_babble; 
wire    portctrl_arb_tt_pe_busy; 
wire    portctrl_arb_tt_rx_err; 
wire    portctrl_arb_tt_rx_valid_b_0; 
wire    portctrl_arb_tt_rx_valid_b_1; 
wire    portctrl_arb_tt_rx_valid_b_2; 
wire    portctrl_arb_tt_rx_data_0; 
wire    portctrl_arb_tt_rx_data_1; 
wire    portctrl_arb_tt_rx_data_2; 
wire    portctrl_arb_tt_rx_data_3; 
wire    portctrl_arb_tt_rx_data_4; 
wire    portctrl_arb_tt_rx_data_5; 
wire    portctrl_arb_tt_rx_data_6; 
wire    portctrl_arb_tt_rx_data_7; 
wire    portctrl_arb_tt_rx_data_8; 
wire    portctrl_arb_tt_rx_data_9; 
wire    portctrl_arb_tt_rx_data_10; 
wire    portctrl_arb_tt_rx_data_11; 
wire    portctrl_arb_tt_rx_data_12; 
wire    portctrl_arb_tt_rx_data_13; 
wire    portctrl_arb_tt_rx_data_14; 
wire    portctrl_arb_tt_rx_data_15; 
wire    portctrl_arb_tt_tx_ready; 
wire    [1:0] portctrl_arb_tt_tx_valid_b; 
wire    portctrl_arb_tt_tx_valid_b_en; 
wire    portctrl_arb_tt_tx_valid_early; 
wire    portctrl_arb_tt_tx_valid_last; 
wire    [15:0] portctrl_arb_tt_tx_data; 
wire    portctrl_arb_tt_tx_ls; 
wire    portctrl_arb_tt_tx_done; 
wire    portctrl_arb_tt_bto; 
wire    portctrl_arb_tt_flow_en; 
//  vframe support
wire    vframe_i; 
reg     vframe_s1; 
reg     vframe_s2; 
wire    vframe; 
// ---------------------------------------------------------------------------
//  vusb_hs_core_dev: xcvr_clk domain signals
// ---------------------------------------------------------------------------
wire    ulpi_up_datard_0; 
wire    ulpi_up_datard_1; 
wire    ulpi_up_datard_2; 
wire    ulpi_up_datard_3; 
wire    ulpi_up_datard_4; 
wire    ulpi_up_datard_5; 
wire    ulpi_up_datard_6; 
wire    ulpi_up_datard_7; 
wire    ulpi_up_cmd_handshake; 
wire    ulpi_up_wakeup_handshake; 
wire    ulpi_up_sync_state; 
//  delta delay inputs (xcvr_clk)
wire    xcvr_clk_i; 
wire    [1:0] utmi_linestate_i; 
wire    utmi_txready_i; 
wire    [15:0] utmi_dataout_i; 
wire    utmi_rxvalid_i; 
wire    utmi_rxvalidh_i; 
wire    utmi_rxactive_i; 
wire    utmi_rxerr_i; 
wire    ulpi_dir_i; 
wire    ulpi_nxt_i; 
wire    [7:0] ulpi_rx_data_i; 
//  utmi i/f outputs
wire    utmi_reset_i; 
//  tie-offs
wire    utmi_xcvrselect_1; 
wire    utmi_hostdisconnect_i; 
wire    utmi_iddig_i; 
wire    utmi_idpullup; 
wire    utmi_avalid_i; 
wire    utmi_bvalid_i; 
wire    utmi_vbusvalid_i; 
wire    utmi_sessend_i; 
wire    utmi_dppulldown; 
wire    utmi_dmpulldown; 
wire    utmi_drvvbus; 
wire    utmi_chrgvbus; 
wire    utmi_dischrgvbus; 
wire    utmi_fslsserialmode; 
wire    utmi_tx_enable_n; 
wire    utmi_tx_dat; 
wire    utmi_tx_se0; 
wire    vbus_pwr_fault; 
wire    vbus_pwr_select; 
//  misc.
wire    sess_valid_i; 
// ---------------------------------------------------------------------------
//  vusb_hs_core_otg: xcvr_ser_clk domain signals
// ---------------------------------------------------------------------------
//  delta delay inputs (xcvr_ser_clk)
wire    utmi_rx_rcv_i; 
wire    utmi_rx_dm_i; 
wire    utmi_rx_dp_i; 
wire    ser_rx_rcv_i; 
wire    ser_rx_dm_i; 
wire    ser_rx_dp_i; 
wire    ser_iddig_i; 
wire    ser_idpullup; 
wire    ser_avalid_i; 
wire    ser_bvalid_i; 
wire    ser_vbusvalid_i; 
wire    ser_sessend_i; 
//  tie-offs
wire    ser_speed; 
wire    ser_dppulldown; 
wire    ser_dmpulldown; 
wire    ser_drvvbus; 
wire    ser_chrgvbus; 
wire    ser_dischrgvbus; 
//  Constant to select source of the system clock (clk, xcvr_vusb_hs_clk) when clock configuration = 0
//    0 - select xcvr clock
//    1 - select system clock
//    ** this should not by modified by the user and therefore it is not in the vusb_hs_cfg package.
parameter CLOCK_CONFIGURATION_0_CLK_SEL = 0; 
//  local copies of global setting
parameter VUSB_HS_DEV_EP_TX = VUSB_HS_DEV_EP; 
parameter VUSB_HS_DEV_EP_ADD_TX = VUSB_HS_DEV_EP_ADD; 
parameter VUSB_HS_DEV_EP_RX = VUSB_HS_DEV_EP; 
parameter VUSB_HS_DEV_EP_ADD_RX = VUSB_HS_DEV_EP_ADD; 
//  synopsys sync_set_reset "rst_s"
//  synopsys sync_set_reset "rst_local"
//  synopsys sync_set_reset "pe_rst"
//  synopsys sync_set_reset "pe_porst"
//  str
// -------------------------------------------------------------------
//  vusb_hs_core_dev: Clock & Reset Tie-Offs
// -------------------------------------------------------------------

assign rst_s = VUSB_HS_RESET_TYPE != 1 ? rst : 
	1'b 0; 
assign rst_a = VUSB_HS_RESET_TYPE == 1 ? rst : 
	1'b 0; 
assign rst_local = VUSB_HS_RESET_TYPE != 1 ? rst_gen & ~test_mode | rst & 
      test_mode : 
	1'b 0; 
assign rst_local_a = VUSB_HS_RESET_TYPE == 1 ? rst_gen & ~test_mode | rst & 
      test_mode : 
	1'b 0; 
assign utmi_reset = rst_gen | utmi_reset_i; 
//  Clock Configurations
//  system clock:
assign clk_i = VUSB_HS_CLOCK_CONFIGURATION > 0 | CLOCK_CONFIGURATION_0_CLK_SEL != 0 ? clk : 
	xcvr_clk; 
assign tx_buf_clk_a = VUSB_HS_CLOCK_CONFIGURATION > 0 | CLOCK_CONFIGURATION_0_CLK_SEL != 0 ? clk : 
	xcvr_clk; 
assign rx_buf_clk_b = VUSB_HS_CLOCK_CONFIGURATION > 0 | CLOCK_CONFIGURATION_0_CLK_SEL != 0 ? clk : 
	xcvr_clk; 
//  pe_clk:
assign pe_clk = VUSB_HS_CLOCK_CONFIGURATION == 1 | VUSB_HS_CLOCK_CONFIGURATION == 0 & 
      CLOCK_CONFIGURATION_0_CLK_SEL != 0 ? clk : 
	VUSB_HS_CLOCK_CONFIGURATION >= 3 ? aux_clk : 
	xcvr_clk; 
//  could be alternate clock [> 30Mhz]
assign rx_buf_clk_a = VUSB_HS_CLOCK_CONFIGURATION == 1 | VUSB_HS_CLOCK_CONFIGURATION == 0 & 
      CLOCK_CONFIGURATION_0_CLK_SEL != 0 ? clk : 
	VUSB_HS_CLOCK_CONFIGURATION >= 3 ? aux_clk : 
	xcvr_clk; 
//  could be alternate clock [> 30Mhz]
assign tx_buf_clk_b = VUSB_HS_CLOCK_CONFIGURATION == 1 | VUSB_HS_CLOCK_CONFIGURATION == 0 & 
      CLOCK_CONFIGURATION_0_CLK_SEL != 0 ? clk : 
	VUSB_HS_CLOCK_CONFIGURATION >= 3 ? aux_clk : 
	xcvr_clk; 
//  could be alternate clock [> 30Mhz]
// -------------------------------------------------------------------
//  vusb_hs_core_dev: Delay All Inputs By One Delta
//                (simply due to meet hold for clock re-assignment above)
// -------------------------------------------------------------------
assign t_cmdval_i = t_cmdval; 
assign t_address_i = t_address; 
assign t_be_i = t_be; 
assign t_cmd_i = t_cmd; 
assign t_wdata_i = t_wdata; 
assign t_eop_i = t_eop; 
assign t_rspack_i = t_rspack; 
assign i_cmdack_i = i_cmdack; 
assign i_rspval_i = i_rspval; 
assign i_rdata_i = i_rdata; 
assign i_reop_i = i_reop; 
assign i_xtra_in_i = i_xtra_in; 
assign xcvr_clk_i = VUSB_HS_CLOCK_CONFIGURATION == 0 & CLOCK_CONFIGURATION_0_CLK_SEL != 0 ? clk : 
	VUSB_HS_PHY_TYPE == 3 ? xcvr_ser_clk : 
	xcvr_clk; 
assign rx_buf_data_rd_b_i = rx_buf_data_rd_b; 
assign tx_buf_data_rd_b_i = tx_buf_data_rd_b; 
assign utmi_linestate_i = utmi_linestate; 
assign utmi_txready_i = utmi_txready; 
assign utmi_dataout_i = utmi_dataout; 
assign utmi_rxvalid_i = utmi_rxvalid; 
assign utmi_rxvalidh_i = utmi_rxvalidh; 
assign utmi_rxactive_i = utmi_rxactive; 
assign utmi_rxerr_i = utmi_rxerr; 
assign utmi_rx_rcv_i = ser_rx_rcv; 
assign utmi_rx_dm_i = ser_rx_dm; 
assign utmi_rx_dp_i = ser_rx_dp; 
assign ulpi_dir_i = ulpi_dir; 
assign ulpi_nxt_i = ulpi_nxt; 
assign ulpi_rx_data_i = ulpi_rx_data; 
assign ser_rx_rcv_i = ser_rx_rcv; 
assign ser_rx_dm_i = ser_rx_dm; 
assign ser_rx_dp_i = ser_rx_dp; 
// -------------------------------------------------------------------
//  vusb_hs_core_dev: Other Tie-Offs & Signal Mapping
// -------------------------------------------------------------------
assign dma_up_host_mode = 1'b 0; 
assign dma_up_run = up_run; 
assign dma_up_endian = up_endian; 
// -------------------------------------------------------------------
//  vusb_hs_core_dev: Microprocessor Interface
// -------------------------------------------------------------------
vusb_hs_up_int_bvci #(0,1,VUSB_HS_DEV_EP_TX,VUSB_HS_DEV_EP_RX) U_up_int (.clk(clk_i),
          //  do not change to clk!
          .rst_s(rst_s),
          .rst_a(rst_a),
          .rst_local(rst_local),
          .rst_local_a(rst_local_a),
          .rst_gen(rst_gen),
          .t_cmdack(t_cmdack),
          .t_cmdval(t_cmdval_i),
          .t_address(t_address_i),
          .t_be(t_be_i),
          .t_cmd(t_cmd_i),
          .t_wdata(t_wdata_i),
          .t_eop(t_eop_i),
          .t_rspack(t_rspack_i),
          .t_rspval(t_rspval),
          .t_rdata(t_rdata),
          .t_reop(t_reop),
          .interrupt(interrupt),
          .up_device_mode(up_device_mode),
          .up_host_mode(up_host_mode),
          .up_run(up_run),
          .up_endian(up_endian),
          .up_dev_setup_mode(up_dev_setup_mode),
          .up_rx_burst(up_rx_burst),
          .up_tx_burst(up_tx_burst),
          .dma_up_addr(dma_up_addr),
          .dma_up_datard(dma_up_datard),
          .dma_up_datawr(dma_up_datawr),
          .dma_up_wr(dma_up_wr),
          .dma_up_ahbbrst(dma_up_ahbbrst),
          .dma_up_async_adv_irq(dma_up_async_adv_irq),
          .dma_up_frame_roll_irq(dma_up_frame_roll_irq),
          .dma_up_usb_err_irq(dma_up_usb_err_irq),
          .dma_up_usb_gen_irq(dma_up_usb_gen_irq),
          .dma_up_sys_err_irq(dma_up_sys_err_irq),
          .dma_up_usb_hstasync_irq(dma_up_usb_hstasync_irq),
          .dma_up_usb_hstper_irq(dma_up_usb_hstper_irq),
          .dma_up_hst_frindex(dma_up_hst_frindex),
          .up_txfifo_addr(up_txfifo_addr),
          .up_txfifo_datard(up_txfifo_datard),
          .up_txfifo_datawr(up_txfifo_datawr),
          .up_txfifo_wr_tog_en(up_txfifo_wr_tog_en),
          .up_txfifo_wr_be(up_txfifo_wr_be),
          .up_txfifo_wr_handshake(up_txfifo_wr_handshake),
          .up_pe_addr(up_pe_addr),
          .up_pe_datard(up_pe_datard),
          .up_pe_datawr(up_pe_datawr),
          .up_pe_wr_be(up_pe_wr_be),
          .up_pe_wr_tog_en(up_pe_wr_tog_en),
          .up_pe_wr_handshake(up_pe_wr_handshake),
          .up_pe_dev_rst_irq(up_pe_dev_rst_irq),
          .up_pe_sof_irq_tog(up_pe_sof_irq_tog),
          .up_pe_dev_sus_irq(up_pe_dev_sus_irq),
          .up_pe_dev_nak_irq(up_pe_dev_nak_irq),
          .up_otg_datard(up_otg_datard),
          .up_otg_datawr(up_otg_datawr),
          .up_otg_wr(up_otg_wr),
          .up_otg_irq(up_otg_irq),
          .up_otg_id(up_otg_id),
          .otg_autohst2dev_start_reset(otg_autohst2dev_start_reset),
          .otg_autohst2dev_set_dev(otg_autohst2dev_set_dev),
          .otg_autohst2dev_set_run(otg_autohst2dev_set_run),
          .up_portctrl_datard_0(up_portctrl_datard_0),
          .up_portctrl_datard_1(up_portctrl_datard_1),
          .up_portctrl_datard_2(up_portctrl_datard_2),
          .up_portctrl_datard_3(up_portctrl_datard_3),
          .up_portctrl_datard_4(up_portctrl_datard_4),
          .up_portctrl_datard_5(up_portctrl_datard_5),
          .up_portctrl_datard_6(up_portctrl_datard_6),
          .up_portctrl_datard_7(up_portctrl_datard_7),
          .up_portctrl_datard_8(up_portctrl_datard_8),
          .up_portctrl_datard_9(up_portctrl_datard_9),
          .up_portctrl_datard_10(up_portctrl_datard_10),
          .up_portctrl_datard_11(up_portctrl_datard_11),
          .up_portctrl_datard_12(up_portctrl_datard_12),
          .up_portctrl_datard_13(up_portctrl_datard_13),
          .up_portctrl_datard_14(up_portctrl_datard_14),
          .up_portctrl_datard_15(up_portctrl_datard_15),
          .up_portctrl_datard_16(up_portctrl_datard_16),
          .up_portctrl_datard_17(up_portctrl_datard_17),
          .up_portctrl_datard_18(up_portctrl_datard_18),
          .up_portctrl_datard_19(up_portctrl_datard_19),
          .up_portctrl_datard_20(up_portctrl_datard_20),
          .up_portctrl_datard_21(up_portctrl_datard_21),
          .up_portctrl_datard_22(up_portctrl_datard_22),
          .up_portctrl_datard_23(up_portctrl_datard_23),
          .up_portctrl_datard_24(up_portctrl_datard_24),
          .up_portctrl_datard_25(up_portctrl_datard_25),
          .up_portctrl_datard_26(up_portctrl_datard_26),
          .up_portctrl_datard_27(up_portctrl_datard_27),
          .up_portctrl_datard_28(up_portctrl_datard_28),
          .up_portctrl_datard_29(up_portctrl_datard_29),
          .up_portctrl_datard_30(up_portctrl_datard_30),
          .up_portctrl_datard_31(up_portctrl_datard_31),
          .up_portctrl_datawr(up_portctrl_datawr),
          .up_portctrl_rd(up_portctrl_rd),
          .up_portctrl_wr_be(up_portctrl_wr_be),
          .up_portctrl_wr_tog_en(up_portctrl_wr_tog_en),
          .up_portctrl_wr_handshake(up_portctrl_wr_handshake),
          .up_portctrl_phy_select_0(up_portctrl_phy_select_0),
          .up_portctrl_phy_select_1(up_portctrl_phy_select_1),
          .up_portctrl_serial_select(up_portctrl_serial_select),
          .up_portctrl_port_owner(up_portctrl_port_owner),
          .up_portctrl_data_width(up_portctrl_data_width),
          .up_portctrl_port_ind_1(port_ind_ctl_1_i),
          .up_portctrl_port_ind_0(port_ind_ctl_0_i),
          .up_portctrl_port_power(up_portctrl_port_power),
          .up_portctrl_port_chg_irq_tog(up_portctrl_port_chg_irq_tog),
          .up_portctrl_suspend(up_portctrl_suspend),
          .up_ulpi_datard_0(up_ulpi_datard_0),
          .up_ulpi_datard_1(up_ulpi_datard_1),
          .up_ulpi_datard_2(up_ulpi_datard_2),
          .up_ulpi_datard_3(up_ulpi_datard_3),
          .up_ulpi_datard_4(up_ulpi_datard_4),
          .up_ulpi_datard_5(up_ulpi_datard_5),
          .up_ulpi_datard_6(up_ulpi_datard_6),
          .up_ulpi_datard_7(up_ulpi_datard_7),
          .up_ulpi_datawr(up_ulpi_datawr),
          .up_ulpi_addr(up_ulpi_addr),
          .up_ulpi_rd0wr1(up_ulpi_rd0wr1),
          .up_ulpi_cmd_tog(up_ulpi_cmd_tog),
          .up_ulpi_cmd_handshake(up_ulpi_cmd_handshake),
          .up_ulpi_wakeup(up_ulpi_wakeup),
          .up_ulpi_wakeup_handshake(up_ulpi_wakeup_handshake),
          .up_ulpi_sync_state(up_ulpi_sync_state),
          .utmi_pwrctl_suspend(utmi_pwrctl_suspend_i),
          .ulpi_pwrctl_suspend(ulpi_pwrctl_suspend_i),
          .ser_pwrctl_suspend(ser_pwrctl_suspend_i),
          .pwrctl_suspend_clr(pwrctl_suspend_clr_i),
          .pwrctl_wakeup(pwrctl_wakeup_i),
          .pwrctl_wake_cnnt_en(pwrctl_wake_cnnt_en_i),
          .pwrctl_wake_dscnnt_en(pwrctl_wake_dscnnt_en_i),
          .pwrctl_wake_ovrcurr_en(pwrctl_wake_ovrcurr_en_i),
          .vbus_pwr_select(vbus_pwr_select),
          .timebase_1us_tog(timebase_1us_tog),
          .timebase_125us_tog(timebase_125us_tog));
assign pwrctl_suspend_clr = pwrctl_suspend_clr_i[0]; 
assign port_ind_ctl = {port_ind_ctl_1_i[0], port_ind_ctl_0_i[0]}; 
assign pwrctl_wakeup_i[0] = pwrctl_wakeup; 
assign dma_up_hst_frindex = {14{1'b 0}}; 
assign dma_up_usb_hstasync_irq = 1'b 0; 
assign dma_up_usb_hstper_irq = 1'b 0; 
// -------------------------------------------------------------------
//  vusb_hs_core_dev: DMA Engine
// -------------------------------------------------------------------
vusb_hs_dma_dev_bvci #(VUSB_HS_DEV_EP_TX,VUSB_HS_DEV_EP_ADD_TX,VUSB_HS_DEV_EP_RX,VUSB_HS_DEV_EP_ADD_RX) U_dma (.clk(clk_i),
          //  do not change to clk!
          .rst_local(rst_local),
          .rst_local_a(rst_local_a),
          .i_cmdack(i_cmdack_i),
          .i_cmdval(i_cmdval),
          .i_address(i_address),
          .i_be(i_be),
          .i_cmd(i_cmd),
          .i_wdata(i_wdata),
          .i_eop(i_eop),
          .i_rspack(i_rspack),
          .i_rspval(i_rspval_i),
          .i_rdata(i_rdata_i),
          .i_reop(i_reop_i),
          .i_typeinfo(i_typeinfo),
          .i_xtra_in(i_xtra_in_i),
          .i_xtra_out(i_xtra_out),
          .dma_up_addr(dma_up_addr),
          .dma_up_datard(dma_up_datard),
          .dma_up_datawr(dma_up_datawr),
          .dma_up_wr(dma_up_wr),
          .dma_up_ahbbrst(dma_up_ahbbrst),
          .dma_up_async_adv_irq(dma_up_async_adv_irq),
          .dma_up_frame_roll_irq(dma_up_frame_roll_irq),
          .dma_up_usb_err_irq(dma_up_usb_err_irq),
          .dma_up_usb_gen_irq(dma_up_usb_gen_irq),
          .dma_up_sys_err_irq(dma_up_sys_err_irq),
          .dma_up_run(dma_up_run),
          .dma_up_endian(dma_up_endian),
          .up_rx_burst(up_rx_burst),
          .up_tx_burst(up_tx_burst),
          .dma_ep_prime_num(dma_ep_prime_num),
          .dma_ep_prime_rx_tx(dma_ep_prime_rx_tx),
          .dma_ep_prime_max_pkt_len(dma_ep_prime_max_pkt_len),
          .dma_ep_prime_cmd(dma_ep_prime_cmd),
          .dma_ep_prime_cmd_tog(dma_ep_prime_cmd_tog),
          .dma_ep_prime_cmd_handshake_tog(dma_ep_prime_cmd_handshake_tog),
          .dma_ep_prime_cmd_complete_tog(dma_ep_prime_cmd_complete_tog),
          .dma_ep_prime_cmd_fail_tog(dma_ep_prime_cmd_fail_tog),
          .dma_ep_stream_disable(dma_ep_stream_disable),
          .dma_tx_tag_wr(dma_tx_tag_wr),
          .dma_tx_data_wr(dma_tx_data_wr),
          .dma_tx_full(dma_tx_full),
          .dma_tx_mark_down1(dma_tx_mark_down1),
          .dma_tx_mark_down2(dma_tx_mark_down2),
          .dma_tx_wr(dma_tx_wr),
          .dma_tx_ep(dma_tx_ep),
          .dma_rx_tag(dma_rx_tag),
          .dma_rx_data(dma_rx_data),
          .dma_rx_empty(dma_rx_empty),
          .dma_rx_empty_ctrl(dma_rx_empty_ctrl),
          .dma_rx_burst_est(dma_rx_burst_est),
          .dma_rx_mark_up1(dma_rx_mark_up1),
          .dma_rx_mark_up2(dma_rx_mark_up2),
          .dma_rx_rd(dma_rx_rd));
vusb_hs_tx_buf #(1,VUSB_HS_DEV_EP_TX,VUSB_HS_DEV_EP_ADD_TX) U_tx_buf (.clk(clk_i),
          //  do not change to clk!
          .rst_s(rst_s),
          .rst_a(rst_a),
          .rst_local(rst_local),
          .rst_local_a(rst_local_a),
          .dma_host_mode(dma_up_host_mode),
          .dma_tx_tag_wr(dma_tx_tag_wr),
          .dma_tx_data_wr(dma_tx_data_wr),
          .dma_tx_full(dma_tx_full),
          .dma_tx_mark_down1(dma_tx_mark_down1),
          .dma_tx_mark_down2(dma_tx_mark_down2),
          .dma_tx_wr(dma_tx_wr),
          .dma_tx_ep(dma_tx_ep),
          .up_tx_burst(up_tx_burst),
          .up_txfifo_addr(up_txfifo_addr),
          .up_txfifo_datard(up_txfifo_datard),
          .up_txfifo_datawr(up_txfifo_datawr),
          .up_txfifo_wr_tog_en(up_txfifo_wr_tog_en),
          .up_txfifo_wr_be(up_txfifo_wr_be),
          .pe_clk(pe_clk),
          .pe_rst(pe_rst),
          .pe_rst_a(pe_rst_a),
          .pe_porst(pe_porst),
          .pe_porst_a(pe_porst_a),
          .pe_host_mode(pe_up_host_mode),
          .pe_tx_tag(pe_tx_tag),
          .pe_tx_data(pe_tx_data),
          .pe_tx_empty(pe_tx_empty),
          .pe_tx_idle(pe_tx_idle),
          .pe_tx_rd(pe_tx_rd),
          .pe_tx_ep(pe_tx_ep),
          .pe_tx_ep_early(pe_tx_ep_early),
          .pe_tx_early_val(pe_tx_early_val),
          .pe_tx_flush(pe_tx_flush),
          .txfifo_up_addr(txfifo_up_addr),
          .txfifo_up_datawr(txfifo_up_datawr),
          .txfifo_up_wr_tog_en(txfifo_up_wr_tog_en),
          .txfifo_up_wr_be(txfifo_up_wr_be),
          .txfifo_up_wr_handshake(txfifo_up_wr_handshake),
          .tx_buf_addr_a(tx_buf_addr_a),
          .tx_buf_data_wr_a(tx_buf_data_wr_a),
          .tx_buf_wr_en_a(tx_buf_wr_en_a),
          .tx_buf_addr_b(tx_buf_addr_b),
          .tx_buf_rd_en_b(tx_buf_rd_en_b),
          .tx_buf_data_rd_b(tx_buf_data_rd_b_i));
vusb_hs_rx_buf #(1) U_rx_buf (	//  USAGE_DEV
          .clk(clk_i),
          .rst_local(rst_local),
          .rst_local_a(rst_local_a),
          .dma_rx_tag(dma_rx_tag),
          .dma_rx_data(dma_rx_data),
          .dma_rx_empty(dma_rx_empty),
          .dma_rx_empty_ctrl(dma_rx_empty_ctrl),
          .dma_rx_mark_up1(dma_rx_mark_up1),
          .dma_rx_mark_up2(dma_rx_mark_up2),
          .dma_rx_rd(dma_rx_rd),
          .up_rx_burst(up_rx_burst),
          .dma_rx_burst_est(dma_rx_burst_est),
          .pe_clk(pe_clk),
          .pe_rst(pe_rst),
          .pe_rst_a(pe_rst_a),
          .pe_rx_tag(pe_rx_tag),
          .pe_rx_data(pe_rx_data),
          .pe_rx_full(pe_rx_full),
          .pe_rx_wr(pe_rx_wr),
          .rx_buf_addr_a(rx_buf_addr_a),
          .rx_buf_data_wr_a(rx_buf_data_wr_a),
          .rx_buf_wr_en_a(rx_buf_wr_en_a),
          .rx_buf_addr_b(rx_buf_addr_b),
          .rx_buf_rd_en_b(rx_buf_rd_en_b),
          .rx_buf_data_rd_b(rx_buf_data_rd_b_i));
vusb_hs_pe_dev #(VUSB_HS_DEV_EP_TX,VUSB_HS_DEV_EP_ADD_TX,VUSB_HS_DEV_EP_RX,VUSB_HS_DEV_EP_ADD_RX) U_pe (.pe_clk(pe_clk),
          //  [IN]
          .pe_rst(pe_rst),
          //  [IN]
          .pe_rst_a(pe_rst_a),
          //  [IN]
          .pe_up_dev_setup_mode(pe_up_dev_setup_mode),
          //  [IN]
          .pe_up_addr(pe_up_addr),
          //  [IN]
          .pe_up_datard(pe_up_datard),
          //  [OUT]
          .pe_up_datawr(pe_up_datawr),
          //  [IN]
          .pe_up_sof_irq_tog(pe_up_sof_irq_tog),
          //  [OUT]
          .pe_up_dev_sus_irq(pe_up_dev_sus_irq),
          //  [OUT]
          .pe_up_dev_nak_irq(pe_up_dev_nak_irq),
          //  [OUT]
          .pe_up_wr_be(pe_up_wr_be),
          //  [IN]
          .pe_up_wr_handshake(pe_up_wr_handshake),
          //  [OUT]
          .pe_up_wr_tog_en(pe_up_wr_tog_en),
          //  [IN]
          .pe_up_dev_rst_irq(pe_up_dev_rst_irq),
          //  [OUT]
          .pe_ep_prime_cmd(pe_ep_prime_cmd),
          //  [IN]
          .pe_ep_prime_cmd_complete_tog(pe_ep_prime_cmd_complete_tog),
          //  [OUT]
          .pe_ep_prime_cmd_fail_tog(pe_ep_prime_cmd_fail_tog),
          //  [OUT]
          .pe_ep_prime_cmd_handshake_tog(pe_ep_prime_cmd_handshake_tog),
          //  [OUT]
          .pe_ep_prime_cmd_tog(pe_ep_prime_cmd_tog),
          //  [IN]
          .pe_ep_prime_num(pe_ep_prime_num),
          //  [IN]
          .pe_ep_prime_rx_tx(pe_ep_prime_rx_tx),
          //  [IN]
          .pe_ep_prime_max_pkt_len(pe_ep_prime_max_pkt_len),
          //  [IN]
          .pe_ep_stream_disable(pe_ep_stream_disable),
          //  [IN]
          .pe_tx_tag(pe_tx_tag),
          //  [IN]
          .pe_tx_data(pe_tx_data),
          //  [IN]
          .pe_tx_empty(pe_tx_empty),
          //  [IN]
          .pe_tx_idle(pe_tx_idle),
          //  [OUT]
          .pe_tx_flush(pe_tx_flush),
          //  [OUT]
          .pe_tx_rd(pe_tx_rd),
          //  [OUT]
          .pe_tx_ep(pe_tx_ep),
          //  [OUT]
          .pe_tx_ep_early(pe_tx_ep_early),
          //  [OUT]
          .pe_tx_early_val(pe_tx_early_val),
          //  [OUT]
          .pe_rx_tag(pe_rx_tag),
          //  [OUT]
          .pe_rx_data(pe_rx_data),
          //  [OUT]
          .pe_rx_full(pe_rx_full),
          //  [IN]
          .pe_rx_wr(pe_rx_wr),
          //  [OUT]
          .portctrl_bus_reset(portctrl_bus_reset),
          //  [IN]
          .portctrl_suspend(portctrl_suspend),
          //  [IN]
          .portctrl_clk_valid(portctrl_clk_valid),
          //  [IN]
          .portctrl_test_pkt(portctrl_test_pkt),
          //  [IN]
          .portctrl_test_se0_nak(portctrl_test_se0_nak),
          //  [IN]
          .portctrl_force_bit_stuff(portctrl_force_bit_stuff),
          //  [OUT]
          .portctrl_pe_busy(portctrl_pe_busy),
          //  [OUT]
          .portctrl_speed_sel(portctrl_speed_sel),
          //  [IN]
          .portctrl_rx_err(portctrl_rx_err),
          //  [IN]
          .portctrl_rx_valid_b(portctrl_rx_valid_b),
          //  [IN]
          .portctrl_rx_data(portctrl_rx_data),
          //  [IN]
          .portctrl_tx_ready(portctrl_tx_ready),
          //  [IN]
          .portctrl_tx_valid_b(portctrl_tx_valid_b),
          //  [OUT]
          .portctrl_tx_valid_early(portctrl_tx_valid_early),
          //  [OUT]
          .portctrl_tx_valid_last(portctrl_tx_valid_last),
          //  [OUT]
          .portctrl_tx_data(portctrl_tx_data),
          //  [OUT]
          .portctrl_tx_done(portctrl_tx_done),
          //  [IN]
          .portctrl_bto(portctrl_bto),
          //  [IN]
          .portctrl_flow_en(portctrl_flow_en),
          //  [IN]
          .timebase_1us_tog(pe_timebase_1us_tog),
          //  [OUT]
          .timebase_125us_tog(pe_timebase_125us_tog),
          //  [OUT]
          .vframe(vframe_i));
always @(posedge pe_clk or posedge rst_local_a)
   begin : pe_clk_rst_a_sync_PROC
   if (rst_local_a == 1'b 1)
      begin
//  asynchronous reset (active high)
      pe_rst_a_s1 <= 1'b 1;   //  [OUT]
      pe_rst_a_s2 <= 1'b 1;   
      end
   else
      begin
      pe_rst_a_s1 <= 1'b 0;   //  rising clock edge
      pe_rst_a_s2 <= pe_rst_a_s1;   
      end
   end

// -------------------------------------------------------------------
//  vusb_hs_core_dev: PE System Clock Synchronization
// 
//    The double sets of registers in the interfaces below
//    provide metastability protection for clock domain
//    crossing.  This is only needed when
//    VUSB_HS_CLOCK_CONFIGUATION = 2.  (clk_i_freq > pe_clk_freq)
//    When VUSB_HS_CLOCK_CONFIGURATION /= 2 clk_i = pe_clk and
//    no metastability registers are required and are thus bypassed
//    in the code below.
// -------------------------------------------------------------------
//  purpose: provide synchronization and metastability protection between design units
//  sys_clk domain ==> pe_clk domain
//  PROCESS pe_clk_rst_a_sync_PROC
assign pe_rst_a = VUSB_HS_RESET_TYPE == 1 & VUSB_HS_CLOCK_CONFIGURATION >= 2 ? pe_rst_a_s2 & 
      ~test_mode | rst & test_mode : 
	VUSB_HS_RESET_TYPE == 1 ? rst_gen & ~test_mode | rst & 
      test_mode : 
	1'b 0; 
//  power on only (not software resetable)
always @(posedge pe_clk or posedge rst_a)
   begin : pe_clk_porst_a_sync_PROC
   if (rst_a == 1'b 1)
      begin
//  asynchronous reset (active high)
      pe_porst_a_s1 <= 1'b 1;   
      pe_porst_a_s2 <= 1'b 1;   
      end
   else
      begin
      pe_porst_a_s1 <= 1'b 0;   //  rising clock edge
      pe_porst_a_s2 <= pe_porst_a_s1;   
      end
   end

//  PROCESS pe_clk_rst_a_sync_PROC
assign pe_porst_a = VUSB_HS_RESET_TYPE == 1 & VUSB_HS_CLOCK_CONFIGURATION >= 2 ? pe_porst_a_s2 & 
      ~test_mode | rst & test_mode : 
	VUSB_HS_RESET_TYPE == 1 ? rst & ~test_mode | rst & 
      test_mode : 
	1'b 0; 
always @(posedge pe_clk)
   begin : pe_clk_rst_s_sync_PROC
   if (rst_local == 1'b 1)
      begin
      pe_rst_s1 <= 1'b 1;   //  rising clock edge
      pe_rst_s2 <= 1'b 1;   
      end
   else
      begin
      pe_rst_s1 <= 1'b 0;   
      pe_rst_s2 <= pe_rst_s1;   
      end
   end

//  PROCESS pe_clk_rst_s_sync_PROC
assign pe_rst = VUSB_HS_RESET_TYPE != 1 & VUSB_HS_CLOCK_CONFIGURATION >= 2 ? pe_rst_s2 & 
      ~test_mode | rst & test_mode : 
	VUSB_HS_RESET_TYPE != 1 ? rst_gen & ~test_mode | rst & 
      test_mode : 
	1'b 0; 
always @(posedge pe_clk)
   begin : pe_clk_porst_s_sync_PROC
   if (rst_s == 1'b 1)
      begin
      pe_porst_s1 <= 1'b 1;   //  rising clock edge
      pe_porst_s2 <= 1'b 1;   
      end
   else
      begin
      pe_porst_s1 <= 1'b 0;   
      pe_porst_s2 <= pe_porst_s1;   
      end
   end

//  PROCESS pe_clk_rst_s_sync_PROC
assign pe_porst = VUSB_HS_RESET_TYPE != 1 & VUSB_HS_CLOCK_CONFIGURATION >= 2 ? pe_porst_s2 & 
      ~test_mode | rst & test_mode : 
	VUSB_HS_RESET_TYPE != 1 ? rst & ~test_mode | rst & 
      test_mode : 
	1'b 0; 
//  txfifo/uP interface
assign txfifo_up_addr = up_txfifo_addr; 
assign txfifo_up_wr_be = up_txfifo_wr_be; 
assign txfifo_up_datawr = up_txfifo_datawr; 
assign txfifo_up_wr_tog_en = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? txfifo_up_wr_tog_en_s2 : 
	up_txfifo_wr_tog_en; 
assign up_txfifo_wr_handshake = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? up_txfifo_wr_handshake_s2 : 
	1'b 0; 
//  pe/uP interface
assign pe_up_host_mode = 1'b 0; 
assign pe_up_dev_setup_mode = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? pe_up_dev_setup_mode_s2 : 
	up_dev_setup_mode; 
assign pe_up_addr = up_pe_addr; 
assign pe_up_datawr = up_pe_datawr; 
assign pe_up_wr_tog_en = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? pe_up_wr_tog_en_s2 : 
	up_pe_wr_tog_en; 
assign pe_up_wr_be = up_pe_wr_be; 
assign up_pe_datard = pe_up_datard; 
assign up_pe_wr_handshake = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? up_pe_wr_handshake_s2 : 
	1'b 0; 
assign up_pe_dev_rst_irq = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? up_pe_dev_rst_irq_s2 : 
	pe_up_dev_rst_irq; 
assign up_pe_sof_irq_tog = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? up_pe_sof_irq_tog_s2 : 
	pe_up_sof_irq_tog; 
assign up_pe_dev_sus_irq = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? up_pe_dev_sus_irq_s2 : 
	pe_up_dev_sus_irq; 
assign up_pe_dev_nak_irq = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? up_pe_dev_nak_irq_s2 : 
	pe_up_dev_nak_irq; 
assign portctrl_up_device_mode = 1'b 1; 
assign portctrl_up_host_mode = 1'b 0; 
assign portctrl_up_port_power = 1'b 1; 
assign portctrl_up_phy_select_1 = VUSB_HS_PHY_TYPE == 0 | VUSB_HS_PHY_TYPE == 1 ? {1{1'b 0}} : 
	VUSB_HS_PHY_TYPE == 2 | VUSB_HS_PHY_TYPE == 3 ? {1{1'b 1}} : 
	VUSB_HS_CLOCK_CONFIGURATION >= 2 ? portctrl_up_phy_select_1_s2 : 
	up_portctrl_phy_select_1; 
assign portctrl_up_phy_select_0 = VUSB_HS_PHY_TYPE == 0 | VUSB_HS_PHY_TYPE == 2 ? {1{1'b 0}} : 
	VUSB_HS_PHY_TYPE == 1 | VUSB_HS_PHY_TYPE == 3 ? {1{1'b 1}} : 
	VUSB_HS_CLOCK_CONFIGURATION >= 2 ? portctrl_up_phy_select_0_s2 : 
	up_portctrl_phy_select_0; 
assign portctrl_up_serial_select = VUSB_HS_PHY_SERIAL == 0 ? {1{1'b 0}} : 
	VUSB_HS_PHY_SERIAL == 1 ? {1{1'b 1}} : 
	VUSB_HS_CLOCK_CONFIGURATION >= 2 ? portctrl_up_serial_select_s2 : 
	up_portctrl_serial_select; 
assign portctrl_up_port_owner = 1'b 0; 
assign portctrl_up_data_width = VUSB_HS_PHY16_8 == 0 ? {1{1'b 0}} : 
	VUSB_HS_PHY16_8 == 1 ? {1{1'b 1}} : 
	VUSB_HS_CLOCK_CONFIGURATION >= 2 ? portctrl_up_data_width_s2 : 
	up_portctrl_data_width; 
assign portctrl_up_suspend = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? portctrl_up_suspend_s2 : 
	up_portctrl_suspend; 
assign portctrl_up_run = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? portctrl_up_run_s2 : 
	up_run; 
//  portctrl/uP interface
assign portctrl_up_datawr = up_portctrl_datawr; 
assign portctrl_up_rd = up_portctrl_rd[0]; 
assign portctrl_up_wr_tog_en = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? portctrl_up_wr_tog_en_s2 : 
	up_portctrl_wr_tog_en; 
assign portctrl_up_wr_be = up_portctrl_wr_be; 
assign up_portctrl_datard_0 = portctrl_up_datard_0; 
assign up_portctrl_datard_1 = portctrl_up_datard_1; 
assign up_portctrl_datard_2 = portctrl_up_datard_2; 
assign up_portctrl_datard_3 = portctrl_up_datard_3; 
assign up_portctrl_datard_4 = portctrl_up_datard_4; 
assign up_portctrl_datard_5 = portctrl_up_datard_5; 
assign up_portctrl_datard_6 = portctrl_up_datard_6; 
assign up_portctrl_datard_7 = portctrl_up_datard_7; 
assign up_portctrl_datard_8 = portctrl_up_datard_8; 
assign up_portctrl_datard_9 = portctrl_up_datard_9; 
assign up_portctrl_datard_10 = portctrl_up_datard_10; 
assign up_portctrl_datard_11 = portctrl_up_datard_11; 
assign up_portctrl_datard_12 = portctrl_up_datard_12; 
assign up_portctrl_datard_13 = portctrl_up_datard_13; 
assign up_portctrl_datard_14 = portctrl_up_datard_14; 
assign up_portctrl_datard_15 = portctrl_up_datard_15; 
assign up_portctrl_datard_16 = portctrl_up_datard_16; 
assign up_portctrl_datard_17 = portctrl_up_datard_17; 
assign up_portctrl_datard_18 = portctrl_up_datard_18; 
assign up_portctrl_datard_19 = portctrl_up_datard_19; 
assign up_portctrl_datard_20 = portctrl_up_datard_20; 
assign up_portctrl_datard_21 = portctrl_up_datard_21; 
assign up_portctrl_datard_22 = portctrl_up_datard_22; 
assign up_portctrl_datard_23 = portctrl_up_datard_23; 
assign up_portctrl_datard_24 = portctrl_up_datard_24; 
assign up_portctrl_datard_25 = portctrl_up_datard_25; 
assign up_portctrl_datard_26 = portctrl_up_datard_26; 
assign up_portctrl_datard_27 = portctrl_up_datard_27; 
assign up_portctrl_datard_28 = portctrl_up_datard_28; 
assign up_portctrl_datard_29 = portctrl_up_datard_29; 
assign up_portctrl_datard_30 = portctrl_up_datard_30; 
assign up_portctrl_datard_31 = portctrl_up_datard_31; 
assign up_portctrl_wr_handshake = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? up_portctrl_wr_handshake_s2 : 
	{1{1'b 0}}; 
assign up_portctrl_port_chg_irq_tog = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? up_portctrl_port_chg_irq_tog_s2 : 
	portctrl_up_port_chg_irq_tog; 
//  portctrl/ulpi interface
assign up_ulpi_datard_0[0] = VUSB_HS_PHY_ULPI == 1 ? ulpi_up_datard_0 : 
	1'b 0; 
assign up_ulpi_datard_1[0] = VUSB_HS_PHY_ULPI == 1 ? ulpi_up_datard_1 : 
	1'b 0; 
assign up_ulpi_datard_2[0] = VUSB_HS_PHY_ULPI == 1 ? ulpi_up_datard_2 : 
	1'b 0; 
assign up_ulpi_datard_3[0] = VUSB_HS_PHY_ULPI == 1 ? ulpi_up_datard_3 : 
	1'b 0; 
assign up_ulpi_datard_4[0] = VUSB_HS_PHY_ULPI == 1 ? ulpi_up_datard_4 : 
	1'b 0; 
assign up_ulpi_datard_5[0] = VUSB_HS_PHY_ULPI == 1 ? ulpi_up_datard_5 : 
	1'b 0; 
assign up_ulpi_datard_6[0] = VUSB_HS_PHY_ULPI == 1 ? ulpi_up_datard_6 : 
	1'b 0; 
assign up_ulpi_datard_7[0] = VUSB_HS_PHY_ULPI == 1 ? ulpi_up_datard_7 : 
	1'b 0; 
assign up_ulpi_cmd_handshake[0] = VUSB_HS_PHY_ULPI == 1 & VUSB_HS_CLOCK_CONFIGURATION == 0 ? ulpi_up_cmd_handshake : 
	VUSB_HS_PHY_ULPI == 1 ? up_ulpi_cmd_handshake_s2[0] : 
	1'b 0; 
assign up_ulpi_wakeup_handshake[0] = VUSB_HS_PHY_ULPI == 1 & VUSB_HS_CLOCK_CONFIGURATION == 0 ? ulpi_up_wakeup_handshake : 
	VUSB_HS_PHY_ULPI == 1 ? up_ulpi_wakeup_handshake_s2[0] : 
	1'b 0; 
assign up_ulpi_sync_state[0] = VUSB_HS_PHY_ULPI == 1 & VUSB_HS_CLOCK_CONFIGURATION == 0 ? ulpi_up_sync_state : 
	VUSB_HS_PHY_ULPI == 1 ? up_ulpi_sync_state_s2[0] : 
	1'b 0; 
//  Tie-off the OTG inputs to the up_int, OTG is only in the host
assign timebase_1us_tog = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? timebase_1us_tog_s2 : 
	pe_timebase_1us_tog; 
assign timebase_125us_tog = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? timebase_125us_tog_s2 : 
	pe_timebase_125us_tog; 
//  pe/dma interface; device
assign pe_ep_prime_cmd_tog = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? pe_ep_prime_cmd_tog_s2 : 
	dma_ep_prime_cmd_tog; 
assign pe_ep_stream_disable = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? pe_ep_stream_disable_s2 : 
	dma_ep_stream_disable; 
assign dma_ep_prime_cmd_handshake_tog = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? dma_ep_prime_cmd_handshake_tog_s2 : 
	pe_ep_prime_cmd_handshake_tog; 
assign dma_ep_prime_cmd_complete_tog = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? dma_ep_prime_cmd_complete_tog_s2 : 
	pe_ep_prime_cmd_complete_tog; 
assign dma_ep_prime_cmd_fail_tog = VUSB_HS_CLOCK_CONFIGURATION >= 2 ? dma_ep_prime_cmd_fail_tog_s2 : 
	pe_ep_prime_cmd_fail_tog; 
assign pe_ep_prime_num = dma_ep_prime_num; 
assign pe_ep_prime_rx_tx = dma_ep_prime_rx_tx; 
assign pe_ep_prime_max_pkt_len = dma_ep_prime_max_pkt_len; 
assign pe_ep_prime_cmd = dma_ep_prime_cmd; 
//  purpose: provide synchronization and metastability protection between design units
//  pe_clk domain   ==> sys_clk domain
//  xcvr_clk domain ==> sys_clk domain
always @(posedge clk_i or posedge rst_local_a)
   begin : sys_clk_sync_PROC
   if (rst_local_a == 1'b 1)
      begin
//  asynchronous reset (active high)
      up_txfifo_wr_handshake_s1 <= 1'b 0;   
      up_txfifo_wr_handshake_s2 <= 1'b 0;   
      up_pe_wr_handshake_s1 <= 1'b 0;   
      up_pe_wr_handshake_s2 <= 1'b 0;   
      up_pe_dev_rst_irq_s1 <= 1'b 0;   
      up_pe_dev_rst_irq_s2 <= 1'b 0;   
      up_pe_sof_irq_tog_s1 <= 1'b 0;   
      up_pe_sof_irq_tog_s2 <= 1'b 0;   
      up_pe_dev_sus_irq_s1 <= 1'b 0;   
      up_pe_dev_sus_irq_s2 <= 1'b 0;   
      up_pe_dev_nak_irq_s1 <= 1'b 0;   
      up_pe_dev_nak_irq_s2 <= 1'b 0;   
      up_portctrl_wr_handshake_s1 <= {1{1'b 0}};   
      up_portctrl_wr_handshake_s2 <= {1{1'b 0}};   
      up_portctrl_port_chg_irq_tog_s1 <= {1{1'b 0}};   
      up_portctrl_port_chg_irq_tog_s2 <= {1{1'b 0}};   
      up_ulpi_cmd_handshake_s1 <= {1{1'b 0}};   
      up_ulpi_cmd_handshake_s2 <= {1{1'b 0}};   
      up_ulpi_wakeup_handshake_s1 <= {1{1'b 0}};   
      up_ulpi_wakeup_handshake_s2 <= {1{1'b 0}};   
      up_ulpi_sync_state_s1 <= {1{1'b 0}};   
      up_ulpi_sync_state_s2 <= {1{1'b 0}};   
      timebase_1us_tog_s1 <= 1'b 0;   
      timebase_1us_tog_s2 <= 1'b 0;   
      timebase_125us_tog_s1 <= 1'b 0;   
      timebase_125us_tog_s2 <= 1'b 0;   
      dma_ep_prime_cmd_handshake_tog_s1 <= 1'b 0;   
      dma_ep_prime_cmd_handshake_tog_s2 <= 1'b 0;   
      dma_ep_prime_cmd_complete_tog_s1 <= 1'b 0;   
      dma_ep_prime_cmd_complete_tog_s2 <= 1'b 0;   
      dma_ep_prime_cmd_fail_tog_s1 <= 1'b 0;   
      dma_ep_prime_cmd_fail_tog_s2 <= 1'b 0;   
      end
   else
      begin
      if (rst_local == 1'b 1)
         begin
         up_txfifo_wr_handshake_s1 <= 1'b 0;   //  rising clock edge
         up_txfifo_wr_handshake_s2 <= 1'b 0;   
         up_pe_wr_handshake_s1 <= 1'b 0;   
         up_pe_wr_handshake_s2 <= 1'b 0;   
         up_pe_dev_rst_irq_s1 <= 1'b 0;   
         up_pe_dev_rst_irq_s2 <= 1'b 0;   
         up_pe_sof_irq_tog_s1 <= 1'b 0;   
         up_pe_sof_irq_tog_s2 <= 1'b 0;   
         up_pe_dev_sus_irq_s1 <= 1'b 0;   
         up_pe_dev_sus_irq_s2 <= 1'b 0;   
         up_pe_dev_nak_irq_s1 <= 1'b 0;   
         up_pe_dev_nak_irq_s2 <= 1'b 0;   
         up_portctrl_wr_handshake_s1 <= {1{1'b 0}};   
         up_portctrl_wr_handshake_s2 <= {1{1'b 0}};   
         up_portctrl_port_chg_irq_tog_s1 <= {1{1'b 0}};   
         up_portctrl_port_chg_irq_tog_s2 <= {1{1'b 0}};   
         up_ulpi_cmd_handshake_s1 <= {1{1'b 0}};   
         up_ulpi_cmd_handshake_s2 <= {1{1'b 0}};   
         up_ulpi_wakeup_handshake_s1 <= {1{1'b 0}};   
         up_ulpi_wakeup_handshake_s2 <= {1{1'b 0}};   
         up_ulpi_sync_state_s1 <= {1{1'b 0}};   
         up_ulpi_sync_state_s2 <= {1{1'b 0}};   
         timebase_1us_tog_s1 <= 1'b 0;   
         timebase_1us_tog_s2 <= 1'b 0;   
         timebase_125us_tog_s1 <= 1'b 0;   
         timebase_125us_tog_s2 <= 1'b 0;   
         dma_ep_prime_cmd_handshake_tog_s1 <= 1'b 0;   
         dma_ep_prime_cmd_handshake_tog_s2 <= 1'b 0;   
         dma_ep_prime_cmd_complete_tog_s1 <= 1'b 0;   
         dma_ep_prime_cmd_complete_tog_s2 <= 1'b 0;   
         dma_ep_prime_cmd_fail_tog_s1 <= 1'b 0;   
         dma_ep_prime_cmd_fail_tog_s2 <= 1'b 0;   
         end
      else
         begin
         up_txfifo_wr_handshake_s1 <= txfifo_up_wr_handshake;   
         up_txfifo_wr_handshake_s2 <= up_txfifo_wr_handshake_s1;   
         up_pe_wr_handshake_s1 <= pe_up_wr_handshake;   
         up_pe_wr_handshake_s2 <= up_pe_wr_handshake_s1;   
         up_pe_dev_rst_irq_s1 <= pe_up_dev_rst_irq;   
         up_pe_dev_rst_irq_s2 <= up_pe_dev_rst_irq_s1;   
         up_pe_sof_irq_tog_s1 <= pe_up_sof_irq_tog;   
         up_pe_sof_irq_tog_s2 <= up_pe_sof_irq_tog_s1;   
         up_pe_dev_sus_irq_s1 <= pe_up_dev_sus_irq;   
         up_pe_dev_sus_irq_s2 <= up_pe_dev_sus_irq_s1;   
         up_pe_dev_nak_irq_s1 <= pe_up_dev_nak_irq;   
         up_pe_dev_nak_irq_s2 <= up_pe_dev_nak_irq_s1;   
         up_portctrl_wr_handshake_s1 <= portctrl_up_wr_handshake_tog;   
         up_portctrl_wr_handshake_s2 <= up_portctrl_wr_handshake_s1;   
         up_portctrl_port_chg_irq_tog_s1 <= portctrl_up_port_chg_irq_tog;   
         up_portctrl_port_chg_irq_tog_s2 <= up_portctrl_port_chg_irq_tog_s1;   
         up_ulpi_cmd_handshake_s1[0] <= ulpi_up_cmd_handshake;   
         up_ulpi_cmd_handshake_s2 <= up_ulpi_cmd_handshake_s1;   
         up_ulpi_wakeup_handshake_s1[0] <= ulpi_up_wakeup_handshake;   
         up_ulpi_wakeup_handshake_s2 <= up_ulpi_wakeup_handshake_s1;   
         up_ulpi_sync_state_s1[0] <= ulpi_up_sync_state;   
         up_ulpi_sync_state_s2 <= up_ulpi_sync_state_s1;   
         timebase_1us_tog_s1 <= pe_timebase_1us_tog;   
         timebase_1us_tog_s2 <= timebase_1us_tog_s1;   
         timebase_125us_tog_s1 <= pe_timebase_125us_tog;   
         timebase_125us_tog_s2 <= timebase_125us_tog_s1;   
         dma_ep_prime_cmd_handshake_tog_s1 <= pe_ep_prime_cmd_handshake_tog;   
         dma_ep_prime_cmd_handshake_tog_s2 <= dma_ep_prime_cmd_handshake_tog_s1;   
         dma_ep_prime_cmd_complete_tog_s1 <= pe_ep_prime_cmd_complete_tog;   
         dma_ep_prime_cmd_complete_tog_s2 <= dma_ep_prime_cmd_complete_tog_s1;   
         dma_ep_prime_cmd_fail_tog_s1 <= pe_ep_prime_cmd_fail_tog;   
         dma_ep_prime_cmd_fail_tog_s2 <= dma_ep_prime_cmd_fail_tog_s1;   
         end
      end
   end
//  purpose: provide synchronization and metastability protection between design units
//  sys_clk domain ==> pe_clk domain
//  PROCESS sys_clk_sync_PROC
always @(posedge pe_clk or posedge pe_rst_a)
   begin : pe_clk_sync_PROC
   if (pe_rst_a == 1'b 1)
      begin
//  asynchronous reset (active high)
      txfifo_up_wr_tog_en_s1 <= 1'b 0;   
      txfifo_up_wr_tog_en_s2 <= 1'b 0;   
      pe_up_dev_setup_mode_s1 <= 1'b 0;   
      pe_up_dev_setup_mode_s2 <= 1'b 0;   
      pe_up_wr_tog_en_s1 <= 1'b 0;   
      pe_up_wr_tog_en_s2 <= 1'b 0;   
      pe_ep_prime_cmd_tog_s1 <= 1'b 0;   
      pe_ep_prime_cmd_tog_s2 <= 1'b 0;   
      pe_ep_stream_disable_s1 <= 1'b 0;   
      pe_ep_stream_disable_s2 <= 1'b 0;   
      portctrl_up_run_s1 <= 1'b 0;   
      portctrl_up_run_s2 <= 1'b 0;   
      portctrl_up_wr_tog_en_s1 <= {1{1'b 0}};   
      portctrl_up_wr_tog_en_s2 <= {1{1'b 0}};   
      end
   else
      begin
      if (pe_rst == 1'b 1)
         begin
         txfifo_up_wr_tog_en_s1 <= 1'b 0;   //  rising clock edge
         txfifo_up_wr_tog_en_s2 <= 1'b 0;   
         pe_up_dev_setup_mode_s1 <= 1'b 0;   
         pe_up_dev_setup_mode_s2 <= 1'b 0;   
         pe_up_wr_tog_en_s1 <= 1'b 0;   
         pe_up_wr_tog_en_s2 <= 1'b 0;   
         pe_ep_prime_cmd_tog_s1 <= 1'b 0;   
         pe_ep_prime_cmd_tog_s2 <= 1'b 0;   
         pe_ep_stream_disable_s1 <= 1'b 0;   
         pe_ep_stream_disable_s2 <= 1'b 0;   
         portctrl_up_run_s1 <= 1'b 0;   
         portctrl_up_run_s2 <= 1'b 0;   
         portctrl_up_wr_tog_en_s1 <= {1{1'b 0}};   
         portctrl_up_wr_tog_en_s2 <= {1{1'b 0}};   
         end
      else
         begin
         txfifo_up_wr_tog_en_s1 <= up_txfifo_wr_tog_en;   
         txfifo_up_wr_tog_en_s2 <= txfifo_up_wr_tog_en_s1;   
         pe_up_dev_setup_mode_s1 <= up_dev_setup_mode;   
         pe_up_dev_setup_mode_s2 <= pe_up_dev_setup_mode_s1;   
         pe_up_wr_tog_en_s1 <= up_pe_wr_tog_en;   
         pe_up_wr_tog_en_s2 <= pe_up_wr_tog_en_s1;   
         pe_ep_prime_cmd_tog_s1 <= dma_ep_prime_cmd_tog;   
         pe_ep_prime_cmd_tog_s2 <= pe_ep_prime_cmd_tog_s1;   
         pe_ep_stream_disable_s1 <= dma_ep_stream_disable;   
         pe_ep_stream_disable_s2 <= pe_ep_stream_disable_s1;   
         portctrl_up_run_s1 <= up_run;   
         portctrl_up_run_s2 <= portctrl_up_run_s1;   
         portctrl_up_wr_tog_en_s1 <= up_portctrl_wr_tog_en;   
         portctrl_up_wr_tog_en_s2 <= portctrl_up_wr_tog_en_s1;   
         end
      end
   end

//  PROCESS pe_clk_sync_PROC
always @(posedge pe_clk or posedge pe_porst_a)
   begin : pe_clk_sync_power_on_rst_PROC
   if (pe_porst_a == 1'b 1)
      begin
//  asynchronous reset (active high)
      if (VUSB_HS_PHY_TYPE == 2 | VUSB_HS_PHY_TYPE == 3 | 
      VUSB_HS_PHY_TYPE == 6 | VUSB_HS_PHY_TYPE == 7)
         begin
         portctrl_up_phy_select_1_s1 <= {1{1'b 1}};   
         portctrl_up_phy_select_1_s2 <= {1{1'b 1}};   
         end
      else
         begin
         portctrl_up_phy_select_1_s1 <= {1{1'b 0}};   
         portctrl_up_phy_select_1_s2 <= {1{1'b 0}};   
         end
      if (VUSB_HS_PHY_TYPE == 1 | VUSB_HS_PHY_TYPE == 3 | 
      VUSB_HS_PHY_TYPE == 5 | VUSB_HS_PHY_TYPE == 7)
         begin
         portctrl_up_phy_select_0_s1 <= {1{1'b 1}};   
         portctrl_up_phy_select_0_s2 <= {1{1'b 1}};   
         end
      else
         begin
         portctrl_up_phy_select_0_s1 <= {1{1'b 0}};   
         portctrl_up_phy_select_0_s2 <= {1{1'b 0}};   
         end
      if (VUSB_HS_PHY_SERIAL == 1 | VUSB_HS_PHY_SERIAL == 3)
         begin
         portctrl_up_serial_select_s1 <= {1{1'b 1}};   
         portctrl_up_serial_select_s2 <= {1{1'b 1}};   
         end
      else
         begin
         portctrl_up_serial_select_s1 <= {1{1'b 0}};   
         portctrl_up_serial_select_s2 <= {1{1'b 0}};   
         end
      if (VUSB_HS_PHY16_8 == 1 | VUSB_HS_PHY16_8 == 3)
         begin
         portctrl_up_data_width_s1 <= {1{1'b 1}};   
         portctrl_up_data_width_s2 <= {1{1'b 1}};   
         end
      else
         begin
         portctrl_up_data_width_s1 <= {1{1'b 0}};   
         portctrl_up_data_width_s2 <= {1{1'b 0}};   
         end
      portctrl_up_suspend_s1 <= {1{1'b 0}};   
      portctrl_up_suspend_s2 <= {1{1'b 0}};   
      end
   else
      begin
      if (pe_porst == 1'b 1)
         begin
         if (VUSB_HS_PHY_TYPE == 2 | VUSB_HS_PHY_TYPE == 3 | 
      VUSB_HS_PHY_TYPE == 6 | VUSB_HS_PHY_TYPE == 7)
            begin
            portctrl_up_phy_select_1_s1 <= {1{1'b 1}};   //  rising clock edge
            portctrl_up_phy_select_1_s2 <= {1{1'b 1}};   
            end
         else
            begin
            portctrl_up_phy_select_1_s1 <= {1{1'b 0}};   
            portctrl_up_phy_select_1_s2 <= {1{1'b 0}};   
            end
         if (VUSB_HS_PHY_TYPE == 1 | VUSB_HS_PHY_TYPE == 3 | 
      VUSB_HS_PHY_TYPE == 5 | VUSB_HS_PHY_TYPE == 7)
            begin
            portctrl_up_phy_select_0_s1 <= {1{1'b 1}};   
            portctrl_up_phy_select_0_s2 <= {1{1'b 1}};   
            end
         else
            begin
            portctrl_up_phy_select_0_s1 <= {1{1'b 0}};   
            portctrl_up_phy_select_0_s2 <= {1{1'b 0}};   
            end
         if (VUSB_HS_PHY_SERIAL == 1 | VUSB_HS_PHY_SERIAL == 3)
            begin
            portctrl_up_serial_select_s1 <= {1{1'b 1}};   
            portctrl_up_serial_select_s2 <= {1{1'b 1}};   
            end
         else
            begin
            portctrl_up_serial_select_s1 <= {1{1'b 0}};   
            portctrl_up_serial_select_s2 <= {1{1'b 0}};   
            end
         if (VUSB_HS_PHY16_8 == 1 | VUSB_HS_PHY16_8 == 3)
            begin
            portctrl_up_data_width_s1 <= {1{1'b 1}};   
            portctrl_up_data_width_s2 <= {1{1'b 1}};   
            end
         else
            begin
            portctrl_up_data_width_s1 <= {1{1'b 0}};   
            portctrl_up_data_width_s2 <= {1{1'b 0}};   
            end
         portctrl_up_suspend_s1 <= {1{1'b 0}};   
         portctrl_up_suspend_s2 <= {1{1'b 0}};   
         end
      else
         begin
         portctrl_up_phy_select_0_s1 <= up_portctrl_phy_select_0;   
         portctrl_up_phy_select_1_s1 <= up_portctrl_phy_select_1;   
         portctrl_up_phy_select_0_s2 <= portctrl_up_phy_select_0_s1;   
         portctrl_up_phy_select_1_s2 <= portctrl_up_phy_select_1_s1;   
         portctrl_up_serial_select_s1 <= up_portctrl_serial_select;   
         portctrl_up_serial_select_s2 <= portctrl_up_serial_select_s1;   
         portctrl_up_data_width_s1 <= up_portctrl_data_width;   
         portctrl_up_data_width_s2 <= portctrl_up_data_width_s1;   
         portctrl_up_suspend_s1 <= up_portctrl_suspend;   
         portctrl_up_suspend_s2 <= portctrl_up_suspend_s1;   
         end
      end
   end
// -------------------------------------------------------------------
//  vusb_hs_core_dev: Arbitor Placeholder (only in Multi-Port Host)
// -------------------------------------------------------------------
//  PROCESS
assign portctrl_bus_reset = portctrl_arb_bus_reset; 
assign portctrl_suspend = portctrl_arb_suspend; 
assign portctrl_clk_valid = portctrl_arb_clk_valid; 
assign portctrl_test_pkt = portctrl_arb_test_pkt; 
assign portctrl_test_se0_nak = portctrl_arb_test_se0_nak; 
assign portctrl_speed_sel[0] = portctrl_arb_speed_sel_0; 
assign portctrl_speed_sel[1] = portctrl_arb_speed_sel_1; 
assign portctrl_rx_err = portctrl_arb_rx_err; 
assign portctrl_tx_ready = portctrl_arb_tx_ready; 
assign portctrl_rx_valid_b[0] = portctrl_arb_rx_valid_b_0; 
assign portctrl_rx_valid_b[1] = portctrl_arb_rx_valid_b_1; 
assign portctrl_rx_valid_b[2] = portctrl_arb_rx_valid_b_2; 
assign portctrl_rx_data[0] = portctrl_arb_rx_data_0; 
assign portctrl_rx_data[1] = portctrl_arb_rx_data_1; 
assign portctrl_rx_data[2] = portctrl_arb_rx_data_2; 
assign portctrl_rx_data[3] = portctrl_arb_rx_data_3; 
assign portctrl_rx_data[4] = portctrl_arb_rx_data_4; 
assign portctrl_rx_data[5] = portctrl_arb_rx_data_5; 
assign portctrl_rx_data[6] = portctrl_arb_rx_data_6; 
assign portctrl_rx_data[7] = portctrl_arb_rx_data_7; 
assign portctrl_rx_data[8] = portctrl_arb_rx_data_8; 
assign portctrl_rx_data[9] = portctrl_arb_rx_data_9; 
assign portctrl_rx_data[10] = portctrl_arb_rx_data_10; 
assign portctrl_rx_data[11] = portctrl_arb_rx_data_11; 
assign portctrl_rx_data[12] = portctrl_arb_rx_data_12; 
assign portctrl_rx_data[13] = portctrl_arb_rx_data_13; 
assign portctrl_rx_data[14] = portctrl_arb_rx_data_14; 
assign portctrl_rx_data[15] = portctrl_arb_rx_data_15; 
assign portctrl_tx_done = portctrl_arb_tx_done; 
assign portctrl_bto = portctrl_arb_bto; 
assign portctrl_flow_en = portctrl_arb_flow_en; 
assign portctrl_arb_force_bit_stuff = portctrl_force_bit_stuff; 
assign portctrl_arb_pe_busy = portctrl_pe_busy; 
assign portctrl_arb_hst_frame_babble = 1'b 0; //  host only
assign portctrl_arb_tx_valid_b = portctrl_tx_valid_b; 
assign portctrl_arb_tx_valid_b_en = 1'b 1; //  multi-port host only
assign portctrl_arb_tx_valid_early = portctrl_tx_valid_early; 
assign portctrl_arb_tx_valid_last = portctrl_tx_valid_last; 
assign portctrl_arb_tx_data = portctrl_tx_data; 
assign portctrl_arb_tx_ls = 1'b 0; 
assign portctrl_arb_tt_force_bit_stuff = 1'b 0; 
assign portctrl_arb_tt_pe_busy = 1'b 0; 
assign portctrl_arb_tt_hst_frame_babble = 1'b 0; 
assign portctrl_arb_tt_tx_valid_b = 2'b 00; 
assign portctrl_arb_tt_tx_valid_b_en = 1'b 0; 
assign portctrl_arb_tt_tx_valid_early = 1'b 0; 
assign portctrl_arb_tt_tx_valid_last = 1'b 0; 
assign portctrl_arb_tt_tx_data = {16{1'b 0}}; 
assign portctrl_arb_tt_tx_ls = 1'b 0; 
// -------------------------------------------------------------------
//  vusb_hs_core_dev: Port Controller
// -------------------------------------------------------------------
vusb_hs_portctrl #(0,6,3) U_portctrl (.rst(rst),
          //  [IN]
          .rst_a(rst_a),
          //  [IN]
          .rst_s(rst_s),
          //  [IN]
          .rst_local_a(rst_local_a),
          //  [IN]
          .rst_local(rst_local),
          //  [IN]
          .pe_clk(pe_clk),
          //  [IN]
          .pe_rst(pe_rst),
          //  [IN]
          .pe_rst_a(pe_rst_a),
          //  [IN]
          .pe_porst(pe_porst),
          //  [IN]
          .pe_porst_a(pe_porst_a),
          //  [IN]
          .xcvr_clk(xcvr_clk_i),
          //  [IN]
          .xcvr_ser_clk(xcvr_ser_clk),
          //  [IN]
          .test_mode(test_mode),
          //  [IN]
          .portctrl_arb_force_bit_stuff(portctrl_arb_force_bit_stuff),
          //  [IN]
          .portctrl_arb_hst_frame_babble(portctrl_arb_hst_frame_babble),
          //  [IN]
          .portctrl_arb_pe_busy(portctrl_arb_pe_busy),
          //  [IN]
          .portctrl_arb_tx_data(portctrl_arb_tx_data),
          //  [IN]
          .portctrl_arb_tx_ls(portctrl_arb_tx_ls),
          //  [IN]
          .portctrl_arb_tx_valid_b_0(portctrl_arb_tx_valid_b[0]),
          //  [IN]
          .portctrl_arb_tx_valid_b_1(portctrl_arb_tx_valid_b[1]),
          //  [IN]
          .portctrl_arb_tx_valid_b_en(portctrl_arb_tx_valid_b_en),
          //  [IN]
          .portctrl_arb_tx_valid_early(portctrl_arb_tx_valid_early),
          //  [IN]
          .portctrl_arb_tx_valid_last(portctrl_arb_tx_valid_last),
          //  [IN]
          .portctrl_arb_bus_reset(portctrl_arb_bus_reset),
          //  [OUT]
          .portctrl_arb_clk_valid(portctrl_arb_clk_valid),
          //  [OUT]
          .portctrl_arb_rx_data_0(portctrl_arb_rx_data_0),
          //  [OUT]
          .portctrl_arb_rx_data_1(portctrl_arb_rx_data_1),
          //  [OUT]
          .portctrl_arb_rx_data_2(portctrl_arb_rx_data_2),
          //  [OUT]
          .portctrl_arb_rx_data_3(portctrl_arb_rx_data_3),
          //  [OUT]
          .portctrl_arb_rx_data_4(portctrl_arb_rx_data_4),
          //  [OUT]
          .portctrl_arb_rx_data_5(portctrl_arb_rx_data_5),
          //  [OUT]
          .portctrl_arb_rx_data_6(portctrl_arb_rx_data_6),
          //  [OUT]
          .portctrl_arb_rx_data_7(portctrl_arb_rx_data_7),
          //  [OUT]
          .portctrl_arb_rx_data_8(portctrl_arb_rx_data_8),
          //  [OUT]
          .portctrl_arb_rx_data_9(portctrl_arb_rx_data_9),
          //  [OUT]
          .portctrl_arb_rx_data_10(portctrl_arb_rx_data_10),
          //  [OUT]
          .portctrl_arb_rx_data_11(portctrl_arb_rx_data_11),
          //  [OUT]
          .portctrl_arb_rx_data_12(portctrl_arb_rx_data_12),
          //  [OUT]
          .portctrl_arb_rx_data_13(portctrl_arb_rx_data_13),
          //  [OUT]
          .portctrl_arb_rx_data_14(portctrl_arb_rx_data_14),
          //  [OUT]
          .portctrl_arb_rx_data_15(portctrl_arb_rx_data_15),
          //  [OUT]
          .portctrl_arb_rx_err(portctrl_arb_rx_err),
          //  [OUT]
          .portctrl_arb_rx_valid_b_0(portctrl_arb_rx_valid_b_0),
          //  [OUT]
          .portctrl_arb_rx_valid_b_1(portctrl_arb_rx_valid_b_1),
          //  [OUT]
          .portctrl_arb_rx_valid_b_2(portctrl_arb_rx_valid_b_2),
          //  [OUT]
          .portctrl_arb_speed_sel_0(portctrl_arb_speed_sel_0),
          //  [OUT]
          .portctrl_arb_speed_sel_1(portctrl_arb_speed_sel_1),
          //  [OUT]
          .portctrl_arb_suspend(portctrl_arb_suspend),
          //  [OUT]
          .portctrl_arb_test_pkt(portctrl_arb_test_pkt),
          //  [OUT]
          .portctrl_arb_test_se0_nak(portctrl_arb_test_se0_nak),
          //  [OUT]
          .portctrl_arb_tx_ready(portctrl_arb_tx_ready),
          //  [OUT]
          .portctrl_arb_tx_done(portctrl_arb_tx_done),
          //  [OUT]
          .portctrl_arb_bto(portctrl_arb_bto),
          //  [OUT]
          .portctrl_arb_flow_en(portctrl_arb_flow_en),
          //  [OUT]
          .portctrl_arb_tt_force_bit_stuff(portctrl_arb_tt_force_bit_stuff),
          //  [IN]
          .portctrl_arb_tt_hst_frame_babble(portctrl_arb_tt_hst_frame_babble),
          //  [IN]
          .portctrl_arb_tt_pe_busy(portctrl_arb_tt_pe_busy),
          //  [IN]
          .portctrl_arb_tt_tx_data(portctrl_arb_tt_tx_data),
          //  [IN]
          .portctrl_arb_tt_tx_ls(portctrl_arb_tt_tx_ls),
          //  [IN]
          .portctrl_arb_tt_tx_valid_b_0(portctrl_arb_tt_tx_valid_b[0]),
          //  [IN]
          .portctrl_arb_tt_tx_valid_b_1(portctrl_arb_tt_tx_valid_b[1]),
          //  [IN]
          .portctrl_arb_tt_tx_valid_b_en(portctrl_arb_tt_tx_valid_b_en),
          //  [IN]
          .portctrl_arb_tt_tx_valid_early(portctrl_arb_tt_tx_valid_early),
          //  [IN]
          .portctrl_arb_tt_tx_valid_last(portctrl_arb_tt_tx_valid_last),
          //  [IN]
          .portctrl_arb_tt_clk_valid(portctrl_arb_tt_clk_valid),
          //  [OUT]
          .portctrl_arb_tt_rx_data_0(portctrl_arb_tt_rx_data_0),
          //  [OUT]
          .portctrl_arb_tt_rx_data_1(portctrl_arb_tt_rx_data_1),
          //  [OUT]
          .portctrl_arb_tt_rx_data_2(portctrl_arb_tt_rx_data_2),
          //  [OUT]
          .portctrl_arb_tt_rx_data_3(portctrl_arb_tt_rx_data_3),
          //  [OUT]
          .portctrl_arb_tt_rx_data_4(portctrl_arb_tt_rx_data_4),
          //  [OUT]
          .portctrl_arb_tt_rx_data_5(portctrl_arb_tt_rx_data_5),
          //  [OUT]
          .portctrl_arb_tt_rx_data_6(portctrl_arb_tt_rx_data_6),
          //  [OUT]
          .portctrl_arb_tt_rx_data_7(portctrl_arb_tt_rx_data_7),
          //  [OUT]
          .portctrl_arb_tt_rx_data_8(portctrl_arb_tt_rx_data_8),
          //  [OUT]
          .portctrl_arb_tt_rx_data_9(portctrl_arb_tt_rx_data_9),
          //  [OUT]
          .portctrl_arb_tt_rx_data_10(portctrl_arb_tt_rx_data_10),
          //  [OUT]
          .portctrl_arb_tt_rx_data_11(portctrl_arb_tt_rx_data_11),
          //  [OUT]
          .portctrl_arb_tt_rx_data_12(portctrl_arb_tt_rx_data_12),
          //  [OUT]
          .portctrl_arb_tt_rx_data_13(portctrl_arb_tt_rx_data_13),
          //  [OUT]
          .portctrl_arb_tt_rx_data_14(portctrl_arb_tt_rx_data_14),
          //  [OUT]
          .portctrl_arb_tt_rx_data_15(portctrl_arb_tt_rx_data_15),
          //  [OUT]
          .portctrl_arb_tt_rx_err(portctrl_arb_tt_rx_err),
          //  [OUT]
          .portctrl_arb_tt_rx_valid_b_0(portctrl_arb_tt_rx_valid_b_0),
          //  [OUT]
          .portctrl_arb_tt_rx_valid_b_1(portctrl_arb_tt_rx_valid_b_1),
          //  [OUT]
          .portctrl_arb_tt_rx_valid_b_2(portctrl_arb_tt_rx_valid_b_2),
          //  [OUT]
          .portctrl_arb_tt_tx_ready(portctrl_arb_tt_tx_ready),
          //  [OUT]
          .portctrl_arb_tt_tx_done(portctrl_arb_tt_tx_done),
          //  [OUT]
          .portctrl_arb_tt_bto(portctrl_arb_tt_bto),
          //  [OUT]
          .portctrl_arb_tt_flow_en(portctrl_arb_tt_flow_en),
          //  [OUT]
          .portctrl_up_port_owner(portctrl_up_port_owner),
          //  [IN]
          .portctrl_up_data_width(portctrl_up_data_width[0]),
          //  [IN]
          .portctrl_up_datawr(portctrl_up_datawr),
          //  [IN]
          .portctrl_up_device_mode(portctrl_up_device_mode),
          //  [IN]
          .portctrl_up_host_mode(portctrl_up_host_mode),
          //  [IN]
          .portctrl_up_phy_select_0(portctrl_up_phy_select_0[0]),
          //  [IN]
          .portctrl_up_phy_select_1(portctrl_up_phy_select_1[0]),
          //  [IN]
          .portctrl_up_serial_select(portctrl_up_serial_select[0]),
          //  [IN]
          .portctrl_up_port_power(portctrl_up_port_power),
          //  [IN]
          .portctrl_up_rd(portctrl_up_rd),
          //  [IN]
          .portctrl_up_run(portctrl_up_run),
          //  [IN]
          .portctrl_up_wr_be(portctrl_up_wr_be),
          //  [IN]
          .portctrl_up_wr_tog_en(portctrl_up_wr_tog_en[0]),
          //  [IN]
          .portctrl_up_datard_0(portctrl_up_datard_0[0]),
          //  [OUT]
          .portctrl_up_datard_1(portctrl_up_datard_1[0]),
          //  [OUT]
          .portctrl_up_datard_2(portctrl_up_datard_2[0]),
          //  [OUT]
          .portctrl_up_datard_3(portctrl_up_datard_3[0]),
          //  [OUT]
          .portctrl_up_datard_4(portctrl_up_datard_4[0]),
          //  [OUT]
          .portctrl_up_datard_5(portctrl_up_datard_5[0]),
          //  [OUT]
          .portctrl_up_datard_6(portctrl_up_datard_6[0]),
          //  [OUT]
          .portctrl_up_datard_7(portctrl_up_datard_7[0]),
          //  [OUT]
          .portctrl_up_datard_8(portctrl_up_datard_8[0]),
          //  [OUT]
          .portctrl_up_datard_9(portctrl_up_datard_9[0]),
          //  [OUT]
          .portctrl_up_datard_10(portctrl_up_datard_10[0]),
          //  [OUT]
          .portctrl_up_datard_11(portctrl_up_datard_11[0]),
          //  [OUT]
          .portctrl_up_datard_12(portctrl_up_datard_12[0]),
          //  [OUT]
          .portctrl_up_datard_13(portctrl_up_datard_13[0]),
          //  [OUT]
          .portctrl_up_datard_14(portctrl_up_datard_14[0]),
          //  [OUT]
          .portctrl_up_datard_15(portctrl_up_datard_15[0]),
          //  [OUT]
          .portctrl_up_datard_16(portctrl_up_datard_16[0]),
          //  [OUT]
          .portctrl_up_datard_17(portctrl_up_datard_17[0]),
          //  [OUT]
          .portctrl_up_datard_18(portctrl_up_datard_18[0]),
          //  [OUT]
          .portctrl_up_datard_19(portctrl_up_datard_19[0]),
          //  [OUT]
          .portctrl_up_datard_20(portctrl_up_datard_20[0]),
          //  [OUT]
          .portctrl_up_datard_21(portctrl_up_datard_21[0]),
          //  [OUT]
          .portctrl_up_datard_22(portctrl_up_datard_22[0]),
          //  [OUT]
          .portctrl_up_datard_23(portctrl_up_datard_23[0]),
          //  [OUT]
          .portctrl_up_datard_24(portctrl_up_datard_24[0]),
          //  [OUT]
          .portctrl_up_datard_25(portctrl_up_datard_25[0]),
          //  [OUT]
          .portctrl_up_datard_26(portctrl_up_datard_26[0]),
          //  [OUT]
          .portctrl_up_datard_27(portctrl_up_datard_27[0]),
          //  [OUT]
          .portctrl_up_datard_28(portctrl_up_datard_28[0]),
          //  [OUT]
          .portctrl_up_datard_29(portctrl_up_datard_29[0]),
          //  [OUT]
          .portctrl_up_datard_30(portctrl_up_datard_30[0]),
          //  [OUT]
          .portctrl_up_datard_31(portctrl_up_datard_31[0]),
          //  [OUT]
          .portctrl_up_port_chg_irq_tog(portctrl_up_port_chg_irq_tog[0]),
          //  [OUT]
          .portctrl_up_wr_handshake_tog(portctrl_up_wr_handshake_tog[0]),
          //  [OUT]
          .portctrl_up_suspend(portctrl_up_suspend[0]),
          //  [IN]
          .ulpi_up_datard_0(ulpi_up_datard_0),
          //  [OUT]
          .ulpi_up_datard_1(ulpi_up_datard_1),
          //  [OUT]
          .ulpi_up_datard_2(ulpi_up_datard_2),
          //  [OUT]
          .ulpi_up_datard_3(ulpi_up_datard_3),
          //  [OUT]
          .ulpi_up_datard_4(ulpi_up_datard_4),
          //  [OUT]
          .ulpi_up_datard_5(ulpi_up_datard_5),
          //  [OUT]
          .ulpi_up_datard_6(ulpi_up_datard_6),
          //  [OUT]
          .ulpi_up_datard_7(ulpi_up_datard_7),
          //  [OUT]
          .up_ulpi_datawr(up_ulpi_datawr),
          //  [IN]
          .up_ulpi_addr(up_ulpi_addr),
          //  [IN]
          .up_ulpi_rd0wr1(up_ulpi_rd0wr1),
          //  [IN]
          .up_ulpi_cmd_tog(up_ulpi_cmd_tog[0]),
          //  [IN]
          .ulpi_up_cmd_handshake(ulpi_up_cmd_handshake),
          //  [OUT]
          .up_ulpi_wakeup(up_ulpi_wakeup[0]),
          //  [IN]
          .ulpi_up_wakeup_handshake(ulpi_up_wakeup_handshake),
          //  [OUT]
          .ulpi_up_sync_state(ulpi_up_sync_state),
          //  [OUT]
          .up_portctrl_data_width(up_portctrl_data_width[0]),
          //  [IN]
          .up_portctrl_port_power(up_portctrl_port_power[0]),
          //  [IN]
          .up_portctrl_device_mode(up_device_mode),
          //  [IN]
          .up_portctrl_host_mode(up_host_mode),
          //  [IN]
          .up_portctrl_phy_select_0(up_portctrl_phy_select_0[0]),
          //  [IN]
          .up_portctrl_phy_select_1(up_portctrl_phy_select_1[0]),
          //  [IN]
          .up_portctrl_suspend(up_portctrl_suspend[0]),
          //  [IN]
          .otg_pc_data_pulse(otg_pc_data_pulse),
          //  [OUT]
          .otg_id(otg_id),
          //  [OUT]
          .otg_a_vbus_vld(otg_a_vbus_vld),
          //  [OUT]
          .otg_a_sess_vld(otg_a_sess_vld),
          //  [OUT]
          .otg_b_sess_vld(otg_b_sess_vld),
          //  [OUT]
          .otg_b_sess_end(otg_b_sess_end),
          //  [OUT]
          .otg_id_state(otg_id_state),
          //  [IN]
          .otg_vbus_chg(otg_vbus_chg),
          //  [IN]
          .otg_vbus_dschg(otg_vbus_dschg),
          //  [IN]
          .otg_dmpulldown(otg_dmpulldown),
          //  [IN]
          .otg_data_pulse(otg_data_pulse),
          //  [IN]
          .otg_idpullup(otg_idpullup),
          //  [IN]
          .otg_autoreset_connect(otg_autoreset_connect),
          //  [OUT]
          .otg_autoreset_proceed(otg_autoreset_proceed),
          //  [IN]
          .otg_autohst2dev_disconnect(otg_autohst2dev_disconnect),
          //  [OUT]
          .utmi_reset(utmi_reset_i),
          //  [OUT]
          .utmi_xcvrselect_0(utmi_xcvrselect),
          //  [OUT]
          .utmi_xcvrselect_1(utmi_xcvrselect_1),
          //  [OUT]
          .utmi_termselect(utmi_termselect),
          //  [OUT]
          .utmi_linestate_0(utmi_linestate_i[0]),
          //  [IN]
          .utmi_linestate_1(utmi_linestate_i[1]),
          //  [IN]
          .utmi_opmode_0(utmi_opmode[0]),
          //  [OUT]
          .utmi_opmode_1(utmi_opmode[1]),
          //  [OUT]
          .utmi_datain_0(utmi_datain[0]),
          //  [OUT]
          .utmi_datain_1(utmi_datain[1]),
          //  [OUT]
          .utmi_datain_2(utmi_datain[2]),
          //  [OUT]
          .utmi_datain_3(utmi_datain[3]),
          //  [OUT]
          .utmi_datain_4(utmi_datain[4]),
          //  [OUT]
          .utmi_datain_5(utmi_datain[5]),
          //  [OUT]
          .utmi_datain_6(utmi_datain[6]),
          //  [OUT]
          .utmi_datain_7(utmi_datain[7]),
          //  [OUT]
          .utmi_datain_8(utmi_datain[8]),
          //  [OUT]
          .utmi_datain_9(utmi_datain[9]),
          //  [OUT]
          .utmi_datain_10(utmi_datain[10]),
          //  [OUT]
          .utmi_datain_11(utmi_datain[11]),
          //  [OUT]
          .utmi_datain_12(utmi_datain[12]),
          //  [OUT]
          .utmi_datain_13(utmi_datain[13]),
          //  [OUT]
          .utmi_datain_14(utmi_datain[14]),
          //  [OUT]
          .utmi_datain_15(utmi_datain[15]),
          //  [OUT]
          .utmi_txvalid(utmi_txvalid),
          //  [OUT]
          .utmi_txvalidh(utmi_txvalidh),
          //  [OUT]
          .utmi_txready(utmi_txready_i),
          //  [IN]
          .utmi_dataout_0(utmi_dataout_i[0]),
          //  [IN]
          .utmi_dataout_1(utmi_dataout_i[1]),
          //  [IN]
          .utmi_dataout_2(utmi_dataout_i[2]),
          //  [IN]
          .utmi_dataout_3(utmi_dataout_i[3]),
          //  [IN]
          .utmi_dataout_4(utmi_dataout_i[4]),
          //  [IN]
          .utmi_dataout_5(utmi_dataout_i[5]),
          //  [IN]
          .utmi_dataout_6(utmi_dataout_i[6]),
          //  [IN]
          .utmi_dataout_7(utmi_dataout_i[7]),
          //  [IN]
          .utmi_dataout_8(utmi_dataout_i[8]),
          //  [IN]
          .utmi_dataout_9(utmi_dataout_i[9]),
          //  [IN]
          .utmi_dataout_10(utmi_dataout_i[10]),
          //  [IN]
          .utmi_dataout_11(utmi_dataout_i[11]),
          //  [IN]
          .utmi_dataout_12(utmi_dataout_i[12]),
          //  [IN]
          .utmi_dataout_13(utmi_dataout_i[13]),
          //  [IN]
          .utmi_dataout_14(utmi_dataout_i[14]),
          //  [IN]
          .utmi_dataout_15(utmi_dataout_i[15]),
          //  [IN]
          .utmi_rxvalid(utmi_rxvalid_i),
          //  [IN]
          .utmi_rxvalidh(utmi_rxvalidh_i),
          //  [IN]
          .utmi_rxactive(utmi_rxactive_i),
          //  [IN]
          .utmi_rxerr(utmi_rxerr_i),
          //  [IN]
          .utmi_dataoe(utmi_dataoe),
          //  [OUT]
          .utmi_ddir(utmi_ddir),
          //  [OUT]
          .utmi_databus16_8(utmi_databus16_8),
          //  [OUT]
          .utmi_hostdisconnect(utmi_hostdisconnect_i),
          //  [IN]
          .utmi_dppulldown(utmi_dppulldown),
          //  [OUT]
          .utmi_dmpulldown(utmi_dmpulldown),
          //  [OUT]
          .utmi_drvvbus(utmi_drvvbus),
          //  [OUT]
          .utmi_chrgvbus(utmi_chrgvbus),
          //  [OUT]
          .utmi_dischrgvbus(utmi_dischrgvbus),
          //  [OUT]
          .utmi_iddig(utmi_iddig_i),
          //  [IN]
          .utmi_idpullup(utmi_idpullup),
          //  [OUT]
          .utmi_avalid(utmi_avalid_i),
          //  [IN]
          .utmi_bvalid(utmi_bvalid_i),
          //  [IN]
          .utmi_vbusvalid(utmi_vbusvalid_i),
          //  [IN]
          .utmi_sessend(utmi_sessend_i),
          //  [IN]
          .utmi_fslsserialmode(utmi_fslsserialmode),
          //  [OUT]
          .utmi_tx_enable_n(utmi_tx_enable_n),
          //  [OUT]
          .utmi_tx_dat(utmi_tx_dat),
          //  [OUT]
          .utmi_tx_se0(utmi_tx_se0),
          //  [OUT]
          .utmi_rx_rcv(utmi_rx_rcv_i),
          //  [IN]
          .utmi_rx_dm(utmi_rx_dm_i),
          //  [IN]
          .utmi_rx_dp(utmi_rx_dp_i),
          //  [IN]
          .utmi_pwrctl_suspend(utmi_pwrctl_suspend_i[0]),
          //  [OUT]
          .utmi_phy_enable(utmi_phy_enable),
          //  [OUT]
          .ulpi_dir(ulpi_dir_i),
          //  [IN]
          .ulpi_stp(ulpi_stp),
          //  [OUT]
          .ulpi_nxt(ulpi_nxt_i),
          //  [IN]
          .ulpi_tx_data_0(ulpi_tx_data[0]),
          //  [OUT]
          .ulpi_tx_data_1(ulpi_tx_data[1]),
          //  [OUT]
          .ulpi_tx_data_2(ulpi_tx_data[2]),
          //  [OUT]
          .ulpi_tx_data_3(ulpi_tx_data[3]),
          //  [OUT]
          .ulpi_tx_data_4(ulpi_tx_data[4]),
          //  [OUT]
          .ulpi_tx_data_5(ulpi_tx_data[5]),
          //  [OUT]
          .ulpi_tx_data_6(ulpi_tx_data[6]),
          //  [OUT]
          .ulpi_tx_data_7(ulpi_tx_data[7]),
          //  [OUT]
          .ulpi_tx_data_nxt_0(ulpi_tx_data_nxt[0]),
          //  [OUT]
          .ulpi_tx_data_nxt_1(ulpi_tx_data_nxt[1]),
          //  [OUT]
          .ulpi_tx_data_nxt_2(ulpi_tx_data_nxt[2]),
          //  [OUT]
          .ulpi_tx_data_nxt_3(ulpi_tx_data_nxt[3]),
          //  [OUT]
          .ulpi_tx_data_nxt_4(ulpi_tx_data_nxt[4]),
          //  [OUT]
          .ulpi_tx_data_nxt_5(ulpi_tx_data_nxt[5]),
          //  [OUT]
          .ulpi_tx_data_nxt_6(ulpi_tx_data_nxt[6]),
          //  [OUT]
          .ulpi_tx_data_nxt_7(ulpi_tx_data_nxt[7]),
          //  [OUT]
          .ulpi_tx_data_oe_0(ulpi_tx_data_oe[0]),
          //  [OUT]
          .ulpi_tx_data_oe_1(ulpi_tx_data_oe[1]),
          //  [OUT]
          .ulpi_tx_data_oe_2(ulpi_tx_data_oe[2]),
          //  [OUT]
          .ulpi_tx_data_oe_3(ulpi_tx_data_oe[3]),
          //  [OUT]
          .ulpi_tx_data_oe_4(ulpi_tx_data_oe[4]),
          //  [OUT]
          .ulpi_tx_data_oe_5(ulpi_tx_data_oe[5]),
          //  [OUT]
          .ulpi_tx_data_oe_6(ulpi_tx_data_oe[6]),
          //  [OUT]
          .ulpi_tx_data_oe_7(ulpi_tx_data_oe[7]),
          //  [OUT]
          .ulpi_rx_data_0(ulpi_rx_data_i[0]),
          //  [IN]
          .ulpi_rx_data_1(ulpi_rx_data_i[1]),
          //  [IN]
          .ulpi_rx_data_2(ulpi_rx_data_i[2]),
          //  [IN]
          .ulpi_rx_data_3(ulpi_rx_data_i[3]),
          //  [IN]
          .ulpi_rx_data_4(ulpi_rx_data_i[4]),
          //  [IN]
          .ulpi_rx_data_5(ulpi_rx_data_i[5]),
          //  [IN]
          .ulpi_rx_data_6(ulpi_rx_data_i[6]),
          //  [IN]
          .ulpi_rx_data_7(ulpi_rx_data_i[7]),
          //  [IN]
          .ulpi_carkit(ulpi_carkit),
          //  [OUT]
          .ulpi_pwrctl_suspend(ulpi_pwrctl_suspend_i[0]),
          //  [OUT]
          .ulpi_phy_enable(ulpi_phy_enable),
          //  [OUT]
          .ser_tx_enable_n(ser_tx_enable_n),
          //  [OUT]
          .ser_tx_dat(ser_tx_dat),
          //  [OUT]
          .ser_tx_se0(ser_tx_se0),
          //  [OUT]
          .ser_rx_rcv(ser_rx_rcv_i),
          //  [IN]
          .ser_rx_dm(ser_rx_dm_i),
          //  [IN]
          .ser_rx_dp(ser_rx_dp_i),
          //  [IN]
          .ser_speed(ser_speed),
          //  [OUT]
          .ser_dppullup(ser_dppullup),
          //  [OUT]
          .ser_dppulldown(ser_dppulldown),
          //  [OUT]
          .ser_dmpulldown(ser_dmpulldown),
          //  [OUT]
          .ser_drvvbus(ser_drvvbus),
          //  [OUT]
          .ser_chrgvbus(ser_chrgvbus),
          //  [OUT]
          .ser_dischrgvbus(ser_dischrgvbus),
          //  [OUT]
          .ser_iddig(ser_iddig_i),
          //  [IN]
          .ser_idpullup(ser_idpullup),
          //  [OUT]
          .ser_avalid(ser_avalid_i),
          //  [IN]
          .ser_bvalid(ser_bvalid_i),
          //  [IN]
          .ser_vbusvalid(ser_vbusvalid_i),
          //  [IN]
          .ser_sessend(ser_sessend_i),
          //  [IN]
          .ser_pwrctl_suspend(ser_pwrctl_suspend_i[0]),
          //  [OUT]
          .ser_phy_enable(ser_phy_enable),
          //  [OUT]
          .pwrctl_suspend_clr(pwrctl_suspend_clr_i[0]),
          //  [IN]
          .pwrctl_wakeup(pwrctl_wakeup),
          //  [IN]
          .vbus_pwr_fault(vbus_pwr_fault));
always @(posedge clk_i or posedge rst_local_a)
   begin : sys_clk_sync_vframe_PROC
   if (rst_local_a == 1'b 1)
      begin
//  asynchronous reset (active high)
      vframe_s1 <= 1'b 0;   //  [IN]
      vframe_s2 <= 1'b 0;   
      end
   else
      begin
      if (rst_local == 1'b 1 | VFRAME_ENABLE == 1'b 0)
         begin
         vframe_s1 <= 1'b 0;   //  rising clock edge
         vframe_s2 <= 1'b 0;   
         end
      else
         begin
         vframe_s1 <= vframe_i;   
         vframe_s2 <= vframe_s1;   
         end
      end
   end
//  vframe support
//  vframe option
//  PROCESS sys_clk_sync_PROC
assign vframe = VUSB_HS_CLOCK_CONFIGURATION >= 0 & VFRAME_ENABLE != 1'b 0 ? vframe_s2 : 
	VFRAME_ENABLE != 1'b 0 ? vframe_i : 
	1'b 0; 
assign up_otg_datard = {32{1'b 0}}; 
assign up_otg_irq = 1'b 0; 
assign up_otg_id = otg_id_state; 
assign otg_autohst2dev_start_reset = 1'b 0; 
assign otg_autohst2dev_set_dev = 1'b 0; 
assign otg_autohst2dev_set_run = 1'b 0; 
assign otg_id_state = 1'b 1; 
assign otg_vbus_chg = 1'b 0; 
assign otg_vbus_dschg = 1'b 0; 
assign otg_dmpulldown = 1'b 0; 
assign otg_data_pulse = 1'b 0; 
assign otg_idpullup = 1'b 0; 
assign otg_autoreset_proceed = 1'b 0; 
assign sess_valid_i = sess_valid == 1'b 1 ? 1'b 1 : 
	1'b 0; 
assign utmi_hostdisconnect_i = 1'b 0; 
assign utmi_iddig_i = 1'b 1; 
assign utmi_avalid_i = sess_valid_i; 
assign utmi_bvalid_i = sess_valid_i; 
assign utmi_vbusvalid_i = sess_valid_i; 
assign utmi_sessend_i = ~sess_valid_i; 
assign ser_iddig_i = 1'b 1; 
assign ser_avalid_i = sess_valid_i; 
assign ser_bvalid_i = sess_valid_i; 
assign ser_vbusvalid_i = sess_valid_i; 
assign ser_sessend_i = ~sess_valid_i; 
assign vbus_pwr_fault = 1'b 0; 
assign utmi_pwrctl_suspend = utmi_pwrctl_suspend_i[0]; 
assign ulpi_pwrctl_suspend = ulpi_pwrctl_suspend_i[0]; 
assign ser_pwrctl_suspend = ser_pwrctl_suspend_i[0]; 
// -------------------------------------------------------------------
//  vusb_hscor: Microprocessor Interface
// -------------------------------------------------------------------

endmodule // module vusb_hs_core_dev_bvci

