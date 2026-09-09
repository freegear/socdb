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
//  File Name           : Outport0.v,v
//  File Revision       : 1.7
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose             : Structural sub-block architecture of Example Amba 
//                        SYstem Multi-layer (EASY-ML), connected to BusMatrix
//                        Outport 0. The module contains the following AHB 
//                        devices:
//                       
//                          - Lite2AHB wrapper
//                          - SMI (which also contains TIC as a sub-block)
//                          - Retry Slave
//                          - Local Slave-to-Master multiplexor
//                          - Local Address Decoder
//                          - Local Default Slave
//                       
//                        The TIC within the SMI is an AHB master. The TIC is  
//                        connected directly to the ARM922T Test Interface,
//                        which is contained within Inport0 module.
//  --========================================================================--

`timescale 1ns/1ps

module Outport0 (HCLK, HRESETn, HADDR, HBURST, HMASTLOCK, HPROT, HREADYmtrx,
                 HSELmtrx, HSIZE, HTRANS, HWDATA, HWRITE, HRDATA, HREADYOUT,
                 HRESP, Remap, SMDATAIN, SMDATAOUT, nSMDATAEN, SMADDR, SMCS,
                 nSMBLS, nSMOEN, HADDRtst, HSELtst, HTRANStst, HWRITEtst,
                 HWDATAtst, HREADYtst, HRESPtst, HRDATAtst, TESTREQA, TESTREQB,
                 TESTACK, SCANENABLE, SCANINHCLK, SCANOUTHCLK);

  // Common AHB signals
  input         HCLK;
  input         HRESETn;

  // Matrix AHB connections
  input [31:0]  HADDR;
  input [2:0]   HBURST;
  input         HMASTLOCK;
  input [3:0]   HPROT;
  input         HREADYmtrx;
  input         HSELmtrx;
  input [2:0]   HSIZE;
  input [1:0]   HTRANS;
  input [31:0]  HWDATA;
  input         HWRITE;

  output [31:0] HRDATA;
  output        HREADYOUT;
  output [1:0]  HRESP;

  // Remap control signal
  input         Remap;

  // SMI external connections
  input [31:0]  SMDATAIN;       // Data from Memory to SMC

  output [31:0] SMDATAOUT;      // Data Bus output from SMC to Memory
  output [3:0]  nSMDATAEN;      // Tri-state I/O pad enable for the byte lanes
                                //  of external memory data bus
  output [25:0] SMADDR;         // External Memory address bus
  output [7:0]  SMCS;           // Memory bank Chip Select output pins
  output [3:0]  nSMBLS;         // Memory device Byte lane enables
  output        nSMOEN;         // Memory Output Enable/not Write-Enable

  // TIC connections (AHB)
  output [31:0] HADDRtst;
  output        HSELtst;
  output [1:0]  HTRANStst;
  output        HWRITEtst;
  output [31:0] HWDATAtst;

  input         HREADYtst;
  input [1:0]   HRESPtst;
  input [31:0]  HRDATAtst;

  // TIC test signals
  input         TESTREQA;
  input         TESTREQB;
  output        TESTACK;

  // Scan test dummy signals; not connected until scan insertion
  input         SCANENABLE;  // Scan Test Mode Enbl
  input         SCANINHCLK;  // Scan Chain Input
  output        SCANOUTHCLK; // Scan Chain Output


  // Port wires
  wire          HCLK;
  wire          HRESETn;

  wire [31:0]   HADDR;
  wire [2:0]    HBURST;
  wire          HMASTLOCK;
  wire [3:0]    HPROT;
  wire          HREADYmtrx;
  wire          HSELmtrx;
  wire [2:0]    HSIZE;
  wire [1:0]    HTRANS;
  wire [31:0]   HWDATA;
  wire          HWRITE;

  wire [31:0]   HRDATA;
  wire          HREADYOUT;
  wire [1:0]    HRESP;

  wire          Remap;

  wire [31:0]   SMDATAIN;

  wire [31:0]   SMDATAOUT; 
  wire [3:0]    nSMDATAEN;
  wire [25:0]   SMADDR;
  wire [7:0]    SMCS;
  wire [3:0]    nSMBLS;
  wire [3:0]    nSMBLS_temp;
  wire          nSMOEN;

  wire          HREADYtst;
  wire [1:0]    HRESPtst;
  wire [31:0]   HRDATAtst;
  wire [31:0]   HADDRtst;
  wire          HSELtst;
  wire [1:0]    HTRANStst;
  wire          HWRITEtst;
  wire [31:0]   HWDATAtst;

  wire          TESTREQA;
  wire          TESTREQB;
  wire          TESTACK;

  wire          SCANENABLE;
  wire          SCANINHCLK;
  wire          SCANOUTHCLK;

//----------------------------------------------------------------------------
// Signal declarations: AHB
//----------------------------------------------------------------------------

// Local AHB backbone
  wire [31:0]   iHADDR;
  wire [1:0]    iHTRANS;
  wire          iHWRITE;
  wire [2:0]    iHSIZE;
  wire [2:0]    iHBURST;
  wire [3:0]    iHPROT;
  wire [31:0]   iHWDATA;
  wire          iHLOCK;

// Multiplexed Local slave output signals
  wire          iHREADY;
  wire [1:0]    iHRESP;
  wire [31:0]   iHRDATA;

// Local Slave specific output signals
  wire          HSELS0B;
  wire          HSELS0R;

  wire          HSELS0;
  wire [31:0]   HRDATAS0;
  wire          HREADYS0;
  wire [1:0]    HRESPS0;

  wire          HSELS1;
  wire [31:0]   HRDATAS1;
  wire          HREADYS1;
  wire [1:0]    HRESPS1;

  wire          HSELS2;
  wire [31:0]   HRDATAS2;
  wire          HREADYS2;
  wire [1:0]    HRESPS2;

  wire          HSELS3;
  wire [31:0]   HRDATAS3;
  wire          HREADYS3;
  wire [1:0]    HRESPS3;

  wire          HSELS4;
  wire [31:0]   HRDATAS4;
  wire          HREADYS4;
  wire [1:0]    HRESPS4;

  wire          HSELS5;
  wire [31:0]   HRDATAS5;
  wire          HREADYS5;
  wire [1:0]    HRESPS5;

  wire          HSELS6;
  wire [31:0]   HRDATAS6;
  wire          HREADYS6;
  wire [1:0]    HRESPS6;

  wire          HSELS7;
  wire [31:0]   HRDATAS7;
  wire          HREADYS7;
  wire [1:0]    HRESPS7;

  wire          HSELS8;
  wire          HSELS9;
  wire          HSELS10;
  wire          HSELS11;
  wire          HSELS12;
  wire          HSELS13;
  wire          HSELS14;
  wire          HSELS15;

  wire          HSELDefault;
  wire          HREADYDefault;
  wire [1:0]    HRESPDefault;

// Miscellaneous signals
  wire          HSELSmi;

  wire          iHBUSREQ;
  wire          iHGRANT;

  wire [31:0]   HRDATASmi;
  wire          HREADYSmi;
  wire [1:0]    HRESPSmi;

  wire [31:0]   HRDATARSlv;
  wire          HREADYRSlv;
  wire [1:0]    HRESPRSlv;

  wire [2:0]    HBURSTtst;
  wire          HBUSREQtst;
  reg           HGRANTtst;
  wire          HLOCKtst;
  wire [3:0]    HPROTtst;
  wire [2:0]    HSIZEtst;
  wire [31:0]   iHADDRtst;

// Unused SMI outputs
  wire          TICBUSREQEBI;
  wire          SMBUSREQEBI;
  wire          MCBUSGNT;
  wire          nSMWEN;
  wire          TICREADEBI;
  wire [31:0]   TBUSOUTEBI;


//------------------------------------------------------------------------------
// Signal declarations: Scan chain
//------------------------------------------------------------------------------

  wire          SCANINsmi;
  wire          SCANINnsmi;
  wire          SCANOUTsmi;
  wire          SCANOUTnsmi;
  wire          SCANINs2m;
  wire          SCANOUTs2m;
  wire          SCANINdefslv;
  wire          SCANOUTdefslv;
  wire          SCANINretry;
  wire          SCANOUTretry;
  wire          SCANINwpr;
  wire          SCANOUTwpr;

//------------------------------------------------------------------------------
// Signal declarations: Tie-offs
//------------------------------------------------------------------------------

  wire          TieOffLo1;
  wire          TieOffHi1;
  wire [1:0]    TieOffLo2;
  wire [3:0]    TieOffLo4;
  wire [25:0]   TieOffLo26;
  wire [31:0]   TieOffLo32;


//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

// The TieOff signals must be assigned explicitly within the body of the HDL.
// Using initial values (in the signal declaration, above) will not work in
//  Synopsys. Signals are used rather than constants as constants can not be
//  connected directly to sub-component instantiations
  assign TieOffHi1 = 1'b1;
  assign TieOffLo1 = 1'b0;
  assign TieOffLo2 = {2{1'b0}};
  assign TieOffLo4 = {4{1'b0}};
  assign TieOffLo26 = {26{1'b0}};
  assign TieOffLo32 = {32{1'b0}};

// The Lite to AHB Wrapper (only master in this module)
  Lite2AHB uLite2AHB 
    (
     // Global signals
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     // Signals from AHB
     .HRDATA      (iHRDATA),
     .HREADY      (iHREADY),
     .HRESP       (iHRESP),
     .HGRANT      (iHGRANT),

     // Signals from AHB-Lite
     .MADDR       (HADDR),
     .MTRANS      (HTRANS),
     .MWRITE      (HWRITE),
     .MSIZE       (HSIZE),
     .MBURST      (HBURST),
     .MPROT       (HPROT),
     .MMASTLOCK   (HMASTLOCK),
     .MWDATA      (HWDATA),

     // Signals to AHB
     .HADDR       (iHADDR),
     .HPROT       (iHPROT),
     .HWDATA      (iHWDATA),
     .HBUSREQ     (iHBUSREQ),
     .HLOCK       (iHLOCK),
     .HTRANS      (iHTRANS),
     .HWRITE      (iHWRITE),
     .HSIZE       (iHSIZE),
     .HBURST      (iHBURST),

     // Signals to AHB-Lite
     .MRDATA      (HRDATA),
     .MREADY      (HREADYOUT),
     .MERROR      (HRESP[0]),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE), // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINwpr),  // Scan Chain Input
     .SCANOUTHCLK (SCANOUTwpr)  // Scan Chain Output
    );

  // This signal is not driven by the Lite2AHB Wrapper
  assign HRESP[1] = 1'b0;

  // Always grant the Lite2AHB Wrapper
  assign iHGRANT = 1'b1;

  wire[1:0] bit32;
  assign bit32 = 2'b10;

/*
// Static Memory Interface instantiated as AHB slave 3 (aliased to Slot 0
//  at boot)
  SMI uSMI 
    (
     // Common AHB signals
     .nHCLK        (TieOffLo1),            // Not used
     .HCLK         (HCLK),
     .HRESETn      (HRESETn),

     .HREADYIN     (iHREADY),
     .HREADYINTIC  (HREADYtst),            // SMI

     // SMI slave interface signals (AHB)
     .HADDR        (iHADDR[28:0]),
     .HBURST       (iHBURST),              // Not used
     .HTRANS       (iHTRANS),
     .HWRITE       (iHWRITE),
     .HSIZE        (iHSIZE),
     .HWDATA       (iHWDATA),
     .HSELSMC      (HSELSmi),              // Decoder slots 0 (boot) and 3
     .HSELREG      (TieOffLo1),              // SMI 
     //.HSELREG      (HSELS9),               // used for Programers' model

     // TIC master interface signals (AHB)
     .HRESPTIC     (HRESPtst),
     .HRDATATIC    (HRDATAtst),
     .HGRANTTIC    (HGRANTtst),

     .BIGENDIAN    (TieOffLo1),            // Not used
     .REMAP        (Remap),

     .TICBUSGNTEBI (TieOffLo1),            // Not used
     .SMBUSGNTEBI  (TieOffLo1),            // Not used

     .SCANENABLE   (SCANENABLE),           // Not used
     .SCANINHCLK   (SCANINsmi),            // Not used
     .SCANINnHCLK  (SCANINnsmi),           // Not used

     .SMWAIT       (TieOffLo1),            // used in SMC
     .CANCELSMWAIT (TieOffLo1),            // Not used
     .SMMWCS7      (bit32),           
     .SMDATAIN     (SMDATAIN),             // Data from Memory to SMI

     .TESTREQA     (TESTREQA),             // Test bus request A
     .TESTREQB     (TESTREQB),             // Test bus request B

     .MCBUSREQ     (TieOffLo1),            // Not used
     .MCADDR       (TieOffLo26),           // Not used
     .MCDATAOUT    (TieOffLo32),           // Not used
     .MCDATAEN     (TieOffLo4),            // Not used

     .EXTBUSMUX    (TieOffLo1),            // Not used

     // SMI slave interface signals (AHB)
     .HRDATA       (HRDATASmi),            // Channel 0 of MuxS2M
     .HREADYOUT    (HREADYSmi),
     .HRESP        (HRESPSmi),

     // TIC master interface signals (AHB)
     .HADDRTIC     (iHADDRtst),
     .HTRANSTIC    (HTRANStst),
     .HWRITETIC    (HWRITEtst),
     .HSIZETIC     (HSIZEtst),
     .HBURSTTIC    (HBURSTtst),
     .HPROTTIC     (HPROTtst),
     .HWDATATIC    (HWDATAtst),
     .HBUSREQTIC   (HBUSREQtst),
     .HLOCKTIC     (HLOCKtst),

     .TICBUSREQEBI (TICBUSREQEBI),         // Not used
     .SMBUSREQEBI  (SMBUSREQEBI),          // Not used

     .SCANOUTnHCLK (SCANOUTnsmi),          // Not used
     .SCANOUTHCLK  (SCANOUTsmi),           // Not used

     .SMDATAOUT    (SMDATAOUT),            // Data from SMI to Memory
     .nSMDATAEN    (nSMDATAEN),            // Data tri-state pad enable
     .SMADDR       (SMADDR),               // External address bus
     .SMCS         (SMCS),                 // External chip selects
     .nSMBLS       (nSMBLS),               // External byte lane write enable
     .nSMWEN       (nSMWEN),               // Not used
     .nSMOEN       (nSMOEN),               // External read enable

     .TICREADEBI   (TICREADEBI),           // Not used
     .TBUSOUTEBI   (TBUSOUTEBI),           // Not used
     .TESTACK      (TESTACK),              // Test acknowledge

     .MCBUSGNT     (MCBUSGNT)              // Not used
    );
*/
wire not_clk;
assign not_clk = !HCLK;
  Smc uSmc 
    (
     // Common AHB signals
     //.nHCLK        (TieOffLo1),            // Not used
     .nHCLK        (not_clk),            // Not used
     .HCLK         (HCLK),
     .HRESETn      (HRESETn),

     .HREADYIN     (iHREADY),

     // SMI slave interface signals (AHB)
     .HADDR        (iHADDR[28:0]),
     .HBURST       (iHBURST),              // Not used
     .HTRANS       (iHTRANS),
     .HWRITE       (iHWRITE),
     .HSIZE        (iHSIZE),
     .HWDATA       (iHWDATA),
     .HSELSMC      (HSELSmi),              // Decoder slots 0 (boot) and 3
     .HSELREG      (HSELS9),               // used for Programers' model

     // TIC master interface signals (AHB)
     .HRESPTIC     (HRESPtst),
     .HRDATATIC    (HRDATAtst),
     .HGRANTTIC    (HGRANTtst),

     .BIGENDIAN    (TieOffLo1),            // Not used
     .REMAP        (Remap),

     .TICBUSGNTEBI (TieOffLo1),            // Not used
     .SMBUSGNTEBI  (TieOffLo1),            // Not used

     .SCANENABLE   (SCANENABLE),           // Not used
     //.SCANINHCLK   (SCANINsmi),            // Not used
     .SCANINHCLK   (TieOffLo1),            // Not used
     //.SCANINnHCLK  (SCANINnsmi),           // Not used
     .SCANINnHCLK  (TieOffLo1),           // Not used

     .SMWAIT       (TieOffHi1),            // used in SMC
     .CANCELSMWAIT (TieOffLo1),            // Not used
     .SMMWCS7      (bit32),           
     .SMDATAIN     (SMDATAIN),             // Data from Memory to SMI

     .TESTREQA     (TESTREQA),             // Test bus request A
     .TESTREQB     (TESTREQB),             // Test bus request B

     .MCBUSREQ     (TieOffLo1),            // Not used
     .MCADDR       (TieOffLo26),           // Not used
     .MCDATAOUT    (TieOffLo32),           // Not used
     .MCDATAEN     (TieOffLo4),            // Not used

     .EXTBUSMUX    (TieOffLo1),            // Not used

     // SMI slave interface signals (AHB)
     .HRDATA       (HRDATASmi),            // Channel 0 of MuxS2M
     .HREADYOUT    (HREADYSmi),
     .HRESP        (HRESPSmi),

     // TIC master interface signals (AHB)
     .HADDRTIC     (iHADDRtst),
     .HTRANSTIC    (HTRANStst),
     .HWRITETIC    (HWRITEtst),
     .HSIZETIC     (HSIZEtst),
     .HBURSTTIC    (HBURSTtst),
     .HPROTTIC     (HPROTtst),
     .HWDATATIC    (HWDATAtst),
     .HBUSREQTIC   (HBUSREQtst),
     .HLOCKTIC     (HLOCKtst),

     .TICBUSREQEBI (TICBUSREQEBI),         // Not used
     .SMBUSREQEBI  (SMBUSREQEBI),          // Not used

     .SCANOUTnHCLK (SCANOUTnsmi),          // Not used
     .SCANOUTHCLK  (SCANOUTsmi),           // Not used

     .SMDATAOUT    (SMDATAOUT),            // Data from SMI to Memory
     .nSMDATAEN    (nSMDATAEN),            // Data tri-state pad enable
     .SMADDR       (SMADDR),               // External address bus
     .SMCS         (SMCS),                 // External chip selects
     .nSMBLS       (nSMBLS),               // External byte lane write enable
     //.nSMBLS       (nSMBLS_Twin_ARM),               // External byte lane write enable
     .nSMWEN       (nSMWEN),               // Not used
     .nSMOEN       (nSMOEN),               // External read enable

     .TICREADEBI   (TICREADEBI),           // Not used
     .TBUSOUTEBI   (TBUSOUTEBI),           // Not used
     .TESTACK      (TESTACK),              // Test acknowledge

     .MCBUSGNT     (MCBUSGNT)              // Not used
    );
//assign nSMBLS = Remap ? nSMBLS_temp : 4'hF;
// Retry Slave (example code template) instantiated as AHB slave 13
  RetrySlave uRetrySlave 
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HADDR       (iHADDR),
     .HTRANS      (iHTRANS),
     .HWRITE      (iHWRITE),
     .HSIZE       (iHSIZE),
     .HWDATA      (iHWDATA),
     .HSELRetry   (HSELS13),          // Decoder slot 13
     .HREADY      (iHREADY),

     .HRDATA      (HRDATARSlv),       // Channel 1 of MuxS2M
     .HREADYOUT   (HREADYRSlv),
     .HRESP       (HRESPRSlv),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),  // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINretry), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTretry) // Scan Chain Output
    );

// Local Address Decoder
  Decoder uDecoder 
    (
     .HADDR   (HADDR[31:20]),

     .Remap   (Remap),

     .HSELS0B (HSELS0B),
     .HSELS0R (HSELS0R),
     .HSELS0  (HSELS0),
     .HSELS1  (HSELS1),
     .HSELS2  (HSELS2),
     .HSELS3  (HSELS3),
     .HSELS4  (HSELS4),
     .HSELS5  (HSELS5),
     .HSELS6  (HSELS6),
     .HSELS7  (HSELS7),
     .HSELS8  (HSELS8),
     .HSELS9  (HSELS9),
     .HSELS10 (HSELS10),
     .HSELS11 (HSELS11),
     .HSELS12 (HSELS12),
     .HSELS13 (HSELS13),
     .HSELS14 (HSELS14),
     .HSELS15 (HSELS15)
    );

  // SMI occupies Slot 3 or Slot 0 (at boot) 
  //assign HSELSmi = (HSELS3 | HSELS0B | HSELS9);
  assign HSELSmi = (HSELS3 | HSELS0B ); //original

  // Default Slave is selected by all unused HSEL lines
  assign HSELDefault = 
    // HSELS0B |
    HSELS0R |                           // IntMem alias
    HSELS0 |
    HSELS1 |
    HSELS2 |
    // HSELS3 |                         // SMI
    HSELS4 |
    HSELS5 |
    HSELS6 |
    HSELS7 |                            // IntMem
    HSELS8 |
    //HSELS9 |                          // SMC
    HSELS10 |
    HSELS11 |
    HSELS12 |                           // APB Peripherals
    // HSELS13 |                        // Retry Slave
    HSELS14 |                           
    HSELS15 |                           // Interrupt Controller
    (~HSELmtrx)
    ;

// Default Slave (selected when no other slaves are accessed)
  DefaultSlave uDefaultSlave 
    (
     .HCLK        (HCLK),
     .HRESETn     (HRESETn),

     .HTRANS      (iHTRANS),
     .HSEL        (HSELDefault),
     .HREADY      (iHREADY),

     .HREADYOUT   (HREADYDefault),
     .HRESP       (HRESPDefault),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE  (SCANENABLE),   // Scan Test Mode Enbl
     .SCANINHCLK  (SCANINdefslv), // Scan Chain Input
     .SCANOUTHCLK (SCANOUTdefslv) // Scan Chain Output
    );

// Local multiplexer - slaves to masters
//  This 8-input multiplexor is used in place of the 16-input version 
//  because it is faster to synthesise. However, in this application,
//  the input channel names do not always match the names of the signals
//  they are assigned to, though the multiplexor operation is unaffected.
  MuxS2M uMuxS2M
    (
     .HCLK          (HCLK),
     .HRESETn       (HRESETn),
     
     .HSELS0        (HSELSmi | HSELS9),          // Decoder slots 0 (boot) and 3
     .HSELS1        (HSELS13),          // Decoder slot 13
     .HSELS2        (TieOffLo1),
//     .HSELS2        (HSELS9),           // Decoder slot 9
     .HSELS3        (TieOffLo1),
     .HSELS4        (TieOffLo1),
     .HSELS5        (TieOffLo1),
     .HSELS6        (TieOffLo1),
     .HSELS7        (TieOffLo1),
     .HSELDefault   (HSELDefault),

     .HRDATAS0      (HRDATAS0),         // SMI
     .HREADYS0      (HREADYS0),
     .HRESPS0       (HRESPS0),

     .HRDATAS1      (HRDATAS1),         // Retry Slave
     .HREADYS1      (HREADYS1),
     .HRESPS1       (HRESPS1),

     .HRDATAS2      (HRDATAS2),                     
     .HREADYS2      (HREADYS2),
     .HRESPS2       (HRESPS2),

     .HRDATAS3      (HRDATAS3),
     .HREADYS3      (HREADYS3),
     .HRESPS3       (HRESPS3),

     .HRDATAS4      (HRDATAS4),
     .HREADYS4      (HREADYS4),
     .HRESPS4       (HRESPS4),

     .HRDATAS5      (HRDATAS5),
     .HREADYS5      (HREADYS5),
     .HRESPS5       (HRESPS5),

     .HRDATAS6      (HRDATAS6),
     .HREADYS6      (HREADYS6),
     .HRESPS6       (HRESPS6),

     .HRDATAS7      (HRDATAS7),
     .HREADYS7      (HREADYS7),
     .HRESPS7       (HRESPS7),

     .HREADYDefault (HREADYDefault),
     .HRESPDefault  (HRESPDefault),

     .HRDATA        (iHRDATA),          // Connected to the Lite2AHB Wrapper
     .HREADY        (iHREADY),
     .HRESP         (iHRESP),

     // Scan test dummy signals; not connected until scan insertion 
     .SCANENABLE    (SCANENABLE), // Scan Test Mode Enbl
     .SCANINHCLK    (SCANINs2m),  // Scan Chain Input
     .SCANOUTHCLK   (SCANOUTs2m)  // Scan Chain Output
    );

  assign HRDATAS0 = HRDATASmi;         // SMI
  assign HREADYS0 = HREADYSmi;
  assign HRESPS0  = HRESPSmi;

  assign HRDATAS1 = HRDATARSlv;        // Retry Slave
  assign HREADYS1 = HREADYRSlv;
  assign HRESPS1  = HRESPRSlv;

// Tie-off the unused channels of MuxS2M

  // Tie off HRDATA for unused slave ports
  // assign HRDATAS0 = TieOffLo32;        // SMI
  // assign HRDATAS1 = TieOffLo32;        // Retry Slave
  assign HRDATAS2 = TieOffLo32;         
  assign HRDATAS3 = TieOffLo32;
  assign HRDATAS4 = TieOffLo32;
  assign HRDATAS5 = TieOffLo32;
  assign HRDATAS6 = TieOffLo32;
  assign HRDATAS7 = TieOffLo32;

  // Tie off HREADY for unused slave ports
  // assign HREADYS0 = TieOffHi1;         // SMI
  // assign HREADYS1 = TieOffHi1;         // Retry Slave
  assign HREADYS2 = TieOffHi1;          
  assign HREADYS3 = TieOffHi1;
  assign HREADYS4 = TieOffHi1;
  assign HREADYS5 = TieOffHi1;
  assign HREADYS6 = TieOffHi1;
  assign HREADYS7 = TieOffHi1;

  // Tie off HRESP for unused slave ports
  // assign HRESPS0 = TieOffLo2;          // SMI
  // assign HRESPS1 = TieOffLo2;          // Retry Slave
  assign HRESPS2 = TieOffLo2;
  assign HRESPS3 = TieOffLo2;
  assign HRESPS4 = TieOffLo2;
  assign HRESPS5 = TieOffLo2;
  assign HRESPS6 = TieOffLo2;
  assign HRESPS7 = TieOffLo2;

// TIC control logic

  // Since TIC is the only master on its AHB layer, it can be granted as soon
  //  as a request is asserted. Note that HGRANTtst is not constantly asserted
  //  for power reasons
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_HGRANTtstSeq
      if (!HRESETn)
        HGRANTtst <= 1'b0;
      else
        HGRANTtst <= HBUSREQtst;
    end

  // Decode TIC address to create slave select signal to ARM core. Note that
  //  TIC tests from ARM will assume a base address of either 0xC0000000 or
  //  0x50000000 - the following is therefore a generic solution
  assign HSELtst = ((iHADDRtst[31:28] != 4'b0000) ? 1'b1 : 1'b0);

  // Connect internal signal to port
  assign HADDRtst = iHADDRtst;


endmodule

// --================================= End ===================================--

