//----------------------------------------------------------------------------
//     The confidential and proprietary information contained in this file may
//     only be used by a person authorised under and to the extent permitted
//     by a subsisting licensing agreement from ARM Limited.
//
//            (C) COPYRIGHT 2003 ARM Limited.
//                ALL RIGHTS RESERVED
//
//     This entire notice must be reproduced on all copies of this file
//     and copies of this file may only be made by a person if such person is
//     permitted to do so under the terms of a subsisting license agreement
//     from ARM Limited.
//
// Checked In : 2003/10/01 15:32:46
// Version    : a926ejsUTLB.v,v 1.32 2003/10/01 15:32:46 dbull ARM926EJS_r0p5-00rel0
// Release Information : ARM926EJS_r0p5-00rel0 
//
//----------------------------------------------------------------------------

`timescale 1 ns / 1 ps

`include "smt_debug.vh"

module a926ejsUTLB (
  GCLK, UTLBnReset, UTLBreadyout,
  
  SysCLKEN, LookupStall,

  CacheEn, SysProt, ROMProt, AlignCheck,       

  UTLBreq, UTLBreadyin, UTLBidleabortout, UTLBabortout, UTLBfs, UTLBntrans, UTLBlock, UTLBnrw,

  UTLBabortin, UTLBdfault, UTLBdomain, UTLBcommit, UTLBpa, UTLBclient, UTLBap, 
  UTLBsize, UTLBcbL1, UTLBcbL2, UTLBregion, UTLBpage,

  A, nMREQ, nRW, SEQ, LOCK, nTRANS, MAS, ABORT, KILL, PA,

  CP15prefetch,

  TCMregion, TCMpagesize, TCMnewpage, DtoITCM, Cregion, Writeback, NCNBregion, NCBregion,

  MMUabort, ExtAbort,

  L2Cacheable, L2Bufferable,

  UTLBinvalidate, UTLBmatch, UTLBload
);

  input          GCLK;               // clock
  input          UTLBnReset;         // UTLB reset
  output         UTLBreadyout;       // UTLB lookup complete, release SYSCTL

  input          SysCLKEN;           // SYSCTL clock enable
  output         LookupStall;        // stall required following lookup

  input          CacheEn;            // CP15 cache enable
  input          SysProt;            // CP15 system protection
  input          ROMProt;            // CP15 ROM protection
  input          AlignCheck;         // CP15 alignment checking enabled

  output         UTLBreq;            // UTLB request to main-MMU
  input          UTLBreadyin;        // UTLB response valid from main-MMU
  output         UTLBidleabortout;   // UTLB abort to main-MMU for idle generation
  output         UTLBabortout;       // UTLB abort to main-MMU
  output [ 7: 0] UTLBfs;             // UTLB fault status to main-MMU
  reg    [ 7: 0] UTLBfs;
  output         UTLBntrans;         // UTLB user/priv indicator to main-MMU
  output         UTLBlock;           // UTLB lock indicator to main-MMU
  output         UTLBnrw;            // UTLB read/write indicator to main-MMU

  input          UTLBabortin;        // UTLB abort, from main-MMU
  input          UTLBdfault;         // UTLB domain fault from main-MMU
  input  [ 3: 0] UTLBdomain;         // UTLB domain select from main-MMU
  input          UTLBcommit;         // UTLB can commit entry
  input  [31:10] UTLBpa;             // UTLB phyiscal address from main-MMU
  input          UTLBclient;         // UTLB access a client
  input  [ 1: 0] UTLBap;             // UTLB access permission from main-MMU
  input  [ 3: 0] UTLBsize;           // UTLB size
                                     //   0b1011   1M region
                                     //   0b1010 512K region
                                     //   0b1001 256K region
                                     //   0b1000 128K region
                                     //   0b0111  64K region
                                     //   0b0110  32K region
                                     //   0b0101  16K region
                                     //   0b0100   8K region
                                     //   0b0011   4K region
                                     //   0b0001   1K region
  input  [ 1: 0] UTLBcbL1;           // UTLB L1 cacheable/bufferable from main-MMU
  input  [ 1: 0] UTLBcbL2;           // UTLB L2 cacheable/bufferable from main-MMU
  input  [ 1: 0] UTLBregion;         // UTLB region from main-MMU
                                     //   0b00 : not DTCM or ITCM region
                                     //   0b01 : DTCM region
                                     //   0b10 : ITCM region
                                     //   0b11 : DTCM-to-ITCM region, or ITCM region
  input          UTLBpage;           // UTLB page, not section

  input  [31: 0] A;                  // (CA/EX) ARM core virtual address
  input          nMREQ;              // (CA/EX) ARM core memory request
  input          nRW;                // (CA/EX) ARM core read/write indicator
  input  [ 1: 0] MAS;                // (CA/EX) ARM core access size
  input          SEQ;                // (CA/EX) ARM core sequential access
  input          LOCK;               // (CA/EX) ARM core locked transfer indicator
  input          nTRANS;             // (CA/EX) ARM core user/priviledge transfer
  input          KILL;               // (FE/ME) ARM core kill operation
  output         ABORT;              // (FE/ME) ARM core abort input
  output [31: 0] PA;                 // physical address

  input          CP15prefetch;       // CP15 prefetch active

  output         TCMregion;          // TCM region being accessed
  output [ 3: 0] TCMpagesize;        // TCM page size being accessed
  output         TCMnewpage;         // TCM accessing a new page from last access
  output         DtoITCM;            // data access in instruction TCM
  output         Cregion;            // Cache region being accessed, WT or WB
  output         Writeback;          // Cache region is WB
  output         NCNBregion;         // NCNB region being accessed
  output         NCBregion;          // NCB region being accessed

  output         MMUabort;           // MMU generated abort (to SYSCTL)
  input          ExtAbort;           // External abort (from SYSCTL)

  output         L2Cacheable;        // L2 cacheable indicator
  output         L2Bufferable;       // L2 bufferable indicator

  input          UTLBinvalidate;     // UTLB invalidate all
  input          UTLBmatch;          // UTLB match enable
  input          UTLBload;           // UTLB load enable following tablewalk
 
