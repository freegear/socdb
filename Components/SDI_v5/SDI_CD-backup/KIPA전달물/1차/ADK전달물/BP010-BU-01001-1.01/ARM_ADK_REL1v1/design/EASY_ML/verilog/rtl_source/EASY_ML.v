//--==========================================================================--
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
//  File Name          : EASY_ML.v,v
//  File Revision      : 1.18
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Structural architecture of Example Amba SYstem
//                        Multi-layer (EASY-ML) consisting of the ARM922T, 
//                        File Reader Bus Master and EgMaster. 
//--==========================================================================--

`timescale 1ns/1ps

//------------------------------------------------------------------------------
// EASY_ML Address Map
//------------------------------------------------------------------------------
// Full Decoding of the Address Map is performed continuously as a function of
//  HADDR. All unused slots are connected to a Default Slave.
//
// AHB address map is:
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
// 0xC0000000 - 0xCFFFFFFF APB Peripherals            (HSELS12)
// 0xD0000000 - 0xDFFFFFFF Retry Slave                (HSELS13)
// 0xE0000000 - 0xEFFFFFFF Default Slave              (HSELS14)
// 0xF0000000 - 0xFFFFFFFF Interrupt Controller       (HSELS15)
//
// APB address map is:
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


module EASY_ML (XCLKIN, nReset, SMDATAIN, SMDATAOUT, nSMDATAEN, SMADDR, SMCS,
                nSMBLS, nSMOEN, TESTREQA, TESTREQB, TESTACK, nTRST, TCK, TDI,
                TMS, TDO, nTDOEN, COMMRX, COMMTX, XFCLK, GPIN, GPOUT, nGPEN,
                nGPAFEN, GPAFOUT, GPAFIN, SCANENABLE, SCANINHCLK, SCANOUTHCLK,
                SCANINPCLK, SCANOUTPCLK);


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

  // ARM922T comms channel debug lines
  output        COMMRX;
  output        COMMTX;

  // ARM922T Fast Cache clock
  input         XFCLK;

  // GPIO lines
  input  [7:0]  GPIN;        // Inputs
  output [7:0]  GPOUT;       // Outputs
  output [7:0]  nGPEN;       // Output ctrl enables
  input  [7:0]  nGPAFEN;     // H/w ctrl enables
  input  [7:0]  GPAFOUT;     // H/w ctrl inputs
  output [7:0]  GPAFIN;      // H/w ctrl outputs

  // Scan test dummy signals; not connected until scan insertion 
  input         SCANENABLE;  // Scan Test Mode Enbl
  input         SCANINHCLK;  // Scan Chain Input (HCLK)
  output        SCANOUTHCLK; // Scan Chain Output (HCLK)
  input         SCANINPCLK;  // Scan Chain Input (PCLK)
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

  wire          XFCLK;

  wire [7:0]    GPIN;
  wire [7:0]    GPOUT;
  wire [7:0]    nGPEN;
  wire [7:0]    nGPAFEN;
  wire [7:0]    GPAFOUT;
  wire [7:0]    GPAFIN;

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
// Signal declarations: BusMatrix modules
//------------------------------------------------------------------------------

// Inport 0 AHB signals
  wire [31:0]   HADDRS0;
  wire [2:0]    HBURSTS0;
  wire          HMASTLOCKS0;
  wire [3:0]    HPROTS0;
  wire [31:0]   HRDATAS0;
  wire          HREADYS0;
  wire [1:0]    HRESPS0;
  wire [2:0]    HSIZES0;
  wire [1:0]    HTRANSS0;
  wire [31:0]   HWDATAS0;
  wire          HWRITES0;
  wire          HSELS0;
  wire          HREADYmtrxS0;

// Inport 1 AHB signals
  wire [31:0]   HADDRS1;
  wire [2:0]    HBURSTS1;
  wire          HMASTLOCKS1;
  wire [3:0]    HPROTS1;
  wire [31:0]   HRDATAS1;
  wire          HREADYS1;
  wire [1:0]    HRESPS1;
  wire [2:0]    HSIZES1;
  wire [1:0]    HTRANSS1;
  wire [31:0]   HWDATAS1;
  wire          HWRITES1;
  wire          HSELS1;
  wire          HREADYmtrxS1;

// Outport 0 AHB signals 
  wire [31:0]   HADDRM0;
  wire [2:0]    HBURSTM0;
  wire          HMASTLOCKM0;
  wire [3:0]    HPROTM0;
  wire [31:0]   HRDATAM0;
  wire          HREADYM0;
  wire [1:0]    HRESPM0;
  wire [2:0]    HSIZEM0;
  wire [1:0]    HTRANSM0;
  wire [31:0]   HWDATAM0;
  wire          HWRITEM0;
  wire          HSELM0;
  wire          HREADYOUTM0;

// Outport 1 AHB signals
  wire [31:0]   HADDRM1;
  wire [2:0]    HBURSTM1;
  wire          HMASTLOCKM1;
  wire [3:0]    HPROTM1;
  wire [31:0]   HRDATAM1;
  wire          HREADYM1;
  wire [1:0]    HRESPM1;
  wire [2:0]    HSIZEM1;
  wire [1:0]    HTRANSM1;
  wire [31:0]   HWDATAM1;
  wire          HWRITEM1;
  wire          HSELM1;
  wire          HREADYOUTM1;

// Outport 2 AHB signals
  wire [31:0]   HADDRM2;
  wire [2:0]    HBURSTM2;
  wire          HMASTLOCKM2;
  wire [3:0]    HPROTM2;
  wire [31:0]   HRDATAM2;
  wire          HREADYM2;
  wire [1:0]    HRESPM2;
  wire [2:0]    HSIZEM2;
  wire [1:0]    HTRANSM2;
  wire [31:0]   HWDATAM2;
  wire          HWRITEM2;
  wire          HSELM2;
  wire          HREADYOUTM2;

//------------------------------------------------------------------------------
// Signal declarations: Scan chain
//------------------------------------------------------------------------------

  wire          SCANINHCLKbmtx;
  wire          SCANOUTHCLKbmtx;
  wire          SCANINHCLKinp0;
  wire          SCANOUTHCLKinp0;
  wire          SCANINHCLKinp1;
  wire          SCANOUTHCLKinp1;
  wire          SCANINHCLKoutp0;
  wire          SCANOUTHCLKoutp0;
  wire          SCANINHCLKoutp1;
  wire          SCANOUTHCLKoutp1;
  wire          SCANINHCLKoutp2;
  wire          SCANOUTHCLKoutp2;
  wire          SCANINPCLKoutp2;
  wire          SCANOUTPCLKoutp2;

//------------------------------------------------------------------------------
// Signal declarations: System specific
//------------------------------------------------------------------------------

// Watchdog
  wire          WDOGRES;
  wire          WDOGRESn;

// TIC signals
  wire          HREADYtst;
  wire [1:0]    HRESPtst;
  wire [31:0]   HRDATAtst;
  wire [31:0]   HADDRtst;
  wire          HSELtst;
  wire [1:0]    HTRANStst;
  wire          HWRITEtst;
  wire [31:0]   HWDATAtst;

// Interrupts
  wire          WDOGINT;
  wire          TIMINTC;
  wire          TIMINT2;
  wire          TIMINT1;
  wire          GPIOINTR;
  wire [7:0]    GPIOMIS;
  wire          nFIQ;
  wire          nIRQ;

// Miscellaneous signals
  wire          Remap;
  wire          Pause;


//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Common system features
//------------------------------------------------------------------------------

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
// AHB Multi-layer System
//------------------------------------------------------------------------------

// Multi-layer Bus Matrix module
  BusMatrix uBusMatrix 
    (
     // Common AHB signals
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),
     
     // Input Port 0
     .HSELS0      (HSELS0),
     .HADDRS0     (HADDRS0),
     .HTRANSS0    (HTRANSS0),
     .HWRITES0    (HWRITES0),
     .HSIZES0     (HSIZES0),
     .HBURSTS0    (HBURSTS0),
     .HPROTS0     (HPROTS0),
     .HWDATAS0    (HWDATAS0),
     .HMASTLOCKS0 (HMASTLOCKS0),
     .HREADYS0    (HREADYS0),

     .HRDATAS0    (HRDATAS0),
     .HREADYOUTS0 (HREADYmtrxS0),
     .HRESPS0     (HRESPS0),

     // Input Port 1
     .HSELS1      (HSELS1),
     .HADDRS1     (HADDRS1),
     .HTRANSS1    (HTRANSS1),
     .HWRITES1    (HWRITES1),
     .HSIZES1     (HSIZES1),
     .HBURSTS1    (HBURSTS1),
     .HPROTS1     (HPROTS1),
     .HWDATAS1    (HWDATAS1),
     .HMASTLOCKS1 (HMASTLOCKS1),
     .HREADYS1    (HREADYS1),

     .HRDATAS1    (HRDATAS1),
     .HREADYOUTS1 (HREADYmtrxS1),
     .HRESPS1     (HRESPS1),

     // Output Port 0
     .HSELM0      (HSELM0),
     .HADDRM0     (HADDRM0),
     .HTRANSM0    (HTRANSM0),
     .HWRITEM0    (HWRITEM0),
     .HSIZEM0     (HSIZEM0),
     .HBURSTM0    (HBURSTM0),
     .HPROTM0     (HPROTM0),
     .HWDATAM0    (HWDATAM0),
     .HMASTLOCKM0 (HMASTLOCKM0),
     .HREADYM0    (HREADYM0),

     .HRDATAM0    (HRDATAM0),
     .HREADYOUTM0 (HREADYOUTM0),
     .HRESPM0     (HRESPM0),

     // Output Port 1
     .HSELM1      (HSELM1),
     .HADDRM1     (HADDRM1),
     .HTRANSM1    (HTRANSM1),
     .HWRITEM1    (HWRITEM1),
     .HSIZEM1     (HSIZEM1),
     .HBURSTM1    (HBURSTM1),
     .HPROTM1     (HPROTM1),
     .HWDATAM1    (HWDATAM1),
     .HMASTLOCKM1 (HMASTLOCKM1),
     .HREADYM1    (HREADYM1),

     .HRDATAM1    (HRDATAM1),
     .HREADYOUTM1 (HREADYOUTM1),
     .HRESPM1     (HRESPM1),

     // Output Port 2
     .HSELM2      (HSELM2),
     .HADDRM2     (HADDRM2),
     .HTRANSM2    (HTRANSM2),
     .HWRITEM2    (HWRITEM2),
     .HSIZEM2     (HSIZEM2),
     .HBURSTM2    (HBURSTM2),
     .HPROTM2     (HPROTM2),
     .HWDATAM2    (HWDATAM2),
     .HMASTLOCKM2 (HMASTLOCKM2),
     .HREADYM2    (HREADYM2),

     .HRDATAM2    (HRDATAM2),
     .HREADYOUTM2 (HREADYOUTM2),
     .HRESPM2     (HRESPM2),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),     // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINHCLKbmtx), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTHCLKbmtx) // Scan Chain Output
    );
  
// Inport 0 (ARM922T and Internal Memory)
  Inport0
  // synopsys translate_off
    // Parameters:
    //   Memory size in address bits: IntMemAddrWidth = 10,
    //   Memory initialisation file name: IntMemInitFile = "intram.dat"
    #(10, "intram.dat")
  // synopsys translate_on
  uInport0 
    (
     // Common AHB signals
     .HCLK         (HCLK),
     .HRESETn      (HRESETn),

     // Matrix AHB connections
     .HADDR        (HADDRS0),
     .HBURST       (HBURSTS0),
     .HMASTLOCK    (HMASTLOCKS0),
     .HPROT        (HPROTS0),
     .HSIZE        (HSIZES0),
     .HTRANS       (HTRANSS0),
     .HWDATA       (HWDATAS0),
     .HWRITE       (HWRITES0),
     .HSELmtrx     (HSELS0),
     .HREADYOUT    (HREADYS0),

     .HRDATAmtrx   (HRDATAS0),
     .HREADYmtrx   (HREADYmtrxS0),
     .HRESPmtrx    (HRESPS0),

     // ARM922T Test Slave connections
     .HADDRtst     (HADDRtst[11:2]),
     .HSELtst      (HSELtst),
     .HTRANStst    (HTRANStst),
     .HWRITEtst    (HWRITEtst),
     .HWDATAtst    (HWDATAtst),

     .HRDATAtst    (HRDATAtst),
     .HREADYOUTtst (HREADYtst),
     .HRESPtst     (HRESPtst),

     // ARM922T interrupts
     .nFIQ         (nFIQ),
     .nIRQ         (nIRQ),

     // ARM922T comms channel debug lines
     .COMMRX       (COMMRX),
     .COMMTX       (COMMTX),

     // ARM922T Fast Cache clock
     .FCLK         (XFCLK),

     // JTAG connections      
     .nTRST        (nTRST),
     .TCK          (TCK),
     .TDI          (TDI),
     .TMS          (TMS),
     .nTDOEN       (nTDOEN),
     .TDO          (TDO),

     // Remap/Pause control signals
     .Remap        (Remap),
     .Pause        (Pause),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE   (SCANENABLE),     // Scan Test Mode Enbl
     .SCANINHCLK   (SCANINHCLKinp0), // Scan Chain Input
     .SCANOUTHCLK  (SCANOUTHCLKinp0) // Scan Chain Output
    );

// Inport 1 (EgMaster and File Reader Bus Master)
  Inport1 
  // synopsys translate_off
    // Parameters:
    //   Default file name: StimFileFRBM = "filestim.frd"
    //   Block enable: EnableEBM = 1, 
    //   Base address read: ReadAddrEBM = 0x30000000 (ext memory via SMI),
    //   Base address write: WriteAddrEBM = 0x34000000 (ext memory via SMI),
    //   Delay between transactions: InitCountEBM = 10
    #("filestim.frd", 1, 'h030, 'h034, 10'h3E8)
  // synopsys translate_on
  uInport1 
    (
     // Common AHB signals
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     // Reset for FRBM from Watchdog
     .nRESETfrbm  (WDOGRESn),

     // Matrix AHB connections
     .HADDR       (HADDRS1),
     .HBURST      (HBURSTS1),
     .HMASTLOCK   (HMASTLOCKS1),
     .HPROT       (HPROTS1),
     .HSIZE       (HSIZES1),
     .HTRANS      (HTRANSS1),
     .HWDATA      (HWDATAS1),
     .HWRITE      (HWRITES1),
     .HSELmtrx    (HSELS1),
     .HREADYOUT   (HREADYS1),

     .HRDATAmtrx  (HRDATAS1),
     .HREADYmtrx  (HREADYmtrxS1),
     .HRESPmtrx   (HRESPS1),

     // Pause control signal
     .Pause       (Pause),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),     // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINHCLKinp1), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTHCLKinp1) // Scan Chain Output
    );

// Outport 0 (TIC, SMI, Retry slave, Default Slave and Lite2AHB wrapper)
  Outport0 uOutport0 
    (
     // Common AHB signals
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     // Matrix AHB connections
     .HADDR       (HADDRM0),
     .HBURST      (HBURSTM0),
     .HMASTLOCK   (HMASTLOCKM0),
     .HPROT       (HPROTM0),
     .HREADYmtrx  (HREADYM0),
     .HSELmtrx    (HSELM0),
     .HSIZE       (HSIZEM0),
     .HTRANS      (HTRANSM0),
     .HWDATA      (HWDATAM0),
     .HWRITE      (HWRITEM0),

     .HRDATA      (HRDATAM0),
     .HREADYOUT   (HREADYOUTM0),
     .HRESP       (HRESPM0),

     // Remap control signal
     .Remap       (Remap),

     // SMI external connections
     .SMDATAIN    (SMDATAIN),
     .SMDATAOUT   (SMDATAOUT),
     .SMADDR      (SMADDR),
     .nSMDATAEN   (nSMDATAEN),
     .SMCS        (SMCS),
     .nSMBLS      (nSMBLS),
     .nSMOEN      (nSMOEN),

     // TIC connections (AHB)
     .HADDRtst    (HADDRtst),
     .HSELtst     (HSELtst),
     .HTRANStst   (HTRANStst),
     .HWRITEtst   (HWRITEtst),
     .HWDATAtst   (HWDATAtst),

     .HREADYtst   (HREADYtst),
     .HRESPtst    (HRESPtst),
     .HRDATAtst   (HRDATAtst),

     // TIC test signals
     .TESTREQA    (TESTREQA),
     .TESTREQB    (TESTREQB),
     .TESTACK     (TESTACK),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),      // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINHCLKoutp0), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTHCLKoutp0) // Scan Chain Output
    );

// Outport 1 (AHB IRQ Controller)
  Outport1 uOutport1 
    (
     // Common AHB signals
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     // Matrix AHB connections
     .HADDR       (HADDRM1),
     .HBURST      (HBURSTM1),
     .HPROT       (HPROTM1),
     .HREADYmtrx  (HREADYM1),
     .HSELmtrx    (HSELM1),
     .HSIZE       (HSIZEM1),
     .HTRANS      (HTRANSM1),
     .HWDATA      (HWDATAM1),
     .HWRITE      (HWRITEM1),

     .HRDATA      (HRDATAM1),
     .HREADYOUT   (HREADYOUTM1),
     .HRESP       (HRESPM1),

     // Peripheral interrupt sources
     .WDOGINT     (WDOGINT),
     .TIMINTC     (TIMINTC),
     .TIMINT2     (TIMINT2),
     .TIMINT1     (TIMINT1),
     .GPIOMIS     (GPIOMIS),
     .GPIOINTR    (GPIOINTR),

     // Processor interrupts
     .nICFIQ      (nFIQ),
     .nICIRQ      (nIRQ),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),      // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINHCLKoutp1), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTHCLKoutp1) // Scan Chain Output
    );

// Outport 2 (AHB-APB bridge, Timers, Remap/Pause, Watchdog, Example APB Slave
//  and GPIO)
  Outport2 uOutport2 
    (
     // Common AHB signals
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     // Matrix AHB connections
     .HADDR       (HADDRM2),
     .HBURST      (HBURSTM2),
     .HPROT       (HPROTM2),
     .HREADYmtrx  (HREADYM2),
     .HSELmtrx    (HSELM2),
     .HSIZE       (HSIZEM2),
     .HTRANS      (HTRANSM2),
     .HWDATA      (HWDATAM2),
     .HWRITE      (HWRITEM2),

     .HRDATA      (HRDATAM2),
     .HREADYOUT   (HREADYOUTM2),
     .HRESP       (HRESPM2),

     // Timer signals 
     .TIMINT1     (TIMINT1),
     .TIMINT2     (TIMINT2),
     .TIMINTC     (TIMINTC),

     // Watchdog signals
     .WDOGRESn    (WDOGRESn),
     .WDOGRES     (WDOGRES),
     .WDOGINT     (WDOGINT),

     // Processor interrupts
     .nFIQ        (nFIQ),
     .nIRQ        (nIRQ),

     // Remap/Pause control signals
     .Pause       (Pause),
     .Remap       (Remap),

     // GPIO signals
     .GPIN        (GPIN),
     .nGPAFEN     (nGPAFEN),
     .GPAFOUT     (GPAFOUT),
     .GPOUT       (GPOUT),
     .nGPEN       (nGPEN),
     .GPAFIN      (GPAFIN),
     .GPIOINTR    (GPIOINTR),
     .GPIOMIS     (GPIOMIS),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),       // Scan Test Mode Enable
     .SCANINHCLK  (SCANINHCLKoutp2),  // Scan Chain Input (HCLK)
     .SCANOUTHCLK (SCANOUTHCLKoutp2), // Scan Chain Output (HCLK)
     .SCANINPCLK  (SCANINPCLKoutp2),  // Scan Chain Input (PCLK)
     .SCANOUTPCLK (SCANOUTPCLKoutp2)  // Scan Chain Output (PCLK)
    );


endmodule

// --================================= End ===================================--

