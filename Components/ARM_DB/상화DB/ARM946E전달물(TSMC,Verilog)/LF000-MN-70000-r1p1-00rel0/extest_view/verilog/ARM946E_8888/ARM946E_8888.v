// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (c) COPYRIGHT 2000-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name           : $RCSfile: ARM946E_8888.v,v $
// File Revision       : $Revision: 1.2 $
//
// Release Information : $State: Rel $
//-----------------------------------------------------------------------------
//
// Abstract : Top level of the cpu subsystem including the core, the
//            test wrapper and the TCMs.

module ARM946E_8888 (
  // Outputs
  HBUSREQ, HLOCK, HADDR, HTRANS, HWRITE, HSIZE, HBURST, HPROT, 
  HWDATA, CPINSTR, CPDOUT, CPPASS, CPLATECANCEL, CPTBIT, nCPMREQ, 
  nCPTRANS, CPCLKEN, COMMRX, COMMTX, DBGACK, DBGRQI, DBGINSTREXEC, 
  DBGRNG, DBGTDO, DBGIR, DBGSCREG, DBGTAPSM, DBGnTDOEN, DBGSDIN, 
  BIGENDOUT, ETMBIGEND, ETMHIVECS, ETMIA, ETMInMREQ, 
  ETMISEQ, ETMITBIT, ETMIABORT, ETMDA, ETMDMAS, ETMDMORE, ETMDnMREQ, 
  ETMDnRW, ETMDSEQ, ETMRDATA, ETMDABORT, ETMCHSD, ETMCHSE, ETMnWAIT, 
  ETMID31To25, ETMID15To11, ETMWDATA, ETMLATECANCEL, ETMPASS, 
  ETMDBGACK, ETMINSTREXEC, ETMRNGOUT, ETMPROCID, ETMPROCIDWR, 
  ETMINSTRVALID, SO, SCANOUT1, SCANOUT2, SCANOUT3, SCANOUT4,
  // Inputs
  HRESETn, HCLKEN, CLK, HGRANT, HRDATA, HREADY, HRESP, 
  CPDIN, CHSDE, CHSEX, DBGEN, EDBGRQ, DBGEXT, DBGIEBKPT, DBGDEWPT, 
  DBGnTRST, DBGTCKEN, DBGTDI, DBGTMS, DBGSDOUT, nFIQ, nIRQ, VINITHI, 
  INITRAM, TAPID, DCacheSize, ICacheSize, ETMFIFOFULL, ETMEN, SI, 
  SCANEN, TESTMODE, SERIALEN, TESTEN, INnotEXTEST, INSCANENABLE,
  EXSCANENABLE, PhyDTCMSize, PhyITCMSize, SCANIN1, SCANIN2, SCANIN3, SCANIN4
  );

