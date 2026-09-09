   //----------------------------------------------------------------------
   //
   // Copyright (c) 1998-2003 CAST, Inc.
   //
   // Please review the terms of the license agreement before using this
   // file.  If you are not an authorized user, please destroy this source
   // code file and notify CAST immediately that you inadvertently received
   // an unauthorized copy.
   //----------------------------------------------------------------------
   //
   //  Project       : PCI Core
   //
   //  File          : pci64_package.vhd
   //
   //  Dependencies  : 
   //
   //  Model Type:   : Synthesizable core
   //
   //  Description   : PCI Constants Parameters
   //
   //  Designer      : AS
   //
   //  QA Engineer   :  NS  
   //
   //  Creation Date : 17-September-2003
   //
   //  Last Update   : 20-November-2003
   //
   //  Version       : 1.0
   //----------------------------------------------------------------------
   //
   parameter ADDR_WIDTH = 32; 
   parameter DATA_WIDTH = 64; 
   parameter CBE_WIDTH = 8; 
   parameter[1:0] PASSED = 0; 
   parameter[1:0] FAILED = 1; 
   parameter[1:0] N_A = 2; 
   parameter[ADDR_WIDTH - 1:0] VID = 'h00000000; 
   parameter[3:0] VID_BE = 4'b1100; 
   parameter[ADDR_WIDTH - 1:0] DID = 'h00000000; 
   parameter[3:0] DID_BE = 4'b0011; 
   parameter[ADDR_WIDTH - 1:0] CMDR = 'h00000004; 
   parameter[3:0] CMDR_BE = 4'b1100; 
   parameter[ADDR_WIDTH - 1:0] STATR = 'h00000004; 
   parameter[3:0] STATR_BE = 4'b0011; 
   parameter[ADDR_WIDTH - 1:0] LATTIMER = 'h0000000C; 
   parameter[ADDR_WIDTH - 1:0] BAR0 = 'h00000010; 
   parameter[ADDR_WIDTH - 1:0] BAR1 = 'h00000014; 
   parameter[ADDR_WIDTH - 1:0] BAR2 = 'h00000018; 
   parameter[ADDR_WIDTH - 1:0] BAR3 = 'h0000001C; 
   parameter[ADDR_WIDTH - 1:0] BAR4 = 'h00000020; 
   parameter[ADDR_WIDTH - 1:0] BAR5 = 'h00000024; 
   parameter[ADDR_WIDTH - 1:0] CISPR = 'h00000028; 
   parameter[ADDR_WIDTH - 1:0] CAP = 'h0000002C; 
   parameter[3:0] CAP_BE = 4'b1110; 
   parameter[ADDR_WIDTH - 1:0] EBAR = 'h00000030; 
   parameter[ADDR_WIDTH - 1:0] SUBVID = 'h00000034; 
   parameter[3:0] SUBVID_BE = 4'b1100; 
   parameter[ADDR_WIDTH - 1:0] SUBDID = 'h00000034; 
   parameter[3:0] SUBDID_BE = 4'b0011; 
   parameter[ADDR_WIDTH - 1:0] MAXLAT = 'h0000003C; 
   parameter[3:0] MAXLAT_BE = 4'b0111; 
   parameter[ADDR_WIDTH - 1:0] MINGNT = 'h0000003C; 
   parameter[3:0] MINGNT_BE = 4'b1011; 
   parameter[ADDR_WIDTH - 1:0] INTPIN = 'h0000003C; 
   parameter[3:0] INTPIN_BE = 4'b1101; 
   parameter[ADDR_WIDTH - 1:0] INTLINE = 'h0000003C; 
   parameter[3:0] INTLINE_BE = 4'b1110; 
   //------------------------------------------------------------------
   // PCI Commands constants
   //------------------------------------------------------------------
   // Interrupt Acknowledge
   parameter[3:0] IACK_CODE = 4'b0000; 
   // Special Cycle
   parameter[3:0] SCYC_CODE = 4'b0001; 
   // I/O Read
   parameter[3:0] IORD_CODE = 4'b0010; 
   // I/O Write
   parameter[3:0] IOWR_CODE = 4'b0011; 
   // Reserved
   parameter[3:0] RES4_CODE = 4'b0100; 
   // Reserved
   parameter[3:0] RES5_CODE = 4'b0101; 
   // Memory Read
   parameter[3:0] MRD_CODE = 4'b0110; 
   // Memory Write
   parameter[3:0] MWR_CODE = 4'b0111; 
   // Reserved
   parameter[3:0] RES8_CODE = 4'b1000; 
   // Reserved
   parameter[3:0] RES9_CODE = 4'b1001; 
   // Configuration Read
   parameter[3:0] CFGRD_CODE = 4'b1010; 
   // Configuration Write
   parameter[3:0] CFGWR_CODE = 4'b1011; 
   // Memory Read Multiple
   parameter[3:0] MRM_CODE = 4'b1100; 
   // Dual Address Cycle
   parameter[3:0] DUAL_CODE = 4'b1101; 
   // Memory Read Line
   parameter[3:0] MRL_CODE = 4'b1110; 
   // Memory Write and Invalidate
   parameter[3:0] MWI_CODE = 4'b1111; 
   // -----------------------------------------------
   // Types and Constant from pci_busmonitor_package
   // -----------------------------------------------
   // PCI compliance record type
   //type tMPC_ARRAY is array (1 to 34) of boolean;
   //
   parameter RETRY_CLK_LIMIT = 334; 
   //
   parameter BUS_LOG_FILEMANE = "bus_monitor.log"; 
   //
   parameter TP1_ERR_MSG1 = " ERROR: TP1 rule violation - "; 
   parameter TP1_ERR_MSG2 = " not driven high before being tri-stated"; 
   parameter TP2_ERR_MSG = " ERROR: TP2 rule violation - PERR# reported without it has claimed the cycle and completed a data phase"; 
   // TP3 - N/A - covered by target PCISIG test scenario 2.5
   // TP4 - N/A - covered by target PCISIG test scenario 2.5
   parameter TP5_ERR_MSG = " ERROR: TP5 rule violation - TRDY# was deasserted without completed a data phase"; 
   parameter TP6_ERR_MSG = " ERROR: TP6 rule violation - DEVSEL# was deasserted while TRDY# asserted without completed a data phase"; 
   parameter TP7_ERR_MSG = " ERROR: TP7 rule violation - STOP# was changed while TRDY# asserted without completed a data phase"; 
   parameter TP8_ERR_MSG = " ERROR: TP8 rule violation - STOP# was changed without completed a data phase"; 
   parameter TP9_ERR_MSG = " ERROR: TP9 rule violation - TRDY# was changed while STOP# asserted without completed a data phase"; 
   parameter TP10_ERR_MSG = " ERROR: TP10 rule violation - DEVSEL# was changed while STOP# asserted without completed a data phase"; 
   parameter TP11_ERR_MSG = " ERROR: TP11 rule violation - data changed before both IRDY# and TRDY# are asserted"; 
   parameter TP12_ERR_MSG = " ERROR: TP12 rule violation - data not valid when TRDY# asserted on a read cycle"; 
   // TP13 - tested in PCISIG test scenario 2.4
   //   TP14 - tested in PCISIG test scenario 2.5
   //   TP15 - tested in PCISIG test scenario 2.6
   //   TP16 - tested in PCISIG test scenario 2.9
   parameter TP17A_ERR_MSG = " ERROR: TP17 rule violation - AD lines are not driven to stable values during address phase"; 
   parameter TP17D_ERR_MSG = " ERROR: TP17 rule violation - AD lines are not driven to stable values during data phase"; 
   //   TP18 -
   parameter TP19_ERR_MSG = " ERROR: TP19 rule violation - TRDY# asserted during turnaround cycle on a read"; 
   parameter TP20_ERR_MSG1 = " ERROR: TP20 rule violation - "; 
   parameter TP20_ERR_MSG2 = " not driven high after the last data phase"; 
   // TP21 - not verified by monitor
   parameter TP22_ERR_MSG = " ERROR: TP22 rule violation - STOP# not deasserted the cycle immediately following FRAME# being dessaerted"; 
   parameter TP23_ERR_MSG = " ERROR: TP23 rule violation - STOP# deasserted before FRAME# is negated"; 
   parameter TP24_ERR_MSG = " ERROR: TP24 rule violation - TRDY# not deasserted before signaling target-abort"; 
   parameter TP25_ERR_MSG = " ERROR: TP25 rule violation - STOP# deasserted and the transaction still continues "; 
   parameter TP26_ERR_MSG = " ERROR: TP26 rule violation - initial data phase not completed within 16 clocks"; 
   // TP27 - not defined
   parameter TP28_ERR_MSG = " ERROR: TP28 rule violation - DEVSEL# not asserted before any other response"; 
   parameter TP29_ERR_MSG = " ERROR: TP29 rule violation - DEVSEL# deasserted before the last data phase"; 
   parameter TP30_ERR_MSG = " ERROR: TP30 rule violation - target responded to special cycles"; 
   parameter TP31_ERR_MSG = " ERROR: TP31 rule violation - PAR not driven within one clock of AD being driven"; 
   parameter TP32_ERR_MSG = " ERROR: TP32 rule violation - parity error"; 
   parameter TP34_ERR_MSG = " ERROR: TP32 rule violation - write transaction not finished after 334 clock cycles after retry"; 

   // -----------------------------------------------
   // Types and Constant from pci_busmonitor_package
   // -----------------------------------------------
   parameter[1:0] FAST = 0; 
   parameter[1:0] MEDIUM = 1; 
   parameter[1:0] SLOW = 2; 
   parameter[1:0] SUB = 3; 
   // PCI transaction termination type
   parameter[2:0] T_CONTINUE = 0; // PCI data vector type
   parameter[2:0] T_ABORT = 1; // PCI data vector type
   parameter[2:0] T_RETRY = 2; // PCI data vector type
   parameter[2:0] T_DISC_W_DATA = 3; // PCI data vector type
   parameter[2:0] T_DISC_WO_DATA = 4; // PCI data vector type
   parameter[2:0] MASTER_END = 5; // PCI data vector type
   // -----------------------------------------------
   // Types and Constant from pcimaster_model_package
   // -----------------------------------------------
   parameter CTO_dly = 6;
   parameter TARGETRESPONSELIMIT = 5;
   parameter TARGETINITIALLATENCY = 16;
   parameter TARGETSUBSEQLATENCY = 8;
   parameter[2:0] MASTER_END_tMASTER_TERMINATE = 0; 
   parameter[2:0] MASTER_ABORT = 1; 
   parameter[2:0] T_ABORT_tMASTER_TERMINATE = 2; 
   parameter[2:0] T_RETRY_tMASTER_TERMINATE = 3; 
   parameter[2:0] T_DISC_W_DATA_tMASTER_TERMINATE = 4; 
   parameter[2:0] T_DISC_WO_DATA_tMASTER_TERMINATE = 5; 
   parameter[0:0] READ = 0; 
   parameter[0:0] WRITE = 1; 

   // No vector file constant - must begin with '#' character
   //
   // Constant defined in pci_m64_package and are used in pci_m64w_tb
   parameter[31:0] BAR0_MAP = 32'b11111111111111111111110000000000; 
   parameter[31:0] BAR1_MAP = 32'b11111111000000000000000000000000; 
   parameter[31:0] BAR2_MAP = 32'b00000000000000000000000000000000; 
   parameter[31:0] BAR3_MAP = 32'b00000000000000000000000000000000; 
   parameter[31:0] BAR4_MAP = 32'b00000000000000000000000000000000; 
   parameter[31:0] BAR5_MAP = 32'b00000000000000000000000000000000; 
   parameter[31:0] EBAR_MAP = 32'b00000000000000000000000000000000; 
   parameter BAR1_PRESENT = 1'b1; 
   parameter BAR2_PRESENT = 1'b0; 
   parameter BAR3_PRESENT = 1'b0; 
   parameter BAR4_PRESENT = 1'b0; 
   parameter BAR5_PRESENT = 1'b0; 
   parameter EBAR_PRESENT = 1'b0; 

   // Base Address
   parameter[31:0] BAR0_ADDR = 'hB0000000;
   parameter[31:0] BAR1_ADDR = 'hB1000000;
   parameter[31:0] BAR2_ADDR = 'hB2000000;
   parameter[31:0] BAR3_ADDR = 'hB3000000;
   parameter[31:0] BAR4_ADDR = 'hB4000000;
   parameter[31:0] BAR5_ADDR = 'hB5000000;
   // Expansion ROM Base Address
   parameter[31:0] EBAR_ADDR = 'hBE000000;

   //------------------------------------------------------------------
   // System init parameters
   //------------------------------------------------------------------
   // Target System Setup Parameters
   parameter DEVICE_NO = 0; // device no for IDSEL generation
   // Latency Timer
   parameter[7:0] LAT_TIMER = 8'h20;
   // Cache Line Size
   parameter[7:0] CACHE_SIZE = 8'h10;
   // Interrupt Line
   parameter[7:0] INT_LINE = 8'h0A;
   //------------------------------------------------------------------
   // PCI Arbiter Parameters
   //------------------------------------------------------------------
   parameter ARBIT_MASTER_NO = 2;
   parameter ARBIT_TARGET_NO = 2;
   parameter ARBIT_LATENCY_LIMIT = 0;
   // Tested device DMA parameters
   parameter[31:0] UUT_DMA_RDADDR = 32'hD8000000;
   parameter[31:0] UUT_DMA_TXCNT = 32'h00000020; // 32 bytes
   parameter[31:0] UUT_DMA_WRADDR = 32'hD8010000;
   parameter[31:0] UUT_DMA_AHBADDR = 32'h00000020;
   parameter[31:0] VOID_SPACE = 32'h10000000;
   // Target Model 1 - parameters
   parameter TARGET1_ENABLE64 = 1'b1;
   parameter[31:0] TARGET1_BASE_ADDR = UUT_DMA_RDADDR;
   parameter[31:0] TARGET1_SIZE = 'h00001000;
   parameter[1:0] TARGET1_DEC_SPEED = MEDIUM;
   parameter TARGET1_VECTOR_FILENAME = "t64_t1.vec";
   parameter TARGET1_LOG_FILENAME = "t64_t1.log";
   // Target Model 2 - parameters
   parameter TARGET2_ENABLE64 = 1'b1;
   parameter[31:0] TARGET2_BASE_ADDR = UUT_DMA_WRADDR;
   parameter[31:0] TARGET2_SIZE = 'h00001000;
   parameter[1:0] TARGET2_DEC_SPEED = MEDIUM;
   parameter TARGET2_VECTOR_FILENAME = "t64_t2.vec";
   parameter TARGET2_LOG_FILENAME = "t64_t2.log";
   parameter TARGET_VEC_LINES = 11;
   //
   parameter PCIAHB_OFFSET = BAR0_ADDR + 'h00;
   parameter PCIAHB_ERROR  = BAR0_ADDR + 'h08;
   parameter PCIAHB_DISCARD= BAR0_ADDR + 'h10;
   parameter DMA_PCIPTR    = BAR0_ADDR + 'h80;
   parameter DMA_AHBPTR    = BAR0_ADDR + 'h88;
   parameter DMA_TXCNT     = BAR0_ADDR + 'h90;
   parameter DMA_CTRL      = BAR0_ADDR + 'h98;
   parameter DMA_STATUS    = BAR0_ADDR + 'hA0;
   parameter INT_STATUS     = BAR0_ADDR + 'h100;
   parameter INT_PCIMASK    = BAR0_ADDR + 'h108;
   parameter INT_AHBMASK    = BAR0_ADDR + 'h110;
   integer logfile;
   integer vectfile;
   parameter RAM_VEC_LINES = 16;
