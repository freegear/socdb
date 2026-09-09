/*
 ARM926EJS with AXI interface.
 
 Created date : 2006.11.14
 File Name   : arm926_axi.v
 version     : 0.2

 note :
 
 history :
    2006.12.11 : modify JTAG Debug signals
 
    2007.1.11 : add ETM.
 
 */
`timescale 1ns/1ps

`include "ARM926EJS.vh" 

`define NoEtm    // if not want to add ETM.
`undef FPGA
`undef TESTCHIP

module     arm_axi 
  (
   // input/output port
   ACLK_CPU            ,
   ACLK_BUS            ,
   BusClockEn          , 	// BUS clock rising indicator
   ARESETn             ,
   VINITHI             ,
   
   ARMnFIQ             ,
   ARMnIRQ             ,
   
   // ARM Instruction
   //Disable_id_port
   ARADDR_ARMI         ,
   ARLEN_ARMI          ,
   ARSIZE_ARMI         ,  
   ARBURST_ARMI        , 
   ARLOCK_ARMI         ,  
   //Disable_cache_port
   //Disable_protect_port
   ARVALID_ARMI        , 
   ARREADY_2_ARMI      , 
   
   //Read data channel
   //Disable_id_port
   RRESP_2_ARMI        ,   
   RDATA_2_ARMI        ,
   RLAST_2_ARMI        ,
   RVALID_2_ARMI       ,  
   RREADY_ARMI         ,  
   
   
   //ARM Data
   //Read address channel
   //Disable_id_port
   ARADDR_ARMD         ,
   ARLEN_ARMD          ,
   ARSIZE_ARMD         ,  
   ARBURST_ARMD        , 
   ARLOCK_ARMD         ,  
   //Disable_cache_port
   //Disable_protect_port
   
   ARVALID_ARMD        , 
   ARREADY_2_ARMD      , 
   
   //Read data channel
   //Disable_id_port
   RRESP_2_ARMD        ,   
   RDATA_2_ARMD        ,
   RLAST_2_ARMD        ,
   RVALID_2_ARMD       ,  
   RREADY_ARMD         ,  
   
   //ARM Data Write Port
   //Disable_id_port
   AWADDR_ARMD         ,
   AWLEN_ARMD          ,
   AWSIZE_ARMD         ,  
   AWBURST_ARMD        , 
   AWLOCK_ARMD         ,  
   //Disable_cache_port
   //Disable_protect_port
   
   AWVALID_ARMD        , 
   AWREADY_2_ARMD      , 
   
   //Write data channel
   //Disable_id_port
   WDATA_ARMD          ,   
   WSTRB_ARMD          ,   
   WLAST_ARMD          ,   
   WVALID_ARMD         ,  
   WREADY_2_ARMD       ,  
   
   //Write response channel
   //Disable_id_port
   BRESP_2_ARMD        ,   
   BVALID_2_ARMD       ,  
   BREADY_ARMD         ,  
   
   `ifdef FPGA
   DBG0                ,       // FPGA debug 
   DBG1                ,       // FPGA debug 
   DSWITCH             ,    // FPGA debug  (from DIP switches)
   `endif
   
   //ATPG
   SCANENABLE          ,
   INTEST              ,
   EXTEST              ,
   TESTMODE            ,
   

   // TEST SIGNAL
   IHREADY_OUT         ,
   DHREADY_OUT         ,

   // Debug JTAG signals
   DBGnTRST            ,
   DBGTDI              ,
   DBGTMS              ,
   DBGTCKEN            ,
   DBGTDO              ,
   EDBGRQ              ,
   DBGACK              ,
   DBGIR               
   );

   // input/output port
   input 			ARESETn;
   input            ACLK_CPU;
   input            ACLK_BUS;
   input 			BusClockEn; 	// BUS clock rising indicator
   input 			VINITHI;
   
   input 			ARMnFIQ;
   input 			ARMnIRQ;
   
   // ARM Instruction
   //Disable_id_port
   output [31:0] 	ARADDR_ARMI;
   output [3:0] 	ARLEN_ARMI;
   output [2:0] 	ARSIZE_ARMI;  
   output [1:0] 	ARBURST_ARMI; 
   output [1:0] 	ARLOCK_ARMI;  
   //Disable_cache_port
   //Disable_protect_port
   output 			ARVALID_ARMI;
   input 			ARREADY_2_ARMI; 
   
   //Read data channel
   //Disable_id_port
   input [1:0] 		RRESP_2_ARMI;   
   input [31:0] 	RDATA_2_ARMI;
   input 			RLAST_2_ARMI;
   input 			RVALID_2_ARMI;  
   output 			RREADY_ARMI;  
 
    
   //ARM Data
   //Read address channel
   //Disable_id_port
   output [31:0] 	ARADDR_ARMD;
   output [3:0] 	ARLEN_ARMD;
   output [2:0] 	ARSIZE_ARMD;  
   output [1:0] 	ARBURST_ARMD; 
   output [1:0] 	ARLOCK_ARMD;  
   //Disable_cache_port
   //Disable_protect_port
   output 			ARVALID_ARMD; 
   input 			ARREADY_2_ARMD; 
   
   //Read data channel
   //Disable_id_port
   input [1:0] 		RRESP_2_ARMD;   
   input [31:0] 	RDATA_2_ARMD;
   input 			RLAST_2_ARMD;
   input 			RVALID_2_ARMD;  
   output 			RREADY_ARMD;  

   //ARM Data Write Port
   //Disable_id_port
   output [31:0] 	AWADDR_ARMD;
   output [3:0] 	AWLEN_ARMD;
   output [2:0] 	AWSIZE_ARMD;  
   output [1:0] 	AWBURST_ARMD; 
   output [1:0] 	AWLOCK_ARMD;  
   //Disable_cache_port
   //Disable_protect_port
   
   output 			AWVALID_ARMD; 
   input 			AWREADY_2_ARMD; 

   //Write data channel
   //Disable_id_port
   output [31:0] 	WDATA_ARMD;   
   output [3:0] 	WSTRB_ARMD;   
   output 			WLAST_ARMD;   
   output 			WVALID_ARMD;  
   input 			WREADY_2_ARMD;  
   
   //Write response channel
   //Disable_id_port
   input [1:0] 		BRESP_2_ARMD;   
   input 			BVALID_2_ARMD;  
   output 			BREADY_ARMD;  

`ifdef FPGA
   output [33:0]     DBG0;       // FPGA debug output
   output [33:0]     DBG1;       // FPGA debug output
   input   [7:0]     DSWITCH;    // FPGA debug input (from DIP switches)
