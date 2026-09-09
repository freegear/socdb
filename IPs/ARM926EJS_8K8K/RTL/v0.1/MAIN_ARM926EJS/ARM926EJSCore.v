//-------------------------------------------------------------------------
//  The confidential and proprietary information contained in this file may
//  only be used by a person authorised under and to the extent permitted
//  by a subsisting licensing agreement from ARM Limited.
//
//
//         (C) COPYRIGHT 2003 ARM Limited.
//             ALL RIGHTS RESERVED
//
//  This entire notice must be reproduced on all copies of this file
//  and copies of this file may only be made by a person if such person is
//  permitted to do so under the terms of a subsisting license agreement
//  from ARM Limited.
//
// Filename   : ARM926EJSCore.v,v
// Date       : 2003/10/01 16:37:27
// Revision   : 1.61
// Release Information : ARM926EJS_r0p5-00rel0 
//
//-------------------------------------------------------------------------

`timescale 1 ns / 10 ps

`include "ARM926EJS.vh"

module ARM926EJSCore (

   // ARM926EJ-S macrocell outputs
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

   // ARM926EJ-S macrocell inputs
  CLK, nFIQ, nIRQ, VINITHI, BIGENDINIT, TAPID, HRESETn, DHCLKEN, DHGRANT, 
  DHREADY, DHRESP, DHRDATA, IHCLKEN, IHGRANT, IHREADY, IHRESP, 
  IHRDATA, CPDIN, CHSDE, CHSEX, CPBURST, CPEN, DBGEN, EDBGRQ, DBGEXT, 
  DBGIEBKPT, DBGDEWPT, DBGnTRST, DBGTCKEN, DBGTDI, DBGTMS, DBGSDOUT, 
  ETMEN, FIFOFULL, DRRD, DRWAIT, DRSIZE, IRRD, IRWAIT, IRSIZE, 
  INITRAM,DRDMAEN,DRDMACS,DRDMAADDR,IRDMAEN,IRDMACS,IRDMAADDR,


 

   // FPGA debug outputs
`ifdef FPGA
  DBG0,DBG1,DSWITCH,
`endif

   // MMU RAM interface

  MMUxADDR,MMUxWD,MMUxCS,MMUxWE,MMUxRD,

   // DCACHE RAM interface

 DCACHESIZE,
 DCTAGCS,
 DCTAGA,DCTAGWE,DCTAGRD0,DCTAGRD1,DCTAGRD2,DCTAGRD3,DCTAGWD,DCDATACS,DCDATAINDEX,
 DCDATAWORDB0,DCDATAWORDB1,DCDATAWORDB2,DCDATAWORDB3,DCDATABYTEWE,DCDATARD0,
 DCDATARD1,DCDATARD2,DCDATARD3,DCDATAWD0,DCDATAWD1,DCDATAWD2,DCDATAWD3,DCVALIDCS,
 DCVALIDA,DCVALIDWE,DCVALIDRD,DCVALIDWD,DCNoRRgen,DCDIRTYCS,DCDIRTYA,DCDIRTYWE,
 DCDIRTYRD,DCDIRTYWD,

 DCBISTEN,DCBISTA,DCBISTTAGCS,DCBISTDATACS,DCBISTVALIDCS,DCBISTDIRTYCS,

   // ICACHE RAM interface

 ICACHESIZE,
 ICTAGCS,
 ICTAGA,ICTAGWE,ICTAGRD0,ICTAGRD1,ICTAGRD2,ICTAGRD3,ICTAGWD,ICDATACS,ICDATAINDEX,
 ICDATAWORDB0,ICDATAWORDB1,ICDATAWORDB2,ICDATAWORDB3,ICDATABYTEWE,ICDATARD0,
 ICDATARD1,ICDATARD2,ICDATARD3,ICDATAWD0,ICDATAWD1,ICDATAWD2,ICDATAWD3,ICVALIDCS,
 ICVALIDA,ICVALIDWE,ICVALIDRD,ICVALIDWD,ICNoRRgen,

 ICBISTEN,ICBISTA,ICBISTTAGCS,ICBISTDATACS,ICBISTVALIDCS,

 SCANENABLE, INTEST, EXTEST, TESTMODE

  );
  
  
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

