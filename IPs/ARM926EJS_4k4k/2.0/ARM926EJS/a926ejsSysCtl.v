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
// File Name           : a926ejsSysCtl.v,v
// File Revision       : 1.33
//
// Release Information : ARM926EJS_r0p5-00rel0
// -------------------------------------------------------------------------

`timescale 1 ns / 10 ps

`include "smt_debug.vh"


module a926ejsSysCtl(

 GCLK,  
 CLK,  
 SnReset, 
 InMREQ,  
 IKILL,   
 InTRANS, 
 ISEQ,  
 DnMREQ,  
 DKILL,   
 DBURST,  
 DMORE,   
 DnRW,    
 DMAS,    
 DnTRANS, 
 DLOCK,   
 CLKEN,   
 ETMInMREQ,
 ETMIKILL,
 PASS,    
 DBGRQI,
 EDBGRQ,
 DBGACK,
 DBGSCREG,
 DBGTCKEN,
 nFIQARM9,
 nIRQARM9,
 FCSESampleIA, 
 FCSESampleDA, 
 DVASelDAHeld, 
 IVASelIAHeld, 
 DAME,         
 IAFE,
 SysCLKEN,     
 MMUIdle,      
 DTCMEn,
 ITCMEn,
 DLookupStall, 
 DTLBReady,    
 DTCMRegion,   
 DCRegion,     
 DNCBRegion,   
 DNCNBRegion,  
 DtoITCM,      
 DMMUAbort,    
 DExtAbort,    
 ILookupStall, 
 ITLBReady,    
 ITCMRegion,   
 ICRegion,     
 INCRegion,    
 IMMUAbort,    
 IExtAbort,    
 IEXTMREQ,     
 IEXTSEQ,      
 IEXTCancel,   
 IPrivileged,  
 IEXTReady,    
 IEXTError,    
 IEXTNoFinish, 
 IEXTBlocked,  
 IEXTIdle,
 DEXTMREQ,     
 DEXTSEQ,      
 DEXTBURST,
 DEXTnRW,      
 DEXTMAS,      
 DEXTBuffered, 
 DEXTCached,   
 DEXTCancel,   
 DPrivileged,  
 DEXTSwap,     
 DEXTReady,    
 DEXTError,    
 DEXTNoFinish, 
 DEXTBlocked,  
 DEXTIdle,     
 DTCMRDREQ,    
 DTCMWRREQ,    
 DTCMSEQ,      
 DTCMnRW,      
 DTCMAS,       
 DTCMCancel,   
 DTCMNoReq,    
 DTCMReady,    
 DTCMBUSY,     
 ITCMRDREQ,    
 ITCMWRREQ,    
 ITCMSEQ,      
 ITCMnRW,      
 ITCMAS,       
 ITCMCancel,   
 ITCMNoReq,    
 ITCMReady,    
 ITCMBUSY,     
 DtoISelDPA,    
 ITCMSampleIA, 
 DTCMSampleDA, 
 DTCMSelDAHeld,
 ITCMSelIAHeld,
 DCMREQ,       
 DCSEQ,        
 DCnRW,        
 DCMAS,        
 DCCancel,     
 DCReady,      
 DCNoFinish,   
 DCIdle,       
 ICMREQ,       
 ICSEQ,        
 ICCancel,     
 ICReady,      
 ICNoFinish,   
 ICIdle,       
 CP15Idle,
 CP15CLKEN,    
 LDCinME,      
 STCinME,      
 MCRinME,      
 MRCinME,      
 CP15Active,
 CP15IHazard,  
 CP15IPrefetch,
 IPrefetchDone,
 CP15WFI,      
 CP15WFIDone,  
 CP15DWB,      
 CP15DWBDone,  
 TraceMaskIRQ, 
 TraceMaskFIQ, 
 SampleInt,
 ForceNCNB,
 BIGEND,
 DBIUIdle,     
 IBIUIdle,     
 FIFOFULL,    
 nFIQ,        
 nIRQ,        
 EXTEST,
 STANDBYWFI,  
 CFGBIGEND,
 SysBIGEND,
 CPBURSTEX,
 RDSelCP15RD,   
 RDSelDCRD,     
 RDSelDEXTRD,   
 RDSelDTCMRD,   
 RDSelITCMRD,   
 RDSelHold,     
 RDCapture,     
 WDSelCP15RD,   
 WDSelWDATA,    
 CPWDSelWDATA,  
 CPWDSelDCRD,   
 CPWDSelDEXTRD, 
 CPWDSelDTCMRD, 
 CPWDSelITCMRD, 
 CPWDSelHold,   
 CPWDCapture, 
 INSTRSelICRD,  
 INSTRSelIEXTRD,
 INSTRSelITCMRD,
 INSTRSelHold,  
 INSTRCapture,  
 WFIWakeUp,
 ICClkEn,       
 DCClkEn,       
 ITCMClkEn,     
 DTCMClkEn,     
 IEXTClkEn,     
 DEXTClkEn,     
 CP15PipeClkEn, 
 CP15DbgClkEn,  
 ARM9ClkEn,     
 MMUClkEn

);


// clock and reset

input      GCLK;      // same as CLK except stopped during WFI
input      CLK;    
input      SnReset;   // alias for HRESETn

// ARM9EJ-S bus-interfaces

input       InMREQ;    // active low instruction fetch request 
input       IKILL;     // kill previously issued InMREQ
input       InTRANS;   // privileged mode indicator
input       ISEQ;      // sequentiality indicator for InMREQ

input       DnMREQ;    // active low data access request
input       DKILL;     // kill previously issued DnMREQ
input [3:0] DBURST;    // burst size indicator for DnMREQ
input       DMORE;     // more to come indicator for DnMREQ
input       DnRW;      // not read/write
input [1:0] DMAS;      // word/half-word/byte indication
input       DnTRANS;   // privileged mode access
input       DLOCK;     // swap indicator

output      CLKEN;     // combined wait state input for I & D

// ARM9EJ-S pipeline status

input       ETMInMREQ; // indicates instruction boundary (DE)
input       ETMIKILL;  // qualifier for ETMInMREQ (EX)
input       PASS;      // coprocessor instruction in EX

// ARM9EJ-S debug

input       DBGRQI;    // debug request 
input       EDBGRQ;    // external debug request
input       DBGACK;    // ARM9EJ-S is now in debug state
input [3:0] DBGSCREG;  // currently selected scan chain register
input       DBGTCKEN;  // debug TCK enable 

// ARM9EJ-S interrupts

output      nFIQARM9;  // nFIQ after SampleInt gating
output      nIRQARM9;  // nIRQ after SampleInt gating

// FCSE interface 

output      FCSESampleIA; // capture strobe for IA (new FE)
output      FCSESampleDA; // capture strobe for DA (new ME)
output      DVASelDAHeld; // select captured DA for DVA
output      IVASelIAHeld; // select captured IA for IVA

input [9:2] DAME;         // DA pipelined into ME
input [9:2] IAFE;         // IA pipelined into FE

// MMU and micro-TLBs

output      SysCLKEN;     // alias for CLKEN
input       MMUIdle;      // main MMU clock may be stopped
input       DTCMEn;       // DTCM is enabled
input       ITCMEn;       // ITCM is enabled

input       DLookupStall; // stall generated in uTLB lookup cycle 
input       DTLBReady;    // micro-TLB/MMU ready 
input       DTCMRegion;   // current region is D-TCM
input       DCRegion;     // current region is DCache (WT or WB)
input       DNCBRegion;   // current region is NCB
input       DNCNBRegion;  // current region is NCNB
input       DtoITCM;      // D-side access to I-TCM space
input       DMMUAbort;    // MMU generated abort 
output      DExtAbort;    // external abort for NC read or NB write

input       ILookupStall; // stall generated in uTLB lookup cycle 
input       ITLBReady;    // micro-TLB/MMU ready
input       ITCMRegion;   // current region is I-TCM
input       ICRegion;     // current region is ICache
input       INCRegion;    // current region is I-NC
input       IMMUAbort;    // MMU generated abort
output      IExtAbort;    // external abort for NC I-fetch

// IEXT

output      IEXTMREQ;     // instruction fetch request
output      IEXTSEQ;      // current IEXTMREQ is sequential 
output      IEXTCancel;   // cancel IEXTMREQ issued in previous cycle
output      IPrivileged;  // instruction fetch made in privileged mode

input       IEXTReady;    // fetch data ready or no outstanding request
input       IEXTError;    // external abort 
input       IEXTNoFinish; // indicates IEXTReady cannot be asserted in current cycle
input       IEXTBlocked;  // IEXT blocked pending BIU access (IEXTClk can be stopped)
input       IEXTIdle;     // IEXT clock can be stopped until the next request is issued

// DEXT

output       DEXTMREQ;     // memory request
output       DEXTSEQ;      // DEXTMREQ is sequential
output [3:0] DEXTBURST;    // number of words to transfer
output       DEXTnRW;      // not read/write
output [1:0] DEXTMAS;      // byte/half-word/word
output       DEXTBuffered; // L1 & L2 bufferable
output       DEXTCached;   // L1 & L2 bufferable
output       DEXTCancel;   // cancel DEXTMREQ issued in previous cycle
output       DPrivileged;  // DnTRANS pipelined into ME
output       DEXTSwap;     // DLOCK pipelined into ME

input        DEXTReady;    // read data ready/write completed/no outstanding request
input        DEXTError;    // external abort on NC read or NB write
input        DEXTNoFinish; // indicates DEXTReady cannot be asserted in current cycle
input        DEXTBlocked;  // DEXT blocked pending BIU access (DEXTClk clock can be stopped)
input        DEXTIdle;     // DEXT clock can be stopped until the next request is issued

// DTCM

