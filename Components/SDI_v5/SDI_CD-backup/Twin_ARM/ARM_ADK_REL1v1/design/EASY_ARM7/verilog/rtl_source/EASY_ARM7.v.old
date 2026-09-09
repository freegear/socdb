//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : EASY_ARM7.v,v
//  File Revision       : 1.4
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Structural architecture of Example Amba SYstem (EASY)
//                        with ARM7TDMI core, AHB-AHB Bridge and EgMaster.
//  --========================================================================--

`timescale 1ns/1ps

//------------------------------------------------------------------------------
// EASY_ARM7 Address Map
//------------------------------------------------------------------------------
// Full Decoding of the Address Map is performed continuously as a function of
//  HADDR. All unused slots are connected to a Default Slave.
//
// Address map for AHB1 is:
//
// 0x00000000 - 0x000FFFFF Default Slave (Remap LOW)  (HSELS0B) (SMI alias)
// 0x00000000 - 0x000FFFFF IntMem alias  (Remap HIGH) (HSELS0R)
// 0x00100000 - 0x10000000 Default Slave              (HSELS0)  (SDRAM)
// 0x10000000 - 0x1FFFFFFF Default Slave              (HSELS1)
// 0x20000000 - 0x2FFFFFFF Default Slave              (HSELS2)
// 0x30000000 - 0x3FFFFFFF SMI                        (HSELS3)
// 0x40000000 - 0x4FFFFFFF Default Slave              (HSELS4)
// 0x50000000 - 0x5FFFFFFF Default Slave              (HSELS5)
// 0x60000000 - 0x6FFFFFFF Default Slave              (HSELS6)
// 0x70000000 - 0x7FFFFFFF IntMem                     (HSELS7)
// 0x80000000 - 0x8FFFFFFF Default Slave              (HSELS8)
// 0x90000000 - 0x9FFFFFFF Default Slave              (HSELS9)
// 0xA0000000 - 0xAFFFFFFF Default Slave              (HSELS10)
// 0xB0000000 - 0xBFFFFFFF Default Slave              (HSELS11)
// 0xC0000000 - 0xCFFFFFFF AHB-AHB Bridge             (HSELS12)
// 0xD0000000 - 0xDFFFFFFF AHB-AHB Bridge             (HSELS13)
// 0xE0000000 - 0xEFFFFFFF Default Slave              (HSELS14)
// 0xF0000000 - 0xFFFFFFFF Interrupt Controller       (HSELS15)
//
// Address map for AHB2 is:
//
// 0x00000000 - 0x0FFFFFFF Default Slave              (HSELS0)
// 0x10000000 - 0x1FFFFFFF Default Slave              (HSELS1)
// 0x20000000 - 0x2FFFFFFF Default Slave              (HSELS2)
// 0x30000000 - 0x3FFFFFFF Default Slave              (HSELS3)
// 0x40000000 - 0x4FFFFFFF Default Slave              (HSELS4)
// 0x50000000 - 0x5FFFFFFF Default Slave              (HSELS5)
// 0x60000000 - 0x6FFFFFFF Default Slave              (HSELS6)
// 0x70000000 - 0x7FFFFFFF Default Slave              (HSELS7)
// 0x80000000 - 0x8FFFFFFF Default Slave              (HSELS8)
// 0x90000000 - 0x9FFFFFFF Default Slave              (HSELS9)
// 0xA0000000 - 0xAFFFFFFF Default Slave              (HSELS10)
// 0xB0000000 - 0xBFFFFFFF Default Slave              (HSELS11)
// 0xC0000000 - 0xCFFFFFFF APB Peripherals            (HSELS12)
// 0xD0000000 - 0xDFFFFFFF Retry Slave                (HSELS13)
// 0xE0000000 - 0xEFFFFFFF Default Slave              (HSELS14)
// 0xF0000000 - 0xFFFFFFFF Default Slave              (HSELS15)
//
// APB Peripheral address decoding is:
//
// 0xC0000000 - 0xC0FFFFFF Unused                     (PSELS0)  (System Control)
// 0xC1000000 - 0xC1FFFFFF Watchdog                   (PSELS1)
// 0xC2000000 - 0xC2FFFFFF Timers                     (PSELS2)
// 0xC3000000 - 0xC3FFFFFF Unused                     (PSELS3)  (Extra Timers)
// 0xC4000000 - 0xC4FFFFFF GPIO                       (PSELS4)
// 0xC5000000 - 0xC5FFFFFF Unused                     (PSELS5)  (Extra GPIO)
// 0xC6000000 - 0xC6FFFFFF Unused                     (PSELS6)  (Extra GPIO)
// 0xC7000000 - 0xC7FFFFFF Unused                     (PSELS7)  (Extra GPIO)
// 0xC8000000 - 0xC8FFFFFF Remap/Pause                (PSELS8)
// 0xC9000000 - 0xC9FFFFFF Unused                     (PSELS9)
// 0xCA000000 - 0xCAFFFFFF Unused                     (PSELS10)
// 0xCB000000 - 0xCBFFFFFF Unused                     (PSELS11)
// 0xCC000000 - 0xCCFFFFFF Unused                     (PSELS12)
// 0xCD000000 - 0xCDFFFFFF Unused                     (PSELS13)
// 0xCE000000 - 0xCEFFFFFF Unused                     (PSELS14)
// 0xCF000000 - 0xCFFFFFFF EgAPBSlave                 (PSELS15)
//
//------------------------------------------------------------------------------


module EASY_ARM7 (XCLKIN, nReset, SMDATAIN, SMDATAOUT, nSMDATAEN, SMADDR, 
                  SMCS, nSMBLS, nSMOEN, TESTREQA, TESTREQB, TESTACK, nTRST, 
                  TCK, TDI, TMS, TDO, nTDOEN, COMMRX, COMMTX, GPIN, GPOUT, 
                  nGPEN, nGPAFEN, GPAFOUT, GPAFIN, SCANENABLE, SCANINHCLK, 
                  SCANOUTHCLK, SCANINPCLK, SCANOUTPCLK);
                  
  input         XCLKIN;      // External clock in
  input         nReset;      // Power on reset in

  input  [31:0] SMDATAIN;    // Data from Memory to SMC
  output [31:0] SMDATAOUT;   // Data Bus output from SMC to Memory
  output [3:0]  nSMDATAEN;   // Tri-state I/O pad enable for the byte lanes of
                             //  external memory data bus
  output [25:0] SMADDR;      // External Memory address bus
  output [7:0]  SMCS;        // Memory bank Chip Select output pins
  output [3:0]  nSMBLS;      // Memory device Byte lane enables
  output        nSMOEN;      // Memory Output Enable 
                             //  (complement serves as Write-Enable)
                           
  // TIC test command signals
  input         TESTREQA;    // Test bus request A
  input         TESTREQB;    // Test bus request B
  output        TESTACK;     // Test acknowledge
    
  // JTAG connections
  input         nTRST;
  input         TCK;
  input         TDI;
  input         TMS;
  output        TDO;
  output        nTDOEN;

  // ARM7TDMI comms channel debug lines
  output        COMMRX;
  output        COMMTX;

  // GPIO lines
  input  [7:0]  GPIN;        // Inputs
  input  [7:0]  nGPAFEN;     // Outputs
  input  [7:0]  GPAFOUT;     // Output ctrl enables
  output [7:0]  GPOUT;       // H/w ctrl enables
  output [7:0]  nGPEN;       // H/w ctrl inputs
  output [7:0]  GPAFIN;      // H/w ctrl outputs

  // Scan test dummy signals; not connected until scan insertion 
  input         SCANENABLE;  // Scan Test Mode Enbl
  input         SCANINHCLK;  // Scan Chain Input (HCLK)
  input         SCANINPCLK;  // Scan Chain Output (HCLK)
  output        SCANOUTHCLK; // Scan Chain Input (PCLK)
  output        SCANOUTPCLK; // Scan Chain Output (PCLK)

  // Port wires
  wire          XCLKIN;
  wire          nReset;

  wire   [31:0] SMDATAIN;
  wire   [31:0] SMDATAOUT;
  wire   [3:0]  nSMDATAEN;
  wire   [25:0] SMADDR;
  wire   [7:0]  SMCS;
  wire   [3:0]  nSMBLS;
  wire          nSMOEN;

  wire          TESTREQA;
  wire          TESTREQB;
  wire          TESTACK;

  wire          nTRST;
  wire          TCK;
  wire          TDI;
  wire          TMS;
  wire          TDO;
  wire          nTDOEN;

  wire          COMMRX;
  wire          COMMTX;

  wire   [7:0]  GPIN;    
  wire   [7:0]  GPOUT;   
  wire   [7:0]  nGPEN;   
  wire   [7:0]  nGPAFEN; 
  wire   [7:0]  GPAFOUT; 
  wire   [7:0]  GPAFIN;  

  wire          SCANENABLE; 
  wire          SCANINHCLK; 
  wire          SCANOUTHCLK;
  wire          SCANINPCLK; 
  wire          SCANOUTPCLK;

  
//------------------------------------------------------------------------------
// Signal declarations: AHB Common
//------------------------------------------------------------------------------

  wire          HCLK;
  wire          HRESETn;

//------------------------------------------------------------------------------
// Signal declarations: AHB1
//------------------------------------------------------------------------------

// AHB1 backbone 
  wire   [1:0]  HTRANS1;
  wire   [31:0] HADDR1;
  wire          HWRITE1;
  wire   [2:0]  HSIZE1;
  wire   [2:0]  HBURST1;
  wire   [3:0]  HPROT1;
  wire   [31:0] HWDATA1;
  wire   [3:0]  HMASTER1;
  wire   [3:0]  HMASTERD1;
  wire          HMASTLOCK1;
  wire   [15:0] HSPLIT1;

// Multiplexed slave output signals
  wire   [31:0] HRDATA1;
  wire          HREADY1;
  wire   [1:0]  HRESP1;

// Slave specific output signals
  wire          HSEL1S0B;
  wire          HSEL1S0R;

  wire          HSEL1S0;
  wire   [31:0] HRDATA1S0;
  wire          HREADY1S0;
  wire   [1:0]  HRESP1S0;

  wire          HSEL1S1;
  wire   [31:0] HRDATA1S1;
  wire          HREADY1S1;
  wire   [1:0]  HRESP1S1;

  wire          HSEL1S2;
  wire   [31:0] HRDATA1S2;
  wire          HREADY1S2;
  wire   [1:0]  HRESP1S2;

  wire          HSEL1S3;
  wire   [31:0] HRDATA1S3;
  wire          HREADY1S3;
  wire   [1:0]  HRESP1S3;

  wire          HSEL1S4;
  wire   [31:0] HRDATA1S4;
  wire          HREADY1S4;
  wire   [1:0]  HRESP1S4;

  wire          HSEL1S5;
  wire   [31:0] HRDATA1S5;
  wire          HREADY1S5;
  wire   [1:0]  HRESP1S5;

  wire          HSEL1S6;
  wire   [31:0] HRDATA1S6;
  wire          HREADY1S6;
  wire   [1:0]  HRESP1S6;

  wire          HSEL1S7;
  wire   [31:0] HRDATA1S7;
  wire          HREADY1S7;
  wire   [1:0]  HRESP1S7;

  wire          HSEL1S8;
  wire          HSEL1S9;
  wire          HSEL1S10;
  wire          HSEL1S11;
  wire          HSEL1S12;
  wire          HSEL1S13;
  wire          HSEL1S14;
  wire          HSEL1S15;

  wire          HREADY1DefSlv;
  wire   [1:0]  HRESP1DefSlv;

// Miscellaneous AHB select lines
  wire          HSEL1DefSlv;
  wire          HSEL1IntMem;
  wire          HSEL1Smi;
  wire          HSEL1bridge;

// Master specific signals
  wire          HBUSREQ1M0;
  wire          HLOCK1M0;
  wire          HGRANT1M0;

  wire   [31:0] HADDR1M1;
  wire   [1:0]  HTRANS1M1;
  wire          HWRITE1M1;
  wire   [2:0]  HSIZE1M1;
  wire   [2:0]  HBURST1M1;
  wire   [3:0]  HPROT1M1;
  wire   [31:0] HWDATA1M1;
  wire          HBUSREQ1M1;
  wire          HLOCK1M1;
  wire          HGRANT1M1;

  wire   [31:0] HADDR1M2;
  wire   [1:0]  HTRANS1M2;
  wire          HWRITE1M2;
  wire   [2:0]  HSIZE1M2;
  wire   [2:0]  HBURST1M2;
  wire   [3:0]  HPROT1M2;
  wire   [31:0] HWDATA1M2;
  wire          HBUSREQ1M2;
  wire          HLOCK1M2;
  wire          HGRANT1M2;

  wire   [31:0] HADDR1M3;
  wire   [1:0]  HTRANS1M3;
  wire          HWRITE1M3;
  wire   [2:0]  HSIZE1M3;
  wire   [2:0]  HBURST1M3;
  wire   [3:0]  HPROT1M3;
  wire   [31:0] HWDATA1M3;
  wire          HBUSREQ1M3;
  wire          HLOCK1M3;
  wire          HGRANT1M3;

//------------------------------------------------------------------------------
// Signal declarations: AHB2
//------------------------------------------------------------------------------

// AHB2 backbone 
  wire   [1:0]  HTRANS2;
  wire   [31:0] HADDR2;
  wire          HWRITE2;
  wire   [2:0]  HSIZE2;
  wire   [2:0]  HBURST2;
  wire   [3:0]  HPROT2;
  wire   [31:0] HWDATA2;
  wire   [3:0]  HMASTER2;
  wire   [3:0]  HMASTERD2;
  wire          HMASTLOCK2;
  wire   [15:0] HSPLIT2;

// Multiplexed slave output signals
  wire   [31:0] HRDATA2;
  wire          HREADY2;
  wire   [1:0]  HRESP2;

// Slave specific output signals
  wire          HSEL2S0B;
  wire          HSEL2S0R;

  wire          HSEL2S0;
  wire   [31:0] HRDATA2S0;
  wire          HREADY2S0;
  wire   [1:0]  HRESP2S0;

  wire          HSEL2S1;
  wire   [31:0] HRDATA2S1;
  wire          HREADY2S1;
  wire   [1:0]  HRESP2S1;

  wire          HSEL2S2;
  wire   [31:0] HRDATA2S2;
  wire          HREADY2S2;
  wire   [1:0]  HRESP2S2;

  wire          HSEL2S3;
  wire   [31:0] HRDATA2S3;
  wire          HREADY2S3;
  wire   [1:0]  HRESP2S3;

  wire          HSEL2S4;
  wire   [31:0] HRDATA2S4;
  wire          HREADY2S4;
  wire   [1:0]  HRESP2S4;

  wire          HSEL2S5;
  wire   [31:0] HRDATA2S5;
  wire          HREADY2S5;
  wire   [1:0]  HRESP2S5;

  wire          HSEL2S6;
  wire   [31:0] HRDATA2S6;
  wire          HREADY2S6;
  wire   [1:0]  HRESP2S6;

  wire          HSEL2S7;
  wire   [31:0] HRDATA2S7;
  wire          HREADY2S7;
  wire   [1:0]  HRESP2S7;

  wire          HSEL2S8;
  wire          HSEL2S9;
  wire          HSEL2S10;
  wire          HSEL2S11;
  wire          HSEL2S12;
  wire          HSEL2S13;
  wire          HSEL2S14;
  wire          HSEL2S15;

  wire          HREADY2DefSlv;
  wire   [1:0]  HRESP2DefSlv;

// Miscellaneous AHB select lines
  wire          HSEL2DefSlv;

// Master specific signals
  wire          HBUSREQ2M0;
  wire          HLOCK2M0;
  wire          HGRANT2M0;

  wire   [31:0] HADDR2M1;
  wire   [1:0]  HTRANS2M1;
  wire          HWRITE2M1;
  wire   [2:0]  HSIZE2M1;
  wire   [2:0]  HBURST2M1;
  wire   [3:0]  HPROT2M1;
  wire   [31:0] HWDATA2M1;
  wire          HBUSREQ2M1;
  wire          HLOCK2M1;
  wire          HGRANT2M1;

  wire   [31:0] HADDR2M2;
  wire   [1:0]  HTRANS2M2;
  wire          HWRITE2M2;
  wire   [2:0]  HSIZE2M2;
  wire   [2:0]  HBURST2M2;
  wire   [3:0]  HPROT2M2;
  wire   [31:0] HWDATA2M2;
  wire          HBUSREQ2M2;
  wire          HLOCK2M2;
  wire          HGRANT2M2;

  wire   [31:0] HADDR2M3;
  wire   [1:0]  HTRANS2M3;
  wire          HWRITE2M3;
  wire   [2:0]  HSIZE2M3;
  wire   [2:0]  HBURST2M3;
  wire   [3:0]  HPROT2M3;
  wire   [31:0] HWDATA2M3;
  wire          HBUSREQ2M3;
  wire          HLOCK2M3;
  wire          HGRANT2M3;

//------------------------------------------------------------------------------
// Signal declarations: APB
//------------------------------------------------------------------------------

// APB backbone
  wire          PENABLE;
  wire   [23:0] PADDR;
  wire          PWRITE;
  wire   [31:0] PWDATA;
  wire   [31:0] PRDATA;

// Slave-select lines
  wire          PSELS0;
  wire          PSELS1;
  wire          PSELS2;
  wire          PSELS3;
  wire          PSELS4;
  wire          PSELS5;
  wire          PSELS6;
  wire          PSELS7;
  wire          PSELS8;
  wire          PSELS9;
  wire          PSELS10;
  wire          PSELS11;
  wire          PSELS12;
  wire          PSELS13;
  wire          PSELS14;
  wire          PSELS15;

// Slave read-data outputs
  wire   [31:0] PRDATAS0;
  wire   [31:0] PRDATAS1;
  wire   [31:0] PRDATAS2;
  wire   [31:0] PRDATAS3;
  wire   [31:0] PRDATAS4;
  wire   [31:0] PRDATAS5;
  wire   [31:0] PRDATAS6;
  wire   [31:0] PRDATAS7;
  wire   [31:0] PRDATAS8;
  wire   [31:0] PRDATAS9;
  wire   [31:0] PRDATAS10;
  wire   [31:0] PRDATAS11;
  wire   [31:0] PRDATAS12;
  wire   [31:0] PRDATAS13;
  wire   [31:0] PRDATAS14;
  wire   [31:0] PRDATAS15;

//------------------------------------------------------------------------------
// Signal declarations: System specific
//------------------------------------------------------------------------------

// Timer interrupt lines
  wire          TIMINT1;    // Timer interrupt 1 
  wire          TIMINT2;    // Timer interrupt 2 
  wire          TIMINTC;    // Combined timer interrupt 

// Watchdog interrupt line
  wire          WDOGINT;

// Watchdog reset lines
  wire          WDOGRESn;   // Input   
  wire          WDOGRES;    // Output 

// GPIO signals
  wire          GPIOINTR;   // GPIO interrupt 
  wire   [7:0]  GPIOMIS;    // GPIO interrupt bus 

// System interrupt bus
  wire   [31:0] IntSource;

// Fast interrupt request output from Interrupt Controller
  wire          nFIQ;

// Interrupt request output from Interrupt Controller
  wire          nIRQ;

// Interrupt controller vector address
  wire   [31:0] ICVECTADDROUT;

// Remap and Pause controller
  wire          Remap;
  wire          Pause;

// Unused SMI outputs
  wire          TICBUSREQEBI;
  wire          SMBUSREQEBI;
  wire          MCBUSGNT;
  wire          nSMWEN;
  wire          TICREADEBI;
  wire   [31:0] TBUSOUTEBI;

// Test bus signals
  wire          HSELtst;
  wire          HBUSREQtst;
  reg           HGRANTtst;
  wire   [31:0] HADDRtst;
  wire   [1:0]  HTRANStst;
  wire   [2:0]  HBURSTtst;
  wire   [2:0]  HSIZEtst;
  wire          HWRITEtst;
  wire   [31:0] HWDATAtst;
  wire   [3:0]  HPROTtst;
  wire          HLOCKtst;
  wire          HREADYtst;
  wire   [1:0]  HRESPtst;
  wire   [31:0] HRDATAtst;

//------------------------------------------------------------------------------
// Signal declarations: Scan chain
//------------------------------------------------------------------------------
  wire          SCANINa7tdmi;
  wire          SCANOUTa7tdmi;
  wire          SCANINtimers;
  wire          SCANOUTtimers;
  wire          SCANINwdog;
  wire          SCANOUTwdog;
  wire          SCANINrpc;
  wire          SCANOUTrpc;
  wire          SCANINic;
  wire          SCANOUTic;
  wire          SCANINgpio;
  wire          SCANOUTgpio;
  wire          SCANINegapb;
  wire          SCANOUTegapb;
  wire          SCANINarb1;
  wire          SCANOUTarb1;
  wire          SCANINdefslv1;
  wire          SCANOUTdefslv1;
  wire          SCANINs2m1;
  wire          SCANOUTs2m1;
  wire          SCANINarb2;
  wire          SCANOUTarb2;
  wire          SCANINdefslv2;
  wire          SCANOUTdefslv2;
  wire          SCANINs2m2;
  wire          SCANOUTs2m2;
  wire          SCANINegmst;
  wire          SCANOUTegmst;
  wire          SCANINretry;
  wire          SCANOUTretry;
  wire          SCANINapb;
  wire          SCANOUTapb;
  wire          SCANINahbbr;
  wire          SCANOUTahbbr;
  wire          SCANINsmi;
  wire          SCANOUTsmi;
  wire          SCANINnsmi;
  wire          SCANOUTnsmi;

//------------------------------------------------------------------------------
// Signal declarations: Tie-offs
//------------------------------------------------------------------------------

  wire          TieOffHi1;
  wire          TieOffLo1;
  wire   [1:0]  TieOffLo2;
  wire   [3:0]  TieOffLo4;
  wire   [25:0] TieOffLo26;
  wire   [31:0] TieOffLo32;


//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Common system features
//------------------------------------------------------------------------------

// The TieOff signals must be assigned explicitly within the body of the RTL.
// Using initial values (in the signal declaration, above) will not work in
// Synopsys. Signals are used rather than constants as constants can not be 
// connected directly to sub-component instantiations
  assign TieOffHi1  = 1'b1;
  assign TieOffLo1  = 1'b0;
  assign TieOffLo2  = 2'b00;
  assign TieOffLo4  = 4'b0000;
  assign TieOffLo26 = {26{1'b0}};
  assign TieOffLo32 = {32{1'b0}};

// Drive the AHB clock with the external clock input.
  assign HCLK = XCLKIN;

// Common reset controller
  ResetCntl uResetCntl
    (
     .HCLK     (HCLK),
     .nPOReset (nReset),
     .WDOGRES  (WDOGRES),
     .HRESETn  (HRESETn),
     .WDOGRESn (WDOGRESn)
    );

//------------------------------------------------------------------------------
// AHB System 1
//------------------------------------------------------------------------------

// ARM7TDMI core wrapper, instantiated as master 1 on AHB1 (lowest priority).
// The Test interface is connected to the TIC via a separate AHB test bus
  A7TDMI uA7TDMI
    (
     // Common AHB Signals
     .HCLK       (HCLK),
     .HRESETn    (HRESETn),

     // Signals to AMBA bus used during normal operation
     .HBUSREQM   (HBUSREQ1M1),
     .HGRANTM    (HGRANT1M1),
     .HADDRM     (HADDR1M1),
     .HTRANSM    (HTRANS1M1),
     .HWRITEM    (HWRITE1M1),
     .HSIZEM     (HSIZE1M1),
     .HBURSTM    (HBURST1M1),
     .HPROTM     (HPROT1M1),
     .HWDATAM    (HWDATA1M1),
     .HLOCKM     (HLOCK1M1),

     // Signals from AMBA bus used during normal operation
     .HRDATAM    (HRDATA1),
     .HREADYM    (HREADY1),
     .HRESPM     (HRESP1),

     // Signals from AMBA bus used during test mode
     .HSELS      (HSELtst),
     .HTRANS1S   (HTRANStst[1]),
     .HWRITES    (HWRITEtst),
     .HWDATAS    (HWDATAtst),
     .HREADYS    (HREADYtst), // HREADYOUT (test) is fed-back  


     // Signals to AMBA bus used during test mode
     .HRDATAS    (HRDATAtst),
     .HREADYOUTS (HREADYtst),
     .HRESPS     (HRESPtst),

     // ARM7TDMI interrupts
     .ARMNFIQ    (nFIQ),
     .ARMNIRQ    (nIRQ),

     // Comms channel signals
     .COMMRX     (COMMRX),
     .COMMTX     (COMMTX),

     // JTAG connections
     .nTRST      (nTRST),
     .TCK        (TCK),
     .TDI        (TDI),
     .TMS        (TMS),
     .nTDOEN     (nTDOEN),
     .TDO        (TDO),

      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE    (SCANENABLE),     // Scan Test Mode Enbl
     .SCANINHCLK    (SCANINa7tdmi),       // Scan Chain Input
     .SCANOUTHCLK   (SCANOUTa7tdmi)       // Scan Chain Output
    );

// The Static Memory Interface, instantiated as slave 3 on AHB1 (aliased to 
//  Slot 0 at boot). Also incorporates the Test Interface Controller (master
//  on separate AHBtst bus)
  SMI uSMI
    (
     // Common AHB signals
     .HCLK         (HCLK),
     .HRESETn      (HRESETn),

     .nHCLK        (TieOffLo1),         // Not used

     // SMI slave interface signals (AHB)
     .HADDR        (HADDR1[28:0]),
     .HBURST       (HBURST1),           // Not used
     .HTRANS       (HTRANS1),
     .HWRITE       (HWRITE1),
     .HSIZE        (HSIZE1),
     .HWDATA       (HWDATA1),
     .HREADYIN     (HREADY1),

     .HSELSMC      (HSEL1Smi),          // Decoder slots 0 (boot) and 3
     .HSELREG      (TieOffLo1),         // Not used

     .HRDATA       (HRDATA1S1),         // Channel 1 of uMuxMtoS1
     .HREADYOUT    (HREADY1S1),
     .HRESP        (HRESP1S1),

     .BIGENDIAN    (TieOffLo1),         // Not used
     .REMAP        (Remap),

     .MCBUSREQ     (TieOffLo1),         // Not used
     .MCBUSGNT     (MCBUSGNT),          // Not used
     .MCADDR       (TieOffLo26),        // Not used
     .MCDATAOUT    (TieOffLo32),        // Not used
     .MCDATAEN     (TieOffLo4),         // Not used

     .EXTBUSMUX    (TieOffLo1),         // Not used

     // Top-level interface signals
     .SMBUSREQEBI  (SMBUSREQEBI),       // Not used
     .SMBUSGNTEBI  (TieOffLo1),         // Not used
     .SMDATAIN     (SMDATAIN),          // Data from Memory to SMI
     .SMDATAOUT    (SMDATAOUT),         // Data from SMI to Memory
     .nSMDATAEN    (nSMDATAEN),         // Data tri-state pad en
     .SMADDR       (SMADDR),            // External address bus
     .SMCS         (SMCS),              // External chip selects
     .nSMBLS       (nSMBLS),            // External byte lane write en
     .nSMWEN       (nSMWEN),            // Not used
     .nSMOEN       (nSMOEN),            // External read enable
     .SMWAIT       (TieOffLo1),         // Not used
     .CANCELSMWAIT (TieOffLo1),         // Not used
     .SMMWCS7      (TieOffLo2),         // Not used

     // TIC test command signals
     .TESTREQA     (TESTREQA),
     .TESTREQB     (TESTREQB),
     .TESTACK      (TESTACK),

     // TIC master interface signals (AHBtst)
     .HBUSREQTIC   (HBUSREQtst),
     .HGRANTTIC    (HGRANTtst),

     .HADDRTIC     (HADDRtst),
     .HTRANSTIC    (HTRANStst),
     .HWRITETIC    (HWRITEtst),
     .HSIZETIC     (HSIZEtst),
     .HBURSTTIC    (HBURSTtst),
     .HPROTTIC     (HPROTtst),
     .HWDATATIC    (HWDATAtst),
     .HLOCKTIC     (HLOCKtst),

     .HREADYINTIC  (HREADYtst),
     .HRESPTIC     (HRESPtst),
     .HRDATATIC    (HRDATAtst),

     .TICBUSREQEBI (TICBUSREQEBI),      // Not used
     .TICBUSGNTEBI (TieOffLo1),         // Not used
     .TICREADEBI   (TICREADEBI),        // Not used
     .TBUSOUTEBI   (TBUSOUTEBI),        // Not used

      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE   (SCANENABLE),        
     .SCANINHCLK   (SCANINsmi),         // Rising edge sample
     .SCANINnHCLK  (SCANINnsmi),        // Falling edge sample
     .SCANOUTHCLK  (SCANOUTsmi),        // Rising edge update
     .SCANOUTnHCLK (SCANOUTnsmi)        // Falling edge update
    );

// Internal Memory instantiated as AHB slave 7 and 0 (after re-map)
  IntMem     
  // synopsys translate_off
    // Parameters:
    //   Memory size in address bits: MemBits = 10
    //   Memory initialisation file name: FileName = "intram.dat"     
    #(10, "intram.dat")
  // synopsys translate_on
  uIntMem 
    (
     .HCLK       (HCLK),
     .HRESETn    (HRESETn),

     .HADDR      (HADDR1),
     .HTRANS     (HTRANS1),
     .HWRITE     (HWRITE1),
     .HSIZE      (HSIZE1),
     .HWDATA     (HWDATA1),

     .HSELIntMem (HSEL1IntMem),
     .HREADY     (HREADY1),

     .HRDATA     (HRDATA1S0), // Channel 0 of uMuxMtoS1
     .HREADYOUT  (HREADY1S0),
     .HRESP      (HRESP1S0)
    );

// Interrupt Controller instantiated as AHB slave 15
  Interrupt uInterrupt
    (
     .HCLK          (HCLK),
     .HRESETn       (HRESETn),

     .HADDR         (HADDR1[11:2]),
     .HTRANS        (HTRANS1[1]),
     .HWRITE        (HWRITE1),
     .HSIZE         (HSIZE1),
     .HPROT         (HPROT1[1]),      // Privileged access
     .HWDATA        (HWDATA1),
     .HREADY        (HREADY1),

     .HSELIC        (HSEL1S15),
     .HRDATA        (HRDATA1S3),      // Channel 3 of uMuxMtoS1
     .HRESP         (HRESP1S3),
     .HREADYOUT     (HREADY1S3),

     .ICINTSOURCE   (IntSource),      // System interrupts
     .nICFIQIN      (TieOffHi1),      // Connect daisy-chained
     .nICIRQIN      (TieOffHi1),      //  interrupt controllers here
     .ICVECTADDRIN  (TieOffLo32),
     .nICFIQ        (nFIQ),
     .nICIRQ        (nIRQ),
     .ICVECTADDROUT (ICVECTADDROUT),  // Not used

      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE    (SCANENABLE),     // Scan Test Mode Enbl
     .SCANINHCLK    (SCANINic),       // Scan Chain Input
     .SCANOUTHCLK   (SCANOUTic)       // Scan Chain Output
    );

  assign IntSource = 
    {GPIOMIS,        // 31:24 GPIO Masked interrupts
     4'b0000,        // 23:20
     4'b0000,        // 19:16
     4'b0000,        // 15:12
     3'b000,         // 11:9
     GPIOINTR,       // 8     GPIO Combined interrupt
     WDOGINT,        // 7     Watchdog
     TIMINTC,        // 6     Counter combined
     TIMINT2,        // 5     Counter 2
     TIMINT1,        // 4     Counter 1
     1'b0,           // 3     Undefined (ARM Comms Tx)
     1'b0,           // 2     Undefined (ARM Comms Rx)
     1'b0,           // 1     Software interrupt
     1'b0};          // 0     Undefined

// AHB to AHB Bridge instantiated as slave 12 on AHB1 (access to the
//  Retry Slave and APB Peripherals must be performed across this Bridge
//  on AHB2).
  Ahb2Ahb uAhb2Ahb
    (
      // Common AHB signals
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

      // AHB1 slave 12 and 13 (APBif and RetrySlave)
     .HSELS       (HSEL1bridge),

     .HADDRS      (HADDR1),
     .HTRANSS     (HTRANS1),
     .HWRITES     (HWRITE1),
     .HSIZES      (HSIZE1),
     .HBURSTS     (HBURST1),
     .HPROTS      (HPROT1),
     .HMASTLOCKS  (HMASTLOCK1),
     .HWDATAS     (HWDATA1),
     .HREADYS     (HREADY1),

     .HRDATAS     (HRDATA1S2),  // Channel 2 of uMuxMtoS1
     .HRESPS      (HRESP1S2),
     .HREADYOUTS  (HREADY1S2),

      // AHB2 master 1
     .HBUSREQM    (HBUSREQ2M1),
     .HGRANTM     (HGRANT2M1),
     .HADDRM      (HADDR2M1),
     .HTRANSM     (HTRANS2M1),
     .HWRITEM     (HWRITE2M1),
     .HSIZEM      (HSIZE2M1),
     .HBURSTM     (HBURST2M1),
     .HPROTM      (HPROT2M1),
     .HWDATAM     (HWDATA2M1),
     .HLOCKM      (HLOCK2M1),

     .HRDATAM     (HRDATA2),
     .HREADYM     (HREADY2),
     .HRESPM      (HRESP2),

      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINahbbr), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTahbbr) // Scan Chain Output
    );

//------------------------------------------------------------------------------
// AHB System 2
//------------------------------------------------------------------------------

// Example Bus Master instantiated as master 2 on AHB2
 EgMaster     
  // synopsys translate_off
    // Parameters:
    //   Block enable: EBMenable = 1, 
    //   Base address read: EBMreadAddr = 0xD0000000 (RetrySlave),
    //   Base address write: EBMwriteAddr = 0xD0000000 (RetrySlave),
    //   Delay between transactions: EBMinitCount = 4
    #(1, 8'hD0, 8'hD0, 10'h004)
  // synopsys translate_on
 uEgMaster 
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HBUSREQ     (HBUSREQ2M2),
     .HGRANT      (HGRANT2M2),

     .HADDR       (HADDR2M2),
     .HTRANS      (HTRANS2M2),
     .HWRITE      (HWRITE2M2),
     .HSIZE       (HSIZE2M2),
     .HBURST      (HBURST2M2),
     .HPROT       (HPROT2M2),
     .HWDATA      (HWDATA2M2),
     .HLOCK       (HLOCK2M2),

     .HRDATA      (HRDATA2),
     .HREADY      (HREADY2),
     .HRESP       (HRESP2),

      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINegmst), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTegmst) // Scan Chain Output
    );

// APB peripherals instantiated as slave 12 on AHB2
  APBif uAPBif
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HADDR       (HADDR2[27:0]),
     .HTRANS      (HTRANS2),
     .HWRITE      (HWRITE2),
     .HWDATA      (HWDATA2),
     .HSEL        (HSEL2S12),
     .HREADY      (HREADY2),

     .HRDATA      (HRDATA2S0), // Channel 0 of uMuxMtoS2
     .HREADYOUT   (HREADY2S0),
     .HRESP       (HRESP2S0),

     .PRDATA      (PRDATA),    // From MuxP2B output

     .PWDATA      (PWDATA),
     .PADDR       (PADDR),
     .PWRITE      (PWRITE),
     .PENABLE     (PENABLE),
     .PSELS0      (PSELS0),    // To APB slaves and MuxP2B
     .PSELS1      (PSELS1),
     .PSELS2      (PSELS2),
     .PSELS3      (PSELS3),
     .PSELS4      (PSELS4),
     .PSELS5      (PSELS5),
     .PSELS6      (PSELS6),
     .PSELS7      (PSELS7),
     .PSELS8      (PSELS8),
     .PSELS9      (PSELS9),
     .PSELS10     (PSELS10),
     .PSELS11     (PSELS11),
     .PSELS12     (PSELS12),
     .PSELS13     (PSELS13),
     .PSELS14     (PSELS14),
     .PSELS15     (PSELS15),
  
      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINapb),  // Scan Chain Input
     .SCANOUTHCLK (SCANOUTapb)  // Scan Chain Output
    );

// Retry Slave instantiated as slave 13 on AHB2
  RetrySlave uRetrySlave
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HADDR       (HADDR2),
     .HTRANS      (HTRANS2),
     .HWRITE      (HWRITE2),
     .HSIZE       (HSIZE2),
     .HWDATA      (HWDATA2),
     .HSELRetry   (HSEL2S13),
     .HREADY      (HREADY2),

     .HRDATA      (HRDATA2S1),   // Channel 1 of uMuxMtoS2
     .HREADYOUT   (HREADY2S1),
     .HRESP       (HRESP2S1),

      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINretry), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTretry) // Scan Chain Output
    );

//------------------------------------------------------------------------------
// AHB Infrastructure
//------------------------------------------------------------------------------

// TIC control logic -----------------------------------------------------------

  // Since TIC is the only master on the test bus, it can be granted as soon
  //  as a request is asserted. Note that HGRANTtst is not constantly asserted
  //  for power reasons
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_HGRANTtstSeq
      if  (!HRESETn)
        HGRANTtst <= 1'b0;
      else
        HGRANTtst <= HBUSREQtst;
    end 

  // Decode TIC address to create slave select signal to ARM core. Note that
  //  TIC tests from ARM will assume a base address of either 0xC0000000 or
  //  0x50000000 - the following is therefore a generic solution
  assign HSELtst = ((HADDRtst [31:28] != 4'b0000) ? 1'b1 : 1'b0);

// AHB1 System Infrastructure --------------------------------------------------

// AHB1 system Arbiter
  Arbiter3 uArbiterBus1
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HTRANS      (HTRANS1),
     .HBURST      (HBURST1),
     .HREADY      (HREADY1),
     .HRESP       (HRESP1),

     .HBUSREQM3   (HBUSREQ1M3),
     .HBUSREQM2   (HBUSREQ1M2),
     .HBUSREQM1   (HBUSREQ1M1),
     .HBUSREQM0   (HBUSREQ1M0),

     .HLOCKM3     (HLOCK1M3),
     .HLOCKM2     (HLOCK1M2),
     .HLOCKM1     (HLOCK1M1),
     .HLOCKM0     (HLOCK1M0),

     .HSPLIT      (HSPLIT1[3:0]),

     .HGRANTM3    (HGRANT1M3),
     .HGRANTM2    (HGRANT1M2),
     .HGRANTM1    (HGRANT1M1),
     .HGRANTM0    (HGRANT1M0),

     .HMASTER     (HMASTER1),
     .HMASTERD    (HMASTERD1),
     .HMASTLOCK   (HMASTLOCK1),
      
      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINarb1), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTarb1) // Scan Chain Output
    );

  // Pause requests Master 0 (2nd highest priority)
  assign HBUSREQ1M0 = Pause;

  // Unconnected Arbiter inputs driven LOW
  assign HBUSREQ1M3 = 1'b0;
  assign HLOCK1M3   = 1'b0;
  assign HBUSREQ1M2 = 1'b0;
  assign HLOCK1M2   = 1'b0;
  assign HLOCK1M0   = 1'b0;
  assign HSPLIT1    = {16{1'b0}};

// AHB1 system Address Decoder 
  Decoder uDecoder1
    (
     .HADDR   (HADDR1[31:20]),

     .Remap   (Remap),

     .HSELS0B (HSEL1S0B),
     .HSELS0R (HSEL1S0R),
     .HSELS0  (HSEL1S0),
     .HSELS1  (HSEL1S1),
     .HSELS2  (HSEL1S2),
     .HSELS3  (HSEL1S3),
     .HSELS4  (HSEL1S4),
     .HSELS5  (HSEL1S5),
     .HSELS6  (HSEL1S6),
     .HSELS7  (HSEL1S7),
     .HSELS8  (HSEL1S8),
     .HSELS9  (HSEL1S9),
     .HSELS10 (HSEL1S10),
     .HSELS11 (HSEL1S11),
     .HSELS12 (HSEL1S12),
     .HSELS13 (HSEL1S13),
     .HSELS14 (HSEL1S14),
     .HSELS15 (HSEL1S15)
    );

// Default Slave selected by all unused HSEL lines
  assign HSEL1DefSlv = 
    // HSEL1S0B |
    // HSEL1S0R |                       // IntMem alias
    HSEL1S0  |
    HSEL1S1  |
    HSEL1S2  |
    // HSEL1S3 |                        // SMI
    HSEL1S4  |
    HSEL1S5  |
    HSEL1S6  |
    // HSEL1S7 |                        // IntMem
    HSEL1S8  |
    HSEL1S9  |
    HSEL1S10 |
    HSEL1S11 |
    // HSEL1S12 |                       // APB Peripherals (via Bridge)
    // HSEL1S13 |                       // Retry Slave (via Bridge)
    HSEL1S14 
    // | HSEL1S15                       // Interrupt Controller
    ;

  // SMI occupies Slot 3 or Slot 0 (at boot) 
  assign HSEL1Smi = (HSEL1S0B | HSEL1S3);

  // Internal Memory occupies Slot 7 and Slot 0 (after re-map)
  assign HSEL1IntMem = (HSEL1S7 | HSEL1S0R);

  // The APB Peripherals and Retry Slave are accessed via the AHB-AHB Bridge
  assign HSEL1bridge = (HSEL1S12 | HSEL1S13);

// Default Slave 1 (selected when no other slaves are accessed on AHB1)
  DefaultSlave uDefaultSlave1
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HTRANS      (HTRANS1),
     .HSEL        (HSEL1DefSlv),
     .HREADY      (HREADY1),

     .HREADYOUT   (HREADY1DefSlv),
     .HRESP       (HRESP1DefSlv),

      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),    // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINdefslv1), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTdefslv1) // Scan Chain Output
    );

// Central multiplexer - masters to slaves on AHB1
  MuxM2S uMuxMtoS1
    (
     .HMASTER  (HMASTER1),
     .HMASTERD (HMASTERD1),
      
     .HADDRM1  (HADDR1M1),
     .HTRANSM1 (HTRANS1M1),
     .HWRITEM1 (HWRITE1M1),
     .HSIZEM1  (HSIZE1M1),
     .HBURSTM1 (HBURST1M1),
     .HPROTM1  (HPROT1M1),
     .HWDATAM1 (HWDATA1M1),
      
     .HADDRM2  (HADDR1M2),
     .HTRANSM2 (HTRANS1M2),
     .HWRITEM2 (HWRITE1M2),
     .HSIZEM2  (HSIZE1M2),
     .HBURSTM2 (HBURST1M2),
     .HPROTM2  (HPROT1M2),
     .HWDATAM2 (HWDATA1M2),
      
     .HADDRM3  (HADDR1M3),
     .HTRANSM3 (HTRANS1M3),
     .HWRITEM3 (HWRITE1M3),
     .HSIZEM3  (HSIZE1M3),
     .HBURSTM3 (HBURST1M3),
     .HPROTM3  (HPROT1M3),
     .HWDATAM3 (HWDATA1M3),
      
     .HADDR    (HADDR1),
     .HTRANS   (HTRANS1),
     .HWRITE   (HWRITE1),
     .HSIZE    (HSIZE1),
     .HBURST   (HBURST1),
     .HPROT    (HPROT1),
     .HWDATA   (HWDATA1)
    );

  // Unconnected MUX inputs
  assign HADDR1M3  = {32{1'b0}};
  assign HTRANS1M3 = 2'b00;
  assign HWRITE1M3 = 1'b0;
  assign HSIZE1M3  = 3'b000;
  assign HBURST1M3 = 3'b000;
  assign HPROT1M3  = 4'b0000;
  assign HWDATA1M3 = {32{1'b0}};

  assign HADDR1M2  = {32{1'b0}};
  assign HTRANS1M2 = 2'b00;
  assign HWRITE1M2 = 1'b0;
  assign HSIZE1M2  = 3'b000;
  assign HBURST1M2 = 3'b000;
  assign HPROT1M2  = 4'b0000;
  assign HWDATA1M2 = {32{1'b0}};

// Local multiplexer - slaves to masters on AHB1
//  This 8-input multiplexor is used in place of the 16-input version 
//  because it is faster to synthesise. However, in this application,
//  the input channel names do not always match the names of the signals
//  they are assigned to, though the multiplexor operation is unaffected.
  MuxS2M uMuxStoM1
    (
     .HCLK          (HCLK),
     .HRESETn       (HRESETn),

     .HSELS0        (HSEL1IntMem),  // Decoder slots 7 and 0 (after re-map)
     .HSELS1        (HSEL1Smi),     // Decoder slots 3 and 0 (at boot)
     .HSELS2        (HSEL1bridge),  // Decoder slots 12 and 13
     .HSELS3        (HSEL1S15),     // Decoder slot 15
     .HSELS4        (TieOffLo1),
     .HSELS5        (TieOffLo1),
     .HSELS6        (TieOffLo1),
     .HSELS7        (TieOffLo1),
     .HSELDefault   (HSEL1DefSlv),

     .HRDATAS0      (HRDATA1S0),    // IntMem
     .HREADYS0      (HREADY1S0),
     .HRESPS0       (HRESP1S0),

     .HRDATAS1      (HRDATA1S1),    // SMI
     .HREADYS1      (HREADY1S1),
     .HRESPS1       (HRESP1S1),

     .HRDATAS2      (HRDATA1S2),    // AHB-AHB Bridge (Retry Slave and
     .HREADYS2      (HREADY1S2),    //  APB Peripherals)
     .HRESPS2       (HRESP1S2),

     .HRDATAS3      (HRDATA1S3),    // Interrupt
     .HREADYS3      (HREADY1S3),
     .HRESPS3       (HRESP1S3),

     .HRDATAS4      (HRDATA1S4),
     .HREADYS4      (HREADY1S4),
     .HRESPS4       (HRESP1S4),

     .HRDATAS5      (HRDATA1S5),
     .HREADYS5      (HREADY1S5),
     .HRESPS5       (HRESP1S5),

     .HRDATAS6      (HRDATA1S6),
     .HREADYS6      (HREADY1S6),
     .HRESPS6       (HRESP1S6),

     .HRDATAS7      (HRDATA1S7),
     .HREADYS7      (HREADY1S7),
     .HRESPS7       (HRESP1S7),

     .HREADYDefault (HREADY1DefSlv),
     .HRESPDefault  (HRESP1DefSlv),

     .HRDATA        (HRDATA1),
     .HREADY        (HREADY1),
     .HRESP         (HRESP1),
      
      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE    (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINHCLK    (SCANINs2m1),  // Scan Chain Input
     .SCANOUTHCLK   (SCANOUTs2m1)  // Scan Chain Output
    );

  // Tie off HRDATA for unused slave ports
  //  assign HRDATA1S0 = TieOffLo32;  // IntMem
  //  assign HRDATA1S1 = TieOffLo32;  // SMI
  //  assign HRDATA1S2 = TieOffLo32;  // Retry Slave and APB Peripherals
  //  assign HRDATA1S3 = TieOffLo32;  // Interrupt
  assign HRDATA1S4 = TieOffLo32;
  assign HRDATA1S5 = TieOffLo32;
  assign HRDATA1S6 = TieOffLo32;
  assign HRDATA1S7 = TieOffLo32;

  // Tie off HREADY for unused slave ports
  //  assign HREADY1S0 = TieOffHi1;   // IntMem
  //  assign HREADY1S1 = TieOffHi1;   // SMI
  //  assign HREADY1S2 = TieOffHi1;   // Retry Slave and APB Peripherals
  //  assign HREADY1S3 = TieOffHi1;   // Interrupt
  assign HREADY1S4 = TieOffHi1;
  assign HREADY1S5 = TieOffHi1;
  assign HREADY1S6 = TieOffHi1;
  assign HREADY1S7 = TieOffHi1;

  // Tie off HRESP for unused slave ports
  //  assign HRESP1S0 = TieOffLo2;    // IntMem
  //  assign HRESP1S1 = TieOffLo2;    // SMI
  //  assign HRESP1S2 = TieOffLo2;    // Retry Slave and APB Peripherals
  //  assign HRESP1S3 = TieOffLo2;    // Interrupt
  assign HRESP1S4 = TieOffLo2;
  assign HRESP1S5 = TieOffLo2;
  assign HRESP1S6 = TieOffLo2;
  assign HRESP1S7 = TieOffLo2;

// AHB2 System Infrastructure --------------------------------------------------

// AHB2 system Arbiter
  Arbiter3 uArbiterBus2
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),
      
     .HTRANS      (HTRANS2),
     .HBURST      (HBURST2),
     .HREADY      (HREADY2),
     .HRESP       (HRESP2),
      
     .HBUSREQM3   (HBUSREQ2M3),
     .HBUSREQM2   (HBUSREQ2M2),
     .HBUSREQM1   (HBUSREQ2M1),
     .HBUSREQM0   (HBUSREQ2M0),
     .HLOCKM3     (HLOCK2M3),
     .HLOCKM2     (HLOCK2M2),
     .HLOCKM1     (HLOCK2M1),
     .HLOCKM0     (HLOCK2M0),
     .HSPLIT      (HSPLIT2[3:0]),
     .HGRANTM3    (HGRANT2M3),
     .HGRANTM2    (HGRANT2M2),
     .HGRANTM1    (HGRANT2M1),
     .HGRANTM0    (HGRANT2M0),
      
     .HMASTER     (HMASTER2),
     .HMASTERD    (HMASTERD2),
     .HMASTLOCK   (HMASTLOCK2),
      
      // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINarb2), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTarb2) // Scan Chain Output
    );

  // Pause requests Master 0 (2nd highest priority)
  assign HBUSREQ2M0 = Pause;

  // Unconnected Arbiter inputs driven LOW
  assign HBUSREQ2M3 = 1'b0;
  assign HLOCK2M3   = 1'b0;
  assign HLOCK2M0   = 1'b0;
  assign HSPLIT2    = {16{1'b0}};

// AHB2 system Address Decoder
  Decoder uDecoder2
    (
     .HADDR   (HADDR2[31:20]),

     .Remap   (Remap),

     .HSELS0B (HSEL2S0B),
     .HSELS0R (HSEL2S0R),
     .HSELS0  (HSEL2S0),
     .HSELS1  (HSEL2S1),
     .HSELS2  (HSEL2S2),
     .HSELS3  (HSEL2S3),
     .HSELS4  (HSEL2S4),
     .HSELS5  (HSEL2S5),
     .HSELS6  (HSEL2S6),
     .HSELS7  (HSEL2S7),
     .HSELS8  (HSEL2S8),
     .HSELS9  (HSEL2S9),
     .HSELS10 (HSEL2S10),
     .HSELS11 (HSEL2S11),
     .HSELS12 (HSEL2S12),
     .HSELS13 (HSEL2S13),
     .HSELS14 (HSEL2S14),
     .HSELS15 (HSEL2S15)
    );

// Default Slave selected by all unused HSEL lines
  assign HSEL2DefSlv =
    HSEL2S0B |
    HSEL2S0R |
    HSEL2S0  |
    HSEL2S1  |
    HSEL2S2  |
    HSEL2S3  |
    HSEL2S4  |
    HSEL2S5  |
    HSEL2S6  |
    HSEL2S7  |
    HSEL2S8  |
    HSEL2S9  |
    HSEL2S10 |
    HSEL2S11 |
    //  HSEL2S12 |                       // APB Peripherals
    //  HSEL2S13 |                       // Retry Slave
    HSEL2S14 |
    HSEL2S15 
    ;

// Default Slave 2 (selected when no other slaves are accessed on AHB2)
  DefaultSlave uDefaultSlave2
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HTRANS      (HTRANS2),
     .HSEL        (HSEL2DefSlv),
     .HREADY      (HREADY2),

     .HREADYOUT   (HREADY2DefSlv),
     .HRESP       (HRESP2DefSlv),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),    // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINdefslv2), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTdefslv2) // Scan Chain Output
    );

// Central multiplexer - masters to slaves on AHB2
  MuxM2S uMuxMtoS2
    (
     .HMASTER  (HMASTER2),
     .HMASTERD (HMASTERD2),

     .HADDRM1  (HADDR2M1),
     .HTRANSM1 (HTRANS2M1),
     .HWRITEM1 (HWRITE2M1),
     .HSIZEM1  (HSIZE2M1),
     .HBURSTM1 (HBURST2M1),
     .HPROTM1  (HPROT2M1),
     .HWDATAM1 (HWDATA2M1),

     .HADDRM2  (HADDR2M2),
     .HTRANSM2 (HTRANS2M2),
     .HWRITEM2 (HWRITE2M2),
     .HSIZEM2  (HSIZE2M2),
     .HBURSTM2 (HBURST2M2),
     .HPROTM2  (HPROT2M2),
     .HWDATAM2 (HWDATA2M2),

     .HADDRM3  (HADDR2M3),
     .HTRANSM3 (HTRANS2M3),
     .HWRITEM3 (HWRITE2M3),
     .HSIZEM3  (HSIZE2M3),
     .HBURSTM3 (HBURST2M3),
     .HPROTM3  (HPROT2M3),
     .HWDATAM3 (HWDATA2M3),

     .HADDR    (HADDR2),
     .HTRANS   (HTRANS2),
     .HWRITE   (HWRITE2),
     .HSIZE    (HSIZE2),
     .HBURST   (HBURST2),
     .HPROT    (HPROT2),
     .HWDATA   (HWDATA2)
    );

  // Unconnected MUX inputs
  assign HADDR2M3  = {32{1'b0}};
  assign HTRANS2M3 = 2'b00;
  assign HWRITE2M3 = 1'b0;
  assign HSIZE2M3  = 3'b000;
  assign HBURST2M3 = 3'b000;
  assign HPROT2M3  = 4'b0000;
  assign HWDATA2M3 = {32{1'b0}};


// Local multiplexer - slaves to masters on AHB2
//  This 8-input multiplexor is used in place of the 16-input version 
//  because it is faster to synthesise. However, in this application,
//  the input channel names do not always match the names of the signals
//  they are assigned to, though the multiplexor operation is unaffected.
  MuxS2M uMuxStoM2
    (
     .HCLK          (HCLK),
     .HRESETn       (HRESETn),

     .HSELS0        (HSEL2S12),   // Decoder slot 12
     .HSELS1        (HSEL2S13),   // Decoder slot 13
     .HSELS2        (TieOffLo1),
     .HSELS3        (TieOffLo1),
     .HSELS4        (TieOffLo1),
     .HSELS5        (TieOffLo1),
     .HSELS6        (TieOffLo1),
     .HSELS7        (TieOffLo1),
     .HSELDefault   (HSEL2DefSlv),

     .HRDATAS0      (HRDATA2S0),  // APB Peripherals
     .HREADYS0      (HREADY2S0),
     .HRESPS0       (HRESP2S0),

     .HRDATAS1      (HRDATA2S1),  // Retry Slave
     .HREADYS1      (HREADY2S1),
     .HRESPS1       (HRESP2S1),

     .HRDATAS2      (HRDATA2S2),
     .HREADYS2      (HREADY2S2),
     .HRESPS2       (HRESP2S2),

     .HRDATAS3      (HRDATA2S3),
     .HREADYS3      (HREADY2S3),
     .HRESPS3       (HRESP2S3),

     .HRDATAS4      (HRDATA2S4),
     .HREADYS4      (HREADY2S4),
     .HRESPS4       (HRESP2S4),

     .HRDATAS5      (HRDATA2S5),
     .HREADYS5      (HREADY2S5),
     .HRESPS5       (HRESP2S5),

     .HRDATAS6      (HRDATA2S6),
     .HREADYS6      (HREADY2S6),
     .HRESPS6       (HRESP2S6),

     .HRDATAS7      (HRDATA2S7),
     .HREADYS7      (HREADY2S7),
     .HRESPS7       (HRESP2S7),

     .HREADYDefault (HREADY2DefSlv),
     .HRESPDefault  (HRESP2DefSlv),

     .HRDATA        (HRDATA2),
     .HREADY        (HREADY2),
     .HRESP         (HRESP2),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE    (SCANENABLE), // Scan Test Mode Enbl
     .SCANINHCLK    (SCANINs2m2), // Scan Chain Input
     .SCANOUTHCLK   (SCANOUTs2m2) // Scan Chain Output
    );


  // Tie off HRDATA for unused slave ports
  //  assign HRDATA2S0 = TieOffLo32;                 // APB Peripherals
  //  assign HRDATA2S1 = TieOffLo32;                 // Retry Slave
  assign HRDATA2S2 = TieOffLo32;
  assign HRDATA2S3 = TieOffLo32;
  assign HRDATA2S4 = TieOffLo32;
  assign HRDATA2S5 = TieOffLo32;
  assign HRDATA2S6 = TieOffLo32;
  assign HRDATA2S7 = TieOffLo32;

  // Tie off HREADY for unused slave ports
  //  assign HREADY2S0 = TieOffHi1;                  // APB Peripherals
  //  assign HREADY2S1 = TieOffHi1;                  // Retry Slave
  assign HREADY2S2 = TieOffHi1;
  assign HREADY2S3 = TieOffHi1;
  assign HREADY2S4 = TieOffHi1;
  assign HREADY2S5 = TieOffHi1;
  assign HREADY2S6 = TieOffHi1;
  assign HREADY2S7 = TieOffHi1;

  // Tie off HRESP for unused slave ports
  //  assign HRESP2S0 = TieOffLo2;                   // APB Peripherals
  //  assign HRESP2S1 = TieOffLo2;                   // Retry Slave
  assign HRESP2S2 = TieOffLo2;
  assign HRESP2S3 = TieOffLo2;
  assign HRESP2S4 = TieOffLo2;
  assign HRESP2S5 = TieOffLo2;
  assign HRESP2S6 = TieOffLo2;
  assign HRESP2S7 = TieOffLo2;

//------------------------------------------------------------------------------
// APB domain on AHB2
//------------------------------------------------------------------------------

// Watchdog instantiated as APB slave 1
  Watchdog uWatchdog
    (
     .PCLK        (HCLK),
     .PRESETn     (HRESETn),

     .PENABLE     (PENABLE),
     .PSEL        (PSELS1),
     .PADDR       (PADDR[11:2]),
     .PWRITE      (PWRITE),
     .PWDATA      (PWDATA),
     .PRDATA      (PRDATAS1),

     .WDOGCLK     (HCLK),
     .WDOGCLKEN   (TieOffHi1),
     .WDOGRESn    (WDOGRESn),
     .WDOGINT     (WDOGINT),
     .WDOGRES     (WDOGRES),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINPCLK  (SCANINwdog), // Scan Chain Input
     .SCANOUTPCLK (SCANOUTwdog) // Scan Chain Output
    );

// Timers instantiated as APB slave 2
  Timers uTimers
    (
     .PCLK        (HCLK),
     .PRESETn     (HRESETn),

     .PENABLE     (PENABLE),
     .PSEL        (PSELS2),
     .PADDR       (PADDR[11:2]),
     .PWRITE      (PWRITE),
     .PWDATA      (PWDATA),
     .PRDATA      (PRDATAS2),

     .TIMCLK      (HCLK),
     .TIMCLKEN1   (TieOffHi1),
     .TIMCLKEN2   (TieOffHi1),
     .TIMINT1     (TIMINT1),
     .TIMINT2     (TIMINT2),
     .TIMINTC     (TIMINTC),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),   // Scan Test Mode Enbl
     .SCANINPCLK  (SCANINtimers), // Scan Chain Input
     .SCANOUTPCLK (SCANOUTtimers) // Scan Chain Output
    );

// General Purpose Input/Output module as APB slave 4
  Gpio uGpio
    (
     .PCLK        (HCLK),
     .PRESETn     (HRESETn),

     .PSEL        (PSELS4),
     .PENABLE     (PENABLE),
     .PWRITE      (PWRITE),
     .PWDATA      (PWDATA[7:0]),
     .PADDR       (PADDR[11:2]),

     .GPIN        (GPIN),
     .nGPAFEN     (nGPAFEN),
     .GPAFOUT     (GPAFOUT),
     .PRDATA      (PRDATAS4[7:0]),
     .nGPEN       (nGPEN),
     .GPOUT       (GPOUT),
     .GPAFIN      (GPAFIN),
     .GPIOINTR    (GPIOINTR),
     .GPIOMIS     (GPIOMIS),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINPCLK  (SCANINgpio), // Scan Chain Input
     .SCANOUTPCLK (SCANOUTgpio) // Scan Chain Output
    );

// Drive unused output read-data bits LOW.
     assign PRDATAS4[31:8] = {24{1'b0}};


// Remap/Pause controller instantiated as APB slave 8
  RemapPause uRemapPause
    (
     .PCLK        (HCLK),
     .PRESETn     (HRESETn),

     .PENABLE     (PENABLE),
     .PSELRPC     (PSELS8),
     .PADDR       (PADDR[5:2]),
     .PWRITE      (PWRITE),
     .PWDATA      (PWDATA[7:0]),
     .PRDATA      (PRDATAS8[7:0]),

     .nFIQ        (nFIQ),
     .nIRQ        (nIRQ),

     .Pause       (Pause),
     .Remap       (Remap),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINPCLK  (SCANINrpc),  // Scan Chain Input
     .SCANOUTPCLK (SCANOUTrpc)  // Scan Chain Output
    );

// Drive unused output read-data bits LOW.
     assign PRDATAS8[31:8] = {24{1'b0}};


// Example APB Slave instantiated as APB slave 15
  EgAPBSlave uEgAPBSlave
    (
     .PCLK        (HCLK),
     .PRESETn     (HRESETn),

     .PENABLE     (PENABLE),
     .PSEL        (PSELS15),
     .PWRITE      (PWRITE),
     .PADDR       (PADDR[11:2]),
     .PRDATA      (PRDATAS15),
     .PWDATA      (PWDATA),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINPCLK  (SCANINegapb), // Scan Chain Input
     .SCANOUTPCLK (SCANOUTegapb) // Scan Chain Output
    );

// Peripheral read-data multiplexor
  MuxP2B uMuxP2B
    (
     .PSELS0    (PSELS0),    // Select lines from APB Bridge
     .PSELS1    (PSELS1),
     .PSELS2    (PSELS2),
     .PSELS3    (PSELS3),
     .PSELS4    (PSELS4),
     .PSELS5    (PSELS5),
     .PSELS6    (PSELS6),
     .PSELS7    (PSELS7),
     .PSELS8    (PSELS8),
     .PSELS9    (PSELS9),
     .PSELS10   (PSELS10),
     .PSELS11   (PSELS11),
     .PSELS12   (PSELS12),
     .PSELS13   (PSELS13),
     .PSELS14   (PSELS14),
     .PSELS15   (PSELS15),

     .PRDATAS0  (PRDATAS0),  // APB Slave read-data
     .PRDATAS1  (PRDATAS1),
     .PRDATAS2  (PRDATAS2),
     .PRDATAS3  (PRDATAS3),
     .PRDATAS4  (PRDATAS4),
     .PRDATAS5  (PRDATAS5),
     .PRDATAS6  (PRDATAS6),
     .PRDATAS7  (PRDATAS7),
     .PRDATAS8  (PRDATAS8),
     .PRDATAS9  (PRDATAS9),
     .PRDATAS10 (PRDATAS10),
     .PRDATAS11 (PRDATAS11),
     .PRDATAS12 (PRDATAS12),
     .PRDATAS13 (PRDATAS13),
     .PRDATAS14 (PRDATAS14),
     .PRDATAS15 (PRDATAS15),

     .PRDATA    (PRDATA)     // To APB Bridge
    );

// Tie off unused APB slave data paths
  assign PRDATAS0 = TieOffLo32;
//  assign PRDATAS1 = TieOffLo32;            // Watchdog
//  assign PRDATAS2 = TieOffLo32;            // Timers
  assign PRDATAS3 = TieOffLo32;
//  assign PRDATAS4 = TieOffLo32;            // GPIO
  assign PRDATAS5 = TieOffLo32;
  assign PRDATAS6 = TieOffLo32;
  assign PRDATAS7 = TieOffLo32;
//  assign PRDATAS8 = TieOffLo32;            // Remap/Pause
  assign PRDATAS9 = TieOffLo32;
  assign PRDATAS10 = TieOffLo32;
  assign PRDATAS11 = TieOffLo32;
  assign PRDATAS12 = TieOffLo32;
  assign PRDATAS13 = TieOffLo32;
  assign PRDATAS14 = TieOffLo32;
//  assign PRDATAS15 = TieOffLo32;           // Example APB Slave


endmodule

// --================================= End ===================================--
