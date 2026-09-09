// -------------------------------------------------------------------------
// This confidential and proprietary software may be used only as authorised
// by a licensing agreement from ARM Limited
//                (c) COPYRIGHT 2003 ARM Limited
//                ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised copies and
// copies may only be made to the extent permitted by a licensing agreement
// from ARM Limited.
// -------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name           : ARM926EJS.v,v
// File Revision       : 1.50
//
// Release Information : ARM926EJS_r0p5-00rel0
// -------------------------------------------------------------------------


`timescale 1 ns / 10 ps

`include "ARM926EJS.vh" 

module ARM926EJS 
  (
   // Outputs
   STANDBYWFI,
   CFGBIGEND,
   
   DHADDR,
   DHTRANS,
   DHBURST,
   DHWRITE,
   DHSIZE, 
   DHBL,
   DHPROT,
   DHWDATA,
   DHBUSREQ, 
   DHLOCK,
   
   IHADDR,
   IHTRANS,
   IHBURST, 
   IHWRITE,
   IHSIZE,
   IHPROT,
   IHBUSREQ,
   IHLOCK,
   
   CPCLKEN,
   CPINSTR, 
   CPDOUT,
   CPPASS,
   CPLATECANCEL,
   nCPINSTRVALID,
   nCPMREQ,
   nCPTRANS, 
   CPABORT,
   
   COMMRX,
   COMMTX,
   
   DBGACK,
   DBGRQI,
   DBGINSTREXEC,
   DBGRNG, 
   DBGTDO,
   DBGIR,
   DBGSCREG,
   DBGTAPSM,
   DBGnTDOEN,
   DBGSDIN,
   
   ETMBIGEND, 
   ETMHIVECS,
   ETMIA,
   ETMInMREQ,
   ETMISEQ,
   ETMITBIT,
   ETMIJBIT, 
   ETMZIFIRST,
   ETMZILAST,
   ETMIABORT,
   ETMDA,
   ETMDMAS,
   ETMDMORE, 
   ETMDnMREQ,
   ETMDnRW,
   ETMDSEQ,
   ETMRDATA,
   ETMDABORT,
   ETMWDATA, 
   ETMnWAIT,
   ETMDBGACK,
   ETMINSTREXEC,
   ETMRNGOUT,
   ETMID31To25, 
   ETMID15To11,
   ETMCHSD,
   ETMCHSE,
   ETMPASS,
   ETMLATECANCEL,
   ETMPROCID, 
   ETMPROCIDWR,
   ETMINSTRVALID,
   
   DRnRW,
   DRADDR,
   DRWD,
   DRIDLE,
   DRCS, 
   DRWBL,
   DRSEQ,
   
   IRnRW,
   IRADDR,
   IRWD,
   IRIDLE,
   IRCS,
   IRWBL,
   IRSEQ, 
   
   `ifdef FPGA
   // FPGA debug 
   DBG0,
   DBG1,
   DSWITCH,
   `endif
   
   // Inputs
   CLK,
   nFIQ,
   nIRQ,
   VINITHI,
   BIGENDINIT,
   TAPID,
   HRESETn,
   
   DHCLKEN, 
   DHGRANT, 
   DHREADY,
   DHRESP,
   DHRDATA,
   
   IHCLKEN,
   IHGRANT,
   IHREADY,
   IHRESP, 
   IHRDATA,
   
   CPDIN,
   CHSDE,
   CHSEX,
   CPBURST,
   CPEN,
   
   DBGEN,
   EDBGRQ,
   DBGEXT, 
   DBGIEBKPT,
   DBGDEWPT,
   DBGnTRST,
   DBGTCKEN,
   DBGTDI,
   DBGTMS,
   DBGSDOUT, 
   ETMEN,
   FIFOFULL,
   DRRD,
   DRWAIT,
   DRSIZE,
   IRRD,
   IRWAIT,
   IRSIZE, 
   INITRAM,
   DRDMAEN,
   DRDMACS,
   DRDMAADDR,
   IRDMAEN,
   IRDMACS,
   IRDMAADDR,
   
   `ifdef TESTCHIP
   // dynamically selectable cache sizes (validation models only)
   DCACHESIZE,
   ICACHESIZE,
   `endif
   
   // ATPG:
   SCANENABLE,
   INTEST,
   EXTEST,
   TESTMODE
   );
  
  
   // FPGA debug