// Clock and Reset
  input          HRESETn;         // System Reset - Active low  
  input          HCLKEN;          // AHB Bus Clock Enable  
  input          CLK;             // System Clock  

  // Master Mode AHB Signals
  output         HBUSREQ;         // AHB Bus request 
  input          HGRANT;          // AHB Bus Grant 
  output         HLOCK;           // AHB Locked Transfer 
  output [31:0]  HADDR;           // AHB Address Bus
  output [1:0]   HTRANS;          // AHB Transfer Type
  output         HWRITE;          // AHB Transfer Direction
  output [2:0]   HSIZE;           // AHB Transfer Size
  output [2:0]   HBURST;          // AHB Burst Type
  output [3:0]   HPROT;           // AHB Protection Control 
  output [31:0]  HWDATA;          // AHB Write Data
  input  [31:0]  HRDATA;          // AHB Read Data
  input          HREADY;          // AHB Transfer Done
  input  [1:0]   HRESP;           // AHB Transfer Response
  
  // Coprocessor Interface Signals
  output [31:0]  CPINSTR;         // Coprocessor Instruction Data
  output [31:0]  CPDOUT;          // Coprocessor Data Out
  input  [31:0]  CPDIN;           // Coprocessor Data In
  output         CPPASS;          // Coprocessor Pass
  output         CPLATECANCEL;    // Coprocessor Late Cancel
  input  [1:0]   CHSDE;           // Coprocessor Handshake Decode
  input  [1:0]   CHSEX;           // Coprocessor Handshake Execute
  output         CPTBIT;          // Coprocessor Interface in Thumb State
  output         nCPMREQ;         // Not-Coprocessor Memory Request
  output         nCPTRANS;        // Not-Coprocessor Translate
  output         CPCLKEN;         // Coprocessor Clock Enable
  
  // Debug Signals
  output         COMMRX;          // Communications Channel Receive 
  output         COMMTX;          // Communications Channel Transmit
  output         DBGACK;          // Debug Acknowledge
  input          DBGEN;           // Debug Enable
  output         DBGRQI;          // Internal Debug Request
  input          EDBGRQ;          // External Debug Request
  input  [1:0]   DBGEXT;          // EmbeddedICE External Input
  output         DBGINSTREXEC;    // Instruction Executed
  output [1:0]   DBGRNG;          // EmbeddedICE Rangeout
  input          DBGIEBKPT;       // Instruction Breakpoint
  input          DBGDEWPT;        // Data Watchpoint
  
  // JTAG Signals
  input          DBGnTRST;        // Not-Test Reset
  input          DBGTCKEN;        // TAP Clock Enable
  input          DBGTDI;          // Test Data Input To Debug Logic
  input          DBGTMS;          // Test Mode Select
  output         DBGTDO;          // Test Data Output From Debug Logic
  output [3:0]   DBGIR;           // TAP Controller Instruction Register
  output [4:0]   DBGSCREG;        // Scan Chain Selected ID
  output [3:0]   DBGTAPSM;        // Tap Controller State Machine
  output         DBGnTDOEN;       // Not-DBGTDO Enable
  output         DBGSDIN;         // External Scan Chain Serial Input
  input          DBGSDOUT;        // External Scan Chain Serial Output
  
  // Miscellaneous Signals
  input          nFIQ;            // Not-Fast Interrupt Request
  input          nIRQ;            // Not-Interrupt Request
  input          VINITHI;         // Exception Vector Location At Reset
  input          INITRAM;         // Instruction TCM Enabled At Reset 
  input [31:0]   TAPID;           // Boundary Scan ID Code        
  input [3:0]    DCacheSize;      // D-Cache Size
  input [3:0]    ICacheSize;      // I-Cache Size
  output         BIGENDOUT;       // Big Endian
  
  // Embedded Trace Module Signals
  input          ETMFIFOFULL;     // ETM Fifo Full
  input          ETMEN;           // ETM Interface Enable
  output         ETMBIGEND;       // ETM Big Endian
  output         ETMHIVECS;       // ETM Exception Vectors Configuration
  output [31:1]  ETMIA;           // ETM Instruction Address
  output         ETMInMREQ;       // ETM Instruction Memory Request
  output         ETMISEQ;         // ETM Sequential Instruction Access
  output         ETMITBIT;        // ETM Thumb State Indication
  output         ETMIABORT;       // ETM Instruction Abort
  output [31:0]  ETMDA;           // ETM Data Address
  output [1:0]   ETMDMAS;         // ETM Data Size Indication
  output         ETMDMORE;        // ETM More Sequential Data Indication
  output         ETMDnMREQ;       // ETM Data Memory Request
  output         ETMDnRW;         // ETM Data Access Not-Read/Write 
  output         ETMDSEQ;         // ETM Sequential Data Access
  output [31:0]  ETMRDATA;        // ETM Read Data
  output         ETMDABORT;       // ETM Data Abort
  output [1:0]   ETMCHSD;         // ETM Coprocessor Handshake Decode Signals
  output [1:0]   ETMCHSE;         // ETM Coprocessor Handshake Execute Signals
  output         ETMnWAIT;        // ETM ARM9E-S Stalled Indication
  output [31:25] ETMID31To25;     // ETM Instruction Data Field
  output [15:11] ETMID15To11;     // ETM Instruction Data Field
  output [31:0]  ETMWDATA;        // ETM Write Data
  output         ETMLATECANCEL;   // ETM Coprocessor Late Cancel
  output         ETMPASS;         // ETM Coprocessor Pass
  output         ETMDBGACK;       // ETM Debug State Indication
  output         ETMINSTREXEC;    // ETM Instruction Execution Indication
  output [1:0]   ETMRNGOUT;       // ETM Watchpoint Register Match 
  output [31:0]  ETMPROCID;       // ETM Trace Processor ID 
  output         ETMPROCIDWR;     // ETM Trace Processor ID Write
  output         ETMINSTRVALID;   // ETM Instruction Valid
  
  // ATPG signals
  input          SI;              // Serial Input Data For INTEST Wrapper SC
  input          SCANEN;          // Enable Scanning of Data in INTEST SC
  input          TESTMODE;        // Test Mode Bypass Signal
  input          SERIALEN;        // Enable INTEST Wrapper BIST Activation MODE
  input          TESTEN;          // INTEST Wrapper Scan Chain Select
  input          INnotEXTEST;     // INTERNAL not EXTERNAL Test
  output         SO;              // Serial Output From INTEST Wrapper SC
  input          INSCANENABLE;    // Scan enable for INTEST
  input          EXSCANENABLE;    // Scan enable for EXTEST
  input          SCANIN1;         // ATPG Scan Chain #1 input
  input          SCANIN2;         // ATPG Scan Chain #2 input
  input          SCANIN3;         // ATPG Scan Chain #3 input
  input          SCANIN4;         // ATPG Scan Chain #4 input
  output         SCANOUT1;        // ATPG Scan Chain #1 output
  output         SCANOUT2;        // ATPG Scan Chain #2 output
  output         SCANOUT3;        // ATPG Scan Chain #3 output
  output         SCANOUT4;        // ATPG Scan Chain #4 output

  // TCM Signals
  input   [3:0]  PhyDTCMSize;    // Physical Size - Data Tightly Coupled Memory
  input   [3:0]  PhyITCMSize;    // Physical Size - Ins. Tightly Coupled Memory

