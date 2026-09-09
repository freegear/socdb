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
//  File Name          : SMI.v,v
//  File Revision      : 1.5
//
//  Release Information : ADK_REL1v1
//
//  ----------------------------------------------------------------------------
//  Purpose            : This is the top level structural block of the Static
//                        Static Memory Interface.
//                        The port map is identical to the PrimeCell SMC PL092
//                        to allow easy use of this memory controller.
//  --========================================================================--

`timescale 1ns/1ps

module SMI (nHCLK, HCLK, HRESETn, HREADYIN, HREADYINTIC, HADDR, HBURST,
            HTRANS, HWRITE, HSIZE, HWDATA, HSELSMC, HSELREG, HRESPTIC,
            HRDATATIC, HGRANTTIC, BIGENDIAN, REMAP, TICBUSGNTEBI, SMBUSGNTEBI,
            SCANENABLE, SCANINHCLK, SCANINnHCLK, SMWAIT, CANCELSMWAIT, SMMWCS7,
            SMDATAIN, TESTREQA, TESTREQB, MCBUSREQ, MCADDR, MCDATAOUT, MCDATAEN,
            EXTBUSMUX, HRDATA, HREADYOUT, HRESP, HADDRTIC, HTRANSTIC, HWRITETIC,
            HSIZETIC, HBURSTTIC, HPROTTIC, HWDATATIC, HBUSREQTIC, HLOCKTIC,
            TICBUSREQEBI, SMBUSREQEBI, SCANOUTnHCLK, SCANOUTHCLK, SMDATAOUT,
            nSMDATAEN, SMADDR, SMCS, nSMBLS, nSMWEN, nSMOEN, TICREADEBI,
            TBUSOUTEBI, TESTACK, MCBUSGNT);
  
  input        nHCLK;        // Not used in SMI
  input        HCLK;
  input        HRESETn;
  input        HREADYIN;
  input        HREADYINTIC;  // !!NOT PRESENT IN PL092!! 
  input [28:0] HADDR;
  input [2:0]  HBURST;       // Not used in SMI
  input [1:0]  HTRANS;
  input        HWRITE;
  input [2:0]  HSIZE;
  input [31:0] HWDATA;
  input        HSELSMC;
  input        HSELREG;      // Not used in SMI
  input [1:0]  HRESPTIC;
  input [31:0] HRDATATIC;
  input        HGRANTTIC;
  input        BIGENDIAN;    // Not used in SMI
  input        REMAP;
  input        TICBUSGNTEBI; // Not used in SMI
  input        SMBUSGNTEBI;  // Not used in SMI
  input        SCANENABLE;  
  input        SCANINHCLK;
  input        SCANINnHCLK;  // Not used in SMI
  input        SMWAIT;       // Not used in SMI
  input        CANCELSMWAIT; // Not used in SMI
  input [1:0]  SMMWCS7;      // Not used in SMI
  input [31:0] SMDATAIN;
  input        TESTREQA;
  input        TESTREQB;
  input        MCBUSREQ;     // Not used in SMI
  input [25:0] MCADDR;       // Not used in SMI
  input [31:0] MCDATAOUT;    // Not used in SMI
  input [3:0]  MCDATAEN;     // Not used in SMI
  input        EXTBUSMUX;    // Not used in SMI
  
  output [31:0] HRDATA;
  output        HREADYOUT;
  output [1:0]  HRESP;
  output [31:0] HADDRTIC;
  output [1:0]  HTRANSTIC;
  output        HWRITETIC;
  output [2:0]  HSIZETIC;
  output [2:0]  HBURSTTIC;
  output [3:0]  HPROTTIC;
  output [31:0] HWDATATIC;
  output        HBUSREQTIC;
  output        HLOCKTIC;
  output        TICBUSREQEBI; // Not used in SMI
  output        SMBUSREQEBI;  // Not used in SMI
  output        SCANOUTnHCLK; // Not used in SMI
  output        SCANOUTHCLK;
  output [31:0] SMDATAOUT;
  output [3:0]  nSMDATAEN;
  output [25:0] SMADDR;
  output [7:0]  SMCS;
  output [3:0]  nSMBLS;
  output        nSMWEN;       // Not used in SMI
  output        nSMOEN;
  output        TICREADEBI;   // Not used in SMI
  output [31:0] TBUSOUTEBI;   // Not used in SMI
  output        TESTACK;
  output        MCBUSGNT;     // Not used in SMI
  
//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// Input/Output Signals
  wire          nHCLK;         // Not used in SMI 
  wire          HCLK;
  wire          HRESETn;
  wire          HREADYIN;
  wire          HREADYINTIC;   // !!NOT PRESENT IN PL092!! 
  wire [28:0]   HADDR;
  wire [2:0]    HBURST;        // Not used in SMI 
  wire [1:0]    HTRANS;
  wire          HWRITE;
  wire [2:0]    HSIZE;
  wire [31:0]   HWDATA;
  wire          HSELSMC;
  wire          HSELREG;       // Not used in SMI 
  wire [1:0]    HRESPTIC;
  wire [31:0]   HRDATATIC;
  wire          HGRANTTIC;
  wire          BIGENDIAN;     // Not used in SMI 
  wire          REMAP;
  wire          TICBUSGNTEBI;  // Not used in SMI 
  wire          SMBUSGNTEBI;   // Not used in SMI 
  wire          SCANENABLE;    // Not used in SMI 
  wire          SCANINHCLK;    // Not used in SMI 
  wire          SCANINnHCLK;   // Not used in SMI 
  wire          SMWAIT;        // Not used in SMI 
  wire          CANCELSMWAIT;  // Not used in SMI 
  wire [1:0]    SMMWCS7;       // Not used in SMI 
  wire [31:0]   SMDATAIN;
  wire          TESTREQA;
  wire          TESTREQB;
  wire          MCBUSREQ;      // Not used in SMI 
  wire [25:0]   MCADDR;        // Not used in SMI 
  wire [31:0]   MCDATAOUT;     // Not used in SMI 
  wire [3:0]    MCDATAEN;      // Not used in SMI 
  wire          EXTBUSMUX;     // Not used in SMI 
  wire [31:0]   HRDATA;
  wire          HREADYOUT;
  wire [1:0]    HRESP;
  wire [31:0]   HADDRTIC;
  wire [1:0]    HTRANSTIC;
  wire          HWRITETIC;
  wire [2:0]    HSIZETIC;
  wire [2:0]    HBURSTTIC;
  wire [3:0]    HPROTTIC;
  wire [31:0]   HWDATATIC;
  wire          HBUSREQTIC;
  wire          HLOCKTIC;
  wire          TICBUSREQEBI;  // Not used in SMI 
  wire          SMBUSREQEBI;   // Not used in SMI 
  wire          SCANOUTnHCLK;  // Not used in SMI 
  wire          SCANOUTHCLK;   // Not used in SMI 
  wire [31:0]   SMDATAOUT;
  wire [3:0]    nSMDATAEN;
  wire [25:0]   SMADDR;
  wire [7:0]    SMCS;
  wire [3:0]    nSMBLS;
  wire          nSMWEN;        // Not used in SMI 
  wire          nSMOEN;
  wire          TICREADEBI;    // Not used in SMI 
  wire [31:0]   TBUSOUTEBI;    // Not used in SMI 
  wire          TESTACK;
  wire          MCBUSGNT;      // Not used in SMI
  
// Internal Signals
  wire [3:0]    nSMCDATAEN;
  wire          TICREAD;
  wire [31:0]   SMCDATAOUT;


//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

// The data bus interface
  SmiDBI uSmiDBI 
    (.nSMCDATAEN (nSMCDATAEN),
     .TICREAD    (TICREAD),
     .SMCDATAOUT (SMCDATAOUT),
     .HRDATATIC  (HRDATATIC),

     .nSMDATAEN  (nSMDATAEN),
     .SMDATAOUT  (SMDATAOUT)
    );

// An example external bus interface
  SmiCore uSmiCore 
    (.HCLK      (HCLK),
     .HRESETn   (HRESETn),
     .HADDR     (HADDR),
     .HTRANS    (HTRANS),
     .HWRITE    (HWRITE),
     .HSIZE     (HSIZE),
     .HWDATA    (HWDATA),
     .HSELSMC   (HSELSMC),
     .HREADYIN  (HREADYIN),

     .HRDATA    (HRDATA),
     .HREADYOUT (HREADYOUT),
     .HRESP     (HRESP),

     .REMAP     (REMAP),

     .SMDATAIN  (SMDATAIN),
     .SMDATAOUT (SMCDATAOUT),
     .nSMDATAEN (nSMCDATAEN),
     .SMADDR    (SMADDR),
     .SMCS      (SMCS),
     .nSMBLS    (nSMBLS),
     .nSMOEN    (nSMOEN)
    );

// The test interface controller
  TIC uTIC 
    (.HCLK       (HCLK),
     .HRESETn    (HRESETn),
     .HREADY     (HREADYINTIC),
     .HRESP      (HRESPTIC),
     .HGRANTtic  (HGRANTTIC),

     .HADDR      (HADDRTIC),
     .HTRANS     (HTRANSTIC),
     .HWRITE     (HWRITETIC),
     .HSIZE      (HSIZETIC),
     .HBURST     (HBURSTTIC), 
     .HPROT      (HPROTTIC),
     .HWDATA     (HWDATATIC),
     .HBUSREQtic (HBUSREQTIC),
     .HLOCKtic   (HLOCKTIC),

     .TESTBUS    (SMDATAIN), 
     .TESTREQA   (TESTREQA), 
     .TESTREQB   (TESTREQB), 

     .TESTACK    (TESTACK), 
     .TicRead    (TICREAD) 
    );

endmodule