`ifdef FPGA
   output [33:0]     DBG0;       // FPGA debug output
   output [33:0]     DBG1;       // FPGA debug output
   input   [7:0]     DSWITCH;    // FPGA debug input (from DIP switches)
`endif

   // Clock, interrupts, etc.

   input             CLK;
   input             nFIQ;
   input             nIRQ;
   output            STANDBYWFI;
   input             VINITHI;
   input             BIGENDINIT;
   output            CFGBIGEND;
   input [31:0]      TAPID;
  
   // AHB signals - Common

   input             HRESETn;

   // AHB signals - D Side

   input             DHCLKEN;
   output [31:0]     DHADDR;
   output [1:0]      DHTRANS;
   output [2:0]      DHBURST;
   output            DHWRITE;
   output [2:0]      DHSIZE;
   output [3:0]      DHBL;
   output [3:0]      DHPROT;
   input             DHGRANT;
   input             DHREADY;
   input [1:0]       DHRESP;
   output [31:0]     DHWDATA;
   input [31:0]      DHRDATA;
   output            DHBUSREQ;
   output            DHLOCK;

   // AHB signals - I Side

   input             IHCLKEN;
   output [31:0]     IHADDR;
   output [1:0]      IHTRANS;
   output [2:0]      IHBURST;
   output            IHWRITE;
   output [2:0]      IHSIZE;
   output [3:0]      IHPROT;
   input             IHGRANT;
   input             IHREADY;
   input [1:0]       IHRESP;
   input [31:0]      IHRDATA;
   output            IHBUSREQ;
   output            IHLOCK;
  
  
   // Coprocessor interface signals

   output            CPCLKEN;
   output [31:0]     CPINSTR;
   output [31:0]     CPDOUT;
   input [31:0]      CPDIN;
   output            CPPASS;
   output            CPLATECANCEL;
   input [1:0]       CHSDE;
   input [1:0]       CHSEX;
   output            nCPINSTRVALID;
   output            nCPMREQ;
   output            nCPTRANS;
   input [3:0]       CPBURST;
   output            CPABORT;
   input             CPEN;
          
   // Debug signals

   output            COMMRX;
   output            COMMTX;
   output            DBGACK;
   input             DBGEN;
   output            DBGRQI;
   input             EDBGRQ;
   input [1:0]       DBGEXT;
   output            DBGINSTREXEC;
   output [1:0]      DBGRNG;
   input             DBGIEBKPT;
   input             DBGDEWPT;

   // Debug JTAG signals

   input             DBGnTRST;
   input             DBGTCKEN;
   input             DBGTDI;
   input             DBGTMS;
   output            DBGTDO;
   output [3:0]      DBGIR;
   output [4:0]      DBGSCREG;
   output [3:0]      DBGTAPSM;
   output            DBGnTDOEN;
   output            DBGSDIN;
   input             DBGSDOUT;
  
   // ETM Interface signals

   input             ETMEN;
   input             FIFOFULL;
   output            ETMBIGEND;
   output            ETMHIVECS;
   output [31:0]     ETMIA;
   output            ETMInMREQ;
   output            ETMISEQ;
   output            ETMITBIT;
   output            ETMIJBIT;
   output            ETMZIFIRST;
   output            ETMZILAST;
  
   output            ETMIABORT;
   output [31:0]     ETMDA;
   output [1:0]      ETMDMAS;
   output            ETMDMORE;
   output            ETMDnMREQ;
   output            ETMDnRW;
   output            ETMDSEQ;
   output [31:0]     ETMRDATA;
   output            ETMDABORT;
   output [31:0]     ETMWDATA;
   output            ETMnWAIT;
   output            ETMDBGACK;
   output            ETMINSTREXEC;
   output [1:0]      ETMRNGOUT;
   output [31:25]    ETMID31To25;
   output [15:11]    ETMID15To11;
   output [1:0]      ETMCHSD;
   output [1:0]      ETMCHSE;
   output            ETMPASS;
   output            ETMLATECANCEL;
   output [31:0]     ETMPROCID;
   output            ETMPROCIDWR;
   output            ETMINSTRVALID;

   // TCM Interface signals (non-DMA)

   output            DRnRW;
   output [17:0]     DRADDR;
   output [31:0]     DRWD;
   output            DRIDLE;
   output            DRCS;
   output [3:0]      DRWBL;
   output            DRSEQ;
   input [31:0]      DRRD;
   input             DRWAIT;
   input [3:0]       DRSIZE;

   output            IRnRW;
   output [17:0]     IRADDR;
   output [31:0]     IRWD;
   output            IRIDLE;
   output            IRCS;
   output [3:0]      IRWBL;
   output            IRSEQ;
   input [31:0]      IRRD;
   input             IRWAIT;
   input [3:0]       IRSIZE;
   input             INITRAM;


   // TCM DMA access 
  
   input             DRDMAEN;    // DTCM DMA enable
   input             DRDMACS;    // DTCM DMA CS.
   input [17:0]      DRDMAADDR;  // DTCM DMA address.

   input             IRDMAEN;    // ITCM DMA enable
   input             IRDMACS;    // ITCM DMA CS.
   input [17:0]      IRDMAADDR;  // ITCM DMA address.

  //ATPG

   input             SCANENABLE;
   input             INTEST;
   input             EXTEST;
   input             TESTMODE;