`endif

   //ATPG
   input             SCANENABLE;
   input             INTEST;
   input             EXTEST;
   input             TESTMODE;
   
   // TEST SIGNAL
   output              IHREADY_OUT         ;
   output              DHREADY_OUT         ;
   
   // Debug JTAG signals
   input             DBGnTRST;
   input             DBGTDI;
   input             DBGTMS;
   input             DBGTCKEN;
   output            DBGTDO;
   input 			 EDBGRQ;
   output 			 DBGACK;
   // for option
   output [3:0] 	 DBGIR;
   

   //===================================================
   // AXI output signals
   wire [31:0] 		ARADDR_ARMI;
   wire [3:0] 		ARLEN_ARMI;
   wire [2:0] 		ARSIZE_ARMI;  
   wire [1:0] 		ARBURST_ARMI; 
   wire [1:0] 		ARLOCK_ARMI;  
   wire 			ARVALID_ARMI; 
   
   wire 			RREADY_ARMI;  
   
   wire [31:0] 		ARADDR_ARMD;
   wire [3:0] 		ARLEN_ARMD;
   wire [2:0] 		ARSIZE_ARMD;  
   wire [1:0] 		ARBURST_ARMD; 
   wire [1:0] 		ARLOCK_ARMD;  
   
   wire 			ARVALID_ARMD; 
   
   wire 			RREADY_ARMD;
  
   wire [31:0] 		WDATA_ARMD;
   wire 			AWREADY_2_ARMD; 
   
   wire 			WREADY_2_ARMD;  
   
   wire [1:0] 		BRESP_2_ARMD;   
   wire 			BVALID_2_ARMD;  
   
   
   // AHB Instruction
   wire [31:0] 		IHADDR;
   wire [ 1:0] 		IHTRANS;
   wire 			IHWRITE; // read only
   wire [2:0] 		IHSIZE;
   wire [2:0] 		IHBURST;
   wire [3:0] 		IHPROT;
   wire [31:0] 		IHWDATA = {32{1'b0}};
   wire [31:0] 		IHRDATA;
   wire 			IHREADY_IN;
   wire 			IHREADY_OUT;
   wire [1:0] 		IHRESP;
   
   wire 			IHSEL;
   reg 				IHMASTLOCK;
   
   wire             IHCLKEN;
   wire 			IHBUSREQ;
   wire 			IHGRANT;
   wire 			IHLOCK;
   
   // AHB Data
   wire [31:0] 		DHADDR;
   wire [ 1:0] 		DHTRANS;
   wire 			DHWRITE;
   wire [2:0] 		DHSIZE;
   wire [3:0] 		DHBL;
   wire [2:0] 		DHBURST;
   wire [3:0] 		DHPROT;
   wire [31:0] 		DHWDATA;
   wire [31:0] 		DHRDATA;
   wire 			DHREADY_IN;
   wire 			DHREADY_OUT;
   wire [1:0] 		DHRESP;
   
   wire 			DHSEL;
   reg 				DHMASTLOCK;

   wire             DHCLKEN;   
   wire 			DHBUSREQ;
   wire 			DHGRANT;
   wire 			DHLOCK;
   
   wire 			EDBGRQ_CM; // external signal or internal signal
   wire 			PWRDOWN;
   wire 			ETMEDBGRQ;
   
   //-------------------------------------------
   // ARM926 Signals
   // Clock, interrupts, etc.
   wire 			STANDBYWFI; // output
   //wire 			VINITHI;    // vector table location
   wire 			BIGENDINIT = 1'b0; // little endian;
   wire 			CFGBIGEND;  // output
   wire [31:0] 		TAPID = 32'h07926F0F;

   // Instruction Bus
   //wire [31:1] 		IHADDR_ARM;


   // Coprocessor interface signals
   wire 			CPCLKEN;
   wire [31:0] 		CPINSTR;
   wire [31:0] 		CPDOUT;
   wire [31:0] 		CPDIN;
   wire 			CPPASS;
   wire 			CPLATECANCEL;
   wire [1:0] 		CHSDE;
   wire [1:0] 		CHSEX;
   wire 			nCPINSTRVALID;
   wire 			nCPMREQ;
   wire 			nCPTRANS;
   wire [3:0] 		CPBURST;
   wire 			CPABORT;
   wire             CPEN;
   
   // Debug signals
`ifdef FPGA
   wire [33:0] 		DBG0;       // FPGA debug output
   wire [33:0] 		DBG1;       // FPGA debug output
   //wire   [7:0]     DSWITCH;    // FPGA debug input (from DIP switches)
