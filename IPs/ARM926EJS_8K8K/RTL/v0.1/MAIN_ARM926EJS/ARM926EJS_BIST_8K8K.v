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
// File Name           : ARM926EJS_BIST.v,v
// File Revision       : 1.5
//
// Release Information : ARM926EJS_r0p5-00rel0
// -------------------------------------------------------------------------


`timescale 1 ns / 10 ps

`include "ARM926EJS.vh" 

module ARM926EJS (
   // Outputs
  STANDBYWFI, CFGBIGEND, DHADDR, DHTRANS, DHBURST, DHWRITE, DHSIZE, 
  DHBL, DHPROT, DHWDATA, DHBUSREQ, DHLOCK, IHADDR, IHTRANS, IHBURST, 
  IHWRITE, IHSIZE, IHPROT, IHBUSREQ, IHLOCK, CPCLKEN, CPINSTR, 
  CPDOUT, CPPASS, CPLATECANCEL, nCPINSTRVALID, nCPMREQ, nCPTRANS, 
  CPABORT, COMMRX, COMMTX, DBGACK, DBGRQI, DBGINSTREXEC, DBGRNG, 
  DBGTDO, DBGIR, DBGSCREG, DBGTAPSM, DBGnTDOEN, DBGSDIN, ETMBIGEND, 
  ETMHIVECS, ETMIA, ETMInMREQ, ETMISEQ, ETMITBIT, ETMIJBIT, 
  ETMZIFIRST, ETMZILAST, ETMIABORT, ETMDA, ETMDMAS, ETMDMORE, 
  ETMDnMREQ, ETMDnRW, ETMDSEQ, ETMRDATA, ETMDABORT, ETMWDATA, 
  ETMnWAIT, ETMDBGACK, ETMINSTREXEC, ETMRNGOUT, ETMID31To25, 
  ETMID15To11, ETMCHSD, ETMCHSE, ETMPASS, ETMLATECANCEL, ETMPROCID, 
  ETMPROCIDWR, ETMINSTRVALID, DRnRW, DRADDR, DRWD, DRIDLE, DRCS, 
  DRWBL, DRSEQ, IRnRW, IRADDR, IRWD, IRIDLE, IRCS, IRWBL, IRSEQ, 


   // Inputs
  CLK, nFIQ, nIRQ, VINITHI, BIGENDINIT, TAPID, HRESETn, DHCLKEN, DHGRANT, 
  DHREADY, DHRESP, DHRDATA, IHCLKEN, IHGRANT, IHREADY, IHRESP, 
  IHRDATA, CPDIN, CHSDE, CHSEX, CPBURST, CPEN, DBGEN, EDBGRQ, DBGEXT, 
  DBGIEBKPT, DBGDEWPT, DBGnTRST, DBGTCKEN, DBGTDI, DBGTMS, DBGSDOUT, 
  ETMEN, FIFOFULL, DRRD, DRWAIT, DRSIZE, IRRD, IRWAIT, IRSIZE, 
  INITRAM,DRDMAEN,DRDMACS,DRDMAADDR,IRDMAEN,IRDMACS,IRDMAADDR,


  // ATPG:
  SCANENABLE, INTEST, EXTEST, TESTMODE

  );
  
  
   // FPGA debug


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

   // Extra BIST signals:
   wire              DCBISTWE; // Via BIST wrapper.
   wire [31:0]       DCBISTWD; // Via BIST wrapper.
   wire              ICBISTWE; // Via BIST wrapper.
   wire [31:0]       ICBISTWD; // Via BIST wrapper.
   wire              MMUBISTWE; // Via BIST wrapper.
   wire [31:0]       MMUBISTWD; // Via BIST wrapper.

   // BIST control:
   wire [13:0]       BISTEnable;
   wire [27:0]       BISTStatus;
   wire              BISTStart;

   // BIST Failure signals:
   wire              FailDCData0;
   wire              FailDCData1;
   wire              FailDCData2;
   wire              FailDCData3;
   wire              FailDCDirty;
   wire              FailDCTag0;
   wire              FailDCTag1;
   wire              FailDCTag2;
   wire              FailDCTag3;
   wire              FailDCValid;
   wire              FailICData0;
   wire              FailICData1;
   wire              FailICData2;
   wire              FailICData3;
   wire              FailICTag0;
   wire              FailICTag1;
   wire              FailICTag2;
   wire              FailICTag3;
   wire              FailICValid;
   wire              FailMMU;
   
   // Ram signals for BIST:
   wire [3:0]        DCDATACombWE;
   wire [3:0]        DCTAGCombWE;
   wire              DCVALIDCombWE;
   wire [7:0]        DCDIRTYCombWE;
   wire [31:0]       DCDATACombWD0;
   wire [31:0]       DCDATACombWD1;
   wire [31:0]       DCDATACombWD2;
   wire [31:0]       DCDATACombWD3;
   wire [21:0]       DCTAGCombWD;
   wire [23:0]       DCVALIDCombWD;
   wire [7:0]        DCDIRTYCombWD;
   wire [3:0]        ICDATACombWE;
   wire [3:0]        ICTAGCombWE;
   wire              ICVALIDCombWE;
   wire [31:0]       ICDATACombWD0;
   wire [31:0]       ICDATACombWD1;
   wire [31:0]       ICDATACombWD2;
   wire [31:0]       ICDATACombWD3;
   wire [21:0]       ICTAGCombWD;
   wire [23:0]       ICVALIDCombWD;
   wire              MMUCombCS;
   wire [4:0]        MMUCombADDR;
   wire [3:0]        MMUCombWE;
   wire [111:0]      MMUCombWD;

   // Signals for special handling of DCTAGA[10]:
   reg               DCTAGABist10;
   wire              DCTAGCombA10;
   wire [10:0]       DCTAGCombA;

   // Handle MMU BIST
   wire              MMUBISTEN;
   wire              MMUBISTCS;
   wire [4:0]        MMUBISTA;

   // JPAG switching signals:
   wire              SwitchJTAG;
   wire              BISTTDO;
   wire              DBGTDO9EJ;
   wire              BISTTDOEN;
   wire              DBGnTDOEN9EJ;
   wire              BISTTMS;
   wire              DBGTMS9EJ;

   // Logic to switch between the 9ej dbg tap and the BIST tap.
   assign SwitchJTAG = TESTMODE & ~EXTEST;
   assign DBGTDO = SwitchJTAG ? BISTTDO : DBGTDO9EJ;
   assign DBGnTDOEN = SwitchJTAG ? ~BISTTDOEN : DBGnTDOEN9EJ;
   assign BISTTMS = SwitchJTAG & DBGTMS;
   assign DBGTMS9EJ = ~SwitchJTAG & DBGTMS;

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
                       .DBGTDO        (DBGTDO9EJ),
                       .DBGIR         (DBGIR[3:0]),
                       .DBGSCREG      (DBGSCREG[4:0]),
                       .DBGTAPSM      (DBGTAPSM[3:0]),
                       .DBGnTDOEN     (DBGnTDOEN9EJ),
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
                       .DBGTMS        (DBGTMS9EJ),
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

   a926ejsBISTTAP uBistTap (
                         // Outputs
                         .BISTEnable    (BISTEnable[13:0]),
                         .BISTStart     (BISTStart),
                         .TDO           (BISTTDO),
                         .TDOEN         (BISTTDOEN),
                         // Inputs
                         .CLK           (CLK),
                         .HRESETn       (HRESETn),
                         .BISTStatus    (BISTStatus[27:0]),
                         .TCK           (CLK),
                         .TDI           (DBGTDI),
                         .TMS           (BISTTMS),
                         .nTRST         (DBGnTRST));
   
   a926ejsBIST uBist (
                   // Outputs
                   .BISTStatus          (BISTStatus[27:0]),
                   .DCBISTDATACS        (DCBISTDATACS[3:0]),
                   .DCBISTTAGCS         (DCBISTTAGCS),
                   .DCBISTVALIDCS       (DCBISTVALIDCS),
                   .DCBISTDIRTYCS       (DCBISTDIRTYCS),
                   .DCBISTA             (DCBISTA[12:0]),
                   .DCBISTEN            (DCBISTEN),
                   .DCBISTWE            (DCBISTWE),
                   .DCBISTWD            (DCBISTWD[31:0]),
                   .ICBISTDATACS        (ICBISTDATACS[3:0]),
                   .ICBISTTAGCS         (ICBISTTAGCS),
                   .ICBISTVALIDCS       (ICBISTVALIDCS),
                   .ICBISTA             (ICBISTA[12:0]),
                   .ICBISTEN            (ICBISTEN),
                   .ICBISTWE            (ICBISTWE),
                   .ICBISTWD            (ICBISTWD[31:0]),
                   .MMUBISTCS           (MMUBISTCS),
                   .MMUBISTA            (MMUBISTA[4:0]),
                   .MMUBISTEN           (MMUBISTEN),
                   .MMUBISTWE           (MMUBISTWE),
                   .MMUBISTWD           (MMUBISTWD[31:0]),
                   // Inputs
                   .CLK                 (CLK),
                   .HRESETn             (HRESETn),
                   .BISTEnable          (BISTEnable[13:0]),
                   .BISTStart           (BISTStart),
                   .DCACHESIZE          (DCACHESIZE[3:0]),
                   .ICACHESIZE          (ICACHESIZE[3:0]),
                   .FailDCData0         (FailDCData0),
                   .FailDCData1         (FailDCData1),
                   .FailDCData2         (FailDCData2),
                   .FailDCData3         (FailDCData3),
                   .FailDCTag0          (FailDCTag0),
                   .FailDCTag1          (FailDCTag1),
                   .FailDCTag2          (FailDCTag2),
                   .FailDCTag3          (FailDCTag3),
                   .FailDCValid         (FailDCValid),
                   .FailDCDirty         (FailDCDirty),
                   .FailICData0         (FailICData0),
                   .FailICData1         (FailICData1),
                   .FailICData2         (FailICData2),
                   .FailICData3         (FailICData3),
                   .FailICTag0          (FailICTag0),
                   .FailICTag1          (FailICTag1),
                   .FailICTag2          (FailICTag2),
                   .FailICTag3          (FailICTag3),
                   .FailICValid         (FailICValid),
                   .FailMMU             (FailMMU));

   a926ejsBISTComp uBistComp (
                      // Outputs
                      .FailDCData0      (FailDCData0),
                      .FailDCData1      (FailDCData1),
                      .FailDCData2      (FailDCData2),
                      .FailDCData3      (FailDCData3),
                      .FailDCDirty      (FailDCDirty),
                      .FailDCTag0       (FailDCTag0),
                      .FailDCTag1       (FailDCTag1),
                      .FailDCTag2       (FailDCTag2),
                      .FailDCTag3       (FailDCTag3),
                      .FailDCValid      (FailDCValid),
                      .FailICData0      (FailICData0),
                      .FailICData1      (FailICData1),
                      .FailICData2      (FailICData2),
                      .FailICData3      (FailICData3),
                      .FailICTag0       (FailICTag0),
                      .FailICTag1       (FailICTag1),
                      .FailICTag2       (FailICTag2),
                      .FailICTag3       (FailICTag3),
                      .FailICValid      (FailICValid),
                      .FailMMU          (FailMMU),
                      // Inputs
                      .CLK              (CLK),
                      .HRESETn          (HRESETn),
                      .MMUxRD           (MMUxRD[111:0]),
                      .ICDATARD0        (ICDATARD0[31:0]),
                      .ICDATARD1        (ICDATARD1[31:0]),
                      .ICDATARD2        (ICDATARD2[31:0]),
                      .ICDATARD3        (ICDATARD3[31:0]),
                      .ICTAGRD0         (ICTAGRD0[21:0]),
                      .ICTAGRD1         (ICTAGRD1[21:0]),
                      .ICTAGRD2         (ICTAGRD2[21:0]),
                      .ICTAGRD3         (ICTAGRD3[21:0]),
                      .ICVALIDRD        (ICVALIDRD[23:0]),
                      .DCDATARD0        (DCDATARD0[31:0]),
                      .DCDATARD1        (DCDATARD1[31:0]),
                      .DCDATARD2        (DCDATARD2[31:0]),
                      .DCDATARD3        (DCDATARD3[31:0]),
                      .DCTAGRD0         (DCTAGRD0[21:0]),
                      .DCTAGRD1         (DCTAGRD1[21:0]),
                      .DCTAGRD2         (DCTAGRD2[21:0]),
                      .DCTAGRD3         (DCTAGRD3[21:0]),
                      .DCVALIDRD        (DCVALIDRD[23:0]),
                      .DCDIRTYRD        (DCDIRTYRD[7:0]),
                      .DCBISTWD         (DCBISTWD[31:0]),
                      .ICBISTWD         (ICBISTWD[31:0]),
                      .MMUBISTWD        (MMUBISTWD[31:0]),
                      .DCBISTEN         (DCBISTEN),
                      .ICBISTEN         (ICBISTEN),
                      .MMUBISTEN        (MMUBISTEN),
                      .ICNoRRgen        (ICNoRRgen),
                      .DCNoRRgen        (DCNoRRgen));
   // Data Cache BIST:

   // MUX the write enable signals:
   assign DCDATACombWE = DCBISTEN ? {4{DCBISTWE}} : DCDATABYTEWE;
   assign DCTAGCombWE = DCBISTEN ? {4{DCBISTWE}} : DCTAGWE;
   assign DCVALIDCombWE = DCBISTEN ? DCBISTWE : DCVALIDWE;
   assign DCDIRTYCombWE = DCBISTEN ? {8{DCBISTWE}} : DCDIRTYWE;
   // MUX the write data signals:
   assign DCDATACombWD0 = DCBISTEN ? {16{DCBISTWD[1:0]}} : DCDATAWD0;
   assign DCDATACombWD1 = DCBISTEN ? {16{DCBISTWD[1:0]}} : DCDATAWD1;
   assign DCDATACombWD2 = DCBISTEN ? {16{DCBISTWD[1:0]}} : DCDATAWD2;
   assign DCDATACombWD3 = DCBISTEN ? {16{DCBISTWD[1:0]}} : DCDATAWD3;
   assign DCTAGCombWD = DCBISTEN ? {11{DCBISTWD[1:0]}} : DCTAGWD;
   assign DCVALIDCombWD = DCBISTEN ? {12{DCBISTWD[1:0]}} : DCVALIDWD;
   assign DCDIRTYCombWD = DCBISTEN ? {4{DCBISTWD[1:0]}} : DCDIRTYWD;
   // Special handling of the bit 10 of the tag address:
   always @(DCACHESIZE or DCBISTA)
     begin
        case (DCACHESIZE)
          4'b0011: DCTAGABist10 = DCBISTA[5]; // 4K
          4'b0100: DCTAGABist10 = DCBISTA[6]; // 8K
          4'b0101: DCTAGABist10 = DCBISTA[7]; // 16K
          4'b0110: DCTAGABist10 = DCBISTA[8]; // 32K
          4'b0111: DCTAGABist10 = DCBISTA[9]; // 64K
          default: DCTAGABist10 = DCBISTA[10]; // 128K
        endcase
     end
   assign DCTAGCombA10 = DCBISTEN ? DCTAGABist10 : DCTAGA[10];
   assign DCTAGCombA = {DCTAGCombA10, DCTAGA[9:0]};
   
   // Instr Cache BIST:

   // MUX the write enable signals:
   assign ICDATACombWE = ICBISTEN ? {4{ICBISTWE}} : ICDATABYTEWE;
   assign ICTAGCombWE = ICBISTEN ? {4{ICBISTWE}} : ICTAGWE;
   assign ICVALIDCombWE = ICBISTEN ? ICBISTWE : ICVALIDWE;

   // MUX the write data signals:
   assign ICDATACombWD0 = ICBISTEN ? {16{ICBISTWD[1:0]}} : ICDATAWD0;
   assign ICDATACombWD1 = ICBISTEN ? {16{ICBISTWD[1:0]}} : ICDATAWD1;
   assign ICDATACombWD2 = ICBISTEN ? {16{ICBISTWD[1:0]}} : ICDATAWD2;
   assign ICDATACombWD3 = ICBISTEN ? {16{ICBISTWD[1:0]}} : ICDATAWD3;
   assign ICTAGCombWD = ICBISTEN ? {11{ICBISTWD[1:0]}} : ICTAGWD;
   assign ICVALIDCombWD = ICBISTEN ? {12{ICBISTWD[1:0]}} : ICVALIDWD;

   // MMU BIST:

   // MUX BIST signals:
   assign MMUCombCS = MMUBISTEN ? MMUBISTCS : MMUxCS;
   assign MMUCombADDR = MMUBISTEN ? MMUBISTA : MMUxADDR;
   assign MMUCombWE = MMUBISTEN ? {4{MMUBISTWE}} : MMUxWE;
   assign MMUCombWD = MMUBISTEN ? {56{MMUBISTWD[1:0]}} : MMUxWD;
   
   // Cache size signals:
   // state cache size settings (this line required for automem).
   assign DCACHESIZE = 4'b0100;
   assign ICACHESIZE = 4'b0100;
   // end cache size settings (this line required for automem).

   //
   // Instruction Cache data banks 0 to 3:
   //


   // start icdata0 instantiation here (this line required for automem).

   IDataRam8k uICData0 (
      .CLK     (CLK),
      .CE      (ICDATACS[0]),
      .A       (ICDataAddr0[8:0]),
      .Q       (ICDATARD0[31:0]),
      .D       (ICDATAWD0[31:0]),
      .WE      ((|ICDATABYTEWE[3:0]))
   );

   // end icdata0 instantiation here (this line required for automem).
   // start icdata1 instantiation here (this line required for automem).

   IDataRam8k uICData1 (
      .CLK     (CLK),
      .CE      (ICDATACS[1]),
      .A       (ICDataAddr1[8:0]),
      .Q       (ICDATARD1[31:0]),
      .D       (ICDATAWD1[31:0]),
      .WE      ((|ICDATABYTEWE[3:0]))
   );

   // end icdata1 instantiation here (this line required for automem).
   // start icdata2 instantiation here (this line required for automem).

   IDataRam8k uICData2 (
      .CLK     (CLK),
      .CE      (ICDATACS[2]),
      .A       (ICDataAddr2[8:0]),
      .Q       (ICDATARD2[31:0]),
      .D       (ICDATAWD2[31:0]),
      .WE      ((|ICDATABYTEWE[3:0]))
   );

   // end icdata2 instantiation here (this line required for automem).
   // start icdata3 instantiation here (this line required for automem).

   IDataRam8k uICData3 (
      .CLK     (CLK),
      .CE      (ICDATACS[3]),
      .A       (ICDataAddr3[8:0]),
      .Q       (ICDATARD3[31:0]),
      .D       (ICDATAWD3[31:0]),
      .WE      ((|ICDATABYTEWE[3:0]))
   );

   // end icdata3 instantiation here (this line required for automem).

   //
   // Instruction Cache tag:
   //
  
  // start ictag instantiation here (this line required for automem).

   ITagRam8k uICTag0 (
      .CLK     (CLK),
      .CE      (ICTAGCS[0]),
      .A       (ICTAGA[5:0]),
      .Q       (ICTAGRD0[21:0]),
      .D       (ICTAGWD[21:0]),
      .WE      (ICTAGWE[0])
   );

   ITagRam8k uICTag1 (
      .CLK     (CLK),
      .CE      (ICTAGCS[1]),
      .A       (ICTAGA[5:0]),
      .Q       (ICTAGRD1[21:0]),
      .D       (ICTAGWD[21:0]),
      .WE      (ICTAGWE[1])
   );

   ITagRam8k uICTag2 (
      .CLK     (CLK),
      .CE      (ICTAGCS[2]),
      .A       (ICTAGA[5:0]),
      .Q       (ICTAGRD2[21:0]),
      .D       (ICTAGWD[21:0]),
      .WE      (ICTAGWE[2])
   );

   ITagRam8k uICTag3 (
      .CLK     (CLK),
      .CE      (ICTAGCS[3]),
      .A       (ICTAGA[5:0]),
      .Q       (ICTAGRD3[21:0]),
      .D       (ICTAGWD[21:0]),
      .WE      (ICTAGWE[3])
   );

   // end ictag instantiation here (this line required for automem).
   
   //
   // Instruction Cache valid Ram:
   //
  
  // start icvalid instantiation here (this line required for automem).

   assign ICNoRRgen = 1'b0;

   ValidRam8k uICValid (
      .CLK     (CLK),
      .CE      (ICVALIDCS),
      .A       (ICVALIDA[3:0]),
      .Q       (ICVALIDRD[23:0]),
      .D       (ICVALIDWD[23:0]),
      .WE      (ICVALIDWE)
   );

  // end icvalid instantiation here (this line required for automem).

  //
  // Data Cache data banks 0 to 3:
  //


  // start dcdata0 instantiation here (this line required for automem).

   DDataRam8k uDCData0 (
      .CLK     (CLK),
      .CE      (DCDATACS[0]),
      .A       (DCDataAddr0[8:0]),
      .Q       (DCDATARD0[31:0]),
      .D       (DCDATAWD0[31:0]),
      .WE      (DCDATABYTEWE[3:0])
   );

   // end dcdata0 instantiation here (this line required for automem).
   // start dcdata1 instantiation here (this line required for automem).

   DDataRam8k uDCData1 (
      .CLK     (CLK),
      .CE      (DCDATACS[1]),
      .A       (DCDataAddr1[8:0]),
      .Q       (DCDATARD1[31:0]),
      .D       (DCDATAWD1[31:0]),
      .WE      (DCDATABYTEWE[3:0])
   );

   // end dcdata1 instantiation here (this line required for automem).
   // start dcdata2 instantiation here (this line required for automem).

   DDataRam8k uDCData2 (
      .CLK     (CLK),
      .CE      (DCDATACS[2]),
      .A       (DCDataAddr2[8:0]),
      .Q       (DCDATARD2[31:0]),
      .D       (DCDATAWD2[31:0]),
      .WE      (DCDATABYTEWE[3:0])
   );

   // end dcdata2 instantiation here (this line required for automem).
   // start dcdata3 instantiation here (this line required for automem).

   DDataRam8k uDCData3 (
      .CLK     (CLK),
      .CE      (DCDATACS[3]),
      .A       (DCDataAddr3[8:0]),
      .Q       (DCDATARD3[31:0]),
      .D       (DCDATAWD3[31:0]),
      .WE      (DCDATABYTEWE[3:0])
   );

  // end dcdata3 instantiation here (this line required for automem).
  
  //
  // Data Cache tag:
  //
   
  // start dctag instantiation here (this line required for automem).

   wire [6:0]   DCTagAddr;

   assign DCTagAddr = {DCTAGA[10], DCTAGA[5:0]};

   DTagRam8k uDCTag0 (
      .CLK     (CLK),
      .CE      (DCTAGCS[0]),
      .A       (DCTagAddr[6:0]),
      .Q       (DCTAGRD0[21:0]),
      .D       (DCTAGWD[21:0]),
      .WE      (DCTAGWE[0])
   );

   DTagRam8k uDCTag1 (
      .CLK     (CLK),
      .CE      (DCTAGCS[1]),
      .A       (DCTagAddr[6:0]),
      .Q       (DCTAGRD1[21:0]),
      .D       (DCTAGWD[21:0]),
      .WE      (DCTAGWE[1])
   );

   DTagRam8k uDCTag2 (
      .CLK     (CLK),
      .CE      (DCTAGCS[2]),
      .A       (DCTagAddr[6:0]),
      .Q       (DCTAGRD2[21:0]),
      .D       (DCTAGWD[21:0]),
      .WE      (DCTAGWE[2])
   );

   DTagRam8k uDCTag3 (
      .CLK     (CLK),
      .CE      (DCTAGCS[3]),
      .A       (DCTagAddr[6:0]),
      .Q       (DCTAGRD3[21:0]),
      .D       (DCTAGWD[21:0]),
      .WE      (DCTAGWE[3])
   );

  // end dctag instantiation here (this line required for automem).
  
  //
  // Data Cache valid Ram:
  //

  // start dcvalid instantiation here (this line required for automem).

   assign DCNoRRgen = 1'b0;

   ValidRam8k uDCValid (
      .CLK     (CLK),
      .CE      (DCVALIDCS),
      .A       (DCVALIDA[3:0]),
      .Q       (DCVALIDRD[23:0]),
      .D       (DCVALIDWD[23:0]),
      .WE      (DCVALIDWE)
   );

  // end dcvalid instantiation here (this line required for automem).

  //
  // Data Dirty Ram:
  //
  
  // start dcdirty instantiation here (this line required for automem).

   DirtyRam8k uDCDirty (
      .CLK     (CLK),
      .CE      (DCDIRTYCS),
      .A       (DCDIRTYA[5:0]),
      .Q       (DCDIRTYRD[7:0]),
      .D       (DCDIRTYWD[7:0]),
      .WE      (DCDIRTYWE[7:0])
   );

   // end dcdirty instantiation here (this line required for automem).


   //
   // MMU Ram:
   //

   // start mmu instantiation here (this line required for automem).

   MMURam30 uMMU3 (
      .CLK     (CLK),
      .CS      (MMUxCS),
      .ADDR    (MMUxADDR[4:0]),
      .DATAOUT (MMUxRD[29:0]),
      .DATAIN  (MMUxWD[29:0]),
      .WE      (MMUxWE[0]),
      .OE      (1'b1)
   );

   MMURam26 uMMU2db0 (
      .CLK     (CLK),
      .CS      (MMUxCS),
      .ADDR    (MMUxADDR[4:0]),
      .DATAOUT (MMUxRD[55:30]),
      .DATAIN  ({1'd0, MMUxWD[55:30]}),
      .WE      (MMUxWE[1]),
      .OE      (1'b1)
   );

   MMURam30 uMMU1 (
      .CLK     (CLK),
      .CS      (MMUxCS),
      .ADDR    (MMUxADDR[4:0]),
      .DATAOUT (MMUxRD[85:56]),
      .DATAIN  (MMUxWD[85:56]),
      .WE      (MMUxWE[2]),
      .OE      (1'b1)
   );

   MMURam26 uMMU0db0 (
      .CLK     (CLK),
      .CS      (MMUxCS),
      .ADDR    (MMUxADDR[4:0]),
      .DATAOUT (MMUxRD[111:86]),
      .DATAIN  ({1'd0, MMUxWD[111:86]}),
      .WE      (MMUxWE[3]),
      .OE      (1'b1)
   );

   // end mmu instantiation here (this line required for automem).

endmodule // ARM926EJS

