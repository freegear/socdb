// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// -----------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : TBROM_DTSDI002.v
// File Revision       : 1.0
// -----------------------------------------------------------------------------
// Purpose             : Verify SW-HW for the DTSDI002 system
// --=========================================================================--



`timescale 1ns/1ps

// Top level - no I/O
module TBROM_DTSDI002 ();

//------------------------------------------------------------------------------
// Constant declarations
//-----------------------------------------------------------------------------

// Bus Clock
//  `define PERIOD 7.5 // 133.3 MHz
//  `define PERIOD 7.518 // 133.0 MHz
//  `define PERIOD 10 // 100.0 MHz
    `define PERIOD 13 //72Mhz[13.89]=> real 76Mhz
//    `define PERIOD 13.89 //72Mhz[13.89]

//  `define PERIOD 15 //  66.6 MHz
//  `define PERIOD 15.152 // 66.0 MHz
//  `define PERIOD 20 //  50.0 MHz
//  `define PERIOD 25 //  40.0 MHz
//  `define PERIOD 30 //  33.3 MHz
//  `define PERIOD 40 //  25.0 MHz

  `define PHASETIME (`PERIOD / 2)

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// External signals
  reg         ARM_OSCi;        // External clock in
  reg         ARM_RESETi;        // Power on reset input
  reg         BOOT_MODE ;
// SMI interface signals
  wire [31:0] XD;
  wire [31:0] XDout;
  wire [30:0] XA;
  wire [7:0]  XCSN;
  wire        XOEN;
  wire [3:0]  XBLS;
  wire [3:0]  XDATAEN;

// TIC interface
  wire        TESTREQA;
  wire        TESTREQB;
  wire        TESTACK;

// JTAG connections
//wire        nTDOEN;
  
  wire        ARM_TRST ;
  wire        ARM_TCK  ;
  wire        ARM_TDI  ;
  wire        ARM_TMS  ;
  wire        ARM_TDO  ;


// ARM7TDMI comms debug signals
  wire        COMMTX;
  wire        COMMRX;

// GPIO signals
  wire [7:0]  GPIN;          // Inputs         
  wire [7:0]  GPOUT;         // Outputs        
  wire [7:0]  nGPEN;         // Output enable  
  wire [7:0]  nGPAFEN;       // H/w ctrl enable
  wire [7:0]  GPAFOUT;       // H/w ctrl input 
  wire [7:0]  GPAFIN;        // H/w ctrl output


  //Test
  wire        TEST_MODE ;
  // Scan signals
  wire        SCANENABLE;    // Scan Test Mode Enable   
  wire        SCANINHCLK;    // Scan Chain Input (HCLK)
  wire        SCANOUTHCLK;   // Scan Chain Output (HCLK)
  wire        SCANINPCLK;    // Scan Chain Input (PCLK)
  wire        SCANOUTPCLK;   // Scan Chain Output (PCLK)
 

 reg		Douten	;	// H(datain)/L(dataout)
 reg	[1:0]	Datain	;	// 
 

 tri	[1:0]	i_SDA	     ;
 tri	[1:0]	i_SCL	     ;	

assign i_SDA = Douten ? i_SDA : 2'bZZ ;
assign i_SCL = Douten ? i_SCL : 2'bZZ ;