//#
//# Internal Signals
//# ================
//#

  wire           CbitD1,SbitD1,RbitD1,AbitD1;

  wire   [ 3: 0] RegionD1;
  wire   [ 1: 0] cbL2D1;
  wire           WritebackD1;

  wire   [31: 0] AD1;
  wire   [31:10] PAD1;

  wire           APfaultC1;
  wire           DfaultC1;

  wire           MfaultC2;
  wire           MfaultD1;

  wire   [ 1: 0] MASD1;
  wire           nMREQD1;
  wire           AfaultC1;

  wire           SEQabortC2;
  wire           SEQabortD1;

  wire           StallAbortC2;
  wire           StallAbortD1;
  wire           SysClkEnD1;
  wire           MaskC2;
  wire           MaskD1;
  wire           MaskC1;

  wire           UTLBreqSetC2;
  wire           UTLBreqC2;
  wire           UTLBreadyoutC2;
  wire           UloadC1;
  wire   [ 1: 0] UloadC2;
  wire   [ 1: 0] UloadD1;

  wire           UnTRANS,ULOCK,UnRW;
  wire   [ 2: 0] APselC2;

  wire           LookupC1;
  wire           LookupD1;
  wire   [ 1: 0] UpdateC2;

  wire           TCMmissC1;
  wire   [ 3: 0] PageSizeD1;

  wire   [ 1: 0] UreqC1;
  wire   [ 1: 0] UhitEnC2;
  wire   [ 1: 0] UhitEnD1;
  wire   [ 1: 0] UmatchEnC2;
  wire   [ 1: 0] UmatchEnD1;

  wire           UmissC1;
  wire   [ 8: 0] UhitC1;
  wire   [ 8: 0] UhitD1;
  wire   [ 1: 0] UinvalC1;

  wire           CP15prefetchD1;
  wire           CP15inval;
  wire   [ 1: 0] UTLBinvalC2;
  wire   [ 1: 0] UTLBinvalD1;
  wire           UTLBinval;
  wire   [ 2: 0] UrepcntC2;
  wire   [ 2: 0] UrepcntD1;

  wire   [50: 0] URD,URD0,URD1,URD2,URD3,URD4,URD5,URD6,URD7,URD8;
  reg    [74: 0] UWD;

//# ====================================================================================
//# == Coprocessor 15 Registers                                                       ==
//# == ------------------------                                                       ==
//# == The micro-TLB registers the coprocessor CP15 signals in order to remove the    ==
//# == possibility of any speed paths from these signals. When the micro-TLB is       ==
//# == instantiated in the top level of the design, the data and instruction cache    ==
//# == enables will be tied to the appropriate CacheEn. In the case of alignment      ==
//# == checking, the instruction cache will tie the AlignCheck to zero since          ==
//# == alignment checking is not supported on the instruction side.                   ==
//# ====================================================================================

  a926dffrnx1 uCbitD1(CbitD1,CacheEn,GCLK,UTLBnReset);
  a926dffrnx1 uSbitD1(SbitD1,SysProt,GCLK,UTLBnReset);
  a926dffrnx1 uRbitD1(RbitD1,ROMProt,GCLK,UTLBnReset);
  a926dffrnx1 uAbitD1(AbitD1,AlignCheck,GCLK,UTLBnReset);

//# ====================================================================================
//# == Micro-TLB Physical Address and Region Type                                     ==
//# == ------------------------------------------                                     ==
//# == The micro-TLB calculates the physical address for the rest of the system. This ==
//# == address is derived from the virtual address and page table descriptor if the   ==
//# == MMU is enabled; otherwise the physical address is derived strickly from the    ==
//# == virtual address. This information is presented to the system in the cycle      ==
//# == following a ARM core memory request.                                           ==
//# ==                                                                                ==
//# ====================================================================================