output       DTCMRDREQ;    // read memory request
output       DTCMWRREQ;    // write memory request
output       DTCMSEQ;      // DTCMXXREQ is sequential 
output       DTCMnRW;      // not read/write 
output [1:0] DTCMAS;       // word/half-word/byte
output       DTCMCancel;   // Cancel DTCMXXREQ issued in previous cycle
output       DTCMNoReq;    // indicates no DTCM request will be issued in current cycle

input        DTCMReady;    // access completed or no outstanding request
input        DTCMBUSY;     // DTCM is not idle

// ITCM

output       ITCMRDREQ;    // read memory request
output       ITCMWRREQ;    // write memory request
output       ITCMSEQ;      // ITCMXXREQ is sequential 
output       ITCMnRW;      // not read/write 
output [1:0] ITCMAS;       // word/half-word/byte
output       ITCMCancel;   // Cancel ITCMXXREQ issued in previous cycle
output       ITCMNoReq;    // indicates no ITCM request will be issued in current cycle

input        ITCMReady;    // access completed or no outstanding request
input        ITCMBUSY;     // ITCM is not idle

// TCM addresses

output       DtoISelDPA;    // select DPA as source for ITCMA, due to DtoI TCM access
output       ITCMSampleIA; // capture strobe for IA (new FE)
output       DTCMSampleDA; // capture strobe for DA (new ME)
output       DTCMSelDAHeld;// select registered DA for bottom 10 bits of DTCMA
output       ITCMSelIAHeld;// select registered IA for bottom 10 bits of ITCMA

// DCache

output       DCMREQ;       // memory request
output       DCSEQ;        // DCMREQ is sequential to previous DCMREQ
output       DCnRW;        // not read/write
output [1:0] DCMAS;        // word/half-word/byte
output       DCCancel;     // cancel DCMREQ issued in previous cycle

input        DCReady;      // read data ready/write completed/no outstanding request
input        DCNoFinish;   // DCReady cannot be asserted in the current cycle
input        DCIdle;       // DCache is idle, and DCClk may be stopped until next request


// ICache

output       ICMREQ;       // memory request
output       ICSEQ;        // ICMREQ is sequential to previous ICMREQ
output       ICCancel;     // cancel ICMREQ issued in previous cycle

input        ICReady;      // read data ready/no outstanding request
input        ICNoFinish;   // ICReady cannot be asserted in the current cycle
input        ICIdle;       // ICache is idle, and ICClk may be stopped until next request

// endianess 

output       SysBIGEND;    // internal copy of CFGBIGEND for use by memory system

// CP15

input        CP15Idle;     
output       CP15CLKEN;    // alias for CLKEN

input        LDCinME;      // LDC in memory 
input        STCinME;      // STC in memory
input        MCRinME;      // MCR in memory
input        MRCinME;      // MRC in memory
input [3:0]  CPBURSTEX;    // LDC/STC transfer size derived from CPBURST 

input        CP15Active;   // a CP15 instruction is executing
input        CP15IHazard;  // a CP15 instruction has executed

input        CP15IPrefetch;// start of instruction prefetch operation
output       IPrefetchDone;// completion handshake for instruction prefetch operation

input        CP15WFI;      // start of wait-for-interrupt operation
output       CP15WFIDone;  // completion handshake for wait-for-interrupt

input        CP15DWB;      // start of drain writebuffer operation
output       CP15DWBDone;  // completion handshake for drain writebuffer

input        TraceMaskIRQ; // prevent IRQ interrupts from affecting FIFOFULL behaviour
input        TraceMaskFIQ; // prevent FIQ interrupts from affecting FIFOFULL behaviour
input        SampleInt;    // mimick ARM9E-S Rev0 interrupt behaviour (validation only)
input        ForceNCNB;    // force NCB stores to be NCNB
input        BIGEND;       // raw value of CP15 BIGEND bit

// BIU

input        DBIUIdle;     // data side BIU idle (no outstanding AHB accesses)
input        IBIUIdle;     // data side BIU idle (no outstanding AHB accesses)

// ARM926EJ-S macrocell IO

input        FIFOFULL;    // ETM FIFOFULL indicator
input        nFIQ;        // FIQ interrupt, active low
input        nIRQ;        // IRQ interrupt, active high
input        EXTEST;      // EXTEST mode, forces TCMMREQ read requests low


output       STANDBYWFI;  // ARM926EJ-S is in wait-for-interrupt mode
output       CFGBIGEND;   // ARM926EJ-S is in big-endian mode


// DROUTE and IROUTE

output       RDSelCP15RD;   // RDATA <- CP15RD   (MRC)
output       RDSelDCRD;     // RDATA <- DCRD     (LDR etc)
output       RDSelDEXTRD;   // RDATA <- DEXTRD   (LDR etc)
output       RDSelDTCMRD;   // RDATA <- DTCMRD   (LDR etc)
output       RDSelITCMRD;   // RDATA <- ITCMRD   (LDR etc)
output       RDSelHold;     // selecting holding register as RDATA source
output       RDCapture;     // capture value of RDATA in holding register

output       WDSelCP15RD;   // DxxWD <- CP15RD   (STC)
output       WDSelWDATA;    // DxxWD <- WDATA    (STR etc) 

output       CPWDSelWDATA;  // CP15WD <- WDATA   (MCR)
output       CPWDSelDCRD;   // CP15WD <- DCRD    (LDC)
output       CPWDSelDEXTRD; // CP15WD <- DEXTRD  (LDC)
output       CPWDSelDTCMRD; // CP15WD <- DTCMRD  (LDC)
output       CPWDSelITCMRD; // CP15WD <- ITCMRD  (LDC)
output       CPWDSelHold;   // select holding register as CP15WD source
output       CPWDCapture; // capture value of CP15WD in holding register

output       INSTRSelICRD;  // INSTR <- ICRD
output       INSTRSelIEXTRD;// INSTR <- IEXTRD
output       INSTRSelITCMRD;// INSTR <- ITCMRD
output       INSTRSelHold;  // select holding register as INSTR source
output       INSTRCapture;  // capture value of INSTR in holding register


// clock block

output       ICClkEn;         // ICache clock enable (ICClk)
output       DCClkEn;         // DCache clock enable (DCClk)
output       ITCMClkEn;       // ITCM clock enable (ITCMClk)
output       DTCMClkEn;       // DTCM clock enable (DTCMClk)
output       IEXTClkEn;       // IEXT clock enable (IEXTClk)
output       DEXTClkEn;       // DEXT clock enable (DEXTClk)
output       CP15PipeClkEn;   // CP15 pipeline follower clock enable (CP15PipeClk)
output       CP15DbgClkEn;    // CP15 JTAG clock enable (CP15DbgClk)
output       ARM9ClkEn;       // ARM9EJ-S clock enable (ARM9Clk)
output       MMUClkEn;        // MMU clock enable (MMUClk)
output       WFIWakeUp;       // wait-for-interrupt wakeup (FIQ/IRQ or DBGRQI)

// registered outputs
reg          DPrivileged;
reg          IPrivileged;
reg          IPrefetchDone;
reg          CP15WFIDone;
reg          CP15DWBDone;
reg          STANDBYWFI;
reg          WFIWakeUp;
reg          CFGBIGEND;
reg          SysBIGEND;

// registered/qualified versions of ARM9EJ-S bus interface signals

reg          DMREQMENoKill;     // not(DnMREQ) pipelined into ME
wire         DMREQME;           // not(DnMREQ) pipelined into ME, and qualified with DKILL
reg          DMOREME;           // DMORE pipelined into ME
wire         DSEQEX;            // DMREQME and DMOREME
reg          DSEQME;            // DSEQEX pipelined into ME
reg [1:0]    DMASME;            // DMAS pipelined into ME
reg          DnRWME;            // DnRW pipelined into ME
reg          DLOCKME;           // DLOCK pipelined into ME
wire         DFirstWordME;      // non-sequential DnMREQ in ME
wire         DLastWordME;       // last DnMREQ in a burst in ME

reg          IMREQFENoKill;     // not(InMREQ) pipelined into FE
wire         IMREQFE;           // not(InMREQ) pipelined into FE, and qualified with IKILL
reg          pSysCLKEN;         // SysCLKEN pipelined by 1 GCLK cycle

wire         IMREQIssuedCA;     // Either of IEXTMREQ, ICMREQ or ITCMREQ is high
reg          IMREQIssuedFE;     // IMREQIssuedCA pipelined into FE
wire         INonSeqCA;         // None of IEXTSEQ, ICSEQ or ITCMSEQ are high
reg          INonSeqFE;         // INonSeqCA pipelined into FE

reg          pCP15IPrefetch;    // CP15IPrefetch pipelined by 1 GCLK cycle
wire         IPrefetchMREQ;     // pseudo InMREQ equivalent for instruction prefetching
reg          IPrefetchMREQFE;   // IPrefetchMREQ pipelined into pseudo FE
wire         ICPrefetchMREQ;    // ICMREQ term for instruction prefetching

wire         DEXTRegion;        // DRegion is either NCB or NCNB
wire         DuTLBLookup;       // D micro-TLB lookup cycle (1st GCLK cycle of ME)
wire         IuTLBLookup;       // I micro-TLB lookup cycle (1st GCLk cycle of FE)

wire         IRegenEnable;      // enable I-side regenerated request
wire         IEXTRegenMREQ;     // regenerated IEXT request
wire         ICRegenMREQ;       // regenerated ICache request
wire         ITCMRegenMREQ;     // regenerated ITCM request
wire         DRegenEnable;      // enable D-side regenerated request
wire         DtoITCMRegenMREQ;  // regenerated D to ITCM request
wire         DEXTRegenMREQ;     // regenerated DEXT request
wire         DCRegenMREQ;       // regenerated DCache request
wire         DTCMRegenMREQ;     // regenerated DTCM request
wire         DRegenReqIssued;   // a D-side regenerated request has been isssued