`include "./task_dtsdi.v"

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

// The ARM7TDMI-based
  Top_DTSDI002  DTSDI002  
    (
     .ARM_OSCi      (ARM_OSCi),
     .ARM_RESETi    (ARM_RESETi),
     .BOOT_MODE     (BOOT_MODE),
     //I2C
     .I2C0_SCL     (i_SCL   ),
     .I2C0_SDA     (i_SDA   ),

     .SMDATAIN    (XD),
     .SMDATAOUT   (XDout),
     .nSMDATAEN   (XDATAEN),
     .SMADDR      (XA[25:0]),
     .SMCS        (XCSN),
     .nSMBLS      (XBLS),
     .nSMOEN      (XOEN),

     .TESTREQA    (TESTREQA),
     .TESTREQB    (TESTREQB),
     .TESTACK     (TESTACK),
     
     .ARM_TRST    (ARM_TRST ),
     .ARM_TCK     (ARM_TCK  ),
     .ARM_TDI     (ARM_TDI  ),
     .ARM_TMS     (ARM_TMS  ),
     .ARM_TDO     (ARM_TDO  ),

     .COMMRX      (COMMRX),
     .COMMTX      (COMMTX),

     .GPIN        (GPIN),
     .GPOUT       (GPOUT),
     .nGPEN       (nGPEN),
     .nGPAFEN     (nGPAFEN),
     .GPAFOUT     (GPAFOUT),
     .GPAFIN      (GPAFIN),

     //TEST
     .TEST_MODE   (TEST_MODE),
     // Scan test dummy signals; not connected until scan insertion
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINHCLK),  // Scan Chain Input (HCLK)
     .SCANOUTHCLK (SCANOUTHCLK), // Scan Chain Output (HCLK)
     .SCANINPCLK  (SCANINPCLK),  // Scan Chain Input (PCLK)
     .SCANOUTPCLK (SCANOUTPCLK)  // Scan Chain Output (PCLK)
    );

  assign XA[30:26] = {5{1'b0}};


// Tube is connected to the SMI
  Tube uTube 
    (
     .XD   (XD),
     .XCSN (XCSN[7:4]),
     .XWEN (XBLS)
    );

// External RAM and ROM
  Memory uMemory 
    (
     .XA   (XA),
     .XD   (XD),
     .XCSN (XCSN[7:4]),
     .XWEN (XBLS),
     .XOEN (XOEN)
    );


// TIC inputs unused
  assign TESTREQA = 1'b0;
  assign TESTREQB = 1'b0;
  
// JTAG inputs unused
//  assign nTRST = 1'b0;
//  assign TCK = 1'b0;
//  assign TDI = 1'b0;
//  assign TMS = 1'b0;

  assign ARM_TRST = 1'b0;
  assign ARM_TCK =  1'b0;
  assign ARM_TDI =  1'b0;
  assign ARM_TMS =  1'b0;

//TEST
  assign TEST_MODE = 1'b0;
// Scan signals unused
  assign SCANENABLE = 1'b0;
  assign SCANINHCLK = 1'b0;
  assign SCANINPCLK = 1'b0;  
  
// Merge the external data bus signals 
  assign XD = ((XDATAEN[0] == 1'b0) ? XDout : (32'bz));

// GPIO alternate function lines tied inactive for integration tests
  assign nGPAFEN = {8{1'b1}};
  assign GPAFOUT = {8{1'b0}};


//------------------------------------------------------------------------
//-- The inputs to the GPIO Alt. Funct. Output are controlled via writes
//-- to the GTAOUTR register
//--                 ________
//-- nGPEN[7:0] >---\\       \
//--                || XOR    -----  
//-- GPOUT[7:0] >---//_______/     |
//--                               |
//-- GPIN[7:0]  <------------------
//--
//--
//-- XOR
//-- --------------------------------
//-- nGPEN[i]   GPOUT[i]   |  GPIN[i]
//-- --------------------------------
//--     0         0       |    0
//--     0         1       |    1
//--     1         0       |    1
//--     1         1       |    0
//-- --------------------------------
//------------------------------------------------------------------------

// Simple loop-back circuit for the integration tests (see above note)
  assign GPIN = (nGPEN ^ GPOUT);

//External Stimulus
initial begin
INIT ;

end

// This controls the clock generation for the system
  always 
    begin : p_ClockGenComb
      ARM_OSCi = 1'b0;
      #`PHASETIME;
      ARM_OSCi = 1'b1;
      #`PHASETIME;
    end

// This controls the timing of the Reset signal.
// The loop values should be changed for different reset timing
  initial
    begin : p_RstComb
      ARM_RESETi = 1'b0;
      begin : reset_loop
        integer i;
        for (i = 1; i <= 20; i = i + 1)
          @ (ARM_OSCi);
      end
      ARM_RESETi = #1 1'b1; // Hold time for ResCntl SyncPOR register
    end

initial begin
        //$shm_open("sim_EASY_ARM7");
        //$shm_open("sim_EASY_ARM7_hellow_noROM");
        //$shm_open("sim_EASY_ARM7_hellow");
        $shm_open("sim_EASY_ARM7_it");
        $shm_probe("AC");
	// VCD dump
	//$dumpfile("dump.vcd");
	//$dumpvars;
end

endmodule

//  --========================================================================--