`ifdef TESTCHIP
  // dynamically size caches (validation model only)
   input [3:0]       DCACHESIZE;
   input [3:0]       ICACHESIZE;
`endif

   // From uCORE to uTLBRAM
   wire [4:0]        MMUxADDR;
   wire              MMUxCS;
   wire [111:0]      MMUxWD;
   wire [3:0]        MMUxWE;
   wire [111:0]      MMUxRD;

   // I$ RAM connections
   wire [3:0]        ICDATACS;     // chip selects to I$ data RAM
   wire [3:0]        ICDATABYTEWE; // byte write enables to I$ data RAM
   wire [9:0]        ICDATAINDEX;  // index (upper address bits) to I$ data RAM
   wire [2:0]        ICDATAWORDB0; // word address bits to I$ data RAM
   wire [2:0]        ICDATAWORDB1; // 
   wire [2:0]        ICDATAWORDB2; // 
   wire [2:0]        ICDATAWORDB3; // 
   wire [31:0]       ICDATAWD0;    // write data bus to I$ data RAM
   wire [31:0]       ICDATAWD1;    // 
   wire [31:0]       ICDATAWD2;    // 
   wire [31:0]       ICDATAWD3;    // 
   wire [31:0]       ICDATARD0;    // read data bus from I$ data RAM
   wire [31:0]       ICDATARD1;    //
   wire [31:0]       ICDATARD2;    //
   wire [31:0]       ICDATARD3;    //
   wire [3:0]        ICTAGCS;      // chip selects to I$ tag RAMs
   wire [3:0]        ICTAGWE;      // write enables to I$ tag RAMs
   wire [10:0]       ICTAGA;       // index/address to I$ tag RAMs
   wire [21:0]       ICTAGWD;      // write data bus to I$ tag RAMs
   wire [21:0]       ICTAGRD0;     // read data bus from I$ tag RAM
   wire [21:0]       ICTAGRD1;     //
   wire [21:0]       ICTAGRD2;     //
   wire [21:0]       ICTAGRD3;     //
   wire              ICVALIDCS;    // chip select to I$ valid RAM
   wire              ICVALIDWE;    // write enable to I$ valid RAM
   wire [7:0]        ICVALIDA;     // index/address to I$ valid RAM
   wire [23:0]       ICVALIDWD;    // write data bus to I$ valid RAM
   wire [23:0]       ICVALIDRD;    // read data bus from I$ valid RAM
   wire              ICBISTEN;     // enable BIST (test mode) for I$ RAMs
   wire [12:0]       ICBISTA;      // address used in BIST mode going to I$ RAMs
   wire [3:0]        ICBISTDATACS; // I$ data RAM chip selects in BIST mode
   wire              ICBISTVALIDCS;// I$ valid RAM chip select in BIST mode
   wire [3:0]        ICBISTTAGCS;  // I$ tag RAM chip selects in BIST mode
   wire              ICNoRRgen;    // I$ valid RAM contains RR bits ('0' == yes)
   // remove start (this line required for automem).
   wire [7:0]        TmpICValidA;
   wire [10:0]       TmpICTagA;
   wire [12:0]       TmpICDataA0;
   wire [12:0]       TmpICDataA1;
   wire [12:0]       TmpICDataA2;
   wire [12:0]       TmpICDataA3;
   // remove end (this line required for automem).

   // D$ RAM connections
   wire [3:0]        DCDATACS;     // D$ data RAM chip selects
   wire [3:0]        DCDATABYTEWE; // D$ data RAM write enables (byte)
   wire [9:0]        DCDATAINDEX;  // D$ data RAM address/index
   wire [2:0]        DCDATAWORDB0; // D$ data RAM address/word
   wire [2:0]        DCDATAWORDB1; // 
   wire [2:0]        DCDATAWORDB2; // 
   wire [2:0]        DCDATAWORDB3; // 
   wire [31:0]       DCDATAWD0;    // D$ data RAM write data bus
   wire [31:0]       DCDATAWD1;    // 
   wire [31:0]       DCDATAWD2;    // 
   wire [31:0]       DCDATAWD3;    // 
   wire [31:0]       DCDATARD0;    // D$ data RAM read data bus
   wire [31:0]       DCDATARD1;    //
   wire [31:0]       DCDATARD2;    //
   wire [31:0]       DCDATARD3;    //
   wire [3:0]        DCTAGCS;      // D$ tag RAM chip selects 
   wire [3:0]        DCTAGWE;      // D$ tag RAM write enables
   wire [10:0]       DCTAGA;       // D$ tag RAM address/index
   wire [21:0]       DCTAGWD;      // D$ tag RAM write data bus
   wire [21:0]       DCTAGRD0;     // D$ tag RAM read data bus
   wire [21:0]       DCTAGRD1;     //
   wire [21:0]       DCTAGRD2;     //
   wire [21:0]       DCTAGRD3;     //
   wire              DCVALIDCS;    // D$ valid RAM chip select 
   wire              DCVALIDWE;    // D$ valid RAM write enable
   wire [7:0]        DCVALIDA;     // D$ valid RAM address/index
   wire [23:0]       DCVALIDWD;    // D$ valid RAM write data bus
   wire [23:0]       DCVALIDRD;    // D$ valid RAM read data bus
   wire              DCDIRTYCS;    // D$ dirty RAM chip select
   wire [7:0]        DCDIRTYWE;    // D$ dirty RAM write enables (bit)
   wire [9:0]        DCDIRTYA;     // D$ dirty RAM address/index
   wire [7:0]        DCDIRTYWD;    // D$ dirty RAM write data bus
   wire [7:0]        DCDIRTYRD;    // D$ dirty RAM read data bus
   wire              DCBISTEN;     // D$ BIST mode enable
   wire [12:0]       DCBISTA;      // D$ BIST address
   wire [3:0]        DCBISTDATACS; // D$ BIST data RAM chip selects
   wire              DCBISTDIRTYCS;// D$ BIST dirty RAM chip select
   wire [3:0]        DCBISTTAGCS;  // D$ BIST tag RAM chip selects
   wire              DCBISTVALIDCS;// D$ BIST valid RAM chip select
   wire              DCNoRRgen;    // D$ valid RAM contains RR bits ('0' = yes)
   // remove start (this line required for automem).
   wire [9:0]        TmpDCDirtyA;
   wire [7:0]        TmpDCValidA;
   wire [10:0]       TmpDCTagA;
   wire [12:0]       TmpDCDataA0;
   wire [12:0]       TmpDCDataA1;
   wire [12:0]       TmpDCDataA2;
   wire [12:0]       TmpDCDataA3;
   // remove end (this line required for automem).

   wire [3:0]        DCACHESIZE;
   wire [3:0]        ICACHESIZE;
   wire [12:0]       DCDataAddr0;
   wire [12:0]       DCDataAddr1;
   wire [12:0]       DCDataAddr2;
   wire [12:0]       DCDataAddr3;
   wire [12:0]       ICDataAddr0;
   wire [12:0]       ICDataAddr1;
   wire [12:0]       ICDataAddr2;
   wire [12:0]       ICDataAddr3;

   ARM926EJSCore uCORE (//Outputs:
                       .STANDBYWFI    (STANDBYWFI),
                       .CFGBIGEND     (CFGBIGEND),
                       .DHADDR        (DHADDR[31:0]),
                       .DHTRANS       (DHTRANS[1:0]),
                       .DHBURST       (DHBURST[2:0]),
                       .DHWRITE       (DHWRITE),
                       .DHSIZE        (DHSIZE[2:0]),
                       .DHBL          (DHBL[3:0]),
                       .DHPROT        (DHPROT[3:0]),
                       .DHWDATA       (DHWDATA[31:0]),
                       .DHBUSREQ      (DHBUSREQ),
                       .DHLOCK        (DHLOCK),
                       .IHADDR        (IHADDR[31:0]),
                       .IHTRANS       (IHTRANS[1:0]),
                       .IHBURST       (IHBURST[2:0]),
                       .IHWRITE       (IHWRITE),
                       .IHSIZE        (IHSIZE[2:0]),
                       .IHPROT        (IHPROT[3:0]),
                       .IHBUSREQ      (IHBUSREQ),
                       .IHLOCK        (IHLOCK),
                       .CPCLKEN       (CPCLKEN),
                       .CPINSTR       (CPINSTR[31:0]),
                       .CPDOUT        (CPDOUT[31:0]),
                       .CPPASS        (CPPASS),
                       .CPLATECANCEL  (CPLATECANCEL),
                       .nCPINSTRVALID (nCPINSTRVALID),
                       .nCPMREQ       (nCPMREQ),
                       .nCPTRANS      (nCPTRANS),
                       .CPABORT       (CPABORT),
                       .COMMRX        (COMMRX),
                       .COMMTX        (COMMTX),
                       .DBGACK        (DBGACK),
                       .DBGRQI        (DBGRQI),
                       .DBGINSTREXEC  (DBGINSTREXEC),
                       .DBGRNG        (DBGRNG[1:0]),
                       .DBGTDO        (DBGTDO),
                       .DBGIR         (DBGIR[3:0]),
                       .DBGSCREG      (DBGSCREG[4:0]),
                       .DBGTAPSM      (DBGTAPSM[3:0]),
                       .DBGnTDOEN     (DBGnTDOEN),
                       .DBGSDIN       (DBGSDIN),
                       .ETMBIGEND     (ETMBIGEND),
                       .ETMHIVECS     (ETMHIVECS),
                       .ETMIA         (ETMIA[31:0]),
                       .ETMInMREQ     (ETMInMREQ),
                       .ETMISEQ       (ETMISEQ),
                       .ETMITBIT      (ETMITBIT),
                       .ETMIJBIT      (ETMIJBIT),
                       .ETMZIFIRST    (ETMZIFIRST),
                       .ETMZILAST     (ETMZILAST),
                       .ETMIABORT     (ETMIABORT),
                       .ETMDA         (ETMDA[31:0]),
                       .ETMDMAS       (ETMDMAS[1:0]),
                       .ETMDMORE      (ETMDMORE),
                       .ETMDnMREQ     (ETMDnMREQ),
                       .ETMDnRW       (ETMDnRW),
                       .ETMDSEQ       (ETMDSEQ),
                       .ETMRDATA      (ETMRDATA[31:0]),
                       .ETMDABORT     (ETMDABORT),
                       .ETMWDATA      (ETMWDATA[31:0]),
                       .ETMnWAIT      (ETMnWAIT),
                       .ETMDBGACK     (ETMDBGACK),
                       .ETMINSTREXEC  (ETMINSTREXEC),
                       .ETMRNGOUT     (ETMRNGOUT[1:0]),
                       .ETMID31To25   (ETMID31To25[31:25]),
                       .ETMID15To11   (ETMID15To11[15:11]),
                       .ETMCHSD       (ETMCHSD[1:0]),
                       .ETMCHSE       (ETMCHSE[1:0]),
                       .ETMPASS       (ETMPASS),
                       .ETMLATECANCEL (ETMLATECANCEL),
                       .ETMPROCID     (ETMPROCID[31:0]),
                       .ETMPROCIDWR   (ETMPROCIDWR),
                       .ETMINSTRVALID (ETMINSTRVALID),
                       .DRnRW         (DRnRW),
                       .DRADDR        (DRADDR[17:0]),
                       .DRWD          (DRWD[31:0]),
                       .DRIDLE        (DRIDLE),
                       .DRCS          (DRCS),
                       .DRWBL         (DRWBL[3:0]),
                       .DRSEQ         (DRSEQ),
                       .IRnRW         (IRnRW),
                       .IRADDR        (IRADDR[17:0]),
                       .IRWD          (IRWD[31:0]),
                       .IRIDLE        (IRIDLE),
                       .IRCS          (IRCS),
                       .IRWBL         (IRWBL[3:0]),
                       .IRSEQ         (IRSEQ),
`ifdef FPGA
                       .DBG0          (DBG0[33:0]),
                       .DBG1          (DBG1[33:0]),
`endif
                       .MMUxADDR      (MMUxADDR[4:0]),
                       .MMUxWD        (MMUxWD[111:0]),
                       .MMUxCS        (MMUxCS),
                       .MMUxWE        (MMUxWE[3:0]),
                       .DCACHESIZE    (`DATA_CACHE_SIZE),       
                       .DCTAGCS       (DCTAGCS[3:0]),
                       .DCTAGA        (DCTAGA[10:0]),
                       .DCTAGWE       (DCTAGWE[3:0]),
                       .DCTAGWD       (DCTAGWD[21:0]),
                       .DCDATACS      (DCDATACS[3:0]),
                       .DCDATAINDEX   (DCDATAINDEX[9:0]),
                       .DCDATAWORDB0  (DCDATAWORDB0[2:0]),
                       .DCDATAWORDB1  (DCDATAWORDB1[2:0]),
                       .DCDATAWORDB2  (DCDATAWORDB2[2:0]),
                       .DCDATAWORDB3  (DCDATAWORDB3[2:0]),
                       .DCDATABYTEWE  (DCDATABYTEWE[3:0]),
                       .DCDATAWD0     (DCDATAWD0[31:0]),
                       .DCDATAWD1     (DCDATAWD1[31:0]),
                       .DCDATAWD2     (DCDATAWD2[31:0]),
                       .DCDATAWD3     (DCDATAWD3[31:0]),
                       .DCVALIDCS     (DCVALIDCS),
                       .DCVALIDA      (DCVALIDA[7:0]),
                       .DCVALIDWE     (DCVALIDWE),
                       .DCVALIDWD     (DCVALIDWD[23:0]),
                       .DCDIRTYCS     (DCDIRTYCS),
                       .DCDIRTYA      (DCDIRTYA[9:0]),
                       .DCDIRTYWE     (DCDIRTYWE[7:0]),
                       .DCDIRTYWD     (DCDIRTYWD[7:0]),
                       .ICACHESIZE    (`INSTR_CACHE_SIZE),       
                       .ICTAGCS       (ICTAGCS[3:0]),
                       .ICTAGA        (ICTAGA[10:0]),
                       .ICTAGWE       (ICTAGWE[3:0]),
                       .ICTAGWD       (ICTAGWD[21:0]),
                       .ICDATACS      (ICDATACS[3:0]),
                       .ICDATAINDEX   (ICDATAINDEX[9:0]),
                       .ICDATAWORDB0  (ICDATAWORDB0[2:0]),
                       .ICDATAWORDB1  (ICDATAWORDB1[2:0]),
                       .ICDATAWORDB2  (ICDATAWORDB2[2:0]),
                       .ICDATAWORDB3  (ICDATAWORDB3[2:0]),
                       .ICDATABYTEWE  (ICDATABYTEWE[3:0]),
                       .ICDATAWD0     (ICDATAWD0[31:0]),
                       .ICDATAWD1     (ICDATAWD1[31:0]),
                       .ICDATAWD2     (ICDATAWD2[31:0]),
                       .ICDATAWD3     (ICDATAWD3[31:0]),
                       .ICVALIDCS     (ICVALIDCS),
                       .ICVALIDA      (ICVALIDA[7:0]),
                       .ICVALIDWE     (ICVALIDWE),
                       .ICVALIDWD     (ICVALIDWD[23:0]),
                       //Inputs:
                       .CLK           (CLK),
                       .nFIQ          (nFIQ),
                       .nIRQ          (nIRQ),
                       .VINITHI       (VINITHI),
                       .BIGENDINIT    (BIGENDINIT),
                       .TAPID         (TAPID[31:0]),
                       .HRESETn       (HRESETn),
                       .DHCLKEN       (DHCLKEN),
                       .DHGRANT       (DHGRANT),
                       .DHREADY       (DHREADY),
                       .DHRESP        (DHRESP[1:0]),
                       .DHRDATA       (DHRDATA[31:0]),
                       .IHCLKEN       (IHCLKEN),
                       .IHGRANT       (IHGRANT),
                       .IHREADY       (IHREADY),
                       .IHRESP        (IHRESP[1:0]),
                       .IHRDATA       (IHRDATA[31:0]),
                       .CPDIN         (CPDIN[31:0]),
                       .CHSDE         (CHSDE[1:0]),
                       .CHSEX         (CHSEX[1:0]),
                       .CPBURST       (CPBURST[3:0]),
                       .CPEN          (CPEN),
                       .DBGEN         (DBGEN),
                       .EDBGRQ        (EDBGRQ),
                       .DBGEXT        (DBGEXT[1:0]),
                       .DBGIEBKPT     (DBGIEBKPT),
                       .DBGDEWPT      (DBGDEWPT),
                       .DBGnTRST      (DBGnTRST),
                       .DBGTCKEN      (DBGTCKEN),
                       .DBGTDI        (DBGTDI),
                       .DBGTMS        (DBGTMS),
                       .DBGSDOUT      (DBGSDOUT),
                       .ETMEN         (ETMEN),
                       .FIFOFULL      (FIFOFULL),
                       .DRRD          (DRRD[31:0]),
                       .DRWAIT        (DRWAIT),
                       .DRSIZE        (DRSIZE[3:0]),
                       .IRRD          (IRRD[31:0]),
                       .IRWAIT        (IRWAIT),
                       .IRSIZE        (IRSIZE[3:0]),
                       .INITRAM       (INITRAM),
                       .DRDMAEN       (DRDMAEN),
                       .DRDMACS       (DRDMACS),
                       .DRDMAADDR     (DRDMAADDR[17:0]),
                       .IRDMAEN       (IRDMAEN),
                       .IRDMACS       (IRDMACS),
                       .IRDMAADDR     (IRDMAADDR[17:0]),
`ifdef FPGA
                       .DSWITCH       (DSWITCH[7:0]),
`endif
                       .MMUxRD        (MMUxRD[111:0]),
                       .DCBISTEN      (DCBISTEN),
                       .DCBISTA       (DCBISTA[12:0]),
                       .DCBISTTAGCS   (DCBISTTAGCS[3:0]),
                       .DCBISTDATACS  (DCBISTDATACS[3:0]),
                       .DCBISTVALIDCS (DCBISTVALIDCS),
                       .DCBISTDIRTYCS (DCBISTDIRTYCS),
                       .DCTAGRD0      (DCTAGRD0[21:0]),
                       .DCTAGRD1      (DCTAGRD1[21:0]),
                       .DCTAGRD2      (DCTAGRD2[21:0]),
                       .DCTAGRD3      (DCTAGRD3[21:0]),
                       .DCDATARD0     (DCDATARD0[31:0]),
                       .DCDATARD1     (DCDATARD1[31:0]),
                       .DCDATARD2     (DCDATARD2[31:0]),
                       .DCDATARD3     (DCDATARD3[31:0]),
                       .DCVALIDRD     (DCVALIDRD[23:0]),
                       .DCNoRRgen     (DCNoRRgen),
                       .DCDIRTYRD     (DCDIRTYRD[7:0]),
                       .ICBISTEN      (ICBISTEN),
                       .ICBISTA       (ICBISTA[12:0]),
                       .ICBISTTAGCS   (ICBISTTAGCS[3:0]),
                       .ICBISTDATACS  (ICBISTDATACS[3:0]),
                       .ICBISTVALIDCS (ICBISTVALIDCS),
                       .ICTAGRD0      (ICTAGRD0[21:0]),
                       .ICTAGRD1      (ICTAGRD1[21:0]),
                       .ICTAGRD2      (ICTAGRD2[21:0]),
                       .ICTAGRD3      (ICTAGRD3[21:0]),
                       .ICDATARD0     (ICDATARD0[31:0]),
                       .ICDATARD1     (ICDATARD1[31:0]),
                       .ICDATARD2     (ICDATARD2[31:0]),
                       .ICDATARD3     (ICDATARD3[31:0]),
                       .ICVALIDRD     (ICVALIDRD[23:0]),
                       .ICNoRRgen     (ICNoRRgen),
                       .SCANENABLE    (SCANENABLE),
                       .INTEST        (INTEST),
                       .EXTEST        (EXTEST),
                       .TESTMODE      (TESTMODE));

   // When there is no BIST tie off the BIST inputs:
   assign ICBISTA       = 13'b0_0000_0000_0000;
   assign ICBISTDATACS  = 4'h0;
   assign ICBISTEN      = 1'b0;
   assign ICBISTTAGCS   = 4'h0;
   assign ICBISTVALIDCS = 1'b0;

   assign DCBISTA       = 13'b0_0000_0000_0000;
   assign DCBISTDATACS  = 4'h0;
   assign DCBISTEN      = 1'b0;
   assign DCBISTTAGCS   = 4'h0;
   assign DCBISTVALIDCS = 1'b0;
   assign DCBISTDIRTYCS = 1'b0;

   // Cache data ram address busses. Used by rams inserted using
   // automem.
   assign DCDataAddr0 = {DCDATAINDEX[9:0], DCDATAWORDB0[2:0]};
   assign DCDataAddr1 = {DCDATAINDEX[9:0], DCDATAWORDB1[2:0]};
   assign DCDataAddr2 = {DCDATAINDEX[9:0], DCDATAWORDB2[2:0]};
   assign DCDataAddr3 = {DCDATAINDEX[9:0], DCDATAWORDB3[2:0]};
   assign ICDataAddr0 = {ICDATAINDEX[9:0], ICDATAWORDB0[2:0]};
   assign ICDataAddr1 = {ICDATAINDEX[9:0], ICDATAWORDB1[2:0]};
   assign ICDataAddr2 = {ICDATAINDEX[9:0], ICDATAWORDB2[2:0]};
   assign ICDataAddr3 = {ICDATAINDEX[9:0], ICDATAWORDB3[2:0]};

   // Cache size signals:
   // state cache size settings (this line required for automem).

   // The cache size inputs are not tied off here for the validation
   // environment.
   
   // end cache size settings (this line required for automem).

   //
   // Instruction Cache data banks 0 to 3:
   //

   // remove start (this line required for automem).

  // instantiate 'gasket' for producing the correct number of address bits for a
  // given cache size
  a926CacheRamGasket uICGasket(
    .CACHESIZE      (`INSTR_CACHE_SIZE),

    .CTAGAIn        (ICTAGA[10:0]),
    .CDATAINDEXIn   (ICDATAINDEX[9:0]),
    .CDATAWORDB0In  (ICDATAWORDB0[2:0]),
    .CDATAWORDB1In  (ICDATAWORDB1[2:0]),
    .CDATAWORDB2In  (ICDATAWORDB2[2:0]),
    .CDATAWORDB3In  (ICDATAWORDB3[2:0]),
    .CVALIDAIn      (ICVALIDA[7:0]),
    .CDIRTYAIn      ({10{1'b0}}),         // no dirty ram on the I$!!

    .CTAGAOut       (TmpICTagA[10:0]),
    .CDATAA0Out     (TmpICDataA0[12:0]),
    .CDATAA1Out     (TmpICDataA1[12:0]),
    .CDATAA2Out     (TmpICDataA2[12:0]),
    .CDATAA3Out     (TmpICDataA3[12:0]),
    .CVALIDAOut     (TmpICValidA[7:0]),
    .CDIRTYAOut     ()                    // unconnected!!
  );

   // remove end (this line required for automem).

   // start icdata0 instantiation here (this line required for automem).

   // 8KB Instruction Cache:
  DataRam4k uICDataRam0(
    .CLK (CLK),
    .CE  (ICDATACS[0]),
    .WE  (ICDATABYTEWE[3:0]),
    .A   (TmpICDataA0[12:0]),
    .D   (ICDATAWD0[31:0]),
    .Q   (ICDATARD0[31:0])
  );

   // end icdata0 instantiation here (this line required for automem).
   // start icdata1 instantiation here (this line required for automem).

  DataRam4k uICDataRam1(
    .CLK (CLK),
    .CE  (ICDATACS[1]),
    .WE  (ICDATABYTEWE[3:0]),
    .A   (TmpICDataA1[12:0]),
    .D   (ICDATAWD1[31:0]),
    .Q   (ICDATARD1[31:0])
  );

   // end icdata1 instantiation here (this line required for automem).
   // start icdata2 instantiation here (this line required for automem).

  DataRam4k uICDataRam2(
    .CLK (CLK),
    .CE  (ICDATACS[2]),
    .WE  (ICDATABYTEWE[3:0]),
    .A   (TmpICDataA2[12:0]),
    .D   (ICDATAWD2[31:0]),
    .Q   (ICDATARD2[31:0])
  );

   // end icdata2 instantiation here (this line required for automem).
   // start icdata3 instantiation here (this line required for automem).

  DataRam4k uICDataRam3(
    .CLK (CLK),
    .CE  (ICDATACS[3]),
    .WE  (ICDATABYTEWE[3:0]),
    .A   (TmpICDataA3[12:0]),
    .D   (ICDATAWD3[31:0]),
    .Q   (ICDATARD3[31:0])
  );

   // end icdata3 instantiation here (this line required for automem).

   //
   // Instruction Cache tag:
   //
  
  // start ictag instantiation here (this line required for automem).

  TagRam4k uICTagRam0(
    .CLK (CLK),
    .CE  (ICTAGCS[0]),
    .WE  (ICTAGWE[0]),
    .A   (TmpICTagA[10:0]),
    .D   (ICTAGWD[21:0]),
    .Q   (ICTAGRD0[21:0])
  );

  TagRam4k uICTagRam1(
    .CLK (CLK),
    .CE  (ICTAGCS[1]),
    .WE  (ICTAGWE[1]),
    .A   (TmpICTagA[10:0]),
    .D   (ICTAGWD[21:0]),
    .Q   (ICTAGRD1[21:0])
  );

  TagRam4k uICTagRam2(
    .CLK (CLK),
    .CE  (ICTAGCS[2]),
    .WE  (ICTAGWE[2]),
    .A   (TmpICTagA[10:0]),
    .D   (ICTAGWD[21:0]),
    .Q   (ICTAGRD2[21:0])
  );

  TagRam4k uICTagRam3(
    .CLK (CLK),
    .CE  (ICTAGCS[3]),
    .WE  (ICTAGWE[3]),
    .A   (TmpICTagA[10:0]),
    .D   (ICTAGWD[21:0]),
    .Q   (ICTAGRD3[21:0])
  );

   // end ictag instantiation here (this line required for automem).
   
   //
   // Instruction Cache valid Ram:
   //
  
  // start icvalid instantiation here (this line required for automem).

  // Use Round-Robin bits:
  assign ICNoRRgen = 1'b0;

  ValidRam4k uICValidRam(
    .CLK (CLK),
    .CE  (ICVALIDCS),
    .WE  (ICVALIDWE),
    .A   (TmpICValidA[7:0]),
    .D   (ICVALIDWD[23:0]),
    .Q   (ICVALIDRD[23:0])
  );

  // end icvalid instantiation here (this line required for automem).

  //
  // Data Cache data banks 0 to 3:
  //

   // remove start (this line required for automem).

  // instantiate 'gasket' for producing the correct number of address bits for a
  // given cache size
  a926CacheRamGasket uDCGasket(
    .CACHESIZE      (`DATA_CACHE_SIZE),

    .CTAGAIn        (DCTAGA[10:0]),
    .CDATAINDEXIn   (DCDATAINDEX[9:0]),
    .CDATAWORDB0In  (DCDATAWORDB0[2:0]),
    .CDATAWORDB1In  (DCDATAWORDB1[2:0]),
    .CDATAWORDB2In  (DCDATAWORDB2[2:0]),
    .CDATAWORDB3In  (DCDATAWORDB3[2:0]),
    .CVALIDAIn      (DCVALIDA[7:0]),
    .CDIRTYAIn      (DCDIRTYA[9:0]),

    .CTAGAOut       (TmpDCTagA[10:0]),
    .CDATAA0Out     (TmpDCDataA0[12:0]),
    .CDATAA1Out     (TmpDCDataA1[12:0]),
    .CDATAA2Out     (TmpDCDataA2[12:0]),
    .CDATAA3Out     (TmpDCDataA3[12:0]),
    .CVALIDAOut     (TmpDCValidA[7:0]),
    .CDIRTYAOut     (TmpDCDirtyA[9:0])
  );

   // remove end (this line required for automem).

  // start dcdata0 instantiation here (this line required for automem).

  // ? KB Data Cache:
  DataRam4k uDCDataRam0(
    .CLK (CLK),
    .CE  (DCDATACS[0]),
    .WE  (DCDATABYTEWE[3:0]),
    .A   (TmpDCDataA0[12:0]),
    .D   (DCDATAWD0[31:0]),
    .Q   (DCDATARD0[31:0])
  );

   // end dcdata0 instantiation here (this line required for automem).
   // start dcdata1 instantiation here (this line required for automem).

  DataRam4k uDCDataRam1(
    .CLK (CLK),
    .CE  (DCDATACS[1]),
    .WE  (DCDATABYTEWE[3:0]),
    .A   (TmpDCDataA1[12:0]),
    .D   (DCDATAWD1[31:0]),
    .Q   (DCDATARD1[31:0])
  );

   // end dcdata1 instantiation here (this line required for automem).
   // start dcdata2 instantiation here (this line required for automem).

  DataRam4k uDCDataRam2(
    .CLK (CLK),
    .CE  (DCDATACS[2]),
    .WE  (DCDATABYTEWE[3:0]),
    .A   (TmpDCDataA2[12:0]),
    .D   (DCDATAWD2[31:0]),
    .Q   (DCDATARD2[31:0])
  );

   // end dcdata2 instantiation here (this line required for automem).
   // start dcdata3 instantiation here (this line required for automem).

  DataRam4k uDCDataRam3(
    .CLK (CLK),
    .CE  (DCDATACS[3]),
    .WE  (DCDATABYTEWE[3:0]),
    .A   (TmpDCDataA3[12:0]),
    .D   (DCDATAWD3[31:0]),
    .Q   (DCDATARD3[31:0])
  );

  // end dcdata3 instantiation here (this line required for automem).
  
  //
  // Data Cache tag:
  //
   
  // start dctag instantiation here (this line required for automem).

  TagRam4k uDCTagRam0(
    .CLK (CLK),
    .CE  (DCTAGCS[0]),
    .WE  (DCTAGWE[0]),
    .A   (TmpDCTagA[10:0]),
    .D   (DCTAGWD[21:0]),
    .Q   (DCTAGRD0[21:0])
  );

  TagRam4k uDCTagRam1(
    .CLK (CLK),
    .CE  (DCTAGCS[1]),
    .WE  (DCTAGWE[1]),
    .A   (TmpDCTagA[10:0]),
    .D   (DCTAGWD[21:0]),
    .Q   (DCTAGRD1[21:0])
  );

  TagRam4k uDCTagRam2(
    .CLK (CLK),
    .CE  (DCTAGCS[2]),
    .WE  (DCTAGWE[2]),
    .A   (TmpDCTagA[10:0]),
    .D   (DCTAGWD[21:0]),
    .Q   (DCTAGRD2[21:0])
  );

  TagRam4k uDCTagRam3(
    .CLK (CLK),
    .CE  (DCTAGCS[3]),
    .WE  (DCTAGWE[3]),
    .A   (TmpDCTagA[10:0]),
    .D   (DCTAGWD[21:0]),
    .Q   (DCTAGRD3[21:0])
  );

  // end dctag instantiation here (this line required for automem).
  
  //
  // Data Cache valid Ram:
  //

  // start dcvalid instantiation here (this line required for automem).

  // Use Round-Robin bits:
  assign DCNoRRgen = 1'b0;

  ValidRam4k uDCValidRam(
    .CLK (CLK),
    .CE  (DCVALIDCS),
    .WE  (DCVALIDWE),
    .A   (TmpDCValidA[7:0]),
    .D   (DCVALIDWD[23:0]),
    .Q   (DCVALIDRD[23:0])
  );

  // end dcvalid instantiation here (this line required for automem).

  //
  // Data Dirty Ram:
  //
  
  // start dcdirty instantiation here (this line required for automem).

  DirtyRam4k uDCDirtyRam(
    .CLK (CLK),
    .CE  (DCDIRTYCS),
    .WE  (DCDIRTYWE[7:0]),
    .A   (TmpDCDirtyA[9:0]),
    .D   (DCDIRTYWD[7:0]),
    .Q   (DCDIRTYRD[7:0])
  );

   // end dcdirty instantiation here (this line required for automem).


   //
   // MMU Ram:
   //

   // start mmu instantiation here (this line required for automem).

   a926ejsMRAM uTLBRAM (//Outputs:
                       .MMUxRD   (MMUxRD[111:0]),
                       //Inputs:
                       .MMUxADDR (MMUxADDR[4:0]),
                       .MMUxWD   (MMUxWD[111:0]),
                       .MMUxCS   (MMUxCS),
                       .MMUxWE   (MMUxWE[3:0]),
                       .MMUClk   (CLK));

   // end mmu instantiation here (this line required for automem).

endmodule // ARM926EJS

