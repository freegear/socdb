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
// File Name           : $RCSfile: A946ESWrapper.v,v $
// File Revision       : $Revision: 1.1 $
//
// Release Information : $State: Rel $
//-----------------------------------------------------------------------------
//
// Abstract: The test wrapper
//

`timescale 1 ns / 1 ns

module A946ESWrapper ( 
  HADDR, 
  iHADDR, 
  HTRANS, 
  iHTRANS, 
  HBURST, 
  iHBURST, 
  HWRITE, 
  iHWRITE, 
  HSIZE, 
  iHSIZE, 
  HPROT, 
  iHPROT, 
  HREADY, 
  iHREADY, 
  HRESP, 
  iHRESP, 
  HWDATA, 
  iHWDATA, 
  HRDATA, 
  iHRDATA, 
  HBUSREQ, 
  iHBUSREQ, 
  HGRANT, 
  iHGRANT, 
  HLOCK, 
  iHLOCK, 
  HRESETn, 
  iHRESETn, 
  CPCLKEN, 
  iCPCLKEN, 
  CPINSTR, 
  iCPINSTR, 
  CPDOUT, 
  iCPDOUT, 
  CPDIN, 
  iCPDIN, 
  CPPASS, 
  iCPPASS, 
  CPLATECANCEL, 
  iCPLATECANCEL, 
  CHSDE, 
  iCHSDE, 
  CHSEX, 
  iCHSEX, 
  CPTBIT, 
  iCPTBIT, 
  nCPMREQ, 
  inCPMREQ, 
  nCPTRANS, 
  inCPTRANS, 
  COMMRX, 
  iCOMMRX, 
  COMMTX, 
  iCOMMTX, 
  DBGACK, 
  iDBGACK, 
  DBGEN, 
  iDBGEN, 
  DBGRQI, 
  iDBGRQI, 
  EDBGRQ, 
  iEDBGRQ, 
  DBGEXT, 
  iDBGEXT, 
  DBGINSTREXEC, 
  iDBGINSTREXEC, 
  DBGRNG, 
  iDBGRNG, 
  DBGIEBKPT, 
  iDBGIEBKPT, 
  DBGDEWPT, 
  iDBGDEWPT, 
  DBGnTRST, 
  iDBGnTRST, 
  DBGTCKEN, 
  iDBGTCKEN, 
  DBGTDI, 
  iDBGTDI, 
  DBGTMS, 
  iDBGTMS, 
  DBGTDO, 
  iDBGTDO, 
  DBGIR, 
  iDBGIR, 
  DBGSCREG, 
  iDBGSCREG, 
  DBGTAPSM, 
  iDBGTAPSM, 
  DBGnTDOEN, 
  iDBGnTDOEN, 
  DBGSDIN, 
  iDBGSDIN, 
  DBGSDOUT, 
  iDBGSDOUT, 
  CLK, 
  HCLKEN, 
  iHCLKEN, 
  nFIQ, 
  inFIQ, 
  nIRQ, 
  inIRQ, 
  BIGENDOUT, 
  iBIGENDOUT, 
  VINITHI, 
  iVINITHI,
  DCacheSize,
  iDCacheSize,
  ICacheSize,
  iICacheSize,
  ETMBIGEND, 
  iETMBIGEND, 
  ETMHIVECS, 
  iETMHIVECS, 
  ETMnWAIT, 
  iETMnWAIT, 
  ETMIA, 
  iETMIA, 
  ETMInMREQ, 
  iETMInMREQ, 
  ETMISEQ, 
  iETMISEQ, 
  ETMITBIT, 
  iETMITBIT,
  ETMIABORT,
  iETMIABORT, 
  ETMID31To25, 
  iETMID31To25, 
  ETMID15To11, 
  iETMID15To11, 
  ETMDA, 
  iETMDA, 
  ETMWDATA, 
  iETMWDATA, 
  ETMDMAS, 
  iETMDMAS, 
  ETMDMORE, 
  iETMDMORE, 
  ETMDnMREQ, 
  iETMDnMREQ, 
  ETMDnRW, 
  iETMDnRW, 
  ETMDSEQ, 
  iETMDSEQ, 
  ETMRDATA, 
  iETMRDATA, 
  ETMDABORT, 
  iETMDABORT, 
  ETMCHSD, 
  iETMCHSD, 
  ETMCHSE, 
  iETMCHSE, 
  ETMLATECANCEL, 
  iETMLATECANCEL, 
  ETMPASS, 
  iETMPASS, 
  ETMDBGACK, 
  iETMDBGACK, 
  ETMINSTREXEC,
  iETMINSTREXEC,
  ETMINSTRVALID, 
  iETMINSTRVALID, 
  ETMRNGOUT, 
  iETMRNGOUT, 
  ETMEN, 
  iETMEN, 
  TAPID, 
  iTAPID, 
  ETMPROCID,
  iETMPROCID,
  ETMPROCIDWR,
  iETMPROCIDWR,
  INITRAM,
  iINITRAM,
  ETMFIFOFULL,
  iETMFIFOFULL,
  IScanEn, INSCANENABLE, EXSCANENABLE, TestEn, SerialEn, INnotEXTEST, SI, SO); 

  output [31:0]  HADDR; 
  input  [31:0]  iHADDR; 
  output [1:0]   HTRANS; 
  input  [1:0]   iHTRANS; 
  output [2:0]   HBURST; 
  input  [2:0]   iHBURST; 
  output         HWRITE; 
  input          iHWRITE; 
  output [2:0]   HSIZE; 
  input  [2:0]   iHSIZE; 
  output [3:0]   HPROT; 
  input  [3:0]   iHPROT; 
  input          HREADY; 
  output         iHREADY; 
  input  [1:0]   HRESP; 
  output [1:0]   iHRESP; 
  output [31:0]  HWDATA; 
  input  [31:0]  iHWDATA; 
  input  [31:0]  HRDATA; 
  output [31:0]  iHRDATA; 
  output         HBUSREQ; 
  input          iHBUSREQ; 
  input          HGRANT; 
  output         iHGRANT; 
  output 	 HLOCK; 
  input          iHLOCK; 
  input          HRESETn; 
  output         iHRESETn; 
  output         CPCLKEN; 
  input          iCPCLKEN; 
  output [31:0]  CPINSTR; 
  input  [31:0]  iCPINSTR; 
  output [31:0]  CPDOUT; 
  input  [31:0]  iCPDOUT; 
  input  [31:0]  CPDIN; 
  output [31:0]  iCPDIN; 
  output         CPPASS; 
  input          iCPPASS; 
  output         CPLATECANCEL; 
  input          iCPLATECANCEL; 
  input  [1:0]   CHSDE; 
  output [1:0]   iCHSDE; 
  input  [1:0]   CHSEX; 
  output [1:0]   iCHSEX; 
  output         CPTBIT; 
  input          iCPTBIT; 
  output         nCPMREQ; 
  input          inCPMREQ; 
  output         nCPTRANS; 
  input          inCPTRANS; 
  output         COMMRX; 
  input          iCOMMRX; 
  output         COMMTX; 
  input          iCOMMTX; 
  output         DBGACK; 
  input          iDBGACK; 
  input          DBGEN; 
  output         iDBGEN; 
  output         DBGRQI; 
  input          iDBGRQI; 
  input          EDBGRQ; 
  output         iEDBGRQ; 
  input  [1:0]   DBGEXT; 
  output [1:0]   iDBGEXT; 
  output         DBGINSTREXEC; 
  input          iDBGINSTREXEC; 
  output [1:0]   DBGRNG; 
  input  [1:0]   iDBGRNG; 
  input          DBGIEBKPT; 
  output         iDBGIEBKPT; 
  input          DBGDEWPT; 
  output         iDBGDEWPT; 
  input          DBGnTRST; 
  output         iDBGnTRST; 
  input          DBGTCKEN; 
  output         iDBGTCKEN; 
  input          DBGTDI; 
  output         iDBGTDI; 
  input          DBGTMS; 
  output         iDBGTMS; 
  output         DBGTDO; 
  input          iDBGTDO; 
  output [3:0]   DBGIR; 
  input  [3:0]   iDBGIR; 
  output [4:0]   DBGSCREG; 
  input  [4:0]   iDBGSCREG; 
  output [3:0]   DBGTAPSM; 
  input  [3:0]   iDBGTAPSM; 
  output         DBGnTDOEN; 
  input          iDBGnTDOEN; 
  output         DBGSDIN; 
  input          iDBGSDIN; 
  input          DBGSDOUT; 
  output         iDBGSDOUT; 
  input          CLK; 
  input          HCLKEN; 
  output         iHCLKEN; 
  input          nFIQ; 
  output         inFIQ; 
  input          nIRQ; 
  output         inIRQ; 
  output         BIGENDOUT; 
  input          iBIGENDOUT; 
  input          VINITHI; 
  output         iVINITHI;
  input  [3:0] 	 DCacheSize;
  output [3:0]   iDCacheSize;
  input  [3:0] 	 ICacheSize;
  output [3:0]   iICacheSize; 
  output         ETMBIGEND; 
  input          iETMBIGEND; 
  output         ETMHIVECS; 
  input          iETMHIVECS; 
  output         ETMnWAIT; 
  input          iETMnWAIT; 
  output [31:1]  ETMIA; 
  input  [31:1]  iETMIA; 
  output         ETMInMREQ; 
  input          iETMInMREQ; 
  output         ETMISEQ; 
  input          iETMISEQ; 
  output         ETMITBIT; 
  input          iETMITBIT;
  output 	 ETMIABORT;
  input 	 iETMIABORT; 
  output [31:25] ETMID31To25; 
  input  [31:25] iETMID31To25; 
  output [15:11] ETMID15To11; 
  input  [15:11] iETMID15To11; 
  output [31:0]  ETMDA; 
  input  [31:0]  iETMDA; 
  output [31:0]  ETMWDATA; 
  input  [31:0]  iETMWDATA; 
  output [1:0]   ETMDMAS; 
  input  [1:0]   iETMDMAS; 
  output         ETMDMORE; 
  input          iETMDMORE; 
  output         ETMDnMREQ; 
  input          iETMDnMREQ; 
  output         ETMDnRW; 
  input          iETMDnRW; 
  output         ETMDSEQ; 
  input          iETMDSEQ; 
  output [31:0]  ETMRDATA; 
  input  [31:0]  iETMRDATA; 
  output         ETMDABORT; 
  input          iETMDABORT; 
  output [1:0]   ETMCHSD; 
  input  [1:0]   iETMCHSD; 
  output [1:0]   ETMCHSE; 
  input  [1:0]   iETMCHSE; 
  output         ETMLATECANCEL; 
  input          iETMLATECANCEL; 
  output         ETMPASS; 
  input          iETMPASS; 
  output         ETMDBGACK; 
  input          iETMDBGACK; 
  output         ETMINSTREXEC; 
  input          iETMINSTREXEC; 
  output         ETMINSTRVALID; 
  input          iETMINSTRVALID; 
  output [1:0]   ETMRNGOUT; 
  input  [1:0]   iETMRNGOUT; 
  input          ETMEN; 
  output         iETMEN; 
  input  [31:0]  TAPID; 
  output [31:0]  iTAPID; 
  output [31:0]  ETMPROCID;
  input  [31:0]  iETMPROCID;
  output         ETMPROCIDWR;
  input          iETMPROCIDWR;
  input 	 INITRAM;
  output 	 iINITRAM;
  input 	 ETMFIFOFULL;
  output 	 iETMFIFOFULL; 
  input          IScanEn;
  input          INSCANENABLE;
  input 	 EXSCANENABLE;
  input          SerialEn; 
  input          TestEn;
  input          INnotEXTEST;
  input          SI; 
  output         SO; 

  wire           ScanEn;
  wire [501:0]   ScanChain;
  wire 	         nINnotEXTEST;
  wire 	         SCANENABLE;
   
  assign SCANENABLE = INSCANENABLE | EXSCANENABLE;
   
  assign ScanEn = SerialEn ? IScanEn : SCANENABLE;

  // For inputs invert INnotEXTEST
  assign nINnotEXTEST = !INnotEXTEST;

  CapUpdCell uscan0 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[0]), .DataIn(iHADDR[31]), .DataOut(HADDR[31]), .SO(ScanChain[1]));
  CapUpdCell uscan1 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[1]), .DataIn(iHADDR[30]), .DataOut(HADDR[30]), .SO(ScanChain[2]));
  CapUpdCell uscan2 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[2]), .DataIn(iHADDR[29]), .DataOut(HADDR[29]), .SO(ScanChain[3]));
  CapUpdCell uscan3 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[3]), .DataIn(iHADDR[28]), .DataOut(HADDR[28]), .SO(ScanChain[4]));
  CapUpdCell uscan4 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[4]), .DataIn(iHADDR[27]), .DataOut(HADDR[27]), .SO(ScanChain[5]));
  CapUpdCell uscan5 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[5]), .DataIn(iHADDR[26]), .DataOut(HADDR[26]), .SO(ScanChain[6]));
  CapUpdCell uscan6 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[6]), .DataIn(iHADDR[25]), .DataOut(HADDR[25]), .SO(ScanChain[7]));
  CapUpdCell uscan7 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[7]), .DataIn(iHADDR[24]), .DataOut(HADDR[24]), .SO(ScanChain[8]));
  CapUpdCell uscan8 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[8]), .DataIn(iHADDR[23]), .DataOut(HADDR[23]), .SO(ScanChain[9]));
  CapUpdCell uscan9 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[9]), .DataIn(iHADDR[22]), .DataOut(HADDR[22]), .SO(ScanChain[10]));
  CapUpdCell uscan10 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[10]), .DataIn(iHADDR[21]), .DataOut(HADDR[21]), .SO(ScanChain[11]));
  CapUpdCell uscan11 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[11]), .DataIn(iHADDR[20]), .DataOut(HADDR[20]), .SO(ScanChain[12]));
  CapUpdCell uscan12 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[12]), .DataIn(iHADDR[19]), .DataOut(HADDR[19]), .SO(ScanChain[13]));
  CapUpdCell uscan13 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[13]), .DataIn(iHADDR[18]), .DataOut(HADDR[18]), .SO(ScanChain[14]));
  CapUpdCell uscan14 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[14]), .DataIn(iHADDR[17]), .DataOut(HADDR[17]), .SO(ScanChain[15]));
  CapUpdCell uscan15 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[15]), .DataIn(iHADDR[16]), .DataOut(HADDR[16]), .SO(ScanChain[16]));
  CapUpdCell uscan16 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[16]), .DataIn(iHADDR[15]), .DataOut(HADDR[15]), .SO(ScanChain[17]));
  CapUpdCell uscan17 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[17]), .DataIn(iHADDR[14]), .DataOut(HADDR[14]), .SO(ScanChain[18]));
  CapUpdCell uscan18 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[18]), .DataIn(iHADDR[13]), .DataOut(HADDR[13]), .SO(ScanChain[19]));
  CapUpdCell uscan19 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[19]), .DataIn(iHADDR[12]), .DataOut(HADDR[12]), .SO(ScanChain[20]));
  CapUpdCell uscan20 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[20]), .DataIn(iHADDR[11]), .DataOut(HADDR[11]), .SO(ScanChain[21]));
  CapUpdCell uscan21 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[21]), .DataIn(iHADDR[10]), .DataOut(HADDR[10]), .SO(ScanChain[22]));
  CapUpdCell uscan22 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[22]), .DataIn(iHADDR[9]), .DataOut(HADDR[9]), .SO(ScanChain[23]));
  CapUpdCell uscan23 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[23]), .DataIn(iHADDR[8]), .DataOut(HADDR[8]), .SO(ScanChain[24]));
  CapUpdCell uscan24 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[24]), .DataIn(iHADDR[7]), .DataOut(HADDR[7]), .SO(ScanChain[25]));
  CapUpdCell uscan25 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[25]), .DataIn(iHADDR[6]), .DataOut(HADDR[6]), .SO(ScanChain[26]));
  CapUpdCell uscan26 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[26]), .DataIn(iHADDR[5]), .DataOut(HADDR[5]), .SO(ScanChain[27]));
  CapUpdCell uscan27 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[27]), .DataIn(iHADDR[4]), .DataOut(HADDR[4]), .SO(ScanChain[28]));
  CapUpdCell uscan28 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[28]), .DataIn(iHADDR[3]), .DataOut(HADDR[3]), .SO(ScanChain[29]));
  CapUpdCell uscan29 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[29]), .DataIn(iHADDR[2]), .DataOut(HADDR[2]), .SO(ScanChain[30]));
  CapUpdCell uscan30 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[30]), .DataIn(iHADDR[1]), .DataOut(HADDR[1]), .SO(ScanChain[31]));
  CapUpdCell uscan31 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[31]), .DataIn(iHADDR[0]), .DataOut(HADDR[0]), .SO(ScanChain[32]));
  CapUpdCell uscan32 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[32]), .DataIn(iHTRANS[1]), .DataOut(HTRANS[1]), .SO(ScanChain[33]));
  CapUpdCell uscan33 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[33]), .DataIn(iHTRANS[0]), .DataOut(HTRANS[0]), .SO(ScanChain[34]));
  CapUpdCell uscan34 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[34]), .DataIn(iHBURST[2]), .DataOut(HBURST[2]), .SO(ScanChain[35]));
  CapUpdCell uscan35 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[35]), .DataIn(iHBURST[1]), .DataOut(HBURST[1]), .SO(ScanChain[36]));
  CapUpdCell uscan36 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[36]), .DataIn(iHBURST[0]), .DataOut(HBURST[0]), .SO(ScanChain[37]));
  CapUpdCell uscan37 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[37]), .DataIn(iHWRITE), .DataOut(HWRITE), .SO(ScanChain[38]));
  CapUpdCell uscan38 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[38]), .DataIn(iHSIZE[2]), .DataOut(HSIZE[2]), .SO(ScanChain[39]));
  CapUpdCell uscan39 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[39]), .DataIn(iHSIZE[1]), .DataOut(HSIZE[1]), .SO(ScanChain[40]));
  CapUpdCell uscan40 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[40]), .DataIn(iHSIZE[0]), .DataOut(HSIZE[0]), .SO(ScanChain[41]));
  CapUpdCell uscan41 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[41]), .DataIn(iHPROT[3]), .DataOut(HPROT[3]), .SO(ScanChain[42]));
  CapUpdCell uscan42 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[42]), .DataIn(iHPROT[2]), .DataOut(HPROT[2]), .SO(ScanChain[43]));
  CapUpdCell uscan43 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[43]), .DataIn(iHPROT[1]), .DataOut(HPROT[1]), .SO(ScanChain[44]));
  CapUpdCell uscan44 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[44]), .DataIn(iHPROT[0]), .DataOut(HPROT[0]), .SO(ScanChain[45]));
  CapUpdCell uscan45 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[45]), .DataIn(HREADY), .DataOut(iHREADY), .SO(ScanChain[46]));
  CapUpdCell uscan46 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[46]), .DataIn(HRESP[1]), .DataOut(iHRESP[1]), .SO(ScanChain[47]));
  CapUpdCell uscan47 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[47]), .DataIn(HRESP[0]), .DataOut(iHRESP[0]), .SO(ScanChain[48]));
  CapUpdCell uscan48 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[48]), .DataIn(iHWDATA[31]), .DataOut(HWDATA[31]), .SO(ScanChain[49]));
  CapUpdCell uscan49 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[49]), .DataIn(iHWDATA[30]), .DataOut(HWDATA[30]), .SO(ScanChain[50]));
  CapUpdCell uscan50 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[50]), .DataIn(iHWDATA[29]), .DataOut(HWDATA[29]), .SO(ScanChain[51]));
  CapUpdCell uscan51 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[51]), .DataIn(iHWDATA[28]), .DataOut(HWDATA[28]), .SO(ScanChain[52]));
  CapUpdCell uscan52 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[52]), .DataIn(iHWDATA[27]), .DataOut(HWDATA[27]), .SO(ScanChain[53]));
  CapUpdCell uscan53 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[53]), .DataIn(iHWDATA[26]), .DataOut(HWDATA[26]), .SO(ScanChain[54]));
  CapUpdCell uscan54 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[54]), .DataIn(iHWDATA[25]), .DataOut(HWDATA[25]), .SO(ScanChain[55]));
  CapUpdCell uscan55 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[55]), .DataIn(iHWDATA[24]), .DataOut(HWDATA[24]), .SO(ScanChain[56]));
  CapUpdCell uscan56 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[56]), .DataIn(iHWDATA[23]), .DataOut(HWDATA[23]), .SO(ScanChain[57]));
  CapUpdCell uscan57 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[57]), .DataIn(iHWDATA[22]), .DataOut(HWDATA[22]), .SO(ScanChain[58]));
  CapUpdCell uscan58 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[58]), .DataIn(iHWDATA[21]), .DataOut(HWDATA[21]), .SO(ScanChain[59]));
  CapUpdCell uscan59 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[59]), .DataIn(iHWDATA[20]), .DataOut(HWDATA[20]), .SO(ScanChain[60]));
  CapUpdCell uscan60 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[60]), .DataIn(iHWDATA[19]), .DataOut(HWDATA[19]), .SO(ScanChain[61]));
  CapUpdCell uscan61 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[61]), .DataIn(iHWDATA[18]), .DataOut(HWDATA[18]), .SO(ScanChain[62]));
  CapUpdCell uscan62 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[62]), .DataIn(iHWDATA[17]), .DataOut(HWDATA[17]), .SO(ScanChain[63]));
  CapUpdCell uscan63 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[63]), .DataIn(iHWDATA[16]), .DataOut(HWDATA[16]), .SO(ScanChain[64]));
  CapUpdCell uscan64 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[64]), .DataIn(iHWDATA[15]), .DataOut(HWDATA[15]), .SO(ScanChain[65]));
  CapUpdCell uscan65 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[65]), .DataIn(iHWDATA[14]), .DataOut(HWDATA[14]), .SO(ScanChain[66]));
  CapUpdCell uscan66 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[66]), .DataIn(iHWDATA[13]), .DataOut(HWDATA[13]), .SO(ScanChain[67]));
  CapUpdCell uscan67 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[67]), .DataIn(iHWDATA[12]), .DataOut(HWDATA[12]), .SO(ScanChain[68]));
  CapUpdCell uscan68 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[68]), .DataIn(iHWDATA[11]), .DataOut(HWDATA[11]), .SO(ScanChain[69]));
  CapUpdCell uscan69 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[69]), .DataIn(iHWDATA[10]), .DataOut(HWDATA[10]), .SO(ScanChain[70]));
  CapUpdCell uscan70 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[70]), .DataIn(iHWDATA[9]), .DataOut(HWDATA[9]), .SO(ScanChain[71]));
  CapUpdCell uscan71 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[71]), .DataIn(iHWDATA[8]), .DataOut(HWDATA[8]), .SO(ScanChain[72]));
  CapUpdCell uscan72 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[72]), .DataIn(iHWDATA[7]), .DataOut(HWDATA[7]), .SO(ScanChain[73]));
  CapUpdCell uscan73 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[73]), .DataIn(iHWDATA[6]), .DataOut(HWDATA[6]), .SO(ScanChain[74]));
  CapUpdCell uscan74 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[74]), .DataIn(iHWDATA[5]), .DataOut(HWDATA[5]), .SO(ScanChain[75]));
  CapUpdCell uscan75 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[75]), .DataIn(iHWDATA[4]), .DataOut(HWDATA[4]), .SO(ScanChain[76]));
  CapUpdCell uscan76 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[76]), .DataIn(iHWDATA[3]), .DataOut(HWDATA[3]), .SO(ScanChain[77]));
  CapUpdCell uscan77 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[77]), .DataIn(iHWDATA[2]), .DataOut(HWDATA[2]), .SO(ScanChain[78]));
  CapUpdCell uscan78 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[78]), .DataIn(iHWDATA[1]), .DataOut(HWDATA[1]), .SO(ScanChain[79]));
  CapUpdCell uscan79 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[79]), .DataIn(iHWDATA[0]), .DataOut(HWDATA[0]), .SO(ScanChain[80]));
  CapUpdCell uscan80 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[80]), .DataIn(HRDATA[31]), .DataOut(iHRDATA[31]), .SO(ScanChain[81]));
  CapUpdCell uscan81 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[81]), .DataIn(HRDATA[30]), .DataOut(iHRDATA[30]), .SO(ScanChain[82]));
  CapUpdCell uscan82 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[82]), .DataIn(HRDATA[29]), .DataOut(iHRDATA[29]), .SO(ScanChain[83]));
  CapUpdCell uscan83 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[83]), .DataIn(HRDATA[28]), .DataOut(iHRDATA[28]), .SO(ScanChain[84]));
  CapUpdCell uscan84 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[84]), .DataIn(HRDATA[27]), .DataOut(iHRDATA[27]), .SO(ScanChain[85]));
  CapUpdCell uscan85 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[85]), .DataIn(HRDATA[26]), .DataOut(iHRDATA[26]), .SO(ScanChain[86]));
  CapUpdCell uscan86 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[86]), .DataIn(HRDATA[25]), .DataOut(iHRDATA[25]), .SO(ScanChain[87]));
  CapUpdCell uscan87 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[87]), .DataIn(HRDATA[24]), .DataOut(iHRDATA[24]), .SO(ScanChain[88]));
  CapUpdCell uscan88 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[88]), .DataIn(HRDATA[23]), .DataOut(iHRDATA[23]), .SO(ScanChain[89]));
  CapUpdCell uscan89 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[89]), .DataIn(HRDATA[22]), .DataOut(iHRDATA[22]), .SO(ScanChain[90]));
  CapUpdCell uscan90 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[90]), .DataIn(HRDATA[21]), .DataOut(iHRDATA[21]), .SO(ScanChain[91]));
  CapUpdCell uscan91 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[91]), .DataIn(HRDATA[20]), .DataOut(iHRDATA[20]), .SO(ScanChain[92]));
  CapUpdCell uscan92 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[92]), .DataIn(HRDATA[19]), .DataOut(iHRDATA[19]), .SO(ScanChain[93]));
  CapUpdCell uscan93 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[93]), .DataIn(HRDATA[18]), .DataOut(iHRDATA[18]), .SO(ScanChain[94]));
  CapUpdCell uscan94 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[94]), .DataIn(HRDATA[17]), .DataOut(iHRDATA[17]), .SO(ScanChain[95]));
  CapUpdCell uscan95 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[95]), .DataIn(HRDATA[16]), .DataOut(iHRDATA[16]), .SO(ScanChain[96]));
  CapUpdCell uscan96 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[96]), .DataIn(HRDATA[15]), .DataOut(iHRDATA[15]), .SO(ScanChain[97]));
  CapUpdCell uscan97 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[97]), .DataIn(HRDATA[14]), .DataOut(iHRDATA[14]), .SO(ScanChain[98]));
  CapUpdCell uscan98 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[98]), .DataIn(HRDATA[13]), .DataOut(iHRDATA[13]), .SO(ScanChain[99]));
  CapUpdCell uscan99 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[99]), .DataIn(HRDATA[12]), .DataOut(iHRDATA[12]), .SO(ScanChain[100]));
  CapUpdCell uscan100 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[100]), .DataIn(HRDATA[11]), .DataOut(iHRDATA[11]), .SO(ScanChain[101]));
  CapUpdCell uscan101 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[101]), .DataIn(HRDATA[10]), .DataOut(iHRDATA[10]), .SO(ScanChain[102]));
  CapUpdCell uscan102 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[102]), .DataIn(HRDATA[9]), .DataOut(iHRDATA[9]), .SO(ScanChain[103]));
  CapUpdCell uscan103 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[103]), .DataIn(HRDATA[8]), .DataOut(iHRDATA[8]), .SO(ScanChain[104]));
  CapUpdCell uscan104 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[104]), .DataIn(HRDATA[7]), .DataOut(iHRDATA[7]), .SO(ScanChain[105]));
  CapUpdCell uscan105 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[105]), .DataIn(HRDATA[6]), .DataOut(iHRDATA[6]), .SO(ScanChain[106]));
  CapUpdCell uscan106 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[106]), .DataIn(HRDATA[5]), .DataOut(iHRDATA[5]), .SO(ScanChain[107]));
  CapUpdCell uscan107 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[107]), .DataIn(HRDATA[4]), .DataOut(iHRDATA[4]), .SO(ScanChain[108]));
  CapUpdCell uscan108 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[108]), .DataIn(HRDATA[3]), .DataOut(iHRDATA[3]), .SO(ScanChain[109]));
  CapUpdCell uscan109 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[109]), .DataIn(HRDATA[2]), .DataOut(iHRDATA[2]), .SO(ScanChain[110]));
  CapUpdCell uscan110 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[110]), .DataIn(HRDATA[1]), .DataOut(iHRDATA[1]), .SO(ScanChain[111]));
  CapUpdCell uscan111 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[111]), .DataIn(HRDATA[0]), .DataOut(iHRDATA[0]), .SO(ScanChain[112]));
  CapUpdCell uscan112 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[112]), .DataIn(iHBUSREQ), .DataOut(HBUSREQ), .SO(ScanChain[113]));
  CapUpdCell uscan113 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[113]), .DataIn(HGRANT), .DataOut(iHGRANT), .SO(ScanChain[114]));
  CapUpdCell uscan114 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[114]), .DataIn(iHLOCK), .DataOut(HLOCK), .SO(ScanChain[115]));
  CapUpdCellReset uscan115 ( .ScanEn(ScanEn), .TestEn(TestEn), .SerialEn(SerialEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[115]), .DataIn(HRESETn), .DataOut(iHRESETn), .SO(ScanChain[116]));
  CapUpdCell uscan116 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[116]), .DataIn(iCPCLKEN), .DataOut(CPCLKEN), .SO(ScanChain[117]));
  CapUpdCell uscan117 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[117]), .DataIn(iCPINSTR[31]), .DataOut(CPINSTR[31]), .SO(ScanChain[118]));
  CapUpdCell uscan118 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[118]), .DataIn(iCPINSTR[30]), .DataOut(CPINSTR[30]), .SO(ScanChain[119]));
  CapUpdCell uscan119 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[119]), .DataIn(iCPINSTR[29]), .DataOut(CPINSTR[29]), .SO(ScanChain[120]));
  CapUpdCell uscan120 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[120]), .DataIn(iCPINSTR[28]), .DataOut(CPINSTR[28]), .SO(ScanChain[121]));
  CapUpdCell uscan121 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[121]), .DataIn(iCPINSTR[27]), .DataOut(CPINSTR[27]), .SO(ScanChain[122]));
  CapUpdCell uscan122 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[122]), .DataIn(iCPINSTR[26]), .DataOut(CPINSTR[26]), .SO(ScanChain[123]));
  CapUpdCell uscan123 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[123]), .DataIn(iCPINSTR[25]), .DataOut(CPINSTR[25]), .SO(ScanChain[124]));
  CapUpdCell uscan124 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[124]), .DataIn(iCPINSTR[24]), .DataOut(CPINSTR[24]), .SO(ScanChain[125]));
  CapUpdCell uscan125 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[125]), .DataIn(iCPINSTR[23]), .DataOut(CPINSTR[23]), .SO(ScanChain[126]));
  CapUpdCell uscan126 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[126]), .DataIn(iCPINSTR[22]), .DataOut(CPINSTR[22]), .SO(ScanChain[127]));
  CapUpdCell uscan127 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[127]), .DataIn(iCPINSTR[21]), .DataOut(CPINSTR[21]), .SO(ScanChain[128]));
  CapUpdCell uscan128 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[128]), .DataIn(iCPINSTR[20]), .DataOut(CPINSTR[20]), .SO(ScanChain[129]));
  CapUpdCell uscan129 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[129]), .DataIn(iCPINSTR[19]), .DataOut(CPINSTR[19]), .SO(ScanChain[130]));
  CapUpdCell uscan130 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[130]), .DataIn(iCPINSTR[18]), .DataOut(CPINSTR[18]), .SO(ScanChain[131]));
  CapUpdCell uscan131 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[131]), .DataIn(iCPINSTR[17]), .DataOut(CPINSTR[17]), .SO(ScanChain[132]));
  CapUpdCell uscan132 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[132]), .DataIn(iCPINSTR[16]), .DataOut(CPINSTR[16]), .SO(ScanChain[133]));
  CapUpdCell uscan133 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[133]), .DataIn(iCPINSTR[15]), .DataOut(CPINSTR[15]), .SO(ScanChain[134]));
  CapUpdCell uscan134 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[134]), .DataIn(iCPINSTR[14]), .DataOut(CPINSTR[14]), .SO(ScanChain[135]));
  CapUpdCell uscan135 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[135]), .DataIn(iCPINSTR[13]), .DataOut(CPINSTR[13]), .SO(ScanChain[136]));
  CapUpdCell uscan136 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[136]), .DataIn(iCPINSTR[12]), .DataOut(CPINSTR[12]), .SO(ScanChain[137]));
  CapUpdCell uscan137 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[137]), .DataIn(iCPINSTR[11]), .DataOut(CPINSTR[11]), .SO(ScanChain[138]));
  CapUpdCell uscan138 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[138]), .DataIn(iCPINSTR[10]), .DataOut(CPINSTR[10]), .SO(ScanChain[139]));
  CapUpdCell uscan139 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[139]), .DataIn(iCPINSTR[9]), .DataOut(CPINSTR[9]), .SO(ScanChain[140]));
  CapUpdCell uscan140 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[140]), .DataIn(iCPINSTR[8]), .DataOut(CPINSTR[8]), .SO(ScanChain[141]));
  CapUpdCell uscan141 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[141]), .DataIn(iCPINSTR[7]), .DataOut(CPINSTR[7]), .SO(ScanChain[142]));
  CapUpdCell uscan142 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[142]), .DataIn(iCPINSTR[6]), .DataOut(CPINSTR[6]), .SO(ScanChain[143]));
  CapUpdCell uscan143 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[143]), .DataIn(iCPINSTR[5]), .DataOut(CPINSTR[5]), .SO(ScanChain[144]));
  CapUpdCell uscan144 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[144]), .DataIn(iCPINSTR[4]), .DataOut(CPINSTR[4]), .SO(ScanChain[145]));
  CapUpdCell uscan145 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[145]), .DataIn(iCPINSTR[3]), .DataOut(CPINSTR[3]), .SO(ScanChain[146]));
  CapUpdCell uscan146 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[146]), .DataIn(iCPINSTR[2]), .DataOut(CPINSTR[2]), .SO(ScanChain[147]));
  CapUpdCell uscan147 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[147]), .DataIn(iCPINSTR[1]), .DataOut(CPINSTR[1]), .SO(ScanChain[148]));
  CapUpdCell uscan148 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[148]), .DataIn(iCPINSTR[0]), .DataOut(CPINSTR[0]), .SO(ScanChain[149]));
  CapUpdCell uscan149 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[149]), .DataIn(iCPDOUT[31]), .DataOut(CPDOUT[31]), .SO(ScanChain[150]));
  CapUpdCell uscan150 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[150]), .DataIn(iCPDOUT[30]), .DataOut(CPDOUT[30]), .SO(ScanChain[151]));
  CapUpdCell uscan151 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[151]), .DataIn(iCPDOUT[29]), .DataOut(CPDOUT[29]), .SO(ScanChain[152]));
  CapUpdCell uscan152 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[152]), .DataIn(iCPDOUT[28]), .DataOut(CPDOUT[28]), .SO(ScanChain[153]));
  CapUpdCell uscan153 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[153]), .DataIn(iCPDOUT[27]), .DataOut(CPDOUT[27]), .SO(ScanChain[154]));
  CapUpdCell uscan154 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[154]), .DataIn(iCPDOUT[26]), .DataOut(CPDOUT[26]), .SO(ScanChain[155]));
  CapUpdCell uscan155 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[155]), .DataIn(iCPDOUT[25]), .DataOut(CPDOUT[25]), .SO(ScanChain[156]));
  CapUpdCell uscan156 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[156]), .DataIn(iCPDOUT[24]), .DataOut(CPDOUT[24]), .SO(ScanChain[157]));
  CapUpdCell uscan157 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[157]), .DataIn(iCPDOUT[23]), .DataOut(CPDOUT[23]), .SO(ScanChain[158]));
  CapUpdCell uscan158 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[158]), .DataIn(iCPDOUT[22]), .DataOut(CPDOUT[22]), .SO(ScanChain[159]));
  CapUpdCell uscan159 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[159]), .DataIn(iCPDOUT[21]), .DataOut(CPDOUT[21]), .SO(ScanChain[160]));
  CapUpdCell uscan160 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[160]), .DataIn(iCPDOUT[20]), .DataOut(CPDOUT[20]), .SO(ScanChain[161]));
  CapUpdCell uscan161 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[161]), .DataIn(iCPDOUT[19]), .DataOut(CPDOUT[19]), .SO(ScanChain[162]));
  CapUpdCell uscan162 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[162]), .DataIn(iCPDOUT[18]), .DataOut(CPDOUT[18]), .SO(ScanChain[163]));
  CapUpdCell uscan163 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[163]), .DataIn(iCPDOUT[17]), .DataOut(CPDOUT[17]), .SO(ScanChain[164]));
  CapUpdCell uscan164 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[164]), .DataIn(iCPDOUT[16]), .DataOut(CPDOUT[16]), .SO(ScanChain[165]));
  CapUpdCell uscan165 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[165]), .DataIn(iCPDOUT[15]), .DataOut(CPDOUT[15]), .SO(ScanChain[166]));
  CapUpdCell uscan166 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[166]), .DataIn(iCPDOUT[14]), .DataOut(CPDOUT[14]), .SO(ScanChain[167]));
  CapUpdCell uscan167 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[167]), .DataIn(iCPDOUT[13]), .DataOut(CPDOUT[13]), .SO(ScanChain[168]));
  CapUpdCell uscan168 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[168]), .DataIn(iCPDOUT[12]), .DataOut(CPDOUT[12]), .SO(ScanChain[169]));
  CapUpdCell uscan169 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[169]), .DataIn(iCPDOUT[11]), .DataOut(CPDOUT[11]), .SO(ScanChain[170]));
  CapUpdCell uscan170 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[170]), .DataIn(iCPDOUT[10]), .DataOut(CPDOUT[10]), .SO(ScanChain[171]));
  CapUpdCell uscan171 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[171]), .DataIn(iCPDOUT[9]), .DataOut(CPDOUT[9]), .SO(ScanChain[172]));
  CapUpdCell uscan172 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[172]), .DataIn(iCPDOUT[8]), .DataOut(CPDOUT[8]), .SO(ScanChain[173]));
  CapUpdCell uscan173 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[173]), .DataIn(iCPDOUT[7]), .DataOut(CPDOUT[7]), .SO(ScanChain[174]));
  CapUpdCell uscan174 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[174]), .DataIn(iCPDOUT[6]), .DataOut(CPDOUT[6]), .SO(ScanChain[175]));
  CapUpdCell uscan175 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[175]), .DataIn(iCPDOUT[5]), .DataOut(CPDOUT[5]), .SO(ScanChain[176]));
  CapUpdCell uscan176 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[176]), .DataIn(iCPDOUT[4]), .DataOut(CPDOUT[4]), .SO(ScanChain[177]));
  CapUpdCell uscan177 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[177]), .DataIn(iCPDOUT[3]), .DataOut(CPDOUT[3]), .SO(ScanChain[178]));
  CapUpdCell uscan178 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[178]), .DataIn(iCPDOUT[2]), .DataOut(CPDOUT[2]), .SO(ScanChain[179]));
  CapUpdCell uscan179 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[179]), .DataIn(iCPDOUT[1]), .DataOut(CPDOUT[1]), .SO(ScanChain[180]));
  CapUpdCell uscan180 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[180]), .DataIn(iCPDOUT[0]), .DataOut(CPDOUT[0]), .SO(ScanChain[181]));
  CapUpdCell uscan181 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[181]), .DataIn(CPDIN[31]), .DataOut(iCPDIN[31]), .SO(ScanChain[182]));
  CapUpdCell uscan182 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[182]), .DataIn(CPDIN[30]), .DataOut(iCPDIN[30]), .SO(ScanChain[183]));
  CapUpdCell uscan183 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[183]), .DataIn(CPDIN[29]), .DataOut(iCPDIN[29]), .SO(ScanChain[184]));
  CapUpdCell uscan184 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[184]), .DataIn(CPDIN[28]), .DataOut(iCPDIN[28]), .SO(ScanChain[185]));
  CapUpdCell uscan185 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[185]), .DataIn(CPDIN[27]), .DataOut(iCPDIN[27]), .SO(ScanChain[186]));
  CapUpdCell uscan186 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[186]), .DataIn(CPDIN[26]), .DataOut(iCPDIN[26]), .SO(ScanChain[187]));
  CapUpdCell uscan187 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[187]), .DataIn(CPDIN[25]), .DataOut(iCPDIN[25]), .SO(ScanChain[188]));
  CapUpdCell uscan188 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[188]), .DataIn(CPDIN[24]), .DataOut(iCPDIN[24]), .SO(ScanChain[189]));
  CapUpdCell uscan189 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[189]), .DataIn(CPDIN[23]), .DataOut(iCPDIN[23]), .SO(ScanChain[190]));
  CapUpdCell uscan190 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[190]), .DataIn(CPDIN[22]), .DataOut(iCPDIN[22]), .SO(ScanChain[191]));
  CapUpdCell uscan191 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[191]), .DataIn(CPDIN[21]), .DataOut(iCPDIN[21]), .SO(ScanChain[192]));
  CapUpdCell uscan192 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[192]), .DataIn(CPDIN[20]), .DataOut(iCPDIN[20]), .SO(ScanChain[193]));
  CapUpdCell uscan193 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[193]), .DataIn(CPDIN[19]), .DataOut(iCPDIN[19]), .SO(ScanChain[194]));
  CapUpdCell uscan194 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[194]), .DataIn(CPDIN[18]), .DataOut(iCPDIN[18]), .SO(ScanChain[195]));
  CapUpdCell uscan195 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[195]), .DataIn(CPDIN[17]), .DataOut(iCPDIN[17]), .SO(ScanChain[196]));
  CapUpdCell uscan196 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[196]), .DataIn(CPDIN[16]), .DataOut(iCPDIN[16]), .SO(ScanChain[197]));
  CapUpdCell uscan197 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[197]), .DataIn(CPDIN[15]), .DataOut(iCPDIN[15]), .SO(ScanChain[198]));
  CapUpdCell uscan198 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[198]), .DataIn(CPDIN[14]), .DataOut(iCPDIN[14]), .SO(ScanChain[199]));
  CapUpdCell uscan199 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[199]), .DataIn(CPDIN[13]), .DataOut(iCPDIN[13]), .SO(ScanChain[200]));
  CapUpdCell uscan200 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[200]), .DataIn(CPDIN[12]), .DataOut(iCPDIN[12]), .SO(ScanChain[201]));
  CapUpdCell uscan201 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[201]), .DataIn(CPDIN[11]), .DataOut(iCPDIN[11]), .SO(ScanChain[202]));
  CapUpdCell uscan202 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[202]), .DataIn(CPDIN[10]), .DataOut(iCPDIN[10]), .SO(ScanChain[203]));
  CapUpdCell uscan203 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[203]), .DataIn(CPDIN[9]), .DataOut(iCPDIN[9]), .SO(ScanChain[204]));
  CapUpdCell uscan204 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[204]), .DataIn(CPDIN[8]), .DataOut(iCPDIN[8]), .SO(ScanChain[205]));
  CapUpdCell uscan205 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[205]), .DataIn(CPDIN[7]), .DataOut(iCPDIN[7]), .SO(ScanChain[206]));
  CapUpdCell uscan206 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[206]), .DataIn(CPDIN[6]), .DataOut(iCPDIN[6]), .SO(ScanChain[207]));
  CapUpdCell uscan207 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[207]), .DataIn(CPDIN[5]), .DataOut(iCPDIN[5]), .SO(ScanChain[208]));
  CapUpdCell uscan208 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[208]), .DataIn(CPDIN[4]), .DataOut(iCPDIN[4]), .SO(ScanChain[209]));
  CapUpdCell uscan209 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[209]), .DataIn(CPDIN[3]), .DataOut(iCPDIN[3]), .SO(ScanChain[210]));
  CapUpdCell uscan210 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[210]), .DataIn(CPDIN[2]), .DataOut(iCPDIN[2]), .SO(ScanChain[211]));
  CapUpdCell uscan211 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[211]), .DataIn(CPDIN[1]), .DataOut(iCPDIN[1]), .SO(ScanChain[212]));
  CapUpdCell uscan212 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[212]), .DataIn(CPDIN[0]), .DataOut(iCPDIN[0]), .SO(ScanChain[213]));
  CapUpdCell uscan213 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[213]), .DataIn(iCPPASS), .DataOut(CPPASS), .SO(ScanChain[214]));
  CapUpdCell uscan214 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[214]), .DataIn(iCPLATECANCEL), .DataOut(CPLATECANCEL), .SO(ScanChain[215]));
  CapUpdCell uscan215 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[215]), .DataIn(CHSDE[1]), .DataOut(iCHSDE[1]), .SO(ScanChain[216]));
  CapUpdCell uscan216 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[216]), .DataIn(CHSDE[0]), .DataOut(iCHSDE[0]), .SO(ScanChain[217]));
  CapUpdCell uscan217 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[217]), .DataIn(CHSEX[1]), .DataOut(iCHSEX[1]), .SO(ScanChain[218]));
  CapUpdCell uscan218 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[218]), .DataIn(CHSEX[0]), .DataOut(iCHSEX[0]), .SO(ScanChain[219]));
  CapUpdCell uscan219 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[219]), .DataIn(iCPTBIT), .DataOut(CPTBIT), .SO(ScanChain[220]));
  CapUpdCell uscan220 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[220]), .DataIn(inCPMREQ), .DataOut(nCPMREQ), .SO(ScanChain[221]));
  CapUpdCell uscan221 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[221]), .DataIn(inCPTRANS), .DataOut(nCPTRANS), .SO(ScanChain[222]));
  CapUpdCell uscan222 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[222]), .DataIn(iCOMMRX), .DataOut(COMMRX), .SO(ScanChain[223]));
  CapUpdCell uscan223 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[223]), .DataIn(iCOMMTX), .DataOut(COMMTX), .SO(ScanChain[224]));
  CapUpdCell uscan224 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[224]), .DataIn(iDBGACK), .DataOut(DBGACK), .SO(ScanChain[225]));
  CapUpdCell uscan225 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[225]), .DataIn(DBGEN), .DataOut(iDBGEN), .SO(ScanChain[226]));
  CapUpdCell uscan226 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[226]), .DataIn(iDBGRQI), .DataOut(DBGRQI), .SO(ScanChain[227]));
  CapUpdCell uscan227 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[227]), .DataIn(EDBGRQ), .DataOut(iEDBGRQ), .SO(ScanChain[228]));
  CapUpdCell uscan228 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[228]), .DataIn(DBGEXT[1]), .DataOut(iDBGEXT[1]), .SO(ScanChain[229]));
  CapUpdCell uscan229 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[229]), .DataIn(DBGEXT[0]), .DataOut(iDBGEXT[0]), .SO(ScanChain[230]));
  CapUpdCell uscan230 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[230]), .DataIn(iDBGINSTREXEC), .DataOut(DBGINSTREXEC), .SO(ScanChain[231]));
  CapUpdCell uscan231 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[231]), .DataIn(iDBGRNG[1]), .DataOut(DBGRNG[1]), .SO(ScanChain[232]));
  CapUpdCell uscan232 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[232]), .DataIn(iDBGRNG[0]), .DataOut(DBGRNG[0]), .SO(ScanChain[233]));
  CapUpdCell uscan233 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[233]), .DataIn(DBGIEBKPT), .DataOut(iDBGIEBKPT), .SO(ScanChain[234]));
  CapUpdCell uscan234 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[234]), .DataIn(DBGDEWPT), .DataOut(iDBGDEWPT), .SO(ScanChain[235]));
  CapUpdCellReset uscan235 ( .ScanEn(ScanEn), .TestEn(TestEn), .SerialEn(SerialEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[235]), .DataIn(DBGnTRST), .DataOut(iDBGnTRST), .SO(ScanChain[236]));
  CapUpdCellClkEn uscan236 ( .ScanEn(ScanEn), .TestEn(TestEn), .SerialEn(SerialEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[236]), .DataIn(DBGTCKEN), .DataOut(iDBGTCKEN), .SO(ScanChain[237]));
  CapUpdCell uscan237 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[237]), .DataIn(DBGTDI), .DataOut(iDBGTDI), .SO(ScanChain[238]));
  CapUpdCell uscan238 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[238]), .DataIn(DBGTMS), .DataOut(iDBGTMS), .SO(ScanChain[239]));
  CapUpdCell uscan239 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[239]), .DataIn(iDBGTDO), .DataOut(DBGTDO), .SO(ScanChain[240]));
  CapUpdCell uscan240 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[240]), .DataIn(iDBGIR[3]), .DataOut(DBGIR[3]), .SO(ScanChain[241]));
  CapUpdCell uscan241 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[241]), .DataIn(iDBGIR[2]), .DataOut(DBGIR[2]), .SO(ScanChain[242]));
  CapUpdCell uscan242 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[242]), .DataIn(iDBGIR[1]), .DataOut(DBGIR[1]), .SO(ScanChain[243]));
  CapUpdCell uscan243 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[243]), .DataIn(iDBGIR[0]), .DataOut(DBGIR[0]), .SO(ScanChain[244]));
  CapUpdCell uscan244 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[244]), .DataIn(iDBGSCREG[4]), .DataOut(DBGSCREG[4]), .SO(ScanChain[245]));
  CapUpdCell uscan245 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[245]), .DataIn(iDBGSCREG[3]), .DataOut(DBGSCREG[3]), .SO(ScanChain[246]));
  CapUpdCell uscan246 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[246]), .DataIn(iDBGSCREG[2]), .DataOut(DBGSCREG[2]), .SO(ScanChain[247]));
  CapUpdCell uscan247 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[247]), .DataIn(iDBGSCREG[1]), .DataOut(DBGSCREG[1]), .SO(ScanChain[248]));
  CapUpdCell uscan248 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[248]), .DataIn(iDBGSCREG[0]), .DataOut(DBGSCREG[0]), .SO(ScanChain[249]));
  CapUpdCell uscan249 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[249]), .DataIn(iDBGTAPSM[3]), .DataOut(DBGTAPSM[3]), .SO(ScanChain[250]));
  CapUpdCell uscan250 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[250]), .DataIn(iDBGTAPSM[2]), .DataOut(DBGTAPSM[2]), .SO(ScanChain[251]));
  CapUpdCell uscan251 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[251]), .DataIn(iDBGTAPSM[1]), .DataOut(DBGTAPSM[1]), .SO(ScanChain[252]));
  CapUpdCell uscan252 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[252]), .DataIn(iDBGTAPSM[0]), .DataOut(DBGTAPSM[0]), .SO(ScanChain[253]));
  CapUpdCell uscan253 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[253]), .DataIn(iDBGnTDOEN), .DataOut(DBGnTDOEN), .SO(ScanChain[254]));
  CapUpdCell uscan254 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[254]), .DataIn(iDBGSDIN), .DataOut(DBGSDIN), .SO(ScanChain[255]));
  CapUpdCell uscan255 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[255]), .DataIn(DBGSDOUT), .DataOut(iDBGSDOUT), .SO(ScanChain[256]));
  CapUpdCellClkEn uscan256 ( .ScanEn(ScanEn), .TestEn(TestEn), .SerialEn(SerialEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[256]), .DataIn(HCLKEN), .DataOut(iHCLKEN), .SO(ScanChain[257]));
  CapUpdCell uscan257 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[257]), .DataIn(nFIQ), .DataOut(inFIQ), .SO(ScanChain[258]));
  CapUpdCell uscan258 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[258]), .DataIn(nIRQ), .DataOut(inIRQ), .SO(ScanChain[259]));
  CapUpdCell uscan259 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[259]), .DataIn(iBIGENDOUT), .DataOut(BIGENDOUT), .SO(ScanChain[260]));
  CapUpdCell uscan260 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[260]), .DataIn(VINITHI), .DataOut(iVINITHI), .SO(ScanChain[261]));
  CapUpdCellReset uscan261 ( .ScanEn(ScanEn), .TestEn(TestEn), .SerialEn(SerialEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[261]), .DataIn(DCacheSize[3]), .DataOut(iDCacheSize[3]), .SO(ScanChain[262]));
  CapUpdCellReset uscan262 ( .ScanEn(ScanEn), .TestEn(TestEn), .SerialEn(SerialEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[262]), .DataIn(DCacheSize[2]), .DataOut(iDCacheSize[2]), .SO(ScanChain[263]));
  CapUpdCellReset uscan263 ( .ScanEn(ScanEn), .TestEn(TestEn), .SerialEn(SerialEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[263]), .DataIn(DCacheSize[1]), .DataOut(iDCacheSize[1]), .SO(ScanChain[264]));
  CapUpdCellReset uscan264 ( .ScanEn(ScanEn), .TestEn(TestEn), .SerialEn(SerialEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[264]), .DataIn(DCacheSize[0]), .DataOut(iDCacheSize[0]), .SO(ScanChain[265]));
  CapUpdCellReset uscan265 ( .ScanEn(ScanEn), .TestEn(TestEn), .SerialEn(SerialEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[265]), .DataIn(ICacheSize[3]), .DataOut(iICacheSize[3]), .SO(ScanChain[266]));
  CapUpdCellReset uscan266 ( .ScanEn(ScanEn), .TestEn(TestEn), .SerialEn(SerialEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[266]), .DataIn(ICacheSize[2]), .DataOut(iICacheSize[2]), .SO(ScanChain[267]));
  CapUpdCellReset uscan267 ( .ScanEn(ScanEn), .TestEn(TestEn), .SerialEn(SerialEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[267]), .DataIn(ICacheSize[1]), .DataOut(iICacheSize[1]), .SO(ScanChain[268]));
  CapUpdCellReset uscan268 ( .ScanEn(ScanEn), .TestEn(TestEn), .SerialEn(SerialEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[268]), .DataIn(ICacheSize[0]), .DataOut(iICacheSize[0]), .SO(ScanChain[269]));
  CapUpdCell uscan269 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[269]), .DataIn(iETMBIGEND), .DataOut(ETMBIGEND), .SO(ScanChain[270]));
  CapUpdCell uscan270 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[270]), .DataIn(iETMHIVECS), .DataOut(ETMHIVECS), .SO(ScanChain[271]));
  CapUpdCell uscan271 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[271]), .DataIn(iETMnWAIT), .DataOut(ETMnWAIT), .SO(ScanChain[272]));
  CapUpdCell uscan272 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[272]), .DataIn(iETMIA[31]), .DataOut(ETMIA[31]), .SO(ScanChain[273]));
  CapUpdCell uscan273 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[273]), .DataIn(iETMIA[30]), .DataOut(ETMIA[30]), .SO(ScanChain[274]));
  CapUpdCell uscan274 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[274]), .DataIn(iETMIA[29]), .DataOut(ETMIA[29]), .SO(ScanChain[275]));
  CapUpdCell uscan275 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[275]), .DataIn(iETMIA[28]), .DataOut(ETMIA[28]), .SO(ScanChain[276]));
  CapUpdCell uscan276 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[276]), .DataIn(iETMIA[27]), .DataOut(ETMIA[27]), .SO(ScanChain[277]));
  CapUpdCell uscan277 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[277]), .DataIn(iETMIA[26]), .DataOut(ETMIA[26]), .SO(ScanChain[278]));
  CapUpdCell uscan278 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[278]), .DataIn(iETMIA[25]), .DataOut(ETMIA[25]), .SO(ScanChain[279]));
  CapUpdCell uscan279 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[279]), .DataIn(iETMIA[24]), .DataOut(ETMIA[24]), .SO(ScanChain[280]));
  CapUpdCell uscan280 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[280]), .DataIn(iETMIA[23]), .DataOut(ETMIA[23]), .SO(ScanChain[281]));
  CapUpdCell uscan281 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[281]), .DataIn(iETMIA[22]), .DataOut(ETMIA[22]), .SO(ScanChain[282]));
  CapUpdCell uscan282 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[282]), .DataIn(iETMIA[21]), .DataOut(ETMIA[21]), .SO(ScanChain[283]));
  CapUpdCell uscan283 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[283]), .DataIn(iETMIA[20]), .DataOut(ETMIA[20]), .SO(ScanChain[284]));
  CapUpdCell uscan284 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[284]), .DataIn(iETMIA[19]), .DataOut(ETMIA[19]), .SO(ScanChain[285]));
  CapUpdCell uscan285 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[285]), .DataIn(iETMIA[18]), .DataOut(ETMIA[18]), .SO(ScanChain[286]));
  CapUpdCell uscan286 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[286]), .DataIn(iETMIA[17]), .DataOut(ETMIA[17]), .SO(ScanChain[287]));
  CapUpdCell uscan287 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[287]), .DataIn(iETMIA[16]), .DataOut(ETMIA[16]), .SO(ScanChain[288]));
  CapUpdCell uscan288 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[288]), .DataIn(iETMIA[15]), .DataOut(ETMIA[15]), .SO(ScanChain[289]));
  CapUpdCell uscan289 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[289]), .DataIn(iETMIA[14]), .DataOut(ETMIA[14]), .SO(ScanChain[290]));
  CapUpdCell uscan290 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[290]), .DataIn(iETMIA[13]), .DataOut(ETMIA[13]), .SO(ScanChain[291]));
  CapUpdCell uscan291 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[291]), .DataIn(iETMIA[12]), .DataOut(ETMIA[12]), .SO(ScanChain[292]));
  CapUpdCell uscan292 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[292]), .DataIn(iETMIA[11]), .DataOut(ETMIA[11]), .SO(ScanChain[293]));
  CapUpdCell uscan293 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[293]), .DataIn(iETMIA[10]), .DataOut(ETMIA[10]), .SO(ScanChain[294]));
  CapUpdCell uscan294 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[294]), .DataIn(iETMIA[9]), .DataOut(ETMIA[9]), .SO(ScanChain[295]));
  CapUpdCell uscan295 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[295]), .DataIn(iETMIA[8]), .DataOut(ETMIA[8]), .SO(ScanChain[296]));
  CapUpdCell uscan296 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[296]), .DataIn(iETMIA[7]), .DataOut(ETMIA[7]), .SO(ScanChain[297]));
  CapUpdCell uscan297 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[297]), .DataIn(iETMIA[6]), .DataOut(ETMIA[6]), .SO(ScanChain[298]));
  CapUpdCell uscan298 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[298]), .DataIn(iETMIA[5]), .DataOut(ETMIA[5]), .SO(ScanChain[299]));
  CapUpdCell uscan299 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[299]), .DataIn(iETMIA[4]), .DataOut(ETMIA[4]), .SO(ScanChain[300]));
  CapUpdCell uscan300 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[300]), .DataIn(iETMIA[3]), .DataOut(ETMIA[3]), .SO(ScanChain[301]));
  CapUpdCell uscan301 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[301]), .DataIn(iETMIA[2]), .DataOut(ETMIA[2]), .SO(ScanChain[302]));
  CapUpdCell uscan302 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[302]), .DataIn(iETMIA[1]), .DataOut(ETMIA[1]), .SO(ScanChain[303]));
  CapUpdCell uscan303 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[303]), .DataIn(iETMInMREQ), .DataOut(ETMInMREQ), .SO(ScanChain[304]));
  CapUpdCell uscan304 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[304]), .DataIn(iETMISEQ), .DataOut(ETMISEQ), .SO(ScanChain[305]));
  CapUpdCell uscan305 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[305]), .DataIn(iETMITBIT), .DataOut(ETMITBIT), .SO(ScanChain[306]));
  CapUpdCell uscan306 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[306]), .DataIn(iETMIABORT), .DataOut(ETMIABORT), .SO(ScanChain[307]));
  CapUpdCell uscan307 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[307]), .DataIn(iETMID31To25[31]), .DataOut(ETMID31To25[31]), .SO(ScanChain[308]));
  CapUpdCell uscan308 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[308]), .DataIn(iETMID31To25[30]), .DataOut(ETMID31To25[30]), .SO(ScanChain[309]));
  CapUpdCell uscan309 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[309]), .DataIn(iETMID31To25[29]), .DataOut(ETMID31To25[29]), .SO(ScanChain[310]));
  CapUpdCell uscan310 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[310]), .DataIn(iETMID31To25[28]), .DataOut(ETMID31To25[28]), .SO(ScanChain[311]));
  CapUpdCell uscan311 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[311]), .DataIn(iETMID31To25[27]), .DataOut(ETMID31To25[27]), .SO(ScanChain[312]));
  CapUpdCell uscan312 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[312]), .DataIn(iETMID31To25[26]), .DataOut(ETMID31To25[26]), .SO(ScanChain[313]));
  CapUpdCell uscan313 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[313]), .DataIn(iETMID31To25[25]), .DataOut(ETMID31To25[25]), .SO(ScanChain[314]));
  CapUpdCell uscan314 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[314]), .DataIn(iETMID15To11[15]), .DataOut(ETMID15To11[15]), .SO(ScanChain[315]));
  CapUpdCell uscan315 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[315]), .DataIn(iETMID15To11[14]), .DataOut(ETMID15To11[14]), .SO(ScanChain[316]));
  CapUpdCell uscan316 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[316]), .DataIn(iETMID15To11[13]), .DataOut(ETMID15To11[13]), .SO(ScanChain[317]));
  CapUpdCell uscan317 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[317]), .DataIn(iETMID15To11[12]), .DataOut(ETMID15To11[12]), .SO(ScanChain[318]));
  CapUpdCell uscan318 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[318]), .DataIn(iETMID15To11[11]), .DataOut(ETMID15To11[11]), .SO(ScanChain[319]));
  CapUpdCell uscan319 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[319]), .DataIn(iETMDA[31]), .DataOut(ETMDA[31]), .SO(ScanChain[320]));
  CapUpdCell uscan320 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[320]), .DataIn(iETMDA[30]), .DataOut(ETMDA[30]), .SO(ScanChain[321]));
  CapUpdCell uscan321 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[321]), .DataIn(iETMDA[29]), .DataOut(ETMDA[29]), .SO(ScanChain[322]));
  CapUpdCell uscan322 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[322]), .DataIn(iETMDA[28]), .DataOut(ETMDA[28]), .SO(ScanChain[323]));
  CapUpdCell uscan323 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[323]), .DataIn(iETMDA[27]), .DataOut(ETMDA[27]), .SO(ScanChain[324]));
  CapUpdCell uscan324 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[324]), .DataIn(iETMDA[26]), .DataOut(ETMDA[26]), .SO(ScanChain[325]));
  CapUpdCell uscan325 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[325]), .DataIn(iETMDA[25]), .DataOut(ETMDA[25]), .SO(ScanChain[326]));
  CapUpdCell uscan326 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[326]), .DataIn(iETMDA[24]), .DataOut(ETMDA[24]), .SO(ScanChain[327]));
  CapUpdCell uscan327 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[327]), .DataIn(iETMDA[23]), .DataOut(ETMDA[23]), .SO(ScanChain[328]));
  CapUpdCell uscan328 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[328]), .DataIn(iETMDA[22]), .DataOut(ETMDA[22]), .SO(ScanChain[329]));
  CapUpdCell uscan329 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[329]), .DataIn(iETMDA[21]), .DataOut(ETMDA[21]), .SO(ScanChain[330]));
  CapUpdCell uscan330 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[330]), .DataIn(iETMDA[20]), .DataOut(ETMDA[20]), .SO(ScanChain[331]));
  CapUpdCell uscan331 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[331]), .DataIn(iETMDA[19]), .DataOut(ETMDA[19]), .SO(ScanChain[332]));
  CapUpdCell uscan332 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[332]), .DataIn(iETMDA[18]), .DataOut(ETMDA[18]), .SO(ScanChain[333]));
  CapUpdCell uscan333 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[333]), .DataIn(iETMDA[17]), .DataOut(ETMDA[17]), .SO(ScanChain[334]));
  CapUpdCell uscan334 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[334]), .DataIn(iETMDA[16]), .DataOut(ETMDA[16]), .SO(ScanChain[335]));
  CapUpdCell uscan335 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[335]), .DataIn(iETMDA[15]), .DataOut(ETMDA[15]), .SO(ScanChain[336]));
  CapUpdCell uscan336 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[336]), .DataIn(iETMDA[14]), .DataOut(ETMDA[14]), .SO(ScanChain[337]));
  CapUpdCell uscan337 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[337]), .DataIn(iETMDA[13]), .DataOut(ETMDA[13]), .SO(ScanChain[338]));
  CapUpdCell uscan338 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[338]), .DataIn(iETMDA[12]), .DataOut(ETMDA[12]), .SO(ScanChain[339]));
  CapUpdCell uscan339 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[339]), .DataIn(iETMDA[11]), .DataOut(ETMDA[11]), .SO(ScanChain[340]));
  CapUpdCell uscan340 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[340]), .DataIn(iETMDA[10]), .DataOut(ETMDA[10]), .SO(ScanChain[341]));
  CapUpdCell uscan341 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[341]), .DataIn(iETMDA[9]), .DataOut(ETMDA[9]), .SO(ScanChain[342]));
  CapUpdCell uscan342 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[342]), .DataIn(iETMDA[8]), .DataOut(ETMDA[8]), .SO(ScanChain[343]));
  CapUpdCell uscan343 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[343]), .DataIn(iETMDA[7]), .DataOut(ETMDA[7]), .SO(ScanChain[344]));
  CapUpdCell uscan344 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[344]), .DataIn(iETMDA[6]), .DataOut(ETMDA[6]), .SO(ScanChain[345]));
  CapUpdCell uscan345 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[345]), .DataIn(iETMDA[5]), .DataOut(ETMDA[5]), .SO(ScanChain[346]));
  CapUpdCell uscan346 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[346]), .DataIn(iETMDA[4]), .DataOut(ETMDA[4]), .SO(ScanChain[347]));
  CapUpdCell uscan347 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[347]), .DataIn(iETMDA[3]), .DataOut(ETMDA[3]), .SO(ScanChain[348]));
  CapUpdCell uscan348 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[348]), .DataIn(iETMDA[2]), .DataOut(ETMDA[2]), .SO(ScanChain[349]));
  CapUpdCell uscan349 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[349]), .DataIn(iETMDA[1]), .DataOut(ETMDA[1]), .SO(ScanChain[350]));
  CapUpdCell uscan350 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[350]), .DataIn(iETMDA[0]), .DataOut(ETMDA[0]), .SO(ScanChain[351]));
  CapUpdCell uscan351 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[351]), .DataIn(iETMWDATA[31]), .DataOut(ETMWDATA[31]), .SO(ScanChain[352]));
  CapUpdCell uscan352 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[352]), .DataIn(iETMWDATA[30]), .DataOut(ETMWDATA[30]), .SO(ScanChain[353]));
  CapUpdCell uscan353 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[353]), .DataIn(iETMWDATA[29]), .DataOut(ETMWDATA[29]), .SO(ScanChain[354]));
  CapUpdCell uscan354 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[354]), .DataIn(iETMWDATA[28]), .DataOut(ETMWDATA[28]), .SO(ScanChain[355]));
  CapUpdCell uscan355 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[355]), .DataIn(iETMWDATA[27]), .DataOut(ETMWDATA[27]), .SO(ScanChain[356]));
  CapUpdCell uscan356 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[356]), .DataIn(iETMWDATA[26]), .DataOut(ETMWDATA[26]), .SO(ScanChain[357]));
  CapUpdCell uscan357 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[357]), .DataIn(iETMWDATA[25]), .DataOut(ETMWDATA[25]), .SO(ScanChain[358]));
  CapUpdCell uscan358 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[358]), .DataIn(iETMWDATA[24]), .DataOut(ETMWDATA[24]), .SO(ScanChain[359]));
  CapUpdCell uscan359 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[359]), .DataIn(iETMWDATA[23]), .DataOut(ETMWDATA[23]), .SO(ScanChain[360]));
  CapUpdCell uscan360 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[360]), .DataIn(iETMWDATA[22]), .DataOut(ETMWDATA[22]), .SO(ScanChain[361]));
  CapUpdCell uscan361 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[361]), .DataIn(iETMWDATA[21]), .DataOut(ETMWDATA[21]), .SO(ScanChain[362]));
  CapUpdCell uscan362 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[362]), .DataIn(iETMWDATA[20]), .DataOut(ETMWDATA[20]), .SO(ScanChain[363]));
  CapUpdCell uscan363 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[363]), .DataIn(iETMWDATA[19]), .DataOut(ETMWDATA[19]), .SO(ScanChain[364]));
  CapUpdCell uscan364 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[364]), .DataIn(iETMWDATA[18]), .DataOut(ETMWDATA[18]), .SO(ScanChain[365]));
  CapUpdCell uscan365 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[365]), .DataIn(iETMWDATA[17]), .DataOut(ETMWDATA[17]), .SO(ScanChain[366]));
  CapUpdCell uscan366 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[366]), .DataIn(iETMWDATA[16]), .DataOut(ETMWDATA[16]), .SO(ScanChain[367]));
  CapUpdCell uscan367 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[367]), .DataIn(iETMWDATA[15]), .DataOut(ETMWDATA[15]), .SO(ScanChain[368]));
  CapUpdCell uscan368 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[368]), .DataIn(iETMWDATA[14]), .DataOut(ETMWDATA[14]), .SO(ScanChain[369]));
  CapUpdCell uscan369 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[369]), .DataIn(iETMWDATA[13]), .DataOut(ETMWDATA[13]), .SO(ScanChain[370]));
  CapUpdCell uscan370 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[370]), .DataIn(iETMWDATA[12]), .DataOut(ETMWDATA[12]), .SO(ScanChain[371]));
  CapUpdCell uscan371 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[371]), .DataIn(iETMWDATA[11]), .DataOut(ETMWDATA[11]), .SO(ScanChain[372]));
  CapUpdCell uscan372 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[372]), .DataIn(iETMWDATA[10]), .DataOut(ETMWDATA[10]), .SO(ScanChain[373]));
  CapUpdCell uscan373 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[373]), .DataIn(iETMWDATA[9]), .DataOut(ETMWDATA[9]), .SO(ScanChain[374]));
  CapUpdCell uscan374 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[374]), .DataIn(iETMWDATA[8]), .DataOut(ETMWDATA[8]), .SO(ScanChain[375]));
  CapUpdCell uscan375 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[375]), .DataIn(iETMWDATA[7]), .DataOut(ETMWDATA[7]), .SO(ScanChain[376]));
  CapUpdCell uscan376 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[376]), .DataIn(iETMWDATA[6]), .DataOut(ETMWDATA[6]), .SO(ScanChain[377]));
  CapUpdCell uscan377 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[377]), .DataIn(iETMWDATA[5]), .DataOut(ETMWDATA[5]), .SO(ScanChain[378]));
  CapUpdCell uscan378 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[378]), .DataIn(iETMWDATA[4]), .DataOut(ETMWDATA[4]), .SO(ScanChain[379]));
  CapUpdCell uscan379 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[379]), .DataIn(iETMWDATA[3]), .DataOut(ETMWDATA[3]), .SO(ScanChain[380]));
  CapUpdCell uscan380 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[380]), .DataIn(iETMWDATA[2]), .DataOut(ETMWDATA[2]), .SO(ScanChain[381]));
  CapUpdCell uscan381 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[381]), .DataIn(iETMWDATA[1]), .DataOut(ETMWDATA[1]), .SO(ScanChain[382]));
  CapUpdCell uscan382 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[382]), .DataIn(iETMWDATA[0]), .DataOut(ETMWDATA[0]), .SO(ScanChain[383]));
  CapUpdCell uscan383 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[383]), .DataIn(iETMDMAS[1]), .DataOut(ETMDMAS[1]), .SO(ScanChain[384]));
  CapUpdCell uscan384 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[384]), .DataIn(iETMDMAS[0]), .DataOut(ETMDMAS[0]), .SO(ScanChain[385]));
  CapUpdCell uscan385 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[385]), .DataIn(iETMDMORE), .DataOut(ETMDMORE), .SO(ScanChain[386]));
  CapUpdCell uscan386 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[386]), .DataIn(iETMDnMREQ), .DataOut(ETMDnMREQ), .SO(ScanChain[387]));
  CapUpdCell uscan387 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[387]), .DataIn(iETMDnRW), .DataOut(ETMDnRW), .SO(ScanChain[388]));
  CapUpdCell uscan388 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[388]), .DataIn(iETMDSEQ), .DataOut(ETMDSEQ), .SO(ScanChain[389]));
  CapUpdCell uscan389 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[389]), .DataIn(iETMRDATA[31]), .DataOut(ETMRDATA[31]), .SO(ScanChain[390]));
  CapUpdCell uscan390 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[390]), .DataIn(iETMRDATA[30]), .DataOut(ETMRDATA[30]), .SO(ScanChain[391]));
  CapUpdCell uscan391 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[391]), .DataIn(iETMRDATA[29]), .DataOut(ETMRDATA[29]), .SO(ScanChain[392]));
  CapUpdCell uscan392 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[392]), .DataIn(iETMRDATA[28]), .DataOut(ETMRDATA[28]), .SO(ScanChain[393]));
  CapUpdCell uscan393 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[393]), .DataIn(iETMRDATA[27]), .DataOut(ETMRDATA[27]), .SO(ScanChain[394]));
  CapUpdCell uscan394 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[394]), .DataIn(iETMRDATA[26]), .DataOut(ETMRDATA[26]), .SO(ScanChain[395]));
  CapUpdCell uscan395 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[395]), .DataIn(iETMRDATA[25]), .DataOut(ETMRDATA[25]), .SO(ScanChain[396]));
  CapUpdCell uscan396 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[396]), .DataIn(iETMRDATA[24]), .DataOut(ETMRDATA[24]), .SO(ScanChain[397]));
  CapUpdCell uscan397 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[397]), .DataIn(iETMRDATA[23]), .DataOut(ETMRDATA[23]), .SO(ScanChain[398]));
  CapUpdCell uscan398 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[398]), .DataIn(iETMRDATA[22]), .DataOut(ETMRDATA[22]), .SO(ScanChain[399]));
  CapUpdCell uscan399 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[399]), .DataIn(iETMRDATA[21]), .DataOut(ETMRDATA[21]), .SO(ScanChain[400]));
  CapUpdCell uscan400 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[400]), .DataIn(iETMRDATA[20]), .DataOut(ETMRDATA[20]), .SO(ScanChain[401]));
  CapUpdCell uscan401 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[401]), .DataIn(iETMRDATA[19]), .DataOut(ETMRDATA[19]), .SO(ScanChain[402]));
  CapUpdCell uscan402 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[402]), .DataIn(iETMRDATA[18]), .DataOut(ETMRDATA[18]), .SO(ScanChain[403]));
  CapUpdCell uscan403 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[403]), .DataIn(iETMRDATA[17]), .DataOut(ETMRDATA[17]), .SO(ScanChain[404]));
  CapUpdCell uscan404 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[404]), .DataIn(iETMRDATA[16]), .DataOut(ETMRDATA[16]), .SO(ScanChain[405]));
  CapUpdCell uscan405 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[405]), .DataIn(iETMRDATA[15]), .DataOut(ETMRDATA[15]), .SO(ScanChain[406]));
  CapUpdCell uscan406 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[406]), .DataIn(iETMRDATA[14]), .DataOut(ETMRDATA[14]), .SO(ScanChain[407]));
  CapUpdCell uscan407 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[407]), .DataIn(iETMRDATA[13]), .DataOut(ETMRDATA[13]), .SO(ScanChain[408]));
  CapUpdCell uscan408 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[408]), .DataIn(iETMRDATA[12]), .DataOut(ETMRDATA[12]), .SO(ScanChain[409]));
  CapUpdCell uscan409 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[409]), .DataIn(iETMRDATA[11]), .DataOut(ETMRDATA[11]), .SO(ScanChain[410]));
  CapUpdCell uscan410 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[410]), .DataIn(iETMRDATA[10]), .DataOut(ETMRDATA[10]), .SO(ScanChain[411]));
  CapUpdCell uscan411 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[411]), .DataIn(iETMRDATA[9]), .DataOut(ETMRDATA[9]), .SO(ScanChain[412]));
  CapUpdCell uscan412 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[412]), .DataIn(iETMRDATA[8]), .DataOut(ETMRDATA[8]), .SO(ScanChain[413]));
  CapUpdCell uscan413 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[413]), .DataIn(iETMRDATA[7]), .DataOut(ETMRDATA[7]), .SO(ScanChain[414]));
  CapUpdCell uscan414 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[414]), .DataIn(iETMRDATA[6]), .DataOut(ETMRDATA[6]), .SO(ScanChain[415]));
  CapUpdCell uscan415 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[415]), .DataIn(iETMRDATA[5]), .DataOut(ETMRDATA[5]), .SO(ScanChain[416]));
  CapUpdCell uscan416 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[416]), .DataIn(iETMRDATA[4]), .DataOut(ETMRDATA[4]), .SO(ScanChain[417]));
  CapUpdCell uscan417 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[417]), .DataIn(iETMRDATA[3]), .DataOut(ETMRDATA[3]), .SO(ScanChain[418]));
  CapUpdCell uscan418 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[418]), .DataIn(iETMRDATA[2]), .DataOut(ETMRDATA[2]), .SO(ScanChain[419]));
  CapUpdCell uscan419 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[419]), .DataIn(iETMRDATA[1]), .DataOut(ETMRDATA[1]), .SO(ScanChain[420]));
  CapUpdCell uscan420 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[420]), .DataIn(iETMRDATA[0]), .DataOut(ETMRDATA[0]), .SO(ScanChain[421]));
  CapUpdCell uscan421 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[421]), .DataIn(iETMDABORT), .DataOut(ETMDABORT), .SO(ScanChain[422]));
  CapUpdCell uscan422 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[422]), .DataIn(iETMCHSD[1]), .DataOut(ETMCHSD[1]), .SO(ScanChain[423]));
  CapUpdCell uscan423 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[423]), .DataIn(iETMCHSD[0]), .DataOut(ETMCHSD[0]), .SO(ScanChain[424]));
  CapUpdCell uscan424 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[424]), .DataIn(iETMCHSE[1]), .DataOut(ETMCHSE[1]), .SO(ScanChain[425]));
  CapUpdCell uscan425 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[425]), .DataIn(iETMCHSE[0]), .DataOut(ETMCHSE[0]), .SO(ScanChain[426]));
  CapUpdCell uscan426 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[426]), .DataIn(iETMLATECANCEL), .DataOut(ETMLATECANCEL), .SO(ScanChain[427]));
  CapUpdCell uscan427 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[427]), .DataIn(iETMPASS), .DataOut(ETMPASS), .SO(ScanChain[428]));
  CapUpdCell uscan428 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[428]), .DataIn(iETMDBGACK), .DataOut(ETMDBGACK), .SO(ScanChain[429]));
  CapUpdCell uscan429 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[429]), .DataIn(iETMINSTREXEC), .DataOut(ETMINSTREXEC), .SO(ScanChain[430]));
  CapUpdCell uscan430 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[430]), .DataIn(iETMINSTRVALID), .DataOut(ETMINSTRVALID), .SO(ScanChain[431]));
  CapUpdCell uscan431 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[431]), .DataIn(iETMRNGOUT[1]), .DataOut(ETMRNGOUT[1]), .SO(ScanChain[432]));
  CapUpdCell uscan432 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[432]), .DataIn(iETMRNGOUT[0]), .DataOut(ETMRNGOUT[0]), .SO(ScanChain[433]));
  CapUpdCellEn uscan433 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[433]), .DataIn(ETMEN), .DataOut(iETMEN), .SO(ScanChain[434]));
  CapUpdCell uscan434 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[434]), .DataIn(TAPID[31]), .DataOut(iTAPID[31]), .SO(ScanChain[435]));
  CapUpdCell uscan435 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[435]), .DataIn(TAPID[30]), .DataOut(iTAPID[30]), .SO(ScanChain[436]));
  CapUpdCell uscan436 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[436]), .DataIn(TAPID[29]), .DataOut(iTAPID[29]), .SO(ScanChain[437]));
  CapUpdCell uscan437 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[437]), .DataIn(TAPID[28]), .DataOut(iTAPID[28]), .SO(ScanChain[438]));
  CapUpdCell uscan438 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[438]), .DataIn(TAPID[27]), .DataOut(iTAPID[27]), .SO(ScanChain[439]));
  CapUpdCell uscan439 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[439]), .DataIn(TAPID[26]), .DataOut(iTAPID[26]), .SO(ScanChain[440]));
  CapUpdCell uscan440 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[440]), .DataIn(TAPID[25]), .DataOut(iTAPID[25]), .SO(ScanChain[441]));
  CapUpdCell uscan441 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[441]), .DataIn(TAPID[24]), .DataOut(iTAPID[24]), .SO(ScanChain[442]));
  CapUpdCell uscan442 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[442]), .DataIn(TAPID[23]), .DataOut(iTAPID[23]), .SO(ScanChain[443]));
  CapUpdCell uscan443 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[443]), .DataIn(TAPID[22]), .DataOut(iTAPID[22]), .SO(ScanChain[444]));
  CapUpdCell uscan444 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[444]), .DataIn(TAPID[21]), .DataOut(iTAPID[21]), .SO(ScanChain[445]));
  CapUpdCell uscan445 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[445]), .DataIn(TAPID[20]), .DataOut(iTAPID[20]), .SO(ScanChain[446]));
  CapUpdCell uscan446 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[446]), .DataIn(TAPID[19]), .DataOut(iTAPID[19]), .SO(ScanChain[447]));
  CapUpdCell uscan447 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[447]), .DataIn(TAPID[18]), .DataOut(iTAPID[18]), .SO(ScanChain[448]));
  CapUpdCell uscan448 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[448]), .DataIn(TAPID[17]), .DataOut(iTAPID[17]), .SO(ScanChain[449]));
  CapUpdCell uscan449 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[449]), .DataIn(TAPID[16]), .DataOut(iTAPID[16]), .SO(ScanChain[450]));
  CapUpdCell uscan450 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[450]), .DataIn(TAPID[15]), .DataOut(iTAPID[15]), .SO(ScanChain[451]));
  CapUpdCell uscan451 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[451]), .DataIn(TAPID[14]), .DataOut(iTAPID[14]), .SO(ScanChain[452]));
  CapUpdCell uscan452 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[452]), .DataIn(TAPID[13]), .DataOut(iTAPID[13]), .SO(ScanChain[453]));
  CapUpdCell uscan453 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[453]), .DataIn(TAPID[12]), .DataOut(iTAPID[12]), .SO(ScanChain[454]));
  CapUpdCell uscan454 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[454]), .DataIn(TAPID[11]), .DataOut(iTAPID[11]), .SO(ScanChain[455]));
  CapUpdCell uscan455 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[455]), .DataIn(TAPID[10]), .DataOut(iTAPID[10]), .SO(ScanChain[456]));
  CapUpdCell uscan456 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[456]), .DataIn(TAPID[9]), .DataOut(iTAPID[9]), .SO(ScanChain[457]));
  CapUpdCell uscan457 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[457]), .DataIn(TAPID[8]), .DataOut(iTAPID[8]), .SO(ScanChain[458]));
  CapUpdCell uscan458 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[458]), .DataIn(TAPID[7]), .DataOut(iTAPID[7]), .SO(ScanChain[459]));
  CapUpdCell uscan459 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[459]), .DataIn(TAPID[6]), .DataOut(iTAPID[6]), .SO(ScanChain[460]));
  CapUpdCell uscan460 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[460]), .DataIn(TAPID[5]), .DataOut(iTAPID[5]), .SO(ScanChain[461]));
  CapUpdCell uscan461 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[461]), .DataIn(TAPID[4]), .DataOut(iTAPID[4]), .SO(ScanChain[462]));
  CapUpdCell uscan462 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[462]), .DataIn(TAPID[3]), .DataOut(iTAPID[3]), .SO(ScanChain[463]));
  CapUpdCell uscan463 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[463]), .DataIn(TAPID[2]), .DataOut(iTAPID[2]), .SO(ScanChain[464]));
  CapUpdCell uscan464 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[464]), .DataIn(TAPID[1]), .DataOut(iTAPID[1]), .SO(ScanChain[465]));
  CapUpdCell uscan465 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[465]), .DataIn(TAPID[0]), .DataOut(iTAPID[0]), .SO(ScanChain[466]));
  CapUpdCell uscan466 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[466]), .DataIn(iETMPROCID[0]), .DataOut(ETMPROCID[0]), .SO(ScanChain[467]));
  CapUpdCell uscan467 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[467]), .DataIn(iETMPROCID[1]), .DataOut(ETMPROCID[1]), .SO(ScanChain[468]));
  CapUpdCell uscan468 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[468]), .DataIn(iETMPROCID[2]), .DataOut(ETMPROCID[2]), .SO(ScanChain[469]));
  CapUpdCell uscan469 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[469]), .DataIn(iETMPROCID[3]), .DataOut(ETMPROCID[3]), .SO(ScanChain[470]));
  CapUpdCell uscan470 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[470]), .DataIn(iETMPROCID[4]), .DataOut(ETMPROCID[4]), .SO(ScanChain[471]));
  CapUpdCell uscan471 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[471]), .DataIn(iETMPROCID[5]), .DataOut(ETMPROCID[5]), .SO(ScanChain[472]));
  CapUpdCell uscan472 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[472]), .DataIn(iETMPROCID[6]), .DataOut(ETMPROCID[6]), .SO(ScanChain[473]));
  CapUpdCell uscan473 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[473]), .DataIn(iETMPROCID[7]), .DataOut(ETMPROCID[7]), .SO(ScanChain[474]));
  CapUpdCell uscan474 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[474]), .DataIn(iETMPROCID[8]), .DataOut(ETMPROCID[8]), .SO(ScanChain[475]));
  CapUpdCell uscan475 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[475]), .DataIn(iETMPROCID[9]), .DataOut(ETMPROCID[9]), .SO(ScanChain[476]));
  CapUpdCell uscan476 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[476]), .DataIn(iETMPROCID[10]), .DataOut(ETMPROCID[10]), .SO(ScanChain[477]));
  CapUpdCell uscan477 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[477]), .DataIn(iETMPROCID[11]), .DataOut(ETMPROCID[11]), .SO(ScanChain[478]));
  CapUpdCell uscan478 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[478]), .DataIn(iETMPROCID[12]), .DataOut(ETMPROCID[12]), .SO(ScanChain[479]));
  CapUpdCell uscan479 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[479]), .DataIn(iETMPROCID[13]), .DataOut(ETMPROCID[13]), .SO(ScanChain[480]));
  CapUpdCell uscan480 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[480]), .DataIn(iETMPROCID[14]), .DataOut(ETMPROCID[14]), .SO(ScanChain[481]));
  CapUpdCell uscan481 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[481]), .DataIn(iETMPROCID[15]), .DataOut(ETMPROCID[15]), .SO(ScanChain[482]));
  CapUpdCell uscan482 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[482]), .DataIn(iETMPROCID[16]), .DataOut(ETMPROCID[16]), .SO(ScanChain[483]));
  CapUpdCell uscan483 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[483]), .DataIn(iETMPROCID[17]), .DataOut(ETMPROCID[17]), .SO(ScanChain[484]));
  CapUpdCell uscan484 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[484]), .DataIn(iETMPROCID[18]), .DataOut(ETMPROCID[18]), .SO(ScanChain[485]));
  CapUpdCell uscan485 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[485]), .DataIn(iETMPROCID[19]), .DataOut(ETMPROCID[19]), .SO(ScanChain[486]));
  CapUpdCell uscan486 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[486]), .DataIn(iETMPROCID[20]), .DataOut(ETMPROCID[20]), .SO(ScanChain[487]));
  CapUpdCell uscan487 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[487]), .DataIn(iETMPROCID[21]), .DataOut(ETMPROCID[21]), .SO(ScanChain[488]));
  CapUpdCell uscan488 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[488]), .DataIn(iETMPROCID[22]), .DataOut(ETMPROCID[22]), .SO(ScanChain[489]));
  CapUpdCell uscan489 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[489]), .DataIn(iETMPROCID[23]), .DataOut(ETMPROCID[23]), .SO(ScanChain[490]));
  CapUpdCell uscan490 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[490]), .DataIn(iETMPROCID[24]), .DataOut(ETMPROCID[24]), .SO(ScanChain[491]));
  CapUpdCell uscan491 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[491]), .DataIn(iETMPROCID[25]), .DataOut(ETMPROCID[25]), .SO(ScanChain[492]));
  CapUpdCell uscan492 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[492]), .DataIn(iETMPROCID[26]), .DataOut(ETMPROCID[26]), .SO(ScanChain[493]));
  CapUpdCell uscan493 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[493]), .DataIn(iETMPROCID[27]), .DataOut(ETMPROCID[27]), .SO(ScanChain[494]));
  CapUpdCell uscan494 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[494]), .DataIn(iETMPROCID[28]), .DataOut(ETMPROCID[28]), .SO(ScanChain[495]));
  CapUpdCell uscan495 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[495]), .DataIn(iETMPROCID[29]), .DataOut(ETMPROCID[29]), .SO(ScanChain[496]));
  CapUpdCell uscan496 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[496]), .DataIn(iETMPROCID[30]), .DataOut(ETMPROCID[30]), .SO(ScanChain[497]));
  CapUpdCell uscan497 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[497]), .DataIn(iETMPROCID[31]), .DataOut(ETMPROCID[31]), .SO(ScanChain[498]));
  CapUpdCell uscan498 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(INnotEXTEST), .CLK(CLK), .SI(ScanChain[498]), .DataIn(iETMPROCIDWR), .DataOut(ETMPROCIDWR), .SO(ScanChain[499]));
  CapUpdCell uscan499 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[499]), .DataIn(INITRAM), .DataOut(iINITRAM), .SO(ScanChain[500]));
  CapUpdCell uscan500 ( .ScanEn(ScanEn), .TestEn(TestEn), .INnotEXTEST(nINnotEXTEST), .CLK(CLK), .SI(ScanChain[500]), .DataIn(ETMFIFOFULL), .DataOut(iETMFIFOFULL), .SO(ScanChain[501]));
  assign ScanChain[0] = SI ;
  assign SO = ScanChain[501] ; 
endmodule 