wire         EnIEXTCoreMREQ;    // enable InMREQ -> IEXTMREQ
wire         IEXTCoreMREQ;      // IEXTMREQ from InMREQ
wire         EnICCoreMREQ;      // enable InMREQ -> ICMREQ
wire         ICCoreMREQ;        // ICMREQ from InMREQ
wire         EnITCMCoreMREQ;    // enable InMREQ -> ITCMREQ
wire         ITCMCoreMREQ;      // ITCMREQ from InMREQ
wire         EnDEXTCoreMREQ;    // enable DnMREQ -> DEXTMREQ
wire         DEXTCoreMREQ;      // DEXTMREQ from DnMREQ
wire         EnDCCoreMREQ;      // enable DnMREQ -> DCMREQ
wire         DCCoreMREQ;        // DCMREQ from DnMREQ
wire         EnDTCMCoreMREQ;    // enable DnMREQ -> DTCMREQ
wire         DTCMCoreMREQ;      // DTCMREQ from DnMREQ
wire         DTCMREQ;           // read or write DTCM memory request
wire         ITCMREQ;           // read or write ITCM memory request

reg          pDTCMREQ;          // DTCMREQ pipelined by 1 GCLK cycle
reg          pITCMREQ;          // ITCMREQ pipelined by 1 GCLK cycle
reg          pIEXTMREQ;         // IEXTMREQ pipelined by 1 GCLK cycle
reg          pDEXTMREQ;         // DEXTMREQ pipelined by 1 GCLK cycle
reg          pDCMREQ;           // DCMREQ pipelined by 1 GCLK cycle
reg          pICMREQ;           // ICMREQ pipelined by 1 GCLK cycle
reg          pDtoITCMRegenMREQ; // DtoITCMRegenMREQ pipelined by 1 GCLK cycle

wire         DtoITCMAccess;     // A DtoI TCM access is pending
reg          DtoITCMAccessRaw;
wire         NextDtoITCMRaw;
wire         SampleDtoITCMRaw;
reg          pDtoISelDPA;

reg          pIMMUAbort;        // IMMUAbort pipelined by 1 GCLK cycle
reg          pDMMUAbort;        // DMMUAbort pipelined by 1 GCLK cycle

reg          DSysState;         // D-side state machine current state 
reg          ISysState;         // I-side state machine current state 
reg          DNextSysState;     // D-side state machine next state 
reg          INextSysState;     // I-side state machine next state 
wire         DRegenComplete;    // D-side regeneration complete
wire         ITCMComplete;      // possible I-TCM access completed, D to I-TCM access can start

wire         DRegen;            // DSysState == REGEN
wire         IRegen;            // ISysState == REGEN
wire         DorIRegen;         // either of DSysState or ISysState == REGEN

wire         ILastInPageFE;     // fetch in FE is to the last word in the page 
wire         IForceNonSeq;      // force next instruction request to be non-sequential 
reg          pIForceNonSeq;     // IForceNonSeq pipelined by 1 GCLK cycle
wire         SetIForceNonSeq;   // set term for IForceNonSeq
wire         ClrIForceNonSeq;   // clear term for IForceNonSeq
wire         EnISEQ;            // enable ISEQ -> IEXTSEQ, ICSEQ, or ITCMSEQ

wire         DLastInPageME;     // access in ME is to the last word in the page 
wire         DFirstInPageME;    // access in ME is to the first word in the page 
wire         DSingleTransferEX; // current burst value indicates single word (or unknown length)
reg          DSingleTransferME; // DSingleTransferEX pipelined into ME
wire         EnDSEQ;            // enables DSEQEX -> DEXTSEQ, DCSEQ, and DTCMSEQ

wire [3:0]   BURSTEX;           // combined DBURST/CPBURSTEX 
reg  [3:0]   BURSTME;           // BURSTEX pipelined into ME
wire [3:0]   BURST1stEX;        // BURST in 1st EX cycle (DBURST or CPBURSTEX)
wire [4:0]   EndLowerME;        // lower order bits of sum of address + burst size
wire         DNearBoundaryME;   // data side address 16 words or less from boundary
wire         SplitBurstME;      // burst crosses boundary and must be split (1st ME cycle of burst)
wire [3:0]   SplitBurstInitial; // if the burst is split, the 1st half of the burst (before boundary) 
reg  [3:0]   SplitBurstXPage;   // if the burst is split, the 2nd half of the burst (after boundary)
wire [3:0 ]  USplitBurstXPage;  // unregistered SplitBurstXPage
wire [3:0]   BurstRaw;          // raw value of DEXTBURST prior to qualification
wire [3:0]   BurstInitial;      // burst value for 1st ME cycle of transfer
wire         EnDEXTBURST;       // enable non-zero value to be driven onto DEXTBURST
wire [3:0]   EnDEXTBURST4;      // EnDEXTBURST4 replicated 4 times into a bus


wire         ICancelFE;         // raw I-side cancel term (ILookupStall or IMMUAbort or IKILL) 
wire         DCancelME;         // raw D-side cancel term (DLookupStall or DMMUAbort or DKILL)

wire         DTCMIdle;          // DTCM is idle
wire         ITCMIdle;          // ITCM is idle
wire         NoFinish;          // CLKEN will not be asserted in the current cycle
wire         ForceClkEn;        // force block level clocks to be active for CP15 operations
wire         StopARM9Clk;       // stall ARM9Clk low 
wire         StopIEXTClk;       // stall IEXTClk low
wire         StopICClk;         // stall ICClk low
wire         StopITCMClk;       // stall ITCMClk low
wire         StopDEXTClk;
wire         StopDTCMClk;
wire         StopDCClk;
wire         StopCP15PipeClk;   // stall CP15PipeClk low


wire         DEXTPending;
wire         DCPending;
wire         DTCMPending;
wire         DtoITCMPending;
wire         IEXTPending;
wire         ICPending;
wire         ITCMPending;

reg          pIEXTPending;
reg          pICPending;
reg          pITCMPending;
reg          pDEXTPending;
reg          pDCPending;
reg          pDTCMPending;
reg          pDtoITCMPending;

reg          pIEXTReady;
reg          pITCMReady;
reg          pICReady;

reg          pDEXTReady;
reg          pDTCMReady;
reg          pDCReady;

wire         EnDExtAbort;
wire         DExtAbortAccum;
reg          DExtAbortHeld;
wire         DExtWordAborted;
wire         UDExtAbortHeld;
wire         ClrDExtAbortHeld;
wire         IEXTWordAborted;
reg          IExtAbortHeld;
wire         UIExtAbortHeld;
wire         PotentialXAbort;

wire         SysStall;
wire         SysReady;
wire         MMUReady;
wire         WFIStall;
wire         CP15CacheOpStall;
wire         FIFOFULLStall;
wire         EnFIFOFULLStall;
reg          pnIRQ;
reg          pnFIQ;

reg          nFIQCLKEN;        // nFIQ sampled on CLKEN boundary
reg          nIRQCLKEN;        // nIRQ sampled on CLKEN boundary
wire         nFIQdelayed;      // nFIQ or nFIQ delayed until CLKEN boundary 
wire         nIRQdelayed;      // nIRQ or nFIQ delayed until CLKEN boundary 

wire         InstrBoundaryDE;
reg          InstrBoundaryEXNoKill;
wire         InstrBoundaryEX;

wire         UIPrefetchDone;
wire         UCP15DWBDone;
wire         SystemIdle;
wire         UCP15WFIDone;
wire         USTANDBYWFI;
wire         UWFIWakeUp;

reg          EndianStall;      // CLKEN stall due to BIGEND change
wire         UEndianStall;
wire         SetEndianStall;
wire         ClrEndianStall;
wire         EndianChange;
wire         WriteBufHazard;   // endian dependant write buffers are not empty
wire         UpdateCFGBIGEND;  // update strobe for CFGBIGEND
reg          OldBIGEND;        // previous value of BIGEND before CP15 op started
reg          SampleBIGEND;  
wire         USampleBIGEND;  
reg          pCP15Active;      


wire         ScanChain15Sel;  // scan chain 15 is selected (DbgSCREG = 15)


// pseudo memory request for instruction prefetching
// =================================================
//
// The rising edge of CP15IPrefetch is used to trigger
// an instruction side memory request for instruction
// prefetching. IPrefetchMREQ is equivalent to ~InMREQ.

always @(posedge GCLK) begin
  pCP15IPrefetch <= CP15IPrefetch;
end

assign IPrefetchMREQ = CP15IPrefetch & ~pCP15IPrefetch;

always @(posedge GCLK) begin
  if (SysCLKEN) begin
    IPrefetchMREQFE <= IPrefetchMREQ;
  end
end



// D/InMREQ related ME & FE class signals 
// ======================================
//

always @(posedge GCLK) begin
  if (SysCLKEN) begin
    DMREQMENoKill <= ~DnMREQ;
    IMREQFENoKill <= ~InMREQ;
    DMOREME <= DMORE;
    DSEQME <= DSEQEX;
  end
end

assign DMREQME = DMREQMENoKill & ~DKILL;

assign IMREQFE = IMREQFENoKill & ~IKILL;

assign DSEQEX = DMREQME & DMOREME;

assign DFirstWordME = DMREQME & ~DSEQME;

assign DLastWordME = DMREQME & ~DMOREME;


