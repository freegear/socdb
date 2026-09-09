
module Ssp ( PCLK, PRESETn, PADDR, PSEL, PENABLE, PWRITE, PWDATA, SSPINTR, 
        SSPRXD, SSPFSSIN, SSPCLKIN, SSPFSSOUT, SSPCLKOUT, SSPTXD, nSSPOE, 
        nSSPCTLOE, PRDATA, TxDMAReq, RxDMAReq );
  input [4:2] PADDR;
  input [15:0] PWDATA;
  output [31:0] PRDATA;
  input PCLK, PRESETn, PSEL, PENABLE, PWRITE, SSPRXD, SSPFSSIN, SSPCLKIN;
  output SSPINTR, SSPFSSOUT, SSPCLKOUT, SSPTXD, nSSPOE, nSSPCTLOE, TxDMAReq,
         RxDMAReq;
  wire   SSE, MS, SPO, SPH, SPIPRE_15_, SPIPRE_14_, SPIPRE_13_, SPIPRE_12_,
         SPIPRE_11_, SPIPRE_10_, SPIPRE_9_, SPIHIDDEN_1_, SPIHIDDEN_0_,
         SPIINTDMA_13_, SPIINTDMA_12_, SPIINTDMA_11_, SPIINTDMA_10_,
         SPIINTDMA_9_, SPIINTDMA_4_, TNF, RNE, BSY, RFF, TFE, TXRIS, RXRIS,
         RTINTR, DataStp, RORRIS, TXMIS, RXMIS, RORMIS, RORIC, RTIC,
         SPITXDATWr, RxFRdPtrInc, TxFRdPtrInc, TxRxBSY, TxDataAvlbl, RxFWr,
         RORINTR, INTR, FSSOUT, CLKOUT, TXD, nCTLOE, nOE, IntSSPRXD, SSPCLKDIV,
         NextnSOE, NextSTXD, NextSRxFWr, NxtSTxFRdPtrInc, NextSTxRxBSY, MRxRT,
         IncRxTimeOut, SRxRT;
  wire   [7:0] SCR;
  wire   [3:0] DSS;
  wire   [1:0] FRF;
  wire   [3:0] TxDMALevel;
  wire   [3:0] RxDMALevel;
  wire   [3:0] TxFFillLevel;
  wire   [3:0] RxFFillLevel;
  wire   [15:0] RxFRdData;
  wire   [15:0] TxFRdData;
  wire   [15:0] TxFRdDataIn;
  wire   [15:0] SRxFWrData;
  wire   [15:0] MRxFWrData;
  wire   SYNOPSYS_UNCONNECTED__0;

  SspApbif uSspApbif ( .PCLK(PCLK), .PRESETn(PRESETn), .PSEL(PSEL), .PWRITE(
        PWRITE), .PENABLE(PENABLE), .PADDR(PADDR), .PWDATA(PWDATA), .TNF(TNF), 
        .RNE(RNE), .BSY(BSY), .RFF(RFF), .TFE(TFE), .TXRIS(TXRIS), .RXRIS(
        RXRIS), .RTRISSync(DataStp), .RORRIS(RORRIS), .TXMIS(TXMIS), .RXMIS(
        RXMIS), .RTMISSync(RTINTR), .RORMIS(RORMIS), .TxFFillLevel(
        TxFFillLevel), .RxFFillLevel(RxFFillLevel), .RxFRdData(RxFRdData), 
        .TxFRdData(TxFRdData), .PRDATA(PRDATA), .RORIC(RORIC), .RTIC(RTIC), 
        .SPICON({SSE, MS, SPO, SPH}), .SPIPRE({SPIPRE_15_, SPIPRE_14_, 
        SPIPRE_13_, SPIPRE_12_, SPIPRE_11_, SPIPRE_10_, SPIPRE_9_, 
        SYNOPSYS_UNCONNECTED__0, SCR}), .SPIINTDMA({SPIINTDMA_13_, 
        SPIINTDMA_12_, SPIINTDMA_11_, SPIINTDMA_10_, SPIINTDMA_9_, TxDMALevel, 
        SPIINTDMA_4_, RxDMALevel}), .SPIHIDDEN({DSS, FRF, SPIHIDDEN_1_, 
        SPIHIDDEN_0_}), .SPITXDATWr(SPITXDATWr), .RxFRdPtrInc(RxFRdPtrInc) );
  SspTxFIFO uSspTxFIFO ( .PCLK(PCLK), .PRESETn(PRESETn), .MS(MS), .SSPDRWr(
        SPITXDATWr), .TxFRdPtrIncSync(TxFRdPtrInc), .TxRxBSYSync(TxRxBSY), 
        .TXIM(SPIINTDMA_13_), .FRFPCLK(FRF), .DSSPCLK(DSS), .PWDATAIn(PWDATA), 
        .TxDMALevel(TxDMALevel), .TNF(TNF), .TFE(TFE), .BSY(BSY), .TXRIS(TXRIS), .TXMIS(TXMIS), .TxDataAvlbl(TxDataAvlbl), .TxFRdData(TxFRdData), 
        .TxFRdDataIn(TxFRdDataIn), .TxFFillLevel(TxFFillLevel) );
  SspRxFIFO uSspRxFIFO ( .PCLK(PCLK), .PRESETn(PRESETn), .RXIM(SPIINTDMA_12_), 
        .RORIM(SPIINTDMA_10_), .RORIC(RORIC), .RxFWrSync(RxFWr), .RxFRdPtrInc(
        RxFRdPtrInc), .MS(MS), .SRxFWrData(SRxFWrData), .MRxFWrData(MRxFWrData), .RxDMALevel(RxDMALevel), .RNE(RNE), .RFF(RFF), .RXRIS(RXRIS), .RORRIS(RORRIS), .RXMIS(RXMIS), .RORMIS(RORMIS), .RxFRdData(RxFRdData), .RxFFillLevel(
        RxFFillLevel) );
  SspIntGen uSspIntGen ( .TXMIS(TXMIS), .RXMIS(RXMIS), .RORMIS(RORMIS), 
        .DataStp(DataStp), .RTIMSync(SPIINTDMA_11_), .RORIC(RORIC), .RTIC(RTIC), .RORINTR(RORINTR), .RTINTR(RTINTR), .INTR(INTR) );
  SspTest uSspTest ( .PCLK(PCLK), .PRESETn(PRESETn), .LBM(SPIHIDDEN_0_), 
        .SSPRXD(SSPRXD), .TXMIS(TXMIS), .RXMIS(RXMIS), .RORINTR(RORINTR), 
        .RTINTR(RTINTR), .INTR(INTR), .FSSOUT(FSSOUT), .CLKOUT(CLKOUT), .TXD(
        TXD), .nCTLOE(nCTLOE), .nOE(nOE), .IntSSPRXD(IntSSPRXD), .IntSSPINTR(
        SSPINTR), .IntSSPFSSOUT(SSPFSSOUT), .IntSSPCLKOUT(SSPCLKOUT), 
        .IntSSPTXD(SSPTXD), .IntnSSPCTLOE(nSSPCTLOE), .IntnSSPOE(nSSPOE) );
  SspScaleCntr uSspScaleCntr ( .PCLK(PCLK), .PRESETn(PRESETn), .SSESync(SSE), 
        .SSPCPSR({SPIPRE_15_, SPIPRE_14_, SPIPRE_13_, SPIPRE_12_, SPIPRE_11_, 
        SPIPRE_10_, SPIPRE_9_}), .SSPCLKDIV(SSPCLKDIV) );
  SspMTxRxCntl uSspMTxRxCntl ( .PCLK(PCLK), .PRESETn(PRESETn), .DSS(DSS), 
        .FRF(FRF), .SCR(SCR), .SPO(SPO), .SPH(SPH), .SSESync(SSE), .SSPCLKDIV(
        SSPCLKDIV), .TxDataAvlbl(TxDataAvlbl), .TxFRdDataIn(TxFRdDataIn), 
        .IntSSPRXD(IntSSPRXD), .MSSync(MS), .NextnSOE(NextnSOE), .NextSTXD(
        NextSTXD), .NextSRxFWr(NextSRxFWr), .NxtSTxFRdPtrInc(NxtSTxFRdPtrInc), 
        .NextSTxRxBSY(NextSTxRxBSY), .RNESync(RNE), .CLKOUT(CLKOUT), .FSSOUT(
        FSSOUT), .TXD(TXD), .nCTLOE(nCTLOE), .nOE(nOE), .TxFRdPtrInc(
        TxFRdPtrInc), .RxFWr(RxFWr), .MRxFWrData(MRxFWrData), .TxRxBSY(TxRxBSY), .MRxRT(MRxRT), .IncRxTimeOut(IncRxTimeOut) );
  SspSTxRxCntl uSspSTxRxCntl ( .PCLK(PCLK), .PRESETn(PRESETn), .TXD(TXD), 
        .nOE(nOE), .DSS(DSS), .FRF(FRF), .SCR(SCR), .SPO(SPO), .SPH(SPH), 
        .SSPCLKDIV(SSPCLKDIV), .CLKINSync(SSPCLKIN), .FSSINSync(SSPFSSIN), 
        .SSESync(SSE), .MSSync(MS), .SODSync(SPIHIDDEN_1_), .TxFRdDataIn(
        TxFRdDataIn), .TxFRdPtrInc(TxFRdPtrInc), .RxFWr(RxFWr), .TxRxBSY(
        TxRxBSY), .IntSSPRXD(IntSSPRXD), .NxtSTxFRdPtrInc(NxtSTxFRdPtrInc), 
        .NextSTxRxBSY(NextSTxRxBSY), .NextSRxFWr(NextSRxFWr), .NextnSOE(
        NextnSOE), .NextSTXD(NextSTXD), .SRxFWrData(SRxFWrData), .SRxRT(SRxRT)
         );
  SspDataStp uSspDataStp ( .PCLK(PCLK), .PRESETn(PRESETn), .IncRxTimeOut(
        IncRxTimeOut), .MRxRT(MRxRT), .SRxRT(SRxRT), .RNESync(RNE), .RTICSync(
        RTIC), .DataStp(DataStp) );
  SspNewDMA uSspNewDMA ( .TxFFillLevel(TxFFillLevel), .RxFFillLevel(
        RxFFillLevel), .TxDMALevel(TxDMALevel), .RxDMALevel(RxDMALevel), 
        .TxDMAReqEn(SPIINTDMA_9_), .RxDMAReqEn(SPIINTDMA_4_), .TxDMAReq(
        TxDMAReq), .RxDMAReq(RxDMAReq) );
endmodule


module SspNewDMA ( TxFFillLevel, RxFFillLevel, TxDMALevel, RxDMALevel, 
        TxDMAReqEn, RxDMAReqEn, TxDMAReq, RxDMAReq );
  input [3:0] TxFFillLevel;
  input [3:0] RxFFillLevel;
  input [3:0] TxDMALevel;
  input [3:0] RxDMALevel;
  input TxDMAReqEn, RxDMAReqEn;
  output TxDMAReq, RxDMAReq;
  wire   n145, n146, n147, n148, n149, n150, n151, n152, n153, n154, n155,
         n156, n157, n158, n159, n161, n162, n163, n164, n165, n166, n167,
         n168, n169, n170, n171, n172, n173;

  INVX1 U99 ( .A(n159), .Y(n156) );
  NAND2BX1 U100 ( .AN(TxFFillLevel[1]), .B(n158), .Y(n159) );
  XOR2X1 U101 ( .A(n159), .B(TxFFillLevel[2]), .Y(n149) );
  OR2X1 U102 ( .A(n153), .B(n152), .Y(n151) );
  OAI31X1 U103 ( .A0(n159), .A1(TxFFillLevel[3]), .A2(TxFFillLevel[2]), .B0(
        n161), .Y(n152) );
  OA22X1 U104 ( .A0(n162), .A1(n163), .B0(n156), .B1(n163), .Y(n161) );
  INVX1 U105 ( .A(TxFFillLevel[2]), .Y(n162) );
  INVX1 U106 ( .A(TxFFillLevel[3]), .Y(n163) );
  INVX1 U107 ( .A(RxFFillLevel[3]), .Y(n168) );
  INVX1 U108 ( .A(TxFFillLevel[0]), .Y(n158) );
  INVX1 U109 ( .A(RxFFillLevel[2]), .Y(n167) );
  NAND2BX1 U110 ( .AN(RxFFillLevel[3]), .B(RxDMALevel[3]), .Y(n172) );
  NOR2BX1 U111 ( .AN(TxDMAReqEn), .B(n145), .Y(TxDMAReq) );
  OA21X2 U112 ( .A0(n146), .A1(n147), .B0(n148), .Y(n145) );
  INVX1 U113 ( .A(n151), .Y(n146) );
  AOI32X1 U114 ( .A0(n149), .A1(n150), .A2(n151), .B0(n152), .B1(n153), .Y(
        n148) );
  OA21X2 U115 ( .A0(n164), .A1(n165), .B0(RxDMAReqEn), .Y(RxDMAReq) );
  AOI211X1 U116 ( .A0(n169), .A1(n170), .B0(n171), .C0(n166), .Y(n164) );
  OAI32X1 U117 ( .A0(n166), .A1(RxDMALevel[2]), .A2(n167), .B0(RxDMALevel[3]), 
        .B1(n168), .Y(n165) );
  INVX1 U118 ( .A(n172), .Y(n166) );
  NAND2BX1 U119 ( .AN(RxDMALevel[1]), .B(RxFFillLevel[1]), .Y(n170) );
  NOR2BX1 U120 ( .AN(RxDMALevel[0]), .B(RxFFillLevel[0]), .Y(n169) );
  INVX1 U121 ( .A(TxDMALevel[3]), .Y(n153) );
  AO22X1 U122 ( .A0(RxDMALevel[1]), .A1(n173), .B0(RxDMALevel[2]), .B1(n167), 
        .Y(n171) );
  INVX1 U123 ( .A(RxFFillLevel[1]), .Y(n173) );
  OAI211X1 U124 ( .A0(n149), .A1(n150), .B0(n154), .C0(n155), .Y(n147) );
  OAI211X1 U125 ( .A0(TxDMALevel[1]), .A1(n157), .B0(TxDMALevel[0]), .C0(n158), 
        .Y(n154) );
  AOI32X1 U126 ( .A0(TxFFillLevel[1]), .A1(TxDMALevel[1]), .A2(TxFFillLevel[0]), .B0(TxDMALevel[1]), .B1(n156), .Y(n155) );
  INVX1 U127 ( .A(TxFFillLevel[1]), .Y(n157) );
  INVX1 U128 ( .A(TxDMALevel[2]), .Y(n150) );
endmodule


module SspDataStp ( PCLK, PRESETn, IncRxTimeOut, MRxRT, SRxRT, RNESync, 
        RTICSync, DataStp );
  input PCLK, PRESETn, IncRxTimeOut, MRxRT, SRxRT, RNESync, RTICSync;
  output DataStp;
  wire   SspDataStpState_0_, NextWDCount221_5_, NextWDCount221_4_,
         NextWDCount221_3_, NextWDCount221_2_, NextWDCount221_1_, n317, n347,
         n348, n349, n350, n351, n352, n353, n354, carry_5_, carry_4_,
         carry_3_, carry_2_, n355, n358, n359, n361, n362, n363, n364, n365,
         n366, n367, n368, n369, n370, n371, n372, n373, n375, n377, n378,
         n379, n380, n384, n385, n386, n387, n388, n389, n390, n391;
  wire   [5:0] WDCount;

  INVX1 U180 ( .A(n368), .Y(n359) );
  INVX1 U181 ( .A(n373), .Y(n365) );
  NAND2BX1 U182 ( .AN(n359), .B(n363), .Y(n373) );
  OAI31X1 U183 ( .A0(n355), .A1(n386), .A2(n388), .B0(n358), .Y(n354) );
  AOI21X1 U184 ( .A0(n377), .A1(n388), .B0(n378), .Y(n391) );
  NAND3BX1 U185 ( .AN(n361), .B(IncRxTimeOut), .C(n362), .Y(n358) );
  INVX1 U186 ( .A(n364), .Y(n361) );
  INVX1 U187 ( .A(n363), .Y(n362) );
  OAI221X1 U188 ( .A0(n375), .A1(n386), .B0(SspDataStpState_0_), .B1(n364), 
        .C0(n391), .Y(n368) );
  INVX1 U189 ( .A(n355), .Y(n375) );
  NAND2BX1 U190 ( .AN(SspDataStpState_0_), .B(n391), .Y(n363) );
  OAI31X1 U191 ( .A0(n379), .A1(WDCount[0]), .A2(n380), .B0(IncRxTimeOut), .Y(
        n364) );
  NAND3BX1 U192 ( .AN(WDCount[5]), .B(n387), .C(n390), .Y(n379) );
  NAND2BX1 U193 ( .AN(WDCount[2]), .B(n389), .Y(n380) );
  OR2X1 U194 ( .A(MRxRT), .B(SRxRT), .Y(n377) );
  NAND2BX1 U195 ( .AN(n365), .B(n366), .Y(n352) );
  XOR2X1 U196 ( .A(WDCount[0]), .B(n359), .Y(n366) );
  INVX1 U197 ( .A(RNESync), .Y(n378) );
  AO21X1 U198 ( .A0(WDCount[5]), .A1(n359), .B0(n372), .Y(n347) );
  AO21X1 U199 ( .A0(NextWDCount221_5_), .A1(n368), .B0(n365), .Y(n372) );
  XNOR2X1 U1_A_5 ( .A(WDCount[5]), .B(carry_5_), .Y(NextWDCount221_5_) );
  OR2X1 U1_B_4 ( .A(WDCount[4]), .B(carry_4_), .Y(carry_5_) );
  AO21X1 U200 ( .A0(WDCount[4]), .A1(n359), .B0(n371), .Y(n348) );
  AO21X1 U201 ( .A0(NextWDCount221_4_), .A1(n368), .B0(n365), .Y(n371) );
  XNOR2X1 U1_A_4 ( .A(WDCount[4]), .B(carry_4_), .Y(NextWDCount221_4_) );
  AO21X1 U202 ( .A0(WDCount[3]), .A1(n359), .B0(n370), .Y(n349) );
  AO21X1 U203 ( .A0(NextWDCount221_3_), .A1(n368), .B0(n365), .Y(n370) );
  XNOR2X1 U1_A_3 ( .A(WDCount[3]), .B(carry_3_), .Y(NextWDCount221_3_) );
  AO21X1 U204 ( .A0(WDCount[2]), .A1(n359), .B0(n369), .Y(n350) );
  AO21X1 U205 ( .A0(NextWDCount221_2_), .A1(n368), .B0(n365), .Y(n369) );
  XNOR2X1 U1_A_2 ( .A(WDCount[2]), .B(carry_2_), .Y(NextWDCount221_2_) );
  AO21X1 U206 ( .A0(WDCount[1]), .A1(n359), .B0(n367), .Y(n351) );
  AO21X1 U207 ( .A0(NextWDCount221_1_), .A1(n368), .B0(n365), .Y(n367) );
  XNOR2X1 U1_A_1 ( .A(WDCount[1]), .B(WDCount[0]), .Y(NextWDCount221_1_) );
  OAI2BB1X1 U208 ( .A0N(n359), .A1N(SspDataStpState_0_), .B0(n358), .Y(n353)
         );
  NAND2BX1 U209 ( .AN(n384), .B(n385), .Y(n355) );
  AO21X1 U210 ( .A0(RTICSync), .A1(n317), .B0(n378), .Y(n384) );
  INVX1 U211 ( .A(n377), .Y(n385) );
  OR2X1 U1_B_1 ( .A(WDCount[1]), .B(WDCount[0]), .Y(carry_2_) );
  OR2X1 U1_B_3 ( .A(WDCount[3]), .B(carry_3_), .Y(carry_4_) );
  OR2X1 U1_B_2 ( .A(WDCount[2]), .B(carry_2_), .Y(carry_3_) );
  DFFRX1 DataStp_reg ( .D(n354), .CK(PCLK), .RN(PRESETn), .Q(DataStp), .QN(
        n388) );
  DFFSX1 WDCount_reg_4_ ( .D(n348), .CK(PCLK), .SN(PRESETn), .Q(WDCount[4]), 
        .QN(n387) );
  DFFSX1 WDCount_reg_3_ ( .D(n349), .CK(PCLK), .SN(PRESETn), .Q(WDCount[3]), 
        .QN(n390) );
  DFFSX1 WDCount_reg_1_ ( .D(n351), .CK(PCLK), .SN(PRESETn), .Q(WDCount[1]), 
        .QN(n389) );
  DFFSX1 WDCount_reg_0_ ( .D(n352), .CK(PCLK), .SN(PRESETn), .Q(WDCount[0]) );
  DFFSX1 WDCount_reg_2_ ( .D(n350), .CK(PCLK), .SN(PRESETn), .Q(WDCount[2]) );
  DFFSX1 WDCount_reg_5_ ( .D(n347), .CK(PCLK), .SN(PRESETn), .Q(WDCount[5]) );
  DFFRX1 SspDataStpState_reg_0_ ( .D(n353), .CK(PCLK), .RN(PRESETn), .Q(
        SspDataStpState_0_), .QN(n386) );
  DFFRX1 delRTICSync_reg ( .D(RTICSync), .CK(PCLK), .RN(PRESETn), .QN(n317) );
endmodule


module SspSTxRxCntl ( PCLK, PRESETn, TXD, nOE, DSS, FRF, SCR, SPO, SPH, 
        SSPCLKDIV, CLKINSync, FSSINSync, SSESync, MSSync, SODSync, TxFRdDataIn, 
        TxFRdPtrInc, RxFWr, TxRxBSY, IntSSPRXD, NxtSTxFRdPtrInc, NextSTxRxBSY, 
        NextSRxFWr, NextnSOE, NextSTXD, SRxFWrData, SRxRT );
  input [3:0] DSS;
  input [1:0] FRF;
  input [7:0] SCR;
  input [15:0] TxFRdDataIn;
  output [15:0] SRxFWrData;
  input PCLK, PRESETn, TXD, nOE, SPO, SPH, SSPCLKDIV, CLKINSync, FSSINSync,
         SSESync, MSSync, SODSync, TxFRdPtrInc, RxFWr, TxRxBSY, IntSSPRXD;
  output NxtSTxFRdPtrInc, NextSTxRxBSY, NextSRxFWr, NextnSOE, NextSTXD, SRxRT;
  wire   DelCLKINSync, IntSOD, NextBitPeriodCnt1450_7_,
         NextBitPeriodCnt1450_6_, NextBitPeriodCnt1450_5_,
         NextBitPeriodCnt1450_4_, NextBitPeriodCnt1450_3_,
         NextBitPeriodCnt1450_2_, NextBitPeriodCnt1450_1_, n2452, n2453, n2454,
         n2455, n2456, n2457, n2458, n2459, n2460, n2461, n2462, n2463, n2464,
         n2465, n2466, n2467, n2468, n2469, n2470, n2471, n2472, n2473, n2474,
         n2475, n2476, n2477, n2478, n2479, n2480, n2481, n2482, n2483, n2484,
         n2485, n2486, n2487, n2488, n2489, n2490, n2491, n2492, n2493, n2494,
         n2495, n2496, n2497, n2498, n2499, n2500, n2501, n2502, n2503, n2504,
         n2505, n2506, n2507, n2508, n2509, n2510, n2511, n2512, n2513, n2514,
         n2515, carry_7_, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_,
         n2531, n2532, n2533, n2534, n2535, n2536, n2537, n2538, n2540, n2541,
         n2542, n2543, n2544, n2545, n2546, n2547, n2548, n2549, n2550, n2551,
         n2552, n2553, n2554, n2555, n2556, n2557, n2558, n2559, n2560, n2561,
         n2562, n2563, n2564, n2565, n2566, n2567, n2568, n2569, n2570, n2571,
         n2572, n2573, n2574, n2575, n2576, n2577, n2578, n2579, n2580, n2581,
         n2582, n2583, n2584, n2585, n2586, n2587, n2590, n2591, n2592, n2593,
         n2595, n2596, n2597, n2598, n2599, n2600, n2601, n2602, n2603, n2604,
         n2606, n2607, n2608, n2609, n2611, n2613, n2614, n2615, n2616, n2620,
         n2621, n2622, n2623, n2624, n2625, n2626, n2627, n2628, n2629, n2630,
         n2631, n2632, n2633, n2634, n2635, n2636, n2637, n2638, n2639, n2641,
         n2642, n2643, n2645, n2646, n2647, n2648, n2649, n2650, n2651, n2652,
         n2653, n2654, n2655, n2656, n2657, n2658, n2659, n2660, n2661, n2662,
         n2663, n2664, n2665, n2666, n2667, n2668, n2669, n2670, n2671, n2672,
         n2673, n2674, n2675, n2676, n2677, n2678, n2679, n2680, n2681, n2682,
         n2683, n2684, n2685, n2686, n2687, n2688, n2689, n2690, n2691, n2692,
         n2693, n2694, n2695, n2696, n2697, n2698, n2699, n2700, n2701, n2702,
         n2703, n2704, n2705, n2706, n2707, n2708, n2709, n2710, n2711, n2712,
         n2713, n2714, n2715, n2716, n2717, n2718, n2719, n2720, n2721, n2722,
         n2724, n2725, n2726, n2727, n2728, n2729, n2730, n2731, n2732, n2733,
         n2734, n2735, n2736, n2737, n2738, n2739, n2740, n2741, n2742, n2743,
         n2745, n2746, n2749, n2750, n2751, n2752, n2753, n2754, n2755, n2756,
         n2757, n2758, n2760, n2761, n2762, n2764, n2765, n2766, n2767, n2768,
         n2769, n2770, n2771, n2772, n2773, n2775, n2776, n2777, n2778, n2779,
         n2781, n2782, n2783, n2784, n2785, n2787, n2788, n2789, n2790, n2791,
         n2792, n2793, n2794, n2795, n2796, n2797, n2798, n2799, n2800, n2801,
         n2802, n2804, n2805, n2807, n2810, n2811, n2813, n2814, n2816, n2817,
         n2818, n2819, n2820, n2821, n2822, n2823, n2824, n2825, n2826, n2827,
         n2828, n2829, n2830, n2831, n2832, n2833, n2834, n2835, n2836, n2837,
         n2838, n2840, n2841, n2842, n2843, n2844, n2845, n2846, n2847, n2848,
         n2849, n2850, n2851, n2857, n2858, n2859, n2860, n2861, n2863, n2864,
         n2865, n2866, n2867, n2868, n2869, n2870, n2871, n2872, n2873, n2874,
         n2876, n2877, n2878, n2879, n2880, n2881, n2882, n2883, n2884, n2885,
         n2886, n2887, n2888, n2889, n2890, n2891, n2892, n2893, n2894, n2895,
         n2896, n2897, n2898, n2899, n2900, n2901, n2902, n2903, n2904;
  wire   [7:0] BitPeriodCnt;
  wire   [3:0] BitCnt;
  wire   [4:0] SspSTxRxState;
  wire   [14:0] TxShft;
  wire   [14:0] RxShft;

  AOI21X1 U1910 ( .A0(n2787), .A1(n2545), .B0(n2788), .Y(n2884) );
  AOI21X1 U1911 ( .A0(n2709), .A1(n2900), .B0(n2840), .Y(n2888) );
  AOI21X1 U1912 ( .A0(n2626), .A1(n2724), .B0(FSSINSync), .Y(n2889) );
  INVX1 U1913 ( .A(n2590), .Y(n2567) );
  INVX1 U1914 ( .A(n2559), .Y(n2565) );
  INVX1 U1915 ( .A(n2722), .Y(n2768) );
  INVX1 U1916 ( .A(n2591), .Y(n2568) );
  NAND2BX1 U1917 ( .AN(n2592), .B(n2590), .Y(n2591) );
  INVX1 U1918 ( .A(n2661), .Y(n2807) );
  DFFRX1 SspSTxRxState_reg_1_ ( .D(n2455), .CK(PCLK), .RN(PRESETn), .Q(
        SspSTxRxState[1]), .QN(n2878) );
  DFFRX1 SspSTxRxState_reg_2_ ( .D(n2454), .CK(PCLK), .RN(PRESETn), .Q(
        SspSTxRxState[2]), .QN(n2900) );
  NAND2BX1 U1919 ( .AN(n2775), .B(n2758), .Y(n2559) );
  OR2X1 U1920 ( .A(n2593), .B(n2595), .Y(n2590) );
  NAND2BX1 U1921 ( .AN(n2813), .B(n2724), .Y(n2820) );
  OR2X1 U1922 ( .A(n2696), .B(n2716), .Y(n2722) );
  NAND2BX1 U1923 ( .AN(n2795), .B(n2547), .Y(n2536) );
  NAND2BX1 U1924 ( .AN(n2776), .B(n2713), .Y(n2696) );
  INVX1 U1925 ( .A(n2697), .Y(n2677) );
  INVX1 U1926 ( .A(n2775), .Y(n2675) );
  INVX1 U1927 ( .A(n2711), .Y(n2630) );
  INVX1 U1928 ( .A(n2857), .Y(n2841) );
  NAND2BX1 U1929 ( .AN(n2883), .B(n2620), .Y(n2857) );
  INVX1 U1930 ( .A(n2586), .Y(n2553) );
  INVX1 U1931 ( .A(n2669), .Y(n2547) );
  INVX1 U1932 ( .A(n2734), .Y(n2781) );
  INVX1 U1933 ( .A(n2810), .Y(n2776) );
  INVX1 U1934 ( .A(n2705), .Y(n2813) );
  INVX1 U1935 ( .A(n2699), .Y(n2715) );
  INVX1 U1936 ( .A(n2587), .Y(n2710) );
  INVX1 U1937 ( .A(n2749), .Y(n2662) );
  INVX1 U1938 ( .A(n2598), .Y(n2596) );
  INVX1 U1939 ( .A(n2861), .Y(n2798) );
  INVX1 U1940 ( .A(n2562), .Y(n2561) );
  AO21X1 U1941 ( .A0(n2771), .A1(n2734), .B0(n2662), .Y(n2661) );
  INVX1 U1942 ( .A(n2667), .Y(n2664) );
  BUFX2 U1943 ( .A(n2665), .Y(n2903) );
  OAI2BB2X1 U1944 ( .A0N(n2565), .A1N(n2667), .B0(n2664), .B1(n2666), .Y(n2665) );
  INVX1 U1945 ( .A(n2668), .Y(n2666) );
  NOR2BX1 U1946 ( .AN(n2559), .B(n2689), .Y(n2688) );
  INVX1 U1947 ( .A(n2686), .Y(n2860) );
  INVX1 U1948 ( .A(n2760), .Y(n2693) );
  INVX1 U1949 ( .A(n2790), .Y(n2545) );
  INVX1 U1950 ( .A(n2653), .Y(n2654) );
  INVX1 U1951 ( .A(n2560), .Y(n2656) );
  INVX1 U1952 ( .A(n2614), .Y(n2592) );
  INVX1 U1953 ( .A(n2692), .Y(n2680) );
  NAND3BX1 U1954 ( .AN(n2727), .B(n2728), .C(n2729), .Y(n2697) );
  NAND3BX1 U1955 ( .AN(n2746), .B(n2884), .C(n2898), .Y(n2727) );
  INVX1 U1956 ( .A(n2745), .Y(n2728) );
  AOI211X1 U1957 ( .A0(n2730), .A1(n2731), .B0(n2732), .C0(n2733), .Y(n2729)
         );
  NAND2BX1 U1958 ( .AN(n2887), .B(n2611), .Y(n2686) );
  NAND2BX1 U1959 ( .AN(n2695), .B(n2682), .Y(n2724) );
  NAND3X1 U1960 ( .A(n2691), .B(n2686), .C(n2760), .Y(n2716) );
  NAND2BX1 U1961 ( .AN(n2546), .B(n2841), .Y(n2760) );
  NAND3BX1 U1962 ( .AN(n2630), .B(n2687), .C(n2628), .Y(n2726) );
  NAND3BX1 U1963 ( .AN(n2737), .B(n2559), .C(n2738), .Y(n2719) );
  OR2X1 U1964 ( .A(n2706), .B(n2540), .Y(n2534) );
  NAND2BX1 U1965 ( .AN(n2554), .B(n2631), .Y(n2669) );
  NAND2BX1 U1966 ( .AN(n2736), .B(n2674), .Y(n2790) );
  AO21X1 U1967 ( .A0(n2709), .A1(n2900), .B0(n2785), .Y(n2737) );
  NAND2BX1 U1968 ( .AN(n2714), .B(n2790), .Y(n2861) );
  NAND2BX1 U1969 ( .AN(n2683), .B(n2694), .Y(n2705) );
  OR2X1 U1970 ( .A(n2634), .B(n2637), .Y(n2711) );
  NAND2BX1 U1971 ( .AN(n2902), .B(n2630), .Y(n2795) );
  NAND2BX1 U1972 ( .AN(n2904), .B(n2878), .Y(n2775) );
  NAND2BX1 U1973 ( .AN(n2902), .B(n2697), .Y(n2699) );
  NAND2BX1 U1974 ( .AN(n2663), .B(n2781), .Y(n2540) );
  NAND2BX1 U1975 ( .AN(n2816), .B(n2730), .Y(n2734) );
  NAND2BX1 U1976 ( .AN(n2660), .B(SSPCLKDIV), .Y(n2653) );
  NAND2BX1 U1977 ( .AN(n2634), .B(n2552), .Y(n2810) );
  OAI211X1 U1978 ( .A0(n2556), .A1(n2902), .B0(n2622), .C0(n2623), .Y(n2598)
         );
  INVX1 U1979 ( .A(n2593), .Y(n2623) );
  NAND2BX1 U1980 ( .AN(n2636), .B(n2841), .Y(n2749) );
  NAND2BX1 U1981 ( .AN(n2887), .B(n2899), .Y(n2586) );
  NAND2BX1 U1982 ( .AN(n2634), .B(n2551), .Y(n2587) );
  NAND3BX1 U1983 ( .AN(n2904), .B(n2639), .C(n2620), .Y(n2713) );
  OAI221X1 U1984 ( .A0(n2901), .A1(n2789), .B0(n2560), .B1(n2760), .C0(n2830), 
        .Y(n2593) );
  NOR2BX1 U1985 ( .AN(n2782), .B(n2831), .Y(n2830) );
  INVX1 U1986 ( .A(n2762), .Y(n2831) );
  AO21X1 U1987 ( .A0(n2657), .A1(n2563), .B0(n2874), .Y(n2562) );
  OAI31X1 U1988 ( .A0(n2714), .A1(n2901), .A2(n2790), .B0(n2536), .Y(n2874) );
  AO22X1 U1989 ( .A0(n2787), .A1(n2902), .B0(n2804), .B1(n2669), .Y(n2692) );
  INVX1 U1990 ( .A(n2795), .Y(n2804) );
  OAI31X1 U1991 ( .A0(n2686), .A1(n2750), .A2(n2901), .B0(n2622), .Y(n2595) );
  INVX1 U1992 ( .A(n2789), .Y(n2788) );
  INVX1 U1993 ( .A(n2829), .Y(n2622) );
  OAI33X1 U1994 ( .A0(n2560), .A1(n2674), .A2(n2691), .B0(n2738), .B1(n2663), 
        .B2(n2633), .Y(n2829) );
  INVX1 U1995 ( .A(n2555), .Y(n2541) );
  OAI211X1 U1996 ( .A0(n2556), .A1(n2902), .B0(n2557), .C0(n2558), .Y(n2555)
         );
  AOI31X1 U1997 ( .A0(n2563), .A1(n2564), .A2(n2565), .B0(n2566), .Y(n2557) );
  OA21X2 U1998 ( .A0(n2559), .A1(n2560), .B0(n2561), .Y(n2558) );
  NAND2BX1 U1999 ( .AN(n2736), .B(n2554), .Y(n2633) );
  INVX1 U2000 ( .A(n2554), .Y(n2674) );
  INVX1 U2001 ( .A(n2543), .Y(n2542) );
  NAND2BX1 U2002 ( .AN(n2541), .B(n2544), .Y(n2543) );
  OAI221X1 U2003 ( .A0(n2545), .A1(n2546), .B0(n2547), .B1(n2548), .C0(n2549), 
        .Y(n2544) );
  AOI211X1 U2004 ( .A0(n2550), .A1(n2551), .B0(n2552), .C0(n2553), .Y(n2549)
         );
  NAND2BX1 U2005 ( .AN(n2736), .B(n2776), .Y(n2538) );
  INVX1 U2006 ( .A(n2736), .Y(n2784) );
  INVX1 U2007 ( .A(n2584), .Y(n2570) );
  NAND2BX1 U2008 ( .AN(n2567), .B(n2585), .Y(n2584) );
  AOI32X1 U2009 ( .A0(n2904), .A1(n2586), .A2(n2587), .B0(n2883), .B1(n2880), 
        .Y(n2585) );
  INVX1 U2010 ( .A(n2867), .Y(n2552) );
  INVX1 U2011 ( .A(n2548), .Y(n2620) );
  INVX1 U2012 ( .A(n2628), .Y(n2689) );
  INVX1 U2013 ( .A(n2858), .Y(n2730) );
  INVX1 U2014 ( .A(n2636), .Y(n2551) );
  INVX1 U2015 ( .A(n2546), .Y(n2639) );
  INVX1 U2016 ( .A(n2714), .Y(n2787) );
  OAI222X1 U2017 ( .A0(n2899), .A1(n2887), .B0(n2775), .B1(n2887), .C0(n2904), 
        .C1(n2637), .Y(n2672) );
  INVX1 U2018 ( .A(n2782), .Y(n2566) );
  INVX1 U2019 ( .A(n2601), .Y(n2611) );
  INVX1 U2020 ( .A(n2707), .Y(n2682) );
  INVX1 U2021 ( .A(n2849), .Y(n2694) );
  NAND3BX1 U2022 ( .AN(n2904), .B(n2899), .C(n2620), .Y(n2849) );
  OAI222X1 U2023 ( .A0(n2887), .A1(n2697), .B0(n2677), .B1(n2724), .C0(n2725), 
        .C1(n2699), .Y(n2452) );
  INVX1 U2024 ( .A(n2726), .Y(n2725) );
  AO21X1 U2025 ( .A0(n2715), .A1(n2716), .B0(n2717), .Y(n2454) );
  OAI32X1 U2026 ( .A0(n2677), .A1(n2718), .A2(n2663), .B0(n2900), .B1(n2697), 
        .Y(n2717) );
  INVX1 U2027 ( .A(n2719), .Y(n2718) );
  OAI221X1 U2028 ( .A0(n2749), .A1(n2653), .B0(n2750), .B1(n2686), .C0(n2751), 
        .Y(n2746) );
  OA22X1 U2029 ( .A0(n2676), .A1(n2714), .B0(n2627), .B1(n2711), .Y(n2751) );
  OAI222X1 U2030 ( .A0(n2707), .A1(n2683), .B0(n2734), .B1(n2706), .C0(n2735), 
        .C1(n2736), .Y(n2733) );
  INVX1 U2031 ( .A(n2737), .Y(n2735) );
  OAI31X1 U2032 ( .A0(n2705), .A1(n2540), .A2(n2625), .B0(n2534), .Y(n2779) );
  INVX1 U2033 ( .A(n2634), .Y(n2822) );
  OAI221X1 U2034 ( .A0(n2878), .A1(n2697), .B0(n2698), .B1(n2699), .C0(n2700), 
        .Y(n2455) );
  OA21X2 U2035 ( .A0(n2711), .A1(n2669), .B0(n2712), .Y(n2698) );
  OAI31X1 U2036 ( .A0(n2701), .A1(n2702), .A2(n2657), .B0(n2697), .Y(n2700) );
  AND4X1 U2037 ( .A(n2713), .B(n2686), .C(n2687), .D(n2714), .Y(n2712) );
  AOI211X1 U2038 ( .A0(n2847), .A1(n2848), .B0(n2813), .C0(n2689), .Y(n2846)
         );
  INVX1 U2039 ( .A(n2687), .Y(n2847) );
  INVX1 U2040 ( .A(n2845), .Y(n2785) );
  NAND3BX1 U2041 ( .AN(n2904), .B(n2551), .C(n2620), .Y(n2845) );
  AO21X1 U2042 ( .A0(n2694), .A1(n2704), .B0(n2672), .Y(n2773) );
  INVX1 U2043 ( .A(n2703), .Y(n2741) );
  INVX1 U2044 ( .A(n2631), .Y(n2627) );
  OAI31X1 U2045 ( .A0(n2888), .A1(n2784), .A2(n2663), .B0(n2838), .Y(n2837) );
  NOR2BX1 U2046 ( .AN(n2810), .B(n2771), .Y(n2838) );
  OAI221X1 U2047 ( .A0(n2880), .A1(n2887), .B0(n2656), .B1(n2760), .C0(n2761), 
        .Y(n2755) );
  AOI211X1 U2048 ( .A0(n2627), .A1(n2689), .B0(n2663), .C0(n2878), .Y(n2761)
         );
  INVX1 U2049 ( .A(n2738), .Y(n2840) );
  INVX1 U2050 ( .A(n2877), .Y(n2657) );
  NAND2BX1 U2051 ( .AN(n2554), .B(n2565), .Y(n2877) );
  INVX1 U2052 ( .A(n2825), .Y(n2758) );
  INVX1 U2053 ( .A(n2824), .Y(n2709) );
  AOI31X1 U2054 ( .A0(n2797), .A1(n2554), .A2(n2565), .B0(n2798), .Y(n2793) );
  INVX1 U2055 ( .A(n2564), .Y(n2797) );
  AOI21X1 U2056 ( .A0(n2565), .A1(n2564), .B0(n2657), .Y(n2896) );
  INVX1 U2057 ( .A(n2866), .Y(n2743) );
  OAI221X1 U2058 ( .A0(n2730), .A1(n2691), .B0(n2554), .B1(n2691), .C0(n2713), 
        .Y(n2866) );
  INVX1 U2059 ( .A(n2624), .Y(n2556) );
  OAI221X1 U2060 ( .A0(n2625), .A1(n2626), .B0(n2627), .B1(n2628), .C0(n2629), 
        .Y(n2624) );
  AOI31X1 U2061 ( .A0(n2630), .A1(n2554), .A2(n2631), .B0(n2632), .Y(n2629) );
  OAI31X1 U2062 ( .A0(n2633), .A1(n2634), .A2(n2635), .B0(n2538), .Y(n2632) );
  NAND2BX1 U2063 ( .AN(n2858), .B(n2676), .Y(n2560) );
  NAND2BX1 U2064 ( .AN(n2630), .B(n2714), .Y(n2668) );
  AO22X1 U2065 ( .A0(n2883), .A1(n2900), .B0(n2620), .B1(n2621), .Y(n2614) );
  OAI31X1 U2066 ( .A0(n2669), .A1(n2637), .A2(n2902), .B0(n2670), .Y(n2667) );
  AOI211X1 U2067 ( .A0(n2671), .A1(n2545), .B0(n2672), .C0(n2673), .Y(n2670)
         );
  AND4X1 U2068 ( .A(n2904), .B(n2878), .C(n2639), .D(n2676), .Y(n2671) );
  AND4X1 U2069 ( .A(n2563), .B(n2551), .C(n2674), .D(n2675), .Y(n2673) );
  AOI21X1 U2070 ( .A0(n2552), .A1(n2904), .B0(n2611), .Y(n2897) );
  OAI32X1 U2071 ( .A0(n2641), .A1(n2654), .A2(n2878), .B0(n2641), .B1(n2880), 
        .Y(n2643) );
  INVX1 U2072 ( .A(n2706), .Y(n2771) );
  INVX1 U2073 ( .A(n2876), .Y(n2563) );
  NAND2BX1 U2074 ( .AN(n2663), .B(n2730), .Y(n2876) );
  AOI31X1 U2075 ( .A0(n2824), .A1(n2825), .A2(n2826), .B0(n2663), .Y(n2817) );
  OA22X1 U2076 ( .A0(n2654), .A1(n2706), .B0(n2816), .B1(n2706), .Y(n2826) );
  OAI221X1 U2077 ( .A0(n2554), .A1(n2738), .B0(n2654), .B1(n2749), .C0(n2559), 
        .Y(n2836) );
  AO21X1 U2078 ( .A0(n2689), .A1(n2902), .B0(n2757), .Y(n2756) );
  OAI211X1 U2079 ( .A0(n2904), .A1(n2758), .B0(n2621), .C0(n2894), .Y(n2757)
         );
  OAI211X1 U2080 ( .A0(n2703), .A1(n2704), .B0(n2705), .C0(n2706), .Y(n2702)
         );
  AOI211X1 U2081 ( .A0(n2682), .A1(n2683), .B0(n2684), .C0(n2685), .Y(n2681)
         );
  NAND3BX1 U2082 ( .AN(n2690), .B(n2691), .C(n2626), .Y(n2684) );
  AOI31X1 U2083 ( .A0(n2686), .A1(n2687), .A2(n2688), .B0(n2901), .Y(n2685) );
  INVX1 U2084 ( .A(n2534), .Y(n2690) );
  AOI22X1 U2085 ( .A0(n2693), .A1(n2730), .B0(n2689), .B1(n2631), .Y(n2898) );
  INVX1 U2086 ( .A(n2833), .Y(n2750) );
  INVX1 U2087 ( .A(n2613), .Y(n2600) );
  INVX1 U2088 ( .A(n2740), .Y(n2533) );
  NAND2BX1 U2089 ( .AN(DelCLKINSync), .B(CLKINSync), .Y(n2736) );
  NAND4BX1 U2090 ( .AN(BitCnt[3]), .B(n2881), .C(n2890), .D(n2885), .Y(n2554)
         );
  NAND3BX1 U2091 ( .AN(SspSTxRxState[1]), .B(n2639), .C(n2822), .Y(n2714) );
  NAND3BX1 U2092 ( .AN(n2904), .B(SspSTxRxState[1]), .C(n2553), .Y(n2687) );
  XOR2X1 U2093 ( .A(n2885), .B(DSS[1]), .Y(n2800) );
  NAND3BX1 U2094 ( .AN(n2901), .B(MSSync), .C(n2832), .Y(n2782) );
  INVX1 U2095 ( .A(n2724), .Y(n2832) );
  NAND3BX1 U2096 ( .AN(SspSTxRxState[4]), .B(n2675), .C(n2639), .Y(n2706) );
  NAND3BX1 U2097 ( .AN(SspSTxRxState[4]), .B(n2883), .C(n2552), .Y(n2691) );
  NAND3BX1 U2098 ( .AN(n2883), .B(SspSTxRxState[1]), .C(n2553), .Y(n2628) );
  NAND3BX1 U2099 ( .AN(SspSTxRxState[1]), .B(SspSTxRxState[2]), .C(
        SspSTxRxState[3]), .Y(n2867) );
  NAND4BX1 U2100 ( .AN(n2799), .B(n2800), .C(n2801), .D(n2802), .Y(n2564) );
  XOR2X1 U2101 ( .A(DSS[0]), .B(BitCnt[0]), .Y(n2799) );
  XOR2X1 U2102 ( .A(n2893), .B(DSS[3]), .Y(n2801) );
  XOR2X1 U2103 ( .A(n2881), .B(DSS[2]), .Y(n2802) );
  NAND3BX1 U2104 ( .AN(n2880), .B(SspSTxRxState[2]), .C(SspSTxRxState[1]), .Y(
        n2637) );
  NAND3BX1 U2105 ( .AN(SspSTxRxState[4]), .B(n2899), .C(n2675), .Y(n2707) );
  NAND3BX1 U2106 ( .AN(n2736), .B(SSESync), .C(n2737), .Y(n2762) );
  NAND3BX1 U2107 ( .AN(FRF[0]), .B(FRF[1]), .C(n2741), .Y(n2626) );
  NAND2BX1 U2108 ( .AN(SspSTxRxState[1]), .B(n2710), .Y(n2738) );
  NAND2BX1 U2109 ( .AN(SspSTxRxState[4]), .B(n2904), .Y(n2634) );
  NAND3BX1 U2110 ( .AN(n2687), .B(SPH), .C(n2833), .Y(n2789) );
  NAND3BX1 U2111 ( .AN(SspSTxRxState[1]), .B(n2904), .C(n2899), .Y(n2601) );
  AO22X1 U2112 ( .A0(SPO), .A1(n2863), .B0(n2865), .B1(n2864), .Y(n2631) );
  AO22X1 U2113 ( .A0(n2863), .A1(n2864), .B0(SPO), .B1(n2865), .Y(n2833) );
  NAND2BX1 U2114 ( .AN(SspSTxRxState[2]), .B(SspSTxRxState[3]), .Y(n2546) );
  NAND2BX1 U2115 ( .AN(FRF[0]), .B(n2742), .Y(n2695) );
  NAND2BX1 U2116 ( .AN(SspSTxRxState[3]), .B(SspSTxRxState[2]), .Y(n2636) );
  NAND2BX1 U2117 ( .AN(CLKINSync), .B(DelCLKINSync), .Y(n2858) );
  NAND2BX1 U2118 ( .AN(SspSTxRxState[4]), .B(SspSTxRxState[1]), .Y(n2548) );
  NAND2BX1 U2119 ( .AN(SspSTxRxState[4]), .B(n2611), .Y(n2703) );
  NAND2BX1 U2120 ( .AN(SspSTxRxState[3]), .B(n2841), .Y(n2824) );
  NAND2BX1 U2121 ( .AN(SspSTxRxState[4]), .B(n2551), .Y(n2825) );
  OAI211X1 U2122 ( .A0(n2676), .A1(n2768), .B0(n2769), .C0(n2770), .Y(n2745)
         );
  AOI211X1 U2123 ( .A0(n2726), .A1(n2902), .B0(n2772), .C0(n2773), .Y(n2769)
         );
  OAI31X1 U2124 ( .A0(n2719), .A1(n2771), .A2(n2662), .B0(n2663), .Y(n2770) );
  OAI31X1 U2125 ( .A0(n2706), .A1(FSSINSync), .A2(n2653), .B0(n2538), .Y(n2772) );
  INVX1 U2126 ( .A(MSSync), .Y(n2625) );
  NAND2BX1 U2127 ( .AN(FRF[1]), .B(FRF[0]), .Y(n2683) );
  INVX1 U2128 ( .A(SSESync), .Y(n2663) );
  BUFX2 U2129 ( .A(SspSTxRxState[0]), .Y(n2904) );
  INVX1 U2130 ( .A(FRF[1]), .Y(n2742) );
  AO22X1 U2131 ( .A0(n2784), .A1(n2848), .B0(SPH), .B1(n2730), .Y(n2865) );
  AO22X1 U2132 ( .A0(n2784), .A1(SPH), .B0(n2730), .B1(n2848), .Y(n2863) );
  NAND2BX1 U2133 ( .AN(SspSTxRxState[1]), .B(SspSTxRxState[3]), .Y(n2635) );
  OAI211X1 U2134 ( .A0(n2764), .A1(n2707), .B0(n2765), .C0(n2766), .Y(NextnSOE) );
  INVX1 U2135 ( .A(n2695), .Y(n2764) );
  INVX1 U2136 ( .A(SPH), .Y(n2848) );
  NAND4BX1 U2137 ( .AN(BitPeriodCnt[1]), .B(n2895), .C(n2850), .D(n2851), .Y(
        n2660) );
  NOR2BX1 U2138 ( .AN(n2892), .B(BitPeriodCnt[3]), .Y(n2850) );
  AND4X1 U2139 ( .A(n2882), .B(n2886), .C(n2879), .D(n2891), .Y(n2851) );
  AO21X1 U2140 ( .A0(BitCnt[0]), .A1(n2613), .B0(n2596), .Y(n2602) );
  NOR2BX1 U2141 ( .AN(n2767), .B(n2745), .Y(n2766) );
  AOI211X1 U2142 ( .A0(n2694), .A1(FRF[1]), .B0(n2777), .C0(n2778), .Y(n2767)
         );
  OA21X2 U2143 ( .A0(n2566), .A1(n2779), .B0(SODSync), .Y(n2778) );
  OAI31X1 U2144 ( .A0(n2884), .A1(n2894), .A2(n2902), .B0(n2783), .Y(n2777) );
  AND2X2 U2145 ( .A(n2900), .B(n2880), .Y(n2899) );
  AO21X1 U2146 ( .A0(BitCnt[1]), .A1(n2613), .B0(n2602), .Y(n2607) );
  AO22X1 U2147 ( .A0(TxFRdDataIn[15]), .A1(n2593), .B0(TxShft[14]), .B1(n2595), 
        .Y(n2828) );
  AO21X1 U2148 ( .A0(TxFRdDataIn[14]), .A1(n2568), .B0(n2583), .Y(n2485) );
  AO22X1 U2149 ( .A0(TxShft[14]), .A1(n2567), .B0(TxShft[13]), .B1(n2570), .Y(
        n2583) );
  AO21X1 U2150 ( .A0(TxFRdDataIn[13]), .A1(n2568), .B0(n2582), .Y(n2486) );
  AO22X1 U2151 ( .A0(TxShft[13]), .A1(n2567), .B0(TxShft[12]), .B1(n2570), .Y(
        n2582) );
  AO21X1 U2152 ( .A0(TxFRdDataIn[12]), .A1(n2568), .B0(n2581), .Y(n2487) );
  AO22X1 U2153 ( .A0(TxShft[12]), .A1(n2567), .B0(TxShft[11]), .B1(n2570), .Y(
        n2581) );
  AO21X1 U2154 ( .A0(TxFRdDataIn[11]), .A1(n2568), .B0(n2580), .Y(n2488) );
  AO22X1 U2155 ( .A0(TxShft[11]), .A1(n2567), .B0(TxShft[10]), .B1(n2570), .Y(
        n2580) );
  AO21X1 U2156 ( .A0(TxFRdDataIn[10]), .A1(n2568), .B0(n2579), .Y(n2489) );
  AO22X1 U2157 ( .A0(TxShft[10]), .A1(n2567), .B0(TxShft[9]), .B1(n2570), .Y(
        n2579) );
  AO21X1 U2158 ( .A0(TxFRdDataIn[9]), .A1(n2568), .B0(n2578), .Y(n2490) );
  AO22X1 U2159 ( .A0(TxShft[9]), .A1(n2567), .B0(TxShft[8]), .B1(n2570), .Y(
        n2578) );
  AO21X1 U2160 ( .A0(TxFRdDataIn[8]), .A1(n2568), .B0(n2577), .Y(n2491) );
  AO22X1 U2161 ( .A0(TxShft[8]), .A1(n2567), .B0(TxShft[7]), .B1(n2570), .Y(
        n2577) );
  AO21X1 U2162 ( .A0(TxFRdDataIn[7]), .A1(n2568), .B0(n2576), .Y(n2492) );
  AO22X1 U2163 ( .A0(TxShft[7]), .A1(n2567), .B0(TxShft[6]), .B1(n2570), .Y(
        n2576) );
  AO21X1 U2164 ( .A0(TxFRdDataIn[6]), .A1(n2568), .B0(n2575), .Y(n2493) );
  AO22X1 U2165 ( .A0(TxShft[6]), .A1(n2567), .B0(TxShft[5]), .B1(n2570), .Y(
        n2575) );
  AO21X1 U2166 ( .A0(TxFRdDataIn[5]), .A1(n2568), .B0(n2574), .Y(n2494) );
  AO22X1 U2167 ( .A0(TxShft[5]), .A1(n2567), .B0(TxShft[4]), .B1(n2570), .Y(
        n2574) );
  AO21X1 U2168 ( .A0(TxFRdDataIn[4]), .A1(n2568), .B0(n2573), .Y(n2495) );
  AO22X1 U2169 ( .A0(TxShft[4]), .A1(n2567), .B0(TxShft[3]), .B1(n2570), .Y(
        n2573) );
  AO21X1 U2170 ( .A0(TxFRdDataIn[3]), .A1(n2568), .B0(n2572), .Y(n2496) );
  AO22X1 U2171 ( .A0(TxShft[3]), .A1(n2567), .B0(TxShft[2]), .B1(n2570), .Y(
        n2572) );
  AO21X1 U2172 ( .A0(TxFRdDataIn[2]), .A1(n2568), .B0(n2571), .Y(n2497) );
  AO22X1 U2173 ( .A0(TxShft[2]), .A1(n2567), .B0(TxShft[1]), .B1(n2570), .Y(
        n2571) );
  AO21X1 U2174 ( .A0(TxFRdDataIn[1]), .A1(n2568), .B0(n2569), .Y(n2498) );
  AO22X1 U2175 ( .A0(TxShft[1]), .A1(n2567), .B0(n2570), .B1(TxShft[0]), .Y(
        n2569) );
  AO21X1 U2176 ( .A0(n2562), .A1(n2868), .B0(n2869), .Y(NextSRxFWr) );
  INVX1 U2177 ( .A(SPO), .Y(n2864) );
  AO22X1 U2178 ( .A0(BitCnt[2]), .A1(n2607), .B0(n2608), .B1(n2598), .Y(n2482)
         );
  OAI221X1 U2179 ( .A0(n2592), .A1(n2609), .B0(BitCnt[2]), .B1(n2606), .C0(
        n2897), .Y(n2608) );
  INVX1 U2180 ( .A(DSS[2]), .Y(n2609) );
  AO22X1 U2181 ( .A0(RxShft[14]), .A1(n2541), .B0(RxShft[13]), .B1(n2542), .Y(
        n2500) );
  AO22X1 U2182 ( .A0(RxShft[13]), .A1(n2541), .B0(RxShft[12]), .B1(n2542), .Y(
        n2501) );
  AO22X1 U2183 ( .A0(RxShft[12]), .A1(n2541), .B0(RxShft[11]), .B1(n2542), .Y(
        n2502) );
  AO22X1 U2184 ( .A0(RxShft[11]), .A1(n2541), .B0(RxShft[10]), .B1(n2542), .Y(
        n2503) );
  AO22X1 U2185 ( .A0(RxShft[10]), .A1(n2541), .B0(RxShft[9]), .B1(n2542), .Y(
        n2504) );
  AO22X1 U2186 ( .A0(RxShft[9]), .A1(n2541), .B0(RxShft[8]), .B1(n2542), .Y(
        n2505) );
  AO22X1 U2187 ( .A0(RxShft[8]), .A1(n2541), .B0(RxShft[7]), .B1(n2542), .Y(
        n2506) );
  AO22X1 U2188 ( .A0(RxShft[7]), .A1(n2541), .B0(RxShft[6]), .B1(n2542), .Y(
        n2507) );
  AO22X1 U2189 ( .A0(RxShft[6]), .A1(n2541), .B0(RxShft[5]), .B1(n2542), .Y(
        n2508) );
  AO22X1 U2190 ( .A0(RxShft[5]), .A1(n2541), .B0(RxShft[4]), .B1(n2542), .Y(
        n2509) );
  AO22X1 U2191 ( .A0(RxShft[4]), .A1(n2541), .B0(RxShft[3]), .B1(n2542), .Y(
        n2510) );
  AO22X1 U2192 ( .A0(RxShft[3]), .A1(n2541), .B0(RxShft[2]), .B1(n2542), .Y(
        n2511) );
  AO22X1 U2193 ( .A0(RxShft[2]), .A1(n2541), .B0(RxShft[1]), .B1(n2542), .Y(
        n2512) );
  AO22X1 U2194 ( .A0(RxShft[1]), .A1(n2541), .B0(RxShft[0]), .B1(n2542), .Y(
        n2513) );
  AO22X1 U2195 ( .A0(RxShft[0]), .A1(n2541), .B0(IntSSPRXD), .B1(n2542), .Y(
        n2514) );
  OAI2BB1X1 U2196 ( .A0N(BitCnt[3]), .A1N(n2607), .B0(n2615), .Y(n2481) );
  AOI31X1 U2197 ( .A0(DSS[3]), .A1(n2614), .A2(n2598), .B0(n2616), .Y(n2615)
         );
  OAI33X1 U2198 ( .A0(n2600), .A1(n2893), .A2(n2881), .B0(n2596), .B1(n2554), 
        .B2(n2600), .Y(n2616) );
  OAI221X1 U2199 ( .A0(n2834), .A1(n2902), .B0(n2656), .B1(n2760), .C0(n2835), 
        .Y(n2827) );
  OA21X2 U2200 ( .A0(n2730), .A1(n2743), .B0(n2859), .Y(n2834) );
  AOI211X1 U2201 ( .A0(SSESync), .A1(n2836), .B0(n2805), .C0(n2837), .Y(n2835)
         );
  AOI211X1 U2202 ( .A0(n2750), .A1(n2860), .B0(n2798), .C0(n2630), .Y(n2859)
         );
  AO21X1 U2203 ( .A0(n2677), .A1(SspSTxRxState[0]), .B0(n2678), .Y(n2456) );
  AOI31X1 U2204 ( .A0(n2679), .A1(n2680), .A2(n2681), .B0(n2677), .Y(n2678) );
  AOI221X1 U2205 ( .A0(n2693), .A1(n2901), .B0(n2694), .B1(n2695), .C0(n2696), 
        .Y(n2679) );
  AO21X1 U2206 ( .A0(TXD), .A1(n2827), .B0(n2828), .Y(NextSTXD) );
  OAI211X1 U2207 ( .A0(n2714), .A1(n2699), .B0(n2720), .C0(n2721), .Y(n2453)
         );
  OA22X1 U2208 ( .A0(n2880), .A1(n2697), .B0(n2677), .B1(n2626), .Y(n2720) );
  AOI32X1 U2209 ( .A0(SSESync), .A1(n2662), .A2(n2697), .B0(n2715), .B1(n2722), 
        .Y(n2721) );
  OAI31X1 U2210 ( .A0(n2791), .A1(n2692), .A2(n2792), .B0(nOE), .Y(n2765) );
  OAI211X1 U2211 ( .A0(n2781), .A1(n2559), .B0(n2793), .C0(n2794), .Y(n2792)
         );
  NAND4BX1 U2212 ( .AN(n2805), .B(n2888), .C(n2768), .D(n2807), .Y(n2791) );
  AO21X1 U2213 ( .A0(n2559), .A1(n2795), .B0(n2796), .Y(n2794) );
  OAI211X1 U2214 ( .A0(FSSINSync), .A1(n2559), .B0(n2743), .C0(n2896), .Y(
        n2731) );
  OAI32X1 U2215 ( .A0(n2752), .A1(TxFRdPtrInc), .A2(IntSOD), .B0(n2753), .B1(
        n2754), .Y(NxtSTxFRdPtrInc) );
  INVX1 U2216 ( .A(TxFRdPtrInc), .Y(n2754) );
  OA21X2 U2217 ( .A0(n2898), .A1(n2901), .B0(n2762), .Y(n2752) );
  AOI211X1 U2218 ( .A0(n2737), .A1(n2736), .B0(n2755), .C0(n2756), .Y(n2753)
         );
  OAI211X1 U2219 ( .A0(n2842), .A1(n2901), .B0(n2843), .C0(n2844), .Y(n2805)
         );
  OA22X1 U2220 ( .A0(n2676), .A1(n2724), .B0(n2563), .B1(n2705), .Y(n2844) );
  OA21X2 U2221 ( .A0(n2687), .A1(n2833), .B0(n2846), .Y(n2842) );
  AOI32X1 U2222 ( .A0(SSESync), .A1(n2736), .A2(n2785), .B0(n2820), .B1(n2625), 
        .Y(n2843) );
  OAI211X1 U2223 ( .A0(n2633), .A1(n2738), .B0(n2739), .C0(n2740), .Y(n2732)
         );
  AOI32X1 U2224 ( .A0(FRF[1]), .A1(n2704), .A2(n2682), .B0(n2741), .B1(n2742), 
        .Y(n2739) );
  AOI31X1 U2225 ( .A0(IntSOD), .A1(n2784), .A2(n2785), .B0(n2741), .Y(n2783)
         );
  OAI221X1 U2226 ( .A0(n2781), .A1(n2889), .B0(n2813), .B1(n2889), .C0(n2814), 
        .Y(n2740) );
  NOR2BX1 U2227 ( .AN(MSSync), .B(n2663), .Y(n2814) );
  OAI211X1 U2228 ( .A0(SspSTxRxState[1]), .A1(n2636), .B0(n2637), .C0(n2638), 
        .Y(n2613) );
  AOI222X1 U2229 ( .A0(n2639), .A1(n2878), .B0(SspSTxRxState[3]), .B1(n2883), 
        .C0(SspSTxRxState[4]), .C1(n2904), .Y(n2638) );
  NAND2BX1 U2230 ( .AN(FSSINSync), .B(SSESync), .Y(n2902) );
  NOR2BX1 U2231 ( .AN(n2554), .B(FSSINSync), .Y(n2550) );
  NAND2BX1 U2232 ( .AN(FSSINSync), .B(SSESync), .Y(n2901) );
  OAI32X1 U2233 ( .A0(n2641), .A1(SspSTxRxState[3]), .A2(SspSTxRxState[1]), 
        .B0(n2641), .B1(n2653), .Y(n2645) );
  INVX1 U2234 ( .A(FSSINSync), .Y(n2816) );
  NAND2BX1 U2235 ( .AN(n2730), .B(n2736), .Y(SRxRT) );
  NAND2BX1 U2236 ( .AN(n2883), .B(SspSTxRxState[2]), .Y(n2621) );
  NAND3BX1 U2237 ( .AN(SspSTxRxState[4]), .B(n2867), .C(n2861), .Y(n2873) );
  NAND3BX1 U2238 ( .AN(BitCnt[1]), .B(n2890), .C(n2613), .Y(n2606) );
  INVX1 U2239 ( .A(FRF[0]), .Y(n2704) );
  INVX1 U2240 ( .A(n2537), .Y(n2676) );
  NAND2BX1 U2241 ( .AN(FSSINSync), .B(SSESync), .Y(n2537) );
  INVX1 U2242 ( .A(n2655), .Y(n2641) );
  OAI2BB1X1 U2243 ( .A0N(n2656), .A1N(n2657), .B0(n2658), .Y(n2655) );
  AOI33X1 U2244 ( .A0(n2659), .A1(n2660), .A2(n2661), .B0(n2654), .B1(SSESync), 
        .B2(n2662), .Y(n2658) );
  NOR2BX1 U2245 ( .AN(SSPCLKDIV), .B(n2663), .Y(n2659) );
  OR2X1 U1_B_1 ( .A(BitPeriodCnt[1]), .B(BitPeriodCnt[0]), .Y(carry_2_) );
  OR2X1 U1_B_2 ( .A(BitPeriodCnt[2]), .B(carry_2_), .Y(carry_3_) );
  OR2X1 U1_B_4 ( .A(BitPeriodCnt[4]), .B(carry_4_), .Y(carry_5_) );
  OR2X1 U1_B_5 ( .A(BitPeriodCnt[5]), .B(carry_5_), .Y(carry_6_) );
  OR2X1 U1_B_3 ( .A(BitPeriodCnt[3]), .B(carry_3_), .Y(carry_4_) );
  AO21X1 U2246 ( .A0(BitPeriodCnt[0]), .A1(n2641), .B0(n2642), .Y(n2480) );
  AO22X1 U2247 ( .A0(n2643), .A1(n2895), .B0(SCR[0]), .B1(n2645), .Y(n2642) );
  AO22X1 U2248 ( .A0(BitCnt[1]), .A1(n2602), .B0(n2603), .B1(n2598), .Y(n2483)
         );
  OAI211X1 U2249 ( .A0(n2592), .A1(n2604), .B0(n2897), .C0(n2606), .Y(n2603)
         );
  INVX1 U2250 ( .A(DSS[1]), .Y(n2604) );
  AO22X1 U2251 ( .A0(n2596), .A1(BitCnt[0]), .B0(n2597), .B1(n2598), .Y(n2484)
         );
  OAI221X1 U2252 ( .A0(n2592), .A1(n2599), .B0(BitCnt[0]), .B1(n2600), .C0(
        n2601), .Y(n2597) );
  INVX1 U2253 ( .A(DSS[0]), .Y(n2599) );
  AO22X1 U2254 ( .A0(SRxFWrData[15]), .A1(n2664), .B0(RxShft[14]), .B1(n2903), 
        .Y(n2457) );
  AO22X1 U2255 ( .A0(SRxFWrData[14]), .A1(n2664), .B0(RxShft[13]), .B1(n2903), 
        .Y(n2458) );
  AO22X1 U2256 ( .A0(SRxFWrData[13]), .A1(n2664), .B0(RxShft[12]), .B1(n2903), 
        .Y(n2459) );
  AO22X1 U2257 ( .A0(SRxFWrData[12]), .A1(n2664), .B0(RxShft[11]), .B1(n2903), 
        .Y(n2460) );
  AO22X1 U2258 ( .A0(SRxFWrData[11]), .A1(n2664), .B0(RxShft[10]), .B1(n2903), 
        .Y(n2461) );
  AO22X1 U2259 ( .A0(SRxFWrData[10]), .A1(n2664), .B0(RxShft[9]), .B1(n2903), 
        .Y(n2462) );
  AO22X1 U2260 ( .A0(SRxFWrData[9]), .A1(n2664), .B0(RxShft[8]), .B1(n2903), 
        .Y(n2463) );
  AO22X1 U2261 ( .A0(SRxFWrData[8]), .A1(n2664), .B0(RxShft[7]), .B1(n2903), 
        .Y(n2464) );
  AO22X1 U2262 ( .A0(SRxFWrData[7]), .A1(n2664), .B0(RxShft[6]), .B1(n2903), 
        .Y(n2465) );
  AO22X1 U2263 ( .A0(SRxFWrData[6]), .A1(n2664), .B0(RxShft[5]), .B1(n2903), 
        .Y(n2466) );
  AO22X1 U2264 ( .A0(SRxFWrData[5]), .A1(n2664), .B0(RxShft[4]), .B1(n2903), 
        .Y(n2467) );
  AO22X1 U2265 ( .A0(SRxFWrData[4]), .A1(n2664), .B0(RxShft[3]), .B1(n2903), 
        .Y(n2468) );
  AO22X1 U2266 ( .A0(SRxFWrData[3]), .A1(n2664), .B0(RxShft[2]), .B1(n2903), 
        .Y(n2469) );
  AO22X1 U2267 ( .A0(SRxFWrData[2]), .A1(n2664), .B0(RxShft[1]), .B1(n2903), 
        .Y(n2470) );
  AO22X1 U2268 ( .A0(SRxFWrData[1]), .A1(n2664), .B0(RxShft[0]), .B1(n2903), 
        .Y(n2471) );
  AO22X1 U2269 ( .A0(SRxFWrData[0]), .A1(n2664), .B0(IntSSPRXD), .B1(n2903), 
        .Y(n2472) );
  AO22X1 U2270 ( .A0(TxShft[0]), .A1(n2567), .B0(TxFRdDataIn[0]), .B1(n2568), 
        .Y(n2499) );
  OAI2BB1X1 U2271 ( .A0N(n2822), .A1N(SspSTxRxState[3]), .B0(n2823), .Y(n2821)
         );
  AOI32X1 U2272 ( .A0(n2878), .A1(n2887), .A2(SspSTxRxState[2]), .B0(n2620), 
        .B1(n2639), .Y(n2823) );
  AO21X1 U2273 ( .A0(TxRxBSY), .A1(n2811), .B0(n2533), .Y(NextSTxRxBSY) );
  NAND4BX1 U2274 ( .AN(n2817), .B(n2626), .C(n2818), .D(n2819), .Y(n2811) );
  INVX1 U2275 ( .A(n2820), .Y(n2819) );
  AOI32X1 U2276 ( .A0(n2553), .A1(n2775), .A2(n2676), .B0(n2676), .B1(n2821), 
        .Y(n2818) );
  AO22X1 U2277 ( .A0(SODSync), .A1(n2531), .B0(IntSOD), .B1(n2532), .Y(n2515)
         );
  INVX1 U2278 ( .A(n2531), .Y(n2532) );
  NAND4BX1 U2279 ( .AN(n2533), .B(n2534), .C(n2535), .D(n2536), .Y(n2531) );
  OA22X1 U2280 ( .A0(n2901), .A1(n2538), .B0(n2896), .B1(n2540), .Y(n2535) );
  INVX1 U2281 ( .A(SODSync), .Y(n2796) );
  AO21X1 U2282 ( .A0(BitPeriodCnt[7]), .A1(n2641), .B0(n2652), .Y(n2473) );
  AO22X1 U2283 ( .A0(NextBitPeriodCnt1450_7_), .A1(n2643), .B0(SCR[7]), .B1(
        n2645), .Y(n2652) );
  XNOR2X1 U1_A_7 ( .A(BitPeriodCnt[7]), .B(carry_7_), .Y(
        NextBitPeriodCnt1450_7_) );
  OR2X1 U1_B_6 ( .A(BitPeriodCnt[6]), .B(carry_6_), .Y(carry_7_) );
  AO21X1 U2284 ( .A0(BitPeriodCnt[6]), .A1(n2641), .B0(n2651), .Y(n2474) );
  AO22X1 U2285 ( .A0(NextBitPeriodCnt1450_6_), .A1(n2643), .B0(SCR[6]), .B1(
        n2645), .Y(n2651) );
  XNOR2X1 U1_A_6 ( .A(BitPeriodCnt[6]), .B(carry_6_), .Y(
        NextBitPeriodCnt1450_6_) );
  AO21X1 U2286 ( .A0(BitPeriodCnt[5]), .A1(n2641), .B0(n2650), .Y(n2475) );
  AO22X1 U2287 ( .A0(NextBitPeriodCnt1450_5_), .A1(n2643), .B0(SCR[5]), .B1(
        n2645), .Y(n2650) );
  XNOR2X1 U1_A_5 ( .A(BitPeriodCnt[5]), .B(carry_5_), .Y(
        NextBitPeriodCnt1450_5_) );
  AO21X1 U2288 ( .A0(BitPeriodCnt[4]), .A1(n2641), .B0(n2649), .Y(n2476) );
  AO22X1 U2289 ( .A0(NextBitPeriodCnt1450_4_), .A1(n2643), .B0(SCR[4]), .B1(
        n2645), .Y(n2649) );
  XNOR2X1 U1_A_4 ( .A(BitPeriodCnt[4]), .B(carry_4_), .Y(
        NextBitPeriodCnt1450_4_) );
  AO21X1 U2290 ( .A0(BitPeriodCnt[3]), .A1(n2641), .B0(n2648), .Y(n2477) );
  AO22X1 U2291 ( .A0(NextBitPeriodCnt1450_3_), .A1(n2643), .B0(SCR[3]), .B1(
        n2645), .Y(n2648) );
  XNOR2X1 U1_A_3 ( .A(BitPeriodCnt[3]), .B(carry_3_), .Y(
        NextBitPeriodCnt1450_3_) );
  AO21X1 U2292 ( .A0(BitPeriodCnt[2]), .A1(n2641), .B0(n2647), .Y(n2478) );
  AO22X1 U2293 ( .A0(NextBitPeriodCnt1450_2_), .A1(n2643), .B0(SCR[2]), .B1(
        n2645), .Y(n2647) );
  XNOR2X1 U1_A_2 ( .A(BitPeriodCnt[2]), .B(carry_2_), .Y(
        NextBitPeriodCnt1450_2_) );
  AO21X1 U2294 ( .A0(BitPeriodCnt[1]), .A1(n2641), .B0(n2646), .Y(n2479) );
  AO22X1 U2295 ( .A0(NextBitPeriodCnt1450_1_), .A1(n2643), .B0(SCR[1]), .B1(
        n2645), .Y(n2646) );
  XNOR2X1 U1_A_1 ( .A(BitPeriodCnt[1]), .B(BitPeriodCnt[0]), .Y(
        NextBitPeriodCnt1450_1_) );
  AOI31X1 U2296 ( .A0(n2870), .A1(n2871), .A2(n2872), .B0(n2868), .Y(n2869) );
  OA22X1 U2297 ( .A0(n2563), .A1(n2559), .B0(SspSTxRxState[2]), .B1(n2904), 
        .Y(n2870) );
  AOI221X1 U2298 ( .A0(SspSTxRxState[1]), .A1(n2621), .B0(n2668), .B1(n2901), 
        .C0(n2873), .Y(n2872) );
  AOI221X1 U2299 ( .A0(n2630), .A1(n2669), .B0(n2904), .B1(n2880), .C0(n2554), 
        .Y(n2871) );
  OAI222X1 U2300 ( .A0(FRF[1]), .A1(n2707), .B0(SSESync), .B1(n2708), .C0(
        n2676), .C1(n2559), .Y(n2701) );
  AOI211X1 U2301 ( .A0(n2551), .A1(n2620), .B0(n2709), .C0(n2710), .Y(n2708)
         );
  INVX1 U2302 ( .A(RxFWr), .Y(n2868) );
  DFFRX1 SspSTxRxState_reg_3_ ( .D(n2453), .CK(PCLK), .RN(PRESETn), .Q(
        SspSTxRxState[3]), .QN(n2880) );
  DFFRX1 SspSTxRxState_reg_4_ ( .D(n2452), .CK(PCLK), .RN(PRESETn), .Q(
        SspSTxRxState[4]), .QN(n2887) );
  DFFRX1 BitCnt_reg_0_ ( .D(n2484), .CK(PCLK), .RN(PRESETn), .Q(BitCnt[0]), 
        .QN(n2890) );
  DFFRX1 BitPeriodCnt_reg_6_ ( .D(n2474), .CK(PCLK), .RN(PRESETn), .Q(
        BitPeriodCnt[6]), .QN(n2879) );
  DFFRX1 BitPeriodCnt_reg_5_ ( .D(n2475), .CK(PCLK), .RN(PRESETn), .Q(
        BitPeriodCnt[5]), .QN(n2886) );
  DFFRX1 BitPeriodCnt_reg_4_ ( .D(n2476), .CK(PCLK), .RN(PRESETn), .Q(
        BitPeriodCnt[4]), .QN(n2882) );
  DFFRX1 BitPeriodCnt_reg_2_ ( .D(n2478), .CK(PCLK), .RN(PRESETn), .Q(
        BitPeriodCnt[2]), .QN(n2892) );
  DFFRX1 BitCnt_reg_1_ ( .D(n2483), .CK(PCLK), .RN(PRESETn), .Q(BitCnt[1]), 
        .QN(n2885) );
  DFFRX1 BitPeriodCnt_reg_7_ ( .D(n2473), .CK(PCLK), .RN(PRESETn), .Q(
        BitPeriodCnt[7]), .QN(n2891) );
  DFFRX1 BitCnt_reg_3_ ( .D(n2481), .CK(PCLK), .RN(PRESETn), .Q(BitCnt[3]), 
        .QN(n2893) );
  DFFRX1 BitCnt_reg_2_ ( .D(n2482), .CK(PCLK), .RN(PRESETn), .Q(BitCnt[2]), 
        .QN(n2881) );
  DFFRX1 SspSTxRxState_reg_0_ ( .D(n2456), .CK(PCLK), .RN(PRESETn), .Q(
        SspSTxRxState[0]), .QN(n2883) );
  DFFRX1 BitPeriodCnt_reg_3_ ( .D(n2477), .CK(PCLK), .RN(PRESETn), .Q(
        BitPeriodCnt[3]) );
  DFFRX1 DelCLKINSync_reg ( .D(CLKINSync), .CK(PCLK), .RN(PRESETn), .Q(
        DelCLKINSync) );
  DFFRX1 BitPeriodCnt_reg_0_ ( .D(n2480), .CK(PCLK), .RN(PRESETn), .Q(
        BitPeriodCnt[0]), .QN(n2895) );
  DFFRX1 IntSOD_reg ( .D(n2515), .CK(PCLK), .RN(PRESETn), .Q(IntSOD), .QN(
        n2894) );
  DFFRX1 BitPeriodCnt_reg_1_ ( .D(n2479), .CK(PCLK), .RN(PRESETn), .Q(
        BitPeriodCnt[1]) );
  DFFRX1 SRxFWrData_reg_15_ ( .D(n2457), .CK(PCLK), .RN(PRESETn), .Q(
        SRxFWrData[15]) );
  DFFRX1 SRxFWrData_reg_14_ ( .D(n2458), .CK(PCLK), .RN(PRESETn), .Q(
        SRxFWrData[14]) );
  DFFRX1 SRxFWrData_reg_13_ ( .D(n2459), .CK(PCLK), .RN(PRESETn), .Q(
        SRxFWrData[13]) );
  DFFRX1 SRxFWrData_reg_12_ ( .D(n2460), .CK(PCLK), .RN(PRESETn), .Q(
        SRxFWrData[12]) );
  DFFRX1 SRxFWrData_reg_11_ ( .D(n2461), .CK(PCLK), .RN(PRESETn), .Q(
        SRxFWrData[11]) );
  DFFRX1 SRxFWrData_reg_10_ ( .D(n2462), .CK(PCLK), .RN(PRESETn), .Q(
        SRxFWrData[10]) );
  DFFRX1 SRxFWrData_reg_9_ ( .D(n2463), .CK(PCLK), .RN(PRESETn), .Q(
        SRxFWrData[9]) );
  DFFRX1 SRxFWrData_reg_8_ ( .D(n2464), .CK(PCLK), .RN(PRESETn), .Q(
        SRxFWrData[8]) );
  DFFRX1 SRxFWrData_reg_7_ ( .D(n2465), .CK(PCLK), .RN(PRESETn), .Q(
        SRxFWrData[7]) );
  DFFRX1 SRxFWrData_reg_6_ ( .D(n2466), .CK(PCLK), .RN(PRESETn), .Q(
        SRxFWrData[6]) );
  DFFRX1 SRxFWrData_reg_5_ ( .D(n2467), .CK(PCLK), .RN(PRESETn), .Q(
        SRxFWrData[5]) );
  DFFRX1 SRxFWrData_reg_4_ ( .D(n2468), .CK(PCLK), .RN(PRESETn), .Q(
        SRxFWrData[4]) );
  DFFRX1 SRxFWrData_reg_3_ ( .D(n2469), .CK(PCLK), .RN(PRESETn), .Q(
        SRxFWrData[3]) );
  DFFRX1 SRxFWrData_reg_2_ ( .D(n2470), .CK(PCLK), .RN(PRESETn), .Q(
        SRxFWrData[2]) );
  DFFRX1 SRxFWrData_reg_1_ ( .D(n2471), .CK(PCLK), .RN(PRESETn), .Q(
        SRxFWrData[1]) );
  DFFRX1 SRxFWrData_reg_0_ ( .D(n2472), .CK(PCLK), .RN(PRESETn), .Q(
        SRxFWrData[0]) );
  DFFRX1 TxShft_reg_14_ ( .D(n2485), .CK(PCLK), .RN(PRESETn), .Q(TxShft[14])
         );
  DFFRX1 TxShft_reg_13_ ( .D(n2486), .CK(PCLK), .RN(PRESETn), .Q(TxShft[13])
         );
  DFFRX1 TxShft_reg_12_ ( .D(n2487), .CK(PCLK), .RN(PRESETn), .Q(TxShft[12])
         );
  DFFRX1 TxShft_reg_11_ ( .D(n2488), .CK(PCLK), .RN(PRESETn), .Q(TxShft[11])
         );
  DFFRX1 TxShft_reg_10_ ( .D(n2489), .CK(PCLK), .RN(PRESETn), .Q(TxShft[10])
         );
  DFFRX1 TxShft_reg_9_ ( .D(n2490), .CK(PCLK), .RN(PRESETn), .Q(TxShft[9]) );
  DFFRX1 TxShft_reg_8_ ( .D(n2491), .CK(PCLK), .RN(PRESETn), .Q(TxShft[8]) );
  DFFRX1 TxShft_reg_7_ ( .D(n2492), .CK(PCLK), .RN(PRESETn), .Q(TxShft[7]) );
  DFFRX1 TxShft_reg_6_ ( .D(n2493), .CK(PCLK), .RN(PRESETn), .Q(TxShft[6]) );
  DFFRX1 TxShft_reg_5_ ( .D(n2494), .CK(PCLK), .RN(PRESETn), .Q(TxShft[5]) );
  DFFRX1 TxShft_reg_4_ ( .D(n2495), .CK(PCLK), .RN(PRESETn), .Q(TxShft[4]) );
  DFFRX1 TxShft_reg_3_ ( .D(n2496), .CK(PCLK), .RN(PRESETn), .Q(TxShft[3]) );
  DFFRX1 TxShft_reg_2_ ( .D(n2497), .CK(PCLK), .RN(PRESETn), .Q(TxShft[2]) );
  DFFRX1 TxShft_reg_1_ ( .D(n2498), .CK(PCLK), .RN(PRESETn), .Q(TxShft[1]) );
  DFFRX1 TxShft_reg_0_ ( .D(n2499), .CK(PCLK), .RN(PRESETn), .Q(TxShft[0]) );
  DFFRX1 RxShft_reg_13_ ( .D(n2501), .CK(PCLK), .RN(PRESETn), .Q(RxShft[13])
         );
  DFFRX1 RxShft_reg_12_ ( .D(n2502), .CK(PCLK), .RN(PRESETn), .Q(RxShft[12])
         );
  DFFRX1 RxShft_reg_11_ ( .D(n2503), .CK(PCLK), .RN(PRESETn), .Q(RxShft[11])
         );
  DFFRX1 RxShft_reg_10_ ( .D(n2504), .CK(PCLK), .RN(PRESETn), .Q(RxShft[10])
         );
  DFFRX1 RxShft_reg_9_ ( .D(n2505), .CK(PCLK), .RN(PRESETn), .Q(RxShft[9]) );
  DFFRX1 RxShft_reg_8_ ( .D(n2506), .CK(PCLK), .RN(PRESETn), .Q(RxShft[8]) );
  DFFRX1 RxShft_reg_7_ ( .D(n2507), .CK(PCLK), .RN(PRESETn), .Q(RxShft[7]) );
  DFFRX1 RxShft_reg_6_ ( .D(n2508), .CK(PCLK), .RN(PRESETn), .Q(RxShft[6]) );
  DFFRX1 RxShft_reg_5_ ( .D(n2509), .CK(PCLK), .RN(PRESETn), .Q(RxShft[5]) );
  DFFRX1 RxShft_reg_4_ ( .D(n2510), .CK(PCLK), .RN(PRESETn), .Q(RxShft[4]) );
  DFFRX1 RxShft_reg_3_ ( .D(n2511), .CK(PCLK), .RN(PRESETn), .Q(RxShft[3]) );
  DFFRX1 RxShft_reg_2_ ( .D(n2512), .CK(PCLK), .RN(PRESETn), .Q(RxShft[2]) );
  DFFRX1 RxShft_reg_1_ ( .D(n2513), .CK(PCLK), .RN(PRESETn), .Q(RxShft[1]) );
  DFFRX1 RxShft_reg_0_ ( .D(n2514), .CK(PCLK), .RN(PRESETn), .Q(RxShft[0]) );
  DFFRX1 RxShft_reg_14_ ( .D(n2500), .CK(PCLK), .RN(PRESETn), .Q(RxShft[14])
         );
endmodule


module SspMTxRxCntl ( PCLK, PRESETn, DSS, FRF, SCR, SPO, SPH, SSESync, 
        SSPCLKDIV, TxDataAvlbl, TxFRdDataIn, IntSSPRXD, MSSync, NextnSOE, 
        NextSTXD, NextSRxFWr, NxtSTxFRdPtrInc, NextSTxRxBSY, RNESync, CLKOUT, 
        FSSOUT, TXD, nCTLOE, nOE, TxFRdPtrInc, RxFWr, MRxFWrData, TxRxBSY, 
        MRxRT, IncRxTimeOut );
  input [3:0] DSS;
  input [1:0] FRF;
  input [7:0] SCR;
  input [15:0] TxFRdDataIn;
  output [15:0] MRxFWrData;
  input PCLK, PRESETn, SPO, SPH, SSESync, SSPCLKDIV, TxDataAvlbl, IntSSPRXD,
         MSSync, NextnSOE, NextSTXD, NextSRxFWr, NxtSTxFRdPtrInc, NextSTxRxBSY,
         RNESync;
  output CLKOUT, FSSOUT, TXD, nCTLOE, nOE, TxFRdPtrInc, RxFWr, TxRxBSY, MRxRT,
         IncRxTimeOut;
  wire   DelCLKOUT, NextIncRxTimeOut, TxShft_0_, TxDataAvlblSync, n6242, n6243,
         n6244, n6245, n6246, n6247, n6248, n6249, n6250, n6251, n6252, n6253,
         n6254, n6255, n6256, n6257, n6258, n6259, n6260, n6261, n6262, n6263,
         n6264, n6265, n6266, n6267, n6268, n6269, n6270, n6271, n6272, n6273,
         n6274, n6275, n6276, n6277, n6278, n6279, n6280, n6281, n6282, n6283,
         n6284, n6285, n6286, n6287, n6288, n6289, n6290, n6291, n6292, n6293,
         n6294, n6295, n6296, n6297, n6298, n6299, n6300, n6301, n6302, n6303,
         n6304, n6305, n6306, n6307, n6308, n6309, n6310, n6311, n6312, n6313,
         n5701, n5700, n5699, n5698, n5697, n5696, n5695, carry_7_, carry_6_,
         carry_5_, carry_4_, carry_3_, carry_2_, n6329, n6330, n6331, n6333,
         n6335, n6336, n6337, n6338, n6339, n6341, n6342, n6343, n6344, n6345,
         n6346, n6347, n6348, n6349, n6350, n6351, n6352, n6353, n6354, n6355,
         n6356, n6357, n6358, n6359, n6360, n6362, n6363, n6364, n6365, n6366,
         n6367, n6368, n6369, n6370, n6371, n6372, n6373, n6374, n6375, n6376,
         n6377, n6378, n6379, n6380, n6381, n6382, n6383, n6384, n6385, n6386,
         n6388, n6389, n6390, n6391, n6394, n6396, n6397, n6399, n6400, n6401,
         n6402, n6403, n6404, n6405, n6406, n6407, n6408, n6409, n6410, n6411,
         n6414, n6415, n6416, n6417, n6418, n6419, n6420, n6421, n6422, n6423,
         n6424, n6425, n6426, n6427, n6428, n6429, n6430, n6431, n6432, n6433,
         n6434, n6435, n6437, n6438, n6439, n6440, n6441, n6442, n6443, n6444,
         n6445, n6446, n6447, n6448, n6449, n6450, n6451, n6452, n6453, n6454,
         n6456, n6457, n6458, n6459, n6460, n6461, n6462, n6463, n6464, n6465,
         n6466, n6467, n6468, n6469, n6470, n6471, n6472, n6473, n6474, n6475,
         n6477, n6478, n6479, n6480, n6481, n6482, n6483, n6484, n6488, n6489,
         n6490, n6491, n6492, n6493, n6494, n6495, n6497, n6498, n6499, n6500,
         n6501, n6502, n6503, n6504, n6505, n6506, n6507, n6508, n6509, n6510,
         n6511, n6512, n6513, n6514, n6515, n6516, n6517, n6518, n6519, n6520,
         n6521, n6522, n6523, n6524, n6525, n6526, n6527, n6528, n6529, n6530,
         n6531, n6532, n6533, n6534, n6535, n6536, n6537, n6538, n6539, n6540,
         n6541, n6542, n6545, n6546, n6547, n6548, n6549, n6550, n6551, n6553,
         n6554, n6555, n6556, n6557, n6558, n6559, n6560, n6561, n6562, n6564,
         n6567, n6568, n6569, n6570, n6571, n6572, n6573, n6574, n6575, n6576,
         n6577, n6579, n6580, n6581, n6582, n6583, n6584, n6586, n6587, n6588,
         n6590, n6592, n6593, n6594, n6595, n6596, n6597, n6598, n6599, n6600,
         n6601, n6602, n6603, n6604, n6605, n6606, n6607, n6608, n6609, n6610,
         n6611, n6612, n6613, n6614, n6615, n6616, n6617, n6618, n6619, n6620,
         n6621, n6622, n6623, n6624, n6625, n6626, n6627, n6628, n6629, n6630,
         n6631, n6632, n6633, n6634, n6635, n6636, n6637, n6638, n6639, n6640,
         n6641, n6642, n6643, n6644, n6645, n6646, n6647, n6648, n6649, n6650,
         n6651, n6652, n6653, n6654, n6655, n6656, n6657, n6658, n6660, n6661,
         n6662, n6664, n6666, n6667, n6668, n6669, n6670, n6671, n6673, n6674,
         n6676, n6677, n6679, n6680, n6682, n6683, n6685, n6686, n6688, n6689,
         n6691, n6692, n6694, n6695, n6697, n6698, n6700, n6701, n6703, n6704,
         n6706, n6707, n6709, n6710, n6711, n6712, n6713, n6714, n6715, n6716,
         n6717, n6719, n6720, n6721, n6722, n6723, n6724, n6725, n6726, n6727,
         n6728, n6729, n6730, n6732, n6733, n6735, n6736, n6737, n6738, n6739,
         n6740, n6741, n6742, n6743, n6744, n6745, n6746, n6747, n6748, n6749,
         n6750, n6751, n6752, n6753, n6754, n6756, n6757, n6759, n6760, n6761,
         n6762, n6763, n6764, n6765, n6766, n6767, n6768, n6770, n6771, n6772,
         n6773, n6774, n6775, n6776, n6777, n6778, n6779, n6781, n6783, n6784,
         n6785, n6786, n6787, n6788, n6789, n6790, n6791, n6792, n6793, n6794,
         n6795, n6796, n6797, n6798, n6799, n6800, n6801, n6802, n6803, n6804,
         n6805, n6806, n6807, n6809, n6810, n6811, n6812, n6814, n6815, n6817,
         n6819, n6820, n6821, n6822, n6823, n6824, n6825, n6826, n6827, n6828,
         n6829, n6830, n6831, n6832, n6833, n6834, n6835, n6836, n6837, n6838,
         n6839, n6840, n6841, n6842, n6844, n6845, n6846, n6847, n6848, n6849,
         n6850, n6851, n6852, n6853, n6854, n6855, n6857, n6858, n6859, n6865,
         n6866, n6867, n6868, n6869, n6870, n6871, n6872, n6873, n6874, n6875,
         n6876, n6877, n6878, n6879, n6880, n6881, n6882, n6883, n6884, n6885,
         n6886, n6887, n6888, n6889, n6890, n6891, n6892, n6893, n6894, n6895,
         n6896, n6897, n6898, n6899, n6900, n6901, n6902, n6903, n6904, n6905,
         n6906, n6907, n6908, n6909, n6910, n6911, n6912, n6913, n6914;
  wire   [7:0] BitPeriodCnt;
  wire   [3:0] BitCnt;
  wire   [5:0] SspMTxRxState;
  wire   [14:0] RxShft;

  AOI32X1 U3650 ( .A0(n6914), .A1(n6869), .A2(n6396), .B0(n6397), .B1(n6886), 
        .Y(n6394) );
  OAI211X1 U3651 ( .A0(n6618), .A1(n6451), .B0(n6341), .C0(n6446), .Y(n6717)
         );
  NOR4X1 U3652 ( .A(n6819), .B(n6820), .C(n6771), .D(n6765), .Y(n6872) );
  AOI21X1 U3653 ( .A0(n6732), .A1(n6447), .B0(n6733), .Y(n6888) );
  AOI21X1 U3654 ( .A0(n6579), .A1(n6422), .B0(n6580), .Y(n6893) );
  DFFRX1 nCTLOE_reg ( .D(MSSync), .CK(PCLK), .RN(PRESETn), .Q(nCTLOE) );
  OR2X1 U3655 ( .A(n6537), .B(n6558), .Y(n6643) );
  INVX1 U3656 ( .A(n6812), .Y(n6523) );
  NAND2BX1 U3657 ( .AN(n6636), .B(n6906), .Y(n6812) );
  INVX1 U3658 ( .A(n6505), .Y(n6423) );
  INVX1 U3659 ( .A(n6357), .Y(n6358) );
  INVX1 U3660 ( .A(n6504), .Y(n6600) );
  INVX1 U3661 ( .A(n6822), .Y(n6719) );
  NAND2BX1 U3662 ( .AN(n6658), .B(n6453), .Y(n6822) );
  INVX1 U3663 ( .A(n6792), .Y(n6801) );
  INVX1 U3664 ( .A(n6561), .Y(n6652) );
  INVX1 U3665 ( .A(n6612), .Y(n6537) );
  INVX1 U3666 ( .A(n6450), .Y(n6837) );
  INVX1 U3667 ( .A(n6797), .Y(n6609) );
  AOI22X1 U3668 ( .A0(n6358), .A1(n6497), .B0(n6498), .B1(n6499), .Y(n6905) );
  INVX1 U3669 ( .A(n6562), .Y(n6542) );
  INVX1 U3670 ( .A(n6625), .Y(n6549) );
  NAND2BX1 U3671 ( .AN(n6517), .B(n6642), .Y(n6505) );
  NAND2BX1 U3672 ( .AN(n6887), .B(n6384), .Y(n6357) );
  NAND4BX1 U3673 ( .AN(n6599), .B(n6639), .C(n6806), .D(n6637), .Y(n6792) );
  INVX1 U3674 ( .A(n6643), .Y(n6806) );
  NAND3BX1 U3675 ( .AN(n6429), .B(n6408), .C(n6529), .Y(n6477) );
  NAND2BX1 U3676 ( .AN(n6429), .B(n6396), .Y(n6561) );
  NAND2BX1 U3677 ( .AN(n6805), .B(n6600), .Y(n6484) );
  NAND2BX1 U3678 ( .AN(n6474), .B(n6607), .Y(n6504) );
  NAND2BX1 U3679 ( .AN(n6534), .B(n6607), .Y(n6612) );
  AO22X1 U3680 ( .A0(n6396), .A1(n6732), .B0(n6383), .B1(n6449), .Y(n6610) );
  NAND2BX1 U3681 ( .AN(n6438), .B(n6456), .Y(n6450) );
  NAND2BX1 U3682 ( .AN(n6357), .B(n6762), .Y(n6797) );
  NAND2BX1 U3683 ( .AN(n6429), .B(n6762), .Y(n6540) );
  NAND2BX1 U3684 ( .AN(n6652), .B(n6713), .Y(n6558) );
  AO22X1 U3685 ( .A0(n6383), .A1(n6411), .B0(n6401), .B1(n6422), .Y(n6562) );
  INVX1 U3686 ( .A(n6809), .Y(n6639) );
  NAND2BX1 U3687 ( .AN(n6562), .B(n6810), .Y(n6809) );
  AOI211X1 U3688 ( .A0(n6607), .A1(n6411), .B0(n6536), .C0(n6811), .Y(n6810)
         );
  INVX1 U3689 ( .A(n6540), .Y(n6811) );
  AO21X1 U3690 ( .A0(n6730), .A1(n6776), .B0(n6470), .Y(n6725) );
  INVX1 U3691 ( .A(n6713), .Y(n6733) );
  NAND2BX1 U3692 ( .AN(n6474), .B(n6762), .Y(n6557) );
  INVX1 U3693 ( .A(n6727), .Y(n6446) );
  OAI221X1 U3694 ( .A0(n6888), .A1(n6618), .B0(n6728), .B1(n6534), .C0(n6729), 
        .Y(n6727) );
  AOI32X1 U3695 ( .A0(n6730), .A1(n6414), .A2(n6423), .B0(n6509), .B1(n6366), 
        .Y(n6729) );
  NAND4BX1 U3696 ( .AN(n6634), .B(n6581), .C(n6523), .D(n6354), .Y(n6795) );
  NAND2BX1 U3697 ( .AN(n6474), .B(n6366), .Y(n6453) );
  NAND3BX1 U3698 ( .AN(n6636), .B(n6556), .C(n6637), .Y(n6633) );
  NAND2BX1 U3699 ( .AN(n6423), .B(n6533), .Y(n6635) );
  INVX1 U3700 ( .A(n6512), .Y(n6510) );
  INVX1 U3701 ( .A(n6524), .Y(n6401) );
  NAND3BX1 U3702 ( .AN(n6725), .B(n6719), .C(n6821), .Y(n6765) );
  AOI32X1 U3703 ( .A0(n6732), .A1(n6447), .A2(n6438), .B0(n6732), .B1(n6497), 
        .Y(n6821) );
  INVX1 U3704 ( .A(n6429), .Y(n6411) );
  INVX1 U3705 ( .A(n6456), .Y(n6529) );
  INVX1 U3706 ( .A(n6534), .Y(n6732) );
  INVX1 U3707 ( .A(n6354), .Y(n6360) );
  INVX1 U3708 ( .A(n6474), .Y(n6449) );
  INVX1 U3709 ( .A(n6533), .Y(n6532) );
  INVX1 U3710 ( .A(n6824), .Y(n6759) );
  INVX1 U3711 ( .A(n6432), .Y(n6417) );
  AOI21X1 U3712 ( .A0(n6396), .A1(n6449), .B0(n6595), .Y(n6906) );
  INVX1 U3713 ( .A(n6338), .Y(n6470) );
  INVX1 U3714 ( .A(n6419), .Y(n6656) );
  INVX1 U3715 ( .A(n6841), .Y(n6527) );
  NAND2BX1 U3716 ( .AN(n6399), .B(n6423), .Y(n6841) );
  INVX1 U3717 ( .A(n6556), .Y(n6599) );
  INVX1 U3718 ( .A(n6495), .Y(n6458) );
  INVX1 U3719 ( .A(n6743), .Y(n6737) );
  NOR2X1 U3720 ( .A(n6717), .B(n6342), .Y(n6907) );
  INVX1 U3721 ( .A(n6907), .Y(n6662) );
  INVX1 U3722 ( .A(n6823), .Y(n6658) );
  NAND3BX1 U3723 ( .AN(n6824), .B(n6776), .C(n6796), .Y(n6823) );
  INVX1 U3724 ( .A(n6352), .Y(n6498) );
  INVX1 U3725 ( .A(n6618), .Y(n6438) );
  INVX1 U3726 ( .A(n6842), .Y(n6776) );
  NAND2BX1 U3727 ( .AN(n6517), .B(n6447), .Y(n6842) );
  INVX1 U3728 ( .A(n6833), .Y(n6418) );
  NAND2BX1 U3729 ( .AN(n6358), .B(n6429), .Y(n6833) );
  INVX1 U3730 ( .A(n6767), .Y(n6366) );
  INVX1 U3731 ( .A(n6805), .Y(n6796) );
  INVX1 U3732 ( .A(n6728), .Y(n6497) );
  AOI21X1 U3733 ( .A0(n6396), .A1(n6509), .B0(n6610), .Y(n6908) );
  INVX1 U3734 ( .A(n6467), .Y(n6536) );
  INVX1 U3735 ( .A(n6766), .Y(n6654) );
  OAI211X1 U3736 ( .A0(n6429), .A1(n6767), .B0(n6768), .C0(n6721), .Y(n6766)
         );
  NOR2BX1 U3737 ( .AN(n6770), .B(n6527), .Y(n6768) );
  INVX1 U3738 ( .A(n6771), .Y(n6770) );
  INVX1 U3739 ( .A(n6804), .Y(n6499) );
  INVX1 U3740 ( .A(n6803), .Y(n6630) );
  OAI221X1 U3741 ( .A0(n6804), .A1(n6391), .B0(n6726), .B1(n6797), .C0(n6484), 
        .Y(n6803) );
  INVX1 U3742 ( .A(n6364), .Y(n6479) );
  INVX1 U3743 ( .A(n6427), .Y(n6426) );
  INVX1 U3744 ( .A(n6838), .Y(n6421) );
  OAI211X1 U3745 ( .A0(n6728), .A1(n6474), .B0(n6839), .C0(n6840), .Y(n6838)
         );
  AOI31X1 U3746 ( .A0(n6509), .A1(n6776), .A2(n6499), .B0(n6527), .Y(n6839) );
  NAND3BX1 U3747 ( .AN(n6357), .B(n6505), .C(n6396), .Y(n6569) );
  NAND2BX1 U3748 ( .AN(n6493), .B(n6608), .Y(n6625) );
  NAND2BX1 U3749 ( .AN(n6350), .B(n6423), .Y(n6371) );
  NAND2BX1 U3750 ( .AN(n6534), .B(n6762), .Y(n6567) );
  NAND4BX1 U3751 ( .AN(n6495), .B(n6906), .C(n6909), .D(n6564), .Y(n6559) );
  NAND3BX1 U3752 ( .AN(n6480), .B(n6484), .C(n6500), .Y(n6494) );
  AOI31X1 U3753 ( .A0(n6501), .A1(n6469), .A2(n6358), .B0(n6502), .Y(n6500) );
  INVX1 U3754 ( .A(n6371), .Y(n6502) );
  NAND3BX1 U3755 ( .AN(n6351), .B(n6338), .C(n6352), .Y(n6348) );
  INVX1 U3756 ( .A(n6651), .Y(n6646) );
  INVX1 U3757 ( .A(n6852), .Y(n6848) );
  AOI222X1 U3758 ( .A0(n6596), .A1(n6533), .B0(n6383), .B1(n6384), .C0(n6383), 
        .C1(n6411), .Y(n6613) );
  AOI222X1 U3759 ( .A0(n6440), .A1(n6529), .B0(n6383), .B1(n6358), .C0(n6598), 
        .C1(n6423), .Y(n6574) );
  INVX1 U3760 ( .A(n6555), .Y(n6598) );
  AOI211X1 U3761 ( .A0(n6593), .A1(n6423), .B0(n6594), .C0(n6595), .Y(n6575)
         );
  NAND2BX1 U3762 ( .AN(n6596), .B(n6521), .Y(n6594) );
  INVX1 U3763 ( .A(n6388), .Y(n6593) );
  INVX1 U3764 ( .A(n6391), .Y(n6608) );
  AND3X2 U3765 ( .A(n6569), .B(n6567), .C(n6568), .Y(n6909) );
  INVX1 U3766 ( .A(n6622), .Y(n6616) );
  INVX1 U3767 ( .A(n6377), .Y(n6440) );
  INVX1 U3768 ( .A(n6521), .Y(n6624) );
  OA21X2 U3769 ( .A0(n6418), .A1(n6419), .B0(n6905), .Y(n6478) );
  INVX1 U3770 ( .A(n6621), .Y(n6528) );
  INVX1 U3771 ( .A(n6568), .Y(n6596) );
  INVX1 U3772 ( .A(n6539), .Y(n6636) );
  INVX1 U3773 ( .A(n6726), .Y(n6501) );
  AOI31X1 U3774 ( .A0(n6539), .A1(n6388), .A2(n6893), .B0(n6505), .Y(n6551) );
  AOI31X1 U3775 ( .A0(n6520), .A1(n6521), .A2(n6522), .B0(n6517), .Y(n6519) );
  INVX1 U3776 ( .A(n6350), .Y(n6349) );
  INVX1 U3777 ( .A(n6378), .Y(n6516) );
  INVX1 U3778 ( .A(n6451), .Y(n6351) );
  INVX1 U3779 ( .A(n6448), .Y(n6503) );
  INVX1 U3780 ( .A(n6741), .Y(n6751) );
  AOI21X1 U3781 ( .A0(n6607), .A1(n6759), .B0(n6608), .Y(n6910) );
  INVX1 U3782 ( .A(n6581), .Y(n6580) );
  INVX1 U3783 ( .A(n6640), .Y(n6802) );
  DFFSX1 SspMTxRxState_reg_5_ ( .D(n6301), .CK(PCLK), .SN(PRESETn), .Q(
        SspMTxRxState[5]), .QN(n6870) );
  OR2X1 U3784 ( .A(n6914), .B(n6355), .Y(n6429) );
  NAND2BX1 U3785 ( .AN(n6914), .B(n6384), .Y(n6534) );
  NAND2BX1 U3786 ( .AN(n6870), .B(n6354), .Y(n6338) );
  NAND2BX1 U3787 ( .AN(n6874), .B(n6777), .Y(n6354) );
  NAND2BX1 U3788 ( .AN(n6475), .B(n6397), .Y(n6399) );
  NAND2BX1 U3789 ( .AN(n6869), .B(n6759), .Y(n6474) );
  NAND2BX1 U3790 ( .AN(n6404), .B(n6509), .Y(n6352) );
  NAND2BX1 U3791 ( .AN(n6407), .B(n6762), .Y(n6556) );
  NAND2BX1 U3792 ( .AN(n6517), .B(n6844), .Y(n6533) );
  NAND4BX1 U3793 ( .AN(n6483), .B(n6719), .C(n6720), .D(n6721), .Y(n6342) );
  NAND2BX1 U3794 ( .AN(n6362), .B(n6744), .Y(n6743) );
  NAND2BX1 U3795 ( .AN(n6404), .B(n6423), .Y(n6419) );
  NAND2BX1 U3796 ( .AN(n6353), .B(n6397), .Y(n6467) );
  NAND3BX1 U3797 ( .AN(n6404), .B(n6403), .C(n6401), .Y(n6388) );
  NAND3BX1 U3798 ( .AN(n6638), .B(n6906), .C(n6639), .Y(n6622) );
  OAI211X1 U3799 ( .A0(n6404), .A1(n6524), .B0(n6581), .C0(n6399), .Y(n6638)
         );
  NAND2BX1 U3800 ( .AN(n6422), .B(n6475), .Y(n6414) );
  NAND2BX1 U3801 ( .AN(n6407), .B(n6383), .Y(n6581) );
  NAND3BX1 U3802 ( .AN(n6483), .B(n6653), .C(n6654), .Y(n6651) );
  AOI31X1 U3803 ( .A0(n6408), .A1(n6411), .A2(n6438), .B0(n6655), .Y(n6653) );
  AO21X1 U3804 ( .A0(n6656), .A1(n6657), .B0(n6658), .Y(n6655) );
  NAND2BX1 U3805 ( .AN(n6362), .B(n6338), .Y(n6495) );
  NAND2BX1 U3806 ( .AN(n6870), .B(n6656), .Y(n6454) );
  NAND2BX1 U3807 ( .AN(n6756), .B(n6423), .Y(n6456) );
  NAND2BX1 U3808 ( .AN(n6471), .B(n6397), .Y(n6713) );
  NAND2BX1 U3809 ( .AN(n6817), .B(n6509), .Y(n6555) );
  NAND2BX1 U3810 ( .AN(n6892), .B(n6492), .Y(n6726) );
  NAND2BX1 U3811 ( .AN(n6370), .B(n6607), .Y(n6391) );
  NAND2BX1 U3812 ( .AN(n6874), .B(n6914), .Y(n6824) );
  NAND2BX1 U3813 ( .AN(n6870), .B(n6360), .Y(n6524) );
  NAND2BX1 U3814 ( .AN(n6892), .B(n6473), .Y(n6805) );
  NAND2X1 U3815 ( .A(n6756), .B(n6423), .Y(n6618) );
  NAND2BX1 U3816 ( .AN(n6892), .B(n6493), .Y(n6804) );
  NAND2BX1 U3817 ( .AN(n6471), .B(n6423), .Y(n6728) );
  NAND2BX1 U3818 ( .AN(n6353), .B(n6423), .Y(n6767) );
  NAND2BX1 U3819 ( .AN(n6480), .B(n6481), .Y(n6364) );
  AOI211X1 U3820 ( .A0(n6482), .A1(SSPCLKDIV), .B0(n6483), .C0(n6362), .Y(
        n6481) );
  INVX1 U3821 ( .A(n6484), .Y(n6482) );
  AO21X1 U3822 ( .A0(n6423), .A1(n6427), .B0(n6362), .Y(n6771) );
  NAND2BX1 U3823 ( .AN(n6465), .B(n6329), .Y(n6852) );
  INVX1 U3824 ( .A(n6867), .Y(n6777) );
  NAND2BX1 U3825 ( .AN(n6914), .B(n6869), .Y(n6867) );
  OAI222X1 U3826 ( .A0(n6471), .A1(n6370), .B0(n6475), .B1(n6370), .C0(n6471), 
        .C1(n6407), .Y(n6427) );
  INVX1 U3827 ( .A(n6855), .Y(n6840) );
  OAI222X1 U3828 ( .A0(n6832), .A1(n6419), .B0(n6832), .B1(n6767), .C0(n6419), 
        .C1(n6409), .Y(n6855) );
  OAI32X1 U3829 ( .A0(n6872), .A1(n6362), .A2(n6790), .B0(n6533), .B1(n6791), 
        .Y(n6781) );
  AOI222X1 U3830 ( .A0(n6532), .A1(n6792), .B0(n6793), .B1(n6794), .C0(n6795), 
        .C1(n6505), .Y(n6790) );
  OAI222X1 U3831 ( .A0(n6499), .A1(n6391), .B0(n6796), .B1(n6504), .C0(n6501), 
        .C1(n6797), .Y(n6793) );
  OAI32X1 U3832 ( .A0(n6872), .A1(n6362), .A2(n6798), .B0(n6794), .B1(n6791), 
        .Y(n6778) );
  AOI211X1 U3833 ( .A0(n6423), .A1(n6795), .B0(n6799), .C0(n6800), .Y(n6798)
         );
  AOI31X1 U3834 ( .A0(n6391), .A1(n6504), .A2(n6797), .B0(n6794), .Y(n6800) );
  OAI211X1 U3835 ( .A0(n6532), .A1(n6801), .B0(n6802), .C0(n6630), .Y(n6799)
         );
  INVX1 U3836 ( .A(n6807), .Y(n6637) );
  OAI221X1 U3837 ( .A0(n6357), .A1(n6531), .B0(n6534), .B1(n6535), .C0(n6557), 
        .Y(n6807) );
  INVX1 U3838 ( .A(n6648), .Y(n6647) );
  OAI211X1 U3839 ( .A0(n6649), .A1(n6650), .B0(n6341), .C0(n6651), .Y(n6648)
         );
  NAND2BX1 U3840 ( .AN(n6595), .B(n6399), .Y(n6649) );
  AO21X1 U3841 ( .A0(n6509), .A1(n6870), .B0(n6652), .Y(n6650) );
  OAI211X1 U3842 ( .A0(n6825), .A1(n6475), .B0(n6826), .C0(n6827), .Y(n6820)
         );
  OAI221X1 U3843 ( .A0(n6836), .A1(n6533), .B0(n6837), .B1(n6429), .C0(n6421), 
        .Y(n6819) );
  OR2X1 U3844 ( .A(n6597), .B(n6454), .Y(n6721) );
  NAND4BX1 U3845 ( .AN(n6629), .B(n6630), .C(n6631), .D(n6632), .Y(n6512) );
  AO21X1 U3846 ( .A0(n6643), .A1(n6450), .B0(n6644), .Y(n6629) );
  AOI211X1 U3847 ( .A0(SSPCLKDIV), .A1(n6640), .B0(n6641), .C0(n6495), .Y(
        n6631) );
  OAI31X1 U3848 ( .A0(n6622), .A1(n6633), .A2(n6634), .B0(n6635), .Y(n6632) );
  INVX1 U3849 ( .A(n6850), .Y(n6849) );
  OAI211X1 U3850 ( .A0(n6652), .A1(n6851), .B0(n6341), .C0(n6852), .Y(n6850)
         );
  NAND2BX1 U3851 ( .AN(n6579), .B(n6409), .Y(n6851) );
  INVX1 U3852 ( .A(n6475), .Y(n6469) );
  INVX1 U3853 ( .A(n6441), .Y(n6396) );
  INVX1 U3854 ( .A(n6817), .Y(n6762) );
  INVX1 U3855 ( .A(n6471), .Y(n6408) );
  INVX1 U3856 ( .A(n6353), .Y(n6422) );
  INVX1 U3857 ( .A(n6359), .Y(n6492) );
  NAND2BX1 U3858 ( .AN(n6815), .B(n6908), .Y(n6634) );
  OAI211X1 U3859 ( .A0(n6357), .A1(n6441), .B0(n6541), .C0(n6555), .Y(n6815)
         );
  INVX1 U3860 ( .A(n6531), .Y(n6607) );
  INVX1 U3861 ( .A(n6370), .Y(n6509) );
  INVX1 U3862 ( .A(n6404), .Y(n6447) );
  OAI221X1 U3863 ( .A0(n6503), .A1(n6504), .B0(n6505), .B1(n6467), .C0(n6457), 
        .Y(n6480) );
  OAI221X1 U3864 ( .A0(n6661), .A1(n6706), .B0(n6669), .B1(n6703), .C0(n6707), 
        .Y(n6271) );
  OA22X1 U3865 ( .A0(n6664), .A1(n6880), .B0(n6662), .B1(n6902), .Y(n6707) );
  OAI221X1 U3866 ( .A0(n6661), .A1(n6703), .B0(n6669), .B1(n6700), .C0(n6704), 
        .Y(n6272) );
  OA22X1 U3867 ( .A0(n6664), .A1(n6896), .B0(n6662), .B1(n6880), .Y(n6704) );
  OAI221X1 U3868 ( .A0(n6661), .A1(n6700), .B0(n6669), .B1(n6697), .C0(n6701), 
        .Y(n6273) );
  OA22X1 U3869 ( .A0(n6664), .A1(n6881), .B0(n6662), .B1(n6896), .Y(n6701) );
  OAI221X1 U3870 ( .A0(n6661), .A1(n6697), .B0(n6669), .B1(n6694), .C0(n6698), 
        .Y(n6274) );
  OA22X1 U3871 ( .A0(n6664), .A1(n6897), .B0(n6662), .B1(n6881), .Y(n6698) );
  OAI221X1 U3872 ( .A0(n6661), .A1(n6694), .B0(n6669), .B1(n6691), .C0(n6695), 
        .Y(n6275) );
  OA22X1 U3873 ( .A0(n6664), .A1(n6882), .B0(n6662), .B1(n6897), .Y(n6695) );
  OAI221X1 U3874 ( .A0(n6661), .A1(n6691), .B0(n6669), .B1(n6688), .C0(n6692), 
        .Y(n6276) );
  OA22X1 U3875 ( .A0(n6664), .A1(n6898), .B0(n6662), .B1(n6882), .Y(n6692) );
  OAI221X1 U3876 ( .A0(n6661), .A1(n6688), .B0(n6669), .B1(n6685), .C0(n6689), 
        .Y(n6277) );
  OA22X1 U3877 ( .A0(n6664), .A1(n6883), .B0(n6662), .B1(n6898), .Y(n6689) );
  OAI221X1 U3878 ( .A0(n6661), .A1(n6685), .B0(n6669), .B1(n6682), .C0(n6686), 
        .Y(n6278) );
  OA22X1 U3879 ( .A0(n6664), .A1(n6899), .B0(n6662), .B1(n6883), .Y(n6686) );
  OAI221X1 U3880 ( .A0(n6661), .A1(n6682), .B0(n6669), .B1(n6679), .C0(n6683), 
        .Y(n6279) );
  OA22X1 U3881 ( .A0(n6664), .A1(n6884), .B0(n6662), .B1(n6899), .Y(n6683) );
  OAI221X1 U3882 ( .A0(n6661), .A1(n6679), .B0(n6669), .B1(n6676), .C0(n6680), 
        .Y(n6280) );
  OA22X1 U3883 ( .A0(n6664), .A1(n6900), .B0(n6662), .B1(n6884), .Y(n6680) );
  OAI221X1 U3884 ( .A0(n6661), .A1(n6676), .B0(n6669), .B1(n6673), .C0(n6677), 
        .Y(n6281) );
  OA22X1 U3885 ( .A0(n6664), .A1(n6885), .B0(n6662), .B1(n6900), .Y(n6677) );
  OAI221X1 U3886 ( .A0(n6661), .A1(n6673), .B0(n6669), .B1(n6670), .C0(n6674), 
        .Y(n6282) );
  OA22X1 U3887 ( .A0(n6664), .A1(n6901), .B0(n6662), .B1(n6885), .Y(n6674) );
  OAI221X1 U3888 ( .A0(n6661), .A1(n6670), .B0(n6667), .B1(n6669), .C0(n6671), 
        .Y(n6283) );
  OA22X1 U3889 ( .A0(n6664), .A1(n6879), .B0(n6662), .B1(n6901), .Y(n6671) );
  INVX1 U3890 ( .A(n6409), .Y(n6397) );
  INVX1 U3891 ( .A(n6428), .Y(n6384) );
  OAI31X1 U3892 ( .A0(n6743), .A1(n6760), .A2(n6746), .B0(n6744), .Y(n6748) );
  AOI31X1 U3893 ( .A0(n6358), .A1(n6492), .A2(n6829), .B0(n6834), .Y(n6825) );
  OAI31X1 U3894 ( .A0(n6505), .A1(n6726), .A2(n6869), .B0(n6835), .Y(n6834) );
  OA22X1 U3895 ( .A0(n6517), .A1(n6534), .B0(n6505), .B1(n6824), .Y(n6835) );
  INVX1 U3896 ( .A(n6844), .Y(n6642) );
  INVX1 U3897 ( .A(n6535), .Y(n6383) );
  INVX1 U3898 ( .A(n6847), .Y(n6493) );
  OAI221X1 U3899 ( .A0(n6423), .A1(n6523), .B0(n6419), .B1(n6524), .C0(n6525), 
        .Y(n6518) );
  NOR3BX1 U3900 ( .AN(n6526), .B(n6527), .C(n6528), .Y(n6525) );
  AOI31X1 U3901 ( .A0(n6440), .A1(n6892), .A2(n6529), .B0(n6530), .Y(n6526) );
  OAI33X1 U3902 ( .A0(n6418), .A1(n6531), .A2(n6532), .B0(n6533), .B1(n6534), 
        .B2(n6535), .Y(n6530) );
  INVX1 U3903 ( .A(n6374), .Y(n6473) );
  INVX1 U3904 ( .A(n6597), .Y(n6403) );
  OAI32X1 U3905 ( .A0(n6510), .A1(n6362), .A2(n6601), .B0(n6869), .B1(n6512), 
        .Y(n6303) );
  AND4X1 U3906 ( .A(n6602), .B(n6564), .C(n6603), .D(n6572), .Y(n6601) );
  AOI221X1 U3907 ( .A0(n6609), .A1(n6405), .B0(n6607), .B1(n6411), .C0(n6610), 
        .Y(n6603) );
  AND4X1 U3908 ( .A(n6612), .B(n6567), .C(n6561), .D(n6613), .Y(n6602) );
  NAND3BX1 U3909 ( .AN(n6444), .B(n6445), .C(n6446), .Y(n6432) );
  AOI32X1 U3910 ( .A0(n6447), .A1(n6448), .A2(n6449), .B0(n6351), .B1(n6450), 
        .Y(n6445) );
  NAND3BX1 U3911 ( .AN(n6452), .B(n6453), .C(n6454), .Y(n6444) );
  OAI211X1 U3912 ( .A0(n6888), .A1(n6456), .B0(n6457), .C0(n6458), .Y(n6452)
         );
  NAND2BX1 U3913 ( .AN(n6416), .B(n6417), .Y(n6415) );
  OAI211X1 U3914 ( .A0(n6418), .A1(n6419), .B0(n6420), .C0(n6421), .Y(n6416)
         );
  AOI32X1 U3915 ( .A0(n6422), .A1(SSPCLKDIV), .A2(n6358), .B0(n6423), .B1(
        n6424), .Y(n6420) );
  OAI211X1 U3916 ( .A0(n6353), .A1(n6870), .B0(n6425), .C0(n6426), .Y(n6424)
         );
  AND4X1 U3917 ( .A(n6429), .B(n6534), .C(n6350), .D(n6845), .Y(n6836) );
  AOI222X1 U3918 ( .A0(n6846), .A1(n6869), .B0(n6384), .B1(n6492), .C0(n6473), 
        .C1(n6759), .Y(n6845) );
  OAI221X1 U3919 ( .A0(n6874), .A1(n6404), .B0(n6404), .B1(n6847), .C0(n6817), 
        .Y(n6846) );
  INVX1 U3920 ( .A(n6407), .Y(n6730) );
  OAI221X1 U3921 ( .A0(n6403), .A1(n6404), .B0(n6886), .B1(n6374), .C0(n6873), 
        .Y(n6402) );
  AOI221X1 U3922 ( .A0(n6532), .A1(n6536), .B0(n6537), .B1(n6438), .C0(n6538), 
        .Y(n6514) );
  OAI222X1 U3923 ( .A0(n6369), .A1(n6539), .B0(n6532), .B1(n6540), .C0(n6419), 
        .C1(n6541), .Y(n6538) );
  INVX1 U3924 ( .A(n6747), .Y(n6760) );
  INVX1 U3925 ( .A(n6794), .Y(n6829) );
  AOI32X1 U3926 ( .A0(n6509), .A1(n6493), .A2(n6829), .B0(n6830), .B1(n6635), 
        .Y(n6826) );
  OAI211X1 U3927 ( .A0(n6418), .A1(n6404), .B0(n6831), .C0(n6832), .Y(n6830)
         );
  NOR2BX1 U3928 ( .AN(n6353), .B(n6408), .Y(n6831) );
  INVX1 U3929 ( .A(SSPCLKDIV), .Y(n6517) );
  INVX1 U3930 ( .A(n6333), .Y(n6329) );
  INVX1 U3931 ( .A(n6577), .Y(n6545) );
  OAI221X1 U3932 ( .A0(n6438), .A1(n6561), .B0(n6369), .B1(n6556), .C0(n6893), 
        .Y(n6577) );
  INVX1 U3933 ( .A(n6814), .Y(n6595) );
  NAND2BX1 U3934 ( .AN(n6407), .B(n6396), .Y(n6814) );
  INVX1 U3935 ( .A(n6720), .Y(n6367) );
  AND2X2 U3936 ( .A(n6399), .B(n6394), .Y(n6911) );
  NAND2BX1 U3937 ( .AN(n6475), .B(n6449), .Y(n6350) );
  NAND2BX1 U3938 ( .AN(n6374), .B(n6600), .Y(n6520) );
  NAND2BX1 U3939 ( .AN(n6471), .B(n6401), .Y(n6521) );
  NAND2BX1 U3940 ( .AN(n6475), .B(n6579), .Y(n6377) );
  NAND2BX1 U3941 ( .AN(n6471), .B(n6579), .Y(n6568) );
  NAND2BX1 U3942 ( .AN(n6847), .B(n6608), .Y(n6378) );
  NAND2BX1 U3943 ( .AN(n6535), .B(n6509), .Y(n6539) );
  NAND2BX1 U3944 ( .AN(n6359), .B(n6609), .Y(n6522) );
  NAND2BX1 U3945 ( .AN(n6493), .B(n6359), .Y(n6448) );
  NAND2BX1 U3946 ( .AN(n6407), .B(n6607), .Y(n6621) );
  NAND2BX1 U3947 ( .AN(n6475), .B(n6657), .Y(n6451) );
  OAI211X1 U3948 ( .A0(n6418), .A1(n6535), .B0(n6910), .C0(n6757), .Y(n6741)
         );
  NOR2BX1 U3949 ( .AN(n6524), .B(n6440), .Y(n6757) );
  OAI211X1 U3950 ( .A0(n6357), .A1(n6535), .B0(n6621), .C0(n6567), .Y(n6640)
         );
  INVX1 U3951 ( .A(n6611), .Y(n6564) );
  OAI211X1 U3952 ( .A0(n6356), .A1(n6504), .B0(n6540), .C0(n6522), .Y(n6611)
         );
  NAND4BX1 U3953 ( .AN(n6466), .B(n6352), .C(n6467), .D(n6468), .Y(n6462) );
  OAI221X1 U3954 ( .A0(n6429), .A1(n6404), .B0(n6471), .B1(n6357), .C0(n6472), 
        .Y(n6466) );
  AOI31X1 U3955 ( .A0(n6914), .A1(n6359), .A2(n6469), .B0(n6470), .Y(n6468) );
  OA22X1 U3956 ( .A0(n6473), .A1(n6474), .B0(n6870), .B1(n6475), .Y(n6472) );
  NAND2BX1 U3957 ( .AN(n6465), .B(n6362), .Y(n6791) );
  INVX1 U3958 ( .A(n6362), .Y(n6341) );
  NAND2BX1 U3959 ( .AN(n6475), .B(n6401), .Y(n6553) );
  AOI33X1 U3960 ( .A0(n6410), .A1(n6870), .A2(n6411), .B0(n6887), .B1(n6874), 
        .B2(n6383), .Y(n6379) );
  INVX1 U3961 ( .A(n6414), .Y(n6410) );
  INVX1 U3962 ( .A(n6832), .Y(n6657) );
  INVX1 U3963 ( .A(n6619), .Y(n6576) );
  NAND3BX1 U3964 ( .AN(n6528), .B(n6520), .C(n6620), .Y(n6619) );
  AOI33X1 U3965 ( .A0(n6449), .A1(n6505), .A2(n6383), .B0(n6359), .B1(n6405), 
        .B2(n6609), .Y(n6620) );
  INVX1 U3966 ( .A(n6541), .Y(n6579) );
  INVX1 U3967 ( .A(n6744), .Y(n6736) );
  INVX1 U3968 ( .A(n6604), .Y(n6572) );
  NAND4BX1 U3969 ( .AN(n6605), .B(n6557), .C(n6606), .D(n6569), .Y(n6604) );
  AOI31X1 U3970 ( .A0(n6607), .A1(n6358), .A2(n6532), .B0(n6608), .Y(n6606) );
  OAI222X1 U3971 ( .A0(n6474), .A1(n6441), .B0(n6493), .B1(n6553), .C0(n6532), 
        .C1(n6467), .Y(n6605) );
  OAI222X1 U3972 ( .A0(n6353), .A1(n6354), .B0(n6355), .B1(n6356), .C0(n6353), 
        .C1(n6357), .Y(n6347) );
  AO22X1 U3973 ( .A0(n6609), .A1(n6356), .B0(n6624), .B1(n6642), .Y(n6641) );
  OAI32X1 U3974 ( .A0(n6857), .A1(n6794), .A2(n6362), .B0(n6794), .B1(n6791), 
        .Y(NextIncRxTimeOut) );
  AOI222X1 U3975 ( .A0(n6865), .A1(n6726), .B0(n6866), .B1(n6805), .C0(n6516), 
        .C1(n6804), .Y(n6857) );
  INVX1 U3976 ( .A(n6522), .Y(n6865) );
  INVX1 U3977 ( .A(n6520), .Y(n6866) );
  OAI221X1 U3978 ( .A0(n6356), .A1(n6553), .B0(n6529), .B1(n6377), .C0(n6554), 
        .Y(n6550) );
  AND4X1 U3979 ( .A(n6555), .B(n6556), .C(n6399), .D(n6557), .Y(n6554) );
  OA21X2 U3980 ( .A0(n6353), .A1(n6428), .B0(n6429), .Y(n6425) );
  AOI211X1 U3981 ( .A0(n6549), .A1(n6356), .B0(n6624), .C0(n6599), .Y(n6623)
         );
  INVX1 U3982 ( .A(n6739), .Y(n6746) );
  NAND2BX1 U3983 ( .AN(MSSync), .B(SSESync), .Y(n6362) );
  NAND2BX1 U3984 ( .AN(SspMTxRxState[0]), .B(SspMTxRxState[1]), .Y(n6475) );
  NAND4BX1 U3985 ( .AN(n6367), .B(n6763), .C(n6654), .D(n6764), .Y(n6744) );
  AOI32X1 U3986 ( .A0(n6411), .A1(n6469), .A2(n6423), .B0(n6497), .B1(
        SspMTxRxState[5]), .Y(n6763) );
  INVX1 U3987 ( .A(n6765), .Y(n6764) );
  NAND2BX1 U3988 ( .AN(SspMTxRxState[1]), .B(SspMTxRxState[0]), .Y(n6353) );
  NAND4BX1 U3989 ( .AN(BitPeriodCnt[1]), .B(n6889), .C(n6858), .D(n6859), .Y(
        n6844) );
  NOR2BX1 U3990 ( .AN(n6891), .B(BitPeriodCnt[3]), .Y(n6858) );
  AND4X1 U3991 ( .A(n6871), .B(n6876), .C(n6868), .D(n6890), .Y(n6859) );
  NAND2BX1 U3992 ( .AN(FRF[0]), .B(FRF[1]), .Y(n6359) );
  NAND2BX1 U3993 ( .AN(SspMTxRxState[0]), .B(n6886), .Y(n6404) );
  NAND2BX1 U3994 ( .AN(n6873), .B(SspMTxRxState[1]), .Y(n6471) );
  NAND2BX1 U3995 ( .AN(SspMTxRxState[3]), .B(n6759), .Y(n6407) );
  OAI211X1 U3996 ( .A0(n6579), .A1(n6715), .B0(n6716), .C0(n6662), .Y(n6661)
         );
  OA21X2 U3997 ( .A0(n6529), .A1(n6715), .B0(n6341), .Y(n6716) );
  OAI211X1 U3998 ( .A0(SspMTxRxState[5]), .A1(n6357), .B0(n6910), .C0(n6735), 
        .Y(n6715) );
  NOR2BX1 U3999 ( .AN(n6567), .B(n6624), .Y(n6735) );
  NAND3BX1 U4000 ( .AN(BitCnt[3]), .B(n6877), .C(n6760), .Y(n6756) );
  NAND3BX1 U4001 ( .AN(SspMTxRxState[4]), .B(n6869), .C(n6914), .Y(n6832) );
  OAI211X1 U4002 ( .A0(n6443), .A1(n6711), .B0(n6341), .C0(n6662), .Y(n6664)
         );
  OAI32X1 U4003 ( .A0(n6534), .A1(SspMTxRxState[5]), .A2(n6414), .B0(n6529), 
        .B1(n6541), .Y(n6711) );
  NAND2BX1 U4004 ( .AN(SspMTxRxState[5]), .B(n6408), .Y(n6441) );
  NAND2BX1 U4005 ( .AN(SspMTxRxState[5]), .B(n6360), .Y(n6409) );
  NAND2BX1 U4006 ( .AN(n6505), .B(RNESync), .Y(n6794) );
  NAND2BX1 U4007 ( .AN(FRF[0]), .B(n6356), .Y(n6374) );
  NAND2BX1 U4008 ( .AN(SspMTxRxState[5]), .B(n6422), .Y(n6535) );
  NAND3BX1 U4009 ( .AN(n6714), .B(n6341), .C(n6662), .Y(n6669) );
  AOI32X1 U4010 ( .A0(SspMTxRxState[0]), .A1(n6870), .A2(n6449), .B0(n6401), 
        .B1(n6873), .Y(n6714) );
  NAND2BX1 U4011 ( .AN(SspMTxRxState[4]), .B(n6777), .Y(n6370) );
  NAND2BX1 U4012 ( .AN(n6405), .B(FRF[1]), .Y(n6508) );
  NAND2BX1 U4013 ( .AN(FRF[1]), .B(FRF[0]), .Y(n6847) );
  NAND2BX1 U4014 ( .AN(SspMTxRxState[4]), .B(SspMTxRxState[3]), .Y(n6428) );
  NAND2BX1 U4015 ( .AN(SspMTxRxState[5]), .B(n6469), .Y(n6817) );
  NAND2BX1 U4016 ( .AN(SspMTxRxState[5]), .B(n6447), .Y(n6531) );
  NAND2BX1 U4017 ( .AN(n6869), .B(SspMTxRxState[4]), .Y(n6355) );
  NAND2BX1 U4018 ( .AN(n6386), .B(TxDataAvlblSync), .Y(n6597) );
  NAND2BX1 U4019 ( .AN(BitCnt[0]), .B(n6875), .Y(n6747) );
  OAI211X1 U4020 ( .A0(n6407), .A1(n6712), .B0(n6539), .C0(n6713), .Y(n6443)
         );
  NAND2BX1 U4021 ( .AN(SspMTxRxState[5]), .B(n6414), .Y(n6712) );
  OAI33X1 U4022 ( .A0(n6587), .A1(n6588), .A2(n6875), .B0(n6587), .B1(DSS[2]), 
        .B2(BitCnt[1]), .Y(n6586) );
  INVX1 U4023 ( .A(n6590), .Y(n6587) );
  OAI33X1 U4024 ( .A0(n6877), .A1(BitCnt[3]), .A2(n6592), .B0(BitCnt[2]), .B1(
        DSS[3]), .B2(BitCnt[3]), .Y(n6590) );
  INVX1 U4025 ( .A(n6406), .Y(n6385) );
  OAI32X1 U4026 ( .A0(n6407), .A1(SspMTxRxState[5]), .A2(n6408), .B0(n6873), 
        .B1(n6409), .Y(n6406) );
  OAI2BB2X1 U4027 ( .A0N(n6736), .A1N(BitCnt[1]), .B0(n6742), .B1(n6743), .Y(
        n6268) );
  AOI211X1 U4028 ( .A0(DSS[1]), .A1(n6741), .B0(n6745), .C0(n6610), .Y(n6742)
         );
  OAI32X1 U4029 ( .A0(n6746), .A1(n6894), .A2(n6875), .B0(n6746), .B1(n6747), 
        .Y(n6745) );
  AO21X1 U4030 ( .A0(n6341), .A1(n6853), .B0(MSSync), .Y(n6333) );
  NAND3BX1 U4031 ( .AN(n6854), .B(n6338), .C(n6840), .Y(n6853) );
  INVX1 U4032 ( .A(n6477), .Y(n6854) );
  INVX1 U4033 ( .A(FRF[1]), .Y(n6356) );
  AO21X1 U4034 ( .A0(n6772), .A1(n6773), .B0(SspMTxRxState[4]), .Y(n6720) );
  AOI33X1 U4035 ( .A0(SspMTxRxState[3]), .A1(n6775), .A2(n6422), .B0(n6776), 
        .B1(n6777), .B2(n6499), .Y(n6772) );
  NAND3BX1 U4036 ( .AN(n6774), .B(n6469), .C(n6529), .Y(n6773) );
  NOR2BX1 U4037 ( .AN(n6914), .B(n6517), .Y(n6775) );
  BUFX2 U4038 ( .A(SspMTxRxState[2]), .Y(n6914) );
  INVX1 U4039 ( .A(DSS[2]), .Y(n6588) );
  INVX1 U4040 ( .A(SPH), .Y(n6386) );
  INVX1 U4041 ( .A(FRF[0]), .Y(n6405) );
  AO22X1 U4042 ( .A0(n6464), .A1(n6465), .B0(NextnSOE), .B1(MSSync), .Y(n6463)
         );
  INVX1 U4043 ( .A(MSSync), .Y(n6464) );
  AOI222X1 U4044 ( .A0(SPO), .A1(n6381), .B0(n6382), .B1(n6375), .C0(n6383), 
        .C1(n6384), .Y(n6380) );
  OAI211X1 U4045 ( .A0(SPH), .A1(n6385), .B0(n6389), .C0(n6390), .Y(n6381) );
  OAI221X1 U4046 ( .A0(n6385), .A1(n6386), .B0(SPH), .B1(n6911), .C0(n6388), 
        .Y(n6382) );
  AOI32X1 U4047 ( .A0(n6400), .A1(SspMTxRxState[1]), .A2(n6358), .B0(n6401), 
        .B1(n6402), .Y(n6389) );
  OAI221X1 U4048 ( .A0(n6709), .A1(n6661), .B0(n6669), .B1(n6706), .C0(n6710), 
        .Y(n6270) );
  INVX1 U4049 ( .A(TxFRdDataIn[15]), .Y(n6709) );
  OA22X1 U4050 ( .A0(n6664), .A1(n6902), .B0(n6878), .B1(n6662), .Y(n6710) );
  OAI221X1 U4051 ( .A0(n6895), .A1(n6664), .B0(n6662), .B1(n6879), .C0(n6666), 
        .Y(n6284) );
  OA22X1 U4052 ( .A0(n6661), .A1(n6667), .B0(n6668), .B1(n6669), .Y(n6666) );
  INVX1 U4053 ( .A(TxFRdDataIn[0]), .Y(n6668) );
  OA22X1 U4054 ( .A0(n6911), .A1(n6386), .B0(FRF[1]), .B1(n6391), .Y(n6390) );
  AO21X1 U4055 ( .A0(CLKOUT), .A1(n6372), .B0(n6373), .Y(n6310) );
  OAI33X1 U4056 ( .A0(n6374), .A1(n6341), .A2(n6375), .B0(n6372), .B1(n6362), 
        .B2(n6376), .Y(n6373) );
  AND4X1 U4057 ( .A(n6377), .B(n6378), .C(n6379), .D(n6380), .Y(n6376) );
  INVX1 U4058 ( .A(n6415), .Y(n6372) );
  OAI2BB1X1 U4059 ( .A0N(n6510), .A1N(SspMTxRxState[1]), .B0(n6546), .Y(n6305)
         );
  AO21X1 U4060 ( .A0(n6547), .A1(n6548), .B0(n6510), .Y(n6546) );
  AOI211X1 U4061 ( .A0(n6549), .A1(FRF[1]), .B0(n6550), .C0(n6551), .Y(n6548)
         );
  AOI211X1 U4062 ( .A0(n6438), .A1(n6558), .B0(n6559), .C0(n6560), .Y(n6547)
         );
  AO22X1 U4063 ( .A0(n6510), .A1(SspMTxRxState[4]), .B0(n6614), .B1(n6512), 
        .Y(n6302) );
  NAND4BX1 U4064 ( .AN(n6615), .B(n6616), .C(n6576), .D(n6617), .Y(n6614) );
  AOI211X1 U4065 ( .A0(n6537), .A1(n6618), .B0(n6558), .C0(n6495), .Y(n6617)
         );
  OAI221X1 U4066 ( .A0(n6533), .A1(n6557), .B0(n6374), .B1(n6553), .C0(n6623), 
        .Y(n6615) );
  OAI2BB1X1 U4067 ( .A0N(TxFRdPtrInc), .A1N(n6335), .B0(n6336), .Y(n6312) );
  INVX1 U4068 ( .A(n6339), .Y(n6335) );
  AOI32X1 U4069 ( .A0(n6337), .A1(n6338), .A2(n6339), .B0(NxtSTxFRdPtrInc), 
        .B1(MSSync), .Y(n6336) );
  AO21X1 U4070 ( .A0(n6341), .A1(n6342), .B0(MSSync), .Y(n6339) );
  OAI2BB1X1 U4071 ( .A0N(RxFWr), .A1N(n6329), .B0(n6330), .Y(n6313) );
  AOI32X1 U4072 ( .A0(n6331), .A1(n6870), .A2(n6333), .B0(NextSRxFWr), .B1(
        MSSync), .Y(n6330) );
  NOR2BX1 U4073 ( .AN(n6904), .B(MSSync), .Y(n6331) );
  AO22X1 U4074 ( .A0(n6510), .A1(n6914), .B0(n6570), .B1(n6512), .Y(n6304) );
  AOI31X1 U4075 ( .A0(n6571), .A1(n6572), .A2(n6573), .B0(n6362), .Y(n6570) );
  AOI222X1 U4076 ( .A0(n6532), .A1(n6599), .B0(n6600), .B1(FRF[1]), .C0(n6579), 
        .C1(n6505), .Y(n6571) );
  AND4X1 U4077 ( .A(n6574), .B(n6575), .C(n6576), .D(n6545), .Y(n6573) );
  AO22X1 U4078 ( .A0(n6510), .A1(SspMTxRxState[0]), .B0(n6511), .B1(n6512), 
        .Y(n6306) );
  AOI31X1 U4079 ( .A0(n6513), .A1(n6514), .A2(n6515), .B0(n6362), .Y(n6511) );
  AOI211X1 U4080 ( .A0(n6516), .A1(n6517), .B0(n6518), .C0(n6519), .Y(n6515)
         );
  AND4X1 U4081 ( .A(n6542), .B(n6909), .C(n6908), .D(n6545), .Y(n6513) );
  AO22X1 U4082 ( .A0(BitCnt[2]), .A1(n6748), .B0(n6737), .B1(n6749), .Y(n6267)
         );
  OAI31X1 U4083 ( .A0(n6746), .A1(BitCnt[2]), .A2(n6747), .B0(n6750), .Y(n6749) );
  OA21X2 U4084 ( .A0(n6751), .A1(n6588), .B0(n6752), .Y(n6750) );
  INVX1 U4085 ( .A(n6610), .Y(n6752) );
  AO22X1 U4086 ( .A0(n6736), .A1(BitCnt[0]), .B0(n6737), .B1(n6738), .Y(n6269)
         );
  AO21X1 U4087 ( .A0(n6739), .A1(n6894), .B0(n6740), .Y(n6738) );
  AO21X1 U4088 ( .A0(DSS[0]), .A1(n6741), .B0(n6610), .Y(n6740) );
  AO22X1 U4089 ( .A0(MRxFWrData[15]), .A1(n6848), .B0(n6849), .B1(RxShft[14]), 
        .Y(n6242) );
  AO22X1 U4090 ( .A0(RxShft[14]), .A1(n6646), .B0(RxShft[13]), .B1(n6647), .Y(
        n6286) );
  AO22X1 U4091 ( .A0(RxShft[13]), .A1(n6646), .B0(RxShft[12]), .B1(n6647), .Y(
        n6287) );
  AO22X1 U4092 ( .A0(RxShft[12]), .A1(n6646), .B0(RxShft[11]), .B1(n6647), .Y(
        n6288) );
  AO22X1 U4093 ( .A0(RxShft[11]), .A1(n6646), .B0(RxShft[10]), .B1(n6647), .Y(
        n6289) );
  AO22X1 U4094 ( .A0(RxShft[10]), .A1(n6646), .B0(RxShft[9]), .B1(n6647), .Y(
        n6290) );
  AO22X1 U4095 ( .A0(RxShft[9]), .A1(n6646), .B0(RxShft[8]), .B1(n6647), .Y(
        n6291) );
  AO22X1 U4096 ( .A0(RxShft[8]), .A1(n6646), .B0(RxShft[7]), .B1(n6647), .Y(
        n6292) );
  AO22X1 U4097 ( .A0(RxShft[7]), .A1(n6646), .B0(RxShft[6]), .B1(n6647), .Y(
        n6293) );
  AO22X1 U4098 ( .A0(RxShft[6]), .A1(n6646), .B0(RxShft[5]), .B1(n6647), .Y(
        n6294) );
  AO22X1 U4099 ( .A0(RxShft[5]), .A1(n6646), .B0(RxShft[4]), .B1(n6647), .Y(
        n6295) );
  AO22X1 U4100 ( .A0(RxShft[4]), .A1(n6646), .B0(RxShft[3]), .B1(n6647), .Y(
        n6296) );
  AO22X1 U4101 ( .A0(RxShft[3]), .A1(n6646), .B0(RxShft[2]), .B1(n6647), .Y(
        n6297) );
  AO22X1 U4102 ( .A0(RxShft[2]), .A1(n6646), .B0(RxShft[1]), .B1(n6647), .Y(
        n6298) );
  AO22X1 U4103 ( .A0(RxShft[1]), .A1(n6646), .B0(RxShft[0]), .B1(n6647), .Y(
        n6299) );
  AO22X1 U4104 ( .A0(RxShft[0]), .A1(n6646), .B0(IntSSPRXD), .B1(n6647), .Y(
        n6300) );
  AO22X1 U4105 ( .A0(MRxFWrData[14]), .A1(n6848), .B0(n6849), .B1(RxShft[13]), 
        .Y(n6243) );
  AO22X1 U4106 ( .A0(MRxFWrData[13]), .A1(n6848), .B0(n6849), .B1(RxShft[12]), 
        .Y(n6244) );
  AO22X1 U4107 ( .A0(MRxFWrData[12]), .A1(n6848), .B0(n6849), .B1(RxShft[11]), 
        .Y(n6245) );
  AO22X1 U4108 ( .A0(MRxFWrData[11]), .A1(n6848), .B0(n6849), .B1(RxShft[10]), 
        .Y(n6246) );
  AO22X1 U4109 ( .A0(MRxFWrData[10]), .A1(n6848), .B0(n6849), .B1(RxShft[9]), 
        .Y(n6247) );
  AO22X1 U4110 ( .A0(MRxFWrData[9]), .A1(n6848), .B0(n6849), .B1(RxShft[8]), 
        .Y(n6248) );
  AO22X1 U4111 ( .A0(MRxFWrData[8]), .A1(n6848), .B0(n6849), .B1(RxShft[7]), 
        .Y(n6249) );
  AO22X1 U4112 ( .A0(MRxFWrData[7]), .A1(n6848), .B0(n6849), .B1(RxShft[6]), 
        .Y(n6250) );
  AO22X1 U4113 ( .A0(MRxFWrData[6]), .A1(n6848), .B0(n6849), .B1(RxShft[5]), 
        .Y(n6251) );
  AO22X1 U4114 ( .A0(MRxFWrData[5]), .A1(n6848), .B0(n6849), .B1(RxShft[4]), 
        .Y(n6252) );
  AO22X1 U4115 ( .A0(MRxFWrData[4]), .A1(n6848), .B0(n6849), .B1(RxShft[3]), 
        .Y(n6253) );
  AO22X1 U4116 ( .A0(MRxFWrData[3]), .A1(n6848), .B0(n6849), .B1(RxShft[2]), 
        .Y(n6254) );
  AO22X1 U4117 ( .A0(MRxFWrData[2]), .A1(n6848), .B0(n6849), .B1(RxShft[1]), 
        .Y(n6255) );
  AO22X1 U4118 ( .A0(MRxFWrData[1]), .A1(n6848), .B0(n6849), .B1(RxShft[0]), 
        .Y(n6256) );
  AO22X1 U4119 ( .A0(MRxFWrData[0]), .A1(n6848), .B0(n6849), .B1(IntSSPRXD), 
        .Y(n6257) );
  AO22X1 U4120 ( .A0(TxShft_0_), .A1(n6907), .B0(TxFRdDataIn[0]), .B1(n6660), 
        .Y(n6285) );
  INVX1 U4121 ( .A(n6661), .Y(n6660) );
  OAI221X1 U4122 ( .A0(n6419), .A1(n6409), .B0(n6870), .B1(n6512), .C0(n6626), 
        .Y(n6301) );
  AOI31X1 U4123 ( .A0(n6447), .A1(n6401), .A2(n6627), .B0(n6628), .Y(n6626) );
  AO21X1 U4124 ( .A0(TxDataAvlblSync), .A1(n6386), .B0(n6505), .Y(n6627) );
  AO21X1 U4125 ( .A0(n6401), .A1(n6422), .B0(n6495), .Y(n6628) );
  AO22X1 U4126 ( .A0(nOE), .A1(n6459), .B0(n6460), .B1(n6461), .Y(n6308) );
  INVX1 U4127 ( .A(n6461), .Y(n6459) );
  OAI211X1 U4128 ( .A0(n6892), .A1(n6477), .B0(n6478), .C0(n6479), .Y(n6461)
         );
  AO21X1 U4129 ( .A0(n6341), .A1(n6462), .B0(n6463), .Y(n6460) );
  INVX1 U4130 ( .A(DSS[3]), .Y(n6592) );
  AO21X1 U4131 ( .A0(FSSOUT), .A1(n6343), .B0(n6344), .Y(n6311) );
  OAI32X1 U4132 ( .A0(n6343), .A1(FRF[0]), .A2(n6345), .B0(n6343), .B1(n6346), 
        .Y(n6344) );
  AOI221X1 U4133 ( .A0(n6358), .A1(n6359), .B0(n6360), .B1(n6873), .C0(n6362), 
        .Y(n6345) );
  OAI31X1 U4134 ( .A0(n6347), .A1(n6348), .A2(n6349), .B0(n6341), .Y(n6346) );
  AO21X1 U4135 ( .A0(SCR[7]), .A1(n6778), .B0(n6789), .Y(n6258) );
  AO22X1 U4136 ( .A0(BitPeriodCnt[7]), .A1(n6872), .B0(n5695), .B1(n6781), .Y(
        n6789) );
  XNOR2X1 U1_A_7 ( .A(BitPeriodCnt[7]), .B(carry_7_), .Y(n5695) );
  OR2X1 U1_B_6 ( .A(BitPeriodCnt[6]), .B(carry_6_), .Y(carry_7_) );
  AO21X1 U4137 ( .A0(SCR[6]), .A1(n6778), .B0(n6788), .Y(n6259) );
  AO22X1 U4138 ( .A0(BitPeriodCnt[6]), .A1(n6872), .B0(n5696), .B1(n6781), .Y(
        n6788) );
  XNOR2X1 U1_A_6 ( .A(BitPeriodCnt[6]), .B(carry_6_), .Y(n5696) );
  AO21X1 U4139 ( .A0(SCR[5]), .A1(n6778), .B0(n6787), .Y(n6260) );
  AO22X1 U4140 ( .A0(BitPeriodCnt[5]), .A1(n6872), .B0(n5697), .B1(n6781), .Y(
        n6787) );
  XNOR2X1 U1_A_5 ( .A(BitPeriodCnt[5]), .B(carry_5_), .Y(n5697) );
  AO21X1 U4141 ( .A0(SCR[4]), .A1(n6778), .B0(n6786), .Y(n6261) );
  AO22X1 U4142 ( .A0(BitPeriodCnt[4]), .A1(n6872), .B0(n5698), .B1(n6781), .Y(
        n6786) );
  XNOR2X1 U1_A_4 ( .A(BitPeriodCnt[4]), .B(carry_4_), .Y(n5698) );
  AO21X1 U4143 ( .A0(SCR[3]), .A1(n6778), .B0(n6785), .Y(n6262) );
  AO22X1 U4144 ( .A0(BitPeriodCnt[3]), .A1(n6872), .B0(n5699), .B1(n6781), .Y(
        n6785) );
  XNOR2X1 U1_A_3 ( .A(BitPeriodCnt[3]), .B(carry_3_), .Y(n5699) );
  AO21X1 U4145 ( .A0(SCR[2]), .A1(n6778), .B0(n6784), .Y(n6263) );
  AO22X1 U4146 ( .A0(BitPeriodCnt[2]), .A1(n6872), .B0(n5700), .B1(n6781), .Y(
        n6784) );
  XNOR2X1 U1_A_2 ( .A(BitPeriodCnt[2]), .B(carry_2_), .Y(n5700) );
  AO21X1 U4147 ( .A0(SCR[1]), .A1(n6778), .B0(n6783), .Y(n6264) );
  AO22X1 U4148 ( .A0(BitPeriodCnt[1]), .A1(n6872), .B0(n5701), .B1(n6781), .Y(
        n6783) );
  XNOR2X1 U1_A_1 ( .A(BitPeriodCnt[1]), .B(BitPeriodCnt[0]), .Y(n5701) );
  AO21X1 U4149 ( .A0(SCR[0]), .A1(n6778), .B0(n6779), .Y(n6265) );
  AO22X1 U4150 ( .A0(BitPeriodCnt[0]), .A1(n6872), .B0(n6781), .B1(n6889), .Y(
        n6779) );
  AO21X1 U4151 ( .A0(BitCnt[3]), .A1(n6748), .B0(n6753), .Y(n6266) );
  OAI33X1 U4152 ( .A0(n6743), .A1(n6751), .A2(n6592), .B0(n6743), .B1(n6746), 
        .B2(n6754), .Y(n6753) );
  OA21X2 U4153 ( .A0(n6877), .A1(n6903), .B0(n6756), .Y(n6754) );
  OAI2BB1X1 U4154 ( .A0N(TXD), .A1N(n6417), .B0(n6430), .Y(n6309) );
  AOI32X1 U4155 ( .A0(n6431), .A1(n6341), .A2(n6432), .B0(NextSTXD), .B1(
        MSSync), .Y(n6430) );
  OAI222X1 U4156 ( .A0(n6433), .A1(n6354), .B0(n6355), .B1(n6434), .C0(n6435), 
        .C1(n6878), .Y(n6431) );
  AOI31X1 U4157 ( .A0(SspMTxRxState[3]), .A1(n6887), .A2(n6529), .B0(n6828), 
        .Y(n6827) );
  OAI31X1 U4158 ( .A0(n6794), .A1(n6474), .A2(n6374), .B0(n6454), .Y(n6828) );
  INVX1 U4159 ( .A(n6363), .Y(n6343) );
  NAND2BX1 U4160 ( .AN(n6364), .B(n6365), .Y(n6363) );
  AOI211X1 U4161 ( .A0(SspMTxRxState[5]), .A1(n6366), .B0(n6367), .C0(n6368), 
        .Y(n6365) );
  OAI31X1 U4162 ( .A0(n6369), .A1(n6353), .A2(n6370), .B0(n6371), .Y(n6368) );
  AOI31X1 U4163 ( .A0(n6437), .A1(n6384), .A2(n6438), .B0(n6439), .Y(n6435) );
  NOR2BX1 U4164 ( .AN(n6886), .B(SspMTxRxState[5]), .Y(n6437) );
  NAND3BX1 U4165 ( .AN(n6440), .B(n6441), .C(n6442), .Y(n6439) );
  INVX1 U4166 ( .A(n6443), .Y(n6442) );
  AO21X1 U4167 ( .A0(n6497), .A1(SspMTxRxState[5]), .B0(n6722), .Y(n6483) );
  OAI31X1 U4168 ( .A0(n6723), .A1(n6475), .A2(n6517), .B0(n6724), .Y(n6722) );
  OA21X2 U4169 ( .A0(n6726), .A1(n6428), .B0(n6534), .Y(n6723) );
  INVX1 U4170 ( .A(n6725), .Y(n6724) );
  NAND2BX1 U4171 ( .AN(n6582), .B(n6423), .Y(n6369) );
  OAI33X1 U4172 ( .A0(n6583), .A1(n6584), .A2(n6894), .B0(n6583), .B1(DSS[1]), 
        .B2(BitCnt[0]), .Y(n6582) );
  INVX1 U4173 ( .A(DSS[1]), .Y(n6584) );
  INVX1 U4174 ( .A(n6586), .Y(n6583) );
  INVX1 U4175 ( .A(n6506), .Y(n6457) );
  OAI31X1 U4176 ( .A0(n6357), .A1(FRF[1]), .A2(n6475), .B0(n6507), .Y(n6506)
         );
  AOI32X1 U4177 ( .A0(SspMTxRxState[5]), .A1(n6508), .A2(n6469), .B0(n6498), 
        .B1(n6405), .Y(n6507) );
  NAND2BX1 U4178 ( .AN(SspMTxRxState[5]), .B(n6657), .Y(n6541) );
  XOR2X1 U4179 ( .A(DelCLKOUT), .B(CLKOUT), .Y(MRxRT) );
  NAND3BX1 U4180 ( .AN(SspMTxRxState[3]), .B(n6914), .C(TxDataAvlblSync), .Y(
        n6774) );
  NOR2BX1 U4181 ( .AN(n6405), .B(SspMTxRxState[5]), .Y(n6400) );
  NAND3BX1 U4182 ( .AN(SspMTxRxState[1]), .B(TxFRdDataIn[15]), .C(n6403), .Y(
        n6433) );
  AO22X1 U4183 ( .A0(n6761), .A1(n6870), .B0(n6762), .B1(n6887), .Y(n6739) );
  AO22X1 U4184 ( .A0(SspMTxRxState[0]), .A1(n6869), .B0(n6732), .B1(n6886), 
        .Y(n6761) );
  OAI222X1 U4185 ( .A0(n6503), .A1(n6504), .B0(n6645), .B1(n6553), .C0(FRF[0]), 
        .C1(n6625), .Y(n6644) );
  INVX1 U4186 ( .A(n6508), .Y(n6645) );
  OR2X1 U1_B_1 ( .A(BitPeriodCnt[1]), .B(BitPeriodCnt[0]), .Y(carry_2_) );
  OR2X1 U1_B_2 ( .A(BitPeriodCnt[2]), .B(carry_2_), .Y(carry_3_) );
  OR2X1 U1_B_4 ( .A(BitPeriodCnt[4]), .B(carry_4_), .Y(carry_5_) );
  OR2X1 U1_B_5 ( .A(BitPeriodCnt[5]), .B(carry_5_), .Y(carry_6_) );
  OR2X1 U1_B_3 ( .A(BitPeriodCnt[3]), .B(carry_3_), .Y(carry_4_) );
  OAI222X1 U4187 ( .A0(n6423), .A1(n6441), .B0(TxDataAvlblSync), .B1(n6561), 
        .C0(n6532), .C1(n6542), .Y(n6560) );
  INVX1 U4188 ( .A(SPO), .Y(n6375) );
  AOI211X1 U4189 ( .A0(n6490), .A1(n6491), .B0(SspMTxRxState[5]), .C0(n6362), 
        .Y(n6489) );
  NAND3BX1 U4190 ( .AN(SspMTxRxState[0]), .B(n6384), .C(n6492), .Y(n6491) );
  AOI33X1 U4191 ( .A0(SspMTxRxState[3]), .A1(n6886), .A2(n6473), .B0(n6869), 
        .B1(n6874), .B2(n6493), .Y(n6490) );
  OAI21X1 U4192 ( .A0(n6912), .A1(n6488), .B0(n6913), .Y(n6307) );
  AOI22X1 U4193 ( .A0(NextSTxRxBSY), .A1(MSSync), .B0(n6488), .B1(n6489), .Y(
        n6913) );
  NAND3BX1 U4194 ( .AN(n6494), .B(n6905), .C(n6458), .Y(n6488) );
  NOR2X1 U4195 ( .A(TxFRdPtrInc), .B(MSSync), .Y(n6337) );
  NAND3BX1 U4196 ( .AN(SspMTxRxState[5]), .B(TxFRdDataIn[15]), .C(
        SspMTxRxState[0]), .Y(n6434) );
  INVX1 U4197 ( .A(SSESync), .Y(n6465) );
  INVX1 U4198 ( .A(TxFRdDataIn[1]), .Y(n6667) );
  INVX1 U4199 ( .A(TxFRdDataIn[14]), .Y(n6706) );
  INVX1 U4200 ( .A(TxFRdDataIn[13]), .Y(n6703) );
  INVX1 U4201 ( .A(TxFRdDataIn[12]), .Y(n6700) );
  INVX1 U4202 ( .A(TxFRdDataIn[11]), .Y(n6697) );
  INVX1 U4203 ( .A(TxFRdDataIn[10]), .Y(n6694) );
  INVX1 U4204 ( .A(TxFRdDataIn[9]), .Y(n6691) );
  INVX1 U4205 ( .A(TxFRdDataIn[8]), .Y(n6688) );
  INVX1 U4206 ( .A(TxFRdDataIn[7]), .Y(n6685) );
  INVX1 U4207 ( .A(TxFRdDataIn[6]), .Y(n6682) );
  INVX1 U4208 ( .A(TxFRdDataIn[5]), .Y(n6679) );
  INVX1 U4209 ( .A(TxFRdDataIn[4]), .Y(n6676) );
  INVX1 U4210 ( .A(TxFRdDataIn[3]), .Y(n6673) );
  INVX1 U4211 ( .A(TxFRdDataIn[2]), .Y(n6670) );
  DFFRX1 SspMTxRxState_reg_0_ ( .D(n6306), .CK(PCLK), .RN(PRESETn), .Q(
        SspMTxRxState[0]), .QN(n6873) );
  DFFSX1 SspMTxRxState_reg_1_ ( .D(n6305), .CK(PCLK), .SN(PRESETn), .Q(
        SspMTxRxState[1]), .QN(n6886) );
  DFFSX1 SspMTxRxState_reg_4_ ( .D(n6302), .CK(PCLK), .SN(PRESETn), .Q(
        SspMTxRxState[4]), .QN(n6874) );
  DFFRX1 TxDataAvlblSync_reg ( .D(TxDataAvlbl), .CK(PCLK), .RN(PRESETn), .Q(
        TxDataAvlblSync), .QN(n6892) );
  DFFRX1 SspMTxRxState_reg_3_ ( .D(n6303), .CK(PCLK), .RN(PRESETn), .Q(
        SspMTxRxState[3]), .QN(n6869) );
  DFFRX1 BitPeriodCnt_reg_0_ ( .D(n6265), .CK(PCLK), .RN(PRESETn), .Q(
        BitPeriodCnt[0]), .QN(n6889) );
  DFFRX1 BitPeriodCnt_reg_6_ ( .D(n6259), .CK(PCLK), .RN(PRESETn), .Q(
        BitPeriodCnt[6]), .QN(n6868) );
  DFFRX1 BitPeriodCnt_reg_5_ ( .D(n6260), .CK(PCLK), .RN(PRESETn), .Q(
        BitPeriodCnt[5]), .QN(n6876) );
  DFFRX1 BitPeriodCnt_reg_4_ ( .D(n6261), .CK(PCLK), .RN(PRESETn), .Q(
        BitPeriodCnt[4]), .QN(n6871) );
  DFFRX1 BitPeriodCnt_reg_2_ ( .D(n6263), .CK(PCLK), .RN(PRESETn), .Q(
        BitPeriodCnt[2]), .QN(n6891) );
  DFFRX1 BitCnt_reg_3_ ( .D(n6266), .CK(PCLK), .RN(PRESETn), .Q(BitCnt[3]), 
        .QN(n6903) );
  DFFRX1 BitPeriodCnt_reg_7_ ( .D(n6258), .CK(PCLK), .RN(PRESETn), .Q(
        BitPeriodCnt[7]), .QN(n6890) );
  DFFRX1 BitCnt_reg_0_ ( .D(n6269), .CK(PCLK), .RN(PRESETn), .Q(BitCnt[0]), 
        .QN(n6894) );
  DFFRX1 BitCnt_reg_2_ ( .D(n6267), .CK(PCLK), .RN(PRESETn), .Q(BitCnt[2]), 
        .QN(n6877) );
  DFFRX1 BitCnt_reg_1_ ( .D(n6268), .CK(PCLK), .RN(PRESETn), .Q(BitCnt[1]), 
        .QN(n6875) );
  DFFRX1 BitPeriodCnt_reg_3_ ( .D(n6262), .CK(PCLK), .RN(PRESETn), .Q(
        BitPeriodCnt[3]) );
  DFFRX1 BitPeriodCnt_reg_1_ ( .D(n6264), .CK(PCLK), .RN(PRESETn), .Q(
        BitPeriodCnt[1]) );
  DFFRX1 SspMTxRxState_reg_2_ ( .D(n6304), .CK(PCLK), .RN(PRESETn), .Q(
        SspMTxRxState[2]), .QN(n6887) );
  DFFRX1 TxFRdPtrInc_reg ( .D(n6312), .CK(PCLK), .RN(PRESETn), .Q(TxFRdPtrInc)
         );
  DFFRX1 RxFWr_reg ( .D(n6313), .CK(PCLK), .RN(PRESETn), .Q(RxFWr), .QN(n6904)
         );
  DFFRX1 CLKOUT_reg ( .D(n6310), .CK(PCLK), .RN(PRESETn), .Q(CLKOUT) );
  DFFRX1 IncRxTimeOut_reg ( .D(NextIncRxTimeOut), .CK(PCLK), .RN(PRESETn), .Q(
        IncRxTimeOut) );
  DFFRX1 DelCLKOUT_reg ( .D(CLKOUT), .CK(PCLK), .RN(PRESETn), .Q(DelCLKOUT) );
  DFFRX1 TxShft_reg_0_ ( .D(n6285), .CK(PCLK), .RN(PRESETn), .Q(TxShft_0_), 
        .QN(n6895) );
  DFFRX1 TxShft_reg_15_ ( .D(n6270), .CK(PCLK), .RN(PRESETn), .QN(n6878) );
  DFFRX1 TxShft_reg_14_ ( .D(n6271), .CK(PCLK), .RN(PRESETn), .QN(n6902) );
  DFFRX1 TxShft_reg_13_ ( .D(n6272), .CK(PCLK), .RN(PRESETn), .QN(n6880) );
  DFFRX1 TxShft_reg_12_ ( .D(n6273), .CK(PCLK), .RN(PRESETn), .QN(n6896) );
  DFFRX1 TxShft_reg_11_ ( .D(n6274), .CK(PCLK), .RN(PRESETn), .QN(n6881) );
  DFFRX1 TxShft_reg_10_ ( .D(n6275), .CK(PCLK), .RN(PRESETn), .QN(n6897) );
  DFFRX1 TxShft_reg_9_ ( .D(n6276), .CK(PCLK), .RN(PRESETn), .QN(n6882) );
  DFFRX1 TxShft_reg_8_ ( .D(n6277), .CK(PCLK), .RN(PRESETn), .QN(n6898) );
  DFFRX1 TxShft_reg_7_ ( .D(n6278), .CK(PCLK), .RN(PRESETn), .QN(n6883) );
  DFFRX1 TxShft_reg_6_ ( .D(n6279), .CK(PCLK), .RN(PRESETn), .QN(n6899) );
  DFFRX1 TxShft_reg_5_ ( .D(n6280), .CK(PCLK), .RN(PRESETn), .QN(n6884) );
  DFFRX1 TxShft_reg_4_ ( .D(n6281), .CK(PCLK), .RN(PRESETn), .QN(n6900) );
  DFFRX1 TxShft_reg_3_ ( .D(n6282), .CK(PCLK), .RN(PRESETn), .QN(n6885) );
  DFFRX1 TxShft_reg_2_ ( .D(n6283), .CK(PCLK), .RN(PRESETn), .QN(n6901) );
  DFFRX1 TxShft_reg_1_ ( .D(n6284), .CK(PCLK), .RN(PRESETn), .QN(n6879) );
  DFFRX1 TXD_reg ( .D(n6309), .CK(PCLK), .RN(PRESETn), .Q(TXD) );
  DFFSX1 nOE_reg ( .D(n6308), .CK(PCLK), .SN(PRESETn), .Q(nOE) );
  DFFRX1 RxShft_reg_13_ ( .D(n6287), .CK(PCLK), .RN(PRESETn), .Q(RxShft[13])
         );
  DFFRX1 RxShft_reg_12_ ( .D(n6288), .CK(PCLK), .RN(PRESETn), .Q(RxShft[12])
         );
  DFFRX1 RxShft_reg_11_ ( .D(n6289), .CK(PCLK), .RN(PRESETn), .Q(RxShft[11])
         );
  DFFRX1 RxShft_reg_10_ ( .D(n6290), .CK(PCLK), .RN(PRESETn), .Q(RxShft[10])
         );
  DFFRX1 RxShft_reg_9_ ( .D(n6291), .CK(PCLK), .RN(PRESETn), .Q(RxShft[9]) );
  DFFRX1 RxShft_reg_8_ ( .D(n6292), .CK(PCLK), .RN(PRESETn), .Q(RxShft[8]) );
  DFFRX1 RxShft_reg_7_ ( .D(n6293), .CK(PCLK), .RN(PRESETn), .Q(RxShft[7]) );
  DFFRX1 RxShft_reg_6_ ( .D(n6294), .CK(PCLK), .RN(PRESETn), .Q(RxShft[6]) );
  DFFRX1 RxShft_reg_5_ ( .D(n6295), .CK(PCLK), .RN(PRESETn), .Q(RxShft[5]) );
  DFFRX1 RxShft_reg_4_ ( .D(n6296), .CK(PCLK), .RN(PRESETn), .Q(RxShft[4]) );
  DFFRX1 RxShft_reg_3_ ( .D(n6297), .CK(PCLK), .RN(PRESETn), .Q(RxShft[3]) );
  DFFRX1 RxShft_reg_2_ ( .D(n6298), .CK(PCLK), .RN(PRESETn), .Q(RxShft[2]) );
  DFFRX1 RxShft_reg_1_ ( .D(n6299), .CK(PCLK), .RN(PRESETn), .Q(RxShft[1]) );
  DFFRX1 RxShft_reg_0_ ( .D(n6300), .CK(PCLK), .RN(PRESETn), .Q(RxShft[0]) );
  DFFRX1 TxRxBSY_reg ( .D(n6307), .CK(PCLK), .RN(PRESETn), .Q(TxRxBSY), .QN(
        n6912) );
  DFFRX1 MRxFWrData_reg_15_ ( .D(n6242), .CK(PCLK), .RN(PRESETn), .Q(
        MRxFWrData[15]) );
  DFFRX1 MRxFWrData_reg_14_ ( .D(n6243), .CK(PCLK), .RN(PRESETn), .Q(
        MRxFWrData[14]) );
  DFFRX1 MRxFWrData_reg_13_ ( .D(n6244), .CK(PCLK), .RN(PRESETn), .Q(
        MRxFWrData[13]) );
  DFFRX1 MRxFWrData_reg_12_ ( .D(n6245), .CK(PCLK), .RN(PRESETn), .Q(
        MRxFWrData[12]) );
  DFFRX1 MRxFWrData_reg_11_ ( .D(n6246), .CK(PCLK), .RN(PRESETn), .Q(
        MRxFWrData[11]) );
  DFFRX1 MRxFWrData_reg_10_ ( .D(n6247), .CK(PCLK), .RN(PRESETn), .Q(
        MRxFWrData[10]) );
  DFFRX1 MRxFWrData_reg_9_ ( .D(n6248), .CK(PCLK), .RN(PRESETn), .Q(
        MRxFWrData[9]) );
  DFFRX1 MRxFWrData_reg_8_ ( .D(n6249), .CK(PCLK), .RN(PRESETn), .Q(
        MRxFWrData[8]) );
  DFFRX1 MRxFWrData_reg_7_ ( .D(n6250), .CK(PCLK), .RN(PRESETn), .Q(
        MRxFWrData[7]) );
  DFFRX1 MRxFWrData_reg_6_ ( .D(n6251), .CK(PCLK), .RN(PRESETn), .Q(
        MRxFWrData[6]) );
  DFFRX1 MRxFWrData_reg_5_ ( .D(n6252), .CK(PCLK), .RN(PRESETn), .Q(
        MRxFWrData[5]) );
  DFFRX1 MRxFWrData_reg_4_ ( .D(n6253), .CK(PCLK), .RN(PRESETn), .Q(
        MRxFWrData[4]) );
  DFFRX1 MRxFWrData_reg_3_ ( .D(n6254), .CK(PCLK), .RN(PRESETn), .Q(
        MRxFWrData[3]) );
  DFFRX1 MRxFWrData_reg_2_ ( .D(n6255), .CK(PCLK), .RN(PRESETn), .Q(
        MRxFWrData[2]) );
  DFFRX1 MRxFWrData_reg_1_ ( .D(n6256), .CK(PCLK), .RN(PRESETn), .Q(
        MRxFWrData[1]) );
  DFFRX1 MRxFWrData_reg_0_ ( .D(n6257), .CK(PCLK), .RN(PRESETn), .Q(
        MRxFWrData[0]) );
  DFFSX1 FSSOUT_reg ( .D(n6311), .CK(PCLK), .SN(PRESETn), .Q(FSSOUT) );
  DFFRX1 RxShft_reg_14_ ( .D(n6286), .CK(PCLK), .RN(PRESETn), .Q(RxShft[14])
         );
endmodule


module SspScaleCntr ( PCLK, PRESETn, SSESync, SSPCPSR, SSPCLKDIV, SSPCPSC );
  input [7:1] SSPCPSR;
  output [6:0] SSPCPSC;
  input PCLK, PRESETn, SSESync;
  output SSPCLKDIV;
  wire   NextSSPCPSC137_6_, NextSSPCPSC137_5_, NextSSPCPSC137_4_,
         NextSSPCPSC137_3_, NextSSPCPSC137_2_, NextSSPCPSC137_1_, carry_6_,
         carry_5_, carry_4_, carry_3_, carry_2_, n234, n235, n240, n241, n242,
         n243, n245, n246;
  wire   [6:0] NextSSPCPSC;

  INVX1 U94 ( .A(n234), .Y(n235) );
  NOR4X1 U95 ( .A(SSPCPSC[2]), .B(SSPCPSC[1]), .C(n245), .D(n246), .Y(
        SSPCLKDIV) );
  NAND4X1 U96 ( .A(n242), .B(n243), .C(n240), .D(n241), .Y(n246) );
  OR2X1 U1_B_1 ( .A(SSPCPSC[1]), .B(SSPCPSC[0]), .Y(carry_2_) );
  OR2X1 U1_B_2 ( .A(SSPCPSC[2]), .B(carry_2_), .Y(carry_3_) );
  OR2X1 U1_B_3 ( .A(SSPCPSC[3]), .B(carry_3_), .Y(carry_4_) );
  OR2X1 U1_B_4 ( .A(SSPCPSC[4]), .B(carry_4_), .Y(carry_5_) );
  AO22X1 U97 ( .A0(SSPCPSR[7]), .A1(n234), .B0(NextSSPCPSC137_6_), .B1(n235), 
        .Y(NextSSPCPSC[6]) );
  XNOR2X1 U1_A_6 ( .A(SSPCPSC[6]), .B(carry_6_), .Y(NextSSPCPSC137_6_) );
  OR2X1 U1_B_5 ( .A(SSPCPSC[5]), .B(carry_5_), .Y(carry_6_) );
  NAND2BX1 U98 ( .AN(SSPCLKDIV), .B(SSESync), .Y(n234) );
  AO22X1 U99 ( .A0(SSPCPSR[1]), .A1(n234), .B0(n235), .B1(n245), .Y(
        NextSSPCPSC[0]) );
  AO22X1 U100 ( .A0(SSPCPSR[2]), .A1(n234), .B0(NextSSPCPSC137_1_), .B1(n235), 
        .Y(NextSSPCPSC[1]) );
  XNOR2X1 U1_A_1 ( .A(SSPCPSC[1]), .B(SSPCPSC[0]), .Y(NextSSPCPSC137_1_) );
  AO22X1 U101 ( .A0(SSPCPSR[3]), .A1(n234), .B0(NextSSPCPSC137_2_), .B1(n235), 
        .Y(NextSSPCPSC[2]) );
  XNOR2X1 U1_A_2 ( .A(SSPCPSC[2]), .B(carry_2_), .Y(NextSSPCPSC137_2_) );
  AO22X1 U102 ( .A0(SSPCPSR[4]), .A1(n234), .B0(NextSSPCPSC137_3_), .B1(n235), 
        .Y(NextSSPCPSC[3]) );
  XNOR2X1 U1_A_3 ( .A(SSPCPSC[3]), .B(carry_3_), .Y(NextSSPCPSC137_3_) );
  AO22X1 U103 ( .A0(SSPCPSR[5]), .A1(n234), .B0(NextSSPCPSC137_4_), .B1(n235), 
        .Y(NextSSPCPSC[4]) );
  XNOR2X1 U1_A_4 ( .A(SSPCPSC[4]), .B(carry_4_), .Y(NextSSPCPSC137_4_) );
  AO22X1 U104 ( .A0(SSPCPSR[6]), .A1(n234), .B0(NextSSPCPSC137_5_), .B1(n235), 
        .Y(NextSSPCPSC[5]) );
  XNOR2X1 U1_A_5 ( .A(SSPCPSC[5]), .B(carry_5_), .Y(NextSSPCPSC137_5_) );
  DFFRX1 SSPCPSC_reg_0_ ( .D(NextSSPCPSC[0]), .CK(PCLK), .RN(PRESETn), .Q(
        SSPCPSC[0]), .QN(n245) );
  DFFRX1 SSPCPSC_reg_2_ ( .D(NextSSPCPSC[2]), .CK(PCLK), .RN(PRESETn), .Q(
        SSPCPSC[2]) );
  DFFRX1 SSPCPSC_reg_1_ ( .D(NextSSPCPSC[1]), .CK(PCLK), .RN(PRESETn), .Q(
        SSPCPSC[1]) );
  DFFRX1 SSPCPSC_reg_6_ ( .D(NextSSPCPSC[6]), .CK(PCLK), .RN(PRESETn), .Q(
        SSPCPSC[6]), .QN(n241) );
  DFFRX1 SSPCPSC_reg_5_ ( .D(NextSSPCPSC[5]), .CK(PCLK), .RN(PRESETn), .Q(
        SSPCPSC[5]), .QN(n240) );
  DFFRX1 SSPCPSC_reg_3_ ( .D(NextSSPCPSC[3]), .CK(PCLK), .RN(PRESETn), .Q(
        SSPCPSC[3]), .QN(n242) );
  DFFRX1 SSPCPSC_reg_4_ ( .D(NextSSPCPSC[4]), .CK(PCLK), .RN(PRESETn), .Q(
        SSPCPSC[4]), .QN(n243) );
endmodule


module SspTest ( PCLK, PRESETn, LBM, SSPRXD, TXMIS, RXMIS, RORINTR, RTINTR, 
        INTR, FSSOUT, CLKOUT, TXD, nCTLOE, nOE, IntSSPRXD, IntSSPINTR, 
        IntSSPTXINTR, IntSSPRXINTR, IntSSPRTINTR, IntSSPRORINTR, IntSSPFSSOUT, 
        IntSSPCLKOUT, IntSSPTXD, IntnSSPCTLOE, IntnSSPOE );
  input PCLK, PRESETn, LBM, SSPRXD, TXMIS, RXMIS, RORINTR, RTINTR, INTR,
         FSSOUT, CLKOUT, TXD, nCTLOE, nOE;
  output IntSSPRXD, IntSSPINTR, IntSSPTXINTR, IntSSPRXINTR, IntSSPRTINTR,
         IntSSPRORINTR, IntSSPFSSOUT, IntSSPCLKOUT, IntSSPTXD, IntnSSPCTLOE,
         IntnSSPOE;
  wire   INTR0, TXMIS0, RXMIS0, RTINTR0, RORINTR0, nOE0, nCTLOE0, CLKOUT0,
         FSSOUT0, TXD0, n159;
  assign IntSSPINTR = INTR0;
  assign INTR0 = INTR;
  assign IntSSPTXINTR = TXMIS0;
  assign TXMIS0 = TXMIS;
  assign IntSSPRXINTR = RXMIS0;
  assign RXMIS0 = RXMIS;
  assign IntSSPRTINTR = RTINTR0;
  assign RTINTR0 = RTINTR;
  assign IntSSPRORINTR = RORINTR0;
  assign RORINTR0 = RORINTR;
  assign IntnSSPOE = nOE0;
  assign nOE0 = nOE;
  assign IntnSSPCTLOE = nCTLOE0;
  assign nCTLOE0 = nCTLOE;
  assign IntSSPCLKOUT = CLKOUT0;
  assign CLKOUT0 = CLKOUT;
  assign IntSSPFSSOUT = FSSOUT0;
  assign FSSOUT0 = FSSOUT;
  assign IntSSPTXD = TXD0;
  assign TXD0 = TXD;

  AO22X1 U21 ( .A0(TXD0), .A1(LBM), .B0(SSPRXD), .B1(n159), .Y(IntSSPRXD) );
  INVX1 U22 ( .A(LBM), .Y(n159) );
endmodule


module SspIntGen ( TXMIS, RXMIS, RORMIS, DataStp, RTIMSync, RORIC, RTIC, 
        RORINTR, RTINTR, INTR );
  input TXMIS, RXMIS, RORMIS, DataStp, RTIMSync, RORIC, RTIC;
  output RORINTR, RTINTR, INTR;
  wire   n56, n57;

  NAND3BX1 U17 ( .AN(RTIC), .B(DataStp), .C(RTIMSync), .Y(n56) );
  NAND2BX1 U18 ( .AN(RORIC), .B(RORMIS), .Y(n57) );
  OR4X1 U19 ( .A(TXMIS), .B(RXMIS), .C(RORINTR), .D(RTINTR), .Y(INTR) );
  INVX1 U20 ( .A(n57), .Y(RORINTR) );
  INVX1 U21 ( .A(n56), .Y(RTINTR) );
endmodule


module SspRxFIFO ( PCLK, PRESETn, RXIM, RORIM, RORIC, RxFWrSync, RxFRdPtrInc, 
        MS, SRxFWrData, MRxFWrData, RxDMALevel, RNE, RFF, RXRIS, RORRIS, RXMIS, 
        RORMIS, RxFRdData, RxFFillLevel );
  input [15:0] SRxFWrData;
  input [15:0] MRxFWrData;
  input [3:0] RxDMALevel;
  output [15:0] RxFRdData;
  output [3:0] RxFFillLevel;
  input PCLK, PRESETn, RXIM, RORIM, RORIC, RxFWrSync, RxFRdPtrInc, MS;
  output RNE, RFF, RXRIS, RORRIS, RXMIS, RORMIS;
  wire   RegFileWrEn;
  wire   [2:0] WrPtr;
  wire   [2:0] RdPtr;

  SspRxFCntl uSspRxFCntl ( .PCLK(PCLK), .PRESETn(PRESETn), .RXIM(RXIM), 
        .RORIM(RORIM), .RORIC(RORIC), .RxFWrSync(RxFWrSync), .RxFRdPtrInc(
        RxFRdPtrInc), .RxDMALevel(RxDMALevel), .RNE(RNE), .RFF(RFF), .RXRIS(
        RXRIS), .RORRIS(RORRIS), .RXMIS(RXMIS), .RORMIS(RORMIS), .RegFileWrEn(
        RegFileWrEn), .WrPtr(WrPtr), .RdPtr(RdPtr), .RxFFillLevel(RxFFillLevel) );
  SspRxRegFile uSspRxRegFile ( .PCLK(PCLK), .PRESETn(PRESETn), .MS(MS), 
        .RegFileWrEn(RegFileWrEn), .WrPtr(WrPtr), .RdPtr(RdPtr), .SRxFWrData(
        SRxFWrData), .MRxFWrData(MRxFWrData), .RxFRdData(RxFRdData) );
endmodule


module SspRxRegFile ( PCLK, PRESETn, MS, RegFileWrEn, WrPtr, RdPtr, SRxFWrData, 
        MRxFWrData, RxFRdData );
  input [2:0] WrPtr;
  input [2:0] RdPtr;
  input [15:0] SRxFWrData;
  input [15:0] MRxFWrData;
  output [15:0] RxFRdData;
  input PCLK, PRESETn, MS, RegFileWrEn;
  wire   n1063, n1064, n1065, n1066, n1067, n1068, n1069, n1070, n1071, n1072,
         n1073, n1074, n1075, n1076, n1077, n1078, n1079, n1080, n1081, n1082,
         n1083, n1084, n1085, n1086, n1087, n1088, n1089, n1090, n1091, n1092,
         n1093, n1094, n1095, n1096, n1097, n1098, n1099, n1100, n1101, n1102,
         n1103, n1104, n1105, n1106, n1107, n1108, n1109, n1110, n1111, n1112,
         n1113, n1114, n1115, n1116, n1117, n1118, n1119, n1120, n1121, n1122,
         n1123, n1124, n1125, n1126, n1127, n1128, n1129, n1130, n1131, n1132,
         n1133, n1134, n1135, n1136, n1137, n1138, n1139, n1140, n1141, n1142,
         n1143, n1144, n1145, n1146, n1147, n1148, n1149, n1150, n1151, n1152,
         n1153, n1154, n1155, n1156, n1157, n1158, n1159, n1160, n1161, n1162,
         n1163, n1164, n1165, n1166, n1167, n1168, n1169, n1170, n1171, n1172,
         n1173, n1174, n1175, n1176, n1177, n1178, n1179, n1180, n1181, n1182,
         n1183, n1184, n1185, n1186, n1187, n1188, n1189, n1190, n1199, n1201,
         n1202, n1203, n1204, n1205, n1206, n1207, n1208, n1209, n1210, n1211,
         n1212, n1213, n1214, n1215, n1216, n1219, n1220, n1221, n1222, n1223,
         n1224, n1225, n1228, n1229, n1230, n1231, n1232, n1233, n1234, n1235,
         n1236, n1237, n1238, n1240, n1241, n1242, n1243, n1244, n1245, n1246,
         n1247, n1248, n1249, n1250, n1252, n1253, n1254, n1256, n1257, n1258,
         n1260, n1261, n1262, n1264, n1265, n1266, n1268, n1269, n1270, n1272,
         n1273, n1274, n1276, n1277, n1278, n1280, n1281, n1282, n1284, n1285,
         n1286, n1288, n1289, n1290, n1292, n1293, n1294, n1296, n1297, n1298,
         n1300, n1301, n1302, n1304, n1305, n1306, n1308, n1309, n1310, n1311,
         n1312, n1313, n1314, n1315, n1316, n1317, n1318, n1319, n1320, n1321,
         n1322, n1323, n1324, n1325, n1326, n1327, n1328, n1329, n1330, n1331,
         n1332, n1333, n1334, n1335, n1336, n1337, n1338, n1339, n1340, n1341,
         n1342, n1343, n1344;
  wire   [15:0] RxReg0;
  wire   [15:0] RxReg1;
  wire   [15:0] RxReg2;
  wire   [15:0] RxReg3;
  wire   [15:0] RxReg4;
  wire   [15:0] RxReg5;
  wire   [15:0] RxReg6;
  wire   [15:0] RxReg7;

  INVX1 U978 ( .A(n1340), .Y(n1232) );
  INVX1 U979 ( .A(n1341), .Y(n1229) );
  INVX1 U980 ( .A(n1344), .Y(n1220) );
  INVX1 U981 ( .A(n1339), .Y(n1234) );
  INVX1 U982 ( .A(n1343), .Y(n1222) );
  INVX1 U983 ( .A(n1338), .Y(n1236) );
  INVX1 U984 ( .A(n1342), .Y(n1224) );
  NAND4BX1 U985 ( .AN(n1315), .B(n1312), .C(n1311), .D(n1310), .Y(n1240) );
  INVX1 U986 ( .A(n1311), .Y(n1244) );
  INVX1 U987 ( .A(n1312), .Y(n1243) );
  INVX1 U988 ( .A(n1310), .Y(n1245) );
  BUFX2 U989 ( .A(n1231), .Y(n1340) );
  NAND3BX1 U990 ( .AN(WrPtr[0]), .B(WrPtr[1]), .C(n1230), .Y(n1231) );
  BUFX2 U991 ( .A(n1228), .Y(n1341) );
  NAND3BX1 U992 ( .AN(n1225), .B(WrPtr[1]), .C(n1230), .Y(n1228) );
  BUFX2 U993 ( .A(n1219), .Y(n1344) );
  NAND3BX1 U994 ( .AN(WrPtr[0]), .B(WrPtr[1]), .C(n1337), .Y(n1219) );
  BUFX2 U995 ( .A(n1233), .Y(n1339) );
  NAND3BX1 U996 ( .AN(WrPtr[1]), .B(WrPtr[0]), .C(n1230), .Y(n1233) );
  BUFX2 U997 ( .A(n1221), .Y(n1343) );
  NAND3BX1 U998 ( .AN(WrPtr[1]), .B(WrPtr[0]), .C(n1337), .Y(n1221) );
  AND3X2 U999 ( .A(WrPtr[1]), .B(WrPtr[0]), .C(n1337), .Y(n1336) );
  INVX1 U1000 ( .A(n1336), .Y(n1199) );
  BUFX2 U1001 ( .A(n1235), .Y(n1338) );
  NAND3BX1 U1002 ( .AN(WrPtr[1]), .B(n1225), .C(n1230), .Y(n1235) );
  BUFX2 U1003 ( .A(n1223), .Y(n1342) );
  NAND3BX1 U1004 ( .AN(WrPtr[1]), .B(n1225), .C(n1337), .Y(n1223) );
  INVX1 U1005 ( .A(n1238), .Y(n1230) );
  NAND2BX1 U1006 ( .AN(WrPtr[2]), .B(RegFileWrEn), .Y(n1238) );
  AND2X2 U1007 ( .A(RegFileWrEn), .B(WrPtr[2]), .Y(n1337) );
  AO22X1 U1008 ( .A0(RxReg0[15]), .A1(n1338), .B0(n1236), .B1(n1216), .Y(n1063) );
  AO22X1 U1009 ( .A0(RxReg0[14]), .A1(n1338), .B0(n1236), .B1(n1215), .Y(n1064) );
  AO22X1 U1010 ( .A0(RxReg0[13]), .A1(n1338), .B0(n1236), .B1(n1214), .Y(n1065) );
  AO22X1 U1011 ( .A0(RxReg0[12]), .A1(n1338), .B0(n1236), .B1(n1213), .Y(n1066) );
  AO22X1 U1012 ( .A0(RxReg0[11]), .A1(n1338), .B0(n1236), .B1(n1212), .Y(n1067) );
  AO22X1 U1013 ( .A0(RxReg0[10]), .A1(n1338), .B0(n1236), .B1(n1211), .Y(n1068) );
  AO22X1 U1014 ( .A0(RxReg0[9]), .A1(n1338), .B0(n1236), .B1(n1210), .Y(n1069)
         );
  AO22X1 U1015 ( .A0(RxReg0[8]), .A1(n1338), .B0(n1236), .B1(n1209), .Y(n1070)
         );
  AO22X1 U1016 ( .A0(RxReg0[7]), .A1(n1338), .B0(n1236), .B1(n1208), .Y(n1071)
         );
  AO22X1 U1017 ( .A0(RxReg0[6]), .A1(n1338), .B0(n1236), .B1(n1207), .Y(n1072)
         );
  AO22X1 U1018 ( .A0(RxReg0[5]), .A1(n1338), .B0(n1236), .B1(n1206), .Y(n1073)
         );
  AO22X1 U1019 ( .A0(RxReg0[4]), .A1(n1338), .B0(n1236), .B1(n1205), .Y(n1074)
         );
  AO22X1 U1020 ( .A0(RxReg0[3]), .A1(n1338), .B0(n1236), .B1(n1204), .Y(n1075)
         );
  AO22X1 U1021 ( .A0(RxReg0[2]), .A1(n1338), .B0(n1236), .B1(n1203), .Y(n1076)
         );
  AO22X1 U1022 ( .A0(RxReg0[1]), .A1(n1338), .B0(n1236), .B1(n1202), .Y(n1077)
         );
  AO22X1 U1023 ( .A0(RxReg0[0]), .A1(n1338), .B0(n1236), .B1(n1201), .Y(n1078)
         );
  AO22X1 U1024 ( .A0(RxReg1[15]), .A1(n1339), .B0(n1234), .B1(n1216), .Y(n1079) );
  AO22X1 U1025 ( .A0(RxReg1[14]), .A1(n1339), .B0(n1234), .B1(n1215), .Y(n1080) );
  AO22X1 U1026 ( .A0(RxReg1[13]), .A1(n1339), .B0(n1234), .B1(n1214), .Y(n1081) );
  AO22X1 U1027 ( .A0(RxReg1[12]), .A1(n1339), .B0(n1234), .B1(n1213), .Y(n1082) );
  AO22X1 U1028 ( .A0(RxReg1[11]), .A1(n1339), .B0(n1234), .B1(n1212), .Y(n1083) );
  AO22X1 U1029 ( .A0(RxReg1[10]), .A1(n1339), .B0(n1234), .B1(n1211), .Y(n1084) );
  AO22X1 U1030 ( .A0(RxReg1[9]), .A1(n1339), .B0(n1234), .B1(n1210), .Y(n1085)
         );
  AO22X1 U1031 ( .A0(RxReg1[8]), .A1(n1339), .B0(n1234), .B1(n1209), .Y(n1086)
         );
  AO22X1 U1032 ( .A0(RxReg1[7]), .A1(n1339), .B0(n1234), .B1(n1208), .Y(n1087)
         );
  AO22X1 U1033 ( .A0(RxReg1[6]), .A1(n1339), .B0(n1234), .B1(n1207), .Y(n1088)
         );
  AO22X1 U1034 ( .A0(RxReg1[5]), .A1(n1339), .B0(n1234), .B1(n1206), .Y(n1089)
         );
  AO22X1 U1035 ( .A0(RxReg1[4]), .A1(n1339), .B0(n1234), .B1(n1205), .Y(n1090)
         );
  AO22X1 U1036 ( .A0(RxReg1[3]), .A1(n1339), .B0(n1234), .B1(n1204), .Y(n1091)
         );
  AO22X1 U1037 ( .A0(RxReg1[2]), .A1(n1339), .B0(n1234), .B1(n1203), .Y(n1092)
         );
  AO22X1 U1038 ( .A0(RxReg1[1]), .A1(n1339), .B0(n1234), .B1(n1202), .Y(n1093)
         );
  AO22X1 U1039 ( .A0(RxReg1[0]), .A1(n1339), .B0(n1234), .B1(n1201), .Y(n1094)
         );
  AO22X1 U1040 ( .A0(RxReg2[15]), .A1(n1340), .B0(n1232), .B1(n1216), .Y(n1095) );
  AO22X1 U1041 ( .A0(RxReg2[14]), .A1(n1340), .B0(n1232), .B1(n1215), .Y(n1096) );
  AO22X1 U1042 ( .A0(RxReg2[13]), .A1(n1340), .B0(n1232), .B1(n1214), .Y(n1097) );
  AO22X1 U1043 ( .A0(RxReg2[12]), .A1(n1340), .B0(n1232), .B1(n1213), .Y(n1098) );
  AO22X1 U1044 ( .A0(RxReg2[11]), .A1(n1340), .B0(n1232), .B1(n1212), .Y(n1099) );
  AO22X1 U1045 ( .A0(RxReg2[10]), .A1(n1340), .B0(n1232), .B1(n1211), .Y(n1100) );
  AO22X1 U1046 ( .A0(RxReg2[9]), .A1(n1340), .B0(n1232), .B1(n1210), .Y(n1101)
         );
  AO22X1 U1047 ( .A0(RxReg2[8]), .A1(n1340), .B0(n1232), .B1(n1209), .Y(n1102)
         );
  AO22X1 U1048 ( .A0(RxReg2[7]), .A1(n1340), .B0(n1232), .B1(n1208), .Y(n1103)
         );
  AO22X1 U1049 ( .A0(RxReg2[6]), .A1(n1340), .B0(n1232), .B1(n1207), .Y(n1104)
         );
  AO22X1 U1050 ( .A0(RxReg2[5]), .A1(n1340), .B0(n1232), .B1(n1206), .Y(n1105)
         );
  AO22X1 U1051 ( .A0(RxReg2[4]), .A1(n1340), .B0(n1232), .B1(n1205), .Y(n1106)
         );
  AO22X1 U1052 ( .A0(RxReg2[3]), .A1(n1340), .B0(n1232), .B1(n1204), .Y(n1107)
         );
  AO22X1 U1053 ( .A0(RxReg2[2]), .A1(n1340), .B0(n1232), .B1(n1203), .Y(n1108)
         );
  AO22X1 U1054 ( .A0(RxReg2[1]), .A1(n1340), .B0(n1232), .B1(n1202), .Y(n1109)
         );
  AO22X1 U1055 ( .A0(RxReg2[0]), .A1(n1340), .B0(n1232), .B1(n1201), .Y(n1110)
         );
  AO22X1 U1056 ( .A0(RxReg3[15]), .A1(n1341), .B0(n1229), .B1(n1216), .Y(n1111) );
  AO22X1 U1057 ( .A0(RxReg3[14]), .A1(n1341), .B0(n1229), .B1(n1215), .Y(n1112) );
  AO22X1 U1058 ( .A0(RxReg3[13]), .A1(n1341), .B0(n1229), .B1(n1214), .Y(n1113) );
  AO22X1 U1059 ( .A0(RxReg3[12]), .A1(n1341), .B0(n1229), .B1(n1213), .Y(n1114) );
  AO22X1 U1060 ( .A0(RxReg3[11]), .A1(n1341), .B0(n1229), .B1(n1212), .Y(n1115) );
  AO22X1 U1061 ( .A0(RxReg3[10]), .A1(n1341), .B0(n1229), .B1(n1211), .Y(n1116) );
  AO22X1 U1062 ( .A0(RxReg3[9]), .A1(n1341), .B0(n1229), .B1(n1210), .Y(n1117)
         );
  AO22X1 U1063 ( .A0(RxReg3[8]), .A1(n1341), .B0(n1229), .B1(n1209), .Y(n1118)
         );
  AO22X1 U1064 ( .A0(RxReg3[7]), .A1(n1341), .B0(n1229), .B1(n1208), .Y(n1119)
         );
  AO22X1 U1065 ( .A0(RxReg3[6]), .A1(n1341), .B0(n1229), .B1(n1207), .Y(n1120)
         );
  AO22X1 U1066 ( .A0(RxReg3[5]), .A1(n1341), .B0(n1229), .B1(n1206), .Y(n1121)
         );
  AO22X1 U1067 ( .A0(RxReg3[4]), .A1(n1341), .B0(n1229), .B1(n1205), .Y(n1122)
         );
  AO22X1 U1068 ( .A0(RxReg3[3]), .A1(n1341), .B0(n1229), .B1(n1204), .Y(n1123)
         );
  AO22X1 U1069 ( .A0(RxReg3[2]), .A1(n1341), .B0(n1229), .B1(n1203), .Y(n1124)
         );
  AO22X1 U1070 ( .A0(RxReg3[1]), .A1(n1341), .B0(n1229), .B1(n1202), .Y(n1125)
         );
  AO22X1 U1071 ( .A0(RxReg3[0]), .A1(n1341), .B0(n1229), .B1(n1201), .Y(n1126)
         );
  AO22X1 U1072 ( .A0(RxReg4[15]), .A1(n1342), .B0(n1224), .B1(n1216), .Y(n1127) );
  AO22X1 U1073 ( .A0(RxReg4[14]), .A1(n1342), .B0(n1224), .B1(n1215), .Y(n1128) );
  AO22X1 U1074 ( .A0(RxReg4[13]), .A1(n1342), .B0(n1224), .B1(n1214), .Y(n1129) );
  AO22X1 U1075 ( .A0(RxReg4[12]), .A1(n1342), .B0(n1224), .B1(n1213), .Y(n1130) );
  AO22X1 U1076 ( .A0(RxReg4[11]), .A1(n1342), .B0(n1224), .B1(n1212), .Y(n1131) );
  AO22X1 U1077 ( .A0(RxReg4[10]), .A1(n1342), .B0(n1224), .B1(n1211), .Y(n1132) );
  AO22X1 U1078 ( .A0(RxReg4[9]), .A1(n1342), .B0(n1224), .B1(n1210), .Y(n1133)
         );
  AO22X1 U1079 ( .A0(RxReg4[8]), .A1(n1342), .B0(n1224), .B1(n1209), .Y(n1134)
         );
  AO22X1 U1080 ( .A0(RxReg4[7]), .A1(n1342), .B0(n1224), .B1(n1208), .Y(n1135)
         );
  AO22X1 U1081 ( .A0(RxReg4[6]), .A1(n1342), .B0(n1224), .B1(n1207), .Y(n1136)
         );
  AO22X1 U1082 ( .A0(RxReg4[5]), .A1(n1342), .B0(n1224), .B1(n1206), .Y(n1137)
         );
  AO22X1 U1083 ( .A0(RxReg4[4]), .A1(n1342), .B0(n1224), .B1(n1205), .Y(n1138)
         );
  AO22X1 U1084 ( .A0(RxReg4[3]), .A1(n1342), .B0(n1224), .B1(n1204), .Y(n1139)
         );
  AO22X1 U1085 ( .A0(RxReg4[2]), .A1(n1342), .B0(n1224), .B1(n1203), .Y(n1140)
         );
  AO22X1 U1086 ( .A0(RxReg4[1]), .A1(n1342), .B0(n1224), .B1(n1202), .Y(n1141)
         );
  AO22X1 U1087 ( .A0(RxReg4[0]), .A1(n1342), .B0(n1224), .B1(n1201), .Y(n1142)
         );
  AO22X1 U1088 ( .A0(RxReg5[15]), .A1(n1343), .B0(n1222), .B1(n1216), .Y(n1143) );
  AO22X1 U1089 ( .A0(RxReg5[14]), .A1(n1343), .B0(n1222), .B1(n1215), .Y(n1144) );
  AO22X1 U1090 ( .A0(RxReg5[13]), .A1(n1343), .B0(n1222), .B1(n1214), .Y(n1145) );
  AO22X1 U1091 ( .A0(RxReg5[12]), .A1(n1343), .B0(n1222), .B1(n1213), .Y(n1146) );
  AO22X1 U1092 ( .A0(RxReg5[11]), .A1(n1343), .B0(n1222), .B1(n1212), .Y(n1147) );
  AO22X1 U1093 ( .A0(RxReg5[10]), .A1(n1343), .B0(n1222), .B1(n1211), .Y(n1148) );
  AO22X1 U1094 ( .A0(RxReg5[9]), .A1(n1343), .B0(n1222), .B1(n1210), .Y(n1149)
         );
  AO22X1 U1095 ( .A0(RxReg5[8]), .A1(n1343), .B0(n1222), .B1(n1209), .Y(n1150)
         );
  AO22X1 U1096 ( .A0(RxReg5[7]), .A1(n1343), .B0(n1222), .B1(n1208), .Y(n1151)
         );
  AO22X1 U1097 ( .A0(RxReg5[6]), .A1(n1343), .B0(n1222), .B1(n1207), .Y(n1152)
         );
  AO22X1 U1098 ( .A0(RxReg5[5]), .A1(n1343), .B0(n1222), .B1(n1206), .Y(n1153)
         );
  AO22X1 U1099 ( .A0(RxReg5[4]), .A1(n1343), .B0(n1222), .B1(n1205), .Y(n1154)
         );
  AO22X1 U1100 ( .A0(RxReg5[3]), .A1(n1343), .B0(n1222), .B1(n1204), .Y(n1155)
         );
  AO22X1 U1101 ( .A0(RxReg5[2]), .A1(n1343), .B0(n1222), .B1(n1203), .Y(n1156)
         );
  AO22X1 U1102 ( .A0(RxReg5[1]), .A1(n1343), .B0(n1222), .B1(n1202), .Y(n1157)
         );
  AO22X1 U1103 ( .A0(RxReg5[0]), .A1(n1343), .B0(n1222), .B1(n1201), .Y(n1158)
         );
  AO22X1 U1104 ( .A0(RxReg6[15]), .A1(n1344), .B0(n1220), .B1(n1216), .Y(n1159) );
  AO22X1 U1105 ( .A0(RxReg6[14]), .A1(n1344), .B0(n1220), .B1(n1215), .Y(n1160) );
  AO22X1 U1106 ( .A0(RxReg6[13]), .A1(n1344), .B0(n1220), .B1(n1214), .Y(n1161) );
  AO22X1 U1107 ( .A0(RxReg6[12]), .A1(n1344), .B0(n1220), .B1(n1213), .Y(n1162) );
  AO22X1 U1108 ( .A0(RxReg6[11]), .A1(n1344), .B0(n1220), .B1(n1212), .Y(n1163) );
  AO22X1 U1109 ( .A0(RxReg6[10]), .A1(n1344), .B0(n1220), .B1(n1211), .Y(n1164) );
  AO22X1 U1110 ( .A0(RxReg6[9]), .A1(n1344), .B0(n1220), .B1(n1210), .Y(n1165)
         );
  AO22X1 U1111 ( .A0(RxReg6[8]), .A1(n1344), .B0(n1220), .B1(n1209), .Y(n1166)
         );
  AO22X1 U1112 ( .A0(RxReg6[7]), .A1(n1344), .B0(n1220), .B1(n1208), .Y(n1167)
         );
  AO22X1 U1113 ( .A0(RxReg6[6]), .A1(n1344), .B0(n1220), .B1(n1207), .Y(n1168)
         );
  AO22X1 U1114 ( .A0(RxReg6[5]), .A1(n1344), .B0(n1220), .B1(n1206), .Y(n1169)
         );
  AO22X1 U1115 ( .A0(RxReg6[4]), .A1(n1344), .B0(n1220), .B1(n1205), .Y(n1170)
         );
  AO22X1 U1116 ( .A0(RxReg6[3]), .A1(n1344), .B0(n1220), .B1(n1204), .Y(n1171)
         );
  AO22X1 U1117 ( .A0(RxReg6[2]), .A1(n1344), .B0(n1220), .B1(n1203), .Y(n1172)
         );
  AO22X1 U1118 ( .A0(RxReg6[1]), .A1(n1344), .B0(n1220), .B1(n1202), .Y(n1173)
         );
  AO22X1 U1119 ( .A0(RxReg6[0]), .A1(n1344), .B0(n1220), .B1(n1201), .Y(n1174)
         );
  AO22X1 U1120 ( .A0(RxReg7[15]), .A1(n1199), .B0(n1336), .B1(n1216), .Y(n1175) );
  AO22X1 U1121 ( .A0(RxReg7[14]), .A1(n1199), .B0(n1336), .B1(n1215), .Y(n1176) );
  AO22X1 U1122 ( .A0(RxReg7[13]), .A1(n1199), .B0(n1336), .B1(n1214), .Y(n1177) );
  AO22X1 U1123 ( .A0(RxReg7[12]), .A1(n1199), .B0(n1336), .B1(n1213), .Y(n1178) );
  AO22X1 U1124 ( .A0(RxReg7[11]), .A1(n1199), .B0(n1336), .B1(n1212), .Y(n1179) );
  AO22X1 U1125 ( .A0(RxReg7[10]), .A1(n1199), .B0(n1336), .B1(n1211), .Y(n1180) );
  AO22X1 U1126 ( .A0(RxReg7[9]), .A1(n1199), .B0(n1336), .B1(n1210), .Y(n1181)
         );
  AO22X1 U1127 ( .A0(RxReg7[8]), .A1(n1199), .B0(n1336), .B1(n1209), .Y(n1182)
         );
  AO22X1 U1128 ( .A0(RxReg7[7]), .A1(n1199), .B0(n1336), .B1(n1208), .Y(n1183)
         );
  AO22X1 U1129 ( .A0(RxReg7[6]), .A1(n1199), .B0(n1336), .B1(n1207), .Y(n1184)
         );
  AO22X1 U1130 ( .A0(RxReg7[5]), .A1(n1199), .B0(n1336), .B1(n1206), .Y(n1185)
         );
  AO22X1 U1131 ( .A0(RxReg7[4]), .A1(n1199), .B0(n1336), .B1(n1205), .Y(n1186)
         );
  AO22X1 U1132 ( .A0(RxReg7[3]), .A1(n1199), .B0(n1336), .B1(n1204), .Y(n1187)
         );
  AO22X1 U1133 ( .A0(RxReg7[2]), .A1(n1199), .B0(n1336), .B1(n1203), .Y(n1188)
         );
  AO22X1 U1134 ( .A0(RxReg7[1]), .A1(n1199), .B0(n1336), .B1(n1202), .Y(n1189)
         );
  AO22X1 U1135 ( .A0(RxReg7[0]), .A1(n1199), .B0(n1336), .B1(n1201), .Y(n1190)
         );
  OAI211X1 U1136 ( .A0(n1320), .A1(n1240), .B0(n1280), .C0(n1281), .Y(
        RxFRdData[1]) );
  AOI222X1 U1137 ( .A0(n1243), .A1(RxReg1[1]), .B0(n1244), .B1(RxReg3[1]), 
        .C0(n1245), .C1(RxReg5[1]), .Y(n1281) );
  OAI211X1 U1138 ( .A0(n1321), .A1(n1240), .B0(n1272), .C0(n1273), .Y(
        RxFRdData[3]) );
  AOI222X1 U1139 ( .A0(n1243), .A1(RxReg1[3]), .B0(n1244), .B1(RxReg3[3]), 
        .C0(n1245), .C1(RxReg5[3]), .Y(n1273) );
  OAI211X1 U1140 ( .A0(n1322), .A1(n1240), .B0(n1288), .C0(n1289), .Y(
        RxFRdData[14]) );
  OAI211X1 U1141 ( .A0(n1323), .A1(n1240), .B0(n1284), .C0(n1285), .Y(
        RxFRdData[15]) );
  NAND3BX1 U1142 ( .AN(RdPtr[1]), .B(RdPtr[2]), .C(RdPtr[0]), .Y(n1310) );
  NAND3BX1 U1143 ( .AN(RdPtr[2]), .B(RdPtr[1]), .C(RdPtr[0]), .Y(n1311) );
  NAND3BX1 U1144 ( .AN(RdPtr[2]), .B(n1318), .C(RdPtr[0]), .Y(n1312) );
  INVX1 U1145 ( .A(n1319), .Y(n1246) );
  NAND3BX1 U1146 ( .AN(RdPtr[0]), .B(RdPtr[1]), .C(RdPtr[2]), .Y(n1319) );
  INVX1 U1147 ( .A(n1314), .Y(n1250) );
  NAND3BX1 U1148 ( .AN(RdPtr[2]), .B(n1315), .C(RdPtr[1]), .Y(n1314) );
  INVX1 U1149 ( .A(n1316), .Y(n1249) );
  NAND3BX1 U1150 ( .AN(RdPtr[1]), .B(n1315), .C(RdPtr[2]), .Y(n1316) );
  INVX1 U1151 ( .A(RdPtr[0]), .Y(n1315) );
  INVX1 U1152 ( .A(RdPtr[1]), .Y(n1318) );
  OAI211X1 U1153 ( .A0(n1324), .A1(n1240), .B0(n1252), .C0(n1253), .Y(
        RxFRdData[8]) );
  AOI222X1 U1154 ( .A0(n1243), .A1(RxReg1[8]), .B0(n1244), .B1(RxReg3[8]), 
        .C0(n1245), .C1(RxReg5[8]), .Y(n1253) );
  AOI221X1 U1155 ( .A0(n1246), .A1(RxReg6[8]), .B0(n1247), .B1(RxReg0[8]), 
        .C0(n1254), .Y(n1252) );
  OAI211X1 U1156 ( .A0(n1325), .A1(n1240), .B0(n1241), .C0(n1242), .Y(
        RxFRdData[9]) );
  AOI222X1 U1157 ( .A0(n1243), .A1(RxReg1[9]), .B0(n1244), .B1(RxReg3[9]), 
        .C0(n1245), .C1(RxReg5[9]), .Y(n1242) );
  AOI221X1 U1158 ( .A0(n1246), .A1(RxReg6[9]), .B0(n1247), .B1(RxReg0[9]), 
        .C0(n1248), .Y(n1241) );
  OAI211X1 U1159 ( .A0(n1326), .A1(n1240), .B0(n1304), .C0(n1305), .Y(
        RxFRdData[10]) );
  AOI222X1 U1160 ( .A0(n1243), .A1(RxReg1[10]), .B0(n1244), .B1(RxReg3[10]), 
        .C0(n1245), .C1(RxReg5[10]), .Y(n1305) );
  AOI221X1 U1161 ( .A0(n1246), .A1(RxReg6[10]), .B0(n1247), .B1(RxReg0[10]), 
        .C0(n1306), .Y(n1304) );
  OAI211X1 U1162 ( .A0(n1327), .A1(n1240), .B0(n1300), .C0(n1301), .Y(
        RxFRdData[11]) );
  AOI222X1 U1163 ( .A0(n1243), .A1(RxReg1[11]), .B0(n1244), .B1(RxReg3[11]), 
        .C0(n1245), .C1(RxReg5[11]), .Y(n1301) );
  AOI221X1 U1164 ( .A0(n1246), .A1(RxReg6[11]), .B0(n1247), .B1(RxReg0[11]), 
        .C0(n1302), .Y(n1300) );
  OAI211X1 U1165 ( .A0(n1328), .A1(n1240), .B0(n1296), .C0(n1297), .Y(
        RxFRdData[12]) );
  AOI222X1 U1166 ( .A0(n1243), .A1(RxReg1[12]), .B0(n1244), .B1(RxReg3[12]), 
        .C0(n1245), .C1(RxReg5[12]), .Y(n1297) );
  AOI221X1 U1167 ( .A0(n1246), .A1(RxReg6[12]), .B0(n1247), .B1(RxReg0[12]), 
        .C0(n1298), .Y(n1296) );
  OAI211X1 U1168 ( .A0(n1329), .A1(n1240), .B0(n1292), .C0(n1293), .Y(
        RxFRdData[13]) );
  AOI222X1 U1169 ( .A0(n1243), .A1(RxReg1[13]), .B0(n1244), .B1(RxReg3[13]), 
        .C0(n1245), .C1(RxReg5[13]), .Y(n1293) );
  AOI221X1 U1170 ( .A0(n1246), .A1(RxReg6[13]), .B0(n1247), .B1(RxReg0[13]), 
        .C0(n1294), .Y(n1292) );
  INVX1 U1171 ( .A(n1317), .Y(n1247) );
  NAND3BX1 U1172 ( .AN(RdPtr[2]), .B(n1318), .C(n1315), .Y(n1317) );
  AO22X1 U1173 ( .A0(n1249), .A1(RxReg4[0]), .B0(n1250), .B1(RxReg2[0]), .Y(
        n1313) );
  AO22X1 U1174 ( .A0(n1249), .A1(RxReg4[2]), .B0(n1250), .B1(RxReg2[2]), .Y(
        n1278) );
  AO22X1 U1175 ( .A0(n1249), .A1(RxReg4[4]), .B0(n1250), .B1(RxReg2[4]), .Y(
        n1270) );
  AO22X1 U1176 ( .A0(n1249), .A1(RxReg4[5]), .B0(n1250), .B1(RxReg2[5]), .Y(
        n1266) );
  AO22X1 U1177 ( .A0(n1249), .A1(RxReg4[6]), .B0(n1250), .B1(RxReg2[6]), .Y(
        n1262) );
  AO22X1 U1178 ( .A0(n1249), .A1(RxReg4[7]), .B0(n1250), .B1(RxReg2[7]), .Y(
        n1258) );
  AO22X1 U1179 ( .A0(n1249), .A1(RxReg4[8]), .B0(n1250), .B1(RxReg2[8]), .Y(
        n1254) );
  AO22X1 U1180 ( .A0(n1249), .A1(RxReg4[9]), .B0(n1250), .B1(RxReg2[9]), .Y(
        n1248) );
  AO22X1 U1181 ( .A0(n1249), .A1(RxReg4[10]), .B0(n1250), .B1(RxReg2[10]), .Y(
        n1306) );
  AO22X1 U1182 ( .A0(n1249), .A1(RxReg4[11]), .B0(n1250), .B1(RxReg2[11]), .Y(
        n1302) );
  AO22X1 U1183 ( .A0(n1249), .A1(RxReg4[12]), .B0(n1250), .B1(RxReg2[12]), .Y(
        n1298) );
  AO22X1 U1184 ( .A0(n1249), .A1(RxReg4[13]), .B0(n1250), .B1(RxReg2[13]), .Y(
        n1294) );
  OAI211X1 U1185 ( .A0(n1330), .A1(n1240), .B0(n1276), .C0(n1277), .Y(
        RxFRdData[2]) );
  AOI222X1 U1186 ( .A0(n1243), .A1(RxReg1[2]), .B0(n1244), .B1(RxReg3[2]), 
        .C0(n1245), .C1(RxReg5[2]), .Y(n1277) );
  AOI221X1 U1187 ( .A0(n1246), .A1(RxReg6[2]), .B0(n1247), .B1(RxReg0[2]), 
        .C0(n1278), .Y(n1276) );
  OAI211X1 U1188 ( .A0(n1331), .A1(n1240), .B0(n1308), .C0(n1309), .Y(
        RxFRdData[0]) );
  AOI222X1 U1189 ( .A0(n1243), .A1(RxReg1[0]), .B0(n1244), .B1(RxReg3[0]), 
        .C0(n1245), .C1(RxReg5[0]), .Y(n1309) );
  AOI221X1 U1190 ( .A0(n1246), .A1(RxReg6[0]), .B0(n1247), .B1(RxReg0[0]), 
        .C0(n1313), .Y(n1308) );
  AOI222X1 U1191 ( .A0(n1243), .A1(RxReg1[14]), .B0(n1244), .B1(RxReg3[14]), 
        .C0(n1245), .C1(RxReg5[14]), .Y(n1289) );
  AOI222X1 U1192 ( .A0(n1243), .A1(RxReg1[15]), .B0(n1244), .B1(RxReg3[15]), 
        .C0(n1245), .C1(RxReg5[15]), .Y(n1285) );
  AOI221X1 U1193 ( .A0(n1246), .A1(RxReg6[1]), .B0(n1247), .B1(RxReg0[1]), 
        .C0(n1282), .Y(n1280) );
  AO22X1 U1194 ( .A0(n1249), .A1(RxReg4[1]), .B0(n1250), .B1(RxReg2[1]), .Y(
        n1282) );
  AOI221X1 U1195 ( .A0(n1246), .A1(RxReg6[3]), .B0(n1247), .B1(RxReg0[3]), 
        .C0(n1274), .Y(n1272) );
  AO22X1 U1196 ( .A0(n1249), .A1(RxReg4[3]), .B0(n1250), .B1(RxReg2[3]), .Y(
        n1274) );
  AOI221X1 U1197 ( .A0(n1246), .A1(RxReg6[14]), .B0(n1247), .B1(RxReg0[14]), 
        .C0(n1290), .Y(n1288) );
  AO22X1 U1198 ( .A0(n1249), .A1(RxReg4[14]), .B0(n1250), .B1(RxReg2[14]), .Y(
        n1290) );
  AOI221X1 U1199 ( .A0(n1246), .A1(RxReg6[15]), .B0(n1247), .B1(RxReg0[15]), 
        .C0(n1286), .Y(n1284) );
  AO22X1 U1200 ( .A0(n1249), .A1(RxReg4[15]), .B0(n1250), .B1(RxReg2[15]), .Y(
        n1286) );
  OAI211X1 U1201 ( .A0(n1332), .A1(n1240), .B0(n1268), .C0(n1269), .Y(
        RxFRdData[4]) );
  AOI222X1 U1202 ( .A0(n1243), .A1(RxReg1[4]), .B0(n1244), .B1(RxReg3[4]), 
        .C0(n1245), .C1(RxReg5[4]), .Y(n1269) );
  AOI221X1 U1203 ( .A0(n1246), .A1(RxReg6[4]), .B0(n1247), .B1(RxReg0[4]), 
        .C0(n1270), .Y(n1268) );
  OAI211X1 U1204 ( .A0(n1333), .A1(n1240), .B0(n1260), .C0(n1261), .Y(
        RxFRdData[6]) );
  AOI222X1 U1205 ( .A0(n1243), .A1(RxReg1[6]), .B0(n1244), .B1(RxReg3[6]), 
        .C0(n1245), .C1(RxReg5[6]), .Y(n1261) );
  AOI221X1 U1206 ( .A0(n1246), .A1(RxReg6[6]), .B0(n1247), .B1(RxReg0[6]), 
        .C0(n1262), .Y(n1260) );
  OAI211X1 U1207 ( .A0(n1334), .A1(n1240), .B0(n1256), .C0(n1257), .Y(
        RxFRdData[7]) );
  AOI222X1 U1208 ( .A0(n1243), .A1(RxReg1[7]), .B0(n1244), .B1(RxReg3[7]), 
        .C0(n1245), .C1(RxReg5[7]), .Y(n1257) );
  AOI221X1 U1209 ( .A0(n1246), .A1(RxReg6[7]), .B0(n1247), .B1(RxReg0[7]), 
        .C0(n1258), .Y(n1256) );
  OAI211X1 U1210 ( .A0(n1335), .A1(n1240), .B0(n1264), .C0(n1265), .Y(
        RxFRdData[5]) );
  AOI222X1 U1211 ( .A0(n1243), .A1(RxReg1[5]), .B0(n1244), .B1(RxReg3[5]), 
        .C0(n1245), .C1(RxReg5[5]), .Y(n1265) );
  AOI221X1 U1212 ( .A0(n1246), .A1(RxReg6[5]), .B0(n1247), .B1(RxReg0[5]), 
        .C0(n1266), .Y(n1264) );
  INVX1 U1213 ( .A(MS), .Y(n1237) );
  AO22X1 U1214 ( .A0(SRxFWrData[15]), .A1(MS), .B0(MRxFWrData[15]), .B1(n1237), 
        .Y(n1216) );
  AO22X1 U1215 ( .A0(SRxFWrData[14]), .A1(MS), .B0(MRxFWrData[14]), .B1(n1237), 
        .Y(n1215) );
  AO22X1 U1216 ( .A0(SRxFWrData[13]), .A1(MS), .B0(MRxFWrData[13]), .B1(n1237), 
        .Y(n1214) );
  AO22X1 U1217 ( .A0(SRxFWrData[12]), .A1(MS), .B0(MRxFWrData[12]), .B1(n1237), 
        .Y(n1213) );
  AO22X1 U1218 ( .A0(SRxFWrData[11]), .A1(MS), .B0(MRxFWrData[11]), .B1(n1237), 
        .Y(n1212) );
  AO22X1 U1219 ( .A0(SRxFWrData[10]), .A1(MS), .B0(MRxFWrData[10]), .B1(n1237), 
        .Y(n1211) );
  AO22X1 U1220 ( .A0(SRxFWrData[9]), .A1(MS), .B0(MRxFWrData[9]), .B1(n1237), 
        .Y(n1210) );
  AO22X1 U1221 ( .A0(SRxFWrData[8]), .A1(MS), .B0(MRxFWrData[8]), .B1(n1237), 
        .Y(n1209) );
  AO22X1 U1222 ( .A0(SRxFWrData[7]), .A1(MS), .B0(MRxFWrData[7]), .B1(n1237), 
        .Y(n1208) );
  AO22X1 U1223 ( .A0(SRxFWrData[6]), .A1(MS), .B0(MRxFWrData[6]), .B1(n1237), 
        .Y(n1207) );
  AO22X1 U1224 ( .A0(SRxFWrData[5]), .A1(MS), .B0(MRxFWrData[5]), .B1(n1237), 
        .Y(n1206) );
  AO22X1 U1225 ( .A0(SRxFWrData[4]), .A1(MS), .B0(MRxFWrData[4]), .B1(n1237), 
        .Y(n1205) );
  AO22X1 U1226 ( .A0(SRxFWrData[3]), .A1(MS), .B0(MRxFWrData[3]), .B1(n1237), 
        .Y(n1204) );
  AO22X1 U1227 ( .A0(SRxFWrData[2]), .A1(MS), .B0(MRxFWrData[2]), .B1(n1237), 
        .Y(n1203) );
  AO22X1 U1228 ( .A0(SRxFWrData[1]), .A1(MS), .B0(MRxFWrData[1]), .B1(n1237), 
        .Y(n1202) );
  AO22X1 U1229 ( .A0(SRxFWrData[0]), .A1(MS), .B0(MRxFWrData[0]), .B1(n1237), 
        .Y(n1201) );
  INVX1 U1230 ( .A(WrPtr[0]), .Y(n1225) );
  DFFRX1 RxReg4_reg_7_ ( .D(n1135), .CK(PCLK), .RN(PRESETn), .Q(RxReg4[7]) );
  DFFRX1 RxReg4_reg_6_ ( .D(n1136), .CK(PCLK), .RN(PRESETn), .Q(RxReg4[6]) );
  DFFRX1 RxReg4_reg_5_ ( .D(n1137), .CK(PCLK), .RN(PRESETn), .Q(RxReg4[5]) );
  DFFRX1 RxReg4_reg_4_ ( .D(n1138), .CK(PCLK), .RN(PRESETn), .Q(RxReg4[4]) );
  DFFRX1 RxReg4_reg_3_ ( .D(n1139), .CK(PCLK), .RN(PRESETn), .Q(RxReg4[3]) );
  DFFRX1 RxReg4_reg_1_ ( .D(n1141), .CK(PCLK), .RN(PRESETn), .Q(RxReg4[1]) );
  DFFRX1 RxReg2_reg_7_ ( .D(n1103), .CK(PCLK), .RN(PRESETn), .Q(RxReg2[7]) );
  DFFRX1 RxReg2_reg_6_ ( .D(n1104), .CK(PCLK), .RN(PRESETn), .Q(RxReg2[6]) );
  DFFRX1 RxReg2_reg_5_ ( .D(n1105), .CK(PCLK), .RN(PRESETn), .Q(RxReg2[5]) );
  DFFRX1 RxReg2_reg_4_ ( .D(n1106), .CK(PCLK), .RN(PRESETn), .Q(RxReg2[4]) );
  DFFRX1 RxReg2_reg_3_ ( .D(n1107), .CK(PCLK), .RN(PRESETn), .Q(RxReg2[3]) );
  DFFRX1 RxReg2_reg_1_ ( .D(n1109), .CK(PCLK), .RN(PRESETn), .Q(RxReg2[1]) );
  DFFRX1 RxReg1_reg_7_ ( .D(n1087), .CK(PCLK), .RN(PRESETn), .Q(RxReg1[7]) );
  DFFRX1 RxReg1_reg_6_ ( .D(n1088), .CK(PCLK), .RN(PRESETn), .Q(RxReg1[6]) );
  DFFRX1 RxReg1_reg_5_ ( .D(n1089), .CK(PCLK), .RN(PRESETn), .Q(RxReg1[5]) );
  DFFRX1 RxReg1_reg_4_ ( .D(n1090), .CK(PCLK), .RN(PRESETn), .Q(RxReg1[4]) );
  DFFRX1 RxReg1_reg_3_ ( .D(n1091), .CK(PCLK), .RN(PRESETn), .Q(RxReg1[3]) );
  DFFRX1 RxReg6_reg_7_ ( .D(n1167), .CK(PCLK), .RN(PRESETn), .Q(RxReg6[7]) );
  DFFRX1 RxReg6_reg_6_ ( .D(n1168), .CK(PCLK), .RN(PRESETn), .Q(RxReg6[6]) );
  DFFRX1 RxReg6_reg_5_ ( .D(n1169), .CK(PCLK), .RN(PRESETn), .Q(RxReg6[5]) );
  DFFRX1 RxReg6_reg_4_ ( .D(n1170), .CK(PCLK), .RN(PRESETn), .Q(RxReg6[4]) );
  DFFRX1 RxReg6_reg_3_ ( .D(n1171), .CK(PCLK), .RN(PRESETn), .Q(RxReg6[3]) );
  DFFRX1 RxReg3_reg_7_ ( .D(n1119), .CK(PCLK), .RN(PRESETn), .Q(RxReg3[7]) );
  DFFRX1 RxReg3_reg_6_ ( .D(n1120), .CK(PCLK), .RN(PRESETn), .Q(RxReg3[6]) );
  DFFRX1 RxReg3_reg_5_ ( .D(n1121), .CK(PCLK), .RN(PRESETn), .Q(RxReg3[5]) );
  DFFRX1 RxReg3_reg_4_ ( .D(n1122), .CK(PCLK), .RN(PRESETn), .Q(RxReg3[4]) );
  DFFRX1 RxReg3_reg_3_ ( .D(n1123), .CK(PCLK), .RN(PRESETn), .Q(RxReg3[3]) );
  DFFRX1 RxReg3_reg_1_ ( .D(n1125), .CK(PCLK), .RN(PRESETn), .Q(RxReg3[1]) );
  DFFRX1 RxReg5_reg_7_ ( .D(n1151), .CK(PCLK), .RN(PRESETn), .Q(RxReg5[7]) );
  DFFRX1 RxReg5_reg_6_ ( .D(n1152), .CK(PCLK), .RN(PRESETn), .Q(RxReg5[6]) );
  DFFRX1 RxReg5_reg_5_ ( .D(n1153), .CK(PCLK), .RN(PRESETn), .Q(RxReg5[5]) );
  DFFRX1 RxReg5_reg_4_ ( .D(n1154), .CK(PCLK), .RN(PRESETn), .Q(RxReg5[4]) );
  DFFRX1 RxReg5_reg_3_ ( .D(n1155), .CK(PCLK), .RN(PRESETn), .Q(RxReg5[3]) );
  DFFRX1 RxReg5_reg_1_ ( .D(n1157), .CK(PCLK), .RN(PRESETn), .Q(RxReg5[1]) );
  DFFRX1 RxReg0_reg_7_ ( .D(n1071), .CK(PCLK), .RN(PRESETn), .Q(RxReg0[7]) );
  DFFRX1 RxReg0_reg_6_ ( .D(n1072), .CK(PCLK), .RN(PRESETn), .Q(RxReg0[6]) );
  DFFRX1 RxReg0_reg_5_ ( .D(n1073), .CK(PCLK), .RN(PRESETn), .Q(RxReg0[5]) );
  DFFRX1 RxReg0_reg_4_ ( .D(n1074), .CK(PCLK), .RN(PRESETn), .Q(RxReg0[4]) );
  DFFRX1 RxReg0_reg_3_ ( .D(n1075), .CK(PCLK), .RN(PRESETn), .Q(RxReg0[3]) );
  DFFRX1 RxReg0_reg_1_ ( .D(n1077), .CK(PCLK), .RN(PRESETn), .Q(RxReg0[1]) );
  DFFRX1 RxReg7_reg_15_ ( .D(n1175), .CK(PCLK), .RN(PRESETn), .Q(RxReg7[15]), 
        .QN(n1323) );
  DFFRX1 RxReg7_reg_14_ ( .D(n1176), .CK(PCLK), .RN(PRESETn), .Q(RxReg7[14]), 
        .QN(n1322) );
  DFFRX1 RxReg7_reg_13_ ( .D(n1177), .CK(PCLK), .RN(PRESETn), .Q(RxReg7[13]), 
        .QN(n1329) );
  DFFRX1 RxReg7_reg_12_ ( .D(n1178), .CK(PCLK), .RN(PRESETn), .Q(RxReg7[12]), 
        .QN(n1328) );
  DFFRX1 RxReg7_reg_11_ ( .D(n1179), .CK(PCLK), .RN(PRESETn), .Q(RxReg7[11]), 
        .QN(n1327) );
  DFFRX1 RxReg7_reg_10_ ( .D(n1180), .CK(PCLK), .RN(PRESETn), .Q(RxReg7[10]), 
        .QN(n1326) );
  DFFRX1 RxReg7_reg_9_ ( .D(n1181), .CK(PCLK), .RN(PRESETn), .Q(RxReg7[9]), 
        .QN(n1325) );
  DFFRX1 RxReg7_reg_8_ ( .D(n1182), .CK(PCLK), .RN(PRESETn), .Q(RxReg7[8]), 
        .QN(n1324) );
  DFFRX1 RxReg7_reg_7_ ( .D(n1183), .CK(PCLK), .RN(PRESETn), .Q(RxReg7[7]), 
        .QN(n1334) );
  DFFRX1 RxReg7_reg_6_ ( .D(n1184), .CK(PCLK), .RN(PRESETn), .Q(RxReg7[6]), 
        .QN(n1333) );
  DFFRX1 RxReg7_reg_5_ ( .D(n1185), .CK(PCLK), .RN(PRESETn), .Q(RxReg7[5]), 
        .QN(n1335) );
  DFFRX1 RxReg7_reg_4_ ( .D(n1186), .CK(PCLK), .RN(PRESETn), .Q(RxReg7[4]), 
        .QN(n1332) );
  DFFRX1 RxReg7_reg_3_ ( .D(n1187), .CK(PCLK), .RN(PRESETn), .Q(RxReg7[3]), 
        .QN(n1321) );
  DFFRX1 RxReg7_reg_2_ ( .D(n1188), .CK(PCLK), .RN(PRESETn), .Q(RxReg7[2]), 
        .QN(n1330) );
  DFFRX1 RxReg7_reg_1_ ( .D(n1189), .CK(PCLK), .RN(PRESETn), .Q(RxReg7[1]), 
        .QN(n1320) );
  DFFRX1 RxReg7_reg_0_ ( .D(n1190), .CK(PCLK), .RN(PRESETn), .Q(RxReg7[0]), 
        .QN(n1331) );
  DFFRX1 RxReg4_reg_15_ ( .D(n1127), .CK(PCLK), .RN(PRESETn), .Q(RxReg4[15])
         );
  DFFRX1 RxReg4_reg_14_ ( .D(n1128), .CK(PCLK), .RN(PRESETn), .Q(RxReg4[14])
         );
  DFFRX1 RxReg4_reg_13_ ( .D(n1129), .CK(PCLK), .RN(PRESETn), .Q(RxReg4[13])
         );
  DFFRX1 RxReg4_reg_12_ ( .D(n1130), .CK(PCLK), .RN(PRESETn), .Q(RxReg4[12])
         );
  DFFRX1 RxReg4_reg_11_ ( .D(n1131), .CK(PCLK), .RN(PRESETn), .Q(RxReg4[11])
         );
  DFFRX1 RxReg4_reg_10_ ( .D(n1132), .CK(PCLK), .RN(PRESETn), .Q(RxReg4[10])
         );
  DFFRX1 RxReg4_reg_9_ ( .D(n1133), .CK(PCLK), .RN(PRESETn), .Q(RxReg4[9]) );
  DFFRX1 RxReg4_reg_8_ ( .D(n1134), .CK(PCLK), .RN(PRESETn), .Q(RxReg4[8]) );
  DFFRX1 RxReg4_reg_2_ ( .D(n1140), .CK(PCLK), .RN(PRESETn), .Q(RxReg4[2]) );
  DFFRX1 RxReg4_reg_0_ ( .D(n1142), .CK(PCLK), .RN(PRESETn), .Q(RxReg4[0]) );
  DFFRX1 RxReg2_reg_15_ ( .D(n1095), .CK(PCLK), .RN(PRESETn), .Q(RxReg2[15])
         );
  DFFRX1 RxReg2_reg_14_ ( .D(n1096), .CK(PCLK), .RN(PRESETn), .Q(RxReg2[14])
         );
  DFFRX1 RxReg2_reg_13_ ( .D(n1097), .CK(PCLK), .RN(PRESETn), .Q(RxReg2[13])
         );
  DFFRX1 RxReg2_reg_12_ ( .D(n1098), .CK(PCLK), .RN(PRESETn), .Q(RxReg2[12])
         );
  DFFRX1 RxReg2_reg_11_ ( .D(n1099), .CK(PCLK), .RN(PRESETn), .Q(RxReg2[11])
         );
  DFFRX1 RxReg2_reg_10_ ( .D(n1100), .CK(PCLK), .RN(PRESETn), .Q(RxReg2[10])
         );
  DFFRX1 RxReg2_reg_9_ ( .D(n1101), .CK(PCLK), .RN(PRESETn), .Q(RxReg2[9]) );
  DFFRX1 RxReg2_reg_8_ ( .D(n1102), .CK(PCLK), .RN(PRESETn), .Q(RxReg2[8]) );
  DFFRX1 RxReg2_reg_2_ ( .D(n1108), .CK(PCLK), .RN(PRESETn), .Q(RxReg2[2]) );
  DFFRX1 RxReg2_reg_0_ ( .D(n1110), .CK(PCLK), .RN(PRESETn), .Q(RxReg2[0]) );
  DFFRX1 RxReg1_reg_15_ ( .D(n1079), .CK(PCLK), .RN(PRESETn), .Q(RxReg1[15])
         );
  DFFRX1 RxReg1_reg_14_ ( .D(n1080), .CK(PCLK), .RN(PRESETn), .Q(RxReg1[14])
         );
  DFFRX1 RxReg1_reg_13_ ( .D(n1081), .CK(PCLK), .RN(PRESETn), .Q(RxReg1[13])
         );
  DFFRX1 RxReg1_reg_12_ ( .D(n1082), .CK(PCLK), .RN(PRESETn), .Q(RxReg1[12])
         );
  DFFRX1 RxReg1_reg_11_ ( .D(n1083), .CK(PCLK), .RN(PRESETn), .Q(RxReg1[11])
         );
  DFFRX1 RxReg1_reg_10_ ( .D(n1084), .CK(PCLK), .RN(PRESETn), .Q(RxReg1[10])
         );
  DFFRX1 RxReg1_reg_9_ ( .D(n1085), .CK(PCLK), .RN(PRESETn), .Q(RxReg1[9]) );
  DFFRX1 RxReg1_reg_8_ ( .D(n1086), .CK(PCLK), .RN(PRESETn), .Q(RxReg1[8]) );
  DFFRX1 RxReg1_reg_2_ ( .D(n1092), .CK(PCLK), .RN(PRESETn), .Q(RxReg1[2]) );
  DFFRX1 RxReg1_reg_1_ ( .D(n1093), .CK(PCLK), .RN(PRESETn), .Q(RxReg1[1]) );
  DFFRX1 RxReg1_reg_0_ ( .D(n1094), .CK(PCLK), .RN(PRESETn), .Q(RxReg1[0]) );
  DFFRX1 RxReg6_reg_15_ ( .D(n1159), .CK(PCLK), .RN(PRESETn), .Q(RxReg6[15])
         );
  DFFRX1 RxReg6_reg_14_ ( .D(n1160), .CK(PCLK), .RN(PRESETn), .Q(RxReg6[14])
         );
  DFFRX1 RxReg6_reg_13_ ( .D(n1161), .CK(PCLK), .RN(PRESETn), .Q(RxReg6[13])
         );
  DFFRX1 RxReg6_reg_12_ ( .D(n1162), .CK(PCLK), .RN(PRESETn), .Q(RxReg6[12])
         );
  DFFRX1 RxReg6_reg_11_ ( .D(n1163), .CK(PCLK), .RN(PRESETn), .Q(RxReg6[11])
         );
  DFFRX1 RxReg6_reg_10_ ( .D(n1164), .CK(PCLK), .RN(PRESETn), .Q(RxReg6[10])
         );
  DFFRX1 RxReg6_reg_9_ ( .D(n1165), .CK(PCLK), .RN(PRESETn), .Q(RxReg6[9]) );
  DFFRX1 RxReg6_reg_8_ ( .D(n1166), .CK(PCLK), .RN(PRESETn), .Q(RxReg6[8]) );
  DFFRX1 RxReg6_reg_2_ ( .D(n1172), .CK(PCLK), .RN(PRESETn), .Q(RxReg6[2]) );
  DFFRX1 RxReg6_reg_1_ ( .D(n1173), .CK(PCLK), .RN(PRESETn), .Q(RxReg6[1]) );
  DFFRX1 RxReg6_reg_0_ ( .D(n1174), .CK(PCLK), .RN(PRESETn), .Q(RxReg6[0]) );
  DFFRX1 RxReg3_reg_15_ ( .D(n1111), .CK(PCLK), .RN(PRESETn), .Q(RxReg3[15])
         );
  DFFRX1 RxReg3_reg_14_ ( .D(n1112), .CK(PCLK), .RN(PRESETn), .Q(RxReg3[14])
         );
  DFFRX1 RxReg3_reg_13_ ( .D(n1113), .CK(PCLK), .RN(PRESETn), .Q(RxReg3[13])
         );
  DFFRX1 RxReg3_reg_12_ ( .D(n1114), .CK(PCLK), .RN(PRESETn), .Q(RxReg3[12])
         );
  DFFRX1 RxReg3_reg_11_ ( .D(n1115), .CK(PCLK), .RN(PRESETn), .Q(RxReg3[11])
         );
  DFFRX1 RxReg3_reg_10_ ( .D(n1116), .CK(PCLK), .RN(PRESETn), .Q(RxReg3[10])
         );
  DFFRX1 RxReg3_reg_9_ ( .D(n1117), .CK(PCLK), .RN(PRESETn), .Q(RxReg3[9]) );
  DFFRX1 RxReg3_reg_8_ ( .D(n1118), .CK(PCLK), .RN(PRESETn), .Q(RxReg3[8]) );
  DFFRX1 RxReg3_reg_2_ ( .D(n1124), .CK(PCLK), .RN(PRESETn), .Q(RxReg3[2]) );
  DFFRX1 RxReg3_reg_0_ ( .D(n1126), .CK(PCLK), .RN(PRESETn), .Q(RxReg3[0]) );
  DFFRX1 RxReg5_reg_15_ ( .D(n1143), .CK(PCLK), .RN(PRESETn), .Q(RxReg5[15])
         );
  DFFRX1 RxReg5_reg_14_ ( .D(n1144), .CK(PCLK), .RN(PRESETn), .Q(RxReg5[14])
         );
  DFFRX1 RxReg5_reg_13_ ( .D(n1145), .CK(PCLK), .RN(PRESETn), .Q(RxReg5[13])
         );
  DFFRX1 RxReg5_reg_12_ ( .D(n1146), .CK(PCLK), .RN(PRESETn), .Q(RxReg5[12])
         );
  DFFRX1 RxReg5_reg_11_ ( .D(n1147), .CK(PCLK), .RN(PRESETn), .Q(RxReg5[11])
         );
  DFFRX1 RxReg5_reg_10_ ( .D(n1148), .CK(PCLK), .RN(PRESETn), .Q(RxReg5[10])
         );
  DFFRX1 RxReg5_reg_9_ ( .D(n1149), .CK(PCLK), .RN(PRESETn), .Q(RxReg5[9]) );
  DFFRX1 RxReg5_reg_8_ ( .D(n1150), .CK(PCLK), .RN(PRESETn), .Q(RxReg5[8]) );
  DFFRX1 RxReg5_reg_2_ ( .D(n1156), .CK(PCLK), .RN(PRESETn), .Q(RxReg5[2]) );
  DFFRX1 RxReg5_reg_0_ ( .D(n1158), .CK(PCLK), .RN(PRESETn), .Q(RxReg5[0]) );
  DFFRX1 RxReg0_reg_15_ ( .D(n1063), .CK(PCLK), .RN(PRESETn), .Q(RxReg0[15])
         );
  DFFRX1 RxReg0_reg_14_ ( .D(n1064), .CK(PCLK), .RN(PRESETn), .Q(RxReg0[14])
         );
  DFFRX1 RxReg0_reg_13_ ( .D(n1065), .CK(PCLK), .RN(PRESETn), .Q(RxReg0[13])
         );
  DFFRX1 RxReg0_reg_12_ ( .D(n1066), .CK(PCLK), .RN(PRESETn), .Q(RxReg0[12])
         );
  DFFRX1 RxReg0_reg_11_ ( .D(n1067), .CK(PCLK), .RN(PRESETn), .Q(RxReg0[11])
         );
  DFFRX1 RxReg0_reg_10_ ( .D(n1068), .CK(PCLK), .RN(PRESETn), .Q(RxReg0[10])
         );
  DFFRX1 RxReg0_reg_9_ ( .D(n1069), .CK(PCLK), .RN(PRESETn), .Q(RxReg0[9]) );
  DFFRX1 RxReg0_reg_8_ ( .D(n1070), .CK(PCLK), .RN(PRESETn), .Q(RxReg0[8]) );
  DFFRX1 RxReg0_reg_2_ ( .D(n1076), .CK(PCLK), .RN(PRESETn), .Q(RxReg0[2]) );
  DFFRX1 RxReg0_reg_0_ ( .D(n1078), .CK(PCLK), .RN(PRESETn), .Q(RxReg0[0]) );
endmodule


module SspRxFCntl ( PCLK, PRESETn, RXIM, RORIM, RORIC, RxFWrSync, RxFRdPtrInc, 
        RxDMALevel, RNE, RFF, RXRIS, RORRIS, RXMIS, RORMIS, RegFileWrEn, WrPtr, 
        RdPtr, RxFFillLevel );
  input [3:0] RxDMALevel;
  output [2:0] WrPtr;
  output [2:0] RdPtr;
  output [3:0] RxFFillLevel;
  input PCLK, PRESETn, RXIM, RORIM, RORIC, RxFWrSync, RxFRdPtrInc;
  output RNE, RFF, RXRIS, RORRIS, RXMIS, RORMIS, RegFileWrEn;
  wire   NextRXRIS, Wrap, n366, n387, n388, n389, n390, n391, n392, n393, n394,
         n395, n396, n442, n443, n445, n446, n448, n449, n450, n451, n452,
         n453, n454, n455, n456, n457, n458, n459, n460, n462, n464, n465,
         n469, n471, n475, n476, n477, n478, n479, n480, n481, n482, n483,
         n484, n485, n486, n487, n488, n489, n490, n491, n492, n493, n494,
         n495, n496, n497, n498;

  XOR2X1 U248 ( .A(n488), .B(Wrap), .Y(RxFFillLevel[3]) );
  INVX1 U249 ( .A(n464), .Y(n462) );
  DFFRX1 WrPtr_reg_1_ ( .D(n388), .CK(PCLK), .RN(PRESETn), .Q(WrPtr[1]), .QN(
        n491) );
  DFFRX1 RdPtr_reg_1_ ( .D(n391), .CK(PCLK), .RN(PRESETn), .Q(RdPtr[1]), .QN(
        n490) );
  DFFRX1 RdPtr_reg_0_ ( .D(n392), .CK(PCLK), .RN(PRESETn), .Q(RdPtr[0]), .QN(
        n493) );
  NAND2BX1 U250 ( .AN(n493), .B(n452), .Y(n464) );
  NAND4BX1 U251 ( .AN(RegFileWrEn), .B(n445), .C(n446), .D(n452), .Y(n451) );
  INVX1 U252 ( .A(n454), .Y(n452) );
  XOR2X1 U253 ( .A(n493), .B(n454), .Y(n392) );
  XOR2X1 U254 ( .A(n491), .B(n460), .Y(n388) );
  XOR2X1 U255 ( .A(n490), .B(n464), .Y(n391) );
  DFFRX1 WrPtr_reg_0_ ( .D(n389), .CK(PCLK), .RN(PRESETn), .Q(WrPtr[0]) );
  NAND2BX1 U256 ( .AN(n475), .B(n442), .Y(n487) );
  INVX1 U257 ( .A(RxFFillLevel[1]), .Y(n446) );
  INVX1 U258 ( .A(RxFFillLevel[3]), .Y(n442) );
  INVX1 U259 ( .A(n485), .Y(n482) );
  DFFRX1 RdPtr_reg_2_ ( .D(n390), .CK(PCLK), .RN(PRESETn), .Q(RdPtr[2]), .QN(
        n492) );
  DFFRX1 RNE_reg ( .D(n394), .CK(PCLK), .RN(PRESETn), .Q(RNE) );
  INVX1 U260 ( .A(RxFFillLevel[2]), .Y(n448) );
  INVX1 U261 ( .A(RxFFillLevel[0]), .Y(n445) );
  AO22X1 U262 ( .A0(RxFRdPtrInc), .A1(n497), .B0(n497), .B1(n494), .Y(
        RegFileWrEn) );
  NAND2X1 U263 ( .A(RNE), .B(RxFRdPtrInc), .Y(n454) );
  AO22X1 U264 ( .A0(n455), .A1(RegFileWrEn), .B0(RNE), .B1(n456), .Y(n394) );
  INVX1 U265 ( .A(n456), .Y(n455) );
  NAND4BX1 U266 ( .AN(RxFFillLevel[3]), .B(n446), .C(n448), .D(n457), .Y(n456)
         );
  AO22X1 U267 ( .A0(RegFileWrEn), .A1(n445), .B0(n452), .B1(RxFFillLevel[0]), 
        .Y(n457) );
  NAND2X1 U268 ( .A(WrPtr[0]), .B(RegFileWrEn), .Y(n460) );
  XOR3X1 U269 ( .A(Wrap), .B(n458), .C(n459), .Y(n393) );
  NAND3BX1 U270 ( .AN(n490), .B(RdPtr[2]), .C(n462), .Y(n458) );
  NAND3BX1 U271 ( .AN(n460), .B(WrPtr[1]), .C(WrPtr[2]), .Y(n459) );
  OAI31X1 U272 ( .A0(n460), .A1(WrPtr[2]), .A2(n491), .B0(n469), .Y(n387) );
  OA22X1 U273 ( .A0(WrPtr[1]), .A1(n496), .B0(n471), .B1(n496), .Y(n469) );
  INVX1 U274 ( .A(n460), .Y(n471) );
  OAI31X1 U275 ( .A0(n464), .A1(RdPtr[2]), .A2(n490), .B0(n465), .Y(n390) );
  OA22X1 U276 ( .A0(RdPtr[1]), .A1(n492), .B0(n462), .B1(n492), .Y(n465) );
  OAI31X1 U277 ( .A0(RxFFillLevel[3]), .A1(n448), .A2(n449), .B0(n450), .Y(
        n395) );
  NAND4BX1 U278 ( .AN(n453), .B(RxFFillLevel[0]), .C(RxFFillLevel[1]), .D(n454), .Y(n449) );
  OAI31X1 U279 ( .A0(n442), .A1(RxFFillLevel[2]), .A2(n451), .B0(RFF), .Y(n450) );
  INVX1 U280 ( .A(RegFileWrEn), .Y(n453) );
  XOR2X1 U281 ( .A(RegFileWrEn), .B(WrPtr[0]), .Y(n389) );
  OAI32X1 U282 ( .A0(n442), .A1(RxFFillLevel[2]), .A2(n443), .B0(RORIC), .B1(
        n495), .Y(n396) );
  NAND4BX1 U283 ( .AN(RxFRdPtrInc), .B(n445), .C(n446), .D(n497), .Y(n443) );
  OAI222X1 U284 ( .A0(WrPtr[2]), .A1(n486), .B0(n486), .B1(n492), .C0(WrPtr[2]), .C1(n492), .Y(n488) );
  NAND2BX1 U285 ( .AN(n483), .B(n484), .Y(RxFFillLevel[1]) );
  AOI33X1 U286 ( .A0(n490), .A1(n491), .A2(n482), .B0(RdPtr[1]), .B1(WrPtr[1]), 
        .B2(n482), .Y(n484) );
  OAI33X1 U287 ( .A0(n482), .A1(WrPtr[1]), .A2(n490), .B0(n482), .B1(RdPtr[1]), 
        .B2(n491), .Y(n483) );
  XOR3X1 U288 ( .A(WrPtr[2]), .B(n486), .C(n492), .Y(RxFFillLevel[2]) );
  NAND2BX1 U289 ( .AN(WrPtr[0]), .B(RdPtr[0]), .Y(n485) );
  AO21X1 U290 ( .A0(RxFFillLevel[3]), .A1(n475), .B0(n476), .Y(NextRXRIS) );
  OAI32X1 U291 ( .A0(n477), .A1(RxDMALevel[2]), .A2(n448), .B0(n477), .B1(n478), .Y(n476) );
  OAI221X1 U292 ( .A0(RxFFillLevel[1]), .A1(n479), .B0(RxFFillLevel[2]), .B1(
        n480), .C0(n481), .Y(n478) );
  INVX1 U293 ( .A(n487), .Y(n477) );
  OAI211X1 U294 ( .A0(RxDMALevel[1]), .A1(n446), .B0(RxDMALevel[0]), .C0(n445), 
        .Y(n481) );
  INVX1 U295 ( .A(n489), .Y(n486) );
  OAI222X1 U296 ( .A0(WrPtr[1]), .A1(n485), .B0(n485), .B1(n490), .C0(WrPtr[1]), .C1(n490), .Y(n489) );
  AO21X1 U297 ( .A0(WrPtr[0]), .A1(n493), .B0(n482), .Y(RxFFillLevel[0]) );
  XOR2X1 U298 ( .A(n498), .B(RxFWrSync), .Y(n497) );
  INVX1 U299 ( .A(RxDMALevel[3]), .Y(n475) );
  INVX1 U300 ( .A(RxDMALevel[1]), .Y(n479) );
  INVX1 U301 ( .A(RxDMALevel[2]), .Y(n480) );
  NOR2BX1 U302 ( .AN(RORIM), .B(n495), .Y(RORMIS) );
  NOR2BX1 U303 ( .AN(RXIM), .B(n366), .Y(RXMIS) );
  DFFRX1 WrPtr_reg_2_ ( .D(n387), .CK(PCLK), .RN(PRESETn), .Q(WrPtr[2]), .QN(
        n496) );
  DFFRX1 RFF_reg ( .D(n395), .CK(PCLK), .RN(PRESETn), .Q(RFF), .QN(n494) );
  DFFRX1 DelRxFWrSync_reg ( .D(RxFWrSync), .CK(PCLK), .RN(PRESETn), .Q(n498)
         );
  DFFRX1 RORRIS_reg ( .D(n396), .CK(PCLK), .RN(PRESETn), .Q(RORRIS), .QN(n495)
         );
  DFFRX1 Wrap_reg ( .D(n393), .CK(PCLK), .RN(PRESETn), .Q(Wrap) );
  DFFRX1 RXRIS_reg ( .D(NextRXRIS), .CK(PCLK), .RN(PRESETn), .Q(RXRIS), .QN(
        n366) );
endmodule


module SspTxFIFO ( PCLK, PRESETn, MS, SSPDRWr, TxFRdPtrIncSync, TxRxBSYSync, 
        TXIM, FRFPCLK, DSSPCLK, PWDATAIn, TxDMALevel, TNF, TFE, BSY, TXRIS, 
        TXMIS, FIFOLTE7Full, TxDataAvlbl, TxFRdData, TxFRdDataIn, TxFFillLevel
 );
  input [1:0] FRFPCLK;
  input [3:0] DSSPCLK;
  input [15:0] PWDATAIn;
  input [3:0] TxDMALevel;
  output [15:0] TxFRdData;
  output [15:0] TxFRdDataIn;
  output [3:0] TxFFillLevel;
  input PCLK, PRESETn, MS, SSPDRWr, TxFRdPtrIncSync, TxRxBSYSync, TXIM;
  output TNF, TFE, BSY, TXRIS, TXMIS, FIFOLTE7Full, TxDataAvlbl;
  wire   RegFileWrEn;
  wire   [2:0] WrPtr;
  wire   [2:0] RdPtr;

  SspTxFCntl uSspTxFCntl ( .PCLK(PCLK), .PRESETn(PRESETn), .TXIM(TXIM), 
        .SSPDRWr(SSPDRWr), .TxFRdPtrIncSync(TxFRdPtrIncSync), .TxRxBSYSync(
        TxRxBSYSync), .TxDMALevel(TxDMALevel), .TNF(TNF), .TFE(TFE), .BSY(BSY), 
        .TXRIS(TXRIS), .TXMIS(TXMIS), .FIFOLTE7Full(FIFOLTE7Full), 
        .RegFileWrEn(RegFileWrEn), .TxDataAvlbl(TxDataAvlbl), .WrPtr(WrPtr), 
        .RdPtr(RdPtr), .TxFFillLevel(TxFFillLevel) );
  SspTxRegFile uSspTxRegFile ( .PCLK(PCLK), .PRESETn(PRESETn), .PWDATAIn(
        PWDATAIn), .RegFileWrEn(RegFileWrEn), .WrPtr(WrPtr), .RdPtr(RdPtr), 
        .TxFRdData(TxFRdData) );
  SspTxLJustify uSspTxLJustify ( .PCLK(PCLK), .PRESETn(PRESETn), .FRFPCLK(
        FRFPCLK), .DSSPCLK(DSSPCLK), .TxFRdData(TxFRdData), .MS(MS), 
        .TxFRdDataIn(TxFRdDataIn) );
endmodule


module SspTxLJustify ( PCLK, PRESETn, FRFPCLK, DSSPCLK, TxFRdData, MS, 
        TxFRdDataIn );
  input [1:0] FRFPCLK;
  input [3:0] DSSPCLK;
  input [15:0] TxFRdData;
  output [15:0] TxFRdDataIn;
  input PCLK, PRESETn, MS;
  wire   n227, n228, n229, n230, n231, n232, n233, n234, n235, n236, n237,
         n238, n239, n240, n241, n242, n243, n244, n245, n246, n247, n248,
         n249, n250, n251, n252, n253, n254, n255, n256, n257, n258, n259,
         n260, n261, n262, n263, n264, n265, n266, n267, n268, n269, n270,
         n271, n272, n273, n274, n275, n276, n277, n278, n279, n280, n281,
         n282, n283, n284, n285, n286, n287, n288, n289, n290, n291, n292,
         n293, n294, n295, n296, n297, n298, n299, n300, n301, n302, n303,
         n304, n305, n306, n307, n308, n309, n310, n311, n312, n313, n314,
         n315, n316, n317, n318, n319, n320, n321, n322, n323, n324, n325,
         n326, n327, n328, n329, n330, n331, n332, n333, n334, n335, n336,
         n339, n340, n341;
  wire   [15:0] NextTxFRdDataIn;

  OAI221X1 U310 ( .A0(n256), .A1(n248), .B0(n257), .B1(n239), .C0(n258), .Y(
        n251) );
  OA22X1 U311 ( .A0(n259), .A1(n260), .B0(n247), .B1(n261), .Y(n258) );
  OAI222X1 U312 ( .A0(n257), .A1(n247), .B0(n249), .B1(n288), .C0(n259), .C1(
        n242), .Y(n320) );
  NOR2BX1 U313 ( .AN(n279), .B(n340), .Y(NextTxFRdDataIn[2]) );
  OAI222X1 U314 ( .A0(n241), .A1(n232), .B0(n239), .B1(n249), .C0(n268), .C1(
        n233), .Y(n279) );
  OA22X1 U315 ( .A0(n257), .A1(n241), .B0(n266), .B1(n232), .Y(n265) );
  INVX1 U316 ( .A(n233), .Y(n254) );
  OAI33X1 U317 ( .A0(n233), .A1(n340), .A2(n232), .B0(n241), .B1(n340), .B2(
        n249), .Y(NextTxFRdDataIn[1]) );
  INVX1 U318 ( .A(n241), .Y(n255) );
  INVX1 U319 ( .A(n259), .Y(n244) );
  INVX1 U320 ( .A(n266), .Y(n236) );
  INVX1 U321 ( .A(n264), .Y(n238) );
  INVX1 U322 ( .A(n296), .Y(n237) );
  OAI2BB1X1 U323 ( .A0N(n340), .A1N(TxFRdData[2]), .B0(n324), .Y(
        NextTxFRdDataIn[10]) );
  OAI31X1 U324 ( .A0(n325), .A1(n326), .A2(n327), .B0(n230), .Y(n324) );
  OAI222X1 U325 ( .A0(n247), .A1(n260), .B0(n257), .B1(n248), .C0(n259), .C1(
        n240), .Y(n326) );
  OAI222X1 U326 ( .A0(n249), .A1(n295), .B0(n239), .B1(n242), .C0(n241), .C1(
        n234), .Y(n327) );
  OAI2BB1X1 U327 ( .A0N(n340), .A1N(TxFRdData[7]), .B0(n280), .Y(
        NextTxFRdDataIn[15]) );
  OAI31X1 U328 ( .A0(n281), .A1(n282), .A2(n283), .B0(n230), .Y(n280) );
  OAI222X1 U329 ( .A0(n239), .A1(n284), .B0(n248), .B1(n285), .C0(n241), .C1(
        n286), .Y(n283) );
  OAI221X1 U330 ( .A0(n261), .A1(n287), .B0(n256), .B1(n288), .C0(n289), .Y(
        n282) );
  AO21X1 U331 ( .A0(n340), .A1(TxFRdData[1]), .B0(n227), .Y(NextTxFRdDataIn[9]) );
  OA21X2 U332 ( .A0(n228), .A1(n229), .B0(n230), .Y(n227) );
  OAI221X1 U333 ( .A0(n239), .A1(n240), .B0(n241), .B1(n242), .C0(n243), .Y(
        n228) );
  OAI221X1 U334 ( .A0(n231), .A1(n232), .B0(n233), .B1(n234), .C0(n235), .Y(
        n229) );
  INVX1 U335 ( .A(TxFRdData[3]), .Y(n261) );
  OAI221X1 U336 ( .A0(n249), .A1(n230), .B0(n249), .B1(n231), .C0(n250), .Y(
        NextTxFRdDataIn[8]) );
  OAI31X1 U337 ( .A0(n251), .A1(n252), .A2(n253), .B0(n230), .Y(n250) );
  AO22X1 U338 ( .A0(TxFRdData[2]), .A1(n236), .B0(n255), .B1(TxFRdData[7]), 
        .Y(n252) );
  AO22X1 U339 ( .A0(n254), .A1(TxFRdData[8]), .B0(TxFRdData[1]), .B1(n238), 
        .Y(n253) );
  OAI221X1 U340 ( .A0(n268), .A1(n231), .B0(n233), .B1(n291), .C0(n334), .Y(
        n325) );
  AOI222X1 U341 ( .A0(n236), .A1(TxFRdData[4]), .B0(TxFRdData[1]), .B1(n237), 
        .C0(n238), .C1(TxFRdData[3]), .Y(n334) );
  INVX1 U342 ( .A(TxFRdData[5]), .Y(n260) );
  AOI222X1 U343 ( .A0(TxFRdData[3]), .A1(n236), .B0(TxFRdData[0]), .B1(n237), 
        .C0(TxFRdData[2]), .C1(n238), .Y(n235) );
  AOI222X1 U344 ( .A0(TxFRdData[6]), .A1(n244), .B0(TxFRdData[5]), .B1(n245), 
        .C0(TxFRdData[4]), .C1(n246), .Y(n243) );
  INVX1 U345 ( .A(n248), .Y(n245) );
  INVX1 U346 ( .A(n247), .Y(n246) );
  OAI211X1 U347 ( .A0(n266), .A1(n234), .B0(n292), .C0(n293), .Y(n281) );
  OA22X1 U348 ( .A0(n260), .A1(n295), .B0(n257), .B1(n296), .Y(n292) );
  AOI222X1 U349 ( .A0(TxFRdData[15]), .A1(n254), .B0(n238), .B1(TxFRdData[8]), 
        .C0(n294), .C1(TxFRdData[7]), .Y(n293) );
  INVX1 U350 ( .A(n231), .Y(n294) );
  NAND2BX1 U351 ( .AN(n322), .B(n329), .Y(n259) );
  NAND2BX1 U352 ( .AN(n331), .B(n316), .Y(n233) );
  NAND2BX1 U353 ( .AN(n328), .B(n333), .Y(n247) );
  NAND2BX1 U354 ( .AN(n328), .B(n329), .Y(n241) );
  NAND2BX1 U355 ( .AN(n330), .B(n329), .Y(n239) );
  NAND2BX1 U356 ( .AN(n332), .B(n316), .Y(n248) );
  OR2X1 U357 ( .A(n332), .B(n330), .Y(n266) );
  NAND2BX1 U358 ( .AN(n336), .B(n316), .Y(n231) );
  NAND2BX1 U359 ( .AN(n328), .B(n323), .Y(n296) );
  NAND2BX1 U360 ( .AN(n322), .B(n333), .Y(n264) );
  NOR3BX1 U361 ( .AN(TxFRdData[0]), .B(n233), .C(n340), .Y(NextTxFRdDataIn[0])
         );
  NAND2BX1 U362 ( .AN(n330), .B(n323), .Y(n295) );
  NAND2BX1 U363 ( .AN(n322), .B(n323), .Y(n288) );
  OAI222X1 U364 ( .A0(n239), .A1(n234), .B0(n248), .B1(n240), .C0(n241), .C1(
        n291), .Y(n321) );
  OAI222X1 U365 ( .A0(n239), .A1(n291), .B0(n248), .B1(n242), .C0(n241), .C1(
        n285), .Y(n313) );
  OAI222X1 U366 ( .A0(n239), .A1(n285), .B0(n248), .B1(n234), .C0(n241), .C1(
        n290), .Y(n307) );
  OAI222X1 U367 ( .A0(n239), .A1(n290), .B0(n248), .B1(n291), .C0(n241), .C1(
        n284), .Y(n301) );
  OAI221X1 U368 ( .A0(n249), .A1(n287), .B0(n232), .B1(n288), .C0(n314), .Y(
        n312) );
  OA22X1 U369 ( .A0(n259), .A1(n234), .B0(n247), .B1(n240), .Y(n314) );
  OAI221X1 U370 ( .A0(n232), .A1(n287), .B0(n268), .B1(n288), .C0(n308), .Y(
        n306) );
  OA22X1 U371 ( .A0(n259), .A1(n291), .B0(n247), .B1(n242), .Y(n308) );
  OAI221X1 U372 ( .A0(n268), .A1(n287), .B0(n261), .B1(n288), .C0(n302), .Y(
        n300) );
  OA22X1 U373 ( .A0(n259), .A1(n285), .B0(n247), .B1(n234), .Y(n302) );
  INVX1 U374 ( .A(n336), .Y(n323) );
  OA22X1 U375 ( .A0(n259), .A1(n290), .B0(n247), .B1(n291), .Y(n289) );
  INVX1 U376 ( .A(n331), .Y(n329) );
  AO22X1 U377 ( .A0(n340), .A1(TxFRdData[3]), .B0(n317), .B1(n230), .Y(
        NextTxFRdDataIn[11]) );
  OR4X1 U378 ( .A(n318), .B(n319), .C(n320), .D(n321), .Y(n317) );
  OAI222X1 U379 ( .A0(n296), .A1(n268), .B0(n232), .B1(n295), .C0(n260), .C1(
        n266), .Y(n318) );
  OAI222X1 U380 ( .A0(n261), .A1(n231), .B0(n256), .B1(n264), .C0(n233), .C1(
        n285), .Y(n319) );
  AO22X1 U381 ( .A0(n340), .A1(TxFRdData[4]), .B0(n309), .B1(n230), .Y(
        NextTxFRdDataIn[12]) );
  OR4X1 U382 ( .A(n310), .B(n311), .C(n312), .D(n313), .Y(n309) );
  OAI222X1 U383 ( .A0(n296), .A1(n261), .B0(n268), .B1(n295), .C0(n257), .C1(
        n266), .Y(n310) );
  OAI222X1 U384 ( .A0(n256), .A1(n231), .B0(n260), .B1(n264), .C0(n233), .C1(
        n290), .Y(n311) );
  AO22X1 U385 ( .A0(n340), .A1(TxFRdData[5]), .B0(n303), .B1(n230), .Y(
        NextTxFRdDataIn[13]) );
  OR4X1 U386 ( .A(n304), .B(n305), .C(n306), .D(n307), .Y(n303) );
  OAI222X1 U387 ( .A0(n256), .A1(n296), .B0(n261), .B1(n295), .C0(n240), .C1(
        n266), .Y(n304) );
  OAI222X1 U388 ( .A0(n260), .A1(n231), .B0(n257), .B1(n264), .C0(n233), .C1(
        n284), .Y(n305) );
  AO22X1 U389 ( .A0(n340), .A1(TxFRdData[6]), .B0(n297), .B1(n230), .Y(
        NextTxFRdDataIn[14]) );
  OR4X1 U390 ( .A(n298), .B(n299), .C(n300), .D(n301), .Y(n297) );
  OAI222X1 U391 ( .A0(n260), .A1(n296), .B0(n256), .B1(n295), .C0(n242), .C1(
        n266), .Y(n298) );
  OAI222X1 U392 ( .A0(n257), .A1(n231), .B0(n240), .B1(n264), .C0(n233), .C1(
        n286), .Y(n299) );
  INVX1 U393 ( .A(n332), .Y(n333) );
  INVX1 U394 ( .A(TxFRdData[1]), .Y(n232) );
  OA21X2 U395 ( .A0(n274), .A1(n275), .B0(n230), .Y(NextTxFRdDataIn[4]) );
  AO22X1 U396 ( .A0(n254), .A1(TxFRdData[4]), .B0(TxFRdData[3]), .B1(n255), 
        .Y(n275) );
  OAI222X1 U397 ( .A0(n248), .A1(n249), .B0(n259), .B1(n232), .C0(n239), .C1(
        n268), .Y(n274) );
  OA21X2 U398 ( .A0(n272), .A1(n273), .B0(n230), .Y(NextTxFRdDataIn[5]) );
  OAI222X1 U399 ( .A0(n247), .A1(n249), .B0(n248), .B1(n232), .C0(n259), .C1(
        n268), .Y(n272) );
  OAI222X1 U400 ( .A0(n256), .A1(n241), .B0(n239), .B1(n261), .C0(n260), .C1(
        n233), .Y(n273) );
  OA21X2 U401 ( .A0(n269), .A1(n270), .B0(n230), .Y(NextTxFRdDataIn[6]) );
  OAI222X1 U402 ( .A0(n249), .A1(n266), .B0(n260), .B1(n241), .C0(n257), .C1(
        n233), .Y(n270) );
  OAI221X1 U403 ( .A0(n248), .A1(n268), .B0(n256), .B1(n239), .C0(n271), .Y(
        n269) );
  OA22X1 U404 ( .A0(n259), .A1(n261), .B0(n247), .B1(n232), .Y(n271) );
  OA21X1 U405 ( .A0(n262), .A1(n263), .B0(n230), .Y(NextTxFRdDataIn[7]) );
  OAI221X1 U406 ( .A0(n248), .A1(n261), .B0(n260), .B1(n239), .C0(n267), .Y(
        n262) );
  OAI221X1 U407 ( .A0(n249), .A1(n264), .B0(n240), .B1(n233), .C0(n265), .Y(
        n263) );
  OA22X1 U408 ( .A0(n259), .A1(n256), .B0(n247), .B1(n268), .Y(n267) );
  OA21X1 U409 ( .A0(n276), .A1(n277), .B0(n230), .Y(NextTxFRdDataIn[3]) );
  AO22X1 U410 ( .A0(TxFRdData[1]), .A1(n278), .B0(TxFRdData[0]), .B1(n244), 
        .Y(n276) );
  AO22X1 U411 ( .A0(n254), .A1(TxFRdData[3]), .B0(TxFRdData[2]), .B1(n255), 
        .Y(n277) );
  INVX1 U412 ( .A(n239), .Y(n278) );
  INVX1 U413 ( .A(TxFRdData[2]), .Y(n268) );
  INVX1 U414 ( .A(TxFRdData[0]), .Y(n249) );
  INVX1 U415 ( .A(TxFRdData[4]), .Y(n256) );
  INVX1 U416 ( .A(TxFRdData[6]), .Y(n257) );
  INVX1 U417 ( .A(TxFRdData[7]), .Y(n240) );
  INVX1 U418 ( .A(TxFRdData[8]), .Y(n242) );
  NAND2BX1 U419 ( .AN(DSSPCLK[1]), .B(DSSPCLK[0]), .Y(n330) );
  NAND2BX1 U420 ( .AN(DSSPCLK[3]), .B(DSSPCLK[2]), .Y(n336) );
  NAND2BX1 U421 ( .AN(DSSPCLK[2]), .B(DSSPCLK[3]), .Y(n332) );
  NAND2BX1 U422 ( .AN(n315), .B(DSSPCLK[3]), .Y(n331) );
  AND2X2 U423 ( .A(n341), .B(FRFPCLK[1]), .Y(n340) );
  INVX1 U424 ( .A(n340), .Y(n230) );
  NOR2X1 U425 ( .A(MS), .B(FRFPCLK[0]), .Y(n341) );
  NAND2BX1 U426 ( .AN(DSSPCLK[0]), .B(DSSPCLK[1]), .Y(n328) );
  NAND3BX1 U427 ( .AN(DSSPCLK[3]), .B(n315), .C(n316), .Y(n287) );
  INVX1 U428 ( .A(DSSPCLK[1]), .Y(n335) );
  NAND2BX1 U429 ( .AN(DSSPCLK[0]), .B(n335), .Y(n322) );
  INVX1 U430 ( .A(DSSPCLK[2]), .Y(n315) );
  INVX1 U431 ( .A(n339), .Y(n316) );
  NAND2BX1 U432 ( .AN(n335), .B(DSSPCLK[0]), .Y(n339) );
  INVX1 U433 ( .A(TxFRdData[9]), .Y(n234) );
  INVX1 U434 ( .A(TxFRdData[10]), .Y(n291) );
  INVX1 U435 ( .A(TxFRdData[11]), .Y(n285) );
  INVX1 U436 ( .A(TxFRdData[12]), .Y(n290) );
  INVX1 U437 ( .A(TxFRdData[13]), .Y(n284) );
  INVX1 U438 ( .A(TxFRdData[14]), .Y(n286) );
  DFFRX1 TxFRdDataIn_reg_15_ ( .D(NextTxFRdDataIn[15]), .CK(PCLK), .RN(PRESETn), .Q(TxFRdDataIn[15]) );
  DFFRX1 TxFRdDataIn_reg_0_ ( .D(NextTxFRdDataIn[0]), .CK(PCLK), .RN(PRESETn), 
        .Q(TxFRdDataIn[0]) );
  DFFRX1 TxFRdDataIn_reg_1_ ( .D(NextTxFRdDataIn[1]), .CK(PCLK), .RN(PRESETn), 
        .Q(TxFRdDataIn[1]) );
  DFFRX1 TxFRdDataIn_reg_2_ ( .D(NextTxFRdDataIn[2]), .CK(PCLK), .RN(PRESETn), 
        .Q(TxFRdDataIn[2]) );
  DFFRX1 TxFRdDataIn_reg_3_ ( .D(NextTxFRdDataIn[3]), .CK(PCLK), .RN(PRESETn), 
        .Q(TxFRdDataIn[3]) );
  DFFRX1 TxFRdDataIn_reg_4_ ( .D(NextTxFRdDataIn[4]), .CK(PCLK), .RN(PRESETn), 
        .Q(TxFRdDataIn[4]) );
  DFFRX1 TxFRdDataIn_reg_5_ ( .D(NextTxFRdDataIn[5]), .CK(PCLK), .RN(PRESETn), 
        .Q(TxFRdDataIn[5]) );
  DFFRX1 TxFRdDataIn_reg_6_ ( .D(NextTxFRdDataIn[6]), .CK(PCLK), .RN(PRESETn), 
        .Q(TxFRdDataIn[6]) );
  DFFRX1 TxFRdDataIn_reg_7_ ( .D(NextTxFRdDataIn[7]), .CK(PCLK), .RN(PRESETn), 
        .Q(TxFRdDataIn[7]) );
  DFFRX1 TxFRdDataIn_reg_8_ ( .D(NextTxFRdDataIn[8]), .CK(PCLK), .RN(PRESETn), 
        .Q(TxFRdDataIn[8]) );
  DFFRX1 TxFRdDataIn_reg_9_ ( .D(NextTxFRdDataIn[9]), .CK(PCLK), .RN(PRESETn), 
        .Q(TxFRdDataIn[9]) );
  DFFRX1 TxFRdDataIn_reg_10_ ( .D(NextTxFRdDataIn[10]), .CK(PCLK), .RN(PRESETn), .Q(TxFRdDataIn[10]) );
  DFFRX1 TxFRdDataIn_reg_11_ ( .D(NextTxFRdDataIn[11]), .CK(PCLK), .RN(PRESETn), .Q(TxFRdDataIn[11]) );
  DFFRX1 TxFRdDataIn_reg_12_ ( .D(NextTxFRdDataIn[12]), .CK(PCLK), .RN(PRESETn), .Q(TxFRdDataIn[12]) );
  DFFRX1 TxFRdDataIn_reg_13_ ( .D(NextTxFRdDataIn[13]), .CK(PCLK), .RN(PRESETn), .Q(TxFRdDataIn[13]) );
  DFFRX1 TxFRdDataIn_reg_14_ ( .D(NextTxFRdDataIn[14]), .CK(PCLK), .RN(PRESETn), .Q(TxFRdDataIn[14]) );
endmodule


module SspTxRegFile ( PCLK, PRESETn, PWDATAIn, RegFileWrEn, WrPtr, RdPtr, 
        TxFRdData );
  input [15:0] PWDATAIn;
  input [2:0] WrPtr;
  input [2:0] RdPtr;
  output [15:0] TxFRdData;
  input PCLK, PRESETn, RegFileWrEn;
  wire   n1004, n1005, n1006, n1007, n1008, n1009, n1010, n1011, n1012, n1013,
         n1014, n1015, n1016, n1017, n1018, n1019, n1020, n1021, n1022, n1023,
         n1024, n1025, n1026, n1027, n1028, n1029, n1030, n1031, n1032, n1033,
         n1034, n1035, n1036, n1037, n1038, n1039, n1040, n1041, n1042, n1043,
         n1044, n1045, n1046, n1047, n1048, n1049, n1050, n1051, n1052, n1053,
         n1054, n1055, n1056, n1057, n1058, n1059, n1060, n1061, n1062, n1063,
         n1064, n1065, n1066, n1067, n1068, n1069, n1070, n1071, n1072, n1073,
         n1074, n1075, n1076, n1077, n1078, n1079, n1080, n1081, n1082, n1083,
         n1084, n1085, n1086, n1087, n1088, n1089, n1090, n1091, n1092, n1093,
         n1094, n1095, n1096, n1097, n1098, n1099, n1100, n1101, n1102, n1103,
         n1104, n1105, n1106, n1107, n1108, n1109, n1110, n1111, n1112, n1113,
         n1114, n1115, n1116, n1117, n1118, n1119, n1120, n1121, n1122, n1123,
         n1124, n1125, n1126, n1127, n1128, n1129, n1130, n1131, n1140, n1144,
         n1145, n1146, n1147, n1148, n1149, n1150, n1153, n1154, n1155, n1156,
         n1157, n1158, n1159, n1160, n1161, n1162, n1164, n1165, n1166, n1167,
         n1168, n1169, n1170, n1171, n1172, n1173, n1174, n1176, n1177, n1178,
         n1180, n1181, n1182, n1184, n1185, n1186, n1188, n1189, n1190, n1192,
         n1193, n1194, n1196, n1197, n1198, n1200, n1201, n1202, n1204, n1205,
         n1206, n1208, n1209, n1210, n1212, n1213, n1214, n1216, n1217, n1218,
         n1220, n1221, n1222, n1224, n1225, n1226, n1228, n1229, n1230, n1232,
         n1233, n1234, n1235, n1236, n1237, n1238, n1239, n1240, n1241, n1242,
         n1243, n1244, n1245, n1246, n1247, n1248, n1249, n1250, n1251, n1252,
         n1253, n1254, n1255, n1256, n1257, n1258, n1259, n1260, n1261, n1262,
         n1263, n1264, n1265, n1266, n1267, n1268;
  wire   [15:0] TxReg0;
  wire   [15:0] TxReg1;
  wire   [15:0] TxReg2;
  wire   [15:0] TxReg3;
  wire   [15:0] TxReg4;
  wire   [15:0] TxReg5;
  wire   [15:0] TxReg6;
  wire   [15:0] TxReg7;

  INVX1 U935 ( .A(n1264), .Y(n1157) );
  INVX1 U936 ( .A(n1265), .Y(n1154) );
  INVX1 U937 ( .A(n1268), .Y(n1145) );
  INVX1 U938 ( .A(n1263), .Y(n1159) );
  INVX1 U939 ( .A(n1267), .Y(n1147) );
  INVX1 U940 ( .A(n1262), .Y(n1161) );
  INVX1 U941 ( .A(n1266), .Y(n1149) );
  INVX1 U942 ( .A(n1235), .Y(n1168) );
  INVX1 U943 ( .A(n1236), .Y(n1167) );
  INVX1 U944 ( .A(n1234), .Y(n1169) );
  NAND4BX1 U945 ( .AN(n1239), .B(n1236), .C(n1235), .D(n1234), .Y(n1164) );
  BUFX2 U946 ( .A(n1160), .Y(n1262) );
  NAND3BX1 U947 ( .AN(WrPtr[1]), .B(n1150), .C(n1155), .Y(n1160) );
  BUFX2 U948 ( .A(n1148), .Y(n1266) );
  NAND3BX1 U949 ( .AN(WrPtr[1]), .B(n1150), .C(n1261), .Y(n1148) );
  BUFX2 U950 ( .A(n1156), .Y(n1264) );
  NAND3BX1 U951 ( .AN(WrPtr[0]), .B(WrPtr[1]), .C(n1155), .Y(n1156) );
  BUFX2 U952 ( .A(n1153), .Y(n1265) );
  NAND3BX1 U953 ( .AN(n1150), .B(WrPtr[1]), .C(n1155), .Y(n1153) );
  BUFX2 U954 ( .A(n1144), .Y(n1268) );
  NAND3BX1 U955 ( .AN(WrPtr[0]), .B(WrPtr[1]), .C(n1261), .Y(n1144) );
  BUFX2 U956 ( .A(n1158), .Y(n1263) );
  NAND3BX1 U957 ( .AN(WrPtr[1]), .B(WrPtr[0]), .C(n1155), .Y(n1158) );
  BUFX2 U958 ( .A(n1146), .Y(n1267) );
  NAND3BX1 U959 ( .AN(WrPtr[1]), .B(WrPtr[0]), .C(n1261), .Y(n1146) );
  AND3X2 U960 ( .A(WrPtr[1]), .B(WrPtr[0]), .C(n1261), .Y(n1260) );
  INVX1 U961 ( .A(n1260), .Y(n1140) );
  AO22X1 U962 ( .A0(TxReg7[15]), .A1(n1140), .B0(PWDATAIn[15]), .B1(n1260), 
        .Y(n1116) );
  AO22X1 U963 ( .A0(TxReg7[14]), .A1(n1140), .B0(PWDATAIn[14]), .B1(n1260), 
        .Y(n1117) );
  AO22X1 U964 ( .A0(TxReg7[13]), .A1(n1140), .B0(PWDATAIn[13]), .B1(n1260), 
        .Y(n1118) );
  AO22X1 U965 ( .A0(TxReg7[12]), .A1(n1140), .B0(PWDATAIn[12]), .B1(n1260), 
        .Y(n1119) );
  AO22X1 U966 ( .A0(TxReg7[11]), .A1(n1140), .B0(PWDATAIn[11]), .B1(n1260), 
        .Y(n1120) );
  AO22X1 U967 ( .A0(TxReg7[10]), .A1(n1140), .B0(PWDATAIn[10]), .B1(n1260), 
        .Y(n1121) );
  AO22X1 U968 ( .A0(TxReg7[9]), .A1(n1140), .B0(PWDATAIn[9]), .B1(n1260), .Y(
        n1122) );
  AO22X1 U969 ( .A0(TxReg7[8]), .A1(n1140), .B0(PWDATAIn[8]), .B1(n1260), .Y(
        n1123) );
  AO22X1 U970 ( .A0(TxReg7[7]), .A1(n1140), .B0(PWDATAIn[7]), .B1(n1260), .Y(
        n1124) );
  AO22X1 U971 ( .A0(TxReg7[6]), .A1(n1140), .B0(PWDATAIn[6]), .B1(n1260), .Y(
        n1125) );
  AO22X1 U972 ( .A0(TxReg7[5]), .A1(n1140), .B0(PWDATAIn[5]), .B1(n1260), .Y(
        n1126) );
  AO22X1 U973 ( .A0(TxReg7[4]), .A1(n1140), .B0(PWDATAIn[4]), .B1(n1260), .Y(
        n1127) );
  AO22X1 U974 ( .A0(TxReg7[3]), .A1(n1140), .B0(PWDATAIn[3]), .B1(n1260), .Y(
        n1128) );
  AO22X1 U975 ( .A0(TxReg7[2]), .A1(n1140), .B0(PWDATAIn[2]), .B1(n1260), .Y(
        n1129) );
  AO22X1 U976 ( .A0(TxReg7[1]), .A1(n1140), .B0(PWDATAIn[1]), .B1(n1260), .Y(
        n1130) );
  AO22X1 U977 ( .A0(TxReg7[0]), .A1(n1140), .B0(PWDATAIn[0]), .B1(n1260), .Y(
        n1131) );
  AO22X1 U978 ( .A0(TxReg0[15]), .A1(n1262), .B0(n1161), .B1(PWDATAIn[15]), 
        .Y(n1004) );
  AO22X1 U979 ( .A0(TxReg0[14]), .A1(n1262), .B0(n1161), .B1(PWDATAIn[14]), 
        .Y(n1005) );
  AO22X1 U980 ( .A0(TxReg0[13]), .A1(n1262), .B0(n1161), .B1(PWDATAIn[13]), 
        .Y(n1006) );
  AO22X1 U981 ( .A0(TxReg0[12]), .A1(n1262), .B0(n1161), .B1(PWDATAIn[12]), 
        .Y(n1007) );
  AO22X1 U982 ( .A0(TxReg0[11]), .A1(n1262), .B0(n1161), .B1(PWDATAIn[11]), 
        .Y(n1008) );
  AO22X1 U983 ( .A0(TxReg0[10]), .A1(n1262), .B0(n1161), .B1(PWDATAIn[10]), 
        .Y(n1009) );
  AO22X1 U984 ( .A0(TxReg0[9]), .A1(n1262), .B0(n1161), .B1(PWDATAIn[9]), .Y(
        n1010) );
  AO22X1 U985 ( .A0(TxReg0[8]), .A1(n1262), .B0(n1161), .B1(PWDATAIn[8]), .Y(
        n1011) );
  AO22X1 U986 ( .A0(TxReg0[7]), .A1(n1262), .B0(n1161), .B1(PWDATAIn[7]), .Y(
        n1012) );
  AO22X1 U987 ( .A0(TxReg0[6]), .A1(n1262), .B0(n1161), .B1(PWDATAIn[6]), .Y(
        n1013) );
  AO22X1 U988 ( .A0(TxReg0[5]), .A1(n1262), .B0(n1161), .B1(PWDATAIn[5]), .Y(
        n1014) );
  AO22X1 U989 ( .A0(TxReg0[4]), .A1(n1262), .B0(n1161), .B1(PWDATAIn[4]), .Y(
        n1015) );
  AO22X1 U990 ( .A0(TxReg0[3]), .A1(n1262), .B0(n1161), .B1(PWDATAIn[3]), .Y(
        n1016) );
  AO22X1 U991 ( .A0(TxReg0[2]), .A1(n1262), .B0(n1161), .B1(PWDATAIn[2]), .Y(
        n1017) );
  AO22X1 U992 ( .A0(TxReg0[1]), .A1(n1262), .B0(n1161), .B1(PWDATAIn[1]), .Y(
        n1018) );
  AO22X1 U993 ( .A0(TxReg0[0]), .A1(n1262), .B0(n1161), .B1(PWDATAIn[0]), .Y(
        n1019) );
  AO22X1 U994 ( .A0(TxReg1[15]), .A1(n1263), .B0(n1159), .B1(PWDATAIn[15]), 
        .Y(n1020) );
  AO22X1 U995 ( .A0(TxReg1[14]), .A1(n1263), .B0(n1159), .B1(PWDATAIn[14]), 
        .Y(n1021) );
  AO22X1 U996 ( .A0(TxReg1[13]), .A1(n1263), .B0(n1159), .B1(PWDATAIn[13]), 
        .Y(n1022) );
  AO22X1 U997 ( .A0(TxReg1[12]), .A1(n1263), .B0(n1159), .B1(PWDATAIn[12]), 
        .Y(n1023) );
  AO22X1 U998 ( .A0(TxReg1[11]), .A1(n1263), .B0(n1159), .B1(PWDATAIn[11]), 
        .Y(n1024) );
  AO22X1 U999 ( .A0(TxReg1[10]), .A1(n1263), .B0(n1159), .B1(PWDATAIn[10]), 
        .Y(n1025) );
  AO22X1 U1000 ( .A0(TxReg1[9]), .A1(n1263), .B0(n1159), .B1(PWDATAIn[9]), .Y(
        n1026) );
  AO22X1 U1001 ( .A0(TxReg1[8]), .A1(n1263), .B0(n1159), .B1(PWDATAIn[8]), .Y(
        n1027) );
  AO22X1 U1002 ( .A0(TxReg1[7]), .A1(n1263), .B0(n1159), .B1(PWDATAIn[7]), .Y(
        n1028) );
  AO22X1 U1003 ( .A0(TxReg1[6]), .A1(n1263), .B0(n1159), .B1(PWDATAIn[6]), .Y(
        n1029) );
  AO22X1 U1004 ( .A0(TxReg1[5]), .A1(n1263), .B0(n1159), .B1(PWDATAIn[5]), .Y(
        n1030) );
  AO22X1 U1005 ( .A0(TxReg1[4]), .A1(n1263), .B0(n1159), .B1(PWDATAIn[4]), .Y(
        n1031) );
  AO22X1 U1006 ( .A0(TxReg1[3]), .A1(n1263), .B0(n1159), .B1(PWDATAIn[3]), .Y(
        n1032) );
  AO22X1 U1007 ( .A0(TxReg1[2]), .A1(n1263), .B0(n1159), .B1(PWDATAIn[2]), .Y(
        n1033) );
  AO22X1 U1008 ( .A0(TxReg1[1]), .A1(n1263), .B0(n1159), .B1(PWDATAIn[1]), .Y(
        n1034) );
  AO22X1 U1009 ( .A0(TxReg1[0]), .A1(n1263), .B0(n1159), .B1(PWDATAIn[0]), .Y(
        n1035) );
  AO22X1 U1010 ( .A0(TxReg2[15]), .A1(n1264), .B0(n1157), .B1(PWDATAIn[15]), 
        .Y(n1036) );
  AO22X1 U1011 ( .A0(TxReg2[14]), .A1(n1264), .B0(n1157), .B1(PWDATAIn[14]), 
        .Y(n1037) );
  AO22X1 U1012 ( .A0(TxReg2[13]), .A1(n1264), .B0(n1157), .B1(PWDATAIn[13]), 
        .Y(n1038) );
  AO22X1 U1013 ( .A0(TxReg2[12]), .A1(n1264), .B0(n1157), .B1(PWDATAIn[12]), 
        .Y(n1039) );
  AO22X1 U1014 ( .A0(TxReg2[11]), .A1(n1264), .B0(n1157), .B1(PWDATAIn[11]), 
        .Y(n1040) );
  AO22X1 U1015 ( .A0(TxReg2[10]), .A1(n1264), .B0(n1157), .B1(PWDATAIn[10]), 
        .Y(n1041) );
  AO22X1 U1016 ( .A0(TxReg2[9]), .A1(n1264), .B0(n1157), .B1(PWDATAIn[9]), .Y(
        n1042) );
  AO22X1 U1017 ( .A0(TxReg2[8]), .A1(n1264), .B0(n1157), .B1(PWDATAIn[8]), .Y(
        n1043) );
  AO22X1 U1018 ( .A0(TxReg2[7]), .A1(n1264), .B0(n1157), .B1(PWDATAIn[7]), .Y(
        n1044) );
  AO22X1 U1019 ( .A0(TxReg2[6]), .A1(n1264), .B0(n1157), .B1(PWDATAIn[6]), .Y(
        n1045) );
  AO22X1 U1020 ( .A0(TxReg2[5]), .A1(n1264), .B0(n1157), .B1(PWDATAIn[5]), .Y(
        n1046) );
  AO22X1 U1021 ( .A0(TxReg2[4]), .A1(n1264), .B0(n1157), .B1(PWDATAIn[4]), .Y(
        n1047) );
  AO22X1 U1022 ( .A0(TxReg2[3]), .A1(n1264), .B0(n1157), .B1(PWDATAIn[3]), .Y(
        n1048) );
  AO22X1 U1023 ( .A0(TxReg2[2]), .A1(n1264), .B0(n1157), .B1(PWDATAIn[2]), .Y(
        n1049) );
  AO22X1 U1024 ( .A0(TxReg2[1]), .A1(n1264), .B0(n1157), .B1(PWDATAIn[1]), .Y(
        n1050) );
  AO22X1 U1025 ( .A0(TxReg2[0]), .A1(n1264), .B0(n1157), .B1(PWDATAIn[0]), .Y(
        n1051) );
  AO22X1 U1026 ( .A0(TxReg3[15]), .A1(n1265), .B0(n1154), .B1(PWDATAIn[15]), 
        .Y(n1052) );
  AO22X1 U1027 ( .A0(TxReg3[14]), .A1(n1265), .B0(n1154), .B1(PWDATAIn[14]), 
        .Y(n1053) );
  AO22X1 U1028 ( .A0(TxReg3[13]), .A1(n1265), .B0(n1154), .B1(PWDATAIn[13]), 
        .Y(n1054) );
  AO22X1 U1029 ( .A0(TxReg3[12]), .A1(n1265), .B0(n1154), .B1(PWDATAIn[12]), 
        .Y(n1055) );
  AO22X1 U1030 ( .A0(TxReg3[11]), .A1(n1265), .B0(n1154), .B1(PWDATAIn[11]), 
        .Y(n1056) );
  AO22X1 U1031 ( .A0(TxReg3[10]), .A1(n1265), .B0(n1154), .B1(PWDATAIn[10]), 
        .Y(n1057) );
  AO22X1 U1032 ( .A0(TxReg3[9]), .A1(n1265), .B0(n1154), .B1(PWDATAIn[9]), .Y(
        n1058) );
  AO22X1 U1033 ( .A0(TxReg3[8]), .A1(n1265), .B0(n1154), .B1(PWDATAIn[8]), .Y(
        n1059) );
  AO22X1 U1034 ( .A0(TxReg3[7]), .A1(n1265), .B0(n1154), .B1(PWDATAIn[7]), .Y(
        n1060) );
  AO22X1 U1035 ( .A0(TxReg3[6]), .A1(n1265), .B0(n1154), .B1(PWDATAIn[6]), .Y(
        n1061) );
  AO22X1 U1036 ( .A0(TxReg3[5]), .A1(n1265), .B0(n1154), .B1(PWDATAIn[5]), .Y(
        n1062) );
  AO22X1 U1037 ( .A0(TxReg3[4]), .A1(n1265), .B0(n1154), .B1(PWDATAIn[4]), .Y(
        n1063) );
  AO22X1 U1038 ( .A0(TxReg3[3]), .A1(n1265), .B0(n1154), .B1(PWDATAIn[3]), .Y(
        n1064) );
  AO22X1 U1039 ( .A0(TxReg3[2]), .A1(n1265), .B0(n1154), .B1(PWDATAIn[2]), .Y(
        n1065) );
  AO22X1 U1040 ( .A0(TxReg3[1]), .A1(n1265), .B0(n1154), .B1(PWDATAIn[1]), .Y(
        n1066) );
  AO22X1 U1041 ( .A0(TxReg3[0]), .A1(n1265), .B0(n1154), .B1(PWDATAIn[0]), .Y(
        n1067) );
  AO22X1 U1042 ( .A0(TxReg4[15]), .A1(n1266), .B0(n1149), .B1(PWDATAIn[15]), 
        .Y(n1068) );
  AO22X1 U1043 ( .A0(TxReg4[14]), .A1(n1266), .B0(n1149), .B1(PWDATAIn[14]), 
        .Y(n1069) );
  AO22X1 U1044 ( .A0(TxReg4[13]), .A1(n1266), .B0(n1149), .B1(PWDATAIn[13]), 
        .Y(n1070) );
  AO22X1 U1045 ( .A0(TxReg4[12]), .A1(n1266), .B0(n1149), .B1(PWDATAIn[12]), 
        .Y(n1071) );
  AO22X1 U1046 ( .A0(TxReg4[11]), .A1(n1266), .B0(n1149), .B1(PWDATAIn[11]), 
        .Y(n1072) );
  AO22X1 U1047 ( .A0(TxReg4[10]), .A1(n1266), .B0(n1149), .B1(PWDATAIn[10]), 
        .Y(n1073) );
  AO22X1 U1048 ( .A0(TxReg4[9]), .A1(n1266), .B0(n1149), .B1(PWDATAIn[9]), .Y(
        n1074) );
  AO22X1 U1049 ( .A0(TxReg4[8]), .A1(n1266), .B0(n1149), .B1(PWDATAIn[8]), .Y(
        n1075) );
  AO22X1 U1050 ( .A0(TxReg4[7]), .A1(n1266), .B0(n1149), .B1(PWDATAIn[7]), .Y(
        n1076) );
  AO22X1 U1051 ( .A0(TxReg4[6]), .A1(n1266), .B0(n1149), .B1(PWDATAIn[6]), .Y(
        n1077) );
  AO22X1 U1052 ( .A0(TxReg4[5]), .A1(n1266), .B0(n1149), .B1(PWDATAIn[5]), .Y(
        n1078) );
  AO22X1 U1053 ( .A0(TxReg4[4]), .A1(n1266), .B0(n1149), .B1(PWDATAIn[4]), .Y(
        n1079) );
  AO22X1 U1054 ( .A0(TxReg4[3]), .A1(n1266), .B0(n1149), .B1(PWDATAIn[3]), .Y(
        n1080) );
  AO22X1 U1055 ( .A0(TxReg4[2]), .A1(n1266), .B0(n1149), .B1(PWDATAIn[2]), .Y(
        n1081) );
  AO22X1 U1056 ( .A0(TxReg4[1]), .A1(n1266), .B0(n1149), .B1(PWDATAIn[1]), .Y(
        n1082) );
  AO22X1 U1057 ( .A0(TxReg4[0]), .A1(n1266), .B0(n1149), .B1(PWDATAIn[0]), .Y(
        n1083) );
  AO22X1 U1058 ( .A0(TxReg5[15]), .A1(n1267), .B0(n1147), .B1(PWDATAIn[15]), 
        .Y(n1084) );
  AO22X1 U1059 ( .A0(TxReg5[14]), .A1(n1267), .B0(n1147), .B1(PWDATAIn[14]), 
        .Y(n1085) );
  AO22X1 U1060 ( .A0(TxReg5[13]), .A1(n1267), .B0(n1147), .B1(PWDATAIn[13]), 
        .Y(n1086) );
  AO22X1 U1061 ( .A0(TxReg5[12]), .A1(n1267), .B0(n1147), .B1(PWDATAIn[12]), 
        .Y(n1087) );
  AO22X1 U1062 ( .A0(TxReg5[11]), .A1(n1267), .B0(n1147), .B1(PWDATAIn[11]), 
        .Y(n1088) );
  AO22X1 U1063 ( .A0(TxReg5[10]), .A1(n1267), .B0(n1147), .B1(PWDATAIn[10]), 
        .Y(n1089) );
  AO22X1 U1064 ( .A0(TxReg5[9]), .A1(n1267), .B0(n1147), .B1(PWDATAIn[9]), .Y(
        n1090) );
  AO22X1 U1065 ( .A0(TxReg5[8]), .A1(n1267), .B0(n1147), .B1(PWDATAIn[8]), .Y(
        n1091) );
  AO22X1 U1066 ( .A0(TxReg5[7]), .A1(n1267), .B0(n1147), .B1(PWDATAIn[7]), .Y(
        n1092) );
  AO22X1 U1067 ( .A0(TxReg5[6]), .A1(n1267), .B0(n1147), .B1(PWDATAIn[6]), .Y(
        n1093) );
  AO22X1 U1068 ( .A0(TxReg5[5]), .A1(n1267), .B0(n1147), .B1(PWDATAIn[5]), .Y(
        n1094) );
  AO22X1 U1069 ( .A0(TxReg5[4]), .A1(n1267), .B0(n1147), .B1(PWDATAIn[4]), .Y(
        n1095) );
  AO22X1 U1070 ( .A0(TxReg5[3]), .A1(n1267), .B0(n1147), .B1(PWDATAIn[3]), .Y(
        n1096) );
  AO22X1 U1071 ( .A0(TxReg5[2]), .A1(n1267), .B0(n1147), .B1(PWDATAIn[2]), .Y(
        n1097) );
  AO22X1 U1072 ( .A0(TxReg5[1]), .A1(n1267), .B0(n1147), .B1(PWDATAIn[1]), .Y(
        n1098) );
  AO22X1 U1073 ( .A0(TxReg5[0]), .A1(n1267), .B0(n1147), .B1(PWDATAIn[0]), .Y(
        n1099) );
  AO22X1 U1074 ( .A0(TxReg6[15]), .A1(n1268), .B0(n1145), .B1(PWDATAIn[15]), 
        .Y(n1100) );
  AO22X1 U1075 ( .A0(TxReg6[14]), .A1(n1268), .B0(n1145), .B1(PWDATAIn[14]), 
        .Y(n1101) );
  AO22X1 U1076 ( .A0(TxReg6[13]), .A1(n1268), .B0(n1145), .B1(PWDATAIn[13]), 
        .Y(n1102) );
  AO22X1 U1077 ( .A0(TxReg6[12]), .A1(n1268), .B0(n1145), .B1(PWDATAIn[12]), 
        .Y(n1103) );
  AO22X1 U1078 ( .A0(TxReg6[11]), .A1(n1268), .B0(n1145), .B1(PWDATAIn[11]), 
        .Y(n1104) );
  AO22X1 U1079 ( .A0(TxReg6[10]), .A1(n1268), .B0(n1145), .B1(PWDATAIn[10]), 
        .Y(n1105) );
  AO22X1 U1080 ( .A0(TxReg6[9]), .A1(n1268), .B0(n1145), .B1(PWDATAIn[9]), .Y(
        n1106) );
  AO22X1 U1081 ( .A0(TxReg6[8]), .A1(n1268), .B0(n1145), .B1(PWDATAIn[8]), .Y(
        n1107) );
  AO22X1 U1082 ( .A0(TxReg6[7]), .A1(n1268), .B0(n1145), .B1(PWDATAIn[7]), .Y(
        n1108) );
  AO22X1 U1083 ( .A0(TxReg6[6]), .A1(n1268), .B0(n1145), .B1(PWDATAIn[6]), .Y(
        n1109) );
  AO22X1 U1084 ( .A0(TxReg6[5]), .A1(n1268), .B0(n1145), .B1(PWDATAIn[5]), .Y(
        n1110) );
  AO22X1 U1085 ( .A0(TxReg6[4]), .A1(n1268), .B0(n1145), .B1(PWDATAIn[4]), .Y(
        n1111) );
  AO22X1 U1086 ( .A0(TxReg6[3]), .A1(n1268), .B0(n1145), .B1(PWDATAIn[3]), .Y(
        n1112) );
  AO22X1 U1087 ( .A0(TxReg6[2]), .A1(n1268), .B0(n1145), .B1(PWDATAIn[2]), .Y(
        n1113) );
  AO22X1 U1088 ( .A0(TxReg6[1]), .A1(n1268), .B0(n1145), .B1(PWDATAIn[1]), .Y(
        n1114) );
  AO22X1 U1089 ( .A0(TxReg6[0]), .A1(n1268), .B0(n1145), .B1(PWDATAIn[0]), .Y(
        n1115) );
  INVX1 U1090 ( .A(n1162), .Y(n1155) );
  NAND2BX1 U1091 ( .AN(WrPtr[2]), .B(RegFileWrEn), .Y(n1162) );
  AND2X2 U1092 ( .A(RegFileWrEn), .B(WrPtr[2]), .Y(n1261) );
  NAND3BX1 U1093 ( .AN(RdPtr[1]), .B(RdPtr[2]), .C(RdPtr[0]), .Y(n1234) );
  NAND3BX1 U1094 ( .AN(RdPtr[2]), .B(RdPtr[1]), .C(RdPtr[0]), .Y(n1235) );
  NAND3BX1 U1095 ( .AN(RdPtr[2]), .B(n1242), .C(RdPtr[0]), .Y(n1236) );
  INVX1 U1096 ( .A(n1243), .Y(n1170) );
  NAND3BX1 U1097 ( .AN(RdPtr[0]), .B(RdPtr[1]), .C(RdPtr[2]), .Y(n1243) );
  OAI211X1 U1098 ( .A0(n1244), .A1(n1164), .B0(n1196), .C0(n1197), .Y(
        TxFRdData[3]) );
  AOI222X1 U1099 ( .A0(n1167), .A1(TxReg1[3]), .B0(n1168), .B1(TxReg3[3]), 
        .C0(n1169), .C1(TxReg5[3]), .Y(n1197) );
  AOI221X1 U1100 ( .A0(n1170), .A1(TxReg6[3]), .B0(n1171), .B1(TxReg0[3]), 
        .C0(n1198), .Y(n1196) );
  OAI211X1 U1101 ( .A0(n1245), .A1(n1164), .B0(n1204), .C0(n1205), .Y(
        TxFRdData[1]) );
  AOI222X1 U1102 ( .A0(n1167), .A1(TxReg1[1]), .B0(n1168), .B1(TxReg3[1]), 
        .C0(n1169), .C1(TxReg5[1]), .Y(n1205) );
  AOI221X1 U1103 ( .A0(n1170), .A1(TxReg6[1]), .B0(n1171), .B1(TxReg0[1]), 
        .C0(n1206), .Y(n1204) );
  OAI211X1 U1104 ( .A0(n1246), .A1(n1164), .B0(n1200), .C0(n1201), .Y(
        TxFRdData[2]) );
  AOI222X1 U1105 ( .A0(n1167), .A1(TxReg1[2]), .B0(n1168), .B1(TxReg3[2]), 
        .C0(n1169), .C1(TxReg5[2]), .Y(n1201) );
  AOI221X1 U1106 ( .A0(n1170), .A1(TxReg6[2]), .B0(n1171), .B1(TxReg0[2]), 
        .C0(n1202), .Y(n1200) );
  OAI211X1 U1107 ( .A0(n1247), .A1(n1164), .B0(n1192), .C0(n1193), .Y(
        TxFRdData[4]) );
  AOI222X1 U1108 ( .A0(n1167), .A1(TxReg1[4]), .B0(n1168), .B1(TxReg3[4]), 
        .C0(n1169), .C1(TxReg5[4]), .Y(n1193) );
  AOI221X1 U1109 ( .A0(n1170), .A1(TxReg6[4]), .B0(n1171), .B1(TxReg0[4]), 
        .C0(n1194), .Y(n1192) );
  OAI211X1 U1110 ( .A0(n1248), .A1(n1164), .B0(n1232), .C0(n1233), .Y(
        TxFRdData[0]) );
  AOI222X1 U1111 ( .A0(n1167), .A1(TxReg1[0]), .B0(n1168), .B1(TxReg3[0]), 
        .C0(n1169), .C1(TxReg5[0]), .Y(n1233) );
  AOI221X1 U1112 ( .A0(n1170), .A1(TxReg6[0]), .B0(n1171), .B1(TxReg0[0]), 
        .C0(n1237), .Y(n1232) );
  OAI211X1 U1113 ( .A0(n1249), .A1(n1164), .B0(n1180), .C0(n1181), .Y(
        TxFRdData[7]) );
  AOI222X1 U1114 ( .A0(n1167), .A1(TxReg1[7]), .B0(n1168), .B1(TxReg3[7]), 
        .C0(n1169), .C1(TxReg5[7]), .Y(n1181) );
  AOI221X1 U1115 ( .A0(n1170), .A1(TxReg6[7]), .B0(n1171), .B1(TxReg0[7]), 
        .C0(n1182), .Y(n1180) );
  OAI211X1 U1116 ( .A0(n1250), .A1(n1164), .B0(n1184), .C0(n1185), .Y(
        TxFRdData[6]) );
  AOI222X1 U1117 ( .A0(n1167), .A1(TxReg1[6]), .B0(n1168), .B1(TxReg3[6]), 
        .C0(n1169), .C1(TxReg5[6]), .Y(n1185) );
  AOI221X1 U1118 ( .A0(n1170), .A1(TxReg6[6]), .B0(n1171), .B1(TxReg0[6]), 
        .C0(n1186), .Y(n1184) );
  OAI211X1 U1119 ( .A0(n1251), .A1(n1164), .B0(n1188), .C0(n1189), .Y(
        TxFRdData[5]) );
  AOI222X1 U1120 ( .A0(n1167), .A1(TxReg1[5]), .B0(n1168), .B1(TxReg3[5]), 
        .C0(n1169), .C1(TxReg5[5]), .Y(n1189) );
  AOI221X1 U1121 ( .A0(n1170), .A1(TxReg6[5]), .B0(n1171), .B1(TxReg0[5]), 
        .C0(n1190), .Y(n1188) );
  OAI211X1 U1122 ( .A0(n1252), .A1(n1164), .B0(n1176), .C0(n1177), .Y(
        TxFRdData[8]) );
  AOI222X1 U1123 ( .A0(n1167), .A1(TxReg1[8]), .B0(n1168), .B1(TxReg3[8]), 
        .C0(n1169), .C1(TxReg5[8]), .Y(n1177) );
  AOI221X1 U1124 ( .A0(n1170), .A1(TxReg6[8]), .B0(n1171), .B1(TxReg0[8]), 
        .C0(n1178), .Y(n1176) );
  INVX1 U1125 ( .A(n1238), .Y(n1174) );
  NAND3BX1 U1126 ( .AN(RdPtr[2]), .B(n1239), .C(RdPtr[1]), .Y(n1238) );
  INVX1 U1127 ( .A(n1240), .Y(n1173) );
  NAND3BX1 U1128 ( .AN(RdPtr[1]), .B(n1239), .C(RdPtr[2]), .Y(n1240) );
  INVX1 U1129 ( .A(RdPtr[0]), .Y(n1239) );
  INVX1 U1130 ( .A(RdPtr[1]), .Y(n1242) );
  INVX1 U1131 ( .A(n1241), .Y(n1171) );
  NAND3BX1 U1132 ( .AN(RdPtr[2]), .B(n1242), .C(n1239), .Y(n1241) );
  AO22X1 U1133 ( .A0(n1173), .A1(TxReg4[6]), .B0(n1174), .B1(TxReg2[6]), .Y(
        n1186) );
  AO22X1 U1134 ( .A0(n1173), .A1(TxReg4[4]), .B0(n1174), .B1(TxReg2[4]), .Y(
        n1194) );
  AO22X1 U1135 ( .A0(n1173), .A1(TxReg4[5]), .B0(n1174), .B1(TxReg2[5]), .Y(
        n1190) );
  AO22X1 U1136 ( .A0(n1173), .A1(TxReg4[8]), .B0(n1174), .B1(TxReg2[8]), .Y(
        n1178) );
  AO22X1 U1137 ( .A0(n1173), .A1(TxReg4[7]), .B0(n1174), .B1(TxReg2[7]), .Y(
        n1182) );
  AO22X1 U1138 ( .A0(n1173), .A1(TxReg4[3]), .B0(n1174), .B1(TxReg2[3]), .Y(
        n1198) );
  AO22X1 U1139 ( .A0(n1173), .A1(TxReg4[2]), .B0(n1174), .B1(TxReg2[2]), .Y(
        n1202) );
  AO22X1 U1140 ( .A0(n1173), .A1(TxReg4[1]), .B0(n1174), .B1(TxReg2[1]), .Y(
        n1206) );
  AO22X1 U1141 ( .A0(n1173), .A1(TxReg4[0]), .B0(n1174), .B1(TxReg2[0]), .Y(
        n1237) );
  AO22X1 U1142 ( .A0(n1173), .A1(TxReg4[15]), .B0(n1174), .B1(TxReg2[15]), .Y(
        n1210) );
  AOI221X1 U1143 ( .A0(n1170), .A1(TxReg6[10]), .B0(n1171), .B1(TxReg0[10]), 
        .C0(n1230), .Y(n1228) );
  AO22X1 U1144 ( .A0(n1173), .A1(TxReg4[10]), .B0(n1174), .B1(TxReg2[10]), .Y(
        n1230) );
  AOI221X1 U1145 ( .A0(n1170), .A1(TxReg6[12]), .B0(n1171), .B1(TxReg0[12]), 
        .C0(n1222), .Y(n1220) );
  AO22X1 U1146 ( .A0(n1173), .A1(TxReg4[12]), .B0(n1174), .B1(TxReg2[12]), .Y(
        n1222) );
  AOI221X1 U1147 ( .A0(n1170), .A1(TxReg6[9]), .B0(n1171), .B1(TxReg0[9]), 
        .C0(n1172), .Y(n1165) );
  AO22X1 U1148 ( .A0(n1173), .A1(TxReg4[9]), .B0(n1174), .B1(TxReg2[9]), .Y(
        n1172) );
  AOI221X1 U1149 ( .A0(n1170), .A1(TxReg6[11]), .B0(n1171), .B1(TxReg0[11]), 
        .C0(n1226), .Y(n1224) );
  AO22X1 U1150 ( .A0(n1173), .A1(TxReg4[11]), .B0(n1174), .B1(TxReg2[11]), .Y(
        n1226) );
  AOI221X1 U1151 ( .A0(n1170), .A1(TxReg6[13]), .B0(n1171), .B1(TxReg0[13]), 
        .C0(n1218), .Y(n1216) );
  AO22X1 U1152 ( .A0(n1173), .A1(TxReg4[13]), .B0(n1174), .B1(TxReg2[13]), .Y(
        n1218) );
  AOI221X1 U1153 ( .A0(n1170), .A1(TxReg6[14]), .B0(n1171), .B1(TxReg0[14]), 
        .C0(n1214), .Y(n1212) );
  AO22X1 U1154 ( .A0(n1173), .A1(TxReg4[14]), .B0(n1174), .B1(TxReg2[14]), .Y(
        n1214) );
  OAI211X1 U1155 ( .A0(n1259), .A1(n1164), .B0(n1208), .C0(n1209), .Y(
        TxFRdData[15]) );
  AOI222X1 U1156 ( .A0(n1167), .A1(TxReg1[15]), .B0(n1168), .B1(TxReg3[15]), 
        .C0(n1169), .C1(TxReg5[15]), .Y(n1209) );
  AOI221X1 U1157 ( .A0(n1170), .A1(TxReg6[15]), .B0(n1171), .B1(TxReg0[15]), 
        .C0(n1210), .Y(n1208) );
  OAI211X1 U1158 ( .A0(n1253), .A1(n1164), .B0(n1165), .C0(n1166), .Y(
        TxFRdData[9]) );
  AOI222X1 U1159 ( .A0(n1167), .A1(TxReg1[9]), .B0(n1168), .B1(TxReg3[9]), 
        .C0(n1169), .C1(TxReg5[9]), .Y(n1166) );
  OAI211X1 U1160 ( .A0(n1254), .A1(n1164), .B0(n1228), .C0(n1229), .Y(
        TxFRdData[10]) );
  AOI222X1 U1161 ( .A0(n1167), .A1(TxReg1[10]), .B0(n1168), .B1(TxReg3[10]), 
        .C0(n1169), .C1(TxReg5[10]), .Y(n1229) );
  OAI211X1 U1162 ( .A0(n1255), .A1(n1164), .B0(n1224), .C0(n1225), .Y(
        TxFRdData[11]) );
  AOI222X1 U1163 ( .A0(n1167), .A1(TxReg1[11]), .B0(n1168), .B1(TxReg3[11]), 
        .C0(n1169), .C1(TxReg5[11]), .Y(n1225) );
  OAI211X1 U1164 ( .A0(n1256), .A1(n1164), .B0(n1220), .C0(n1221), .Y(
        TxFRdData[12]) );
  AOI222X1 U1165 ( .A0(n1167), .A1(TxReg1[12]), .B0(n1168), .B1(TxReg3[12]), 
        .C0(n1169), .C1(TxReg5[12]), .Y(n1221) );
  OAI211X1 U1166 ( .A0(n1257), .A1(n1164), .B0(n1216), .C0(n1217), .Y(
        TxFRdData[13]) );
  AOI222X1 U1167 ( .A0(n1167), .A1(TxReg1[13]), .B0(n1168), .B1(TxReg3[13]), 
        .C0(n1169), .C1(TxReg5[13]), .Y(n1217) );
  OAI211X1 U1168 ( .A0(n1258), .A1(n1164), .B0(n1212), .C0(n1213), .Y(
        TxFRdData[14]) );
  AOI222X1 U1169 ( .A0(n1167), .A1(TxReg1[14]), .B0(n1168), .B1(TxReg3[14]), 
        .C0(n1169), .C1(TxReg5[14]), .Y(n1213) );
  INVX1 U1170 ( .A(WrPtr[0]), .Y(n1150) );
  DFFRX1 TxReg7_reg_15_ ( .D(n1116), .CK(PCLK), .RN(PRESETn), .Q(TxReg7[15]), 
        .QN(n1259) );
  DFFRX1 TxReg7_reg_13_ ( .D(n1118), .CK(PCLK), .RN(PRESETn), .Q(TxReg7[13]), 
        .QN(n1257) );
  DFFRX1 TxReg7_reg_12_ ( .D(n1119), .CK(PCLK), .RN(PRESETn), .Q(TxReg7[12]), 
        .QN(n1256) );
  DFFRX1 TxReg7_reg_11_ ( .D(n1120), .CK(PCLK), .RN(PRESETn), .Q(TxReg7[11]), 
        .QN(n1255) );
  DFFRX1 TxReg7_reg_10_ ( .D(n1121), .CK(PCLK), .RN(PRESETn), .Q(TxReg7[10]), 
        .QN(n1254) );
  DFFRX1 TxReg7_reg_9_ ( .D(n1122), .CK(PCLK), .RN(PRESETn), .Q(TxReg7[9]), 
        .QN(n1253) );
  DFFRX1 TxReg7_reg_8_ ( .D(n1123), .CK(PCLK), .RN(PRESETn), .Q(TxReg7[8]), 
        .QN(n1252) );
  DFFRX1 TxReg7_reg_7_ ( .D(n1124), .CK(PCLK), .RN(PRESETn), .Q(TxReg7[7]), 
        .QN(n1249) );
  DFFRX1 TxReg7_reg_6_ ( .D(n1125), .CK(PCLK), .RN(PRESETn), .Q(TxReg7[6]), 
        .QN(n1250) );
  DFFRX1 TxReg7_reg_5_ ( .D(n1126), .CK(PCLK), .RN(PRESETn), .Q(TxReg7[5]), 
        .QN(n1251) );
  DFFRX1 TxReg7_reg_4_ ( .D(n1127), .CK(PCLK), .RN(PRESETn), .Q(TxReg7[4]), 
        .QN(n1247) );
  DFFRX1 TxReg7_reg_3_ ( .D(n1128), .CK(PCLK), .RN(PRESETn), .Q(TxReg7[3]), 
        .QN(n1244) );
  DFFRX1 TxReg7_reg_2_ ( .D(n1129), .CK(PCLK), .RN(PRESETn), .Q(TxReg7[2]), 
        .QN(n1246) );
  DFFRX1 TxReg7_reg_1_ ( .D(n1130), .CK(PCLK), .RN(PRESETn), .Q(TxReg7[1]), 
        .QN(n1245) );
  DFFRX1 TxReg7_reg_0_ ( .D(n1131), .CK(PCLK), .RN(PRESETn), .Q(TxReg7[0]), 
        .QN(n1248) );
  DFFRX1 TxReg4_reg_15_ ( .D(n1068), .CK(PCLK), .RN(PRESETn), .Q(TxReg4[15])
         );
  DFFRX1 TxReg4_reg_14_ ( .D(n1069), .CK(PCLK), .RN(PRESETn), .Q(TxReg4[14])
         );
  DFFRX1 TxReg4_reg_13_ ( .D(n1070), .CK(PCLK), .RN(PRESETn), .Q(TxReg4[13])
         );
  DFFRX1 TxReg4_reg_12_ ( .D(n1071), .CK(PCLK), .RN(PRESETn), .Q(TxReg4[12])
         );
  DFFRX1 TxReg4_reg_11_ ( .D(n1072), .CK(PCLK), .RN(PRESETn), .Q(TxReg4[11])
         );
  DFFRX1 TxReg4_reg_10_ ( .D(n1073), .CK(PCLK), .RN(PRESETn), .Q(TxReg4[10])
         );
  DFFRX1 TxReg4_reg_9_ ( .D(n1074), .CK(PCLK), .RN(PRESETn), .Q(TxReg4[9]) );
  DFFRX1 TxReg4_reg_8_ ( .D(n1075), .CK(PCLK), .RN(PRESETn), .Q(TxReg4[8]) );
  DFFRX1 TxReg4_reg_7_ ( .D(n1076), .CK(PCLK), .RN(PRESETn), .Q(TxReg4[7]) );
  DFFRX1 TxReg4_reg_6_ ( .D(n1077), .CK(PCLK), .RN(PRESETn), .Q(TxReg4[6]) );
  DFFRX1 TxReg4_reg_5_ ( .D(n1078), .CK(PCLK), .RN(PRESETn), .Q(TxReg4[5]) );
  DFFRX1 TxReg4_reg_4_ ( .D(n1079), .CK(PCLK), .RN(PRESETn), .Q(TxReg4[4]) );
  DFFRX1 TxReg4_reg_3_ ( .D(n1080), .CK(PCLK), .RN(PRESETn), .Q(TxReg4[3]) );
  DFFRX1 TxReg4_reg_2_ ( .D(n1081), .CK(PCLK), .RN(PRESETn), .Q(TxReg4[2]) );
  DFFRX1 TxReg4_reg_1_ ( .D(n1082), .CK(PCLK), .RN(PRESETn), .Q(TxReg4[1]) );
  DFFRX1 TxReg4_reg_0_ ( .D(n1083), .CK(PCLK), .RN(PRESETn), .Q(TxReg4[0]) );
  DFFRX1 TxReg2_reg_15_ ( .D(n1036), .CK(PCLK), .RN(PRESETn), .Q(TxReg2[15])
         );
  DFFRX1 TxReg2_reg_14_ ( .D(n1037), .CK(PCLK), .RN(PRESETn), .Q(TxReg2[14])
         );
  DFFRX1 TxReg2_reg_13_ ( .D(n1038), .CK(PCLK), .RN(PRESETn), .Q(TxReg2[13])
         );
  DFFRX1 TxReg2_reg_12_ ( .D(n1039), .CK(PCLK), .RN(PRESETn), .Q(TxReg2[12])
         );
  DFFRX1 TxReg2_reg_11_ ( .D(n1040), .CK(PCLK), .RN(PRESETn), .Q(TxReg2[11])
         );
  DFFRX1 TxReg2_reg_10_ ( .D(n1041), .CK(PCLK), .RN(PRESETn), .Q(TxReg2[10])
         );
  DFFRX1 TxReg2_reg_9_ ( .D(n1042), .CK(PCLK), .RN(PRESETn), .Q(TxReg2[9]) );
  DFFRX1 TxReg2_reg_8_ ( .D(n1043), .CK(PCLK), .RN(PRESETn), .Q(TxReg2[8]) );
  DFFRX1 TxReg2_reg_7_ ( .D(n1044), .CK(PCLK), .RN(PRESETn), .Q(TxReg2[7]) );
  DFFRX1 TxReg2_reg_6_ ( .D(n1045), .CK(PCLK), .RN(PRESETn), .Q(TxReg2[6]) );
  DFFRX1 TxReg2_reg_5_ ( .D(n1046), .CK(PCLK), .RN(PRESETn), .Q(TxReg2[5]) );
  DFFRX1 TxReg2_reg_4_ ( .D(n1047), .CK(PCLK), .RN(PRESETn), .Q(TxReg2[4]) );
  DFFRX1 TxReg2_reg_3_ ( .D(n1048), .CK(PCLK), .RN(PRESETn), .Q(TxReg2[3]) );
  DFFRX1 TxReg2_reg_2_ ( .D(n1049), .CK(PCLK), .RN(PRESETn), .Q(TxReg2[2]) );
  DFFRX1 TxReg2_reg_1_ ( .D(n1050), .CK(PCLK), .RN(PRESETn), .Q(TxReg2[1]) );
  DFFRX1 TxReg2_reg_0_ ( .D(n1051), .CK(PCLK), .RN(PRESETn), .Q(TxReg2[0]) );
  DFFRX1 TxReg1_reg_15_ ( .D(n1020), .CK(PCLK), .RN(PRESETn), .Q(TxReg1[15])
         );
  DFFRX1 TxReg1_reg_14_ ( .D(n1021), .CK(PCLK), .RN(PRESETn), .Q(TxReg1[14])
         );
  DFFRX1 TxReg1_reg_13_ ( .D(n1022), .CK(PCLK), .RN(PRESETn), .Q(TxReg1[13])
         );
  DFFRX1 TxReg1_reg_12_ ( .D(n1023), .CK(PCLK), .RN(PRESETn), .Q(TxReg1[12])
         );
  DFFRX1 TxReg1_reg_11_ ( .D(n1024), .CK(PCLK), .RN(PRESETn), .Q(TxReg1[11])
         );
  DFFRX1 TxReg1_reg_10_ ( .D(n1025), .CK(PCLK), .RN(PRESETn), .Q(TxReg1[10])
         );
  DFFRX1 TxReg1_reg_9_ ( .D(n1026), .CK(PCLK), .RN(PRESETn), .Q(TxReg1[9]) );
  DFFRX1 TxReg1_reg_8_ ( .D(n1027), .CK(PCLK), .RN(PRESETn), .Q(TxReg1[8]) );
  DFFRX1 TxReg1_reg_7_ ( .D(n1028), .CK(PCLK), .RN(PRESETn), .Q(TxReg1[7]) );
  DFFRX1 TxReg1_reg_6_ ( .D(n1029), .CK(PCLK), .RN(PRESETn), .Q(TxReg1[6]) );
  DFFRX1 TxReg1_reg_5_ ( .D(n1030), .CK(PCLK), .RN(PRESETn), .Q(TxReg1[5]) );
  DFFRX1 TxReg1_reg_4_ ( .D(n1031), .CK(PCLK), .RN(PRESETn), .Q(TxReg1[4]) );
  DFFRX1 TxReg1_reg_3_ ( .D(n1032), .CK(PCLK), .RN(PRESETn), .Q(TxReg1[3]) );
  DFFRX1 TxReg1_reg_2_ ( .D(n1033), .CK(PCLK), .RN(PRESETn), .Q(TxReg1[2]) );
  DFFRX1 TxReg1_reg_1_ ( .D(n1034), .CK(PCLK), .RN(PRESETn), .Q(TxReg1[1]) );
  DFFRX1 TxReg1_reg_0_ ( .D(n1035), .CK(PCLK), .RN(PRESETn), .Q(TxReg1[0]) );
  DFFRX1 TxReg6_reg_15_ ( .D(n1100), .CK(PCLK), .RN(PRESETn), .Q(TxReg6[15])
         );
  DFFRX1 TxReg6_reg_14_ ( .D(n1101), .CK(PCLK), .RN(PRESETn), .Q(TxReg6[14])
         );
  DFFRX1 TxReg6_reg_13_ ( .D(n1102), .CK(PCLK), .RN(PRESETn), .Q(TxReg6[13])
         );
  DFFRX1 TxReg6_reg_12_ ( .D(n1103), .CK(PCLK), .RN(PRESETn), .Q(TxReg6[12])
         );
  DFFRX1 TxReg6_reg_11_ ( .D(n1104), .CK(PCLK), .RN(PRESETn), .Q(TxReg6[11])
         );
  DFFRX1 TxReg6_reg_10_ ( .D(n1105), .CK(PCLK), .RN(PRESETn), .Q(TxReg6[10])
         );
  DFFRX1 TxReg6_reg_9_ ( .D(n1106), .CK(PCLK), .RN(PRESETn), .Q(TxReg6[9]) );
  DFFRX1 TxReg6_reg_8_ ( .D(n1107), .CK(PCLK), .RN(PRESETn), .Q(TxReg6[8]) );
  DFFRX1 TxReg6_reg_7_ ( .D(n1108), .CK(PCLK), .RN(PRESETn), .Q(TxReg6[7]) );
  DFFRX1 TxReg6_reg_6_ ( .D(n1109), .CK(PCLK), .RN(PRESETn), .Q(TxReg6[6]) );
  DFFRX1 TxReg6_reg_5_ ( .D(n1110), .CK(PCLK), .RN(PRESETn), .Q(TxReg6[5]) );
  DFFRX1 TxReg6_reg_4_ ( .D(n1111), .CK(PCLK), .RN(PRESETn), .Q(TxReg6[4]) );
  DFFRX1 TxReg6_reg_3_ ( .D(n1112), .CK(PCLK), .RN(PRESETn), .Q(TxReg6[3]) );
  DFFRX1 TxReg6_reg_2_ ( .D(n1113), .CK(PCLK), .RN(PRESETn), .Q(TxReg6[2]) );
  DFFRX1 TxReg6_reg_1_ ( .D(n1114), .CK(PCLK), .RN(PRESETn), .Q(TxReg6[1]) );
  DFFRX1 TxReg6_reg_0_ ( .D(n1115), .CK(PCLK), .RN(PRESETn), .Q(TxReg6[0]) );
  DFFRX1 TxReg3_reg_15_ ( .D(n1052), .CK(PCLK), .RN(PRESETn), .Q(TxReg3[15])
         );
  DFFRX1 TxReg3_reg_14_ ( .D(n1053), .CK(PCLK), .RN(PRESETn), .Q(TxReg3[14])
         );
  DFFRX1 TxReg3_reg_13_ ( .D(n1054), .CK(PCLK), .RN(PRESETn), .Q(TxReg3[13])
         );
  DFFRX1 TxReg3_reg_12_ ( .D(n1055), .CK(PCLK), .RN(PRESETn), .Q(TxReg3[12])
         );
  DFFRX1 TxReg3_reg_11_ ( .D(n1056), .CK(PCLK), .RN(PRESETn), .Q(TxReg3[11])
         );
  DFFRX1 TxReg3_reg_10_ ( .D(n1057), .CK(PCLK), .RN(PRESETn), .Q(TxReg3[10])
         );
  DFFRX1 TxReg3_reg_9_ ( .D(n1058), .CK(PCLK), .RN(PRESETn), .Q(TxReg3[9]) );
  DFFRX1 TxReg3_reg_8_ ( .D(n1059), .CK(PCLK), .RN(PRESETn), .Q(TxReg3[8]) );
  DFFRX1 TxReg3_reg_7_ ( .D(n1060), .CK(PCLK), .RN(PRESETn), .Q(TxReg3[7]) );
  DFFRX1 TxReg3_reg_6_ ( .D(n1061), .CK(PCLK), .RN(PRESETn), .Q(TxReg3[6]) );
  DFFRX1 TxReg3_reg_5_ ( .D(n1062), .CK(PCLK), .RN(PRESETn), .Q(TxReg3[5]) );
  DFFRX1 TxReg3_reg_4_ ( .D(n1063), .CK(PCLK), .RN(PRESETn), .Q(TxReg3[4]) );
  DFFRX1 TxReg3_reg_3_ ( .D(n1064), .CK(PCLK), .RN(PRESETn), .Q(TxReg3[3]) );
  DFFRX1 TxReg3_reg_2_ ( .D(n1065), .CK(PCLK), .RN(PRESETn), .Q(TxReg3[2]) );
  DFFRX1 TxReg3_reg_1_ ( .D(n1066), .CK(PCLK), .RN(PRESETn), .Q(TxReg3[1]) );
  DFFRX1 TxReg3_reg_0_ ( .D(n1067), .CK(PCLK), .RN(PRESETn), .Q(TxReg3[0]) );
  DFFRX1 TxReg5_reg_15_ ( .D(n1084), .CK(PCLK), .RN(PRESETn), .Q(TxReg5[15])
         );
  DFFRX1 TxReg5_reg_14_ ( .D(n1085), .CK(PCLK), .RN(PRESETn), .Q(TxReg5[14])
         );
  DFFRX1 TxReg5_reg_13_ ( .D(n1086), .CK(PCLK), .RN(PRESETn), .Q(TxReg5[13])
         );
  DFFRX1 TxReg5_reg_12_ ( .D(n1087), .CK(PCLK), .RN(PRESETn), .Q(TxReg5[12])
         );
  DFFRX1 TxReg5_reg_11_ ( .D(n1088), .CK(PCLK), .RN(PRESETn), .Q(TxReg5[11])
         );
  DFFRX1 TxReg5_reg_10_ ( .D(n1089), .CK(PCLK), .RN(PRESETn), .Q(TxReg5[10])
         );
  DFFRX1 TxReg5_reg_9_ ( .D(n1090), .CK(PCLK), .RN(PRESETn), .Q(TxReg5[9]) );
  DFFRX1 TxReg5_reg_8_ ( .D(n1091), .CK(PCLK), .RN(PRESETn), .Q(TxReg5[8]) );
  DFFRX1 TxReg5_reg_7_ ( .D(n1092), .CK(PCLK), .RN(PRESETn), .Q(TxReg5[7]) );
  DFFRX1 TxReg5_reg_6_ ( .D(n1093), .CK(PCLK), .RN(PRESETn), .Q(TxReg5[6]) );
  DFFRX1 TxReg5_reg_5_ ( .D(n1094), .CK(PCLK), .RN(PRESETn), .Q(TxReg5[5]) );
  DFFRX1 TxReg5_reg_4_ ( .D(n1095), .CK(PCLK), .RN(PRESETn), .Q(TxReg5[4]) );
  DFFRX1 TxReg5_reg_3_ ( .D(n1096), .CK(PCLK), .RN(PRESETn), .Q(TxReg5[3]) );
  DFFRX1 TxReg5_reg_2_ ( .D(n1097), .CK(PCLK), .RN(PRESETn), .Q(TxReg5[2]) );
  DFFRX1 TxReg5_reg_1_ ( .D(n1098), .CK(PCLK), .RN(PRESETn), .Q(TxReg5[1]) );
  DFFRX1 TxReg5_reg_0_ ( .D(n1099), .CK(PCLK), .RN(PRESETn), .Q(TxReg5[0]) );
  DFFRX1 TxReg0_reg_15_ ( .D(n1004), .CK(PCLK), .RN(PRESETn), .Q(TxReg0[15])
         );
  DFFRX1 TxReg0_reg_14_ ( .D(n1005), .CK(PCLK), .RN(PRESETn), .Q(TxReg0[14])
         );
  DFFRX1 TxReg0_reg_13_ ( .D(n1006), .CK(PCLK), .RN(PRESETn), .Q(TxReg0[13])
         );
  DFFRX1 TxReg0_reg_12_ ( .D(n1007), .CK(PCLK), .RN(PRESETn), .Q(TxReg0[12])
         );
  DFFRX1 TxReg0_reg_11_ ( .D(n1008), .CK(PCLK), .RN(PRESETn), .Q(TxReg0[11])
         );
  DFFRX1 TxReg0_reg_10_ ( .D(n1009), .CK(PCLK), .RN(PRESETn), .Q(TxReg0[10])
         );
  DFFRX1 TxReg0_reg_9_ ( .D(n1010), .CK(PCLK), .RN(PRESETn), .Q(TxReg0[9]) );
  DFFRX1 TxReg0_reg_8_ ( .D(n1011), .CK(PCLK), .RN(PRESETn), .Q(TxReg0[8]) );
  DFFRX1 TxReg0_reg_7_ ( .D(n1012), .CK(PCLK), .RN(PRESETn), .Q(TxReg0[7]) );
  DFFRX1 TxReg0_reg_6_ ( .D(n1013), .CK(PCLK), .RN(PRESETn), .Q(TxReg0[6]) );
  DFFRX1 TxReg0_reg_5_ ( .D(n1014), .CK(PCLK), .RN(PRESETn), .Q(TxReg0[5]) );
  DFFRX1 TxReg0_reg_4_ ( .D(n1015), .CK(PCLK), .RN(PRESETn), .Q(TxReg0[4]) );
  DFFRX1 TxReg0_reg_3_ ( .D(n1016), .CK(PCLK), .RN(PRESETn), .Q(TxReg0[3]) );
  DFFRX1 TxReg0_reg_2_ ( .D(n1017), .CK(PCLK), .RN(PRESETn), .Q(TxReg0[2]) );
  DFFRX1 TxReg0_reg_1_ ( .D(n1018), .CK(PCLK), .RN(PRESETn), .Q(TxReg0[1]) );
  DFFRX1 TxReg0_reg_0_ ( .D(n1019), .CK(PCLK), .RN(PRESETn), .Q(TxReg0[0]) );
  DFFRX1 TxReg7_reg_14_ ( .D(n1117), .CK(PCLK), .RN(PRESETn), .Q(TxReg7[14]), 
        .QN(n1258) );
endmodule


module SspTxFCntl ( PCLK, PRESETn, TXIM, SSPDRWr, TxFRdPtrIncSync, TxRxBSYSync, 
        TxDMALevel, TNF, TFE, BSY, TXRIS, TXMIS, FIFOLTE7Full, RegFileWrEn, 
        TxDataAvlbl, WrPtr, RdPtr, TxFFillLevel );
  input [3:0] TxDMALevel;
  output [2:0] WrPtr;
  output [2:0] RdPtr;
  output [3:0] TxFFillLevel;
  input PCLK, PRESETn, TXIM, SSPDRWr, TxFRdPtrIncSync, TxRxBSYSync;
  output TNF, TFE, BSY, TXRIS, TXMIS, FIFOLTE7Full, RegFileWrEn, TxDataAvlbl;
  wire   NextTXRIS, Wrap, n354, n376, n377, n378, n379, n380, n381, n382, n383,
         n384, n429, n430, n431, n432, n433, n434, n435, n436, n437, n438,
         n439, n440, n441, n442, n443, n444, n446, n448, n450, n451, n454,
         n456, n458, n460, n461, n462, n463, n464, n465, n466, n468, n469,
         n470, n471, n472, n473, n475, n476, n477, n478;

  XOR2X1 U239 ( .A(n469), .B(Wrap), .Y(TxFFillLevel[3]) );
  DFFRX1 RdPtr_reg_1_ ( .D(n380), .CK(PCLK), .RN(PRESETn), .Q(RdPtr[1]), .QN(
        n472) );
  DFFRX1 RdPtr_reg_0_ ( .D(n381), .CK(PCLK), .RN(PRESETn), .Q(RdPtr[0]), .QN(
        n475) );
  INVX1 U240 ( .A(n441), .Y(n435) );
  INVX1 U241 ( .A(n450), .Y(n448) );
  NAND3BX1 U242 ( .AN(n432), .B(n440), .C(FIFOLTE7Full), .Y(n437) );
  AND4X1 U243 ( .A(RegFileWrEn), .B(TxFFillLevel[1]), .C(n441), .D(
        TxFFillLevel[0]), .Y(n440) );
  INVX1 U244 ( .A(n442), .Y(RegFileWrEn) );
  INVX1 U245 ( .A(n456), .Y(n446) );
  DFFRX1 WrPtr_reg_1_ ( .D(n377), .CK(PCLK), .RN(PRESETn), .Q(WrPtr[1]), .QN(
        n477) );
  DFFRX1 WrPtr_reg_0_ ( .D(n378), .CK(PCLK), .RN(PRESETn), .Q(WrPtr[0]) );
  DFFRX1 RdPtr_reg_2_ ( .D(n379), .CK(PCLK), .RN(PRESETn), .Q(RdPtr[2]), .QN(
        n473) );
  INVX1 U246 ( .A(TxFFillLevel[3]), .Y(FIFOLTE7Full) );
  INVX1 U247 ( .A(TxFFillLevel[2]), .Y(n432) );
  OR2X1 U248 ( .A(TFE), .B(n454), .Y(n441) );
  NAND2BX1 U249 ( .AN(n475), .B(n435), .Y(n450) );
  INVX1 U250 ( .A(n433), .Y(TxFFillLevel[1]) );
  INVX1 U251 ( .A(TxFFillLevel[0]), .Y(n434) );
  INVX1 U252 ( .A(n465), .Y(n464) );
  XOR2X1 U253 ( .A(n475), .B(n441), .Y(n381) );
  XOR2X1 U254 ( .A(n472), .B(n450), .Y(n380) );
  OAI2BB1X1 U255 ( .A0N(n454), .A1N(n476), .B0(SSPDRWr), .Y(n442) );
  NAND2BX1 U256 ( .AN(n442), .B(WrPtr[0]), .Y(n456) );
  AO22X1 U257 ( .A0(n436), .A1(n437), .B0(TNF), .B1(n438), .Y(n383) );
  INVX1 U258 ( .A(n436), .Y(n438) );
  OAI31X1 U259 ( .A0(FIFOLTE7Full), .A1(n439), .A2(TxFFillLevel[2]), .B0(n437), 
        .Y(n436) );
  NAND4BX1 U260 ( .AN(n441), .B(n433), .C(n442), .D(n434), .Y(n439) );
  OAI31X1 U261 ( .A0(n456), .A1(WrPtr[2]), .A2(n477), .B0(n458), .Y(n376) );
  OA22X1 U262 ( .A0(WrPtr[1]), .A1(n478), .B0(n446), .B1(n478), .Y(n458) );
  XNOR2X1 U263 ( .A(WrPtr[0]), .B(n442), .Y(n378) );
  XOR2X1 U264 ( .A(WrPtr[1]), .B(n446), .Y(n377) );
  XOR3X1 U265 ( .A(Wrap), .B(n443), .C(n444), .Y(n382) );
  NAND3BX1 U266 ( .AN(n472), .B(RdPtr[2]), .C(n448), .Y(n443) );
  NAND3BX1 U267 ( .AN(n478), .B(WrPtr[1]), .C(n446), .Y(n444) );
  NAND2BX1 U268 ( .AN(TxRxBSYSync), .B(TFE), .Y(BSY) );
  AO22X1 U269 ( .A0(n429), .A1(RegFileWrEn), .B0(n430), .B1(TxDataAvlbl), .Y(
        n384) );
  INVX1 U270 ( .A(n430), .Y(n429) );
  NAND4BX1 U271 ( .AN(TxFFillLevel[3]), .B(n431), .C(n432), .D(n433), .Y(n430)
         );
  AO22X1 U272 ( .A0(RegFileWrEn), .A1(n434), .B0(n435), .B1(TxFFillLevel[0]), 
        .Y(n431) );
  OAI222X1 U273 ( .A0(WrPtr[2]), .A1(n463), .B0(n463), .B1(n473), .C0(WrPtr[2]), .C1(n473), .Y(n469) );
  XOR3X1 U274 ( .A(WrPtr[2]), .B(n463), .C(n473), .Y(TxFFillLevel[2]) );
  NAND2BX1 U275 ( .AN(WrPtr[0]), .B(RdPtr[0]), .Y(n468) );
  OAI222X1 U276 ( .A0(n460), .A1(n461), .B0(TxFFillLevel[3]), .B1(n460), .C0(
        TxFFillLevel[3]), .C1(n461), .Y(NextTXRIS) );
  INVX1 U277 ( .A(TxDMALevel[3]), .Y(n461) );
  OAI222X1 U278 ( .A0(TxDMALevel[2]), .A1(n462), .B0(n432), .B1(n462), .C0(
        TxDMALevel[2]), .C1(n432), .Y(n460) );
  OAI2BB2X1 U279 ( .A0N(TxDMALevel[1]), .A1N(n465), .B0(n464), .B1(
        TxFFillLevel[1]), .Y(n462) );
  INVX1 U280 ( .A(n470), .Y(n463) );
  OAI222X1 U281 ( .A0(WrPtr[1]), .A1(n468), .B0(n468), .B1(n472), .C0(WrPtr[1]), .C1(n472), .Y(n470) );
  XOR2X1 U282 ( .A(n471), .B(TxFRdPtrIncSync), .Y(n454) );
  OAI2BB1X1 U283 ( .A0N(WrPtr[0]), .A1N(n475), .B0(n468), .Y(TxFFillLevel[0])
         );
  XOR3X1 U284 ( .A(WrPtr[1]), .B(RdPtr[1]), .C(n468), .Y(n433) );
  OAI2BB1X1 U285 ( .A0N(TxDMALevel[1]), .A1N(n433), .B0(n466), .Y(n465) );
  NOR2BX1 U286 ( .AN(TxFFillLevel[0]), .B(TxDMALevel[0]), .Y(n466) );
  OAI31X1 U287 ( .A0(n450), .A1(RdPtr[2]), .A2(n472), .B0(n451), .Y(n379) );
  OA22X1 U288 ( .A0(RdPtr[1]), .A1(n473), .B0(n448), .B1(n473), .Y(n451) );
  NOR2BX1 U289 ( .AN(TXIM), .B(n354), .Y(TXMIS) );
  DFFRX1 WrPtr_reg_2_ ( .D(n376), .CK(PCLK), .RN(PRESETn), .Q(WrPtr[2]), .QN(
        n478) );
  DFFSX1 TNF_reg ( .D(n383), .CK(PCLK), .SN(PRESETn), .Q(TNF), .QN(n476) );
  DFFRX1 TxDataAvlbl_reg ( .D(n384), .CK(PCLK), .RN(PRESETn), .Q(TxDataAvlbl), 
        .QN(TFE) );
  DFFRX1 Wrap_reg ( .D(n382), .CK(PCLK), .RN(PRESETn), .Q(Wrap) );
  DFFRX1 DelRdPtrInc_reg ( .D(TxFRdPtrIncSync), .CK(PCLK), .RN(PRESETn), .QN(
        n471) );
  DFFSX1 TXRIS_reg ( .D(NextTXRIS), .CK(PCLK), .SN(PRESETn), .Q(TXRIS), .QN(
        n354) );
endmodule


module SspApbif ( PCLK, PRESETn, PSEL, PWRITE, PENABLE, PADDR, PWDATA, TNF, 
        RNE, BSY, RFF, TFE, TXRIS, RXRIS, RTRISSync, RORRIS, TXMIS, RXMIS, 
        RTMISSync, RORMIS, TxFFillLevel, RxFFillLevel, RxFRdData, TxFRdData, 
        PRDATA, RORIC, RTIC, SPICON, SPIPRE, SPIINTDMA, SPITXDAT, SPIHIDDEN, 
        SPITXDATWr, RxFRdPtrInc );
  input [4:2] PADDR;
  input [15:0] PWDATA;
  input [3:0] TxFFillLevel;
  input [3:0] RxFFillLevel;
  input [15:0] RxFRdData;
  input [15:0] TxFRdData;
  output [31:0] PRDATA;
  output [3:0] SPICON;
  output [15:0] SPIPRE;
  output [13:0] SPIINTDMA;
  output [15:0] SPITXDAT;
  output [7:0] SPIHIDDEN;
  input PCLK, PRESETn, PSEL, PWRITE, PENABLE, TNF, RNE, BSY, RFF, TFE, TXRIS,
         RXRIS, RTRISSync, RORRIS, TXMIS, RXMIS, RTMISSync, RORMIS;
  output RORIC, RTIC, SPITXDATWr, RxFRdPtrInc;
  wire   NextRORIC, n1086, n1087, n1088, n1089, n1090, n1091, n1092, n1093,
         n1094, n1095, n1096, n1097, n1098, n1099, n1100, n1101, n1102, n1103,
         n1104, n1105, n1106, n1107, n1108, n1109, n1110, n1111, n1112, n1113,
         n1114, n1115, n1116, n1117, n1118, n1119, n1120, n1121, n1122, n1123,
         n1124, n1125, n1126, n1127, n1128, n1129, n1130, n1131, n1132, n1133,
         n1134, n1135, n1136, n1137, n1138, n1139, n1140, n1141, n1142, n1143,
         n1144, n1145, n1148, n1149, n1150, n1151, n1152, n1153, n1154, n1155,
         n1156, n1157, n1158, n1159, n1160, n1161, n1162, n1163, n1164, n1165,
         n1166, n1167, n1169, n1170, n1171, n1175, n1177, n1178, n1179, n1180,
         n1183, n1186, n1187, n1190, n1192, n1193, n1194, n1195, n1197, n1200,
         n1201, n1204, n1205, n1206, n1207, n1208, n1211, n1212, n1213, n1214,
         n1215, n1216, n1217, n1218, n1220, n1221, n1222, n1223, n1224, n1226,
         n1227, n1230, n1231, n1234, n1237, n1240, n1243, n1244, n1245, n1246,
         n1247, n1248, n1251, n1253, n1255, n1256, n1257, n1258, n1259, n1260,
         n1261, n1262, n1263, n1264, n1265, n1266, n1267, n1268, n1269, n1270,
         n1271, n1272, n1273, n1274, n1275, n1276, n1277, n1278, n1279, n1280,
         n1281, n1282, n1283, n1284, n1285, n1286, n1287;
  wire   [15:0] NextPRDATA;

  DFFRX1 SPICON_reg_2_ ( .D(n1088), .CK(PCLK), .RN(PRESETn), .Q(SPICON[2]), 
        .QN(n1279) );
  DFFRX1 PRDATA_reg_31_ ( .D(1'b0), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[31]) );
  DFFRX1 PRDATA_reg_30_ ( .D(1'b0), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[30]) );
  DFFRX1 PRDATA_reg_29_ ( .D(1'b0), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[29]) );
  DFFRX1 PRDATA_reg_28_ ( .D(1'b0), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[28]) );
  DFFRX1 PRDATA_reg_27_ ( .D(1'b0), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[27]) );
  DFFRX1 PRDATA_reg_26_ ( .D(1'b0), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[26]) );
  DFFRX1 PRDATA_reg_25_ ( .D(1'b0), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[25]) );
  DFFRX1 PRDATA_reg_24_ ( .D(1'b0), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[24]) );
  DFFRX1 PRDATA_reg_23_ ( .D(1'b0), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[23]) );
  DFFRX1 PRDATA_reg_22_ ( .D(1'b0), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[22]) );
  DFFRX1 PRDATA_reg_21_ ( .D(1'b0), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[21]) );
  DFFRX1 PRDATA_reg_20_ ( .D(1'b0), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[20]) );
  DFFRX1 PRDATA_reg_19_ ( .D(1'b0), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[19]) );
  DFFRX1 PRDATA_reg_18_ ( .D(1'b0), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[18]) );
  DFFRX1 PRDATA_reg_17_ ( .D(1'b0), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[17]) );
  DFFRX1 PRDATA_reg_16_ ( .D(1'b0), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[16]) );
  INVX1 U698 ( .A(n1287), .Y(SPITXDATWr) );
  INVX1 U699 ( .A(n1148), .Y(n1149) );
  BUFX2 U700 ( .A(n1160), .Y(n1287) );
  NAND2BX1 U701 ( .AN(n1150), .B(n1161), .Y(n1160) );
  NAND2BX1 U702 ( .AN(n1150), .B(n1151), .Y(n1148) );
  NAND2BX1 U703 ( .AN(n1150), .B(n1167), .Y(n1155) );
  INVX1 U704 ( .A(n1156), .Y(n1157) );
  INVX1 U705 ( .A(n1244), .Y(n1179) );
  INVX1 U706 ( .A(n1286), .Y(n1163) );
  INVX1 U707 ( .A(n1177), .Y(n1212) );
  INVX1 U708 ( .A(n1175), .Y(n1217) );
  INVX1 U709 ( .A(n1165), .Y(n1166) );
  INVX1 U710 ( .A(n1197), .Y(n1187) );
  INVX1 U711 ( .A(n1226), .Y(n1211) );
  INVX1 U712 ( .A(n1220), .Y(n1207) );
  NAND2BX1 U713 ( .AN(n1171), .B(n1285), .Y(n1150) );
  INVX1 U714 ( .A(n1164), .Y(n1161) );
  NAND2BX1 U715 ( .AN(n1158), .B(n1151), .Y(n1156) );
  NAND2BX1 U716 ( .AN(n1164), .B(n1248), .Y(n1175) );
  NAND2BX1 U717 ( .AN(n1164), .B(n1224), .Y(n1177) );
  NAND2BX1 U718 ( .AN(n1158), .B(n1167), .Y(n1165) );
  NAND2BX1 U719 ( .AN(n1159), .B(n1248), .Y(n1197) );
  NAND2BX1 U720 ( .AN(n1170), .B(n1224), .Y(n1220) );
  NAND2BX1 U721 ( .AN(n1159), .B(n1224), .Y(n1244) );
  NAND2BX1 U722 ( .AN(n1170), .B(n1248), .Y(n1226) );
  INVX1 U723 ( .A(n1169), .Y(n1180) );
  BUFX2 U724 ( .A(n1162), .Y(n1286) );
  NAND2BX1 U725 ( .AN(n1158), .B(n1161), .Y(n1162) );
  INVX1 U726 ( .A(n1159), .Y(n1151) );
  INVX1 U727 ( .A(n1218), .Y(n1195) );
  INVX1 U728 ( .A(n1170), .Y(n1167) );
  DFFRX1 PRDATA_reg_0_ ( .D(NextPRDATA[0]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[0]) );
  DFFRX1 PRDATA_reg_1_ ( .D(NextPRDATA[1]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[1]) );
  DFFRX1 PRDATA_reg_2_ ( .D(NextPRDATA[2]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[2]) );
  DFFRX1 PRDATA_reg_3_ ( .D(NextPRDATA[3]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[3]) );
  DFFRX1 PRDATA_reg_4_ ( .D(NextPRDATA[4]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[4]) );
  DFFRX1 PRDATA_reg_5_ ( .D(NextPRDATA[5]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[5]) );
  DFFRX1 PRDATA_reg_6_ ( .D(NextPRDATA[6]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[6]) );
  DFFRX1 PRDATA_reg_7_ ( .D(NextPRDATA[7]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[7]) );
  DFFRX1 PRDATA_reg_8_ ( .D(NextPRDATA[8]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[8]) );
  DFFRX1 PRDATA_reg_9_ ( .D(NextPRDATA[9]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[9]) );
  DFFRX1 PRDATA_reg_10_ ( .D(NextPRDATA[10]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[10]) );
  DFFRX1 PRDATA_reg_11_ ( .D(NextPRDATA[11]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[11]) );
  DFFRX1 PRDATA_reg_12_ ( .D(NextPRDATA[12]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[12]) );
  DFFRX1 PRDATA_reg_13_ ( .D(NextPRDATA[13]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[13]) );
  DFFRX1 PRDATA_reg_14_ ( .D(NextPRDATA[14]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[14]) );
  DFFRX1 PRDATA_reg_15_ ( .D(NextPRDATA[15]), .CK(PCLK), .RN(PRESETn), .Q(
        PRDATA[15]) );
  DFFSX1 SPIHIDDEN_reg_5_ ( .D(n1140), .CK(PCLK), .SN(PRESETn), .Q(
        SPIHIDDEN[5]), .QN(n1256) );
  DFFRX1 SPIHIDDEN_reg_3_ ( .D(n1142), .CK(PCLK), .RN(PRESETn), .Q(
        SPIHIDDEN[3]), .QN(n1255) );
  DFFSX1 SPIHIDDEN_reg_6_ ( .D(n1139), .CK(PCLK), .SN(PRESETn), .Q(
        SPIHIDDEN[6]) );
  DFFRX1 SPICON_reg_3_ ( .D(n1087), .CK(PCLK), .RN(PRESETn), .Q(SPICON[3]) );
  DFFSX1 SPIHIDDEN_reg_4_ ( .D(n1141), .CK(PCLK), .SN(PRESETn), .Q(
        SPIHIDDEN[4]), .QN(n1266) );
  DFFRX1 SPICON_reg_0_ ( .D(n1090), .CK(PCLK), .RN(PRESETn), .Q(SPICON[0]), 
        .QN(n1257) );
  DFFRX1 SPIHIDDEN_reg_2_ ( .D(n1143), .CK(PCLK), .RN(PRESETn), .Q(
        SPIHIDDEN[2]) );
  NAND3BX1 U729 ( .AN(PADDR[2]), .B(PADDR[3]), .C(n1248), .Y(n1169) );
  AND3X2 U730 ( .A(PENABLE), .B(PSEL), .C(PWRITE), .Y(n1285) );
  NAND2BX1 U731 ( .AN(PADDR[3]), .B(PADDR[2]), .Y(n1164) );
  NOR2BX1 U732 ( .AN(PENABLE), .B(n1169), .Y(RxFRdPtrInc) );
  INVX1 U733 ( .A(n1253), .Y(n1248) );
  NAND3BX1 U734 ( .AN(PWRITE), .B(PSEL), .C(PADDR[4]), .Y(n1253) );
  NAND3BX1 U735 ( .AN(PADDR[2]), .B(PADDR[3]), .C(n1224), .Y(n1218) );
  INVX1 U736 ( .A(n1251), .Y(n1224) );
  NAND3BX1 U737 ( .AN(PWRITE), .B(n1171), .C(PSEL), .Y(n1251) );
  NAND2X1 U738 ( .A(PADDR[2]), .B(PADDR[3]), .Y(n1159) );
  OR2X1 U739 ( .A(PADDR[2]), .B(PADDR[3]), .Y(n1170) );
  INVX1 U740 ( .A(PADDR[4]), .Y(n1171) );
  OAI221X1 U741 ( .A0(n1269), .A1(n1175), .B0(n1265), .B1(n1177), .C0(n1183), 
        .Y(NextPRDATA[8]) );
  AOI22X1 U742 ( .A0(n1179), .A1(SPIINTDMA[8]), .B0(RxFRdData[8]), .B1(n1180), 
        .Y(n1183) );
  NAND2BX1 U743 ( .AN(PADDR[4]), .B(n1285), .Y(n1158) );
  NAND3BX1 U744 ( .AN(n1213), .B(n1214), .C(n1215), .Y(NextPRDATA[2]) );
  OA22X1 U745 ( .A0(RNE), .A1(n1218), .B0(n1279), .B1(n1220), .Y(n1214) );
  AO22X1 U746 ( .A0(RxFRdData[2]), .A1(n1180), .B0(n1179), .B1(SPIINTDMA[2]), 
        .Y(n1213) );
  AOI221X1 U747 ( .A0(n1212), .A1(SPIPRE[2]), .B0(RXRIS), .B1(n1211), .C0(
        n1216), .Y(n1215) );
  NOR2BX1 U748 ( .AN(PWDATA[4]), .B(n1155), .Y(NextRORIC) );
  AO22X1 U749 ( .A0(SPIHIDDEN[6]), .A1(n1148), .B0(PWDATA[6]), .B1(n1149), .Y(
        n1139) );
  AO22X1 U750 ( .A0(SPIHIDDEN[5]), .A1(n1148), .B0(PWDATA[5]), .B1(n1149), .Y(
        n1140) );
  AO22X1 U751 ( .A0(SPIHIDDEN[4]), .A1(n1148), .B0(PWDATA[4]), .B1(n1149), .Y(
        n1141) );
  AO22X1 U752 ( .A0(SPITXDAT[15]), .A1(n1287), .B0(PWDATA[15]), .B1(SPITXDATWr), .Y(n1107) );
  AO22X1 U753 ( .A0(SPITXDAT[14]), .A1(n1287), .B0(PWDATA[14]), .B1(SPITXDATWr), .Y(n1108) );
  AO22X1 U754 ( .A0(SPIINTDMA[13]), .A1(n1156), .B0(PWDATA[13]), .B1(n1157), 
        .Y(n1123) );
  AO22X1 U755 ( .A0(SPIINTDMA[12]), .A1(n1156), .B0(PWDATA[12]), .B1(n1157), 
        .Y(n1124) );
  AO22X1 U756 ( .A0(SPIINTDMA[11]), .A1(n1156), .B0(PWDATA[11]), .B1(n1157), 
        .Y(n1125) );
  AO22X1 U757 ( .A0(SPIINTDMA[10]), .A1(n1156), .B0(PWDATA[10]), .B1(n1157), 
        .Y(n1126) );
  AO22X1 U758 ( .A0(SPIINTDMA[9]), .A1(n1156), .B0(PWDATA[9]), .B1(n1157), .Y(
        n1127) );
  AO22X1 U759 ( .A0(SPIINTDMA[8]), .A1(n1156), .B0(PWDATA[8]), .B1(n1157), .Y(
        n1128) );
  AO22X1 U760 ( .A0(SPIHIDDEN[7]), .A1(n1148), .B0(PWDATA[7]), .B1(n1149), .Y(
        n1138) );
  AO22X1 U761 ( .A0(SPIHIDDEN[3]), .A1(n1148), .B0(PWDATA[3]), .B1(n1149), .Y(
        n1142) );
  AO22X1 U762 ( .A0(SPIHIDDEN[2]), .A1(n1148), .B0(PWDATA[2]), .B1(n1149), .Y(
        n1143) );
  AO22X1 U763 ( .A0(SPIHIDDEN[1]), .A1(n1148), .B0(PWDATA[1]), .B1(n1149), .Y(
        n1144) );
  AO22X1 U764 ( .A0(SPIHIDDEN[0]), .A1(n1148), .B0(PWDATA[0]), .B1(n1149), .Y(
        n1145) );
  AO22X1 U765 ( .A0(SPICON[2]), .A1(n1165), .B0(n1166), .B1(PWDATA[2]), .Y(
        n1088) );
  AO22X1 U766 ( .A0(SPIINTDMA[5]), .A1(n1156), .B0(n1157), .B1(PWDATA[5]), .Y(
        n1131) );
  AO22X1 U767 ( .A0(SPIINTDMA[0]), .A1(n1156), .B0(n1157), .B1(PWDATA[0]), .Y(
        n1136) );
  AO22X1 U768 ( .A0(SPICON[3]), .A1(n1165), .B0(n1166), .B1(PWDATA[3]), .Y(
        n1087) );
  AO22X1 U769 ( .A0(SPICON[1]), .A1(n1165), .B0(n1166), .B1(PWDATA[1]), .Y(
        n1089) );
  AO22X1 U770 ( .A0(SPICON[0]), .A1(n1165), .B0(n1166), .B1(PWDATA[0]), .Y(
        n1090) );
  AO22X1 U771 ( .A0(SPIPRE[15]), .A1(n1286), .B0(n1163), .B1(PWDATA[15]), .Y(
        n1091) );
  AO22X1 U772 ( .A0(SPIPRE[14]), .A1(n1286), .B0(n1163), .B1(PWDATA[14]), .Y(
        n1092) );
  AO22X1 U773 ( .A0(SPIPRE[13]), .A1(n1286), .B0(n1163), .B1(PWDATA[13]), .Y(
        n1093) );
  AO22X1 U774 ( .A0(SPIPRE[12]), .A1(n1286), .B0(n1163), .B1(PWDATA[12]), .Y(
        n1094) );
  AO22X1 U775 ( .A0(SPIPRE[11]), .A1(n1286), .B0(n1163), .B1(PWDATA[11]), .Y(
        n1095) );
  AO22X1 U776 ( .A0(SPIPRE[10]), .A1(n1286), .B0(n1163), .B1(PWDATA[10]), .Y(
        n1096) );
  AO22X1 U777 ( .A0(SPIPRE[9]), .A1(n1286), .B0(n1163), .B1(PWDATA[9]), .Y(
        n1097) );
  AO22X1 U778 ( .A0(SPIPRE[8]), .A1(n1286), .B0(n1163), .B1(PWDATA[8]), .Y(
        n1098) );
  AO22X1 U779 ( .A0(SPIPRE[7]), .A1(n1286), .B0(n1163), .B1(PWDATA[7]), .Y(
        n1099) );
  AO22X1 U780 ( .A0(SPIPRE[6]), .A1(n1286), .B0(n1163), .B1(PWDATA[6]), .Y(
        n1100) );
  AO22X1 U781 ( .A0(SPIPRE[5]), .A1(n1286), .B0(n1163), .B1(PWDATA[5]), .Y(
        n1101) );
  AO22X1 U782 ( .A0(SPIPRE[4]), .A1(n1286), .B0(n1163), .B1(PWDATA[4]), .Y(
        n1102) );
  AO22X1 U783 ( .A0(SPIPRE[3]), .A1(n1286), .B0(n1163), .B1(PWDATA[3]), .Y(
        n1103) );
  AO22X1 U784 ( .A0(SPIPRE[2]), .A1(n1286), .B0(n1163), .B1(PWDATA[2]), .Y(
        n1104) );
  AO22X1 U785 ( .A0(SPIPRE[1]), .A1(n1286), .B0(n1163), .B1(PWDATA[1]), .Y(
        n1105) );
  AO22X1 U786 ( .A0(SPIPRE[0]), .A1(n1286), .B0(n1163), .B1(PWDATA[0]), .Y(
        n1106) );
  AO22X1 U787 ( .A0(SPITXDAT[13]), .A1(n1287), .B0(SPITXDATWr), .B1(PWDATA[13]), .Y(n1109) );
  AO22X1 U788 ( .A0(SPITXDAT[12]), .A1(n1287), .B0(SPITXDATWr), .B1(PWDATA[12]), .Y(n1110) );
  AO22X1 U789 ( .A0(SPITXDAT[11]), .A1(n1287), .B0(SPITXDATWr), .B1(PWDATA[11]), .Y(n1111) );
  AO22X1 U790 ( .A0(SPITXDAT[10]), .A1(n1287), .B0(SPITXDATWr), .B1(PWDATA[10]), .Y(n1112) );
  AO22X1 U791 ( .A0(SPITXDAT[9]), .A1(n1287), .B0(SPITXDATWr), .B1(PWDATA[9]), 
        .Y(n1113) );
  AO22X1 U792 ( .A0(SPITXDAT[8]), .A1(n1287), .B0(SPITXDATWr), .B1(PWDATA[8]), 
        .Y(n1114) );
  AO22X1 U793 ( .A0(SPITXDAT[7]), .A1(n1287), .B0(SPITXDATWr), .B1(PWDATA[7]), 
        .Y(n1115) );
  AO22X1 U794 ( .A0(SPITXDAT[6]), .A1(n1287), .B0(SPITXDATWr), .B1(PWDATA[6]), 
        .Y(n1116) );
  AO22X1 U795 ( .A0(SPITXDAT[5]), .A1(n1287), .B0(SPITXDATWr), .B1(PWDATA[5]), 
        .Y(n1117) );
  AO22X1 U796 ( .A0(SPITXDAT[4]), .A1(n1287), .B0(SPITXDATWr), .B1(PWDATA[4]), 
        .Y(n1118) );
  AO22X1 U797 ( .A0(SPITXDAT[3]), .A1(n1287), .B0(SPITXDATWr), .B1(PWDATA[3]), 
        .Y(n1119) );
  AO22X1 U798 ( .A0(SPITXDAT[2]), .A1(n1287), .B0(SPITXDATWr), .B1(PWDATA[2]), 
        .Y(n1120) );
  AO22X1 U799 ( .A0(SPITXDAT[1]), .A1(n1287), .B0(SPITXDATWr), .B1(PWDATA[1]), 
        .Y(n1121) );
  AO22X1 U800 ( .A0(SPITXDAT[0]), .A1(n1287), .B0(SPITXDATWr), .B1(PWDATA[0]), 
        .Y(n1122) );
  AO22X1 U801 ( .A0(SPIINTDMA[7]), .A1(n1156), .B0(n1157), .B1(PWDATA[7]), .Y(
        n1129) );
  AO22X1 U802 ( .A0(SPIINTDMA[6]), .A1(n1156), .B0(n1157), .B1(PWDATA[6]), .Y(
        n1130) );
  AO22X1 U803 ( .A0(SPIINTDMA[4]), .A1(n1156), .B0(n1157), .B1(PWDATA[4]), .Y(
        n1132) );
  AO22X1 U804 ( .A0(SPIINTDMA[3]), .A1(n1156), .B0(n1157), .B1(PWDATA[3]), .Y(
        n1133) );
  AO22X1 U805 ( .A0(SPIINTDMA[2]), .A1(n1156), .B0(n1157), .B1(PWDATA[2]), .Y(
        n1134) );
  AO22X1 U806 ( .A0(SPIINTDMA[1]), .A1(n1156), .B0(n1157), .B1(PWDATA[1]), .Y(
        n1135) );
  NAND3BX1 U807 ( .AN(n1245), .B(n1246), .C(n1247), .Y(NextPRDATA[0]) );
  OA22X1 U808 ( .A0(n1257), .A1(n1220), .B0(n1282), .B1(n1244), .Y(n1246) );
  AO22X1 U809 ( .A0(n1187), .A1(SPIHIDDEN[0]), .B0(RxFRdData[0]), .B1(n1180), 
        .Y(n1245) );
  AOI222X1 U810 ( .A0(n1217), .A1(SPITXDAT[0]), .B0(RORRIS), .B1(n1211), .C0(
        n1212), .C1(SPIPRE[0]), .Y(n1247) );
  NAND3BX1 U811 ( .AN(n1204), .B(n1205), .C(n1206), .Y(NextPRDATA[3]) );
  AO22X1 U812 ( .A0(TXRIS), .A1(n1211), .B0(n1212), .B1(SPIPRE[3]), .Y(n1204)
         );
  OA22X1 U813 ( .A0(n1255), .A1(n1197), .B0(n1283), .B1(n1175), .Y(n1205) );
  AOI221X1 U814 ( .A0(RFF), .A1(n1195), .B0(n1207), .B1(SPICON[3]), .C0(n1208), 
        .Y(n1206) );
  NOR2BX1 U815 ( .AN(n1195), .B(TNF), .Y(n1194) );
  OA22X1 U816 ( .A0(n1267), .A1(n1197), .B0(n1284), .B1(n1175), .Y(n1227) );
  AO22X1 U817 ( .A0(n1217), .A1(SPITXDAT[2]), .B0(n1187), .B1(SPIHIDDEN[2]), 
        .Y(n1216) );
  NAND2BX1 U818 ( .AN(n1221), .B(n1222), .Y(NextPRDATA[1]) );
  AOI221X1 U819 ( .A0(BSY), .A1(n1195), .B0(n1207), .B1(SPICON[1]), .C0(n1223), 
        .Y(n1222) );
  OAI221X1 U820 ( .A0(n1268), .A1(n1177), .B0(n1153), .B1(n1226), .C0(n1227), 
        .Y(n1221) );
  AO22X1 U821 ( .A0(RxFRdData[1]), .A1(n1180), .B0(n1179), .B1(SPIINTDMA[1]), 
        .Y(n1223) );
  AO22X1 U822 ( .A0(RxFRdData[3]), .A1(n1180), .B0(n1179), .B1(SPIINTDMA[3]), 
        .Y(n1208) );
  OAI32X1 U823 ( .A0(n1152), .A1(n1153), .A2(n1086), .B0(n1154), .B1(n1155), 
        .Y(n1137) );
  INVX1 U824 ( .A(PWDATA[5]), .Y(n1154) );
  INVX1 U825 ( .A(n1155), .Y(n1152) );
  OAI221X1 U826 ( .A0(n1270), .A1(n1175), .B0(n1258), .B1(n1177), .C0(n1190), 
        .Y(NextPRDATA[6]) );
  AOI222X1 U827 ( .A0(RxFRdData[6]), .A1(n1180), .B0(n1179), .B1(SPIINTDMA[6]), 
        .C0(n1187), .C1(SPIHIDDEN[6]), .Y(n1190) );
  OAI221X1 U828 ( .A0(n1271), .A1(n1175), .B0(n1260), .B1(n1177), .C0(n1178), 
        .Y(NextPRDATA[9]) );
  AOI22X1 U829 ( .A0(n1179), .A1(SPIINTDMA[9]), .B0(RxFRdData[9]), .B1(n1180), 
        .Y(n1178) );
  OAI221X1 U830 ( .A0(n1272), .A1(n1175), .B0(n1261), .B1(n1177), .C0(n1243), 
        .Y(NextPRDATA[10]) );
  AOI22X1 U831 ( .A0(n1179), .A1(SPIINTDMA[10]), .B0(RxFRdData[10]), .B1(n1180), .Y(n1243) );
  OAI221X1 U832 ( .A0(n1273), .A1(n1175), .B0(n1262), .B1(n1177), .C0(n1240), 
        .Y(NextPRDATA[11]) );
  AOI22X1 U833 ( .A0(n1179), .A1(SPIINTDMA[11]), .B0(RxFRdData[11]), .B1(n1180), .Y(n1240) );
  OAI221X1 U834 ( .A0(n1274), .A1(n1175), .B0(n1263), .B1(n1177), .C0(n1237), 
        .Y(NextPRDATA[12]) );
  AOI22X1 U835 ( .A0(n1179), .A1(SPIINTDMA[12]), .B0(RxFRdData[12]), .B1(n1180), .Y(n1237) );
  OAI221X1 U836 ( .A0(n1275), .A1(n1175), .B0(n1264), .B1(n1177), .C0(n1234), 
        .Y(NextPRDATA[13]) );
  AOI22X1 U837 ( .A0(n1179), .A1(SPIINTDMA[13]), .B0(RxFRdData[13]), .B1(n1180), .Y(n1234) );
  OAI221X1 U838 ( .A0(n1276), .A1(n1175), .B0(n1259), .B1(n1177), .C0(n1186), 
        .Y(NextPRDATA[7]) );
  AOI222X1 U839 ( .A0(RxFRdData[7]), .A1(n1180), .B0(n1179), .B1(SPIINTDMA[7]), 
        .C0(n1187), .C1(SPIHIDDEN[7]), .Y(n1186) );
  AO21X1 U840 ( .A0(RxFRdData[14]), .A1(n1180), .B0(n1231), .Y(NextPRDATA[14])
         );
  AO22X1 U841 ( .A0(n1217), .A1(SPITXDAT[14]), .B0(n1212), .B1(SPIPRE[14]), 
        .Y(n1231) );
  AO21X1 U842 ( .A0(RxFRdData[15]), .A1(n1180), .B0(n1230), .Y(NextPRDATA[15])
         );
  AO22X1 U843 ( .A0(n1217), .A1(SPITXDAT[15]), .B0(n1212), .B1(SPIPRE[15]), 
        .Y(n1230) );
  OAI211X1 U844 ( .A0(n1277), .A1(n1175), .B0(n1200), .C0(n1201), .Y(
        NextPRDATA[4]) );
  OA22X1 U845 ( .A0(n1266), .A1(n1197), .B0(n1280), .B1(n1177), .Y(n1200) );
  AOI222X1 U846 ( .A0(RxFRdData[4]), .A1(n1180), .B0(TFE), .B1(n1195), .C0(
        n1179), .C1(SPIINTDMA[4]), .Y(n1201) );
  OAI211X1 U847 ( .A0(n1278), .A1(n1175), .B0(n1192), .C0(n1193), .Y(
        NextPRDATA[5]) );
  OA22X1 U848 ( .A0(n1256), .A1(n1197), .B0(n1281), .B1(n1177), .Y(n1192) );
  AOI221X1 U849 ( .A0(RxFRdData[5]), .A1(n1180), .B0(n1179), .B1(SPIINTDMA[5]), 
        .C0(n1194), .Y(n1193) );
  INVX1 U850 ( .A(RTRISSync), .Y(n1153) );
  DFFRX1 SPICON_reg_1_ ( .D(n1089), .CK(PCLK), .RN(PRESETn), .Q(SPICON[1]) );
  DFFRX1 SPIHIDDEN_reg_7_ ( .D(n1138), .CK(PCLK), .RN(PRESETn), .Q(
        SPIHIDDEN[7]) );
  DFFRX1 SPIHIDDEN_reg_1_ ( .D(n1144), .CK(PCLK), .RN(PRESETn), .Q(
        SPIHIDDEN[1]), .QN(n1267) );
  DFFRX1 SPIINTDMA_reg_1_ ( .D(n1135), .CK(PCLK), .RN(PRESETn), .Q(
        SPIINTDMA[1]) );
  DFFRX1 RTIC_reg ( .D(n1137), .CK(PCLK), .RN(PRESETn), .Q(RTIC), .QN(n1086)
         );
  DFFRX1 SPIINTDMA_reg_8_ ( .D(n1128), .CK(PCLK), .RN(PRESETn), .Q(
        SPIINTDMA[8]) );
  DFFRX1 SPIINTDMA_reg_3_ ( .D(n1133), .CK(PCLK), .RN(PRESETn), .Q(
        SPIINTDMA[3]) );
  DFFRX1 SPIINTDMA_reg_2_ ( .D(n1134), .CK(PCLK), .RN(PRESETn), .Q(
        SPIINTDMA[2]) );
  DFFSX1 SPIINTDMA_reg_0_ ( .D(n1136), .CK(PCLK), .SN(PRESETn), .Q(
        SPIINTDMA[0]), .QN(n1282) );
  DFFRX1 SPIHIDDEN_reg_0_ ( .D(n1145), .CK(PCLK), .RN(PRESETn), .Q(
        SPIHIDDEN[0]) );
  DFFRX1 SPIPRE_reg_7_ ( .D(n1099), .CK(PCLK), .RN(PRESETn), .Q(SPIPRE[7]), 
        .QN(n1259) );
  DFFRX1 SPIPRE_reg_6_ ( .D(n1100), .CK(PCLK), .RN(PRESETn), .Q(SPIPRE[6]), 
        .QN(n1258) );
  DFFRX1 SPIPRE_reg_5_ ( .D(n1101), .CK(PCLK), .RN(PRESETn), .Q(SPIPRE[5]), 
        .QN(n1281) );
  DFFRX1 SPIPRE_reg_4_ ( .D(n1102), .CK(PCLK), .RN(PRESETn), .Q(SPIPRE[4]), 
        .QN(n1280) );
  DFFRX1 SPIPRE_reg_1_ ( .D(n1105), .CK(PCLK), .RN(PRESETn), .Q(SPIPRE[1]), 
        .QN(n1268) );
  DFFRX1 SPIINTDMA_reg_7_ ( .D(n1129), .CK(PCLK), .RN(PRESETn), .Q(
        SPIINTDMA[7]) );
  DFFRX1 SPIPRE_reg_13_ ( .D(n1093), .CK(PCLK), .RN(PRESETn), .Q(SPIPRE[13]), 
        .QN(n1264) );
  DFFRX1 SPIPRE_reg_12_ ( .D(n1094), .CK(PCLK), .RN(PRESETn), .Q(SPIPRE[12]), 
        .QN(n1263) );
  DFFRX1 SPIPRE_reg_11_ ( .D(n1095), .CK(PCLK), .RN(PRESETn), .Q(SPIPRE[11]), 
        .QN(n1262) );
  DFFRX1 SPIPRE_reg_10_ ( .D(n1096), .CK(PCLK), .RN(PRESETn), .Q(SPIPRE[10]), 
        .QN(n1261) );
  DFFRX1 SPIPRE_reg_9_ ( .D(n1097), .CK(PCLK), .RN(PRESETn), .Q(SPIPRE[9]), 
        .QN(n1260) );
  DFFRX1 SPIPRE_reg_8_ ( .D(n1098), .CK(PCLK), .RN(PRESETn), .Q(SPIPRE[8]), 
        .QN(n1265) );
  DFFRX1 SPITXDAT_reg_13_ ( .D(n1109), .CK(PCLK), .RN(PRESETn), .Q(
        SPITXDAT[13]), .QN(n1275) );
  DFFRX1 SPITXDAT_reg_12_ ( .D(n1110), .CK(PCLK), .RN(PRESETn), .Q(
        SPITXDAT[12]), .QN(n1274) );
  DFFRX1 SPITXDAT_reg_11_ ( .D(n1111), .CK(PCLK), .RN(PRESETn), .Q(
        SPITXDAT[11]), .QN(n1273) );
  DFFRX1 SPITXDAT_reg_10_ ( .D(n1112), .CK(PCLK), .RN(PRESETn), .Q(
        SPITXDAT[10]), .QN(n1272) );
  DFFRX1 SPITXDAT_reg_9_ ( .D(n1113), .CK(PCLK), .RN(PRESETn), .Q(SPITXDAT[9]), 
        .QN(n1271) );
  DFFRX1 SPITXDAT_reg_8_ ( .D(n1114), .CK(PCLK), .RN(PRESETn), .Q(SPITXDAT[8]), 
        .QN(n1269) );
  DFFRX1 SPITXDAT_reg_7_ ( .D(n1115), .CK(PCLK), .RN(PRESETn), .Q(SPITXDAT[7]), 
        .QN(n1276) );
  DFFRX1 SPITXDAT_reg_6_ ( .D(n1116), .CK(PCLK), .RN(PRESETn), .Q(SPITXDAT[6]), 
        .QN(n1270) );
  DFFRX1 SPITXDAT_reg_5_ ( .D(n1117), .CK(PCLK), .RN(PRESETn), .Q(SPITXDAT[5]), 
        .QN(n1278) );
  DFFRX1 SPITXDAT_reg_4_ ( .D(n1118), .CK(PCLK), .RN(PRESETn), .Q(SPITXDAT[4]), 
        .QN(n1277) );
  DFFRX1 SPITXDAT_reg_3_ ( .D(n1119), .CK(PCLK), .RN(PRESETn), .Q(SPITXDAT[3]), 
        .QN(n1283) );
  DFFRX1 SPITXDAT_reg_1_ ( .D(n1121), .CK(PCLK), .RN(PRESETn), .Q(SPITXDAT[1]), 
        .QN(n1284) );
  DFFRX1 SPIINTDMA_reg_11_ ( .D(n1125), .CK(PCLK), .RN(PRESETn), .Q(
        SPIINTDMA[11]) );
  DFFRX1 SPIINTDMA_reg_6_ ( .D(n1130), .CK(PCLK), .RN(PRESETn), .Q(
        SPIINTDMA[6]) );
  DFFRX1 SPIINTDMA_reg_13_ ( .D(n1123), .CK(PCLK), .RN(PRESETn), .Q(
        SPIINTDMA[13]) );
  DFFRX1 SPIINTDMA_reg_12_ ( .D(n1124), .CK(PCLK), .RN(PRESETn), .Q(
        SPIINTDMA[12]) );
  DFFRX1 SPIINTDMA_reg_10_ ( .D(n1126), .CK(PCLK), .RN(PRESETn), .Q(
        SPIINTDMA[10]) );
  DFFRX1 SPIINTDMA_reg_9_ ( .D(n1127), .CK(PCLK), .RN(PRESETn), .Q(
        SPIINTDMA[9]) );
  DFFSX1 SPIINTDMA_reg_5_ ( .D(n1131), .CK(PCLK), .SN(PRESETn), .Q(
        SPIINTDMA[5]) );
  DFFRX1 SPIPRE_reg_3_ ( .D(n1103), .CK(PCLK), .RN(PRESETn), .Q(SPIPRE[3]) );
  DFFRX1 SPIPRE_reg_2_ ( .D(n1104), .CK(PCLK), .RN(PRESETn), .Q(SPIPRE[2]) );
  DFFRX1 SPIPRE_reg_0_ ( .D(n1106), .CK(PCLK), .RN(PRESETn), .Q(SPIPRE[0]) );
  DFFRX1 SPIPRE_reg_15_ ( .D(n1091), .CK(PCLK), .RN(PRESETn), .Q(SPIPRE[15])
         );
  DFFRX1 SPIPRE_reg_14_ ( .D(n1092), .CK(PCLK), .RN(PRESETn), .Q(SPIPRE[14])
         );
  DFFRX1 SPIINTDMA_reg_4_ ( .D(n1132), .CK(PCLK), .RN(PRESETn), .Q(
        SPIINTDMA[4]) );
  DFFRX1 SPITXDAT_reg_15_ ( .D(n1107), .CK(PCLK), .RN(PRESETn), .Q(
        SPITXDAT[15]) );
  DFFRX1 SPITXDAT_reg_14_ ( .D(n1108), .CK(PCLK), .RN(PRESETn), .Q(
        SPITXDAT[14]) );
  DFFRX1 SPITXDAT_reg_2_ ( .D(n1120), .CK(PCLK), .RN(PRESETn), .Q(SPITXDAT[2])
         );
  DFFRX1 SPITXDAT_reg_0_ ( .D(n1122), .CK(PCLK), .RN(PRESETn), .Q(SPITXDAT[0])
         );
  DFFRX1 RORIC_reg ( .D(NextRORIC), .CK(PCLK), .RN(PRESETn), .Q(RORIC) );
endmodule

