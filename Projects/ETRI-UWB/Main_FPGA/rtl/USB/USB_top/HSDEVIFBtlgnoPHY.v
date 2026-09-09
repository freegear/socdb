////////////////////////////////////////////////////////////////////////////////
// File          : $HeadURL: file:///ci/svn/USBCTRL/USBIF/trunk/HSXXXIFxx/rtl_v/HSXXXIFxx.v $                                                    
// Author        : $Author: hhsilva $                                                     
// Project       : USBIF                                                    
// Instances     :                                                              
// Creation date :                                                              
////////////////////////////////////////////////////////////////////////////////
// Description:
//
//   Top level integration module for USB HS-xxx Controller + USB HS PHY
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
// $Date: 2007-02-08 10:37:39 +0000 (Thu, 08 Feb 2007) $                                                                       
// $Revision: 120 $

`timescale 1ns / 1ps
module HSDEVIFBtlgnoPHY (
                 clk                    , // Processor interface clock
                 rst                    , // Processor interface reset
                 scanmode               , // Controller & PHY scan mode (test_mode at controller level)
                 s_penable	        , // Slave AMBA interface
                 s_psel                 , // Slave AMBA interface
                 s_paddr                , // Slave AMBA interface
                 s_pwrite               , // Slave AMBA interface
                 s_pwdata               , // Slave AMBA interface
                 s_prdata               , // Slave AMBA interface
                 s_pready               , // Slave AMBA interface
                 m_haddr	        , // Master AMBA interface
                 m_htrans	        , // Master AMBA interface
                 m_hwrite	        , // Master AMBA interface
                 m_hsize	        , // Master AMBA interface
                 m_hburst	        , // Master AMBA interface
                 m_hprot	        , // Master AMBA interface
                 m_htypeinfo            , // Master AMBA interface
                 m_hwdata	        , // Master AMBA interface
                 m_hrdata	        , // Master AMBA interface
                 m_hready	        , // Master AMBA interface
                 m_hresp	        , // Master AMBA interface
                 m_hbusreq	        , // Master AMBA interface
                 m_hgrant	        , // Master AMBA interface
                 m_hlock	        , // Master AMBA interface
                 interrupt              , // Interrupt for processor
//                 pwrctl_suspend_out     , // To power manager block -> Suspend request from controller
//                 pwrctl_phy_enable      , // To power manager block -> PHY enable request from the controller                 
//                 pwrctl_suspend_in      , // To power manager block -> Suspend input for the PHY
//                 pwrctl_linestate       , // To power manager block -> State of the line from the PHY
//                 pwrctl_suspend_clr     , // To power manager block -> Suspend clear request from the controller
//                 pwrctl_wakeup          , // To power manager block -> Wakeup request for the controller
//                 pwrctl_vbuson          , // To power manager block -> Indication for the Controller that vbus is present
	             pwrctl_utmi_xcvr_clk   , // To power manager block -> Clock from the PHY
//                 pwrctl_port_ind_ctl    , // To power manager block -> Activity LED indication
                 rx_buf_addr_a          , // RX external RAM
                 rx_buf_data_wr_a       , // RX external RAM
                 rx_buf_wr_en_a         , // RX external RAM
                 rx_buf_clk_a           , // RX external RAM
                 rx_buf_addr_b          , // RX external RAM
                 rx_buf_rd_en_b         , // RX external RAM
                 rx_buf_data_rd_b       , // RX external RAM
                 rx_buf_clk_b           , // RX external RAM
                 tx_buf_addr_a          , // TX external RAM
                 tx_buf_data_wr_a       , // TX external RAM
                 tx_buf_wr_en_a         , // TX external RAM
                 tx_buf_clk_a           , // TX external RAM
                 tx_buf_addr_b          , // TX external RAM
                 tx_buf_data_rd_b       , // TX external RAM
                 tx_buf_rd_en_b         , // TX external RAM
                 tx_buf_clk_b           , // TX external RAM
               
				 ctrl_utmi_datain_l     ,
                 ctrl_utmi_dataoe       ,
				 ctrl_utmi_opmode       ,
				 ctrl_utmi_txvalid      ,
				 ctrl_utmi_reset        ,
				 ctrl_utmi_termselect   ,
				 ctrl_utmi_xcvrsel      ,

				 pwrctl_linestate       ,
				 phy_utmi_dataout_l     ,
				 phy_utmi_txready       ,
				 phy_utmi_rxvalid       ,
				 phy_utmi_rxactive      ,
				 phy_utmi_rxerror       ,

				 ctrl_utmi_chrgvbus     ,
				 ctrl_utmi_dischrgvbus  ,
				 pwrctl_suspendn        ,
				 id_dig		            ,
				 idpullup		        ,
						 
				 phy_utmi_hostdisconnect,
				 ctrl_utmi_dmpulldown   ,
				 ctrl_utmi_dppulldown	,
				 sessend		        ,
				 sessvld		        ,
				 vbusvld		        
						 
/*               ,
                 vdda                   , // Analog supply
                 vssa                   , // Analog supply
                 vddp                   , // Analog supply
                 vssp                   , // Analog supply
                 dp                     , // DP line
                 dn                     , // DN line
                 sysclock               , // External clock for the PHY
                 rrefext                , // PHY External reference resistor
                 test_gpanaio           , // PHY analog test point
                 test_utmi_suspend      , // PHY test signal	 
                 test_utmi_xcvr_clk     , // PHY test signal
                 test_utmi_txready      , // PHY test signal
                 test_utmi_dataout      , // PHY test signal
                 test_utmi_rxvalid      , // PHY test signal
                 test_utmi_rxvalidh     , // PHY test signal
                 test_utmi_rxactive     , // PHY test signal
                 test_utmi_rxerror      , // PHY test signal
                 test_utmi_linestate    , // PHY test signal
                 test_utmi_vload        , // PHY test signal
                 test_utmi_vcontrol     , // PHY test signal
                 test_utmi_vstatus      , // PHY test signal
                 test_onbist            , // PHY test signal
                 phy_scanclk            , // PHY scan clock
                 phy_scanina            , // PHY scan shift input
                 phy_scaninb            ,
                 phy_scanen             , // PHY scan enable
                 phy_scanouta           , // PHY scan shift output
                 phy_scanoutb           , // PHY scan shift output
                 test_utmi_databus16_8  , // PHY test signal
                 test_utmi_datain       , // PHY test signal
                 test_utmi_txvalid      , // PHY test signal
                 test_utmi_txvalidh     , // PHY test signal
                 test_utmi_reset        , // PHY test signal
                 test_utmi_xcvrselect   , // PHY test signal
                 test_utmi_termselect   , // PHY test signal
                 test_utmi_opmode       , // PHY test signal
                 testmode_enable          // PHY Test mux enable
 */
                );


`include "vusb_hs_pkg.v"        // file containing translation of VHDL package 'vusb_hs_pkg'