`endif
   // EmbeddedICE-RT Communication channel signals
   wire 			COMMRX;
   wire 			COMMTX;
   wire 			DBGACK;
   wire             DBGEN = 1'b1;  // enable Debugging Block
   wire 			DBGRQI; // not used
   wire             EDBGRQ; // = 1'b0;
   wire [1:0] 		DBGEXT = 2'b00;
   wire 			DBGINSTREXEC;
   wire [1:0] 		DBGRNG;
   wire             DBGIEBKPT = 1'b0;
   wire             DBGDEWPT = 1'b0;
   
   // Debug JTAG signals
   wire 			DBGTDO;
   
   wire [3:0] 		DBGIR;
   wire [4:0] 		DBGSCREG;
   wire [3:0] 		DBGTAPSM;
   wire 			DBGnTDOEN;
   wire 			DBGSDIN;
   wire             DBGSDOUT;
   
   // ETM Interface signals
   
   wire             ETMEN;
   wire             FIFOFULL;
   wire 			ETMBIGEND;
   wire 			ETMHIVECS;
   wire [31:0] 		ETMIA;
   wire 			ETMInMREQ;
   wire 			ETMISEQ;
   wire 			ETMITBIT;
   wire 			ETMIJBIT;
   wire 			ETMZIFIRST;
   wire 			ETMZILAST;
   
   wire 			ETMIABORT;
   wire [31:0] 		ETMDA;
   wire [1:0] 		ETMDMAS;
   wire 			ETMDMORE;
   wire 			ETMDnMREQ;
   wire 			ETMDnRW;
   wire 			ETMDSEQ;
   wire [31:0] 		ETMRDATA;
   wire 			ETMDABORT;
   wire [31:0] 		ETMWDATA;
   wire 			ETMnWAIT;
   wire 			ETMDBGACK;
   wire 			ETMINSTREXEC;
   wire [1:0] 		ETMRNGOUT;
   wire [31:25] 	ETMID31To25;
   wire [15:11] 	ETMID15To11;
   wire [1:0] 		ETMCHSD;
   wire [1:0] 		ETMCHSE;
   wire 			ETMPASS;
   wire 			ETMLATECANCEL;
   wire [31:0] 		ETMPROCID;
   wire 			ETMPROCIDWR;
   wire 			ETMINSTRVALID;

   
   // TCM Interface signals (non-DMA)
   
   wire 			DRnRW;
   wire [17:0] 		DRADDR;
   wire [31:0] 		DRWD;
   wire 			DRIDLE;
   wire 			DRCS;
   wire [3:0] 		DRWBL;
   wire 			DRSEQ;
   wire [31:0] 		DRRD = {32{1'b0}};
   wire             DRWAIT = 1'b0;
   wire [3:0] 		DRSIZE = 4'h0;   // memory size
   
   wire 			IRnRW;
   wire [17:0] 		IRADDR;
   wire [31:0] 		IRWD;
   wire 			IRIDLE;
   wire 			IRCS;
   wire [3:0] 		IRWBL;
   wire 			IRSEQ;
   wire [31:0] 		IRRD = {32{1'b0}};
   wire             IRWAIT = 1'b0;
   wire [3:0] 		IRSIZE = 4'h0;   // memory size
   wire             INITRAM = 1'b0;  // must be low for CPU boot.

   // TCM DMA access 
  
   wire             DRDMAEN = 1'b0;    // DTCM DMA enable
   wire             DRDMACS = 1'b0;    // DTCM DMA CS.
   wire [17:0]      DRDMAADDR = {18{1'b0}};  // DTCM DMA address.

   wire             IRDMAEN = 1'b0;    // ITCM DMA enable
   wire             IRDMACS = 1'b0;    // ITCM DMA CS.
   wire [17:0]      IRDMAADDR = {18{1'b0}};  // ITCM DMA address.


`ifdef TESTCHIP
  // dynamically size caches (validation model only)
   wire [3:0]       DCACHESIZE = 4'b0011;
   wire [3:0]       ICACHESIZE = 4'b0011;
