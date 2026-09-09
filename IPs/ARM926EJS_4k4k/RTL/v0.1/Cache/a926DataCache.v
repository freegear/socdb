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
// Filename   : a926DataCache.v,v
// Date       : 2001/10/31 15:10:49
// Revision   : 1.30
// Release Information : ARM926EJS_r0p5-00rel0 
//
//-------------------------------------------------------------------------

//#
//#                          a926Cache
//#                          =========
//#
//# ARM926EJS Cache top-level control and data-path
//#
//# >Originator :< Kim Rasmussen/Peter Middleton
//#
//# Revisions
//# =========
//#
//#spec versions
//#
//# Overview
//# ========
//#
//# Module Declaration
//# ==================
//#

`timescale 1ns / 1ps

`include "smt_debug.vh"

module a926DataCache(
  CClk,
  CnReset,

  CIdle,
  CNoFinish,
  CReady,  
  CMREQ,
  CSEQ,
  CnRW,
  CMAS,
  CCancel,
  Privileged,
  VA,
  MVA,
  RawMVA,
  PA,
  Writeback,
  DontCommit,
  CRD,
  CWD,
  
  CACHEBIUEarlyReq,
  CACHEBIUReq,
  CACHEBIUA,
  CACHEBIUBurst,
  CACHEBIUnRW,
  CACHEBIUWrap,
  CACHEBIUPriv,
  CACHEBIUWD,
  CACHEBIUAck,
  CACHEBIUNextWD,
  CACHEBIUReady,
  BIURD,

  CnWayAlloc,
  CNoLinefill,
  BIGEND,
  RRBIT,
  DisableWriteback,
  InvalMicroTag,
  CCP15Req,
  CacheOp,
  CCP15Ready,
  CDirty,
  CACHESIZE,
  Csize,
  Cassoc,
  CMbit,

  CBISTEN,
  CBISTA,
  CBISTTAGCS,
  CBISTDATACS,
  CBISTVALIDCS,
  CBISTDIRTYCS,

  CTAGCS,
  CTAGA,
  CTAGWE,
  CTAGRD0,
  CTAGRD1,
  CTAGRD2,
  CTAGRD3,
  CTAGWD,

  CDATACS,
  CDATAINDEX,
  CDATAWORDB0,  
  CDATAWORDB1,
  CDATAWORDB2,
  CDATAWORDB3,
  CDATABYTEWE,
  CDATARD0,
  CDATARD1,
  CDATARD2,
  CDATARD3,
  CDATAWD0,
  CDATAWD1,
  CDATAWD2,
  CDATAWD3,

  CVALIDCS,
  CVALIDA,
  CVALIDWE,
  CVALIDRD,
  CVALIDWD,
  CNoRRgen,

  CDIRTYCS,
  CDIRTYA,
  CDIRTYWE,
  CDIRTYRD,
  CDIRTYWD

);

//#
//# Interface Signals
//# =================
//#

  input          CClk;             // cache block clock from clock block
  input          CnReset;          // cache block reset
  
//-------------------------------------------------------------------------
// SysCtl/core signals
//-------------------------------------------------------------------------
  output         CIdle;     
  output         CNoFinish;
  output         CReady; 
  input          CMREQ;
  input          CSEQ;
  input          CnRW;
  input  [ 1: 0] CMAS;
  input          CCancel;
  input          Privileged;
  input  [31: 0] VA;               // virtual address from core
  input  [ 6: 0] MVA;              // modified (FCSE) virtual address
  input  [31:25] RawMVA;           // raw MVA to FB and PWB
  input  [21: 0] PA;               // physical (translated) address from MMU
  input          Writeback;
  output         DontCommit;
  output [31: 0] CRD;              // data from BIU/FB/RAM (to DROUTE)
  input  [31: 0] CWD;              // data from core to RAM (if hit)
  
//-------------------------------------------------------------------------
// BIU signals
//-------------------------------------------------------------------------
  output         CACHEBIUEarlyReq;
  output         CACHEBIUReq;
  output [31: 0] CACHEBIUA;        // address assoc with req
  output [ 2: 0] CACHEBIUBurst;
  output         CACHEBIUnRW;
  output         CACHEBIUWrap;
  output         CACHEBIUPriv;
  output [31: 0] CACHEBIUWD;       // data for write req
  input          CACHEBIUAck;
  input          CACHEBIUNextWD;
  input          CACHEBIUReady;
  input  [31: 0] BIURD;            // read data

//-------------------------------------------------------------------------
// CP15 signals
//-------------------------------------------------------------------------
  input  [ 3: 0] CnWayAlloc;
  input          CNoLinefill;      // a926ejsCPdp/rp15Reg15CD[I=bit1,D=bit0]
  input          BIGEND;           // endianess
  input          RRBIT;
  input          DisableWriteback; // a926ejsCPdp/rp15Reg15CD[2]
  input          InvalMicroTag;
  input          CCP15Req;
  input  [ 3: 0] CacheOp;
  output         CCP15Ready;
  output         CDirty;
  input  [ 3: 0] CACHESIZE;
  output [ 3: 0] Csize;
  output [ 2: 0] Cassoc;
  output         CMbit;

//-------------------------------------------------------------------------
// BIST signals
//-------------------------------------------------------------------------
  input          CBISTEN;
  input  [12: 0] CBISTA;           // address for access (WAY + index)
  input  [ 3: 0] CBISTTAGCS;
  input  [ 3: 0] CBISTDATACS;
  input          CBISTVALIDCS;
  input          CBISTDIRTYCS;

//-------------------------------------------------------------------------
// TAG ram
//-------------------------------------------------------------------------
  output [ 3: 0] CTAGCS;
  output [10: 0] CTAGA;            // maximum #bits for NSETS
  output [ 3: 0] CTAGWE;
  input  [21: 0] CTAGRD0;          // tag data from way 0
  input  [21: 0] CTAGRD1;          // tag data from way 1
  input  [21: 0] CTAGRD2;          // tag data from way 2
  input  [21: 0] CTAGRD3;          // tag data from way 3
  output [21: 0] CTAGWD;           // maximum #bits for tag
 
//-------------------------------------------------------------------------
// DATA ram
//-------------------------------------------------------------------------
  output [ 3: 0] CDATACS;
  output [ 9: 0] CDATAINDEX;       // index for data access (max #bits)
  output [ 2: 0] CDATAWORDB0;      // word selects for a line in bank 0
  output [ 2: 0] CDATAWORDB1;      // word selects for a line in bank 1
  output [ 2: 0] CDATAWORDB2;      // word selects for a line in bank 2
  output [ 2: 0] CDATAWORDB3;      // word selects for a line in bank 3
  output [ 3: 0] CDATABYTEWE;
  input  [31: 0] CDATARD0;         // data from bank 0
  input  [31: 0] CDATARD1;         // data from bank 1
  input  [31: 0] CDATARD2;         // data from bank 2
  input  [31: 0] CDATARD3;         // data from bank 3
  output [31: 0] CDATAWD0;         // data to bank 0
  output [31: 0] CDATAWD1;         // data to bank 1
  output [31: 0] CDATAWD2;         // data to bank 2
  output [31: 0] CDATAWD3;         // data to bank 3

//-------------------------------------------------------------------------
// VALID ram
//-------------------------------------------------------------------------
  output         CVALIDCS;
  output [ 7: 0] CVALIDA;          // address to valid RAM
  output         CVALIDWE;         // 16 valid, 8 rrgen
  input  [23: 0] CVALIDRD;         // 16 valid, 8 rrgen
  output [23: 0] CVALIDWD;         // 16 valid, 8 rrgen
  input          CNoRRgen;

//-------------------------------------------------------------------------
// DIRTY ram
//-------------------------------------------------------------------------
  output         CDIRTYCS;
  output [ 9: 0] CDIRTYA;          // address to dirty RAM
  output [ 7: 0] CDIRTYWE;
  input  [ 7: 0] CDIRTYRD;
  output [ 7: 0] CDIRTYWD;


//#
//# Internal Signals
//# ================
//#

//-------------------------------------------------------------------------
// Sample the memory request information
//-------------------------------------------------------------------------
  wire           CacheReady;
  wire           LastWord;
  wire           CacheSEQ;
  wire           NSeqMemReq;
  wire           MemReq;
  wire           NSeqWrMemReq;
  wire           SeqWrMemReq;
  wire           NSeqRdMemReq;
  wire           SeqRdMemReq;

  wire           sNSeqWrMemReq;
  wire           sNSeqRdMemReq;
  wire           sSeqWrMemReq;
  wire           sSeqRdMemReq;
  wire           sMemReq;

  wire           sRdMemReq;
  wire           RdReCirc;
  wire           sRdReCirc;

  wire           SmpNSeqVA;

  wire   [31: 5] sNSeqVA;
  wire   [ 4: 0] sVA;
  wire   [ 1: 0] sMAS;
  wire           sBIGEND;
  wire   [31:25] sMVA;
  wire   [31:10] sPA;
  wire           sPriv;
  wire           WWriteback;
  wire           sWWriteback;
  wire   [14: 5] sNSeqVAValid;
  wire   [14: 5] sNSeqVALfVA;

//-------------------------------------------------------------------------
// Linefill address registers
//-------------------------------------------------------------------------
  wire           SmpLf;
  wire           SmpLfVA;
  wire   [31: 5] LfVANS;
  wire   [31:25] LfMVA;
  wire   [31: 5] LfVA;
  wire   [31:10] LfPA;
  wire           LfWriteback;
  wire           sLFPATAGrd;

//-------------------------------------------------------------------------
// CReady
//-------------------------------------------------------------------------
  `define CREADY_READY   2'b10
  `define CREADY_LF      2'b00
  `define CREADY_FB      2'b01
  `define CREADY_UNDEF   2'bxx

  wire   [ 1: 0] CReadyCS;
  reg    [ 1: 0] CReadyNS;
  wire           LateCReady1;
  wire           LateCReady2;
  wire           EarlyReady;
  wire           FBPath;

//-------------------------------------------------------------------------
// CIdle
//-------------------------------------------------------------------------
  wire           sWrMemReq;
  wire           CIdleNS;
  wire           CIdleCS;

//-------------------------------------------------------------------------
// CNoFinish
//-------------------------------------------------------------------------
  wire           NoFinishNS;
  wire           NoFinish;

//-------------------------------------------------------------------------
// CSize, CSizeBit, sNSeqVAIndex, LfIndex
//-------------------------------------------------------------------------
  reg    [ 3: 0] Csize;
  reg    [ 5: 0] CSizeBitNS;
  wire   [ 5: 0] CSizeBit;
  reg    [14: 5] sNSeqVAIndex;
  reg    [14: 5] LfIndex;

//-------------------------------------------------------------------------
// uTag control
//-------------------------------------------------------------------------
  wire           InvaluTagAll;
  wire           InvaluTagIndex;
   
//-------------------------------------------------------------------------
// Linefill Dirty logic
//-------------------------------------------------------------------------
  wire           ValidEviction;
  wire           FBIndexMatch;
  wire           FBWayMatch;
  wire           DirtyLower;
  wire           DirtyUpper;
  wire           PWEWBMatchBuf0;
  wire           PWEWBMatchBuf1;
  wire           SmpDirty;
  wire           sDirtyLower;
  wire           sDirtyUpper;
  wire           sPWEWBMatchBuf0;
  wire           sPWEWBMatchBuf1;

//-------------------------------------------------------------------------
// FBDrainUpperFirst
//-------------------------------------------------------------------------
  reg            FBDUFirstNS;
  wire           FBDUFirst;
 
//-------------------------------------------------------------------------
// Combined FB and EWB signals
//-------------------------------------------------------------------------
  wire           DATAUpperSel;
  wire           LFBlock;

//-------------------------------------------------------------------------
// FB Drain fsm
//-------------------------------------------------------------------------
  `define        FB_DRAIN_IDLE   3'b000
  `define        FB_DRAIN_LF1    3'b101
  `define        FB_DRAIN_FB1    3'b100
  `define        FB_DRAIN_FB2    3'b110
  `define        FB_DRAIN_UNDEF  3'bxxx

  wire   [ 2: 0] FBDRAINCState;
  reg    [ 2: 0] FBDRAINNState;
  wire           SmpFBEWB;
  reg            LFMVATAGwr;
  reg            LFDATAwr;
  reg            LFVALIDwr0;
  reg            LFVALIDwr1;
  reg            LFDIRTYrd;
  reg            LFDIRTYwr;
  reg            LFPATAGwr;
  reg            FBDrain;
  reg            DATAFBUpperSel;
  reg            IncrEvictionWay;
  reg            LFSmpDirty;
  wire           LFFBBlock;
  wire           LFStart;

//-------------------------------------------------------------------------
// BIU FB fsm
//-------------------------------------------------------------------------
  `define        BIU_FB_IDLE   3'b000
  `define        BIU_FB_LF1    3'b101
  `define        BIU_FB_PEND   3'b110
  `define        BIU_FB_FB2    3'b100
  `define        BIU_FB_UNDEF  3'bxxx

  wire   [ 2: 0] BIUFBCState;
  reg    [ 2: 0] BIUFBNState;
  wire           FBPending;
  wire           FBBIUReq;
  wire           Linefill;

//-------------------------------------------------------------------------
// EWB Fill fsm
//-------------------------------------------------------------------------
  `define        EWB_FILL_IDLE  3'b000
  `define        EWB_FILL_WAIT  3'b100
  `define        EWB_FILL_WB1   3'b101
  `define        EWB_FILL_WB2   3'b010
  `define        EWB_FILL_EWB2  3'b011
  `define        EWB_FILL_UNDEF 3'bxxx

  wire   [ 2: 0] EWBFILLCState;
  reg    [ 2: 0] EWBFILLNState;
  reg            LFDATArd;
  reg            LFPATAGrd;
  reg            DATAEWBUpperSel;
  reg            EWBLower;
  reg            EWBUpper;
  reg            EWBStart;
  reg            PWEWBWrite;
  reg            PWEWBReadBuf1;
  wire           LFEWBBlock;
  wire           EWBFILLBusy;