`include "vusb_hs_cfg.v"        // file containing translation of VHDL package 'vusb_hs_cfg'


// Clocks and Resets
input           clk; //  system clock
input           rst; //  reset input

// Scan test enable for controller and PHY
input           scanmode; //  (0) normal mode ; (1) scan test
input           s_penable ;
input           s_psel    ;
input    [8:0]  s_paddr   ;
input           s_pwrite  ;
input    [31:0] s_pwdata  ;
output   [31:0] s_prdata  ;
output          s_pready  ;
output   [31:0] m_haddr   ;
output   [1:0]  m_htrans  ;
output          m_hwrite  ;
output   [2:0]  m_hsize   ;
output   [2:0]  m_hburst  ;
output   [3:0]  m_hprot   ;
output   [BUS_TYPE_INFO_WIDTH-1:0] m_htypeinfo; // 4bits
output   [31:0] m_hwdata  ;
input    [31:0] m_hrdata  ;
input           m_hready  ;
input    [1:0]  m_hresp   ;
output          m_hbusreq ;
input           m_hgrant  ;
output          m_hlock   ;

// System processor interrupt request
output          interrupt; //  Interrupt to the processor

// Power management signals
//output [VUSB_HS_NUM_PORT - 1:0] pwrctl_suspend_out      ; // Suspend output to external power control circuit from the controller
//output [VUSB_HS_NUM_PORT - 1:0] pwrctl_phy_enable       ; // UTMI phy i/f is selected
//input  [VUSB_HS_NUM_PORT - 1:0] pwrctl_suspend_in       ; // Suspend input to the PHY from power control circuit
//output [1:0]                    pwrctl_linestate        ; // State of the line in suspend for the power control circuit
//output [VUSB_HS_NUM_PORT - 1:0] pwrctl_suspend_clr      ;
//input  [VUSB_HS_NUM_PORT - 1:0] pwrctl_wakeup           ;
//input                           pwrctl_vbuson           ;
//output [VUSB_HS_NUM_PORT - 1:0] pwrctl_utmi_xcvr_clk    ;
   input  [VUSB_HS_NUM_PORT - 1:0] pwrctl_utmi_xcvr_clk    ;
//output [1:0]                    pwrctl_port_ind_ctl     ; // LED

// Rx RAM Signals
output   [VUSB_HS_RX_ADD - 1:0] rx_buf_addr_a    ; //  Address bus A
output   [35:0]                 rx_buf_data_wr_a ; //  Data write bus A - bits [35:32] used as a tag
output                          rx_buf_wr_en_a   ; //  Data write enable A
output                          rx_buf_clk_a     ; //  Clock A - connect to pe_clk (see pe_clk notes)
output   [VUSB_HS_RX_ADD - 1:0] rx_buf_addr_b    ; //  Address bus B
output                          rx_buf_rd_en_b   ; //  Data read enable B
input    [35:0]                 rx_buf_data_rd_b ; //  Data read bus B - bits [35:32] used as a tag
output                          rx_buf_clk_b     ; //  Clock B - Connect to system clock

// Tx RAM Signals
output   [VUSB_HS_TX_ADD - 1:0] tx_buf_addr_a    ; //  Address bus A
output   [35:0]                 tx_buf_data_wr_a ; //  Data write bus A - bits [35:32] used as a tag
output                          tx_buf_wr_en_a   ; //  Data write enable A
output                          tx_buf_clk_a     ; //  Clock A - Connect to system clock
output   [VUSB_HS_TX_ADD - 1:0] tx_buf_addr_b    ; //  Address bus B
input    [35:0]                 tx_buf_data_rd_b ; //  Data read bus B - bits [35:32] used as a tag
output                          tx_buf_rd_en_b   ; //  Data read enable B
output                          tx_buf_clk_b     ;

// USB3500 PHY interface
   output [7:0] 				ctrl_utmi_datain_l      ; //1
   output 						ctrl_utmi_dataoe        ;
   output [1:0] 				ctrl_utmi_opmode        ; //1
   output 						ctrl_utmi_txvalid       ; //1
   //output  [VUSB_HS_NUM_PORT-1:0]  ctrl_utmi_txvalidh      ;
   output 						ctrl_utmi_reset         ; //1
   output 						ctrl_utmi_termselect    ; //1
   output [1:0] 				ctrl_utmi_xcvrsel       ; //2
   
   input [1:0] 					pwrctl_linestate            ; //1
   input [7:0] 					phy_utmi_dataout_l          ; //1
   input 						phy_utmi_txready            ; //1
   input 						phy_utmi_rxvalid            ; //1
   //input [VUSB_HS_NUM_PORT-1:0]    phy_utmi_rxvalidh           ;
   input 						phy_utmi_rxactive           ; //1
   input 						phy_utmi_rxerror            ; //1
   
   output 						ctrl_utmi_chrgvbus      ;
   output 						ctrl_utmi_dischrgvbus   ;
   output 						pwrctl_suspendn         ;
   input 						id_dig                  ; // USB type A or B
   output 						idpullup                ;
   //input                        clkout; //pwrctl_utmi_xcvr_clk∑Œ ¥Î√º
   input 						phy_utmi_hostdisconnect ; // no used
   output 						ctrl_utmi_dmpulldown    ;
   output 						ctrl_utmi_dppulldown    ;
   input 						sessend; // no used
   input 						sessvld;
   input 						vbusvld; // no used
      

// PHY analog signals
   /*
inout [VUSB_HS_NUM_PORT-1:0]        vdda;
inout [VUSB_HS_NUM_PORT-1:0]        vssa;
inout [VUSB_HS_NUM_PORT-1:0]        vddp;
inout [VUSB_HS_NUM_PORT-1:0]        vssp;
inout [VUSB_HS_NUM_PORT-1:0]        rrefext;
inout [VUSB_HS_NUM_PORT-1:0]        test_gpanaio;
inout [VUSB_HS_NUM_PORT-1:0]        dp;
inout [VUSB_HS_NUM_PORT-1:0]        dn;
*/
// PHY Permanent signals
   /*
input  [VUSB_HS_NUM_PORT-1:0]       sysclock           ;
wire   [VUSB_HS_NUM_PORT-1:0]       phy_ser_onvbuscmp  ;
wire   [VUSB_HS_NUM_PORT-1:0]       phy_ser_chrgvbus   ;
wire   [VUSB_HS_NUM_PORT-1:0]       phy_ser_dischrgvbus;
wire   [VUSB_HS_NUM_PORT-1:0]       phy_ser_idpullup   ;
output                              test_utmi_xcvr_clk ;
output                              test_utmi_txready  ;
output [15:0]                       test_utmi_dataout  ;
output                              test_utmi_rxvalid  ;
output                              test_utmi_rxvalidh ;
output                              test_utmi_rxactive ;
output                              test_utmi_rxerror  ;
output  [1:0]                       test_utmi_linestate;
input                               test_utmi_vload    ;
input   [3:0]                       test_utmi_vcontrol ;
output  [7:0]                       test_utmi_vstatus  ;
input                               test_onbist        ;
*/
// PHY scan signals
   /*
input  [VUSB_HS_NUM_PORT-1:0]       phy_scanclk;
input  [VUSB_HS_NUM_PORT-1:0]       phy_scanina;
input  [VUSB_HS_NUM_PORT-1:0]       phy_scaninb;
input  [VUSB_HS_NUM_PORT-1:0]       phy_scanen;
output [VUSB_HS_NUM_PORT-1:0]       phy_scanouta;
output [VUSB_HS_NUM_PORT-1:0]       phy_scanoutb;
	*/
// PHY Test Bus - optionaly accessible
   /*
input         testmode_enable;   // 0-Normal mode; 1-Enable external UTMI+ interface
input         test_utmi_suspend;
input         test_utmi_databus16_8;
input  [15:0] test_utmi_datain     ;
input         test_utmi_txvalid    ;
input         test_utmi_txvalidh   ;
input         test_utmi_reset      ;
input   [1:0] test_utmi_xcvrselect ;
input         test_utmi_termselect ;
input   [1:0] test_utmi_opmode     ;
*/

////////////////////////////////////////////////

  
// Not used serial signals
wire [VUSB_HS_NUM_PORT - 1:0] ser_phy_enable;
wire [VUSB_HS_NUM_PORT - 1:0] ser_pwrctl_suspend;
wire [VUSB_HS_NUM_PORT - 1:0] ser_tx_se0;
wire [VUSB_HS_NUM_PORT - 1:0] ser_tx_dat;
wire [VUSB_HS_NUM_PORT - 1:0] ser_tx_enable_n;
wire [VUSB_HS_NUM_PORT - 1:0] ser_speed;
wire [VUSB_HS_NUM_PORT - 1:0] ser_drvvbus;

// Not used ULPI signals
wire [VUSB_HS_NUM_PORT-1:0] ulpi_phy_enable;
wire [VUSB_HS_NUM_PORT-1:0] ulpi_pwrctl_suspend;
wire [VUSB_HS_NUM_PORT-1:0] ulpi_carkit;
wire [VUSB_HS_NUM_PORT-1:0] ulpi_stp;
wire [7:0] ulpi_tx_data_oe;                     
wire [7:0] ulpi_tx_data_nxt;                     
wire [7:0] ulpi_tx_data;                          

// Not used UTMI bi-directional signals
wire [VUSB_HS_NUM_PORT-1:0] utmi_ddir;
   
wire [VUSB_HS_NUM_PORT-1:0] utmi_dataoe; // using for FPGA

// Internal signals
wire [VUSB_HS_NUM_PORT-1:0]     ctrl_utmi_databus16_8   ;
wire  [15:0]                    ctrl_utmi_datain        ;
wire  [1:0]                     ctrl_utmi_opmode        ;
wire  [VUSB_HS_NUM_PORT-1:0]    ctrl_utmi_txvalid       ;
wire  [VUSB_HS_NUM_PORT-1:0]    ctrl_utmi_txvalidh      ;
wire  [VUSB_HS_NUM_PORT-1:0]    ctrl_utmi_reset         ;
wire  [VUSB_HS_NUM_PORT-1:0]    ctrl_utmi_termselect    ;
wire                            ctrl_utmi_xcvrselect ;

//wire                            phy_utmi_idpullup    ;
//wire                            phy_utmi_chrgvbus    ;
//wire                            phy_utmi_dischrgvbus ;
/*
wire [VUSB_HS_NUM_PORT-1:0]     phy_utmi_databus16_8    ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_utmi_txvalid        ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_utmi_txvalidh       ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_utmi_reset          ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_utmi_termselect     ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_utmi_dmpulldown     ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_utmi_dppulldown     ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_utmi_suspend        ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_utmi_vload          ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_onbist              ;
wire [VUSB_HS_NUM_PORT*16-1:0]  phy_utmi_datain             ;
wire [VUSB_HS_NUM_PORT*2-1:0]   phy_utmi_xcvrselect         ;
wire [VUSB_HS_NUM_PORT*2-1:0]   phy_utmi_opmode             ;
wire [VUSB_HS_NUM_PORT*4-1:0]   phy_utmi_vcontrol           ;
*/
//wire [VUSB_HS_NUM_PORT-1:0]     phy_utmi_txready            ;
//wire [VUSB_HS_NUM_PORT-1:0]     phy_utmi_rxvalid            ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_utmi_rxvalidh           ;
//wire [VUSB_HS_NUM_PORT-1:0]     phy_utmi_rxactive           ;
//wire [VUSB_HS_NUM_PORT-1:0]     phy_utmi_rxerror            ;
//wire [VUSB_HS_NUM_PORT-1:0]     phy_utmi_hostdisconnect     ;
wire [VUSB_HS_NUM_PORT*16-1:0]  phy_utmi_dataout            ;
//wire [VUSB_HS_NUM_PORT*8-1:0]   phy_utmi_vstatus            ;
//wire [VUSB_HS_NUM_PORT*2-1:0]   pwrctl_linestate            ;
/*
wire [VUSB_HS_NUM_PORT-1:0]     phy_ser_ondiffrec       ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_ser_onserec         ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_ser_ondrv           ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_ser_datarpu2        ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_ser_dppullup        ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_ser_tx_se0          ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_ser_tx_enable_n     ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_ser_tx_data         ;
wire [VUSB_HS_NUM_PORT-1:0]     phy_ser_rx_rcv          ;
wire                            test_ser_ondiffrec      ;
wire                            test_ser_onserec        ;
wire                            test_ser_ondrv          ;
wire                            test_ser_datarpu2       ;
wire                            test_ser_dppullup       ;
wire                            test_ser_tx_se0         ;
wire                            test_ser_tx_enable_n    ;
wire                            test_ser_tx_data        ;
wire                            test_ser_vbusvalid      ;
wire                            test_ser_avalid         ;
wire                            test_ser_bvalid         ;
wire                            test_ser_sessend        ;
wire                            test_ser_iddig          ;
wire                            test_ser_dp             ;
wire                            test_ser_dm             ;
wire                            test_ser_rx_rcv         ;
wire [VUSB_HS_NUM_PORT-1:0]     ctrl_ser_ondiffrec      ;
wire [VUSB_HS_NUM_PORT-1:0]     ctrl_ser_onserec        ;
wire [VUSB_HS_NUM_PORT-1:0]     ctrl_ser_ondrv          ;
wire [VUSB_HS_NUM_PORT-1:0]     ctrl_ser_datarpu2       ;
 */
wire [VUSB_HS_NUM_PORT-1:0]     ctrl_ser_dppullup       ;
//wire [VUSB_HS_NUM_PORT-1:0]     ctrl_ser_tx_se0         ;
   
wire [VUSB_HS_NUM_PORT-1:0]     ctrl_in_ser_tx_se0      ;
wire [VUSB_HS_NUM_PORT-1:0]     ctrl_ser_tx_enable_n    ;
wire [VUSB_HS_NUM_PORT-1:0]     ctrl_ser_tx_data        ;
wire [VUSB_HS_NUM_PORT-1:0]     ctrl_in_ser_tx_data     ;
wire [VUSB_HS_NUM_PORT-1:0]     muxed_xcvr_clk          ;


   wire [31:0] 					s_prdata  ;
   wire 						s_pready  ;
   wire [31:0] 					m_haddr   ;
   wire [1:0] 					m_htrans  ;
   wire 						m_hwrite  ;
   wire [2:0] 					m_hsize   ;
   wire [2:0] 					m_hburst  ;
   wire [3:0] 					m_hprot   ;
   wire [BUS_TYPE_INFO_WIDTH-1:0] m_htypeinfo; // 4bits
   wire [31:0] 					  m_hwdata  ;
   wire 						  m_hbusreq ;
   wire 						  m_hlock   ;

   
   wire 						pwrctl_suspend_out;
   
   wire [1:0] 					ctrl_utmi_xcvrsel = {1'b0,ctrl_utmi_xcvrselect};
   wire 						ctrl_utmi_chrgvbus = 1'b0;
   wire 						ctrl_utmi_dischrgvbus = 1'b0;
   wire 						ctrl_utmi_dataoe = utmi_dataoe;
   wire 						idpullup = 1'b0;
   wire 						ctrl_utmi_dmpulldown = 1'b0;
   wire 						ctrl_utmi_dppulldown = 1'b0;
   assign 						phy_utmi_dataout = {8'h00,phy_utmi_dataout_l};
   wire [7:0] 					ctrl_utmi_datain_l = ctrl_utmi_datain[7:0];

   wire 						pwrctl_suspendn = ~pwrctl_suspend_out;
   
   assign 						phy_utmi_rxvalidh = 1'b0;
   wire 						pwrctl_wakeup = 1'b0; //?
   wire 						pwrctl_vbuson = sessvld;
   //wire 						pwrctl_vbuson = vbusvld;
   wire [1:0] 					pwrctl_port_ind_ctl     ; // LED   
   wire 						pwrctl_suspend_clr; // no used
   
   
scanclkmux  u_scanclkmux    (
                            .scanmode       (scanmode               ),
                            .clk            (clk                    ),
                            .xcvr_clk       (pwrctl_utmi_xcvr_clk   ),
                            .muxed_xcvr_clk (muxed_xcvr_clk         )
                            );

   vusb_hs_core_dev_amba_apb    CTRL
	 (
      .clk                    (clk                    ),
      .rst                    (rst                    ),
      .aux_clk                (1'b0                   ),
      .xcvr_clk               (muxed_xcvr_clk         ),
      .xcvr_ser_clk           (muxed_xcvr_clk /*1'b0 */                  ),
      .test_mode              (scanmode               ),
      .s_penable              (s_penable              ),
      .s_psel                 (s_psel                 ),
      .s_paddr                (s_paddr                ),
      .s_pwrite               (s_pwrite               ),
      .s_pwdata               (s_pwdata               ),
      .s_prdata               (s_prdata               ),
      .s_pready               (s_pready               ),
      .m_haddr                (m_haddr                ),
      .m_htrans               (m_htrans               ),
      .m_hwrite               (m_hwrite               ),
      .m_hsize                (m_hsize                ),
      .m_hburst               (m_hburst               ),
      .m_hprot                (m_hprot                ),
      .m_htypeinfo            (m_htypeinfo            ),
      .m_hwdata               (m_hwdata               ),
      .m_hrdata               (m_hrdata               ),
      .m_hready               (m_hready               ),
      .m_hresp                (m_hresp                ),
      .m_hbusreq              (m_hbusreq              ),
      .m_hgrant               (m_hgrant               ),
      .m_hlock                (m_hlock                ),
      .interrupt              (interrupt              ),
	  
      .utmi_reset             (ctrl_utmi_reset        ),
      .utmi_xcvrselect        (ctrl_utmi_xcvrselect   ),
      .utmi_linestate         (pwrctl_linestate       ),
      .utmi_opmode            (ctrl_utmi_opmode       ),
      .utmi_datain            (ctrl_utmi_datain       ),
      .utmi_dataout           (phy_utmi_dataout       ),
      .utmi_termselect        (ctrl_utmi_termselect   ),
      .utmi_txvalid           (ctrl_utmi_txvalid      ),
      .utmi_txvalidh          (ctrl_utmi_txvalidh     ),
      .utmi_txready           (phy_utmi_txready       ),
      .utmi_rxvalid           (phy_utmi_rxvalid       ),
      .utmi_rxvalidh          (phy_utmi_rxvalidh      ),
      .utmi_rxactive          (phy_utmi_rxactive      ),
      .utmi_rxerr             (phy_utmi_rxerror       ),
      .utmi_dataoe            (utmi_dataoe            ), // Not used
      .utmi_ddir              (utmi_ddir              ), // Not used
      .utmi_databus16_8       (ctrl_utmi_databus16_8  ),
      .utmi_pwrctl_suspend    (pwrctl_suspend_out     ),
      .utmi_phy_enable        (pwrctl_phy_enable      ),

      .sess_valid             (pwrctl_vbuson          ), // Input from external VBUS presence detector. DEV only
      .ulpi_dir               ({VUSB_HS_NUM_PORT{1'b0}}), //
      .ulpi_stp               (ulpi_stp               ), // Not connected
      .ulpi_nxt               ({VUSB_HS_NUM_PORT{1'b0}}), ///
      .ulpi_tx_data           (ulpi_tx_data           ),
      .ulpi_tx_data_nxt       (ulpi_tx_data_nxt       ),
      .ulpi_tx_data_oe        (ulpi_tx_data_oe        ),
      .ulpi_rx_data           (8'b00000000            ),
      .ulpi_carkit            (ulpi_carkit            ),
      .ulpi_pwrctl_suspend    (ulpi_pwrctl_suspend    ),
      .ulpi_phy_enable        (ulpi_phy_enable        ),
      .ser_tx_enable_n        (ctrl_ser_tx_enable_n   ),
      .ser_tx_dat             (ctrl_in_ser_tx_data    ),
      .ser_tx_se0             (ctrl_in_ser_tx_se0     ),
      .ser_rx_rcv             ({VUSB_HS_NUM_PORT{1'b0}}),
      .ser_rx_dm              ({VUSB_HS_NUM_PORT{1'b0}}),
      .ser_rx_dp              ({VUSB_HS_NUM_PORT{1'b0}}),
      .ser_dppullup           (ctrl_ser_dppullup      ),
      .ser_pwrctl_suspend     (ser_pwrctl_suspend     ), 
      .ser_phy_enable         (ser_phy_enable         ), 
      .pwrctl_suspend_clr     (pwrctl_suspend_clr     ),
      .pwrctl_wakeup          (pwrctl_wakeup          ),
      .port_ind_ctl           (pwrctl_port_ind_ctl    ),
      .rx_buf_addr_a          (rx_buf_addr_a          ),
      .rx_buf_data_wr_a       (rx_buf_data_wr_a       ),
      .rx_buf_wr_en_a         (rx_buf_wr_en_a         ),
      .rx_buf_clk_a           (rx_buf_clk_a           ),
      .rx_buf_addr_b          (rx_buf_addr_b          ),
      .rx_buf_rd_en_b         (rx_buf_rd_en_b         ),
      .rx_buf_data_rd_b       (rx_buf_data_rd_b       ),
      .rx_buf_clk_b           (rx_buf_clk_b           ),
      .tx_buf_addr_a          (tx_buf_addr_a          ),
      .tx_buf_data_wr_a       (tx_buf_data_wr_a       ),
      .tx_buf_wr_en_a         (tx_buf_wr_en_a         ),
      .tx_buf_clk_a           (tx_buf_clk_a           ),
      .tx_buf_addr_b          (tx_buf_addr_b          ),
      .tx_buf_data_rd_b       (tx_buf_data_rd_b       ),
      .tx_buf_rd_en_b         (tx_buf_rd_en_b         ),
      .tx_buf_clk_b           (tx_buf_clk_b           )
      );
/*

// UTMI+ Test Mux

testmux u_testmux(
                  .ctrl_reset              (rst                       ),
		  .scanmode                (scanmode                  ),
                  .testmode_enable         (testmode_enable           ),
                  .phy_ser_vbusvalid       ({VUSB_HS_NUM_PORT{1'b0}}),
                  .phy_ser_avalid          ({VUSB_HS_NUM_PORT{1'b0}}),
                  .phy_ser_bvalid          ({VUSB_HS_NUM_PORT{1'b0}}),
                  .phy_ser_sessend         ({VUSB_HS_NUM_PORT{1'b0}}),
                  .phy_ser_iddig           ({VUSB_HS_NUM_PORT{1'b0}}),
                  .phy_ser_dp              ({VUSB_HS_NUM_PORT{1'b0}}),
                  .phy_ser_dm              ({VUSB_HS_NUM_PORT{1'b0}}),
                  .phy_ser_rx_rcv          ({VUSB_HS_NUM_PORT{1'b0}}),

                  .test_ser_onvbuscmp      (1'b0                    ),
                  .test_ser_ondiffrec      (1'b0                    ),
                  .test_ser_onserec        (1'b0                    ),
                  .test_ser_ondrv          (1'b0                    ),
                  .test_ser_datarpu2       (1'b0                    ),
                  .test_ser_dppullup       (1'b0                    ),
                  .test_ser_chrgvbus       (1'b0                    ),
                  .test_ser_dischrgvbus    (1'b0                    ),
                  .test_ser_idpullup       (1'b0                    ),
                  .test_ser_tx_se0         (1'b0                    ),
                  .test_ser_tx_enable_n    (1'b0                    ),
                  .test_ser_tx_data        (1'b0                    ),
                                                                  
                  .ctrl_ser_onvbuscmp      ({VUSB_HS_NUM_PORT{1'b0}}),
                  .ctrl_ser_ondiffrec      ({VUSB_HS_NUM_PORT{1'b0}}),
                  .ctrl_ser_onserec        ({VUSB_HS_NUM_PORT{1'b0}}),
                  .ctrl_ser_ondrv          ({VUSB_HS_NUM_PORT{1'b0}}),
                  .ctrl_ser_datarpu2       ({VUSB_HS_NUM_PORT{1'b0}}),
                  .ctrl_ser_dppullup       ({VUSB_HS_NUM_PORT{1'b0}}),
                  .ctrl_ser_chrgvbus       ({VUSB_HS_NUM_PORT{1'b0}}),
                  .ctrl_ser_dischrgvbus    ({VUSB_HS_NUM_PORT{1'b0}}),
                  .ctrl_ser_idpullup       ({VUSB_HS_NUM_PORT{1'b0}}),
                  .ctrl_ser_tx_se0         ({VUSB_HS_NUM_PORT{1'b0}}),
                  .ctrl_ser_tx_enable_n    ({VUSB_HS_NUM_PORT{1'b0}}),
                  .ctrl_ser_tx_data        ({VUSB_HS_NUM_PORT{1'b0}}),

                  .test_utmi_databus16_8   (test_utmi_databus16_8     ),
                  .test_utmi_datain        (test_utmi_datain          ),
                  .test_utmi_txvalid       (test_utmi_txvalid         ),
                  .test_utmi_txvalidh      (test_utmi_txvalidh        ),
                  .test_utmi_reset         (test_utmi_reset           ),
                  .test_utmi_xcvrselect    (test_utmi_xcvrselect      ),
                  .test_utmi_termselect    (test_utmi_termselect      ),
                  .test_utmi_opmode        (test_utmi_opmode          ),
                  .test_utmi_vload         (test_utmi_vload           ),
                  .test_utmi_vcontrol      (test_utmi_vcontrol        ),
                  .test_onbist             (test_onbist               ),
		  .test_utmi_suspend       (test_utmi_suspend         ),
		  .ctrl_utmi_databus16_8   (ctrl_utmi_databus16_8     ),
                  .ctrl_utmi_datain        (ctrl_utmi_datain          ),
                  .ctrl_utmi_opmode        (ctrl_utmi_opmode          ),
		  .ctrl_utmi_xcvrselect    ({1'b0,ctrl_utmi_xcvrselect}),
                  .ctrl_utmi_txvalid       (ctrl_utmi_txvalid         ),
                  .ctrl_utmi_txvalidh      (ctrl_utmi_txvalidh        ),
                  .ctrl_utmi_reset         (ctrl_utmi_reset           ),
                  .ctrl_utmi_termselect    (ctrl_utmi_termselect      ),
                  .pwrctl_suspend_in       (pwrctl_suspend_in         ),
                  .phy_utmi_xcvr_clk       (pwrctl_utmi_xcvr_clk      ),
                  .phy_utmi_txready        (phy_utmi_txready          ),
                  .phy_utmi_dataout        (phy_utmi_dataout          ),
                  .phy_utmi_linestate      (pwrctl_linestate          ),
                  .phy_utmi_vstatus        (phy_utmi_vstatus          ),
		  .phy_utmi_rxvalid        (phy_utmi_rxvalid          ),
		  .phy_utmi_rxvalidh       (phy_utmi_rxvalidh         ),
		  .phy_utmi_rxactive       (phy_utmi_rxactive         ),
		  .phy_utmi_rxerror        (phy_utmi_rxerror          ),
		  .phy_utmi_hostdisconnect (phy_utmi_hostdisconnect   ),
                  .test_utmi_vstatus       (test_utmi_vstatus         ),                  
		  .test_utmi_idpullup      (1'b0                      ),
		  .test_utmi_chrgvbus      (1'b0                      ),
		  .test_utmi_dischrgvbus   (1'b0                      ),
		  .test_utmi_dmpulldown    (1'b0                      ),
		  .test_utmi_dppulldown    (1'b0                      ),
                  .test_utmi_xcvr_clk      (test_utmi_xcvr_clk        ),
		  .test_utmi_txready       (test_utmi_txready         ),
		  .test_utmi_dataout       (test_utmi_dataout         ),
		  .test_utmi_rxvalid       (test_utmi_rxvalid         ),
		  .test_utmi_rxvalidh      (test_utmi_rxvalidh        ),
		  .test_utmi_rxactive      (test_utmi_rxactive        ),
		  .test_utmi_rxerror       (test_utmi_rxerror         ),
		  .test_utmi_linestate     (test_utmi_linestate       ),
		  .test_utmi_hostdisconnect(                          ),
                  .test_utmi_avalid        (                          ),
		  .test_utmi_bvalid        (                          ),
		  .test_utmi_vbusvalid     (                          ),
		  .test_utmi_endsession    (                          ),
		  .test_utmi_iddig         (                          ),
		  .ctrl_utmi_idpullup      (1'b0                      ),
		  .ctrl_utmi_chrgvbus      (1'b0                      ),
		  .ctrl_utmi_dischrgvbus   (1'b0                      ),
		  .ctrl_utmi_dmpulldown    (1'b0                      ),
		  .ctrl_utmi_dppulldown    (1'b0                      ),
                  .phy_utmi_databus16_8    (phy_utmi_databus16_8      ),
                  .phy_utmi_datain         (phy_utmi_datain           ),
                  .phy_utmi_xcvrselect     (phy_utmi_xcvrselect       ),
                  .phy_utmi_opmode         (phy_utmi_opmode           ),
                  .phy_utmi_vcontrol       (phy_utmi_vcontrol         ),
                  .phy_utmi_txvalid        (phy_utmi_txvalid          ),
		  .phy_utmi_txvalidh       (phy_utmi_txvalidh         ),
		  .phy_utmi_reset          (phy_utmi_reset            ),
		  .phy_utmi_termselect     (phy_utmi_termselect       ),
		  .phy_utmi_dmpulldown     (phy_utmi_dmpulldown       ),
		  .phy_utmi_dppulldown     (phy_utmi_dppulldown       ),
		  .phy_utmi_suspend        (phy_utmi_suspend          ),
                  .phy_utmi_vload          (phy_utmi_vload            ),                  
                  .phy_onbist              (phy_onbist                ),                  
		  .phy_utmi_avalid         (1'b0                      ),
		  .phy_utmi_bvalid         (1'b0                      ),
		  .phy_utmi_vbusvalid      (1'b0                      ),
		  .phy_utmi_endsession     (1'b0                      ),
		  .phy_utmi_iddig          (1'b0                      ),
		  .phy_utmi_idpullup       (phy_utmi_idpullup         ),
		  .phy_utmi_chrgvbus       (phy_utmi_chrgvbus         ),
		  .phy_utmi_dischrgvbus    (phy_utmi_dischrgvbus      ),
                  
                  .phy_ser_onvbuscmp       (phy_ser_onvbuscmp         ),
                  .phy_ser_ondiffrec       (phy_ser_ondiffrec         ),
                  .phy_ser_onserec         (phy_ser_onserec           ),
                  .phy_ser_ondrv           (phy_ser_ondrv             ),
                  .phy_ser_datarpu2        (phy_ser_datarpu2          ),
                  .phy_ser_dppullup        (phy_ser_dppullup          ),
                  .phy_ser_chrgvbus        (phy_ser_chrgvbus          ),
                  .phy_ser_dischrgvbus     (phy_ser_dischrgvbus       ),
                  .phy_ser_tx_se0          (phy_ser_tx_se0            ),
                  .phy_ser_tx_enable_n     (phy_ser_tx_enable_n       ),
                  .phy_ser_tx_data         (phy_ser_tx_data           ),
                  .phy_ser_idpullup        (phy_ser_idpullup          ),
                  
                  .test_ser_vbusvalid      (test_ser_vbusvalid        ),
                  .test_ser_avalid         (test_ser_avalid           ),
                  .test_ser_bvalid         (test_ser_bvalid           ),
                  .test_ser_sessend        (test_ser_sessend          ),
                  .test_ser_iddig          (test_ser_iddig            ),
                  .test_ser_dp             (test_ser_dp               ),
                  .test_ser_dm             (test_ser_dm               ),
                  .test_ser_rx_rcv         (test_ser_rx_rcv           )
                  
                 );

CI12338tl  PHY(
                        .vdda               (vdda                       ),
                        .vssa               (vssa                       ),
                        .vddp               (vddp                       ),
                        .vssp               (vssp                       ),
                        .dp                 (dp                         ),
                        .dn                 (dn                         ),
                        .sysclock           (sysclock                   ),
                        .sieclock           (pwrctl_utmi_xcvr_clk       ),
                        .databus16_8        (phy_utmi_databus16_8       ),
                        .datain             (phy_utmi_datain            ),
                        .txvalid            (phy_utmi_txvalid           ),
                        .txvalidh           (phy_utmi_txvalidh          ),
                        .txready            (phy_utmi_txready           ),
                        .dataout            (phy_utmi_dataout           ),
                        .rxvalid            (phy_utmi_rxvalid           ),
                        .rxvalidh           (phy_utmi_rxvalidh          ),
                        .rxactive           (phy_utmi_rxactive          ),
                        .rxerror            (phy_utmi_rxerror           ),
                        .reset              (phy_utmi_reset             ),
                        .suspend            (phy_utmi_suspend           ),
                        .xcvrsel            (phy_utmi_xcvrselect        ),
                        .termsel            (phy_utmi_termselect        ),
                        .opmode             (phy_utmi_opmode            ),
                        .linestate          (pwrctl_linestate           ),
                        .rrefext            (rrefext                    ),
                        .vload              (phy_utmi_vload             ),
                        .vcontrol           (phy_utmi_vcontrol          ),
                        .vstatus            (phy_utmi_vstatus           ),
                        .scanmode           (scanmode                   ),
                        .scanclk            (phy_scanclk                ),
                        .scanina            (phy_scanina                ),
                        .scaninb            (phy_scaninb                ),
                        .scanen             (phy_scanen                 ),
                        .scanouta           (phy_scanouta               ),
                        .scanoutb           (phy_scanoutb               ),
                        .hostdisconnect     (phy_utmi_hostdisconnect    ),
                        .txsezero           (1'b0                       ), //
                        .fslsserialmode     (1'b0                       ), //
                        .txenablez          (1'b1                       ), //
                        .txdata             (1'b0                       ), //
                        .txbitstuffenable   (1'b0                       ), // UTMI serial mode.
                        .txbitstuffenableH  (1'b0                       ), //
                        .rxdp               (                           ), //
                        .rxdm               (                           ), //
                        .rxrcv              (                           ), //
                        .dnpulldown         (phy_utmi_dmpulldown        ),
                        .dppulldown         (phy_utmi_dppulldown        ),
                        .conf1              ({VUSB_HS_NUM_PORT{1'b0}}   ),
                        .setin12            ({VUSB_HS_NUM_PORT{1'b0}}   ), //24Mhz
                        .vbg                (                           ),
                        .ibiascp            (                           ),
                        .onbist             (phy_onbist                 ),
                        .gpanaio            (test_gpanaio               )
                        );
*/
endmodule