`endif

   //=====================================================

   reg 			IHBUSREQ_ff;

  
   always @(posedge ACLK_BUS or negedge ARESETn) begin
	  if(!ARESETn) begin
		 IHBUSREQ_ff <= 0;
		 IHMASTLOCK <= 0;
	  end
	  else
		begin
		   IHBUSREQ_ff <= IHBUSREQ;
		   if(IHBUSREQ && !IHBUSREQ_ff)	// rising edge of BUSREQ
			 IHMASTLOCK <= IHLOCK;
		end
   end // always
   
   assign IHGRANT = 1'b1;
   assign IHREADY_IN = IHREADY_OUT;
   assign IHSEL = 1'b1;
   
   assign 		IHCLKEN = BusClockEn;
   assign 		DHCLKEN = BusClockEn;
   //assign       IHADDR = {IHADDR_ARM,1'b0};

   
   AHB2AXIBridge IAHB2AXI
	 (
	  .CLK          ( ACLK_BUS ),
	  .RESETn       ( ARESETn ),
	  
	  // AHB Bus
	  .HADDR        ( IHADDR ),
	  .HTRANS       ( IHTRANS ),
	  .HWRITE       ( IHWRITE ),
	  .HSIZE        ( IHSIZE ),
	  .HBL          ( 4'b1111 ),
	  .HBURST       ( IHBURST ),
	  .HPROT        ( IHPROT ),
	  .HWDATA       ( IHWDATA ),
	  .HRDATA       ( IHRDATA ),
	  .HREADY_IN    ( IHREADY_IN ),
	  .HREADY_OUT   ( IHREADY_OUT ),
	  .HRESP        ( IHRESP ),
	  
	  .HSEL         ( IHSEL ),
	  .HMASTLOCK    ( IHMASTLOCK ),

	  // AXI write
	  .AWADDR       (  ),
	  .AWLEN        (  ),
	  .AWSIZE       (  ),
	  .AWBURST      (  ),
	  .AWLOCK       (  ),
	  .AWCACHE      (  ),
	  .AWPROT       (  ),
	  .AWVALID      (  ),
	  .AWREADY      ( 1'b1 ),
	  
	  .WDATA        (  ),
	  .WSTRB        (  ),
	  .WLAST        (  ),
	  .WVALID       (  ),
	  .WREADY       ( 1'b1 ),
	  
	  .BRESP        ( 2'b00 ),
	  .BVALID       ( 1'b1 ),
	  .BREADY       (  ),

	  // AXI read
	  .ARADDR       ( ARADDR_ARMI ),
	  .ARLEN        ( ARLEN_ARMI ),
	  .ARSIZE       ( ARSIZE_ARMI ),
	  .ARBURST      ( ARBURST_ARMI ),
	  .ARLOCK       ( ARLOCK_ARMI ),
	  .ARCACHE      (  ),
	  .ARPROT       (  ),
	  .ARVALID      ( ARVALID_ARMI ),
	  .ARREADY      ( ARREADY_2_ARMI ),
	  
	  .RDATA        ( RDATA_2_ARMI ),
	  .RRESP        ( RRESP_2_ARMI ),
	  .RLAST        ( RLAST_2_ARMI ),
	  .RVALID       ( RVALID_2_ARMI ),
	  .RREADY       ( RREADY_ARMI )
	  ); // AHB2AXI_I


   
   //----------------------------------------------

   reg 			DHBUSREQ_ff;
   
   always @(posedge ACLK_BUS or negedge ARESETn) begin
	  if(!ARESETn) begin
		 DHBUSREQ_ff <= 0;
		 DHMASTLOCK <= 0;
	  end
	  else
		begin
		   DHBUSREQ_ff <= DHBUSREQ;
		   if(DHBUSREQ && !DHBUSREQ_ff)	// rising edge of BUSREQ
			 DHMASTLOCK <= DHLOCK;
		end
   end // always
   
   assign DHGRANT = 1'b1;
   assign DHREADY_IN = DHREADY_OUT;
   assign DHSEL = 1'b1;
   
   
   
   AHB2AXIBridge     DAHB2AXI
	 (
	  .CLK          ( ACLK_BUS ),
	  .RESETn       ( ARESETn ),
	  
	  // AHB Bus
	  .HADDR        ( DHADDR ),
	  .HTRANS       ( DHTRANS ),
	  .HWRITE       ( DHWRITE ),
	  .HSIZE        ( DHSIZE ),
	  .HBL          ( DHBL ),
	  .HBURST       ( DHBURST ),
	  .HPROT        ( DHPROT ),
	  .HWDATA       ( DHWDATA ),
	  .HRDATA       ( DHRDATA ),
	  .HREADY_IN    ( DHREADY_IN ),
	  .HREADY_OUT   ( DHREADY_OUT ),
	  .HRESP        ( DHRESP ),
	  
	  .HSEL         ( DHSEL ),
	  .HMASTLOCK    ( DHMASTLOCK ),

	  // AXI write
	  .AWADDR       ( AWADDR_ARMD ),
	  .AWLEN        ( AWLEN_ARMD ),
	  .AWSIZE       ( AWSIZE_ARMD ),
	  .AWBURST      ( AWBURST_ARMD ),
	  .AWLOCK       ( AWLOCK_ARMD ),
	  .AWCACHE      (  ),
	  .AWPROT       (  ),
	  .AWVALID      ( AWVALID_ARMD),
	  .AWREADY      ( AWREADY_2_ARMD ),
	  
	  .WDATA        ( WDATA_ARMD ),
	  .WSTRB        ( WSTRB_ARMD ),
	  .WLAST        ( WLAST_ARMD ),
	  .WVALID       ( WVALID_ARMD ),
	  .WREADY       ( WREADY_2_ARMD ),
	  
	  .BRESP        ( BRESP_2_ARMD ),
	  .BVALID       ( BVALID_2_ARMD ),
	  .BREADY       ( BREADY_ARMD ),

	  // AXI read
	  .ARADDR       ( ARADDR_ARMD ),
	  .ARLEN        ( ARLEN_ARMD),
	  .ARSIZE       ( ARSIZE_ARMD ),
	  .ARBURST      ( ARBURST_ARMD ),
	  .ARLOCK       ( ARLOCK_ARMD ),
	  .ARCACHE      (  ),
	  .ARPROT       (  ),
	  .ARVALID      ( ARVALID_ARMD ),
	  .ARREADY      ( ARREADY_2_ARMD ),
	   
	  .RDATA        ( RDATA_2_ARMD ),
	  .RRESP        ( RRESP_2_ARMD ),
	  .RLAST        ( RLAST_2_ARMD ),
	  .RVALID       ( RVALID_2_ARMD ),
	  .RREADY       ( RREADY_ARMD )
	  ); // AHB2AXI_D




   
   //=========================================================

   assign      CPBURST = 4'h0; // if no coprocessor
   assign      CHSDE = 2'b10;
   assign      CHSEX = 2'b10;
   assign 	   CPDIN = {32{1'b0}};
   assign 	   CPEN = 1'b0;
   



   ARM926EJS         CPU 
	 (
	  // Outputs
	  .STANDBYWFI    ( STANDBYWFI ),
	  .CFGBIGEND     ( CFGBIGEND ),
	  
	  .DHADDR        ( DHADDR ),
	  .DHTRANS       ( DHTRANS ),
	  .DHBURST       ( DHBURST ),
	  .DHWRITE       ( DHWRITE ),
	  .DHSIZE        ( DHSIZE ), 
	  .DHBL          ( DHBL ),
	  .DHPROT        ( DHPROT ),
	  .DHWDATA       ( DHWDATA ),
	  .DHBUSREQ      ( DHBUSREQ ),
	  .DHLOCK        ( DHLOCK ),
	  
	  .IHADDR        ( IHADDR ),  //
	  .IHTRANS       ( IHTRANS ),
	  .IHBURST       ( IHBURST ), 
	  .IHWRITE       ( IHWRITE ), 
	  .IHSIZE        ( IHSIZE ),
	  .IHPROT        ( IHPROT ),
	  .IHBUSREQ      ( IHBUSREQ ),
	  .IHLOCK        ( IHLOCK ),

	  .CPCLKEN       ( CPCLKEN ),
	  .CPINSTR       ( CPINSTR ), 
	  .CPDOUT        ( CPDOUT ),
	  .CPPASS        ( CPPASS ),
	  .CPLATECANCEL  ( CPLATECANCEL ),
	  .nCPINSTRVALID ( nCPINSTRVALID ),
	  .nCPMREQ       ( nCPMREQ ),
	  .nCPTRANS      ( nCPTRANS ), 
	  .CPABORT       ( CPABORT ),

	  .COMMRX        ( COMMRX ),
	  .COMMTX        ( COMMTX ),

	  .DBGACK        ( DBGACK ),
	  .DBGRQI        ( DBGRQI ),
	  .DBGINSTREXEC  ( DBGINSTREXEC ),
	  .DBGRNG        ( DBGRNG ), 
	  .DBGTDO        ( DBGTDO ),
	  .DBGIR         ( DBGIR ),
	  .DBGSCREG      ( DBGSCREG ),
	  .DBGTAPSM      ( DBGTAPSM ),
	  .DBGnTDOEN     ( DBGnTDOEN ),
	  .DBGSDIN       ( DBGSDIN ),

	  .ETMBIGEND     ( ETMBIGEND ), 
	  .ETMHIVECS     ( ETMHIVECS ),
	  .ETMIA         ( ETMIA ),
	  .ETMInMREQ     ( ETMInMREQ ),
	  .ETMISEQ       ( ETMISEQ ),
	  .ETMITBIT      ( ETMITBIT ), //
	  .ETMIJBIT      ( ETMIJBIT ), //
	  .ETMZIFIRST    ( ETMZIFIRST ),
	  .ETMZILAST     ( ETMZILAST ),
	  .ETMIABORT     ( ETMIABORT ),
	  .ETMDA         ( ETMDA ),
	  .ETMDMAS       ( ETMDMAS ),
	  .ETMDMORE      ( ETMDMORE ), 
	  .ETMDnMREQ     ( ETMDnMREQ ),
	  .ETMDnRW       ( ETMDnRW ),
	  .ETMDSEQ       ( ETMDSEQ ),
	  .ETMRDATA      ( ETMRDATA ),
	  .ETMDABORT     ( ETMDABORT ),
	  .ETMWDATA      ( ETMWDATA ), 
	  .ETMnWAIT      ( ETMnWAIT ),
	  .ETMDBGACK     ( ETMDBGACK ),
	  .ETMINSTREXEC  ( ETMINSTREXEC ),
	  .ETMRNGOUT     ( ETMRNGOUT ),
	  .ETMID31To25   ( ETMID31To25 ), 
	  .ETMID15To11   ( ETMID15To11 ),
	  .ETMCHSD       ( ETMCHSD ),
	  .ETMCHSE       ( ETMCHSE ),
	  .ETMPASS       ( ETMPASS ),
	  .ETMLATECANCEL ( ETMLATECANCEL ),
	  .ETMPROCID     ( ETMPROCID ), 
	  .ETMPROCIDWR   ( ETMPROCIDWR ),
	  .ETMINSTRVALID ( ETMINSTRVALID ),

	  .DRnRW         ( DRnRW ),
	  .DRADDR        ( DRADDR ),
	  .DRWD          ( DRWD ),
	  .DRIDLE        ( DRIDLE ),
	  .DRCS          ( DRCS ), 
	  .DRWBL         ( DRWBL ),
	  .DRSEQ         ( DRSEQ ),

	  .IRnRW         ( IRnRW ),
	  .IRADDR        ( IRADDR ),
	  .IRWD          ( IRWD ),
	  .IRIDLE        ( IRIDLE ),
	  .IRCS          ( IRCS ),
	  .IRWBL         ( IRWBL ),
	  .IRSEQ         ( IRSEQ ), 
	  
	  `ifdef FPGA
	  // FPGA debug 
	  .DBG0          ( DBG0 ),
	  .DBG1          ( DBG1 ),
	  .DSWITCH       ( DSWITCH ),
	  `endif
	  
	  // Inputs
	  .CLK           ( ACLK_CPU ),
	  .nFIQ          ( ARMnFIQ ),
	  .nIRQ          ( ARMnIRQ ),
	  .VINITHI       ( VINITHI ),
	  .BIGENDINIT    ( BIGENDINIT ),
	  .TAPID         ( TAPID ),
	  .HRESETn       ( ARESETn ),
	  
	  .DHCLKEN       ( DHCLKEN ),
	  .DHGRANT       ( DHGRANT ), 
	  .DHREADY       ( DHREADY_OUT ),
	  .DHRESP        ( DHRESP ),
	  .DHRDATA       ( DHRDATA ),
	  
	  .IHCLKEN       ( IHCLKEN ),
	  .IHGRANT       ( IHGRANT ),
	  .IHREADY       ( IHREADY_OUT ),
	  .IHRESP        ( IHRESP ), 
	  .IHRDATA       ( IHRDATA ),

	  .CPDIN         ( CPDIN ),
	  .CHSDE         ( CHSDE ),
	  .CHSEX         ( CHSEX ),
	  .CPBURST       ( CPBURST ),
	  .CPEN          ( CPEN ),

	  .DBGEN         ( DBGEN ),
	  .EDBGRQ        ( EDBGRQ_CM ),
	  .DBGEXT        ( DBGEXT ), 
	  .DBGIEBKPT     ( DBGIEBKPT ),
	  .DBGDEWPT      ( DBGDEWPT ),
	  .DBGnTRST      ( DBGnTRST ),
	  .DBGTCKEN      ( DBGTCKEN ),
	  .DBGTDI        ( DBGTDI ),
	  .DBGTMS        ( DBGTMS ),
	  .DBGSDOUT      ( DBGSDOUT ), 
	  .ETMEN         ( ETMEN ),
	  .FIFOFULL      ( FIFOFULL ),
	  .DRRD          ( DRRD ),
	  .DRWAIT        ( DRWAIT ),
	  .DRSIZE        ( DRSIZE ),
	  .IRRD          ( IRRD ),
	  .IRWAIT        ( IRWAIT ),
	  .IRSIZE        ( IRSIZE ), 
	  .INITRAM       ( INITRAM ),
	  .DRDMAEN       ( DRDMAEN ),
	  .DRDMACS       ( DRDMACS ),
	  .DRDMAADDR     ( DRDMAADDR ),
	  .IRDMAEN       ( IRDMAEN ),
	  .IRDMACS       ( IRDMACS ),
	  .IRDMAADDR     ( IRDMAADDR ),
	  
	  `ifdef TESTCHIP
	  // dynamically selectable cache sizes (validation models only)
	  .DCACHESIZE    ( DCACHESIZE ), 
	  .ICACHESIZE    ( ICACHESIZE ),
	  `endif
	  
	  // ATPG:
	  .SCANENABLE    ( SCANENABLE ),
	  .INTEST        ( INTEST ),
	  .EXTEST        ( EXTEST ),
	  .TESTMODE      ( TESTMODE )
	  ); // CPU

   // select one
   assign 	   EDBGRQ_CM = ETMEDBGRQ & PWRDOWN; // internal singal
   //assign 	   EDBGRQ_CM = EDBGRQ;   // external signal
   
   assign      ETMEN = ~PWRDOWN;
   

`ifdef NoEtm
   assign 	   FIFOFULL = 1'b0;
   assign 	   PWRDOWN  = 1'b1;
   assign 	   ETMEDBGRQ = 1'b0;
   assign 	   DBGSDOUT = 1'b0;