//-------------------------------------------------------------------------
// BIU EWB fsm
//-------------------------------------------------------------------------
  `define        BIU_EWB_IDLE   3'b000
  `define        BIU_EWB_WB2    3'b001
  `define        BIU_EWB_EWB2   3'b110
  `define        BIU_EWB_PEND   3'b100
  `define        BIU_EWB_UNDEF  3'bxxx

  wire   [ 2: 0] BIUEWBCState;
  reg    [ 2: 0] BIUEWBNState;
  wire           BIUEWBSel;
  wire           EWBPending;
  wire           EWBBIUReq;

//-------------------------------------------------------------------------
// CP15 Operation registering
//-------------------------------------------------------------------------
  wire           CP15Clean;
  wire           CP15Inval;
  wire           CP15All;
  wire           CP15Set;
  wire           CP15MVA;
  wire           CP15AllNS;
  wire           CP15SetNS;
  wire           CP15MVANS;

//-------------------------------------------------------------------------
// CP15 Dirty evaluation
//-------------------------------------------------------------------------
  reg    [ 3: 0] CP15SetWay;
  wire   [ 7: 0] CP15DirtyWay;
  wire           CP15DirtyWay0;
  wire           CP15DirtyWay1;
  wire           CP15DirtyWay2;
  wire           CP15DirtyWay3;
  reg    [ 3: 0] CP15AllWay;
  wire   [ 3: 0] CP15WayNS;
  wire   [ 3: 0] CP15Way;
  wire           SmpCP15Way;
  wire           CP15DirtyLower;
  wire           CP15DirtyUpper;

//-------------------------------------------------------------------------
// CP15 fsm
//-------------------------------------------------------------------------
  `define        CP15_IDLE  6'b000000
  `define        CP15_PWB   6'b100010   // CP15nRW
  `define        CP15_FB1   6'b100100   // CP15FBDrain
  `define        CP15_FB2   6'b100000
  `define        CP15_OP1   6'b110011   // CP15Start
  `define        CP15_OP2   6'b110010
  `define        CP15_OP3   6'b110100   // CP15Update
  `define        CP15_OP4   6'b111000   // most CP15 triggers
  `define        CP15_OP5   6'b110000
  `define        CP15_UNDEF 6'bxxxxxx

  wire   [ 5: 0] CP15CState;
  reg    [ 5: 0] CP15NState;
  wire           SmpCP15CState;

//-------------------------------------------------------------------------
// CP15 control signals
//-------------------------------------------------------------------------
  wire           CP15InvalAll;
  wire           CP15InvalValid;
  wire           CP15ClearHazard;
  wire           CP15nRW;
  wire           CP15orCnRW;
  wire           CP15InvalFB;
  wire           CP15FBDrain;
  wire           CP15Block;
  wire           CP15Start;
  wire           CP15Update;
  wire           CP15DirtySel;
  wire           CP15IndexSel;
  wire           CP15IndexIncr;
  wire           sCP15Dirty;

//-------------------------------------------------------------------------
// CP15 VALID interface signals
//-------------------------------------------------------------------------
  wire           CP15VALIDCS;
  wire           CP15VALIDrd;
  wire           CP15VALIDwr0;
  wire           sCP15VALIDrd;

//-------------------------------------------------------------------------
// CP15 DIRTY interface signals
//-------------------------------------------------------------------------
  wire           CP15DIRTYCS;
  wire           CP15DIRTYrd;
  wire           CP15DIRTYwr0;

//-------------------------------------------------------------------------
// CP15 TAG interface/EWB_FILL fsm signals
//-------------------------------------------------------------------------
  wire           CP15MVATAGrd;
  wire           CP15Eviction;
  wire           sCP15MVATAGrd;

//-------------------------------------------------------------------------
// CDirty
//-------------------------------------------------------------------------
  wire           CDirtyNS;

//-------------------------------------------------------------------------
// CP15Index
//-------------------------------------------------------------------------
  wire           CountRst;
  wire           CountIncr;
  wire           CountLoop;
  wire   [ 9: 0] CP15IndexNS;
  wire   [ 9: 0] CP15Index;
  wire           SmpCP15Index;
  reg            LastClean;
  reg    [ 9: 0] MaxCount;

//-------------------------------------------------------------------------
// Writing from the PWB to the DATA ram
//-------------------------------------------------------------------------
  wire           PWRAMFull;
  wire   [14: 2] PWRAMAddr;
  wire   [ 3: 0] PWRAMHitWay;
  wire   [ 3: 0] PWRAMByteSel;
  wire           PWRAMWriteback;
  wire   [31: 0] PWRAMD;

//-------------------------------------------------------------------------
// Writing from the PWB to the FB
//-------------------------------------------------------------------------
  wire           PWFBFull;
  wire   [ 4: 2] PWFBWord;
  wire   [ 3: 0] PWFBByteSel;
  wire           PWFBWriteback;
  wire   [31: 0] PWFBD;

//-------------------------------------------------------------------------
// Merging Data from the PWB to CRD
//-------------------------------------------------------------------------
  wire           PWCRDTagHit;        
  wire   [ 3: 0] PWCRDByteSel;
  wire   [31: 0] PWCRDD;
  
//-------------------------------------------------------------------------
// Writing Data from the PWB to EWB
//-------------------------------------------------------------------------
  wire   [ 4: 2] PWEWBWord;
  wire   [ 3: 0] PWEWBByteSel;
  wire   [31: 0] PWEWBD;
  wire           PWEWBMatchLowerBuf0;
  wire           PWEWBMatchUpperBuf0;
  wire           PWEWBMatchLowerBuf1;
  wire           PWEWBMatchUpperBuf1;
  wire           RdPtr;
  wire           sRdPtr;

//-------------------------------------------------------------------------
// RGen
//-------------------------------------------------------------------------
  wire   [ 3: 0] EvictionWay;
  wire   [ 3: 0] sEvictionWay;
  wire   [ 3: 0] LfWay;
  wire   [ 3: 0] LfWayFB;
  wire   [ 3: 0] LfWayTDE;

//-------------------------------------------------------------------------
// FB drain, or BIU/FB data to core
//-------------------------------------------------------------------------
  wire   [31: 0] FBWD0;
  wire   [31: 0] FBWD1;
  wire   [31: 0] FBWD2;
  wire   [31: 0] FBWD3;
  wire   [31: 0] FBRD;

//-------------------------------------------------------------------------
// FB control signals
//-------------------------------------------------------------------------
  wire           FBHit;
  wire           FBWordHit;
  wire           FBFull;
  wire           FBFilling;
  wire           FBFill;
  wire           FBDirtyLower;
  wire           FBDirtyUpper;

//-------------------------------------------------------------------------
// EWB control signals
//-------------------------------------------------------------------------
  wire           EWBBusy;

//-------------------------------------------------------------------------
// TagIntf control signals
//-------------------------------------------------------------------------
  wire           mTagHit;
  wire           smTagHit;
  wire   [ 3: 0] mTagHitWay;
  wire   [ 3: 0] smTagHitWay;
  wire   [21: 0] sTAGRD;

//-------------------------------------------------------------------------
// uTag control signals
//-------------------------------------------------------------------------
  wire           uTagHit;
  wire   [ 3: 0] uTagHitWay;

//-------------------------------------------------------------------------
// ValidIntf control signals
//-------------------------------------------------------------------------
  wire           ValidReady;
  wire   [ 3: 0] ValidWay;
  wire   [ 3: 0] sValidWay;
  wire   [ 1: 0] RRCount;

//-------------------------------------------------------------------------
// DirtyIntf control signals
//-------------------------------------------------------------------------
  wire           Dl;
  wire           Du;
  wire   [ 7: 0] sCDIRTYRD;

//-------------------------------------------------------------------------
// Debug capabilites
//-------------------------------------------------------------------------
  wire           QCnReset;       // qualified CnReset
  reg            sQCnReset;      // registered QCnReset
  wire           DeviceResetNS;
  reg            DeviceReset;
  wire           EnableChecks;   // enable debug checks
  reg            ReadCRD;        // flag to enable checking of CRD

//#
//# Main Code
//# =========
//#

//-------------------------------------------------------------------------
// Sample the memory request address information
// ---------------------------------------------
//   VA[31:0]
//   MVA[31:25]
//   PA[31:10]
//   MAS[1:0]
//   BIGEND
//   Privileged   - BIU interface for linefills
//   WWriteback
// 
// Power can be reduced by only sampling the addresses when they are
// required. So, as sequentiality is broken on cache line boundaries and 
// after any CP15 operation, only the Word bits of the address can change 
// on a sequential access, so sample the address as sNSeqVA = Tag,Index 
// and sVA = Word,Byte. (Byte is strictly speaking NSeq)
// In the same way, MAS and BIGEND cannot change during a sequential 
// operation.
// MVA and PA will only be used for a non-sequential read which missed in
// the cache, so they too can be sampled infrequently on non-sequential 
// reads.
// 
// NSeqMemReq is qualified by CMREQ. Beware of speed for sNSeqVA.
//
//-------------------------------------------------------------------------

//-------------------------------------------------------------------------
// Memory request signals
//-------------------------------------------------------------------------

  assign   CacheReady = (CReady & CCP15Ready) | CCancel;
  assign     LastWord = (sVA[4:2] == 3'b111);    // Last word in cache line
  assign     CacheSEQ = CSEQ & ~LastWord;

  assign       MemReq = CMREQ & CacheReady;
  assign   NSeqMemReq = CMREQ & CacheReady & ~CacheSEQ;

  assign NSeqWrMemReq = CMREQ & CacheReady & CnRW & ~CacheSEQ;
  assign  SeqWrMemReq = CMREQ & CacheReady & CnRW &  CacheSEQ;
					  
  assign NSeqRdMemReq = CMREQ & CacheReady & ~CnRW & ~CacheSEQ;
  assign  SeqRdMemReq = CMREQ & CacheReady & ~CnRW &  CacheSEQ;



//-------------------------------------------------------------------------
// pipeline NSeqWrMemReq, NSeqRdMemReq, SeqWrMemReq & SeqRdMemReq
//-------------------------------------------------------------------------

  a926dffrnx1  usNSRd (sNSeqRdMemReq, NSeqRdMemReq, CClk, CnReset); // IsD
  a926dffrnx1  usSRd  (sSeqRdMemReq,  SeqRdMemReq,  CClk, CnReset); // IsD
  a926dffrnx1  usNSWr (sNSeqWrMemReq, NSeqWrMemReq, CClk, CnReset); // IsD
  a926dffrnx1  usSWr  (sSeqWrMemReq,  SeqWrMemReq,  CClk, CnReset); // IsD
  a926dffrnx1  usMem  (sMemReq,       MemReq,       CClk, CnReset); // IsD



//-------------------------------------------------------------------------
// RdReCirc
// --------
// Detect that the Read hit in the main TAG, but not the microTAG, so
// the read data from the DATA ram will need to be sampled and 
// re-circulated. The output data will then be sampled by the I/DRoute 
// blocks, so this operation will always be 2 cycles.
//
// The pipelined RdReCirc is used to control the CRD muxes and uTag entry 
// loading for Non-Sequential read uTag miss, mTag hit.
//
//-------------------------------------------------------------------------

  assign    sRdMemReq = sNSeqRdMemReq | sSeqRdMemReq; 
  assign     RdReCirc = sRdMemReq & ~uTagHit & mTagHit & ~FBHit & ~CCancel;

  // pipeline RdReCirc

  a926dffrnx1  usRdRCc (sRdReCirc, RdReCirc, CClk, CnReset);



//-------------------------------------------------------------------------
// sNSeqVA[31:5], sVA[4:0]
// -----------------------
// VA[31:5], sampled at the start of an NSeq cycle (read or write)
// VA[4:0], sampled at the start of an NSeq or Seq cycle (read or write)
//
// There are separate sNSeqVA buses for either the ValidIntf or the Dirty,
// Tag and DataIntf, to account for CP15 operations:
//
// For the ValidIntf, CP15IndexSel selects between CP15Index and sNSeqVA, 
// dependent upon whether the CP15 operation is an 'All' operation, or 
// an 'MVA' or 'Index' operation.
//
//           All        Set      MVA
// CP15_OP1  CP15Index  sNSeqVA  sNSeqVA
// CP15_OP2  CP15Index  sNSeqVA  sNSeqVA
// CP15_OP3  CP15Index  sNSeqVA  sNSeqVA
// CP15_OP4  CP15Index  sNSeqVA  sNSeqVA  
// CP15_OP5  CP15Index  sNSeqVA  sNSeqVA
//
// For the Dirty, Tag and DataIntf, LfVA is used as the address.
// To support this, sNSeqVALfVA is assigned to be either CP15Index or
// sNSeqVA in the cycle preceding CP15_OP1, defined by CP15Start, and 
// sampled at the end of the cycle.
//
//                         All        Set      MVA
// CP15Start sNSeqVALfVA = CP15Index  sNSeqVA  sNSeqVA
// CP15_OP1  LfVA        = CP15Index  sNSeqVA  sNSeqVA
// CP15_OP2  LfVA        = CP15Index  sNSeqVA  sNSeqVA
// CP15_OP3  LfVA        = CP15Index  sNSeqVA  sNSeqVA
// CP15_OP4  LfVA        = CP15Index  sNSeqVA  sNSeqVA
// CP15_OP5  LfVA        = CP15Index  sNSeqVA  sNSeqVA
//
//-------------------------------------------------------------------------

  assign SmpNSeqVA = NSeqMemReq | CCP15Req ;

  a926gdffx27  uNSVA   (sNSeqVA,     VA[31:5],   CClk, SmpNSeqVA);
  a926gdffx5   uVA     (sVA,         VA[4:0],    CClk, MemReq);

  // sNSeqVA[14:5] for the ValidIntf
  assign sNSeqVAValid[14:5]   = (CP15IndexSel == 1'b1) ? 
                                 CP15Index : 
                                 sNSeqVA[14:5];

  // sNSeqVA[14:5] for the LfVA register, used by Dirty, Tag and Data
  // for CP15 operations
  assign sNSeqVALfVA[14:5]    = (CP15Start & CP15All) ? 
                                 CP15Index : 
                                 sNSeqVA[14:5];



//-------------------------------------------------------------------------
// sMAS[1:0] and sBIGEND
// ---------------------
// MAS and BIGEND, sampled at the start of an NSeq cycle (read or write)
//-------------------------------------------------------------------------

  a926gdffx3 unSeq({sMAS[1:0], sBIGEND},                             // IsD
                   {CMAS[1:0], BIGEND},                              // IsD
                   CClk, NSeqMemReq);                                // IsD



//-------------------------------------------------------------------------
// sMVA[31:25], sPA[31:10], sPriv, sWWriteback
// -------------------------------------------
// MVA, PA, Privileged and WWriteback, sampled at the end an NSeq read 
// cycle.
//-------------------------------------------------------------------------

  a926gdffx31 usNSeqRd({sMVA[31:25], sPA[31:10], sPriv,      sWWriteback}, // IsD
                       {MVA[6:0],    PA[21:0],   Privileged, WWriteback }, // IsD
                       CClk, sNSeqRdMemReq);                               // IsD



//-------------------------------------------------------------------------
// Linefill address registers
// --------------------------
//
// In normal operation, the linefill registers sample:
//   LfVA[31:5]
//   LfMVA[31:25]
//   LfPA[31:10]
//   LfWriteback
//   sLFPATAGrd, which is LFPATAGrd pipelined to generate an enable to 
//               sample TAGRD.
//
// For CP15 operations, the Index bits from either sNSeqVA or CP15Index
// are sampled to LfVA[14:5], and used by the Dirty, Tag and DataIntf.
// LfVA[31:15] is always sampled sNSeqVA[31:15].
//
//-------------------------------------------------------------------------

  assign SmpLf   = IncrEvictionWay ; 
  assign SmpLfVA = IncrEvictionWay | CP15Start ;

  // concatenate sNSeqVA[31:15] with sNSeqVALfVA[14:5], which muxes
  // in the Index for CP15 operations

  assign LfVANS  = {sNSeqVA[31:15], sNSeqVALfVA[14:5]};

  a926gdffrnx27 uLfVA   (LfVA, LfVANS, CClk, SmpLfVA, CnReset);  // IsD
  a926gdffrnx30 uLfAddr ({LfMVA, LfPA, LfWriteback},             // IsD
                         {sMVA,  sPA,  sWWriteback},             // IsD
                         CClk, SmpLf, CnReset);                  // IsD
  a926dffrnx1   uLfPArd (sLFPATAGrd, LFPATAGrd, CClk, CnReset);  // IsD



//-------------------------------------------------------------------------
// CReady
// ------
// LateCReady1 is dependent upon the uTag, FBHit and FBWordHit
// LateCReady2 is dependent upon the FBHit and FBWordHit
// EarlyCReady is dependent upon the FSM
//
// The FSM generating EarlyCReady is used to select the source for CReady.
//
// There is no combinatorial path from CCancel to CReady. If CCancel is 
// asserted, CReady will remain asserted or deasserted for the end of the 
// MEM/FE cycle. The cache will be ready to accept a new request, 
// regardless of the state of CReady. 
//
//-------------------------------------------------------------------------


  assign CReady = LateCReady1 | LateCReady2 | EarlyReady;


  // CREADY_READY and...
  // - read mem request -> uTag hit (and mTag hit/miss ignored)
  // - read mem request -> FB hit and FBWord hit

  assign LateCReady1 = (CReadyCS[1] & (sNSeqRdMemReq | sSeqRdMemReq)) &
                       (uTagHit | (FBHit & FBWordHit));

  // CREADY_FB and...
  // - word returned from the Fill Buffer, after having waited for it
  //   to be passed from the BIU

  assign LateCReady2 = (CReadyCS[0]) & 
                       (FBWordHit & ValidReady);

  // CREADY_READY and...
  // - NSeq or Seq lookup - cannot be EarlyReady, dependent upon 
  //                        LateCReady1 or LateCReady2
  // CREADY_FB and....
  // - waiting for word from BIU - cannot be EarlyReady, dependent upon 
  //                               LateCReady1 or LateCReady2
  // CREADY_READY and...
  // - no read mem request - this accounts for the genuine case of no
  //                         read mem request, and also the case where.... 
  // - read mem request -> uTag miss and mTag hit. In this case, EarlyReady
  //                       is not asserted for the first lookup cycle, but
  //                       is asserted for the second cycle - if we stayed
  //                       in the CREADY_READY state.
  // Also accounts for the case where....
  // - cancelled read mem request - we stay in the CREADY_READY state and
  //                                look at the next request.
  //
  // might be able to simplify this logic.....or leave to synthesis

  assign EarlyReady  = ~(CReadyCS[1] & (sNSeqRdMemReq | sSeqRdMemReq)) &
                       ~(CReadyCS[0]) & 
                        (CReadyCS[1]);
                       
  // Control the muxes in CRD to select the path from the Fill Buffer
  // if waiting for FBWordHit. This can either be after:
  // - Linefill request
  // - FBHit & ~FBWordHit
  assign FBPath = CReadyCS[0];

  // CReady current state register
  a926dffrnx1 uCReadyCS0(CReadyCS[0], CReadyNS[0], CClk, CnReset);
  a926dffsnx1 uCReadyCS1(CReadyCS[1], CReadyNS[1], CClk, CnReset);

  // CReady next state logic
  always @(
           CReadyCS or
           sNSeqRdMemReq or 
           sSeqRdMemReq or 
           CCancel or
           uTagHit or 
           mTagHit or 
           FBHit or 
           FBWordHit or
           LFStart or 
           ValidReady
          )
  begin : CReadyFSM

    case (CReadyCS)
      `CREADY_READY:
          // read mem request -> Linefill
          if (sNSeqRdMemReq & ~uTagHit & ~mTagHit & ~FBHit & ~CCancel)
            CReadyNS = `CREADY_LF;
        
          // read mem request -> FB hit, but not the FBWord, so will 
          //                     have to wait for the word from the BIU
          else if ((sNSeqRdMemReq | sSeqRdMemReq) & FBHit & ~FBWordHit &
                    ~CCancel)
            CReadyNS = `CREADY_FB;
                
          // Either:
          // - no read mem request
          // - read mem request -> uTag hit and mTag hit
          // - read mem request -> uTag miss and mTag hit
          // - read mem request -> FB hit and FBWord hit
          // - cancelled read mem request - > CReady is unaltered by CCancel
          else
            CReadyNS = `CREADY_READY;

      `CREADY_LF:  
          if (LFStart)
            CReadyNS = `CREADY_FB;
          else
            CReadyNS = `CREADY_LF;

      `CREADY_FB: 
          if (FBWordHit & ValidReady)
            CReadyNS = `CREADY_READY;
          else
            CReadyNS = `CREADY_FB;
   
      // surefire coverage_off
      default:
          CReadyNS = `CREADY_UNDEF;
      // surefire coverage_on
  
    endcase

  end // CReadyFSM