`ifdef FPGA
   output [33:0]     DBG0;       // FPGA debug output
   output [33:0]     DBG1;       // FPGA debug output
   input [7:0]       DSWITCH;    // FPGA debug input (from DIP switches)
`endif

   // MMU RAM interface

   output [4:0]      MMUxADDR;  // address
   output [111:0]    MMUxWD;    // write data
   output            MMUxCS;    // chip select
   output [3:0]      MMUxWE;    // write enable
   input [111:0]     MMUxRD;    // read data
 

   // Data cache RAM interface

   input             [ 3: 0] DCACHESIZE;
 
   // BIST signals
   input             DCBISTEN;
   input             [12: 0] DCBISTA;           // address for access (WAY + index)
   input             [ 3: 0] DCBISTTAGCS;
   input             [ 3: 0] DCBISTDATACS;
   input             DCBISTVALIDCS;
   input             DCBISTDIRTYCS;

   // TAG ram
   output            [ 3: 0] DCTAGCS;
   output            [10: 0] DCTAGA;            // maximum #bits for NSETS
   output            [ 3: 0] DCTAGWE;
   input             [21: 0] DCTAGRD0;          // tag data from way 0
   input             [21: 0] DCTAGRD1;          // tag data from way 1
   input             [21: 0] DCTAGRD2;          // tag data from way 2
   input             [21: 0] DCTAGRD3;          // tag data from way 3
   output            [21: 0] DCTAGWD;           // maximum #bits for tag
 
   // DATA ram
   output            [ 3: 0] DCDATACS;
   output            [ 9: 0] DCDATAINDEX;       // index for data access (max #bits)
   output            [ 2: 0] DCDATAWORDB0;      // word selects for a line in bank 0
   output            [ 2: 0] DCDATAWORDB1;      // word selects for a line in bank 1
   output            [ 2: 0] DCDATAWORDB2;      // word selects for a line in bank 2
   output            [ 2: 0] DCDATAWORDB3;      // word selects for a line in bank 3
   output            [ 3: 0] DCDATABYTEWE;
   input             [31: 0] DCDATARD0;         // data from bank 0
   input             [31: 0] DCDATARD1;         // data from bank 1
   input             [31: 0] DCDATARD2;         // data from bank 2
   input             [31: 0] DCDATARD3;         // data from bank 3
   output            [31: 0] DCDATAWD0;         // data to bank 0
   output            [31: 0] DCDATAWD1;         // data to bank 1
   output            [31: 0] DCDATAWD2;         // data to bank 2
   output            [31: 0] DCDATAWD3;         // data to bank 3

   // VALID ram
   output                    DCVALIDCS;
   output            [ 7: 0] DCVALIDA;          // address to valid RAM
   output                    DCVALIDWE;         // 16 valid, 8 rrgen
   input             [23: 0] DCVALIDRD;         // 16 valid, 8 rrgen
   output            [23: 0] DCVALIDWD;         // 16 valid, 8 rrgen
   input                     DCNoRRgen;

   // DIRTY ram
   output                    DCDIRTYCS;
   output            [ 9: 0] DCDIRTYA;          // address to dirty RAM
   output            [ 7: 0] DCDIRTYWE;
   input             [ 7: 0] DCDIRTYRD;
   output            [ 7: 0] DCDIRTYWD;


   // Instruction cache RAM interface

   input             [ 3: 0] ICACHESIZE;
 
   // BIST signals

   input                     ICBISTEN;
   input             [12: 0] ICBISTA;           // address for access (WAY + index)
   input             [ 3: 0] ICBISTTAGCS;
   input             [ 3: 0] ICBISTDATACS;
   input                     ICBISTVALIDCS;

   // TAG ram
   output            [ 3: 0] ICTAGCS;
   output            [10: 0] ICTAGA;            // maximum #bits for NSETS
   output            [ 3: 0] ICTAGWE;
   input             [21: 0] ICTAGRD0;          // tag data from way 0
   input             [21: 0] ICTAGRD1;          // tag data from way 1
   input             [21: 0] ICTAGRD2;          // tag data from way 2
   input             [21: 0] ICTAGRD3;          // tag data from way 3
   output            [21: 0] ICTAGWD;           // maximum #bits for tag
 
   // DATA ram
   output            [ 3: 0] ICDATACS;
   output            [ 9: 0] ICDATAINDEX;       // index for data access (max #bits)
   output            [ 2: 0] ICDATAWORDB0;      // word selects for a line in bank 0
   output            [ 2: 0] ICDATAWORDB1;      // word selects for a line in bank 1
   output            [ 2: 0] ICDATAWORDB2;      // word selects for a line in bank 2
   output            [ 2: 0] ICDATAWORDB3;      // word selects for a line in bank 3
   output            [ 3: 0] ICDATABYTEWE;
   input             [31: 0] ICDATARD0;         // data from bank 0
   input             [31: 0] ICDATARD1;         // data from bank 1
   input             [31: 0] ICDATARD2;         // data from bank 2
   input             [31: 0] ICDATARD3;         // data from bank 3
   output            [31: 0] ICDATAWD0;         // data to bank 0
   output            [31: 0] ICDATAWD1;         // data to bank 1
   output            [31: 0] ICDATAWD2;         // data to bank 2
   output            [31: 0] ICDATAWD3;         // data to bank 3

   // VALID ram
   output            ICVALIDCS;
   output            [ 7: 0] ICVALIDA;          // address to valid RAM
   output                    ICVALIDWE;         // 16 valid, 8 rrgen
   input             [23: 0] ICVALIDRD;         // 16 valid, 8 rrgen
   output            [23: 0] ICVALIDWD;         // 16 valid, 8 rrgen
   input             ICNoRRgen;

   //ATPG
   input             SCANENABLE;
   input             INTEST;
   input             EXTEST;
   input             TESTMODE;
	

   // From uClkBlk to u9EJ
   wire              ARM9Clk;

   // From uClkBlk to ETMIF
   wire              ETMIFClk;

   // From uClkBlk to uCP15
   wire              CP15DebugClk;
   wire              CP15PipeClk;
   wire              DisableBlkClkGate;

   // From uClkBlk to uDExt
   wire              DEXTClk;

   // From uClkBlk to uIExt
   wire              IEXTClk;

   // From uClkBlk to uSysCtl
   wire              CP15DbgClkEn;
   wire              CP15PipeClkEn;
   wire              ARM9ClkEn;
   wire              DCClkEn;
   wire              DEXTClkEn;
   wire              DTCMClkEn;
   wire              ICClkEn;
   wire              IEXTClkEn;
   wire              ITCMClkEn;
   wire              MMUClkEn;
   wire              WFIWakeUp;

   // From uClkBlk to uICache
   wire              ICClk;

   // From uClkBlk to uDCache
   wire              DCClk;

   // From uClkBlk to uMMU
   wire              MMUClk;

   // From uClkBlk to uTCM
   wire              DTCMClk;
   wire              ITCMClk;

   // From uFCSE to uCP15
   wire [31:0]       CP15VA;
   wire              DisableFCSE;
   wire [31:25]      FCSEPID;
   wire              SelCP15VA;

   // From uFCSE to uSysCtl
   wire [9:2]        DAME;
   wire [9:2]        IAFE;
   wire              DVASelDAHeld;
   wire              FCSESampleDA;
   wire              FCSESampleIA;
   wire              IVASelIAHeld;

   // From uFCSE to uICache
   wire [31:0]       IVA;
   wire [31:25]      RawIMVA;

   // From uFCSE to uDCache
   wire [31:0]       DVA;
   wire [31:25]      RawDMVA;

   // From u9EJ to ETMIF
   wire              DBGINSTRVALID;
   wire [31:0]       ETMIAFEraw;
   wire              ETMISEQraw;
   wire              ETMZIFIRSTraw;
   wire              ETMZILASTraw;

   // From u9EJ to uCP15

   wire              DisableLdTBIT;
   wire              HIVECS;
   wire              DBGTDOa9ejs;

   // From u9EJ to uSysCtl
   wire [3:0]        DBURST;


   // From uCP15 to uIExt
   wire              IEXTEnPrefetch;

   // From uCP15 to uSysCtl
   wire              CP15Active;
   wire              CP15DWB;
   wire              CP15IHazard;
   wire              CP15IPrefetch;
   wire              CP15Idle;
   wire              CP15WFI;
   wire [3:0]        CPBURSTEX;
   wire              ForceNCNB;
   wire              LDCinME;
   wire              MCRinME;
   wire              MRCinME;
   wire              STCinME;
   wire              TCFIQNoStall;
   wire              TCIRQNoStall;
   wire              SampleInt;
   wire              CP15CLKEN;
   wire              CP15DWBDone;
   wire              CP15WFIDone;

   // From uCP15 to uDRoute
   wire [31:0]       CP15RD;
   wire [31:0]       CP15WD;

   // From uCP15 to uICache
   wire              ICCP15Req;
   wire              ICNoLineFill;
   wire [3:0]        ICnWayAlloc;
   wire              ICMbit;
   wire [2:0]        ICassoc;
   wire [3:0]        ICsize;

   // From uCP15 to uDCache
   wire              DCCP15Req;
   wire              DCNoLineFill;
   wire [3:0]        DCnWayAlloc;
   wire              DisableWriteback;
   wire              DCDirty;
   wire              DCMbit;
   wire [2:0]        DCassoc;
   wire [3:0]        DCsize;

   // From uCP15 to uMMU
   wire              AbortDTLBMiss;
   wire              AbortITLBMiss;
   wire [31:0]       DBGWD;
   wire              MMUCP15Req;
   wire [10:0]       MMUOp;
   wire              MMUCP15Ready;
   wire [31:0]       MMUREGRD;

   // From uDExt to uBIU
   wire [31:0]       DEXTBIUA;
   wire              DEXTBIUBuff;
   wire [2:0]        DEXTBIUBurst;
   wire              DEXTBIUCacheable;
   wire              DEXTBIULock;
   wire [1:0]        DEXTBIUMAS;
   wire              DEXTBIUPriv;
   wire              DEXTBIUReq;
   wire [31:0]       DEXTBIUWD;
   wire              DEXTBIUnRW;
   wire              DEXTBIUAck;
   wire              DEXTBIUErr;
   wire              DEXTBIUNextWD;
   wire              DEXTBIUReady;

   // From uDExt to uSysCtl
   wire              DEXTBlocked;
   wire              DEXTError;
   wire              DEXTIdle;
   wire              DEXTNoFinish;
   wire              DEXTReady;
   wire [3:0]        DEXTBURST;
   wire              DEXTBuffered;
   wire              DEXTCached;
   wire              DEXTCancel;
   wire [1:0]        DEXTMAS;
   wire              DEXTMREQ;
   wire              DEXTSEQ;
   wire              DEXTSwap;
   wire              DEXTnRW;

   // From uDExt to uDRoute
   wire [31:0]       DEXTRD;
   wire [31:0]       DEXTWD;

   // From uDExt to uDCache
   wire              DontCommit;

   // From uDExt to uDuTLB
   wire              DL2Bufferable;
   wire              DL2Cacheable;

   // From uIExt to uBIU
   wire [31:0]       IEXTBIUA;
   wire [2:0]        IEXTBIUBurst;
   wire              IEXTBIUCacheable;
   wire              IEXTBIUPriv;
   wire              IEXTBIUReq;
   wire              IEXTBIUAck;
   wire              IEXTBIUErr;
   wire              IEXTBIUReady;

   // From uIExt to uSysCtl
   wire              IEXTBlocked;
   wire              IEXTError;
   wire              IEXTIdle;
   wire              IEXTNoFinish;
   wire              IEXTReady;
   wire              IEXTCancel;
   wire              IEXTMREQ;
   wire              IEXTSEQ;

   // From uIExt to uIuTLB
   wire              IL2Cacheable;

   // From uBIU to uSysCtl
   wire              DBIUIdle;
   wire              IBIUIdle;

   // From uBIU to uICache
   wire              ICACHEBIUAck;
   wire              ICACHEBIUReady;
   wire [31:0]       ICACHEBIUA;
   wire [2:0]        ICACHEBIUBurst;
   wire              ICACHEBIUPriv;
   wire              ICACHEBIUReq;
   wire              ICACHEBIUEarlyReq;
   wire              ICACHEBIUWrap;

   // From uBIU to uDCache
   wire              DCACHEBIUAck;
   wire              DCACHEBIUNextWD;
   wire              DCACHEBIUReady;
   wire [31:0]       DCACHEBIUA;
   wire [2:0]        DCACHEBIUBurst;
   wire              DCACHEBIUPriv;
   wire              DCACHEBIUReq;
   wire              DCACHEBIUEarlyReq;
   wire [31:0]       DCACHEBIUWD;
   wire              DCACHEBIUWrap;
   wire              DCACHEBIUnRW;

   // From uBIU to uMMU
   wire              MMUBIUAck;
   wire              MMUBIUErr;
   wire              MMUBIUReady;
   wire [31:0]       MMUBIUA;
   wire              MMUBIUDnI;
   wire              MMUBIUReq;

   // From uSysCtl to uIRoute
   wire              INSTRCapture;
   wire              INSTRSelHold;
   wire              INSTRSelICRD;
   wire              INSTRSelIEXTRD;
   wire              INSTRSelITCMRD;

   // From uSysCtl to uDRoute
   wire              CPWDCapture;
   wire              CPWDSelDCRD;
   wire              CPWDSelDEXTRD;
   wire              CPWDSelDTCMRD;
   wire              CPWDSelHold;
   wire              CPWDSelITCMRD;
   wire              CPWDSelWDATA;
   wire              RDCapture;
   wire              RDSelCP15RD;
   wire              RDSelDCRD;
   wire              RDSelDEXTRD;
   wire              RDSelDTCMRD;
   wire              RDSelHold;
   wire              RDSelITCMRD;
   wire              WDSelCP15RD;
   wire              WDSelWDATA;

   // From uSysCtl to uICache
   wire              ICCancel;
   wire              ICMREQ;
   wire              ICSEQ;
   wire              ICIdle;
   wire              ICNoFinish;
   wire              ICReady;

   // From uSysCtl to uDCache
   wire              DCCancel;
   wire [1:0]        DCMAS;
   wire              DCMREQ;
   wire              DCSEQ;
   wire              DCnRW;
   wire              DCIdle;
   wire              DCNoFinish;
   wire              DCReady;

   // From uSysCtl to uMMU
   wire              DTCMEn;
   wire              ITCMEn;
   wire              MMUIdle;

   // From uSysCtl to uDuTLB
   wire              DExtAbort;
   wire              DCRegion;
   wire              DLookupStall;
   wire              DMMUAbort;
   wire              DNCBRegion;
   wire              DNCNBRegion;
   wire              DTCMRegion;
   wire              DTLBReady;

   // From uSysCtl to uIuTLB
   wire              IExtAbort;
   wire              ICRegion;
   wire              ILookupStall;
   wire              IMMUAbort;
   wire              INCRegion;
   wire              ITCMRegion;
   wire              ITLBReady;

   // From uSysCtl to uTCM
   wire [1:0]        DTCMAS;
   wire              DTCMCancel;
   wire              DTCMNoReq;
   wire              DTCMRDREQ;
   wire              DTCMSEQ;
   wire              DTCMSampleDA;
   wire              DTCMSelDAHeld;
   wire              DTCMWRREQ;
   wire              DTCMnRW;
   wire              DtoISelDPA;
   wire [1:0]        ITCMAS;
   wire              ITCMCancel;
   wire              ITCMNoReq;
   wire              ITCMRDREQ;
   wire              ITCMSEQ;
   wire              ITCMSampleIA;
   wire              ITCMSelIAHeld;
   wire              ITCMWRREQ;
   wire              ITCMnRW;
   wire              DTCMBUSY;
   wire              DTCMReady;
   wire              ITCMBUSY;
   wire              ITCMReady;

   // From uDRoute to uDCache
   wire [31:0]       DCWD;
   wire [31:0]       DCRD;

   // From uDRoute to uTCM
   wire [31:0]       DTCMWD;
   wire [31:0]       ITCMWD;
   wire [31:0]       DTCMRD;

   // From uDCache to uDuTLB
   wire              Writeback;

   // From uMMU to uDuTLB
   wire              DUTLBready;
   wire              DUTLBabort;
   wire              DUTLBidleabort;
   wire [7:0]        DUTLBfs;
   wire              DUTLBlock;
   wire              DUTLBnrw;
   wire              DUTLBntrans;
   wire              DUTLBreq;

   // From uMMU to uIuTLB
   wire              IUTLBready;
   wire              IUTLBabort;
   wire              IUTLBidleabort;
   wire [7:0]        IUTLBfs;
   wire              IUTLBlock;
   wire              IUTLBnrw;
   wire              IUTLBntrans;
   wire              IUTLBreq;

   // From uDuTLB to uTCM
   wire              DTCMNewPage;
   wire  [3:0]       DTCMPageSize;

   // From uIuTLB to uTCM
   wire              ITCMNewPage;
   wire  [3:0]       ITCMPageSize;

   // interrupt inputs to 9EJ

   wire              nFIQARM9;
   wire              nIRQARM9;

   // Other wires
   wire              AlignCheck; // 
   wire              BIGEND;    // raw BIGEND bit from control register in CP15
   wire              SysBIGEND; // BIGEND pipelined and delayed to avoid write-buffer hazards
   wire [1:0]        CHSD; // 
   wire [1:0]        CHSE; // 
   wire              CLKEN; // 
   wire [3:0]        CacheOp; // 
   wire              DABORT; // 
   wire [31:0]       DA; // 
   wire [31:0]       DBIURD; // 
   wire              DCCP15Ready; // 
   wire              DCacheEn; // 
   wire              DKILL; // 
   wire              DLOCK; // 
   wire [1:0]        DMAS; // 
   wire              DMORE; // 
   wire [31:0]       DMVA; // 
   wire [31:0]       DPA; // 
   wire              DPrivileged; // 
   wire              DSEQ; // 
   wire              DUTLBload; // 
   wire              DUTLBmatch; // 
   wire              DnMREQ; // 
   wire              DnRW; // 
   wire              DnTRANS; // 
   wire              DtoITCM; // 
   wire              pETMEN;
   wire              ETMIKILLraw; // 
   wire              ETMInMREQraw; // 
   wire              GCLK; // 
   wire              IABORT; // 
   wire [31:0]       IA; // 
   wire [31:0]       IBIURD; // 
   wire              ICCP15Ready; // 
   wire [31:0]       ICRD; // 
   wire              ICacheEn; // 
   wire [31:0]       IEXTRD; // 
   wire              IJBIT; // 
   wire              IKILL; // 
   wire [31:0]       IMVA; // 
   wire [31:0]       INSTR; // 
   wire [31:0]       IPA; // 
   wire              IPrefetchDone; // 
   wire              IPrivileged; // 
   wire              ISEQ; // 
   wire              ITBIT; // 
   wire [31:0]       ITCMRD; // 
   wire              IUTLBload; // 
   wire              IUTLBmatch; // 
   wire              InMREQ; // 
   wire              InTRANS; // 
   wire              InvalMicroTAG; // 
   wire              InvalMicroTLB; // 
   wire              LATECANCEL; // 
   wire              MMUEn; // 
   wire              MMUdisDCenbBHV; // 
   wire              PASS; // 
   wire [31:0]       RDATA; // 
   wire              ROMProt; // 
   wire              RRBIT; // 
   wire              SysCLKEN; // 
   wire              SysProt; // 
   wire              UTLBabort; // 
   wire [1:0]        UTLBap; // 
   wire [1:0]        DUTLBcbL1; // 
   wire [1:0]        DUTLBcbL2; // 
   wire [1:0]        IUTLBcbL1; // 
   wire [1:0]        IUTLBcbL2; // 
   wire              UTLBclient; // 
   wire              UTLBcommit; // 
   wire              UTLBdfault; // 
   wire [3:0]        UTLBdomain; // 
   wire [31:10]      UTLBpa; // 
   wire              UTLBpage; // 
   wire [1:0]        UTLBregion; // 
   wire [3:0]        UTLBsize; // 
   wire [31:0]       WDATA; // 

// Unused inputs:
   wire [33:0]       DBG0;
   wire [33:0]       DBG1;
   wire              DCDIRTYCS;
   wire              DCVALIDCS;
   wire              ICVALIDCS;


    wire RESETn;         // Buffered HRESETn
    wire DBGnTRSTbuf;    // Buffered DBGnTRST
    wire iDBGTCKENbuf;   // Buffered iDBGTCKEN 



// null-assignments to DBG0 and DBG1