// Beginning of automatic wires (for undeclared instantiated-module outputs)
wire [1:0]              iCHSDE;                 // From uWrapper of A946ESWrapper.v
wire [1:0]              iCHSEX;                 // From uWrapper of A946ESWrapper.v
wire [31:0]             iCPDIN;                 // From uWrapper of A946ESWrapper.v
wire                    iDBGDEWPT;              // From uWrapper of A946ESWrapper.v
wire                    iDBGEN;                 // From uWrapper of A946ESWrapper.v
wire [1:0]              iDBGEXT;                // From uWrapper of A946ESWrapper.v
wire                    iDBGIEBKPT;             // From uWrapper of A946ESWrapper.v
wire                    iDBGSDOUT;              // From uWrapper of A946ESWrapper.v
wire                    iDBGTCKEN;              // From uWrapper of A946ESWrapper.v
wire                    iDBGTDI;                // From uWrapper of A946ESWrapper.v
wire                    iDBGTMS;                // From uWrapper of A946ESWrapper.v
wire                    iDBGnTRST;              // From uWrapper of A946ESWrapper.v
wire [3:0]              iDCacheSize;            // From uWrapper of A946ESWrapper.v
wire                    iEDBGRQ;                // From uWrapper of A946ESWrapper.v
wire                    iETMEN;                 // From uWrapper of A946ESWrapper.v
wire                    iHCLKEN;                // From uWrapper of A946ESWrapper.v
wire                    iHGRANT;                // From uWrapper of A946ESWrapper.v
wire [31:0]             iHRDATA;                // From uWrapper of A946ESWrapper.v
wire                    iHREADY;                // From uWrapper of A946ESWrapper.v
wire                    iHRESETn;               // From uWrapper of A946ESWrapper.v
wire [1:0]              iHRESP;                 // From uWrapper of A946ESWrapper.v
wire [3:0]              iICacheSize;            // From uWrapper of A946ESWrapper.v
wire [31:0]             iTAPID;                 // From uWrapper of A946ESWrapper.v
wire                    iVINITHI;               // From uWrapper of A946ESWrapper.v
wire                    iINITRAM;               // From uWrapper of A946ESWrapper.v
wire                    inFIQ;                  // From uWrapper of A946ESWrapper.v
wire                    inIRQ;                  // From uWrapper of A946ESWrapper.v
  wire [31:1]           iETMIA;
  wire [31:0]           iHADDR;
  wire [1:0]            iHTRANS;
  wire [2:0]            iHBURST;
  wire [2:0]            iHSIZE;
  wire [3:0]            iHPROT;
  wire [31:0]           iHWDATA;
  wire [31:0]           iCPINSTR;
  wire [31:0]           iCPDOUT;
  wire [1:0]            iDBGRNG;
  wire [3:0]            iDBGIR;
  wire [4:0]            iDBGSCREG;
  wire [3:0]            iDBGTAPSM;
  wire [31:25]          iETMID31To25;
  wire [15:11]          iETMID15To11;
  wire [31:0]           iETMDA;
  wire [31:0]           iETMWDATA;
  wire [1:0]            iETMDMAS;
  wire [31:0]           iETMRDATA;
  wire [1:0]            iETMCHSD;
  wire [1:0]            iETMCHSE;
  wire [1:0]            iETMRNGOUT;
  wire [31:0]           iETMPROCID;
  wire                  iETMFIFOFULL;
  wire [17:0]           ITCMAdrs;
  wire [17:0]           DTCMAdrs;
  wire [3:0]            DTCMWEn; 
  wire [31:0]           ITCMWData;
  wire [31:0]           ITCMRData; 
  wire [3:0]            ITCMWEn;
  wire [31:0]           DTCMRData;
  wire [31:0]           DTCMWData;

  // GateTheCLK is is an unused and unconnected output from ARM946ES
  wire                  GateTheCLK;
                