`else // NoEtm
   wire [4:1]  ETMEXTIN;
   wire [15:0] Mmd;
   
   assign 	   ETMEXTIN = 4'h0;
   assign 	   Mmd = 16'h0000;   
   
   ETM9             uETM9 
	(
     // Outputs
     .MMDCTRL        (),
     .MMDIA          (),
     .MMDITBIT       (),
     .MMDInMREQ      (),
     .MMDDA          (),
     .MMDDnRW        (),
     .MMDDnMREQ      (),
     .EXTOUT         ( ),
     .DBGRQ          (ETMEDBGRQ),
     .TDO            (DBGSDOUT),
     .PWRDOWN        (PWRDOWN),
     .ETMEN          (),
     .CLKDIVTWOEN    ( ),
     .PIPESTAT       ( ),
     .TRACEPKT       ( ),
     .TRACESYNC      ( ),
     .FIFOFULL       (FIFOFULL),
     .PORTSIZE       ( ),
     .PORTMODE       ( ),
     // Inputs
     .TCK            (CLK),
     .TCKEN          (DBGTCKEN),
     .nTRST          (DBGnTRST),
     .TDI            (DBGTDI),
     .TMS            (DBGTMS),
     .ARMTDO         (1'b0),
     .nRESET         (DBGnTRST), // Expected
     .CLK            (CLK),
     .CLKEN          (ETMnWAIT),
     .BIGEND         (ETMBIGEND),
     .HIVECS         (ETMHIVECS),
     .IA             (ETMIA[31:0]),
     .InMREQ         (ETMInMREQ),
     .ISEQ           (ETMISEQ),
     .ITBIT          (ETMITBIT),
     .IJBIT          (ETMIJBIT),
     .INSTREXEC      (ETMINSTREXEC),
     .INSTRVALID     (ETMINSTRVALID),
     .ID31To25       (ETMID31To25[31:25]),
     .ID15To11       (ETMID15To11[15:11]),
     .ZIFIRST        (ETMZIFIRST),
     .ZILAST         (ETMZILAST),
     .DA             (ETMDA[31:0]),
     .DD             (ETMWDATA[31:0]),
     .DMAS           (ETMDMAS[1:0]),
     .DnMREQ         (ETMDnMREQ),
     .DnRW           (ETMDnRW),
     .DSEQ           (ETMDSEQ),
     .CHSD           (ETMCHSD[1:0]),
     .CHSE           (ETMCHSE[1:0]),
     .LATECANCEL     (ETMLATECANCEL),
     .PASS           (ETMPASS),
     .DABORT         (ETMDABORT),
     .DDIN           (ETMRDATA[31:0]),
     .DBGACK         (ETMDBGACK),
     .PROCID         (ETMPROCID[31:0]),
     .PROCIDWR       (ETMPROCIDWR),
     .EXTIN          (ETMEXTIN[4:1]),
     .MMDIN          (Mmd[15:0]),
     .SYSOPT         (9'b111111010),
     .RANGEOUT0      (ETMRNGOUT[0]),
     .RANGEOUT1      (ETMRNGOUT[1])
	 );
`endif // NoEtm



//-------------------------------------------------------   
//synopsys translate_off
   integer     memf;

   initial begin
	  memf = $fopen("memop.log");
   end // initial
   //----------------------------------------------------
   // Display the fetch address
   wire   valid_iaddr;

   assign valid_iaddr = (IHTRANS != 2'h0 && IHREADY_OUT == 1'b1)? 1'b1 : 1'b0;

   always@(posedge ACLK_CPU) begin
	  if(ARESETn & BusClockEn & valid_iaddr) begin
		 $display(" %t Instruction Fetch : %h",$time,IHADDR);
		 $fdisplay(memf," %t Instruction Fetch : %h",$time,IHADDR);
	  end
   end // always
   

   //----------------------------------------------------
   // Display the data access address
   wire   valid_daddr;
   assign valid_daddr = (DHTRANS != 2'h0 && DHREADY_OUT == 1'b1)? 1'b1 : 1'b0;

   always@(posedge ACLK_CPU) begin
	  if(ARESETn & BusClockEn & valid_daddr) begin
		 $display(" %t Data Access : %h",$time,DHADDR);
		 $fdisplay(memf," %t Data Access : %h",$time,DHADDR);
	  end
   end // always
   
//synopsys translate_on

endmodule //arm_axi