//-------------------------------------------------------------------------
// CIdle
// -----
// The CIdle output indicates that the cache is idle and CClk may be 
// stopped. The system controller is then responsible for restarting the 
// CClk. The main use for the signal is to enable the system controller to
// know when CClk can be stopped for MCR Wait For Interrupt, or when MCR 
// Drain Write Buffer has completed. Both of these are MCR, which means 
// CnRW will indicate a write, which is necessary to ensure that the 
// Pending Write buffer can drain.
// The blocks within the cache that can continue whilst CReady is asserted
// are:
//   - Fill Buffer
//   - Pending Write Buffer
//   - Eviction Buffer
//   - Valid interface
// The logic below uses the fact that the ValidReady signal causes the 
// CReady FSM to return to the Ready state, with CReady[1] asserted.
// By gating sNSeq and sSeq requests with CIdleCS to produce CIdle, this
// ensures that CIdle will never be asserted if CReady is not asserted
// (ie. it removes the pipeline delay after an idle period)
//           _____       _____       _____       _____       _____
// CClk   __/     \_____/     \_____/     \_____/     \_____/     \_____
//        ____             _______________________
// CReady     \___________/                       \_____________________
//        ____                         ___________
// CIdle  ____\_______________________/           \_____________________
//
//
//
// Note: Use of sRdMemReq and sWrMemReq may not be ideal for synthesis.
//
//-------------------------------------------------------------------------

  assign sWrMemReq = sNSeqWrMemReq | sSeqWrMemReq; 

  assign CIdleNS = CReadyCS[1] &
                   (~sRdMemReq & ~LFBlock & ~LFStart & ~FBFilling) &
                   (~sWrMemReq & ~PWRAMFull & ~PWFBFull) &
                   (~EWBFILLBusy) & (~EWBBusy) &
                   (~CP15NState[5]);

  a926dffsnx1 uCIdle(CIdleCS, CIdleNS, CClk, CnReset);

  assign CIdle   = CIdleCS & 
                   ~sNSeqRdMemReq & ~sSeqRdMemReq &
                   ~sNSeqWrMemReq & ~sSeqWrMemReq;
                           


//-------------------------------------------------------------------------
// CNoFinish
// ---------
// Indicates that CReady will not be asserted in the current cycle.
// Set if a linefill is scheduled, this signal must be combinatorially 
// deasserted when CACHEBIUReady is asserted.
//
// The 'Linefill' signal is a decode from the BIUFB fsm, which will remain
// asserted while the previous linefill (if any) is completed. Once it is 
// negated, we are awaiting the first word to be returned from the BIU, 
// indicated by 'CACHEBIUReady'. So, 'NoFinish' extends the signal until
// 'CACHEBIUReady' is asserted.
//-------------------------------------------------------------------------

  assign NoFinishNS = Linefill |                        // Set
                      (NoFinish & ~CACHEBIUReady);      // retain and Reset

  a926dffrnx1 uNoFinished (NoFinish, NoFinishNS, CClk, CnReset);
  
  assign CNoFinish = Linefill | (NoFinish & ~CACHEBIUReady);



//-------------------------------------------------------------------------
// Cassoc, CMbit
// -------------
// Cassoc and CMbit are routed from the cache to CP15 register 1, the Cache
// Type register. The cache is always present, and 4-way associative for
// this cache revision.
// This logic partitioning means that if a different cache
// controller/architecture is used, CP15 will not need to be changed.
//
//-------------------------------------------------------------------------

  assign Cassoc = 3'b010;               // 4-way associativity

  assign CMbit  = 1'b0;                 // Cache present



//-------------------------------------------------------------------------
// Csize and CSizeBit from CACHESIZE
// ---------------------------------
// The user of the a926core needs to define the cache size to configure
// the cache controller appropriately.
// This cache controller supports 4K, 8K, 16K, 32K, 64K and 128K byte
// cache sizes. The encoding of CACHESIZE is such that some encodings
// are not used. Encodings that indicate less than 4K are mapped to 4K, 
// and encodings that indicate more than 128K are mapped to 128K.
// Csize is produced by the cache, reflecting the filtering process, to
// avoid the possible problems which would be caused if CACHESIZE was 
// read directly by CP15 into the CP15 Cache Type Register (register 0)
// CSizeBit[5:0] is used by the ValidIntf and EWB.
//
// CSizeBit[5:0] is registered to remove a speed path in the ValidIntf.
// To reduce power, the CSizeBit register is only clocked when CCP15Req is 
// asserted. This works because until the cache is enabled, the cache will
// receive no memory requests, and changing CP15 register 1 is preceded by 
// the CP15 preamble, which the cache sees as CacheOp = "0000", to clear
// any hazards. This will load the CSizeBit register. Also, any CP15 
// register 7 operations start with CCP15Req, so even if the cache is off, 
// the CSizeBit register will be loaded before the actual CP15 operation 
// is executed. The CSizeBit register resets to indicate a cache size of 
// 4K.
//
//-------------------------------------------------------------------------

  // we need to decode the cache size input bits
  always @(CACHESIZE)
    casez (CACHESIZE)
      4'b0000,
      4'b0001,
      4'b0010,
      4'b0011: begin Csize = 4'b0011; CSizeBitNS = 6'b00_0001; end //   4K
      4'b0100: begin Csize = 4'b0100; CSizeBitNS = 6'b00_0010; end //   8K
      4'b0101: begin Csize = 4'b0101; CSizeBitNS = 6'b00_0100; end //  16K
      4'b0110: begin Csize = 4'b0110; CSizeBitNS = 6'b00_1000; end //  32K
      4'b0111: begin Csize = 4'b0111; CSizeBitNS = 6'b01_0000; end //  64K
      4'b1???: begin Csize = 4'b1000; CSizeBitNS = 6'b10_0000; end // 128K
      // surefire coverage_off
      default: begin Csize = 4'bxxxx; CSizeBitNS = 6'bxx_xxxx; end
      // surefire coverage_on
    endcase

  // CSizeBit register resets to 4K, 6'b00_0001.
  // CSizeBit[5:1] are sampled with other CP15 signals which reset to 0. 
  // CSizeBit[0] is set to 1'b1.

  a926gdffsnx1 uCSB0 (CSizeBit[0],  CSizeBitNS[0],  CClk,CCP15Req,CnReset);



//-------------------------------------------------------------------------
// sNSeqVA Index
// -------------
// sNSeqVAIndex[14:5] is the Index bits of sNSeqVA[31:5], with the top bits
// masked to zero for smaller cache sizes. 
//
// This is used for Dirty<Upper|Lower> evaluation and within the ValidIntf.
// 
// For Dirty<Upper|Lower>, sNSeqVAIndex is compared with LfIndex to 
// produce FBIndexMatch, asserted if the current cache line index is the
// same as the line in the Fill Buffer. If the Way matches as well, 
// FBWayMatch, for a cache line fill, then the Fill Buffer will be drained
// before the cache line is invalidated on the following cycle. So if the
// Fill Buffer contains dirty data, Dirty<Upper|Lower> must be set so that
// the cache line is properly evicted to the EWB.
//
// sNSeqVAIndex is used in the ValidIntf to detect if the contents of the 
// sFB<  > registers should be forwarded when reading the VALID ram.
//
//-------------------------------------------------------------------------

  always @(
           sNSeqVA or
           CSizeBit
          )
  begin : sVAIndex
    case (CSizeBit)
      //                          masked,   sNSeqVA
      6'b000001: sNSeqVAIndex = { 5'b00000, sNSeqVA[ 9:5]}; //   4 KByte
      6'b000010: sNSeqVAIndex = { 4'b0000,  sNSeqVA[10:5]}; //   8 KByte
      6'b000100: sNSeqVAIndex = { 3'b000,   sNSeqVA[11:5]}; //  16 KByte
      6'b001000: sNSeqVAIndex = { 2'b00,    sNSeqVA[12:5]}; //  32 KByte
      6'b010000: sNSeqVAIndex = { 1'b0,     sNSeqVA[13:5]}; //  64 KByte
      6'b100000: sNSeqVAIndex = {           sNSeqVA[14:5]}; // 128 KByte
      // surefire coverage_off
      default:   sNSeqVAIndex = 10'bxx_xxxx_xxxx;
      // surefire coverage_on
    endcase
  end // sVAIndex
 

   
//-------------------------------------------------------------------------
// Linefill Index
// --------------
// LfIndex[14:5] is the Index bits of LfVA[31:5], with the top bits
// masked to zero for smaller cache sizes. 
//
// This is used for Dirty<Upper|Lower> evaluation and within the ValidIntf
// in exactly the same way as sNSeqVAIndex, except it is the Index of
// the linefill and is therefore relevant to the contents of the Fill
// Buffer and the sFB<  > registers.
// 
//-------------------------------------------------------------------------

  always @(
           LfVA or
           CSizeBit
          )
  begin : LinefillIndex
    case (CSizeBit)
      //                     masked,   LfVA
      6'b000001: LfIndex = { 5'b00000, LfVA[ 9:5]}; //   4 KByte
      6'b000010: LfIndex = { 4'b0000,  LfVA[10:5]}; //   8 KByte
      6'b000100: LfIndex = { 3'b000,   LfVA[11:5]}; //  16 KByte
      6'b001000: LfIndex = { 2'b00,    LfVA[12:5]}; //  32 KByte
      6'b010000: LfIndex = { 1'b0,     LfVA[13:5]}; //  64 KByte
      6'b100000: LfIndex = {           LfVA[14:5]}; // 128 KByte
      // surefire coverage_off
      default:   LfIndex = 10'bxx_xxxx_xxxx;
      // surefire coverage_on
    endcase
  end // LinefillIndex
 
   

//-------------------------------------------------------------------------
// uTag control
// ------------
// The whole uTag is invalidated:
//   - CP15 control, via InvalMicroTag
//   - CP15 MCR, Invalidate All
//   - CP15 CacheOp. All cache operations invalidate the uTag.
// Specific entries of the uTag are invalidated:
//   - Linefill
//-------------------------------------------------------------------------

  assign InvaluTagAll   = InvalMicroTag | CP15InvalAll | CP15Start;

  assign InvaluTagIndex = LFStart;



//-------------------------------------------------------------------------
// Linefill Dirty logic
// --------------------
// When an eviction is started, need to take a copy of the dirty
// information, for the BIU interface. These will remain static until
// the next eviction. Needs to be reset at power up to give the correct 
// indication to CP15.
//
// Need to factor in the possible sources of dirty data:
// 1. DATA ram (via DIRTY ram)
// 2. PWB
// 3. FB
// 4. CP15 eviction
//
// The CP15Dirty<Lower|Upper> are only asserted when CP15Update is 
// asserted. At all other times they are zero, so as not to affect normal 
// line eviction operation. This does mean that sPWEWBMatchBuf<0|1> should
// be clocked for CP15 operations so they are correctly cleared, otherwise
// an erroneous merge could be indicated from the previous 
// linefill/eviction.
//
// Dirty<Lower|Upper> are constrained such that if linefills are disabled
// they cannot be asserted for 'linefills'. When the cache has a read miss
// a 'linefill' will be started, but the FB will not be drained. The 
// linefill is started by the FB_DRAIN and BIU_FB fsm executing to 
// completion, but with the FB not being drained, and the line selected
// for eviction will not be invalidated. At the end of the FB_DRAIN fsm 
// execution LFStart will be asserted to start the FB. This will also 
// start the EWB fsms. The EWB_FILL fsm will not continue as the line 
// 'selected' for eviction (it doesn't actually get invalidated), will
// not indicate that it is dirty.
// 1. DIRTY ram read, Dl and Du, are masked out by CNoLinefill
// 2. PWEWBMatch<Lower|Upper><Buf0|Buf1> cannot be set as all writes
//    are marked as being WT (Writeback is gated out by CNoLinefill)
// 3. FBDirty<Lower|Upper> cannot be set as all writes are marked as 
//    being WT (Writeback is gated out by CNoLinefill) 
//
//-------------------------------------------------------------------------

  assign ValidEviction  = |(sValidWay & sEvictionWay);

  assign FBIndexMatch   = (sNSeqVAIndex == LfIndex);
  assign FBWayMatch     = (sEvictionWay == LfWay);

  assign DirtyLower     = (Dl & ValidEviction & ~CNoLinefill)          | 
                          (PWEWBMatchLowerBuf0 | PWEWBMatchLowerBuf1)  |
                          (FBIndexMatch & FBWayMatch & FBDirtyLower)   |
                          CP15DirtyLower ;                              
								       
  assign DirtyUpper     = (Du & ValidEviction & ~CNoLinefill)          |
                          (PWEWBMatchUpperBuf0 | PWEWBMatchUpperBuf1)  |
                          (FBIndexMatch & FBWayMatch & FBDirtyUpper)   |
                          CP15DirtyUpper ;

  assign PWEWBMatchBuf0 = (PWEWBMatchLowerBuf0 | PWEWBMatchUpperBuf0);
  assign PWEWBMatchBuf1 = (PWEWBMatchLowerBuf1 | PWEWBMatchUpperBuf1);

  assign SmpDirty       = LFSmpDirty | CP15Update;

  a926gdffrnx5 uDlDuPm0Pm1RdP(                                           // IsD
       {sDirtyLower, sDirtyUpper, sPWEWBMatchBuf0, sPWEWBMatchBuf1, sRdPtr},  // IsD
       {DirtyLower,  DirtyUpper,  PWEWBMatchBuf0,  PWEWBMatchBuf1,  RdPtr},   // IsD
       CClk, SmpDirty, CnReset);                                      // IsD



//-------------------------------------------------------------------------
// FBDrainUpperFirst
// -----------------
// The linefill fetches data from the requested word first. By decoding
// this, the order of optimum FB draining can be established, based on what
// will be the last word fetched. ie. the half of the cache line that
// has already been filled can be drained simultaneously with the last
// word being written from the BIU.
//
//-------------------------------------------------------------------------

  always @(sVA)
  begin
    case (sVA[4:2])
      3'b000:  FBDUFirstNS = 1'b0;  // last = 7, Drain Lower first
      3'b001:  FBDUFirstNS = 1'b1;  // last = 0, Drain Upper first
      3'b010:  FBDUFirstNS = 1'b1;  // last = 1, Drain Upper first
      3'b011:  FBDUFirstNS = 1'b1;  // last = 2, Drain Upper first
      3'b100:  FBDUFirstNS = 1'b1;  // last = 3, Drain Upper first
      3'b101:  FBDUFirstNS = 1'b0;  // last = 4, Drain Lower first
      3'b110:  FBDUFirstNS = 1'b0;  // last = 5, Drain Lower first
      3'b111:  FBDUFirstNS = 1'b0;  // last = 6, Drain Lower first
      // surefire coverage_off
      default: FBDUFirstNS = 1'bx;
      // surefire coverage_on
    endcase
  end

  // sample the order of filling/eviction, FBDrainUpperFirst

  a926gdffrnx1  uFBDUFirst(FBDUFirst, FBDUFirstNS, CClk, LFStart, CnReset);