// State machines for I & D sides
// ==============================
//
// There are two identical state machines, one for each side. Only two
// states are used:
//
// LOOKUP
// ------
//  
// LOOKUP indicates the possiblity of a new access having entered 
// into either ME or FE, (FE in this context accounts for both
// normal instruction fetches, and instruction prefetch operations).
//
// The LOOKUP state only indicates a possible new FE or ME cycle. An
// actual new FE or ME cycle will only have begun if
//
// i)  There was a request (InMREQ/DnMREQ/CP15IPrefetch)
//     present in the previous GCLK cycle
//
// ii) CLKEN was high in the previous cycle
//
// Note that DuTLBLookup, and IuTLBLookup signals include the terms
// in i) and ii) above.
//
// REGEN
// -----
//
// REGEN indicates a possible request regeneration cycle. The REGEN
// state is entered when the micro-TLB asserts LookupStall, which 
// indicates either:
//
// i)   A uTLB miss
//
// ii)  A physical address mispredict for a TCM region access
//
// iii) A memory region mispredict 
//
// iv)  A data side access to I-TCM space
// 
// Once the REGEN state has been entered, after the assertion of 
// LookupStall, the state machine will stay in the REGEN state
// until TLBReady is asserted, which indicates that all the
// TLB/uTLB attributes are valid. 
//
// After the TLB has asserted TLBReady, then a request will be
// re-generated unless the access aborted (MMUAbort), or was killed
// by the ARM9EJ-S (D/KILL). For D to I-TCM accesses, the re-generated 
// request cannot be made until the I-TCM has finished any possible 
// instruction fetch activity. The D-side state machine will spin in 
// the REGEN state, until the re-generated request has been issued.
// 


// encodings for DSysState and ISysState

`define LOOKUP 1'b0
`define REGEN  1'b1

always @(posedge GCLK or negedge SnReset) begin
  if (~SnReset) begin
    DSysState <= `LOOKUP;
    ISysState <= `LOOKUP;
  end 
  else begin
    DSysState <= DNextSysState;
    ISysState <= INextSysState;
  end
end

// D-side next state logic

always @(DSysState or DLookupStall or DRegenComplete) begin
  if (DSysState == `LOOKUP) begin 
    if (DLookupStall) 
      DNextSysState = `REGEN;
    else
      DNextSysState = `LOOKUP;
  end
  else begin // in REGEN state
    if (DRegenComplete) 
      DNextSysState = `LOOKUP;
    else
      DNextSysState = `REGEN;
  end
end

// DRegenComplete indicates that either
//
// i)  The regenerated request has been issued on XXMREQ
//
// ii) The access was either killed or aborted
//
// NOTE: Terms i & ii above are only required for DtoI TCM accesses,
// in all other cases DTLBReady would be sufficient, as whether an
// an access is killed or aborted is only required to stop the state
// machine staying in REGEN for DtoI TCM accesses that are killed or
// aborted. In all other cases the transition from REGEN to LOOKUP
// could happen simply when DTLBReady be asserted.


assign DRegenComplete = DTLBReady & (DRegenReqIssued | pDMMUAbort | (DMREQMENoKill & DKILL));

assign DRegenReqIssued = DEXTRegenMREQ | 
                         DCRegenMREQ | 
                         DTCMRegenMREQ | 
                         DtoITCMRegenMREQ;


// I-side next state logic
//
// This is identical to the D-side next state logic, however
// if an I-side request is regenerated it will always be done
// in the first cycle when ITLBReady is asserted, so IRegenComplete
// simply gets replaced with ITLBReady

always @(ISysState or ILookupStall or ITLBReady) begin
  if (ISysState == `LOOKUP) begin 
    if (ILookupStall) 
      INextSysState = `REGEN;
    else
      INextSysState = `LOOKUP;
  end
  else begin // in REGEN state
    if (ITLBReady) 
      INextSysState = `LOOKUP;
    else
      INextSysState = `REGEN;
  end
end

// DRegen/IRegen/DorIRegen are used to indicate that the 
// D/I/either side state machine is in the REGEN state.

assign DRegen = (DSysState == `REGEN);
assign IRegen = (ISysState == `REGEN);
assign DorIRegen = DRegen | IRegen;

// micro-TLB Lookup cycle indication
//
// DuTLBLookup and IuTLBLookup indicate when a micro-TLB lookup
// will take place. This is the first cycle of memory/fetch.

assign DuTLBLookup = DMREQMENoKill & pSysCLKEN;

assign IuTLBLookup = (IMREQFENoKill | IPrefetchMREQFE) & pSysCLKEN;



always @(posedge GCLK) begin
  pDMMUAbort <= DMMUAbort;
  pIMMUAbort <= IMMUAbort;
  pSysCLKEN  <= SysCLKEN;
end


// CMIF Request Generation
// =======================
// 
// The memory requests given to IEXT,ICache,I-TCM, DEXT, DCache and D-TCM
// are all of the form
// 
// XXMREQ <= (not(nMREQ) and (XXEnCoreMREQ)) or RegenXXMREQ
//
//
// XXEnCoreMREQ enables I/DnMREQ to passed combinationally through
// to XXMREQ. This will be done if XX is the currently predicted region
// when the access is issued by the ARM9EJ-S, and CLKEN is high.
//
// RegenXXMREQ is a regenerated request. Regenerated requests are issued
// after the micro-TLB has indicated a LookupStall, if the access was
// not aborted (MMU abort), or killed via D/KILL. 
//
// ICMREQ due to an instruction preftech operation is treated in the
// same way as InMREQ, in that the rising edge of CP15IPrefetch will
// cause ICMREQ to be asserted in the same cycle (as long as the ICache
// is the currently predicted region).

// IRegenEnable conatains all the shared qualfier terms for I-side 
// regeneration requests
 
assign IRegenEnable = ITLBReady & IRegen & ~pIMMUAbort;

// IEXT
// ----
//

assign IEXTMREQ = IEXTCoreMREQ | IEXTRegenMREQ;

assign IEXTCoreMREQ = ~InMREQ & EnIEXTCoreMREQ;

// pass InMREQ through to IEXTMREQ if the predicted
// region is non-cacheable, and CLKEN is asserted.

assign EnIEXTCoreMREQ = INCRegion & SysCLKEN;

assign IEXTRegenMREQ = IRegenEnable & INCRegion & IMREQFE;


// ICache
// ------
// 
// The ICache differs from IEXT in that it includes 
// terms used for instruction prefetch operations.

assign ICMREQ = ICCoreMREQ | ICPrefetchMREQ | ICRegenMREQ;

assign ICPrefetchMREQ = IPrefetchMREQ & EnICCoreMREQ;

assign ICCoreMREQ = ~InMREQ & EnICCoreMREQ;

assign EnICCoreMREQ = ICRegion & SysCLKEN;

assign ICRegenMREQ = IRegenEnable & ICRegion & (IMREQFE | IPrefetchMREQFE);

// ITCM
// ----
//
// The ITCM differs from other blocks due to having separate read and
// write requests, and D to I-TCM space regenerated requests.
//
// Note that only D to I-TCM accesses can cause writes to the I-TCM 
//
//
assign ITCMRDREQ = ITCMCoreMREQ | ITCMRegenMREQ | (DtoITCMRegenMREQ & ~DnRWME);

assign ITCMWRREQ = (DtoITCMRegenMREQ & DnRWME);

assign ITCMREQ = ITCMRDREQ | ITCMWRREQ;

assign ITCMCoreMREQ = ~InMREQ & EnITCMCoreMREQ;

assign EnITCMCoreMREQ = ITCMRegion & SysCLKEN & ~EXTEST;

assign ITCMRegenMREQ = IRegenEnable & ITCMRegion & IMREQFE & ~EXTEST;


// For D to I-TCM accesses DtoICTMAccess is asserted in the first data side 
// REGEN cycle when DTLBReady is asserted, and held while the D-side state 
// machine is in the REGEN state. The D-side state machine will only leave 
// the REGEN state when DtoITCMRegenMREQ has been asserted


assign DtoITCMRegenMREQ = DtoITCMAccess & ITCMComplete & ~EXTEST;


// DtoITCMAccessRaw is continually sampled until DTLBReady
// is asserted. This is then qualified using DTLBReady
// and DRegen to produce DtoITCMAccess


assign NextDtoITCMRaw = DMREQME & DtoITCM & ~DMMUAbort;

assign SampleDtoITCMRaw = DuTLBLookup | ~DTLBReady;

always @(posedge GCLK) begin
  if (SampleDtoITCMRaw) begin
    DtoITCMAccessRaw <= NextDtoITCMRaw;
  end
end

assign DtoITCMAccess = DtoITCMAccessRaw & DTLBReady & DRegen;

// ITCMComplete is asserted when the ITCM has finished any possible
// I-side activity, allowing a D to I-TCM access to start

assign ITCMComplete = ITLBReady & ~ITCMRegenMREQ & ITCMReady;


// D-side
//
// DRegenEnable contains all the shared terms for normal D-side regeneration
// (excluding DtoITCM regeneration). 
//
// Note that for D to I-TCM accesses, DXXRegion does not change, so ~DtoITCMAccess
// must be included here to prevent a regenerated request for the currently
// predicted region.

assign DRegenEnable = DTLBReady & DRegen & ~DtoITCMAccess & ~pDMMUAbort & DMREQME;

// DEXT
// ----
// As the DEXT block is also used as the write-buffer for cacheable
// stores (both WT and WB), DEXTMREQ must be assserted if DCMREQ is
// asserted. 

assign DEXTRegion = DNCNBRegion | DNCBRegion;

assign DEXTMREQ = DEXTCoreMREQ | DCCoreMREQ | DEXTRegenMREQ | DCRegenMREQ;

assign EnDEXTCoreMREQ = DEXTRegion & SysCLKEN;

assign DEXTCoreMREQ = ~DnMREQ & EnDEXTCoreMREQ;

assign DEXTRegenMREQ = DEXTRegion & DRegenEnable;

// DCache
// ------