// INTEST Wrapper Instantiation
  A946ESWrapper uWrapper
    (
     // Outputs
     .HADDR                             (HADDR[31:0]),
     .HTRANS                            (HTRANS[1:0]),
     .HBURST                            (HBURST[2:0]),
     .HWRITE                            (HWRITE),
     .HSIZE                             (HSIZE[2:0]),
     .HPROT                             (HPROT[3:0]),
     .iHREADY                           (iHREADY),
     .iHRESP                            (iHRESP[1:0]),
     .HWDATA                            (HWDATA[31:0]),
     .iHRDATA                           (iHRDATA[31:0]),
     .HBUSREQ                           (HBUSREQ),
     .iHGRANT                           (iHGRANT),
     .HLOCK                             (HLOCK),
     .iHRESETn                          (iHRESETn),
     .CPCLKEN                           (CPCLKEN),
     .CPINSTR                           (CPINSTR[31:0]),
     .CPDOUT                            (CPDOUT[31:0]),
     .iCPDIN                            (iCPDIN[31:0]),
     .CPPASS                            (CPPASS),
     .CPLATECANCEL                      (CPLATECANCEL),
     .iCHSDE                            (iCHSDE[1:0]),
     .iCHSEX                            (iCHSEX[1:0]),
     .CPTBIT                            (CPTBIT),
     .nCPMREQ                           (nCPMREQ),
     .nCPTRANS                          (nCPTRANS),
     .COMMRX                            (COMMRX),
     .COMMTX                            (COMMTX),
     .DBGACK                            (DBGACK),
     .iDBGEN                            (iDBGEN),
     .DBGRQI                            (DBGRQI),
     .iEDBGRQ                           (iEDBGRQ),
     .iDBGEXT                           (iDBGEXT[1:0]),
     .DBGINSTREXEC                      (DBGINSTREXEC),
     .DBGRNG                            (DBGRNG[1:0]),
     .iDBGIEBKPT                        (iDBGIEBKPT),
     .iDBGDEWPT                         (iDBGDEWPT),
     .iDBGnTRST                         (iDBGnTRST),
     .iDBGTCKEN                         (iDBGTCKEN),
     .iDBGTDI                           (iDBGTDI),
     .iDBGTMS                           (iDBGTMS),
     .DBGTDO                            (DBGTDO),
     .DBGIR                             (DBGIR[3:0]),
     .DBGSCREG                          (DBGSCREG[4:0]),
     .DBGTAPSM                          (DBGTAPSM[3:0]),
     .DBGnTDOEN                         (DBGnTDOEN),
     .DBGSDIN                           (DBGSDIN),
     .iDBGSDOUT                         (iDBGSDOUT),
     .iHCLKEN                           (iHCLKEN),
     .inFIQ                             (inFIQ),
     .inIRQ                             (inIRQ),
     .BIGENDOUT                         (BIGENDOUT),
     .iVINITHI                          (iVINITHI),
     .iDCacheSize                       (iDCacheSize[3:0]),
     .iICacheSize                       (iICacheSize[3:0]),
     .ETMBIGEND                         (ETMBIGEND),
     .ETMHIVECS                         (ETMHIVECS),
     .ETMnWAIT                          (ETMnWAIT),
     .ETMIA                             (ETMIA[31:1]),
     .ETMInMREQ                         (ETMInMREQ),
     .ETMISEQ                           (ETMISEQ),
     .ETMITBIT                          (ETMITBIT),
     .ETMIABORT                         (ETMIABORT),
     .ETMID31To25                       (ETMID31To25[31:25]),
     .ETMID15To11                       (ETMID15To11[15:11]),
     .ETMDA                             (ETMDA[31:0]),
     .ETMWDATA                          (ETMWDATA[31:0]),
     .ETMDMAS                           (ETMDMAS[1:0]),
     .ETMDMORE                          (ETMDMORE),
     .ETMDnMREQ                         (ETMDnMREQ),
     .ETMDnRW                           (ETMDnRW),
     .ETMDSEQ                           (ETMDSEQ),
     .ETMRDATA                          (ETMRDATA[31:0]),
     .ETMDABORT                         (ETMDABORT),
     .ETMCHSD                           (ETMCHSD[1:0]),
     .ETMCHSE                           (ETMCHSE[1:0]),
     .ETMLATECANCEL                     (ETMLATECANCEL),
     .ETMPASS                           (ETMPASS),
     .ETMDBGACK                         (ETMDBGACK),
     .ETMINSTREXEC                      (ETMINSTREXEC),
     .ETMINSTRVALID                     (ETMINSTRVALID),
     .ETMRNGOUT                         (ETMRNGOUT[1:0]),
     .iETMEN                            (iETMEN),
     .iTAPID                            (iTAPID[31:0]),
     .ETMPROCID                         (ETMPROCID[31:0]),
     .ETMPROCIDWR                       (ETMPROCIDWR),
     .iINITRAM                          (iINITRAM),
     .iETMFIFOFULL                      (iETMFIFOFULL),
     .SO                                (SO),
     // Inputs
     .iHADDR                            (iHADDR[31:0]),
     .iHTRANS                           (iHTRANS[1:0]),
     .iHBURST                           (iHBURST[2:0]),
     .iHWRITE                           (iHWRITE),
     .iHSIZE                            (iHSIZE[2:0]),
     .iHPROT                            (iHPROT[3:0]),
     .HREADY                            (HREADY),
     .HRESP                             (HRESP[1:0]),
     .iHWDATA                           (iHWDATA[31:0]),
     .HRDATA                            (HRDATA[31:0]),
     .iHBUSREQ                          (iHBUSREQ),
     .HGRANT                            (HGRANT),
     .iHLOCK                            (iHLOCK),
     .HRESETn                           (HRESETn),
     .iCPCLKEN                          (iCPCLKEN),
     .iCPINSTR                          (iCPINSTR[31:0]),
     .iCPDOUT                           (iCPDOUT[31:0]),
     .CPDIN                             (CPDIN[31:0]),
     .iCPPASS                           (iCPPASS),
     .iCPLATECANCEL                     (iCPLATECANCEL),
     .CHSDE                             (CHSDE[1:0]),
     .CHSEX                             (CHSEX[1:0]),
     .iCPTBIT                           (iCPTBIT),
     .inCPMREQ                          (inCPMREQ),
     .inCPTRANS                         (inCPTRANS),
     .iCOMMRX                           (iCOMMRX),
     .iCOMMTX                           (iCOMMTX),
     .iDBGACK                           (iDBGACK),
     .DBGEN                             (DBGEN),
     .iDBGRQI                           (iDBGRQI),
     .EDBGRQ                            (EDBGRQ),
     .DBGEXT                            (DBGEXT[1:0]),
     .iDBGINSTREXEC                     (iDBGINSTREXEC),
     .iDBGRNG                           (iDBGRNG[1:0]),
     .DBGIEBKPT                         (DBGIEBKPT),
     .DBGDEWPT                          (DBGDEWPT),
     .DBGnTRST                          (DBGnTRST),
     .DBGTCKEN                          (DBGTCKEN),
     .DBGTDI                            (DBGTDI),
     .DBGTMS                            (DBGTMS),
     .iDBGTDO                           (iDBGTDO),
     .iDBGIR                            (iDBGIR[3:0]),
     .iDBGSCREG                         (iDBGSCREG[4:0]),
     .iDBGTAPSM                         (iDBGTAPSM[3:0]),
     .iDBGnTDOEN                        (iDBGnTDOEN),
     .iDBGSDIN                          (iDBGSDIN),
     .DBGSDOUT                          (DBGSDOUT),
     .CLK                               (CLK),
     .HCLKEN                            (HCLKEN),
     .nFIQ                              (nFIQ),
     .nIRQ                              (nIRQ),
     .iBIGENDOUT                        (iBIGENDOUT),
     .VINITHI                           (VINITHI),
     .DCacheSize                        (DCacheSize[3:0]),
     .ICacheSize                        (ICacheSize[3:0]),
     .iETMBIGEND                        (iETMBIGEND),
     .iETMHIVECS                        (iETMHIVECS),
     .iETMnWAIT                         (iETMnWAIT),
     .iETMIA                            (iETMIA[31:1]),
     .iETMInMREQ                        (iETMInMREQ),
     .iETMISEQ                          (iETMISEQ),
     .iETMITBIT                         (iETMITBIT),
     .iETMIABORT                        (iETMIABORT),
     .iETMID31To25                      (iETMID31To25[31:25]),
     .iETMID15To11                      (iETMID15To11[15:11]),
     .iETMDA                            (iETMDA[31:0]),
     .iETMWDATA                         (iETMWDATA[31:0]),
     .iETMDMAS                          (iETMDMAS[1:0]),
     .iETMDMORE                         (iETMDMORE),
     .iETMDnMREQ                        (iETMDnMREQ),
     .iETMDnRW                          (iETMDnRW),
     .iETMDSEQ                          (iETMDSEQ),
     .iETMRDATA                         (iETMRDATA[31:0]),
     .iETMDABORT                        (iETMDABORT),
     .iETMCHSD                          (iETMCHSD[1:0]),
     .iETMCHSE                          (iETMCHSE[1:0]),
     .iETMLATECANCEL                    (iETMLATECANCEL),
     .iETMPASS                          (iETMPASS),
     .iETMDBGACK                        (iETMDBGACK),
     .iETMINSTREXEC                     (iETMINSTREXEC),
     .iETMINSTRVALID                    (iETMINSTRVALID),
     .iETMRNGOUT                        (iETMRNGOUT[1:0]),
     .ETMEN                             (ETMEN),
     .TAPID                             (TAPID[31:0]),
     .iETMPROCID                        (iETMPROCID[31:0]),
     .iETMPROCIDWR                      (iETMPROCIDWR),
     .INITRAM                           (INITRAM),
     .ETMFIFOFULL                       (ETMFIFOFULL),
     .IScanEn                           (SCANEN),
     .INSCANENABLE                      (INSCANENABLE),
     .EXSCANENABLE                      (EXSCANENABLE),
     .SerialEn                          (SERIALEN),
     .TestEn                            (TESTEN),
     .INnotEXTEST                       (INnotEXTEST),
     .SI                                (SI));
  
  // instantiate the ARM946ES Core
  ARM946E_88 
    uARM946E_88
      (
       // Outputs
       .GateTheCLK              (GateTheCLK),    //NC
       .HBUSREQ                 (iHBUSREQ),
       .HLOCK                   (iHLOCK),
       .HADDR                   (iHADDR),
       .HTRANS                  (iHTRANS),
       .HWRITE                  (iHWRITE),
       .HSIZE                   (iHSIZE),
       .HBURST                  (iHBURST),
       .HPROT                   (iHPROT),
       .HWDATA                  (iHWDATA),
       .CPINSTR                 (iCPINSTR),
       .CPDOUT                  (iCPDOUT),
       .CPPASS                  (iCPPASS),
       .CPLATECANCEL            (iCPLATECANCEL),
       .CPTBIT                  (iCPTBIT),
       .nCPMREQ                 (inCPMREQ),
       .nCPTRANS                (inCPTRANS),
       .CPCLKEN                 (iCPCLKEN),
       .COMMRX                  (iCOMMRX),
       .COMMTX                  (iCOMMTX),
       .DBGACK                  (iDBGACK),
       .DBGRQI                  (iDBGRQI), 
       .DBGINSTREXEC            (iDBGINSTREXEC),
       .DBGRNG                  (iDBGRNG),
       .DBGTDO                  (iDBGTDO),
       .DBGIR                   (iDBGIR),
       .DBGSCREG                (iDBGSCREG),
       .DBGTAPSM                (iDBGTAPSM),
       .DBGnTDOEN               (iDBGnTDOEN),
       .DBGSDIN                 (iDBGSDIN),
       .BIGENDOUT               (iBIGENDOUT),
       .ETMBIGEND               (iETMBIGEND),
       .ETMHIVECS               (iETMHIVECS),
       .ETMIA                   (iETMIA),
       .ETMInMREQ               (iETMInMREQ),
       .ETMISEQ                 (iETMISEQ),
       .ETMITBIT                (iETMITBIT),
       .ETMIABORT               (iETMIABORT),
       .ETMDA                   (iETMDA),
       .ETMDMAS                 (iETMDMAS),
       .ETMDMORE                (iETMDMORE),
       .ETMDnMREQ               (iETMDnMREQ),
       .ETMDnRW                 (iETMDnRW),
       .ETMDSEQ                 (iETMDSEQ),
       .ETMRDATA                (iETMRDATA),
       .ETMDABORT               (iETMDABORT),
       .ETMCHSD                 (iETMCHSD),
       .ETMCHSE                 (iETMCHSE),
       .ETMnWAIT                (iETMnWAIT),
       .ETMID31To25             (iETMID31To25),
       .ETMID15To11             (iETMID15To11),
       .ETMWDATA                (iETMWDATA),
       .ETMLATECANCEL           (iETMLATECANCEL),
       .ETMPASS                 (iETMPASS),
       .ETMDBGACK               (iETMDBGACK),
       .ETMINSTREXEC            (iETMINSTREXEC),
       .ETMRNGOUT               (iETMRNGOUT),
       .ETMPROCID               (iETMPROCID),
       .ETMPROCIDWR             (iETMPROCIDWR),
       .ETMINSTRVALID           (iETMINSTRVALID),
       .ITCMWData               (ITCMWData),
       .ITCMWEn                 (ITCMWEn),
       .ITCMEn                  (ITCMEn),
       .ITCMAdrs                (ITCMAdrs),
       .DTCMWData               (DTCMWData),
       .DTCMWEn                 (DTCMWEn),
       .DTCMEn                  (DTCMEn),
       .DTCMAdrs                (DTCMAdrs),
       .SCANOUT1                (SCANOUT1),
       .SCANOUT2                (SCANOUT2),
       .SCANOUT3                (SCANOUT3),
       .SCANOUT4                (SCANOUT4),
       // Inputs                
       .ITCMRData               (ITCMRData),
       .DTCMRData               (DTCMRData),
       .PhyDTCMSize             (PhyDTCMSize),
       .PhyITCMSize             (PhyITCMSize),
       .HRESETn                 (iHRESETn),
       .HCLKEN                  (iHCLKEN),
       .CLK                     (CLK),
       .HGRANT                  (iHGRANT),
       .HRDATA                  (iHRDATA),
       .HREADY                  (iHREADY),
       .HRESP                   (iHRESP),
       .CPDIN                   (iCPDIN),
       .CHSDE                   (iCHSDE),
       .CHSEX                   (iCHSEX),
       .DBGEN                   (iDBGEN),
       .EDBGRQ                  (iEDBGRQ),
       .DBGEXT                  (iDBGEXT),
       .DBGIEBKPT               (iDBGIEBKPT),
       .DBGDEWPT                (iDBGDEWPT),
       .DBGnTRST                (iDBGnTRST),
       .DBGTCKEN                (iDBGTCKEN),
       .DBGTDI                  (iDBGTDI),
       .DBGTMS                  (iDBGTMS),
       .DBGSDOUT                (iDBGSDOUT),
       .nFIQ                    (inFIQ),
       .nIRQ                    (inIRQ),
       .VINITHI                 (iVINITHI),
       .UnGatedCLK              (CLK),
       .INITRAM                 (iINITRAM),
       .ETMFIFOFULL             (iETMFIFOFULL),
       .TAPID                   (iTAPID),
       .DCacheSize              (iDCacheSize),
       .ICacheSize              (iICacheSize),
       .ETMEN                   (iETMEN),
       .SCANEN                  (A946SCANEN),
       .TESTMODE                (TESTMODE),
       .SCANIN1                 (SCANIN1),
       .SCANIN2                 (SCANIN2),
       .SCANIN3                 (SCANIN3),
       .SCANIN4                 (SCANIN4));