//#
//# Generate all of the region information for the system, where regions
//# correspond to caches, TCMs, bufferred stores, etc.
//#

  assign UpdateC2[1] = UpdateC2[0] & ~DtoITCM;
  assign UpdateC2[0] = UhitEnD1[1:0]!=2'b00 & ~UmissC1 & ~(KILL | ABORT);

  a926gdffrnx4 uRegionD1(RegionD1[3:0],URD[3:0],GCLK,UpdateC2[1],UTLBnReset);

  assign DtoITCM    = URD[4];
  assign TCMnewpage = URD[3] & ~KILL & (LookupStall | (|UloadD1[1:0]));

  assign TCMregion  = RegionD1[3];
  assign Cregion    = RegionD1[2];
  assign NCBregion  = RegionD1[1];
  assign NCNBregion = RegionD1[0];

  assign Writeback = URD[46] | (UhitEnD1==2'b00 & WritebackD1);
  a926gdffrnx1 uWritebackD1(WritebackD1,Writeback,GCLK,UpdateC2[0],UTLBnReset);

  a926gdffrnx2 ucbL2D1(cbL2D1[1:0],URD[6:5],GCLK,UpdateC2[1],UTLBnReset);

  assign L2Cacheable  = cbL2D1[1];
  assign L2Bufferable = |(cbL2D1[1:0]);

//#
//# A lookup stall to the system controller needs to be generated whenever the
//# micro-TLB misses, there is a PA mispredict, or a region mispredict. This in
//# turn will trigger the TCM to capture the latest physical address and page
//# size information.
//#

  assign LookupC1 = (SysCLKEN | UTLBinvalidate) & (|UreqC1[1:0]);
  a926dffrnx1 uLookupD1(LookupD1,LookupC1,GCLK,UTLBnReset);

  assign LookupStall = LookupD1 & (UmissC1 | TCMmissC1 | (~|(RegionD1[3:0] & URD[3:0])));

//#
//# Generate a PA mispredict by detecting that the current region is a TCM
//# region and that the predicted VA is not the same as the current VA. This is 
//# achieved by check the last entry that was hit with the current entry that
//# is being hit. If they are equal, then the old PA and page size will match 
//# the new PA and page size. 
//#

  a926gdffrnx9 uUhitD1(UhitD1[8:0],UhitC1[8:0],GCLK,UpdateC2[0],UTLBnReset);

  assign TCMmissC1 = TCMregion & ~|(UhitD1[8:0] & UhitC1[8:0]);

//#
//# Generate the current page size information to the TCM. Anytime the micro-TLB
//# performs a lookup, the value of the entry is passed immediately from URD to 
//# TCMpagesize.
//#

  assign TCMpagesize[3] = URD[50] | (UhitEnD1==2'b00 & PageSizeD1[3]);
  assign TCMpagesize[2] = URD[49] | (UhitEnD1==2'b00 & PageSizeD1[2]);
  assign TCMpagesize[1] = URD[48] | (UhitEnD1==2'b00 & PageSizeD1[1]);
  assign TCMpagesize[0] = URD[47] | (UhitEnD1==2'b00 & PageSizeD1[0]);

  a926gdffrnx4 uPageSizeD1(PageSizeD1[3:0],TCMpagesize[3:0],GCLK,UpdateC2[0],UTLBnReset);

//# 
//# Generate the physical address to the rest of the system. The address is
//# produced either from the micro-TLB entries or the stored physical address
//# PAD1. The low order bits [9:0] are always the register version of the
//# virtual address.
//#

  a926gdffx32 uAD1(AD1[31:0],A[31:0],GCLK,SysCLKEN);

  assign PA[31] = URD[34] | (UhitEnD1==2'b00 & PAD1[31]);
  assign PA[30] = URD[33] | (UhitEnD1==2'b00 & PAD1[30]);
  assign PA[29] = URD[32] | (UhitEnD1==2'b00 & PAD1[29]);
  assign PA[28] = URD[31] | (UhitEnD1==2'b00 & PAD1[28]);
  assign PA[27] = URD[30] | (UhitEnD1==2'b00 & PAD1[27]);
  assign PA[26] = URD[29] | (UhitEnD1==2'b00 & PAD1[26]);
  assign PA[25] = URD[28] | (UhitEnD1==2'b00 & PAD1[25]);
  assign PA[24] = URD[27] | (UhitEnD1==2'b00 & PAD1[24]);
  assign PA[23] = URD[26] | (UhitEnD1==2'b00 & PAD1[23]);
  assign PA[22] = URD[25] | (UhitEnD1==2'b00 & PAD1[22]);
  assign PA[21] = URD[24] | (UhitEnD1==2'b00 & PAD1[21]);
  assign PA[20] = URD[23] | (UhitEnD1==2'b00 & PAD1[20]);

  assign PA[19] = URD[22] | (URD[44] & AD1[19]) | (UhitEnD1==2'b00 & PAD1[19]);
  assign PA[18] = URD[21] | (URD[43] & AD1[18]) | (UhitEnD1==2'b00 & PAD1[18]);
  assign PA[17] = URD[20] | (URD[42] & AD1[17]) | (UhitEnD1==2'b00 & PAD1[17]);
  assign PA[16] = URD[19] | (URD[41] & AD1[16]) | (UhitEnD1==2'b00 & PAD1[16]);
  assign PA[15] = URD[18] | (URD[40] & AD1[15]) | (UhitEnD1==2'b00 & PAD1[15]);
  assign PA[14] = URD[17] | (URD[39] & AD1[14]) | (UhitEnD1==2'b00 & PAD1[14]);
  assign PA[13] = URD[16] | (URD[38] & AD1[13]) | (UhitEnD1==2'b00 & PAD1[13]);
  assign PA[12] = URD[15] | (URD[37] & AD1[12]) | (UhitEnD1==2'b00 & PAD1[12]);
  assign PA[11] = URD[14] | (URD[36] & AD1[11]) | (UhitEnD1==2'b00 & PAD1[11]);
  assign PA[10] = URD[13] | (URD[35] & AD1[10]) | (UhitEnD1==2'b00 & PAD1[10]);

  assign PA[9:0] = AD1[9:0];

  a926gdffx22 uPAD1(PAD1[31:10],PA[31:10],GCLK,UpdateC2[0]);
 
//# ====================================================================================
//# == Micro-TLB Abort to System Controller and ARM core                              ==
//# == -------------------------------------------------                              ==
//# == The micro-TLB needs to construct abort information for the system controller.  ==
//# == To do so it must determine aborts for the following abort types:               ==
//# ==                                                                                ==
//# ==    (a) access permission faults                                                ==
//# ==    (b) domain faults                                                           ==
//# ==    (c) main-MMU faults, which are comprised of                                 ==
//# ==          (i) external aborts on page table walks                               ==
//# ==         (ii) access permission fault from page table entry                     ==
//# ==        (iii) domain fault from page table entry                                ==
//# ==         (iv) aborts for main-MMU miss                                          ==
//# ==    (d) alignment faults                                                        ==
//# ==    (e) recirculating aborts held over stalls, or aborts during a LDM or STM    ==
//# ====================================================================================

//# ------------------------------------------------------------------------------------
//# ==    (a) access permission faults                                                ==
//# ------------------------------------------------------------------------------------
//# The access permission fault in the micro-TLB will only occur when the
//# MMU is enabled, an access by the ARM core has occurred, the access 
//# was marked in the Domain Access Control register to be a client, and the
//# permission checks failed. The checks that are performed can be seen below,
//# note these checks are only performed when the DAC indicates a client.
//#
//#    AP S R  Supervisor    User         Notes
//#            Permissions   Permissions
//#    ----------------------------------------------------------------------
//#    00 0 0  No Access     No Access    Any access generates AP fault.
//#    00 0 1  Read          Read         Any write generates AP fault.
//#    00 1 0  Read          No Access    Supervisor read only permitted.
//#    00 1 1  No Access     No Access    Any access generated AP fault.
//#    01 - -  Read/Write    No Access    Supervisor access permitted.
//#    10 - -  Read/Write    Read         User mode read permitted.
//#    11 - -  Read/Write    Read/Write   All access permitted.

  assign APfaultC1 = URD[45];

//# ------------------------------------------------------------------------------------
//# ==    (b) domain faults                                                           ==
//# ------------------------------------------------------------------------------------
//# The domain fault will always come from the micro-TLB data structure 
//# following either a micro-TLB read hit or a main-MMU tablewalk. Domain faults
//# can only occur when the MMU is enabled, an access by the ARM core has 
//# occurred, and the access marked the particular domain as faulting or was
//# marked as reserved.

  assign DfaultC1 = URD[7];

//# ------------------------------------------------------------------------------------
//# ==    (c) main-MMU faults, which are comprised of                                 ==
//# ------------------------------------------------------------------------------------
//# The MMU fault or abort is indicated when the main-MMU access has completed.
//# If the main-MMU indicates that the data for the micro-TLB is ready via
//# UTLBreadyin, the the micro-TLB can examined the abort indicator, UTLBabort, 
//# and generate a main-MMU fault. The main-MMU fault can occur because of the 
//# follow cases
//#
//#     (i) external aborts on page table walks
//#    (ii) access permission fault from page table entry
//#   (iii) domain fault from page table entry
//#    (iv) aborts for main-MMU miss

  assign MfaultC2 = UTLBreadyin & UTLBabortin;
  a926dffrnx1 uMfaultD1(MfaultD1,MfaultC2,GCLK,UTLBnReset);

//# ------------------------------------------------------------------------------------
//# ==    (d) alignment faults                                                        ==
//# ------------------------------------------------------------------------------------
//# Alignment faults must be calculated within the micro-TLB for the following 
//# cases:
//#
//#     1) any 32-bit, MAS[1:0]==0b1x, access which A[1:0]!=0b00
//#     2) and 16-bit, MAS[1:0]==0b01, access which A[0]!=0b0
//#
//# In the case of the instruction micro-TLB, alignment faults are not allowed.

  a926gdffrnx2 uMASD1(MASD1[1:0],MAS[1:0],GCLK,SysCLKEN,UTLBnReset);
  a926gdffsnx1 unMREQD1(nMREQD1,nMREQ,GCLK,SysCLKEN,UTLBnReset);

  assign AfaultC1 = ~nMREQD1 & AbitD1 & ((MASD1[0] & AD1[0]) |
                                         (MASD1[1] & AD1[0]) |
                                         (MASD1[1] & AD1[1]));

//# ------------------------------------------------------------------------------------
//# ==    (e) recirculating aborts held over stalls, or aborts during a LDM or STM    ==
//# ------------------------------------------------------------------------------------
//# The abort which has to be held over a stall is shown below in the timing
//# diagram:
//#               ___     ___     ___     ___     ___     ___     ___     ___
//#   GCLK     __/   \___/   \___/   \___/   \___/   \___/   \___/   \___/   
//#            ___         __________________________________________________
//#   nMREQ       \_______/
//#                        _______________________________________
//#   MREQ     ___________/                                       \__________
//#            ___________                                 __________________
//#   SysCLKEN            \_______________________________/
//#                        _______________________________________
//#   ABORT    ___________/                                       \__________
//#

  assign StallAbortC2 = ABORT & ~SysCLKEN;
  a926dffrnx1 uStallAbortD1(StallAbortD1,StallAbortC2,GCLK,UTLBnReset);

//# The sequential access, a LDM or STM, which aborts must also abort for the duration 
//# of the LDM or STM. The timing diagram below shows the behavior.
//#               ___     ___     ___     ___     ___     ___     ___     ___
//#   GCLK     __/   \___/   \___/   \___/   \___/   \___/   \___/   \___/   
//#            ___                                 __________________________
//#   nMREQ       \_______________________________/
//#                        _______________________
//#   SEQ      ___________/                       \__________________________
//#                        _______________________________
//#   ABORT    ___________/_______/_______/_______/       \__________________

  assign SEQabortC2 = ~nMREQ & SEQ & MMUabort;
  a926gdffrnx1 uSEQabortD1(SEQabortD1,SEQabortC2,GCLK,SysCLKEN,UTLBnReset);

//# ------------------------------------------------------------------------------------
//# ==    (f) system controller abort                                                 ==
//# ------------------------------------------------------------------------------------

  a926dffsnx1 uSysClkEnD1(SysClkEnD1,SysCLKEN,GCLK,UTLBnReset);

  assign MMUabort = ~KILL & (APfaultC1    |             // UTLB access permission fault
                             DfaultC1     |             // UTLB domain fault
                             StallAbortD1 |             // abort under sysctl stall
                             MfaultD1     |             // tablewalks aborts
                             SEQabortD1   |             // sequential aborts
                             (SysClkEnD1 & AfaultC1));  // alignment fault, last cycle

//# ------------------------------------------------------------------------------------
//# ==    (g) final abort calculation                                                 ==
//# ------------------------------------------------------------------------------------
//# The final abort that is to be returned to the ARM core is simply a combination of 
//# the aborts previously calculated.

  assign ABORT = ~KILL & (APfaultC1    |             // UTLB access permission fault
                          DfaultC1     |             // UTLB domain fault
                          StallAbortD1 |             // abort under sysctl stall
                          ExtAbort     |             // external aborts
                          MfaultD1     |             // tablewalks aborts
                          SEQabortD1   |             // sequential aborts
                          (SysClkEnD1 & AfaultC1));  // alignment fault, last cycle

//# ====================================================================================
//# == Micro-TLB Parameter Construction                                               ==
//# == --------------------------------                                               ==
//# == The micro-TLB needs to understand two types of accesses:                       ==
//# ==                                                                                ==
//# ==    (1) a lookups by the ARM core                                               ==
//# ==    (2) a page table walks                                                      ==
//# ==    (3) aborts which have to be passed to the main-MMU                          ==
//# ==                                                                                ==
//# == The essential information that the micro-TLB needs to know about following     ==
//# == either case (1) or case (2) can be seen below:                                 ==
//# ==                                                                                ==
//# ==    (a) request generation                                                      ==
//# ==    (b) ready indicator to the system controller                                ==
//# ==    (c) transfer type, lock indicator, and read/write indicator                 ==
//# ==    (d) abort indicator                                                         ==
//# ==    (e) abort status indicator (fault status)                                   ==
//# ====================================================================================

//# ------------------------------------------------------------------------------------
//# ==    (a) request generation                                                      ==
//# ------------------------------------------------------------------------------------
//# The request to the main-MMU needs to be generated whenever, the micro-TLB needs a 
//# page table walk performed. The request logic is structured using a trigger 
//# mechanism. It will retain the trigger until the main-MMU indicates that the data
//# is available for the request by pulsing a ready indicator. The timing can be seen
//# in the diagram below:
//#               ___     ___     ___     ___     ___     ___     ___     ___
//#   GCLK     __/   \___/   \___/   \___/   \___/   \___/   \___/   \___/   
//#                        _______
//#   UTLBreqSetC2 _______/       \__________________________________________
//#                                _______________________
//#   UTLBreq  ___________________/                       \__________________
//#                                                _______
//#   UTLBreadyin ________________________________/       \__________________

  assign UTLBreqSetC2 = UmissC1 & ~(KILL | ABORT) & UhitEnD1!=2'b00;

  assign UTLBreqC2 = UTLBreqSetC2 | (UTLBreq & ~UTLBreadyin);
  a926dffrnx1 uUTLBreq(UTLBreq,UTLBreqC2,GCLK,UTLBnReset);

//# ------------------------------------------------------------------------------------
//# ==    (b) ready indicator to the system controller                                ==
//# ------------------------------------------------------------------------------------
//# The system controller needs to know when the micro-TLB has completed it's current
//# transaction. Basically, ready output to the system controller can be seen in the 
//# diagram below:
//#               ___     ___     ___     ___     ___     ___     ___     ___
//#   GCLK     __/   \___/   \___/   \___/   \___/   \___/   \___/   \___/   
//#                        _______
//#   UTLBreqSetC2 _______/       \__________________________________________
//#                                _______________________
//#   UTLBreq  ___________________/                       \__________________
//#                _______________                                  _________
//#   UTLBreadyout                \________________________________/         
//#

  assign UTLBreadyoutC2 = ~(UTLBreq | UTLBreqSetC2);
  a926dffsnx1 uUTLBreadyout(UTLBreadyout,UTLBreadyoutC2,GCLK,UTLBnReset);
 
//# ------------------------------------------------------------------------------------
//# ==    (c) transfer type, lock indicator, and read/write indicator                 ==
//# ------------------------------------------------------------------------------------
//# The transfer type, lock indicator and read/write indicator are simply the registered
//# forms from the ARM core. The are gated with the system controller clock enable to
//# hold the values stable throughout the micro-TLB request to the main-MMU.

  assign UnTRANS = (SysCLKEN) ? nTRANS : UTLBntrans;
  a926dffsnx1 uUTLBntrans(UTLBntrans,UnTRANS,GCLK,UTLBnReset);

  assign ULOCK = (SysCLKEN) ? LOCK : UTLBlock;
  a926dffrnx1 uUTLBlock  (UTLBlock,  ULOCK,  GCLK,UTLBnReset);

  assign UnRW = (SysCLKEN) ? nRW : UTLBnrw;
  a926dffsnx1 uUTLBnrw   (UTLBnrw,   UnRW,   GCLK,UTLBnReset);

//# ------------------------------------------------------------------------------------
//# ==    (d) abort indicator                                                         ==
//# ------------------------------------------------------------------------------------
//# The abort indicator the the main-MMU is constructed using only the faults that can
//# be generated by the micro-TLB. This include the alignment fault, access permission
//# and domain fault for a micro-TLB hit, and an external abort other than a page table
//# walk external abort.

  assign MaskC2 = ~UTLBreadyin & ABORT & SEQ & ~nMREQ;
  a926gdffrnx1 uMaskD1(MaskD1,MaskC2,GCLK,SysCLKEN,UTLBnReset);
  assign MaskC1 = MaskD1 | KILL;

  assign UTLBidleabortout = ~MaskD1 & (AfaultC1  |     // alignment fault
                                       APfaultC1 |     // access permission fault
                                       DfaultC1);      // domain fault

  assign UTLBabortout = (~MaskC1 & (AfaultC1   |     // alignment fault
                                    APfaultC1  |     // access permission fault
                                    DfaultC1)) |     // domain fault
                                    ExtAbort   ;     // external aborts

//# ------------------------------------------------------------------------------------
//# ==    (e) abort status indicator (fault status)                                   ==
//# ------------------------------------------------------------------------------------
//# The fault status indicator to the main-MMU is constructed using the four fault types
//# indicator for the micro-TLB abort indicator. These are priority encoded to alignment
//# faults always have the highest priority, followed by domain faults, followed by 
//# access permission faults, followed by external aborts.

  always @(AfaultC1 or APfaultC1 or DfaultC1 or URD)
    casex ({AfaultC1,DfaultC1,APfaultC1})
      3'b1xx : UTLBfs[7:0] = {    4'bxxxx, 2'b00,    1'bx, 1'b1 };
      3'b01x : UTLBfs[7:0] = { URD[12: 9], 2'b10, URD[ 8], 1'b1 };
      3'b001 : UTLBfs[7:0] = { URD[12: 9], 2'b11, URD[ 8], 1'b1 };
      3'b000 : UTLBfs[7:0] = { URD[12: 9], 2'b10, URD[ 8], 1'b0 };
      default: UTLBfs[7:0] = {    4'bxxxx, 2'bxx,    1'bx, 1'bx };
    endcase

//# ====================================================================================
//# == Micro-TLB Entries                                                              ==
//# == -----------------                                                              ==
//# == The micro-TLB is broken into 9 discrete entries. The entries numbering 0 thru  ==
//# == 7 correspond to the entries used in the micro-TLB when the ARM is not          ==
//# == performing a prefetch operation by CP15. The "magical" entry 8 is used only    ==
//# == when the micro-TLB is performing lookups when a CP15 prefetch operation is     ==
//# == occuring. The reasoning behind the "magical" entry is so the micro-TLB is not  ==
//# == polluted during these very special forms of page table walks.                  ==
//# ==                                                                                ==
//# == During normal operation, ie. CP15, the micro-TLB locks out the                 ==
//# == "magical" entry. This then precludes the micro-TLB from filling this during    ==
//# == page table walks. It also prevents the system from becomming corrupt with      ==
//# == false information from the "magical" entry. The entries 0 thru 7 will remain   ==
//# == valid even during the special operations. The filling process for entries 0    ==
//# == thru 7 is round robin replacement. The pointer will only increment when the    ==
//# == main-MMU indicates that the micro-TLB should commit the data from the page     ==
//# == table walk.                                                                    ==
//# ==                                                                                ==
//# == During a CP15 prefetch operation, the micro-TLB will also lock out the entries ==
//# == 0 thru 7 and will only allow accesses to the "magical" entry 8. The entry will ==
//# == be loaded with the data following the page table walk and will retain its      ==
//# == state while the operation is active. Upon entering and exiting the CP15        ==
//# == prefetch operation the "magical" entry 8 will be invalidate such that the data ==
//# == does not corrupt an address translation. The primary reason for this is the    ==
//# == fast-context-switch extensions. This extension aliases the lower 32MB of       ==
//# == physical memory and remaps this using the a process identifier. When the       ==
//# == micro-TLB performs CP15 prefetch operations in the lower 32MB, the aliasing    ==
//# == effect is negated, implying that the translation mapping is unknown and may    ==
//# == falsely map to one of the already loaded lower entries of the micro-TLB. In    ==
//# == order to correct this, the "magical" entry 8 is used and is invalidate before  ==
//# == and after performing the CP15 prefetch operation.                              ==
//# ==                                                                                ==
//# == The following section describes the items necessary to access the micro-TLB    ==
//# == data entries for either reads or writes:                                       ==
//# ==                                                                                ==
//# ==    (a) access permission select bits                                           ==
//# ==    (b) a load entry indicator                                                  ==
//# ==    (c) a hit enable and hit indicator                                          ==
//# ==    (d) invalidate entry indicators                                             ==
//# ==    (e) write and read data                                                     ==
//# ==    (f) the replacement counter                                                 ==
//# ==    (g) the entries themselves                                                  ==
//# ====================================================================================

//# ------------------------------------------------------------------------------------
//# ==    (a) access permission select bits                                           ==
//# ------------------------------------------------------------------------------------
//# When the micro-TLB performs a lookup in the 9 entries, selects bits must be 
//# generated such that a access permission fault can be determined. This is
//# accomplished by decoding the current state of the access in question. The following 
//# table indicates when a particular select is driven high.
//#
//#    AP S R  Supervisor    User         Notes
//#            Permissions   Permissions
//#    ----------------------------------------------------------------------
//#    00 0 0  No Access     No Access    Any access generates AP fault.
//#    00 0 1  Read          Read         Any write generates AP fault.
//#    00 1 0  Read          No Access    Supervisor read only permitted.
//#    00 1 1  No Access     No Access    Any access generated AP fault.
//#    01 - -  Read/Write    No Access    Supervisor access permitted.
//#    10 - -  Read/Write    Read         User mode read permitted.
//#    11 - -  Read/Write    Read/Write   All access permitted.

  assign APselC2[2] = ~UnTRANS & (UnRW | ULOCK);
  assign APselC2[1] = ~UnTRANS;
  assign APselC2[0] = (SbitD1 & RbitD1) | (~SbitD1 & ~RbitD1) | (~RbitD1 & ~UnTRANS) | UnRW | ULOCK;

//# ------------------------------------------------------------------------------------
//# ==    (b) a load entry indicator                                                  ==
//# ------------------------------------------------------------------------------------
//# An entry is loaded into the micro-TLB storage if and only if the main-MMU indicates 
//# that the entry is to be committed when it also indicates the data is ready and 
//# valid. There are two indicators for loading. The first, bit 0, corresponds to the 
//# micro-TLB entries 0 thru 7, while bit 1 corresponds to the "magical" entry 8.
//#
//# The coprocessor 15 test register allows loads to be disabled. This is evident 
//# when UTLBload or UTLBmatch is asserted low. Bit 0 will be disabled in this case. 
//# However, bit 1 will be enabled. Because the "magical" entry 8 is being used for 
//# storing this special data, it will only be stored in the cycle that is used. The 
//# micro-TLB will invalidate the "magical" entry 8 following a load when either 
//# UTLBload or UTLBmatch is asserted low.

  assign UloadC1 = UTLBcommit & UTLBreadyin;

  assign UloadC2[1] = UloadC1 &  (CP15prefetch | ~(UTLBload & UTLBmatch));
  assign UloadC2[0] = UloadC1 & ~(CP15prefetch | ~(UTLBload & UTLBmatch));

  a926dffrnx2 uUloadD1(UloadD1[1:0],UloadC2[1:0],GCLK,UTLBnReset);

//# ------------------------------------------------------------------------------------
//# ==    (c) a hit enable and hit indicator                                          ==
//# ------------------------------------------------------------------------------------
//# A lookup in the micro-TLB is only performed if the MMU is enabled, the system 
//# controller is enabled, and a request is present. It will also occur when the
//# main-MMU indicates data is present and must be committed. This last case implies
//# the micro-TLB does not forward data directly from the page table walk but instead
//# performs a lookup following the page table walk.
//#
//# Again the micro-TLB has two bits in which bit 0 maps to entries 0 thru 7 while bit 1
//# maps to the "magical" entry 8.
//#
//# Entries 0 thru 7 are only allowed to perform a lookup via the ARM core. This
//# precludes any lookups by a coprocessor 15 prefetch operation. 
//#
//# The "magical" entry 8 will perform lookups whenever there is either a ARM core 
//# request or a the first cycle of a request for a coprocessor 15 prefetch.
//#
//# The coprocessor 15 test register allows match operations within the
//# micro-TLB to be disabled. This is indicated by UTLBmatch being asserted low.
//# Therefore, lookups will only occur in the micro-TLB if this signal is asserted 
//# high.
//#
//# A hit is determined whenever each of the 9 entries hit signals are logically-OR'd
//# together and at least one is asserted high; hence, a miss is indicated when none are
//# asserted high.

  assign UreqC1[1] = ~nMREQ | (CP15prefetch & ~CP15prefetchD1);
  assign UreqC1[0] = ~nMREQ & ~CP15prefetch;

  assign UmatchEnC2[1] = SysCLKEN & UreqC1[1];
  assign UmatchEnC2[0] = SysCLKEN & UreqC1[0] & UTLBmatch;

  assign UhitEnC2[1] = UloadC2[1] | UmatchEnC2[1];
  assign UhitEnC2[0] = UloadC2[0] | UmatchEnC2[0];

  a926dffrnx2 uUhitEnD1(UhitEnD1[1:0],UhitEnC2[1:0],GCLK,UTLBnReset);
  a926dffrnx2 uUmatchEnD1(UmatchEnD1[1:0],UmatchEnC2[1:0],GCLK,UTLBnReset);

  assign UmissC1 = ~|(UhitC1[8:0]);

//# ------------------------------------------------------------------------------------
//# ==    (d) invalidate entry indicators                                             ==
//# ------------------------------------------------------------------------------------
//# The invalidate entry signals are used to reset the valid bits any of the 9 entries.
//# The "magical" entry 8 can and must be invalidated at the start and end of the CP15
//# prefetch operation. The timing diagram below indicates when invalidation occurs.
//#               ___     ___     ___     ___     ___     ___     ___     ___
//#   GCLK     __/   \___/   \___/   \___/   \___/   \___/   \___/   \___/   
//#                        _______
//#   UTLBinvalidate  ____/       \__________________________________________
//#                                        _______________________
//#   CP15prefetch _______________________/                       \__________
//#                                                _______________________
//#   CP15prefetchD1 _____________________________/                       \__
//#                        _______
//#   UinvalC1[0] ________/       \__________________________________________
//#                        _______         _______                 _______
//#   UinvalC1[1] ________/       \_______/       \_______________/       \__
//#
//# In addition, the "magical" entry 8 must also be invalidated whenever the
//# debugging bits, UTLBload or UTLBmatch, are cleared in order to guarentee that
//# the micro-TLB does not cache duplicate entries following a tablewalk.

  a926dffrnx1 uCP15prefetchD1(CP15prefetchD1,CP15prefetch,GCLK,UTLBnReset);
  assign CP15inval = CP15prefetch ^ CP15prefetchD1;

  assign UTLBinvalC2[1:0] = { UTLBload,UTLBmatch };
  a926dffrnx2 uUTLBinvalD1(UTLBinvalD1[1:0],UTLBinvalC2[1:0],GCLK,UTLBnReset);
  assign UTLBinval = |(UTLBinvalC2[1:0] ^ UTLBinvalD1[1:0]);
  
  assign UinvalC1[1] = UTLBinvalidate | CP15inval | UTLBinval;
  assign UinvalC1[0] = UTLBinvalidate;

//# ------------------------------------------------------------------------------------
//# ==    (e) write and read data                                                     ==
//# ------------------------------------------------------------------------------------
//# Write data that is stored in the micro-TLB entries is identical for each. The
//# majority of the data is expanded into bit select fields when critical. This is the
//# case with the size, AP fields, and region type. All other fields are stored in their
//# native format.
//#
//# Read data is simply a logical-OR of all 9 entries. Each entry forces it's outputs
//# to zero when it misses or is not active such that the logical-OR can take place.
//# Think of it as a distributed 9-way mux.

  always @(UTLBsize or AD1 or UTLBclient or UTLBap or UTLBpa or UTLBdomain or UTLBdfault 
           or UTLBcbL2 or UTLBcbL1 or UTLBregion or UTLBpage or CbitD1)
    begin
      UWD[74:71] = UTLBsize[3:0];
      UWD[70] = UTLBregion[1:0]==2'b00 & CbitD1 & UTLBcbL1[1:0]==2'b11;
      UWD[69:48] = AD1[31:10];
      case (UTLBsize[3:0])
        4'b1011: UWD[47:38] = 10'b1111_1111_11;                   // 1M
        4'b1010: UWD[47:38] = 10'b0111_1111_11;                   // 512K
        4'b1001: UWD[47:38] = 10'b0011_1111_11;                   // 256K
        4'b1000: UWD[47:38] = 10'b0001_1111_11;                   // 128K
        4'b0111: UWD[47:38] = 10'b0000_1111_11;                   // 64K
        4'b0110: UWD[47:38] = 10'b0000_0111_11;                   // 32K
        4'b0101: UWD[47:38] = 10'b0000_0011_11;                   // 16K
        4'b0100: UWD[47:38] = 10'b0000_0001_11;                   // 8K
        4'b0011: UWD[47:38] = 10'b0000_0000_11;                   // 4K
        4'b0010: UWD[47:38] = 10'b0000_0000_01;                   // 2K
        4'b0001: UWD[47:38] = 10'b0000_0000_00;                   // 1K
        default: UWD[47:38] = 10'bxxxx_xxxx_xx;
      endcase
      case (UTLBsize[3:0])
        4'b1011: UWD[37:16] = { UTLBpa[31:20], 10'b0000000000 };  // 1M
        4'b1010: UWD[37:16] = { UTLBpa[31:19],  9'b000000000 };   // 512K
        4'b1001: UWD[37:16] = { UTLBpa[31:18],  8'b00000000 };    // 256K
        4'b1000: UWD[37:16] = { UTLBpa[31:17],  7'b0000000 };     // 128K
        4'b0111: UWD[37:16] = { UTLBpa[31:16],  6'b000000 };      // 64K
        4'b0110: UWD[37:16] = { UTLBpa[31:15],  5'b00000 };       // 32K
        4'b0101: UWD[37:16] = { UTLBpa[31:14],  4'b0000 };        // 16K
        4'b0100: UWD[37:16] = { UTLBpa[31:13],  3'b000 };         // 8K
        4'b0011: UWD[37:16] = { UTLBpa[31:12],  2'b00 };          // 4K
        4'b0010: UWD[37:16] = { UTLBpa[31:11],  1'b0 };           // 2K
        4'b0001: UWD[37:16] =   UTLBpa[31:10];                    // 1K
        default: UWD[37:16] = { 22{ 1'bx }};
      endcase
      UWD[15:12] = UTLBdomain[3:0];
      UWD[   11] = UTLBpage;
      casex ({UTLBclient,UTLBap[1:0]})
        3'b0_xx: UWD[10: 8] = 3'b000;
        3'b1_00: UWD[10: 8] = 3'b001;
        3'b1_01: UWD[10: 8] = 3'b010;
        3'b1_10: UWD[10: 8] = 3'b100;
        3'b1_11: UWD[10: 8] = 3'b000;
        default: UWD[10: 8] = 3'bxxx;
      endcase
      UWD[    7] = UTLBdfault;
      UWD[ 6: 5] = UTLBcbL2[1:0];
      casex ({UTLBregion[1:0],CbitD1,UTLBcbL1[1:0]})
        5'b00_x_00: UWD[4:0] = 5'b00001;        // NCNB
        5'b00_x_01: UWD[4:0] = 5'b00010;        // NCB
        5'b00_0_1x: UWD[4:0] = 5'b00010;        // force NCB
        5'b00_1_1x: UWD[4:0] = 5'b00100;        // C
        5'b01_x_xx: UWD[4:0] = 5'b01000;        // TCM
        5'b1x_x_xx: UWD[4:0] = 5'b10000;        // D-to-I TCM
        default   : UWD[4:0] = 5'bxxxxx;
      endcase
    end

  assign URD = URD8 | URD7 | URD6 | URD5 | URD4 | URD3 | URD2 | URD1 | URD0;

//# ------------------------------------------------------------------------------------
//# ==    (f) the replacement counter                                                 ==
//# ------------------------------------------------------------------------------------
//# The replacement counter increments only when a micro-TLB entry 0 thru 7 is
//# inserted. It is a simple round robin counter and nothing else.

  assign UrepcntC2[2:0] = UrepcntD1[2:0] + 1;
  a926gdffrnx3 uUrepcntD1(UrepcntD1[2:0],UrepcntC2[2:0],GCLK,UloadC2[0],UTLBnReset);

//# ------------------------------------------------------------------------------------
//# ==    (g) the entries themselves                                                  ==
//# ------------------------------------------------------------------------------------

  a926ejsUTLBentry #(3'b000) u0 (
    .GCLK       (GCLK),
    .UTLBnReset (UTLBnReset),
    .A          (A[31:10]),
    .APselC2    (APselC2[2:0]),
    .UloadC2    (UloadC2[0]),
    .UrepcntD1  (UrepcntD1[2:0]),
    .UinvalC1   (UinvalC1[0]),
    .UmatchEnD1 (UmatchEnD1[0]),
    .UWD        (UWD[74:0]),
    .UhitC1     (UhitC1[0]),
    .URD        (URD0[50:0])
  );

  a926ejsUTLBentry #(3'b001) u1 (
    .GCLK       (GCLK),
    .UTLBnReset (UTLBnReset),
    .A          (A[31:10]),
    .APselC2    (APselC2[2:0]),
    .UloadC2    (UloadC2[0]),
    .UrepcntD1  (UrepcntD1[2:0]),
    .UinvalC1   (UinvalC1[0]),
    .UmatchEnD1 (UmatchEnD1[0]),
    .UWD        (UWD[74:0]),
    .UhitC1     (UhitC1[1]),
    .URD        (URD1[50:0])
  );

  a926ejsUTLBentry #(3'b010) u2 (
    .GCLK       (GCLK),
    .UTLBnReset (UTLBnReset),
    .A          (A[31:10]),
    .APselC2    (APselC2[2:0]),
    .UloadC2    (UloadC2[0]),
    .UrepcntD1  (UrepcntD1[2:0]),
    .UinvalC1   (UinvalC1[0]),
    .UmatchEnD1 (UmatchEnD1[0]),
    .UWD        (UWD[74:0]),
    .UhitC1     (UhitC1[2]),
    .URD        (URD2[50:0])
  );

  a926ejsUTLBentry #(3'b011) u3 (
    .GCLK       (GCLK),
    .UTLBnReset (UTLBnReset),
    .A          (A[31:10]),
    .APselC2    (APselC2[2:0]),
    .UloadC2    (UloadC2[0]),
    .UrepcntD1  (UrepcntD1[2:0]),
    .UinvalC1   (UinvalC1[0]),
    .UmatchEnD1 (UmatchEnD1[0]),
    .UWD        (UWD[74:0]),
    .UhitC1     (UhitC1[3]),
    .URD        (URD3[50:0])
  );

  a926ejsUTLBentry #(3'b100) u4 (
    .GCLK       (GCLK),
    .UTLBnReset (UTLBnReset),
    .A          (A[31:10]),
    .APselC2    (APselC2[2:0]),
    .UloadC2    (UloadC2[0]),
    .UrepcntD1  (UrepcntD1[2:0]),
    .UinvalC1   (UinvalC1[0]),
    .UmatchEnD1 (UmatchEnD1[0]),
    .UWD        (UWD[74:0]),
    .UhitC1     (UhitC1[4]),
    .URD        (URD4[50:0])
  );

  a926ejsUTLBentry #(3'b101) u5 (
    .GCLK       (GCLK),
    .UTLBnReset (UTLBnReset),
    .A          (A[31:10]),
    .APselC2    (APselC2[2:0]),
    .UloadC2    (UloadC2[0]),
    .UrepcntD1  (UrepcntD1[2:0]),
    .UinvalC1   (UinvalC1[0]),
    .UmatchEnD1 (UmatchEnD1[0]),
    .UWD        (UWD[74:0]),
    .UhitC1     (UhitC1[5]),
    .URD        (URD5[50:0])
  );

  a926ejsUTLBentry #(3'b110) u6 (
    .GCLK       (GCLK),
    .UTLBnReset (UTLBnReset),
    .A          (A[31:10]),
    .APselC2    (APselC2[2:0]),
    .UloadC2    (UloadC2[0]),
    .UrepcntD1  (UrepcntD1[2:0]),
    .UinvalC1   (UinvalC1[0]),
    .UmatchEnD1 (UmatchEnD1[0]),
    .UWD        (UWD[74:0]),
    .UhitC1     (UhitC1[6]),
    .URD        (URD6[50:0])
  );

  a926ejsUTLBentry #(3'b111) u7 (
    .GCLK       (GCLK),
    .UTLBnReset (UTLBnReset),
    .A          (A[31:10]),
    .APselC2    (APselC2[2:0]),
    .UloadC2    (UloadC2[0]),
    .UrepcntD1  (UrepcntD1[2:0]),
    .UinvalC1   (UinvalC1[0]),
    .UmatchEnD1 (UmatchEnD1[0]),
    .UWD        (UWD[74:0]),
    .UhitC1     (UhitC1[7]),
    .URD        (URD7[50:0])
  );

  a926ejsUTLBentry #(3'b000) u8 (
    .GCLK       (GCLK),
    .UTLBnReset (UTLBnReset),
    .A          (A[31:10]),
    .APselC2    (APselC2[2:0]),
    .UloadC2    (UloadC2[1]),
    .UrepcntD1  (3'b000),
    .UinvalC1   (UinvalC1[1]),
    .UmatchEnD1 (UmatchEnD1[1]),
    .UWD        (UWD[74:0]),
    .UhitC1     (UhitC1[8]),
    .URD        (URD8[50:0])
  );

//surefire coverage_off
//synopsys translate_off

  always @(posedge(GCLK))
    if (UTLBnReset==1'b1) begin
      case (UhitC1[8:0])
        9'b000000000,
        9'b000000001,
        9'b000000010,
        9'b000000100,
        9'b000001000,
        9'b000010000,
        9'b000100000,
        9'b001000000,
        9'b010000000,
        9'b100000000: begin
                       /* only a single micro-TLB hit, everything is ok.. */
                     end
        default    : begin
                       $display("%t %m : ERROR : multiple entries hit in micro-TLB",$time);
`ifndef __NO_STOP__
                       #1000 $stop;
`endif //__NO_STOP__
                     end
      endcase
    end

//synopsys translate_on
//surefire coverage_on

endmodule