assign DCMREQ = DCCoreMREQ | DCRegenMREQ;

assign DCCoreMREQ = ~DnMREQ & EnDCCoreMREQ;

assign EnDCCoreMREQ = DCRegion & SysCLKEN;

assign DCRegenMREQ = DCRegion & DRegenEnable;

// DTCM
// ----

assign DTCMRDREQ = (DTCMCoreMREQ & ~DnRW)  | (DTCMRegenMREQ & ~DnRWME);

assign DTCMWRREQ = (DTCMCoreMREQ & DnRW)  | (DTCMRegenMREQ & DnRWME);

assign DTCMREQ = DTCMRDREQ | DTCMWRREQ;

assign DTCMCoreMREQ = ~DnMREQ & EnDTCMCoreMREQ;

assign EnDTCMCoreMREQ = DTCMRegion & SysCLKEN & ~EXTEST;

assign DTCMRegenMREQ = DTCMRegion & DRegenEnable & ~EXTEST;





// XXMREQ request cancellation - XXCancel
// ======================================
//
// CMIF requests will be cancelled if:
//
// i)   The access is killed by the ARM9EJ-S via D/IKILL
//
// ii)  The MMU aborts the access (MMUAbort)
//
// iii) A uTLB lookup stall occurs (uTLBMiss, region mispredict, PA mispredict)
//
//
// For clarity the individual block cancellation signals are only asserted if
// a request was actually issued to that block in the previous GCLK cycle

always @(posedge GCLK) begin
  pIEXTMREQ <= IEXTMREQ;
  pICMREQ   <= ICMREQ;
  pITCMREQ  <= ITCMREQ;
  pDEXTMREQ <= DEXTMREQ; 
  pDCMREQ   <= DCMREQ;
  pDTCMREQ  <= DTCMREQ;
  pDtoITCMRegenMREQ <= DtoITCMRegenMREQ;
end


assign DCancelME = (DMREQMENoKill & DKILL) | DMMUAbort | DLookupStall;

assign DEXTCancel = pDEXTMREQ & DCancelME;

assign DCCancel = pDCMREQ & DCancelME;

assign DTCMCancel = pDTCMREQ & DCancelME;


assign ICancelFE = (IMREQFENoKill & IKILL) | IMMUAbort | ILookupStall;

assign IEXTCancel = pIEXTMREQ & ICancelFE;

assign ICCancel = pICMREQ & ICancelFE;

assign ITCMCancel = pITCMREQ & ~pDtoITCMRegenMREQ & ICancelFE;




// I-side sequentiality
// ====================
//
// Sequentiality is broken for
//
// i)   1K boundaries 
// ii)  executed CP15 instructions
// iii) previous instruction fetch killed by ARM9EJ-S (ICache and ITCM only)
// iv)  a D to I-TCM access has occurred, and the current I-side region is TCM.
// 
//
// Note that the IEXT block does not need sequentiality due to IKILL, and that
// breaking sequentiality in this case would cause the IEXT block to flush its
// prefetch buffer for every ARM9EJ-S interlock (most common case for IKILL).
//
// IForceNonSeq is produced using a synchronous set/clear arrangement, as there
// may be many cycles between the condition which requires I-side sequentiality
// to be broken, and the next instruction fetch performed by the ARM9EJ-S

assign ILastInPageFE = &IAFE[9:2];

assign SetIForceNonSeq = CP15IHazard |
                         (ILastInPageFE & IMREQFE) |
                         (IMREQFENoKill & IKILL & ~INCRegion) |
                         (DtoITCMRegenMREQ & ITCMRegion);

// IForceNonSeq is cleared when a non-sequential instruction fetch
// derived directly from InMREQ has been issued, and this has not
// been cancelled via IKILL.

assign IMREQIssuedCA = IEXTCoreMREQ | ITCMCoreMREQ | ICCoreMREQ;

assign INonSeqCA = ~IEXTSEQ & ~ITCMSEQ & ~ICSEQ;

always @(posedge GCLK) begin
    IMREQIssuedFE <= IMREQIssuedCA;
    INonSeqFE <= INonSeqCA;
end
  
assign ClrIForceNonSeq = IMREQIssuedFE & INonSeqFE & ~IKILL;

always @(posedge GCLK or negedge SnReset) begin
  if (~SnReset)
    pIForceNonSeq <= 1'b0;
  else 
    pIForceNonSeq <= IForceNonSeq;
end
  
assign IForceNonSeq = SetIForceNonSeq | (pIForceNonSeq & ~ClrIForceNonSeq);


// ISEQ is also suppressed for regenerated requests, and for instruction
// prefetch operations. Note that the DorIRegen term below means that SysCLKEN
// does not need to be factored in, as if either of the state machines are in
// the REGEN state then SysCLKEN enable must low, and any request being issued
// in the current cycle must be a regenerated one.

assign EnISEQ = ~IForceNonSeq & ~DorIRegen & ~IPrefetchMREQ;

assign IEXTSEQ = INCRegion & ISEQ & EnISEQ;

assign ICSEQ = ICRegion & ISEQ & EnISEQ;

assign ITCMSEQ = ITCMRegion & ISEQ & EnISEQ;



// D-side sequentiality
// ====================
// 
// There are two cases for suppressing the DXXSEQ inputs:
//
// i)  1K boundaries (DEXT, DCache, and DTCM)
// 
// ii) An external coprocessor performs a multi-word LDC/STC operation
//     with CPBURST tied off to zero (DEXT only). 
//
//     DEXT uses DEXTSEQ low in conjunction with DEXTMREQ to sample DEXTBURST 
//     in the following ME cycle. If CPBURST is set to zero, then each of the 
//     words must be transferred individually by DEXT, and so DEXTSEQ must be 
//     forced low for every memory request in the transfer (DEXTBURST will be 
//     set to "0000" in this case, indicating a single word transfer).

// Unified BURST signal - BURSTEX
//
// BURSTEX is derived from either DBURST (ARM9EJ-S), or CPBURSTEX (external
// coprocessor interface). The ARM9EJ-S coprocessor interface signal PASS
// is used to select between them. PASS will be asserted in ARM9EJ-S EX cycles
// (including busy-waited cycles), which correspond to an executing coprocessor
// instruction. 
//



assign BURST1stEX = PASS ? CPBURSTEX : DBURST;

assign BURSTEX = DSEQEX ? BURSTME : BURST1stEX;

// if BURSTEX = "0000" then any DEXTMREQ issued in the current
// cycle is forced to be non-sequential. Note that if CPBURSTEX
// is "0000", then BURSTEX will be also be "0000" for all EX
// cycles where a DnMREQ is issued. 

assign DSingleTransferEX = ~|BURSTEX;

always @(posedge GCLK) begin
  if (SysCLKEN) begin
    DSingleTransferME <= DSingleTransferEX;
  end
end


assign DLastInPageME = &DAME[9:2];

assign DFirstInPageME = ~|DAME[9:2];


// enable DSEQ -> DXXSEQ if
//
// previous data address was not the last in a page
//
// DXXMREQ is not for a regenerated request
//
// Note: only the value of DAME needs to be used here for
// the 1K boundary case (I-side equivalent logic takes into 
// account IMREQFE)
//


assign EnDSEQ = ~DLastInPageME & ~DRegen;

assign DEXTSEQ = DSEQEX & EnDSEQ & (DEXTRegion | DCRegion) & ~DSingleTransferEX;

assign DCSEQ = DSEQEX & EnDSEQ & DCRegion;

assign DTCMSEQ = DSEQEX & EnDSEQ & DTCMRegion;

// DEXTBURST generation
// ====================
//
// Bursts which cross a 1k boundary are split, and issued as
// two seperate transactions. Note that the two sides of the
// boundary may not correspond to the same memory region, so in
// the case of one of regions being TCM space DEXT will only see
// one half of the burst.
//
// Whether a burst needs to be split or not is detected by adding
// the burst value (BURSTME) to bits 5:2 of DAME. The resulting
// sum will be the low order part of the address corresponding
// to the last address in the transfer. If BURSTME + DAME[5:2] is
// greater than 0b1111, and the start address for the transfer 
// is less than 16 words away from the boundary then the burst must
// be split.

always @(posedge GCLK) begin
  if (SysCLKEN) begin
    BURSTME <= BURSTEX;
  end
end

assign EndLowerME = BURSTME + DAME[5:2];

assign DNearBoundaryME = &DAME[9:6];