//-------------------------------------------------------------------------
// Combined FB and EWB signals
//-------------------------------------------------------------------------

  // Combine to produce DATAUpperSel. The signals are mutually exclusive.
  assign DATAUpperSel = DATAFBUpperSel | DATAEWBUpperSel;

  // Combine to produce LFBlock
  assign LFBlock = LFFBBlock | LFEWBBlock;



//-------------------------------------------------------------------------
// FB Drain fsm
// ------------
// The state names FB_DRAIN_<  > and BIU_FB_<  > align where the 
// bracketted names are the same.
//
//   FB_DRAIN_IDLE      BIU_FB_IDLE
//   FB_DRAIN_LF1       BIU_FB_LF1
//   FB_DRAIN_FB1       BIU_FB_PEND
//   FB_DRAIN_FB2       BIU_FB_PEND or BIU_FB_FB2
//
// The FB_DRAIN fsm controls draining the FB to the TAG, VALID and DATA 
// ram. It is triggered on either a NSeq read miss which is not cancelled, 
// or a CP15FBDrain.
//
// A CP15Drain is requested if the Fill Buffer is either filling or full.
// The FBFill and FBFull flags used in the CP15CState fsm are the DFF
// versions, so that the 'raw' FBFilling is only used in the FB_DRAIN fsm.
//
// The FB_DRAIN fsm can spin/wait in state LF1 because:
// - Fill Buffer is filling and is not full. 
//   This is from the previous linefill request. There will be 
//   no further pending linefill requests, but there may be a 
//   pending Eviction Write Buffer request, which cannot start 
//   until the linefill has finished.
// - Eviction Writeback Buffer is still pending a response from 
//   the BIU. 
//   Until this is cleared, we cannot start a linefill request, as
//   the wrong request attributes will be put on the BIU 
//   interface.
// The fsm will advance to state FB1 if both of the following are true:
// - The Fill buffer is not filling.
//   ie. either Fill Buffer is full, or empty (with no pending 
//   linefill, which is impossible anyway as there could not have
//   been a lookup until the first word of the previous linefill 
//   was returned, so there cannot be a pending linefill request 
//   by definition).
// - Eviction Write Buffer request is not pending.
//   ie. it has either been accepted by the BIU, or was not
//   required.
//
// The CState registers for FBDRAIN, BIUFB, EWBFILL and BIUEWB are all
// combined here to allow clock gating.
//
//-------------------------------------------------------------------------

  // FBDRAIN, BIUFB, EWBFILL & BIUEWB CState registers (IsD)
  a926gdffrnx12 uFBEWBcs ({FBDRAINCState[2:0], BIUFBCState[2:0],     // IsD
                           EWBFILLCState[2:0], BIUEWBCState[2:0]},   // IsD
                          {FBDRAINNState[2:0], BIUFBNState[2:0],     // IsD
                           EWBFILLNState[2:0], BIUEWBNState[2:0]},   // IsD
                          CClk, SmpFBEWB, CnReset);                  // IsD

  // Combined enable for the FBDRAIN, BIUFB, EWBFILL and BIUEWB fsm CState
  assign SmpFBEWB = CP15FBDrain | sNSeqRdMemReq |           // FBDRAIN,BIUFB
                    FBDRAINCState[2] |                      // FBDRAIN
                    BIUFBCState[2] |                        // BIUFB
                    CP15Eviction |                          // EWBFILL
                    EWBFILLCState[2] | EWBFILLCState[1] |   // EWBFILL
                    BIUEWBCState[0] | BIUEWBCState[2];      // BIUEWB

  // FBDRAIN next state logic
  always @(
           FBDRAINCState or
           sNSeqRdMemReq or
           uTagHit or
           mTagHit or
           FBHit or
           CCancel or
           CP15FBDrain or
           EWBPending or
           FBFilling or
           FBFull or
           LfWriteback or
           Linefill or
           CNoLinefill or
           FBDUFirst or
           CDirty
          )
  begin : FBDRAINfsm

    // default output values
    LFMVATAGwr      = 1'b0;
    LFDATAwr        = 1'b0;
    LFVALIDwr0      = 1'b0;
    LFVALIDwr1      = 1'b0;
    LFDIRTYrd       = 1'b0;
    LFDIRTYwr       = 1'b0;
    LFPATAGwr       = 1'b0;
    FBDrain         = 1'b0;
    DATAFBUpperSel  = 1'b0;
    IncrEvictionWay = 1'b0;
    LFSmpDirty      = 1'b0;

    case (FBDRAINCState)
      `FB_DRAIN_IDLE:
         if ((sNSeqRdMemReq & ~uTagHit & ~mTagHit & ~FBHit & ~CCancel) |
             (CP15FBDrain))
           FBDRAINNState   = `FB_DRAIN_LF1;
         else
           FBDRAINNState   = `FB_DRAIN_IDLE;
      `FB_DRAIN_LF1:
         if (EWBPending | FBFilling)
           FBDRAINNState   = `FB_DRAIN_LF1;
         else begin
           LFMVATAGwr      = FBFull;
           LFDATAwr        = FBFull;
           LFVALIDwr0      = Linefill & ~CNoLinefill;
           LFVALIDwr1      = FBFull;
           LFDIRTYrd       = CDirty;
           FBDrain         = FBFull;
           DATAFBUpperSel  = FBDUFirst;
           FBDRAINNState   = `FB_DRAIN_FB1;
         end
      `FB_DRAIN_FB1: begin
           LFDATAwr        = FBFull;
           LFDIRTYwr       = FBFull;
           LFPATAGwr       = FBFull & LfWriteback;    // always 1'b0 for I$
           FBDrain         = FBFull;
           DATAFBUpperSel  = ~FBDUFirst;
           IncrEvictionWay = Linefill;
           LFSmpDirty      = 1'b1;
           FBDRAINNState   = `FB_DRAIN_FB2;
         end
      `FB_DRAIN_FB2: begin
           // LFStart         = Linefill;
           FBDRAINNState   = `FB_DRAIN_IDLE;
         end
      // surefire coverage_off
      default: begin
         LFMVATAGwr      = 1'bx;
         LFDATAwr        = 1'bx;
         LFVALIDwr0      = 1'bx;
         LFVALIDwr1      = 1'bx;
         LFDIRTYrd       = 1'bx;
         LFDIRTYwr       = 1'bx;
         LFPATAGwr       = 1'bx;
         FBDrain         = 1'bx;
         DATAFBUpperSel  = 1'bx;
         IncrEvictionWay = 1'bx;
         LFSmpDirty      = 1'bx;
         FBDRAINNState   = `FB_DRAIN_UNDEF;
      end
      // surefire coverage_on
    endcase
  end // FBDRAINFsm

  assign LFFBBlock = FBDRAINCState[2];

  assign LFStart   = FBDRAINCState[1] & Linefill;



//-------------------------------------------------------------------------
// BIU FB fsm
// ----------
// The state names FB_DRAIN_<  > and BIU_FBB_<  > align where the 
// bracketted names are the same.
// The BIU_FB fsm controls requesting the BIU interface for a linefill
// to the FB. It is triggered on a NSeq read miss which is not cancelled.
//
// The BIU_FB fsm has been extended by one state, BIU_FB_FB2. This has
// no impact on the minimal cycle time, as there is a finite delay
// from CACHEBIUReq to CACHEBIUAck to CACHEBIUReady. The extra state 
// the BIU_FB fsm to indicate Linefill, and allows state BIU_FB_FB2 to 
// align with state FB_DRAIN_FB2, so that LFStart can be asserted if the 
// FB_DRAIN fsm is being used for a linefill. 
//
//-------------------------------------------------------------------------

  // BIUFB next state logic
  always @(
           BIUFBCState or
           sNSeqRdMemReq or
           uTagHit or
           mTagHit or
           FBHit or
           CCancel or
           FBFilling or
           EWBPending or
           CACHEBIUAck
          )
  begin : BIUFBFsm

    case (BIUFBCState)
      `BIU_FB_IDLE:
         if (sNSeqRdMemReq & ~uTagHit & ~mTagHit & ~FBHit & ~CCancel) 
           BIUFBNState = `BIU_FB_LF1;
         else
           BIUFBNState = `BIU_FB_IDLE;
      `BIU_FB_LF1:
         // Linefill = 1'b1, CACHEBIUEarlyReq = 1'b1, FBBIUReq = ?
         BIUFBNState = (EWBPending | FBFilling) ?
                       `BIU_FB_LF1  :
                       `BIU_FB_PEND ;
      `BIU_FB_PEND:
         // Linefill = 1'b1, FBPending = 1'b1
         BIUFBNState = (CACHEBIUAck == 1'b1) ? `BIU_FB_FB2 : `BIU_FB_PEND;
      `BIU_FB_FB2:
         // Linefill = 1'b1
         BIUFBNState = `BIU_FB_IDLE;
      // surefire coverage_off
      default:
         BIUFBNState = `BIU_FB_UNDEF;
      // surefire coverage_on
    endcase
  end // BIUFBFsm    

  assign CACHEBIUEarlyReq = BIUFBCState[0];
  assign FBPending        = BIUFBCState[1]; 
  assign FBBIUReq         = BIUFBCState[0] & ~FBFilling & ~EWBPending;
  assign Linefill         = BIUFBCState[2]; 



//-------------------------------------------------------------------------
// EWB Fill fsm
// ------------
// The state names EWB_FILL_<  > and BIU_EWB_<  > align where the 
// bracketted names are the same.
//
//   EWB_FILL_IDLE      BIU_EWB_IDLE
//   EWB_FILL_WAIT      ---- " -----
//   EWB_FILL_WB1       ---- " -----
//   EWB_FILL_WB2       BIU_EWB_WB2
//                      BIU_EWB_EWB2
//                      BIU_EWB_PEND
//
// The EWB_FILL fsm controls filling the EWB from the DATA ram and PWB.
// It is triggered by either a Linefill (LFStart) or a CP15 operation
// which requires a cache line to be evicted (CP15Eviction). 
//
// At this point the fsm checks for whether the line being evicted is 
// dirty. In the case of a CP15 operation, this has already been worked 
// out, but the same logic and decision making process is still applied.
// 
// Back-to-back evictions are not possible during normal linefill
// operation, but they are if the eviction is due to a CP15 operation.
// ie. CP15 operation before a linefill, back-to-back CP15 operations, or
// linefill to CP15 operation. The EWB_FILL fsm must therefore wait until
// the EWB is empty = not busy.
//
// The EWB_FILL fsm then controls the reading of the DATA ram, and correct
// merging of PWB data into the EWB. The order of merging of data from the 
// PWB needs to be controlled such that if both entries in the PWB need 
// to be merged into the EWB to the same word, they are merged such that 
// the oldest word is merged first. This then becomes the general rule, 
// whether both entries in the PWB relate to the same word in the line 
// or not.
//
// The following code example shows the scenario where this can occur. In
// general it is hard to create because the PWB tries to drain whenever
// there is an ARM9EJ write or idle cycle.
//
//   STR ri, [x] ; cache hit (WB) - stored in PWB
//   STR rj, [x] ; cache hit (WB) - stored in PWB
//   LDR rk, [y] ; cache miss - evicts line x - lfill prevents draining PWB
//
// In this case, STR ri data must be merged into the EWB before the STR rj
// data. As the PWB -> EWB merging is a two cycle sequence, logic has been 
// implemented to detect in which order the PWB buffers should be merged. 
// This means either of RAMBuf0 and RAMBuf1 can be merged in either EWBFILL 
// state WB2 or EWB2 if both entries are in the line being evicted.
//
// The following truth table describes the setting of the mux select signal
// PWEWBReadBuf1:
//
//    sRdPtr   sPWEWBMatchBuf1   sPWEWBMatchBuf0 | PWEWBReadBuf1
//                                               |  WB2    EWB2
//    -------------------------------------------+---------------
//       0            0                 0        |   0       0
//       0            0                 1        |   0       0
//       0            1                 0        |   0       1
//       0            1                 1        |   0       1
//       1            0                 0        |   0       0
//       1            0                 1        |   0       0
//       1            1                 0        |   0       1
//       1            1                 1        |   1       0
//
// The resulting logic expressions are implemented in the FSM below.
//
//-------------------------------------------------------------------------

  // EWBFILL next state logic
  always @(
           EWBFILLCState or
           LFStart or
           CP15Eviction or
           sDirtyLower or
           sDirtyUpper or
           EWBBusy or
           sRdPtr or
           sPWEWBMatchBuf0 or
           sPWEWBMatchBuf1 
          )
  begin : EWBFILLfsm

    // default output values
    LFDATArd        = 1'b0;
    LFPATAGrd       = 1'b0;
    DATAEWBUpperSel = 1'b0;
    EWBLower        = 1'b0;
    EWBUpper        = 1'b0;
    EWBStart        = 1'b0;
    PWEWBWrite      = 1'b0;
    PWEWBReadBuf1   = 1'b0;

    case (EWBFILLCState)
      `EWB_FILL_IDLE:
         casez ({(CP15Eviction|LFStart), sDirtyUpper, sDirtyLower, EWBBusy})
           4'b0???,                                  // no triggers
           4'b100?: EWBFILLNState = `EWB_FILL_IDLE;  // trigger, not dirty
           4'b1101,                                  // trigger, dirty
           4'b1011,                                  //    "
           4'b1111: EWBFILLNState = `EWB_FILL_WAIT;  //    "
           4'b1100,                                  // trigger, dirty, EWB
           4'b1010,                                  //    "
           4'b1110: begin                            //    "
                      LFDATArd      = sDirtyLower;   // Read lower 4 words
                      LFPATAGrd     = 1'b1;          // Read PATAG
                      EWBFILLNState = `EWB_FILL_WB1;
                    end
           // surefire coverage_off
           default: EWBFILLNState = `EWB_FILL_UNDEF;
           // surefire coverage_on
         endcase
      `EWB_FILL_WAIT:
         case (EWBBusy)
           1'b1:    EWBFILLNState = `EWB_FILL_WAIT;
           1'b0:    begin
                      LFDATArd      = sDirtyLower;    // Read lower 4 words
                      LFPATAGrd     = 1'b1;           // Read PATAG
                      EWBFILLNState = `EWB_FILL_WB1;
                    end
           // surefire coverage_off
           default: EWBFILLNState = `EWB_FILL_UNDEF;
           // surefire coverage_on
         endcase
      `EWB_FILL_WB1:  begin
           LFDATArd        = sDirtyUpper;          // Read upper 4 words
           DATAEWBUpperSel = sDirtyUpper;          // Read upper 4 words
           EWBLower        = sDirtyLower;          // Write lower 4 words
           EWBStart        = 1'b1;                 // Start to request BIU
           EWBFILLNState   = `EWB_FILL_WB2;
         end
      `EWB_FILL_WB2:  begin
           EWBUpper        = sDirtyUpper;          // Write upper 4 words
           PWEWBWrite      = sPWEWBMatchBuf0;      // Write from PWB
                                                   // Select PWB buffer
           PWEWBReadBuf1   = sPWEWBMatchBuf1 & sPWEWBMatchBuf0 & sRdPtr; 
           EWBFILLNState   = `EWB_FILL_EWB2;
         end
      `EWB_FILL_EWB2: begin
           PWEWBWrite      = sPWEWBMatchBuf1;      // Write from PWB
                                                   // Select PWB Buffer
           PWEWBReadBuf1   = sPWEWBMatchBuf1 & (~sRdPtr | ~sPWEWBMatchBuf0);
           EWBFILLNState   = `EWB_FILL_IDLE;
         end
      // surefire coverage_off
      default: begin
           LFDATArd        = 1'bx;
           LFPATAGrd       = 1'bx;
           DATAEWBUpperSel = 1'bx;
           EWBLower        = 1'bx;
           EWBUpper        = 1'bx;
           EWBStart        = 1'bx;
           PWEWBWrite      = 1'bx;
           PWEWBReadBuf1   = 1'bx;
           EWBFILLNState   = `EWB_FILL_UNDEF;
         end
      // surefire coverage_on
    endcase
  end // EWBFILLFsm

  assign LFEWBBlock  = EWBFILLCState[2];

  assign EWBFILLBusy = EWBFILLCState[1];



//-------------------------------------------------------------------------
// BIU EWB fsm
// -----------
// The state names EWB_FILL_<  > and BIU_EWB_<  > align where the 
// bracketted names are the same.
//
//   EWB_FILL_IDLE      BIU_EWB_IDLE
//   EWB_FILL_WAIT      ---- " -----
//   EWB_FILL_WB1       ---- " -----
//   EWB_FILL_WB2       BIU_EWB_WB2
//                      BIU_EWB_EWB2
//                      BIU_EWB_PEND
//
// The BIU_EWB fsm controls requesting the BIU interface for an EWB
// eviction. It is triggered by EWBStart, asserted by the EWB_FILL fsm in 
// state EWB_FILL_WB1. 
//
// Whilst the BIU_EWB fsm is active, it asserts EWBPending.
//
//-------------------------------------------------------------------------

  // BIUEWB next state logic
  always @(
           BIUEWBCState or
           EWBStart or
           FBPending or
           CACHEBIUAck
          )
  begin : BIUEWBFsm

    case (BIUEWBCState)
      `BIU_EWB_IDLE:
         BIUEWBNState = (EWBStart == 1'b1)  ? `BIU_EWB_WB2  : `BIU_EWB_IDLE;
      `BIU_EWB_WB2:
         BIUEWBNState = (FBPending == 1'b0) ? `BIU_EWB_EWB2 : `BIU_EWB_WB2;
      `BIU_EWB_EWB2:
         // EWBPending = 1'b1, BIUEWBSel = 1'b1, EWBBIUReq = 1'b1
         BIUEWBNState = `BIU_EWB_PEND;
      `BIU_EWB_PEND:
         // EWBPending = 1'b1, BIUEWBSel = 1'b1
         BIUEWBNState = (CACHEBIUAck == 1'b1) ? `BIU_EWB_IDLE : `BIU_EWB_PEND;
      // surefire coverage_off
      default:
         BIUEWBNState = `BIU_EWB_UNDEF;
      // surefire coverage_on
    endcase
  end // BIUEWBFsm

  assign EWBBIUReq  = BIUEWBCState[1];
  assign EWBPending = BIUEWBCState[2];
  assign BIUEWBSel  = BIUEWBCState[2];



//-------------------------------------------------------------------------
// CP15 operation/CacheOp relationship
// -----------------------------------
//                                                         CRm  Op2 CacheOp
// Inval I$ & D$   (All)             MCR p15,0,Rd,c7,c7,0  0111 000 0100
// Inval I$        (All)             MCR p15,0,Rd,c7,c5,0  0101 000 0100
// Inval D$        (All)             MCR p15,0,Rd,c7,c6,0  0110 000 0100
// Inval I$ single (MVA)             MCR p15,0,Rd,c7,c5,1  0101 001 0101
// Inval I$ single (Set/Way)         MCR p15,0,Rd,c7,c5,2  0101 010 0110
// Inval D$ single (MVA)             MCR p15,0,Rd,c7,c6,1  0110 001 0101
// Inval D$ single (Set/Way)         MCR p15,0,Rd,c7,c6,2  0110 010 0110
// Clean D$        (Test)            MCR p15,0,Rd,c7,c10,0 1010 011 1011
// Clean D$ single (MVA)             MCR p15,0,Rd,c7,c10,1 1010 001 1001
// Clean D$ single (Set/Way)         MCR p15,0,Rd,c7,c10,2 1010 010 1010
// Clean & Inval D$        (Test)    MCR p15,0,Rd,c7,c14,0 1110 011 1111
// Clean & Inval D$ single (MVA)     MCR p15,0,Rd,c7,c14,1 1110 001 1101
// Clean & Inval D$ single (Set/Way) MCR p15,0,Rd,c7,c14,2 1110 010 1110
//
// where CRm[3] = Clean
//       CRm[2] = Invalidate
//       CRm[1] = D$
//       CRm[0] = I$
//
//       Op2 = 0 = All
//       Op2 = 1 = MVA
//       Op2 = 2 = Set/Way
//       Op2 = 3 = Test
//
// so for c7 operations, CacheOp[3:0] = {CRm[3:2],Op2[1:0]}
//
// Additionally CP15 can cause the cache to drain the FB and PWB and
// invalidate the uTag. This avoids hazards caused by matching in these 
// sub-blocks using VA, and a CP15 operation changing the FCSE such that
// the MVA is no longer consistent with the MVA when the Tags in these
// blocks were loaded. This is described as Clear Hazard.
//
// This is summarised below:
//
//                                       CacheOp
// Clear Hazard                          00--        (invoked by CP15)
// Inval $      (All)                    0100
// Inval single (MVA)                    0101
// Inval single (Set/Way)                0110
// Clean all    (CP15Index)              1011        (test & Clean)
// Clean single (MVA)                    1001
// Clean single (Set/Way)                1010
// Clean & Inval all    (CP15Index)      1111        (test & Clean & Inval)
// Clean & Inval single (MVA)            1101
// Clean & Inval single (Set/Way)        1110
//
// For CP15 Way/Set/Word operations, the Way is encoded in VA[31:30].
// This is decoded to CP15SetWay.
//
//-------------------------------------------------------------------------

//-------------------------------------------------------------------------
// CP15 Operation registering
// --------------------------
// The CP15 operations are either:
//   - Clean
//   - Invalidate
//   - Clean & Invalidate
// This is encoded in CacheOP[3:2], and is decoded and sampled to CP15Clean
// and CP15Inval when CCP15Req is asserted.
// 
// The CP15 operations have 3 types of addressing mode:
//   All  - Cache either doesn't need an address, or uses CP15Index
//   Set  - Cache is addressed using the Set/Way
//   MVA  - Cache is addressed by performing a lookup using VA and MVA
// These are decoded from CacheOp[1:0].
//
// The CSizeBit are sampled for synthesis speed reasons. To avoid 
// continuous sampling, they are only sampled when CCP15Req is asserted.
// This is consistent because the cache can only be enabled when CP15 
// register 1 is written to, and this by definition causes a a ClearHazard 
// operation whenever the this register is written, as it could be 
// associated with cache enable/disable and MMU enable/disable. Also,
// it is consistent with CP15 operations which operate on the cache when 
// it is off, as the CCP15Req signal will ensure the CSizeBit are correct 
// before state CP15_OP1 is reached.
// 
//-------------------------------------------------------------------------

  // registered pre-decoded CP15 CacheOp and CSizeBit[5:1]

  a926gdffrnx10 uCP15Grp(
   {CP15Clean,  CP15Inval,  CP15All,   CP15Set,   CP15MVA,   CSizeBit[5:1]  },
   {CacheOp[3], CacheOp[2], CP15AllNS, CP15SetNS, CP15MVANS, CSizeBitNS[5:1]},
   CClk, CCP15Req, CnReset);

  assign CP15AllNS = ( CacheOp[1] &  CacheOp[0]) |       // Test
                     (~CacheOp[1] & ~CacheOp[0]);        // All
  assign CP15SetNS = ( CacheOp[1] & ~CacheOp[0]);        // Set
  assign CP15MVANS = (~CacheOp[1] &  CacheOp[0]);        // MVA



//-------------------------------------------------------------------------
// CP15 Dirty evaluation
// ---------------------
// CP15SetWay is decoded from the upper bits if sNSeqVA, which is sampled
// Rd from MCR p15, 0, Rd, c7, CRm, op2, and is the Way used for CP15 
// Set/Way operations.
//
// CP15DirtyWay[7:0] is the Dl and Du bits for each cache line
// for the Index selected. This applies to MVA, Set or All operations.
// These are produced from the Dirty and Valid bits read and sampled 
// in state CP15_OP2.
// 
// Bit    7    6    5    4    3    2    1    0
//        Du   Dl   Du   Dl   Du   Dl   Du   Dl
//        Way 3     Way 2     Way 1     Way 0
//
// The Du and Dl bits are OR'ed together for each Way to produce 
// CP15DirtyWay<0,1,2,3>.
//
// CP15DirtyWay<0,1,2,3> are then priority encoded so the least significant
// dirty Way is selected as CP15AllWay for cleaning. One-hot encoded [3:0].
//
// For a CP15 Set operation, CP15Way _needs_ to be sampled for CP15Start.
// For a CP15 MVA and All operations, CP15Way needs to be sampled once 
// the decision has been made as to which Way to Clean, indicated by 
// CP15Update. CP15WayNS is also sampled into LfWayTDE, which is then used
// by the TagIntf, DataIntf and EWB, as they evict using the LfVA and LfWay
// paths.
//
// CP15DirtyLower and CP15DirtyUpper are set depending on whether the 
// operation is either an All, Set or MVA operation, and on which Way
// has been priority encoded, selected or matched. These are only asserted
// for CP15 operations, and are then a term in DirtyLower and DirtyUpper,
// which are sampled to sDirtyLower and sDirtyUpper.
//
//-------------------------------------------------------------------------

  // CP15SetWay decoder, decoded from sNSeqVA[31:30]

  always @(sNSeqVA)
  begin : CP15SetWayDecode
    case (sNSeqVA[31:30])
      2'b00:   CP15SetWay = 4'b0001;
      2'b01:   CP15SetWay = 4'b0010;
      2'b10:   CP15SetWay = 4'b0100;
      2'b11:   CP15SetWay = 4'b1000;
      // surefire coverage_off
      default: CP15SetWay = 4'bxxxx;
      // surefire coverage_on
    endcase
  end // CP15SetWayDecode

  // Validate sCDIRTYRD

  assign CP15DirtyWay[0] = sCDIRTYRD[0] & sValidWay[0]; // Dl Way 0
  assign CP15DirtyWay[1] = sCDIRTYRD[1] & sValidWay[0]; // Du Way 0
  assign CP15DirtyWay[2] = sCDIRTYRD[2] & sValidWay[1]; // Dl Way 1
  assign CP15DirtyWay[3] = sCDIRTYRD[3] & sValidWay[1]; // Du Way 1
  assign CP15DirtyWay[4] = sCDIRTYRD[4] & sValidWay[2]; // Dl Way 2
  assign CP15DirtyWay[5] = sCDIRTYRD[5] & sValidWay[2]; // Du Way 2
  assign CP15DirtyWay[6] = sCDIRTYRD[6] & sValidWay[3]; // Dl Way 3
  assign CP15DirtyWay[7] = sCDIRTYRD[7] & sValidWay[3]; // Du Way 3

  // CP15AllWay logic, which selects which Way will be cleaned for the 
  // 'All' operation, based on a priority encode from Way 0 up to Way 3
  // CP15DirtySel ensures CP15DirtyWay0-3 is clean whenever it is sampled.

  assign CP15DirtyWay0 = (CP15DirtyWay[0] | CP15DirtyWay[1]) & CP15DirtySel;
  assign CP15DirtyWay1 = (CP15DirtyWay[2] | CP15DirtyWay[3]) & CP15DirtySel;
  assign CP15DirtyWay2 = (CP15DirtyWay[4] | CP15DirtyWay[5]) & CP15DirtySel;
  assign CP15DirtyWay3 = (CP15DirtyWay[6] | CP15DirtyWay[7]) & CP15DirtySel;

  always @(
           CP15DirtyWay0 or
           CP15DirtyWay1 or
           CP15DirtyWay2 or
           CP15DirtyWay3
          )
    casez ({CP15DirtyWay3, CP15DirtyWay2, CP15DirtyWay1, CP15DirtyWay0})
      4'b???1: CP15AllWay = 4'b0001;
      4'b??10: CP15AllWay = 4'b0010;
      4'b?100: CP15AllWay = 4'b0100;
      4'b1000: CP15AllWay = 4'b1000;
      4'b0000: CP15AllWay = 4'b0000;
      // surefire coverage_off
      default: CP15AllWay = 4'bxxxx;
      // surefire coverage_on
    endcase // PriorityCP15DirtyWay

  // CP15WayNS mux

  assign CP15WayNS = (CP15AllWay  & {4{CP15All & ~CP15Start}}) |  // All
                     (CP15SetWay  & {4{CP15Set |  CP15Start}}) |  // Set
                     (smTagHitWay & {4{CP15MVA & ~CP15Start}}) ;  // MVA


  // CP15Way register

  assign SmpCP15Way = CP15Start | CP15Update;

  a926gdffrnx4 uCP15Way(CP15Way, CP15WayNS, CClk, SmpCP15Way, CnReset);


  // CP15DirtyLower and CP15DirtyUpper

  assign CP15DirtyLower = 
          (CP15All & 
           ((sCDIRTYRD[0] & sValidWay[0] & CP15AllWay[0] & CP15Update) |
            (sCDIRTYRD[2] & sValidWay[1] & CP15AllWay[1] & CP15Update) |
            (sCDIRTYRD[4] & sValidWay[2] & CP15AllWay[2] & CP15Update) |
            (sCDIRTYRD[6] & sValidWay[3] & CP15AllWay[3] & CP15Update))) |
          (CP15Set & 
           ((sCDIRTYRD[0] & sValidWay[0] & CP15SetWay[0] & CP15Update) |
            (sCDIRTYRD[2] & sValidWay[1] & CP15SetWay[1] & CP15Update) |
            (sCDIRTYRD[4] & sValidWay[2] & CP15SetWay[2] & CP15Update) |
            (sCDIRTYRD[6] & sValidWay[3] & CP15SetWay[3] & CP15Update))) |
          (CP15MVA &
           ((sCDIRTYRD[0] & smTagHitWay[0] & CP15Update) |
            (sCDIRTYRD[2] & smTagHitWay[1] & CP15Update) |
            (sCDIRTYRD[4] & smTagHitWay[2] & CP15Update) |
            (sCDIRTYRD[6] & smTagHitWay[3] & CP15Update)));

  assign CP15DirtyUpper = 
          (CP15All & 
           ((sCDIRTYRD[1] & sValidWay[0] & CP15AllWay[0] & CP15Update) |
            (sCDIRTYRD[3] & sValidWay[1] & CP15AllWay[1] & CP15Update) |
            (sCDIRTYRD[5] & sValidWay[2] & CP15AllWay[2] & CP15Update) |
            (sCDIRTYRD[7] & sValidWay[3] & CP15AllWay[3] & CP15Update))) |
          (CP15Set & 
           ((sCDIRTYRD[1] & sValidWay[0] & CP15SetWay[0] & CP15Update) |
            (sCDIRTYRD[3] & sValidWay[1] & CP15SetWay[1] & CP15Update) |
            (sCDIRTYRD[5] & sValidWay[2] & CP15SetWay[2] & CP15Update) |
            (sCDIRTYRD[7] & sValidWay[3] & CP15SetWay[3] & CP15Update))) |
          (CP15MVA &
           ((sCDIRTYRD[1] & smTagHitWay[0] & CP15Update) |
            (sCDIRTYRD[3] & smTagHitWay[1] & CP15Update) |
            (sCDIRTYRD[5] & smTagHitWay[2] & CP15Update) |
            (sCDIRTYRD[7] & smTagHitWay[3] & CP15Update)));



//-------------------------------------------------------------------------
// CP15 fsm
// --------
// The CP15 fsm responds to CCP15Req, and unless the request is for 
// Invalidate All, will advance to the CP15_PWB state. 
//
// Note. CP15 Invalidate All is a single cycle operation, so does not 
// trigger the CP15 fsm.
//
//            CP15_IDLE
//            CP15_PWB
//           /    |
//      CP15_FB1  |  
//      CP15_FB2  |
//           \    |
//            CP15_OP1-->
//            CP15_OP2
//            CP15_OP3
//            CP15_OP4-->
//            CP15_OP5-->
//
//
// In the CP15_PWB state, as the PWB may still have a pending write in the 
// buffer, CP15nRW is asserted which causes CP15orCnRW to be asserted, so
// the PWB can drain before the CP15 operation can continue. In practise,
// most of the cache CP15 operations are MCR, which asserts CnRW anyway, so 
// the PWB is likely to have already drained. However, MRC Test and Clean 
// <and Invalidate> will not have asserted CnRW, so this ensures the PWB 
// is empty. If the EWB is busy, remain in this state until the EWB is 
// idle. Once the EWB is idle and the PWB is empty, if the FB is filling 
// or full, go to the CP15_FB1 state and drain the FB. Otherwise, proceed 
// to the CP15_OP1 state to start the CP15 operation. The FBFill and FBFull 
// flags used in the decision making are the DFF versions, so that the 
// 'raw' FBFilling is only used in the FB_DRAIN fsm.
//
// CP15_FB1 asserts CP15FBDRAIN to trigger the FB_DRAIN fsm, then waits in
// state CP15_FB2 until the FB has drained and the ValidIntf has completed
// validating the VALID ram word.
//
// The transition to state CP15_OP1 asserts CP15Start, which is used to 
// sample LfVA, CP15Way and invalidate the uTag.
// 
// CP15_OP1 is when the Valid, Dirty and Tag chip selects are asserted.
//
// CP15_OP2 is when the associated ram accesses occur and the results are 
// sampled.
// 
// CP15_OP3 is when logic is processed for the Clean operations, and
// CP15Update is asserted to sample CP15Way, CP15Dirty<Lower&Upper>, and 
// LfVANS to LfVA, which will be CP15Index or sNSeqVA.
// 
// CP15_OP4 is when the Valid chip selects are asserted for Invalidate
// operations, the Dirty chip selects are asserted for Clean operations,
// the Tag chip selects are asserted for Clean operations, if appropriate.
// If the Clean operation means a line needs to be evicted, CP15Eviction
// is asserted and the fsm advances to state CP15_OP5. Otherwise, if a 
// Clean operation is not required, the CP15 fsm returns to the CP15_IDLE 
// state.
//
// In CP15_OP5 state, wait until EWBStart is asserted, then return to 
// CP15_IDLE. This asserts CCP15Ready, and stops the fsm from being 
// clocked.
//
//-------------------------------------------------------------------------

  // CP15 current state register
  a926gdffrnx6 uCP15CS(CP15CState, CP15NState, CClk, SmpCP15CState, CnReset);

  assign SmpCP15CState = CCP15Req | CP15CState[5];

  // CP15 next state logic
  always @(
           CP15CState or
           CCP15Req or
           CP15InvalAll or
           EWBPending or
           PWRAMFull or
           FBFill or
           FBFull or
           LFBlock or
           ValidReady or
           CP15ClearHazard or
           CP15Clean or
           CP15MVA or
           sCP15Dirty or
           smTagHit or
           EWBStart
          )
  begin : CP15fsm

    case (CP15CState)
      `CP15_IDLE:
         if (CCP15Req & ~CP15InvalAll)
           CP15NState = `CP15_PWB;
         else
           CP15NState = `CP15_IDLE;
      `CP15_PWB:
         casez ({EWBPending, PWRAMFull, FBFill, FBFull})
           4'b1???: CP15NState = `CP15_PWB;       // EWB Pending to BIU
           4'b01??: CP15NState = `CP15_PWB;       // Pending write to RAM
           4'b0001,                               // FB is full
           4'b0010,                               // FB is filling
           4'b0011: CP15NState = `CP15_FB1;       // FB is filling and full
           4'b0000: CP15NState = `CP15_OP1;       // Nothing pending
           // surefire coverage_off
           default: CP15NState = `CP15_UNDEF;
           // surefire coverage_on
         endcase
      `CP15_FB1:
         CP15NState = `CP15_FB2;
      `CP15_FB2:
         if (~LFBlock & ValidReady)
           CP15NState = `CP15_OP1;
         else
           CP15NState = `CP15_FB2;
      `CP15_OP1:
         if (CP15ClearHazard)
           CP15NState = `CP15_IDLE;
         else
           CP15NState = `CP15_OP2;
      `CP15_OP2:
         CP15NState = `CP15_OP3;
      `CP15_OP3:
         CP15NState = `CP15_OP4;
      `CP15_OP4:
         casez ({CP15Clean, CP15MVA, sCP15Dirty, smTagHit})
           // <Clean | Clean and Invalidate> All & sCP15Dirty
           // <Clean | Clean and Invalidate> Set & sCP15Dirty
           // <Clean | Clean and Invalidate> MVA & sCP15Dirty & smTagHit
           4'b1_0_1_?,                               // All or Set
           4'b1_1_1_1: CP15NState = `CP15_OP5;       // MVA
           // <Clean | Clean and Invalidate> All & ~sCP15Dirty
           // <Clean | Clean and Invalidate> Set & ~sCP15Dirty
           // <Clean | Clean and Invalidate> MVA & (~sCP15Dirty | ~smTagHit)
           // Invalidate Set 
           // Invalidate MVA 
           default:    CP15NState = `CP15_IDLE;
         endcase
      `CP15_OP5:
         if (EWBStart)
           CP15NState = `CP15_IDLE;
         else
           CP15NState = `CP15_OP5;
      // surefire coverage_off
      default:
           CP15NState   = `CP15_UNDEF;
      // surefire coverage_on
    endcase
  end // CP15fsm



//-------------------------------------------------------------------------
// CP15 control signals
// --------------------
// CP15InvalAll is a single cycle CP15 operation/signal used to reset uTag, 
// PWB, FB, CDirty and CP15Index, asserted 
//
// CP15InvalValid is a single cycle CP15 operation/signal asserted when
// CP15InvalAll is asserted, but also at the end of a CP15 Test & Clean & 
// Invalidate loop, to reset the Valid Reg in the ValidIntf.
//
// CP15ClearHazard is a CP15 operation decode such that the cache must
// drain the PWB and drain the FB, but nothing else, returning to the 
// CP15_IDLE state from CP15_OP1.
//
// CCP15Ready is the inverse of CP15CState[5], to give fast timing.
// It relies on the CP15 fsm not leaving CP15_IDLE for a CP15InvalAll
// operation.
//
// CP15nRW is asserted in state CP15_PWB, and will remain asserted in 
// this state whilst the PWB is drained. It is ORed with CnRW and used
// by the PWB, DataIntf, DirtyIntf, CDirty, CP15Index. It is not used
// in the top level memory request control or the uTag, where it is a
// critical path, and for power saving only.
//
// CP15InvalFB is used only by the FB. It is only asserted if CNoLinefill 
// is asserted, and is then asserted at the
// start of every CP15 operation. This ensures that even though the FB
// is not drained at the start of the CP15 operation the contents are
// invalidated so no further matches can occur in the FB once the CP15 
// operation has completed.
//
// CP15FBDrain is asserted in state CP15_FB1 and instructs the FB_DRAIN
// fsm to drain the FB before continuing with the CP15 operation.
//
// CP15Block is used like LFBlock within the DataIntf to control address
// muxing, and force the DataIntf to use the LF address path.
//
// CP15Start is asserted on the transition to the state CP15_OP1. It is
// used to invalidate the uTag, and sample CP15Way and LfVA.
//
// CP15Update is asserted in state CP15_OP3. It is used sample CP15Way,
// define and sample CP15Dirty<Lower&Upper>, and sample LfVANS to LfVA.
//
// CP15DirtySel ensures CP15DirtyWay<0-3> is clean whenever it is 
// sampled.
//
// CP15IndexSel selects between sNSeqVA or CP15Index for sNSeqVA[14:5]
// used by the ValidIntf. The resultant sNSeqVA[31:5], using the muxed
// bits[14:5], are also sampled into LfVA. LfVA is then used by the 
// Dirty, Tag, Data and BIU interfaces
//
// CP15IndexIncr is used to increment the CP15Index counter at the end
// of a CP15All operation. As the CP15 operation can finish in state
// CP15_OP4 or OP5, the completion of the operation is detected by
// CP15CState[4] changing from 1 to 0.
//
// sCP15Dirty is the OR of the sDirtyLower and sDirtyUpper, which were
// sampled at the end of CP15_OP3, and are then used in CP15_OP4 to decide
// whether to return to CP15_IDLE or continue to CP15_OP5.
//
//
// Note the use of NState for CP15Start and CP15IndexIncr.
//-------------------------------------------------------------------------

  assign CP15InvalAll = CCP15Req & (CacheOp == 4'b0100);       // CP15


  // note CP15IndexIncr factors in CP15Clean & CP15All directly, and hence
  // into CountIncr
  assign CP15InvalValid = (CCP15Req & (CacheOp == 4'b0100))     |  // CP15
                          (CP15Inval & ~CDirty & CP15IndexIncr) |  // ~Dirty
                          (CP15Inval & CountIncr & CountLoop);     // Dirty

  assign CP15ClearHazard = ~CP15Clean & ~CP15Inval;

  assign CCP15Ready    = ~CP15CState[5];



  assign CP15nRW       = ~CP15CState[4] &  CP15CState[1];

  assign CP15orCnRW    = CP15nRW | CnRW;

  assign CP15InvalFB   = ~CP15CState[4] &  CP15CState[1] & CNoLinefill;

  assign CP15FBDrain   = ~CP15CState[4] &  CP15CState[2] & ~CNoLinefill;


  assign CP15Block     =  CP15CState[4];

  assign CP15Start     =  CP15NState[0];

  assign CP15Update    =  CP15CState[4] &  CP15CState[2];

  assign CP15DirtySel  =  CP15CState[4] & ~CP15CState[1];

  assign CP15IndexSel  =  CP15CState[4] & CP15All;

  assign CP15IndexIncr =  CP15CState[4] & ~CP15NState[4] & CP15Clean & CP15All;

  assign sCP15Dirty    = sDirtyLower | sDirtyUpper;



//-------------------------------------------------------------------------
// CP15 VALID interface signals
// ----------------------------
// CP15VALIDCS  = OP1 | (OP4 & (Inval<Set|(MVA & Hit)|All>)
// CP15VALIDrd  = OP1
// CP15VALIDwr0 =       (OP4 & (Inval<Set|(MVA & Hit)|All>)
//
// For all CP15 operations:
//
//           Invalidate        Clean             Clean&Invalidate
//           All Set MVA       All Set MVA       All Set MVA
// CP15_OP1  Rd  Rd  Rd        Rd  Rd  Rd        Rd  Rd  Rd
// CP15_OP2
// CP15_OP3
// CP15_OP4  Wr  Wr  Hit:Wr                      Wr  Wr  Hit:Wr
// CP15_OP5
//
// This means that whether the cache line is valid or not, if it is being
// invalidated, it is written as being invalid.
//
//-------------------------------------------------------------------------

  assign CP15VALIDCS  = 
    CP15CState[0] |                                             // OP1
    (CP15CState[3] & CP15Inval & CP15All) |                     // InvalAll
    (CP15CState[3] & CP15Inval & CP15Set) |                     // InvalSet
    (CP15CState[3] & CP15Inval & CP15MVA & smTagHit) ;          // InvalMVA

  assign CP15VALIDrd  =
    CP15CState[0] ;                                             // OP1

  assign CP15VALIDwr0 =
    (CP15CState[3] & CP15Inval & CP15All) |                     // InvalAll
    (CP15CState[3] & CP15Inval & CP15Set) |                     // InvalSet
    (CP15CState[3] & CP15Inval & CP15MVA & smTagHit) ;          // InvalMVA

  a926dffrnx1 usCP15VALIDrd (sCP15VALIDrd, CP15VALIDrd, CClk, CnReset);



//-------------------------------------------------------------------------
// CP15 DIRTY interface signals
// ----------------------------
// CP15DIRTYCS  = (OP1 & Clean) | (OP4 & Clean<Set|(MVA & Hit)|All>)
// CP15DIRTYrd  = (OP1 & Clean)
// CP15DIRTYwr0 =                 (OP4 & Clean<Set|(MVA & Hit)|All>)
//
// For all CP15 operations:
//
//           Invalidate        Clean             Clean&Invalidate
//           All Set MVA       All Set MVA       All Set MVA
// CP15_OP1                    Rd  Rd  Rd        Rd  Rd  Rd
// CP15_OP2
// CP15_OP3
// CP15_OP4                    Wr  Wr  Hit:Wr    Wr  Wr  Hit:Wr
// CP15_OP5
//
// This means that whether the cache line is dirty or not, if it is being
// cleaned, it is written as being clean.
//
//-------------------------------------------------------------------------

  assign CP15DIRTYCS  =
    (CP15CState[0] & CP15Clean) |                               // OP1
    (CP15CState[3] & CP15Clean & CP15All) |                     // CleanAll
    (CP15CState[3] & CP15Clean & CP15Set) |                     // CleanSet
    (CP15CState[3] & CP15Clean & CP15MVA & smTagHit) ;          // CleanMVA

  assign CP15DIRTYrd  =
    (CP15CState[0] & CP15Clean) ;                               // OP1

  assign CP15DIRTYwr0 = 
    (CP15CState[3] & CP15Clean & CP15All) |                     // CleanAll
    (CP15CState[3] & CP15Clean & CP15Set) |                     // CleanSet
    (CP15CState[3] & CP15Clean & CP15MVA & smTagHit) ;          // CleanMVA



//-------------------------------------------------------------------------
// CP15 TAG interface/EWB_FILL fsm signals
// ---------------------------------------
// CP15MVATAGrd = (OP1 & MVA)
// CP15PATAGrd is not required, as it is produced as LFPATAGrd from the 
// EWB_FILL fsm.
// CP15Eviction = (OP4 & Clean<Set|(MVA & Hit)|All> & sCP15Dirty)
//
// For all CP15 operations, reading the MVATAG:
//
//          Invalidate   Clean                     Clean&Invalidate
//          All Set MVA  All    Set    MVA         All    Set    MVA
// CP15_OP1         Rd                 Rd                        Rd
// CP15_OP2
// CP15_OP3
// CP15_OP4
// CP15_OP5
//
// For all CP15 operations, triggering an eviction:
//
//          Invalidate   Clean                     Clean&Invalidate
//          All Set MVA  All    Set    MVA         All    Set    MVA
// CP15_OP1
// CP15_OP2
// CP15_OP3
// CP15_OP4              Dty:Wr Dty:Wr Hit&Dty:Wr  Dty:Wr Dty:Wr Hit&Dty:Wr
// CP15_OP5
//
//-------------------------------------------------------------------------

  assign CP15MVATAGrd = 
    (CP15CState[0] & CP15MVA) ;

  assign CP15Eviction  = 
    (CP15CState[3] & CP15Clean & CP15All & sCP15Dirty) |           // All
    (CP15CState[3] & CP15Clean & CP15Set & sCP15Dirty) |           // Set
    (CP15CState[3] & CP15Clean & CP15MVA & sCP15Dirty & smTagHit); // MVA

  a926dffrnx1 usCP15MVATAGrd (sCP15MVATAGrd, CP15MVATAGrd, CClk, CnReset);



//-------------------------------------------------------------------------
// CDirty
// ------
// Set whenever there is a Pending Write which sets a dirty bit.
// Cleared after successful completion of 
//   - CP15 Test & Clean Loop
//   - CP15 Test & Clean & Inval Loop
//   - CP15InvalAll
// 
// - It will _not_ be reset due to natural eviction.
//
// The signal means:
// 'A Pending Write has set a dirty bit, and until the cache is completely
//  cleaned or invalidated, assume the cache is dirty'

//-------------------------------------------------------------------------

  assign CDirtyNS = 
    (PWRAMFull & PWRAMWriteback & CP15orCnRW & ~LFBlock) |   // set
    (PWFBFull & PWFBWriteback) |                             // set
    (CDirty &                                                // retain
    ~(CP15InvalAll |                                         // reset
      (CountIncr & CountLoop)));                             // reset

  a926dffrnx1 uCDirty (CDirty, CDirtyNS, CClk, CnReset); // IsD
  


//-------------------------------------------------------------------------
// CP15Index
// ---------
// Reset to 10'h0:
//   - Pending Write from a Writeback region, which will set a Dirty bit
//     in either the Dirty ram or the Fill Buffer.
//   - CP15InvalAll
// Incremented:
//   - At the end of a CP15 Test & <Clean|Clean&Inval> operation where 
//     CP15DirtyWay indicates that this is the last clean for that Index
// Increment and Loopback:
//   - Increment condition above and the CP15Index count has reached the 
//     MaxCount, defined by CACHESIZE.
//
// The Test & Clean <& Invalidate> loop is reset when CDirty is asserted,
// which occurs when a write to a writeback region hits in the cache.
// The MRC Test & Clean <& Invalidate> operation starts from Index 0, and
// tests all 4 ways. 
// - If none are dirty, the CP15Index count is incremented to Index 1 and 
//   the operation finishes. 
// - If one way is dirty, that way is cleaned, the CP15Index count is 
//   incremented to Index 1 and the operation finishes. 
// - If two or more ways are dirty, that least significant way is cleaned, 
//   the CP15Index count is _not_ incremented and the operation finishes. 
// Applying these rules, the MRC is repeatedly applied until the CP15Index 
// count loops back to zero, and CDirty is negated.
//
// The LastClean logic detects whether to increment the CP15Index, and
// the MaxCount logic produces the upper limit of the CP15Count, dependent
// upon cache size.
//
//-------------------------------------------------------------------------

  assign CountRst     = (PWRAMFull & PWRAMWriteback & CP15orCnRW & ~LFBlock) |
                        (PWFBFull & PWFBWriteback) |
                        CP15InvalAll;

  assign CountIncr    = CDirty & CP15IndexIncr & LastClean;

  assign CountLoop    = (CP15Index == MaxCount);

  assign CP15IndexNS  = (CountRst | (CountLoop & CountIncr)) ?
                        10'b00_0000_0000 :             // Reset or Loop back
                        // verilint 484 off
                        CP15Index + 10'b00_0000_0001;  // Increment
                        // verilint 484 on

  assign SmpCP15Index = CountRst | CountIncr;

  a926gdffrnx10 uCP15Idx(CP15Index, CP15IndexNS, CClk, SmpCP15Index, CnReset); // IsD

  // last clean for that Index?

  always @(
           CP15DirtyWay0 or
           CP15DirtyWay1 or
           CP15DirtyWay2 or
           CP15DirtyWay3
          )
    case ({CP15DirtyWay3, CP15DirtyWay2, CP15DirtyWay1, CP15DirtyWay0})
      4'b0000:  LastClean = 1'b1;  // none of the Ways are dirty and valid
      4'b0001:  LastClean = 1'b1;  // only Way 1 is dirty and valid
      4'b0010:  LastClean = 1'b1;  // only Way 2 is dirty and valid
      4'b0100:  LastClean = 1'b1;  // only Way 3 is dirty and valid
      4'b1000:  LastClean = 1'b1;  // only Way 4 is dirty and valid
      default:  LastClean = 1'b0;  // more than one Way is dirty and valid
    endcase
      
  // encode MaxCount, based on CACHESIZE

  always @(CACHESIZE)
    casez (CACHESIZE)
      4'b0000,
      4'b0001,
      4'b0010,
      4'b0011: MaxCount = 10'b0000011111;  //   4K and below
      4'b0100: MaxCount = 10'b0000111111;  //   8K
      4'b0101: MaxCount = 10'b0001111111;  //  16K
      4'b0110: MaxCount = 10'b0011111111;  //  32K
      4'b0111: MaxCount = 10'b0111111111;  //  64K
      4'b1???: MaxCount = 10'b1111111111;  // 128K and above
      // surefire coverage_off
      default: MaxCount = 10'bxxxxxxxxxx;
      // surefire coverage_on
    endcase



//-------------------------------------------------------------------------
// Debug capabilites
// -----------------
//-------------------------------------------------------------------------

// synopsys translate_off
// verilint all off
// surefire coverage_off

  //-----------------------------------------------------------------------
  // Enable for Checks after reset
  //-----------------------------------------------------------------------

  assign QCnReset = (CnReset === 1'bx) ? 1'b0 : CnReset;

  always @(posedge CClk)
    sQCnReset = #1 QCnReset;

  assign DeviceResetNS = (QCnReset & ~sQCnReset) | DeviceReset;

  always @(posedge CClk)
    if (CnReset == 1'b0)
      DeviceReset = #1 1'b0;
    else 
      DeviceReset = #1 DeviceResetNS; 

  assign EnableChecks = DeviceReset | DeviceResetNS;
    

  //-----------------------------------------------------------------------
  // Checks after reset, once enabled
  //-----------------------------------------------------------------------

  always @(posedge CClk)
  if (EnableChecks) begin
  
    //---------------------------------------------------------------------
    // RAM Chip Selects, CTAGCS, CDATACS, CVALIDCS, CDIRTYCS
    //---------------------------------------------------------------------
    if (^(CTAGCS) === 1'bx) begin
      $display("%t, Undef CTAGCS",$time);
  `ifdef __NO_STOP__
      #1000 $stop;
  `endif //__NO_STOP__
    end
    if (^(CDATACS) === 1'bx) begin
      $display("%t, Undef CDATACS",$time);
  `ifndef __NO_STOP__
      #1000 $stop;
  `endif //__NO_STOP__
    end
    if (CVALIDCS === 1'bx) begin
      $display("%t, Undef CVALIDCS",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (CDIRTYCS === 1'bx) begin
      $display("%t, Undef CDIRTYCS",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end

    //---------------------------------------------------------------------
    // RAM Write Data, CDATAWDn, CTAGWD, CVALIDWD, CDIRTYWD
    //---------------------------------------------------------------------
    if (((CDATACS[0] & CDATABYTEWE[0]) === 1'b1) && (^(CDATAWD0[7:0])) === 1'bx) begin
      $display("%t, Undefined CDATAWD0[7:0]",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CDATACS[0] & CDATABYTEWE[1]) === 1'b1) && (^(CDATAWD0[15:8])) === 1'bx) begin
      $display("%t, Undefined CDATAWD0[15:8]",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CDATACS[0] & CDATABYTEWE[2]) === 1'b1) && (^(CDATAWD0[23:16])) === 1'bx) begin
      $display("%t, Undefined CDATAWD0[23:16]",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CDATACS[0] & CDATABYTEWE[3]) === 1'b1) && (^(CDATAWD0[31:24])) === 1'bx) begin
      $display("%t, Undefined CDATAWD0[31:24]",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CDATACS[1] & CDATABYTEWE[0]) === 1'b1) && (^(CDATAWD1[7:0])) === 1'bx) begin
      $display("%t, Undefined CDATAWD1[7:0]",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CDATACS[1] & CDATABYTEWE[1]) === 1'b1) && (^(CDATAWD1[15:8])) === 1'bx) begin
      $display("%t, Undefined CDATAWD1[15:8]",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CDATACS[1] & CDATABYTEWE[2]) === 1'b1) && (^(CDATAWD1[23:16])) === 1'bx) begin
      $display("%t, Undefined CDATAWD1[23:16]",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CDATACS[1] & CDATABYTEWE[3]) === 1'b1) && (^(CDATAWD1[31:24])) === 1'bx) begin
      $display("%t, Undefined CDATAWD1[31:24]",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CDATACS[2] & CDATABYTEWE[0]) === 1'b1) && (^(CDATAWD2[7:0])) === 1'bx) begin
      $display("%t, Undefined CDATAWD2[7:0]",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CDATACS[2] & CDATABYTEWE[1]) === 1'b1) && (^(CDATAWD2[15:8])) === 1'bx) begin
      $display("%t, Undefined CDATAWD2[15:8]",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CDATACS[2] & CDATABYTEWE[2]) === 1'b1) && (^(CDATAWD2[23:16])) === 1'bx) begin
      $display("%t, Undefined CDATAWD2[23:16]",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CDATACS[2] & CDATABYTEWE[3]) === 1'b1) && (^(CDATAWD2[31:24])) === 1'bx) begin
      $display("%t, Undefined CDATAWD2[31:24]",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CDATACS[3] & CDATABYTEWE[0]) === 1'b1) && (^(CDATAWD3[7:0])) === 1'bx) begin
      $display("%t, Undefined CDATAWD3[7:0]",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CDATACS[3] & CDATABYTEWE[1]) === 1'b1) && (^(CDATAWD3[15:8])) === 1'bx) begin
      $display("%t, Undefined CDATAWD3[15:8]",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CDATACS[3] & CDATABYTEWE[2]) === 1'b1) && (^(CDATAWD3[23:16])) === 1'bx) begin
      $display("%t, Undefined CDATAWD3[23:16]",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CDATACS[3] & CDATABYTEWE[3]) === 1'b1) && (^(CDATAWD3[31:24])) === 1'bx) begin
      $display("%t, Undefined CDATAWD3[31:24]",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CTAGCS[0] & CTAGWE[0]) === 1'b1) && (^(CTAGWD) === 1'bx)) begin
      $display("%t, Undefined CTAGWD",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CTAGCS[1] & CTAGWE[1]) === 1'b1) && (^(CTAGWD) === 1'bx)) begin
      $display("%t, Undefined CTAGWD",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CTAGCS[2] & CTAGWE[2]) === 1'b1) && (^(CTAGWD) === 1'bx)) begin
      $display("%t, Undefined CTAGWD",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CTAGCS[3] & CTAGWE[3]) === 1'b1) && (^(CTAGWD) === 1'bx)) begin
      $display("%t, Undefined CTAGWD",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CVALIDCS & CVALIDWE) === 1'b1) && (^(CVALIDWD) === 1'bx)) begin
      $display("%t, Undefined CVALIDWD",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((CDIRTYCS & |(CDIRTYWE)) === 1'b1) && (^(CDIRTYWD) === 1'bx)) begin
      $display("%t, Undefined CDIRTYWD",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end

    //---------------------------------------------------------------------
    // CNoFinish
    //---------------------------------------------------------------------
    if ((CReady & CNoFinish) === 1'b1) begin
      $display("%t, CReady and CNoFinish asserted together",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end

    //---------------------------------------------------------------------
    // CIdle
    //---------------------------------------------------------------------
    if ((~CReady & CIdle) === 1'b1) begin
      $display("%t, CReady not asserted, but CIdle asserted",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if ((~CCP15Ready & CIdle) === 1'b1) begin
      $display("%t, CCP15Ready not asserted, but CIdle asserted",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if ((~(FBDRAINCState === `FB_DRAIN_IDLE) & CIdle) === 1'b1) begin
      $display("%t, FBDRAIN fsm not idle, but CIdle asserted",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if ((~(BIUFBCState === `BIU_FB_IDLE) & CIdle) === 1'b1) begin
      $display("%t, BIUFB fsm not idle, but CIdle asserted",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if ((~(EWBFILLCState === `EWB_FILL_IDLE) & CIdle) === 1'b1) begin
      $display("%t, EWBFILL fsm not idle, but CIdle asserted",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if ((~(BIUEWBCState === `BIU_EWB_IDLE) & CIdle) === 1'b1) begin
      $display("%t, BIUEWB fsm not idle, but CIdle asserted",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if ((~(CP15CState === `CP15_IDLE) & CIdle) === 1'b1) begin
      $display("%t, CP15 fsm not idle, but CIdle asserted",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if ((FBFilling & CIdle) === 1'b1) begin
      $display("%t, Fill Buffer filling, but CIdle asserted",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if ((EWBBusy & CIdle) === 1'b1) begin
      $display("%t, Eviction Buffer evicting, but CIdle asserted",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if (((PWRAMFull | PWFBFull) & CIdle) === 1'b1) begin
      $display("%t, Pending Write Buffer full, but CIdle asserted",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end
    if ((~ValidReady & CIdle) === 1'b1) begin
      $display("%t, Valid interface not ready, but CIdle asserted",$time);
 `ifndef __NO_STOP__
      #1000 $stop;
 `endif //__NO_STOP__
    end

    //---------------------------------------------------------------------
    // mTagHitWay
    //---------------------------------------------------------------------
    if ((sNSeqRdMemReq | sNSeqWrMemReq) === 1'b1) begin
      casez (mTagHitWay)
        4'b0001,
        4'b0010,
        4'b0100, 
        4'b1000,
        4'b0000: ; // OK
        4'bx???,
        4'b?x??,
        4'b??x?,
        4'b???x: begin
                 $display("%t, Undefined mTagHitWay, %b",$time,mTagHitWay); 
 `ifndef __NO_STOP__
                 #1000 $stop;
 `endif //__NO_STOP__
                 end
        default: begin
                 $display("%t, Multiple hit, mTagHitWay, %b",$time,mTagHitWay);
 `ifndef __NO_STOP__
                 #1000 $stop;
 `endif //__NO_STOP__
                 end
      endcase
    end
  end


  //-----------------------------------------------------------------------
  // CRD
  //-----------------------------------------------------------------------
  always @(posedge CClk)
  if (EnableChecks) begin

    if ((CReady | (~CReady & CCancel)) & (CMREQ & ~CnRW))
      ReadCRD <= #1 1'b1;
    else if ((CReady | (~CReady & CCancel)) & ((CMREQ & CnRW) | (~CMREQ)))
      ReadCRD <= #1 1'b0;
  
    if (CReady & ReadCRD) begin
      if (^(CRD) === 1'bx) begin
        $display("%t, Undefined CRD, %b",$time,CRD);
 `ifndef __NO_STOP__
        #1000 $stop;
 `endif //__NO_STOP__
      end
    end

  end



// surefire coverage_on
// verilint all on
// synopsys translate_on

//-------------------------------------------------------------------------
// Instantiate sub-blocks
// ======================
//-------------------------------------------------------------------------

//-------------------------------------------------------------------------
// Instantiate PWB
// ---------------
//-------------------------------------------------------------------------

a926CachePWB uPWB(                              // IsD
  .CClk             (CClk),                     // IsD
  .CnReset          (CnReset),                  // IsD
                                                // IsD
  .CnRW             (CP15orCnRW),               // IsD
  .sNSeqWrMemReq    (sNSeqWrMemReq),            // IsD
  .sSeqWrMemReq     (sSeqWrMemReq),             // IsD
  .sNSeqRdMemReq    (sNSeqRdMemReq),            // IsD
  .sSeqRdMemReq     (sSeqRdMemReq),             // IsD
  .CCancel          (CCancel),                  // IsD
  .CP15InvalAll     (CP15InvalAll),             // IsD
                                                // IsD
  .mTagHit          (mTagHit),                  // IsD
  .FBHit            (FBHit),                    // IsD
                                                // IsD
  .LFBlock          (LFBlock),                  // IsD
  .LFStart          (LFStart),                  // IsD
                                                // IsD
  .PWEWBWrite       (PWEWBWrite),               // IsD
  .PWEWBReadBuf1    (PWEWBReadBuf1),            // IsD
                                                // IsD
  .CWD              (CWD[31:0]),                // IsD
  .Writeback        (Writeback),                // IsD
  .DisableWriteback (DisableWriteback),         // IsD
  .CNoLinefill      (CNoLinefill),              // IsD
  .RawMVA           (RawMVA[31:25]),            // IsD
  .sNSeqVA          (sNSeqVA[24:5]),            // IsD
  .sVA              (sVA[4:0]),                 // IsD
  .CSizeBit         (CSizeBit[5:0]),            // IsD
  .sMAS             (sMAS[1:0]),                // IsD
  .sBIGEND          (sBIGEND),                  // IsD
  .mTagHitWay       (mTagHitWay[3:0]),          // IsD
  .sEvictionWay     (sEvictionWay[3:0]),        // IsD
                                                // IsD
  .WWriteback       (WWriteback),               // IsD
  .DontCommit       (DontCommit),               // IsD
                                                // IsD
  .PWRAMFull        (PWRAMFull),                // IsD
  .PWRAMAddr        (PWRAMAddr[14:2]),          // IsD
  .PWRAMHitWay      (PWRAMHitWay[3:0]),         // IsD
  .PWRAMByteSel     (PWRAMByteSel[3:0]),        // IsD
  .PWRAMWriteback   (PWRAMWriteback),           // IsD
  .PWRAMD           (PWRAMD[31:0]),             // IsD
                                                // IsD
  .PWFBFull         (PWFBFull),                 // IsD
  .PWFBWord         (PWFBWord[4:2]),            // IsD
  .PWFBByteSel      (PWFBByteSel[3:0]),         // IsD
  .PWFBWriteback    (PWFBWriteback),            // IsD
  .PWFBD            (PWFBD[31:0]),              // IsD
                                                // IsD
  .PWCRDTagHit      (PWCRDTagHit),              // IsD
  .PWCRDByteSel     (PWCRDByteSel[3:0]),        // IsD
  .PWCRDD           (PWCRDD[31:0]),             // IsD
                                                // IsD
  .PWEWBWord            (PWEWBWord[4:2]),       // IsD
  .PWEWBByteSel         (PWEWBByteSel[3:0]),    // IsD
  .PWEWBD               (PWEWBD[31:0]),         // IsD
  .RdPtr                (RdPtr),                // IsD
  .PWEWBMatchLowerBuf0  (PWEWBMatchLowerBuf0),  // IsD
  .PWEWBMatchUpperBuf0  (PWEWBMatchUpperBuf0),  // IsD
  .PWEWBMatchLowerBuf1  (PWEWBMatchLowerBuf1),  // IsD
  .PWEWBMatchUpperBuf1  (PWEWBMatchUpperBuf1)   // IsD
);                                              // IsD
                




//-------------------------------------------------------------------------
// Instantiate EWB
// ---------------
//-------------------------------------------------------------------------

a926CacheEWB uEWB(                              // IsD
  .CClk            (CClk),                      // IsD
  .CnReset         (CnReset),                   // IsD
                                                // IsD
  .CDATARD0        (CDATARD0[31:0]),            // IsD
  .CDATARD1        (CDATARD1[31:0]),            // IsD
  .CDATARD2        (CDATARD2[31:0]),            // IsD
  .CDATARD3        (CDATARD3[31:0]),            // IsD
                                                // IsD
  .EWBLower        (EWBLower),                  // IsD
  .EWBUpper        (EWBUpper),                  // IsD
  .LfWay           (LfWayTDE[3:0]),             // IsD
                                                // IsD
  .CACHEBIUNextWD  (CACHEBIUNextWD),            // IsD
  .CACHEBIUWD      (CACHEBIUWD[31:0]),          // IsD
                                                // IsD
  .PWEWBD          (PWEWBD[31:0]),              // IsD
  .PWEWBByteSel    (PWEWBByteSel[3:0]),         // IsD
  .PWEWBWord       (PWEWBWord[4:2]),            // IsD
  .PWEWBWrite      (PWEWBWrite),                // IsD
                                                // IsD
  .EWBBusy         (EWBBusy)                    // IsD
);                                              // IsD


//-------------------------------------------------------------------------
// Instantiate FB
// --------------
//-------------------------------------------------------------------------

a926CacheFB uFB(
  .CClk           (CClk),
  .CnReset        (CnReset),
  
  .PWFBFull       (PWFBFull),
  .PWFBWord       (PWFBWord[4:2]),
  .PWFBByteSel    (PWFBByteSel[3:0]),
  .PWFBWriteback  (PWFBWriteback),
  .PWFBD          (PWFBD[31:0]),
  
  .BIURD          (BIURD[31:0]),
  .CACHEBIUReady  (CACHEBIUReady),

  .sMemReq        (sMemReq),
  .sVA            (sVA[4:2]),
  .sNSeqVA        (sNSeqVA[24:5]),
  .RawMVA         (RawMVA[31:25]),
  .LfVA           (LfVA[24:5]),
  .LfMVA          (LfMVA[31:25]),
  .LfWay          (LfWayFB[3:0]),

  .FBHit          (FBHit),
  .FBWordHit      (FBWordHit),
  .FBFull         (FBFull),
  .FBFilling      (FBFilling),
  .FBFill         (FBFill),
  .FBDirtyLower   (FBDirtyLower),
  .FBDirtyUpper   (FBDirtyUpper),
  .FBDrain        (FBDrain),
  .DATAFBUpperSel (DATAFBUpperSel),
  .LFStart        (LFStart),

  .CP15InvalAll   (CP15InvalAll),
  .CP15InvalFB    (CP15InvalFB),
  .CNoLinefill    (CNoLinefill),

  .FBWD0          (FBWD0[31:0]),
  .FBWD1          (FBWD1[31:0]),
  .FBWD2          (FBWD2[31:0]),
  .FBWD3          (FBWD3[31:0]),
  .FBRD           (FBRD[31:0])
);

//-------------------------------------------------------------------------
// Instantiate RGen
// ----------------
//-------------------------------------------------------------------------

a926CacheRGen uRGen(
  .CClk            (CClk),
  .CnReset         (CnReset),
  
  .RRBIT           (RRBIT),
  .CnWayAlloc      (CnWayAlloc[3:0]),

  .RRCount         (RRCount[1:0]),
  .CNoRRgen        (CNoRRgen),

  .LFBlock         (LFBlock),
  .SmpLf           (SmpLf),

  .CP15WayNS       (CP15WayNS),
  .CP15Update      (CP15Update),

  .EvictionWay     (EvictionWay[3:0]),
  .sEvictionWay    (sEvictionWay[3:0]),
  .LfWay           (LfWay[3:0]),
  .LfWayFB         (LfWayFB[3:0]),
  .LfWayTDE        (LfWayTDE[3:0])
);

//-------------------------------------------------------------------------
// Instantiate Tag RAM Interface
// -----------------------------
//-------------------------------------------------------------------------

a926CacheTagIntf uTagIntf(
  .CClk          (CClk),

  .CTAGCS        (CTAGCS[3:0]),
  .CTAGA         (CTAGA[10:0]),
  .CTAGWE        (CTAGWE[3:0]),
  .CTAGRD0       (CTAGRD0[21:0]),
  .CTAGRD1       (CTAGRD1[21:0]),
  .CTAGRD2       (CTAGRD2[21:0]),
  .CTAGRD3       (CTAGRD3[21:0]),
  .CTAGWD        (CTAGWD[21:0]),

  .CBISTEN       (CBISTEN),
  .CBISTA        (CBISTA[10:0]),
  .CBISTTAGCS    (CBISTTAGCS[3:0]),
  
  .CMREQ         (CMREQ),
  .CSEQ          (CSEQ),
  .LastWord      (LastWord),
  .CacheReady    (CacheReady),
  .sNSeqWrMemReq (sNSeqWrMemReq),
  .sNSeqRdMemReq (sNSeqRdMemReq),
  .LFMVATAGwr    (LFMVATAGwr),
  .LFPATAGwr     (LFPATAGwr),
  .LFPATAGrd     (LFPATAGrd),
  .sLFPATAGrd    (sLFPATAGrd),
  
  .VA            (VA[14:5]),
  .sNSeqVA       (sNSeqVA[24:10]),
  .MVA           (MVA[6:0]),
  .LfPA          (LfPA[31:10]),
  .LfMVA         (LfMVA[31:25]),
  .LfVA          (LfVA[24:5]),

  .ValidWay      (ValidWay[3:0]),
  .LfWay         (LfWayTDE[3:0]),

  .CP15MVATAGrd  (CP15MVATAGrd),
  .sCP15MVATAGrd (sCP15MVATAGrd),

  .mTagHit       (mTagHit),
  .smTagHit      (smTagHit),
  .mTagHitWay    (mTagHitWay[3:0]),
  .smTagHitWay   (smTagHitWay[3:0]),
  .sTAGRD        (sTAGRD)
);

//-------------------------------------------------------------------------
// Instantiate Data RAM Interface
// ------------------------------
//-------------------------------------------------------------------------

a926CacheDataIntf uDataIntf(
  .CClk          (CClk),

  .PWRAMFull     (PWRAMFull),
  .PWRAMAddr     (PWRAMAddr[14:2]),
  .PWRAMHitWay   (PWRAMHitWay[3:0]),
  .PWRAMByteSel  (PWRAMByteSel[3:0]),
  .PWRAMD        (PWRAMD[31:0]),

  .PWCRDTagHit   (PWCRDTagHit),
  .PWCRDByteSel  (PWCRDByteSel[3:0]),
  .PWCRDD        (PWCRDD[31:0]),
  
  .CMREQ         (CMREQ),
  .CSEQ          (CSEQ),
  .CnRW          (CP15orCnRW),
  .LastWord      (LastWord),
  .CacheReady    (CacheReady),
  .sNSeqRdMemReq (sNSeqRdMemReq),
  .sSeqRdMemReq  (sSeqRdMemReq),
  .VA            (VA[14:2]),
  .LfVA          (LfVA[14:5]),
  .sVA           (sVA[4:2]), 
  .LFBlock       (LFBlock),
  .LFDATArd      (LFDATArd),
  .LFDATAwr      (LFDATAwr),
  .DATAUpperSel  (DATAUpperSel),
  .LfWay         (LfWayTDE[3:0]),
  .mTagHitWay    (mTagHitWay[3:0]),
  .smTagHitWay   (smTagHitWay[3:0]),
  .uTagHitWay    (uTagHitWay[3:0]),
  .RdReCirc      (RdReCirc),
  .sRdReCirc     (sRdReCirc),

  .CP15Block     (CP15Block),
		 
  .CBISTEN       (CBISTEN),
  .CBISTDATACS   (CBISTDATACS[3:0]),
  .CBISTA        (CBISTA[12:0]),
		 
  .CDATACS       (CDATACS[3:0]),
  .CDATAINDEX    (CDATAINDEX[9:0]),
  .CDATAWORDB0   (CDATAWORDB0[2:0]),
  .CDATAWORDB1   (CDATAWORDB1[2:0]),
  .CDATAWORDB2   (CDATAWORDB2[2:0]),
  .CDATAWORDB3   (CDATAWORDB3[2:0]),
  .CDATABYTEWE   (CDATABYTEWE[3:0]),
  .CDATARD0      (CDATARD0[31:0]),
  .CDATARD1      (CDATARD1[31:0]),
  .CDATARD2      (CDATARD2[31:0]),
  .CDATARD3      (CDATARD3[31:0]),
  .CDATAWD0      (CDATAWD0[31:0]),
  .CDATAWD1      (CDATAWD1[31:0]),
  .CDATAWD2      (CDATAWD2[31:0]),
  .CDATAWD3      (CDATAWD3[31:0]),
		 
  .CRD           (CRD[31:0]),
  		 
  .FBHit         (FBHit),
  .FBPath        (FBPath),
  .FBRD          (FBRD[31:0]),
  .FBWD0         (FBWD0[31:0]),
  .FBWD1         (FBWD1[31:0]),
  .FBWD2         (FBWD2[31:0]),
  .FBWD3         (FBWD3[31:0]) 
);

//-------------------------------------------------------------------------
// Instantiate valid RAM interface
// -------------------------------
//-------------------------------------------------------------------------

a926CacheValidIntf uValidIntf(
  .CClk          (CClk),
  .CnReset       (CnReset),

  .CMREQ         (CMREQ),
  .CSEQ          (CSEQ),
  .LastWord      (LastWord),
  .CacheReady    (CacheReady),
  .sNSeqWrMemReq (sNSeqWrMemReq),
  .sNSeqRdMemReq (sNSeqRdMemReq),
  .LFVALIDwr0    (LFVALIDwr0),
  .LFVALIDwr1    (LFVALIDwr1),
  
  .VA            (VA[14:7]),
  .sNSeqVA       (sNSeqVAValid[14:5]),
  .sNSeqVAIndex  (sNSeqVAIndex[14:7]),
  .LfIndex       (LfIndex[14:7]),
  .CSizeBit      (CSizeBit[5:0]),
  .EvictionWay   (EvictionWay[3:0]),

  .CP15InvalAll  (CP15InvalValid),
  .CP15VALIDCS   (CP15VALIDCS),
  .sCP15VALIDrd  (sCP15VALIDrd),
  .CP15VALIDwr0  (CP15VALIDwr0),
  .CP15Way       (CP15Way[3:0]),

  .CBISTEN       (CBISTEN),
  .CBISTVALIDCS  (CBISTVALIDCS),
  .CBISTA        (CBISTA[7:0]),
  

  .CVALIDCS      (CVALIDCS),
  .CVALIDA       (CVALIDA[7:0]),
  .CVALIDWE      (CVALIDWE),
  .CVALIDRD      (CVALIDRD[23:0]),
  .CVALIDWD      (CVALIDWD[23:0]),

  .ValidReady    (ValidReady),

  .ValidWay      (ValidWay[3:0]),
  .sValidWay     (sValidWay[3:0]),
  .RRCount       (RRCount[1:0])
);

//-------------------------------------------------------------------------
// Instantiate dirty RAM Interface
// -------------------------------
//-------------------------------------------------------------------------

a926CacheDirtyIntf uDirtyIntf(                  // IsD
  .CClk           (CClk),                       // IsD
  .CnReset        (CnReset),                    // IsD
                                                // IsD
  .LFDIRTYrd      (LFDIRTYrd),                  // IsD
  .sNSeqVA        (sNSeqVA[14:5]),              // IsD
  .sEvictionWay   (sEvictionWay[3:0]),          // IsD
                                                // IsD
  .LFDIRTYwr      (LFDIRTYwr),                  // IsD
  .LfVA           (LfVA[14:5]),                 // IsD
  .LfWay          (LfWay[3:0]),                 // IsD
  .FBDirtyLower   (FBDirtyLower),               // IsD
  .FBDirtyUpper   (FBDirtyUpper),               // IsD
                                                // IsD
  .PWRAMFull      (PWRAMFull),                  // IsD
  .PWRAMWriteback (PWRAMWriteback),             // IsD
  .PWRAMAddr      (PWRAMAddr[14:4]),            // IsD
  .PWRAMHitWay    (PWRAMHitWay[3:0]),           // IsD
  .CnRW           (CP15orCnRW),                 // IsD
  .LFBlock        (LFBlock),                    // IsD
                                                // IsD
  .CDIRTYCS       (CDIRTYCS),                   // IsD
  .CDIRTYA        (CDIRTYA[9:0]),               // IsD
  .CDIRTYWE       (CDIRTYWE[7:0]),              // IsD
  .CDIRTYRD       (CDIRTYRD[7:0]),              // IsD
  .CDIRTYWD       (CDIRTYWD[7:0]),              // IsD
                                                // IsD
  .CBISTEN        (CBISTEN),                    // IsD
  .CBISTDIRTYCS   (CBISTDIRTYCS),               // IsD
  .CBISTA         (CBISTA[9:0]),                // IsD
                                                // IsD
  .CP15DIRTYCS    (CP15DIRTYCS),                // IsD
  .CP15DIRTYrd    (CP15DIRTYrd),                // IsD
  .CP15DIRTYwr0   (CP15DIRTYwr0),               // IsD
  .CP15Way        (CP15Way[3:0]),               // IsD
                                                // IsD
  .Dl             (Dl),                         // IsD
  .Du             (Du),                         // IsD
  .sCDIRTYRD      (sCDIRTYRD)                   // IsD
);                                              // IsD

//-------------------------------------------------------------------------
// Instantiate BIU interface
// -------------------------
//-------------------------------------------------------------------------

a926CacheBiuIntf uBiuIntf(
  .sDirtyLower   (sDirtyLower),
  .sDirtyUpper   (sDirtyUpper),

  .CACHEBIUReq   (CACHEBIUReq),
  .CACHEBIUA     (CACHEBIUA[31:0]),
  .CACHEBIUBurst (CACHEBIUBurst[2:0]),
  .CACHEBIUnRW   (CACHEBIUnRW),
  .CACHEBIUWrap  (CACHEBIUWrap),
  .CACHEBIUPriv  (CACHEBIUPriv),

  .FBBIUReq      (FBBIUReq),
  .EWBBIUReq     (EWBBIUReq),
  .BIUEWBSel     (BIUEWBSel),
  .sPA           (sPA[31:10]),
  .sNSeqVA       (sNSeqVA[9:5]),
  .sVA           (sVA[4:2]),
  .sTAGRD        (sTAGRD[21:0]),
  .LfVA          (LfVA[9:5]),
  .sPriv         (sPriv)
);

//-------------------------------------------------------------------------
// Instantiate uTag
// ----------------
//-------------------------------------------------------------------------

a926CacheUTag uUTag(
  .CClk           (CClk),
  .CnReset        (CnReset),

  .CacheReady     (CacheReady),
  .CnRW           (CnRW),
  .sNSeqRdMemReq  (sNSeqRdMemReq),
  .sSeqRdMemReq   (sSeqRdMemReq),
 
  .sRdReCirc      (sRdReCirc),
  .InvaluTagAll   (InvaluTagAll),
  .InvaluTagIndex (InvaluTagIndex),
  .smTagHitWay    (smTagHitWay[3:0]),
  .sValidWay      (sValidWay[3:0]),

  .VA             (VA[31:5]),
  .sNSeqVA        (sNSeqVA[31:5]),

  .uTagHit        (uTagHit),
  .uTagHitWay     (uTagHitWay[3:0])
);

endmodule // a926Cache

//-------------------------------------------------------------------------
// Restrict the scope of the `define definitions to this block
//-------------------------------------------------------------------------
`undef CREADY_READY
`undef CREADY_LF
`undef CREADY_FB
`undef CREADY_UNDEF
`undef FB_DRAIN_IDLE
`undef FB_DRAIN_LF1
`undef FB_DRAIN_FB1
`undef FB_DRAIN_FB2
`undef FB_DRAIN_UNDEF
`undef BIU_FB_IDLE
`undef BIU_FB_LF1
`undef BIU_FB_PEND
`undef BIU_FB_FB2
`undef BIU_FB_UNDEF
`undef EWB_FILL_IDLE
`undef EWB_FILL_WAIT
`undef EWB_FILL_WB1
`undef EWB_FILL_WB2
`undef EWB_FILL_EWB2
`undef EWB_FILL_UNDEF
`undef BIU_EWB_IDLE
`undef BIU_EWB_WB2
`undef BIU_EWB_EWB2
`undef BIU_EWB_PEND
`undef BIU_EWB_UNDEF
`undef CP15_IDLE 
`undef CP15_PWB  
`undef CP15_FB1  
`undef CP15_FB2  
`undef CP15_OP1  
`undef CP15_OP2  
`undef CP15_OP3  
`undef CP15_OP4  
`undef CP15_OP5  
`undef CP15_UNDEF
