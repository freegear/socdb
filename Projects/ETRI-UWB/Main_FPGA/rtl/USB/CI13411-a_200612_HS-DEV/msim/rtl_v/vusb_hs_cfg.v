/*******************************************************************************

-- File Type:    Verilog HDL 
-- Tool Version: VHDL2verilog  v5.6.4 Fri Apr 11 2003 Linux 2.4.2-2 
-- VHDL translation of package (except components) 'vusb_hs_cfg'

*******************************************************************************/
// ------------------------------------------------------------------------------
//  File          : $HeadURL: file:///ci/svn/USBCTRL/HSCTRL/tags/HSCTRL_1.1.A/digital/design/hsctrl/rtl_vhdl/vusb_hs_cfg.vhdl $                                                    
//  Author        : $Author: apacheco $                                                     
//  Project       : HSCTRL                                                    
//  Instances     :                                                              
//  Creation date :                                                              
// ------------------------------------------------------------------------------
//  Description:
// 
//    User configurable core options.  Please read comments below
//    and refer to core documentation for more info.
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
//  $Date: 2006-12-11 15:42:58 +0000 (Mon, 11 Dec 2006) $                                                                       
//  $Revision: 504 $                                                                   
// ---------------------------------------------------------------------------
//  System Configuration Options
// ---------------------------------------------------------------------------
// 
//  The VUSB_HS_RESET_TYPE constant determines the reset type used in the core.
//    0 = Use Synchronous Resets
//    1 = Use Asynchronous Resets
// 
// 
//  The VUSB_HS_RESET_OPTIONAL constant determines if various register files
//  are connected to the main reset.  For the Multi-port host product,
//  there are large numbers of flops that it is not necessary to reset.
//  Some ASIC flows and require that 100% of all flops have a reset and
//  the constant can ensure that all flops have a reset.
// 
//  For the Multi-Host products, adding resets to all flops can add an
//  additional 6k gates or more.  (varies by technology)
// 
//  Note: This constant is only relevent for the Multi-port host product.
//        Device-Only, OTG, and Single host products to not have flops
//        with optional resets.  Value is don't care 
// 
//  Note: By default, all flops are reset in the core except the following:
//      (MPH-Only): TT Contexts in vusb_hs_dma_hst_sm & vusb_hs_dma_traf_tt.
//      (MPH-Only): TT FIFOs in vusb_hs_tt_rx_buf & vusb_hs_tt_tx_buf.
// 
//  0 = Reset all flops except those listed above.
//  1 = Reset 100% of flops.
// 
parameter VUSB_HS_RESET_TYPE = 1; //  [0,1]
parameter VUSB_HS_RESET_OPTIONAL = 1; //  [0,1]
// 
//  The VUSB_HS_CLOCK_CONFIGURATION constant determines the clocking used in the core
//  See reference manual for a description of the clocking modes available.
// 
//    0 = xcvr_clk_0 = pe_clk = clk (do not select for multi-port host product)
//    1 = xcvr_clk_0 < pe_clk = clk
//    2 = xcvr_clk_0 = pe_clk <> clk (do not select for multi-port host product)
//    3 = xcvr_clk_0 < pe_clk <> clk
parameter VUSB_HS_CLOCK_CONFIGURATION = 2; //  [0,1,2,3]
// 
//  phy size (UTMI Only)
//  Set according to the data width of the transciever connected to the core.
//    0 = 8 bit wide data bus [60MHz clock from the transciever]
//    1 = 16 bit wide data bus [30MHZ clock from the transciever]
//    2 = software programmable reset to 8-bit width
//    3 = software programmable reset to 16-bit width
//  NOTE: options 2,3 are not recommended when VUSB_HS_CLOCK_CONFIGURATION = 0
parameter VUSB_HS_PHY16_8 = 0; //  [0,1,2,3]
//  This constant selects which phy is being used
//  0 = UTMI/UMTI+
//  1 = Reserved
//  2 = ULPI
//  3 = Serial Only
//  4 = Software programmable - reset to UTMI
//  5 = Reserved
//  6 = Software programmable - reset to ULPI
//  7 = Software programmable - reset to Serial
//  NOTE: options 4,5,6,7 are not recommended when VUSB_HS_CLOCK_CONFIGURATION = 0
parameter VUSB_HS_PHY_TYPE = 0; //  [0,2,3,4,6,7]
//  derived constants ; must set to match VUSB_HS_PHY_TYPE above according the attached instructions.
parameter VUSB_HS_PHY_UTMI = 1; //  [0,1] ; set to 0 if VUSB_HS_PHY_TYPE=1,2,3       else 1
parameter VUSB_HS_PHY_ULPI = 0; //  [0,1] ; set to 0 if VUSB_HS_PHY_TYPE=0,1,3       else 1
//  This constant selects that the serial engine is used in place of the
//  parallel signalling for UTMI+ and ULPI.  Note: if serial
//  mode is enabled with a ULPI PHY, the parallel signalling
//  will be used 
//  0 - No Serial Engine      - Always use parallel signalling
//  1 - Serial Engine Present - Always use serial signalling for FS/LS
//  2 - Software programmable - Reset to use parallel signalling for FS/LS
//  3 - Software programmable - Reset to use serial signalling for FS/LS
//  NOTE: Must set to 1 if PHY_TYPE=3
//  NOTE: option 0 slims gate count by removing all logic necessary in the serial engine
parameter VUSB_HS_PHY_SERIAL = 0; 
// ---------------------------------------------------------------------------
//  Device Configuration 
// ---------------------------------------------------------------------------
// 
//  The VUSB_HS_DEV_EP constant represents the total number of endpoints.
// 
//  ** NOTE ** : VUSB_HS_DEV_EP should be set to 1 for host only implementations,
//  ** NOTE ** : VUSB_HS_DEV_EP_ADD must be updated when the VUSB_HS_DEV_EP is changed.
// 
parameter VUSB_HS_DEV_EP = 2; //  [2,3,...,16]
//  set the VUSB_HS_DEV_EP_ADD equal to max(1, log2(VUSB_HS_DEV_EP))
parameter VUSB_HS_DEV_EP_ADD = 1; 
// ---------------------------------------------------------------------------
//  Multi-port Host Configuration
// ---------------------------------------------------------------------------
//  The VUSB_HS_NUM_PORT constant specifies the number of downstream ports
//  supported by the host controller.  This constant is only relevant for
//  for the multi-port host product.  Leave 1 for device, otg, and single port host
//  products.
// 
//  Maximum: 8 downstream ports.
// 
parameter VUSB_HS_NUM_PORT = 1; //  [1,2,...,8]
// 
//  The VUSB_HS_MULTI_PORT_FREQ_LOCKED is only to be altered for the multi-port
//  host product.  Leave 0 for device, OTG, and single port host.
// 
//  Set VUSB_HS_MULTI_PORT_FREQ_LOCKED to 1 if and only if all the 30/60Mhz
//  xcvr_clk inputs AND the xcvr_ser_clk input are frequency locked.  That is,
//  all the clocks use a common timebase oscillator or share a PLL that ensures
//  that there is not frequency drift over time.  The xcvr_clk & xcvr_ser_clk input
//  clocks need not be phase aligned to one another.
// 
//  The effect of setting VUSB_HS_MULTI_PORT_FREQ_LOCKED will ensure
//  that the jitter alignment circuit is operating to minimize SOF
//  jitter on each port and ensure compliance to the frame repeatability
//  inteval in the USB specification.  DANGER! if the ports are not locked in
//  frequency, then setting this constant to a 1 will cause the SOF
//  jitter to be worsened.  If multi-port and the clocks are
//  independant on each port, then the jitter alignment circuit is
//  disabled and a +/- 2 clock SOF jitter may be seen each port which
//  is a violation of the USB 2.0 specification but historically has
//  not caused inoperability problems.
// 
//  Contact support if there is any doubt before setting this constant to a 1.
// 
parameter VUSB_HS_MULTI_PORT_FREQ_LOCKED = 0; //  [0,1]
// ---------------------------------------------------------------------------
//  Host Configuration - Internal Transaction Translator
// ---------------------------------------------------------------------------
//  These constants define how many periodic contexts the internal TT can support.
// 
//  Note1: These constants are only relevent for the multi-port host product.
//  Note2: The number of async. contexts should not be adjusted.
// 
//  USB 2.0 spec requires 16 periodic contexts for a hub TT although this seems unncessarily
//  big for an embedded application where limits can be imposed on the downstream applications.
//  Changing the  number from 16 to 4 will significantly reduce gate count but be cautioned
//  that this will impose limits on the number of downstream periodic (ISO/Interrupt) transactions.
// 
//  The simplifying limit imposed when the number of periodic contexts is reduced to 4 is
//  that the application can send no more than 4 periodic (ISO/Interrupt) packets per
//  frame to the downstream Full and Low-Speed devices. Whereas, when the number
//  of periodic contexts are 16, its possible to pipeline packets accross the
//  microframes and send as many periodic packets per frame as can be scheduled (> 16).
// 
parameter VUSB_HS_TT_ASYNC_CONTEXTS = 2; //  DO NOT CHANGE
parameter VUSB_HS_TT_ASYNC_CONTEXTS_ADDR = 1; //  DO NOT CHANGE ; max(1,log2(VUSB_HS_TT_ASYNC_CONTEXTS))
parameter VUSB_HS_TT_PERIODIC_CONTEXTS = 16; //  [4,16 Only] ; Caution (see note above)
//  if this is changed to 4 then change the following constants:
//     VUSB_HS_TT_PERIODIC_CONTEXT_ADDR=2
//     VUSB_HS_TT_CONTEXTS_ADDR=2
parameter VUSB_HS_TT_PERIODIC_CONTEXTS_ADDR = 4; //  max(1,log2(VUSB_HS_TT_PERIODIC_CONTEXTS))
parameter VUSB_HS_TT_CONTEXTS_ADDR = 4; //  max(VUSB_HS_TT_ASYNC_CONTEXTS_ADDR, VUSB_HS_TT_PERIODIC_CONTEXTS_ADDR) 
// ---------------------------------------------------------------------------
//  RX Buffer Constants
// ---------------------------------------------------------------------------
//  Depth & Number Of Address Bits For RX Buffer
//  ** NOTE ** : VUSB_HS_RX_ADD must be updated when VUSB_HS_RX_DEPTH is changed.
parameter VUSB_HS_RX_DEPTH = 128; //  Must be power of 2! (ie. 2**j)
//  Minimum : >= 8
//  Minimum : >= 3*VUSB_HS_RX_BURST/2
//  Maximum : <= 4096
//  Recommended : > 2*VUSB_HS_RX_BURST
parameter VUSB_HS_RX_ADD = 7; //  log2(VUSB_HS_RX_DEPTH)
parameter VUSB_HS_RX_BURST = 8; //  Burst size for RX Buffer To Memory Transfers
//  Minimum : 2
//  Maximum : 128
//  Recommended : >= 4
// ---------------------------------------------------------------------------
//  TX Buffer Constants
// ---------------------------------------------------------------------------
//  Depth & Number Of Address Bits For TX Channel
//  The Channel constants control the size of the buffer associated with each TX
//  endpoint channel.  All of the channel buffers are combined into a single
//  TX Buffer using the TX Buffer constants.
//  ** NOTE ** : VUSB_HS_TX_CHAN_ADD must be updated when VUSB_HS_TX_CHAN is changed.
parameter VUSB_HS_TX_CHAN = 64; //  Must be power of 2 (ie. 2**k)
//  Minimum : >= 8
//  Minimum : >= 3*VUSB_HS_TX_BURST/2+4
//  Maximum : <= 256
//  Recommended : > 2*VUSB_HS_TX_BURST+4
parameter VUSB_HS_TX_CHAN_ADD = 6; //  log2(VUSB_HS_TX_CHAN);
//  Depth & Number Of Address Bits For TX Buffer
//  ** NOTE ** : VUSB_HS_TX_DEPTH and VUSB_HS_TX_ADD must be updated when either
//               VUSB_HS_TX_CHAN or VUSB_HS_DEV_EP are changed.
//  Host Only : VUSB_HS_TX_DEPTH = VUSB_HS_TX_CHAN
//  Device    : VUSB_HS_TX_DEPTH = (VUSB_HS_TX_CHAN)*max_int(1,VUSB_HS_DEV_EP)
//            : VUSB_HS_TX_DEPTH <--> ** Power of 2 not necessary ** ; integer multiple of power of 2 acceptable;
//                                    ie. 2**X * VUSB_HS_DEV_EP.
//                                    (verify code exists for chosen TX_DEPTH in graycode package file)
parameter VUSB_HS_TX_DEPTH = 128; //  (VUSB_HS_TX_CHAN)*max_int(1,VUSB_HS_DEV_EP);
parameter VUSB_HS_TX_ADD = 7; //  log2(VUSB_HS_TX_DEPTH);
parameter VUSB_HS_TX_BURST = 8; //  Burst size for Memory To TX Buffer Transfers
//  Minimum : 2
//  Maximum : 128
//  Recommended : >= 4
// ---------------------------------------------------------------------------
//  AMBA 2.0 Specific options
// ---------------------------------------------------------------------------
//  This will only affect designs featuring AMBA AHB 2.0
//  AHB master interface Burst configuration:
//   0: AHB Master will only issue incremental bursts of unspecified length
//   1: AHB Master will issue INCR4, non multiple transfers of 4 are decomposed to singles
//   2: AHB Master will issue INCR8, non multiple transfers of 8 are decomposed to INCR4 or singles
//   3: AHB Master will issue INCR16, non multiple transfers of 16 are decomposed to INCR8, INCR4 or singles
//   4: Do not use this value!
//   5: AHB Master will issue INCR4, non multiple transfers of 4 are decomposed to INCR of unspecifed length
//   6: AHB Master will issue INCR8, non multiple transfers of 8 are decomposed to INCR4 or INCR of unspecifed length
//   7: AHB Master will issue INCR16, non multiple transfers of 16 are decomposed to INCR8, INCR4 or INCR of unspecifed length
//   Special note: This register overrides VUSB_HS_TX_BURST, VUSB_HS_RX_BURST and BURSTSIZE register when it's not zero
parameter VUSB_HS_AHBBRST = 2; 
// ---------------------------------------------------------------------------
//  Device Version Number
// ---------------------------------------------------------------------------
parameter VUSB_HS_DCIVERSION = 16'b 0000000000000001; 
parameter VUSB_HS_HCIVERSION = 16'b 0000000100000000; //  EHCI 1.00