assign SplitBurstME = (EndLowerME > 5'b01111) & DNearBoundaryME;

assign SplitBurstInitial = 4'b1111 - DAME[5:2];

assign USplitBurstXPage = (BURSTME - SplitBurstInitial) - 4'b0001;


always @(posedge GCLK) begin
  if (DFirstWordME) begin
    SplitBurstXPage <= USplitBurstXPage;
  end
end

assign BurstInitial = SplitBurstME ? SplitBurstInitial : BURSTME;

assign BurstRaw = DFirstWordME ? BurstInitial : SplitBurstXPage;

assign EnDEXTBURST = DFirstWordME | (DFirstInPageME & DMREQME & ~DSingleTransferME);

assign EnDEXTBURST4 = {4{EnDEXTBURST}};

assign DEXTBURST = EnDEXTBURST4 & BurstRaw;

// memory request attributes 
// =========================
//
// XXMAS and xxnRW
// ---------------

// register EX/CA stage ARM9EJ-S attribute signals

always @(posedge GCLK) begin
  if (SysCLKEN) begin
    DMASME <= DMAS;
    DnRWME <= DnRW;
    DPrivileged <= DnTRANS;
    IPrivileged <= InTRANS;
    DLOCKME <= DLOCK;
  end
end

assign DEXTSwap = DLOCKME & DEXTRegion;

// I-TCM 
//
// For D to I-TCM accesses, DnRW and MAS are passed onto
// ITCMnRW and ITCMMAS, otherwise ITCMnRW and ITCMAS
// are set to specify word sized reads (MAS = 10, nRW = 0)

assign ITCMAS = DtoITCMRegenMREQ ? DMASME : 2'b10;

assign ITCMnRW = DtoITCMRegenMREQ ? DnRWME : 1'b0;

// For the DEXT, DCache and DTCM blocks the registered (ME)
// version is used for regenerated accesses, in all other
// cases the ARM9EJ-S EX stage attribute are passed straight
// through.

// DEXT
//

assign DEXTMAS = (DEXTRegenMREQ | DCRegenMREQ) ? DMASME : DMAS;

assign DEXTnRW = (DEXTRegenMREQ | DCRegenMREQ) ? DnRWME : DnRW;

// DCache

assign DCMAS = DCRegenMREQ ? DMASME : DMAS;

assign DCnRW = DCRegenMREQ ? DnRWME : DnRW;

// D-TCM

assign DTCMAS = DTCMRegenMREQ ? DMASME : DMAS;

assign DTCMnRW = DTCMRegenMREQ ? DnRWME : DnRW;

// DEXT Cached and Buffered
// ------------------------
// 
// Whether an access is cacheable or bufferable is determined
// by the region type. Note that all cacheable regions of memory
// must also be bufferable. 

assign DEXTCached = DCRegion;

assign DEXTBuffered = (DNCBRegion & ~ForceNCNB) | DCRegion;


// TCMAddr address control - DTCMA and ITCMA
// =========================================
//
// ITCMSelIAHeld indicates that the FE version of
// IA sould be passed through onto the bottom bits
// of ITCMA. This is done for:
//
// i)   I-TCM wait states for normal I-TCM accesses (not D to I-TCM)
//
// ii)  Normal regenerated I-TCM accesses (not D to I-TCM)
//
// iii) The I-TCM is not the currently predicted region (and no D to I access is
//      in progress). This is done to avoid ITCMA transitioning unnecessarily.

assign ITCMSelIAHeld = ~DtoISelDPA & (ITCMRegenMREQ | ~ITCMReady | ~ITCMRegion);

// DTCMSelDAHeld is symmetrical to ITCMSelIAHeld, except that it does not need
// to take into consideration D to I-TCM accesses.

assign DTCMSelDAHeld = DTCMRegenMREQ | ~DTCMReady | ~DTCMRegion;

// DtoISelDPA is used to indicate that the physical address portion
// of ITCMA should sourced from the data side physical address, which
// is required for D to I-TCM accesses. 
//
// DtoISelDPA is asserted in the cycle when DtoIRegenMREQ is issued, and
// held until the access has completed.

always @(posedge GCLK) begin
    pDtoISelDPA <= DtoISelDPA;
end

assign DtoISelDPA = DtoITCMRegenMREQ | (pDtoISelDPA & ~ITCMReady);

// sampling of DA and IA in TCMAddr
//
// If the I-TCM is enabled then both IA and DA must be sampled (in the
// event of a D to I-TCM access the registered version of DA will be used
// for the lower part of ITCMA)
//
// If only the D-TCM is enabled then only DA needs to be sampled

assign ITCMSampleIA = SysCLKEN & ITCMEn;

assign DTCMSampleDA = SysCLKEN & (DTCMEn | ITCMEn);


// FCSE address control - IVA/DVA, IMVA and DMVA
// =============================================
// 
// The logic for selecting the source for IVA and DVA
// is symmetrical:
//
// The holding registers are used as a source for XVA if:
//
// i)  A cacheable access is being regenerated
//
// ii) The cache is not the currently predicted region and
//     a CP15 operation is not in progress (CP15Active). This
//     avoids unecessary transitions on XVA.

assign IVASelIAHeld = ICRegenMREQ | (~ICRegion & ~CP15Active);

assign DVASelDAHeld = DCRegenMREQ | (~DCRegion & ~CP15Active);

assign FCSESampleDA = SysCLKEN;

assign FCSESampleIA = SysCLKEN;

// DROUTE and IROUTE control
// =========================
// 
//
// Note that in order for ETM to be able to trace data correctly:
//
// RDATA must reflect the value of STC/LDC and MRC data (RDATA connects to DDIN on ETM9)
// WDATA must reflect the value of MCR/STR         data (WDATA connects to DD   on ETM9)
//
// read data/instruction fetches
//
// XXPending for each block indicates that read data is
// pending from that block. This is used to steer the
// read data muxes in DROUTE/IROUTE, together with the
// XXReady signal for that block.

assign DEXTPending = (pDEXTMREQ & ~pDCMREQ & ~DKILL) | (pDEXTPending & ~pDEXTReady);

assign DCPending = (pDCMREQ & ~DKILL) | (pDCPending & ~pDCReady);

assign DTCMPending = (pDTCMREQ & ~DKILL) | (pDTCMPending & ~pDTCMReady);

assign DtoITCMPending = (pDtoITCMRegenMREQ) | (pDtoITCMPending & ~pITCMReady);

always @(posedge GCLK) begin
  pDEXTReady <= DEXTReady;
  pDCReady <= DCReady;
  pDTCMReady <= DTCMReady;
  pDEXTPending <= DEXTPending;
  pDCPending <= DCPending;
  pDTCMPending <= DTCMPending;
  pDtoITCMPending <= DtoITCMPending;
end

// RDATA 
//

assign RDSelCP15RD = MRCinME | STCinME;

assign RDSelDCRD = DCPending & DCReady & ~DnRWME;

assign RDSelDEXTRD = DEXTPending & DEXTReady & ~DnRWME;

assign RDSelDTCMRD = DTCMPending & DTCMReady & ~DnRWME;

assign RDSelITCMRD = DtoITCMPending & ITCMReady & ~DnRWME;


// select the hold register if no other selection term active

assign RDSelHold = ~|{RDSelCP15RD,RDSelDCRD,RDSelDEXTRD,RDSelDTCMRD,RDSelITCMRD};

// capture the value of RDATA if DCache, DEXT, DTCM, or ITCM returning data

assign RDCapture = |{RDSelDCRD,RDSelDEXTRD,RDSelDTCMRD,RDSelITCMRD};


// CP15WD
//

assign CPWDSelWDATA = MCRinME;

assign CPWDSelDCRD = DCPending & DCReady & LDCinME;

assign CPWDSelDEXTRD = DEXTPending & DEXTReady & LDCinME;

assign CPWDSelDTCMRD = DTCMPending & DTCMReady & LDCinME;

assign CPWDSelITCMRD = DtoITCMPending & ITCMReady & LDCinME;


// select the hold register if none of the other CPWDSelXX signals is asserted

assign CPWDSelHold = ~|{CPWDSelWDATA,CPWDSelDCRD,CPWDSelDEXTRD,CPWDSelDTCMRD,CPWDSelITCMRD};

// capture the value of CP15WD if DCache, DEXT, DTCM, or ITCM returning data

assign CPWDCapture = |{CPWDSelDCRD,CPWDSelDEXTRD,CPWDSelDTCMRD,CPWDSelITCMRD};


// DEXTWD, DCWD, DTCMWD and ITCMWD

assign WDSelCP15RD = STCinME;

assign WDSelWDATA  = ~STCinME;


// INSTR


assign IEXTPending = (pIEXTMREQ & ~IKILL) | (pIEXTPending & ~pIEXTReady);

assign ICPending = (pICMREQ & ~IKILL) | (pICPending & ~pICReady);

assign ITCMPending = (pITCMREQ & ~pDtoITCMRegenMREQ & ~IKILL) | (pITCMPending & ~pITCMReady);

always @(posedge GCLK) begin
  pIEXTReady <= IEXTReady;
  pICReady <= ICReady;
  pITCMReady <= ITCMReady;
  pIEXTPending <= IEXTPending;
  pICPending <= ICPending;
  pITCMPending <= ITCMPending;
end

// CP15 requires that INSTR is effectively the FE stage in its pipeline follower
// in ARM mode. This means that INSTR should not reflect ICRD during a CP15 
// prefetch operation.  

assign INSTRSelICRD = ICPending & ~IPrefetchMREQFE & ICReady;

assign INSTRSelIEXTRD = IEXTPending & IEXTReady;

assign INSTRSelITCMRD = ITCMPending & ITCMReady;

assign INSTRSelHold = ~|{INSTRSelICRD,INSTRSelIEXTRD,INSTRSelITCMRD};

assign INSTRCapture = |{INSTRSelICRD,INSTRSelIEXTRD,INSTRSelITCMRD};

// External Aborts
// ===============
//
// DExtAbort
// ---------
//
// External abort information for NC loads, and NB writes must be
// accumulated, and presented to the DuTLB at the correct point to
// enable the correct address to be placed in the FAR.
// 
// If a 1K boundary is not crossed, then this is simply the last
// word in the transfer. 
//
// If a 1K boundary is crossed, then this is at the 1K boundary
// if the external abort occurs before the boundary, or the last
// word of the transfer if the abort occurs after the boundary.
// 
// This is done by accumalting the external abort information for
// a transfer, and presenting to this to the DuTLB at the next
// 1K boundary, or at the end of the transfer. Once DExtAbort
// has been asserted and the ARM9EJ-S core clocked, the accumulated
// abort information is cleared.

assign EnDExtAbort = DEXTRegion & (DLastInPageME | DLastWordME);

assign DExtAbortAccum = DExtAbortHeld | DExtWordAborted;

assign DExtWordAborted = DEXTError & DEXTPending & DEXTReady;

assign UDExtAbortHeld = DExtAbortAccum & ~ClrDExtAbortHeld;

assign ClrDExtAbortHeld = (DLastInPageME | DLastWordME) & SysCLKEN;


always @(posedge GCLK or negedge SnReset) begin
  if (~SnReset)
    DExtAbortHeld <= 1'b0;
  else
    DExtAbortHeld <= UDExtAbortHeld;
end

assign DExtAbort =  DExtWordAborted | DExtAbortHeld;

// IExtAbort
// ---------
//
// There is no I-side FAR, so IExtAbort is set when
// IEXTError is asserted, and held until the ARM9EJ-S
// is clocked.
//

assign IEXTWordAborted = INCRegion & IEXTError & IEXTPending & IEXTReady;

assign IExtAbort = IEXTWordAborted | IExtAbortHeld;

assign UIExtAbortHeld = IExtAbort & ~SysCLKEN;

always @(posedge GCLK) begin
  IExtAbortHeld <= UIExtAbortHeld;
end

// PotentialXAbort
//
// PotentialXAbort is used to identify a GCLK cycle where an external
// abort on either side may be indicated to the MMU. This is used to
// enable the MMU clock, so the FSR and FAR values from the micro-TLB
// can be registered. This is less precise than using DExtAbort or
// IExtAbort, as it will be asserted in cycles where D/ExtAbort are
// not asserted.

assign PotentialXAbort = IExtAbortHeld | IEXTError | DExtAbortHeld | DEXTError;



// CLKEN/SysCLKEN/CP15CLKEN
// ========================
//
// SysCLKEN and CP15CLKEN are simply aliases for CLKEN
// 
// CLKEN will be deasserted if:
//
//
// i)    Any of IEXTReady, ICReady, ITCMReady, DEXTReady, DCReady, DTCMReady are
//       low 
//
// ii)   Either of DLookupStall or ILookupStall are high (uTLB miss, 
//       region mispredict, PA mispredict for TCM, D to I-TCM access)
//
// iii)  Either of DTLBReady or ITLBReady is low (MMU lookup incomplete)
//
// iv)   Either of the state machines is in the REGEN state (regenerated access
//       is pending).
//
// v)    The ETM FIFOFULL signal is asserted, and its affect is not masked
//       by the presence of a FIQ or IRQ interrupt. 
//
// vi)   The ARM926EJ-S is in a standby mode due to wait-for-interrupt.
//
//
// vii)  The endian of the system has changed (via a write to the control reg
//       in CP15), and either the TCM or DEXT write-buffers are not empty


assign SysStall = DorIRegen | WFIStall | FIFOFULLStall | EndianStall;

assign SysReady = ~SysStall;

assign MMUReady = ~DLookupStall & ~ILookupStall & DTLBReady & ITLBReady;

assign CLKEN = SysReady &
               MMUReady &
               IEXTReady &
               ICReady &
               ITCMReady &
               DEXTReady &
               DCReady &
               DTCMReady;

assign SysCLKEN = CLKEN;

assign CP15CLKEN = CLKEN;

// wait-for-interrupt CLKEN stall

assign WFIStall = CP15Active & CP15WFI & ~CP15WFIDone;


// ETM FIFOFULL stalling
//
// The ARM9EJ-S is only stalled on instruction bouindaries, in order
// to esnure that it is not stalled half-way through a burst (LDM/STM etc).
// 

assign InstrBoundaryDE = ~ETMInMREQ;

always @(posedge GCLK) begin
  if (SysCLKEN)
    InstrBoundaryEXNoKill <= InstrBoundaryDE;
end

assign InstrBoundaryEX = InstrBoundaryEXNoKill & ~ETMIKILL;

// The presence of a FIQ or IRQ interrupt will prevent the core
// from stalling, unless the TraceMaskXXX signals are asserted

// nFIQ and nIRQ are registered, in order to prevent paths from
// nIRQ/FIQ to CLKEN

always @(posedge GCLK) begin
  pnIRQ <= nIRQ;
  pnFIQ <= nFIQ;
end

assign EnFIFOFULLStall = (pnIRQ | TraceMaskIRQ) & (pnFIQ | TraceMaskFIQ);

assign FIFOFULLStall = InstrBoundaryEX & FIFOFULL & EnFIFOFULLStall;



// Endian Change CLKEN stall
// =========================
//
// If the value of the BIGEND bit (CP15 register 1) changes, then the
// system is stalled until both the TCM and DEXT write-buffers have
// drained, and the D-side BIU is idle. 
//

assign WriteBufHazard = ~ITCMIdle | ~DTCMIdle | ~DEXTIdle | ~DBIUIdle;

// endian change is detected by sampling the value of BIGEND on the
// cycle after the rising edge of CP15Active, and comparing this sampled 
// value with the raw value of the BIGEND bit

always @(posedge GCLK or negedge SnReset) begin
  if (~SnReset)
    pCP15Active <= 1'b0;
  else
    pCP15Active <= CP15Active;
end

assign USampleBIGEND = CP15Active & ~pCP15Active;

always @(posedge GCLK or negedge SnReset) begin
  if (~SnReset) 
    SampleBIGEND <= 1'b1;
  else
    SampleBIGEND <= USampleBIGEND;
end

always @(posedge GCLK) begin
  if (SampleBIGEND) 
    OldBIGEND <= BIGEND;
end

assign EndianChange = BIGEND ^ OldBIGEND;

// start stalling in the cycle after the last EX of the MCR
// which corresponds to the EX of the following instruction
// (note CP15IHazard indicates last CP15 EX cycle)

assign SetEndianStall = CP15IHazard & EndianChange & WriteBufHazard;

assign ClrEndianStall = ~WriteBufHazard;

assign UEndianStall = (SetEndianStall | EndianStall) & ~ClrEndianStall;

always @(posedge GCLK or negedge SnReset) begin
  if (~SnReset) 
    EndianStall <= 1'b0;
  else
    EndianStall <= UEndianStall;
end

// CFGBIGEND/SysBIGEND are not updated until after the CP15 instruction 
// has finished its last execute cycle (CP15Active falling),
// and all of the write-buffers have been drained. 
//
// Delaying this update means that it will change in the EX cycle of the
// instruction following the MCR. (DCache samples endian info in EX, and
// the TCM controllers in ME)

assign UpdateCFGBIGEND = ~CP15Active & ~WriteBufHazard;

always @(posedge GCLK) begin
  if (UpdateCFGBIGEND) begin
    CFGBIGEND <= BIGEND;
    SysBIGEND <= BIGEND;
  end
end



// CP15 instruction prefetch handshaking
// =====================================
//
// The rising edge of CP15IPrefetch will create a pesudo
// memory request, which will be treated in the same way
// as a normal instruction fetch, wrt CLKEN. This means
// that CLKEN will be stalled until the first word is
// returned by the cache on ICRD. Once the first word has
// been returned SysCLKEN will be asserted, and the ARM9EJ-S
// and CP15 will be clocked, and CP15IPrefetchDone will be
// asserted in the next cycle. The next instruction fetch 
// from the ARM9EJ-S will almost certainly be sequential (a
// non-seq fetch could occur due to exception entry). The
// presence of CP15IHazard will force ICSEQ to be low for
// the next core I-fetch, which means that the ICache will
// complete the linefill for the remaining words in the
// background. 


assign UIPrefetchDone = IPrefetchMREQFE & SysCLKEN;

always @(posedge GCLK) begin
  IPrefetchDone <= UIPrefetchDone;
end

// drain write-buffer sequencing
// =============================
//
// The drain-write-buffer operation will complete when:
//
// Both TCM interfaces are idle
// DCache is idle
// DEXT is idle
// DBIU is idle (i.e. the last AHB transaction has finished)
//

assign ITCMIdle = ~ITCMBUSY;

assign DTCMIdle = ~DTCMBUSY;

assign UCP15DWBDone = CP15DWB & ITCMIdle & DTCMIdle & DCIdle & DEXTIdle & DBIUIdle;

always @(posedge GCLK) begin
  if (SysCLKEN) begin
    CP15DWBDone <= UCP15DWBDone;
  end
end

// wait-for-interrupt sequencing
// =============================
//
// WFI is initiated by CP15 asserting CP15WFI.
//
// When the ARM926EJ-S is in a quiescent state the STANDBYWFI signal
// will be asserted. This allows logic external to the ARM926EJ-S
// not be clocked, in the knowledge that no accesses will occur on
// either the AHB or external coprocessor interfaces.
//
// The standby mode is left when either a FIQ or IRQ interrupt occurs,
// or either of DBGRQI/EDBGRQ is asserted. Note that DBGRQI may be asserted due to
// a debug request scanned into the CP14 debug control register, which
// means that the clock supplied to the ARM9EJ-S cannot be stopped, although
// CLKEN can be deasserted. The deassertion of CLKEN also inhibits the 
// propagation of EDBGRQ to DBGRQI, so EDBGRQ must be used explicitly.
//
// Note that GCLK will be stopped when STANDBYWFI is asserted, and will
// be restarted when WFIWakeUp is asserted. 

// Rev0.4 onwards IEXTIdle has been removed from SystemIdle term
// has been demonstrated to be redundant due to the behaviour of
// the IBIUIdle and CP15WFI signals.
  
assign SystemIdle = ITCMIdle & DTCMIdle & ICIdle & DCIdle & 
                               DEXTIdle & MMUIdle & IBIUIdle & DBIUIdle;

assign UWFIWakeUp = ~nFIQ | ~nIRQ | DBGRQI | EDBGRQ;

always @(posedge CLK) begin
  WFIWakeUp <= UWFIWakeUp;
end


assign UCP15WFIDone = CP15WFI & WFIWakeUp;

always @(posedge GCLK) begin
  CP15WFIDone <= UCP15WFIDone;
end

assign USTANDBYWFI = CP15WFI & SystemIdle & ~WFIWakeUp;

always @(posedge GCLK or negedge SnReset) begin
  if (~SnReset)
    STANDBYWFI <= 1'b0;
  else
    STANDBYWFI <= USTANDBYWFI;
end

// interrupt manipulation for ARM9E-S Rev0 Compatiblity (validation only)
// ======================================================================
//
// If SampleInt is asserted then the values of nFIQ and nIRQ which are 
// presented to the ARM9EJ-S core are delayed until CLKEN is asserted.
//
// This mimicks the behaviour of ARM9E-S Rev0 in which interrupts were
// only sampled on a CLKEN boundary.

always @(posedge GCLK) begin
  if (SysCLKEN) begin
    nFIQCLKEN <= nFIQ;
    nIRQCLKEN <= nIRQ;
  end
end

assign nFIQdelayed = SampleInt ? nFIQCLKEN : nFIQ;
assign nIRQdelayed = SampleInt ? nIRQCLKEN : nIRQ;

assign nFIQARM9 = SysCLKEN ? nFIQ : nFIQdelayed;
assign nIRQARM9 = SysCLKEN ? nIRQ : nIRQdelayed;

// block level clock gating
// ========================
//
// The primary level of clock gating control is done inside
// the main clock block, and this is where CP15 debug
// register block level clock gating disabling is applied.
//
// Normally block level clocks will be disabled when blocks
// are known to be in idle state, or they are blocked pending
// data and/or a response from the BIU. The exception is for CP15
// operations (except WFI), where all block level clocks
// are enabled unconditonally. 
//

// NoFinish gives early indication that at least one of
// the blocks that produces XXReady, will not have its XXReady
// signal asserted in the current cycle. The TCM ready signals
// are early, so ~XTCMReady is used instead of a XTCMNoFinish
//
// NoFinish is suppressed if regeneration is occurring on either
// side, to avoid qualification of NoFinish in each of the block
// enable terms with either DRegen or IRegen, to ensure that 
// blocks are clocked for re-generated requests.


assign NoFinish = ~DorIRegen & 
                  (IEXTNoFinish | ~ITCMReady | ICNoFinish |
                   DEXTNoFinish | ~DTCMReady | DCNoFinish);

// ForceClkEn forces block level clocks to be active except
// during CP15 operations, except for wait-for-interrupt

assign ForceClkEn = CP15Active & ~CP15WFI;

// IEXT

assign StopIEXTClk = (IEXTIdle & NoFinish & INCRegion) |  
                     (IEXTIdle & ~INCRegion) |
                     IEXTBlocked |
                     STANDBYWFI;
  
assign IEXTClkEn = ~StopIEXTClk | ForceClkEn;         

// ITCM

assign StopITCMClk = (ITCMIdle & NoFinish & ~DorIRegen) |
                     (ITCMIdle & ~ITCMRegion & ~ITCMEn) |
                     STANDBYWFI;

assign ITCMClkEn = ~StopITCMClk | ForceClkEn;

// ICache

assign StopICClk = (ICIdle & NoFinish & ICRegion) |
                   (ICIdle & ~ICRegion) |
                   STANDBYWFI;

assign ICClkEn = ~StopICClk | ForceClkEn;

// DEXT

assign StopDEXTClk = (DEXTIdle & NoFinish & (DEXTRegion | DCRegion)) |
                     (DEXTIdle & ~(DEXTRegion | DCRegion)) |
                     DEXTBlocked | 
                     STANDBYWFI;

assign DEXTClkEn = ~StopDEXTClk | ForceClkEn;

// DTCM

assign StopDTCMClk = (DTCMIdle & NoFinish & DTCMRegion) |
                     (DTCMIdle & ~DTCMRegion) |
                     STANDBYWFI;

assign DTCMClkEn = ~StopDTCMClk | ForceClkEn;

// DCache

assign StopDCClk = (DCIdle & NoFinish & DCRegion) |
                   (DCIdle & ~DCRegion) |
                   STANDBYWFI;

assign DCClkEn = ~StopDCClk | ForceClkEn;

// If NoFinish is asserted then CLKEN must be low
// in the current cycle, and the clock to the ARM9EJ-S
// can be stopped, unless either DBGTCKEN is asserted, or an
// interrupt could be pending (interrupt latency)

assign StopARM9Clk = (NoFinish & ~DBGTCKEN & pnFIQ & pnIRQ) |
                     (STANDBYWFI & ~WFIWakeUp &~DBGTCKEN);

assign ARM9ClkEn = ~StopARM9Clk;


// MMU
//
// MMUIdle is deasserted when either of the UTLBReq signals,
// is asserted, or if an MMU abort is generated,
//
// For external aborts the PotentialXAbort term ensures
// that the MMU is clocked if an external abort could be
// indicated in the current cycle.
//

assign MMUClkEn = ~MMUIdle | PotentialXAbort | ForceClkEn;



// disable CP15PipeClk in standby mode

assign StopCP15PipeClk = STANDBYWFI & ~WFIWakeUp;

// force CP15PipeClk to be enabled in debug state

assign CP15PipeClkEn = ~StopCP15PipeClk | DBGACK;


// only enable CP15DebugClk if scan chain 15 is
// currently selected (decode of DBGSCREG)

assign ScanChain15Sel = (DBGSCREG == 4'b1111);

assign CP15DbgClkEn = ScanChain15Sel;



// The TCMNoReq signals give an early indication that
// no request will be issued to a particular side of
// the TCM interface.
//
// For the data side this is simply that the current
// data region is not defined to be DTCM, or a CP15
// operation is taking place.
//
// The instruction side also has to account for a possible
// D to ITCM access. 


assign DTCMNoReq = ~DTCMRegion | CP15Active;

assign ITCMNoReq = (~ITCMRegion & ~DtoITCMAccess) | CP15Active;


//synopsys translate_off
//surefire coverage_off


task fatal;
input [25*8:1] msg;
begin
  $display("%d fatal error - %s\n",$time,msg);
`ifndef __NO_STOP__
  #1000 $stop;
`endif //__NO_STOP__
end

endtask

// check that PotentialXAbort is definitely high if
// either of D/IExtAbort is high

always @(posedge GCLK) begin
  if ((DExtAbort | IExtAbort) & ~PotentialXAbort) begin
    fatal("PotentialXAbort not asserted for D/IExtAbort");
  end
end


// clock gating and CLKEN checks

always @(posedge GCLK) begin

  if (NoFinish & CLKEN) begin
    fatal("NoFinish and CLKEN both high");
  end

  if (DCIdle & ~DCReady) begin
    fatal("DC idle when DCReady = 0");
  end

  if (DEXTIdle & ~DEXTReady) begin
    fatal("DEXT idle when DEXTReady = 0");
  end

  if (ICIdle & ~ICReady) begin
    fatal("IC idle when ICReady = 0");
  end

  if (IEXTIdle & ~IEXTReady) begin
    fatal("IEXT idle when IEXTReady = 0");
  end

  if (ITCMIdle & ~ITCMReady) begin
    fatal("ITCM idle when ITCMReady = 0");
  end

  if (DTCMIdle & ~DTCMReady) begin
    fatal("DTCM idle when DTCMReady = 0");
  end

end


// Check ClkEn is always defined after reset has been deasserted
// Note that during reset all of the block level clocks will
// active, due to reset logic in the clock block


always @(posedge GCLK) begin
  if (SnReset === 1'b1) begin
    if ((DEXTClkEn !== 1'b0) && (DEXTClkEn !== 1'b1))
    fatal("DEXTClkEn unknown");

    if ((IEXTClkEn !== 1'b0) && (IEXTClkEn !== 1'b1))
    fatal("IEXTClkEn unknown");

    if ((DCClkEn !== 1'b0) && (DCClkEn !== 1'b1))
    fatal("DCClkEn unknown");

    if ((ICClkEn !== 1'b0) && (ICClkEn !== 1'b1))
    fatal("ICClkEn unknown");

    if ((DTCMClkEn !== 1'b0) && (DTCMClkEn !== 1'b1))
    fatal("DTCMClkEn unknown");

    if ((ITCMClkEn !== 1'b0) && (ITCMClkEn !== 1'b1))
    fatal("ITCMClkEn unknown");

    if ((CP15PipeClkEn !== 1'b0) && (CP15PipeClkEn !== 1'b1))
    fatal("CP15PipeClkEn unknown");

    if ((CP15DbgClkEn !== 1'b0) && (CP15DbgClkEn !== 1'b1))
    fatal("CP15DbgClkEn unknown");

    if ((ARM9ClkEn !== 1'b0) && (ARM9ClkEn !== 1'b1))
    fatal("ARM9ClkEn unknown");

    if ((MMUClkEn !== 1'b0) && (MMUClkEn !== 1'b1))
    fatal("MMUClkEn unknown");
  end
end

always @(posedge GCLK) begin


  if (DEXTMREQ & ~DEXTClkEn) begin
    fatal("DEXTClkEn low, when DEXTMREQ issued");
  end

  if (IEXTMREQ & ~IEXTClkEn) begin
    fatal("IEXTClkEn low, when IEXTMREQ issued");
  end

  if (DCMREQ & ~DCClkEn) begin
    fatal("DCClkEn low, when DCMREQ issued");
  end

  if (ICMREQ & ~ICClkEn) begin
    fatal("ICClkEn low, when ICMREQ issued");
  end

  if ((DTCMRDREQ | DTCMWRREQ) & ~DTCMClkEn) begin
    fatal("DTCMClkEn low, when DTCM MREQ issued");
  end

  if ((ITCMRDREQ | ITCMWRREQ) & ~ITCMClkEn) begin
    fatal("ITCMClkEn low, when ITCM MREQ issued");
  end

end



//synopsys translate_on

//surefire coverage_on

endmodule











  

               