// Internal Test Wrapper nets:
   wire              iDBGIEBKPT;
   wire              iDBGDEWPT;
   wire              iINITRAM;
   wire   [1:0]      iCHSDE;
   wire   [1:0]      iCHSEX;
   wire   [3:0]      iCPBURST;
   wire   [31:0]     iCPDIN;
   wire              iCPEN;
   wire              iDBGEN;
   wire   [1:0]      iDBGEXT;
   wire              iDBGSDOUT;
   wire              iDBGTCKEN;
   wire              iDBGTDI;
   wire              iDBGTMS;
   wire              iDHCLKEN;
   wire              iDHGRANT;
   wire              iDHREADY;
   wire   [1:0]      iDHRESP;
   wire   [17:0]     iDRDMAADDR;
   wire              iDRDMACS;
   wire              iDRDMAEN;
   wire   [31:0]     iDRRD;
   wire   [3:0]      iDRSIZE;
   wire              iEDBGRQ;
   wire              iETMEN;
   wire              iFIFOFULL;
   wire              iIHCLKEN;
   wire              iIHGRANT;
   wire              iIHREADY;
   wire   [1:0]      iIHRESP;
   wire   [17:0]     iIRDMAADDR;
   wire              iIRDMACS;
   wire              iIRDMAEN;
   wire   [31:0]     iIRRD;
   wire   [3:0]      iIRSIZE;
   wire   [31:0]     iTAPID;
   wire              iVINITHI;
   wire              iBIGENDINIT;
   wire              inFIQ;
   wire              inIRQ;
   wire              iCOMMTX;
   wire              iCPCLKEN;
   wire              iDBGACK;
   wire              iDBGINSTREXEC;
   wire  [3:0]       iDBGIR;
   wire  [1:0]       iDBGRNG;
   wire              iDBGRQI;
   wire              iDBGSDIN;
   wire  [3:0]       iDBGTAPSM;
   wire              iDBGTDO;
   wire              iDBGnTDOEN;
   wire              iDRIDLE;
   wire              iDRSEQ;
   wire  [3:0]       iDRWBL;
   wire              iDRnRW;
   wire              iIRIDLE;
   wire              iIRSEQ;
   wire  [3:0]       iIRWBL;
   wire              iIRnRW;
   wire              inCPMREQ;


   TestWrapper uTestWrapper(
                      // Wrapper Outputs:
                      .iDBGIEBKPT   (iDBGIEBKPT),
                      .iDBGDEWPT    (iDBGDEWPT),
                      .iINITRAM     (iINITRAM),
                      .iCHSDE       (iCHSDE[1:0]),
                      .iCHSEX       (iCHSEX[1:0]),
                      .iCPBURST     (iCPBURST[3:0]),
                      .iCPDIN       (iCPDIN[31:0]),
                      .iCPEN        (iCPEN),
                      .iDBGEN       (iDBGEN),
                      .iDBGEXT      (iDBGEXT[1:0]),
                      .iDBGSDOUT    (iDBGSDOUT),
                      .iDBGTCKEN    (iDBGTCKEN),
                      .iDBGTDI      (iDBGTDI),
                      .iDBGTMS      (iDBGTMS),
                      .iDHCLKEN     (iDHCLKEN),
                      .iDHGRANT     (iDHGRANT),
                      .iDHREADY     (iDHREADY),
                      .iDHRESP      (iDHRESP[1:0]),
                      .iDRDMAADDR   (iDRDMAADDR[17:0]),
                      .iDRDMACS     (iDRDMACS),
                      .iDRDMAEN     (iDRDMAEN),
                      .iDRRD        (iDRRD[31:0]),
                      .iDRSIZE      (iDRSIZE[3:0]),
                      .iEDBGRQ      (iEDBGRQ),
                      .iETMEN       (iETMEN),
                      .iFIFOFULL    (iFIFOFULL),
                      .iIHCLKEN     (iIHCLKEN),
                      .iIHGRANT     (iIHGRANT),
                      .iIHREADY     (iIHREADY),
                      .iIHRESP      (iIHRESP[1:0]),
                      .iIRDMAADDR   (iIRDMAADDR[17:0]),
                      .iIRDMACS     (iIRDMACS),
                      .iIRDMAEN     (iIRDMAEN),
                      .iIRRD        (iIRRD[31:0]),
                      .iIRSIZE      (iIRSIZE[3:0]),
                      .iTAPID       (iTAPID[31:0]),
                      .iVINITHI     (iVINITHI),
                      .iBIGENDINIT  (iBIGENDINIT),
                      .inFIQ        (inFIQ),
                      .inIRQ        (inIRQ),
                      .COMMTX       (COMMTX),
                      .CPCLKEN      (CPCLKEN),
                      .DBGACK       (DBGACK),
                      .DBGINSTREXEC (DBGINSTREXEC),
                      .DBGIR        (DBGIR[3:0]),
                      .DBGRNG       (DBGRNG[1:0]),
                      .DBGRQI       (DBGRQI),
                      .DBGSDIN      (DBGSDIN),
                      .DBGTAPSM     (DBGTAPSM[3:0]),
                      .DBGTDO       (DBGTDO),
                      .DBGnTDOEN    (DBGnTDOEN),
                      .DRIDLE       (DRIDLE),
                      .DRSEQ        (DRSEQ),
                      .DRWBL        (DRWBL[3:0]),
                      .DRnRW        (DRnRW),
                      .IRIDLE       (IRIDLE),
                      .IRSEQ        (IRSEQ),
                      .IRWBL        (IRWBL[3:0]),
                      .IRnRW        (IRnRW),
                      // Wrapper Inputs:
                      .DBGIEBKPT    (DBGIEBKPT),
                      .DBGDEWPT     (DBGDEWPT),
                      .INITRAM      (INITRAM),
                      .nCPMREQ      (nCPMREQ),
                      .CLK          (CLK),
                      .EXTEST       (EXTEST),
                      .INTEST       (INTEST),
                      .CHSDE        (CHSDE[1:0]),
                      .CHSEX        (CHSEX[1:0]),
                      .CPBURST      (CPBURST[3:0]),
                      .CPDIN        (CPDIN[31:0]),
                      .CPEN         (CPEN),
                      .DBGEN        (DBGEN),
                      .DBGEXT       (DBGEXT[1:0]),
                      .DBGSDOUT     (DBGSDOUT),
                      .DBGTCKEN     (DBGTCKEN),
                      .DBGTDI       (DBGTDI),
                      .DBGTMS       (DBGTMS),
                      .DHCLKEN      (DHCLKEN),
                      .DHGRANT      (DHGRANT),
                      .DHREADY      (DHREADY),
                      .DHRESP       (DHRESP[1:0]),
                      .DRDMAADDR    (DRDMAADDR[17:0]),
                      .DRDMACS      (DRDMACS),
                      .DRDMAEN      (DRDMAEN),
                      .DRRD         (DRRD[31:0]),
                      .DRSIZE       (DRSIZE[3:0]),
                      .EDBGRQ       (EDBGRQ),
                      .ETMEN        (ETMEN),
                      .FIFOFULL     (FIFOFULL),
                      .IHCLKEN      (IHCLKEN),
                      .IHGRANT      (IHGRANT),
                      .IHREADY      (IHREADY),
                      .IHRESP       (IHRESP[1:0]),
                      .IRDMAADDR    (IRDMAADDR[17:0]),
                      .IRDMACS      (IRDMACS),
                      .IRDMAEN      (IRDMAEN),
                      .IRRD         (IRRD[31:0]),
                      .IRSIZE       (IRSIZE[3:0]),
                      .TAPID        (TAPID[31:0]),
                      .VINITHI      (VINITHI),
                      .BIGENDINIT   (BIGENDINIT),
                      .nFIQ         (nFIQ),
                      .nIRQ         (nIRQ),
                      .iCOMMTX      (iCOMMTX),
                      .iCPCLKEN     (iCPCLKEN),
                      .iDBGACK      (iDBGACK),
                      .iDBGINSTREXEC(iDBGINSTREXEC),
                      .iDBGIR       (iDBGIR[3:0]),
                      .iDBGRNG      (iDBGRNG[1:0]),
                      .iDBGRQI      (iDBGRQI),
                      .iDBGSDIN     (iDBGSDIN),
                      .iDBGTAPSM    (iDBGTAPSM[3:0]),
                      .iDBGTDO      (iDBGTDO),
                      .iDBGnTDOEN   (iDBGnTDOEN),
                      .iDRIDLE      (iDRIDLE),
                      .iDRSEQ       (iDRSEQ),
                      .iDRWBL       (iDRWBL[3:0]),
                      .iDRnRW       (iDRnRW),
                      .iIRIDLE      (iIRIDLE),
                      .iIRSEQ       (iIRSEQ),
                      .iIRWBL       (iIRWBL[3:0]),
                      .iIRnRW       (iIRnRW),
                      .inCPMREQ     (inCPMREQ));


// Dummy Buffers for high-fanout nets

   dummy_buffer uHRESET_CT (.Z (RESETn),
                            .I (HRESETn)
                           );

   dummy_buffer uDBGnTRST_CT (.Z (DBGnTRSTbuf),
                              .I (DBGnTRST)
                             );

   dummy_buffer uDBGTCKEN_CT (.Z (iDBGTCKENbuf),
                              .I (iDBGTCKEN)
                             );