// A946SCANEN is the enable signal for ARM946ES ATPG
assign A946SCANEN = INSCANENABLE & ~SERIALEN;


//-----------------------------------------------------------
// Instruction Tightly Coupled Memory Instantiation
//-----------------------------------------------------------
`ifdef ITCM_PRESENT 
  A946ESITCM #(`RITCM_ADDR_WIDTH) iITCM (
    .CLK(CLK),
    .ADDR(ITCMAdrs[`RITCM_ADDR_WIDTH-1:0]),
    .DI(ITCMWData),
    .WE(ITCMWEn),
    .En(ITCMEn),
    .DO(ITCMRData));
`else
  assign ITCMRData = 32'h00000000;
`endif
 
//-----------------------------------------------------------
// Data Tightly Coupled Memory Instantiation
//-----------------------------------------------------------
`ifdef DTCM_PRESENT
  A946ESDTCM #(`RDTCM_ADDR_WIDTH) iDTCM (
    .CLK(CLK),
    .ADDR(DTCMAdrs[`RDTCM_ADDR_WIDTH-1:0]),
    .DI(DTCMWData),
    .WE(DTCMWEn),
    .En(DTCMEn),
    .DO(DTCMRData)
    );
`else
  assign DTCMRData = 32'h00000000;
`endif
  
endmodule // ARM946

// --================================= End ===================================--
