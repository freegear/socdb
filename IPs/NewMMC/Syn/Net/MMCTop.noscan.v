
module MMCTop ( PCLK, PRESETn, PSEL, PENABLE, PWRITE, PADDR, PWDATA, PRDATA, 
        MMC_FBCLK, MMC_CMDIN, MMC_DATIN, TESTMODE, MMC_INT, MMC_DMAREQ, 
        MMC_CLKOUT, MMC_CMDOUT, MMC_DATOUT, MMC_nCMDEN, MMC_nDATEN );
  input [6:2] PADDR;
  input [31:0] PWDATA;
  output [31:0] PRDATA;
  input [7:0] MMC_DATIN;
  output [7:0] MMC_DATOUT;
  input PCLK, PRESETn, PSEL, PENABLE, PWRITE, MMC_FBCLK, MMC_CMDIN, TESTMODE;
  output MMC_INT, MMC_DMAREQ, MMC_CLKOUT, MMC_CMDOUT, MMC_nCMDEN, MMC_nDATEN;
  wire   SDIDatCon_30_, SDIDatCon_29_, SDIDatCon_28_, SDIDatCon_27_,
         SDIDatCon_26_, SDIDatCon_25_, SDIDatCon_24_, SDIDatCon_23_,
         SDIDatCon_22_, SDIDatCon_21_, SDIDatCon_20_, SDIDatCon_19_,
         SDIDatCon_18_, SDIDatCon_15_, SDIDatCon_14_, SDIDatCon_13_,
         SDIDatCon_12_, SDIDatCon_11_, SDIDatCon_10_, SDIDatCon_9_,
         SDIDatCon_8_, SDIDatCon_7_, SDIDatCon_6_, SDIDatCon_5_, SDIDatCon_4_,
         SDIDatCon_3_, SDIDatCon_2_, SDIDatCon_1_, SDIDatCon_0_, SDreset,
         ENCLK, neg_CKPulse, CKPulse, ENCLK_REG, PSAVEON, CMST, CMSTClr,
         RspCrcSet, CmdSentSet, CmdToutSet, RspFinSet, CmdOn, DTST, DTSTClr,
         NoBusySet, CrcStaSet, DatCrcSet, DatToutSet, DatFinSet, BusyFinSet,
         TxDatOn, RxDatOn, FRST, RxUnderrun, TxOverrun, TFDET, RFDET, TFHalf,
         TFEmpty, RFFull, RFHalf, TxWriteEn, RxRdPtrInc, InvSel, RCmdStart,
         RCmdStartClr, AutoReadComplete, n_2, TxActive, TxRdPtrInc, RxActive,
         RxWriteEn, TFREmpty, ENCLK_FIFO, CmdCtrlIdle, BusyChkIdle,
         DatCtrlIdle, MMC_FBCLK_DLY0, iMMC_FBCLK, MMC_FBCLK_DLY1,
         MMC_FBCLK_DLY2, MMC_FBCLK_DLY3, MMC_FBCLK_DLY4, iFBCLK_BUF, iFBCLK,
         CMDIN, CmdStartMuxO, NoCRCRspMuxO, LongRspMuxO, WaitRspMuxO,
         BusyRspMuxO, AbortCmdMuxO, n401, n402, n420, n421, n422, n423, n424,
         n425, n426, n427, n428, n429, n430, n431, n432, n433, n434;
  wire   [1:0] DatMode;
  wire   [7:0] iSDIPRE;
  wire   [31:0] CmdArg;
  wire   [12:0] SDICmdCon;
  wire   [7:0] RspIndex;
  wire   [31:0] Response0;
  wire   [31:0] Response1;
  wire   [31:0] Response2;
  wire   [31:0] Response3;
  wire   [22:0] iDataTimer;
  wire   [15:0] iBlkSize;
  wire   [15:0] BlkNumCnt;
  wire   [15:0] BlkCnt;
  wire   [4:0] FFCNT;
  wire   [31:0] FRdData;
  wire   [2:0] DelaySel;
  wire   [1:0] AutoReadCon;
  wire   [1:0] ErrorState;
  wire   [31:0] ResponseCMD18;
  wire   [31:0] RxFWrData;
  wire   [7:0] DATIN;
  wire   [31:0] CmdArgMuxO;
  wire   [6:0] CmdIndexMuxO;
  wire   SYNOPSYS_UNCONNECTED__0;

  mmc_Prescaler Prescaler ( .PCLK(PCLK), .nRst(PRESETn), .SDreset(SDreset), 
        .SDIPRE(iSDIPRE), .ENCLK(ENCLK), .MMC_CLK(MMC_CLKOUT), .neg_CKPulse(
        neg_CKPulse), .CKPulse(CKPulse) );
  mmc_APBRegisterIF mmc_APBRegisterIF ( .PCLK(PCLK), .PRESETn(PRESETn), .PSEL(
        PSEL), .PENABLE(PENABLE), .PWRITE(PWRITE), .PADDR(PADDR), .PWDATA(
        PWDATA), .PRDATA(PRDATA), .SDreset(SDreset), .ENCLK(ENCLK_REG), 
        .PSAVEON(PSAVEON), .iSDIPRE(iSDIPRE), .CmdArg(CmdArg), .iSDICmdCon({
        SDICmdCon[12:10], SYNOPSYS_UNCONNECTED__0, SDICmdCon[8:0]}), .CMST(
        CMST), .CMSTClr(CMSTClr), .RspCrcSet(RspCrcSet), .CmdSentSet(
        CmdSentSet), .CmdToutSet(CmdToutSet), .RspFinSet(RspFinSet), .CmdOn(
        CmdOn), .RspIndex(RspIndex), .Response0(Response0), .Response1(
        Response1), .Response2(Response2), .Response3(Response3), .iDataTimer(
        iDataTimer), .iBlkSize(iBlkSize), .iSDIDatCon({SDIDatCon_30_, 
        SDIDatCon_29_, SDIDatCon_28_, SDIDatCon_27_, SDIDatCon_26_, 
        SDIDatCon_25_, SDIDatCon_24_, SDIDatCon_23_, SDIDatCon_22_, 
        SDIDatCon_21_, SDIDatCon_20_, SDIDatCon_19_, SDIDatCon_18_, DatMode, 
        SDIDatCon_15_, SDIDatCon_14_, SDIDatCon_13_, SDIDatCon_12_, 
        SDIDatCon_11_, SDIDatCon_10_, SDIDatCon_9_, SDIDatCon_8_, SDIDatCon_7_, 
        SDIDatCon_6_, SDIDatCon_5_, SDIDatCon_4_, SDIDatCon_3_, SDIDatCon_2_, 
        SDIDatCon_1_, SDIDatCon_0_}), .DTST(DTST), .DTSTClr(DTSTClr), 
        .BlkNumCnt(BlkNumCnt), .BlkCnt(BlkCnt), .NoBusySet(NoBusySet), 
        .CrcStaSet(CrcStaSet), .DatCrcSet(DatCrcSet), .DatToutSet(DatToutSet), 
        .DatFinSet(DatFinSet), .BusyFinSet(BusyFinSet), .TxDatOn(TxDatOn), 
        .RxDatOn(RxDatOn), .FRST(FRST), .FFfailSet(n_2), .TFDET(TFDET), 
        .RFDET(RFDET), .TFHalf(TFHalf), .TFEmpty(TFEmpty), .RFFull(RFFull), 
        .RFHalf(RFHalf), .FFCNT(FFCNT), .TxWriteEn(TxWriteEn), .RxRdPtrInc(
        RxRdPtrInc), .FIFOdata(FRdData), .DelaySel(DelaySel), .InvSel(InvSel), 
        .RCmdStart(RCmdStart), .RCmdStartClr(RCmdStartClr), .iAutoReadCon(
        AutoReadCon), .ErrorState(ErrorState), .ResponseCMD18(ResponseCMD18), 
        .AutoReadComplete(AutoReadComplete), .MMC_INT(MMC_INT) );
  mmc_FifoDmaCtr DataFifo_DMA ( .PCLK(PCLK), .PRESETn(PRESETn), .SDreset(
        SDreset), .FRST(FRST), .DatMode(DatMode), .DMASize({SDIDatCon_30_, 
        SDIDatCon_29_, SDIDatCon_28_, SDIDatCon_27_, SDIDatCon_26_, 
        SDIDatCon_25_}), .TxActive(TxActive), .TxRdPtrInc(TxRdPtrInc), 
        .PWData(PWDATA), .RxActive(RxActive), .RxRdPtrInc(RxRdPtrInc), 
        .RxFWrData(RxFWrData), .RxWriteEn(RxWriteEn), .TxWriteEn(TxWriteEn), 
        .RxUnderrun(RxUnderrun), .TxOverrun(TxOverrun), .TFDET(TFDET), 
        .TFHalf(TFHalf), .TFEmpty(TFEmpty), .TFREmpty(TFREmpty), .RFFull(
        RFFull), .RFHalf(RFHalf), .RFDET(RFDET), .FFCNT(FFCNT), .FIFORdData(
        FRdData), .EnDMA(SDIDatCon_18_), .DREQ(MMC_DMAREQ) );
  mmc_PSave mmc_PowerSave ( .PCLK(PCLK), .PRESETn(PRESETn), .CKPulse(CKPulse), 
        .CMST(CMST), .ENCLK_REG(ENCLK_REG), .ENCLK_FIFO(ENCLK_FIFO), 
        .CmdCtrlIdle(CmdCtrlIdle), .BusyChkIdle(BusyChkIdle), .DatCtrlIdle(
        DatCtrlIdle), .PSAVEON(PSAVEON), .ENCLK(ENCLK) );
  DLY3ns FBCLKBUF0 ( .Y(MMC_FBCLK_DLY0), .A(iMMC_FBCLK) );
  DLY3ns FBCLKBUF1 ( .Y(MMC_FBCLK_DLY1), .A(MMC_FBCLK_DLY0) );
  DLY3ns FBCLKBUF2 ( .Y(MMC_FBCLK_DLY2), .A(MMC_FBCLK_DLY1) );
  DLY3ns FBCLKBUF3 ( .Y(MMC_FBCLK_DLY3), .A(MMC_FBCLK_DLY2) );
  DLY3ns FBCLKBUF4 ( .Y(MMC_FBCLK_DLY4), .A(MMC_FBCLK_DLY3) );
  BUFX2 FBCLK_BUF ( .A(iFBCLK), .Y(iFBCLK_BUF) );
  mmc_FeedBackSync FeedBackSync ( .nRst(PRESETn), .SDreset(SDreset), 
        .MMC_FBCLK(iFBCLK_BUF), .MMC_CMDIN(MMC_CMDIN), .MMC_DATIN(MMC_DATIN), 
        .CMDIN(CMDIN), .DATIN(DATIN) );
  AUTORead AutoRead ( .nRst(PRESETn), .SDreset(SDreset), .PCLK(PCLK), 
        .AutoReadEn(AutoReadCon[1]), .RCmdStart(RCmdStart), .RCmdStartClr(
        RCmdStartClr), .SingleMultiRead(AutoReadCon[0]), .Response0(Response0), 
        .NoBusySet(NoBusySet), .BusyFinSet(BusyFinSet), .RspCrcSet(RspCrcSet), 
        .RspFinSet(RspFinSet), .CmdToutSet(CmdToutSet), .DatCrcSet(DatCrcSet), 
        .DatFinSet(DatFinSet), .CmdArg(CmdArg), .CmdIndex(SDICmdCon[6:0]), 
        .CMST(CMST), .CMSTClr(CMSTClr), .NoCRCRsp(SDICmdCon[11]), .LongRsp(
        SDICmdCon[8]), .WaitRsp(SDICmdCon[7]), .BusyRsp(SDICmdCon[12]), 
        .AbortCmd(SDICmdCon[10]), .CmdStartMuxO(CmdStartMuxO), .CmdArgMuxO(
        CmdArgMuxO), .CmdIndexMuxO(CmdIndexMuxO), .NoCRCRspMuxO(NoCRCRspMuxO), 
        .LongRspMuxO(LongRspMuxO), .WaitRspMuxO(WaitRspMuxO), .BusyRspMuxO(
        BusyRspMuxO), .AbortCmdMuxO(AbortCmdMuxO), .ResponseCMD18(
        ResponseCMD18), .AutoReadComplete(AutoReadComplete), .ErrorState(
        ErrorState) );
  mmc_CommandControl CommandControl ( .nRst(PRESETn), .SDreset(SDreset), 
        .PCLK(PCLK), .neg_CKPulse(neg_CKPulse), .CKPulse(CKPulse), .CMDIN(
        CMDIN), .Inv_CMDOUT(MMC_CMDOUT), .Inv_nCMDEN(MMC_nCMDEN), .SDICmdArg(
        CmdArgMuxO), .NoCRCRsp(NoCRCRspMuxO), .LongRsp(LongRspMuxO), .WaitRsp(
        WaitRspMuxO), .CMST(CmdStartMuxO), .CMSTClr(CMSTClr), .CmdIndex(
        CmdIndexMuxO), .RspCrcSet(RspCrcSet), .CmdSentSet(CmdSentSet), 
        .CmdToutSet(CmdToutSet), .RspFinSet(RspFinSet), .CmdOn(CmdOn), 
        .RspIndex(RspIndex), .Response0(Response0), .Response1(Response1), 
        .Response2(Response2), .Response3(Response3), .CmdCtrlIdle(CmdCtrlIdle) );
  mmc_DataControl DataControl ( .nRst(PRESETn), .SDreset(SDreset), .PCLK(PCLK), 
        .neg_CKPulse(neg_CKPulse), .CKPulse(CKPulse), .ByteOrder(SDIDatCon_22_), .SDIDTimer(iDataTimer), .SDIBSize(iBlkSize), .TARSP(SDIDatCon_24_), .RACMD(
        SDIDatCon_23_), .BlkMode(SDIDatCon_21_), .WideBus(SDIDatCon_19_), 
        .MMCPlus(SDIDatCon_20_), .DTST(DTST), .DatMode(DatMode), .BlkNum({
        SDIDatCon_15_, SDIDatCon_14_, SDIDatCon_13_, SDIDatCon_12_, 
        SDIDatCon_11_, SDIDatCon_10_, SDIDatCon_9_, SDIDatCon_8_, SDIDatCon_7_, 
        SDIDatCon_6_, SDIDatCon_5_, SDIDatCon_4_, SDIDatCon_3_, SDIDatCon_2_, 
        SDIDatCon_1_, SDIDatCon_0_}), .BusyRsp(BusyRspMuxO), .AbortCmd(
        AbortCmdMuxO), .BlkNumCnt(BlkNumCnt), .BlkDatCnt(BlkCnt), .NoBusySet(
        NoBusySet), .CrcStaSet(CrcStaSet), .DatCrcSet(DatCrcSet), .DatToutSet(
        DatToutSet), .DatFinSet(DatFinSet), .BusyFinSet(BusyFinSet), .TxDatOn(
        TxDatOn), .RxDatOn(RxDatOn), .DTSTClr(DTSTClr), .RspFinSet(RspFinSet), 
        .CmdSentSet(CmdSentSet), .TxActive(TxActive), .TxRdPtrInc(TxRdPtrInc), 
        .RxActive(RxActive), .RxWriteEn(RxWriteEn), .FIFOWriteData(RxFWrData), 
        .TFREmpty(TFREmpty), .RFFull(RFFull), .FIFOReadData(FRdData), .ENCLK2(
        ENCLK_FIFO), .Inv_nDATEN(MMC_nDATEN), .Inv_DATOUT(MMC_DATOUT), .DATIN(
        DATIN), .BusyChkIdle(BusyChkIdle), .DatCtrlIdle(DatCtrlIdle) );
  AO22X4 U90 ( .A0(TESTMODE), .A1(PCLK), .B0(n401), .B1(n402), .Y(iFBCLK) );
  INVX1 U130 ( .A(n432), .Y(iMMC_FBCLK) );
  OR2X1 U131 ( .A(RxUnderrun), .B(TxOverrun), .Y(n_2) );
  XNOR2X1 U132 ( .A(MMC_FBCLK), .B(InvSel), .Y(n432) );
  INVX1 U133 ( .A(TESTMODE), .Y(n402) );
  NOR2BX1 U134 ( .AN(n427), .B(DelaySel[2]), .Y(n431) );
  OA21X2 U135 ( .A0(n432), .A1(n425), .B0(n433), .Y(n428) );
  AOI32X1 U136 ( .A0(n427), .A1(n425), .A2(MMC_FBCLK_DLY3), .B0(n434), .B1(
        DelaySel[0]), .Y(n433) );
  NOR2BX1 U137 ( .AN(MMC_FBCLK_DLY4), .B(DelaySel[1]), .Y(n434) );
  INVX1 U138 ( .A(DelaySel[1]), .Y(n425) );
  INVX1 U139 ( .A(n426), .Y(n421) );
  NAND3BX1 U140 ( .AN(DelaySel[2]), .B(n427), .C(DelaySel[1]), .Y(n426) );
  INVX1 U141 ( .A(n424), .Y(n422) );
  NAND3BX1 U142 ( .AN(DelaySel[2]), .B(n425), .C(DelaySel[0]), .Y(n424) );
  INVX1 U143 ( .A(DelaySel[0]), .Y(n427) );
  OAI31X1 U144 ( .A0(n420), .A1(n421), .A2(n422), .B0(n423), .Y(n401) );
  OA21X2 U145 ( .A0(n428), .A1(n429), .B0(n430), .Y(n420) );
  AOI22X1 U146 ( .A0(MMC_FBCLK_DLY1), .A1(n421), .B0(MMC_FBCLK_DLY0), .B1(n422), .Y(n423) );
  AOI32X1 U147 ( .A0(MMC_FBCLK_DLY2), .A1(n429), .A2(DelaySel[0]), .B0(n431), 
        .B1(iMMC_FBCLK), .Y(n430) );
  INVX1 U148 ( .A(DelaySel[2]), .Y(n429) );
endmodule


module mmc_DataControl ( nRst, SDreset, PCLK, neg_CKPulse, CKPulse, ByteOrder, 
        SDIDTimer, SDIBSize, TARSP, RACMD, BlkMode, WideBus, MMCPlus, DTST, 
        DatMode, BlkNum, BusyRsp, AbortCmd, BlkNumCnt, BlkDatCnt, NoBusySet, 
        CrcStaSet, DatCrcSet, DatToutSet, DatFinSet, BusyFinSet, TxDatOn, 
        RxDatOn, DTSTClr, RspFinSet, CmdSentSet, TxActive, TxRdPtrInc, 
        RxActive, RxWriteEn, FIFOWriteData, TFREmpty, RFFull, FIFOReadData, 
        ENCLK2, nDATEN, Inv_nDATEN, DATOUT, Inv_DATOUT, DATIN, BusyChkIdle, 
        DatCtrlIdle );
  input [22:0] SDIDTimer;
  input [15:0] SDIBSize;
  input [1:0] DatMode;
  input [15:0] BlkNum;
  output [15:0] BlkNumCnt;
  output [15:0] BlkDatCnt;
  output [31:0] FIFOWriteData;
  input [31:0] FIFOReadData;
  output [7:0] DATOUT;
  output [7:0] Inv_DATOUT;
  input [7:0] DATIN;
  input nRst, SDreset, PCLK, neg_CKPulse, CKPulse, ByteOrder, TARSP, RACMD,
         BlkMode, WideBus, MMCPlus, DTST, BusyRsp, AbortCmd, RspFinSet,
         CmdSentSet, TFREmpty, RFFull;
  output NoBusySet, CrcStaSet, DatCrcSet, DatToutSet, DatFinSet, BusyFinSet,
         TxDatOn, RxDatOn, DTSTClr, TxActive, TxRdPtrInc, RxActive, RxWriteEn,
         ENCLK2, nDATEN, Inv_nDATEN, BusyChkIdle, DatCtrlIdle;
  wire   CRCStatusChk, DATSR_30_, DATSR_29_, DATSR_28_, DATSR_27_, DATSR_26_,
         DATSR_25_, DATSR_24_, DATSR_23_, DATSR_22_, DATSR_21_, DATSR_20_,
         DATSR_19_, DATSR_18_, DATSR_17_, DATSR_16_, DATSR_15_, DATSR_14_,
         DATSR_13_, DATSR_12_, DATSR_11_, DATSR_10_, DATSR_9_, DATSR_8_,
         DATSR_7_, DATSR_6_, DATSR_5_, DATSR_4_, DATSR_3_, DATSR_2_, DATSR_1_,
         DATSR_0_, BlkDatCntEn, LdDataBuffer, TxCRCSend, NibbleCnt, TxCRCCal,
         RxCRCCal, CRCStatusStr, AbortCmdSent, Abort, StopBit, StartBit,
         CRCStatusGet, BusyStatus, TxEmptyDetect, CRCCheck2263, CRCCheck,
         CRCStatusChk2453, StateCnt_31_, StateCnt_30_, StateCnt_29_,
         StateCnt_28_, StateCnt_27_, StateCnt_26_, StateCnt_25_, StateCnt_24_,
         StateCnt_23_, StateCnt_22_, StateCnt_21_, StateCnt_20_, StateCnt_19_,
         StateCnt_18_, StateCnt_17_, StateCnt_16_, StateCnt_15_, StateCnt_14_,
         StateCnt_13_, StateCnt_12_, StateCnt_11_, StateCnt_10_, StateCnt_9_,
         StateCnt_8_, StateCnt_7_, StateCnt_6_, StateCnt_5_, StateCnt_4_,
         StateCnt_3_, StateCnt_2_, StateCnt_1_, StateCnt_0_, BitCnt_2_,
         BitCnt_1_, BitCnt_0_, CRCStatusCnt_2_, CRCStatusCnt_1_,
         CRCStatusCnt_0_, DATSR4385_31_, DATSR4385_30_, DATSR4385_29_,
         DATSR4385_28_, DATSR4385_27_, DATSR4385_26_, DATSR4385_25_,
         DATSR4385_24_, LdDataBuffer4424, BlkDatCnt4671_15_, BlkDatCnt4671_14_,
         BlkDatCnt4671_13_, BlkDatCnt4671_12_, BlkDatCnt4671_11_,
         BlkDatCnt4671_10_, BlkDatCnt4671_9_, BlkDatCnt4671_8_,
         BlkDatCnt4671_7_, BlkDatCnt4671_6_, BlkDatCnt4671_5_,
         BlkDatCnt4671_4_, BlkDatCnt4671_3_, BlkDatCnt4671_2_,
         BlkDatCnt4671_1_, BlkNumCnt4764_15_, BlkNumCnt4764_14_,
         BlkNumCnt4764_13_, BlkNumCnt4764_12_, BlkNumCnt4764_11_,
         BlkNumCnt4764_10_, BlkNumCnt4764_9_, BlkNumCnt4764_8_,
         BlkNumCnt4764_7_, BlkNumCnt4764_6_, BlkNumCnt4764_5_,
         BlkNumCnt4764_4_, BlkNumCnt4764_3_, BlkNumCnt4764_2_,
         BlkNumCnt4764_1_, StateCnt5261_31_, StateCnt5261_30_,
         StateCnt5261_29_, StateCnt5261_28_, StateCnt5261_27_,
         StateCnt5261_26_, StateCnt5261_25_, StateCnt5261_24_,
         StateCnt5261_23_, StateCnt5261_22_, StateCnt5261_21_,
         StateCnt5261_20_, StateCnt5261_19_, StateCnt5261_18_,
         StateCnt5261_17_, StateCnt5261_16_, StateCnt5261_15_,
         StateCnt5261_14_, StateCnt5261_13_, StateCnt5261_12_,
         StateCnt5261_11_, StateCnt5261_10_, StateCnt5261_9_, StateCnt5261_8_,
         StateCnt5261_7_, StateCnt5261_6_, StateCnt5261_5_, StateCnt5261_4_,
         StateCnt5261_3_, StateCnt5261_2_, StateCnt5261_1_, D0CRCSR5426_15_,
         D1CRCSR5432_15_, D2CRCSR5438_15_, D3CRCSR5444_15_, D4CRCSR5450_15_,
         D5CRCSR5456_15_, D6CRCSR5462_15_, D7CRCSR5468_15_, NextBusyCnt6524_4_,
         NextBusyCnt6524_3_, NextBusyCnt6524_2_, NextBusyCnt6524_1_,
         BusyState6570_1_, BusyState6570_0_, NoBusySet6582, BusyFinSet6588,
         n8855, n8856, n8857, n8858, n8859, n8860, n8861, n8862, n8863, n8864,
         n8865, n8866, n8867, n8868, n8869, n8870, n8871, n8872, n8873, n8874,
         n8875, n8876, n8877, n8878, n8879, n8880, n8881, n8882, n8883, n8884,
         n8885, n8886, n8887, n8888, n8889, n8890, n8891, n8892, n8893, n8894,
         n8895, n8896, n8897, n8898, n8899, n8900, n8901, n8902, n8903, n8904,
         n8905, n8906, n8907, n8908, n8909, n8910, n8911, n8912, n8913, n8914,
         n8915, n8916, n8917, n8918, n8919, n8920, n8921, n8922, n8923, n8924,
         n8925, n8926, n8927, n8928, n8929, n8930, n8931, n8932, n8933, n8934,
         n8935, n8936, n8937, n8938, n8939, n8940, n8941, n8942, n8943, n8944,
         n8945, n8946, n8947, n8948, n8949, n8950, n8951, n8952, n8953, n8954,
         n8955, n8956, n8957, n8958, n8959, n8960, n8961, n8962, n8963, n8964,
         n8965, n8966, n8967, n8968, n8969, n8970, n8971, n8972, n8973, n8974,
         n8975, n8976, n8977, n8978, n8979, n8980, n8981, n8982, n8983, n8984,
         n8985, n8986, n8987, n8988, n8989, n8990, n8991, n8992, n8993, n8994,
         n8995, n8996, n8997, n8998, n8999, n9000, n9001, n9002, n9003, n9004,
         n9005, n9006, n9007, n9008, n9009, n9010, n9011, n9012, n9013, n9014,
         n9015, n9016, n9017, n9018, n9019, n9020, n9021, n9022, n9023, n9024,
         n9025, n9026, n9027, n9028, n9029, n9030, n9031, n9032, n9033, n9034,
         n9035, n9036, n9037, n9038, n9039, n9040, n9041, n9042, n9043, n9044,
         n9045, n9046, n9047, n9048, n9049, n9050, n9051, n9052, n9053, n9054,
         n9055, n9056, n9057, n9058, n9059, n9060, n9061, n9062, n9063, n9064,
         n9065, n9066, n9067, n9068, n9069, n9070, n9071, n9072, n9073, n9074,
         n9075, n9076, n9077, n9078, n9079, n9080, n9081, n9082, n9083, n9084,
         n9085, n9086, n9087, n9088, n9089, n9090, n9091, n9092, n9093, n9094,
         n9095, n9096, n9097, n9098, n9099, n9100, n9101, n9102, n9103, n9104,
         n9105, n9106, n9107, n9108, n9109, n9110, n9111, n9112, n9113, n9114,
         n9115, n9116, n9117, n9118, n9119, n9120, n9121, n9122, n9123, n9124,
         n9125, n9126, n9127, n9128, n9129, n9130, n9131, n9132, n9133, n9134,
         n9135, n9136, n9137, n9138, n9139, n9140, n9141, n9142, n9143, n9144,
         n9145, n9146, n9147, n9148, n9149, n9150, n9151, n9152, n9153, n9154,
         n9155, n9156, n9157, n9158, n9159, n9160, n9161, n9162, n9163, n9164,
         n9165, n9166, n9167, n9168, n9169, n9170, n9171, n9172, n9173, n9174,
         n9175, n9176, n9177, n9178, n9179, n9180, n9181, n9182, n9183, n9184,
         n9185, n9186, n9187, n9188, n9189, n9190, n9191, n9192, n9193, n9194,
         carry, carry0, carry1, carry2, carry3, carry4, carry5, carry6, carry7,
         carry8, carry9, carry10, carry11, carry12, carry13, carry14, carry15,
         carry16, carry17, carry18, carry19, carry20, carry21, carry22,
         carry23, carry24, carry25, carry26, carry_31_, carry_30_, carry_29_,
         carry_28_, carry_27_, carry_26_, carry_25_, carry_24_, carry_23_,
         carry_22_, carry_21_, carry_20_, carry_19_, carry_18_, carry_17_,
         carry_16_, carry_15_, carry_14_, carry_13_, carry_12_, carry_11_,
         carry_10_, carry_9_, carry_8_, carry_7_, carry_6_, carry_5_, carry27,
         carry28, carry29, carry_4_, carry_3_, carry_2_, n9225, n9226, n9228,
         n9229, n9230, n9233, n9234, n9235, n9237, n9238, n9239, n9240, n9241,
         n9242, n9243, n9244, n9245, n9246, n9247, n9249, n9250, n9252, n9253,
         n9254, n9256, n9257, n9258, n9259, n9260, n9261, n9263, n9264, n9265,
         n9266, n9267, n9268, n9269, n9270, n9271, n9273, n9274, n9275, n9276,
         n9277, n9279, n9280, n9281, n9284, n9285, n9286, n9287, n9288, n9289,
         n9290, n9291, n9292, n9293, n9294, n9295, n9298, n9299, n9300, n9301,
         n9302, n9303, n9304, n9305, n9306, n9307, n9309, n9310, n9311, n9312,
         n9314, n9315, n9316, n9317, n9318, n9319, n9320, n9321, n9322, n9323,
         n9324, n9325, n9326, n9328, n9329, n9330, n9331, n9332, n9333, n9334,
         n9336, n9337, n9338, n9340, n9341, n9342, n9343, n9344, n9345, n9347,
         n9348, n9349, n9350, n9351, n9352, n9353, n9354, n9355, n9356, n9357,
         n9358, n9359, n9360, n9361, n9362, n9363, n9364, n9366, n9367, n9368,
         n9369, n9370, n9371, n9372, n9373, n9374, n9375, n9376, n9378, n9379,
         n9380, n9381, n9383, n9384, n9385, n9386, n9387, n9388, n9389, n9390,
         n9391, n9392, n9393, n9394, n9395, n9396, n9397, n9399, n9401, n9402,
         n9403, n9404, n9405, n9406, n9407, n9408, n9410, n9411, n9412, n9413,
         n9414, n9416, n9417, n9418, n9419, n9420, n9421, n9422, n9423, n9424,
         n9425, n9426, n9427, n9428, n9429, n9430, n9433, n9436, n9437, n9438,
         n9439, n9440, n9441, n9442, n9443, n9444, n9445, n9446, n9447, n9448,
         n9449, n9450, n9451, n9452, n9453, n9455, n9456, n9457, n9459, n9460,
         n9461, n9462, n9463, n9465, n9466, n9468, n9470, n9471, n9473, n9474,
         n9475, n9476, n9478, n9480, n9481, n9483, n9484, n9485, n9486, n9488,
         n9490, n9491, n9493, n9494, n9495, n9496, n9498, n9500, n9501, n9503,
         n9504, n9505, n9506, n9508, n9510, n9511, n9513, n9514, n9515, n9516,
         n9518, n9520, n9521, n9523, n9524, n9525, n9527, n9529, n9530, n9531,
         n9532, n9533, n9534, n9535, n9538, n9539, n9541, n9542, n9543, n9544,
         n9545, n9546, n9548, n9549, n9550, n9551, n9552, n9553, n9555, n9556,
         n9558, n9561, n9562, n9563, n9564, n9565, n9566, n9567, n9569, n9570,
         n9571, n9572, n9573, n9574, n9575, n9576, n9577, n9578, n9579, n9580,
         n9581, n9582, n9583, n9584, n9586, n9587, n9588, n9589, n9590, n9591,
         n9593, n9594, n9595, n9598, n9599, n9600, n9603, n9604, n9605, n9607,
         n9608, n9610, n9611, n9613, n9614, n9616, n9617, n9619, n9620, n9622,
         n9623, n9625, n9626, n9628, n9629, n9631, n9632, n9634, n9635, n9637,
         n9638, n9640, n9641, n9643, n9644, n9646, n9647, n9649, n9650, n9652,
         n9653, n9654, n9655, n9657, n9659, n9660, n9661, n9662, n9663, n9665,
         n9666, n9667, n9668, n9669, n9670, n9671, n9675, n9676, n9677, n9678,
         n9679, n9680, n9681, n9683, n9686, n9687, n9688, n9689, n9690, n9692,
         n9695, n9696, n9698, n9699, n9700, n9701, n9702, n9703, n9705, n9707,
         n9708, n9709, n9710, n9712, n9713, n9714, n9715, n9716, n9717, n9718,
         n9719, n9720, n9721, n9722, n9723, n9724, n9725, n9726, n9727, n9728,
         n9729, n9730, n9731, n9732, n9733, n9734, n9735, n9736, n9737, n9738,
         n9739, n9742, n9743, n9744, n9745, n9746, n9747, n9748, n9749, n9750,
         n9751, n9752, n9753, n9754, n9755, n9757, n9758, n9759, n9760, n9762,
         n9763, n9764, n9765, n9767, n9768, n9769, n9770, n9771, n9772, n9773,
         n9774, n9775, n9776, n9777, n9778, n9779, n9780, n9781, n9782, n9784,
         n9785, n9787, n9788, n9789, n9792, n9793, n9794, n9795, n9797, n9798,
         n9799, n9800, n9801, n9802, n9803, n9804, n9805, n9806, n9807, n9808,
         n9809, n9810, n9811, n9812, n9813, n9814, n9815, n9816, n9817, n9818,
         n9819, n9821, n9822, n9823, n9824, n9825, n9826, n9827, n9828, n9829,
         n9830, n9831, n9832, n9833, n9834, n9835, n9836, n9837, n9838, n9839,
         n9840, n9841, n9842, n9843, n9844, n9853, n9854, n9855, n9856, n9857,
         n9858, n9859, n9860, n9861, n9862, n9863, n9864, n9865, n9866, n9867,
         n9869, n9870, n9871, n9872, n9873, n9874, n9876, n9877, n9878, n9879,
         n9881, n9882, n9883, n9885, n9887, n9888, n9889, n9891, n9892, n9894,
         n9895, n9897, n9898, n9900, n9901, n9903, n9904, n9906, n9907, n9908,
         n9917, n9918, n9920, n9921, n9922, n9923, n9924, n9926, n9927, n9928,
         n9929, n9930, n9931, n9932, n9933, n9934, n9935, n9938, n9939, n9940,
         n9941, n9942, n9943, n9944, n9960, n9961, n9962, n9963, n9964, n9965,
         n9980, n9981, n9982, n9983, n9985, n9986, n9987, n9988, n9989, n9990,
         n9991, n9992, n9993, n9994, n9995, n9996, n9997, n9998, n9999, n10000,
         n10001, n10002, n10003, n10004, n10005, n10006, n10007, n10008,
         n10009, n10010, n10011, n10012, n10013, n10014, n10016, n10018,
         n10019, n10020, n10021, n10022, n10027, n10030, n10031, n10032,
         n10033, n10034, n10035, n10036, n10037, n10038, n10045, n10046,
         n10047, n10048, n10064, n10076, n10081, n10083, n10089, n10090,
         n10091, n10098, n10102, n10103, n10104, n10106, n10107, n10113,
         n10114, n10120, n10121, n10122, n10123, n10124, n10125, n10126,
         n10127, n10134, n10135, n10136, n10137, n10143, n10144, n10145,
         n10146, n10152, n10153, n10154, n10155, n10161, n10162, n10163,
         n10164, n10165, n10166, n10167, n10168, n10169, n10187, n10198,
         n10199, n10200, n10201, n10202, n10205, n10206, n10207, n10208,
         n10209, n10210, n10211, n10212, n10213, n10214, n10215, n10216,
         n10217, n10218, n10219, n10220, n10221, n10222, n10223, n10224,
         n10225, n10226, n10227, n10228, n10229, n10230, n10231, n10232,
         n10233, n10234, n10235, n10236, n10237, n10238, n10239, n10240,
         n10241, n10242, n10243, n10244, n10245, n10246, n10247, n10248,
         n10249, n10250, n10251, n10252, n10253, n10254, n10255, n10256,
         n10257, n10258, n10259, n10260, n10261, n10262, n10263, n10264,
         n10265, n10266, n10267, n10268, n10269, n10270, n10271, n10272,
         n10273, n10274, n10275, n10276, n10277, n10278, n10279, n10280,
         n10281, n10282, n10283, n10284, n10285, n10286, n10287, n10288,
         n10289, n10290, n10291, n10292, n10293, n10294, n10295, n10296,
         n10297, n10298, n10299, n10300, n10301, n10302, n10303, n10304,
         n10305, n10306, n10307, n10308, n10309, n10310, n10311, n10312,
         n10313, n10314, n10315, n10316, n10317, n10318, n10319, n10320,
         n10321, n10322, n10323, n10324, n10325, n10326, n10327, n10328,
         n10329, n10330, n10331, n10332, n10333, n10334, n10335, n10336,
         n10337, n10338, n10339, n10340, n10341, n10342, n10343, n10344,
         n10345, n10346, n10347, n10348, n10349, n10350, n10351, n10352,
         n10353, n10354, n10355, n10356, n10357, n10358, n10359, n10360,
         n10361, n10362, n10363, n10364, n10365, n10366, n10367, n10368,
         n10369, n10370, n10371, n10372, n10373, n10374, n10375, n10376,
         n10377, n10378, n10379, n10380, n10381, n10382, n10383, n10384,
         n10385, n10386, n10387, n10388, n10389, n10390, n10391, n10392,
         n10393, n10394, n10395, n10396, n10397, n10398, n10399, n10400,
         n10401, n10402, n10403, n10404, n10405, n10406, n10407, n10408,
         n10409, n10410, n10411, n10412, n10413, n10414, n10415, n10416,
         n10417, n10418, n10419, n10420, n10421, n10422, n10423, n10424,
         n10425, n10426, n10427, n10428, n10429, n10430, n10431, n10432,
         n10433, n10434, n10435, n10436, n10437, n10438, n10439, n10440,
         n10441, n10442, n10443, n10444, n10445, n10446, n10447, n10448,
         n10449, n10450, n10451, n10452, n10453, n10455, n10456, n10457,
         n10458, n10459, n10460, n10461, n10462, n10463, n10464, n10465,
         n10466, n10467, n10468, n10469, n10470, n10471, n10472, n10473,
         n10474, n10475;
  wire   [6:0] DATAState;
  wire   [1:0] WORDCnt;
  wire   [15:0] D7CRCSR;
  wire   [15:0] D6CRCSR;
  wire   [15:0] D5CRCSR;
  wire   [15:0] D4CRCSR;
  wire   [15:0] D3CRCSR;
  wire   [15:0] D2CRCSR;
  wire   [15:0] D1CRCSR;
  wire   [15:0] D0CRCSR;
  wire   [1:0] BusyState;
  wire   [4:0] BusyCnt;

  OAI221X1 U5857 ( .A0(NibbleCnt), .A1(n9654), .B0(WideBus), .B1(n9781), .C0(
        n9655), .Y(n9306) );
  AOI21X1 U5858 ( .A0(n9548), .A1(n10339), .B0(n9530), .Y(n10367) );
  INVX1 U5859 ( .A(n9688), .Y(n9700) );
  INVX1 U5860 ( .A(n9823), .Y(n9824) );
  INVX1 U5861 ( .A(n9264), .Y(n9440) );
  INVX1 U5862 ( .A(n10459), .Y(n10461) );
  INVX1 U5863 ( .A(n9456), .Y(n10460) );
  NAND2BX1 U5864 ( .AN(n9555), .B(n9413), .Y(n9683) );
  NAND2BX1 U5865 ( .AN(n9843), .B(n9819), .Y(n9823) );
  NAND2BX1 U5866 ( .AN(n9743), .B(n9692), .Y(n9688) );
  INVX1 U5867 ( .A(n9692), .Y(n9716) );
  INVX1 U5868 ( .A(n9843), .Y(n9798) );
  INVX1 U5869 ( .A(n9713), .Y(n9710) );
  NAND2BX1 U5870 ( .AN(n9555), .B(n9273), .Y(n9264) );
  NAND2X1 U5871 ( .A(n9782), .B(n9687), .Y(n9784) );
  INVX1 U5872 ( .A(n9567), .Y(n9575) );
  INVX1 U5873 ( .A(n9819), .Y(n9826) );
  INVX1 U5874 ( .A(n9565), .Y(n9574) );
  INVX1 U5875 ( .A(n9702), .Y(n9707) );
  OR2X1 U5876 ( .A(n9789), .B(n9784), .Y(n9785) );
  INVX1 U5877 ( .A(n9456), .Y(n9451) );
  NOR2BX1 U5878 ( .AN(n9779), .B(n9927), .Y(LdDataBuffer4424) );
  INVX1 U5879 ( .A(n9257), .Y(n9316) );
  INVX1 U5880 ( .A(n9284), .Y(n9324) );
  INVX1 U5881 ( .A(n9530), .Y(n9535) );
  INVX1 U5882 ( .A(n9677), .Y(n9687) );
  NAND3BX1 U5883 ( .AN(n9742), .B(n9712), .C(n9710), .Y(n9743) );
  NAND2BX1 U5884 ( .AN(n9703), .B(n9707), .Y(n9713) );
  OAI31X1 U5885 ( .A0(n9792), .A1(n9293), .A2(n9555), .B0(n9798), .Y(n9819) );
  OAI211X1 U5886 ( .A0(n9381), .A1(n9844), .B0(n9818), .C0(n9295), .Y(n9843)
         );
  INVX1 U5887 ( .A(n9842), .Y(n9844) );
  AND2X2 U5888 ( .A(n9742), .B(n9710), .Y(n10433) );
  INVX1 U5889 ( .A(n9719), .Y(n9961) );
  OAI31X1 U5890 ( .A0(n9273), .A1(n9555), .A2(n9401), .B0(n9744), .Y(n9692) );
  INVX1 U5891 ( .A(n9743), .Y(n9744) );
  INVX1 U5892 ( .A(n10457), .Y(n9555) );
  NAND2BX1 U5893 ( .AN(n10457), .B(n9413), .Y(n9257) );
  NAND3BX1 U5894 ( .AN(SDreset), .B(n9745), .C(n9696), .Y(n9702) );
  NAND2BX1 U5895 ( .AN(SDreset), .B(n9661), .Y(n9567) );
  NAND2BX1 U5896 ( .AN(n9299), .B(n9352), .Y(n9421) );
  NAND2BX1 U5897 ( .AN(n9686), .B(n9675), .Y(n9678) );
  OR2X1 U5898 ( .A(SDreset), .B(n9657), .Y(n9565) );
  OAI211X1 U5899 ( .A0(n9555), .A1(n9792), .B0(n9687), .C0(n9789), .Y(n9782)
         );
  AOI21X1 U5900 ( .A0(n9556), .A1(n10459), .B0(n9873), .Y(n10434) );
  NAND2BX1 U5901 ( .AN(n9246), .B(n9361), .Y(n9395) );
  NAND2BX1 U5902 ( .AN(SDreset), .B(n9361), .Y(n9390) );
  INVX1 U5903 ( .A(n9561), .Y(n9584) );
  INVX1 U5904 ( .A(n9817), .Y(n9795) );
  NAND3BX1 U5905 ( .AN(n9798), .B(n9295), .C(n9818), .Y(n9817) );
  INVX1 U5906 ( .A(n9815), .Y(n9799) );
  NAND2BX1 U5907 ( .AN(SDreset), .B(n9816), .Y(n9815) );
  INVX1 U5908 ( .A(n9359), .Y(n9413) );
  INVX1 U5909 ( .A(n9822), .Y(n9827) );
  NAND2BX1 U5910 ( .AN(n9583), .B(n9584), .Y(n9570) );
  INVX1 U5911 ( .A(n9562), .Y(n9591) );
  AOI32X1 U5912 ( .A0(n9286), .A1(n9287), .A2(n9288), .B0(n9288), .B1(n9289), 
        .Y(n9285) );
  INVX1 U5913 ( .A(n9343), .Y(n9354) );
  INVX1 U5914 ( .A(n9325), .Y(n9333) );
  INVX1 U5915 ( .A(n9818), .Y(n9816) );
  INVX1 U5916 ( .A(n9340), .Y(n9352) );
  INVX1 U5917 ( .A(n9661), .Y(n9986) );
  INVX1 U5918 ( .A(n9772), .Y(n9769) );
  INVX1 U5919 ( .A(n10468), .Y(n9573) );
  AOI22X1 U5920 ( .A0(n9707), .A1(n9708), .B0(n9709), .B1(n9710), .Y(n10435)
         );
  INVX1 U5921 ( .A(n9856), .Y(n9871) );
  INVX1 U5922 ( .A(n9793), .Y(n9789) );
  NAND2BX1 U5923 ( .AN(n9354), .B(n9311), .Y(n9793) );
  INVX1 U5924 ( .A(n10036), .Y(n10102) );
  NAND2BX1 U5925 ( .AN(n10460), .B(n9463), .Y(n9465) );
  NAND2BX1 U5926 ( .AN(SDreset), .B(n10458), .Y(n9530) );
  NAND2BX1 U5927 ( .AN(n10457), .B(n9295), .Y(n9456) );
  NAND2BX1 U5928 ( .AN(n10457), .B(n9295), .Y(n10458) );
  NAND2BX1 U5929 ( .AN(n9555), .B(n9556), .Y(n9551) );
  AO21X1 U5930 ( .A0(n9358), .A1(n9359), .B0(SDreset), .Y(n9284) );
  NAND2BX1 U5931 ( .AN(n10457), .B(n9295), .Y(n10459) );
  NAND3BX1 U5932 ( .AN(SDreset), .B(n9299), .C(n9961), .Y(n9927) );
  AO21X1 U5933 ( .A0(n9372), .A1(n9359), .B0(SDreset), .Y(n9310) );
  NOR3BX1 U5934 ( .AN(n9343), .B(n9332), .C(SDreset), .Y(n9342) );
  NAND2BX1 U5935 ( .AN(SDreset), .B(n9413), .Y(n9246) );
  BUFX2 U5936 ( .A(n9453), .Y(n10474) );
  BUFX2 U5937 ( .A(n9453), .Y(n10475) );
  BUFX2 U5938 ( .A(n9453), .Y(n10473) );
  INVX1 U5939 ( .A(n9305), .Y(n9273) );
  INVX1 U5940 ( .A(n9370), .Y(DatCtrlIdle) );
  INVX1 U5941 ( .A(n9361), .Y(n9393) );
  INVX1 U5942 ( .A(n9550), .Y(n9695) );
  INVX1 U5943 ( .A(n9241), .Y(n9332) );
  AO21X1 U5944 ( .A0(n9401), .A1(n9287), .B0(n9752), .Y(n9331) );
  INVX1 U5945 ( .A(n10019), .Y(n10018) );
  NAND2BX1 U5946 ( .AN(SDreset), .B(n10020), .Y(n10019) );
  INVX1 U5947 ( .A(n9792), .Y(n9351) );
  INVX1 U5948 ( .A(n9372), .Y(n9748) );
  AOI21X1 U5949 ( .A0(n9254), .A1(n9359), .B0(SDreset), .Y(n10436) );
  INVX1 U5950 ( .A(n9270), .Y(n9386) );
  INVX1 U5951 ( .A(n9696), .Y(n9446) );
  INVX1 U5952 ( .A(n9363), .Y(n9423) );
  INVX1 U5953 ( .A(CmdSentSet), .Y(n9450) );
  DFFRX1 TxCRCCal_reg ( .D(n9181), .CK(PCLK), .RN(nRst), .Q(TxCRCCal), .QN(
        n10324) );
  NAND2BX1 U5954 ( .AN(SDreset), .B(n9370), .Y(n9677) );
  INVX3 U5955 ( .A(SDreset), .Y(n9295) );
  INVX1 U5956 ( .A(n9299), .Y(n9383) );
  NAND2BX1 U5957 ( .AN(n9901), .B(n9748), .Y(TxDatOn) );
  INVX1 U5958 ( .A(n9928), .Y(n9779) );
  INVX1 U5959 ( .A(n9230), .Y(n9225) );
  INVX1 U5960 ( .A(n9908), .Y(n9917) );
  INVX1 U5961 ( .A(n9920), .Y(RxDatOn) );
  INVX1 U5962 ( .A(n9429), .Y(n9433) );
  INVX1 U5963 ( .A(n9931), .Y(n9428) );
  INVX1 U5964 ( .A(n10016), .Y(n9933) );
  NAND2BX1 U5965 ( .AN(n10448), .B(n10449), .Y(n10016) );
  INVX1 U5966 ( .A(n9930), .Y(n9929) );
  NOR2BX1 U5967 ( .AN(n9842), .B(n9408), .Y(DatFinSet) );
  NAND3BX1 U5968 ( .AN(n9683), .B(n10325), .C(n9376), .Y(n9719) );
  NAND2X1 U5969 ( .A(n9750), .B(n9676), .Y(n9842) );
  OAI211X1 U5970 ( .A0(n10345), .A1(n10276), .B0(n9931), .C0(n9932), .Y(n9920)
         );
  OAI211X1 U5971 ( .A0(n9381), .A1(n9750), .B0(n9304), .C0(n9318), .Y(n9742)
         );
  OAI211X1 U5972 ( .A0(n9391), .A1(n9392), .B0(n9444), .C0(n9676), .Y(n9703)
         );
  BUFX2 U5973 ( .A(CKPulse), .Y(n10457) );
  INVX1 U5974 ( .A(n9366), .Y(n9293) );
  INVX1 U5975 ( .A(n10027), .Y(n9932) );
  NAND4BX1 U5976 ( .AN(n9427), .B(n10446), .C(n10208), .D(n10238), .Y(n10027)
         );
  INVX1 U5977 ( .A(n9427), .Y(n9379) );
  INVX1 U5978 ( .A(n9436), .Y(n9900) );
  NAND3BX1 U5979 ( .AN(n9418), .B(n9419), .C(n9420), .Y(n9361) );
  AND4X1 U5980 ( .A(n9343), .B(n10208), .C(n9325), .D(n9421), .Y(n9420) );
  OAI33X1 U5981 ( .A0(n9249), .A1(n9441), .A2(n9271), .B0(n9340), .B1(n9305), 
        .B2(n9366), .Y(n9418) );
  AND4X1 U5982 ( .A(n9422), .B(n10436), .C(n9423), .D(n9424), .Y(n9419) );
  NAND4BX1 U5983 ( .AN(n9555), .B(n9794), .C(n9366), .D(n9368), .Y(n9343) );
  OR2X1 U5984 ( .A(DatCrcSet), .B(CrcStaSet), .Y(n9359) );
  NAND2BX1 U5985 ( .AN(n9397), .B(n9257), .Y(n9325) );
  NAND2BX1 U5986 ( .AN(n9311), .B(n9918), .Y(n9657) );
  NAND3BX1 U5987 ( .AN(n9552), .B(n9311), .C(n9567), .Y(n9561) );
  NAND2BX1 U5988 ( .AN(n9371), .B(DatCtrlIdle), .Y(n9818) );
  NAND3BX1 U5989 ( .AN(n10387), .B(n10457), .C(n9311), .Y(n9989) );
  NAND2BX1 U5990 ( .AN(n9402), .B(n9443), .Y(n9696) );
  OR2X1 U5991 ( .A(SDreset), .B(n9659), .Y(n9562) );
  AO21X1 U5992 ( .A0(n10457), .A1(n9417), .B0(n9686), .Y(n9675) );
  NAND2BX1 U5993 ( .AN(n9412), .B(n9257), .Y(n9340) );
  NAND2BX1 U5994 ( .AN(n9660), .B(n9584), .Y(n10468) );
  AO21X1 U5995 ( .A0(n9311), .A1(n10387), .B0(n9555), .Y(n9661) );
  NAND2BX1 U5996 ( .AN(n9660), .B(n9584), .Y(n9582) );
  OAI32X1 U5997 ( .A0(n9279), .A1(n9280), .A2(n9246), .B0(n9281), .B1(n10456), 
        .Y(n9187) );
  NAND2BX1 U5998 ( .AN(n10324), .B(n9273), .Y(n9280) );
  INVX1 U5999 ( .A(n9281), .Y(n9279) );
  NAND2BX1 U6000 ( .AN(n9284), .B(n9285), .Y(n9281) );
  NAND2BX1 U6001 ( .AN(n9866), .B(n9556), .Y(n9856) );
  AO21X1 U6002 ( .A0(n9333), .A1(n9357), .B0(n9284), .Y(n9336) );
  AO21X1 U6003 ( .A0(n9443), .A1(n9383), .B0(n9904), .Y(n9864) );
  OAI31X1 U6004 ( .A0(n9751), .A1(n9305), .A2(n9356), .B0(n9295), .Y(n9904) );
  NAND2BX1 U6005 ( .AN(n9655), .B(n9584), .Y(n10470) );
  NAND2BX1 U6006 ( .AN(n9655), .B(n9584), .Y(n10469) );
  NAND2BX1 U6007 ( .AN(n9654), .B(n9584), .Y(n10472) );
  NAND2BX1 U6008 ( .AN(n9654), .B(n9584), .Y(n10471) );
  OAI221X1 U6009 ( .A0(n9816), .A1(n9408), .B0(n9816), .B1(n9842), .C0(n9295), 
        .Y(n9822) );
  OR4X1 U6010 ( .A(n10038), .B(n10437), .C(n10438), .D(n10439), .Y(n10037) );
  NAND4X1 U6011 ( .A(n10212), .B(n10242), .C(n10292), .D(n10352), .Y(n10437)
         );
  NAND4X1 U6012 ( .A(n10045), .B(n10046), .C(n10047), .D(n10048), .Y(n10438)
         );
  NAND4X1 U6013 ( .A(n10209), .B(n10295), .C(n10245), .D(n10351), .Y(n10439)
         );
  NAND2BX1 U6014 ( .AN(n9655), .B(n9584), .Y(n9589) );
  NAND2BX1 U6015 ( .AN(n9654), .B(n9584), .Y(n9590) );
  OR4X1 U6016 ( .A(n10120), .B(n10121), .C(n10122), .D(n10123), .Y(n10036) );
  OR4X1 U6017 ( .A(n10152), .B(n10153), .C(n10154), .D(n10155), .Y(n10120) );
  OR4X1 U6018 ( .A(n10143), .B(n10144), .C(n10145), .D(n10146), .Y(n10121) );
  OR4X1 U6019 ( .A(n10134), .B(n10135), .C(n10136), .D(n10137), .Y(n10122) );
  OR4X1 U6020 ( .A(n10064), .B(n10440), .C(n10441), .D(n10442), .Y(n10038) );
  NAND4X1 U6021 ( .A(n10244), .B(n10349), .C(n10294), .D(n10214), .Y(n10440)
         );
  NAND4X1 U6022 ( .A(n10243), .B(n10350), .C(n10293), .D(n10213), .Y(n10441)
         );
  NAND4X1 U6023 ( .A(n10291), .B(n10348), .C(n10240), .D(n10210), .Y(n10442)
         );
  NOR2BX1 U6024 ( .AN(n9867), .B(SDreset), .Y(DATSR4385_24_) );
  NOR2BX1 U6025 ( .AN(n9874), .B(SDreset), .Y(DATSR4385_25_) );
  NOR2BX1 U6026 ( .AN(n9879), .B(SDreset), .Y(DATSR4385_26_) );
  NOR2BX1 U6027 ( .AN(n9883), .B(SDreset), .Y(DATSR4385_27_) );
  NOR2BX1 U6028 ( .AN(n9887), .B(SDreset), .Y(DATSR4385_28_) );
  NOR2BX1 U6029 ( .AN(n9872), .B(SDreset), .Y(DATSR4385_29_) );
  NOR2BX1 U6030 ( .AN(n9878), .B(SDreset), .Y(DATSR4385_30_) );
  NOR2BX1 U6031 ( .AN(n9859), .B(SDreset), .Y(DATSR4385_31_) );
  AO21X1 U6032 ( .A0(n9903), .A1(n9456), .B0(n9864), .Y(n9873) );
  INVX1 U6033 ( .A(n9767), .Y(n9903) );
  AOI31X1 U6034 ( .A0(n9273), .A1(n9254), .A2(n9257), .B0(n9425), .Y(n9424) );
  OAI32X1 U6035 ( .A0(n9264), .A1(n9293), .A2(n9367), .B0(n9426), .B1(n9427), 
        .Y(n9425) );
  INVX1 U6036 ( .A(n9380), .Y(n9426) );
  OAI31X1 U6037 ( .A0(n9359), .A1(n9250), .A2(n9249), .B0(n9242), .Y(n9708) );
  OAI211X1 U6038 ( .A0(n9258), .A1(n9683), .B0(n9687), .C0(n9676), .Y(n9686)
         );
  INVX1 U6039 ( .A(n9749), .Y(n9709) );
  INVX1 U6040 ( .A(n9312), .Y(n9311) );
  OAI222X1 U6041 ( .A0(n10450), .A1(n9366), .B0(n9367), .B1(n9368), .C0(n9369), 
        .C1(n9370), .Y(n9364) );
  INVX1 U6042 ( .A(n9371), .Y(n9369) );
  OR2X1 U6043 ( .A(n9397), .B(n9683), .Y(n9772) );
  OAI221X1 U6044 ( .A0(n9853), .A1(n9854), .B0(n9855), .B1(n9856), .C0(n9857), 
        .Y(n8937) );
  INVX1 U6045 ( .A(n9867), .Y(n9853) );
  AOI31X1 U6046 ( .A0(n9583), .A1(n9858), .A2(n9859), .B0(n9860), .Y(n9857) );
  INVX1 U6047 ( .A(n9866), .Y(n9858) );
  OAI32X1 U6048 ( .A0(n9390), .A1(n9391), .A2(n9392), .B0(n10450), .B1(n9361), 
        .Y(n9177) );
  OAI32X1 U6049 ( .A0(n9390), .A1(n9389), .A2(n9414), .B0(n10446), .B1(n9361), 
        .Y(n9172) );
  NAND2BX1 U6050 ( .AN(n9381), .B(n9254), .Y(n9414) );
  INVX1 U6051 ( .A(n9751), .Y(n9443) );
  OAI221X1 U6052 ( .A0(n9368), .A1(n9561), .B0(n9562), .B1(n9563), .C0(n9564), 
        .Y(n9046) );
  OA22X1 U6053 ( .A0(n9565), .A1(n9566), .B0(n9567), .B1(n10336), .Y(n9564) );
  OAI211X1 U6054 ( .A0(n9368), .A1(n9417), .B0(n9939), .C0(n9440), .Y(n9250)
         );
  OA21X2 U6055 ( .A0(n9368), .A1(n10392), .B0(n10322), .Y(n9939) );
  OAI221X1 U6056 ( .A0(n10458), .A1(n10418), .B0(n9861), .B1(n9862), .C0(n9863), .Y(n9860) );
  INVX1 U6057 ( .A(n9865), .Y(n9861) );
  INVX1 U6058 ( .A(n9864), .Y(n9863) );
  OAI211X1 U6059 ( .A0(n10422), .A1(n10459), .B0(n10434), .C0(n9894), .Y(n8930) );
  OA22X1 U6060 ( .A0(n9895), .A1(n9854), .B0(n10240), .B1(n9862), .Y(n9894) );
  INVX1 U6061 ( .A(n9859), .Y(n9895) );
  OAI211X1 U6062 ( .A0(n10458), .A1(n10420), .B0(n10434), .C0(n9888), .Y(n8932) );
  OA22X1 U6063 ( .A0(n9889), .A1(n9854), .B0(n10222), .B1(n9862), .Y(n9888) );
  INVX1 U6064 ( .A(n9872), .Y(n9889) );
  OAI211X1 U6065 ( .A0(n10459), .A1(n10419), .B0(n10434), .C0(n9891), .Y(n8931) );
  OA22X1 U6066 ( .A0(n9892), .A1(n9854), .B0(n10241), .B1(n9862), .Y(n9891) );
  INVX1 U6067 ( .A(n9878), .Y(n9892) );
  OAI211X1 U6068 ( .A0(n10459), .A1(n10421), .B0(n10434), .C0(n9885), .Y(n8933) );
  OA22X1 U6069 ( .A0(n9855), .A1(n9854), .B0(n10223), .B1(n9862), .Y(n9885) );
  INVX1 U6070 ( .A(n9732), .Y(n9745) );
  INVX1 U6071 ( .A(n9298), .Y(n9288) );
  INVX1 U6072 ( .A(n9323), .Y(n9897) );
  INVX1 U6073 ( .A(n9309), .Y(n9422) );
  INVX1 U6074 ( .A(n9758), .Y(n9759) );
  INVX1 U6075 ( .A(n9747), .Y(n9712) );
  OAI211X1 U6076 ( .A0(n9413), .A1(n9748), .B0(n9241), .C0(n9749), .Y(n9747)
         );
  INVX1 U6077 ( .A(n9887), .Y(n9855) );
  NAND2BX1 U6078 ( .AN(n9412), .B(n9359), .Y(n9241) );
  NAND2BX1 U6079 ( .AN(n10161), .B(n10389), .Y(n9305) );
  OR2X1 U6080 ( .A(n10208), .B(n9384), .Y(n9370) );
  INVX1 U6081 ( .A(n9665), .Y(n9663) );
  NAND3BX1 U6082 ( .AN(SDreset), .B(n9666), .C(n9667), .Y(n9665) );
  NAND2BX1 U6083 ( .AN(SDreset), .B(n9732), .Y(n9550) );
  NAND2BX1 U6084 ( .AN(n9254), .B(n9397), .Y(n9372) );
  NAND2BX1 U6085 ( .AN(n10387), .B(n9306), .Y(n9792) );
  AO21X1 U6086 ( .A0(n10393), .A1(n10324), .B0(n9331), .Y(n9405) );
  NAND2BX1 U6087 ( .AN(n10322), .B(n9273), .Y(n9270) );
  NAND2BX1 U6088 ( .AN(n9233), .B(n9351), .Y(n9928) );
  NAND2BX1 U6089 ( .AN(n9552), .B(n9755), .Y(n9757) );
  OAI31X1 U6090 ( .A0(n9229), .A1(n9767), .A2(n9555), .B0(n9765), .Y(n9755) );
  INVX1 U6091 ( .A(n9529), .Y(n9453) );
  NAND2BX1 U6092 ( .AN(n9530), .B(n9531), .Y(n9529) );
  INVX1 U6093 ( .A(n9531), .Y(n9548) );
  OAI221X1 U6094 ( .A0(n9433), .A1(n10450), .B0(n10449), .B1(n10448), .C0(
        n9241), .Y(n9363) );
  INVX1 U6095 ( .A(n9249), .Y(n9254) );
  NOR2BX1 U6096 ( .AN(n9865), .B(SDreset), .Y(D0CRCSR5426_15_) );
  NOR2BX1 U6097 ( .AN(n10457), .B(n9259), .Y(n9253) );
  INVX1 U6098 ( .A(n9412), .Y(n9376) );
  INVX1 U6099 ( .A(n9355), .Y(n9287) );
  INVX1 U6100 ( .A(n9667), .Y(n9662) );
  NOR2X1 U6101 ( .A(n9341), .B(n9927), .Y(CRCCheck2263) );
  AND4X1 U6102 ( .A(n10166), .B(n10167), .C(n10168), .D(n10169), .Y(n10165) );
  AND4X1 U6103 ( .A(n10313), .B(n10377), .C(n10256), .D(n10226), .Y(n10166) );
  AND4X1 U6104 ( .A(n10312), .B(n10376), .C(n10221), .D(n10255), .Y(n10167) );
  AND4X1 U6105 ( .A(n10378), .B(n10219), .C(n10308), .D(n10251), .Y(n10168) );
  INVX1 U6106 ( .A(n9367), .Y(n9794) );
  NOR2X1 U6107 ( .A(n9310), .B(n9309), .Y(n9300) );
  INVX1 U6108 ( .A(n9271), .Y(n9923) );
  INVX1 U6109 ( .A(n9242), .Y(n9239) );
  OAI32X1 U6110 ( .A0(n9334), .A1(n10391), .A2(n9246), .B0(n10324), .B1(n9336), 
        .Y(n9181) );
  INVX1 U6111 ( .A(n9336), .Y(n9334) );
  OAI32X1 U6112 ( .A0(n9244), .A1(n9245), .A2(n9246), .B0(n9247), .B1(n10339), 
        .Y(n9189) );
  INVX1 U6113 ( .A(n9247), .Y(n9244) );
  OAI211X1 U6114 ( .A0(n9249), .A1(n9250), .B0(n10436), .C0(n9252), .Y(n9247)
         );
  AOI32X1 U6115 ( .A0(n9253), .A1(n9254), .A2(n10452), .B0(n9256), .B1(n9257), 
        .Y(n9252) );
  OAI32X1 U6116 ( .A0(n9260), .A1(n9261), .A2(n9246), .B0(n10392), .B1(n9263), 
        .Y(n9188) );
  INVX1 U6117 ( .A(n9263), .Y(n9260) );
  OAI211X1 U6118 ( .A0(n9264), .A1(n9265), .B0(n9266), .C0(n10436), .Y(n9263)
         );
  NAND3BX1 U6119 ( .AN(n9274), .B(n9275), .C(n9254), .Y(n9265) );
  INVX1 U6120 ( .A(n9306), .Y(n9401) );
  INVX1 U6121 ( .A(n9307), .Y(n9752) );
  INVX1 U6122 ( .A(n10022), .Y(n10020) );
  NAND2BX1 U6123 ( .AN(n9555), .B(n9531), .Y(n10022) );
  NAND2BX1 U6124 ( .AN(n10393), .B(n9273), .Y(n9299) );
  OAI31X1 U6125 ( .A0(n9355), .A1(n9401), .A2(n10324), .B0(n9402), .Y(n9289)
         );
  OAI211X1 U6126 ( .A0(n9428), .A1(n10446), .B0(n9429), .C0(n9430), .Y(n9380)
         );
  OA22X1 U6127 ( .A0(n10445), .A1(n10238), .B0(n10345), .B1(n10276), .Y(n9430)
         );
  NOR3BX1 U6128 ( .AN(n9295), .B(n9271), .C(n10199), .Y(BusyFinSet6588) );
  INVX1 U6129 ( .A(n9654), .Y(n9556) );
  NOR2X1 U6130 ( .A(n10443), .B(n9683), .Y(CRCStatusChk2453) );
  NAND4X1 U6131 ( .A(n9277), .B(n9295), .C(n9254), .D(n10452), .Y(n10443) );
  INVX1 U6132 ( .A(n9408), .Y(n9381) );
  INVX1 U6133 ( .A(n9417), .Y(n9388) );
  INVX1 U6134 ( .A(n9259), .Y(n9277) );
  INVX1 U6135 ( .A(n9397), .Y(n9358) );
  INVX1 U6136 ( .A(n9660), .Y(n9583) );
  NAND2BX1 U6137 ( .AN(n9355), .B(n9351), .Y(n9718) );
  INVX1 U6138 ( .A(n9402), .Y(n9780) );
  INVX1 U6139 ( .A(n9258), .Y(n9256) );
  INVX1 U6140 ( .A(n9546), .Y(n9542) );
  AOI33X1 U6141 ( .A0(n9376), .A1(n10325), .A2(n9378), .B0(n9379), .B1(n10208), 
        .B2(n9380), .Y(n9375) );
  AO21X1 U6142 ( .A0(n9381), .A1(n10387), .B0(n9383), .Y(n9378) );
  INVX1 U6143 ( .A(n9261), .Y(n9274) );
  INVX1 U6144 ( .A(n9245), .Y(n9319) );
  INVX1 U6145 ( .A(n9438), .Y(n9901) );
  INVX1 U6146 ( .A(n9243), .Y(n9240) );
  AOI22X1 U6147 ( .A0(n9900), .A1(n10208), .B0(n9901), .B1(n9366), .Y(n10444)
         );
  NAND2BX1 U6148 ( .AN(SDreset), .B(TFREmpty), .Y(n9230) );
  NAND3BX1 U6149 ( .AN(n9917), .B(n9295), .C(n9918), .Y(n10465) );
  NAND3BX1 U6150 ( .AN(n9917), .B(n9295), .C(n9918), .Y(n10464) );
  NAND3BX1 U6151 ( .AN(n9917), .B(n9295), .C(n9918), .Y(n9906) );
  OAI31X1 U6152 ( .A0(n10263), .A1(n10330), .A2(n10398), .B0(n9295), .Y(n10462) );
  OAI31X1 U6153 ( .A0(n10263), .A1(n10330), .A2(n10398), .B0(n9295), .Y(n9908)
         );
  OAI31X1 U6154 ( .A0(n10263), .A1(n10330), .A2(n10398), .B0(n9295), .Y(n10463) );
  INVX1 U6155 ( .A(neg_CKPulse), .Y(n9558) );
  INVX1 U6156 ( .A(n9461), .Y(n9463) );
  AND4X1 U6157 ( .A(n10208), .B(n9295), .C(n10238), .D(n10448), .Y(n9294) );
  INVX1 U6158 ( .A(n9781), .Y(n9229) );
  OAI211X1 U6159 ( .A0(n9542), .A1(n9543), .B0(n10339), .C0(n10456), .Y(n9539)
         );
  INVX1 U6160 ( .A(n9552), .Y(n9765) );
  INVX1 U6161 ( .A(n9233), .Y(n9228) );
  INVX1 U6162 ( .A(n9356), .Y(n9286) );
  OAI31X1 U6163 ( .A0(n9370), .A1(DatMode[1]), .A2(n9980), .B0(n9818), .Y(
        DTSTClr) );
  AO21X1 U6164 ( .A0(n9938), .A1(n9386), .B0(n9708), .Y(DatToutSet) );
  INVX1 U6165 ( .A(n9940), .Y(n9938) );
  NAND2BX1 U6166 ( .AN(MMCPlus), .B(WideBus), .Y(n9654) );
  NAND2BX1 U6167 ( .AN(DATAState[4]), .B(n10276), .Y(n9931) );
  NAND2BX1 U6168 ( .AN(WideBus), .B(n9655), .Y(n9767) );
  NAND2BX1 U6169 ( .AN(DATAState[3]), .B(n10445), .Y(n9429) );
  OAI31X1 U6170 ( .A0(n9933), .A1(n10447), .A2(n9900), .B0(n9934), .Y(n9930)
         );
  NOR3BX1 U6171 ( .AN(n9935), .B(n9293), .C(DATAState[0]), .Y(n9934) );
  OAI222X1 U6172 ( .A0(n10239), .A1(n9655), .B0(n10453), .B1(n9767), .C0(
        n10284), .C1(n9654), .Y(n9935) );
  OAI2BB2X1 U6173 ( .A0N(n9930), .A1N(n9920), .B0(RFFull), .B1(n9929), .Y(
        ENCLK2) );
  INVX1 U6174 ( .A(MMCPlus), .Y(n9655) );
  AND2X2 U6175 ( .A(n10446), .B(n9428), .Y(n10445) );
  AND3X2 U6176 ( .A(n10448), .B(DATAState[1]), .C(n9433), .Y(n10447) );
  AND2X2 U6177 ( .A(n10450), .B(n9433), .Y(n10449) );
  NAND4BX1 U6178 ( .AN(n9962), .B(n9963), .C(n9964), .D(n9965), .Y(n9366) );
  NAND4BX1 U6179 ( .AN(BlkDatCnt[9]), .B(n10341), .C(n10277), .D(n10234), .Y(
        n9962) );
  AND4X1 U6180 ( .A(n10236), .B(n10278), .C(n10342), .D(n10206), .Y(n9963) );
  AND4X1 U6181 ( .A(n10205), .B(n10344), .C(n10235), .D(n10280), .Y(n9964) );
  NAND4BX1 U6182 ( .AN(n9931), .B(DATAState[6]), .C(n9379), .D(n10238), .Y(
        n9436) );
  NAND4BX1 U6183 ( .AN(BlkDatCntEn), .B(n9293), .C(n9287), .D(n9961), .Y(n9750) );
  NAND3BX1 U6184 ( .AN(n9683), .B(DATIN[0]), .C(n9254), .Y(n9940) );
  NAND2BX1 U6185 ( .AN(DATAState[1]), .B(n10448), .Y(n9427) );
  AO22X1 U6186 ( .A0(StateCnt_31_), .A1(n9716), .B0(StateCnt5261_31_), .B1(
        n9700), .Y(n8983) );
  XNOR2X1 U1_A_311 ( .A(StateCnt_31_), .B(carry_31_), .Y(StateCnt5261_31_) );
  OR2X1 U1_B_30 ( .A(StateCnt_30_), .B(carry_30_), .Y(carry_31_) );
  INVX1 U6187 ( .A(n9983), .Y(n9391) );
  NAND2BX1 U6188 ( .AN(RspFinSet), .B(TARSP), .Y(n9983) );
  AND4X1 U6189 ( .A(n10343), .B(n10237), .C(n10279), .D(n10207), .Y(n9965) );
  OR2X1 U1_B_11 ( .A(StateCnt_1_), .B(StateCnt_0_), .Y(carry29) );
  OR2X1 U1_B_16 ( .A(StateCnt_16_), .B(carry_16_), .Y(carry_17_) );
  OR2X1 U1_B_17 ( .A(StateCnt_17_), .B(carry_17_), .Y(carry_18_) );
  OR2X1 U1_B_18 ( .A(StateCnt_18_), .B(carry_18_), .Y(carry_19_) );
  OR2X1 U1_B_19 ( .A(StateCnt_19_), .B(carry_19_), .Y(carry_20_) );
  OR2X1 U1_B_20 ( .A(StateCnt_20_), .B(carry_20_), .Y(carry_21_) );
  OR2X1 U1_B_211 ( .A(StateCnt_21_), .B(carry_21_), .Y(carry_22_) );
  OR2X1 U1_B_22 ( .A(StateCnt_22_), .B(carry_22_), .Y(carry_23_) );
  OR2X1 U1_B_24 ( .A(StateCnt_24_), .B(carry_24_), .Y(carry_25_) );
  OR2X1 U1_B_25 ( .A(StateCnt_25_), .B(carry_25_), .Y(carry_26_) );
  OR2X1 U1_B_26 ( .A(StateCnt_26_), .B(carry_26_), .Y(carry_27_) );
  OR2X1 U1_B_27 ( .A(StateCnt_27_), .B(carry_27_), .Y(carry_28_) );
  OR2X1 U1_B_28 ( .A(StateCnt_28_), .B(carry_28_), .Y(carry_29_) );
  OR2X1 U1_B_29 ( .A(StateCnt_29_), .B(carry_29_), .Y(carry_30_) );
  OR2X1 U1_B_4 ( .A(StateCnt_4_), .B(carry27), .Y(carry_5_) );
  OR2X1 U1_B_5 ( .A(StateCnt_5_), .B(carry_5_), .Y(carry_6_) );
  OR2X1 U1_B_6 ( .A(StateCnt_6_), .B(carry_6_), .Y(carry_7_) );
  OR2X1 U1_B_7 ( .A(StateCnt_7_), .B(carry_7_), .Y(carry_8_) );
  OR2X1 U1_B_8 ( .A(StateCnt_8_), .B(carry_8_), .Y(carry_9_) );
  OR2X1 U1_B_9 ( .A(StateCnt_9_), .B(carry_9_), .Y(carry_10_) );
  OR2X1 U1_B_10 ( .A(StateCnt_10_), .B(carry_10_), .Y(carry_11_) );
  OR2X1 U1_B_111 ( .A(StateCnt_11_), .B(carry_11_), .Y(carry_12_) );
  OR2X1 U1_B_12 ( .A(StateCnt_12_), .B(carry_12_), .Y(carry_13_) );
  OR2X1 U1_B_13 ( .A(StateCnt_13_), .B(carry_13_), .Y(carry_14_) );
  OR2X1 U1_B_14 ( .A(StateCnt_14_), .B(carry_14_), .Y(carry_15_) );
  OR2X1 U1_B_15 ( .A(StateCnt_15_), .B(carry_15_), .Y(carry_16_) );
  OR2X1 U1_B_21 ( .A(StateCnt_2_), .B(carry29), .Y(carry28) );
  OR2X1 U1_B_31 ( .A(StateCnt_3_), .B(carry28), .Y(carry27) );
  OR2X1 U1_B_23 ( .A(StateCnt_23_), .B(carry_23_), .Y(carry_24_) );
  OAI222X1 U6190 ( .A0(n9819), .A1(n10205), .B0(n9821), .B1(n9822), .C0(
        BlkDatCnt[0]), .C1(n9823), .Y(n8961) );
  INVX1 U6191 ( .A(SDIBSize[0]), .Y(n9821) );
  OAI2BB1X1 U6192 ( .A0N(StateCnt5261_15_), .A1N(n9700), .B0(n9731), .Y(n8999)
         );
  XNOR2X1 U1_A_15 ( .A(StateCnt_15_), .B(carry_15_), .Y(StateCnt5261_15_) );
  AOI222X1 U6193 ( .A0(StateCnt_15_), .A1(n9716), .B0(SDIBSize[15]), .B1(n9695), .C0(SDIDTimer[15]), .C1(n10433), .Y(n9731) );
  OAI2BB1X1 U6194 ( .A0N(StateCnt5261_14_), .A1N(n9700), .B0(n9730), .Y(n9000)
         );
  XNOR2X1 U1_A_14 ( .A(StateCnt_14_), .B(carry_14_), .Y(StateCnt5261_14_) );
  AOI222X1 U6195 ( .A0(StateCnt_14_), .A1(n9716), .B0(SDIBSize[14]), .B1(n9695), .C0(SDIDTimer[14]), .C1(n10433), .Y(n9730) );
  OAI2BB1X1 U6196 ( .A0N(StateCnt5261_13_), .A1N(n9700), .B0(n9729), .Y(n9001)
         );
  XNOR2X1 U1_A_13 ( .A(StateCnt_13_), .B(carry_13_), .Y(StateCnt5261_13_) );
  AOI222X1 U6197 ( .A0(StateCnt_13_), .A1(n9716), .B0(SDIBSize[13]), .B1(n9695), .C0(SDIDTimer[13]), .C1(n10433), .Y(n9729) );
  OAI2BB1X1 U6198 ( .A0N(StateCnt5261_12_), .A1N(n9700), .B0(n9728), .Y(n9002)
         );
  XNOR2X1 U1_A_12 ( .A(StateCnt_12_), .B(carry_12_), .Y(StateCnt5261_12_) );
  AOI222X1 U6199 ( .A0(StateCnt_12_), .A1(n9716), .B0(SDIBSize[12]), .B1(n9695), .C0(SDIDTimer[12]), .C1(n10433), .Y(n9728) );
  OAI2BB1X1 U6200 ( .A0N(StateCnt5261_11_), .A1N(n9700), .B0(n9727), .Y(n9003)
         );
  XNOR2X1 U1_A_111 ( .A(StateCnt_11_), .B(carry_11_), .Y(StateCnt5261_11_) );
  AOI222X1 U6201 ( .A0(StateCnt_11_), .A1(n9716), .B0(SDIBSize[11]), .B1(n9695), .C0(SDIDTimer[11]), .C1(n10433), .Y(n9727) );
  OAI2BB1X1 U6202 ( .A0N(StateCnt5261_10_), .A1N(n9700), .B0(n9726), .Y(n9004)
         );
  XNOR2X1 U1_A_10 ( .A(StateCnt_10_), .B(carry_10_), .Y(StateCnt5261_10_) );
  AOI222X1 U6203 ( .A0(StateCnt_10_), .A1(n9716), .B0(SDIBSize[10]), .B1(n9695), .C0(SDIDTimer[10]), .C1(n10433), .Y(n9726) );
  OAI2BB1X1 U6204 ( .A0N(StateCnt5261_9_), .A1N(n9700), .B0(n9725), .Y(n9005)
         );
  XNOR2X1 U1_A_9 ( .A(StateCnt_9_), .B(carry_9_), .Y(StateCnt5261_9_) );
  AOI222X1 U6205 ( .A0(StateCnt_9_), .A1(n9716), .B0(SDIBSize[9]), .B1(n9695), 
        .C0(SDIDTimer[9]), .C1(n10433), .Y(n9725) );
  OAI2BB1X1 U6206 ( .A0N(StateCnt5261_8_), .A1N(n9700), .B0(n9724), .Y(n9006)
         );
  XNOR2X1 U1_A_8 ( .A(StateCnt_8_), .B(carry_8_), .Y(StateCnt5261_8_) );
  AOI222X1 U6207 ( .A0(StateCnt_8_), .A1(n9716), .B0(SDIBSize[8]), .B1(n9695), 
        .C0(SDIDTimer[8]), .C1(n10433), .Y(n9724) );
  OAI2BB1X1 U6208 ( .A0N(StateCnt5261_7_), .A1N(n9700), .B0(n9723), .Y(n9007)
         );
  XNOR2X1 U1_A_7 ( .A(StateCnt_7_), .B(carry_7_), .Y(StateCnt5261_7_) );
  AOI222X1 U6209 ( .A0(StateCnt_7_), .A1(n9716), .B0(SDIBSize[7]), .B1(n9695), 
        .C0(SDIDTimer[7]), .C1(n10433), .Y(n9723) );
  OAI2BB1X1 U6210 ( .A0N(StateCnt5261_6_), .A1N(n9700), .B0(n9722), .Y(n9008)
         );
  XNOR2X1 U1_A_6 ( .A(StateCnt_6_), .B(carry_6_), .Y(StateCnt5261_6_) );
  AOI222X1 U6211 ( .A0(StateCnt_6_), .A1(n9716), .B0(SDIBSize[6]), .B1(n9695), 
        .C0(SDIDTimer[6]), .C1(n10433), .Y(n9722) );
  OAI2BB1X1 U6212 ( .A0N(StateCnt5261_5_), .A1N(n9700), .B0(n9721), .Y(n9009)
         );
  XNOR2X1 U1_A_5 ( .A(StateCnt_5_), .B(carry_5_), .Y(StateCnt5261_5_) );
  AOI222X1 U6213 ( .A0(StateCnt_5_), .A1(n9716), .B0(SDIBSize[5]), .B1(n9695), 
        .C0(SDIDTimer[5]), .C1(n10433), .Y(n9721) );
  OAI2BB1X1 U6214 ( .A0N(StateCnt5261_4_), .A1N(n9700), .B0(n9715), .Y(n9010)
         );
  XNOR2X1 U1_A_41 ( .A(StateCnt_4_), .B(carry27), .Y(StateCnt5261_4_) );
  AOI221X1 U6215 ( .A0(StateCnt_4_), .A1(n9716), .B0(SDIDTimer[4]), .B1(n10433), .C0(n9717), .Y(n9715) );
  OAI32X1 U6216 ( .A0(n9713), .A1(n9718), .A2(n9719), .B0(n9550), .B1(n9720), 
        .Y(n9717) );
  AO22X1 U6217 ( .A0(StateCnt_30_), .A1(n9716), .B0(StateCnt5261_30_), .B1(
        n9700), .Y(n8984) );
  XNOR2X1 U1_A_30 ( .A(StateCnt_30_), .B(carry_30_), .Y(StateCnt5261_30_) );
  AO22X1 U6218 ( .A0(StateCnt_29_), .A1(n9716), .B0(StateCnt5261_29_), .B1(
        n9700), .Y(n8985) );
  XNOR2X1 U1_A_29 ( .A(StateCnt_29_), .B(carry_29_), .Y(StateCnt5261_29_) );
  AO22X1 U6219 ( .A0(StateCnt_28_), .A1(n9716), .B0(StateCnt5261_28_), .B1(
        n9700), .Y(n8986) );
  XNOR2X1 U1_A_28 ( .A(StateCnt_28_), .B(carry_28_), .Y(StateCnt5261_28_) );
  AO22X1 U6220 ( .A0(StateCnt_27_), .A1(n9716), .B0(StateCnt5261_27_), .B1(
        n9700), .Y(n8987) );
  XNOR2X1 U1_A_27 ( .A(StateCnt_27_), .B(carry_27_), .Y(StateCnt5261_27_) );
  AO22X1 U6221 ( .A0(StateCnt_26_), .A1(n9716), .B0(StateCnt5261_26_), .B1(
        n9700), .Y(n8988) );
  XNOR2X1 U1_A_26 ( .A(StateCnt_26_), .B(carry_26_), .Y(StateCnt5261_26_) );
  AO22X1 U6222 ( .A0(StateCnt_25_), .A1(n9716), .B0(StateCnt5261_25_), .B1(
        n9700), .Y(n8989) );
  XNOR2X1 U1_A_25 ( .A(StateCnt_25_), .B(carry_25_), .Y(StateCnt5261_25_) );
  AO22X1 U6223 ( .A0(StateCnt_24_), .A1(n9716), .B0(StateCnt5261_24_), .B1(
        n9700), .Y(n8990) );
  XNOR2X1 U1_A_24 ( .A(StateCnt_24_), .B(carry_24_), .Y(StateCnt5261_24_) );
  AO22X1 U6224 ( .A0(StateCnt_23_), .A1(n9716), .B0(StateCnt5261_23_), .B1(
        n9700), .Y(n8991) );
  XNOR2X1 U1_A_23 ( .A(StateCnt_23_), .B(carry_23_), .Y(StateCnt5261_23_) );
  OAI221X1 U6225 ( .A0(n9692), .A1(n10219), .B0(n9712), .B1(n9713), .C0(n9714), 
        .Y(n9011) );
  AOI222X1 U6226 ( .A0(StateCnt5261_3_), .A1(n9700), .B0(SDIBSize[3]), .B1(
        n9695), .C0(SDIDTimer[3]), .C1(n10433), .Y(n9714) );
  XNOR2X1 U1_A_31 ( .A(StateCnt_3_), .B(carry28), .Y(StateCnt5261_3_) );
  AO21X1 U6227 ( .A0(StateCnt5261_22_), .A1(n9700), .B0(n9739), .Y(n8992) );
  XNOR2X1 U1_A_22 ( .A(StateCnt_22_), .B(carry_22_), .Y(StateCnt5261_22_) );
  AO22X1 U6228 ( .A0(StateCnt_22_), .A1(n9716), .B0(SDIDTimer[22]), .B1(n10433), .Y(n9739) );
  AO21X1 U6229 ( .A0(StateCnt5261_21_), .A1(n9700), .B0(n9738), .Y(n8993) );
  XNOR2X1 U1_A_211 ( .A(StateCnt_21_), .B(carry_21_), .Y(StateCnt5261_21_) );
  AO22X1 U6230 ( .A0(StateCnt_21_), .A1(n9716), .B0(SDIDTimer[21]), .B1(n10433), .Y(n9738) );
  AO21X1 U6231 ( .A0(StateCnt5261_20_), .A1(n9700), .B0(n9737), .Y(n8994) );
  XNOR2X1 U1_A_20 ( .A(StateCnt_20_), .B(carry_20_), .Y(StateCnt5261_20_) );
  AO22X1 U6232 ( .A0(StateCnt_20_), .A1(n9716), .B0(SDIDTimer[20]), .B1(n10433), .Y(n9737) );
  AO21X1 U6233 ( .A0(StateCnt5261_19_), .A1(n9700), .B0(n9736), .Y(n8995) );
  XNOR2X1 U1_A_19 ( .A(StateCnt_19_), .B(carry_19_), .Y(StateCnt5261_19_) );
  AO22X1 U6234 ( .A0(StateCnt_19_), .A1(n9716), .B0(SDIDTimer[19]), .B1(n10433), .Y(n9736) );
  AO21X1 U6235 ( .A0(StateCnt5261_18_), .A1(n9700), .B0(n9735), .Y(n8996) );
  XNOR2X1 U1_A_18 ( .A(StateCnt_18_), .B(carry_18_), .Y(StateCnt5261_18_) );
  AO22X1 U6236 ( .A0(StateCnt_18_), .A1(n9716), .B0(SDIDTimer[18]), .B1(n10433), .Y(n9735) );
  AO21X1 U6237 ( .A0(StateCnt5261_17_), .A1(n9700), .B0(n9734), .Y(n8997) );
  XNOR2X1 U1_A_17 ( .A(StateCnt_17_), .B(carry_17_), .Y(StateCnt5261_17_) );
  AO22X1 U6238 ( .A0(StateCnt_17_), .A1(n9716), .B0(SDIDTimer[17]), .B1(n10433), .Y(n9734) );
  AO21X1 U6239 ( .A0(StateCnt5261_16_), .A1(n9700), .B0(n9733), .Y(n8998) );
  XNOR2X1 U1_A_16 ( .A(StateCnt_16_), .B(carry_16_), .Y(StateCnt5261_16_) );
  AO22X1 U6240 ( .A0(StateCnt_16_), .A1(n9716), .B0(SDIDTimer[16]), .B1(n10433), .Y(n9733) );
  OAI211X1 U6241 ( .A0(n9692), .A1(n10221), .B0(n10435), .C0(n9705), .Y(n9012)
         );
  AOI222X1 U6242 ( .A0(StateCnt5261_2_), .A1(n9700), .B0(SDIBSize[2]), .B1(
        n9695), .C0(SDIDTimer[2]), .C1(n10433), .Y(n9705) );
  XNOR2X1 U1_A_21 ( .A(StateCnt_2_), .B(carry29), .Y(StateCnt5261_2_) );
  OAI211X1 U6243 ( .A0(n9692), .A1(n10220), .B0(n9698), .C0(n9699), .Y(n9013)
         );
  OA21X2 U6244 ( .A0(n9701), .A1(n9702), .B0(n10435), .Y(n9698) );
  AOI222X1 U6245 ( .A0(StateCnt5261_1_), .A1(n9700), .B0(SDIBSize[1]), .B1(
        n9695), .C0(SDIDTimer[1]), .C1(n10433), .Y(n9699) );
  INVX1 U6246 ( .A(n9703), .Y(n9701) );
  OAI211X1 U6247 ( .A0(StateCnt_0_), .A1(n9688), .B0(n9689), .C0(n9690), .Y(
        n9014) );
  AOI222X1 U6248 ( .A0(SDIDTimer[0]), .A1(n10433), .B0(n9446), .B1(n9295), 
        .C0(SDIBSize[0]), .C1(n9695), .Y(n9689) );
  OA21X2 U6249 ( .A0(n10389), .A1(n9692), .B0(n10435), .Y(n9690) );
  INVX1 U6250 ( .A(n9960), .Y(n9676) );
  OAI33X1 U6251 ( .A0(n9940), .A1(CRCStatusGet), .A2(n9417), .B0(n9940), .B1(
        n9386), .B2(n10392), .Y(n9960) );
  NAND2BX1 U6252 ( .AN(n9311), .B(ByteOrder), .Y(n9659) );
  NAND4BX1 U6253 ( .AN(n9751), .B(n9306), .C(n9287), .D(TxCRCCal), .Y(n9749)
         );
  NAND2BX1 U6254 ( .AN(n9555), .B(DATIN[0]), .Y(n9271) );
  NAND4BX1 U6255 ( .AN(TxCRCSend), .B(n10459), .C(n9897), .D(n9749), .Y(n9866)
         );
  NAND4BX1 U6256 ( .AN(n9746), .B(DTST), .C(n9753), .D(DatCtrlIdle), .Y(n9304)
         );
  OA21X2 U6257 ( .A0(CmdSentSet), .A1(n9754), .B0(n9238), .Y(n9753) );
  NAND3BX1 U6258 ( .AN(n9683), .B(n9376), .C(AbortCmdSent), .Y(n9444) );
  NAND3BX1 U6259 ( .AN(n9336), .B(n9349), .C(n9350), .Y(n9348) );
  AOI211X1 U6260 ( .A0(n9353), .A1(n9333), .B0(n9332), .C0(n9354), .Y(n9349)
         );
  AOI32X1 U6261 ( .A0(n9351), .A1(n9287), .A2(n9352), .B0(n9352), .B1(
        AbortCmdSent), .Y(n9350) );
  NOR2BX1 U6262 ( .AN(n9286), .B(n9355), .Y(n9353) );
  NAND2BX1 U6263 ( .AN(StartBit), .B(n9769), .Y(n9751) );
  OR2X1 U6264 ( .A(D0CRCSR[0]), .B(D0CRCSR[2]), .Y(n10030) );
  NAND2BX1 U6265 ( .AN(StartBit), .B(n9333), .Y(n9298) );
  AO21X1 U6266 ( .A0(StartBit), .A1(n9769), .B0(n9354), .Y(n9732) );
  OAI32X1 U6267 ( .A0(n9264), .A1(DATAState[0]), .A2(n9436), .B0(n9437), .B1(
        n9438), .Y(n9309) );
  AOI211X1 U6268 ( .A0(n10457), .A1(n9439), .B0(n9440), .C0(n9293), .Y(n9437)
         );
  INVX1 U6269 ( .A(TARSP), .Y(n9439) );
  OAI221X1 U6270 ( .A0(n9657), .A1(n9985), .B0(n9986), .B1(n10410), .C0(n9987), 
        .Y(n9859) );
  INVX1 U6271 ( .A(FIFOReadData[7]), .Y(n9985) );
  OA22X1 U6272 ( .A0(n9988), .A1(n9989), .B0(n9659), .B1(n9990), .Y(n9987) );
  AOI222X1 U6273 ( .A0(DATSR_30_), .A1(n9583), .B0(DATSR_23_), .B1(MMCPlus), 
        .C0(DATSR_27_), .C1(n9556), .Y(n9988) );
  AO21X1 U6274 ( .A0(n9391), .A1(DatMode[0]), .B0(n9981), .Y(n9371) );
  OAI31X1 U6275 ( .A0(n9754), .A1(DatMode[0]), .A2(CmdSentSet), .B0(n9982), 
        .Y(n9981) );
  NOR2BX1 U6276 ( .AN(DTST), .B(n9746), .Y(n9982) );
  OAI221X1 U6277 ( .A0(n9657), .A1(n9991), .B0(n9986), .B1(n10407), .C0(n9992), 
        .Y(n9878) );
  INVX1 U6278 ( .A(FIFOReadData[6]), .Y(n9991) );
  OA22X1 U6279 ( .A0(n9993), .A1(n9989), .B0(n9659), .B1(n9994), .Y(n9992) );
  AOI222X1 U6280 ( .A0(DATSR_29_), .A1(n9583), .B0(DATSR_22_), .B1(MMCPlus), 
        .C0(DATSR_26_), .C1(n9556), .Y(n9993) );
  OAI221X1 U6281 ( .A0(n9657), .A1(n9995), .B0(n9986), .B1(n10409), .C0(n9996), 
        .Y(n9872) );
  INVX1 U6282 ( .A(FIFOReadData[5]), .Y(n9995) );
  OA22X1 U6283 ( .A0(n9997), .A1(n9989), .B0(n9659), .B1(n9998), .Y(n9996) );
  AOI222X1 U6284 ( .A0(DATSR_28_), .A1(n9583), .B0(DATSR_21_), .B1(MMCPlus), 
        .C0(DATSR_25_), .C1(n9556), .Y(n9997) );
  OAI32X1 U6285 ( .A0(n9438), .A1(n9293), .A2(n9898), .B0(n10444), .B1(n9264), 
        .Y(n9323) );
  NAND2BX1 U6286 ( .AN(TARSP), .B(n10457), .Y(n9898) );
  OAI221X1 U6287 ( .A0(n9657), .A1(n9999), .B0(n9986), .B1(n10408), .C0(n10000), .Y(n9887) );
  INVX1 U6288 ( .A(FIFOReadData[4]), .Y(n9999) );
  OA22X1 U6289 ( .A0(n10001), .A1(n9989), .B0(n9659), .B1(n10002), .Y(n10000)
         );
  AOI222X1 U6290 ( .A0(DATSR_27_), .A1(n9583), .B0(DATSR_20_), .B1(MMCPlus), 
        .C0(DATSR_24_), .C1(n9556), .Y(n10001) );
  OAI221X1 U6291 ( .A0(n9657), .A1(n9580), .B0(n9986), .B1(n10403), .C0(n10003), .Y(n9883) );
  OA22X1 U6292 ( .A0(n10004), .A1(n9989), .B0(n9659), .B1(n10005), .Y(n10003)
         );
  AOI222X1 U6293 ( .A0(DATSR_26_), .A1(n9583), .B0(DATSR_19_), .B1(MMCPlus), 
        .C0(DATSR_23_), .C1(n9556), .Y(n10004) );
  INVX1 U6294 ( .A(FIFOReadData[27]), .Y(n10005) );
  OAI221X1 U6295 ( .A0(n9657), .A1(n9577), .B0(n9986), .B1(n10406), .C0(n10006), .Y(n9879) );
  OA22X1 U6296 ( .A0(n10007), .A1(n9989), .B0(n9659), .B1(n10008), .Y(n10006)
         );
  AOI222X1 U6297 ( .A0(DATSR_25_), .A1(n9583), .B0(DATSR_18_), .B1(MMCPlus), 
        .C0(DATSR_22_), .C1(n9556), .Y(n10007) );
  INVX1 U6298 ( .A(FIFOReadData[26]), .Y(n10008) );
  OAI221X1 U6299 ( .A0(n9657), .A1(n9571), .B0(n9986), .B1(n10404), .C0(n10009), .Y(n9874) );
  OA22X1 U6300 ( .A0(n10010), .A1(n9989), .B0(n9659), .B1(n10011), .Y(n10009)
         );
  AOI222X1 U6301 ( .A0(DATSR_24_), .A1(n9583), .B0(DATSR_17_), .B1(MMCPlus), 
        .C0(DATSR_21_), .C1(n9556), .Y(n10010) );
  INVX1 U6302 ( .A(FIFOReadData[25]), .Y(n10011) );
  OAI221X1 U6303 ( .A0(n9563), .A1(n9657), .B0(n9986), .B1(n10405), .C0(n10012), .Y(n9867) );
  OA22X1 U6304 ( .A0(n10013), .A1(n9989), .B0(n9659), .B1(n9566), .Y(n10012)
         );
  AOI222X1 U6305 ( .A0(DATSR_23_), .A1(n9583), .B0(DATSR_16_), .B1(MMCPlus), 
        .C0(DATSR_20_), .C1(n9556), .Y(n10013) );
  OAI32X1 U6306 ( .A0(n9772), .A1(n10014), .A2(n9928), .B0(n9772), .B1(n10391), 
        .Y(n9312) );
  NAND2BX1 U6307 ( .AN(StopBit), .B(n9752), .Y(n10014) );
  NAND4BX1 U6308 ( .AN(n10081), .B(n10370), .C(n10303), .D(n10083), .Y(n10035)
         );
  NAND3BX1 U6309 ( .AN(D5CRCSR[8]), .B(n10307), .C(n10371), .Y(n10081) );
  AND4X1 U6310 ( .A(n10218), .B(n10381), .C(n10317), .D(n10259), .Y(n10083) );
  NAND2BX1 U6311 ( .AN(n9866), .B(MMCPlus), .Y(n9854) );
  NAND3BX1 U6312 ( .AN(D1CRCSR[0]), .B(n10355), .C(n10285), .Y(n10144) );
  OR3X2 U6313 ( .A(D1CRCSR[8]), .B(D1CRCSR[7]), .C(D1CRCSR[6]), .Y(n10153) );
  NAND3BX1 U6314 ( .AN(D3CRCSR[13]), .B(n10346), .C(n10283), .Y(n10135) );
  OR3X2 U6315 ( .A(D3CRCSR[0]), .B(D2CRCSR[9]), .C(D2CRCSR[8]), .Y(n10127) );
  NAND3BX1 U6316 ( .AN(D3CRCSR[6]), .B(n10353), .C(n10290), .Y(n10137) );
  NAND3BX1 U6317 ( .AN(D2CRCSR[13]), .B(n10354), .C(n10287), .Y(n10155) );
  NAND3BX1 U6318 ( .AN(D1CRCSR[2]), .B(n10356), .C(n10281), .Y(n10146) );
  OR3X2 U6319 ( .A(D3CRCSR[9]), .B(D3CRCSR[8]), .C(D3CRCSR[7]), .Y(n10136) );
  NAND3BX1 U6320 ( .AN(D1CRCSR[5]), .B(n10357), .C(n10286), .Y(n10145) );
  NAND3BX1 U6321 ( .AN(D2CRCSR[1]), .B(n10347), .C(n10282), .Y(n10154) );
  OR3X2 U6322 ( .A(D1CRCSR[14]), .B(D1CRCSR[13]), .C(D1CRCSR[12]), .Y(n10143)
         );
  OR3X2 U6323 ( .A(D3CRCSR[3]), .B(D3CRCSR[2]), .C(D3CRCSR[1]), .Y(n10134) );
  OR3X2 U6324 ( .A(D2CRCSR[10]), .B(D2CRCSR[0]), .C(D1CRCSR[9]), .Y(n10152) );
  NAND3BX1 U6325 ( .AN(n10089), .B(n10090), .C(n10091), .Y(n10034) );
  AND4X1 U6326 ( .A(n10250), .B(n10316), .C(n10379), .D(n10222), .Y(n10090) );
  AND4X1 U6327 ( .A(n10318), .B(n10382), .C(n10262), .D(n10228), .Y(n10091) );
  NAND3BX1 U6328 ( .AN(D4CRCSR[12]), .B(n10368), .C(n10098), .Y(n10089) );
  OAI211X1 U6329 ( .A0(TxCRCSend), .A1(n9709), .B0(n9897), .C0(n10458), .Y(
        n9862) );
  NAND3BX1 U6330 ( .AN(n9751), .B(n9405), .C(StopBit), .Y(n9318) );
  NAND3BX1 U6331 ( .AN(n10076), .B(n10358), .C(n10296), .Y(n10064) );
  NAND3BX1 U6332 ( .AN(D7CRCSR[9]), .B(n10298), .C(n10362), .Y(n10076) );
  OR4X1 U6333 ( .A(n10124), .B(n10125), .C(n10126), .D(n10127), .Y(n10123) );
  NAND3BX1 U6334 ( .AN(D2CRCSR[7]), .B(n10361), .C(n10297), .Y(n10124) );
  NAND3BX1 U6335 ( .AN(D2CRCSR[2]), .B(n10360), .C(n10288), .Y(n10125) );
  NAND3BX1 U6336 ( .AN(D3CRCSR[12]), .B(n10359), .C(n10289), .Y(n10126) );
  AO21X1 U6337 ( .A0(n9768), .A1(n9745), .B0(SDreset), .Y(n9758) );
  AOI2BB1X1 U6338 ( .A0N(n9719), .A1N(n9770), .B0(n9771), .Y(n9768) );
  OAI211X1 U6339 ( .A0(n9229), .A1(n9779), .B0(BlkDatCntEn), .C0(n9305), .Y(
        n9770) );
  OAI33X1 U6340 ( .A0(n9772), .A1(StopBit), .A2(n9773), .B0(n9719), .B1(n9306), 
        .B2(n9774), .Y(n9771) );
  OAI211X1 U6341 ( .A0(n9582), .A1(n10270), .B0(n9603), .C0(n9604), .Y(n9039)
         );
  AOI222X1 U6342 ( .A0(DATSR_7_), .A1(n9575), .B0(FIFOReadData[7]), .B1(n9591), 
        .C0(FIFOReadData[31]), .C1(n9574), .Y(n9603) );
  OA22X1 U6343 ( .A0(n9605), .A1(n10469), .B0(n10331), .B1(n10471), .Y(n9604)
         );
  INVX1 U6344 ( .A(DATIN[7]), .Y(n9605) );
  OAI211X1 U6345 ( .A0(n9582), .A1(n10274), .B0(n9598), .C0(n9599), .Y(n9040)
         );
  AOI222X1 U6346 ( .A0(DATSR_6_), .A1(n9575), .B0(FIFOReadData[6]), .B1(n9591), 
        .C0(FIFOReadData[30]), .C1(n9574), .Y(n9598) );
  OA22X1 U6347 ( .A0(n9600), .A1(n9589), .B0(n10338), .B1(n9590), .Y(n9599) );
  INVX1 U6348 ( .A(DATIN[6]), .Y(n9600) );
  OAI211X1 U6349 ( .A0(n9582), .A1(n10271), .B0(n9593), .C0(n9594), .Y(n9041)
         );
  AOI222X1 U6350 ( .A0(DATSR_5_), .A1(n9575), .B0(FIFOReadData[5]), .B1(n9591), 
        .C0(FIFOReadData[29]), .C1(n9574), .Y(n9593) );
  OA22X1 U6351 ( .A0(n9595), .A1(n10470), .B0(n10337), .B1(n10472), .Y(n9594)
         );
  INVX1 U6352 ( .A(DATIN[5]), .Y(n9595) );
  OAI211X1 U6353 ( .A0(n9582), .A1(n10331), .B0(n9586), .C0(n9587), .Y(n9042)
         );
  AOI222X1 U6354 ( .A0(DATSR_4_), .A1(n9575), .B0(FIFOReadData[4]), .B1(n9591), 
        .C0(FIFOReadData[28]), .C1(n9574), .Y(n9586) );
  OA22X1 U6355 ( .A0(n9588), .A1(n10469), .B0(n10336), .B1(n10471), .Y(n9587)
         );
  INVX1 U6356 ( .A(DATIN[4]), .Y(n9588) );
  AND4X1 U6357 ( .A(n10320), .B(n10383), .C(n10260), .D(n10223), .Y(n10098) );
  OAI2BB1X1 U6358 ( .A0N(n9360), .A1N(n9361), .B0(n9362), .Y(n9178) );
  OAI211X1 U6359 ( .A0(n9373), .A1(n9249), .B0(n9374), .C0(n9375), .Y(n9360)
         );
  OAI31X1 U6360 ( .A0(n9363), .A1(n9310), .A2(n9364), .B0(n9361), .Y(n9362) );
  AOI32X1 U6361 ( .A0(n9358), .A1(n10391), .A2(n9383), .B0(DATAState[0]), .B1(
        n9384), .Y(n9374) );
  AND4X1 U6362 ( .A(n10217), .B(n10363), .C(n10300), .D(n10246), .Y(n10048) );
  AND4X1 U6363 ( .A(n10380), .B(n10306), .C(n10113), .D(n10114), .Y(n10103) );
  INVX1 U6364 ( .A(n10030), .Y(n10113) );
  AND4X1 U6365 ( .A(n10315), .B(n10384), .C(n10258), .D(n10227), .Y(n10114) );
  AND4X1 U6366 ( .A(n10301), .B(n10364), .C(n10247), .D(n10216), .Y(n10047) );
  AND4X1 U6367 ( .A(n10302), .B(n10366), .C(n10248), .D(n10215), .Y(n10045) );
  AND4X1 U6368 ( .A(n10299), .B(n10365), .C(n10241), .D(n10211), .Y(n10046) );
  AO21X1 U6369 ( .A0(CRCStatusCnt_2_), .A1(n9680), .B0(n9681), .Y(n9015) );
  OAI33X1 U6370 ( .A0(n9678), .A1(n10321), .A2(n10412), .B0(n9683), .B1(n9258), 
        .B2(n9677), .Y(n9681) );
  OAI222X1 U6371 ( .A0(n9390), .A1(n9304), .B0(n9395), .B1(n9406), .C0(n10345), 
        .C1(n9361), .Y(n9174) );
  NAND3BX1 U6372 ( .AN(n9407), .B(n9408), .C(n9376), .Y(n9406) );
  NAND3BX1 U6373 ( .AN(BlkDatCntEn), .B(n10325), .C(n10393), .Y(n9407) );
  OAI222X1 U6374 ( .A0(n9258), .A1(n9395), .B0(n9395), .B1(n9403), .C0(n10238), 
        .C1(n9361), .Y(n9175) );
  NAND4BX1 U6375 ( .AN(n9404), .B(n10391), .C(n9358), .D(StopBit), .Y(n9403)
         );
  INVX1 U6376 ( .A(n9405), .Y(n9404) );
  OAI222X1 U6377 ( .A0(n10451), .A1(n9675), .B0(n9676), .B1(n9677), .C0(
        CRCStatusCnt_0_), .C1(n9678), .Y(n9017) );
  NAND2BX1 U6378 ( .AN(n9759), .B(n9764), .Y(n8980) );
  AOI32X1 U6379 ( .A0(BitCnt_1_), .A1(BitCnt_2_), .A2(n9765), .B0(BitCnt_2_), 
        .B1(n9763), .Y(n9764) );
  NAND2BX1 U6380 ( .AN(n9759), .B(n9760), .Y(n8981) );
  AOI32X1 U6381 ( .A0(n10323), .A1(n10388), .A2(n9762), .B0(BitCnt_1_), .B1(
        n9763), .Y(n9760) );
  INVX1 U6382 ( .A(n9757), .Y(n9762) );
  OAI32X1 U6383 ( .A0(n9678), .A1(CRCStatusCnt_1_), .A2(CRCStatusCnt_0_), .B0(
        n9679), .B1(n10321), .Y(n9016) );
  INVX1 U6384 ( .A(n9680), .Y(n9679) );
  OAI32X1 U6385 ( .A0(n9314), .A1(SDreset), .A2(DATAState[3]), .B0(n10322), 
        .B1(n9315), .Y(n9184) );
  INVX1 U6386 ( .A(n9315), .Y(n9314) );
  OAI211X1 U6387 ( .A0(n9316), .A1(n9317), .B0(n10436), .C0(n9318), .Y(n9315)
         );
  NAND2BX1 U6388 ( .AN(n9249), .B(n9319), .Y(n9317) );
  OAI32X1 U6389 ( .A0(n9326), .A1(StopBit), .A2(n9246), .B0(n10411), .B1(n9328), .Y(n9182) );
  INVX1 U6390 ( .A(n9328), .Y(n9326) );
  OAI211X1 U6391 ( .A0(n9298), .A1(n9329), .B0(n9324), .C0(n9330), .Y(n9328)
         );
  NAND2BX1 U6392 ( .AN(TxCRCCal), .B(n9287), .Y(n9329) );
  OAI221X1 U6393 ( .A0(n9755), .A1(n10323), .B0(BitCnt_0_), .B1(n9757), .C0(
        n9758), .Y(n8982) );
  OAI221X1 U6394 ( .A0(n9782), .A1(n10263), .B0(WORDCnt[0]), .B1(n9784), .C0(
        n9785), .Y(n8979) );
  OAI221X1 U6395 ( .A0(n9579), .A1(n9570), .B0(n9562), .B1(n9580), .C0(n9581), 
        .Y(n9043) );
  INVX1 U6396 ( .A(DATIN[3]), .Y(n9579) );
  AOI222X1 U6397 ( .A0(DATSR_2_), .A1(n9573), .B0(FIFOReadData[27]), .B1(n9574), .C0(DATSR_3_), .C1(n9575), .Y(n9581) );
  OAI221X1 U6398 ( .A0(n9576), .A1(n9570), .B0(n9562), .B1(n9577), .C0(n9578), 
        .Y(n9044) );
  INVX1 U6399 ( .A(DATIN[2]), .Y(n9576) );
  AOI222X1 U6400 ( .A0(DATSR_1_), .A1(n9573), .B0(FIFOReadData[26]), .B1(n9574), .C0(DATSR_2_), .C1(n9575), .Y(n9578) );
  OAI221X1 U6401 ( .A0(n9569), .A1(n9570), .B0(n9562), .B1(n9571), .C0(n9572), 
        .Y(n9045) );
  INVX1 U6402 ( .A(DATIN[1]), .Y(n9569) );
  AOI222X1 U6403 ( .A0(n9573), .A1(DATSR_0_), .B0(FIFOReadData[25]), .B1(n9574), .C0(DATSR_1_), .C1(n9575), .Y(n9572) );
  AO21X1 U6404 ( .A0(n9344), .A1(BlkDatCntEn), .B0(n9345), .Y(n9179) );
  OAI33X1 U6405 ( .A0(n9344), .A1(SDreset), .A2(n10345), .B0(n9344), .B1(n9246), .B2(n9347), .Y(n9345) );
  NAND2BX1 U6406 ( .AN(DATAState[5]), .B(StartBit), .Y(n9347) );
  INVX1 U6407 ( .A(n9348), .Y(n9344) );
  AO21X1 U6408 ( .A0(n9393), .A1(DATAState[5]), .B0(n9410), .Y(n9173) );
  OAI33X1 U6409 ( .A0(n9390), .A1(DATIN[0]), .A2(n9367), .B0(n9395), .B1(n9411), .B2(n9412), .Y(n9410) );
  OA21X2 U6410 ( .A0(n9383), .A1(n10387), .B0(n10325), .Y(n9411) );
  AO21X1 U6411 ( .A0(n9393), .A1(DATAState[2]), .B0(n9394), .Y(n9176) );
  OAI32X1 U6412 ( .A0(n9395), .A1(n9396), .A2(n9397), .B0(n10444), .B1(n9390), 
        .Y(n9394) );
  OA21X2 U6413 ( .A0(StopBit), .A1(n9383), .B0(n9399), .Y(n9396) );
  INVX1 U6414 ( .A(n9357), .Y(n9399) );
  AO21X1 U6415 ( .A0(n9795), .A1(n10230), .B0(n9797), .Y(n8977) );
  AO22X1 U6416 ( .A0(BlkNumCnt[0]), .A1(n9798), .B0(BlkNum[0]), .B1(n9799), 
        .Y(n9797) );
  AO21X1 U6417 ( .A0(BlkDatCnt4671_15_), .A1(n9824), .B0(n9841), .Y(n8946) );
  XNOR2X1 U1_A_152 ( .A(BlkDatCnt[15]), .B(carry), .Y(BlkDatCnt4671_15_) );
  AO22X1 U6418 ( .A0(BlkDatCnt[15]), .A1(n9826), .B0(n9827), .B1(SDIBSize[15]), 
        .Y(n9841) );
  OR2X1 U1_B_142 ( .A(BlkDatCnt[14]), .B(carry0), .Y(carry) );
  AO21X1 U6419 ( .A0(BlkDatCnt4671_14_), .A1(n9824), .B0(n9840), .Y(n8947) );
  XNOR2X1 U1_A_142 ( .A(BlkDatCnt[14]), .B(carry0), .Y(BlkDatCnt4671_14_) );
  AO22X1 U6420 ( .A0(BlkDatCnt[14]), .A1(n9826), .B0(n9827), .B1(SDIBSize[14]), 
        .Y(n9840) );
  AO21X1 U6421 ( .A0(BlkDatCnt4671_13_), .A1(n9824), .B0(n9839), .Y(n8948) );
  XNOR2X1 U1_A_132 ( .A(BlkDatCnt[13]), .B(carry1), .Y(BlkDatCnt4671_13_) );
  AO22X1 U6422 ( .A0(BlkDatCnt[13]), .A1(n9826), .B0(n9827), .B1(SDIBSize[13]), 
        .Y(n9839) );
  AO21X1 U6423 ( .A0(BlkDatCnt4671_12_), .A1(n9824), .B0(n9838), .Y(n8949) );
  XNOR2X1 U1_A_122 ( .A(BlkDatCnt[12]), .B(carry2), .Y(BlkDatCnt4671_12_) );
  AO22X1 U6424 ( .A0(BlkDatCnt[12]), .A1(n9826), .B0(n9827), .B1(SDIBSize[12]), 
        .Y(n9838) );
  AO21X1 U6425 ( .A0(BlkDatCnt4671_11_), .A1(n9824), .B0(n9837), .Y(n8950) );
  XNOR2X1 U1_A_114 ( .A(BlkDatCnt[11]), .B(carry3), .Y(BlkDatCnt4671_11_) );
  AO22X1 U6426 ( .A0(BlkDatCnt[11]), .A1(n9826), .B0(n9827), .B1(SDIBSize[11]), 
        .Y(n9837) );
  AO21X1 U6427 ( .A0(BlkDatCnt4671_10_), .A1(n9824), .B0(n9836), .Y(n8951) );
  XNOR2X1 U1_A_102 ( .A(BlkDatCnt[10]), .B(carry4), .Y(BlkDatCnt4671_10_) );
  AO22X1 U6428 ( .A0(BlkDatCnt[10]), .A1(n9826), .B0(n9827), .B1(SDIBSize[10]), 
        .Y(n9836) );
  AO21X1 U6429 ( .A0(BlkDatCnt4671_9_), .A1(n9824), .B0(n9835), .Y(n8952) );
  XNOR2X1 U1_A_92 ( .A(BlkDatCnt[9]), .B(carry5), .Y(BlkDatCnt4671_9_) );
  AO22X1 U6430 ( .A0(BlkDatCnt[9]), .A1(n9826), .B0(n9827), .B1(SDIBSize[9]), 
        .Y(n9835) );
  AO21X1 U6431 ( .A0(BlkDatCnt4671_8_), .A1(n9824), .B0(n9834), .Y(n8953) );
  XNOR2X1 U1_A_82 ( .A(BlkDatCnt[8]), .B(carry6), .Y(BlkDatCnt4671_8_) );
  AO22X1 U6432 ( .A0(BlkDatCnt[8]), .A1(n9826), .B0(n9827), .B1(SDIBSize[8]), 
        .Y(n9834) );
  AO21X1 U6433 ( .A0(BlkDatCnt4671_7_), .A1(n9824), .B0(n9833), .Y(n8954) );
  XNOR2X1 U1_A_72 ( .A(BlkDatCnt[7]), .B(carry7), .Y(BlkDatCnt4671_7_) );
  AO22X1 U6434 ( .A0(BlkDatCnt[7]), .A1(n9826), .B0(n9827), .B1(SDIBSize[7]), 
        .Y(n9833) );
  AO21X1 U6435 ( .A0(BlkDatCnt4671_6_), .A1(n9824), .B0(n9832), .Y(n8955) );
  XNOR2X1 U1_A_62 ( .A(BlkDatCnt[6]), .B(carry8), .Y(BlkDatCnt4671_6_) );
  AO22X1 U6436 ( .A0(BlkDatCnt[6]), .A1(n9826), .B0(n9827), .B1(SDIBSize[6]), 
        .Y(n9832) );
  AO21X1 U6437 ( .A0(BlkDatCnt4671_5_), .A1(n9824), .B0(n9831), .Y(n8956) );
  XNOR2X1 U1_A_52 ( .A(BlkDatCnt[5]), .B(carry9), .Y(BlkDatCnt4671_5_) );
  AO22X1 U6438 ( .A0(BlkDatCnt[5]), .A1(n9826), .B0(n9827), .B1(SDIBSize[5]), 
        .Y(n9831) );
  AO21X1 U6439 ( .A0(BlkDatCnt4671_4_), .A1(n9824), .B0(n9830), .Y(n8957) );
  XNOR2X1 U1_A_43 ( .A(BlkDatCnt[4]), .B(carry10), .Y(BlkDatCnt4671_4_) );
  AO22X1 U6440 ( .A0(BlkDatCnt[4]), .A1(n9826), .B0(n9827), .B1(SDIBSize[4]), 
        .Y(n9830) );
  AO21X1 U6441 ( .A0(BlkDatCnt4671_3_), .A1(n9824), .B0(n9829), .Y(n8958) );
  XNOR2X1 U1_A_33 ( .A(BlkDatCnt[3]), .B(carry11), .Y(BlkDatCnt4671_3_) );
  AO22X1 U6442 ( .A0(BlkDatCnt[3]), .A1(n9826), .B0(n9827), .B1(SDIBSize[3]), 
        .Y(n9829) );
  AO21X1 U6443 ( .A0(BlkDatCnt4671_2_), .A1(n9824), .B0(n9828), .Y(n8959) );
  XNOR2X1 U1_A_212 ( .A(BlkDatCnt[2]), .B(carry12), .Y(BlkDatCnt4671_2_) );
  AO22X1 U6444 ( .A0(BlkDatCnt[2]), .A1(n9826), .B0(n9827), .B1(SDIBSize[2]), 
        .Y(n9828) );
  AO21X1 U6445 ( .A0(BlkDatCnt4671_1_), .A1(n9824), .B0(n9825), .Y(n8960) );
  XNOR2X1 U1_A_113 ( .A(BlkDatCnt[1]), .B(BlkDatCnt[0]), .Y(BlkDatCnt4671_1_)
         );
  AO22X1 U6446 ( .A0(BlkDatCnt[1]), .A1(n9826), .B0(n9827), .B1(SDIBSize[1]), 
        .Y(n9825) );
  AO21X1 U6447 ( .A0(BlkNumCnt4764_15_), .A1(n9795), .B0(n9814), .Y(n8962) );
  XNOR2X1 U1_A_151 ( .A(BlkNumCnt[15]), .B(carry13), .Y(BlkNumCnt4764_15_) );
  AO22X1 U6448 ( .A0(BlkNumCnt[15]), .A1(n9798), .B0(BlkNum[15]), .B1(n9799), 
        .Y(n9814) );
  OR2X1 U1_B_141 ( .A(BlkNumCnt[14]), .B(carry14), .Y(carry13) );
  AO21X1 U6449 ( .A0(BlkNumCnt4764_14_), .A1(n9795), .B0(n9813), .Y(n8963) );
  XNOR2X1 U1_A_141 ( .A(BlkNumCnt[14]), .B(carry14), .Y(BlkNumCnt4764_14_) );
  AO22X1 U6450 ( .A0(BlkNumCnt[14]), .A1(n9798), .B0(BlkNum[14]), .B1(n9799), 
        .Y(n9813) );
  AO21X1 U6451 ( .A0(BlkNumCnt4764_13_), .A1(n9795), .B0(n9812), .Y(n8964) );
  XNOR2X1 U1_A_131 ( .A(BlkNumCnt[13]), .B(carry15), .Y(BlkNumCnt4764_13_) );
  AO22X1 U6452 ( .A0(BlkNumCnt[13]), .A1(n9798), .B0(BlkNum[13]), .B1(n9799), 
        .Y(n9812) );
  AO21X1 U6453 ( .A0(BlkNumCnt4764_12_), .A1(n9795), .B0(n9811), .Y(n8965) );
  XNOR2X1 U1_A_121 ( .A(BlkNumCnt[12]), .B(carry16), .Y(BlkNumCnt4764_12_) );
  AO22X1 U6454 ( .A0(BlkNumCnt[12]), .A1(n9798), .B0(BlkNum[12]), .B1(n9799), 
        .Y(n9811) );
  AO21X1 U6455 ( .A0(BlkNumCnt4764_11_), .A1(n9795), .B0(n9810), .Y(n8966) );
  XNOR2X1 U1_A_112 ( .A(BlkNumCnt[11]), .B(carry17), .Y(BlkNumCnt4764_11_) );
  AO22X1 U6456 ( .A0(BlkNumCnt[11]), .A1(n9798), .B0(BlkNum[11]), .B1(n9799), 
        .Y(n9810) );
  AO21X1 U6457 ( .A0(BlkNumCnt4764_10_), .A1(n9795), .B0(n9809), .Y(n8967) );
  XNOR2X1 U1_A_101 ( .A(BlkNumCnt[10]), .B(carry18), .Y(BlkNumCnt4764_10_) );
  AO22X1 U6458 ( .A0(BlkNumCnt[10]), .A1(n9798), .B0(BlkNum[10]), .B1(n9799), 
        .Y(n9809) );
  AO21X1 U6459 ( .A0(BlkNumCnt4764_9_), .A1(n9795), .B0(n9808), .Y(n8968) );
  XNOR2X1 U1_A_91 ( .A(BlkNumCnt[9]), .B(carry19), .Y(BlkNumCnt4764_9_) );
  AO22X1 U6460 ( .A0(BlkNumCnt[9]), .A1(n9798), .B0(BlkNum[9]), .B1(n9799), 
        .Y(n9808) );
  AO21X1 U6461 ( .A0(BlkNumCnt4764_8_), .A1(n9795), .B0(n9807), .Y(n8969) );
  XNOR2X1 U1_A_81 ( .A(BlkNumCnt[8]), .B(carry20), .Y(BlkNumCnt4764_8_) );
  AO22X1 U6462 ( .A0(BlkNumCnt[8]), .A1(n9798), .B0(BlkNum[8]), .B1(n9799), 
        .Y(n9807) );
  AO21X1 U6463 ( .A0(BlkNumCnt4764_7_), .A1(n9795), .B0(n9806), .Y(n8970) );
  XNOR2X1 U1_A_71 ( .A(BlkNumCnt[7]), .B(carry21), .Y(BlkNumCnt4764_7_) );
  AO22X1 U6464 ( .A0(BlkNumCnt[7]), .A1(n9798), .B0(BlkNum[7]), .B1(n9799), 
        .Y(n9806) );
  AO21X1 U6465 ( .A0(BlkNumCnt4764_6_), .A1(n9795), .B0(n9805), .Y(n8971) );
  XNOR2X1 U1_A_61 ( .A(BlkNumCnt[6]), .B(carry22), .Y(BlkNumCnt4764_6_) );
  AO22X1 U6466 ( .A0(BlkNumCnt[6]), .A1(n9798), .B0(BlkNum[6]), .B1(n9799), 
        .Y(n9805) );
  AO21X1 U6467 ( .A0(BlkNumCnt4764_5_), .A1(n9795), .B0(n9804), .Y(n8972) );
  XNOR2X1 U1_A_51 ( .A(BlkNumCnt[5]), .B(carry23), .Y(BlkNumCnt4764_5_) );
  AO22X1 U6468 ( .A0(BlkNumCnt[5]), .A1(n9798), .B0(BlkNum[5]), .B1(n9799), 
        .Y(n9804) );
  AO21X1 U6469 ( .A0(BlkNumCnt4764_4_), .A1(n9795), .B0(n9803), .Y(n8973) );
  XNOR2X1 U1_A_42 ( .A(BlkNumCnt[4]), .B(carry24), .Y(BlkNumCnt4764_4_) );
  AO22X1 U6470 ( .A0(BlkNumCnt[4]), .A1(n9798), .B0(BlkNum[4]), .B1(n9799), 
        .Y(n9803) );
  AO21X1 U6471 ( .A0(BlkNumCnt4764_3_), .A1(n9795), .B0(n9802), .Y(n8974) );
  XNOR2X1 U1_A_32 ( .A(BlkNumCnt[3]), .B(carry25), .Y(BlkNumCnt4764_3_) );
  AO22X1 U6472 ( .A0(BlkNumCnt[3]), .A1(n9798), .B0(BlkNum[3]), .B1(n9799), 
        .Y(n9802) );
  AO21X1 U6473 ( .A0(BlkNumCnt4764_2_), .A1(n9795), .B0(n9801), .Y(n8975) );
  XNOR2X1 U1_A_210 ( .A(BlkNumCnt[2]), .B(carry26), .Y(BlkNumCnt4764_2_) );
  AO22X1 U6474 ( .A0(BlkNumCnt[2]), .A1(n9798), .B0(BlkNum[2]), .B1(n9799), 
        .Y(n9801) );
  AO21X1 U6475 ( .A0(BlkNumCnt4764_1_), .A1(n9795), .B0(n9800), .Y(n8976) );
  XNOR2X1 U1_A_110 ( .A(BlkNumCnt[1]), .B(BlkNumCnt[0]), .Y(BlkNumCnt4764_1_)
         );
  AO22X1 U6476 ( .A0(BlkNumCnt[1]), .A1(n9798), .B0(BlkNum[1]), .B1(n9799), 
        .Y(n9800) );
  AND4X1 U6477 ( .A(n10305), .B(n10386), .C(n10106), .D(n10107), .Y(n10104) );
  NOR2BX1 U6478 ( .AN(n10372), .B(D0CRCSR[5]), .Y(n10106) );
  AND4X1 U6479 ( .A(n10319), .B(n10385), .C(n10261), .D(n10229), .Y(n10107) );
  OAI221X1 U6480 ( .A0(n10346), .A1(n9862), .B0(n9881), .B1(n9854), .C0(n9882), 
        .Y(n8934) );
  INVX1 U6481 ( .A(n9883), .Y(n9881) );
  AOI221X1 U6482 ( .A0(n9871), .A1(n9859), .B0(DATOUT[3]), .B1(n10461), .C0(
        n9873), .Y(n9882) );
  OAI221X1 U6483 ( .A0(n10347), .A1(n9862), .B0(n9876), .B1(n9854), .C0(n9877), 
        .Y(n8935) );
  INVX1 U6484 ( .A(n9879), .Y(n9876) );
  AOI221X1 U6485 ( .A0(n9871), .A1(n9878), .B0(DATOUT[2]), .B1(n10461), .C0(
        n9873), .Y(n9877) );
  OAI221X1 U6486 ( .A0(n10427), .A1(n9862), .B0(n9869), .B1(n9854), .C0(n9870), 
        .Y(n8936) );
  INVX1 U6487 ( .A(n9874), .Y(n9869) );
  AOI221X1 U6488 ( .A0(n9871), .A1(n9872), .B0(DATOUT[1]), .B1(n10460), .C0(
        n9873), .Y(n9870) );
  OAI211X1 U6489 ( .A0(n10468), .A1(n10414), .B0(n9649), .C0(n9650), .Y(n9024)
         );
  AOI222X1 U6490 ( .A0(DATSR_22_), .A1(n9575), .B0(FIFOReadData[22]), .B1(
        n9591), .C0(FIFOReadData[14]), .C1(n9574), .Y(n9649) );
  OA22X1 U6491 ( .A0(n10469), .A1(n10333), .B0(n10471), .B1(n10399), .Y(n9650)
         );
  OAI211X1 U6492 ( .A0(n10468), .A1(n10401), .B0(n9643), .C0(n9644), .Y(n9026)
         );
  AOI222X1 U6493 ( .A0(DATSR_20_), .A1(n9575), .B0(FIFOReadData[20]), .B1(
        n9591), .C0(FIFOReadData[12]), .C1(n9574), .Y(n9643) );
  OA22X1 U6494 ( .A0(n10470), .A1(n10273), .B0(n10472), .B1(n10402), .Y(n9644)
         );
  OAI211X1 U6495 ( .A0(n9582), .A1(n10416), .B0(n9652), .C0(n9653), .Y(n9023)
         );
  AOI222X1 U6496 ( .A0(DATSR_23_), .A1(n9575), .B0(FIFOReadData[23]), .B1(
        n9591), .C0(FIFOReadData[15]), .C1(n9574), .Y(n9652) );
  OA22X1 U6497 ( .A0(n10470), .A1(n10272), .B0(n10472), .B1(n10401), .Y(n9653)
         );
  OAI211X1 U6498 ( .A0(n9582), .A1(n10415), .B0(n9646), .C0(n9647), .Y(n9025)
         );
  AOI222X1 U6499 ( .A0(DATSR_21_), .A1(n9575), .B0(FIFOReadData[21]), .B1(
        n9591), .C0(FIFOReadData[13]), .C1(n9574), .Y(n9646) );
  OA22X1 U6500 ( .A0(n9589), .A1(n10268), .B0(n9590), .B1(n10400), .Y(n9647)
         );
  OAI211X1 U6501 ( .A0(n9582), .A1(n10399), .B0(n9640), .C0(n9641), .Y(n9027)
         );
  AOI222X1 U6502 ( .A0(DATSR_19_), .A1(n9575), .B0(FIFOReadData[19]), .B1(
        n9591), .C0(FIFOReadData[11]), .C1(n9574), .Y(n9640) );
  OA22X1 U6503 ( .A0(n10469), .A1(n10334), .B0(n10471), .B1(n10272), .Y(n9641)
         );
  OAI211X1 U6504 ( .A0(n9582), .A1(n10400), .B0(n9637), .C0(n9638), .Y(n9028)
         );
  AOI222X1 U6505 ( .A0(DATSR_18_), .A1(n9575), .B0(FIFOReadData[18]), .B1(
        n9591), .C0(FIFOReadData[10]), .C1(n9574), .Y(n9637) );
  OA22X1 U6506 ( .A0(n9589), .A1(n10233), .B0(n9590), .B1(n10333), .Y(n9638)
         );
  OAI211X1 U6507 ( .A0(n9582), .A1(n10402), .B0(n9634), .C0(n9635), .Y(n9029)
         );
  AOI222X1 U6508 ( .A0(DATSR_17_), .A1(n9575), .B0(FIFOReadData[17]), .B1(
        n9591), .C0(FIFOReadData[9]), .C1(n9574), .Y(n9634) );
  OA22X1 U6509 ( .A0(n10470), .A1(n10332), .B0(n10472), .B1(n10268), .Y(n9635)
         );
  OAI211X1 U6510 ( .A0(n9582), .A1(n10272), .B0(n9631), .C0(n9632), .Y(n9030)
         );
  AOI222X1 U6511 ( .A0(DATSR_16_), .A1(n9575), .B0(FIFOReadData[16]), .B1(
        n9591), .C0(FIFOReadData[8]), .C1(n9574), .Y(n9631) );
  OA22X1 U6512 ( .A0(n10469), .A1(n10335), .B0(n10471), .B1(n10273), .Y(n9632)
         );
  OAI211X1 U6513 ( .A0(n9582), .A1(n10333), .B0(n9628), .C0(n9629), .Y(n9031)
         );
  AOI222X1 U6514 ( .A0(DATSR_15_), .A1(n9575), .B0(FIFOReadData[15]), .B1(
        n9591), .C0(FIFOReadData[23]), .C1(n9574), .Y(n9628) );
  OA22X1 U6515 ( .A0(n9589), .A1(n10269), .B0(n9590), .B1(n10334), .Y(n9629)
         );
  OAI211X1 U6516 ( .A0(n9582), .A1(n10268), .B0(n9625), .C0(n9626), .Y(n9032)
         );
  AOI222X1 U6517 ( .A0(DATSR_14_), .A1(n9575), .B0(FIFOReadData[14]), .B1(
        n9591), .C0(FIFOReadData[22]), .C1(n9574), .Y(n9625) );
  OA22X1 U6518 ( .A0(n10470), .A1(n10270), .B0(n10472), .B1(n10233), .Y(n9626)
         );
  OAI211X1 U6519 ( .A0(n9582), .A1(n10273), .B0(n9622), .C0(n9623), .Y(n9033)
         );
  AOI222X1 U6520 ( .A0(DATSR_13_), .A1(n9575), .B0(FIFOReadData[13]), .B1(
        n9591), .C0(FIFOReadData[21]), .C1(n9574), .Y(n9622) );
  OA22X1 U6521 ( .A0(n10469), .A1(n10274), .B0(n10471), .B1(n10332), .Y(n9623)
         );
  OAI211X1 U6522 ( .A0(n9582), .A1(n10334), .B0(n9619), .C0(n9620), .Y(n9034)
         );
  AOI222X1 U6523 ( .A0(DATSR_12_), .A1(n9575), .B0(FIFOReadData[12]), .B1(
        n9591), .C0(FIFOReadData[20]), .C1(n9574), .Y(n9619) );
  OA22X1 U6524 ( .A0(n9589), .A1(n10271), .B0(n9590), .B1(n10335), .Y(n9620)
         );
  OAI211X1 U6525 ( .A0(n9582), .A1(n10233), .B0(n9616), .C0(n9617), .Y(n9035)
         );
  AOI222X1 U6526 ( .A0(DATSR_11_), .A1(n9575), .B0(FIFOReadData[11]), .B1(
        n9591), .C0(FIFOReadData[19]), .C1(n9574), .Y(n9616) );
  OA22X1 U6527 ( .A0(n10331), .A1(n10470), .B0(n10472), .B1(n10269), .Y(n9617)
         );
  OAI211X1 U6528 ( .A0(n9582), .A1(n10332), .B0(n9613), .C0(n9614), .Y(n9036)
         );
  AOI222X1 U6529 ( .A0(DATSR_10_), .A1(n9575), .B0(FIFOReadData[10]), .B1(
        n9591), .C0(FIFOReadData[18]), .C1(n9574), .Y(n9613) );
  OA22X1 U6530 ( .A0(n10338), .A1(n10469), .B0(n10471), .B1(n10270), .Y(n9614)
         );
  OAI211X1 U6531 ( .A0(n9582), .A1(n10335), .B0(n9610), .C0(n9611), .Y(n9037)
         );
  AOI222X1 U6532 ( .A0(DATSR_9_), .A1(n9575), .B0(FIFOReadData[9]), .B1(n9591), 
        .C0(FIFOReadData[17]), .C1(n9574), .Y(n9610) );
  OA22X1 U6533 ( .A0(n10337), .A1(n9589), .B0(n9590), .B1(n10274), .Y(n9611)
         );
  OAI211X1 U6534 ( .A0(n9582), .A1(n10269), .B0(n9607), .C0(n9608), .Y(n9038)
         );
  AOI222X1 U6535 ( .A0(DATSR_8_), .A1(n9575), .B0(FIFOReadData[8]), .B1(n9591), 
        .C0(FIFOReadData[16]), .C1(n9574), .Y(n9607) );
  OA22X1 U6536 ( .A0(n10336), .A1(n10470), .B0(n10472), .B1(n10271), .Y(n9608)
         );
  AOI31X1 U6537 ( .A0(StopBit), .A1(n9331), .A2(n9288), .B0(n9332), .Y(n9330)
         );
  OAI21X1 U6538 ( .A0(n9678), .A1(n10451), .B0(n9675), .Y(n9680) );
  INVX1 U6539 ( .A(n10031), .Y(DatCrcSet) );
  OAI221X1 U6540 ( .A0(MMCPlus), .A1(n10032), .B0(n10032), .B1(n10033), .C0(
        CRCCheck), .Y(n10031) );
  OAI211X1 U6541 ( .A0(n10102), .A1(n9654), .B0(n10103), .C0(n10104), .Y(
        n10032) );
  OR4X1 U6542 ( .A(n10034), .B(n10035), .C(n10036), .D(n10037), .Y(n10033) );
  OAI221X1 U6543 ( .A0(n9233), .A1(n9784), .B0(n9782), .B1(n10398), .C0(n9787), 
        .Y(n8978) );
  AOI31X1 U6544 ( .A0(WORDCnt[0]), .A1(WORDCnt[1]), .A2(n9687), .B0(n9788), 
        .Y(n9787) );
  INVX1 U6545 ( .A(n9785), .Y(n9788) );
  NAND3BX1 U6546 ( .AN(n9450), .B(BusyRsp), .C(BusyChkIdle), .Y(n9666) );
  NAND4BX1 U6547 ( .AN(DATAState[0]), .B(DATAState[3]), .C(n9379), .D(n10445), 
        .Y(n9249) );
  NAND3BX1 U6548 ( .AN(SDreset), .B(n9666), .C(n9670), .Y(n9667) );
  OAI31X1 U6549 ( .A0(n9671), .A1(BusyCnt[1]), .A2(BusyCnt[0]), .B0(n10457), 
        .Y(n9670) );
  NAND3BX1 U6550 ( .AN(BusyCnt[4]), .B(n10275), .C(n10340), .Y(n9671) );
  NAND3BX1 U6551 ( .AN(DATAState[4]), .B(DATAState[5]), .C(n9932), .Y(n9412)
         );
  NAND2BX1 U6552 ( .AN(DATAState[0]), .B(n9933), .Y(n9397) );
  NAND3BX1 U6553 ( .AN(DATAState[5]), .B(DATAState[4]), .C(n9932), .Y(n9367)
         );
  NAND3BX1 U6554 ( .AN(n10325), .B(TxCRCCal), .C(n9305), .Y(n9402) );
  NAND4BX1 U6555 ( .AN(n9264), .B(n9366), .C(n9794), .D(DATIN[0]), .Y(n9242)
         );
  NAND2BX1 U6556 ( .AN(Abort), .B(n9273), .Y(n9355) );
  OAI32X1 U6557 ( .A0(n9234), .A1(n9235), .A2(n10208), .B0(n9237), .B1(n8896), 
        .Y(n9191) );
  NAND2BX1 U6558 ( .AN(SDreset), .B(n9238), .Y(n9235) );
  INVX1 U6559 ( .A(n9237), .Y(n9234) );
  NAND3BX1 U6560 ( .AN(n9239), .B(n9240), .C(n9241), .Y(n9237) );
  NAND3BX1 U6561 ( .AN(BitCnt_2_), .B(n10388), .C(n10323), .Y(n9781) );
  NAND2BX1 U6562 ( .AN(n9416), .B(n9413), .Y(n9389) );
  OAI211X1 U6563 ( .A0(BusyStatus), .A1(n9274), .B0(DATIN[0]), .C0(n9270), .Y(
        n9416) );
  NAND2BX1 U6564 ( .AN(DATAState[2]), .B(n10449), .Y(n9384) );
  AO22X1 U6565 ( .A0(CRCStatusChk), .A1(n10305), .B0(CRCStatusChk), .B1(n10030), .Y(CrcStaSet) );
  OAI2BB1X1 U6566 ( .A0N(n10020), .A1N(D0CRCSR[14]), .B0(n10021), .Y(n9865) );
  AOI32X1 U6567 ( .A0(CRCStatusStr), .A1(D0CRCSR[14]), .A2(n10457), .B0(
        D0CRCSR[15]), .B1(n9555), .Y(n10021) );
  AO21X1 U6568 ( .A0(AbortCmdSent), .A1(TxCRCCal), .B0(n9273), .Y(n9307) );
  NAND4BX1 U6569 ( .AN(n10162), .B(n10163), .C(n10164), .D(n10165), .Y(n10161)
         );
  NAND4BX1 U6570 ( .AN(StateCnt_23_), .B(n10249), .C(n10369), .D(n10304), .Y(
        n10162) );
  AND4X1 U6571 ( .A(n10390), .B(n10314), .C(n10257), .D(n10220), .Y(n10163) );
  AND4X1 U6572 ( .A(n10309), .B(n10373), .C(n10252), .D(n10187), .Y(n10164) );
  OAI222X1 U6573 ( .A0(n9383), .A1(n9442), .B0(n9443), .B1(n9442), .C0(SDreset), .C1(n9444), .Y(n9171) );
  NAND4BX1 U6574 ( .AN(n9445), .B(n9295), .C(n9241), .D(Abort), .Y(n9442) );
  INVX1 U6575 ( .A(n9421), .Y(n9445) );
  NAND4BX1 U6576 ( .AN(n9746), .B(DTST), .C(DatMode[0]), .D(DatCtrlIdle), .Y(
        n9392) );
  OAI33X1 U6577 ( .A0(n9465), .A1(D7CRCSR[15]), .A2(n9466), .B0(n9465), .B1(
        n9460), .B2(n10210), .Y(n9452) );
  INVX1 U6578 ( .A(n9460), .Y(n9466) );
  OAI33X1 U6579 ( .A0(n9465), .A1(D1CRCSR[15]), .A2(n9527), .B0(n9465), .B1(
        n10281), .B2(n9524), .Y(n9518) );
  INVX1 U6580 ( .A(n9524), .Y(n9527) );
  OAI33X1 U6581 ( .A0(n9465), .A1(D2CRCSR[15]), .A2(n9516), .B0(n9465), .B1(
        n10282), .B2(n9514), .Y(n9508) );
  INVX1 U6582 ( .A(n9514), .Y(n9516) );
  OAI33X1 U6583 ( .A0(n9465), .A1(D3CRCSR[15]), .A2(n9506), .B0(n9465), .B1(
        n10283), .B2(n9504), .Y(n9498) );
  INVX1 U6584 ( .A(n9504), .Y(n9506) );
  OAI33X1 U6585 ( .A0(n9465), .A1(D4CRCSR[15]), .A2(n9496), .B0(n9465), .B1(
        n10209), .B2(n9494), .Y(n9488) );
  INVX1 U6586 ( .A(n9494), .Y(n9496) );
  OAI33X1 U6587 ( .A0(n9465), .A1(D5CRCSR[15]), .A2(n9486), .B0(n9465), .B1(
        n10218), .B2(n9484), .Y(n9478) );
  INVX1 U6588 ( .A(n9484), .Y(n9486) );
  OAI33X1 U6589 ( .A0(n9465), .A1(D6CRCSR[15]), .A2(n9476), .B0(n9465), .B1(
        n10211), .B2(n9474), .Y(n9468) );
  INVX1 U6590 ( .A(n9474), .Y(n9476) );
  NAND2BX1 U6591 ( .AN(n9549), .B(n9550), .Y(n9049) );
  OAI33X1 U6592 ( .A0(n9551), .A1(NibbleCnt), .A2(n9552), .B0(n9553), .B1(
        n10425), .B2(n9552), .Y(n9549) );
  INVX1 U6593 ( .A(n9551), .Y(n9553) );
  AND4X1 U6594 ( .A(n10310), .B(n10374), .C(n10253), .D(n10224), .Y(n10169) );
  AND4X1 U6595 ( .A(n10254), .B(n10311), .C(n10225), .D(n10375), .Y(n10187) );
  AO22X1 U6596 ( .A0(nDATEN), .A1(n9290), .B0(n9291), .B1(n9292), .Y(n9186) );
  OAI2BB1X1 U6597 ( .A0N(n9293), .A1N(DATAState[1]), .B0(n9294), .Y(n9291) );
  INVX1 U6598 ( .A(n9292), .Y(n9290) );
  OAI211X1 U6599 ( .A0(n9298), .A1(n9299), .B0(n9300), .C0(n9301), .Y(n9292)
         );
  OAI33X1 U6600 ( .A0(n9311), .A1(TxRdPtrInc), .A2(SDreset), .B0(n9312), .B1(
        SDreset), .B2(n10426), .Y(n9185) );
  AO22X1 U6601 ( .A0(BusyCnt[4]), .A1(n9662), .B0(n9668), .B1(n9667), .Y(n9018) );
  OA21X2 U6602 ( .A0(n9669), .A1(NextBusyCnt6524_4_), .B0(n9295), .Y(n9668) );
  XNOR2X1 U1_A_4 ( .A(BusyCnt[4]), .B(carry_4_), .Y(NextBusyCnt6524_4_) );
  INVX1 U6603 ( .A(n9666), .Y(n9669) );
  NAND2BX1 U6604 ( .AN(n9532), .B(n9533), .Y(n9064) );
  AOI32X1 U6605 ( .A0(CRCStatusStr), .A1(n9534), .A2(n9535), .B0(D0CRCSR[0]), 
        .B1(n10460), .Y(n9533) );
  INVX1 U6606 ( .A(n9544), .Y(n9532) );
  NAND3BX1 U6607 ( .AN(CRCStatusStr), .B(n9543), .C(n9545), .Y(n9544) );
  INVX1 U6608 ( .A(n9465), .Y(n9545) );
  AO22X1 U6609 ( .A0(n9320), .A1(StartBit), .B0(n9321), .B1(n9322), .Y(n9183)
         );
  OA21X2 U6610 ( .A0(DATAState[1]), .A1(DATAState[6]), .B0(n9295), .Y(n9321)
         );
  INVX1 U6611 ( .A(n9322), .Y(n9320) );
  NAND3BX1 U6612 ( .AN(n9323), .B(n9324), .C(n9325), .Y(n9322) );
  AO22X1 U6613 ( .A0(BusyCnt[0]), .A1(n9662), .B0(n9663), .B1(n10423), .Y(
        n9022) );
  AO22X1 U6614 ( .A0(n10460), .A1(D7CRCSR[15]), .B0(n10018), .B1(D7CRCSR[14]), 
        .Y(D7CRCSR5468_15_) );
  AO22X1 U6615 ( .A0(D6CRCSR[15]), .A1(n9451), .B0(n10018), .B1(D6CRCSR[14]), 
        .Y(D6CRCSR5462_15_) );
  AO22X1 U6616 ( .A0(D5CRCSR[15]), .A1(n9451), .B0(n10018), .B1(D5CRCSR[14]), 
        .Y(D5CRCSR5456_15_) );
  AO22X1 U6617 ( .A0(D4CRCSR[15]), .A1(n10460), .B0(n10018), .B1(D4CRCSR[14]), 
        .Y(D4CRCSR5450_15_) );
  AO22X1 U6618 ( .A0(D3CRCSR[15]), .A1(n10460), .B0(n10018), .B1(D3CRCSR[14]), 
        .Y(D3CRCSR5444_15_) );
  AO22X1 U6619 ( .A0(D2CRCSR[15]), .A1(n10461), .B0(n10018), .B1(D2CRCSR[14]), 
        .Y(D2CRCSR5438_15_) );
  AO22X1 U6620 ( .A0(D1CRCSR[15]), .A1(n10460), .B0(n10018), .B1(D1CRCSR[14]), 
        .Y(D1CRCSR5432_15_) );
  AO22X1 U6621 ( .A0(D0CRCSR[1]), .A1(n10461), .B0(n10367), .B1(D0CRCSR[0]), 
        .Y(n9063) );
  AO22X1 U6622 ( .A0(D0CRCSR[14]), .A1(n10460), .B0(D0CRCSR[13]), .B1(n10367), 
        .Y(n9050) );
  AO22X1 U6623 ( .A0(D0CRCSR[13]), .A1(n10460), .B0(D0CRCSR[12]), .B1(n10367), 
        .Y(n9051) );
  AO22X1 U6624 ( .A0(D0CRCSR[11]), .A1(n10461), .B0(D0CRCSR[10]), .B1(n10367), 
        .Y(n9053) );
  AO22X1 U6625 ( .A0(D0CRCSR[10]), .A1(n10461), .B0(D0CRCSR[9]), .B1(n10367), 
        .Y(n9054) );
  AO22X1 U6626 ( .A0(D0CRCSR[9]), .A1(n10460), .B0(D0CRCSR[8]), .B1(n10367), 
        .Y(n9055) );
  AO22X1 U6627 ( .A0(D0CRCSR[8]), .A1(n10461), .B0(D0CRCSR[7]), .B1(n10367), 
        .Y(n9056) );
  AO22X1 U6628 ( .A0(D0CRCSR[7]), .A1(n9451), .B0(D0CRCSR[6]), .B1(n10367), 
        .Y(n9057) );
  AO22X1 U6629 ( .A0(D0CRCSR[6]), .A1(n10460), .B0(D0CRCSR[5]), .B1(n10367), 
        .Y(n9058) );
  AO22X1 U6630 ( .A0(D0CRCSR[4]), .A1(n10460), .B0(D0CRCSR[3]), .B1(n10367), 
        .Y(n9060) );
  AO22X1 U6631 ( .A0(D0CRCSR[3]), .A1(n10460), .B0(D0CRCSR[2]), .B1(n10367), 
        .Y(n9061) );
  AO22X1 U6632 ( .A0(D0CRCSR[2]), .A1(n10461), .B0(D0CRCSR[1]), .B1(n10367), 
        .Y(n9062) );
  AO22X1 U6633 ( .A0(BusyCnt[3]), .A1(n9662), .B0(NextBusyCnt6524_3_), .B1(
        n9663), .Y(n9019) );
  XNOR2X1 U1_A_3 ( .A(BusyCnt[3]), .B(carry_3_), .Y(NextBusyCnt6524_3_) );
  AO22X1 U6634 ( .A0(BusyCnt[2]), .A1(n9662), .B0(NextBusyCnt6524_2_), .B1(
        n9663), .Y(n9020) );
  XNOR2X1 U1_A_2 ( .A(BusyCnt[2]), .B(carry_2_), .Y(NextBusyCnt6524_2_) );
  AO22X1 U6635 ( .A0(BusyCnt[1]), .A1(n9662), .B0(NextBusyCnt6524_1_), .B1(
        n9663), .Y(n9021) );
  XNOR2X1 U1_A_1 ( .A(BusyCnt[1]), .B(BusyCnt[0]), .Y(NextBusyCnt6524_1_) );
  AO22X1 U6636 ( .A0(D1CRCSR[6]), .A1(n10460), .B0(D1CRCSR[5]), .B1(n10473), 
        .Y(n9073) );
  AO22X1 U6637 ( .A0(D3CRCSR[13]), .A1(n10461), .B0(D3CRCSR[12]), .B1(n10473), 
        .Y(n9096) );
  AO22X1 U6638 ( .A0(D4CRCSR[13]), .A1(n9451), .B0(D4CRCSR[12]), .B1(n10473), 
        .Y(n9111) );
  AO22X1 U6639 ( .A0(D1CRCSR[9]), .A1(n10460), .B0(D1CRCSR[8]), .B1(n10473), 
        .Y(n9070) );
  AO22X1 U6640 ( .A0(D1CRCSR[3]), .A1(n10460), .B0(D1CRCSR[2]), .B1(n10474), 
        .Y(n9076) );
  AO22X1 U6641 ( .A0(D1CRCSR[1]), .A1(n10461), .B0(D1CRCSR[0]), .B1(n10475), 
        .Y(n9078) );
  AO22X1 U6642 ( .A0(D2CRCSR[14]), .A1(n10461), .B0(D2CRCSR[13]), .B1(n10474), 
        .Y(n9080) );
  AO22X1 U6643 ( .A0(D2CRCSR[11]), .A1(n10461), .B0(D2CRCSR[10]), .B1(n10475), 
        .Y(n9083) );
  AO22X1 U6644 ( .A0(D2CRCSR[8]), .A1(n10461), .B0(D2CRCSR[7]), .B1(n10475), 
        .Y(n9086) );
  AO22X1 U6645 ( .A0(D2CRCSR[3]), .A1(n10460), .B0(D2CRCSR[2]), .B1(n10474), 
        .Y(n9091) );
  AO22X1 U6646 ( .A0(D2CRCSR[2]), .A1(n10461), .B0(D2CRCSR[1]), .B1(n10473), 
        .Y(n9092) );
  AO22X1 U6647 ( .A0(D3CRCSR[14]), .A1(n10461), .B0(D3CRCSR[13]), .B1(n10474), 
        .Y(n9095) );
  AO22X1 U6648 ( .A0(D3CRCSR[10]), .A1(n9451), .B0(D3CRCSR[9]), .B1(n10474), 
        .Y(n9099) );
  AO22X1 U6649 ( .A0(D3CRCSR[7]), .A1(n9451), .B0(D3CRCSR[6]), .B1(n10474), 
        .Y(n9102) );
  AO22X1 U6650 ( .A0(D3CRCSR[4]), .A1(n9451), .B0(D3CRCSR[3]), .B1(n10475), 
        .Y(n9105) );
  AO22X1 U6651 ( .A0(D3CRCSR[1]), .A1(n10461), .B0(D3CRCSR[0]), .B1(n10475), 
        .Y(n9108) );
  AO22X1 U6652 ( .A0(D5CRCSR[9]), .A1(n10460), .B0(D5CRCSR[8]), .B1(n10473), 
        .Y(n9130) );
  AO22X1 U6653 ( .A0(D7CRCSR[10]), .A1(n9451), .B0(D7CRCSR[9]), .B1(n10474), 
        .Y(n9159) );
  AO22X1 U6654 ( .A0(D1CRCSR[14]), .A1(n9451), .B0(D1CRCSR[13]), .B1(n10474), 
        .Y(n9065) );
  AO22X1 U6655 ( .A0(D1CRCSR[13]), .A1(n10460), .B0(D1CRCSR[12]), .B1(n10475), 
        .Y(n9066) );
  AO22X1 U6656 ( .A0(D1CRCSR[11]), .A1(n10461), .B0(D1CRCSR[10]), .B1(n10473), 
        .Y(n9068) );
  AO22X1 U6657 ( .A0(D1CRCSR[10]), .A1(n10461), .B0(D1CRCSR[9]), .B1(n10474), 
        .Y(n9069) );
  AO22X1 U6658 ( .A0(D1CRCSR[8]), .A1(n10461), .B0(D1CRCSR[7]), .B1(n10475), 
        .Y(n9071) );
  AO22X1 U6659 ( .A0(D1CRCSR[7]), .A1(n9451), .B0(D1CRCSR[6]), .B1(n10474), 
        .Y(n9072) );
  AO22X1 U6660 ( .A0(D1CRCSR[4]), .A1(n10460), .B0(D1CRCSR[3]), .B1(n10475), 
        .Y(n9075) );
  AO22X1 U6661 ( .A0(D1CRCSR[2]), .A1(n10461), .B0(D1CRCSR[1]), .B1(n10473), 
        .Y(n9077) );
  AO22X1 U6662 ( .A0(D2CRCSR[13]), .A1(n10460), .B0(D2CRCSR[12]), .B1(n10473), 
        .Y(n9081) );
  AO22X1 U6663 ( .A0(D2CRCSR[10]), .A1(n9451), .B0(D2CRCSR[9]), .B1(n10474), 
        .Y(n9084) );
  AO22X1 U6664 ( .A0(D2CRCSR[9]), .A1(n10460), .B0(D2CRCSR[8]), .B1(n10473), 
        .Y(n9085) );
  AO22X1 U6665 ( .A0(D2CRCSR[7]), .A1(n9451), .B0(D2CRCSR[6]), .B1(n10474), 
        .Y(n9087) );
  AO22X1 U6666 ( .A0(D2CRCSR[6]), .A1(n10460), .B0(D2CRCSR[5]), .B1(n10473), 
        .Y(n9088) );
  AO22X1 U6667 ( .A0(D2CRCSR[4]), .A1(n10460), .B0(D2CRCSR[3]), .B1(n10475), 
        .Y(n9090) );
  AO22X1 U6668 ( .A0(D2CRCSR[1]), .A1(n10461), .B0(D2CRCSR[0]), .B1(n10475), 
        .Y(n9093) );
  AO22X1 U6669 ( .A0(D3CRCSR[11]), .A1(n10461), .B0(D3CRCSR[10]), .B1(n10475), 
        .Y(n9098) );
  AO22X1 U6670 ( .A0(D3CRCSR[9]), .A1(n10460), .B0(D3CRCSR[8]), .B1(n10473), 
        .Y(n9100) );
  AO22X1 U6671 ( .A0(D3CRCSR[8]), .A1(n9451), .B0(D3CRCSR[7]), .B1(n10475), 
        .Y(n9101) );
  AO22X1 U6672 ( .A0(D3CRCSR[6]), .A1(n9451), .B0(D3CRCSR[5]), .B1(n10473), 
        .Y(n9103) );
  AO22X1 U6673 ( .A0(D3CRCSR[3]), .A1(n10460), .B0(D3CRCSR[2]), .B1(n10474), 
        .Y(n9106) );
  AO22X1 U6674 ( .A0(D3CRCSR[2]), .A1(n10461), .B0(D3CRCSR[1]), .B1(n10473), 
        .Y(n9107) );
  AO22X1 U6675 ( .A0(D4CRCSR[14]), .A1(n10461), .B0(D4CRCSR[13]), .B1(n10474), 
        .Y(n9110) );
  AO22X1 U6676 ( .A0(D4CRCSR[11]), .A1(n10461), .B0(D4CRCSR[10]), .B1(n10475), 
        .Y(n9113) );
  AO22X1 U6677 ( .A0(D4CRCSR[10]), .A1(n9451), .B0(D4CRCSR[9]), .B1(n10474), 
        .Y(n9114) );
  AO22X1 U6678 ( .A0(D4CRCSR[9]), .A1(n10460), .B0(D4CRCSR[8]), .B1(n10473), 
        .Y(n9115) );
  AO22X1 U6679 ( .A0(D4CRCSR[8]), .A1(n10461), .B0(D4CRCSR[7]), .B1(n10475), 
        .Y(n9116) );
  AO22X1 U6680 ( .A0(D4CRCSR[7]), .A1(n9451), .B0(D4CRCSR[6]), .B1(n10474), 
        .Y(n9117) );
  AO22X1 U6681 ( .A0(D4CRCSR[6]), .A1(n10460), .B0(D4CRCSR[5]), .B1(n10473), 
        .Y(n9118) );
  AO22X1 U6682 ( .A0(D4CRCSR[4]), .A1(n9451), .B0(D4CRCSR[3]), .B1(n10475), 
        .Y(n9120) );
  AO22X1 U6683 ( .A0(D4CRCSR[3]), .A1(n10460), .B0(D4CRCSR[2]), .B1(n10474), 
        .Y(n9121) );
  AO22X1 U6684 ( .A0(D4CRCSR[2]), .A1(n10461), .B0(D4CRCSR[1]), .B1(n10473), 
        .Y(n9122) );
  AO22X1 U6685 ( .A0(D4CRCSR[1]), .A1(n9451), .B0(D4CRCSR[0]), .B1(n10475), 
        .Y(n9123) );
  AO22X1 U6686 ( .A0(D5CRCSR[14]), .A1(n10461), .B0(D5CRCSR[13]), .B1(n10474), 
        .Y(n9125) );
  AO22X1 U6687 ( .A0(D5CRCSR[13]), .A1(n9451), .B0(D5CRCSR[12]), .B1(n10473), 
        .Y(n9126) );
  AO22X1 U6688 ( .A0(D5CRCSR[11]), .A1(n10461), .B0(D5CRCSR[10]), .B1(n10475), 
        .Y(n9128) );
  AO22X1 U6689 ( .A0(D5CRCSR[10]), .A1(n9451), .B0(D5CRCSR[9]), .B1(n10474), 
        .Y(n9129) );
  AO22X1 U6690 ( .A0(D5CRCSR[8]), .A1(n10461), .B0(D5CRCSR[7]), .B1(n10475), 
        .Y(n9131) );
  AO22X1 U6691 ( .A0(D5CRCSR[7]), .A1(n9451), .B0(D5CRCSR[6]), .B1(n10474), 
        .Y(n9132) );
  AO22X1 U6692 ( .A0(D5CRCSR[6]), .A1(n10460), .B0(D5CRCSR[5]), .B1(n10473), 
        .Y(n9133) );
  AO22X1 U6693 ( .A0(D5CRCSR[4]), .A1(n9451), .B0(D5CRCSR[3]), .B1(n10475), 
        .Y(n9135) );
  AO22X1 U6694 ( .A0(D5CRCSR[3]), .A1(n10460), .B0(D5CRCSR[2]), .B1(n10474), 
        .Y(n9136) );
  AO22X1 U6695 ( .A0(D5CRCSR[2]), .A1(n10461), .B0(D5CRCSR[1]), .B1(n10473), 
        .Y(n9137) );
  AO22X1 U6696 ( .A0(D5CRCSR[1]), .A1(n9451), .B0(D5CRCSR[0]), .B1(n10475), 
        .Y(n9138) );
  AO22X1 U6697 ( .A0(D6CRCSR[14]), .A1(n10461), .B0(D6CRCSR[13]), .B1(n10474), 
        .Y(n9140) );
  AO22X1 U6698 ( .A0(D6CRCSR[13]), .A1(n9451), .B0(D6CRCSR[12]), .B1(n10473), 
        .Y(n9141) );
  AO22X1 U6699 ( .A0(D6CRCSR[11]), .A1(n10461), .B0(D6CRCSR[10]), .B1(n10475), 
        .Y(n9143) );
  AO22X1 U6700 ( .A0(D6CRCSR[10]), .A1(n9451), .B0(D6CRCSR[9]), .B1(n10475), 
        .Y(n9144) );
  AO22X1 U6701 ( .A0(D6CRCSR[9]), .A1(n10460), .B0(D6CRCSR[8]), .B1(n10473), 
        .Y(n9145) );
  AO22X1 U6702 ( .A0(D6CRCSR[8]), .A1(n9451), .B0(D6CRCSR[7]), .B1(n10475), 
        .Y(n9146) );
  AO22X1 U6703 ( .A0(D6CRCSR[7]), .A1(n10460), .B0(D6CRCSR[6]), .B1(n10474), 
        .Y(n9147) );
  AO22X1 U6704 ( .A0(D6CRCSR[6]), .A1(n9451), .B0(D6CRCSR[5]), .B1(n10473), 
        .Y(n9148) );
  AO22X1 U6705 ( .A0(D6CRCSR[4]), .A1(n10461), .B0(D6CRCSR[3]), .B1(n10475), 
        .Y(n9150) );
  AO22X1 U6706 ( .A0(D6CRCSR[3]), .A1(n10460), .B0(D6CRCSR[2]), .B1(n10474), 
        .Y(n9151) );
  AO22X1 U6707 ( .A0(D6CRCSR[2]), .A1(n9451), .B0(D6CRCSR[1]), .B1(n10473), 
        .Y(n9152) );
  AO22X1 U6708 ( .A0(D6CRCSR[1]), .A1(n10461), .B0(D6CRCSR[0]), .B1(n10475), 
        .Y(n9153) );
  AO22X1 U6709 ( .A0(D7CRCSR[14]), .A1(n10460), .B0(D7CRCSR[13]), .B1(n10474), 
        .Y(n9155) );
  AO22X1 U6710 ( .A0(D7CRCSR[13]), .A1(n10461), .B0(D7CRCSR[12]), .B1(n10473), 
        .Y(n9156) );
  AO22X1 U6711 ( .A0(D7CRCSR[11]), .A1(n10461), .B0(D7CRCSR[10]), .B1(n10475), 
        .Y(n9158) );
  AO22X1 U6712 ( .A0(D7CRCSR[9]), .A1(n10461), .B0(D7CRCSR[8]), .B1(n10473), 
        .Y(n9160) );
  AO22X1 U6713 ( .A0(D7CRCSR[8]), .A1(n10460), .B0(D7CRCSR[7]), .B1(n10475), 
        .Y(n9161) );
  AO22X1 U6714 ( .A0(D7CRCSR[7]), .A1(n10461), .B0(D7CRCSR[6]), .B1(n10474), 
        .Y(n9162) );
  AO22X1 U6715 ( .A0(D7CRCSR[6]), .A1(n10460), .B0(D7CRCSR[5]), .B1(n10473), 
        .Y(n9163) );
  AO22X1 U6716 ( .A0(D7CRCSR[4]), .A1(n10460), .B0(D7CRCSR[3]), .B1(n10475), 
        .Y(n9165) );
  AO22X1 U6717 ( .A0(D7CRCSR[3]), .A1(n10460), .B0(D7CRCSR[2]), .B1(n10474), 
        .Y(n9166) );
  AO22X1 U6718 ( .A0(D7CRCSR[2]), .A1(n10461), .B0(D7CRCSR[1]), .B1(n10473), 
        .Y(n9167) );
  AO22X1 U6719 ( .A0(D7CRCSR[1]), .A1(n9451), .B0(n10474), .B1(D7CRCSR[0]), 
        .Y(n9168) );
  OAI2BB1X1 U6720 ( .A0N(n9532), .A1N(n10306), .B0(n9541), .Y(n9052) );
  AOI32X1 U6721 ( .A0(n9535), .A1(D0CRCSR[11]), .A2(n9539), .B0(D0CRCSR[12]), 
        .B1(n10461), .Y(n9541) );
  OAI2BB1X1 U6722 ( .A0N(n9518), .A1N(n10285), .B0(n9523), .Y(n9067) );
  AOI32X1 U6723 ( .A0(D1CRCSR[11]), .A1(n10459), .A2(n9521), .B0(D1CRCSR[12]), 
        .B1(n10461), .Y(n9523) );
  OAI2BB1X1 U6724 ( .A0N(n9518), .A1N(n10286), .B0(n9520), .Y(n9074) );
  AOI32X1 U6725 ( .A0(D1CRCSR[4]), .A1(n10458), .A2(n9521), .B0(D1CRCSR[5]), 
        .B1(n9451), .Y(n9520) );
  OAI2BB1X1 U6726 ( .A0N(n9508), .A1N(n10287), .B0(n9513), .Y(n9082) );
  AOI32X1 U6727 ( .A0(D2CRCSR[11]), .A1(n10458), .A2(n9511), .B0(D2CRCSR[12]), 
        .B1(n10460), .Y(n9513) );
  OAI2BB1X1 U6728 ( .A0N(n9508), .A1N(n10288), .B0(n9510), .Y(n9089) );
  AOI32X1 U6729 ( .A0(D2CRCSR[4]), .A1(n10459), .A2(n9511), .B0(D2CRCSR[5]), 
        .B1(n9451), .Y(n9510) );
  OAI2BB1X1 U6730 ( .A0N(n9498), .A1N(n10289), .B0(n9503), .Y(n9097) );
  AOI32X1 U6731 ( .A0(D3CRCSR[11]), .A1(n10458), .A2(n9501), .B0(D3CRCSR[12]), 
        .B1(n10460), .Y(n9503) );
  OAI2BB1X1 U6732 ( .A0N(n9498), .A1N(n10290), .B0(n9500), .Y(n9104) );
  AOI32X1 U6733 ( .A0(D3CRCSR[4]), .A1(n10459), .A2(n9501), .B0(D3CRCSR[5]), 
        .B1(n10461), .Y(n9500) );
  OAI2BB1X1 U6734 ( .A0N(n9488), .A1N(n10368), .B0(n9493), .Y(n9112) );
  AOI32X1 U6735 ( .A0(D4CRCSR[11]), .A1(n10459), .A2(n9491), .B0(D4CRCSR[12]), 
        .B1(n10460), .Y(n9493) );
  OAI2BB1X1 U6736 ( .A0N(n9488), .A1N(n10212), .B0(n9490), .Y(n9119) );
  AOI32X1 U6737 ( .A0(D4CRCSR[4]), .A1(n10458), .A2(n9491), .B0(D4CRCSR[5]), 
        .B1(n10461), .Y(n9490) );
  OAI2BB1X1 U6738 ( .A0N(n9478), .A1N(n10250), .B0(n9483), .Y(n9127) );
  AOI32X1 U6739 ( .A0(D5CRCSR[11]), .A1(n10458), .A2(n9481), .B0(D5CRCSR[12]), 
        .B1(n9451), .Y(n9483) );
  OAI2BB1X1 U6740 ( .A0N(n9478), .A1N(n10303), .B0(n9480), .Y(n9134) );
  AOI32X1 U6741 ( .A0(D5CRCSR[4]), .A1(n10459), .A2(n9481), .B0(D5CRCSR[5]), 
        .B1(n10461), .Y(n9480) );
  OAI2BB1X1 U6742 ( .A0N(n9468), .A1N(n10215), .B0(n9473), .Y(n9142) );
  AOI32X1 U6743 ( .A0(D6CRCSR[11]), .A1(n10458), .A2(n9471), .B0(D6CRCSR[12]), 
        .B1(n10460), .Y(n9473) );
  OAI2BB1X1 U6744 ( .A0N(n9468), .A1N(n10216), .B0(n9470), .Y(n9149) );
  AOI32X1 U6745 ( .A0(D6CRCSR[4]), .A1(n10458), .A2(n9471), .B0(D6CRCSR[5]), 
        .B1(n9451), .Y(n9470) );
  OAI2BB1X1 U6746 ( .A0N(n9452), .A1N(n10213), .B0(n9459), .Y(n9157) );
  AOI32X1 U6747 ( .A0(D7CRCSR[11]), .A1(n10459), .A2(n9457), .B0(D7CRCSR[12]), 
        .B1(n9451), .Y(n9459) );
  OAI2BB1X1 U6748 ( .A0N(n9452), .A1N(n10214), .B0(n9455), .Y(n9164) );
  AOI32X1 U6749 ( .A0(D7CRCSR[4]), .A1(n10458), .A2(n9457), .B0(D7CRCSR[5]), 
        .B1(n10461), .Y(n9455) );
  OAI2BB1X1 U6750 ( .A0N(n9532), .A1N(n10372), .B0(n9538), .Y(n9059) );
  AOI32X1 U6751 ( .A0(n9535), .A1(D0CRCSR[4]), .A2(n9539), .B0(D0CRCSR[5]), 
        .B1(n9451), .Y(n9538) );
  OAI32X1 U6752 ( .A0(n9337), .A1(SDreset), .A2(DATAState[5]), .B0(n9338), 
        .B1(n10432), .Y(n9180) );
  INVX1 U6753 ( .A(n9338), .Y(n9337) );
  OAI31X1 U6754 ( .A0(n9340), .A1(AbortCmdSent), .A2(n9341), .B0(n9342), .Y(
        n9338) );
  OAI32X1 U6755 ( .A0(n10198), .A1(SDreset), .A2(DATIN[0]), .B0(n10458), .B1(
        n10199), .Y(BusyState6570_1_) );
  OA21X2 U6756 ( .A0(n9555), .A1(n9926), .B0(n10199), .Y(n10198) );
  OAI32X1 U6757 ( .A0(n9446), .A1(n9447), .A2(n9448), .B0(SDreset), .B1(n9449), 
        .Y(n9170) );
  NAND2BX1 U6758 ( .AN(SDreset), .B(AbortCmdSent), .Y(n9447) );
  INVX1 U6759 ( .A(n9444), .Y(n9448) );
  NAND2BX1 U6760 ( .AN(n9450), .B(AbortCmd), .Y(n9449) );
  OAI2BB1X1 U6761 ( .A0N(BitCnt_0_), .A1N(n9765), .B0(n9755), .Y(n9763) );
  OAI221X1 U6762 ( .A0(SDreset), .A1(n9666), .B0(n10458), .B1(n9926), .C0(
        n10200), .Y(BusyState6570_0_) );
  OAI31X1 U6763 ( .A0(n10201), .A1(BusyCnt[1]), .A2(n10423), .B0(n10202), .Y(
        n10200) );
  NAND3BX1 U6764 ( .AN(BusyCnt[4]), .B(n10275), .C(n10340), .Y(n10201) );
  NOR3BX1 U6765 ( .AN(n9295), .B(n9926), .C(n9368), .Y(n10202) );
  AND4X1 U6766 ( .A(n9921), .B(n9922), .C(n9923), .D(n9924), .Y(NoBusySet6582)
         );
  NOR2BX1 U6767 ( .AN(BusyCnt[0]), .B(BusyCnt[1]), .Y(n9921) );
  INVX1 U6768 ( .A(n9926), .Y(n9922) );
  AND4X1 U6769 ( .A(n10340), .B(n10275), .C(n10413), .D(n9295), .Y(n9924) );
  AO21X1 U6770 ( .A0(D1CRCSR[0]), .A1(n10460), .B0(n9518), .Y(n9079) );
  AO21X1 U6771 ( .A0(D2CRCSR[0]), .A1(n9451), .B0(n9508), .Y(n9094) );
  AO21X1 U6772 ( .A0(D3CRCSR[0]), .A1(n10461), .B0(n9498), .Y(n9109) );
  AO21X1 U6773 ( .A0(D4CRCSR[0]), .A1(n9451), .B0(n9488), .Y(n9124) );
  AO21X1 U6774 ( .A0(D5CRCSR[0]), .A1(n10461), .B0(n9478), .Y(n9139) );
  AO21X1 U6775 ( .A0(D6CRCSR[0]), .A1(n10461), .B0(n9468), .Y(n9154) );
  AO21X1 U6776 ( .A0(D7CRCSR[0]), .A1(n9451), .B0(n9452), .Y(n9169) );
  AOI221X1 U6777 ( .A0(n9385), .A1(n9381), .B0(n9386), .B1(DATIN[0]), .C0(
        n9387), .Y(n9373) );
  OAI32X1 U6778 ( .A0(n9388), .A1(CRCStatusGet), .A2(BusyStatus), .B0(DATIN[0]), .B1(CRCStatusGet), .Y(n9387) );
  INVX1 U6779 ( .A(n9389), .Y(n9385) );
  AOI33X1 U6780 ( .A0(n9267), .A1(n9254), .A2(n9268), .B0(n9254), .B1(n9269), 
        .B2(n9270), .Y(n9266) );
  NOR3BX1 U6781 ( .AN(n10322), .B(n9273), .C(DATIN[0]), .Y(n9268) );
  NOR2BX1 U6782 ( .AN(n10457), .B(n9261), .Y(n9267) );
  NOR2BX1 U6783 ( .AN(BusyStatus), .B(n9271), .Y(n9269) );
  AOI31X1 U6784 ( .A0(StopBit), .A1(n9302), .A2(n9288), .B0(n9303), .Y(n9301)
         );
  OAI211X1 U6785 ( .A0(n9305), .A1(n9306), .B0(TxCRCCal), .C0(n9307), .Y(n9302) );
  INVX1 U6786 ( .A(n9304), .Y(n9303) );
  NAND4BX1 U6787 ( .AN(n9941), .B(n9942), .C(n9943), .D(n9944), .Y(n9408) );
  NAND4BX1 U6788 ( .AN(BlkNumCnt[9]), .B(n10264), .C(n10394), .D(n10326), .Y(
        n9941) );
  AND4X1 U6789 ( .A(n10232), .B(n10396), .C(n10328), .D(n10266), .Y(n9942) );
  AND4X1 U6790 ( .A(n10230), .B(n10395), .C(n10327), .D(n10265), .Y(n9943) );
  NAND3BX1 U6791 ( .AN(CRCStatusCnt_2_), .B(n10321), .C(n10451), .Y(n9417) );
  NAND3BX1 U6792 ( .AN(CRCStatusCnt_2_), .B(n10451), .C(CRCStatusCnt_1_), .Y(
        n9259) );
  NAND2BX1 U6793 ( .AN(TxCRCSend), .B(n9542), .Y(n9531) );
  NAND3BX1 U6794 ( .AN(DATIN[0]), .B(CRCStatusGet), .C(n9254), .Y(n9258) );
  NAND3BX1 U6795 ( .AN(n10161), .B(n10387), .C(StateCnt_0_), .Y(n9341) );
  NAND2BX1 U6796 ( .AN(BusyStatus), .B(n9388), .Y(n9261) );
  NAND2BX1 U6797 ( .AN(RxCRCCal), .B(n10324), .Y(n9546) );
  NAND2BX1 U6798 ( .AN(MMCPlus), .B(n9654), .Y(n9660) );
  NAND2BX1 U6799 ( .AN(WORDCnt[1]), .B(n10263), .Y(n9233) );
  OR2X1 U6800 ( .A(StartBit), .B(n9289), .Y(n9357) );
  NAND2BX1 U6801 ( .AN(DATAState[0]), .B(n10447), .Y(n9438) );
  AO21X1 U6802 ( .A0(DATIN[0]), .A1(n9305), .B0(n10322), .Y(n9245) );
  AO21X1 U6803 ( .A0(DatMode[1]), .A1(DatCtrlIdle), .B0(SDreset), .Y(n9243) );
  INVX1 U6804 ( .A(DATIN[0]), .Y(n9368) );
  AND4X1 U6805 ( .A(n10267), .B(n10329), .C(n10397), .D(n10231), .Y(n9944) );
  AOI211X1 U6806 ( .A0(n9276), .A1(CRCStatusCnt_0_), .B0(CRCStatusGet), .C0(
        n9277), .Y(n9275) );
  NOR2BX1 U6807 ( .AN(n10321), .B(CRCStatusCnt_2_), .Y(n9276) );
  INVX1 U6808 ( .A(DatMode[0]), .Y(n9238) );
  OR2X1 U1_B_110 ( .A(BlkNumCnt[1]), .B(BlkNumCnt[0]), .Y(carry26) );
  OR2X1 U1_B_113 ( .A(BlkDatCnt[1]), .B(BlkDatCnt[0]), .Y(carry12) );
  OR2X1 U1_B_71 ( .A(BlkNumCnt[7]), .B(carry21), .Y(carry20) );
  OR2X1 U1_B_81 ( .A(BlkNumCnt[8]), .B(carry20), .Y(carry19) );
  OR2X1 U1_B_101 ( .A(BlkNumCnt[10]), .B(carry18), .Y(carry17) );
  OR2X1 U1_B_112 ( .A(BlkNumCnt[11]), .B(carry17), .Y(carry16) );
  OR2X1 U1_B_121 ( .A(BlkNumCnt[12]), .B(carry16), .Y(carry15) );
  OR2X1 U1_B_131 ( .A(BlkNumCnt[13]), .B(carry15), .Y(carry14) );
  OR2X1 U1_B_32 ( .A(BlkNumCnt[3]), .B(carry25), .Y(carry24) );
  OR2X1 U1_B_42 ( .A(BlkDatCnt[4]), .B(carry10), .Y(carry9) );
  OR2X1 U1_B_41 ( .A(BlkNumCnt[4]), .B(carry24), .Y(carry23) );
  OR2X1 U1_B_51 ( .A(BlkNumCnt[5]), .B(carry23), .Y(carry22) );
  OR2X1 U1_B_61 ( .A(BlkNumCnt[6]), .B(carry22), .Y(carry21) );
  OR2X1 U1_B_82 ( .A(BlkDatCnt[8]), .B(carry6), .Y(carry5) );
  OR2X1 U1_B_102 ( .A(BlkDatCnt[10]), .B(carry4), .Y(carry3) );
  OR2X1 U1_B_122 ( .A(BlkDatCnt[12]), .B(carry2), .Y(carry1) );
  OR2X1 U1_B_132 ( .A(BlkDatCnt[13]), .B(carry1), .Y(carry0) );
  OR2X1 U1_B_212 ( .A(BlkDatCnt[2]), .B(carry12), .Y(carry11) );
  OR2X1 U1_B_33 ( .A(BlkDatCnt[3]), .B(carry11), .Y(carry10) );
  OR2X1 U1_B_52 ( .A(BlkDatCnt[5]), .B(carry9), .Y(carry8) );
  OR2X1 U1_B_62 ( .A(BlkDatCnt[6]), .B(carry8), .Y(carry7) );
  OR2X1 U1_B_72 ( .A(BlkDatCnt[7]), .B(carry7), .Y(carry6) );
  OR2X1 U1_B_114 ( .A(BlkDatCnt[11]), .B(carry3), .Y(carry2) );
  OR2X1 U1_B_210 ( .A(BlkNumCnt[2]), .B(carry26), .Y(carry25) );
  OR2X1 U1_B_92 ( .A(BlkDatCnt[9]), .B(carry5), .Y(carry4) );
  OR2X1 U1_B_91 ( .A(BlkNumCnt[9]), .B(carry19), .Y(carry18) );
  INVX1 U6809 ( .A(DatMode[1]), .Y(n9746) );
  INVX1 U6810 ( .A(FIFOReadData[24]), .Y(n9566) );
  OAI32X1 U6811 ( .A0(n9240), .A1(SDreset), .A2(n9238), .B0(n9243), .B1(n8897), 
        .Y(n9190) );
  INVX1 U6812 ( .A(FIFOReadData[30]), .Y(n9994) );
  INVX1 U6813 ( .A(FIFOReadData[28]), .Y(n10002) );
  INVX1 U6814 ( .A(FIFOReadData[29]), .Y(n9998) );
  INVX1 U6815 ( .A(FIFOReadData[31]), .Y(n9990) );
  OA21X2 U6816 ( .A0(CRCStatusGet), .A1(n9417), .B0(n10392), .Y(n9441) );
  INVX1 U6817 ( .A(FIFOReadData[3]), .Y(n9580) );
  INVX1 U6818 ( .A(FIFOReadData[2]), .Y(n9577) );
  INVX1 U6819 ( .A(FIFOReadData[1]), .Y(n9571) );
  INVX1 U6820 ( .A(FIFOReadData[0]), .Y(n9563) );
  AOI33X1 U6821 ( .A0(n9775), .A1(n9556), .A2(n9776), .B0(n9752), .B1(n9655), 
        .B2(n9777), .Y(n9773) );
  NOR2BX1 U6822 ( .AN(NibbleCnt), .B(n10387), .Y(n9775) );
  AO21X1 U6823 ( .A0(n9351), .A1(n9778), .B0(n9779), .Y(n9777) );
  OAI31X1 U6824 ( .A0(n9780), .A1(Abort), .A2(n10324), .B0(n9307), .Y(n9776)
         );
  AOI21X1 U6825 ( .A0(BusyStatus), .A1(DATIN[0]), .B0(n9319), .Y(n10452) );
  INVX1 U6826 ( .A(RACMD), .Y(n9754) );
  NAND3BX1 U6827 ( .AN(TxCRCSend), .B(n9295), .C(n9546), .Y(n9461) );
  NAND2BX1 U6828 ( .AN(BusyState[1]), .B(BusyState[0]), .Y(n9926) );
  XOR2X1 U6829 ( .A(n9534), .B(D0CRCSR[15]), .Y(n9543) );
  NAND2BX1 U6830 ( .AN(SDreset), .B(BlkDatCntEn), .Y(n9552) );
  XNOR2X1 U1_A_11 ( .A(StateCnt_1_), .B(StateCnt_0_), .Y(StateCnt5261_1_) );
  NAND3BX1 U6831 ( .AN(n9917), .B(n9295), .C(ByteOrder), .Y(n10467) );
  NAND3BX1 U6832 ( .AN(n9917), .B(n9295), .C(ByteOrder), .Y(n10466) );
  AO22X1 U6833 ( .A0(DATOUT[7]), .A1(TxCRCCal), .B0(DATIN[7]), .B1(n10324), 
        .Y(n9460) );
  AO22X1 U6834 ( .A0(DATOUT[1]), .A1(TxCRCCal), .B0(DATIN[1]), .B1(n10324), 
        .Y(n9524) );
  AO22X1 U6835 ( .A0(DATOUT[2]), .A1(TxCRCCal), .B0(DATIN[2]), .B1(n10324), 
        .Y(n9514) );
  AO22X1 U6836 ( .A0(DATOUT[3]), .A1(TxCRCCal), .B0(DATIN[3]), .B1(n10324), 
        .Y(n9504) );
  AO22X1 U6837 ( .A0(DATOUT[4]), .A1(TxCRCCal), .B0(DATIN[4]), .B1(n10324), 
        .Y(n9494) );
  AO22X1 U6838 ( .A0(DATOUT[5]), .A1(TxCRCCal), .B0(DATIN[5]), .B1(n10324), 
        .Y(n9484) );
  AO22X1 U6839 ( .A0(DATOUT[6]), .A1(TxCRCCal), .B0(DATIN[6]), .B1(n10324), 
        .Y(n9474) );
  NAND2BX1 U6840 ( .AN(TxCRCCal), .B(n10411), .Y(n9356) );
  NAND3BX1 U6841 ( .AN(n9917), .B(n9295), .C(ByteOrder), .Y(n9907) );
  OAI2BB2X1 U6842 ( .A0N(n9225), .A1N(n9226), .B0(n10453), .B1(n9226), .Y(
        n9194) );
  AO21X1 U6843 ( .A0(n9228), .A1(n9229), .B0(n9230), .Y(n9226) );
  NAND2BX1 U6844 ( .AN(BusyState[0]), .B(BusyState[1]), .Y(n10199) );
  NAND3BX1 U6845 ( .AN(Abort), .B(BlkDatCntEn), .C(n9229), .Y(n9774) );
  AO22X1 U6846 ( .A0(DATOUT[0]), .A1(TxCRCCal), .B0(DATIN[0]), .B1(n10324), 
        .Y(n9534) );
  INVX1 U6847 ( .A(ByteOrder), .Y(n9918) );
  OR2X1 U1_B_1 ( .A(BusyCnt[1]), .B(BusyCnt[0]), .Y(carry_2_) );
  OR2X1 U1_B_2 ( .A(BusyCnt[2]), .B(carry_2_), .Y(carry_3_) );
  OAI33X1 U6848 ( .A0(SDreset), .A1(n10330), .A2(RxWriteEn), .B0(SDreset), 
        .B1(n10424), .B2(LdDataBuffer), .Y(n9047) );
  OAI222X1 U6849 ( .A0(n10269), .A1(n10465), .B0(n10410), .B1(n10467), .C0(
        n10463), .C1(n8879), .Y(n8898) );
  OAI222X1 U6850 ( .A0(n10270), .A1(n10464), .B0(n10407), .B1(n10466), .C0(
        n10462), .C1(n8878), .Y(n8899) );
  OAI222X1 U6851 ( .A0(n10271), .A1(n10465), .B0(n10408), .B1(n10467), .C0(
        n10463), .C1(n8875), .Y(n8901) );
  OAI222X1 U6852 ( .A0(n10331), .A1(n10464), .B0(n10403), .B1(n10466), .C0(
        n10462), .C1(n8874), .Y(n8902) );
  OAI222X1 U6853 ( .A0(n10337), .A1(n10465), .B0(n10404), .B1(n10467), .C0(
        n10463), .C1(n8872), .Y(n8904) );
  OAI222X1 U6854 ( .A0(n10336), .A1(n10464), .B0(n10405), .B1(n10466), .C0(
        n10462), .C1(n8871), .Y(n8905) );
  OAI222X1 U6855 ( .A0(n10333), .A1(n10465), .B0(n10416), .B1(n10467), .C0(
        n10463), .C1(n8869), .Y(n8907) );
  OAI222X1 U6856 ( .A0(n10268), .A1(n10464), .B0(n10414), .B1(n10466), .C0(
        n10462), .C1(n8868), .Y(n8908) );
  OAI222X1 U6857 ( .A0(n10334), .A1(n10465), .B0(n10401), .B1(n10467), .C0(
        n10463), .C1(n8865), .Y(n8910) );
  OAI222X1 U6858 ( .A0(n10233), .A1(n10464), .B0(n10399), .B1(n10466), .C0(
        n10462), .C1(n8864), .Y(n8911) );
  OAI222X1 U6859 ( .A0(n10335), .A1(n10465), .B0(n10402), .B1(n10467), .C0(
        n10463), .C1(n8862), .Y(n8913) );
  OAI222X1 U6860 ( .A0(n10417), .A1(n10464), .B0(n10272), .B1(n10466), .C0(
        n10462), .C1(n8861), .Y(n8914) );
  OAI222X1 U6861 ( .A0(n10414), .A1(n10465), .B0(n10268), .B1(n10467), .C0(
        n10463), .C1(n8859), .Y(n8916) );
  OAI222X1 U6862 ( .A0(n10415), .A1(n10464), .B0(n10273), .B1(n10466), .C0(
        n10462), .C1(n8858), .Y(n8917) );
  OAI222X1 U6863 ( .A0(n10399), .A1(n10465), .B0(n10233), .B1(n10467), .C0(
        n10463), .C1(n8856), .Y(n8919) );
  OAI222X1 U6864 ( .A0(n10400), .A1(n10464), .B0(n10332), .B1(n10466), .C0(
        n10462), .C1(n8886), .Y(n8920) );
  OAI222X1 U6865 ( .A0(n10410), .A1(n10465), .B0(n10269), .B1(n10467), .C0(
        n10463), .C1(n8884), .Y(n8922) );
  OAI222X1 U6866 ( .A0(n10407), .A1(n10464), .B0(n10270), .B1(n10466), .C0(
        n10462), .C1(n8883), .Y(n8923) );
  OAI222X1 U6867 ( .A0(n10408), .A1(n10465), .B0(n10271), .B1(n10467), .C0(
        n10463), .C1(n8881), .Y(n8925) );
  OAI222X1 U6868 ( .A0(n10403), .A1(n10464), .B0(n10331), .B1(n10466), .C0(
        n10462), .C1(n8880), .Y(n8926) );
  OAI222X1 U6869 ( .A0(n10404), .A1(n10465), .B0(n10337), .B1(n10467), .C0(
        n10463), .C1(n8866), .Y(n8928) );
  OAI222X1 U6870 ( .A0(n10405), .A1(n10464), .B0(n10336), .B1(n10466), .C0(
        n10462), .C1(n8855), .Y(n8929) );
  OAI222X1 U6871 ( .A0(n10274), .A1(n9906), .B0(n10409), .B1(n9907), .C0(n9908), .C1(n8876), .Y(n8900) );
  OAI222X1 U6872 ( .A0(n10338), .A1(n9906), .B0(n10406), .B1(n9907), .C0(
        n10462), .C1(n8873), .Y(n8903) );
  OAI222X1 U6873 ( .A0(n10272), .A1(n9906), .B0(n10417), .B1(n9907), .C0(
        n10463), .C1(n8870), .Y(n8906) );
  OAI222X1 U6874 ( .A0(n10273), .A1(n9906), .B0(n10415), .B1(n9907), .C0(
        n10462), .C1(n8867), .Y(n8909) );
  OAI222X1 U6875 ( .A0(n10332), .A1(n9906), .B0(n10400), .B1(n9907), .C0(
        n10463), .C1(n8863), .Y(n8912) );
  OAI222X1 U6876 ( .A0(n10416), .A1(n9906), .B0(n10333), .B1(n9907), .C0(
        n10462), .C1(n8860), .Y(n8915) );
  OAI222X1 U6877 ( .A0(n10401), .A1(n9906), .B0(n10334), .B1(n9907), .C0(
        n10463), .C1(n8857), .Y(n8918) );
  OAI222X1 U6878 ( .A0(n10402), .A1(n9906), .B0(n10335), .B1(n9907), .C0(
        n10462), .C1(n8885), .Y(n8921) );
  OAI222X1 U6879 ( .A0(n10409), .A1(n9906), .B0(n10274), .B1(n9907), .C0(
        n10463), .C1(n8882), .Y(n8924) );
  OAI222X1 U6880 ( .A0(n10406), .A1(n9906), .B0(n10338), .B1(n9907), .C0(
        n10462), .C1(n8877), .Y(n8927) );
  AO22X1 U6881 ( .A0(TxEmptyDetect), .A1(n9225), .B0(n9225), .B1(n9228), .Y(
        n9192) );
  INVX1 U6882 ( .A(DTST), .Y(n9980) );
  OAI221X1 U6883 ( .A0(neg_CKPulse), .A1(n8894), .B0(n10422), .B1(n9558), .C0(
        n9295), .Y(n8938) );
  OAI221X1 U6884 ( .A0(neg_CKPulse), .A1(n8893), .B0(n10419), .B1(n9558), .C0(
        n9295), .Y(n8939) );
  OAI221X1 U6885 ( .A0(neg_CKPulse), .A1(n8892), .B0(n10420), .B1(n9558), .C0(
        n9295), .Y(n8940) );
  OAI221X1 U6886 ( .A0(neg_CKPulse), .A1(n8891), .B0(n10421), .B1(n9558), .C0(
        n9295), .Y(n8941) );
  OAI221X1 U6887 ( .A0(neg_CKPulse), .A1(n8890), .B0(n10428), .B1(n9558), .C0(
        n9295), .Y(n8942) );
  OAI221X1 U6888 ( .A0(neg_CKPulse), .A1(n8889), .B0(n10429), .B1(n9558), .C0(
        n9295), .Y(n8943) );
  OAI221X1 U6889 ( .A0(neg_CKPulse), .A1(n8888), .B0(n10430), .B1(n9558), .C0(
        n9295), .Y(n8944) );
  OAI221X1 U6890 ( .A0(neg_CKPulse), .A1(n8887), .B0(n10418), .B1(n9558), .C0(
        n9295), .Y(n8945) );
  OAI221X1 U6891 ( .A0(neg_CKPulse), .A1(n8895), .B0(n10431), .B1(n9558), .C0(
        n9295), .Y(n9048) );
  OAI32X1 U6892 ( .A0(SDreset), .A1(n10239), .A2(NibbleCnt), .B0(n9230), .B1(
        n10284), .Y(n9193) );
  OAI31X1 U6893 ( .A0(n9524), .A1(D1CRCSR[15]), .A2(n9461), .B0(n9525), .Y(
        n9521) );
  AOI31X1 U6894 ( .A0(D1CRCSR[15]), .A1(n9524), .A2(n9463), .B0(n10455), .Y(
        n9525) );
  OAI31X1 U6895 ( .A0(n9514), .A1(D2CRCSR[15]), .A2(n9461), .B0(n9515), .Y(
        n9511) );
  AOI31X1 U6896 ( .A0(D2CRCSR[15]), .A1(n9514), .A2(n9463), .B0(n10455), .Y(
        n9515) );
  OAI31X1 U6897 ( .A0(n9504), .A1(D3CRCSR[15]), .A2(n9461), .B0(n9505), .Y(
        n9501) );
  AOI31X1 U6898 ( .A0(D3CRCSR[15]), .A1(n9504), .A2(n9463), .B0(n10455), .Y(
        n9505) );
  OAI31X1 U6899 ( .A0(n9494), .A1(D4CRCSR[15]), .A2(n9461), .B0(n9495), .Y(
        n9491) );
  AOI31X1 U6900 ( .A0(D4CRCSR[15]), .A1(n9494), .A2(n9463), .B0(n10455), .Y(
        n9495) );
  OAI31X1 U6901 ( .A0(n9484), .A1(D5CRCSR[15]), .A2(n9461), .B0(n9485), .Y(
        n9481) );
  AOI31X1 U6902 ( .A0(D5CRCSR[15]), .A1(n9484), .A2(n9463), .B0(n10455), .Y(
        n9485) );
  OAI31X1 U6903 ( .A0(n9474), .A1(D6CRCSR[15]), .A2(n9461), .B0(n9475), .Y(
        n9471) );
  AOI31X1 U6904 ( .A0(D6CRCSR[15]), .A1(n9474), .A2(n9463), .B0(n10455), .Y(
        n9475) );
  OAI31X1 U6905 ( .A0(n9460), .A1(D7CRCSR[15]), .A2(n9461), .B0(n9462), .Y(
        n9457) );
  AOI31X1 U6906 ( .A0(D7CRCSR[15]), .A1(n9460), .A2(n9463), .B0(n10455), .Y(
        n9462) );
  OR2X1 U1_B_3 ( .A(BusyCnt[3]), .B(carry_3_), .Y(carry_4_) );
  NOR2X1 U6907 ( .A(BusyState[1]), .B(BusyState[0]), .Y(BusyChkIdle) );
  NOR2X1 U6908 ( .A(SDreset), .B(n10456), .Y(n10455) );
  INVX1 U6909 ( .A(WideBus), .Y(n9778) );
  INVX1 U6910 ( .A(SDIBSize[4]), .Y(n9720) );
  DFFRX1 DATAState_reg_5_ ( .D(n9173), .CK(PCLK), .RN(nRst), .Q(DATAState[5]), 
        .QN(n10276) );
  DFFRX1 DATAState_reg_4_ ( .D(n9174), .CK(PCLK), .RN(nRst), .Q(DATAState[4]), 
        .QN(n10345) );
  DFFSX1 DATAState_reg_0_ ( .D(n9178), .CK(PCLK), .SN(nRst), .Q(DATAState[0]), 
        .QN(n10208) );
  DFFRX1 StateCnt_reg_0_ ( .D(n9014), .CK(PCLK), .RN(nRst), .Q(StateCnt_0_), 
        .QN(n10389) );
  DFFRX1 DATAState_reg_1_ ( .D(n9177), .CK(PCLK), .RN(nRst), .Q(DATAState[1]), 
        .QN(n10450) );
  DFFRX1 BlkDatCnt_reg_13_ ( .D(n8948), .CK(PCLK), .RN(nRst), .Q(BlkDatCnt[13]), .QN(n10343) );
  DFFRX1 BlkDatCnt_reg_12_ ( .D(n8949), .CK(PCLK), .RN(nRst), .Q(BlkDatCnt[12]), .QN(n10280) );
  DFFRX1 BlkDatCnt_reg_10_ ( .D(n8951), .CK(PCLK), .RN(nRst), .Q(BlkDatCnt[10]), .QN(n10344) );
  DFFRX1 BlkDatCnt_reg_8_ ( .D(n8953), .CK(PCLK), .RN(nRst), .Q(BlkDatCnt[8]), 
        .QN(n10341) );
  DFFRX1 BlkDatCnt_reg_4_ ( .D(n8957), .CK(PCLK), .RN(nRst), .Q(BlkDatCnt[4]), 
        .QN(n10342) );
  DFFRX1 BlkDatCnt_reg_15_ ( .D(n8946), .CK(PCLK), .RN(nRst), .Q(BlkDatCnt[15]), .QN(n10279) );
  DFFRX1 BlkDatCnt_reg_0_ ( .D(n8961), .CK(PCLK), .RN(nRst), .Q(BlkDatCnt[0]), 
        .QN(n10205) );
  DFFRX1 BlkDatCnt_reg_11_ ( .D(n8950), .CK(PCLK), .RN(nRst), .Q(BlkDatCnt[11]), .QN(n10235) );
  DFFRX1 BlkDatCnt_reg_7_ ( .D(n8954), .CK(PCLK), .RN(nRst), .Q(BlkDatCnt[7]), 
        .QN(n10234) );
  DFFRX1 BlkDatCnt_reg_6_ ( .D(n8955), .CK(PCLK), .RN(nRst), .Q(BlkDatCnt[6]), 
        .QN(n10277) );
  DFFRX1 BlkDatCnt_reg_5_ ( .D(n8956), .CK(PCLK), .RN(nRst), .Q(BlkDatCnt[5]), 
        .QN(n10206) );
  DFFRX1 BlkDatCnt_reg_3_ ( .D(n8958), .CK(PCLK), .RN(nRst), .Q(BlkDatCnt[3]), 
        .QN(n10278) );
  DFFRX1 BlkDatCnt_reg_2_ ( .D(n8959), .CK(PCLK), .RN(nRst), .Q(BlkDatCnt[2]), 
        .QN(n10236) );
  DFFRX1 BlkDatCnt_reg_1_ ( .D(n8960), .CK(PCLK), .RN(nRst), .Q(BlkDatCnt[1]), 
        .QN(n10207) );
  DFFRX1 BlkDatCnt_reg_14_ ( .D(n8947), .CK(PCLK), .RN(nRst), .Q(BlkDatCnt[14]), .QN(n10237) );
  DFFRX1 DATAState_reg_6_ ( .D(n9172), .CK(PCLK), .RN(nRst), .Q(DATAState[6]), 
        .QN(n10446) );
  DFFRX1 RxActive_reg ( .D(n9191), .CK(PCLK), .RN(nRst), .Q(RxActive), .QN(
        n8896) );
  DFFRX1 DATAState_reg_3_ ( .D(n9175), .CK(PCLK), .RN(nRst), .Q(DATAState[3]), 
        .QN(n10238) );
  DFFRX1 StateCnt_reg_3_ ( .D(n9011), .CK(PCLK), .RN(nRst), .Q(StateCnt_3_), 
        .QN(n10219) );
  DFFRX1 StateCnt_reg_2_ ( .D(n9012), .CK(PCLK), .RN(nRst), .Q(StateCnt_2_), 
        .QN(n10221) );
  DFFRX1 StateCnt_reg_1_ ( .D(n9013), .CK(PCLK), .RN(nRst), .Q(StateCnt_1_), 
        .QN(n10220) );
  DFFRX1 DATAState_reg_2_ ( .D(n9176), .CK(PCLK), .RN(nRst), .Q(DATAState[2]), 
        .QN(n10448) );
  DFFRX1 TxEmptyDetect_reg ( .D(n9192), .CK(PCLK), .RN(nRst), .Q(TxEmptyDetect), .QN(n10239) );
  DFFRX1 TxEmptyDetect3_reg ( .D(n9194), .CK(PCLK), .RN(nRst), .QN(n10453) );
  DFFRX1 TxEmptyDetect2_reg ( .D(n9193), .CK(PCLK), .RN(nRst), .QN(n10284) );
  DFFRX1 BlkDatCnt_reg_9_ ( .D(n8952), .CK(PCLK), .RN(nRst), .Q(BlkDatCnt[9])
         );
  DFFRX1 StateCnt_reg_10_ ( .D(n9004), .CK(PCLK), .RN(nRst), .Q(StateCnt_10_), 
        .QN(n10252) );
  DFFRX1 StateCnt_reg_9_ ( .D(n9005), .CK(PCLK), .RN(nRst), .Q(StateCnt_9_), 
        .QN(n10224) );
  DFFRX1 StateCnt_reg_8_ ( .D(n9006), .CK(PCLK), .RN(nRst), .Q(StateCnt_8_), 
        .QN(n10253) );
  DFFRX1 StateCnt_reg_7_ ( .D(n9007), .CK(PCLK), .RN(nRst), .Q(StateCnt_7_), 
        .QN(n10374) );
  DFFRX1 StateCnt_reg_6_ ( .D(n9008), .CK(PCLK), .RN(nRst), .Q(StateCnt_6_), 
        .QN(n10310) );
  DFFRX1 StateCnt_reg_5_ ( .D(n9009), .CK(PCLK), .RN(nRst), .Q(StateCnt_5_), 
        .QN(n10251) );
  DFFRX1 StateCnt_reg_4_ ( .D(n9010), .CK(PCLK), .RN(nRst), .Q(StateCnt_4_), 
        .QN(n10308) );
  DFFRX1 D1CRCSR_reg_14_ ( .D(n9065), .CK(PCLK), .RN(nRst), .Q(D1CRCSR[14]), 
        .QN(n10427) );
  DFFRX1 D0CRCSR_reg_15_ ( .D(D0CRCSR5426_15_), .CK(PCLK), .RN(nRst), .Q(
        D0CRCSR[15]), .QN(n10227) );
  DFFRX1 D7CRCSR_reg_15_ ( .D(D7CRCSR5468_15_), .CK(PCLK), .RN(nRst), .Q(
        D7CRCSR[15]), .QN(n10210) );
  DFFRX1 D6CRCSR_reg_15_ ( .D(D6CRCSR5462_15_), .CK(PCLK), .RN(nRst), .Q(
        D6CRCSR[15]), .QN(n10211) );
  DFFRX1 D5CRCSR_reg_15_ ( .D(D5CRCSR5456_15_), .CK(PCLK), .RN(nRst), .Q(
        D5CRCSR[15]), .QN(n10218) );
  DFFRX1 D4CRCSR_reg_15_ ( .D(D4CRCSR5450_15_), .CK(PCLK), .RN(nRst), .Q(
        D4CRCSR[15]), .QN(n10209) );
  DFFRX1 D3CRCSR_reg_15_ ( .D(D3CRCSR5444_15_), .CK(PCLK), .RN(nRst), .Q(
        D3CRCSR[15]), .QN(n10283) );
  DFFRX1 D2CRCSR_reg_15_ ( .D(D2CRCSR5438_15_), .CK(PCLK), .RN(nRst), .Q(
        D2CRCSR[15]), .QN(n10282) );
  DFFRX1 D1CRCSR_reg_15_ ( .D(D1CRCSR5432_15_), .CK(PCLK), .RN(nRst), .Q(
        D1CRCSR[15]), .QN(n10281) );
  DFFRX1 D0CRCSR_reg_14_ ( .D(n9050), .CK(PCLK), .RN(nRst), .Q(D0CRCSR[14]), 
        .QN(n10258) );
  DFFRX1 D0CRCSR_reg_13_ ( .D(n9051), .CK(PCLK), .RN(nRst), .Q(D0CRCSR[13]), 
        .QN(n10384) );
  DFFRX1 D0CRCSR_reg_10_ ( .D(n9054), .CK(PCLK), .RN(nRst), .Q(D0CRCSR[10]), 
        .QN(n10380) );
  DFFRX1 D0CRCSR_reg_9_ ( .D(n9055), .CK(PCLK), .RN(nRst), .Q(D0CRCSR[9]), 
        .QN(n10229) );
  DFFRX1 D0CRCSR_reg_8_ ( .D(n9056), .CK(PCLK), .RN(nRst), .Q(D0CRCSR[8]), 
        .QN(n10261) );
  DFFRX1 D0CRCSR_reg_7_ ( .D(n9057), .CK(PCLK), .RN(nRst), .Q(D0CRCSR[7]), 
        .QN(n10385) );
  DFFRX1 D0CRCSR_reg_6_ ( .D(n9058), .CK(PCLK), .RN(nRst), .Q(D0CRCSR[6]), 
        .QN(n10319) );
  DFFRX1 D0CRCSR_reg_3_ ( .D(n9061), .CK(PCLK), .RN(nRst), .Q(D0CRCSR[3]), 
        .QN(n10386) );
  DFFRX1 D0CRCSR_reg_2_ ( .D(n9062), .CK(PCLK), .RN(nRst), .Q(D0CRCSR[2]) );
  DFFRX1 D0CRCSR_reg_1_ ( .D(n9063), .CK(PCLK), .RN(nRst), .Q(D0CRCSR[1]), 
        .QN(n10305) );
  DFFRX1 D1CRCSR_reg_13_ ( .D(n9066), .CK(PCLK), .RN(nRst), .Q(D1CRCSR[13]) );
  DFFRX1 D1CRCSR_reg_10_ ( .D(n9069), .CK(PCLK), .RN(nRst), .Q(D1CRCSR[10]), 
        .QN(n10355) );
  DFFRX1 D1CRCSR_reg_9_ ( .D(n9070), .CK(PCLK), .RN(nRst), .Q(D1CRCSR[9]) );
  DFFRX1 D1CRCSR_reg_7_ ( .D(n9072), .CK(PCLK), .RN(nRst), .Q(D1CRCSR[7]) );
  DFFRX1 D1CRCSR_reg_6_ ( .D(n9073), .CK(PCLK), .RN(nRst), .Q(D1CRCSR[6]) );
  DFFRX1 D1CRCSR_reg_3_ ( .D(n9076), .CK(PCLK), .RN(nRst), .Q(D1CRCSR[3]), 
        .QN(n10357) );
  DFFRX1 D1CRCSR_reg_1_ ( .D(n9078), .CK(PCLK), .RN(nRst), .Q(D1CRCSR[1]), 
        .QN(n10356) );
  DFFRX1 D2CRCSR_reg_9_ ( .D(n9085), .CK(PCLK), .RN(nRst), .Q(D2CRCSR[9]) );
  DFFRX1 D2CRCSR_reg_8_ ( .D(n9086), .CK(PCLK), .RN(nRst), .Q(D2CRCSR[8]) );
  DFFRX1 D2CRCSR_reg_6_ ( .D(n9088), .CK(PCLK), .RN(nRst), .Q(D2CRCSR[6]), 
        .QN(n10361) );
  DFFRX1 D2CRCSR_reg_3_ ( .D(n9091), .CK(PCLK), .RN(nRst), .Q(D2CRCSR[3]), 
        .QN(n10360) );
  DFFRX1 D3CRCSR_reg_10_ ( .D(n9099), .CK(PCLK), .RN(nRst), .Q(D3CRCSR[10]), 
        .QN(n10359) );
  DFFRX1 D3CRCSR_reg_8_ ( .D(n9101), .CK(PCLK), .RN(nRst), .Q(D3CRCSR[8]) );
  DFFRX1 D3CRCSR_reg_7_ ( .D(n9102), .CK(PCLK), .RN(nRst), .Q(D3CRCSR[7]) );
  DFFRX1 D3CRCSR_reg_2_ ( .D(n9107), .CK(PCLK), .RN(nRst), .Q(D3CRCSR[2]) );
  DFFRX1 D3CRCSR_reg_1_ ( .D(n9108), .CK(PCLK), .RN(nRst), .Q(D3CRCSR[1]) );
  DFFRX1 D4CRCSR_reg_13_ ( .D(n9111), .CK(PCLK), .RN(nRst), .Q(D4CRCSR[13]), 
        .QN(n10260) );
  DFFRX1 D4CRCSR_reg_10_ ( .D(n9114), .CK(PCLK), .RN(nRst), .Q(D4CRCSR[10]), 
        .QN(n10383) );
  DFFRX1 D4CRCSR_reg_9_ ( .D(n9115), .CK(PCLK), .RN(nRst), .Q(D4CRCSR[9]), 
        .QN(n10382) );
  DFFRX1 D4CRCSR_reg_8_ ( .D(n9116), .CK(PCLK), .RN(nRst), .Q(D4CRCSR[8]), 
        .QN(n10318) );
  DFFRX1 D4CRCSR_reg_7_ ( .D(n9117), .CK(PCLK), .RN(nRst), .Q(D4CRCSR[7]), 
        .QN(n10352) );
  DFFRX1 D4CRCSR_reg_6_ ( .D(n9118), .CK(PCLK), .RN(nRst), .Q(D4CRCSR[6]), 
        .QN(n10292) );
  DFFRX1 D4CRCSR_reg_3_ ( .D(n9121), .CK(PCLK), .RN(nRst), .Q(D4CRCSR[3]), 
        .QN(n10351) );
  DFFRX1 D4CRCSR_reg_2_ ( .D(n9122), .CK(PCLK), .RN(nRst), .Q(D4CRCSR[2]), 
        .QN(n10245) );
  DFFRX1 D4CRCSR_reg_1_ ( .D(n9123), .CK(PCLK), .RN(nRst), .Q(D4CRCSR[1]), 
        .QN(n10295) );
  DFFRX1 D5CRCSR_reg_13_ ( .D(n9126), .CK(PCLK), .RN(nRst), .Q(D5CRCSR[13]), 
        .QN(n10379) );
  DFFRX1 D5CRCSR_reg_10_ ( .D(n9129), .CK(PCLK), .RN(nRst), .Q(D5CRCSR[10]), 
        .QN(n10228) );
  DFFRX1 D5CRCSR_reg_9_ ( .D(n9130), .CK(PCLK), .RN(nRst), .Q(D5CRCSR[9]), 
        .QN(n10302) );
  DFFRX1 D5CRCSR_reg_7_ ( .D(n9132), .CK(PCLK), .RN(nRst), .Q(D5CRCSR[7]), 
        .QN(n10307) );
  DFFRX1 D5CRCSR_reg_6_ ( .D(n9133), .CK(PCLK), .RN(nRst), .Q(D5CRCSR[6]), 
        .QN(n10371) );
  DFFRX1 D5CRCSR_reg_3_ ( .D(n9136), .CK(PCLK), .RN(nRst), .Q(D5CRCSR[3]), 
        .QN(n10259) );
  DFFRX1 D5CRCSR_reg_2_ ( .D(n9137), .CK(PCLK), .RN(nRst), .Q(D5CRCSR[2]), 
        .QN(n10317) );
  DFFRX1 D5CRCSR_reg_1_ ( .D(n9138), .CK(PCLK), .RN(nRst), .Q(D5CRCSR[1]), 
        .QN(n10381) );
  DFFRX1 D6CRCSR_reg_13_ ( .D(n9141), .CK(PCLK), .RN(nRst), .Q(D6CRCSR[13]), 
        .QN(n10365) );
  DFFRX1 D6CRCSR_reg_10_ ( .D(n9144), .CK(PCLK), .RN(nRst), .Q(D6CRCSR[10]), 
        .QN(n10248) );
  DFFRX1 D6CRCSR_reg_9_ ( .D(n9145), .CK(PCLK), .RN(nRst), .Q(D6CRCSR[9]), 
        .QN(n10243) );
  DFFRX1 D6CRCSR_reg_8_ ( .D(n9146), .CK(PCLK), .RN(nRst), .Q(D6CRCSR[8]), 
        .QN(n10246) );
  DFFRX1 D6CRCSR_reg_7_ ( .D(n9147), .CK(PCLK), .RN(nRst), .Q(D6CRCSR[7]), 
        .QN(n10300) );
  DFFRX1 D6CRCSR_reg_6_ ( .D(n9148), .CK(PCLK), .RN(nRst), .Q(D6CRCSR[6]), 
        .QN(n10363) );
  DFFRX1 D6CRCSR_reg_3_ ( .D(n9151), .CK(PCLK), .RN(nRst), .Q(D6CRCSR[3]), 
        .QN(n10247) );
  DFFRX1 D6CRCSR_reg_2_ ( .D(n9152), .CK(PCLK), .RN(nRst), .Q(D6CRCSR[2]), 
        .QN(n10364) );
  DFFRX1 D6CRCSR_reg_1_ ( .D(n9153), .CK(PCLK), .RN(nRst), .Q(D6CRCSR[1]), 
        .QN(n10301) );
  DFFRX1 D7CRCSR_reg_13_ ( .D(n9156), .CK(PCLK), .RN(nRst), .Q(D7CRCSR[13]), 
        .QN(n10348) );
  DFFRX1 D7CRCSR_reg_10_ ( .D(n9159), .CK(PCLK), .RN(nRst), .Q(D7CRCSR[10]), 
        .QN(n10293) );
  DFFRX1 D7CRCSR_reg_8_ ( .D(n9161), .CK(PCLK), .RN(nRst), .Q(D7CRCSR[8]), 
        .QN(n10298) );
  DFFRX1 D7CRCSR_reg_7_ ( .D(n9162), .CK(PCLK), .RN(nRst), .Q(D7CRCSR[7]), 
        .QN(n10362) );
  DFFRX1 D7CRCSR_reg_6_ ( .D(n9163), .CK(PCLK), .RN(nRst), .Q(D7CRCSR[6]), 
        .QN(n10358) );
  DFFRX1 D7CRCSR_reg_3_ ( .D(n9166), .CK(PCLK), .RN(nRst), .Q(D7CRCSR[3]), 
        .QN(n10294) );
  DFFRX1 D7CRCSR_reg_2_ ( .D(n9167), .CK(PCLK), .RN(nRst), .Q(D7CRCSR[2]), 
        .QN(n10349) );
  DFFRX1 D7CRCSR_reg_1_ ( .D(n9168), .CK(PCLK), .RN(nRst), .Q(D7CRCSR[1]), 
        .QN(n10244) );
  DFFRX1 D2CRCSR_reg_0_ ( .D(n9094), .CK(PCLK), .RN(nRst), .Q(D2CRCSR[0]) );
  DFFRX1 D4CRCSR_reg_0_ ( .D(n9124), .CK(PCLK), .RN(nRst), .Q(D4CRCSR[0]), 
        .QN(n10320) );
  DFFRX1 D5CRCSR_reg_0_ ( .D(n9139), .CK(PCLK), .RN(nRst), .Q(D5CRCSR[0]), 
        .QN(n10262) );
  DFFRX1 D6CRCSR_reg_0_ ( .D(n9154), .CK(PCLK), .RN(nRst), .Q(D6CRCSR[0]), 
        .QN(n10366) );
  DFFRX1 D2CRCSR_reg_14_ ( .D(n9080), .CK(PCLK), .RN(nRst), .Q(D2CRCSR[14]), 
        .QN(n10347) );
  DFFRX1 D3CRCSR_reg_14_ ( .D(n9095), .CK(PCLK), .RN(nRst), .Q(D3CRCSR[14]), 
        .QN(n10346) );
  DFFRX1 D4CRCSR_reg_14_ ( .D(n9110), .CK(PCLK), .RN(nRst), .Q(D4CRCSR[14]), 
        .QN(n10223) );
  DFFRX1 D5CRCSR_reg_14_ ( .D(n9125), .CK(PCLK), .RN(nRst), .Q(D5CRCSR[14]), 
        .QN(n10222) );
  DFFRX1 D6CRCSR_reg_14_ ( .D(n9140), .CK(PCLK), .RN(nRst), .Q(D6CRCSR[14]), 
        .QN(n10241) );
  DFFRX1 D7CRCSR_reg_14_ ( .D(n9155), .CK(PCLK), .RN(nRst), .Q(D7CRCSR[14]), 
        .QN(n10240) );
  DFFRX1 D7CRCSR_reg_0_ ( .D(n9169), .CK(PCLK), .RN(nRst), .Q(D7CRCSR[0]), 
        .QN(n10350) );
  DFFRX1 D1CRCSR_reg_11_ ( .D(n9068), .CK(PCLK), .RN(nRst), .Q(D1CRCSR[11]), 
        .QN(n10285) );
  DFFRX1 D1CRCSR_reg_4_ ( .D(n9075), .CK(PCLK), .RN(nRst), .Q(D1CRCSR[4]), 
        .QN(n10286) );
  DFFRX1 D2CRCSR_reg_11_ ( .D(n9083), .CK(PCLK), .RN(nRst), .Q(D2CRCSR[11]), 
        .QN(n10287) );
  DFFRX1 D2CRCSR_reg_4_ ( .D(n9090), .CK(PCLK), .RN(nRst), .Q(D2CRCSR[4]), 
        .QN(n10288) );
  DFFRX1 D3CRCSR_reg_11_ ( .D(n9098), .CK(PCLK), .RN(nRst), .Q(D3CRCSR[11]), 
        .QN(n10289) );
  DFFRX1 D3CRCSR_reg_4_ ( .D(n9105), .CK(PCLK), .RN(nRst), .Q(D3CRCSR[4]), 
        .QN(n10290) );
  DFFRX1 D4CRCSR_reg_11_ ( .D(n9113), .CK(PCLK), .RN(nRst), .Q(D4CRCSR[11]), 
        .QN(n10368) );
  DFFRX1 D4CRCSR_reg_4_ ( .D(n9120), .CK(PCLK), .RN(nRst), .Q(D4CRCSR[4]), 
        .QN(n10212) );
  DFFRX1 D5CRCSR_reg_11_ ( .D(n9128), .CK(PCLK), .RN(nRst), .Q(D5CRCSR[11]), 
        .QN(n10250) );
  DFFRX1 D5CRCSR_reg_4_ ( .D(n9135), .CK(PCLK), .RN(nRst), .Q(D5CRCSR[4]), 
        .QN(n10303) );
  DFFRX1 D6CRCSR_reg_11_ ( .D(n9143), .CK(PCLK), .RN(nRst), .Q(D6CRCSR[11]), 
        .QN(n10215) );
  DFFRX1 D6CRCSR_reg_4_ ( .D(n9150), .CK(PCLK), .RN(nRst), .Q(D6CRCSR[4]), 
        .QN(n10216) );
  DFFRX1 D7CRCSR_reg_11_ ( .D(n9158), .CK(PCLK), .RN(nRst), .Q(D7CRCSR[11]), 
        .QN(n10213) );
  DFFRX1 D7CRCSR_reg_4_ ( .D(n9165), .CK(PCLK), .RN(nRst), .Q(D7CRCSR[4]), 
        .QN(n10214) );
  DFFRX1 D0CRCSR_reg_12_ ( .D(n9052), .CK(PCLK), .RN(nRst), .Q(D0CRCSR[12]), 
        .QN(n10315) );
  DFFRX1 D1CRCSR_reg_12_ ( .D(n9067), .CK(PCLK), .RN(nRst), .Q(D1CRCSR[12]) );
  DFFRX1 D2CRCSR_reg_12_ ( .D(n9082), .CK(PCLK), .RN(nRst), .Q(D2CRCSR[12]), 
        .QN(n10354) );
  DFFRX1 D2CRCSR_reg_5_ ( .D(n9089), .CK(PCLK), .RN(nRst), .Q(D2CRCSR[5]), 
        .QN(n10297) );
  DFFRX1 D3CRCSR_reg_5_ ( .D(n9104), .CK(PCLK), .RN(nRst), .Q(D3CRCSR[5]), 
        .QN(n10353) );
  DFFRX1 D4CRCSR_reg_5_ ( .D(n9119), .CK(PCLK), .RN(nRst), .Q(D4CRCSR[5]), 
        .QN(n10242) );
  DFFRX1 D5CRCSR_reg_12_ ( .D(n9127), .CK(PCLK), .RN(nRst), .Q(D5CRCSR[12]), 
        .QN(n10316) );
  DFFRX1 D5CRCSR_reg_5_ ( .D(n9134), .CK(PCLK), .RN(nRst), .Q(D5CRCSR[5]), 
        .QN(n10370) );
  DFFRX1 D6CRCSR_reg_12_ ( .D(n9142), .CK(PCLK), .RN(nRst), .Q(D6CRCSR[12]), 
        .QN(n10299) );
  DFFRX1 D6CRCSR_reg_5_ ( .D(n9149), .CK(PCLK), .RN(nRst), .Q(D6CRCSR[5]), 
        .QN(n10217) );
  DFFRX1 D7CRCSR_reg_12_ ( .D(n9157), .CK(PCLK), .RN(nRst), .Q(D7CRCSR[12]), 
        .QN(n10291) );
  DFFRX1 D7CRCSR_reg_5_ ( .D(n9164), .CK(PCLK), .RN(nRst), .Q(D7CRCSR[5]), 
        .QN(n10296) );
  DFFRX1 D0CRCSR_reg_11_ ( .D(n9053), .CK(PCLK), .RN(nRst), .Q(D0CRCSR[11]), 
        .QN(n10306) );
  DFFRX1 D0CRCSR_reg_4_ ( .D(n9060), .CK(PCLK), .RN(nRst), .Q(D0CRCSR[4]), 
        .QN(n10372) );
  DFFRX1 D0CRCSR_reg_5_ ( .D(n9059), .CK(PCLK), .RN(nRst), .Q(D0CRCSR[5]) );
  DFFRX1 D1CRCSR_reg_8_ ( .D(n9071), .CK(PCLK), .RN(nRst), .Q(D1CRCSR[8]) );
  DFFRX1 D1CRCSR_reg_2_ ( .D(n9077), .CK(PCLK), .RN(nRst), .Q(D1CRCSR[2]) );
  DFFRX1 D2CRCSR_reg_13_ ( .D(n9081), .CK(PCLK), .RN(nRst), .Q(D2CRCSR[13]) );
  DFFRX1 D2CRCSR_reg_10_ ( .D(n9084), .CK(PCLK), .RN(nRst), .Q(D2CRCSR[10]) );
  DFFRX1 D2CRCSR_reg_7_ ( .D(n9087), .CK(PCLK), .RN(nRst), .Q(D2CRCSR[7]) );
  DFFRX1 D2CRCSR_reg_2_ ( .D(n9092), .CK(PCLK), .RN(nRst), .Q(D2CRCSR[2]) );
  DFFRX1 D2CRCSR_reg_1_ ( .D(n9093), .CK(PCLK), .RN(nRst), .Q(D2CRCSR[1]) );
  DFFRX1 D3CRCSR_reg_13_ ( .D(n9096), .CK(PCLK), .RN(nRst), .Q(D3CRCSR[13]) );
  DFFRX1 D3CRCSR_reg_9_ ( .D(n9100), .CK(PCLK), .RN(nRst), .Q(D3CRCSR[9]) );
  DFFRX1 D3CRCSR_reg_6_ ( .D(n9103), .CK(PCLK), .RN(nRst), .Q(D3CRCSR[6]) );
  DFFRX1 D3CRCSR_reg_3_ ( .D(n9106), .CK(PCLK), .RN(nRst), .Q(D3CRCSR[3]) );
  DFFRX1 D5CRCSR_reg_8_ ( .D(n9131), .CK(PCLK), .RN(nRst), .Q(D5CRCSR[8]) );
  DFFRX1 D7CRCSR_reg_9_ ( .D(n9160), .CK(PCLK), .RN(nRst), .Q(D7CRCSR[9]) );
  DFFRX1 D1CRCSR_reg_0_ ( .D(n9079), .CK(PCLK), .RN(nRst), .Q(D1CRCSR[0]) );
  DFFRX1 D3CRCSR_reg_0_ ( .D(n9109), .CK(PCLK), .RN(nRst), .Q(D3CRCSR[0]) );
  DFFRX1 D1CRCSR_reg_5_ ( .D(n9074), .CK(PCLK), .RN(nRst), .Q(D1CRCSR[5]) );
  DFFRX1 D3CRCSR_reg_12_ ( .D(n9097), .CK(PCLK), .RN(nRst), .Q(D3CRCSR[12]) );
  DFFRX1 D4CRCSR_reg_12_ ( .D(n9112), .CK(PCLK), .RN(nRst), .Q(D4CRCSR[12]) );
  DFFRX1 D0CRCSR_reg_0_ ( .D(n9064), .CK(PCLK), .RN(nRst), .Q(D0CRCSR[0]) );
  DFFRX1 CRCStatusGet_reg ( .D(n9184), .CK(PCLK), .RN(nRst), .Q(CRCStatusGet), 
        .QN(n10322) );
  DFFRX1 StateCnt_reg_30_ ( .D(n8984), .CK(PCLK), .RN(nRst), .Q(StateCnt_30_), 
        .QN(n10255) );
  DFFRX1 StateCnt_reg_29_ ( .D(n8985), .CK(PCLK), .RN(nRst), .Q(StateCnt_29_), 
        .QN(n10376) );
  DFFRX1 StateCnt_reg_28_ ( .D(n8986), .CK(PCLK), .RN(nRst), .Q(StateCnt_28_), 
        .QN(n10312) );
  DFFRX1 StateCnt_reg_27_ ( .D(n8987), .CK(PCLK), .RN(nRst), .Q(StateCnt_27_), 
        .QN(n10226) );
  DFFRX1 StateCnt_reg_26_ ( .D(n8988), .CK(PCLK), .RN(nRst), .Q(StateCnt_26_), 
        .QN(n10256) );
  DFFRX1 StateCnt_reg_25_ ( .D(n8989), .CK(PCLK), .RN(nRst), .Q(StateCnt_25_), 
        .QN(n10377) );
  DFFRX1 StateCnt_reg_24_ ( .D(n8990), .CK(PCLK), .RN(nRst), .Q(StateCnt_24_), 
        .QN(n10313) );
  DFFRX1 StateCnt_reg_22_ ( .D(n8992), .CK(PCLK), .RN(nRst), .Q(StateCnt_22_), 
        .QN(n10249) );
  DFFRX1 StateCnt_reg_21_ ( .D(n8993), .CK(PCLK), .RN(nRst), .Q(StateCnt_21_), 
        .QN(n10304) );
  DFFRX1 StateCnt_reg_20_ ( .D(n8994), .CK(PCLK), .RN(nRst), .Q(StateCnt_20_), 
        .QN(n10369) );
  DFFRX1 StateCnt_reg_19_ ( .D(n8995), .CK(PCLK), .RN(nRst), .Q(StateCnt_19_), 
        .QN(n10257) );
  DFFRX1 StateCnt_reg_18_ ( .D(n8996), .CK(PCLK), .RN(nRst), .Q(StateCnt_18_), 
        .QN(n10314) );
  DFFRX1 StateCnt_reg_17_ ( .D(n8997), .CK(PCLK), .RN(nRst), .Q(StateCnt_17_), 
        .QN(n10390) );
  DFFRX1 StateCnt_reg_16_ ( .D(n8998), .CK(PCLK), .RN(nRst), .Q(StateCnt_16_), 
        .QN(n10375) );
  DFFRX1 StateCnt_reg_15_ ( .D(n8999), .CK(PCLK), .RN(nRst), .Q(StateCnt_15_), 
        .QN(n10225) );
  DFFRX1 StateCnt_reg_14_ ( .D(n9000), .CK(PCLK), .RN(nRst), .Q(StateCnt_14_), 
        .QN(n10311) );
  DFFRX1 StateCnt_reg_13_ ( .D(n9001), .CK(PCLK), .RN(nRst), .Q(StateCnt_13_), 
        .QN(n10254) );
  DFFRX1 StateCnt_reg_12_ ( .D(n9002), .CK(PCLK), .RN(nRst), .Q(StateCnt_12_), 
        .QN(n10373) );
  DFFRX1 StateCnt_reg_11_ ( .D(n9003), .CK(PCLK), .RN(nRst), .Q(StateCnt_11_), 
        .QN(n10309) );
  DFFRX1 StateCnt_reg_31_ ( .D(n8983), .CK(PCLK), .RN(nRst), .Q(StateCnt_31_), 
        .QN(n10378) );
  DFFRX1 NibbleCnt_reg ( .D(n9049), .CK(PCLK), .RN(nRst), .Q(NibbleCnt), .QN(
        n10425) );
  DFFRX1 BitCnt_reg_0_ ( .D(n8982), .CK(PCLK), .RN(nRst), .Q(BitCnt_0_), .QN(
        n10323) );
  DFFRX1 BitCnt_reg_1_ ( .D(n8981), .CK(PCLK), .RN(nRst), .Q(BitCnt_1_), .QN(
        n10388) );
  DFFRX1 StateCnt_reg_23_ ( .D(n8991), .CK(PCLK), .RN(nRst), .Q(StateCnt_23_)
         );
  DFFRX1 CRCStatusChk_reg ( .D(CRCStatusChk2453), .CK(PCLK), .RN(nRst), .Q(
        CRCStatusChk) );
  DFFRX1 BitCnt_reg_2_ ( .D(n8980), .CK(PCLK), .RN(nRst), .Q(BitCnt_2_) );
  DFFRX1 CRCCheck_reg ( .D(CRCCheck2263), .CK(PCLK), .RN(nRst), .Q(CRCCheck)
         );
  DFFRX1 TxRdPtrInc_reg ( .D(n9185), .CK(PCLK), .RN(nRst), .Q(TxRdPtrInc), 
        .QN(n10426) );
  DFFRX1 RxWriteEn_reg ( .D(n9047), .CK(PCLK), .RN(nRst), .Q(RxWriteEn), .QN(
        n10424) );
  DFFRX1 StopBit_reg ( .D(n9182), .CK(PCLK), .RN(nRst), .Q(StopBit), .QN(
        n10411) );
  DFFRX1 BlkDatCntEn_reg ( .D(n9179), .CK(PCLK), .RN(nRst), .Q(BlkDatCntEn), 
        .QN(n10387) );
  DFFRX1 StartBit_reg ( .D(n9183), .CK(PCLK), .RN(nRst), .Q(StartBit), .QN(
        n10391) );
  DFFRX1 AbortCmdSent_reg ( .D(n9170), .CK(PCLK), .RN(nRst), .Q(AbortCmdSent), 
        .QN(n10325) );
  DFFRX1 BlkNumCnt_reg_0_ ( .D(n8977), .CK(PCLK), .RN(nRst), .Q(BlkNumCnt[0]), 
        .QN(n10230) );
  DFFRX1 BlkNumCnt_reg_14_ ( .D(n8963), .CK(PCLK), .RN(nRst), .Q(BlkNumCnt[14]), .QN(n10329) );
  DFFRX1 BlkNumCnt_reg_13_ ( .D(n8964), .CK(PCLK), .RN(nRst), .Q(BlkNumCnt[13]), .QN(n10267) );
  DFFRX1 BlkNumCnt_reg_12_ ( .D(n8965), .CK(PCLK), .RN(nRst), .Q(BlkNumCnt[12]), .QN(n10265) );
  DFFRX1 BlkNumCnt_reg_11_ ( .D(n8966), .CK(PCLK), .RN(nRst), .Q(BlkNumCnt[11]), .QN(n10327) );
  DFFRX1 BlkNumCnt_reg_10_ ( .D(n8967), .CK(PCLK), .RN(nRst), .Q(BlkNumCnt[10]), .QN(n10395) );
  DFFRX1 BlkNumCnt_reg_8_ ( .D(n8969), .CK(PCLK), .RN(nRst), .Q(BlkNumCnt[8]), 
        .QN(n10264) );
  DFFRX1 BlkNumCnt_reg_7_ ( .D(n8970), .CK(PCLK), .RN(nRst), .Q(BlkNumCnt[7]), 
        .QN(n10326) );
  DFFRX1 BlkNumCnt_reg_6_ ( .D(n8971), .CK(PCLK), .RN(nRst), .Q(BlkNumCnt[6]), 
        .QN(n10394) );
  DFFRX1 BlkNumCnt_reg_5_ ( .D(n8972), .CK(PCLK), .RN(nRst), .Q(BlkNumCnt[5]), 
        .QN(n10266) );
  DFFRX1 BlkNumCnt_reg_4_ ( .D(n8973), .CK(PCLK), .RN(nRst), .Q(BlkNumCnt[4]), 
        .QN(n10328) );
  DFFRX1 BlkNumCnt_reg_3_ ( .D(n8974), .CK(PCLK), .RN(nRst), .Q(BlkNumCnt[3]), 
        .QN(n10396) );
  DFFRX1 Abort_reg ( .D(n9171), .CK(PCLK), .RN(nRst), .Q(Abort), .QN(n10393)
         );
  DFFRX1 CRCStatusCnt_reg_2_ ( .D(n9015), .CK(PCLK), .RN(nRst), .Q(
        CRCStatusCnt_2_), .QN(n10412) );
  DFFRX1 BlkNumCnt_reg_2_ ( .D(n8975), .CK(PCLK), .RN(nRst), .Q(BlkNumCnt[2]), 
        .QN(n10232) );
  DFFRX1 BlkNumCnt_reg_1_ ( .D(n8976), .CK(PCLK), .RN(nRst), .Q(BlkNumCnt[1]), 
        .QN(n10231) );
  DFFRX1 BlkNumCnt_reg_15_ ( .D(n8962), .CK(PCLK), .RN(nRst), .Q(BlkNumCnt[15]), .QN(n10397) );
  DFFRX1 BusyStatus_reg ( .D(n9188), .CK(PCLK), .RN(nRst), .Q(BusyStatus), 
        .QN(n10392) );
  DFFRX1 CRCStatusCnt_reg_1_ ( .D(n9016), .CK(PCLK), .RN(nRst), .Q(
        CRCStatusCnt_1_), .QN(n10321) );
  DFFRX1 CRCStatusCnt_reg_0_ ( .D(n9017), .CK(PCLK), .RN(nRst), .Q(
        CRCStatusCnt_0_), .QN(n10451) );
  DFFRX1 WORDCnt_reg_1_ ( .D(n8978), .CK(PCLK), .RN(nRst), .Q(WORDCnt[1]), 
        .QN(n10398) );
  DFFRX1 WORDCnt_reg_0_ ( .D(n8979), .CK(PCLK), .RN(nRst), .Q(WORDCnt[0]), 
        .QN(n10263) );
  DFFRX1 BlkNumCnt_reg_9_ ( .D(n8968), .CK(PCLK), .RN(nRst), .Q(BlkNumCnt[9])
         );
  DFFRX1 TxActive_reg ( .D(n9190), .CK(PCLK), .RN(nRst), .Q(TxActive), .QN(
        n8897) );
  DFFRX1 BusyCnt_reg_0_ ( .D(n9022), .CK(PCLK), .RN(nRst), .Q(BusyCnt[0]), 
        .QN(n10423) );
  DFFRX1 TxCRCSend_reg ( .D(n9187), .CK(PCLK), .RN(nRst), .Q(TxCRCSend), .QN(
        n10456) );
  DFFRX1 BusyCnt_reg_4_ ( .D(n9018), .CK(PCLK), .RN(nRst), .Q(BusyCnt[4]), 
        .QN(n10413) );
  DFFRX1 BusyCnt_reg_3_ ( .D(n9019), .CK(PCLK), .RN(nRst), .Q(BusyCnt[3]), 
        .QN(n10275) );
  DFFRX1 BusyCnt_reg_2_ ( .D(n9020), .CK(PCLK), .RN(nRst), .Q(BusyCnt[2]), 
        .QN(n10340) );
  DFFRX1 BusyState_reg_0_ ( .D(BusyState6570_0_), .CK(PCLK), .RN(nRst), .Q(
        BusyState[0]) );
  DFFSX1 DATOUT_reg_3_ ( .D(n8934), .CK(PCLK), .SN(nRst), .Q(DATOUT[3]), .QN(
        n10428) );
  DFFSX1 DATOUT_reg_2_ ( .D(n8935), .CK(PCLK), .SN(nRst), .Q(DATOUT[2]), .QN(
        n10429) );
  DFFSX1 DATOUT_reg_1_ ( .D(n8936), .CK(PCLK), .SN(nRst), .Q(DATOUT[1]), .QN(
        n10430) );
  DFFRX1 DATSR_reg_23_ ( .D(n9023), .CK(PCLK), .RN(nRst), .Q(DATSR_23_), .QN(
        n10417) );
  DFFSX1 DATOUT_reg_7_ ( .D(n8930), .CK(PCLK), .SN(nRst), .Q(DATOUT[7]), .QN(
        n10422) );
  DFFSX1 DATOUT_reg_6_ ( .D(n8931), .CK(PCLK), .SN(nRst), .Q(DATOUT[6]), .QN(
        n10419) );
  DFFSX1 DATOUT_reg_5_ ( .D(n8932), .CK(PCLK), .SN(nRst), .Q(DATOUT[5]), .QN(
        n10420) );
  DFFSX1 DATOUT_reg_4_ ( .D(n8933), .CK(PCLK), .SN(nRst), .Q(DATOUT[4]), .QN(
        n10421) );
  DFFSX1 DATOUT_reg_0_ ( .D(n8937), .CK(PCLK), .SN(nRst), .Q(DATOUT[0]), .QN(
        n10418) );
  DFFRX1 CRCStatusStr_reg ( .D(n9189), .CK(PCLK), .RN(nRst), .Q(CRCStatusStr), 
        .QN(n10339) );
  DFFRX1 DATSR_reg_22_ ( .D(n9024), .CK(PCLK), .RN(nRst), .Q(DATSR_22_), .QN(
        n10416) );
  DFFRX1 DATSR_reg_21_ ( .D(n9025), .CK(PCLK), .RN(nRst), .Q(DATSR_21_), .QN(
        n10414) );
  DFFRX1 DATSR_reg_20_ ( .D(n9026), .CK(PCLK), .RN(nRst), .Q(DATSR_20_), .QN(
        n10415) );
  DFFRX1 DATSR_reg_19_ ( .D(n9027), .CK(PCLK), .RN(nRst), .Q(DATSR_19_), .QN(
        n10401) );
  DFFRX1 DATSR_reg_18_ ( .D(n9028), .CK(PCLK), .RN(nRst), .Q(DATSR_18_), .QN(
        n10399) );
  DFFRX1 DATSR_reg_17_ ( .D(n9029), .CK(PCLK), .RN(nRst), .Q(DATSR_17_), .QN(
        n10400) );
  DFFRX1 DATSR_reg_16_ ( .D(n9030), .CK(PCLK), .RN(nRst), .Q(DATSR_16_), .QN(
        n10402) );
  DFFRX1 DATSR_reg_2_ ( .D(n9044), .CK(PCLK), .RN(nRst), .Q(DATSR_2_), .QN(
        n10338) );
  DFFRX1 DATSR_reg_1_ ( .D(n9045), .CK(PCLK), .RN(nRst), .Q(DATSR_1_), .QN(
        n10337) );
  DFFRX1 DATSR_reg_24_ ( .D(DATSR4385_24_), .CK(PCLK), .RN(nRst), .Q(DATSR_24_), .QN(n10405) );
  DFFRX1 DATSR_reg_25_ ( .D(DATSR4385_25_), .CK(PCLK), .RN(nRst), .Q(DATSR_25_), .QN(n10404) );
  DFFRX1 DATSR_reg_26_ ( .D(DATSR4385_26_), .CK(PCLK), .RN(nRst), .Q(DATSR_26_), .QN(n10406) );
  DFFRX1 DATSR_reg_27_ ( .D(DATSR4385_27_), .CK(PCLK), .RN(nRst), .Q(DATSR_27_), .QN(n10403) );
  DFFRX1 RxCRCCal_reg ( .D(n9180), .CK(PCLK), .RN(nRst), .Q(RxCRCCal), .QN(
        n10432) );
  DFFRX1 DATSR_reg_28_ ( .D(DATSR4385_28_), .CK(PCLK), .RN(nRst), .Q(DATSR_28_), .QN(n10408) );
  DFFRX1 DATSR_reg_29_ ( .D(DATSR4385_29_), .CK(PCLK), .RN(nRst), .Q(DATSR_29_), .QN(n10409) );
  DFFRX1 DATSR_reg_30_ ( .D(DATSR4385_30_), .CK(PCLK), .RN(nRst), .Q(DATSR_30_), .QN(n10407) );
  DFFRX1 LdDataBuffer_reg ( .D(LdDataBuffer4424), .CK(PCLK), .RN(nRst), .Q(
        LdDataBuffer), .QN(n10330) );
  DFFRX1 DATSR_reg_3_ ( .D(n9043), .CK(PCLK), .RN(nRst), .Q(DATSR_3_), .QN(
        n10331) );
  DFFRX1 BusyCnt_reg_1_ ( .D(n9021), .CK(PCLK), .RN(nRst), .Q(BusyCnt[1]) );
  DFFRX1 DATSR_reg_31_ ( .D(DATSR4385_31_), .CK(PCLK), .RN(nRst), .QN(n10410)
         );
  DFFRX1 BusyState_reg_1_ ( .D(BusyState6570_1_), .CK(PCLK), .RN(nRst), .Q(
        BusyState[1]) );
  DFFRX1 NoBusySet_reg ( .D(NoBusySet6582), .CK(PCLK), .RN(nRst), .Q(NoBusySet) );
  DFFRX1 BusyFinSet_reg ( .D(BusyFinSet6588), .CK(PCLK), .RN(nRst), .Q(
        BusyFinSet) );
  DFFSX1 nDATEN_reg ( .D(n9186), .CK(PCLK), .SN(nRst), .Q(nDATEN), .QN(n10431)
         );
  DFFRX1 DATSR_reg_0_ ( .D(n9046), .CK(PCLK), .RN(nRst), .Q(DATSR_0_), .QN(
        n10336) );
  DFFRX1 DATSR_reg_15_ ( .D(n9031), .CK(PCLK), .RN(nRst), .Q(DATSR_15_), .QN(
        n10272) );
  DFFRX1 DATSR_reg_14_ ( .D(n9032), .CK(PCLK), .RN(nRst), .Q(DATSR_14_), .QN(
        n10333) );
  DFFRX1 DATSR_reg_13_ ( .D(n9033), .CK(PCLK), .RN(nRst), .Q(DATSR_13_), .QN(
        n10268) );
  DFFRX1 DATSR_reg_12_ ( .D(n9034), .CK(PCLK), .RN(nRst), .Q(DATSR_12_), .QN(
        n10273) );
  DFFRX1 DATSR_reg_11_ ( .D(n9035), .CK(PCLK), .RN(nRst), .Q(DATSR_11_), .QN(
        n10334) );
  DFFRX1 DATSR_reg_10_ ( .D(n9036), .CK(PCLK), .RN(nRst), .Q(DATSR_10_), .QN(
        n10233) );
  DFFRX1 DATSR_reg_9_ ( .D(n9037), .CK(PCLK), .RN(nRst), .Q(DATSR_9_), .QN(
        n10332) );
  DFFRX1 DATSR_reg_8_ ( .D(n9038), .CK(PCLK), .RN(nRst), .Q(DATSR_8_), .QN(
        n10335) );
  DFFRX1 DATSR_reg_7_ ( .D(n9039), .CK(PCLK), .RN(nRst), .Q(DATSR_7_), .QN(
        n10269) );
  DFFRX1 DATSR_reg_6_ ( .D(n9040), .CK(PCLK), .RN(nRst), .Q(DATSR_6_), .QN(
        n10270) );
  DFFRX1 DATSR_reg_5_ ( .D(n9041), .CK(PCLK), .RN(nRst), .Q(DATSR_5_), .QN(
        n10274) );
  DFFRX1 DATSR_reg_4_ ( .D(n9042), .CK(PCLK), .RN(nRst), .Q(DATSR_4_), .QN(
        n10271) );
  DFFSX1 Inv_DATOUT_reg_7_ ( .D(n8938), .CK(PCLK), .SN(nRst), .Q(Inv_DATOUT[7]), .QN(n8894) );
  DFFSX1 Inv_DATOUT_reg_6_ ( .D(n8939), .CK(PCLK), .SN(nRst), .Q(Inv_DATOUT[6]), .QN(n8893) );
  DFFSX1 Inv_DATOUT_reg_5_ ( .D(n8940), .CK(PCLK), .SN(nRst), .Q(Inv_DATOUT[5]), .QN(n8892) );
  DFFSX1 Inv_DATOUT_reg_4_ ( .D(n8941), .CK(PCLK), .SN(nRst), .Q(Inv_DATOUT[4]), .QN(n8891) );
  DFFSX1 Inv_DATOUT_reg_3_ ( .D(n8942), .CK(PCLK), .SN(nRst), .Q(Inv_DATOUT[3]), .QN(n8890) );
  DFFSX1 Inv_DATOUT_reg_2_ ( .D(n8943), .CK(PCLK), .SN(nRst), .Q(Inv_DATOUT[2]), .QN(n8889) );
  DFFSX1 Inv_DATOUT_reg_1_ ( .D(n8944), .CK(PCLK), .SN(nRst), .Q(Inv_DATOUT[1]), .QN(n8888) );
  DFFSX1 Inv_DATOUT_reg_0_ ( .D(n8945), .CK(PCLK), .SN(nRst), .Q(Inv_DATOUT[0]), .QN(n8887) );
  DFFSX1 Inv_nDATEN_reg ( .D(n9048), .CK(PCLK), .SN(nRst), .Q(Inv_nDATEN), 
        .QN(n8895) );
  DFFRX1 FIFOWriteData_reg_31_ ( .D(n8898), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[31]), .QN(n8879) );
  DFFRX1 FIFOWriteData_reg_30_ ( .D(n8899), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[30]), .QN(n8878) );
  DFFRX1 FIFOWriteData_reg_29_ ( .D(n8900), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[29]), .QN(n8876) );
  DFFRX1 FIFOWriteData_reg_28_ ( .D(n8901), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[28]), .QN(n8875) );
  DFFRX1 FIFOWriteData_reg_27_ ( .D(n8902), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[27]), .QN(n8874) );
  DFFRX1 FIFOWriteData_reg_26_ ( .D(n8903), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[26]), .QN(n8873) );
  DFFRX1 FIFOWriteData_reg_25_ ( .D(n8904), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[25]), .QN(n8872) );
  DFFRX1 FIFOWriteData_reg_24_ ( .D(n8905), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[24]), .QN(n8871) );
  DFFRX1 FIFOWriteData_reg_23_ ( .D(n8906), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[23]), .QN(n8870) );
  DFFRX1 FIFOWriteData_reg_22_ ( .D(n8907), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[22]), .QN(n8869) );
  DFFRX1 FIFOWriteData_reg_21_ ( .D(n8908), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[21]), .QN(n8868) );
  DFFRX1 FIFOWriteData_reg_20_ ( .D(n8909), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[20]), .QN(n8867) );
  DFFRX1 FIFOWriteData_reg_19_ ( .D(n8910), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[19]), .QN(n8865) );
  DFFRX1 FIFOWriteData_reg_18_ ( .D(n8911), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[18]), .QN(n8864) );
  DFFRX1 FIFOWriteData_reg_17_ ( .D(n8912), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[17]), .QN(n8863) );
  DFFRX1 FIFOWriteData_reg_16_ ( .D(n8913), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[16]), .QN(n8862) );
  DFFRX1 FIFOWriteData_reg_15_ ( .D(n8914), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[15]), .QN(n8861) );
  DFFRX1 FIFOWriteData_reg_14_ ( .D(n8915), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[14]), .QN(n8860) );
  DFFRX1 FIFOWriteData_reg_13_ ( .D(n8916), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[13]), .QN(n8859) );
  DFFRX1 FIFOWriteData_reg_12_ ( .D(n8917), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[12]), .QN(n8858) );
  DFFRX1 FIFOWriteData_reg_11_ ( .D(n8918), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[11]), .QN(n8857) );
  DFFRX1 FIFOWriteData_reg_10_ ( .D(n8919), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[10]), .QN(n8856) );
  DFFRX1 FIFOWriteData_reg_9_ ( .D(n8920), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[9]), .QN(n8886) );
  DFFRX1 FIFOWriteData_reg_8_ ( .D(n8921), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[8]), .QN(n8885) );
  DFFRX1 FIFOWriteData_reg_7_ ( .D(n8922), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[7]), .QN(n8884) );
  DFFRX1 FIFOWriteData_reg_6_ ( .D(n8923), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[6]), .QN(n8883) );
  DFFRX1 FIFOWriteData_reg_5_ ( .D(n8924), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[5]), .QN(n8882) );
  DFFRX1 FIFOWriteData_reg_4_ ( .D(n8925), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[4]), .QN(n8881) );
  DFFRX1 FIFOWriteData_reg_3_ ( .D(n8926), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[3]), .QN(n8880) );
  DFFRX1 FIFOWriteData_reg_2_ ( .D(n8927), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[2]), .QN(n8877) );
  DFFRX1 FIFOWriteData_reg_1_ ( .D(n8928), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[1]), .QN(n8866) );
  DFFRX1 FIFOWriteData_reg_0_ ( .D(n8929), .CK(PCLK), .RN(nRst), .Q(
        FIFOWriteData[0]), .QN(n8855) );
endmodule


module mmc_CommandControl ( nRst, SDreset, PCLK, neg_CKPulse, CKPulse, CMDIN, 
        CMDOUT, Inv_CMDOUT, nCMDEN, Inv_nCMDEN, SDICmdArg, NoCRCRsp, LongRsp, 
        WaitRsp, CMST, CMSTClr, CmdIndex, RspCrcSet, CmdSentSet, CmdToutSet, 
        RspFinSet, CmdOn, RspIndex, Response0, Response1, Response2, Response3, 
        CmdCtrlIdle );
  input [31:0] SDICmdArg;
  input [6:0] CmdIndex;
  output [7:0] RspIndex;
  output [31:0] Response0;
  output [31:0] Response1;
  output [31:0] Response2;
  output [31:0] Response3;
  input nRst, SDreset, PCLK, neg_CKPulse, CKPulse, CMDIN, NoCRCRsp, LongRsp,
         WaitRsp, CMST;
  output CMDOUT, Inv_CMDOUT, nCMDEN, Inv_nCMDEN, CMSTClr, RspCrcSet,
         CmdSentSet, CmdToutSet, RspFinSet, CmdOn, CmdCtrlIdle;
  wire   CMDState_2_, CMDState_1_, CCMDState3, CMDShift_30_, CMDShift_29_,
         CMDShift_28_, CMDShift_27_, CMDShift_26_, CMDShift_25_, CMDShift_24_,
         CMDShift_23_, CMDShift_22_, CMDShift_21_, CMDShift_20_, CMDShift_19_,
         CMDShift_18_, CMDShift_17_, CMDShift_16_, CMDShift_15_, CMDShift_14_,
         CMDShift_13_, CMDShift_12_, CMDShift_11_, CMDShift_10_, CMDShift_9_,
         CMDShift_8_, CMDShift_7_, CMDShift_6_, CMDShift_5_, CMDShift_4_,
         CMDShift_3_, CMDShift_2_, CMDShift_1_, CMDShift_0_, CMDTxMode,
         CRCTxMode, CRCRxMode, CMDCnt1567_6_, CMDCnt1567_5_, CMDCnt1567_4_,
         CMDCnt1567_3_, CMDCnt1567_2_, CMDCnt1567_1_, CRCShift1652_6_,
         CRCShift1652_5_, CRCShift1652_4_, CRCShift1652_3_, CRCShift1652_2_,
         CRCShift1652_1_, CRCShift1652_0_, CRCRxMode1784, n3059, n3060, n3061,
         n3062, n3063, n3064, n3065, n3066, n3067, n3068, n3069, n3070, n3071,
         n3072, n3073, n3074, n3075, n3076, n3077, n3078, n3079, n3080, n3081,
         n3082, n3083, n3084, n3085, n3086, n3087, n3088, n3089, n3090, n3091,
         n3092, n3093, n3094, n3095, n3096, n3097, n3098, n3099, n3100, n3101,
         n3102, n3103, n3104, n3105, n3106, n3107, n3108, n3109, n3110, n3111,
         n3112, n3113, n3114, n3115, n3116, n3117, n3118, n3119, n3120, n3121,
         n3122, n3123, n3124, n3125, n3126, n3127, n3128, n3129, n3130, n3131,
         n3132, n3133, n3134, n3135, n3136, n3137, n3138, n3139, n3140, n3141,
         n3142, n3143, n3144, n3145, n3146, n3147, n3148, n3149, n3150, n3151,
         n3152, n3153, n3154, n3155, n3156, n3157, n3158, n3159, n3160, n3161,
         n3162, n3163, n3164, n3165, n3166, n3167, n3168, n3169, n3170, n3171,
         n3172, n3173, n3174, n3175, n3176, n3177, n3178, n3179, n3180, n3181,
         n3182, n3183, n3184, n3185, n3186, n3187, n3188, n3189, n3190, n3191,
         n3192, n3193, n3194, n3195, n3196, n3197, n3198, n3199, n3200, n3201,
         n3202, n3203, n3204, n3205, n3206, n3207, n3208, n3209, n3210, n3211,
         n3212, n3213, n3214, n3215, n3216, n3217, n3218, n3219, n3220, n3221,
         n3222, n3223, n3224, n3225, n3226, n3227, n3228, n3229, n3230, n3231,
         n3232, n3233, n3234, n3235, n3236, n3237, n3238, n3239, n3240, n3241,
         n3242, n3243, n3244, n3245, n3246, n3247, n3248, n3249, n3250, n3251,
         n3252, n3253, carry_6_, carry_5_, carry_4_, carry_3_, carry_2_, n1,
         n2, n3, n4, n5, n6, n3257, n3258, n3259, n3260, n3261, n3262, n3263,
         n3264, n3265, n3266, n3268, n3269, n3270, n3271, n3272, n3275, n3276,
         n3278, n3280, n3281, n3282, n3283, n3285, n3286, n3287, n3288, n3289,
         n3290, n3291, n3292, n3293, n3297, n3298, n3299, n3300, n3301, n3302,
         n3303, n3306, n3308, n3310, n3312, n3314, n3316, n3318, n3320, n3321,
         n3322, n3323, n3324, n3325, n3326, n3327, n3328, n3329, n3330, n3331,
         n3332, n3333, n3334, n3335, n3336, n3337, n3338, n3339, n3342, n3343,
         n3344, n3345, n3346, n3347, n3348, n3349, n3350, n3351, n3352, n3353,
         n3354, n3355, n3356, n3357, n3358, n3359, n3360, n3361, n3362, n3363,
         n3364, n3366, n3367, n3368, n3369, n3370, n3371, n3372, n3373, n3374,
         n3375, n3380, n3381, n3383, n3384, n3385, n3386, n3387, n3388, n3390,
         n3391, n3392, n3393, n3394, n3395, n3396, n3397, n3398, n3399, n3400,
         n3401, n3402, n3404, n3405, n3406, n3407, n3409, n3410, n3411, n3412,
         n3414, n3415, n3416, n3417, n3418, n3419, n3421, n3422, n3423, n3424,
         n3426, n3428, n3441, n3442, n3452, n3453, n3454, n3455, n3458, n3460,
         n3462, n3463, n3464, n3465, n3469, n3472, n3473, n3474, n3475, n3478,
         n3480, n3481, n3483, n3485, n3486, n3487, n3488, n3489, n3491, n3493,
         n3495, n3496, n3497, n3499, n3501, n3503, n3504, n3505, n3506, n3507,
         n3508, n3509, n3511, n3512, n3513, n3515, n3516, n3517, n3518, n3519,
         n3520, n3521, n3522, n3523, n3524, n3525, n3526, n3527, n3528, n3529,
         n3530, n3531, n3532, n3533, n3534, n3535, n3536, n3537, n3538, n3539,
         n3540, n3541, n3542, n3543, n3544, n3545, n3546, n3547, n3548, n3549,
         n3550, n3551, n3552, n3553, n3554, n3555, n3556, n3557, n3558, n3559,
         n3560, n3561, n3562, n3563, n3564, n3565, n3566, n3567, n3568;
  wire   [7:0] CMDCnt;
  wire   [6:0] CRCShift;

  AHHCONX2 U1_1_1 ( .A(CMDCnt[1]), .CI(CMDCnt[0]), .S(CMDCnt1567_1_), .CON(n6)
         );
  AHHCONX2 U1_1_2 ( .A(CMDCnt[2]), .CI(carry_2_), .S(CMDCnt1567_2_), .CON(n5)
         );
  AHHCONX2 U1_1_3 ( .A(CMDCnt[3]), .CI(carry_3_), .S(CMDCnt1567_3_), .CON(n4)
         );
  AHHCONX2 U1_1_4 ( .A(CMDCnt[4]), .CI(carry_4_), .S(CMDCnt1567_4_), .CON(n3)
         );
  AHHCONX2 U1_1_5 ( .A(CMDCnt[5]), .CI(carry_5_), .S(CMDCnt1567_5_), .CON(n2)
         );
  AHHCONX2 U1_1_6 ( .A(CMDCnt[6]), .CI(carry_6_), .S(CMDCnt1567_6_), .CON(n1)
         );
  AO21X1 U2017 ( .A0(n3543), .A1(n3407), .B0(SDreset), .Y(n3529) );
  AO21X1 U2018 ( .A0(n3363), .A1(n3407), .B0(SDreset), .Y(n3530) );
  INVX1 U2019 ( .A(n3288), .Y(RspFinSet) );
  INVX1 U2020 ( .A(n3384), .Y(n3385) );
  INVX1 U2021 ( .A(n3530), .Y(n3442) );
  INVX1 U2022 ( .A(n3529), .Y(n3411) );
  INVX1 U2023 ( .A(n3418), .Y(n3417) );
  NAND2BX1 U2024 ( .AN(n3416), .B(n3261), .Y(n3418) );
  INVX1 U2025 ( .A(n3409), .Y(n3410) );
  INVX1 U2026 ( .A(n3345), .Y(n3343) );
  OAI221X1 U2027 ( .A0(n3543), .A1(n3441), .B0(n3543), .B1(n3369), .C0(n3407), 
        .Y(n3288) );
  NAND2BX1 U2028 ( .AN(n3399), .B(n3383), .Y(n3384) );
  OR2X1 U2029 ( .A(n3401), .B(n3400), .Y(n3399) );
  NAND3BX1 U2030 ( .AN(n3422), .B(n3261), .C(n3441), .Y(n3426) );
  INVX1 U2031 ( .A(n3383), .Y(n3387) );
  AO21X1 U2032 ( .A0(n3371), .A1(n3407), .B0(SDreset), .Y(n3409) );
  OAI221X1 U2033 ( .A0(n3269), .A1(n3361), .B0(n3269), .B1(n3268), .C0(n3301), 
        .Y(n3345) );
  NAND2BX1 U2034 ( .AN(SDreset), .B(n3390), .Y(n3393) );
  NAND2BX1 U2035 ( .AN(SDreset), .B(CMSTClr), .Y(n3259) );
  INVX1 U2036 ( .A(n3453), .Y(n3452) );
  NAND2BX1 U2037 ( .AN(SDreset), .B(n3530), .Y(n3453) );
  INVX1 U2038 ( .A(n3415), .Y(n3416) );
  INVX1 U2039 ( .A(n3428), .Y(n3423) );
  INVX1 U2040 ( .A(n3414), .Y(n3412) );
  NAND2BX1 U2041 ( .AN(SDreset), .B(n3529), .Y(n3414) );
  NAND2BX1 U2042 ( .AN(n3400), .B(n3401), .Y(n3390) );
  INVX1 U2043 ( .A(n3339), .Y(n3299) );
  NAND2BX1 U2044 ( .AN(SDreset), .B(n3542), .Y(n3339) );
  INVX1 U2045 ( .A(n3265), .Y(n3264) );
  INVX1 U2046 ( .A(n3268), .Y(n3363) );
  INVX1 U2047 ( .A(SDreset), .Y(n3261) );
  INVX1 U2048 ( .A(CKPulse), .Y(n3269) );
  INVX1 U2049 ( .A(n3503), .Y(n3407) );
  INVX1 U2050 ( .A(n3469), .Y(n3465) );
  INVX1 U2051 ( .A(n3487), .Y(n3480) );
  INVX1 U2052 ( .A(n3473), .Y(n3472) );
  DFFSX1 CMDCnt_reg_0_ ( .D(n3210), .CK(PCLK), .SN(nRst), .Q(CMDCnt[0]), .QN(
        n3517) );
  OAI211X1 U2053 ( .A0(n3281), .A1(n3269), .B0(n3261), .C0(n3402), .Y(n3383)
         );
  INVX1 U2054 ( .A(n3399), .Y(n3402) );
  NAND2BX1 U2055 ( .AN(WaitRsp), .B(CmdSentSet), .Y(n3260) );
  OAI211X1 U2056 ( .A0(n3297), .A1(n3404), .B0(n3293), .C0(n3298), .Y(n3400)
         );
  INVX1 U2057 ( .A(WaitRsp), .Y(n3404) );
  INVX1 U2058 ( .A(n3424), .Y(n3422) );
  INVX1 U2059 ( .A(n3297), .Y(CmdSentSet) );
  OAI211X1 U2060 ( .A0(n3364), .A1(n3405), .B0(n3406), .C0(n3260), .Y(n3401)
         );
  NAND2BX1 U2061 ( .AN(LongRsp), .B(n3407), .Y(n3405) );
  AOI31X1 U2062 ( .A0(n3407), .A1(LongRsp), .A2(n3543), .B0(CmdToutSet), .Y(
        n3406) );
  INVX1 U2063 ( .A(n3262), .Y(CmdToutSet) );
  OAI222X1 U2064 ( .A0(n3531), .A1(n3383), .B0(SDreset), .B1(n3390), .C0(n3384), .C1(n3391), .Y(n3207) );
  NAND2BX1 U2065 ( .AN(SDreset), .B(CMDCnt1567_3_), .Y(n3391) );
  INVX1 U2066 ( .A(n3495), .Y(CRCShift1652_0_) );
  NAND2BX1 U2067 ( .AN(SDreset), .B(n3473), .Y(n3495) );
  INVX1 U2068 ( .A(n3485), .Y(CRCShift1652_3_) );
  NAND2BX1 U2069 ( .AN(SDreset), .B(n3469), .Y(n3485) );
  INVX1 U2070 ( .A(n3493), .Y(CRCShift1652_1_) );
  NAND2BX1 U2071 ( .AN(n3548), .B(n3261), .Y(n3493) );
  INVX1 U2072 ( .A(n3491), .Y(CRCShift1652_2_) );
  NAND2BX1 U2073 ( .AN(n3547), .B(n3261), .Y(n3491) );
  INVX1 U2074 ( .A(n3483), .Y(CRCShift1652_4_) );
  NAND2BX1 U2075 ( .AN(n3546), .B(n3261), .Y(n3483) );
  INVX1 U2076 ( .A(n3481), .Y(CRCShift1652_5_) );
  NAND2BX1 U2077 ( .AN(n3545), .B(n3261), .Y(n3481) );
  INVX1 U2078 ( .A(n3478), .Y(CRCShift1652_6_) );
  NAND2BX1 U2079 ( .AN(n3544), .B(n3261), .Y(n3478) );
  NAND3BX1 U2080 ( .AN(n3422), .B(n3261), .C(LongRsp), .Y(n3428) );
  OAI31X1 U2081 ( .A0(n3419), .A1(n3551), .A2(n3421), .B0(n3261), .Y(n3415) );
  NAND3BX1 U2082 ( .AN(SDreset), .B(n3297), .C(n3298), .Y(n3265) );
  AND2X2 U2083 ( .A(n3342), .B(n3338), .Y(n3542) );
  INVX1 U2084 ( .A(n3336), .Y(n3302) );
  NAND2BX1 U2085 ( .AN(n3337), .B(n3338), .Y(n3336) );
  INVX1 U2086 ( .A(n3338), .Y(n3301) );
  NAND3BX1 U2087 ( .AN(n3280), .B(n3281), .C(n3271), .Y(n3272) );
  INVX1 U2088 ( .A(n3298), .Y(CMSTClr) );
  AND2X2 U2089 ( .A(n3261), .B(n3499), .Y(CRCRxMode1784) );
  INVX1 U2090 ( .A(n3364), .Y(n3369) );
  INVX1 U2091 ( .A(n3293), .Y(n3292) );
  OAI32X1 U2092 ( .A0(n3272), .A1(n3537), .A2(n3278), .B0(n3521), .B1(n3271), 
        .Y(n3247) );
  NAND2BX1 U2093 ( .AN(SDreset), .B(n3520), .Y(n3278) );
  OAI32X1 U2094 ( .A0(RspFinSet), .A1(SDreset), .A2(n3539), .B0(SDreset), .B1(
        n3293), .Y(n3244) );
  INVX1 U2095 ( .A(LongRsp), .Y(n3441) );
  NOR2X1 U2096 ( .A(n3458), .B(n3375), .Y(n3543) );
  NAND4BX1 U2097 ( .AN(n3375), .B(n3532), .C(n3515), .D(n3518), .Y(n3361) );
  NAND2BX1 U2098 ( .AN(n3551), .B(n3454), .Y(n3268) );
  INVX1 U2099 ( .A(n3372), .Y(n3348) );
  NAND2BX1 U2100 ( .AN(SDreset), .B(n3342), .Y(n3372) );
  INVX1 U2101 ( .A(neg_CKPulse), .Y(n3263) );
  INVX1 U2102 ( .A(n3337), .Y(n3350) );
  INVX1 U2103 ( .A(n3380), .Y(n3371) );
  INVX1 U2104 ( .A(n3381), .Y(n3346) );
  NAND2BX1 U2105 ( .AN(n3540), .B(n3363), .Y(n3381) );
  INVX1 U2106 ( .A(n3280), .Y(n3276) );
  NAND3BX1 U2107 ( .AN(CMDIN), .B(CMDState_2_), .C(CKPulse), .Y(n3293) );
  NAND3BX1 U2108 ( .AN(n3507), .B(n3407), .C(n3508), .Y(n3464) );
  NAND3BX1 U2109 ( .AN(CMDCnt[4]), .B(n3532), .C(CMDCnt[0]), .Y(n3507) );
  OAI32X1 U2110 ( .A0(n3509), .A1(n3518), .A2(n3515), .B0(LongRsp), .B1(n3455), 
        .Y(n3508) );
  NAND3BX1 U2111 ( .AN(CMDCnt[3]), .B(n3551), .C(n3516), .Y(n3509) );
  AO21X1 U2112 ( .A0(CRCShift[3]), .A1(n3269), .B0(n3486), .Y(n3469) );
  OAI33X1 U2113 ( .A0(n3487), .A1(CRCShift[2]), .A2(n3488), .B0(n3487), .B1(
        n3489), .B2(n3536), .Y(n3486) );
  INVX1 U2114 ( .A(n3489), .Y(n3488) );
  NAND2BX1 U2115 ( .AN(n3269), .B(CCMDState3), .Y(n3503) );
  OAI222X1 U2116 ( .A0(LongRsp), .A1(n3293), .B0(n3501), .B1(n3535), .C0(n3503), .C1(n3380), .Y(n3499) );
  INVX1 U2117 ( .A(n3464), .Y(n3501) );
  OAI31X1 U2118 ( .A0(n3499), .A1(CRCTxMode), .A2(CRCRxMode), .B0(CKPulse), 
        .Y(n3487) );
  AOI211X1 U2119 ( .A0(n3462), .A1(n3463), .B0(NoCRCRsp), .C0(n3464), .Y(
        RspCrcSet) );
  AND3X2 U2120 ( .A(n3548), .B(n3547), .C(n3472), .Y(n3462) );
  AND4X1 U2121 ( .A(n3465), .B(n3546), .C(n3545), .D(n3544), .Y(n3463) );
  AO22X1 U2122 ( .A0(CRCShift[0]), .A1(n3269), .B0(n3480), .B1(n3489), .Y(
        n3473) );
  AOI22X1 U2123 ( .A0(CRCShift[6]), .A1(n3269), .B0(CRCShift[5]), .B1(n3480), 
        .Y(n3544) );
  AOI22X1 U2124 ( .A0(CRCShift[5]), .A1(n3269), .B0(CRCShift[4]), .B1(n3480), 
        .Y(n3545) );
  AOI22X1 U2125 ( .A0(CRCShift[4]), .A1(n3269), .B0(CRCShift[3]), .B1(n3480), 
        .Y(n3546) );
  AOI22X1 U2126 ( .A0(CRCShift[2]), .A1(n3269), .B0(CRCShift[1]), .B1(n3480), 
        .Y(n3547) );
  AOI22X1 U2127 ( .A0(CRCShift[1]), .A1(n3269), .B0(CRCShift[0]), .B1(n3480), 
        .Y(n3548) );
  NAND4BX1 U2128 ( .AN(n3474), .B(CMDCnt[0]), .C(CKPulse), .D(n3475), .Y(n3262) );
  NAND3BX1 U2129 ( .AN(n3532), .B(CMDCnt[4]), .C(CMDState_2_), .Y(n3474) );
  INVX1 U2130 ( .A(n3455), .Y(n3475) );
  NAND4X1 U2131 ( .A(CMST), .B(CmdCtrlIdle), .C(CKPulse), .D(n3281), .Y(n3298)
         );
  NAND4BX1 U2132 ( .AN(CMDCnt[7]), .B(n3516), .C(CMDCnt[2]), .D(n3550), .Y(
        n3455) );
  NAND3BX1 U2133 ( .AN(n3506), .B(CMDCnt[0]), .C(CMDCnt[1]), .Y(n3421) );
  NAND3BX1 U2134 ( .AN(CMDCnt[7]), .B(n3533), .C(CMDCnt[2]), .Y(n3506) );
  OR2X1 U2135 ( .A(n3421), .B(n3549), .Y(n3297) );
  NAND4X1 U2136 ( .A(CKPulse), .B(n3516), .C(CMDState_1_), .D(n3550), .Y(n3549) );
  NAND2BX1 U2137 ( .AN(CMDCnt[5]), .B(n3454), .Y(n3380) );
  OAI31X1 U2138 ( .A0(n3419), .A1(CMDCnt[5]), .A2(n3421), .B0(n3261), .Y(n3424) );
  NAND3BX1 U2139 ( .AN(CMDCnt[3]), .B(CMDCnt[6]), .C(n3407), .Y(n3419) );
  AO22X1 U2140 ( .A0(CMDShift_30_), .A1(n3343), .B0(n3359), .B1(n3345), .Y(
        n3212) );
  OAI2BB1X1 U2141 ( .A0N(CRCShift1652_5_), .A1N(n3346), .B0(n3360), .Y(n3359)
         );
  AOI222X1 U2142 ( .A0(CMDShift_29_), .A1(n3348), .B0(CmdIndex[5]), .B1(n3349), 
        .C0(SDICmdArg[30]), .C1(n3350), .Y(n3360) );
  AO22X1 U2143 ( .A0(CMDShift_29_), .A1(n3343), .B0(n3357), .B1(n3345), .Y(
        n3213) );
  OAI2BB1X1 U2144 ( .A0N(CRCShift1652_4_), .A1N(n3346), .B0(n3358), .Y(n3357)
         );
  AOI222X1 U2145 ( .A0(CMDShift_28_), .A1(n3348), .B0(CmdIndex[4]), .B1(n3349), 
        .C0(SDICmdArg[29]), .C1(n3350), .Y(n3358) );
  AO22X1 U2146 ( .A0(CMDShift_28_), .A1(n3343), .B0(n3355), .B1(n3345), .Y(
        n3214) );
  OAI2BB1X1 U2147 ( .A0N(CRCShift1652_3_), .A1N(n3346), .B0(n3356), .Y(n3355)
         );
  AOI222X1 U2148 ( .A0(CMDShift_27_), .A1(n3348), .B0(CmdIndex[3]), .B1(n3349), 
        .C0(SDICmdArg[28]), .C1(n3350), .Y(n3356) );
  AO22X1 U2149 ( .A0(CMDShift_27_), .A1(n3343), .B0(n3353), .B1(n3345), .Y(
        n3215) );
  OAI2BB1X1 U2150 ( .A0N(CRCShift1652_2_), .A1N(n3346), .B0(n3354), .Y(n3353)
         );
  AOI222X1 U2151 ( .A0(CMDShift_26_), .A1(n3348), .B0(CmdIndex[2]), .B1(n3349), 
        .C0(SDICmdArg[27]), .C1(n3350), .Y(n3354) );
  AO22X1 U2152 ( .A0(CMDShift_26_), .A1(n3343), .B0(n3351), .B1(n3345), .Y(
        n3216) );
  OAI2BB1X1 U2153 ( .A0N(CRCShift1652_1_), .A1N(n3346), .B0(n3352), .Y(n3351)
         );
  AOI222X1 U2154 ( .A0(CMDShift_25_), .A1(n3348), .B0(CmdIndex[1]), .B1(n3349), 
        .C0(SDICmdArg[26]), .C1(n3350), .Y(n3352) );
  AO22X1 U2155 ( .A0(CMDShift_25_), .A1(n3343), .B0(n3344), .B1(n3345), .Y(
        n3217) );
  OAI2BB1X1 U2156 ( .A0N(CRCShift1652_0_), .A1N(n3346), .B0(n3347), .Y(n3344)
         );
  AOI222X1 U2157 ( .A0(n3348), .A1(CMDShift_24_), .B0(CmdIndex[0]), .B1(n3349), 
        .C0(SDICmdArg[25]), .C1(n3350), .Y(n3347) );
  NOR2X1 U2158 ( .A(n3531), .B(n3551), .Y(n3550) );
  INVX1 U2159 ( .A(n3504), .Y(n3454) );
  NAND3BX1 U2160 ( .AN(CMDCnt[6]), .B(n3531), .C(n3505), .Y(n3504) );
  INVX1 U2161 ( .A(n3421), .Y(n3505) );
  OAI222X1 U2162 ( .A0(n3424), .A1(n3066), .B0(n3555), .B1(n3426), .C0(n3523), 
        .C1(n3428), .Y(n3100) );
  OAI222X1 U2163 ( .A0(n3424), .A1(n3065), .B0(n3557), .B1(n3426), .C0(n3524), 
        .C1(n3428), .Y(n3101) );
  OAI222X1 U2164 ( .A0(n3424), .A1(n3064), .B0(n3559), .B1(n3426), .C0(n3525), 
        .C1(n3428), .Y(n3102) );
  OAI222X1 U2165 ( .A0(n3424), .A1(n3063), .B0(n3561), .B1(n3426), .C0(n3526), 
        .C1(n3428), .Y(n3103) );
  OAI222X1 U2166 ( .A0(n3424), .A1(n3062), .B0(n3563), .B1(n3426), .C0(n3527), 
        .C1(n3428), .Y(n3104) );
  OAI222X1 U2167 ( .A0(n3424), .A1(n3061), .B0(n3565), .B1(n3426), .C0(n3528), 
        .C1(n3428), .Y(n3105) );
  OAI222X1 U2168 ( .A0(n3424), .A1(n3060), .B0(n3553), .B1(n3426), .C0(n3522), 
        .C1(n3428), .Y(n3106) );
  OAI221X1 U2169 ( .A0(n3517), .A1(n3383), .B0(CMDCnt[0]), .B1(n3384), .C0(
        n3261), .Y(n3210) );
  OAI32X1 U2170 ( .A0(SDreset), .A1(n3534), .A2(CKPulse), .B0(n3366), .B1(
        n3269), .Y(n3211) );
  AOI221X1 U2171 ( .A0(CRCShift1652_6_), .A1(n3346), .B0(CMDShift_30_), .B1(
        n3348), .C0(n3367), .Y(n3366) );
  OAI2BB1X1 U2172 ( .A0N(SDICmdArg[31]), .A1N(n3350), .B0(n3368), .Y(n3367) );
  AO21X1 U2173 ( .A0(CMDCnt1567_6_), .A1(n3385), .B0(n3395), .Y(n3204) );
  AO21X1 U2174 ( .A0(n3387), .A1(CMDCnt[6]), .B0(n3393), .Y(n3395) );
  AO21X1 U2175 ( .A0(CMDCnt1567_5_), .A1(n3385), .B0(n3394), .Y(n3205) );
  AO21X1 U2176 ( .A0(n3387), .A1(CMDCnt[5]), .B0(n3393), .Y(n3394) );
  AO21X1 U2177 ( .A0(CMDCnt1567_4_), .A1(n3385), .B0(n3392), .Y(n3206) );
  AO21X1 U2178 ( .A0(n3387), .A1(CMDCnt[4]), .B0(n3393), .Y(n3392) );
  AO21X1 U2179 ( .A0(CMDCnt1567_2_), .A1(n3385), .B0(n3388), .Y(n3208) );
  AO21X1 U2180 ( .A0(n3387), .A1(CMDCnt[2]), .B0(SDreset), .Y(n3388) );
  AO21X1 U2181 ( .A0(CMDCnt1567_1_), .A1(n3385), .B0(n3386), .Y(n3209) );
  AO21X1 U2182 ( .A0(n3387), .A1(CMDCnt[1]), .B0(SDreset), .Y(n3386) );
  OAI211X1 U2183 ( .A0(n3515), .A1(n3383), .B0(n3396), .C0(n3397), .Y(n3203)
         );
  INVX1 U2184 ( .A(n3393), .Y(n3396) );
  AOI33X1 U2185 ( .A0(n3515), .A1(n3398), .A2(n3385), .B0(n1), .B1(CMDCnt[7]), 
        .B2(n3385), .Y(n3397) );
  INVX1 U2186 ( .A(n1), .Y(n3398) );
  NAND4BX1 U2187 ( .AN(n3455), .B(n3533), .C(CMDCnt[1]), .D(n3517), .Y(n3364)
         );
  NAND3BX1 U2188 ( .AN(n3460), .B(n3531), .C(n3517), .Y(n3375) );
  NAND3BX1 U2189 ( .AN(CMDCnt[4]), .B(n3551), .C(n3516), .Y(n3460) );
  NAND3BX1 U2190 ( .AN(n3518), .B(CMDCnt[1]), .C(CMDCnt[7]), .Y(n3458) );
  NAND3BX1 U2191 ( .AN(n3287), .B(n3288), .C(n3289), .Y(n3271) );
  AOI33X1 U2192 ( .A0(CMST), .A1(CmdCtrlIdle), .A2(CKPulse), .B0(n3520), .B1(
        n3537), .B2(n3276), .Y(n3289) );
  OAI211X1 U2193 ( .A0(n3520), .A1(n3537), .B0(n3568), .C0(n3290), .Y(n3287)
         );
  OAI31X1 U2194 ( .A0(n3291), .A1(CmdSentSet), .A2(n3292), .B0(n3280), .Y(
        n3290) );
  OAI221X1 U2195 ( .A0(CMDTxMode), .A1(n3269), .B0(n3362), .B1(n3363), .C0(
        n3261), .Y(n3338) );
  NAND3BX1 U2196 ( .AN(n3269), .B(n3361), .C(n3364), .Y(n3362) );
  NAND2BX1 U2197 ( .AN(n3496), .B(n3497), .Y(n3489) );
  AOI33X1 U2198 ( .A0(CRCShift[6]), .A1(n3534), .A2(CRCTxMode), .B0(CMDOUT), 
        .B1(n3519), .B2(CRCTxMode), .Y(n3497) );
  OAI33X1 U2199 ( .A0(n3286), .A1(CRCTxMode), .A2(CRCShift[6]), .B0(n3519), 
        .B1(CRCTxMode), .B2(CMDIN), .Y(n3496) );
  NAND4BX1 U2200 ( .AN(CCMDState3), .B(n3537), .C(n3261), .D(n3271), .Y(n3282)
         );
  NAND3BX1 U2201 ( .AN(CmdCtrlIdle), .B(n3520), .C(n3262), .Y(n3291) );
  AO21X1 U2202 ( .A0(SDICmdArg[7]), .A1(n3302), .B0(n3316), .Y(n3235) );
  AO22X1 U2203 ( .A0(n3554), .A1(n3542), .B0(CMDShift_7_), .B1(n3301), .Y(
        n3316) );
  AO21X1 U2204 ( .A0(SDICmdArg[8]), .A1(n3302), .B0(n3318), .Y(n3234) );
  AO22X1 U2205 ( .A0(n3566), .A1(n3542), .B0(CMDShift_8_), .B1(n3301), .Y(
        n3318) );
  AO21X1 U2206 ( .A0(SDICmdArg[6]), .A1(n3302), .B0(n3314), .Y(n3236) );
  AO22X1 U2207 ( .A0(n3556), .A1(n3542), .B0(CMDShift_6_), .B1(n3301), .Y(
        n3314) );
  AO21X1 U2208 ( .A0(SDICmdArg[5]), .A1(n3302), .B0(n3312), .Y(n3237) );
  AO22X1 U2209 ( .A0(n3558), .A1(n3542), .B0(CMDShift_5_), .B1(n3301), .Y(
        n3312) );
  AO21X1 U2210 ( .A0(SDICmdArg[4]), .A1(n3302), .B0(n3310), .Y(n3238) );
  AO22X1 U2211 ( .A0(n3560), .A1(n3542), .B0(CMDShift_4_), .B1(n3301), .Y(
        n3310) );
  AO21X1 U2212 ( .A0(SDICmdArg[3]), .A1(n3302), .B0(n3308), .Y(n3239) );
  AO22X1 U2213 ( .A0(n3562), .A1(n3542), .B0(CMDShift_3_), .B1(n3301), .Y(
        n3308) );
  AO21X1 U2214 ( .A0(SDICmdArg[2]), .A1(n3302), .B0(n3306), .Y(n3240) );
  AO22X1 U2215 ( .A0(n3564), .A1(n3542), .B0(CMDShift_2_), .B1(n3301), .Y(
        n3306) );
  AO21X1 U2216 ( .A0(SDICmdArg[1]), .A1(n3302), .B0(n3303), .Y(n3241) );
  AO22X1 U2217 ( .A0(n3552), .A1(n3542), .B0(CMDShift_1_), .B1(n3301), .Y(
        n3303) );
  AO22X1 U2218 ( .A0(n3270), .A1(n3271), .B0(CmdCtrlIdle), .B1(n3272), .Y(
        n3248) );
  OAI211X1 U2219 ( .A0(WaitRsp), .A1(n3521), .B0(n3568), .C0(n3275), .Y(n3270)
         );
  AOI221X1 U2220 ( .A0(n3276), .A1(n3537), .B0(CMDIN), .B1(CMDState_2_), .C0(
        CCMDState3), .Y(n3275) );
  AO22X1 U2221 ( .A0(n3264), .A1(nCMDEN), .B0(n3265), .B1(n3259), .Y(n3250) );
  AO22X1 U2222 ( .A0(Response0[7]), .A1(n3442), .B0(n3566), .B1(n3530), .Y(
        n3091) );
  AO22X1 U2223 ( .A0(Response0[6]), .A1(n3442), .B0(n3554), .B1(n3530), .Y(
        n3092) );
  AO22X1 U2224 ( .A0(Response0[5]), .A1(n3442), .B0(n3556), .B1(n3530), .Y(
        n3093) );
  AO22X1 U2225 ( .A0(Response0[4]), .A1(n3442), .B0(n3558), .B1(n3530), .Y(
        n3094) );
  AO22X1 U2226 ( .A0(Response0[3]), .A1(n3442), .B0(n3560), .B1(n3530), .Y(
        n3095) );
  AO22X1 U2227 ( .A0(Response0[2]), .A1(n3442), .B0(n3562), .B1(n3530), .Y(
        n3096) );
  AO22X1 U2228 ( .A0(Response0[1]), .A1(n3442), .B0(n3564), .B1(n3530), .Y(
        n3097) );
  AO22X1 U2229 ( .A0(Response0[0]), .A1(n3442), .B0(n3552), .B1(n3530), .Y(
        n3098) );
  AO22X1 U2230 ( .A0(n3566), .A1(n3415), .B0(Response2[7]), .B1(n3416), .Y(
        n3155) );
  AO22X1 U2231 ( .A0(n3554), .A1(n3415), .B0(Response2[6]), .B1(n3416), .Y(
        n3156) );
  AO22X1 U2232 ( .A0(n3556), .A1(n3415), .B0(Response2[5]), .B1(n3416), .Y(
        n3157) );
  AO22X1 U2233 ( .A0(n3562), .A1(n3415), .B0(Response2[2]), .B1(n3416), .Y(
        n3160) );
  AO22X1 U2234 ( .A0(n3564), .A1(n3415), .B0(Response2[1]), .B1(n3416), .Y(
        n3161) );
  AO22X1 U2235 ( .A0(n3552), .A1(n3415), .B0(Response2[0]), .B1(n3416), .Y(
        n3162) );
  AO22X1 U2236 ( .A0(n3566), .A1(n3529), .B0(Response3[8]), .B1(n3411), .Y(
        n3186) );
  AO22X1 U2237 ( .A0(n3554), .A1(n3529), .B0(Response3[7]), .B1(n3411), .Y(
        n3187) );
  AO22X1 U2238 ( .A0(n3556), .A1(n3529), .B0(Response3[6]), .B1(n3411), .Y(
        n3188) );
  AO22X1 U2239 ( .A0(n3558), .A1(n3529), .B0(Response3[5]), .B1(n3411), .Y(
        n3189) );
  AO22X1 U2240 ( .A0(n3560), .A1(n3529), .B0(Response3[4]), .B1(n3411), .Y(
        n3190) );
  AO22X1 U2241 ( .A0(n3562), .A1(n3529), .B0(Response3[3]), .B1(n3411), .Y(
        n3191) );
  AO22X1 U2242 ( .A0(n3566), .A1(n3409), .B0(RspIndex[7]), .B1(n3410), .Y(
        n3195) );
  AO22X1 U2243 ( .A0(n3554), .A1(n3409), .B0(RspIndex[6]), .B1(n3410), .Y(
        n3196) );
  AO22X1 U2244 ( .A0(n3556), .A1(n3409), .B0(RspIndex[5]), .B1(n3410), .Y(
        n3197) );
  AO22X1 U2245 ( .A0(n3564), .A1(n3409), .B0(RspIndex[1]), .B1(n3410), .Y(
        n3201) );
  AO22X1 U2246 ( .A0(n3552), .A1(n3409), .B0(RspIndex[0]), .B1(n3410), .Y(
        n3202) );
  AO22X1 U2247 ( .A0(n3558), .A1(n3415), .B0(Response2[4]), .B1(n3416), .Y(
        n3158) );
  AO22X1 U2248 ( .A0(n3560), .A1(n3415), .B0(Response2[3]), .B1(n3416), .Y(
        n3159) );
  AO22X1 U2249 ( .A0(n3564), .A1(n3529), .B0(Response3[2]), .B1(n3411), .Y(
        n3192) );
  AO22X1 U2250 ( .A0(n3552), .A1(n3529), .B0(Response3[1]), .B1(n3411), .Y(
        n3193) );
  AO22X1 U2251 ( .A0(n3558), .A1(n3409), .B0(RspIndex[4]), .B1(n3410), .Y(
        n3198) );
  AO22X1 U2252 ( .A0(n3560), .A1(n3409), .B0(RspIndex[3]), .B1(n3410), .Y(
        n3199) );
  AO22X1 U2253 ( .A0(n3562), .A1(n3409), .B0(RspIndex[2]), .B1(n3410), .Y(
        n3200) );
  AO22X1 U2254 ( .A0(Response1[7]), .A1(n3422), .B0(n3423), .B1(CMDShift_7_), 
        .Y(n3123) );
  AO22X1 U2255 ( .A0(Response0[31]), .A1(n3442), .B0(n3452), .B1(CMDOUT), .Y(
        n3067) );
  AO22X1 U2256 ( .A0(Response0[30]), .A1(n3442), .B0(n3452), .B1(CMDShift_30_), 
        .Y(n3068) );
  AO22X1 U2257 ( .A0(Response0[29]), .A1(n3442), .B0(n3452), .B1(CMDShift_29_), 
        .Y(n3069) );
  AO22X1 U2258 ( .A0(Response0[28]), .A1(n3442), .B0(n3452), .B1(CMDShift_28_), 
        .Y(n3070) );
  AO22X1 U2259 ( .A0(Response0[27]), .A1(n3442), .B0(n3452), .B1(CMDShift_27_), 
        .Y(n3071) );
  AO22X1 U2260 ( .A0(Response0[26]), .A1(n3442), .B0(n3452), .B1(CMDShift_26_), 
        .Y(n3072) );
  AO22X1 U2261 ( .A0(Response0[25]), .A1(n3442), .B0(n3452), .B1(CMDShift_25_), 
        .Y(n3073) );
  AO22X1 U2262 ( .A0(Response0[24]), .A1(n3442), .B0(n3452), .B1(CMDShift_24_), 
        .Y(n3074) );
  AO22X1 U2263 ( .A0(Response0[23]), .A1(n3442), .B0(n3452), .B1(CMDShift_23_), 
        .Y(n3075) );
  AO22X1 U2264 ( .A0(Response0[22]), .A1(n3442), .B0(n3452), .B1(CMDShift_22_), 
        .Y(n3076) );
  AO22X1 U2265 ( .A0(Response0[21]), .A1(n3442), .B0(n3452), .B1(CMDShift_21_), 
        .Y(n3077) );
  AO22X1 U2266 ( .A0(Response0[20]), .A1(n3442), .B0(n3452), .B1(CMDShift_20_), 
        .Y(n3078) );
  AO22X1 U2267 ( .A0(Response0[19]), .A1(n3442), .B0(n3452), .B1(CMDShift_19_), 
        .Y(n3079) );
  AO22X1 U2268 ( .A0(Response0[18]), .A1(n3442), .B0(n3452), .B1(CMDShift_18_), 
        .Y(n3080) );
  AO22X1 U2269 ( .A0(Response0[17]), .A1(n3442), .B0(n3452), .B1(CMDShift_17_), 
        .Y(n3081) );
  AO22X1 U2270 ( .A0(Response0[16]), .A1(n3442), .B0(n3452), .B1(CMDShift_16_), 
        .Y(n3082) );
  AO22X1 U2271 ( .A0(Response0[15]), .A1(n3442), .B0(n3452), .B1(CMDShift_15_), 
        .Y(n3083) );
  AO22X1 U2272 ( .A0(Response0[14]), .A1(n3442), .B0(n3452), .B1(CMDShift_14_), 
        .Y(n3084) );
  AO22X1 U2273 ( .A0(Response0[13]), .A1(n3442), .B0(n3452), .B1(CMDShift_13_), 
        .Y(n3085) );
  AO22X1 U2274 ( .A0(Response0[12]), .A1(n3442), .B0(n3452), .B1(CMDShift_12_), 
        .Y(n3086) );
  AO22X1 U2275 ( .A0(Response0[11]), .A1(n3442), .B0(n3452), .B1(CMDShift_11_), 
        .Y(n3087) );
  AO22X1 U2276 ( .A0(Response0[10]), .A1(n3442), .B0(n3452), .B1(CMDShift_10_), 
        .Y(n3088) );
  AO22X1 U2277 ( .A0(Response0[9]), .A1(n3442), .B0(n3452), .B1(CMDShift_9_), 
        .Y(n3089) );
  AO22X1 U2278 ( .A0(Response0[8]), .A1(n3442), .B0(n3452), .B1(CMDShift_8_), 
        .Y(n3090) );
  AO22X1 U2279 ( .A0(Response2[31]), .A1(n3416), .B0(n3417), .B1(CMDOUT), .Y(
        n3131) );
  AO22X1 U2280 ( .A0(Response2[30]), .A1(n3416), .B0(n3417), .B1(CMDShift_30_), 
        .Y(n3132) );
  AO22X1 U2281 ( .A0(Response2[29]), .A1(n3416), .B0(n3417), .B1(CMDShift_29_), 
        .Y(n3133) );
  AO22X1 U2282 ( .A0(Response2[28]), .A1(n3416), .B0(n3417), .B1(CMDShift_28_), 
        .Y(n3134) );
  AO22X1 U2283 ( .A0(Response2[27]), .A1(n3416), .B0(n3417), .B1(CMDShift_27_), 
        .Y(n3135) );
  AO22X1 U2284 ( .A0(Response2[26]), .A1(n3416), .B0(n3417), .B1(CMDShift_26_), 
        .Y(n3136) );
  AO22X1 U2285 ( .A0(Response2[25]), .A1(n3416), .B0(n3417), .B1(CMDShift_25_), 
        .Y(n3137) );
  AO22X1 U2286 ( .A0(Response2[24]), .A1(n3416), .B0(n3417), .B1(CMDShift_24_), 
        .Y(n3138) );
  AO22X1 U2287 ( .A0(Response2[23]), .A1(n3416), .B0(n3417), .B1(CMDShift_23_), 
        .Y(n3139) );
  AO22X1 U2288 ( .A0(Response2[22]), .A1(n3416), .B0(n3417), .B1(CMDShift_22_), 
        .Y(n3140) );
  AO22X1 U2289 ( .A0(Response2[21]), .A1(n3416), .B0(n3417), .B1(CMDShift_21_), 
        .Y(n3141) );
  AO22X1 U2290 ( .A0(Response2[20]), .A1(n3416), .B0(n3417), .B1(CMDShift_20_), 
        .Y(n3142) );
  AO22X1 U2291 ( .A0(Response2[19]), .A1(n3416), .B0(n3417), .B1(CMDShift_19_), 
        .Y(n3143) );
  AO22X1 U2292 ( .A0(Response2[18]), .A1(n3416), .B0(n3417), .B1(CMDShift_18_), 
        .Y(n3144) );
  AO22X1 U2293 ( .A0(Response2[17]), .A1(n3416), .B0(n3417), .B1(CMDShift_17_), 
        .Y(n3145) );
  AO22X1 U2294 ( .A0(Response2[16]), .A1(n3416), .B0(n3417), .B1(CMDShift_16_), 
        .Y(n3146) );
  AO22X1 U2295 ( .A0(Response2[15]), .A1(n3416), .B0(n3417), .B1(CMDShift_15_), 
        .Y(n3147) );
  AO22X1 U2296 ( .A0(Response2[14]), .A1(n3416), .B0(n3417), .B1(CMDShift_14_), 
        .Y(n3148) );
  AO22X1 U2297 ( .A0(Response2[13]), .A1(n3416), .B0(n3417), .B1(CMDShift_13_), 
        .Y(n3149) );
  AO22X1 U2298 ( .A0(Response2[12]), .A1(n3416), .B0(n3417), .B1(CMDShift_12_), 
        .Y(n3150) );
  AO22X1 U2299 ( .A0(Response2[11]), .A1(n3416), .B0(n3417), .B1(CMDShift_11_), 
        .Y(n3151) );
  AO22X1 U2300 ( .A0(Response2[10]), .A1(n3416), .B0(n3417), .B1(CMDShift_10_), 
        .Y(n3152) );
  AO22X1 U2301 ( .A0(Response2[9]), .A1(n3416), .B0(n3417), .B1(CMDShift_9_), 
        .Y(n3153) );
  AO22X1 U2302 ( .A0(Response2[8]), .A1(n3416), .B0(n3417), .B1(CMDShift_8_), 
        .Y(n3154) );
  AO22X1 U2303 ( .A0(Response3[31]), .A1(n3411), .B0(n3412), .B1(CMDShift_30_), 
        .Y(n3163) );
  AO22X1 U2304 ( .A0(Response3[30]), .A1(n3411), .B0(n3412), .B1(CMDShift_29_), 
        .Y(n3164) );
  AO22X1 U2305 ( .A0(Response3[29]), .A1(n3411), .B0(n3412), .B1(CMDShift_28_), 
        .Y(n3165) );
  AO22X1 U2306 ( .A0(Response3[28]), .A1(n3411), .B0(n3412), .B1(CMDShift_27_), 
        .Y(n3166) );
  AO22X1 U2307 ( .A0(Response3[27]), .A1(n3411), .B0(n3412), .B1(CMDShift_26_), 
        .Y(n3167) );
  AO22X1 U2308 ( .A0(Response3[26]), .A1(n3411), .B0(n3412), .B1(CMDShift_25_), 
        .Y(n3168) );
  AO22X1 U2309 ( .A0(Response3[25]), .A1(n3411), .B0(n3412), .B1(CMDShift_24_), 
        .Y(n3169) );
  AO22X1 U2310 ( .A0(Response3[24]), .A1(n3411), .B0(n3412), .B1(CMDShift_23_), 
        .Y(n3170) );
  AO22X1 U2311 ( .A0(Response3[23]), .A1(n3411), .B0(n3412), .B1(CMDShift_22_), 
        .Y(n3171) );
  AO22X1 U2312 ( .A0(Response3[22]), .A1(n3411), .B0(n3412), .B1(CMDShift_21_), 
        .Y(n3172) );
  AO22X1 U2313 ( .A0(Response3[21]), .A1(n3411), .B0(n3412), .B1(CMDShift_20_), 
        .Y(n3173) );
  AO22X1 U2314 ( .A0(Response3[20]), .A1(n3411), .B0(n3412), .B1(CMDShift_19_), 
        .Y(n3174) );
  AO22X1 U2315 ( .A0(Response3[19]), .A1(n3411), .B0(n3412), .B1(CMDShift_18_), 
        .Y(n3175) );
  AO22X1 U2316 ( .A0(Response3[18]), .A1(n3411), .B0(n3412), .B1(CMDShift_17_), 
        .Y(n3176) );
  AO22X1 U2317 ( .A0(Response3[17]), .A1(n3411), .B0(n3412), .B1(CMDShift_16_), 
        .Y(n3177) );
  AO22X1 U2318 ( .A0(Response3[16]), .A1(n3411), .B0(n3412), .B1(CMDShift_15_), 
        .Y(n3178) );
  AO22X1 U2319 ( .A0(Response3[15]), .A1(n3411), .B0(n3412), .B1(CMDShift_14_), 
        .Y(n3179) );
  AO22X1 U2320 ( .A0(Response3[14]), .A1(n3411), .B0(n3412), .B1(CMDShift_13_), 
        .Y(n3180) );
  AO22X1 U2321 ( .A0(Response3[13]), .A1(n3411), .B0(n3412), .B1(CMDShift_12_), 
        .Y(n3181) );
  AO22X1 U2322 ( .A0(Response3[12]), .A1(n3411), .B0(n3412), .B1(CMDShift_11_), 
        .Y(n3182) );
  AO22X1 U2323 ( .A0(Response3[11]), .A1(n3411), .B0(n3412), .B1(CMDShift_10_), 
        .Y(n3183) );
  AO22X1 U2324 ( .A0(Response3[10]), .A1(n3411), .B0(n3412), .B1(CMDShift_9_), 
        .Y(n3184) );
  AO22X1 U2325 ( .A0(Response3[9]), .A1(n3411), .B0(n3412), .B1(CMDShift_8_), 
        .Y(n3185) );
  AO22X1 U2326 ( .A0(Response1[23]), .A1(n3422), .B0(n3423), .B1(CMDShift_23_), 
        .Y(n3107) );
  AO22X1 U2327 ( .A0(Response1[22]), .A1(n3422), .B0(n3423), .B1(CMDShift_22_), 
        .Y(n3108) );
  AO22X1 U2328 ( .A0(Response1[21]), .A1(n3422), .B0(n3423), .B1(CMDShift_21_), 
        .Y(n3109) );
  AO22X1 U2329 ( .A0(Response1[20]), .A1(n3422), .B0(n3423), .B1(CMDShift_20_), 
        .Y(n3110) );
  AO22X1 U2330 ( .A0(Response1[19]), .A1(n3422), .B0(n3423), .B1(CMDShift_19_), 
        .Y(n3111) );
  AO22X1 U2331 ( .A0(Response1[18]), .A1(n3422), .B0(n3423), .B1(CMDShift_18_), 
        .Y(n3112) );
  AO22X1 U2332 ( .A0(Response1[17]), .A1(n3422), .B0(n3423), .B1(CMDShift_17_), 
        .Y(n3113) );
  AO22X1 U2333 ( .A0(Response1[16]), .A1(n3422), .B0(n3423), .B1(CMDShift_16_), 
        .Y(n3114) );
  AO22X1 U2334 ( .A0(Response1[15]), .A1(n3422), .B0(n3423), .B1(CMDShift_15_), 
        .Y(n3115) );
  AO22X1 U2335 ( .A0(Response1[14]), .A1(n3422), .B0(n3423), .B1(CMDShift_14_), 
        .Y(n3116) );
  AO22X1 U2336 ( .A0(Response1[13]), .A1(n3422), .B0(n3423), .B1(CMDShift_13_), 
        .Y(n3117) );
  AO22X1 U2337 ( .A0(Response1[12]), .A1(n3422), .B0(n3423), .B1(CMDShift_12_), 
        .Y(n3118) );
  AO22X1 U2338 ( .A0(Response1[11]), .A1(n3422), .B0(n3423), .B1(CMDShift_11_), 
        .Y(n3119) );
  AO22X1 U2339 ( .A0(Response1[10]), .A1(n3422), .B0(n3423), .B1(CMDShift_10_), 
        .Y(n3120) );
  AO22X1 U2340 ( .A0(Response1[9]), .A1(n3422), .B0(n3423), .B1(CMDShift_9_), 
        .Y(n3121) );
  AO22X1 U2341 ( .A0(Response1[8]), .A1(n3422), .B0(n3423), .B1(CMDShift_8_), 
        .Y(n3122) );
  AO22X1 U2342 ( .A0(Response1[31]), .A1(n3422), .B0(n3423), .B1(CMDOUT), .Y(
        n3099) );
  AO22X1 U2343 ( .A0(Response1[6]), .A1(n3422), .B0(n3423), .B1(CMDShift_6_), 
        .Y(n3124) );
  AO22X1 U2344 ( .A0(Response1[5]), .A1(n3422), .B0(n3423), .B1(CMDShift_5_), 
        .Y(n3125) );
  AO22X1 U2345 ( .A0(Response1[4]), .A1(n3422), .B0(n3423), .B1(CMDShift_4_), 
        .Y(n3126) );
  AO22X1 U2346 ( .A0(Response1[3]), .A1(n3422), .B0(n3423), .B1(CMDShift_3_), 
        .Y(n3127) );
  AO22X1 U2347 ( .A0(Response1[2]), .A1(n3422), .B0(n3423), .B1(CMDShift_2_), 
        .Y(n3128) );
  AO22X1 U2348 ( .A0(Response1[1]), .A1(n3422), .B0(n3423), .B1(CMDShift_1_), 
        .Y(n3129) );
  AO22X1 U2349 ( .A0(Response1[0]), .A1(n3422), .B0(n3423), .B1(CMDShift_0_), 
        .Y(n3130) );
  OAI32X1 U2350 ( .A0(n3282), .A1(n3538), .A2(n3285), .B0(n3520), .B1(n3271), 
        .Y(n3245) );
  NAND2BX1 U2351 ( .AN(CMDState_1_), .B(n3286), .Y(n3285) );
  OAI32X1 U2352 ( .A0(n3282), .A1(n3283), .A2(n3521), .B0(n3538), .B1(n3271), 
        .Y(n3246) );
  NAND2BX1 U2353 ( .AN(CMDState_2_), .B(WaitRsp), .Y(n3283) );
  AO21X1 U2354 ( .A0(n3299), .A1(CMDIN), .B0(n3300), .Y(n3242) );
  AO22X1 U2355 ( .A0(CMDShift_0_), .A1(n3301), .B0(SDICmdArg[0]), .B1(n3302), 
        .Y(n3300) );
  OAI2BB1X1 U2356 ( .A0N(CMDTxMode), .A1N(n3264), .B0(n3259), .Y(n3243) );
  AO21X1 U2357 ( .A0(CMDShift_23_), .A1(n3299), .B0(n3335), .Y(n3218) );
  AO22X1 U2358 ( .A0(CMDShift_24_), .A1(n3301), .B0(SDICmdArg[24]), .B1(n3302), 
        .Y(n3335) );
  AO21X1 U2359 ( .A0(CMDShift_22_), .A1(n3299), .B0(n3334), .Y(n3219) );
  AO22X1 U2360 ( .A0(CMDShift_23_), .A1(n3301), .B0(SDICmdArg[23]), .B1(n3302), 
        .Y(n3334) );
  AO21X1 U2361 ( .A0(CMDShift_21_), .A1(n3299), .B0(n3333), .Y(n3220) );
  AO22X1 U2362 ( .A0(CMDShift_22_), .A1(n3301), .B0(SDICmdArg[22]), .B1(n3302), 
        .Y(n3333) );
  AO21X1 U2363 ( .A0(CMDShift_20_), .A1(n3299), .B0(n3332), .Y(n3221) );
  AO22X1 U2364 ( .A0(CMDShift_21_), .A1(n3301), .B0(SDICmdArg[21]), .B1(n3302), 
        .Y(n3332) );
  AO21X1 U2365 ( .A0(CMDShift_19_), .A1(n3299), .B0(n3331), .Y(n3222) );
  AO22X1 U2366 ( .A0(CMDShift_20_), .A1(n3301), .B0(SDICmdArg[20]), .B1(n3302), 
        .Y(n3331) );
  AO21X1 U2367 ( .A0(CMDShift_18_), .A1(n3299), .B0(n3330), .Y(n3223) );
  AO22X1 U2368 ( .A0(CMDShift_19_), .A1(n3301), .B0(SDICmdArg[19]), .B1(n3302), 
        .Y(n3330) );
  AO21X1 U2369 ( .A0(CMDShift_17_), .A1(n3299), .B0(n3329), .Y(n3224) );
  AO22X1 U2370 ( .A0(CMDShift_18_), .A1(n3301), .B0(SDICmdArg[18]), .B1(n3302), 
        .Y(n3329) );
  AO21X1 U2371 ( .A0(CMDShift_16_), .A1(n3299), .B0(n3328), .Y(n3225) );
  AO22X1 U2372 ( .A0(CMDShift_17_), .A1(n3301), .B0(SDICmdArg[17]), .B1(n3302), 
        .Y(n3328) );
  AO21X1 U2373 ( .A0(CMDShift_15_), .A1(n3299), .B0(n3327), .Y(n3226) );
  AO22X1 U2374 ( .A0(CMDShift_16_), .A1(n3301), .B0(SDICmdArg[16]), .B1(n3302), 
        .Y(n3327) );
  AO21X1 U2375 ( .A0(CMDShift_14_), .A1(n3299), .B0(n3326), .Y(n3227) );
  AO22X1 U2376 ( .A0(CMDShift_15_), .A1(n3301), .B0(SDICmdArg[15]), .B1(n3302), 
        .Y(n3326) );
  AO21X1 U2377 ( .A0(CMDShift_13_), .A1(n3299), .B0(n3325), .Y(n3228) );
  AO22X1 U2378 ( .A0(CMDShift_14_), .A1(n3301), .B0(SDICmdArg[14]), .B1(n3302), 
        .Y(n3325) );
  AO21X1 U2379 ( .A0(CMDShift_12_), .A1(n3299), .B0(n3324), .Y(n3229) );
  AO22X1 U2380 ( .A0(CMDShift_13_), .A1(n3301), .B0(SDICmdArg[13]), .B1(n3302), 
        .Y(n3324) );
  AO21X1 U2381 ( .A0(CMDShift_11_), .A1(n3299), .B0(n3323), .Y(n3230) );
  AO22X1 U2382 ( .A0(CMDShift_12_), .A1(n3301), .B0(SDICmdArg[12]), .B1(n3302), 
        .Y(n3323) );
  AO21X1 U2383 ( .A0(CMDShift_10_), .A1(n3299), .B0(n3322), .Y(n3231) );
  AO22X1 U2384 ( .A0(CMDShift_11_), .A1(n3301), .B0(SDICmdArg[11]), .B1(n3302), 
        .Y(n3322) );
  AO21X1 U2385 ( .A0(CMDShift_9_), .A1(n3299), .B0(n3321), .Y(n3232) );
  AO22X1 U2386 ( .A0(CMDShift_10_), .A1(n3301), .B0(SDICmdArg[10]), .B1(n3302), 
        .Y(n3321) );
  AO21X1 U2387 ( .A0(CMDShift_8_), .A1(n3299), .B0(n3320), .Y(n3233) );
  AO22X1 U2388 ( .A0(CMDShift_9_), .A1(n3301), .B0(SDICmdArg[9]), .B1(n3302), 
        .Y(n3320) );
  AO21X1 U2389 ( .A0(Response3[0]), .A1(n3411), .B0(n3412), .Y(n3194) );
  OAI31X1 U2390 ( .A0(n3257), .A1(n3258), .A2(n3059), .B0(n3259), .Y(n3253) );
  INVX1 U2391 ( .A(n3260), .Y(n3258) );
  NAND3BX1 U2392 ( .AN(RspFinSet), .B(n3261), .C(n3262), .Y(n3257) );
  OAI31X1 U2393 ( .A0(n3266), .A1(SDreset), .A2(n3541), .B0(n3259), .Y(n3249)
         );
  NOR3BX1 U2394 ( .AN(CMDState_1_), .B(n3268), .C(n3269), .Y(n3266) );
  INVX1 U2395 ( .A(CMDIN), .Y(n3286) );
  INVX1 U2396 ( .A(n2), .Y(carry_6_) );
  INVX1 U2397 ( .A(n6), .Y(carry_2_) );
  INVX1 U2398 ( .A(n4), .Y(carry_4_) );
  INVX1 U2399 ( .A(n5), .Y(carry_3_) );
  OAI32X1 U2400 ( .A0(n3373), .A1(n3363), .A2(n3374), .B0(CMDTxMode), .B1(
        n3539), .Y(n3342) );
  INVX1 U2401 ( .A(n3361), .Y(n3374) );
  NAND2BX1 U2402 ( .AN(n3540), .B(n3380), .Y(n3373) );
  INVX1 U2403 ( .A(n3511), .Y(n3281) );
  NAND3BX1 U2404 ( .AN(n3512), .B(n3513), .C(CMDCnt[6]), .Y(n3511) );
  INVX1 U2405 ( .A(n3458), .Y(n3513) );
  NAND3BX1 U2406 ( .AN(n3533), .B(CMDCnt[0]), .C(n3550), .Y(n3512) );
  AOI32X1 U2407 ( .A0(CMDTxMode), .A1(n3261), .A2(n3369), .B0(CmdIndex[6]), 
        .B1(n3349), .Y(n3368) );
  INVX1 U2408 ( .A(n3), .Y(carry_5_) );
  INVX1 U2409 ( .A(n3370), .Y(n3349) );
  NAND3BX1 U2410 ( .AN(n3361), .B(n3261), .C(CMDTxMode), .Y(n3370) );
  NAND3BX1 U2411 ( .AN(SDreset), .B(CMDTxMode), .C(n3371), .Y(n3337) );
  NAND2BX1 U2412 ( .AN(CMDState_1_), .B(n3538), .Y(n3280) );
  AO22X1 U2413 ( .A0(neg_CKPulse), .A1(nCMDEN), .B0(Inv_nCMDEN), .B1(n3263), 
        .Y(n3252) );
  AO22X1 U2414 ( .A0(Inv_CMDOUT), .A1(n3263), .B0(CMDOUT), .B1(neg_CKPulse), 
        .Y(n3251) );
  NOR2X1 U2415 ( .A(SDreset), .B(n3553), .Y(n3552) );
  NOR2X1 U2416 ( .A(SDreset), .B(n3555), .Y(n3554) );
  NOR2X1 U2417 ( .A(SDreset), .B(n3557), .Y(n3556) );
  NOR2X1 U2418 ( .A(SDreset), .B(n3559), .Y(n3558) );
  NOR2X1 U2419 ( .A(SDreset), .B(n3561), .Y(n3560) );
  NOR2X1 U2420 ( .A(SDreset), .B(n3563), .Y(n3562) );
  NOR2X1 U2421 ( .A(SDreset), .B(n3565), .Y(n3564) );
  NOR2X1 U2422 ( .A(SDreset), .B(n3567), .Y(n3566) );
  AOI21X1 U2423 ( .A0(CMDState_1_), .A1(CMDState_2_), .B0(SDreset), .Y(n3568)
         );
  DFFSX1 CMDCnt_reg_1_ ( .D(n3209), .CK(PCLK), .SN(nRst), .Q(CMDCnt[1]), .QN(
        n3532) );
  DFFSX1 CMDCnt_reg_6_ ( .D(n3204), .CK(PCLK), .SN(nRst), .Q(CMDCnt[6]), .QN(
        n3516) );
  DFFSX1 CMDCnt_reg_2_ ( .D(n3208), .CK(PCLK), .SN(nRst), .Q(CMDCnt[2]), .QN(
        n3518) );
  DFFSX1 CMDCnt_reg_4_ ( .D(n3206), .CK(PCLK), .SN(nRst), .Q(CMDCnt[4]), .QN(
        n3533) );
  DFFSX1 CMDCnt_reg_5_ ( .D(n3205), .CK(PCLK), .SN(nRst), .Q(CMDCnt[5]), .QN(
        n3551) );
  DFFRX1 CMDState_reg_2_ ( .D(n3246), .CK(PCLK), .RN(nRst), .Q(CMDState_2_), 
        .QN(n3538) );
  DFFSX1 CMDCnt_reg_7_ ( .D(n3203), .CK(PCLK), .SN(nRst), .Q(CMDCnt[7]), .QN(
        n3515) );
  DFFRX1 CMDCnt_reg_3_ ( .D(n3207), .CK(PCLK), .RN(nRst), .Q(CMDCnt[3]), .QN(
        n3531) );
  DFFRX1 CMDState_reg_3_ ( .D(n3245), .CK(PCLK), .RN(nRst), .Q(CCMDState3), 
        .QN(n3520) );
  DFFRX1 CMDShift_reg_31_ ( .D(n3211), .CK(PCLK), .RN(nRst), .Q(CMDOUT), .QN(
        n3534) );
  DFFRX1 CRCTxMode_reg ( .D(n3249), .CK(PCLK), .RN(nRst), .Q(CRCTxMode), .QN(
        n3541) );
  DFFRX1 CRCShift_reg_6_ ( .D(CRCShift1652_6_), .CK(PCLK), .RN(nRst), .Q(
        CRCShift[6]), .QN(n3519) );
  DFFRX1 CRCShift_reg_2_ ( .D(CRCShift1652_2_), .CK(PCLK), .RN(nRst), .Q(
        CRCShift[2]), .QN(n3536) );
  DFFRX1 CRCRxMode_reg ( .D(CRCRxMode1784), .CK(PCLK), .RN(nRst), .Q(CRCRxMode), .QN(n3535) );
  DFFSX1 CMDState_reg_0_ ( .D(n3248), .CK(PCLK), .SN(nRst), .Q(CmdCtrlIdle), 
        .QN(n3537) );
  DFFRX1 CMDState_reg_1_ ( .D(n3247), .CK(PCLK), .RN(nRst), .Q(CMDState_1_), 
        .QN(n3521) );
  DFFRX1 CRCShift_reg_0_ ( .D(CRCShift1652_0_), .CK(PCLK), .RN(nRst), .Q(
        CRCShift[0]) );
  DFFRX1 CRCShift_reg_1_ ( .D(CRCShift1652_1_), .CK(PCLK), .RN(nRst), .Q(
        CRCShift[1]) );
  DFFRX1 CRCShift_reg_4_ ( .D(CRCShift1652_4_), .CK(PCLK), .RN(nRst), .Q(
        CRCShift[4]) );
  DFFRX1 CRCShift_reg_5_ ( .D(CRCShift1652_5_), .CK(PCLK), .RN(nRst), .Q(
        CRCShift[5]) );
  DFFRX1 CRCShift_reg_3_ ( .D(CRCShift1652_3_), .CK(PCLK), .RN(nRst), .Q(
        CRCShift[3]) );
  DFFRX1 CMDTxMode_reg ( .D(n3243), .CK(PCLK), .RN(nRst), .Q(CMDTxMode), .QN(
        n3540) );
  DFFRX1 CMDShift_reg_24_ ( .D(n3218), .CK(PCLK), .RN(nRst), .Q(CMDShift_24_), 
        .QN(n3522) );
  DFFRX1 CMDShift_reg_29_ ( .D(n3213), .CK(PCLK), .RN(nRst), .Q(CMDShift_29_), 
        .QN(n3524) );
  DFFRX1 CMDShift_reg_28_ ( .D(n3214), .CK(PCLK), .RN(nRst), .Q(CMDShift_28_), 
        .QN(n3525) );
  DFFRX1 CMDShift_reg_27_ ( .D(n3215), .CK(PCLK), .RN(nRst), .Q(CMDShift_27_), 
        .QN(n3526) );
  DFFRX1 CMDShift_reg_26_ ( .D(n3216), .CK(PCLK), .RN(nRst), .Q(CMDShift_26_), 
        .QN(n3527) );
  DFFRX1 CMDShift_reg_25_ ( .D(n3217), .CK(PCLK), .RN(nRst), .Q(CMDShift_25_), 
        .QN(n3528) );
  DFFRX1 CMDShift_reg_30_ ( .D(n3212), .CK(PCLK), .RN(nRst), .Q(CMDShift_30_), 
        .QN(n3523) );
  DFFRX1 CMDRxMode_reg ( .D(n3244), .CK(PCLK), .RN(nRst), .QN(n3539) );
  DFFRX1 Response0_reg_31_ ( .D(n3067), .CK(PCLK), .RN(nRst), .Q(Response0[31]) );
  DFFRX1 Response0_reg_30_ ( .D(n3068), .CK(PCLK), .RN(nRst), .Q(Response0[30]) );
  DFFRX1 Response0_reg_29_ ( .D(n3069), .CK(PCLK), .RN(nRst), .Q(Response0[29]) );
  DFFRX1 Response0_reg_28_ ( .D(n3070), .CK(PCLK), .RN(nRst), .Q(Response0[28]) );
  DFFRX1 Response0_reg_27_ ( .D(n3071), .CK(PCLK), .RN(nRst), .Q(Response0[27]) );
  DFFRX1 Response0_reg_26_ ( .D(n3072), .CK(PCLK), .RN(nRst), .Q(Response0[26]) );
  DFFRX1 Response0_reg_25_ ( .D(n3073), .CK(PCLK), .RN(nRst), .Q(Response0[25]) );
  DFFRX1 Response0_reg_24_ ( .D(n3074), .CK(PCLK), .RN(nRst), .Q(Response0[24]) );
  DFFRX1 Response0_reg_23_ ( .D(n3075), .CK(PCLK), .RN(nRst), .Q(Response0[23]) );
  DFFRX1 Response0_reg_22_ ( .D(n3076), .CK(PCLK), .RN(nRst), .Q(Response0[22]) );
  DFFRX1 Response0_reg_21_ ( .D(n3077), .CK(PCLK), .RN(nRst), .Q(Response0[21]) );
  DFFRX1 Response0_reg_20_ ( .D(n3078), .CK(PCLK), .RN(nRst), .Q(Response0[20]) );
  DFFRX1 Response0_reg_19_ ( .D(n3079), .CK(PCLK), .RN(nRst), .Q(Response0[19]) );
  DFFRX1 Response0_reg_3_ ( .D(n3095), .CK(PCLK), .RN(nRst), .Q(Response0[3])
         );
  DFFRX1 Response0_reg_2_ ( .D(n3096), .CK(PCLK), .RN(nRst), .Q(Response0[2])
         );
  DFFRX1 Response0_reg_15_ ( .D(n3083), .CK(PCLK), .RN(nRst), .Q(Response0[15]) );
  DFFRX1 Response0_reg_18_ ( .D(n3080), .CK(PCLK), .RN(nRst), .Q(Response0[18]) );
  DFFRX1 Response0_reg_17_ ( .D(n3081), .CK(PCLK), .RN(nRst), .Q(Response0[17]) );
  DFFRX1 Response0_reg_16_ ( .D(n3082), .CK(PCLK), .RN(nRst), .Q(Response0[16]) );
  DFFRX1 Response0_reg_1_ ( .D(n3097), .CK(PCLK), .RN(nRst), .Q(Response0[1])
         );
  DFFRX1 Response0_reg_0_ ( .D(n3098), .CK(PCLK), .RN(nRst), .Q(Response0[0])
         );
  DFFRX1 Response1_reg_2_ ( .D(n3128), .CK(PCLK), .RN(nRst), .Q(Response1[2])
         );
  DFFRX1 Response2_reg_15_ ( .D(n3147), .CK(PCLK), .RN(nRst), .Q(Response2[15]) );
  DFFRX1 Response2_reg_14_ ( .D(n3148), .CK(PCLK), .RN(nRst), .Q(Response2[14]) );
  DFFRX1 Response2_reg_13_ ( .D(n3149), .CK(PCLK), .RN(nRst), .Q(Response2[13]) );
  DFFRX1 Response2_reg_9_ ( .D(n3153), .CK(PCLK), .RN(nRst), .Q(Response2[9])
         );
  DFFRX1 Response2_reg_8_ ( .D(n3154), .CK(PCLK), .RN(nRst), .Q(Response2[8])
         );
  DFFRX1 Response1_reg_22_ ( .D(n3108), .CK(PCLK), .RN(nRst), .Q(Response1[22]) );
  DFFRX1 Response1_reg_21_ ( .D(n3109), .CK(PCLK), .RN(nRst), .Q(Response1[21]) );
  DFFRX1 Response1_reg_20_ ( .D(n3110), .CK(PCLK), .RN(nRst), .Q(Response1[20]) );
  DFFRX1 Response1_reg_19_ ( .D(n3111), .CK(PCLK), .RN(nRst), .Q(Response1[19]) );
  DFFRX1 Response1_reg_15_ ( .D(n3115), .CK(PCLK), .RN(nRst), .Q(Response1[15]) );
  DFFRX1 Response1_reg_14_ ( .D(n3116), .CK(PCLK), .RN(nRst), .Q(Response1[14]) );
  DFFRX1 Response1_reg_13_ ( .D(n3117), .CK(PCLK), .RN(nRst), .Q(Response1[13]) );
  DFFRX1 Response1_reg_9_ ( .D(n3121), .CK(PCLK), .RN(nRst), .Q(Response1[9])
         );
  DFFRX1 Response1_reg_8_ ( .D(n3122), .CK(PCLK), .RN(nRst), .Q(Response1[8])
         );
  DFFRX1 Response1_reg_4_ ( .D(n3126), .CK(PCLK), .RN(nRst), .Q(Response1[4])
         );
  DFFRX1 Response2_reg_31_ ( .D(n3131), .CK(PCLK), .RN(nRst), .Q(Response2[31]) );
  DFFRX1 Response2_reg_30_ ( .D(n3132), .CK(PCLK), .RN(nRst), .Q(Response2[30]) );
  DFFRX1 Response2_reg_29_ ( .D(n3133), .CK(PCLK), .RN(nRst), .Q(Response2[29]) );
  DFFRX1 Response2_reg_28_ ( .D(n3134), .CK(PCLK), .RN(nRst), .Q(Response2[28]) );
  DFFRX1 Response2_reg_27_ ( .D(n3135), .CK(PCLK), .RN(nRst), .Q(Response2[27]) );
  DFFRX1 Response2_reg_26_ ( .D(n3136), .CK(PCLK), .RN(nRst), .Q(Response2[26]) );
  DFFRX1 Response2_reg_25_ ( .D(n3137), .CK(PCLK), .RN(nRst), .Q(Response2[25]) );
  DFFRX1 Response2_reg_24_ ( .D(n3138), .CK(PCLK), .RN(nRst), .Q(Response2[24]) );
  DFFRX1 Response2_reg_23_ ( .D(n3139), .CK(PCLK), .RN(nRst), .Q(Response2[23]) );
  DFFRX1 Response2_reg_22_ ( .D(n3140), .CK(PCLK), .RN(nRst), .Q(Response2[22]) );
  DFFRX1 Response2_reg_21_ ( .D(n3141), .CK(PCLK), .RN(nRst), .Q(Response2[21]) );
  DFFRX1 Response2_reg_20_ ( .D(n3142), .CK(PCLK), .RN(nRst), .Q(Response2[20]) );
  DFFRX1 Response2_reg_19_ ( .D(n3143), .CK(PCLK), .RN(nRst), .Q(Response2[19]) );
  DFFRX1 Response2_reg_4_ ( .D(n3158), .CK(PCLK), .RN(nRst), .Q(Response2[4])
         );
  DFFRX1 Response3_reg_18_ ( .D(n3176), .CK(PCLK), .RN(nRst), .Q(Response3[18]) );
  DFFRX1 Response3_reg_17_ ( .D(n3177), .CK(PCLK), .RN(nRst), .Q(Response3[17]) );
  DFFRX1 Response3_reg_16_ ( .D(n3178), .CK(PCLK), .RN(nRst), .Q(Response3[16]) );
  DFFRX1 Response3_reg_1_ ( .D(n3193), .CK(PCLK), .RN(nRst), .Q(Response3[1])
         );
  DFFRX1 RspIndex_reg_4_ ( .D(n3198), .CK(PCLK), .RN(nRst), .Q(RspIndex[4]) );
  DFFRX1 RspIndex_reg_3_ ( .D(n3199), .CK(PCLK), .RN(nRst), .Q(RspIndex[3]) );
  DFFRX1 Response3_reg_0_ ( .D(n3194), .CK(PCLK), .RN(nRst), .Q(Response3[0])
         );
  DFFRX1 Response2_reg_3_ ( .D(n3159), .CK(PCLK), .RN(nRst), .Q(Response2[3])
         );
  DFFRX1 Response3_reg_2_ ( .D(n3192), .CK(PCLK), .RN(nRst), .Q(Response3[2])
         );
  DFFRX1 RspIndex_reg_2_ ( .D(n3200), .CK(PCLK), .RN(nRst), .Q(RspIndex[2]) );
  DFFRX1 RspIndex_reg_7_ ( .D(n3195), .CK(PCLK), .RN(nRst), .Q(RspIndex[7]) );
  DFFRX1 RspIndex_reg_6_ ( .D(n3196), .CK(PCLK), .RN(nRst), .Q(RspIndex[6]) );
  DFFRX1 RspIndex_reg_5_ ( .D(n3197), .CK(PCLK), .RN(nRst), .Q(RspIndex[5]) );
  DFFRX1 RspIndex_reg_1_ ( .D(n3201), .CK(PCLK), .RN(nRst), .Q(RspIndex[1]) );
  DFFRX1 RspIndex_reg_0_ ( .D(n3202), .CK(PCLK), .RN(nRst), .Q(RspIndex[0]) );
  DFFRX1 CmdOn_reg ( .D(n3253), .CK(PCLK), .RN(nRst), .Q(CmdOn), .QN(n3059) );
  DFFRX1 CMDShift_reg_0_ ( .D(n3242), .CK(PCLK), .RN(nRst), .Q(CMDShift_0_), 
        .QN(n3553) );
  DFFRX1 CMDShift_reg_6_ ( .D(n3236), .CK(PCLK), .RN(nRst), .Q(CMDShift_6_), 
        .QN(n3555) );
  DFFRX1 CMDShift_reg_5_ ( .D(n3237), .CK(PCLK), .RN(nRst), .Q(CMDShift_5_), 
        .QN(n3557) );
  DFFRX1 CMDShift_reg_4_ ( .D(n3238), .CK(PCLK), .RN(nRst), .Q(CMDShift_4_), 
        .QN(n3559) );
  DFFRX1 CMDShift_reg_3_ ( .D(n3239), .CK(PCLK), .RN(nRst), .Q(CMDShift_3_), 
        .QN(n3561) );
  DFFRX1 CMDShift_reg_2_ ( .D(n3240), .CK(PCLK), .RN(nRst), .Q(CMDShift_2_), 
        .QN(n3563) );
  DFFRX1 CMDShift_reg_1_ ( .D(n3241), .CK(PCLK), .RN(nRst), .Q(CMDShift_1_), 
        .QN(n3565) );
  DFFRX1 CMDShift_reg_23_ ( .D(n3219), .CK(PCLK), .RN(nRst), .Q(CMDShift_23_)
         );
  DFFRX1 CMDShift_reg_22_ ( .D(n3220), .CK(PCLK), .RN(nRst), .Q(CMDShift_22_)
         );
  DFFRX1 CMDShift_reg_21_ ( .D(n3221), .CK(PCLK), .RN(nRst), .Q(CMDShift_21_)
         );
  DFFRX1 CMDShift_reg_20_ ( .D(n3222), .CK(PCLK), .RN(nRst), .Q(CMDShift_20_)
         );
  DFFRX1 CMDShift_reg_19_ ( .D(n3223), .CK(PCLK), .RN(nRst), .Q(CMDShift_19_)
         );
  DFFRX1 CMDShift_reg_18_ ( .D(n3224), .CK(PCLK), .RN(nRst), .Q(CMDShift_18_)
         );
  DFFRX1 CMDShift_reg_17_ ( .D(n3225), .CK(PCLK), .RN(nRst), .Q(CMDShift_17_)
         );
  DFFRX1 CMDShift_reg_16_ ( .D(n3226), .CK(PCLK), .RN(nRst), .Q(CMDShift_16_)
         );
  DFFRX1 CMDShift_reg_15_ ( .D(n3227), .CK(PCLK), .RN(nRst), .Q(CMDShift_15_)
         );
  DFFRX1 CMDShift_reg_14_ ( .D(n3228), .CK(PCLK), .RN(nRst), .Q(CMDShift_14_)
         );
  DFFRX1 CMDShift_reg_13_ ( .D(n3229), .CK(PCLK), .RN(nRst), .Q(CMDShift_13_)
         );
  DFFRX1 CMDShift_reg_12_ ( .D(n3230), .CK(PCLK), .RN(nRst), .Q(CMDShift_12_)
         );
  DFFRX1 CMDShift_reg_11_ ( .D(n3231), .CK(PCLK), .RN(nRst), .Q(CMDShift_11_)
         );
  DFFRX1 CMDShift_reg_10_ ( .D(n3232), .CK(PCLK), .RN(nRst), .Q(CMDShift_10_)
         );
  DFFRX1 CMDShift_reg_9_ ( .D(n3233), .CK(PCLK), .RN(nRst), .Q(CMDShift_9_) );
  DFFRX1 CMDShift_reg_8_ ( .D(n3234), .CK(PCLK), .RN(nRst), .Q(CMDShift_8_) );
  DFFSX1 Inv_CMDOUT_reg ( .D(n3251), .CK(PCLK), .SN(nRst), .Q(Inv_CMDOUT) );
  DFFSX1 Inv_nCMDEN_reg ( .D(n3252), .CK(PCLK), .SN(nRst), .Q(Inv_nCMDEN) );
  DFFRX1 CMDShift_reg_7_ ( .D(n3235), .CK(PCLK), .RN(nRst), .Q(CMDShift_7_), 
        .QN(n3567) );
  DFFRX1 Response0_reg_14_ ( .D(n3084), .CK(PCLK), .RN(nRst), .Q(Response0[14]) );
  DFFRX1 Response0_reg_13_ ( .D(n3085), .CK(PCLK), .RN(nRst), .Q(Response0[13]) );
  DFFRX1 Response0_reg_9_ ( .D(n3089), .CK(PCLK), .RN(nRst), .Q(Response0[9])
         );
  DFFRX1 Response0_reg_8_ ( .D(n3090), .CK(PCLK), .RN(nRst), .Q(Response0[8])
         );
  DFFRX1 Response0_reg_4_ ( .D(n3094), .CK(PCLK), .RN(nRst), .Q(Response0[4])
         );
  DFFRX1 Response0_reg_12_ ( .D(n3086), .CK(PCLK), .RN(nRst), .Q(Response0[12]) );
  DFFRX1 Response0_reg_11_ ( .D(n3087), .CK(PCLK), .RN(nRst), .Q(Response0[11]) );
  DFFRX1 Response0_reg_10_ ( .D(n3088), .CK(PCLK), .RN(nRst), .Q(Response0[10]) );
  DFFRX1 Response0_reg_7_ ( .D(n3091), .CK(PCLK), .RN(nRst), .Q(Response0[7])
         );
  DFFRX1 Response0_reg_6_ ( .D(n3092), .CK(PCLK), .RN(nRst), .Q(Response0[6])
         );
  DFFRX1 Response0_reg_5_ ( .D(n3093), .CK(PCLK), .RN(nRst), .Q(Response0[5])
         );
  DFFRX1 Response1_reg_18_ ( .D(n3112), .CK(PCLK), .RN(nRst), .Q(Response1[18]) );
  DFFRX1 Response1_reg_17_ ( .D(n3113), .CK(PCLK), .RN(nRst), .Q(Response1[17]) );
  DFFRX1 Response1_reg_16_ ( .D(n3114), .CK(PCLK), .RN(nRst), .Q(Response1[16]) );
  DFFRX1 Response3_reg_22_ ( .D(n3172), .CK(PCLK), .RN(nRst), .Q(Response3[22]) );
  DFFRX1 Response3_reg_21_ ( .D(n3173), .CK(PCLK), .RN(nRst), .Q(Response3[21]) );
  DFFRX1 Response3_reg_20_ ( .D(n3174), .CK(PCLK), .RN(nRst), .Q(Response3[20]) );
  DFFRX1 Response3_reg_19_ ( .D(n3175), .CK(PCLK), .RN(nRst), .Q(Response3[19]) );
  DFFRX1 Response3_reg_14_ ( .D(n3180), .CK(PCLK), .RN(nRst), .Q(Response3[14]) );
  DFFRX1 Response3_reg_13_ ( .D(n3181), .CK(PCLK), .RN(nRst), .Q(Response3[13]) );
  DFFRX1 Response3_reg_9_ ( .D(n3185), .CK(PCLK), .RN(nRst), .Q(Response3[9])
         );
  DFFSX1 nCMDEN_reg ( .D(n3250), .CK(PCLK), .SN(nRst), .Q(nCMDEN) );
  DFFRX1 Response2_reg_18_ ( .D(n3144), .CK(PCLK), .RN(nRst), .Q(Response2[18]) );
  DFFRX1 Response2_reg_17_ ( .D(n3145), .CK(PCLK), .RN(nRst), .Q(Response2[17]) );
  DFFRX1 Response2_reg_16_ ( .D(n3146), .CK(PCLK), .RN(nRst), .Q(Response2[16]) );
  DFFRX1 Response1_reg_31_ ( .D(n3099), .CK(PCLK), .RN(nRst), .Q(Response1[31]) );
  DFFRX1 Response1_reg_23_ ( .D(n3107), .CK(PCLK), .RN(nRst), .Q(Response1[23]) );
  DFFRX1 Response2_reg_12_ ( .D(n3150), .CK(PCLK), .RN(nRst), .Q(Response2[12]) );
  DFFRX1 Response2_reg_11_ ( .D(n3151), .CK(PCLK), .RN(nRst), .Q(Response2[11]) );
  DFFRX1 Response2_reg_10_ ( .D(n3152), .CK(PCLK), .RN(nRst), .Q(Response2[10]) );
  DFFRX1 Response3_reg_12_ ( .D(n3182), .CK(PCLK), .RN(nRst), .Q(Response3[12]) );
  DFFRX1 Response3_reg_11_ ( .D(n3183), .CK(PCLK), .RN(nRst), .Q(Response3[11]) );
  DFFRX1 Response3_reg_10_ ( .D(n3184), .CK(PCLK), .RN(nRst), .Q(Response3[10]) );
  DFFRX1 Response1_reg_12_ ( .D(n3118), .CK(PCLK), .RN(nRst), .Q(Response1[12]) );
  DFFRX1 Response1_reg_11_ ( .D(n3119), .CK(PCLK), .RN(nRst), .Q(Response1[11]) );
  DFFRX1 Response1_reg_10_ ( .D(n3120), .CK(PCLK), .RN(nRst), .Q(Response1[10]) );
  DFFRX1 Response1_reg_7_ ( .D(n3123), .CK(PCLK), .RN(nRst), .Q(Response1[7])
         );
  DFFRX1 Response1_reg_6_ ( .D(n3124), .CK(PCLK), .RN(nRst), .Q(Response1[6])
         );
  DFFRX1 Response1_reg_5_ ( .D(n3125), .CK(PCLK), .RN(nRst), .Q(Response1[5])
         );
  DFFRX1 Response1_reg_3_ ( .D(n3127), .CK(PCLK), .RN(nRst), .Q(Response1[3])
         );
  DFFRX1 Response3_reg_31_ ( .D(n3163), .CK(PCLK), .RN(nRst), .Q(Response3[31]) );
  DFFRX1 Response3_reg_30_ ( .D(n3164), .CK(PCLK), .RN(nRst), .Q(Response3[30]) );
  DFFRX1 Response3_reg_29_ ( .D(n3165), .CK(PCLK), .RN(nRst), .Q(Response3[29]) );
  DFFRX1 Response3_reg_28_ ( .D(n3166), .CK(PCLK), .RN(nRst), .Q(Response3[28]) );
  DFFRX1 Response3_reg_27_ ( .D(n3167), .CK(PCLK), .RN(nRst), .Q(Response3[27]) );
  DFFRX1 Response3_reg_26_ ( .D(n3168), .CK(PCLK), .RN(nRst), .Q(Response3[26]) );
  DFFRX1 Response3_reg_25_ ( .D(n3169), .CK(PCLK), .RN(nRst), .Q(Response3[25]) );
  DFFRX1 Response3_reg_24_ ( .D(n3170), .CK(PCLK), .RN(nRst), .Q(Response3[24]) );
  DFFRX1 Response3_reg_23_ ( .D(n3171), .CK(PCLK), .RN(nRst), .Q(Response3[23]) );
  DFFRX1 Response1_reg_1_ ( .D(n3129), .CK(PCLK), .RN(nRst), .Q(Response1[1])
         );
  DFFRX1 Response1_reg_0_ ( .D(n3130), .CK(PCLK), .RN(nRst), .Q(Response1[0])
         );
  DFFRX1 Response3_reg_15_ ( .D(n3179), .CK(PCLK), .RN(nRst), .Q(Response3[15]) );
  DFFRX1 Response2_reg_1_ ( .D(n3161), .CK(PCLK), .RN(nRst), .Q(Response2[1])
         );
  DFFRX1 Response2_reg_0_ ( .D(n3162), .CK(PCLK), .RN(nRst), .Q(Response2[0])
         );
  DFFRX1 Response2_reg_7_ ( .D(n3155), .CK(PCLK), .RN(nRst), .Q(Response2[7])
         );
  DFFRX1 Response2_reg_6_ ( .D(n3156), .CK(PCLK), .RN(nRst), .Q(Response2[6])
         );
  DFFRX1 Response2_reg_5_ ( .D(n3157), .CK(PCLK), .RN(nRst), .Q(Response2[5])
         );
  DFFRX1 Response3_reg_7_ ( .D(n3187), .CK(PCLK), .RN(nRst), .Q(Response3[7])
         );
  DFFRX1 Response3_reg_6_ ( .D(n3188), .CK(PCLK), .RN(nRst), .Q(Response3[6])
         );
  DFFRX1 Response3_reg_5_ ( .D(n3189), .CK(PCLK), .RN(nRst), .Q(Response3[5])
         );
  DFFRX1 Response3_reg_4_ ( .D(n3190), .CK(PCLK), .RN(nRst), .Q(Response3[4])
         );
  DFFRX1 Response3_reg_3_ ( .D(n3191), .CK(PCLK), .RN(nRst), .Q(Response3[3])
         );
  DFFRX1 Response3_reg_8_ ( .D(n3186), .CK(PCLK), .RN(nRst), .Q(Response3[8])
         );
  DFFRX1 Response2_reg_2_ ( .D(n3160), .CK(PCLK), .RN(nRst), .Q(Response2[2])
         );
  DFFRX1 Response1_reg_30_ ( .D(n3100), .CK(PCLK), .RN(nRst), .Q(Response1[30]), .QN(n3066) );
  DFFRX1 Response1_reg_29_ ( .D(n3101), .CK(PCLK), .RN(nRst), .Q(Response1[29]), .QN(n3065) );
  DFFRX1 Response1_reg_28_ ( .D(n3102), .CK(PCLK), .RN(nRst), .Q(Response1[28]), .QN(n3064) );
  DFFRX1 Response1_reg_27_ ( .D(n3103), .CK(PCLK), .RN(nRst), .Q(Response1[27]), .QN(n3063) );
  DFFRX1 Response1_reg_26_ ( .D(n3104), .CK(PCLK), .RN(nRst), .Q(Response1[26]), .QN(n3062) );
  DFFRX1 Response1_reg_25_ ( .D(n3105), .CK(PCLK), .RN(nRst), .Q(Response1[25]), .QN(n3061) );
  DFFRX1 Response1_reg_24_ ( .D(n3106), .CK(PCLK), .RN(nRst), .Q(Response1[24]), .QN(n3060) );
endmodule


module AUTORead ( nRst, SDreset, PCLK, AutoReadEn, RCmdStart, RCmdStartClr, 
        SingleMultiRead, Response0, NoBusySet, BusyFinSet, RspCrcSet, 
        RspFinSet, CmdToutSet, DatCrcSet, DatFinSet, CmdArg, CmdIndex, CMST, 
        CMSTClr, NoCRCRsp, LongRsp, WaitRsp, BusyRsp, AbortCmd, CmdStartMuxO, 
        CmdArgMuxO, CmdIndexMuxO, NoCRCRspMuxO, LongRspMuxO, WaitRspMuxO, 
        BusyRspMuxO, AbortCmdMuxO, ResponseCMD18, AutoReadComplete, ErrorState
 );
  input [31:0] Response0;
  input [31:0] CmdArg;
  input [6:0] CmdIndex;
  output [31:0] CmdArgMuxO;
  output [6:0] CmdIndexMuxO;
  output [31:0] ResponseCMD18;
  output [1:0] ErrorState;
  input nRst, SDreset, PCLK, AutoReadEn, RCmdStart, SingleMultiRead, NoBusySet,
         BusyFinSet, RspCrcSet, RspFinSet, CmdToutSet, DatCrcSet, DatFinSet,
         CMST, CMSTClr, NoCRCRsp, LongRsp, WaitRsp, BusyRsp, AbortCmd;
  output RCmdStartClr, CmdStartMuxO, NoCRCRspMuxO, LongRspMuxO, WaitRspMuxO,
         BusyRspMuxO, AbortCmdMuxO, AutoReadComplete;
  wire   Cnt_1_, Cnt_0_, CmdStart, ACmdArg_31_, ACmdArg_30_, ACmdArg_29_,
         ACmdArg_28_, ACmdArg_27_, ACmdArg_26_, ACmdArg_25_, ACmdArg_24_,
         ACmdArg_23_, ACmdArg_22_, ACmdArg_21_, ACmdArg_20_, ACmdArg_19_,
         ACmdArg_18_, ACmdArg_17_, ACmdArg_16_, ACmdArg_15_, ACmdArg_14_,
         ACmdArg_13_, ACmdArg_12_, ACmdArg_11_, ACmdArg_10_, ACmdArg_9_,
         ACmdArg_8_, ACmdArg_7_, ACmdArg_6_, ACmdArg_5_, ACmdArg_4_,
         ACmdArg_3_, ACmdArg_2_, ACmdArg_1_, ACmdArg_0_, ACmdIndex_6_,
         ACmdIndex_5_, ACmdIndex_4_, ACmdIndex_3_, ACmdIndex_2_, ACmdIndex_1_,
         ACmdIndex_0_, ANoCRCRsp, ALongRsp, AWaitRsp, ABusyRsp, AAbortCmd,
         n1312, n1313, n1314, n1315, n1316, n1317, n1318, n1319, n1320, n1321,
         n1322, n1323, n1324, n1325, n1326, n1327, n1328, n1329, n1330, n1331,
         n1332, n1333, n1334, n1335, n1336, n1337, n1338, n1339, n1340, n1341,
         n1342, n1343, n1344, n1345, n1346, n1347, n1348, n1349, n1350, n1351,
         n1352, n1353, n1354, n1355, n1356, n1357, n1358, n1359, n1360, n1361,
         n1362, n1363, n1364, n1365, n1366, n1367, n1368, n1369, n1370, n1371,
         n1372, n1373, n1374, n1375, n1376, n1377, n1378, n1379, n1380, n1381,
         n1382, n1383, n1384, n1385, n1386, n1387, n1388, n1389, n1390, n1391,
         n1392, n1393, n1398, n1399, n1400, n1401, n1402, n1404, n1405, n1410,
         n1411, n1412, n1413, n1414, n1415, n1416, n1417, n1418, n1420, n1421,
         n1422, n1423, n1424, n1425, n1426, n1427, n1428, n1429, n1430, n1431,
         n1432, n1433, n1434, n1435, n1436, n1437, n1438, n1439, n1440, n1442,
         n1444, n1445, n1447, n1448, n1449, n1450, n1451, n1453, n1454, n1455;
  wire   [2:0] C_AR_State;

  INVX1 U822 ( .A(n1429), .Y(n1426) );
  INVX1 U823 ( .A(n1444), .Y(n1442) );
  NAND2BX1 U824 ( .AN(CmdToutSet), .B(n1445), .Y(n1444) );
  INVX1 U825 ( .A(n1415), .Y(n1413) );
  NAND3BX1 U826 ( .AN(n1398), .B(DatFinSet), .C(RCmdStartClr), .Y(n1435) );
  AO21X1 U827 ( .A0(n1430), .A1(RCmdStartClr), .B0(SDreset), .Y(n1429) );
  NOR2BX1 U828 ( .AN(RspFinSet), .B(n1398), .Y(n1430) );
  INVX1 U829 ( .A(n1428), .Y(n1427) );
  NAND2BX1 U830 ( .AN(SDreset), .B(n1429), .Y(n1428) );
  INVX1 U831 ( .A(SDreset), .Y(n1438) );
  NAND2BX1 U832 ( .AN(DatCrcSet), .B(n1442), .Y(n1415) );
  NAND2BX1 U833 ( .AN(n1421), .B(n1415), .Y(n1425) );
  NAND3BX1 U834 ( .AN(SDreset), .B(n1454), .C(n1412), .Y(n1416) );
  OAI32X1 U835 ( .A0(n1416), .A1(n1447), .A2(n1415), .B0(n1450), .B1(n1412), 
        .Y(n1385) );
  INVX1 U836 ( .A(RspCrcSet), .Y(n1445) );
  NOR2X1 U837 ( .A(n1442), .B(n1420), .Y(ErrorState[1]) );
  INVX1 U838 ( .A(n1454), .Y(n1398) );
  INVX1 U839 ( .A(n1421), .Y(RCmdStartClr) );
  INVX1 U840 ( .A(n1440), .Y(n1423) );
  NAND2BX1 U841 ( .AN(RCmdStartClr), .B(n1420), .Y(n1440) );
  INVX1 U842 ( .A(n1439), .Y(n1436) );
  NAND3BX1 U843 ( .AN(SDreset), .B(n1450), .C(n1455), .Y(n1439) );
  INVX1 U844 ( .A(n1455), .Y(n1399) );
  INVX1 U845 ( .A(n1425), .Y(ErrorState[0]) );
  NOR3BX1 U846 ( .AN(n1445), .B(n1420), .C(n1453), .Y(AutoReadComplete) );
  AO22X1 U847 ( .A0(NoCRCRsp), .A1(n1398), .B0(ANoCRCRsp), .B1(n1454), .Y(
        NoCRCRspMuxO) );
  OR4X1 U848 ( .A(SDreset), .B(ErrorState[1]), .C(n1417), .D(n1418), .Y(n1412)
         );
  OAI222X1 U849 ( .A0(n1453), .A1(n1420), .B0(n1421), .B1(n1422), .C0(n1454), 
        .C1(n1423), .Y(n1418) );
  OAI31X1 U850 ( .A0(n1424), .A1(C_AR_State[2]), .A2(C_AR_State[1]), .B0(n1425), .Y(n1417) );
  INVX1 U851 ( .A(DatFinSet), .Y(n1422) );
  OAI32X1 U852 ( .A0(n1416), .A1(C_AR_State[2]), .A2(C_AR_State[1]), .B0(n1447), .B1(n1412), .Y(n1386) );
  AO22X1 U853 ( .A0(n1410), .A1(C_AR_State[0]), .B0(n1411), .B1(n1412), .Y(
        n1387) );
  OAI211X1 U854 ( .A0(n1413), .A1(n1447), .B0(n1454), .C0(n1414), .Y(n1411) );
  INVX1 U855 ( .A(n1412), .Y(n1410) );
  NOR2BX1 U856 ( .AN(n1450), .B(SDreset), .Y(n1414) );
  AO22X1 U857 ( .A0(LongRsp), .A1(n1398), .B0(ALongRsp), .B1(n1454), .Y(
        LongRspMuxO) );
  BUFX2 U858 ( .A(AutoReadEn), .Y(n1454) );
  INVX1 U859 ( .A(n1432), .Y(n1431) );
  NAND2BX1 U860 ( .AN(SDreset), .B(n1433), .Y(n1432) );
  OAI221X1 U861 ( .A0(C_AR_State[0]), .A1(n1434), .B0(n1434), .B1(n1447), .C0(
        n1450), .Y(n1433) );
  INVX1 U862 ( .A(n1435), .Y(n1434) );
  AO22X1 U863 ( .A0(CmdIndex[5]), .A1(n1398), .B0(ACmdIndex_5_), .B1(n1454), 
        .Y(CmdIndexMuxO[5]) );
  AO22X1 U864 ( .A0(CmdIndex[4]), .A1(n1398), .B0(ACmdIndex_4_), .B1(n1454), 
        .Y(CmdIndexMuxO[4]) );
  AO22X1 U865 ( .A0(CmdIndex[3]), .A1(n1398), .B0(ACmdIndex_3_), .B1(n1454), 
        .Y(CmdIndexMuxO[3]) );
  AO22X1 U866 ( .A0(CmdIndex[2]), .A1(n1398), .B0(ACmdIndex_2_), .B1(n1454), 
        .Y(CmdIndexMuxO[2]) );
  AO22X1 U867 ( .A0(CmdIndex[1]), .A1(n1398), .B0(ACmdIndex_1_), .B1(n1454), 
        .Y(CmdIndexMuxO[1]) );
  AO22X1 U868 ( .A0(CmdIndex[0]), .A1(n1398), .B0(ACmdIndex_0_), .B1(n1454), 
        .Y(CmdIndexMuxO[0]) );
  AO22X1 U869 ( .A0(Cnt_1_), .A1(n1431), .B0(n1431), .B1(Cnt_0_), .Y(n1351) );
  AO22X1 U870 ( .A0(Cnt_1_), .A1(n1431), .B0(n1431), .B1(n1448), .Y(n1352) );
  AO22X1 U871 ( .A0(CmdArg[31]), .A1(n1398), .B0(ACmdArg_31_), .B1(n1454), .Y(
        CmdArgMuxO[31]) );
  AO22X1 U872 ( .A0(BusyRsp), .A1(n1398), .B0(ABusyRsp), .B1(n1454), .Y(
        BusyRspMuxO) );
  AO22X1 U873 ( .A0(CmdArg[7]), .A1(n1398), .B0(ACmdArg_7_), .B1(n1454), .Y(
        CmdArgMuxO[7]) );
  AO22X1 U874 ( .A0(CmdArg[8]), .A1(n1398), .B0(ACmdArg_8_), .B1(n1454), .Y(
        CmdArgMuxO[8]) );
  AO22X1 U875 ( .A0(CmdArg[6]), .A1(n1398), .B0(ACmdArg_6_), .B1(n1454), .Y(
        CmdArgMuxO[6]) );
  AO22X1 U876 ( .A0(CmdArg[5]), .A1(n1398), .B0(ACmdArg_5_), .B1(n1454), .Y(
        CmdArgMuxO[5]) );
  AO22X1 U877 ( .A0(CmdArg[4]), .A1(n1398), .B0(ACmdArg_4_), .B1(n1454), .Y(
        CmdArgMuxO[4]) );
  AO22X1 U878 ( .A0(CmdArg[3]), .A1(n1398), .B0(ACmdArg_3_), .B1(n1454), .Y(
        CmdArgMuxO[3]) );
  AO22X1 U879 ( .A0(CmdArg[2]), .A1(n1398), .B0(ACmdArg_2_), .B1(n1454), .Y(
        CmdArgMuxO[2]) );
  AO22X1 U880 ( .A0(CmdArg[1]), .A1(n1398), .B0(ACmdArg_1_), .B1(n1454), .Y(
        CmdArgMuxO[1]) );
  AO22X1 U881 ( .A0(ResponseCMD18[18]), .A1(n1426), .B0(Response0[18]), .B1(
        n1427), .Y(n1366) );
  AO22X1 U882 ( .A0(ResponseCMD18[17]), .A1(n1426), .B0(Response0[17]), .B1(
        n1427), .Y(n1367) );
  AO22X1 U883 ( .A0(ResponseCMD18[16]), .A1(n1426), .B0(Response0[16]), .B1(
        n1427), .Y(n1368) );
  AO22X1 U884 ( .A0(ResponseCMD18[14]), .A1(n1426), .B0(Response0[14]), .B1(
        n1427), .Y(n1370) );
  AO22X1 U885 ( .A0(ResponseCMD18[13]), .A1(n1426), .B0(Response0[13]), .B1(
        n1427), .Y(n1371) );
  AO22X1 U886 ( .A0(ResponseCMD18[12]), .A1(n1426), .B0(Response0[12]), .B1(
        n1427), .Y(n1372) );
  AO22X1 U887 ( .A0(ResponseCMD18[11]), .A1(n1426), .B0(Response0[11]), .B1(
        n1427), .Y(n1373) );
  AO22X1 U888 ( .A0(ResponseCMD18[10]), .A1(n1426), .B0(Response0[10]), .B1(
        n1427), .Y(n1374) );
  AO22X1 U889 ( .A0(ResponseCMD18[9]), .A1(n1426), .B0(Response0[9]), .B1(
        n1427), .Y(n1375) );
  AO22X1 U890 ( .A0(ResponseCMD18[8]), .A1(n1426), .B0(Response0[8]), .B1(
        n1427), .Y(n1376) );
  AO22X1 U891 ( .A0(ResponseCMD18[7]), .A1(n1426), .B0(Response0[7]), .B1(
        n1427), .Y(n1377) );
  AO22X1 U892 ( .A0(ResponseCMD18[6]), .A1(n1426), .B0(Response0[6]), .B1(
        n1427), .Y(n1378) );
  AO22X1 U893 ( .A0(ResponseCMD18[5]), .A1(n1426), .B0(Response0[5]), .B1(
        n1427), .Y(n1379) );
  AO22X1 U894 ( .A0(ResponseCMD18[4]), .A1(n1426), .B0(Response0[4]), .B1(
        n1427), .Y(n1380) );
  AO22X1 U895 ( .A0(ResponseCMD18[1]), .A1(n1426), .B0(Response0[1]), .B1(
        n1427), .Y(n1383) );
  AO22X1 U896 ( .A0(ResponseCMD18[0]), .A1(n1426), .B0(Response0[0]), .B1(
        n1427), .Y(n1384) );
  AO22X1 U897 ( .A0(ResponseCMD18[31]), .A1(n1426), .B0(Response0[31]), .B1(
        n1427), .Y(n1353) );
  AO22X1 U898 ( .A0(ResponseCMD18[30]), .A1(n1426), .B0(Response0[30]), .B1(
        n1427), .Y(n1354) );
  AO22X1 U899 ( .A0(ResponseCMD18[29]), .A1(n1426), .B0(Response0[29]), .B1(
        n1427), .Y(n1355) );
  AO22X1 U900 ( .A0(ResponseCMD18[28]), .A1(n1426), .B0(Response0[28]), .B1(
        n1427), .Y(n1356) );
  AO22X1 U901 ( .A0(ResponseCMD18[27]), .A1(n1426), .B0(Response0[27]), .B1(
        n1427), .Y(n1357) );
  AO22X1 U902 ( .A0(ResponseCMD18[26]), .A1(n1426), .B0(Response0[26]), .B1(
        n1427), .Y(n1358) );
  AO22X1 U903 ( .A0(ResponseCMD18[25]), .A1(n1426), .B0(Response0[25]), .B1(
        n1427), .Y(n1359) );
  AO22X1 U904 ( .A0(ResponseCMD18[24]), .A1(n1426), .B0(Response0[24]), .B1(
        n1427), .Y(n1360) );
  AO22X1 U905 ( .A0(ResponseCMD18[23]), .A1(n1426), .B0(Response0[23]), .B1(
        n1427), .Y(n1361) );
  AO22X1 U906 ( .A0(ResponseCMD18[22]), .A1(n1426), .B0(Response0[22]), .B1(
        n1427), .Y(n1362) );
  AO22X1 U907 ( .A0(ResponseCMD18[21]), .A1(n1426), .B0(Response0[21]), .B1(
        n1427), .Y(n1363) );
  AO22X1 U908 ( .A0(ResponseCMD18[20]), .A1(n1426), .B0(Response0[20]), .B1(
        n1427), .Y(n1364) );
  AO22X1 U909 ( .A0(ResponseCMD18[19]), .A1(n1426), .B0(Response0[19]), .B1(
        n1427), .Y(n1365) );
  AO22X1 U910 ( .A0(ResponseCMD18[15]), .A1(n1426), .B0(Response0[15]), .B1(
        n1427), .Y(n1369) );
  AO22X1 U911 ( .A0(ResponseCMD18[3]), .A1(n1426), .B0(Response0[3]), .B1(
        n1427), .Y(n1381) );
  AO22X1 U912 ( .A0(ResponseCMD18[2]), .A1(n1426), .B0(Response0[2]), .B1(
        n1427), .Y(n1382) );
  AO22X1 U913 ( .A0(CmdArg[0]), .A1(n1398), .B0(ACmdArg_0_), .B1(n1454), .Y(
        CmdArgMuxO[0]) );
  AO22X1 U914 ( .A0(CmdArg[24]), .A1(n1398), .B0(ACmdArg_24_), .B1(n1454), .Y(
        CmdArgMuxO[24]) );
  AO22X1 U915 ( .A0(CmdArg[23]), .A1(n1398), .B0(ACmdArg_23_), .B1(n1454), .Y(
        CmdArgMuxO[23]) );
  AO22X1 U916 ( .A0(CmdArg[22]), .A1(n1398), .B0(ACmdArg_22_), .B1(n1454), .Y(
        CmdArgMuxO[22]) );
  AO22X1 U917 ( .A0(CmdArg[21]), .A1(n1398), .B0(ACmdArg_21_), .B1(n1454), .Y(
        CmdArgMuxO[21]) );
  AO22X1 U918 ( .A0(CmdArg[20]), .A1(n1398), .B0(ACmdArg_20_), .B1(n1454), .Y(
        CmdArgMuxO[20]) );
  AO22X1 U919 ( .A0(CmdArg[19]), .A1(n1398), .B0(ACmdArg_19_), .B1(n1454), .Y(
        CmdArgMuxO[19]) );
  AO22X1 U920 ( .A0(CmdArg[18]), .A1(n1398), .B0(ACmdArg_18_), .B1(n1454), .Y(
        CmdArgMuxO[18]) );
  AO22X1 U921 ( .A0(CmdArg[17]), .A1(n1398), .B0(ACmdArg_17_), .B1(n1454), .Y(
        CmdArgMuxO[17]) );
  AO22X1 U922 ( .A0(CmdArg[16]), .A1(n1398), .B0(ACmdArg_16_), .B1(n1454), .Y(
        CmdArgMuxO[16]) );
  AO22X1 U923 ( .A0(CmdArg[15]), .A1(n1398), .B0(ACmdArg_15_), .B1(n1454), .Y(
        CmdArgMuxO[15]) );
  AO22X1 U924 ( .A0(CmdArg[14]), .A1(n1398), .B0(ACmdArg_14_), .B1(n1454), .Y(
        CmdArgMuxO[14]) );
  AO22X1 U925 ( .A0(CmdArg[13]), .A1(n1398), .B0(ACmdArg_13_), .B1(n1454), .Y(
        CmdArgMuxO[13]) );
  AO22X1 U926 ( .A0(CmdArg[12]), .A1(n1398), .B0(ACmdArg_12_), .B1(n1454), .Y(
        CmdArgMuxO[12]) );
  AO22X1 U927 ( .A0(CmdArg[11]), .A1(n1398), .B0(ACmdArg_11_), .B1(n1454), .Y(
        CmdArgMuxO[11]) );
  AO22X1 U928 ( .A0(CmdArg[10]), .A1(n1398), .B0(ACmdArg_10_), .B1(n1454), .Y(
        CmdArgMuxO[10]) );
  AO22X1 U929 ( .A0(CmdArg[9]), .A1(n1398), .B0(ACmdArg_9_), .B1(n1454), .Y(
        CmdArgMuxO[9]) );
  NAND3BX1 U930 ( .AN(C_AR_State[2]), .B(n1449), .C(C_AR_State[1]), .Y(n1421)
         );
  AO22X1 U931 ( .A0(WaitRsp), .A1(n1398), .B0(AWaitRsp), .B1(n1454), .Y(
        WaitRspMuxO) );
  AO22X1 U932 ( .A0(CmdStart), .A1(n1454), .B0(CMST), .B1(n1398), .Y(
        CmdStartMuxO) );
  AO22X1 U933 ( .A0(CmdIndex[6]), .A1(n1398), .B0(ACmdIndex_6_), .B1(n1454), 
        .Y(CmdIndexMuxO[6]) );
  OAI33X1 U934 ( .A0(SDreset), .A1(n1451), .A2(CMSTClr), .B0(n1404), .B1(n1405), .B2(n1448), .Y(n1388) );
  NAND2BX1 U935 ( .AN(Cnt_1_), .B(n1449), .Y(n1405) );
  INVX1 U936 ( .A(n1401), .Y(n1404) );
  NAND3BX1 U937 ( .AN(C_AR_State[1]), .B(n1449), .C(C_AR_State[2]), .Y(n1420)
         );
  INVX1 U938 ( .A(n1437), .Y(n1400) );
  NAND3BX1 U939 ( .AN(SDreset), .B(C_AR_State[2]), .C(n1455), .Y(n1437) );
  OAI33X1 U940 ( .A0(n1447), .A1(SDreset), .A2(C_AR_State[2]), .B0(n1450), 
        .B1(SDreset), .B2(C_AR_State[1]), .Y(n1401) );
  NAND3BX1 U941 ( .AN(n1449), .B(RCmdStart), .C(SingleMultiRead), .Y(n1424) );
  BUFX2 U942 ( .A(n1402), .Y(n1455) );
  OAI31X1 U943 ( .A0(n1423), .A1(Cnt_1_), .A2(Cnt_0_), .B0(n1438), .Y(n1402)
         );
  NOR2X1 U944 ( .A(BusyFinSet), .B(NoBusySet), .Y(n1453) );
  AO22X1 U945 ( .A0(AbortCmd), .A1(n1398), .B0(AAbortCmd), .B1(n1454), .Y(
        AbortCmdMuxO) );
  NOR2BX1 U946 ( .AN(ACmdIndex_5_), .B(n1455), .Y(n1345) );
  NOR2BX1 U947 ( .AN(ACmdIndex_0_), .B(n1455), .Y(n1350) );
  NOR2BX1 U948 ( .AN(ANoCRCRsp), .B(n1455), .Y(n1389) );
  NOR2BX1 U949 ( .AN(ALongRsp), .B(n1455), .Y(n1390) );
  AO22X1 U950 ( .A0(n1455), .A1(n1438), .B0(ACmdIndex_6_), .B1(n1399), .Y(
        n1344) );
  AO22X1 U951 ( .A0(n1399), .A1(ACmdArg_26_), .B0(n1436), .B1(CmdArg[26]), .Y(
        n1317) );
  AO22X1 U952 ( .A0(ACmdArg_22_), .A1(n1399), .B0(CmdArg[22]), .B1(n1436), .Y(
        n1321) );
  AO22X1 U953 ( .A0(ACmdArg_21_), .A1(n1399), .B0(CmdArg[21]), .B1(n1436), .Y(
        n1322) );
  AO22X1 U954 ( .A0(ACmdArg_20_), .A1(n1399), .B0(CmdArg[20]), .B1(n1436), .Y(
        n1323) );
  AO22X1 U955 ( .A0(ACmdArg_19_), .A1(n1399), .B0(CmdArg[19]), .B1(n1436), .Y(
        n1324) );
  AO22X1 U956 ( .A0(ACmdArg_4_), .A1(n1399), .B0(CmdArg[4]), .B1(n1436), .Y(
        n1339) );
  AO22X1 U957 ( .A0(ACmdArg_3_), .A1(n1399), .B0(CmdArg[3]), .B1(n1436), .Y(
        n1340) );
  AO22X1 U958 ( .A0(ACmdArg_18_), .A1(n1399), .B0(CmdArg[18]), .B1(n1436), .Y(
        n1325) );
  AO22X1 U959 ( .A0(ACmdArg_17_), .A1(n1399), .B0(CmdArg[17]), .B1(n1436), .Y(
        n1326) );
  AO22X1 U960 ( .A0(ACmdArg_16_), .A1(n1399), .B0(CmdArg[16]), .B1(n1436), .Y(
        n1327) );
  AO22X1 U961 ( .A0(ACmdArg_14_), .A1(n1399), .B0(CmdArg[14]), .B1(n1436), .Y(
        n1329) );
  AO22X1 U962 ( .A0(ACmdArg_13_), .A1(n1399), .B0(CmdArg[13]), .B1(n1436), .Y(
        n1330) );
  AO22X1 U963 ( .A0(ACmdArg_9_), .A1(n1399), .B0(CmdArg[9]), .B1(n1436), .Y(
        n1334) );
  AO22X1 U964 ( .A0(ACmdArg_8_), .A1(n1399), .B0(CmdArg[8]), .B1(n1436), .Y(
        n1335) );
  AO22X1 U965 ( .A0(ACmdArg_1_), .A1(n1399), .B0(CmdArg[1]), .B1(n1436), .Y(
        n1342) );
  AO22X1 U966 ( .A0(ACmdArg_0_), .A1(n1399), .B0(CmdArg[0]), .B1(n1436), .Y(
        n1343) );
  AO22X1 U967 ( .A0(AWaitRsp), .A1(n1399), .B0(n1401), .B1(n1455), .Y(n1391)
         );
  AO22X1 U968 ( .A0(ACmdArg_31_), .A1(n1399), .B0(CmdArg[31]), .B1(n1436), .Y(
        n1312) );
  AO22X1 U969 ( .A0(ACmdArg_30_), .A1(n1399), .B0(CmdArg[30]), .B1(n1436), .Y(
        n1313) );
  AO22X1 U970 ( .A0(ACmdArg_29_), .A1(n1399), .B0(CmdArg[29]), .B1(n1436), .Y(
        n1314) );
  AO22X1 U971 ( .A0(ACmdArg_28_), .A1(n1399), .B0(CmdArg[28]), .B1(n1436), .Y(
        n1315) );
  AO22X1 U972 ( .A0(ACmdArg_27_), .A1(n1399), .B0(CmdArg[27]), .B1(n1436), .Y(
        n1316) );
  AO22X1 U973 ( .A0(ACmdArg_25_), .A1(n1399), .B0(CmdArg[25]), .B1(n1436), .Y(
        n1318) );
  AO22X1 U974 ( .A0(ACmdArg_24_), .A1(n1399), .B0(CmdArg[24]), .B1(n1436), .Y(
        n1319) );
  AO22X1 U975 ( .A0(ACmdArg_23_), .A1(n1399), .B0(CmdArg[23]), .B1(n1436), .Y(
        n1320) );
  AO22X1 U976 ( .A0(ACmdArg_12_), .A1(n1399), .B0(CmdArg[12]), .B1(n1436), .Y(
        n1331) );
  AO22X1 U977 ( .A0(ACmdArg_11_), .A1(n1399), .B0(CmdArg[11]), .B1(n1436), .Y(
        n1332) );
  AO22X1 U978 ( .A0(ACmdArg_10_), .A1(n1399), .B0(CmdArg[10]), .B1(n1436), .Y(
        n1333) );
  AO22X1 U979 ( .A0(ACmdArg_7_), .A1(n1399), .B0(CmdArg[7]), .B1(n1436), .Y(
        n1336) );
  AO22X1 U980 ( .A0(ACmdArg_6_), .A1(n1399), .B0(CmdArg[6]), .B1(n1436), .Y(
        n1337) );
  AO22X1 U981 ( .A0(ACmdArg_5_), .A1(n1399), .B0(CmdArg[5]), .B1(n1436), .Y(
        n1338) );
  AO22X1 U982 ( .A0(ACmdArg_2_), .A1(n1399), .B0(CmdArg[2]), .B1(n1436), .Y(
        n1341) );
  AO22X1 U983 ( .A0(ACmdArg_15_), .A1(n1399), .B0(CmdArg[15]), .B1(n1436), .Y(
        n1328) );
  AO22X1 U984 ( .A0(CmdArg[30]), .A1(n1398), .B0(ACmdArg_30_), .B1(n1454), .Y(
        CmdArgMuxO[30]) );
  AO22X1 U985 ( .A0(CmdArg[29]), .A1(n1398), .B0(ACmdArg_29_), .B1(n1454), .Y(
        CmdArgMuxO[29]) );
  AO22X1 U986 ( .A0(CmdArg[28]), .A1(n1398), .B0(ACmdArg_28_), .B1(n1454), .Y(
        CmdArgMuxO[28]) );
  AO22X1 U987 ( .A0(CmdArg[27]), .A1(n1398), .B0(ACmdArg_27_), .B1(n1454), .Y(
        CmdArgMuxO[27]) );
  AO22X1 U988 ( .A0(CmdArg[25]), .A1(n1398), .B0(ACmdArg_25_), .B1(n1454), .Y(
        CmdArgMuxO[25]) );
  AO22X1 U989 ( .A0(CmdArg[26]), .A1(n1398), .B0(n1454), .B1(ACmdArg_26_), .Y(
        CmdArgMuxO[26]) );
  AO21X1 U990 ( .A0(ACmdIndex_4_), .A1(n1399), .B0(n1436), .Y(n1346) );
  AO21X1 U991 ( .A0(ACmdIndex_3_), .A1(n1399), .B0(n1400), .Y(n1347) );
  AO21X1 U992 ( .A0(ACmdIndex_2_), .A1(n1399), .B0(n1400), .Y(n1348) );
  AO21X1 U993 ( .A0(ACmdIndex_1_), .A1(n1399), .B0(n1436), .Y(n1349) );
  AO21X1 U994 ( .A0(ABusyRsp), .A1(n1399), .B0(n1400), .Y(n1392) );
  AO21X1 U995 ( .A0(AAbortCmd), .A1(n1399), .B0(n1400), .Y(n1393) );
  DFFRX1 ALongRsp_reg ( .D(n1390), .CK(PCLK), .RN(nRst), .Q(ALongRsp) );
  DFFRX1 C_AR_State_reg_2_ ( .D(n1385), .CK(PCLK), .RN(nRst), .Q(C_AR_State[2]), .QN(n1450) );
  DFFRX1 CmdStart_reg ( .D(n1388), .CK(PCLK), .RN(nRst), .Q(CmdStart), .QN(
        n1451) );
  DFFRX1 AWaitRsp_reg ( .D(n1391), .CK(PCLK), .RN(nRst), .Q(AWaitRsp) );
  DFFRX1 ANoCRCRsp_reg ( .D(n1389), .CK(PCLK), .RN(nRst), .Q(ANoCRCRsp) );
  DFFRX1 C_AR_State_reg_1_ ( .D(n1386), .CK(PCLK), .RN(nRst), .Q(C_AR_State[1]), .QN(n1447) );
  DFFSX1 C_AR_State_reg_0_ ( .D(n1387), .CK(PCLK), .SN(nRst), .Q(C_AR_State[0]), .QN(n1449) );
  DFFRX1 Cnt_reg_0_ ( .D(n1352), .CK(PCLK), .RN(nRst), .Q(Cnt_0_), .QN(n1448)
         );
  DFFRX1 Cnt_reg_1_ ( .D(n1351), .CK(PCLK), .RN(nRst), .Q(Cnt_1_) );
  DFFRX1 ResponseCMD18_reg_3_ ( .D(n1381), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[3]) );
  DFFRX1 ResponseCMD18_reg_2_ ( .D(n1382), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[2]) );
  DFFRX1 ResponseCMD18_reg_1_ ( .D(n1383), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[1]) );
  DFFRX1 ResponseCMD18_reg_0_ ( .D(n1384), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[0]) );
  DFFRX1 ACmdArg_reg_31_ ( .D(n1312), .CK(PCLK), .RN(nRst), .Q(ACmdArg_31_) );
  DFFRX1 ACmdArg_reg_30_ ( .D(n1313), .CK(PCLK), .RN(nRst), .Q(ACmdArg_30_) );
  DFFRX1 ACmdArg_reg_29_ ( .D(n1314), .CK(PCLK), .RN(nRst), .Q(ACmdArg_29_) );
  DFFRX1 ACmdArg_reg_28_ ( .D(n1315), .CK(PCLK), .RN(nRst), .Q(ACmdArg_28_) );
  DFFRX1 ACmdArg_reg_27_ ( .D(n1316), .CK(PCLK), .RN(nRst), .Q(ACmdArg_27_) );
  DFFRX1 ACmdArg_reg_25_ ( .D(n1318), .CK(PCLK), .RN(nRst), .Q(ACmdArg_25_) );
  DFFRX1 ResponseCMD18_reg_31_ ( .D(n1353), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[31]) );
  DFFRX1 ResponseCMD18_reg_30_ ( .D(n1354), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[30]) );
  DFFRX1 ResponseCMD18_reg_29_ ( .D(n1355), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[29]) );
  DFFRX1 ResponseCMD18_reg_28_ ( .D(n1356), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[28]) );
  DFFRX1 ResponseCMD18_reg_27_ ( .D(n1357), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[27]) );
  DFFRX1 ResponseCMD18_reg_26_ ( .D(n1358), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[26]) );
  DFFRX1 ResponseCMD18_reg_25_ ( .D(n1359), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[25]) );
  DFFRX1 ResponseCMD18_reg_24_ ( .D(n1360), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[24]) );
  DFFRX1 ResponseCMD18_reg_23_ ( .D(n1361), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[23]) );
  DFFRX1 ResponseCMD18_reg_15_ ( .D(n1369), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[15]) );
  DFFRX1 ACmdArg_reg_26_ ( .D(n1317), .CK(PCLK), .RN(nRst), .Q(ACmdArg_26_) );
  DFFRX1 ACmdIndex_reg_6_ ( .D(n1344), .CK(PCLK), .RN(nRst), .Q(ACmdIndex_6_)
         );
  DFFRX1 ACmdIndex_reg_4_ ( .D(n1346), .CK(PCLK), .RN(nRst), .Q(ACmdIndex_4_)
         );
  DFFRX1 ACmdIndex_reg_3_ ( .D(n1347), .CK(PCLK), .RN(nRst), .Q(ACmdIndex_3_)
         );
  DFFRX1 ACmdIndex_reg_2_ ( .D(n1348), .CK(PCLK), .RN(nRst), .Q(ACmdIndex_2_)
         );
  DFFRX1 ACmdIndex_reg_1_ ( .D(n1349), .CK(PCLK), .RN(nRst), .Q(ACmdIndex_1_)
         );
  DFFRX1 ABusyRsp_reg ( .D(n1392), .CK(PCLK), .RN(nRst), .Q(ABusyRsp) );
  DFFRX1 ACmdIndex_reg_5_ ( .D(n1345), .CK(PCLK), .RN(nRst), .Q(ACmdIndex_5_)
         );
  DFFRX1 ACmdIndex_reg_0_ ( .D(n1350), .CK(PCLK), .RN(nRst), .Q(ACmdIndex_0_)
         );
  DFFRX1 ACmdArg_reg_24_ ( .D(n1319), .CK(PCLK), .RN(nRst), .Q(ACmdArg_24_) );
  DFFRX1 ACmdArg_reg_23_ ( .D(n1320), .CK(PCLK), .RN(nRst), .Q(ACmdArg_23_) );
  DFFRX1 ACmdArg_reg_22_ ( .D(n1321), .CK(PCLK), .RN(nRst), .Q(ACmdArg_22_) );
  DFFRX1 ACmdArg_reg_21_ ( .D(n1322), .CK(PCLK), .RN(nRst), .Q(ACmdArg_21_) );
  DFFRX1 ACmdArg_reg_20_ ( .D(n1323), .CK(PCLK), .RN(nRst), .Q(ACmdArg_20_) );
  DFFRX1 ACmdArg_reg_19_ ( .D(n1324), .CK(PCLK), .RN(nRst), .Q(ACmdArg_19_) );
  DFFRX1 ACmdArg_reg_18_ ( .D(n1325), .CK(PCLK), .RN(nRst), .Q(ACmdArg_18_) );
  DFFRX1 ACmdArg_reg_17_ ( .D(n1326), .CK(PCLK), .RN(nRst), .Q(ACmdArg_17_) );
  DFFRX1 ACmdArg_reg_16_ ( .D(n1327), .CK(PCLK), .RN(nRst), .Q(ACmdArg_16_) );
  DFFRX1 ACmdArg_reg_15_ ( .D(n1328), .CK(PCLK), .RN(nRst), .Q(ACmdArg_15_) );
  DFFRX1 ACmdArg_reg_14_ ( .D(n1329), .CK(PCLK), .RN(nRst), .Q(ACmdArg_14_) );
  DFFRX1 ACmdArg_reg_13_ ( .D(n1330), .CK(PCLK), .RN(nRst), .Q(ACmdArg_13_) );
  DFFRX1 ACmdArg_reg_12_ ( .D(n1331), .CK(PCLK), .RN(nRst), .Q(ACmdArg_12_) );
  DFFRX1 ACmdArg_reg_11_ ( .D(n1332), .CK(PCLK), .RN(nRst), .Q(ACmdArg_11_) );
  DFFRX1 ACmdArg_reg_10_ ( .D(n1333), .CK(PCLK), .RN(nRst), .Q(ACmdArg_10_) );
  DFFRX1 ACmdArg_reg_9_ ( .D(n1334), .CK(PCLK), .RN(nRst), .Q(ACmdArg_9_) );
  DFFRX1 ACmdArg_reg_8_ ( .D(n1335), .CK(PCLK), .RN(nRst), .Q(ACmdArg_8_) );
  DFFRX1 ACmdArg_reg_7_ ( .D(n1336), .CK(PCLK), .RN(nRst), .Q(ACmdArg_7_) );
  DFFRX1 ACmdArg_reg_6_ ( .D(n1337), .CK(PCLK), .RN(nRst), .Q(ACmdArg_6_) );
  DFFRX1 ACmdArg_reg_5_ ( .D(n1338), .CK(PCLK), .RN(nRst), .Q(ACmdArg_5_) );
  DFFRX1 ACmdArg_reg_4_ ( .D(n1339), .CK(PCLK), .RN(nRst), .Q(ACmdArg_4_) );
  DFFRX1 ACmdArg_reg_3_ ( .D(n1340), .CK(PCLK), .RN(nRst), .Q(ACmdArg_3_) );
  DFFRX1 ACmdArg_reg_2_ ( .D(n1341), .CK(PCLK), .RN(nRst), .Q(ACmdArg_2_) );
  DFFRX1 ACmdArg_reg_1_ ( .D(n1342), .CK(PCLK), .RN(nRst), .Q(ACmdArg_1_) );
  DFFRX1 ACmdArg_reg_0_ ( .D(n1343), .CK(PCLK), .RN(nRst), .Q(ACmdArg_0_) );
  DFFRX1 AAbortCmd_reg ( .D(n1393), .CK(PCLK), .RN(nRst), .Q(AAbortCmd) );
  DFFRX1 ResponseCMD18_reg_18_ ( .D(n1366), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[18]) );
  DFFRX1 ResponseCMD18_reg_17_ ( .D(n1367), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[17]) );
  DFFRX1 ResponseCMD18_reg_16_ ( .D(n1368), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[16]) );
  DFFRX1 ResponseCMD18_reg_14_ ( .D(n1370), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[14]) );
  DFFRX1 ResponseCMD18_reg_13_ ( .D(n1371), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[13]) );
  DFFRX1 ResponseCMD18_reg_12_ ( .D(n1372), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[12]) );
  DFFRX1 ResponseCMD18_reg_11_ ( .D(n1373), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[11]) );
  DFFRX1 ResponseCMD18_reg_10_ ( .D(n1374), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[10]) );
  DFFRX1 ResponseCMD18_reg_9_ ( .D(n1375), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[9]) );
  DFFRX1 ResponseCMD18_reg_8_ ( .D(n1376), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[8]) );
  DFFRX1 ResponseCMD18_reg_7_ ( .D(n1377), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[7]) );
  DFFRX1 ResponseCMD18_reg_6_ ( .D(n1378), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[6]) );
  DFFRX1 ResponseCMD18_reg_5_ ( .D(n1379), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[5]) );
  DFFRX1 ResponseCMD18_reg_4_ ( .D(n1380), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[4]) );
  DFFRX1 ResponseCMD18_reg_22_ ( .D(n1362), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[22]) );
  DFFRX1 ResponseCMD18_reg_21_ ( .D(n1363), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[21]) );
  DFFRX1 ResponseCMD18_reg_20_ ( .D(n1364), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[20]) );
  DFFRX1 ResponseCMD18_reg_19_ ( .D(n1365), .CK(PCLK), .RN(nRst), .Q(
        ResponseCMD18[19]) );
endmodule


module mmc_FeedBackSync ( nRst, SDreset, MMC_FBCLK, MMC_CMDIN, MMC_DATIN, 
        CMDIN, DATIN );
  input [7:0] MMC_DATIN;
  output [7:0] DATIN;
  input nRst, SDreset, MMC_FBCLK, MMC_CMDIN;
  output CMDIN;
  wire   CMDIN58, DATIN64_7_, DATIN64_6_, DATIN64_5_, DATIN64_4_, DATIN64_3_,
         DATIN64_2_, DATIN64_1_, DATIN64_0_, n111;

  INVX1 U58 ( .A(SDreset), .Y(n111) );
  DFFSX1 DATIN_reg_0_ ( .D(DATIN64_0_), .CK(MMC_FBCLK), .SN(nRst), .Q(DATIN[0]) );
  NAND2BX1 U59 ( .AN(MMC_CMDIN), .B(n111), .Y(CMDIN58) );
  NAND2BX1 U60 ( .AN(MMC_DATIN[0]), .B(n111), .Y(DATIN64_0_) );
  NAND2BX1 U61 ( .AN(MMC_DATIN[1]), .B(n111), .Y(DATIN64_1_) );
  NAND2BX1 U62 ( .AN(MMC_DATIN[2]), .B(n111), .Y(DATIN64_2_) );
  NAND2BX1 U63 ( .AN(MMC_DATIN[3]), .B(n111), .Y(DATIN64_3_) );
  NAND2BX1 U64 ( .AN(MMC_DATIN[4]), .B(n111), .Y(DATIN64_4_) );
  NAND2BX1 U65 ( .AN(MMC_DATIN[5]), .B(n111), .Y(DATIN64_5_) );
  NAND2BX1 U66 ( .AN(MMC_DATIN[6]), .B(n111), .Y(DATIN64_6_) );
  NAND2BX1 U67 ( .AN(MMC_DATIN[7]), .B(n111), .Y(DATIN64_7_) );
  DFFSX1 CMDIN_reg ( .D(CMDIN58), .CK(MMC_FBCLK), .SN(nRst), .Q(CMDIN) );
  DFFSX1 DATIN_reg_1_ ( .D(DATIN64_1_), .CK(MMC_FBCLK), .SN(nRst), .Q(DATIN[1]) );
  DFFSX1 DATIN_reg_2_ ( .D(DATIN64_2_), .CK(MMC_FBCLK), .SN(nRst), .Q(DATIN[2]) );
  DFFSX1 DATIN_reg_3_ ( .D(DATIN64_3_), .CK(MMC_FBCLK), .SN(nRst), .Q(DATIN[3]) );
  DFFSX1 DATIN_reg_4_ ( .D(DATIN64_4_), .CK(MMC_FBCLK), .SN(nRst), .Q(DATIN[4]) );
  DFFSX1 DATIN_reg_5_ ( .D(DATIN64_5_), .CK(MMC_FBCLK), .SN(nRst), .Q(DATIN[5]) );
  DFFSX1 DATIN_reg_6_ ( .D(DATIN64_6_), .CK(MMC_FBCLK), .SN(nRst), .Q(DATIN[6]) );
  DFFSX1 DATIN_reg_7_ ( .D(DATIN64_7_), .CK(MMC_FBCLK), .SN(nRst), .Q(DATIN[7]) );
endmodule


module DLY3ns ( Y, A );
  input A;
  output Y;
  wire   A1, A2, A3, A4, A5, A6;

  DLY3X1 DLY1 ( .A(A), .Y(A1) );
  DLY3X1 DLY2 ( .A(A1), .Y(A2) );
  DLY3X1 DLY3 ( .A(A2), .Y(A3) );
  DLY3X1 DLY4 ( .A(A3), .Y(A4) );
  DLY3X1 DLY5 ( .A(A4), .Y(A5) );
  DLY3X1 DLY6 ( .A(A5), .Y(A6) );
  DLY3X1 DLY7 ( .A(A6), .Y(Y) );
endmodule


module mmc_PSave ( PCLK, PRESETn, CKPulse, CMST, ENCLK_REG, ENCLK_FIFO, 
        CmdCtrlIdle, BusyChkIdle, DatCtrlIdle, PSAVEON, ENCLK );
  input PCLK, PRESETn, CKPulse, CMST, ENCLK_REG, ENCLK_FIFO, CmdCtrlIdle,
         BusyChkIdle, DatCtrlIdle, PSAVEON;
  output ENCLK;
  wire   n204, n205, n206, n207, n213, n214, n216, n217, n219, n220, n222,
         n223, n224, n225, n227, n228, n229, n230, n231, n232;
  wire   [3:0] PulseCnt;

  AO21X1 U97 ( .A0(n225), .A1(n229), .B0(n216), .Y(n222) );
  AO21X1 U98 ( .A0(n225), .A1(n230), .B0(n213), .Y(n216) );
  INVX1 U99 ( .A(n219), .Y(n217) );
  INVX1 U100 ( .A(n214), .Y(n213) );
  AND3X2 U101 ( .A(ENCLK_FIFO), .B(ENCLK_REG), .C(n227), .Y(ENCLK) );
  NAND3BX1 U102 ( .AN(n228), .B(PulseCnt[3]), .C(PSAVEON), .Y(n227) );
  NAND3BX1 U103 ( .AN(PulseCnt[2]), .B(n229), .C(n230), .Y(n228) );
  NAND3BX1 U104 ( .AN(CMST), .B(PulseCnt[0]), .C(n214), .Y(n219) );
  OAI2BB1X1 U105 ( .A0N(PulseCnt[3]), .A1N(n222), .B0(n223), .Y(n204) );
  AOI33X1 U106 ( .A0(n224), .A1(PulseCnt[1]), .A2(n217), .B0(n225), .B1(n231), 
        .B2(PulseCnt[3]), .Y(n223) );
  NOR2BX1 U107 ( .AN(PulseCnt[2]), .B(PulseCnt[3]), .Y(n224) );
  NAND2X1 U108 ( .A(n232), .B(n225), .Y(n214) );
  NAND4X1 U109 ( .A(DatCtrlIdle), .B(CmdCtrlIdle), .C(CKPulse), .D(BusyChkIdle), .Y(n232) );
  AO22X1 U110 ( .A0(PulseCnt[1]), .A1(n216), .B0(n217), .B1(n229), .Y(n206) );
  OAI32X1 U111 ( .A0(n213), .A1(PulseCnt[0]), .A2(CMST), .B0(n214), .B1(n230), 
        .Y(n207) );
  OAI32X1 U112 ( .A0(n219), .A1(PulseCnt[2]), .A2(n229), .B0(n220), .B1(n231), 
        .Y(n205) );
  INVX1 U113 ( .A(n222), .Y(n220) );
  INVX1 U114 ( .A(CMST), .Y(n225) );
  DFFRX1 PulseCnt_reg_0_ ( .D(n207), .CK(PCLK), .RN(PRESETn), .Q(PulseCnt[0]), 
        .QN(n230) );
  DFFRX1 PulseCnt_reg_2_ ( .D(n205), .CK(PCLK), .RN(PRESETn), .Q(PulseCnt[2]), 
        .QN(n231) );
  DFFRX1 PulseCnt_reg_1_ ( .D(n206), .CK(PCLK), .RN(PRESETn), .Q(PulseCnt[1]), 
        .QN(n229) );
  DFFRX1 PulseCnt_reg_3_ ( .D(n204), .CK(PCLK), .RN(PRESETn), .Q(PulseCnt[3])
         );
endmodule


module mmc_FifoDmaCtr ( PCLK, PRESETn, SDreset, FRST, DatMode, DMASize, 
        TxActive, TxRdPtrInc, PWData, RxActive, RxRdPtrInc, RxFWrData, 
        RxWriteEn, TxWriteEn, RxUnderrun, TxOverrun, TFDET, TFHalf, TFEmpty, 
        TFREmpty, RFFull, RFHalf, RFDET, FFCNT, FIFORdData, EnDMA, DREQ );
  input [1:0] DatMode;
  input [5:0] DMASize;
  input [31:0] PWData;
  input [31:0] RxFWrData;
  output [4:0] FFCNT;
  output [31:0] FIFORdData;
  input PCLK, PRESETn, SDreset, FRST, TxActive, TxRdPtrInc, RxActive,
         RxRdPtrInc, RxWriteEn, TxWriteEn, EnDMA;
  output RxUnderrun, TxOverrun, TFDET, TFHalf, TFEmpty, TFREmpty, RFFull,
         RFHalf, RFDET, DREQ;
  wire   dRxWriteEn, dTxRdPtrInc, FIFOFull, FIFOHalfEmpty, FIFOHalfFull,
         FIFOEmpty, FIFOReadEmpty, FIFOWrite, FIFORead, dRxWriteEn158,
         dTxRdPtrInc164, DREQ323, n377, n378, n379, n380, n381, n382, n383,
         n384, n385, n387, n388, n389, n391, n392, n393, n394, n396, n398,
         n399, n400, n401, n402, n403, n404, n405, n406, n407, n408, n409,
         n410, n411, n412, n413, n414, n415, n416, n417, n418, n419, n420,
         n421, n423, n424, n425, n426, n427, n428, n429, n430, n431, n432,
         n433, n434, n435, n437, n438, n439, n440, n441;
  wire   [31:0] FIFOWdata;

  mmc_Fifo_FIFO_AW5 mmcFifo ( .Clk(PCLK), .nRST(PRESETn), .SDreset(SDreset), 
        .FIFOWrite(FIFOWrite), .FIFOWrData(FIFOWdata), .FIFORead(FIFORead), 
        .FIFORdData(FIFORdData), .FIFOFlush(FRST), .FIFOFull(FIFOFull), 
        .FIFOHalfFull(FIFOHalfFull), .FIFOHalfEmpty(FIFOHalfEmpty), 
        .FIFOEmpty(FIFOEmpty), .FIFOReadEmpty(FIFOReadEmpty), .DatCnt(FFCNT)
         );
  AO21X4 U177 ( .A0(TxWriteEn), .A1(n441), .B0(n383), .Y(FIFOWrite) );
  AO21X4 U267 ( .A0(RxRdPtrInc), .A1(n387), .B0(n388), .Y(FIFORead) );
  AOI21X1 U268 ( .A0(FFCNT[4]), .A1(n423), .B0(n424), .Y(n437) );
  BUFX2 U269 ( .A(TxActive), .Y(n441) );
  NOR2BX1 U270 ( .AN(FIFOEmpty), .B(n379), .Y(TFEmpty) );
  NOR2BX1 U271 ( .AN(FIFOHalfEmpty), .B(n379), .Y(TFHalf) );
  INVX1 U272 ( .A(FIFORead), .Y(n380) );
  INVX1 U273 ( .A(FIFOWrite), .Y(n377) );
  INVX1 U274 ( .A(n421), .Y(n412) );
  OAI33X1 U275 ( .A0(n410), .A1(n411), .A2(n408), .B0(n412), .B1(n413), .B2(
        n414), .Y(n409) );
  INVX1 U276 ( .A(n404), .Y(n406) );
  INVX1 U277 ( .A(n423), .Y(n405) );
  NOR2BX1 U278 ( .AN(FIFOHalfFull), .B(n382), .Y(RFHalf) );
  NOR2BX1 U279 ( .AN(FIFOReadEmpty), .B(n379), .Y(TFREmpty) );
  INVX1 U280 ( .A(n384), .Y(n387) );
  INVX1 U281 ( .A(FIFOReadEmpty), .Y(n381) );
  INVX1 U282 ( .A(n441), .Y(n379) );
  DFFRX1 DREQ_reg ( .D(DREQ323), .CK(PCLK), .RN(PRESETn), .Q(DREQ) );
  OAI33X1 U283 ( .A0(n384), .A1(dRxWriteEn), .A2(n385), .B0(n384), .B1(
        RxWriteEn), .B2(n438), .Y(n383) );
  INVX1 U284 ( .A(RxWriteEn), .Y(n385) );
  OAI33X1 U285 ( .A0(n379), .A1(dTxRdPtrInc), .A2(n389), .B0(n379), .B1(
        TxRdPtrInc), .B2(n439), .Y(n388) );
  INVX1 U286 ( .A(TxRdPtrInc), .Y(n389) );
  NOR2BX1 U287 ( .AN(n441), .B(FIFOFull), .Y(TFDET) );
  NOR3BX1 U288 ( .AN(n441), .B(n377), .C(n378), .Y(TxOverrun) );
  NOR3BX1 U289 ( .AN(RxActive), .B(n380), .C(n381), .Y(RxUnderrun) );
  AO22X1 U290 ( .A0(PWData[0]), .A1(n441), .B0(RxFWrData[0]), .B1(n387), .Y(
        FIFOWdata[0]) );
  AO22X1 U291 ( .A0(PWData[1]), .A1(n441), .B0(RxFWrData[1]), .B1(n387), .Y(
        FIFOWdata[1]) );
  AO22X1 U292 ( .A0(PWData[2]), .A1(n441), .B0(RxFWrData[2]), .B1(n387), .Y(
        FIFOWdata[2]) );
  AO22X1 U293 ( .A0(PWData[3]), .A1(n441), .B0(RxFWrData[3]), .B1(n387), .Y(
        FIFOWdata[3]) );
  AO22X1 U294 ( .A0(PWData[4]), .A1(n441), .B0(RxFWrData[4]), .B1(n387), .Y(
        FIFOWdata[4]) );
  AO22X1 U295 ( .A0(PWData[5]), .A1(n441), .B0(RxFWrData[5]), .B1(n387), .Y(
        FIFOWdata[5]) );
  AO22X1 U296 ( .A0(PWData[6]), .A1(n441), .B0(RxFWrData[6]), .B1(n387), .Y(
        FIFOWdata[6]) );
  AO22X1 U297 ( .A0(PWData[7]), .A1(n441), .B0(RxFWrData[7]), .B1(n387), .Y(
        FIFOWdata[7]) );
  AO22X1 U298 ( .A0(PWData[8]), .A1(n441), .B0(RxFWrData[8]), .B1(n387), .Y(
        FIFOWdata[8]) );
  AO22X1 U299 ( .A0(PWData[9]), .A1(n441), .B0(RxFWrData[9]), .B1(n387), .Y(
        FIFOWdata[9]) );
  AO22X1 U300 ( .A0(PWData[10]), .A1(n441), .B0(RxFWrData[10]), .B1(n387), .Y(
        FIFOWdata[10]) );
  AO22X1 U301 ( .A0(PWData[11]), .A1(n441), .B0(RxFWrData[11]), .B1(n387), .Y(
        FIFOWdata[11]) );
  AO22X1 U302 ( .A0(PWData[12]), .A1(n441), .B0(RxFWrData[12]), .B1(n387), .Y(
        FIFOWdata[12]) );
  AO22X1 U303 ( .A0(PWData[13]), .A1(n441), .B0(RxFWrData[13]), .B1(n387), .Y(
        FIFOWdata[13]) );
  AO22X1 U304 ( .A0(PWData[14]), .A1(n441), .B0(RxFWrData[14]), .B1(n387), .Y(
        FIFOWdata[14]) );
  AO22X1 U305 ( .A0(PWData[15]), .A1(n441), .B0(RxFWrData[15]), .B1(n387), .Y(
        FIFOWdata[15]) );
  AO22X1 U306 ( .A0(PWData[16]), .A1(n441), .B0(RxFWrData[16]), .B1(n387), .Y(
        FIFOWdata[16]) );
  AO22X1 U307 ( .A0(PWData[17]), .A1(n441), .B0(RxFWrData[17]), .B1(n387), .Y(
        FIFOWdata[17]) );
  AO22X1 U308 ( .A0(PWData[18]), .A1(n441), .B0(RxFWrData[18]), .B1(n387), .Y(
        FIFOWdata[18]) );
  AO22X1 U309 ( .A0(PWData[19]), .A1(n441), .B0(RxFWrData[19]), .B1(n387), .Y(
        FIFOWdata[19]) );
  AO22X1 U310 ( .A0(PWData[20]), .A1(n441), .B0(RxFWrData[20]), .B1(n387), .Y(
        FIFOWdata[20]) );
  AO22X1 U311 ( .A0(PWData[21]), .A1(n441), .B0(RxFWrData[21]), .B1(n387), .Y(
        FIFOWdata[21]) );
  AO22X1 U312 ( .A0(PWData[22]), .A1(n441), .B0(RxFWrData[22]), .B1(n387), .Y(
        FIFOWdata[22]) );
  AO22X1 U313 ( .A0(PWData[23]), .A1(n441), .B0(RxFWrData[23]), .B1(n387), .Y(
        FIFOWdata[23]) );
  AO22X1 U314 ( .A0(PWData[24]), .A1(n441), .B0(RxFWrData[24]), .B1(n387), .Y(
        FIFOWdata[24]) );
  AO22X1 U315 ( .A0(PWData[25]), .A1(n441), .B0(RxFWrData[25]), .B1(n387), .Y(
        FIFOWdata[25]) );
  AO22X1 U316 ( .A0(PWData[26]), .A1(n441), .B0(RxFWrData[26]), .B1(n387), .Y(
        FIFOWdata[26]) );
  AO22X1 U317 ( .A0(PWData[27]), .A1(n441), .B0(RxFWrData[27]), .B1(n387), .Y(
        FIFOWdata[27]) );
  AO22X1 U318 ( .A0(PWData[28]), .A1(n441), .B0(RxFWrData[28]), .B1(n387), .Y(
        FIFOWdata[28]) );
  AO22X1 U319 ( .A0(PWData[29]), .A1(n441), .B0(RxFWrData[29]), .B1(n387), .Y(
        FIFOWdata[29]) );
  AO22X1 U320 ( .A0(PWData[30]), .A1(n441), .B0(RxFWrData[30]), .B1(n387), .Y(
        FIFOWdata[30]) );
  AO22X1 U321 ( .A0(PWData[31]), .A1(n441), .B0(RxFWrData[31]), .B1(n387), .Y(
        FIFOWdata[31]) );
  NOR2BX1 U322 ( .AN(FIFOFull), .B(n382), .Y(RFFull) );
  INVX1 U323 ( .A(RxActive), .Y(n382) );
  NAND2BX1 U324 ( .AN(FFCNT[0]), .B(n410), .Y(n421) );
  OA22X1 U325 ( .A0(n437), .A1(n398), .B0(n398), .B1(n399), .Y(n396) );
  INVX1 U326 ( .A(n400), .Y(n398) );
  OAI221X1 U327 ( .A0(n401), .A1(n402), .B0(n437), .B1(n399), .C0(n403), .Y(
        n400) );
  AOI221X1 U328 ( .A0(DMASize[2]), .A1(n406), .B0(n407), .B1(n408), .C0(n409), 
        .Y(n402) );
  AOI211X1 U329 ( .A0(n391), .A1(n392), .B0(SDreset), .C0(n393), .Y(DREQ323)
         );
  NAND2X1 U330 ( .A(EnDMA), .B(DatMode[1]), .Y(n393) );
  AOI32X1 U331 ( .A0(DatMode[0]), .A1(n394), .A2(n440), .B0(n426), .B1(n427), 
        .Y(n391) );
  OAI211X1 U332 ( .A0(n394), .A1(n440), .B0(DatMode[0]), .C0(n396), .Y(n392)
         );
  OAI31X1 U333 ( .A0(n404), .A1(DMASize[3]), .A2(n417), .B0(n418), .Y(n401) );
  AOI31X1 U334 ( .A0(n419), .A1(n417), .A2(n404), .B0(n420), .Y(n418) );
  OAI33X1 U335 ( .A0(n421), .A1(DMASize[2]), .A2(n413), .B0(n412), .B1(
        FFCNT[2]), .B2(DMASize[2]), .Y(n420) );
  NAND2BX1 U336 ( .AN(FFCNT[4]), .B(n405), .Y(n425) );
  NAND2BX1 U337 ( .AN(FFCNT[2]), .B(n412), .Y(n404) );
  NAND2BX1 U338 ( .AN(n441), .B(RxActive), .Y(n384) );
  NAND2BX1 U339 ( .AN(FFCNT[3]), .B(n406), .Y(n423) );
  INVX1 U340 ( .A(FFCNT[0]), .Y(n408) );
  NAND2BX1 U341 ( .AN(FFCNT[1]), .B(DMASize[1]), .Y(n416) );
  INVX1 U342 ( .A(FFCNT[1]), .Y(n410) );
  INVX1 U343 ( .A(FFCNT[2]), .Y(n413) );
  XNOR2X1 U344 ( .A(n425), .B(FIFOFull), .Y(n440) );
  INVX1 U345 ( .A(FFCNT[3]), .Y(n417) );
  INVX1 U346 ( .A(DMASize[3]), .Y(n419) );
  AOI222X1 U347 ( .A0(n434), .A1(n435), .B0(FFCNT[3]), .B1(n419), .C0(FFCNT[2]), .C1(n414), .Y(n428) );
  OA21X2 U348 ( .A0(FFCNT[2]), .A1(n414), .B0(n416), .Y(n434) );
  OAI211X1 U349 ( .A0(DMASize[1]), .A1(n410), .B0(DMASize[0]), .C0(n408), .Y(
        n435) );
  OAI221X1 U350 ( .A0(FFCNT[1]), .A1(n415), .B0(n411), .B1(n415), .C0(n416), 
        .Y(n407) );
  INVX1 U351 ( .A(DMASize[0]), .Y(n415) );
  OAI31X1 U352 ( .A0(n428), .A1(n429), .A2(n430), .B0(n431), .Y(n426) );
  AO22X1 U353 ( .A0(DMASize[4]), .A1(n433), .B0(DMASize[3]), .B1(n417), .Y(
        n430) );
  INVX1 U354 ( .A(n432), .Y(n429) );
  AOI32X1 U355 ( .A0(FFCNT[4]), .A1(n399), .A2(n432), .B0(FIFOFull), .B1(n394), 
        .Y(n431) );
  AOI32X1 U356 ( .A0(DMASize[3]), .A1(FFCNT[3]), .A2(n404), .B0(DMASize[3]), 
        .B1(n405), .Y(n403) );
  INVX1 U357 ( .A(DMASize[2]), .Y(n414) );
  INVX1 U358 ( .A(DMASize[1]), .Y(n411) );
  INVX1 U359 ( .A(n425), .Y(n424) );
  NAND2BX1 U360 ( .AN(FIFOFull), .B(DMASize[5]), .Y(n432) );
  NOR2BX1 U361 ( .AN(RxActive), .B(FIFOReadEmpty), .Y(RFDET) );
  INVX1 U362 ( .A(DatMode[0]), .Y(n427) );
  INVX1 U363 ( .A(FFCNT[4]), .Y(n433) );
  INVX1 U364 ( .A(DMASize[5]), .Y(n394) );
  INVX1 U365 ( .A(DMASize[4]), .Y(n399) );
  NOR2BX1 U366 ( .AN(TxRdPtrInc), .B(SDreset), .Y(dTxRdPtrInc164) );
  NOR2BX1 U367 ( .AN(RxWriteEn), .B(SDreset), .Y(dRxWriteEn158) );
  INVX1 U368 ( .A(FIFOFull), .Y(n378) );
  DFFRX1 dRxWriteEn_reg ( .D(dRxWriteEn158), .CK(PCLK), .RN(PRESETn), .Q(
        dRxWriteEn), .QN(n438) );
  DFFRX1 dTxRdPtrInc_reg ( .D(dTxRdPtrInc164), .CK(PCLK), .RN(PRESETn), .Q(
        dTxRdPtrInc), .QN(n439) );
endmodule


module mmc_Fifo_FIFO_AW5 ( Clk, nRST, SDreset, FIFOWrite, FIFOWrData, FIFORead, 
        FIFORdData, FIFOFlush, FIFOFull, FIFOHalfFull, FIFOHalfEmpty, 
        FIFOAlmostEmpty, FIFOEmpty, FIFOReadEmpty, DatCnt );
  input [31:0] FIFOWrData;
  output [31:0] FIFORdData;
  output [4:0] DatCnt;
  input Clk, nRST, SDreset, FIFOWrite, FIFORead, FIFOFlush;
  output FIFOFull, FIFOHalfFull, FIFOHalfEmpty, FIFOAlmostEmpty, FIFOEmpty,
         FIFOReadEmpty;
  wire   WriteAllow, n_2, n76;
  wire   [4:0] ReadAddr;
  wire   [4:0] WriteAddr;

  RF2SH32x32 FIFORAM ( .CENB(n_2), .AB(WriteAddr), .DB(FIFOWrData), .CENA(
        FIFOEmpty), .AA(ReadAddr), .CLKB(Clk), .CLKA(Clk), .QA(FIFORdData) );
  mmc_FIFOCtl_AW5 mmc_IntFIFOCtl ( .Clki(Clk), .ReadEni(FIFORead), .WriteEni(
        FIFOWrite), .nRST(nRST), .Flushi(n76), .Fullo(FIFOFull), 
        .FIFOHalfFull(FIFOHalfFull), .FIFOHalfEmpty(FIFOHalfEmpty), .DatCnto(
        DatCnt), .AlmostEmptyo(FIFOAlmostEmpty), .Emptyo(FIFOEmpty), 
        .ReadEmptyo(FIFOReadEmpty), .WriteAddro(WriteAddr), .ReadAddro(
        ReadAddr), .WriteAllowo(WriteAllow) );
  INVX1 U9 ( .A(WriteAllow), .Y(n_2) );
  OR2X1 U10 ( .A(FIFOFlush), .B(SDreset), .Y(n76) );
endmodule


module mmc_FIFOCtl_AW5 ( Clki, ReadEni, WriteEni, nRST, Flushi, Fullo, 
        FIFOHalfFull, FIFOHalfEmpty, DatCnto, AlmostEmptyo, Emptyo, ReadEmptyo, 
        WriteAddro, ReadAddro, ReadAllowo, WriteAllowo );
  output [4:0] DatCnto;
  output [4:0] WriteAddro;
  output [4:0] ReadAddro;
  input Clki, ReadEni, WriteEni, nRST, Flushi;
  output Fullo, FIFOHalfFull, FIFOHalfEmpty, AlmostEmptyo, Emptyo, ReadEmptyo,
         ReadAllowo, WriteAllowo;
  wire   DEmpty, DAEmpty1, DAEmpty2, RdAddrPlusOne164_3_, RdAddrPlusOne164_2_,
         RdAddrPlusOne164_1_, RdAddrPlusOne165_3_, RdAddrPlusOne165_2_,
         RdAddrPlusOne165_1_, DAEmpty1433, DatCnt579_5_, DatCnt579_4_,
         DatCnt579_3_, DatCnt579_2_, DatCnt579_1_, DatCnt583_4_, DatCnt583_3_,
         DatCnt583_2_, DatCnt583_1_, n704, n705, n707, n757, n758, n759, n760,
         n761, n762, n763, n764, n765, n766, n767, n768, n769, n770, n771,
         n772, n773, n774, n775, n776, n777, carry, carry0, n12, n22, n32,
         carry1, carry2, n11, n21, n31, carry_5_, carry3, carry4, carry5,
         carry_4_, carry_3_, carry_2_, n1, n2, n3, n4, n780, n781, n783, n784,
         n786, n787, n800, n801, n802, n803, n804, n805, n806, n807, n808,
         n810, n811, n812, n813, n814, n815, n816, n817, n818, n820, n821,
         n822, n823, n824, n825, n828, n829, n830, n831, n832, n833, n834,
         n835, n836, n837, n838, n839, n840, n841, n842, n843, n844, n845,
         n846, n847, n848, n849, n850, n851, n852, n853, n854;
  wire   [4:0] RdAddr;
  wire   [4:0] RdAddrPlusOne;

  AHHCONX2 U1_1_12 ( .A(WriteAddro[1]), .CI(WriteAddro[0]), .S(
        RdAddrPlusOne164_1_), .CON(n32) );
  AHHCONX2 U1_1_22 ( .A(WriteAddro[2]), .CI(carry0), .S(RdAddrPlusOne164_2_), 
        .CON(n22) );
  AHHCONX2 U1_1_32 ( .A(WriteAddro[3]), .CI(carry), .S(RdAddrPlusOne164_3_), 
        .CON(n12) );
  AHHCONX2 U1_1_11 ( .A(RdAddrPlusOne[1]), .CI(RdAddrPlusOne[0]), .S(
        RdAddrPlusOne165_1_), .CON(n31) );
  AHHCONX2 U1_1_21 ( .A(RdAddrPlusOne[2]), .CI(carry2), .S(RdAddrPlusOne165_2_), .CON(n21) );
  AHHCONX2 U1_1_31 ( .A(RdAddrPlusOne[3]), .CI(carry1), .S(RdAddrPlusOne165_3_), .CON(n11) );
  AHHCONX2 U1_1_1 ( .A(DatCnto[1]), .CI(DatCnto[0]), .S(DatCnt583_1_), .CON(n4) );
  AHHCONX2 U1_1_2 ( .A(DatCnto[2]), .CI(carry_2_), .S(DatCnt583_2_), .CON(n3)
         );
  AHHCONX2 U1_1_3 ( .A(DatCnto[3]), .CI(carry_3_), .S(DatCnt583_3_), .CON(n2)
         );
  AHHCONX2 U1_1_4 ( .A(DatCnto[4]), .CI(carry_4_), .S(DatCnt583_4_), .CON(n1)
         );
  NAND2BX4 U362 ( .AN(Flushi), .B(n822), .Y(n808) );
  NAND2BX4 U395 ( .AN(Flushi), .B(n822), .Y(n832) );
  INVX3 U396 ( .A(n808), .Y(n814) );
  BUFX8 U397 ( .A(n821), .Y(n854) );
  NAND2BX4 U398 ( .AN(Flushi), .B(n784), .Y(n787) );
  NAND2BX4 U399 ( .AN(Flushi), .B(n854), .Y(n784) );
  NAND2BX2 U400 ( .AN(Emptyo), .B(ReadEni), .Y(n821) );
  OAI221X1 U401 ( .A0(n808), .A1(n845), .B0(n1), .B1(n811), .C0(n820), .Y(n757) );
  OAI222X1 U402 ( .A0(n808), .A1(n846), .B0(DatCnto[0]), .B1(n852), .C0(
        DatCnto[0]), .C1(n811), .Y(n762) );
  DFFRX1 DatCnt_reg_0_ ( .D(n762), .CK(Clki), .RN(nRST), .Q(DatCnto[0]), .QN(
        n846) );
  DFFRX1 WrAddr_reg_4_ ( .D(n773), .CK(Clki), .RN(nRST), .Q(WriteAddro[4]), 
        .QN(n833) );
  DFFRX1 WrAddr_reg_0_ ( .D(n777), .CK(Clki), .RN(nRST), .Q(WriteAddro[0]), 
        .QN(n840) );
  DFFRX1 WrAddr_reg_3_ ( .D(n774), .CK(Clki), .RN(nRST), .Q(WriteAddro[3]), 
        .QN(n841) );
  DFFRX1 WrAddr_reg_2_ ( .D(n775), .CK(Clki), .RN(nRST), .Q(WriteAddro[2]), 
        .QN(n842) );
  DFFSX1 WrAddr_reg_1_ ( .D(n776), .CK(Clki), .SN(nRST), .Q(WriteAddro[1]), 
        .QN(n843) );
  NAND3BX1 U403 ( .AN(Flushi), .B(ReadAllowo), .C(n808), .Y(n852) );
  BUFX2 U404 ( .A(n780), .Y(n853) );
  NAND2BX4 U405 ( .AN(Fullo), .B(WriteEni), .Y(n780) );
  INVX1 U406 ( .A(n811), .Y(n812) );
  INVX1 U407 ( .A(n853), .Y(WriteAllowo) );
  XNOR2X4 U408 ( .A(n854), .B(n780), .Y(n822) );
  NAND2BX1 U409 ( .AN(n784), .B(n808), .Y(n811) );
  NAND3BX2 U410 ( .AN(Flushi), .B(ReadAllowo), .C(n832), .Y(n810) );
  INVX1 U411 ( .A(n784), .Y(n802) );
  INVX1 U412 ( .A(n810), .Y(n815) );
  INVX3 U413 ( .A(n787), .Y(n800) );
  INVX1 U414 ( .A(n854), .Y(ReadAllowo) );
  XOR2X1 U415 ( .A(n840), .B(n853), .Y(n777) );
  DFFRX1 DatCnt_reg_5_ ( .D(n757), .CK(Clki), .RN(nRST), .Q(Fullo), .QN(n845)
         );
  DFFRX1 DatCnt_reg_2_ ( .D(n760), .CK(Clki), .RN(nRST), .Q(DatCnto[2]), .QN(
        n838) );
  DFFRX1 DatCnt_reg_1_ ( .D(n761), .CK(Clki), .RN(nRST), .Q(DatCnto[1]), .QN(
        n844) );
  INVX1 U416 ( .A(n824), .Y(Emptyo) );
  INVX1 U417 ( .A(FIFOHalfFull), .Y(FIFOHalfEmpty) );
  INVX1 U418 ( .A(n12), .Y(n783) );
  INVX1 U419 ( .A(Flushi), .Y(n786) );
  NAND2BX1 U420 ( .AN(n852), .B(DatCnt579_5_), .Y(n820) );
  XNOR2X1 U1_A_5 ( .A(Fullo), .B(carry_5_), .Y(DatCnt579_5_) );
  OR2X1 U1_B_4 ( .A(DatCnto[4]), .B(carry3), .Y(carry_5_) );
  AOI33X1 U421 ( .A0(n12), .A1(WriteAddro[4]), .A2(Flushi), .B0(n833), .B1(
        n783), .B2(Flushi), .Y(n805) );
  INVX1 U422 ( .A(n11), .Y(n807) );
  NOR2BX1 U423 ( .AN(AlmostEmptyo), .B(n854), .Y(DAEmpty1433) );
  INVX1 U424 ( .A(n828), .Y(AlmostEmptyo) );
  NAND3BX1 U425 ( .AN(n829), .B(FIFOHalfEmpty), .C(DatCnto[0]), .Y(n828) );
  NAND3BX1 U426 ( .AN(DatCnto[3]), .B(n838), .C(n844), .Y(n829) );
  AO22X1 U427 ( .A0(RdAddr[0]), .A1(n854), .B0(ReadAllowo), .B1(
        RdAddrPlusOne[0]), .Y(ReadAddro[0]) );
  AO22X1 U428 ( .A0(RdAddr[1]), .A1(n854), .B0(ReadAllowo), .B1(
        RdAddrPlusOne[1]), .Y(ReadAddro[1]) );
  AO22X1 U429 ( .A0(RdAddr[2]), .A1(n854), .B0(ReadAllowo), .B1(
        RdAddrPlusOne[2]), .Y(ReadAddro[2]) );
  AO22X1 U430 ( .A0(RdAddr[3]), .A1(n854), .B0(ReadAllowo), .B1(
        RdAddrPlusOne[3]), .Y(ReadAddro[3]) );
  AO22X1 U431 ( .A0(RdAddr[4]), .A1(n854), .B0(ReadAllowo), .B1(
        RdAddrPlusOne[4]), .Y(ReadAddro[4]) );
  OAI222X1 U432 ( .A0(n834), .A1(n784), .B0(WriteAddro[0]), .B1(n786), .C0(
        RdAddrPlusOne[0]), .C1(n787), .Y(n767) );
  OAI222X1 U433 ( .A0(n784), .A1(n851), .B0(n843), .B1(n786), .C0(n787), .C1(
        n837), .Y(n771) );
  AO22X1 U434 ( .A0(WriteAddro[1]), .A1(n853), .B0(RdAddrPlusOne164_1_), .B1(
        WriteAllowo), .Y(n776) );
  OAI222X1 U435 ( .A0(n784), .A1(n847), .B0(n833), .B1(n786), .C0(n787), .C1(
        n839), .Y(n768) );
  OAI222X1 U436 ( .A0(n784), .A1(n848), .B0(n841), .B1(n786), .C0(n787), .C1(
        n835), .Y(n769) );
  OAI222X1 U437 ( .A0(n784), .A1(n849), .B0(n842), .B1(n786), .C0(n787), .C1(
        n836), .Y(n770) );
  OAI222X1 U438 ( .A0(n784), .A1(n850), .B0(n840), .B1(n786), .C0(n787), .C1(
        n834), .Y(n772) );
  AO22X1 U439 ( .A0(WriteAddro[3]), .A1(n853), .B0(RdAddrPlusOne164_3_), .B1(
        WriteAllowo), .Y(n774) );
  AO22X1 U440 ( .A0(WriteAddro[2]), .A1(n853), .B0(RdAddrPlusOne164_2_), .B1(
        WriteAllowo), .Y(n775) );
  AO21X1 U441 ( .A0(RdAddrPlusOne165_1_), .A1(n800), .B0(n801), .Y(n766) );
  AO22X1 U442 ( .A0(RdAddrPlusOne[1]), .A1(n802), .B0(Flushi), .B1(
        RdAddrPlusOne164_1_), .Y(n801) );
  AO21X1 U443 ( .A0(RdAddrPlusOne165_3_), .A1(n800), .B0(n804), .Y(n764) );
  AO22X1 U444 ( .A0(RdAddrPlusOne[3]), .A1(n802), .B0(Flushi), .B1(
        RdAddrPlusOne164_3_), .Y(n804) );
  AO21X1 U445 ( .A0(RdAddrPlusOne165_2_), .A1(n800), .B0(n803), .Y(n765) );
  AO22X1 U446 ( .A0(RdAddrPlusOne[2]), .A1(n802), .B0(Flushi), .B1(
        RdAddrPlusOne164_2_), .Y(n803) );
  AO21X1 U447 ( .A0(DatCnt583_4_), .A1(n812), .B0(n818), .Y(n758) );
  AO22X1 U448 ( .A0(DatCnto[4]), .A1(n814), .B0(DatCnt579_4_), .B1(n815), .Y(
        n818) );
  XNOR2X1 U1_A_4 ( .A(DatCnto[4]), .B(carry3), .Y(DatCnt579_4_) );
  AO21X1 U449 ( .A0(DatCnt583_3_), .A1(n812), .B0(n817), .Y(n759) );
  AO22X1 U450 ( .A0(DatCnto[3]), .A1(n814), .B0(DatCnt579_3_), .B1(n815), .Y(
        n817) );
  XNOR2X1 U1_A_3 ( .A(DatCnto[3]), .B(carry4), .Y(DatCnt579_3_) );
  AO21X1 U451 ( .A0(DatCnt583_2_), .A1(n812), .B0(n816), .Y(n760) );
  AO22X1 U452 ( .A0(DatCnto[2]), .A1(n814), .B0(DatCnt579_2_), .B1(n815), .Y(
        n816) );
  XNOR2X1 U1_A_2 ( .A(DatCnto[2]), .B(carry5), .Y(DatCnt579_2_) );
  AO21X1 U453 ( .A0(DatCnt583_1_), .A1(n812), .B0(n813), .Y(n761) );
  AO22X1 U454 ( .A0(DatCnto[1]), .A1(n814), .B0(DatCnt579_1_), .B1(n815), .Y(
        n813) );
  XNOR2X1 U1_A_1 ( .A(DatCnto[1]), .B(DatCnto[0]), .Y(DatCnt579_1_) );
  OAI31X1 U455 ( .A0(n853), .A1(n12), .A2(WriteAddro[4]), .B0(n781), .Y(n773)
         );
  OA22X1 U456 ( .A0(n833), .A1(n783), .B0(WriteAllowo), .B1(n833), .Y(n781) );
  NAND3BX1 U457 ( .AN(n825), .B(n846), .C(FIFOHalfEmpty), .Y(n824) );
  NAND3BX1 U458 ( .AN(DatCnto[3]), .B(n838), .C(n844), .Y(n825) );
  NAND2BX1 U459 ( .AN(DatCnto[4]), .B(n845), .Y(FIFOHalfFull) );
  INVX1 U460 ( .A(n21), .Y(carry1) );
  NAND4BX1 U461 ( .AN(n823), .B(n704), .C(n705), .D(n824), .Y(ReadEmptyo) );
  NAND3BX1 U462 ( .AN(n830), .B(n831), .C(n707), .Y(n823) );
  INVX1 U463 ( .A(n4), .Y(carry_2_) );
  INVX1 U464 ( .A(n3), .Y(carry_3_) );
  INVX1 U465 ( .A(n31), .Y(carry2) );
  INVX1 U466 ( .A(n2), .Y(carry_4_) );
  OR2X1 U1_B_1 ( .A(DatCnto[1]), .B(DatCnto[0]), .Y(carry5) );
  OR2X1 U1_B_2 ( .A(DatCnto[2]), .B(carry5), .Y(carry4) );
  OR2X1 U1_B_3 ( .A(DatCnto[3]), .B(carry4), .Y(carry3) );
  INVX1 U467 ( .A(n32), .Y(carry0) );
  INVX1 U468 ( .A(n22), .Y(carry) );
  DFFRX1 DatCnt_reg_3_ ( .D(n759), .CK(Clki), .RN(nRST), .Q(DatCnto[3]) );
  DFFRX1 DatCnt_reg_4_ ( .D(n758), .CK(Clki), .RN(nRST), .Q(DatCnto[4]) );
  DFFSX1 RdAddrPlusOne_reg_0_ ( .D(n767), .CK(Clki), .SN(nRST), .Q(
        RdAddrPlusOne[0]), .QN(n834) );
  DFFSX1 RdAddrPlusOne_reg_1_ ( .D(n766), .CK(Clki), .SN(nRST), .Q(
        RdAddrPlusOne[1]), .QN(n837) );
  DFFRX1 RdAddrPlusOne_reg_3_ ( .D(n764), .CK(Clki), .RN(nRST), .Q(
        RdAddrPlusOne[3]), .QN(n835) );
  DFFRX1 RdAddrPlusOne_reg_2_ ( .D(n765), .CK(Clki), .RN(nRST), .Q(
        RdAddrPlusOne[2]), .QN(n836) );
  DFFSX1 DAEmpty1_reg ( .D(DAEmpty1433), .CK(Clki), .SN(nRST), .Q(DAEmpty1), 
        .QN(n705) );
  DFFSX1 DAEmpty2_reg ( .D(DAEmpty1), .CK(Clki), .SN(nRST), .Q(DAEmpty2), .QN(
        n704) );
  DFFSX1 DEmpty_reg ( .D(Emptyo), .CK(Clki), .SN(nRST), .Q(DEmpty), .QN(n707)
         );
  DFFSX1 DEmpty1_reg ( .D(DEmpty), .CK(Clki), .SN(nRST), .QN(n831) );
  DFFSX1 DAEmpty_reg ( .D(DAEmpty2), .CK(Clki), .SN(nRST), .Q(n830) );
  DFFSX1 RdAddr_reg_1_ ( .D(n771), .CK(Clki), .SN(nRST), .Q(RdAddr[1]), .QN(
        n851) );
  DFFRX1 RdAddrPlusOne_reg_4_ ( .D(n763), .CK(Clki), .RN(nRST), .Q(
        RdAddrPlusOne[4]), .QN(n839) );
  DFFRX1 RdAddr_reg_4_ ( .D(n768), .CK(Clki), .RN(nRST), .Q(RdAddr[4]), .QN(
        n847) );
  DFFRX1 RdAddr_reg_3_ ( .D(n769), .CK(Clki), .RN(nRST), .Q(RdAddr[3]), .QN(
        n848) );
  DFFRX1 RdAddr_reg_2_ ( .D(n770), .CK(Clki), .RN(nRST), .Q(RdAddr[2]), .QN(
        n849) );
  DFFRX1 RdAddr_reg_0_ ( .D(n772), .CK(Clki), .RN(nRST), .Q(RdAddr[0]), .QN(
        n850) );
  AOI33X1 U469 ( .A0(n839), .A1(n807), .A2(n800), .B0(RdAddrPlusOne[4]), .B1(
        n11), .B2(n800), .Y(n806) );
  OAI211X1 U470 ( .A0(n784), .A1(n839), .B0(n805), .C0(n806), .Y(n763) );
endmodule


module mmc_APBRegisterIF ( PCLK, PRESETn, PSEL, PENABLE, PWRITE, PADDR, PWDATA, 
        PRDATA, SDreset, ENCLK, PSAVEON, iSDIPRE, CmdArg, iSDICmdCon, CMST, 
        CMSTClr, RspCrcSet, CmdSentSet, CmdToutSet, RspFinSet, CmdOn, RspIndex, 
        Response0, Response1, Response2, Response3, iDataTimer, iBlkSize, 
        iSDIDatCon, DTST, DTSTClr, BlkNumCnt, BlkCnt, NoBusySet, CrcStaSet, 
        DatCrcSet, DatToutSet, DatFinSet, BusyFinSet, TxDatOn, RxDatOn, FRST, 
        FFfailSet, TFDET, RFDET, TFHalf, TFEmpty, RFFull, RFHalf, FFCNT, 
        TxWriteEn, RxRdPtrInc, FIFOdata, DelaySel, InvSel, RCmdStart, 
        RCmdStartClr, iAutoReadCon, ErrorState, ResponseCMD18, 
        AutoReadComplete, MMC_INT );
  input [6:2] PADDR;
  input [31:0] PWDATA;
  output [31:0] PRDATA;
  output [7:0] iSDIPRE;
  output [31:0] CmdArg;
  output [12:0] iSDICmdCon;
  input [7:0] RspIndex;
  input [31:0] Response0;
  input [31:0] Response1;
  input [31:0] Response2;
  input [31:0] Response3;
  output [22:0] iDataTimer;
  output [15:0] iBlkSize;
  output [30:0] iSDIDatCon;
  input [15:0] BlkNumCnt;
  input [15:0] BlkCnt;
  input [4:0] FFCNT;
  input [31:0] FIFOdata;
  output [2:0] DelaySel;
  output [1:0] iAutoReadCon;
  input [1:0] ErrorState;
  input [31:0] ResponseCMD18;
  input PCLK, PRESETn, PSEL, PENABLE, PWRITE, CMSTClr, RspCrcSet, CmdSentSet,
         CmdToutSet, RspFinSet, CmdOn, DTSTClr, NoBusySet, CrcStaSet,
         DatCrcSet, DatToutSet, DatFinSet, BusyFinSet, TxDatOn, RxDatOn,
         FFfailSet, TFDET, RFDET, TFHalf, TFEmpty, RFFull, RFHalf,
         RCmdStartClr, AutoReadComplete;
  output SDreset, ENCLK, PSAVEON, CMST, DTST, FRST, TxWriteEn, RxRdPtrInc,
         InvSel, RCmdStart, MMC_INT;
  wire   RspCrc, CmdSent, CmdTout, RspFin, NoBusy, CrcSta, DatCrc, DatTout,
         DatFin, BusyFin, FFfail, R18Error, R12Error, AutoCMDComplete,
         AutoCMDCompleteInt, R12ErrorInt, R18ErrorInt, NoBusyInt, RspCrcInt,
         CmdSentInt, CmdToutInt, RspFinInt, FFfailInt, CrcStaInt, DatCrcInt,
         DatToutInt, DatFinInt, BusyFinInt, TFHalfInt, TFEmpInt, RFFullInt,
         RFHalfInt, SDreset2925, CMSTSet3211, FRST3958, RCmdStartSet4533,
         n5589, n5593, n5594, n5595, n5596, n5597, n5598, n5599, n5600, n5601,
         n5602, n5603, n5604, n5605, n5606, n5607, n5608, n5609, n5610, n5611,
         n5612, n5613, n5614, n5615, n5616, n5617, n5618, n5619, n5620, n5621,
         n5622, n5623, n5624, n5625, n5626, n5627, n5628, n5629, n5630, n5631,
         n5632, n5633, n5634, n5635, n5636, n5637, n5638, n5639, n5640, n5641,
         n5642, n5643, n5644, n5645, n5646, n5647, n5648, n5649, n5650, n5651,
         n5652, n5653, n5654, n5655, n5656, n5657, n5658, n5659, n5660, n5661,
         n5662, n5663, n5664, n5665, n5666, n5667, n5668, n5669, n5670, n5671,
         n5672, n5673, n5674, n5675, n5676, n5677, n5678, n5679, n5680, n5681,
         n5682, n5683, n5684, n5685, n5686, n5687, n5688, n5689, n5690, n5691,
         n5692, n5693, n5694, n5695, n5696, n5697, n5698, n5699, n5700, n5701,
         n5702, n5703, n5704, n5705, n5706, n5707, n5708, n5709, n5710, n5711,
         n5712, n5713, n5714, n5715, n5716, n5717, n5718, n5719, n5720, n5721,
         n5722, n5723, n5724, n5725, n5726, n5727, n5728, n5729, n5730, n5731,
         n5732, n5733, n5734, n5735, n5736, n5737, n5738, n5739, n5740, n5741,
         n5742, n5743, n5744, n5745, n5746, n5747, n5748, n5749, n5750, n5751,
         n5752, n5753, n5754, n5755, n5756, n5757, n5758, n5759, n5760, n5761,
         n5762, n5763, n5764, n5765, n5766, n5767, n5768, n5769, n5770, n5771,
         n5772, n5773, n5774, n5775, n5776, n5777, n5778, n5779, n5780, n5781,
         n5782, n5783, n5784, n5785, n5786, n5787, n5788, n5789, n5790, n5791,
         n5792, n5793, n5794, n5795, n5796, n5797, n5798, n5799, n5800, n5801,
         n5802, n5803, n5804, n5805, n5816, n5820, n5821, n5826, n5828, n5829,
         n5830, n5831, n5832, n5833, n5834, n5835, n5836, n5837, n5838, n5839,
         n5840, n5841, n5842, n5843, n5844, n5845, n5846, n5847, n5849, n5850,
         n5852, n5853, n5854, n5855, n5856, n5857, n5858, n5859, n5860, n5861,
         n5862, n5863, n5864, n5865, n5866, n5867, n5868, n5869, n5870, n5871,
         n5872, n5873, n5874, n5875, n5876, n5878, n5880, n5881, n5882, n5883,
         n5885, n5886, n5887, n5889, n5890, n5892, n5893, n5894, n5895, n5897,
         n5898, n5899, n5901, n5902, n5903, n5905, n5906, n5908, n5909, n5910,
         n5911, n5913, n5914, n5915, n5917, n5918, n5919, n5920, n5921, n5922,
         n5923, n5924, n5925, n5926, n5927, n5928, n5929, n5930, n5931, n5932,
         n5933, n5934, n5935, n5936, n5938, n5940, n5941, n5942, n5943, n5944,
         n5945, n5946, n5947, n5948, n5949, n5950, n5951, n5953, n5954, n5955,
         n5956, n5957, n5959, n5960, n5962, n5963, n5964, n5965, n5966, n5967,
         n5968, n5969, n5971, n5973, n5974, n5975, n5976, n5977, n5979, n5980,
         n5981, n5982, n5983, n5984, n5985, n5987, n5988, n5990, n5991, n5992,
         n5993, n5995, n5996, n5997, n5998, n5999, n6000, n6001, n6002, n6004,
         n6006, n6007, n6008, n6009, n6010, n6012, n6013, n6015, n6016, n6017,
         n6018, n6019, n6020, n6021, n6022, n6023, n6024, n6025, n6026, n6027,
         n6028, n6031, n6032, n6034, n6035, n6036, n6037, n6038, n6039, n6040,
         n6044, n6045, n6047, n6048, n6049, n6050, n6051, n6052, n6053, n6056,
         n6057, n6058, n6060, n6062, n6063, n6064, n6065, n6066, n6068, n6069,
         n6070, n6071, n6072, n6073, n6074, n6075, n6076, n6077, n6078, n6079,
         n6080, n6081, n6082, n6083, n6084, n6085, n6086, n6087, n6088, n6092,
         n6093, n6094, n6095, n6096, n6097, n6098, n6099, n6100, n6104, n6105,
         n6107, n6108, n6109, n6110, n6111, n6112, n6113, n6116, n6117, n6118,
         n6119, n6120, n6121, n6122, n6123, n6124, n6125, n6126, n6127, n6128,
         n6129, n6130, n6131, n6132, n6133, n6134, n6135, n6136, n6137, n6138,
         n6139, n6140, n6141, n6142, n6143, n6144, n6147, n6148, n6149, n6151,
         n6152, n6153, n6154, n6155, n6156, n6157, n6158, n6159, n6160, n6161,
         n6162, n6163, n6164, n6165, n6166, n6167, n6168, n6169, n6170, n6171,
         n6172, n6173, n6174, n6175, n6176, n6177, n6178, n6179, n6180, n6181,
         n6182, n6183, n6184, n6185, n6186, n6187, n6188, n6189, n6190, n6191,
         n6192, n6193, n6194, n6195, n6196, n6197, n6198, n6199, n6200, n6201,
         n6202, n6203, n6204, n6205, n6206, n6207, n6208, n6209, n6210, n6211,
         n6212, n6213, n6214, n6215, n6216, n6217, n6218, n6219, n6220, n6221,
         n6222, n6223, n6224, n6225, n6226, n6227, n6228, n6229, n6230, n6231,
         n6232, n6233, n6234, n6235, n6236, n6237, n6238, n6239, n6240, n6241,
         n6242, n6243, n6244, n6245, n6246, n6247, n6248, n6249, n6251, n6252,
         n6254, n6255, n6256, n6257, n6258, n6260, n6261, n6263, n6264, n6265,
         n6266, n6267, n6268, n6273, n6274, n6275, n6276, n6278, n6279, n6281,
         n6282, n6283, n6284, n6285, n6287, n6288, n6289, n6290, n6291, n6292,
         n6293, n6294, n6295, n6296, n6297, n6298, n6299, n6300, n6301, n6302,
         n6303, n6304, n6305, n6306, n6308, n6309, n6311, n6313, n6314, n6316,
         n6317, n6318, n6319, n6320, n6322, n6323, n6325, n6329, n6330, n6331,
         n6332, n6333, n6334, n6335, n6336, n6337, n6338, n6339, n6340, n6341,
         n6342, n6343, n6344, n6345, n6346, n6347, n6348, n6349, n6350, n6351,
         n6352, n6353, n6354, n6355, n6356, n6357, n6358, n6359, n6360, n6361,
         n6362, n6363, n6364, n6365, n6366, n6367, n6368, n6369, n6370, n6371,
         n6372, n6373, n6374, n6375, n6376, n6377, n6378, n6379, n6380, n6381,
         n6382, n6383, n6384, n6385, n6386, n6387, n6388, n6389, n6390, n6391,
         n6392, n6393, n6394, n6395, n6396, n6397, n6398, n6399, n6400;

  NAND3BX4 U2976 ( .AN(n5955), .B(n6136), .C(n6135), .Y(n6265) );
  NAND2BX2 U3178 ( .AN(PADDR[3]), .B(PADDR[2]), .Y(n5875) );
  INVX3 U3179 ( .A(n6244), .Y(n5943) );
  INVX3 U3180 ( .A(n5988), .Y(n5942) );
  INVX3 U3181 ( .A(n6241), .Y(n5933) );
  INVX3 U3182 ( .A(n6240), .Y(n5941) );
  INVX3 U3183 ( .A(n6314), .Y(n6257) );
  AND2X6 U3184 ( .A(n6384), .B(n6391), .Y(n6390) );
  NOR3X8 U3185 ( .A(n6382), .B(PWRITE), .C(PENABLE), .Y(n6384) );
  NAND2BX2 U3186 ( .AN(n5875), .B(n6252), .Y(n6256) );
  INVX2 U3187 ( .A(n6313), .Y(n6252) );
  INVX20 U3188 ( .A(PSEL), .Y(n6382) );
  AND2X8 U3189 ( .A(PSEL), .B(PWRITE), .Y(n6398) );
  NAND2BX1 U3190 ( .AN(n6251), .B(n6254), .Y(n5988) );
  NAND2BX2 U3191 ( .AN(n6389), .B(n6397), .Y(n5962) );
  INVX1 U3192 ( .A(n6195), .Y(n5953) );
  OR4X4 U3193 ( .A(n6245), .B(n6246), .C(n6247), .D(n6248), .Y(n6140) );
  NAND3BX1 U3194 ( .AN(n6260), .B(n6240), .C(n5988), .Y(n6246) );
  NAND2BX2 U3195 ( .AN(n6251), .B(n6397), .Y(n6136) );
  NAND2BX1 U3196 ( .AN(PADDR[4]), .B(n6257), .Y(n6313) );
  INVX1 U3197 ( .A(n6261), .Y(n6254) );
  NAND3BX1 U3198 ( .AN(PADDR[4]), .B(PADDR[5]), .C(n6390), .Y(n6261) );
  NAND3BX1 U3199 ( .AN(n6395), .B(n5936), .C(n6195), .Y(n6255) );
  NAND3BX1 U3200 ( .AN(PADDR[5]), .B(n5850), .C(n6398), .Y(n6276) );
  INVX3 U3201 ( .A(PADDR[6]), .Y(n6391) );
  INVX1 U3202 ( .A(n6276), .Y(n6309) );
  INVX3 U3203 ( .A(n6268), .Y(n5955) );
  INVX6 U3204 ( .A(n6256), .Y(RxRdPtrInc) );
  NAND4BX1 U3205 ( .AN(n5926), .B(n5927), .C(n5928), .D(n5929), .Y(n5925) );
  AO21X1 U3206 ( .A0(PRDATA[2]), .A1(n5924), .B0(n5979), .Y(n5701) );
  NAND4BX1 U3207 ( .AN(n5980), .B(n5981), .C(n5982), .D(n5983), .Y(n5979) );
  AO21X1 U3208 ( .A0(PRDATA[1]), .A1(n5924), .B0(n5963), .Y(n5702) );
  AO21X1 U3209 ( .A0(PRDATA[11]), .A1(n5924), .B0(n6095), .Y(n5692) );
  AND3X2 U3210 ( .A(n6157), .B(n6156), .C(n6386), .Y(n6153) );
  AO21X1 U3211 ( .A0(PRDATA[8]), .A1(n5924), .B0(n6393), .Y(n5695) );
  AO21X1 U3212 ( .A0(PRDATA[4]), .A1(n5924), .B0(n6392), .Y(n5699) );
  DFFRX1 PRDATA_reg_0_ ( .D(n5703), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[0]) );
  DFFRX1 PRDATA_reg_2_ ( .D(n5701), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[2]) );
  DFFRX1 PRDATA_reg_18_ ( .D(n5685), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[18])
         );
  DFFRX1 PRDATA_reg_17_ ( .D(n5686), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[17])
         );
  DFFRX1 PRDATA_reg_1_ ( .D(n5702), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[1]) );
  AO21X1 U3213 ( .A0(n5886), .A1(n5887), .B0(SDreset), .Y(n6335) );
  AOI22X1 U3214 ( .A0(PWDATA[16]), .A1(n5820), .B0(PWDATA[0]), .B1(n5821), .Y(
        n6354) );
  AOI22X1 U3215 ( .A0(PWDATA[17]), .A1(n5820), .B0(PWDATA[1]), .B1(n5821), .Y(
        n6355) );
  AOI22X1 U3216 ( .A0(PWDATA[18]), .A1(n5820), .B0(PWDATA[2]), .B1(n5821), .Y(
        n6356) );
  AO21X1 U3217 ( .A0(PRDATA[0]), .A1(n5924), .B0(n5925), .Y(n5703) );
  NAND3BX2 U3218 ( .AN(PADDR[5]), .B(PADDR[6]), .C(n6384), .Y(n6314) );
  AND2X2 U3219 ( .A(n6166), .B(n6167), .Y(n6381) );
  AND3X2 U3220 ( .A(n6169), .B(n6168), .C(n6381), .Y(n6165) );
  AOI222X4 U3221 ( .A0(FIFOdata[18]), .A1(RxRdPtrInc), .B0(ResponseCMD18[18]), 
        .B1(n6385), .C0(n5953), .C1(iDataTimer[18]), .Y(n6166) );
  INVX3 U3222 ( .A(PADDR[4]), .Y(n5850) );
  AND2X2 U3223 ( .A(n6160), .B(n6161), .Y(n6383) );
  AND3X2 U3224 ( .A(n6163), .B(n6162), .C(n6383), .Y(n6159) );
  AOI222X4 U3225 ( .A0(FIFOdata[17]), .A1(RxRdPtrInc), .B0(ResponseCMD18[17]), 
        .B1(n6385), .C0(n5953), .C1(iDataTimer[17]), .Y(n6160) );
  BUFX2 U3226 ( .A(n6395), .Y(n6385) );
  AND3X1 U3227 ( .A(n6396), .B(PADDR[4]), .C(n6257), .Y(n6395) );
  AND2X2 U3228 ( .A(n6155), .B(n6154), .Y(n6386) );
  AOI222X4 U3229 ( .A0(FIFOdata[16]), .A1(RxRdPtrInc), .B0(ResponseCMD18[16]), 
        .B1(n6385), .C0(n5953), .C1(iDataTimer[16]), .Y(n6154) );
  AO21X1 U3230 ( .A0(n6278), .A1(n5917), .B0(SDreset), .Y(n6387) );
  NAND2BX1 U3231 ( .AN(n5908), .B(n6254), .Y(n6240) );
  AOI221X1 U3232 ( .A0(iSDICmdCon[10]), .A1(n5930), .B0(RFDET), .B1(n5956), 
        .C0(n6118), .Y(n6110) );
  AND4X1 U3233 ( .A(n6109), .B(n6110), .C(n6111), .D(n6112), .Y(n6108) );
  AOI221X1 U3234 ( .A0(iSDICmdCon[8]), .A1(n5930), .B0(TFEmpty), .B1(n5956), 
        .C0(n6093), .Y(n6085) );
  AND4X1 U3235 ( .A(n6084), .B(n6085), .C(n6086), .D(n6087), .Y(n6083) );
  OR2X2 U3236 ( .A(PADDR[2]), .B(PADDR[3]), .Y(n5908) );
  NAND2X1 U3237 ( .A(PADDR[2]), .B(PADDR[3]), .Y(n6389) );
  AND3X1 U3238 ( .A(PADDR[5]), .B(PADDR[4]), .C(n6390), .Y(n6397) );
  INVX1 U3239 ( .A(n6239), .Y(n5944) );
  NAND2BX1 U3240 ( .AN(n5875), .B(n6397), .Y(n6012) );
  NAND2BX1 U3241 ( .AN(n5875), .B(n6254), .Y(n6195) );
  NAND3BX1 U3242 ( .AN(PADDR[5]), .B(PADDR[4]), .C(n6390), .Y(n6266) );
  INVX1 U3243 ( .A(PENABLE), .Y(n5921) );
  NAND3BX1 U3244 ( .AN(PADDR[5]), .B(PENABLE), .C(PADDR[4]), .Y(n6308) );
  NAND2BX1 U3245 ( .AN(PENABLE), .B(n6306), .Y(n6305) );
  NAND4X1 U3246 ( .A(n6062), .B(n6063), .C(n6064), .D(n6065), .Y(n6393) );
  NAND4X1 U3247 ( .A(n6015), .B(n6016), .C(n6017), .D(n6018), .Y(n6392) );
  NAND2BX1 U3248 ( .AN(n5875), .B(n6263), .Y(n6264) );
  INVX3 U3249 ( .A(n6140), .Y(n5924) );
  NAND3BX1 U3250 ( .AN(n5945), .B(n6239), .C(n6241), .Y(n6260) );
  AO21X1 U3251 ( .A0(n5886), .A1(n5894), .B0(n5816), .Y(n6388) );
  INVX3 U3252 ( .A(n6264), .Y(n5945) );
  INVX3 U3253 ( .A(n6344), .Y(SDreset) );
  INVX1 U3254 ( .A(n5908), .Y(n6396) );
  INVX1 U3255 ( .A(n5847), .Y(n5846) );
  NAND2BX1 U3256 ( .AN(n5831), .B(n6344), .Y(n5847) );
  INVX1 U3257 ( .A(TFEmpty), .Y(n5987) );
  INVX1 U3258 ( .A(TFHalf), .Y(n6004) );
  INVX1 U3259 ( .A(n6304), .Y(n6303) );
  NAND2BX1 U3260 ( .AN(n5816), .B(n6387), .Y(n6304) );
  INVX1 U3261 ( .A(n5893), .Y(n5892) );
  NAND2BX1 U3262 ( .AN(n5816), .B(n6388), .Y(n5893) );
  INVX1 U3263 ( .A(n5885), .Y(n5882) );
  NAND2BX1 U3264 ( .AN(n5816), .B(n6335), .Y(n5885) );
  NAND4BX1 U3265 ( .AN(n6265), .B(n6117), .C(n6244), .D(n6057), .Y(n6245) );
  NAND3BX1 U3266 ( .AN(n6249), .B(n5960), .C(n6012), .Y(n6248) );
  INVX1 U3267 ( .A(n6387), .Y(n6285) );
  INVX1 U3268 ( .A(n6335), .Y(n5880) );
  NAND3X1 U3269 ( .A(n5959), .B(n6151), .C(n5962), .Y(n6249) );
  INVX1 U3270 ( .A(n6283), .Y(n6284) );
  INVX3 U3271 ( .A(n6151), .Y(n5949) );
  NAND2BX1 U3272 ( .AN(n5816), .B(n5897), .Y(n5901) );
  INVX1 U3273 ( .A(n6388), .Y(n5889) );
  INVX1 U3274 ( .A(n6117), .Y(n5932) );
  INVX1 U3275 ( .A(n6400), .Y(n5831) );
  INVX1 U3276 ( .A(n5962), .Y(n6071) );
  INVX1 U3277 ( .A(n5915), .Y(n5913) );
  INVX1 U3278 ( .A(n6135), .Y(n5930) );
  INVX1 U3279 ( .A(n6057), .Y(n5931) );
  INVX1 U3280 ( .A(n6136), .Y(n5956) );
  INVX1 U3281 ( .A(n6010), .Y(n5954) );
  INVX1 U3282 ( .A(n5936), .Y(n6082) );
  INVX1 U3283 ( .A(n5856), .Y(n5820) );
  INVX1 U3284 ( .A(n6012), .Y(n5957) );
  INVX1 U3285 ( .A(n5918), .Y(n5919) );
  INVX1 U3286 ( .A(n5922), .Y(n5923) );
  INVX1 U3287 ( .A(RFHalf), .Y(n5938) );
  AO21X1 U3288 ( .A0(n5917), .A1(n5887), .B0(n5816), .Y(n6283) );
  NAND2BX2 U3289 ( .AN(n5908), .B(n6252), .Y(n5936) );
  AO21X1 U3290 ( .A0(n5917), .A1(n5894), .B0(n5816), .Y(n5915) );
  NAND3BX1 U3291 ( .AN(n5850), .B(n5894), .C(n6257), .Y(n6010) );
  NAND2BX1 U3292 ( .AN(n6251), .B(n6252), .Y(n5960) );
  NAND2BX1 U3293 ( .AN(n5875), .B(n6258), .Y(n6057) );
  NAND2BX1 U3294 ( .AN(n6251), .B(n6258), .Y(n6244) );
  NAND2BX1 U3295 ( .AN(n5908), .B(n5828), .Y(n5856) );
  NAND2BX1 U3296 ( .AN(n5908), .B(n6263), .Y(n6117) );
  NAND2BX1 U3297 ( .AN(n6389), .B(n6254), .Y(n6151) );
  NAND2BX1 U3298 ( .AN(n6389), .B(n6258), .Y(n6135) );
  NAND2BX1 U3299 ( .AN(n6251), .B(n6263), .Y(n6241) );
  NAND2BX1 U3300 ( .AN(n6389), .B(n6263), .Y(n6239) );
  NAND2BX1 U3301 ( .AN(n6389), .B(n6252), .Y(n5959) );
  INVX1 U3302 ( .A(n5826), .Y(n5821) );
  NAND2BX1 U3303 ( .AN(n6389), .B(n5828), .Y(n5826) );
  OAI31X1 U3304 ( .A0(n5920), .A1(n5921), .A2(n5908), .B0(n6344), .Y(n5918) );
  OAI221X1 U3305 ( .A0(n5857), .A1(n5855), .B0(n5856), .B1(n5864), .C0(n6344), 
        .Y(n5863) );
  NAND3BX1 U3306 ( .AN(n5908), .B(n5909), .C(n5910), .Y(n5897) );
  NAND2BX2 U3307 ( .AN(n5908), .B(n6397), .Y(n6268) );
  INVX1 U3308 ( .A(n5875), .Y(n5894) );
  AOI21X1 U3309 ( .A0(n6278), .A1(n5886), .B0(n5816), .Y(n6394) );
  INVX1 U3310 ( .A(n6394), .Y(n6279) );
  BUFX2 U3311 ( .A(n5830), .Y(n6400) );
  OAI31X1 U3312 ( .A0(n5849), .A1(n6389), .A2(n5850), .B0(n6344), .Y(n5830) );
  INVX1 U3313 ( .A(n6251), .Y(n6278) );
  INVX1 U3314 ( .A(n5911), .Y(n5828) );
  INVX1 U3315 ( .A(n5849), .Y(n5876) );
  NAND2BX1 U3316 ( .AN(n5908), .B(n6258), .Y(n5940) );
  INVX1 U3317 ( .A(n6282), .Y(n5909) );
  INVX1 U3318 ( .A(n5920), .Y(n6306) );
  INVX1 U3319 ( .A(n6273), .Y(n6274) );
  INVX1 U3320 ( .A(n6389), .Y(n5887) );
  NAND4BX1 U3321 ( .AN(n6391), .B(n6398), .C(n5894), .D(n5910), .Y(n5922) );
  NOR2BX1 U3322 ( .AN(n6278), .B(n5911), .Y(RCmdStartSet4533) );
  NOR2BX1 U3323 ( .AN(n5887), .B(n6311), .Y(CMSTSet3211) );
  NOR2X1 U3324 ( .A(n5908), .B(n6311), .Y(SDreset2925) );
  DFFRX1 DTST_reg ( .D(n5774), .CK(PCLK), .RN(PRESETn), .Q(DTST), .QN(n6372)
         );
  DFFRX1 iSDIDatCon_reg_16_ ( .D(n5757), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[16]) );
  INVX1 U3325 ( .A(RFFull), .Y(n5971) );
  OR4X1 U3326 ( .A(n6316), .B(n6317), .C(n6318), .D(n6319), .Y(MMC_INT) );
  OAI221X1 U3327 ( .A0(n6336), .A1(n5971), .B0(n6330), .B1(n5938), .C0(n6325), 
        .Y(n6316) );
  OAI221X1 U3328 ( .A0(n6342), .A1(n6332), .B0(n6379), .B1(n6350), .C0(n6322), 
        .Y(n6318) );
  OAI221X1 U3329 ( .A0(n6329), .A1(n6331), .B0(n6341), .B1(n6349), .C0(n6320), 
        .Y(n6319) );
  OA22X1 U3330 ( .A0(n6357), .A1(n6338), .B0(n6333), .B1(n6351), .Y(n6320) );
  NAND2BX1 U3331 ( .AN(PADDR[2]), .B(PADDR[3]), .Y(n6251) );
  NAND3BX1 U3332 ( .AN(n5921), .B(PADDR[6]), .C(n6309), .Y(n5911) );
  NAND3BX1 U3333 ( .AN(n5921), .B(PADDR[5]), .C(n5909), .Y(n5849) );
  NAND3BX1 U3334 ( .AN(n5875), .B(PADDR[4]), .C(n5876), .Y(n5855) );
  NAND2BX1 U3335 ( .AN(PADDR[6]), .B(n6398), .Y(n6282) );
  AND4X1 U3336 ( .A(n5894), .B(PADDR[6]), .C(n6309), .D(n5921), .Y(TxWriteEn)
         );
  NAND2BX1 U3337 ( .AN(PADDR[6]), .B(n6309), .Y(n5920) );
  INVX1 U3338 ( .A(n6305), .Y(n5917) );
  OAI31X1 U3339 ( .A0(n6275), .A1(PENABLE), .A2(n6276), .B0(n6344), .Y(n6273)
         );
  NAND2BX1 U3340 ( .AN(n6391), .B(n6278), .Y(n6275) );
  NAND3BX1 U3341 ( .AN(n5973), .B(n5974), .C(n5975), .Y(n5964) );
  AOI222X1 U3342 ( .A0(BlkCnt[1]), .A1(n5955), .B0(FFCNT[1]), .B1(n5956), .C0(
        TxDatOn), .C1(n5957), .Y(n5974) );
  OAI222X1 U3343 ( .A0(n6359), .A1(n5959), .B0(n6346), .B1(n5960), .C0(n6336), 
        .C1(n5962), .Y(n5973) );
  AOI211X1 U3344 ( .A0(n5949), .A1(iSDIDatCon[1]), .B0(n5976), .C0(n5977), .Y(
        n5975) );
  NAND3BX1 U3345 ( .AN(n5946), .B(n5947), .C(n5948), .Y(n5926) );
  AOI222X1 U3346 ( .A0(BlkCnt[0]), .A1(n5955), .B0(FFCNT[0]), .B1(n5956), .C0(
        RxDatOn), .C1(n5957), .Y(n5947) );
  OAI222X1 U3347 ( .A0(n6352), .A1(n5959), .B0(n5960), .B1(n6371), .C0(n6330), 
        .C1(n5962), .Y(n5946) );
  AOI211X1 U3348 ( .A0(n5949), .A1(iSDIDatCon[0]), .B0(n5950), .C0(n5951), .Y(
        n5948) );
  INVX1 U3349 ( .A(n6266), .Y(n6263) );
  INVX1 U3350 ( .A(n6308), .Y(n5910) );
  AOI221X1 U3351 ( .A0(iSDICmdCon[11]), .A1(n5930), .B0(TFDET), .B1(n5956), 
        .C0(n6125), .Y(n6124) );
  AO22X1 U3352 ( .A0(n6071), .A1(CmdSentInt), .B0(BlkCnt[13]), .B1(n5955), .Y(
        n6125) );
  AOI221X1 U3353 ( .A0(Response3[11]), .A1(n5941), .B0(Response1[11]), .B1(
        n5933), .C0(n6100), .Y(n6099) );
  OAI32X1 U3354 ( .A0(n5936), .A1(n6334), .A2(n6343), .B0(n5988), .B1(n6360), 
        .Y(n6100) );
  AOI221X1 U3355 ( .A0(Response3[7]), .A1(n5941), .B0(Response1[7]), .B1(n5933), .C0(n6053), .Y(n6052) );
  OAI32X1 U3356 ( .A0(n5936), .A1(n6329), .A2(n6331), .B0(n5988), .B1(n6361), 
        .Y(n6053) );
  AOI221X1 U3357 ( .A0(Response3[6]), .A1(n5941), .B0(Response1[6]), .B1(n5933), .C0(n6040), .Y(n6039) );
  OAI32X1 U3358 ( .A0(n5936), .A1(n6333), .A2(n6351), .B0(n5988), .B1(n6362), 
        .Y(n6040) );
  AOI221X1 U3359 ( .A0(Response3[5]), .A1(n5941), .B0(Response1[5]), .B1(n5933), .C0(n6028), .Y(n6027) );
  OAI32X1 U3360 ( .A0(n5936), .A1(n6339), .A2(n6348), .B0(n5988), .B1(n6363), 
        .Y(n6028) );
  AOI221X1 U3361 ( .A0(Response3[3]), .A1(n5941), .B0(Response1[3]), .B1(n5933), .C0(n6002), .Y(n6001) );
  OAI32X1 U3362 ( .A0(n5936), .A1(n6337), .A2(n6004), .B0(n5988), .B1(n6364), 
        .Y(n6002) );
  AOI221X1 U3363 ( .A0(n5949), .A1(iSDIDatCon[14]), .B0(ResponseCMD18[14]), 
        .B1(n6385), .C0(n6137), .Y(n6132) );
  AO22X1 U3364 ( .A0(FIFOdata[14]), .A1(RxRdPtrInc), .B0(n5953), .B1(
        iDataTimer[14]), .Y(n6137) );
  AOI221X1 U3365 ( .A0(n5949), .A1(iSDIDatCon[9]), .B0(ResponseCMD18[9]), .B1(
        n6385), .C0(n6079), .Y(n6076) );
  AO22X1 U3366 ( .A0(FIFOdata[9]), .A1(RxRdPtrInc), .B0(n5953), .B1(
        iDataTimer[9]), .Y(n6079) );
  AOI211X1 U3367 ( .A0(Response2[2]), .A1(n5944), .B0(n5984), .C0(n5985), .Y(
        n5983) );
  AO22X1 U3368 ( .A0(Response1[2]), .A1(n5933), .B0(Response3[2]), .B1(n5941), 
        .Y(n5984) );
  OAI32X1 U3369 ( .A0(n5936), .A1(n6345), .A2(n5987), .B0(n5988), .B1(n6365), 
        .Y(n5985) );
  AO22X1 U3370 ( .A0(iSDIDatCon[30]), .A1(n5880), .B0(PWDATA[31]), .B1(n5882), 
        .Y(n5743) );
  AO22X1 U3371 ( .A0(iSDIDatCon[29]), .A1(n5880), .B0(PWDATA[30]), .B1(n5882), 
        .Y(n5744) );
  AO22X1 U3372 ( .A0(iSDIDatCon[27]), .A1(n5880), .B0(PWDATA[28]), .B1(n5882), 
        .Y(n5746) );
  AO22X1 U3373 ( .A0(iSDIDatCon[26]), .A1(n5880), .B0(PWDATA[27]), .B1(n5882), 
        .Y(n5747) );
  AO22X1 U3374 ( .A0(iSDIDatCon[25]), .A1(n5880), .B0(PWDATA[26]), .B1(n5882), 
        .Y(n5748) );
  AO22X1 U3375 ( .A0(iSDIDatCon[24]), .A1(n5880), .B0(PWDATA[25]), .B1(n5882), 
        .Y(n5749) );
  AO22X1 U3376 ( .A0(iSDIDatCon[23]), .A1(n5880), .B0(PWDATA[24]), .B1(n5882), 
        .Y(n5750) );
  AO22X1 U3377 ( .A0(iSDIDatCon[22]), .A1(n5880), .B0(PWDATA[23]), .B1(n5882), 
        .Y(n5751) );
  AO22X1 U3378 ( .A0(iSDIDatCon[21]), .A1(n5880), .B0(PWDATA[22]), .B1(n5882), 
        .Y(n5752) );
  AO22X1 U3379 ( .A0(iSDIDatCon[20]), .A1(n5880), .B0(PWDATA[21]), .B1(n5882), 
        .Y(n5753) );
  AO22X1 U3380 ( .A0(iSDIDatCon[19]), .A1(n5880), .B0(PWDATA[20]), .B1(n5882), 
        .Y(n5754) );
  AO22X1 U3381 ( .A0(iSDIDatCon[18]), .A1(n5880), .B0(PWDATA[19]), .B1(n5882), 
        .Y(n5755) );
  AOI221X1 U3382 ( .A0(Response0[14]), .A1(n5945), .B0(CmdArg[14]), .B1(n5943), 
        .C0(n6138), .Y(n6131) );
  AO22X1 U3383 ( .A0(Response2[14]), .A1(n5944), .B0(Response1[14]), .B1(n5933), .Y(n6138) );
  AOI221X1 U3384 ( .A0(Response0[13]), .A1(n5945), .B0(CmdArg[13]), .B1(n5943), 
        .C0(n6127), .Y(n6122) );
  AO22X1 U3385 ( .A0(Response2[13]), .A1(n5944), .B0(Response1[13]), .B1(n5933), .Y(n6127) );
  AOI221X1 U3386 ( .A0(Response0[9]), .A1(n5945), .B0(CmdArg[9]), .B1(n5943), 
        .C0(n6080), .Y(n6075) );
  AO22X1 U3387 ( .A0(Response2[9]), .A1(n5944), .B0(Response1[9]), .B1(n5933), 
        .Y(n6080) );
  INVX1 U3388 ( .A(n6267), .Y(n6258) );
  NAND3BX1 U3389 ( .AN(PADDR[5]), .B(n5850), .C(n6390), .Y(n6267) );
  AOI211X1 U3390 ( .A0(Response1[1]), .A1(n5933), .B0(n5968), .C0(n5969), .Y(
        n5966) );
  AO22X1 U3391 ( .A0(Response3[1]), .A1(n5941), .B0(iBlkSize[1]), .B1(n5942), 
        .Y(n5968) );
  OAI32X1 U3392 ( .A0(n5936), .A1(n6336), .A2(n5971), .B0(n6369), .B1(n5940), 
        .Y(n5969) );
  AOI211X1 U3393 ( .A0(Response1[0]), .A1(n5933), .B0(n5934), .C0(n5935), .Y(
        n5928) );
  AO22X1 U3394 ( .A0(Response3[0]), .A1(n5941), .B0(iBlkSize[0]), .B1(n5942), 
        .Y(n5934) );
  OAI32X1 U3395 ( .A0(n5936), .A1(n6330), .A2(n5938), .B0(n6370), .B1(n5940), 
        .Y(n5935) );
  AO22X1 U3396 ( .A0(n6285), .A1(CmdArg[31]), .B0(n6303), .B1(PWDATA[31]), .Y(
        n5609) );
  AO22X1 U3397 ( .A0(n6285), .A1(CmdArg[30]), .B0(n6303), .B1(PWDATA[30]), .Y(
        n5610) );
  AO22X1 U3398 ( .A0(n6285), .A1(CmdArg[29]), .B0(n6303), .B1(PWDATA[29]), .Y(
        n5611) );
  AO22X1 U3399 ( .A0(n6285), .A1(CmdArg[28]), .B0(n6303), .B1(PWDATA[28]), .Y(
        n5612) );
  AO22X1 U3400 ( .A0(n6285), .A1(CmdArg[27]), .B0(n6303), .B1(PWDATA[27]), .Y(
        n5613) );
  AO22X1 U3401 ( .A0(n6285), .A1(CmdArg[26]), .B0(n6303), .B1(PWDATA[26]), .Y(
        n5614) );
  AO22X1 U3402 ( .A0(n6285), .A1(CmdArg[25]), .B0(n6303), .B1(PWDATA[25]), .Y(
        n5615) );
  AO22X1 U3403 ( .A0(n6285), .A1(CmdArg[24]), .B0(n6303), .B1(PWDATA[24]), .Y(
        n5616) );
  AO22X1 U3404 ( .A0(n6285), .A1(CmdArg[23]), .B0(n6303), .B1(PWDATA[23]), .Y(
        n5617) );
  AO22X1 U3405 ( .A0(n6285), .A1(CmdArg[22]), .B0(n6303), .B1(PWDATA[22]), .Y(
        n5618) );
  AO22X1 U3406 ( .A0(n6285), .A1(CmdArg[21]), .B0(n6303), .B1(PWDATA[21]), .Y(
        n5619) );
  AO22X1 U3407 ( .A0(n6285), .A1(CmdArg[20]), .B0(n6303), .B1(PWDATA[20]), .Y(
        n5620) );
  AO22X1 U3408 ( .A0(n6285), .A1(CmdArg[19]), .B0(n6303), .B1(PWDATA[19]), .Y(
        n5621) );
  AO22X1 U3409 ( .A0(n6285), .A1(CmdArg[18]), .B0(n6303), .B1(PWDATA[18]), .Y(
        n5622) );
  AO22X1 U3410 ( .A0(n6285), .A1(CmdArg[17]), .B0(n6303), .B1(PWDATA[17]), .Y(
        n5623) );
  AO22X1 U3411 ( .A0(n6285), .A1(CmdArg[16]), .B0(n6303), .B1(PWDATA[16]), .Y(
        n5624) );
  AO22X1 U3412 ( .A0(iDataTimer[22]), .A1(n5889), .B0(n5892), .B1(PWDATA[22]), 
        .Y(n5720) );
  AO22X1 U3413 ( .A0(iDataTimer[21]), .A1(n5889), .B0(n5892), .B1(PWDATA[21]), 
        .Y(n5721) );
  AO22X1 U3414 ( .A0(iDataTimer[20]), .A1(n5889), .B0(n5892), .B1(PWDATA[20]), 
        .Y(n5722) );
  AO22X1 U3415 ( .A0(iDataTimer[19]), .A1(n5889), .B0(n5892), .B1(PWDATA[19]), 
        .Y(n5723) );
  AO22X1 U3416 ( .A0(iDataTimer[18]), .A1(n5889), .B0(n5892), .B1(PWDATA[18]), 
        .Y(n5724) );
  AO22X1 U3417 ( .A0(iDataTimer[17]), .A1(n5889), .B0(n5892), .B1(PWDATA[17]), 
        .Y(n5725) );
  AO22X1 U3418 ( .A0(iSDIDatCon[17]), .A1(n5880), .B0(n5882), .B1(PWDATA[17]), 
        .Y(n5756) );
  AO22X1 U3419 ( .A0(iSDIDatCon[16]), .A1(n5880), .B0(n5882), .B1(PWDATA[16]), 
        .Y(n5757) );
  AO22X1 U3420 ( .A0(AutoCMDCompleteInt), .A1(n5831), .B0(n5846), .B1(
        PWDATA[18]), .Y(n5782) );
  AO22X1 U3421 ( .A0(R12ErrorInt), .A1(n5831), .B0(n5846), .B1(PWDATA[17]), 
        .Y(n5783) );
  AO22X1 U3422 ( .A0(R18ErrorInt), .A1(n5831), .B0(n5846), .B1(PWDATA[16]), 
        .Y(n5784) );
  INVX1 U3423 ( .A(n6281), .Y(n5886) );
  NAND4BX1 U3424 ( .AN(n6282), .B(n5921), .C(PADDR[5]), .D(n5850), .Y(n6281)
         );
  AOI222X1 U3425 ( .A0(CmdArg[18]), .A1(n5943), .B0(Response2[18]), .B1(n5944), 
        .C0(Response0[18]), .C1(n5945), .Y(n6168) );
  AOI222X1 U3426 ( .A0(CmdArg[17]), .A1(n5943), .B0(Response2[17]), .B1(n5944), 
        .C0(Response0[17]), .C1(n5945), .Y(n6162) );
  AOI222X1 U3427 ( .A0(CmdArg[16]), .A1(n5943), .B0(Response2[16]), .B1(n5944), 
        .C0(Response0[16]), .C1(n5945), .Y(n6156) );
  AOI221X1 U3428 ( .A0(iBlkSize[8]), .A1(n5942), .B0(Response3[8]), .B1(n5941), 
        .C0(n6066), .Y(n6065) );
  OAI32X1 U3429 ( .A0(n5936), .A1(n6357), .A2(n6338), .B0(n5940), .B1(n6344), 
        .Y(n6066) );
  AOI221X1 U3430 ( .A0(Response3[12]), .A1(n5941), .B0(Response1[12]), .B1(
        n5933), .C0(n6113), .Y(n6112) );
  OAI32X1 U3431 ( .A0(n5936), .A1(n6342), .A2(n6332), .B0(n5988), .B1(n6366), 
        .Y(n6113) );
  AOI221X1 U3432 ( .A0(Response3[10]), .A1(n5941), .B0(Response1[10]), .B1(
        n5933), .C0(n6088), .Y(n6087) );
  OAI32X1 U3433 ( .A0(n5936), .A1(n6341), .A2(n6349), .B0(n5988), .B1(n6367), 
        .Y(n6088) );
  AOI221X1 U3434 ( .A0(Response3[4]), .A1(n5941), .B0(iBlkSize[4]), .B1(n5942), 
        .C0(n6019), .Y(n6018) );
  AO22X1 U3435 ( .A0(Response2[4]), .A1(n5944), .B0(Response1[4]), .B1(n5933), 
        .Y(n6019) );
  AOI221X1 U3436 ( .A0(Response2[12]), .A1(n5944), .B0(Response0[12]), .B1(
        n5945), .C0(n6116), .Y(n6111) );
  AO22X1 U3437 ( .A0(n5932), .A1(RspCrc), .B0(CmdArg[12]), .B1(n5943), .Y(
        n6116) );
  AOI221X1 U3438 ( .A0(Response2[10]), .A1(n5944), .B0(Response0[10]), .B1(
        n5945), .C0(n6092), .Y(n6086) );
  AO22X1 U3439 ( .A0(n5932), .A1(CmdTout), .B0(CmdArg[10]), .B1(n5943), .Y(
        n6092) );
  AOI221X1 U3440 ( .A0(Response0[8]), .A1(n5945), .B0(CmdArg[8]), .B1(n5943), 
        .C0(n6068), .Y(n6064) );
  AO22X1 U3441 ( .A0(Response2[8]), .A1(n5944), .B0(Response1[8]), .B1(n5933), 
        .Y(n6068) );
  AOI221X1 U3442 ( .A0(iSDICmdCon[4]), .A1(n5930), .B0(FFCNT[4]), .B1(n5956), 
        .C0(n6021), .Y(n6016) );
  AO22X1 U3443 ( .A0(n5957), .A1(DatFin), .B0(BlkCnt[4]), .B1(n5955), .Y(n6021) );
  AOI31X1 U3444 ( .A0(AutoCMDCompleteInt), .A1(AutoCMDComplete), .A2(n6082), 
        .B0(n6170), .Y(n6169) );
  AO22X1 U3445 ( .A0(Response1[18]), .A1(n5933), .B0(Response3[18]), .B1(n5941), .Y(n6170) );
  AOI31X1 U3446 ( .A0(R12ErrorInt), .A1(R12Error), .A2(n6082), .B0(n6164), .Y(
        n6163) );
  AO22X1 U3447 ( .A0(Response1[17]), .A1(n5933), .B0(Response3[17]), .B1(n5941), .Y(n6164) );
  AOI31X1 U3448 ( .A0(R18ErrorInt), .A1(R18Error), .A2(n6082), .B0(n6158), .Y(
        n6157) );
  AO22X1 U3449 ( .A0(Response1[16]), .A1(n5933), .B0(Response3[16]), .B1(n5941), .Y(n6158) );
  AOI32X1 U3450 ( .A0(RspCrc), .A1(RspCrcInt), .A2(n6082), .B0(iBlkSize[14]), 
        .B1(n5942), .Y(n6139) );
  AOI32X1 U3451 ( .A0(CmdSent), .A1(CmdSentInt), .A2(n6082), .B0(iBlkSize[13]), 
        .B1(n5942), .Y(n6128) );
  AOI32X1 U3452 ( .A0(CrcSta), .A1(CrcStaInt), .A2(n6082), .B0(iBlkSize[9]), 
        .B1(n5942), .Y(n6081) );
  AO22X1 U3453 ( .A0(Response2[15]), .A1(n5944), .B0(Response1[15]), .B1(n5933), .Y(n6147) );
  OAI33X1 U3454 ( .A0(n5816), .A1(n6372), .A2(DTSTClr), .B0(n5849), .B1(n6389), 
        .B2(n5878), .Y(n5774) );
  NAND3BX1 U3455 ( .AN(n5816), .B(n5850), .C(PWDATA[18]), .Y(n5878) );
  AO22X1 U3456 ( .A0(n5833), .A1(n6273), .B0(n6274), .B1(iAutoReadCon[1]), .Y(
        n5670) );
  AO22X1 U3457 ( .A0(n5829), .A1(n6273), .B0(n6274), .B1(iAutoReadCon[0]), .Y(
        n5671) );
  AO22X1 U3458 ( .A0(R18Error), .A1(n6354), .B0(ErrorState[0]), .B1(n6354), 
        .Y(n5801) );
  AO22X1 U3459 ( .A0(RspFinSet), .A1(n6344), .B0(n5895), .B1(n6399), .Y(n5719)
         );
  OA21X2 U3460 ( .A0(n5870), .A1(n5897), .B0(RspFin), .Y(n5895) );
  AO22X1 U3461 ( .A0(R12Error), .A1(n6355), .B0(ErrorState[1]), .B1(n6355), 
        .Y(n5800) );
  AO22X1 U3462 ( .A0(n5845), .A1(n6279), .B0(n6394), .B1(iBlkSize[15]), .Y(
        n5654) );
  AO22X1 U3463 ( .A0(n5844), .A1(n6279), .B0(n6394), .B1(iBlkSize[14]), .Y(
        n5655) );
  AO22X1 U3464 ( .A0(n5843), .A1(n6279), .B0(n6394), .B1(iBlkSize[13]), .Y(
        n5656) );
  AO22X1 U3465 ( .A0(n5842), .A1(n6279), .B0(n6394), .B1(iBlkSize[12]), .Y(
        n5657) );
  AO22X1 U3466 ( .A0(n5841), .A1(n6279), .B0(n6394), .B1(iBlkSize[11]), .Y(
        n5658) );
  AO22X1 U3467 ( .A0(n5840), .A1(n6279), .B0(n6394), .B1(iBlkSize[10]), .Y(
        n5659) );
  AO22X1 U3468 ( .A0(n5839), .A1(n6279), .B0(n6394), .B1(iBlkSize[9]), .Y(
        n5660) );
  AO22X1 U3469 ( .A0(n5838), .A1(n6279), .B0(n6394), .B1(iBlkSize[8]), .Y(
        n5661) );
  AO22X1 U3470 ( .A0(n5837), .A1(n6279), .B0(n6394), .B1(iBlkSize[7]), .Y(
        n5662) );
  AO22X1 U3471 ( .A0(n5836), .A1(n6279), .B0(n6394), .B1(iBlkSize[6]), .Y(
        n5663) );
  AO22X1 U3472 ( .A0(n5835), .A1(n6279), .B0(n6394), .B1(iBlkSize[5]), .Y(
        n5664) );
  AO22X1 U3473 ( .A0(n5881), .A1(n6279), .B0(n6394), .B1(iBlkSize[4]), .Y(
        n5665) );
  AO22X1 U3474 ( .A0(n5834), .A1(n6279), .B0(n6394), .B1(iBlkSize[3]), .Y(
        n5666) );
  AO22X1 U3475 ( .A0(n5833), .A1(n6279), .B0(n6394), .B1(iBlkSize[2]), .Y(
        n5667) );
  AO22X1 U3476 ( .A0(n5832), .A1(n6279), .B0(n6394), .B1(iBlkSize[1]), .Y(
        n5668) );
  AO22X1 U3477 ( .A0(n5829), .A1(n6279), .B0(n6394), .B1(iBlkSize[0]), .Y(
        n5669) );
  AO22X1 U3478 ( .A0(n5837), .A1(n5915), .B0(iSDIPRE[7]), .B1(n5913), .Y(n5707) );
  AO22X1 U3479 ( .A0(n5836), .A1(n5915), .B0(iSDIPRE[6]), .B1(n5913), .Y(n5708) );
  AO22X1 U3480 ( .A0(n5835), .A1(n5915), .B0(iSDIPRE[5]), .B1(n5913), .Y(n5709) );
  AO22X1 U3481 ( .A0(n5881), .A1(n5915), .B0(iSDIPRE[4]), .B1(n5913), .Y(n5710) );
  AO22X1 U3482 ( .A0(n5834), .A1(n5915), .B0(iSDIPRE[3]), .B1(n5913), .Y(n5711) );
  AO22X1 U3483 ( .A0(n5833), .A1(n5915), .B0(iSDIPRE[2]), .B1(n5913), .Y(n5712) );
  AO22X1 U3484 ( .A0(n5832), .A1(n5915), .B0(iSDIPRE[1]), .B1(n5913), .Y(n5713) );
  AO22X1 U3485 ( .A0(n5845), .A1(n6400), .B0(NoBusyInt), .B1(n5831), .Y(n5785)
         );
  AO22X1 U3486 ( .A0(n5844), .A1(n6400), .B0(RspCrcInt), .B1(n5831), .Y(n5786)
         );
  AO22X1 U3487 ( .A0(n5843), .A1(n6400), .B0(CmdSentInt), .B1(n5831), .Y(n5787) );
  AO22X1 U3488 ( .A0(n5842), .A1(n6400), .B0(CmdToutInt), .B1(n5831), .Y(n5788) );
  AO22X1 U3489 ( .A0(n5841), .A1(n6400), .B0(RspFinInt), .B1(n5831), .Y(n5789)
         );
  AO22X1 U3490 ( .A0(n5840), .A1(n6400), .B0(FFfailInt), .B1(n5831), .Y(n5790)
         );
  AO22X1 U3491 ( .A0(n5839), .A1(n6400), .B0(CrcStaInt), .B1(n5831), .Y(n5791)
         );
  AO22X1 U3492 ( .A0(n5838), .A1(n6400), .B0(DatCrcInt), .B1(n5831), .Y(n5792)
         );
  AO22X1 U3493 ( .A0(n5837), .A1(n6400), .B0(DatToutInt), .B1(n5831), .Y(n5793) );
  AO22X1 U3494 ( .A0(n5836), .A1(n6400), .B0(DatFinInt), .B1(n5831), .Y(n5794)
         );
  AO22X1 U3495 ( .A0(n5835), .A1(n6400), .B0(BusyFinInt), .B1(n5831), .Y(n5795) );
  AO22X1 U3496 ( .A0(n5834), .A1(n6400), .B0(TFHalfInt), .B1(n5831), .Y(n5796)
         );
  AO22X1 U3497 ( .A0(n5833), .A1(n6400), .B0(TFEmpInt), .B1(n5831), .Y(n5797)
         );
  AO22X1 U3498 ( .A0(n5832), .A1(n6400), .B0(RFFullInt), .B1(n5831), .Y(n5798)
         );
  AO22X1 U3499 ( .A0(n5829), .A1(n6400), .B0(RFHalfInt), .B1(n5831), .Y(n5799)
         );
  AO22X1 U3500 ( .A0(n6285), .A1(CmdArg[15]), .B0(n5845), .B1(n6387), .Y(n5625) );
  AO22X1 U3501 ( .A0(n6285), .A1(CmdArg[8]), .B0(n5838), .B1(n6387), .Y(n5632)
         );
  AO22X1 U3502 ( .A0(n5843), .A1(n6283), .B0(n6284), .B1(iSDICmdCon[11]), .Y(
        n5642) );
  AO22X1 U3503 ( .A0(n5842), .A1(n6283), .B0(n6284), .B1(iSDICmdCon[10]), .Y(
        n5643) );
  AO22X1 U3504 ( .A0(n5836), .A1(n6283), .B0(n6284), .B1(iSDICmdCon[6]), .Y(
        n5647) );
  AO22X1 U3505 ( .A0(n5835), .A1(n6283), .B0(n6284), .B1(iSDICmdCon[5]), .Y(
        n5648) );
  AO22X1 U3506 ( .A0(n5841), .A1(n6283), .B0(n6284), .B1(iSDICmdCon[9]), .Y(
        n5644) );
  AO22X1 U3507 ( .A0(n5840), .A1(n6283), .B0(n6284), .B1(iSDICmdCon[8]), .Y(
        n5645) );
  AO22X1 U3508 ( .A0(n5881), .A1(n6283), .B0(n6284), .B1(iSDICmdCon[4]), .Y(
        n5649) );
  AO22X1 U3509 ( .A0(n5834), .A1(n6283), .B0(n6284), .B1(iSDICmdCon[3]), .Y(
        n5650) );
  AO22X1 U3510 ( .A0(n5833), .A1(n6283), .B0(n6284), .B1(iSDICmdCon[2]), .Y(
        n5651) );
  AO22X1 U3511 ( .A0(n5832), .A1(n6283), .B0(n6284), .B1(iSDICmdCon[1]), .Y(
        n5652) );
  AO22X1 U3512 ( .A0(n5829), .A1(n6283), .B0(n6284), .B1(iSDICmdCon[0]), .Y(
        n5653) );
  AO22X1 U3513 ( .A0(n5844), .A1(n6388), .B0(iDataTimer[14]), .B1(n5889), .Y(
        n5728) );
  AO22X1 U3514 ( .A0(n5843), .A1(n6388), .B0(iDataTimer[13]), .B1(n5889), .Y(
        n5729) );
  AO22X1 U3515 ( .A0(n5842), .A1(n6388), .B0(iDataTimer[12]), .B1(n5889), .Y(
        n5730) );
  AO22X1 U3516 ( .A0(n5841), .A1(n6388), .B0(iDataTimer[11]), .B1(n5889), .Y(
        n5731) );
  AO22X1 U3517 ( .A0(n5840), .A1(n6388), .B0(iDataTimer[10]), .B1(n5889), .Y(
        n5732) );
  AO22X1 U3518 ( .A0(n5839), .A1(n6388), .B0(iDataTimer[9]), .B1(n5889), .Y(
        n5733) );
  AO22X1 U3519 ( .A0(n5838), .A1(n6388), .B0(iDataTimer[8]), .B1(n5889), .Y(
        n5734) );
  AO22X1 U3520 ( .A0(n5837), .A1(n6388), .B0(iDataTimer[7]), .B1(n5889), .Y(
        n5735) );
  AO22X1 U3521 ( .A0(n5836), .A1(n6388), .B0(iDataTimer[6]), .B1(n5889), .Y(
        n5736) );
  AO22X1 U3522 ( .A0(n5835), .A1(n6388), .B0(iDataTimer[5]), .B1(n5889), .Y(
        n5737) );
  AO22X1 U3523 ( .A0(n5881), .A1(n6388), .B0(iDataTimer[4]), .B1(n5889), .Y(
        n5738) );
  AO22X1 U3524 ( .A0(n5834), .A1(n6388), .B0(iDataTimer[3]), .B1(n5889), .Y(
        n5739) );
  AO22X1 U3525 ( .A0(n5833), .A1(n6388), .B0(iDataTimer[2]), .B1(n5889), .Y(
        n5740) );
  AO22X1 U3526 ( .A0(n5832), .A1(n6388), .B0(iDataTimer[1]), .B1(n5889), .Y(
        n5741) );
  AO22X1 U3527 ( .A0(n5834), .A1(n6335), .B0(iSDIDatCon[3]), .B1(n5880), .Y(
        n5770) );
  AO22X1 U3528 ( .A0(n5833), .A1(n6335), .B0(iSDIDatCon[2]), .B1(n5880), .Y(
        n5771) );
  AO22X1 U3529 ( .A0(n5832), .A1(n6335), .B0(iSDIDatCon[1]), .B1(n5880), .Y(
        n5772) );
  AO22X1 U3530 ( .A0(n5829), .A1(n6335), .B0(iSDIDatCon[0]), .B1(n5880), .Y(
        n5773) );
  AO22X1 U3531 ( .A0(n5845), .A1(n6388), .B0(iDataTimer[15]), .B1(n5889), .Y(
        n5727) );
  AO22X1 U3532 ( .A0(n5829), .A1(n6388), .B0(iDataTimer[0]), .B1(n5889), .Y(
        n5742) );
  AO22X1 U3533 ( .A0(n5844), .A1(n6335), .B0(iSDIDatCon[14]), .B1(n5880), .Y(
        n5759) );
  AO22X1 U3534 ( .A0(n5843), .A1(n6335), .B0(iSDIDatCon[13]), .B1(n5880), .Y(
        n5760) );
  AO22X1 U3535 ( .A0(n5842), .A1(n6335), .B0(iSDIDatCon[12]), .B1(n5880), .Y(
        n5761) );
  AO22X1 U3536 ( .A0(n5841), .A1(n6335), .B0(iSDIDatCon[11]), .B1(n5880), .Y(
        n5762) );
  AO22X1 U3537 ( .A0(n5840), .A1(n6335), .B0(iSDIDatCon[10]), .B1(n5880), .Y(
        n5763) );
  AO22X1 U3538 ( .A0(n5839), .A1(n6335), .B0(iSDIDatCon[9]), .B1(n5880), .Y(
        n5764) );
  AO22X1 U3539 ( .A0(n5838), .A1(n6335), .B0(iSDIDatCon[8]), .B1(n5880), .Y(
        n5765) );
  AO22X1 U3540 ( .A0(n5837), .A1(n6335), .B0(iSDIDatCon[7]), .B1(n5880), .Y(
        n5766) );
  AO22X1 U3541 ( .A0(n5836), .A1(n6335), .B0(iSDIDatCon[6]), .B1(n5880), .Y(
        n5767) );
  AO22X1 U3542 ( .A0(n5835), .A1(n6335), .B0(iSDIDatCon[5]), .B1(n5880), .Y(
        n5768) );
  AO22X1 U3543 ( .A0(n5881), .A1(n6335), .B0(iSDIDatCon[4]), .B1(n5880), .Y(
        n5769) );
  AO22X1 U3544 ( .A0(n6285), .A1(CmdArg[14]), .B0(n5844), .B1(n6387), .Y(n5626) );
  AO22X1 U3545 ( .A0(n6285), .A1(CmdArg[13]), .B0(n5843), .B1(n6387), .Y(n5627) );
  AO22X1 U3546 ( .A0(n6285), .A1(CmdArg[12]), .B0(n5842), .B1(n6387), .Y(n5628) );
  AO22X1 U3547 ( .A0(n6285), .A1(CmdArg[11]), .B0(n5841), .B1(n6387), .Y(n5629) );
  AO22X1 U3548 ( .A0(n6285), .A1(CmdArg[10]), .B0(n5840), .B1(n6387), .Y(n5630) );
  AO22X1 U3549 ( .A0(n6285), .A1(CmdArg[9]), .B0(n5839), .B1(n6387), .Y(n5631)
         );
  AO22X1 U3550 ( .A0(n6285), .A1(CmdArg[7]), .B0(n5837), .B1(n6387), .Y(n5633)
         );
  AO22X1 U3551 ( .A0(n6285), .A1(CmdArg[4]), .B0(n5881), .B1(n6387), .Y(n5636)
         );
  AO22X1 U3552 ( .A0(FFfailSet), .A1(n6399), .B0(FFfail), .B1(n6399), .Y(n5781) );
  AO22X1 U3553 ( .A0(AutoReadComplete), .A1(n6356), .B0(AutoCMDComplete), .B1(
        n6356), .Y(n5802) );
  AO22X1 U3554 ( .A0(n5844), .A1(n6283), .B0(n6284), .B1(iSDICmdCon[12]), .Y(
        n5641) );
  AO22X1 U3555 ( .A0(n5839), .A1(n6283), .B0(n6284), .B1(iSDICmdCon[7]), .Y(
        n5646) );
  AO22X1 U3556 ( .A0(n5829), .A1(n5918), .B0(ENCLK), .B1(n5919), .Y(n5705) );
  AO22X1 U3557 ( .A0(n5832), .A1(n5918), .B0(PSAVEON), .B1(n5919), .Y(n5706)
         );
  AO22X1 U3558 ( .A0(NoBusySet), .A1(n5871), .B0(NoBusy), .B1(n5871), .Y(n5775) );
  INVX1 U3559 ( .A(n5872), .Y(n5871) );
  OAI221X1 U3560 ( .A0(n5873), .A1(n5855), .B0(n5856), .B1(n5874), .C0(n6344), 
        .Y(n5872) );
  INVX1 U3561 ( .A(PWDATA[11]), .Y(n5873) );
  AO22X1 U3562 ( .A0(CrcStaSet), .A1(n5868), .B0(CrcSta), .B1(n5868), .Y(n5776) );
  INVX1 U3563 ( .A(n5869), .Y(n5868) );
  OAI221X1 U3564 ( .A0(n5864), .A1(n5855), .B0(n5856), .B1(n5870), .C0(n6344), 
        .Y(n5869) );
  AO22X1 U3565 ( .A0(DatCrcSet), .A1(n5865), .B0(DatCrc), .B1(n5865), .Y(n5777) );
  INVX1 U3566 ( .A(n5866), .Y(n5865) );
  OAI221X1 U3567 ( .A0(n5861), .A1(n5855), .B0(n5856), .B1(n5867), .C0(n6344), 
        .Y(n5866) );
  INVX1 U3568 ( .A(PWDATA[8]), .Y(n5867) );
  AO22X1 U3569 ( .A0(DatToutSet), .A1(n5862), .B0(DatTout), .B1(n5862), .Y(
        n5778) );
  INVX1 U3570 ( .A(n5863), .Y(n5862) );
  AO22X1 U3571 ( .A0(DatFinSet), .A1(n5858), .B0(DatFin), .B1(n5858), .Y(n5779) );
  INVX1 U3572 ( .A(n5859), .Y(n5858) );
  OAI221X1 U3573 ( .A0(n5855), .A1(n5860), .B0(n5856), .B1(n5861), .C0(n6344), 
        .Y(n5859) );
  INVX1 U3574 ( .A(PWDATA[4]), .Y(n5860) );
  AO22X1 U3575 ( .A0(BusyFinSet), .A1(n5852), .B0(BusyFin), .B1(n5852), .Y(
        n5780) );
  INVX1 U3576 ( .A(n5853), .Y(n5852) );
  OAI221X1 U3577 ( .A0(n5854), .A1(n5855), .B0(n5856), .B1(n5857), .C0(n6344), 
        .Y(n5853) );
  INVX1 U3578 ( .A(PWDATA[3]), .Y(n5854) );
  AO22X1 U3579 ( .A0(n6285), .A1(CmdArg[6]), .B0(n5836), .B1(n6387), .Y(n5634)
         );
  AO22X1 U3580 ( .A0(n6285), .A1(CmdArg[5]), .B0(n5835), .B1(n6387), .Y(n5635)
         );
  AO22X1 U3581 ( .A0(n6285), .A1(CmdArg[3]), .B0(n5834), .B1(n6387), .Y(n5637)
         );
  AO22X1 U3582 ( .A0(n6285), .A1(CmdArg[2]), .B0(n5833), .B1(n6387), .Y(n5638)
         );
  AO22X1 U3583 ( .A0(n6285), .A1(CmdArg[1]), .B0(n5832), .B1(n6387), .Y(n5639)
         );
  AO22X1 U3584 ( .A0(n6285), .A1(CmdArg[0]), .B0(n5829), .B1(n6387), .Y(n5640)
         );
  AO22X1 U3585 ( .A0(n5845), .A1(n6335), .B0(iSDIDatCon[15]), .B1(n5880), .Y(
        n5758) );
  OAI221X1 U3586 ( .A0(n6347), .A1(n6012), .B0(n6334), .B1(n5962), .C0(n6107), 
        .Y(n6096) );
  AOI222X1 U3587 ( .A0(BlkCnt[11]), .A1(n5955), .B0(iSDICmdCon[9]), .B1(n5930), 
        .C0(TFHalf), .C1(n5956), .Y(n6107) );
  OAI221X1 U3588 ( .A0(n6348), .A1(n6012), .B0(n6337), .B1(n5962), .C0(n6013), 
        .Y(n5998) );
  AOI222X1 U3589 ( .A0(BlkCnt[3]), .A1(n5955), .B0(iSDICmdCon[3]), .B1(n5930), 
        .C0(FFCNT[3]), .C1(n5956), .Y(n6013) );
  OAI221X1 U3590 ( .A0(n6350), .A1(n6012), .B0(n6329), .B1(n5962), .C0(n6060), 
        .Y(n6049) );
  AOI222X1 U3591 ( .A0(BlkCnt[7]), .A1(n5955), .B0(RspIndex[7]), .B1(n5932), 
        .C0(n5956), .C1(RFHalf), .Y(n6060) );
  OAI221X1 U3592 ( .A0(n6338), .A1(n6012), .B0(n6333), .B1(n5962), .C0(n6047), 
        .Y(n6036) );
  AOI222X1 U3593 ( .A0(BlkCnt[6]), .A1(n5955), .B0(RspIndex[6]), .B1(n5932), 
        .C0(iSDICmdCon[6]), .C1(n5930), .Y(n6047) );
  OAI221X1 U3594 ( .A0(n6331), .A1(n6012), .B0(n6339), .B1(n5962), .C0(n6034), 
        .Y(n6024) );
  AOI222X1 U3595 ( .A0(BlkCnt[5]), .A1(n5955), .B0(RspIndex[5]), .B1(n5932), 
        .C0(iSDICmdCon[5]), .C1(n5930), .Y(n6034) );
  OAI221X1 U3596 ( .A0(n6358), .A1(n5959), .B0(n6345), .B1(n5962), .C0(n5995), 
        .Y(n5980) );
  AOI222X1 U3597 ( .A0(BlkCnt[2]), .A1(n5955), .B0(FFCNT[2]), .B1(n5956), .C0(
        iAutoReadCon[1]), .C1(n5996), .Y(n5995) );
  INVX1 U3598 ( .A(n5960), .Y(n5996) );
  OAI2BB1X1 U3599 ( .A0N(PRDATA[18]), .A1N(n5924), .B0(n6165), .Y(n5685) );
  AOI222X1 U3600 ( .A0(n5949), .A1(DTST), .B0(BlkNumCnt[2]), .B1(n5955), .C0(
        n6071), .C1(AutoCMDCompleteInt), .Y(n6167) );
  OAI2BB1X1 U3601 ( .A0N(PRDATA[17]), .A1N(n5924), .B0(n6159), .Y(n5686) );
  AOI222X1 U3602 ( .A0(n5949), .A1(iSDIDatCon[17]), .B0(BlkNumCnt[1]), .B1(
        n5955), .C0(n6071), .C1(R12ErrorInt), .Y(n6161) );
  OAI2BB1X1 U3603 ( .A0N(PRDATA[16]), .A1N(n5924), .B0(n6153), .Y(n5687) );
  AOI222X1 U3604 ( .A0(n5949), .A1(iSDIDatCon[16]), .B0(BlkNumCnt[0]), .B1(
        n5955), .C0(n6071), .C1(R18ErrorInt), .Y(n6155) );
  OAI2BB1X1 U3605 ( .A0N(PRDATA[12]), .A1N(n5924), .B0(n6108), .Y(n5691) );
  AOI221X1 U3606 ( .A0(n5949), .A1(iSDIDatCon[12]), .B0(ResponseCMD18[12]), 
        .B1(n6385), .C0(n6119), .Y(n6109) );
  OAI2BB1X1 U3607 ( .A0N(PRDATA[10]), .A1N(n5924), .B0(n6083), .Y(n5693) );
  AOI221X1 U3608 ( .A0(n5949), .A1(iSDIDatCon[10]), .B0(ResponseCMD18[10]), 
        .B1(n6385), .C0(n6094), .Y(n6084) );
  AOI221X1 U3609 ( .A0(n5949), .A1(iSDIDatCon[8]), .B0(ResponseCMD18[8]), .B1(
        n6385), .C0(n6072), .Y(n6062) );
  AOI211X1 U3610 ( .A0(n5930), .A1(CMST), .B0(n6069), .C0(n6070), .Y(n6063) );
  AOI221X1 U3611 ( .A0(Response0[4]), .A1(n5945), .B0(CmdArg[4]), .B1(n5943), 
        .C0(n6020), .Y(n6017) );
  AOI221X1 U3612 ( .A0(n5949), .A1(iSDIDatCon[4]), .B0(ResponseCMD18[4]), .B1(
        n6385), .C0(n6022), .Y(n6015) );
  AO22X1 U3613 ( .A0(RspIndex[4]), .A1(n5932), .B0(n5931), .B1(iSDIPRE[4]), 
        .Y(n6020) );
  AO22X1 U3614 ( .A0(Response0[31]), .A1(n5945), .B0(Response2[31]), .B1(n5944), .Y(n6238) );
  AO22X1 U3615 ( .A0(Response0[30]), .A1(n5945), .B0(Response2[30]), .B1(n5944), .Y(n6233) );
  AO22X1 U3616 ( .A0(Response0[29]), .A1(n5945), .B0(Response2[29]), .B1(n5944), .Y(n6228) );
  AO22X1 U3617 ( .A0(Response0[28]), .A1(n5945), .B0(Response2[28]), .B1(n5944), .Y(n6223) );
  AO22X1 U3618 ( .A0(Response0[27]), .A1(n5945), .B0(Response2[27]), .B1(n5944), .Y(n6218) );
  AO22X1 U3619 ( .A0(Response0[26]), .A1(n5945), .B0(Response2[26]), .B1(n5944), .Y(n6213) );
  AO22X1 U3620 ( .A0(Response0[25]), .A1(n5945), .B0(Response2[25]), .B1(n5944), .Y(n6208) );
  AO22X1 U3621 ( .A0(Response0[24]), .A1(n5945), .B0(Response2[24]), .B1(n5944), .Y(n6203) );
  AO22X1 U3622 ( .A0(Response0[23]), .A1(n5945), .B0(Response2[23]), .B1(n5944), .Y(n6198) );
  AO22X1 U3623 ( .A0(iSDICmdCon[7]), .A1(n5930), .B0(n5932), .B1(RspFin), .Y(
        n6078) );
  AO22X1 U3624 ( .A0(n5956), .A1(FFfail), .B0(iSDICmdCon[12]), .B1(n5930), .Y(
        n6134) );
  AO22X1 U3625 ( .A0(FIFOdata[13]), .A1(RxRdPtrInc), .B0(n5953), .B1(
        iDataTimer[13]), .Y(n6126) );
  AO22X1 U3626 ( .A0(FIFOdata[12]), .A1(RxRdPtrInc), .B0(n5953), .B1(
        iDataTimer[12]), .Y(n6119) );
  AO22X1 U3627 ( .A0(FIFOdata[11]), .A1(RxRdPtrInc), .B0(n5953), .B1(
        iDataTimer[11]), .Y(n6105) );
  AO22X1 U3628 ( .A0(FIFOdata[10]), .A1(RxRdPtrInc), .B0(n5953), .B1(
        iDataTimer[10]), .Y(n6094) );
  AO22X1 U3629 ( .A0(FIFOdata[8]), .A1(RxRdPtrInc), .B0(n5953), .B1(
        iDataTimer[8]), .Y(n6072) );
  AO22X1 U3630 ( .A0(FIFOdata[7]), .A1(RxRdPtrInc), .B0(n5953), .B1(
        iDataTimer[7]), .Y(n6058) );
  AO22X1 U3631 ( .A0(FIFOdata[6]), .A1(RxRdPtrInc), .B0(n5953), .B1(
        iDataTimer[6]), .Y(n6045) );
  AO22X1 U3632 ( .A0(FIFOdata[5]), .A1(RxRdPtrInc), .B0(n5953), .B1(
        iDataTimer[5]), .Y(n6032) );
  AO22X1 U3633 ( .A0(FIFOdata[4]), .A1(RxRdPtrInc), .B0(n5953), .B1(
        iDataTimer[4]), .Y(n6022) );
  AO22X1 U3634 ( .A0(n5932), .A1(CmdSent), .B0(CmdArg[11]), .B1(n5943), .Y(
        n6104) );
  AO22X1 U3635 ( .A0(n5931), .A1(iSDIPRE[7]), .B0(CmdArg[7]), .B1(n5943), .Y(
        n6056) );
  AO22X1 U3636 ( .A0(n5931), .A1(iSDIPRE[6]), .B0(CmdArg[6]), .B1(n5943), .Y(
        n6044) );
  AO22X1 U3637 ( .A0(n5931), .A1(iSDIPRE[5]), .B0(CmdArg[5]), .B1(n5943), .Y(
        n6031) );
  AO22X1 U3638 ( .A0(n6071), .A1(CmdToutInt), .B0(BlkCnt[12]), .B1(n5955), .Y(
        n6118) );
  AO22X1 U3639 ( .A0(n6071), .A1(FFfailInt), .B0(BlkCnt[10]), .B1(n5955), .Y(
        n6093) );
  OAI221X1 U3640 ( .A0(n5880), .A1(n5883), .B0(n6335), .B1(n6373), .C0(n6344), 
        .Y(n5745) );
  INVX1 U3641 ( .A(PWDATA[29]), .Y(n5883) );
  OAI221X1 U3642 ( .A0(n5913), .A1(n5914), .B0(n5915), .B1(n6377), .C0(n6344), 
        .Y(n5714) );
  INVX1 U3643 ( .A(PWDATA[0]), .Y(n5914) );
  OAI221X1 U3644 ( .A0(n5889), .A1(n5890), .B0(n6388), .B1(n6378), .C0(n6344), 
        .Y(n5726) );
  INVX1 U3645 ( .A(PWDATA[16]), .Y(n5890) );
  AO22X1 U3646 ( .A0(FIFOdata[3]), .A1(RxRdPtrInc), .B0(n5954), .B1(InvSel), 
        .Y(n6008) );
  AO22X1 U3647 ( .A0(Response0[3]), .A1(n5945), .B0(Response2[3]), .B1(n5944), 
        .Y(n6006) );
  AO22X1 U3648 ( .A0(Response3[22]), .A1(n5941), .B0(Response1[22]), .B1(n5933), .Y(n6191) );
  AO22X1 U3649 ( .A0(Response3[21]), .A1(n5941), .B0(Response1[21]), .B1(n5933), .Y(n6185) );
  AO22X1 U3650 ( .A0(Response3[20]), .A1(n5941), .B0(Response1[20]), .B1(n5933), .Y(n6179) );
  AO22X1 U3651 ( .A0(Response3[19]), .A1(n5941), .B0(Response1[19]), .B1(n5933), .Y(n6173) );
  AO22X1 U3652 ( .A0(FIFOdata[1]), .A1(RxRdPtrInc), .B0(DelaySel[1]), .B1(
        n5954), .Y(n5976) );
  AO22X1 U3653 ( .A0(FIFOdata[0]), .A1(RxRdPtrInc), .B0(DelaySel[0]), .B1(
        n5954), .Y(n5950) );
  AO22X1 U3654 ( .A0(FIFOdata[2]), .A1(RxRdPtrInc), .B0(DelaySel[2]), .B1(
        n5954), .Y(n5992) );
  AO22X1 U3655 ( .A0(CmdArg[2]), .A1(n5943), .B0(Response0[2]), .B1(n5945), 
        .Y(n5990) );
  AO22X1 U3656 ( .A0(n6071), .A1(DatCrcInt), .B0(BlkCnt[8]), .B1(n5955), .Y(
        n6069) );
  AO22X1 U3657 ( .A0(RFFull), .A1(n5956), .B0(CmdOn), .B1(n5932), .Y(n6070) );
  AO22X1 U3658 ( .A0(RspIndex[3]), .A1(n5932), .B0(n5931), .B1(iSDIPRE[3]), 
        .Y(n6007) );
  AO22X1 U3659 ( .A0(n5931), .A1(iSDIPRE[2]), .B0(RspIndex[2]), .B1(n5932), 
        .Y(n5991) );
  AO22X1 U3660 ( .A0(Response0[22]), .A1(n5945), .B0(Response2[22]), .B1(n5944), .Y(n6192) );
  AO22X1 U3661 ( .A0(Response0[21]), .A1(n5945), .B0(Response2[21]), .B1(n5944), .Y(n6186) );
  AO22X1 U3662 ( .A0(Response0[20]), .A1(n5945), .B0(Response2[20]), .B1(n5944), .Y(n6180) );
  AO22X1 U3663 ( .A0(Response0[19]), .A1(n5945), .B0(Response2[19]), .B1(n5944), .Y(n6174) );
  AO22X1 U3664 ( .A0(n5953), .A1(iDataTimer[15]), .B0(ResponseCMD18[15]), .B1(
        n6395), .Y(n6149) );
  AO22X1 U3665 ( .A0(ResponseCMD18[1]), .A1(n6395), .B0(n5953), .B1(
        iDataTimer[1]), .Y(n5977) );
  AO22X1 U3666 ( .A0(ResponseCMD18[0]), .A1(n6395), .B0(n5953), .B1(
        iDataTimer[0]), .Y(n5951) );
  AO22X1 U3667 ( .A0(ResponseCMD18[3]), .A1(n6395), .B0(n5953), .B1(
        iDataTimer[3]), .Y(n6009) );
  AO22X1 U3668 ( .A0(ResponseCMD18[2]), .A1(n6395), .B0(n5953), .B1(
        iDataTimer[2]), .Y(n5993) );
  AO22X1 U3669 ( .A0(BlkNumCnt[15]), .A1(n5955), .B0(CmdArg[31]), .B1(n5943), 
        .Y(n6243) );
  AO22X1 U3670 ( .A0(BlkNumCnt[14]), .A1(n5955), .B0(CmdArg[30]), .B1(n5943), 
        .Y(n6235) );
  AO22X1 U3671 ( .A0(BlkNumCnt[13]), .A1(n5955), .B0(CmdArg[29]), .B1(n5943), 
        .Y(n6230) );
  AO22X1 U3672 ( .A0(BlkNumCnt[12]), .A1(n5955), .B0(CmdArg[28]), .B1(n5943), 
        .Y(n6225) );
  AO22X1 U3673 ( .A0(BlkNumCnt[11]), .A1(n5955), .B0(CmdArg[27]), .B1(n5943), 
        .Y(n6220) );
  AO22X1 U3674 ( .A0(BlkNumCnt[10]), .A1(n5955), .B0(CmdArg[26]), .B1(n5943), 
        .Y(n6215) );
  AO22X1 U3675 ( .A0(BlkNumCnt[9]), .A1(n5955), .B0(CmdArg[25]), .B1(n5943), 
        .Y(n6210) );
  AO22X1 U3676 ( .A0(BlkNumCnt[8]), .A1(n5955), .B0(CmdArg[24]), .B1(n5943), 
        .Y(n6205) );
  AO22X1 U3677 ( .A0(BlkNumCnt[7]), .A1(n5955), .B0(CmdArg[23]), .B1(n5943), 
        .Y(n6200) );
  AO22X1 U3678 ( .A0(n5949), .A1(iSDIDatCon[21]), .B0(BlkNumCnt[6]), .B1(n5955), .Y(n6194) );
  AO22X1 U3679 ( .A0(n5949), .A1(iSDIDatCon[20]), .B0(BlkNumCnt[5]), .B1(n5955), .Y(n6188) );
  AO22X1 U3680 ( .A0(n5949), .A1(iSDIDatCon[19]), .B0(BlkNumCnt[4]), .B1(n5955), .Y(n6182) );
  AO22X1 U3681 ( .A0(n5949), .A1(iSDIDatCon[18]), .B0(BlkNumCnt[3]), .B1(n5955), .Y(n6176) );
  OAI32X1 U3682 ( .A0(n5936), .A1(n6340), .A2(n6347), .B0(n5988), .B1(n6368), 
        .Y(n6144) );
  OAI221X1 U3683 ( .A0(n6340), .A1(n5962), .B0(n6376), .B1(n6151), .C0(n6152), 
        .Y(n6148) );
  AOI22X1 U3684 ( .A0(CmdArg[15]), .A1(n5943), .B0(BlkCnt[15]), .B1(n5955), 
        .Y(n6152) );
  AO21X1 U3685 ( .A0(RspCrcSet), .A1(n6344), .B0(n5905), .Y(n5716) );
  AOI211X1 U3686 ( .A0(PWDATA[14]), .A1(n5820), .B0(n5906), .C0(n6353), .Y(
        n5905) );
  OA21X2 U3687 ( .A0(n5816), .A1(PWDATA[12]), .B0(n5901), .Y(n5906) );
  AO21X1 U3688 ( .A0(CmdSentSet), .A1(n6344), .B0(n5902), .Y(n5717) );
  AOI211X1 U3689 ( .A0(PWDATA[13]), .A1(n5820), .B0(n5903), .C0(n6375), .Y(
        n5902) );
  OA21X2 U3690 ( .A0(n5816), .A1(PWDATA[11]), .B0(n5901), .Y(n5903) );
  AO21X1 U3691 ( .A0(CmdToutSet), .A1(n6344), .B0(n5898), .Y(n5718) );
  AOI211X1 U3692 ( .A0(PWDATA[12]), .A1(n5820), .B0(n5899), .C0(n6332), .Y(
        n5898) );
  OA21X2 U3693 ( .A0(n5816), .A1(PWDATA[10]), .B0(n5901), .Y(n5899) );
  NAND4BX1 U3694 ( .AN(n6096), .B(n6097), .C(n6098), .D(n6099), .Y(n6095) );
  AOI221X1 U3695 ( .A0(n5949), .A1(iSDIDatCon[11]), .B0(ResponseCMD18[11]), 
        .B1(n6385), .C0(n6105), .Y(n6097) );
  AOI221X1 U3696 ( .A0(Response2[11]), .A1(n5944), .B0(Response0[11]), .B1(
        n5945), .C0(n6104), .Y(n6098) );
  AO21X1 U3697 ( .A0(PRDATA[3]), .A1(n5924), .B0(n5997), .Y(n5700) );
  NAND4BX1 U3698 ( .AN(n5998), .B(n5999), .C(n6000), .D(n6001), .Y(n5997) );
  AOI211X1 U3699 ( .A0(n5949), .A1(iSDIDatCon[3]), .B0(n6008), .C0(n6009), .Y(
        n5999) );
  AOI211X1 U3700 ( .A0(CmdArg[3]), .A1(n5943), .B0(n6006), .C0(n6007), .Y(
        n6000) );
  AO21X1 U3701 ( .A0(PRDATA[14]), .A1(n5924), .B0(n6129), .Y(n5689) );
  NAND4BX1 U3702 ( .AN(n6130), .B(n6131), .C(n6132), .D(n6133), .Y(n6129) );
  OAI2BB1X1 U3703 ( .A0N(Response3[14]), .A1N(n5941), .B0(n6139), .Y(n6130) );
  AOI221X1 U3704 ( .A0(BlkCnt[14]), .A1(n5955), .B0(n6071), .B1(RspCrcInt), 
        .C0(n6134), .Y(n6133) );
  AO21X1 U3705 ( .A0(PRDATA[13]), .A1(n5924), .B0(n6120), .Y(n5690) );
  NAND4BX1 U3706 ( .AN(n6121), .B(n6122), .C(n6123), .D(n6124), .Y(n6120) );
  OAI2BB1X1 U3707 ( .A0N(Response3[13]), .A1N(n5941), .B0(n6128), .Y(n6121) );
  AOI221X1 U3708 ( .A0(n5949), .A1(iSDIDatCon[13]), .B0(ResponseCMD18[13]), 
        .B1(n6385), .C0(n6126), .Y(n6123) );
  AO21X1 U3709 ( .A0(PRDATA[9]), .A1(n5924), .B0(n6073), .Y(n5694) );
  NAND4BX1 U3710 ( .AN(n6074), .B(n6075), .C(n6076), .D(n6077), .Y(n6073) );
  OAI2BB1X1 U3711 ( .A0N(Response3[9]), .A1N(n5941), .B0(n6081), .Y(n6074) );
  AOI221X1 U3712 ( .A0(BlkCnt[9]), .A1(n5955), .B0(n6071), .B1(CrcStaInt), 
        .C0(n6078), .Y(n6077) );
  AO21X1 U3713 ( .A0(PRDATA[7]), .A1(n5924), .B0(n6048), .Y(n5696) );
  NAND4BX1 U3714 ( .AN(n6049), .B(n6050), .C(n6051), .D(n6052), .Y(n6048) );
  AOI221X1 U3715 ( .A0(n5949), .A1(iSDIDatCon[7]), .B0(ResponseCMD18[7]), .B1(
        n6385), .C0(n6058), .Y(n6050) );
  AOI221X1 U3716 ( .A0(Response2[7]), .A1(n5944), .B0(Response0[7]), .B1(n5945), .C0(n6056), .Y(n6051) );
  AO21X1 U3717 ( .A0(PRDATA[6]), .A1(n5924), .B0(n6035), .Y(n5697) );
  NAND4BX1 U3718 ( .AN(n6036), .B(n6037), .C(n6038), .D(n6039), .Y(n6035) );
  AOI221X1 U3719 ( .A0(n5949), .A1(iSDIDatCon[6]), .B0(ResponseCMD18[6]), .B1(
        n6385), .C0(n6045), .Y(n6037) );
  AOI221X1 U3720 ( .A0(Response2[6]), .A1(n5944), .B0(Response0[6]), .B1(n5945), .C0(n6044), .Y(n6038) );
  AO21X1 U3721 ( .A0(PRDATA[5]), .A1(n5924), .B0(n6023), .Y(n5698) );
  NAND4BX1 U3722 ( .AN(n6024), .B(n6025), .C(n6026), .D(n6027), .Y(n6023) );
  AOI221X1 U3723 ( .A0(n5949), .A1(iSDIDatCon[5]), .B0(ResponseCMD18[5]), .B1(
        n6385), .C0(n6032), .Y(n6025) );
  AOI221X1 U3724 ( .A0(Response2[5]), .A1(n5944), .B0(Response0[5]), .B1(n5945), .C0(n6031), .Y(n6026) );
  AOI211X1 U3725 ( .A0(n5949), .A1(iSDIDatCon[2]), .B0(n5992), .C0(n5993), .Y(
        n5981) );
  AOI211X1 U3726 ( .A0(iSDICmdCon[2]), .A1(n5930), .B0(n5990), .C0(n5991), .Y(
        n5982) );
  NAND4BX1 U3727 ( .AN(n5964), .B(n5965), .C(n5966), .D(n5967), .Y(n5963) );
  AOI222X1 U3728 ( .A0(CmdArg[1]), .A1(n5943), .B0(Response2[1]), .B1(n5944), 
        .C0(Response0[1]), .C1(n5945), .Y(n5965) );
  AOI222X1 U3729 ( .A0(iSDICmdCon[1]), .A1(n5930), .B0(n5931), .B1(iSDIPRE[1]), 
        .C0(RspIndex[1]), .C1(n5932), .Y(n5967) );
  AOI222X1 U3730 ( .A0(CmdArg[0]), .A1(n5943), .B0(Response2[0]), .B1(n5944), 
        .C0(Response0[0]), .C1(n5945), .Y(n5927) );
  AOI222X1 U3731 ( .A0(iSDICmdCon[0]), .A1(n5930), .B0(n5931), .B1(iSDIPRE[0]), 
        .C0(RspIndex[0]), .C1(n5932), .Y(n5929) );
  OAI211X1 U3732 ( .A0(n6140), .A1(n5605), .B0(n6236), .C0(n6237), .Y(n5672)
         );
  AOI211X1 U3733 ( .A0(n5949), .A1(iSDIDatCon[30]), .B0(n6242), .C0(n6243), 
        .Y(n6236) );
  AOI221X1 U3734 ( .A0(Response1[31]), .A1(n5933), .B0(Response3[31]), .B1(
        n5941), .C0(n6238), .Y(n6237) );
  AO22X1 U3735 ( .A0(FIFOdata[31]), .A1(RxRdPtrInc), .B0(ResponseCMD18[31]), 
        .B1(n6385), .Y(n6242) );
  OAI211X1 U3736 ( .A0(n6140), .A1(n5604), .B0(n6231), .C0(n6232), .Y(n5673)
         );
  AOI211X1 U3737 ( .A0(n5949), .A1(iSDIDatCon[29]), .B0(n6234), .C0(n6235), 
        .Y(n6231) );
  AOI221X1 U3738 ( .A0(Response1[30]), .A1(n5933), .B0(Response3[30]), .B1(
        n5941), .C0(n6233), .Y(n6232) );
  AO22X1 U3739 ( .A0(FIFOdata[30]), .A1(RxRdPtrInc), .B0(ResponseCMD18[30]), 
        .B1(n6385), .Y(n6234) );
  OAI211X1 U3740 ( .A0(n6140), .A1(n5603), .B0(n6226), .C0(n6227), .Y(n5674)
         );
  AOI211X1 U3741 ( .A0(n5949), .A1(iSDIDatCon[28]), .B0(n6229), .C0(n6230), 
        .Y(n6226) );
  AOI221X1 U3742 ( .A0(Response1[29]), .A1(n5933), .B0(Response3[29]), .B1(
        n5941), .C0(n6228), .Y(n6227) );
  AO22X1 U3743 ( .A0(FIFOdata[29]), .A1(RxRdPtrInc), .B0(ResponseCMD18[29]), 
        .B1(n6385), .Y(n6229) );
  OAI211X1 U3744 ( .A0(n6140), .A1(n5602), .B0(n6221), .C0(n6222), .Y(n5675)
         );
  AOI211X1 U3745 ( .A0(n5949), .A1(iSDIDatCon[27]), .B0(n6224), .C0(n6225), 
        .Y(n6221) );
  AOI221X1 U3746 ( .A0(Response1[28]), .A1(n5933), .B0(Response3[28]), .B1(
        n5941), .C0(n6223), .Y(n6222) );
  AO22X1 U3747 ( .A0(FIFOdata[28]), .A1(RxRdPtrInc), .B0(ResponseCMD18[28]), 
        .B1(n6395), .Y(n6224) );
  OAI211X1 U3748 ( .A0(n6140), .A1(n5601), .B0(n6216), .C0(n6217), .Y(n5676)
         );
  AOI211X1 U3749 ( .A0(n5949), .A1(iSDIDatCon[26]), .B0(n6219), .C0(n6220), 
        .Y(n6216) );
  AOI221X1 U3750 ( .A0(Response1[27]), .A1(n5933), .B0(Response3[27]), .B1(
        n5941), .C0(n6218), .Y(n6217) );
  AO22X1 U3751 ( .A0(FIFOdata[27]), .A1(RxRdPtrInc), .B0(ResponseCMD18[27]), 
        .B1(n6385), .Y(n6219) );
  OAI211X1 U3752 ( .A0(n6140), .A1(n5600), .B0(n6211), .C0(n6212), .Y(n5677)
         );
  AOI211X1 U3753 ( .A0(n5949), .A1(iSDIDatCon[25]), .B0(n6214), .C0(n6215), 
        .Y(n6211) );
  AOI221X1 U3754 ( .A0(Response1[26]), .A1(n5933), .B0(Response3[26]), .B1(
        n5941), .C0(n6213), .Y(n6212) );
  AO22X1 U3755 ( .A0(FIFOdata[26]), .A1(RxRdPtrInc), .B0(ResponseCMD18[26]), 
        .B1(n6385), .Y(n6214) );
  OAI211X1 U3756 ( .A0(n6140), .A1(n5599), .B0(n6206), .C0(n6207), .Y(n5678)
         );
  AOI211X1 U3757 ( .A0(n5949), .A1(iSDIDatCon[24]), .B0(n6209), .C0(n6210), 
        .Y(n6206) );
  AOI221X1 U3758 ( .A0(Response1[25]), .A1(n5933), .B0(Response3[25]), .B1(
        n5941), .C0(n6208), .Y(n6207) );
  AO22X1 U3759 ( .A0(FIFOdata[25]), .A1(RxRdPtrInc), .B0(ResponseCMD18[25]), 
        .B1(n6385), .Y(n6209) );
  OAI211X1 U3760 ( .A0(n6140), .A1(n5598), .B0(n6201), .C0(n6202), .Y(n5679)
         );
  AOI211X1 U3761 ( .A0(n5949), .A1(iSDIDatCon[23]), .B0(n6204), .C0(n6205), 
        .Y(n6201) );
  AOI221X1 U3762 ( .A0(Response1[24]), .A1(n5933), .B0(Response3[24]), .B1(
        n5941), .C0(n6203), .Y(n6202) );
  AO22X1 U3763 ( .A0(FIFOdata[24]), .A1(RxRdPtrInc), .B0(ResponseCMD18[24]), 
        .B1(n6385), .Y(n6204) );
  OAI211X1 U3764 ( .A0(n6140), .A1(n5597), .B0(n6196), .C0(n6197), .Y(n5680)
         );
  AOI211X1 U3765 ( .A0(n5949), .A1(iSDIDatCon[22]), .B0(n6199), .C0(n6200), 
        .Y(n6196) );
  AOI221X1 U3766 ( .A0(Response1[23]), .A1(n5933), .B0(Response3[23]), .B1(
        n5941), .C0(n6198), .Y(n6197) );
  AO22X1 U3767 ( .A0(FIFOdata[23]), .A1(RxRdPtrInc), .B0(ResponseCMD18[23]), 
        .B1(n6395), .Y(n6199) );
  OAI211X1 U3768 ( .A0(n6140), .A1(n5596), .B0(n6189), .C0(n6190), .Y(n5681)
         );
  AOI211X1 U3769 ( .A0(ResponseCMD18[22]), .A1(n6385), .B0(n6193), .C0(n6194), 
        .Y(n6189) );
  AOI211X1 U3770 ( .A0(CmdArg[22]), .A1(n5943), .B0(n6191), .C0(n6192), .Y(
        n6190) );
  AO22X1 U3771 ( .A0(FIFOdata[22]), .A1(RxRdPtrInc), .B0(n5953), .B1(
        iDataTimer[22]), .Y(n6193) );
  OAI211X1 U3772 ( .A0(n6140), .A1(n5595), .B0(n6183), .C0(n6184), .Y(n5682)
         );
  AOI211X1 U3773 ( .A0(ResponseCMD18[21]), .A1(n6385), .B0(n6187), .C0(n6188), 
        .Y(n6183) );
  AOI211X1 U3774 ( .A0(CmdArg[21]), .A1(n5943), .B0(n6185), .C0(n6186), .Y(
        n6184) );
  AO22X1 U3775 ( .A0(FIFOdata[21]), .A1(RxRdPtrInc), .B0(n5953), .B1(
        iDataTimer[21]), .Y(n6187) );
  OAI211X1 U3776 ( .A0(n6140), .A1(n5594), .B0(n6177), .C0(n6178), .Y(n5683)
         );
  AOI211X1 U3777 ( .A0(ResponseCMD18[20]), .A1(n6385), .B0(n6181), .C0(n6182), 
        .Y(n6177) );
  AOI211X1 U3778 ( .A0(CmdArg[20]), .A1(n5943), .B0(n6179), .C0(n6180), .Y(
        n6178) );
  AO22X1 U3779 ( .A0(FIFOdata[20]), .A1(RxRdPtrInc), .B0(n5953), .B1(
        iDataTimer[20]), .Y(n6181) );
  OAI211X1 U3780 ( .A0(n6140), .A1(n5593), .B0(n6171), .C0(n6172), .Y(n5684)
         );
  AOI211X1 U3781 ( .A0(ResponseCMD18[19]), .A1(n6385), .B0(n6175), .C0(n6176), 
        .Y(n6171) );
  AOI211X1 U3782 ( .A0(CmdArg[19]), .A1(n5943), .B0(n6173), .C0(n6174), .Y(
        n6172) );
  AO22X1 U3783 ( .A0(FIFOdata[19]), .A1(RxRdPtrInc), .B0(n5953), .B1(
        iDataTimer[19]), .Y(n6175) );
  OAI211X1 U3784 ( .A0(n6140), .A1(n5589), .B0(n6141), .C0(n6142), .Y(n5688)
         );
  AOI211X1 U3785 ( .A0(Response3[15]), .A1(n5941), .B0(n6143), .C0(n6144), .Y(
        n6142) );
  AOI211X1 U3786 ( .A0(FIFOdata[15]), .A1(RxRdPtrInc), .B0(n6148), .C0(n6149), 
        .Y(n6141) );
  AO21X1 U3787 ( .A0(Response0[15]), .A1(n5945), .B0(n6147), .Y(n6143) );
  AOI21X1 U3788 ( .A0(PWDATA[11]), .A1(n5820), .B0(n5816), .Y(n6399) );
  INVX1 U3789 ( .A(n6291), .Y(n5881) );
  NAND2BX1 U3790 ( .AN(n5816), .B(PWDATA[4]), .Y(n6291) );
  INVX1 U3791 ( .A(n6302), .Y(n5845) );
  NAND2BX1 U3792 ( .AN(n5816), .B(PWDATA[15]), .Y(n6302) );
  INVX1 U3793 ( .A(n6301), .Y(n5844) );
  NAND2BX1 U3794 ( .AN(n5816), .B(PWDATA[14]), .Y(n6301) );
  INVX1 U3795 ( .A(n6300), .Y(n5843) );
  NAND2BX1 U3796 ( .AN(n5816), .B(PWDATA[13]), .Y(n6300) );
  INVX1 U3797 ( .A(n6299), .Y(n5842) );
  NAND2BX1 U3798 ( .AN(n5816), .B(PWDATA[12]), .Y(n6299) );
  INVX1 U3799 ( .A(n6298), .Y(n5841) );
  NAND2BX1 U3800 ( .AN(n5816), .B(PWDATA[11]), .Y(n6298) );
  INVX1 U3801 ( .A(n6297), .Y(n5840) );
  NAND2BX1 U3802 ( .AN(n5816), .B(PWDATA[10]), .Y(n6297) );
  INVX1 U3803 ( .A(n6296), .Y(n5839) );
  NAND2BX1 U3804 ( .AN(n5816), .B(PWDATA[9]), .Y(n6296) );
  INVX1 U3805 ( .A(n6295), .Y(n5838) );
  NAND2BX1 U3806 ( .AN(n5816), .B(PWDATA[8]), .Y(n6295) );
  INVX1 U3807 ( .A(n6294), .Y(n5837) );
  NAND2BX1 U3808 ( .AN(n5816), .B(PWDATA[7]), .Y(n6294) );
  INVX1 U3809 ( .A(n6289), .Y(n5833) );
  NAND2BX1 U3810 ( .AN(n5816), .B(PWDATA[2]), .Y(n6289) );
  INVX1 U3811 ( .A(n6288), .Y(n5832) );
  NAND2BX1 U3812 ( .AN(n5816), .B(PWDATA[1]), .Y(n6288) );
  INVX1 U3813 ( .A(n6287), .Y(n5829) );
  NAND2BX1 U3814 ( .AN(n5816), .B(PWDATA[0]), .Y(n6287) );
  NAND3BX1 U3815 ( .AN(n5921), .B(PWDATA[8]), .C(n6306), .Y(n6311) );
  INVX1 U3816 ( .A(PWDATA[9]), .Y(n5870) );
  INVX1 U3817 ( .A(PWDATA[7]), .Y(n5864) );
  INVX1 U3818 ( .A(PWDATA[6]), .Y(n5861) );
  INVX1 U3819 ( .A(PWDATA[5]), .Y(n5857) );
  INVX1 U3820 ( .A(PWDATA[15]), .Y(n5874) );
  INVX1 U3821 ( .A(n6293), .Y(n5836) );
  NAND2BX1 U3822 ( .AN(n5816), .B(PWDATA[6]), .Y(n6293) );
  INVX1 U3823 ( .A(n6292), .Y(n5835) );
  NAND2BX1 U3824 ( .AN(n5816), .B(PWDATA[5]), .Y(n6292) );
  INVX1 U3825 ( .A(n6290), .Y(n5834) );
  NAND2BX1 U3826 ( .AN(n5816), .B(PWDATA[3]), .Y(n6290) );
  AO22X1 U3827 ( .A0(DelaySel[2]), .A1(n5922), .B0(n5923), .B1(PWDATA[2]), .Y(
        n5606) );
  AO22X1 U3828 ( .A0(DelaySel[1]), .A1(n5922), .B0(n5923), .B1(PWDATA[1]), .Y(
        n5607) );
  AO22X1 U3829 ( .A0(DelaySel[0]), .A1(n5922), .B0(n5923), .B1(PWDATA[0]), .Y(
        n5608) );
  AO22X1 U3830 ( .A0(InvSel), .A1(n5922), .B0(n5923), .B1(PWDATA[3]), .Y(n5704) );
  AND4X1 U3831 ( .A(PWDATA[16]), .B(PADDR[4]), .C(n6278), .D(n5876), .Y(
        FRST3958) );
  OAI32X1 U3832 ( .A0(n5816), .A1(n6374), .A2(CMSTClr), .B0(n5816), .B1(n5805), 
        .Y(n5715) );
  OAI32X1 U3833 ( .A0(n5816), .A1(n6346), .A2(RCmdStartClr), .B0(n5816), .B1(
        n5804), .Y(n5803) );
  OAI221X1 U3834 ( .A0(n6345), .A1(n5987), .B0(n6337), .B1(n6004), .C0(n6323), 
        .Y(n6317) );
  OA22X1 U3835 ( .A0(n6380), .A1(n6353), .B0(n6334), .B1(n6343), .Y(n6323) );
  AOI222X1 U3836 ( .A0(CmdSent), .A1(CmdSentInt), .B0(AutoCMDCompleteInt), 
        .B1(AutoCMDComplete), .C0(BusyFin), .C1(BusyFinInt), .Y(n6322) );
  AOI222X1 U3837 ( .A0(R18ErrorInt), .A1(R18Error), .B0(NoBusy), .B1(NoBusyInt), .C0(R12ErrorInt), .C1(R12Error), .Y(n6325) );
  DFFRX1 iSDIDatCon_reg_20_ ( .D(n5753), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[20]) );
  DFFRX1 iSDIDatCon_reg_19_ ( .D(n5754), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[19]) );
  DFFRX1 PRDATA_reg_14_ ( .D(n5689), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[14])
         );
  DFFRX1 PRDATA_reg_13_ ( .D(n5690), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[13])
         );
  DFFRX1 PRDATA_reg_11_ ( .D(n5692), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[11])
         );
  DFFRX1 PRDATA_reg_9_ ( .D(n5694), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[9]) );
  DFFRX1 PRDATA_reg_7_ ( .D(n5696), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[7]) );
  DFFRX1 PRDATA_reg_6_ ( .D(n5697), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[6]) );
  DFFRX1 PRDATA_reg_5_ ( .D(n5698), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[5]) );
  DFFRX1 PRDATA_reg_3_ ( .D(n5700), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[3]) );
  DFFRX1 PRDATA_reg_16_ ( .D(n5687), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[16])
         );
  DFFRX1 PRDATA_reg_12_ ( .D(n5691), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[12])
         );
  DFFRX1 PRDATA_reg_10_ ( .D(n5693), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[10])
         );
  DFFRX1 PRDATA_reg_8_ ( .D(n5695), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[8]) );
  DFFRX1 PRDATA_reg_4_ ( .D(n5699), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[4]) );
  DFFRX1 PRDATA_reg_31_ ( .D(n5672), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[31]), 
        .QN(n5605) );
  DFFRX1 PRDATA_reg_30_ ( .D(n5673), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[30]), 
        .QN(n5604) );
  DFFRX1 PRDATA_reg_29_ ( .D(n5674), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[29]), 
        .QN(n5603) );
  DFFRX1 PRDATA_reg_28_ ( .D(n5675), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[28]), 
        .QN(n5602) );
  DFFRX1 PRDATA_reg_27_ ( .D(n5676), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[27]), 
        .QN(n5601) );
  DFFRX1 PRDATA_reg_26_ ( .D(n5677), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[26]), 
        .QN(n5600) );
  DFFRX1 PRDATA_reg_25_ ( .D(n5678), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[25]), 
        .QN(n5599) );
  DFFRX1 PRDATA_reg_24_ ( .D(n5679), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[24]), 
        .QN(n5598) );
  DFFRX1 PRDATA_reg_23_ ( .D(n5680), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[23]), 
        .QN(n5597) );
  DFFRX1 PRDATA_reg_22_ ( .D(n5681), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[22]), 
        .QN(n5596) );
  DFFRX1 PRDATA_reg_21_ ( .D(n5682), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[21]), 
        .QN(n5595) );
  DFFRX1 PRDATA_reg_20_ ( .D(n5683), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[20]), 
        .QN(n5594) );
  DFFRX1 PRDATA_reg_19_ ( .D(n5684), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[19]), 
        .QN(n5593) );
  DFFRX1 PRDATA_reg_15_ ( .D(n5688), .CK(PCLK), .RN(PRESETn), .Q(PRDATA[15]), 
        .QN(n5589) );
  DFFRX1 PSAVEON_reg ( .D(n5706), .CK(PCLK), .RN(PRESETn), .Q(PSAVEON), .QN(
        n6369) );
  DFFRX1 ENCLK_reg ( .D(n5705), .CK(PCLK), .RN(PRESETn), .Q(ENCLK), .QN(n6370)
         );
  DFFRX1 iAutoReadCon_reg_1_ ( .D(n5670), .CK(PCLK), .RN(PRESETn), .Q(
        iAutoReadCon[1]) );
  DFFRX1 iSDICmdCon_reg_8_ ( .D(n5645), .CK(PCLK), .RN(PRESETn), .Q(
        iSDICmdCon[8]) );
  DFFSX1 iSDIDatCon_reg_28_ ( .D(n5745), .CK(PCLK), .SN(PRESETn), .Q(
        iSDIDatCon[28]), .QN(n6373) );
  DFFRX1 CMST_reg ( .D(n5715), .CK(PCLK), .RN(PRESETn), .Q(CMST), .QN(n6374)
         );
  DFFRX1 iSDIDatCon_reg_17_ ( .D(n5756), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[17]) );
  DFFRX1 iSDIDatCon_reg_24_ ( .D(n5749), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[24]) );
  DFFRX1 iSDIDatCon_reg_26_ ( .D(n5747), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[26]) );
  DFFRX1 iSDIDatCon_reg_27_ ( .D(n5746), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[27]) );
  DFFRX1 iSDIDatCon_reg_25_ ( .D(n5748), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[25]) );
  DFFRX1 SDreset_reg ( .D(SDreset2925), .CK(PCLK), .RN(PRESETn), .Q(n5816), 
        .QN(n6344) );
  DFFRX1 iSDIDatCon_reg_23_ ( .D(n5750), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[23]) );
  DFFRX1 iSDICmdCon_reg_7_ ( .D(n5646), .CK(PCLK), .RN(PRESETn), .Q(
        iSDICmdCon[7]) );
  DFFRX1 iSDICmdCon_reg_11_ ( .D(n5642), .CK(PCLK), .RN(PRESETn), .Q(
        iSDICmdCon[11]) );
  DFFRX1 iSDIDatCon_reg_22_ ( .D(n5751), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[22]) );
  DFFRX1 DelaySel_reg_1_ ( .D(n5607), .CK(PCLK), .RN(PRESETn), .Q(DelaySel[1])
         );
  DFFRX1 DelaySel_reg_2_ ( .D(n5606), .CK(PCLK), .RN(PRESETn), .Q(DelaySel[2])
         );
  DFFRX1 DelaySel_reg_0_ ( .D(n5608), .CK(PCLK), .RN(PRESETn), .Q(DelaySel[0])
         );
  DFFRX1 iSDIDatCon_reg_30_ ( .D(n5743), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[30]) );
  DFFRX1 iAutoReadCon_reg_0_ ( .D(n5671), .CK(PCLK), .RN(PRESETn), .Q(
        iAutoReadCon[0]), .QN(n6371) );
  DFFSX1 iSDIPRE_reg_0_ ( .D(n5714), .CK(PCLK), .SN(PRESETn), .Q(iSDIPRE[0]), 
        .QN(n6377) );
  DFFSX1 iDataTimer_reg_16_ ( .D(n5726), .CK(PCLK), .SN(PRESETn), .Q(
        iDataTimer[16]), .QN(n6378) );
  DFFRX1 iSDIDatCon_reg_29_ ( .D(n5744), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[29]) );
  DFFRX1 iBlkSize_reg_0_ ( .D(n5669), .CK(PCLK), .RN(PRESETn), .Q(iBlkSize[0])
         );
  DFFRX1 iBlkSize_reg_15_ ( .D(n5654), .CK(PCLK), .RN(PRESETn), .Q(
        iBlkSize[15]), .QN(n6368) );
  DFFRX1 iBlkSize_reg_12_ ( .D(n5657), .CK(PCLK), .RN(PRESETn), .Q(
        iBlkSize[12]), .QN(n6366) );
  DFFRX1 iBlkSize_reg_11_ ( .D(n5658), .CK(PCLK), .RN(PRESETn), .Q(
        iBlkSize[11]), .QN(n6360) );
  DFFRX1 iBlkSize_reg_10_ ( .D(n5659), .CK(PCLK), .RN(PRESETn), .Q(
        iBlkSize[10]), .QN(n6367) );
  DFFRX1 iBlkSize_reg_7_ ( .D(n5662), .CK(PCLK), .RN(PRESETn), .Q(iBlkSize[7]), 
        .QN(n6361) );
  DFFRX1 iBlkSize_reg_6_ ( .D(n5663), .CK(PCLK), .RN(PRESETn), .Q(iBlkSize[6]), 
        .QN(n6362) );
  DFFRX1 iBlkSize_reg_5_ ( .D(n5664), .CK(PCLK), .RN(PRESETn), .Q(iBlkSize[5]), 
        .QN(n6363) );
  DFFRX1 iBlkSize_reg_3_ ( .D(n5666), .CK(PCLK), .RN(PRESETn), .Q(iBlkSize[3]), 
        .QN(n6364) );
  DFFRX1 iBlkSize_reg_2_ ( .D(n5667), .CK(PCLK), .RN(PRESETn), .Q(iBlkSize[2]), 
        .QN(n6365) );
  DFFRX1 iBlkSize_reg_4_ ( .D(n5665), .CK(PCLK), .RN(PRESETn), .Q(iBlkSize[4])
         );
  DFFRX1 RCmdStart_reg ( .D(n5803), .CK(PCLK), .RN(PRESETn), .Q(RCmdStart), 
        .QN(n6346) );
  DFFRX1 CmdSent_reg ( .D(n5717), .CK(PCLK), .RN(PRESETn), .Q(CmdSent), .QN(
        n6375) );
  DFFRX1 DatFin_reg ( .D(n5779), .CK(PCLK), .RN(PRESETn), .Q(DatFin), .QN(
        n6351) );
  DFFRX1 FFfail_reg ( .D(n5781), .CK(PCLK), .RN(PRESETn), .Q(FFfail), .QN(
        n6349) );
  DFFRX1 CmdToutInt_reg ( .D(n5788), .CK(PCLK), .RN(PRESETn), .Q(CmdToutInt), 
        .QN(n6342) );
  DFFRX1 FFfailInt_reg ( .D(n5790), .CK(PCLK), .RN(PRESETn), .Q(FFfailInt), 
        .QN(n6341) );
  DFFRX1 DatCrcInt_reg ( .D(n5792), .CK(PCLK), .RN(PRESETn), .Q(DatCrcInt), 
        .QN(n6357) );
  DFFRX1 iSDIDatCon_reg_15_ ( .D(n5758), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[15]), .QN(n6376) );
  DFFRX1 R18Error_reg ( .D(n5801), .CK(PCLK), .RN(PRESETn), .Q(R18Error), .QN(
        n6352) );
  DFFRX1 R12Error_reg ( .D(n5800), .CK(PCLK), .RN(PRESETn), .Q(R12Error), .QN(
        n6359) );
  DFFRX1 RspCrcInt_reg ( .D(n5786), .CK(PCLK), .RN(PRESETn), .Q(RspCrcInt), 
        .QN(n6380) );
  DFFRX1 CrcStaInt_reg ( .D(n5791), .CK(PCLK), .RN(PRESETn), .Q(CrcStaInt), 
        .QN(n6379) );
  DFFRX1 RspFin_reg ( .D(n5719), .CK(PCLK), .RN(PRESETn), .Q(RspFin), .QN(
        n6343) );
  DFFRX1 RspCrc_reg ( .D(n5716), .CK(PCLK), .RN(PRESETn), .Q(RspCrc), .QN(
        n6353) );
  DFFRX1 CrcSta_reg ( .D(n5776), .CK(PCLK), .RN(PRESETn), .Q(CrcSta), .QN(
        n6350) );
  DFFRX1 NoBusy_reg ( .D(n5775), .CK(PCLK), .RN(PRESETn), .Q(NoBusy), .QN(
        n6347) );
  DFFRX1 NoBusyInt_reg ( .D(n5785), .CK(PCLK), .RN(PRESETn), .Q(NoBusyInt), 
        .QN(n6340) );
  DFFRX1 BusyFinInt_reg ( .D(n5795), .CK(PCLK), .RN(PRESETn), .Q(BusyFinInt), 
        .QN(n6339) );
  DFFRX1 BusyFin_reg ( .D(n5780), .CK(PCLK), .RN(PRESETn), .Q(BusyFin), .QN(
        n6348) );
  DFFRX1 CmdTout_reg ( .D(n5718), .CK(PCLK), .RN(PRESETn), .Q(CmdTout), .QN(
        n6332) );
  DFFRX1 DatCrc_reg ( .D(n5777), .CK(PCLK), .RN(PRESETn), .Q(DatCrc), .QN(
        n6338) );
  DFFRX1 DatTout_reg ( .D(n5778), .CK(PCLK), .RN(PRESETn), .Q(DatTout), .QN(
        n6331) );
  DFFRX1 RspFinInt_reg ( .D(n5789), .CK(PCLK), .RN(PRESETn), .Q(RspFinInt), 
        .QN(n6334) );
  DFFRX1 DatToutInt_reg ( .D(n5793), .CK(PCLK), .RN(PRESETn), .Q(DatToutInt), 
        .QN(n6329) );
  DFFRX1 DatFinInt_reg ( .D(n5794), .CK(PCLK), .RN(PRESETn), .Q(DatFinInt), 
        .QN(n6333) );
  DFFRX1 TFHalfInt_reg ( .D(n5796), .CK(PCLK), .RN(PRESETn), .Q(TFHalfInt), 
        .QN(n6337) );
  DFFRX1 TFEmpInt_reg ( .D(n5797), .CK(PCLK), .RN(PRESETn), .Q(TFEmpInt), .QN(
        n6345) );
  DFFRX1 RFFullInt_reg ( .D(n5798), .CK(PCLK), .RN(PRESETn), .Q(RFFullInt), 
        .QN(n6336) );
  DFFRX1 RFHalfInt_reg ( .D(n5799), .CK(PCLK), .RN(PRESETn), .Q(RFHalfInt), 
        .QN(n6330) );
  DFFRX1 iSDIDatCon_reg_18_ ( .D(n5755), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[18]) );
  DFFRX1 CmdArg_reg_15_ ( .D(n5625), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[15])
         );
  DFFRX1 InvSel_reg ( .D(n5704), .CK(PCLK), .RN(PRESETn), .Q(InvSel) );
  DFFRX1 CmdArg_reg_2_ ( .D(n5638), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[2]) );
  DFFRX1 CmdArg_reg_31_ ( .D(n5609), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[31])
         );
  DFFRX1 CmdArg_reg_30_ ( .D(n5610), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[30])
         );
  DFFRX1 CmdArg_reg_29_ ( .D(n5611), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[29])
         );
  DFFRX1 CmdArg_reg_28_ ( .D(n5612), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[28])
         );
  DFFRX1 CmdArg_reg_27_ ( .D(n5613), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[27])
         );
  DFFRX1 CmdArg_reg_25_ ( .D(n5615), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[25])
         );
  DFFRX1 CmdArg_reg_24_ ( .D(n5616), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[24])
         );
  DFFRX1 CmdArg_reg_23_ ( .D(n5617), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[23])
         );
  DFFRX1 CmdArg_reg_12_ ( .D(n5628), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[12])
         );
  DFFRX1 CmdArg_reg_11_ ( .D(n5629), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[11])
         );
  DFFRX1 CmdArg_reg_10_ ( .D(n5630), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[10])
         );
  DFFRX1 CmdArg_reg_7_ ( .D(n5633), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[7]) );
  DFFRX1 CmdArg_reg_6_ ( .D(n5634), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[6]) );
  DFFRX1 CmdArg_reg_5_ ( .D(n5635), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[5]) );
  DFFRX1 CmdArg_reg_26_ ( .D(n5614), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[26])
         );
  DFFRX1 iBlkSize_reg_1_ ( .D(n5668), .CK(PCLK), .RN(PRESETn), .Q(iBlkSize[1])
         );
  DFFRX1 iSDIPRE_reg_7_ ( .D(n5707), .CK(PCLK), .RN(PRESETn), .Q(iSDIPRE[7])
         );
  DFFRX1 iSDIPRE_reg_6_ ( .D(n5708), .CK(PCLK), .RN(PRESETn), .Q(iSDIPRE[6])
         );
  DFFRX1 iSDIPRE_reg_5_ ( .D(n5709), .CK(PCLK), .RN(PRESETn), .Q(iSDIPRE[5])
         );
  DFFRX1 iSDIPRE_reg_2_ ( .D(n5712), .CK(PCLK), .RN(PRESETn), .Q(iSDIPRE[2])
         );
  DFFRX1 CmdSentInt_reg ( .D(n5787), .CK(PCLK), .RN(PRESETn), .Q(CmdSentInt)
         );
  DFFRX1 iSDICmdCon_reg_12_ ( .D(n5641), .CK(PCLK), .RN(PRESETn), .Q(
        iSDICmdCon[12]) );
  DFFRX1 iSDIPRE_reg_4_ ( .D(n5710), .CK(PCLK), .RN(PRESETn), .Q(iSDIPRE[4])
         );
  DFFRX1 iSDIPRE_reg_3_ ( .D(n5711), .CK(PCLK), .RN(PRESETn), .Q(iSDIPRE[3])
         );
  DFFRX1 iDataTimer_reg_22_ ( .D(n5720), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[22]) );
  DFFRX1 iDataTimer_reg_21_ ( .D(n5721), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[21]) );
  DFFRX1 iDataTimer_reg_20_ ( .D(n5722), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[20]) );
  DFFRX1 iDataTimer_reg_19_ ( .D(n5723), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[19]) );
  DFFRX1 iDataTimer_reg_15_ ( .D(n5727), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[15]) );
  DFFRX1 iSDIPRE_reg_1_ ( .D(n5713), .CK(PCLK), .RN(PRESETn), .Q(iSDIPRE[1])
         );
  DFFRX1 iSDICmdCon_reg_1_ ( .D(n5652), .CK(PCLK), .RN(PRESETn), .Q(
        iSDICmdCon[1]) );
  DFFRX1 iSDICmdCon_reg_0_ ( .D(n5653), .CK(PCLK), .RN(PRESETn), .Q(
        iSDICmdCon[0]) );
  DFFRX1 iDataTimer_reg_18_ ( .D(n5724), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[18]) );
  DFFRX1 iDataTimer_reg_17_ ( .D(n5725), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[17]) );
  DFFRX1 iDataTimer_reg_0_ ( .D(n5742), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[0]) );
  DFFRX1 iSDICmdCon_reg_3_ ( .D(n5650), .CK(PCLK), .RN(PRESETn), .Q(
        iSDICmdCon[3]) );
  DFFRX1 iSDICmdCon_reg_4_ ( .D(n5649), .CK(PCLK), .RN(PRESETn), .Q(
        iSDICmdCon[4]) );
  DFFRX1 iSDICmdCon_reg_2_ ( .D(n5651), .CK(PCLK), .RN(PRESETn), .Q(
        iSDICmdCon[2]) );
  DFFRX1 R18ErrorInt_reg ( .D(n5784), .CK(PCLK), .RN(PRESETn), .Q(R18ErrorInt)
         );
  DFFRX1 iDataTimer_reg_4_ ( .D(n5738), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[4]) );
  DFFRX1 iSDICmdCon_reg_6_ ( .D(n5647), .CK(PCLK), .RN(PRESETn), .Q(
        iSDICmdCon[6]) );
  DFFRX1 iSDICmdCon_reg_5_ ( .D(n5648), .CK(PCLK), .RN(PRESETn), .Q(
        iSDICmdCon[5]) );
  DFFRX1 AutoCMDCompleteInt_reg ( .D(n5782), .CK(PCLK), .RN(PRESETn), .Q(
        AutoCMDCompleteInt) );
  DFFRX1 iSDIDatCon_reg_1_ ( .D(n5772), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[1]) );
  DFFRX1 iSDIDatCon_reg_0_ ( .D(n5773), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[0]) );
  DFFRX1 iDataTimer_reg_14_ ( .D(n5728), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[14]) );
  DFFRX1 iDataTimer_reg_13_ ( .D(n5729), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[13]) );
  DFFRX1 iDataTimer_reg_12_ ( .D(n5730), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[12]) );
  DFFRX1 iDataTimer_reg_11_ ( .D(n5731), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[11]) );
  DFFRX1 iDataTimer_reg_10_ ( .D(n5732), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[10]) );
  DFFRX1 iDataTimer_reg_9_ ( .D(n5733), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[9]) );
  DFFRX1 iDataTimer_reg_8_ ( .D(n5734), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[8]) );
  DFFRX1 iDataTimer_reg_7_ ( .D(n5735), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[7]) );
  DFFRX1 iDataTimer_reg_6_ ( .D(n5736), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[6]) );
  DFFRX1 iDataTimer_reg_5_ ( .D(n5737), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[5]) );
  DFFRX1 iDataTimer_reg_3_ ( .D(n5739), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[3]) );
  DFFRX1 iDataTimer_reg_2_ ( .D(n5740), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[2]) );
  DFFRX1 iDataTimer_reg_1_ ( .D(n5741), .CK(PCLK), .RN(PRESETn), .Q(
        iDataTimer[1]) );
  DFFRX1 R12ErrorInt_reg ( .D(n5783), .CK(PCLK), .RN(PRESETn), .Q(R12ErrorInt)
         );
  DFFRX1 iSDIDatCon_reg_21_ ( .D(n5752), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[21]) );
  DFFRX1 FRST_reg ( .D(FRST3958), .CK(PCLK), .RN(PRESETn), .Q(FRST) );
  DFFRX1 iSDICmdCon_reg_9_ ( .D(n5644), .CK(PCLK), .RN(PRESETn), .Q(
        iSDICmdCon[9]) );
  DFFRX1 AutoCMDComplete_reg ( .D(n5802), .CK(PCLK), .RN(PRESETn), .Q(
        AutoCMDComplete), .QN(n6358) );
  DFFRX1 CmdArg_reg_18_ ( .D(n5622), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[18])
         );
  DFFRX1 CmdArg_reg_17_ ( .D(n5623), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[17])
         );
  DFFRX1 CmdArg_reg_16_ ( .D(n5624), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[16])
         );
  DFFRX1 CmdArg_reg_1_ ( .D(n5639), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[1]) );
  DFFRX1 CmdArg_reg_0_ ( .D(n5640), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[0]) );
  DFFRX1 CmdArg_reg_14_ ( .D(n5626), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[14])
         );
  DFFRX1 CmdArg_reg_13_ ( .D(n5627), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[13])
         );
  DFFRX1 CmdArg_reg_9_ ( .D(n5631), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[9]) );
  DFFRX1 CmdArg_reg_8_ ( .D(n5632), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[8]) );
  DFFRX1 CmdArg_reg_4_ ( .D(n5636), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[4]) );
  DFFRX1 CmdArg_reg_22_ ( .D(n5618), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[22])
         );
  DFFRX1 CmdArg_reg_21_ ( .D(n5619), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[21])
         );
  DFFRX1 CmdArg_reg_20_ ( .D(n5620), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[20])
         );
  DFFRX1 CmdArg_reg_19_ ( .D(n5621), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[19])
         );
  DFFRX1 CmdArg_reg_3_ ( .D(n5637), .CK(PCLK), .RN(PRESETn), .Q(CmdArg[3]) );
  DFFRX1 iBlkSize_reg_14_ ( .D(n5655), .CK(PCLK), .RN(PRESETn), .Q(
        iBlkSize[14]) );
  DFFRX1 iBlkSize_reg_13_ ( .D(n5656), .CK(PCLK), .RN(PRESETn), .Q(
        iBlkSize[13]) );
  DFFRX1 iBlkSize_reg_9_ ( .D(n5660), .CK(PCLK), .RN(PRESETn), .Q(iBlkSize[9])
         );
  DFFRX1 iBlkSize_reg_8_ ( .D(n5661), .CK(PCLK), .RN(PRESETn), .Q(iBlkSize[8])
         );
  DFFRX1 iSDIDatCon_reg_14_ ( .D(n5759), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[14]) );
  DFFRX1 iSDIDatCon_reg_13_ ( .D(n5760), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[13]) );
  DFFRX1 iSDIDatCon_reg_12_ ( .D(n5761), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[12]) );
  DFFRX1 iSDIDatCon_reg_11_ ( .D(n5762), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[11]) );
  DFFRX1 iSDIDatCon_reg_10_ ( .D(n5763), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[10]) );
  DFFRX1 iSDIDatCon_reg_9_ ( .D(n5764), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[9]) );
  DFFRX1 iSDIDatCon_reg_8_ ( .D(n5765), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[8]) );
  DFFRX1 iSDIDatCon_reg_7_ ( .D(n5766), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[7]) );
  DFFRX1 iSDIDatCon_reg_6_ ( .D(n5767), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[6]) );
  DFFRX1 iSDIDatCon_reg_5_ ( .D(n5768), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[5]) );
  DFFRX1 iSDIDatCon_reg_4_ ( .D(n5769), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[4]) );
  DFFRX1 iSDICmdCon_reg_10_ ( .D(n5643), .CK(PCLK), .RN(PRESETn), .Q(
        iSDICmdCon[10]) );
  DFFRX1 iSDIDatCon_reg_3_ ( .D(n5770), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[3]) );
  DFFRX1 iSDIDatCon_reg_2_ ( .D(n5771), .CK(PCLK), .RN(PRESETn), .Q(
        iSDIDatCon[2]) );
  DFFRX1 RCmdStartSet_reg ( .D(RCmdStartSet4533), .CK(PCLK), .RN(PRESETn), 
        .QN(n5804) );
  DFFRX1 CMSTSet_reg ( .D(CMSTSet3211), .CK(PCLK), .RN(PRESETn), .QN(n5805) );
  NAND4BX1 U3838 ( .AN(n6255), .B(n5940), .C(n6256), .D(n6010), .Y(n6247) );
endmodule


module mmc_Prescaler ( PCLK, nRst, SDreset, SDIPRE, ENCLK, MMC_CLK, 
        neg_CKPulse, CKPulse );
  input [7:0] SDIPRE;
  input PCLK, nRst, SDreset, ENCLK;
  output MMC_CLK, neg_CKPulse, CKPulse;
  wire   ClkDivCnt_7_, ClkDivCnt_6_, ClkDivCnt_5_, ClkDivCnt_4_, ClkDivCnt_3_,
         ClkDivCnt_2_, ClkDivCnt_1_, ClkDivCnt_0_, CntState175,
         ClkDivCnt291_7_, ClkDivCnt291_6_, ClkDivCnt291_5_, ClkDivCnt291_4_,
         ClkDivCnt291_3_, ClkDivCnt291_2_, ClkDivCnt291_1_, ClkDivCnt291_0_,
         ClkDivCnt316_7_, ClkDivCnt316_6_, ClkDivCnt316_5_, ClkDivCnt316_4_,
         ClkDivCnt316_3_, ClkDivCnt316_2_, ClkDivCnt316_1_, n400, n402, n403,
         n404, n405, n406, n418, carry_7_, carry_6_, carry_5_, carry_4_,
         carry_3_, carry_2_, n419, n420, n422, n424, n425, n426, n427, n428,
         n429, n430, n431, n432;

  NOR3BX1 U180 ( .AN(ENCLK), .B(n419), .C(MMC_CLK), .Y(CKPulse) );
  NOR2BX1 U181 ( .AN(MMC_CLK), .B(n419), .Y(neg_CKPulse) );
  INVX1 U182 ( .A(n426), .Y(n420) );
  NAND2BX1 U183 ( .AN(n425), .B(n427), .Y(n426) );
  INVX1 U184 ( .A(n424), .Y(n422) );
  NAND2BX1 U185 ( .AN(n425), .B(n419), .Y(n424) );
  INVX1 U186 ( .A(CntState175), .Y(n425) );
  INVX1 U187 ( .A(n419), .Y(n427) );
  NAND4BX1 U188 ( .AN(ClkDivCnt_1_), .B(n431), .C(n429), .D(n430), .Y(n419) );
  AND4X1 U189 ( .A(n403), .B(n404), .C(n405), .D(n406), .Y(n430) );
  NOR2BX1 U190 ( .AN(n402), .B(ClkDivCnt_3_), .Y(n429) );
  OAI32X1 U191 ( .A0(n427), .A1(SDreset), .A2(n400), .B0(SDreset), .B1(n428), 
        .Y(CntState175) );
  INVX1 U192 ( .A(ENCLK), .Y(n428) );
  AO22X1 U193 ( .A0(n420), .A1(n432), .B0(n422), .B1(MMC_CLK), .Y(n418) );
  AO22X1 U194 ( .A0(SDIPRE[0]), .A1(n420), .B0(n422), .B1(n431), .Y(
        ClkDivCnt291_0_) );
  AO22X1 U195 ( .A0(SDIPRE[1]), .A1(n420), .B0(ClkDivCnt316_1_), .B1(n422), 
        .Y(ClkDivCnt291_1_) );
  XNOR2X1 U1_A_1 ( .A(ClkDivCnt_1_), .B(ClkDivCnt_0_), .Y(ClkDivCnt316_1_) );
  AO22X1 U196 ( .A0(SDIPRE[2]), .A1(n420), .B0(ClkDivCnt316_2_), .B1(n422), 
        .Y(ClkDivCnt291_2_) );
  XNOR2X1 U1_A_2 ( .A(ClkDivCnt_2_), .B(carry_2_), .Y(ClkDivCnt316_2_) );
  AO22X1 U197 ( .A0(SDIPRE[3]), .A1(n420), .B0(ClkDivCnt316_3_), .B1(n422), 
        .Y(ClkDivCnt291_3_) );
  XNOR2X1 U1_A_3 ( .A(ClkDivCnt_3_), .B(carry_3_), .Y(ClkDivCnt316_3_) );
  AO22X1 U198 ( .A0(SDIPRE[4]), .A1(n420), .B0(ClkDivCnt316_4_), .B1(n422), 
        .Y(ClkDivCnt291_4_) );
  XNOR2X1 U1_A_4 ( .A(ClkDivCnt_4_), .B(carry_4_), .Y(ClkDivCnt316_4_) );
  AO22X1 U199 ( .A0(SDIPRE[5]), .A1(n420), .B0(ClkDivCnt316_5_), .B1(n422), 
        .Y(ClkDivCnt291_5_) );
  XNOR2X1 U1_A_5 ( .A(ClkDivCnt_5_), .B(carry_5_), .Y(ClkDivCnt316_5_) );
  AO22X1 U200 ( .A0(SDIPRE[6]), .A1(n420), .B0(ClkDivCnt316_6_), .B1(n422), 
        .Y(ClkDivCnt291_6_) );
  XNOR2X1 U1_A_6 ( .A(ClkDivCnt_6_), .B(carry_6_), .Y(ClkDivCnt316_6_) );
  AO22X1 U201 ( .A0(SDIPRE[7]), .A1(n420), .B0(ClkDivCnt316_7_), .B1(n422), 
        .Y(ClkDivCnt291_7_) );
  XNOR2X1 U1_A_7 ( .A(ClkDivCnt_7_), .B(carry_7_), .Y(ClkDivCnt316_7_) );
  OR2X1 U1_B_6 ( .A(ClkDivCnt_6_), .B(carry_6_), .Y(carry_7_) );
  OR2X1 U1_B_1 ( .A(ClkDivCnt_1_), .B(ClkDivCnt_0_), .Y(carry_2_) );
  OR2X1 U1_B_2 ( .A(ClkDivCnt_2_), .B(carry_2_), .Y(carry_3_) );
  OR2X1 U1_B_3 ( .A(ClkDivCnt_3_), .B(carry_3_), .Y(carry_4_) );
  OR2X1 U1_B_4 ( .A(ClkDivCnt_4_), .B(carry_4_), .Y(carry_5_) );
  OR2X1 U1_B_5 ( .A(ClkDivCnt_5_), .B(carry_5_), .Y(carry_6_) );
  DFFRX1 MMC_CLK_reg ( .D(n418), .CK(PCLK), .RN(nRst), .Q(MMC_CLK), .QN(n432)
         );
  DFFRX1 ClkDivCnt_reg_0_ ( .D(ClkDivCnt291_0_), .CK(PCLK), .RN(nRst), .Q(
        ClkDivCnt_0_), .QN(n431) );
  DFFRX1 ClkDivCnt_reg_3_ ( .D(ClkDivCnt291_3_), .CK(PCLK), .RN(nRst), .Q(
        ClkDivCnt_3_) );
  DFFRX1 ClkDivCnt_reg_1_ ( .D(ClkDivCnt291_1_), .CK(PCLK), .RN(nRst), .Q(
        ClkDivCnt_1_) );
  DFFRX1 ClkDivCnt_reg_7_ ( .D(ClkDivCnt291_7_), .CK(PCLK), .RN(nRst), .Q(
        ClkDivCnt_7_), .QN(n406) );
  DFFRX1 ClkDivCnt_reg_6_ ( .D(ClkDivCnt291_6_), .CK(PCLK), .RN(nRst), .Q(
        ClkDivCnt_6_), .QN(n405) );
  DFFRX1 ClkDivCnt_reg_4_ ( .D(ClkDivCnt291_4_), .CK(PCLK), .RN(nRst), .Q(
        ClkDivCnt_4_), .QN(n403) );
  DFFRX1 ClkDivCnt_reg_5_ ( .D(ClkDivCnt291_5_), .CK(PCLK), .RN(nRst), .Q(
        ClkDivCnt_5_), .QN(n404) );
  DFFRX1 ClkDivCnt_reg_2_ ( .D(ClkDivCnt291_2_), .CK(PCLK), .RN(nRst), .Q(
        ClkDivCnt_2_), .QN(n402) );
  DFFRX1 CntState_reg ( .D(CntState175), .CK(PCLK), .RN(nRst), .QN(n400) );
endmodule