`ifdef FPGA
//   assign            DBG0 = {2'b00, 32'h00000000};
//   assign            DBG1 = {2'b00, 32'h00000000};
  wire [33:0] ARM9DBG0;
  wire [33:0] ARM9DBG1;
  assign ARM9DBG0 = {2'b00, 32'h00000000};
  assign ARM9DBG1 = {2'b00, 32'h00000000};
  
  assign DBG0 = (DSWITCH[4:2] == 3'b000) ? ARM9DBG0 :
		(DSWITCH[4:2] == 3'b001) ? {ARM9Clk, CLKEN, DMVA} :
		(DSWITCH[4:2] == 3'b010) ? {ARM9Clk, CLKEN, IPA} :
		(DSWITCH[4:2] == 3'b011) ? {ARM9Clk, CLKEN, DPA} :
		(DSWITCH[4:2] == 3'b100) ? {ARM9Clk, CLKEN, INSTR} :
		(DSWITCH[4:2] == 3'b101) ? {CLK, CLKEN, IEXTReady, DEXTReady, ICReady, 
					DCReady, ITLBReady, DTLBReady, ILookupStall, 
					DLookupStall, DBIUIdle, IBIUIdle, DUTLBreq, 
					IUTLBreq, 5'b00000, DnMREQ, InMREQ, DKILL, 
					IKILL, DABORT, IABORT, DHWRITE, DEXTMREQ, 
					DEXTnRW, DEXTCancel, DEXTCached, DCMREQ, 
					DCnRW, DCCancel, DEXTBIUReq} :
		(DSWITCH[4:2] == 3'b110) ? {ARM9Clk, CLKEN, DCIdle, DCNoFinish, 
					    DCReady, DCMREQ, 
					    DCSEQ, DCnRW, DCMAS[1:0], DCCancel,
					    DPrivileged, Writeback, DontCommit,
					    DCACHEBIUEarlyReq, DCACHEBIUReq,
					    DCACHEBIUBurst[2:0], DCACHEBIUnRW,
					    DCACHEBIUWrap, DCACHEBIUPriv,
					    DCACHEBIUAck, DCACHEBIUNextWD,
					    DCACHEBIUReady, DisableWriteback, 
					    InvalMicroTAG, 1'b0, CacheOp[3:0], DCCP15Req, 
					    1'b0} :
		{ARM9Clk, CLKEN, DEXTReady, DEXTBIUReq, DEXTBIUnRW, DEXTSEQ, DEXTMREQ,
		 DEXTBURST[3:0], DEXTnRW, DEXTBIUReady, DEXTBIUAck, DEXTBIUNextWD, 
		 DEXTCancel, DCIdle, DCReady, 
		 DCMREQ, DCSEQ, DCnRW, DCCancel, Writeback, DCACHEBIUEarlyReq, 
		 DCACHEBIUReq, DCACHEBIUnRW, DCACHEBIUWrap, DCACHEBIUAck, 
		 DCACHEBIUReady, DCACHEBIUNextWD, DHWRITE, DnMREQ, DKILL, DSEQ};
		
  assign DBG1 = (DSWITCH[7:5] == 3'b000) ? ARM9DBG1 :
		(DSWITCH[7:5] == 3'b001) ? {ARM9Clk, CLKEN, IMVA} :
		(DSWITCH[7:5] == 3'b010) ? {ARM9Clk, CLKEN, IPA} :
		(DSWITCH[7:5] == 3'b011) ? {ARM9Clk, CLKEN, DPA} :
		(DSWITCH[7:5] == 3'b100) ? {ARM9Clk, CLKEN, INSTR} :
		(DSWITCH[7:5] == 3'b101) ? {CLK, CLKEN, IEXTReady, DEXTReady, ICReady, 
					DCReady, ITLBReady, DTLBReady, ILookupStall, 
					DLookupStall, DBIUIdle, IBIUIdle, DUTLBreq, 
					IUTLBreq, 5'b00000, DnMREQ, InMREQ, DKILL, 
					IKILL, DABORT, IABORT, DHWRITE, DEXTMREQ, 
					DEXTnRW, DEXTCancel, DEXTCached, DCMREQ, 
					DCnRW, DCCancel, DEXTBIUReq, DCACHEBIUReq, 
					MMUBIUReq} :
		(DSWITCH[7:5] == 3'b110) ? {ARM9Clk, CLKEN, DCIdle, DCNoFinish, 
					    DCReady, DCMREQ, 
					    DCSEQ, DCnRW, DCMAS[1:0], DCCancel,
					    DPrivileged, Writeback, DontCommit,
					    DCACHEBIUEarlyReq, DCACHEBIUReq,
					    DCACHEBIUBurst[2:0], DCACHEBIUnRW,
					    DCACHEBIUWrap, DCACHEBIUPriv,
					    DCACHEBIUAck, DCACHEBIUNextWD,
					    DCACHEBIUReady, DisableWriteback, 
					    InvalMicroTAG, 1'b0, CacheOp[3:0], DCCP15Req, 
					    1'b0} :
		{ARM9Clk, CLKEN, DEXTReady, DEXTBIUReq, DEXTBIUnRW, DEXTSEQ, DEXTMREQ,
		 DEXTBURST[3:0], DEXTnRW, DEXTBIUReady, DEXTBIUAck, DEXTBIUNextWD, 
		 DEXTCancel, DCIdle, DCReady, 
		 DCMREQ, DCSEQ, DCnRW, DCCancel, Writeback, DCACHEBIUEarlyReq, 
		 DCACHEBIUReq, DCACHEBIUnRW, DCACHEBIUWrap, DCACHEBIUAck, 
		 DCACHEBIUReady, DCACHEBIUNextWD, DHWRITE, DnMREQ, DKILL, DSEQ};
`endif		

   a926ejsClkBlk uClkBlk (//Outputs:
                         .GCLK              (GCLK),                       
                         .ARM9Clk           (ARM9Clk),
                         .IEXTClk           (IEXTClk),
                         .DEXTClk           (DEXTClk),
                         .ICClk             (ICClk),
                         .DCClk             (DCClk),
                         .DTCMClk           (DTCMClk),
                         .ITCMClk           (ITCMClk),
                         .CP15PipeClk       (CP15PipeClk),
                         .CP15DebugClk      (CP15DebugClk),
                         .MMUClk            (MMUClk),
                         .ETMIFClk          (ETMIFClk),
                         .pETMEN            (pETMEN),
                         //Inputs:
                         .TESTMODE          (TESTMODE),
                         .HRESETn           (RESETn),
                         .CLK               (CLK),
                         .DisableBlkClkGate (DisableBlkClkGate),
                         .WFIWakeUp         (WFIWakeUp),
                         .STANDBYWFI        (STANDBYWFI),
                         .ICClkEn           (ICClkEn),
                         .DCClkEn           (DCClkEn),
                         .ITCMClkEn         (ITCMClkEn),
                         .DTCMClkEn         (DTCMClkEn),
                         .IEXTClkEn         (IEXTClkEn),
                         .DEXTClkEn         (DEXTClkEn),
                         .CP15PipeClkEn     (CP15PipeClkEn),
                         .CP15DbgClkEn      (CP15DbgClkEn),
                         .ARM9ClkEn         (ARM9ClkEn),
                         .MMUClkEn          (MMUClkEn),
                         .ETMEN             (iETMEN));

   a926ejsFCSE uFCSE (//Outputs:
                     .DVA          (DVA[31:0]),
                     .IVA          (IVA[31:0]),
                     .DMVA         (DMVA[31:0]),
                     .IMVA         (IMVA[31:0]),
                     .DAME         (DAME[9:2]),
                     .IAFE         (IAFE[9:2]),
                     .RawIMVA      (RawIMVA[31:25]),
                     .RawDMVA      (RawDMVA[31:25]),
                     //Inputs:
                     .GCLK         (GCLK),
                     .Reset        (RESETn),
                     .FCSESampleIA (FCSESampleIA),
                     .FCSESampleDA (FCSESampleDA),
                     .DVASelDAHeld (DVASelDAHeld),
                     .IVASelIAHeld (IVASelIAHeld),
                     .IA           (IA[31:0]),
                     .DA           (DA[31:0]),
                     .CP15VA       (CP15VA[31:0]),
                     .FCSEPID      (FCSEPID[31:25]),
                     .MMUEn        (MMUEn),
                     .DisableFCSE  (DisableFCSE),
                     .SelCP15VA    (SelCP15VA));

   ARM9EJSwrap u9EJ (//Outputs:
                    .IA            (IA[31:0]),
                    .IKILL         (IKILL),
                    .InMREQ        (InMREQ),
                    .InM           (),
                    .InTRANS       (InTRANS),
                    .ISEQ          (ISEQ),
                    .ITBIT         (ITBIT),
                    .IJBIT         (IJBIT),
                    .DA            (DA[31:0]),
                    .WDATA         (WDATA[31:0]),
                    .DBURST        (DBURST[3:0]),
                    .DKILL         (DKILL),
                    .DLOCK         (DLOCK),
                    .DMAS          (DMAS[1:0]),
                    .DMORE         (DMORE),
                    .DnMREQ        (DnMREQ),
                    .DnM           (),
                    .DnRW          (DnRW),
                    .DnSPEC        (),
                    .DnTRANS       (DnTRANS),
                    .DSEQ          (DSEQ),
                    .PASS          (PASS),
                    .LATECANCEL    (LATECANCEL),
                    .DBGIR         (iDBGIR[3:0]),
                    .DBGnTDOEN     (iDBGnTDOEN),
                    .DBGSCREG      (DBGSCREG[4:0]),
                    .DBGSDIN       (iDBGSDIN),
                    .DBGTAPSM      (iDBGTAPSM[3:0]),
                    .DBGTDO        (DBGTDOa9ejs),
                    .DBGCOMMRX     (COMMRX),
                    .DBGCOMMTX     (iCOMMTX),
                    .DBGACK        (iDBGACK),
                    .DBGRQI        (iDBGRQI),
                    .CORECLKENOUT  (),
                    .DBGINSTREXEC  (iDBGINSTREXEC),
                    .DBGINSTRVALID (DBGINSTRVALID),
                    .DBGRNG        (iDBGRNG[1:0]),
                    .FIQDIS        (),
                    .IRQDIS        (),
                    .ETMIAFE       (ETMIAFEraw[31:0]),
                    .ETMInMREQ     (ETMInMREQraw),
                    .ETMIKILL      (ETMIKILLraw),
                    .ETMISEQ       (ETMISEQraw),
                    .ETMZILAST     (ETMZILASTraw),
                    .ETMZIFIRST    (ETMZIFIRSTraw),
                    //Inputs:
                    .CLK           (ARM9Clk),
                    .CLKEN         (CLKEN),
                    .nRESET        (RESETn),
                    .IABORT        (IABORT),
                    .INSTR         (INSTR[31:0]),
                    .DBGIEBKPT     (iDBGIEBKPT),
                    .DABORT        (DABORT),
                    .RDATA         (RDATA[31:0]),
                    .DBGDEWPT      (iDBGDEWPT),
                    .nFIQ          (nFIQARM9),
                    .nIRQ          (nIRQARM9),
                    .CFGBIGEND     (BIGEND),
                    .CFGDISLTBIT   (DisableLdTBIT),
                    .CFGHIVECS     (HIVECS),
                    .CHSD          (CHSD[1:0]),
                    .CHSE          (CHSE[1:0]),
                    .DBGnTRST      (DBGnTRSTbuf),
                    .DBGSDOUT      (iDBGSDOUT),
                    .DBGTCKEN      (iDBGTCKENbuf),
                    .DBGTDI        (iDBGTDI),
                    .DBGTMS        (iDBGTMS),
                    .DBGEN         (iDBGEN),
                    .EDBGRQ        (iEDBGRQ),
                    .DBGEXT        (iDBGEXT[1:0]),
                    .TAPID         (iTAPID[31:0]),
                    .CFGTHUMB32    (1'b1));


   a926ejsETMIF ETMIF (//Outputs:
                      .ETMBIGEND     (ETMBIGEND),
                      .ETMHIVECS     (ETMHIVECS),
                      .ETMnWAIT      (ETMnWAIT),
                      .ETMIA         (ETMIA[31:0]),
                      .ETMInMREQ     (ETMInMREQ),
                      .ETMISEQ       (ETMISEQ),
                      .ETMZIFIRST    (ETMZIFIRST),
                      .ETMZILAST     (ETMZILAST),
                      .ETMITBIT      (ETMITBIT),
                      .ETMIJBIT      (ETMIJBIT),
                      .ETMID31To25   (ETMID31To25[31:25]),
                      .ETMID15To11   (ETMID15To11[15:11]),
                      .ETMDA         (ETMDA[31:0]),
                      .ETMWDATA      (ETMWDATA[31:0]),
                      .ETMDMAS       (ETMDMAS[1:0]),
                      .ETMDMORE      (ETMDMORE),
                      .ETMDnMREQ     (ETMDnMREQ),
                      .ETMDnRW       (ETMDnRW),
                      .ETMDSEQ       (ETMDSEQ),
                      .ETMRDATA      (ETMRDATA[31:0]),
                      .ETMDABORT     (ETMDABORT),
                      .ETMCHSD       (ETMCHSD[1:0]),
                      .ETMCHSE       (ETMCHSE[1:0]),
                      .ETMLATECANCEL (ETMLATECANCEL),
                      .ETMPASS       (ETMPASS),
                      .ETMDBGACK     (ETMDBGACK),
                      .ETMINSTREXEC  (ETMINSTREXEC),
                      .ETMINSTRVALID (ETMINSTRVALID),
                      .ETMRNGOUT     (ETMRNGOUT[1:0]),
                      .ETMIABORT     (ETMIABORT),
                      //Inputs:
                      .CFGBIGEND     (BIGEND),
                      .CFGHIVECS     (HIVECS),
                      .CLKEN         (CLKEN),
                      .ETMInMREQraw  (ETMInMREQraw),
                      .ETMISEQraw    (ETMISEQraw),
                      .ETMIKILLraw   (ETMIKILLraw),
                      .ETMZIFIRSTraw (ETMZIFIRSTraw),
                      .ETMZILASTraw  (ETMZILASTraw),
                      .ETMIAFEraw    (ETMIAFEraw[31:0]),
                      .ITBIT         (ITBIT),
                      .IJBIT         (IJBIT),
                      .INSTR         (INSTR[31:0]),
                      .DA            (DA[31:0]),
                      .CPUWDATA      (WDATA[31:0]),
                      .DMAS          (DMAS[1:0]),
                      .DMORE         (DMORE),
                      .DnMREQ        (DnMREQ),
                      .DKILL         (DKILL),
                      .DnRW          (DnRW),
                      .DSEQ          (DSEQ),
                      .CPURDATA      (RDATA[31:0]),
                      .DABORT        (DABORT),
                      .CHSD          (CHSD[1:0]),
                      .CHSE          (CHSE[1:0]),
                      .LATECANCEL    (LATECANCEL),
                      .PASS          (PASS),
                      .DBGACK        (iDBGACK),
                      .DBGINSTREXEC  (iDBGINSTREXEC),
                      .DBGINSTRVALID (DBGINSTRVALID),
                      .DBGRNG        (iDBGRNG[1:0]),
                      .IABORT        (IABORT),
                      .pETMEN        (pETMEN),
                      .ETMIFCLK      (ETMIFClk));

   a926ejsCP15 uCP15 (//Outputs:
                      .CP15Idle          (CP15Idle),
                      .CHSD              (CHSD[1:0]),
                      .CHSE              (CHSE[1:0]),
                      .CPCLKEN           (iCPCLKEN),
                      .nCPMREQ           (inCPMREQ),
                      .CPPASS            (CPPASS),
                      .CPLATECANCEL      (CPLATECANCEL),
                      .CPABORT           (CPABORT),
                      .CPINSTR           (CPINSTR[31:0]),
                      .nCPINSTRVALID     (nCPINSTRVALID),
                      .nCPTRANS          (nCPTRANS),
                      .CPDOUT            (CPDOUT[31:0]),
                      .CPBURSTEX         (CPBURSTEX[3:0]),
                      .CP15RD            (CP15RD[31:0]),
                      .LDCinME           (LDCinME),
                      .MCRinME           (MCRinME),
                      .STCinME           (STCinME),
                      .MRCinME           (MRCinME),
                      .CP15VA            (CP15VA[31:0]),
                      .DisableFCSE       (DisableFCSE),
                      .SelCP15VA         (SelCP15VA),
                      .DBGWD             (DBGWD[31:0]),
                      .MMUCP15Req        (MMUCP15Req),
                      .MMUOp             (MMUOp[10:0]),
                      .DCCP15Req         (DCCP15Req),
                      .ICCP15Req         (ICCP15Req),
                      .CacheOp           (CacheOp[3:0]),
                      .InvalMicroTAG     (InvalMicroTAG),
                      .CP15IHazard       (CP15IHazard),
                      .InvalMicroTLB     (InvalMicroTLB),
                      .CP15Active        (CP15Active),
                      .CP15IPrefetch     (CP15IPrefetch),
                      .CP15DWB           (CP15DWB),
                      .CP15WFI           (CP15WFI),
                      .FCSEPID           (FCSEPID[31:25]),
                      .ETMPROCID         (ETMPROCID[31:0]),
                      .ETMPROCIDWR       (ETMPROCIDWR),
                      .DCnWayAlloc       (DCnWayAlloc[3:0]),
                      .ICnWayAlloc       (ICnWayAlloc[3:0]),
                      .DisableLdTBIT     (DisableLdTBIT),
                      .RRBIT             (RRBIT),
                      .HIVECS            (HIVECS),
                      .ICacheEn          (ICacheEn),
                      .ROMProt           (ROMProt),
                      .SysProt           (SysProt),
                      .BIGEND            (BIGEND),
                      .DCacheEn          (DCacheEn),
                      .AlignCheck        (AlignCheck),
                      .MMUEn             (MMUEn),
                      .AbortDTLBMiss     (AbortDTLBMiss),
                      .AbortITLBMiss     (AbortITLBMiss),
                      .IEXTEnPrefetch    (IEXTEnPrefetch),
                      .DisableBlkClkGate (DisableBlkClkGate),
                      .ForceNCNB         (ForceNCNB),
                      .MMUdisDCenbBHV    (MMUdisDCenbBHV),
                      .TCFIQNoStall      (TCFIQNoStall),
                      .TCIRQNoStall      (TCIRQNoStall),
                      .SampleInt         (SampleInt),
                      .DisableWriteback  (DisableWriteback),
                      .ICNoLineFill      (ICNoLineFill),
                      .DCNoLineFill      (DCNoLineFill),
                      //Inputs:
                      .CP15PipeClk       (CP15PipeClk),
                      .CP15DebugClk      (CP15DebugClk),
                      .CPEN              (iCPEN),
                      .DBGnTRST          (DBGnTRSTbuf),
                      .DBGTCKEN          (iDBGTCKENbuf),
                      .DBGACK            (iDBGACK),
                      .DBGTDOa9ejs       (DBGTDOa9ejs),
                      .DBGTDI            (iDBGTDI),
                      .DBGTDO            (iDBGTDO),
                      .DBGTAPSM          (iDBGTAPSM[3:0]),
                      .DBGIR             (iDBGIR[3:0]),
                      .DBGSCREG          (DBGSCREG[4:0]),
                      .CP15nReset        (RESETn),
                      .DABORT            (DABORT),
                      .IABORT            (IABORT),
                      .PASS              (PASS),
                      .LATECANCEL        (LATECANCEL),
                      .ETMInMREQ         (ETMInMREQraw),
                      .InTRANS           (InTRANS),
                      .ITBIT             (ITBIT),
                      .IJBIT             (IJBIT),
                      .CHSDE             (iCHSDE[1:0]),
                      .CHSEX             (iCHSEX[1:0]),
                      .CPBURST           (iCPBURST[3:0]),
                      .CPDIN             (iCPDIN[31:0]),
                      .CP15CLKEN         (CP15CLKEN),
                      .CP15WD            (CP15WD[31:0]),
                      .INSTR             (INSTR[31:0]),
                      .MMUREGRD          (MMUREGRD[31:0]),
                      .MMUCP15Ready      (MMUCP15Ready),
                      .DCCP15Ready       (DCCP15Ready),
                      .DCDirty           (DCDirty),
                      .ICCP15Ready       (ICCP15Ready),
                      .IPrefetchDone     (IPrefetchDone),
                      .CP15DWBDone       (CP15DWBDone),
                      .CP15WFIDone       (CP15WFIDone),
                      .VINITHI           (iVINITHI),
                      .BIGENDINIT        (iBIGENDINIT),
                      .DCsize            (DCsize[3:0]),
                      .DCassoc           (DCassoc[2:0]),
                      .DCMbit            (DCMbit),
                      .ICsize            (ICsize[3:0]),
                      .ICassoc           (ICassoc[2:0]),
                      .ICMbit            (ICMbit),
                      .DRSIZE            (iDRSIZE[3:0]),
                      .IRSIZE            (iIRSIZE[3:0]));

   a926ejsDExt uDExt (//Outputs:
                     .DEXTReady        (DEXTReady),
                     .DEXTRD           (DEXTRD[31:0]),
                     .DEXTError        (DEXTError),
                     .DEXTIdle         (DEXTIdle),
                     .DEXTBlocked      (DEXTBlocked),
                     .DEXTNoFinish     (DEXTNoFinish),
                     .DEXTBIUA         (DEXTBIUA[31:0]),
                     .DEXTBIUReq       (DEXTBIUReq),
                     .DEXTBIUBurst     (DEXTBIUBurst[2:0]),
                     .DEXTBIUWD        (DEXTBIUWD[31:0]),
                     .DEXTBIUMAS       (DEXTBIUMAS[1:0]),
                     .DEXTBIUnRW       (DEXTBIUnRW),
                     .DEXTBIULock      (DEXTBIULock),
                     .DEXTBIUPriv      (DEXTBIUPriv),
                     .DEXTBIUBuff      (DEXTBIUBuff),
                     .DEXTBIUCacheable (DEXTBIUCacheable),
                     //Inputs:
                     .DEXTClk          (DEXTClk),
                     .DEXTnReset       (RESETn),
                     .DEXTCancel       (DEXTCancel),
                     .DEXTSEQ          (DEXTSEQ),
                     .DEXTMREQ         (DEXTMREQ),
                     .DEXTBURST        (DEXTBURST[3:0]),
                     .DEXTnRW          (DEXTnRW),
                     .DEXTMAS          (DEXTMAS[1:0]),
                     .DPA              (DPA[31:0]),
                     .DEXTWD           (DEXTWD[31:0]),
                     .DEXTSwap         (DEXTSwap),
                     .DPrivileged      (DPrivileged),
                     .Buffered         (DEXTBuffered),
                     .Cached           (DEXTCached),
                     .DL2Bufferable    (DL2Bufferable),
                     .DL2Cacheable     (DL2Cacheable),
                     .DontCommit       (DontCommit),
                     .DEXTBIUReady     (DEXTBIUReady),
                     .DEXTBIUNextWD    (DEXTBIUNextWD),
                     .DEXTBIUAck       (DEXTBIUAck),
                     .DEXTBIUErr       (DEXTBIUErr),
                     .BIURD            (DBIURD[31:0]));

   a926ejsIExt uIExt (//Outputs:
                     .IEXTIdle         (IEXTIdle),
                     .IEXTBlocked      (IEXTBlocked),
                     .IEXTReady        (IEXTReady),
                     .IEXTNoFinish     (IEXTNoFinish),
                     .IEXTRD           (IEXTRD[31:0]),
                     .IEXTError        (IEXTError),
                     .IEXTBIUReq       (IEXTBIUReq),
                     .IEXTBIUBurst     (IEXTBIUBurst[2:0]),
                     .IEXTBIUA         (IEXTBIUA[31:0]),
                     .IEXTBIUPriv      (IEXTBIUPriv),
                     .IEXTBIUCacheable (IEXTBIUCacheable),
                     //Inputs:
                     .IEXTClk          (IEXTClk),
                     .IEXTnReset       (RESETn),
                     .IEXTMREQ         (IEXTMREQ),
                     .IEXTSEQ          (IEXTSEQ),
                     .IEXTCancel       (IEXTCancel),
                     .IPrivileged      (IPrivileged),
                     .IPA              (IPA[31:0]),
                     .IEXTEnPrefetch   (IEXTEnPrefetch),
                     .IEXTBIUReady     (IEXTBIUReady),
                     .IEXTBIUAck       (IEXTBIUAck),
                     .IEXTBIUErr       (IEXTBIUErr),
                     .IBIURD           (IBIURD[31:0]),
                     .IL2Cacheable     (IL2Cacheable));

   a926ejsBIU uBIU (//Outputs:
                   .DHBUSREQ         (DHBUSREQ),
                   .DHLOCK           (DHLOCK),
                   .DHADDR           (DHADDR[31:0]),
                   .DHTRANS          (DHTRANS[1:0]),
                   .DHWRITE          (DHWRITE),
                   .DHSIZE           (DHSIZE[2:0]),
                   .DHBURST          (DHBURST[2:0]),
                   .DHPROT           (DHPROT[3:0]),
                   .DHWDATA          (DHWDATA[31:0]),
                   .DHBL             (DHBL[3:0]),
                   .IHBUSREQ         (IHBUSREQ),
                   .IHLOCK           (IHLOCK),
                   .IHADDR           (IHADDR[31:0]),
                   .IHTRANS          (IHTRANS[1:0]),
                   .IHWRITE          (IHWRITE),
                   .IHSIZE           (IHSIZE[2:0]),
                   .IHBURST          (IHBURST[2:0]),
                   .IHPROT           (IHPROT[3:0]),
                   .DEXTBIUAck       (DEXTBIUAck),
                   .IEXTBIUAck       (IEXTBIUAck),
                   .MMUBIUAck        (MMUBIUAck),
                   .DCACHEBIUAck     (DCACHEBIUAck),
                   .ICACHEBIUAck     (ICACHEBIUAck),
                   .DEXTBIUReady     (DEXTBIUReady),
                   .IEXTBIUReady     (IEXTBIUReady),
                   .MMUBIUReady      (MMUBIUReady),
                   .DCACHEBIUReady   (DCACHEBIUReady),
                   .ICACHEBIUReady   (ICACHEBIUReady),
                   .DEXTBIUNextWD    (DEXTBIUNextWD),
                   .DCACHEBIUNextWD  (DCACHEBIUNextWD),
                   .DEXTBIUErr       (DEXTBIUErr),
                   .IEXTBIUErr       (IEXTBIUErr),
                   .MMUBIUErr        (MMUBIUErr),
                   .IBIURD           (IBIURD[31:0]),
                   .DBIURD           (DBIURD[31:0]),
                   .DBIUIdle         (DBIUIdle),
                   .IBIUIdle         (IBIUIdle),
                   //Inputs:
                   .DEXTBIUReq       (DEXTBIUReq),
                   .IEXTBIUReq       (IEXTBIUReq),
                   .MMUBIUReq        (MMUBIUReq),
                   .DCACHEBIUReqEarly(DCACHEBIUEarlyReq),
                   .ICACHEBIUReqEarly(ICACHEBIUEarlyReq),
                   .DCACHEBIUReq     (DCACHEBIUReq),
                   .ICACHEBIUReq     (ICACHEBIUReq),
                   .DEXTBIUBurst     (DEXTBIUBurst[2:0]),
                   .IEXTBIUBurst     (IEXTBIUBurst[2:0]),
                   .DCACHEBIUBurst   (DCACHEBIUBurst[2:0]),
                   .ICACHEBIUBurst   (ICACHEBIUBurst[2:0]),
                   .DEXTBIUA         (DEXTBIUA[31:0]),
                   .IEXTBIUA         (IEXTBIUA[31:0]),
                   .MMUBIUA          (MMUBIUA[31:0]),
                   .DCACHEBIUA       (DCACHEBIUA[31:0]),
                   .ICACHEBIUA       (ICACHEBIUA[31:0]),
                   .DEXTBIUnRW       (DEXTBIUnRW),
                   .DCACHEBIUnRW     (DCACHEBIUnRW),
                   .DEXTBIUMAS       (DEXTBIUMAS[1:0]),
                   .DEXTBIUWD        (DEXTBIUWD[31:0]),
                   .DCACHEBIUWD      (DCACHEBIUWD[31:0]),
                   .DCACHEBIUWrap    (DCACHEBIUWrap),
                   .ICACHEBIUWrap    (ICACHEBIUWrap),
                   .DEXTBIUBuff      (DEXTBIUBuff),
                   .DEXTBIUPriv      (DEXTBIUPriv),
                   .IEXTBIUPriv      (IEXTBIUPriv),
                   .MMUBIUDnI        (MMUBIUDnI),
                   .DCACHEBIUPriv    (DCACHEBIUPriv),
                   .ICACHEBIUPriv    (ICACHEBIUPriv),
                   .DEXTBIUCacheable (DEXTBIUCacheable),
                   .IEXTBIUCacheable (IEXTBIUCacheable),
                   .DEXTBIULock      (DEXTBIULock),
                   .CLK              (CLK),
                   .BIGEND           (SysBIGEND),
                   .EXTEST           (EXTEST),
                   .HRESETn          (RESETn),
                   .DHGRANT          (iDHGRANT),
                   .DHCLKEN          (iDHCLKEN),
                   .DHREADY          (iDHREADY),
                   .DHRESP           (iDHRESP[1:0]),
                   .DHRDATA          (DHRDATA[31:0]),
                   .IHGRANT          (iIHGRANT),
                   .IHCLKEN          (iIHCLKEN),
                   .IHREADY          (iIHREADY),
                   .IHRESP           (iIHRESP[1:0]),
                   .IHRDATA          (IHRDATA[31:0]));

   a926ejsSysCtl uSysCtl (//Outputs:
                         .CLKEN          (CLKEN),
                         .FCSESampleIA   (FCSESampleIA),
                         .FCSESampleDA   (FCSESampleDA),
                         .DVASelDAHeld   (DVASelDAHeld),
                         .IVASelIAHeld   (IVASelIAHeld),
                         .SysCLKEN       (SysCLKEN),
                         .DExtAbort      (DExtAbort),
                         .IExtAbort      (IExtAbort),
                         .IEXTMREQ       (IEXTMREQ),
                         .IEXTSEQ        (IEXTSEQ),
                         .IEXTCancel     (IEXTCancel),
                         .IPrivileged    (IPrivileged),
                         .DEXTMREQ       (DEXTMREQ),
                         .DEXTSEQ        (DEXTSEQ),
                         .DEXTBURST      (DEXTBURST[3:0]),
                         .DEXTnRW        (DEXTnRW),
                         .DEXTMAS        (DEXTMAS[1:0]),
                         .DEXTBuffered   (DEXTBuffered),
                         .DEXTCached     (DEXTCached),
                         .DEXTCancel     (DEXTCancel),
                         .DPrivileged    (DPrivileged),
                         .DEXTSwap       (DEXTSwap),
                         .DTCMRDREQ      (DTCMRDREQ),
                         .DTCMWRREQ      (DTCMWRREQ),
                         .DTCMSEQ        (DTCMSEQ),
                         .DTCMnRW        (DTCMnRW),
                         .DTCMAS         (DTCMAS[1:0]),
                         .DTCMCancel     (DTCMCancel),
                         .DTCMNoReq      (DTCMNoReq),
                         .ITCMRDREQ      (ITCMRDREQ),
                         .ITCMWRREQ      (ITCMWRREQ),
                         .ITCMSEQ        (ITCMSEQ),
                         .ITCMnRW        (ITCMnRW),
                         .ITCMAS         (ITCMAS[1:0]),
                         .ITCMCancel     (ITCMCancel),
                         .ITCMNoReq      (ITCMNoReq),
                         .DtoISelDPA     (DtoISelDPA),
                         .ITCMSampleIA   (ITCMSampleIA),
                         .DTCMSampleDA   (DTCMSampleDA),
                         .DTCMSelDAHeld  (DTCMSelDAHeld),
                         .ITCMSelIAHeld  (ITCMSelIAHeld),
                         .DCMREQ         (DCMREQ),
                         .DCSEQ          (DCSEQ),
                         .DCnRW          (DCnRW),
                         .DCMAS          (DCMAS[1:0]),
                         .DCCancel       (DCCancel),
                         .ICMREQ         (ICMREQ),
                         .ICSEQ          (ICSEQ),
                         .ICCancel       (ICCancel),
                         .CP15CLKEN      (CP15CLKEN),
                         .IPrefetchDone  (IPrefetchDone),
                         .CP15WFIDone    (CP15WFIDone),
                         .CP15DWBDone    (CP15DWBDone),
                         .STANDBYWFI     (STANDBYWFI),
                         .RDSelCP15RD    (RDSelCP15RD),
                         .RDSelDCRD      (RDSelDCRD),
                         .RDSelDEXTRD    (RDSelDEXTRD),
                         .RDSelDTCMRD    (RDSelDTCMRD),
                         .RDSelITCMRD    (RDSelITCMRD),
                         .RDSelHold      (RDSelHold),
                         .RDCapture      (RDCapture),
                         .WDSelCP15RD    (WDSelCP15RD),
                         .WDSelWDATA     (WDSelWDATA),
                         .CPWDSelWDATA   (CPWDSelWDATA),
                         .CPWDSelDCRD    (CPWDSelDCRD),
                         .CPWDSelDEXTRD  (CPWDSelDEXTRD),
                         .CPWDSelDTCMRD  (CPWDSelDTCMRD),
                         .CPWDSelITCMRD  (CPWDSelITCMRD),
                         .CPWDSelHold    (CPWDSelHold),
                         .CPWDCapture    (CPWDCapture),
                         .INSTRSelICRD   (INSTRSelICRD),
                         .INSTRSelIEXTRD (INSTRSelIEXTRD),
                         .INSTRSelITCMRD (INSTRSelITCMRD),
                         .INSTRSelHold   (INSTRSelHold),
                         .INSTRCapture   (INSTRCapture),
                         .ICClkEn        (ICClkEn),
                         .DCClkEn        (DCClkEn),
                         .ITCMClkEn      (ITCMClkEn),
                         .DTCMClkEn      (DTCMClkEn),
                         .IEXTClkEn      (IEXTClkEn),
                         .DEXTClkEn      (DEXTClkEn),
                         .CP15PipeClkEn  (CP15PipeClkEn),
                         .CP15DbgClkEn   (CP15DbgClkEn),
                         .ARM9ClkEn      (ARM9ClkEn),
                         .MMUClkEn       (MMUClkEn),
                         .WFIWakeUp      (WFIWakeUp),
			 .SysBIGEND      (SysBIGEND),
			 .CFGBIGEND      (CFGBIGEND),
                         //Inputs:
			 .CLK            (CLK),
                         .GCLK           (GCLK),
                         .SnReset        (RESETn),
                         .InMREQ         (InMREQ),
                         .IKILL          (IKILL),
                         .InTRANS        (InTRANS),
                         .ISEQ           (ISEQ),
                         .DnMREQ         (DnMREQ),
                         .DKILL          (DKILL),
                         .DBURST         (DBURST[3:0]),
                         .DMORE          (DMORE),
                         .DnRW           (DnRW),
                         .DMAS           (DMAS[1:0]),
                         .DnTRANS        (DnTRANS),
                         .DLOCK          (DLOCK),
                         .ETMInMREQ      (ETMInMREQraw),
                         .ETMIKILL       (ETMIKILLraw),
                         .PASS           (PASS),
                         .DBGTCKEN       (iDBGTCKENbuf),
                         .DBGRQI         (iDBGRQI),
                         .EDBGRQ         (iEDBGRQ),
                         .DBGACK         (iDBGACK),
                         .DBGSCREG       (DBGSCREG[3:0]),
                         .DAME           (DAME[9:2]),
                         .IAFE           (IAFE[9:2]),
                         .MMUIdle        (MMUIdle),
                         .DTCMEn         (DTCMEn),
                         .ITCMEn         (ITCMEn),
                         .DLookupStall   (DLookupStall),
                         .DTLBReady      (DTLBReady),
                         .DTCMRegion     (DTCMRegion),
                         .DCRegion       (DCRegion),
                         .DNCBRegion     (DNCBRegion),
                         .DNCNBRegion    (DNCNBRegion),
                         .DtoITCM        (DtoITCM),
                         .DMMUAbort      (DMMUAbort),
                         .ILookupStall   (ILookupStall),
                         .ITLBReady      (ITLBReady),
                         .ITCMRegion     (ITCMRegion),
                         .ICRegion       (ICRegion),
                         .INCRegion      (INCRegion),
                         .IMMUAbort      (IMMUAbort),
                         .IEXTReady      (IEXTReady),
                         .IEXTError      (IEXTError),
                         .IEXTNoFinish   (IEXTNoFinish),
                         .IEXTBlocked    (IEXTBlocked),
                         .IEXTIdle       (IEXTIdle),
                         .DEXTReady      (DEXTReady),
                         .DEXTError      (DEXTError),
                         .DEXTNoFinish   (DEXTNoFinish),
                         .DEXTBlocked    (DEXTBlocked),
                         .DEXTIdle       (DEXTIdle),
                         .DTCMReady      (DTCMReady),
                         .DTCMBUSY       (DTCMBUSY),
                         .ITCMReady      (ITCMReady),
                         .ITCMBUSY       (ITCMBUSY),
                         .DCReady        (DCReady),
                         .DCNoFinish     (DCNoFinish),
                         .DCIdle         (DCIdle),
                         .ICReady        (ICReady),
                         .ICNoFinish     (ICNoFinish),
                         .ICIdle         (ICIdle),
                         .CP15Idle       (CP15Idle),
                         .LDCinME        (LDCinME),
                         .STCinME        (STCinME),
                         .MCRinME        (MCRinME),
                         .MRCinME        (MRCinME),
                         .CPBURSTEX      (CPBURSTEX[3:0]),
                         .CP15Active     (CP15Active),
                         .CP15IHazard    (CP15IHazard),
                         .CP15IPrefetch  (CP15IPrefetch),
                         .CP15WFI        (CP15WFI),
                         .CP15DWB        (CP15DWB),
                         .TraceMaskIRQ   (TCIRQNoStall),
                         .TraceMaskFIQ   (TCFIQNoStall),
                         .SampleInt      (SampleInt),
                         .ForceNCNB      (ForceNCNB),
			 .BIGEND         (BIGEND),
                         .DBIUIdle       (DBIUIdle),
                         .IBIUIdle       (IBIUIdle),
                         .FIFOFULL       (iFIFOFULL),
                         .nFIQ           (inFIQ),
                         .nIRQ           (inIRQ),
                         .nFIQARM9       (nFIQARM9),
                         .nIRQARM9       (nIRQARM9),
                         .EXTEST         (EXTEST));



   a926ejsIRoute uIRoute (//Outputs:
                         .INSTR          (INSTR[31:0]),
                         //Inputs:
                         .GCLK           (GCLK),
                         .INSTRSelICRD   (INSTRSelICRD),
                         .INSTRSelIEXTRD (INSTRSelIEXTRD),
                         .INSTRSelITCMRD (INSTRSelITCMRD),
                         .INSTRSelHold   (INSTRSelHold),
                         .INSTRCapture   (INSTRCapture),
                         .ICRD           (ICRD[31:0]),
                         .IEXTRD         (IEXTRD[31:0]),
                         .ITCMRD         (ITCMRD[31:0]));

   a926ejsDRoute uDRoute (//Outputs:
                         .RDATA         (RDATA[31:0]),
                         .CP15WD        (CP15WD[31:0]),
                         .DEXTWD        (DEXTWD[31:0]),
                         .DCWD          (DCWD[31:0]),
                         .DTCMWD        (DTCMWD[31:0]),
                         .ITCMWD        (ITCMWD[31:0]),
                         //Inputs:
                         .GCLK          (GCLK),
                         .RDSelCP15RD   (RDSelCP15RD),
                         .RDSelDCRD     (RDSelDCRD),
                         .RDSelDEXTRD   (RDSelDEXTRD),
                         .RDSelDTCMRD   (RDSelDTCMRD),
                         .RDSelITCMRD   (RDSelITCMRD),
                         .RDSelHold     (RDSelHold),
                         .RDCapture     (RDCapture),
                         .WDSelCP15RD   (WDSelCP15RD),
                         .WDSelWDATA    (WDSelWDATA),
                         .CPWDSelWDATA  (CPWDSelWDATA),
                         .CPWDSelDCRD   (CPWDSelDCRD),
                         .CPWDSelDEXTRD (CPWDSelDEXTRD),
                         .CPWDSelDTCMRD (CPWDSelDTCMRD),
                         .CPWDSelITCMRD (CPWDSelITCMRD),
                         .CPWDSelHold   (CPWDSelHold),
                         .CPWDCapture   (CPWDCapture),
                         .DEXTRD        (DEXTRD[31:0]),
                         .DCRD          (DCRD[31:0]),
                         .DTCMRD        (DTCMRD[31:0]),
                         .ITCMRD        (ITCMRD[31:0]),
                         .CP15RD        (CP15RD[31:0]),
                         .WDATA         (WDATA[31:0]));

   a926ICache uICache (
     //Outputs:
     .ICIdle            (ICIdle),
     .ICNoFinish        (ICNoFinish),
     .ICReady           (ICReady),
     .ICRD              (ICRD[31:0]),
     .ICACHEBIUReq      (ICACHEBIUReq),
     .ICACHEBIUEarlyReq (ICACHEBIUEarlyReq),
     .ICACHEBIUA        (ICACHEBIUA[31:0]),
     .ICACHEBIUBurst    (ICACHEBIUBurst[2:0]),
     .ICACHEBIUWrap     (ICACHEBIUWrap),
     .ICACHEBIUPriv     (ICACHEBIUPriv),
     .ICCP15Ready       (ICCP15Ready),
     .ICsize            (ICsize[3:0]),
     .ICassoc           (ICassoc[2:0]),
     .ICMbit            (ICMbit),
     //Inputs:
     .ICClk             (ICClk),
     .ICnReset          (RESETn),
     .ICMREQ            (ICMREQ),
     .ICSEQ             (ICSEQ),
     .ICCancel          (ICCancel),
     .IPrivileged       (IPrivileged),
     .IVA               (IVA[31:0]),
     .IMVA              (IMVA[31:25]),
     .RawIMVA           (RawIMVA[31:25]),
     .IPA               (IPA[31:10]),
     .ICACHEBIUAck      (ICACHEBIUAck),
     .ICACHEBIUReady    (ICACHEBIUReady),
     .IBIURD            (IBIURD[31:0]),
     .ICnWayAlloc       (ICnWayAlloc[3:0]),
     .ICNoLinefill      (ICNoLineFill),
     .ICNoRRgen         (ICNoRRgen),              // RR bits in valid RAM
     .RRBIT             (RRBIT),
     .InvalMicroTag     (InvalMicroTAG),
     .ICCP15Req         (ICCP15Req),
     .CacheOp           (CacheOp[3:0]),
     .ICACHESIZE        (ICACHESIZE[3:0]),            

     .ICBISTEN          (ICBISTEN),
     .ICBISTA           (ICBISTA[12:0]),
     .ICBISTTAGCS       (ICBISTTAGCS[3:0]),
     .ICBISTDATACS      (ICBISTDATACS[3:0]),
     .ICBISTVALIDCS     (ICBISTVALIDCS),

     .ICTAGCS           (ICTAGCS[3:0]),
     .ICTAGA            (ICTAGA[10:0]),
     .ICTAGWE           (ICTAGWE[3:0]),
     .ICTAGRD0          (ICTAGRD0[21:0]),
     .ICTAGRD1          (ICTAGRD1[21:0]),
     .ICTAGRD2          (ICTAGRD2[21:0]),
     .ICTAGRD3          (ICTAGRD3[21:0]),
     .ICTAGWD           (ICTAGWD[21:0]),

     .ICDATACS          (ICDATACS[3:0]),
     .ICDATAINDEX       (ICDATAINDEX[9:0]),
     .ICDATAWORDB0      (ICDATAWORDB0[2:0]),
     .ICDATAWORDB1      (ICDATAWORDB1[2:0]),
     .ICDATAWORDB2      (ICDATAWORDB2[2:0]),
     .ICDATAWORDB3      (ICDATAWORDB3[2:0]),
     .ICDATABYTEWE      (ICDATABYTEWE[3:0]),
     .ICDATARD0         (ICDATARD0[31:0]),
     .ICDATARD1         (ICDATARD1[31:0]),
     .ICDATARD2         (ICDATARD2[31:0]),
     .ICDATARD3         (ICDATARD3[31:0]),
     .ICDATAWD0         (ICDATAWD0[31:0]),
     .ICDATAWD1         (ICDATAWD1[31:0]),
     .ICDATAWD2         (ICDATAWD2[31:0]),
     .ICDATAWD3         (ICDATAWD3[31:0]),

     .ICVALIDCS         (ICVALIDCS),
     .ICVALIDA          (ICVALIDA[7:0]),
     .ICVALIDWE         (ICVALIDWE),
     .ICVALIDRD         (ICVALIDRD[23:0]),
     .ICVALIDWD         (ICVALIDWD[23:0])
   );

   a926DCache uDCache(
     .DCClk             (DCClk),
     .DCnReset          (RESETn),

     .DCIdle            (DCIdle),
     .DCNoFinish        (DCNoFinish),
     .DCReady           (DCReady),
     .DCMREQ            (DCMREQ),
     .DCSEQ             (DCSEQ),
     .DCnRW             (DCnRW),
     .DCMAS             (DCMAS[1:0]),
     .DCCancel          (DCCancel),
     .DPrivileged       (DPrivileged),
     .DVA               (DVA[31:0]),
     .DMVA              (DMVA[31:25]),
     .RawDMVA           (RawDMVA[31:25]),
     .DPA               (DPA[31:10]),
     .Writeback         (Writeback),
     .DontCommit        (DontCommit),
     .DCRD              (DCRD[31:0]),
     .DCWD              (DCWD[31:0]),
     
     .DCACHEBIUEarlyReq (DCACHEBIUEarlyReq),
     .DCACHEBIUReq      (DCACHEBIUReq),
     .DCACHEBIUA        (DCACHEBIUA[31:0]),
     .DCACHEBIUBurst    (DCACHEBIUBurst[2:0]),
     .DCACHEBIUnRW      (DCACHEBIUnRW),
     .DCACHEBIUWrap     (DCACHEBIUWrap),
     .DCACHEBIUPriv     (DCACHEBIUPriv),
     .DCACHEBIUWD       (DCACHEBIUWD[31:0]),
     .DCACHEBIUAck      (DCACHEBIUAck),
     .DCACHEBIUNextWD   (DCACHEBIUNextWD),
     .DCACHEBIUReady    (DCACHEBIUReady),
     .DBIURD            (DBIURD[31:0]),

     .DCnWayAlloc       (DCnWayAlloc[3:0]),
     .DCNoLinefill      (DCNoLineFill),
     .BIGEND            (SysBIGEND),
     .RRBIT             (RRBIT),
     .DisableWriteback  (DisableWriteback),
     .InvalMicroTag     (InvalMicroTAG),
     .DCCP15Req         (DCCP15Req),
     .CacheOp           (CacheOp[3:0]),
     .DCCP15Ready       (DCCP15Ready),
     .DCDirty           (DCDirty),
     .DCACHESIZE        (DCACHESIZE[3:0]),          
     .DCsize            (DCsize[3:0]),
     .DCassoc           (DCassoc[2:0]),
     .DCMbit            (DCMbit),

     .DCBISTEN          (DCBISTEN),
     .DCBISTA           (DCBISTA[12:0]),
     .DCBISTTAGCS       (DCBISTTAGCS[3:0]),
     .DCBISTDATACS      (DCBISTDATACS[3:0]),
     .DCBISTVALIDCS     (DCBISTVALIDCS),
     .DCBISTDIRTYCS     (DCBISTDIRTYCS),

     .DCTAGCS           (DCTAGCS[3:0]),
     .DCTAGA            (DCTAGA[10:0]),
     .DCTAGWE           (DCTAGWE[3:0]),
     .DCTAGRD0          (DCTAGRD0[21:0]),
     .DCTAGRD1          (DCTAGRD1[21:0]),
     .DCTAGRD2          (DCTAGRD2[21:0]),
     .DCTAGRD3          (DCTAGRD3[21:0]),
     .DCTAGWD           (DCTAGWD[21:0]),

     .DCDATACS          (DCDATACS[3:0]),
     .DCDATAINDEX       (DCDATAINDEX[9:0]),
     .DCDATAWORDB0      (DCDATAWORDB0[2:0]),
     .DCDATAWORDB1      (DCDATAWORDB1[2:0]),
     .DCDATAWORDB2      (DCDATAWORDB2[2:0]),
     .DCDATAWORDB3      (DCDATAWORDB3[2:0]),
     .DCDATABYTEWE      (DCDATABYTEWE[3:0]),
     .DCDATARD0         (DCDATARD0[31:0]),
     .DCDATARD1         (DCDATARD1[31:0]),
     .DCDATARD2         (DCDATARD2[31:0]),
     .DCDATARD3         (DCDATARD3[31:0]),
     .DCDATAWD0         (DCDATAWD0[31:0]),
     .DCDATAWD1         (DCDATAWD1[31:0]),
     .DCDATAWD2         (DCDATAWD2[31:0]),
     .DCDATAWD3         (DCDATAWD3[31:0]),

     .DCVALIDCS         (DCVALIDCS),
     .DCVALIDA          (DCVALIDA[7:0]),
     .DCVALIDWE         (DCVALIDWE),
     .DCVALIDRD         (DCVALIDRD[23:0]),
     .DCVALIDWD         (DCVALIDWD[23:0]),
     .DCNoRRgen         (DCNoRRgen),

     .DCDIRTYCS         (DCDIRTYCS),
     .DCDIRTYA          (DCDIRTYA[9:0]),
     .DCDIRTYWE         (DCDIRTYWE[7:0]),
     .DCDIRTYRD         (DCDIRTYRD[7:0]),
     .DCDIRTYWD         (DCDIRTYWD[7:0])
   );

//synopsys translate_off


   a926ejsSysDebug uSysDebug (//Outputs:
                             //Inputs:
                             .CLK     (CLK),
                             .CLKEN   (CLKEN),
                             .HRESETn (RESETn),
                             .InMREQ  (InMREQ),
                             .ISEQ    (ISEQ),
                             .IKILL   (IKILL),
                             .ITBIT   (ITBIT),
                             .IJBIT   (IJBIT),
                             .IA      (IA[31:0]),
                             .INSTR   (INSTR[31:0]),
                             .CPINSTR (CPINSTR[31:0]),
                             .ICRD    (ICRD[31:0]),
                             .ITCMRD  (ITCMRD[31:0]),
                             .IEXTRD  (IEXTRD[31:0]),
                             .IBIURD  (IBIURD[31:0]),
                             .CHSD    (CHSD[1:0]),
                             .CHSE    (CHSE[1:0]),
                             .CHSDE   (iCHSDE[1:0]),
                             .CHSEX   (iCHSEX[1:0]),                                
                             .IEXTBIUReady    (IEXTBIUReady),
                             .IEXTBlocked     (IEXTBlocked),
                             .DEXTBIUReady    (DEXTBIUReady),
                             .DEXTBlocked     (DEXTBlocked),
			     .DTCMReady       (DTCMReady),
			     .ITCMReady       (ITCMReady),
			      
			     .DRnRW         (DRnRW),
			     .DRADDR        (DRADDR[17:0]),
			     .DRWD          (DRWD[31:0]),
			     .DRRD          (DRRD[31:0]),			      
			     .DRIDLE        (DRIDLE),
			     .DRCS          (DRCS),
			     .DRWBL         (DRWBL[3:0]),
			     .DRSEQ         (DRSEQ),
			     .DRWAIT        (DRWAIT),
			     .DRDMAEN       (DRDMAEN),
			     .DRDMAADDR     (DRDMAADDR[17:0]),
			     .DRDMACS       (DRDMACS),
			      
			     .IRnRW         (IRnRW),
			     .IRADDR        (IRADDR[17:0]),
			     .IRWD          (IRWD[31:0]),
			     .IRRD          (IRRD[31:0]),			      
			     .IRIDLE        (IRIDLE),
			     .IRCS          (IRCS),
			     .IRWBL         (IRWBL[3:0]),
			     .IRSEQ         (IRSEQ),
			     .IRWAIT        (IRWAIT),
			     .IRDMAEN       (IRDMAEN),
			     .IRDMAADDR     (IRDMAADDR[17:0]),
			     .IRDMACS       (IRDMACS)

);


//synopsys translate_on

   a926ejsMMU uMMU (//Outputs:
                   .MMUIdle       (MMUIdle),
                   .MMUBIUReq     (MMUBIUReq),
                   .MMUBIUA       (MMUBIUA[31:0]),
                   .MMUBIUDnI     (MMUBIUDnI),
                   .MMUCP15Ready  (MMUCP15Ready),
                   .MMUREGRD      (MMUREGRD[31:0]),
                   .IUTLBready    (IUTLBready),
                   .IUTLBmatch    (IUTLBmatch),
                   .IUTLBload     (IUTLBload),
                   .IUTLBcbL1     (IUTLBcbL1[1:0]),
                   .IUTLBcbL2     (IUTLBcbL2[1:0]),
                   .DUTLBready    (DUTLBready),
                   .DUTLBmatch    (DUTLBmatch),
                   .DUTLBload     (DUTLBload),
                   .DUTLBcbL1     (DUTLBcbL1[1:0]),
                   .DUTLBcbL2     (DUTLBcbL2[1:0]),
                   .UTLBabort     (UTLBabort),
                   .UTLBdfault    (UTLBdfault),
                   .UTLBdomain    (UTLBdomain[3:0]),
                   .UTLBcommit    (UTLBcommit),
                   .UTLBpa        (UTLBpa[31:10]),
                   .UTLBclient    (UTLBclient),
                   .UTLBap        (UTLBap[1:0]),
                   .UTLBsize      (UTLBsize[3:0]),
                   .UTLBregion    (UTLBregion[1:0]),
                   .UTLBpage      (UTLBpage),
                   .ITCMen        (ITCMEn),
                   .DTCMen        (DTCMEn),
                   .MMUxADDR      (MMUxADDR[4:0]),
                   .MMUxWD        (MMUxWD[111:0]),
                   .MMUxCS        (MMUxCS),
                   .MMUxWE        (MMUxWE[3:0]),
                   //Inputs:
                   .MMUClk        (MMUClk),
                   .MMUnReset     (RESETn),
                   .DRSIZE        (iDRSIZE[3:0]),
                   .IRSIZE        (iIRSIZE[3:0]),
                   .ICacheEn      (ICacheEn),
                   .ROMProt       (ROMProt),
                   .SysProt       (SysProt),
                   .DCacheEn      (DCacheEn),
                   .MMUEn         (MMUEn),
                   .MMUdisDCenbBHV(MMUdisDCenbBHV),
                   .INITRAM       (iINITRAM),
                   .AbortDTLBMiss (AbortDTLBMiss),
                   .AbortITLBMiss (AbortITLBMiss),
                   .MMUBIUErr     (MMUBIUErr),
                   .MMUBIUAck     (MMUBIUAck),
                   .MMUBIUReady   (MMUBIUReady),
                   .BIURD         (DBIURD[31:0]),
                   .MMUCP15Req    (MMUCP15Req),
                   .MMUOP         (MMUOp[10:0]),
                   .MMUREGWD      (DBGWD[31:0]),
                   .IUTLBreq      (IUTLBreq),
                   .IMVA          (IMVA[31:10]),
                   .IUTLBabort    (IUTLBabort),
                   .IUTLBidleabort(IUTLBidleabort),
                   .IUTLBfs       (IUTLBfs[7:0]),
                   .IUTLBntrans   (IUTLBntrans),
                   .IUTLBlock     (IUTLBlock),
                   .IUTLBnrw      (IUTLBnrw),
                   .DUTLBreq      (DUTLBreq),
                   .DMVA          (DMVA[31:0]),
                   .DUTLBidleabort(DUTLBidleabort),
                   .DUTLBabort    (DUTLBabort),
                   .DUTLBfs       (DUTLBfs[7:0]),
                   .DUTLBntrans   (DUTLBntrans),
                   .DUTLBlock     (DUTLBlock),
                   .DUTLBnrw      (DUTLBnrw),
                   .MMUxRD        (MMUxRD[111:0]));

   a926ejsUTLB uDuTLB (
     .GCLK             (GCLK),
     .UTLBnReset       (RESETn),
     .UTLBreadyout     (DTLBReady),
     .LookupStall      (DLookupStall),
     .SysCLKEN         (SysCLKEN),
     .CacheEn          (DCacheEn),
     .SysProt          (SysProt),
     .ROMProt          (ROMProt),
     .AlignCheck       (AlignCheck),
     .UTLBreq          (DUTLBreq),
     .UTLBreadyin      (DUTLBready),
     .UTLBidleabortout (DUTLBidleabort),
     .UTLBabortout     (DUTLBabort),
     .UTLBfs           (DUTLBfs[7:0]),
     .UTLBntrans       (DUTLBntrans),
     .UTLBlock         (DUTLBlock),
     .UTLBnrw          (DUTLBnrw),
     .UTLBabortin      (UTLBabort),
     .UTLBdfault       (UTLBdfault),
     .UTLBdomain       (UTLBdomain[3:0]),
     .UTLBcommit       (UTLBcommit),
     .UTLBpa           (UTLBpa[31:10]),
     .UTLBclient       (UTLBclient),
     .UTLBap           (UTLBap[1:0]),
     .UTLBsize         (UTLBsize[3:0]),
     .UTLBcbL1         (DUTLBcbL1[1:0]),
     .UTLBcbL2         (DUTLBcbL2[1:0]),
     .UTLBregion       (UTLBregion[1:0]),
     .UTLBpage         (UTLBpage),
     .A                (DA[31:0]),
     .nMREQ            (DnMREQ),
     .nRW              (DnRW),
     .MAS              (DMAS[1:0]),
     .SEQ              (DSEQ),
     .LOCK             (DLOCK),
     .nTRANS           (DnTRANS),
     .KILL             (DKILL),
     .ABORT            (DABORT),
     .PA               (DPA[31:0]),
     .CP15prefetch     (1'b0),
     .TCMregion        (DTCMRegion),
     .TCMnewpage       (DTCMNewPage),
     .TCMpagesize      (DTCMPageSize[3:0]),
     .DtoITCM          (DtoITCM),
     .Cregion          (DCRegion),
     .Writeback        (Writeback),
     .NCBregion        (DNCBRegion),
     .NCNBregion       (DNCNBRegion),
     .MMUabort         (DMMUAbort),
     .ExtAbort         (DExtAbort),
     .L2Cacheable      (DL2Cacheable),
     .L2Bufferable     (DL2Bufferable),
     .UTLBinvalidate   (InvalMicroTLB),
     .UTLBmatch        (DUTLBmatch),
     .UTLBload         (DUTLBload)
   );


   a926ejsUTLB uIuTLB (
     .GCLK             (GCLK),
     .UTLBnReset       (RESETn),
     .UTLBreadyout     (ITLBReady),
     .LookupStall      (ILookupStall),
     .SysCLKEN         (SysCLKEN),
     .CacheEn          (ICacheEn),
     .SysProt          (SysProt),
     .ROMProt          (ROMProt),
     .AlignCheck       (1'b0),
     .UTLBreq          (IUTLBreq),
     .UTLBreadyin      (IUTLBready),
     .UTLBidleabortout (IUTLBidleabort),
     .UTLBabortout     (IUTLBabort),
     .UTLBfs           (IUTLBfs[7:0]),
     .UTLBntrans       (IUTLBntrans),
     .UTLBlock         (IUTLBlock),
     .UTLBnrw          (IUTLBnrw),
     .UTLBabortin      (UTLBabort),
     .UTLBdfault       (UTLBdfault),
     .UTLBdomain       (UTLBdomain[3:0]),
     .UTLBcommit       (UTLBcommit),
     .UTLBpa           (UTLBpa[31:10]),
     .UTLBclient       (UTLBclient),
     .UTLBap           (UTLBap[1:0]),
     .UTLBsize         (UTLBsize[3:0]),
     .UTLBcbL1         ({IUTLBcbL1[1],1'b0}),
     .UTLBcbL2         (IUTLBcbL2[1:0]),
     .UTLBregion       (UTLBregion[1:0]),
     .UTLBpage         (UTLBpage),
     .A                (IA[31:0]),
     .nMREQ            (InMREQ),
     .nRW              (1'b0),
     .MAS              (2'b10),
     .SEQ              (ISEQ),
     .LOCK             (1'b0),
     .nTRANS           (InTRANS),
     .KILL             (IKILL),
     .ABORT            (IABORT),
     .PA               (IPA[31:0]),
     .CP15prefetch     (CP15IPrefetch),
     .TCMregion        (ITCMRegion),
     .TCMnewpage       (ITCMNewPage),
     .TCMpagesize      (ITCMPageSize[3:0]),
     .DtoITCM          (),
     .Cregion          (ICRegion),
     .Writeback        (),
     .NCBregion        (),
     .NCNBregion       (INCRegion),
     .MMUabort         (IMMUAbort),
     .ExtAbort         (IExtAbort),
     .L2Cacheable      (IL2Cacheable),
     .L2Bufferable     (),
     .UTLBinvalidate   (InvalMicroTLB),
     .UTLBmatch        (IUTLBmatch),
     .UTLBload         (IUTLBload)
   );

   a926ejsTCM uTCM (//Outputs:
                   .ITCMReady     (ITCMReady),
                   .ITCMRD        (ITCMRD[31:0]),
                   .ITCMBUSY      (ITCMBUSY),
                   .IRADDR        (IRADDR[17:0]),
                   .IRWD          (IRWD[31:0]),
                   .IRCS          (IRCS),
                   .IRWBL         (iIRWBL[3:0]),
                   .IRSEQ         (iIRSEQ),
                   .IRnRW         (iIRnRW),
                   .IRIDLE        (iIRIDLE),
                   .DTCMReady     (DTCMReady),
                   .DTCMRD        (DTCMRD[31:0]),
                   .DTCMBUSY      (DTCMBUSY),
                   .DRADDR        (DRADDR[17:0]),
                   .DRWD          (DRWD[31:0]),
                   .DRCS          (DRCS),
                   .DRWBL         (iDRWBL[3:0]),
                   .DRSEQ         (iDRSEQ),
                   .DRnRW         (iDRnRW),
                   .DRIDLE        (iDRIDLE),
                   //Inputs:
                   .GCLK          (GCLK),
                   .ITCMSelIAHeld (ITCMSelIAHeld),
                   .DTCMSelDAHeld (DTCMSelDAHeld),
                   .ITCMSampleIA  (ITCMSampleIA),
                   .DTCMSampleDA  (DTCMSampleDA),
                   .ITCMNewPage   (ITCMNewPage),
                   .DTCMNewPage   (DTCMNewPage),
                   .DtoITCM       (DtoITCM),
                   .DtoISelDPA    (DtoISelDPA),
                   .IA            (IA[19:0]),
                   .DA            (DA[19:0]),
                   .IPA           (IPA[19:10]),
                   .DPA           (DPA[19:10]),
                   .DTCMPageSize  (DTCMPageSize[3:0]),
                   .ITCMPageSize  (ITCMPageSize[3:0]),
                   .BIGEND        (SysBIGEND),
                   .ITCMClk       (ITCMClk),
                   .ITCMnReset    (RESETn),
                   .ITCMCancel    (ITCMCancel),
                   .ITCMSEQ       (ITCMSEQ),
                   .ITCMWRREQ     (ITCMWRREQ),
                   .ITCMRDREQ     (ITCMRDREQ),
                   .ITCMnRW       (ITCMnRW),
                   .ITCMAS        (ITCMAS[1:0]),
                   .ITCMWD        (ITCMWD[31:0]),
                   .ITCMNoReq     (ITCMNoReq),
                   .IRRD          (iIRRD[31:0]),
                   .IRWAIT        (IRWAIT),
                   .DTCMClk       (DTCMClk),
                   .DTCMnReset    (RESETn),
                   .DTCMCancel    (DTCMCancel),
                   .DTCMSEQ       (DTCMSEQ),
                   .DTCMWRREQ     (DTCMWRREQ),
                   .DTCMRDREQ     (DTCMRDREQ),
                   .DTCMnRW       (DTCMnRW),
                   .DTCMAS        (DTCMAS[1:0]),
                   .DTCMWD        (DTCMWD[31:0]),
                   .DTCMNoReq     (DTCMNoReq),
                   .DRRD          (iDRRD[31:0]),
                   .DRWAIT        (DRWAIT),
                   .DRDMAEN       (iDRDMAEN),
                   .IRDMAEN       (iIRDMAEN),
                   .DRDMAADDR     (iDRDMAADDR[17:0]),
                   .IRDMAADDR     (iIRDMAADDR[17:0]),
                   .DRDMACS       (iDRDMACS),
                   .IRDMACS       (iIRDMACS),
                   .INTEST        (INTEST),
                   .EXTEST        (EXTEST));


endmodule // ARM926EJSCore

