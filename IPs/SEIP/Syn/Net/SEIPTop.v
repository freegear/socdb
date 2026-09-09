
module SEIPTop ( MCK, XRST, TE, TI0, TI1, TI2, TI3, TI4, TO0, TO1, TO2, TO3, 
        TO4, PSEL, PENABLE, PADDR, PWRITE, PWDATA, PRDATA, PREADY, EEMA_M, 
        EEMDI_M, EEMDO_M, XEEMWE_M, RxDmaRequest, TxDmaRequest, SEIPInt, 
        EXMBIH, WEMDI, WEMDO, WEMA, XWEMOC, XWEMWE, SDI1, SDI2, SCKO, ADMCK, 
        LRCKO, SD2O, SD1O, MLRCK, MSCK );
  input [13:2] PADDR;
  input [31:0] PWDATA;
  output [31:0] PRDATA;
  output [15:0] EEMA_M;
  output [31:0] EEMDI_M;
  input [31:0] EEMDO_M;
  output [3:0] XEEMWE_M;
  output [7:0] WEMDI;
  input [7:0] WEMDO;
  output [23:0] WEMA;
  input MCK, XRST, TE, TI0, TI1, TI2, TI3, TI4, PSEL, PENABLE, PWRITE, SDI1,
         SDI2;
  output TO0, TO1, TO2, TO3, TO4, PREADY, RxDmaRequest, TxDmaRequest, SEIPInt,
         EXMBIH, XWEMOC, XWEMWE, SCKO, ADMCK, LRCKO, SD2O, SD1O, MLRCK, MSCK;
  wire   EEMA_0_, XPWE, XPOE, PRDY, RxDmaErr, TxDmaErr, RxDmaReq, TxDmaReq,
         RxFIFOWrite, RxFIFOReadCpu, RxFIFOFlush, RxFIFOEmpty, RxFIFOFull,
         RxDmaEn, RxDmaReset, TxFIFORead, TxFIFOWriteCpu, TxFIFOFlush,
         TxFIFOEmpty, TxFIFOFull, TxDmaEn, TxDmaReset, RXSYNC, RXRDY, RXWE,
         TXSYNC, TXRDY, TXRD, XWIMWE, XTIMWE, XEIMWE, XEEMWE, XEEMWE_M_3_,
         XEEMWE_M_1_, n322, n323, n324, n325;
  wire   [10:0] PIA;
  wire   [15:0] PIDI;
  wire   [15:0] PIDO;
  wire   [31:0] RxFIFOWrData;
  wire   [31:0] RxFIFORdDataCpu;
  wire   [2:0] RxFIFODataCnt;
  wire   [2:0] RxDmaSize;
  wire   [31:0] TxFIFORdData;
  wire   [31:0] TxFIFOWrDataCpu;
  wire   [2:0] TxFIFODataCnt;
  wire   [2:0] TxDmaSize;
  wire   [31:0] RXD;
  wire   [31:0] TXD;
  wire   [8:0] WIMA;
  wire   [15:0] WIMD;
  wire   [15:0] WIMDI;
  wire   [8:0] TIMA;
  wire   [23:0] TIMO;
  wire   [23:0] TIMI;
  wire   [7:0] EIMA;
  wire   [15:0] EIMO;
  wire   [15:0] EIMDI;
  wire   [15:0] EEMDI;
  wire   [8:0] TROMA;
  wire   [7:0] TROMO;
  wire   [15:0] EEMDO;
  assign EEMA_M[15] = 1'b0;
  assign XEEMWE_M[2] = XEEMWE_M_3_;
  assign XEEMWE_M[3] = XEEMWE_M_3_;
  assign XEEMWE_M[0] = XEEMWE_M_1_;
  assign XEEMWE_M[1] = XEEMWE_M_1_;

  SEIPApbIf SEIPApbIf ( .PIA(PIA), .PIDI(PIDI), .XPOE(XPOE), .XPWE(XPWE), 
        .PIDO(PIDO), .PRDY(PRDY), .PCLK(MCK), .PRESETB(XRST), .PSEL(PSEL), 
        .PENABLE(PENABLE), .PADDR(PADDR), .PWRITE(PWRITE), .PWDATA(PWDATA), 
        .PRDATA(PRDATA), .PREADY(PREADY), .RxDmaErr(RxDmaErr), .TxDmaErr(
        TxDmaErr), .RxDmaReq(RxDmaReq), .TxDmaReq(TxDmaReq), .SEIPInt(SEIPInt), 
        .RxFIFOWrite(RxFIFOWrite), .RxFIFOWrData(RxFIFOWrData), 
        .RxFIFOReadCpu(RxFIFOReadCpu), .RxFIFORdDataCpu(RxFIFORdDataCpu), 
        .RxFIFOFlush(RxFIFOFlush), .RxFIFODataCnt(RxFIFODataCnt), 
        .RxFIFOEmpty(RxFIFOEmpty), .RxFIFOFull(RxFIFOFull), .RxDmaEn(RxDmaEn), 
        .RxDmaSize(RxDmaSize), .RxDmaReset(RxDmaReset), .TxFIFORead(TxFIFORead), .TxFIFORdData(TxFIFORdData), .TxFIFOWriteCpu(TxFIFOWriteCpu), 
        .TxFIFOWrDataCpu(TxFIFOWrDataCpu), .TxFIFOFlush(TxFIFOFlush), 
        .TxFIFODataCnt(TxFIFODataCnt), .TxFIFOEmpty(TxFIFOEmpty), .TxFIFOFull(
        TxFIFOFull), .TxDmaEn(TxDmaEn), .TxDmaSize(TxDmaSize), .TxDmaReset(
        TxDmaReset) );
  SEIPDmaIf SEIPDmaIf ( .PCLK(MCK), .PRESETB(XRST), .RxFIFOWrite(RxFIFOWrite), 
        .RxFIFOWrData(RxFIFOWrData), .RxFIFOReadCpu(RxFIFOReadCpu), 
        .RxFIFORdDataCpu(RxFIFORdDataCpu), .RxFIFOFlush(RxFIFOFlush), 
        .RxFIFODataCnt(RxFIFODataCnt), .RxFIFOEmpty(RxFIFOEmpty), .RxFIFOFull(
        RxFIFOFull), .RxDmaEn(RxDmaEn), .RxDmaSize(RxDmaSize), .RxDmaReset(
        RxDmaReset), .RxDmaRequest(RxDmaRequest), .RxDmaErr(RxDmaErr), 
        .RxDmaReq(RxDmaReq), .TxFIFORead(TxFIFORead), .TxFIFORdData(
        TxFIFORdData), .TxFIFOWriteCpu(TxFIFOWriteCpu), .TxFIFOWrDataCpu(
        TxFIFOWrDataCpu), .TxFIFOFlush(TxFIFOFlush), .TxFIFODataCnt(
        TxFIFODataCnt), .TxFIFOEmpty(TxFIFOEmpty), .TxFIFOFull(TxFIFOFull), 
        .TxDmaEn(TxDmaEn), .TxDmaSize(TxDmaSize), .TxDmaReset(TxDmaReset), 
        .TxDmaRequest(TxDmaRequest), .TxDmaErr(TxDmaErr), .TxDmaReq(TxDmaReq), 
        .RXSYNC(RXSYNC), .RXRDY(RXRDY), .RXWE(RXWE), .RXD(RXD), .TXSYNC(TXSYNC), .TXRDY(TXRDY), .TXRD(TXRD), .TXD(TXD) );
  SEIP SEIP ( .WEMDO(WEMDO), .PIA(PIA), .PIDI(PIDI), .EEMDO(EEMDO), .RXD(RXD), 
        .WIMD(WIMD), .TIMO(TIMO), .EIMO(EIMO), .TROMO(TROMO), .SDI1(SDI1), 
        .TXRDY(TXRDY), .MCK(MCK), .XRST(XRST), .RXWE(RXWE), .TE(TE), .TI0(TI0), 
        .TI1(TI1), .TI2(TI2), .TI3(TI3), .TI4(TI4), .SDI2(SDI2), .XPOE(XPOE), 
        .XPWE(XPWE), .PIDO(PIDO), .WEMDI(WEMDI), .WEMA(WEMA), .EEMA({
        EEMA_M[14:0], EEMA_0_}), .EEMDI(EEMDI), .TXD(TXD), .WIMA(WIMA), 
        .WIMDI(WIMDI), .TIMA(TIMA), .TIMI(TIMI), .TROMA(TROMA), .EIMDI(EIMDI), 
        .EIMA(EIMA), .XEIMWE(XEIMWE), .XTIMWE(XTIMWE), .XWIMWE(XWIMWE), 
        .EXMBIH(EXMBIH), .SCKO(SCKO), .TO4(TO4), .ADMCK(ADMCK), .TO0(TO0), 
        .PRDY(PRDY), .TO1(TO1), .LRCKO(LRCKO), .TO3(TO3), .TO2(TO2), .SD2O(
        SD2O), .SD1O(SD1O), .TXSYNC(TXSYNC), .TXRD(TXRD), .RXSYNC(RXSYNC), 
        .RXRDY(RXRDY), .MLRCK(MLRCK), .MSCK(MSCK), .XEEMWE(XEEMWE), .XWEMWE(
        XWEMWE), .XWEMOC(XWEMOC) );
  RA1SH512x16 RAM1 ( .Q(WIMD), .CLK(MCK), .CEN(1'b0), .WEN(XWIMWE), .A(WIMA), 
        .D(WIMDI) );
  RA1SH512x24 RAM2 ( .Q(TIMO), .CLK(MCK), .CEN(1'b0), .WEN(XTIMWE), .A(TIMA), 
        .D(TIMI) );
  RA1SH256x16 RAM3 ( .Q(EIMO), .CLK(MCK), .CEN(1'b0), .WEN(XEIMWE), .A(EIMA), 
        .D(EIMDI) );
  RODSH512x8 ROM ( .Q(TROMO), .CLK(MCK), .CEN(1'b0), .A(TROMA) );
  CLKBUFX3 U140 ( .A(n322), .Y(n324) );
  CLKBUFX3 U141 ( .A(n322), .Y(n325) );
  CLKINVX1 U142 ( .A(n323), .Y(n322) );
  CLKBUFX3 U143 ( .A(EEMA_0_), .Y(n323) );
  AO22X1 U144 ( .A0(EEMDO_M[31]), .A1(n323), .B0(EEMDO_M[15]), .B1(n324), .Y(
        EEMDO[15]) );
  AO22X1 U145 ( .A0(EEMDO_M[30]), .A1(n323), .B0(EEMDO_M[14]), .B1(n325), .Y(
        EEMDO[14]) );
  AO22X1 U146 ( .A0(EEMDO_M[29]), .A1(n323), .B0(EEMDO_M[13]), .B1(n324), .Y(
        EEMDO[13]) );
  AO22X1 U147 ( .A0(EEMDO_M[28]), .A1(n323), .B0(EEMDO_M[12]), .B1(n324), .Y(
        EEMDO[12]) );
  AO22X1 U148 ( .A0(EEMDO_M[27]), .A1(n323), .B0(EEMDO_M[11]), .B1(n324), .Y(
        EEMDO[11]) );
  AO22X1 U149 ( .A0(EEMDO_M[26]), .A1(n323), .B0(EEMDO_M[10]), .B1(n324), .Y(
        EEMDO[10]) );
  AO22X1 U150 ( .A0(EEMDO_M[25]), .A1(n323), .B0(EEMDO_M[9]), .B1(n325), .Y(
        EEMDO[9]) );
  AO22X1 U151 ( .A0(EEMDO_M[24]), .A1(n323), .B0(EEMDO_M[8]), .B1(n325), .Y(
        EEMDO[8]) );
  AO22X1 U152 ( .A0(EEMDO_M[23]), .A1(n323), .B0(EEMDO_M[7]), .B1(n324), .Y(
        EEMDO[7]) );
  AO22X1 U153 ( .A0(EEMDO_M[22]), .A1(n323), .B0(EEMDO_M[6]), .B1(n325), .Y(
        EEMDO[6]) );
  AO22X1 U154 ( .A0(EEMDO_M[21]), .A1(n323), .B0(EEMDO_M[5]), .B1(n324), .Y(
        EEMDO[5]) );
  AO22X1 U155 ( .A0(EEMDO_M[20]), .A1(n323), .B0(EEMDO_M[4]), .B1(n325), .Y(
        EEMDO[4]) );
  AO22X1 U156 ( .A0(EEMDO_M[19]), .A1(n323), .B0(EEMDO_M[3]), .B1(n325), .Y(
        EEMDO[3]) );
  AO22X1 U157 ( .A0(EEMDO_M[18]), .A1(n323), .B0(EEMDO_M[2]), .B1(n324), .Y(
        EEMDO[2]) );
  AO22X1 U158 ( .A0(EEMDO_M[17]), .A1(n323), .B0(EEMDO_M[1]), .B1(n325), .Y(
        EEMDO[1]) );
  AO22X1 U159 ( .A0(EEMDO_M[16]), .A1(n323), .B0(EEMDO_M[0]), .B1(n325), .Y(
        EEMDO[0]) );
  NAND2BX1 U160 ( .AN(XEEMWE), .B(n323), .Y(XEEMWE_M_3_) );
  OR2X1 U161 ( .A(n323), .B(XEEMWE), .Y(XEEMWE_M_1_) );
  NOR2BX1 U162 ( .AN(EEMDI[0]), .B(n323), .Y(EEMDI_M[0]) );
  NOR2BX1 U163 ( .AN(EEMDI[1]), .B(n323), .Y(EEMDI_M[1]) );
  NOR2BX1 U164 ( .AN(EEMDI[2]), .B(n323), .Y(EEMDI_M[2]) );
  NOR2BX1 U165 ( .AN(EEMDI[3]), .B(n323), .Y(EEMDI_M[3]) );
  NOR2BX1 U166 ( .AN(EEMDI[4]), .B(n323), .Y(EEMDI_M[4]) );
  NOR2BX1 U167 ( .AN(EEMDI[5]), .B(n323), .Y(EEMDI_M[5]) );
  NOR2BX1 U168 ( .AN(EEMDI[6]), .B(n323), .Y(EEMDI_M[6]) );
  NOR2BX1 U169 ( .AN(EEMDI[7]), .B(n323), .Y(EEMDI_M[7]) );
  NOR2BX1 U170 ( .AN(EEMDI[8]), .B(n323), .Y(EEMDI_M[8]) );
  NOR2BX1 U171 ( .AN(EEMDI[9]), .B(n323), .Y(EEMDI_M[9]) );
  NOR2BX1 U172 ( .AN(EEMDI[10]), .B(n323), .Y(EEMDI_M[10]) );
  NOR2BX1 U173 ( .AN(EEMDI[11]), .B(n323), .Y(EEMDI_M[11]) );
  NOR2BX1 U174 ( .AN(EEMDI[12]), .B(n323), .Y(EEMDI_M[12]) );
  NOR2BX1 U175 ( .AN(EEMDI[13]), .B(n323), .Y(EEMDI_M[13]) );
  NOR2BX1 U176 ( .AN(EEMDI[14]), .B(n323), .Y(EEMDI_M[14]) );
  NOR2BX1 U177 ( .AN(EEMDI[15]), .B(n323), .Y(EEMDI_M[15]) );
  NOR2BX1 U178 ( .AN(EEMDI[0]), .B(n325), .Y(EEMDI_M[16]) );
  NOR2BX1 U179 ( .AN(EEMDI[1]), .B(n325), .Y(EEMDI_M[17]) );
  NOR2BX1 U180 ( .AN(EEMDI[2]), .B(n324), .Y(EEMDI_M[18]) );
  NOR2BX1 U181 ( .AN(EEMDI[3]), .B(n324), .Y(EEMDI_M[19]) );
  NOR2BX1 U182 ( .AN(EEMDI[4]), .B(n324), .Y(EEMDI_M[20]) );
  NOR2BX1 U183 ( .AN(EEMDI[5]), .B(n325), .Y(EEMDI_M[21]) );
  NOR2BX1 U184 ( .AN(EEMDI[6]), .B(n324), .Y(EEMDI_M[22]) );
  NOR2BX1 U185 ( .AN(EEMDI[7]), .B(n325), .Y(EEMDI_M[23]) );
  NOR2BX1 U186 ( .AN(EEMDI[8]), .B(n325), .Y(EEMDI_M[24]) );
  NOR2BX1 U187 ( .AN(EEMDI[9]), .B(n325), .Y(EEMDI_M[25]) );
  NOR2BX1 U188 ( .AN(EEMDI[10]), .B(n324), .Y(EEMDI_M[26]) );
  NOR2BX1 U189 ( .AN(EEMDI[11]), .B(n324), .Y(EEMDI_M[27]) );
  NOR2BX1 U190 ( .AN(EEMDI[12]), .B(n325), .Y(EEMDI_M[28]) );
  NOR2BX1 U191 ( .AN(EEMDI[13]), .B(n325), .Y(EEMDI_M[29]) );
  NOR2BX1 U192 ( .AN(EEMDI[14]), .B(n324), .Y(EEMDI_M[30]) );
  NOR2BX1 U193 ( .AN(EEMDI[15]), .B(n324), .Y(EEMDI_M[31]) );
endmodule


module SEIP ( WEMDO, PIA, PIDI, EEMDO, RXD, WIMD, TIMO, EIMO, TROMO, SDI1, 
        TXRDY, MCK, XRST, RXWE, TE, TI0, TI1, TI2, TI3, TI4, SDI2, XPOE, XPWE, 
        PIDO, WEMDI, WEMA, EEMA, EEMDI, TXD, WIMA, WIMDI, TIMA, TIMI, TROMA, 
        EIMDI, EIMA, XEEMCE, XEIMCE, XTROMCE, XTIMCE, XWIMCE, XEIMWE, XTIMWE, 
        XWIMWE, EXMBIH, SCKO, TO4, ADMCK, TO0, PRDY, TO1, LRCKO, TO3, TO2, 
        SD2O, SD1O, TXSYNC, TXRD, RXSYNC, RXRDY, MLRCK, MSCK, XEEMWE, XWEMWE, 
        XWEMOC );
  input [7:0] WEMDO;
  input [10:0] PIA;
  input [15:0] PIDI;
  input [15:0] EEMDO;
  input [31:0] RXD;
  input [15:0] WIMD;
  input [23:0] TIMO;
  input [15:0] EIMO;
  input [7:0] TROMO;
  output [15:0] PIDO;
  output [7:0] WEMDI;
  output [23:0] WEMA;
  output [15:0] EEMA;
  output [15:0] EEMDI;
  output [31:0] TXD;
  output [8:0] WIMA;
  output [15:0] WIMDI;
  output [8:0] TIMA;
  output [23:0] TIMI;
  output [8:0] TROMA;
  output [15:0] EIMDI;
  output [7:0] EIMA;
  input SDI1, TXRDY, MCK, XRST, RXWE, TE, TI0, TI1, TI2, TI3, TI4, SDI2, XPOE,
         XPWE;
  output XEEMCE, XEIMCE, XTROMCE, XTIMCE, XWIMCE, XEIMWE, XTIMWE, XWIMWE,
         EXMBIH, SCKO, TO4, ADMCK, TO0, PRDY, TO1, LRCKO, TO3, TO2, SD2O, SD1O,
         TXSYNC, TXRD, RXSYNC, RXRDY, MLRCK, MSCK, XEEMWE, XWEMWE, XWEMOC;
  wire   n_A_0N, n_A_3B, n_A_46, n_A_3D, n_A_3J, n_A_3H, n_A_3G, n_A_02,
         n_A_2B, n_A_3S, n_A_2G, n_A_06, n_A_03, n_A_45, n_A_05, n_A_3F1,
         n_A_3F2, n_A_3F3, n_A_3F4, n_A_3F5, n_A_3F6, n_A_3F7, n_A_3F8,
         n_A_3F9, n_A_3F10, n_A_3F11, n_A_3F12, n_A_3F13, n_A_3F14, n_A_3F15,
         n_A_3F16, n_A_3E1, n_A_3E2, n_A_3E3, n_A_3E4, n_PMD15, n_PMD14,
         n_PMD13, n_PMD12, n_PMD11, n_PMD10, n_PMD09, n_PMD08, n_PMD07,
         n_PMD06, n_PMD05, n_PMD04, n_PMD03, n_PMD02, n_PMD01, n_PMD00, n_PMA8,
         n_PMA7, n_PMA6, n_PMA5, n_PMA4, n_PMA3, n_PMA2, n_PMA1, n_PMA0,
         n_A_2F1, n_A_2F2, n_A_2F3, n_A_2F4, n_A_2F5, n_A_2F6, n_A_311,
         n_A_312, n_A_313, n_A_314, n_A_315, n_A_316, n_A_317, n_A_321,
         n_A_322, n_A_3N1, n_A_3N2, n_A_3N3, n_A_3N4, n_A_3M1, n_A_3M2,
         n_A_3M3, n_A_3M4, n_A_3M5, n_A_3M6, n_A_3M7, n_A_3M8, n_A_3M9,
         n_A_3M10, n_A_3M11, n_A_3M12, n_A_3M13, n_A_3M14, n_A_3M15, n_A_3M16,
         n_A_3M17, n_A_3M18, n_A_3M19, n_A_3M20, n_A_2E1, n_A_2E2, n_A_2E3,
         n_A_2E4, n_A_2E5, n_A_2E6, n_A_2E7, n_A_2E8, n_A_27, n_A_2A, n_A_29,
         n_A_38, n_A_37, n_A_3K, n_A_2J, n_A_2H, n_A_26, n_A_281, n_A_282,
         n_A_283, n_A_284, n_A_285, n_A_286, n_A_287, n_A_288, n_A_289,
         n_A_3L1, n_A_3L2, n_A_3L3, n_A_3L4, n_A_3L5, n_A_3L6, n_A_3L7,
         n_A_3L8, n_A_3L9, n_A_3L10, n_A_3L11, n_A_3L12, n_A_3L13, n_A_3L14,
         n_A_3L15, n_A_3L16, n_A_3L17, n_A_3L18, n_A_3L19, n_A_3L20, n_A_391,
         n_A_392, n_A_393, n_A_394, n_A_395, n_A_396, n_A_397, n_A_398,
         n_A_3A1, n_A_3A2, n_A_3A3, n_A_2R, n_A_0U, n_A_2K, n_A_2P, n_A_36,
         n_A_0S, n_A_2N, n_A_2S, n_A_2L1, n_A_2L2, n_A_2M1, n_A_2M2;

  TIELO A06 ( .Y(XEEMCE) );
  TIELO A08 ( .Y(XEIMCE) );
  TIELO A07 ( .Y(XTROMCE) );
  TIELO A28 ( .Y(XTIMCE) );
  TIELO A25 ( .Y(XWIMCE) );
  WMA A02 ( .WEMDO(WEMDO), .PMD({n_PMD15, n_PMD14, n_PMD13, n_PMD12, n_PMD11, 
        n_PMD10, n_PMD09, n_PMD08, n_PMD07, n_PMD06, n_PMD05, n_PMD04, n_PMD03, 
        n_PMD02, n_PMD01, n_PMD00}), .PMA({n_PMA8, n_PMA7, n_PMA6, n_PMA5, 
        n_PMA4, n_PMA3, n_PMA2, n_PMA1, n_PMA0}), .WIMDO(WIMD), .GPA({n_A_3E1, 
        n_A_3E2, n_A_3E3, n_A_3E4}), .GPD({n_A_3F1, n_A_3F2, n_A_3F3, n_A_3F4, 
        n_A_3F5, n_A_3F6, n_A_3F7, n_A_3F8, n_A_3F9, n_A_3F10, n_A_3F11, 
        n_A_3F12, n_A_3F13, n_A_3F14, n_A_3F15, n_A_3F16}), .CHTEST(n_A_46), 
        .WMDRE(n_A_3J), .ENP(n_A_0N), .WWREQ(n_A_3D), .CHOSLD(n_A_3B), .TE(TE), 
        .XRST(XRST), .FSYNC(n_A_3G), .START(n_A_3H), .TI(TI1), .WMDWE(n_A_3S), 
        .MCK(MCK), .WST1(n_A_2B), .WST0(n_A_02), .SLWD({n_A_3M1, n_A_3M2, 
        n_A_3M3, n_A_3M4, n_A_3M5, n_A_3M6, n_A_3M7, n_A_3M8, n_A_3M9, 
        n_A_3M10, n_A_3M11, n_A_3M12, n_A_3M13, n_A_3M14, n_A_3M15, n_A_3M16, 
        n_A_3M17, n_A_3M18, n_A_3M19, n_A_3M20}), .WEMDI(WEMDI), .WEMA(WEMA), 
        .WIMA(WIMA), .WIMDI(WIMDI), .PLACA({n_A_311, n_A_312, n_A_313, n_A_314, 
        n_A_315, n_A_316, n_A_317}), .PITB({n_A_3N1, n_A_3N2, n_A_3N3, n_A_3N4}), .WMRD({n_A_2E1, n_A_2E2, n_A_2E3, n_A_2E4, n_A_2E5, n_A_2E6, n_A_2E7, 
        n_A_2E8}), .CHS({n_A_2F1, n_A_2F2, n_A_2F3, n_A_2F4, n_A_2F5, n_A_2F6}), .FMODE({n_A_321, n_A_322}), .CHOFDT(n_A_2G), .TSYNC(n_A_05), .CHONLE(n_A_03), 
        .TO(TO1), .XWIMWE(XWIMWE), .WWRDY(n_A_45), .XWEMWE(XWEMWE), .XWEMOC(
        XWEMOC), .WSCST(n_A_06) );
  TSP A03 ( .TIMO(TIMO), .EROMA({n_A_281, n_A_282, n_A_283, n_A_284, n_A_285, 
        n_A_286, n_A_287, n_A_288, n_A_289}), .PLACA({n_A_311, n_A_312, 
        n_A_313, n_A_314, n_A_315, n_A_316, n_A_317}), .FMODE({n_A_321, 
        n_A_322}), .SLWD({n_A_3M1, n_A_3M2, n_A_3M3, n_A_3M4, n_A_3M5, n_A_3M6, 
        n_A_3M7, n_A_3M8, n_A_3M9, n_A_3M10, n_A_3M11, n_A_3M12, n_A_3M13, 
        n_A_3M14, n_A_3M15, n_A_3M16, n_A_3M17, n_A_3M18, n_A_3M19, n_A_3M20}), 
        .PMD({n_PMD11, n_PMD10, n_PMD09, n_PMD08, n_PMD07, n_PMD06, n_PMD05, 
        n_PMD04, n_PMD03, n_PMD02, n_PMD01, n_PMD00}), .TROMO(TROMO), .PITB({
        n_A_3N1, n_A_3N2, n_A_3N3, n_A_3N4}), .CHLV({n_A_3A1, n_A_3A2, n_A_3A3}), .ITPD({n_A_391, n_A_392, n_A_393, n_A_394, n_A_395, n_A_396, n_A_397, 
        n_A_398}), .PMA({n_PMA8, n_PMA7, n_PMA6, n_PMA5, n_PMA4, n_PMA3, 
        n_PMA2, n_PMA1, n_PMA0}), .CHTEST(n_A_46), .XRST(XRST), .TE(TE), 
        .ESSCL(n_A_29), .ESSCE(n_A_2A), .TI(TI2), .CHOSLD(n_A_3B), .TSYNC(
        n_A_05), .WSCST(n_A_06), .EROMAS(n_A_27), .TLWREQ(n_A_37), .THWREQ(
        n_A_38), .ENP(n_A_0N), .MCK(MCK), .TROMA(TROMA), .ESSD({n_A_3L1, 
        n_A_3L2, n_A_3L3, n_A_3L4, n_A_3L5, n_A_3L6, n_A_3L7, n_A_3L8, n_A_3L9, 
        n_A_3L10, n_A_3L11, n_A_3L12, n_A_3L13, n_A_3L14, n_A_3L15, n_A_3L16, 
        n_A_3L17, n_A_3L18, n_A_3L19, n_A_3L20}), .TIMI(TIMI), .TIMA(TIMA), 
        .TSCST(n_A_26), .TLWRDY(n_A_2H), .THWRDY(n_A_2J), .XTIMWE(XTIMWE), 
        .TO(TO2), .WST1(n_A_2B), .WST0(n_A_02), .ESYNC(n_A_3K) );
  ESP A04 ( .EEMDO(EEMDO), .PMD({n_PMD15, n_PMD14, n_PMD13, n_PMD12, n_PMD11, 
        n_PMD10, n_PMD09, n_PMD08, n_PMD07, n_PMD06, n_PMD05, n_PMD04, n_PMD03, 
        n_PMD02, n_PMD01, n_PMD00}), .PMA({n_PMA7, n_PMA6, n_PMA5, n_PMA4, 
        n_PMA3, n_PMA2, n_PMA1, n_PMA0}), .SOBWS({n_A_2M1, n_A_2M2}), .RXD(RXD), .EIMO(EIMO), .ESSD({n_A_3L1, n_A_3L2, n_A_3L3, n_A_3L4, n_A_3L5, n_A_3L6, 
        n_A_3L7, n_A_3L8, n_A_3L9, n_A_3L10, n_A_3L11, n_A_3L12, n_A_3L13, 
        n_A_3L14, n_A_3L15, n_A_3L16, n_A_3L17, n_A_3L18, n_A_3L19, n_A_3L20}), 
        .EDBRS({n_A_2L1, n_A_2L2}), .SDI2(SDI2), .TI1(TI4), .EMCL(n_A_2N), 
        .RXESEN(n_A_2S), .ENP(n_A_0N), .TE(TE), .MCK(MCK), .TI0(TI3), .XRST(
        XRST), .TXRDY(TXRDY), .TXEN(n_A_2P), .RXEN(n_A_2R), .RXWE(RXWE), 
        .SDI1(SDI1), .TSCST(n_A_26), .SURDEN(n_A_2K), .PCEBEN(n_A_0U), .ESYNC(
        n_A_3K), .EWREQ(n_A_36), .EIMA(EIMA), .EIMDI(EIMDI), .EEMDI(EEMDI), 
        .EEMA(EEMA), .TXD(TXD), .EROMA({n_A_281, n_A_282, n_A_283, n_A_284, 
        n_A_285, n_A_286, n_A_287, n_A_288, n_A_289}), .TO1(TO4), .EROMAS(
        n_A_27), .TO0(TO3), .RXSYNC(RXSYNC), .RXRDY(RXRDY), .TXSYNC(TXSYNC), 
        .TXRD(TXRD), .LRCKO(LRCKO), .SCKO(SCKO), .SD2O(SD2O), .SD1O(SD1O), 
        .EWRDY(n_A_0S), .XEIMWE(XEIMWE), .XEEMWE(XEEMWE), .ESSCL(n_A_29), 
        .ESSCE(n_A_2A), .MLRCK(MLRCK), .MSCK(MSCK) );
  PIF A01 ( .CHS({n_A_2F1, n_A_2F2, n_A_2F3, n_A_2F4, n_A_2F5, n_A_2F6}), 
        .PIA(PIA), .PIDI(PIDI), .WMRD({n_A_2E1, n_A_2E2, n_A_2E3, n_A_2E4, 
        n_A_2E5, n_A_2E6, n_A_2E7, n_A_2E8}), .XRST(XRST), .TE(TE), .TI(TI0), 
        .XPOE(XPOE), .XPWE(XPWE), .EWRDY(n_A_0S), .TLWRDY(n_A_2H), .THWRDY(
        n_A_2J), .WWRDY(n_A_45), .CHOFDT(n_A_2G), .CHONLE(n_A_03), .MCK(MCK), 
        .GPA({n_A_3E1, n_A_3E2, n_A_3E3, n_A_3E4}), .GPD({n_A_3F1, n_A_3F2, 
        n_A_3F3, n_A_3F4, n_A_3F5, n_A_3F6, n_A_3F7, n_A_3F8, n_A_3F9, 
        n_A_3F10, n_A_3F11, n_A_3F12, n_A_3F13, n_A_3F14, n_A_3F15, n_A_3F16}), 
        .PMA({n_PMA8, n_PMA7, n_PMA6, n_PMA5, n_PMA4, n_PMA3, n_PMA2, n_PMA1, 
        n_PMA0}), .PMD({n_PMD15, n_PMD14, n_PMD13, n_PMD12, n_PMD11, n_PMD10, 
        n_PMD09, n_PMD08, n_PMD07, n_PMD06, n_PMD05, n_PMD04, n_PMD03, n_PMD02, 
        n_PMD01, n_PMD00}), .SOBWS({n_A_2M1, n_A_2M2}), .CHLV({n_A_3A1, 
        n_A_3A2, n_A_3A3}), .ITPD({n_A_391, n_A_392, n_A_393, n_A_394, n_A_395, 
        n_A_396, n_A_397, n_A_398}), .PIDO(PIDO), .EDBRS({n_A_2L1, n_A_2L2}), 
        .EXMBIH(EXMBIH), .RXESEN(n_A_2S), .RXEN(n_A_2R), .TXEN(n_A_2P), 
        .FSYNC(n_A_3G), .CHTEST(n_A_46), .PCEBEN(n_A_0U), .SURDEN(n_A_2K), 
        .EMCL(n_A_2N), .START(n_A_3H), .WMDRE(n_A_3J), .WMDWE(n_A_3S), .EWREQ(
        n_A_36), .TLWREQ(n_A_37), .THWREQ(n_A_38), .WWREQ(n_A_3D), .PRDY(PRDY), 
        .TO(TO0), .CHOSLD(n_A_3B), .ENP(n_A_0N), .ADMCK(ADMCK) );
endmodule


module PIF ( CHS, PIA, PIDI, WMRD, XRST, TE, TI, XPOE, XPWE, EWRDY, TLWRDY, 
        THWRDY, WWRDY, CHOFDT, CHONLE, MCK, GPA, GPD, PMA, PMD, SOBWS, CHLV, 
        ITPD, PIDO, EDBRS, EXMBIH, RXESEN, RXEN, TXEN, FSYNC, CHTEST, PCEBEN, 
        SURDEN, EMCL, START, WMDRE, WMDWE, EWREQ, TLWREQ, THWREQ, WWREQ, PRDY, 
        TO, CHOSLD, ENP, ADMCK );
  input [5:0] CHS;
  input [10:0] PIA;
  input [15:0] PIDI;
  input [7:0] WMRD;
  output [3:0] GPA;
  output [15:0] GPD;
  output [8:0] PMA;
  output [15:0] PMD;
  output [1:0] SOBWS;
  output [2:0] CHLV;
  output [7:0] ITPD;
  output [15:0] PIDO;
  output [1:0] EDBRS;
  input XRST, TE, TI, XPOE, XPWE, EWRDY, TLWRDY, THWRDY, WWRDY, CHOFDT, CHONLE,
         MCK;
  output EXMBIH, RXESEN, RXEN, TXEN, FSYNC, CHTEST, PCEBEN, SURDEN, EMCL,
         START, WMDRE, WMDWE, EWREQ, TLWREQ, THWREQ, WWREQ, PRDY, TO, CHOSLD,
         ENP, ADMCK;
  wire   n_A_07, n_A_1F, n_A_05, n_A_04, n_A_1K, n_A_1J, n_A_0W1, n_A_0W2,
         n_A_0W3, n_A_0W4, n_A_0W5, n_A_0W6, n_A_0W7, n_A_0W8, n_A_0W9,
         n_A_0W10, n_A_0W11, n_A_0W12, n_A_0W13, n_A_0W14, n_A_0W15, n_A_0W16;

  SYNCG A03 ( .TE(n_A_05), .XRST(n_A_04), .TI(n_A_1F), .MCK(MCK), .ADMCK(ADMCK), .TO(n_A_07), .FSYNC(FSYNC), .ENP(ENP) );
  GPMREG A01 ( .PIA(PIA), .PIDI(PIDI), .CHORD({n_A_0W1, n_A_0W2, n_A_0W3, 
        n_A_0W4, n_A_0W5, n_A_0W6, n_A_0W7, n_A_0W8, n_A_0W9, n_A_0W10, 
        n_A_0W11, n_A_0W12, n_A_0W13, n_A_0W14, n_A_0W15, n_A_0W16}), .WMRD(
        WMRD), .XRST(n_A_04), .TE(n_A_05), .XPOE(XPOE), .XPWE(XPWE), .TI(TI), 
        .TLWRDY(TLWRDY), .THWRDY(THWRDY), .WWRDY(WWRDY), .EWRDY(EWRDY), .MCK(
        MCK), .GPA(GPA), .PMA(PMA), .GPD(GPD), .PMD(PMD), .SOBWS(SOBWS), 
        .CHLV(CHLV), .ITPD(ITPD), .PIDO(PIDO), .EDBRS(EDBRS), .CHTEST(CHTEST), 
        .EXMBIH(EXMBIH), .RXESEN(RXESEN), .RXEN(RXEN), .TXEN(TXEN), .PRDY(PRDY), .PCEBEN(PCEBEN), .SURDEN(SURDEN), .EMCL(EMCL), .START(START), .CHORE(n_A_1J), 
        .WMDRE(WMDRE), .TO(n_A_1F), .WMDWE(WMDWE), .CHOWE(n_A_1K), .TLWREQ(
        TLWREQ), .THWREQ(THWREQ), .WWREQ(WWREQ), .EWREQ(EWREQ) );
  CHOFRG A02 ( .GPWD(GPD), .GPA(GPA), .CHS(CHS), .TI(n_A_07), .CHORE(n_A_1J), 
        .XRST(n_A_04), .TE(n_A_05), .FSYNC(FSYNC), .CHONLE(CHONLE), .CHOWE(
        n_A_1K), .MCK(MCK), .CHOFDT(CHOFDT), .CHORD({n_A_0W1, n_A_0W2, n_A_0W3, 
        n_A_0W4, n_A_0W5, n_A_0W6, n_A_0W7, n_A_0W8, n_A_0W9, n_A_0W10, 
        n_A_0W11, n_A_0W12, n_A_0W13, n_A_0W14, n_A_0W15, n_A_0W16}), .CHOSLD(
        CHOSLD), .TO(TO) );
  BUFX2 A06 ( .A(TE), .Y(n_A_05) );
  BUFX2 A05 ( .A(XRST), .Y(n_A_04) );
endmodule


module CHOFRG ( GPWD, GPA, CHS, TI, CHORE, XRST, TE, FSYNC, CHONLE, CHOWE, MCK, 
        CHOFDT, CHORD, CHOSLD, TO );
  input [15:0] GPWD;
  input [3:0] GPA;
  input [5:0] CHS;
  output [15:0] CHORD;
  input TI, CHORE, XRST, TE, FSYNC, CHONLE, CHOWE, MCK, CHOFDT;
  output CHOSLD, TO;
  wire   n_GPAB0, n_GPAB1, n_GPAB2, n_A_2D, n_A_38, n_A_15, n_GPAB3, n_A_1L,
         n_A_1K, n_A_1J, n_A_1H, n_A_1G, n_A_1F, n_A_1E, n_A_10, n_A_2A,
         n_A_1W, n_A_1V, n_A_1T, n_A_1U, n_A_19, n_A_31, n_A_30, n_A_25,
         n_A_18, n_A_1X, n_A_1B, n_A_32, n_A_33, n_A_34, n_A_35, n_A_36,
         n_A_21, n_A_1N, n_A_2B, n_A_1S, n_A_14, n_A_1P, n_A_16, n_A_0T,
         n_A_241, n_A_242, n_A_243, n_A_244, n_A_245, n_A_246, n_A_247,
         n_A_248, n_A_249, n_A_2410, n_A_2411, n_A_2412, n_A_2413, n_A_2414,
         n_A_2415, n_A_2416, n_A_28, n_A_2F, n_A_02, n_A_2T, n_CRDD15,
         n_CRDD14, n_CRDD13, n_CRDD12, n_CRDD11, n_CRDD10, n_CRDD09, n_CRDD08,
         n_A_01, n_A_2V, n_CRDD07, n_CRDD06, n_CRDD05, n_CRDD04, n_CRDD03,
         n_CRDD02, n_CRDD01, n_CRDD00, n_A_2N, n_A_2W, n_CRDC15, n_CRDC14,
         n_CRDC13, n_CRDC12, n_CRDC11, n_CRDC10, n_CRDC09, n_CRDC08, n_A_2P,
         n_A_2X, n_CRDC07, n_CRDC06, n_CRDC05, n_CRDC04, n_CRDC03, n_CRDC02,
         n_CRDC01, n_CRDC00, n_A_2R, n_A_2L, n_CRDB15, n_CRDB14, n_CRDB13,
         n_CRDB12, n_CRDB11, n_CRDB10, n_CRDB09, n_CRDB08, n_A_2C, n_A_2K,
         n_CRDB07, n_CRDB06, n_CRDB05, n_CRDB04, n_CRDB03, n_CRDB02, n_CRDB01,
         n_CRDB00, n_A_2S, n_A_2J, n_CRDA15, n_CRDA14, n_CRDA13, n_CRDA12,
         n_CRDA11, n_CRDA10, n_CRDA09, n_CRDA08, n_A_2Y, n_CRDA07, n_CRDA06,
         n_CRDA05, n_CRDA04, n_CRDA03, n_CRDA02, n_CRDA01, n_CRDA00;

  BUFX2 A150 ( .A(GPA[0]), .Y(n_GPAB0) );
  BUFX2 A151 ( .A(GPA[1]), .Y(n_GPAB1) );
  BUFX2 A152 ( .A(GPA[2]), .Y(n_GPAB2) );
  INVX1 A2G ( .A(n_GPAB2), .Y(n_A_2D) );
  INVX1 A2J ( .A(n_A_38), .Y(n_A_15) );
  BUFX2 A153 ( .A(GPA[3]), .Y(n_GPAB3) );
  DC08 A09 ( .C(CHS[5]), .B(CHS[4]), .A(CHS[3]), .Y0(n_A_1L), .Y1(n_A_1K), 
        .Y2(n_A_1J), .Y3(n_A_1H), .Y4(n_A_1G), .Y5(n_A_1F), .Y6(n_A_1E), .Y7(
        n_A_10) );
  DC04P A1V ( .EN(n_A_2A), .B(n_GPAB1), .A(n_GPAB0), .Y3(n_A_1U), .Y2(n_A_1T), 
        .Y1(n_A_1V), .Y0(n_A_1W) );
  DC04P A1R ( .EN(n_A_19), .B(n_GPAB1), .A(n_GPAB0), .Y3(n_A_18), .Y2(n_A_25), 
        .Y1(n_A_30), .Y0(n_A_31) );
  PDL4 A0B ( .RN(n_A_21), .TE(n_A_1B), .ENP(n_A_1N), .SS4(n_A_18), .SS3(n_A_25), .SS2(n_A_30), .TI(n_A_1X), .SS1(n_A_31), .CK(MCK), .TO(n_A_36), .P4(n_A_35), 
        .P3(n_A_34), .P2(n_A_33), .P1(n_A_32) );
  INVX1 A2D ( .A(n_GPAB2), .Y(n_A_2B) );
  AND2X1 A1N ( .A(n_A_2D), .B(n_GPAB3), .Y(n_A_1S) );
  NOR2X1 A1A ( .A(n_GPAB3), .B(n_A_2B), .Y(n_A_14) );
  NOR2X1 A1U ( .A(n_GPAB2), .B(n_GPAB3), .Y(n_A_1P) );
  BUFX2 A11 ( .A(TE), .Y(n_A_1B) );
  AND2X1 A16 ( .A(n_A_1P), .B(CHOWE), .Y(n_A_19) );
  AND2X1 A21 ( .A(n_A_1P), .B(CHORE), .Y(n_A_16) );
  AND2X1 A2H ( .A(n_A_15), .B(FSYNC), .Y(n_A_0T) );
  EN16 A1K ( .A({n_A_241, n_A_242, n_A_243, n_A_244, n_A_245, n_A_246, n_A_247, 
        n_A_248, n_A_249, n_A_2410, n_A_2411, n_A_2412, n_A_2413, n_A_2414, 
        n_A_2415, n_A_2416}), .EN(n_A_16), .Y(CHORD) );
  AND2X1 A20 ( .A(CHOWE), .B(n_A_1S), .Y(n_A_38) );
  SR1R A1D ( .RN(n_A_21), .TE(n_A_1B), .TI(TI), .CK(MCK), .SR(n_A_0T), .SS(
        n_A_38), .Q(n_A_1X) );
  AND2X1 A1W ( .A(n_A_14), .B(CHOWE), .Y(n_A_2A) );
  AND2X1 A1S ( .A(n_A_1X), .B(FSYNC), .Y(n_A_28) );
  AND2X1 A14 ( .A(n_A_1P), .B(CHONLE), .Y(n_A_1N) );
  OFR8 A08 ( .D(GPWD[15:8]), .S(CHS[2:0]), .RN(n_A_21), .SE(n_A_10), .OFDT(
        n_A_2F), .TE(n_A_1B), .DE4(n_A_28), .DE3(n_A_35), .DE2(n_A_1U), .DE1(
        n_A_18), .TI(n_A_02), .CK(MCK), .Q({n_CRDD15, n_CRDD14, n_CRDD13, 
        n_CRDD12, n_CRDD11, n_CRDD10, n_CRDD09, n_CRDD08}), .CHQ(n_A_2T), .TO(
        TO) );
  OFR8 A07 ( .D(GPWD[7:0]), .S(CHS[2:0]), .RN(n_A_21), .SE(n_A_1E), .OFDT(
        n_A_2F), .TE(n_A_1B), .DE4(n_A_28), .DE3(n_A_35), .DE2(n_A_1U), .DE1(
        n_A_18), .TI(n_A_01), .CK(MCK), .Q({n_CRDD07, n_CRDD06, n_CRDD05, 
        n_CRDD04, n_CRDD03, n_CRDD02, n_CRDD01, n_CRDD00}), .CHQ(n_A_2V), .TO(
        n_A_02) );
  OFR8 A06 ( .D(GPWD[15:8]), .S(CHS[2:0]), .RN(n_A_21), .SE(n_A_1F), .OFDT(
        n_A_2F), .TE(n_A_1B), .DE4(n_A_28), .DE3(n_A_34), .DE2(n_A_1T), .DE1(
        n_A_25), .TI(n_A_2N), .CK(MCK), .Q({n_CRDC15, n_CRDC14, n_CRDC13, 
        n_CRDC12, n_CRDC11, n_CRDC10, n_CRDC09, n_CRDC08}), .CHQ(n_A_2W), .TO(
        n_A_01) );
  OFR8 A05 ( .D(GPWD[7:0]), .S(CHS[2:0]), .RN(n_A_21), .SE(n_A_1G), .OFDT(
        n_A_2F), .TE(n_A_1B), .DE4(n_A_28), .DE3(n_A_34), .DE2(n_A_1T), .DE1(
        n_A_25), .TI(n_A_2P), .CK(MCK), .Q({n_CRDC07, n_CRDC06, n_CRDC05, 
        n_CRDC04, n_CRDC03, n_CRDC02, n_CRDC01, n_CRDC00}), .CHQ(n_A_2X), .TO(
        n_A_2N) );
  OFR8 A04 ( .D(GPWD[15:8]), .S(CHS[2:0]), .RN(n_A_21), .SE(n_A_1H), .OFDT(
        n_A_2F), .TE(n_A_1B), .DE4(n_A_28), .DE3(n_A_33), .DE2(n_A_1V), .DE1(
        n_A_30), .TI(n_A_2R), .CK(MCK), .Q({n_CRDB15, n_CRDB14, n_CRDB13, 
        n_CRDB12, n_CRDB11, n_CRDB10, n_CRDB09, n_CRDB08}), .CHQ(n_A_2L), .TO(
        n_A_2P) );
  OFR8 A03 ( .D(GPWD[7:0]), .S(CHS[2:0]), .RN(n_A_21), .SE(n_A_1J), .OFDT(
        n_A_2F), .TE(n_A_1B), .DE4(n_A_28), .DE3(n_A_33), .DE2(n_A_1V), .DE1(
        n_A_30), .TI(n_A_2C), .CK(MCK), .Q({n_CRDB07, n_CRDB06, n_CRDB05, 
        n_CRDB04, n_CRDB03, n_CRDB02, n_CRDB01, n_CRDB00}), .CHQ(n_A_2K), .TO(
        n_A_2R) );
  OFR8 A02 ( .D(GPWD[15:8]), .S(CHS[2:0]), .RN(n_A_21), .SE(n_A_1K), .OFDT(
        n_A_2F), .TE(n_A_1B), .DE4(n_A_28), .DE3(n_A_32), .DE2(n_A_1W), .DE1(
        n_A_31), .TI(n_A_2S), .CK(MCK), .Q({n_CRDA15, n_CRDA14, n_CRDA13, 
        n_CRDA12, n_CRDA11, n_CRDA10, n_CRDA09, n_CRDA08}), .CHQ(n_A_2J), .TO(
        n_A_2C) );
  OFR8 A01 ( .D(GPWD[7:0]), .S(CHS[2:0]), .RN(n_A_21), .SE(n_A_1L), .OFDT(
        n_A_2F), .TE(n_A_1B), .DE4(n_A_28), .DE3(n_A_32), .DE2(n_A_1W), .DE1(
        n_A_31), .TI(n_A_36), .CK(MCK), .Q({n_CRDA07, n_CRDA06, n_CRDA05, 
        n_CRDA04, n_CRDA03, n_CRDA02, n_CRDA01, n_CRDA00}), .CHQ(n_A_2Y), .TO(
        n_A_2S) );
  BUFX2 A13 ( .A(CHOFDT), .Y(n_A_2F) );
  BUFX2 A12 ( .A(XRST), .Y(n_A_21) );
  DS164 A0C ( .A({n_CRDA15, n_CRDA14, n_CRDA13, n_CRDA12, n_CRDA11, n_CRDA10, 
        n_CRDA09, n_CRDA08, n_CRDA07, n_CRDA06, n_CRDA05, n_CRDA04, n_CRDA03, 
        n_CRDA02, n_CRDA01, n_CRDA00}), .B({n_CRDB15, n_CRDB14, n_CRDB13, 
        n_CRDB12, n_CRDB11, n_CRDB10, n_CRDB09, n_CRDB08, n_CRDB07, n_CRDB06, 
        n_CRDB05, n_CRDB04, n_CRDB03, n_CRDB02, n_CRDB01, n_CRDB00}), .C({
        n_CRDC15, n_CRDC14, n_CRDC13, n_CRDC12, n_CRDC11, n_CRDC10, n_CRDC09, 
        n_CRDC08, n_CRDC07, n_CRDC06, n_CRDC05, n_CRDC04, n_CRDC03, n_CRDC02, 
        n_CRDC01, n_CRDC00}), .D({n_CRDD15, n_CRDD14, n_CRDD13, n_CRDD12, 
        n_CRDD11, n_CRDD10, n_CRDD09, n_CRDD08, n_CRDD07, n_CRDD06, n_CRDD05, 
        n_CRDD04, n_CRDD03, n_CRDD02, n_CRDD01, n_CRDD00}), .S1(n_GPAB1), .S0(
        n_GPAB0), .Y({n_A_241, n_A_242, n_A_243, n_A_244, n_A_245, n_A_246, 
        n_A_247, n_A_248, n_A_249, n_A_2410, n_A_2411, n_A_2412, n_A_2413, 
        n_A_2414, n_A_2415, n_A_2416}) );
  ND8 A0A ( .H(n_A_2T), .G(n_A_2V), .F(n_A_2W), .E(n_A_2X), .D(n_A_2L), .C(
        n_A_2K), .B(n_A_2J), .A(n_A_2Y), .Y(CHOSLD) );
endmodule


module DS164 ( A, B, C, D, S1, S0, Y );
  input [15:0] A;
  input [15:0] B;
  input [15:0] C;
  input [15:0] D;
  output [15:0] Y;
  input S1, S0;
  wire   n_A_07, n_A_05;

  MX4X1 A100 ( .S1(n_A_05), .S0(n_A_07), .D(D[0]), .C(C[0]), .B(B[0]), .A(A[0]), .Y(Y[0]) );
  MX4X1 A101 ( .S1(n_A_05), .S0(n_A_07), .D(D[1]), .C(C[1]), .B(B[1]), .A(A[1]), .Y(Y[1]) );
  MX4X1 A102 ( .S1(n_A_05), .S0(n_A_07), .D(D[2]), .C(C[2]), .B(B[2]), .A(A[2]), .Y(Y[2]) );
  MX4X1 A103 ( .S1(n_A_05), .S0(n_A_07), .D(D[3]), .C(C[3]), .B(B[3]), .A(A[3]), .Y(Y[3]) );
  MX4X1 A104 ( .S1(n_A_05), .S0(n_A_07), .D(D[4]), .C(C[4]), .B(B[4]), .A(A[4]), .Y(Y[4]) );
  MX4X1 A105 ( .S1(n_A_05), .S0(n_A_07), .D(D[5]), .C(C[5]), .B(B[5]), .A(A[5]), .Y(Y[5]) );
  MX4X1 A106 ( .S1(n_A_05), .S0(n_A_07), .D(D[6]), .C(C[6]), .B(B[6]), .A(A[6]), .Y(Y[6]) );
  MX4X1 A107 ( .S1(n_A_05), .S0(n_A_07), .D(D[7]), .C(C[7]), .B(B[7]), .A(A[7]), .Y(Y[7]) );
  MX4X1 A108 ( .S1(n_A_05), .S0(n_A_07), .D(D[8]), .C(C[8]), .B(B[8]), .A(A[8]), .Y(Y[8]) );
  MX4X1 A109 ( .S1(n_A_05), .S0(n_A_07), .D(D[9]), .C(C[9]), .B(B[9]), .A(A[9]), .Y(Y[9]) );
  MX4X1 A110 ( .S1(n_A_05), .S0(n_A_07), .D(D[10]), .C(C[10]), .B(B[10]), .A(
        A[10]), .Y(Y[10]) );
  MX4X1 A111 ( .S1(n_A_05), .S0(n_A_07), .D(D[11]), .C(C[11]), .B(B[11]), .A(
        A[11]), .Y(Y[11]) );
  MX4X1 A112 ( .S1(n_A_05), .S0(n_A_07), .D(D[12]), .C(C[12]), .B(B[12]), .A(
        A[12]), .Y(Y[12]) );
  MX4X1 A113 ( .S1(n_A_05), .S0(n_A_07), .D(D[13]), .C(C[13]), .B(B[13]), .A(
        A[13]), .Y(Y[13]) );
  MX4X1 A114 ( .S1(n_A_05), .S0(n_A_07), .D(D[14]), .C(C[14]), .B(B[14]), .A(
        A[14]), .Y(Y[14]) );
  MX4X1 A115 ( .S1(n_A_05), .S0(n_A_07), .D(D[15]), .C(C[15]), .B(B[15]), .A(
        A[15]), .Y(Y[15]) );
  BUFX4 A205 ( .A(S1), .Y(n_A_05) );
  BUFX4 A204 ( .A(S0), .Y(n_A_07) );
endmodule


module OFR8 ( D, S, RN, SE, OFDT, TE, DE4, DE3, DE2, DE1, TI, CK, Q, CHQ, TO
 );
  input [7:0] D;
  input [2:0] S;
  output [7:0] Q;
  input RN, SE, OFDT, TE, DE4, DE3, DE2, DE1, TI, CK;
  output CHQ, TO;
  wire   n_A_1V, n_A_1W, n_A_1X, n_A_1Y, n_A_11, n_A_1E, n_A_1D, n_A_1C,
         n_A_22, n_A_12, n_A_10, n_A_0Y, n_A_0X, n_A_1B, n_A_1H, n_A_1U,
         n_A_16, n_A_15, n_A_14, n_A_13, n_A_17, n_A_18, n_A_19, n_A_1A,
         n_A_1K, n_A_1L, n_A_1M, n_A_1N, n_A_1P, n_A_1R, n_A_1S;

  DC08P A09 ( .EN(SE), .C(S[2]), .B(S[1]), .A(S[0]), .Y0(n_A_1V), .Y1(n_A_1W), 
        .Y2(n_A_1X), .Y3(n_A_1Y), .Y4(n_A_11), .Y5(n_A_1E), .Y6(n_A_1D), .Y7(
        n_A_1C) );
  INVX1 A1C ( .A(n_A_22), .Y(CHQ) );
  BUFX2 A11 ( .A(DE4), .Y(n_A_12) );
  BUFX2 A10 ( .A(DE3), .Y(n_A_10) );
  BUFX2 A0Y ( .A(DE2), .Y(n_A_0Y) );
  BUFX2 A0X ( .A(DE1), .Y(n_A_0X) );
  BUFX2 A0W ( .A(OFDT), .Y(n_A_1B) );
  BUFX2 A0V ( .A(TE), .Y(n_A_1H) );
  BUFX2 A0K ( .A(RN), .Y(n_A_1U) );
  ND8 A0A ( .H(n_A_1A), .G(n_A_19), .F(n_A_18), .E(n_A_17), .D(n_A_16), .C(
        n_A_15), .B(n_A_14), .A(n_A_13), .Y(n_A_22) );
  OFRU A08 ( .RN(n_A_1U), .TE(n_A_1H), .CK(CK), .CHS(n_A_1C), .OFDT(n_A_1B), 
        .DE2(n_A_0Y), .DE4(n_A_12), .DE3(n_A_10), .TI(n_A_1K), .DE1(n_A_0X), 
        .D(D[7]), .TO(TO), .Q(Q[7]), .CHQ(n_A_1A) );
  OFRU A07 ( .RN(n_A_1U), .TE(n_A_1H), .CK(CK), .CHS(n_A_1D), .OFDT(n_A_1B), 
        .DE2(n_A_0Y), .DE4(n_A_12), .DE3(n_A_10), .TI(n_A_1L), .DE1(n_A_0X), 
        .D(D[6]), .TO(n_A_1K), .Q(Q[6]), .CHQ(n_A_19) );
  OFRU A06 ( .RN(n_A_1U), .TE(n_A_1H), .CK(CK), .CHS(n_A_1E), .OFDT(n_A_1B), 
        .DE2(n_A_0Y), .DE4(n_A_12), .DE3(n_A_10), .TI(n_A_1M), .DE1(n_A_0X), 
        .D(D[5]), .TO(n_A_1L), .Q(Q[5]), .CHQ(n_A_18) );
  OFRU A05 ( .RN(n_A_1U), .TE(n_A_1H), .CK(CK), .CHS(n_A_11), .OFDT(n_A_1B), 
        .DE2(n_A_0Y), .DE4(n_A_12), .DE3(n_A_10), .TI(n_A_1N), .DE1(n_A_0X), 
        .D(D[4]), .TO(n_A_1M), .Q(Q[4]), .CHQ(n_A_17) );
  OFRU A04 ( .RN(n_A_1U), .TE(n_A_1H), .CK(CK), .CHS(n_A_1Y), .OFDT(n_A_1B), 
        .DE2(n_A_0Y), .DE4(n_A_12), .DE3(n_A_10), .TI(n_A_1P), .DE1(n_A_0X), 
        .D(D[3]), .TO(n_A_1N), .Q(Q[3]), .CHQ(n_A_16) );
  OFRU A03 ( .RN(n_A_1U), .TE(n_A_1H), .CK(CK), .CHS(n_A_1X), .OFDT(n_A_1B), 
        .DE2(n_A_0Y), .DE4(n_A_12), .DE3(n_A_10), .TI(n_A_1R), .DE1(n_A_0X), 
        .D(D[2]), .TO(n_A_1P), .Q(Q[2]), .CHQ(n_A_15) );
  OFRU A02 ( .RN(n_A_1U), .TE(n_A_1H), .CK(CK), .CHS(n_A_1W), .OFDT(n_A_1B), 
        .DE2(n_A_0Y), .DE4(n_A_12), .DE3(n_A_10), .TI(n_A_1S), .DE1(n_A_0X), 
        .D(D[1]), .TO(n_A_1R), .Q(Q[1]), .CHQ(n_A_14) );
  OFRU A01 ( .RN(n_A_1U), .TE(n_A_1H), .CK(CK), .CHS(n_A_1V), .OFDT(n_A_1B), 
        .DE2(n_A_0Y), .DE4(n_A_12), .DE3(n_A_10), .TI(TI), .DE1(n_A_0X), .D(
        D[0]), .TO(n_A_1S), .Q(Q[0]), .CHQ(n_A_13) );
endmodule


module OFRU ( RN, TE, CK, CHS, OFDT, DE2, DE4, DE3, TI, DE1, D, TO, Q, CHQ );
  input RN, TE, CK, CHS, OFDT, DE2, DE4, DE3, TI, DE1, D;
  output TO, Q, CHQ;
  wire   n_A_0A, n_A_0C, n_A_03, n_A_0B, n_A_0K, n_A_0J;

  FER1 A03 ( .RN(n_A_0A), .TE(n_A_03), .TI(n_A_0C), .CK(CK), .DE(DE2), .D(D), 
        .SR(DE4), .Q(n_A_0B) );
  FER1 A02 ( .RN(n_A_0A), .TE(n_A_03), .TI(TI), .CK(CK), .DE(DE1), .D(D), .SR(
        DE3), .Q(n_A_0C) );
  NAND2X1 A05 ( .A(Q), .B(CHS), .Y(CHQ) );
  BUFX2 A09 ( .A(Q), .Y(TO) );
  BUFX2 A08 ( .A(RN), .Y(n_A_0A) );
  BUFX2 A07 ( .A(TE), .Y(n_A_03) );
  AND2X1 A06 ( .A(DE4), .B(n_A_0B), .Y(n_A_0K) );
  AND2X1 A04 ( .A(OFDT), .B(CHS), .Y(n_A_0J) );
  FSR1 A01 ( .RN(n_A_0A), .TE(n_A_03), .TI(n_A_0B), .CK(CK), .DE(DE3), .D(
        n_A_0C), .SR(n_A_0J), .SS(n_A_0K), .Q(Q) );
endmodule


module FSR1 ( RN, TE, TI, CK, DE, D, SR, SS, Q );
  input RN, TE, TI, CK, DE, D, SR, SS;
  output Q;
  wire   n_A_0D, n_A_0A, n_A_0B, n_A_0C;

  DFFRHQX2 A01 ( .D(n_A_0D), .CK(CK), .RN(RN), .Q(Q) );
  INVX1 A05 ( .A(SR), .Y(n_A_0A) );
  AND2X1 A04 ( .A(n_A_0B), .B(n_A_0A), .Y(n_A_0C) );
  OR2X1 A03 ( .A(Q), .B(SS), .Y(n_A_0B) );
  MX2X1 A02 ( .S0(DE), .B(D), .A(n_A_0C), .Y(n_A_0D) );
endmodule


module FER1 ( RN, TE, TI, CK, DE, D, SR, Q );
  input RN, TE, TI, CK, DE, D, SR;
  output Q;
  wire   n_A_0D, n_A_0A, n_A_0C;

  DFFRHQX2 A01 ( .D(n_A_0D), .CK(CK), .RN(RN), .Q(Q) );
  INVX1 A05 ( .A(SR), .Y(n_A_0A) );
  AND2X1 A04 ( .A(Q), .B(n_A_0A), .Y(n_A_0C) );
  MX2X1 A02 ( .S0(DE), .B(D), .A(n_A_0C), .Y(n_A_0D) );
endmodule


module ND8 ( H, G, F, E, D, C, B, A, Y );
  input H, G, F, E, D, C, B, A;
  output Y;
  wire   n_A_0A, n_A_01;

  NAND2X1 A0C ( .A(n_A_0A), .B(n_A_01), .Y(Y) );
  AND4X1 A01 ( .A(E), .B(F), .C(G), .D(H), .Y(n_A_01) );
  AND4X1 A0B ( .A(A), .B(B), .C(C), .D(D), .Y(n_A_0A) );
endmodule


module PDL4 ( RN, TE, ENP, SS4, SS3, SS2, TI, SS1, CK, TO, P4, P3, P2, P1 );
  input RN, TE, ENP, SS4, SS3, SS2, TI, SS1, CK;
  output TO, P4, P3, P2, P1;
  wire   n_A_0M, n_A_0F, n_A_08, n_A_0A, n_A_0B, n_A_0C, n_A_0D;

  BUFX2 A0C ( .A(ENP), .Y(n_A_0M) );
  BUFX2 A0B ( .A(TE), .Y(n_A_0F) );
  BUFX2 A0A ( .A(RN), .Y(n_A_08) );
  BUFX2 A09 ( .A(n_A_0A), .Y(TO) );
  AND2X1 A08 ( .A(n_A_0A), .B(n_A_0M), .Y(P4) );
  AND2X1 A07 ( .A(n_A_0B), .B(n_A_0M), .Y(P3) );
  AND2X1 A06 ( .A(n_A_0C), .B(n_A_0M), .Y(P2) );
  AND2X1 A05 ( .A(n_A_0D), .B(n_A_0M), .Y(P1) );
  SR1R A04 ( .RN(n_A_08), .TE(n_A_0F), .TI(n_A_0B), .CK(CK), .SR(P4), .SS(SS4), 
        .Q(n_A_0A) );
  SR1R A03 ( .RN(n_A_08), .TE(n_A_0F), .TI(n_A_0C), .CK(CK), .SR(P3), .SS(SS3), 
        .Q(n_A_0B) );
  SR1R A02 ( .RN(n_A_08), .TE(n_A_0F), .TI(n_A_0D), .CK(CK), .SR(P2), .SS(SS2), 
        .Q(n_A_0C) );
  SR1R A01 ( .RN(n_A_08), .TE(n_A_0F), .TI(TI), .CK(CK), .SR(P1), .SS(SS1), 
        .Q(n_A_0D) );
endmodule


module DC08 ( C, B, A, Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7 );
  input C, B, A;
  output Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7;
  wire   n_A_0D, n_A_0B, n_A_09, n_A_0E, n_A_0C, n_A_0A;

  NAND3X1 A08 ( .A(n_A_0D), .B(n_A_0B), .C(n_A_09), .Y(Y7) );
  NAND3X1 A07 ( .A(n_A_0E), .B(n_A_0B), .C(n_A_09), .Y(Y6) );
  NAND3X1 A06 ( .A(n_A_0D), .B(n_A_0C), .C(n_A_09), .Y(Y5) );
  NAND3X1 A05 ( .A(n_A_0E), .B(n_A_0C), .C(n_A_09), .Y(Y4) );
  NAND3X1 A04 ( .A(n_A_0D), .B(n_A_0B), .C(n_A_0A), .Y(Y3) );
  NAND3X1 A03 ( .A(n_A_0E), .B(n_A_0B), .C(n_A_0A), .Y(Y2) );
  NAND3X1 A02 ( .A(n_A_0D), .B(n_A_0C), .C(n_A_0A), .Y(Y1) );
  NAND3X1 A01 ( .A(n_A_0E), .B(n_A_0C), .C(n_A_0A), .Y(Y0) );
  INVX1 A0B ( .A(n_A_0D), .Y(n_A_0E) );
  INVX1 A0D ( .A(n_A_0B), .Y(n_A_0C) );
  INVX1 A0F ( .A(n_A_09), .Y(n_A_0A) );
  BUFX2 A0E ( .A(A), .Y(n_A_0D) );
  BUFX2 A0C ( .A(B), .Y(n_A_0B) );
  BUFX2 A0A ( .A(C), .Y(n_A_09) );
endmodule


module GPMREG ( PIA, PIDI, CHORD, WMRD, XRST, TE, XPOE, XPWE, TI, TLWRDY, 
        THWRDY, WWRDY, EWRDY, MCK, GPA, PMA, GPD, PMD, SOBWS, CHLV, ITPD, PIDO, 
        EDBRS, CHTEST, EXMBIH, RXESEN, RXEN, TXEN, PRDY, PCEBEN, SURDEN, EMCL, 
        START, CHORE, WMDRE, TO, WMDWE, CHOWE, TLWREQ, THWREQ, WWREQ, EWREQ );
  input [10:0] PIA;
  input [15:0] PIDI;
  input [15:0] CHORD;
  input [7:0] WMRD;
  output [3:0] GPA;
  output [8:0] PMA;
  output [15:0] GPD;
  output [15:0] PMD;
  output [1:0] SOBWS;
  output [2:0] CHLV;
  output [7:0] ITPD;
  output [15:0] PIDO;
  output [1:0] EDBRS;
  input XRST, TE, XPOE, XPWE, TI, TLWRDY, THWRDY, WWRDY, EWRDY, MCK;
  output CHTEST, EXMBIH, RXESEN, RXEN, TXEN, PRDY, PCEBEN, SURDEN, EMCL, START,
         CHORE, WMDRE, TO, WMDWE, CHOWE, TLWREQ, THWREQ, WWREQ, EWREQ;
  wire   n_PIAB00, n_PIAB01, n_PIAB02, n_PIAB03, n_PIAB04, n_PIAB05, n_PIAB06,
         n_PIAB07, n_PIAB08, n_PIAB09, n_PMA00, n_PMA01, n_PMA02, n_PMA03,
         n_PMA04, n_PMA05, n_PMA06, n_PMA07, n_A_1J, n_A_0U, n_A_2B, n_A_1K,
         n_A_05, n_PMA08, n_A_1Y, n_A_1L, n_A_2K, n_A_0Y, n_A_1X, n_A_0K,
         n_A_17, n_A_10, n_A_0V, n_PIAB10, n_A_19, n_A_0H, n_PMA09, n_PMA10,
         n_A_18, n_A_0X;

  BUFX2 A100 ( .A(PIDI[0]), .Y(GPD[0]) );
  BUFX2 A101 ( .A(PIDI[1]), .Y(GPD[1]) );
  BUFX2 A102 ( .A(PIDI[2]), .Y(GPD[2]) );
  BUFX2 A103 ( .A(PIDI[3]), .Y(GPD[3]) );
  BUFX2 A104 ( .A(PIDI[4]), .Y(GPD[4]) );
  BUFX2 A105 ( .A(PIDI[5]), .Y(GPD[5]) );
  BUFX2 A106 ( .A(PIDI[6]), .Y(GPD[6]) );
  BUFX2 A107 ( .A(PIDI[7]), .Y(GPD[7]) );
  BUFX2 A108 ( .A(PIDI[8]), .Y(GPD[8]) );
  BUFX2 A109 ( .A(PIDI[9]), .Y(GPD[9]) );
  BUFX2 A110 ( .A(PIDI[10]), .Y(GPD[10]) );
  BUFX2 A111 ( .A(PIDI[11]), .Y(GPD[11]) );
  BUFX2 A112 ( .A(PIDI[12]), .Y(GPD[12]) );
  BUFX2 A113 ( .A(PIDI[13]), .Y(GPD[13]) );
  BUFX2 A114 ( .A(PIDI[14]), .Y(GPD[14]) );
  BUFX2 A200 ( .A(n_PIAB00), .Y(GPA[0]) );
  BUFX2 A201 ( .A(n_PIAB01), .Y(GPA[1]) );
  BUFX2 A202 ( .A(n_PIAB02), .Y(GPA[2]) );
  BUFX2 A000 ( .A(PIA[0]), .Y(n_PIAB00) );
  BUFX2 A001 ( .A(PIA[1]), .Y(n_PIAB01) );
  BUFX2 A002 ( .A(PIA[2]), .Y(n_PIAB02) );
  BUFX2 A003 ( .A(PIA[3]), .Y(n_PIAB03) );
  BUFX2 A004 ( .A(PIA[4]), .Y(n_PIAB04) );
  BUFX2 A005 ( .A(PIA[5]), .Y(n_PIAB05) );
  BUFX2 A006 ( .A(PIA[6]), .Y(n_PIAB06) );
  BUFX2 A007 ( .A(PIA[7]), .Y(n_PIAB07) );
  BUFX2 A008 ( .A(PIA[8]), .Y(n_PIAB08) );
  BUFX2 A009 ( .A(PIA[9]), .Y(n_PIAB09) );
  OR2X2 A300 ( .A(CHORD[0]), .B(WMRD[0]), .Y(PIDO[0]) );
  OR2X2 A301 ( .A(CHORD[1]), .B(WMRD[1]), .Y(PIDO[1]) );
  OR2X2 A302 ( .A(CHORD[2]), .B(WMRD[2]), .Y(PIDO[2]) );
  OR2X2 A303 ( .A(CHORD[3]), .B(WMRD[3]), .Y(PIDO[3]) );
  OR2X2 A304 ( .A(CHORD[4]), .B(WMRD[4]), .Y(PIDO[4]) );
  OR2X2 A305 ( .A(CHORD[5]), .B(WMRD[5]), .Y(PIDO[5]) );
  OR2X2 A306 ( .A(CHORD[6]), .B(WMRD[6]), .Y(PIDO[6]) );
  BUFX2 A400 ( .A(CHORD[8]), .Y(PIDO[8]) );
  BUFX2 A401 ( .A(CHORD[9]), .Y(PIDO[9]) );
  BUFX2 A402 ( .A(CHORD[10]), .Y(PIDO[10]) );
  BUFX2 A403 ( .A(CHORD[11]), .Y(PIDO[11]) );
  BUFX2 A404 ( .A(CHORD[12]), .Y(PIDO[12]) );
  BUFX2 A405 ( .A(CHORD[13]), .Y(PIDO[13]) );
  BUFX2 A406 ( .A(CHORD[14]), .Y(PIDO[14]) );
  BUFX4 A500 ( .A(n_PMA00), .Y(PMA[0]) );
  BUFX4 A501 ( .A(n_PMA01), .Y(PMA[1]) );
  BUFX4 A502 ( .A(n_PMA02), .Y(PMA[2]) );
  BUFX4 A503 ( .A(n_PMA03), .Y(PMA[3]) );
  BUFX4 A504 ( .A(n_PMA04), .Y(PMA[4]) );
  BUFX4 A505 ( .A(n_PMA05), .Y(PMA[5]) );
  BUFX4 A506 ( .A(n_PMA06), .Y(PMA[6]) );
  BUFX4 A507 ( .A(n_PMA07), .Y(PMA[7]) );
  FE08R A1S ( .D(GPD[7:0]), .TI(CHTEST), .EN(n_A_1J), .CK(MCK), .TE(n_A_0U), 
        .RN(n_A_2B), .Q(ITPD), .TO(TO) );
  FE08RB A2S ( .D(GPD[7:0]), .TI(SURDEN), .EN(n_A_1K), .CK(MCK), .TE(n_A_0U), 
        .RN(n_A_2B), .Q0(START), .Q1(EMCL), .Q2(TXEN), .Q3(RXEN), .Q4(RXESEN), 
        .Q5(PCEBEN), .Q6(EXMBIH), .Q7(CHTEST) );
  INVX2 A09 ( .A(XPWE), .Y(n_A_05) );
  BUFX4 A508 ( .A(n_PMA08), .Y(PMA[8]) );
  INVX2 A2A ( .A(n_A_1Y), .Y(PRDY) );
  FE08RB A1R ( .D(GPD[7:0]), .TI(n_A_2K), .EN(n_A_1L), .CK(MCK), .TE(n_A_0U), 
        .RN(n_A_2B), .Q0(SOBWS[0]), .Q1(SOBWS[1]), .Q2(CHLV[0]), .Q3(CHLV[1]), 
        .Q4(CHLV[2]), .Q5(EDBRS[0]), .Q6(EDBRS[1]), .Q7(SURDEN) );
  GPDEC A0T ( .A({n_PIAB10, n_PIAB09, n_PIAB08, n_PIAB07, n_PIAB06, n_PIAB05, 
        n_PIAB04, n_PIAB03, n_PIAB02, n_PIAB01, n_PIAB00}), .WM(n_A_10), .CHO(
        n_A_17), .WSIP(n_A_1X), .MOD(n_A_0V), .PM(n_A_0K), .SYS(n_A_0Y) );
  BUFX2 A407 ( .A(CHORD[15]), .Y(PIDO[15]) );
  OR2X2 A307 ( .A(CHORD[7]), .B(WMRD[7]), .Y(PIDO[7]) );
  AND2X2 A0L ( .A(n_A_10), .B(n_A_19), .Y(WMDRE) );
  AND2X2 A0M ( .A(n_A_10), .B(n_A_05), .Y(WMDWE) );
  AND2X2 A0K ( .A(n_A_17), .B(n_A_19), .Y(CHORE) );
  AND2X2 A0S ( .A(n_A_17), .B(n_A_05), .Y(CHOWE) );
  AND2X2 A0P ( .A(n_A_0K), .B(n_A_05), .Y(n_A_0H) );
  DC04P A03 ( .EN(n_A_1Y), .B(n_PMA10), .A(n_PMA09), .Y3(TLWREQ), .Y2(THWREQ), 
        .Y1(WWREQ), .Y0(EWREQ) );
  BUFX2 A0X ( .A(TE), .Y(n_A_0U) );
  BUFX2 A0W ( .A(XRST), .Y(n_A_2B) );
  INVX1 A06 ( .A(XPOE), .Y(n_A_19) );
  AND2X1 A08 ( .A(n_A_1X), .B(n_A_05), .Y(n_A_1J) );
  AND2X1 A07 ( .A(n_A_0Y), .B(n_A_05), .Y(n_A_1K) );
  AND2X1 A0N ( .A(n_A_0V), .B(n_A_05), .Y(n_A_1L) );
  BUFX2 A010 ( .A(PIA[10]), .Y(n_PIAB10) );
  BUFX2 A203 ( .A(n_PIAB03), .Y(GPA[3]) );
  SR1R A05 ( .RN(n_A_2B), .TE(n_A_0U), .TI(TI), .CK(MCK), .SR(n_A_18), .SS(
        n_A_0H), .Q(n_A_1Y) );
  BUFX2 A115 ( .A(PIDI[15]), .Y(GPD[15]) );
  MX4X1 A04 ( .S1(n_PMA10), .S0(n_PMA09), .D(TLWRDY), .C(THWRDY), .B(WWRDY), 
        .A(EWRDY), .Y(n_A_18) );
  FE11R A02 ( .D({n_PIAB10, n_PIAB09, n_PIAB08, n_PIAB07, n_PIAB06, n_PIAB05, 
        n_PIAB04, n_PIAB03, n_PIAB02, n_PIAB01, n_PIAB00}), .TI(n_A_1Y), .RN(
        n_A_2B), .TE(n_A_0U), .CK(MCK), .EN(n_A_0H), .Q({n_PMA10, n_PMA09, 
        n_PMA08, n_PMA07, n_PMA06, n_PMA05, n_PMA04, n_PMA03, n_PMA02, n_PMA01, 
        n_PMA00}), .TO(n_A_0X) );
  FE16R A01 ( .D(GPD), .TI(n_A_0X), .RN(n_A_2B), .TE(n_A_0U), .CK(MCK), .EN(
        n_A_0H), .Q(PMD), .TO(n_A_2K) );
endmodule


module FE11R ( D, TI, RN, TE, CK, EN, Q, TO );
  input [10:0] D;
  output [10:0] Q;
  input TI, RN, TE, CK, EN;
  output TO;
  wire   n_A_10, n_A_0W, n_A_0P;

  FE1R A01 ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[9]), .CK(CK), .EN(n_A_0P), .D(
        D[10]), .Q(Q[10]) );
  BUFX3 A05 ( .A(RN), .Y(n_A_10) );
  BUFX3 A04 ( .A(TE), .Y(n_A_0W) );
  BUFX3 A02 ( .A(EN), .Y(n_A_0P) );
  BUFX2 A03 ( .A(Q[10]), .Y(TO) );
  FE1R A0N ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[8]), .CK(CK), .EN(n_A_0P), .D(
        D[9]), .Q(Q[9]) );
  FE1R A0M ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[7]), .CK(CK), .EN(n_A_0P), .D(
        D[8]), .Q(Q[8]) );
  FE1R A0L ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[6]), .CK(CK), .EN(n_A_0P), .D(
        D[7]), .Q(Q[7]) );
  FE1R A0K ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[5]), .CK(CK), .EN(n_A_0P), .D(
        D[6]), .Q(Q[6]) );
  FE1R A0J ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[4]), .CK(CK), .EN(n_A_0P), .D(
        D[5]), .Q(Q[5]) );
  FE1R A0H ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[3]), .CK(CK), .EN(n_A_0P), .D(
        D[4]), .Q(Q[4]) );
  FE1R A0G ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[2]), .CK(CK), .EN(n_A_0P), .D(
        D[3]), .Q(Q[3]) );
  FE1R A0F ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[1]), .CK(CK), .EN(n_A_0P), .D(
        D[2]), .Q(Q[2]) );
  FE1R A0E ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[0]), .CK(CK), .EN(n_A_0P), .D(
        D[1]), .Q(Q[1]) );
  FE1R A0D ( .RN(n_A_10), .TE(n_A_0W), .TI(TI), .CK(CK), .EN(n_A_0P), .D(D[0]), 
        .Q(Q[0]) );
endmodule


module GPDEC ( A, WM, CHO, WSIP, MOD, PM, SYS );
  input [10:0] A;
  output WM, CHO, WSIP, MOD, PM, SYS;
  wire   n_A_13, n_A_10, n_A_0U, n_A_0S, n_A_0Y, n_A_12, n_A_0T, n_A_0V,
         n_A_11, n_A_14, n_A_15;

  INVX1 A16 ( .A(A[0]), .Y(n_A_13) );
  BUFX2 A15 ( .A(A[1]), .Y(n_A_10) );
  BUFX2 A0V ( .A(A[4]), .Y(n_A_0U) );
  BUFX2 A0T ( .A(A[5]), .Y(n_A_0S) );
  NOR3X2 A0C ( .A(A[10]), .B(A[9]), .C(A[8]), .Y(n_A_0Y) );
  NOR4X2 A002 ( .A(A[7]), .B(A[6]), .C(A[5]), .D(A[4]), .Y(n_A_12) );
  AND3X1 A012 ( .A(n_A_0Y), .B(n_A_0T), .C(n_A_0S), .Y(WM) );
  AND3X1 A011 ( .A(n_A_0Y), .B(n_A_0V), .C(n_A_0U), .Y(CHO) );
  NOR3X1 A006 ( .A(A[7]), .B(A[6]), .C(A[4]), .Y(n_A_0T) );
  NOR3X1 A007 ( .A(A[7]), .B(A[6]), .C(A[5]), .Y(n_A_0V) );
  NOR3X1 A00U ( .A(A[3]), .B(A[2]), .C(A[0]), .Y(n_A_11) );
  NOR3X1 A005 ( .A(A[3]), .B(A[2]), .C(A[1]), .Y(n_A_14) );
  INVX1 A00S ( .A(n_A_13), .Y(n_A_15) );
  AND4X1 A00K ( .A(n_A_0Y), .B(n_A_12), .C(n_A_11), .D(n_A_10), .Y(WSIP) );
  AND4X1 A00J ( .A(n_A_0Y), .B(n_A_12), .C(n_A_14), .D(n_A_15), .Y(MOD) );
  AND4X1 A004 ( .A(n_A_0Y), .B(n_A_12), .C(n_A_14), .D(n_A_13), .Y(SYS) );
  INVX2 A003 ( .A(n_A_0Y), .Y(PM) );
endmodule


module FE08RB ( D, TI, EN, CK, TE, RN, Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7 );
  input [7:0] D;
  input TI, EN, CK, TE, RN;
  output Q0, Q1, Q2, Q3, Q4, Q5, Q6, Q7;
  wire   n_A_0T, n_A_0K, n_A_0U;

  BUFX2 A0V ( .A(EN), .Y(n_A_0T) );
  BUFX2 A0T ( .A(TE), .Y(n_A_0K) );
  BUFX2 A0S ( .A(RN), .Y(n_A_0U) );
  FE1R A08 ( .RN(n_A_0U), .TE(n_A_0K), .TI(Q6), .CK(CK), .EN(n_A_0T), .D(D[7]), 
        .Q(Q7) );
  FE1R A07 ( .RN(n_A_0U), .TE(n_A_0K), .TI(Q5), .CK(CK), .EN(n_A_0T), .D(D[6]), 
        .Q(Q6) );
  FE1R A06 ( .RN(n_A_0U), .TE(n_A_0K), .TI(Q4), .CK(CK), .EN(n_A_0T), .D(D[5]), 
        .Q(Q5) );
  FE1R A05 ( .RN(n_A_0U), .TE(n_A_0K), .TI(Q3), .CK(CK), .EN(n_A_0T), .D(D[4]), 
        .Q(Q4) );
  FE1R A04 ( .RN(n_A_0U), .TE(n_A_0K), .TI(Q2), .CK(CK), .EN(n_A_0T), .D(D[3]), 
        .Q(Q3) );
  FE1R A03 ( .RN(n_A_0U), .TE(n_A_0K), .TI(Q1), .CK(CK), .EN(n_A_0T), .D(D[2]), 
        .Q(Q2) );
  FE1R A02 ( .RN(n_A_0U), .TE(n_A_0K), .TI(Q0), .CK(CK), .EN(n_A_0T), .D(D[1]), 
        .Q(Q1) );
  FE1R A01 ( .RN(n_A_0U), .TE(n_A_0K), .TI(TI), .CK(CK), .EN(n_A_0T), .D(D[0]), 
        .Q(Q0) );
endmodule


module SYNCG ( TE, XRST, TI, MCK, ADMCK, TO, FSYNC, ENP );
  input TE, XRST, TI, MCK;
  output ADMCK, TO, FSYNC, ENP;
  wire   n_A_12, n_A_0S, n_MTCQ1, n_A_0N, n_A_0U, n_A_19, n_A_0X, n_A_10,
         n_A_18, n_MTCQ2, n_MTCQ0, n_MTCQ4, n_A_1A, n_MTCQ3, n_A_17, n_A_16,
         n_A_15, n_A_14, n_A_13;

  BUFX8 A11 ( .A(n_A_12), .Y(ENP) );
  BUFX2 A1D ( .A(TE), .Y(n_A_0S) );
  BUFX2 A18 ( .A(n_MTCQ1), .Y(ADMCK) );
  BUFX2 A12 ( .A(n_A_0N), .Y(TO) );
  CO01 A0S ( .RN(XRST), .TE(n_A_0S), .TI(TI), .CK(MCK), .Q(n_A_12) );
  TIELO A10 ( .Y(n_A_0U) );
  AND3X1 A0V ( .A(ENP), .B(n_A_19), .C(n_A_10), .Y(n_A_0X) );
  DL1D2 A0X ( .A(n_A_0X), .Y(FSYNC) );
  AND2X1 A0P ( .A(n_A_19), .B(ENP), .Y(n_A_18) );
  AD5 A0N ( .E(n_A_1A), .D(n_MTCQ4), .C(n_MTCQ2), .B(n_MTCQ1), .A(n_MTCQ0), 
        .Y(n_A_19) );
  INVX1 A0L ( .A(n_MTCQ3), .Y(n_A_1A) );
  NR6 A03 ( .F(n_A_0N), .E(n_A_13), .D(n_A_14), .C(n_A_15), .B(n_A_16), .A(
        n_A_17), .Y(n_A_10) );
  CO06 A02 ( .TI(n_MTCQ4), .RN(XRST), .TE(n_A_0S), .CK(MCK), .SCL(n_A_0U), 
        .EN(n_A_18), .Q5(n_A_0N), .Q4(n_A_13), .Q3(n_A_14), .Q2(n_A_15), .Q1(
        n_A_16), .Q0(n_A_17) );
  CO05 A01 ( .RN(XRST), .TE(n_A_0S), .CK(MCK), .SCL(n_A_18), .TI(n_A_12), .EN(
        ENP), .Q4(n_MTCQ4), .Q3(n_MTCQ3), .Q2(n_MTCQ2), .Q1(n_MTCQ1), .Q0(
        n_MTCQ0) );
endmodule


module DL1D2 ( A, Y );
  input A;
  output Y;
  wire   n_A_02;

  BUFX2 A04 ( .A(n_A_02), .Y(Y) );
  DLY1X1 A01 ( .A(A), .Y(n_A_02) );
endmodule


module CO01 ( RN, TE, TI, CK, Q );
  input RN, TE, TI, CK;
  output Q;
  wire   n_A_0D, n_A_0C;

  BUFX2 A04 ( .A(n_A_0D), .Y(n_A_0C) );
  DFFRX2 A03 ( .D(n_A_0C), .CK(CK), .RN(RN), .Q(Q), .QN(n_A_0D) );
endmodule


module ESP ( EEMDO, PMD, PMA, SOBWS, RXD, EIMO, ESSD, EDBRS, SDI2, TI1, EMCL, 
        RXESEN, ENP, TE, MCK, TI0, XRST, TXRDY, TXEN, RXEN, RXWE, SDI1, TSCST, 
        SURDEN, PCEBEN, ESYNC, EWREQ, EIMA, EIMDI, EEMDI, EEMA, TXD, EROMA, 
        TO1, EROMAS, TO0, RXSYNC, RXRDY, TXSYNC, TXRD, LRCKO, SCKO, SD2O, SD1O, 
        EWRDY, XEIMWE, XEEMWE, ESSCL, ESSCE, MLRCK, MSCK );
  input [15:0] EEMDO;
  input [15:0] PMD;
  input [7:0] PMA;
  input [1:0] SOBWS;
  input [31:0] RXD;
  input [15:0] EIMO;
  input [19:0] ESSD;
  input [1:0] EDBRS;
  output [7:0] EIMA;
  output [15:0] EIMDI;
  output [15:0] EEMDI;
  output [15:0] EEMA;
  output [31:0] TXD;
  output [8:0] EROMA;
  input SDI2, TI1, EMCL, RXESEN, ENP, TE, MCK, TI0, XRST, TXRDY, TXEN, RXEN,
         RXWE, SDI1, TSCST, SURDEN, PCEBEN, ESYNC, EWREQ;
  output TO1, EROMAS, TO0, RXSYNC, RXRDY, TXSYNC, TXRD, LRCKO, SCKO, SD2O,
         SD1O, EWRDY, XEIMWE, XEEMWE, ESSCL, ESSCE, MLRCK, MSCK;
  wire   n_A_06, n_A_2H, n_A_07, n_A_1G, n_A_0M, n_A_1R1, n_A_1R2, n_A_1R3,
         n_A_1R4, n_A_1R5, n_A_1R6, n_A_1R7, n_A_1R8, n_A_1R9, n_A_1R10,
         n_A_1R11, n_A_1R12, n_A_1R13, n_A_1R14, n_A_1R15, n_A_1R16, n_A_4H,
         n_A_0N, n_A_4F, n_A_0P, n_A_22, n_A_24, n_A_2J, n_A_25, n_A_3W,
         n_A_23, n_A_1V, n_A_2C, n_A_0K, n_A_33, n_A_0B, n_A_2S, n_A_3C,
         n_A_3X, n_A_2D, n_A_20, n_A_09, n_A_1Y, n_A_0U, n_A_1X, n_A_32,
         n_A_2K, n_A_0H, n_A_0F, n_A_0E, n_A_0D, n_A_3U, n_A_0V, n_A_08,
         n_A_1P, n_A_34, n_A_35, n_A_2V, n_A_10, n_A_4C, n_A_1U, n_A_1W,
         n_A_3L, n_A_3V, n_A_3K, n_A_3E, n_A_0W, n_A_21, n_A_0T, n_A_0A,
         n_A_2U, n_A_30, n_A_31, n_A_2W, n_A_2X, n_A_2N, n_A_2P, n_A_2L,
         n_A_2M, n_A_2R, n_A_2Y, n_A_2T, n_A_03, n_A_04, n_A_4G, n_A_11,
         n_A_4B1, n_A_4B2, n_A_4B3, n_A_4B4, n_A_4B5, n_A_4B6, n_A_4B7,
         n_A_4B8, n_A_4B9, n_A_4B10, n_A_4B11, n_A_4B12, n_A_4B13, n_A_4B14,
         n_A_4B15, n_A_4B16, n_A_4B17, n_A_4B18, n_A_4B19, n_A_4B20, n_A_2A,
         n_A_29, n_A_0L, n_A_031, n_A_032, n_A_033, n_A_034, n_A_035, n_A_036,
         n_A_037, n_A_038, n_A_039, n_A_0310, n_A_0311, n_A_0312, n_A_0313,
         n_A_0314, n_A_0315, n_A_0316, n_A_0317, n_A_0318, n_A_0319, n_A_0320,
         n_A_1M1, n_A_1M2, n_A_1M3, n_A_1M4, n_A_1M5, n_A_1M6, n_A_1M7,
         n_A_1M8, n_A_1M9, n_A_1M10, n_A_1M11, n_A_1M12, n_A_1M13, n_A_1M14,
         n_A_1M15, n_A_1M16, n_A_1M17, n_A_1M18, n_A_1M19, n_A_1M20, n_A_3J1,
         n_A_3J2, n_A_3J3, n_A_3J4, n_A_3J5, n_A_3J6, n_A_3J7, n_A_3J8,
         n_A_3J9, n_A_3J10, n_A_3J11, n_A_3J12, n_A_3J13, n_A_3J14, n_A_3J15,
         n_A_3J16, n_A_3J17, n_A_3J18, n_A_3J19, n_A_3J20, n_A_1T, n_A_3T1,
         n_A_3T2, n_A_3T3, n_A_3T4, n_A_3T5, n_A_3T6, n_A_3T7, n_A_3T8,
         n_A_3T9, n_A_3T10, n_A_3T11, n_A_3T12, n_A_3T13, n_A_3T14, n_A_3T15,
         n_A_3T16, n_A_3T17, n_A_3T18, n_A_3T19, n_A_3T20, n_A_2F1, n_A_2F2,
         n_A_2F3, n_A_2F4, n_A_27, n_A_3D1, n_A_3D2, n_A_3D3, n_A_3D4, n_A_3D5,
         n_A_3D6, n_A_3D7, n_A_3D8, n_A_3D9, n_A_3D10, n_A_3D11, n_A_3D12,
         n_A_3D13, n_A_3D14, n_A_3D15, n_A_3D16, n_A_3D17, n_A_3D18, n_A_3D19,
         n_A_3D20, n_A_1K1, n_A_1K2, n_A_1K3, n_A_1K4, n_A_1K5, n_A_1K6,
         n_A_1K7, n_A_1K8, n_A_1K9, n_A_1K10, n_A_1K11, n_A_1K12, n_A_1K13,
         n_A_1K14, n_A_1K15, n_A_1K16, n_A_1K17, n_A_1K18, n_A_1K19, n_A_1K20,
         n_A_3M1, n_A_3M2, n_A_3M3, n_A_3M4, n_A_3M5, n_A_3M6, n_A_3M7,
         n_A_3M8, n_A_3M9, n_A_3M10, n_A_3M11, n_A_3M12, n_A_3M13, n_A_3M14,
         n_A_3M15, n_A_3M16, n_A_3M17, n_A_3M18, n_A_3M19, n_A_3M20;

  EIMCT A05 ( .EDBR({n_A_1R1, n_A_1R2, n_A_1R3, n_A_1R4, n_A_1R5, n_A_1R6, 
        n_A_1R7, n_A_1R8, n_A_1R9, n_A_1R10, n_A_1R11, n_A_1R12, n_A_1R13, 
        n_A_1R14, n_A_1R15, n_A_1R16}), .EEMDO(EEMDO), .PMD(PMD), .EMCL(EMCL), 
        .EEMDS(n_A_2H), .ENP(n_A_0M), .EWREQ(EWREQ), .EPWEN(n_A_06), .EIMWE(
        n_A_1G), .ESCST(n_A_07), .EIMDI(EIMDI), .EWRDY(EWRDY), .XEIMWE(XEIMWE)
         );
  ESPSQ A01 ( .XRST(n_A_0P), .TE(n_A_4F), .TI(n_A_0N), .MCK(MCK), .TSCST(TSCST), .ESYNC(n_A_4H), .ENP(n_A_0M), .PMA(PMA), .RXESEN(RXESEN), .PCEBEN(PCEBEN), 
        .SURDEN(SURDEN), .EEMADCL(n_A_25), .EEMDS(n_A_2H), .EEMDOLE(n_A_23), 
        .EOBLE(n_A_22), .EEMALE(n_A_24), .XEEMWE(XEEMWE), .ESCST(n_A_07), 
        .EIMA(EIMA), .TO(n_A_2J), .EYLE(n_A_3W), .EXLE(n_A_33), .EALE(n_A_0B), 
        .EBLE(n_A_2S), .LFACLLE(n_A_03), .DTLE(n_A_2V), .EQACCL(n_A_2C), 
        .TXLDLE(n_A_3K), .TXRDLE(n_A_3L), .ESSCL(ESSCL), .ESSCE(ESSCE), 
        .EQACCE(n_A_2D), .EOLE(n_A_20), .EQACLE(n_A_3X), .ERLE(n_A_1P), .ETLE(
        n_A_3C), .EIMWE(n_A_1G), .EROALE(n_A_3V), .ETOEN(n_A_0U), .EPSOEN(
        n_A_1Y), .EPOEN(n_A_09), .ET1EN(n_A_0H), .ET0EN(n_A_2K), .EXHEN(n_A_32), .EIMOEN(n_A_1X), .MCHS(n_A_0K), .ESSDEN(n_A_1U), .SIEXS(n_A_4C), .EXLRS(
        n_A_10), .EXTIEN(n_A_1W), .ERS2(n_A_35), .ERS1(n_A_34), .EROEN(n_A_1V), 
        .EQACS0(n_A_08), .EQOEN(n_A_0V), .ET5EN(n_A_3U), .ET4EN(n_A_0D), 
        .ET3EN(n_A_0E), .ET2EN(n_A_0F), .EPAEN(n_A_0A), .EAIVEN(n_A_2U), 
        .EOS1(n_A_0T), .EOS0(n_A_21), .EOOEN(n_A_0W), .ERLRS(n_A_3E), .LFACLS(
        n_A_04), .EMSFEN(n_A_4G), .DTEN(n_A_31), .EXEXEN(n_A_30), .PBSD4(
        n_A_2Y), .EPWEN(n_A_06), .EROMAS(EROMAS), .INC16(n_A_2T), .ESLMTEN(
        n_A_2R), .SAWPHEN(n_A_2M), .SFTEN(n_A_2L), .REPHEN(n_A_2P), .ABSEN(
        n_A_2N), .EPSFT2(n_A_2W), .EPBSU(n_A_2X) );
  ESPCV A03 ( .MCHS(n_A_0K), .SDI2(SDI2), .XRST(n_A_0P), .TI(TI0), .ESYNC(
        n_A_4H), .ENP(n_A_0M), .TE(n_A_4F), .SDI1(SDI1), .MCK(MCK), .LRS(
        n_A_10), .SPCO({n_A_4B1, n_A_4B2, n_A_4B3, n_A_4B4, n_A_4B5, n_A_4B6, 
        n_A_4B7, n_A_4B8, n_A_4B9, n_A_4B10, n_A_4B11, n_A_4B12, n_A_4B13, 
        n_A_4B14, n_A_4B15, n_A_4B16, n_A_4B17, n_A_4B18, n_A_4B19, n_A_4B20}), 
        .LRCK(MLRCK), .SCK(MSCK), .TO(n_A_11) );
  EEMIF A06 ( .EIMDO(EIMO), .EMCL(EMCL), .TI(n_A_29), .XRST(n_A_0P), .TE(
        n_A_4F), .MCK(MCK), .EEMALE(n_A_24), .EEMADCR(n_A_25), .EEMDOLE(n_A_23), .EEMDI(EEMDI), .EEMA(EEMA), .TO(n_A_2A) );
  ETXD A0B ( .EDBR({n_A_1R1, n_A_1R2, n_A_1R3, n_A_1R4, n_A_1R5, n_A_1R6, 
        n_A_1R7, n_A_1R8, n_A_1R9, n_A_1R10, n_A_1R11, n_A_1R12, n_A_1R13, 
        n_A_1R14, n_A_1R15, n_A_1R16}), .XRST(n_A_0P), .ESYNC(n_A_4H), .TI(
        n_A_0L), .TXRDY(TXRDY), .TXEN(TXEN), .TE(n_A_4F), .TXLDLE(n_A_3K), 
        .MCK(MCK), .TXRDLE(n_A_3L), .TXD(TXD), .TXSYNC(TXSYNC), .TXRD(TXRD), 
        .TO(n_A_0N) );
  EOREG A0A ( .EDB({n_A_031, n_A_032, n_A_033, n_A_034, n_A_035, n_A_036, 
        n_A_037, n_A_038, n_A_039, n_A_0310, n_A_0311, n_A_0312, n_A_0313, 
        n_A_0314, n_A_0315, n_A_0316, n_A_0317, n_A_0318, n_A_0319, n_A_0320}), 
        .SOBWS(SOBWS), .EOBLE(n_A_22), .XRST(n_A_0P), .ENP(n_A_0M), .ESYNC(
        n_A_4H), .TE(n_A_4F), .MCK(MCK), .EOLE(n_A_20), .EOS1(n_A_0T), .EOS0(
        n_A_21), .TI(n_A_2A), .EOO({n_A_1M1, n_A_1M2, n_A_1M3, n_A_1M4, 
        n_A_1M5, n_A_1M6, n_A_1M7, n_A_1M8, n_A_1M9, n_A_1M10, n_A_1M11, 
        n_A_1M12, n_A_1M13, n_A_1M14, n_A_1M15, n_A_1M16, n_A_1M17, n_A_1M18, 
        n_A_1M19, n_A_1M20}), .TO(TO0), .LRCK(LRCKO), .SCK(SCKO), .SDO2(SD2O), 
        .SDO1(SD1O) );
  ERXD A04 ( .SPCO({n_A_4B1, n_A_4B2, n_A_4B3, n_A_4B4, n_A_4B5, n_A_4B6, 
        n_A_4B7, n_A_4B8, n_A_4B9, n_A_4B10, n_A_4B11, n_A_4B12, n_A_4B13, 
        n_A_4B14, n_A_4B15, n_A_4B16, n_A_4B17, n_A_4B18, n_A_4B19, n_A_4B20}), 
        .RXD(RXD), .TI(n_A_11), .MCK(MCK), .SIEXS(n_A_4C), .XRST(n_A_0P), .TE(
        n_A_4F), .LRSEL(n_A_10), .RXEN(RXEN), .ESYNC(n_A_4H), .RXWE(RXWE), 
        .EXTI({n_A_3J1, n_A_3J2, n_A_3J3, n_A_3J4, n_A_3J5, n_A_3J6, n_A_3J7, 
        n_A_3J8, n_A_3J9, n_A_3J10, n_A_3J11, n_A_3J12, n_A_3J13, n_A_3J14, 
        n_A_3J15, n_A_3J16, n_A_3J17, n_A_3J18, n_A_3J19, n_A_3J20}), .RXSYNC(
        RXSYNC), .RXRDY(RXRDY), .TO(n_A_0L) );
  ESOPU A02 ( .EDB({n_A_031, n_A_032, n_A_033, n_A_034, n_A_035, n_A_036, 
        n_A_037, n_A_038, n_A_039, n_A_0310, n_A_0311, n_A_0312, n_A_0313, 
        n_A_0314, n_A_0315, n_A_0316, n_A_0317, n_A_0318, n_A_0319, n_A_0320}), 
        .EPSFT2(n_A_2W), .DTLE(n_A_2V), .EPBSD4(n_A_2Y), .EYLE(n_A_3W), .MCK(
        MCK), .TI(n_A_1T), .TE(n_A_4F), .EXHEN(n_A_32), .DTEN(n_A_31), 
        .EXEXEN(n_A_30), .EXLE(n_A_33), .EPBSU(n_A_2X), .XRST(n_A_0P), 
        .LFACLLE(n_A_03), .EROALE(n_A_3V), .EPOEN(n_A_09), .SFTEN(n_A_2L), 
        .SAWPHEN(n_A_2M), .ABSEN(n_A_2N), .REPHEN(n_A_2P), .ESLMTEN(n_A_2R), 
        .EBLE(n_A_2S), .EALE(n_A_0B), .EAIVEN(n_A_2U), .INC16(n_A_2T), .EPAEN(
        n_A_0A), .ESPO({n_A_3T1, n_A_3T2, n_A_3T3, n_A_3T4, n_A_3T5, n_A_3T6, 
        n_A_3T7, n_A_3T8, n_A_3T9, n_A_3T10, n_A_3T11, n_A_3T12, n_A_3T13, 
        n_A_3T14, n_A_3T15, n_A_3T16, n_A_3T17, n_A_3T18, n_A_3T19, n_A_3T20}), 
        .EROMA(EROMA), .LFACD({n_A_2F1, n_A_2F2, n_A_2F3, n_A_2F4}), .TO(
        n_A_29) );
  ERREG A08 ( .EDB({n_A_031, n_A_032, n_A_033, n_A_034, n_A_035, n_A_036, 
        n_A_037, n_A_038, n_A_039, n_A_0310, n_A_0311, n_A_0312, n_A_0313, 
        n_A_0314, n_A_0315, n_A_0316, n_A_0317, n_A_0318, n_A_0319, n_A_0320}), 
        .XRST(n_A_0P), .TE(n_A_4F), .ERLRS(n_A_3E), .ERS2(n_A_35), .ERS1(
        n_A_34), .ERLE(n_A_1P), .TI(n_A_2J), .MCK(MCK), .ERO({n_A_3D1, n_A_3D2, 
        n_A_3D3, n_A_3D4, n_A_3D5, n_A_3D6, n_A_3D7, n_A_3D8, n_A_3D9, 
        n_A_3D10, n_A_3D11, n_A_3D12, n_A_3D13, n_A_3D14, n_A_3D15, n_A_3D16, 
        n_A_3D17, n_A_3D18, n_A_3D19, n_A_3D20}), .TO(n_A_27) );
  BUFX2 A1V ( .A(ENP), .Y(n_A_0M) );
  BUFX4 A22 ( .A(TE), .Y(n_A_4F) );
  EDBMX A07 ( .EPSO({n_A_3T1, n_A_3T2, n_A_3T3, n_A_3T4, n_A_3T5, n_A_3T6, 
        n_A_3T7, n_A_3T8, n_A_3T9, n_A_3T10, n_A_3T11, n_A_3T12, n_A_3T13, 
        n_A_3T14, n_A_3T15, n_A_3T16, n_A_3T17, n_A_3T18, n_A_3T19, n_A_3T20}), 
        .EIMO(EIMO), .ETO({n_A_3M1, n_A_3M2, n_A_3M3, n_A_3M4, n_A_3M5, 
        n_A_3M6, n_A_3M7, n_A_3M8, n_A_3M9, n_A_3M10, n_A_3M11, n_A_3M12, 
        n_A_3M13, n_A_3M14, n_A_3M15, n_A_3M16, n_A_3M17, n_A_3M18, n_A_3M19, 
        n_A_3M20}), .EQO({n_A_1K1, n_A_1K2, n_A_1K3, n_A_1K4, n_A_1K5, n_A_1K6, 
        n_A_1K7, n_A_1K8, n_A_1K9, n_A_1K10, n_A_1K11, n_A_1K12, n_A_1K13, 
        n_A_1K14, n_A_1K15, n_A_1K16, n_A_1K17, n_A_1K18, n_A_1K19, n_A_1K20}), 
        .EOO({n_A_1M1, n_A_1M2, n_A_1M3, n_A_1M4, n_A_1M5, n_A_1M6, n_A_1M7, 
        n_A_1M8, n_A_1M9, n_A_1M10, n_A_1M11, n_A_1M12, n_A_1M13, n_A_1M14, 
        n_A_1M15, n_A_1M16, n_A_1M17, n_A_1M18, n_A_1M19, n_A_1M20}), .ERO({
        n_A_3D1, n_A_3D2, n_A_3D3, n_A_3D4, n_A_3D5, n_A_3D6, n_A_3D7, n_A_3D8, 
        n_A_3D9, n_A_3D10, n_A_3D11, n_A_3D12, n_A_3D13, n_A_3D14, n_A_3D15, 
        n_A_3D16, n_A_3D17, n_A_3D18, n_A_3D19, n_A_3D20}), .ESSD(ESSD), 
        .EXTI({n_A_3J1, n_A_3J2, n_A_3J3, n_A_3J4, n_A_3J5, n_A_3J6, n_A_3J7, 
        n_A_3J8, n_A_3J9, n_A_3J10, n_A_3J11, n_A_3J12, n_A_3J13, n_A_3J14, 
        n_A_3J15, n_A_3J16, n_A_3J17, n_A_3J18, n_A_3J19, n_A_3J20}), .EDBRS(
        EDBRS), .LFACD({n_A_2F1, n_A_2F2, n_A_2F3, n_A_2F4}), .EMSFEN(n_A_4G), 
        .LFACLS(n_A_04), .ESSDEN(n_A_1U), .EROEN(n_A_1V), .EXTIEN(n_A_1W), 
        .EOOEN(n_A_0W), .EQOEN(n_A_0V), .ETOEN(n_A_0U), .EIMOEN(n_A_1X), 
        .EPSOEN(n_A_1Y), .EDB({n_A_031, n_A_032, n_A_033, n_A_034, n_A_035, 
        n_A_036, n_A_037, n_A_038, n_A_039, n_A_0310, n_A_0311, n_A_0312, 
        n_A_0313, n_A_0314, n_A_0315, n_A_0316, n_A_0317, n_A_0318, n_A_0319, 
        n_A_0320}), .EDBR({n_A_1R1, n_A_1R2, n_A_1R3, n_A_1R4, n_A_1R5, 
        n_A_1R6, n_A_1R7, n_A_1R8, n_A_1R9, n_A_1R10, n_A_1R11, n_A_1R12, 
        n_A_1R13, n_A_1R14, n_A_1R15, n_A_1R16}) );
  BUFX2 A1U ( .A(ESYNC), .Y(n_A_4H) );
  BUFX4 A1S ( .A(XRST), .Y(n_A_0P) );
  EQACC A0C ( .EDB({n_A_031, n_A_032, n_A_033, n_A_034, n_A_035, n_A_036, 
        n_A_037, n_A_038, n_A_039, n_A_0310, n_A_0311, n_A_0312, n_A_0313, 
        n_A_0314, n_A_0315, n_A_0316, n_A_0317, n_A_0318, n_A_0319, n_A_0320}), 
        .EQACS0(n_A_08), .XRST(n_A_0P), .EQACLE(n_A_3X), .TE(n_A_4F), .TI(TI1), 
        .EQACCL(n_A_2C), .EQACCE(n_A_2D), .MCK(MCK), .EQO({n_A_1K1, n_A_1K2, 
        n_A_1K3, n_A_1K4, n_A_1K5, n_A_1K6, n_A_1K7, n_A_1K8, n_A_1K9, 
        n_A_1K10, n_A_1K11, n_A_1K12, n_A_1K13, n_A_1K14, n_A_1K15, n_A_1K16, 
        n_A_1K17, n_A_1K18, n_A_1K19, n_A_1K20}), .TO(TO1) );
  ETREG A09 ( .EDB({n_A_031, n_A_032, n_A_033, n_A_034, n_A_035, n_A_036, 
        n_A_037, n_A_038, n_A_039, n_A_0310, n_A_0311, n_A_0312, n_A_0313, 
        n_A_0314, n_A_0315, n_A_0316, n_A_0317, n_A_0318, n_A_0319, n_A_0320}), 
        .ET5EN(n_A_3U), .TE(n_A_4F), .XRST(n_A_0P), .ET4EN(n_A_0D), .ET3EN(
        n_A_0E), .ET2EN(n_A_0F), .ET1EN(n_A_0H), .ET0EN(n_A_2K), .ETLE(n_A_3C), 
        .MCK(MCK), .TI(n_A_27), .ETO({n_A_3M1, n_A_3M2, n_A_3M3, n_A_3M4, 
        n_A_3M5, n_A_3M6, n_A_3M7, n_A_3M8, n_A_3M9, n_A_3M10, n_A_3M11, 
        n_A_3M12, n_A_3M13, n_A_3M14, n_A_3M15, n_A_3M16, n_A_3M17, n_A_3M18, 
        n_A_3M19, n_A_3M20}), .TO(n_A_1T) );
endmodule


module ETREG ( EDB, ET5EN, TE, XRST, ET4EN, ET3EN, ET2EN, ET1EN, ET0EN, ETLE, 
        MCK, TI, ETO, TO );
  input [19:0] EDB;
  output [19:0] ETO;
  input ET5EN, TE, XRST, ET4EN, ET3EN, ET2EN, ET1EN, ET0EN, ETLE, MCK, TI;
  output TO;
  wire   n_E00, n_E01, n_E02, n_E03, n_E04, n_E05, n_E06, n_E07, n_E08, n_E09,
         n_E10, n_E11, n_E12, n_E13, n_E14, n_E15, n_E16, n_E17, n_E18, n_A_01,
         n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, n_A_0X7,
         n_A_0X8, n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, n_A_0X14,
         n_A_0X15, n_A_0X16, n_A_0X17, n_A_0X18, n_A_0X19, n_A_0X20, n_A_0W1,
         n_A_0W2, n_A_0W3, n_A_0W4, n_A_0W5, n_A_0W6, n_A_0W7, n_A_0W8,
         n_A_0W9, n_A_0W10, n_A_0W11, n_A_0W12, n_A_0W13, n_A_0W14, n_A_0W15,
         n_A_0W16, n_A_0W17, n_A_0W18, n_A_0W19, n_A_0W20, n_A_0V1, n_A_0V2,
         n_A_0V3, n_A_0V4, n_A_0V5, n_A_0V6, n_A_0V7, n_A_0V8, n_A_0V9,
         n_A_0V10, n_A_0V11, n_A_0V12, n_A_0V13, n_A_0V14, n_A_0V15, n_A_0V16,
         n_A_0V17, n_A_0V18, n_A_0V19, n_A_0V20, n_A_0U1, n_A_0U2, n_A_0U3,
         n_A_0U4, n_A_0U5, n_A_0U6, n_A_0U7, n_A_0U8, n_A_0U9, n_A_0U10,
         n_A_0U11, n_A_0U12, n_A_0U13, n_A_0U14, n_A_0U15, n_A_0U16, n_A_0U17,
         n_A_0U18, n_A_0U19, n_A_0U20, n_A_0T1, n_A_0T2, n_A_0T3, n_A_0T4,
         n_A_0T5, n_A_0T6, n_A_0T7, n_A_0T8, n_A_0T9, n_A_0T10, n_A_0T11,
         n_A_0T12, n_A_0T13, n_A_0T14, n_A_0T15, n_A_0T16, n_A_0T17, n_A_0T18,
         n_A_0T19, n_A_0T20, n_A_0A1, n_A_0A2, n_A_0A3, n_A_0A4, n_A_0A5,
         n_A_0A6, n_A_0A7, n_A_0A8, n_A_0A9, n_A_0A10, n_A_0A11, n_A_0A12,
         n_A_0A13, n_A_0A14, n_A_0A15, n_A_0A16, n_A_0A17, n_A_0A18, n_A_0A19,
         n_A_0A20, n_A_15, n_A_0N, n_A_0G, n_E19, n_A_0C, n_A_07, n_A_08,
         n_A_09, n_A_13, n_A_14, n_A_0P, n_A_0R, n_A_0L, n_A_0S;

  BUFX2 A100 ( .A(EDB[0]), .Y(n_E00) );
  BUFX2 A101 ( .A(EDB[1]), .Y(n_E01) );
  BUFX2 A102 ( .A(EDB[2]), .Y(n_E02) );
  BUFX2 A103 ( .A(EDB[3]), .Y(n_E03) );
  BUFX2 A104 ( .A(EDB[4]), .Y(n_E04) );
  BUFX2 A105 ( .A(EDB[5]), .Y(n_E05) );
  BUFX2 A106 ( .A(EDB[6]), .Y(n_E06) );
  BUFX2 A107 ( .A(EDB[7]), .Y(n_E07) );
  BUFX2 A108 ( .A(EDB[8]), .Y(n_E08) );
  BUFX2 A109 ( .A(EDB[9]), .Y(n_E09) );
  BUFX2 A110 ( .A(EDB[10]), .Y(n_E10) );
  BUFX2 A111 ( .A(EDB[11]), .Y(n_E11) );
  BUFX2 A112 ( .A(EDB[12]), .Y(n_E12) );
  BUFX2 A113 ( .A(EDB[13]), .Y(n_E13) );
  BUFX2 A114 ( .A(EDB[14]), .Y(n_E14) );
  BUFX2 A115 ( .A(EDB[15]), .Y(n_E15) );
  BUFX2 A116 ( .A(EDB[16]), .Y(n_E16) );
  BUFX2 A117 ( .A(EDB[17]), .Y(n_E17) );
  BUFX2 A118 ( .A(EDB[18]), .Y(n_E18) );
  BUFX2 A0W ( .A(TE), .Y(n_A_01) );
  DS206 A11 ( .A({n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, 
        n_A_0X7, n_A_0X8, n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, 
        n_A_0X14, n_A_0X15, n_A_0X16, n_A_0X17, n_A_0X18, n_A_0X19, n_A_0X20}), 
        .B({n_A_0W1, n_A_0W2, n_A_0W3, n_A_0W4, n_A_0W5, n_A_0W6, n_A_0W7, 
        n_A_0W8, n_A_0W9, n_A_0W10, n_A_0W11, n_A_0W12, n_A_0W13, n_A_0W14, 
        n_A_0W15, n_A_0W16, n_A_0W17, n_A_0W18, n_A_0W19, n_A_0W20}), .C({
        n_A_0V1, n_A_0V2, n_A_0V3, n_A_0V4, n_A_0V5, n_A_0V6, n_A_0V7, n_A_0V8, 
        n_A_0V9, n_A_0V10, n_A_0V11, n_A_0V12, n_A_0V13, n_A_0V14, n_A_0V15, 
        n_A_0V16, n_A_0V17, n_A_0V18, n_A_0V19, n_A_0V20}), .D({n_A_0U1, 
        n_A_0U2, n_A_0U3, n_A_0U4, n_A_0U5, n_A_0U6, n_A_0U7, n_A_0U8, n_A_0U9, 
        n_A_0U10, n_A_0U11, n_A_0U12, n_A_0U13, n_A_0U14, n_A_0U15, n_A_0U16, 
        n_A_0U17, n_A_0U18, n_A_0U19, n_A_0U20}), .E({n_A_0T1, n_A_0T2, 
        n_A_0T3, n_A_0T4, n_A_0T5, n_A_0T6, n_A_0T7, n_A_0T8, n_A_0T9, 
        n_A_0T10, n_A_0T11, n_A_0T12, n_A_0T13, n_A_0T14, n_A_0T15, n_A_0T16, 
        n_A_0T17, n_A_0T18, n_A_0T19, n_A_0T20}), .F({n_A_0A1, n_A_0A2, 
        n_A_0A3, n_A_0A4, n_A_0A5, n_A_0A6, n_A_0A7, n_A_0A8, n_A_0A9, 
        n_A_0A10, n_A_0A11, n_A_0A12, n_A_0A13, n_A_0A14, n_A_0A15, n_A_0A16, 
        n_A_0A17, n_A_0A18, n_A_0A19, n_A_0A20}), .FE(ET5EN), .EE(ET4EN), .DE(
        ET3EN), .CE(ET2EN), .BE(ET1EN), .AE(ET0EN), .Y(ETO) );
  FE20R A10 ( .D({n_E19, n_E18, n_E17, n_E16, n_E15, n_E14, n_E13, n_E12, 
        n_E11, n_E10, n_E09, n_E08, n_E07, n_E06, n_E05, n_E04, n_E03, n_E02, 
        n_E01, n_E00}), .TI(n_A_0G), .RN(n_A_15), .TE(n_A_01), .CK(MCK), .EN(
        n_A_0N), .Q({n_A_0A1, n_A_0A2, n_A_0A3, n_A_0A4, n_A_0A5, n_A_0A6, 
        n_A_0A7, n_A_0A8, n_A_0A9, n_A_0A10, n_A_0A11, n_A_0A12, n_A_0A13, 
        n_A_0A14, n_A_0A15, n_A_0A16, n_A_0A17, n_A_0A18, n_A_0A19, n_A_0A20}), 
        .TO(TO) );
  AND2X1 A07 ( .A(n_A_0C), .B(ET5EN), .Y(n_A_0N) );
  BUFX2 A0E ( .A(ETLE), .Y(n_A_0C) );
  AND2X1 A0D ( .A(n_A_0C), .B(ET4EN), .Y(n_A_07) );
  AND2X1 A0C ( .A(n_A_0C), .B(ET3EN), .Y(n_A_08) );
  AND2X1 A0B ( .A(n_A_0C), .B(ET2EN), .Y(n_A_09) );
  AND2X1 A0A ( .A(n_A_0C), .B(ET1EN), .Y(n_A_13) );
  AND2X1 A09 ( .A(n_A_0C), .B(ET0EN), .Y(n_A_14) );
  BUFX2 A119 ( .A(EDB[19]), .Y(n_E19) );
  BUFX2 A08 ( .A(XRST), .Y(n_A_15) );
  FE20R A05 ( .D({n_E19, n_E18, n_E17, n_E16, n_E15, n_E14, n_E13, n_E12, 
        n_E11, n_E10, n_E09, n_E08, n_E07, n_E06, n_E05, n_E04, n_E03, n_E02, 
        n_E01, n_E00}), .TI(n_A_0P), .RN(n_A_15), .TE(n_A_01), .CK(MCK), .EN(
        n_A_07), .Q({n_A_0T1, n_A_0T2, n_A_0T3, n_A_0T4, n_A_0T5, n_A_0T6, 
        n_A_0T7, n_A_0T8, n_A_0T9, n_A_0T10, n_A_0T11, n_A_0T12, n_A_0T13, 
        n_A_0T14, n_A_0T15, n_A_0T16, n_A_0T17, n_A_0T18, n_A_0T19, n_A_0T20}), 
        .TO(n_A_0G) );
  FE20R A04 ( .D({n_E19, n_E18, n_E17, n_E16, n_E15, n_E14, n_E13, n_E12, 
        n_E11, n_E10, n_E09, n_E08, n_E07, n_E06, n_E05, n_E04, n_E03, n_E02, 
        n_E01, n_E00}), .TI(n_A_0R), .RN(n_A_15), .TE(n_A_01), .CK(MCK), .EN(
        n_A_08), .Q({n_A_0U1, n_A_0U2, n_A_0U3, n_A_0U4, n_A_0U5, n_A_0U6, 
        n_A_0U7, n_A_0U8, n_A_0U9, n_A_0U10, n_A_0U11, n_A_0U12, n_A_0U13, 
        n_A_0U14, n_A_0U15, n_A_0U16, n_A_0U17, n_A_0U18, n_A_0U19, n_A_0U20}), 
        .TO(n_A_0P) );
  FE20R A03 ( .D({n_E19, n_E18, n_E17, n_E16, n_E15, n_E14, n_E13, n_E12, 
        n_E11, n_E10, n_E09, n_E08, n_E07, n_E06, n_E05, n_E04, n_E03, n_E02, 
        n_E01, n_E00}), .TI(n_A_0L), .RN(n_A_15), .TE(n_A_01), .CK(MCK), .EN(
        n_A_09), .Q({n_A_0V1, n_A_0V2, n_A_0V3, n_A_0V4, n_A_0V5, n_A_0V6, 
        n_A_0V7, n_A_0V8, n_A_0V9, n_A_0V10, n_A_0V11, n_A_0V12, n_A_0V13, 
        n_A_0V14, n_A_0V15, n_A_0V16, n_A_0V17, n_A_0V18, n_A_0V19, n_A_0V20}), 
        .TO(n_A_0R) );
  FE20R A02 ( .D({n_E19, n_E18, n_E17, n_E16, n_E15, n_E14, n_E13, n_E12, 
        n_E11, n_E10, n_E09, n_E08, n_E07, n_E06, n_E05, n_E04, n_E03, n_E02, 
        n_E01, n_E00}), .TI(n_A_0S), .RN(n_A_15), .TE(n_A_01), .CK(MCK), .EN(
        n_A_13), .Q({n_A_0W1, n_A_0W2, n_A_0W3, n_A_0W4, n_A_0W5, n_A_0W6, 
        n_A_0W7, n_A_0W8, n_A_0W9, n_A_0W10, n_A_0W11, n_A_0W12, n_A_0W13, 
        n_A_0W14, n_A_0W15, n_A_0W16, n_A_0W17, n_A_0W18, n_A_0W19, n_A_0W20}), 
        .TO(n_A_0L) );
  FE20R A01 ( .D({n_E19, n_E18, n_E17, n_E16, n_E15, n_E14, n_E13, n_E12, 
        n_E11, n_E10, n_E09, n_E08, n_E07, n_E06, n_E05, n_E04, n_E03, n_E02, 
        n_E01, n_E00}), .TI(TI), .RN(n_A_15), .TE(n_A_01), .CK(MCK), .EN(
        n_A_14), .Q({n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, 
        n_A_0X7, n_A_0X8, n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, 
        n_A_0X14, n_A_0X15, n_A_0X16, n_A_0X17, n_A_0X18, n_A_0X19, n_A_0X20}), 
        .TO(n_A_0S) );
endmodule


module DS206 ( A, B, C, D, E, F, FE, EE, DE, CE, BE, AE, Y );
  input [19:0] A;
  input [19:0] B;
  input [19:0] C;
  input [19:0] D;
  input [19:0] E;
  input [19:0] F;
  output [19:0] Y;
  input FE, EE, DE, CE, BE, AE;
  wire   n_A_0S, n_A_0220, n_A_0219, n_A_0218, n_A_0217, n_A_0216, n_A_0215,
         n_A_0214, n_A_0213, n_A_0212, n_A_0211, n_A_0210, n_A_029, n_A_028,
         n_A_027, n_A_026, n_A_025, n_A_024, n_A_023, n_A_022, n_A_0M,
         n_A_0320, n_A_0319, n_A_0318, n_A_0317, n_A_0316, n_A_0315, n_A_0314,
         n_A_0313, n_A_0312, n_A_0311, n_A_0310, n_A_039, n_A_038, n_A_037,
         n_A_036, n_A_035, n_A_034, n_A_033, n_A_032, n_A_0K, n_A_0420,
         n_A_0419, n_A_0418, n_A_0417, n_A_0416, n_A_0415, n_A_0414, n_A_0413,
         n_A_0412, n_A_0411, n_A_0410, n_A_049, n_A_048, n_A_047, n_A_046,
         n_A_045, n_A_044, n_A_043, n_A_042, n_A_0F, n_A_0520, n_A_0519,
         n_A_0518, n_A_0517, n_A_0516, n_A_0515, n_A_0514, n_A_0513, n_A_0512,
         n_A_0511, n_A_0510, n_A_059, n_A_058, n_A_057, n_A_056, n_A_055,
         n_A_054, n_A_053, n_A_052, n_A_0D, n_A_0620, n_A_0619, n_A_0618,
         n_A_0617, n_A_0616, n_A_0615, n_A_0614, n_A_0613, n_A_0612, n_A_0611,
         n_A_0610, n_A_069, n_A_068, n_A_067, n_A_066, n_A_065, n_A_064,
         n_A_063, n_A_062, n_A_09, n_A_0720, n_A_0719, n_A_0718, n_A_0717,
         n_A_0716, n_A_0715, n_A_0714, n_A_0713, n_A_0712, n_A_0711, n_A_0710,
         n_A_079, n_A_078, n_A_077, n_A_076, n_A_075, n_A_074, n_A_073,
         n_A_072, n_A_041, n_A_031, n_A_021, n_A_051, n_A_061, n_A_071;

  NAND2X1 A100 ( .A(A[0]), .B(n_A_0S), .Y(n_A_0220) );
  NAND2X1 A101 ( .A(A[1]), .B(n_A_0S), .Y(n_A_0219) );
  NAND2X1 A102 ( .A(A[2]), .B(n_A_0S), .Y(n_A_0218) );
  NAND2X1 A103 ( .A(A[3]), .B(n_A_0S), .Y(n_A_0217) );
  NAND2X1 A104 ( .A(A[4]), .B(n_A_0S), .Y(n_A_0216) );
  NAND2X1 A105 ( .A(A[5]), .B(n_A_0S), .Y(n_A_0215) );
  NAND2X1 A106 ( .A(A[6]), .B(n_A_0S), .Y(n_A_0214) );
  NAND2X1 A107 ( .A(A[7]), .B(n_A_0S), .Y(n_A_0213) );
  NAND2X1 A108 ( .A(A[8]), .B(n_A_0S), .Y(n_A_0212) );
  NAND2X1 A109 ( .A(A[9]), .B(n_A_0S), .Y(n_A_0211) );
  NAND2X1 A110 ( .A(A[10]), .B(n_A_0S), .Y(n_A_0210) );
  NAND2X1 A111 ( .A(A[11]), .B(n_A_0S), .Y(n_A_029) );
  NAND2X1 A112 ( .A(A[12]), .B(n_A_0S), .Y(n_A_028) );
  NAND2X1 A113 ( .A(A[13]), .B(n_A_0S), .Y(n_A_027) );
  NAND2X1 A114 ( .A(A[14]), .B(n_A_0S), .Y(n_A_026) );
  NAND2X1 A115 ( .A(A[15]), .B(n_A_0S), .Y(n_A_025) );
  NAND2X1 A116 ( .A(A[16]), .B(n_A_0S), .Y(n_A_024) );
  NAND2X1 A117 ( .A(A[17]), .B(n_A_0S), .Y(n_A_023) );
  NAND2X1 A118 ( .A(A[18]), .B(n_A_0S), .Y(n_A_022) );
  NAND2X1 A200 ( .A(B[0]), .B(n_A_0M), .Y(n_A_0320) );
  NAND2X1 A201 ( .A(B[1]), .B(n_A_0M), .Y(n_A_0319) );
  NAND2X1 A202 ( .A(B[2]), .B(n_A_0M), .Y(n_A_0318) );
  NAND2X1 A203 ( .A(B[3]), .B(n_A_0M), .Y(n_A_0317) );
  NAND2X1 A204 ( .A(B[4]), .B(n_A_0M), .Y(n_A_0316) );
  NAND2X1 A205 ( .A(B[5]), .B(n_A_0M), .Y(n_A_0315) );
  NAND2X1 A206 ( .A(B[6]), .B(n_A_0M), .Y(n_A_0314) );
  NAND2X1 A207 ( .A(B[7]), .B(n_A_0M), .Y(n_A_0313) );
  NAND2X1 A208 ( .A(B[8]), .B(n_A_0M), .Y(n_A_0312) );
  NAND2X1 A209 ( .A(B[9]), .B(n_A_0M), .Y(n_A_0311) );
  NAND2X1 A210 ( .A(B[10]), .B(n_A_0M), .Y(n_A_0310) );
  NAND2X1 A211 ( .A(B[11]), .B(n_A_0M), .Y(n_A_039) );
  NAND2X1 A212 ( .A(B[12]), .B(n_A_0M), .Y(n_A_038) );
  NAND2X1 A213 ( .A(B[13]), .B(n_A_0M), .Y(n_A_037) );
  NAND2X1 A214 ( .A(B[14]), .B(n_A_0M), .Y(n_A_036) );
  NAND2X1 A215 ( .A(B[15]), .B(n_A_0M), .Y(n_A_035) );
  NAND2X1 A216 ( .A(B[16]), .B(n_A_0M), .Y(n_A_034) );
  NAND2X1 A217 ( .A(B[17]), .B(n_A_0M), .Y(n_A_033) );
  NAND2X1 A218 ( .A(B[18]), .B(n_A_0M), .Y(n_A_032) );
  NAND2X1 A300 ( .A(C[0]), .B(n_A_0K), .Y(n_A_0420) );
  NAND2X1 A301 ( .A(C[1]), .B(n_A_0K), .Y(n_A_0419) );
  NAND2X1 A302 ( .A(C[2]), .B(n_A_0K), .Y(n_A_0418) );
  NAND2X1 A303 ( .A(C[3]), .B(n_A_0K), .Y(n_A_0417) );
  NAND2X1 A304 ( .A(C[4]), .B(n_A_0K), .Y(n_A_0416) );
  NAND2X1 A305 ( .A(C[5]), .B(n_A_0K), .Y(n_A_0415) );
  NAND2X1 A306 ( .A(C[6]), .B(n_A_0K), .Y(n_A_0414) );
  NAND2X1 A307 ( .A(C[7]), .B(n_A_0K), .Y(n_A_0413) );
  NAND2X1 A308 ( .A(C[8]), .B(n_A_0K), .Y(n_A_0412) );
  NAND2X1 A309 ( .A(C[9]), .B(n_A_0K), .Y(n_A_0411) );
  NAND2X1 A310 ( .A(C[10]), .B(n_A_0K), .Y(n_A_0410) );
  NAND2X1 A311 ( .A(C[11]), .B(n_A_0K), .Y(n_A_049) );
  NAND2X1 A312 ( .A(C[12]), .B(n_A_0K), .Y(n_A_048) );
  NAND2X1 A313 ( .A(C[13]), .B(n_A_0K), .Y(n_A_047) );
  NAND2X1 A314 ( .A(C[14]), .B(n_A_0K), .Y(n_A_046) );
  NAND2X1 A315 ( .A(C[15]), .B(n_A_0K), .Y(n_A_045) );
  NAND2X1 A316 ( .A(C[16]), .B(n_A_0K), .Y(n_A_044) );
  NAND2X1 A317 ( .A(C[17]), .B(n_A_0K), .Y(n_A_043) );
  NAND2X1 A318 ( .A(C[18]), .B(n_A_0K), .Y(n_A_042) );
  NAND2X1 A400 ( .A(D[0]), .B(n_A_0F), .Y(n_A_0520) );
  NAND2X1 A401 ( .A(D[1]), .B(n_A_0F), .Y(n_A_0519) );
  NAND2X1 A402 ( .A(D[2]), .B(n_A_0F), .Y(n_A_0518) );
  NAND2X1 A403 ( .A(D[3]), .B(n_A_0F), .Y(n_A_0517) );
  NAND2X1 A404 ( .A(D[4]), .B(n_A_0F), .Y(n_A_0516) );
  NAND2X1 A405 ( .A(D[5]), .B(n_A_0F), .Y(n_A_0515) );
  NAND2X1 A406 ( .A(D[6]), .B(n_A_0F), .Y(n_A_0514) );
  NAND2X1 A407 ( .A(D[7]), .B(n_A_0F), .Y(n_A_0513) );
  NAND2X1 A408 ( .A(D[8]), .B(n_A_0F), .Y(n_A_0512) );
  NAND2X1 A409 ( .A(D[9]), .B(n_A_0F), .Y(n_A_0511) );
  NAND2X1 A410 ( .A(D[10]), .B(n_A_0F), .Y(n_A_0510) );
  NAND2X1 A411 ( .A(D[11]), .B(n_A_0F), .Y(n_A_059) );
  NAND2X1 A412 ( .A(D[12]), .B(n_A_0F), .Y(n_A_058) );
  NAND2X1 A413 ( .A(D[13]), .B(n_A_0F), .Y(n_A_057) );
  NAND2X1 A414 ( .A(D[14]), .B(n_A_0F), .Y(n_A_056) );
  NAND2X1 A415 ( .A(D[15]), .B(n_A_0F), .Y(n_A_055) );
  NAND2X1 A416 ( .A(D[16]), .B(n_A_0F), .Y(n_A_054) );
  NAND2X1 A417 ( .A(D[17]), .B(n_A_0F), .Y(n_A_053) );
  NAND2X1 A418 ( .A(D[18]), .B(n_A_0F), .Y(n_A_052) );
  NAND2X1 A500 ( .A(E[0]), .B(n_A_0D), .Y(n_A_0620) );
  NAND2X1 A501 ( .A(E[1]), .B(n_A_0D), .Y(n_A_0619) );
  NAND2X1 A502 ( .A(E[2]), .B(n_A_0D), .Y(n_A_0618) );
  NAND2X1 A503 ( .A(E[3]), .B(n_A_0D), .Y(n_A_0617) );
  NAND2X1 A504 ( .A(E[4]), .B(n_A_0D), .Y(n_A_0616) );
  NAND2X1 A505 ( .A(E[5]), .B(n_A_0D), .Y(n_A_0615) );
  NAND2X1 A506 ( .A(E[6]), .B(n_A_0D), .Y(n_A_0614) );
  NAND2X1 A507 ( .A(E[7]), .B(n_A_0D), .Y(n_A_0613) );
  NAND2X1 A508 ( .A(E[8]), .B(n_A_0D), .Y(n_A_0612) );
  NAND2X1 A509 ( .A(E[9]), .B(n_A_0D), .Y(n_A_0611) );
  NAND2X1 A510 ( .A(E[10]), .B(n_A_0D), .Y(n_A_0610) );
  NAND2X1 A511 ( .A(E[11]), .B(n_A_0D), .Y(n_A_069) );
  NAND2X1 A512 ( .A(E[12]), .B(n_A_0D), .Y(n_A_068) );
  NAND2X1 A513 ( .A(E[13]), .B(n_A_0D), .Y(n_A_067) );
  NAND2X1 A514 ( .A(E[14]), .B(n_A_0D), .Y(n_A_066) );
  NAND2X1 A515 ( .A(E[15]), .B(n_A_0D), .Y(n_A_065) );
  NAND2X1 A516 ( .A(E[16]), .B(n_A_0D), .Y(n_A_064) );
  NAND2X1 A517 ( .A(E[17]), .B(n_A_0D), .Y(n_A_063) );
  NAND2X1 A518 ( .A(E[18]), .B(n_A_0D), .Y(n_A_062) );
  NAND2X1 A600 ( .A(F[0]), .B(n_A_09), .Y(n_A_0720) );
  NAND2X1 A601 ( .A(F[1]), .B(n_A_09), .Y(n_A_0719) );
  NAND2X1 A602 ( .A(F[2]), .B(n_A_09), .Y(n_A_0718) );
  NAND2X1 A603 ( .A(F[3]), .B(n_A_09), .Y(n_A_0717) );
  NAND2X1 A604 ( .A(F[4]), .B(n_A_09), .Y(n_A_0716) );
  NAND2X1 A605 ( .A(F[5]), .B(n_A_09), .Y(n_A_0715) );
  NAND2X1 A606 ( .A(F[6]), .B(n_A_09), .Y(n_A_0714) );
  NAND2X1 A607 ( .A(F[7]), .B(n_A_09), .Y(n_A_0713) );
  NAND2X1 A608 ( .A(F[8]), .B(n_A_09), .Y(n_A_0712) );
  NAND2X1 A609 ( .A(F[9]), .B(n_A_09), .Y(n_A_0711) );
  NAND2X1 A610 ( .A(F[10]), .B(n_A_09), .Y(n_A_0710) );
  NAND2X1 A611 ( .A(F[11]), .B(n_A_09), .Y(n_A_079) );
  NAND2X1 A612 ( .A(F[12]), .B(n_A_09), .Y(n_A_078) );
  NAND2X1 A613 ( .A(F[13]), .B(n_A_09), .Y(n_A_077) );
  NAND2X1 A614 ( .A(F[14]), .B(n_A_09), .Y(n_A_076) );
  NAND2X1 A615 ( .A(F[15]), .B(n_A_09), .Y(n_A_075) );
  NAND2X1 A616 ( .A(F[16]), .B(n_A_09), .Y(n_A_074) );
  NAND2X1 A617 ( .A(F[17]), .B(n_A_09), .Y(n_A_073) );
  NAND2X1 A618 ( .A(F[18]), .B(n_A_09), .Y(n_A_072) );
  ND6D2 A700 ( .F(n_A_0720), .E(n_A_0620), .D(n_A_0520), .C(n_A_0420), .B(
        n_A_0320), .A(n_A_0220), .Y(Y[0]) );
  ND6D2 A701 ( .F(n_A_0719), .E(n_A_0619), .D(n_A_0519), .C(n_A_0419), .B(
        n_A_0319), .A(n_A_0219), .Y(Y[1]) );
  ND6D2 A702 ( .F(n_A_0718), .E(n_A_0618), .D(n_A_0518), .C(n_A_0418), .B(
        n_A_0318), .A(n_A_0218), .Y(Y[2]) );
  ND6D2 A703 ( .F(n_A_0717), .E(n_A_0617), .D(n_A_0517), .C(n_A_0417), .B(
        n_A_0317), .A(n_A_0217), .Y(Y[3]) );
  ND6D2 A704 ( .F(n_A_0716), .E(n_A_0616), .D(n_A_0516), .C(n_A_0416), .B(
        n_A_0316), .A(n_A_0216), .Y(Y[4]) );
  ND6D2 A705 ( .F(n_A_0715), .E(n_A_0615), .D(n_A_0515), .C(n_A_0415), .B(
        n_A_0315), .A(n_A_0215), .Y(Y[5]) );
  ND6D2 A706 ( .F(n_A_0714), .E(n_A_0614), .D(n_A_0514), .C(n_A_0414), .B(
        n_A_0314), .A(n_A_0214), .Y(Y[6]) );
  ND6D2 A707 ( .F(n_A_0713), .E(n_A_0613), .D(n_A_0513), .C(n_A_0413), .B(
        n_A_0313), .A(n_A_0213), .Y(Y[7]) );
  ND6D2 A708 ( .F(n_A_0712), .E(n_A_0612), .D(n_A_0512), .C(n_A_0412), .B(
        n_A_0312), .A(n_A_0212), .Y(Y[8]) );
  ND6D2 A709 ( .F(n_A_0711), .E(n_A_0611), .D(n_A_0511), .C(n_A_0411), .B(
        n_A_0311), .A(n_A_0211), .Y(Y[9]) );
  ND6D2 A710 ( .F(n_A_0710), .E(n_A_0610), .D(n_A_0510), .C(n_A_0410), .B(
        n_A_0310), .A(n_A_0210), .Y(Y[10]) );
  ND6D2 A711 ( .F(n_A_079), .E(n_A_069), .D(n_A_059), .C(n_A_049), .B(n_A_039), 
        .A(n_A_029), .Y(Y[11]) );
  ND6D2 A712 ( .F(n_A_078), .E(n_A_068), .D(n_A_058), .C(n_A_048), .B(n_A_038), 
        .A(n_A_028), .Y(Y[12]) );
  ND6D2 A713 ( .F(n_A_077), .E(n_A_067), .D(n_A_057), .C(n_A_047), .B(n_A_037), 
        .A(n_A_027), .Y(Y[13]) );
  ND6D2 A714 ( .F(n_A_076), .E(n_A_066), .D(n_A_056), .C(n_A_046), .B(n_A_036), 
        .A(n_A_026), .Y(Y[14]) );
  ND6D2 A715 ( .F(n_A_075), .E(n_A_065), .D(n_A_055), .C(n_A_045), .B(n_A_035), 
        .A(n_A_025), .Y(Y[15]) );
  ND6D2 A716 ( .F(n_A_074), .E(n_A_064), .D(n_A_054), .C(n_A_044), .B(n_A_034), 
        .A(n_A_024), .Y(Y[16]) );
  ND6D2 A717 ( .F(n_A_073), .E(n_A_063), .D(n_A_053), .C(n_A_043), .B(n_A_033), 
        .A(n_A_023), .Y(Y[17]) );
  ND6D2 A718 ( .F(n_A_072), .E(n_A_062), .D(n_A_052), .C(n_A_042), .B(n_A_032), 
        .A(n_A_022), .Y(Y[18]) );
  ND6D2 A719 ( .F(n_A_071), .E(n_A_061), .D(n_A_051), .C(n_A_041), .B(n_A_031), 
        .A(n_A_021), .Y(Y[19]) );
  BUFX4 A0K ( .A(FE), .Y(n_A_09) );
  BUFX4 A0J ( .A(EE), .Y(n_A_0D) );
  BUFX4 A0H ( .A(DE), .Y(n_A_0F) );
  BUFX4 A0G ( .A(CE), .Y(n_A_0K) );
  BUFX4 A0F ( .A(BE), .Y(n_A_0M) );
  BUFX4 A0E ( .A(AE), .Y(n_A_0S) );
  NAND2X1 A619 ( .A(F[19]), .B(n_A_09), .Y(n_A_071) );
  NAND2X1 A519 ( .A(E[19]), .B(n_A_0D), .Y(n_A_061) );
  NAND2X1 A419 ( .A(D[19]), .B(n_A_0F), .Y(n_A_051) );
  NAND2X1 A319 ( .A(C[19]), .B(n_A_0K), .Y(n_A_041) );
  NAND2X1 A219 ( .A(B[19]), .B(n_A_0M), .Y(n_A_031) );
  NAND2X1 A119 ( .A(A[19]), .B(n_A_0S), .Y(n_A_021) );
endmodule


module EQACC ( EDB, EQACS0, XRST, EQACLE, TE, TI, EQACCL, EQACCE, MCK, EQO, TO
 );
  input [19:0] EDB;
  output [19:0] EQO;
  input EQACS0, XRST, EQACLE, TE, TI, EQACCL, EQACCE, MCK;
  output TO;
  wire   n_A_0K, n_A_0V, n_A_09, n_A_0J, n_A_0N1, n_A_0N2, n_A_0N3, n_A_0N4,
         n_A_0N5, n_A_0N6, n_A_0N7, n_A_0N8, n_A_0N9, n_A_0N10, n_A_0N11,
         n_A_0N12, n_A_0N13, n_A_0N14, n_A_0N15, n_A_0N16, n_A_0N17, n_A_0N18,
         n_A_0N19, n_A_0N20, n_SQ3, n_SQ2, n_SQ1, n_SQ0, n_A_0L, n_A_0W,
         n_A_0R1, n_A_0R2, n_A_0R3, n_A_0R4, n_A_0R5, n_A_0R6, n_A_0R7,
         n_A_0R8, n_A_0R9, n_A_0R10, n_A_0R11, n_A_0R12, n_A_0R13, n_A_0R14,
         n_A_0R15, n_A_0R16, n_A_0R17, n_A_0R18, n_A_0R19, n_A_0R20, n_A_0M,
         n_A_08, n_A_0P1, n_A_0P2, n_A_0P3, n_A_0P4, n_A_0P5, n_A_0P6, n_A_0P7,
         n_A_0P8, n_A_0P9, n_A_0P10, n_A_0P11, n_A_0P12, n_A_0P13, n_A_0P14,
         n_A_0P15, n_A_0P16, n_A_0P17, n_A_0P18, n_A_0P19, n_A_0P20, n_A_06;

  RG2016 A03 ( .D(EDB), .S({n_SQ3, n_SQ2, n_SQ1, n_SQ0}), .RN(n_A_0J), .EN(
        n_A_0K), .TE(n_A_09), .TI(n_A_0V), .MCK(MCK), .Y({n_A_0N1, n_A_0N2, 
        n_A_0N3, n_A_0N4, n_A_0N5, n_A_0N6, n_A_0N7, n_A_0N8, n_A_0N9, 
        n_A_0N10, n_A_0N11, n_A_0N12, n_A_0N13, n_A_0N14, n_A_0N15, n_A_0N16, 
        n_A_0N17, n_A_0N18, n_A_0N19, n_A_0N20}), .TO(TO) );
  RG2016 A02 ( .D(EDB), .S({n_SQ3, n_SQ2, n_SQ1, n_SQ0}), .RN(n_A_0J), .EN(
        n_A_0L), .TE(n_A_09), .TI(n_A_0W), .MCK(MCK), .Y({n_A_0R1, n_A_0R2, 
        n_A_0R3, n_A_0R4, n_A_0R5, n_A_0R6, n_A_0R7, n_A_0R8, n_A_0R9, 
        n_A_0R10, n_A_0R11, n_A_0R12, n_A_0R13, n_A_0R14, n_A_0R15, n_A_0R16, 
        n_A_0R17, n_A_0R18, n_A_0R19, n_A_0R20}), .TO(n_A_0V) );
  RG2016 A01 ( .D(EDB), .S({n_SQ3, n_SQ2, n_SQ1, n_SQ0}), .RN(n_A_0J), .EN(
        n_A_0M), .TE(n_A_09), .TI(n_A_08), .MCK(MCK), .Y({n_A_0P1, n_A_0P2, 
        n_A_0P3, n_A_0P4, n_A_0P5, n_A_0P6, n_A_0P7, n_A_0P8, n_A_0P9, 
        n_A_0P10, n_A_0P11, n_A_0P12, n_A_0P13, n_A_0P14, n_A_0P15, n_A_0P16, 
        n_A_0P17, n_A_0P18, n_A_0P19, n_A_0P20}), .TO(n_A_0W) );
  BUFX2 A0H ( .A(EQACS0), .Y(n_SQ0) );
  CO05 A0A ( .RN(n_A_0J), .TE(n_A_09), .CK(MCK), .SCL(EQACCL), .TI(TI), .EN(
        EQACCE), .Q4(n_A_08), .Q3(n_A_06), .Q2(n_SQ3), .Q1(n_SQ2), .Q0(n_SQ1)
         );
  BUFX2 A07 ( .A(XRST), .Y(n_A_0J) );
  BUFX2 A08 ( .A(TE), .Y(n_A_09) );
  DS203 A09 ( .B({n_A_0R1, n_A_0R2, n_A_0R3, n_A_0R4, n_A_0R5, n_A_0R6, 
        n_A_0R7, n_A_0R8, n_A_0R9, n_A_0R10, n_A_0R11, n_A_0R12, n_A_0R13, 
        n_A_0R14, n_A_0R15, n_A_0R16, n_A_0R17, n_A_0R18, n_A_0R19, n_A_0R20}), 
        .A({n_A_0P1, n_A_0P2, n_A_0P3, n_A_0P4, n_A_0P5, n_A_0P6, n_A_0P7, 
        n_A_0P8, n_A_0P9, n_A_0P10, n_A_0P11, n_A_0P12, n_A_0P13, n_A_0P14, 
        n_A_0P15, n_A_0P16, n_A_0P17, n_A_0P18, n_A_0P19, n_A_0P20}), .C({
        n_A_0N1, n_A_0N2, n_A_0N3, n_A_0N4, n_A_0N5, n_A_0N6, n_A_0N7, n_A_0N8, 
        n_A_0N9, n_A_0N10, n_A_0N11, n_A_0N12, n_A_0N13, n_A_0N14, n_A_0N15, 
        n_A_0N16, n_A_0N17, n_A_0N18, n_A_0N19, n_A_0N20}), .S2(n_A_08), .S1(
        n_A_06), .Y(EQO) );
  DC04P A0B ( .EN(EQACLE), .B(n_A_08), .A(n_A_06), .Y2(n_A_0K), .Y1(n_A_0L), 
        .Y0(n_A_0M) );
endmodule


module RG2016 ( D, S, RN, EN, TE, TI, MCK, Y, TO );
  input [19:0] D;
  input [3:0] S;
  output [19:0] Y;
  input RN, EN, TE, TI, MCK;
  output TO;
  wire   n_A_12, n_A_0L, n_A_0M, n_A_0G, n_A_1N, n_A_1B, n_A_1S1, n_A_1S2,
         n_A_1S3, n_A_1S4, n_A_0K, n_A_0N, n_A_0W, n_A_16, n_A_1V1, n_A_1V2,
         n_A_1V3, n_A_1V4, n_A_14, n_A_201, n_A_202, n_A_203, n_A_204, n_A_15,
         n_A_1M, n_A_241, n_A_242, n_A_243, n_A_244, n_A_0R, n_A_1P, n_A_2B1,
         n_A_2B2, n_A_2B3, n_A_2B4, n_A_18, n_A_2D, n_A_2C1, n_A_2C2, n_A_2C3,
         n_A_2C4, n_A_13, n_A_1C, n_A_1U1, n_A_1U2, n_A_1U3, n_A_1U4, n_A_1H,
         n_A_1Y1, n_A_1Y2, n_A_1Y3, n_A_1Y4, n_A_0S, n_A_231, n_A_232, n_A_233,
         n_A_234, n_A_1G, n_A_2A1, n_A_2A2, n_A_2A3, n_A_2A4, n_A_1K, n_A_271,
         n_A_272, n_A_273, n_A_274, n_A_0D, n_A_1T1, n_A_1T2, n_A_1T3, n_A_1T4,
         n_A_17, n_A_1X1, n_A_1X2, n_A_1X3, n_A_1X4, n_A_1A, n_A_221, n_A_222,
         n_A_223, n_A_224, n_A_1D, n_A_291, n_A_292, n_A_293, n_A_294, n_A_1L,
         n_A_261, n_A_262, n_A_263, n_A_264, n_A_1W1, n_A_1W2, n_A_1W3,
         n_A_1W4, n_A_211, n_A_212, n_A_213, n_A_214, n_A_1R1, n_A_1R2,
         n_A_1R3, n_A_1R4, n_A_251, n_A_252, n_A_253, n_A_254;

  RG44 A05 ( .D(D[19:16]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_12), .TE(TE), 
        .RN(n_A_0G), .TI(n_A_1N), .CK(MCK), .Y({n_A_1S1, n_A_1S2, n_A_1S3, 
        n_A_1S4}), .TO(n_A_1B) );
  BUFX2 A10 ( .A(S[3]), .Y(n_A_0K) );
  BUFX2 A11 ( .A(S[2]), .Y(n_A_0N) );
  RG44 A0L ( .D(D[19:16]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_0W), .TE(TE), 
        .RN(n_A_0G), .TI(n_A_16), .CK(MCK), .Y({n_A_1V1, n_A_1V2, n_A_1V3, 
        n_A_1V4}), .TO(TO) );
  RG44 A0K ( .D(D[15:12]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_0W), .TE(TE), 
        .RN(n_A_0G), .TI(n_A_14), .CK(MCK), .Y({n_A_201, n_A_202, n_A_203, 
        n_A_204}), .TO(n_A_1N) );
  RG44 A0J ( .D(D[11:8]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_0W), .TE(TE), .RN(
        n_A_0G), .TI(n_A_15), .CK(MCK), .Y({n_A_241, n_A_242, n_A_243, n_A_244}), .TO(n_A_1M) );
  RG44 A0H ( .D(D[7:4]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_0W), .TE(TE), .RN(
        n_A_0G), .TI(n_A_0R), .CK(MCK), .Y({n_A_2B1, n_A_2B2, n_A_2B3, n_A_2B4}), .TO(n_A_1P) );
  RG44 A0G ( .D(D[3:0]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_0W), .TE(TE), .RN(
        n_A_0G), .TI(n_A_18), .CK(MCK), .Y({n_A_2C1, n_A_2C2, n_A_2C3, n_A_2C4}), .TO(n_A_2D) );
  RG44 A0F ( .D(D[19:16]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_13), .TE(TE), 
        .RN(n_A_0G), .TI(n_A_1C), .CK(MCK), .Y({n_A_1U1, n_A_1U2, n_A_1U3, 
        n_A_1U4}), .TO(n_A_16) );
  RG44 A0E ( .D(D[15:12]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_13), .TE(TE), 
        .RN(n_A_0G), .TI(n_A_1H), .CK(MCK), .Y({n_A_1Y1, n_A_1Y2, n_A_1Y3, 
        n_A_1Y4}), .TO(n_A_14) );
  RG44 A0D ( .D(D[11:8]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_13), .TE(TE), .RN(
        n_A_0G), .TI(n_A_0S), .CK(MCK), .Y({n_A_231, n_A_232, n_A_233, n_A_234}), .TO(n_A_15) );
  RG44 A0C ( .D(D[7:4]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_13), .TE(TE), .RN(
        n_A_0G), .TI(n_A_1G), .CK(MCK), .Y({n_A_2A1, n_A_2A2, n_A_2A3, n_A_2A4}), .TO(n_A_0R) );
  RG44 A0B ( .D(D[3:0]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_13), .TE(TE), .RN(
        n_A_0G), .TI(n_A_1K), .CK(MCK), .Y({n_A_271, n_A_272, n_A_273, n_A_274}), .TO(n_A_18) );
  RG44 A0A ( .D(D[19:16]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_0D), .TE(TE), 
        .RN(n_A_0G), .TI(n_A_1B), .CK(MCK), .Y({n_A_1T1, n_A_1T2, n_A_1T3, 
        n_A_1T4}), .TO(n_A_1C) );
  RG44 A09 ( .D(D[15:12]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_0D), .TE(TE), 
        .RN(n_A_0G), .TI(n_A_17), .CK(MCK), .Y({n_A_1X1, n_A_1X2, n_A_1X3, 
        n_A_1X4}), .TO(n_A_1H) );
  RG44 A08 ( .D(D[11:8]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_0D), .TE(TE), .RN(
        n_A_0G), .TI(n_A_1A), .CK(MCK), .Y({n_A_221, n_A_222, n_A_223, n_A_224}), .TO(n_A_0S) );
  RG44 A07 ( .D(D[7:4]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_0D), .TE(TE), .RN(
        n_A_0G), .TI(n_A_1D), .CK(MCK), .Y({n_A_291, n_A_292, n_A_293, n_A_294}), .TO(n_A_1G) );
  RG44 A06 ( .D(D[3:0]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_0D), .TE(TE), .RN(
        n_A_0G), .TI(n_A_1L), .CK(MCK), .Y({n_A_261, n_A_262, n_A_263, n_A_264}), .TO(n_A_1K) );
  RG44 A04 ( .D(D[15:12]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_12), .TE(TE), 
        .RN(n_A_0G), .TI(n_A_1M), .CK(MCK), .Y({n_A_1W1, n_A_1W2, n_A_1W3, 
        n_A_1W4}), .TO(n_A_17) );
  RG44 A03 ( .D(D[11:8]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_12), .TE(TE), .RN(
        n_A_0G), .TI(n_A_1P), .CK(MCK), .Y({n_A_211, n_A_212, n_A_213, n_A_214}), .TO(n_A_1A) );
  RG44 A02 ( .D(D[7:4]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_12), .TE(TE), .RN(
        n_A_0G), .TI(n_A_2D), .CK(MCK), .Y({n_A_1R1, n_A_1R2, n_A_1R3, n_A_1R4}), .TO(n_A_1D) );
  RG44 A01 ( .D(D[3:0]), .S1(n_A_0M), .S0(n_A_0L), .EN(n_A_12), .TE(TE), .RN(
        n_A_0G), .TI(TI), .CK(MCK), .Y({n_A_251, n_A_252, n_A_253, n_A_254}), 
        .TO(n_A_1L) );
  BUFX4 A1T ( .A(RN), .Y(n_A_0G) );
  BUFX4 A1A ( .A(S[1]), .Y(n_A_0M) );
  BUFX4 A19 ( .A(S[0]), .Y(n_A_0L) );
  DS044 A0M ( .A({n_A_1S1, n_A_1S2, n_A_1S3, n_A_1S4}), .B({n_A_1T1, n_A_1T2, 
        n_A_1T3, n_A_1T4}), .C({n_A_1U1, n_A_1U2, n_A_1U3, n_A_1U4}), .D({
        n_A_1V1, n_A_1V2, n_A_1V3, n_A_1V4}), .S1(n_A_0K), .S0(n_A_0N), .Y(
        Y[19:16]) );
  DS044 A0N ( .A({n_A_1W1, n_A_1W2, n_A_1W3, n_A_1W4}), .B({n_A_1X1, n_A_1X2, 
        n_A_1X3, n_A_1X4}), .C({n_A_1Y1, n_A_1Y2, n_A_1Y3, n_A_1Y4}), .D({
        n_A_201, n_A_202, n_A_203, n_A_204}), .S1(n_A_0K), .S0(n_A_0N), .Y(
        Y[15:12]) );
  DS044 A0P ( .A({n_A_211, n_A_212, n_A_213, n_A_214}), .B({n_A_221, n_A_222, 
        n_A_223, n_A_224}), .C({n_A_231, n_A_232, n_A_233, n_A_234}), .D({
        n_A_241, n_A_242, n_A_243, n_A_244}), .S1(n_A_0K), .S0(n_A_0N), .Y(
        Y[11:8]) );
  DS044 A0Q ( .A({n_A_1R1, n_A_1R2, n_A_1R3, n_A_1R4}), .B({n_A_291, n_A_292, 
        n_A_293, n_A_294}), .C({n_A_2A1, n_A_2A2, n_A_2A3, n_A_2A4}), .D({
        n_A_2B1, n_A_2B2, n_A_2B3, n_A_2B4}), .S1(n_A_0K), .S0(n_A_0N), .Y(
        Y[7:4]) );
  DS044 A0S ( .A({n_A_251, n_A_252, n_A_253, n_A_254}), .B({n_A_261, n_A_262, 
        n_A_263, n_A_264}), .C({n_A_271, n_A_272, n_A_273, n_A_274}), .D({
        n_A_2C1, n_A_2C2, n_A_2C3, n_A_2C4}), .S1(n_A_0K), .S0(n_A_0N), .Y(
        Y[3:0]) );
  DC04P A0T ( .EN(EN), .B(n_A_0K), .A(n_A_0N), .Y3(n_A_0W), .Y2(n_A_13), .Y1(
        n_A_0D), .Y0(n_A_12) );
endmodule


module DS044 ( A, B, C, D, S1, S0, Y );
  input [3:0] A;
  input [3:0] B;
  input [3:0] C;
  input [3:0] D;
  output [3:0] Y;
  input S1, S0;
  wire   n_A_06, n_A_02;

  MX4X1 A010 ( .S1(n_A_02), .S0(n_A_06), .D(D[0]), .C(C[0]), .B(B[0]), .A(A[0]), .Y(Y[0]) );
  MX4X1 A011 ( .S1(n_A_02), .S0(n_A_06), .D(D[1]), .C(C[1]), .B(B[1]), .A(A[1]), .Y(Y[1]) );
  MX4X1 A012 ( .S1(n_A_02), .S0(n_A_06), .D(D[2]), .C(C[2]), .B(B[2]), .A(A[2]), .Y(Y[2]) );
  BUFX2 A05 ( .A(S0), .Y(n_A_06) );
  BUFX2 A04 ( .A(S1), .Y(n_A_02) );
  MX4X1 A013 ( .S1(n_A_02), .S0(n_A_06), .D(D[3]), .C(C[3]), .B(B[3]), .A(A[3]), .Y(Y[3]) );
endmodule


module RG44 ( D, S1, S0, EN, TE, RN, TI, CK, Y, TO );
  input [3:0] D;
  output [3:0] Y;
  input S1, S0, EN, TE, RN, TI, CK;
  output TO;
  wire   n_A_0T, n_A_0D, n_A_0C, n_A_0V, n_A_0B, n_A_0E, n_A_0F, n_A_0G,
         n_A_0H, n_A_1G, n_A_1E, n_A_1F, n_A_1H, n_A_0Y, n_A_0X, n_A_0W,
         n_A_13, n_A_12, n_A_11, n_A_10, n_A_17, n_A_16, n_A_15, n_A_14,
         n_A_1C, n_A_1B, n_A_1A, n_A_19;

  BUFX4 A0X ( .A(RN), .Y(n_A_0T) );
  BUFX2 A0W ( .A(S0), .Y(n_A_0D) );
  BUFX2 A0V ( .A(S1), .Y(n_A_0C) );
  BUFX2 A0U ( .A(n_A_0V), .Y(TO) );
  BUFX4 A0T ( .A(TE), .Y(n_A_0B) );
  BUFX2 A0S ( .A(D[3]), .Y(n_A_0E) );
  BUFX2 A0R ( .A(D[2]), .Y(n_A_0F) );
  BUFX2 A0P ( .A(D[1]), .Y(n_A_0G) );
  BUFX2 A0N ( .A(D[0]), .Y(n_A_0H) );
  DC04P A0M ( .EN(EN), .B(n_A_0C), .A(n_A_0D), .Y3(n_A_1H), .Y2(n_A_1F), .Y1(
        n_A_1E), .Y0(n_A_1G) );
  MX4X1 A0L ( .S1(n_A_0C), .S0(n_A_0D), .D(n_A_0V), .C(n_A_0W), .B(n_A_0X), 
        .A(n_A_0Y), .Y(Y[3]) );
  MX4X1 A0K ( .S1(n_A_0C), .S0(n_A_0D), .D(n_A_10), .C(n_A_11), .B(n_A_12), 
        .A(n_A_13), .Y(Y[2]) );
  MX4X1 A0J ( .S1(n_A_0C), .S0(n_A_0D), .D(n_A_14), .C(n_A_15), .B(n_A_16), 
        .A(n_A_17), .Y(Y[1]) );
  MX4X1 A0H ( .S1(n_A_0C), .S0(n_A_0D), .D(n_A_19), .C(n_A_1A), .B(n_A_1B), 
        .A(n_A_1C), .Y(Y[0]) );
  FE1R A0G ( .RN(n_A_0T), .TE(n_A_0B), .TI(n_A_0W), .CK(CK), .EN(n_A_1H), .D(
        n_A_0E), .Q(n_A_0V) );
  FE1R A0F ( .RN(n_A_0T), .TE(n_A_0B), .TI(n_A_0X), .CK(CK), .EN(n_A_1F), .D(
        n_A_0E), .Q(n_A_0W) );
  FE1R A0E ( .RN(n_A_0T), .TE(n_A_0B), .TI(n_A_0Y), .CK(CK), .EN(n_A_1E), .D(
        n_A_0E), .Q(n_A_0X) );
  FE1R A0D ( .RN(n_A_0T), .TE(n_A_0B), .TI(n_A_10), .CK(CK), .EN(n_A_1G), .D(
        n_A_0E), .Q(n_A_0Y) );
  FE1R A0C ( .RN(n_A_0T), .TE(n_A_0B), .TI(n_A_11), .CK(CK), .EN(n_A_1H), .D(
        n_A_0F), .Q(n_A_10) );
  FE1R A0B ( .RN(n_A_0T), .TE(n_A_0B), .TI(n_A_12), .CK(CK), .EN(n_A_1F), .D(
        n_A_0F), .Q(n_A_11) );
  FE1R A0A ( .RN(n_A_0T), .TE(n_A_0B), .TI(n_A_13), .CK(CK), .EN(n_A_1E), .D(
        n_A_0F), .Q(n_A_12) );
  FE1R A09 ( .RN(n_A_0T), .TE(n_A_0B), .TI(n_A_14), .CK(CK), .EN(n_A_1G), .D(
        n_A_0F), .Q(n_A_13) );
  FE1R A08 ( .RN(n_A_0T), .TE(n_A_0B), .TI(n_A_15), .CK(CK), .EN(n_A_1H), .D(
        n_A_0G), .Q(n_A_14) );
  FE1R A07 ( .RN(n_A_0T), .TE(n_A_0B), .TI(n_A_16), .CK(CK), .EN(n_A_1F), .D(
        n_A_0G), .Q(n_A_15) );
  FE1R A06 ( .RN(n_A_0T), .TE(n_A_0B), .TI(n_A_17), .CK(CK), .EN(n_A_1E), .D(
        n_A_0G), .Q(n_A_16) );
  FE1R A05 ( .RN(n_A_0T), .TE(n_A_0B), .TI(n_A_19), .CK(CK), .EN(n_A_1G), .D(
        n_A_0G), .Q(n_A_17) );
  FE1R A04 ( .RN(n_A_0T), .TE(n_A_0B), .TI(n_A_1A), .CK(CK), .EN(n_A_1H), .D(
        n_A_0H), .Q(n_A_19) );
  FE1R A03 ( .RN(n_A_0T), .TE(n_A_0B), .TI(n_A_1B), .CK(CK), .EN(n_A_1F), .D(
        n_A_0H), .Q(n_A_1A) );
  FE1R A02 ( .RN(n_A_0T), .TE(n_A_0B), .TI(n_A_1C), .CK(CK), .EN(n_A_1E), .D(
        n_A_0H), .Q(n_A_1B) );
  FE1R A01 ( .RN(n_A_0T), .TE(n_A_0B), .TI(TI), .CK(CK), .EN(n_A_1G), .D(
        n_A_0H), .Q(n_A_1C) );
endmodule


module EDBMX ( EPSO, EIMO, ETO, EQO, EOO, ERO, ESSD, EXTI, EDBRS, LFACD, 
        EMSFEN, LFACLS, ESSDEN, EROEN, EXTIEN, EOOEN, EQOEN, ETOEN, EIMOEN, 
        EPSOEN, EDB, EDBR );
  input [19:0] EPSO;
  input [15:0] EIMO;
  input [19:0] ETO;
  input [19:0] EQO;
  input [19:0] EOO;
  input [19:0] ERO;
  input [19:0] ESSD;
  input [19:0] EXTI;
  input [1:0] EDBRS;
  input [3:0] LFACD;
  output [19:0] EDB;
  output [15:0] EDBR;
  input EMSFEN, LFACLS, ESSDEN, EROEN, EXTIEN, EOOEN, EQOEN, ETOEN, EIMOEN,
         EPSOEN;
  wire   n_A_0J20, n_A_0K20, n_A_0L20, n_A_0M20, n_A_0H20, n_A_0G20, n_A_0F20,
         n_A_0E20, n_A_0J19, n_A_0K19, n_A_0L19, n_A_0M19, n_A_0H19, n_A_0G19,
         n_A_0F19, n_A_0E19, n_A_0J18, n_A_0K18, n_A_0L18, n_A_0M18, n_A_0H18,
         n_A_0G18, n_A_0F18, n_A_0E18, n_A_0J17, n_A_0K17, n_A_0L17, n_A_0M17,
         n_A_0H17, n_A_0G17, n_A_0F17, n_A_0E17, n_A_0J16, n_A_0K16, n_A_0L16,
         n_A_0M16, n_A_0H16, n_A_0G16, n_A_0F16, n_A_0E16, n_A_0J15, n_A_0K15,
         n_A_0L15, n_A_0M15, n_A_0H15, n_A_0G15, n_A_0F15, n_A_0E15, n_A_0J14,
         n_A_0K14, n_A_0L14, n_A_0M14, n_A_0H14, n_A_0G14, n_A_0F14, n_A_0E14,
         n_A_0J13, n_A_0K13, n_A_0L13, n_A_0M13, n_A_0H13, n_A_0G13, n_A_0F13,
         n_A_0E13, n_A_0J12, n_A_0K12, n_A_0L12, n_A_0M12, n_A_0H12, n_A_0G12,
         n_A_0F12, n_A_0E12, n_A_0J11, n_A_0K11, n_A_0L11, n_A_0M11, n_A_0H11,
         n_A_0G11, n_A_0F11, n_A_0E11, n_A_0J10, n_A_0K10, n_A_0L10, n_A_0M10,
         n_A_0H10, n_A_0G10, n_A_0F10, n_A_0E10, n_A_0J9, n_A_0K9, n_A_0L9,
         n_A_0M9, n_A_0H9, n_A_0G9, n_A_0F9, n_A_0E9, n_A_0J8, n_A_0K8,
         n_A_0L8, n_A_0M8, n_A_0H8, n_A_0G8, n_A_0F8, n_A_0E8, n_A_0J7,
         n_A_0K7, n_A_0L7, n_A_0M7, n_A_0H7, n_A_0G7, n_A_0F7, n_A_0E7,
         n_A_0J6, n_A_0K6, n_A_0L6, n_A_0M6, n_A_0H6, n_A_0G6, n_A_0F6,
         n_A_0E6, n_A_0J5, n_A_0K5, n_A_0L5, n_A_0M5, n_A_0H5, n_A_0G5,
         n_A_0F5, n_A_0E5, n_A_0J4, n_A_0K4, n_A_0L4, n_A_0M4, n_A_0H4,
         n_A_0G4, n_A_0F4, n_A_0E4, n_A_0J3, n_A_0K3, n_A_0L3, n_A_0M3,
         n_A_0H3, n_A_0G3, n_A_0F3, n_A_0E3, n_A_0J2, n_A_0K2, n_A_0L2,
         n_A_0M2, n_A_0H2, n_A_0G2, n_A_0F2, n_A_0E2, n_A_0S, n_A_0W, n_A_11,
         n_A_15, n_A_19, n_A_1F, n_A_1W20, n_A_1H, n_A_1W19, n_A_1W18,
         n_A_1W17, n_A_1W16, n_A_1W15, n_A_1W14, n_A_1W13, n_A_1W12, n_A_1W11,
         n_A_1W10, n_A_1W9, n_A_1W8, n_A_1W7, n_A_1W6, n_A_1W5, n_A_1W4,
         n_A_1W3, n_A_1W2, n_A_1K, n_A_07, n_ED00, n_ED01, n_ED02, n_ED03,
         n_A_1W1, n_A_1R, n_A_0E1, n_A_0F1, n_A_0G1, n_A_0H1, n_A_0J1, n_A_0K1,
         n_A_0L1, n_A_0M1;

  ND8D2 A900 ( .H(n_A_0E20), .G(n_A_0F20), .F(n_A_0G20), .E(n_A_0H20), .D(
        n_A_0J20), .C(n_A_0K20), .B(n_A_0L20), .A(n_A_0M20), .Y(EDB[0]) );
  ND8D2 A901 ( .H(n_A_0E19), .G(n_A_0F19), .F(n_A_0G19), .E(n_A_0H19), .D(
        n_A_0J19), .C(n_A_0K19), .B(n_A_0L19), .A(n_A_0M19), .Y(EDB[1]) );
  ND8D2 A902 ( .H(n_A_0E18), .G(n_A_0F18), .F(n_A_0G18), .E(n_A_0H18), .D(
        n_A_0J18), .C(n_A_0K18), .B(n_A_0L18), .A(n_A_0M18), .Y(EDB[2]) );
  ND8D2 A903 ( .H(n_A_0E17), .G(n_A_0F17), .F(n_A_0G17), .E(n_A_0H17), .D(
        n_A_0J17), .C(n_A_0K17), .B(n_A_0L17), .A(n_A_0M17), .Y(EDB[3]) );
  ND8D2 A904 ( .H(n_A_0E16), .G(n_A_0F16), .F(n_A_0G16), .E(n_A_0H16), .D(
        n_A_0J16), .C(n_A_0K16), .B(n_A_0L16), .A(n_A_0M16), .Y(EDB[4]) );
  ND8D2 A905 ( .H(n_A_0E15), .G(n_A_0F15), .F(n_A_0G15), .E(n_A_0H15), .D(
        n_A_0J15), .C(n_A_0K15), .B(n_A_0L15), .A(n_A_0M15), .Y(EDB[5]) );
  ND8D2 A906 ( .H(n_A_0E14), .G(n_A_0F14), .F(n_A_0G14), .E(n_A_0H14), .D(
        n_A_0J14), .C(n_A_0K14), .B(n_A_0L14), .A(n_A_0M14), .Y(EDB[6]) );
  ND8D2 A907 ( .H(n_A_0E13), .G(n_A_0F13), .F(n_A_0G13), .E(n_A_0H13), .D(
        n_A_0J13), .C(n_A_0K13), .B(n_A_0L13), .A(n_A_0M13), .Y(EDB[7]) );
  ND8D2 A908 ( .H(n_A_0E12), .G(n_A_0F12), .F(n_A_0G12), .E(n_A_0H12), .D(
        n_A_0J12), .C(n_A_0K12), .B(n_A_0L12), .A(n_A_0M12), .Y(EDB[8]) );
  ND8D2 A909 ( .H(n_A_0E11), .G(n_A_0F11), .F(n_A_0G11), .E(n_A_0H11), .D(
        n_A_0J11), .C(n_A_0K11), .B(n_A_0L11), .A(n_A_0M11), .Y(EDB[9]) );
  ND8D2 A910 ( .H(n_A_0E10), .G(n_A_0F10), .F(n_A_0G10), .E(n_A_0H10), .D(
        n_A_0J10), .C(n_A_0K10), .B(n_A_0L10), .A(n_A_0M10), .Y(EDB[10]) );
  ND8D2 A911 ( .H(n_A_0E9), .G(n_A_0F9), .F(n_A_0G9), .E(n_A_0H9), .D(n_A_0J9), 
        .C(n_A_0K9), .B(n_A_0L9), .A(n_A_0M9), .Y(EDB[11]) );
  ND8D2 A912 ( .H(n_A_0E8), .G(n_A_0F8), .F(n_A_0G8), .E(n_A_0H8), .D(n_A_0J8), 
        .C(n_A_0K8), .B(n_A_0L8), .A(n_A_0M8), .Y(EDB[12]) );
  ND8D2 A913 ( .H(n_A_0E7), .G(n_A_0F7), .F(n_A_0G7), .E(n_A_0H7), .D(n_A_0J7), 
        .C(n_A_0K7), .B(n_A_0L7), .A(n_A_0M7), .Y(EDB[13]) );
  ND8D2 A914 ( .H(n_A_0E6), .G(n_A_0F6), .F(n_A_0G6), .E(n_A_0H6), .D(n_A_0J6), 
        .C(n_A_0K6), .B(n_A_0L6), .A(n_A_0M6), .Y(EDB[14]) );
  ND8D2 A915 ( .H(n_A_0E5), .G(n_A_0F5), .F(n_A_0G5), .E(n_A_0H5), .D(n_A_0J5), 
        .C(n_A_0K5), .B(n_A_0L5), .A(n_A_0M5), .Y(EDB[15]) );
  ND8D2 A916 ( .H(n_A_0E4), .G(n_A_0F4), .F(n_A_0G4), .E(n_A_0H4), .D(n_A_0J4), 
        .C(n_A_0K4), .B(n_A_0L4), .A(n_A_0M4), .Y(EDB[16]) );
  ND8D2 A917 ( .H(n_A_0E3), .G(n_A_0F3), .F(n_A_0G3), .E(n_A_0H3), .D(n_A_0J3), 
        .C(n_A_0K3), .B(n_A_0L3), .A(n_A_0M3), .Y(EDB[17]) );
  ND8D2 A918 ( .H(n_A_0E2), .G(n_A_0F2), .F(n_A_0G2), .E(n_A_0H2), .D(n_A_0J2), 
        .C(n_A_0K2), .B(n_A_0L2), .A(n_A_0M2), .Y(EDB[18]) );
  NAND2X1 A100 ( .A(ESSD[0]), .B(n_A_0S), .Y(n_A_0M20) );
  NAND2X1 A101 ( .A(ESSD[1]), .B(n_A_0S), .Y(n_A_0M19) );
  NAND2X1 A102 ( .A(ESSD[2]), .B(n_A_0S), .Y(n_A_0M18) );
  NAND2X1 A103 ( .A(ESSD[3]), .B(n_A_0S), .Y(n_A_0M17) );
  NAND2X1 A104 ( .A(ESSD[4]), .B(n_A_0S), .Y(n_A_0M16) );
  NAND2X1 A105 ( .A(ESSD[5]), .B(n_A_0S), .Y(n_A_0M15) );
  NAND2X1 A106 ( .A(ESSD[6]), .B(n_A_0S), .Y(n_A_0M14) );
  NAND2X1 A107 ( .A(ESSD[7]), .B(n_A_0S), .Y(n_A_0M13) );
  NAND2X1 A108 ( .A(ESSD[8]), .B(n_A_0S), .Y(n_A_0M12) );
  NAND2X1 A109 ( .A(ESSD[9]), .B(n_A_0S), .Y(n_A_0M11) );
  NAND2X1 A110 ( .A(ESSD[10]), .B(n_A_0S), .Y(n_A_0M10) );
  NAND2X1 A111 ( .A(ESSD[11]), .B(n_A_0S), .Y(n_A_0M9) );
  NAND2X1 A112 ( .A(ESSD[12]), .B(n_A_0S), .Y(n_A_0M8) );
  NAND2X1 A113 ( .A(ESSD[13]), .B(n_A_0S), .Y(n_A_0M7) );
  NAND2X1 A114 ( .A(ESSD[14]), .B(n_A_0S), .Y(n_A_0M6) );
  NAND2X1 A115 ( .A(ESSD[15]), .B(n_A_0S), .Y(n_A_0M5) );
  NAND2X1 A116 ( .A(ESSD[16]), .B(n_A_0S), .Y(n_A_0M4) );
  NAND2X1 A117 ( .A(ESSD[17]), .B(n_A_0S), .Y(n_A_0M3) );
  NAND2X1 A118 ( .A(ESSD[18]), .B(n_A_0S), .Y(n_A_0M2) );
  NAND2X1 A200 ( .A(ERO[0]), .B(n_A_0W), .Y(n_A_0L20) );
  NAND2X1 A201 ( .A(ERO[1]), .B(n_A_0W), .Y(n_A_0L19) );
  NAND2X1 A202 ( .A(ERO[2]), .B(n_A_0W), .Y(n_A_0L18) );
  NAND2X1 A203 ( .A(ERO[3]), .B(n_A_0W), .Y(n_A_0L17) );
  NAND2X1 A204 ( .A(ERO[4]), .B(n_A_0W), .Y(n_A_0L16) );
  NAND2X1 A205 ( .A(ERO[5]), .B(n_A_0W), .Y(n_A_0L15) );
  NAND2X1 A206 ( .A(ERO[6]), .B(n_A_0W), .Y(n_A_0L14) );
  NAND2X1 A207 ( .A(ERO[7]), .B(n_A_0W), .Y(n_A_0L13) );
  NAND2X1 A208 ( .A(ERO[8]), .B(n_A_0W), .Y(n_A_0L12) );
  NAND2X1 A209 ( .A(ERO[9]), .B(n_A_0W), .Y(n_A_0L11) );
  NAND2X1 A210 ( .A(ERO[10]), .B(n_A_0W), .Y(n_A_0L10) );
  NAND2X1 A211 ( .A(ERO[11]), .B(n_A_0W), .Y(n_A_0L9) );
  NAND2X1 A212 ( .A(ERO[12]), .B(n_A_0W), .Y(n_A_0L8) );
  NAND2X1 A213 ( .A(ERO[13]), .B(n_A_0W), .Y(n_A_0L7) );
  NAND2X1 A214 ( .A(ERO[14]), .B(n_A_0W), .Y(n_A_0L6) );
  NAND2X1 A215 ( .A(ERO[15]), .B(n_A_0W), .Y(n_A_0L5) );
  NAND2X1 A216 ( .A(ERO[16]), .B(n_A_0W), .Y(n_A_0L4) );
  NAND2X1 A217 ( .A(ERO[17]), .B(n_A_0W), .Y(n_A_0L3) );
  NAND2X1 A218 ( .A(ERO[18]), .B(n_A_0W), .Y(n_A_0L2) );
  NAND2X1 A300 ( .A(EXTI[0]), .B(n_A_11), .Y(n_A_0K20) );
  NAND2X1 A301 ( .A(EXTI[1]), .B(n_A_11), .Y(n_A_0K19) );
  NAND2X1 A302 ( .A(EXTI[2]), .B(n_A_11), .Y(n_A_0K18) );
  NAND2X1 A303 ( .A(EXTI[3]), .B(n_A_11), .Y(n_A_0K17) );
  NAND2X1 A304 ( .A(EXTI[4]), .B(n_A_11), .Y(n_A_0K16) );
  NAND2X1 A305 ( .A(EXTI[5]), .B(n_A_11), .Y(n_A_0K15) );
  NAND2X1 A306 ( .A(EXTI[6]), .B(n_A_11), .Y(n_A_0K14) );
  NAND2X1 A307 ( .A(EXTI[7]), .B(n_A_11), .Y(n_A_0K13) );
  NAND2X1 A308 ( .A(EXTI[8]), .B(n_A_11), .Y(n_A_0K12) );
  NAND2X1 A309 ( .A(EXTI[9]), .B(n_A_11), .Y(n_A_0K11) );
  NAND2X1 A310 ( .A(EXTI[10]), .B(n_A_11), .Y(n_A_0K10) );
  NAND2X1 A311 ( .A(EXTI[11]), .B(n_A_11), .Y(n_A_0K9) );
  NAND2X1 A312 ( .A(EXTI[12]), .B(n_A_11), .Y(n_A_0K8) );
  NAND2X1 A313 ( .A(EXTI[13]), .B(n_A_11), .Y(n_A_0K7) );
  NAND2X1 A314 ( .A(EXTI[14]), .B(n_A_11), .Y(n_A_0K6) );
  NAND2X1 A315 ( .A(EXTI[15]), .B(n_A_11), .Y(n_A_0K5) );
  NAND2X1 A316 ( .A(EXTI[16]), .B(n_A_11), .Y(n_A_0K4) );
  NAND2X1 A317 ( .A(EXTI[17]), .B(n_A_11), .Y(n_A_0K3) );
  NAND2X1 A318 ( .A(EXTI[18]), .B(n_A_11), .Y(n_A_0K2) );
  NAND2X1 A400 ( .A(EOO[0]), .B(n_A_15), .Y(n_A_0J20) );
  NAND2X1 A401 ( .A(EOO[1]), .B(n_A_15), .Y(n_A_0J19) );
  NAND2X1 A402 ( .A(EOO[2]), .B(n_A_15), .Y(n_A_0J18) );
  NAND2X1 A403 ( .A(EOO[3]), .B(n_A_15), .Y(n_A_0J17) );
  NAND2X1 A404 ( .A(EOO[4]), .B(n_A_15), .Y(n_A_0J16) );
  NAND2X1 A405 ( .A(EOO[5]), .B(n_A_15), .Y(n_A_0J15) );
  NAND2X1 A406 ( .A(EOO[6]), .B(n_A_15), .Y(n_A_0J14) );
  NAND2X1 A407 ( .A(EOO[7]), .B(n_A_15), .Y(n_A_0J13) );
  NAND2X1 A408 ( .A(EOO[8]), .B(n_A_15), .Y(n_A_0J12) );
  NAND2X1 A409 ( .A(EOO[9]), .B(n_A_15), .Y(n_A_0J11) );
  NAND2X1 A410 ( .A(EOO[10]), .B(n_A_15), .Y(n_A_0J10) );
  NAND2X1 A411 ( .A(EOO[11]), .B(n_A_15), .Y(n_A_0J9) );
  NAND2X1 A412 ( .A(EOO[12]), .B(n_A_15), .Y(n_A_0J8) );
  NAND2X1 A413 ( .A(EOO[13]), .B(n_A_15), .Y(n_A_0J7) );
  NAND2X1 A414 ( .A(EOO[14]), .B(n_A_15), .Y(n_A_0J6) );
  NAND2X1 A415 ( .A(EOO[15]), .B(n_A_15), .Y(n_A_0J5) );
  NAND2X1 A416 ( .A(EOO[16]), .B(n_A_15), .Y(n_A_0J4) );
  NAND2X1 A417 ( .A(EOO[17]), .B(n_A_15), .Y(n_A_0J3) );
  NAND2X1 A418 ( .A(EOO[18]), .B(n_A_15), .Y(n_A_0J2) );
  NAND2X1 A500 ( .A(EQO[0]), .B(n_A_19), .Y(n_A_0H20) );
  NAND2X1 A501 ( .A(EQO[1]), .B(n_A_19), .Y(n_A_0H19) );
  NAND2X1 A502 ( .A(EQO[2]), .B(n_A_19), .Y(n_A_0H18) );
  NAND2X1 A503 ( .A(EQO[3]), .B(n_A_19), .Y(n_A_0H17) );
  NAND2X1 A504 ( .A(EQO[4]), .B(n_A_19), .Y(n_A_0H16) );
  NAND2X1 A505 ( .A(EQO[5]), .B(n_A_19), .Y(n_A_0H15) );
  NAND2X1 A506 ( .A(EQO[6]), .B(n_A_19), .Y(n_A_0H14) );
  NAND2X1 A507 ( .A(EQO[7]), .B(n_A_19), .Y(n_A_0H13) );
  NAND2X1 A508 ( .A(EQO[8]), .B(n_A_19), .Y(n_A_0H12) );
  NAND2X1 A509 ( .A(EQO[9]), .B(n_A_19), .Y(n_A_0H11) );
  NAND2X1 A510 ( .A(EQO[10]), .B(n_A_19), .Y(n_A_0H10) );
  NAND2X1 A511 ( .A(EQO[11]), .B(n_A_19), .Y(n_A_0H9) );
  NAND2X1 A512 ( .A(EQO[12]), .B(n_A_19), .Y(n_A_0H8) );
  NAND2X1 A513 ( .A(EQO[13]), .B(n_A_19), .Y(n_A_0H7) );
  NAND2X1 A514 ( .A(EQO[14]), .B(n_A_19), .Y(n_A_0H6) );
  NAND2X1 A515 ( .A(EQO[15]), .B(n_A_19), .Y(n_A_0H5) );
  NAND2X1 A516 ( .A(EQO[16]), .B(n_A_19), .Y(n_A_0H4) );
  NAND2X1 A517 ( .A(EQO[17]), .B(n_A_19), .Y(n_A_0H3) );
  NAND2X1 A518 ( .A(EQO[18]), .B(n_A_19), .Y(n_A_0H2) );
  NAND2X1 A600 ( .A(ETO[0]), .B(n_A_1F), .Y(n_A_0G20) );
  NAND2X1 A601 ( .A(ETO[1]), .B(n_A_1F), .Y(n_A_0G19) );
  NAND2X1 A602 ( .A(ETO[2]), .B(n_A_1F), .Y(n_A_0G18) );
  NAND2X1 A603 ( .A(ETO[3]), .B(n_A_1F), .Y(n_A_0G17) );
  NAND2X1 A604 ( .A(ETO[4]), .B(n_A_1F), .Y(n_A_0G16) );
  NAND2X1 A605 ( .A(ETO[5]), .B(n_A_1F), .Y(n_A_0G15) );
  NAND2X1 A606 ( .A(ETO[6]), .B(n_A_1F), .Y(n_A_0G14) );
  NAND2X1 A607 ( .A(ETO[7]), .B(n_A_1F), .Y(n_A_0G13) );
  NAND2X1 A608 ( .A(ETO[8]), .B(n_A_1F), .Y(n_A_0G12) );
  NAND2X1 A609 ( .A(ETO[9]), .B(n_A_1F), .Y(n_A_0G11) );
  NAND2X1 A610 ( .A(ETO[10]), .B(n_A_1F), .Y(n_A_0G10) );
  NAND2X1 A611 ( .A(ETO[11]), .B(n_A_1F), .Y(n_A_0G9) );
  NAND2X1 A612 ( .A(ETO[12]), .B(n_A_1F), .Y(n_A_0G8) );
  NAND2X1 A613 ( .A(ETO[13]), .B(n_A_1F), .Y(n_A_0G7) );
  NAND2X1 A614 ( .A(ETO[14]), .B(n_A_1F), .Y(n_A_0G6) );
  NAND2X1 A615 ( .A(ETO[15]), .B(n_A_1F), .Y(n_A_0G5) );
  NAND2X1 A616 ( .A(ETO[16]), .B(n_A_1F), .Y(n_A_0G4) );
  NAND2X1 A617 ( .A(ETO[17]), .B(n_A_1F), .Y(n_A_0G3) );
  NAND2X1 A618 ( .A(ETO[18]), .B(n_A_1F), .Y(n_A_0G2) );
  NAND2X1 A700 ( .A(n_A_1W20), .B(n_A_1H), .Y(n_A_0F20) );
  NAND2X1 A701 ( .A(n_A_1W19), .B(n_A_1H), .Y(n_A_0F19) );
  NAND2X1 A702 ( .A(n_A_1W18), .B(n_A_1H), .Y(n_A_0F18) );
  NAND2X1 A703 ( .A(n_A_1W17), .B(n_A_1H), .Y(n_A_0F17) );
  NAND2X1 A704 ( .A(n_A_1W16), .B(n_A_1H), .Y(n_A_0F16) );
  NAND2X1 A705 ( .A(n_A_1W15), .B(n_A_1H), .Y(n_A_0F15) );
  NAND2X1 A706 ( .A(n_A_1W14), .B(n_A_1H), .Y(n_A_0F14) );
  NAND2X1 A707 ( .A(n_A_1W13), .B(n_A_1H), .Y(n_A_0F13) );
  NAND2X1 A708 ( .A(n_A_1W12), .B(n_A_1H), .Y(n_A_0F12) );
  NAND2X1 A709 ( .A(n_A_1W11), .B(n_A_1H), .Y(n_A_0F11) );
  NAND2X1 A710 ( .A(n_A_1W10), .B(n_A_1H), .Y(n_A_0F10) );
  NAND2X1 A711 ( .A(n_A_1W9), .B(n_A_1H), .Y(n_A_0F9) );
  NAND2X1 A712 ( .A(n_A_1W8), .B(n_A_1H), .Y(n_A_0F8) );
  NAND2X1 A713 ( .A(n_A_1W7), .B(n_A_1H), .Y(n_A_0F7) );
  NAND2X1 A714 ( .A(n_A_1W6), .B(n_A_1H), .Y(n_A_0F6) );
  NAND2X1 A715 ( .A(n_A_1W5), .B(n_A_1H), .Y(n_A_0F5) );
  NAND2X1 A716 ( .A(n_A_1W4), .B(n_A_1H), .Y(n_A_0F4) );
  NAND2X1 A717 ( .A(n_A_1W3), .B(n_A_1H), .Y(n_A_0F3) );
  NAND2X1 A718 ( .A(n_A_1W2), .B(n_A_1H), .Y(n_A_0F2) );
  NAND2X1 A800 ( .A(EPSO[0]), .B(n_A_1K), .Y(n_A_0E20) );
  NAND2X1 A801 ( .A(EPSO[1]), .B(n_A_1K), .Y(n_A_0E19) );
  NAND2X1 A802 ( .A(EPSO[2]), .B(n_A_1K), .Y(n_A_0E18) );
  NAND2X1 A803 ( .A(EPSO[3]), .B(n_A_1K), .Y(n_A_0E17) );
  NAND2X1 A804 ( .A(EPSO[4]), .B(n_A_1K), .Y(n_A_0E16) );
  NAND2X1 A805 ( .A(EPSO[5]), .B(n_A_1K), .Y(n_A_0E15) );
  NAND2X1 A806 ( .A(EPSO[6]), .B(n_A_1K), .Y(n_A_0E14) );
  NAND2X1 A807 ( .A(EPSO[7]), .B(n_A_1K), .Y(n_A_0E13) );
  NAND2X1 A808 ( .A(EPSO[8]), .B(n_A_1K), .Y(n_A_0E12) );
  NAND2X1 A809 ( .A(EPSO[9]), .B(n_A_1K), .Y(n_A_0E11) );
  NAND2X1 A810 ( .A(EPSO[10]), .B(n_A_1K), .Y(n_A_0E10) );
  NAND2X1 A811 ( .A(EPSO[11]), .B(n_A_1K), .Y(n_A_0E9) );
  NAND2X1 A812 ( .A(EPSO[12]), .B(n_A_1K), .Y(n_A_0E8) );
  NAND2X1 A813 ( .A(EPSO[13]), .B(n_A_1K), .Y(n_A_0E7) );
  NAND2X1 A814 ( .A(EPSO[14]), .B(n_A_1K), .Y(n_A_0E6) );
  NAND2X1 A815 ( .A(EPSO[15]), .B(n_A_1K), .Y(n_A_0E5) );
  NAND2X1 A816 ( .A(EPSO[16]), .B(n_A_1K), .Y(n_A_0E4) );
  NAND2X1 A817 ( .A(EPSO[17]), .B(n_A_1K), .Y(n_A_0E3) );
  NAND2X1 A818 ( .A(EPSO[18]), .B(n_A_1K), .Y(n_A_0E2) );
  AND2X1 A1V0 ( .A(LFACD[0]), .B(n_A_07), .Y(n_ED00) );
  AND2X1 A1V1 ( .A(LFACD[1]), .B(n_A_07), .Y(n_ED01) );
  AND2X1 A1V2 ( .A(LFACD[2]), .B(n_A_07), .Y(n_ED02) );
  AND2X1 A1V3 ( .A(LFACD[3]), .B(n_A_07), .Y(n_ED03) );
  BUFX2 A0V ( .A(LFACLS), .Y(n_A_07) );
  BS2014 A1W ( .D({EIMO, n_ED03, n_ED02, n_ED01, n_ED00}), .SFT(EMSFEN), .Y({
        n_A_1W1, n_A_1W2, n_A_1W3, n_A_1W4, n_A_1W5, n_A_1W6, n_A_1W7, n_A_1W8, 
        n_A_1W9, n_A_1W10, n_A_1W11, n_A_1W12, n_A_1W13, n_A_1W14, n_A_1W15, 
        n_A_1W16, n_A_1W17, n_A_1W18, n_A_1W19, n_A_1W20}) );
  RDLGC A1F ( .D19(EDB[19]), .D18(EDB[18]), .D17(EDB[17]), .D16(EDB[16]), .D1(
        EDB[1]), .D2(EDB[2]), .D3(EDB[3]), .S1(EDBRS[1]), .S0(EDBRS[0]), .Y(
        n_A_1R) );
  INC16 A1E ( .D(EDB[19:4]), .CI(n_A_1R), .S(EDBR) );
  BUFX4 A14 ( .A(ESSDEN), .Y(n_A_0S) );
  BUFX4 A13 ( .A(EROEN), .Y(n_A_0W) );
  BUFX4 A12 ( .A(EXTIEN), .Y(n_A_11) );
  BUFX4 A11 ( .A(EOOEN), .Y(n_A_15) );
  BUFX4 A10 ( .A(EQOEN), .Y(n_A_19) );
  BUFX4 A0Y ( .A(ETOEN), .Y(n_A_1F) );
  BUFX4 A0X ( .A(EIMOEN), .Y(n_A_1H) );
  BUFX4 A0W ( .A(EPSOEN), .Y(n_A_1K) );
  NAND2X1 A819 ( .A(EPSO[19]), .B(n_A_1K), .Y(n_A_0E1) );
  NAND2X1 A719 ( .A(n_A_1W1), .B(n_A_1H), .Y(n_A_0F1) );
  NAND2X1 A619 ( .A(ETO[19]), .B(n_A_1F), .Y(n_A_0G1) );
  NAND2X1 A519 ( .A(EQO[19]), .B(n_A_19), .Y(n_A_0H1) );
  NAND2X1 A419 ( .A(EOO[19]), .B(n_A_15), .Y(n_A_0J1) );
  NAND2X1 A319 ( .A(EXTI[19]), .B(n_A_11), .Y(n_A_0K1) );
  NAND2X1 A219 ( .A(ERO[19]), .B(n_A_0W), .Y(n_A_0L1) );
  NAND2X1 A119 ( .A(ESSD[19]), .B(n_A_0S), .Y(n_A_0M1) );
  ND8D2 A919 ( .H(n_A_0E1), .G(n_A_0F1), .F(n_A_0G1), .E(n_A_0H1), .D(n_A_0J1), 
        .C(n_A_0K1), .B(n_A_0L1), .A(n_A_0M1), .Y(EDB[19]) );
endmodule


module INC16 ( D, CI, S );
  input [15:0] D;
  output [15:0] S;
  input CI;
  wire   n_A_08;

  INC08C A01 ( .D(D[7:0]), .CI(CI), .S(S[7:0]), .CO(n_A_08) );
  INC08 A02 ( .D(D[15:8]), .CI(n_A_08), .S(S[15:8]) );
endmodule


module INC08 ( D, CI, S );
  input [7:0] D;
  output [7:0] S;
  input CI;
  wire   n_A_0Y, n_A_0W, n_A_0K, n_A_0X, n_A_0L, n_A_0M, n_A_0V, n_A_10,
         n_A_0N, n_A_11, n_A_0P, n_A_12, n_A_0R, n_A_0S, n_A_0U, n_A_0T;

  XOR2X1 A0G ( .A(n_A_0Y), .B(n_A_0W), .Y(S[7]) );
  XOR2X1 A0F ( .A(n_A_0K), .B(n_A_0X), .Y(S[6]) );
  XOR2X1 A0E ( .A(n_A_0L), .B(n_A_0M), .Y(S[5]) );
  XOR2X1 A0D ( .A(n_A_0V), .B(n_A_10), .Y(S[4]) );
  XOR2X1 A0C ( .A(n_A_0N), .B(n_A_11), .Y(S[3]) );
  XOR2X1 A0B ( .A(n_A_0P), .B(n_A_12), .Y(S[2]) );
  XOR2X1 A0A ( .A(n_A_0R), .B(n_A_0S), .Y(S[1]) );
  XOR2X1 A09 ( .A(n_A_0U), .B(n_A_0T), .Y(S[0]) );
  AND2X1 A0K ( .A(n_A_0R), .B(n_A_0S), .Y(n_A_12) );
  BUFX2 A0R ( .A(CI), .Y(n_A_0T) );
  AND3X1 A0P ( .A(n_A_0K), .B(n_A_0L), .C(n_A_0M), .Y(n_A_0W) );
  AND2X1 A0N ( .A(n_A_0L), .B(n_A_0M), .Y(n_A_0X) );
  AND4X1 A0M ( .A(n_A_0N), .B(n_A_0P), .C(n_A_0R), .D(n_A_0S), .Y(n_A_10) );
  AND3X1 A0L ( .A(n_A_0P), .B(n_A_0S), .C(n_A_0R), .Y(n_A_11) );
  AND2X1 A0J ( .A(n_A_0U), .B(n_A_0T), .Y(n_A_0S) );
  AD6 A0H ( .F(n_A_0T), .E(n_A_0U), .D(n_A_0R), .C(n_A_0P), .B(n_A_0N), .A(
        n_A_0V), .Y(n_A_0M) );
  BUFX2 A08 ( .A(D[0]), .Y(n_A_0U) );
  BUFX2 A07 ( .A(D[1]), .Y(n_A_0R) );
  BUFX2 A06 ( .A(D[2]), .Y(n_A_0P) );
  BUFX2 A05 ( .A(D[3]), .Y(n_A_0N) );
  BUFX2 A04 ( .A(D[4]), .Y(n_A_0V) );
  BUFX2 A03 ( .A(D[5]), .Y(n_A_0L) );
  BUFX2 A02 ( .A(D[6]), .Y(n_A_0K) );
  BUFX2 A01 ( .A(D[7]), .Y(n_A_0Y) );
endmodule


module INC08C ( D, CI, S, CO );
  input [7:0] D;
  output [7:0] S;
  input CI;
  output CO;
  wire   n_A_0Y, n_A_0W, n_A_0K, n_A_0X, n_A_0L, n_A_0M, n_A_0V, n_A_10,
         n_A_0N, n_A_11, n_A_0P, n_A_12, n_A_0R, n_A_0S, n_A_0U, n_A_0T,
         n_A_15;

  XOR2X1 A0G ( .A(n_A_0Y), .B(n_A_0W), .Y(S[7]) );
  XOR2X1 A0F ( .A(n_A_0K), .B(n_A_0X), .Y(S[6]) );
  XOR2X1 A0E ( .A(n_A_0L), .B(n_A_0M), .Y(S[5]) );
  XOR2X1 A0D ( .A(n_A_0V), .B(n_A_10), .Y(S[4]) );
  XOR2X1 A0C ( .A(n_A_0N), .B(n_A_11), .Y(S[3]) );
  XOR2X1 A0B ( .A(n_A_0P), .B(n_A_12), .Y(S[2]) );
  XOR2X1 A0A ( .A(n_A_0R), .B(n_A_0S), .Y(S[1]) );
  XOR2X1 A09 ( .A(n_A_0U), .B(n_A_0T), .Y(S[0]) );
  AND2X1 A1D ( .A(n_A_15), .B(n_A_0T), .Y(CO) );
  AD8 A1C ( .H(n_A_0U), .G(n_A_0R), .F(n_A_0P), .E(n_A_0N), .D(n_A_0V), .C(
        n_A_0L), .B(n_A_0K), .A(n_A_0Y), .Y(n_A_15) );
  AND2X1 A0K ( .A(n_A_0R), .B(n_A_0S), .Y(n_A_12) );
  BUFX2 A0R ( .A(CI), .Y(n_A_0T) );
  AND3X1 A0P ( .A(n_A_0K), .B(n_A_0L), .C(n_A_0M), .Y(n_A_0W) );
  AND2X1 A0N ( .A(n_A_0L), .B(n_A_0M), .Y(n_A_0X) );
  AND4X1 A0M ( .A(n_A_0N), .B(n_A_0P), .C(n_A_0R), .D(n_A_0S), .Y(n_A_10) );
  AND3X1 A0L ( .A(n_A_0P), .B(n_A_0S), .C(n_A_0R), .Y(n_A_11) );
  AND2X1 A0J ( .A(n_A_0U), .B(n_A_0T), .Y(n_A_0S) );
  AD6 A0H ( .F(n_A_0T), .E(n_A_0U), .D(n_A_0R), .C(n_A_0P), .B(n_A_0N), .A(
        n_A_0V), .Y(n_A_0M) );
  BUFX2 A08 ( .A(D[0]), .Y(n_A_0U) );
  BUFX2 A07 ( .A(D[1]), .Y(n_A_0R) );
  BUFX2 A06 ( .A(D[2]), .Y(n_A_0P) );
  BUFX2 A05 ( .A(D[3]), .Y(n_A_0N) );
  BUFX2 A04 ( .A(D[4]), .Y(n_A_0V) );
  BUFX2 A03 ( .A(D[5]), .Y(n_A_0L) );
  BUFX2 A02 ( .A(D[6]), .Y(n_A_0K) );
  BUFX2 A01 ( .A(D[7]), .Y(n_A_0Y) );
endmodule


module RDLGC ( D19, D18, D17, D16, D1, D2, D3, S1, S0, Y );
  input D19, D18, D17, D16, D1, D2, D3, S1, S0;
  output Y;
  wire   n_A_0R, n_A_01, n_A_02, n_A_0P, n_A_0N, n_A_09, n_A_0A, n_A_03,
         n_A_04, n_A_08, n_A_07, n_A_0J, n_A_0H, n_A_0C, n_A_06;

  BUFX2 A0T ( .A(S1), .Y(n_A_0R) );
  BUFX2 A0S ( .A(S0), .Y(n_A_01) );
  NAND4X1 A01 ( .A(n_A_02), .B(n_A_0P), .C(n_A_0N), .D(D1), .Y(n_A_09) );
  NAND3X1 A02 ( .A(n_A_03), .B(n_A_0P), .C(n_A_0N), .Y(n_A_0A) );
  NAND2X1 A03 ( .A(n_A_04), .B(n_A_0P), .Y(n_A_08) );
  NAND3X1 A0A ( .A(n_A_08), .B(n_A_0A), .C(n_A_09), .Y(n_A_07) );
  INVX1 A0E ( .A(n_A_01), .Y(n_A_0J) );
  BUFX2 A0D ( .A(D2), .Y(n_A_0N) );
  BUFX2 A0C ( .A(D3), .Y(n_A_0P) );
  INVX1 A0B ( .A(n_A_0R), .Y(n_A_0H) );
  AND2X1 A09 ( .A(n_A_01), .B(n_A_0H), .Y(n_A_02) );
  AND2X1 A08 ( .A(n_A_0R), .B(n_A_0J), .Y(n_A_03) );
  AND2X1 A07 ( .A(n_A_01), .B(n_A_0R), .Y(n_A_04) );
  INVX1 A06 ( .A(D19), .Y(n_A_0C) );
  AND2X1 A05 ( .A(n_A_07), .B(n_A_06), .Y(Y) );
  NAND4X1 A04 ( .A(D16), .B(D17), .C(D18), .D(n_A_0C), .Y(n_A_06) );
endmodule


module BS2014 ( D, SFT, Y );
  input [19:0] D;
  output [19:0] Y;
  input SFT;
  wire   n_A_1V, n_A_1U;

  BUFX2 A27 ( .A(D[19]), .Y(n_A_1V) );
  BUFX2 A06 ( .A(SFT), .Y(n_A_1U) );
  DS42 A05 ( .S(n_A_1U), .B3(D[4]), .A3(D[0]), .B2(D[5]), .A2(D[1]), .B1(D[6]), 
        .A1(D[2]), .B0(D[7]), .A0(D[3]), .Y3(Y[0]), .Y2(Y[1]), .Y1(Y[2]), .Y0(
        Y[3]) );
  DS42 A04 ( .S(n_A_1U), .B3(D[8]), .A3(D[4]), .B2(D[9]), .A2(D[5]), .B1(D[10]), .A1(D[6]), .B0(D[11]), .A0(D[7]), .Y3(Y[4]), .Y2(Y[5]), .Y1(Y[6]), .Y0(Y[7])
         );
  DS42 A03 ( .S(n_A_1U), .B3(D[12]), .A3(D[8]), .B2(D[13]), .A2(D[9]), .B1(
        D[14]), .A1(D[10]), .B0(D[15]), .A0(D[11]), .Y3(Y[8]), .Y2(Y[9]), .Y1(
        Y[10]), .Y0(Y[11]) );
  DS42 A02 ( .S(n_A_1U), .B3(D[16]), .A3(D[12]), .B2(D[17]), .A2(D[13]), .B1(
        D[18]), .A1(D[14]), .B0(n_A_1V), .A0(D[15]), .Y3(Y[12]), .Y2(Y[13]), 
        .Y1(Y[14]), .Y0(Y[15]) );
  DS42 A01 ( .S(n_A_1U), .B3(n_A_1V), .A3(D[16]), .B2(n_A_1V), .A2(D[17]), 
        .B1(n_A_1V), .A1(D[18]), .B0(n_A_1V), .A0(D[19]), .Y3(Y[16]), .Y2(
        Y[17]), .Y1(Y[18]), .Y0(Y[19]) );
endmodule


module ND8D2 ( H, G, F, E, D, C, B, A, Y );
  input H, G, F, E, D, C, B, A;
  output Y;
  wire   n_A_0A, n_A_01;

  NAND2X2 A0C ( .A(n_A_0A), .B(n_A_01), .Y(Y) );
  AND4X1 A01 ( .A(E), .B(F), .C(G), .D(H), .Y(n_A_01) );
  AND4X1 A0B ( .A(A), .B(B), .C(C), .D(D), .Y(n_A_0A) );
endmodule


module ERREG ( EDB, XRST, TE, ERLRS, ERS2, ERS1, ERLE, TI, MCK, ERO, TO );
  input [19:0] EDB;
  output [19:0] ERO;
  input XRST, TE, ERLRS, ERS2, ERS1, ERLE, TI, MCK;
  output TO;
  wire   n_A_0820, n_A_0819, n_A_0818, n_A_0817, n_A_0816, n_A_0815, n_A_0814,
         n_A_0813, n_A_0812, n_A_0811, n_A_0810, n_A_089, n_A_088, n_A_087,
         n_A_086, n_A_085, n_A_084, n_A_083, n_A_082, n_A_1D, n_A_0N, n_A_0M,
         n_A_0W1, n_A_0W2, n_A_0W3, n_A_0W4, n_A_0W5, n_A_0W6, n_A_0W7,
         n_A_0W8, n_A_0W9, n_A_0W10, n_A_0W11, n_A_0W12, n_A_0W13, n_A_0W14,
         n_A_0W15, n_A_0W16, n_A_0W17, n_A_0W18, n_A_0W19, n_A_0W20, n_A_0X1,
         n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, n_A_0X7, n_A_0X8,
         n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, n_A_0X14, n_A_0X15,
         n_A_0X16, n_A_0X17, n_A_0X18, n_A_0X19, n_A_0X20, n_A_131, n_A_132,
         n_A_133, n_A_134, n_A_135, n_A_136, n_A_137, n_A_138, n_A_139,
         n_A_1310, n_A_1311, n_A_1312, n_A_1313, n_A_1314, n_A_1315, n_A_1316,
         n_A_1317, n_A_1318, n_A_1319, n_A_1320, n_A_121, n_A_122, n_A_123,
         n_A_124, n_A_125, n_A_126, n_A_127, n_A_128, n_A_129, n_A_1210,
         n_A_1211, n_A_1212, n_A_1213, n_A_1214, n_A_1215, n_A_1216, n_A_1217,
         n_A_1218, n_A_1219, n_A_1220, n_A_0D, n_A_0E, n_A_0A, n_A_0V, n_A_0C,
         n_A_0G, n_A_0K, n_A_01, n_A_0H, n_A_161, n_A_162, n_A_163, n_A_164,
         n_A_165, n_A_166, n_A_167, n_A_168, n_A_169, n_A_1610, n_A_1611,
         n_A_1612, n_A_1613, n_A_1614, n_A_1615, n_A_1616, n_A_1617, n_A_1618,
         n_A_1619, n_A_1620, n_A_171, n_A_172, n_A_173, n_A_174, n_A_175,
         n_A_176, n_A_177, n_A_178, n_A_179, n_A_1710, n_A_1711, n_A_1712,
         n_A_1713, n_A_1714, n_A_1715, n_A_1716, n_A_1717, n_A_1718, n_A_1719,
         n_A_1720, n_A_0P, n_A_10, n_A_0B, n_A_081, n_A_0Y, n_A_1B1, n_A_1B2,
         n_A_1B3, n_A_1B4, n_A_1B5, n_A_1B6, n_A_1B7, n_A_1B8, n_A_1B9,
         n_A_1B10, n_A_1B11, n_A_1B12, n_A_1B13, n_A_1B14, n_A_1B15, n_A_1B16,
         n_A_1B17, n_A_1B18, n_A_1B19, n_A_1B20, n_A_1C1, n_A_1C2, n_A_1C3,
         n_A_1C4, n_A_1C5, n_A_1C6, n_A_1C7, n_A_1C8, n_A_1C9, n_A_1C10,
         n_A_1C11, n_A_1C12, n_A_1C13, n_A_1C14, n_A_1C15, n_A_1C16, n_A_1C17,
         n_A_1C18, n_A_1C19, n_A_1C20, n_A_191, n_A_192, n_A_193, n_A_194,
         n_A_195, n_A_196, n_A_197, n_A_198, n_A_199, n_A_1910, n_A_1911,
         n_A_1912, n_A_1913, n_A_1914, n_A_1915, n_A_1916, n_A_1917, n_A_1918,
         n_A_1919, n_A_1920, n_A_1A1, n_A_1A2, n_A_1A3, n_A_1A4, n_A_1A5,
         n_A_1A6, n_A_1A7, n_A_1A8, n_A_1A9, n_A_1A10, n_A_1A11, n_A_1A12,
         n_A_1A13, n_A_1A14, n_A_1A15, n_A_1A16, n_A_1A17, n_A_1A18, n_A_1A19,
         n_A_1A20, n_A_141, n_A_142, n_A_143, n_A_144, n_A_145, n_A_146,
         n_A_147, n_A_148, n_A_149, n_A_1410, n_A_1411, n_A_1412, n_A_1413,
         n_A_1414, n_A_1415, n_A_1416, n_A_1417, n_A_1418, n_A_1419, n_A_1420,
         n_A_181, n_A_182, n_A_183, n_A_184, n_A_185, n_A_186, n_A_187,
         n_A_188, n_A_189, n_A_1810, n_A_1811, n_A_1812, n_A_1813, n_A_1814,
         n_A_1815, n_A_1816, n_A_1817, n_A_1818, n_A_1819, n_A_1820, n_A_06,
         n_A_0T, n_A_0J, n_A_0F, n_A_15;

  BUFX2 A000 ( .A(EDB[0]), .Y(n_A_0820) );
  BUFX2 A001 ( .A(EDB[1]), .Y(n_A_0819) );
  BUFX2 A002 ( .A(EDB[2]), .Y(n_A_0818) );
  BUFX2 A003 ( .A(EDB[3]), .Y(n_A_0817) );
  BUFX2 A004 ( .A(EDB[4]), .Y(n_A_0816) );
  BUFX2 A005 ( .A(EDB[5]), .Y(n_A_0815) );
  BUFX2 A006 ( .A(EDB[6]), .Y(n_A_0814) );
  BUFX2 A007 ( .A(EDB[7]), .Y(n_A_0813) );
  BUFX2 A008 ( .A(EDB[8]), .Y(n_A_0812) );
  BUFX2 A009 ( .A(EDB[9]), .Y(n_A_0811) );
  BUFX2 A010 ( .A(EDB[10]), .Y(n_A_0810) );
  BUFX2 A011 ( .A(EDB[11]), .Y(n_A_089) );
  BUFX2 A012 ( .A(EDB[12]), .Y(n_A_088) );
  BUFX2 A013 ( .A(EDB[13]), .Y(n_A_087) );
  BUFX2 A014 ( .A(EDB[14]), .Y(n_A_086) );
  BUFX2 A015 ( .A(EDB[15]), .Y(n_A_085) );
  BUFX2 A016 ( .A(EDB[16]), .Y(n_A_084) );
  BUFX2 A017 ( .A(EDB[17]), .Y(n_A_083) );
  BUFX2 A018 ( .A(EDB[18]), .Y(n_A_082) );
  INVX1 A11 ( .A(ERLE), .Y(n_A_1D) );
  DS204 A0A ( .A({n_A_0W1, n_A_0W2, n_A_0W3, n_A_0W4, n_A_0W5, n_A_0W6, 
        n_A_0W7, n_A_0W8, n_A_0W9, n_A_0W10, n_A_0W11, n_A_0W12, n_A_0W13, 
        n_A_0W14, n_A_0W15, n_A_0W16, n_A_0W17, n_A_0W18, n_A_0W19, n_A_0W20}), 
        .B({n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, n_A_0X7, 
        n_A_0X8, n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, n_A_0X14, 
        n_A_0X15, n_A_0X16, n_A_0X17, n_A_0X18, n_A_0X19, n_A_0X20}), .C({
        n_A_131, n_A_132, n_A_133, n_A_134, n_A_135, n_A_136, n_A_137, n_A_138, 
        n_A_139, n_A_1310, n_A_1311, n_A_1312, n_A_1313, n_A_1314, n_A_1315, 
        n_A_1316, n_A_1317, n_A_1318, n_A_1319, n_A_1320}), .D({n_A_121, 
        n_A_122, n_A_123, n_A_124, n_A_125, n_A_126, n_A_127, n_A_128, n_A_129, 
        n_A_1210, n_A_1211, n_A_1212, n_A_1213, n_A_1214, n_A_1215, n_A_1216, 
        n_A_1217, n_A_1218, n_A_1219, n_A_1220}), .S1(n_A_0M), .S0(n_A_0N), 
        .Y(ERO) );
  BUFX2 A0Y ( .A(ERS2), .Y(n_A_0M) );
  BUFX2 A0L ( .A(ERS1), .Y(n_A_0N) );
  BUFX2 A0F ( .A(ERLRS), .Y(n_A_0D) );
  DC08P A0B ( .EN(n_A_1D), .C(n_A_0M), .B(n_A_0N), .A(n_A_0D), .Y0(n_A_0E), 
        .Y1(n_A_0A), .Y2(n_A_0V), .Y3(n_A_0C), .Y4(n_A_0G), .Y5(n_A_0K), .Y6(
        n_A_01), .Y7(n_A_0H) );
  DS202 A0X ( .A({n_A_161, n_A_162, n_A_163, n_A_164, n_A_165, n_A_166, 
        n_A_167, n_A_168, n_A_169, n_A_1610, n_A_1611, n_A_1612, n_A_1613, 
        n_A_1614, n_A_1615, n_A_1616, n_A_1617, n_A_1618, n_A_1619, n_A_1620}), 
        .B({n_A_171, n_A_172, n_A_173, n_A_174, n_A_175, n_A_176, n_A_177, 
        n_A_178, n_A_179, n_A_1710, n_A_1711, n_A_1712, n_A_1713, n_A_1714, 
        n_A_1715, n_A_1716, n_A_1717, n_A_1718, n_A_1719, n_A_1720}), .S(
        n_A_0D), .Y({n_A_121, n_A_122, n_A_123, n_A_124, n_A_125, n_A_126, 
        n_A_127, n_A_128, n_A_129, n_A_1210, n_A_1211, n_A_1212, n_A_1213, 
        n_A_1214, n_A_1215, n_A_1216, n_A_1217, n_A_1218, n_A_1219, n_A_1220})
         );
  FE20R A0W ( .D({n_A_081, n_A_082, n_A_083, n_A_084, n_A_085, n_A_086, 
        n_A_087, n_A_088, n_A_089, n_A_0810, n_A_0811, n_A_0812, n_A_0813, 
        n_A_0814, n_A_0815, n_A_0816, n_A_0817, n_A_0818, n_A_0819, n_A_0820}), 
        .TI(n_A_10), .RN(n_A_0P), .TE(n_A_0B), .CK(MCK), .EN(n_A_0H), .Q({
        n_A_171, n_A_172, n_A_173, n_A_174, n_A_175, n_A_176, n_A_177, n_A_178, 
        n_A_179, n_A_1710, n_A_1711, n_A_1712, n_A_1713, n_A_1714, n_A_1715, 
        n_A_1716, n_A_1717, n_A_1718, n_A_1719, n_A_1720}), .TO(TO) );
  FE20R A0V ( .D({n_A_081, n_A_082, n_A_083, n_A_084, n_A_085, n_A_086, 
        n_A_087, n_A_088, n_A_089, n_A_0810, n_A_0811, n_A_0812, n_A_0813, 
        n_A_0814, n_A_0815, n_A_0816, n_A_0817, n_A_0818, n_A_0819, n_A_0820}), 
        .TI(n_A_0Y), .RN(n_A_0P), .TE(n_A_0B), .CK(MCK), .EN(n_A_01), .Q({
        n_A_161, n_A_162, n_A_163, n_A_164, n_A_165, n_A_166, n_A_167, n_A_168, 
        n_A_169, n_A_1610, n_A_1611, n_A_1612, n_A_1613, n_A_1614, n_A_1615, 
        n_A_1616, n_A_1617, n_A_1618, n_A_1619, n_A_1620}), .TO(n_A_10) );
  BUFX2 A019 ( .A(EDB[19]), .Y(n_A_081) );
  BUFX2 A0D ( .A(TE), .Y(n_A_0B) );
  BUFX2 A0C ( .A(XRST), .Y(n_A_0P) );
  DS202 A09 ( .A({n_A_1B1, n_A_1B2, n_A_1B3, n_A_1B4, n_A_1B5, n_A_1B6, 
        n_A_1B7, n_A_1B8, n_A_1B9, n_A_1B10, n_A_1B11, n_A_1B12, n_A_1B13, 
        n_A_1B14, n_A_1B15, n_A_1B16, n_A_1B17, n_A_1B18, n_A_1B19, n_A_1B20}), 
        .B({n_A_1C1, n_A_1C2, n_A_1C3, n_A_1C4, n_A_1C5, n_A_1C6, n_A_1C7, 
        n_A_1C8, n_A_1C9, n_A_1C10, n_A_1C11, n_A_1C12, n_A_1C13, n_A_1C14, 
        n_A_1C15, n_A_1C16, n_A_1C17, n_A_1C18, n_A_1C19, n_A_1C20}), .S(
        n_A_0D), .Y({n_A_131, n_A_132, n_A_133, n_A_134, n_A_135, n_A_136, 
        n_A_137, n_A_138, n_A_139, n_A_1310, n_A_1311, n_A_1312, n_A_1313, 
        n_A_1314, n_A_1315, n_A_1316, n_A_1317, n_A_1318, n_A_1319, n_A_1320})
         );
  DS202 A08 ( .A({n_A_191, n_A_192, n_A_193, n_A_194, n_A_195, n_A_196, 
        n_A_197, n_A_198, n_A_199, n_A_1910, n_A_1911, n_A_1912, n_A_1913, 
        n_A_1914, n_A_1915, n_A_1916, n_A_1917, n_A_1918, n_A_1919, n_A_1920}), 
        .B({n_A_1A1, n_A_1A2, n_A_1A3, n_A_1A4, n_A_1A5, n_A_1A6, n_A_1A7, 
        n_A_1A8, n_A_1A9, n_A_1A10, n_A_1A11, n_A_1A12, n_A_1A13, n_A_1A14, 
        n_A_1A15, n_A_1A16, n_A_1A17, n_A_1A18, n_A_1A19, n_A_1A20}), .S(
        n_A_0D), .Y({n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, 
        n_A_0X7, n_A_0X8, n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, 
        n_A_0X14, n_A_0X15, n_A_0X16, n_A_0X17, n_A_0X18, n_A_0X19, n_A_0X20})
         );
  DS202 A07 ( .A({n_A_141, n_A_142, n_A_143, n_A_144, n_A_145, n_A_146, 
        n_A_147, n_A_148, n_A_149, n_A_1410, n_A_1411, n_A_1412, n_A_1413, 
        n_A_1414, n_A_1415, n_A_1416, n_A_1417, n_A_1418, n_A_1419, n_A_1420}), 
        .B({n_A_181, n_A_182, n_A_183, n_A_184, n_A_185, n_A_186, n_A_187, 
        n_A_188, n_A_189, n_A_1810, n_A_1811, n_A_1812, n_A_1813, n_A_1814, 
        n_A_1815, n_A_1816, n_A_1817, n_A_1818, n_A_1819, n_A_1820}), .S(
        n_A_0D), .Y({n_A_0W1, n_A_0W2, n_A_0W3, n_A_0W4, n_A_0W5, n_A_0W6, 
        n_A_0W7, n_A_0W8, n_A_0W9, n_A_0W10, n_A_0W11, n_A_0W12, n_A_0W13, 
        n_A_0W14, n_A_0W15, n_A_0W16, n_A_0W17, n_A_0W18, n_A_0W19, n_A_0W20})
         );
  FE20R A06 ( .D({n_A_081, n_A_082, n_A_083, n_A_084, n_A_085, n_A_086, 
        n_A_087, n_A_088, n_A_089, n_A_0810, n_A_0811, n_A_0812, n_A_0813, 
        n_A_0814, n_A_0815, n_A_0816, n_A_0817, n_A_0818, n_A_0819, n_A_0820}), 
        .TI(n_A_06), .RN(n_A_0P), .TE(n_A_0B), .CK(MCK), .EN(n_A_0K), .Q({
        n_A_1C1, n_A_1C2, n_A_1C3, n_A_1C4, n_A_1C5, n_A_1C6, n_A_1C7, n_A_1C8, 
        n_A_1C9, n_A_1C10, n_A_1C11, n_A_1C12, n_A_1C13, n_A_1C14, n_A_1C15, 
        n_A_1C16, n_A_1C17, n_A_1C18, n_A_1C19, n_A_1C20}), .TO(n_A_0Y) );
  FE20R A05 ( .D({n_A_081, n_A_082, n_A_083, n_A_084, n_A_085, n_A_086, 
        n_A_087, n_A_088, n_A_089, n_A_0810, n_A_0811, n_A_0812, n_A_0813, 
        n_A_0814, n_A_0815, n_A_0816, n_A_0817, n_A_0818, n_A_0819, n_A_0820}), 
        .TI(n_A_0T), .RN(n_A_0P), .TE(n_A_0B), .CK(MCK), .EN(n_A_0G), .Q({
        n_A_1B1, n_A_1B2, n_A_1B3, n_A_1B4, n_A_1B5, n_A_1B6, n_A_1B7, n_A_1B8, 
        n_A_1B9, n_A_1B10, n_A_1B11, n_A_1B12, n_A_1B13, n_A_1B14, n_A_1B15, 
        n_A_1B16, n_A_1B17, n_A_1B18, n_A_1B19, n_A_1B20}), .TO(n_A_06) );
  FE20R A04 ( .D({n_A_081, n_A_082, n_A_083, n_A_084, n_A_085, n_A_086, 
        n_A_087, n_A_088, n_A_089, n_A_0810, n_A_0811, n_A_0812, n_A_0813, 
        n_A_0814, n_A_0815, n_A_0816, n_A_0817, n_A_0818, n_A_0819, n_A_0820}), 
        .TI(n_A_0J), .RN(n_A_0P), .TE(n_A_0B), .CK(MCK), .EN(n_A_0C), .Q({
        n_A_1A1, n_A_1A2, n_A_1A3, n_A_1A4, n_A_1A5, n_A_1A6, n_A_1A7, n_A_1A8, 
        n_A_1A9, n_A_1A10, n_A_1A11, n_A_1A12, n_A_1A13, n_A_1A14, n_A_1A15, 
        n_A_1A16, n_A_1A17, n_A_1A18, n_A_1A19, n_A_1A20}), .TO(n_A_0T) );
  FE20R A03 ( .D({n_A_081, n_A_082, n_A_083, n_A_084, n_A_085, n_A_086, 
        n_A_087, n_A_088, n_A_089, n_A_0810, n_A_0811, n_A_0812, n_A_0813, 
        n_A_0814, n_A_0815, n_A_0816, n_A_0817, n_A_0818, n_A_0819, n_A_0820}), 
        .TI(n_A_0F), .RN(n_A_0P), .TE(n_A_0B), .CK(MCK), .EN(n_A_0V), .Q({
        n_A_191, n_A_192, n_A_193, n_A_194, n_A_195, n_A_196, n_A_197, n_A_198, 
        n_A_199, n_A_1910, n_A_1911, n_A_1912, n_A_1913, n_A_1914, n_A_1915, 
        n_A_1916, n_A_1917, n_A_1918, n_A_1919, n_A_1920}), .TO(n_A_0J) );
  FE20R A02 ( .D({n_A_081, n_A_082, n_A_083, n_A_084, n_A_085, n_A_086, 
        n_A_087, n_A_088, n_A_089, n_A_0810, n_A_0811, n_A_0812, n_A_0813, 
        n_A_0814, n_A_0815, n_A_0816, n_A_0817, n_A_0818, n_A_0819, n_A_0820}), 
        .TI(n_A_15), .RN(n_A_0P), .TE(n_A_0B), .CK(MCK), .EN(n_A_0A), .Q({
        n_A_181, n_A_182, n_A_183, n_A_184, n_A_185, n_A_186, n_A_187, n_A_188, 
        n_A_189, n_A_1810, n_A_1811, n_A_1812, n_A_1813, n_A_1814, n_A_1815, 
        n_A_1816, n_A_1817, n_A_1818, n_A_1819, n_A_1820}), .TO(n_A_0F) );
  FE20R A01 ( .D({n_A_081, n_A_082, n_A_083, n_A_084, n_A_085, n_A_086, 
        n_A_087, n_A_088, n_A_089, n_A_0810, n_A_0811, n_A_0812, n_A_0813, 
        n_A_0814, n_A_0815, n_A_0816, n_A_0817, n_A_0818, n_A_0819, n_A_0820}), 
        .TI(TI), .RN(n_A_0P), .TE(n_A_0B), .CK(MCK), .EN(n_A_0E), .Q({n_A_141, 
        n_A_142, n_A_143, n_A_144, n_A_145, n_A_146, n_A_147, n_A_148, n_A_149, 
        n_A_1410, n_A_1411, n_A_1412, n_A_1413, n_A_1414, n_A_1415, n_A_1416, 
        n_A_1417, n_A_1418, n_A_1419, n_A_1420}), .TO(n_A_15) );
endmodule


module DC08P ( EN, C, B, A, Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7 );
  input EN, C, B, A;
  output Y0, Y1, Y2, Y3, Y4, Y5, Y6, Y7;
  wire   n_A_0B, n_A_0D, n_A_09, n_A_0F, n_A_0E, n_A_0C, n_A_0A;

  AND4X1 A08 ( .A(n_A_0D), .B(n_A_0B), .C(n_A_09), .D(n_A_0F), .Y(Y7) );
  AND4X1 A07 ( .A(n_A_0E), .B(n_A_0B), .C(n_A_09), .D(n_A_0F), .Y(Y6) );
  AND4X1 A06 ( .A(n_A_0D), .B(n_A_0C), .C(n_A_09), .D(n_A_0F), .Y(Y5) );
  AND4X1 A05 ( .A(n_A_0E), .B(n_A_0C), .C(n_A_09), .D(n_A_0F), .Y(Y4) );
  AND4X1 A04 ( .A(n_A_0D), .B(n_A_0B), .C(n_A_0A), .D(n_A_0F), .Y(Y3) );
  AND4X1 A03 ( .A(n_A_0E), .B(n_A_0B), .C(n_A_0A), .D(n_A_0F), .Y(Y2) );
  AND4X1 A02 ( .A(n_A_0D), .B(n_A_0C), .C(n_A_0A), .D(n_A_0F), .Y(Y1) );
  AND4X1 A01 ( .A(n_A_0E), .B(n_A_0C), .C(n_A_0A), .D(n_A_0F), .Y(Y0) );
  INVX1 A0B ( .A(n_A_0D), .Y(n_A_0E) );
  INVX1 A0D ( .A(n_A_0B), .Y(n_A_0C) );
  INVX1 A0F ( .A(n_A_09), .Y(n_A_0A) );
  INVX2 A09 ( .A(EN), .Y(n_A_0F) );
  BUFX2 A0E ( .A(A), .Y(n_A_0D) );
  BUFX2 A0C ( .A(B), .Y(n_A_0B) );
  BUFX2 A0A ( .A(C), .Y(n_A_09) );
endmodule


module ESOPU ( EDB, EPSFT2, DTLE, EPBSD4, EYLE, MCK, TI, TE, EXHEN, DTEN, 
        EXEXEN, EXLE, EPBSU, XRST, LFACLLE, EROALE, EPOEN, SFTEN, SAWPHEN, 
        ABSEN, REPHEN, ESLMTEN, EBLE, EALE, EAIVEN, INC16, EPAEN, ESPO, EROMA, 
        LFACD, TO );
  input [19:0] EDB;
  output [19:0] ESPO;
  output [8:0] EROMA;
  output [3:0] LFACD;
  input EPSFT2, DTLE, EPBSD4, EYLE, MCK, TI, TE, EXHEN, DTEN, EXEXEN, EXLE,
         EPBSU, XRST, LFACLLE, EROALE, EPOEN, SFTEN, SAWPHEN, ABSEN, REPHEN,
         ESLMTEN, EBLE, EALE, EAIVEN, INC16, EPAEN;
  output TO;
  wire   n_SFB0, n_SFB1, n_A_1B, n_TE1, n_TO1, n_RN, n_PO09, n_PO08, n_PO07,
         n_PO06, n_PO05, n_PO04, n_PO03, n_DT6, n_DT5, n_DT4, n_DT3, n_DT2,
         n_DT1, n_DT0, n_DT7, n_A_0F, n_SFB2, n_A_041, n_A_042, n_A_043,
         n_A_1L1, n_A_1L2, n_A_1L3, n_A_1A1, n_A_1A2, n_A_1A3, n_A_1A4,
         n_A_1A5, n_A_1A6, n_A_1A7, n_A_1A8, n_A_1A9, n_A_1A10, n_A_1A11,
         n_A_1A12, n_A_1A13, n_A_1A14, n_A_1A15, n_A_1A16, n_A_1A17, n_A_1A18,
         n_A_1A19, n_A_1A20, n_A_081, n_A_082, n_A_083, n_A_084, n_A_085,
         n_A_086, n_A_087, n_A_088, n_A_089, n_A_0810, n_A_0811, n_A_0812,
         n_A_0813, n_A_0814, n_A_0815, n_A_0816, n_A_0817, n_A_0818, n_A_0819,
         n_A_0820, n_EPO19, n_EPO18, n_EPO17, n_EPO16, n_EPO15, n_EPO14,
         n_EPO13, n_EPO12, n_EPO11, n_EPO10, n_EPO09, n_EPO08, n_EPO07,
         n_EPO06, n_EPO05, n_EPO04, n_EPO03, n_EPO02, n_EPO01, n_EPO00, n_PO21,
         n_A_1D1, n_A_1D2, n_A_1D3, n_A_1D4, n_A_1D5, n_A_1D6, n_A_1D7,
         n_A_1D8, n_A_1D9, n_A_1D10, n_A_1D11, n_A_1D12, n_A_1D13, n_A_1D14,
         n_A_1D15, n_A_1D16, n_A_1D17, n_A_1D18, n_A_1D19, n_A_1D20, n_A_181,
         n_A_182, n_A_183, n_A_184, n_A_185, n_A_186, n_A_187, n_A_188, n_PO20,
         n_PO19, n_PO18, n_PO17, n_PO16, n_PO15, n_PO14, n_PO13, n_PO12,
         n_PO11, n_PO10, n_PO02, n_PO01, n_PO00, n_A_0Y, n_A_151, n_A_152,
         n_A_153, n_A_154, n_A_155, n_A_156, n_A_157, n_A_158, n_A_171,
         n_A_172, n_A_173, n_A_174, n_A_175, n_A_176, n_A_177, n_A_178, n_A_1K,
         n_A_1J1, n_A_1J2, n_A_1J3, n_A_191, n_A_192, n_A_193, n_A_194,
         n_A_195, n_A_196, n_A_197, n_A_198, n_AC05, n_AC06, n_AC07, n_AC08,
         n_AC09, n_AC10, n_AC11, n_AC12, n_AC13, n_AC14, n_AC15, n_AC16,
         n_AC17, n_AC18, n_AC00, n_AC01, n_AC02, n_AC03, n_AC19, n_AC04,
         n_B_1B, n_B_1D1, n_B_1D2, n_B_1D3, n_B_1D4, n_B_1C, n_SO03, n_SO02,
         n_SO01, n_SO00, n_B_16, n_SO18, n_SO17, n_SO16, n_SO15, n_SO14,
         n_SO13, n_SO12, n_SO11, n_SO10, n_SO19, n_SO09, n_SO08, n_SO07,
         n_SO06, n_SO05, n_SO04, n_B_151, n_B_152, n_B_153, n_B_154, n_B_155,
         n_B_156, n_B_157, n_B_158, n_B_159, n_B_1510, n_B_1511, n_B_1512,
         n_B_1513, n_B_1514, n_B_1515, n_B_1516, n_B_1517, n_B_1518, n_B_1519,
         n_B_1520, n_EAI19, n_EBI19, n_ESA19, n_B_0W, n_B_0V, n_B_0U, n_B_0A,
         n_B_111, n_B_112, n_B_113, n_B_114, n_B_115, n_B_116, n_B_117,
         n_B_118, n_B_119, n_B_1110, n_B_1111, n_B_1112, n_B_1113, n_B_1114,
         n_B_1115, n_B_1116, n_B_1117, n_B_1118, n_B_1119, n_B_1120, n_B_101,
         n_B_102, n_B_103, n_B_104, n_B_105, n_B_106, n_B_107, n_B_108,
         n_B_109, n_B_1010, n_B_1011, n_B_1012, n_B_1013, n_B_1014, n_B_1015,
         n_B_1016, n_B_1017, n_B_1018, n_B_1019, n_B_1020, n_ESA18, n_ESA17,
         n_ESA16, n_ESA15, n_ESA14, n_ESA13, n_ESA12, n_ESA11, n_ESA10,
         n_ESA09, n_ESA08, n_ESA07, n_ESA06, n_ESA05, n_ESA04, n_ESA03,
         n_ESA02, n_ESA01, n_ESA00, n_EBI18, n_EBI17, n_EBI16, n_EBI15,
         n_EBI14, n_EBI13, n_EBI12, n_EBI11, n_EBI10, n_EBI09, n_EBI08,
         n_EBI07, n_EBI06, n_EBI05, n_EBI04, n_EBI03, n_EBI02, n_EBI01,
         n_EBI00, n_EAI18, n_EAI17, n_EAI16, n_EAI15, n_EAI14, n_EAI13,
         n_EAI12, n_EAI11, n_EAI10, n_EAI09, n_EAI08, n_EAI07, n_EAI06,
         n_EAI05, n_EAI04, n_EAI03, n_EAI02, n_EAI01, n_EAI00;

  TIEHI A0H0 ( .Y(n_SFB0) );
  TIEHI A0H1 ( .Y(n_SFB1) );
  FS075 A09 ( .D({n_PO09, n_PO08, n_PO07, n_PO06, n_PO05, n_PO04, n_PO03}), 
        .CK(MCK), .EN(DTLE), .TI(n_A_1B), .TE(n_TE1), .RN(n_RN), .Q({n_DT6, 
        n_DT5, n_DT4, n_DT3, n_DT2, n_DT1, n_DT0}), .TO(n_TO1) );
  TIELO A0M ( .Y(n_DT7) );
  BUFX2 A1M ( .A(EXLE), .Y(n_A_0F) );
  TIELO A0S ( .Y(n_SFB2) );
  DS032 A0G ( .A({n_A_041, n_A_042, n_A_043}), .B({n_SFB2, n_SFB1, n_SFB0}), 
        .S(EPBSD4), .Y({n_A_1L1, n_A_1L2, n_A_1L3}) );
  DS202 A08 ( .A({n_A_1A1, n_A_1A2, n_A_1A3, n_A_1A4, n_A_1A5, n_A_1A6, 
        n_A_1A7, n_A_1A8, n_A_1A9, n_A_1A10, n_A_1A11, n_A_1A12, n_A_1A13, 
        n_A_1A14, n_A_1A15, n_A_1A16, n_A_1A17, n_A_1A18, n_A_1A19, n_A_1A20}), 
        .B({n_A_081, n_A_082, n_A_083, n_A_084, n_A_085, n_A_086, n_A_087, 
        n_A_088, n_A_089, n_A_0810, n_A_0811, n_A_0812, n_A_0813, n_A_0814, 
        n_A_0815, n_A_0816, n_A_0817, n_A_0818, n_A_0819, n_A_0820}), .S(EPBSU), .Y({n_EPO19, n_EPO18, n_EPO17, n_EPO16, n_EPO15, n_EPO14, n_EPO13, n_EPO12, 
        n_EPO11, n_EPO10, n_EPO09, n_EPO08, n_EPO07, n_EPO06, n_EPO05, n_EPO04, 
        n_EPO03, n_EPO02, n_EPO01, n_EPO00}) );
  MLT03 A01 ( .A({n_A_1D1, n_A_1D2, n_A_1D3, n_A_1D4, n_A_1D5, n_A_1D6, 
        n_A_1D7, n_A_1D8, n_A_1D9, n_A_1D10, n_A_1D11, n_A_1D12, n_A_1D13, 
        n_A_1D14, n_A_1D15, n_A_1D16, n_A_1D17, n_A_1D18, n_A_1D19, n_A_1D20}), 
        .B({n_A_181, n_A_182, n_A_183, n_A_184, n_A_185, n_A_186, n_A_187, 
        n_A_188}), .P({n_PO20, n_PO19, n_PO18, n_PO17, n_PO16, n_PO15, n_PO14, 
        n_PO13, n_PO12, n_PO11, n_PO10, n_PO09, n_PO08, n_PO07, n_PO06, n_PO05, 
        n_PO04, n_PO03, n_PO02, n_PO01, n_PO00}), .P23(n_PO21) );
  FE20R A02 ( .D(EDB), .TI(TI), .RN(n_RN), .TE(n_TE1), .CK(MCK), .EN(EYLE), 
        .Q({n_A_1D1, n_A_1D2, n_A_1D3, n_A_1D4, n_A_1D5, n_A_1D6, n_A_1D7, 
        n_A_1D8, n_A_1D9, n_A_1D10, n_A_1D11, n_A_1D12, n_A_1D13, n_A_1D14, 
        n_A_1D15, n_A_1D16, n_A_1D17, n_A_1D18, n_A_1D19, n_A_1D20}), .TO(
        n_A_0Y) );
  BUFX2 A10 ( .A(XRST), .Y(n_RN) );
  BUFX2 A0Y ( .A(TE), .Y(n_TE1) );
  BA08 A05 ( .D({n_A_151, n_A_152, n_A_153, n_A_154, n_A_155, n_A_156, n_A_157, 
        n_A_158}), .EN(EXEXEN), .Y({n_A_171, n_A_172, n_A_173, n_A_174, 
        n_A_175, n_A_176, n_A_177, n_A_178}), .SF({n_A_041, n_A_042, n_A_043})
         );
  FE03S A0A ( .D({n_A_1L1, n_A_1L2, n_A_1L3}), .SN(n_RN), .TE(n_TE1), .CK(MCK), 
        .EN(n_A_0F), .TI(n_A_1K), .Q({n_A_1J1, n_A_1J2, n_A_1J3}), .TO(n_A_1B)
         );
  BS20U2 A0C ( .D({n_PO21, n_PO20, n_PO19, n_PO18, n_PO17, n_PO16, n_PO15, 
        n_PO14, n_PO13, n_PO12, n_PO11, n_PO10, n_PO09, n_PO08, n_PO07, n_PO06, 
        n_PO05, n_PO04, n_PO03, n_PO02, n_PO01, n_PO00}), .SFT2(EPSFT2), .Y({
        n_A_081, n_A_082, n_A_083, n_A_084, n_A_085, n_A_086, n_A_087, n_A_088, 
        n_A_089, n_A_0810, n_A_0811, n_A_0812, n_A_0813, n_A_0814, n_A_0815, 
        n_A_0816, n_A_0817, n_A_0818, n_A_0819, n_A_0820}) );
  BS203 A0B ( .SFT({n_A_1J1, n_A_1J2, n_A_1J3}), .D({n_PO21, n_PO20, n_PO19, 
        n_PO18, n_PO17, n_PO16, n_PO15, n_PO14, n_PO13, n_PO12, n_PO11, n_PO10, 
        n_PO09, n_PO08, n_PO07, n_PO06, n_PO05, n_PO04, n_PO03, n_PO02}), .Y({
        n_A_1A1, n_A_1A2, n_A_1A3, n_A_1A4, n_A_1A5, n_A_1A6, n_A_1A7, n_A_1A8, 
        n_A_1A9, n_A_1A10, n_A_1A11, n_A_1A12, n_A_1A13, n_A_1A14, n_A_1A15, 
        n_A_1A16, n_A_1A17, n_A_1A18, n_A_1A19, n_A_1A20}) );
  DS083 A07 ( .A(EDB[11:4]), .B(EDB[19:12]), .C({n_DT7, n_DT6, n_DT5, n_DT4, 
        n_DT3, n_DT2, n_DT1, n_DT0}), .S1(DTEN), .S0(EXHEN), .Y({n_A_151, 
        n_A_152, n_A_153, n_A_154, n_A_155, n_A_156, n_A_157, n_A_158}) );
  DS082 A06 ( .B({n_A_171, n_A_172, n_A_173, n_A_174, n_A_175, n_A_176, 
        n_A_177, n_A_178}), .A({n_A_151, n_A_152, n_A_153, n_A_154, n_A_155, 
        n_A_156, n_A_157, n_A_158}), .S(EXEXEN), .Y({n_A_191, n_A_192, n_A_193, 
        n_A_194, n_A_195, n_A_196, n_A_197, n_A_198}) );
  FE08R A04 ( .D({n_A_191, n_A_192, n_A_193, n_A_194, n_A_195, n_A_196, 
        n_A_197, n_A_198}), .TI(n_A_0Y), .EN(n_A_0F), .CK(MCK), .TE(n_TE1), 
        .RN(n_RN), .Q({n_A_181, n_A_182, n_A_183, n_A_184, n_A_185, n_A_186, 
        n_A_187, n_A_188}), .TO(n_A_1K) );
  TIELO B000 ( .Y(n_AC05) );
  TIELO B001 ( .Y(n_AC06) );
  TIELO B002 ( .Y(n_AC07) );
  TIELO B003 ( .Y(n_AC08) );
  TIELO B004 ( .Y(n_AC09) );
  TIELO B005 ( .Y(n_AC10) );
  TIELO B006 ( .Y(n_AC11) );
  TIELO B007 ( .Y(n_AC12) );
  TIELO B008 ( .Y(n_AC13) );
  TIELO B009 ( .Y(n_AC14) );
  TIELO B010 ( .Y(n_AC15) );
  TIELO B011 ( .Y(n_AC16) );
  TIELO B012 ( .Y(n_AC17) );
  TIELO B013 ( .Y(n_AC18) );
  TIELO B100 ( .Y(n_AC00) );
  TIELO B101 ( .Y(n_AC01) );
  TIELO B102 ( .Y(n_AC02) );
  TIELO B103 ( .Y(n_AC03) );
  TIELO B014 ( .Y(n_AC19) );
  TIEHI B0G ( .Y(n_AC04) );
  FE04R B1B ( .D({n_B_1D1, n_B_1D2, n_B_1D3, n_B_1D4}), .CK(MCK), .RN(n_RN), 
        .TE(n_TE1), .EN(LFACLLE), .TI(n_B_1B), .Q(LFACD), .TO(TO) );
  FE04R B1A ( .D({n_SO03, n_SO02, n_SO01, n_SO00}), .CK(MCK), .RN(n_RN), .TE(
        n_TE1), .EN(LFACLLE), .TI(n_B_1C), .Q({n_B_1D1, n_B_1D2, n_B_1D3, 
        n_B_1D4}), .TO(n_B_1B) );
  FE09R B16 ( .D({n_SO18, n_SO17, n_SO16, n_SO15, n_SO14, n_SO13, n_SO12, 
        n_SO11, n_SO10}), .TI(n_B_16), .RN(n_RN), .TE(n_TE1), .CK(MCK), .EN(
        EROALE), .Q(EROMA), .TO(n_B_1C) );
  DS202 B14 ( .A({n_SO19, n_SO18, n_SO17, n_SO16, n_SO15, n_SO14, n_SO13, 
        n_SO12, n_SO11, n_SO10, n_SO09, n_SO08, n_SO07, n_SO06, n_SO05, n_SO04, 
        n_SO03, n_SO02, n_SO01, n_SO00}), .B({n_EPO19, n_EPO18, n_EPO17, 
        n_EPO16, n_EPO15, n_EPO14, n_EPO13, n_EPO12, n_EPO11, n_EPO10, n_EPO09, 
        n_EPO08, n_EPO07, n_EPO06, n_EPO05, n_EPO04, n_EPO03, n_EPO02, n_EPO01, 
        n_EPO00}), .S(EPOEN), .Y(ESPO) );
  FG20 B07 ( .A({n_B_151, n_B_152, n_B_153, n_B_154, n_B_155, n_B_156, n_B_157, 
        n_B_158, n_B_159, n_B_1510, n_B_1511, n_B_1512, n_B_1513, n_B_1514, 
        n_B_1515, n_B_1516, n_B_1517, n_B_1518, n_B_1519, n_B_1520}), .SFT(
        SFTEN), .SAWPH(SAWPHEN), .RECPH(REPHEN), .ABS(ABSEN), .Y({n_SO19, 
        n_SO18, n_SO17, n_SO16, n_SO15, n_SO14, n_SO13, n_SO12, n_SO11, n_SO10, 
        n_SO09, n_SO08, n_SO07, n_SO06, n_SO05, n_SO04, n_SO03, n_SO02, n_SO01, 
        n_SO00}) );
  LMCNT B08 ( .C(n_ESA19), .B(n_EBI19), .A(n_EAI19), .EN(ESLMTEN), .SG(n_B_0W), 
        .S(n_B_0V) );
  FE21R B02 ( .D({n_B_111, n_B_112, n_B_113, n_B_114, n_B_115, n_B_116, 
        n_B_117, n_B_118, n_B_119, n_B_1110, n_B_1111, n_B_1112, n_B_1113, 
        n_B_1114, n_B_1115, n_B_1116, n_B_1117, n_B_1118, n_B_1119, n_B_1120}), 
        .D20(EAIVEN), .TI(n_TO1), .RN(n_RN), .TE(n_TE1), .CK(MCK), .EN(EALE), 
        .Q({n_B_101, n_B_102, n_B_103, n_B_104, n_B_105, n_B_106, n_B_107, 
        n_B_108, n_B_109, n_B_1010, n_B_1011, n_B_1012, n_B_1013, n_B_1014, 
        n_B_1015, n_B_1016, n_B_1017, n_B_1018, n_B_1019, n_B_1020}), .Q20(
        n_B_0U), .TO(n_B_0A) );
  LM20 B06 ( .A({n_ESA19, n_ESA18, n_ESA17, n_ESA16, n_ESA15, n_ESA14, n_ESA13, 
        n_ESA12, n_ESA11, n_ESA10, n_ESA09, n_ESA08, n_ESA07, n_ESA06, n_ESA05, 
        n_ESA04, n_ESA03, n_ESA02, n_ESA01, n_ESA00}), .S(n_B_0V), .SG(n_B_0W), 
        .Y({n_B_151, n_B_152, n_B_153, n_B_154, n_B_155, n_B_156, n_B_157, 
        n_B_158, n_B_159, n_B_1510, n_B_1511, n_B_1512, n_B_1513, n_B_1514, 
        n_B_1515, n_B_1516, n_B_1517, n_B_1518, n_B_1519, n_B_1520}) );
  FE20R B05 ( .D(EDB), .TI(n_B_0A), .RN(n_RN), .TE(n_TE1), .CK(MCK), .EN(EBLE), 
        .Q({n_EBI19, n_EBI18, n_EBI17, n_EBI16, n_EBI15, n_EBI14, n_EBI13, 
        n_EBI12, n_EBI11, n_EBI10, n_EBI09, n_EBI08, n_EBI07, n_EBI06, n_EBI05, 
        n_EBI04, n_EBI03, n_EBI02, n_EBI01, n_EBI00}), .TO(n_B_16) );
  ADD20C B04 ( .A({n_EAI19, n_EAI18, n_EAI17, n_EAI16, n_EAI15, n_EAI14, 
        n_EAI13, n_EAI12, n_EAI11, n_EAI10, n_EAI09, n_EAI08, n_EAI07, n_EAI06, 
        n_EAI05, n_EAI04, n_EAI03, n_EAI02, n_EAI01, n_EAI00}), .B({n_EBI19, 
        n_EBI18, n_EBI17, n_EBI16, n_EBI15, n_EBI14, n_EBI13, n_EBI12, n_EBI11, 
        n_EBI10, n_EBI09, n_EBI08, n_EBI07, n_EBI06, n_EBI05, n_EBI04, n_EBI03, 
        n_EBI02, n_EBI01, n_EBI00}), .CI(n_B_0U), .S({n_ESA19, n_ESA18, 
        n_ESA17, n_ESA16, n_ESA15, n_ESA14, n_ESA13, n_ESA12, n_ESA11, n_ESA10, 
        n_ESA09, n_ESA08, n_ESA07, n_ESA06, n_ESA05, n_ESA04, n_ESA03, n_ESA02, 
        n_ESA01, n_ESA00}) );
  INV20 B03 ( .A({n_B_101, n_B_102, n_B_103, n_B_104, n_B_105, n_B_106, 
        n_B_107, n_B_108, n_B_109, n_B_1010, n_B_1011, n_B_1012, n_B_1013, 
        n_B_1014, n_B_1015, n_B_1016, n_B_1017, n_B_1018, n_B_1019, n_B_1020}), 
        .INV(n_B_0U), .Y({n_EAI19, n_EAI18, n_EAI17, n_EAI16, n_EAI15, n_EAI14, 
        n_EAI13, n_EAI12, n_EAI11, n_EAI10, n_EAI09, n_EAI08, n_EAI07, n_EAI06, 
        n_EAI05, n_EAI04, n_EAI03, n_EAI02, n_EAI01, n_EAI00}) );
  DS203 B01 ( .B({n_EPO19, n_EPO18, n_EPO17, n_EPO16, n_EPO15, n_EPO14, 
        n_EPO13, n_EPO12, n_EPO11, n_EPO10, n_EPO09, n_EPO08, n_EPO07, n_EPO06, 
        n_EPO05, n_EPO04, n_EPO03, n_EPO02, n_EPO01, n_EPO00}), .A(EDB), .C({
        n_AC19, n_AC18, n_AC17, n_AC16, n_AC15, n_AC14, n_AC13, n_AC12, n_AC11, 
        n_AC10, n_AC09, n_AC08, n_AC07, n_AC06, n_AC05, n_AC04, n_AC03, n_AC02, 
        n_AC01, n_AC00}), .S2(INC16), .S1(EPAEN), .Y({n_B_111, n_B_112, 
        n_B_113, n_B_114, n_B_115, n_B_116, n_B_117, n_B_118, n_B_119, 
        n_B_1110, n_B_1111, n_B_1112, n_B_1113, n_B_1114, n_B_1115, n_B_1116, 
        n_B_1117, n_B_1118, n_B_1119, n_B_1120}) );
endmodule


module FG20 ( A, SFT, SAWPH, RECPH, ABS, Y );
  input [19:0] A;
  output [19:0] Y;
  input SFT, SAWPH, RECPH, ABS;
  wire   n_RA00, n_A_0U, n_RA01, n_RA02, n_RA03, n_RA04, n_RA05, n_RA06,
         n_RA07, n_RA08, n_RA09, n_RA10, n_RA11, n_RA12, n_RA13, n_RA14,
         n_RA15, n_RA16, n_RA17, n_SA00, n_SA01, n_SA02, n_SA03, n_SA04,
         n_SA05, n_SA06, n_SA07, n_SA08, n_SA09, n_SA10, n_SA11, n_SA12,
         n_SA13, n_SA14, n_SA15, n_SA16, n_SA18, n_SA19, n_SA17, n_RA19,
         n_RA18, n_A_08, n_A_0A, n_A_09, n_A_0T, n_A_0S, n_A_0D, n_A_0C,
         n_A_0E;

  XOR2X1 A000 ( .A(A[0]), .B(n_A_0U), .Y(n_RA00) );
  XOR2X1 A001 ( .A(A[1]), .B(n_A_0U), .Y(n_RA01) );
  XOR2X1 A002 ( .A(A[2]), .B(n_A_0U), .Y(n_RA02) );
  XOR2X1 A003 ( .A(A[3]), .B(n_A_0U), .Y(n_RA03) );
  XOR2X1 A004 ( .A(A[4]), .B(n_A_0U), .Y(n_RA04) );
  XOR2X1 A005 ( .A(A[5]), .B(n_A_0U), .Y(n_RA05) );
  XOR2X1 A006 ( .A(A[6]), .B(n_A_0U), .Y(n_RA06) );
  XOR2X1 A007 ( .A(A[7]), .B(n_A_0U), .Y(n_RA07) );
  XOR2X1 A008 ( .A(A[8]), .B(n_A_0U), .Y(n_RA08) );
  XOR2X1 A009 ( .A(A[9]), .B(n_A_0U), .Y(n_RA09) );
  XOR2X1 A010 ( .A(A[10]), .B(n_A_0U), .Y(n_RA10) );
  XOR2X1 A011 ( .A(A[11]), .B(n_A_0U), .Y(n_RA11) );
  XOR2X1 A012 ( .A(A[12]), .B(n_A_0U), .Y(n_RA12) );
  XOR2X1 A013 ( .A(A[13]), .B(n_A_0U), .Y(n_RA13) );
  XOR2X1 A014 ( .A(A[14]), .B(n_A_0U), .Y(n_RA14) );
  XOR2X1 A015 ( .A(A[15]), .B(n_A_0U), .Y(n_RA15) );
  XOR2X1 A016 ( .A(A[16]), .B(n_A_0U), .Y(n_RA16) );
  XOR2X1 A017 ( .A(A[17]), .B(n_A_0U), .Y(n_RA17) );
  BUFX2 A100 ( .A(A[1]), .Y(n_SA00) );
  BUFX2 A101 ( .A(A[2]), .Y(n_SA01) );
  BUFX2 A102 ( .A(A[3]), .Y(n_SA02) );
  BUFX2 A103 ( .A(A[4]), .Y(n_SA03) );
  BUFX2 A104 ( .A(A[5]), .Y(n_SA04) );
  BUFX2 A105 ( .A(A[6]), .Y(n_SA05) );
  BUFX2 A106 ( .A(A[7]), .Y(n_SA06) );
  BUFX2 A107 ( .A(A[8]), .Y(n_SA07) );
  BUFX2 A108 ( .A(A[9]), .Y(n_SA08) );
  BUFX2 A109 ( .A(A[10]), .Y(n_SA09) );
  BUFX2 A110 ( .A(A[11]), .Y(n_SA10) );
  BUFX2 A111 ( .A(A[12]), .Y(n_SA11) );
  BUFX2 A112 ( .A(A[13]), .Y(n_SA12) );
  BUFX2 A113 ( .A(A[14]), .Y(n_SA13) );
  BUFX2 A114 ( .A(A[15]), .Y(n_SA14) );
  BUFX2 A115 ( .A(A[16]), .Y(n_SA15) );
  BUFX2 A116 ( .A(A[17]), .Y(n_SA16) );
  XOR2X1 A0M ( .A(A[19]), .B(SAWPH), .Y(n_SA18) );
  TIELO A0T ( .Y(n_SA19) );
  BUFX2 A117 ( .A(A[18]), .Y(n_SA17) );
  DS202 A0K ( .A({n_RA19, n_RA18, n_RA17, n_RA16, n_RA15, n_RA14, n_RA13, 
        n_RA12, n_RA11, n_RA10, n_RA09, n_RA08, n_RA07, n_RA06, n_RA05, n_RA04, 
        n_RA03, n_RA02, n_RA01, n_RA00}), .B({n_SA19, n_SA18, n_SA17, n_SA16, 
        n_SA15, n_SA14, n_SA13, n_SA12, n_SA11, n_SA10, n_SA09, n_SA08, n_SA07, 
        n_SA06, n_SA05, n_SA04, n_SA03, n_SA02, n_SA01, n_SA00}), .S(SFT), .Y(
        Y) );
  NOR2X1 A20B ( .A(n_A_0A), .B(n_A_09), .Y(n_A_08) );
  AND3X1 A20A ( .A(n_A_0T), .B(n_A_0S), .C(n_A_0D), .Y(n_A_09) );
  AND3X1 A209 ( .A(n_A_0C), .B(n_A_0E), .C(n_A_0T), .Y(n_A_0A) );
  BUFX2 A208 ( .A(RECPH), .Y(n_A_0D) );
  BUFX2 A207 ( .A(ABS), .Y(n_A_0T) );
  INVX3 A206 ( .A(n_A_08), .Y(n_A_0U) );
  INVX1 A205 ( .A(n_A_0D), .Y(n_A_0E) );
  INVX1 A204 ( .A(n_A_0S), .Y(n_A_0C) );
  INVX1 A203 ( .A(A[19]), .Y(n_A_0S) );
  NOR2X2 A202 ( .A(n_A_0S), .B(n_A_0T), .Y(n_RA19) );
  XOR2X1 A018 ( .A(A[18]), .B(n_A_0U), .Y(n_RA18) );
endmodule


module FE09R ( D, TI, RN, TE, CK, EN, Q, TO );
  input [8:0] D;
  output [8:0] Q;
  input TI, RN, TE, CK, EN;
  output TO;
  wire   n_A_10, n_A_0W, n_A_0P;

  BUFX2 A02 ( .A(RN), .Y(n_A_10) );
  BUFX2 A04 ( .A(TE), .Y(n_A_0W) );
  BUFX2 A05 ( .A(EN), .Y(n_A_0P) );
  BUFX2 A03 ( .A(Q[8]), .Y(TO) );
  FE1R A0M ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[7]), .CK(CK), .EN(n_A_0P), .D(
        D[8]), .Q(Q[8]) );
  FE1R A0L ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[6]), .CK(CK), .EN(n_A_0P), .D(
        D[7]), .Q(Q[7]) );
  FE1R A0K ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[5]), .CK(CK), .EN(n_A_0P), .D(
        D[6]), .Q(Q[6]) );
  FE1R A0J ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[4]), .CK(CK), .EN(n_A_0P), .D(
        D[5]), .Q(Q[5]) );
  FE1R A0H ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[3]), .CK(CK), .EN(n_A_0P), .D(
        D[4]), .Q(Q[4]) );
  FE1R A0G ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[2]), .CK(CK), .EN(n_A_0P), .D(
        D[3]), .Q(Q[3]) );
  FE1R A0F ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[1]), .CK(CK), .EN(n_A_0P), .D(
        D[2]), .Q(Q[2]) );
  FE1R A0E ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[0]), .CK(CK), .EN(n_A_0P), .D(
        D[1]), .Q(Q[1]) );
  FE1R A0D ( .RN(n_A_10), .TE(n_A_0W), .TI(TI), .CK(CK), .EN(n_A_0P), .D(D[0]), 
        .Q(Q[0]) );
endmodule


module DS083 ( A, B, C, S1, S0, Y );
  input [7:0] A;
  input [7:0] B;
  input [7:0] C;
  output [7:0] Y;
  input S1, S0;
  wire   n_A_09, n_A_0B8, n_A_0B7, n_A_0B6, n_A_0B5, n_A_0B4, n_A_0B3, n_A_0B2,
         n_A_07, n_A_0B1;

  MX2X1 A010 ( .S0(n_A_09), .B(B[0]), .A(A[0]), .Y(n_A_0B8) );
  MX2X1 A011 ( .S0(n_A_09), .B(B[1]), .A(A[1]), .Y(n_A_0B7) );
  MX2X1 A012 ( .S0(n_A_09), .B(B[2]), .A(A[2]), .Y(n_A_0B6) );
  MX2X1 A013 ( .S0(n_A_09), .B(B[3]), .A(A[3]), .Y(n_A_0B5) );
  MX2X1 A014 ( .S0(n_A_09), .B(B[4]), .A(A[4]), .Y(n_A_0B4) );
  MX2X1 A015 ( .S0(n_A_09), .B(B[5]), .A(A[5]), .Y(n_A_0B3) );
  MX2X1 A016 ( .S0(n_A_09), .B(B[6]), .A(A[6]), .Y(n_A_0B2) );
  MX2X1 A020 ( .S0(n_A_07), .B(C[0]), .A(n_A_0B8), .Y(Y[0]) );
  MX2X1 A021 ( .S0(n_A_07), .B(C[1]), .A(n_A_0B7), .Y(Y[1]) );
  MX2X1 A022 ( .S0(n_A_07), .B(C[2]), .A(n_A_0B6), .Y(Y[2]) );
  MX2X1 A023 ( .S0(n_A_07), .B(C[3]), .A(n_A_0B5), .Y(Y[3]) );
  MX2X1 A024 ( .S0(n_A_07), .B(C[4]), .A(n_A_0B4), .Y(Y[4]) );
  MX2X1 A025 ( .S0(n_A_07), .B(C[5]), .A(n_A_0B3), .Y(Y[5]) );
  MX2X1 A026 ( .S0(n_A_07), .B(C[6]), .A(n_A_0B2), .Y(Y[6]) );
  BUFX2 A06 ( .A(S0), .Y(n_A_09) );
  BUFX2 A05 ( .A(S1), .Y(n_A_07) );
  MX2X1 A027 ( .S0(n_A_07), .B(C[7]), .A(n_A_0B1), .Y(Y[7]) );
  MX2X1 A017 ( .S0(n_A_09), .B(B[7]), .A(A[7]), .Y(n_A_0B1) );
endmodule


module BS203 ( SFT, D, Y );
  input [2:0] SFT;
  input [19:0] D;
  output [19:0] Y;
  wire   n_A_1F, n_A_1H, n_A_1G, n_A_21, n_A_2P, n_A_1L, n_A_24, n_A_1K,
         n_A_23, n_A_1J, n_A_22, n_A_2A, n_A_26, n_A_27, n_A_2S, n_A_2R,
         n_A_1R, n_A_1P, n_A_1N, n_A_1M, n_A_25, n_A_1V, n_A_1U, n_A_1T,
         n_A_1S, n_A_20, n_A_1Y, n_A_1X, n_A_1W, n_A_2C, n_A_29, n_A_2B,
         n_A_28, n_A_2G, n_A_2E, n_A_2F, n_A_2D, n_A_2L, n_A_2J, n_A_2K,
         n_A_2H, n_A_2N, n_A_2M;

  BUFX2 A19 ( .A(SFT[2]), .Y(n_A_1F) );
  BUFX2 A18 ( .A(SFT[1]), .Y(n_A_1H) );
  BUFX2 A17 ( .A(SFT[0]), .Y(n_A_1G) );
  BUFX2 A0J ( .A(n_A_21), .Y(Y[19]) );
  BUFX2 A0H ( .A(n_A_2P), .Y(n_A_21) );
  BUFX2 A0G ( .A(D[19]), .Y(n_A_2P) );
  DS32 A0F ( .S(n_A_1F), .B2(n_A_22), .A2(n_A_1J), .B1(n_A_23), .A1(n_A_1K), 
        .B0(n_A_24), .A0(n_A_1L), .Y2(Y[0]), .Y1(Y[1]), .Y0(Y[2]) );
  DS32 A0E ( .S(n_A_1H), .B2(n_A_2R), .A2(n_A_26), .B1(n_A_2S), .A1(n_A_27), 
        .B0(n_A_26), .A0(n_A_2A), .Y2(n_A_22), .Y1(n_A_23), .Y0(n_A_24) );
  DS32 A0D ( .S(n_A_1G), .B2(D[0]), .A2(D[1]), .B1(D[1]), .A1(D[2]), .B0(D[2]), 
        .A0(D[3]), .Y2(n_A_2R), .Y1(n_A_2S), .Y0(n_A_26) );
  DS42 A0C ( .S(n_A_1F), .B3(n_A_25), .A3(n_A_1M), .B2(n_A_1J), .A2(n_A_1N), 
        .B1(n_A_1K), .A1(n_A_1P), .B0(n_A_1L), .A0(n_A_1R), .Y3(Y[3]), .Y2(
        Y[4]), .Y1(Y[5]), .Y0(Y[6]) );
  DS42 A0B ( .S(n_A_1F), .B3(n_A_1M), .A3(n_A_1S), .B2(n_A_1N), .A2(n_A_1T), 
        .B1(n_A_1P), .A1(n_A_1U), .B0(n_A_1R), .A0(n_A_1V), .Y3(Y[7]), .Y2(
        Y[8]), .Y1(Y[9]), .Y0(Y[10]) );
  DS42 A0A ( .S(n_A_1F), .B3(n_A_1S), .A3(n_A_1W), .B2(n_A_1T), .A2(n_A_1X), 
        .B1(n_A_1U), .A1(n_A_1Y), .B0(n_A_1V), .A0(n_A_20), .Y3(Y[11]), .Y2(
        Y[12]), .Y1(Y[13]), .Y0(Y[14]) );
  DS42 A09 ( .S(n_A_1F), .B3(n_A_1W), .A3(n_A_21), .B2(n_A_1X), .A2(n_A_21), 
        .B1(n_A_1Y), .A1(n_A_21), .B0(n_A_20), .A0(n_A_21), .Y3(Y[15]), .Y2(
        Y[16]), .Y1(Y[17]), .Y0(Y[18]) );
  DS42 A08 ( .S(n_A_1H), .B3(n_A_27), .A3(n_A_28), .B2(n_A_2A), .A2(n_A_29), 
        .B1(n_A_28), .A1(n_A_2B), .B0(n_A_29), .A0(n_A_2C), .Y3(n_A_25), .Y2(
        n_A_1J), .Y1(n_A_1K), .Y0(n_A_1L) );
  DS42 A07 ( .S(n_A_1H), .B3(n_A_2B), .A3(n_A_2D), .B2(n_A_2C), .A2(n_A_2E), 
        .B1(n_A_2D), .A1(n_A_2F), .B0(n_A_2E), .A0(n_A_2G), .Y3(n_A_1M), .Y2(
        n_A_1N), .Y1(n_A_1P), .Y0(n_A_1R) );
  DS42 A06 ( .S(n_A_1H), .B3(n_A_2F), .A3(n_A_2H), .B2(n_A_2G), .A2(n_A_2J), 
        .B1(n_A_2H), .A1(n_A_2K), .B0(n_A_2J), .A0(n_A_2L), .Y3(n_A_1S), .Y2(
        n_A_1T), .Y1(n_A_1U), .Y0(n_A_1V) );
  DS42 A05 ( .S(n_A_1H), .B3(n_A_2K), .A3(n_A_2M), .B2(n_A_2L), .A2(n_A_2N), 
        .B1(n_A_2M), .A1(n_A_2P), .B0(n_A_2N), .A0(n_A_2P), .Y3(n_A_1W), .Y2(
        n_A_1X), .Y1(n_A_1Y), .Y0(n_A_20) );
  DS42 A04 ( .S(n_A_1G), .B3(D[3]), .A3(D[4]), .B2(D[4]), .A2(D[5]), .B1(D[5]), 
        .A1(D[6]), .B0(D[6]), .A0(D[7]), .Y3(n_A_27), .Y2(n_A_2A), .Y1(n_A_28), 
        .Y0(n_A_29) );
  DS42 A03 ( .S(n_A_1G), .B3(D[7]), .A3(D[8]), .B2(D[8]), .A2(D[9]), .B1(D[9]), 
        .A1(D[10]), .B0(D[10]), .A0(D[11]), .Y3(n_A_2B), .Y2(n_A_2C), .Y1(
        n_A_2D), .Y0(n_A_2E) );
  DS42 A02 ( .S(n_A_1G), .B3(D[11]), .A3(D[12]), .B2(D[12]), .A2(D[13]), .B1(
        D[13]), .A1(D[14]), .B0(D[14]), .A0(D[15]), .Y3(n_A_2F), .Y2(n_A_2G), 
        .Y1(n_A_2H), .Y0(n_A_2J) );
  DS42 A01 ( .S(n_A_1G), .B3(D[15]), .A3(D[16]), .B2(D[16]), .A2(D[17]), .B1(
        D[17]), .A1(D[18]), .B0(D[18]), .A0(D[19]), .Y3(n_A_2K), .Y2(n_A_2L), 
        .Y1(n_A_2M), .Y0(n_A_2N) );
endmodule


module BS20U2 ( D, SFT2, Y );
  input [21:0] D;
  output [19:0] Y;
  input SFT2;
  wire   n_A_1G, n_A_1J, n_A_24, n_A_2B, n_A_2A, n_A_29, n_A_2F, n_A_2E,
         n_A_2D, n_A_2C, n_A_2K, n_A_2J, n_A_2H, n_A_2G, n_A_2N, n_A_2M,
         n_A_2L, n_A_1H, n_A_2T, n_A_2S, n_A_2R, n_A_2P, n_A_1F, n_A_26,
         n_A_25, n_A_27;

  AND2X1 A2J ( .A(n_A_1G), .B(n_A_1J), .Y(n_A_24) );
  BUFX2 A2G ( .A(SFT2), .Y(n_A_1J) );
  DS32 A1V ( .S(n_A_1J), .B2(D[0]), .A2(D[1]), .B1(D[1]), .A1(D[2]), .B0(D[2]), 
        .A0(D[3]), .Y2(n_A_29), .Y1(n_A_2A), .Y0(n_A_2B) );
  DS42 A1U ( .S(n_A_1J), .B3(D[3]), .A3(D[4]), .B2(D[4]), .A2(D[5]), .B1(D[5]), 
        .A1(D[6]), .B0(D[6]), .A0(D[7]), .Y3(n_A_2C), .Y2(n_A_2D), .Y1(n_A_2E), 
        .Y0(n_A_2F) );
  DS42 A1T ( .S(n_A_1J), .B3(D[7]), .A3(D[8]), .B2(D[8]), .A2(D[9]), .B1(D[9]), 
        .A1(D[10]), .B0(D[10]), .A0(D[11]), .Y3(n_A_2G), .Y2(n_A_2H), .Y1(
        n_A_2J), .Y0(n_A_2K) );
  DS42 A1S ( .S(n_A_1J), .B3(D[11]), .A3(D[12]), .B2(D[12]), .A2(D[13]), .B1(
        D[13]), .A1(D[14]), .B0(D[14]), .A0(D[15]), .Y3(n_A_1H), .Y2(n_A_2L), 
        .Y1(n_A_2M), .Y0(n_A_2N) );
  DS42 A1R ( .S(n_A_1J), .B3(D[15]), .A3(D[16]), .B2(D[16]), .A2(D[17]), .B1(
        D[17]), .A1(D[18]), .B0(D[18]), .A0(D[19]), .Y3(n_A_2P), .Y2(n_A_2R), 
        .Y1(n_A_2S), .Y0(n_A_2T) );
  INVX4 A0X ( .A(n_A_1F), .Y(n_A_26) );
  OR2X2 A11 ( .A(n_A_25), .B(n_A_24), .Y(n_A_27) );
  XOR2X1 A10 ( .A(n_A_1F), .B(D[19]), .Y(n_A_1G) );
  XOR2X1 A0Y ( .A(n_A_1F), .B(D[20]), .Y(n_A_25) );
  BUFX2 A0W ( .A(n_A_1F), .Y(Y[19]) );
  BUFX2 A0V ( .A(D[21]), .Y(n_A_1F) );
  DS32 A05 ( .S(n_A_27), .B2(n_A_26), .A2(n_A_29), .B1(n_A_26), .A1(n_A_2A), 
        .B0(n_A_26), .A0(n_A_2B), .Y2(Y[0]), .Y1(Y[1]), .Y0(Y[2]) );
  DS42 A04 ( .S(n_A_27), .B3(n_A_26), .A3(n_A_2C), .B2(n_A_26), .A2(n_A_2D), 
        .B1(n_A_26), .A1(n_A_2E), .B0(n_A_26), .A0(n_A_2F), .Y3(Y[3]), .Y2(
        Y[4]), .Y1(Y[5]), .Y0(Y[6]) );
  DS42 A03 ( .S(n_A_27), .B3(n_A_26), .A3(n_A_2G), .B2(n_A_26), .A2(n_A_2H), 
        .B1(n_A_26), .A1(n_A_2J), .B0(n_A_26), .A0(n_A_2K), .Y3(Y[7]), .Y2(
        Y[8]), .Y1(Y[9]), .Y0(Y[10]) );
  DS42 A02 ( .S(n_A_27), .B3(n_A_26), .A3(n_A_1H), .B2(n_A_26), .A2(n_A_2L), 
        .B1(n_A_26), .A1(n_A_2M), .B0(n_A_26), .A0(n_A_2N), .Y3(Y[11]), .Y2(
        Y[12]), .Y1(Y[13]), .Y0(Y[14]) );
  DS42 A01 ( .S(n_A_27), .B3(n_A_26), .A3(n_A_2P), .B2(n_A_26), .A2(n_A_2R), 
        .B1(n_A_26), .A1(n_A_2S), .B0(n_A_26), .A0(n_A_2T), .Y3(Y[15]), .Y2(
        Y[16]), .Y1(Y[17]), .Y0(Y[18]) );
endmodule


module FE03S ( D, SN, TE, CK, EN, TI, Q, TO );
  input [2:0] D;
  output [2:0] Q;
  input SN, TE, CK, EN, TI;
  output TO;
  wire   n_A_0H, n_A_0J;

  BUFX2 A0G ( .A(EN), .Y(n_A_0H) );
  BUFX2 A0E ( .A(TE), .Y(n_A_0J) );
  BUFX2 A0D ( .A(Q[2]), .Y(TO) );
  FE1S A03 ( .TI(Q[1]), .CK(CK), .TE(n_A_0J), .EN(n_A_0H), .D(D[2]), .SN(SN), 
        .Q(Q[2]) );
  FE1S A02 ( .TI(Q[0]), .CK(CK), .TE(n_A_0J), .EN(n_A_0H), .D(D[1]), .SN(SN), 
        .Q(Q[1]) );
  FE1S A01 ( .TI(TI), .CK(CK), .TE(n_A_0J), .EN(n_A_0H), .D(D[0]), .SN(SN), 
        .Q(Q[0]) );
endmodule


module BA08 ( D, EN, Y, SF );
  input [7:0] D;
  output [7:0] Y;
  output [2:0] SF;
  input EN;
  wire   n_A_0P;

  INVX1 A09 ( .A(EN), .Y(n_A_0P) );
  OR2X1 A04 ( .A(D[4]), .B(n_A_0P), .Y(SF[0]) );
  OR2X1 A03 ( .A(D[5]), .B(n_A_0P), .Y(SF[1]) );
  OR2X1 A02 ( .A(D[6]), .B(n_A_0P), .Y(SF[2]) );
  TIELO A0Y ( .Y(Y[0]) );
  TIELO A0X ( .Y(Y[1]) );
  TIELO A0W ( .Y(Y[2]) );
  BUFX2 A08 ( .A(D[0]), .Y(Y[3]) );
  BUFX2 A07 ( .A(D[1]), .Y(Y[4]) );
  BUFX2 A06 ( .A(D[2]), .Y(Y[5]) );
  BUFX2 A05 ( .A(D[3]), .Y(Y[6]) );
  BUFX2 A01 ( .A(D[7]), .Y(Y[7]) );
endmodule


module MLT03 ( A, B, P, P00, P22, P23 );
  input [19:0] A;
  input [7:0] B;
  output [21:1] P;
  output P00, P22, P23;
  wire   n_AN00, n_AN01, n_AN02, n_AN03, n_AN04, n_AN05, n_AN06, n_AN07,
         n_AN08, n_AN09, n_AN10, n_AN11, n_AN12, n_AN13, n_AN14, n_AN15,
         n_AN16, n_AN17, n_AN18, n_BN0, n_BN1, n_BN2, n_BN3, n_BN4, n_BN5,
         n_BN6, n_P305, n_P207, n_P109, n_P011, n_B11C2, n_B11C1, n_A_30,
         n_P304, n_P206, n_P108, n_P010, n_A_1S, n_A_1T, n_A_31, n_P303,
         n_P205, n_P107, n_P009, n_A_2U, n_A_2M, n_A_32, n_P302, n_P204,
         n_P106, n_P008, n_A_2X, n_A_2Y, n_A_37, n_P301, n_P203, n_P105,
         n_P007, n_A_34, n_A_35, n_A_39, n_P202, n_P104, n_P006, n_A_1B,
         n_A_25, n_A_36, n_A_3B, n_P101, n_P003, n_A_3X, n_A_3Y, n_BC03,
         n_A_3V, n_P100, n_P002, n_A_3R, n_A_41, n_AN19, n_P120, n_P119,
         n_P118, n_P117, n_P116, n_P115, n_P114, n_P113, n_P112, n_P111,
         n_P110, n_P103, n_P102, n_A_3U, n_P220, n_P219, n_P218, n_P217,
         n_P216, n_P215, n_P214, n_P213, n_P212, n_P211, n_P210, n_P209,
         n_P208, n_P201, n_P200, n_BN7, n_P320, n_P319, n_P318, n_P317, n_P316,
         n_P315, n_P314, n_P313, n_P312, n_P311, n_P310, n_P309, n_P308,
         n_P307, n_P306, n_P300, n_P020, n_P019, n_P018, n_P017, n_P016,
         n_P015, n_P014, n_P013, n_P012, n_P005, n_P004, n_P001, n_P000,
         n_A_2N, n_BS10, n_BC10, n_BS11, n_BC11, n_BS09, n_BC09, n_BS08,
         n_BC08, n_BS07, n_BC07, n_A_38, n_BS06, n_BC06, n_A_3W, n_A_3A,
         n_BS05, n_BC05, n_A_3J, n_BS04, n_BC04, n_B_0W, n_B_0V, n_B_1V,
         n_B20C1, n_B_0Y, n_B20C2, n_B_0X, n_B_1S, n_B_1U, n_B_1T, n_B_1R,
         n_B_1M, n_B_1N, n_B_1P, n_B_1L, n_B_27, n_B_14, n_BS20, n_BC20,
         n_BS19, n_BC19, n_BS18, n_BC18, n_BS17, n_BC17, n_B_29, n_B_2A,
         n_BS16, n_BC16, n_B_2N, n_B_2M, n_B_2T, n_BS15, n_BC15, n_B_2K,
         n_B_2L, n_B_2U, n_BS14, n_BC14, n_B_2J, n_B_2H, n_B_2V, n_BS13,
         n_BC13, n_B_2W, n_BS12, n_BC12, n_C_24, n_C_1A, n_BS22, n_BC22,
         n_C_31, n_C_30, n_C_2A, n_C_28, n_BS25, n_BC25, n_C_0U, n_C_0N,
         n_C_0Y, n_C_0R, n_BS23, n_BC23, n_C_18, n_C_0S, n_BS24, n_BC24,
         n_BS27, n_BS26, n_BS21, n_BC26, n_BC21;

  INVX2 A100 ( .A(A[0]), .Y(n_AN00) );
  INVX2 A101 ( .A(A[1]), .Y(n_AN01) );
  INVX2 A102 ( .A(A[2]), .Y(n_AN02) );
  INVX2 A103 ( .A(A[3]), .Y(n_AN03) );
  INVX2 A104 ( .A(A[4]), .Y(n_AN04) );
  INVX2 A105 ( .A(A[5]), .Y(n_AN05) );
  INVX2 A106 ( .A(A[6]), .Y(n_AN06) );
  INVX2 A107 ( .A(A[7]), .Y(n_AN07) );
  INVX2 A108 ( .A(A[8]), .Y(n_AN08) );
  INVX2 A109 ( .A(A[9]), .Y(n_AN09) );
  INVX2 A110 ( .A(A[10]), .Y(n_AN10) );
  INVX2 A111 ( .A(A[11]), .Y(n_AN11) );
  INVX2 A112 ( .A(A[12]), .Y(n_AN12) );
  INVX2 A113 ( .A(A[13]), .Y(n_AN13) );
  INVX2 A114 ( .A(A[14]), .Y(n_AN14) );
  INVX2 A115 ( .A(A[15]), .Y(n_AN15) );
  INVX2 A116 ( .A(A[16]), .Y(n_AN16) );
  INVX2 A117 ( .A(A[17]), .Y(n_AN17) );
  INVX2 A118 ( .A(A[18]), .Y(n_AN18) );
  INVX2 A200 ( .A(B[0]), .Y(n_BN0) );
  INVX2 A201 ( .A(B[1]), .Y(n_BN1) );
  INVX2 A202 ( .A(B[2]), .Y(n_BN2) );
  INVX2 A203 ( .A(B[3]), .Y(n_BN3) );
  INVX2 A204 ( .A(B[4]), .Y(n_BN4) );
  INVX2 A205 ( .A(B[5]), .Y(n_BN5) );
  INVX2 A206 ( .A(B[6]), .Y(n_BN6) );
  QA1 A01D ( .A(n_P305), .B(n_P207), .C(n_P109), .D(n_P011), .CO1(n_B11C2), 
        .S(n_A_30), .CO2(n_B11C1) );
  QA1 A01C ( .A(n_P304), .B(n_P206), .C(n_P108), .D(n_P010), .CO1(n_A_1S), .S(
        n_A_31), .CO2(n_A_1T) );
  QA1 A00V ( .A(n_P303), .B(n_P205), .C(n_P107), .D(n_P009), .CO1(n_A_2U), .S(
        n_A_32), .CO2(n_A_2M) );
  QA1 A019 ( .A(n_P302), .B(n_P204), .C(n_P106), .D(n_P008), .CO1(n_A_2X), .S(
        n_A_37), .CO2(n_A_2Y) );
  QA1 A00T ( .A(n_P301), .B(n_P203), .C(n_P105), .D(n_P007), .CO1(n_A_34), .S(
        n_A_39), .CO2(n_A_35) );
  QA1 A014 ( .A(n_P202), .B(n_P104), .C(n_P006), .D(n_A_1B), .CO1(n_A_25), .S(
        n_A_3B), .CO2(n_A_36) );
  QA1 A010 ( .A(n_P101), .B(n_P003), .C(n_A_3X), .D(n_A_3Y), .CO1(n_BC03), 
        .CO2(n_A_3V) );
  QA1 A00Y ( .A(n_P100), .B(n_P002), .C(n_A_3R), .D(n_A_41), .CO1(n_A_3X), 
        .CO2(n_A_3Y) );
  PP20 A002 ( .AN({n_AN19, n_AN18, n_AN17, n_AN16, n_AN15, n_AN14, n_AN13, 
        n_AN12, n_AN11, n_AN10, n_AN09, n_AN08, n_AN07, n_AN06, n_AN05, n_AN04, 
        n_AN03, n_AN02, n_AN01, n_AN00}), .B1N(n_BN3), .B0N(n_BN2), .B_1N(
        n_BN1), .PP({n_P120, n_P119, n_P118, n_P117, n_P116, n_P115, n_P114, 
        n_P113, n_P112, n_P111, n_P110, n_P109, n_P108, n_P107, n_P106, n_P105, 
        n_P104, n_P103, n_P102, n_P101, n_P100}), .AD1(n_A_3R) );
  PP20 A003 ( .AN({n_AN19, n_AN18, n_AN17, n_AN16, n_AN15, n_AN14, n_AN13, 
        n_AN12, n_AN11, n_AN10, n_AN09, n_AN08, n_AN07, n_AN06, n_AN05, n_AN04, 
        n_AN03, n_AN02, n_AN01, n_AN00}), .B1N(n_BN5), .B0N(n_BN4), .B_1N(
        n_BN3), .PP({n_P220, n_P219, n_P218, n_P217, n_P216, n_P215, n_P214, 
        n_P213, n_P212, n_P211, n_P210, n_P209, n_P208, n_P207, n_P206, n_P205, 
        n_P204, n_P203, n_P202, n_P201, n_P200}), .AD1(n_A_3U) );
  PP20 A004 ( .AN({n_AN19, n_AN18, n_AN17, n_AN16, n_AN15, n_AN14, n_AN13, 
        n_AN12, n_AN11, n_AN10, n_AN09, n_AN08, n_AN07, n_AN06, n_AN05, n_AN04, 
        n_AN03, n_AN02, n_AN01, n_AN00}), .B1N(n_BN7), .B0N(n_BN6), .B_1N(
        n_BN5), .PP({n_P320, n_P319, n_P318, n_P317, n_P316, n_P315, n_P314, 
        n_P313, n_P312, n_P311, n_P310, n_P309, n_P308, n_P307, n_P306, n_P305, 
        n_P304, n_P303, n_P302, n_P301, n_P300}), .AD1(n_A_1B) );
  PP20LS A001 ( .AN({n_AN19, n_AN18, n_AN17, n_AN16, n_AN15, n_AN14, n_AN13, 
        n_AN12, n_AN11, n_AN10, n_AN09, n_AN08, n_AN07, n_AN06, n_AN05, n_AN04, 
        n_AN03, n_AN02, n_AN01, n_AN00}), .B1N(n_BN1), .B0N(n_BN0), .PP({
        n_P020, n_P019, n_P018, n_P017, n_P016, n_P015, n_P014, n_P013, n_P012, 
        n_P011, n_P010, n_P009, n_P008, n_P007, n_P006, n_P005, n_P004, n_P003, 
        n_P002, n_P001, n_P000}) );
  INVX1 A01J ( .A(n_BN1), .Y(n_A_2N) );
  AND3X1 A01G ( .A(n_P001), .B(n_P000), .C(n_A_2N), .Y(n_A_41) );
  ADDFHX1 A01F ( .A(n_A_31), .B(n_A_2U), .CI(n_A_2M), .S(n_BS10), .CO(n_BC10)
         );
  ADDFHX1 A01E ( .A(n_A_30), .B(n_A_1S), .CI(n_A_1T), .S(n_BS11), .CO(n_BC11)
         );
  ADDFHX1 A01A ( .A(n_A_32), .B(n_A_2X), .CI(n_A_2Y), .S(n_BS09), .CO(n_BC09)
         );
  ADDFHX1 A018 ( .A(n_A_37), .B(n_A_34), .CI(n_A_35), .S(n_BS08), .CO(n_BC08)
         );
  ADDFHX1 A017 ( .A(n_A_39), .B(n_A_36), .CI(n_A_25), .S(n_BS07), .CO(n_BC07)
         );
  ADDFHX1 A015 ( .A(n_P300), .B(n_A_38), .CI(n_A_3B), .S(n_BS06), .CO(n_BC06)
         );
  ADDFHX1 A013 ( .A(n_P201), .B(n_A_3W), .CI(n_A_3A), .S(n_BS05), .CO(n_BC05)
         );
  ADDFHX1 A012 ( .A(n_P200), .B(n_P102), .CI(n_A_3J), .S(n_BS04), .CO(n_BC04)
         );
  ADDFHX1 A011 ( .A(n_P004), .B(n_A_3U), .CI(n_A_3V), .S(n_A_3J), .CO(n_A_3A)
         );
  ADDHX1 A00R ( .A(n_P103), .B(n_P005), .S(n_A_3W), .CO(n_A_38) );
  INVX2 A207 ( .A(B[7]), .Y(n_BN7) );
  INVX2 A119 ( .A(A[19]), .Y(n_AN19) );
  ADDFHX1 B24 ( .A(n_P020), .B(n_B_0W), .CI(n_B_0V), .S(n_B_1V), .CO(n_B20C1)
         );
  TIEHI B1R ( .Y(n_B_0W) );
  ADDFHX1 B28 ( .A(n_P314), .B(n_P216), .CI(n_P118), .S(n_B_0Y), .CO(n_B20C2)
         );
  QA1 B20 ( .A(n_P313), .B(n_P215), .C(n_P117), .D(n_P019), .CO1(n_B_0X), .S(
        n_B_1S), .CO2(n_B_0V) );
  QA1 B1X ( .A(n_P312), .B(n_P214), .C(n_P116), .D(n_P018), .CO1(n_B_1U), .S(
        n_B_1R), .CO2(n_B_1T) );
  QA1 B1W ( .A(n_P311), .B(n_P213), .C(n_P115), .D(n_P017), .CO1(n_B_1M), .S(
        n_B_1P), .CO2(n_B_1N) );
  QA1 B05 ( .A(n_P310), .B(n_P212), .C(n_P114), .D(n_P016), .CO1(n_B_1L), .S(
        n_B_14), .CO2(n_B_27) );
  ADDFHX1 B0F ( .A(n_B_0Y), .B(n_B_0X), .CI(n_B_1V), .S(n_BS20), .CO(n_BC20)
         );
  ADDFHX1 B0E ( .A(n_B_1T), .B(n_B_1U), .CI(n_B_1S), .S(n_BS19), .CO(n_BC19)
         );
  ADDFHX1 B0D ( .A(n_B_1N), .B(n_B_1M), .CI(n_B_1R), .S(n_BS18), .CO(n_BC18)
         );
  ADDFHX1 B0C ( .A(n_B_27), .B(n_B_1L), .CI(n_B_1P), .S(n_BS17), .CO(n_BC17)
         );
  ADDFHX1 B0B ( .A(n_B_29), .B(n_B_2A), .CI(n_B_14), .S(n_BS16), .CO(n_BC16)
         );
  ADDFHX1 B0A ( .A(n_B_2N), .B(n_B_2M), .CI(n_B_2T), .S(n_BS15), .CO(n_BC15)
         );
  ADDFHX1 B09 ( .A(n_B_2K), .B(n_B_2L), .CI(n_B_2U), .S(n_BS14), .CO(n_BC14)
         );
  ADDFHX1 B08 ( .A(n_B_2J), .B(n_B_2H), .CI(n_B_2V), .S(n_BS13), .CO(n_BC13)
         );
  ADDFHX1 B07 ( .A(n_B11C1), .B(n_B11C2), .CI(n_B_2W), .S(n_BS12), .CO(n_BC12)
         );
  QA1 B04 ( .A(n_P309), .B(n_P211), .C(n_P113), .D(n_P015), .CO1(n_B_2A), .S(
        n_B_2T), .CO2(n_B_29) );
  QA1 B03 ( .A(n_P308), .B(n_P210), .C(n_P112), .D(n_P014), .CO1(n_B_2M), .S(
        n_B_2U), .CO2(n_B_2N) );
  QA1 B02 ( .A(n_P307), .B(n_P209), .C(n_P111), .D(n_P013), .CO1(n_B_2L), .S(
        n_B_2V), .CO2(n_B_2K) );
  QA1 B01 ( .A(n_P306), .B(n_P208), .C(n_P110), .D(n_P012), .CO1(n_B_2H), .S(
        n_B_2W), .CO2(n_B_2J) );
  ADDHX1 C0F ( .A(n_C_24), .B(n_C_1A), .S(n_BS22), .CO(n_BC22) );
  ADDFHX1 C0C ( .A(n_P315), .B(n_P217), .CI(n_C_31), .S(n_C_30), .CO(n_C_24)
         );
  ADDHX1 C0J ( .A(n_C_2A), .B(n_C_28), .S(n_BS25), .CO(n_BC25) );
  ADDFHX1 C30 ( .A(n_P318), .B(n_P220), .CI(n_P219), .S(n_C_0U), .CO(n_C_28)
         );
  ADDFHX1 C0G ( .A(n_C_0N), .B(n_C_0Y), .CI(n_C_0R), .S(n_BS23), .CO(n_BC23)
         );
  ADDHX1 C37 ( .A(n_P317), .B(n_C_18), .S(n_C_0N), .CO(n_C_0S) );
  QA1 C0E ( .A(n_P120), .B(n_P218), .C(n_P119), .D(n_P316), .CO1(n_C_0Y), .S(
        n_C_1A), .CO2(n_C_0R) );
  ADDHX1 C0H ( .A(n_C_0U), .B(n_C_0S), .S(n_BS24), .CO(n_BC24) );
  INVX1 C24 ( .A(n_P219), .Y(n_C_18) );
  ADD24 C0L ( .A({n_BS27, n_BS26, n_BS25, n_BS24, n_BS23, n_BS22, n_BS21, 
        n_BS20, n_BS19, n_BS18, n_BS17, n_BS16, n_BS15, n_BS14, n_BS13, n_BS12, 
        n_BS11, n_BS10, n_BS09, n_BS08, n_BS07, n_BS06, n_BS05, n_BS04}), .B({
        n_BC26, n_BC25, n_BC24, n_BC23, n_BC22, n_BC21, n_BC20, n_BC19, n_BC18, 
        n_BC17, n_BC16, n_BC15, n_BC14, n_BC13, n_BC12, n_BC11, n_BC10, n_BC09, 
        n_BC08, n_BC07, n_BC06, n_BC05, n_BC04, n_BC03}), .S({P23, P22, P, P00}) );
  TIEHI C27 ( .Y(n_BS27) );
  INVX1 C25 ( .A(n_P119), .Y(n_C_31) );
  INVX1 C23 ( .A(n_P319), .Y(n_C_2A) );
  ADDHX1 C0K ( .A(n_P320), .B(n_P319), .S(n_BS26), .CO(n_BC26) );
  ADDFHX1 C0D ( .A(n_B20C2), .B(n_B20C1), .CI(n_C_30), .S(n_BS21), .CO(n_BC21)
         );
endmodule


module ADD24 ( A, B, S );
  input [23:0] A;
  input [23:0] B;
  output [23:0] S;
  wire   n_A_041, n_A_042, n_A_043, n_A_044, n_A_045, n_A_046, n_A_047,
         n_A_048, n_A_049, n_A_0410, n_A_0411, n_A_0412, n_A_0413, n_A_0414,
         n_A_0415, n_A_0416, n_A_0417, n_A_0418, n_A_0419, n_A_0420, n_A_0421,
         n_A_0422, n_A_0423, n_A_0424, n_A_031, n_A_032, n_A_033, n_A_034,
         n_A_035, n_A_036, n_A_037, n_A_038, n_A_039, n_A_0310, n_A_0311,
         n_A_0312, n_A_0313, n_A_0314, n_A_0315, n_A_0316, n_A_0317, n_A_0318,
         n_A_0319, n_A_0320, n_A_0321, n_A_0322, n_A_0323, n_A_0324;

  CS24D A002 ( .PN({n_A_041, n_A_042, n_A_043, n_A_044, n_A_045, n_A_046, 
        n_A_047, n_A_048, n_A_049, n_A_0410, n_A_0411, n_A_0412, n_A_0413, 
        n_A_0414, n_A_0415, n_A_0416, n_A_0417, n_A_0418, n_A_0419, n_A_0420, 
        n_A_0421, n_A_0422, n_A_0423, n_A_0424}), .GN({n_A_031, n_A_032, 
        n_A_033, n_A_034, n_A_035, n_A_036, n_A_037, n_A_038, n_A_039, 
        n_A_0310, n_A_0311, n_A_0312, n_A_0313, n_A_0314, n_A_0315, n_A_0316, 
        n_A_0317, n_A_0318, n_A_0319, n_A_0320, n_A_0321, n_A_0322, n_A_0323, 
        n_A_0324}), .S(S) );
  PG24 A001 ( .A(A), .B(B), .GN({n_A_031, n_A_032, n_A_033, n_A_034, n_A_035, 
        n_A_036, n_A_037, n_A_038, n_A_039, n_A_0310, n_A_0311, n_A_0312, 
        n_A_0313, n_A_0314, n_A_0315, n_A_0316, n_A_0317, n_A_0318, n_A_0319, 
        n_A_0320, n_A_0321, n_A_0322, n_A_0323, n_A_0324}), .PN({n_A_041, 
        n_A_042, n_A_043, n_A_044, n_A_045, n_A_046, n_A_047, n_A_048, n_A_049, 
        n_A_0410, n_A_0411, n_A_0412, n_A_0413, n_A_0414, n_A_0415, n_A_0416, 
        n_A_0417, n_A_0418, n_A_0419, n_A_0420, n_A_0421, n_A_0422, n_A_0423, 
        n_A_0424}) );
endmodule


module PG24 ( A, B, GN, PN );
  input [23:0] A;
  input [23:0] B;
  output [23:0] GN;
  output [23:0] PN;


  NAND2X2 A00S ( .A(A[0]), .B(B[0]), .Y(GN[0]) );
  XNOR2X2 A001 ( .A(A[0]), .B(B[0]), .Y(PN[0]) );
  NAND2X2 A01G ( .A(A[23]), .B(B[23]), .Y(GN[23]) );
  NAND2X2 A01F ( .A(A[22]), .B(B[22]), .Y(GN[22]) );
  NAND2X2 A01E ( .A(A[21]), .B(B[21]), .Y(GN[21]) );
  NAND2X2 A01D ( .A(A[20]), .B(B[20]), .Y(GN[20]) );
  NAND2X2 A01C ( .A(A[19]), .B(B[19]), .Y(GN[19]) );
  NAND2X2 A01B ( .A(A[18]), .B(B[18]), .Y(GN[18]) );
  NAND2X2 A01A ( .A(A[17]), .B(B[17]), .Y(GN[17]) );
  NAND2X2 A019 ( .A(A[16]), .B(B[16]), .Y(GN[16]) );
  NAND2X2 A018 ( .A(A[15]), .B(B[15]), .Y(GN[15]) );
  NAND2X2 A017 ( .A(A[14]), .B(B[14]), .Y(GN[14]) );
  NAND2X2 A016 ( .A(A[13]), .B(B[13]), .Y(GN[13]) );
  NAND2X2 A015 ( .A(A[12]), .B(B[12]), .Y(GN[12]) );
  NAND2X2 A014 ( .A(A[11]), .B(B[11]), .Y(GN[11]) );
  NAND2X2 A013 ( .A(A[10]), .B(B[10]), .Y(GN[10]) );
  NAND2X2 A012 ( .A(A[9]), .B(B[9]), .Y(GN[9]) );
  NAND2X2 A011 ( .A(A[8]), .B(B[8]), .Y(GN[8]) );
  NAND2X2 A010 ( .A(A[7]), .B(B[7]), .Y(GN[7]) );
  NAND2X2 A00Y ( .A(A[6]), .B(B[6]), .Y(GN[6]) );
  NAND2X2 A00X ( .A(A[5]), .B(B[5]), .Y(GN[5]) );
  NAND2X2 A00W ( .A(A[4]), .B(B[4]), .Y(GN[4]) );
  NAND2X2 A00V ( .A(A[3]), .B(B[3]), .Y(GN[3]) );
  NAND2X2 A00U ( .A(A[2]), .B(B[2]), .Y(GN[2]) );
  NAND2X2 A00T ( .A(A[1]), .B(B[1]), .Y(GN[1]) );
  XNOR2X2 A00R ( .A(A[23]), .B(B[23]), .Y(PN[23]) );
  XNOR2X2 A00P ( .A(A[22]), .B(B[22]), .Y(PN[22]) );
  XNOR2X2 A00N ( .A(A[21]), .B(B[21]), .Y(PN[21]) );
  XNOR2X2 A00M ( .A(A[20]), .B(B[20]), .Y(PN[20]) );
  XNOR2X2 A00L ( .A(A[19]), .B(B[19]), .Y(PN[19]) );
  XNOR2X2 A00K ( .A(A[18]), .B(B[18]), .Y(PN[18]) );
  XNOR2X2 A00J ( .A(A[17]), .B(B[17]), .Y(PN[17]) );
  XNOR2X2 A00H ( .A(A[16]), .B(B[16]), .Y(PN[16]) );
  XNOR2X2 A00G ( .A(A[15]), .B(B[15]), .Y(PN[15]) );
  XNOR2X2 A00F ( .A(A[14]), .B(B[14]), .Y(PN[14]) );
  XNOR2X2 A00E ( .A(A[13]), .B(B[13]), .Y(PN[13]) );
  XNOR2X2 A00D ( .A(A[12]), .B(B[12]), .Y(PN[12]) );
  XNOR2X2 A00C ( .A(A[11]), .B(B[11]), .Y(PN[11]) );
  XNOR2X2 A00B ( .A(A[10]), .B(B[10]), .Y(PN[10]) );
  XNOR2X2 A00A ( .A(A[9]), .B(B[9]), .Y(PN[9]) );
  XNOR2X2 A009 ( .A(A[8]), .B(B[8]), .Y(PN[8]) );
  XNOR2X2 A008 ( .A(A[7]), .B(B[7]), .Y(PN[7]) );
  XNOR2X2 A007 ( .A(A[6]), .B(B[6]), .Y(PN[6]) );
  XNOR2X2 A006 ( .A(A[5]), .B(B[5]), .Y(PN[5]) );
  XNOR2X2 A005 ( .A(A[4]), .B(B[4]), .Y(PN[4]) );
  XNOR2X2 A004 ( .A(A[3]), .B(B[3]), .Y(PN[3]) );
  XNOR2X2 A003 ( .A(A[2]), .B(B[2]), .Y(PN[2]) );
  XNOR2X2 A002 ( .A(A[1]), .B(B[1]), .Y(PN[1]) );
endmodule


module CS24D ( PN, GN, S, CO );
  input [23:0] PN;
  input [23:0] GN;
  output [23:0] S;
  output CO;
  wire   n_A_1D, n_A_19, n_A_21, n_A_1C, n_A_1A, n_A_1E, n_A_1G, n_A_1B,
         n_A_1F, n_A_25, n__13G7, n_A_24, n_A_1W, n_A_17, n_A_1X, n__13GN7B,
         n_A_18, n_A_16, n_A_26, n_A_22, n_A_27, n_A_23, n_A_20, n_A_1Y,
         n__14GN15, n__14G15B, n_B_21, n_B_1L, n_B_1K, n_B_1S, n_B_1J, n_B_1R,
         n_B_1V, n_B_1H, n_B_1C, n_B_1U, n_B_25, n_B_1E, n_B_26, n_B_23,
         n_B_1D, n_B_24, n_B_22, n_B_1F, n_B_2A, n_B_29, n_B_1X, n_B_1W,
         n_B_1G, n_B_1Y, n_B_20, n_B_27, n_B_28, n_B_2C, n_B_2B, n_C_1X,
         n_C_23, n_C_24, n_C_25, n_C_26, n_C_20, n_C_1Y, n_C_1F, n_C_1W,
         n_C_1G, n_C_1T, n_C_1B, n_C_1S, n_C_1A, n_C_29, n_C_1N, n_C_1K,
         n_C_1L, n_C_1J, n_C_1M, n_C_1U, n_C_1V, n_C_27, n_C_28, n_C_22,
         n_C_21, n_C_1P, n_C_1H, n_C_2A, n_C_1R;

  INVX2 A27 ( .A(PN[0]), .Y(S[0]) );
  OAI21X1 A08 ( .A0(PN[4]), .A1(n_A_1D), .B0(GN[4]), .Y(n_A_19) );
  AOI21X1 A09 ( .A0(n_A_21), .A1(n_A_1C), .B0(n_A_1E), .Y(n_A_1A) );
  AOI21X1 A0A ( .A0(n_A_1G), .A1(n_A_1C), .B0(n_A_1F), .Y(n_A_1B) );
  XOR2X2 A0D ( .A(PN[7]), .B(n_A_1B), .Y(S[7]) );
  OAI21X2 A07 ( .A0(n_A_25), .A1(n_A_1D), .B0(n_A_24), .Y(n__13G7) );
  OAI21X2 A06 ( .A0(PN[2]), .A1(n_A_1W), .B0(GN[2]), .Y(n_A_17) );
  OAI21X2 A05 ( .A0(PN[1]), .A1(GN[0]), .B0(GN[1]), .Y(n_A_1X) );
  INVX2 A0U ( .A(n__13G7), .Y(n__13GN7B) );
  INVX1 A0S ( .A(n_A_1C), .Y(n_A_18) );
  INVX1 A0R ( .A(n_A_1D), .Y(n_A_1C) );
  INVX1 A0P ( .A(n_A_1W), .Y(n_A_16) );
  INVX1 A0N ( .A(n_A_1X), .Y(n_A_1W) );
  INVX1 A0M ( .A(n_A_26), .Y(n_A_22) );
  INVX1 A0L ( .A(n_A_27), .Y(n_A_23) );
  XNOR2X2 A0K ( .A(PN[2]), .B(n_A_16), .Y(S[2]) );
  XNOR2X2 A0J ( .A(PN[3]), .B(n_A_17), .Y(S[3]) );
  XNOR2X2 A0H ( .A(PN[5]), .B(n_A_19), .Y(S[5]) );
  XOR2X2 A0G ( .A(PN[1]), .B(GN[0]), .Y(S[1]) );
  XOR2X2 A0F ( .A(PN[4]), .B(n_A_18), .Y(S[4]) );
  XOR2X2 A0E ( .A(PN[6]), .B(n_A_1A), .Y(S[6]) );
  XOR2X2 A0C ( .A(PN[8]), .B(n__13GN7B), .Y(S[8]) );
  AOI21X2 A0B ( .A0(n_A_1X), .A1(n_A_20), .B0(n_A_1Y), .Y(n_A_1D) );
  CODD4 A04 ( .GHN(GN[6]), .GLN(n_A_22), .PLN(n_A_23), .PHN(PN[6]), .GO(n_A_1F), .PO(n_A_1G) );
  CODD4 A03 ( .GHN(GN[3]), .GLN(GN[2]), .PLN(PN[2]), .PHN(PN[3]), .GO(n_A_1Y), 
        .PO(n_A_20) );
  CODD4 A02 ( .GHN(GN[5]), .GLN(GN[4]), .PLN(PN[4]), .PHN(PN[5]), .GO(n_A_1E), 
        .PO(n_A_21) );
  ODD8 A01 ( .G2N(GN[5]), .G1N(GN[4]), .G4N(GN[7]), .G3N(GN[6]), .P1N(PN[4]), 
        .P2N(PN[5]), .P3N(PN[6]), .P4N(PN[7]), .YG2(n_A_26), .YG4N(n_A_24), 
        .YP2(n_A_27), .YP4N(n_A_25) );
  INVX2 B26 ( .A(n__14GN15), .Y(n__14G15B) );
  INVX1 B1M ( .A(GN[12]), .Y(n_B_21) );
  INVX1 B0V ( .A(PN[9]), .Y(n_B_1L) );
  OAI21X1 B0P ( .A0(n__13GN7B), .A1(PN[8]), .B0(GN[8]), .Y(n_B_1K) );
  AOI21X1 B0L ( .A0(n_B_1S), .A1(n__13G7), .B0(n_B_1R), .Y(n_B_1J) );
  AOI21X1 B0N ( .A0(n_B_1V), .A1(n__13G7), .B0(n_B_1C), .Y(n_B_1H) );
  AOI21X1 B0R ( .A0(n_B_1U), .A1(n_B_25), .B0(n_B_26), .Y(n_B_1E) );
  AOI21X1 B0S ( .A0(n_B_23), .A1(n_B_1U), .B0(n_B_24), .Y(n_B_1D) );
  OAI22X1 B0U ( .A0(n_B_22), .A1(n_B_21), .B0(n_B_21), .B1(n_B_1U), .Y(n_B_1F)
         );
  AOI21X2 B0T ( .A0(n_B_2A), .A1(n__13G7), .B0(n_B_29), .Y(n__14GN15) );
  OAI21X2 B0M ( .A0(n__13GN7B), .A1(n_B_1X), .B0(n_B_1W), .Y(n_B_1U) );
  XNOR2X2 B0K ( .A(PN[16]), .B(n__14G15B), .Y(S[16]) );
  XOR2X2 B0J ( .A(PN[15]), .B(n_B_1D), .Y(S[15]) );
  XOR2X2 B0H ( .A(PN[14]), .B(n_B_1E), .Y(S[14]) );
  XOR2X2 B0G ( .A(PN[13]), .B(n_B_1F), .Y(S[13]) );
  XOR2X2 B0F ( .A(PN[12]), .B(n_B_1G), .Y(S[12]) );
  XOR2X2 B0E ( .A(PN[11]), .B(n_B_1H), .Y(S[11]) );
  XOR2X2 B0D ( .A(PN[10]), .B(n_B_1J), .Y(S[10]) );
  XOR2X2 B0C ( .A(n_B_1L), .B(n_B_1K), .Y(S[9]) );
  INVX1 B0B ( .A(n_B_1U), .Y(n_B_1G) );
  INVX1 B0A ( .A(n_B_1R), .Y(n_B_1Y) );
  INVX1 B09 ( .A(n_B_1S), .Y(n_B_20) );
  INVX1 B08 ( .A(PN[12]), .Y(n_B_22) );
  INVX1 B07 ( .A(n_B_26), .Y(n_B_27) );
  INVX1 B06 ( .A(n_B_25), .Y(n_B_28) );
  CODD4 B05 ( .GHN(n_B_2B), .GLN(n_B_1W), .PLN(n_B_1X), .PHN(n_B_2C), .GO(
        n_B_29), .PO(n_B_2A) );
  CODD4 B04 ( .GHN(GN[14]), .GLN(n_B_27), .PLN(n_B_28), .PHN(PN[14]), .GO(
        n_B_24), .PO(n_B_23) );
  CODD4 B03 ( .GHN(GN[10]), .GLN(n_B_1Y), .PLN(n_B_20), .PHN(PN[10]), .GO(
        n_B_1C), .PO(n_B_1V) );
  ODD8 B02 ( .G2N(GN[9]), .G1N(GN[8]), .G4N(GN[11]), .G3N(GN[10]), .P1N(PN[8]), 
        .P2N(PN[9]), .P3N(PN[10]), .P4N(PN[11]), .YG2(n_B_1R), .YG4N(n_B_1W), 
        .YP2(n_B_1S), .YP4N(n_B_1X) );
  ODD8 B01 ( .G2N(GN[13]), .G1N(GN[12]), .G4N(GN[15]), .G3N(GN[14]), .P1N(
        PN[12]), .P2N(PN[13]), .P3N(PN[14]), .P4N(PN[15]), .YG2(n_B_26), 
        .YG4N(n_B_2B), .YP2(n_B_25), .YP4N(n_B_2C) );
  INVX1 C0W ( .A(PN[17]), .Y(n_C_1X) );
  XOR2X2 C0V ( .A(PN[23]), .B(n_C_23), .Y(S[23]) );
  XOR2X2 C0U ( .A(PN[22]), .B(n_C_24), .Y(S[22]) );
  XOR2X2 C0T ( .A(PN[21]), .B(n_C_25), .Y(S[21]) );
  XOR2X2 C0S ( .A(PN[20]), .B(n_C_26), .Y(S[20]) );
  XOR2X2 C0R ( .A(PN[19]), .B(n_C_20), .Y(S[19]) );
  XOR2X2 C0P ( .A(PN[18]), .B(n_C_1Y), .Y(S[18]) );
  XOR2X2 C0N ( .A(n_C_1X), .B(n_C_1F), .Y(S[17]) );
  INVX2 C0M ( .A(n_C_1W), .Y(CO) );
  INVX1 C0L ( .A(n_C_1G), .Y(n_C_26) );
  INVX1 C0K ( .A(n_C_1T), .Y(n_C_1B) );
  INVX1 C0J ( .A(n_C_1S), .Y(n_C_1A) );
  INVX1 C0H ( .A(GN[20]), .Y(n_C_29) );
  INVX1 C0G ( .A(PN[20]), .Y(n_C_1N) );
  INVX1 C0F ( .A(n_C_1K), .Y(n_C_1L) );
  INVX1 C0E ( .A(n_C_1J), .Y(n_C_1M) );
  OAI22X1 C0D ( .A0(n_C_1N), .A1(n_C_29), .B0(n_C_29), .B1(n_C_1G), .Y(n_C_25)
         );
  AOI21X1 C0C ( .A0(n__14G15B), .A1(n_C_1U), .B0(n_C_1V), .Y(n_C_1W) );
  AOI21X1 C0B ( .A0(n_C_27), .A1(n_C_1G), .B0(n_C_28), .Y(n_C_23) );
  AOI21X1 C0A ( .A0(n_C_1J), .A1(n_C_1G), .B0(n_C_1K), .Y(n_C_24) );
  AOI21X1 C09 ( .A0(n__14G15B), .A1(n_C_22), .B0(n_C_21), .Y(n_C_20) );
  OAI21X2 C08 ( .A0(n_C_1P), .A1(n__14GN15), .B0(n_C_1H), .Y(n_C_1G) );
  AOI21X1 C07 ( .A0(n__14G15B), .A1(n_C_1S), .B0(n_C_1T), .Y(n_C_1Y) );
  OAI21X1 C06 ( .A0(PN[16]), .A1(n__14GN15), .B0(GN[16]), .Y(n_C_1F) );
  CODD4 C05 ( .GHN(GN[18]), .GLN(n_C_1B), .PLN(n_C_1A), .PHN(PN[18]), .GO(
        n_C_21), .PO(n_C_22) );
  CODD4 C04 ( .GHN(GN[22]), .GLN(n_C_1L), .PLN(n_C_1M), .PHN(PN[22]), .GO(
        n_C_28), .PO(n_C_27) );
  CODD4 C03 ( .GHN(n_C_1R), .GLN(n_C_1H), .PLN(n_C_1P), .PHN(n_C_2A), .GO(
        n_C_1V), .PO(n_C_1U) );
  ODD8 C02 ( .G2N(GN[17]), .G1N(GN[16]), .G4N(GN[19]), .G3N(GN[18]), .P1N(
        PN[16]), .P2N(PN[17]), .P3N(PN[18]), .P4N(PN[19]), .YG2(n_C_1T), 
        .YG4N(n_C_1H), .YP2(n_C_1S), .YP4N(n_C_1P) );
  ODD8 C01 ( .G2N(GN[21]), .G1N(GN[20]), .G4N(GN[23]), .G3N(GN[22]), .P1N(
        PN[20]), .P2N(PN[21]), .P3N(PN[22]), .P4N(PN[23]), .YG2(n_C_1K), 
        .YG4N(n_C_1R), .YP2(n_C_1J), .YP4N(n_C_2A) );
endmodule


module PP20LS ( AN, B1N, B0N, PP );
  input [19:0] AN;
  output [20:0] PP;
  input B1N, B0N;
  wire   n_A_1M, n_A_1B, n_A_1C, n_A_1L, n_A_15, n_A_1N, n_A_16, n_A_17,
         n_A_18;

  PPU4 A1F ( .SFT(n_A_1B), .NSFT(n_A_1C), .AN3(AN[19]), .AN2(AN[18]), .AN1(
        AN[17]), .AN0(AN[16]), .RI(n_A_1M), .SN(B1N), .LO(n_A_1L), .P3(PP[19]), 
        .P2(PP[18]), .P1(PP[17]), .P0(PP[16]) );
  AND2X4 A09 ( .A(n_A_15), .B(B0N), .Y(n_A_1B) );
  INVX4 A07 ( .A(B0N), .Y(n_A_1C) );
  INVX1 A08 ( .A(B1N), .Y(n_A_15) );
  NAND2X1 A06 ( .A(n_A_1L), .B(n_A_1N), .Y(PP[20]) );
  NAND2X1 A05 ( .A(B0N), .B(B1N), .Y(n_A_1N) );
  PPU4 A04 ( .SFT(n_A_1B), .NSFT(n_A_1C), .AN3(AN[15]), .AN2(AN[14]), .AN1(
        AN[13]), .AN0(AN[12]), .RI(n_A_16), .SN(B1N), .LO(n_A_1M), .P3(PP[15]), 
        .P2(PP[14]), .P1(PP[13]), .P0(PP[12]) );
  PPU4 A03 ( .SFT(n_A_1B), .NSFT(n_A_1C), .AN3(AN[11]), .AN2(AN[10]), .AN1(
        AN[9]), .AN0(AN[8]), .RI(n_A_17), .SN(B1N), .LO(n_A_16), .P3(PP[11]), 
        .P2(PP[10]), .P1(PP[9]), .P0(PP[8]) );
  PPU4 A02 ( .SFT(n_A_1B), .NSFT(n_A_1C), .AN3(AN[7]), .AN2(AN[6]), .AN1(AN[5]), .AN0(AN[4]), .RI(n_A_18), .SN(B1N), .LO(n_A_17), .P3(PP[7]), .P2(PP[6]), 
        .P1(PP[5]), .P0(PP[4]) );
  PPU4 A01 ( .SFT(n_A_1B), .NSFT(n_A_1C), .AN3(AN[3]), .AN2(AN[2]), .AN1(AN[1]), .AN0(AN[0]), .RI(n_A_15), .SN(B1N), .LO(n_A_18), .P3(PP[3]), .P2(PP[2]), 
        .P1(PP[1]), .P0(PP[0]) );
endmodule


module PP20 ( AN, B1N, B0N, B_1N, PP, AD1 );
  input [19:0] AN;
  output [20:0] PP;
  input B1N, B0N, B_1N;
  output AD1;
  wire   n_A_1G, n_A_1T, n_A_1P, n_A_1R, n_A_1N, n_A_1H, n_A_1D, n_A_1C,
         n_A_1S, n_A_1J, n_A_1A, n_A_1U, n_A_1V, n_A_1W;

  XNOR2X1 A09 ( .A(B0N), .B(B_1N), .Y(n_A_1G) );
  PPU4 A1G ( .SFT(n_A_1P), .NSFT(n_A_1R), .AN3(AN[19]), .AN2(AN[18]), .AN1(
        AN[17]), .AN0(AN[16]), .RI(n_A_1T), .SN(B1N), .LO(n_A_1N), .P3(PP[19]), 
        .P2(PP[18]), .P1(PP[17]), .P0(PP[16]) );
  AND2X4 A07 ( .A(n_A_1G), .B(n_A_1H), .Y(n_A_1P) );
  INVX4 A0E ( .A(n_A_1G), .Y(n_A_1R) );
  AND2X2 A1F ( .A(n_A_1D), .B(n_A_1C), .Y(AD1) );
  NAND2X1 A0D ( .A(n_A_1N), .B(n_A_1S), .Y(PP[20]) );
  NAND2X1 A0C ( .A(n_A_1G), .B(n_A_1J), .Y(n_A_1S) );
  OR2X1 A0B ( .A(B0N), .B(B_1N), .Y(n_A_1D) );
  XOR2X1 A0A ( .A(B0N), .B(B1N), .Y(n_A_1H) );
  INVX1 A08 ( .A(B1N), .Y(n_A_1C) );
  INVX1 A06 ( .A(n_A_1H), .Y(n_A_1J) );
  INVX1 A05 ( .A(B1N), .Y(n_A_1A) );
  PPU4 A04 ( .SFT(n_A_1P), .NSFT(n_A_1R), .AN3(AN[15]), .AN2(AN[14]), .AN1(
        AN[13]), .AN0(AN[12]), .RI(n_A_1U), .SN(B1N), .LO(n_A_1T), .P3(PP[15]), 
        .P2(PP[14]), .P1(PP[13]), .P0(PP[12]) );
  PPU4 A03 ( .SFT(n_A_1P), .NSFT(n_A_1R), .AN3(AN[11]), .AN2(AN[10]), .AN1(
        AN[9]), .AN0(AN[8]), .RI(n_A_1V), .SN(B1N), .LO(n_A_1U), .P3(PP[11]), 
        .P2(PP[10]), .P1(PP[9]), .P0(PP[8]) );
  PPU4 A02 ( .SFT(n_A_1P), .NSFT(n_A_1R), .AN3(AN[7]), .AN2(AN[6]), .AN1(AN[5]), .AN0(AN[4]), .RI(n_A_1W), .SN(B1N), .LO(n_A_1V), .P3(PP[7]), .P2(PP[6]), 
        .P1(PP[5]), .P0(PP[4]) );
  PPU4 A01 ( .SFT(n_A_1P), .NSFT(n_A_1R), .AN3(AN[3]), .AN2(AN[2]), .AN1(AN[1]), .AN0(AN[0]), .RI(n_A_1A), .SN(B1N), .LO(n_A_1W), .P3(PP[3]), .P2(PP[2]), 
        .P1(PP[1]), .P0(PP[0]) );
endmodule


module DS032 ( A, B, S, Y );
  input [2:0] A;
  input [2:0] B;
  output [2:0] Y;
  input S;
  wire   n_A_06;

  MX2X1 A10 ( .S0(n_A_06), .B(B[0]), .A(A[0]), .Y(Y[0]) );
  MX2X1 A11 ( .S0(n_A_06), .B(B[1]), .A(A[1]), .Y(Y[1]) );
  BUFX2 A02 ( .A(S), .Y(n_A_06) );
  MX2X1 A12 ( .S0(n_A_06), .B(B[2]), .A(A[2]), .Y(Y[2]) );
endmodule


module FS075 ( D, CK, EN, TI, TE, RN, Q, TO );
  input [6:0] D;
  output [6:0] Q;
  input CK, EN, TI, TE, RN;
  output TO;
  wire   n_A_0P, n_A_08, n_A_0A, n_A_02, n_A_0R, n_A_0U, n_A_13, n_A_1B,
         n_A_0B, n_A_1L, n_A_1C, n_A_0W, n_A_0X, n_A_0Y, n_A_10, n_A_11,
         n_A_12, n_A_14, n_A_15, n_A_16, n_A_17, n_A_18, n_A_19, n_A_1A,
         n_A_0V, n_A_1D, n_A_1E, n_A_1F, n_A_1G, n_A_1H, n_A_1J;

  FE1R A1W ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_08), .CK(CK), .EN(n_A_0R), .D(
        n_A_02), .Q(Q[0]) );
  FE1R A11 ( .RN(n_A_0P), .TE(n_A_0A), .TI(Q[0]), .CK(CK), .EN(n_A_0R), .D(
        n_A_0U), .Q(Q[1]) );
  FE1R A08 ( .RN(n_A_0P), .TE(n_A_0A), .TI(Q[1]), .CK(CK), .EN(n_A_0R), .D(
        n_A_13), .Q(Q[2]) );
  FE1R A0G ( .RN(n_A_0P), .TE(n_A_0A), .TI(Q[2]), .CK(CK), .EN(n_A_0R), .D(
        n_A_1B), .Q(Q[3]) );
  FE1R A0R ( .RN(n_A_0P), .TE(n_A_0A), .TI(Q[3]), .CK(CK), .EN(n_A_0R), .D(
        n_A_0B), .Q(Q[4]) );
  FE1R A10 ( .RN(n_A_0P), .TE(n_A_0A), .TI(Q[4]), .CK(CK), .EN(n_A_0R), .D(
        n_A_1L), .Q(Q[5]) );
  FE1R A1G ( .RN(n_A_0P), .TE(n_A_0A), .TI(Q[5]), .CK(CK), .EN(n_A_0R), .D(
        n_A_08), .Q(Q[6]) );
  BUFX8 A1L ( .A(EN), .Y(n_A_0R) );
  BUFX8 A1K ( .A(RN), .Y(n_A_0P) );
  BUFX8 A1J ( .A(TE), .Y(n_A_0A) );
  BUFX2 A1H ( .A(Q[6]), .Y(TO) );
  FE1R A0Y ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_1L), .CK(CK), .EN(n_A_0R), .D(
        n_A_1C), .Q(n_A_08) );
  FE1R A0X ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_0B), .CK(CK), .EN(n_A_0R), .D(
        n_A_0W), .Q(n_A_1L) );
  FE1R A0W ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_1B), .CK(CK), .EN(n_A_0R), .D(
        n_A_0X), .Q(n_A_0B) );
  FE1R A0V ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_13), .CK(CK), .EN(n_A_0R), .D(
        n_A_0Y), .Q(n_A_1B) );
  FE1R A0U ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_0U), .CK(CK), .EN(n_A_0R), .D(
        n_A_10), .Q(n_A_13) );
  FE1R A0T ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_02), .CK(CK), .EN(n_A_0R), .D(
        n_A_11), .Q(n_A_0U) );
  FE1R A0S ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_1C), .CK(CK), .EN(n_A_0R), .D(
        n_A_12), .Q(n_A_02) );
  FE1R A0P ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_0W), .CK(CK), .EN(n_A_0R), .D(
        n_A_14), .Q(n_A_1C) );
  FE1R A0N ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_0X), .CK(CK), .EN(n_A_0R), .D(
        n_A_15), .Q(n_A_0W) );
  FE1R A0M ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_0Y), .CK(CK), .EN(n_A_0R), .D(
        n_A_16), .Q(n_A_0X) );
  FE1R A0L ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_10), .CK(CK), .EN(n_A_0R), .D(
        n_A_17), .Q(n_A_0Y) );
  FE1R A0K ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_11), .CK(CK), .EN(n_A_0R), .D(
        n_A_18), .Q(n_A_10) );
  FE1R A0J ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_12), .CK(CK), .EN(n_A_0R), .D(
        n_A_19), .Q(n_A_11) );
  FE1R A0H ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_14), .CK(CK), .EN(n_A_0R), .D(
        n_A_1A), .Q(n_A_12) );
  FE1R A0F ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_15), .CK(CK), .EN(n_A_0R), .D(
        n_A_0V), .Q(n_A_14) );
  FE1R A0E ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_16), .CK(CK), .EN(n_A_0R), .D(
        n_A_1D), .Q(n_A_15) );
  FE1R A0D ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_17), .CK(CK), .EN(n_A_0R), .D(
        n_A_1E), .Q(n_A_16) );
  FE1R A0C ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_18), .CK(CK), .EN(n_A_0R), .D(
        n_A_1F), .Q(n_A_17) );
  FE1R A0B ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_19), .CK(CK), .EN(n_A_0R), .D(
        n_A_1G), .Q(n_A_18) );
  FE1R A0A ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_1A), .CK(CK), .EN(n_A_0R), .D(
        n_A_1H), .Q(n_A_19) );
  FE1R A09 ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_0V), .CK(CK), .EN(n_A_0R), .D(
        n_A_1J), .Q(n_A_1A) );
  FE1R A07 ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_1D), .CK(CK), .EN(n_A_0R), .D(
        D[6]), .Q(n_A_0V) );
  FE1R A06 ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_1E), .CK(CK), .EN(n_A_0R), .D(
        D[5]), .Q(n_A_1D) );
  FE1R A05 ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_1F), .CK(CK), .EN(n_A_0R), .D(
        D[4]), .Q(n_A_1E) );
  FE1R A04 ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_1G), .CK(CK), .EN(n_A_0R), .D(
        D[3]), .Q(n_A_1F) );
  FE1R A03 ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_1H), .CK(CK), .EN(n_A_0R), .D(
        D[2]), .Q(n_A_1G) );
  FE1R A02 ( .RN(n_A_0P), .TE(n_A_0A), .TI(n_A_1J), .CK(CK), .EN(n_A_0R), .D(
        D[1]), .Q(n_A_1H) );
  FE1R A01 ( .RN(n_A_0P), .TE(n_A_0A), .TI(TI), .CK(CK), .EN(n_A_0R), .D(D[0]), 
        .Q(n_A_1J) );
endmodule


module ERXD ( SPCO, RXD, TI, MCK, SIEXS, XRST, TE, LRSEL, RXEN, ESYNC, RXWE, 
        EXTI, RXSYNC, RXRDY, TO );
  input [19:0] SPCO;
  input [31:0] RXD;
  output [19:0] EXTI;
  input TI, MCK, SIEXS, XRST, TE, LRSEL, RXEN, ESYNC, RXWE;
  output RXSYNC, RXRDY, TO;
  wire   n_EO00, n_EO01, n_EO02, n_A_0G, n_A_09, n_A_0D, n_A_0A, n_A_0Y1,
         n_A_0Y2, n_A_0Y3, n_A_0Y4, n_A_0Y5, n_A_0Y6, n_A_0Y7, n_A_0Y8,
         n_A_0Y9, n_A_0Y10, n_A_0Y11, n_A_0Y12, n_A_0Y13, n_A_0Y14, n_A_0Y15,
         n_A_0Y16, n_A_101, n_A_102, n_A_103, n_A_104, n_A_105, n_A_106,
         n_A_107, n_A_108, n_A_109, n_A_1010, n_A_1011, n_A_1012, n_A_1013,
         n_A_1014, n_A_1015, n_A_1016, n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4,
         n_A_0X5, n_A_0X6, n_A_0X7, n_A_0X8, n_A_0X9, n_A_0X10, n_A_0X11,
         n_A_0X12, n_A_0X13, n_A_0X14, n_A_0X15, n_A_0X16, n_A_111, n_A_112,
         n_A_113, n_A_114, n_A_115, n_A_116, n_A_117, n_A_118, n_A_119,
         n_A_1110, n_A_1111, n_A_1112, n_A_1113, n_A_1114, n_A_1115, n_A_1116,
         n_A_0C, n_A_0R, n_A_0W, n_EO03, n_A_131, n_A_132, n_A_133, n_A_134,
         n_A_135, n_A_136, n_A_137, n_A_138, n_A_139, n_A_1310, n_A_1311,
         n_A_1312, n_A_1313, n_A_1314, n_A_1315, n_A_1316, n_A_121, n_A_122,
         n_A_123, n_A_124, n_A_125, n_A_126, n_A_127, n_A_128, n_A_129,
         n_A_1210, n_A_1211, n_A_1212, n_A_1213, n_A_1214, n_A_1215, n_A_1216,
         n_EO19, n_EO18, n_EO17, n_EO16, n_EO15, n_EO14, n_EO13, n_EO12,
         n_EO11, n_EO10, n_EO09, n_EO08, n_EO07, n_EO06, n_EO05, n_EO04,
         n_A_0M, n_A_0L, n_A_0K;

  TIELO A0D0 ( .Y(n_EO00) );
  TIELO A0D1 ( .Y(n_EO01) );
  TIELO A0D2 ( .Y(n_EO02) );
  AND2X2 A0W ( .A(n_A_0G), .B(n_A_09), .Y(RXRDY) );
  BUFX2 A11 ( .A(XRST), .Y(n_A_0D) );
  BUFX2 A10 ( .A(TE), .Y(n_A_0A) );
  BUFX2 A0G ( .A(RXEN), .Y(n_A_09) );
  EN16 A08 ( .A({n_A_0Y1, n_A_0Y2, n_A_0Y3, n_A_0Y4, n_A_0Y5, n_A_0Y6, n_A_0Y7, 
        n_A_0Y8, n_A_0Y9, n_A_0Y10, n_A_0Y11, n_A_0Y12, n_A_0Y13, n_A_0Y14, 
        n_A_0Y15, n_A_0Y16}), .EN(n_A_09), .Y({n_A_101, n_A_102, n_A_103, 
        n_A_104, n_A_105, n_A_106, n_A_107, n_A_108, n_A_109, n_A_1010, 
        n_A_1011, n_A_1012, n_A_1013, n_A_1014, n_A_1015, n_A_1016}) );
  EN16 A09 ( .A({n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, n_A_0X7, 
        n_A_0X8, n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, n_A_0X14, 
        n_A_0X15, n_A_0X16}), .EN(n_A_09), .Y({n_A_111, n_A_112, n_A_113, 
        n_A_114, n_A_115, n_A_116, n_A_117, n_A_118, n_A_119, n_A_1110, 
        n_A_1111, n_A_1112, n_A_1113, n_A_1114, n_A_1115, n_A_1116}) );
  AND2X2 A0L ( .A(n_A_0C), .B(n_A_09), .Y(RXSYNC) );
  BUFX2 A0H ( .A(LRSEL), .Y(n_A_0R) );
  BUFX2 A0F ( .A(ESYNC), .Y(n_A_0C) );
  BUFX2 A0E ( .A(RXWE), .Y(n_A_0W) );
  TIELO A0D3 ( .Y(n_EO03) );
  SR1R A0A ( .RN(n_A_0D), .TE(n_A_0A), .TI(TI), .CK(MCK), .SR(n_A_0W), .SS(
        n_A_0C), .Q(n_A_0G) );
  DS162 A02 ( .A({n_A_131, n_A_132, n_A_133, n_A_134, n_A_135, n_A_136, 
        n_A_137, n_A_138, n_A_139, n_A_1310, n_A_1311, n_A_1312, n_A_1313, 
        n_A_1314, n_A_1315, n_A_1316}), .B({n_A_121, n_A_122, n_A_123, n_A_124, 
        n_A_125, n_A_126, n_A_127, n_A_128, n_A_129, n_A_1210, n_A_1211, 
        n_A_1212, n_A_1213, n_A_1214, n_A_1215, n_A_1216}), .S(n_A_0R), .Y({
        n_EO19, n_EO18, n_EO17, n_EO16, n_EO15, n_EO14, n_EO13, n_EO12, n_EO11, 
        n_EO10, n_EO09, n_EO08, n_EO07, n_EO06, n_EO05, n_EO04}) );
  FE16R A03 ( .D(RXD[31:16]), .TI(n_A_0G), .RN(n_A_0D), .TE(n_A_0A), .CK(MCK), 
        .EN(n_A_0W), .Q({n_A_0Y1, n_A_0Y2, n_A_0Y3, n_A_0Y4, n_A_0Y5, n_A_0Y6, 
        n_A_0Y7, n_A_0Y8, n_A_0Y9, n_A_0Y10, n_A_0Y11, n_A_0Y12, n_A_0Y13, 
        n_A_0Y14, n_A_0Y15, n_A_0Y16}), .TO(n_A_0M) );
  FE16R A04 ( .D(RXD[15:0]), .TI(n_A_0M), .RN(n_A_0D), .TE(n_A_0A), .CK(MCK), 
        .EN(n_A_0W), .Q({n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, 
        n_A_0X7, n_A_0X8, n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, 
        n_A_0X14, n_A_0X15, n_A_0X16}), .TO(n_A_0L) );
  FE16R A05 ( .D({n_A_101, n_A_102, n_A_103, n_A_104, n_A_105, n_A_106, 
        n_A_107, n_A_108, n_A_109, n_A_1010, n_A_1011, n_A_1012, n_A_1013, 
        n_A_1014, n_A_1015, n_A_1016}), .TI(n_A_0K), .RN(n_A_0D), .TE(n_A_0A), 
        .CK(MCK), .EN(n_A_0C), .Q({n_A_121, n_A_122, n_A_123, n_A_124, n_A_125, 
        n_A_126, n_A_127, n_A_128, n_A_129, n_A_1210, n_A_1211, n_A_1212, 
        n_A_1213, n_A_1214, n_A_1215, n_A_1216}), .TO(TO) );
  FE16R A06 ( .D({n_A_111, n_A_112, n_A_113, n_A_114, n_A_115, n_A_116, 
        n_A_117, n_A_118, n_A_119, n_A_1110, n_A_1111, n_A_1112, n_A_1113, 
        n_A_1114, n_A_1115, n_A_1116}), .TI(n_A_0L), .RN(n_A_0D), .TE(n_A_0A), 
        .CK(MCK), .EN(n_A_0C), .Q({n_A_131, n_A_132, n_A_133, n_A_134, n_A_135, 
        n_A_136, n_A_137, n_A_138, n_A_139, n_A_1310, n_A_1311, n_A_1312, 
        n_A_1313, n_A_1314, n_A_1315, n_A_1316}), .TO(n_A_0K) );
  DS202 A01 ( .A(SPCO), .B({n_EO19, n_EO18, n_EO17, n_EO16, n_EO15, n_EO14, 
        n_EO13, n_EO12, n_EO11, n_EO10, n_EO09, n_EO08, n_EO07, n_EO06, n_EO05, 
        n_EO04, n_EO03, n_EO02, n_EO01, n_EO00}), .S(SIEXS), .Y(EXTI) );
endmodule


module EOREG ( EDB, SOBWS, EOBLE, XRST, ENP, ESYNC, TE, MCK, EOLE, EOS1, EOS0, 
        TI, EOO, TO, LRCK, SCK, SDO2, SDO1 );
  input [19:0] EDB;
  input [1:0] SOBWS;
  output [19:0] EOO;
  input EOBLE, XRST, ENP, ESYNC, TE, MCK, EOLE, EOS1, EOS0, TI;
  output TO, LRCK, SCK, SDO2, SDO1;
  wire   n_PDA00, n_PDA01, n_PDA02, n_PDB00, n_PDB01, n_PDB02, n_PDB03,
         n_PDA03, n_A_1L20, n_A_1L19, n_A_1L18, n_A_1L17, n_A_1L16, n_A_1L15,
         n_A_1L14, n_A_1L13, n_A_1L12, n_A_1L11, n_A_1L10, n_A_1L9, n_A_1L8,
         n_A_1L7, n_A_1L6, n_A_1L5, n_A_1L4, n_A_1L3, n_A_1L2, n_A_14, n_A_1L1,
         n_A_18, n_A_1G, n_A_1H, n_A_0L, n_A_0J, n_A_0Y1, n_A_0Y2, n_A_0Y3,
         n_A_0Y4, n_A_0Y5, n_A_0Y6, n_A_0Y7, n_A_0Y8, n_A_0Y9, n_A_0Y10,
         n_A_0Y11, n_A_0Y12, n_A_0Y13, n_A_0Y14, n_A_0Y15, n_A_0Y16, n_A_0Y17,
         n_A_0Y18, n_A_0Y19, n_A_0Y20, n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4,
         n_A_0X5, n_A_0X6, n_A_0X7, n_A_0X8, n_A_0X9, n_A_0X10, n_A_0X11,
         n_A_0X12, n_A_0X13, n_A_0X14, n_A_0X15, n_A_0X16, n_A_0X17, n_A_0X18,
         n_A_0X19, n_A_0X20, n_A_0W1, n_A_0W2, n_A_0W3, n_A_0W4, n_A_0W5,
         n_A_0W6, n_A_0W7, n_A_0W8, n_A_0W9, n_A_0W10, n_A_0W11, n_A_0W12,
         n_A_0W13, n_A_0W14, n_A_0W15, n_A_0W16, n_A_0W17, n_A_0W18, n_A_0W19,
         n_A_0W20, n_A_0V1, n_A_0V2, n_A_0V3, n_A_0V4, n_A_0V5, n_A_0V6,
         n_A_0V7, n_A_0V8, n_A_0V9, n_A_0V10, n_A_0V11, n_A_0V12, n_A_0V13,
         n_A_0V14, n_A_0V15, n_A_0V16, n_A_0V17, n_A_0V18, n_A_0V19, n_A_0V20,
         n_A_0U, n_A_0D, n_A_1P, n_A_081, n_A_082, n_A_083, n_A_084, n_A_085,
         n_A_1J1, n_A_1J2, n_A_1J3, n_A_1J4, n_A_1J5, n_A_1J6, n_A_1J7,
         n_A_1J8, n_A_1J9, n_A_1J10, n_A_1J11, n_A_1J12, n_A_1J13, n_A_1J14,
         n_A_1J15, n_A_1J16, n_A_1J17, n_A_1J18, n_A_1J19, n_A_1J20, n_A_1C1,
         n_A_1C2, n_A_1C3, n_A_1C4, n_A_1C5, n_A_1C6, n_A_1C7, n_A_1C8,
         n_A_1C9, n_A_1C10, n_A_1C11, n_A_1C12, n_A_1C13, n_A_1C14, n_A_1C15,
         n_A_1C16, n_A_1C17, n_A_1C18, n_A_1C19, n_A_1C20, n_PDB23, n_PDB22,
         n_PDB21, n_PDB20, n_PDB19, n_PDB18, n_PDB17, n_PDB16, n_PDB15,
         n_PDB14, n_PDB13, n_PDB12, n_PDB11, n_PDB10, n_PDB09, n_PDB08,
         n_PDB07, n_PDB06, n_PDB05, n_PDB04, n_A_1S1, n_A_1S2, n_A_1S3,
         n_A_1S4, n_A_1S5, n_A_1S6, n_A_1S7, n_A_1S8, n_A_1S9, n_A_1S10,
         n_A_1S11, n_A_1S12, n_A_1S13, n_A_1S14, n_A_1S15, n_A_1S16, n_A_1S17,
         n_A_1S18, n_A_1S19, n_A_1S20, n_A_1B1, n_A_1B2, n_A_1B3, n_A_1B4,
         n_A_1B5, n_A_1B6, n_A_1B7, n_A_1B8, n_A_1B9, n_A_1B10, n_A_1B11,
         n_A_1B12, n_A_1B13, n_A_1B14, n_A_1B15, n_A_1B16, n_A_1B17, n_A_1B18,
         n_A_1B19, n_A_1B20, n_PDA23, n_PDA22, n_PDA21, n_PDA20, n_PDA19,
         n_PDA18, n_PDA17, n_PDA16, n_PDA15, n_PDA14, n_PDA13, n_PDA12,
         n_PDA11, n_PDA10, n_PDA09, n_PDA08, n_PDA07, n_PDA06, n_PDA05,
         n_PDA04, n_A_0K, n_A_0M, n_A_15, n_A_0P, n_A_17, n_A_0S, n_A_16;

  TIELO A100 ( .Y(n_PDA00) );
  TIELO A101 ( .Y(n_PDA01) );
  TIELO A102 ( .Y(n_PDA02) );
  TIELO A200 ( .Y(n_PDB00) );
  TIELO A201 ( .Y(n_PDB01) );
  TIELO A202 ( .Y(n_PDB02) );
  TIELO A203 ( .Y(n_PDB03) );
  TIELO A103 ( .Y(n_PDA03) );
  BUFX2 A000 ( .A(EDB[0]), .Y(n_A_1L20) );
  BUFX2 A001 ( .A(EDB[1]), .Y(n_A_1L19) );
  BUFX2 A002 ( .A(EDB[2]), .Y(n_A_1L18) );
  BUFX2 A003 ( .A(EDB[3]), .Y(n_A_1L17) );
  BUFX2 A004 ( .A(EDB[4]), .Y(n_A_1L16) );
  BUFX2 A005 ( .A(EDB[5]), .Y(n_A_1L15) );
  BUFX2 A006 ( .A(EDB[6]), .Y(n_A_1L14) );
  BUFX2 A007 ( .A(EDB[7]), .Y(n_A_1L13) );
  BUFX2 A008 ( .A(EDB[8]), .Y(n_A_1L12) );
  BUFX2 A009 ( .A(EDB[9]), .Y(n_A_1L11) );
  BUFX2 A010 ( .A(EDB[10]), .Y(n_A_1L10) );
  BUFX2 A011 ( .A(EDB[11]), .Y(n_A_1L9) );
  BUFX2 A012 ( .A(EDB[12]), .Y(n_A_1L8) );
  BUFX2 A013 ( .A(EDB[13]), .Y(n_A_1L7) );
  BUFX2 A014 ( .A(EDB[14]), .Y(n_A_1L6) );
  BUFX2 A015 ( .A(EDB[15]), .Y(n_A_1L5) );
  BUFX2 A016 ( .A(EDB[16]), .Y(n_A_1L4) );
  BUFX2 A017 ( .A(EDB[17]), .Y(n_A_1L3) );
  BUFX2 A018 ( .A(EDB[18]), .Y(n_A_1L2) );
  BUFX2 A0N ( .A(LRCK), .Y(n_A_14) );
  BUFX2 A019 ( .A(EDB[19]), .Y(n_A_1L1) );
  BUFX2 A1K ( .A(EOBLE), .Y(n_A_18) );
  DC04P A0G ( .EN(EOLE), .B(EOS1), .A(EOS0), .Y3(n_A_0J), .Y2(n_A_0L), .Y1(
        n_A_1H), .Y0(n_A_1G) );
  DS204 A1H ( .A({n_A_0Y1, n_A_0Y2, n_A_0Y3, n_A_0Y4, n_A_0Y5, n_A_0Y6, 
        n_A_0Y7, n_A_0Y8, n_A_0Y9, n_A_0Y10, n_A_0Y11, n_A_0Y12, n_A_0Y13, 
        n_A_0Y14, n_A_0Y15, n_A_0Y16, n_A_0Y17, n_A_0Y18, n_A_0Y19, n_A_0Y20}), 
        .B({n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, n_A_0X7, 
        n_A_0X8, n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, n_A_0X14, 
        n_A_0X15, n_A_0X16, n_A_0X17, n_A_0X18, n_A_0X19, n_A_0X20}), .C({
        n_A_0W1, n_A_0W2, n_A_0W3, n_A_0W4, n_A_0W5, n_A_0W6, n_A_0W7, n_A_0W8, 
        n_A_0W9, n_A_0W10, n_A_0W11, n_A_0W12, n_A_0W13, n_A_0W14, n_A_0W15, 
        n_A_0W16, n_A_0W17, n_A_0W18, n_A_0W19, n_A_0W20}), .D({n_A_0V1, 
        n_A_0V2, n_A_0V3, n_A_0V4, n_A_0V5, n_A_0V6, n_A_0V7, n_A_0V8, n_A_0V9, 
        n_A_0V10, n_A_0V11, n_A_0V12, n_A_0V13, n_A_0V14, n_A_0V15, n_A_0V16, 
        n_A_0V17, n_A_0V18, n_A_0V19, n_A_0V20}), .S1(EOS1), .S0(EOS0), .Y(EOO) );
  BUFX2 A0R ( .A(XRST), .Y(n_A_0U) );
  BUFX2 A0P ( .A(TE), .Y(n_A_0D) );
  PSCKG A09 ( .SBW(SOBWS), .RN(n_A_0U), .TE(n_A_0D), .SYNC(ESYNC), .TI(n_A_1P), 
        .EN(ENP), .CK(MCK), .SO({n_A_081, n_A_082, n_A_083, n_A_084, n_A_085}), 
        .SCK(SCK), .TO(TO), .LRCK(LRCK) );
  DS202 A0M ( .A({n_A_1J1, n_A_1J2, n_A_1J3, n_A_1J4, n_A_1J5, n_A_1J6, 
        n_A_1J7, n_A_1J8, n_A_1J9, n_A_1J10, n_A_1J11, n_A_1J12, n_A_1J13, 
        n_A_1J14, n_A_1J15, n_A_1J16, n_A_1J17, n_A_1J18, n_A_1J19, n_A_1J20}), 
        .B({n_A_1C1, n_A_1C2, n_A_1C3, n_A_1C4, n_A_1C5, n_A_1C6, n_A_1C7, 
        n_A_1C8, n_A_1C9, n_A_1C10, n_A_1C11, n_A_1C12, n_A_1C13, n_A_1C14, 
        n_A_1C15, n_A_1C16, n_A_1C17, n_A_1C18, n_A_1C19, n_A_1C20}), .S(
        n_A_14), .Y({n_PDB23, n_PDB22, n_PDB21, n_PDB20, n_PDB19, n_PDB18, 
        n_PDB17, n_PDB16, n_PDB15, n_PDB14, n_PDB13, n_PDB12, n_PDB11, n_PDB10, 
        n_PDB09, n_PDB08, n_PDB07, n_PDB06, n_PDB05, n_PDB04}) );
  DS202 A0L ( .A({n_A_1S1, n_A_1S2, n_A_1S3, n_A_1S4, n_A_1S5, n_A_1S6, 
        n_A_1S7, n_A_1S8, n_A_1S9, n_A_1S10, n_A_1S11, n_A_1S12, n_A_1S13, 
        n_A_1S14, n_A_1S15, n_A_1S16, n_A_1S17, n_A_1S18, n_A_1S19, n_A_1S20}), 
        .B({n_A_1B1, n_A_1B2, n_A_1B3, n_A_1B4, n_A_1B5, n_A_1B6, n_A_1B7, 
        n_A_1B8, n_A_1B9, n_A_1B10, n_A_1B11, n_A_1B12, n_A_1B13, n_A_1B14, 
        n_A_1B15, n_A_1B16, n_A_1B17, n_A_1B18, n_A_1B19, n_A_1B20}), .S(
        n_A_14), .Y({n_PDA23, n_PDA22, n_PDA21, n_PDA20, n_PDA19, n_PDA18, 
        n_PDA17, n_PDA16, n_PDA15, n_PDA14, n_PDA13, n_PDA12, n_PDA11, n_PDA10, 
        n_PDA09, n_PDA08, n_PDA07, n_PDA06, n_PDA05, n_PDA04}) );
  MPX24 A0B ( .S({n_A_081, n_A_082, n_A_083, n_A_084, n_A_085}), .A({n_PDB23, 
        n_PDB22, n_PDB21, n_PDB20, n_PDB19, n_PDB18, n_PDB17, n_PDB16, n_PDB15, 
        n_PDB14, n_PDB13, n_PDB12, n_PDB11, n_PDB10, n_PDB09, n_PDB08, n_PDB07, 
        n_PDB06, n_PDB05, n_PDB04, n_PDB03, n_PDB02, n_PDB01, n_PDB00}), .Y(
        SDO2) );
  MPX24 A0A ( .S({n_A_081, n_A_082, n_A_083, n_A_084, n_A_085}), .A({n_PDA23, 
        n_PDA22, n_PDA21, n_PDA20, n_PDA19, n_PDA18, n_PDA17, n_PDA16, n_PDA15, 
        n_PDA14, n_PDA13, n_PDA12, n_PDA11, n_PDA10, n_PDA09, n_PDA08, n_PDA07, 
        n_PDA06, n_PDA05, n_PDA04, n_PDA03, n_PDA02, n_PDA01, n_PDA00}), .Y(
        SDO1) );
  FE20R A08 ( .D({n_A_0V1, n_A_0V2, n_A_0V3, n_A_0V4, n_A_0V5, n_A_0V6, 
        n_A_0V7, n_A_0V8, n_A_0V9, n_A_0V10, n_A_0V11, n_A_0V12, n_A_0V13, 
        n_A_0V14, n_A_0V15, n_A_0V16, n_A_0V17, n_A_0V18, n_A_0V19, n_A_0V20}), 
        .TI(n_A_0K), .RN(n_A_0U), .TE(n_A_0D), .CK(MCK), .EN(n_A_18), .Q({
        n_A_1C1, n_A_1C2, n_A_1C3, n_A_1C4, n_A_1C5, n_A_1C6, n_A_1C7, n_A_1C8, 
        n_A_1C9, n_A_1C10, n_A_1C11, n_A_1C12, n_A_1C13, n_A_1C14, n_A_1C15, 
        n_A_1C16, n_A_1C17, n_A_1C18, n_A_1C19, n_A_1C20}), .TO(n_A_1P) );
  FE20R A07 ( .D({n_A_0W1, n_A_0W2, n_A_0W3, n_A_0W4, n_A_0W5, n_A_0W6, 
        n_A_0W7, n_A_0W8, n_A_0W9, n_A_0W10, n_A_0W11, n_A_0W12, n_A_0W13, 
        n_A_0W14, n_A_0W15, n_A_0W16, n_A_0W17, n_A_0W18, n_A_0W19, n_A_0W20}), 
        .TI(n_A_0M), .RN(n_A_0U), .TE(n_A_0D), .CK(MCK), .EN(n_A_18), .Q({
        n_A_1J1, n_A_1J2, n_A_1J3, n_A_1J4, n_A_1J5, n_A_1J6, n_A_1J7, n_A_1J8, 
        n_A_1J9, n_A_1J10, n_A_1J11, n_A_1J12, n_A_1J13, n_A_1J14, n_A_1J15, 
        n_A_1J16, n_A_1J17, n_A_1J18, n_A_1J19, n_A_1J20}), .TO(n_A_15) );
  FE20R A06 ( .D({n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, 
        n_A_0X7, n_A_0X8, n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, 
        n_A_0X14, n_A_0X15, n_A_0X16, n_A_0X17, n_A_0X18, n_A_0X19, n_A_0X20}), 
        .TI(n_A_0P), .RN(n_A_0U), .TE(n_A_0D), .CK(MCK), .EN(n_A_18), .Q({
        n_A_1B1, n_A_1B2, n_A_1B3, n_A_1B4, n_A_1B5, n_A_1B6, n_A_1B7, n_A_1B8, 
        n_A_1B9, n_A_1B10, n_A_1B11, n_A_1B12, n_A_1B13, n_A_1B14, n_A_1B15, 
        n_A_1B16, n_A_1B17, n_A_1B18, n_A_1B19, n_A_1B20}), .TO(n_A_17) );
  FE20R A05 ( .D({n_A_0Y1, n_A_0Y2, n_A_0Y3, n_A_0Y4, n_A_0Y5, n_A_0Y6, 
        n_A_0Y7, n_A_0Y8, n_A_0Y9, n_A_0Y10, n_A_0Y11, n_A_0Y12, n_A_0Y13, 
        n_A_0Y14, n_A_0Y15, n_A_0Y16, n_A_0Y17, n_A_0Y18, n_A_0Y19, n_A_0Y20}), 
        .TI(n_A_0S), .RN(n_A_0U), .TE(n_A_0D), .CK(MCK), .EN(n_A_18), .Q({
        n_A_1S1, n_A_1S2, n_A_1S3, n_A_1S4, n_A_1S5, n_A_1S6, n_A_1S7, n_A_1S8, 
        n_A_1S9, n_A_1S10, n_A_1S11, n_A_1S12, n_A_1S13, n_A_1S14, n_A_1S15, 
        n_A_1S16, n_A_1S17, n_A_1S18, n_A_1S19, n_A_1S20}), .TO(n_A_16) );
  FE20R A04 ( .D({n_A_1L1, n_A_1L2, n_A_1L3, n_A_1L4, n_A_1L5, n_A_1L6, 
        n_A_1L7, n_A_1L8, n_A_1L9, n_A_1L10, n_A_1L11, n_A_1L12, n_A_1L13, 
        n_A_1L14, n_A_1L15, n_A_1L16, n_A_1L17, n_A_1L18, n_A_1L19, n_A_1L20}), 
        .TI(n_A_15), .RN(n_A_0U), .TE(n_A_0D), .CK(MCK), .EN(n_A_0J), .Q({
        n_A_0V1, n_A_0V2, n_A_0V3, n_A_0V4, n_A_0V5, n_A_0V6, n_A_0V7, n_A_0V8, 
        n_A_0V9, n_A_0V10, n_A_0V11, n_A_0V12, n_A_0V13, n_A_0V14, n_A_0V15, 
        n_A_0V16, n_A_0V17, n_A_0V18, n_A_0V19, n_A_0V20}), .TO(n_A_0K) );
  FE20R A03 ( .D({n_A_1L1, n_A_1L2, n_A_1L3, n_A_1L4, n_A_1L5, n_A_1L6, 
        n_A_1L7, n_A_1L8, n_A_1L9, n_A_1L10, n_A_1L11, n_A_1L12, n_A_1L13, 
        n_A_1L14, n_A_1L15, n_A_1L16, n_A_1L17, n_A_1L18, n_A_1L19, n_A_1L20}), 
        .TI(n_A_17), .RN(n_A_0U), .TE(n_A_0D), .CK(MCK), .EN(n_A_0L), .Q({
        n_A_0W1, n_A_0W2, n_A_0W3, n_A_0W4, n_A_0W5, n_A_0W6, n_A_0W7, n_A_0W8, 
        n_A_0W9, n_A_0W10, n_A_0W11, n_A_0W12, n_A_0W13, n_A_0W14, n_A_0W15, 
        n_A_0W16, n_A_0W17, n_A_0W18, n_A_0W19, n_A_0W20}), .TO(n_A_0M) );
  FE20R A02 ( .D({n_A_1L1, n_A_1L2, n_A_1L3, n_A_1L4, n_A_1L5, n_A_1L6, 
        n_A_1L7, n_A_1L8, n_A_1L9, n_A_1L10, n_A_1L11, n_A_1L12, n_A_1L13, 
        n_A_1L14, n_A_1L15, n_A_1L16, n_A_1L17, n_A_1L18, n_A_1L19, n_A_1L20}), 
        .TI(n_A_16), .RN(n_A_0U), .TE(n_A_0D), .CK(MCK), .EN(n_A_1H), .Q({
        n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, n_A_0X7, n_A_0X8, 
        n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, n_A_0X14, n_A_0X15, 
        n_A_0X16, n_A_0X17, n_A_0X18, n_A_0X19, n_A_0X20}), .TO(n_A_0P) );
  FE20R A01 ( .D({n_A_1L1, n_A_1L2, n_A_1L3, n_A_1L4, n_A_1L5, n_A_1L6, 
        n_A_1L7, n_A_1L8, n_A_1L9, n_A_1L10, n_A_1L11, n_A_1L12, n_A_1L13, 
        n_A_1L14, n_A_1L15, n_A_1L16, n_A_1L17, n_A_1L18, n_A_1L19, n_A_1L20}), 
        .TI(TI), .RN(n_A_0U), .TE(n_A_0D), .CK(MCK), .EN(n_A_1G), .Q({n_A_0Y1, 
        n_A_0Y2, n_A_0Y3, n_A_0Y4, n_A_0Y5, n_A_0Y6, n_A_0Y7, n_A_0Y8, n_A_0Y9, 
        n_A_0Y10, n_A_0Y11, n_A_0Y12, n_A_0Y13, n_A_0Y14, n_A_0Y15, n_A_0Y16, 
        n_A_0Y17, n_A_0Y18, n_A_0Y19, n_A_0Y20}), .TO(n_A_0S) );
endmodule


module MPX24 ( S, A, Y );
  input [4:0] S;
  input [23:0] A;
  output Y;
  wire   n_A_10, n_A_11, n_A_13, n_A_14, n_A_16, n_A_15, n_A_1A, n_A_19,
         n_A_18, n_A_17;

  BUFX2 A013 ( .A(S[1]), .Y(n_A_10) );
  BUFX2 A012 ( .A(S[0]), .Y(n_A_11) );
  MX2X2 A009 ( .S0(S[4]), .B(n_A_14), .A(n_A_13), .Y(Y) );
  MX2X1 A008 ( .S0(S[2]), .B(n_A_15), .A(n_A_16), .Y(n_A_14) );
  MX4X1 A007 ( .S1(S[3]), .S0(S[2]), .D(n_A_17), .C(n_A_18), .B(n_A_19), .A(
        n_A_1A), .Y(n_A_13) );
  MX4X1 A006 ( .S1(n_A_10), .S0(n_A_11), .D(A[0]), .C(A[1]), .B(A[2]), .A(A[3]), .Y(n_A_15) );
  MX4X1 A005 ( .S1(n_A_10), .S0(n_A_11), .D(A[4]), .C(A[5]), .B(A[6]), .A(A[7]), .Y(n_A_16) );
  MX4X1 A004 ( .S1(n_A_10), .S0(n_A_11), .D(A[8]), .C(A[9]), .B(A[10]), .A(
        A[11]), .Y(n_A_17) );
  MX4X1 A003 ( .S1(n_A_10), .S0(n_A_11), .D(A[12]), .C(A[13]), .B(A[14]), .A(
        A[15]), .Y(n_A_18) );
  MX4X1 A002 ( .S1(n_A_10), .S0(n_A_11), .D(A[16]), .C(A[17]), .B(A[18]), .A(
        A[19]), .Y(n_A_19) );
  MX4X1 A001 ( .S1(n_A_10), .S0(n_A_11), .D(A[20]), .C(A[21]), .B(A[22]), .A(
        A[23]), .Y(n_A_1A) );
endmodule


module PSCKG ( SBW, RN, TE, SYNC, TI, EN, CK, SO, SCK, TO, LRCK );
  input [1:0] SBW;
  output [4:0] SO;
  input RN, TE, SYNC, TI, EN, CK;
  output SCK, TO, LRCK;
  wire   n_A_0T, n_A_1F, n_A_0M, n_A_0P, n_A_0B, n_A_0F, n_A_0E, n_A_0H,
         n_A_0N, n_A_0W, n_A_17, n_A_0X, n_A_19, n_A_0V, n_A_18, n_A_13,
         n_A_0Y, n_A_0J, n_A_14, n_A_15, n_A_16, n_A_0R, n_A_0U, n_A_1B,
         n_A_1A, n_A_1C, n_A_1D, n_A_10, n_A_08;

  BUFX2 A0X ( .A(EN), .Y(n_A_0T) );
  AND2X1 A0K ( .A(n_A_1F), .B(n_A_0M), .Y(n_A_0P) );
  BUFX2 A0V ( .A(SYNC), .Y(n_A_0B) );
  BUFX2 A0U ( .A(RN), .Y(n_A_0F) );
  BUFX2 A0T ( .A(TE), .Y(n_A_0E) );
  BUFX2 A0S ( .A(n_A_0H), .Y(TO) );
  OR2X1 A0J ( .A(n_A_0B), .B(n_A_0P), .Y(n_A_0N) );
  INVX1 A0H ( .A(n_A_0W), .Y(n_A_17) );
  INVX1 A0G ( .A(n_A_0X), .Y(n_A_19) );
  INVX1 A0F ( .A(n_A_0V), .Y(n_A_18) );
  NR5 A0E ( .E(n_A_0J), .D(n_A_0V), .C(n_A_0W), .B(n_A_0X), .A(n_A_0Y), .Y(
        n_A_13) );
  NR5 A0D ( .E(n_A_0J), .D(n_A_0V), .C(n_A_0X), .B(n_A_0Y), .A(n_A_17), .Y(
        n_A_14) );
  NR5 A0C ( .E(n_A_17), .D(n_A_0J), .C(n_A_0V), .B(n_A_19), .A(n_A_0Y), .Y(
        n_A_15) );
  NR5 A0B ( .E(n_A_18), .D(n_A_0J), .C(n_A_0W), .B(n_A_0X), .A(n_A_0Y), .Y(
        n_A_16) );
  AND2X1 A0A ( .A(n_A_0H), .B(n_A_0M), .Y(n_A_0R) );
  INVX1 A09 ( .A(n_A_0V), .Y(n_A_0U) );
  AD5 A08 ( .E(n_A_0U), .D(n_A_0J), .C(n_A_0W), .B(n_A_0X), .A(n_A_0Y), .Y(
        n_A_1F) );
  AD6 A07 ( .F(SCK), .E(n_A_1D), .D(n_A_1C), .C(n_A_1B), .B(n_A_1A), .A(n_A_0T), .Y(n_A_0M) );
  MX4X1 A06 ( .S1(SBW[1]), .S0(SBW[0]), .D(n_A_13), .C(n_A_14), .B(n_A_15), 
        .A(n_A_16), .Y(n_A_10) );
  FS1R A05 ( .EN(n_A_0T), .RN(n_A_0F), .TE(n_A_0E), .TI(n_A_08), .CK(CK), .SR(
        n_A_0N), .SS(n_A_10), .Q(n_A_0H) );
  COU1 A04 ( .RN(n_A_0F), .TE(n_A_0E), .TI(SO[4]), .CK(CK), .SCL(n_A_0B), .EN(
        n_A_0P), .QN(LRCK), .Q(n_A_08) );
  CO05 A03 ( .RN(n_A_0F), .TE(n_A_0E), .CK(CK), .SCL(n_A_0N), .TI(n_A_0J), 
        .EN(n_A_0R), .Q4(SO[4]), .Q3(SO[3]), .Q2(SO[2]), .Q1(SO[1]), .Q0(SO[0]) );
  CO05 A02 ( .RN(n_A_0F), .TE(n_A_0E), .CK(CK), .SCL(n_A_0N), .TI(SCK), .EN(
        n_A_0M), .Q4(n_A_0J), .Q3(n_A_0V), .Q2(n_A_0W), .Q1(n_A_0X), .Q0(
        n_A_0Y) );
  CO05 A01 ( .RN(n_A_0F), .TE(n_A_0E), .CK(CK), .SCL(n_A_0B), .TI(TI), .EN(
        n_A_0T), .Q4(SCK), .Q3(n_A_1D), .Q2(n_A_1C), .Q1(n_A_1B), .Q0(n_A_1A)
         );
endmodule


module DC04P ( EN, B, A, Y3, Y2, Y1, Y0 );
  input EN, B, A;
  output Y3, Y2, Y1, Y0;
  wire   n_A_0C, n_A_07, n_A_09, n_A_06, n_A_08;

  BUFX2 A09 ( .A(EN), .Y(n_A_0C) );
  INVX1 A08 ( .A(n_A_07), .Y(n_A_09) );
  INVX1 A07 ( .A(n_A_06), .Y(n_A_08) );
  BUFX2 A06 ( .A(B), .Y(n_A_07) );
  BUFX2 A05 ( .A(A), .Y(n_A_06) );
  AND3X1 A04 ( .A(n_A_06), .B(n_A_07), .C(n_A_0C), .Y(Y3) );
  AND3X1 A03 ( .A(n_A_08), .B(n_A_07), .C(n_A_0C), .Y(Y2) );
  AND3X1 A02 ( .A(n_A_06), .B(n_A_09), .C(n_A_0C), .Y(Y1) );
  AND3X1 A01 ( .A(n_A_08), .B(n_A_09), .C(n_A_0C), .Y(Y0) );
endmodule


module ETXD ( EDBR, XRST, ESYNC, TI, TXRDY, TXEN, TE, TXLDLE, MCK, TXRDLE, TXD, 
        TXSYNC, TXRD, TO );
  input [15:0] EDBR;
  output [31:0] TXD;
  input XRST, ESYNC, TI, TXRDY, TXEN, TE, TXLDLE, MCK, TXRDLE;
  output TXSYNC, TXRD, TO;
  wire   n_A_0X, n_A_05, n_A_09, n_A_0K, n_A_0E, n_A_0J, n_A_0S1, n_A_0S2,
         n_A_0S3, n_A_0S4, n_A_0S5, n_A_0S6, n_A_0S7, n_A_0S8, n_A_0S9,
         n_A_0S10, n_A_0S11, n_A_0S12, n_A_0S13, n_A_0S14, n_A_0S15, n_A_0S16,
         n_A_0T1, n_A_0T2, n_A_0T3, n_A_0T4, n_A_0T5, n_A_0T6, n_A_0T7,
         n_A_0T8, n_A_0T9, n_A_0T10, n_A_0T11, n_A_0T12, n_A_0T13, n_A_0T14,
         n_A_0T15, n_A_0T16, n_A_0W1, n_A_0W2, n_A_0W3, n_A_0W4, n_A_0W5,
         n_A_0W6, n_A_0W7, n_A_0W8, n_A_0W9, n_A_0W10, n_A_0W11, n_A_0W12,
         n_A_0W13, n_A_0W14, n_A_0W15, n_A_0W16, n_A_0V1, n_A_0V2, n_A_0V3,
         n_A_0V4, n_A_0V5, n_A_0V6, n_A_0V7, n_A_0V8, n_A_0V9, n_A_0V10,
         n_A_0V11, n_A_0V12, n_A_0V13, n_A_0V14, n_A_0V15, n_A_0V16, n_A_0B,
         n_A_0C, n_A_0D;

  TIEHI A0X ( .Y(n_A_0X) );
  BUFX2 A0F ( .A(XRST), .Y(n_A_05) );
  BUFX2 A0E ( .A(TE), .Y(n_A_09) );
  BUFX2 A0D ( .A(ESYNC), .Y(n_A_0K) );
  FE1R A0C ( .RN(n_A_05), .TE(n_A_09), .TI(TI), .CK(MCK), .EN(n_A_0X), .D(
        TXRDY), .Q(n_A_0E) );
  BUFX2 A0B ( .A(TXEN), .Y(n_A_0J) );
  EN16 A08 ( .A({n_A_0S1, n_A_0S2, n_A_0S3, n_A_0S4, n_A_0S5, n_A_0S6, n_A_0S7, 
        n_A_0S8, n_A_0S9, n_A_0S10, n_A_0S11, n_A_0S12, n_A_0S13, n_A_0S14, 
        n_A_0S15, n_A_0S16}), .EN(n_A_0J), .Y({n_A_0T1, n_A_0T2, n_A_0T3, 
        n_A_0T4, n_A_0T5, n_A_0T6, n_A_0T7, n_A_0T8, n_A_0T9, n_A_0T10, 
        n_A_0T11, n_A_0T12, n_A_0T13, n_A_0T14, n_A_0T15, n_A_0T16}) );
  EN16 A07 ( .A({n_A_0W1, n_A_0W2, n_A_0W3, n_A_0W4, n_A_0W5, n_A_0W6, n_A_0W7, 
        n_A_0W8, n_A_0W9, n_A_0W10, n_A_0W11, n_A_0W12, n_A_0W13, n_A_0W14, 
        n_A_0W15, n_A_0W16}), .EN(n_A_0J), .Y({n_A_0V1, n_A_0V2, n_A_0V3, 
        n_A_0V4, n_A_0V5, n_A_0V6, n_A_0V7, n_A_0V8, n_A_0V9, n_A_0V10, 
        n_A_0V11, n_A_0V12, n_A_0V13, n_A_0V14, n_A_0V15, n_A_0V16}) );
  AND2X2 A06 ( .A(n_A_0J), .B(n_A_0K), .Y(TXSYNC) );
  AND2X2 A05 ( .A(n_A_0J), .B(n_A_0E), .Y(TXRD) );
  FE16R A04 ( .D({n_A_0T1, n_A_0T2, n_A_0T3, n_A_0T4, n_A_0T5, n_A_0T6, 
        n_A_0T7, n_A_0T8, n_A_0T9, n_A_0T10, n_A_0T11, n_A_0T12, n_A_0T13, 
        n_A_0T14, n_A_0T15, n_A_0T16}), .TI(n_A_0B), .RN(n_A_05), .TE(n_A_09), 
        .CK(MCK), .EN(n_A_0K), .Q(TXD[15:0]), .TO(TO) );
  FE16R A03 ( .D({n_A_0V1, n_A_0V2, n_A_0V3, n_A_0V4, n_A_0V5, n_A_0V6, 
        n_A_0V7, n_A_0V8, n_A_0V9, n_A_0V10, n_A_0V11, n_A_0V12, n_A_0V13, 
        n_A_0V14, n_A_0V15, n_A_0V16}), .TI(n_A_0C), .RN(n_A_05), .TE(n_A_09), 
        .CK(MCK), .EN(n_A_0K), .Q(TXD[31:16]), .TO(n_A_0B) );
  FE16R A02 ( .D(EDBR), .TI(n_A_0E), .RN(n_A_05), .TE(n_A_09), .CK(MCK), .EN(
        TXLDLE), .Q({n_A_0S1, n_A_0S2, n_A_0S3, n_A_0S4, n_A_0S5, n_A_0S6, 
        n_A_0S7, n_A_0S8, n_A_0S9, n_A_0S10, n_A_0S11, n_A_0S12, n_A_0S13, 
        n_A_0S14, n_A_0S15, n_A_0S16}), .TO(n_A_0D) );
  FE16R A01 ( .D(EDBR), .TI(n_A_0D), .RN(n_A_05), .TE(n_A_09), .CK(MCK), .EN(
        TXRDLE), .Q({n_A_0W1, n_A_0W2, n_A_0W3, n_A_0W4, n_A_0W5, n_A_0W6, 
        n_A_0W7, n_A_0W8, n_A_0W9, n_A_0W10, n_A_0W11, n_A_0W12, n_A_0W13, 
        n_A_0W14, n_A_0W15, n_A_0W16}), .TO(n_A_0C) );
endmodule


module EEMIF ( EIMDO, EMCL, TI, XRST, TE, MCK, EEMALE, EEMADCR, EEMDOLE, EEMDI, 
        EEMA, TO );
  input [15:0] EIMDO;
  output [15:0] EEMDI;
  output [15:0] EEMA;
  input EMCL, TI, XRST, TE, MCK, EEMALE, EEMADCR, EEMDOLE;
  output TO;
  wire   n_A_0116, n_A_0115, n_A_0114, n_A_0113, n_A_0112, n_A_0111, n_A_0110,
         n_A_019, n_A_018, n_A_017, n_A_016, n_A_015, n_A_014, n_A_013,
         n_A_012, n_A_13, n_A_0J1, n_A_0J2, n_A_0J3, n_A_0J4, n_A_0J5, n_A_0J6,
         n_A_0J7, n_A_0J8, n_A_0J9, n_A_0J10, n_A_0J11, n_A_0J12, n_A_0J13,
         n_A_0J14, n_A_0J15, n_A_0J16, n_A_011, n_A_12, n_A_0L, n_A_0V,
         n_A_0T1, n_A_0T2, n_A_0T3, n_A_0T4, n_A_0T5, n_A_0T6, n_A_0T7,
         n_A_0T8, n_A_0T9, n_A_0T10, n_A_0T11, n_A_0T12, n_A_0T13, n_A_0T14,
         n_A_0T15, n_A_0T16, n_A_0U1, n_A_0U2, n_A_0U3, n_A_0U4, n_A_0U5,
         n_A_0U6, n_A_0U7, n_A_0U8, n_A_0U9, n_A_0U10, n_A_0U11, n_A_0U12,
         n_A_0U13, n_A_0U14, n_A_0U15, n_A_0U16, n_A_0F, n_A_101, n_A_102,
         n_A_103, n_A_104, n_A_105, n_A_106, n_A_107, n_A_108, n_A_109,
         n_A_1010, n_A_1011, n_A_1012, n_A_1013, n_A_1014, n_A_1015, n_A_1016;

  BUFX2 A100 ( .A(n_A_0116), .Y(EEMA[0]) );
  BUFX2 A101 ( .A(n_A_0115), .Y(EEMA[1]) );
  BUFX2 A102 ( .A(n_A_0114), .Y(EEMA[2]) );
  BUFX2 A103 ( .A(n_A_0113), .Y(EEMA[3]) );
  BUFX2 A104 ( .A(n_A_0112), .Y(EEMA[4]) );
  BUFX2 A105 ( .A(n_A_0111), .Y(EEMA[5]) );
  BUFX2 A106 ( .A(n_A_0110), .Y(EEMA[6]) );
  BUFX2 A107 ( .A(n_A_019), .Y(EEMA[7]) );
  BUFX2 A108 ( .A(n_A_018), .Y(EEMA[8]) );
  BUFX2 A109 ( .A(n_A_017), .Y(EEMA[9]) );
  BUFX2 A110 ( .A(n_A_016), .Y(EEMA[10]) );
  BUFX2 A111 ( .A(n_A_015), .Y(EEMA[11]) );
  BUFX2 A112 ( .A(n_A_014), .Y(EEMA[12]) );
  BUFX2 A113 ( .A(n_A_013), .Y(EEMA[13]) );
  BUFX2 A114 ( .A(n_A_012), .Y(EEMA[14]) );
  INVX1 A0E ( .A(EMCL), .Y(n_A_13) );
  EN16 A0D ( .A({n_A_0J1, n_A_0J2, n_A_0J3, n_A_0J4, n_A_0J5, n_A_0J6, n_A_0J7, 
        n_A_0J8, n_A_0J9, n_A_0J10, n_A_0J11, n_A_0J12, n_A_0J13, n_A_0J14, 
        n_A_0J15, n_A_0J16}), .EN(n_A_13), .Y(EEMDI) );
  BUFX2 A115 ( .A(n_A_011), .Y(EEMA[15]) );
  FE16R A0A ( .D(EIMDO), .TI(TI), .RN(n_A_0L), .TE(n_A_12), .CK(MCK), .EN(
        EEMDOLE), .Q({n_A_0J1, n_A_0J2, n_A_0J3, n_A_0J4, n_A_0J5, n_A_0J6, 
        n_A_0J7, n_A_0J8, n_A_0J9, n_A_0J10, n_A_0J11, n_A_0J12, n_A_0J13, 
        n_A_0J14, n_A_0J15, n_A_0J16}), .TO(n_A_0V) );
  BUFX2 A11 ( .A(TE), .Y(n_A_12) );
  BUFX2 A10 ( .A(XRST), .Y(n_A_0L) );
  DCR16 A0H ( .A({n_A_0T1, n_A_0T2, n_A_0T3, n_A_0T4, n_A_0T5, n_A_0T6, 
        n_A_0T7, n_A_0T8, n_A_0T9, n_A_0T10, n_A_0T11, n_A_0T12, n_A_0T13, 
        n_A_0T14, n_A_0T15, n_A_0T16}), .DCR(EEMADCR), .Y({n_A_0U1, n_A_0U2, 
        n_A_0U3, n_A_0U4, n_A_0U5, n_A_0U6, n_A_0U7, n_A_0U8, n_A_0U9, 
        n_A_0U10, n_A_0U11, n_A_0U12, n_A_0U13, n_A_0U14, n_A_0U15, n_A_0U16})
         );
  FE16R A05 ( .D(EIMDO), .TI(n_A_0V), .RN(n_A_0L), .TE(n_A_12), .CK(MCK), .EN(
        EEMALE), .Q({n_A_0T1, n_A_0T2, n_A_0T3, n_A_0T4, n_A_0T5, n_A_0T6, 
        n_A_0T7, n_A_0T8, n_A_0T9, n_A_0T10, n_A_0T11, n_A_0T12, n_A_0T13, 
        n_A_0T14, n_A_0T15, n_A_0T16}), .TO(n_A_0F) );
  FE16R A03 ( .D({n_A_011, n_A_012, n_A_013, n_A_014, n_A_015, n_A_016, 
        n_A_017, n_A_018, n_A_019, n_A_0110, n_A_0111, n_A_0112, n_A_0113, 
        n_A_0114, n_A_0115, n_A_0116}), .TI(n_A_0F), .RN(n_A_0L), .TE(n_A_12), 
        .CK(MCK), .EN(EEMADCR), .Q({n_A_101, n_A_102, n_A_103, n_A_104, 
        n_A_105, n_A_106, n_A_107, n_A_108, n_A_109, n_A_1010, n_A_1011, 
        n_A_1012, n_A_1013, n_A_1014, n_A_1015, n_A_1016}), .TO(TO) );
  ADD16 A01 ( .A({n_A_0U1, n_A_0U2, n_A_0U3, n_A_0U4, n_A_0U5, n_A_0U6, 
        n_A_0U7, n_A_0U8, n_A_0U9, n_A_0U10, n_A_0U11, n_A_0U12, n_A_0U13, 
        n_A_0U14, n_A_0U15, n_A_0U16}), .B({n_A_101, n_A_102, n_A_103, n_A_104, 
        n_A_105, n_A_106, n_A_107, n_A_108, n_A_109, n_A_1010, n_A_1011, 
        n_A_1012, n_A_1013, n_A_1014, n_A_1015, n_A_1016}), .S({n_A_011, 
        n_A_012, n_A_013, n_A_014, n_A_015, n_A_016, n_A_017, n_A_018, n_A_019, 
        n_A_0110, n_A_0111, n_A_0112, n_A_0113, n_A_0114, n_A_0115, n_A_0116})
         );
endmodule


module ADD16 ( A, B, S, CO );
  input [15:0] A;
  input [15:0] B;
  output [15:0] S;
  output CO;
  wire   n_A_051, n_A_052, n_A_053, n_A_054, n_A_055, n_A_056, n_A_057,
         n_A_058, n_A_059, n_A_0510, n_A_0511, n_A_0512, n_A_0513, n_A_0514,
         n_A_0515, n_A_0516, n_A_061, n_A_062, n_A_063, n_A_064, n_A_065,
         n_A_066, n_A_067, n_A_068, n_A_069, n_A_0610, n_A_0611, n_A_0612,
         n_A_0613, n_A_0614, n_A_0615, n_A_0616;

  CS16 A002 ( .PN({n_A_061, n_A_062, n_A_063, n_A_064, n_A_065, n_A_066, 
        n_A_067, n_A_068, n_A_069, n_A_0610, n_A_0611, n_A_0612, n_A_0613, 
        n_A_0614, n_A_0615, n_A_0616}), .GN({n_A_051, n_A_052, n_A_053, 
        n_A_054, n_A_055, n_A_056, n_A_057, n_A_058, n_A_059, n_A_0510, 
        n_A_0511, n_A_0512, n_A_0513, n_A_0514, n_A_0515, n_A_0516}), .S(S), 
        .CO(CO) );
  PG16 A001 ( .A(A), .B(B), .GN({n_A_051, n_A_052, n_A_053, n_A_054, n_A_055, 
        n_A_056, n_A_057, n_A_058, n_A_059, n_A_0510, n_A_0511, n_A_0512, 
        n_A_0513, n_A_0514, n_A_0515, n_A_0516}), .PN({n_A_061, n_A_062, 
        n_A_063, n_A_064, n_A_065, n_A_066, n_A_067, n_A_068, n_A_069, 
        n_A_0610, n_A_0611, n_A_0612, n_A_0613, n_A_0614, n_A_0615, n_A_0616})
         );
endmodule


module PG16 ( A, B, GN, PN );
  input [15:0] A;
  input [15:0] B;
  output [15:0] GN;
  output [15:0] PN;


  NAND2X2 A101 ( .A(A[0]), .B(B[0]), .Y(GN[0]) );
  XNOR2X2 A001 ( .A(A[0]), .B(B[0]), .Y(PN[0]) );
  NAND2X2 A10G ( .A(A[15]), .B(B[15]), .Y(GN[15]) );
  NAND2X2 A10F ( .A(A[14]), .B(B[14]), .Y(GN[14]) );
  NAND2X2 A10E ( .A(A[13]), .B(B[13]), .Y(GN[13]) );
  NAND2X2 A10D ( .A(A[12]), .B(B[12]), .Y(GN[12]) );
  NAND2X2 A10C ( .A(A[11]), .B(B[11]), .Y(GN[11]) );
  NAND2X2 A10B ( .A(A[10]), .B(B[10]), .Y(GN[10]) );
  NAND2X2 A10A ( .A(A[9]), .B(B[9]), .Y(GN[9]) );
  NAND2X2 A109 ( .A(A[8]), .B(B[8]), .Y(GN[8]) );
  NAND2X2 A108 ( .A(A[7]), .B(B[7]), .Y(GN[7]) );
  NAND2X2 A107 ( .A(A[6]), .B(B[6]), .Y(GN[6]) );
  NAND2X2 A106 ( .A(A[5]), .B(B[5]), .Y(GN[5]) );
  NAND2X2 A105 ( .A(A[4]), .B(B[4]), .Y(GN[4]) );
  NAND2X2 A104 ( .A(A[3]), .B(B[3]), .Y(GN[3]) );
  NAND2X2 A103 ( .A(A[2]), .B(B[2]), .Y(GN[2]) );
  NAND2X2 A102 ( .A(A[1]), .B(B[1]), .Y(GN[1]) );
  XNOR2X2 A0G ( .A(A[15]), .B(B[15]), .Y(PN[15]) );
  XNOR2X2 A0F ( .A(A[14]), .B(B[14]), .Y(PN[14]) );
  XNOR2X2 A0E ( .A(A[13]), .B(B[13]), .Y(PN[13]) );
  XNOR2X2 A00D ( .A(A[12]), .B(B[12]), .Y(PN[12]) );
  XNOR2X2 A00C ( .A(A[11]), .B(B[11]), .Y(PN[11]) );
  XNOR2X2 A00B ( .A(A[10]), .B(B[10]), .Y(PN[10]) );
  XNOR2X2 A00A ( .A(A[9]), .B(B[9]), .Y(PN[9]) );
  XNOR2X2 A009 ( .A(A[8]), .B(B[8]), .Y(PN[8]) );
  XNOR2X2 A008 ( .A(A[7]), .B(B[7]), .Y(PN[7]) );
  XNOR2X2 A007 ( .A(A[6]), .B(B[6]), .Y(PN[6]) );
  XNOR2X2 A006 ( .A(A[5]), .B(B[5]), .Y(PN[5]) );
  XNOR2X2 A005 ( .A(A[4]), .B(B[4]), .Y(PN[4]) );
  XNOR2X2 A004 ( .A(A[3]), .B(B[3]), .Y(PN[3]) );
  XNOR2X2 A003 ( .A(A[2]), .B(B[2]), .Y(PN[2]) );
  XNOR2X2 A002 ( .A(A[1]), .B(B[1]), .Y(PN[1]) );
endmodule


module DCR16 ( A, DCR, Y );
  input [15:0] A;
  output [15:0] Y;
  input DCR;
  wire   n_A_02;

  OR2X1 A100 ( .A(A[0]), .B(n_A_02), .Y(Y[0]) );
  OR2X1 A101 ( .A(A[1]), .B(n_A_02), .Y(Y[1]) );
  OR2X1 A102 ( .A(A[2]), .B(n_A_02), .Y(Y[2]) );
  OR2X1 A103 ( .A(A[3]), .B(n_A_02), .Y(Y[3]) );
  OR2X1 A104 ( .A(A[4]), .B(n_A_02), .Y(Y[4]) );
  OR2X1 A105 ( .A(A[5]), .B(n_A_02), .Y(Y[5]) );
  OR2X1 A106 ( .A(A[6]), .B(n_A_02), .Y(Y[6]) );
  OR2X1 A107 ( .A(A[7]), .B(n_A_02), .Y(Y[7]) );
  OR2X1 A108 ( .A(A[8]), .B(n_A_02), .Y(Y[8]) );
  OR2X1 A109 ( .A(A[9]), .B(n_A_02), .Y(Y[9]) );
  OR2X1 A110 ( .A(A[10]), .B(n_A_02), .Y(Y[10]) );
  OR2X1 A111 ( .A(A[11]), .B(n_A_02), .Y(Y[11]) );
  OR2X1 A112 ( .A(A[12]), .B(n_A_02), .Y(Y[12]) );
  OR2X1 A113 ( .A(A[13]), .B(n_A_02), .Y(Y[13]) );
  OR2X1 A114 ( .A(A[14]), .B(n_A_02), .Y(Y[14]) );
  OR2X1 A115 ( .A(A[15]), .B(n_A_02), .Y(Y[15]) );
  BUFX4 A003 ( .A(DCR), .Y(n_A_02) );
endmodule


module ESPCV ( MCHS, SDI2, XRST, TI, ESYNC, ENP, TE, SDI1, MCK, LRS, SPCO, 
        LRCK, SCK, TO );
  output [19:0] SPCO;
  input MCHS, SDI2, XRST, TI, ESYNC, ENP, TE, SDI1, MCK, LRS;
  output LRCK, SCK, TO;
  wire   n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, n_A_0X7,
         n_A_0X8, n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, n_A_0X14,
         n_A_0X15, n_A_0X16, n_A_0X17, n_A_0X18, n_A_0X19, n_A_0X20, n_A_051,
         n_A_052, n_A_053, n_A_054, n_A_055, n_A_056, n_A_057, n_A_058,
         n_A_059, n_A_0510, n_A_0511, n_A_0512, n_A_0513, n_A_0514, n_A_0515,
         n_A_0516, n_A_0517, n_A_0518, n_A_0519, n_A_0520, n_A_0M1, n_A_0M2,
         n_A_0M3, n_A_0M4, n_A_0M5, n_A_0M6, n_A_0M7, n_A_0M8, n_A_0M9,
         n_A_0M10, n_A_0M11, n_A_0M12, n_A_0M13, n_A_0M14, n_A_0M15, n_A_0M16,
         n_A_0M17, n_A_0M18, n_A_0M19, n_A_0M20, n_A_0L1, n_A_0L2, n_A_0L3,
         n_A_0L4, n_A_0L5, n_A_0L6, n_A_0L7, n_A_0L8, n_A_0L9, n_A_0L10,
         n_A_0L11, n_A_0L12, n_A_0L13, n_A_0L14, n_A_0L15, n_A_0L16, n_A_0L17,
         n_A_0L18, n_A_0L19, n_A_0L20, n_A_04, n_A_0C, n_A_12, n_A_0E, n_A_11,
         n_A_0J1, n_A_0J2, n_A_0J3, n_A_0J4, n_A_0J5, n_A_0J6, n_A_0J7,
         n_A_0J8, n_A_0J9, n_A_0J10, n_A_0J11, n_A_0J12, n_A_0J13, n_A_0J14,
         n_A_0J15, n_A_0J16, n_A_0J17, n_A_0J18, n_A_0J19, n_A_0J20, n_A_13,
         n_A_161, n_A_162, n_A_163, n_A_164, n_A_165, n_A_166, n_A_167,
         n_A_168, n_A_169, n_A_1610, n_A_1611, n_A_1612, n_A_1613, n_A_1614,
         n_A_1615, n_A_1616, n_A_1617, n_A_1618, n_A_1619, n_A_1620, n_A_0D,
         n_A_14, n_A_10, n_A_0Y, n_A_0P, n_A_0T, n_A_06, n_A_09, n_A_0U1,
         n_A_0U2, n_A_0U3, n_A_0U4, n_A_0U5, n_A_0U6, n_A_0U7, n_A_0U8,
         n_A_0U9, n_A_0U10, n_A_0U11, n_A_0U12, n_A_0U13, n_A_0U14, n_A_0U15,
         n_A_0U16, n_A_0U17, n_A_0U18, n_A_0U19, n_A_0U20, n_A_0A, n_A_0V1,
         n_A_0V2, n_A_0V3, n_A_0V4, n_A_0V5, n_A_0V6, n_A_0V7, n_A_0V8,
         n_A_0V9, n_A_0V10, n_A_0V11, n_A_0V12, n_A_0V13, n_A_0V14, n_A_0V15,
         n_A_0V16, n_A_0V17, n_A_0V18, n_A_0V19, n_A_0V20, n_A_0B;

  DS204 A05 ( .A({n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, 
        n_A_0X7, n_A_0X8, n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, 
        n_A_0X14, n_A_0X15, n_A_0X16, n_A_0X17, n_A_0X18, n_A_0X19, n_A_0X20}), 
        .B({n_A_051, n_A_052, n_A_053, n_A_054, n_A_055, n_A_056, n_A_057, 
        n_A_058, n_A_059, n_A_0510, n_A_0511, n_A_0512, n_A_0513, n_A_0514, 
        n_A_0515, n_A_0516, n_A_0517, n_A_0518, n_A_0519, n_A_0520}), .C({
        n_A_0M1, n_A_0M2, n_A_0M3, n_A_0M4, n_A_0M5, n_A_0M6, n_A_0M7, n_A_0M8, 
        n_A_0M9, n_A_0M10, n_A_0M11, n_A_0M12, n_A_0M13, n_A_0M14, n_A_0M15, 
        n_A_0M16, n_A_0M17, n_A_0M18, n_A_0M19, n_A_0M20}), .D({n_A_0L1, 
        n_A_0L2, n_A_0L3, n_A_0L4, n_A_0L5, n_A_0L6, n_A_0L7, n_A_0L8, n_A_0L9, 
        n_A_0L10, n_A_0L11, n_A_0L12, n_A_0L13, n_A_0L14, n_A_0L15, n_A_0L16, 
        n_A_0L17, n_A_0L18, n_A_0L19, n_A_0L20}), .S1(MCHS), .S0(LRS), .Y(SPCO) );
  FE20R A0V ( .D({n_A_0J1, n_A_0J2, n_A_0J3, n_A_0J4, n_A_0J5, n_A_0J6, 
        n_A_0J7, n_A_0J8, n_A_0J9, n_A_0J10, n_A_0J11, n_A_0J12, n_A_0J13, 
        n_A_0J14, n_A_0J15, n_A_0J16, n_A_0J17, n_A_0J18, n_A_0J19, n_A_0J20}), 
        .TI(n_A_12), .RN(n_A_04), .TE(n_A_0E), .CK(MCK), .EN(n_A_0C), .Q({
        n_A_0L1, n_A_0L2, n_A_0L3, n_A_0L4, n_A_0L5, n_A_0L6, n_A_0L7, n_A_0L8, 
        n_A_0L9, n_A_0L10, n_A_0L11, n_A_0L12, n_A_0L13, n_A_0L14, n_A_0L15, 
        n_A_0L16, n_A_0L17, n_A_0L18, n_A_0L19, n_A_0L20}), .TO(n_A_11) );
  FE20R A0U ( .D({n_A_161, n_A_162, n_A_163, n_A_164, n_A_165, n_A_166, 
        n_A_167, n_A_168, n_A_169, n_A_1610, n_A_1611, n_A_1612, n_A_1613, 
        n_A_1614, n_A_1615, n_A_1616, n_A_1617, n_A_1618, n_A_1619, n_A_1620}), 
        .TI(n_A_13), .RN(n_A_04), .TE(n_A_0E), .CK(MCK), .EN(n_A_0C), .Q({
        n_A_0M1, n_A_0M2, n_A_0M3, n_A_0M4, n_A_0M5, n_A_0M6, n_A_0M7, n_A_0M8, 
        n_A_0M9, n_A_0M10, n_A_0M11, n_A_0M12, n_A_0M13, n_A_0M14, n_A_0M15, 
        n_A_0M16, n_A_0M17, n_A_0M18, n_A_0M19, n_A_0M20}), .TO(n_A_12) );
  FE20R A0T ( .D({n_A_0J1, n_A_0J2, n_A_0J3, n_A_0J4, n_A_0J5, n_A_0J6, 
        n_A_0J7, n_A_0J8, n_A_0J9, n_A_0J10, n_A_0J11, n_A_0J12, n_A_0J13, 
        n_A_0J14, n_A_0J15, n_A_0J16, n_A_0J17, n_A_0J18, n_A_0J19, n_A_0J20}), 
        .TI(n_A_14), .RN(n_A_04), .TE(n_A_0E), .CK(MCK), .EN(n_A_0D), .Q({
        n_A_161, n_A_162, n_A_163, n_A_164, n_A_165, n_A_166, n_A_167, n_A_168, 
        n_A_169, n_A_1610, n_A_1611, n_A_1612, n_A_1613, n_A_1614, n_A_1615, 
        n_A_1616, n_A_1617, n_A_1618, n_A_1619, n_A_1620}), .TO(n_A_13) );
  SPC24 A0S ( .RN(n_A_04), .TE(n_A_0E), .TI(n_A_0Y), .EN(n_A_10), .D(SDI2), 
        .CK(MCK), .Q({n_A_0J1, n_A_0J2, n_A_0J3, n_A_0J4, n_A_0J5, n_A_0J6, 
        n_A_0J7, n_A_0J8, n_A_0J9, n_A_0J10, n_A_0J11, n_A_0J12, n_A_0J13, 
        n_A_0J14, n_A_0J15, n_A_0J16, n_A_0J17, n_A_0J18, n_A_0J19, n_A_0J20}), 
        .TO(n_A_14) );
  SPCKG A06 ( .RN(n_A_04), .TE(n_A_0E), .TI(TI), .SYNC(ESYNC), .EN(ENP), .CK(
        MCK), .SCK(n_A_0P), .LRCK(n_A_0T), .TO(n_A_06) );
  BUFX2 A0B ( .A(XRST), .Y(n_A_04) );
  BUFX2 A0A ( .A(TE), .Y(n_A_0E) );
  BUFX2 A09 ( .A(n_A_0T), .Y(LRCK) );
  BUFX2 A08 ( .A(n_A_0P), .Y(SCK) );
  SDLTG A07 ( .SCK(n_A_0P), .RN(n_A_04), .TE(n_A_0E), .TI(n_A_06), .LRCK(
        n_A_0T), .ENP(ENP), .CK(MCK), .SDLE(n_A_10), .TO(n_A_0Y), .LLE(n_A_0D), 
        .RLE(n_A_0C) );
  FE20R A04 ( .D({n_A_0U1, n_A_0U2, n_A_0U3, n_A_0U4, n_A_0U5, n_A_0U6, 
        n_A_0U7, n_A_0U8, n_A_0U9, n_A_0U10, n_A_0U11, n_A_0U12, n_A_0U13, 
        n_A_0U14, n_A_0U15, n_A_0U16, n_A_0U17, n_A_0U18, n_A_0U19, n_A_0U20}), 
        .TI(n_A_09), .RN(n_A_04), .TE(n_A_0E), .CK(MCK), .EN(n_A_0C), .Q({
        n_A_051, n_A_052, n_A_053, n_A_054, n_A_055, n_A_056, n_A_057, n_A_058, 
        n_A_059, n_A_0510, n_A_0511, n_A_0512, n_A_0513, n_A_0514, n_A_0515, 
        n_A_0516, n_A_0517, n_A_0518, n_A_0519, n_A_0520}), .TO(TO) );
  FE20R A03 ( .D({n_A_0V1, n_A_0V2, n_A_0V3, n_A_0V4, n_A_0V5, n_A_0V6, 
        n_A_0V7, n_A_0V8, n_A_0V9, n_A_0V10, n_A_0V11, n_A_0V12, n_A_0V13, 
        n_A_0V14, n_A_0V15, n_A_0V16, n_A_0V17, n_A_0V18, n_A_0V19, n_A_0V20}), 
        .TI(n_A_0A), .RN(n_A_04), .TE(n_A_0E), .CK(MCK), .EN(n_A_0C), .Q({
        n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, n_A_0X7, n_A_0X8, 
        n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, n_A_0X14, n_A_0X15, 
        n_A_0X16, n_A_0X17, n_A_0X18, n_A_0X19, n_A_0X20}), .TO(n_A_09) );
  FE20R A02 ( .D({n_A_0U1, n_A_0U2, n_A_0U3, n_A_0U4, n_A_0U5, n_A_0U6, 
        n_A_0U7, n_A_0U8, n_A_0U9, n_A_0U10, n_A_0U11, n_A_0U12, n_A_0U13, 
        n_A_0U14, n_A_0U15, n_A_0U16, n_A_0U17, n_A_0U18, n_A_0U19, n_A_0U20}), 
        .TI(n_A_0B), .RN(n_A_04), .TE(n_A_0E), .CK(MCK), .EN(n_A_0D), .Q({
        n_A_0V1, n_A_0V2, n_A_0V3, n_A_0V4, n_A_0V5, n_A_0V6, n_A_0V7, n_A_0V8, 
        n_A_0V9, n_A_0V10, n_A_0V11, n_A_0V12, n_A_0V13, n_A_0V14, n_A_0V15, 
        n_A_0V16, n_A_0V17, n_A_0V18, n_A_0V19, n_A_0V20}), .TO(n_A_0A) );
  SPC24 A01 ( .RN(n_A_04), .TE(n_A_0E), .TI(n_A_11), .EN(n_A_10), .D(SDI1), 
        .CK(MCK), .Q({n_A_0U1, n_A_0U2, n_A_0U3, n_A_0U4, n_A_0U5, n_A_0U6, 
        n_A_0U7, n_A_0U8, n_A_0U9, n_A_0U10, n_A_0U11, n_A_0U12, n_A_0U13, 
        n_A_0U14, n_A_0U15, n_A_0U16, n_A_0U17, n_A_0U18, n_A_0U19, n_A_0U20}), 
        .TO(n_A_0B) );
endmodule


module SDLTG ( SCK, RN, TE, TI, LRCK, ENP, CK, SDLE, TO, LLE, RLE );
  input SCK, RN, TE, TI, LRCK, ENP, CK;
  output SDLE, TO, LLE, RLE;
  wire   n_A_0L, n_A_0C, n_A_0M, n_A_0D, n_A_05, n_A_07, n_A_0F, n_A_0E,
         n_A_0H, n_A_0G, n_A_0B;

  BUFX2 A0P ( .A(SCK), .Y(n_A_0L) );
  INVX1 A0S ( .A(n_A_0C), .Y(n_A_0M) );
  AND3X1 A0R ( .A(n_A_0D), .B(n_A_0L), .C(n_A_0M), .Y(SDLE) );
  FE1R A0M ( .RN(n_A_05), .TE(n_A_07), .TI(TI), .CK(CK), .EN(n_A_0D), .D(
        n_A_0L), .Q(n_A_0C) );
  BUFX2 A0B ( .A(RN), .Y(n_A_05) );
  BUFX2 A0A ( .A(TE), .Y(n_A_07) );
  BUFX2 A03 ( .A(LRCK), .Y(n_A_0F) );
  AND3X1 A08 ( .A(n_A_0D), .B(n_A_0E), .C(n_A_0H), .Y(LLE) );
  AND3X1 A09 ( .A(n_A_0D), .B(n_A_0F), .C(n_A_0G), .Y(RLE) );
  INVX1 A07 ( .A(TO), .Y(n_A_0H) );
  INVX1 A06 ( .A(n_A_0B), .Y(n_A_0G) );
  BUFX2 A05 ( .A(ENP), .Y(n_A_0D) );
  INVX1 A04 ( .A(n_A_0F), .Y(n_A_0E) );
  FE1R A02 ( .RN(n_A_05), .TE(n_A_07), .TI(n_A_0B), .CK(CK), .EN(n_A_0D), .D(
        n_A_0E), .Q(TO) );
  FE1R A01 ( .RN(n_A_05), .TE(n_A_07), .TI(n_A_0C), .CK(CK), .EN(n_A_0D), .D(
        n_A_0F), .Q(n_A_0B) );
endmodule


module SPCKG ( RN, TE, TI, SYNC, EN, CK, SCK, LRCK, TO );
  input RN, TE, TI, SYNC, EN, CK;
  output SCK, LRCK, TO;
  wire   n_A_0N, n_A_0T, n_A_0P, n_A_0R, n_A_0F, n_A_06, n_A_05, n_A_0C,
         n_A_0D, n_A_0G, n_A_0H, n_A_0J, n_A_0K, n_A_0L, n_A_0M, n_A_02;

  AD6 A04 ( .F(SCK), .E(n_A_0R), .D(n_A_0P), .C(n_A_0N), .B(n_A_0T), .A(EN), 
        .Y(n_A_0F) );
  BUFX2 A0A ( .A(TE), .Y(n_A_06) );
  BUFX2 A09 ( .A(RN), .Y(n_A_05) );
  OR2X1 A08 ( .A(SYNC), .B(n_A_0C), .Y(n_A_0D) );
  AND2X1 A06 ( .A(n_A_0F), .B(n_A_0G), .Y(n_A_0C) );
  INVX1 A07 ( .A(n_A_0H), .Y(n_A_0J) );
  AD5 A05 ( .E(n_A_02), .D(n_A_0J), .C(n_A_0K), .B(n_A_0L), .A(n_A_0M), .Y(
        n_A_0G) );
  COU1 A03 ( .RN(n_A_05), .TE(n_A_06), .TI(n_A_02), .CK(CK), .SCL(SYNC), .EN(
        n_A_0C), .QN(LRCK), .Q(TO) );
  CO05 A02 ( .RN(n_A_05), .TE(n_A_06), .CK(CK), .SCL(n_A_0D), .TI(SCK), .EN(
        n_A_0F), .Q4(n_A_02), .Q3(n_A_0H), .Q2(n_A_0K), .Q1(n_A_0L), .Q0(
        n_A_0M) );
  CO05 A01 ( .RN(n_A_05), .TE(n_A_06), .CK(CK), .SCL(SYNC), .TI(TI), .EN(EN), 
        .Q4(SCK), .Q3(n_A_0R), .Q2(n_A_0P), .Q1(n_A_0N), .Q0(n_A_0T) );
endmodule


module SPC24 ( RN, TE, TI, EN, D, CK, Q, TO );
  output [19:0] Q;
  input RN, TE, TI, EN, D, CK;
  output TO;
  wire   n_A_13, n_A_14, n_A_11, n_A_05, n_A_02, n_A_03, n_A_04;

  BUFX8 A1L ( .A(EN), .Y(n_A_13) );
  BUFX2 A1K ( .A(Q[19]), .Y(TO) );
  BUFX8 A0T ( .A(RN), .Y(n_A_14) );
  BUFX8 A0S ( .A(TE), .Y(n_A_11) );
  FE1R A0R ( .RN(n_A_14), .TE(n_A_11), .TI(Q[18]), .CK(CK), .EN(n_A_13), .D(
        Q[18]), .Q(Q[19]) );
  FE1R A0P ( .RN(n_A_14), .TE(n_A_11), .TI(Q[17]), .CK(CK), .EN(n_A_13), .D(
        Q[17]), .Q(Q[18]) );
  FE1R A0N ( .RN(n_A_14), .TE(n_A_11), .TI(Q[16]), .CK(CK), .EN(n_A_13), .D(
        Q[16]), .Q(Q[17]) );
  FE1R A0M ( .RN(n_A_14), .TE(n_A_11), .TI(Q[15]), .CK(CK), .EN(n_A_13), .D(
        Q[15]), .Q(Q[16]) );
  FE1R A0L ( .RN(n_A_14), .TE(n_A_11), .TI(Q[14]), .CK(CK), .EN(n_A_13), .D(
        Q[14]), .Q(Q[15]) );
  FE1R A0K ( .RN(n_A_14), .TE(n_A_11), .TI(Q[13]), .CK(CK), .EN(n_A_13), .D(
        Q[13]), .Q(Q[14]) );
  FE1R A0J ( .RN(n_A_14), .TE(n_A_11), .TI(Q[12]), .CK(CK), .EN(n_A_13), .D(
        Q[12]), .Q(Q[13]) );
  FE1R A0H ( .RN(n_A_14), .TE(n_A_11), .TI(Q[11]), .CK(CK), .EN(n_A_13), .D(
        Q[11]), .Q(Q[12]) );
  FE1R A0G ( .RN(n_A_14), .TE(n_A_11), .TI(Q[10]), .CK(CK), .EN(n_A_13), .D(
        Q[10]), .Q(Q[11]) );
  FE1R A0F ( .RN(n_A_14), .TE(n_A_11), .TI(Q[9]), .CK(CK), .EN(n_A_13), .D(
        Q[9]), .Q(Q[10]) );
  FE1R A0E ( .RN(n_A_14), .TE(n_A_11), .TI(Q[8]), .CK(CK), .EN(n_A_13), .D(
        Q[8]), .Q(Q[9]) );
  FE1R A0D ( .RN(n_A_14), .TE(n_A_11), .TI(Q[7]), .CK(CK), .EN(n_A_13), .D(
        Q[7]), .Q(Q[8]) );
  FE1R A0C ( .RN(n_A_14), .TE(n_A_11), .TI(Q[6]), .CK(CK), .EN(n_A_13), .D(
        Q[6]), .Q(Q[7]) );
  FE1R A0B ( .RN(n_A_14), .TE(n_A_11), .TI(Q[5]), .CK(CK), .EN(n_A_13), .D(
        Q[5]), .Q(Q[6]) );
  FE1R A0A ( .RN(n_A_14), .TE(n_A_11), .TI(Q[4]), .CK(CK), .EN(n_A_13), .D(
        Q[4]), .Q(Q[5]) );
  FE1R A09 ( .RN(n_A_14), .TE(n_A_11), .TI(Q[3]), .CK(CK), .EN(n_A_13), .D(
        Q[3]), .Q(Q[4]) );
  FE1R A08 ( .RN(n_A_14), .TE(n_A_11), .TI(Q[2]), .CK(CK), .EN(n_A_13), .D(
        Q[2]), .Q(Q[3]) );
  FE1R A07 ( .RN(n_A_14), .TE(n_A_11), .TI(Q[1]), .CK(CK), .EN(n_A_13), .D(
        Q[1]), .Q(Q[2]) );
  FE1R A06 ( .RN(n_A_14), .TE(n_A_11), .TI(Q[0]), .CK(CK), .EN(n_A_13), .D(
        Q[0]), .Q(Q[1]) );
  FE1R A05 ( .RN(n_A_14), .TE(n_A_11), .TI(n_A_05), .CK(CK), .EN(n_A_13), .D(
        n_A_05), .Q(Q[0]) );
  FE1R A04 ( .RN(n_A_14), .TE(n_A_11), .TI(n_A_02), .CK(CK), .EN(n_A_13), .D(
        n_A_02), .Q(n_A_05) );
  FE1R A03 ( .RN(n_A_14), .TE(n_A_11), .TI(n_A_03), .CK(CK), .EN(n_A_13), .D(
        n_A_03), .Q(n_A_02) );
  FE1R A02 ( .RN(n_A_14), .TE(n_A_11), .TI(n_A_04), .CK(CK), .EN(n_A_13), .D(
        n_A_04), .Q(n_A_03) );
  FE1R A01 ( .RN(n_A_14), .TE(n_A_11), .TI(TI), .CK(CK), .EN(n_A_13), .D(D), 
        .Q(n_A_04) );
endmodule


module ESPSQ ( XRST, TE, TI, MCK, TSCST, ESYNC, ENP, PMA, RXESEN, PCEBEN, 
        SURDEN, EEMADCL, EEMDS, EEMDOLE, EOBLE, EEMALE, XEEMWE, ESCST, EIMA, 
        TO, EYLE, EXLE, EALE, EBLE, LFACLLE, DTLE, EQACCL, TXLDLE, TXRDLE, 
        ESSCL, ESSCE, EQACCE, EOLE, EQACLE, ERLE, ETLE, EIMWE, EROALE, ETOEN, 
        EPSOEN, EPOEN, ET1EN, ET0EN, EXHEN, EIMOEN, MCHS, ESSDEN, SIEXS, EXLRS, 
        EXTIEN, ERS2, ERS1, EROEN, EQACS0, EQOEN, ET5EN, ET4EN, ET3EN, ET2EN, 
        EPAEN, EAIVEN, EOS1, EOS0, EOOEN, ERLRS, LFACLS, EMSFEN, DTEN, EXEXEN, 
        PBSD4, EPWEN, EROMAS, INC16, ESLMTEN, SAWPHEN, SFTEN, REPHEN, ABSEN, 
        EPSFT2, EPBSU );
  input [7:0] PMA;
  output [7:0] EIMA;
  input XRST, TE, TI, MCK, TSCST, ESYNC, ENP, RXESEN, PCEBEN, SURDEN;
  output EEMADCL, EEMDS, EEMDOLE, EOBLE, EEMALE, XEEMWE, ESCST, TO, EYLE, EXLE,
         EALE, EBLE, LFACLLE, DTLE, EQACCL, TXLDLE, TXRDLE, ESSCL, ESSCE,
         EQACCE, EOLE, EQACLE, ERLE, ETLE, EIMWE, EROALE, ETOEN, EPSOEN, EPOEN,
         ET1EN, ET0EN, EXHEN, EIMOEN, MCHS, ESSDEN, SIEXS, EXLRS, EXTIEN, ERS2,
         ERS1, EROEN, EQACS0, EQOEN, ET5EN, ET4EN, ET3EN, ET2EN, EPAEN, EAIVEN,
         EOS1, EOS0, EOOEN, ERLRS, LFACLS, EMSFEN, DTEN, EXEXEN, PBSD4, EPWEN,
         EROMAS, INC16, ESLMTEN, SAWPHEN, SFTEN, REPHEN, ABSEN, EPSFT2, EPBSU;
  wire   n_A_0W, n_BLD23, n_BLD22, n_BLD21, n_BLD20, n_BLD19, n_BLD18, n_BLD17,
         n_BLD16, n_BLD15, n_BLD14, n_BLD13, n_BLD12, n_BLD11, n_BLD10,
         n_BLD09, n_BLD08, n_BLD07, n_BLD06, n_BLD05, n_BLD04, n_BLD03,
         n_BLD02, n_BLD01, n_BLD00, n_EQB4, n_EQB3, n_EQB2, n_EQB1, n_EQB0,
         n_EEV23, n_EEV22, n_EEV21, n_EEV20, n_EEV19, n_EEV18, n_EEV17,
         n_EEV16, n_EEV15, n_EEV14, n_EEV13, n_EEV12, n_EEV11, n_EEV10,
         n_EEV09, n_EEV08, n_EEV07, n_EEV06, n_EEV05, n_EEV04, n_EEV03,
         n_EEV02, n_EEV01, n_EEV00, n_EQA4, n_EQA3, n_EQA2, n_EQA1, n_EQA0,
         n_RP1, n_RP2, n_RP3, n_RP5, n_A_0T, n_A_2A, n_A_2M, n_A_24, n_RP7,
         n_DLDALE, n_A_2G, n_ENP, n_EMACL, n_A_2N, n_A_22, n_EEMEND, n_EQC2,
         n_TE, n_EIMAE, n_EEMILE, n_TO1, n_XRST, n_EEMRWC, n_EEMACE, n_EEMCE,
         n_A_1W, n_A_1M, n_A_1P, n_A_1R, n_A_1S, n_EQC1, n_EQC0, n_RP6, n_RP4,
         n_RP0, n_CHDA5, n_CHDA6, n_LDA0, n_LDA1, n_DLDA5, n_DLDA6, n_EACC6,
         n_CPRA5, n_CPRA6, n_B_46, n_CPRA3, n_CPRA2, n_CPRA1, n_CPRA0, n_B_21,
         n_B_2S, n_B_03, n_B_41, n_B_4H, n_B_3G, n_EMCPACE, n_B_3A, n_B_0D,
         n_CHDA0, n_CHDA1, n_CHDA2, n_CHDA3, n_EMCPDCE, n_CHDA4, n_B_0G,
         n_REVA2, n_REVA1, n_REVA0, n_REVA3, n_REVA4, n_REVA6, n_B_2M, n_B_32,
         n_EMEDCE, n_EMEDLE, n_EMEDSE, n_B_35, n_EDA0, n_EDA1, n_EDA2, n_EDA3,
         n_EDA4, n_EDA6, n_CPRA7, n_REVA7, n_CPRA4, n_REVA5, n_B_2L, n_B_2N,
         n_B_3V, n_B_40, n_B_4C, n_B_3U, n_B_28, n_B_2U, n_EACC7, n_EMPMEN,
         n_EMEDEN, n_EMCPADEN, n_EMACAEN, n_DLDAEN, n_EPM7, n_EPM6, n_EPM5,
         n_EPM4, n_EPM3, n_EPM2, n_EPM1, n_EPM0, n_EDA7, n_EDA5, n_CHDA7,
         n_EACC5, n_EACC4, n_EACC3, n_EACC2, n_EACC1, n_EACC0, n_DLDA7,
         n_DLDA4, n_DLDA3, n_DLDA2, n_DLDA1, n_DLDA0, n_B_2W1, n_B_2W2,
         n_B_2W3, n_B_2W4, n_B_2W5, n_B_2W6, n_B_2W7, n_B_2W8, n_DLDADE,
         n_LDB2, n_LDB0, n_LDB1, n_LDB3, n_LDA2, n_LDA4, n_LDA3, n_DLDACE,
         n_B_2Y, n_B_3C, n_EMCPAEN, n_B_2G1, n_B_2G2, n_B_2G3, n_B_2G4,
         n_B_2G5, n_B_2G6, n_B_2G7, n_B_2G8, n_EMACLE, n_EMACCE, n_EMPMCE,
         n_EMPMLE, n_EMPMSE, n_C_84, n_C_86, n_C_5T, n_C_5G, n_C_5K, n_C_5J,
         n_C_5H, n_C_6T, n_C_7U, n_C_7H, n_C_81, n_C_80, n_C_5Y, n_C_5W,
         n_C_5V, n_C_82, n_C_78, n_C_7Y, n_C_83, n_C_85, n_C_67, n_C_66,
         n_C_64, n_C_87, n_C_8A, n_C_8B, n_C_6K, n_C_6H, n_C_6G, n_C_8C,
         n_C_7X, n_C_6M, n_C_6S, n_C_3G, n_C_72, n_C_2S, n_C_5P, n_C_5N,
         n_C_7T, n_C_6V, n_C_7C, n_C_7A, n_C_6X, n_C_75, n_C_7P, n_C_5B,
         n_C_1P, n_C_1L, n_C_18, n_C_0N, n_C_7L, n_C_89, n_C_6B, n_C_6A,
         n_C_88, n_C_6F, n_C_6E, n_C_5A, n_C_04, n_C_70, n_C_6Y, n_C_6W,
         n_C_6U, n_C_6N, n_C_6L, n_C_71, n_C_73, n_C_74, n_C_76, n_C_79,
         n_C_7B, n_C_7D, n_C_7F, n_C_7G, n_C_7J, n_C_7K, n_C_7M, n_C_7N,
         n_C_7R, n_D_9S, n_D_9T, n_D_75, n_D_90, n_D_9H, n_D_95, n_D_8D,
         n_D_74, n_D_20, n_D_94, n_D_15, n_D_85, n_D_71, n_D_7F, n_D_70,
         n_D_9K, n_D_8S, n_D_8R, n_D_8N, n_D_9L, n_D_89, n_D_8C, n_D_8B,
         n_D_9M, n_D_76, n_D_7G, n_D_4C, n_D_7U, n_D_3Y, n_D_79, n_D_7W,
         n_D_9D, n_D_92, n_D_7P, n_D_7A, n_D_83, n_D_87, n_D_1F, n_D_96,
         n_D_91, n_D_9B, n_D_6M, n_D_9J, n_D_7D, n_D_8L, n_D_7C, n_D_80,
         n_D_8J, n_D_98, n_D_6T, n_D_6S, n_D_6V, n_D_7Y, n_D_9C, n_D_77,
         n_D_78, n_D_7B, n_D_7E, n_D_7X, n_D_7T, n_D_7L, n_D_84, n_D_7H,
         n_D_86, n_D_6L, n_D_7K, n_D_8E, n_D_9R, n_D_88, n_D_8U, n_D_8T,
         n_D_7J, n_D_81, n_D_8H, n_D_8G, n_D_8K, n_D_8M, n_D_99, n_D_9F,
         n_D_9E, n_D_9A, n_E_78, n_E_7A, n_E_79, n_E_4A, n_E_4H, n_E_49,
         n_E_2E, n_E_6S, n_E_70, n_E_42, n_E_3Y, n_E_5Y, n_E_2W, n_E_6U,
         n_E_6J, n_E_4F, n_E_6K, n_E_4G, n_E_4L, n_E_2F, n_E_67, n_E_4R,
         n_E_3H, n_E_6W, n_E_62, n_E_6X, n_E_6V, n_E_73, n_E_0G, n_E_5N,
         n_E_5B, n_E_5C, n_E_69, n_E_4M, n_E_6A, n_E_4K, n_E_4P, n_E_58,
         n_E_1Y, n_E_57, n_E_63, n_E_56, n_E_4Y, n_E_53, n_E_5U, n_E_72,
         n_E_3P, n_E_3R, n_E_6P, n_E_5G, n_E_47, n_E_4T, n_E_4S, n_E_65,
         n_E_74, n_E_4D, n_E_60, n_E_3M, n_E_3N, n_E_3L, n_E_3K, n_E_75,
         n_E_41, n_E_4B, n_E_4C, n_E_4N, n_E_5S, n_E_5H, n_E_4X, n_E_50,
         n_E_51, n_E_55, n_E_5D, n_E_5K, n_F_68, n_F_5L, n_F_3L, n_F_63,
         n_F_5C, n_F_5G, n_F_1R, n_F_5U, n_F_0T, n_F_6F, n_F_66, n_F_69,
         n_F_5B, n_F_51, n_F_5J, n_F_6P, n_F_4X, n_F_6R, n_F_4R, n_F_6M,
         n_F_6L, n_F_5P, n_F_41, n_F_7D, n_F_5F, n_F_5E, n_F_7C, n_F_5D,
         n_F_5T, n_F_4S, n_F_6N, n_F_5H, n_F_0R, n_F_62, n_F_6K, n_F_6A,
         n_F_7L, n_F_7J, n_F_7K, n_F_5N, n_F_4Y, n_F_7R, n_F_55, n_F_6C,
         n_F_7M, n_F_7N, n_F_0S, n_F_56, n_F_5S, n_F_5R, n_F_60, n_F_61,
         n_F_5W, n_F_5V, n_F_5X, n_F_5Y, n_F_6H, n_F_57, n_F_6B, n_F_6U,
         n_F_6T, n_F_67, n_F_6X, n_F_6V, n_F_6Y, n_F_76, n_F_7A, n_F_71,
         n_F_73, n_F_6G, n_F_75, n_F_70, n_F_74, n_F_72, n_F_79, n_F_78,
         n_F_7B, n_F_6D, n_F_1U, n_F_4M, n_F_7G, n_G_5P, n_G_6M, n_G_7J,
         n_G_78, n_G_0S, n_G_0T, n_G_7N, n_G_5W, n_G_9B, n_G_94, n_G_96,
         n_G_0B, n_G_9C, n_G_93, n_G_6K, n_G_6S, n_G_75, n_G_5R, n_G_2G,
         n_G_7X, n_G_98, n_G_8K, n_G_97, n_G_9A, n_G_7M, n_G_6V, n_G_8A,
         n_G_6Y, n_G_6D, n_G_6L, n_G_77, n_G_87, n_G_9D, n_G_9E, n_G_6C,
         n_G_6E, n_G_5S, n_G_6B, n_G_6H, n_G_6J, n_G_6G, n_G_71, n_G_72,
         n_G_73, n_G_74, n_G_7F, n_G_7E, n_G_7D, n_G_7B, n_G_7L, n_G_7K,
         n_G_7U, n_G_7T, n_G_7W, n_G_7V, n_G_7S, n_G_7R, n_G_86, n_G_21,
         n_G_89, n_G_81, n_G_8D, n_G_8C, n_G_8H, n_G_8F, n_G_8E, n_G_8G,
         n_G_8L, n_G_8M, n_G_8P, n_G_8R, n_G_8S, n_G_8X, n_G_8Y, n_G_90,
         n_G_91, n_G_6P, n_G_7A, n_G_79, n_G_99, n_H_6P, n_H_7J, n_H_6W,
         n_H_3D, n_H_6T, n_H_71, n_H_79, n_H_8K, n_H_6D, n_H_7Y, n_H_06,
         n_H_7P, n_H_77, n_H_7S, n_H_8F, n_H_3M, n_H_0C, n_H_0S, n_H_0X,
         n_H_8R, n_H_7G, n_H_6J, n_H_64, n_H_80, n_H_87, n_H_8U, n_H_8X,
         n_H_8G, n_H_07, n_H_6L, n_H_8L, n_H_66, n_H_67, n_H_6M, n_H_76,
         n_H_01, n_H_8H, n_H_69, n_H_6B, n_H_6C, n_H_6A, n_H_6E, n_H_6G,
         n_H_63, n_H_6H, n_H_95, n_H_94, n_H_6Y, n_H_7N, n_H_93, n_H_6S,
         n_H_8J, n_H_61, n_H_62, n_H_90, n_H_65, n_H_92, n_H_6K, n_EIMDIS,
         n_H_7M, n_H_7L, n_H_7K, n_H_70, n_H_73, n_H_72, n_H_75, n_H_74,
         n_H_84, n_H_85, n_H_86, n_H_7W, n_H_89, n_H_8B, n_H_8A, n_H_81,
         n_H_88, n_H_83, n_H_8P, n_I_7V, n_I_84, n_I_91, n_I_7F, n_I_6L,
         n_I_73, n_I_72, n_I_1D, n_I_62, n_I_5J, n_I_3A, n_I_69, n_I_7J,
         n_I_65, n_I_5Y, n_I_5C, n_I_7C, n_I_71, n_I_63, n_I_60, n_I_5L,
         n_I_5M, n_I_1C, n_I_7B, n_I_6U, n_I_5V, n_I_1E, n_I_64, n_I_66,
         n_I_7A, n_I_6F, n_I_7K, n_I_37, n_I_81, n_I_8T, n_I_51, n_I_1J,
         n_I_4Y, n_I_6G, n_I_8Y, n_I_6V, n_I_6W, n_I_1H, n_I_6E, n_I_8X,
         n_I_5G, n_I_5H, n_I_5U, n_I_5T, n_I_5S, n_I_5R, n_I_5W, n_I_5X,
         n_I_5P, n_I_6B, n_I_6A, n_I_6Y, n_I_50, n_I_6J, n_I_6K, n_I_29,
         n_I_7Y, n_I_7L, n_I_7N, n_I_7M, n_I_7H, n_I_82, n_I_8N, n_I_7U,
         n_I_8V, n_I_8S, n_I_8R, n_I_8C, n_I_8B, n_I_8D, n_I_8E, n_I_8G,
         n_I_8H, n_J_7B, n_J_2K, n_J_6C, n_J_6D, n_J_5L, n_J_6K, n_J_7C,
         n_J_5R, n_J_6U, n_J_7F, n_J_7K, n_J_79, n_J_77, n_J_6F, n_J_6T,
         n_J_3F, n_J_8U, n_J_8V, n_J_5S, n_J_8T, n_J_6V, n_J_7T, n_J_88,
         n_J_2V, n_J_2H, n_J_8B, n_J_87, n_J_3B, n_J_6X, n_J_7P, n_J_60,
         n_J_75, n_J_42, n_J_76, n_J_7N, n_J_7J, n_J_8X, n_J_3Y, n_J_7L,
         n_J_5Y, n_J_7D, n_J_61, n_J_5X, n_J_54, n_J_5D, n_J_90, n_J_5T,
         n_J_81, n_J_80, n_J_82, n_J_5M, n_J_6G, n_J_1R, n_J_8J, n_J_0K,
         n_J_3G, n_J_67, n_J_65, n_J_2E, n_J_64, n_J_6P, n_J_6R, n_J_5N,
         n_J_71, n_J_70, n_J_6Y, n_J_78, n_J_7R, n_J_7X, n_J_83, n_J_86,
         n_J_85, n_J_8G, n_J_8D, n_J_8F, n_J_8E, n_J_8H, n_J_8K, n_J_7W,
         n_J_8L, n_J_89, n_J_8M, n_K_8W, n_K_7Y, n_K_9V, n_K_8D, n_K_5M,
         n_K_0V, n_K_0X, n_K_96, n_K_0D, n_K_86, n_K_94, n_K_66, n_K_54,
         n_K_98, n_K_6W, n_K_8N, n_K_27, n_K_9T, n_K_9M, n_K_8V, n_K_7H,
         n_K_5G, n_K_8Y, n_K_9A, n_K_9L, n_K_9K, n_K_9H, n_K_9G, n_K_62,
         n_K_5L, n_K_5U, n_K_5F, n_K_5H, n_K_0E, n_K_5Y, n_K_2M, n_K_8C,
         n_K_7A, n_K_8J, n_K_76, n_K_75, n_K_9E, n_K_58, n_K_5A, n_K_59,
         n_K_57, n_K_56, n_K_6H, n_K_6E, n_K_9D, n_K_9U, n_K_9B, n_K_9C,
         n_K_8L, n_K_8T, n_K_8A, n_K_85, n_K_9W, n_K_73, n_K_6U, n_K_7K,
         n_K_89, n_K_5W, n_K_77, n_K_78, n_K_6B, n_K_50, n_K_07, n_K_7F,
         n_K_2A, n_K_5X, n_K_7D, n_K_61, n_K_64, n_K_63, n_K_79, n_K_6P,
         n_K_6R, n_K_6M, n_K_6N, n_K_6F, n_K_84, n_K_6G, n_K_74, n_K_8U,
         n_K_9S, n_K_8F, n_K_9F, n_L_2W, n_L_2G, n_L_2K, n_L_2F, n_L_2J,
         n_L_27, n_L_21, n_L_1W, n_L_23, n_L_20, n_L_1S, n_L_25, n_L_24,
         n_L_2B, n_L_14, n_L_28, n_L_17, n_L_1A, n_L_1J, n_L_1M;

  DC24 A06 ( .A({n_EQB4, n_EQB3, n_EQB2, n_EQB1, n_EQB0}), .EN(n_A_0W), .Y({
        n_BLD23, n_BLD22, n_BLD21, n_BLD20, n_BLD19, n_BLD18, n_BLD17, n_BLD16, 
        n_BLD15, n_BLD14, n_BLD13, n_BLD12, n_BLD11, n_BLD10, n_BLD09, n_BLD08, 
        n_BLD07, n_BLD06, n_BLD05, n_BLD04, n_BLD03, n_BLD02, n_BLD01, n_BLD00}) );
  DC24 A02 ( .A({n_EQA4, n_EQA3, n_EQA2, n_EQA1, n_EQA0}), .EN(ESCST), .Y({
        n_EEV23, n_EEV22, n_EEV21, n_EEV20, n_EEV19, n_EEV18, n_EEV17, n_EEV16, 
        n_EEV15, n_EEV14, n_EEV13, n_EEV12, n_EEV11, n_EEV10, n_EEV09, n_EEV08, 
        n_EEV07, n_EEV06, n_EEV05, n_EEV04, n_EEV03, n_EEV02, n_EEV01, n_EEV00}) );
  ESQLGC A0A ( .A({n_BLD23, n_BLD22, n_BLD21, n_BLD20, n_BLD19, n_BLD18, 
        n_BLD17, n_BLD16, n_BLD15, n_BLD14, n_BLD13, n_BLD12, n_BLD11, n_BLD10, 
        n_BLD09, n_BLD08, n_BLD07, n_BLD06, n_BLD05, n_BLD04, n_BLD03, n_BLD02, 
        n_BLD01, n_BLD00}), .B5(n_RP5), .EN(n_A_2A), .B7(n_RP7), .B3(n_RP3), 
        .B2(n_RP2), .B1(n_RP1), .FLEND(EOBLE), .EMST(n_A_24), .SE(n_A_2M), .Y(
        n_A_0T) );
  NOR2X2 A31 ( .A(n_EEV23), .B(n_BLD08), .Y(n_DLDALE) );
  NOR3X1 A2L ( .A(n_EEV23), .B(n_BLD23), .C(n_RP5), .Y(n_A_2G) );
  AND2X2 A30 ( .A(n_ENP), .B(n_A_2G), .Y(n_EMACL) );
  AND2X1 A2Y ( .A(n_ENP), .B(ESCST), .Y(n_A_2N) );
  AND2X1 A2W ( .A(n_ENP), .B(ESCST), .Y(n_A_22) );
  EEMDEC A27 ( .EEMRWC(n_EEMRWC), .RN(n_XRST), .TE(n_TE), .TI(n_EQC2), 
        .EEMEND(n_EEMEND), .EEMST(n_A_24), .CK(MCK), .EN(n_A_22), .EEMCE(
        n_EEMCE), .EEMDS(EEMDS), .EIMAE(n_EIMAE), .EEMACE(n_EEMACE), .TO(n_TO1), .EEMDILE(n_EEMILE), .EEMDOLE(EEMDOLE), .EEMALE(EEMALE), .XEEMWE(XEEMWE) );
  BUFX4 A19 ( .A(TE), .Y(n_TE) );
  BUFX4 A18 ( .A(XRST), .Y(n_XRST) );
  AD6D2 A0B ( .F(n_A_1W), .E(n_EQA4), .D(n_EQA2), .C(n_EQA1), .B(n_EQA0), .A(
        n_ENP), .Y(n_A_2A) );
  BUFX4 A17 ( .A(ENP), .Y(n_ENP) );
  BUFX2 A2T ( .A(n_EMACL), .Y(EEMADCL) );
  TIEHI A1J ( .Y(n_A_0W) );
  BUFX2 A1A ( .A(ESYNC), .Y(n_A_1M) );
  OR2X1 A15 ( .A(n_A_0T), .B(n_A_1M), .Y(n_A_1P) );
  OR2X1 A14 ( .A(n_A_1M), .B(n_A_2M), .Y(n_A_1R) );
  OR2X1 A13 ( .A(n_A_1M), .B(n_A_2A), .Y(n_A_1S) );
  INVX1 A12 ( .A(n_EQA3), .Y(n_A_1W) );
  FE1R A08 ( .RN(n_XRST), .TE(n_TE), .TI(TI), .CK(MCK), .EN(n_A_1M), .D(TSCST), 
        .Q(ESCST) );
  DC08B A07 ( .A({n_EQC2, n_EQC1, n_EQC0}), .Y({n_RP7, n_RP6, n_RP5, n_RP4, 
        n_RP3, n_RP2, n_RP1, n_RP0}) );
  CO03 A04 ( .RN(n_XRST), .TE(n_TE), .TI(n_EQB4), .CK(MCK), .SCL(n_A_1P), .EN(
        n_A_2A), .Q2(n_EQC2), .Q1(n_EQC1), .Q0(n_EQC0) );
  CO05 A03 ( .RN(n_XRST), .TE(n_TE), .CK(MCK), .SCL(n_A_1R), .TI(n_EQA4), .EN(
        n_A_0T), .Q4(n_EQB4), .Q3(n_EQB3), .Q2(n_EQB2), .Q1(n_EQB1), .Q0(
        n_EQB0) );
  CO05 A01 ( .RN(n_XRST), .TE(n_TE), .CK(MCK), .SCL(n_A_1S), .TI(ESCST), .EN(
        n_A_2N), .Q4(n_EQA4), .Q3(n_EQA3), .Q2(n_EQA2), .Q1(n_EQA1), .Q0(
        n_EQA0) );
  TIEHI B1X0 ( .Y(n_CHDA5) );
  TIEHI B1X1 ( .Y(n_CHDA6) );
  TIELO B2H0 ( .Y(n_LDA0) );
  TIELO B2H1 ( .Y(n_LDA1) );
  TIEHI B2V0 ( .Y(n_DLDA5) );
  TIEHI B2V1 ( .Y(n_DLDA6) );
  TIEHI B1W0 ( .Y(n_EACC6) );
  TIEHI B4H0 ( .Y(n_CPRA5) );
  TIEHI B4H1 ( .Y(n_CPRA6) );
  EWADEC B3X ( .A({n_CPRA3, n_CPRA2, n_CPRA1, n_CPRA0}), .Y(n_B_46) );
  INVX1 B3W ( .A(n_CPRA1), .Y(n_B_21) );
  AND3X1 B3U ( .A(n_CPRA3), .B(n_CPRA0), .C(n_CPRA2), .Y(n_B_2S) );
  INVX1 B51 ( .A(n_B_03), .Y(n_B_41) );
  AND2X1 B50 ( .A(n_EEMACE), .B(n_B_41), .Y(n_B_4H) );
  INVX1 B1D ( .A(EPWEN), .Y(n_B_3G) );
  NAND2X1 B19 ( .A(n_B_3G), .B(ESCST), .Y(n_B_03) );
  DCO04 B05 ( .QS(n_CHDA4), .RN(n_XRST), .TE(n_TE), .CE2(n_EMCPDCE), .TI(
        n_B_0D), .SCL(n_B_3A), .CE1(n_EMCPACE), .CK(MCK), .TO(n_B_0G), .Q3(
        n_CHDA3), .Q2(n_CHDA2), .Q1(n_CHDA1), .Q0(n_CHDA0) );
  AD6 B42 ( .F(n_REVA6), .E(n_REVA4), .D(n_REVA3), .C(n_REVA2), .B(n_REVA1), 
        .A(n_REVA0), .Y(n_B_2M) );
  TIELO B3G ( .Y(n_B_32) );
  CL06 B02 ( .RN(n_XRST), .TE(n_TE), .TI(n_B_35), .SCL(n_B_3A), .CE(n_EMEDCE), 
        .LE(n_EMEDLE), .CK(MCK), .SE(n_EMEDSE), .Q5(n_EDA6), .Q4(n_EDA4), .Q3(
        n_EDA3), .Q2(n_EDA2), .Q1(n_EDA1), .Q0(n_EDA0), .TO(n_B_0D) );
  TIEHI B4H2 ( .Y(n_CPRA7) );
  TIELO B0S ( .Y(n_REVA7) );
  INVX1 B4E ( .A(n_EIMAE), .Y(n_CPRA4) );
  INVX1 B49 ( .A(n_EIMAE), .Y(n_REVA5) );
  AND2X1 B0N ( .A(n_B_2L), .B(n_B_2N), .Y(n_B_3V) );
  BUFX2 B48 ( .A(n_EEMCE), .Y(n_B_2L) );
  BUFX2 B44 ( .A(n_CPRA3), .Y(TO) );
  AND2X1 B0X ( .A(n_B_40), .B(n_REVA0), .Y(n_B_4C) );
  AND3X2 B3V ( .A(n_B_2S), .B(n_B_21), .C(n_B_2L), .Y(n_EEMEND) );
  CO04 B08 ( .RN(n_XRST), .TE(n_TE), .CK(MCK), .SCL(n_EEMEND), .TI(n_B_28), 
        .EN(n_B_3U), .Q3(n_CPRA3), .Q2(n_CPRA2), .Q1(n_CPRA1), .Q0(n_CPRA0) );
  AND2X1 B3P ( .A(n_B_2M), .B(n_B_2L), .Y(n_B_2U) );
  COU1 B10 ( .RN(n_XRST), .TE(n_TE), .TI(n_REVA6), .CK(MCK), .SCL(n_EEMEND), 
        .EN(n_B_2U), .QN(n_B_2N), .Q(n_B_28) );
  BUFX2 B3A ( .A(n_EMACL), .Y(n_B_3A) );
  TIEHI B1W1 ( .Y(n_EACC7) );
  DS086 B09 ( .A({n_EPM7, n_EPM6, n_EPM5, n_EPM4, n_EPM3, n_EPM2, n_EPM1, 
        n_EPM0}), .B({n_EDA7, n_EDA6, n_EDA5, n_EDA4, n_EDA3, n_EDA2, n_EDA1, 
        n_EDA0}), .C({n_CHDA7, n_CHDA6, n_CHDA5, n_CHDA4, n_CHDA3, n_CHDA2, 
        n_CHDA1, n_CHDA0}), .D({n_EACC7, n_EACC6, n_EACC5, n_EACC4, n_EACC3, 
        n_EACC2, n_EACC1, n_EACC0}), .E({n_DLDA7, n_DLDA6, n_DLDA5, n_DLDA4, 
        n_DLDA3, n_DLDA2, n_DLDA1, n_DLDA0}), .F(PMA), .FE(n_B_03), .EE(
        n_DLDAEN), .DE(n_EMACAEN), .CE(n_EMCPADEN), .BE(n_EMEDEN), .AE(
        n_EMPMEN), .Y({n_B_2W1, n_B_2W2, n_B_2W3, n_B_2W4, n_B_2W5, n_B_2W6, 
        n_B_2W7, n_B_2W8}) );
  TIEHI B2V2 ( .Y(n_DLDA7) );
  BUFX2 B2U ( .A(n_DLDADE), .Y(n_DLDA4) );
  TIELO B2T ( .Y(n_LDB2) );
  TIELO B2S ( .Y(n_LDB0) );
  TIEHI B2R ( .Y(n_LDB1) );
  TIEHI B2P ( .Y(n_LDB3) );
  TIELO B2H2 ( .Y(n_LDA2) );
  TIELO B2E ( .Y(n_LDA4) );
  TIEHI B2D ( .Y(n_LDA3) );
  CO04L B26 ( .D({n_LDB3, n_LDB2, n_LDB1, n_LDB0}), .RN(n_XRST), .TE(n_TE), 
        .TI(n_B_2Y), .CK(MCK), .SCL(n_B_32), .LE(n_DLDALE), .CE(n_DLDACE), 
        .Q3(n_DLDA3), .Q2(n_DLDA2), .Q1(n_DLDA1), .Q0(n_DLDA0), .TO(n_B_3C) );
  TIELO B20 ( .Y(n_EACC5) );
  TIEHI B1X2 ( .Y(n_CHDA7) );
  INVX1 B1F ( .A(n_EMCPAEN), .Y(n_CHDA4) );
  TIEHI B1T ( .Y(n_EDA5) );
  TIELO B1S ( .Y(n_EDA7) );
  TIEHI B1R ( .Y(n_EPM7) );
  AND2X1 B12 ( .A(n_B_28), .B(n_B_2L), .Y(n_B_3U) );
  MX2X1 B11 ( .S0(n_B_28), .B(n_B_46), .A(n_B_4C), .Y(n_EEMRWC) );
  NAND2X1 B0W ( .A(n_REVA3), .B(n_REVA4), .Y(n_B_40) );
  DS082 B0P ( .B({n_CPRA7, n_CPRA6, n_CPRA5, n_CPRA4, n_CPRA3, n_CPRA2, 
        n_CPRA1, n_CPRA0}), .A({n_REVA7, n_REVA6, n_REVA5, n_REVA4, n_REVA3, 
        n_REVA2, n_REVA1, n_REVA0}), .S(n_B_28), .Y({n_B_2G1, n_B_2G2, n_B_2G3, 
        n_B_2G4, n_B_2G5, n_B_2G6, n_B_2G7, n_B_2G8}) );
  CO06 B07 ( .TI(n_B_3C), .RN(n_XRST), .TE(n_TE), .CK(MCK), .SCL(n_EEMEND), 
        .EN(n_B_3V), .Q5(n_REVA6), .Q4(n_REVA4), .Q3(n_REVA3), .Q2(n_REVA2), 
        .Q1(n_REVA1), .Q0(n_REVA0) );
  DS082 B06 ( .B({n_B_2G1, n_B_2G2, n_B_2G3, n_B_2G4, n_B_2G5, n_B_2G6, 
        n_B_2G7, n_B_2G8}), .A({n_B_2W1, n_B_2W2, n_B_2W3, n_B_2W4, n_B_2W5, 
        n_B_2W6, n_B_2W7, n_B_2W8}), .S(n_B_4H), .Y(EIMA) );
  CO05L B03 ( .D({n_LDA4, n_LDA3, n_LDA2, n_LDA1, n_LDA0}), .RN(n_XRST), .TE(
        n_TE), .TI(n_B_0G), .CK(MCK), .SCL(n_B_3A), .LE(n_EMACLE), .CE(
        n_EMACCE), .Q0(n_EACC0), .Q1(n_EACC1), .Q2(n_EACC2), .Q3(n_EACC3), 
        .Q4(n_EACC4), .TO(n_B_2Y) );
  CL07 B01 ( .RN(n_XRST), .TE(n_TE), .TI(n_TO1), .SCL(n_B_3A), .CE(n_EMPMCE), 
        .LE(n_EMPMLE), .CK(MCK), .SE(n_EMPMSE), .Q({n_EPM6, n_EPM5, n_EPM4, 
        n_EPM3, n_EPM2, n_EPM1, n_EPM0}), .TO(n_B_35) );
  NOR2X1 C03 ( .A(n_C_86), .B(n_BLD21), .Y(n_C_84) );
  NR5 C7B ( .E(n_C_6T), .D(n_C_5H), .C(n_C_5J), .B(n_C_5K), .A(n_C_5G), .Y(
        n_C_5T) );
  NOR2X1 C8D ( .A(n_C_7U), .B(n_BLD21), .Y(n_C_6T) );
  AND4X1 C88 ( .A(n_EEV00), .B(n_EEV05), .C(n_EEV07), .D(n_EEV12), .Y(n_C_7U)
         );
  NR5 C7E ( .E(n_C_5V), .D(n_C_5W), .C(n_C_5Y), .B(n_C_80), .A(n_C_81), .Y(
        n_C_7H) );
  NOR2X1 C57 ( .A(n_C_82), .B(n_BLD01), .Y(n_C_80) );
  AND4X1 C3Y ( .A(n_EEV10), .B(n_EEV13), .C(n_EEV17), .D(n_EEV20), .Y(n_C_82)
         );
  AND2X1 C3X ( .A(n_EEV01), .B(n_EEV03), .Y(n_C_78) );
  AOI31X1 C4F ( .A0(n_EEV03), .A1(n_EEV14), .A2(n_EEV17), .B0(n_BLD05), .Y(
        n_C_7Y) );
  NR5 C7G ( .E(n_C_84), .D(n_C_64), .C(n_C_66), .B(n_C_67), .A(n_C_85), .Y(
        n_C_83) );
  AND4X1 C02 ( .A(n_EEV01), .B(n_EEV04), .C(n_EEV08), .D(n_EEV11), .Y(n_C_86)
         );
  NR5 C7H ( .E(n_C_6G), .D(n_C_6H), .C(n_C_6K), .B(n_C_8B), .A(n_C_8A), .Y(
        n_C_87) );
  NOR2X1 C4X ( .A(n_C_8C), .B(n_BLD01), .Y(n_C_8B) );
  AND4X1 C5B ( .A(n_EEV11), .B(n_EEV14), .C(n_EEV18), .D(n_EEV21), .Y(n_C_8C)
         );
  NOR2X1 C04 ( .A(n_EEV00), .B(n_BLD00), .Y(n_C_8A) );
  NOR2X1 C6K ( .A(n_C_78), .B(n_BLD00), .Y(n_C_81) );
  AOI31X1 C5W ( .A0(n_EEV02), .A1(n_EEV14), .A2(n_EEV18), .B0(n_BLD08), .Y(
        n_C_7X) );
  AOI22X1 C6G ( .A0(n_EEV03), .A1(n_EEV10), .B0(n_BLD12), .B1(n_BLD16), .Y(
        n_C_6M) );
  AOI32X1 C2D ( .A0(n_EEV04), .A1(n_EEV07), .A2(n_EEV12), .B0(n_BLD12), .B1(
        n_BLD16), .Y(n_C_6S) );
  AOI21X1 C7V ( .A0(n_EEV00), .A1(n_EEV11), .B0(n_BLD11), .Y(n_C_3G) );
  AOI31X1 C1R ( .A0(n_EEV03), .A1(n_EEV07), .A2(n_EEV12), .B0(n_BLD08), .Y(
        n_C_72) );
  AOI31X1 C1F ( .A0(n_EEV05), .A1(n_EEV13), .A2(n_EEV16), .B0(n_BLD05), .Y(
        n_C_2S) );
  NOR2X1 C6D ( .A(n_C_5N), .B(n_BLD11), .Y(n_C_5P) );
  AND4X1 C5L ( .A(n_EEV01), .B(n_EEV04), .C(n_EEV13), .D(n_EEV17), .Y(n_C_5N)
         );
  AD6 C66 ( .F(n_EEV20), .E(n_EEV17), .D(n_EEV10), .C(n_EEV08), .B(n_EEV04), 
        .A(n_EEV01), .Y(n_C_7T) );
  AND2X1 C3D ( .A(n_BLD13), .B(n_BLD17), .Y(n_C_6V) );
  AND2X1 C3R ( .A(n_BLD13), .B(n_BLD17), .Y(n_C_7C) );
  AND2X1 C3S ( .A(n_BLD14), .B(n_BLD18), .Y(n_C_7A) );
  AND2X1 C6X ( .A(n_BLD14), .B(n_BLD18), .Y(n_C_6X) );
  AND2X1 C47 ( .A(n_BLD02), .B(n_BLD20), .Y(n_C_75) );
  AND2X1 C3U ( .A(n_BLD02), .B(n_BLD20), .Y(n_C_7P) );
  NOR4X1 C7C ( .A(n_C_1P), .B(n_C_1L), .C(n_C_5P), .D(n_C_6M), .Y(n_C_5B) );
  NOR4X1 C7D ( .A(n_C_7Y), .B(n_C_0N), .C(n_C_7L), .D(n_C_7X), .Y(n_C_18) );
  NOR4X1 C7K ( .A(n_C_6B), .B(n_C_6A), .C(n_C_3G), .D(n_C_6S), .Y(n_C_89) );
  NOR4X1 C7J ( .A(n_C_2S), .B(n_C_6F), .C(n_C_6E), .D(n_C_72), .Y(n_C_88) );
  AND2X2 C7N ( .A(n_ENP), .B(n_C_5A), .Y(EXLE) );
  AND2X2 C7M ( .A(n_ENP), .B(n_C_04), .Y(EYLE) );
  NAND4X1 C7L ( .A(n_C_7H), .B(n_C_18), .C(n_C_5B), .D(n_C_5T), .Y(n_C_04) );
  NAND4X1 C7F ( .A(n_C_87), .B(n_C_88), .C(n_C_89), .D(n_C_83), .Y(n_C_5A) );
  AND4X1 C76 ( .A(n_EEV00), .B(n_EEV06), .C(n_EEV12), .D(n_EEV18), .Y(n_C_70)
         );
  AD5 C6Y ( .E(n_EEV17), .D(n_EEV13), .C(n_EEV07), .B(n_EEV03), .A(n_EEV00), 
        .Y(n_C_6Y) );
  AD5 C6N ( .E(n_EEV19), .D(n_EEV17), .C(n_EEV13), .B(n_EEV05), .A(n_EEV01), 
        .Y(n_C_6W) );
  AND4X1 C2X ( .A(n_EEV00), .B(n_EEV07), .C(n_EEV13), .D(n_EEV18), .Y(n_C_6U)
         );
  AND4X1 C61 ( .A(n_EEV05), .B(n_EEV10), .C(n_EEV15), .D(n_EEV21), .Y(n_C_6N)
         );
  AND4X1 C5R ( .A(n_EEV03), .B(n_EEV14), .C(n_EEV17), .D(n_EEV18), .Y(n_C_6L)
         );
  NOR2X1 C5F ( .A(n_C_70), .B(n_BLD19), .Y(n_C_5H) );
  NOR2X1 C5E ( .A(n_C_6Y), .B(n_BLD15), .Y(n_C_5J) );
  NOR2X1 C5D ( .A(n_C_6W), .B(n_C_6X), .Y(n_C_5K) );
  NOR2X1 C5C ( .A(n_C_6U), .B(n_C_6V), .Y(n_C_5G) );
  NOR2X1 C59 ( .A(n_C_7T), .B(n_BLD10), .Y(n_C_1L) );
  NOR2X1 C58 ( .A(n_C_6N), .B(n_BLD09), .Y(n_C_1P) );
  NOR2X1 C56 ( .A(n_C_6L), .B(n_BLD07), .Y(n_C_7L) );
  NOR2X1 C55 ( .A(n_C_71), .B(n_BLD06), .Y(n_C_0N) );
  AND4X1 C4Y ( .A(n_EEV02), .B(n_EEV08), .C(n_EEV17), .D(n_EEV20), .Y(n_C_71)
         );
  NOR2X1 C4S ( .A(n_C_73), .B(n_BLD04), .Y(n_C_5V) );
  AD5 C4K ( .E(n_EEV20), .D(n_EEV15), .C(n_EEV08), .B(n_EEV03), .A(n_EEV00), 
        .Y(n_C_73) );
  NOR2X1 C4J ( .A(n_C_74), .B(n_BLD03), .Y(n_C_5W) );
  AND4X1 C49 ( .A(n_EEV00), .B(n_EEV02), .C(n_EEV11), .D(n_EEV13), .Y(n_C_74)
         );
  NOR2X1 C48 ( .A(n_C_76), .B(n_C_75), .Y(n_C_5Y) );
  AD6 C40 ( .F(n_EEV18), .E(n_EEV16), .D(n_EEV15), .C(n_EEV06), .B(n_EEV04), 
        .A(n_EEV03), .Y(n_C_76) );
  AND4X1 C3G ( .A(n_EEV01), .B(n_EEV04), .C(n_EEV08), .D(n_EEV11), .Y(n_C_79)
         );
  NOR2X1 C3E ( .A(n_EEV01), .B(n_BLD19), .Y(n_C_64) );
  NOR2X1 C3C ( .A(n_C_79), .B(n_BLD15), .Y(n_C_66) );
  NOR2X1 C3B ( .A(n_C_7B), .B(n_C_7A), .Y(n_C_67) );
  AD5 C3A ( .E(n_EEV20), .D(n_EEV16), .C(n_EEV12), .B(n_EEV04), .A(n_EEV00), 
        .Y(n_C_7B) );
  AD5 C2K ( .E(n_EEV19), .D(n_EEV14), .C(n_EEV08), .B(n_EEV05), .A(n_EEV01), 
        .Y(n_C_7D) );
  NOR2X1 C2F ( .A(n_C_7D), .B(n_C_7C), .Y(n_C_85) );
  NOR2X1 C24 ( .A(n_C_7F), .B(n_BLD10), .Y(n_C_6A) );
  AD5 C23 ( .E(n_EEV21), .D(n_EEV18), .C(n_EEV13), .B(n_EEV03), .A(n_EEV00), 
        .Y(n_C_7F) );
  NOR2X1 C1X ( .A(n_C_7G), .B(n_BLD09), .Y(n_C_6B) );
  AND4X1 C1W ( .A(n_EEV03), .B(n_EEV14), .C(n_EEV18), .D(n_EEV20), .Y(n_C_7G)
         );
  NOR2X1 C1K ( .A(n_C_7J), .B(n_BLD07), .Y(n_C_6E) );
  AND4X1 C1J ( .A(n_EEV05), .B(n_EEV13), .C(n_EEV16), .D(n_EEV19), .Y(n_C_7J)
         );
  AD5 C1G ( .E(n_EEV21), .D(n_EEV18), .C(n_EEV07), .B(n_EEV05), .A(n_EEV03), 
        .Y(n_C_7K) );
  NOR2X1 C1H ( .A(n_C_7K), .B(n_BLD06), .Y(n_C_6F) );
  NOR2X1 C1D ( .A(n_C_7M), .B(n_BLD04), .Y(n_C_6G) );
  AND4X1 C1C ( .A(n_EEV01), .B(n_EEV04), .C(n_EEV07), .D(n_EEV14), .Y(n_C_7M)
         );
  NOR2X1 C1B ( .A(n_C_7N), .B(n_BLD03), .Y(n_C_6H) );
  AD6 C1A ( .F(n_EEV18), .E(n_EEV14), .D(n_EEV12), .C(n_EEV07), .B(n_EEV03), 
        .A(n_EEV01), .Y(n_C_7N) );
  NOR2X1 C0C ( .A(n_C_7R), .B(n_C_7P), .Y(n_C_6K) );
  AND4X1 C07 ( .A(n_EEV00), .B(n_EEV09), .C(n_EEV12), .D(n_EEV21), .Y(n_C_7R)
         );
  NR5 D4V ( .E(n_D_95), .D(n_D_9H), .C(n_D_90), .B(n_D_75), .A(n_D_9T), .Y(
        n_D_9S) );
  AOI21X1 D9U ( .A0(n_EEV03), .A1(n_EEV10), .B0(n_BLD21), .Y(n_D_8D) );
  AOI21X1 D9N ( .A0(n_EEV15), .A1(n_EEV22), .B0(n_BLD01), .Y(n_D_74) );
  AOI21X1 D3G ( .A0(n_EEV02), .A1(n_EEV09), .B0(n_BLD21), .Y(n_D_20) );
  AOI21X1 D8A ( .A0(n_EEV12), .A1(n_EEV19), .B0(n_BLD01), .Y(n_D_75) );
  NR5 D9C ( .E(n_D_8D), .D(n_D_7F), .C(n_D_71), .B(n_D_85), .A(n_D_15), .Y(
        n_D_94) );
  NR5 D7L ( .E(n_D_8N), .D(n_D_74), .C(n_D_8R), .B(n_D_8S), .A(n_D_9K), .Y(
        n_D_70) );
  NR5 D4X ( .E(n_D_20), .D(n_D_9M), .C(n_D_8B), .B(n_D_8C), .A(n_D_89), .Y(
        n_D_9L) );
  AOI22X1 D81 ( .A0(n_EEV08), .A1(n_EEV14), .B0(n_BLD12), .B1(n_BLD16), .Y(
        n_D_76) );
  AOI31X1 D6C ( .A0(n_EEV01), .A1(n_EEV10), .A2(n_EEV22), .B0(n_BLD06), .Y(
        n_D_7G) );
  AOI31X1 D55 ( .A0(n_EEV06), .A1(n_EEV09), .A2(n_EEV12), .B0(n_BLD00), .Y(
        n_D_9K) );
  AOI31X1 D2L ( .A0(n_EEV00), .A1(n_EEV09), .A2(n_EEV19), .B0(n_BLD06), .Y(
        n_D_4C) );
  AOI22X1 D45 ( .A0(n_EEV05), .A1(n_EEV13), .B0(n_BLD12), .B1(n_BLD16), .Y(
        n_D_7U) );
  AND4X1 D6H ( .A(n_EEV01), .B(n_EEV04), .C(n_EEV08), .D(n_EEV11), .Y(n_D_3Y)
         );
  AD5 D66 ( .E(n_EEV18), .D(n_EEV11), .C(n_EEV08), .B(n_EEV04), .A(n_EEV01), 
        .Y(n_D_79) );
  NOR2X1 D61 ( .A(n_D_7W), .B(n_BLD04), .Y(n_D_8N) );
  AD5 D78 ( .E(n_EEV15), .D(n_EEV12), .C(n_EEV09), .B(n_EEV06), .A(n_EEV00), 
        .Y(n_D_9D) );
  AD6 D2C ( .F(n_EEV19), .E(n_EEV15), .D(n_EEV12), .C(n_EEV09), .B(n_EEV06), 
        .A(n_EEV00), .Y(n_D_92) );
  AD7 D8T ( .G(n_EEV23), .F(n_EEV19), .E(n_EEV15), .D(n_EEV14), .C(n_EEV10), 
        .B(n_EEV06), .A(n_EEV05), .Y(n_D_7P) );
  AD7 D6Y ( .G(n_EEV19), .F(n_EEV16), .E(n_EEV12), .D(n_EEV08), .C(n_EEV06), 
        .B(n_EEV02), .A(n_EEV00), .Y(n_D_7A) );
  AD7 D6N ( .G(n_EEV19), .F(n_EEV16), .E(n_EEV15), .D(n_EEV11), .C(n_EEV08), 
        .B(n_EEV04), .A(n_EEV01), .Y(n_D_83) );
  AD7 D60 ( .G(n_EEV21), .F(n_EEV18), .E(n_EEV17), .D(n_EEV12), .C(n_EEV10), 
        .B(n_EEV06), .A(n_EEV05), .Y(n_D_7W) );
  AD7 D0E ( .G(n_EEV22), .F(n_EEV16), .E(n_EEV12), .D(n_EEV09), .C(n_EEV06), 
        .B(n_EEV04), .A(n_EEV01), .Y(n_D_87) );
  AD7 D2X ( .G(n_EEV19), .F(n_EEV17), .E(n_EEV15), .D(n_EEV13), .C(n_EEV09), 
        .B(n_EEV05), .A(n_EEV00), .Y(n_D_1F) );
  AD7 D23 ( .G(n_EEV21), .F(n_EEV19), .E(n_EEV16), .D(n_EEV13), .C(n_EEV11), 
        .B(n_EEV09), .A(n_EEV02), .Y(n_D_96) );
  AD9 D3R ( .I(n_EEV19), .H(n_EEV18), .G(n_EEV16), .F(n_EEV14), .E(n_EEV12), 
        .D(n_EEV09), .C(n_EEV07), .B(n_EEV05), .A(n_EEV02), .Y(n_D_91) );
  AD5 D3H ( .E(n_EEV19), .D(n_EEV14), .C(n_EEV11), .B(n_EEV05), .A(n_EEV02), 
        .Y(n_D_9B) );
  AD5 D5P ( .E(n_EEV22), .D(n_EEV19), .C(n_EEV15), .B(n_EEV08), .A(n_EEV04), 
        .Y(n_D_6M) );
  AD5 D1W ( .E(n_EEV21), .D(n_EEV19), .C(n_EEV16), .B(n_EEV09), .A(n_EEV05), 
        .Y(n_D_9J) );
  AND2X1 D8C ( .A(n_BLD13), .B(n_BLD17), .Y(n_D_7D) );
  AND2X1 D4C ( .A(n_BLD13), .B(n_BLD17), .Y(n_D_8L) );
  AND2X1 D8L ( .A(n_BLD14), .B(n_BLD18), .Y(n_D_7C) );
  AND2X1 D5B ( .A(n_BLD02), .B(n_BLD20), .Y(n_D_80) );
  AND2X1 D4F ( .A(n_BLD14), .B(n_BLD18), .Y(n_D_8J) );
  AND2X1 D1G ( .A(n_BLD02), .B(n_BLD20), .Y(n_D_98) );
  AND2X2 D9E ( .A(n_ENP), .B(n_D_6T), .Y(EBLE) );
  AND2X2 D9D ( .A(n_ENP), .B(n_D_6S), .Y(EALE) );
  NOR4X1 D9B ( .A(n_D_7Y), .B(n_D_9C), .C(n_D_77), .D(n_D_76), .Y(n_D_6V) );
  NOR2X1 D96 ( .A(n_D_78), .B(n_BLD19), .Y(n_D_7F) );
  AND4X1 D95 ( .A(n_EEV04), .B(n_EEV10), .C(n_EEV16), .D(n_EEV21), .Y(n_D_78)
         );
  NOR2X1 D8U ( .A(n_D_7P), .B(n_BLD15), .Y(n_D_71) );
  NOR2X1 D8M ( .A(n_D_7B), .B(n_D_7C), .Y(n_D_85) );
  AND4X1 D8K ( .A(n_EEV06), .B(n_EEV07), .C(n_EEV15), .D(n_EEV21), .Y(n_D_7B)
         );
  NOR2X1 D8J ( .A(n_D_7E), .B(n_D_7D), .Y(n_D_15) );
  AD5 D8B ( .E(n_EEV21), .D(n_EEV16), .C(n_EEV11), .B(n_EEV09), .A(n_EEV02), 
        .Y(n_D_7E) );
  NAND4X1 D7N ( .A(n_D_70), .B(n_D_7X), .C(n_D_6V), .D(n_D_94), .Y(n_D_6T) );
  NOR4X1 D7M ( .A(n_D_7T), .B(n_D_7G), .C(n_D_7L), .D(n_D_84), .Y(n_D_7X) );
  NOR2X1 D7K ( .A(n_D_7H), .B(n_BLD11), .Y(n_D_77) );
  AD8 D7H ( .H(n_EEV23), .G(n_EEV19), .F(n_EEV15), .E(n_EEV14), .D(n_EEV10), 
        .C(n_EEV08), .B(n_EEV06), .A(n_EEV03), .Y(n_D_7H) );
  NOR4X1 D4U ( .A(n_D_6L), .B(n_D_7K), .C(n_D_8E), .D(n_D_7U), .Y(n_D_86) );
  NOR4X1 D4W ( .A(n_D_88), .B(n_D_4C), .C(n_D_8U), .D(n_D_8T), .Y(n_D_9R) );
  AD6 D79 ( .F(n_EEV23), .E(n_EEV22), .D(n_EEV15), .C(n_EEV09), .B(n_EEV06), 
        .A(n_EEV02), .Y(n_D_7J) );
  NOR2X1 D7A ( .A(n_D_7J), .B(n_BLD10), .Y(n_D_9C) );
  NOR2X1 D70 ( .A(n_D_7A), .B(n_BLD09), .Y(n_D_7Y) );
  NOR2X1 D6P ( .A(n_D_83), .B(n_BLD08), .Y(n_D_84) );
  NOR2X1 D6J ( .A(n_D_3Y), .B(n_BLD07), .Y(n_D_7L) );
  NOR2X1 D6B ( .A(n_D_79), .B(n_BLD05), .Y(n_D_7T) );
  NOR2X1 D13 ( .A(n_D_6M), .B(n_BLD03), .Y(n_D_8R) );
  NAND4X1 D5R ( .A(n_D_9S), .B(n_D_9R), .C(n_D_86), .D(n_D_9L), .Y(n_D_6S) );
  NOR2X1 D5N ( .A(n_D_81), .B(n_D_80), .Y(n_D_8S) );
  AD8 D5A ( .H(n_EEV22), .G(n_EEV19), .F(n_EEV17), .E(n_EEV14), .D(n_EEV10), 
        .C(n_EEV07), .B(n_EEV05), .A(n_EEV02), .Y(n_D_81) );
  NOR2X1 D0R ( .A(n_D_8H), .B(n_BLD15), .Y(n_D_8B) );
  AD6 D0N ( .F(n_EEV18), .E(n_EEV16), .D(n_EEV14), .C(n_EEV12), .B(n_EEV09), 
        .A(n_EEV02), .Y(n_D_8H) );
  NOR2X1 D4N ( .A(n_D_8G), .B(n_BLD19), .Y(n_D_9M) );
  AND4X1 D4M ( .A(n_EEV03), .B(n_EEV09), .C(n_EEV15), .D(n_EEV22), .Y(n_D_8G)
         );
  NOR2X1 D4G ( .A(n_D_8K), .B(n_D_8J), .Y(n_D_8C) );
  AND4X1 D4E ( .A(n_EEV02), .B(n_EEV14), .C(n_EEV18), .D(n_EEV22), .Y(n_D_8K)
         );
  NOR2X1 D4D ( .A(n_D_8M), .B(n_D_8L), .Y(n_D_89) );
  AD5 D46 ( .E(n_EEV20), .D(n_EEV15), .C(n_EEV12), .B(n_EEV06), .A(n_EEV03), 
        .Y(n_D_8M) );
  NOR2X1 D3S ( .A(n_D_91), .B(n_BLD11), .Y(n_D_8E) );
  NOR2X1 D3J ( .A(n_D_9B), .B(n_BLD10), .Y(n_D_7K) );
  NOR2X1 D38 ( .A(n_D_87), .B(n_BLD09), .Y(n_D_6L) );
  NOR2X1 D2Y ( .A(n_D_1F), .B(n_BLD08), .Y(n_D_8T) );
  NOR2X1 D2S ( .A(n_D_9D), .B(n_BLD07), .Y(n_D_8U) );
  NOR2X1 D2J ( .A(n_D_92), .B(n_BLD05), .Y(n_D_88) );
  NOR2X1 D0D ( .A(n_D_96), .B(n_BLD04), .Y(n_D_95) );
  NOR2X1 D1X ( .A(n_D_9J), .B(n_BLD03), .Y(n_D_9H) );
  NOR2X1 D1V ( .A(n_D_99), .B(n_D_98), .Y(n_D_90) );
  NOR2X1 D1H ( .A(n_D_9F), .B(n_D_9E), .Y(n_D_99) );
  ND5 D1E ( .E(n_EEV22), .D(n_EEV19), .C(n_EEV17), .B(n_EEV16), .A(n_EEV13), 
        .Y(n_D_9E) );
  ND5 D1F ( .E(n_EEV10), .D(n_EEV07), .C(n_EEV05), .B(n_EEV04), .A(n_EEV01), 
        .Y(n_D_9F) );
  NOR2X1 D06 ( .A(n_D_9A), .B(n_BLD00), .Y(n_D_9T) );
  AND4X1 D05 ( .A(n_EEV05), .B(n_EEV08), .C(n_EEV11), .D(n_EEV14), .Y(n_D_9A)
         );
  AND2X2 E7R ( .A(n_ENP), .B(n_E_78), .Y(LFACLLE) );
  NOR2X1 E7K ( .A(n_E_7A), .B(n_E_79), .Y(n_E_78) );
  AND2X1 E7J ( .A(n_BLD05), .B(n_BLD07), .Y(n_E_79) );
  OR2X1 E5X ( .A(n_EEV02), .B(n_RP1), .Y(n_E_7A) );
  NOR3X1 E7H ( .A(n_E_4A), .B(n_E_4H), .C(n_E_49), .Y(n_E_2E) );
  NOR3X1 E7G ( .A(n_E_6S), .B(n_E_70), .C(n_E_42), .Y(n_E_3Y) );
  NAND2X1 E7F ( .A(n_E_3Y), .B(n_E_2E), .Y(n_E_5Y) );
  NOR2X1 E5E ( .A(n_EEV23), .B(n_BLD18), .Y(n_E_42) );
  NOR2X1 E4L ( .A(n_BLD14), .B(n_EEV23), .Y(n_E_2W) );
  NOR3X1 E4P ( .A(n_E_6U), .B(n_E_6J), .C(n_E_4F), .Y(n_E_6K) );
  NOR3X1 E4R ( .A(n_E_4G), .B(n_E_4L), .C(n_E_2W), .Y(n_E_2F) );
  INVX1 E78 ( .A(n_EEMILE), .Y(n_E_67) );
  AOI21X1 E6M ( .A0(n_EEV06), .A1(n_EEV13), .B0(n_BLD21), .Y(n_E_49) );
  AOI21X1 E3V ( .A0(n_EEV16), .A1(n_EEV23), .B0(n_BLD01), .Y(n_E_6J) );
  AD6 E3L ( .F(n_EEV15), .E(n_EEV13), .D(n_EEV10), .C(n_EEV07), .B(n_EEV04), 
        .A(n_EEV02), .Y(n_E_4R) );
  NOR2X1 E0K ( .A(n_EEV11), .B(n_BLD06), .Y(n_E_3H) );
  OR4X1 E6N ( .A(n_E_62), .B(n_E_6W), .C(n_E_6X), .D(n_E_6V), .Y(n_E_73) );
  AOI21X1 E6H ( .A0(n_EEV07), .A1(n_EEV10), .B0(n_BLD00), .Y(n_E_62) );
  AND2X2 E0P ( .A(n_ENP), .B(n_E_0G), .Y(DTLE) );
  AND2X2 E1V ( .A(n_ENP), .B(n_E_5N), .Y(EQACCL) );
  AOI21X1 E1A ( .A0(n_BLD05), .A1(n_BLD07), .B0(n_EEV06), .Y(n_E_0G) );
  NOR2X1 E21 ( .A(n_EEV00), .B(n_BLD00), .Y(n_E_5N) );
  AND2X2 E2U ( .A(n_ENP), .B(n_E_5B), .Y(TXLDLE) );
  AND2X2 E33 ( .A(n_ENP), .B(n_E_5C), .Y(TXRDLE) );
  NOR2X1 E3Y ( .A(n_EEV10), .B(n_BLD21), .Y(n_E_5B) );
  NOR2X1 E4D ( .A(n_EEV03), .B(n_BLD21), .Y(n_E_5C) );
  AOI21X1 E59 ( .A0(n_EEV11), .A1(n_EEV23), .B0(n_BLD20), .Y(n_E_4H) );
  AOI21X1 E4E ( .A0(n_EEV07), .A1(n_EEV12), .B0(n_BLD10), .Y(n_E_4L) );
  AOI21X1 E6D ( .A0(n_EEV06), .A1(n_EEV10), .B0(n_BLD08), .Y(n_E_70) );
  AOI21X1 E3X ( .A0(n_EEV11), .A1(n_EEV23), .B0(n_BLD02), .Y(n_E_4F) );
  AOI21X1 E31 ( .A0(n_BLD13), .A1(n_BLD17), .B0(n_EEV10), .Y(n_E_69) );
  AOI21X1 E2V ( .A0(n_BLD12), .A1(n_BLD16), .B0(n_EEV14), .Y(n_E_4M) );
  AOI21X1 E2L ( .A0(n_EEV19), .A1(n_EEV23), .B0(n_BLD09), .Y(n_E_6A) );
  AOI31X1 E28 ( .A0(n_EEV04), .A1(n_EEV06), .A2(n_EEV23), .B0(n_BLD06), .Y(
        n_E_4K) );
  AOI21X1 E67 ( .A0(n_BLD03), .A1(n_BLD04), .B0(n_EEV23), .Y(n_E_4P) );
  AOI21X1 E1U ( .A0(n_EEV16), .A1(n_EEV23), .B0(n_BLD01), .Y(n_E_58) );
  AOI31X1 E1J ( .A0(n_EEV15), .A1(n_EEV20), .A2(n_EEV22), .B0(n_BLD15), .Y(
        n_E_1Y) );
  AOI32X1 E1P ( .A0(n_EEV04), .A1(n_EEV17), .A2(n_EEV22), .B0(n_BLD13), .B1(
        n_BLD17), .Y(n_E_57) );
  AOI21X1 E17 ( .A0(n_BLD12), .A1(n_BLD16), .B0(n_EEV06), .Y(n_E_63) );
  AOI31X1 E15 ( .A0(n_EEV15), .A1(n_EEV20), .A2(n_EEV22), .B0(n_BLD11), .Y(
        n_E_56) );
  AOI31X1 E0N ( .A0(n_EEV16), .A1(n_EEV20), .A2(n_EEV21), .B0(n_BLD08), .Y(
        n_E_4Y) );
  AOI22X1 E5V ( .A0(n_EEV07), .A1(n_EEV10), .B0(n_BLD05), .B1(n_BLD07), .Y(
        n_E_53) );
  AOI21X1 E02 ( .A0(n_EEV18), .A1(n_EEV22), .B0(n_BLD04), .Y(n_E_5U) );
  NAND3X1 E1T ( .A(n_E_67), .B(n_E_3P), .C(n_E_3R), .Y(n_E_72) );
  AND2X2 E76 ( .A(n_ENP), .B(n_E_6P), .Y(ESSCL) );
  NOR2X1 E75 ( .A(n_EEV00), .B(n_BLD00), .Y(n_E_6P) );
  AND2X2 E6P ( .A(n_ENP), .B(n_E_73), .Y(ESSCE) );
  NOR2X1 E6L ( .A(n_EEV02), .B(n_BLD09), .Y(n_E_6V) );
  NOR2X1 E6K ( .A(n_EEV00), .B(n_BLD08), .Y(n_E_6X) );
  NOR2X1 E6J ( .A(n_EEV12), .B(n_BLD04), .Y(n_E_6W) );
  NR5 E3H ( .E(n_E_4S), .D(n_E_4T), .C(n_E_69), .B(n_E_4M), .A(n_E_47), .Y(
        n_E_5G) );
  NOR2X1 E69 ( .A(n_EEV16), .B(n_BLD10), .Y(n_E_65) );
  AND2X2 E65 ( .A(n_ENP), .B(n_E_74), .Y(EQACCE) );
  NOR2X1 E64 ( .A(n_E_4D), .B(n_E_60), .Y(n_E_74) );
  AND2X1 E61 ( .A(n_EEV09), .B(n_EEV21), .Y(n_E_60) );
  AND2X1 E4T ( .A(n_BLD02), .B(n_BLD20), .Y(n_E_4D) );
  AND2X1 E5T ( .A(n_BLD05), .B(n_BLD07), .Y(n_E_3M) );
  OR2X1 E0F ( .A(n_EEV02), .B(n_RP1), .Y(n_E_3N) );
  NOR2X1 E5S ( .A(n_E_3N), .B(n_E_3M), .Y(n_E_3L) );
  AND2X2 E5G ( .A(n_ENP), .B(n_E_3K), .Y(ETLE) );
  AND2X2 E5K ( .A(n_ENP), .B(n_E_5Y), .Y(EOLE) );
  AND2X2 E5J ( .A(n_ENP), .B(n_E_75), .Y(EQACLE) );
  AND2X2 E5H ( .A(n_ENP), .B(n_E_41), .Y(ERLE) );
  NAND2X1 E5F ( .A(n_E_6K), .B(n_E_2F), .Y(n_E_41) );
  NOR2X1 E53 ( .A(n_E_4B), .B(n_BLD19), .Y(n_E_4A) );
  AND4X1 E52 ( .A(n_EEV05), .B(n_EEV11), .C(n_EEV17), .D(n_EEV23), .Y(n_E_4B)
         );
  NOR2X1 E51 ( .A(n_E_4C), .B(n_E_4D), .Y(n_E_75) );
  AND4X1 E4S ( .A(n_EEV06), .B(n_EEV08), .C(n_EEV18), .D(n_EEV20), .Y(n_E_4C)
         );
  NOR2X1 E4A ( .A(n_EEV20), .B(n_BLD05), .Y(n_E_4G) );
  NOR2X1 E49 ( .A(n_E_4N), .B(n_BLD03), .Y(n_E_6S) );
  AND4X1 E43 ( .A(n_EEV06), .B(n_EEV10), .C(n_EEV17), .D(n_EEV20), .Y(n_E_4N)
         );
  NOR2X1 E3R ( .A(n_E_4R), .B(n_BLD00), .Y(n_E_6U) );
  NAND3X1 E3J ( .A(n_E_5S), .B(n_E_5H), .C(n_E_5G), .Y(n_E_3K) );
  NOR4X1 E3G ( .A(n_E_4X), .B(n_E_50), .C(n_E_6A), .D(n_E_65), .Y(n_E_5H) );
  NOR4X1 E3F ( .A(n_E_58), .B(n_E_4P), .C(n_E_51), .D(n_E_4K), .Y(n_E_5S) );
  NOR2X1 E39 ( .A(n_E_55), .B(n_BLD19), .Y(n_E_4S) );
  AND4X1 E38 ( .A(n_EEV02), .B(n_EEV08), .C(n_EEV14), .D(n_EEV20), .Y(n_E_55)
         );
  NOR2X1 E35 ( .A(n_EEV21), .B(n_BLD15), .Y(n_E_4T) );
  NOR2X1 E2R ( .A(n_EEV21), .B(n_BLD11), .Y(n_E_47) );
  NOR2X1 E2G ( .A(n_EEV02), .B(n_BLD08), .Y(n_E_50) );
  NOR2X1 E2D ( .A(n_EEV20), .B(n_BLD07), .Y(n_E_4X) );
  NOR2X1 E24 ( .A(n_EEV17), .B(n_BLD05), .Y(n_E_51) );
  AND2X2 E20 ( .A(n_ENP), .B(n_E_72), .Y(EIMWE) );
  NR5 E1S ( .E(n_E_1Y), .D(n_E_57), .C(n_E_63), .B(n_E_56), .A(n_E_5D), .Y(
        n_E_3R) );
  NR5 E1R ( .E(n_E_4Y), .D(n_E_3H), .C(n_E_3L), .B(n_E_53), .A(n_E_5U), .Y(
        n_E_3P) );
  NOR2X1 E0V ( .A(n_E_5K), .B(n_BLD09), .Y(n_E_5D) );
  AND3X1 E0U ( .A(n_EEV07), .B(n_EEV13), .C(n_EEV17), .Y(n_E_5K) );
  NR5 F2A ( .E(n_F_5G), .D(n_F_5C), .C(n_F_63), .B(n_F_3L), .A(n_F_5L), .Y(
        n_F_68) );
  NOR2X1 F2S ( .A(n_EEV23), .B(n_BLD00), .Y(n_F_5L) );
  NOR2X1 F31 ( .A(n_EEV07), .B(n_BLD15), .Y(n_F_1R) );
  AND2X1 F1W ( .A(n_EEV03), .B(n_EEV11), .Y(n_F_5U) );
  NOR3X1 F1H ( .A(n_F_0T), .B(n_F_6F), .C(n_F_66), .Y(n_F_69) );
  NOR2X1 F1M ( .A(n_F_5U), .B(n_F_5B), .Y(n_F_6F) );
  AND2X1 F2C ( .A(n_BLD12), .B(n_BLD16), .Y(n_F_5B) );
  OR2X1 F6K ( .A(n_F_51), .B(n_F_5J), .Y(n_F_6P) );
  NOR2X1 F7X ( .A(n_EEV13), .B(n_BLD06), .Y(n_F_5J) );
  AOI22X1 F0K ( .A0(n_EEV08), .A1(n_EEV20), .B0(n_BLD05), .B1(n_BLD07), .Y(
        n_F_51) );
  OR4X1 F1A ( .A(n_F_6R), .B(n_F_4X), .C(n_F_4R), .D(n_F_6M), .Y(n_F_6L) );
  NOR2X1 F7H ( .A(n_EEV13), .B(n_BLD06), .Y(n_F_4X) );
  AND4X1 F6B ( .A(n_EEV03), .B(n_EEV07), .C(n_EEV15), .D(n_EEV19), .Y(n_F_5P)
         );
  AOI22X1 F5W ( .A0(n_EEV05), .A1(n_EEV08), .B0(n_BLD12), .B1(n_BLD16), .Y(
        n_F_41) );
  NOR4X1 F0Y ( .A(n_F_5F), .B(n_F_5E), .C(n_F_7C), .D(n_F_5D), .Y(n_F_7D) );
  NOR2X1 F41 ( .A(n_EEV23), .B(n_BLD06), .Y(n_F_5T) );
  NOR2X1 F32 ( .A(n_EEV03), .B(n_BLD19), .Y(n_F_4S) );
  NOR4X1 F2B ( .A(n_F_5H), .B(n_F_0R), .C(n_F_62), .D(n_F_6K), .Y(n_F_6N) );
  AND2X1 F2R ( .A(n_RP0), .B(n_RP2), .Y(n_F_6A) );
  AND2X1 F2P ( .A(n_RP1), .B(n_RP3), .Y(n_F_7L) );
  AND2X2 F04 ( .A(n_ENP), .B(n_F_7J), .Y(n_EMEDLE) );
  AND2X2 F75 ( .A(n_ENP), .B(n_F_7K), .Y(n_EMEDSE) );
  NOR3X1 F6C ( .A(n_F_5N), .B(n_EEV00), .C(n_F_7L), .Y(n_F_7J) );
  NOR3X1 F5X ( .A(n_F_5N), .B(n_EEV00), .C(n_F_6A), .Y(n_F_7K) );
  AOI31X1 F7A ( .A0(n_EEV14), .A1(n_EEV16), .A2(n_EEV20), .B0(n_BLD09), .Y(
        n_F_4R) );
  AOI22X1 F70 ( .A0(n_EEV11), .A1(n_EEV17), .B0(n_BLD05), .B1(n_BLD07), .Y(
        n_F_6R) );
  AOI22X1 F6T ( .A0(n_EEV21), .A1(n_EEV23), .B0(n_BLD11), .B1(n_BLD15), .Y(
        n_F_4Y) );
  AOI31X1 F1R ( .A0(n_EEV02), .A1(n_EEV15), .A2(n_EEV22), .B0(n_BLD10), .Y(
        n_F_0T) );
  AOI21X1 F1L ( .A0(n_EEV13), .A1(n_EEV19), .B0(n_BLD09), .Y(n_F_6K) );
  AOI21X1 F1G ( .A0(n_EEV01), .A1(n_EEV10), .B0(n_BLD08), .Y(n_F_62) );
  AOI32X1 F1B ( .A0(n_EEV00), .A1(n_EEV02), .A2(n_EEV04), .B0(n_BLD05), .B1(
        n_BLD07), .Y(n_F_5H) );
  AOI21X1 F0T ( .A0(n_EEV05), .A1(n_EEV20), .B0(n_BLD04), .Y(n_F_5G) );
  AOI31X1 F0J ( .A0(n_EEV05), .A1(n_EEV13), .A2(n_EEV22), .B0(n_BLD03), .Y(
        n_F_5C) );
  AOI21X1 F03 ( .A0(n_EEV10), .A1(n_EEV22), .B0(n_BLD02), .Y(n_F_63) );
  AOI21X1 F5K ( .A0(n_EEV17), .A1(n_EEV23), .B0(n_BLD01), .Y(n_F_3L) );
  AND2X1 F1D ( .A(n_BLD05), .B(n_BLD07), .Y(n_F_7R) );
  AND2X2 F5Y ( .A(n_ENP), .B(n_F_6L), .Y(n_EMCPDCE) );
  AND2X2 F7J ( .A(n_ENP), .B(n_F_6P), .Y(n_EMCPACE) );
  AND2X2 F7G ( .A(n_ENP), .B(n_F_55), .Y(n_EMEDCE) );
  NAND2X1 F7F ( .A(n_F_6C), .B(n_F_7M), .Y(n_F_55) );
  NOR2X1 F7E ( .A(n_F_7N), .B(n_F_0S), .Y(n_F_7M) );
  NOR2X1 F7D ( .A(n_F_4Y), .B(n_F_41), .Y(n_F_6C) );
  AND2X2 F4Y ( .A(n_ENP), .B(n_F_56), .Y(n_EMPMLE) );
  NOR2X1 F7B ( .A(n_EEV00), .B(n_BLD10), .Y(n_F_6M) );
  NOR2X1 F6L ( .A(n_F_5P), .B(n_F_5N), .Y(n_F_0S) );
  AND2X1 F6D ( .A(n_BLD14), .B(n_BLD18), .Y(n_F_5N) );
  NOR2X1 F6A ( .A(n_F_5S), .B(n_F_5R), .Y(n_F_7N) );
  AND2X1 F68 ( .A(n_BLD13), .B(n_BLD17), .Y(n_F_5R) );
  AND4X1 F62 ( .A(n_EEV03), .B(n_EEV10), .C(n_EEV21), .D(n_EEV23), .Y(n_F_5S)
         );
  AD5 F2G ( .E(n_EEV21), .D(n_EEV19), .C(n_EEV15), .B(n_EEV07), .A(n_EEV03), 
        .Y(n_F_60) );
  AND4X1 F0X ( .A(n_EEV01), .B(n_EEV06), .C(n_EEV15), .D(n_EEV22), .Y(n_F_61)
         );
  NOR4X1 F33 ( .A(n_F_5V), .B(n_F_1R), .C(n_F_4S), .D(n_F_5X), .Y(n_F_5W) );
  NOR2X1 F5M ( .A(n_EEV22), .B(n_BLD20), .Y(n_F_5X) );
  NOR2X1 F2E ( .A(n_F_60), .B(n_F_5Y), .Y(n_F_5V) );
  AND4X1 F1F ( .A(n_EEV00), .B(n_EEV07), .C(n_EEV18), .D(n_EEV21), .Y(n_F_6H)
         );
  NAND2X1 F5H ( .A(n_F_57), .B(n_F_6B), .Y(n_F_56) );
  NOR2X1 F5G ( .A(n_F_6U), .B(n_F_6T), .Y(n_F_6B) );
  NOR3X1 F5E ( .A(n_F_67), .B(n_F_6X), .C(n_F_6V), .Y(n_F_57) );
  AND2X2 F5B ( .A(n_ENP), .B(n_F_6Y), .Y(n_EMPMSE) );
  NAND3X1 F4F ( .A(n_F_76), .B(n_F_7D), .C(n_F_7A), .Y(n_F_6Y) );
  AND2X1 F5F ( .A(n_BLD14), .B(n_BLD18), .Y(n_F_71) );
  NOR3X1 F57 ( .A(n_EEV23), .B(n_RP3), .C(n_BLD20), .Y(n_F_6T) );
  AND2X1 F59 ( .A(n_BLD12), .B(n_BLD16), .Y(n_F_73) );
  AND2X1 F23 ( .A(n_BLD13), .B(n_BLD17), .Y(n_F_6G) );
  AND2X1 F2F ( .A(n_BLD14), .B(n_BLD18), .Y(n_F_5Y) );
  AND2X1 F5C ( .A(n_BLD13), .B(n_BLD17), .Y(n_F_75) );
  AND2X1 F58 ( .A(n_RP0), .B(n_RP2), .Y(n_F_70) );
  AND3X1 F4R ( .A(n_RP0), .B(n_RP1), .C(n_RP2), .Y(n_F_74) );
  AND2X1 F54 ( .A(n_RP0), .B(n_RP1), .Y(n_F_72) );
  NOR3X1 F4N ( .A(n_EEV22), .B(n_F_73), .C(n_F_72), .Y(n_F_6X) );
  NOR3X1 F52 ( .A(n_EEV22), .B(n_F_71), .C(n_F_70), .Y(n_F_6U) );
  NOR3X1 F50 ( .A(n_EEV23), .B(n_F_75), .C(n_F_74), .Y(n_F_6V) );
  NOR3X1 F4A ( .A(n_EEV20), .B(n_RP0), .C(n_F_7R), .Y(n_F_67) );
  NOR3X1 F42 ( .A(n_F_79), .B(n_F_78), .C(n_F_7B), .Y(n_F_7A) );
  NOR4X1 F40 ( .A(n_F_6D), .B(n_F_5T), .C(n_F_1U), .D(n_F_4M), .Y(n_F_76) );
  NOR2X1 F3W ( .A(n_EEV18), .B(n_BLD19), .Y(n_F_7B) );
  NOR3X1 F3T ( .A(n_EEV23), .B(n_RP1), .C(n_BLD18), .Y(n_F_78) );
  NOR3X1 F3P ( .A(n_EEV22), .B(n_RP3), .C(n_BLD17), .Y(n_F_79) );
  NOR3X1 F3L ( .A(n_EEV19), .B(n_RP2), .C(n_BLD16), .Y(n_F_5D) );
  NOR2X1 F3J ( .A(n_EEV20), .B(n_BLD15), .Y(n_F_7C) );
  NOR3X1 F3A ( .A(n_EEV23), .B(n_RP1), .C(n_BLD14), .Y(n_F_5E) );
  NOR3X1 F3D ( .A(n_EEV23), .B(n_RP3), .C(n_BLD13), .Y(n_F_5F) );
  NOR3X1 F3F ( .A(n_EEV22), .B(n_RP2), .C(n_BLD12), .Y(n_F_4M) );
  NOR2X1 F38 ( .A(n_EEV23), .B(n_BLD11), .Y(n_F_1U) );
  NOR2X1 F36 ( .A(n_EEV23), .B(n_BLD04), .Y(n_F_6D) );
  AND2X2 F35 ( .A(n_ENP), .B(n_F_7G), .Y(n_EMPMCE) );
  NAND4X1 F34 ( .A(n_F_68), .B(n_F_6N), .C(n_F_69), .D(n_F_5W), .Y(n_F_7G) );
  NOR2X1 F24 ( .A(n_F_6H), .B(n_F_6G), .Y(n_F_66) );
  NOR2X1 F15 ( .A(n_F_61), .B(n_BLD06), .Y(n_F_0R) );
  NOR2X1 G0S ( .A(n_G_6M), .B(n_BLD21), .Y(n_G_5P) );
  NR5 G4V ( .E(n_G_5P), .D(n_G_7N), .C(n_G_0T), .B(n_G_0S), .A(n_G_78), .Y(
        n_G_7J) );
  AND4X1 G1B ( .A(n_EEV01), .B(n_EEV04), .C(n_EEV08), .D(n_EEV11), .Y(n_G_6M)
         );
  AOI22X1 G71 ( .A0(n_EEV07), .A1(n_EEV10), .B0(n_BLD05), .B1(n_BLD07), .Y(
        n_EMCPAEN) );
  NR5 G4S ( .E(n_G_9C), .D(n_G_0B), .C(n_G_96), .B(n_G_94), .A(n_G_9B), .Y(
        n_G_5W) );
  NOR2X1 G1C ( .A(n_G_93), .B(n_BLD01), .Y(n_G_94) );
  AND4X1 G1F ( .A(n_EEV11), .B(n_EEV14), .C(n_EEV18), .D(n_EEV21), .Y(n_G_93)
         );
  NOR2X1 G1D ( .A(n_EEV00), .B(n_BLD00), .Y(n_G_9B) );
  AND2X1 G7N ( .A(n_RP4), .B(n_G_6K), .Y(n_G_6S) );
  BUFX2 G63 ( .A(n_BLD20), .Y(n_G_75) );
  AND4X1 G8T ( .A(n_RP0), .B(n_RP1), .C(n_RP2), .D(n_RP3), .Y(n_G_6K) );
  AOI31X1 G32 ( .A0(n_EEV03), .A1(n_EEV07), .A2(n_EEV12), .B0(n_BLD08), .Y(
        n_G_5R) );
  AOI21X1 G3T ( .A0(n_EEV00), .A1(n_EEV11), .B0(n_BLD11), .Y(n_G_2G) );
  OR5 G0T ( .E(n_G_9A), .D(n_G_97), .C(n_G_8K), .B(n_G_98), .A(n_G_7X), .Y(
        n_G_7M) );
  AOI21X1 G8M ( .A0(n_EEV16), .A1(n_EEV23), .B0(n_BLD08), .Y(n_G_98) );
  AOI21X1 G0D ( .A0(n_EEV18), .A1(n_EEV23), .B0(n_BLD04), .Y(n_G_7X) );
  NAND4X2 G54 ( .A(n_G_5W), .B(n_G_6V), .C(n_G_8A), .D(n_G_7J), .Y(n_EMPMEN)
         );
  AOI32X1 G8H ( .A0(n_EEV12), .A1(n_EEV16), .A2(n_EEV17), .B0(n_BLD13), .B1(
        n_BLD17), .Y(n_G_6Y) );
  AOI31X1 G5W ( .A0(n_EEV15), .A1(n_EEV17), .A2(n_EEV21), .B0(n_BLD09), .Y(
        n_G_6D) );
  AOI22X1 G68 ( .A0(n_EEV03), .A1(n_EEV06), .B0(n_BLD12), .B1(n_BLD16), .Y(
        n_G_6L) );
  AOI22X1 G5N ( .A0(n_EEV21), .A1(n_EEV22), .B0(n_BLD11), .B1(n_BLD15), .Y(
        n_G_77) );
  AOI32X1 G41 ( .A0(n_EEV04), .A1(n_EEV07), .A2(n_EEV12), .B0(n_BLD12), .B1(
        n_BLD16), .Y(n_G_87) );
  AOI21X1 G0M ( .A0(n_BLD13), .A1(n_BLD17), .B0(n_EEV10), .Y(n_G_9A) );
  AOI22X1 G0G ( .A0(n_EEV10), .A1(n_EEV15), .B0(n_BLD11), .B1(n_BLD15), .Y(
        n_G_97) );
  NOR3X2 G7E ( .A(n_G_9D), .B(n_G_75), .C(n_G_6S), .Y(n_DLDADE) );
  NOR3X2 G8U ( .A(n_G_9E), .B(n_G_75), .C(n_G_6S), .Y(n_DLDAEN) );
  NOR2X1 G9A ( .A(n_G_6E), .B(n_G_6Y), .Y(n_G_6C) );
  AND2X1 G8V ( .A(n_BLD11), .B(n_BLD15), .Y(n_G_5S) );
  AND2X1 G9N ( .A(n_EEV03), .B(n_EEV19), .Y(n_G_9D) );
  AND3X1 G99 ( .A(n_EEV18), .B(n_EEV19), .C(n_EEV03), .Y(n_G_9E) );
  NAND2X2 G9B ( .A(n_G_6B), .B(n_G_6C), .Y(n_EMACAEN) );
  NOR3X1 G97 ( .A(n_G_6H), .B(n_G_6J), .C(n_G_6G), .Y(n_G_6B) );
  NOR2X1 G8F ( .A(n_G_71), .B(n_G_5S), .Y(n_G_6E) );
  AD6 G88 ( .F(n_EEV20), .E(n_EEV19), .D(n_EEV16), .C(n_EEV15), .B(n_EEV14), 
        .A(n_EEV12), .Y(n_G_71) );
  NOR2X1 G81 ( .A(n_G_72), .B(n_BLD09), .Y(n_G_6G) );
  AD6 G80 ( .F(n_EEV13), .E(n_EEV12), .D(n_EEV09), .C(n_EEV07), .B(n_EEV06), 
        .A(n_EEV04), .Y(n_G_72) );
  NOR2X1 G7S ( .A(n_G_73), .B(n_BLD08), .Y(n_G_6J) );
  AD6 G7R ( .F(n_EEV20), .E(n_EEV19), .D(n_EEV17), .C(n_EEV16), .B(n_EEV15), 
        .A(n_EEV13), .Y(n_G_73) );
  NOR2X1 G78 ( .A(n_G_74), .B(n_BLD04), .Y(n_G_6H) );
  AD6 G77 ( .F(n_EEV22), .E(n_EEV21), .D(n_EEV19), .C(n_EEV18), .B(n_EEV17), 
        .A(n_EEV13), .Y(n_G_74) );
  OR5D2 G6X ( .E(n_G_7B), .D(n_G_6D), .C(n_G_7D), .B(n_G_7E), .A(n_G_7F), .Y(
        n_EMCPADEN) );
  OR4X2 G6W ( .A(n_G_77), .B(n_G_6L), .C(n_G_7L), .D(n_G_7K), .Y(n_EMEDEN) );
  NOR2X1 G6V ( .A(n_G_7U), .B(n_G_7T), .Y(n_G_7K) );
  AND2X1 G6N ( .A(n_BLD14), .B(n_BLD18), .Y(n_G_7T) );
  AND4X1 G6M ( .A(n_EEV01), .B(n_EEV05), .C(n_EEV13), .D(n_EEV17), .Y(n_G_7U)
         );
  NOR2X1 G6L ( .A(n_G_7W), .B(n_G_7V), .Y(n_G_7L) );
  AND2X1 G6F ( .A(n_BLD13), .B(n_BLD17), .Y(n_G_7V) );
  AND4X1 G6E ( .A(n_EEV00), .B(n_EEV04), .C(n_EEV11), .D(n_EEV22), .Y(n_G_7W)
         );
  NOR2X1 G61 ( .A(n_EEV01), .B(n_BLD10), .Y(n_G_7B) );
  NOR2X1 G5T ( .A(n_EEV21), .B(n_BLD08), .Y(n_G_7D) );
  NOR2X1 G5R ( .A(n_EEV11), .B(n_BLD06), .Y(n_G_7E) );
  NOR2X1 G5P ( .A(n_G_7S), .B(n_G_7R), .Y(n_G_7F) );
  AND2X1 G5A ( .A(n_BLD05), .B(n_BLD07), .Y(n_G_7R) );
  AND4X1 G59 ( .A(n_EEV07), .B(n_EEV10), .C(n_EEV11), .D(n_EEV12), .Y(n_G_7S)
         );
  AND2X2 G16 ( .A(n_G_7M), .B(n_ENP), .Y(n_EMACCE) );
  NOR2X1 G53 ( .A(n_EEV01), .B(n_BLD19), .Y(n_G_7N) );
  NOR2X1 G4W ( .A(n_G_86), .B(n_BLD15), .Y(n_G_0T) );
  AND4X1 G4A ( .A(n_EEV01), .B(n_EEV04), .C(n_EEV08), .D(n_EEV11), .Y(n_G_86)
         );
  NOR4X1 G4U ( .A(n_G_21), .B(n_G_89), .C(n_G_2G), .D(n_G_87), .Y(n_G_8A) );
  NOR4X1 G4T ( .A(n_G_81), .B(n_G_8D), .C(n_G_8C), .D(n_G_5R), .Y(n_G_6V) );
  AD5 G42 ( .E(n_EEV19), .D(n_EEV14), .C(n_EEV08), .B(n_EEV05), .A(n_EEV01), 
        .Y(n_G_8H) );
  NOR2X1 G4F ( .A(n_G_8F), .B(n_G_8E), .Y(n_G_0S) );
  AND2X1 G4E ( .A(n_BLD14), .B(n_BLD18), .Y(n_G_8E) );
  AD5 G4D ( .E(n_EEV20), .D(n_EEV16), .C(n_EEV12), .B(n_EEV04), .A(n_EEV00), 
        .Y(n_G_8F) );
  NOR2X1 G44 ( .A(n_G_8H), .B(n_G_8G), .Y(n_G_78) );
  AND2X1 G43 ( .A(n_BLD13), .B(n_BLD17), .Y(n_G_8G) );
  NOR2X1 G3L ( .A(n_G_8L), .B(n_BLD10), .Y(n_G_89) );
  AD5 G3K ( .E(n_EEV21), .D(n_EEV18), .C(n_EEV13), .B(n_EEV03), .A(n_EEV00), 
        .Y(n_G_8L) );
  NOR2X1 G3E ( .A(n_G_8M), .B(n_BLD09), .Y(n_G_21) );
  AND4X1 G3D ( .A(n_EEV03), .B(n_EEV14), .C(n_EEV18), .D(n_EEV20), .Y(n_G_8M)
         );
  NOR2X1 G2T ( .A(n_G_8P), .B(n_BLD07), .Y(n_G_8C) );
  AD6 G2S ( .F(n_EEV19), .E(n_EEV05), .D(n_EEV04), .C(n_EEV02), .B(n_EEV01), 
        .A(n_EEV00), .Y(n_G_8P) );
  NOR2X1 G2J ( .A(n_G_8R), .B(n_BLD06), .Y(n_G_8D) );
  AD5 G2H ( .E(n_EEV21), .D(n_EEV18), .C(n_EEV07), .B(n_EEV05), .A(n_EEV03), 
        .Y(n_G_8R) );
  NOR2X1 G2G ( .A(n_G_8S), .B(n_BLD05), .Y(n_G_81) );
  AD6 G1G ( .F(n_EEV16), .E(n_EEV05), .D(n_EEV04), .C(n_EEV02), .B(n_EEV01), 
        .A(n_EEV00), .Y(n_G_8S) );
  NOR2X1 G25 ( .A(n_G_8X), .B(n_BLD04), .Y(n_G_9C) );
  AND4X1 G24 ( .A(n_EEV01), .B(n_EEV04), .C(n_EEV07), .D(n_EEV14), .Y(n_G_8X)
         );
  NOR2X1 G1W ( .A(n_G_8Y), .B(n_BLD03), .Y(n_G_0B) );
  AD6 G1V ( .F(n_EEV18), .E(n_EEV14), .D(n_EEV12), .C(n_EEV07), .B(n_EEV03), 
        .A(n_EEV01), .Y(n_G_8Y) );
  AND2X1 G1S ( .A(n_BLD02), .B(n_BLD20), .Y(n_G_90) );
  NOR2X1 G1M ( .A(n_G_91), .B(n_G_90), .Y(n_G_96) );
  AND4X1 G1L ( .A(n_EEV00), .B(n_EEV09), .C(n_EEV12), .D(n_EEV21), .Y(n_G_91)
         );
  AND2X2 G19 ( .A(n_ENP), .B(n_G_6P), .Y(n_EMACLE) );
  AND2X2 G18 ( .A(n_ENP), .B(n_G_7A), .Y(EROALE) );
  AND2X2 G17 ( .A(n_ENP), .B(n_G_79), .Y(n_DLDACE) );
  NOR2X1 G13 ( .A(n_EEV00), .B(n_BLD00), .Y(n_G_6P) );
  NOR2X1 G0V ( .A(n_EEV03), .B(n_BLD07), .Y(n_G_7A) );
  AND4X1 G11 ( .A(n_RP1), .B(n_RP2), .C(n_RP3), .D(n_RP4), .Y(n_G_99) );
  NOR3X1 G0U ( .A(n_EEV17), .B(n_BLD20), .C(n_G_99), .Y(n_G_79) );
  NOR2X1 G03 ( .A(n_EEV08), .B(n_BLD09), .Y(n_G_8K) );
  AOI21X1 H7V ( .A0(n_EEV05), .A1(n_EEV12), .B0(n_BLD21), .Y(n_H_6P) );
  NR5 H72 ( .E(n_H_79), .D(n_H_71), .C(n_H_6T), .B(n_H_3D), .A(n_H_6W), .Y(
        n_H_7J) );
  AND4X1 H06 ( .A(n_EEV02), .B(n_EEV08), .C(n_EEV10), .D(n_EEV15), .Y(n_H_8K)
         );
  NOR2X1 H86 ( .A(n_H_8K), .B(n_BLD10), .Y(n_H_6D) );
  AOI21X1 H1A ( .A0(n_EEV06), .A1(n_EEV13), .B0(n_BLD21), .Y(n_H_79) );
  AOI21X1 H5U ( .A0(n_EEV16), .A1(n_EEV23), .B0(n_BLD01), .Y(n_H_7Y) );
  NR5 H70 ( .E(n_H_8F), .D(n_H_7S), .C(n_H_7Y), .B(n_H_77), .A(n_H_7P), .Y(
        n_H_06) );
  NR5 H73 ( .E(n_H_6P), .D(n_H_8R), .C(n_H_0X), .B(n_H_0S), .A(n_H_0C), .Y(
        n_H_3M) );
  NR5 H1W ( .E(n_H_8U), .D(n_H_87), .C(n_H_80), .B(n_H_64), .A(n_H_6J), .Y(
        n_H_7G) );
  AOI21X1 H8M ( .A0(n_EEV06), .A1(n_EEV13), .B0(n_BLD21), .Y(n_H_8U) );
  NR5 H1U ( .E(n_H_66), .D(n_H_8L), .C(n_H_6L), .B(n_H_07), .A(n_H_8G), .Y(
        n_H_8X) );
  AOI21X1 H02 ( .A0(n_EEV15), .A1(n_EEV22), .B0(n_BLD01), .Y(n_H_07) );
  AOI21X1 H08 ( .A0(n_EEV02), .A1(n_EEV04), .B0(n_BLD00), .Y(n_H_8G) );
  INVX1 H8N ( .A(RXESEN), .Y(n_H_67) );
  NOR3X1 H6S ( .A(n_EEV08), .B(n_H_67), .C(n_BLD04), .Y(n_H_6M) );
  AND3X1 H4T ( .A(n_H_8X), .B(n_H_76), .C(n_H_7G), .Y(n_H_01) );
  INVX2 H4V ( .A(n_H_01), .Y(EPOEN) );
  AD5 H4X ( .E(n_EEV23), .D(n_EEV16), .C(n_EEV12), .B(n_EEV07), .A(n_EEV04), 
        .Y(n_H_8H) );
  AOI21X1 H8P ( .A0(n_EEV07), .A1(n_EEV23), .B0(n_BLD15), .Y(n_H_69) );
  AOI32X1 H8B ( .A0(n_EEV02), .A1(n_EEV07), .A2(n_EEV21), .B0(n_BLD13), .B1(
        n_BLD17), .Y(n_H_6B) );
  AOI21X1 H8C ( .A0(n_BLD12), .A1(n_BLD16), .B0(n_EEV11), .Y(n_H_6C) );
  AOI21X1 H87 ( .A0(n_EEV09), .A1(n_EEV23), .B0(n_BLD11), .Y(n_H_6A) );
  AOI31X1 H7U ( .A0(n_EEV00), .A1(n_EEV01), .A2(n_EEV11), .B0(n_BLD08), .Y(
        n_H_6E) );
  AOI22X1 H7L ( .A0(n_EEV01), .A1(n_EEV13), .B0(n_BLD02), .B1(n_BLD20), .Y(
        n_H_6G) );
  AOI22X1 H5V ( .A0(n_EEV06), .A1(n_EEV14), .B0(n_BLD12), .B1(n_BLD16), .Y(
        n_H_71) );
  AOI31X1 H3R ( .A0(n_EEV02), .A1(n_EEV11), .A2(n_EEV23), .B0(n_BLD06), .Y(
        n_H_63) );
  AOI21X1 H1F ( .A0(n_BLD14), .A1(n_BLD18), .B0(n_EEV06), .Y(n_H_64) );
  AOI21X1 H1B ( .A0(n_BLD13), .A1(n_BLD17), .B0(n_EEV09), .Y(n_H_6J) );
  AOI21X1 H0K ( .A0(n_BLD12), .A1(n_BLD16), .B0(n_EEV08), .Y(n_H_6H) );
  AOI21X1 H0U ( .A0(n_EEV09), .A1(n_EEV22), .B0(n_BLD10), .Y(n_H_95) );
  AOI21X1 H13 ( .A0(n_EEV18), .A1(n_EEV20), .B0(n_BLD07), .Y(n_H_94) );
  AOI31X1 H11 ( .A0(n_EEV04), .A1(n_EEV06), .A2(n_EEV22), .B0(n_BLD06), .Y(
        n_H_66) );
  AOI21X1 H0R ( .A0(n_EEV02), .A1(n_EEV13), .B0(n_BLD03), .Y(n_H_6L) );
  AD7 H6G ( .G(n_EEV22), .F(n_EEV20), .E(n_EEV17), .D(n_EEV15), .C(n_EEV13), 
        .B(n_EEV10), .A(n_EEV06), .Y(n_H_6Y) );
  AD7 H3W ( .G(n_EEV17), .F(n_EEV14), .E(n_EEV10), .D(n_EEV08), .C(n_EEV07), 
        .B(n_EEV03), .A(n_EEV02), .Y(n_H_7N) );
  AD8 H3E ( .H(n_EEV20), .G(n_EEV17), .F(n_EEV14), .E(n_EEV10), .D(n_EEV08), 
        .C(n_EEV07), .B(n_EEV03), .A(n_EEV02), .Y(n_H_93) );
  AD9 H5F ( .I(n_EEV22), .H(n_EEV20), .G(n_EEV17), .F(n_EEV15), .E(n_EEV13), 
        .D(n_EEV10), .C(n_EEV08), .B(n_EEV06), .A(n_EEV03), .Y(n_H_6S) );
  NOR2X1 H96 ( .A(n_EEV19), .B(n_BLD09), .Y(n_H_8J) );
  NR5 H95 ( .E(n_H_69), .D(n_H_6B), .C(n_H_6C), .B(n_H_6A), .A(n_H_6D), .Y(
        n_H_61) );
  NR5 H94 ( .E(n_H_65), .D(n_H_6E), .C(n_H_90), .B(n_H_6M), .A(n_H_6G), .Y(
        n_H_62) );
  AD5 H24 ( .E(n_EEV23), .D(n_EEV20), .C(n_EEV17), .B(n_EEV10), .A(n_EEV06), 
        .Y(n_H_92) );
  NAND2X2 H8V ( .A(n_H_62), .B(n_H_61), .Y(ETOEN) );
  NOR2X1 H80 ( .A(n_EEV00), .B(n_BLD09), .Y(n_H_65) );
  NOR2X1 H7T ( .A(n_H_6K), .B(n_BLD06), .Y(n_H_90) );
  AND4X1 H7M ( .A(n_EEV00), .B(n_EEV01), .C(n_EEV08), .D(n_EEV10), .Y(n_H_6K)
         );
  ND5D2 H75 ( .E(n_H_3M), .D(n_H_7J), .C(n_EIMDIS), .B(n_H_06), .A(n_H_01), 
        .Y(EPSOEN) );
  NOR4X1 H71 ( .A(n_H_7M), .B(n_H_63), .C(n_H_7L), .D(n_H_7K), .Y(n_EIMDIS) );
  NOR2X1 H6U ( .A(n_H_70), .B(n_BLD19), .Y(n_H_8R) );
  AND4X1 H6T ( .A(n_EEV05), .B(n_EEV11), .C(n_EEV17), .D(n_EEV23), .Y(n_H_70)
         );
  NOR2X1 H6H ( .A(n_H_6Y), .B(n_BLD15), .Y(n_H_0X) );
  NOR2X1 H6F ( .A(n_H_73), .B(n_H_72), .Y(n_H_0S) );
  AND2X1 H6A ( .A(n_BLD14), .B(n_BLD18), .Y(n_H_72) );
  AND4X1 H69 ( .A(n_EEV07), .B(n_EEV15), .C(n_EEV19), .D(n_EEV23), .Y(n_H_73)
         );
  NOR2X1 H68 ( .A(n_H_75), .B(n_H_74), .Y(n_H_0C) );
  AND2X1 H61 ( .A(n_BLD13), .B(n_BLD17), .Y(n_H_74) );
  AD6 H60 ( .F(n_EEV22), .E(n_EEV18), .D(n_EEV17), .C(n_EEV13), .B(n_EEV10), 
        .A(n_EEV04), .Y(n_H_75) );
  NOR2X1 H5H ( .A(n_H_6S), .B(n_BLD11), .Y(n_H_6T) );
  NOR2X1 H4W ( .A(n_H_8H), .B(n_BLD10), .Y(n_H_3D) );
  NOR2X1 H4G ( .A(n_H_85), .B(n_H_86), .Y(n_H_84) );
  NOR2X1 H4F ( .A(n_H_84), .B(n_BLD09), .Y(n_H_6W) );
  NAND4X1 H4E ( .A(n_EEV13), .B(n_EEV16), .C(n_EEV17), .D(n_EEV23), .Y(n_H_86)
         );
  ND5 H4D ( .E(n_EEV10), .D(n_EEV08), .C(n_EEV07), .B(n_EEV05), .A(n_EEV02), 
        .Y(n_H_85) );
  NOR2X1 H45 ( .A(n_H_7W), .B(n_BLD08), .Y(n_H_7K) );
  AD8 H2Y ( .H(n_EEV21), .G(n_EEV20), .F(n_EEV18), .E(n_EEV16), .D(n_EEV14), 
        .C(n_EEV10), .B(n_EEV06), .A(n_EEV02), .Y(n_H_7W) );
  NOR2X1 H3X ( .A(n_H_7N), .B(n_BLD07), .Y(n_H_7L) );
  NOR2X1 H32 ( .A(n_H_8B), .B(n_H_8A), .Y(n_H_89) );
  NOR2X1 H3F ( .A(n_H_93), .B(n_BLD05), .Y(n_H_7M) );
  NOR2X1 H35 ( .A(n_H_81), .B(n_BLD04), .Y(n_H_8F) );
  AD8 H34 ( .H(n_EEV23), .G(n_EEV22), .F(n_EEV20), .E(n_EEV18), .D(n_EEV15), 
        .C(n_EEV12), .B(n_EEV10), .A(n_EEV06), .Y(n_H_81) );
  NOR2X1 H33 ( .A(n_H_89), .B(n_H_88), .Y(n_H_7S) );
  AND2X1 H2E ( .A(n_BLD02), .B(n_BLD20), .Y(n_H_88) );
  ND5 H2D ( .E(n_EEV23), .D(n_EEV20), .C(n_EEV18), .B(n_EEV17), .A(n_EEV15), 
        .Y(n_H_8A) );
  ND5 H2C ( .E(n_EEV11), .D(n_EEV08), .C(n_EEV06), .B(n_EEV05), .A(n_EEV03), 
        .Y(n_H_8B) );
  NOR2X1 H26 ( .A(n_H_92), .B(n_BLD03), .Y(n_H_77) );
  NOR2X1 H1Y ( .A(n_H_83), .B(n_BLD00), .Y(n_H_7P) );
  AND4X1 H1X ( .A(n_EEV07), .B(n_EEV10), .C(n_EEV13), .D(n_EEV15), .Y(n_H_83)
         );
  NOR4X1 H1V ( .A(n_H_94), .B(n_H_8J), .C(n_H_95), .D(n_H_6H), .Y(n_H_76) );
  NOR2X1 H1M ( .A(n_H_8P), .B(n_BLD19), .Y(n_H_87) );
  AD5 H1L ( .E(n_EEV21), .D(n_EEV20), .C(n_EEV14), .B(n_EEV08), .A(n_EEV02), 
        .Y(n_H_8P) );
  NOR2X1 H1J ( .A(n_EEV05), .B(n_BLD15), .Y(n_H_80) );
  NOR2X1 H0V ( .A(n_EEV05), .B(n_BLD04), .Y(n_H_8L) );
  NOR3X1 I1W ( .A(n_I_7V), .B(n_I_84), .C(n_I_91), .Y(n_I_7F) );
  NOR4X1 I53 ( .A(n_I_73), .B(n_I_72), .C(n_I_1D), .D(n_I_62), .Y(n_I_6L) );
  NOR4X1 I54 ( .A(n_I_3A), .B(n_I_69), .C(n_I_7J), .D(n_I_65), .Y(n_I_5J) );
  NOR2X1 I5U ( .A(n_EEV16), .B(n_BLD01), .Y(n_I_5Y) );
  AOI21X1 I56 ( .A0(n_EEV04), .A1(n_EEV11), .B0(n_BLD21), .Y(n_I_3A) );
  AOI21X1 I31 ( .A0(n_EEV14), .A1(n_EEV21), .B0(n_BLD01), .Y(n_I_5C) );
  NAND2X1 I2L ( .A(n_EIMDIS), .B(n_EMPMEN), .Y(n_I_7C) );
  NOR2X1 I24 ( .A(n_I_71), .B(n_BLD08), .Y(n_I_91) );
  AND4X1 I22 ( .A(n_EEV13), .B(n_EEV15), .C(n_EEV17), .D(n_EEV19), .Y(n_I_71)
         );
  NOR2X1 I8W ( .A(n_I_60), .B(n_I_5L), .Y(n_I_63) );
  NOR3X1 I8M ( .A(n_EEV13), .B(n_BLD20), .C(n_I_5M), .Y(n_I_5L) );
  AOI21X1 I6C ( .A0(n_EEV02), .A1(n_EEV10), .B0(n_BLD10), .Y(n_I_1C) );
  NOR2X1 I6E ( .A(n_I_7B), .B(n_BLD04), .Y(n_I_7V) );
  AND4X1 I6D ( .A(n_EEV13), .B(n_EEV17), .C(n_EEV19), .D(n_EEV21), .Y(n_I_7B)
         );
  AOI22X1 I70 ( .A0(n_EEV21), .A1(n_EEV23), .B0(n_BLD11), .B1(n_BLD15), .Y(
        n_I_6U) );
  AOI221X1 I7V ( .A0(n_EEV01), .A1(n_EEV13), .B0(n_RP2), .B1(n_RP3), .C0(
        n_BLD02), .Y(n_I_5V) );
  AOI21X1 I83 ( .A0(n_EEV01), .A1(n_EEV08), .B0(n_BLD06), .Y(n_I_1E) );
  AOI22X1 I6F ( .A0(n_EEV10), .A1(n_EEV14), .B0(n_BLD12), .B1(n_BLD16), .Y(
        n_I_64) );
  AOI221X1 I5W ( .A0(n_EEV01), .A1(n_EEV13), .B0(n_RP0), .B1(n_RP1), .C0(
        n_BLD02), .Y(n_I_66) );
  AOI21X1 I55 ( .A0(n_EEV04), .A1(n_EEV11), .B0(n_BLD15), .Y(n_I_65) );
  AOI22X1 I4M ( .A0(n_EEV05), .A1(n_EEV14), .B0(n_BLD13), .B1(n_BLD17), .Y(
        n_I_69) );
  AOI21X1 I4E ( .A0(n_BLD12), .A1(n_BLD16), .B0(n_EEV07), .Y(n_I_62) );
  AOI31X1 I4A ( .A0(n_EEV00), .A1(n_EEV13), .A2(n_EEV21), .B0(n_BLD10), .Y(
        n_I_72) );
  AOI21X1 I43 ( .A0(n_EEV03), .A1(n_EEV18), .B0(n_BLD09), .Y(n_I_73) );
  AOI21X1 I3T ( .A0(n_EEV16), .A1(n_EEV19), .B0(n_BLD07), .Y(n_I_7A) );
  AOI21X1 I3X ( .A0(n_EEV05), .A1(n_EEV21), .B0(n_BLD06), .Y(n_I_6F) );
  AOI21X1 I3C ( .A0(n_EEV04), .A1(n_EEV14), .B0(n_BLD04), .Y(n_I_7K) );
  AOI31X1 I3H ( .A0(n_EEV03), .A1(n_EEV12), .A2(n_EEV18), .B0(n_BLD03), .Y(
        n_I_37) );
  AOI22X1 I35 ( .A0(n_EEV09), .A1(n_EEV21), .B0(n_BLD02), .B1(n_BLD20), .Y(
        n_I_81) );
  AOI21X1 I1A ( .A0(n_BLD12), .A1(n_BLD16), .B0(n_EEV03), .Y(n_I_8T) );
  AOI22X1 I07 ( .A0(n_EEV11), .A1(n_EEV12), .B0(n_BLD05), .B1(n_BLD07), .Y(
        n_I_84) );
  NOR4X1 I7G ( .A(n_I_64), .B(n_I_1J), .C(n_I_4Y), .D(n_I_6G), .Y(n_I_51) );
  NOR4X1 I7E ( .A(n_I_6V), .B(n_I_6W), .C(n_I_1C), .D(n_I_6U), .Y(n_I_8Y) );
  AND4X1 I6L ( .A(n_EEV10), .B(n_EEV21), .C(n_EEV02), .D(n_EEV07), .Y(n_I_1H)
         );
  NOR3X1 I5T ( .A(n_EEV17), .B(n_RP0), .C(n_BLD05), .Y(n_I_6E) );
  AND2X1 I4H ( .A(n_BLD11), .B(n_BLD15), .Y(n_I_8X) );
  NAND3X2 I8X ( .A(n_I_5G), .B(n_I_5H), .C(n_I_63), .Y(ET1EN) );
  NOR4X1 I2U ( .A(n_I_5U), .B(n_I_5T), .C(n_I_5S), .D(n_I_5R), .Y(n_I_5H) );
  NOR4X1 I2N ( .A(n_I_5W), .B(n_I_5V), .C(n_I_5X), .D(n_I_1E), .Y(n_I_5G) );
  AND4X1 I8N ( .A(n_RP0), .B(n_RP1), .C(n_RP2), .D(n_RP3), .Y(n_I_5M) );
  NOR2X1 I8J ( .A(n_EEV08), .B(n_BLD10), .Y(n_I_5R) );
  NOR2X1 I8G ( .A(n_EEV08), .B(n_BLD19), .Y(n_I_60) );
  NOR2X1 I2V ( .A(n_EEV23), .B(n_BLD09), .Y(n_I_5S) );
  NOR2X1 I2S ( .A(n_EEV01), .B(n_BLD08), .Y(n_I_5T) );
  NOR3X1 I8B ( .A(n_EEV20), .B(n_RP1), .C(n_BLD07), .Y(n_I_5U) );
  NOR3X1 I89 ( .A(n_EEV17), .B(n_RP1), .C(n_BLD05), .Y(n_I_5X) );
  NOR2X1 I7K ( .A(n_EEV23), .B(n_BLD01), .Y(n_I_5W) );
  NAND3X2 I7H ( .A(n_I_5P), .B(n_I_8Y), .C(n_I_51), .Y(ET0EN) );
  NR5 I7F ( .E(n_I_6A), .D(n_I_6B), .C(n_I_6E), .B(n_I_66), .A(n_I_5Y), .Y(
        n_I_5P) );
  NOR3X1 I7D ( .A(n_EEV01), .B(n_I_6Y), .C(n_BLD20), .Y(n_I_6G) );
  AND4X1 I7C ( .A(n_RP0), .B(n_RP1), .C(n_RP2), .D(n_RP3), .Y(n_I_6Y) );
  NOR2X1 I75 ( .A(n_EEV02), .B(n_BLD19), .Y(n_I_4Y) );
  AND2X1 I6N ( .A(n_BLD13), .B(n_BLD17), .Y(n_I_50) );
  NOR2X1 I6M ( .A(n_I_1H), .B(n_I_50), .Y(n_I_1J) );
  NOR2X1 I65 ( .A(n_EEV19), .B(n_BLD09), .Y(n_I_6W) );
  NOR2X1 I64 ( .A(n_EEV00), .B(n_BLD08), .Y(n_I_6V) );
  NOR3X1 I33 ( .A(n_EEV20), .B(n_RP0), .C(n_BLD07), .Y(n_I_6A) );
  NOR2X1 I5P ( .A(n_EEV00), .B(n_BLD06), .Y(n_I_6B) );
  NAND4X2 I5A ( .A(n_I_6J), .B(n_I_6K), .C(n_I_6L), .D(n_I_5J), .Y(EXHEN) );
  NOR4X1 I52 ( .A(n_I_29), .B(n_I_6F), .C(n_I_7A), .D(n_I_7Y), .Y(n_I_6K) );
  NOR4X1 I51 ( .A(n_I_5C), .B(n_I_81), .C(n_I_37), .D(n_I_7K), .Y(n_I_6J) );
  AND2X1 I50 ( .A(n_BLD14), .B(n_BLD18), .Y(n_I_7L) );
  NOR3X1 I4W ( .A(n_I_7N), .B(n_I_7M), .C(n_I_7L), .Y(n_I_7J) );
  AND2X1 I4V ( .A(n_RP1), .B(n_RP3), .Y(n_I_7M) );
  AND4X1 I4U ( .A(n_EEV00), .B(n_EEV04), .C(n_EEV12), .D(n_EEV16), .Y(n_I_7N)
         );
  NOR2X1 I4B ( .A(n_EEV11), .B(n_BLD11), .Y(n_I_1D) );
  NOR2X1 I41 ( .A(n_EEV07), .B(n_BLD08), .Y(n_I_7Y) );
  NOR2X1 I3N ( .A(n_EEV16), .B(n_BLD05), .Y(n_I_29) );
  NAND4X2 I20 ( .A(n_I_7C), .B(n_I_7F), .C(n_I_7H), .D(n_I_82), .Y(EIMOEN) );
  NOR3X1 I1Y ( .A(n_I_8T), .B(n_I_8N), .C(n_I_7U), .Y(n_I_82) );
  NOR3X1 I1X ( .A(n_I_8V), .B(n_I_8S), .C(n_I_8R), .Y(n_I_7H) );
  NOR2X1 I1V ( .A(n_I_8C), .B(n_I_8B), .Y(n_I_7U) );
  AND2X1 I1M ( .A(n_BLD14), .B(n_BLD18), .Y(n_I_8B) );
  AND4X1 I1L ( .A(n_EEV01), .B(n_EEV05), .C(n_EEV13), .D(n_EEV17), .Y(n_I_8C)
         );
  AND2X1 I1K ( .A(n_BLD13), .B(n_BLD17), .Y(n_I_8D) );
  NOR2X1 I1E ( .A(n_I_8E), .B(n_I_8D), .Y(n_I_8N) );
  AND4X1 I1D ( .A(n_EEV00), .B(n_EEV11), .C(n_EEV12), .D(n_EEV16), .Y(n_I_8E)
         );
  NOR2X1 I14 ( .A(n_I_8G), .B(n_I_8X), .Y(n_I_8R) );
  AD5 I13 ( .E(n_EEV21), .D(n_EEV19), .C(n_EEV16), .B(n_EEV14), .A(n_EEV12), 
        .Y(n_I_8G) );
  NOR2X1 I11 ( .A(n_EEV01), .B(n_BLD10), .Y(n_I_8S) );
  AD6 I0S ( .F(n_EEV21), .E(n_EEV15), .D(n_EEV12), .C(n_EEV09), .B(n_EEV06), 
        .A(n_EEV04), .Y(n_I_8H) );
  NOR2X1 I0T ( .A(n_I_8H), .B(n_BLD09), .Y(n_I_8V) );
  NOR4X1 J53 ( .A(n_J_2K), .B(n_J_6C), .C(n_J_6D), .D(n_J_5L), .Y(n_J_7B) );
  NOR3X1 J96 ( .A(n_J_6K), .B(n_J_7C), .C(n_J_5R), .Y(n_J_6U) );
  NOR4X1 J9A ( .A(n_J_7K), .B(n_J_79), .C(n_J_77), .D(n_J_6F), .Y(n_J_7F) );
  AOI21X1 J4B ( .A0(n_EEV21), .A1(n_EEV22), .B0(n_BLD03), .Y(n_J_6F) );
  AND4X1 J3M ( .A(n_EEV00), .B(n_EEV11), .C(n_EEV21), .D(n_EEV22), .Y(n_J_6T)
         );
  AOI21X1 J6D ( .A0(n_EEV06), .A1(n_EEV09), .B0(n_BLD00), .Y(n_J_3F) );
  OR5D2 J9B ( .E(n_J_8T), .D(n_J_5S), .C(n_J_8V), .B(n_J_8U), .A(n_J_3F), .Y(
        ESSDEN) );
  AOI21X2 J46 ( .A0(n_EEV13), .A1(n_EEV20), .B0(n_BLD01), .Y(MCHS) );
  OR2X2 J94 ( .A(n_J_6V), .B(n_J_7T), .Y(SIEXS) );
  OR3X2 J1K ( .A(n_J_88), .B(n_J_2V), .C(n_J_6V), .Y(EXTIEN) );
  OR3X2 J45 ( .A(n_J_2H), .B(n_J_8B), .C(n_J_87), .Y(EXLRS) );
  AOI21X1 J8W ( .A0(n_EEV17), .A1(n_EEV20), .B0(n_BLD01), .Y(n_J_8B) );
  AOI21X1 J5G ( .A0(n_EEV01), .A1(n_EEV03), .B0(n_BLD00), .Y(n_J_7T) );
  AOI21X1 J4N ( .A0(n_EEV01), .A1(n_EEV03), .B0(n_BLD00), .Y(n_J_88) );
  NOR2X1 J63 ( .A(n_J_3B), .B(n_BLD01), .Y(n_J_2V) );
  AND4X1 J60 ( .A(n_EEV10), .B(n_EEV13), .C(n_EEV17), .D(n_EEV20), .Y(n_J_3B)
         );
  AOI21X1 J84 ( .A0(n_EEV00), .A1(n_EEV07), .B0(n_BLD21), .Y(n_J_6V) );
  AOI21X1 J88 ( .A0(n_EEV13), .A1(n_EEV15), .B0(n_BLD00), .Y(n_J_79) );
  OR4X2 J6P ( .A(n_J_7P), .B(n_J_6X), .C(n_J_60), .D(n_J_75), .Y(ET4EN) );
  NOR2X1 J6V ( .A(n_EEV07), .B(n_BLD21), .Y(n_J_87) );
  NOR2X1 J6G ( .A(n_EEV07), .B(n_BLD15), .Y(n_J_75) );
  NOR2X1 J68 ( .A(n_EEV02), .B(n_BLD08), .Y(n_J_60) );
  NOR2X1 J9C ( .A(n_EEV10), .B(n_BLD06), .Y(n_J_6X) );
  NOR2X1 J8Y ( .A(n_EEV23), .B(n_BLD04), .Y(n_J_7P) );
  OR3X1 J8F ( .A(n_J_42), .B(n_J_76), .C(n_J_7N), .Y(n_J_7J) );
  AD6 J8J ( .F(n_EEV14), .E(n_EEV11), .D(n_EEV08), .C(n_EEV05), .B(n_EEV04), 
        .A(n_EEV02), .Y(n_J_8X) );
  NOR2X1 J8B ( .A(n_EEV21), .B(n_BLD14), .Y(n_J_6C) );
  NOR2X1 J5L ( .A(n_J_3Y), .B(n_BLD01), .Y(n_J_42) );
  AND2X1 J6S ( .A(n_EEV16), .B(n_EEV23), .Y(n_J_3Y) );
  NOR2X2 J69 ( .A(n_EEV03), .B(n_BLD00), .Y(n_J_2H) );
  OR3X1 J8G ( .A(n_J_7L), .B(n_J_5Y), .C(n_J_7D), .Y(n_J_61) );
  NOR2X1 J2A ( .A(n_J_7J), .B(n_J_61), .Y(n_J_5X) );
  NOR3X1 J7S ( .A(n_J_54), .B(n_J_5D), .C(n_J_90), .Y(n_J_5T) );
  NAND2X2 J5V ( .A(n_J_5X), .B(n_J_5T), .Y(ERS2) );
  NAND2X2 J5U ( .A(n_J_7F), .B(n_J_5T), .Y(ERS1) );
  NOR2X2 J34 ( .A(n_J_81), .B(n_J_80), .Y(EQACS0) );
  NOR2X2 J3C ( .A(n_J_82), .B(n_J_81), .Y(EQOEN) );
  AOI22X1 J7Y ( .A0(n_EEV00), .A1(n_EEV03), .B0(n_BLD04), .B1(n_BLD15), .Y(
        n_J_7L) );
  AOI21X1 J71 ( .A0(n_EEV12), .A1(n_EEV18), .B0(n_BLD19), .Y(n_J_77) );
  AOI21X1 J8X ( .A0(n_EEV01), .A1(n_EEV04), .B0(n_BLD11), .Y(n_J_90) );
  AOI21X1 J8T ( .A0(n_EEV21), .A1(n_EEV22), .B0(n_BLD03), .Y(n_J_5D) );
  AOI21X1 J8C ( .A0(n_EEV17), .A1(n_EEV20), .B0(n_BLD10), .Y(n_J_7D) );
  AOI21X1 J8A ( .A0(n_EEV17), .A1(n_EEV20), .B0(n_BLD06), .Y(n_J_5Y) );
  AOI21X1 J7U ( .A0(n_EEV00), .A1(n_EEV11), .B0(n_BLD03), .Y(n_J_7N) );
  AOI21X1 J4S ( .A0(n_EEV00), .A1(n_EEV03), .B0(n_BLD15), .Y(n_J_6D) );
  OAI22X2 J22 ( .A0(n_EEV23), .A1(n_BLD06), .B0(n_EEV11), .B1(n_BLD08), .Y(
        ET5EN) );
  AOI21X1 J4A ( .A0(n_EEV17), .A1(n_EEV20), .B0(n_BLD06), .Y(n_J_7C) );
  AOI21X1 J40 ( .A0(n_EEV00), .A1(n_EEV03), .B0(n_BLD04), .Y(n_J_5M) );
  AOI21X1 J3J ( .A0(n_EEV10), .A1(n_EEV22), .B0(n_BLD02), .Y(n_J_6G) );
  AOI21X1 J15 ( .A0(n_EEV15), .A1(n_EEV16), .B0(n_BLD10), .Y(n_J_1R) );
  NAND2X1 J9L ( .A(n_J_8J), .B(RXESEN), .Y(n_J_0K) );
  NAND2X1 J4D ( .A(n_EEV01), .B(n_EEV04), .Y(n_J_8J) );
  NOR2X2 J6J ( .A(n_EEV16), .B(n_BLD07), .Y(n_J_8T) );
  NOR2X2 J6E ( .A(n_EEV01), .B(n_BLD09), .Y(n_J_5S) );
  NOR2X2 J6K ( .A(n_EEV11), .B(n_BLD04), .Y(n_J_8V) );
  NOR2X2 J5J ( .A(n_EEV07), .B(n_BLD11), .Y(n_J_8U) );
  AND4X1 J4F ( .A(n_EEV06), .B(n_EEV11), .C(n_EEV17), .D(n_EEV20), .Y(n_J_3G)
         );
  INVX1 J5P ( .A(SURDEN), .Y(n_J_67) );
  AND2X1 J5S ( .A(n_RP2), .B(n_RP3), .Y(n_J_65) );
  NOR4X1 J99 ( .A(n_J_2E), .B(n_J_67), .C(n_J_65), .D(n_BLD14), .Y(n_J_7K) );
  NR5 J95 ( .E(n_J_5M), .D(n_J_5N), .C(n_J_6G), .B(n_J_6R), .A(n_J_6P), .Y(
        n_J_64) );
  INVX1 J51 ( .A(PCEBEN), .Y(n_J_71) );
  NOR2X1 J4L ( .A(n_J_0K), .B(n_BLD11), .Y(n_J_2K) );
  NOR2X1 J4K ( .A(n_J_3G), .B(n_BLD10), .Y(n_J_5R) );
  NOR2X1 J43 ( .A(n_EEV18), .B(n_BLD05), .Y(n_J_6K) );
  NOR2X1 J3X ( .A(n_J_6T), .B(n_BLD03), .Y(n_J_5N) );
  NOR3X1 J93 ( .A(n_J_70), .B(n_J_71), .C(n_BLD00), .Y(n_J_6R) );
  NOR3X1 J92 ( .A(n_J_6Y), .B(PCEBEN), .C(n_BLD00), .Y(n_J_6P) );
  AND2X1 J3G ( .A(n_EEV11), .B(n_EEV14), .Y(n_J_70) );
  AND2X1 J3F ( .A(n_EEV05), .B(n_EEV08), .Y(n_J_6Y) );
  NOR2X1 J8K ( .A(n_J_8X), .B(n_BLD00), .Y(n_J_54) );
  NOR2X1 J7T ( .A(n_J_78), .B(n_BLD02), .Y(n_J_76) );
  AND4X1 J7B ( .A(n_EEV10), .B(n_EEV11), .C(n_EEV22), .D(n_EEV23), .Y(n_J_78)
         );
  AND2X1 J6U ( .A(n_EEV21), .B(n_EEV23), .Y(n_J_2E) );
  NAND3X2 J54 ( .A(n_J_64), .B(n_J_6U), .C(n_J_7B), .Y(EROEN) );
  NOR2X1 J4V ( .A(n_J_7R), .B(n_BLD19), .Y(n_J_5L) );
  AND4X1 J4U ( .A(n_EEV00), .B(n_EEV06), .C(n_EEV12), .D(n_EEV18), .Y(n_J_7R)
         );
  AD6 J37 ( .F(n_EEV20), .E(n_EEV19), .D(n_EEV16), .C(n_EEV08), .B(n_EEV07), 
        .A(n_EEV04), .Y(n_J_80) );
  AND2X1 J33 ( .A(n_BLD02), .B(n_BLD20), .Y(n_J_81) );
  AD6 J2W ( .F(n_EEV19), .E(n_EEV16), .D(n_EEV14), .C(n_EEV07), .B(n_EEV04), 
        .A(n_EEV02), .Y(n_J_82) );
  NOR4X1 J12 ( .A(n_J_83), .B(n_J_86), .C(n_J_85), .D(n_J_1R), .Y(n_J_7X) );
  OR4X2 J1J ( .A(n_J_8D), .B(n_J_8G), .C(n_J_8F), .D(n_J_8E), .Y(ET3EN) );
  NOR3X1 J1D ( .A(n_EEV13), .B(n_BLD20), .C(n_J_8H), .Y(n_J_8E) );
  AND4X1 J1C ( .A(n_RP4), .B(n_RP5), .C(n_RP6), .D(n_RP7), .Y(n_J_8H) );
  NOR2X1 J1B ( .A(n_EEV20), .B(n_BLD19), .Y(n_J_8F) );
  NOR2X1 J1A ( .A(n_EEV00), .B(n_BLD09), .Y(n_J_8G) );
  NOR2X1 J19 ( .A(n_EEV14), .B(n_BLD19), .Y(n_J_8K) );
  NAND2X2 J14 ( .A(n_J_7X), .B(n_J_7W), .Y(ET2EN) );
  NOR3X1 J13 ( .A(n_J_8L), .B(n_J_8K), .C(n_J_89), .Y(n_J_7W) );
  NOR2X1 J0W ( .A(n_EEV06), .B(n_BLD06), .Y(n_J_8D) );
  NOR3X1 J0R ( .A(n_EEV01), .B(n_BLD20), .C(n_J_8M), .Y(n_J_89) );
  AND4X1 J0F ( .A(n_RP4), .B(n_RP5), .C(n_RP6), .D(n_RP7), .Y(n_J_8M) );
  NOR2X1 J0M ( .A(n_EEV09), .B(n_BLD11), .Y(n_J_8L) );
  NOR2X1 J0H ( .A(n_EEV04), .B(n_BLD06), .Y(n_J_85) );
  NOR2X1 J0G ( .A(n_EEV08), .B(n_BLD04), .Y(n_J_86) );
  NOR2X1 J0E ( .A(n_EEV23), .B(n_BLD03), .Y(n_J_83) );
  AND4X1 K35 ( .A(n_EEV04), .B(n_EEV10), .C(n_EEV16), .D(n_EEV22), .Y(n_K_8W)
         );
  NOR2X1 K9G ( .A(n_K_8W), .B(n_BLD19), .Y(n_K_7Y) );
  NOR2X1 K9L ( .A(n_K_8D), .B(n_BLD19), .Y(n_K_9V) );
  AOI21X1 K9U ( .A0(n_EEV08), .A1(n_EEV10), .B0(n_BLD08), .Y(n_K_5M) );
  AND4X1 K9F ( .A(n_EEV10), .B(n_EEV11), .C(n_EEV22), .D(n_EEV23), .Y(n_K_8D)
         );
  AND4X1 K1B ( .A(n_EEV16), .B(n_EEV17), .C(n_EEV22), .D(n_EEV23), .Y(n_K_0V)
         );
  AND2X1 K3T ( .A(n_EEV21), .B(n_EEV23), .Y(n_K_0X) );
  NOR4X1 K0R ( .A(n_K_0X), .B(n_K_0D), .C(n_BLD18), .D(n_K_86), .Y(n_K_96) );
  NOR3X1 K3K ( .A(n_K_94), .B(n_K_66), .C(n_BLD20), .Y(n_K_54) );
  AND4X1 K9N ( .A(n_RP4), .B(n_RP5), .C(n_RP6), .D(n_RP7), .Y(n_K_66) );
  NOR2X1 K1C ( .A(n_K_0V), .B(n_BLD19), .Y(n_K_98) );
  NOR3X1 K28 ( .A(n_K_6W), .B(n_K_8N), .C(n_K_27), .Y(n_K_9T) );
  OR3X2 K30 ( .A(n_K_96), .B(n_K_98), .C(n_K_54), .Y(EOS1) );
  AOI21X1 K90 ( .A0(n_EEV04), .A1(n_EEV08), .B0(n_BLD08), .Y(n_K_9M) );
  AND4X1 K33 ( .A(n_EEV10), .B(n_EEV11), .C(n_EEV22), .D(n_EEV23), .Y(n_K_94)
         );
  OR6D2 K9Y ( .F(n_K_8Y), .E(n_K_5G), .D(n_K_7H), .C(n_K_9V), .B(n_K_5M), .A(
        n_K_8V), .Y(EOS0) );
  NOR2X1 K2Y ( .A(n_K_9A), .B(n_BLD03), .Y(n_K_8V) );
  AND4X1 K3A ( .A(n_EEV08), .B(n_EEV10), .C(n_EEV19), .D(n_EEV20), .Y(n_K_9A)
         );
  AOI221X1 K3E ( .A0(n_EEV21), .A1(n_EEV23), .B0(n_RP1), .B1(n_RP3), .C0(
        n_BLD18), .Y(n_K_5G) );
  AOI21X1 K3B ( .A0(n_EEV22), .A1(n_EEV23), .B0(n_BLD20), .Y(n_K_7H) );
  AOI21X1 K91 ( .A0(n_EEV15), .A1(n_EEV19), .B0(n_BLD03), .Y(n_K_9L) );
  OR6D2 K96 ( .F(n_K_9G), .E(n_K_9H), .D(n_K_7Y), .C(n_K_9K), .B(n_K_9M), .A(
        n_K_9L), .Y(EOOEN) );
  AND2X1 K0U ( .A(n_RP2), .B(n_RP3), .Y(n_K_86) );
  INVX1 K0T ( .A(SURDEN), .Y(n_K_0D) );
  NOR2X1 K1N ( .A(n_EEV21), .B(n_BLD18), .Y(n_K_9K) );
  AOI221X1 K1R ( .A0(n_EEV21), .A1(n_EEV23), .B0(n_RP1), .B1(n_RP3), .C0(
        n_BLD14), .Y(n_K_62) );
  NOR4X1 K8K ( .A(n_K_5U), .B(n_K_5F), .C(n_K_5H), .D(n_K_0E), .Y(n_K_5L) );
  NOR2X1 K49 ( .A(n_K_2M), .B(n_BLD03), .Y(n_K_5Y) );
  AND4X1 K4R ( .A(n_EEV05), .B(n_EEV09), .C(n_EEV16), .D(n_EEV19), .Y(n_K_2M)
         );
  NR5 K70 ( .E(n_K_75), .D(n_K_76), .C(n_K_5Y), .B(n_K_8J), .A(n_K_7A), .Y(
        n_K_8C) );
  AOI21X1 K0S ( .A0(n_EEV11), .A1(n_EEV22), .B0(n_BLD03), .Y(n_K_9E) );
  AOI21X1 K98 ( .A0(n_EEV10), .A1(n_EEV13), .B0(n_BLD21), .Y(n_K_8Y) );
  AOI21X1 K2M ( .A0(n_EEV10), .A1(n_EEV22), .B0(n_BLD20), .Y(n_K_9H) );
  AOI21X1 K0J ( .A0(n_EEV03), .A1(n_EEV10), .B0(n_BLD21), .Y(n_K_9G) );
  NOR4X1 K5K ( .A(n_K_5A), .B(n_K_59), .C(n_K_57), .D(n_K_56), .Y(n_K_58) );
  AOI21X1 K20 ( .A0(n_EEV02), .A1(n_EEV09), .B0(n_BLD21), .Y(n_K_57) );
  AOI21X1 K4F ( .A0(n_EEV12), .A1(n_EEV19), .B0(n_BLD01), .Y(n_K_7A) );
  NOR3X1 K7W ( .A(n_K_6H), .B(n_K_6E), .C(n_BLD02), .Y(n_K_9D) );
  NR5 K26 ( .E(n_K_8L), .D(n_K_9E), .C(n_K_9D), .B(n_K_9C), .A(n_K_9B), .Y(
        n_K_9U) );
  NOR2X1 K02 ( .A(n_EEV23), .B(n_BLD01), .Y(n_K_9C) );
  AD5 K0G ( .E(n_EEV15), .D(n_EEV14), .C(n_EEV10), .B(n_EEV08), .A(n_EEV04), 
        .Y(n_K_8T) );
  AOI21X1 K8G ( .A0(n_EEV12), .A1(n_EEV16), .B0(n_BLD15), .Y(n_K_0E) );
  AOI21X1 K8C ( .A0(n_BLD13), .A1(n_BLD17), .B0(n_EEV12), .Y(n_K_5H) );
  AOI21X1 K81 ( .A0(n_EEV13), .A1(n_EEV17), .B0(n_BLD08), .Y(n_K_8A) );
  NAND4X2 K74 ( .A(n_K_8C), .B(n_K_85), .C(n_K_9W), .D(n_K_58), .Y(EPAEN) );
  AOI31X1 K8B ( .A0(n_EEV03), .A1(n_EEV09), .A2(n_EEV15), .B0(n_BLD19), .Y(
        n_K_56) );
  NOR4X1 K71 ( .A(n_K_73), .B(n_K_6U), .C(n_K_7K), .D(n_K_89), .Y(n_K_9W) );
  NOR4X1 K72 ( .A(n_K_5W), .B(n_K_77), .C(n_K_78), .D(n_K_6B), .Y(n_K_85) );
  AND4X1 K0H ( .A(n_EEV10), .B(n_EEV11), .C(n_EEV22), .D(n_EEV23), .Y(n_K_6H)
         );
  AND2X1 K88 ( .A(n_RP2), .B(n_RP3), .Y(n_K_6E) );
  NOR4X1 K8J ( .A(n_K_07), .B(n_K_7F), .C(n_K_2A), .D(n_K_8A), .Y(n_K_50) );
  AD5 K8W ( .E(n_EEV19), .D(n_EEV18), .C(n_EEV14), .B(n_EEV05), .A(n_EEV02), 
        .Y(n_K_5X) );
  NOR2X1 K8T ( .A(n_K_7D), .B(n_BLD10), .Y(n_K_73) );
  AND4X1 K93 ( .A(n_EEV02), .B(n_EEV05), .C(n_EEV14), .D(n_EEV19), .Y(n_K_7D)
         );
  AOI21X1 K87 ( .A0(n_EEV12), .A1(n_EEV16), .B0(n_BLD11), .Y(n_K_5F) );
  AOI21X1 K86 ( .A0(n_EEV04), .A1(n_EEV09), .B0(n_BLD09), .Y(n_K_5U) );
  AOI22X1 K80 ( .A0(n_EEV12), .A1(n_EEV15), .B0(n_BLD05), .B1(n_BLD07), .Y(
        n_K_2A) );
  AOI21X1 K7S ( .A0(n_EEV13), .A1(n_EEV19), .B0(n_BLD04), .Y(n_K_7F) );
  AOI22X1 K62 ( .A0(n_EEV05), .A1(n_EEV13), .B0(n_BLD12), .B1(n_BLD16), .Y(
        n_K_7K) );
  AOI21X1 K58 ( .A0(n_EEV06), .A1(n_EEV15), .B0(n_BLD07), .Y(n_K_77) );
  AOI21X1 K54 ( .A0(n_EEV09), .A1(n_EEV19), .B0(n_BLD06), .Y(n_K_5W) );
  AOI31X1 K4Y ( .A0(n_EEV06), .A1(n_EEV15), .A2(n_EEV19), .B0(n_BLD05), .Y(
        n_K_75) );
  AOI31X1 K1D ( .A0(n_EEV06), .A1(n_EEV07), .A2(n_EEV20), .B0(n_BLD10), .Y(
        n_K_27) );
  AOI21X1 K25 ( .A0(n_EEV06), .A1(n_EEV18), .B0(n_BLD19), .Y(n_K_61) );
  AOI211X1 K15 ( .A0(n_EEV18), .A1(n_EEV20), .B0(n_RP1), .C0(n_BLD05), .Y(
        n_K_6W) );
  NAND2X2 K8L ( .A(n_K_50), .B(n_K_5L), .Y(EAIVEN) );
  AND2X1 K7D ( .A(n_BLD02), .B(n_BLD20), .Y(n_K_64) );
  NOR2X1 K7C ( .A(n_K_63), .B(n_K_64), .Y(n_K_07) );
  AD6 K75 ( .F(n_EEV17), .E(n_EEV16), .D(n_EEV13), .C(n_EEV05), .B(n_EEV04), 
        .A(n_EEV01), .Y(n_K_63) );
  NOR2X1 K6T ( .A(n_K_79), .B(n_BLD15), .Y(n_K_59) );
  AND4X1 K6S ( .A(n_EEV02), .B(n_EEV09), .C(n_EEV14), .D(n_EEV18), .Y(n_K_79)
         );
  NOR2X1 K6R ( .A(n_K_6P), .B(n_K_6R), .Y(n_K_5A) );
  AND2X1 K6H ( .A(n_BLD14), .B(n_BLD18), .Y(n_K_6R) );
  AND4X1 K6G ( .A(n_EEV02), .B(n_EEV14), .C(n_EEV18), .D(n_EEV22), .Y(n_K_6P)
         );
  NOR2X1 K6F ( .A(n_K_6M), .B(n_K_6N), .Y(n_K_89) );
  AND2X1 K6E ( .A(n_BLD13), .B(n_BLD17), .Y(n_K_6N) );
  AND4X1 K67 ( .A(n_EEV03), .B(n_EEV06), .C(n_EEV15), .D(n_EEV20), .Y(n_K_6M)
         );
  NOR2X1 K5T ( .A(n_K_5X), .B(n_BLD11), .Y(n_K_6U) );
  NOR2X1 K5H ( .A(n_K_6F), .B(n_BLD08), .Y(n_K_78) );
  AND4X1 K5F ( .A(n_EEV05), .B(n_EEV09), .C(n_EEV15), .D(n_EEV19), .Y(n_K_6F)
         );
  AND4X1 K4U ( .A(n_EEV02), .B(n_EEV09), .C(n_EEV16), .D(n_EEV21), .Y(n_K_84)
         );
  NOR2X1 K4N ( .A(n_K_6G), .B(n_BLD09), .Y(n_K_6B) );
  AND4X1 K4H ( .A(n_EEV06), .B(n_EEV12), .C(n_EEV16), .D(n_EEV22), .Y(n_K_6G)
         );
  NOR2X1 K4B ( .A(n_K_84), .B(n_BLD04), .Y(n_K_76) );
  AND2X1 K44 ( .A(n_BLD02), .B(n_BLD20), .Y(n_K_74) );
  NOR2X1 K2P ( .A(n_K_8U), .B(n_K_74), .Y(n_K_8J) );
  AD8 K2F ( .H(n_EEV22), .G(n_EEV19), .F(n_EEV17), .E(n_EEV16), .D(n_EEV10), 
        .C(n_EEV07), .B(n_EEV05), .A(n_EEV04), .Y(n_K_8U) );
  NAND3X2 K2A ( .A(n_K_9U), .B(n_K_9T), .C(n_K_9S), .Y(ERLRS) );
  NOR4X1 K29 ( .A(n_K_8F), .B(n_K_62), .C(n_K_9F), .D(n_K_61), .Y(n_K_9S) );
  NOR2X1 K1X ( .A(n_EEV03), .B(n_BLD15), .Y(n_K_9F) );
  NOR2X1 K1J ( .A(n_EEV04), .B(n_BLD11), .Y(n_K_8F) );
  NOR2X1 K17 ( .A(n_EEV20), .B(n_BLD06), .Y(n_K_8N) );
  NOR2X1 K10 ( .A(n_EEV03), .B(n_BLD04), .Y(n_K_8L) );
  NOR2X1 K03 ( .A(n_K_8T), .B(n_BLD00), .Y(n_K_9B) );
  NOR2X2 L3B ( .A(n_EEV01), .B(n_L_2W), .Y(LFACLS) );
  NOR2X2 L3A ( .A(n_EEV00), .B(n_L_2W), .Y(EMSFEN) );
  AND2X2 L39 ( .A(n_BLD05), .B(n_BLD07), .Y(n_L_2W) );
  INVX1 L38 ( .A(n_EEV01), .Y(n_L_2G) );
  AND2X1 L33 ( .A(n_L_2K), .B(n_L_2G), .Y(n_L_2F) );
  NAND2X1 L36 ( .A(n_BLD22), .B(n_BLD23), .Y(n_L_2K) );
  AOI21X2 L31 ( .A0(n_BLD05), .A1(n_BLD07), .B0(n_EEV13), .Y(DTEN) );
  AOI22X2 L2U ( .A0(n_EEV00), .A1(n_EEV12), .B0(n_BLD02), .B1(n_BLD20), .Y(
        EXEXEN) );
  NOR3X1 L1U ( .A(n_EEV15), .B(n_L_27), .C(n_L_2K), .Y(n_L_2J) );
  NAND2X2 L2P ( .A(n_L_21), .B(n_L_1W), .Y(EPBSU) );
  NOR2X1 L2N ( .A(n_L_23), .B(n_L_20), .Y(n_L_1W) );
  NOR3X1 L0W ( .A(n_L_1S), .B(n_L_25), .C(n_L_24), .Y(n_L_21) );
  NAND4X1 L2E ( .A(n_BLD08), .B(n_BLD09), .C(n_BLD11), .D(n_BLD15), .Y(n_L_27)
         );
  INVX2 L2D ( .A(n_L_2B), .Y(ESLMTEN) );
  AOI21X1 L1F ( .A0(n_EEV02), .A1(n_EEV03), .B0(n_L_14), .Y(n_L_2B) );
  AOI31X1 L0V ( .A0(n_EEV05), .A1(n_EEV09), .A2(n_EEV14), .B0(n_BLD10), .Y(
        n_L_20) );
  NOR2X1 L28 ( .A(n_L_28), .B(n_BLD01), .Y(n_L_25) );
  AND4X1 L02 ( .A(n_EEV12), .B(n_EEV15), .C(n_EEV19), .D(n_EEV22), .Y(n_L_28)
         );
  AOI22X1 L0A ( .A0(n_EEV10), .A1(n_EEV22), .B0(n_BLD02), .B1(n_BLD20), .Y(
        n_L_1S) );
  NOR2X2 L0K ( .A(n_EEV05), .B(n_L_14), .Y(PBSD4) );
  OR3X2 L23 ( .A(n_L_17), .B(n_L_2J), .C(n_L_2F), .Y(EPWEN) );
  INVX1 L22 ( .A(n_L_27), .Y(n_L_1A) );
  NOR2X1 L21 ( .A(n_EEV10), .B(n_L_1A), .Y(n_L_17) );
  NOR2X2 L1S ( .A(n_EEV16), .B(n_BLD07), .Y(EROMAS) );
  NOR2X2 L1K ( .A(n_EEV09), .B(n_L_14), .Y(INC16) );
  AND2X1 L1J ( .A(n_BLD05), .B(n_BLD07), .Y(n_L_14) );
  INVX2 L19 ( .A(n_L_1J), .Y(SFTEN) );
  NOR2X2 L18 ( .A(n_L_1J), .B(n_RP1), .Y(SAWPHEN) );
  OR2X1 L17 ( .A(n_EEV03), .B(n_BLD07), .Y(n_L_1J) );
  NOR2X2 L12 ( .A(n_L_1M), .B(n_RP1), .Y(REPHEN) );
  INVX2 L13 ( .A(n_L_1M), .Y(ABSEN) );
  OR2X1 L11 ( .A(n_EEV03), .B(n_BLD05), .Y(n_L_1M) );
  BUFX2 L0X ( .A(n_L_1S), .Y(EPSFT2) );
  NOR2X1 L0S ( .A(n_EEV20), .B(n_BLD07), .Y(n_L_23) );
  NOR2X1 L0R ( .A(n_EEV19), .B(n_BLD05), .Y(n_L_24) );
endmodule


module OR6D2 ( F, E, D, C, B, A, Y );
  input F, E, D, C, B, A;
  output Y;
  wire   n_A_09, n_A_01;

  NAND2X2 A0A ( .A(n_A_09), .B(n_A_01), .Y(Y) );
  NOR3X1 A01 ( .A(D), .B(E), .C(F), .Y(n_A_01) );
  NOR3X1 A09 ( .A(A), .B(B), .C(C), .Y(n_A_09) );
endmodule


module OR5D2 ( E, D, C, B, A, Y );
  input E, D, C, B, A;
  output Y;
  wire   n_A_08, n_A_07;

  NAND2X2 A09 ( .A(n_A_08), .B(n_A_07), .Y(Y) );
  NOR2X1 A08 ( .A(D), .B(E), .Y(n_A_07) );
  NOR3X1 A01 ( .A(A), .B(B), .C(C), .Y(n_A_08) );
endmodule


module OR5 ( E, D, C, B, A, Y );
  input E, D, C, B, A;
  output Y;
  wire   n_A_08, n_A_07;

  NAND2X1 A09 ( .A(n_A_08), .B(n_A_07), .Y(Y) );
  NOR2X1 A08 ( .A(D), .B(E), .Y(n_A_07) );
  NOR3X1 A01 ( .A(A), .B(B), .C(C), .Y(n_A_08) );
endmodule


module AD8 ( H, G, F, E, D, C, B, A, Y );
  input H, G, F, E, D, C, B, A;
  output Y;
  wire   n_A_0B, n_A_0A;

  NOR2X1 A03 ( .A(n_A_0B), .B(n_A_0A), .Y(Y) );
  NAND4X1 A02 ( .A(E), .B(F), .C(G), .D(H), .Y(n_A_0A) );
  NAND4X1 A01 ( .A(A), .B(B), .C(C), .D(D), .Y(n_A_0B) );
endmodule


module AD9 ( I, H, G, F, E, D, C, B, A, Y );
  input I, H, G, F, E, D, C, B, A;
  output Y;
  wire   n_A_0C, n_A_0B;

  NOR2X1 A03 ( .A(n_A_0C), .B(n_A_0B), .Y(Y) );
  NAND4X1 A02 ( .A(F), .B(G), .C(H), .D(I), .Y(n_A_0B) );
  ND5 A01 ( .E(E), .D(D), .C(C), .B(B), .A(A), .Y(n_A_0C) );
endmodule


module AD7 ( G, F, E, D, C, B, A, Y );
  input G, F, E, D, C, B, A;
  output Y;
  wire   n_A_0A, n_A_09;

  NOR2X1 A03 ( .A(n_A_0A), .B(n_A_09), .Y(Y) );
  NAND3X1 A02 ( .A(E), .B(F), .C(G), .Y(n_A_09) );
  NAND4X1 A01 ( .A(A), .B(B), .C(C), .D(D), .Y(n_A_0A) );
endmodule


module CL07 ( RN, TE, TI, SCL, CE, LE, CK, SE, Q, TO );
  output [6:0] Q;
  input RN, TE, TI, SCL, CE, LE, CK, SE;
  output TO;
  wire   n_A_06, n_A_08, n_A_07, n_A_0D1, n_A_0D2, n_A_0D3, n_A_0D4, n_A_0D5,
         n_A_0D6, n_A_0D7;

  BUFX2 A04 ( .A(RN), .Y(n_A_06) );
  BUFX2 A03 ( .A(TE), .Y(n_A_08) );
  CO07L A01 ( .D({n_A_0D1, n_A_0D2, n_A_0D3, n_A_0D4, n_A_0D5, n_A_0D6, 
        n_A_0D7}), .RN(n_A_06), .TE(n_A_08), .TI(TI), .CK(CK), .SCL(SCL), .LE(
        LE), .CE(CE), .Q(Q), .TO(n_A_07) );
  FE07R A02 ( .D(Q), .CK(CK), .TI(n_A_07), .EN(SE), .TE(n_A_08), .RN(n_A_06), 
        .Q({n_A_0D1, n_A_0D2, n_A_0D3, n_A_0D4, n_A_0D5, n_A_0D6, n_A_0D7}), 
        .TO(TO) );
endmodule


module CO07L ( D, RN, TE, TI, CK, SCL, LE, CE, Q, TO );
  input [6:0] D;
  output [6:0] Q;
  input RN, TE, TI, CK, SCL, LE, CE;
  output TO;
  wire   n_A_11, n_A_01, n_A_0R, n_A_08, n_A_10, n_A_0P, n_A_0S, n_A_0T,
         n_A_0U, n_A_0V;

  AND2X1 A12 ( .A(n_A_11), .B(Q[5]), .Y(n_A_01) );
  COU1L A0A ( .LE(n_A_0P), .D(D[6]), .RN(n_A_10), .TE(n_A_08), .TI(Q[5]), .CK(
        CK), .SCL(n_A_0R), .CE(n_A_01), .Q(Q[6]) );
  BUFX2 A0K ( .A(Q[6]), .Y(TO) );
  BUFX2 A0S ( .A(RN), .Y(n_A_10) );
  BUFX2 A0R ( .A(TE), .Y(n_A_08) );
  BUFX2 A0P ( .A(SCL), .Y(n_A_0R) );
  BUFX2 A0N ( .A(LE), .Y(n_A_0P) );
  AND2X1 A0G ( .A(n_A_0S), .B(Q[3]), .Y(n_A_0T) );
  AND2X1 A0H ( .A(n_A_0T), .B(Q[4]), .Y(n_A_11) );
  AND2X1 A0F ( .A(n_A_0U), .B(Q[2]), .Y(n_A_0S) );
  AND2X1 A08 ( .A(n_A_0V), .B(Q[1]), .Y(n_A_0U) );
  AND2X1 A09 ( .A(CE), .B(Q[0]), .Y(n_A_0V) );
  COU1L A06 ( .LE(n_A_0P), .D(D[5]), .RN(n_A_10), .TE(n_A_08), .TI(Q[4]), .CK(
        CK), .SCL(n_A_0R), .CE(n_A_11), .Q(Q[5]) );
  COU1L A05 ( .LE(n_A_0P), .D(D[4]), .RN(n_A_10), .TE(n_A_08), .TI(Q[3]), .CK(
        CK), .SCL(n_A_0R), .CE(n_A_0T), .Q(Q[4]) );
  COU1L A04 ( .LE(n_A_0P), .D(D[3]), .RN(n_A_10), .TE(n_A_08), .TI(Q[2]), .CK(
        CK), .SCL(n_A_0R), .CE(n_A_0S), .Q(Q[3]) );
  COU1L A03 ( .LE(n_A_0P), .D(D[2]), .RN(n_A_10), .TE(n_A_08), .TI(Q[1]), .CK(
        CK), .SCL(n_A_0R), .CE(n_A_0U), .Q(Q[2]) );
  COU1L A02 ( .LE(n_A_0P), .D(D[1]), .RN(n_A_10), .TE(n_A_08), .TI(Q[0]), .CK(
        CK), .SCL(n_A_0R), .CE(n_A_0V), .Q(Q[1]) );
  COU1L A01 ( .LE(n_A_0P), .D(D[0]), .RN(n_A_10), .TE(n_A_08), .TI(TI), .CK(CK), .SCL(n_A_0R), .CE(CE), .Q(Q[0]) );
endmodule


module CO05L ( D, RN, TE, TI, CK, SCL, LE, CE, Q0, Q1, Q2, Q3, Q4, TO );
  input [4:0] D;
  input RN, TE, TI, CK, SCL, LE, CE;
  output Q0, Q1, Q2, Q3, Q4, TO;
  wire   n_A_0R, n_A_0P, n_A_12, n_A_13, n_A_0S, n_A_0T, n_A_0U, n_A_0V;

  BUFX2 A0K ( .A(Q4), .Y(TO) );
  BUFX2 A0S ( .A(RN), .Y(n_A_0R) );
  BUFX2 A0R ( .A(TE), .Y(n_A_0P) );
  BUFX2 A0P ( .A(SCL), .Y(n_A_12) );
  BUFX2 A0N ( .A(LE), .Y(n_A_13) );
  AND2X1 A0G ( .A(n_A_0S), .B(Q3), .Y(n_A_0T) );
  AND2X1 A0F ( .A(n_A_0U), .B(Q2), .Y(n_A_0S) );
  AND2X1 A08 ( .A(n_A_0V), .B(Q1), .Y(n_A_0U) );
  AND2X1 A09 ( .A(CE), .B(Q0), .Y(n_A_0V) );
  COU1L A05 ( .LE(n_A_13), .D(D[4]), .RN(n_A_0R), .TE(n_A_0P), .TI(Q3), .CK(CK), .SCL(n_A_12), .CE(n_A_0T), .Q(Q4) );
  COU1L A04 ( .LE(n_A_13), .D(D[3]), .RN(n_A_0R), .TE(n_A_0P), .TI(Q2), .CK(CK), .SCL(n_A_12), .CE(n_A_0S), .Q(Q3) );
  COU1L A03 ( .LE(n_A_13), .D(D[2]), .RN(n_A_0R), .TE(n_A_0P), .TI(Q1), .CK(CK), .SCL(n_A_12), .CE(n_A_0U), .Q(Q2) );
  COU1L A02 ( .LE(n_A_13), .D(D[1]), .RN(n_A_0R), .TE(n_A_0P), .TI(Q0), .CK(CK), .SCL(n_A_12), .CE(n_A_0V), .Q(Q1) );
  COU1L A01 ( .LE(n_A_13), .D(D[0]), .RN(n_A_0R), .TE(n_A_0P), .TI(TI), .CK(CK), .SCL(n_A_12), .CE(CE), .Q(Q0) );
endmodule


module DS082 ( B, A, S, Y );
  input [7:0] B;
  input [7:0] A;
  output [7:0] Y;
  input S;
  wire   n_A_06;

  MX2X1 A00 ( .S0(n_A_06), .B(B[0]), .A(A[0]), .Y(Y[0]) );
  MX2X1 A01 ( .S0(n_A_06), .B(B[1]), .A(A[1]), .Y(Y[1]) );
  MX2X1 A02 ( .S0(n_A_06), .B(B[2]), .A(A[2]), .Y(Y[2]) );
  MX2X1 A03 ( .S0(n_A_06), .B(B[3]), .A(A[3]), .Y(Y[3]) );
  MX2X1 A04 ( .S0(n_A_06), .B(B[4]), .A(A[4]), .Y(Y[4]) );
  MX2X1 A05 ( .S0(n_A_06), .B(B[5]), .A(A[5]), .Y(Y[5]) );
  MX2X1 A06 ( .S0(n_A_06), .B(B[6]), .A(A[6]), .Y(Y[6]) );
  BUFX2 A10 ( .A(S), .Y(n_A_06) );
  MX2X1 A07 ( .S0(n_A_06), .B(B[7]), .A(A[7]), .Y(Y[7]) );
endmodule


module CO04L ( D, RN, TE, TI, CK, SCL, LE, CE, Q3, Q2, Q1, Q0, TO );
  input [3:0] D;
  input RN, TE, TI, CK, SCL, LE, CE;
  output Q3, Q2, Q1, Q0, TO;
  wire   n_A_10, n_A_0S, n_A_13, n_A_0P, n_A_0U, n_A_12, n_A_0V;

  BUFX2 A0K ( .A(Q3), .Y(TO) );
  BUFX2 A0S ( .A(RN), .Y(n_A_10) );
  BUFX2 A0R ( .A(TE), .Y(n_A_0S) );
  BUFX2 A0P ( .A(SCL), .Y(n_A_13) );
  BUFX2 A0N ( .A(LE), .Y(n_A_0P) );
  AND2X1 A0F ( .A(n_A_0U), .B(Q2), .Y(n_A_12) );
  AND2X1 A08 ( .A(n_A_0V), .B(Q1), .Y(n_A_0U) );
  AND2X1 A09 ( .A(CE), .B(Q0), .Y(n_A_0V) );
  COU1L A04 ( .LE(n_A_0P), .D(D[3]), .RN(n_A_10), .TE(n_A_0S), .TI(Q2), .CK(CK), .SCL(n_A_13), .CE(n_A_12), .Q(Q3) );
  COU1L A03 ( .LE(n_A_0P), .D(D[2]), .RN(n_A_10), .TE(n_A_0S), .TI(Q1), .CK(CK), .SCL(n_A_13), .CE(n_A_0U), .Q(Q2) );
  COU1L A02 ( .LE(n_A_0P), .D(D[1]), .RN(n_A_10), .TE(n_A_0S), .TI(Q0), .CK(CK), .SCL(n_A_13), .CE(n_A_0V), .Q(Q1) );
  COU1L A01 ( .LE(n_A_0P), .D(D[0]), .RN(n_A_10), .TE(n_A_0S), .TI(TI), .CK(CK), .SCL(n_A_13), .CE(CE), .Q(Q0) );
endmodule


module DS086 ( A, B, C, D, E, F, FE, EE, DE, CE, BE, AE, Y );
  input [7:0] A;
  input [7:0] B;
  input [7:0] C;
  input [7:0] D;
  input [7:0] E;
  input [7:0] F;
  output [7:0] Y;
  input FE, EE, DE, CE, BE, AE;
  wire   n_A_0G, n_A_048, n_A_047, n_A_046, n_A_045, n_A_044, n_A_043, n_A_042,
         n_A_0E, n_A_058, n_A_057, n_A_056, n_A_055, n_A_054, n_A_053, n_A_052,
         n_A_0C, n_A_068, n_A_067, n_A_066, n_A_065, n_A_064, n_A_063, n_A_062,
         n_A_0A, n_A_038, n_A_037, n_A_036, n_A_035, n_A_034, n_A_033, n_A_032,
         n_A_08, n_A_028, n_A_027, n_A_026, n_A_025, n_A_024, n_A_023, n_A_022,
         n_A_0W, n_A_0X8, n_A_0X7, n_A_0X6, n_A_0X5, n_A_0X4, n_A_0X3, n_A_0X2,
         n_A_061, n_A_051, n_A_041, n_A_031, n_A_021, n_A_0X1;

  NAND2X1 A010 ( .A(A[0]), .B(n_A_0G), .Y(n_A_048) );
  NAND2X1 A011 ( .A(A[1]), .B(n_A_0G), .Y(n_A_047) );
  NAND2X1 A012 ( .A(A[2]), .B(n_A_0G), .Y(n_A_046) );
  NAND2X1 A013 ( .A(A[3]), .B(n_A_0G), .Y(n_A_045) );
  NAND2X1 A014 ( .A(A[4]), .B(n_A_0G), .Y(n_A_044) );
  NAND2X1 A015 ( .A(A[5]), .B(n_A_0G), .Y(n_A_043) );
  NAND2X1 A016 ( .A(A[6]), .B(n_A_0G), .Y(n_A_042) );
  NAND2X1 A020 ( .A(B[0]), .B(n_A_0E), .Y(n_A_058) );
  NAND2X1 A021 ( .A(B[1]), .B(n_A_0E), .Y(n_A_057) );
  NAND2X1 A022 ( .A(B[2]), .B(n_A_0E), .Y(n_A_056) );
  NAND2X1 A023 ( .A(B[3]), .B(n_A_0E), .Y(n_A_055) );
  NAND2X1 A024 ( .A(B[4]), .B(n_A_0E), .Y(n_A_054) );
  NAND2X1 A025 ( .A(B[5]), .B(n_A_0E), .Y(n_A_053) );
  NAND2X1 A026 ( .A(B[6]), .B(n_A_0E), .Y(n_A_052) );
  NAND2X1 A030 ( .A(C[0]), .B(n_A_0C), .Y(n_A_068) );
  NAND2X1 A031 ( .A(C[1]), .B(n_A_0C), .Y(n_A_067) );
  NAND2X1 A032 ( .A(C[2]), .B(n_A_0C), .Y(n_A_066) );
  NAND2X1 A033 ( .A(C[3]), .B(n_A_0C), .Y(n_A_065) );
  NAND2X1 A034 ( .A(C[4]), .B(n_A_0C), .Y(n_A_064) );
  NAND2X1 A035 ( .A(C[5]), .B(n_A_0C), .Y(n_A_063) );
  NAND2X1 A036 ( .A(C[6]), .B(n_A_0C), .Y(n_A_062) );
  NAND2X1 A040 ( .A(D[0]), .B(n_A_0A), .Y(n_A_038) );
  NAND2X1 A041 ( .A(D[1]), .B(n_A_0A), .Y(n_A_037) );
  NAND2X1 A042 ( .A(D[2]), .B(n_A_0A), .Y(n_A_036) );
  NAND2X1 A043 ( .A(D[3]), .B(n_A_0A), .Y(n_A_035) );
  NAND2X1 A044 ( .A(D[4]), .B(n_A_0A), .Y(n_A_034) );
  NAND2X1 A045 ( .A(D[5]), .B(n_A_0A), .Y(n_A_033) );
  NAND2X1 A046 ( .A(D[6]), .B(n_A_0A), .Y(n_A_032) );
  NAND2X1 A050 ( .A(E[0]), .B(n_A_08), .Y(n_A_028) );
  NAND2X1 A051 ( .A(E[1]), .B(n_A_08), .Y(n_A_027) );
  NAND2X1 A052 ( .A(E[2]), .B(n_A_08), .Y(n_A_026) );
  NAND2X1 A053 ( .A(E[3]), .B(n_A_08), .Y(n_A_025) );
  NAND2X1 A054 ( .A(E[4]), .B(n_A_08), .Y(n_A_024) );
  NAND2X1 A055 ( .A(E[5]), .B(n_A_08), .Y(n_A_023) );
  NAND2X1 A056 ( .A(E[6]), .B(n_A_08), .Y(n_A_022) );
  NAND2X1 A060 ( .A(F[0]), .B(n_A_0W), .Y(n_A_0X8) );
  NAND2X1 A061 ( .A(F[1]), .B(n_A_0W), .Y(n_A_0X7) );
  NAND2X1 A062 ( .A(F[2]), .B(n_A_0W), .Y(n_A_0X6) );
  NAND2X1 A063 ( .A(F[3]), .B(n_A_0W), .Y(n_A_0X5) );
  NAND2X1 A064 ( .A(F[4]), .B(n_A_0W), .Y(n_A_0X4) );
  NAND2X1 A065 ( .A(F[5]), .B(n_A_0W), .Y(n_A_0X3) );
  NAND2X1 A066 ( .A(F[6]), .B(n_A_0W), .Y(n_A_0X2) );
  ND6 A070 ( .F(n_A_0X8), .E(n_A_028), .D(n_A_038), .C(n_A_068), .B(n_A_058), 
        .A(n_A_048), .Y(Y[0]) );
  ND6 A071 ( .F(n_A_0X7), .E(n_A_027), .D(n_A_037), .C(n_A_067), .B(n_A_057), 
        .A(n_A_047), .Y(Y[1]) );
  ND6 A072 ( .F(n_A_0X6), .E(n_A_026), .D(n_A_036), .C(n_A_066), .B(n_A_056), 
        .A(n_A_046), .Y(Y[2]) );
  ND6 A073 ( .F(n_A_0X5), .E(n_A_025), .D(n_A_035), .C(n_A_065), .B(n_A_055), 
        .A(n_A_045), .Y(Y[3]) );
  ND6 A074 ( .F(n_A_0X4), .E(n_A_024), .D(n_A_034), .C(n_A_064), .B(n_A_054), 
        .A(n_A_044), .Y(Y[4]) );
  ND6 A075 ( .F(n_A_0X3), .E(n_A_023), .D(n_A_033), .C(n_A_063), .B(n_A_053), 
        .A(n_A_043), .Y(Y[5]) );
  ND6 A076 ( .F(n_A_0X2), .E(n_A_022), .D(n_A_032), .C(n_A_062), .B(n_A_052), 
        .A(n_A_042), .Y(Y[6]) );
  BUFX2 A0X ( .A(FE), .Y(n_A_0W) );
  ND6 A077 ( .F(n_A_0X1), .E(n_A_021), .D(n_A_031), .C(n_A_061), .B(n_A_051), 
        .A(n_A_041), .Y(Y[7]) );
  NAND2X1 A067 ( .A(F[7]), .B(n_A_0W), .Y(n_A_0X1) );
  BUFX2 A0G ( .A(EE), .Y(n_A_08) );
  BUFX2 A0F ( .A(DE), .Y(n_A_0A) );
  BUFX2 A0E ( .A(CE), .Y(n_A_0C) );
  BUFX2 A0D ( .A(BE), .Y(n_A_0E) );
  BUFX2 A0C ( .A(AE), .Y(n_A_0G) );
  NAND2X1 A057 ( .A(E[7]), .B(n_A_08), .Y(n_A_021) );
  NAND2X1 A047 ( .A(D[7]), .B(n_A_0A), .Y(n_A_031) );
  NAND2X1 A037 ( .A(C[7]), .B(n_A_0C), .Y(n_A_061) );
  NAND2X1 A027 ( .A(B[7]), .B(n_A_0E), .Y(n_A_051) );
  NAND2X1 A017 ( .A(A[7]), .B(n_A_0G), .Y(n_A_041) );
endmodule


module CL06 ( RN, TE, TI, SCL, CE, LE, CK, SE, Q5, Q4, Q3, Q2, Q1, Q0, TO );
  input RN, TE, TI, SCL, CE, LE, CK, SE;
  output Q5, Q4, Q3, Q2, Q1, Q0, TO;
  wire   n_A_07, n_A_08, n_A_06, n_A_0D1, n_A_0D2, n_A_0D3, n_A_0D4, n_A_0D5,
         n_A_0D6;

  FE06R A01 ( .D({Q5, Q4, Q3, Q2, Q1, Q0}), .CK(CK), .TI(n_A_07), .EN(SE), 
        .TE(n_A_08), .RN(n_A_06), .Q({n_A_0D1, n_A_0D2, n_A_0D3, n_A_0D4, 
        n_A_0D5, n_A_0D6}), .TO(TO) );
  CO06L A02 ( .D({n_A_0D1, n_A_0D2, n_A_0D3, n_A_0D4, n_A_0D5, n_A_0D6}), .RN(
        n_A_06), .TE(n_A_08), .TI(TI), .CK(CK), .SCL(SCL), .LE(LE), .CE(CE), 
        .Q({Q5, Q4, Q3, Q2, Q1, Q0}), .TO(n_A_07) );
  BUFX2 A04 ( .A(RN), .Y(n_A_06) );
  BUFX2 A03 ( .A(TE), .Y(n_A_08) );
endmodule


module CO06L ( D, RN, TE, TI, CK, SCL, LE, CE, Q, TO );
  input [5:0] D;
  output [5:0] Q;
  input RN, TE, TI, CK, SCL, LE, CE;
  output TO;
  wire   n_A_10, n_A_08, n_A_0R, n_A_0P, n_A_0S, n_A_0T, n_A_11, n_A_0U,
         n_A_0V;

  BUFX2 A0K ( .A(Q[5]), .Y(TO) );
  BUFX2 A0S ( .A(RN), .Y(n_A_10) );
  BUFX2 A0R ( .A(TE), .Y(n_A_08) );
  BUFX2 A0P ( .A(SCL), .Y(n_A_0R) );
  BUFX2 A0N ( .A(LE), .Y(n_A_0P) );
  AND2X1 A0G ( .A(n_A_0S), .B(Q[3]), .Y(n_A_0T) );
  AND2X1 A0H ( .A(n_A_0T), .B(Q[4]), .Y(n_A_11) );
  AND2X1 A0F ( .A(n_A_0U), .B(Q[2]), .Y(n_A_0S) );
  AND2X1 A08 ( .A(n_A_0V), .B(Q[1]), .Y(n_A_0U) );
  AND2X1 A09 ( .A(CE), .B(Q[0]), .Y(n_A_0V) );
  COU1L A06 ( .LE(n_A_0P), .D(D[5]), .RN(n_A_10), .TE(n_A_08), .TI(Q[4]), .CK(
        CK), .SCL(n_A_0R), .CE(n_A_11), .Q(Q[5]) );
  COU1L A05 ( .LE(n_A_0P), .D(D[4]), .RN(n_A_10), .TE(n_A_08), .TI(Q[3]), .CK(
        CK), .SCL(n_A_0R), .CE(n_A_0T), .Q(Q[4]) );
  COU1L A04 ( .LE(n_A_0P), .D(D[3]), .RN(n_A_10), .TE(n_A_08), .TI(Q[2]), .CK(
        CK), .SCL(n_A_0R), .CE(n_A_0S), .Q(Q[3]) );
  COU1L A03 ( .LE(n_A_0P), .D(D[2]), .RN(n_A_10), .TE(n_A_08), .TI(Q[1]), .CK(
        CK), .SCL(n_A_0R), .CE(n_A_0U), .Q(Q[2]) );
  COU1L A02 ( .LE(n_A_0P), .D(D[1]), .RN(n_A_10), .TE(n_A_08), .TI(Q[0]), .CK(
        CK), .SCL(n_A_0R), .CE(n_A_0V), .Q(Q[1]) );
  COU1L A01 ( .LE(n_A_0P), .D(D[0]), .RN(n_A_10), .TE(n_A_08), .TI(TI), .CK(CK), .SCL(n_A_0R), .CE(CE), .Q(Q[0]) );
endmodule


module COU1L ( LE, D, RN, TE, TI, CK, SCL, CE, Q );
  input LE, D, RN, TE, TI, CK, SCL, CE;
  output Q;
  wire   n_A_0A, n_A_01, n_A_0C, n_A_09, n_A_04;

  AND2X1 A0D ( .A(n_A_0A), .B(n_A_01), .Y(n_A_0C) );
  MX2X1 A0B ( .S0(LE), .B(D), .A(n_A_09), .Y(n_A_0A) );
  MX2X1 A02 ( .S0(CE), .B(n_A_04), .A(Q), .Y(n_A_09) );
  DFFRX2 A03 ( .D(n_A_0C), .CK(CK), .RN(RN), .Q(Q), .QN(n_A_04) );
  INVX1 A0C ( .A(SCL), .Y(n_A_01) );
endmodule


module FE06R ( D, CK, TI, EN, TE, RN, Q, TO );
  input [5:0] D;
  output [5:0] Q;
  input CK, TI, EN, TE, RN;
  output TO;
  wire   n_A_0L, n_A_0M, n_A_0N;

  BUFX2 A0V ( .A(Q[5]), .Y(TO) );
  BUFX2 A0M ( .A(EN), .Y(n_A_0L) );
  BUFX2 A0L ( .A(TE), .Y(n_A_0M) );
  BUFX2 A0K ( .A(RN), .Y(n_A_0N) );
  FE1R A06 ( .RN(n_A_0N), .TE(n_A_0M), .TI(Q[4]), .CK(CK), .EN(n_A_0L), .D(
        D[5]), .Q(Q[5]) );
  FE1R A05 ( .RN(n_A_0N), .TE(n_A_0M), .TI(Q[3]), .CK(CK), .EN(n_A_0L), .D(
        D[4]), .Q(Q[4]) );
  FE1R A04 ( .RN(n_A_0N), .TE(n_A_0M), .TI(Q[2]), .CK(CK), .EN(n_A_0L), .D(
        D[3]), .Q(Q[3]) );
  FE1R A03 ( .RN(n_A_0N), .TE(n_A_0M), .TI(Q[1]), .CK(CK), .EN(n_A_0L), .D(
        D[2]), .Q(Q[2]) );
  FE1R A02 ( .RN(n_A_0N), .TE(n_A_0M), .TI(Q[0]), .CK(CK), .EN(n_A_0L), .D(
        D[1]), .Q(Q[1]) );
  FE1R A01 ( .RN(n_A_0N), .TE(n_A_0M), .TI(TI), .CK(CK), .EN(n_A_0L), .D(D[0]), 
        .Q(Q[0]) );
endmodule


module DCO04 ( QS, RN, TE, CE2, TI, SCL, CE1, CK, TO, Q3, Q2, Q1, Q0 );
  input QS, RN, TE, CE2, TI, SCL, CE1, CK;
  output TO, Q3, Q2, Q1, Q0;
  wire   n_A_04, n_A_0L, n_A_0H, n_A_0K, n_A_0G, n_A_0J, n_A_0F, n_A_05;

  BUFX2 A04 ( .A(n_A_04), .Y(TO) );
  DS42 A03 ( .S(QS), .B3(n_A_04), .A3(n_A_05), .B2(n_A_0F), .A2(n_A_0J), .B1(
        n_A_0G), .A1(n_A_0K), .B0(n_A_0H), .A0(n_A_0L), .Y3(Q3), .Y2(Q2), .Y1(
        Q1), .Y0(Q0) );
  CO04 A02 ( .RN(RN), .TE(TE), .CK(CK), .SCL(SCL), .TI(n_A_05), .EN(CE2), .Q3(
        n_A_04), .Q2(n_A_0F), .Q1(n_A_0G), .Q0(n_A_0H) );
  CO04 A01 ( .RN(RN), .TE(TE), .CK(CK), .SCL(SCL), .TI(TI), .EN(CE1), .Q3(
        n_A_05), .Q2(n_A_0J), .Q1(n_A_0K), .Q0(n_A_0L) );
endmodule


module CO04 ( RN, TE, CK, SCL, TI, EN, Q3, Q2, Q1, Q0 );
  input RN, TE, CK, SCL, TI, EN;
  output Q3, Q2, Q1, Q0;
  wire   n_A_0K, n_A_0L, n_A_0M, n_A_07, n_A_0D, n_A_0F, n_A_0A, n_A_0E,
         n_A_0C, n_A_0B, n_A_09;

  BUFX2 A0D ( .A(RN), .Y(n_A_0K) );
  BUFX2 A0C ( .A(TE), .Y(n_A_0L) );
  BUFX2 A0B ( .A(SCL), .Y(n_A_0M) );
  BUFX2 A09 ( .A(EN), .Y(n_A_07) );
  INVX2 A08 ( .A(n_A_07), .Y(n_A_0D) );
  NOR2X1 A07 ( .A(n_A_0D), .B(n_A_0A), .Y(n_A_0F) );
  NOR4X1 A05 ( .A(n_A_0D), .B(n_A_0A), .C(n_A_0C), .D(n_A_0B), .Y(n_A_0E) );
  NOR3X1 A06 ( .A(n_A_0D), .B(n_A_0A), .C(n_A_0C), .Y(n_A_09) );
  COU1 A04 ( .RN(n_A_0K), .TE(n_A_0L), .TI(Q2), .CK(CK), .SCL(n_A_0M), .EN(
        n_A_0E), .Q(Q3) );
  COU1 A03 ( .RN(n_A_0K), .TE(n_A_0L), .TI(Q1), .CK(CK), .SCL(n_A_0M), .EN(
        n_A_09), .QN(n_A_0B), .Q(Q2) );
  COU1 A02 ( .RN(n_A_0K), .TE(n_A_0L), .TI(Q0), .CK(CK), .SCL(n_A_0M), .EN(
        n_A_0F), .QN(n_A_0C), .Q(Q1) );
  COU1 A01 ( .RN(n_A_0K), .TE(n_A_0L), .TI(TI), .CK(CK), .SCL(n_A_0M), .EN(
        n_A_07), .QN(n_A_0A), .Q(Q0) );
endmodule


module EWADEC ( A, Y );
  input [3:0] A;
  output Y;
  wire   n_A_0K, n_A_0H, n_A_0G, n_A_0F, n_A_0J, n_A_0M, n_A_0L, n_A_0N;

  AND3X1 A06 ( .A(A[0]), .B(A[1]), .C(A[3]), .Y(n_A_0K) );
  NAND3X1 A09 ( .A(n_A_0H), .B(n_A_0G), .C(n_A_0F), .Y(Y) );
  NAND2X1 A08 ( .A(n_A_0K), .B(n_A_0J), .Y(n_A_0F) );
  INVX1 A07 ( .A(A[2]), .Y(n_A_0J) );
  NAND2X1 A05 ( .A(n_A_0M), .B(n_A_0L), .Y(n_A_0G) );
  AND2X1 A04 ( .A(A[0]), .B(A[3]), .Y(n_A_0L) );
  NOR2X1 A03 ( .A(A[1]), .B(A[2]), .Y(n_A_0M) );
  NAND2X1 A02 ( .A(n_A_0N), .B(A[2]), .Y(n_A_0H) );
  NOR3X1 A01 ( .A(A[0]), .B(A[1]), .C(A[3]), .Y(n_A_0N) );
endmodule


module DC08B ( A, Y );
  input [2:0] A;
  output [7:0] Y;
  wire   n_A_0U, n_A_0T, n_A_0S, n_A_0R, n_A_0P, n_A_0N, n_A_0M, n_A_0L,
         n_A_0D, n_A_0B, n_A_09, n_A_0E, n_A_0C, n_A_0A;

  BUFX4 A0W ( .A(n_A_0U), .Y(Y[7]) );
  BUFX4 A0V ( .A(n_A_0T), .Y(Y[6]) );
  BUFX4 A09 ( .A(n_A_0S), .Y(Y[5]) );
  BUFX4 A0K ( .A(n_A_0R), .Y(Y[4]) );
  BUFX4 A0J ( .A(n_A_0P), .Y(Y[3]) );
  BUFX4 A0H ( .A(n_A_0N), .Y(Y[2]) );
  BUFX4 A0L ( .A(n_A_0M), .Y(Y[1]) );
  BUFX4 A0M ( .A(n_A_0L), .Y(Y[0]) );
  NAND3X1 A08 ( .A(n_A_0D), .B(n_A_0B), .C(n_A_09), .Y(n_A_0U) );
  NAND3X1 A07 ( .A(n_A_0E), .B(n_A_0B), .C(n_A_09), .Y(n_A_0T) );
  NAND3X1 A06 ( .A(n_A_0D), .B(n_A_0C), .C(n_A_09), .Y(n_A_0S) );
  NAND3X1 A05 ( .A(n_A_0E), .B(n_A_0C), .C(n_A_09), .Y(n_A_0R) );
  NAND3X1 A04 ( .A(n_A_0D), .B(n_A_0B), .C(n_A_0A), .Y(n_A_0P) );
  NAND3X1 A03 ( .A(n_A_0E), .B(n_A_0B), .C(n_A_0A), .Y(n_A_0N) );
  NAND3X1 A02 ( .A(n_A_0D), .B(n_A_0C), .C(n_A_0A), .Y(n_A_0M) );
  NAND3X1 A01 ( .A(n_A_0E), .B(n_A_0C), .C(n_A_0A), .Y(n_A_0L) );
  INVX1 A0B ( .A(n_A_0D), .Y(n_A_0E) );
  INVX1 A0D ( .A(n_A_0B), .Y(n_A_0C) );
  INVX1 A0F ( .A(n_A_09), .Y(n_A_0A) );
  BUFX2 A0E ( .A(A[0]), .Y(n_A_0D) );
  BUFX2 A0C ( .A(A[1]), .Y(n_A_0B) );
  BUFX2 A0A ( .A(A[2]), .Y(n_A_09) );
endmodule


module EEMDEC ( EEMRWC, RN, TE, TI, EEMEND, EEMST, CK, EN, EEMCE, EEMDS, EIMAE, 
        EEMACE, TO, EEMDILE, EEMDOLE, EEMALE, XEEMWE );
  input EEMRWC, RN, TE, TI, EEMEND, EEMST, CK, EN;
  output EEMCE, EEMDS, EIMAE, EEMACE, TO, EEMDILE, EEMDOLE, EEMALE, XEEMWE;
  wire   n_A_0U, n_A_10, n_A_0S, n_A_05, n_A_0C, n_A_0M, n_A_09, n_A_0L,
         n_A_11, n_A_0J, n_A_06, n_A_0X, n_A_03, n_A_07, n_A_0F, n_A_0T;

  INVX1 A19 ( .A(n_A_0U), .Y(n_A_10) );
  NOR2X1 A18 ( .A(n_A_10), .B(n_A_05), .Y(n_A_0S) );
  AND2X2 A16 ( .A(n_A_0C), .B(n_A_0M), .Y(EEMCE) );
  AND3X2 A0A ( .A(n_A_09), .B(n_A_0L), .C(n_A_11), .Y(EEMDS) );
  AND3X2 A09 ( .A(n_A_09), .B(n_A_0C), .C(n_A_0J), .Y(EEMALE) );
  AND2X2 A0D ( .A(n_A_09), .B(n_A_0J), .Y(EIMAE) );
  BUFX2 A0T ( .A(n_A_06), .Y(n_A_09) );
  BUFX2 A0F ( .A(EEMRWC), .Y(n_A_0X) );
  AND3X2 A0B ( .A(n_A_0S), .B(n_A_0C), .C(n_A_0X), .Y(EEMDOLE) );
  NAND3X2 A14 ( .A(n_A_0C), .B(n_A_0X), .C(n_A_11), .Y(XEEMWE) );
  BUFX2 A15 ( .A(n_A_06), .Y(EEMACE) );
  AND3X2 A0C ( .A(n_A_0C), .B(n_A_11), .C(n_A_0L), .Y(EEMDILE) );
  INVX1 A08 ( .A(n_A_0X), .Y(n_A_0L) );
  BUFX2 A0Y ( .A(RN), .Y(n_A_03) );
  BUFX2 A0W ( .A(n_A_05), .Y(TO) );
  BUFX2 A0U ( .A(TE), .Y(n_A_07) );
  BUFX2 A0E ( .A(EN), .Y(n_A_0C) );
  AND2X1 A07 ( .A(n_A_0C), .B(n_A_06), .Y(n_A_0F) );
  INVX1 A06 ( .A(n_A_0U), .Y(n_A_0T) );
  AND2X1 A05 ( .A(n_A_0U), .B(n_A_05), .Y(n_A_0M) );
  AND2X1 A04 ( .A(n_A_0T), .B(n_A_05), .Y(n_A_11) );
  NOR2X1 A03 ( .A(n_A_0U), .B(n_A_05), .Y(n_A_0J) );
  CO02 A02 ( .RN(n_A_03), .TE(n_A_07), .TI(n_A_06), .CK(CK), .SCL(EEMEND), 
        .EN(n_A_0F), .Q1(n_A_05), .Q0(n_A_0U) );
  FS1R A01 ( .EN(n_A_0C), .RN(n_A_03), .TE(n_A_07), .TI(TI), .CK(CK), .SR(
        EEMEND), .SS(EEMST), .Q(n_A_06) );
endmodule


module ESQLGC ( A, B5, EN, B7, B3, B2, B1, FLEND, EMST, SE, Y );
  input [23:0] A;
  input B5, EN, B7, B3, B2, B1;
  output FLEND, EMST, SE, Y;
  wire   n_A_1W, n_A_1B, n_A_0Y, n_A_11, n_A_12, n_A_10, n_A_17, n_A_1T,
         n_A_0R, n_A_1U, n_A_1X, n_A_1C, n_A_1F, n_A_22, n_A_1L, n_A_0V,
         n_A_13, n_A_14, n_A_15, n_A_1P, n_A_1N, n_A_16, n_A_1H, n_A_1M,
         n_A_21, n_A_1K, n_A_1D, n_A_1E, n_A_1J, n_A_19, n_A_1A, n_A_18;

  BUFX2 A012 ( .A(A[21]), .Y(n_A_1W) );
  BUFX2 A011 ( .A(A[1]), .Y(n_A_1B) );
  ND6 A016 ( .F(n_A_17), .E(n_A_10), .D(n_A_1W), .C(n_A_0Y), .B(n_A_11), .A(
        n_A_12), .Y(n_A_1T) );
  AND2X2 A014 ( .A(n_A_0R), .B(n_A_1U), .Y(FLEND) );
  INVX1 A01B ( .A(n_A_1W), .Y(n_A_1X) );
  AND2X1 A013 ( .A(n_A_1U), .B(n_A_1X), .Y(EMST) );
  BUFX2 A004 ( .A(A[4]), .Y(n_A_1C) );
  OR2X1 A005 ( .A(A[5]), .B(B1), .Y(n_A_1F) );
  BUFX2 A020 ( .A(EN), .Y(n_A_1U) );
  BUFX2 A008 ( .A(A[8]), .Y(n_A_22) );
  OR2X1 A007 ( .A(A[7]), .B(B1), .Y(n_A_1L) );
  AND2X1 A01A ( .A(n_A_1U), .B(n_A_0R), .Y(SE) );
  INVX1 A00P ( .A(n_A_17), .Y(n_A_0R) );
  AND2X2 A018 ( .A(n_A_1U), .B(n_A_0V), .Y(Y) );
  OR2X1 A00L ( .A(A[20]), .B(B7), .Y(n_A_0Y) );
  OR2X1 A00M ( .A(A[22]), .B(B7), .Y(n_A_10) );
  OR2X1 A00N ( .A(A[23]), .B(B5), .Y(n_A_17) );
  BUFX2 A00K ( .A(A[19]), .Y(n_A_11) );
  OR2X1 A00G ( .A(A[18]), .B(B3), .Y(n_A_12) );
  OR2X1 A00H ( .A(A[17]), .B(B3), .Y(n_A_13) );
  OR2X1 A00J ( .A(A[16]), .B(B2), .Y(n_A_14) );
  BUFX2 A00F ( .A(A[15]), .Y(n_A_15) );
  OR2X1 A00C ( .A(A[12]), .B(B2), .Y(n_A_1P) );
  OR2X1 A00D ( .A(A[13]), .B(B3), .Y(n_A_1N) );
  OR2X1 A00E ( .A(A[14]), .B(B3), .Y(n_A_16) );
  BUFX2 A00B ( .A(A[11]), .Y(n_A_1H) );
  BUFX2 A00A ( .A(A[10]), .Y(n_A_1M) );
  BUFX2 A009 ( .A(A[9]), .Y(n_A_21) );
  BUFX2 A006 ( .A(A[6]), .Y(n_A_1K) );
  BUFX2 A003 ( .A(A[3]), .Y(n_A_1D) );
  OR2X1 A002 ( .A(A[2]), .B(B3), .Y(n_A_1E) );
  BUFX2 A001 ( .A(A[0]), .Y(n_A_1J) );
  OR4X1 A017 ( .A(n_A_1A), .B(n_A_19), .C(n_A_18), .D(n_A_1T), .Y(n_A_0V) );
  ND6 A015 ( .F(n_A_13), .E(n_A_14), .D(n_A_15), .C(n_A_16), .B(n_A_1N), .A(
        n_A_1P), .Y(n_A_18) );
  ND6 A01J ( .F(n_A_1H), .E(n_A_1M), .D(n_A_21), .C(n_A_22), .B(n_A_1L), .A(
        n_A_1K), .Y(n_A_19) );
  ND6 A01H ( .F(n_A_1F), .E(n_A_1C), .D(n_A_1D), .C(n_A_1E), .B(n_A_1B), .A(
        n_A_1J), .Y(n_A_1A) );
endmodule


module EIMCT ( EDBR, EEMDO, PMD, EMCL, EEMDS, ENP, EWREQ, EPWEN, EIMWE, ESCST, 
        EIMDI, EWRDY, XEIMWE );
  input [15:0] EDBR;
  input [15:0] EEMDO;
  input [15:0] PMD;
  output [15:0] EIMDI;
  input EMCL, EEMDS, ENP, EWREQ, EPWEN, EIMWE, ESCST;
  output EWRDY, XEIMWE;
  wire   n_A_15, n_A_02, n_A_0J1, n_A_0J2, n_A_0J3, n_A_0J4, n_A_0J5, n_A_0J6,
         n_A_0J7, n_A_0J8, n_A_0J9, n_A_0J10, n_A_0J11, n_A_0J12, n_A_0J13,
         n_A_0J14, n_A_0J15, n_A_0J16, n_A_05, n_A_0D, n_A_0S, n_A_10, n_A_12,
         n_A_13, n_A_0F, n_A_01, n_A_17;

  DS163 A10 ( .B({n_A_0J1, n_A_0J2, n_A_0J3, n_A_0J4, n_A_0J5, n_A_0J6, 
        n_A_0J7, n_A_0J8, n_A_0J9, n_A_0J10, n_A_0J11, n_A_0J12, n_A_0J13, 
        n_A_0J14, n_A_0J15, n_A_0J16}), .A(EDBR), .C(PMD), .S2(n_A_02), .S1(
        n_A_15), .Y(EIMDI) );
  BUFX2 A12 ( .A(n_A_05), .Y(EWRDY) );
  NOR2X2 A1B ( .A(EIMWE), .B(n_A_05), .Y(XEIMWE) );
  AND2X1 A1E ( .A(n_A_0D), .B(n_A_0S), .Y(n_A_05) );
  INVX1 A07 ( .A(n_A_10), .Y(n_A_12) );
  OR2X1 A1C ( .A(n_A_12), .B(ENP), .Y(n_A_0S) );
  OR2X1 A0X ( .A(EEMDS), .B(n_A_02), .Y(n_A_15) );
  OR2X1 A1D ( .A(n_A_10), .B(n_A_13), .Y(n_A_0F) );
  NAND2X1 A08 ( .A(n_A_01), .B(n_A_0F), .Y(n_A_02) );
  NAND2X1 A03 ( .A(EPWEN), .B(n_A_10), .Y(n_A_01) );
  INVX1 A09 ( .A(EWREQ), .Y(n_A_13) );
  INVX1 A19 ( .A(EMCL), .Y(n_A_17) );
  EN16 A17 ( .A(EEMDO), .EN(n_A_17), .Y({n_A_0J1, n_A_0J2, n_A_0J3, n_A_0J4, 
        n_A_0J5, n_A_0J6, n_A_0J7, n_A_0J8, n_A_0J9, n_A_0J10, n_A_0J11, 
        n_A_0J12, n_A_0J13, n_A_0J14, n_A_0J15, n_A_0J16}) );
  BUFX2 A06 ( .A(ESCST), .Y(n_A_10) );
  OAI22X1 A02 ( .A0(n_A_01), .A1(n_A_13), .B0(n_A_13), .B1(n_A_10), .Y(n_A_0D)
         );
endmodule


module EN16 ( A, EN, Y );
  input [15:0] A;
  output [15:0] Y;
  input EN;
  wire   n_A_05;

  AND2X2 A100 ( .A(A[0]), .B(n_A_05), .Y(Y[0]) );
  AND2X2 A101 ( .A(A[1]), .B(n_A_05), .Y(Y[1]) );
  AND2X2 A102 ( .A(A[2]), .B(n_A_05), .Y(Y[2]) );
  AND2X2 A103 ( .A(A[3]), .B(n_A_05), .Y(Y[3]) );
  AND2X2 A104 ( .A(A[4]), .B(n_A_05), .Y(Y[4]) );
  AND2X2 A105 ( .A(A[5]), .B(n_A_05), .Y(Y[5]) );
  AND2X2 A106 ( .A(A[6]), .B(n_A_05), .Y(Y[6]) );
  AND2X2 A107 ( .A(A[7]), .B(n_A_05), .Y(Y[7]) );
  AND2X2 A108 ( .A(A[8]), .B(n_A_05), .Y(Y[8]) );
  AND2X2 A109 ( .A(A[9]), .B(n_A_05), .Y(Y[9]) );
  AND2X2 A110 ( .A(A[10]), .B(n_A_05), .Y(Y[10]) );
  AND2X2 A111 ( .A(A[11]), .B(n_A_05), .Y(Y[11]) );
  AND2X2 A112 ( .A(A[12]), .B(n_A_05), .Y(Y[12]) );
  AND2X2 A113 ( .A(A[13]), .B(n_A_05), .Y(Y[13]) );
  AND2X2 A114 ( .A(A[14]), .B(n_A_05), .Y(Y[14]) );
  BUFX4 A001 ( .A(EN), .Y(n_A_05) );
  AND2X2 A115 ( .A(A[15]), .B(n_A_05), .Y(Y[15]) );
endmodule


module TSP ( TIMO, EROMA, PLACA, FMODE, SLWD, PMD, TROMO, PITB, CHLV, ITPD, 
        PMA, CHTEST, XRST, TE, ESSCL, ESSCE, TI, CHOSLD, TSYNC, WSCST, EROMAS, 
        TLWREQ, THWREQ, ENP, MCK, TROMA, ESSD, TIMI, TIMA, TSCST, TLWRDY, 
        THWRDY, XTIMWE, TO, WST1, WST0, ESYNC );
  input [23:0] TIMO;
  input [8:0] EROMA;
  input [6:0] PLACA;
  input [1:0] FMODE;
  input [19:0] SLWD;
  input [11:0] PMD;
  input [7:0] TROMO;
  input [3:0] PITB;
  input [2:0] CHLV;
  input [7:0] ITPD;
  input [8:0] PMA;
  output [8:0] TROMA;
  output [19:0] ESSD;
  output [23:0] TIMI;
  output [8:0] TIMA;
  input CHTEST, XRST, TE, ESSCL, ESSCE, TI, CHOSLD, TSYNC, WSCST, EROMAS,
         TLWREQ, THWREQ, ENP, MCK;
  output TSCST, TLWRDY, THWRDY, XTIMWE, TO, WST1, WST0, ESYNC;
  wire   n_A_1S, n_A_1T, n_A_1U, n_A_1V, n_A_1W, n_A_1X, n_A_1Y, n_A_20,
         n_A_21, n_A_22, n_A_23, n_A_0R, n_A_38, n_A_07, n_A_1D1, n_A_1D2,
         n_A_1D3, n_A_1D4, n_A_1D5, n_A_1D6, n_A_1D7, n_A_1D8, n_A_1D9,
         n_A_1D10, n_A_1D11, n_A_1D12, n_A_1D13, n_A_1D14, n_A_1D15, n_A_1D16,
         n_A_1D17, n_A_1D18, n_A_1D19, n_A_1D20, n_A_0X1, n_A_0X2, n_A_0X3,
         n_A_0X4, n_A_0X5, n_A_0X6, n_A_0X7, n_A_0X8, n_A_0X9, n_A_0X10,
         n_A_0X11, n_A_0X12, n_A_0X13, n_A_0X14, n_A_0X15, n_A_0X16, n_A_0X17,
         n_A_0X18, n_A_0X19, n_A_0X20, n_A_04, n_A_26, n_A_2U, n_A_2W, n_A_2E,
         n_A_2N, n_A_13, n_A_1K, n_A_27, n_A_1B, n_A_1M, n_A_1N, n_A_2J,
         n_A_2P, n_A_2F, n_A_1J, n_A_2R, n_A_1L, n_A_2C, n_A_2K, n_A_2G,
         n_A_1H, n_A_2T, n_A_2H, n_A_2V, n_A_0E, n_A_2M, n_A_1R, n_A_1P,
         n_A_0A, n_A_25, n_A_15, n_A_0G, n_A_2A, n_A_0T, n_A_2S, n_A_2D,
         n_A_051, n_A_052, n_A_053, n_A_054, n_A_055, n_A_056, n_A_057,
         n_A_058, n_A_059, n_A_121, n_A_122, n_A_123, n_A_124, n_A_125,
         n_A_126, n_A_127, n_A_128, n_A_129, n_A_29, n_A_1A, n_A_321, n_A_322,
         n_A_323, n_A_324, n_A_325, n_A_326, n_A_327, n_A_328, n_A_329,
         n_A_3210, n_A_3211, n_A_3212, n_A_3213, n_A_3214, n_A_3215, n_A_3216,
         n_A_3217, n_A_3218, n_A_3219, n_A_3220, n_A_061, n_A_062, n_A_063,
         n_A_064, n_A_065, n_A_066, n_A_067, n_A_068, n_A_069, n_A_0610,
         n_A_0611, n_A_0612, n_A_0613, n_A_0614, n_A_0615, n_A_0616, n_A_0617,
         n_A_0618, n_A_0619, n_A_0620, n_A_0621, n_A_0622, n_A_0623, n_A_0624,
         n_A_1E1, n_A_1E2, n_A_1E3, n_A_1E4, n_A_1E5, n_A_1E6, n_A_1E7,
         n_A_1E8, n_A_1E9, n_A_1E10, n_A_1E11, n_A_1E12, n_A_1E13, n_A_1E14,
         n_A_1E15, n_A_1E16, n_A_1E17, n_A_1E18, n_A_1E19, n_A_1E20, n_A_1G;

  TOACC A04 ( .TSO({n_A_1D1, n_A_1D2, n_A_1D3, n_A_1D4, n_A_1D5, n_A_1D6, 
        n_A_1D7, n_A_1D8, n_A_1D9, n_A_1D10, n_A_1D11, n_A_1D12, n_A_1D13, 
        n_A_1D14, n_A_1D15, n_A_1D16, n_A_1D17, n_A_1D18, n_A_1D19, n_A_1D20}), 
        .TROMO(TROMO), .ACCL(n_A_1X), .XRST(n_A_0R), .DYACLE(n_A_1W), .CHACLE(
        n_A_1V), .RVACLE(n_A_1U), .DRACLE(n_A_1T), .ESSCL(ESSCL), .ESSCE(ESSCE), .DYACEN(n_A_23), .CHACEN(n_A_22), .REACEN(n_A_21), .DLACEN(n_A_1Y), .DRACEN(
        n_A_20), .TE(n_A_07), .MCK(MCK), .DLACLE(n_A_1S), .TI(n_A_38), .ESSD(
        ESSD), .TACO({n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, 
        n_A_0X7, n_A_0X8, n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, 
        n_A_0X14, n_A_0X15, n_A_0X16, n_A_0X17, n_A_0X18, n_A_0X19, n_A_0X20}), 
        .TO(TO) );
  TSPSQ A05 ( .PLACA(PLACA), .FMODE(FMODE), .CHTEST(CHTEST), .MCK(MCK), .TI(TI), .TE(n_A_07), .ENP(n_A_04), .XRST(n_A_0R), .WSCST(WSCST), .TSYNC(TSYNC), 
        .CHOSLD(CHOSLD), .PITB(PITB), .TIMEA({n_A_051, n_A_052, n_A_053, 
        n_A_054, n_A_055, n_A_056, n_A_057, n_A_058, n_A_059}), .TACCL(n_A_1X), 
        .TPWEN(n_A_26), .TSCST(TSCST), .ESYNC(ESYNC), .TO(n_A_0A), .TIMLLLE(
        n_A_1K), .TTLE(n_A_2J), .TC2LE(n_A_1N), .TC1LE(n_A_1M), .DYACLE(n_A_1W), .CHACLE(n_A_1V), .RVACLE(n_A_1U), .DLACLE(n_A_1S), .DRACLE(n_A_1T), .TIMLWE(
        n_A_1B), .TIMHWE(n_A_27), .WEABLE(n_A_13), .TBLE(n_A_2N), .TALE(n_A_2E), .TYLE(n_A_2W), .TXLE(n_A_2U), .PLACB({n_A_121, n_A_122, n_A_123, n_A_124, 
        n_A_125, n_A_126, n_A_127, n_A_128, n_A_129}), .TIMEXEN(n_A_0G), 
        .CHLVEN(n_A_2S), .TBS2EN(n_A_2D), .TROMEN(n_A_2T), .WESAEN(n_A_15), 
        .TIMLIS(n_A_25), .DYACEN(n_A_23), .CHACEN(n_A_22), .RVACEN(n_A_21), 
        .DLACEN(n_A_1Y), .DRACEN(n_A_20), .TCSEL(n_A_1P), .WST0(WST0), .TACEN(
        n_A_1R), .TCBEN(n_A_2M), .WST1(WST1), .TSOEN(n_A_0E), .TPYEN(n_A_2V), 
        .TBCL(n_A_2H), .ITPEN(n_A_0T), .WEOEN(n_A_1H), .TSBEN(n_A_2G), .TTSEN(
        n_A_2K), .TSYEN(n_A_2A), .TXEXEN(n_A_2C), .TIMLLEN(n_A_1L), .TIMLEN(
        n_A_2R), .TIMHLEN(n_A_1J), .TAIVEN(n_A_2F), .TPAEN(n_A_2P) );
  TDBMX A03 ( .WEO({n_A_321, n_A_322, n_A_323, n_A_324, n_A_325, n_A_326, 
        n_A_327, n_A_328, n_A_329, n_A_3210, n_A_3211, n_A_3212, n_A_3213, 
        n_A_3214, n_A_3215, n_A_3216, n_A_3217, n_A_3218, n_A_3219, n_A_3220}), 
        .TSO({n_A_1D1, n_A_1D2, n_A_1D3, n_A_1D4, n_A_1D5, n_A_1D6, n_A_1D7, 
        n_A_1D8, n_A_1D9, n_A_1D10, n_A_1D11, n_A_1D12, n_A_1D13, n_A_1D14, 
        n_A_1D15, n_A_1D16, n_A_1D17, n_A_1D18, n_A_1D19, n_A_1D20}), .TIMO(
        TIMO), .TACO({n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, 
        n_A_0X7, n_A_0X8, n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, 
        n_A_0X14, n_A_0X15, n_A_0X16, n_A_0X17, n_A_0X18, n_A_0X19, n_A_0X20}), 
        .TIMEXEN(n_A_0G), .TACEN(n_A_1R), .TCSEL(n_A_1P), .XRST(n_A_0R), .TE(
        n_A_07), .TC2LE(n_A_1N), .TC1LE(n_A_1M), .TIMLLEN(n_A_1L), .TI(n_A_1A), 
        .TIMLLLE(n_A_1K), .MCK(MCK), .TIMHLEN(n_A_1J), .TSOEN(n_A_0E), .WEOEN(
        n_A_1H), .TCO({n_A_1E1, n_A_1E2, n_A_1E3, n_A_1E4, n_A_1E5, n_A_1E6, 
        n_A_1E7, n_A_1E8, n_A_1E9, n_A_1E10, n_A_1E11, n_A_1E12, n_A_1E13, 
        n_A_1E14, n_A_1E15, n_A_1E16, n_A_1E17, n_A_1E18, n_A_1E19, n_A_1E20}), 
        .TDB({n_A_061, n_A_062, n_A_063, n_A_064, n_A_065, n_A_066, n_A_067, 
        n_A_068, n_A_069, n_A_0610, n_A_0611, n_A_0612, n_A_0613, n_A_0614, 
        n_A_0615, n_A_0616, n_A_0617, n_A_0618, n_A_0619, n_A_0620, n_A_0621, 
        n_A_0622, n_A_0623, n_A_0624}), .TO(n_A_29) );
  TIMCT A06 ( .TDB({n_A_061, n_A_062, n_A_063, n_A_064, n_A_065, n_A_066, 
        n_A_067, n_A_068, n_A_069, n_A_0610, n_A_0611, n_A_0612, n_A_0613, 
        n_A_0614, n_A_0615, n_A_0616, n_A_0617, n_A_0618, n_A_0619, n_A_0620, 
        n_A_0621, n_A_0622, n_A_0623, n_A_0624}), .PMD(PMD), .TIMO(TIMO), 
        .TIMEA({n_A_051, n_A_052, n_A_053, n_A_054, n_A_055, n_A_056, n_A_057, 
        n_A_058, n_A_059}), .PMA(PMA), .MCK(MCK), .TSCST(TSCST), .TI(n_A_29), 
        .XRST(n_A_0R), .TE(n_A_07), .TIMLIS(n_A_25), .TIMLWE(n_A_1B), .TLWREQ(
        TLWREQ), .TIMHWE(n_A_27), .THWREQ(THWREQ), .TPWEN(n_A_26), .ENP(n_A_04), .TIMI(TIMI), .TIMA(TIMA), .TO(n_A_38), .TLWRDY(TLWRDY), .THWRDY(THWRDY), 
        .XTIMWE(XTIMWE) );
  TSOPU A02 ( .CHLV(CHLV), .TROMO(TROMO), .TDB({n_A_061, n_A_062, n_A_063, 
        n_A_064, n_A_065, n_A_066, n_A_067, n_A_068, n_A_069, n_A_0610, 
        n_A_0611, n_A_0612, n_A_0613, n_A_0614, n_A_0615, n_A_0616, n_A_0617, 
        n_A_0618, n_A_0619, n_A_0620, n_A_0621, n_A_0622, n_A_0623, n_A_0624}), 
        .ITPD(ITPD), .TIMEXEN(n_A_0G), .ITPEN(n_A_0T), .TIMLEN(n_A_2R), .TE(
        n_A_07), .MCK(MCK), .TSYEN(n_A_2A), .TPYEN(n_A_2V), .TYLE(n_A_2W), 
        .TXLE(n_A_2U), .TI(n_A_0A), .TROMEN(n_A_2T), .TXEXEN(n_A_2C), .CHLVEN(
        n_A_2S), .TBS2EN(n_A_2D), .XRST(n_A_0R), .TCO({n_A_1E1, n_A_1E2, 
        n_A_1E3, n_A_1E4, n_A_1E5, n_A_1E6, n_A_1E7, n_A_1E8, n_A_1E9, 
        n_A_1E10, n_A_1E11, n_A_1E12, n_A_1E13, n_A_1E14, n_A_1E15, n_A_1E16, 
        n_A_1E17, n_A_1E18, n_A_1E19, n_A_1E20}), .TBCL(n_A_2H), .TSBEN(n_A_2G), .TPAEN(n_A_2P), .TALE(n_A_2E), .TAIVEN(n_A_2F), .TBLE(n_A_2N), .TCBEN(n_A_2M), .TTLE(n_A_2J), .TTSEN(n_A_2K), .TSO({n_A_1D1, n_A_1D2, n_A_1D3, n_A_1D4, 
        n_A_1D5, n_A_1D6, n_A_1D7, n_A_1D8, n_A_1D9, n_A_1D10, n_A_1D11, 
        n_A_1D12, n_A_1D13, n_A_1D14, n_A_1D15, n_A_1D16, n_A_1D17, n_A_1D18, 
        n_A_1D19, n_A_1D20}), .TO(n_A_1G) );
  TWEXP A01 ( .TIMO(TIMO[19:0]), .SLWD(SLWD), .XRST(n_A_0R), .TE(n_A_07), 
        .WESAEN(n_A_15), .MCK(MCK), .TI(n_A_1G), .WEABLE(n_A_13), .WEO({
        n_A_321, n_A_322, n_A_323, n_A_324, n_A_325, n_A_326, n_A_327, n_A_328, 
        n_A_329, n_A_3210, n_A_3211, n_A_3212, n_A_3213, n_A_3214, n_A_3215, 
        n_A_3216, n_A_3217, n_A_3218, n_A_3219, n_A_3220}), .TO(n_A_1A) );
  TROMIF A07 ( .PLACB({n_A_121, n_A_122, n_A_123, n_A_124, n_A_125, n_A_126, 
        n_A_127, n_A_128, n_A_129}), .EROMA(EROMA), .EROMAS(EROMAS), .TROMA(
        TROMA) );
  BUFX4 A1A ( .A(XRST), .Y(n_A_0R) );
  BUFX4 A19 ( .A(TE), .Y(n_A_07) );
  BUFX2 A0C ( .A(ENP), .Y(n_A_04) );
endmodule


module TROMIF ( PLACB, EROMA, EROMAS, TROMA );
  input [8:0] PLACB;
  input [8:0] EROMA;
  output [8:0] TROMA;
  input EROMAS;


  DS092 A01 ( .A(PLACB), .B(EROMA), .S(EROMAS), .Y(TROMA) );
endmodule


module TWEXP ( TIMO, SLWD, XRST, TE, WESAEN, MCK, TI, WEABLE, WEO, TO );
  input [19:0] TIMO;
  input [19:0] SLWD;
  output [19:0] WEO;
  input XRST, TE, WESAEN, MCK, TI, WEABLE;
  output TO;
  wire   n_A_07, n_A_0A, n_A_04, n_A_0E1, n_A_0E2, n_A_0E3, n_A_0E4, n_A_0E5,
         n_A_0E6, n_A_0E7, n_A_0E8, n_A_0E9, n_A_0E10, n_A_0E11, n_A_0E12,
         n_A_0E13, n_A_0E14, n_A_0E15, n_A_0E16, n_A_0E17, n_A_0E18, n_A_0E19,
         n_A_0E20, n_A_0G1, n_A_0G2, n_A_0G3, n_A_0G4, n_A_0G5, n_A_0G6,
         n_A_0G7, n_A_0G8, n_A_0G9, n_A_0G10, n_A_0G11, n_A_0G12, n_A_0G13,
         n_A_0G14, n_A_0G15, n_A_0G16, n_A_0G17, n_A_0G18, n_A_0G19, n_A_0G20,
         n_A_0F1, n_A_0F2, n_A_0F3, n_A_0F4, n_A_0F5, n_A_0F6, n_A_0F7,
         n_A_0F8, n_A_0F9, n_A_0F10, n_A_0F11, n_A_0F12, n_A_0F13, n_A_0F14,
         n_A_0F15, n_A_0F16, n_A_0F17, n_A_0F18, n_A_0F19, n_A_0F20;

  FE20R A01 ( .D({n_A_0E1, n_A_0E2, n_A_0E3, n_A_0E4, n_A_0E5, n_A_0E6, 
        n_A_0E7, n_A_0E8, n_A_0E9, n_A_0E10, n_A_0E11, n_A_0E12, n_A_0E13, 
        n_A_0E14, n_A_0E15, n_A_0E16, n_A_0E17, n_A_0E18, n_A_0E19, n_A_0E20}), 
        .TI(TI), .RN(n_A_07), .TE(n_A_0A), .CK(MCK), .EN(WEABLE), .Q({n_A_0G1, 
        n_A_0G2, n_A_0G3, n_A_0G4, n_A_0G5, n_A_0G6, n_A_0G7, n_A_0G8, n_A_0G9, 
        n_A_0G10, n_A_0G11, n_A_0G12, n_A_0G13, n_A_0G14, n_A_0G15, n_A_0G16, 
        n_A_0G17, n_A_0G18, n_A_0G19, n_A_0G20}), .TO(n_A_04) );
  FE20R A02 ( .D(SLWD), .TI(n_A_04), .RN(n_A_07), .TE(n_A_0A), .CK(MCK), .EN(
        WEABLE), .Q({n_A_0F1, n_A_0F2, n_A_0F3, n_A_0F4, n_A_0F5, n_A_0F6, 
        n_A_0F7, n_A_0F8, n_A_0F9, n_A_0F10, n_A_0F11, n_A_0F12, n_A_0F13, 
        n_A_0F14, n_A_0F15, n_A_0F16, n_A_0F17, n_A_0F18, n_A_0F19, n_A_0F20}), 
        .TO(TO) );
  DS202 A04 ( .A(TIMO), .B(WEO), .S(WESAEN), .Y({n_A_0E1, n_A_0E2, n_A_0E3, 
        n_A_0E4, n_A_0E5, n_A_0E6, n_A_0E7, n_A_0E8, n_A_0E9, n_A_0E10, 
        n_A_0E11, n_A_0E12, n_A_0E13, n_A_0E14, n_A_0E15, n_A_0E16, n_A_0E17, 
        n_A_0E18, n_A_0E19, n_A_0E20}) );
  ADD20 A03 ( .A({n_A_0G1, n_A_0G2, n_A_0G3, n_A_0G4, n_A_0G5, n_A_0G6, 
        n_A_0G7, n_A_0G8, n_A_0G9, n_A_0G10, n_A_0G11, n_A_0G12, n_A_0G13, 
        n_A_0G14, n_A_0G15, n_A_0G16, n_A_0G17, n_A_0G18, n_A_0G19, n_A_0G20}), 
        .B({n_A_0F1, n_A_0F2, n_A_0F3, n_A_0F4, n_A_0F5, n_A_0F6, n_A_0F7, 
        n_A_0F8, n_A_0F9, n_A_0F10, n_A_0F11, n_A_0F12, n_A_0F13, n_A_0F14, 
        n_A_0F15, n_A_0F16, n_A_0F17, n_A_0F18, n_A_0F19, n_A_0F20}), .S(WEO)
         );
  BUFX2 A0F ( .A(XRST), .Y(n_A_07) );
  BUFX2 A0E ( .A(TE), .Y(n_A_0A) );
endmodule


module TSOPU ( CHLV, TROMO, TDB, ITPD, TIMEXEN, ITPEN, TIMLEN, TE, MCK, TSYEN, 
        TPYEN, TYLE, TXLE, TI, TROMEN, TXEXEN, CHLVEN, TBS2EN, XRST, TCO, TBCL, 
        TSBEN, TPAEN, TALE, TAIVEN, TBLE, TCBEN, TTLE, TTSEN, TSO, TO );
  input [2:0] CHLV;
  input [7:0] TROMO;
  input [23:0] TDB;
  input [7:0] ITPD;
  input [19:0] TCO;
  output [19:0] TSO;
  input TIMEXEN, ITPEN, TIMLEN, TE, MCK, TSYEN, TPYEN, TYLE, TXLE, TI, TROMEN,
         TXEXEN, CHLVEN, TBS2EN, XRST, TBCL, TSBEN, TPAEN, TALE, TAIVEN, TBLE,
         TCBEN, TTLE, TTSEN;
  output TO;
  wire   n_ITPD8, n_A_124, n_A_1X, n_A_1E4, n_A_123, n_A_1E3, n_A_122, n_A_1E2,
         n_TDBA19, n_TDBA18, n_TDBA17, n_TDBA16, n_TDBA15, n_TDBA14, n_TDBA13,
         n_TDBA12, n_TDBA11, n_TDBA10, n_TDBA09, n_TDBA08, n_TDBA07, n_TDBA06,
         n_TDBA05, n_TDBA04, n_TDBA03, n_TDBA02, n_TDBA01, n_TDBA00, n_TDBB19,
         n_TDBB18, n_TDBB17, n_TDBB16, n_TDBB15, n_TDBB14, n_TDBB13, n_TDBB12,
         n_TDBB11, n_TDBB10, n_TDBB09, n_TDBB08, n_TDBB07, n_TDBB06, n_TDBB05,
         n_TDBB04, n_TDBB03, n_TDBB02, n_TDBB01, n_TDBB00, n_TO1, n_PA22,
         n_PA21, n_PA20, n_PA19, n_PA18, n_PA17, n_PA16, n_PA15, n_PA14,
         n_PA13, n_PA12, n_PA11, n_PA10, n_PA09, n_PA08, n_PA07, n_PA06,
         n_PA05, n_PA04, n_PA03, n_PA02, n_PA01, n_PA00, n_A_0X1, n_A_0X2,
         n_A_0X3, n_A_0X4, n_TPO19, n_TPO18, n_TPO17, n_TPO16, n_TPO15,
         n_TPO14, n_TPO13, n_TPO12, n_TPO11, n_TPO10, n_TPO09, n_TPO08,
         n_TPO07, n_TPO06, n_TPO05, n_TPO04, n_TPO03, n_TPO02, n_TPO01,
         n_TPO00, n_CHLV3, n_A_121, n_A_1E1, n_ITPD9, n_TRO9, n_TRO0, n_A_101,
         n_A_102, n_A_103, n_A_104, n_A_105, n_A_106, n_A_107, n_A_108,
         n_A_109, n_A_1010, n_A_0T, n_A_21, n_A_18, n_A_1B1, n_A_1B2, n_A_1B3,
         n_A_1B4, n_A_1B5, n_A_1B6, n_A_1B7, n_A_1B8, n_A_1B9, n_A_1B10,
         n_A_1B11, n_A_1B12, n_A_1B13, n_A_1B14, n_A_1B15, n_A_1B16, n_A_1N1,
         n_A_1N2, n_A_1N3, n_A_1N4, n_A_1N5, n_A_1N6, n_A_1N7, n_A_1N8,
         n_A_1N9, n_A_1N10, n_A_1N11, n_A_1N12, n_A_1N13, n_A_1N14, n_A_1N15,
         n_A_1N16, n_XIB9, n_A_1L1, n_A_1L2, n_A_1L3, n_A_1L4, n_A_16, n_A_17,
         n_A_1H1, n_A_1H2, n_A_1H3, n_A_1H4, n_A_1H5, n_A_1H6, n_A_1H7,
         n_A_1H8, n_A_1H9, n_A_1H10, n_A_1P1, n_A_1P2, n_A_1P3, n_A_1P4,
         n_A_1P5, n_A_1P6, n_A_1P7, n_A_1P8, n_A_1P9, n_A_1P10, n_XIB8, n_XIB7,
         n_XIB6, n_XIB5, n_XIB4, n_XIB3, n_XIB2, n_XIB1, n_XIB0, n_TSTO19,
         n_TSTO18, n_TSTO17, n_TSTO16, n_TSTO15, n_TSTO14, n_TSTO13, n_TSTO12,
         n_TSTO11, n_TSTO10, n_TSTO09, n_TSTO08, n_TSTO07, n_TSTO06, n_TSTO05,
         n_TSTO04, n_B_1920, n_B_0H, n_B_0320, n_B_1919, n_B_0319, n_B_1918,
         n_B_0318, n_B_1917, n_B_0317, n_B_1916, n_B_0316, n_B_1915, n_B_0315,
         n_B_1914, n_B_0314, n_B_1913, n_B_0313, n_B_1912, n_B_0312, n_B_1911,
         n_B_0311, n_B_1910, n_B_0310, n_B_199, n_B_039, n_B_198, n_B_038,
         n_B_197, n_B_037, n_B_196, n_B_036, n_B_195, n_B_035, n_B_194,
         n_B_034, n_B_193, n_B_033, n_B_192, n_B_032, n_B_0J, n_B_0A, n_B_0V,
         n_B_0P, n_B_151, n_B_152, n_B_153, n_B_154, n_B_155, n_B_156, n_B_157,
         n_B_158, n_B_159, n_B_1510, n_B_1511, n_B_1512, n_B_1513, n_B_1514,
         n_B_1515, n_B_1516, n_B_1517, n_B_1518, n_B_1519, n_B_1520, n_B_171,
         n_B_172, n_B_173, n_B_174, n_B_175, n_B_176, n_B_177, n_B_178,
         n_B_179, n_B_1710, n_B_1711, n_B_1712, n_B_1713, n_B_1714, n_B_1715,
         n_B_1716, n_B_1717, n_B_1718, n_B_1719, n_B_1720, n_TAAI19, n_TAAI18,
         n_TAAI17, n_TAAI16, n_TAAI15, n_TAAI14, n_TAAI13, n_TAAI12, n_TAAI11,
         n_TAAI10, n_TAAI09, n_TAAI08, n_TAAI07, n_TAAI06, n_TAAI05, n_TAAI04,
         n_TAAI03, n_TAAI02, n_TAAI01, n_TAAI00, n_B_191, n_B_031, n_B_1A1,
         n_B_1A2, n_B_1A3, n_B_1A4, n_B_1A5, n_B_1A6, n_B_1A7, n_B_1A8,
         n_B_1A9, n_B_1A10, n_B_1A11, n_B_1A12, n_B_1A13, n_B_1A14, n_B_1A15,
         n_B_1A16, n_B_1A17, n_B_1A18, n_B_1A19, n_B_1A20, n_TSTO03, n_TSTO02,
         n_TSTO01, n_TSTO00, n_B_0T, n_TABI19, n_TSD19, n_B_14, n_B_13,
         n_TSD18, n_TSD17, n_TSD16, n_TSD15, n_TSD14, n_TSD13, n_TSD12,
         n_TSD11, n_TSD10, n_TSD09, n_TSD08, n_TSD07, n_TSD06, n_TSD05,
         n_TSD04, n_TSD03, n_TSD02, n_TSD01, n_TSD00, n_TABI18, n_TABI17,
         n_TABI16, n_TABI15, n_TABI14, n_TABI13, n_TABI12, n_TABI11, n_TABI10,
         n_TABI09, n_TABI08, n_TABI07, n_TABI06, n_TABI05, n_TABI04, n_TABI03,
         n_TABI02, n_TABI01, n_TABI00;

  TIELO A260 ( .Y(n_ITPD8) );
  OR2X1 A280 ( .A(n_A_124), .B(n_A_1X), .Y(n_A_1E4) );
  OR2X1 A281 ( .A(n_A_123), .B(n_A_1X), .Y(n_A_1E3) );
  OR2X1 A282 ( .A(n_A_122), .B(n_A_1X), .Y(n_A_1E2) );
  DSH12 A1S ( .D(TDB), .S(TIMEXEN), .Y({n_TDBA19, n_TDBA18, n_TDBA17, n_TDBA16, 
        n_TDBA15, n_TDBA14, n_TDBA13, n_TDBA12, n_TDBA11, n_TDBA10, n_TDBA09, 
        n_TDBA08, n_TDBA07, n_TDBA06, n_TDBA05, n_TDBA04, n_TDBA03, n_TDBA02, 
        n_TDBA01, n_TDBA00}) );
  DSL20 A1F ( .A(TDB[19:0]), .S(TIMLEN), .Y({n_TDBB19, n_TDBB18, n_TDBB17, 
        n_TDBB16, n_TDBB15, n_TDBB14, n_TDBB13, n_TDBB12, n_TDBB11, n_TDBB10, 
        n_TDBB09, n_TDBB08, n_TDBB07, n_TDBB06, n_TDBB05, n_TDBB04, n_TDBB03, 
        n_TDBB02, n_TDBB01, n_TDBB00}) );
  BS205L A01 ( .D({n_PA22, n_PA21, n_PA20, n_PA19, n_PA18, n_PA17, n_PA16, 
        n_PA15, n_PA14, n_PA13, n_PA12, n_PA11, n_PA10, n_PA09, n_PA08, n_PA07, 
        n_PA06, n_PA05, n_PA04, n_PA03, n_PA02, n_PA01, n_PA00}), .SFT({
        n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4}), .U4SFT(n_TO1), .Y({n_TPO19, 
        n_TPO18, n_TPO17, n_TPO16, n_TPO15, n_TPO14, n_TPO13, n_TPO12, n_TPO11, 
        n_TPO10, n_TPO09, n_TPO08, n_TPO07, n_TPO06, n_TPO05, n_TPO04, n_TPO03, 
        n_TPO02, n_TPO01, n_TPO00}) );
  TIEHI A21 ( .Y(n_CHLV3) );
  MSIV A2B ( .A({n_TDBB11, n_TDBB10, n_TDBB09, n_TDBB08}), .Y({n_A_121, 
        n_A_122, n_A_123, n_A_124}) );
  OR2X1 A283 ( .A(n_A_121), .B(n_A_1X), .Y(n_A_1E1) );
  INVX1 A2A ( .A(TXEXEN), .Y(n_A_1X) );
  TIELO A261 ( .Y(n_ITPD9) );
  DS103 A15 ( .B({n_ITPD9, n_ITPD8, ITPD}), .A({n_TDBB19, n_TDBB18, n_TDBB17, 
        n_TDBB16, n_TDBB15, n_TDBB14, n_TDBB13, n_TDBB12, n_TDBB11, n_TDBB10}), 
        .C({n_TRO9, TROMO, n_TRO0}), .S2(TROMEN), .S1(ITPEN), .Y({n_A_101, 
        n_A_102, n_A_103, n_A_104, n_A_105, n_A_106, n_A_107, n_A_108, n_A_109, 
        n_A_1010}) );
  TIELO A1Y ( .Y(n_TRO0) );
  TIELO A1X ( .Y(n_TRO9) );
  FE16R A03 ( .D({n_A_1B1, n_A_1B2, n_A_1B3, n_A_1B4, n_A_1B5, n_A_1B6, 
        n_A_1B7, n_A_1B8, n_A_1B9, n_A_1B10, n_A_1B11, n_A_1B12, n_A_1B13, 
        n_A_1B14, n_A_1B15, n_A_1B16}), .TI(TI), .RN(n_A_21), .TE(n_A_0T), 
        .CK(MCK), .EN(TYLE), .Q({n_A_1N1, n_A_1N2, n_A_1N3, n_A_1N4, n_A_1N5, 
        n_A_1N6, n_A_1N7, n_A_1N8, n_A_1N9, n_A_1N10, n_A_1N11, n_A_1N12, 
        n_A_1N13, n_A_1N14, n_A_1N15, n_A_1N16}), .TO(n_A_18) );
  BUFX2 A0W ( .A(XRST), .Y(n_A_21) );
  BUFX2 A0V ( .A(TE), .Y(n_A_0T) );
  TIELO A0G ( .Y(n_XIB9) );
  DS042 A0A ( .A({n_A_1E1, n_A_1E2, n_A_1E3, n_A_1E4}), .B({n_CHLV3, CHLV}), 
        .S(CHLVEN), .Y({n_A_1L1, n_A_1L2, n_A_1L3, n_A_1L4}) );
  FE1R A09 ( .RN(n_A_21), .TE(n_A_0T), .TI(n_A_16), .CK(MCK), .EN(TXLE), .D(
        TBS2EN), .Q(n_TO1) );
  FE04S A08 ( .D({n_A_1L1, n_A_1L2, n_A_1L3, n_A_1L4}), .SN(n_A_21), .TE(
        n_A_0T), .CK(MCK), .EN(TXLE), .TI(n_A_17), .Q({n_A_0X1, n_A_0X2, 
        n_A_0X3, n_A_0X4}), .TO(n_A_16) );
  FE10R A05 ( .D({n_A_1H1, n_A_1H2, n_A_1H3, n_A_1H4, n_A_1H5, n_A_1H6, 
        n_A_1H7, n_A_1H8, n_A_1H9, n_A_1H10}), .TI(n_A_18), .RN(n_A_21), .TE(
        n_A_0T), .CK(MCK), .EN(TXLE), .Q({n_A_1P1, n_A_1P2, n_A_1P3, n_A_1P4, 
        n_A_1P5, n_A_1P6, n_A_1P7, n_A_1P8, n_A_1P9, n_A_1P10}), .TO(n_A_17)
         );
  EXPCNV A07 ( .A({n_TDBB07, n_TDBB06, n_TDBB05, n_TDBB04, n_TDBB03, n_TDBB02, 
        n_TDBB01, n_TDBB00}), .Y({n_XIB8, n_XIB7, n_XIB6, n_XIB5, n_XIB4, 
        n_XIB3, n_XIB2, n_XIB1, n_XIB0}) );
  DS102 A06 ( .A({n_A_101, n_A_102, n_A_103, n_A_104, n_A_105, n_A_106, 
        n_A_107, n_A_108, n_A_109, n_A_1010}), .B({n_XIB9, n_XIB8, n_XIB7, 
        n_XIB6, n_XIB5, n_XIB4, n_XIB3, n_XIB2, n_XIB1, n_XIB0}), .S(TXEXEN), 
        .Y({n_A_1H1, n_A_1H2, n_A_1H3, n_A_1H4, n_A_1H5, n_A_1H6, n_A_1H7, 
        n_A_1H8, n_A_1H9, n_A_1H10}) );
  DS163 A04 ( .B({n_TSTO19, n_TSTO18, n_TSTO17, n_TSTO16, n_TSTO15, n_TSTO14, 
        n_TSTO13, n_TSTO12, n_TSTO11, n_TSTO10, n_TSTO09, n_TSTO08, n_TSTO07, 
        n_TSTO06, n_TSTO05, n_TSTO04}), .A({n_TDBB19, n_TDBB18, n_TDBB17, 
        n_TDBB16, n_TDBB15, n_TDBB14, n_TDBB13, n_TDBB12, n_TDBB11, n_TDBB10, 
        n_TDBB09, n_TDBB08, n_TDBB07, n_TDBB06, n_TDBB05, n_TDBB04}), .C({
        n_TPO19, n_TPO18, n_TPO17, n_TPO16, n_TPO15, n_TPO14, n_TPO13, n_TPO12, 
        n_TPO11, n_TPO10, n_TPO09, n_TPO08, n_TPO07, n_TPO06, n_TPO05, n_TPO04}), .S2(TPYEN), .S1(TSYEN), .Y({n_A_1B1, n_A_1B2, n_A_1B3, n_A_1B4, n_A_1B5, 
        n_A_1B6, n_A_1B7, n_A_1B8, n_A_1B9, n_A_1B10, n_A_1B11, n_A_1B12, 
        n_A_1B13, n_A_1B14, n_A_1B15, n_A_1B16}) );
  MLT02 A02 ( .A({n_A_1N1, n_A_1N2, n_A_1N3, n_A_1N4, n_A_1N5, n_A_1N6, 
        n_A_1N7, n_A_1N8, n_A_1N9, n_A_1N10, n_A_1N11, n_A_1N12, n_A_1N13, 
        n_A_1N14, n_A_1N15, n_A_1N16}), .B({n_A_1P1, n_A_1P2, n_A_1P3, n_A_1P4, 
        n_A_1P5, n_A_1P6, n_A_1P7, n_A_1P8, n_A_1P9, n_A_1P10}), .P({n_PA21, 
        n_PA20, n_PA19, n_PA18, n_PA17, n_PA16, n_PA15, n_PA14, n_PA13, n_PA12, 
        n_PA11, n_PA10, n_PA09, n_PA08, n_PA07, n_PA06, n_PA05, n_PA04, n_PA03, 
        n_PA02, n_PA01, n_PA00}), .P25(n_PA22) );
  AND2X1 B200 ( .A(n_B_1920), .B(n_B_0H), .Y(n_B_0320) );
  AND2X1 B201 ( .A(n_B_1919), .B(n_B_0H), .Y(n_B_0319) );
  AND2X1 B202 ( .A(n_B_1918), .B(n_B_0H), .Y(n_B_0318) );
  AND2X1 B203 ( .A(n_B_1917), .B(n_B_0H), .Y(n_B_0317) );
  AND2X1 B204 ( .A(n_B_1916), .B(n_B_0H), .Y(n_B_0316) );
  AND2X1 B205 ( .A(n_B_1915), .B(n_B_0H), .Y(n_B_0315) );
  AND2X1 B206 ( .A(n_B_1914), .B(n_B_0H), .Y(n_B_0314) );
  AND2X1 B207 ( .A(n_B_1913), .B(n_B_0H), .Y(n_B_0313) );
  AND2X1 B208 ( .A(n_B_1912), .B(n_B_0H), .Y(n_B_0312) );
  AND2X1 B209 ( .A(n_B_1911), .B(n_B_0H), .Y(n_B_0311) );
  AND2X1 B210 ( .A(n_B_1910), .B(n_B_0H), .Y(n_B_0310) );
  AND2X1 B211 ( .A(n_B_199), .B(n_B_0H), .Y(n_B_039) );
  AND2X1 B212 ( .A(n_B_198), .B(n_B_0H), .Y(n_B_038) );
  AND2X1 B213 ( .A(n_B_197), .B(n_B_0H), .Y(n_B_037) );
  AND2X1 B214 ( .A(n_B_196), .B(n_B_0H), .Y(n_B_036) );
  AND2X1 B215 ( .A(n_B_195), .B(n_B_0H), .Y(n_B_035) );
  AND2X1 B216 ( .A(n_B_194), .B(n_B_0H), .Y(n_B_034) );
  AND2X1 B217 ( .A(n_B_193), .B(n_B_0H), .Y(n_B_033) );
  AND2X1 B218 ( .A(n_B_192), .B(n_B_0H), .Y(n_B_032) );
  TIEHI B09 ( .Y(n_B_0J) );
  FE21R B0A ( .D({n_B_151, n_B_152, n_B_153, n_B_154, n_B_155, n_B_156, 
        n_B_157, n_B_158, n_B_159, n_B_1510, n_B_1511, n_B_1512, n_B_1513, 
        n_B_1514, n_B_1515, n_B_1516, n_B_1517, n_B_1518, n_B_1519, n_B_1520}), 
        .D20(TAIVEN), .TI(n_TO1), .RN(XRST), .TE(n_B_0A), .CK(MCK), .EN(TALE), 
        .Q({n_B_171, n_B_172, n_B_173, n_B_174, n_B_175, n_B_176, n_B_177, 
        n_B_178, n_B_179, n_B_1710, n_B_1711, n_B_1712, n_B_1713, n_B_1714, 
        n_B_1715, n_B_1716, n_B_1717, n_B_1718, n_B_1719, n_B_1720}), .Q20(
        n_B_0V), .TO(n_B_0P) );
  INV20 B0B ( .A({n_B_171, n_B_172, n_B_173, n_B_174, n_B_175, n_B_176, 
        n_B_177, n_B_178, n_B_179, n_B_1710, n_B_1711, n_B_1712, n_B_1713, 
        n_B_1714, n_B_1715, n_B_1716, n_B_1717, n_B_1718, n_B_1719, n_B_1720}), 
        .INV(n_B_0V), .Y({n_TAAI19, n_TAAI18, n_TAAI17, n_TAAI16, n_TAAI15, 
        n_TAAI14, n_TAAI13, n_TAAI12, n_TAAI11, n_TAAI10, n_TAAI09, n_TAAI08, 
        n_TAAI07, n_TAAI06, n_TAAI05, n_TAAI04, n_TAAI03, n_TAAI02, n_TAAI01, 
        n_TAAI00}) );
  INVX4 B1F ( .A(TBCL), .Y(n_B_0H) );
  AND2X1 B219 ( .A(n_B_191), .B(n_B_0H), .Y(n_B_031) );
  DS202 B04 ( .A({n_TDBA19, n_TDBA18, n_TDBA17, n_TDBA16, n_TDBA15, n_TDBA14, 
        n_TDBA13, n_TDBA12, n_TDBA11, n_TDBA10, n_TDBA09, n_TDBA08, n_TDBA07, 
        n_TDBA06, n_TDBA05, n_TDBA04, n_TDBA03, n_TDBA02, n_TDBA01, n_TDBA00}), 
        .B({n_TPO19, n_TPO18, n_TPO17, n_TPO16, n_TPO15, n_TPO14, n_TPO13, 
        n_TPO12, n_TPO11, n_TPO10, n_TPO09, n_TPO08, n_TPO07, n_TPO06, n_TPO05, 
        n_TPO04, n_TPO03, n_TPO02, n_TPO01, n_TPO00}), .S(TPAEN), .Y({n_B_151, 
        n_B_152, n_B_153, n_B_154, n_B_155, n_B_156, n_B_157, n_B_158, n_B_159, 
        n_B_1510, n_B_1511, n_B_1512, n_B_1513, n_B_1514, n_B_1515, n_B_1516, 
        n_B_1517, n_B_1518, n_B_1519, n_B_1520}) );
  BUFX2 B17 ( .A(TE), .Y(n_B_0A) );
  DS202 B0G ( .A(TSO), .B({n_B_1A1, n_B_1A2, n_B_1A3, n_B_1A4, n_B_1A5, 
        n_B_1A6, n_B_1A7, n_B_1A8, n_B_1A9, n_B_1A10, n_B_1A11, n_B_1A12, 
        n_B_1A13, n_B_1A14, n_B_1A15, n_B_1A16, n_B_1A17, n_B_1A18, n_B_1A19, 
        n_B_1A20}), .S(TTSEN), .Y({n_TSTO19, n_TSTO18, n_TSTO17, n_TSTO16, 
        n_TSTO15, n_TSTO14, n_TSTO13, n_TSTO12, n_TSTO11, n_TSTO10, n_TSTO09, 
        n_TSTO08, n_TSTO07, n_TSTO06, n_TSTO05, n_TSTO04, n_TSTO03, n_TSTO02, 
        n_TSTO01, n_TSTO00}) );
  FE20R B0F ( .D(TSO), .TI(n_B_0T), .RN(XRST), .TE(n_B_0A), .CK(MCK), .EN(TTLE), .Q({n_B_1A1, n_B_1A2, n_B_1A3, n_B_1A4, n_B_1A5, n_B_1A6, n_B_1A7, n_B_1A8, 
        n_B_1A9, n_B_1A10, n_B_1A11, n_B_1A12, n_B_1A13, n_B_1A14, n_B_1A15, 
        n_B_1A16, n_B_1A17, n_B_1A18, n_B_1A19, n_B_1A20}), .TO(TO) );
  LMCNT B08 ( .C(n_TSD19), .B(n_TABI19), .A(n_TAAI19), .EN(n_B_0J), .SG(n_B_14), .S(n_B_13) );
  LM20 B07 ( .A({n_TSD19, n_TSD18, n_TSD17, n_TSD16, n_TSD15, n_TSD14, n_TSD13, 
        n_TSD12, n_TSD11, n_TSD10, n_TSD09, n_TSD08, n_TSD07, n_TSD06, n_TSD05, 
        n_TSD04, n_TSD03, n_TSD02, n_TSD01, n_TSD00}), .S(n_B_13), .SG(n_B_14), 
        .Y(TSO) );
  DS203 B05 ( .B({n_TSTO19, n_TSTO18, n_TSTO17, n_TSTO16, n_TSTO15, n_TSTO14, 
        n_TSTO13, n_TSTO12, n_TSTO11, n_TSTO10, n_TSTO09, n_TSTO08, n_TSTO07, 
        n_TSTO06, n_TSTO05, n_TSTO04, n_TSTO03, n_TSTO02, n_TSTO01, n_TSTO00}), 
        .A({n_TDBB19, n_TDBB18, n_TDBB17, n_TDBB16, n_TDBB15, n_TDBB14, 
        n_TDBB13, n_TDBB12, n_TDBB11, n_TDBB10, n_TDBB09, n_TDBB08, n_TDBB07, 
        n_TDBB06, n_TDBB05, n_TDBB04, n_TDBB03, n_TDBB02, n_TDBB01, n_TDBB00}), 
        .C(TCO), .S2(TCBEN), .S1(TSBEN), .Y({n_B_191, n_B_192, n_B_193, 
        n_B_194, n_B_195, n_B_196, n_B_197, n_B_198, n_B_199, n_B_1910, 
        n_B_1911, n_B_1912, n_B_1913, n_B_1914, n_B_1915, n_B_1916, n_B_1917, 
        n_B_1918, n_B_1919, n_B_1920}) );
  FE20R B03 ( .D({n_B_031, n_B_032, n_B_033, n_B_034, n_B_035, n_B_036, 
        n_B_037, n_B_038, n_B_039, n_B_0310, n_B_0311, n_B_0312, n_B_0313, 
        n_B_0314, n_B_0315, n_B_0316, n_B_0317, n_B_0318, n_B_0319, n_B_0320}), 
        .TI(n_B_0P), .RN(XRST), .TE(n_B_0A), .CK(MCK), .EN(TBLE), .Q({n_TABI19, 
        n_TABI18, n_TABI17, n_TABI16, n_TABI15, n_TABI14, n_TABI13, n_TABI12, 
        n_TABI11, n_TABI10, n_TABI09, n_TABI08, n_TABI07, n_TABI06, n_TABI05, 
        n_TABI04, n_TABI03, n_TABI02, n_TABI01, n_TABI00}), .TO(n_B_0T) );
  ADD20C B01 ( .A({n_TAAI19, n_TAAI18, n_TAAI17, n_TAAI16, n_TAAI15, n_TAAI14, 
        n_TAAI13, n_TAAI12, n_TAAI11, n_TAAI10, n_TAAI09, n_TAAI08, n_TAAI07, 
        n_TAAI06, n_TAAI05, n_TAAI04, n_TAAI03, n_TAAI02, n_TAAI01, n_TAAI00}), 
        .B({n_TABI19, n_TABI18, n_TABI17, n_TABI16, n_TABI15, n_TABI14, 
        n_TABI13, n_TABI12, n_TABI11, n_TABI10, n_TABI09, n_TABI08, n_TABI07, 
        n_TABI06, n_TABI05, n_TABI04, n_TABI03, n_TABI02, n_TABI01, n_TABI00}), 
        .CI(n_B_0V), .S({n_TSD19, n_TSD18, n_TSD17, n_TSD16, n_TSD15, n_TSD14, 
        n_TSD13, n_TSD12, n_TSD11, n_TSD10, n_TSD09, n_TSD08, n_TSD07, n_TSD06, 
        n_TSD05, n_TSD04, n_TSD03, n_TSD02, n_TSD01, n_TSD00}) );
endmodule


module ADD20C ( A, B, CI, S, CO );
  input [19:0] A;
  input [19:0] B;
  output [19:0] S;
  input CI;
  output CO;
  wire   n_A_071, n_A_072, n_A_073, n_A_074, n_A_075, n_A_076, n_A_077,
         n_A_078, n_A_079, n_A_0710, n_A_0711, n_A_0712, n_A_0713, n_A_0714,
         n_A_0715, n_A_0716, n_A_0717, n_A_0718, n_A_0719, n_A_0720, n_A_061,
         n_A_062, n_A_063, n_A_064, n_A_065, n_A_066, n_A_067, n_A_068,
         n_A_069, n_A_0610, n_A_0611, n_A_0612, n_A_0613, n_A_0614, n_A_0615,
         n_A_0616, n_A_0617, n_A_0618, n_A_0619, n_A_0620;

  CS20 A002 ( .PN({n_A_061, n_A_062, n_A_063, n_A_064, n_A_065, n_A_066, 
        n_A_067, n_A_068, n_A_069, n_A_0610, n_A_0611, n_A_0612, n_A_0613, 
        n_A_0614, n_A_0615, n_A_0616, n_A_0617, n_A_0618, n_A_0619, n_A_0620}), 
        .GN({n_A_071, n_A_072, n_A_073, n_A_074, n_A_075, n_A_076, n_A_077, 
        n_A_078, n_A_079, n_A_0710, n_A_0711, n_A_0712, n_A_0713, n_A_0714, 
        n_A_0715, n_A_0716, n_A_0717, n_A_0718, n_A_0719, n_A_0720}), .S(S), 
        .CO(CO) );
  PG20C A001 ( .A(A), .B(B), .CI(CI), .GN({n_A_071, n_A_072, n_A_073, n_A_074, 
        n_A_075, n_A_076, n_A_077, n_A_078, n_A_079, n_A_0710, n_A_0711, 
        n_A_0712, n_A_0713, n_A_0714, n_A_0715, n_A_0716, n_A_0717, n_A_0718, 
        n_A_0719, n_A_0720}), .PN({n_A_061, n_A_062, n_A_063, n_A_064, n_A_065, 
        n_A_066, n_A_067, n_A_068, n_A_069, n_A_0610, n_A_0611, n_A_0612, 
        n_A_0613, n_A_0614, n_A_0615, n_A_0616, n_A_0617, n_A_0618, n_A_0619, 
        n_A_0620}) );
endmodule


module PG20C ( A, B, CI, GN, PN );
  input [19:0] A;
  input [19:0] B;
  output [19:0] GN;
  output [19:0] PN;
  input CI;


  AOI222X2 A00S ( .A0(A[0]), .A1(B[0]), .B0(A[0]), .B1(CI), .C0(B[0]), .C1(CI), 
        .Y(GN[0]) );
  NAND2X2 A01C ( .A(A[19]), .B(B[19]), .Y(GN[19]) );
  NAND2X2 A01B ( .A(A[18]), .B(B[18]), .Y(GN[18]) );
  NAND2X2 A01A ( .A(A[17]), .B(B[17]), .Y(GN[17]) );
  NAND2X2 A019 ( .A(A[16]), .B(B[16]), .Y(GN[16]) );
  NAND2X2 A018 ( .A(A[15]), .B(B[15]), .Y(GN[15]) );
  NAND2X2 A017 ( .A(A[14]), .B(B[14]), .Y(GN[14]) );
  NAND2X2 A016 ( .A(A[13]), .B(B[13]), .Y(GN[13]) );
  NAND2X2 A015 ( .A(A[12]), .B(B[12]), .Y(GN[12]) );
  NAND2X2 A014 ( .A(A[11]), .B(B[11]), .Y(GN[11]) );
  NAND2X2 A013 ( .A(A[10]), .B(B[10]), .Y(GN[10]) );
  NAND2X2 A012 ( .A(A[9]), .B(B[9]), .Y(GN[9]) );
  NAND2X2 A011 ( .A(A[8]), .B(B[8]), .Y(GN[8]) );
  NAND2X2 A010 ( .A(A[7]), .B(B[7]), .Y(GN[7]) );
  NAND2X2 A00Y ( .A(A[6]), .B(B[6]), .Y(GN[6]) );
  NAND2X2 A00X ( .A(A[5]), .B(B[5]), .Y(GN[5]) );
  NAND2X2 A00W ( .A(A[4]), .B(B[4]), .Y(GN[4]) );
  NAND2X2 A00V ( .A(A[3]), .B(B[3]), .Y(GN[3]) );
  NAND2X2 A00U ( .A(A[2]), .B(B[2]), .Y(GN[2]) );
  NAND2X2 A00T ( .A(A[1]), .B(B[1]), .Y(GN[1]) );
  XNOR2X2 A00L ( .A(A[19]), .B(B[19]), .Y(PN[19]) );
  XNOR2X2 A00K ( .A(A[18]), .B(B[18]), .Y(PN[18]) );
  XNOR2X2 A00J ( .A(A[17]), .B(B[17]), .Y(PN[17]) );
  XNOR2X2 A00H ( .A(A[16]), .B(B[16]), .Y(PN[16]) );
  XNOR2X2 A00G ( .A(A[15]), .B(B[15]), .Y(PN[15]) );
  XNOR2X2 A00F ( .A(A[14]), .B(B[14]), .Y(PN[14]) );
  XNOR2X2 A00E ( .A(A[13]), .B(B[13]), .Y(PN[13]) );
  XNOR2X2 A00D ( .A(A[12]), .B(B[12]), .Y(PN[12]) );
  XNOR2X2 A00C ( .A(A[11]), .B(B[11]), .Y(PN[11]) );
  XNOR2X2 A00B ( .A(A[10]), .B(B[10]), .Y(PN[10]) );
  XNOR2X2 A00A ( .A(A[9]), .B(B[9]), .Y(PN[9]) );
  XNOR2X2 A009 ( .A(A[8]), .B(B[8]), .Y(PN[8]) );
  XNOR2X2 A008 ( .A(A[7]), .B(B[7]), .Y(PN[7]) );
  XNOR2X2 A007 ( .A(A[6]), .B(B[6]), .Y(PN[6]) );
  XNOR2X2 A006 ( .A(A[5]), .B(B[5]), .Y(PN[5]) );
  XNOR2X2 A005 ( .A(A[4]), .B(B[4]), .Y(PN[4]) );
  XNOR2X2 A004 ( .A(A[3]), .B(B[3]), .Y(PN[3]) );
  XNOR2X2 A003 ( .A(A[2]), .B(B[2]), .Y(PN[2]) );
  XNOR2X2 A002 ( .A(A[1]), .B(B[1]), .Y(PN[1]) );
  XN3D2 A001 ( .C(CI), .B(B[0]), .A(A[0]), .Y(PN[0]) );
endmodule


module LM20 ( A, S, SG, Y );
  input [19:0] A;
  output [19:0] Y;
  input S, SG;
  wire   n_A_0E, n_A_1D;

  INVX4 A00N ( .A(SG), .Y(n_A_0E) );
  BUFX4 A00M ( .A(S), .Y(n_A_1D) );
  MX2X1 A00L ( .S0(n_A_1D), .B(SG), .A(A[19]), .Y(Y[19]) );
  MX2X1 A00K ( .S0(n_A_1D), .B(n_A_0E), .A(A[18]), .Y(Y[18]) );
  MX2X1 A00J ( .S0(n_A_1D), .B(n_A_0E), .A(A[17]), .Y(Y[17]) );
  MX2X1 A00H ( .S0(n_A_1D), .B(n_A_0E), .A(A[16]), .Y(Y[16]) );
  MX2X1 A00G ( .S0(n_A_1D), .B(n_A_0E), .A(A[15]), .Y(Y[15]) );
  MX2X1 A00F ( .S0(n_A_1D), .B(n_A_0E), .A(A[14]), .Y(Y[14]) );
  MX2X1 A00E ( .S0(n_A_1D), .B(n_A_0E), .A(A[13]), .Y(Y[13]) );
  MX2X1 A00D ( .S0(n_A_1D), .B(n_A_0E), .A(A[12]), .Y(Y[12]) );
  MX2X1 A00C ( .S0(n_A_1D), .B(n_A_0E), .A(A[11]), .Y(Y[11]) );
  MX2X1 A00B ( .S0(n_A_1D), .B(n_A_0E), .A(A[10]), .Y(Y[10]) );
  MX2X1 A00A ( .S0(n_A_1D), .B(n_A_0E), .A(A[9]), .Y(Y[9]) );
  MX2X1 A009 ( .S0(n_A_1D), .B(n_A_0E), .A(A[8]), .Y(Y[8]) );
  MX2X1 A008 ( .S0(n_A_1D), .B(n_A_0E), .A(A[7]), .Y(Y[7]) );
  MX2X1 A007 ( .S0(n_A_1D), .B(n_A_0E), .A(A[6]), .Y(Y[6]) );
  MX2X1 A006 ( .S0(n_A_1D), .B(n_A_0E), .A(A[5]), .Y(Y[5]) );
  MX2X1 A005 ( .S0(n_A_1D), .B(n_A_0E), .A(A[4]), .Y(Y[4]) );
  MX2X1 A004 ( .S0(n_A_1D), .B(n_A_0E), .A(A[3]), .Y(Y[3]) );
  MX2X1 A003 ( .S0(n_A_1D), .B(n_A_0E), .A(A[2]), .Y(Y[2]) );
  MX2X1 A002 ( .S0(n_A_1D), .B(n_A_0E), .A(A[1]), .Y(Y[1]) );
  MX2X1 A001 ( .S0(n_A_1D), .B(n_A_0E), .A(A[0]), .Y(Y[0]) );
endmodule


module LMCNT ( C, B, A, EN, SG, S );
  input C, B, A, EN;
  output SG, S;
  wire   n_A_03, n_A_05, n_A_06, n_A_09, n_A_07, n_A_0B;

  BUFX2 A0E ( .A(B), .Y(n_A_03) );
  BUFX2 A07 ( .A(n_A_03), .Y(SG) );
  INVX1 A06 ( .A(EN), .Y(n_A_05) );
  NOR2X1 A05 ( .A(n_A_05), .B(n_A_06), .Y(S) );
  AOI21X1 A04 ( .A0(n_A_09), .A1(C), .B0(n_A_07), .Y(n_A_06) );
  NOR2X1 A03 ( .A(C), .B(n_A_0B), .Y(n_A_07) );
  NOR2X1 A02 ( .A(A), .B(n_A_03), .Y(n_A_09) );
  NAND2X1 A01 ( .A(A), .B(n_A_03), .Y(n_A_0B) );
endmodule


module INV20 ( A, INV, Y );
  input [19:0] A;
  output [19:0] Y;
  input INV;
  wire   n_A_04;

  XOR2X1 A000 ( .A(A[0]), .B(n_A_04), .Y(Y[0]) );
  XOR2X1 A001 ( .A(A[1]), .B(n_A_04), .Y(Y[1]) );
  XOR2X1 A002 ( .A(A[2]), .B(n_A_04), .Y(Y[2]) );
  XOR2X1 A003 ( .A(A[3]), .B(n_A_04), .Y(Y[3]) );
  XOR2X1 A004 ( .A(A[4]), .B(n_A_04), .Y(Y[4]) );
  XOR2X1 A005 ( .A(A[5]), .B(n_A_04), .Y(Y[5]) );
  XOR2X1 A006 ( .A(A[6]), .B(n_A_04), .Y(Y[6]) );
  XOR2X1 A007 ( .A(A[7]), .B(n_A_04), .Y(Y[7]) );
  XOR2X1 A008 ( .A(A[8]), .B(n_A_04), .Y(Y[8]) );
  XOR2X1 A009 ( .A(A[9]), .B(n_A_04), .Y(Y[9]) );
  XOR2X1 A010 ( .A(A[10]), .B(n_A_04), .Y(Y[10]) );
  XOR2X1 A011 ( .A(A[11]), .B(n_A_04), .Y(Y[11]) );
  XOR2X1 A012 ( .A(A[12]), .B(n_A_04), .Y(Y[12]) );
  XOR2X1 A013 ( .A(A[13]), .B(n_A_04), .Y(Y[13]) );
  XOR2X1 A014 ( .A(A[14]), .B(n_A_04), .Y(Y[14]) );
  XOR2X1 A015 ( .A(A[15]), .B(n_A_04), .Y(Y[15]) );
  XOR2X1 A016 ( .A(A[16]), .B(n_A_04), .Y(Y[16]) );
  XOR2X1 A017 ( .A(A[17]), .B(n_A_04), .Y(Y[17]) );
  XOR2X1 A018 ( .A(A[18]), .B(n_A_04), .Y(Y[18]) );
  XOR2X1 A019 ( .A(A[19]), .B(n_A_04), .Y(Y[19]) );
  BUFX4 A103 ( .A(INV), .Y(n_A_04) );
endmodule


module FE21R ( D, D20, TI, RN, TE, CK, EN, Q, Q20, TO );
  input [19:0] D;
  output [19:0] Q;
  input D20, TI, RN, TE, CK, EN;
  output Q20, TO;
  wire   n_A_1A, n_A_1E, n_A_15;

  FE1R A02 ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[19]), .CK(CK), .EN(n_A_15), .D(
        D20), .Q(Q20) );
  BUFX2 A28 ( .A(Q20), .Y(TO) );
  FE1R A1Y ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[18]), .CK(CK), .EN(n_A_15), .D(
        D[19]), .Q(Q[19]) );
  FE1R A1X ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[17]), .CK(CK), .EN(n_A_15), .D(
        D[18]), .Q(Q[18]) );
  FE1R A1W ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[16]), .CK(CK), .EN(n_A_15), .D(
        D[17]), .Q(Q[17]) );
  FE1R A1V ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[15]), .CK(CK), .EN(n_A_15), .D(
        D[16]), .Q(Q[16]) );
  BUFX4 A04 ( .A(RN), .Y(n_A_1A) );
  BUFX4 A01 ( .A(EN), .Y(n_A_15) );
  BUFX4 A03 ( .A(TE), .Y(n_A_1E) );
  FE1R A1R ( .RN(n_A_1A), .TE(n_A_1E), .TI(TI), .CK(CK), .EN(n_A_15), .D(D[0]), 
        .Q(Q[0]) );
  FE1R A1P ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[0]), .CK(CK), .EN(n_A_15), .D(
        D[1]), .Q(Q[1]) );
  FE1R A1N ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[1]), .CK(CK), .EN(n_A_15), .D(
        D[2]), .Q(Q[2]) );
  FE1R A1M ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[2]), .CK(CK), .EN(n_A_15), .D(
        D[3]), .Q(Q[3]) );
  FE1R A1L ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[3]), .CK(CK), .EN(n_A_15), .D(
        D[4]), .Q(Q[4]) );
  FE1R A1K ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[4]), .CK(CK), .EN(n_A_15), .D(
        D[5]), .Q(Q[5]) );
  FE1R A1J ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[5]), .CK(CK), .EN(n_A_15), .D(
        D[6]), .Q(Q[6]) );
  FE1R A1H ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[6]), .CK(CK), .EN(n_A_15), .D(
        D[7]), .Q(Q[7]) );
  FE1R A1G ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[7]), .CK(CK), .EN(n_A_15), .D(
        D[8]), .Q(Q[8]) );
  FE1R A1F ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[8]), .CK(CK), .EN(n_A_15), .D(
        D[9]), .Q(Q[9]) );
  FE1R A1E ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[9]), .CK(CK), .EN(n_A_15), .D(
        D[10]), .Q(Q[10]) );
  FE1R A1D ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[10]), .CK(CK), .EN(n_A_15), .D(
        D[11]), .Q(Q[11]) );
  FE1R A1C ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[11]), .CK(CK), .EN(n_A_15), .D(
        D[12]), .Q(Q[12]) );
  FE1R A1B ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[12]), .CK(CK), .EN(n_A_15), .D(
        D[13]), .Q(Q[13]) );
  FE1R A1A ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[13]), .CK(CK), .EN(n_A_15), .D(
        D[14]), .Q(Q[14]) );
  FE1R A19 ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[14]), .CK(CK), .EN(n_A_15), .D(
        D[15]), .Q(Q[15]) );
endmodule


module MLT02 ( A, B, P, P24, P25 );
  input [15:0] A;
  input [9:0] B;
  output [23:2] P;
  output P24, P25;
  wire   n_BN0, n_BN1, n_BN2, n_BN3, n_BN4, n_BN5, n_BN6, n_BN7, n_BN8, n_AN00,
         n_AN01, n_AN02, n_AN03, n_AN04, n_AN05, n_AN06, n_AN07, n_AN08,
         n_AN09, n_AN10, n_AN11, n_AN12, n_AN13, n_AN14, n_P001, n_P000,
         n_A_4P, n_A_4N, n_AN15, n_BN9, n_A_3G, n_A_3F, n_A_3U, n_BS13, n_BC13,
         n_A_3J, n_A_3H, n_A_3V, n_BS12, n_BC12, n_A_3L, n_A_3K, n_A_3W,
         n_BS11, n_BC11, n_A_3N, n_A_3M, n_A_3X, n_BS10, n_BC10, n_A_3R,
         n_A_3P, n_A_3Y, n_BS09, n_BC09, n_A_3S, n_A_3T, n_A_40, n_BS08,
         n_BC08, n_P405, n_P307, n_P209, n_P111, n_B13C2, n_B13C1, n_P013,
         n_P404, n_P306, n_P208, n_P110, n_B12C2, n_P012, n_P403, n_P305,
         n_P207, n_P109, n_P011, n_P402, n_P304, n_P206, n_P108, n_P010,
         n_P401, n_P303, n_P205, n_P107, n_P009, n_P400, n_P302, n_P204,
         n_P106, n_P008, n_A_45, n_A_44, n_A_48, n_BS07, n_BC07, n_A_47,
         n_A_46, n_A_49, n_BS06, n_BC06, n_A_4D, n_A_4B, n_A_4A, n_BS05,
         n_BC05, n_A_4E, n_A_4F, n_A_4C, n_BS04, n_BC04, n_A_43, n_A_42,
         n_A_41, n_BC03, n_A_4K, n_P301, n_P203, n_P105, n_P007, n_P300,
         n_P202, n_P104, n_P006, n_A_4L, n_P201, n_P103, n_P005, n_A_4J,
         n_P200, n_P102, n_P004, n_P100, n_P002, n_A_4M, n_P101, n_P003,
         n_P416, n_P415, n_P414, n_P413, n_P412, n_P411, n_P410, n_P409,
         n_P408, n_P407, n_P406, n_P316, n_P315, n_P314, n_P313, n_P312,
         n_P311, n_P310, n_P309, n_P308, n_P216, n_P215, n_P214, n_P213,
         n_P212, n_P211, n_P210, n_P116, n_P115, n_P114, n_P113, n_P112,
         n_P016, n_P015, n_P014, n_B_31, n_B_27, n_B_0H, n_B_0B, n_B_34,
         n_B_3H, n_B_2K, n_BS25, n_B_2L, n_B_2M, n_B_2N, n_B_2Y, n_BS24,
         n_BS23, n_BS22, n_BS21, n_BS20, n_BS19, n_BS18, n_BS17, n_BS16,
         n_BS15, n_BS14, n_BC24, n_BC23, n_BC22, n_BC21, n_BC20, n_BC19,
         n_BC18, n_BC17, n_BC16, n_BC15, n_BC14, n_B_2P, n_B_26, n_B_2B,
         n_B_2H, n_B_2G, n_B_2F, n_B_2E, n_B_2D, n_B_2C, n_B_2J, n_B_25,
         n_B_2A, n_B_32, n_B_33, n_B_35, n_B_30, n_B_2R, n_B_3G, n_B_2S,
         n_B_2X, n_B_2U;

  INVX2 A200 ( .A(B[0]), .Y(n_BN0) );
  INVX2 A201 ( .A(B[1]), .Y(n_BN1) );
  INVX2 A202 ( .A(B[2]), .Y(n_BN2) );
  INVX2 A203 ( .A(B[3]), .Y(n_BN3) );
  INVX2 A204 ( .A(B[4]), .Y(n_BN4) );
  INVX2 A205 ( .A(B[5]), .Y(n_BN5) );
  INVX2 A206 ( .A(B[6]), .Y(n_BN6) );
  INVX2 A207 ( .A(B[7]), .Y(n_BN7) );
  INVX2 A208 ( .A(B[8]), .Y(n_BN8) );
  INVX2 A100 ( .A(A[0]), .Y(n_AN00) );
  INVX2 A101 ( .A(A[1]), .Y(n_AN01) );
  INVX2 A102 ( .A(A[2]), .Y(n_AN02) );
  INVX2 A103 ( .A(A[3]), .Y(n_AN03) );
  INVX2 A104 ( .A(A[4]), .Y(n_AN04) );
  INVX2 A105 ( .A(A[5]), .Y(n_AN05) );
  INVX2 A106 ( .A(A[6]), .Y(n_AN06) );
  INVX2 A107 ( .A(A[7]), .Y(n_AN07) );
  INVX2 A108 ( .A(A[8]), .Y(n_AN08) );
  INVX2 A109 ( .A(A[9]), .Y(n_AN09) );
  INVX2 A110 ( .A(A[10]), .Y(n_AN10) );
  INVX2 A111 ( .A(A[11]), .Y(n_AN11) );
  INVX2 A112 ( .A(A[12]), .Y(n_AN12) );
  INVX2 A113 ( .A(A[13]), .Y(n_AN13) );
  INVX2 A114 ( .A(A[14]), .Y(n_AN14) );
  AND3X1 A01K ( .A(n_P001), .B(n_P000), .C(n_A_4N), .Y(n_A_4P) );
  INVX1 A011 ( .A(n_BN1), .Y(n_A_4N) );
  INVX2 A115 ( .A(A[15]), .Y(n_AN15) );
  INVX2 A209 ( .A(B[9]), .Y(n_BN9) );
  ADDFHX1 A00X ( .A(n_A_3G), .B(n_A_3F), .CI(n_A_3U), .S(n_BS13), .CO(n_BC13)
         );
  ADDFHX1 A00W ( .A(n_A_3J), .B(n_A_3H), .CI(n_A_3V), .S(n_BS12), .CO(n_BC12)
         );
  ADDFHX1 A00V ( .A(n_A_3L), .B(n_A_3K), .CI(n_A_3W), .S(n_BS11), .CO(n_BC11)
         );
  ADDFHX1 A00U ( .A(n_A_3N), .B(n_A_3M), .CI(n_A_3X), .S(n_BS10), .CO(n_BC10)
         );
  ADDFHX1 A00T ( .A(n_A_3R), .B(n_A_3P), .CI(n_A_3Y), .S(n_BS09), .CO(n_BC09)
         );
  ADDFHX1 A00S ( .A(n_A_3S), .B(n_A_3T), .CI(n_A_40), .S(n_BS08), .CO(n_BC08)
         );
  PA1 A00R ( .E(n_P013), .D(n_P111), .C(n_P209), .B(n_P307), .A(n_P405), .CO1(
        n_B13C2), .S(n_A_3U), .CO2(n_B13C1) );
  PA1 A00P ( .E(n_P012), .D(n_P110), .C(n_P208), .B(n_P306), .A(n_P404), .CO1(
        n_B12C2), .S(n_A_3V), .CO2(n_A_3F) );
  PA1 A00N ( .E(n_P011), .D(n_P109), .C(n_P207), .B(n_P305), .A(n_P403), .CO1(
        n_A_3G), .S(n_A_3W), .CO2(n_A_3H) );
  PA1 A00M ( .E(n_P010), .D(n_P108), .C(n_P206), .B(n_P304), .A(n_P402), .CO1(
        n_A_3J), .S(n_A_3X), .CO2(n_A_3K) );
  PA1 A00L ( .E(n_P009), .D(n_P107), .C(n_P205), .B(n_P303), .A(n_P401), .CO1(
        n_A_3L), .S(n_A_3Y), .CO2(n_A_3M) );
  PA1 A00K ( .E(n_P008), .D(n_P106), .C(n_P204), .B(n_P302), .A(n_P400), .CO1(
        n_A_3N), .S(n_A_40), .CO2(n_A_3P) );
  ADDFHX1 A00J ( .A(n_A_45), .B(n_A_44), .CI(n_A_48), .S(n_BS07), .CO(n_BC07)
         );
  ADDFHX1 A00H ( .A(n_A_47), .B(n_A_46), .CI(n_A_49), .S(n_BS06), .CO(n_BC06)
         );
  ADDFHX1 A00G ( .A(n_A_4D), .B(n_A_4B), .CI(n_A_4A), .S(n_BS05), .CO(n_BC05)
         );
  ADDFHX1 A00F ( .A(n_A_4E), .B(n_A_4F), .CI(n_A_4C), .S(n_BS04), .CO(n_BC04)
         );
  ADDFHX1 A00E ( .A(n_A_43), .B(n_A_42), .CI(n_A_41), .S(P[3]), .CO(n_BC03) );
  PA1 A00D ( .E(n_P007), .D(n_P105), .C(n_P203), .B(n_P301), .A(n_A_4K), .CO1(
        n_A_3R), .S(n_A_48), .CO2(n_A_3S) );
  PA1 A00C ( .E(n_P006), .D(n_P104), .C(n_P202), .B(n_P300), .A(n_A_4K), .CO1(
        n_A_3T), .S(n_A_49), .CO2(n_A_44) );
  PA1 A00B ( .E(n_P005), .D(n_P103), .C(n_P201), .B(n_A_4L), .A(n_A_4K), .CO1(
        n_A_45), .S(n_A_4A), .CO2(n_A_46) );
  PA1 A00A ( .E(n_P004), .D(n_P102), .C(n_P200), .B(n_A_4J), .A(n_A_4K), .CO1(
        n_A_47), .S(n_A_4C), .CO2(n_A_4B) );
  ADDFHX1 A009 ( .A(n_A_4L), .B(n_A_4K), .CI(n_A_4J), .S(n_A_4E), .CO(n_A_4D)
         );
  QA1 A008 ( .A(n_P100), .B(n_P002), .C(n_A_4M), .D(n_A_4P), .CO1(n_A_42), .S(
        P[2]), .CO2(n_A_43) );
  ADDHX1 A007 ( .A(n_P101), .B(n_P003), .S(n_A_41), .CO(n_A_4F) );
  PP16 A005 ( .AN({n_AN15, n_AN14, n_AN13, n_AN12, n_AN11, n_AN10, n_AN09, 
        n_AN08, n_AN07, n_AN06, n_AN05, n_AN04, n_AN03, n_AN02, n_AN01, n_AN00}), .B1N(n_BN9), .B0N(n_BN8), .B_1N(n_BN7), .PP({n_P416, n_P415, n_P414, n_P413, 
        n_P412, n_P411, n_P410, n_P409, n_P408, n_P407, n_P406, n_P405, n_P404, 
        n_P403, n_P402, n_P401, n_P400}), .AD1(n_A_4K) );
  PP16 A004 ( .AN({n_AN15, n_AN14, n_AN13, n_AN12, n_AN11, n_AN10, n_AN09, 
        n_AN08, n_AN07, n_AN06, n_AN05, n_AN04, n_AN03, n_AN02, n_AN01, n_AN00}), .B1N(n_BN7), .B0N(n_BN6), .B_1N(n_BN5), .PP({n_P316, n_P315, n_P314, n_P313, 
        n_P312, n_P311, n_P310, n_P309, n_P308, n_P307, n_P306, n_P305, n_P304, 
        n_P303, n_P302, n_P301, n_P300}), .AD1(n_A_4L) );
  PP16 A003 ( .AN({n_AN15, n_AN14, n_AN13, n_AN12, n_AN11, n_AN10, n_AN09, 
        n_AN08, n_AN07, n_AN06, n_AN05, n_AN04, n_AN03, n_AN02, n_AN01, n_AN00}), .B1N(n_BN5), .B0N(n_BN4), .B_1N(n_BN3), .PP({n_P216, n_P215, n_P214, n_P213, 
        n_P212, n_P211, n_P210, n_P209, n_P208, n_P207, n_P206, n_P205, n_P204, 
        n_P203, n_P202, n_P201, n_P200}), .AD1(n_A_4J) );
  PP16 A002 ( .AN({n_AN15, n_AN14, n_AN13, n_AN12, n_AN11, n_AN10, n_AN09, 
        n_AN08, n_AN07, n_AN06, n_AN05, n_AN04, n_AN03, n_AN02, n_AN01, n_AN00}), .B1N(n_BN3), .B0N(n_BN2), .B_1N(n_BN1), .PP({n_P116, n_P115, n_P114, n_P113, 
        n_P112, n_P111, n_P110, n_P109, n_P108, n_P107, n_P106, n_P105, n_P104, 
        n_P103, n_P102, n_P101, n_P100}), .AD1(n_A_4M) );
  PPLSB A001 ( .AN({n_AN15, n_AN14, n_AN13, n_AN12, n_AN11, n_AN10, n_AN09, 
        n_AN08, n_AN07, n_AN06, n_AN05, n_AN04, n_AN03, n_AN02, n_AN01, n_AN00}), .B1N(n_BN1), .B0N(n_BN0), .PP({n_P016, n_P015, n_P014, n_P013, n_P012, 
        n_P011, n_P010, n_P009, n_P008, n_P007, n_P006, n_P005, n_P004, n_P003, 
        n_P002, n_P001, n_P000}) );
  ADDHX1 B3H ( .A(n_P408), .B(n_P310), .S(n_B_31), .CO(n_B_27) );
  PA1 B03 ( .E(n_B_3H), .D(n_P016), .C(n_P114), .B(n_P212), .A(n_B_31), .CO1(
        n_B_0H), .S(n_B_34), .CO2(n_B_0B) );
  TIELO B2V ( .Y(n_B_2K) );
  TIEHI B2U ( .Y(n_BS25) );
  INVX1 B2T ( .A(n_P415), .Y(n_B_2L) );
  INVX1 B2S ( .A(n_P315), .Y(n_B_2M) );
  INVX1 B2R ( .A(n_P215), .Y(n_B_2N) );
  TIEHI B1H ( .Y(n_B_3H) );
  INVX1 B1G ( .A(n_P115), .Y(n_B_2Y) );
  ADD22 B0N ( .A({n_BS25, n_BS24, n_BS23, n_BS22, n_BS21, n_BS20, n_BS19, 
        n_BS18, n_BS17, n_BS16, n_BS15, n_BS14, n_BS13, n_BS12, n_BS11, n_BS10, 
        n_BS09, n_BS08, n_BS07, n_BS06, n_BS05, n_BS04}), .B({n_BC24, n_BC23, 
        n_BC22, n_BC21, n_BC20, n_BC19, n_BC18, n_BC17, n_BC16, n_BC15, n_BC14, 
        n_BC13, n_BC12, n_BC11, n_BC10, n_BC09, n_BC08, n_BC07, n_BC06, n_BC05, 
        n_BC04, n_BC03}), .S({P25, P24, P[23:4]}) );
  ADDFHX1 B0M ( .A(n_B_2P), .B(n_B_26), .CI(n_B_2B), .S(n_BS19), .CO(n_BC19)
         );
  ADDHX1 B0L ( .A(n_P416), .B(n_P415), .S(n_BS24), .CO(n_BC24) );
  ADDHX1 B0K ( .A(n_B_2H), .B(n_B_2G), .S(n_BS22), .CO(n_BC22) );
  ADDHX1 B0J ( .A(n_P413), .B(n_B_2M), .S(n_B_2F), .CO(n_B_2G) );
  QA1 B0H ( .A(n_P412), .B(n_P314), .C(n_P216), .D(n_P215), .CO1(n_B_2E), .S(
        n_B_2C), .CO2(n_B_2D) );
  ADDFHX1 B0G ( .A(n_B_2L), .B(n_B_2K), .CI(n_B_2J), .S(n_BS23), .CO(n_BC23)
         );
  ADDFHX1 B0F ( .A(n_P414), .B(n_P316), .CI(n_P315), .S(n_B_2H), .CO(n_B_2J)
         );
  ADDFHX1 B0E ( .A(n_B_2D), .B(n_B_2E), .CI(n_B_2F), .S(n_BS21), .CO(n_BC21)
         );
  ADDFHX1 B0D ( .A(n_B_25), .B(n_B_2A), .CI(n_B_2C), .S(n_BS20), .CO(n_BC20)
         );
  ADDFHX1 B0B ( .A(n_P411), .B(n_P313), .CI(n_B_2N), .S(n_B_2B), .CO(n_B_2A)
         );
  ADDFHX1 B0A ( .A(n_B_0H), .B(n_B_32), .CI(n_B_33), .S(n_BS18), .CO(n_BC18)
         );
  ADDFHX1 B09 ( .A(n_B_35), .B(n_B_0B), .CI(n_B_30), .S(n_BS17), .CO(n_BC17)
         );
  ADDFHX1 B08 ( .A(n_B_2R), .B(n_B_3G), .CI(n_B_34), .S(n_BS16), .CO(n_BC16)
         );
  ADDFHX1 B07 ( .A(n_B13C2), .B(n_B_2S), .CI(n_B_2X), .S(n_BS15), .CO(n_BC15)
         );
  ADDFHX1 B06 ( .A(n_B13C1), .B(n_B12C2), .CI(n_B_2U), .S(n_BS14), .CO(n_BC14)
         );
  PA1 B05 ( .E(n_P115), .D(n_P116), .C(n_P214), .B(n_P312), .A(n_P410), .CO1(
        n_B_25), .S(n_B_33), .CO2(n_B_26) );
  PA1 B04 ( .E(n_B_27), .D(n_B_2Y), .C(n_P213), .B(n_P311), .A(n_P409), .CO1(
        n_B_2P), .S(n_B_30), .CO2(n_B_32) );
  PA1 B02 ( .E(n_P015), .D(n_P113), .C(n_P211), .B(n_P309), .A(n_P407), .CO1(
        n_B_35), .S(n_B_2X), .CO2(n_B_3G) );
  PA1 B01 ( .E(n_P014), .D(n_P112), .C(n_P210), .B(n_P308), .A(n_P406), .CO1(
        n_B_2R), .S(n_B_2U), .CO2(n_B_2S) );
endmodule


module ADD22 ( A, B, S, CO );
  input [21:0] A;
  input [21:0] B;
  output [21:0] S;
  output CO;
  wire   n_A_061, n_A_062, n_A_063, n_A_064, n_A_065, n_A_066, n_A_067,
         n_A_068, n_A_069, n_A_0610, n_A_0611, n_A_0612, n_A_0613, n_A_0614,
         n_A_0615, n_A_0616, n_A_0617, n_A_0618, n_A_0619, n_A_0620, n_A_0621,
         n_A_0622, n_A_051, n_A_052, n_A_053, n_A_054, n_A_055, n_A_056,
         n_A_057, n_A_058, n_A_059, n_A_0510, n_A_0511, n_A_0512, n_A_0513,
         n_A_0514, n_A_0515, n_A_0516, n_A_0517, n_A_0518, n_A_0519, n_A_0520,
         n_A_0521, n_A_0522;

  PG22 A001 ( .A(A), .B(B), .GN({n_A_051, n_A_052, n_A_053, n_A_054, n_A_055, 
        n_A_056, n_A_057, n_A_058, n_A_059, n_A_0510, n_A_0511, n_A_0512, 
        n_A_0513, n_A_0514, n_A_0515, n_A_0516, n_A_0517, n_A_0518, n_A_0519, 
        n_A_0520, n_A_0521, n_A_0522}), .PN({n_A_061, n_A_062, n_A_063, 
        n_A_064, n_A_065, n_A_066, n_A_067, n_A_068, n_A_069, n_A_0610, 
        n_A_0611, n_A_0612, n_A_0613, n_A_0614, n_A_0615, n_A_0616, n_A_0617, 
        n_A_0618, n_A_0619, n_A_0620, n_A_0621, n_A_0622}) );
  CS22 A002 ( .PN({n_A_061, n_A_062, n_A_063, n_A_064, n_A_065, n_A_066, 
        n_A_067, n_A_068, n_A_069, n_A_0610, n_A_0611, n_A_0612, n_A_0613, 
        n_A_0614, n_A_0615, n_A_0616, n_A_0617, n_A_0618, n_A_0619, n_A_0620, 
        n_A_0621, n_A_0622}), .GN({n_A_051, n_A_052, n_A_053, n_A_054, n_A_055, 
        n_A_056, n_A_057, n_A_058, n_A_059, n_A_0510, n_A_0511, n_A_0512, 
        n_A_0513, n_A_0514, n_A_0515, n_A_0516, n_A_0517, n_A_0518, n_A_0519, 
        n_A_0520, n_A_0521, n_A_0522}), .S(S), .CO(CO) );
endmodule


module CS22 ( PN, GN, S, CO );
  input [21:0] PN;
  input [21:0] GN;
  output [21:0] S;
  output CO;
  wire   n_A_1D, n_A_19, n_A_21, n_A_1C, n_A_1A, n_A_1E, n_A_1G, n_A_1B,
         n_A_1F, n_A_25, n__13G7, n_A_24, n_A_1W, n_A_17, n_A_1X, n__13GN7B,
         n_A_18, n_A_16, n_A_26, n_A_22, n_A_27, n_A_23, n_A_20, n_A_1Y,
         n__14GN15, n__14G15B, n_B_21, n_B_1L, n_B_1K, n_B_1S, n_B_1J, n_B_1R,
         n_B_1V, n_B_1H, n_B_1C, n_B_1U, n_B_25, n_B_1E, n_B_26, n_B_23,
         n_B_1D, n_B_24, n_B_22, n_B_1F, n_B_2A, n_B_29, n_B_1X, n_B_1W,
         n_B_1G, n_B_1Y, n_B_20, n_B_27, n_B_28, n_B_2C, n_B_2B, n_C_03,
         n_C_28, n_C_1X, n_C_25, n_C_16, n_C_20, n_C_1Y, n_C_1F, n_C_1T,
         n_C_1B, n_C_1S, n_C_1A, n_C_23, n_C_27, n_C_17, n_C_02, n_C_22,
         n_C_21, n_C_1P, n_C_1H;

  OAI21X1 A08 ( .A0(PN[4]), .A1(n_A_1D), .B0(GN[4]), .Y(n_A_19) );
  AOI21X1 A09 ( .A0(n_A_21), .A1(n_A_1C), .B0(n_A_1E), .Y(n_A_1A) );
  AOI21X1 A0A ( .A0(n_A_1G), .A1(n_A_1C), .B0(n_A_1F), .Y(n_A_1B) );
  XOR2X2 A0D ( .A(PN[7]), .B(n_A_1B), .Y(S[7]) );
  OAI21X2 A07 ( .A0(n_A_25), .A1(n_A_1D), .B0(n_A_24), .Y(n__13G7) );
  OAI21X2 A06 ( .A0(PN[2]), .A1(n_A_1W), .B0(GN[2]), .Y(n_A_17) );
  OAI21X2 A05 ( .A0(PN[1]), .A1(GN[0]), .B0(GN[1]), .Y(n_A_1X) );
  INVX2 A0U ( .A(n__13G7), .Y(n__13GN7B) );
  INVX2 A0T ( .A(PN[0]), .Y(S[0]) );
  INVX1 A0S ( .A(n_A_1C), .Y(n_A_18) );
  INVX1 A0R ( .A(n_A_1D), .Y(n_A_1C) );
  INVX1 A0P ( .A(n_A_1W), .Y(n_A_16) );
  INVX1 A0N ( .A(n_A_1X), .Y(n_A_1W) );
  INVX1 A0M ( .A(n_A_26), .Y(n_A_22) );
  INVX1 A0L ( .A(n_A_27), .Y(n_A_23) );
  XNOR2X2 A0K ( .A(PN[2]), .B(n_A_16), .Y(S[2]) );
  XNOR2X2 A0J ( .A(PN[3]), .B(n_A_17), .Y(S[3]) );
  XNOR2X2 A0H ( .A(PN[5]), .B(n_A_19), .Y(S[5]) );
  XOR2X2 A0G ( .A(PN[1]), .B(GN[0]), .Y(S[1]) );
  XOR2X2 A0F ( .A(PN[4]), .B(n_A_18), .Y(S[4]) );
  XOR2X2 A0E ( .A(PN[6]), .B(n_A_1A), .Y(S[6]) );
  XOR2X2 A0C ( .A(PN[8]), .B(n__13GN7B), .Y(S[8]) );
  AOI21X2 A0B ( .A0(n_A_1X), .A1(n_A_20), .B0(n_A_1Y), .Y(n_A_1D) );
  CODD4 A04 ( .GHN(GN[6]), .GLN(n_A_22), .PLN(n_A_23), .PHN(PN[6]), .GO(n_A_1F), .PO(n_A_1G) );
  CODD4 A03 ( .GHN(GN[3]), .GLN(GN[2]), .PLN(PN[2]), .PHN(PN[3]), .GO(n_A_1Y), 
        .PO(n_A_20) );
  CODD4 A02 ( .GHN(GN[5]), .GLN(GN[4]), .PLN(PN[4]), .PHN(PN[5]), .GO(n_A_1E), 
        .PO(n_A_21) );
  ODD8 A01 ( .G2N(GN[5]), .G1N(GN[4]), .G4N(GN[7]), .G3N(GN[6]), .P1N(PN[4]), 
        .P2N(PN[5]), .P3N(PN[6]), .P4N(PN[7]), .YG2(n_A_26), .YG4N(n_A_24), 
        .YP2(n_A_27), .YP4N(n_A_25) );
  INVX2 B26 ( .A(n__14GN15), .Y(n__14G15B) );
  INVX1 B1M ( .A(GN[12]), .Y(n_B_21) );
  INVX1 B0V ( .A(PN[9]), .Y(n_B_1L) );
  OAI21X1 B0P ( .A0(n__13GN7B), .A1(PN[8]), .B0(GN[8]), .Y(n_B_1K) );
  AOI21X1 B0L ( .A0(n_B_1S), .A1(n__13G7), .B0(n_B_1R), .Y(n_B_1J) );
  AOI21X1 B0N ( .A0(n_B_1V), .A1(n__13G7), .B0(n_B_1C), .Y(n_B_1H) );
  AOI21X1 B0R ( .A0(n_B_1U), .A1(n_B_25), .B0(n_B_26), .Y(n_B_1E) );
  AOI21X1 B0S ( .A0(n_B_23), .A1(n_B_1U), .B0(n_B_24), .Y(n_B_1D) );
  OAI22X1 B0U ( .A0(n_B_21), .A1(n_B_22), .B0(n_B_21), .B1(n_B_1U), .Y(n_B_1F)
         );
  AOI21X2 B0T ( .A0(n_B_2A), .A1(n__13G7), .B0(n_B_29), .Y(n__14GN15) );
  OAI21X2 B0M ( .A0(n__13GN7B), .A1(n_B_1X), .B0(n_B_1W), .Y(n_B_1U) );
  XNOR2X2 B0K ( .A(PN[16]), .B(n__14G15B), .Y(S[16]) );
  XOR2X2 B0J ( .A(PN[15]), .B(n_B_1D), .Y(S[15]) );
  XOR2X2 B0H ( .A(PN[14]), .B(n_B_1E), .Y(S[14]) );
  XOR2X2 B0G ( .A(PN[13]), .B(n_B_1F), .Y(S[13]) );
  XOR2X2 B0F ( .A(PN[12]), .B(n_B_1G), .Y(S[12]) );
  XOR2X2 B0E ( .A(PN[11]), .B(n_B_1H), .Y(S[11]) );
  XOR2X2 B0D ( .A(PN[10]), .B(n_B_1J), .Y(S[10]) );
  XOR2X2 B0C ( .A(n_B_1L), .B(n_B_1K), .Y(S[9]) );
  INVX1 B0B ( .A(n_B_1U), .Y(n_B_1G) );
  INVX1 B0A ( .A(n_B_1R), .Y(n_B_1Y) );
  INVX1 B09 ( .A(n_B_1S), .Y(n_B_20) );
  INVX1 B08 ( .A(PN[12]), .Y(n_B_22) );
  INVX1 B07 ( .A(n_B_26), .Y(n_B_27) );
  INVX1 B06 ( .A(n_B_25), .Y(n_B_28) );
  CODD4 B05 ( .GHN(n_B_2B), .GLN(n_B_1W), .PLN(n_B_1X), .PHN(n_B_2C), .GO(
        n_B_29), .PO(n_B_2A) );
  CODD4 B04 ( .GHN(GN[14]), .GLN(n_B_27), .PLN(n_B_28), .PHN(PN[14]), .GO(
        n_B_24), .PO(n_B_23) );
  CODD4 B03 ( .GHN(GN[10]), .GLN(n_B_1Y), .PLN(n_B_20), .PHN(PN[10]), .GO(
        n_B_1C), .PO(n_B_1V) );
  ODD8 B02 ( .G2N(GN[9]), .G1N(GN[8]), .G4N(GN[11]), .G3N(GN[10]), .P1N(PN[8]), 
        .P2N(PN[9]), .P3N(PN[10]), .P4N(PN[11]), .YG2(n_B_1R), .YG4N(n_B_1W), 
        .YP2(n_B_1S), .YP4N(n_B_1X) );
  ODD8 B01 ( .G2N(GN[13]), .G1N(GN[12]), .G4N(GN[15]), .G3N(GN[14]), .P1N(
        PN[12]), .P2N(PN[13]), .P3N(PN[14]), .P4N(PN[15]), .YG2(n_B_26), 
        .YG4N(n_B_2B), .YP2(n_B_25), .YP4N(n_B_2C) );
  INVX1 C1U ( .A(n_C_03), .Y(CO) );
  INVX1 C0L ( .A(PN[20]), .Y(n_C_28) );
  INVX1 C0W ( .A(PN[17]), .Y(n_C_1X) );
  XOR2X2 C0T ( .A(PN[21]), .B(n_C_25), .Y(S[21]) );
  XOR2X2 C0S ( .A(n_C_28), .B(n_C_16), .Y(S[20]) );
  XOR2X2 C0R ( .A(PN[19]), .B(n_C_20), .Y(S[19]) );
  XOR2X2 C0P ( .A(PN[18]), .B(n_C_1Y), .Y(S[18]) );
  XOR2X2 C0N ( .A(n_C_1X), .B(n_C_1F), .Y(S[17]) );
  INVX1 C0K ( .A(n_C_1T), .Y(n_C_1B) );
  INVX1 C0J ( .A(n_C_1S), .Y(n_C_1A) );
  INVX1 C0H ( .A(GN[20]), .Y(n_C_23) );
  INVX1 C0G ( .A(PN[20]), .Y(n_C_27) );
  AOI21X1 C0B ( .A0(n_C_17), .A1(n_C_16), .B0(n_C_02), .Y(n_C_03) );
  AOI21X1 C0A ( .A0(n_C_27), .A1(n_C_16), .B0(n_C_23), .Y(n_C_25) );
  AOI21X1 C09 ( .A0(n__14G15B), .A1(n_C_22), .B0(n_C_21), .Y(n_C_20) );
  OAI21X2 C08 ( .A0(n_C_1P), .A1(n__14GN15), .B0(n_C_1H), .Y(n_C_16) );
  AOI21X1 C07 ( .A0(n__14G15B), .A1(n_C_1S), .B0(n_C_1T), .Y(n_C_1Y) );
  OAI21X1 C06 ( .A0(PN[16]), .A1(n__14GN15), .B0(GN[16]), .Y(n_C_1F) );
  CODD4 C05 ( .GHN(GN[18]), .GLN(n_C_1B), .PLN(n_C_1A), .PHN(PN[18]), .GO(
        n_C_21), .PO(n_C_22) );
  CODD4 C04 ( .GHN(GN[21]), .GLN(GN[20]), .PLN(PN[20]), .PHN(PN[21]), .GO(
        n_C_02), .PO(n_C_17) );
  ODD8 C02 ( .G2N(GN[17]), .G1N(GN[16]), .G4N(GN[19]), .G3N(GN[18]), .P1N(
        PN[16]), .P2N(PN[17]), .P3N(PN[18]), .P4N(PN[19]), .YG2(n_C_1T), 
        .YG4N(n_C_1H), .YP2(n_C_1S), .YP4N(n_C_1P) );
endmodule


module PG22 ( A, B, GN, PN );
  input [21:0] A;
  input [21:0] B;
  output [21:0] GN;
  output [21:0] PN;


  NAND2X2 A00S ( .A(A[0]), .B(B[0]), .Y(GN[0]) );
  XNOR2X2 A001 ( .A(A[0]), .B(B[0]), .Y(PN[0]) );
  NAND2X2 A01E ( .A(A[21]), .B(B[21]), .Y(GN[21]) );
  NAND2X2 A01D ( .A(A[20]), .B(B[20]), .Y(GN[20]) );
  NAND2X2 A01C ( .A(A[19]), .B(B[19]), .Y(GN[19]) );
  NAND2X2 A01B ( .A(A[18]), .B(B[18]), .Y(GN[18]) );
  NAND2X2 A01A ( .A(A[17]), .B(B[17]), .Y(GN[17]) );
  NAND2X2 A019 ( .A(A[16]), .B(B[16]), .Y(GN[16]) );
  NAND2X2 A018 ( .A(A[15]), .B(B[15]), .Y(GN[15]) );
  NAND2X2 A017 ( .A(A[14]), .B(B[14]), .Y(GN[14]) );
  NAND2X2 A016 ( .A(A[13]), .B(B[13]), .Y(GN[13]) );
  NAND2X2 A015 ( .A(A[12]), .B(B[12]), .Y(GN[12]) );
  NAND2X2 A014 ( .A(A[11]), .B(B[11]), .Y(GN[11]) );
  NAND2X2 A013 ( .A(A[10]), .B(B[10]), .Y(GN[10]) );
  NAND2X2 A012 ( .A(A[9]), .B(B[9]), .Y(GN[9]) );
  NAND2X2 A011 ( .A(A[8]), .B(B[8]), .Y(GN[8]) );
  NAND2X2 A010 ( .A(A[7]), .B(B[7]), .Y(GN[7]) );
  NAND2X2 A00Y ( .A(A[6]), .B(B[6]), .Y(GN[6]) );
  NAND2X2 A00X ( .A(A[5]), .B(B[5]), .Y(GN[5]) );
  NAND2X2 A00W ( .A(A[4]), .B(B[4]), .Y(GN[4]) );
  NAND2X2 A00V ( .A(A[3]), .B(B[3]), .Y(GN[3]) );
  NAND2X2 A00U ( .A(A[2]), .B(B[2]), .Y(GN[2]) );
  NAND2X2 A00T ( .A(A[1]), .B(B[1]), .Y(GN[1]) );
  XNOR2X2 A00N ( .A(A[21]), .B(B[21]), .Y(PN[21]) );
  XNOR2X2 A00M ( .A(A[20]), .B(B[20]), .Y(PN[20]) );
  XNOR2X2 A00L ( .A(A[19]), .B(B[19]), .Y(PN[19]) );
  XNOR2X2 A00K ( .A(A[18]), .B(B[18]), .Y(PN[18]) );
  XNOR2X2 A00J ( .A(A[17]), .B(B[17]), .Y(PN[17]) );
  XNOR2X2 A00H ( .A(A[16]), .B(B[16]), .Y(PN[16]) );
  XNOR2X2 A00G ( .A(A[15]), .B(B[15]), .Y(PN[15]) );
  XNOR2X2 A00F ( .A(A[14]), .B(B[14]), .Y(PN[14]) );
  XNOR2X2 A00E ( .A(A[13]), .B(B[13]), .Y(PN[13]) );
  XNOR2X2 A00D ( .A(A[12]), .B(B[12]), .Y(PN[12]) );
  XNOR2X2 A00C ( .A(A[11]), .B(B[11]), .Y(PN[11]) );
  XNOR2X2 A00B ( .A(A[10]), .B(B[10]), .Y(PN[10]) );
  XNOR2X2 A00A ( .A(A[9]), .B(B[9]), .Y(PN[9]) );
  XNOR2X2 A009 ( .A(A[8]), .B(B[8]), .Y(PN[8]) );
  XNOR2X2 A008 ( .A(A[7]), .B(B[7]), .Y(PN[7]) );
  XNOR2X2 A007 ( .A(A[6]), .B(B[6]), .Y(PN[6]) );
  XNOR2X2 A006 ( .A(A[5]), .B(B[5]), .Y(PN[5]) );
  XNOR2X2 A005 ( .A(A[4]), .B(B[4]), .Y(PN[4]) );
  XNOR2X2 A004 ( .A(A[3]), .B(B[3]), .Y(PN[3]) );
  XNOR2X2 A003 ( .A(A[2]), .B(B[2]), .Y(PN[2]) );
  XNOR2X2 A002 ( .A(A[1]), .B(B[1]), .Y(PN[1]) );
endmodule


module PPLSB ( AN, B1N, B0N, PP );
  input [15:0] AN;
  output [16:0] PP;
  input B1N, B0N;
  wire   n_A_15, n_A_1B, n_A_1C, n_A_14, n_A_1D, n_A_16, n_A_17, n_A_18;

  AND2X4 A09 ( .A(n_A_15), .B(B0N), .Y(n_A_1B) );
  INVX4 A07 ( .A(B0N), .Y(n_A_1C) );
  INVX1 A08 ( .A(B1N), .Y(n_A_15) );
  NAND2X1 A06 ( .A(n_A_14), .B(n_A_1D), .Y(PP[16]) );
  NAND2X1 A05 ( .A(B0N), .B(B1N), .Y(n_A_1D) );
  PPU4 A04 ( .SFT(n_A_1B), .NSFT(n_A_1C), .AN3(AN[15]), .AN2(AN[14]), .AN1(
        AN[13]), .AN0(AN[12]), .RI(n_A_16), .SN(B1N), .LO(n_A_14), .P3(PP[15]), 
        .P2(PP[14]), .P1(PP[13]), .P0(PP[12]) );
  PPU4 A03 ( .SFT(n_A_1B), .NSFT(n_A_1C), .AN3(AN[11]), .AN2(AN[10]), .AN1(
        AN[9]), .AN0(AN[8]), .RI(n_A_17), .SN(B1N), .LO(n_A_16), .P3(PP[11]), 
        .P2(PP[10]), .P1(PP[9]), .P0(PP[8]) );
  PPU4 A02 ( .SFT(n_A_1B), .NSFT(n_A_1C), .AN3(AN[7]), .AN2(AN[6]), .AN1(AN[5]), .AN0(AN[4]), .RI(n_A_18), .SN(B1N), .LO(n_A_17), .P3(PP[7]), .P2(PP[6]), 
        .P1(PP[5]), .P0(PP[4]) );
  PPU4 A01 ( .SFT(n_A_1B), .NSFT(n_A_1C), .AN3(AN[3]), .AN2(AN[2]), .AN1(AN[1]), .AN0(AN[0]), .RI(n_A_15), .SN(B1N), .LO(n_A_18), .P3(PP[3]), .P2(PP[2]), 
        .P1(PP[1]), .P0(PP[0]) );
endmodule


module PP16 ( AN, B1N, B0N, B_1N, PP, AD1 );
  input [15:0] AN;
  output [16:0] PP;
  input B1N, B0N, B_1N;
  output AD1;
  wire   n_A_1G, n_A_1H, n_A_18, n_A_19, n_A_1D, n_A_1C, n_A_16, n_A_17,
         n_A_1J, n_A_1A, n_A_1M, n_A_1L, n_A_1K;

  XNOR2X1 A09 ( .A(B0N), .B(B_1N), .Y(n_A_1G) );
  AND2X4 A07 ( .A(n_A_1G), .B(n_A_1H), .Y(n_A_18) );
  INVX4 A0E ( .A(n_A_1G), .Y(n_A_19) );
  AND2X2 A1F ( .A(n_A_1D), .B(n_A_1C), .Y(AD1) );
  NAND2X1 A0D ( .A(n_A_16), .B(n_A_17), .Y(PP[16]) );
  NAND2X1 A0C ( .A(n_A_1G), .B(n_A_1J), .Y(n_A_17) );
  OR2X1 A0B ( .A(B0N), .B(B_1N), .Y(n_A_1D) );
  XOR2X1 A0A ( .A(B0N), .B(B1N), .Y(n_A_1H) );
  INVX1 A08 ( .A(B1N), .Y(n_A_1C) );
  INVX1 A06 ( .A(n_A_1H), .Y(n_A_1J) );
  INVX1 A05 ( .A(B1N), .Y(n_A_1A) );
  PPU4 A04 ( .SFT(n_A_18), .NSFT(n_A_19), .AN3(AN[15]), .AN2(AN[14]), .AN1(
        AN[13]), .AN0(AN[12]), .RI(n_A_1M), .SN(B1N), .LO(n_A_16), .P3(PP[15]), 
        .P2(PP[14]), .P1(PP[13]), .P0(PP[12]) );
  PPU4 A03 ( .SFT(n_A_18), .NSFT(n_A_19), .AN3(AN[11]), .AN2(AN[10]), .AN1(
        AN[9]), .AN0(AN[8]), .RI(n_A_1L), .SN(B1N), .LO(n_A_1M), .P3(PP[11]), 
        .P2(PP[10]), .P1(PP[9]), .P0(PP[8]) );
  PPU4 A02 ( .SFT(n_A_18), .NSFT(n_A_19), .AN3(AN[7]), .AN2(AN[6]), .AN1(AN[5]), .AN0(AN[4]), .RI(n_A_1K), .SN(B1N), .LO(n_A_1L), .P3(PP[7]), .P2(PP[6]), 
        .P1(PP[5]), .P0(PP[4]) );
  PPU4 A01 ( .SFT(n_A_18), .NSFT(n_A_19), .AN3(AN[3]), .AN2(AN[2]), .AN1(AN[1]), .AN0(AN[0]), .RI(n_A_1A), .SN(B1N), .LO(n_A_1K), .P3(PP[3]), .P2(PP[2]), 
        .P1(PP[1]), .P0(PP[0]) );
endmodule


module PPU4 ( SFT, NSFT, AN3, AN2, AN1, AN0, RI, SN, LO, P3, P2, P1, P0 );
  input SFT, NSFT, AN3, AN2, AN1, AN0, RI, SN;
  output LO, P3, P2, P1, P0;
  wire   n_A_0B, n_A_0K, n_A_0P, n_A_03, n_A_04, n_A_07, n_A_08, n_A_0L,
         n_A_0M, n_A_0N;

  BUFX2 A0F ( .A(SN), .Y(n_A_0B) );
  BUFX2 A0E ( .A(n_A_0K), .Y(LO) );
  BUFX2 A0D ( .A(RI), .Y(n_A_0P) );
  INVX1 A0C ( .A(n_A_03), .Y(P0) );
  INVX1 A0B ( .A(n_A_04), .Y(P1) );
  INVX1 A0A ( .A(n_A_07), .Y(P2) );
  INVX1 A09 ( .A(n_A_08), .Y(P3) );
  AOI22X1 A08 ( .A0(NSFT), .A1(n_A_0K), .B0(SFT), .B1(n_A_0L), .Y(n_A_08) );
  AOI22X1 A07 ( .A0(NSFT), .A1(n_A_0L), .B0(SFT), .B1(n_A_0M), .Y(n_A_07) );
  AOI22X1 A06 ( .A0(NSFT), .A1(n_A_0M), .B0(SFT), .B1(n_A_0N), .Y(n_A_04) );
  AOI22X1 A05 ( .A0(NSFT), .A1(n_A_0N), .B0(SFT), .B1(n_A_0P), .Y(n_A_03) );
  XOR2X1 A04 ( .A(n_A_0B), .B(AN3), .Y(n_A_0K) );
  XOR2X1 A03 ( .A(n_A_0B), .B(AN2), .Y(n_A_0L) );
  XOR2X1 A02 ( .A(n_A_0B), .B(AN1), .Y(n_A_0M) );
  XOR2X1 A01 ( .A(n_A_0B), .B(AN0), .Y(n_A_0N) );
endmodule


module QA1 ( A, B, C, D, CO1, S, CO2 );
  input A, B, C, D;
  output CO1, S, CO2;
  wire   n_A_08, n_A_05, n_A_04;

  NAND2X1 A06 ( .A(B), .B(A), .Y(n_A_08) );
  OAI21X1 A05 ( .A0(n_A_05), .A1(n_A_04), .B0(n_A_08), .Y(CO1) );
  AND2X1 A04 ( .A(D), .B(C), .Y(CO2) );
  XOR2X1 A03 ( .A(n_A_05), .B(n_A_04), .Y(S) );
  XNOR2X1 A02 ( .A(A), .B(B), .Y(n_A_05) );
  XNOR2X1 A01 ( .A(C), .B(D), .Y(n_A_04) );
endmodule


module PA1 ( E, D, C, B, A, CO1, S, CO2 );
  input E, D, C, B, A;
  output CO1, S, CO2;
  wire   n_A_0F, n_A_0D, n_A_0B, n_A_03, n_A_04, n_A_0E, n_A_0C, n_A_0G;

  INVX1 A0B ( .A(n_A_0F), .Y(n_A_0D) );
  INVX1 A0A ( .A(E), .Y(n_A_0B) );
  AND2X1 A09 ( .A(n_A_03), .B(n_A_04), .Y(CO1) );
  XOR2X1 A08 ( .A(n_A_03), .B(n_A_04), .Y(CO2) );
  XN3 A07 ( .C(n_A_0F), .B(n_A_0E), .A(n_A_0B), .Y(S) );
  OAI31X1 A06 ( .A0(n_A_0B), .A1(n_A_0E), .A2(n_A_0D), .B0(n_A_0C), .Y(n_A_03)
         );
  OA321 A05 ( .F(n_A_0G), .C(n_A_0F), .B(n_A_0E), .A(E), .E(n_A_0F), .D(n_A_0B), .Y(n_A_04) );
  NAND2X1 A04 ( .A(C), .B(D), .Y(n_A_0C) );
  NAND2X1 A03 ( .A(A), .B(B), .Y(n_A_0G) );
  XNOR2X2 A02 ( .A(D), .B(C), .Y(n_A_0E) );
  XNOR2X2 A01 ( .A(B), .B(A), .Y(n_A_0F) );
endmodule


module OA321 ( F, C, B, A, E, D, Y );
  input F, C, B, A, E, D;
  output Y;
  wire   n_A_06, n_A_04;

  NAND3X1 A0A ( .A(n_A_06), .B(n_A_04), .C(F), .Y(Y) );
  OR2X1 A01 ( .A(D), .B(E), .Y(n_A_06) );
  OR3X1 A02 ( .A(A), .B(B), .C(C), .Y(n_A_04) );
endmodule


module XN3 ( C, B, A, Y );
  input C, B, A;
  output Y;
  wire   n_A_02;

  XOR2X1 A06 ( .A(A), .B(B), .Y(n_A_02) );
  XNOR2X1 A01 ( .A(n_A_02), .B(C), .Y(Y) );
endmodule


module DS102 ( A, B, S, Y );
  input [9:0] A;
  input [9:0] B;
  output [9:0] Y;
  input S;
  wire   n_A_06;

  MX2X1 A00 ( .S0(n_A_06), .B(B[0]), .A(A[0]), .Y(Y[0]) );
  MX2X1 A01 ( .S0(n_A_06), .B(B[1]), .A(A[1]), .Y(Y[1]) );
  MX2X1 A02 ( .S0(n_A_06), .B(B[2]), .A(A[2]), .Y(Y[2]) );
  MX2X1 A03 ( .S0(n_A_06), .B(B[3]), .A(A[3]), .Y(Y[3]) );
  MX2X1 A04 ( .S0(n_A_06), .B(B[4]), .A(A[4]), .Y(Y[4]) );
  MX2X1 A05 ( .S0(n_A_06), .B(B[5]), .A(A[5]), .Y(Y[5]) );
  MX2X1 A06 ( .S0(n_A_06), .B(B[6]), .A(A[6]), .Y(Y[6]) );
  MX2X1 A07 ( .S0(n_A_06), .B(B[7]), .A(A[7]), .Y(Y[7]) );
  MX2X1 A08 ( .S0(n_A_06), .B(B[8]), .A(A[8]), .Y(Y[8]) );
  BUFX3 A12 ( .A(S), .Y(n_A_06) );
  MX2X1 A09 ( .S0(n_A_06), .B(B[9]), .A(A[9]), .Y(Y[9]) );
endmodule


module EXPCNV ( A, Y );
  input [7:0] A;
  output [8:0] Y;
  wire   n_A_1L, n_BS7, n_BS6, n_BS5, n_BS4, n_BS3, n_BS2, n_BS1, n_BS0, n_BC7,
         n_BC6, n_BC5, n_BC4, n_BC3, n_BC2, n_BC1, n_BC0, n_EB8, n_EA5, n_EB7,
         n_EA4, n_EB6, n_EB1, n_EA3, n_EB5, n_EA2, n_EB4, n_EA1, n_EB3, n_EA0,
         n_EB2, n_EB0, n_A_1J, n_SD3, n_SD2, n_SD1, n_SD0, n_A_1K;

  TIEHI A1R ( .Y(n_A_1L) );
  ADD08 A0D ( .A({n_BS7, n_BS6, n_BS5, n_BS4, n_BS3, n_BS2, n_BS1, n_BS0}), 
        .B({n_BC7, n_BC6, n_BC5, n_BC4, n_BC3, n_BC2, n_BC1, n_BC0}), .S(
        Y[8:1]) );
  ADDHX1 A0C ( .A(n_A_1L), .B(n_EB8), .S(n_BS7) );
  ADDHX1 A0B ( .A(n_EA5), .B(n_EB7), .S(n_BS6), .CO(n_BC7) );
  ADDHX1 A0A ( .A(n_EA4), .B(n_EB6), .S(n_BS5), .CO(n_BC6) );
  ADDHX1 A09 ( .A(A[1]), .B(n_EB1), .S(n_BS0), .CO(n_BC1) );
  ADDFHX1 A08 ( .A(n_EA3), .B(A[5]), .CI(n_EB5), .S(n_BS4), .CO(n_BC5) );
  ADDFHX1 A07 ( .A(n_EA2), .B(A[4]), .CI(n_EB4), .S(n_BS3), .CO(n_BC4) );
  ADDFHX1 A06 ( .A(n_EA1), .B(A[3]), .CI(n_EB3), .S(n_BS2), .CO(n_BC3) );
  ADDFHX1 A05 ( .A(n_EA0), .B(A[2]), .CI(n_EB2), .S(n_BS1), .CO(n_BC2) );
  ADDFHX1 A04 ( .A(A[0]), .B(n_EB0), .CI(n_A_1J), .S(Y[0]), .CO(n_BC0) );
  INV49 A03 ( .A({n_SD3, n_SD2, n_SD1, n_SD0}), .INV(n_A_1J), .Y({n_EB8, n_EB7, 
        n_EB6, n_EB5, n_EB4, n_EB3, n_EB2, n_EB1, n_EB0}) );
  BS042 A02 ( .A(A[5:2]), .SFT(n_A_1K), .Y({n_SD3, n_SD2, n_SD1, n_SD0}) );
  EXPDEC A01 ( .A0(A[6]), .A1(A[7]), .Y({n_EA5, n_EA4, n_EA3, n_EA2, n_EA1, 
        n_EA0}), .INV(n_A_1J), .SFT(n_A_1K) );
endmodule


module EXPDEC ( A0, A1, Y, INV, SFT );
  output [5:0] Y;
  input A0, A1;
  output INV, SFT;
  wire   n_A_0C, n_A_0D;

  BUFX2 A0A ( .A(A0), .Y(n_A_0C) );
  BUFX2 A09 ( .A(A1), .Y(n_A_0D) );
  INVX1 A08 ( .A(n_A_0D), .Y(INV) );
  XOR2X1 A07 ( .A(n_A_0D), .B(n_A_0C), .Y(SFT) );
  BUFX2 A06 ( .A(n_A_0C), .Y(Y[2]) );
  OR2X1 A05 ( .A(n_A_0D), .B(n_A_0C), .Y(Y[3]) );
  NOR2BX2 A04 ( .AN(n_A_0D), .B(n_A_0C), .Y(Y[0]) );
  NOR2BX2 A03 ( .AN(n_A_0D), .B(n_A_0C), .Y(Y[1]) );
  NOR2BX2 A02 ( .AN(n_A_0D), .B(n_A_0C), .Y(Y[4]) );
  AND2X1 A01 ( .A(n_A_0D), .B(n_A_0C), .Y(Y[5]) );
endmodule


module BS042 ( A, SFT, Y );
  input [3:0] A;
  output [3:0] Y;
  input SFT;
  wire   n_A_0E, n_A_0F, n_A_0D;

  TIELO A0L ( .Y(n_A_0E) );
  TIELO A0K ( .Y(n_A_0F) );
  BUFX2 A05 ( .A(SFT), .Y(n_A_0D) );
  MX2X1 A04 ( .S0(n_A_0D), .B(n_A_0F), .A(A[3]), .Y(Y[3]) );
  MX2X1 A03 ( .S0(n_A_0D), .B(n_A_0E), .A(A[2]), .Y(Y[2]) );
  MX2X1 A02 ( .S0(n_A_0D), .B(A[3]), .A(A[1]), .Y(Y[1]) );
  MX2X1 A01 ( .S0(n_A_0D), .B(A[2]), .A(A[0]), .Y(Y[0]) );
endmodule


module INV49 ( A, INV, Y );
  input [3:0] A;
  output [8:0] Y;
  input INV;
  wire   n_A_0G;

  BUFX2 A0A ( .A(n_A_0G), .Y(Y[8]) );
  BUFX2 A09 ( .A(n_A_0G), .Y(Y[7]) );
  BUFX2 A08 ( .A(n_A_0G), .Y(Y[6]) );
  BUFX2 A07 ( .A(n_A_0G), .Y(Y[5]) );
  BUFX2 A06 ( .A(n_A_0G), .Y(Y[4]) );
  XOR2X1 A05 ( .A(A[3]), .B(n_A_0G), .Y(Y[3]) );
  XOR2X1 A04 ( .A(A[2]), .B(n_A_0G), .Y(Y[2]) );
  XOR2X1 A03 ( .A(A[1]), .B(n_A_0G), .Y(Y[1]) );
  XOR2X1 A02 ( .A(A[0]), .B(n_A_0G), .Y(Y[0]) );
  BUFX2 A01 ( .A(INV), .Y(n_A_0G) );
endmodule


module ADD08 ( A, B, S, CO );
  input [7:0] A;
  input [7:0] B;
  output [7:0] S;
  output CO;
  wire   n_PN0, n_PN1, n_PN2, n_PN3, n_PN4, n_PN5, n_PN6, n_GN0, n_GN1, n_GN2,
         n_GN3, n_GN4, n_GN5, n_GN6, n_GN7, n_A_1X, n_A_1R, n_A_1W, n_A_1F,
         n_A_1N, n_A_1P, n_A_1V, n_A_1T, n_A_1U, n_PN7, n_A_1L, n_A_1M, n_A_1E,
         n_A_25, n_A_22, n_A_26, n_A_21, n_A_1J, n_A_1S, n_A_20, n_A_1Y,
         n_A_23, n_A_24;

  XNOR2X2 A100 ( .A(A[0]), .B(B[0]), .Y(n_PN0) );
  XNOR2X2 A101 ( .A(A[1]), .B(B[1]), .Y(n_PN1) );
  XNOR2X2 A102 ( .A(A[2]), .B(B[2]), .Y(n_PN2) );
  XNOR2X2 A103 ( .A(A[3]), .B(B[3]), .Y(n_PN3) );
  XNOR2X2 A104 ( .A(A[4]), .B(B[4]), .Y(n_PN4) );
  XNOR2X2 A105 ( .A(A[5]), .B(B[5]), .Y(n_PN5) );
  XNOR2X2 A106 ( .A(A[6]), .B(B[6]), .Y(n_PN6) );
  NAND2X2 A200 ( .A(A[0]), .B(B[0]), .Y(n_GN0) );
  NAND2X2 A201 ( .A(A[1]), .B(B[1]), .Y(n_GN1) );
  NAND2X2 A202 ( .A(A[2]), .B(B[2]), .Y(n_GN2) );
  NAND2X2 A203 ( .A(A[3]), .B(B[3]), .Y(n_GN3) );
  NAND2X2 A204 ( .A(A[4]), .B(B[4]), .Y(n_GN4) );
  NAND2X2 A205 ( .A(A[5]), .B(B[5]), .Y(n_GN5) );
  NAND2X2 A206 ( .A(A[6]), .B(B[6]), .Y(n_GN6) );
  NAND2X2 A207 ( .A(A[7]), .B(B[7]), .Y(n_GN7) );
  OAI21X1 A06 ( .A0(n_A_1X), .A1(n_A_1R), .B0(n_A_1W), .Y(CO) );
  XNOR2X2 A0P ( .A(n_PN5), .B(n_A_1F), .Y(S[5]) );
  XNOR2X2 A0L ( .A(n_PN3), .B(n_A_1N), .Y(S[3]) );
  XNOR2X2 A0M ( .A(n_PN2), .B(n_A_1P), .Y(S[2]) );
  AOI21X2 A07 ( .A0(n_A_1V), .A1(n_A_1T), .B0(n_A_1U), .Y(n_A_1R) );
  XNOR2X2 A107 ( .A(A[7]), .B(B[7]), .Y(n_PN7) );
  XOR2X2 A0S ( .A(n_PN7), .B(n_A_1L), .Y(S[7]) );
  XOR2X2 A0R ( .A(n_PN6), .B(n_A_1M), .Y(S[6]) );
  XOR2X2 A0N ( .A(n_PN4), .B(n_A_1E), .Y(S[4]) );
  XOR2X2 A0K ( .A(n_PN1), .B(n_GN0), .Y(S[1]) );
  INVX2 A0J ( .A(n_PN0), .Y(S[0]) );
  INVX1 A0H ( .A(n_A_25), .Y(n_A_22) );
  INVX1 A0G ( .A(n_A_26), .Y(n_A_21) );
  INVX1 A0F ( .A(n_A_1J), .Y(n_A_1E) );
  INVX1 A0E ( .A(n_A_1R), .Y(n_A_1J) );
  INVX1 A0D ( .A(n_A_1S), .Y(n_A_1P) );
  INVX1 A0C ( .A(n_A_1T), .Y(n_A_1S) );
  OAI21X1 A0B ( .A0(n_PN4), .A1(n_A_1R), .B0(n_GN4), .Y(n_A_1F) );
  CODD4 A0A ( .GHN(n_GN6), .GLN(n_A_22), .PLN(n_A_21), .PHN(n_PN6), .GO(n_A_1Y), .PO(n_A_20) );
  AOI21X1 A09 ( .A0(n_A_20), .A1(n_A_1J), .B0(n_A_1Y), .Y(n_A_1L) );
  AOI21X1 A08 ( .A0(n_A_23), .A1(n_A_1J), .B0(n_A_24), .Y(n_A_1M) );
  OAI21X1 A05 ( .A0(n_PN2), .A1(n_A_1S), .B0(n_GN2), .Y(n_A_1N) );
  OAI21X1 A04 ( .A0(n_PN1), .A1(n_GN0), .B0(n_GN1), .Y(n_A_1T) );
  ODD8 A03 ( .G2N(n_GN5), .G1N(n_GN4), .G4N(n_GN7), .G3N(n_GN6), .P1N(n_PN4), 
        .P2N(n_PN5), .P3N(n_PN6), .P4N(n_PN7), .YG2(n_A_25), .YG4N(n_A_1W), 
        .YP2(n_A_26), .YP4N(n_A_1X) );
  CODD4 A02 ( .GHN(n_GN5), .GLN(n_GN4), .PLN(n_PN4), .PHN(n_PN5), .GO(n_A_24), 
        .PO(n_A_23) );
  CODD4 A01 ( .GHN(n_GN3), .GLN(n_GN2), .PLN(n_PN2), .PHN(n_PN3), .GO(n_A_1U), 
        .PO(n_A_1V) );
endmodule


module FE10R ( D, TI, RN, TE, CK, EN, Q, TO );
  input [9:0] D;
  output [9:0] Q;
  input TI, RN, TE, CK, EN;
  output TO;
  wire   n_A_10, n_A_0W, n_A_0P;

  BUFX3 A0F ( .A(RN), .Y(n_A_10) );
  BUFX3 A0E ( .A(TE), .Y(n_A_0W) );
  BUFX3 A0C ( .A(EN), .Y(n_A_0P) );
  BUFX2 A0B ( .A(Q[9]), .Y(TO) );
  FE1R A0A ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[8]), .CK(CK), .EN(n_A_0P), .D(
        D[9]), .Q(Q[9]) );
  FE1R A09 ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[7]), .CK(CK), .EN(n_A_0P), .D(
        D[8]), .Q(Q[8]) );
  FE1R A08 ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[6]), .CK(CK), .EN(n_A_0P), .D(
        D[7]), .Q(Q[7]) );
  FE1R A07 ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[5]), .CK(CK), .EN(n_A_0P), .D(
        D[6]), .Q(Q[6]) );
  FE1R A06 ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[4]), .CK(CK), .EN(n_A_0P), .D(
        D[5]), .Q(Q[5]) );
  FE1R A05 ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[3]), .CK(CK), .EN(n_A_0P), .D(
        D[4]), .Q(Q[4]) );
  FE1R A04 ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[2]), .CK(CK), .EN(n_A_0P), .D(
        D[3]), .Q(Q[3]) );
  FE1R A03 ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[1]), .CK(CK), .EN(n_A_0P), .D(
        D[2]), .Q(Q[2]) );
  FE1R A02 ( .RN(n_A_10), .TE(n_A_0W), .TI(Q[0]), .CK(CK), .EN(n_A_0P), .D(
        D[1]), .Q(Q[1]) );
  FE1R A01 ( .RN(n_A_10), .TE(n_A_0W), .TI(TI), .CK(CK), .EN(n_A_0P), .D(D[0]), 
        .Q(Q[0]) );
endmodule


module FE04S ( D, SN, TE, CK, EN, TI, Q, TO );
  input [3:0] D;
  output [3:0] Q;
  input SN, TE, CK, EN, TI;
  output TO;
  wire   n_A_0H, n_A_0J;

  BUFX2 A0G ( .A(EN), .Y(n_A_0H) );
  BUFX2 A0E ( .A(TE), .Y(n_A_0J) );
  BUFX2 A0D ( .A(Q[3]), .Y(TO) );
  FE1S A04 ( .TI(Q[2]), .CK(CK), .TE(n_A_0J), .EN(n_A_0H), .D(D[3]), .SN(SN), 
        .Q(Q[3]) );
  FE1S A03 ( .TI(Q[1]), .CK(CK), .TE(n_A_0J), .EN(n_A_0H), .D(D[2]), .SN(SN), 
        .Q(Q[2]) );
  FE1S A02 ( .TI(Q[0]), .CK(CK), .TE(n_A_0J), .EN(n_A_0H), .D(D[1]), .SN(SN), 
        .Q(Q[1]) );
  FE1S A01 ( .TI(TI), .CK(CK), .TE(n_A_0J), .EN(n_A_0H), .D(D[0]), .SN(SN), 
        .Q(Q[0]) );
endmodule


module FE1S ( TI, CK, TE, EN, D, SN, Q );
  input TI, CK, TE, EN, D, SN;
  output Q;
  wire   n_A_08;

  DFFSHQX1 A01 ( .D(n_A_08), .CK(CK), .SN(SN), .Q(Q) );
  MX2X1 A02 ( .S0(EN), .B(D), .A(Q), .Y(n_A_08) );
endmodule


module DS103 ( B, A, C, S2, S1, Y );
  input [9:0] B;
  input [9:0] A;
  input [9:0] C;
  output [9:0] Y;
  input S2, S1;
  wire   n_A_0A, n_A_0B10, n_A_0B9, n_A_0B8, n_A_0B7, n_A_0B6, n_A_0B5,
         n_A_0B4, n_A_0B3, n_A_0B2, n_A_08, n_A_0B1;

  MX2X1 A10 ( .S0(n_A_0A), .B(B[0]), .A(A[0]), .Y(n_A_0B10) );
  MX2X1 A11 ( .S0(n_A_0A), .B(B[1]), .A(A[1]), .Y(n_A_0B9) );
  MX2X1 A12 ( .S0(n_A_0A), .B(B[2]), .A(A[2]), .Y(n_A_0B8) );
  MX2X1 A13 ( .S0(n_A_0A), .B(B[3]), .A(A[3]), .Y(n_A_0B7) );
  MX2X1 A14 ( .S0(n_A_0A), .B(B[4]), .A(A[4]), .Y(n_A_0B6) );
  MX2X1 A15 ( .S0(n_A_0A), .B(B[5]), .A(A[5]), .Y(n_A_0B5) );
  MX2X1 A16 ( .S0(n_A_0A), .B(B[6]), .A(A[6]), .Y(n_A_0B4) );
  MX2X1 A17 ( .S0(n_A_0A), .B(B[7]), .A(A[7]), .Y(n_A_0B3) );
  MX2X1 A18 ( .S0(n_A_0A), .B(B[8]), .A(A[8]), .Y(n_A_0B2) );
  MX2X2 A20 ( .S0(n_A_08), .B(C[0]), .A(n_A_0B10), .Y(Y[0]) );
  MX2X2 A21 ( .S0(n_A_08), .B(C[1]), .A(n_A_0B9), .Y(Y[1]) );
  MX2X2 A22 ( .S0(n_A_08), .B(C[2]), .A(n_A_0B8), .Y(Y[2]) );
  MX2X2 A23 ( .S0(n_A_08), .B(C[3]), .A(n_A_0B7), .Y(Y[3]) );
  MX2X2 A24 ( .S0(n_A_08), .B(C[4]), .A(n_A_0B6), .Y(Y[4]) );
  MX2X2 A25 ( .S0(n_A_08), .B(C[5]), .A(n_A_0B5), .Y(Y[5]) );
  MX2X2 A26 ( .S0(n_A_08), .B(C[6]), .A(n_A_0B4), .Y(Y[6]) );
  MX2X2 A27 ( .S0(n_A_08), .B(C[7]), .A(n_A_0B3), .Y(Y[7]) );
  MX2X2 A28 ( .S0(n_A_08), .B(C[8]), .A(n_A_0B2), .Y(Y[8]) );
  BUFX4 A06 ( .A(S1), .Y(n_A_0A) );
  BUFX4 A05 ( .A(S2), .Y(n_A_08) );
  MX2X2 A29 ( .S0(n_A_08), .B(C[9]), .A(n_A_0B1), .Y(Y[9]) );
  MX2X1 A19 ( .S0(n_A_0A), .B(B[9]), .A(A[9]), .Y(n_A_0B1) );
endmodule


module MSIV ( A, Y );
  input [3:0] A;
  output [3:0] Y;


  BUFX2 A04 ( .A(A[0]), .Y(Y[0]) );
  BUFX2 A03 ( .A(A[1]), .Y(Y[1]) );
  BUFX2 A02 ( .A(A[2]), .Y(Y[2]) );
  INVX1 A01 ( .A(A[3]), .Y(Y[3]) );
endmodule


module BS205L ( D, SFT, U4SFT, Y );
  input [22:0] D;
  input [3:0] SFT;
  output [19:0] Y;
  input U4SFT;
  wire   n_A_11, n_A_10, n_A_17, n_A_16, n_A_2D, n_A_3X, n_A_3W, n_A_18,
         n_A_1A, n_A_19, n_A_1B, n_A_31, n_A_14, n_A_13, n_A_1C, n_A_1P,
         n_A_2N, n_A_1E, n_A_29, n_A_1M, n_A_4N, n_A_1D, n_A_1U, n_A_1J,
         n_A_0V, n_A_21, n_A_1W, n_A_1Y, n_A_1V, n_A_0U, n_A_0W, n_A_4U,
         n_A_4T, n_A_4S, n_A_4R, n_A_4P, n_A_3J, n_A_2H, n_A_2K, n_A_20,
         n_A_1F, n_A_2E, n_A_1T, n_A_2J, n_A_2L, n_A_0Y, n_A_0X, n_A_2B,
         n_A_2C, n_A_3H, n_A_2F, n_A_25, n_A_4L, n_A_26, n_A_4K, n_A_27,
         n_A_1L, n_A_28, n_A_2G, n_A_24, n_A_23, n_A_1N, n_A_22, n_A_4M,
         n_A_1G, n_A_2M, n_A_1K, n_A_3K, n_A_34, n_A_33, n_A_12, n_A_32,
         n_A_15, n_A_38, n_A_37, n_A_36, n_A_35, n_A_3C, n_A_3B, n_A_3A,
         n_A_39, n_A_3G, n_A_3F, n_A_3E, n_A_3D, n_A_42, n_A_40, n_A_41,
         n_A_3Y, n_A_46, n_A_44, n_A_45, n_A_43, n_A_48, n_A_3R, n_A_47,
         n_A_3P, n_A_4C, n_A_4A, n_A_4B, n_A_49, n_A_4F, n_A_4E, n_A_4D;

  TIELO A20 ( .Y(n_A_11) );
  DS32 A06 ( .S(n_A_10), .B2(n_A_11), .A2(D[0]), .B1(D[0]), .A1(D[1]), .B0(
        D[1]), .A0(D[2]), .Y2(n_A_2D), .Y1(n_A_16), .Y0(n_A_17) );
  DS32 A0C ( .S(n_A_18), .B2(n_A_2D), .A2(n_A_17), .B1(n_A_16), .A1(n_A_3W), 
        .B0(n_A_17), .A0(n_A_3X), .Y2(n_A_1B), .Y1(n_A_19), .Y0(n_A_1A) );
  DS32 A0K ( .S(n_A_1C), .B2(n_A_1B), .A2(n_A_13), .B1(n_A_19), .A1(n_A_14), 
        .B0(n_A_1A), .A0(n_A_31), .Y2(n_A_1E), .Y1(n_A_2N), .Y0(n_A_1P) );
  DS32 A0N ( .S(n_A_1D), .B2(n_A_1E), .A2(n_A_4N), .B1(n_A_2N), .A1(n_A_1M), 
        .B0(n_A_1P), .A0(n_A_29), .Y2(n_A_0V), .Y1(n_A_1J), .Y0(n_A_1U) );
  DS33 A31 ( .A0(n_A_21), .B0(n_A_1U), .C0(n_A_1W), .C2(n_A_1W), .A2(n_A_1V), 
        .C1(n_A_1W), .B1(n_A_1J), .S0(n_A_0U), .S1(n_A_0W), .B2(n_A_0V), .A1(
        n_A_1Y), .Y2(Y[0]), .Y1(Y[1]), .Y0(Y[2]) );
  OFD04 A32 ( .D3(n_A_4P), .D2(n_A_4R), .EN(n_A_0U), .D1(n_A_4S), .D0(n_A_4T), 
        .PD(n_A_4U), .OF(n_A_0W) );
  BUFX2 A0R ( .A(SFT[3]), .Y(n_A_1D) );
  BUFX2 A34 ( .A(n_A_4U), .Y(Y[19]) );
  BUFX2 A33 ( .A(U4SFT), .Y(n_A_0U) );
  DS43 A30 ( .A0(n_A_3J), .B0(n_A_21), .C0(n_A_1W), .B3(n_A_1F), .A3(n_A_20), 
        .C2(n_A_1W), .A2(n_A_2K), .C1(n_A_1W), .B1(n_A_1Y), .S0(n_A_0U), .S1(
        n_A_0W), .C3(n_A_1W), .B2(n_A_1V), .A1(n_A_2H), .Y3(Y[3]), .Y2(Y[4]), 
        .Y1(Y[5]), .Y0(Y[6]) );
  DS43 A2R ( .A0(n_A_2E), .B0(n_A_3J), .C0(n_A_1W), .B3(n_A_20), .A3(n_A_2L), 
        .C2(n_A_1W), .A2(n_A_2J), .C1(n_A_1W), .B1(n_A_2H), .S0(n_A_0U), .S1(
        n_A_0W), .C3(n_A_1W), .B2(n_A_2K), .A1(n_A_1T), .Y3(Y[7]), .Y2(Y[8]), 
        .Y1(Y[9]), .Y0(Y[10]) );
  DS43 A0T ( .A0(n_A_0Y), .B0(n_A_2E), .C0(n_A_1W), .B3(n_A_2L), .A3(n_A_2C), 
        .C2(n_A_1W), .A2(n_A_2B), .C1(n_A_1W), .B1(n_A_1T), .S0(n_A_0U), .S1(
        n_A_0W), .C3(n_A_1W), .B2(n_A_2J), .A1(n_A_0X), .Y3(Y[11]), .Y2(Y[12]), 
        .Y1(Y[13]), .Y0(Y[14]) );
  DS43 A0S ( .A0(n_A_4T), .B0(n_A_0Y), .C0(n_A_1W), .B3(n_A_2C), .A3(n_A_4P), 
        .C2(n_A_1W), .A2(n_A_4R), .C1(n_A_1W), .B1(n_A_0X), .S0(n_A_0U), .S1(
        n_A_0W), .C3(n_A_1W), .B2(n_A_2B), .A1(n_A_4S), .Y3(Y[15]), .Y2(Y[16]), 
        .Y1(Y[17]), .Y0(Y[18]) );
  BUFX2 A0X ( .A(n_A_3H), .Y(n_A_2F) );
  DS42 A0M ( .S(n_A_1D), .B3(n_A_2G), .A3(n_A_28), .B2(n_A_1L), .A2(n_A_27), 
        .B1(n_A_4K), .A1(n_A_26), .B0(n_A_4L), .A0(n_A_25), .Y3(n_A_1F), .Y2(
        n_A_1V), .Y1(n_A_1Y), .Y0(n_A_21) );
  DS42 A15 ( .S(n_A_1D), .B3(n_A_4M), .A3(n_A_22), .B2(n_A_4N), .A2(n_A_1N), 
        .B1(n_A_1M), .A1(n_A_23), .B0(n_A_29), .A0(n_A_24), .Y3(n_A_20), .Y2(
        n_A_2K), .Y1(n_A_2H), .Y0(n_A_3J) );
  DS42 A14 ( .S(n_A_1D), .B3(n_A_28), .A3(n_A_3K), .B2(n_A_27), .A2(n_A_1K), 
        .B1(n_A_26), .A1(n_A_2M), .B0(n_A_25), .A0(n_A_1G), .Y3(n_A_2L), .Y2(
        n_A_2J), .Y1(n_A_1T), .Y0(n_A_2E) );
  DS42 A16 ( .S(n_A_1D), .B3(n_A_22), .A3(n_A_2F), .B2(n_A_1N), .A2(n_A_2F), 
        .B1(n_A_23), .A1(n_A_2F), .B0(n_A_24), .A0(n_A_2F), .Y3(n_A_2C), .Y2(
        n_A_2B), .Y1(n_A_0X), .Y0(n_A_0Y) );
  DS42 A17 ( .S(n_A_1D), .B3(n_A_3K), .A3(n_A_2F), .B2(n_A_1K), .A2(n_A_2F), 
        .B1(n_A_2M), .A1(n_A_2F), .B0(n_A_1G), .A0(n_A_2F), .Y3(n_A_4P), .Y2(
        n_A_4R), .Y1(n_A_4S), .Y0(n_A_4T) );
  INVX8 A10 ( .A(n_A_4U), .Y(n_A_1W) );
  DS42 A0J ( .S(n_A_1C), .B3(n_A_15), .A3(n_A_32), .B2(n_A_13), .A2(n_A_12), 
        .B1(n_A_14), .A1(n_A_33), .B0(n_A_31), .A0(n_A_34), .Y3(n_A_2G), .Y2(
        n_A_1L), .Y1(n_A_4K), .Y0(n_A_4L) );
  DS42 A0H ( .S(n_A_1C), .B3(n_A_32), .A3(n_A_35), .B2(n_A_12), .A2(n_A_36), 
        .B1(n_A_33), .A1(n_A_37), .B0(n_A_34), .A0(n_A_38), .Y3(n_A_4M), .Y2(
        n_A_4N), .Y1(n_A_1M), .Y0(n_A_29) );
  DS42 A0G ( .S(n_A_1C), .B3(n_A_35), .A3(n_A_39), .B2(n_A_36), .A2(n_A_3A), 
        .B1(n_A_37), .A1(n_A_3B), .B0(n_A_38), .A0(n_A_3C), .Y3(n_A_28), .Y2(
        n_A_27), .Y1(n_A_26), .Y0(n_A_25) );
  DS42 A0F ( .S(n_A_1C), .B3(n_A_39), .A3(n_A_3D), .B2(n_A_3A), .A2(n_A_3E), 
        .B1(n_A_3B), .A1(n_A_3F), .B0(n_A_3C), .A0(n_A_3G), .Y3(n_A_22), .Y2(
        n_A_1N), .Y1(n_A_23), .Y0(n_A_24) );
  DS42 A0E ( .S(n_A_1C), .B3(n_A_3D), .A3(n_A_3H), .B2(n_A_3E), .A2(n_A_3H), 
        .B1(n_A_3F), .A1(n_A_3H), .B0(n_A_3G), .A0(n_A_3H), .Y3(n_A_3K), .Y2(
        n_A_1K), .Y1(n_A_2M), .Y0(n_A_1G) );
  DS42 A0B ( .S(n_A_18), .B3(n_A_3W), .A3(n_A_3Y), .B2(n_A_3X), .A2(n_A_40), 
        .B1(n_A_3Y), .A1(n_A_41), .B0(n_A_40), .A0(n_A_42), .Y3(n_A_15), .Y2(
        n_A_13), .Y1(n_A_14), .Y0(n_A_31) );
  DS42 A0A ( .S(n_A_18), .B3(n_A_41), .A3(n_A_43), .B2(n_A_42), .A2(n_A_44), 
        .B1(n_A_43), .A1(n_A_45), .B0(n_A_44), .A0(n_A_46), .Y3(n_A_32), .Y2(
        n_A_12), .Y1(n_A_33), .Y0(n_A_34) );
  DS42 A09 ( .S(n_A_18), .B3(n_A_45), .A3(n_A_3P), .B2(n_A_46), .A2(n_A_3R), 
        .B1(n_A_3P), .A1(n_A_47), .B0(n_A_3R), .A0(n_A_48), .Y3(n_A_35), .Y2(
        n_A_36), .Y1(n_A_37), .Y0(n_A_38) );
  DS42 A08 ( .S(n_A_18), .B3(n_A_47), .A3(n_A_49), .B2(n_A_48), .A2(n_A_4A), 
        .B1(n_A_49), .A1(n_A_4B), .B0(n_A_4A), .A0(n_A_4C), .Y3(n_A_39), .Y2(
        n_A_3A), .Y1(n_A_3B), .Y0(n_A_3C) );
  DS42 A07 ( .S(n_A_18), .B3(n_A_4B), .A3(n_A_4D), .B2(n_A_4C), .A2(n_A_4E), 
        .B1(n_A_4D), .A1(n_A_4F), .B0(n_A_4E), .A0(n_A_4F), .Y3(n_A_3D), .Y2(
        n_A_3E), .Y1(n_A_3F), .Y0(n_A_3G) );
  DS42 A05 ( .S(n_A_10), .B3(D[2]), .A3(D[3]), .B2(D[3]), .A2(D[4]), .B1(D[4]), 
        .A1(D[5]), .B0(D[5]), .A0(D[6]), .Y3(n_A_3W), .Y2(n_A_3X), .Y1(n_A_3Y), 
        .Y0(n_A_40) );
  DS42 A04 ( .S(n_A_10), .B3(D[6]), .A3(D[7]), .B2(D[7]), .A2(D[8]), .B1(D[8]), 
        .A1(D[9]), .B0(D[9]), .A0(D[10]), .Y3(n_A_41), .Y2(n_A_42), .Y1(n_A_43), .Y0(n_A_44) );
  DS42 A03 ( .S(n_A_10), .B3(D[10]), .A3(D[11]), .B2(D[11]), .A2(D[12]), .B1(
        D[12]), .A1(D[13]), .B0(D[13]), .A0(D[14]), .Y3(n_A_45), .Y2(n_A_46), 
        .Y1(n_A_3P), .Y0(n_A_3R) );
  DS42 A02 ( .S(n_A_10), .B3(D[14]), .A3(D[15]), .B2(D[15]), .A2(D[16]), .B1(
        D[16]), .A1(D[17]), .B0(D[17]), .A0(D[18]), .Y3(n_A_47), .Y2(n_A_48), 
        .Y1(n_A_49), .Y0(n_A_4A) );
  DS42 A01 ( .S(n_A_10), .B3(D[18]), .A3(D[19]), .B2(D[19]), .A2(D[20]), .B1(
        D[20]), .A1(D[21]), .B0(D[21]), .A0(D[22]), .Y3(n_A_4B), .Y2(n_A_4C), 
        .Y1(n_A_4D), .Y0(n_A_4E) );
  BUFX2 A13 ( .A(SFT[2]), .Y(n_A_1C) );
  BUFX2 A12 ( .A(SFT[1]), .Y(n_A_18) );
  BUFX2 A11 ( .A(SFT[0]), .Y(n_A_10) );
  BUFX2 A0Y ( .A(n_A_2F), .Y(n_A_4U) );
  BUFX2 A0W ( .A(n_A_4F), .Y(n_A_3H) );
  BUFX2 A0V ( .A(D[22]), .Y(n_A_4F) );
endmodule


module DS43 ( A0, B0, C0, B3, A3, C2, A2, C1, B1, S0, S1, C3, B2, A1, Y3, Y2, 
        Y1, Y0 );
  input A0, B0, C0, B3, A3, C2, A2, C1, B1, S0, S1, C3, B2, A1;
  output Y3, Y2, Y1, Y0;
  wire   n_A_0M, n_A_0J, n_A_0K, n_A_0N, n_A_0P, n_A_0R;

  MX2X1 A0L ( .S0(n_A_0J), .B(C0), .A(n_A_0M), .Y(Y0) );
  MX2X1 A0K ( .S0(n_A_0K), .B(B0), .A(A0), .Y(n_A_0M) );
  MX2X1 A0J ( .S0(n_A_0J), .B(C1), .A(n_A_0N), .Y(Y1) );
  MX2X1 A0H ( .S0(n_A_0K), .B(B1), .A(A1), .Y(n_A_0N) );
  MX2X1 A0G ( .S0(n_A_0J), .B(C2), .A(n_A_0P), .Y(Y2) );
  MX2X1 A02 ( .S0(n_A_0K), .B(B2), .A(A2), .Y(n_A_0P) );
  MX2X1 A01 ( .S0(n_A_0J), .B(C3), .A(n_A_0R), .Y(Y3) );
  MX2X1 A0B ( .S0(n_A_0K), .B(B3), .A(A3), .Y(n_A_0R) );
  BUFX2 A04 ( .A(S0), .Y(n_A_0K) );
  BUFX2 A03 ( .A(S1), .Y(n_A_0J) );
endmodule


module OFD04 ( D3, D2, EN, D1, D0, PD, OF );
  input D3, D2, EN, D1, D0, PD;
  output OF;
  wire   n_A_06, n_A_04, n_A_09, n_A_0A, n_A_0B, n_A_03;

  BUFX2 A0E ( .A(PD), .Y(n_A_06) );
  XOR2X1 A0B ( .A(n_A_06), .B(D3), .Y(n_A_04) );
  XOR2X1 A0A ( .A(n_A_06), .B(D2), .Y(n_A_09) );
  OR4X1 A03 ( .A(n_A_0B), .B(n_A_0A), .C(n_A_09), .D(n_A_04), .Y(n_A_03) );
  AND2X2 A04 ( .A(n_A_03), .B(EN), .Y(OF) );
  XOR2X1 A02 ( .A(n_A_06), .B(D1), .Y(n_A_0A) );
  XOR2X1 A01 ( .A(n_A_06), .B(D0), .Y(n_A_0B) );
endmodule


module DS33 ( A0, B0, C0, C2, A2, C1, B1, S0, S1, B2, A1, Y2, Y1, Y0 );
  input A0, B0, C0, C2, A2, C1, B1, S0, S1, B2, A1;
  output Y2, Y1, Y0;
  wire   n_A_0M, n_A_0J, n_A_0K, n_A_0N, n_A_0P;

  MX2X1 A0L ( .S0(n_A_0J), .B(C0), .A(n_A_0M), .Y(Y0) );
  MX2X1 A0K ( .S0(n_A_0K), .B(B0), .A(A0), .Y(n_A_0M) );
  MX2X1 A0J ( .S0(n_A_0J), .B(C1), .A(n_A_0N), .Y(Y1) );
  MX2X1 A0H ( .S0(n_A_0K), .B(B1), .A(A1), .Y(n_A_0N) );
  MX2X1 A0G ( .S0(n_A_0J), .B(C2), .A(n_A_0P), .Y(Y2) );
  MX2X1 A02 ( .S0(n_A_0K), .B(B2), .A(A2), .Y(n_A_0P) );
  BUFX2 A04 ( .A(S0), .Y(n_A_0K) );
  BUFX2 A03 ( .A(S1), .Y(n_A_0J) );
endmodule


module DSL20 ( A, S, Y );
  input [19:0] A;
  output [19:0] Y;
  input S;
  wire   n_A_19, n_A_1B;

  AND2X1 A100 ( .A(A[0]), .B(n_A_19), .Y(Y[0]) );
  AND2X1 A101 ( .A(A[1]), .B(n_A_19), .Y(Y[1]) );
  AND2X1 A102 ( .A(A[2]), .B(n_A_19), .Y(Y[2]) );
  AND2X1 A103 ( .A(A[3]), .B(n_A_19), .Y(Y[3]) );
  AND2X1 A104 ( .A(A[4]), .B(n_A_19), .Y(Y[4]) );
  AND2X1 A105 ( .A(A[5]), .B(n_A_19), .Y(Y[5]) );
  AND2X1 A106 ( .A(A[6]), .B(n_A_19), .Y(Y[6]) );
  INVX2 A1S ( .A(n_A_1B), .Y(n_A_19) );
  MX2X1 A00J ( .S0(n_A_1B), .B(A[11]), .A(A[19]), .Y(Y[19]) );
  MX2X1 A00H ( .S0(n_A_1B), .B(A[10]), .A(A[18]), .Y(Y[18]) );
  BUFX4 A111 ( .A(S), .Y(n_A_1B) );
  AND2X1 A107 ( .A(A[7]), .B(n_A_19), .Y(Y[7]) );
  MX2X1 A00A ( .S0(n_A_1B), .B(A[9]), .A(A[17]), .Y(Y[17]) );
  MX2X1 A009 ( .S0(n_A_1B), .B(A[8]), .A(A[16]), .Y(Y[16]) );
  MX2X1 A008 ( .S0(n_A_1B), .B(A[7]), .A(A[15]), .Y(Y[15]) );
  MX2X1 A007 ( .S0(n_A_1B), .B(A[6]), .A(A[14]), .Y(Y[14]) );
  MX2X1 A006 ( .S0(n_A_1B), .B(A[5]), .A(A[13]), .Y(Y[13]) );
  MX2X1 A005 ( .S0(n_A_1B), .B(A[4]), .A(A[12]), .Y(Y[12]) );
  MX2X1 A004 ( .S0(n_A_1B), .B(A[3]), .A(A[11]), .Y(Y[11]) );
  MX2X1 A003 ( .S0(n_A_1B), .B(A[2]), .A(A[10]), .Y(Y[10]) );
  MX2X1 A002 ( .S0(n_A_1B), .B(A[1]), .A(A[9]), .Y(Y[9]) );
  MX2X1 A001 ( .S0(n_A_1B), .B(A[0]), .A(A[8]), .Y(Y[8]) );
endmodule


module DSH12 ( D, S, Y );
  input [23:0] D;
  output [19:0] Y;
  input S;
  wire   n_A_1A, n_A_17;

  AND2X1 Y0 ( .A(D[0]), .B(n_A_1A), .Y(Y[0]) );
  AND2X1 Y1 ( .A(D[1]), .B(n_A_1A), .Y(Y[1]) );
  AND2X1 Y2 ( .A(D[2]), .B(n_A_1A), .Y(Y[2]) );
  AND2X1 Y3 ( .A(D[3]), .B(n_A_1A), .Y(Y[3]) );
  AND2X1 Y4 ( .A(D[4]), .B(n_A_1A), .Y(Y[4]) );
  AND2X1 Y5 ( .A(D[5]), .B(n_A_1A), .Y(Y[5]) );
  AND2X1 Y6 ( .A(D[6]), .B(n_A_1A), .Y(Y[6]) );
  INVX2 A1T ( .A(S), .Y(n_A_1A) );
  BUFX4 A1S ( .A(S), .Y(n_A_17) );
  AND2X1 Y7 ( .A(D[7]), .B(n_A_1A), .Y(Y[7]) );
  MX2X1 A0C ( .S0(n_A_17), .B(D[12]), .A(D[8]), .Y(Y[8]) );
  MX2X1 A0B ( .S0(n_A_17), .B(D[13]), .A(D[9]), .Y(Y[9]) );
  MX2X1 A0A ( .S0(n_A_17), .B(D[14]), .A(D[10]), .Y(Y[10]) );
  MX2X1 A09 ( .S0(n_A_17), .B(D[15]), .A(D[11]), .Y(Y[11]) );
  MX2X1 A08 ( .S0(n_A_17), .B(D[16]), .A(D[12]), .Y(Y[12]) );
  MX2X1 A07 ( .S0(n_A_17), .B(D[17]), .A(D[13]), .Y(Y[13]) );
  MX2X1 A06 ( .S0(n_A_17), .B(D[18]), .A(D[14]), .Y(Y[14]) );
  MX2X1 A05 ( .S0(n_A_17), .B(D[19]), .A(D[15]), .Y(Y[15]) );
  MX2X1 A04 ( .S0(n_A_17), .B(D[20]), .A(D[16]), .Y(Y[16]) );
  MX2X1 A03 ( .S0(n_A_17), .B(D[21]), .A(D[17]), .Y(Y[17]) );
  MX2X1 A02 ( .S0(n_A_17), .B(D[22]), .A(D[18]), .Y(Y[18]) );
  MX2X1 A01 ( .S0(n_A_17), .B(D[23]), .A(D[19]), .Y(Y[19]) );
endmodule


module TIMCT ( TDB, PMD, TIMO, TIMEA, PMA, MCK, TSCST, TI, XRST, TE, TIMLIS, 
        TIMLWE, TLWREQ, TIMHWE, THWREQ, TPWEN, ENP, TIMI, TIMA, TO, TLWRDY, 
        THWRDY, XTIMWE );
  input [23:0] TDB;
  input [11:0] PMD;
  input [23:0] TIMO;
  input [8:0] TIMEA;
  input [8:0] PMA;
  output [23:0] TIMI;
  output [8:0] TIMA;
  input MCK, TSCST, TI, XRST, TE, TIMLIS, TIMLWE, TLWREQ, TIMHWE, THWREQ,
         TPWEN, ENP;
  output TO, TLWRDY, THWRDY, XTIMWE;
  wire   n_A_1H, n_A_1J, n_A_0V, n_A_0N, n_A_11, n_A_0S, n_A_0B, n_A_1G,
         n_A_13, n_A_0T, n_A_0R, n_A_0D, n_A_1A, n_A_0L, n_A_12, n_A_1K,
         n_A_15, n_A_181, n_A_182, n_A_183, n_A_184, n_A_185, n_A_186, n_A_187,
         n_A_188, n_A_189, n_A_1810, n_A_1811, n_A_1812;

  DS123 A01 ( .A(TDB[23:12]), .B(PMD), .C(TIMO[23:12]), .S1(n_A_1J), .S0(
        n_A_1H), .Y(TIMI[23:12]) );
  OR2X2 A15 ( .A(ENP), .B(n_A_0V), .Y(n_A_0N) );
  INVX1 A1E ( .A(TSCST), .Y(n_A_0V) );
  NAND2X1 A0M ( .A(n_A_1J), .B(n_A_11), .Y(n_A_0S) );
  NOR2X1 A0F ( .A(TIMHWE), .B(n_A_0B), .Y(n_A_1J) );
  NOR2X1 A0G ( .A(n_A_1G), .B(TIMLWE), .Y(n_A_11) );
  AND2X1 A0L ( .A(THWREQ), .B(TLWREQ), .Y(n_A_13) );
  NAND2X2 A0N ( .A(n_A_0N), .B(n_A_0S), .Y(XTIMWE) );
  NAND2X1 A1J ( .A(TLWREQ), .B(n_A_0T), .Y(n_A_0R) );
  NAND2X1 A1G ( .A(THWREQ), .B(n_A_0D), .Y(n_A_1A) );
  AND2X2 A0B ( .A(n_A_0N), .B(n_A_1G), .Y(TLWRDY) );
  AND2X2 A0C ( .A(n_A_0B), .B(n_A_0N), .Y(THWRDY) );
  BUFX2 A1R ( .A(XRST), .Y(n_A_0L) );
  FE1R A1P ( .RN(n_A_0L), .TE(TE), .TI(n_A_0D), .CK(MCK), .EN(n_A_0N), .D(
        TLWREQ), .Q(n_A_0T) );
  FE1R A1F ( .RN(n_A_0L), .TE(TE), .TI(TI), .CK(MCK), .EN(n_A_0N), .D(THWREQ), 
        .Q(n_A_0D) );
  BUFX2 A0S ( .A(TSCST), .Y(n_A_12) );
  OR2X1 A0H ( .A(n_A_12), .B(n_A_13), .Y(n_A_1K) );
  NAND2X2 A08 ( .A(n_A_15), .B(n_A_1K), .Y(n_A_1H) );
  DS092 A1K ( .A(TIMEA), .B(PMA), .S(n_A_1H), .Y(TIMA) );
  BUFX2 A16 ( .A(n_A_0T), .Y(TO) );
  NAND2X1 A0J ( .A(TPWEN), .B(n_A_12), .Y(n_A_15) );
  OAI22X1 A0E ( .A0(n_A_15), .A1(n_A_0R), .B0(n_A_0R), .B1(n_A_12), .Y(n_A_1G)
         );
  OAI22X1 A0D ( .A0(n_A_15), .A1(n_A_1A), .B0(n_A_1A), .B1(n_A_12), .Y(n_A_0B)
         );
  DS122 A03 ( .B(TDB[19:8]), .A(TDB[11:0]), .S(TIMLIS), .Y({n_A_181, n_A_182, 
        n_A_183, n_A_184, n_A_185, n_A_186, n_A_187, n_A_188, n_A_189, 
        n_A_1810, n_A_1811, n_A_1812}) );
  DS123 A02 ( .A({n_A_181, n_A_182, n_A_183, n_A_184, n_A_185, n_A_186, 
        n_A_187, n_A_188, n_A_189, n_A_1810, n_A_1811, n_A_1812}), .B(PMD), 
        .C(TIMO[11:0]), .S1(n_A_11), .S0(n_A_1H), .Y(TIMI[11:0]) );
endmodule


module DS122 ( B, A, S, Y );
  input [11:0] B;
  input [11:0] A;
  output [11:0] Y;
  input S;
  wire   n_A_05;

  MX2X2 A100 ( .S0(n_A_05), .B(B[0]), .A(A[0]), .Y(Y[0]) );
  MX2X2 A101 ( .S0(n_A_05), .B(B[1]), .A(A[1]), .Y(Y[1]) );
  MX2X2 A102 ( .S0(n_A_05), .B(B[2]), .A(A[2]), .Y(Y[2]) );
  MX2X2 A103 ( .S0(n_A_05), .B(B[3]), .A(A[3]), .Y(Y[3]) );
  MX2X2 A104 ( .S0(n_A_05), .B(B[4]), .A(A[4]), .Y(Y[4]) );
  MX2X2 A105 ( .S0(n_A_05), .B(B[5]), .A(A[5]), .Y(Y[5]) );
  MX2X2 A106 ( .S0(n_A_05), .B(B[6]), .A(A[6]), .Y(Y[6]) );
  MX2X2 A107 ( .S0(n_A_05), .B(B[7]), .A(A[7]), .Y(Y[7]) );
  MX2X2 A108 ( .S0(n_A_05), .B(B[8]), .A(A[8]), .Y(Y[8]) );
  MX2X2 A109 ( .S0(n_A_05), .B(B[9]), .A(A[9]), .Y(Y[9]) );
  MX2X2 A110 ( .S0(n_A_05), .B(B[10]), .A(A[10]), .Y(Y[10]) );
  BUFX3 A003 ( .A(S), .Y(n_A_05) );
  MX2X2 A111 ( .S0(n_A_05), .B(B[11]), .A(A[11]), .Y(Y[11]) );
endmodule


module DS123 ( A, B, C, S1, S0, Y );
  input [11:0] A;
  input [11:0] B;
  input [11:0] C;
  output [11:0] Y;
  input S1, S0;
  wire   n_A_0A, n_A_0812, n_A_0811, n_A_0810, n_A_089, n_A_088, n_A_087,
         n_A_086, n_A_085, n_A_084, n_A_083, n_A_082, n_A_07, n_A_081;

  MX2X1 A100 ( .S0(n_A_0A), .B(B[0]), .A(A[0]), .Y(n_A_0812) );
  MX2X1 A101 ( .S0(n_A_0A), .B(B[1]), .A(A[1]), .Y(n_A_0811) );
  MX2X1 A102 ( .S0(n_A_0A), .B(B[2]), .A(A[2]), .Y(n_A_0810) );
  MX2X1 A103 ( .S0(n_A_0A), .B(B[3]), .A(A[3]), .Y(n_A_089) );
  MX2X1 A104 ( .S0(n_A_0A), .B(B[4]), .A(A[4]), .Y(n_A_088) );
  MX2X1 A105 ( .S0(n_A_0A), .B(B[5]), .A(A[5]), .Y(n_A_087) );
  MX2X1 A106 ( .S0(n_A_0A), .B(B[6]), .A(A[6]), .Y(n_A_086) );
  MX2X1 A107 ( .S0(n_A_0A), .B(B[7]), .A(A[7]), .Y(n_A_085) );
  MX2X1 A108 ( .S0(n_A_0A), .B(B[8]), .A(A[8]), .Y(n_A_084) );
  MX2X1 A109 ( .S0(n_A_0A), .B(B[9]), .A(A[9]), .Y(n_A_083) );
  MX2X1 A110 ( .S0(n_A_0A), .B(B[10]), .A(A[10]), .Y(n_A_082) );
  MX2X1 A200 ( .S0(n_A_07), .B(C[0]), .A(n_A_0812), .Y(Y[0]) );
  MX2X1 A201 ( .S0(n_A_07), .B(C[1]), .A(n_A_0811), .Y(Y[1]) );
  MX2X1 A202 ( .S0(n_A_07), .B(C[2]), .A(n_A_0810), .Y(Y[2]) );
  MX2X1 A203 ( .S0(n_A_07), .B(C[3]), .A(n_A_089), .Y(Y[3]) );
  MX2X1 A204 ( .S0(n_A_07), .B(C[4]), .A(n_A_088), .Y(Y[4]) );
  MX2X1 A205 ( .S0(n_A_07), .B(C[5]), .A(n_A_087), .Y(Y[5]) );
  MX2X1 A206 ( .S0(n_A_07), .B(C[6]), .A(n_A_086), .Y(Y[6]) );
  MX2X1 A207 ( .S0(n_A_07), .B(C[7]), .A(n_A_085), .Y(Y[7]) );
  MX2X1 A208 ( .S0(n_A_07), .B(C[8]), .A(n_A_084), .Y(Y[8]) );
  MX2X1 A209 ( .S0(n_A_07), .B(C[9]), .A(n_A_083), .Y(Y[9]) );
  MX2X1 A210 ( .S0(n_A_07), .B(C[10]), .A(n_A_082), .Y(Y[10]) );
  BUFX3 A006 ( .A(S0), .Y(n_A_0A) );
  BUFX3 A005 ( .A(S1), .Y(n_A_07) );
  MX2X1 A211 ( .S0(n_A_07), .B(C[11]), .A(n_A_081), .Y(Y[11]) );
  MX2X1 A111 ( .S0(n_A_0A), .B(B[11]), .A(A[11]), .Y(n_A_081) );
endmodule


module TDBMX ( WEO, TSO, TIMO, TACO, TIMEXEN, TACEN, TCSEL, XRST, TE, TC2LE, 
        TC1LE, TIMLLEN, TI, TIMLLLE, MCK, TIMHLEN, TSOEN, WEOEN, TCO, TDB, TO
 );
  input [19:0] WEO;
  input [19:0] TSO;
  input [23:0] TIMO;
  input [19:0] TACO;
  output [19:0] TCO;
  output [23:0] TDB;
  input TIMEXEN, TACEN, TCSEL, XRST, TE, TC2LE, TC1LE, TIMLLEN, TI, TIMLLLE,
         MCK, TIMHLEN, TSOEN, WEOEN;
  output TO;
  wire   n_A_17, n_A_1D20, n_A_1D19, n_A_1D18, n_A_1D17, n_A_1D16, n_A_1D15,
         n_A_1D14, n_A_1D13, n_A_1D12, n_A_1D11, n_A_1D10, n_A_1D9, n_A_1D8,
         n_A_1D7, n_A_1D6, n_A_1D5, n_A_1D4, n_A_1D3, n_A_1D2, n_A_1D1, n_A_11,
         n_A_1E20, n_A_1E19, n_A_1E18, n_A_1E17, n_A_1E16, n_A_1E15, n_A_1E14,
         n_A_1E13, n_A_1E12, n_A_1E11, n_A_1E10, n_A_1E9, n_A_1E8, n_A_1E7,
         n_A_1E6, n_A_1E5, n_A_1E4, n_A_1E3, n_A_1E2, n_A_1E1, n_A_0X,
         n_A_1B20, n_A_1B19, n_A_1B18, n_A_1B17, n_A_1B16, n_A_1B15, n_A_1B14,
         n_A_1B13, n_A_1B12, n_A_1B11, n_A_1B10, n_A_1B9, n_A_1B8, n_A_1B7,
         n_A_1B6, n_A_1B5, n_A_1B4, n_A_1B3, n_A_1B2, n_A_1B1, n_LL00, n_A_1H,
         n_A_0K20, n_LL01, n_A_0K19, n_LL02, n_A_0K18, n_LL03, n_A_0K17,
         n_LL04, n_A_0K16, n_LL05, n_A_0K15, n_LL06, n_A_0K14, n_LL07,
         n_A_0K13, n_LL08, n_A_0K12, n_LL09, n_A_0K11, n_LL10, n_A_0K10,
         n_LL11, n_A_0K9, n_LL12, n_A_0K8, n_LL13, n_A_0K7, n_LL14, n_A_0K6,
         n_LL15, n_A_0K5, n_LL16, n_A_0K4, n_LL17, n_A_0K3, n_LL18, n_A_0K2,
         n_LL19, n_A_0K1, n_A_0F, n_A_0H, n_A_0D1, n_A_0D2, n_A_0D3, n_A_0D4,
         n_A_0D5, n_A_0D6, n_A_0D7, n_A_0D8, n_A_0D9, n_A_0D10, n_A_0D11,
         n_A_0D12, n_A_0D13, n_A_0D14, n_A_0D15, n_A_0D16, n_A_0D17, n_A_0D18,
         n_A_0D19, n_A_0D20, n_A_191, n_A_192, n_A_193, n_A_194, n_A_195,
         n_A_196, n_A_197, n_A_198, n_A_199, n_A_1910, n_A_1911, n_A_1912,
         n_A_1913, n_A_1914, n_A_1915, n_A_1916, n_A_1917, n_A_1918, n_A_1919,
         n_A_1920, n_A_0S, n_A_1L;

  NAND2X1 A200 ( .A(WEO[0]), .B(n_A_17), .Y(n_A_1D20) );
  NAND2X1 A201 ( .A(WEO[1]), .B(n_A_17), .Y(n_A_1D19) );
  NAND2X1 A202 ( .A(WEO[2]), .B(n_A_17), .Y(n_A_1D18) );
  NAND2X1 A203 ( .A(WEO[3]), .B(n_A_17), .Y(n_A_1D17) );
  NAND2X1 A204 ( .A(WEO[4]), .B(n_A_17), .Y(n_A_1D16) );
  NAND2X1 A205 ( .A(WEO[5]), .B(n_A_17), .Y(n_A_1D15) );
  NAND2X1 A206 ( .A(WEO[6]), .B(n_A_17), .Y(n_A_1D14) );
  NAND2X1 A207 ( .A(WEO[7]), .B(n_A_17), .Y(n_A_1D13) );
  NAND2X1 A208 ( .A(WEO[8]), .B(n_A_17), .Y(n_A_1D12) );
  NAND2X1 A209 ( .A(WEO[9]), .B(n_A_17), .Y(n_A_1D11) );
  NAND2X1 A210 ( .A(WEO[10]), .B(n_A_17), .Y(n_A_1D10) );
  NAND2X1 A211 ( .A(WEO[11]), .B(n_A_17), .Y(n_A_1D9) );
  NAND2X1 A212 ( .A(WEO[12]), .B(n_A_17), .Y(n_A_1D8) );
  NAND2X1 A213 ( .A(WEO[13]), .B(n_A_17), .Y(n_A_1D7) );
  NAND2X1 A214 ( .A(WEO[14]), .B(n_A_17), .Y(n_A_1D6) );
  NAND2X1 A215 ( .A(WEO[15]), .B(n_A_17), .Y(n_A_1D5) );
  NAND2X1 A216 ( .A(WEO[16]), .B(n_A_17), .Y(n_A_1D4) );
  NAND2X1 A217 ( .A(WEO[17]), .B(n_A_17), .Y(n_A_1D3) );
  NAND2X1 A218 ( .A(WEO[18]), .B(n_A_17), .Y(n_A_1D2) );
  NAND2X1 A219 ( .A(WEO[19]), .B(n_A_17), .Y(n_A_1D1) );
  NAND2X1 A300 ( .A(TSO[0]), .B(n_A_11), .Y(n_A_1E20) );
  NAND2X1 A301 ( .A(TSO[1]), .B(n_A_11), .Y(n_A_1E19) );
  NAND2X1 A302 ( .A(TSO[2]), .B(n_A_11), .Y(n_A_1E18) );
  NAND2X1 A303 ( .A(TSO[3]), .B(n_A_11), .Y(n_A_1E17) );
  NAND2X1 A304 ( .A(TSO[4]), .B(n_A_11), .Y(n_A_1E16) );
  NAND2X1 A305 ( .A(TSO[5]), .B(n_A_11), .Y(n_A_1E15) );
  NAND2X1 A306 ( .A(TSO[6]), .B(n_A_11), .Y(n_A_1E14) );
  NAND2X1 A307 ( .A(TSO[7]), .B(n_A_11), .Y(n_A_1E13) );
  NAND2X1 A308 ( .A(TSO[8]), .B(n_A_11), .Y(n_A_1E12) );
  NAND2X1 A309 ( .A(TSO[9]), .B(n_A_11), .Y(n_A_1E11) );
  NAND2X1 A310 ( .A(TSO[10]), .B(n_A_11), .Y(n_A_1E10) );
  NAND2X1 A311 ( .A(TSO[11]), .B(n_A_11), .Y(n_A_1E9) );
  NAND2X1 A312 ( .A(TSO[12]), .B(n_A_11), .Y(n_A_1E8) );
  NAND2X1 A313 ( .A(TSO[13]), .B(n_A_11), .Y(n_A_1E7) );
  NAND2X1 A314 ( .A(TSO[14]), .B(n_A_11), .Y(n_A_1E6) );
  NAND2X1 A315 ( .A(TSO[15]), .B(n_A_11), .Y(n_A_1E5) );
  NAND2X1 A316 ( .A(TSO[16]), .B(n_A_11), .Y(n_A_1E4) );
  NAND2X1 A317 ( .A(TSO[17]), .B(n_A_11), .Y(n_A_1E3) );
  NAND2X1 A318 ( .A(TSO[18]), .B(n_A_11), .Y(n_A_1E2) );
  NAND2X1 A319 ( .A(TSO[19]), .B(n_A_11), .Y(n_A_1E1) );
  NAND2X1 A400 ( .A(TIMO[0]), .B(n_A_0X), .Y(n_A_1B20) );
  NAND2X1 A401 ( .A(TIMO[1]), .B(n_A_0X), .Y(n_A_1B19) );
  NAND2X1 A402 ( .A(TIMO[2]), .B(n_A_0X), .Y(n_A_1B18) );
  NAND2X1 A403 ( .A(TIMO[3]), .B(n_A_0X), .Y(n_A_1B17) );
  NAND2X1 A404 ( .A(TIMO[4]), .B(n_A_0X), .Y(n_A_1B16) );
  NAND2X1 A405 ( .A(TIMO[5]), .B(n_A_0X), .Y(n_A_1B15) );
  NAND2X1 A406 ( .A(TIMO[6]), .B(n_A_0X), .Y(n_A_1B14) );
  NAND2X1 A407 ( .A(TIMO[7]), .B(n_A_0X), .Y(n_A_1B13) );
  NAND2X1 A408 ( .A(TIMO[8]), .B(n_A_0X), .Y(n_A_1B12) );
  NAND2X1 A409 ( .A(TIMO[9]), .B(n_A_0X), .Y(n_A_1B11) );
  NAND2X1 A410 ( .A(TIMO[10]), .B(n_A_0X), .Y(n_A_1B10) );
  NAND2X1 A411 ( .A(TIMO[11]), .B(n_A_0X), .Y(n_A_1B9) );
  NAND2X1 A412 ( .A(TIMO[12]), .B(n_A_0X), .Y(n_A_1B8) );
  NAND2X1 A413 ( .A(TIMO[13]), .B(n_A_0X), .Y(n_A_1B7) );
  NAND2X1 A414 ( .A(TIMO[14]), .B(n_A_0X), .Y(n_A_1B6) );
  NAND2X1 A415 ( .A(TIMO[15]), .B(n_A_0X), .Y(n_A_1B5) );
  NAND2X1 A416 ( .A(TIMO[16]), .B(n_A_0X), .Y(n_A_1B4) );
  NAND2X1 A417 ( .A(TIMO[17]), .B(n_A_0X), .Y(n_A_1B3) );
  NAND2X1 A418 ( .A(TIMO[18]), .B(n_A_0X), .Y(n_A_1B2) );
  NAND2X1 A419 ( .A(TIMO[19]), .B(n_A_0X), .Y(n_A_1B1) );
  NAND2X1 A500 ( .A(n_LL00), .B(n_A_1H), .Y(n_A_0K20) );
  NAND2X1 A501 ( .A(n_LL01), .B(n_A_1H), .Y(n_A_0K19) );
  NAND2X1 A502 ( .A(n_LL02), .B(n_A_1H), .Y(n_A_0K18) );
  NAND2X1 A503 ( .A(n_LL03), .B(n_A_1H), .Y(n_A_0K17) );
  NAND2X1 A504 ( .A(n_LL04), .B(n_A_1H), .Y(n_A_0K16) );
  NAND2X1 A505 ( .A(n_LL05), .B(n_A_1H), .Y(n_A_0K15) );
  NAND2X1 A506 ( .A(n_LL06), .B(n_A_1H), .Y(n_A_0K14) );
  NAND2X1 A507 ( .A(n_LL07), .B(n_A_1H), .Y(n_A_0K13) );
  NAND2X1 A508 ( .A(n_LL08), .B(n_A_1H), .Y(n_A_0K12) );
  NAND2X1 A509 ( .A(n_LL09), .B(n_A_1H), .Y(n_A_0K11) );
  NAND2X1 A510 ( .A(n_LL10), .B(n_A_1H), .Y(n_A_0K10) );
  NAND2X1 A511 ( .A(n_LL11), .B(n_A_1H), .Y(n_A_0K9) );
  NAND2X1 A512 ( .A(n_LL12), .B(n_A_1H), .Y(n_A_0K8) );
  NAND2X1 A513 ( .A(n_LL13), .B(n_A_1H), .Y(n_A_0K7) );
  NAND2X1 A514 ( .A(n_LL14), .B(n_A_1H), .Y(n_A_0K6) );
  NAND2X1 A515 ( .A(n_LL15), .B(n_A_1H), .Y(n_A_0K5) );
  NAND2X1 A516 ( .A(n_LL16), .B(n_A_1H), .Y(n_A_0K4) );
  NAND2X1 A517 ( .A(n_LL17), .B(n_A_1H), .Y(n_A_0K3) );
  NAND2X1 A518 ( .A(n_LL18), .B(n_A_1H), .Y(n_A_0K2) );
  NAND2X1 A519 ( .A(n_LL19), .B(n_A_1H), .Y(n_A_0K1) );
  BUFX2 A700 ( .A(TIMO[0]), .Y(n_LL16) );
  BUFX2 A701 ( .A(TIMO[1]), .Y(n_LL17) );
  BUFX2 A702 ( .A(TIMO[2]), .Y(n_LL18) );
  TIELO A800 ( .Y(n_LL00) );
  TIELO A801 ( .Y(n_LL01) );
  TIELO A802 ( .Y(n_LL02) );
  TIELO A803 ( .Y(n_LL03) );
  TIELO A804 ( .Y(n_LL04) );
  TIELO A805 ( .Y(n_LL05) );
  TIELO A806 ( .Y(n_LL06) );
  TIELO A807 ( .Y(n_LL07) );
  TIELO A808 ( .Y(n_LL08) );
  TIELO A809 ( .Y(n_LL09) );
  TIELO A810 ( .Y(n_LL10) );
  TIELO A811 ( .Y(n_LL11) );
  NAND4X2 A100 ( .A(n_A_1D20), .B(n_A_1E20), .C(n_A_1B20), .D(n_A_0K20), .Y(
        TDB[0]) );
  NAND4X2 A101 ( .A(n_A_1D19), .B(n_A_1E19), .C(n_A_1B19), .D(n_A_0K19), .Y(
        TDB[1]) );
  NAND4X2 A102 ( .A(n_A_1D18), .B(n_A_1E18), .C(n_A_1B18), .D(n_A_0K18), .Y(
        TDB[2]) );
  NAND4X2 A103 ( .A(n_A_1D17), .B(n_A_1E17), .C(n_A_1B17), .D(n_A_0K17), .Y(
        TDB[3]) );
  NAND4X2 A104 ( .A(n_A_1D16), .B(n_A_1E16), .C(n_A_1B16), .D(n_A_0K16), .Y(
        TDB[4]) );
  NAND4X2 A105 ( .A(n_A_1D15), .B(n_A_1E15), .C(n_A_1B15), .D(n_A_0K15), .Y(
        TDB[5]) );
  NAND4X2 A106 ( .A(n_A_1D14), .B(n_A_1E14), .C(n_A_1B14), .D(n_A_0K14), .Y(
        TDB[6]) );
  NAND4X2 A107 ( .A(n_A_1D13), .B(n_A_1E13), .C(n_A_1B13), .D(n_A_0K13), .Y(
        TDB[7]) );
  NAND4X2 A108 ( .A(n_A_1D12), .B(n_A_1E12), .C(n_A_1B12), .D(n_A_0K12), .Y(
        TDB[8]) );
  NAND4X2 A109 ( .A(n_A_1D11), .B(n_A_1E11), .C(n_A_1B11), .D(n_A_0K11), .Y(
        TDB[9]) );
  NAND4X2 A110 ( .A(n_A_1D10), .B(n_A_1E10), .C(n_A_1B10), .D(n_A_0K10), .Y(
        TDB[10]) );
  NAND4X2 A111 ( .A(n_A_1D9), .B(n_A_1E9), .C(n_A_1B9), .D(n_A_0K9), .Y(
        TDB[11]) );
  NAND4X2 A112 ( .A(n_A_1D8), .B(n_A_1E8), .C(n_A_1B8), .D(n_A_0K8), .Y(
        TDB[12]) );
  NAND4X2 A113 ( .A(n_A_1D7), .B(n_A_1E7), .C(n_A_1B7), .D(n_A_0K7), .Y(
        TDB[13]) );
  NAND4X2 A114 ( .A(n_A_1D6), .B(n_A_1E6), .C(n_A_1B6), .D(n_A_0K6), .Y(
        TDB[14]) );
  NAND4X2 A115 ( .A(n_A_1D5), .B(n_A_1E5), .C(n_A_1B5), .D(n_A_0K5), .Y(
        TDB[15]) );
  NAND4X2 A116 ( .A(n_A_1D4), .B(n_A_1E4), .C(n_A_1B4), .D(n_A_0K4), .Y(
        TDB[16]) );
  NAND4X2 A117 ( .A(n_A_1D3), .B(n_A_1E3), .C(n_A_1B3), .D(n_A_0K3), .Y(
        TDB[17]) );
  NAND4X2 A118 ( .A(n_A_1D2), .B(n_A_1E2), .C(n_A_1B2), .D(n_A_0K2), .Y(
        TDB[18]) );
  NAND4X2 A119 ( .A(n_A_1D1), .B(n_A_1E1), .C(n_A_1B1), .D(n_A_0K1), .Y(
        TDB[19]) );
  BUFX4 A12 ( .A(TIMHLEN), .Y(n_A_0X) );
  AND2X2 A1R0 ( .A(TIMO[20]), .B(TIMEXEN), .Y(TDB[20]) );
  AND2X2 A1R1 ( .A(TIMO[21]), .B(TIMEXEN), .Y(TDB[21]) );
  AND2X2 A1R2 ( .A(TIMO[22]), .B(TIMEXEN), .Y(TDB[22]) );
  AND2X2 A1R3 ( .A(TIMO[23]), .B(TIMEXEN), .Y(TDB[23]) );
  BUFX2 A703 ( .A(TIMO[3]), .Y(n_LL19) );
  BUFX2 A0S ( .A(XRST), .Y(n_A_0F) );
  BUFX2 A0R ( .A(TE), .Y(n_A_0H) );
  BUFX4 A0P ( .A(TIMLLEN), .Y(n_A_1H) );
  BUFX4 A0N ( .A(TSOEN), .Y(n_A_11) );
  BUFX4 A0L ( .A(WEOEN), .Y(n_A_17) );
  DS203 A0K ( .B({n_A_191, n_A_192, n_A_193, n_A_194, n_A_195, n_A_196, 
        n_A_197, n_A_198, n_A_199, n_A_1910, n_A_1911, n_A_1912, n_A_1913, 
        n_A_1914, n_A_1915, n_A_1916, n_A_1917, n_A_1918, n_A_1919, n_A_1920}), 
        .A({n_A_0D1, n_A_0D2, n_A_0D3, n_A_0D4, n_A_0D5, n_A_0D6, n_A_0D7, 
        n_A_0D8, n_A_0D9, n_A_0D10, n_A_0D11, n_A_0D12, n_A_0D13, n_A_0D14, 
        n_A_0D15, n_A_0D16, n_A_0D17, n_A_0D18, n_A_0D19, n_A_0D20}), .C(TACO), 
        .S2(TACEN), .S1(TCSEL), .Y(TCO) );
  FE20R A0G ( .D(TDB[19:0]), .TI(n_A_0S), .RN(n_A_0F), .TE(n_A_0H), .CK(MCK), 
        .EN(TC2LE), .Q({n_A_191, n_A_192, n_A_193, n_A_194, n_A_195, n_A_196, 
        n_A_197, n_A_198, n_A_199, n_A_1910, n_A_1911, n_A_1912, n_A_1913, 
        n_A_1914, n_A_1915, n_A_1916, n_A_1917, n_A_1918, n_A_1919, n_A_1920}), 
        .TO(TO) );
  FE20R A0F ( .D(TDB[19:0]), .TI(n_A_1L), .RN(n_A_0F), .TE(n_A_0H), .CK(MCK), 
        .EN(TC1LE), .Q({n_A_0D1, n_A_0D2, n_A_0D3, n_A_0D4, n_A_0D5, n_A_0D6, 
        n_A_0D7, n_A_0D8, n_A_0D9, n_A_0D10, n_A_0D11, n_A_0D12, n_A_0D13, 
        n_A_0D14, n_A_0D15, n_A_0D16, n_A_0D17, n_A_0D18, n_A_0D19, n_A_0D20}), 
        .TO(n_A_0S) );
  FE04R A07 ( .D(TIMO[3:0]), .CK(MCK), .RN(n_A_0F), .TE(n_A_0H), .EN(TIMLLLE), 
        .TI(TI), .Q({n_LL15, n_LL14, n_LL13, n_LL12}), .TO(n_A_1L) );
endmodule


module DS203 ( B, A, C, S2, S1, Y );
  input [19:0] B;
  input [19:0] A;
  input [19:0] C;
  output [19:0] Y;
  input S2, S1;
  wire   n_A_0A, n_A_0B20, n_A_0B19, n_A_0B18, n_A_0B17, n_A_0B16, n_A_0B15,
         n_A_0B14, n_A_0B13, n_A_0B12, n_A_0B11, n_A_0B10, n_A_0B9, n_A_0B8,
         n_A_0B7, n_A_0B6, n_A_0B5, n_A_0B4, n_A_0B3, n_A_0B2, n_A_08, n_A_0B1
;

  MX2X1 A100 ( .S0(n_A_0A), .B(B[0]), .A(A[0]), .Y(n_A_0B20) );
  MX2X1 A101 ( .S0(n_A_0A), .B(B[1]), .A(A[1]), .Y(n_A_0B19) );
  MX2X1 A102 ( .S0(n_A_0A), .B(B[2]), .A(A[2]), .Y(n_A_0B18) );
  MX2X1 A103 ( .S0(n_A_0A), .B(B[3]), .A(A[3]), .Y(n_A_0B17) );
  MX2X1 A104 ( .S0(n_A_0A), .B(B[4]), .A(A[4]), .Y(n_A_0B16) );
  MX2X1 A105 ( .S0(n_A_0A), .B(B[5]), .A(A[5]), .Y(n_A_0B15) );
  MX2X1 A106 ( .S0(n_A_0A), .B(B[6]), .A(A[6]), .Y(n_A_0B14) );
  MX2X1 A107 ( .S0(n_A_0A), .B(B[7]), .A(A[7]), .Y(n_A_0B13) );
  MX2X1 A108 ( .S0(n_A_0A), .B(B[8]), .A(A[8]), .Y(n_A_0B12) );
  MX2X1 A109 ( .S0(n_A_0A), .B(B[9]), .A(A[9]), .Y(n_A_0B11) );
  MX2X1 A110 ( .S0(n_A_0A), .B(B[10]), .A(A[10]), .Y(n_A_0B10) );
  MX2X1 A111 ( .S0(n_A_0A), .B(B[11]), .A(A[11]), .Y(n_A_0B9) );
  MX2X1 A112 ( .S0(n_A_0A), .B(B[12]), .A(A[12]), .Y(n_A_0B8) );
  MX2X1 A113 ( .S0(n_A_0A), .B(B[13]), .A(A[13]), .Y(n_A_0B7) );
  MX2X1 A114 ( .S0(n_A_0A), .B(B[14]), .A(A[14]), .Y(n_A_0B6) );
  MX2X1 A115 ( .S0(n_A_0A), .B(B[15]), .A(A[15]), .Y(n_A_0B5) );
  MX2X1 A116 ( .S0(n_A_0A), .B(B[16]), .A(A[16]), .Y(n_A_0B4) );
  MX2X1 A117 ( .S0(n_A_0A), .B(B[17]), .A(A[17]), .Y(n_A_0B3) );
  MX2X1 A118 ( .S0(n_A_0A), .B(B[18]), .A(A[18]), .Y(n_A_0B2) );
  MX2X2 A200 ( .S0(n_A_08), .B(C[0]), .A(n_A_0B20), .Y(Y[0]) );
  MX2X2 A201 ( .S0(n_A_08), .B(C[1]), .A(n_A_0B19), .Y(Y[1]) );
  MX2X2 A202 ( .S0(n_A_08), .B(C[2]), .A(n_A_0B18), .Y(Y[2]) );
  MX2X2 A203 ( .S0(n_A_08), .B(C[3]), .A(n_A_0B17), .Y(Y[3]) );
  MX2X2 A204 ( .S0(n_A_08), .B(C[4]), .A(n_A_0B16), .Y(Y[4]) );
  MX2X2 A205 ( .S0(n_A_08), .B(C[5]), .A(n_A_0B15), .Y(Y[5]) );
  MX2X2 A206 ( .S0(n_A_08), .B(C[6]), .A(n_A_0B14), .Y(Y[6]) );
  MX2X2 A207 ( .S0(n_A_08), .B(C[7]), .A(n_A_0B13), .Y(Y[7]) );
  MX2X2 A208 ( .S0(n_A_08), .B(C[8]), .A(n_A_0B12), .Y(Y[8]) );
  MX2X2 A209 ( .S0(n_A_08), .B(C[9]), .A(n_A_0B11), .Y(Y[9]) );
  MX2X2 A210 ( .S0(n_A_08), .B(C[10]), .A(n_A_0B10), .Y(Y[10]) );
  MX2X2 A211 ( .S0(n_A_08), .B(C[11]), .A(n_A_0B9), .Y(Y[11]) );
  MX2X2 A212 ( .S0(n_A_08), .B(C[12]), .A(n_A_0B8), .Y(Y[12]) );
  MX2X2 A213 ( .S0(n_A_08), .B(C[13]), .A(n_A_0B7), .Y(Y[13]) );
  MX2X2 A214 ( .S0(n_A_08), .B(C[14]), .A(n_A_0B6), .Y(Y[14]) );
  MX2X2 A215 ( .S0(n_A_08), .B(C[15]), .A(n_A_0B5), .Y(Y[15]) );
  MX2X2 A216 ( .S0(n_A_08), .B(C[16]), .A(n_A_0B4), .Y(Y[16]) );
  MX2X2 A217 ( .S0(n_A_08), .B(C[17]), .A(n_A_0B3), .Y(Y[17]) );
  MX2X2 A218 ( .S0(n_A_08), .B(C[18]), .A(n_A_0B2), .Y(Y[18]) );
  BUFX4 A002 ( .A(S1), .Y(n_A_0A) );
  BUFX4 A001 ( .A(S2), .Y(n_A_08) );
  MX2X2 A219 ( .S0(n_A_08), .B(C[19]), .A(n_A_0B1), .Y(Y[19]) );
  MX2X1 A119 ( .S0(n_A_0A), .B(B[19]), .A(A[19]), .Y(n_A_0B1) );
endmodule


module TSPSQ ( PLACA, FMODE, CHTEST, MCK, TI, TE, ENP, XRST, WSCST, TSYNC, 
        CHOSLD, PITB, TIMEA, TACCL, TPWEN, TSCST, ESYNC, TO, TIMLLLE, TTLE, 
        TC2LE, TC1LE, DYACLE, CHACLE, RVACLE, DLACLE, DRACLE, TIMLWE, TIMHWE, 
        WEABLE, TBLE, TALE, TYLE, TXLE, PLACB, TIMEXEN, CHLVEN, TBS2EN, TROMEN, 
        WESAEN, TIMLIS, DYACEN, CHACEN, RVACEN, DLACEN, DRACEN, TCSEL, WST0, 
        TACEN, TCBEN, WST1, TSOEN, TPYEN, TBCL, ITPEN, WEOEN, TSBEN, TTSEN, 
        TSYEN, TXEXEN, TIMLLEN, TIMLEN, TIMHLEN, TAIVEN, TPAEN );
  input [6:0] PLACA;
  input [1:0] FMODE;
  input [3:0] PITB;
  output [8:0] TIMEA;
  output [8:0] PLACB;
  input CHTEST, MCK, TI, TE, ENP, XRST, WSCST, TSYNC, CHOSLD;
  output TACCL, TPWEN, TSCST, ESYNC, TO, TIMLLLE, TTLE, TC2LE, TC1LE, DYACLE,
         CHACLE, RVACLE, DLACLE, DRACLE, TIMLWE, TIMHWE, WEABLE, TBLE, TALE,
         TYLE, TXLE, TIMEXEN, CHLVEN, TBS2EN, TROMEN, WESAEN, TIMLIS, DYACEN,
         CHACEN, RVACEN, DLACEN, DRACEN, TCSEL, WST0, TACEN, TCBEN, WST1,
         TSOEN, TPYEN, TBCL, ITPEN, WEOEN, TSBEN, TTSEN, TSYEN, TXEXEN,
         TIMLLEN, TIMLEN, TIMHLEN, TAIVEN, TPAEN;
  wire   n_TCHQ3, n_A_35, n_TCHQ4, n_TCHQ5, n_TCHQ6, n_TCHQ7, n_A_20, n_A_1K,
         n_A_1Y, n_A_3A, n_A_1T, n_A_2H, n_A_1C, n_TSQ0, n_TSQ1, n_TSQ2,
         n_TSQ3, n_A_1U, n_TSQ4, n_TCHQ8, n_A_30, n_A_2B, n_A_2S, n_A_2N,
         n_TIMAA2, n_TIMAB0, n_TIMAB1, n_A_2P, n_A_2X, n_TIMAA0, n_TIMAA1,
         n_A_2Y, n_A_2V, n_A_17, n_A_1G, n_A_2F, n_A_1E, n_A_2T, n_TFMODE0,
         n_TFMODE1, n_A_2J, n_TEV23, n_TEV22, n_TEV21, n_TEV20, n_TEV19,
         n_TEV18, n_TEV17, n_TEV16, n_TEV15, n_TEV14, n_TEV13, n_TEV12,
         n_TEV11, n_TEV10, n_TEV09, n_TEV08, n_TEV07, n_TEV06, n_TEV05,
         n_TEV04, n_TEV03, n_TEV02, n_TEV01, n_TEV00, n_A_25, n_A_26, n_A_21,
         n_A_2W, n_TIMAB2, n_A_2U, n_TIMAC1, n_A_16, n_TIMAC2, n_TIMAC0,
         n_B_3M, n_B_1V, n_B_3L, n_B_3K, n_B_2P, n_B_2D, n_B_2S, n_B_26,
         n_B_27, n_B_28, n_B_29, n_B_2A, n_B_2B, n_B_2C, n_B_3D, n_B_2Y,
         n_B_30, n_B_31, n_B_32, n_B_33, n_B_34, n_B_35, n_B_36, n_B_37,
         n_B_39, n_B_38, n_B_3A, n_B_2J, n_B_2K, n_B_2L, n_B_2M, n_B_2H,
         n_B_2E, n_B_2F, n_B_2G, n_C_27, n_C_0P, n_C_30, n_C_2G, n_C_3T,
         n_C_37, n_C_36, n_C_35;

  AND2X2 A000 ( .A(n_TCHQ3), .B(n_A_35), .Y(TIMEA[3]) );
  AND2X2 A001 ( .A(n_TCHQ4), .B(n_A_35), .Y(TIMEA[4]) );
  AND2X2 A002 ( .A(n_TCHQ5), .B(n_A_35), .Y(TIMEA[5]) );
  AND2X2 A003 ( .A(n_TCHQ6), .B(n_A_35), .Y(TIMEA[6]) );
  AND2X2 A004 ( .A(n_TCHQ7), .B(n_A_35), .Y(TIMEA[7]) );
  AND4X2 A2M ( .A(TSCST), .B(n_A_20), .C(n_A_1K), .D(n_A_1Y), .Y(TACCL) );
  AND2X1 A3G ( .A(TSCST), .B(n_A_1K), .Y(n_A_3A) );
  CO05 A01 ( .RN(n_A_1U), .TE(n_A_1C), .CK(MCK), .SCL(n_A_1T), .TI(n_A_2H), 
        .EN(n_A_3A), .Q4(n_TSQ4), .Q3(n_TSQ3), .Q2(n_TSQ2), .Q1(n_TSQ1), .Q0(
        n_TSQ0) );
  INVX2 A39 ( .A(CHTEST), .Y(n_A_35) );
  AND2X2 A005 ( .A(n_TCHQ8), .B(n_A_35), .Y(TIMEA[8]) );
  BUFX2 A36 ( .A(n_A_30), .Y(ESYNC) );
  AND2X1 A2A ( .A(n_A_1K), .B(n_A_2B), .Y(n_A_2S) );
  COU1 A05 ( .RN(n_A_1U), .TE(n_A_1C), .TI(n_TIMAA2), .CK(MCK), .SCL(n_A_2N), 
        .EN(n_A_2S), .QN(n_TIMAB1), .Q(n_TIMAB0) );
  CO03 A1E ( .RN(n_A_1U), .TE(n_A_1C), .TI(n_A_2X), .CK(MCK), .SCL(n_A_2N), 
        .EN(n_A_2P), .Q2(n_TIMAA2), .Q1(n_TIMAA1), .Q0(n_TIMAA0) );
  AND2X1 A35 ( .A(n_A_2N), .B(n_A_2Y), .Y(n_A_2V) );
  AD6 A07 ( .F(n_TCHQ8), .E(n_TCHQ7), .D(n_TCHQ6), .C(n_TCHQ5), .B(n_TCHQ4), 
        .A(n_TCHQ3), .Y(n_A_2Y) );
  AND2X1 A06 ( .A(n_A_17), .B(n_A_1K), .Y(n_A_2P) );
  FE02RC A15 ( .D1(n_A_2T), .D0(n_A_2B), .EN(n_A_1K), .RN(n_A_1U), .TE(n_A_1C), 
        .TI(n_TCHQ8), .CK(MCK), .Q1(n_A_1E), .Q0(n_A_1G), .TO(n_A_2F) );
  FE04RC A03 ( .D3(CHOSLD), .D2(FMODE[1]), .D1(FMODE[0]), .D0(WSCST), .CK(MCK), 
        .RN(n_A_1U), .TE(n_A_1C), .EN(n_A_1T), .TI(TI), .Q0(TSCST), .Q1(
        n_TFMODE0), .Q2(n_TFMODE1), .Q3(n_A_2J), .TO(n_A_2H) );
  FE07R A2C ( .D(PLACA), .CK(MCK), .TI(n_A_2F), .EN(n_A_1T), .TE(n_A_1C), .RN(
        n_A_1U), .Q(PLACB[6:0]), .TO(n_A_2X) );
  DC24 A0D ( .A({n_TSQ4, n_TSQ3, n_TSQ2, n_TSQ1, n_TSQ0}), .EN(n_A_2J), .Y({
        n_TEV23, n_TEV22, n_TEV21, n_TEV20, n_TEV19, n_TEV18, n_TEV17, n_TEV16, 
        n_TEV15, n_TEV14, n_TEV13, n_TEV12, n_TEV11, n_TEV10, n_TEV09, n_TEV08, 
        n_TEV07, n_TEV06, n_TEV05, n_TEV04, n_TEV03, n_TEV02, n_TEV01, n_TEV00}) );
  NAND2X1 A27 ( .A(n_TEV19), .B(n_TEV22), .Y(n_A_2T) );
  NAND2X1 A29 ( .A(n_TEV09), .B(n_TEV11), .Y(n_A_2B) );
  OR2X1 A0X ( .A(n_A_25), .B(n_A_26), .Y(n_A_17) );
  NR6 A2K ( .F(n_TCHQ8), .E(n_TCHQ7), .D(n_TCHQ6), .C(n_TCHQ5), .B(n_TCHQ4), 
        .A(n_TCHQ3), .Y(n_A_1Y) );
  TSPTG A1V ( .A({n_TSQ4, n_TSQ3, n_TSQ2, n_TSQ1, n_TSQ0}), .Y0(n_A_20), .Y19(
        TPWEN), .Y23(n_A_21) );
  AND2X2 A1T ( .A(n_A_1K), .B(n_A_21), .Y(n_A_2N) );
  NAND3X1 A0W ( .A(n_TEV10), .B(n_TEV12), .C(n_TEV14), .Y(n_A_26) );
  NAND4X1 A0E ( .A(n_TEV05), .B(n_TEV06), .C(n_TEV07), .D(n_TEV08), .Y(n_A_25)
         );
  BUFX2 A2S ( .A(XRST), .Y(n_A_1U) );
  BUFX2 A2P ( .A(n_A_2W), .Y(TO) );
  BUFX3 A2N ( .A(TE), .Y(n_A_1C) );
  BUFX2 A2G ( .A(TSYNC), .Y(n_A_30) );
  BUFX2 A2F ( .A(ENP), .Y(n_A_1K) );
  OR2X2 A0A ( .A(n_A_30), .B(n_A_2N), .Y(n_A_1T) );
  TIELO A14 ( .Y(n_TIMAB2) );
  AND2X1 A0L ( .A(n_A_2V), .B(n_A_2W), .Y(n_A_2U) );
  XNOR2X1 A1A ( .A(n_A_16), .B(n_A_2W), .Y(n_TIMAC1) );
  XOR2X1 A19 ( .A(n_A_16), .B(n_A_2W), .Y(n_TIMAC2) );
  INVX1 A18 ( .A(n_A_16), .Y(n_TIMAC0) );
  CO02 A17 ( .RN(n_A_1U), .TE(n_A_1C), .TI(n_TIMAB0), .CK(MCK), .SCL(n_A_2U), 
        .EN(n_A_2V), .Q1(n_A_2W), .Q0(n_A_16) );
  DS033 A08 ( .A({n_TIMAA2, n_TIMAA1, n_TIMAA0}), .B({n_TIMAB2, n_TIMAB1, 
        n_TIMAB0}), .C({n_TIMAC2, n_TIMAC1, n_TIMAC0}), .S1(n_A_1E), .S0(
        n_A_1G), .Y(TIMEA[2:0]) );
  CO06 A04 ( .TI(n_TSQ4), .RN(n_A_1U), .TE(n_A_1C), .CK(MCK), .SCL(n_A_30), 
        .EN(n_A_2N), .Q5(n_TCHQ8), .Q4(n_TCHQ7), .Q3(n_TCHQ6), .Q2(n_TCHQ5), 
        .Q1(n_TCHQ4), .Q0(n_TCHQ3) );
  OR2X1 B48 ( .A(n_B_3M), .B(n_B_1V), .Y(n_B_3L) );
  AND2X1 B47 ( .A(n_B_3K), .B(n_TFMODE0), .Y(n_B_1V) );
  INVX1 B46 ( .A(n_TEV10), .Y(n_B_3K) );
  INVX1 B21 ( .A(n_TEV08), .Y(n_B_3M) );
  AND2X2 B3R ( .A(n_B_3L), .B(n_B_2P), .Y(TTLE) );
  NAND3X2 B1Y ( .A(n_B_2D), .B(n_TEV10), .C(n_TEV12), .Y(TIMHWE) );
  NAND4X2 B20 ( .A(n_B_2D), .B(n_TEV10), .C(n_TEV12), .D(n_TEV23), .Y(TIMLWE)
         );
  NAND4X1 B1F ( .A(n_TEV00), .B(n_TEV01), .C(n_TEV02), .D(n_TEV03), .Y(n_B_2S)
         );
  INVX1 B22 ( .A(n_TEV07), .Y(n_B_26) );
  INVX1 B23 ( .A(n_TEV06), .Y(n_B_27) );
  INVX1 B25 ( .A(n_TEV19), .Y(n_B_28) );
  INVX1 B24 ( .A(n_TEV18), .Y(n_B_29) );
  INVX1 B26 ( .A(n_TEV17), .Y(n_B_2A) );
  INVX1 B37 ( .A(n_TEV16), .Y(n_B_2B) );
  INVX1 B3N ( .A(n_TEV15), .Y(n_B_2C) );
  AND2X2 B3P ( .A(n_B_26), .B(n_B_2P), .Y(TC2LE) );
  AND2X2 B3V ( .A(n_B_27), .B(n_B_2P), .Y(TC1LE) );
  AND2X2 B1G ( .A(n_B_28), .B(n_B_2P), .Y(DYACLE) );
  AND2X2 B0F ( .A(n_B_29), .B(n_B_2P), .Y(CHACLE) );
  AND2X2 B0E ( .A(n_B_2A), .B(n_B_2P), .Y(RVACLE) );
  AND2X2 B08 ( .A(n_B_2B), .B(n_B_2P), .Y(DLACLE) );
  AND2X2 B07 ( .A(n_B_2C), .B(n_B_2P), .Y(DRACLE) );
  AND2X2 B27 ( .A(n_B_3D), .B(n_B_2P), .Y(TIMLLLE) );
  AND2X2 B28 ( .A(n_B_2S), .B(n_B_2P), .Y(WEABLE) );
  AND2X2 B29 ( .A(n_B_2Y), .B(n_B_2P), .Y(TBLE) );
  AND2X2 B2A ( .A(n_B_30), .B(n_B_2P), .Y(TALE) );
  AND2X2 B2B ( .A(n_B_31), .B(n_B_2P), .Y(TYLE) );
  AND2X2 B2C ( .A(n_B_32), .B(n_B_2P), .Y(TXLE) );
  OR3X1 B0D ( .A(n_B_33), .B(n_B_34), .C(n_B_35), .Y(n_B_2Y) );
  OR4X1 B0C ( .A(n_B_36), .B(n_B_33), .C(n_B_34), .D(n_B_35), .Y(n_B_30) );
  OR3X1 B05 ( .A(n_B_37), .B(n_B_39), .C(n_B_38), .Y(n_B_31) );
  OR3X1 B06 ( .A(n_B_3A), .B(n_B_37), .C(n_B_39), .Y(n_B_32) );
  BUFX4 B2X ( .A(ENP), .Y(n_B_2P) );
  INVX1 B3U ( .A(n_TEV14), .Y(n_B_3D) );
  INVX1 B32 ( .A(PITB[3]), .Y(n_B_2J) );
  INVX1 B31 ( .A(PITB[2]), .Y(n_B_2K) );
  INVX1 B30 ( .A(PITB[1]), .Y(n_B_2L) );
  INVX1 B2Y ( .A(PITB[0]), .Y(n_B_2M) );
  NOR4X1 B1X ( .A(n_B_2H), .B(n_B_2E), .C(n_B_2F), .D(n_B_2G), .Y(n_B_2D) );
  NOR2X1 B1W ( .A(n_TEV04), .B(n_B_2J), .Y(n_B_2G) );
  NOR2X1 B1V ( .A(n_TEV03), .B(n_B_2K), .Y(n_B_2F) );
  NOR2X1 B1U ( .A(n_TEV02), .B(n_B_2L), .Y(n_B_2E) );
  NOR2X1 B1T ( .A(n_TEV01), .B(n_B_2M), .Y(n_B_2H) );
  INVX1 B0G ( .A(n_TEV22), .Y(n_B_36) );
  NAND4X1 B0B ( .A(n_TEV16), .B(n_TEV17), .C(n_TEV18), .D(n_TEV20), .Y(n_B_35)
         );
  ND5 B0A ( .E(n_TEV15), .D(n_TEV14), .C(n_TEV11), .B(n_TEV09), .A(n_TEV07), 
        .Y(n_B_34) );
  ND5 B09 ( .E(n_TEV06), .D(n_TEV05), .C(n_TEV04), .B(n_TEV03), .A(n_TEV02), 
        .Y(n_B_33) );
  NAND2X1 B04 ( .A(n_TEV10), .B(n_TEV12), .Y(n_B_38) );
  NAND3X1 B03 ( .A(n_TEV08), .B(n_TEV13), .C(n_TEV21), .Y(n_B_39) );
  NAND4X1 B02 ( .A(n_TEV01), .B(n_TEV02), .C(n_TEV03), .D(n_TEV04), .Y(n_B_37)
         );
  ND6 B01 ( .F(n_TEV17), .E(n_TEV16), .D(n_TEV15), .C(n_TEV14), .B(n_TEV11), 
        .A(n_TEV09), .Y(n_B_3A) );
  INVX2 C16 ( .A(n_TEV20), .Y(TIMEXEN) );
  NOR2X1 C1U ( .A(n_TFMODE0), .B(n_TFMODE1), .Y(n_C_27) );
  NAND3X2 C41 ( .A(n_TEV01), .B(n_TEV02), .C(n_TEV03), .Y(WESAEN) );
  OR3X2 C0Y ( .A(n_C_0P), .B(n_C_30), .C(TXEXEN), .Y(TIMHLEN) );
  ND5 C0W ( .E(n_TEV16), .D(n_TEV14), .C(n_TEV07), .B(n_TEV06), .A(n_TEV00), 
        .Y(n_C_0P) );
  NAND3X1 C18 ( .A(n_TEV13), .B(n_TEV15), .C(n_TEV20), .Y(n_C_30) );
  OR2X2 C39 ( .A(n_C_2G), .B(TACEN), .Y(TCBEN) );
  NAND2X1 C31 ( .A(n_TEV09), .B(n_TEV11), .Y(n_C_2G) );
  ND5D2 C4V ( .E(n_TEV17), .D(n_TEV16), .C(n_TEV15), .B(n_TEV14), .A(n_TEV13), 
        .Y(CHLVEN) );
  NAND2X2 C4D ( .A(n_TEV01), .B(n_TEV02), .Y(PLACB[8]) );
  NAND2X2 C4E ( .A(n_TEV01), .B(n_TEV03), .Y(PLACB[7]) );
  INVX2 C4U ( .A(n_TEV09), .Y(TBS2EN) );
  NAND4X1 C2C ( .A(n_TEV01), .B(n_TEV02), .C(n_TEV03), .D(n_TEV04), .Y(n_C_3T)
         );
  BUFX2 C4P ( .A(n_C_3T), .Y(TROMEN) );
  BUFX2 C4N ( .A(n_C_3T), .Y(WEOEN) );
  INVX2 C3J ( .A(n_TEV23), .Y(TIMLIS) );
  INVX2 C3K ( .A(n_TEV18), .Y(DYACEN) );
  INVX2 C3L ( .A(n_TEV17), .Y(CHACEN) );
  INVX2 C3M ( .A(n_TEV16), .Y(RVACEN) );
  INVX2 C3N ( .A(n_TEV15), .Y(DLACEN) );
  INVX2 C3P ( .A(n_TEV14), .Y(DRACEN) );
  INVX2 C3R ( .A(n_TEV11), .Y(TCSEL) );
  ND5D2 C38 ( .E(n_TEV18), .D(n_TEV17), .C(n_TEV16), .B(n_TEV15), .A(n_TEV14), 
        .Y(TACEN) );
  NAND2X2 C2U ( .A(n_TEV02), .B(n_TEV03), .Y(WST1) );
  NAND2X2 C2V ( .A(n_TEV01), .B(n_TEV03), .Y(WST0) );
  NAND3X2 C2P ( .A(n_TEV10), .B(n_TEV12), .C(n_TEV23), .Y(TSOEN) );
  INVX2 C2H ( .A(n_TEV13), .Y(TPYEN) );
  INVX2 C2K ( .A(n_TEV02), .Y(TBCL) );
  INVX2 C2N ( .A(n_TEV21), .Y(ITPEN) );
  ND5D2 C1V ( .E(n_TEV07), .D(n_TEV06), .C(n_TEV05), .B(n_TEV04), .A(n_TEV03), 
        .Y(TSBEN) );
  NOR2X2 C1P ( .A(n_TEV12), .B(n_C_27), .Y(TTSEN) );
  NAND4X2 C1J ( .A(n_TEV08), .B(n_TEV10), .C(n_TEV12), .D(n_TEV21), .Y(TSYEN)
         );
  NAND3X2 C1E ( .A(n_TEV08), .B(n_TEV09), .C(n_TEV11), .Y(TXEXEN) );
  INVX2 C1C ( .A(n_TEV17), .Y(TIMLLEN) );
  BUFX2 C10 ( .A(n_C_30), .Y(TIMLEN) );
  NAND4X2 C05 ( .A(n_TEV06), .B(n_TEV07), .C(n_TEV20), .D(n_TEV22), .Y(TAIVEN)
         );
  OR3X2 C04 ( .A(n_C_37), .B(n_C_36), .C(n_C_35), .Y(TPAEN) );
  NAND4X1 C03 ( .A(n_TEV16), .B(n_TEV17), .C(n_TEV18), .D(n_TEV22), .Y(n_C_35)
         );
  NAND4X1 C02 ( .A(n_TEV09), .B(n_TEV11), .C(n_TEV14), .D(n_TEV15), .Y(n_C_36)
         );
  NAND4X1 C01 ( .A(n_TEV02), .B(n_TEV03), .C(n_TEV04), .D(n_TEV05), .Y(n_C_37)
         );
endmodule


module DS033 ( A, B, C, S1, S0, Y );
  input [2:0] A;
  input [2:0] B;
  input [2:0] C;
  output [2:0] Y;
  input S1, S0;
  wire   n_A_06, n_A_0B3, n_A_0B2, n_A_0C3, n_A_0A, n_A_0C2, n_A_0C1, n_A_0B1;

  MX2X1 A10 ( .S0(n_A_06), .B(B[0]), .A(A[0]), .Y(n_A_0B3) );
  MX2X1 A11 ( .S0(n_A_06), .B(B[1]), .A(A[1]), .Y(n_A_0B2) );
  MX2X1 A20 ( .S0(n_A_0A), .B(n_A_0C3), .A(n_A_0B3), .Y(Y[0]) );
  MX2X1 A21 ( .S0(n_A_0A), .B(n_A_0C2), .A(n_A_0B2), .Y(Y[1]) );
  BUFX2 A30 ( .A(C[0]), .Y(n_A_0C3) );
  BUFX2 A31 ( .A(C[1]), .Y(n_A_0C2) );
  BUFX2 A07 ( .A(S1), .Y(n_A_0A) );
  BUFX2 A06 ( .A(S0), .Y(n_A_06) );
  BUFX2 A32 ( .A(C[2]), .Y(n_A_0C1) );
  MX2X1 A22 ( .S0(n_A_0A), .B(n_A_0C1), .A(n_A_0B1), .Y(Y[2]) );
  MX2X1 A12 ( .S0(n_A_06), .B(B[2]), .A(A[2]), .Y(n_A_0B1) );
endmodule


module TSPTG ( A, Y0, Y19, Y23 );
  input [4:0] A;
  output Y0, Y19, Y23;
  wire   n_B0, n_B1, n_B2, n_B3, n_B4, n_A_0L, n_A_0M, n_A_0N;

  BUFX2 A070 ( .A(A[0]), .Y(n_B0) );
  BUFX2 A071 ( .A(A[1]), .Y(n_B1) );
  BUFX2 A072 ( .A(A[2]), .Y(n_B2) );
  BUFX2 A073 ( .A(A[3]), .Y(n_B3) );
  AD5 A05 ( .E(n_A_0L), .D(n_B4), .C(n_B2), .B(n_B1), .A(n_B0), .Y(Y23) );
  BUFX2 A074 ( .A(A[4]), .Y(n_B4) );
  INVX1 A06 ( .A(n_B3), .Y(n_A_0L) );
  NOR2X2 A04 ( .A(n_A_0M), .B(n_A_0N), .Y(Y19) );
  OR2X1 A03 ( .A(n_B2), .B(n_B3), .Y(n_A_0N) );
  NAND3X1 A02 ( .A(n_B0), .B(n_B1), .C(n_B4), .Y(n_A_0M) );
  NR5 A01 ( .E(n_B4), .D(n_B3), .C(n_B2), .B(n_B1), .A(n_B0), .Y(Y0) );
endmodule


module AD5 ( E, D, C, B, A, Y );
  input E, D, C, B, A;
  output Y;
  wire   n_A_07, n_A_01;

  NOR2X1 A09 ( .A(n_A_07), .B(n_A_01), .Y(Y) );
  NAND2X1 A08 ( .A(D), .B(E), .Y(n_A_01) );
  NAND3X1 A01 ( .A(A), .B(B), .C(C), .Y(n_A_07) );
endmodule


module FE04RC ( D3, D2, D1, D0, CK, RN, TE, EN, TI, Q0, Q1, Q2, Q3, TO );
  input D3, D2, D1, D0, CK, RN, TE, EN, TI;
  output Q0, Q1, Q2, Q3, TO;
  wire   n_A_0H, n_A_0K, n_A_0G;

  BUFX2 A0G ( .A(Q3), .Y(TO) );
  FE1R A02 ( .RN(n_A_0H), .TE(n_A_0K), .TI(Q0), .CK(CK), .EN(n_A_0G), .D(D1), 
        .Q(Q1) );
  BUFX2 A0F ( .A(EN), .Y(n_A_0G) );
  BUFX2 A0E ( .A(TE), .Y(n_A_0K) );
  BUFX2 A0D ( .A(RN), .Y(n_A_0H) );
  FE1R A04 ( .RN(n_A_0H), .TE(n_A_0K), .TI(Q2), .CK(CK), .EN(n_A_0G), .D(D3), 
        .Q(Q3) );
  FE1R A03 ( .RN(n_A_0H), .TE(n_A_0K), .TI(Q1), .CK(CK), .EN(n_A_0G), .D(D2), 
        .Q(Q2) );
  FE1R A01 ( .RN(n_A_0H), .TE(n_A_0K), .TI(TI), .CK(CK), .EN(n_A_0G), .D(D0), 
        .Q(Q0) );
endmodule


module FE02RC ( D1, D0, EN, RN, TE, TI, CK, Q1, Q0, TO );
  input D1, D0, EN, RN, TE, TI, CK;
  output Q1, Q0, TO;
  wire   n_A_0C, n_A_0A;

  BUFX2 A09 ( .A(Q1), .Y(TO) );
  BUFX2 A08 ( .A(RN), .Y(n_A_0C) );
  BUFX2 A05 ( .A(TE), .Y(n_A_0A) );
  FE1R A02 ( .RN(n_A_0C), .TE(n_A_0A), .TI(Q0), .CK(CK), .EN(EN), .D(D1), .Q(
        Q1) );
  FE1R A01 ( .RN(n_A_0C), .TE(n_A_0A), .TI(TI), .CK(CK), .EN(EN), .D(D0), .Q(
        Q0) );
endmodule


module AD6 ( F, E, D, C, B, A, Y );
  input F, E, D, C, B, A;
  output Y;
  wire   n_A_02, n_A_03;

  NOR2X1 A02 ( .A(n_A_02), .B(n_A_03), .Y(Y) );
  NAND3X1 A03 ( .A(D), .B(E), .C(F), .Y(n_A_03) );
  NAND3X1 A01 ( .A(A), .B(B), .C(C), .Y(n_A_02) );
endmodule


module TOACC ( TSO, TROMO, ACCL, XRST, DYACLE, CHACLE, RVACLE, DRACLE, ESSCL, 
        ESSCE, DYACEN, CHACEN, REACEN, DLACEN, DRACEN, TE, MCK, DLACLE, TI, 
        ESSD, TACO, TO );
  input [19:0] TSO;
  input [7:0] TROMO;
  output [19:0] ESSD;
  output [19:0] TACO;
  input ACCL, XRST, DYACLE, CHACLE, RVACLE, DRACLE, ESSCL, ESSCE, DYACEN,
         CHACEN, REACEN, DLACEN, DRACEN, TE, MCK, DLACLE, TI;
  output TO;
  wire   n_A_0F, n_A_2P20, n_A_2P19, n_A_2P18, n_A_2P17, n_A_2P16, n_A_2P15,
         n_A_2P14, n_A_2P13, n_A_2P12, n_A_2P11, n_A_2P10, n_A_2P9, n_A_2P8,
         n_A_2P7, n_A_2P6, n_A_2P5, n_A_2P4, n_A_2P3, n_A_2P2, n_A_3720,
         n_A_1V, n_A_2B20, n_A_3719, n_A_2B19, n_A_3718, n_A_2B18, n_A_3717,
         n_A_2B17, n_A_3716, n_A_2B16, n_A_3715, n_A_2B15, n_A_3714, n_A_2B14,
         n_A_3713, n_A_2B13, n_A_3712, n_A_2B12, n_A_3711, n_A_2B11, n_A_3710,
         n_A_2B10, n_A_379, n_A_2B9, n_A_378, n_A_2B8, n_A_377, n_A_2B7,
         n_A_376, n_A_2B6, n_A_375, n_A_2B5, n_A_374, n_A_2B4, n_A_373,
         n_A_2B3, n_A_372, n_A_2B2, n_A_0G20, n_A_1U, n_A_2C20, n_A_0G19,
         n_A_2C19, n_A_0G18, n_A_2C18, n_A_0G17, n_A_2C17, n_A_0G16, n_A_2C16,
         n_A_0G15, n_A_2C15, n_A_0G14, n_A_2C14, n_A_0G13, n_A_2C13, n_A_0G12,
         n_A_2C12, n_A_0G11, n_A_2C11, n_A_0G10, n_A_2C10, n_A_0G9, n_A_2C9,
         n_A_0G8, n_A_2C8, n_A_0G7, n_A_2C7, n_A_0G6, n_A_2C6, n_A_0G5,
         n_A_2C5, n_A_0G4, n_A_2C4, n_A_0G3, n_A_2C3, n_A_0G2, n_A_2C2,
         n_A_1J20, n_A_1T, n_A_2D20, n_A_1J19, n_A_2D19, n_A_1J18, n_A_2D18,
         n_A_1J17, n_A_2D17, n_A_1J16, n_A_2D16, n_A_1J15, n_A_2D15, n_A_1J14,
         n_A_2D14, n_A_1J13, n_A_2D13, n_A_1J12, n_A_2D12, n_A_1J11, n_A_2D11,
         n_A_1J10, n_A_2D10, n_A_1J9, n_A_2D9, n_A_1J8, n_A_2D8, n_A_1J7,
         n_A_2D7, n_A_1J6, n_A_2D6, n_A_1J5, n_A_2D5, n_A_1J4, n_A_2D4,
         n_A_1J3, n_A_2D3, n_A_1J2, n_A_2D2, n_A_1H20, n_A_1S, n_A_2A20,
         n_A_1H19, n_A_2A19, n_A_1H18, n_A_2A18, n_A_1H17, n_A_2A17, n_A_1H16,
         n_A_2A16, n_A_1H15, n_A_2A15, n_A_1H14, n_A_2A14, n_A_1H13, n_A_2A13,
         n_A_1H12, n_A_2A12, n_A_1H11, n_A_2A11, n_A_1H10, n_A_2A10, n_A_1H9,
         n_A_2A9, n_A_1H8, n_A_2A8, n_A_1H7, n_A_2A7, n_A_1H6, n_A_2A6,
         n_A_1H5, n_A_2A5, n_A_1H4, n_A_2A4, n_A_1H3, n_A_2A3, n_A_1H2,
         n_A_2A2, n_A_0H20, n_A_1R, n_A_2920, n_A_0H19, n_A_2919, n_A_0H18,
         n_A_2918, n_A_0H17, n_A_2917, n_A_0H16, n_A_2916, n_A_0H15, n_A_2915,
         n_A_0H14, n_A_2914, n_A_0H13, n_A_2913, n_A_0H12, n_A_2912, n_A_0H11,
         n_A_2911, n_A_0H10, n_A_2910, n_A_0H9, n_A_299, n_A_0H8, n_A_298,
         n_A_0H7, n_A_297, n_A_0H6, n_A_296, n_A_0H5, n_A_295, n_A_0H4,
         n_A_294, n_A_0H3, n_A_293, n_A_0H2, n_A_292, n_A_2520, n_A_21,
         n_A_2W20, n_A_2519, n_A_2W19, n_A_2518, n_A_2W18, n_A_2517, n_A_2W17,
         n_A_2516, n_A_2W16, n_A_2515, n_A_2W15, n_A_2514, n_A_2W14, n_A_2513,
         n_A_2W13, n_A_2512, n_A_2W12, n_A_2511, n_A_2W11, n_A_2510, n_A_2W10,
         n_A_259, n_A_2W9, n_A_258, n_A_2W8, n_A_257, n_A_2W7, n_A_256,
         n_A_2W6, n_A_255, n_A_2W5, n_A_254, n_A_2W4, n_A_253, n_A_2W3,
         n_A_252, n_A_2W2, n_A_2420, n_A_07, n_A_2V20, n_A_2419, n_A_2V19,
         n_A_2418, n_A_2V18, n_A_2417, n_A_2V17, n_A_2416, n_A_2V16, n_A_2415,
         n_A_2V15, n_A_2414, n_A_2V14, n_A_2413, n_A_2V13, n_A_2412, n_A_2V12,
         n_A_2411, n_A_2V11, n_A_2410, n_A_2V10, n_A_249, n_A_2V9, n_A_248,
         n_A_2V8, n_A_247, n_A_2V7, n_A_246, n_A_2V6, n_A_245, n_A_2V5,
         n_A_244, n_A_2V4, n_A_243, n_A_2V3, n_A_242, n_A_2V2, n_A_0220,
         n_A_08, n_A_2U20, n_A_0219, n_A_2U19, n_A_0218, n_A_2U18, n_A_0217,
         n_A_2U17, n_A_0216, n_A_2U16, n_A_0215, n_A_2U15, n_A_0214, n_A_2U14,
         n_A_0213, n_A_2U13, n_A_0212, n_A_2U12, n_A_0211, n_A_2U11, n_A_0210,
         n_A_2U10, n_A_029, n_A_2U9, n_A_028, n_A_2U8, n_A_027, n_A_2U7,
         n_A_026, n_A_2U6, n_A_025, n_A_2U5, n_A_024, n_A_2U4, n_A_023,
         n_A_2U3, n_A_022, n_A_2U2, n_A_2820, n_A_22, n_A_2T20, n_A_2819,
         n_A_2T19, n_A_2818, n_A_2T18, n_A_2817, n_A_2T17, n_A_2816, n_A_2T16,
         n_A_2815, n_A_2T15, n_A_2814, n_A_2T14, n_A_2813, n_A_2T13, n_A_2812,
         n_A_2T12, n_A_2811, n_A_2T11, n_A_2810, n_A_2T10, n_A_289, n_A_2T9,
         n_A_288, n_A_2T8, n_A_287, n_A_2T7, n_A_286, n_A_2T6, n_A_285,
         n_A_2T5, n_A_284, n_A_2T4, n_A_283, n_A_2T3, n_A_282, n_A_2T2,
         n_A_2720, n_A_23, n_A_2S20, n_A_2719, n_A_2S19, n_A_2718, n_A_2S18,
         n_A_2717, n_A_2S17, n_A_2716, n_A_2S16, n_A_2715, n_A_2S15, n_A_2714,
         n_A_2S14, n_A_2713, n_A_2S13, n_A_2712, n_A_2S12, n_A_2711, n_A_2S11,
         n_A_2710, n_A_2S10, n_A_279, n_A_2S9, n_A_278, n_A_2S8, n_A_277,
         n_A_2S7, n_A_276, n_A_2S6, n_A_275, n_A_2S5, n_A_274, n_A_2S4,
         n_A_273, n_A_2S3, n_A_272, n_A_2S2, n_TBM00, n_TBM01, n_TBM02,
         n_TBM03, n_TBM04, n_TBM05, n_TBM06, n_TBM07, n_TBM08, n_TBM09,
         n_TBM10, n_TBM11, n_TBM12, n_TBM13, n_TBM14, n_TBM15, n_TBM16,
         n_TBM17, n_TBM18, n_A_0U, n_TBM19, n_A_1C, n_A_2Y, n_A_1D, n_A_30,
         n_A_1E, n_A_2X, n_A_33, n_A_0K, n_A_31, n_A_1F, n_A_32, n_A_0P,
         n_A_0B, n_A_2U1, n_A_2V1, n_A_2W1, n_A_2T1, n_A_2S1, n_A_2D1, n_A_2C1,
         n_A_2B1, n_A_2A1, n_A_291, n_A_271, n_A_281, n_A_021, n_A_241,
         n_A_251, n_A_0H1, n_A_1H1, n_A_1J1, n_A_0G1, n_A_371, n_A_2P1, n_A_2H,
         n_A_2J, n_A_2K, n_A_2L, n_A_2M, n_A_0M, n_A_0N, n_A_0R, n_A_0T,
         n_A_26, n_A_0V, n_A_0W, n_A_0X, n_A_0Y;

  AND2X2 A000 ( .A(TSO[0]), .B(n_A_0F), .Y(n_A_2P20) );
  AND2X2 A001 ( .A(TSO[1]), .B(n_A_0F), .Y(n_A_2P19) );
  AND2X2 A002 ( .A(TSO[2]), .B(n_A_0F), .Y(n_A_2P18) );
  AND2X2 A003 ( .A(TSO[3]), .B(n_A_0F), .Y(n_A_2P17) );
  AND2X2 A004 ( .A(TSO[4]), .B(n_A_0F), .Y(n_A_2P16) );
  AND2X2 A005 ( .A(TSO[5]), .B(n_A_0F), .Y(n_A_2P15) );
  AND2X2 A006 ( .A(TSO[6]), .B(n_A_0F), .Y(n_A_2P14) );
  AND2X2 A007 ( .A(TSO[7]), .B(n_A_0F), .Y(n_A_2P13) );
  AND2X2 A008 ( .A(TSO[8]), .B(n_A_0F), .Y(n_A_2P12) );
  AND2X2 A009 ( .A(TSO[9]), .B(n_A_0F), .Y(n_A_2P11) );
  AND2X2 A010 ( .A(TSO[10]), .B(n_A_0F), .Y(n_A_2P10) );
  AND2X2 A011 ( .A(TSO[11]), .B(n_A_0F), .Y(n_A_2P9) );
  AND2X2 A012 ( .A(TSO[12]), .B(n_A_0F), .Y(n_A_2P8) );
  AND2X2 A013 ( .A(TSO[13]), .B(n_A_0F), .Y(n_A_2P7) );
  AND2X2 A014 ( .A(TSO[14]), .B(n_A_0F), .Y(n_A_2P6) );
  AND2X2 A015 ( .A(TSO[15]), .B(n_A_0F), .Y(n_A_2P5) );
  AND2X2 A016 ( .A(TSO[16]), .B(n_A_0F), .Y(n_A_2P4) );
  AND2X2 A017 ( .A(TSO[17]), .B(n_A_0F), .Y(n_A_2P3) );
  AND2X2 A018 ( .A(TSO[18]), .B(n_A_0F), .Y(n_A_2P2) );
  NAND2X1 A100 ( .A(n_A_3720), .B(n_A_1V), .Y(n_A_2B20) );
  NAND2X1 A101 ( .A(n_A_3719), .B(n_A_1V), .Y(n_A_2B19) );
  NAND2X1 A102 ( .A(n_A_3718), .B(n_A_1V), .Y(n_A_2B18) );
  NAND2X1 A103 ( .A(n_A_3717), .B(n_A_1V), .Y(n_A_2B17) );
  NAND2X1 A104 ( .A(n_A_3716), .B(n_A_1V), .Y(n_A_2B16) );
  NAND2X1 A105 ( .A(n_A_3715), .B(n_A_1V), .Y(n_A_2B15) );
  NAND2X1 A106 ( .A(n_A_3714), .B(n_A_1V), .Y(n_A_2B14) );
  NAND2X1 A107 ( .A(n_A_3713), .B(n_A_1V), .Y(n_A_2B13) );
  NAND2X1 A108 ( .A(n_A_3712), .B(n_A_1V), .Y(n_A_2B12) );
  NAND2X1 A109 ( .A(n_A_3711), .B(n_A_1V), .Y(n_A_2B11) );
  NAND2X1 A110 ( .A(n_A_3710), .B(n_A_1V), .Y(n_A_2B10) );
  NAND2X1 A111 ( .A(n_A_379), .B(n_A_1V), .Y(n_A_2B9) );
  NAND2X1 A112 ( .A(n_A_378), .B(n_A_1V), .Y(n_A_2B8) );
  NAND2X1 A113 ( .A(n_A_377), .B(n_A_1V), .Y(n_A_2B7) );
  NAND2X1 A114 ( .A(n_A_376), .B(n_A_1V), .Y(n_A_2B6) );
  NAND2X1 A115 ( .A(n_A_375), .B(n_A_1V), .Y(n_A_2B5) );
  NAND2X1 A116 ( .A(n_A_374), .B(n_A_1V), .Y(n_A_2B4) );
  NAND2X1 A117 ( .A(n_A_373), .B(n_A_1V), .Y(n_A_2B3) );
  NAND2X1 A118 ( .A(n_A_372), .B(n_A_1V), .Y(n_A_2B2) );
  NAND2X1 A200 ( .A(n_A_0G20), .B(n_A_1U), .Y(n_A_2C20) );
  NAND2X1 A201 ( .A(n_A_0G19), .B(n_A_1U), .Y(n_A_2C19) );
  NAND2X1 A202 ( .A(n_A_0G18), .B(n_A_1U), .Y(n_A_2C18) );
  NAND2X1 A203 ( .A(n_A_0G17), .B(n_A_1U), .Y(n_A_2C17) );
  NAND2X1 A204 ( .A(n_A_0G16), .B(n_A_1U), .Y(n_A_2C16) );
  NAND2X1 A205 ( .A(n_A_0G15), .B(n_A_1U), .Y(n_A_2C15) );
  NAND2X1 A206 ( .A(n_A_0G14), .B(n_A_1U), .Y(n_A_2C14) );
  NAND2X1 A207 ( .A(n_A_0G13), .B(n_A_1U), .Y(n_A_2C13) );
  NAND2X1 A208 ( .A(n_A_0G12), .B(n_A_1U), .Y(n_A_2C12) );
  NAND2X1 A209 ( .A(n_A_0G11), .B(n_A_1U), .Y(n_A_2C11) );
  NAND2X1 A210 ( .A(n_A_0G10), .B(n_A_1U), .Y(n_A_2C10) );
  NAND2X1 A211 ( .A(n_A_0G9), .B(n_A_1U), .Y(n_A_2C9) );
  NAND2X1 A212 ( .A(n_A_0G8), .B(n_A_1U), .Y(n_A_2C8) );
  NAND2X1 A213 ( .A(n_A_0G7), .B(n_A_1U), .Y(n_A_2C7) );
  NAND2X1 A214 ( .A(n_A_0G6), .B(n_A_1U), .Y(n_A_2C6) );
  NAND2X1 A215 ( .A(n_A_0G5), .B(n_A_1U), .Y(n_A_2C5) );
  NAND2X1 A216 ( .A(n_A_0G4), .B(n_A_1U), .Y(n_A_2C4) );
  NAND2X1 A217 ( .A(n_A_0G3), .B(n_A_1U), .Y(n_A_2C3) );
  NAND2X1 A218 ( .A(n_A_0G2), .B(n_A_1U), .Y(n_A_2C2) );
  NAND2X1 A300 ( .A(n_A_1J20), .B(n_A_1T), .Y(n_A_2D20) );
  NAND2X1 A301 ( .A(n_A_1J19), .B(n_A_1T), .Y(n_A_2D19) );
  NAND2X1 A302 ( .A(n_A_1J18), .B(n_A_1T), .Y(n_A_2D18) );
  NAND2X1 A303 ( .A(n_A_1J17), .B(n_A_1T), .Y(n_A_2D17) );
  NAND2X1 A304 ( .A(n_A_1J16), .B(n_A_1T), .Y(n_A_2D16) );
  NAND2X1 A305 ( .A(n_A_1J15), .B(n_A_1T), .Y(n_A_2D15) );
  NAND2X1 A306 ( .A(n_A_1J14), .B(n_A_1T), .Y(n_A_2D14) );
  NAND2X1 A307 ( .A(n_A_1J13), .B(n_A_1T), .Y(n_A_2D13) );
  NAND2X1 A308 ( .A(n_A_1J12), .B(n_A_1T), .Y(n_A_2D12) );
  NAND2X1 A309 ( .A(n_A_1J11), .B(n_A_1T), .Y(n_A_2D11) );
  NAND2X1 A310 ( .A(n_A_1J10), .B(n_A_1T), .Y(n_A_2D10) );
  NAND2X1 A311 ( .A(n_A_1J9), .B(n_A_1T), .Y(n_A_2D9) );
  NAND2X1 A312 ( .A(n_A_1J8), .B(n_A_1T), .Y(n_A_2D8) );
  NAND2X1 A313 ( .A(n_A_1J7), .B(n_A_1T), .Y(n_A_2D7) );
  NAND2X1 A314 ( .A(n_A_1J6), .B(n_A_1T), .Y(n_A_2D6) );
  NAND2X1 A315 ( .A(n_A_1J5), .B(n_A_1T), .Y(n_A_2D5) );
  NAND2X1 A316 ( .A(n_A_1J4), .B(n_A_1T), .Y(n_A_2D4) );
  NAND2X1 A317 ( .A(n_A_1J3), .B(n_A_1T), .Y(n_A_2D3) );
  NAND2X1 A318 ( .A(n_A_1J2), .B(n_A_1T), .Y(n_A_2D2) );
  NAND2X1 A400 ( .A(n_A_1H20), .B(n_A_1S), .Y(n_A_2A20) );
  NAND2X1 A401 ( .A(n_A_1H19), .B(n_A_1S), .Y(n_A_2A19) );
  NAND2X1 A402 ( .A(n_A_1H18), .B(n_A_1S), .Y(n_A_2A18) );
  NAND2X1 A403 ( .A(n_A_1H17), .B(n_A_1S), .Y(n_A_2A17) );
  NAND2X1 A404 ( .A(n_A_1H16), .B(n_A_1S), .Y(n_A_2A16) );
  NAND2X1 A405 ( .A(n_A_1H15), .B(n_A_1S), .Y(n_A_2A15) );
  NAND2X1 A406 ( .A(n_A_1H14), .B(n_A_1S), .Y(n_A_2A14) );
  NAND2X1 A407 ( .A(n_A_1H13), .B(n_A_1S), .Y(n_A_2A13) );
  NAND2X1 A408 ( .A(n_A_1H12), .B(n_A_1S), .Y(n_A_2A12) );
  NAND2X1 A409 ( .A(n_A_1H11), .B(n_A_1S), .Y(n_A_2A11) );
  NAND2X1 A410 ( .A(n_A_1H10), .B(n_A_1S), .Y(n_A_2A10) );
  NAND2X1 A411 ( .A(n_A_1H9), .B(n_A_1S), .Y(n_A_2A9) );
  NAND2X1 A412 ( .A(n_A_1H8), .B(n_A_1S), .Y(n_A_2A8) );
  NAND2X1 A413 ( .A(n_A_1H7), .B(n_A_1S), .Y(n_A_2A7) );
  NAND2X1 A414 ( .A(n_A_1H6), .B(n_A_1S), .Y(n_A_2A6) );
  NAND2X1 A415 ( .A(n_A_1H5), .B(n_A_1S), .Y(n_A_2A5) );
  NAND2X1 A416 ( .A(n_A_1H4), .B(n_A_1S), .Y(n_A_2A4) );
  NAND2X1 A417 ( .A(n_A_1H3), .B(n_A_1S), .Y(n_A_2A3) );
  NAND2X1 A418 ( .A(n_A_1H2), .B(n_A_1S), .Y(n_A_2A2) );
  NAND2X1 A500 ( .A(n_A_0H20), .B(n_A_1R), .Y(n_A_2920) );
  NAND2X1 A501 ( .A(n_A_0H19), .B(n_A_1R), .Y(n_A_2919) );
  NAND2X1 A502 ( .A(n_A_0H18), .B(n_A_1R), .Y(n_A_2918) );
  NAND2X1 A503 ( .A(n_A_0H17), .B(n_A_1R), .Y(n_A_2917) );
  NAND2X1 A504 ( .A(n_A_0H16), .B(n_A_1R), .Y(n_A_2916) );
  NAND2X1 A505 ( .A(n_A_0H15), .B(n_A_1R), .Y(n_A_2915) );
  NAND2X1 A506 ( .A(n_A_0H14), .B(n_A_1R), .Y(n_A_2914) );
  NAND2X1 A507 ( .A(n_A_0H13), .B(n_A_1R), .Y(n_A_2913) );
  NAND2X1 A508 ( .A(n_A_0H12), .B(n_A_1R), .Y(n_A_2912) );
  NAND2X1 A509 ( .A(n_A_0H11), .B(n_A_1R), .Y(n_A_2911) );
  NAND2X1 A510 ( .A(n_A_0H10), .B(n_A_1R), .Y(n_A_2910) );
  NAND2X1 A511 ( .A(n_A_0H9), .B(n_A_1R), .Y(n_A_299) );
  NAND2X1 A512 ( .A(n_A_0H8), .B(n_A_1R), .Y(n_A_298) );
  NAND2X1 A513 ( .A(n_A_0H7), .B(n_A_1R), .Y(n_A_297) );
  NAND2X1 A514 ( .A(n_A_0H6), .B(n_A_1R), .Y(n_A_296) );
  NAND2X1 A515 ( .A(n_A_0H5), .B(n_A_1R), .Y(n_A_295) );
  NAND2X1 A516 ( .A(n_A_0H4), .B(n_A_1R), .Y(n_A_294) );
  NAND2X1 A517 ( .A(n_A_0H3), .B(n_A_1R), .Y(n_A_293) );
  NAND2X1 A518 ( .A(n_A_0H2), .B(n_A_1R), .Y(n_A_292) );
  NAND2X1 A700 ( .A(n_A_2520), .B(n_A_21), .Y(n_A_2W20) );
  NAND2X1 A701 ( .A(n_A_2519), .B(n_A_21), .Y(n_A_2W19) );
  NAND2X1 A702 ( .A(n_A_2518), .B(n_A_21), .Y(n_A_2W18) );
  NAND2X1 A703 ( .A(n_A_2517), .B(n_A_21), .Y(n_A_2W17) );
  NAND2X1 A704 ( .A(n_A_2516), .B(n_A_21), .Y(n_A_2W16) );
  NAND2X1 A705 ( .A(n_A_2515), .B(n_A_21), .Y(n_A_2W15) );
  NAND2X1 A706 ( .A(n_A_2514), .B(n_A_21), .Y(n_A_2W14) );
  NAND2X1 A707 ( .A(n_A_2513), .B(n_A_21), .Y(n_A_2W13) );
  NAND2X1 A708 ( .A(n_A_2512), .B(n_A_21), .Y(n_A_2W12) );
  NAND2X1 A709 ( .A(n_A_2511), .B(n_A_21), .Y(n_A_2W11) );
  NAND2X1 A710 ( .A(n_A_2510), .B(n_A_21), .Y(n_A_2W10) );
  NAND2X1 A711 ( .A(n_A_259), .B(n_A_21), .Y(n_A_2W9) );
  NAND2X1 A712 ( .A(n_A_258), .B(n_A_21), .Y(n_A_2W8) );
  NAND2X1 A713 ( .A(n_A_257), .B(n_A_21), .Y(n_A_2W7) );
  NAND2X1 A714 ( .A(n_A_256), .B(n_A_21), .Y(n_A_2W6) );
  NAND2X1 A715 ( .A(n_A_255), .B(n_A_21), .Y(n_A_2W5) );
  NAND2X1 A716 ( .A(n_A_254), .B(n_A_21), .Y(n_A_2W4) );
  NAND2X1 A717 ( .A(n_A_253), .B(n_A_21), .Y(n_A_2W3) );
  NAND2X1 A718 ( .A(n_A_252), .B(n_A_21), .Y(n_A_2W2) );
  NAND2X1 A800 ( .A(n_A_2420), .B(n_A_07), .Y(n_A_2V20) );
  NAND2X1 A801 ( .A(n_A_2419), .B(n_A_07), .Y(n_A_2V19) );
  NAND2X1 A802 ( .A(n_A_2418), .B(n_A_07), .Y(n_A_2V18) );
  NAND2X1 A803 ( .A(n_A_2417), .B(n_A_07), .Y(n_A_2V17) );
  NAND2X1 A804 ( .A(n_A_2416), .B(n_A_07), .Y(n_A_2V16) );
  NAND2X1 A805 ( .A(n_A_2415), .B(n_A_07), .Y(n_A_2V15) );
  NAND2X1 A806 ( .A(n_A_2414), .B(n_A_07), .Y(n_A_2V14) );
  NAND2X1 A807 ( .A(n_A_2413), .B(n_A_07), .Y(n_A_2V13) );
  NAND2X1 A808 ( .A(n_A_2412), .B(n_A_07), .Y(n_A_2V12) );
  NAND2X1 A809 ( .A(n_A_2411), .B(n_A_07), .Y(n_A_2V11) );
  NAND2X1 A810 ( .A(n_A_2410), .B(n_A_07), .Y(n_A_2V10) );
  NAND2X1 A811 ( .A(n_A_249), .B(n_A_07), .Y(n_A_2V9) );
  NAND2X1 A812 ( .A(n_A_248), .B(n_A_07), .Y(n_A_2V8) );
  NAND2X1 A813 ( .A(n_A_247), .B(n_A_07), .Y(n_A_2V7) );
  NAND2X1 A814 ( .A(n_A_246), .B(n_A_07), .Y(n_A_2V6) );
  NAND2X1 A815 ( .A(n_A_245), .B(n_A_07), .Y(n_A_2V5) );
  NAND2X1 A816 ( .A(n_A_244), .B(n_A_07), .Y(n_A_2V4) );
  NAND2X1 A817 ( .A(n_A_243), .B(n_A_07), .Y(n_A_2V3) );
  NAND2X1 A818 ( .A(n_A_242), .B(n_A_07), .Y(n_A_2V2) );
  NAND2X1 A900 ( .A(n_A_0220), .B(n_A_08), .Y(n_A_2U20) );
  NAND2X1 A901 ( .A(n_A_0219), .B(n_A_08), .Y(n_A_2U19) );
  NAND2X1 A902 ( .A(n_A_0218), .B(n_A_08), .Y(n_A_2U18) );
  NAND2X1 A903 ( .A(n_A_0217), .B(n_A_08), .Y(n_A_2U17) );
  NAND2X1 A904 ( .A(n_A_0216), .B(n_A_08), .Y(n_A_2U16) );
  NAND2X1 A905 ( .A(n_A_0215), .B(n_A_08), .Y(n_A_2U15) );
  NAND2X1 A906 ( .A(n_A_0214), .B(n_A_08), .Y(n_A_2U14) );
  NAND2X1 A907 ( .A(n_A_0213), .B(n_A_08), .Y(n_A_2U13) );
  NAND2X1 A908 ( .A(n_A_0212), .B(n_A_08), .Y(n_A_2U12) );
  NAND2X1 A909 ( .A(n_A_0211), .B(n_A_08), .Y(n_A_2U11) );
  NAND2X1 A910 ( .A(n_A_0210), .B(n_A_08), .Y(n_A_2U10) );
  NAND2X1 A911 ( .A(n_A_029), .B(n_A_08), .Y(n_A_2U9) );
  NAND2X1 A912 ( .A(n_A_028), .B(n_A_08), .Y(n_A_2U8) );
  NAND2X1 A913 ( .A(n_A_027), .B(n_A_08), .Y(n_A_2U7) );
  NAND2X1 A914 ( .A(n_A_026), .B(n_A_08), .Y(n_A_2U6) );
  NAND2X1 A915 ( .A(n_A_025), .B(n_A_08), .Y(n_A_2U5) );
  NAND2X1 A916 ( .A(n_A_024), .B(n_A_08), .Y(n_A_2U4) );
  NAND2X1 A917 ( .A(n_A_023), .B(n_A_08), .Y(n_A_2U3) );
  NAND2X1 A918 ( .A(n_A_022), .B(n_A_08), .Y(n_A_2U2) );
  NAND2X1 AA00 ( .A(n_A_2820), .B(n_A_22), .Y(n_A_2T20) );
  NAND2X1 AA01 ( .A(n_A_2819), .B(n_A_22), .Y(n_A_2T19) );
  NAND2X1 AA02 ( .A(n_A_2818), .B(n_A_22), .Y(n_A_2T18) );
  NAND2X1 AA03 ( .A(n_A_2817), .B(n_A_22), .Y(n_A_2T17) );
  NAND2X1 AA04 ( .A(n_A_2816), .B(n_A_22), .Y(n_A_2T16) );
  NAND2X1 AA05 ( .A(n_A_2815), .B(n_A_22), .Y(n_A_2T15) );
  NAND2X1 AA06 ( .A(n_A_2814), .B(n_A_22), .Y(n_A_2T14) );
  NAND2X1 AA07 ( .A(n_A_2813), .B(n_A_22), .Y(n_A_2T13) );
  NAND2X1 AA08 ( .A(n_A_2812), .B(n_A_22), .Y(n_A_2T12) );
  NAND2X1 AA09 ( .A(n_A_2811), .B(n_A_22), .Y(n_A_2T11) );
  NAND2X1 AA10 ( .A(n_A_2810), .B(n_A_22), .Y(n_A_2T10) );
  NAND2X1 AA11 ( .A(n_A_289), .B(n_A_22), .Y(n_A_2T9) );
  NAND2X1 AA12 ( .A(n_A_288), .B(n_A_22), .Y(n_A_2T8) );
  NAND2X1 AA13 ( .A(n_A_287), .B(n_A_22), .Y(n_A_2T7) );
  NAND2X1 AA14 ( .A(n_A_286), .B(n_A_22), .Y(n_A_2T6) );
  NAND2X1 AA15 ( .A(n_A_285), .B(n_A_22), .Y(n_A_2T5) );
  NAND2X1 AA16 ( .A(n_A_284), .B(n_A_22), .Y(n_A_2T4) );
  NAND2X1 AA17 ( .A(n_A_283), .B(n_A_22), .Y(n_A_2T3) );
  NAND2X1 AA18 ( .A(n_A_282), .B(n_A_22), .Y(n_A_2T2) );
  NAND2X1 AB00 ( .A(n_A_2720), .B(n_A_23), .Y(n_A_2S20) );
  NAND2X1 AB01 ( .A(n_A_2719), .B(n_A_23), .Y(n_A_2S19) );
  NAND2X1 AB02 ( .A(n_A_2718), .B(n_A_23), .Y(n_A_2S18) );
  NAND2X1 AB03 ( .A(n_A_2717), .B(n_A_23), .Y(n_A_2S17) );
  NAND2X1 AB04 ( .A(n_A_2716), .B(n_A_23), .Y(n_A_2S16) );
  NAND2X1 AB05 ( .A(n_A_2715), .B(n_A_23), .Y(n_A_2S15) );
  NAND2X1 AB06 ( .A(n_A_2714), .B(n_A_23), .Y(n_A_2S14) );
  NAND2X1 AB07 ( .A(n_A_2713), .B(n_A_23), .Y(n_A_2S13) );
  NAND2X1 AB08 ( .A(n_A_2712), .B(n_A_23), .Y(n_A_2S12) );
  NAND2X1 AB09 ( .A(n_A_2711), .B(n_A_23), .Y(n_A_2S11) );
  NAND2X1 AB10 ( .A(n_A_2710), .B(n_A_23), .Y(n_A_2S10) );
  NAND2X1 AB11 ( .A(n_A_279), .B(n_A_23), .Y(n_A_2S9) );
  NAND2X1 AB12 ( .A(n_A_278), .B(n_A_23), .Y(n_A_2S8) );
  NAND2X1 AB13 ( .A(n_A_277), .B(n_A_23), .Y(n_A_2S7) );
  NAND2X1 AB14 ( .A(n_A_276), .B(n_A_23), .Y(n_A_2S6) );
  NAND2X1 AB15 ( .A(n_A_275), .B(n_A_23), .Y(n_A_2S5) );
  NAND2X1 AB16 ( .A(n_A_274), .B(n_A_23), .Y(n_A_2S4) );
  NAND2X1 AB17 ( .A(n_A_273), .B(n_A_23), .Y(n_A_2S3) );
  NAND2X1 AB18 ( .A(n_A_272), .B(n_A_23), .Y(n_A_2S2) );
  ND5D2 A600 ( .E(n_A_2920), .D(n_A_2A20), .C(n_A_2D20), .B(n_A_2C20), .A(
        n_A_2B20), .Y(TACO[0]) );
  ND5D2 A601 ( .E(n_A_2919), .D(n_A_2A19), .C(n_A_2D19), .B(n_A_2C19), .A(
        n_A_2B19), .Y(TACO[1]) );
  ND5D2 A602 ( .E(n_A_2918), .D(n_A_2A18), .C(n_A_2D18), .B(n_A_2C18), .A(
        n_A_2B18), .Y(TACO[2]) );
  ND5D2 A603 ( .E(n_A_2917), .D(n_A_2A17), .C(n_A_2D17), .B(n_A_2C17), .A(
        n_A_2B17), .Y(TACO[3]) );
  ND5D2 A604 ( .E(n_A_2916), .D(n_A_2A16), .C(n_A_2D16), .B(n_A_2C16), .A(
        n_A_2B16), .Y(TACO[4]) );
  ND5D2 A605 ( .E(n_A_2915), .D(n_A_2A15), .C(n_A_2D15), .B(n_A_2C15), .A(
        n_A_2B15), .Y(TACO[5]) );
  ND5D2 A606 ( .E(n_A_2914), .D(n_A_2A14), .C(n_A_2D14), .B(n_A_2C14), .A(
        n_A_2B14), .Y(TACO[6]) );
  ND5D2 A607 ( .E(n_A_2913), .D(n_A_2A13), .C(n_A_2D13), .B(n_A_2C13), .A(
        n_A_2B13), .Y(TACO[7]) );
  ND5D2 A608 ( .E(n_A_2912), .D(n_A_2A12), .C(n_A_2D12), .B(n_A_2C12), .A(
        n_A_2B12), .Y(TACO[8]) );
  ND5D2 A609 ( .E(n_A_2911), .D(n_A_2A11), .C(n_A_2D11), .B(n_A_2C11), .A(
        n_A_2B11), .Y(TACO[9]) );
  ND5D2 A610 ( .E(n_A_2910), .D(n_A_2A10), .C(n_A_2D10), .B(n_A_2C10), .A(
        n_A_2B10), .Y(TACO[10]) );
  ND5D2 A611 ( .E(n_A_299), .D(n_A_2A9), .C(n_A_2D9), .B(n_A_2C9), .A(n_A_2B9), 
        .Y(TACO[11]) );
  ND5D2 A612 ( .E(n_A_298), .D(n_A_2A8), .C(n_A_2D8), .B(n_A_2C8), .A(n_A_2B8), 
        .Y(TACO[12]) );
  ND5D2 A613 ( .E(n_A_297), .D(n_A_2A7), .C(n_A_2D7), .B(n_A_2C7), .A(n_A_2B7), 
        .Y(TACO[13]) );
  ND5D2 A614 ( .E(n_A_296), .D(n_A_2A6), .C(n_A_2D6), .B(n_A_2C6), .A(n_A_2B6), 
        .Y(TACO[14]) );
  ND5D2 A615 ( .E(n_A_295), .D(n_A_2A5), .C(n_A_2D5), .B(n_A_2C5), .A(n_A_2B5), 
        .Y(TACO[15]) );
  ND5D2 A616 ( .E(n_A_294), .D(n_A_2A4), .C(n_A_2D4), .B(n_A_2C4), .A(n_A_2B4), 
        .Y(TACO[16]) );
  ND5D2 A617 ( .E(n_A_293), .D(n_A_2A3), .C(n_A_2D3), .B(n_A_2C3), .A(n_A_2B3), 
        .Y(TACO[17]) );
  ND5D2 A618 ( .E(n_A_292), .D(n_A_2A2), .C(n_A_2D2), .B(n_A_2C2), .A(n_A_2B2), 
        .Y(TACO[18]) );
  ND6D2 AD00 ( .F(n_TBM00), .E(n_A_2S20), .D(n_A_2T20), .C(n_A_2U20), .B(
        n_A_2V20), .A(n_A_2W20), .Y(ESSD[0]) );
  ND6D2 AD01 ( .F(n_TBM01), .E(n_A_2S19), .D(n_A_2T19), .C(n_A_2U19), .B(
        n_A_2V19), .A(n_A_2W19), .Y(ESSD[1]) );
  ND6D2 AD02 ( .F(n_TBM02), .E(n_A_2S18), .D(n_A_2T18), .C(n_A_2U18), .B(
        n_A_2V18), .A(n_A_2W18), .Y(ESSD[2]) );
  ND6D2 AD03 ( .F(n_TBM03), .E(n_A_2S17), .D(n_A_2T17), .C(n_A_2U17), .B(
        n_A_2V17), .A(n_A_2W17), .Y(ESSD[3]) );
  ND6D2 AD04 ( .F(n_TBM04), .E(n_A_2S16), .D(n_A_2T16), .C(n_A_2U16), .B(
        n_A_2V16), .A(n_A_2W16), .Y(ESSD[4]) );
  ND6D2 AD05 ( .F(n_TBM05), .E(n_A_2S15), .D(n_A_2T15), .C(n_A_2U15), .B(
        n_A_2V15), .A(n_A_2W15), .Y(ESSD[5]) );
  ND6D2 AD06 ( .F(n_TBM06), .E(n_A_2S14), .D(n_A_2T14), .C(n_A_2U14), .B(
        n_A_2V14), .A(n_A_2W14), .Y(ESSD[6]) );
  ND6D2 AD07 ( .F(n_TBM07), .E(n_A_2S13), .D(n_A_2T13), .C(n_A_2U13), .B(
        n_A_2V13), .A(n_A_2W13), .Y(ESSD[7]) );
  ND6D2 AD08 ( .F(n_TBM08), .E(n_A_2S12), .D(n_A_2T12), .C(n_A_2U12), .B(
        n_A_2V12), .A(n_A_2W12), .Y(ESSD[8]) );
  ND6D2 AD09 ( .F(n_TBM09), .E(n_A_2S11), .D(n_A_2T11), .C(n_A_2U11), .B(
        n_A_2V11), .A(n_A_2W11), .Y(ESSD[9]) );
  ND6D2 AD10 ( .F(n_TBM10), .E(n_A_2S10), .D(n_A_2T10), .C(n_A_2U10), .B(
        n_A_2V10), .A(n_A_2W10), .Y(ESSD[10]) );
  ND6D2 AD11 ( .F(n_TBM11), .E(n_A_2S9), .D(n_A_2T9), .C(n_A_2U9), .B(n_A_2V9), 
        .A(n_A_2W9), .Y(ESSD[11]) );
  ND6D2 AD12 ( .F(n_TBM12), .E(n_A_2S8), .D(n_A_2T8), .C(n_A_2U8), .B(n_A_2V8), 
        .A(n_A_2W8), .Y(ESSD[12]) );
  ND6D2 AD13 ( .F(n_TBM13), .E(n_A_2S7), .D(n_A_2T7), .C(n_A_2U7), .B(n_A_2V7), 
        .A(n_A_2W7), .Y(ESSD[13]) );
  ND6D2 AD14 ( .F(n_TBM14), .E(n_A_2S6), .D(n_A_2T6), .C(n_A_2U6), .B(n_A_2V6), 
        .A(n_A_2W6), .Y(ESSD[14]) );
  ND6D2 AD15 ( .F(n_TBM15), .E(n_A_2S5), .D(n_A_2T5), .C(n_A_2U5), .B(n_A_2V5), 
        .A(n_A_2W5), .Y(ESSD[15]) );
  ND6D2 AD16 ( .F(n_TBM16), .E(n_A_2S4), .D(n_A_2T4), .C(n_A_2U4), .B(n_A_2V4), 
        .A(n_A_2W4), .Y(ESSD[16]) );
  ND6D2 AD17 ( .F(n_TBM17), .E(n_A_2S3), .D(n_A_2T3), .C(n_A_2U3), .B(n_A_2V3), 
        .A(n_A_2W3), .Y(ESSD[17]) );
  ND6D2 AD18 ( .F(n_TBM18), .E(n_A_2S2), .D(n_A_2T2), .C(n_A_2U2), .B(n_A_2V2), 
        .A(n_A_2W2), .Y(ESSD[18]) );
  NAND2X1 AC0 ( .A(TROMO[0]), .B(n_A_0U), .Y(n_TBM11) );
  NAND2X1 AC1 ( .A(TROMO[1]), .B(n_A_0U), .Y(n_TBM12) );
  NAND2X1 AC2 ( .A(TROMO[2]), .B(n_A_0U), .Y(n_TBM13) );
  NAND2X1 AC3 ( .A(TROMO[3]), .B(n_A_0U), .Y(n_TBM14) );
  NAND2X1 AC4 ( .A(TROMO[4]), .B(n_A_0U), .Y(n_TBM15) );
  NAND2X1 AC5 ( .A(TROMO[5]), .B(n_A_0U), .Y(n_TBM16) );
  NAND2X1 AC6 ( .A(TROMO[6]), .B(n_A_0U), .Y(n_TBM17) );
  TIEHI AE00 ( .Y(n_TBM00) );
  TIEHI AE01 ( .Y(n_TBM01) );
  TIEHI AE02 ( .Y(n_TBM02) );
  TIEHI AE03 ( .Y(n_TBM03) );
  TIEHI AE04 ( .Y(n_TBM04) );
  TIEHI AE05 ( .Y(n_TBM05) );
  TIEHI AE06 ( .Y(n_TBM06) );
  TIEHI AE07 ( .Y(n_TBM07) );
  TIEHI AE08 ( .Y(n_TBM08) );
  TIEHI AE09 ( .Y(n_TBM09) );
  TIEHI AE10 ( .Y(n_TBM10) );
  TIEHI A2K ( .Y(n_TBM19) );
  BUFX2 A1A ( .A(n_A_1C), .Y(n_A_0U) );
  BUFX4 A2P ( .A(n_A_2Y), .Y(n_A_08) );
  BUFX4 A1B ( .A(n_A_1D), .Y(n_A_23) );
  BUFX4 A19 ( .A(n_A_30), .Y(n_A_22) );
  BUFX4 A18 ( .A(n_A_1E), .Y(n_A_07) );
  BUFX4 A17 ( .A(n_A_2X), .Y(n_A_21) );
  BUFX4 A15 ( .A(DYACEN), .Y(n_A_1R) );
  BUFX4 A14 ( .A(CHACEN), .Y(n_A_1S) );
  BUFX4 A13 ( .A(REACEN), .Y(n_A_1T) );
  BUFX4 A12 ( .A(DLACEN), .Y(n_A_1U) );
  BUFX4 A16 ( .A(DRACEN), .Y(n_A_1V) );
  DLY1X1 A1T ( .A(n_A_33), .Y(n_A_0K) );
  DC06 A2T ( .C(n_A_1F), .B(n_A_31), .A(n_A_32), .Y0(n_A_2X), .Y1(n_A_1E), 
        .Y2(n_A_30), .Y3(n_A_1C), .Y4(n_A_1D), .Y5(n_A_2Y) );
  CO03 A2S ( .RN(n_A_0B), .TE(n_A_0P), .TI(TI), .CK(MCK), .SCL(ESSCL), .EN(
        ESSCE), .Q2(n_A_1F), .Q1(n_A_31), .Q0(n_A_32) );
  NAND2X1 AC7 ( .A(TROMO[7]), .B(n_A_0U), .Y(n_TBM18) );
  ND6D2 AD19 ( .F(n_TBM19), .E(n_A_2S1), .D(n_A_2T1), .C(n_A_2U1), .B(n_A_2V1), 
        .A(n_A_2W1), .Y(ESSD[19]) );
  ND5D2 A619 ( .E(n_A_291), .D(n_A_2A1), .C(n_A_2D1), .B(n_A_2C1), .A(n_A_2B1), 
        .Y(TACO[19]) );
  NAND2X1 AB19 ( .A(n_A_271), .B(n_A_23), .Y(n_A_2S1) );
  NAND2X1 AA19 ( .A(n_A_281), .B(n_A_22), .Y(n_A_2T1) );
  NAND2X1 A919 ( .A(n_A_021), .B(n_A_08), .Y(n_A_2U1) );
  NAND2X1 A819 ( .A(n_A_241), .B(n_A_07), .Y(n_A_2V1) );
  NAND2X1 A719 ( .A(n_A_251), .B(n_A_21), .Y(n_A_2W1) );
  NAND2X1 A519 ( .A(n_A_0H1), .B(n_A_1R), .Y(n_A_291) );
  NAND2X1 A419 ( .A(n_A_1H1), .B(n_A_1S), .Y(n_A_2A1) );
  NAND2X1 A319 ( .A(n_A_1J1), .B(n_A_1T), .Y(n_A_2D1) );
  NAND2X1 A219 ( .A(n_A_0G1), .B(n_A_1U), .Y(n_A_2C1) );
  NAND2X1 A119 ( .A(n_A_371), .B(n_A_1V), .Y(n_A_2B1) );
  INVX4 A2G ( .A(n_A_0K), .Y(n_A_0F) );
  AND2X2 A019 ( .A(TSO[19]), .B(n_A_0F), .Y(n_A_2P1) );
  OR2X1 A2D ( .A(DRACLE), .B(n_A_33), .Y(n_A_2H) );
  BUFX2 A2F ( .A(ACCL), .Y(n_A_33) );
  OR2X1 A2C ( .A(DLACLE), .B(n_A_33), .Y(n_A_2J) );
  OR2X1 A2B ( .A(RVACLE), .B(n_A_33), .Y(n_A_2K) );
  OR2X1 A2A ( .A(CHACLE), .B(n_A_33), .Y(n_A_2L) );
  OR2X1 A29 ( .A(DYACLE), .B(n_A_33), .Y(n_A_2M) );
  BUFX3 A25 ( .A(XRST), .Y(n_A_0B) );
  BUFX3 A1C ( .A(TE), .Y(n_A_0P) );
  FE20R A0A ( .D({n_A_0H1, n_A_0H2, n_A_0H3, n_A_0H4, n_A_0H5, n_A_0H6, 
        n_A_0H7, n_A_0H8, n_A_0H9, n_A_0H10, n_A_0H11, n_A_0H12, n_A_0H13, 
        n_A_0H14, n_A_0H15, n_A_0H16, n_A_0H17, n_A_0H18, n_A_0H19, n_A_0H20}), 
        .TI(n_A_0M), .RN(n_A_0B), .TE(n_A_0P), .CK(MCK), .EN(n_A_33), .Q({
        n_A_271, n_A_272, n_A_273, n_A_274, n_A_275, n_A_276, n_A_277, n_A_278, 
        n_A_279, n_A_2710, n_A_2711, n_A_2712, n_A_2713, n_A_2714, n_A_2715, 
        n_A_2716, n_A_2717, n_A_2718, n_A_2719, n_A_2720}), .TO(TO) );
  FE20R A09 ( .D({n_A_1H1, n_A_1H2, n_A_1H3, n_A_1H4, n_A_1H5, n_A_1H6, 
        n_A_1H7, n_A_1H8, n_A_1H9, n_A_1H10, n_A_1H11, n_A_1H12, n_A_1H13, 
        n_A_1H14, n_A_1H15, n_A_1H16, n_A_1H17, n_A_1H18, n_A_1H19, n_A_1H20}), 
        .TI(n_A_0N), .RN(n_A_0B), .TE(n_A_0P), .CK(MCK), .EN(n_A_33), .Q({
        n_A_281, n_A_282, n_A_283, n_A_284, n_A_285, n_A_286, n_A_287, n_A_288, 
        n_A_289, n_A_2810, n_A_2811, n_A_2812, n_A_2813, n_A_2814, n_A_2815, 
        n_A_2816, n_A_2817, n_A_2818, n_A_2819, n_A_2820}), .TO(n_A_0M) );
  FE20R A08 ( .D({n_A_1J1, n_A_1J2, n_A_1J3, n_A_1J4, n_A_1J5, n_A_1J6, 
        n_A_1J7, n_A_1J8, n_A_1J9, n_A_1J10, n_A_1J11, n_A_1J12, n_A_1J13, 
        n_A_1J14, n_A_1J15, n_A_1J16, n_A_1J17, n_A_1J18, n_A_1J19, n_A_1J20}), 
        .TI(n_A_0R), .RN(n_A_0B), .TE(n_A_0P), .CK(MCK), .EN(n_A_33), .Q({
        n_A_021, n_A_022, n_A_023, n_A_024, n_A_025, n_A_026, n_A_027, n_A_028, 
        n_A_029, n_A_0210, n_A_0211, n_A_0212, n_A_0213, n_A_0214, n_A_0215, 
        n_A_0216, n_A_0217, n_A_0218, n_A_0219, n_A_0220}), .TO(n_A_0N) );
  FE20R A07 ( .D({n_A_0G1, n_A_0G2, n_A_0G3, n_A_0G4, n_A_0G5, n_A_0G6, 
        n_A_0G7, n_A_0G8, n_A_0G9, n_A_0G10, n_A_0G11, n_A_0G12, n_A_0G13, 
        n_A_0G14, n_A_0G15, n_A_0G16, n_A_0G17, n_A_0G18, n_A_0G19, n_A_0G20}), 
        .TI(n_A_0T), .RN(n_A_0B), .TE(n_A_0P), .CK(MCK), .EN(n_A_33), .Q({
        n_A_241, n_A_242, n_A_243, n_A_244, n_A_245, n_A_246, n_A_247, n_A_248, 
        n_A_249, n_A_2410, n_A_2411, n_A_2412, n_A_2413, n_A_2414, n_A_2415, 
        n_A_2416, n_A_2417, n_A_2418, n_A_2419, n_A_2420}), .TO(n_A_0R) );
  FE20R A06 ( .D({n_A_371, n_A_372, n_A_373, n_A_374, n_A_375, n_A_376, 
        n_A_377, n_A_378, n_A_379, n_A_3710, n_A_3711, n_A_3712, n_A_3713, 
        n_A_3714, n_A_3715, n_A_3716, n_A_3717, n_A_3718, n_A_3719, n_A_3720}), 
        .TI(n_A_26), .RN(n_A_0B), .TE(n_A_0P), .CK(MCK), .EN(n_A_33), .Q({
        n_A_251, n_A_252, n_A_253, n_A_254, n_A_255, n_A_256, n_A_257, n_A_258, 
        n_A_259, n_A_2510, n_A_2511, n_A_2512, n_A_2513, n_A_2514, n_A_2515, 
        n_A_2516, n_A_2517, n_A_2518, n_A_2519, n_A_2520}), .TO(n_A_0T) );
  FE20R A05 ( .D({n_A_2P1, n_A_2P2, n_A_2P3, n_A_2P4, n_A_2P5, n_A_2P6, 
        n_A_2P7, n_A_2P8, n_A_2P9, n_A_2P10, n_A_2P11, n_A_2P12, n_A_2P13, 
        n_A_2P14, n_A_2P15, n_A_2P16, n_A_2P17, n_A_2P18, n_A_2P19, n_A_2P20}), 
        .TI(n_A_0V), .RN(n_A_0B), .TE(n_A_0P), .CK(MCK), .EN(n_A_2M), .Q({
        n_A_0H1, n_A_0H2, n_A_0H3, n_A_0H4, n_A_0H5, n_A_0H6, n_A_0H7, n_A_0H8, 
        n_A_0H9, n_A_0H10, n_A_0H11, n_A_0H12, n_A_0H13, n_A_0H14, n_A_0H15, 
        n_A_0H16, n_A_0H17, n_A_0H18, n_A_0H19, n_A_0H20}), .TO(n_A_26) );
  FE20R A04 ( .D({n_A_2P1, n_A_2P2, n_A_2P3, n_A_2P4, n_A_2P5, n_A_2P6, 
        n_A_2P7, n_A_2P8, n_A_2P9, n_A_2P10, n_A_2P11, n_A_2P12, n_A_2P13, 
        n_A_2P14, n_A_2P15, n_A_2P16, n_A_2P17, n_A_2P18, n_A_2P19, n_A_2P20}), 
        .TI(n_A_0W), .RN(n_A_0B), .TE(n_A_0P), .CK(MCK), .EN(n_A_2L), .Q({
        n_A_1H1, n_A_1H2, n_A_1H3, n_A_1H4, n_A_1H5, n_A_1H6, n_A_1H7, n_A_1H8, 
        n_A_1H9, n_A_1H10, n_A_1H11, n_A_1H12, n_A_1H13, n_A_1H14, n_A_1H15, 
        n_A_1H16, n_A_1H17, n_A_1H18, n_A_1H19, n_A_1H20}), .TO(n_A_0V) );
  FE20R A03 ( .D({n_A_2P1, n_A_2P2, n_A_2P3, n_A_2P4, n_A_2P5, n_A_2P6, 
        n_A_2P7, n_A_2P8, n_A_2P9, n_A_2P10, n_A_2P11, n_A_2P12, n_A_2P13, 
        n_A_2P14, n_A_2P15, n_A_2P16, n_A_2P17, n_A_2P18, n_A_2P19, n_A_2P20}), 
        .TI(n_A_0X), .RN(n_A_0B), .TE(n_A_0P), .CK(MCK), .EN(n_A_2K), .Q({
        n_A_1J1, n_A_1J2, n_A_1J3, n_A_1J4, n_A_1J5, n_A_1J6, n_A_1J7, n_A_1J8, 
        n_A_1J9, n_A_1J10, n_A_1J11, n_A_1J12, n_A_1J13, n_A_1J14, n_A_1J15, 
        n_A_1J16, n_A_1J17, n_A_1J18, n_A_1J19, n_A_1J20}), .TO(n_A_0W) );
  FE20R A02 ( .D({n_A_2P1, n_A_2P2, n_A_2P3, n_A_2P4, n_A_2P5, n_A_2P6, 
        n_A_2P7, n_A_2P8, n_A_2P9, n_A_2P10, n_A_2P11, n_A_2P12, n_A_2P13, 
        n_A_2P14, n_A_2P15, n_A_2P16, n_A_2P17, n_A_2P18, n_A_2P19, n_A_2P20}), 
        .TI(n_A_0Y), .RN(n_A_0B), .TE(n_A_0P), .CK(MCK), .EN(n_A_2J), .Q({
        n_A_0G1, n_A_0G2, n_A_0G3, n_A_0G4, n_A_0G5, n_A_0G6, n_A_0G7, n_A_0G8, 
        n_A_0G9, n_A_0G10, n_A_0G11, n_A_0G12, n_A_0G13, n_A_0G14, n_A_0G15, 
        n_A_0G16, n_A_0G17, n_A_0G18, n_A_0G19, n_A_0G20}), .TO(n_A_0X) );
  FE20R A01 ( .D({n_A_2P1, n_A_2P2, n_A_2P3, n_A_2P4, n_A_2P5, n_A_2P6, 
        n_A_2P7, n_A_2P8, n_A_2P9, n_A_2P10, n_A_2P11, n_A_2P12, n_A_2P13, 
        n_A_2P14, n_A_2P15, n_A_2P16, n_A_2P17, n_A_2P18, n_A_2P19, n_A_2P20}), 
        .TI(n_A_1F), .RN(n_A_0B), .TE(n_A_0P), .CK(MCK), .EN(n_A_2H), .Q({
        n_A_371, n_A_372, n_A_373, n_A_374, n_A_375, n_A_376, n_A_377, n_A_378, 
        n_A_379, n_A_3710, n_A_3711, n_A_3712, n_A_3713, n_A_3714, n_A_3715, 
        n_A_3716, n_A_3717, n_A_3718, n_A_3719, n_A_3720}), .TO(n_A_0Y) );
endmodule


module DC06 ( C, B, A, Y0, Y1, Y2, Y3, Y4, Y5 );
  input C, B, A;
  output Y0, Y1, Y2, Y3, Y4, Y5;
  wire   n_A_0D, n_A_0C, n_A_09, n_A_0E, n_A_0B, n_A_0A;

  AND3X1 A01 ( .A(n_A_0D), .B(n_A_0C), .C(n_A_09), .Y(Y5) );
  AND3X1 A02 ( .A(n_A_0E), .B(n_A_0C), .C(n_A_09), .Y(Y4) );
  AND3X1 A03 ( .A(n_A_0D), .B(n_A_0B), .C(n_A_0A), .Y(Y3) );
  AND3X1 A04 ( .A(n_A_0E), .B(n_A_0B), .C(n_A_0A), .Y(Y2) );
  AND3X1 A05 ( .A(n_A_0D), .B(n_A_0C), .C(n_A_0A), .Y(Y1) );
  AND3X1 A06 ( .A(n_A_0E), .B(n_A_0C), .C(n_A_0A), .Y(Y0) );
  INVX1 A0B ( .A(n_A_0D), .Y(n_A_0E) );
  INVX1 A0D ( .A(n_A_0B), .Y(n_A_0C) );
  INVX1 A0F ( .A(n_A_09), .Y(n_A_0A) );
  BUFX2 A0E ( .A(A), .Y(n_A_0D) );
  BUFX2 A0C ( .A(B), .Y(n_A_0B) );
  BUFX2 A0A ( .A(C), .Y(n_A_09) );
endmodule


module ND6D2 ( F, E, D, C, B, A, Y );
  input F, E, D, C, B, A;
  output Y;
  wire   n_A_03, n_A_01;

  NAND2X2 A03 ( .A(n_A_03), .B(n_A_01), .Y(Y) );
  AND3X1 A02 ( .A(D), .B(E), .C(F), .Y(n_A_01) );
  AND3X1 A01 ( .A(A), .B(B), .C(C), .Y(n_A_03) );
endmodule


module ND5D2 ( E, D, C, B, A, Y );
  input E, D, C, B, A;
  output Y;
  wire   n_A_01, n_A_07;

  NAND2X2 A09 ( .A(n_A_01), .B(n_A_07), .Y(Y) );
  AND2X1 A08 ( .A(D), .B(E), .Y(n_A_07) );
  AND3X1 A01 ( .A(A), .B(B), .C(C), .Y(n_A_01) );
endmodule


module WMA ( WEMDO, PMD, PMA, WIMDO, GPA, GPD, CHTEST, WMDRE, ENP, WWREQ, 
        CHOSLD, TE, XRST, FSYNC, START, TI, WMDWE, MCK, WST1, WST0, SLWD, 
        WEMDI, WEMA, WIMA, WIMDI, PLACA, PITB, WMRD, CHS, FMODE, CHOFDT, TSYNC, 
        CHONLE, TO, XWIMWE, WWRDY, XWEMWE, XWEMOC, WSCST );
  input [7:0] WEMDO;
  input [15:0] PMD;
  input [8:0] PMA;
  input [15:0] WIMDO;
  input [3:0] GPA;
  input [15:0] GPD;
  output [19:0] SLWD;
  output [7:0] WEMDI;
  output [23:0] WEMA;
  output [8:0] WIMA;
  output [15:0] WIMDI;
  output [6:0] PLACA;
  output [3:0] PITB;
  output [7:0] WMRD;
  output [5:0] CHS;
  output [1:0] FMODE;
  input CHTEST, WMDRE, ENP, WWREQ, CHOSLD, TE, XRST, FSYNC, START, TI, WMDWE,
         MCK, WST1, WST0;
  output CHOFDT, TSYNC, CHONLE, TO, XWIMWE, WWRDY, XWEMWE, XWEMOC, WSCST;
  wire   n_A_2Y, n_A_2X, n_A_2W, n_A_2R, n_A_2U, n_A_2T, n_A_2S, n_A_0S,
         n_A_2M, n_A_2N, n_A_1J, n_A_44, n_A_2P, n_A_0C, n_A_28, n_A_2J1,
         n_A_2J2, n_A_2J3, n_A_2J4, n_A_2J5, n_A_2J6, n_A_2J7, n_A_2J8,
         n_A_2J9, n_A_2J10, n_A_2J11, n_A_2J12, n_A_2J13, n_A_2J14, n_A_2J15,
         n_A_2J16, n_A_201, n_A_202, n_A_203, n_A_204, n_A_2K1, n_A_2K2,
         n_A_2K3, n_A_2K4, n_A_2K5, n_A_2K6, n_A_2K7, n_A_2L1, n_A_2L2,
         n_A_2L3, n_A_2L4, n_A_2L5, n_A_2L6, n_A_2L7, n_A_2L8, n_A_2L9,
         n_A_2L10, n_A_2L11, n_A_2L12, n_A_2L13, n_A_2L14, n_A_2L15, n_A_2L16,
         n_A_2H1, n_A_2H2, n_A_0Y1, n_A_0Y2, n_A_0Y3, n_A_0Y4, n_A_0Y5,
         n_A_0Y6, n_A_0Y7, n_A_0Y8, n_A_0Y9, n_A_0Y10, n_A_0Y11, n_A_0Y12,
         n_A_0Y13, n_A_0Y14, n_A_0Y15, n_A_0Y16, n_A_13, n_A_1C, n_A_38,
         n_A_26, n_A_0H, n_A_3C, n_A_3A, n_A_3F, n_A_07, n_A_3T, n_A_0M,
         n_A_0D, n_A_3D, n_A_3U, n_A_3G, n_A_36, n_A_31, n_A_0F, n_A_3K,
         n_A_1B, n_A_39, n_A_3B, n_A_3J, n_A_1D, n_A_3L, n_A_3W, n_A_3X,
         n_A_3N, n_A_1X, n_A_3P, n_A_3R, n_A_3S, n_A_0K, n_A_0J, n_A_1A,
         n_A_37, n_A_101, n_A_102, n_A_103, n_A_104, n_A_105, n_A_106, n_A_107,
         n_A_108, n_A_109, n_A_0T, n_A_45, n_A_40, n_WR106, n_A_3H, n_A_0N,
         n_A_1K, n_A_09, n_A_0P1, n_A_0P2, n_A_0P3, n_A_3V, n_A_18, n_A_05,
         n_A_141, n_A_142, n_A_143, n_A_144, n_A_1F, n_A_431, n_A_432, n_A_433,
         n_A_434, n_A_435, n_A_436, n_A_437, n_A_438, n_A_439, n_A_4310,
         n_A_4311, n_A_4312, n_A_4313, n_A_4314, n_A_4315, n_A_4316, n_A_1R1,
         n_A_1R2, n_A_1R3, n_A_1R4, n_A_1R5, n_A_1R6, n_A_1R7, n_A_1R8,
         n_A_1R9, n_A_1R10, n_A_1R11, n_A_1R12, n_A_1R13, n_A_1R14, n_A_1R15,
         n_A_1R16, n_A_2B1, n_A_2B2, n_A_2B3, n_A_2B4, n_A_2B5, n_A_2B6,
         n_A_2B7, n_A_2B8, n_A_2B9, n_A_2B10, n_A_2B11, n_A_2B12, n_A_2B13,
         n_A_2B14, n_A_2B15, n_A_2B16, n_A_3M, n_WMADR19, n_WMADR18, n_WMADR17,
         n_WMADR16, n_WMADR15, n_WMADR14, n_WMADR13, n_WMADR12, n_WMADR11,
         n_WMADR10, n_WMADR09, n_WMADR08, n_WMADR07, n_WMADR06, n_WMADR05,
         n_WMADR04, n_WMADR03, n_WMADR02, n_WMADR01, n_WMADR00, n_WR105,
         n_WR104, n_WR103, n_WR102, n_WR101, n_WR100;

  WMREG A04 ( .WIMO(WIMDO), .WR6LE(n_A_28), .WR0LE(n_A_2Y), .MCK(MCK), .XRST(
        n_A_2P), .WR1LE(n_A_2X), .TE(n_A_44), .WR7LE(n_A_2S), .WR2LE(n_A_2W), 
        .WR5LE(n_A_2T), .TI(TI), .WR4LE(n_A_2U), .RPDSEN(n_A_2R), .WSMSB(
        n_A_0S), .PITCH({n_A_2H1, n_A_2H2, n_A_0Y1, n_A_0Y2, n_A_0Y3, n_A_0Y4, 
        n_A_0Y5, n_A_0Y6, n_A_0Y7, n_A_0Y8, n_A_0Y9, n_A_0Y10, n_A_0Y11, 
        n_A_0Y12, n_A_0Y13, n_A_0Y14, n_A_0Y15, n_A_0Y16}), .PLACA(PLACA), 
        .RPD({n_A_2J1, n_A_2J2, n_A_2J3, n_A_2J4, n_A_2J5, n_A_2J6, n_A_2J7, 
        n_A_2J8, n_A_2J9, n_A_2J10, n_A_2J11, n_A_2J12, n_A_2J13, n_A_2J14, 
        n_A_2J15, n_A_2J16}), .FMODE(FMODE), .WEMAH({n_A_201, n_A_202, n_A_203, 
        n_A_204}), .PLCD({n_A_2K1, n_A_2K2, n_A_2K3, n_A_2K4, n_A_2K5, n_A_2K6, 
        n_A_2K7}), .PACH({n_A_2L1, n_A_2L2, n_A_2L3, n_A_2L4, n_A_2L5, n_A_2L6, 
        n_A_2L7, n_A_2L8, n_A_2L9, n_A_2L10, n_A_2L11, n_A_2L12, n_A_2L13, 
        n_A_2L14, n_A_2L15, n_A_2L16}), .LDIRC(n_A_1J), .TO(n_A_0C), .WMODE1(
        n_A_2N), .WMODE0(n_A_2M) );
  WMASQ A01 ( .CHTEST(CHTEST), .ENP(n_A_13), .LDIRC(n_A_1J), .MCK(MCK), .TI(
        n_A_0C), .TE(n_A_44), .XRST(n_A_2P), .SCHON(CHOSLD), .FSYNC(FSYNC), 
        .START(START), .WR1SE(n_A_3G), .WIMEA({n_A_101, n_A_102, n_A_103, 
        n_A_104, n_A_105, n_A_106, n_A_107, n_A_108, n_A_109}), .CHS(CHS), 
        .TO(n_A_0M), .CHONLE(CHONLE), .WPWEN(n_A_26), .WEMLE(n_A_1X), .TSYNC(
        TSYNC), .WSCST(WSCST), .WR6LE(n_A_28), .PITLEN(n_A_3A), .WR7LE(n_A_2S), 
        .WMDILE(n_A_1A), .PLCCLE(n_A_3T), .WNLE(n_A_3U), .WAPCEN(n_A_3K), 
        .PITALE(n_A_3R), .W3ICE(n_A_3N), .W2ICE(n_A_3X), .W1ICE(n_A_3W), 
        .PITBLE(n_A_3J), .WADBLE(n_A_07), .W0ICE(n_A_3L), .WRPEN(n_A_38), 
        .WRLEN(n_A_3B), .WR0EN(n_A_39), .WR1EN(n_A_1C), .RPDSEN(n_A_2R), 
        .WSOEN(n_A_1B), .WIMOEN(n_A_0F), .PLCCEN(n_A_31), .WMADS(n_A_36), 
        .WAIVEN(n_A_1D), .WCRLE(n_A_3D), .WR5LE(n_A_2T), .WR4LE(n_A_2U), 
        .WR3LE(n_A_0D), .WR2LE(n_A_2W), .WR1LE(n_A_2X), .WR0LE(n_A_2Y), 
        .WDRCLE(n_A_37), .W3LE(n_A_0H), .W2LE(n_A_0J), .W1LE(n_A_0K), .W0LE(
        n_A_3S), .NSTLE(n_A_3P), .WIMWE(n_A_3F), .WABLE(n_A_3C) );
  WPTLP A05 ( .PITH({n_A_2H1, n_A_2H2}), .NSTLE(n_A_3P), .CARRY(n_A_0T), 
        .WAPCEN(n_A_3K), .TI(n_A_1K), .MCK(MCK), .WDRCLE(n_A_37), .PITALE(
        n_A_3R), .XRST(n_A_2P), .W1ICE(n_A_3W), .W2ICE(n_A_3X), .W3ICE(n_A_3N), 
        .W0ICE(n_A_3L), .CHNEN(CHOSLD), .PITBLE(n_A_3J), .TE(n_A_44), .WMODE1(
        n_A_2N), .WMODE0(n_A_2M), .WRLEN(n_A_3B), .LDIRC(n_A_1J), .WSMSB(
        n_A_0S), .WAIVEN(n_A_1D), .W3LE(n_A_0H), .W2LE(n_A_0J), .W1LE(n_A_0K), 
        .W0LE(n_A_3S), .PITB(PITB), .RLD({n_A_0P1, n_A_0P2, n_A_0P3}), 
        .WABINC(n_A_09), .NLCDLE(n_A_3H), .WR1SE(n_A_3G), .CHOFDT(CHOFDT), 
        .WR106(n_WR106), .TO(n_A_0N), .WNDIRC(n_A_40), .WAIVCT(n_A_45) );
  WMD A0E ( .WEMDO(WEMDO), .CDI({n_A_141, n_A_142, n_A_143, n_A_144}), .WEMRE(
        n_A_3V), .MCK(MCK), .WST1(WST1), .WST0(WST0), .W0LE(n_A_3S), .W1LE(
        n_A_0K), .W2LE(n_A_0J), .W3LE(n_A_0H), .TE(n_A_44), .XRST(n_A_2P), 
        .TI(n_A_05), .WMDILE(n_A_1A), .SLWD(SLWD), .WMRD(WMRD), .WCCD(n_A_18), 
        .TO(TO) );
  WMOPU A0F ( .WDB({n_A_431, n_A_432, n_A_433, n_A_434, n_A_435, n_A_436, 
        n_A_437, n_A_438, n_A_439, n_A_4310, n_A_4311, n_A_4312, n_A_4313, 
        n_A_4314, n_A_4315, n_A_4316}), .RLD({n_A_0P1, n_A_0P2, n_A_0P3}), 
        .RPD({n_A_2J1, n_A_2J2, n_A_2J3, n_A_2J4, n_A_2J5, n_A_2J6, n_A_2J7, 
        n_A_2J8, n_A_2J9, n_A_2J10, n_A_2J11, n_A_2J12, n_A_2J13, n_A_2J14, 
        n_A_2J15, n_A_2J16}), .PACH({n_A_2L1, n_A_2L2, n_A_2L3, n_A_2L4, 
        n_A_2L5, n_A_2L6, n_A_2L7, n_A_2L8, n_A_2L9, n_A_2L10, n_A_2L11, 
        n_A_2L12, n_A_2L13, n_A_2L14, n_A_2L15, n_A_2L16}), .PITL({n_A_0Y1, 
        n_A_0Y2, n_A_0Y3, n_A_0Y4, n_A_0Y5, n_A_0Y6, n_A_0Y7, n_A_0Y8, n_A_0Y9, 
        n_A_0Y10, n_A_0Y11, n_A_0Y12, n_A_0Y13, n_A_0Y14, n_A_0Y15, n_A_0Y16}), 
        .PITLEN(n_A_3A), .MSBLE(n_A_37), .WABINC(n_A_09), .TE(n_A_44), .XRST(
        n_A_2P), .WMADS(n_A_36), .WRPEN(n_A_38), .WR0EN(n_A_39), .WAIVCT(
        n_A_45), .TI(n_A_0N), .WRLEN(n_A_3B), .WABLE(n_A_3C), .WCRLE(n_A_3D), 
        .MCK(MCK), .WSO({n_A_1R1, n_A_1R2, n_A_1R3, n_A_1R4, n_A_1R5, n_A_1R6, 
        n_A_1R7, n_A_1R8, n_A_1R9, n_A_1R10, n_A_1R11, n_A_1R12, n_A_1R13, 
        n_A_1R14, n_A_1R15, n_A_1R16}), .WADI({n_A_2B1, n_A_2B2, n_A_2B3, 
        n_A_2B4, n_A_2B5, n_A_2B6, n_A_2B7, n_A_2B8, n_A_2B9, n_A_2B10, 
        n_A_2B11, n_A_2B12, n_A_2B13, n_A_2B14, n_A_2B15, n_A_2B16}), .CARRY(
        n_A_0T), .WSMSB(n_A_0S), .TO(n_A_1F) );
  WEMIF A0D ( .WEMAR({n_WMADR19, n_WMADR18, n_WMADR17, n_WMADR16, n_WMADR15, 
        n_WMADR14, n_WMADR13, n_WMADR12, n_WMADR11, n_WMADR10, n_WMADR09, 
        n_WMADR08, n_WMADR07, n_WMADR06, n_WMADR05, n_WMADR04, n_WMADR03, 
        n_WMADR02, n_WMADR01, n_WMADR00}), .WEMAH({n_A_201, n_A_202, n_A_203, 
        n_A_204}), .GPD(GPD), .GPA(GPA), .MCK(MCK), .WMDRE(WMDRE), .WMDWE(
        WMDWE), .WEMLE(n_A_1X), .XRST(n_A_2P), .ENP(n_A_13), .TE(n_A_44), 
        .WSCST(WSCST), .TI(n_A_3M), .WEMA(WEMA), .WEMDI(WEMDI), .TO(n_A_05), 
        .WEMRE(n_A_3V), .XWEMOC(XWEMOC), .XWEMWE(XWEMWE) );
  WDBMX A0G ( .WR1O({n_WR106, n_WR105, n_WR104, n_WR103, n_WR102, n_WR101, 
        n_WR100}), .WSO({n_A_1R1, n_A_1R2, n_A_1R3, n_A_1R4, n_A_1R5, n_A_1R6, 
        n_A_1R7, n_A_1R8, n_A_1R9, n_A_1R10, n_A_1R11, n_A_1R12, n_A_1R13, 
        n_A_1R14, n_A_1R15, n_A_1R16}), .WIMO(WIMDO), .WIMOEN(n_A_0F), .WSOEN(
        n_A_1B), .WR1OEN(n_A_1C), .WDB({n_A_431, n_A_432, n_A_433, n_A_434, 
        n_A_435, n_A_436, n_A_437, n_A_438, n_A_439, n_A_4310, n_A_4311, 
        n_A_4312, n_A_4313, n_A_4314, n_A_4315, n_A_4316}) );
  WIMCNT A02 ( .WDB({n_A_431, n_A_432, n_A_433, n_A_434, n_A_435, n_A_436, 
        n_A_437, n_A_438, n_A_439, n_A_4310, n_A_4311, n_A_4312, n_A_4313, 
        n_A_4314, n_A_4315, n_A_4316}), .PMD(PMD), .WIMEA({n_A_101, n_A_102, 
        n_A_103, n_A_104, n_A_105, n_A_106, n_A_107, n_A_108, n_A_109}), .PMA(
        PMA), .WIMWE(n_A_3F), .ENP(n_A_13), .WWREQ(WWREQ), .WSCST(WSCST), 
        .WPWEN(n_A_26), .WIMA(WIMA), .WIMI(WIMDI), .XWIMWE(XWIMWE), .WWRDY(
        WWRDY) );
  WMAG A0C ( .WDB({n_A_431, n_A_432, n_A_433, n_A_434, n_A_435, n_A_436, 
        n_A_437, n_A_438, n_A_439, n_A_4310, n_A_4311, n_A_4312, n_A_4313, 
        n_A_4314, n_A_4315, n_A_4316}), .WADI({n_A_2B1, n_A_2B2, n_A_2B3, 
        n_A_2B4, n_A_2B5, n_A_2B6, n_A_2B7, n_A_2B8, n_A_2B9, n_A_2B10, 
        n_A_2B11, n_A_2B12, n_A_2B13, n_A_2B14, n_A_2B15, n_A_2B16}), .XRST(
        n_A_2P), .WADBLE(n_A_07), .TE(n_A_44), .TI(n_A_1F), .MCK(MCK), .WR3LE(
        n_A_0D), .WMADR({n_WMADR19, n_WMADR18, n_WMADR17, n_WMADR16, n_WMADR15, 
        n_WMADR14, n_WMADR13, n_WMADR12, n_WMADR11, n_WMADR10, n_WMADR09, 
        n_WMADR08, n_WMADR07, n_WMADR06, n_WMADR05, n_WMADR04, n_WMADR03, 
        n_WMADR02, n_WMADR01, n_WMADR00}), .TO(n_A_3M) );
  BUFX2 A1Y ( .A(ENP), .Y(n_A_13) );
  BUFX4 A0R ( .A(TE), .Y(n_A_44) );
  BUFX4 A06 ( .A(XRST), .Y(n_A_2P) );
  WLCDCT A0H ( .PLCD({n_A_2K1, n_A_2K2, n_A_2K3, n_A_2K4, n_A_2K5, n_A_2K6, 
        n_A_2K7}), .XRST(n_A_2P), .NLCDLE(n_A_3H), .TE(n_A_44), .PLCCLE(n_A_3T), .WNDIRC(n_A_40), .PLCCEN(n_A_31), .WMAQ0(n_WMADR00), .WNLE(n_A_3U), .WCCD(
        n_A_18), .TI(n_A_0M), .MCK(MCK), .CDI({n_A_141, n_A_142, n_A_143, 
        n_A_144}), .WR1O({n_WR105, n_WR104, n_WR103, n_WR102, n_WR101, n_WR100}), .TO(n_A_1K) );
endmodule


module WLCDCT ( PLCD, XRST, NLCDLE, TE, PLCCLE, WNDIRC, PLCCEN, WMAQ0, WNLE, 
        WCCD, TI, MCK, CDI, WR1O, TO );
  input [6:0] PLCD;
  output [3:0] CDI;
  output [5:0] WR1O;
  input XRST, NLCDLE, TE, PLCCLE, WNDIRC, PLCCEN, WMAQ0, WNLE, WCCD, TI, MCK;
  output TO;
  wire   n_A_0L, n_A_0K, n_A_17, n_A_0R, n_NLCD0, n_A_0U, n_A_0S, n_A_1C,
         n_A_0H, n_A_19, n_NLCD1, n_A_1E, n_A_1G, n_A_1H, n_A_1A, n_A_1F,
         n_A_1B, n_A_1D, n_A_1J, n_A_1K, n_A_0J, n_A_1L, n_A_1M, n_A_0F,
         n_A_0G;

  FE1R A0L ( .RN(n_A_0L), .TE(n_A_17), .TI(n_A_0K), .CK(MCK), .EN(n_A_0R), .D(
        WMAQ0), .Q(n_NLCD0) );
  OR2X1 A0W ( .A(n_A_0U), .B(PLCCLE), .Y(n_A_0R) );
  BUFX2 A0M ( .A(WNLE), .Y(n_A_0U) );
  BUFX2 A10 ( .A(TE), .Y(n_A_17) );
  BUFX2 A0Y ( .A(XRST), .Y(n_A_0L) );
  BUFX2 A0X ( .A(NLCDLE), .Y(n_A_0S) );
  INVX1 A0V ( .A(n_NLCD0), .Y(n_A_1C) );
  INVX1 A0S ( .A(n_A_0H), .Y(n_A_19) );
  BUFX2 A0K ( .A(WCCD), .Y(n_NLCD1) );
  NAND2X1 A0J ( .A(n_A_1E), .B(n_A_1G), .Y(n_A_1H) );
  INVX1 A0H ( .A(n_A_1A), .Y(n_A_1F) );
  AOI22X1 A0G ( .A0(PLCD[6]), .A1(n_A_0H), .B0(WNDIRC), .B1(n_A_19), .Y(n_A_1A) );
  NAND3X1 A0F ( .A(n_A_1B), .B(n_NLCD0), .C(n_A_1F), .Y(n_A_1G) );
  NAND3X1 A0E ( .A(n_A_1D), .B(n_A_1C), .C(n_A_1A), .Y(n_A_1E) );
  INVX1 A0D ( .A(n_A_1B), .Y(n_A_1D) );
  INVX1 A0C ( .A(n_A_1J), .Y(n_A_1K) );
  AOI22X1 A0B ( .A0(PLCD[4]), .A1(n_A_0H), .B0(n_A_0J), .B1(n_A_19), .Y(n_A_1B) );
  AOI22X1 A0A ( .A0(PLCD[5]), .A1(n_A_0H), .B0(n_A_0K), .B1(n_A_19), .Y(n_A_1J) );
  AND2X1 A09 ( .A(n_NLCD1), .B(n_A_1H), .Y(n_A_1L) );
  AND2X1 A08 ( .A(n_A_1K), .B(n_A_1H), .Y(n_A_1M) );
  FE1R A07 ( .RN(n_A_0L), .TE(n_A_17), .TI(n_A_0J), .CK(MCK), .EN(n_A_0R), .D(
        PLCCEN), .Q(n_A_0H) );
  FE1R A06 ( .RN(n_A_0L), .TE(n_A_17), .TI(n_NLCD0), .CK(MCK), .EN(n_A_0U), 
        .D(n_NLCD0), .Q(n_A_0J) );
  FE1R A05 ( .RN(n_A_0L), .TE(n_A_17), .TI(TI), .CK(MCK), .EN(n_A_0U), .D(
        n_NLCD1), .Q(n_A_0K) );
  FE02R A03 ( .D({n_NLCD1, n_NLCD0}), .EN(n_A_0S), .RN(n_A_0L), .TE(n_A_17), 
        .TI(n_A_0F), .CK(MCK), .Q(WR1O[5:4]), .TO(TO) );
  FE04R A02 ( .D(CDI), .CK(MCK), .RN(n_A_0L), .TE(n_A_17), .EN(n_A_0S), .TI(
        n_A_0G), .Q(WR1O[3:0]), .TO(n_A_0F) );
  UD04 A01 ( .LD(PLCD[3:0]), .RN(n_A_0L), .TE(n_A_17), .TI(n_A_0H), .EN(n_A_0R), .CK(MCK), .LE(PLCCEN), .UE(n_A_1M), .DE(n_A_1L), .S(CDI), .TO(n_A_0G) );
endmodule


module UD04 ( LD, RN, TE, TI, EN, CK, LE, UE, DE, S, TO );
  input [3:0] LD;
  output [3:0] S;
  input RN, TE, TI, EN, CK, LE, UE, DE;
  output TO;
  wire   n_A_02, n_A_0L, n_A_0M, n_A_0N, n_A_0P, n_A_0R, n_A_0V, n_A_0U,
         n_A_0T, n_A_0S;

  INVX1 A0N ( .A(LE), .Y(n_A_02) );
  BUFX2 A04 ( .A(DE), .Y(n_A_0L) );
  ADD04 A01 ( .CI(UE), .B0(n_A_0R), .B1(n_A_0P), .B2(n_A_0N), .B3(n_A_0M), 
        .A0(n_A_0L), .A1(n_A_0L), .A2(n_A_0L), .A3(n_A_0L), .S0(S[0]), .S1(
        S[1]), .S2(S[2]), .S3(S[3]) );
  FE4R A03 ( .TI(TI), .CK(CK), .D3(n_A_0V), .D2(n_A_0U), .D1(n_A_0T), .D0(
        n_A_0S), .EN(EN), .TE(TE), .RN(RN), .TO(TO), .Q0(n_A_0R), .Q1(n_A_0P), 
        .Q2(n_A_0N), .Q3(n_A_0M) );
  DS42 A02 ( .S(n_A_02), .B3(S[0]), .A3(LD[0]), .B2(S[1]), .A2(LD[1]), .B1(
        S[2]), .A1(LD[2]), .B0(S[3]), .A0(LD[3]), .Y3(n_A_0S), .Y2(n_A_0T), 
        .Y1(n_A_0U), .Y0(n_A_0V) );
endmodule


module ADD04 ( CI, B0, B1, B2, B3, A0, A1, A2, A3, S0, S1, S2, S3, CO );
  input CI, B0, B1, B2, B3, A0, A1, A2, A3;
  output S0, S1, S2, S3, CO;
  wire   n_A_19, n_PN1, n_GN0, n_PN3, n_A_1A, n_PN2, n_A_1C, n_GN3, n_GN2,
         n_GN1, n_PN0, n_A_1B, n_A_1D, n_A_18, n_A_17;

  INVX1 A0K ( .A(n_A_19), .Y(CO) );
  XOR2X1 A0J ( .A(n_PN1), .B(n_GN0), .Y(S1) );
  XNOR2X1 A0H ( .A(n_PN3), .B(n_A_1A), .Y(S3) );
  XNOR2X1 A0G ( .A(n_PN2), .B(n_A_1C), .Y(S2) );
  NAND2X2 A08 ( .A(A3), .B(B3), .Y(n_GN3) );
  NAND2X2 A07 ( .A(A2), .B(B2), .Y(n_GN2) );
  NAND2X2 A06 ( .A(A1), .B(B1), .Y(n_GN1) );
  INVX1 A0F ( .A(n_PN0), .Y(S0) );
  INVX1 A0E ( .A(n_A_1B), .Y(n_A_1C) );
  INVX1 A0D ( .A(n_A_1D), .Y(n_A_1B) );
  AOI21X1 A0C ( .A0(n_A_18), .A1(n_A_1D), .B0(n_A_17), .Y(n_A_19) );
  CODD4 A0B ( .GHN(n_GN3), .GLN(n_GN2), .PLN(n_PN2), .PHN(n_PN3), .GO(n_A_17), 
        .PO(n_A_18) );
  OAI21X1 A0A ( .A0(n_PN2), .A1(n_A_1B), .B0(n_GN2), .Y(n_A_1A) );
  OAI21X1 A09 ( .A0(n_PN1), .A1(n_GN0), .B0(n_GN1), .Y(n_A_1D) );
  AOI222X2 A05 ( .A0(A0), .A1(B0), .B0(A0), .B1(CI), .C0(B0), .C1(CI), .Y(
        n_GN0) );
  XNOR2X2 A04 ( .A(A3), .B(B3), .Y(n_PN3) );
  XNOR2X2 A03 ( .A(A2), .B(B2), .Y(n_PN2) );
  XNOR2X2 A02 ( .A(A1), .B(B1), .Y(n_PN1) );
  XN3D2 A01 ( .C(CI), .B(B0), .A(A0), .Y(n_PN0) );
endmodule


module WMAG ( WDB, WADI, XRST, WADBLE, TE, TI, MCK, WR3LE, WMADR, TO );
  input [15:0] WDB;
  input [15:0] WADI;
  output [19:0] WMADR;
  input XRST, WADBLE, TE, TI, MCK, WR3LE;
  output TO;
  wire   n_AI00, n_AI01, n_AI02, n_BI16, n_BI17, n_BI18, n_A_0N1, n_A_0N2,
         n_A_0N3, n_A_0N4, n_A_0N5, n_A_0N6, n_A_0N7, n_A_0N8, n_A_0N9,
         n_A_0N10, n_A_0N11, n_A_0N12, n_A_0N13, n_A_0N14, n_A_0N15, n_A_0N16,
         n_AI19, n_AI18, n_AI17, n_AI16, n_AI15, n_AI14, n_AI13, n_AI12,
         n_AI11, n_AI10, n_AI09, n_AI08, n_AI07, n_AI06, n_AI05, n_AI04,
         n_A_0M1, n_A_0M2, n_A_0M3, n_A_0M4, n_A_0M5, n_A_0M6, n_A_0M7,
         n_A_0M8, n_A_0M9, n_A_0M10, n_A_0M11, n_A_0M12, n_A_0M13, n_A_0M14,
         n_A_0M15, n_A_0M16, n_BI15, n_BI14, n_BI13, n_BI12, n_BI11, n_BI10,
         n_BI09, n_BI08, n_BI07, n_BI06, n_BI05, n_BI04, n_BI03, n_BI02,
         n_BI01, n_BI00, n_A_0C, n_A_08, n_A_0A, n_BI19, n_AI03;

  TIELO A0C0 ( .Y(n_AI00) );
  TIELO A0C1 ( .Y(n_AI01) );
  TIELO A0C2 ( .Y(n_AI02) );
  TIELO A0D0 ( .Y(n_BI16) );
  TIELO A0D1 ( .Y(n_BI17) );
  TIELO A0D2 ( .Y(n_BI18) );
  DS162 A0U ( .A({n_A_0N1, n_A_0N2, n_A_0N3, n_A_0N4, n_A_0N5, n_A_0N6, 
        n_A_0N7, n_A_0N8, n_A_0N9, n_A_0N10, n_A_0N11, n_A_0N12, n_A_0N13, 
        n_A_0N14, n_A_0N15, n_A_0N16}), .B(WDB), .S(WR3LE), .Y({n_AI19, n_AI18, 
        n_AI17, n_AI16, n_AI15, n_AI14, n_AI13, n_AI12, n_AI11, n_AI10, n_AI09, 
        n_AI08, n_AI07, n_AI06, n_AI05, n_AI04}) );
  DS162 A19 ( .A({n_A_0M1, n_A_0M2, n_A_0M3, n_A_0M4, n_A_0M5, n_A_0M6, 
        n_A_0M7, n_A_0M8, n_A_0M9, n_A_0M10, n_A_0M11, n_A_0M12, n_A_0M13, 
        n_A_0M14, n_A_0M15, n_A_0M16}), .B(WADI), .S(WADBLE), .Y({n_BI15, 
        n_BI14, n_BI13, n_BI12, n_BI11, n_BI10, n_BI09, n_BI08, n_BI07, n_BI06, 
        n_BI05, n_BI04, n_BI03, n_BI02, n_BI01, n_BI00}) );
  BUFX2 A0G ( .A(XRST), .Y(n_A_0C) );
  BUFX2 A0F ( .A(TE), .Y(n_A_08) );
  FE16R A07 ( .D(WADI), .TI(n_A_0A), .RN(n_A_0C), .TE(n_A_08), .CK(MCK), .EN(
        WADBLE), .Q({n_A_0M1, n_A_0M2, n_A_0M3, n_A_0M4, n_A_0M5, n_A_0M6, 
        n_A_0M7, n_A_0M8, n_A_0M9, n_A_0M10, n_A_0M11, n_A_0M12, n_A_0M13, 
        n_A_0M14, n_A_0M15, n_A_0M16}), .TO(TO) );
  TIELO A0D3 ( .Y(n_BI19) );
  TIELO A0C3 ( .Y(n_AI03) );
  ADD20 A03 ( .A({n_AI19, n_AI18, n_AI17, n_AI16, n_AI15, n_AI14, n_AI13, 
        n_AI12, n_AI11, n_AI10, n_AI09, n_AI08, n_AI07, n_AI06, n_AI05, n_AI04, 
        n_AI03, n_AI02, n_AI01, n_AI00}), .B({n_BI19, n_BI18, n_BI17, n_BI16, 
        n_BI15, n_BI14, n_BI13, n_BI12, n_BI11, n_BI10, n_BI09, n_BI08, n_BI07, 
        n_BI06, n_BI05, n_BI04, n_BI03, n_BI02, n_BI01, n_BI00}), .S(WMADR) );
  FE16R A06 ( .D(WDB), .TI(TI), .RN(n_A_0C), .TE(n_A_08), .CK(MCK), .EN(WR3LE), 
        .Q({n_A_0N1, n_A_0N2, n_A_0N3, n_A_0N4, n_A_0N5, n_A_0N6, n_A_0N7, 
        n_A_0N8, n_A_0N9, n_A_0N10, n_A_0N11, n_A_0N12, n_A_0N13, n_A_0N14, 
        n_A_0N15, n_A_0N16}), .TO(n_A_0A) );
endmodule


module ADD20 ( A, B, S, CO );
  input [19:0] A;
  input [19:0] B;
  output [19:0] S;
  output CO;
  wire   n_A_071, n_A_072, n_A_073, n_A_074, n_A_075, n_A_076, n_A_077,
         n_A_078, n_A_079, n_A_0710, n_A_0711, n_A_0712, n_A_0713, n_A_0714,
         n_A_0715, n_A_0716, n_A_0717, n_A_0718, n_A_0719, n_A_0720, n_A_061,
         n_A_062, n_A_063, n_A_064, n_A_065, n_A_066, n_A_067, n_A_068,
         n_A_069, n_A_0610, n_A_0611, n_A_0612, n_A_0613, n_A_0614, n_A_0615,
         n_A_0616, n_A_0617, n_A_0618, n_A_0619, n_A_0620;

  CS20 A002 ( .PN({n_A_061, n_A_062, n_A_063, n_A_064, n_A_065, n_A_066, 
        n_A_067, n_A_068, n_A_069, n_A_0610, n_A_0611, n_A_0612, n_A_0613, 
        n_A_0614, n_A_0615, n_A_0616, n_A_0617, n_A_0618, n_A_0619, n_A_0620}), 
        .GN({n_A_071, n_A_072, n_A_073, n_A_074, n_A_075, n_A_076, n_A_077, 
        n_A_078, n_A_079, n_A_0710, n_A_0711, n_A_0712, n_A_0713, n_A_0714, 
        n_A_0715, n_A_0716, n_A_0717, n_A_0718, n_A_0719, n_A_0720}), .S(S), 
        .CO(CO) );
  PG20 A001 ( .A(A), .B(B), .GN({n_A_071, n_A_072, n_A_073, n_A_074, n_A_075, 
        n_A_076, n_A_077, n_A_078, n_A_079, n_A_0710, n_A_0711, n_A_0712, 
        n_A_0713, n_A_0714, n_A_0715, n_A_0716, n_A_0717, n_A_0718, n_A_0719, 
        n_A_0720}), .PN({n_A_061, n_A_062, n_A_063, n_A_064, n_A_065, n_A_066, 
        n_A_067, n_A_068, n_A_069, n_A_0610, n_A_0611, n_A_0612, n_A_0613, 
        n_A_0614, n_A_0615, n_A_0616, n_A_0617, n_A_0618, n_A_0619, n_A_0620})
         );
endmodule


module PG20 ( A, B, GN, PN );
  input [19:0] A;
  input [19:0] B;
  output [19:0] GN;
  output [19:0] PN;


  NAND2X2 A0S ( .A(A[0]), .B(B[0]), .Y(GN[0]) );
  XNOR2X2 A001 ( .A(A[0]), .B(B[0]), .Y(PN[0]) );
  NAND2X2 A01C ( .A(A[19]), .B(B[19]), .Y(GN[19]) );
  NAND2X2 A01B ( .A(A[18]), .B(B[18]), .Y(GN[18]) );
  NAND2X2 A01A ( .A(A[17]), .B(B[17]), .Y(GN[17]) );
  NAND2X2 A019 ( .A(A[16]), .B(B[16]), .Y(GN[16]) );
  NAND2X2 A018 ( .A(A[15]), .B(B[15]), .Y(GN[15]) );
  NAND2X2 A017 ( .A(A[14]), .B(B[14]), .Y(GN[14]) );
  NAND2X2 A016 ( .A(A[13]), .B(B[13]), .Y(GN[13]) );
  NAND2X2 A015 ( .A(A[12]), .B(B[12]), .Y(GN[12]) );
  NAND2X2 A014 ( .A(A[11]), .B(B[11]), .Y(GN[11]) );
  NAND2X2 A013 ( .A(A[10]), .B(B[10]), .Y(GN[10]) );
  NAND2X2 A012 ( .A(A[9]), .B(B[9]), .Y(GN[9]) );
  NAND2X2 A011 ( .A(A[8]), .B(B[8]), .Y(GN[8]) );
  NAND2X2 A010 ( .A(A[7]), .B(B[7]), .Y(GN[7]) );
  NAND2X2 A00Y ( .A(A[6]), .B(B[6]), .Y(GN[6]) );
  NAND2X2 A00X ( .A(A[5]), .B(B[5]), .Y(GN[5]) );
  NAND2X2 A00W ( .A(A[4]), .B(B[4]), .Y(GN[4]) );
  NAND2X2 A00V ( .A(A[3]), .B(B[3]), .Y(GN[3]) );
  NAND2X2 A00U ( .A(A[2]), .B(B[2]), .Y(GN[2]) );
  NAND2X2 A00T ( .A(A[1]), .B(B[1]), .Y(GN[1]) );
  XNOR2X2 A00L ( .A(A[19]), .B(B[19]), .Y(PN[19]) );
  XNOR2X2 A00K ( .A(A[18]), .B(B[18]), .Y(PN[18]) );
  XNOR2X2 A00J ( .A(A[17]), .B(B[17]), .Y(PN[17]) );
  XNOR2X2 A00H ( .A(A[16]), .B(B[16]), .Y(PN[16]) );
  XNOR2X2 A00G ( .A(A[15]), .B(B[15]), .Y(PN[15]) );
  XNOR2X2 A00F ( .A(A[14]), .B(B[14]), .Y(PN[14]) );
  XNOR2X2 A00E ( .A(A[13]), .B(B[13]), .Y(PN[13]) );
  XNOR2X2 A00D ( .A(A[12]), .B(B[12]), .Y(PN[12]) );
  XNOR2X2 A00C ( .A(A[11]), .B(B[11]), .Y(PN[11]) );
  XNOR2X2 A00B ( .A(A[10]), .B(B[10]), .Y(PN[10]) );
  XNOR2X2 A00A ( .A(A[9]), .B(B[9]), .Y(PN[9]) );
  XNOR2X2 A009 ( .A(A[8]), .B(B[8]), .Y(PN[8]) );
  XNOR2X2 A008 ( .A(A[7]), .B(B[7]), .Y(PN[7]) );
  XNOR2X2 A007 ( .A(A[6]), .B(B[6]), .Y(PN[6]) );
  XNOR2X2 A006 ( .A(A[5]), .B(B[5]), .Y(PN[5]) );
  XNOR2X2 A005 ( .A(A[4]), .B(B[4]), .Y(PN[4]) );
  XNOR2X2 A004 ( .A(A[3]), .B(B[3]), .Y(PN[3]) );
  XNOR2X2 A003 ( .A(A[2]), .B(B[2]), .Y(PN[2]) );
  XNOR2X2 A002 ( .A(A[1]), .B(B[1]), .Y(PN[1]) );
endmodule


module CS20 ( PN, GN, S, CO );
  input [19:0] PN;
  input [19:0] GN;
  output [19:0] S;
  output CO;
  wire   n_A_1D, n_A_19, n_A_21, n_A_1C, n_A_1A, n_A_1E, n_A_1G, n_A_1B,
         n_A_1F, n_A_25, n__13G7, n_A_24, n_A_1W, n_A_17, n_A_1X, n__13GN7B,
         n_A_18, n_A_16, n_A_26, n_A_22, n_A_27, n_A_23, n_A_20, n_A_1Y,
         n__14GN15, n__14G15B, n_B_21, n_B_1L, n_B_1K, n_B_1S, n_B_1J, n_B_1R,
         n_B_1V, n_B_1H, n_B_1C, n_B_1U, n_B_25, n_B_1E, n_B_26, n_B_23,
         n_B_1D, n_B_24, n_B_22, n_B_1F, n_B_2A, n_B_29, n_B_1X, n_B_1W,
         n_B_1G, n_B_1Y, n_B_20, n_B_27, n_B_28, n_B_2C, n_B_2B, n_C_13,
         n_C_0R, n_C_12, n_C_0S, n_C_11, n_C_14, n_C_0U, n_C_0V, n_C_0X,
         n_C_0W, n_C_10, n_C_0Y;

  OAI21X1 A08 ( .A0(PN[4]), .A1(n_A_1D), .B0(GN[4]), .Y(n_A_19) );
  AOI21X1 A09 ( .A0(n_A_21), .A1(n_A_1C), .B0(n_A_1E), .Y(n_A_1A) );
  AOI21X1 A0A ( .A0(n_A_1G), .A1(n_A_1C), .B0(n_A_1F), .Y(n_A_1B) );
  XOR2X2 A0D ( .A(PN[7]), .B(n_A_1B), .Y(S[7]) );
  OAI21X2 A07 ( .A0(n_A_25), .A1(n_A_1D), .B0(n_A_24), .Y(n__13G7) );
  OAI21X2 A06 ( .A0(PN[2]), .A1(n_A_1W), .B0(GN[2]), .Y(n_A_17) );
  OAI21X2 A05 ( .A0(PN[1]), .A1(GN[0]), .B0(GN[1]), .Y(n_A_1X) );
  INVX2 A0U ( .A(n__13G7), .Y(n__13GN7B) );
  INVX2 A0T ( .A(PN[0]), .Y(S[0]) );
  INVX1 A0S ( .A(n_A_1C), .Y(n_A_18) );
  INVX1 A0R ( .A(n_A_1D), .Y(n_A_1C) );
  INVX1 A0P ( .A(n_A_1W), .Y(n_A_16) );
  INVX1 A0N ( .A(n_A_1X), .Y(n_A_1W) );
  INVX1 A0M ( .A(n_A_26), .Y(n_A_22) );
  INVX1 A0L ( .A(n_A_27), .Y(n_A_23) );
  XNOR2X2 A0K ( .A(PN[2]), .B(n_A_16), .Y(S[2]) );
  XNOR2X2 A0J ( .A(PN[3]), .B(n_A_17), .Y(S[3]) );
  XNOR2X2 A0H ( .A(PN[5]), .B(n_A_19), .Y(S[5]) );
  XOR2X2 A0G ( .A(PN[1]), .B(GN[0]), .Y(S[1]) );
  XOR2X2 A0F ( .A(PN[4]), .B(n_A_18), .Y(S[4]) );
  XOR2X2 A0E ( .A(PN[6]), .B(n_A_1A), .Y(S[6]) );
  XOR2X2 A0C ( .A(PN[8]), .B(n__13GN7B), .Y(S[8]) );
  AOI21X2 A0B ( .A0(n_A_1X), .A1(n_A_20), .B0(n_A_1Y), .Y(n_A_1D) );
  CODD4 A04 ( .GHN(GN[6]), .GLN(n_A_22), .PLN(n_A_23), .PHN(PN[6]), .GO(n_A_1F), .PO(n_A_1G) );
  CODD4 A03 ( .GHN(GN[3]), .GLN(GN[2]), .PLN(PN[2]), .PHN(PN[3]), .GO(n_A_1Y), 
        .PO(n_A_20) );
  CODD4 A02 ( .GHN(GN[5]), .GLN(GN[4]), .PLN(PN[4]), .PHN(PN[5]), .GO(n_A_1E), 
        .PO(n_A_21) );
  ODD8 A01 ( .G2N(GN[5]), .G1N(GN[4]), .G4N(GN[7]), .G3N(GN[6]), .P1N(PN[4]), 
        .P2N(PN[5]), .P3N(PN[6]), .P4N(PN[7]), .YG2(n_A_26), .YG4N(n_A_24), 
        .YP2(n_A_27), .YP4N(n_A_25) );
  INVX2 B26 ( .A(n__14GN15), .Y(n__14G15B) );
  INVX1 B1M ( .A(GN[12]), .Y(n_B_21) );
  INVX1 B0V ( .A(PN[9]), .Y(n_B_1L) );
  OAI21X1 B0P ( .A0(n__13GN7B), .A1(PN[8]), .B0(GN[8]), .Y(n_B_1K) );
  AOI21X1 B0L ( .A0(n_B_1S), .A1(n__13G7), .B0(n_B_1R), .Y(n_B_1J) );
  AOI21X1 B0N ( .A0(n_B_1V), .A1(n__13G7), .B0(n_B_1C), .Y(n_B_1H) );
  AOI21X1 B0R ( .A0(n_B_1U), .A1(n_B_25), .B0(n_B_26), .Y(n_B_1E) );
  AOI21X1 B0S ( .A0(n_B_23), .A1(n_B_1U), .B0(n_B_24), .Y(n_B_1D) );
  OAI22X1 B0U ( .A0(n_B_22), .A1(n_B_21), .B0(n_B_21), .B1(n_B_1U), .Y(n_B_1F)
         );
  AOI21X2 B0T ( .A0(n_B_2A), .A1(n__13G7), .B0(n_B_29), .Y(n__14GN15) );
  OAI21X2 B0M ( .A0(n__13GN7B), .A1(n_B_1X), .B0(n_B_1W), .Y(n_B_1U) );
  XNOR2X2 B0K ( .A(PN[16]), .B(n__14G15B), .Y(S[16]) );
  XOR2X2 B0J ( .A(PN[15]), .B(n_B_1D), .Y(S[15]) );
  XOR2X2 B0H ( .A(PN[14]), .B(n_B_1E), .Y(S[14]) );
  XOR2X2 B0G ( .A(PN[13]), .B(n_B_1F), .Y(S[13]) );
  XOR2X2 B0F ( .A(PN[12]), .B(n_B_1G), .Y(S[12]) );
  XOR2X2 B0E ( .A(PN[11]), .B(n_B_1H), .Y(S[11]) );
  XOR2X2 B0D ( .A(PN[10]), .B(n_B_1J), .Y(S[10]) );
  XOR2X2 B0C ( .A(n_B_1L), .B(n_B_1K), .Y(S[9]) );
  INVX1 B0B ( .A(n_B_1U), .Y(n_B_1G) );
  INVX1 B0A ( .A(n_B_1R), .Y(n_B_1Y) );
  INVX1 B09 ( .A(n_B_1S), .Y(n_B_20) );
  INVX1 B08 ( .A(PN[12]), .Y(n_B_22) );
  INVX1 B07 ( .A(n_B_26), .Y(n_B_27) );
  INVX1 B06 ( .A(n_B_25), .Y(n_B_28) );
  CODD4 B05 ( .GHN(n_B_2B), .GLN(n_B_1W), .PLN(n_B_1X), .PHN(n_B_2C), .GO(
        n_B_29), .PO(n_B_2A) );
  CODD4 B04 ( .GHN(GN[14]), .GLN(n_B_27), .PLN(n_B_28), .PHN(PN[14]), .GO(
        n_B_24), .PO(n_B_23) );
  CODD4 B03 ( .GHN(GN[10]), .GLN(n_B_1Y), .PLN(n_B_20), .PHN(PN[10]), .GO(
        n_B_1C), .PO(n_B_1V) );
  ODD8 B02 ( .G2N(GN[9]), .G1N(GN[8]), .G4N(GN[11]), .G3N(GN[10]), .P1N(PN[8]), 
        .P2N(PN[9]), .P3N(PN[10]), .P4N(PN[11]), .YG2(n_B_1R), .YG4N(n_B_1W), 
        .YP2(n_B_1S), .YP4N(n_B_1X) );
  ODD8 B01 ( .G2N(GN[13]), .G1N(GN[12]), .G4N(GN[15]), .G3N(GN[14]), .P1N(
        PN[12]), .P2N(PN[13]), .P3N(PN[14]), .P4N(PN[15]), .YG2(n_B_26), 
        .YG4N(n_B_2B), .YP2(n_B_25), .YP4N(n_B_2C) );
  INVX1 C0C ( .A(PN[17]), .Y(n_C_13) );
  INVX1 C0B ( .A(n_C_0R), .Y(n_C_12) );
  INVX1 C0A ( .A(n_C_0S), .Y(n_C_11) );
  XOR2X2 C09 ( .A(n_C_13), .B(n_C_14), .Y(S[17]) );
  XOR2X2 C08 ( .A(PN[18]), .B(n_C_0U), .Y(S[18]) );
  XOR2X2 C07 ( .A(PN[19]), .B(n_C_0V), .Y(S[19]) );
  AOI21X1 C06 ( .A0(n_C_0S), .A1(n__14G15B), .B0(n_C_0R), .Y(n_C_0U) );
  AOI21X1 C05 ( .A0(n_C_0X), .A1(n__14G15B), .B0(n_C_0W), .Y(n_C_0V) );
  CODD4 C04 ( .GHN(GN[18]), .GLN(n_C_12), .PLN(n_C_11), .PHN(PN[18]), .GO(
        n_C_0W), .PO(n_C_0X) );
  OAI21X2 C03 ( .A0(n_C_10), .A1(n__14GN15), .B0(n_C_0Y), .Y(CO) );
  OAI21X1 C02 ( .A0(PN[16]), .A1(n__14GN15), .B0(GN[16]), .Y(n_C_14) );
  ODD8 C01 ( .G2N(GN[17]), .G1N(GN[16]), .G4N(GN[19]), .G3N(GN[18]), .P1N(
        PN[16]), .P2N(PN[17]), .P3N(PN[18]), .P4N(PN[19]), .YG2(n_C_0R), 
        .YG4N(n_C_0Y), .YP2(n_C_0S), .YP4N(n_C_10) );
endmodule


module WIMCNT ( WDB, PMD, WIMEA, PMA, WIMWE, ENP, WWREQ, WSCST, WPWEN, WIMA, 
        WIMI, XWIMWE, WWRDY );
  input [15:0] WDB;
  input [15:0] PMD;
  input [8:0] WIMEA;
  input [8:0] PMA;
  output [8:0] WIMA;
  output [15:0] WIMI;
  input WIMWE, ENP, WWREQ, WSCST, WPWEN;
  output XWIMWE, WWRDY;
  wire   n_A_0D, n_A_07, n_A_0J, n_A_0N, n_A_0C, n_A_0B, n_A_06, n_A_0P;

  BUFX2 A0F ( .A(n_A_0D), .Y(WWRDY) );
  AND2X1 A0B ( .A(n_A_07), .B(n_A_0J), .Y(n_A_0D) );
  NOR2X2 A0X ( .A(n_A_0D), .B(WIMWE), .Y(XWIMWE) );
  INVX1 A0H ( .A(n_A_0N), .Y(n_A_0C) );
  OR2X1 A0J ( .A(n_A_0C), .B(ENP), .Y(n_A_0J) );
  NAND2X1 A05 ( .A(n_A_0B), .B(n_A_0N), .Y(n_A_06) );
  OAI22X1 A04 ( .A0(n_A_0B), .A1(n_A_0P), .B0(n_A_0N), .B1(n_A_0P), .Y(n_A_07)
         );
  DS092 A02 ( .A(WIMEA), .B(PMA), .S(n_A_06), .Y(WIMA) );
  BUFX2 A0E ( .A(WSCST), .Y(n_A_0N) );
  INVX1 A0A ( .A(WWREQ), .Y(n_A_0P) );
  NAND2X1 A06 ( .A(WPWEN), .B(n_A_0N), .Y(n_A_0B) );
  DS162 A01 ( .A(WDB), .B(PMD), .S(n_A_06), .Y(WIMI) );
endmodule


module DS092 ( A, B, S, Y );
  input [8:0] A;
  input [8:0] B;
  output [8:0] Y;
  input S;
  wire   n_A_05;

  MX2X1 A000 ( .S0(n_A_05), .B(B[0]), .A(A[0]), .Y(Y[0]) );
  MX2X1 A001 ( .S0(n_A_05), .B(B[1]), .A(A[1]), .Y(Y[1]) );
  MX2X1 A002 ( .S0(n_A_05), .B(B[2]), .A(A[2]), .Y(Y[2]) );
  MX2X1 A003 ( .S0(n_A_05), .B(B[3]), .A(A[3]), .Y(Y[3]) );
  MX2X1 A004 ( .S0(n_A_05), .B(B[4]), .A(A[4]), .Y(Y[4]) );
  MX2X1 A005 ( .S0(n_A_05), .B(B[5]), .A(A[5]), .Y(Y[5]) );
  MX2X1 A006 ( .S0(n_A_05), .B(B[6]), .A(A[6]), .Y(Y[6]) );
  MX2X1 A007 ( .S0(n_A_05), .B(B[7]), .A(A[7]), .Y(Y[7]) );
  BUFX2 A03 ( .A(S), .Y(n_A_05) );
  MX2X1 A008 ( .S0(n_A_05), .B(B[8]), .A(A[8]), .Y(Y[8]) );
endmodule


module WDBMX ( WR1O, WSO, WIMO, WIMOEN, WSOEN, WR1OEN, WDB );
  input [6:0] WR1O;
  input [15:0] WSO;
  input [15:0] WIMO;
  output [15:0] WDB;
  input WIMOEN, WSOEN, WR1OEN;
  wire   n_A_0A, n_A_0E16, n_A_0E15, n_A_0E14, n_A_0E13, n_A_0E12, n_A_0E11,
         n_A_0E10, n_A_0E9, n_A_0E8, n_A_0E7, n_A_0E6, n_A_0E5, n_A_0E4,
         n_A_0E3, n_A_0E2, n_A_08, n_A_0F16, n_A_0F15, n_A_0F14, n_A_0F13,
         n_A_0F12, n_A_0F11, n_A_0F10, n_A_0F9, n_A_0F8, n_A_0F7, n_A_0F6,
         n_A_0F5, n_A_0F4, n_A_0F3, n_A_0F2, n_A_0J, n_A_0G16, n_A_0G15,
         n_A_0G14, n_A_0G13, n_A_0G12, n_A_0G11, n_A_0G10, n_WR1O07, n_A_0G9,
         n_WR1O08, n_A_0G8, n_WR1O09, n_A_0G7, n_WR1O10, n_A_0G6, n_WR1O11,
         n_A_0G5, n_WR1O12, n_A_0G4, n_WR1O13, n_A_0G3, n_WR1O14, n_A_0G2,
         n_WR1O15, n_A_0G1, n_A_0F1, n_A_0E1;

  NAND2X1 A200 ( .A(WIMO[0]), .B(n_A_0A), .Y(n_A_0E16) );
  NAND2X1 A201 ( .A(WIMO[1]), .B(n_A_0A), .Y(n_A_0E15) );
  NAND2X1 A202 ( .A(WIMO[2]), .B(n_A_0A), .Y(n_A_0E14) );
  NAND2X1 A203 ( .A(WIMO[3]), .B(n_A_0A), .Y(n_A_0E13) );
  NAND2X1 A204 ( .A(WIMO[4]), .B(n_A_0A), .Y(n_A_0E12) );
  NAND2X1 A205 ( .A(WIMO[5]), .B(n_A_0A), .Y(n_A_0E11) );
  NAND2X1 A206 ( .A(WIMO[6]), .B(n_A_0A), .Y(n_A_0E10) );
  NAND2X1 A207 ( .A(WIMO[7]), .B(n_A_0A), .Y(n_A_0E9) );
  NAND2X1 A208 ( .A(WIMO[8]), .B(n_A_0A), .Y(n_A_0E8) );
  NAND2X1 A209 ( .A(WIMO[9]), .B(n_A_0A), .Y(n_A_0E7) );
  NAND2X1 A210 ( .A(WIMO[10]), .B(n_A_0A), .Y(n_A_0E6) );
  NAND2X1 A211 ( .A(WIMO[11]), .B(n_A_0A), .Y(n_A_0E5) );
  NAND2X1 A212 ( .A(WIMO[12]), .B(n_A_0A), .Y(n_A_0E4) );
  NAND2X1 A213 ( .A(WIMO[13]), .B(n_A_0A), .Y(n_A_0E3) );
  NAND2X1 A214 ( .A(WIMO[14]), .B(n_A_0A), .Y(n_A_0E2) );
  NAND2X1 A300 ( .A(WSO[0]), .B(n_A_08), .Y(n_A_0F16) );
  NAND2X1 A301 ( .A(WSO[1]), .B(n_A_08), .Y(n_A_0F15) );
  NAND2X1 A302 ( .A(WSO[2]), .B(n_A_08), .Y(n_A_0F14) );
  NAND2X1 A303 ( .A(WSO[3]), .B(n_A_08), .Y(n_A_0F13) );
  NAND2X1 A304 ( .A(WSO[4]), .B(n_A_08), .Y(n_A_0F12) );
  NAND2X1 A305 ( .A(WSO[5]), .B(n_A_08), .Y(n_A_0F11) );
  NAND2X1 A306 ( .A(WSO[6]), .B(n_A_08), .Y(n_A_0F10) );
  NAND2X1 A307 ( .A(WSO[7]), .B(n_A_08), .Y(n_A_0F9) );
  NAND2X1 A308 ( .A(WSO[8]), .B(n_A_08), .Y(n_A_0F8) );
  NAND2X1 A309 ( .A(WSO[9]), .B(n_A_08), .Y(n_A_0F7) );
  NAND2X1 A310 ( .A(WSO[10]), .B(n_A_08), .Y(n_A_0F6) );
  NAND2X1 A311 ( .A(WSO[11]), .B(n_A_08), .Y(n_A_0F5) );
  NAND2X1 A312 ( .A(WSO[12]), .B(n_A_08), .Y(n_A_0F4) );
  NAND2X1 A313 ( .A(WSO[13]), .B(n_A_08), .Y(n_A_0F3) );
  NAND2X1 A314 ( .A(WSO[14]), .B(n_A_08), .Y(n_A_0F2) );
  NAND2X1 A400 ( .A(WR1O[0]), .B(n_A_0J), .Y(n_A_0G16) );
  NAND2X1 A401 ( .A(WR1O[1]), .B(n_A_0J), .Y(n_A_0G15) );
  NAND2X1 A402 ( .A(WR1O[2]), .B(n_A_0J), .Y(n_A_0G14) );
  NAND2X1 A403 ( .A(WR1O[3]), .B(n_A_0J), .Y(n_A_0G13) );
  NAND2X1 A404 ( .A(WR1O[4]), .B(n_A_0J), .Y(n_A_0G12) );
  NAND2X1 A405 ( .A(WR1O[5]), .B(n_A_0J), .Y(n_A_0G11) );
  NAND2X1 A406 ( .A(WR1O[6]), .B(n_A_0J), .Y(n_A_0G10) );
  NAND2X1 A407 ( .A(n_WR1O07), .B(n_A_0J), .Y(n_A_0G9) );
  NAND2X1 A408 ( .A(n_WR1O08), .B(n_A_0J), .Y(n_A_0G8) );
  NAND2X1 A409 ( .A(n_WR1O09), .B(n_A_0J), .Y(n_A_0G7) );
  NAND2X1 A410 ( .A(n_WR1O10), .B(n_A_0J), .Y(n_A_0G6) );
  NAND2X1 A411 ( .A(n_WR1O11), .B(n_A_0J), .Y(n_A_0G5) );
  NAND2X1 A412 ( .A(n_WR1O12), .B(n_A_0J), .Y(n_A_0G4) );
  NAND2X1 A413 ( .A(n_WR1O13), .B(n_A_0J), .Y(n_A_0G3) );
  NAND2X1 A414 ( .A(n_WR1O14), .B(n_A_0J), .Y(n_A_0G2) );
  NAND3X2 A100 ( .A(n_A_0G16), .B(n_A_0F16), .C(n_A_0E16), .Y(WDB[0]) );
  NAND3X2 A101 ( .A(n_A_0G15), .B(n_A_0F15), .C(n_A_0E15), .Y(WDB[1]) );
  NAND3X2 A102 ( .A(n_A_0G14), .B(n_A_0F14), .C(n_A_0E14), .Y(WDB[2]) );
  NAND3X2 A103 ( .A(n_A_0G13), .B(n_A_0F13), .C(n_A_0E13), .Y(WDB[3]) );
  NAND3X2 A104 ( .A(n_A_0G12), .B(n_A_0F12), .C(n_A_0E12), .Y(WDB[4]) );
  NAND3X2 A105 ( .A(n_A_0G11), .B(n_A_0F11), .C(n_A_0E11), .Y(WDB[5]) );
  NAND3X2 A106 ( .A(n_A_0G10), .B(n_A_0F10), .C(n_A_0E10), .Y(WDB[6]) );
  NAND3X2 A107 ( .A(n_A_0G9), .B(n_A_0F9), .C(n_A_0E9), .Y(WDB[7]) );
  NAND3X2 A108 ( .A(n_A_0G8), .B(n_A_0F8), .C(n_A_0E8), .Y(WDB[8]) );
  NAND3X2 A109 ( .A(n_A_0G7), .B(n_A_0F7), .C(n_A_0E7), .Y(WDB[9]) );
  NAND3X2 A110 ( .A(n_A_0G6), .B(n_A_0F6), .C(n_A_0E6), .Y(WDB[10]) );
  NAND3X2 A111 ( .A(n_A_0G5), .B(n_A_0F5), .C(n_A_0E5), .Y(WDB[11]) );
  NAND3X2 A112 ( .A(n_A_0G4), .B(n_A_0F4), .C(n_A_0E4), .Y(WDB[12]) );
  NAND3X2 A113 ( .A(n_A_0G3), .B(n_A_0F3), .C(n_A_0E3), .Y(WDB[13]) );
  NAND3X2 A114 ( .A(n_A_0G2), .B(n_A_0F2), .C(n_A_0E2), .Y(WDB[14]) );
  TIELO A800 ( .Y(n_WR1O07) );
  TIELO A801 ( .Y(n_WR1O08) );
  TIELO A802 ( .Y(n_WR1O09) );
  TIELO A803 ( .Y(n_WR1O10) );
  TIELO A804 ( .Y(n_WR1O11) );
  TIELO A805 ( .Y(n_WR1O12) );
  TIELO A806 ( .Y(n_WR1O13) );
  TIELO A807 ( .Y(n_WR1O14) );
  TIELO A808 ( .Y(n_WR1O15) );
  BUFX4 A07 ( .A(WR1OEN), .Y(n_A_0J) );
  BUFX4 A06 ( .A(WSOEN), .Y(n_A_08) );
  BUFX4 A05 ( .A(WIMOEN), .Y(n_A_0A) );
  NAND3X2 A115 ( .A(n_A_0G1), .B(n_A_0F1), .C(n_A_0E1), .Y(WDB[15]) );
  NAND2X1 A415 ( .A(n_WR1O15), .B(n_A_0J), .Y(n_A_0G1) );
  NAND2X1 A315 ( .A(WSO[15]), .B(n_A_08), .Y(n_A_0F1) );
  NAND2X1 A215 ( .A(WIMO[15]), .B(n_A_0A), .Y(n_A_0E1) );
endmodule


module WEMIF ( WEMAR, WEMAH, GPD, GPA, MCK, WMDRE, WMDWE, WEMLE, XRST, ENP, TE, 
        WSCST, TI, WEMA, WEMDI, TO, WEMRE, XWEMOC, XWEMWE );
  input [19:0] WEMAR;
  input [3:0] WEMAH;
  input [15:0] GPD;
  input [3:0] GPA;
  output [23:0] WEMA;
  output [7:0] WEMDI;
  input MCK, WMDRE, WMDWE, WEMLE, XRST, ENP, TE, WSCST, TI;
  output TO, WEMRE, XWEMOC, XWEMWE;
  wire   n_A_0V, n_LPD19, n_LPD18, n_LPD17, n_LPD16, n_LPD15, n_LPD14, n_LPD13,
         n_LPD12, n_LPD11, n_LPD10, n_LPD09, n_LPD08, n_LPD07, n_LPD06,
         n_LPD05, n_LPD04, n_LPD03, n_LPD02, n_LPD01, n_LPD00, n_A_1G1,
         n_A_1G2, n_A_1G3, n_A_1G4, n_A_1G5, n_A_1G6, n_A_1G7, n_A_1G8,
         n_A_1G9, n_A_1G10, n_A_1G11, n_A_1G12, n_A_1G13, n_A_1G14, n_A_1G15,
         n_A_1G16, n_A_1G17, n_A_1G18, n_A_1G19, n_A_1G20, n_A_1V, n_A_0P,
         n_A_0C, n_A_0F, n_A_0S, n_A_1A, n_A_0H, n_A_1U, n_A_10, n_A_1T,
         n_A_1C, n_A_1R, n_A_1S, n_A_1F, n_A_1E1, n_A_1E2, n_A_1E3, n_A_1E4,
         n_A_1E5, n_A_1E6, n_A_1E7, n_A_1E8, n_A_0G, n_A_18, n_A_0D, n_LPD23,
         n_LPD22, n_LPD21, n_LPD20, n_A_1N1, n_A_1N2, n_A_1N3, n_A_1N4, n_A_07
;

  DS202 A04 ( .A(WEMAR), .B({n_LPD19, n_LPD18, n_LPD17, n_LPD16, n_LPD15, 
        n_LPD14, n_LPD13, n_LPD12, n_LPD11, n_LPD10, n_LPD09, n_LPD08, n_LPD07, 
        n_LPD06, n_LPD05, n_LPD04, n_LPD03, n_LPD02, n_LPD01, n_LPD00}), .S(
        n_A_0V), .Y({n_A_1G1, n_A_1G2, n_A_1G3, n_A_1G4, n_A_1G5, n_A_1G6, 
        n_A_1G7, n_A_1G8, n_A_1G9, n_A_1G10, n_A_1G11, n_A_1G12, n_A_1G13, 
        n_A_1G14, n_A_1G15, n_A_1G16, n_A_1G17, n_A_1G18, n_A_1G19, n_A_1G20})
         );
  PW42 A15 ( .RN(n_A_0S), .TE(n_A_0P), .TI(TI), .SS(n_A_1V), .CK(MCK), .EN8(
        n_A_0H), .EN(ENP), .TO(n_A_0F), .P2(n_A_0C), .P4(n_A_1A) );
  INVX4 A1M ( .A(n_A_1A), .Y(XWEMOC) );
  BUFX2 A0T ( .A(WEMLE), .Y(n_A_0H) );
  INVX1 A23 ( .A(WSCST), .Y(n_A_0V) );
  WPDEC A1P ( .A(GPA), .Y3(n_A_1T), .Y2(n_A_10), .Y1(n_A_1U) );
  AND2X1 A1U ( .A(WMDRE), .B(n_A_1T), .Y(WEMRE) );
  BUFX2 A1S ( .A(WMDWE), .Y(n_A_1C) );
  AND2X1 A0W ( .A(n_A_1C), .B(n_A_1T), .Y(n_A_1V) );
  AND2X1 A1F ( .A(n_A_1C), .B(n_A_10), .Y(n_A_1R) );
  AND2X1 A0Y ( .A(n_A_1C), .B(n_A_1U), .Y(n_A_1S) );
  BUFX2 A0V ( .A(XRST), .Y(n_A_0S) );
  BUFX2 A0U ( .A(TE), .Y(n_A_0P) );
  INVX2 A0S ( .A(n_A_0C), .Y(XWEMWE) );
  FE08R A08 ( .D({n_A_1E1, n_A_1E2, n_A_1E3, n_A_1E4, n_A_1E5, n_A_1E6, 
        n_A_1E7, n_A_1E8}), .TI(n_A_1F), .EN(n_A_0H), .CK(MCK), .TE(n_A_0P), 
        .RN(n_A_0S), .Q(WEMDI), .TO(TO) );
  FE08R A07 ( .D(GPD[7:0]), .TI(n_A_0F), .EN(n_A_1V), .CK(MCK), .TE(n_A_0P), 
        .RN(n_A_0S), .Q({n_A_1E1, n_A_1E2, n_A_1E3, n_A_1E4, n_A_1E5, n_A_1E6, 
        n_A_1E7, n_A_1E8}), .TO(n_A_0G) );
  FE08R A06 ( .D(GPD[7:0]), .TI(n_A_18), .EN(n_A_1S), .CK(MCK), .TE(n_A_0P), 
        .RN(n_A_0S), .Q({n_LPD23, n_LPD22, n_LPD21, n_LPD20, n_LPD19, n_LPD18, 
        n_LPD17, n_LPD16}), .TO(n_A_0D) );
  FE16R A05 ( .D(GPD), .TI(n_A_0G), .RN(n_A_0S), .TE(n_A_0P), .CK(MCK), .EN(
        n_A_1R), .Q({n_LPD15, n_LPD14, n_LPD13, n_LPD12, n_LPD11, n_LPD10, 
        n_LPD09, n_LPD08, n_LPD07, n_LPD06, n_LPD05, n_LPD04, n_LPD03, n_LPD02, 
        n_LPD01, n_LPD00}), .TO(n_A_18) );
  DS042 A03 ( .A(WEMAH), .B({n_LPD23, n_LPD22, n_LPD21, n_LPD20}), .S(n_A_0V), 
        .Y({n_A_1N1, n_A_1N2, n_A_1N3, n_A_1N4}) );
  FE20R A02 ( .D({n_A_1G1, n_A_1G2, n_A_1G3, n_A_1G4, n_A_1G5, n_A_1G6, 
        n_A_1G7, n_A_1G8, n_A_1G9, n_A_1G10, n_A_1G11, n_A_1G12, n_A_1G13, 
        n_A_1G14, n_A_1G15, n_A_1G16, n_A_1G17, n_A_1G18, n_A_1G19, n_A_1G20}), 
        .TI(n_A_07), .RN(n_A_0S), .TE(n_A_0P), .CK(MCK), .EN(n_A_0H), .Q(
        WEMA[19:0]), .TO(n_A_1F) );
  FE04R A01 ( .D({n_A_1N1, n_A_1N2, n_A_1N3, n_A_1N4}), .CK(MCK), .RN(n_A_0S), 
        .TE(n_A_0P), .EN(n_A_0H), .TI(n_A_0D), .Q(WEMA[23:20]), .TO(n_A_07) );
endmodule


module DS042 ( A, B, S, Y );
  input [3:0] A;
  input [3:0] B;
  output [3:0] Y;
  input S;
  wire   n_A_06;

  MX2X1 A10 ( .S0(n_A_06), .B(B[0]), .A(A[0]), .Y(Y[0]) );
  MX2X1 A11 ( .S0(n_A_06), .B(B[1]), .A(A[1]), .Y(Y[1]) );
  MX2X1 A12 ( .S0(n_A_06), .B(B[2]), .A(A[2]), .Y(Y[2]) );
  BUFX2 A02 ( .A(S), .Y(n_A_06) );
  MX2X1 A13 ( .S0(n_A_06), .B(B[3]), .A(A[3]), .Y(Y[3]) );
endmodule


module WPDEC ( A, Y3, Y2, Y1 );
  input [3:0] A;
  output Y3, Y2, Y1;
  wire   n_A_0L, n_A_0J;

  INVX1 A07 ( .A(A[1]), .Y(n_A_0L) );
  INVX1 A05 ( .A(A[0]), .Y(n_A_0J) );
  NOR4X1 A03 ( .A(A[0]), .B(n_A_0L), .C(A[2]), .D(A[3]), .Y(Y3) );
  NOR4X1 A02 ( .A(n_A_0J), .B(A[1]), .C(A[2]), .D(A[3]), .Y(Y2) );
  NOR4X1 A01 ( .A(A[0]), .B(A[1]), .C(A[2]), .D(A[3]), .Y(Y1) );
endmodule


module PW42 ( RN, TE, TI, SS, CK, EN8, EN, TO, P2, P4 );
  input RN, TE, TI, SS, CK, EN8, EN;
  output TO, P2, P4;
  wire   n_A_02, n_A_03, n_A_0B, n_A_09, n_A_06, n_A_0E, n_A_0G, n_A_0K,
         n_A_0H, n_A_0C, n_A_0P, n_A_0S;

  BUFX2 A0F ( .A(RN), .Y(n_A_02) );
  BUFX2 A0E ( .A(TE), .Y(n_A_03) );
  BUFX2 A0D ( .A(P2), .Y(TO) );
  TIEHI A0C ( .Y(n_A_0B) );
  BUFX2 A0B ( .A(EN), .Y(n_A_09) );
  INVX1 A09 ( .A(n_A_06), .Y(n_A_0E) );
  AND2X1 A04 ( .A(P4), .B(n_A_0E), .Y(n_A_0G) );
  FE1R A06 ( .RN(n_A_02), .TE(n_A_03), .TI(n_A_06), .CK(CK), .EN(n_A_09), .D(
        n_A_0G), .Q(P2) );
  AND3X1 A05 ( .A(n_A_09), .B(n_A_0K), .C(n_A_06), .Y(n_A_0H) );
  AND2X1 A08 ( .A(EN8), .B(n_A_0C), .Y(n_A_0P) );
  FS1R A07 ( .EN(n_A_09), .RN(n_A_02), .TE(n_A_03), .TI(n_A_0C), .CK(CK), .SR(
        n_A_0H), .SS(n_A_0P), .Q(P4) );
  AND2X1 A03 ( .A(n_A_09), .B(P4), .Y(n_A_0S) );
  CO02 A02 ( .RN(n_A_02), .TE(n_A_03), .TI(P4), .CK(CK), .SCL(n_A_0H), .EN(
        n_A_0S), .Q1(n_A_06), .Q0(n_A_0K) );
  FS1R A01 ( .EN(n_A_0B), .RN(n_A_02), .TE(n_A_03), .TI(TI), .CK(CK), .SR(
        n_A_0H), .SS(SS), .Q(n_A_0C) );
endmodule


module CO02 ( RN, TE, TI, CK, SCL, EN, Q1, Q0 );
  input RN, TE, TI, CK, SCL, EN;
  output Q1, Q0;
  wire   n_A_0H, n_A_0G, n_A_0A, n_A_0J, n_A_0D, n_A_0C, n_A_09;

  BUFX2 A0C ( .A(RN), .Y(n_A_0H) );
  BUFX2 A0B ( .A(TE), .Y(n_A_0G) );
  COU1 A02 ( .RN(n_A_0H), .TE(n_A_0G), .TI(Q0), .CK(CK), .SCL(n_A_0J), .EN(
        n_A_0A), .Q(Q1) );
  COU1 A01 ( .RN(n_A_0H), .TE(n_A_0G), .TI(TI), .CK(CK), .SCL(n_A_0J), .EN(
        n_A_0D), .QN(n_A_0C), .Q(Q0) );
  BUFX2 A0A ( .A(SCL), .Y(n_A_0J) );
  BUFX2 A07 ( .A(EN), .Y(n_A_0D) );
  NOR2X1 A05 ( .A(n_A_09), .B(n_A_0C), .Y(n_A_0A) );
  INVX1 A04 ( .A(n_A_0D), .Y(n_A_09) );
endmodule


module FS1R ( EN, RN, TE, TI, CK, SR, SS, Q );
  input EN, RN, TE, TI, CK, SR, SS;
  output Q;
  wire   n_A_05, n_A_0C, n_A_08, n_A_09;

  MX2X1 A0C ( .S0(EN), .B(n_A_05), .A(Q), .Y(n_A_0C) );
  INVX1 A04 ( .A(SR), .Y(n_A_08) );
  AND2X1 A03 ( .A(n_A_09), .B(n_A_08), .Y(n_A_05) );
  OR2X1 A02 ( .A(Q), .B(SS), .Y(n_A_09) );
  DFFRHQX2 A01 ( .D(n_A_0C), .CK(CK), .RN(RN), .Q(Q) );
endmodule


module DS202 ( A, B, S, Y );
  input [19:0] A;
  input [19:0] B;
  output [19:0] Y;
  input S;
  wire   n_A_06;

  MX2X2 A100 ( .S0(n_A_06), .B(B[0]), .A(A[0]), .Y(Y[0]) );
  MX2X2 A101 ( .S0(n_A_06), .B(B[1]), .A(A[1]), .Y(Y[1]) );
  MX2X2 A102 ( .S0(n_A_06), .B(B[2]), .A(A[2]), .Y(Y[2]) );
  MX2X2 A103 ( .S0(n_A_06), .B(B[3]), .A(A[3]), .Y(Y[3]) );
  MX2X2 A104 ( .S0(n_A_06), .B(B[4]), .A(A[4]), .Y(Y[4]) );
  MX2X2 A105 ( .S0(n_A_06), .B(B[5]), .A(A[5]), .Y(Y[5]) );
  MX2X2 A106 ( .S0(n_A_06), .B(B[6]), .A(A[6]), .Y(Y[6]) );
  MX2X2 A107 ( .S0(n_A_06), .B(B[7]), .A(A[7]), .Y(Y[7]) );
  MX2X2 A108 ( .S0(n_A_06), .B(B[8]), .A(A[8]), .Y(Y[8]) );
  MX2X2 A109 ( .S0(n_A_06), .B(B[9]), .A(A[9]), .Y(Y[9]) );
  MX2X2 A110 ( .S0(n_A_06), .B(B[10]), .A(A[10]), .Y(Y[10]) );
  MX2X2 A111 ( .S0(n_A_06), .B(B[11]), .A(A[11]), .Y(Y[11]) );
  MX2X2 A112 ( .S0(n_A_06), .B(B[12]), .A(A[12]), .Y(Y[12]) );
  MX2X2 A113 ( .S0(n_A_06), .B(B[13]), .A(A[13]), .Y(Y[13]) );
  MX2X2 A114 ( .S0(n_A_06), .B(B[14]), .A(A[14]), .Y(Y[14]) );
  MX2X2 A115 ( .S0(n_A_06), .B(B[15]), .A(A[15]), .Y(Y[15]) );
  MX2X2 A116 ( .S0(n_A_06), .B(B[16]), .A(A[16]), .Y(Y[16]) );
  MX2X2 A117 ( .S0(n_A_06), .B(B[17]), .A(A[17]), .Y(Y[17]) );
  MX2X2 A118 ( .S0(n_A_06), .B(B[18]), .A(A[18]), .Y(Y[18]) );
  BUFX4 A003 ( .A(S), .Y(n_A_06) );
  MX2X2 A119 ( .S0(n_A_06), .B(B[19]), .A(A[19]), .Y(Y[19]) );
endmodule


module WMOPU ( WDB, RLD, RPD, PACH, PITL, PITLEN, MSBLE, WABINC, TE, XRST, 
        WMADS, WRPEN, WR0EN, WAIVCT, TI, WRLEN, WABLE, WCRLE, MCK, WSO, WADI, 
        CARRY, WSMSB, TO );
  input [15:0] WDB;
  input [2:0] RLD;
  input [15:0] RPD;
  input [15:0] PACH;
  input [15:0] PITL;
  output [15:0] WSO;
  output [15:0] WADI;
  input PITLEN, MSBLE, WABINC, TE, XRST, WMADS, WRPEN, WR0EN, WAIVCT, TI,
         WRLEN, WABLE, WCRLE, MCK;
  output CARRY, WSMSB, TO;
  wire   n_RLD03, n_RLD04, n_RLD05, n_RLD06, n_RLD07, n_RLD08, n_RLD09,
         n_RLD10, n_RLD11, n_RLD12, n_RLD13, n_RLD14, n_RLD15, n_A_161,
         n_A_162, n_A_163, n_A_164, n_A_165, n_A_166, n_A_167, n_A_168,
         n_A_169, n_A_1610, n_A_1611, n_A_1612, n_A_1613, n_A_1614, n_A_1615,
         n_A_1616, n_A_1C, n_A_1B, n_A_08, n_A_0R, n_A_10, n_A_0F, n_A_13,
         n_A_0U, n_A_12, n_A_09, n_A_0W, n_A_0S, n_A_0X1, n_A_0X2, n_A_0X3,
         n_A_0X4, n_A_0X5, n_A_0X6, n_A_0X7, n_A_0X8, n_A_0X9, n_A_0X10,
         n_A_0X11, n_A_0X12, n_A_0X13, n_A_0X14, n_A_0X15, n_A_0X16, n_A_0T1,
         n_A_0T2, n_A_0T3, n_A_0T4, n_A_0T5, n_A_0T6, n_A_0T7, n_A_0T8,
         n_A_0T9, n_A_0T10, n_A_0T11, n_A_0T12, n_A_0T13, n_A_0T14, n_A_0T15,
         n_A_0T16, n_A_11, n_A_171, n_A_172, n_A_173, n_A_174, n_A_175,
         n_A_176, n_A_177, n_A_178, n_A_179, n_A_1710, n_A_1711, n_A_1712,
         n_A_1713, n_A_1714, n_A_1715, n_A_1716, n_A_181, n_A_182, n_A_183,
         n_A_184, n_A_185, n_A_186, n_A_187, n_A_188, n_A_189, n_A_1810,
         n_A_1811, n_A_1812, n_A_1813, n_A_1814, n_A_1815, n_A_1816;

  TIELO A000 ( .Y(n_RLD03) );
  TIELO A001 ( .Y(n_RLD04) );
  TIELO A002 ( .Y(n_RLD05) );
  TIELO A003 ( .Y(n_RLD06) );
  TIELO A004 ( .Y(n_RLD07) );
  TIELO A005 ( .Y(n_RLD08) );
  TIELO A006 ( .Y(n_RLD09) );
  TIELO A007 ( .Y(n_RLD10) );
  TIELO A008 ( .Y(n_RLD11) );
  TIELO A009 ( .Y(n_RLD12) );
  TIELO A010 ( .Y(n_RLD13) );
  TIELO A011 ( .Y(n_RLD14) );
  DS163 A04 ( .B({n_RLD15, n_RLD14, n_RLD13, n_RLD12, n_RLD11, n_RLD10, 
        n_RLD09, n_RLD08, n_RLD07, n_RLD06, n_RLD05, n_RLD04, n_RLD03, RLD}), 
        .A(WDB), .C(PITL), .S2(PITLEN), .S1(WRLEN), .Y({n_A_161, n_A_162, 
        n_A_163, n_A_164, n_A_165, n_A_166, n_A_167, n_A_168, n_A_169, 
        n_A_1610, n_A_1611, n_A_1612, n_A_1613, n_A_1614, n_A_1615, n_A_1616})
         );
  MX2X2 A1F ( .S0(WCRLE), .B(n_A_1B), .A(n_A_1C), .Y(CARRY) );
  INVX2 A1E ( .A(n_A_08), .Y(WSMSB) );
  MX2X1 A0D ( .S0(MSBLE), .B(n_A_1B), .A(n_A_0R), .Y(n_A_08) );
  FE1R A0M ( .RN(n_A_10), .TE(n_A_0F), .TI(n_A_1C), .CK(MCK), .EN(MSBLE), .D(
        n_A_1B), .Q(n_A_0R) );
  OR2X1 A0W ( .A(WAIVCT), .B(WABINC), .Y(n_A_13) );
  FE1R A0E ( .RN(n_A_10), .TE(n_A_0F), .TI(n_A_0U), .CK(MCK), .EN(n_A_12), .D(
        n_A_13), .Q(n_A_09) );
  TIELO A012 ( .Y(n_RLD15) );
  FE16R A03 ( .D({n_A_0X1, n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, 
        n_A_0X7, n_A_0X8, n_A_0X9, n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, 
        n_A_0X14, n_A_0X15, n_A_0X16}), .TI(n_A_09), .RN(n_A_0W), .TE(n_A_0F), 
        .CK(MCK), .EN(n_A_12), .Q({n_A_0T1, n_A_0T2, n_A_0T3, n_A_0T4, n_A_0T5, 
        n_A_0T6, n_A_0T7, n_A_0T8, n_A_0T9, n_A_0T10, n_A_0T11, n_A_0T12, 
        n_A_0T13, n_A_0T14, n_A_0T15, n_A_0T16}), .TO(n_A_0S) );
  BUFX2 A1D ( .A(n_A_0R), .Y(TO) );
  BUFX2 A0K ( .A(WABLE), .Y(n_A_12) );
  BUFX2 A0J ( .A(TE), .Y(n_A_0F) );
  BUFX2 A0H ( .A(XRST), .Y(n_A_0W) );
  BUFX2 A0G ( .A(n_A_0W), .Y(n_A_10) );
  FE1R A0C ( .RN(n_A_10), .TE(n_A_0F), .TI(n_A_0S), .CK(MCK), .EN(WCRLE), .D(
        n_A_1B), .Q(n_A_1C) );
  FE1R A09 ( .RN(n_A_10), .TE(n_A_0F), .TI(n_A_11), .CK(MCK), .EN(n_A_12), .D(
        WAIVCT), .Q(n_A_0U) );
  INV16 A08 ( .A({n_A_171, n_A_172, n_A_173, n_A_174, n_A_175, n_A_176, 
        n_A_177, n_A_178, n_A_179, n_A_1710, n_A_1711, n_A_1712, n_A_1713, 
        n_A_1714, n_A_1715, n_A_1716}), .INV(n_A_0U), .Y({n_A_181, n_A_182, 
        n_A_183, n_A_184, n_A_185, n_A_186, n_A_187, n_A_188, n_A_189, 
        n_A_1810, n_A_1811, n_A_1812, n_A_1813, n_A_1814, n_A_1815, n_A_1816})
         );
  DS162 A06 ( .A(WSO), .B(PACH), .S(WMADS), .Y(WADI) );
  DS163 A05 ( .B(PACH), .A(WDB), .C(RPD), .S2(WRPEN), .S1(WR0EN), .Y({n_A_0X1, 
        n_A_0X2, n_A_0X3, n_A_0X4, n_A_0X5, n_A_0X6, n_A_0X7, n_A_0X8, n_A_0X9, 
        n_A_0X10, n_A_0X11, n_A_0X12, n_A_0X13, n_A_0X14, n_A_0X15, n_A_0X16})
         );
  FE16R A02 ( .D({n_A_161, n_A_162, n_A_163, n_A_164, n_A_165, n_A_166, 
        n_A_167, n_A_168, n_A_169, n_A_1610, n_A_1611, n_A_1612, n_A_1613, 
        n_A_1614, n_A_1615, n_A_1616}), .TI(TI), .RN(n_A_0W), .TE(n_A_0F), 
        .CK(MCK), .EN(n_A_12), .Q({n_A_171, n_A_172, n_A_173, n_A_174, n_A_175, 
        n_A_176, n_A_177, n_A_178, n_A_179, n_A_1710, n_A_1711, n_A_1712, 
        n_A_1713, n_A_1714, n_A_1715, n_A_1716}), .TO(n_A_11) );
  ADD16C A01 ( .A({n_A_181, n_A_182, n_A_183, n_A_184, n_A_185, n_A_186, 
        n_A_187, n_A_188, n_A_189, n_A_1810, n_A_1811, n_A_1812, n_A_1813, 
        n_A_1814, n_A_1815, n_A_1816}), .B({n_A_0T1, n_A_0T2, n_A_0T3, n_A_0T4, 
        n_A_0T5, n_A_0T6, n_A_0T7, n_A_0T8, n_A_0T9, n_A_0T10, n_A_0T11, 
        n_A_0T12, n_A_0T13, n_A_0T14, n_A_0T15, n_A_0T16}), .CI(n_A_09), .S(
        WSO), .CO(n_A_1B) );
endmodule


module ADD16C ( A, B, CI, S, CO );
  input [15:0] A;
  input [15:0] B;
  output [15:0] S;
  input CI;
  output CO;
  wire   n_A_061, n_A_062, n_A_063, n_A_064, n_A_065, n_A_066, n_A_067,
         n_A_068, n_A_069, n_A_0610, n_A_0611, n_A_0612, n_A_0613, n_A_0614,
         n_A_0615, n_A_0616, n_A_071, n_A_072, n_A_073, n_A_074, n_A_075,
         n_A_076, n_A_077, n_A_078, n_A_079, n_A_0710, n_A_0711, n_A_0712,
         n_A_0713, n_A_0714, n_A_0715, n_A_0716;

  CS16 A002 ( .PN({n_A_071, n_A_072, n_A_073, n_A_074, n_A_075, n_A_076, 
        n_A_077, n_A_078, n_A_079, n_A_0710, n_A_0711, n_A_0712, n_A_0713, 
        n_A_0714, n_A_0715, n_A_0716}), .GN({n_A_061, n_A_062, n_A_063, 
        n_A_064, n_A_065, n_A_066, n_A_067, n_A_068, n_A_069, n_A_0610, 
        n_A_0611, n_A_0612, n_A_0613, n_A_0614, n_A_0615, n_A_0616}), .S(S), 
        .CO(CO) );
  PG16C A001 ( .A(A), .B(B), .CI(CI), .GN({n_A_061, n_A_062, n_A_063, n_A_064, 
        n_A_065, n_A_066, n_A_067, n_A_068, n_A_069, n_A_0610, n_A_0611, 
        n_A_0612, n_A_0613, n_A_0614, n_A_0615, n_A_0616}), .PN({n_A_071, 
        n_A_072, n_A_073, n_A_074, n_A_075, n_A_076, n_A_077, n_A_078, n_A_079, 
        n_A_0710, n_A_0711, n_A_0712, n_A_0713, n_A_0714, n_A_0715, n_A_0716})
         );
endmodule


module PG16C ( A, B, CI, GN, PN );
  input [15:0] A;
  input [15:0] B;
  output [15:0] GN;
  output [15:0] PN;
  input CI;


  AOI222X2 A00S ( .A0(A[0]), .A1(B[0]), .B0(A[0]), .B1(CI), .C0(B[0]), .C1(CI), 
        .Y(GN[0]) );
  NAND2X2 A018 ( .A(A[15]), .B(B[15]), .Y(GN[15]) );
  NAND2X2 A017 ( .A(A[14]), .B(B[14]), .Y(GN[14]) );
  NAND2X2 A016 ( .A(A[13]), .B(B[13]), .Y(GN[13]) );
  NAND2X2 A015 ( .A(A[12]), .B(B[12]), .Y(GN[12]) );
  NAND2X2 A014 ( .A(A[11]), .B(B[11]), .Y(GN[11]) );
  NAND2X2 A013 ( .A(A[10]), .B(B[10]), .Y(GN[10]) );
  NAND2X2 A012 ( .A(A[9]), .B(B[9]), .Y(GN[9]) );
  NAND2X2 A011 ( .A(A[8]), .B(B[8]), .Y(GN[8]) );
  NAND2X2 A010 ( .A(A[7]), .B(B[7]), .Y(GN[7]) );
  NAND2X2 A00Y ( .A(A[6]), .B(B[6]), .Y(GN[6]) );
  NAND2X2 A00X ( .A(A[5]), .B(B[5]), .Y(GN[5]) );
  NAND2X2 A00W ( .A(A[4]), .B(B[4]), .Y(GN[4]) );
  NAND2X2 A00V ( .A(A[3]), .B(B[3]), .Y(GN[3]) );
  NAND2X2 A00U ( .A(A[2]), .B(B[2]), .Y(GN[2]) );
  NAND2X2 A00T ( .A(A[1]), .B(B[1]), .Y(GN[1]) );
  XNOR2X2 A00G ( .A(A[15]), .B(B[15]), .Y(PN[15]) );
  XNOR2X2 A00F ( .A(A[14]), .B(B[14]), .Y(PN[14]) );
  XNOR2X2 A00E ( .A(A[13]), .B(B[13]), .Y(PN[13]) );
  XNOR2X2 A00D ( .A(A[12]), .B(B[12]), .Y(PN[12]) );
  XNOR2X2 A00C ( .A(A[11]), .B(B[11]), .Y(PN[11]) );
  XNOR2X2 A00B ( .A(A[10]), .B(B[10]), .Y(PN[10]) );
  XNOR2X2 A00A ( .A(A[9]), .B(B[9]), .Y(PN[9]) );
  XNOR2X2 A009 ( .A(A[8]), .B(B[8]), .Y(PN[8]) );
  XNOR2X2 A008 ( .A(A[7]), .B(B[7]), .Y(PN[7]) );
  XNOR2X2 A007 ( .A(A[6]), .B(B[6]), .Y(PN[6]) );
  XNOR2X2 A006 ( .A(A[5]), .B(B[5]), .Y(PN[5]) );
  XNOR2X2 A005 ( .A(A[4]), .B(B[4]), .Y(PN[4]) );
  XNOR2X2 A004 ( .A(A[3]), .B(B[3]), .Y(PN[3]) );
  XNOR2X2 A003 ( .A(A[2]), .B(B[2]), .Y(PN[2]) );
  XNOR2X2 A002 ( .A(A[1]), .B(B[1]), .Y(PN[1]) );
  XN3D2 A001 ( .C(CI), .B(B[0]), .A(A[0]), .Y(PN[0]) );
endmodule


module XN3D2 ( C, B, A, Y );
  input C, B, A;
  output Y;
  wire   n_A_02;

  XOR2X2 A01 ( .A(n_A_02), .B(C), .Y(Y) );
  XNOR2X1 A06 ( .A(A), .B(B), .Y(n_A_02) );
endmodule


module CS16 ( PN, GN, S, CO );
  input [15:0] PN;
  input [15:0] GN;
  output [15:0] S;
  output CO;
  wire   n_A_1D, n_A_19, n_A_21, n_A_1C, n_A_1A, n_A_1E, n_A_1G, n_A_1B,
         n_A_1F, n_A_25, n__13G7, n_A_24, n_A_1W, n_A_17, n_A_1X, n__13GN7B,
         n_A_18, n_A_16, n_A_26, n_A_22, n_A_27, n_A_23, n_A_20, n_A_1Y,
         n_B_1M, n_B_21, n_B_1L, n_B_1K, n_B_1S, n_B_1J, n_B_1R, n_B_1V,
         n_B_1H, n_B_1C, n_B_1U, n_B_25, n_B_1E, n_B_26, n_B_23, n_B_1D,
         n_B_24, n_B_22, n_B_1F, n_B_2A, n_B_29, n_B_1X, n_B_1W, n_B_1G,
         n_B_1Y, n_B_20, n_B_27, n_B_28, n_B_2C, n_B_2B;

  OAI21X1 A08 ( .A0(PN[4]), .A1(n_A_1D), .B0(GN[4]), .Y(n_A_19) );
  AOI21X1 A09 ( .A0(n_A_21), .A1(n_A_1C), .B0(n_A_1E), .Y(n_A_1A) );
  AOI21X1 A0A ( .A0(n_A_1G), .A1(n_A_1C), .B0(n_A_1F), .Y(n_A_1B) );
  XOR2X2 A0D ( .A(PN[7]), .B(n_A_1B), .Y(S[7]) );
  OAI21X2 A07 ( .A0(n_A_25), .A1(n_A_1D), .B0(n_A_24), .Y(n__13G7) );
  OAI21X2 A06 ( .A0(PN[2]), .A1(n_A_1W), .B0(GN[2]), .Y(n_A_17) );
  OAI21X2 A05 ( .A0(PN[1]), .A1(GN[0]), .B0(GN[1]), .Y(n_A_1X) );
  INVX2 A0U ( .A(n__13G7), .Y(n__13GN7B) );
  INVX2 A0T ( .A(PN[0]), .Y(S[0]) );
  INVX1 A0S ( .A(n_A_1C), .Y(n_A_18) );
  INVX1 A0R ( .A(n_A_1D), .Y(n_A_1C) );
  INVX1 A0P ( .A(n_A_1W), .Y(n_A_16) );
  INVX1 A0N ( .A(n_A_1X), .Y(n_A_1W) );
  INVX1 A0M ( .A(n_A_26), .Y(n_A_22) );
  INVX1 A0L ( .A(n_A_27), .Y(n_A_23) );
  XNOR2X2 A0K ( .A(PN[2]), .B(n_A_16), .Y(S[2]) );
  XNOR2X2 A0J ( .A(PN[3]), .B(n_A_17), .Y(S[3]) );
  XNOR2X2 A0H ( .A(PN[5]), .B(n_A_19), .Y(S[5]) );
  XOR2X2 A0G ( .A(PN[1]), .B(GN[0]), .Y(S[1]) );
  XOR2X2 A0F ( .A(PN[4]), .B(n_A_18), .Y(S[4]) );
  XOR2X2 A0E ( .A(PN[6]), .B(n_A_1A), .Y(S[6]) );
  XOR2X2 A0C ( .A(PN[8]), .B(n__13GN7B), .Y(S[8]) );
  AOI21X2 A0B ( .A0(n_A_1X), .A1(n_A_20), .B0(n_A_1Y), .Y(n_A_1D) );
  CODD4 A04 ( .GHN(GN[6]), .GLN(n_A_22), .PLN(n_A_23), .PHN(PN[6]), .GO(n_A_1F), .PO(n_A_1G) );
  CODD4 A03 ( .GHN(GN[3]), .GLN(GN[2]), .PLN(PN[2]), .PHN(PN[3]), .GO(n_A_1Y), 
        .PO(n_A_20) );
  CODD4 A02 ( .GHN(GN[5]), .GLN(GN[4]), .PLN(PN[4]), .PHN(PN[5]), .GO(n_A_1E), 
        .PO(n_A_21) );
  ODD8 A01 ( .G2N(GN[5]), .G1N(GN[4]), .G4N(GN[7]), .G3N(GN[6]), .P1N(PN[4]), 
        .P2N(PN[5]), .P3N(PN[6]), .P4N(PN[7]), .YG2(n_A_26), .YG4N(n_A_24), 
        .YP2(n_A_27), .YP4N(n_A_25) );
  INVX2 B26 ( .A(n_B_1M), .Y(CO) );
  INVX1 B1M ( .A(GN[12]), .Y(n_B_21) );
  INVX1 B0V ( .A(PN[9]), .Y(n_B_1L) );
  OAI21X1 B0P ( .A0(n__13GN7B), .A1(PN[8]), .B0(GN[8]), .Y(n_B_1K) );
  AOI21X1 B0L ( .A0(n_B_1S), .A1(n__13G7), .B0(n_B_1R), .Y(n_B_1J) );
  AOI21X1 B0N ( .A0(n_B_1V), .A1(n__13G7), .B0(n_B_1C), .Y(n_B_1H) );
  AOI21X1 B0R ( .A0(n_B_1U), .A1(n_B_25), .B0(n_B_26), .Y(n_B_1E) );
  AOI21X1 B0S ( .A0(n_B_23), .A1(n_B_1U), .B0(n_B_24), .Y(n_B_1D) );
  OAI22X1 B0U ( .A0(n_B_22), .A1(n_B_21), .B0(n_B_21), .B1(n_B_1U), .Y(n_B_1F)
         );
  AOI21X2 B0T ( .A0(n_B_2A), .A1(n__13G7), .B0(n_B_29), .Y(n_B_1M) );
  OAI21X2 B0M ( .A0(n__13GN7B), .A1(n_B_1X), .B0(n_B_1W), .Y(n_B_1U) );
  XOR2X2 B0J ( .A(PN[15]), .B(n_B_1D), .Y(S[15]) );
  XOR2X2 B0H ( .A(PN[14]), .B(n_B_1E), .Y(S[14]) );
  XOR2X2 B0G ( .A(PN[13]), .B(n_B_1F), .Y(S[13]) );
  XOR2X2 B0F ( .A(PN[12]), .B(n_B_1G), .Y(S[12]) );
  XOR2X2 B0E ( .A(PN[11]), .B(n_B_1H), .Y(S[11]) );
  XOR2X2 B0D ( .A(PN[10]), .B(n_B_1J), .Y(S[10]) );
  XOR2X2 B0C ( .A(n_B_1L), .B(n_B_1K), .Y(S[9]) );
  INVX1 B0B ( .A(n_B_1U), .Y(n_B_1G) );
  INVX1 B0A ( .A(n_B_1R), .Y(n_B_1Y) );
  INVX1 B09 ( .A(n_B_1S), .Y(n_B_20) );
  INVX1 B08 ( .A(PN[12]), .Y(n_B_22) );
  INVX1 B07 ( .A(n_B_26), .Y(n_B_27) );
  INVX1 B06 ( .A(n_B_25), .Y(n_B_28) );
  CODD4 B05 ( .GHN(n_B_2B), .GLN(n_B_1W), .PLN(n_B_1X), .PHN(n_B_2C), .GO(
        n_B_29), .PO(n_B_2A) );
  CODD4 B04 ( .GHN(GN[14]), .GLN(n_B_27), .PLN(n_B_28), .PHN(PN[14]), .GO(
        n_B_24), .PO(n_B_23) );
  CODD4 B03 ( .GHN(GN[10]), .GLN(n_B_1Y), .PLN(n_B_20), .PHN(PN[10]), .GO(
        n_B_1C), .PO(n_B_1V) );
  ODD8 B02 ( .G2N(GN[9]), .G1N(GN[8]), .G4N(GN[11]), .G3N(GN[10]), .P1N(PN[8]), 
        .P2N(PN[9]), .P3N(PN[10]), .P4N(PN[11]), .YG2(n_B_1R), .YG4N(n_B_1W), 
        .YP2(n_B_1S), .YP4N(n_B_1X) );
  ODD8 B01 ( .G2N(GN[13]), .G1N(GN[12]), .G4N(GN[15]), .G3N(GN[14]), .P1N(
        PN[12]), .P2N(PN[13]), .P3N(PN[14]), .P4N(PN[15]), .YG2(n_B_26), 
        .YG4N(n_B_2B), .YP2(n_B_25), .YP4N(n_B_2C) );
endmodule


module ODD8 ( G2N, G1N, G4N, G3N, P1N, P2N, P3N, P4N, YG2, YG4N, YP2, YP4N );
  input G2N, G1N, G4N, G3N, P1N, P2N, P3N, P4N;
  output YG2, YG4N, YP2, YP4N;
  wire   n_A_0E, n_A_0A;

  AOI21X2 A06 ( .A0(n_A_0E), .A1(YG2), .B0(n_A_0A), .Y(YG4N) );
  NAND2X2 A05 ( .A(n_A_0E), .B(YP2), .Y(YP4N) );
  OAI21X1 A04 ( .A0(P2N), .A1(G1N), .B0(G2N), .Y(YG2) );
  OAI21X1 A03 ( .A0(P4N), .A1(G3N), .B0(G4N), .Y(n_A_0A) );
  NOR2X1 A02 ( .A(P2N), .B(P1N), .Y(YP2) );
  NOR2X1 A01 ( .A(P4N), .B(P3N), .Y(n_A_0E) );
endmodule


module CODD4 ( GHN, GLN, PLN, PHN, GO, PO );
  input GHN, GLN, PLN, PHN;
  output GO, PO;


  NOR2X1 A01 ( .A(PHN), .B(PLN), .Y(PO) );
  OAI21X1 A02 ( .A0(PHN), .A1(GLN), .B0(GHN), .Y(GO) );
endmodule


module DS162 ( A, B, S, Y );
  input [15:0] A;
  input [15:0] B;
  output [15:0] Y;
  input S;
  wire   n_A_06;

  MX2X2 A000 ( .S0(n_A_06), .B(B[0]), .A(A[0]), .Y(Y[0]) );
  MX2X2 A001 ( .S0(n_A_06), .B(B[1]), .A(A[1]), .Y(Y[1]) );
  MX2X2 A002 ( .S0(n_A_06), .B(B[2]), .A(A[2]), .Y(Y[2]) );
  MX2X2 A003 ( .S0(n_A_06), .B(B[3]), .A(A[3]), .Y(Y[3]) );
  MX2X2 A004 ( .S0(n_A_06), .B(B[4]), .A(A[4]), .Y(Y[4]) );
  MX2X2 A005 ( .S0(n_A_06), .B(B[5]), .A(A[5]), .Y(Y[5]) );
  MX2X2 A006 ( .S0(n_A_06), .B(B[6]), .A(A[6]), .Y(Y[6]) );
  MX2X2 A007 ( .S0(n_A_06), .B(B[7]), .A(A[7]), .Y(Y[7]) );
  MX2X2 A008 ( .S0(n_A_06), .B(B[8]), .A(A[8]), .Y(Y[8]) );
  MX2X2 A009 ( .S0(n_A_06), .B(B[9]), .A(A[9]), .Y(Y[9]) );
  MX2X2 A010 ( .S0(n_A_06), .B(B[10]), .A(A[10]), .Y(Y[10]) );
  MX2X2 A011 ( .S0(n_A_06), .B(B[11]), .A(A[11]), .Y(Y[11]) );
  MX2X2 A012 ( .S0(n_A_06), .B(B[12]), .A(A[12]), .Y(Y[12]) );
  MX2X2 A013 ( .S0(n_A_06), .B(B[13]), .A(A[13]), .Y(Y[13]) );
  MX2X2 A014 ( .S0(n_A_06), .B(B[14]), .A(A[14]), .Y(Y[14]) );
  BUFX4 A103 ( .A(S), .Y(n_A_06) );
  MX2X2 A015 ( .S0(n_A_06), .B(B[15]), .A(A[15]), .Y(Y[15]) );
endmodule


module INV16 ( A, INV, Y );
  input [15:0] A;
  output [15:0] Y;
  input INV;
  wire   n_A_04;

  XOR2X1 A000 ( .A(A[0]), .B(n_A_04), .Y(Y[0]) );
  XOR2X1 A001 ( .A(A[1]), .B(n_A_04), .Y(Y[1]) );
  XOR2X1 A002 ( .A(A[2]), .B(n_A_04), .Y(Y[2]) );
  XOR2X1 A003 ( .A(A[3]), .B(n_A_04), .Y(Y[3]) );
  XOR2X1 A004 ( .A(A[4]), .B(n_A_04), .Y(Y[4]) );
  XOR2X1 A005 ( .A(A[5]), .B(n_A_04), .Y(Y[5]) );
  XOR2X1 A006 ( .A(A[6]), .B(n_A_04), .Y(Y[6]) );
  XOR2X1 A007 ( .A(A[7]), .B(n_A_04), .Y(Y[7]) );
  XOR2X1 A008 ( .A(A[8]), .B(n_A_04), .Y(Y[8]) );
  XOR2X1 A009 ( .A(A[9]), .B(n_A_04), .Y(Y[9]) );
  XOR2X1 A010 ( .A(A[10]), .B(n_A_04), .Y(Y[10]) );
  XOR2X1 A011 ( .A(A[11]), .B(n_A_04), .Y(Y[11]) );
  XOR2X1 A012 ( .A(A[12]), .B(n_A_04), .Y(Y[12]) );
  XOR2X1 A013 ( .A(A[13]), .B(n_A_04), .Y(Y[13]) );
  XOR2X1 A014 ( .A(A[14]), .B(n_A_04), .Y(Y[14]) );
  XOR2X1 A015 ( .A(A[15]), .B(n_A_04), .Y(Y[15]) );
  BUFX4 A103 ( .A(INV), .Y(n_A_04) );
endmodule


module WMD ( WEMDO, CDI, WEMRE, MCK, WST1, WST0, W0LE, W1LE, W2LE, W3LE, TE, 
        XRST, TI, WMDILE, SLWD, WMRD, WCCD, TO );
  input [7:0] WEMDO;
  input [3:0] CDI;
  output [19:0] SLWD;
  output [7:0] WMRD;
  input WEMRE, MCK, WST1, WST0, W0LE, W1LE, W2LE, W3LE, TE, XRST, TI, WMDILE;
  output WCCD, TO;
  wire   n_A_1F1, n_A_1F2, n_A_1F3, n_A_1F4, n_A_1F5, n_A_1F6, n_A_1F7,
         n_A_1F8, n_A_1G1, n_A_1G2, n_A_1G3, n_A_1G4, n_A_1G5, n_A_1G6,
         n_A_1G7, n_A_1G8, n_A_02, n_A_0K, n_A_121, n_A_122, n_A_123, n_A_124,
         n_A_125, n_A_126, n_A_127, n_A_128, n_A_129, n_A_1210, n_A_1211,
         n_A_1212, n_A_1213, n_A_1214, n_A_1215, n_A_1216, n_A_1217, n_A_1218,
         n_A_1219, n_A_1220;

  WCSPL A0F ( .A({n_A_1F1, n_A_1F2, n_A_1F3, n_A_1F4, n_A_1F5, n_A_1F6, 
        n_A_1F7, n_A_1F8}), .Y({n_A_1G1, n_A_1G2, n_A_1G3, n_A_1G4, n_A_1G5, 
        n_A_1G6, n_A_1G7, n_A_1G8}), .CT(WCCD) );
  EN08 A13 ( .A(WEMDO), .EN(WEMRE), .Y(WMRD) );
  RG204 A0A ( .D({n_A_121, n_A_122, n_A_123, n_A_124, n_A_125, n_A_126, 
        n_A_127, n_A_128, n_A_129, n_A_1210, n_A_1211, n_A_1212, n_A_1213, 
        n_A_1214, n_A_1215, n_A_1216, n_A_1217, n_A_1218, n_A_1219, n_A_1220}), 
        .S1(WST1), .S0(WST0), .RN(n_A_0K), .TE(TE), .W3LE(W3LE), .W2LE(W2LE), 
        .W1LE(W1LE), .W0LE(W0LE), .TI(n_A_02), .CK(MCK), .Y(SLWD), .TO(TO) );
  BUFX2 A0N ( .A(XRST), .Y(n_A_0K) );
  FE08R A0M ( .D(WEMDO), .TI(TI), .EN(WMDILE), .CK(MCK), .TE(TE), .RN(n_A_0K), 
        .Q({n_A_1F1, n_A_1F2, n_A_1F3, n_A_1F4, n_A_1F5, n_A_1F6, n_A_1F7, 
        n_A_1F8}), .TO(n_A_02) );
  BS084 A0K ( .A({n_A_1G1, n_A_1G2, n_A_1G3, n_A_1G4, n_A_1G5, n_A_1G6, 
        n_A_1G7, n_A_1G8}), .SFT(CDI), .Y({n_A_121, n_A_122, n_A_123, n_A_124, 
        n_A_125, n_A_126, n_A_127, n_A_128, n_A_129, n_A_1210, n_A_1211, 
        n_A_1212, n_A_1213, n_A_1214, n_A_1215, n_A_1216, n_A_1217, n_A_1218, 
        n_A_1219, n_A_1220}) );
endmodule


module BS084 ( A, SFT, Y );
  input [7:0] A;
  input [3:0] SFT;
  output [19:0] Y;
  wire   n_A_2E, n_A_2G, n_A_2B, n_A_1E, n_A_1D, n_A_10, n_A_15, n_A_11,
         n_A_14, n_A_1B, n_A_13, n_A_1F, n_A_1X, n_A_1W, n_A_2A, n_A_1G,
         n_A_1H, n_A_1Y, n_A_1K, n_A_1J, n_A_21, n_A_20, n_A_29, n_A_1A,
         n_A_1V, n_A_28, n_A_19, n_A_18, n_A_17, n_A_16, n_A_1C, n_A_1P,
         n_A_1N, n_A_1M, n_A_1L, n_A_1U, n_A_1T, n_A_1S, n_A_1R, n_A_25,
         n_A_23, n_A_24, n_A_22, n_A_27, n_A_26;

  TIELO A22 ( .Y(n_A_2E) );
  TIELO A21 ( .Y(n_A_2G) );
  DS32 A0T ( .S(n_A_10), .B2(n_A_2E), .A2(n_A_1D), .B1(n_A_2E), .A1(n_A_1E), 
        .B0(n_A_2E), .A0(n_A_2B), .Y2(Y[0]), .Y1(Y[1]), .Y0(Y[2]) );
  DS42 A0J ( .S(n_A_10), .B3(n_A_2G), .A3(n_A_1F), .B2(n_A_2G), .A2(n_A_13), 
        .B1(n_A_1B), .A1(n_A_14), .B0(n_A_11), .A0(n_A_15), .Y3(Y[3]), .Y2(
        Y[4]), .Y1(Y[5]), .Y0(Y[6]) );
  BUFX2 A0S ( .A(SFT[3]), .Y(n_A_10) );
  BUFX2 A0R ( .A(SFT[2]), .Y(n_A_1X) );
  BUFX2 A0P ( .A(SFT[1]), .Y(n_A_1W) );
  BUFX2 A0N ( .A(SFT[0]), .Y(n_A_2A) );
  TIELO A0M ( .Y(n_A_1G) );
  TIELO A0L ( .Y(n_A_1H) );
  TIELO A0K ( .Y(n_A_1Y) );
  DS22 A0H ( .S(n_A_1X), .B1(n_A_1G), .A1(n_A_1J), .B0(n_A_1G), .A0(n_A_1K), 
        .Y1(n_A_1B), .Y0(n_A_11) );
  DS22 A0G ( .S(n_A_1W), .B1(n_A_1Y), .A1(n_A_20), .B0(n_A_1Y), .A0(n_A_21), 
        .Y1(n_A_1J), .Y0(n_A_1K) );
  TIELO A0F ( .Y(n_A_29) );
  BUFX2 A0E ( .A(n_A_1A), .Y(Y[19]) );
  BUFX2 A0D ( .A(n_A_1V), .Y(n_A_1A) );
  BUFX2 A0C ( .A(n_A_28), .Y(n_A_1V) );
  BUFX2 A0B ( .A(A[7]), .Y(n_A_28) );
  DS42 A0A ( .S(n_A_10), .B3(n_A_1C), .A3(n_A_16), .B2(n_A_1D), .A2(n_A_17), 
        .B1(n_A_1E), .A1(n_A_18), .B0(n_A_2B), .A0(n_A_19), .Y3(Y[7]), .Y2(
        Y[8]), .Y1(Y[9]), .Y0(Y[10]) );
  DS42 A09 ( .S(n_A_10), .B3(n_A_1F), .A3(n_A_1A), .B2(n_A_13), .A2(n_A_1A), 
        .B1(n_A_14), .A1(n_A_1A), .B0(n_A_15), .A0(n_A_1A), .Y3(Y[11]), .Y2(
        Y[12]), .Y1(Y[13]), .Y0(Y[14]) );
  DS42 A08 ( .S(n_A_10), .B3(n_A_16), .A3(n_A_1A), .B2(n_A_17), .A2(n_A_1A), 
        .B1(n_A_18), .A1(n_A_1A), .B0(n_A_19), .A0(n_A_1A), .Y3(Y[15]), .Y2(
        Y[16]), .Y1(Y[17]), .Y0(Y[18]) );
  DS42 A07 ( .S(n_A_1X), .B3(n_A_1H), .A3(n_A_1L), .B2(n_A_1H), .A2(n_A_1M), 
        .B1(n_A_1J), .A1(n_A_1N), .B0(n_A_1K), .A0(n_A_1P), .Y3(n_A_1C), .Y2(
        n_A_1D), .Y1(n_A_1E), .Y0(n_A_2B) );
  DS42 A06 ( .S(n_A_1X), .B3(n_A_1L), .A3(n_A_1R), .B2(n_A_1M), .A2(n_A_1S), 
        .B1(n_A_1N), .A1(n_A_1T), .B0(n_A_1P), .A0(n_A_1U), .Y3(n_A_1F), .Y2(
        n_A_13), .Y1(n_A_14), .Y0(n_A_15) );
  DS42 A05 ( .S(n_A_1X), .B3(n_A_1R), .A3(n_A_1V), .B2(n_A_1S), .A2(n_A_1V), 
        .B1(n_A_1T), .A1(n_A_1V), .B0(n_A_1U), .A0(n_A_1V), .Y3(n_A_16), .Y2(
        n_A_17), .Y1(n_A_18), .Y0(n_A_19) );
  DS42 A04 ( .S(n_A_1W), .B3(n_A_20), .A3(n_A_22), .B2(n_A_21), .A2(n_A_23), 
        .B1(n_A_22), .A1(n_A_24), .B0(n_A_23), .A0(n_A_25), .Y3(n_A_1L), .Y2(
        n_A_1M), .Y1(n_A_1N), .Y0(n_A_1P) );
  DS42 A03 ( .S(n_A_1W), .B3(n_A_24), .A3(n_A_26), .B2(n_A_25), .A2(n_A_27), 
        .B1(n_A_26), .A1(n_A_28), .B0(n_A_27), .A0(n_A_28), .Y3(n_A_1R), .Y2(
        n_A_1S), .Y1(n_A_1T), .Y0(n_A_1U) );
  DS42 A02 ( .S(n_A_2A), .B3(n_A_29), .A3(A[0]), .B2(A[0]), .A2(A[1]), .B1(
        A[1]), .A1(A[2]), .B0(A[2]), .A0(A[3]), .Y3(n_A_20), .Y2(n_A_21), .Y1(
        n_A_22), .Y0(n_A_23) );
  DS42 A01 ( .S(n_A_2A), .B3(A[3]), .A3(A[4]), .B2(A[4]), .A2(A[5]), .B1(A[5]), 
        .A1(A[6]), .B0(A[6]), .A0(A[7]), .Y3(n_A_24), .Y2(n_A_25), .Y1(n_A_26), 
        .Y0(n_A_27) );
endmodule


module DS22 ( S, B1, A1, B0, A0, Y1, Y0 );
  input S, B1, A1, B0, A0;
  output Y1, Y0;
  wire   n_A_08;

  BUFX2 A03 ( .A(S), .Y(n_A_08) );
  MX2X1 A02 ( .S0(n_A_08), .B(B1), .A(A1), .Y(Y1) );
  MX2X1 A01 ( .S0(n_A_08), .B(B0), .A(A0), .Y(Y0) );
endmodule


module DS42 ( S, B3, A3, B2, A2, B1, A1, B0, A0, Y3, Y2, Y1, Y0 );
  input S, B3, A3, B2, A2, B1, A1, B0, A0;
  output Y3, Y2, Y1, Y0;
  wire   n_A_05;

  BUFX2 A05 ( .A(S), .Y(n_A_05) );
  MX2X1 A04 ( .S0(n_A_05), .B(B3), .A(A3), .Y(Y3) );
  MX2X1 A03 ( .S0(n_A_05), .B(B2), .A(A2), .Y(Y2) );
  MX2X1 A02 ( .S0(n_A_05), .B(B1), .A(A1), .Y(Y1) );
  MX2X1 A01 ( .S0(n_A_05), .B(B0), .A(A0), .Y(Y0) );
endmodule


module DS32 ( S, B2, A2, B1, A1, B0, A0, Y2, Y1, Y0 );
  input S, B2, A2, B1, A1, B0, A0;
  output Y2, Y1, Y0;
  wire   n_A_05;

  BUFX2 A05 ( .A(S), .Y(n_A_05) );
  MX2X1 A03 ( .S0(n_A_05), .B(B2), .A(A2), .Y(Y2) );
  MX2X1 A02 ( .S0(n_A_05), .B(B1), .A(A1), .Y(Y1) );
  MX2X1 A01 ( .S0(n_A_05), .B(B0), .A(A0), .Y(Y0) );
endmodule


module FE08R ( D, TI, EN, CK, TE, RN, Q, TO );
  input [7:0] D;
  output [7:0] Q;
  input TI, EN, CK, TE, RN;
  output TO;
  wire   n_A_0T, n_A_0K, n_A_0U;

  BUFX2 A0U ( .A(Q[7]), .Y(TO) );
  BUFX2 A0V ( .A(EN), .Y(n_A_0T) );
  BUFX2 A0T ( .A(TE), .Y(n_A_0K) );
  BUFX2 A0S ( .A(RN), .Y(n_A_0U) );
  FE1R A08 ( .RN(n_A_0U), .TE(n_A_0K), .TI(Q[6]), .CK(CK), .EN(n_A_0T), .D(
        D[7]), .Q(Q[7]) );
  FE1R A07 ( .RN(n_A_0U), .TE(n_A_0K), .TI(Q[5]), .CK(CK), .EN(n_A_0T), .D(
        D[6]), .Q(Q[6]) );
  FE1R A06 ( .RN(n_A_0U), .TE(n_A_0K), .TI(Q[4]), .CK(CK), .EN(n_A_0T), .D(
        D[5]), .Q(Q[5]) );
  FE1R A05 ( .RN(n_A_0U), .TE(n_A_0K), .TI(Q[3]), .CK(CK), .EN(n_A_0T), .D(
        D[4]), .Q(Q[4]) );
  FE1R A04 ( .RN(n_A_0U), .TE(n_A_0K), .TI(Q[2]), .CK(CK), .EN(n_A_0T), .D(
        D[3]), .Q(Q[3]) );
  FE1R A03 ( .RN(n_A_0U), .TE(n_A_0K), .TI(Q[1]), .CK(CK), .EN(n_A_0T), .D(
        D[2]), .Q(Q[2]) );
  FE1R A02 ( .RN(n_A_0U), .TE(n_A_0K), .TI(Q[0]), .CK(CK), .EN(n_A_0T), .D(
        D[1]), .Q(Q[1]) );
  FE1R A01 ( .RN(n_A_0U), .TE(n_A_0K), .TI(TI), .CK(CK), .EN(n_A_0T), .D(D[0]), 
        .Q(Q[0]) );
endmodule


module RG204 ( D, S1, S0, RN, TE, W3LE, W2LE, W1LE, W0LE, TI, CK, Y, TO );
  input [19:0] D;
  output [19:0] Y;
  input S1, S0, RN, TE, W3LE, W2LE, W1LE, W0LE, TI, CK;
  output TO;
  wire   n_A_0N20, n_A_0N19, n_A_0N18, n_A_0N17, n_A_0N16, n_A_0N15, n_A_0N14,
         n_A_0N13, n_A_0N12, n_A_0N11, n_A_0N10, n_A_0N9, n_A_0N8, n_A_0N7,
         n_A_0N6, n_A_0N5, n_A_0N4, n_A_0N3, n_A_0N2, n_A_0N1, n_A_06, n_A_09,
         n_A_0E, n_A_0L1, n_A_0L2, n_A_0L3, n_A_0L4, n_A_0L5, n_A_0L6, n_A_0L7,
         n_A_0L8, n_A_0L9, n_A_0L10, n_A_0L11, n_A_0L12, n_A_0L13, n_A_0L14,
         n_A_0L15, n_A_0L16, n_A_0L17, n_A_0L18, n_A_0L19, n_A_0L20, n_A_0F,
         n_A_0M1, n_A_0M2, n_A_0M3, n_A_0M4, n_A_0M5, n_A_0M6, n_A_0M7,
         n_A_0M8, n_A_0M9, n_A_0M10, n_A_0M11, n_A_0M12, n_A_0M13, n_A_0M14,
         n_A_0M15, n_A_0M16, n_A_0M17, n_A_0M18, n_A_0M19, n_A_0M20, n_A_0G,
         n_A_0C1, n_A_0C2, n_A_0C3, n_A_0C4, n_A_0C5, n_A_0C6, n_A_0C7,
         n_A_0C8, n_A_0C9, n_A_0C10, n_A_0C11, n_A_0C12, n_A_0C13, n_A_0C14,
         n_A_0C15, n_A_0C16, n_A_0C17, n_A_0C18, n_A_0C19, n_A_0C20, n_A_0J1,
         n_A_0J2, n_A_0J3, n_A_0J4, n_A_0J5, n_A_0J6, n_A_0J7, n_A_0J8,
         n_A_0J9, n_A_0J10, n_A_0J11, n_A_0J12, n_A_0J13, n_A_0J14, n_A_0J15,
         n_A_0J16, n_A_0J17, n_A_0J18, n_A_0J19, n_A_0J20;

  BUFX2 A000 ( .A(D[0]), .Y(n_A_0N20) );
  BUFX2 A001 ( .A(D[1]), .Y(n_A_0N19) );
  BUFX2 A002 ( .A(D[2]), .Y(n_A_0N18) );
  BUFX2 A003 ( .A(D[3]), .Y(n_A_0N17) );
  BUFX2 A004 ( .A(D[4]), .Y(n_A_0N16) );
  BUFX2 A005 ( .A(D[5]), .Y(n_A_0N15) );
  BUFX2 A006 ( .A(D[6]), .Y(n_A_0N14) );
  BUFX2 A007 ( .A(D[7]), .Y(n_A_0N13) );
  BUFX2 A008 ( .A(D[8]), .Y(n_A_0N12) );
  BUFX2 A009 ( .A(D[9]), .Y(n_A_0N11) );
  BUFX2 A010 ( .A(D[10]), .Y(n_A_0N10) );
  BUFX2 A011 ( .A(D[11]), .Y(n_A_0N9) );
  BUFX2 A012 ( .A(D[12]), .Y(n_A_0N8) );
  BUFX2 A013 ( .A(D[13]), .Y(n_A_0N7) );
  BUFX2 A014 ( .A(D[14]), .Y(n_A_0N6) );
  BUFX2 A015 ( .A(D[15]), .Y(n_A_0N5) );
  BUFX2 A016 ( .A(D[16]), .Y(n_A_0N4) );
  BUFX2 A017 ( .A(D[17]), .Y(n_A_0N3) );
  BUFX2 A018 ( .A(D[18]), .Y(n_A_0N2) );
  BUFX2 A019 ( .A(D[19]), .Y(n_A_0N1) );
  BUFX2 A08 ( .A(TE), .Y(n_A_06) );
  BUFX2 A07 ( .A(RN), .Y(n_A_09) );
  FE20R A04 ( .D({n_A_0N1, n_A_0N2, n_A_0N3, n_A_0N4, n_A_0N5, n_A_0N6, 
        n_A_0N7, n_A_0N8, n_A_0N9, n_A_0N10, n_A_0N11, n_A_0N12, n_A_0N13, 
        n_A_0N14, n_A_0N15, n_A_0N16, n_A_0N17, n_A_0N18, n_A_0N19, n_A_0N20}), 
        .TI(n_A_0E), .RN(n_A_09), .TE(n_A_06), .CK(CK), .EN(W3LE), .Q({n_A_0L1, 
        n_A_0L2, n_A_0L3, n_A_0L4, n_A_0L5, n_A_0L6, n_A_0L7, n_A_0L8, n_A_0L9, 
        n_A_0L10, n_A_0L11, n_A_0L12, n_A_0L13, n_A_0L14, n_A_0L15, n_A_0L16, 
        n_A_0L17, n_A_0L18, n_A_0L19, n_A_0L20}), .TO(TO) );
  FE20R A03 ( .D({n_A_0N1, n_A_0N2, n_A_0N3, n_A_0N4, n_A_0N5, n_A_0N6, 
        n_A_0N7, n_A_0N8, n_A_0N9, n_A_0N10, n_A_0N11, n_A_0N12, n_A_0N13, 
        n_A_0N14, n_A_0N15, n_A_0N16, n_A_0N17, n_A_0N18, n_A_0N19, n_A_0N20}), 
        .TI(n_A_0F), .RN(n_A_09), .TE(n_A_06), .CK(CK), .EN(W2LE), .Q({n_A_0M1, 
        n_A_0M2, n_A_0M3, n_A_0M4, n_A_0M5, n_A_0M6, n_A_0M7, n_A_0M8, n_A_0M9, 
        n_A_0M10, n_A_0M11, n_A_0M12, n_A_0M13, n_A_0M14, n_A_0M15, n_A_0M16, 
        n_A_0M17, n_A_0M18, n_A_0M19, n_A_0M20}), .TO(n_A_0E) );
  FE20R A02 ( .D({n_A_0N1, n_A_0N2, n_A_0N3, n_A_0N4, n_A_0N5, n_A_0N6, 
        n_A_0N7, n_A_0N8, n_A_0N9, n_A_0N10, n_A_0N11, n_A_0N12, n_A_0N13, 
        n_A_0N14, n_A_0N15, n_A_0N16, n_A_0N17, n_A_0N18, n_A_0N19, n_A_0N20}), 
        .TI(n_A_0G), .RN(n_A_09), .TE(n_A_06), .CK(CK), .EN(W1LE), .Q({n_A_0C1, 
        n_A_0C2, n_A_0C3, n_A_0C4, n_A_0C5, n_A_0C6, n_A_0C7, n_A_0C8, n_A_0C9, 
        n_A_0C10, n_A_0C11, n_A_0C12, n_A_0C13, n_A_0C14, n_A_0C15, n_A_0C16, 
        n_A_0C17, n_A_0C18, n_A_0C19, n_A_0C20}), .TO(n_A_0F) );
  FE20R A01 ( .D({n_A_0N1, n_A_0N2, n_A_0N3, n_A_0N4, n_A_0N5, n_A_0N6, 
        n_A_0N7, n_A_0N8, n_A_0N9, n_A_0N10, n_A_0N11, n_A_0N12, n_A_0N13, 
        n_A_0N14, n_A_0N15, n_A_0N16, n_A_0N17, n_A_0N18, n_A_0N19, n_A_0N20}), 
        .TI(TI), .RN(n_A_09), .TE(n_A_06), .CK(CK), .EN(W0LE), .Q({n_A_0J1, 
        n_A_0J2, n_A_0J3, n_A_0J4, n_A_0J5, n_A_0J6, n_A_0J7, n_A_0J8, n_A_0J9, 
        n_A_0J10, n_A_0J11, n_A_0J12, n_A_0J13, n_A_0J14, n_A_0J15, n_A_0J16, 
        n_A_0J17, n_A_0J18, n_A_0J19, n_A_0J20}), .TO(n_A_0G) );
  DS204 A06 ( .A({n_A_0J1, n_A_0J2, n_A_0J3, n_A_0J4, n_A_0J5, n_A_0J6, 
        n_A_0J7, n_A_0J8, n_A_0J9, n_A_0J10, n_A_0J11, n_A_0J12, n_A_0J13, 
        n_A_0J14, n_A_0J15, n_A_0J16, n_A_0J17, n_A_0J18, n_A_0J19, n_A_0J20}), 
        .B({n_A_0C1, n_A_0C2, n_A_0C3, n_A_0C4, n_A_0C5, n_A_0C6, n_A_0C7, 
        n_A_0C8, n_A_0C9, n_A_0C10, n_A_0C11, n_A_0C12, n_A_0C13, n_A_0C14, 
        n_A_0C15, n_A_0C16, n_A_0C17, n_A_0C18, n_A_0C19, n_A_0C20}), .C({
        n_A_0M1, n_A_0M2, n_A_0M3, n_A_0M4, n_A_0M5, n_A_0M6, n_A_0M7, n_A_0M8, 
        n_A_0M9, n_A_0M10, n_A_0M11, n_A_0M12, n_A_0M13, n_A_0M14, n_A_0M15, 
        n_A_0M16, n_A_0M17, n_A_0M18, n_A_0M19, n_A_0M20}), .D({n_A_0L1, 
        n_A_0L2, n_A_0L3, n_A_0L4, n_A_0L5, n_A_0L6, n_A_0L7, n_A_0L8, n_A_0L9, 
        n_A_0L10, n_A_0L11, n_A_0L12, n_A_0L13, n_A_0L14, n_A_0L15, n_A_0L16, 
        n_A_0L17, n_A_0L18, n_A_0L19, n_A_0L20}), .S1(S1), .S0(S0), .Y(Y) );
endmodule


module DS204 ( A, B, C, D, S1, S0, Y );
  input [19:0] A;
  input [19:0] B;
  input [19:0] C;
  input [19:0] D;
  output [19:0] Y;
  input S1, S0;
  wire   n_A_06, n_A_04;

  MX4X1 A000 ( .S1(n_A_04), .S0(n_A_06), .D(D[0]), .C(C[0]), .B(B[0]), .A(A[0]), .Y(Y[0]) );
  MX4X1 A001 ( .S1(n_A_04), .S0(n_A_06), .D(D[1]), .C(C[1]), .B(B[1]), .A(A[1]), .Y(Y[1]) );
  MX4X1 A002 ( .S1(n_A_04), .S0(n_A_06), .D(D[2]), .C(C[2]), .B(B[2]), .A(A[2]), .Y(Y[2]) );
  MX4X1 A003 ( .S1(n_A_04), .S0(n_A_06), .D(D[3]), .C(C[3]), .B(B[3]), .A(A[3]), .Y(Y[3]) );
  MX4X1 A004 ( .S1(n_A_04), .S0(n_A_06), .D(D[4]), .C(C[4]), .B(B[4]), .A(A[4]), .Y(Y[4]) );
  MX4X1 A005 ( .S1(n_A_04), .S0(n_A_06), .D(D[5]), .C(C[5]), .B(B[5]), .A(A[5]), .Y(Y[5]) );
  MX4X1 A006 ( .S1(n_A_04), .S0(n_A_06), .D(D[6]), .C(C[6]), .B(B[6]), .A(A[6]), .Y(Y[6]) );
  MX4X1 A007 ( .S1(n_A_04), .S0(n_A_06), .D(D[7]), .C(C[7]), .B(B[7]), .A(A[7]), .Y(Y[7]) );
  MX4X1 A008 ( .S1(n_A_04), .S0(n_A_06), .D(D[8]), .C(C[8]), .B(B[8]), .A(A[8]), .Y(Y[8]) );
  MX4X1 A009 ( .S1(n_A_04), .S0(n_A_06), .D(D[9]), .C(C[9]), .B(B[9]), .A(A[9]), .Y(Y[9]) );
  MX4X1 A010 ( .S1(n_A_04), .S0(n_A_06), .D(D[10]), .C(C[10]), .B(B[10]), .A(
        A[10]), .Y(Y[10]) );
  MX4X1 A011 ( .S1(n_A_04), .S0(n_A_06), .D(D[11]), .C(C[11]), .B(B[11]), .A(
        A[11]), .Y(Y[11]) );
  MX4X1 A012 ( .S1(n_A_04), .S0(n_A_06), .D(D[12]), .C(C[12]), .B(B[12]), .A(
        A[12]), .Y(Y[12]) );
  MX4X1 A013 ( .S1(n_A_04), .S0(n_A_06), .D(D[13]), .C(C[13]), .B(B[13]), .A(
        A[13]), .Y(Y[13]) );
  MX4X1 A014 ( .S1(n_A_04), .S0(n_A_06), .D(D[14]), .C(C[14]), .B(B[14]), .A(
        A[14]), .Y(Y[14]) );
  MX4X1 A015 ( .S1(n_A_04), .S0(n_A_06), .D(D[15]), .C(C[15]), .B(B[15]), .A(
        A[15]), .Y(Y[15]) );
  MX4X1 A016 ( .S1(n_A_04), .S0(n_A_06), .D(D[16]), .C(C[16]), .B(B[16]), .A(
        A[16]), .Y(Y[16]) );
  MX4X1 A017 ( .S1(n_A_04), .S0(n_A_06), .D(D[17]), .C(C[17]), .B(B[17]), .A(
        A[17]), .Y(Y[17]) );
  MX4X1 A018 ( .S1(n_A_04), .S0(n_A_06), .D(D[18]), .C(C[18]), .B(B[18]), .A(
        A[18]), .Y(Y[18]) );
  BUFX4 A105 ( .A(S0), .Y(n_A_06) );
  BUFX4 A104 ( .A(S1), .Y(n_A_04) );
  MX4X1 A019 ( .S1(n_A_04), .S0(n_A_06), .D(D[19]), .C(C[19]), .B(B[19]), .A(
        A[19]), .Y(Y[19]) );
endmodule


module FE20R ( D, TI, RN, TE, CK, EN, Q, TO );
  input [19:0] D;
  output [19:0] Q;
  input TI, RN, TE, CK, EN;
  output TO;
  wire   n_A_1A, n_A_1E, n_A_15;

  BUFX2 A28 ( .A(Q[19]), .Y(TO) );
  FE1R A1Y ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[18]), .CK(CK), .EN(n_A_15), .D(
        D[19]), .Q(Q[19]) );
  FE1R A1X ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[17]), .CK(CK), .EN(n_A_15), .D(
        D[18]), .Q(Q[18]) );
  FE1R A1W ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[16]), .CK(CK), .EN(n_A_15), .D(
        D[17]), .Q(Q[17]) );
  FE1R A1V ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[15]), .CK(CK), .EN(n_A_15), .D(
        D[16]), .Q(Q[16]) );
  BUFX4 A04 ( .A(RN), .Y(n_A_1A) );
  BUFX4 A01 ( .A(EN), .Y(n_A_15) );
  BUFX4 A03 ( .A(TE), .Y(n_A_1E) );
  FE1R A1R ( .RN(n_A_1A), .TE(n_A_1E), .TI(TI), .CK(CK), .EN(n_A_15), .D(D[0]), 
        .Q(Q[0]) );
  FE1R A1P ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[0]), .CK(CK), .EN(n_A_15), .D(
        D[1]), .Q(Q[1]) );
  FE1R A1N ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[1]), .CK(CK), .EN(n_A_15), .D(
        D[2]), .Q(Q[2]) );
  FE1R A1M ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[2]), .CK(CK), .EN(n_A_15), .D(
        D[3]), .Q(Q[3]) );
  FE1R A1L ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[3]), .CK(CK), .EN(n_A_15), .D(
        D[4]), .Q(Q[4]) );
  FE1R A1K ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[4]), .CK(CK), .EN(n_A_15), .D(
        D[5]), .Q(Q[5]) );
  FE1R A1J ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[5]), .CK(CK), .EN(n_A_15), .D(
        D[6]), .Q(Q[6]) );
  FE1R A1H ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[6]), .CK(CK), .EN(n_A_15), .D(
        D[7]), .Q(Q[7]) );
  FE1R A1G ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[7]), .CK(CK), .EN(n_A_15), .D(
        D[8]), .Q(Q[8]) );
  FE1R A1F ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[8]), .CK(CK), .EN(n_A_15), .D(
        D[9]), .Q(Q[9]) );
  FE1R A1E ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[9]), .CK(CK), .EN(n_A_15), .D(
        D[10]), .Q(Q[10]) );
  FE1R A1D ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[10]), .CK(CK), .EN(n_A_15), .D(
        D[11]), .Q(Q[11]) );
  FE1R A1C ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[11]), .CK(CK), .EN(n_A_15), .D(
        D[12]), .Q(Q[12]) );
  FE1R A1B ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[12]), .CK(CK), .EN(n_A_15), .D(
        D[13]), .Q(Q[13]) );
  FE1R A1A ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[13]), .CK(CK), .EN(n_A_15), .D(
        D[14]), .Q(Q[14]) );
  FE1R A19 ( .RN(n_A_1A), .TE(n_A_1E), .TI(Q[14]), .CK(CK), .EN(n_A_15), .D(
        D[15]), .Q(Q[15]) );
endmodule


module EN08 ( A, EN, Y );
  input [7:0] A;
  output [7:0] Y;
  input EN;
  wire   n_A_05;

  AND2X2 A010 ( .A(A[0]), .B(n_A_05), .Y(Y[0]) );
  AND2X2 A011 ( .A(A[1]), .B(n_A_05), .Y(Y[1]) );
  AND2X2 A012 ( .A(A[2]), .B(n_A_05), .Y(Y[2]) );
  AND2X2 A013 ( .A(A[3]), .B(n_A_05), .Y(Y[3]) );
  AND2X2 A014 ( .A(A[4]), .B(n_A_05), .Y(Y[4]) );
  AND2X2 A015 ( .A(A[5]), .B(n_A_05), .Y(Y[5]) );
  AND2X2 A016 ( .A(A[6]), .B(n_A_05), .Y(Y[6]) );
  BUFX2 A03 ( .A(EN), .Y(n_A_05) );
  AND2X2 A017 ( .A(A[7]), .B(n_A_05), .Y(Y[7]) );
endmodule


module WCSPL ( A, Y, CT );
  input [7:0] A;
  output [7:0] Y;
  output CT;


  BUFX2 A0J ( .A(A[0]), .Y(CT) );
  TIELO A0Y ( .Y(Y[0]) );
  BUFX2 A07 ( .A(A[1]), .Y(Y[1]) );
  BUFX2 A06 ( .A(A[2]), .Y(Y[2]) );
  BUFX2 A05 ( .A(A[3]), .Y(Y[3]) );
  BUFX2 A04 ( .A(A[4]), .Y(Y[4]) );
  BUFX2 A03 ( .A(A[5]), .Y(Y[5]) );
  BUFX2 A02 ( .A(A[6]), .Y(Y[6]) );
  BUFX2 A01 ( .A(A[7]), .Y(Y[7]) );
endmodule


module WPTLP ( PITH, NSTLE, CARRY, WAPCEN, TI, MCK, WDRCLE, PITALE, XRST, 
        W1ICE, W2ICE, W3ICE, W0ICE, CHNEN, PITBLE, TE, WMODE1, WMODE0, WRLEN, 
        LDIRC, WSMSB, WAIVEN, W3LE, W2LE, W1LE, W0LE, PITB, RLD, WABINC, 
        NLCDLE, WR1SE, CHOFDT, WR106, TO, WNDIRC, WAIVCT );
  input [1:0] PITH;
  output [3:0] PITB;
  output [2:0] RLD;
  input NSTLE, CARRY, WAPCEN, TI, MCK, WDRCLE, PITALE, XRST, W1ICE, W2ICE,
         W3ICE, W0ICE, CHNEN, PITBLE, TE, WMODE1, WMODE0, WRLEN, LDIRC, WSMSB,
         WAIVEN, W3LE, W2LE, W1LE, W0LE;
  output WABINC, NLCDLE, WR1SE, CHOFDT, WR106, TO, WNDIRC, WAIVCT;
  wire   n_A_2B, n_A_25, n_A_2A, n_A_32, n_A_1C, n_A_1P, n_A_1S, n_A_33,
         n_A_0H1, n_A_0H2, n_A_0H3, n_A_0H4, n_A_21, n_PITC0, n_PITC1, n_PITC2,
         n_PITC3, n_A_27, n_A_1W, n_A_13, n_A_11, n_A_19, n_A_08, n_A_2J,
         n_A_2C, n_A_29, n_A_28, n_A_2L, n_A_2K, n_A_2M, n_A_22, n_A_2D,
         n_A_24;

  AND3X1 A17 ( .A(n_A_2B), .B(n_A_25), .C(WMODE1), .Y(n_A_2A) );
  AND2X1 A1G ( .A(n_A_2A), .B(CHNEN), .Y(n_A_32) );
  BUFX2 A2B ( .A(WNDIRC), .Y(TO) );
  FE1R A2L ( .RN(n_A_1C), .TE(n_A_1S), .TI(n_A_1P), .CK(MCK), .EN(WDRCLE), .D(
        n_A_1P), .Q(WNDIRC) );
  INVX2 A2A ( .A(n_A_33), .Y(NLCDLE) );
  PTLGC A0L ( .PIT(PITH), .P1(W1ICE), .P2(W2ICE), .P3(W3ICE), .P0(W0ICE), .CI(
        CARRY), .PITA({n_A_0H1, n_A_0H2, n_A_0H3, n_A_0H4}), .RLD(RLD) );
  BUFX2 A2C ( .A(n_A_21), .Y(n_A_1C) );
  AO2222D2 A1Y ( .H(W3LE), .G(n_PITC3), .F(W2LE), .E(n_PITC2), .D(W1LE), .C(
        n_PITC1), .B(W0LE), .A(n_PITC0), .Y(n_A_33) );
  AND2X2 A1M ( .A(n_A_32), .B(NSTLE), .Y(CHOFDT) );
  BUFX2 A0A ( .A(LDIRC), .Y(n_A_27) );
  BUFX2 A2M ( .A(XRST), .Y(n_A_21) );
  BUFX2 A2K ( .A(TE), .Y(n_A_1S) );
  OR4X1 A22 ( .A(n_PITC0), .B(n_PITC1), .C(n_PITC2), .D(n_PITC3), .Y(n_A_1W)
         );
  FE1R A1U ( .RN(n_A_1C), .TE(n_A_1S), .TI(n_A_13), .CK(MCK), .EN(W0LE), .D(
        n_A_1W), .Q(WR1SE) );
  FE04R A1T ( .D({n_A_0H1, n_A_0H2, n_A_0H3, n_A_0H4}), .CK(MCK), .RN(n_A_21), 
        .TE(n_A_1S), .EN(PITALE), .TI(TI), .Q({n_PITC3, n_PITC2, n_PITC1, 
        n_PITC0}), .TO(n_A_11) );
  FE04R A1S ( .D({n_A_0H1, n_A_0H2, n_A_0H3, n_A_0H4}), .CK(MCK), .RN(n_A_21), 
        .TE(n_A_1S), .EN(PITBLE), .TI(n_A_11), .Q(PITB), .TO(n_A_13) );
  FE1R A1L ( .RN(n_A_1C), .TE(n_A_1S), .TI(WR1SE), .CK(MCK), .EN(NSTLE), .D(
        n_A_19), .Q(WR106) );
  FE1R A1K ( .RN(n_A_1C), .TE(n_A_1S), .TI(WR106), .CK(MCK), .EN(WDRCLE), .D(
        n_A_08), .Q(n_A_1P) );
  INVX1 A1J ( .A(WAIVEN), .Y(n_A_2J) );
  XOR2X1 A1H ( .A(n_A_2C), .B(n_A_27), .Y(n_A_08) );
  NAND2X1 A1F ( .A(n_A_29), .B(n_A_28), .Y(n_A_19) );
  NAND2X1 A1E ( .A(n_A_27), .B(n_A_2B), .Y(n_A_28) );
  NAND2X1 A1D ( .A(n_A_27), .B(WRLEN), .Y(n_A_2L) );
  NAND4X2 A1C ( .A(n_A_2J), .B(n_A_2K), .C(n_A_2M), .D(n_A_2L), .Y(WAIVCT) );
  NAND2X1 A1B ( .A(n_A_2B), .B(WAPCEN), .Y(n_A_2K) );
  NAND3X1 A1A ( .A(n_A_22), .B(n_A_2D), .C(WAPCEN), .Y(n_A_2M) );
  AND3X1 A19 ( .A(WAPCEN), .B(n_A_24), .C(n_A_25), .Y(WABINC) );
  NAND2X1 A18 ( .A(n_A_22), .B(WSMSB), .Y(n_A_29) );
  INVX1 A16 ( .A(n_A_2D), .Y(n_A_25) );
  NOR2X1 A15 ( .A(n_A_2B), .B(n_A_2D), .Y(n_A_2C) );
  INVX1 A14 ( .A(n_A_22), .Y(n_A_2B) );
  BUFX2 A13 ( .A(WMODE0), .Y(n_A_22) );
  AND2X1 A12 ( .A(n_A_22), .B(WMODE1), .Y(n_A_24) );
  XNOR2X1 A11 ( .A(WSMSB), .B(n_A_27), .Y(n_A_2D) );
endmodule


module AO2222D2 ( H, G, F, E, D, C, B, A, Y );
  input H, G, F, E, D, C, B, A;
  output Y;
  wire   n_A_0C, n_A_0B, n_A_0A, n_A_01;

  NOR4X2 A0E ( .A(n_A_0C), .B(n_A_0B), .C(n_A_0A), .D(n_A_01), .Y(Y) );
  AND2X1 A0D ( .A(G), .B(H), .Y(n_A_01) );
  AND2X1 A0C ( .A(E), .B(F), .Y(n_A_0A) );
  AND2X1 A0B ( .A(C), .B(D), .Y(n_A_0B) );
  AND2X1 A01 ( .A(A), .B(B), .Y(n_A_0C) );
endmodule


module PTLGC ( PIT, P1, P2, P3, P0, CI, PITA, RLD );
  input [1:0] PIT;
  output [3:0] PITA;
  output [2:0] RLD;
  input P1, P2, P3, P0, CI;
  wire   n_A_0G, n_A_0F, n_A_0K, n_A_0J, n_A_0M, n_A_0L, n_A_0E, n_A_0D,
         n_A_0T, n_A_0U;

  BUFX2 A0H ( .A(PIT[1]), .Y(n_A_0G) );
  AND3X2 A07 ( .A(n_A_0F), .B(n_A_0G), .C(P0), .Y(RLD[2]) );
  XOR2X1 A0J ( .A(PIT[1]), .B(n_A_0F), .Y(n_A_0K) );
  INVX1 A0G ( .A(n_A_0J), .Y(n_A_0M) );
  INVX1 A0F ( .A(n_A_0G), .Y(n_A_0L) );
  AND2X1 A0E ( .A(n_A_0G), .B(n_A_0F), .Y(PITA[3]) );
  AND2X1 A0D ( .A(n_A_0G), .B(n_A_0J), .Y(PITA[2]) );
  AND2X1 A0C ( .A(n_A_0M), .B(n_A_0K), .Y(PITA[1]) );
  AND2X1 A0B ( .A(n_A_0L), .B(n_A_0J), .Y(PITA[0]) );
  INVX2 A09 ( .A(n_A_0E), .Y(RLD[1]) );
  INVX2 A08 ( .A(n_A_0D), .Y(RLD[0]) );
  AND2X1 A06 ( .A(PIT[0]), .B(CI), .Y(n_A_0F) );
  XOR2X1 A05 ( .A(PIT[0]), .B(CI), .Y(n_A_0J) );
  AOI21X1 A04 ( .A0(P0), .A1(n_A_0K), .B0(n_A_0T), .Y(n_A_0E) );
  AOI21X1 A03 ( .A0(P0), .A1(n_A_0J), .B0(n_A_0U), .Y(n_A_0D) );
  OR2X1 A02 ( .A(P3), .B(P2), .Y(n_A_0T) );
  OR2X1 A01 ( .A(P3), .B(P1), .Y(n_A_0U) );
endmodule


module WMASQ ( CHTEST, ENP, LDIRC, MCK, TI, TE, XRST, SCHON, FSYNC, START, 
        WR1SE, WIMEA, CHS, TO, CHONLE, WPWEN, WEMLE, TSYNC, WSCST, WR6LE, 
        PITLEN, WR7LE, WMDILE, PLCCLE, WNLE, WAPCEN, PITALE, W3ICE, W2ICE, 
        W1ICE, PITBLE, WADBLE, W0ICE, WRPEN, WRLEN, WR0EN, WR1EN, RPDSEN, 
        WSOEN, WIMOEN, PLCCEN, WMADS, WAIVEN, WCRLE, WR5LE, WR4LE, WR3LE, 
        WR2LE, WR1LE, WR0LE, WDRCLE, W3LE, W2LE, W1LE, W0LE, NSTLE, WIMWE, 
        WABLE );
  output [8:0] WIMEA;
  output [5:0] CHS;
  input CHTEST, ENP, LDIRC, MCK, TI, TE, XRST, SCHON, FSYNC, START, WR1SE;
  output TO, CHONLE, WPWEN, WEMLE, TSYNC, WSCST, WR6LE, PITLEN, WR7LE, WMDILE,
         PLCCLE, WNLE, WAPCEN, PITALE, W3ICE, W2ICE, W1ICE, PITBLE, WADBLE,
         W0ICE, WRPEN, WRLEN, WR0EN, WR1EN, RPDSEN, WSOEN, WIMOEN, PLCCEN,
         WMADS, WAIVEN, WCRLE, WR5LE, WR4LE, WR3LE, WR2LE, WR1LE, WR0LE,
         WDRCLE, W3LE, W2LE, W1LE, W0LE, NSTLE, WIMWE, WABLE;
  wire   n_A_0K, n_A_1B, n_A_0W, n_A_0T, n_WSQ0, n_WSQ1, n_A_12, n_A_1J,
         n_A_1E, n_A_17, n_A_11, n_A_0E, n_WCHEN, n_WEV23, n_WEV22, n_WEV21,
         n_WEV20, n_WEV19, n_WEV18, n_WEV17, n_WEV16, n_WEV15, n_WEV14,
         n_WEV13, n_WEV12, n_WEV11, n_WEV10, n_WEV09, n_WEV08, n_WEV07,
         n_WEV06, n_WEV05, n_WEV04, n_WEV03, n_WEV02, n_WEV01, n_WEV00, n_WSQ4,
         n_WSQ3, n_WSQ2, n_A_1H, n_A_0R, n_A_1Y, n_A_1G, n_A_1W, n_A_13,
         n_A_0M, n_A_0X, n_A_0N, n_A_0S, n_A_1R, n_A_1P, n_A_1N, n_B_0A,
         n_B_2G, n_B_3V, n_B_2E, n_B_35, n_B_3U, n_B_2S, n_B_3S, n_B_4B,
         n_B_2R, n_B_2P, n_B_2L, n_B_2N, n_B_3Y, n_B_3X, n_B_3W;

  BUFX2 A000 ( .A(WIMEA[3]), .Y(CHS[0]) );
  BUFX2 A001 ( .A(WIMEA[4]), .Y(CHS[1]) );
  BUFX2 A002 ( .A(WIMEA[5]), .Y(CHS[2]) );
  BUFX2 A003 ( .A(WIMEA[6]), .Y(CHS[3]) );
  BUFX2 A004 ( .A(WIMEA[7]), .Y(CHS[4]) );
  OR2X1 A2J ( .A(n_A_0K), .B(WSCST), .Y(n_A_1B) );
  AND2X1 A0Y ( .A(n_A_0W), .B(n_A_1B), .Y(n_A_0T) );
  AND3X2 A15 ( .A(n_A_0W), .B(n_WSQ0), .C(n_WSQ1), .Y(WEMLE) );
  INVX1 A1C ( .A(CHTEST), .Y(n_A_12) );
  AND2X1 A0R ( .A(n_A_1J), .B(n_A_12), .Y(n_A_1E) );
  INVX1 A1T ( .A(WIMEA[1]), .Y(n_A_17) );
  AND2X1 A10 ( .A(n_A_0W), .B(n_A_11), .Y(n_A_0E) );
  BUFX2 A14 ( .A(ENP), .Y(n_A_0W) );
  BUFX2 A005 ( .A(WIMEA[8]), .Y(CHS[5]) );
  DC24 A04 ( .A({n_WSQ4, n_WSQ3, n_WSQ2, n_WSQ1, n_WSQ0}), .EN(n_WCHEN), .Y({
        n_WEV23, n_WEV22, n_WEV21, n_WEV20, n_WEV19, n_WEV18, n_WEV17, n_WEV16, 
        n_WEV15, n_WEV14, n_WEV13, n_WEV12, n_WEV11, n_WEV10, n_WEV09, n_WEV08, 
        n_WEV07, n_WEV06, n_WEV05, n_WEV04, n_WEV03, n_WEV02, n_WEV01, n_WEV00}) );
  SR1R A2G ( .RN(n_A_1W), .TE(n_A_1Y), .TI(n_WSQ4), .CK(MCK), .SR(n_A_0R), 
        .SS(n_A_1H), .Q(n_A_1G) );
  WMATG A1U ( .D({n_WSQ4, n_WSQ3, n_WSQ2, n_WSQ1, n_WSQ0}), .EN(n_A_0T), .Y2(
        n_A_1H), .Y14(WPWEN), .Y18(n_A_0R), .Y23(n_A_1J) );
  NAND3X1 A2E ( .A(n_A_17), .B(WIMEA[2]), .C(LDIRC), .Y(n_A_13) );
  XNOR2X2 A0X ( .A(n_A_0M), .B(n_A_13), .Y(WIMEA[0]) );
  CO05 A01 ( .RN(n_A_0S), .TE(n_A_0N), .CK(MCK), .SCL(n_A_0X), .TI(n_A_0K), 
        .EN(n_A_0W), .Q4(n_WSQ4), .Q3(n_WSQ3), .Q2(n_WSQ2), .Q1(n_WSQ1), .Q0(
        n_WSQ0) );
  BUFX2 A2C ( .A(WIMEA[8]), .Y(TO) );
  BUFX2 A2A ( .A(TE), .Y(n_A_0N) );
  BUFX2 A29 ( .A(n_A_0N), .Y(n_A_1Y) );
  BUFX2 A25 ( .A(XRST), .Y(n_A_0S) );
  BUFX2 A24 ( .A(n_A_0S), .Y(n_A_1W) );
  BUFX2 A22 ( .A(n_A_1J), .Y(CHONLE) );
  AND2X1 A1P ( .A(n_A_0K), .B(n_A_1J), .Y(TSYNC) );
  FE1R A1N ( .RN(n_A_1W), .TE(n_A_1Y), .TI(WSCST), .CK(MCK), .EN(n_A_0X), .D(
        n_A_1R), .Q(n_A_0K) );
  NAND4X1 A0C ( .A(n_WEV05), .B(n_WEV06), .C(n_WEV08), .D(n_WEV22), .Y(n_A_1P)
         );
  AND2X1 A19 ( .A(WSCST), .B(SCHON), .Y(n_WCHEN) );
  OR2X2 A07 ( .A(n_A_1R), .B(n_A_1J), .Y(n_A_0X) );
  BUFX2 A18 ( .A(FSYNC), .Y(n_A_1R) );
  OR2X1 A0D ( .A(n_A_1N), .B(n_A_1P), .Y(n_A_11) );
  ND5 A0B ( .E(n_WEV04), .D(n_WEV03), .C(n_WEV02), .B(n_WEV01), .A(n_WEV00), 
        .Y(n_A_1N) );
  FE1R A06 ( .RN(n_A_1W), .TE(n_A_1Y), .TI(TI), .CK(MCK), .EN(n_A_1R), .D(
        START), .Q(WSCST) );
  CO06 A03 ( .TI(WIMEA[2]), .RN(n_A_0S), .TE(n_A_0N), .CK(MCK), .SCL(n_A_1R), 
        .EN(n_A_1E), .Q5(WIMEA[8]), .Q4(WIMEA[7]), .Q3(WIMEA[6]), .Q2(WIMEA[5]), .Q1(WIMEA[4]), .Q0(WIMEA[3]) );
  CO03 A02 ( .RN(n_A_0S), .TE(n_A_0N), .TI(n_A_1G), .CK(MCK), .SCL(n_A_1J), 
        .EN(n_A_0E), .Q2(WIMEA[2]), .Q1(WIMEA[1]), .Q0(n_A_0M) );
  NOR2X2 B1D ( .A(n_WEV06), .B(n_B_0A), .Y(WR6LE) );
  INVX2 B18 ( .A(n_WEV07), .Y(PITLEN) );
  NAND3X2 B3P ( .A(n_WEV03), .B(n_WEV06), .C(n_WEV07), .Y(WIMOEN) );
  INVX2 B41 ( .A(n_WEV12), .Y(W3ICE) );
  INVX2 B3Y ( .A(n_WEV08), .Y(W2ICE) );
  INVX2 B40 ( .A(n_WEV03), .Y(W1ICE) );
  INVX2 B3U ( .A(n_WEV19), .Y(W0ICE) );
  BUFX2 B4S ( .A(WRLEN), .Y(WR0EN) );
  INVX2 B3T ( .A(n_B_2G), .Y(RPDSEN) );
  INVX2 B42 ( .A(n_WEV23), .Y(WR1EN) );
  NAND3X1 B0M ( .A(n_WEV07), .B(n_WEV17), .C(n_WEV18), .Y(n_B_3V) );
  NAND2X2 B50 ( .A(n_B_2G), .B(n_B_2E), .Y(WRPEN) );
  OR4X2 B3J ( .A(W0LE), .B(W1LE), .C(W2LE), .D(W3LE), .Y(WNLE) );
  NOR2X2 B5K ( .A(n_WEV07), .B(n_B_0A), .Y(WR7LE) );
  NAND4X2 B3W ( .A(n_WEV03), .B(n_WEV08), .C(n_WEV12), .D(n_WEV19), .Y(WRLEN)
         );
  NAND3X2 B3S ( .A(n_B_2E), .B(n_B_35), .C(n_B_2G), .Y(WSOEN) );
  INVX2 B47 ( .A(n_B_2G), .Y(WAPCEN) );
  INVX2 B3M ( .A(n_WEV05), .Y(PLCCEN) );
  INVX2 B3N ( .A(n_WEV02), .Y(WMADS) );
  INVX2 B0L ( .A(n_B_2E), .Y(WAIVEN) );
  NOR2X2 B30 ( .A(n_WEV23), .B(n_B_0A), .Y(PITBLE) );
  NOR2X2 B2D ( .A(n_WEV08), .B(n_B_0A), .Y(PITALE) );
  NOR2X2 B2E ( .A(n_WEV08), .B(n_B_0A), .Y(WCRLE) );
  NOR2X2 B2F ( .A(n_WEV05), .B(n_B_0A), .Y(WR5LE) );
  NOR2X2 B2G ( .A(n_WEV04), .B(n_B_0A), .Y(WR4LE) );
  NOR2X2 B2H ( .A(n_WEV03), .B(n_B_0A), .Y(WR3LE) );
  NOR2X2 B2J ( .A(n_WEV02), .B(n_B_0A), .Y(WR2LE) );
  NOR2X2 B2K ( .A(n_WEV01), .B(n_B_0A), .Y(WR1LE) );
  NOR2X2 B2L ( .A(n_WEV00), .B(n_B_0A), .Y(WR0LE) );
  NOR2X2 B2M ( .A(n_B_2G), .B(n_B_0A), .Y(WDRCLE) );
  NOR2X2 B2N ( .A(n_WEV20), .B(n_B_0A), .Y(W3LE) );
  NOR2X2 B2P ( .A(n_WEV16), .B(n_B_0A), .Y(W2LE) );
  NOR2X2 B2R ( .A(n_WEV12), .B(n_B_0A), .Y(W1LE) );
  NOR2X2 B3G ( .A(n_WEV05), .B(n_B_0A), .Y(PLCCLE) );
  NOR2X2 B2T ( .A(n_WEV09), .B(n_B_0A), .Y(W0LE) );
  NOR2X2 B1L ( .A(n_B_3U), .B(n_B_0A), .Y(WABLE) );
  NOR2X2 B1J ( .A(n_B_2S), .B(n_B_0A), .Y(WIMWE) );
  NOR2X2 B1G ( .A(n_B_3S), .B(n_B_0A), .Y(WADBLE) );
  NOR2X2 B1F ( .A(n_WEV22), .B(n_B_0A), .Y(NSTLE) );
  NOR2X2 B2B ( .A(n_B_4B), .B(n_B_0A), .Y(WMDILE) );
  AND4X1 B2X ( .A(n_WEV07), .B(n_WEV11), .C(n_WEV15), .D(n_WEV19), .Y(n_B_4B)
         );
  AND4X1 B3L ( .A(n_WEV04), .B(n_WEV09), .C(n_WEV13), .D(n_WEV20), .Y(n_B_2E)
         );
  AND2X1 B5E ( .A(n_B_2R), .B(n_B_2P), .Y(n_B_2S) );
  NAND2X1 B5D ( .A(n_B_2L), .B(WR1SE), .Y(n_B_2P) );
  NAND2X1 B05 ( .A(n_B_2N), .B(n_WCHEN), .Y(n_B_2R) );
  INVX1 B12 ( .A(n_WEV23), .Y(n_B_2L) );
  NAND2X1 B1H ( .A(n_WEV08), .B(n_WEV22), .Y(n_B_2N) );
  AND2X1 B3R ( .A(n_WEV08), .B(n_WEV22), .Y(n_B_35) );
  AND4X1 B2V ( .A(n_WEV05), .B(n_WEV10), .C(n_WEV14), .D(n_WEV21), .Y(n_B_2G)
         );
  AND4X1 B1K ( .A(n_WEV02), .B(n_WEV06), .C(n_WEV11), .D(n_WEV15), .Y(n_B_3S)
         );
  NOR4X1 B1E ( .A(n_B_3Y), .B(n_B_3X), .C(n_B_3W), .D(n_B_3V), .Y(n_B_3U) );
  NAND4X1 B1B ( .A(n_WEV14), .B(n_WEV19), .C(n_WEV20), .D(n_WEV21), .Y(n_B_3W)
         );
  NAND4X1 B1A ( .A(n_WEV09), .B(n_WEV10), .C(n_WEV12), .D(n_WEV13), .Y(n_B_3X)
         );
  NAND4X1 B19 ( .A(n_WEV03), .B(n_WEV04), .C(n_WEV05), .D(n_WEV08), .Y(n_B_3Y)
         );
  INVX4 B17 ( .A(ENP), .Y(n_B_0A) );
endmodule


module CO03 ( RN, TE, TI, CK, SCL, EN, Q2, Q1, Q0 );
  input RN, TE, TI, CK, SCL, EN;
  output Q2, Q1, Q0;
  wire   n_A_0F, n_A_0J, n_A_0G, n_A_0H, n_A_0A, n_A_0E, n_A_0D, n_A_0C,
         n_A_0B;

  COU1 A03 ( .RN(n_A_0H), .TE(n_A_0G), .TI(Q1), .CK(CK), .SCL(n_A_0J), .EN(
        n_A_0F), .Q(Q2) );
  BUFX2 A0C ( .A(RN), .Y(n_A_0H) );
  BUFX2 A0B ( .A(TE), .Y(n_A_0G) );
  COU1 A02 ( .RN(n_A_0H), .TE(n_A_0G), .TI(Q0), .CK(CK), .SCL(n_A_0J), .EN(
        n_A_0A), .QN(n_A_0E), .Q(Q1) );
  COU1 A01 ( .RN(n_A_0H), .TE(n_A_0G), .TI(TI), .CK(CK), .SCL(n_A_0J), .EN(
        n_A_0D), .QN(n_A_0C), .Q(Q0) );
  BUFX2 A0A ( .A(SCL), .Y(n_A_0J) );
  BUFX2 A07 ( .A(EN), .Y(n_A_0D) );
  NOR3X1 A06 ( .A(n_A_0B), .B(n_A_0C), .C(n_A_0E), .Y(n_A_0F) );
  NOR2X1 A05 ( .A(n_A_0B), .B(n_A_0C), .Y(n_A_0A) );
  INVX1 A04 ( .A(n_A_0D), .Y(n_A_0B) );
endmodule


module CO06 ( TI, RN, TE, CK, SCL, EN, Q5, Q4, Q3, Q2, Q1, Q0 );
  input TI, RN, TE, CK, SCL, EN;
  output Q5, Q4, Q3, Q2, Q1, Q0;
  wire   n_A_0B, n_A_0D, n_A_0F, n_A_0A, n_A_02, n_A_0S, n_A_0P, n_A_0V,
         n_A_0N, n_A_01, n_A_0M, n_A_0L, n_A_0T, n_A_0R, n_A_0U;

  BUFX2 A0H ( .A(RN), .Y(n_A_0B) );
  BUFX2 A0G ( .A(TE), .Y(n_A_0D) );
  BUFX2 A0F ( .A(SCL), .Y(n_A_0F) );
  BUFX2 A0D ( .A(EN), .Y(n_A_0A) );
  INVX2 A0C ( .A(n_A_0A), .Y(n_A_02) );
  NOR2X1 A07 ( .A(n_A_02), .B(n_A_0P), .Y(n_A_0S) );
  NR6 A0B ( .F(n_A_0L), .E(n_A_0M), .D(n_A_01), .C(n_A_0N), .B(n_A_0P), .A(
        n_A_02), .Y(n_A_0V) );
  NOR3X1 A08 ( .A(n_A_02), .B(n_A_0P), .C(n_A_0N), .Y(n_A_0T) );
  NR5 A0A ( .E(n_A_0M), .D(n_A_01), .C(n_A_0N), .B(n_A_0P), .A(n_A_02), .Y(
        n_A_0R) );
  NOR4X1 A09 ( .A(n_A_02), .B(n_A_0P), .C(n_A_0N), .D(n_A_01), .Y(n_A_0U) );
  COU1 A06 ( .RN(n_A_0B), .TE(n_A_0D), .TI(Q4), .CK(CK), .SCL(n_A_0F), .EN(
        n_A_0V), .Q(Q5) );
  COU1 A05 ( .RN(n_A_0B), .TE(n_A_0D), .TI(Q3), .CK(CK), .SCL(n_A_0F), .EN(
        n_A_0R), .QN(n_A_0L), .Q(Q4) );
  COU1 A04 ( .RN(n_A_0B), .TE(n_A_0D), .TI(Q2), .CK(CK), .SCL(n_A_0F), .EN(
        n_A_0U), .QN(n_A_0M), .Q(Q3) );
  COU1 A03 ( .RN(n_A_0B), .TE(n_A_0D), .TI(Q1), .CK(CK), .SCL(n_A_0F), .EN(
        n_A_0T), .QN(n_A_01), .Q(Q2) );
  COU1 A02 ( .RN(n_A_0B), .TE(n_A_0D), .TI(Q0), .CK(CK), .SCL(n_A_0F), .EN(
        n_A_0S), .QN(n_A_0N), .Q(Q1) );
  COU1 A01 ( .RN(n_A_0B), .TE(n_A_0D), .TI(TI), .CK(CK), .SCL(n_A_0F), .EN(
        n_A_0A), .QN(n_A_0P), .Q(Q0) );
endmodule


module NR6 ( F, E, D, C, B, A, Y );
  input F, E, D, C, B, A;
  output Y;
  wire   n_A_08, n_A_01;

  AND2X1 A0A ( .A(n_A_08), .B(n_A_01), .Y(Y) );
  NOR3X1 A09 ( .A(D), .B(E), .C(F), .Y(n_A_01) );
  NOR3X1 A01 ( .A(A), .B(B), .C(C), .Y(n_A_08) );
endmodule


module ND5 ( E, D, C, B, A, Y );
  input E, D, C, B, A;
  output Y;
  wire   n_A_01, n_A_07;

  NAND2X1 A09 ( .A(n_A_01), .B(n_A_07), .Y(Y) );
  AND2X1 A08 ( .A(D), .B(E), .Y(n_A_07) );
  AND3X1 A01 ( .A(A), .B(B), .C(C), .Y(n_A_01) );
endmodule


module CO05 ( RN, TE, CK, SCL, TI, EN, Q4, Q3, Q2, Q1, Q0 );
  input RN, TE, CK, SCL, TI, EN;
  output Q4, Q3, Q2, Q1, Q0;
  wire   n_A_09, n_A_0A, n_A_0D, n_A_07, n_A_0J, n_A_0S, n_A_0H, n_A_0K,
         n_A_0R, n_A_0P, n_A_0L, n_A_0M, n_A_0N;

  BUFX2 A0F ( .A(RN), .Y(n_A_09) );
  BUFX2 A0E ( .A(TE), .Y(n_A_0A) );
  BUFX2 A0D ( .A(SCL), .Y(n_A_0D) );
  INVX1 A0C ( .A(n_A_07), .Y(n_A_0J) );
  BUFX2 A0B ( .A(EN), .Y(n_A_07) );
  NOR2X1 A0A ( .A(n_A_0J), .B(n_A_0H), .Y(n_A_0S) );
  NOR3X1 A09 ( .A(n_A_0J), .B(n_A_0H), .C(n_A_0K), .Y(n_A_0R) );
  NOR4X1 A07 ( .A(n_A_0J), .B(n_A_0H), .C(n_A_0K), .D(n_A_0L), .Y(n_A_0P) );
  NR5 A06 ( .E(n_A_0N), .D(n_A_0L), .C(n_A_0K), .B(n_A_0H), .A(n_A_0J), .Y(
        n_A_0M) );
  COU1 A05 ( .RN(n_A_09), .TE(n_A_0A), .TI(Q3), .CK(CK), .SCL(n_A_0D), .EN(
        n_A_0M), .Q(Q4) );
  COU1 A04 ( .RN(n_A_09), .TE(n_A_0A), .TI(Q2), .CK(CK), .SCL(n_A_0D), .EN(
        n_A_0P), .QN(n_A_0N), .Q(Q3) );
  COU1 A03 ( .RN(n_A_09), .TE(n_A_0A), .TI(Q1), .CK(CK), .SCL(n_A_0D), .EN(
        n_A_0R), .QN(n_A_0L), .Q(Q2) );
  COU1 A02 ( .RN(n_A_09), .TE(n_A_0A), .TI(Q0), .CK(CK), .SCL(n_A_0D), .EN(
        n_A_0S), .QN(n_A_0K), .Q(Q1) );
  COU1 A01 ( .RN(n_A_09), .TE(n_A_0A), .TI(TI), .CK(CK), .SCL(n_A_0D), .EN(
        n_A_07), .QN(n_A_0H), .Q(Q0) );
endmodule


module COU1 ( RN, TE, TI, CK, SCL, EN, QN, Q );
  input RN, TE, TI, CK, SCL, EN;
  output QN, Q;
  wire   n_A_0D, n_A_01, n_A_0C;

  AND2X1 A0D ( .A(n_A_0D), .B(n_A_01), .Y(n_A_0C) );
  INVX1 A0C ( .A(SCL), .Y(n_A_01) );
  DFFRX2 A03 ( .D(n_A_0C), .CK(CK), .RN(RN), .Q(Q), .QN(QN) );
  MX2X1 A02 ( .S0(EN), .B(QN), .A(Q), .Y(n_A_0D) );
endmodule


module NR5 ( E, D, C, B, A, Y );
  input E, D, C, B, A;
  output Y;
  wire   n_A_07, n_A_01;

  AND2X1 A09 ( .A(n_A_07), .B(n_A_01), .Y(Y) );
  NOR2X1 A08 ( .A(D), .B(E), .Y(n_A_01) );
  NOR3X1 A01 ( .A(A), .B(B), .C(C), .Y(n_A_07) );
endmodule


module WMATG ( D, EN, Y2, Y14, Y18, Y23 );
  input [4:0] D;
  input EN;
  output Y2, Y14, Y18, Y23;
  wire   n_A_11, n_A_0B, n_A_0V, n_A_13, n_A_0T, n_A_12, n_A_0R, n_A_0Y;

  INVX1 A17 ( .A(D[0]), .Y(n_A_11) );
  AD5D2 A02 ( .E(n_A_13), .D(n_A_0V), .C(D[4]), .B(D[1]), .A(n_A_0B), .Y(Y18)
         );
  NOR2X1 A0A ( .A(D[0]), .B(D[2]), .Y(n_A_0B) );
  AD5D2 A01 ( .E(n_A_0T), .D(D[3]), .C(D[2]), .B(D[1]), .A(n_A_11), .Y(Y14) );
  INVX1 A15 ( .A(n_A_13), .Y(n_A_12) );
  BUFX2 A14 ( .A(EN), .Y(n_A_13) );
  NR6D2 A04 ( .F(n_A_12), .E(D[4]), .D(D[3]), .C(D[2]), .B(n_A_0R), .A(D[0]), 
        .Y(Y2) );
  AD6D2 A03 ( .F(n_A_13), .E(n_A_0Y), .D(D[4]), .C(D[2]), .B(D[1]), .A(D[0]), 
        .Y(Y23) );
  INVX1 A09 ( .A(D[3]), .Y(n_A_0V) );
  INVX1 A08 ( .A(D[1]), .Y(n_A_0R) );
  INVX1 A06 ( .A(D[4]), .Y(n_A_0T) );
  INVX1 A05 ( .A(D[3]), .Y(n_A_0Y) );
endmodule


module AD6D2 ( F, E, D, C, B, A, Y );
  input F, E, D, C, B, A;
  output Y;
  wire   n_A_04;

  INVX2 A02 ( .A(n_A_04), .Y(Y) );
  ND6 A01 ( .F(F), .E(E), .D(D), .C(C), .B(B), .A(A), .Y(n_A_04) );
endmodule


module ND6 ( F, E, D, C, B, A, Y );
  input F, E, D, C, B, A;
  output Y;
  wire   n_A_03, n_A_01;

  NAND2X1 A03 ( .A(n_A_03), .B(n_A_01), .Y(Y) );
  AND3X1 A02 ( .A(D), .B(E), .C(F), .Y(n_A_01) );
  AND3X1 A01 ( .A(A), .B(B), .C(C), .Y(n_A_03) );
endmodule


module NR6D2 ( F, E, D, C, B, A, Y );
  input F, E, D, C, B, A;
  output Y;
  wire   n_A_08, n_A_01;

  AND2X2 A0A ( .A(n_A_08), .B(n_A_01), .Y(Y) );
  NOR3X1 A09 ( .A(D), .B(E), .C(F), .Y(n_A_01) );
  NOR3X1 A01 ( .A(A), .B(B), .C(C), .Y(n_A_08) );
endmodule


module AD5D2 ( E, D, C, B, A, Y );
  input E, D, C, B, A;
  output Y;
  wire   n_A_07, n_A_01;

  NOR2X1 A09 ( .A(n_A_07), .B(n_A_01), .Y(Y) );
  NAND2X1 A08 ( .A(D), .B(E), .Y(n_A_01) );
  NAND3X1 A01 ( .A(A), .B(B), .C(C), .Y(n_A_07) );
endmodule


module SR1R ( RN, TE, TI, CK, SR, SS, Q );
  input RN, TE, TI, CK, SR, SS;
  output Q;
  wire   n_A_08, n_A_0A, n_A_0B;

  DFFRHQX2 A01 ( .D(n_A_08), .CK(CK), .RN(RN), .Q(Q) );
  INVX1 A05 ( .A(SR), .Y(n_A_0A) );
  AND2X1 A04 ( .A(n_A_0B), .B(n_A_0A), .Y(n_A_08) );
  OR2X1 A03 ( .A(Q), .B(SS), .Y(n_A_0B) );
endmodule


module DC24 ( A, EN, Y );
  input [4:0] A;
  output [23:0] Y;
  input EN;
  wire   n_A_0U, n_A_0V, n_A_0X, n_A_18, n_A_0W, n_A_0T, n_A_19, n_A_1A,
         n_A_15, n_A_16, n_A_17;

  OR3X1 A05 ( .A(n_A_0U), .B(n_A_0V), .C(n_A_0X), .Y(n_A_18) );
  OR3X1 A06 ( .A(n_A_0W), .B(n_A_0T), .C(n_A_0X), .Y(n_A_19) );
  OR3X1 A04 ( .A(n_A_0U), .B(n_A_0T), .C(n_A_0X), .Y(n_A_1A) );
  DC08E A01 ( .C(n_A_15), .B(n_A_16), .A(n_A_17), .EN(n_A_18), .Y7(Y[23]), 
        .Y6(Y[22]), .Y5(Y[21]), .Y4(Y[20]), .Y3(Y[19]), .Y2(Y[18]), .Y1(Y[17]), 
        .Y0(Y[16]) );
  DC08E A02 ( .C(n_A_15), .B(n_A_16), .A(n_A_17), .EN(n_A_19), .Y7(Y[15]), 
        .Y6(Y[14]), .Y5(Y[13]), .Y4(Y[12]), .Y3(Y[11]), .Y2(Y[10]), .Y1(Y[9]), 
        .Y0(Y[8]) );
  DC08E A03 ( .C(n_A_15), .B(n_A_16), .A(n_A_17), .EN(n_A_1A), .Y7(Y[7]), .Y6(
        Y[6]), .Y5(Y[5]), .Y4(Y[4]), .Y3(Y[3]), .Y2(Y[2]), .Y1(Y[1]), .Y0(Y[0]) );
  INVX1 A1C ( .A(EN), .Y(n_A_0X) );
  INVX1 A0D ( .A(n_A_0V), .Y(n_A_0T) );
  INVX1 A0C ( .A(A[4]), .Y(n_A_0V) );
  INVX1 A0B ( .A(n_A_0W), .Y(n_A_0U) );
  INVX1 A0A ( .A(A[3]), .Y(n_A_0W) );
  BUFX2 A09 ( .A(A[2]), .Y(n_A_15) );
  BUFX2 A08 ( .A(A[1]), .Y(n_A_16) );
  BUFX2 A07 ( .A(A[0]), .Y(n_A_17) );
endmodule


module DC08E ( C, B, A, EN, Y7, Y6, Y5, Y4, Y3, Y2, Y1, Y0 );
  input C, B, A, EN;
  output Y7, Y6, Y5, Y4, Y3, Y2, Y1, Y0;
  wire   n_A_02, n_A_0F, n_A_0D, n_A_0B, n_A_0E, n_A_0C, n_A_0G, n_A_0L,
         n_A_0M, n_A_0N, n_A_0P, n_A_0R, n_A_0S, n_A_0T, n_A_0U;

  INVX2 A0P ( .A(EN), .Y(n_A_02) );
  INVX2 A0N ( .A(n_A_0F), .Y(n_A_0D) );
  INVX2 A0M ( .A(C), .Y(n_A_0F) );
  INVX2 A0L ( .A(n_A_0B), .Y(n_A_0E) );
  INVX2 A0K ( .A(B), .Y(n_A_0B) );
  INVX2 A0J ( .A(n_A_0C), .Y(n_A_0G) );
  INVX2 A0H ( .A(A), .Y(n_A_0C) );
  NOR3X1 A0G ( .A(n_A_0C), .B(n_A_0B), .C(n_A_0F), .Y(n_A_0L) );
  NOR3X1 A0F ( .A(n_A_0G), .B(n_A_0B), .C(n_A_0F), .Y(n_A_0M) );
  NOR3X1 A0E ( .A(n_A_0C), .B(n_A_0E), .C(n_A_0F), .Y(n_A_0N) );
  NOR3X1 A0D ( .A(n_A_0G), .B(n_A_0E), .C(n_A_0F), .Y(n_A_0P) );
  NOR3X1 A0C ( .A(n_A_0C), .B(n_A_0B), .C(n_A_0D), .Y(n_A_0R) );
  NOR3X1 A0B ( .A(n_A_0G), .B(n_A_0B), .C(n_A_0D), .Y(n_A_0S) );
  NOR3X1 A0A ( .A(n_A_0C), .B(n_A_0E), .C(n_A_0D), .Y(n_A_0T) );
  NOR3X1 A09 ( .A(n_A_0G), .B(n_A_0E), .C(n_A_0D), .Y(n_A_0U) );
  NAND2X4 A08 ( .A(n_A_02), .B(n_A_0L), .Y(Y7) );
  NAND2X4 A07 ( .A(n_A_02), .B(n_A_0M), .Y(Y6) );
  NAND2X4 A06 ( .A(n_A_02), .B(n_A_0N), .Y(Y5) );
  NAND2X4 A05 ( .A(n_A_02), .B(n_A_0P), .Y(Y4) );
  NAND2X4 A04 ( .A(n_A_02), .B(n_A_0R), .Y(Y3) );
  NAND2X4 A03 ( .A(n_A_02), .B(n_A_0S), .Y(Y2) );
  NAND2X4 A02 ( .A(n_A_02), .B(n_A_0T), .Y(Y1) );
  NAND2X4 A01 ( .A(n_A_02), .B(n_A_0U), .Y(Y0) );
endmodule


module WMREG ( WIMO, WR6LE, WR0LE, MCK, XRST, WR1LE, TE, WR7LE, WR2LE, WR5LE, 
        TI, WR4LE, RPDSEN, WSMSB, PITCH, PLACA, RPD, FMODE, WEMAH, PLCD, PACH, 
        LDIRC, TO, WMODE1, WMODE0 );
  input [15:0] WIMO;
  output [17:0] PITCH;
  output [6:0] PLACA;
  output [15:0] RPD;
  output [1:0] FMODE;
  output [3:0] WEMAH;
  output [6:0] PLCD;
  output [15:0] PACH;
  input WR6LE, WR0LE, MCK, XRST, WR1LE, TE, WR7LE, WR2LE, WR5LE, TI, WR4LE,
         RPDSEN, WSMSB;
  output LDIRC, TO, WMODE1, WMODE0;
  wire   n_WRMO00, n_WRMO01, n_WRMO02, n_WRMO03, n_WRMO04, n_WRMO05, n_WRMO06,
         n_WRMO07, n_WRMO08, n_WRMO09, n_WRMO10, n_WRMO11, n_WRMO12, n_WRMO13,
         n_WRMO14, n_A_05, n_A_0H, n_A_1X, n_A_07, n_A_23, n_A_04, n_A_1Y,
         n_WRMO15, n_A_19, n_A_1C, n_A_1V, n_A_1S, n_A_0Y, n_A_1L1, n_A_1L2,
         n_A_1L3, n_A_1L4, n_A_1L5, n_A_1L6, n_A_1L7, n_A_1L8, n_A_1L9,
         n_A_1L10, n_A_1L11, n_A_1L12, n_A_1L13, n_A_1L14, n_A_1L15, n_A_1L16,
         n_A_1K1, n_A_1K2, n_A_1K3, n_A_1K4, n_A_1K5, n_A_1K6, n_A_1K7,
         n_A_1K8, n_A_1K9, n_A_1K10, n_A_1K11, n_A_1K12, n_A_1K13, n_A_1K14,
         n_A_1K15, n_A_1K16, n_A_1R, n_A_1P, n_A_0D, n_A_0N, n_A_13, n_A_1G,
         n_A_1D, n_A_1F, n_A_1E, n_A_12, n_A_0K;

  BUFX2 A100 ( .A(WIMO[0]), .Y(n_WRMO00) );
  BUFX2 A101 ( .A(WIMO[1]), .Y(n_WRMO01) );
  BUFX2 A102 ( .A(WIMO[2]), .Y(n_WRMO02) );
  BUFX2 A103 ( .A(WIMO[3]), .Y(n_WRMO03) );
  BUFX2 A104 ( .A(WIMO[4]), .Y(n_WRMO04) );
  BUFX2 A105 ( .A(WIMO[5]), .Y(n_WRMO05) );
  BUFX2 A106 ( .A(WIMO[6]), .Y(n_WRMO06) );
  BUFX2 A107 ( .A(WIMO[7]), .Y(n_WRMO07) );
  BUFX2 A108 ( .A(WIMO[8]), .Y(n_WRMO08) );
  BUFX2 A109 ( .A(WIMO[9]), .Y(n_WRMO09) );
  BUFX2 A110 ( .A(WIMO[10]), .Y(n_WRMO10) );
  BUFX2 A111 ( .A(WIMO[11]), .Y(n_WRMO11) );
  BUFX2 A112 ( .A(WIMO[12]), .Y(n_WRMO12) );
  BUFX2 A113 ( .A(WIMO[13]), .Y(n_WRMO13) );
  BUFX2 A114 ( .A(WIMO[14]), .Y(n_WRMO14) );
  FE02R A04 ( .D({n_WRMO01, n_WRMO00}), .EN(n_A_05), .RN(n_A_07), .TE(n_A_1X), 
        .TI(n_A_0H), .CK(MCK), .Q(PITCH[1:0]), .TO(n_A_23) );
  FE07R A0M ( .D({n_WRMO15, n_WRMO14, n_WRMO13, n_WRMO12, n_WRMO11, n_WRMO10, 
        n_WRMO09}), .CK(MCK), .TI(n_A_04), .EN(WR7LE), .TE(n_A_1X), .RN(n_A_07), .Q(PLACA), .TO(n_A_1Y) );
  FE16R A05 ( .D({n_WRMO15, n_WRMO14, n_WRMO13, n_WRMO12, n_WRMO11, n_WRMO10, 
        n_WRMO09, n_WRMO08, n_WRMO07, n_WRMO06, n_WRMO05, n_WRMO04, n_WRMO03, 
        n_WRMO02, n_WRMO01, n_WRMO00}), .TI(n_A_23), .RN(n_A_07), .TE(n_A_1X), 
        .CK(MCK), .EN(WR6LE), .Q(PITCH[17:2]), .TO(n_A_04) );
  XOR2X1 A0K ( .A(n_A_1C), .B(LDIRC), .Y(n_A_19) );
  AND2X1 A1V ( .A(WR5LE), .B(n_A_19), .Y(n_A_1V) );
  BUFX2 A14 ( .A(PLCD[6]), .Y(LDIRC) );
  BUFX2 A115 ( .A(WIMO[15]), .Y(n_WRMO15) );
  BUFX2 A13 ( .A(XRST), .Y(n_A_07) );
  BUFX2 A12 ( .A(TE), .Y(n_A_1X) );
  FE16R A1R ( .D({n_WRMO15, n_WRMO14, n_WRMO13, n_WRMO12, n_WRMO11, n_WRMO10, 
        n_WRMO09, n_WRMO08, n_WRMO07, n_WRMO06, n_WRMO05, n_WRMO04, n_WRMO03, 
        n_WRMO02, n_WRMO01, n_WRMO00}), .TI(n_A_1S), .RN(n_A_07), .TE(n_A_1X), 
        .CK(MCK), .EN(WR0LE), .Q(PACH), .TO(TO) );
  OR2X1 A07 ( .A(WR4LE), .B(n_A_1V), .Y(n_A_0Y) );
  DS163 A03 ( .B({n_A_1K1, n_A_1K2, n_A_1K3, n_A_1K4, n_A_1K5, n_A_1K6, 
        n_A_1K7, n_A_1K8, n_A_1K9, n_A_1K10, n_A_1K11, n_A_1K12, n_A_1K13, 
        n_A_1K14, n_A_1K15, n_A_1K16}), .A({n_A_1L1, n_A_1L2, n_A_1L3, n_A_1L4, 
        n_A_1L5, n_A_1L6, n_A_1L7, n_A_1L8, n_A_1L9, n_A_1L10, n_A_1L11, 
        n_A_1L12, n_A_1L13, n_A_1L14, n_A_1L15, n_A_1L16}), .C({n_WRMO15, 
        n_WRMO14, n_WRMO13, n_WRMO12, n_WRMO11, n_WRMO10, n_WRMO09, n_WRMO08, 
        n_WRMO07, n_WRMO06, n_WRMO05, n_WRMO04, n_WRMO03, n_WRMO02, n_WRMO01, 
        n_WRMO00}), .S2(n_A_0Y), .S1(n_A_1C), .Y(RPD) );
  MX2X1 A08 ( .S0(LDIRC), .B(WR4LE), .A(WR5LE), .Y(n_A_1R) );
  MX2X1 A1P ( .S0(LDIRC), .B(WR5LE), .A(WR4LE), .Y(n_A_1P) );
  BUFX2 A10 ( .A(WR2LE), .Y(n_A_05) );
  FE07R A0B ( .D({n_WRMO06, n_WRMO05, n_WRMO04, n_WRMO03, n_WRMO02, n_WRMO01, 
        n_WRMO00}), .CK(MCK), .TI(n_A_0D), .EN(WR1LE), .TE(n_A_1X), .RN(n_A_07), .Q(PLCD), .TO(n_A_1S) );
  FE4R A0X ( .TI(n_A_0N), .CK(MCK), .D3(n_WRMO04), .D2(n_WRMO05), .D1(n_WRMO06), .D0(n_WRMO07), .EN(n_A_05), .TE(n_A_1X), .RN(n_A_07), .TO(n_A_0D), .Q0(
        FMODE[1]), .Q1(FMODE[0]), .Q2(WMODE1), .Q3(WMODE0) );
  FE04R A1H ( .D({n_WRMO15, n_WRMO14, n_WRMO13, n_WRMO12}), .CK(MCK), .RN(
        n_A_07), .TE(n_A_1X), .EN(n_A_05), .TI(n_A_1Y), .Q(WEMAH), .TO(n_A_0N)
         );
  NOR2X2 A0W ( .A(WMODE1), .B(WMODE0), .Y(n_A_13) );
  NAND3X1 A0E ( .A(n_A_1D), .B(LDIRC), .C(RPDSEN), .Y(n_A_1G) );
  NAND3X1 A0D ( .A(n_A_13), .B(WSMSB), .C(RPDSEN), .Y(n_A_1F) );
  NAND3X1 A0C ( .A(n_A_1F), .B(n_A_1G), .C(n_A_1E), .Y(n_A_1C) );
  INVX1 A0H ( .A(n_A_13), .Y(n_A_1D) );
  INVX1 A0G ( .A(RPDSEN), .Y(n_A_12) );
  NAND2X1 A0F ( .A(n_A_12), .B(LDIRC), .Y(n_A_1E) );
  FE16R A02 ( .D({n_WRMO15, n_WRMO14, n_WRMO13, n_WRMO12, n_WRMO11, n_WRMO10, 
        n_WRMO09, n_WRMO08, n_WRMO07, n_WRMO06, n_WRMO05, n_WRMO04, n_WRMO03, 
        n_WRMO02, n_WRMO01, n_WRMO00}), .TI(n_A_0K), .RN(n_A_07), .TE(n_A_1X), 
        .CK(MCK), .EN(n_A_1R), .Q({n_A_1K1, n_A_1K2, n_A_1K3, n_A_1K4, n_A_1K5, 
        n_A_1K6, n_A_1K7, n_A_1K8, n_A_1K9, n_A_1K10, n_A_1K11, n_A_1K12, 
        n_A_1K13, n_A_1K14, n_A_1K15, n_A_1K16}), .TO(n_A_0H) );
  FE16R A01 ( .D({n_WRMO15, n_WRMO14, n_WRMO13, n_WRMO12, n_WRMO11, n_WRMO10, 
        n_WRMO09, n_WRMO08, n_WRMO07, n_WRMO06, n_WRMO05, n_WRMO04, n_WRMO03, 
        n_WRMO02, n_WRMO01, n_WRMO00}), .TI(TI), .RN(n_A_07), .TE(n_A_1X), 
        .CK(MCK), .EN(n_A_1P), .Q({n_A_1L1, n_A_1L2, n_A_1L3, n_A_1L4, n_A_1L5, 
        n_A_1L6, n_A_1L7, n_A_1L8, n_A_1L9, n_A_1L10, n_A_1L11, n_A_1L12, 
        n_A_1L13, n_A_1L14, n_A_1L15, n_A_1L16}), .TO(n_A_0K) );
endmodule


module FE04R ( D, CK, RN, TE, EN, TI, Q, TO );
  input [3:0] D;
  output [3:0] Q;
  input CK, RN, TE, EN, TI;
  output TO;
  wire   n_A_0H, n_A_0K, n_A_0G;

  BUFX2 A0G ( .A(Q[3]), .Y(TO) );
  FE1R A02 ( .RN(n_A_0H), .TE(n_A_0K), .TI(Q[0]), .CK(CK), .EN(n_A_0G), .D(
        D[1]), .Q(Q[1]) );
  BUFX2 A0F ( .A(EN), .Y(n_A_0G) );
  BUFX2 A0E ( .A(TE), .Y(n_A_0K) );
  BUFX2 A0D ( .A(RN), .Y(n_A_0H) );
  FE1R A04 ( .RN(n_A_0H), .TE(n_A_0K), .TI(Q[2]), .CK(CK), .EN(n_A_0G), .D(
        D[3]), .Q(Q[3]) );
  FE1R A03 ( .RN(n_A_0H), .TE(n_A_0K), .TI(Q[1]), .CK(CK), .EN(n_A_0G), .D(
        D[2]), .Q(Q[2]) );
  FE1R A01 ( .RN(n_A_0H), .TE(n_A_0K), .TI(TI), .CK(CK), .EN(n_A_0G), .D(D[0]), 
        .Q(Q[0]) );
endmodule


module FE4R ( TI, CK, D3, D2, D1, D0, EN, TE, RN, TO, Q0, Q1, Q2, Q3 );
  input TI, CK, D3, D2, D1, D0, EN, TE, RN;
  output TO, Q0, Q1, Q2, Q3;
  wire   n_A_0A, n_A_0B, n_A_0D;

  BUFX2 A0L ( .A(Q3), .Y(TO) );
  BUFX2 A07 ( .A(RN), .Y(n_A_0A) );
  BUFX2 A06 ( .A(TE), .Y(n_A_0B) );
  BUFX2 A05 ( .A(EN), .Y(n_A_0D) );
  FE1R A04 ( .RN(n_A_0A), .TE(n_A_0B), .TI(Q2), .CK(CK), .EN(n_A_0D), .D(D3), 
        .Q(Q3) );
  FE1R A03 ( .RN(n_A_0A), .TE(n_A_0B), .TI(Q1), .CK(CK), .EN(n_A_0D), .D(D2), 
        .Q(Q2) );
  FE1R A02 ( .RN(n_A_0A), .TE(n_A_0B), .TI(Q0), .CK(CK), .EN(n_A_0D), .D(D1), 
        .Q(Q1) );
  FE1R A01 ( .RN(n_A_0A), .TE(n_A_0B), .TI(TI), .CK(CK), .EN(n_A_0D), .D(D0), 
        .Q(Q0) );
endmodule


module DS163 ( B, A, C, S2, S1, Y );
  input [15:0] B;
  input [15:0] A;
  input [15:0] C;
  output [15:0] Y;
  input S2, S1;
  wire   n_A_0A, n_A_0B16, n_A_0B15, n_A_0B14, n_A_0B13, n_A_0B12, n_A_0B11,
         n_A_0B10, n_A_0B9, n_A_0B8, n_A_0B7, n_A_0B6, n_A_0B5, n_A_0B4,
         n_A_0B3, n_A_0B2, n_A_08, n_A_0B1;

  MX2X1 A100 ( .S0(n_A_0A), .B(B[0]), .A(A[0]), .Y(n_A_0B16) );
  MX2X1 A101 ( .S0(n_A_0A), .B(B[1]), .A(A[1]), .Y(n_A_0B15) );
  MX2X1 A102 ( .S0(n_A_0A), .B(B[2]), .A(A[2]), .Y(n_A_0B14) );
  MX2X1 A103 ( .S0(n_A_0A), .B(B[3]), .A(A[3]), .Y(n_A_0B13) );
  MX2X1 A104 ( .S0(n_A_0A), .B(B[4]), .A(A[4]), .Y(n_A_0B12) );
  MX2X1 A105 ( .S0(n_A_0A), .B(B[5]), .A(A[5]), .Y(n_A_0B11) );
  MX2X1 A106 ( .S0(n_A_0A), .B(B[6]), .A(A[6]), .Y(n_A_0B10) );
  MX2X1 A107 ( .S0(n_A_0A), .B(B[7]), .A(A[7]), .Y(n_A_0B9) );
  MX2X1 A108 ( .S0(n_A_0A), .B(B[8]), .A(A[8]), .Y(n_A_0B8) );
  MX2X1 A109 ( .S0(n_A_0A), .B(B[9]), .A(A[9]), .Y(n_A_0B7) );
  MX2X1 A110 ( .S0(n_A_0A), .B(B[10]), .A(A[10]), .Y(n_A_0B6) );
  MX2X1 A111 ( .S0(n_A_0A), .B(B[11]), .A(A[11]), .Y(n_A_0B5) );
  MX2X1 A112 ( .S0(n_A_0A), .B(B[12]), .A(A[12]), .Y(n_A_0B4) );
  MX2X1 A113 ( .S0(n_A_0A), .B(B[13]), .A(A[13]), .Y(n_A_0B3) );
  MX2X1 A114 ( .S0(n_A_0A), .B(B[14]), .A(A[14]), .Y(n_A_0B2) );
  MX2X2 A200 ( .S0(n_A_08), .B(C[0]), .A(n_A_0B16), .Y(Y[0]) );
  MX2X2 A201 ( .S0(n_A_08), .B(C[1]), .A(n_A_0B15), .Y(Y[1]) );
  MX2X2 A202 ( .S0(n_A_08), .B(C[2]), .A(n_A_0B14), .Y(Y[2]) );
  MX2X2 A203 ( .S0(n_A_08), .B(C[3]), .A(n_A_0B13), .Y(Y[3]) );
  MX2X2 A204 ( .S0(n_A_08), .B(C[4]), .A(n_A_0B12), .Y(Y[4]) );
  MX2X2 A205 ( .S0(n_A_08), .B(C[5]), .A(n_A_0B11), .Y(Y[5]) );
  MX2X2 A206 ( .S0(n_A_08), .B(C[6]), .A(n_A_0B10), .Y(Y[6]) );
  MX2X2 A207 ( .S0(n_A_08), .B(C[7]), .A(n_A_0B9), .Y(Y[7]) );
  MX2X2 A208 ( .S0(n_A_08), .B(C[8]), .A(n_A_0B8), .Y(Y[8]) );
  MX2X2 A209 ( .S0(n_A_08), .B(C[9]), .A(n_A_0B7), .Y(Y[9]) );
  MX2X2 A210 ( .S0(n_A_08), .B(C[10]), .A(n_A_0B6), .Y(Y[10]) );
  MX2X2 A211 ( .S0(n_A_08), .B(C[11]), .A(n_A_0B5), .Y(Y[11]) );
  MX2X2 A212 ( .S0(n_A_08), .B(C[12]), .A(n_A_0B4), .Y(Y[12]) );
  MX2X2 A213 ( .S0(n_A_08), .B(C[13]), .A(n_A_0B3), .Y(Y[13]) );
  MX2X2 A214 ( .S0(n_A_08), .B(C[14]), .A(n_A_0B2), .Y(Y[14]) );
  BUFX4 A002 ( .A(S1), .Y(n_A_0A) );
  BUFX4 A001 ( .A(S2), .Y(n_A_08) );
  MX2X2 A215 ( .S0(n_A_08), .B(C[15]), .A(n_A_0B1), .Y(Y[15]) );
  MX2X1 A115 ( .S0(n_A_0A), .B(B[15]), .A(A[15]), .Y(n_A_0B1) );
endmodule


module FE16R ( D, TI, RN, TE, CK, EN, Q, TO );
  input [15:0] D;
  output [15:0] Q;
  input TI, RN, TE, CK, EN;
  output TO;
  wire   n_A_1A, n_A_15, n_A_1B;

  BUFX2 A1V ( .A(Q[15]), .Y(TO) );
  BUFX4 A04 ( .A(RN), .Y(n_A_1A) );
  BUFX4 A01 ( .A(EN), .Y(n_A_15) );
  BUFX4 A03 ( .A(TE), .Y(n_A_1B) );
  FE1R A1R ( .RN(n_A_1A), .TE(n_A_1B), .TI(TI), .CK(CK), .EN(n_A_15), .D(D[0]), 
        .Q(Q[0]) );
  FE1R A1P ( .RN(n_A_1A), .TE(n_A_1B), .TI(Q[0]), .CK(CK), .EN(n_A_15), .D(
        D[1]), .Q(Q[1]) );
  FE1R A1N ( .RN(n_A_1A), .TE(n_A_1B), .TI(Q[1]), .CK(CK), .EN(n_A_15), .D(
        D[2]), .Q(Q[2]) );
  FE1R A1M ( .RN(n_A_1A), .TE(n_A_1B), .TI(Q[2]), .CK(CK), .EN(n_A_15), .D(
        D[3]), .Q(Q[3]) );
  FE1R A1L ( .RN(n_A_1A), .TE(n_A_1B), .TI(Q[3]), .CK(CK), .EN(n_A_15), .D(
        D[4]), .Q(Q[4]) );
  FE1R A1K ( .RN(n_A_1A), .TE(n_A_1B), .TI(Q[4]), .CK(CK), .EN(n_A_15), .D(
        D[5]), .Q(Q[5]) );
  FE1R A1J ( .RN(n_A_1A), .TE(n_A_1B), .TI(Q[5]), .CK(CK), .EN(n_A_15), .D(
        D[6]), .Q(Q[6]) );
  FE1R A1H ( .RN(n_A_1A), .TE(n_A_1B), .TI(Q[6]), .CK(CK), .EN(n_A_15), .D(
        D[7]), .Q(Q[7]) );
  FE1R A1G ( .RN(n_A_1A), .TE(n_A_1B), .TI(Q[7]), .CK(CK), .EN(n_A_15), .D(
        D[8]), .Q(Q[8]) );
  FE1R A1F ( .RN(n_A_1A), .TE(n_A_1B), .TI(Q[8]), .CK(CK), .EN(n_A_15), .D(
        D[9]), .Q(Q[9]) );
  FE1R A1E ( .RN(n_A_1A), .TE(n_A_1B), .TI(Q[9]), .CK(CK), .EN(n_A_15), .D(
        D[10]), .Q(Q[10]) );
  FE1R A1D ( .RN(n_A_1A), .TE(n_A_1B), .TI(Q[10]), .CK(CK), .EN(n_A_15), .D(
        D[11]), .Q(Q[11]) );
  FE1R A1C ( .RN(n_A_1A), .TE(n_A_1B), .TI(Q[11]), .CK(CK), .EN(n_A_15), .D(
        D[12]), .Q(Q[12]) );
  FE1R A1B ( .RN(n_A_1A), .TE(n_A_1B), .TI(Q[12]), .CK(CK), .EN(n_A_15), .D(
        D[13]), .Q(Q[13]) );
  FE1R A1A ( .RN(n_A_1A), .TE(n_A_1B), .TI(Q[13]), .CK(CK), .EN(n_A_15), .D(
        D[14]), .Q(Q[14]) );
  FE1R A19 ( .RN(n_A_1A), .TE(n_A_1B), .TI(Q[14]), .CK(CK), .EN(n_A_15), .D(
        D[15]), .Q(Q[15]) );
endmodule


module FE07R ( D, CK, TI, EN, TE, RN, Q, TO );
  input [6:0] D;
  output [6:0] Q;
  input CK, TI, EN, TE, RN;
  output TO;
  wire   n_A_0R, n_A_0S, n_A_0E;

  BUFX2 A0M ( .A(RN), .Y(n_A_0R) );
  BUFX2 A0L ( .A(TE), .Y(n_A_0S) );
  BUFX2 A0K ( .A(EN), .Y(n_A_0E) );
  FE1R A0Y ( .RN(n_A_0R), .TE(n_A_0S), .TI(Q[5]), .CK(CK), .EN(n_A_0E), .D(
        D[6]), .Q(Q[6]) );
  BUFX2 A0V ( .A(Q[6]), .Y(TO) );
  FE1R A06 ( .RN(n_A_0R), .TE(n_A_0S), .TI(Q[4]), .CK(CK), .EN(n_A_0E), .D(
        D[5]), .Q(Q[5]) );
  FE1R A05 ( .RN(n_A_0R), .TE(n_A_0S), .TI(Q[3]), .CK(CK), .EN(n_A_0E), .D(
        D[4]), .Q(Q[4]) );
  FE1R A04 ( .RN(n_A_0R), .TE(n_A_0S), .TI(Q[2]), .CK(CK), .EN(n_A_0E), .D(
        D[3]), .Q(Q[3]) );
  FE1R A03 ( .RN(n_A_0R), .TE(n_A_0S), .TI(Q[1]), .CK(CK), .EN(n_A_0E), .D(
        D[2]), .Q(Q[2]) );
  FE1R A02 ( .RN(n_A_0R), .TE(n_A_0S), .TI(Q[0]), .CK(CK), .EN(n_A_0E), .D(
        D[1]), .Q(Q[1]) );
  FE1R A01 ( .RN(n_A_0R), .TE(n_A_0S), .TI(TI), .CK(CK), .EN(n_A_0E), .D(D[0]), 
        .Q(Q[0]) );
endmodule


module FE02R ( D, EN, RN, TE, TI, CK, Q, TO );
  input [1:0] D;
  output [1:0] Q;
  input EN, RN, TE, TI, CK;
  output TO;
  wire   n_A_0C, n_A_0A;

  BUFX2 A09 ( .A(Q[1]), .Y(TO) );
  BUFX2 A08 ( .A(RN), .Y(n_A_0C) );
  BUFX2 A05 ( .A(TE), .Y(n_A_0A) );
  FE1R A02 ( .RN(n_A_0C), .TE(n_A_0A), .TI(Q[0]), .CK(CK), .EN(EN), .D(D[1]), 
        .Q(Q[1]) );
  FE1R A01 ( .RN(n_A_0C), .TE(n_A_0A), .TI(TI), .CK(CK), .EN(EN), .D(D[0]), 
        .Q(Q[0]) );
endmodule


module FE1R ( RN, TE, TI, CK, EN, D, Q );
  input RN, TE, TI, CK, EN, D;
  output Q;
  wire   n_A_08;

  DFFRHQX2 A02 ( .D(n_A_08), .CK(CK), .RN(RN), .Q(Q) );
  MX2X1 A01 ( .S0(EN), .B(D), .A(Q), .Y(n_A_08) );
endmodule


module SEIPDmaIf ( PCLK, PRESETB, RxFIFOWrite, RxFIFOWrData, RxFIFOReadCpu, 
        RxFIFORdDataCpu, RxFIFOFlush, RxFIFODataCnt, RxFIFOEmpty, RxFIFOFull, 
        RxDmaEn, RxDmaSize, RxDmaReset, RxDmaRequest, RxDmaErr, RxDmaReq, 
        TxFIFORead, TxFIFORdData, TxFIFOWriteCpu, TxFIFOWrDataCpu, TxFIFOFlush, 
        TxFIFODataCnt, TxFIFOEmpty, TxFIFOFull, TxDmaEn, TxDmaSize, TxDmaReset, 
        TxDmaRequest, TxDmaErr, TxDmaReq, RXSYNC, RXRDY, RXWE, RXD, TXSYNC, 
        TXRDY, TXRD, TXD );
  input [31:0] RxFIFOWrData;
  output [31:0] RxFIFORdDataCpu;
  output [2:0] RxFIFODataCnt;
  input [2:0] RxDmaSize;
  output [31:0] TxFIFORdData;
  input [31:0] TxFIFOWrDataCpu;
  output [2:0] TxFIFODataCnt;
  input [2:0] TxDmaSize;
  output [31:0] RXD;
  input [31:0] TXD;
  input PCLK, PRESETB, RxFIFOWrite, RxFIFOReadCpu, RxFIFOFlush, RxDmaEn,
         RxDmaReset, TxFIFORead, TxFIFOWriteCpu, TxFIFOFlush, TxDmaEn,
         TxDmaReset, RXSYNC, RXRDY, TXSYNC, TXRD;
  output RxFIFOEmpty, RxFIFOFull, RxDmaRequest, RxDmaErr, RxDmaReq,
         TxFIFOEmpty, TxFIFOFull, TxDmaRequest, TxDmaErr, TxDmaReq, RXWE,
         TXRDY;
  wire   n483, n484, n485, n486, n487, n488, n489, n490, n491, n492, n493,
         n494, n495, n496, n497, n498, n499, n500, n501, n502, n503, n504,
         n505, n506, n507, n508, n509, n510, n511, n512, n513, n514, tRIdle,
         tRSync, tTIdle, tTSync, n191, RxDmaRequest262, TxFIFOWrData_31_,
         TxFIFOWrData_30_, TxFIFOWrData_29_, TxFIFOWrData_28_,
         TxFIFOWrData_27_, TxFIFOWrData_26_, TxFIFOWrData_25_,
         TxFIFOWrData_24_, TxFIFOWrData_23_, TxFIFOWrData_22_,
         TxFIFOWrData_21_, TxFIFOWrData_20_, TxFIFOWrData_19_,
         TxFIFOWrData_18_, TxFIFOWrData_17_, TxFIFOWrData_16_,
         TxFIFOWrData_15_, TxFIFOWrData_14_, TxFIFOWrData_13_,
         TxFIFOWrData_12_, TxFIFOWrData_11_, TxFIFOWrData_10_, TxFIFOWrData_9_,
         TxFIFOWrData_8_, TxFIFOWrData_7_, TxFIFOWrData_6_, TxFIFOWrData_5_,
         TxFIFOWrData_4_, TxFIFOWrData_3_, TxFIFOWrData_2_, TxFIFOWrData_1_,
         TxFIFOWrData_0_, n313, TxDmaRequest379, n515, n516, n517, n518, n519,
         n520, n521, n522, n523, n525, n526, n527, n528, n530, n531, n532,
         n533, n537, n539, n542, n543, n545, n547, n548, n549, n550, n551,
         n552, n553, n554;
  wire   [2:0] NxtStR;
  wire   [2:0] NxtStT;
  assign RxFIFORdDataCpu[31] = n483;
  assign RXD[31] = n483;
  assign RxFIFORdDataCpu[30] = n484;
  assign RXD[30] = n484;
  assign RxFIFORdDataCpu[29] = n485;
  assign RXD[29] = n485;
  assign RxFIFORdDataCpu[28] = n486;
  assign RXD[28] = n486;
  assign RxFIFORdDataCpu[27] = n487;
  assign RXD[27] = n487;
  assign RxFIFORdDataCpu[26] = n488;
  assign RXD[26] = n488;
  assign RxFIFORdDataCpu[25] = n489;
  assign RXD[25] = n489;
  assign RxFIFORdDataCpu[24] = n490;
  assign RXD[24] = n490;
  assign RxFIFORdDataCpu[23] = n491;
  assign RXD[23] = n491;
  assign RxFIFORdDataCpu[22] = n492;
  assign RXD[22] = n492;
  assign RxFIFORdDataCpu[21] = n493;
  assign RXD[21] = n493;
  assign RxFIFORdDataCpu[20] = n494;
  assign RXD[20] = n494;
  assign RxFIFORdDataCpu[19] = n495;
  assign RXD[19] = n495;
  assign RxFIFORdDataCpu[18] = n496;
  assign RXD[18] = n496;
  assign RxFIFORdDataCpu[17] = n497;
  assign RXD[17] = n497;
  assign RxFIFORdDataCpu[16] = n498;
  assign RXD[16] = n498;
  assign RxFIFORdDataCpu[15] = n499;
  assign RXD[15] = n499;
  assign RxFIFORdDataCpu[14] = n500;
  assign RXD[14] = n500;
  assign RxFIFORdDataCpu[13] = n501;
  assign RXD[13] = n501;
  assign RxFIFORdDataCpu[12] = n502;
  assign RXD[12] = n502;
  assign RxFIFORdDataCpu[11] = n503;
  assign RXD[11] = n503;
  assign RxFIFORdDataCpu[10] = n504;
  assign RXD[10] = n504;
  assign RxFIFORdDataCpu[9] = n505;
  assign RXD[9] = n505;
  assign RxFIFORdDataCpu[8] = n506;
  assign RXD[8] = n506;
  assign RxFIFORdDataCpu[7] = n507;
  assign RXD[7] = n507;
  assign RxFIFORdDataCpu[6] = n508;
  assign RXD[6] = n508;
  assign RxFIFORdDataCpu[5] = n509;
  assign RXD[5] = n509;
  assign RxFIFORdDataCpu[4] = n510;
  assign RXD[4] = n510;
  assign RxFIFORdDataCpu[3] = n511;
  assign RXD[3] = n511;
  assign RxFIFORdDataCpu[2] = n512;
  assign RXD[2] = n512;
  assign RxFIFORdDataCpu[1] = n513;
  assign RXD[1] = n513;
  assign RxFIFORdDataCpu[0] = n514;
  assign RXD[0] = n514;

  PcmFIFO_FIFO_AW3_FIFO_DW32 PcmRxFIFO ( .Clk(PCLK), .nRST(PRESETB), 
        .FIFOWrite(RxFIFOWrite), .FIFOWrData(RxFIFOWrData), .FIFORead(n191), 
        .FIFORdData({n483, n484, n485, n486, n487, n488, n489, n490, n491, 
        n492, n493, n494, n495, n496, n497, n498, n499, n500, n501, n502, n503, 
        n504, n505, n506, n507, n508, n509, n510, n511, n512, n513, n514}), 
        .FIFOFlush(RxFIFOFlush), .FIFOFull(RxFIFOFull), .FIFOEmpty(RxFIFOEmpty), .FIFODataCnt(RxFIFODataCnt) );
  PcmFIFO_FIFO_AW3_FIFO_DW32_0 PcmTxFIFO ( .Clk(PCLK), .nRST(PRESETB), 
        .FIFOWrite(n313), .FIFOWrData({TxFIFOWrData_31_, TxFIFOWrData_30_, 
        TxFIFOWrData_29_, TxFIFOWrData_28_, TxFIFOWrData_27_, TxFIFOWrData_26_, 
        TxFIFOWrData_25_, TxFIFOWrData_24_, TxFIFOWrData_23_, TxFIFOWrData_22_, 
        TxFIFOWrData_21_, TxFIFOWrData_20_, TxFIFOWrData_19_, TxFIFOWrData_18_, 
        TxFIFOWrData_17_, TxFIFOWrData_16_, TxFIFOWrData_15_, TxFIFOWrData_14_, 
        TxFIFOWrData_13_, TxFIFOWrData_12_, TxFIFOWrData_11_, TxFIFOWrData_10_, 
        TxFIFOWrData_9_, TxFIFOWrData_8_, TxFIFOWrData_7_, TxFIFOWrData_6_, 
        TxFIFOWrData_5_, TxFIFOWrData_4_, TxFIFOWrData_3_, TxFIFOWrData_2_, 
        TxFIFOWrData_1_, TxFIFOWrData_0_}), .FIFORead(TxFIFORead), 
        .FIFORdData(TxFIFORdData), .FIFOFlush(TxFIFOFlush), .FIFOFull(
        TxFIFOFull), .FIFOEmpty(TxFIFOEmpty), .FIFODataCnt(TxFIFODataCnt) );
  OAI222XL U242 ( .A0(n553), .A1(n525), .B0(RxFIFODataCnt[2]), .B1(
        RxDmaSize[2]), .C0(n526), .C1(n527), .Y(RxDmaReq) );
  NOR2BX1 U243 ( .AN(RxFIFOEmpty), .B(n547), .Y(RxDmaErr) );
  NOR2BX1 U244 ( .AN(RxFIFOFull), .B(n522), .Y(TxDmaErr) );
  CLKINVX1 U245 ( .A(RxFIFOEmpty), .Y(n543) );
  CLKINVX1 U246 ( .A(TxFIFOFull), .Y(n537) );
  CLKINVX1 U247 ( .A(n554), .Y(n515) );
  DFFRX1 TxDmaRequest_reg ( .D(TxDmaRequest379), .CK(PCLK), .RN(PRESETB), .Q(
        TxDmaRequest) );
  DFFRX1 RxDmaRequest_reg ( .D(RxDmaRequest262), .CK(PCLK), .RN(PRESETB), .Q(
        RxDmaRequest) );
  AO21X1 U248 ( .A0(TXRDY), .A1(TXRD), .B0(n554), .Y(n313) );
  AO21X1 U249 ( .A0(RXWE), .A1(RXRDY), .B0(RxFIFOReadCpu), .Y(n191) );
  CLKBUFX3 U250 ( .A(TxFIFOWriteCpu), .Y(n554) );
  OAI31XL U251 ( .A0(TXRDY), .A1(tTSync), .A2(tTIdle), .B0(n539), .Y(NxtStT[0]) );
  OA22X1 U252 ( .A0(n549), .A1(n537), .B0(n522), .B1(n548), .Y(n539) );
  AO22X1 U253 ( .A0(tTSync), .A1(TXSYNC), .B0(TXRDY), .B1(n522), .Y(NxtStT[2])
         );
  OAI2BB2XL U254 ( .A0N(tTIdle), .A1N(n537), .B0(n551), .B1(TXSYNC), .Y(
        NxtStT[1]) );
  OAI2BB2XL U255 ( .A0N(tRIdle), .A1N(n543), .B0(n552), .B1(RXSYNC), .Y(
        NxtStR[1]) );
  AO22X1 U256 ( .A0(tRSync), .A1(RXSYNC), .B0(RXWE), .B1(n542), .Y(NxtStR[2])
         );
  OAI31XL U257 ( .A0(RXWE), .A1(tRSync), .A2(tRIdle), .B0(n545), .Y(NxtStR[0])
         );
  OA22X1 U258 ( .A0(n543), .A1(n550), .B0(n542), .B1(n547), .Y(n545) );
  OAI33X1 U259 ( .A0(n530), .A1(n531), .A2(n532), .B0(n530), .B1(
        RxFIFODataCnt[0]), .B2(n533), .Y(n526) );
  AO21X1 U260 ( .A0(n553), .A1(n525), .B0(n528), .Y(n527) );
  CLKINVX1 U261 ( .A(RxDmaSize[1]), .Y(n530) );
  NAND2BX1 U262 ( .AN(RxFIFODataCnt[0]), .B(n531), .Y(n525) );
  NOR3BXL U263 ( .AN(TxDmaEn), .B(n516), .C(TxDmaReset), .Y(TxDmaRequest379)
         );
  CLKINVX1 U264 ( .A(TxDmaReq), .Y(n516) );
  NOR3BXL U265 ( .AN(RxDmaEn), .B(n523), .C(RxDmaReset), .Y(RxDmaRequest262)
         );
  CLKINVX1 U266 ( .A(RxDmaReq), .Y(n523) );
  AO22X1 U267 ( .A0(TxFIFODataCnt[2]), .A1(n517), .B0(n518), .B1(n519), .Y(
        TxDmaReq) );
  OAI2BB1X1 U268 ( .A0N(TxFIFODataCnt[1]), .A1N(n520), .B0(n521), .Y(n519) );
  OA22X1 U269 ( .A0(TxFIFODataCnt[1]), .A1(n520), .B0(TxFIFODataCnt[2]), .B1(
        n517), .Y(n518) );
  NOR2BX1 U270 ( .AN(TxDmaSize[0]), .B(TxFIFODataCnt[0]), .Y(n521) );
  CLKINVX1 U271 ( .A(RxFIFODataCnt[1]), .Y(n531) );
  CLKINVX1 U272 ( .A(TXRD), .Y(n522) );
  AOI2BB1X1 U273 ( .A0N(RxDmaSize[1]), .A1N(RxDmaSize[0]), .B0(n525), .Y(n528)
         );
  CLKINVX1 U274 ( .A(RxFIFODataCnt[0]), .Y(n532) );
  CLKINVX1 U275 ( .A(RxDmaSize[0]), .Y(n533) );
  AO22X1 U276 ( .A0(TxFIFOWrDataCpu[31]), .A1(n554), .B0(TXD[31]), .B1(n515), 
        .Y(TxFIFOWrData_31_) );
  AO22X1 U277 ( .A0(TxFIFOWrDataCpu[30]), .A1(n554), .B0(TXD[30]), .B1(n515), 
        .Y(TxFIFOWrData_30_) );
  AO22X1 U278 ( .A0(TxFIFOWrDataCpu[29]), .A1(n554), .B0(TXD[29]), .B1(n515), 
        .Y(TxFIFOWrData_29_) );
  AO22X1 U279 ( .A0(TxFIFOWrDataCpu[28]), .A1(n554), .B0(TXD[28]), .B1(n515), 
        .Y(TxFIFOWrData_28_) );
  AO22X1 U280 ( .A0(TxFIFOWrDataCpu[27]), .A1(n554), .B0(TXD[27]), .B1(n515), 
        .Y(TxFIFOWrData_27_) );
  AO22X1 U281 ( .A0(TxFIFOWrDataCpu[26]), .A1(n554), .B0(TXD[26]), .B1(n515), 
        .Y(TxFIFOWrData_26_) );
  AO22X1 U282 ( .A0(TxFIFOWrDataCpu[25]), .A1(n554), .B0(TXD[25]), .B1(n515), 
        .Y(TxFIFOWrData_25_) );
  AO22X1 U283 ( .A0(TxFIFOWrDataCpu[24]), .A1(n554), .B0(TXD[24]), .B1(n515), 
        .Y(TxFIFOWrData_24_) );
  AO22X1 U284 ( .A0(TxFIFOWrDataCpu[23]), .A1(n554), .B0(TXD[23]), .B1(n515), 
        .Y(TxFIFOWrData_23_) );
  AO22X1 U285 ( .A0(TxFIFOWrDataCpu[22]), .A1(n554), .B0(TXD[22]), .B1(n515), 
        .Y(TxFIFOWrData_22_) );
  AO22X1 U286 ( .A0(TxFIFOWrDataCpu[21]), .A1(n554), .B0(TXD[21]), .B1(n515), 
        .Y(TxFIFOWrData_21_) );
  AO22X1 U287 ( .A0(TxFIFOWrDataCpu[20]), .A1(n554), .B0(TXD[20]), .B1(n515), 
        .Y(TxFIFOWrData_20_) );
  AO22X1 U288 ( .A0(TxFIFOWrDataCpu[19]), .A1(n554), .B0(TXD[19]), .B1(n515), 
        .Y(TxFIFOWrData_19_) );
  AO22X1 U289 ( .A0(TxFIFOWrDataCpu[18]), .A1(n554), .B0(TXD[18]), .B1(n515), 
        .Y(TxFIFOWrData_18_) );
  AO22X1 U290 ( .A0(TxFIFOWrDataCpu[17]), .A1(n554), .B0(TXD[17]), .B1(n515), 
        .Y(TxFIFOWrData_17_) );
  AO22X1 U291 ( .A0(TxFIFOWrDataCpu[16]), .A1(n554), .B0(TXD[16]), .B1(n515), 
        .Y(TxFIFOWrData_16_) );
  AO22X1 U292 ( .A0(TxFIFOWrDataCpu[15]), .A1(n554), .B0(TXD[15]), .B1(n515), 
        .Y(TxFIFOWrData_15_) );
  AO22X1 U293 ( .A0(TxFIFOWrDataCpu[14]), .A1(n554), .B0(TXD[14]), .B1(n515), 
        .Y(TxFIFOWrData_14_) );
  AO22X1 U294 ( .A0(TxFIFOWrDataCpu[13]), .A1(n554), .B0(TXD[13]), .B1(n515), 
        .Y(TxFIFOWrData_13_) );
  AO22X1 U295 ( .A0(TxFIFOWrDataCpu[12]), .A1(n554), .B0(TXD[12]), .B1(n515), 
        .Y(TxFIFOWrData_12_) );
  AO22X1 U296 ( .A0(TxFIFOWrDataCpu[11]), .A1(n554), .B0(TXD[11]), .B1(n515), 
        .Y(TxFIFOWrData_11_) );
  AO22X1 U297 ( .A0(TxFIFOWrDataCpu[10]), .A1(n554), .B0(TXD[10]), .B1(n515), 
        .Y(TxFIFOWrData_10_) );
  AO22X1 U298 ( .A0(n554), .A1(TxFIFOWrDataCpu[9]), .B0(TXD[9]), .B1(n515), 
        .Y(TxFIFOWrData_9_) );
  AO22X1 U299 ( .A0(TxFIFOWrDataCpu[8]), .A1(n554), .B0(TXD[8]), .B1(n515), 
        .Y(TxFIFOWrData_8_) );
  AO22X1 U300 ( .A0(TxFIFOWrDataCpu[7]), .A1(n554), .B0(TXD[7]), .B1(n515), 
        .Y(TxFIFOWrData_7_) );
  AO22X1 U301 ( .A0(TxFIFOWrDataCpu[6]), .A1(n554), .B0(TXD[6]), .B1(n515), 
        .Y(TxFIFOWrData_6_) );
  AO22X1 U302 ( .A0(TxFIFOWrDataCpu[5]), .A1(n554), .B0(TXD[5]), .B1(n515), 
        .Y(TxFIFOWrData_5_) );
  AO22X1 U303 ( .A0(TxFIFOWrDataCpu[4]), .A1(n554), .B0(TXD[4]), .B1(n515), 
        .Y(TxFIFOWrData_4_) );
  AO22X1 U304 ( .A0(TxFIFOWrDataCpu[3]), .A1(n554), .B0(TXD[3]), .B1(n515), 
        .Y(TxFIFOWrData_3_) );
  AO22X1 U305 ( .A0(TxFIFOWrDataCpu[2]), .A1(n554), .B0(TXD[2]), .B1(n515), 
        .Y(TxFIFOWrData_2_) );
  AO22X1 U306 ( .A0(TxFIFOWrDataCpu[1]), .A1(n554), .B0(TXD[1]), .B1(n515), 
        .Y(TxFIFOWrData_1_) );
  AO22X1 U307 ( .A0(TxFIFOWrDataCpu[0]), .A1(n554), .B0(TXD[0]), .B1(n515), 
        .Y(TxFIFOWrData_0_) );
  CLKINVX1 U308 ( .A(TxDmaSize[2]), .Y(n517) );
  AND2X2 U309 ( .A(RxDmaSize[2]), .B(RxFIFODataCnt[2]), .Y(n553) );
  CLKINVX1 U310 ( .A(TxDmaSize[1]), .Y(n520) );
  CLKINVX1 U311 ( .A(RXRDY), .Y(n542) );
  DFFRX1 CurStR_reg_2_ ( .D(NxtStR[2]), .CK(PCLK), .RN(PRESETB), .Q(RXWE), 
        .QN(n547) );
  DFFRX1 CurStT_reg_2_ ( .D(NxtStT[2]), .CK(PCLK), .RN(PRESETB), .Q(TXRDY), 
        .QN(n548) );
  DFFSX1 CurStT_reg_0_ ( .D(NxtStT[0]), .CK(PCLK), .SN(PRESETB), .Q(tTIdle), 
        .QN(n549) );
  DFFSX1 CurStR_reg_0_ ( .D(NxtStR[0]), .CK(PCLK), .SN(PRESETB), .Q(tRIdle), 
        .QN(n550) );
  DFFRX1 CurStT_reg_1_ ( .D(NxtStT[1]), .CK(PCLK), .RN(PRESETB), .Q(tTSync), 
        .QN(n551) );
  DFFRX1 CurStR_reg_1_ ( .D(NxtStR[1]), .CK(PCLK), .RN(PRESETB), .Q(tRSync), 
        .QN(n552) );
endmodule


module PcmFIFO_FIFO_AW3_FIFO_DW32_0 ( Clk, nRST, FIFOWrite, FIFOWrData, 
        FIFORead, FIFORdData, FIFOFlush, FIFOFull, FIFOHalfFull, 
        FIFOAlmostEmpty, FIFOEmpty, FIFOEmptyWr, FIFODataCnt );
  input [31:0] FIFOWrData;
  output [31:0] FIFORdData;
  output [2:0] FIFODataCnt;
  input Clk, nRST, FIFOWrite, FIFORead, FIFOFlush;
  output FIFOFull, FIFOHalfFull, FIFOAlmostEmpty, FIFOEmpty, FIFOEmptyWr;
  wire   WriteAllow, FIFO88, FIFO880, FIFO881, FIFO882, FIFO883, FIFO884,
         FIFO885, FIFO886, FIFO887, FIFO888, FIFO889, FIFO8810, FIFO8811,
         FIFO8812, FIFO8813, FIFO8814, FIFO8815, FIFO8816, FIFO8817, FIFO8818,
         FIFO8819, FIFO8820, FIFO8821, FIFO8822, FIFO8823, FIFO8824, FIFO8825,
         FIFO8826, FIFO8827, FIFO8828, FIFO8829, FIFO8830, FIFO8831, FIFO8832,
         FIFO8833, FIFO8834, FIFO8835, FIFO8836, FIFO8837, FIFO8838, FIFO8839,
         FIFO8840, FIFO8841, FIFO8842, FIFO8843, FIFO8844, FIFO8845, FIFO8846,
         FIFO8847, FIFO8848, FIFO8849, FIFO8850, FIFO8851, FIFO8852, FIFO8853,
         FIFO8854, FIFO8855, FIFO8856, FIFO8857, FIFO8858, FIFO8859, FIFO8860,
         FIFO8861, FIFO8862, FIFO8863, FIFO8864, FIFO8865, FIFO8866, FIFO8867,
         FIFO8868, FIFO8869, FIFO8870, FIFO8871, FIFO8872, FIFO8873, FIFO8874,
         FIFO8875, FIFO8876, FIFO8877, FIFO8878, FIFO8879, FIFO8880, FIFO8881,
         FIFO8882, FIFO8883, FIFO8884, FIFO8885, FIFO8886, FIFO8887, FIFO8888,
         FIFO8889, FIFO8890, FIFO8891, FIFO8892, FIFO8893, FIFO8894, FIFO8895,
         FIFO8896, FIFO8897, FIFO8898, FIFO8899, FIFO88100, FIFO88101,
         FIFO88102, FIFO88103, FIFO88104, FIFO88105, FIFO88106, FIFO88107,
         FIFO88108, FIFO88109, FIFO88110, FIFO88111, FIFO88112, FIFO88113,
         FIFO88114, FIFO88115, FIFO88116, FIFO88117, FIFO88118, FIFO88119,
         FIFO88120, FIFO88121, FIFO88122, FIFO88123, FIFO88124, FIFO88125,
         FIFO88126, FIFO88127, FIFO88128, FIFO88129, FIFO88130, FIFO88131,
         FIFO88132, FIFO88133, FIFO88134, FIFO88135, FIFO88136, FIFO88137,
         FIFO88138, FIFO88139, FIFO88140, FIFO88141, FIFO88142, FIFO88143,
         FIFO88144, FIFO88145, FIFO88146, FIFO88147, FIFO88148, FIFO88149,
         FIFO88150, FIFO88151, FIFO88152, FIFO88153, FIFO88154, FIFO88155,
         FIFO88156, FIFO88157, FIFO88158, FIFO88159, FIFO88160, FIFO88161,
         FIFO88162, FIFO88163, FIFO88164, FIFO88165, FIFO88166, FIFO88167,
         FIFO88168, FIFO88169, FIFO88170, FIFO88171, FIFO88172, FIFO88173,
         FIFO88174, FIFO88175, FIFO88176, FIFO88177, FIFO88178, FIFO88179,
         FIFO88180, FIFO88181, FIFO88182, FIFO88183, FIFO88184, FIFO88185,
         FIFO88186, FIFO88187, FIFO88188, FIFO88189, FIFO88190, FIFO88191,
         FIFO88192, FIFO88193, FIFO88194, FIFO88195, FIFO88196, FIFO88197,
         FIFO88198, FIFO88199, FIFO88200, FIFO88201, FIFO88202, FIFO88203,
         FIFO88204, FIFO88205, FIFO88206, FIFO88207, FIFO88208, FIFO88209,
         FIFO88210, FIFO88211, FIFO88212, FIFO88213, FIFO88214, FIFO88215,
         FIFO88216, FIFO88217, FIFO88218, FIFO88219, FIFO88220, FIFO88221,
         FIFO88222, FIFO88223, FIFO88224, FIFO88225, FIFO88226, FIFO88227,
         FIFO88228, FIFO88229, FIFO88230, FIFO88231, FIFO88232, FIFO88233,
         FIFO88234, FIFO88235, FIFO88236, FIFO88237, FIFO88238, FIFO88239,
         FIFO88240, FIFO88241, FIFO88242, FIFO88243, FIFO88244, FIFO88245,
         FIFO88246, FIFO88247, FIFO88248, FIFO88249, FIFO88250, FIFO88251,
         FIFO88252, FIFO88253, FIFO88254, FIFORdData486_31_, FIFORdData486_30_,
         FIFORdData486_29_, FIFORdData486_28_, FIFORdData486_27_,
         FIFORdData486_26_, FIFORdData486_25_, FIFORdData486_24_,
         FIFORdData486_23_, FIFORdData486_22_, FIFORdData486_21_,
         FIFORdData486_20_, FIFORdData486_19_, FIFORdData486_18_,
         FIFORdData486_17_, FIFORdData486_16_, FIFORdData486_15_,
         FIFORdData486_14_, FIFORdData486_13_, FIFORdData486_12_,
         FIFORdData486_11_, FIFORdData486_10_, FIFORdData486_9_,
         FIFORdData486_8_, FIFORdData486_7_, FIFORdData486_6_,
         FIFORdData486_5_, FIFORdData486_4_, FIFORdData486_3_,
         FIFORdData486_2_, FIFORdData486_1_, FIFORdData486_0_, n1215, n1218,
         n1220, n1222, n1224, n1226, n1228, n1230, n1233, n1235, n1244, n1247,
         n1256, n1259, n1268, n1271, n1280, n1283, n1292, n1295, n1304, n1307,
         n1316, n1319, n1328, n1331, n1340, n1343, n1352, n1355, n1364, n1367,
         n1376, n1379, n1388, n1391, n1400, n1403, n1412, n1415, n1424, n1427,
         n1436, n1439, n1448, n1451, n1460, n1463, n1472, n1475, n1484, n1487,
         n1496, n1499, n1508, n1511, n1520, n1523, n1532, n1535, n1544, n1547,
         n1556, n1559, n1568, n1571, n1580, n1583, n1592, n1595, n1600, n1605,
         n1608, n1609, n1610, n1611, n1613, n1614, n1616, n1618, n1620, n1622,
         n1624, n1626, n1628, n1630, n1632, n1634, n1636, n1638, n1640, n1642,
         n1644, n1646, n1648, n1650, n1652, n1654, n1656, n1658, n1660, n1662,
         n1664, n1666, n1668, n1670, n1672, n1674, n1676, n1677, n1678, n1679,
         n1680, n1681, n1682, n1683, n1684, n1685, n1686, n1687, n1688, n1689,
         n1690, n1691, n1692, n1693, n1694, n1695, n1696, n1697, n1698, n1699,
         n1700, n1701, n1702, n1703, n1704, n1706, n1709, n1710, n1712, n1715,
         n1717, n1720, n1722, n1725, n1727, n1730, n1732, n1735, n1737, n1740,
         n1742, n1745, n1747, n1750, n1752, n1755, n1757, n1760, n1762, n1765,
         n1767, n1770, n1772, n1775, n1777, n1780, n1782, n1785, n1787, n1790,
         n1792, n1795, n1797, n1800, n1802, n1805, n1807, n1810, n1812, n1815,
         n1817, n1820, n1822, n1825, n1827, n1830, n1832, n1835, n1837, n1840,
         n1842, n1845, n1847, n1850, n1852, n1855, n1857, n1860, n1862, n1865,
         n1866, n1867, n2124, n2125, n2126, n2127, n2128, n2129, n2130, n2131,
         n2132, n2133, n2134, n2135, n2136, n2137, n2138, n2139, n2140, n2141,
         n2142, n2143, n2144, n2145, n2146, n2147, n2148, n2149, n2150, n2151,
         n2152, n2153, n2154, n2155, n2156, n2157, n2158, n2159, n2160, n2161,
         n2162, n2163, n2164, n2165, n2166, n2167, n2168, n2169, n2170, n2171,
         n2172, n2173, n2174, n2175, n2176, n2177, n2178, n2179, n2180, n2181,
         n2182, n2183, n2184, n2185, n2186, n2187, n2188, n2189, n2190, n2191,
         n2192, n2193, n2194, n2195, n2196, n2197, n2198, n2199, n2200, n2201,
         n2202, n2203, n2204, n2205, n2206, n2207, n2208, n2209, n2210, n2211,
         n2212, n2213, n2214, n2215, n2216, n2217, n2218, n2219, n2220, n2221,
         n2222, n2223, n2224, n2225, n2226, n2227, n2228, n2229, n2230, n2231,
         n2232, n2233, n2234, n2235, n2236, n2237, n2238, n2239, n2240, n2241,
         n2242, n2243, n2244, n2245, n2246, n2247, n2248, n2249, n2250, n2251,
         n2252, n2253, n2254, n2255, n2256, n2257, n2258, n2259, n2260, n2261,
         n2262, n2263, n2264, n2265, n2266, n2267, n2268, n2269, n2270, n2271,
         n2272, n2273, n2274, n2275, n2276, n2277, n2278, n2279, n2280, n2281,
         n2282, n2283, n2284, n2285, n2286, n2287, n2288, n2289, n2290, n2291,
         n2292, n2293, n2294, n2295, n2296, n2297, n2298, n2299, n2300, n2301,
         n2302, n2303, n2304, n2305, n2306, n2307, n2308, n2309, n2310, n2311,
         n2312, n2313, n2314, n2315, n2316, n2317, n2318, n2319, n2320, n2321,
         n2322, n2323, n2324, n2325, n2326, n2327, n2328, n2329, n2330, n2331,
         n2332, n2333, n2334, n2335, n2336, n2337, n2338, n2339, n2340, n2341,
         n2342, n2343, n2344, n2345, n2346, n2347, n2348, n2349, n2350, n2351,
         n2352, n2353, n2354, n2355, n2356, n2357, n2358, n2359, n2360, n2361,
         n2362, n2363, n2364, n2365, n2366, n2367, n2368, n2369, n2370, n2371,
         n2372, n2373, n2374, n2375, n2376, n2377, n2378, n2379, n2380, n2381,
         n2382, n2383, n2384, n2385, n2386, n2387, n2388, n2389, n2390, n2391,
         n2392, n2393, n2394, n2395, n2396, n2397, n2398, n2399, n2400, n2401,
         n2402, n2403, n2404, n2405, n2406, n2407, n2408, n2409, n2410, n2411,
         n2412, n2413, n2414, n2415, n2416, n2417, n2418, n2419, n2420, n2421,
         n2422, n2423, n2424, n2425, n2426, n2427, n2428, n2429, n2430, n2431,
         n2432, n2433, n2434, n2435, n2436, n2437, n2438, n2439, n2440, n2441,
         n2442, n2443, n2444, n2445, n2446, n2447, n2448, n2449, n2450, n2451,
         n2452, n2453, n2454, n2455, n2456, n2457, n2458, n2459, n2460, n2461,
         n2462, n2463, n2464, n2465, n2466, n2467, n2468, n2469, n2470, n2471,
         n2472, n2473, n2474, n2475, n2476, n2477, n2478, n2479, n2480, n2481,
         n2482, n2483, n2484, n2485, n2486, n2487, n2488, n2489, n2490, n2491,
         n2492, n2493, n2494, n2495, n2496, n2497, n2498, n2499, n2500, n2501,
         n2502, n2503, n2504, n2505, n2506, n2507, n2508, n2509, n2510, n2511,
         n2512, n2513, n2514, n2515, n2516, n2517, n2518, n2519, n2520, n2521,
         n2522, n2523, n2524, n2525, n2526, n2527, n2528, n2529, n2530, n2531,
         n2532, n2533, n2534, n2535, n2536, n2537, n2538, n2539, n2540, n2541,
         n2542, n2543, n2544, n2545, n2546, n2547, n2548, n2549, n2550, n2551,
         n2552, n2553, n2554, n2555, n2556, n2557, n2558, n2559, n2560, n2561,
         n2562, n2563, n2564, n2565, n2566, n2567, n2568, n2569, n2570, n2571,
         n2572, n2573, n2574, n2575, n2576, n2577, n2578, n2579, n2580, n2581,
         n2582, n2583, n2584, n2585, n2586, n2587, n2588, n2589, n2590, n2591,
         n2592, n2593, n2594, n2595, n2596, n2597, n2598, n2599, n2600, n2601,
         n2602;
  wire   [2:0] ReadAddr;
  wire   [2:0] WriteAddr;

  PcmFIFOCtl_AW3_0 FIFOCtl ( .Clki(Clk), .ReadEni(FIFORead), .WriteEni(
        FIFOWrite), .nRST(nRST), .Flushi(FIFOFlush), .DataCnt(FIFODataCnt), 
        .Fullo(FIFOFull), .FIFOHalfFull(FIFOHalfFull), .AlmostEmptyo(
        FIFOAlmostEmpty), .Emptyo(FIFOEmpty), .EmptyWrSideo(FIFOEmptyWr), 
        .WriteAddro(WriteAddr), .ReadAddro(ReadAddr), .WriteAllowo(WriteAllow)
         );
  NAND3BXL U1755 ( .AN(n2542), .B(n2540), .C(n2541), .Y(n2595) );
  NAND3BX1 U1756 ( .AN(n2542), .B(n1608), .C(n1600), .Y(n2597) );
  NAND3BX1 U1757 ( .AN(n2542), .B(n1608), .C(n1600), .Y(n2596) );
  NAND3BX1 U1758 ( .AN(n1600), .B(n2541), .C(n2542), .Y(n2600) );
  NAND3BX1 U1759 ( .AN(n1600), .B(n2541), .C(n2542), .Y(n1224) );
  NAND3BX1 U1760 ( .AN(n2541), .B(n2540), .C(n2542), .Y(n1220) );
  NAND3BX1 U1761 ( .AN(n2541), .B(n2540), .C(n2542), .Y(n2602) );
  NAND3BX1 U1762 ( .AN(n2541), .B(n1600), .C(n2542), .Y(n1218) );
  NAND3BX1 U1763 ( .AN(n2541), .B(n1600), .C(n2542), .Y(n2601) );
  INVX3 U1764 ( .A(n2540), .Y(n1600) );
  INVX1 U1765 ( .A(n2541), .Y(n1608) );
  NAND3BX1 U1766 ( .AN(n2542), .B(n1608), .C(n2540), .Y(n2598) );
  OR3X2 U1767 ( .A(n1283), .B(n2426), .C(n2427), .Y(FIFORdData486_4_) );
  OR3X2 U1768 ( .A(n1595), .B(n2380), .C(n2381), .Y(FIFORdData486_0_) );
  OR3X2 U1769 ( .A(n1271), .B(n2386), .C(n2387), .Y(FIFORdData486_5_) );
  OR3X2 U1770 ( .A(n1259), .B(n2388), .C(n2389), .Y(FIFORdData486_6_) );
  DFFQXL FIFORdData_reg_1_ ( .D(FIFORdData486_1_), .CK(Clk), .Q(FIFORdData[1])
         );
  DFFQXL FIFORdData_reg_3_ ( .D(FIFORdData486_3_), .CK(Clk), .Q(FIFORdData[3])
         );
  DFFQXL FIFORdData_reg_2_ ( .D(FIFORdData486_2_), .CK(Clk), .Q(FIFORdData[2])
         );
  DFFQXL FIFORdData_reg_7_ ( .D(FIFORdData486_7_), .CK(Clk), .Q(FIFORdData[7])
         );
  DFFQXL FIFORdData_reg_8_ ( .D(FIFORdData486_8_), .CK(Clk), .Q(FIFORdData[8])
         );
  DFFQXL FIFORdData_reg_9_ ( .D(FIFORdData486_9_), .CK(Clk), .Q(FIFORdData[9])
         );
  DFFQXL FIFORdData_reg_10_ ( .D(FIFORdData486_10_), .CK(Clk), .Q(
        FIFORdData[10]) );
  DFFQXL FIFORdData_reg_11_ ( .D(FIFORdData486_11_), .CK(Clk), .Q(
        FIFORdData[11]) );
  DFFQXL FIFORdData_reg_12_ ( .D(FIFORdData486_12_), .CK(Clk), .Q(
        FIFORdData[12]) );
  DFFQXL FIFORdData_reg_13_ ( .D(FIFORdData486_13_), .CK(Clk), .Q(
        FIFORdData[13]) );
  DFFQXL FIFORdData_reg_14_ ( .D(FIFORdData486_14_), .CK(Clk), .Q(
        FIFORdData[14]) );
  DFFQXL FIFORdData_reg_15_ ( .D(FIFORdData486_15_), .CK(Clk), .Q(
        FIFORdData[15]) );
  DFFQXL FIFORdData_reg_16_ ( .D(FIFORdData486_16_), .CK(Clk), .Q(
        FIFORdData[16]) );
  DFFQXL FIFORdData_reg_17_ ( .D(FIFORdData486_17_), .CK(Clk), .Q(
        FIFORdData[17]) );
  DFFQXL FIFORdData_reg_18_ ( .D(FIFORdData486_18_), .CK(Clk), .Q(
        FIFORdData[18]) );
  DFFQXL FIFORdData_reg_19_ ( .D(FIFORdData486_19_), .CK(Clk), .Q(
        FIFORdData[19]) );
  DFFQXL FIFORdData_reg_20_ ( .D(FIFORdData486_20_), .CK(Clk), .Q(
        FIFORdData[20]) );
  DFFQXL FIFORdData_reg_21_ ( .D(FIFORdData486_21_), .CK(Clk), .Q(
        FIFORdData[21]) );
  DFFQXL FIFORdData_reg_22_ ( .D(FIFORdData486_22_), .CK(Clk), .Q(
        FIFORdData[22]) );
  DFFQXL FIFORdData_reg_23_ ( .D(FIFORdData486_23_), .CK(Clk), .Q(
        FIFORdData[23]) );
  DFFQXL FIFORdData_reg_24_ ( .D(FIFORdData486_24_), .CK(Clk), .Q(
        FIFORdData[24]) );
  DFFQXL FIFORdData_reg_25_ ( .D(FIFORdData486_25_), .CK(Clk), .Q(
        FIFORdData[25]) );
  DFFQXL FIFORdData_reg_26_ ( .D(FIFORdData486_26_), .CK(Clk), .Q(
        FIFORdData[26]) );
  DFFQXL FIFORdData_reg_27_ ( .D(FIFORdData486_27_), .CK(Clk), .Q(
        FIFORdData[27]) );
  DFFQXL FIFORdData_reg_28_ ( .D(FIFORdData486_28_), .CK(Clk), .Q(
        FIFORdData[28]) );
  DFFQXL FIFORdData_reg_29_ ( .D(FIFORdData486_29_), .CK(Clk), .Q(
        FIFORdData[29]) );
  DFFQXL FIFORdData_reg_30_ ( .D(FIFORdData486_30_), .CK(Clk), .Q(
        FIFORdData[30]) );
  DFFQXL FIFORdData_reg_31_ ( .D(FIFORdData486_31_), .CK(Clk), .Q(
        FIFORdData[31]) );
  CLKINVX1 U1771 ( .A(n1689), .Y(n1687) );
  CLKINVX1 U1772 ( .A(WriteAllow), .Y(n1676) );
  CLKINVX1 U1773 ( .A(n1677), .Y(n1611) );
  CLKINVX1 U1774 ( .A(n1710), .Y(n1702) );
  NAND3BXL U1775 ( .AN(n2540), .B(n2541), .C(n2542), .Y(n2599) );
  NAND3BXL U1776 ( .AN(n2540), .B(n2541), .C(n2542), .Y(n1222) );
  NAND3BXL U1777 ( .AN(n2542), .B(n1608), .C(n2540), .Y(n1233) );
  OAI22XL U1778 ( .A0(n2599), .A1(n2187), .B0(n2600), .B1(n2251), .Y(n2380) );
  OAI22XL U1779 ( .A0(n2601), .A1(n2219), .B0(n1220), .B1(n2347), .Y(n2381) );
  OR3XL U1780 ( .A(n1331), .B(n2382), .C(n2383), .Y(FIFORdData486_2_) );
  OAI22XL U1781 ( .A0(n2599), .A1(n2169), .B0(n2600), .B1(n2234), .Y(n2382) );
  OAI22XL U1782 ( .A0(n1218), .A1(n2201), .B0(n2602), .B1(n2329), .Y(n2383) );
  OR3XL U1783 ( .A(n1295), .B(n2384), .C(n2385), .Y(FIFORdData486_3_) );
  OAI22XL U1784 ( .A0(n1222), .A1(n2168), .B0(n2600), .B1(n2233), .Y(n2384) );
  OAI22XL U1785 ( .A0(n1218), .A1(n2200), .B0(n2602), .B1(n2328), .Y(n2385) );
  OAI22XL U1786 ( .A0(n2599), .A1(n2184), .B0(n1224), .B1(n2249), .Y(n2386) );
  OAI22XL U1787 ( .A0(n2601), .A1(n2216), .B0(n2602), .B1(n2344), .Y(n2387) );
  OAI22XL U1788 ( .A0(n1222), .A1(n2167), .B0(n2600), .B1(n2232), .Y(n2388) );
  OAI22XL U1789 ( .A0(n2601), .A1(n2199), .B0(n2602), .B1(n2327), .Y(n2389) );
  OR3XL U1790 ( .A(n1235), .B(n2390), .C(n2391), .Y(FIFORdData486_8_) );
  OAI22XL U1791 ( .A0(n2599), .A1(n2183), .B0(n2600), .B1(n2248), .Y(n2390) );
  OAI22XL U1792 ( .A0(n2601), .A1(n2215), .B0(n1220), .B1(n2343), .Y(n2391) );
  OR3XL U1793 ( .A(n1215), .B(n2392), .C(n2393), .Y(FIFORdData486_9_) );
  OAI22XL U1794 ( .A0(n1222), .A1(n2165), .B0(n2600), .B1(n2230), .Y(n2392) );
  OAI22XL U1795 ( .A0(n1218), .A1(n2197), .B0(n2602), .B1(n2325), .Y(n2393) );
  OR3XL U1796 ( .A(n1583), .B(n2394), .C(n2395), .Y(FIFORdData486_10_) );
  OAI22XL U1797 ( .A0(n2599), .A1(n2164), .B0(n2600), .B1(n2229), .Y(n2394) );
  OAI22XL U1798 ( .A0(n1218), .A1(n2196), .B0(n2602), .B1(n2324), .Y(n2395) );
  OR3XL U1799 ( .A(n1559), .B(n2396), .C(n2397), .Y(FIFORdData486_12_) );
  OAI22XL U1800 ( .A0(n2599), .A1(n2181), .B0(n1224), .B1(n2247), .Y(n2396) );
  OAI22XL U1801 ( .A0(n2601), .A1(n2213), .B0(n2602), .B1(n2341), .Y(n2397) );
  OR3XL U1802 ( .A(n1547), .B(n2398), .C(n2399), .Y(FIFORdData486_13_) );
  OAI22XL U1803 ( .A0(n1222), .A1(n2163), .B0(n2600), .B1(n2228), .Y(n2398) );
  OAI22XL U1804 ( .A0(n2601), .A1(n2195), .B0(n2602), .B1(n2323), .Y(n2399) );
  OR3XL U1805 ( .A(n1523), .B(n2400), .C(n2401), .Y(FIFORdData486_15_) );
  OAI22XL U1806 ( .A0(n2599), .A1(n2179), .B0(n1224), .B1(n2246), .Y(n2400) );
  OAI22XL U1807 ( .A0(n2601), .A1(n2211), .B0(n2602), .B1(n2339), .Y(n2401) );
  OR3XL U1808 ( .A(n1511), .B(n2402), .C(n2403), .Y(FIFORdData486_16_) );
  OAI22XL U1809 ( .A0(n2599), .A1(n2162), .B0(n2600), .B1(n2227), .Y(n2402) );
  OAI22XL U1810 ( .A0(n2601), .A1(n2194), .B0(n2602), .B1(n2322), .Y(n2403) );
  OR3XL U1811 ( .A(n1487), .B(n2404), .C(n2405), .Y(FIFORdData486_18_) );
  OAI22XL U1812 ( .A0(n2599), .A1(n2177), .B0(n2600), .B1(n2245), .Y(n2404) );
  OAI22XL U1813 ( .A0(n2601), .A1(n2209), .B0(n1220), .B1(n2337), .Y(n2405) );
  OR3XL U1814 ( .A(n1475), .B(n2406), .C(n2407), .Y(FIFORdData486_19_) );
  OAI22XL U1815 ( .A0(n1222), .A1(n2161), .B0(n2600), .B1(n2226), .Y(n2406) );
  OAI22XL U1816 ( .A0(n2601), .A1(n2193), .B0(n2602), .B1(n2321), .Y(n2407) );
  OR3XL U1817 ( .A(n1451), .B(n2408), .C(n2409), .Y(FIFORdData486_20_) );
  OAI22XL U1818 ( .A0(n2599), .A1(n2176), .B0(n1224), .B1(n2244), .Y(n2408) );
  OAI22XL U1819 ( .A0(n2601), .A1(n2208), .B0(n2602), .B1(n2336), .Y(n2409) );
  OR3XL U1820 ( .A(n1439), .B(n2410), .C(n2411), .Y(FIFORdData486_21_) );
  OAI22XL U1821 ( .A0(n2599), .A1(n2160), .B0(n2600), .B1(n2225), .Y(n2410) );
  OAI22XL U1822 ( .A0(n1218), .A1(n2192), .B0(n2602), .B1(n2320), .Y(n2411) );
  OR3XL U1823 ( .A(n1415), .B(n2412), .C(n2413), .Y(FIFORdData486_23_) );
  OAI22XL U1824 ( .A0(n2599), .A1(n2174), .B0(n2600), .B1(n2243), .Y(n2412) );
  OAI22XL U1825 ( .A0(n2601), .A1(n2206), .B0(n1220), .B1(n2334), .Y(n2413) );
  OR3XL U1826 ( .A(n1403), .B(n2414), .C(n2415), .Y(FIFORdData486_24_) );
  OAI22XL U1827 ( .A0(n2599), .A1(n2159), .B0(n2600), .B1(n2223), .Y(n2414) );
  OAI22XL U1828 ( .A0(n1218), .A1(n2191), .B0(n2602), .B1(n2319), .Y(n2415) );
  OR3XL U1829 ( .A(n1379), .B(n2416), .C(n2417), .Y(FIFORdData486_26_) );
  OAI22XL U1830 ( .A0(n2599), .A1(n2173), .B0(n2600), .B1(n2242), .Y(n2416) );
  OAI22XL U1831 ( .A0(n2601), .A1(n2205), .B0(n1220), .B1(n2333), .Y(n2417) );
  OR3XL U1832 ( .A(n1367), .B(n2418), .C(n2419), .Y(FIFORdData486_27_) );
  OAI22XL U1833 ( .A0(n1222), .A1(n2157), .B0(n2600), .B1(n2221), .Y(n2418) );
  OAI22XL U1834 ( .A0(n2601), .A1(n2189), .B0(n2602), .B1(n2317), .Y(n2419) );
  OR3XL U1835 ( .A(n1343), .B(n2420), .C(n2421), .Y(FIFORdData486_29_) );
  OAI22XL U1836 ( .A0(n2599), .A1(n2171), .B0(n1224), .B1(n2240), .Y(n2420) );
  OAI22XL U1837 ( .A0(n2601), .A1(n2203), .B0(n2602), .B1(n2331), .Y(n2421) );
  OR3XL U1838 ( .A(n1307), .B(n2422), .C(n2423), .Y(FIFORdData486_31_) );
  OAI22XL U1839 ( .A0(n2599), .A1(n2170), .B0(n2600), .B1(n2239), .Y(n2422) );
  OAI22XL U1840 ( .A0(n2601), .A1(n2202), .B0(n1220), .B1(n2330), .Y(n2423) );
  OR3XL U1841 ( .A(n1463), .B(n2424), .C(n2425), .Y(FIFORdData486_1_) );
  OAI22XL U1842 ( .A0(n1222), .A1(n2186), .B0(n1224), .B1(n2238), .Y(n2424) );
  OAI22XL U1843 ( .A0(n1218), .A1(n2218), .B0(n1220), .B1(n2346), .Y(n2425) );
  OAI22XL U1844 ( .A0(n1222), .A1(n2185), .B0(n1224), .B1(n2250), .Y(n2426) );
  OAI22XL U1845 ( .A0(n1218), .A1(n2217), .B0(n1220), .B1(n2345), .Y(n2427) );
  OR3XL U1846 ( .A(n1247), .B(n2428), .C(n2429), .Y(FIFORdData486_7_) );
  OAI22XL U1847 ( .A0(n1222), .A1(n2166), .B0(n1224), .B1(n2231), .Y(n2428) );
  OAI22XL U1848 ( .A0(n1218), .A1(n2198), .B0(n1220), .B1(n2326), .Y(n2429) );
  OR3XL U1849 ( .A(n1571), .B(n2430), .C(n2431), .Y(FIFORdData486_11_) );
  OAI22XL U1850 ( .A0(n1222), .A1(n2182), .B0(n1224), .B1(n2237), .Y(n2430) );
  OAI22XL U1851 ( .A0(n1218), .A1(n2214), .B0(n1220), .B1(n2342), .Y(n2431) );
  OR3XL U1852 ( .A(n1535), .B(n2432), .C(n2433), .Y(FIFORdData486_14_) );
  OAI22XL U1853 ( .A0(n1222), .A1(n2180), .B0(n1224), .B1(n2236), .Y(n2432) );
  OAI22XL U1854 ( .A0(n1218), .A1(n2212), .B0(n1220), .B1(n2340), .Y(n2433) );
  OR3XL U1855 ( .A(n1499), .B(n2434), .C(n2435), .Y(FIFORdData486_17_) );
  OAI22XL U1856 ( .A0(n1222), .A1(n2178), .B0(n1224), .B1(n2235), .Y(n2434) );
  OAI22XL U1857 ( .A0(n1218), .A1(n2210), .B0(n1220), .B1(n2338), .Y(n2435) );
  OR3XL U1858 ( .A(n1427), .B(n2436), .C(n2437), .Y(FIFORdData486_22_) );
  OAI22XL U1859 ( .A0(n1222), .A1(n2175), .B0(n1224), .B1(n2224), .Y(n2436) );
  OAI22XL U1860 ( .A0(n1218), .A1(n2207), .B0(n1220), .B1(n2335), .Y(n2437) );
  OR3XL U1861 ( .A(n1391), .B(n2438), .C(n2439), .Y(FIFORdData486_25_) );
  OAI22XL U1862 ( .A0(n1222), .A1(n2158), .B0(n1224), .B1(n2222), .Y(n2438) );
  OAI22XL U1863 ( .A0(n1218), .A1(n2190), .B0(n1220), .B1(n2318), .Y(n2439) );
  OR3XL U1864 ( .A(n1355), .B(n2440), .C(n2441), .Y(FIFORdData486_28_) );
  OAI22XL U1865 ( .A0(n1222), .A1(n2172), .B0(n1224), .B1(n2241), .Y(n2440) );
  OAI22XL U1866 ( .A0(n1218), .A1(n2204), .B0(n1220), .B1(n2332), .Y(n2441) );
  OR3XL U1867 ( .A(n1319), .B(n2442), .C(n2443), .Y(FIFORdData486_30_) );
  OAI22XL U1868 ( .A0(n1222), .A1(n2156), .B0(n1224), .B1(n2220), .Y(n2442) );
  OAI22XL U1869 ( .A0(n1218), .A1(n2188), .B0(n1220), .B1(n2316), .Y(n2443) );
  OA22XL U1870 ( .A0(n2597), .A1(n2379), .B0(n2598), .B1(n2283), .Y(n1605) );
  OA22XL U1871 ( .A0(n2596), .A1(n2362), .B0(n2598), .B1(n2266), .Y(n1340) );
  OA22XL U1872 ( .A0(n2596), .A1(n2361), .B0(n2598), .B1(n2265), .Y(n1304) );
  OA22XL U1873 ( .A0(n2597), .A1(n2377), .B0(n2598), .B1(n2281), .Y(n1280) );
  OA22XL U1874 ( .A0(n2596), .A1(n2360), .B0(n2598), .B1(n2264), .Y(n1268) );
  OA22XL U1875 ( .A0(n2597), .A1(n2376), .B0(n2598), .B1(n2280), .Y(n1244) );
  OA22XL U1876 ( .A0(n2596), .A1(n2359), .B0(n2598), .B1(n2262), .Y(n1230) );
  OA22XL U1877 ( .A0(n2596), .A1(n2358), .B0(n2598), .B1(n2261), .Y(n1592) );
  OA22XL U1878 ( .A0(n2597), .A1(n2375), .B0(n2598), .B1(n2279), .Y(n1568) );
  OA22XL U1879 ( .A0(n2596), .A1(n2357), .B0(n2598), .B1(n2260), .Y(n1556) );
  OA22XL U1880 ( .A0(n2597), .A1(n2374), .B0(n2598), .B1(n2278), .Y(n1532) );
  OA22XL U1881 ( .A0(n2596), .A1(n2356), .B0(n2598), .B1(n2259), .Y(n1520) );
  OA22XL U1882 ( .A0(n2597), .A1(n2373), .B0(n2598), .B1(n2277), .Y(n1496) );
  OA22XL U1883 ( .A0(n2596), .A1(n2355), .B0(n2598), .B1(n2258), .Y(n1484) );
  OA22XL U1884 ( .A0(n2597), .A1(n2372), .B0(n2598), .B1(n2276), .Y(n1460) );
  OA22XL U1885 ( .A0(n2596), .A1(n2354), .B0(n2598), .B1(n2257), .Y(n1448) );
  OA22XL U1886 ( .A0(n2597), .A1(n2371), .B0(n2598), .B1(n2275), .Y(n1424) );
  OA22XL U1887 ( .A0(n2596), .A1(n2353), .B0(n1233), .B1(n2255), .Y(n1412) );
  OA22XL U1888 ( .A0(n2597), .A1(n2370), .B0(n2598), .B1(n2274), .Y(n1388) );
  OA22XL U1889 ( .A0(n2596), .A1(n2352), .B0(n1233), .B1(n2253), .Y(n1376) );
  OA22XL U1890 ( .A0(n2597), .A1(n2368), .B0(n2598), .B1(n2272), .Y(n1352) );
  OA22XL U1891 ( .A0(n2597), .A1(n2367), .B0(n2598), .B1(n2271), .Y(n1316) );
  OA22XL U1892 ( .A0(n2597), .A1(n2366), .B0(n1233), .B1(n2270), .Y(n1472) );
  OA22XL U1893 ( .A0(n2597), .A1(n2378), .B0(n1233), .B1(n2282), .Y(n1292) );
  OA22XL U1894 ( .A0(n2597), .A1(n2351), .B0(n1233), .B1(n2263), .Y(n1256) );
  OA22XL U1895 ( .A0(n2596), .A1(n2365), .B0(n1233), .B1(n2269), .Y(n1580) );
  OA22XL U1896 ( .A0(n2597), .A1(n2364), .B0(n1233), .B1(n2268), .Y(n1544) );
  OA22XL U1897 ( .A0(n2596), .A1(n2363), .B0(n1233), .B1(n2267), .Y(n1508) );
  OA22XL U1898 ( .A0(n2597), .A1(n2350), .B0(n1233), .B1(n2256), .Y(n1436) );
  OA22XL U1899 ( .A0(n2596), .A1(n2349), .B0(n1233), .B1(n2254), .Y(n1400) );
  OA22XL U1900 ( .A0(n2596), .A1(n2369), .B0(n1233), .B1(n2273), .Y(n1364) );
  OA22XL U1901 ( .A0(n2596), .A1(n2348), .B0(n1233), .B1(n2252), .Y(n1328) );
  CLKINVX1 U1902 ( .A(n1681), .Y(n1679) );
  CLKINVX1 U1903 ( .A(n1693), .Y(n1691) );
  CLKINVX1 U1904 ( .A(n1685), .Y(n1683) );
  CLKINVX1 U1905 ( .A(n1697), .Y(n1695) );
  BUFX4 U1906 ( .A(ReadAddr[2]), .Y(n2542) );
  BUFX4 U1907 ( .A(ReadAddr[1]), .Y(n2541) );
  CLKINVX1 U1908 ( .A(n1701), .Y(n1699) );
  CLKINVX1 U1909 ( .A(WriteAddr[0]), .Y(n1865) );
  NAND2BX1 U1910 ( .AN(n1676), .B(n1702), .Y(n2547) );
  NAND2BX1 U1911 ( .AN(n1676), .B(n1702), .Y(n2548) );
  NAND2BX1 U1912 ( .AN(n1676), .B(n1687), .Y(n2577) );
  NAND2BX1 U1913 ( .AN(n1676), .B(n1687), .Y(n2578) );
  NAND2BX1 U1914 ( .AN(n1676), .B(n1702), .Y(n1703) );
  NAND2BX1 U1915 ( .AN(n1676), .B(n1611), .Y(n2589) );
  NAND2BX1 U1916 ( .AN(n1676), .B(n1611), .Y(n2590) );
  NAND2BX1 U1917 ( .AN(n1676), .B(n1687), .Y(n1686) );
  NAND2BX1 U1918 ( .AN(n1676), .B(n1611), .Y(n1609) );
  NAND2BX1 U1919 ( .AN(WriteAllow), .B(n1687), .Y(n2579) );
  NAND2BX1 U1920 ( .AN(WriteAllow), .B(n1687), .Y(n2580) );
  NAND2BX1 U1921 ( .AN(WriteAllow), .B(n1679), .Y(n2587) );
  NAND2BX1 U1922 ( .AN(WriteAllow), .B(n1679), .Y(n2588) );
  NAND2BX1 U1923 ( .AN(WriteAllow), .B(n1702), .Y(n2563) );
  NAND2BX1 U1924 ( .AN(WriteAllow), .B(n1702), .Y(n2564) );
  NAND2BX1 U1925 ( .AN(WriteAllow), .B(n1691), .Y(n2575) );
  NAND2BX1 U1926 ( .AN(WriteAllow), .B(n1691), .Y(n2576) );
  NAND2BX1 U1927 ( .AN(WriteAllow), .B(n1683), .Y(n2583) );
  NAND2BX1 U1928 ( .AN(WriteAllow), .B(n1683), .Y(n2584) );
  NAND2BX1 U1929 ( .AN(WriteAllow), .B(n1611), .Y(n2591) );
  NAND2BX1 U1930 ( .AN(WriteAllow), .B(n1611), .Y(n2592) );
  NAND2BX1 U1931 ( .AN(WriteAllow), .B(n1695), .Y(n2571) );
  NAND2BX1 U1932 ( .AN(WriteAllow), .B(n1695), .Y(n2572) );
  NAND2BX1 U1933 ( .AN(n1676), .B(n1679), .Y(n2585) );
  NAND2BX1 U1934 ( .AN(n1676), .B(n1679), .Y(n2586) );
  NAND2BX1 U1935 ( .AN(n1676), .B(n1691), .Y(n2573) );
  NAND2BX1 U1936 ( .AN(n1676), .B(n1691), .Y(n2574) );
  NAND2BX1 U1937 ( .AN(n1676), .B(n1683), .Y(n2581) );
  NAND2BX1 U1938 ( .AN(n1676), .B(n1683), .Y(n2582) );
  NAND2BX1 U1939 ( .AN(n1676), .B(n1695), .Y(n2569) );
  NAND2BX1 U1940 ( .AN(n1676), .B(n1695), .Y(n2570) );
  NAND2BX1 U1941 ( .AN(WriteAllow), .B(n1687), .Y(n1688) );
  NAND2BX1 U1942 ( .AN(WriteAllow), .B(n1679), .Y(n1680) );
  NAND2BX1 U1943 ( .AN(WriteAllow), .B(n1702), .Y(n1704) );
  NAND2BX1 U1944 ( .AN(WriteAllow), .B(n1691), .Y(n1692) );
  NAND2BX1 U1945 ( .AN(WriteAllow), .B(n1683), .Y(n1684) );
  NAND2BX1 U1946 ( .AN(WriteAllow), .B(n1611), .Y(n1613) );
  NAND2BX1 U1947 ( .AN(WriteAllow), .B(n1695), .Y(n1696) );
  NAND2BX1 U1948 ( .AN(n1676), .B(n1679), .Y(n1678) );
  NAND2BX1 U1949 ( .AN(n1676), .B(n1691), .Y(n1690) );
  NAND2BX1 U1950 ( .AN(n1676), .B(n1683), .Y(n1682) );
  NAND2BX1 U1951 ( .AN(n1676), .B(n1695), .Y(n1694) );
  NAND3BX1 U1952 ( .AN(n2542), .B(n1600), .C(n2541), .Y(n2593) );
  NAND3BX1 U1953 ( .AN(n2542), .B(n1600), .C(n2541), .Y(n2594) );
  NAND3BX1 U1954 ( .AN(n2542), .B(n2540), .C(n2541), .Y(n1228) );
  NAND3BX1 U1955 ( .AN(n2542), .B(n1600), .C(n2541), .Y(n1226) );
  OAI221XL U1956 ( .A0(n2594), .A1(n2155), .B0(n2595), .B1(n2315), .C0(n1605), 
        .Y(n1595) );
  OAI221XL U1957 ( .A0(n1226), .A1(n2142), .B0(n1228), .B1(n2314), .C0(n1472), 
        .Y(n1463) );
  OAI221XL U1958 ( .A0(n2593), .A1(n2138), .B0(n2595), .B1(n2297), .C0(n1340), 
        .Y(n1331) );
  OAI221XL U1959 ( .A0(n2593), .A1(n2137), .B0(n1228), .B1(n2296), .C0(n1304), 
        .Y(n1295) );
  OAI221XL U1960 ( .A0(n1226), .A1(n2154), .B0(n1228), .B1(n2313), .C0(n1292), 
        .Y(n1283) );
  OAI221XL U1961 ( .A0(n2594), .A1(n2153), .B0(n2595), .B1(n2312), .C0(n1280), 
        .Y(n1271) );
  OAI221XL U1962 ( .A0(n2593), .A1(n2136), .B0(n1228), .B1(n2295), .C0(n1268), 
        .Y(n1259) );
  OAI221XL U1963 ( .A0(n1226), .A1(n2135), .B0(n1228), .B1(n2294), .C0(n1256), 
        .Y(n1247) );
  OAI221XL U1964 ( .A0(n2594), .A1(n2152), .B0(n2595), .B1(n2311), .C0(n1244), 
        .Y(n1235) );
  OAI221XL U1965 ( .A0(n2593), .A1(n2134), .B0(n1228), .B1(n2293), .C0(n1230), 
        .Y(n1215) );
  OAI221XL U1966 ( .A0(n2593), .A1(n2133), .B0(n2595), .B1(n2292), .C0(n1592), 
        .Y(n1583) );
  OAI221XL U1967 ( .A0(n1226), .A1(n2141), .B0(n1228), .B1(n2310), .C0(n1580), 
        .Y(n1571) );
  OAI221XL U1968 ( .A0(n2594), .A1(n2151), .B0(n2595), .B1(n2309), .C0(n1568), 
        .Y(n1559) );
  OAI221XL U1969 ( .A0(n2593), .A1(n2132), .B0(n1228), .B1(n2291), .C0(n1556), 
        .Y(n1547) );
  OAI221XL U1970 ( .A0(n1226), .A1(n2140), .B0(n1228), .B1(n2308), .C0(n1544), 
        .Y(n1535) );
  OAI221XL U1971 ( .A0(n2594), .A1(n2150), .B0(n2595), .B1(n2307), .C0(n1532), 
        .Y(n1523) );
  OAI221XL U1972 ( .A0(n2593), .A1(n2131), .B0(n2595), .B1(n2290), .C0(n1520), 
        .Y(n1511) );
  OAI221XL U1973 ( .A0(n1226), .A1(n2139), .B0(n1228), .B1(n2306), .C0(n1508), 
        .Y(n1499) );
  OAI221XL U1974 ( .A0(n2594), .A1(n2149), .B0(n2595), .B1(n2305), .C0(n1496), 
        .Y(n1487) );
  OAI221XL U1975 ( .A0(n2593), .A1(n2130), .B0(n1228), .B1(n2289), .C0(n1484), 
        .Y(n1475) );
  OAI221XL U1976 ( .A0(n2594), .A1(n2148), .B0(n2595), .B1(n2304), .C0(n1460), 
        .Y(n1451) );
  OAI221XL U1977 ( .A0(n2593), .A1(n2129), .B0(n2595), .B1(n2288), .C0(n1448), 
        .Y(n1439) );
  OAI221XL U1978 ( .A0(n1226), .A1(n2128), .B0(n1228), .B1(n2303), .C0(n1436), 
        .Y(n1427) );
  OAI221XL U1979 ( .A0(n2594), .A1(n2147), .B0(n2595), .B1(n2302), .C0(n1424), 
        .Y(n1415) );
  OAI221XL U1980 ( .A0(n2593), .A1(n2127), .B0(n2595), .B1(n2287), .C0(n1412), 
        .Y(n1403) );
  OAI221XL U1981 ( .A0(n1226), .A1(n2126), .B0(n1228), .B1(n2286), .C0(n1400), 
        .Y(n1391) );
  OAI221XL U1982 ( .A0(n2594), .A1(n2146), .B0(n2595), .B1(n2301), .C0(n1388), 
        .Y(n1379) );
  OAI221XL U1983 ( .A0(n2593), .A1(n2125), .B0(n1228), .B1(n2285), .C0(n1376), 
        .Y(n1367) );
  OAI221XL U1984 ( .A0(n1226), .A1(n2145), .B0(n1228), .B1(n2300), .C0(n1364), 
        .Y(n1355) );
  OAI221XL U1985 ( .A0(n2594), .A1(n2144), .B0(n2595), .B1(n2299), .C0(n1352), 
        .Y(n1343) );
  OAI221XL U1986 ( .A0(n1226), .A1(n2124), .B0(n1228), .B1(n2284), .C0(n1328), 
        .Y(n1319) );
  OAI221XL U1987 ( .A0(n2594), .A1(n2143), .B0(n2595), .B1(n2298), .C0(n1316), 
        .Y(n1307) );
  NAND3BX1 U1988 ( .AN(n2544), .B(n1867), .C(n1865), .Y(n2545) );
  NAND3BX1 U1989 ( .AN(n2544), .B(n1867), .C(n1865), .Y(n1710) );
  NAND2BX1 U1990 ( .AN(WriteAllow), .B(n1699), .Y(n2567) );
  NAND2BX1 U1991 ( .AN(WriteAllow), .B(n1699), .Y(n2568) );
  NAND2BX1 U1992 ( .AN(n1676), .B(n1699), .Y(n2565) );
  NAND2BX1 U1993 ( .AN(n1676), .B(n1699), .Y(n2566) );
  NAND2BX1 U1994 ( .AN(WriteAllow), .B(n1699), .Y(n1700) );
  NAND2BX1 U1995 ( .AN(n1676), .B(n1699), .Y(n1698) );
  OAI221XL U1996 ( .A0(n2252), .A1(n2549), .B0(n2124), .B1(n2551), .C0(n1750), 
        .Y(n1747) );
  OA22X1 U1997 ( .A0(n2220), .A1(n2553), .B0(n2348), .B1(n2545), .Y(n1750) );
  OAI221XL U1998 ( .A0(n2253), .A1(n2549), .B0(n2125), .B1(n2551), .C0(n1770), 
        .Y(n1767) );
  OA22X1 U1999 ( .A0(n2221), .A1(n2553), .B0(n2352), .B1(n2545), .Y(n1770) );
  OAI221XL U2000 ( .A0(n2254), .A1(n2549), .B0(n2126), .B1(n2551), .C0(n1780), 
        .Y(n1777) );
  OA22X1 U2001 ( .A0(n2222), .A1(n2553), .B0(n2349), .B1(n2545), .Y(n1780) );
  OAI221XL U2002 ( .A0(n2255), .A1(n2549), .B0(n2127), .B1(n2551), .C0(n1785), 
        .Y(n1782) );
  OA22X1 U2003 ( .A0(n2223), .A1(n2553), .B0(n2353), .B1(n2545), .Y(n1785) );
  OAI221XL U2004 ( .A0(n2257), .A1(n2549), .B0(n2129), .B1(n2551), .C0(n1800), 
        .Y(n1797) );
  OA22X1 U2005 ( .A0(n2225), .A1(n2553), .B0(n2354), .B1(n2545), .Y(n1800) );
  OAI221XL U2006 ( .A0(n2258), .A1(n2549), .B0(n2130), .B1(n2551), .C0(n1815), 
        .Y(n1812) );
  OA22X1 U2007 ( .A0(n2226), .A1(n2553), .B0(n2355), .B1(n2545), .Y(n1815) );
  OAI221XL U2008 ( .A0(n2259), .A1(n2549), .B0(n2131), .B1(n2551), .C0(n1830), 
        .Y(n1827) );
  OA22X1 U2009 ( .A0(n2227), .A1(n2553), .B0(n2356), .B1(n2545), .Y(n1830) );
  OAI221XL U2010 ( .A0(n2260), .A1(n2549), .B0(n2132), .B1(n2551), .C0(n1845), 
        .Y(n1842) );
  OA22X1 U2011 ( .A0(n2228), .A1(n2553), .B0(n2357), .B1(n2545), .Y(n1845) );
  OAI221XL U2012 ( .A0(n2261), .A1(n2549), .B0(n2133), .B1(n2551), .C0(n1860), 
        .Y(n1857) );
  OA22X1 U2013 ( .A0(n2229), .A1(n2553), .B0(n2358), .B1(n2545), .Y(n1860) );
  OAI221XL U2014 ( .A0(n2262), .A1(n2549), .B0(n2134), .B1(n2551), .C0(n1709), 
        .Y(n1706) );
  OA22X1 U2015 ( .A0(n2230), .A1(n2553), .B0(n2359), .B1(n2545), .Y(n1709) );
  OAI221XL U2016 ( .A0(n2263), .A1(n2549), .B0(n2135), .B1(n2551), .C0(n1720), 
        .Y(n1717) );
  OA22X1 U2017 ( .A0(n2231), .A1(n2553), .B0(n2351), .B1(n2545), .Y(n1720) );
  OAI221XL U2018 ( .A0(n2264), .A1(n2549), .B0(n2136), .B1(n2551), .C0(n1725), 
        .Y(n1722) );
  OA22X1 U2019 ( .A0(n2232), .A1(n2553), .B0(n2360), .B1(n2545), .Y(n1725) );
  OAI221XL U2020 ( .A0(n2265), .A1(n2549), .B0(n2137), .B1(n2551), .C0(n1740), 
        .Y(n1737) );
  OA22X1 U2021 ( .A0(n2233), .A1(n2553), .B0(n2361), .B1(n2545), .Y(n1740) );
  OAI221XL U2022 ( .A0(n2266), .A1(n2549), .B0(n2138), .B1(n2551), .C0(n1755), 
        .Y(n1752) );
  OA22X1 U2023 ( .A0(n2234), .A1(n2553), .B0(n2362), .B1(n2545), .Y(n1755) );
  OAI221XL U2024 ( .A0(n2256), .A1(n2550), .B0(n2128), .B1(n2552), .C0(n1795), 
        .Y(n1792) );
  OA22X1 U2025 ( .A0(n2224), .A1(n2554), .B0(n2350), .B1(n1710), .Y(n1795) );
  NOR3X1 U2026 ( .A(n1747), .B(n2445), .C(n2446), .Y(n2444) );
  OAI22XL U2027 ( .A0(n2316), .A1(n2555), .B0(n2156), .B1(n2557), .Y(n2445) );
  OAI22XL U2028 ( .A0(n2284), .A1(n2559), .B0(n2188), .B1(n2561), .Y(n2446) );
  NOR3X1 U2029 ( .A(n1767), .B(n2448), .C(n2449), .Y(n2447) );
  OAI22XL U2030 ( .A0(n2317), .A1(n2555), .B0(n2157), .B1(n2557), .Y(n2448) );
  OAI22XL U2031 ( .A0(n2285), .A1(n2559), .B0(n2189), .B1(n2561), .Y(n2449) );
  NOR3X1 U2032 ( .A(n1777), .B(n2451), .C(n2452), .Y(n2450) );
  OAI22XL U2033 ( .A0(n2318), .A1(n2555), .B0(n2158), .B1(n2557), .Y(n2451) );
  OAI22XL U2034 ( .A0(n2286), .A1(n2559), .B0(n2190), .B1(n2561), .Y(n2452) );
  NOR3X1 U2035 ( .A(n1782), .B(n2454), .C(n2455), .Y(n2453) );
  OAI22XL U2036 ( .A0(n2319), .A1(n2555), .B0(n2159), .B1(n2557), .Y(n2454) );
  OAI22XL U2037 ( .A0(n2287), .A1(n2559), .B0(n2191), .B1(n2561), .Y(n2455) );
  NOR3X1 U2038 ( .A(n1797), .B(n2457), .C(n2458), .Y(n2456) );
  OAI22XL U2039 ( .A0(n2320), .A1(n2555), .B0(n2160), .B1(n2557), .Y(n2457) );
  OAI22XL U2040 ( .A0(n2288), .A1(n2559), .B0(n2192), .B1(n2561), .Y(n2458) );
  NOR3X1 U2041 ( .A(n1812), .B(n2460), .C(n2461), .Y(n2459) );
  OAI22XL U2042 ( .A0(n2321), .A1(n2555), .B0(n2161), .B1(n2557), .Y(n2460) );
  OAI22XL U2043 ( .A0(n2289), .A1(n2559), .B0(n2193), .B1(n2561), .Y(n2461) );
  NOR3X1 U2044 ( .A(n1827), .B(n2463), .C(n2464), .Y(n2462) );
  OAI22XL U2045 ( .A0(n2322), .A1(n2555), .B0(n2162), .B1(n2557), .Y(n2463) );
  OAI22XL U2046 ( .A0(n2290), .A1(n2559), .B0(n2194), .B1(n2561), .Y(n2464) );
  NOR3X1 U2047 ( .A(n1842), .B(n2466), .C(n2467), .Y(n2465) );
  OAI22XL U2048 ( .A0(n2323), .A1(n2555), .B0(n2163), .B1(n2557), .Y(n2466) );
  OAI22XL U2049 ( .A0(n2291), .A1(n2559), .B0(n2195), .B1(n2561), .Y(n2467) );
  NOR3X1 U2050 ( .A(n1857), .B(n2469), .C(n2470), .Y(n2468) );
  OAI22XL U2051 ( .A0(n2324), .A1(n2555), .B0(n2164), .B1(n2557), .Y(n2469) );
  OAI22XL U2052 ( .A0(n2292), .A1(n2559), .B0(n2196), .B1(n2561), .Y(n2470) );
  NOR3X1 U2053 ( .A(n1706), .B(n2472), .C(n2473), .Y(n2471) );
  OAI22XL U2054 ( .A0(n2325), .A1(n2555), .B0(n2165), .B1(n2557), .Y(n2472) );
  OAI22XL U2055 ( .A0(n2293), .A1(n2559), .B0(n2197), .B1(n2561), .Y(n2473) );
  NOR3X1 U2056 ( .A(n1717), .B(n2475), .C(n2476), .Y(n2474) );
  OAI22XL U2057 ( .A0(n2326), .A1(n2555), .B0(n2166), .B1(n2557), .Y(n2475) );
  OAI22XL U2058 ( .A0(n2294), .A1(n2559), .B0(n2198), .B1(n2561), .Y(n2476) );
  NOR3X1 U2059 ( .A(n1722), .B(n2478), .C(n2479), .Y(n2477) );
  OAI22XL U2060 ( .A0(n2327), .A1(n2555), .B0(n2167), .B1(n2557), .Y(n2478) );
  OAI22XL U2061 ( .A0(n2295), .A1(n2559), .B0(n2199), .B1(n2561), .Y(n2479) );
  NOR3X1 U2062 ( .A(n1737), .B(n2481), .C(n2482), .Y(n2480) );
  OAI22XL U2063 ( .A0(n2328), .A1(n2555), .B0(n2168), .B1(n2557), .Y(n2481) );
  OAI22XL U2064 ( .A0(n2296), .A1(n2559), .B0(n2200), .B1(n2561), .Y(n2482) );
  NOR3X1 U2065 ( .A(n1752), .B(n2484), .C(n2485), .Y(n2483) );
  OAI22XL U2066 ( .A0(n2329), .A1(n2555), .B0(n2169), .B1(n2557), .Y(n2484) );
  OAI22XL U2067 ( .A0(n2297), .A1(n2559), .B0(n2201), .B1(n2561), .Y(n2485) );
  OAI222XL U2068 ( .A0(n1702), .A1(n2348), .B0(n1628), .B1(n1703), .C0(n2444), 
        .C1(n1704), .Y(FIFO880) );
  OAI222XL U2069 ( .A0(n1702), .A1(n2369), .B0(n1634), .B1(n1703), .C0(n2492), 
        .C1(n1704), .Y(FIFO882) );
  OAI222XL U2070 ( .A0(n1702), .A1(n2349), .B0(n1640), .B1(n1703), .C0(n2450), 
        .C1(n1704), .Y(FIFO885) );
  OAI222XL U2071 ( .A0(n1702), .A1(n2350), .B0(n1646), .B1(n1703), .C0(n2501), 
        .C1(n1704), .Y(FIFO888) );
  OAI222XL U2072 ( .A0(n1702), .A1(n2363), .B0(n1658), .B1(n1703), .C0(n2510), 
        .C1(n1704), .Y(FIFO8813) );
  OAI222XL U2073 ( .A0(n1702), .A1(n2364), .B0(n1664), .B1(n1703), .C0(n2516), 
        .C1(n1704), .Y(FIFO8816) );
  OAI222XL U2074 ( .A0(n1702), .A1(n2365), .B0(n1670), .B1(n1703), .C0(n2522), 
        .C1(n1704), .Y(FIFO8819) );
  OAI222XL U2075 ( .A0(n1702), .A1(n2351), .B0(n1616), .B1(n1703), .C0(n2474), 
        .C1(n1704), .Y(FIFO8823) );
  OAI222XL U2076 ( .A0(n1702), .A1(n2378), .B0(n1622), .B1(n1703), .C0(n2531), 
        .C1(n1704), .Y(FIFO8826) );
  OAI222XL U2077 ( .A0(n1702), .A1(n2366), .B0(n1652), .B1(n1703), .C0(n2534), 
        .C1(n1704), .Y(FIFO8829) );
  OAI222XL U2078 ( .A0(n1702), .A1(n2367), .B0(n1626), .B1(n2548), .C0(n2486), 
        .C1(n2564), .Y(FIFO88) );
  OAI222XL U2079 ( .A0(n1702), .A1(n2368), .B0(n1632), .B1(n2548), .C0(n2489), 
        .C1(n2564), .Y(FIFO881) );
  OAI222XL U2080 ( .A0(n1702), .A1(n2352), .B0(n1636), .B1(n2547), .C0(n2447), 
        .C1(n2563), .Y(FIFO883) );
  OAI222XL U2081 ( .A0(n1702), .A1(n2370), .B0(n1638), .B1(n2548), .C0(n2495), 
        .C1(n2564), .Y(FIFO884) );
  OAI222XL U2082 ( .A0(n1702), .A1(n2353), .B0(n1642), .B1(n2547), .C0(n2453), 
        .C1(n2563), .Y(FIFO886) );
  OAI222XL U2083 ( .A0(n1702), .A1(n2371), .B0(n1644), .B1(n2548), .C0(n2498), 
        .C1(n2564), .Y(FIFO887) );
  OAI222XL U2084 ( .A0(n1702), .A1(n2354), .B0(n1648), .B1(n2547), .C0(n2456), 
        .C1(n2563), .Y(FIFO889) );
  OAI222XL U2085 ( .A0(n1702), .A1(n2372), .B0(n1650), .B1(n2548), .C0(n2504), 
        .C1(n2564), .Y(FIFO8810) );
  OAI222XL U2086 ( .A0(n1702), .A1(n2355), .B0(n1654), .B1(n2547), .C0(n2459), 
        .C1(n2563), .Y(FIFO8811) );
  OAI222XL U2087 ( .A0(n1702), .A1(n2373), .B0(n1656), .B1(n2548), .C0(n2507), 
        .C1(n2564), .Y(FIFO8812) );
  OAI222XL U2088 ( .A0(n1702), .A1(n2356), .B0(n1660), .B1(n2547), .C0(n2462), 
        .C1(n2563), .Y(FIFO8814) );
  OAI222XL U2089 ( .A0(n1702), .A1(n2374), .B0(n1662), .B1(n2548), .C0(n2513), 
        .C1(n2564), .Y(FIFO8815) );
  OAI222XL U2090 ( .A0(n1702), .A1(n2357), .B0(n1666), .B1(n2547), .C0(n2465), 
        .C1(n2563), .Y(FIFO8817) );
  OAI222XL U2091 ( .A0(n1702), .A1(n2375), .B0(n1668), .B1(n2548), .C0(n2519), 
        .C1(n2564), .Y(FIFO8818) );
  OAI222XL U2092 ( .A0(n1702), .A1(n2358), .B0(n1672), .B1(n2547), .C0(n2468), 
        .C1(n2563), .Y(FIFO8820) );
  OAI222XL U2093 ( .A0(n1702), .A1(n2359), .B0(n1610), .B1(n2547), .C0(n2471), 
        .C1(n2563), .Y(FIFO8821) );
  OAI222XL U2094 ( .A0(n1702), .A1(n2376), .B0(n1614), .B1(n2548), .C0(n2525), 
        .C1(n2564), .Y(FIFO8822) );
  OAI222XL U2095 ( .A0(n1702), .A1(n2360), .B0(n1618), .B1(n2547), .C0(n2477), 
        .C1(n2563), .Y(FIFO8824) );
  OAI222XL U2096 ( .A0(n1702), .A1(n2377), .B0(n1620), .B1(n2548), .C0(n2528), 
        .C1(n2564), .Y(FIFO8825) );
  OAI222XL U2097 ( .A0(n1702), .A1(n2361), .B0(n1624), .B1(n2547), .C0(n2480), 
        .C1(n2563), .Y(FIFO8827) );
  OAI222XL U2098 ( .A0(n1702), .A1(n2362), .B0(n1630), .B1(n2547), .C0(n2483), 
        .C1(n2563), .Y(FIFO8828) );
  OAI222XL U2099 ( .A0(n1702), .A1(n2379), .B0(n1674), .B1(n2548), .C0(n2537), 
        .C1(n2564), .Y(FIFO8830) );
  OAI222XL U2100 ( .A0(n1626), .A1(n2578), .B0(n1687), .B1(n2202), .C0(n2486), 
        .C1(n2580), .Y(FIFO88127) );
  OAI222XL U2101 ( .A0(n1628), .A1(n1686), .B0(n1687), .B1(n2188), .C0(n2444), 
        .C1(n1688), .Y(FIFO88128) );
  OAI222XL U2102 ( .A0(n1632), .A1(n2578), .B0(n1687), .B1(n2203), .C0(n2489), 
        .C1(n2580), .Y(FIFO88129) );
  OAI222XL U2103 ( .A0(n1634), .A1(n1686), .B0(n1687), .B1(n2204), .C0(n2492), 
        .C1(n1688), .Y(FIFO88130) );
  OAI222XL U2104 ( .A0(n1636), .A1(n2577), .B0(n1687), .B1(n2189), .C0(n2447), 
        .C1(n2579), .Y(FIFO88131) );
  OAI222XL U2105 ( .A0(n1638), .A1(n2578), .B0(n1687), .B1(n2205), .C0(n2495), 
        .C1(n2580), .Y(FIFO88132) );
  OAI222XL U2106 ( .A0(n1640), .A1(n1686), .B0(n1687), .B1(n2190), .C0(n2450), 
        .C1(n1688), .Y(FIFO88133) );
  OAI222XL U2107 ( .A0(n1642), .A1(n2577), .B0(n1687), .B1(n2191), .C0(n2453), 
        .C1(n2579), .Y(FIFO88134) );
  OAI222XL U2108 ( .A0(n1644), .A1(n2578), .B0(n1687), .B1(n2206), .C0(n2498), 
        .C1(n2580), .Y(FIFO88135) );
  OAI222XL U2109 ( .A0(n1646), .A1(n1686), .B0(n1687), .B1(n2207), .C0(n2501), 
        .C1(n1688), .Y(FIFO88136) );
  OAI222XL U2110 ( .A0(n1648), .A1(n2577), .B0(n1687), .B1(n2192), .C0(n2456), 
        .C1(n2579), .Y(FIFO88137) );
  OAI222XL U2111 ( .A0(n1650), .A1(n2578), .B0(n1687), .B1(n2208), .C0(n2504), 
        .C1(n2580), .Y(FIFO88138) );
  OAI222XL U2112 ( .A0(n1654), .A1(n2577), .B0(n1687), .B1(n2193), .C0(n2459), 
        .C1(n2579), .Y(FIFO88139) );
  OAI222XL U2113 ( .A0(n1656), .A1(n2578), .B0(n1687), .B1(n2209), .C0(n2507), 
        .C1(n2580), .Y(FIFO88140) );
  OAI222XL U2114 ( .A0(n1658), .A1(n1686), .B0(n1687), .B1(n2210), .C0(n2510), 
        .C1(n1688), .Y(FIFO88141) );
  OAI222XL U2115 ( .A0(n1660), .A1(n2577), .B0(n1687), .B1(n2194), .C0(n2462), 
        .C1(n2579), .Y(FIFO88142) );
  OAI222XL U2116 ( .A0(n1662), .A1(n2578), .B0(n1687), .B1(n2211), .C0(n2513), 
        .C1(n2580), .Y(FIFO88143) );
  OAI222XL U2117 ( .A0(n1664), .A1(n1686), .B0(n1687), .B1(n2212), .C0(n2516), 
        .C1(n1688), .Y(FIFO88144) );
  OAI222XL U2118 ( .A0(n1666), .A1(n2577), .B0(n1687), .B1(n2195), .C0(n2465), 
        .C1(n2579), .Y(FIFO88145) );
  OAI222XL U2119 ( .A0(n1668), .A1(n2578), .B0(n1687), .B1(n2213), .C0(n2519), 
        .C1(n2580), .Y(FIFO88146) );
  OAI222XL U2120 ( .A0(n1670), .A1(n1686), .B0(n1687), .B1(n2214), .C0(n2522), 
        .C1(n1688), .Y(FIFO88147) );
  OAI222XL U2121 ( .A0(n1672), .A1(n2577), .B0(n1687), .B1(n2196), .C0(n2468), 
        .C1(n2579), .Y(FIFO88148) );
  OAI222XL U2122 ( .A0(n1610), .A1(n2577), .B0(n1687), .B1(n2197), .C0(n2471), 
        .C1(n2579), .Y(FIFO88149) );
  OAI222XL U2123 ( .A0(n1614), .A1(n2578), .B0(n1687), .B1(n2215), .C0(n2525), 
        .C1(n2580), .Y(FIFO88150) );
  OAI222XL U2124 ( .A0(n1616), .A1(n1686), .B0(n1687), .B1(n2198), .C0(n2474), 
        .C1(n1688), .Y(FIFO88151) );
  OAI222XL U2125 ( .A0(n1618), .A1(n2577), .B0(n1687), .B1(n2199), .C0(n2477), 
        .C1(n2579), .Y(FIFO88152) );
  OAI222XL U2126 ( .A0(n1620), .A1(n2578), .B0(n1687), .B1(n2216), .C0(n2528), 
        .C1(n2580), .Y(FIFO88153) );
  OAI222XL U2127 ( .A0(n1622), .A1(n1686), .B0(n1687), .B1(n2217), .C0(n2531), 
        .C1(n1688), .Y(FIFO88154) );
  OAI222XL U2128 ( .A0(n1624), .A1(n2577), .B0(n1687), .B1(n2200), .C0(n2480), 
        .C1(n2579), .Y(FIFO88155) );
  OAI222XL U2129 ( .A0(n1630), .A1(n2577), .B0(n1687), .B1(n2201), .C0(n2483), 
        .C1(n2579), .Y(FIFO88156) );
  OAI222XL U2130 ( .A0(n1652), .A1(n1686), .B0(n1687), .B1(n2218), .C0(n2534), 
        .C1(n1688), .Y(FIFO88157) );
  OAI222XL U2131 ( .A0(n1674), .A1(n2578), .B0(n1687), .B1(n2219), .C0(n2537), 
        .C1(n2580), .Y(FIFO88158) );
  OAI222XL U2132 ( .A0(n1626), .A1(n2582), .B0(n1683), .B1(n2330), .C0(n2486), 
        .C1(n2584), .Y(FIFO88159) );
  OAI222XL U2133 ( .A0(n1628), .A1(n1682), .B0(n1683), .B1(n2316), .C0(n2444), 
        .C1(n1684), .Y(FIFO88160) );
  OAI222XL U2134 ( .A0(n1632), .A1(n2582), .B0(n1683), .B1(n2331), .C0(n2489), 
        .C1(n2584), .Y(FIFO88161) );
  OAI222XL U2135 ( .A0(n1634), .A1(n1682), .B0(n1683), .B1(n2332), .C0(n2492), 
        .C1(n1684), .Y(FIFO88162) );
  OAI222XL U2136 ( .A0(n1636), .A1(n2581), .B0(n1683), .B1(n2317), .C0(n2447), 
        .C1(n2583), .Y(FIFO88163) );
  OAI222XL U2137 ( .A0(n1638), .A1(n2582), .B0(n1683), .B1(n2333), .C0(n2495), 
        .C1(n2584), .Y(FIFO88164) );
  OAI222XL U2138 ( .A0(n1640), .A1(n1682), .B0(n1683), .B1(n2318), .C0(n2450), 
        .C1(n1684), .Y(FIFO88165) );
  OAI222XL U2139 ( .A0(n1642), .A1(n2581), .B0(n1683), .B1(n2319), .C0(n2453), 
        .C1(n2583), .Y(FIFO88166) );
  OAI222XL U2140 ( .A0(n1644), .A1(n2582), .B0(n1683), .B1(n2334), .C0(n2498), 
        .C1(n2584), .Y(FIFO88167) );
  OAI222XL U2141 ( .A0(n1646), .A1(n1682), .B0(n1683), .B1(n2335), .C0(n2501), 
        .C1(n1684), .Y(FIFO88168) );
  OAI222XL U2142 ( .A0(n1648), .A1(n2581), .B0(n1683), .B1(n2320), .C0(n2456), 
        .C1(n2583), .Y(FIFO88169) );
  OAI222XL U2143 ( .A0(n1650), .A1(n2582), .B0(n1683), .B1(n2336), .C0(n2504), 
        .C1(n2584), .Y(FIFO88170) );
  OAI222XL U2144 ( .A0(n1654), .A1(n2581), .B0(n1683), .B1(n2321), .C0(n2459), 
        .C1(n2583), .Y(FIFO88171) );
  OAI222XL U2145 ( .A0(n1656), .A1(n2582), .B0(n1683), .B1(n2337), .C0(n2507), 
        .C1(n2584), .Y(FIFO88172) );
  OAI222XL U2146 ( .A0(n1658), .A1(n1682), .B0(n1683), .B1(n2338), .C0(n2510), 
        .C1(n1684), .Y(FIFO88173) );
  OAI222XL U2147 ( .A0(n1660), .A1(n2581), .B0(n1683), .B1(n2322), .C0(n2462), 
        .C1(n2583), .Y(FIFO88174) );
  OAI222XL U2148 ( .A0(n1662), .A1(n2582), .B0(n1683), .B1(n2339), .C0(n2513), 
        .C1(n2584), .Y(FIFO88175) );
  OAI222XL U2149 ( .A0(n1664), .A1(n1682), .B0(n1683), .B1(n2340), .C0(n2516), 
        .C1(n1684), .Y(FIFO88176) );
  OAI222XL U2150 ( .A0(n1666), .A1(n2581), .B0(n1683), .B1(n2323), .C0(n2465), 
        .C1(n2583), .Y(FIFO88177) );
  OAI222XL U2151 ( .A0(n1668), .A1(n2582), .B0(n1683), .B1(n2341), .C0(n2519), 
        .C1(n2584), .Y(FIFO88178) );
  OAI222XL U2152 ( .A0(n1670), .A1(n1682), .B0(n1683), .B1(n2342), .C0(n2522), 
        .C1(n1684), .Y(FIFO88179) );
  OAI222XL U2153 ( .A0(n1672), .A1(n2581), .B0(n1683), .B1(n2324), .C0(n2468), 
        .C1(n2583), .Y(FIFO88180) );
  OAI222XL U2154 ( .A0(n1610), .A1(n2581), .B0(n1683), .B1(n2325), .C0(n2471), 
        .C1(n2583), .Y(FIFO88181) );
  OAI222XL U2155 ( .A0(n1614), .A1(n2582), .B0(n1683), .B1(n2343), .C0(n2525), 
        .C1(n2584), .Y(FIFO88182) );
  OAI222XL U2156 ( .A0(n1616), .A1(n1682), .B0(n1683), .B1(n2326), .C0(n2474), 
        .C1(n1684), .Y(FIFO88183) );
  OAI222XL U2157 ( .A0(n1618), .A1(n2581), .B0(n1683), .B1(n2327), .C0(n2477), 
        .C1(n2583), .Y(FIFO88184) );
  OAI222XL U2158 ( .A0(n1620), .A1(n2582), .B0(n1683), .B1(n2344), .C0(n2528), 
        .C1(n2584), .Y(FIFO88185) );
  OAI222XL U2159 ( .A0(n1622), .A1(n1682), .B0(n1683), .B1(n2345), .C0(n2531), 
        .C1(n1684), .Y(FIFO88186) );
  OAI222XL U2160 ( .A0(n1624), .A1(n2581), .B0(n1683), .B1(n2328), .C0(n2480), 
        .C1(n2583), .Y(FIFO88187) );
  OAI222XL U2161 ( .A0(n1630), .A1(n2581), .B0(n1683), .B1(n2329), .C0(n2483), 
        .C1(n2583), .Y(FIFO88188) );
  OAI222XL U2162 ( .A0(n1652), .A1(n1682), .B0(n1683), .B1(n2346), .C0(n2534), 
        .C1(n1684), .Y(FIFO88189) );
  OAI222XL U2163 ( .A0(n1674), .A1(n2582), .B0(n1683), .B1(n2347), .C0(n2537), 
        .C1(n2584), .Y(FIFO88190) );
  OAI222XL U2164 ( .A0(n1626), .A1(n2586), .B0(n1679), .B1(n2170), .C0(n2486), 
        .C1(n2588), .Y(FIFO88191) );
  OAI222XL U2165 ( .A0(n1628), .A1(n1678), .B0(n1679), .B1(n2156), .C0(n2444), 
        .C1(n1680), .Y(FIFO88192) );
  OAI222XL U2166 ( .A0(n1632), .A1(n2586), .B0(n1679), .B1(n2171), .C0(n2489), 
        .C1(n2588), .Y(FIFO88193) );
  OAI222XL U2167 ( .A0(n1634), .A1(n1678), .B0(n1679), .B1(n2172), .C0(n2492), 
        .C1(n1680), .Y(FIFO88194) );
  OAI222XL U2168 ( .A0(n1636), .A1(n2585), .B0(n1679), .B1(n2157), .C0(n2447), 
        .C1(n2587), .Y(FIFO88195) );
  OAI222XL U2169 ( .A0(n1638), .A1(n2586), .B0(n1679), .B1(n2173), .C0(n2495), 
        .C1(n2588), .Y(FIFO88196) );
  OAI222XL U2170 ( .A0(n1640), .A1(n1678), .B0(n1679), .B1(n2158), .C0(n2450), 
        .C1(n1680), .Y(FIFO88197) );
  OAI222XL U2171 ( .A0(n1642), .A1(n2585), .B0(n1679), .B1(n2159), .C0(n2453), 
        .C1(n2587), .Y(FIFO88198) );
  OAI222XL U2172 ( .A0(n1644), .A1(n2586), .B0(n1679), .B1(n2174), .C0(n2498), 
        .C1(n2588), .Y(FIFO88199) );
  OAI222XL U2173 ( .A0(n1646), .A1(n1678), .B0(n1679), .B1(n2175), .C0(n2501), 
        .C1(n1680), .Y(FIFO88200) );
  OAI222XL U2174 ( .A0(n1648), .A1(n2585), .B0(n1679), .B1(n2160), .C0(n2456), 
        .C1(n2587), .Y(FIFO88201) );
  OAI222XL U2175 ( .A0(n1650), .A1(n2586), .B0(n1679), .B1(n2176), .C0(n2504), 
        .C1(n2588), .Y(FIFO88202) );
  OAI222XL U2176 ( .A0(n1654), .A1(n2585), .B0(n1679), .B1(n2161), .C0(n2459), 
        .C1(n2587), .Y(FIFO88203) );
  OAI222XL U2177 ( .A0(n1656), .A1(n2586), .B0(n1679), .B1(n2177), .C0(n2507), 
        .C1(n2588), .Y(FIFO88204) );
  OAI222XL U2178 ( .A0(n1658), .A1(n1678), .B0(n1679), .B1(n2178), .C0(n2510), 
        .C1(n1680), .Y(FIFO88205) );
  OAI222XL U2179 ( .A0(n1660), .A1(n2585), .B0(n1679), .B1(n2162), .C0(n2462), 
        .C1(n2587), .Y(FIFO88206) );
  OAI222XL U2180 ( .A0(n1662), .A1(n2586), .B0(n1679), .B1(n2179), .C0(n2513), 
        .C1(n2588), .Y(FIFO88207) );
  OAI222XL U2181 ( .A0(n1664), .A1(n1678), .B0(n1679), .B1(n2180), .C0(n2516), 
        .C1(n1680), .Y(FIFO88208) );
  OAI222XL U2182 ( .A0(n1666), .A1(n2585), .B0(n1679), .B1(n2163), .C0(n2465), 
        .C1(n2587), .Y(FIFO88209) );
  OAI222XL U2183 ( .A0(n1668), .A1(n2586), .B0(n1679), .B1(n2181), .C0(n2519), 
        .C1(n2588), .Y(FIFO88210) );
  OAI222XL U2184 ( .A0(n1670), .A1(n1678), .B0(n1679), .B1(n2182), .C0(n2522), 
        .C1(n1680), .Y(FIFO88211) );
  OAI222XL U2185 ( .A0(n1672), .A1(n2585), .B0(n1679), .B1(n2164), .C0(n2468), 
        .C1(n2587), .Y(FIFO88212) );
  OAI222XL U2186 ( .A0(n1610), .A1(n2585), .B0(n1679), .B1(n2165), .C0(n2471), 
        .C1(n2587), .Y(FIFO88213) );
  OAI222XL U2187 ( .A0(n1614), .A1(n2586), .B0(n1679), .B1(n2183), .C0(n2525), 
        .C1(n2588), .Y(FIFO88214) );
  OAI222XL U2188 ( .A0(n1616), .A1(n1678), .B0(n1679), .B1(n2166), .C0(n2474), 
        .C1(n1680), .Y(FIFO88215) );
  OAI222XL U2189 ( .A0(n1618), .A1(n2585), .B0(n1679), .B1(n2167), .C0(n2477), 
        .C1(n2587), .Y(FIFO88216) );
  OAI222XL U2190 ( .A0(n1620), .A1(n2586), .B0(n1679), .B1(n2184), .C0(n2528), 
        .C1(n2588), .Y(FIFO88217) );
  OAI222XL U2191 ( .A0(n1622), .A1(n1678), .B0(n1679), .B1(n2185), .C0(n2531), 
        .C1(n1680), .Y(FIFO88218) );
  OAI222XL U2192 ( .A0(n1624), .A1(n2585), .B0(n1679), .B1(n2168), .C0(n2480), 
        .C1(n2587), .Y(FIFO88219) );
  OAI222XL U2193 ( .A0(n1630), .A1(n2585), .B0(n1679), .B1(n2169), .C0(n2483), 
        .C1(n2587), .Y(FIFO88220) );
  OAI222XL U2194 ( .A0(n1652), .A1(n1678), .B0(n1679), .B1(n2186), .C0(n2534), 
        .C1(n1680), .Y(FIFO88221) );
  OAI222XL U2195 ( .A0(n1674), .A1(n2586), .B0(n1679), .B1(n2187), .C0(n2537), 
        .C1(n2588), .Y(FIFO88222) );
  OAI222XL U2196 ( .A0(n2590), .A1(n1626), .B0(n1611), .B1(n2239), .C0(n2486), 
        .C1(n2592), .Y(FIFO88223) );
  OAI222XL U2197 ( .A0(n1609), .A1(n1628), .B0(n1611), .B1(n2220), .C0(n2444), 
        .C1(n1613), .Y(FIFO88224) );
  OAI222XL U2198 ( .A0(n2590), .A1(n1632), .B0(n1611), .B1(n2240), .C0(n2489), 
        .C1(n2592), .Y(FIFO88225) );
  OAI222XL U2199 ( .A0(n1609), .A1(n1634), .B0(n1611), .B1(n2241), .C0(n2492), 
        .C1(n1613), .Y(FIFO88226) );
  OAI222XL U2200 ( .A0(n2589), .A1(n1636), .B0(n1611), .B1(n2221), .C0(n2447), 
        .C1(n2591), .Y(FIFO88227) );
  OAI222XL U2201 ( .A0(n2590), .A1(n1638), .B0(n1611), .B1(n2242), .C0(n2495), 
        .C1(n2592), .Y(FIFO88228) );
  OAI222XL U2202 ( .A0(n1609), .A1(n1640), .B0(n1611), .B1(n2222), .C0(n2450), 
        .C1(n1613), .Y(FIFO88229) );
  OAI222XL U2203 ( .A0(n2589), .A1(n1642), .B0(n1611), .B1(n2223), .C0(n2453), 
        .C1(n2591), .Y(FIFO88230) );
  OAI222XL U2204 ( .A0(n2590), .A1(n1644), .B0(n1611), .B1(n2243), .C0(n2498), 
        .C1(n2592), .Y(FIFO88231) );
  OAI222XL U2205 ( .A0(n1609), .A1(n1646), .B0(n1611), .B1(n2224), .C0(n2501), 
        .C1(n1613), .Y(FIFO88232) );
  OAI222XL U2206 ( .A0(n2589), .A1(n1648), .B0(n1611), .B1(n2225), .C0(n2456), 
        .C1(n2591), .Y(FIFO88233) );
  OAI222XL U2207 ( .A0(n2590), .A1(n1650), .B0(n1611), .B1(n2244), .C0(n2504), 
        .C1(n2592), .Y(FIFO88234) );
  OAI222XL U2208 ( .A0(n2589), .A1(n1654), .B0(n1611), .B1(n2226), .C0(n2459), 
        .C1(n2591), .Y(FIFO88235) );
  OAI222XL U2209 ( .A0(n2590), .A1(n1656), .B0(n1611), .B1(n2245), .C0(n2507), 
        .C1(n2592), .Y(FIFO88236) );
  OAI222XL U2210 ( .A0(n1609), .A1(n1658), .B0(n1611), .B1(n2235), .C0(n2510), 
        .C1(n1613), .Y(FIFO88237) );
  OAI222XL U2211 ( .A0(n2589), .A1(n1660), .B0(n1611), .B1(n2227), .C0(n2462), 
        .C1(n2591), .Y(FIFO88238) );
  OAI222XL U2212 ( .A0(n2590), .A1(n1662), .B0(n1611), .B1(n2246), .C0(n2513), 
        .C1(n2592), .Y(FIFO88239) );
  OAI222XL U2213 ( .A0(n1609), .A1(n1664), .B0(n1611), .B1(n2236), .C0(n2516), 
        .C1(n1613), .Y(FIFO88240) );
  OAI222XL U2214 ( .A0(n2589), .A1(n1666), .B0(n1611), .B1(n2228), .C0(n2465), 
        .C1(n2591), .Y(FIFO88241) );
  OAI222XL U2215 ( .A0(n2590), .A1(n1668), .B0(n1611), .B1(n2247), .C0(n2519), 
        .C1(n2592), .Y(FIFO88242) );
  OAI222XL U2216 ( .A0(n1609), .A1(n1670), .B0(n1611), .B1(n2237), .C0(n2522), 
        .C1(n1613), .Y(FIFO88243) );
  OAI222XL U2217 ( .A0(n2589), .A1(n1672), .B0(n1611), .B1(n2229), .C0(n2468), 
        .C1(n2591), .Y(FIFO88244) );
  OAI222XL U2218 ( .A0(n2589), .A1(n1610), .B0(n1611), .B1(n2230), .C0(n2471), 
        .C1(n2591), .Y(FIFO88245) );
  OAI222XL U2219 ( .A0(n2590), .A1(n1614), .B0(n1611), .B1(n2248), .C0(n2525), 
        .C1(n2592), .Y(FIFO88246) );
  OAI222XL U2220 ( .A0(n1609), .A1(n1616), .B0(n1611), .B1(n2231), .C0(n2474), 
        .C1(n1613), .Y(FIFO88247) );
  OAI222XL U2221 ( .A0(n2589), .A1(n1618), .B0(n1611), .B1(n2232), .C0(n2477), 
        .C1(n2591), .Y(FIFO88248) );
  OAI222XL U2222 ( .A0(n2590), .A1(n1620), .B0(n1611), .B1(n2249), .C0(n2528), 
        .C1(n2592), .Y(FIFO88249) );
  OAI222XL U2223 ( .A0(n1609), .A1(n1622), .B0(n1611), .B1(n2250), .C0(n2531), 
        .C1(n1613), .Y(FIFO88250) );
  OAI222XL U2224 ( .A0(n2589), .A1(n1624), .B0(n1611), .B1(n2233), .C0(n2480), 
        .C1(n2591), .Y(FIFO88251) );
  OAI222XL U2225 ( .A0(n2589), .A1(n1630), .B0(n1611), .B1(n2234), .C0(n2483), 
        .C1(n2591), .Y(FIFO88252) );
  OAI222XL U2226 ( .A0(n1609), .A1(n1652), .B0(n1611), .B1(n2238), .C0(n2534), 
        .C1(n1613), .Y(FIFO88253) );
  OAI222XL U2227 ( .A0(n2590), .A1(n1674), .B0(n1611), .B1(n2251), .C0(n2537), 
        .C1(n2592), .Y(FIFO88254) );
  OAI222XL U2228 ( .A0(n1626), .A1(n2566), .B0(n1699), .B1(n2271), .C0(n2486), 
        .C1(n2568), .Y(FIFO8831) );
  OAI222XL U2229 ( .A0(n1628), .A1(n1698), .B0(n1699), .B1(n2252), .C0(n2444), 
        .C1(n1700), .Y(FIFO8832) );
  OAI222XL U2230 ( .A0(n1632), .A1(n2566), .B0(n1699), .B1(n2272), .C0(n2489), 
        .C1(n2568), .Y(FIFO8833) );
  OAI222XL U2231 ( .A0(n1634), .A1(n1698), .B0(n1699), .B1(n2273), .C0(n2492), 
        .C1(n1700), .Y(FIFO8834) );
  OAI222XL U2232 ( .A0(n1636), .A1(n2565), .B0(n1699), .B1(n2253), .C0(n2447), 
        .C1(n2567), .Y(FIFO8835) );
  OAI222XL U2233 ( .A0(n1638), .A1(n2566), .B0(n1699), .B1(n2274), .C0(n2495), 
        .C1(n2568), .Y(FIFO8836) );
  OAI222XL U2234 ( .A0(n1640), .A1(n1698), .B0(n1699), .B1(n2254), .C0(n2450), 
        .C1(n1700), .Y(FIFO8837) );
  OAI222XL U2235 ( .A0(n1642), .A1(n2565), .B0(n1699), .B1(n2255), .C0(n2453), 
        .C1(n2567), .Y(FIFO8838) );
  OAI222XL U2236 ( .A0(n1644), .A1(n2566), .B0(n1699), .B1(n2275), .C0(n2498), 
        .C1(n2568), .Y(FIFO8839) );
  OAI222XL U2237 ( .A0(n1646), .A1(n1698), .B0(n1699), .B1(n2256), .C0(n2501), 
        .C1(n1700), .Y(FIFO8840) );
  OAI222XL U2238 ( .A0(n1648), .A1(n2565), .B0(n1699), .B1(n2257), .C0(n2456), 
        .C1(n2567), .Y(FIFO8841) );
  OAI222XL U2239 ( .A0(n1650), .A1(n2566), .B0(n1699), .B1(n2276), .C0(n2504), 
        .C1(n2568), .Y(FIFO8842) );
  OAI222XL U2240 ( .A0(n1654), .A1(n2565), .B0(n1699), .B1(n2258), .C0(n2459), 
        .C1(n2567), .Y(FIFO8843) );
  OAI222XL U2241 ( .A0(n1656), .A1(n2566), .B0(n1699), .B1(n2277), .C0(n2507), 
        .C1(n2568), .Y(FIFO8844) );
  OAI222XL U2242 ( .A0(n1658), .A1(n1698), .B0(n1699), .B1(n2267), .C0(n2510), 
        .C1(n1700), .Y(FIFO8845) );
  OAI222XL U2243 ( .A0(n1660), .A1(n2565), .B0(n1699), .B1(n2259), .C0(n2462), 
        .C1(n2567), .Y(FIFO8846) );
  OAI222XL U2244 ( .A0(n1662), .A1(n2566), .B0(n1699), .B1(n2278), .C0(n2513), 
        .C1(n2568), .Y(FIFO8847) );
  OAI222XL U2245 ( .A0(n1664), .A1(n1698), .B0(n1699), .B1(n2268), .C0(n2516), 
        .C1(n1700), .Y(FIFO8848) );
  OAI222XL U2246 ( .A0(n1666), .A1(n2565), .B0(n1699), .B1(n2260), .C0(n2465), 
        .C1(n2567), .Y(FIFO8849) );
  OAI222XL U2247 ( .A0(n1668), .A1(n2566), .B0(n1699), .B1(n2279), .C0(n2519), 
        .C1(n2568), .Y(FIFO8850) );
  OAI222XL U2248 ( .A0(n1670), .A1(n1698), .B0(n1699), .B1(n2269), .C0(n2522), 
        .C1(n1700), .Y(FIFO8851) );
  OAI222XL U2249 ( .A0(n1672), .A1(n2565), .B0(n1699), .B1(n2261), .C0(n2468), 
        .C1(n2567), .Y(FIFO8852) );
  OAI222XL U2250 ( .A0(n1610), .A1(n2565), .B0(n1699), .B1(n2262), .C0(n2471), 
        .C1(n2567), .Y(FIFO8853) );
  OAI222XL U2251 ( .A0(n1614), .A1(n2566), .B0(n1699), .B1(n2280), .C0(n2525), 
        .C1(n2568), .Y(FIFO8854) );
  OAI222XL U2252 ( .A0(n1616), .A1(n1698), .B0(n1699), .B1(n2263), .C0(n2474), 
        .C1(n1700), .Y(FIFO8855) );
  OAI222XL U2253 ( .A0(n1618), .A1(n2565), .B0(n1699), .B1(n2264), .C0(n2477), 
        .C1(n2567), .Y(FIFO8856) );
  OAI222XL U2254 ( .A0(n1620), .A1(n2566), .B0(n1699), .B1(n2281), .C0(n2528), 
        .C1(n2568), .Y(FIFO8857) );
  OAI222XL U2255 ( .A0(n1622), .A1(n1698), .B0(n1699), .B1(n2282), .C0(n2531), 
        .C1(n1700), .Y(FIFO8858) );
  OAI222XL U2256 ( .A0(n1624), .A1(n2565), .B0(n1699), .B1(n2265), .C0(n2480), 
        .C1(n2567), .Y(FIFO8859) );
  OAI222XL U2257 ( .A0(n1630), .A1(n2565), .B0(n1699), .B1(n2266), .C0(n2483), 
        .C1(n2567), .Y(FIFO8860) );
  OAI222XL U2258 ( .A0(n1652), .A1(n1698), .B0(n1699), .B1(n2270), .C0(n2534), 
        .C1(n1700), .Y(FIFO8861) );
  OAI222XL U2259 ( .A0(n1674), .A1(n2566), .B0(n1699), .B1(n2283), .C0(n2537), 
        .C1(n2568), .Y(FIFO8862) );
  OAI222XL U2260 ( .A0(n1626), .A1(n2574), .B0(n1691), .B1(n2298), .C0(n2486), 
        .C1(n2576), .Y(FIFO8895) );
  OAI222XL U2261 ( .A0(n1628), .A1(n1690), .B0(n1691), .B1(n2284), .C0(n2444), 
        .C1(n1692), .Y(FIFO8896) );
  OAI222XL U2262 ( .A0(n1632), .A1(n2574), .B0(n1691), .B1(n2299), .C0(n2489), 
        .C1(n2576), .Y(FIFO8897) );
  OAI222XL U2263 ( .A0(n1634), .A1(n1690), .B0(n1691), .B1(n2300), .C0(n2492), 
        .C1(n1692), .Y(FIFO8898) );
  OAI222XL U2264 ( .A0(n1636), .A1(n2573), .B0(n1691), .B1(n2285), .C0(n2447), 
        .C1(n2575), .Y(FIFO8899) );
  OAI222XL U2265 ( .A0(n1638), .A1(n2574), .B0(n1691), .B1(n2301), .C0(n2495), 
        .C1(n2576), .Y(FIFO88100) );
  OAI222XL U2266 ( .A0(n1640), .A1(n1690), .B0(n1691), .B1(n2286), .C0(n2450), 
        .C1(n1692), .Y(FIFO88101) );
  OAI222XL U2267 ( .A0(n1642), .A1(n2573), .B0(n1691), .B1(n2287), .C0(n2453), 
        .C1(n2575), .Y(FIFO88102) );
  OAI222XL U2268 ( .A0(n1644), .A1(n2574), .B0(n1691), .B1(n2302), .C0(n2498), 
        .C1(n2576), .Y(FIFO88103) );
  OAI222XL U2269 ( .A0(n1646), .A1(n1690), .B0(n1691), .B1(n2303), .C0(n2501), 
        .C1(n1692), .Y(FIFO88104) );
  OAI222XL U2270 ( .A0(n1648), .A1(n2573), .B0(n1691), .B1(n2288), .C0(n2456), 
        .C1(n2575), .Y(FIFO88105) );
  OAI222XL U2271 ( .A0(n1650), .A1(n2574), .B0(n1691), .B1(n2304), .C0(n2504), 
        .C1(n2576), .Y(FIFO88106) );
  OAI222XL U2272 ( .A0(n1654), .A1(n2573), .B0(n1691), .B1(n2289), .C0(n2459), 
        .C1(n2575), .Y(FIFO88107) );
  OAI222XL U2273 ( .A0(n1656), .A1(n2574), .B0(n1691), .B1(n2305), .C0(n2507), 
        .C1(n2576), .Y(FIFO88108) );
  OAI222XL U2274 ( .A0(n1658), .A1(n1690), .B0(n1691), .B1(n2306), .C0(n2510), 
        .C1(n1692), .Y(FIFO88109) );
  OAI222XL U2275 ( .A0(n1660), .A1(n2573), .B0(n1691), .B1(n2290), .C0(n2462), 
        .C1(n2575), .Y(FIFO88110) );
  OAI222XL U2276 ( .A0(n1662), .A1(n2574), .B0(n1691), .B1(n2307), .C0(n2513), 
        .C1(n2576), .Y(FIFO88111) );
  OAI222XL U2277 ( .A0(n1664), .A1(n1690), .B0(n1691), .B1(n2308), .C0(n2516), 
        .C1(n1692), .Y(FIFO88112) );
  OAI222XL U2278 ( .A0(n1666), .A1(n2573), .B0(n1691), .B1(n2291), .C0(n2465), 
        .C1(n2575), .Y(FIFO88113) );
  OAI222XL U2279 ( .A0(n1668), .A1(n2574), .B0(n1691), .B1(n2309), .C0(n2519), 
        .C1(n2576), .Y(FIFO88114) );
  OAI222XL U2280 ( .A0(n1670), .A1(n1690), .B0(n1691), .B1(n2310), .C0(n2522), 
        .C1(n1692), .Y(FIFO88115) );
  OAI222XL U2281 ( .A0(n1672), .A1(n2573), .B0(n1691), .B1(n2292), .C0(n2468), 
        .C1(n2575), .Y(FIFO88116) );
  OAI222XL U2282 ( .A0(n1610), .A1(n2573), .B0(n1691), .B1(n2293), .C0(n2471), 
        .C1(n2575), .Y(FIFO88117) );
  OAI222XL U2283 ( .A0(n1614), .A1(n2574), .B0(n1691), .B1(n2311), .C0(n2525), 
        .C1(n2576), .Y(FIFO88118) );
  OAI222XL U2284 ( .A0(n1616), .A1(n1690), .B0(n1691), .B1(n2294), .C0(n2474), 
        .C1(n1692), .Y(FIFO88119) );
  OAI222XL U2285 ( .A0(n1618), .A1(n2573), .B0(n1691), .B1(n2295), .C0(n2477), 
        .C1(n2575), .Y(FIFO88120) );
  OAI222XL U2286 ( .A0(n1620), .A1(n2574), .B0(n1691), .B1(n2312), .C0(n2528), 
        .C1(n2576), .Y(FIFO88121) );
  OAI222XL U2287 ( .A0(n1622), .A1(n1690), .B0(n1691), .B1(n2313), .C0(n2531), 
        .C1(n1692), .Y(FIFO88122) );
  OAI222XL U2288 ( .A0(n1624), .A1(n2573), .B0(n1691), .B1(n2296), .C0(n2480), 
        .C1(n2575), .Y(FIFO88123) );
  OAI222XL U2289 ( .A0(n1630), .A1(n2573), .B0(n1691), .B1(n2297), .C0(n2483), 
        .C1(n2575), .Y(FIFO88124) );
  OAI222XL U2290 ( .A0(n1652), .A1(n1690), .B0(n1691), .B1(n2314), .C0(n2534), 
        .C1(n1692), .Y(FIFO88125) );
  OAI222XL U2291 ( .A0(n1674), .A1(n2574), .B0(n1691), .B1(n2315), .C0(n2537), 
        .C1(n2576), .Y(FIFO88126) );
  OAI222XL U2292 ( .A0(n1626), .A1(n2570), .B0(n1695), .B1(n2143), .C0(n2486), 
        .C1(n2572), .Y(FIFO8863) );
  OAI222XL U2293 ( .A0(n1628), .A1(n1694), .B0(n1695), .B1(n2124), .C0(n2444), 
        .C1(n1696), .Y(FIFO8864) );
  OAI222XL U2294 ( .A0(n1632), .A1(n2570), .B0(n1695), .B1(n2144), .C0(n2489), 
        .C1(n2572), .Y(FIFO8865) );
  OAI222XL U2295 ( .A0(n1634), .A1(n1694), .B0(n1695), .B1(n2145), .C0(n2492), 
        .C1(n1696), .Y(FIFO8866) );
  OAI222XL U2296 ( .A0(n1636), .A1(n2569), .B0(n1695), .B1(n2125), .C0(n2447), 
        .C1(n2571), .Y(FIFO8867) );
  OAI222XL U2297 ( .A0(n1638), .A1(n2570), .B0(n1695), .B1(n2146), .C0(n2495), 
        .C1(n2572), .Y(FIFO8868) );
  OAI222XL U2298 ( .A0(n1640), .A1(n1694), .B0(n1695), .B1(n2126), .C0(n2450), 
        .C1(n1696), .Y(FIFO8869) );
  OAI222XL U2299 ( .A0(n1642), .A1(n2569), .B0(n1695), .B1(n2127), .C0(n2453), 
        .C1(n2571), .Y(FIFO8870) );
  OAI222XL U2300 ( .A0(n1644), .A1(n2570), .B0(n1695), .B1(n2147), .C0(n2498), 
        .C1(n2572), .Y(FIFO8871) );
  OAI222XL U2301 ( .A0(n1646), .A1(n1694), .B0(n1695), .B1(n2128), .C0(n2501), 
        .C1(n1696), .Y(FIFO8872) );
  OAI222XL U2302 ( .A0(n1648), .A1(n2569), .B0(n1695), .B1(n2129), .C0(n2456), 
        .C1(n2571), .Y(FIFO8873) );
  OAI222XL U2303 ( .A0(n1650), .A1(n2570), .B0(n1695), .B1(n2148), .C0(n2504), 
        .C1(n2572), .Y(FIFO8874) );
  OAI222XL U2304 ( .A0(n1654), .A1(n2569), .B0(n1695), .B1(n2130), .C0(n2459), 
        .C1(n2571), .Y(FIFO8875) );
  OAI222XL U2305 ( .A0(n1656), .A1(n2570), .B0(n1695), .B1(n2149), .C0(n2507), 
        .C1(n2572), .Y(FIFO8876) );
  OAI222XL U2306 ( .A0(n1658), .A1(n1694), .B0(n1695), .B1(n2139), .C0(n2510), 
        .C1(n1696), .Y(FIFO8877) );
  OAI222XL U2307 ( .A0(n1660), .A1(n2569), .B0(n1695), .B1(n2131), .C0(n2462), 
        .C1(n2571), .Y(FIFO8878) );
  OAI222XL U2308 ( .A0(n1662), .A1(n2570), .B0(n1695), .B1(n2150), .C0(n2513), 
        .C1(n2572), .Y(FIFO8879) );
  OAI222XL U2309 ( .A0(n1664), .A1(n1694), .B0(n1695), .B1(n2140), .C0(n2516), 
        .C1(n1696), .Y(FIFO8880) );
  OAI222XL U2310 ( .A0(n1666), .A1(n2569), .B0(n1695), .B1(n2132), .C0(n2465), 
        .C1(n2571), .Y(FIFO8881) );
  OAI222XL U2311 ( .A0(n1668), .A1(n2570), .B0(n1695), .B1(n2151), .C0(n2519), 
        .C1(n2572), .Y(FIFO8882) );
  OAI222XL U2312 ( .A0(n1670), .A1(n1694), .B0(n1695), .B1(n2141), .C0(n2522), 
        .C1(n1696), .Y(FIFO8883) );
  OAI222XL U2313 ( .A0(n1672), .A1(n2569), .B0(n1695), .B1(n2133), .C0(n2468), 
        .C1(n2571), .Y(FIFO8884) );
  OAI222XL U2314 ( .A0(n1610), .A1(n2569), .B0(n1695), .B1(n2134), .C0(n2471), 
        .C1(n2571), .Y(FIFO8885) );
  OAI222XL U2315 ( .A0(n1614), .A1(n2570), .B0(n1695), .B1(n2152), .C0(n2525), 
        .C1(n2572), .Y(FIFO8886) );
  OAI222XL U2316 ( .A0(n1616), .A1(n1694), .B0(n1695), .B1(n2135), .C0(n2474), 
        .C1(n1696), .Y(FIFO8887) );
  OAI222XL U2317 ( .A0(n1618), .A1(n2569), .B0(n1695), .B1(n2136), .C0(n2477), 
        .C1(n2571), .Y(FIFO8888) );
  OAI222XL U2318 ( .A0(n1620), .A1(n2570), .B0(n1695), .B1(n2153), .C0(n2528), 
        .C1(n2572), .Y(FIFO8889) );
  OAI222XL U2319 ( .A0(n1622), .A1(n1694), .B0(n1695), .B1(n2154), .C0(n2531), 
        .C1(n1696), .Y(FIFO8890) );
  OAI222XL U2320 ( .A0(n1624), .A1(n2569), .B0(n1695), .B1(n2137), .C0(n2480), 
        .C1(n2571), .Y(FIFO8891) );
  OAI222XL U2321 ( .A0(n1630), .A1(n2569), .B0(n1695), .B1(n2138), .C0(n2483), 
        .C1(n2571), .Y(FIFO8892) );
  OAI222XL U2322 ( .A0(n1652), .A1(n1694), .B0(n1695), .B1(n2142), .C0(n2534), 
        .C1(n1696), .Y(FIFO8893) );
  OAI222XL U2323 ( .A0(n1674), .A1(n2570), .B0(n1695), .B1(n2155), .C0(n2537), 
        .C1(n2572), .Y(FIFO8894) );
  NAND3BX1 U2324 ( .AN(n2543), .B(n1865), .C(n2544), .Y(n2561) );
  NAND3BX1 U2325 ( .AN(n2543), .B(n1865), .C(n2544), .Y(n1689) );
  NAND3BX1 U2326 ( .AN(n1865), .B(n2543), .C(n2544), .Y(n2553) );
  NAND3BX1 U2327 ( .AN(n1865), .B(n2543), .C(n2544), .Y(n2554) );
  NAND3BX1 U2328 ( .AN(n2543), .B(n1865), .C(n2544), .Y(n2562) );
  NAND3BX1 U2329 ( .AN(n2544), .B(n1867), .C(n1865), .Y(n2546) );
  NAND3BX1 U2330 ( .AN(n1865), .B(n2543), .C(n2544), .Y(n1677) );
  NAND3BX1 U2331 ( .AN(n2544), .B(n1865), .C(n2543), .Y(n2551) );
  NAND3BX1 U2332 ( .AN(n2544), .B(n1865), .C(n2543), .Y(n2552) );
  NAND3BX1 U2333 ( .AN(n2544), .B(n1865), .C(n2543), .Y(n1697) );
  CLKINVX1 U2334 ( .A(n2543), .Y(n1867) );
  OAI221XL U2335 ( .A0(n2267), .A1(n2550), .B0(n2139), .B1(n2552), .C0(n1825), 
        .Y(n1822) );
  OA22X1 U2336 ( .A0(n2235), .A1(n1677), .B0(n2363), .B1(n1710), .Y(n1825) );
  OAI221XL U2337 ( .A0(n2268), .A1(n2549), .B0(n2140), .B1(n2551), .C0(n1840), 
        .Y(n1837) );
  OA22X1 U2338 ( .A0(n2236), .A1(n1677), .B0(n2364), .B1(n1710), .Y(n1840) );
  OAI221XL U2339 ( .A0(n2269), .A1(n2550), .B0(n2141), .B1(n2552), .C0(n1855), 
        .Y(n1852) );
  OA22X1 U2340 ( .A0(n2237), .A1(n1677), .B0(n2365), .B1(n1710), .Y(n1855) );
  OAI221XL U2341 ( .A0(n2270), .A1(n2549), .B0(n2142), .B1(n2551), .C0(n1810), 
        .Y(n1807) );
  OA22X1 U2342 ( .A0(n2238), .A1(n1677), .B0(n2366), .B1(n1710), .Y(n1810) );
  OAI221XL U2343 ( .A0(n2271), .A1(n2550), .B0(n2143), .B1(n2552), .C0(n1745), 
        .Y(n1742) );
  OA22X1 U2344 ( .A0(n2239), .A1(n2554), .B0(n2367), .B1(n2546), .Y(n1745) );
  OAI221XL U2345 ( .A0(n2272), .A1(n2550), .B0(n2144), .B1(n2552), .C0(n1760), 
        .Y(n1757) );
  OA22X1 U2346 ( .A0(n2240), .A1(n2554), .B0(n2368), .B1(n2546), .Y(n1760) );
  OAI221XL U2347 ( .A0(n2273), .A1(n2550), .B0(n2145), .B1(n2552), .C0(n1765), 
        .Y(n1762) );
  OA22X1 U2348 ( .A0(n2241), .A1(n2554), .B0(n2369), .B1(n2546), .Y(n1765) );
  OAI221XL U2349 ( .A0(n2274), .A1(n2550), .B0(n2146), .B1(n2552), .C0(n1775), 
        .Y(n1772) );
  OA22X1 U2350 ( .A0(n2242), .A1(n2554), .B0(n2370), .B1(n2546), .Y(n1775) );
  OAI221XL U2351 ( .A0(n2275), .A1(n2550), .B0(n2147), .B1(n2552), .C0(n1790), 
        .Y(n1787) );
  OA22X1 U2352 ( .A0(n2243), .A1(n2554), .B0(n2371), .B1(n2546), .Y(n1790) );
  OAI221XL U2353 ( .A0(n2276), .A1(n2550), .B0(n2148), .B1(n2552), .C0(n1805), 
        .Y(n1802) );
  OA22X1 U2354 ( .A0(n2244), .A1(n2554), .B0(n2372), .B1(n2546), .Y(n1805) );
  OAI221XL U2355 ( .A0(n2277), .A1(n2550), .B0(n2149), .B1(n2552), .C0(n1820), 
        .Y(n1817) );
  OA22X1 U2356 ( .A0(n2245), .A1(n2554), .B0(n2373), .B1(n2546), .Y(n1820) );
  OAI221XL U2357 ( .A0(n2278), .A1(n2550), .B0(n2150), .B1(n2552), .C0(n1835), 
        .Y(n1832) );
  OA22X1 U2358 ( .A0(n2246), .A1(n2554), .B0(n2374), .B1(n2546), .Y(n1835) );
  OAI221XL U2359 ( .A0(n2279), .A1(n2550), .B0(n2151), .B1(n2552), .C0(n1850), 
        .Y(n1847) );
  OA22X1 U2360 ( .A0(n2247), .A1(n2554), .B0(n2375), .B1(n2546), .Y(n1850) );
  OAI221XL U2361 ( .A0(n2280), .A1(n2550), .B0(n2152), .B1(n2552), .C0(n1715), 
        .Y(n1712) );
  OA22X1 U2362 ( .A0(n2248), .A1(n2554), .B0(n2376), .B1(n2546), .Y(n1715) );
  OAI221XL U2363 ( .A0(n2281), .A1(n2550), .B0(n2153), .B1(n2552), .C0(n1730), 
        .Y(n1727) );
  OA22X1 U2364 ( .A0(n2249), .A1(n2554), .B0(n2377), .B1(n2546), .Y(n1730) );
  OAI221XL U2365 ( .A0(n2282), .A1(n2550), .B0(n2154), .B1(n2552), .C0(n1735), 
        .Y(n1732) );
  OA22X1 U2366 ( .A0(n2250), .A1(n2554), .B0(n2378), .B1(n2546), .Y(n1735) );
  OAI221XL U2367 ( .A0(n2283), .A1(n2550), .B0(n2155), .B1(n2552), .C0(n1866), 
        .Y(n1862) );
  OA22X1 U2368 ( .A0(n2251), .A1(n2554), .B0(n2379), .B1(n2546), .Y(n1866) );
  NOR3X1 U2369 ( .A(n1742), .B(n2487), .C(n2488), .Y(n2486) );
  OAI22XL U2370 ( .A0(n2330), .A1(n2556), .B0(n2170), .B1(n2558), .Y(n2487) );
  OAI22XL U2371 ( .A0(n2298), .A1(n2560), .B0(n2202), .B1(n2562), .Y(n2488) );
  NOR3X1 U2372 ( .A(n1757), .B(n2490), .C(n2491), .Y(n2489) );
  OAI22XL U2373 ( .A0(n2331), .A1(n2556), .B0(n2171), .B1(n2558), .Y(n2490) );
  OAI22XL U2374 ( .A0(n2299), .A1(n2560), .B0(n2203), .B1(n2562), .Y(n2491) );
  NOR3X1 U2375 ( .A(n1762), .B(n2493), .C(n2494), .Y(n2492) );
  OAI22XL U2376 ( .A0(n2332), .A1(n2556), .B0(n2172), .B1(n2558), .Y(n2493) );
  OAI22XL U2377 ( .A0(n2300), .A1(n2560), .B0(n2204), .B1(n2562), .Y(n2494) );
  NOR3X1 U2378 ( .A(n1772), .B(n2496), .C(n2497), .Y(n2495) );
  OAI22XL U2379 ( .A0(n2333), .A1(n2556), .B0(n2173), .B1(n2558), .Y(n2496) );
  OAI22XL U2380 ( .A0(n2301), .A1(n2560), .B0(n2205), .B1(n2562), .Y(n2497) );
  NOR3X1 U2381 ( .A(n1787), .B(n2499), .C(n2500), .Y(n2498) );
  OAI22XL U2382 ( .A0(n2334), .A1(n2556), .B0(n2174), .B1(n2558), .Y(n2499) );
  OAI22XL U2383 ( .A0(n2302), .A1(n2560), .B0(n2206), .B1(n2562), .Y(n2500) );
  NOR3X1 U2384 ( .A(n1792), .B(n2502), .C(n2503), .Y(n2501) );
  OAI22XL U2385 ( .A0(n2335), .A1(n2556), .B0(n2175), .B1(n1681), .Y(n2502) );
  OAI22XL U2386 ( .A0(n2303), .A1(n2560), .B0(n2207), .B1(n1689), .Y(n2503) );
  NOR3X1 U2387 ( .A(n1802), .B(n2505), .C(n2506), .Y(n2504) );
  OAI22XL U2388 ( .A0(n2336), .A1(n2556), .B0(n2176), .B1(n2558), .Y(n2505) );
  OAI22XL U2389 ( .A0(n2304), .A1(n2560), .B0(n2208), .B1(n2562), .Y(n2506) );
  NOR3X1 U2390 ( .A(n1817), .B(n2508), .C(n2509), .Y(n2507) );
  OAI22XL U2391 ( .A0(n2337), .A1(n2556), .B0(n2177), .B1(n2558), .Y(n2508) );
  OAI22XL U2392 ( .A0(n2305), .A1(n2560), .B0(n2209), .B1(n2562), .Y(n2509) );
  NOR3X1 U2393 ( .A(n1822), .B(n2511), .C(n2512), .Y(n2510) );
  OAI22XL U2394 ( .A0(n2338), .A1(n1685), .B0(n2178), .B1(n1681), .Y(n2511) );
  OAI22XL U2395 ( .A0(n2306), .A1(n1693), .B0(n2210), .B1(n1689), .Y(n2512) );
  NOR3X1 U2396 ( .A(n1832), .B(n2514), .C(n2515), .Y(n2513) );
  OAI22XL U2397 ( .A0(n2339), .A1(n2556), .B0(n2179), .B1(n2558), .Y(n2514) );
  OAI22XL U2398 ( .A0(n2307), .A1(n2560), .B0(n2211), .B1(n2562), .Y(n2515) );
  NOR3X1 U2399 ( .A(n1837), .B(n2517), .C(n2518), .Y(n2516) );
  OAI22XL U2400 ( .A0(n2340), .A1(n1685), .B0(n2180), .B1(n1681), .Y(n2517) );
  OAI22XL U2401 ( .A0(n2308), .A1(n1693), .B0(n2212), .B1(n1689), .Y(n2518) );
  NOR3X1 U2402 ( .A(n1847), .B(n2520), .C(n2521), .Y(n2519) );
  OAI22XL U2403 ( .A0(n2341), .A1(n2556), .B0(n2181), .B1(n2558), .Y(n2520) );
  OAI22XL U2404 ( .A0(n2309), .A1(n2560), .B0(n2213), .B1(n2562), .Y(n2521) );
  NOR3X1 U2405 ( .A(n1852), .B(n2523), .C(n2524), .Y(n2522) );
  OAI22XL U2406 ( .A0(n2342), .A1(n1685), .B0(n2182), .B1(n1681), .Y(n2523) );
  OAI22XL U2407 ( .A0(n2310), .A1(n1693), .B0(n2214), .B1(n1689), .Y(n2524) );
  NOR3X1 U2408 ( .A(n1712), .B(n2526), .C(n2527), .Y(n2525) );
  OAI22XL U2409 ( .A0(n2343), .A1(n2556), .B0(n2183), .B1(n2558), .Y(n2526) );
  OAI22XL U2410 ( .A0(n2311), .A1(n2560), .B0(n2215), .B1(n2562), .Y(n2527) );
  NOR3X1 U2411 ( .A(n1727), .B(n2529), .C(n2530), .Y(n2528) );
  OAI22XL U2412 ( .A0(n2344), .A1(n2556), .B0(n2184), .B1(n2558), .Y(n2529) );
  OAI22XL U2413 ( .A0(n2312), .A1(n2560), .B0(n2216), .B1(n2562), .Y(n2530) );
  NOR3X1 U2414 ( .A(n1732), .B(n2532), .C(n2533), .Y(n2531) );
  OAI22XL U2415 ( .A0(n2345), .A1(n2556), .B0(n2185), .B1(n2558), .Y(n2532) );
  OAI22XL U2416 ( .A0(n2313), .A1(n2560), .B0(n2217), .B1(n2562), .Y(n2533) );
  NOR3X1 U2417 ( .A(n1807), .B(n2535), .C(n2536), .Y(n2534) );
  OAI22XL U2418 ( .A0(n2346), .A1(n1685), .B0(n2186), .B1(n1681), .Y(n2535) );
  OAI22XL U2419 ( .A0(n2314), .A1(n1693), .B0(n2218), .B1(n1689), .Y(n2536) );
  NOR3X1 U2420 ( .A(n1862), .B(n2538), .C(n2539), .Y(n2537) );
  OAI22XL U2421 ( .A0(n2347), .A1(n2556), .B0(n2187), .B1(n2558), .Y(n2538) );
  OAI22XL U2422 ( .A0(n2315), .A1(n2560), .B0(n2219), .B1(n2562), .Y(n2539) );
  CLKBUFX3 U2423 ( .A(ReadAddr[0]), .Y(n2540) );
  NAND3BX1 U2424 ( .AN(n2544), .B(WriteAddr[0]), .C(n2543), .Y(n2559) );
  NAND3BX1 U2425 ( .AN(n2543), .B(WriteAddr[0]), .C(n2544), .Y(n2555) );
  NAND3BX1 U2426 ( .AN(n2544), .B(WriteAddr[0]), .C(n2543), .Y(n2560) );
  NAND3BX1 U2427 ( .AN(n2543), .B(WriteAddr[0]), .C(n2544), .Y(n2556) );
  NAND3BX1 U2428 ( .AN(n2544), .B(WriteAddr[0]), .C(n2543), .Y(n1693) );
  NAND3BX1 U2429 ( .AN(n2543), .B(WriteAddr[0]), .C(n2544), .Y(n1685) );
  NAND3BX1 U2430 ( .AN(WriteAddr[0]), .B(n2543), .C(n2544), .Y(n2557) );
  NAND3BX1 U2431 ( .AN(WriteAddr[0]), .B(n2543), .C(n2544), .Y(n1681) );
  NAND3BX1 U2432 ( .AN(WriteAddr[0]), .B(n2543), .C(n2544), .Y(n2558) );
  NAND3BX1 U2433 ( .AN(n2544), .B(n1867), .C(WriteAddr[0]), .Y(n2549) );
  NAND3BX1 U2434 ( .AN(n2544), .B(n1867), .C(WriteAddr[0]), .Y(n2550) );
  NAND3BX1 U2435 ( .AN(n2544), .B(n1867), .C(WriteAddr[0]), .Y(n1701) );
  CLKBUFX3 U2436 ( .A(WriteAddr[1]), .Y(n2543) );
  CLKBUFX3 U2437 ( .A(WriteAddr[2]), .Y(n2544) );
  CLKINVX1 U2438 ( .A(FIFOWrData[31]), .Y(n1626) );
  CLKINVX1 U2439 ( .A(FIFOWrData[30]), .Y(n1628) );
  CLKINVX1 U2440 ( .A(FIFOWrData[29]), .Y(n1632) );
  CLKINVX1 U2441 ( .A(FIFOWrData[28]), .Y(n1634) );
  CLKINVX1 U2442 ( .A(FIFOWrData[27]), .Y(n1636) );
  CLKINVX1 U2443 ( .A(FIFOWrData[26]), .Y(n1638) );
  CLKINVX1 U2444 ( .A(FIFOWrData[25]), .Y(n1640) );
  CLKINVX1 U2445 ( .A(FIFOWrData[24]), .Y(n1642) );
  CLKINVX1 U2446 ( .A(FIFOWrData[23]), .Y(n1644) );
  CLKINVX1 U2447 ( .A(FIFOWrData[22]), .Y(n1646) );
  CLKINVX1 U2448 ( .A(FIFOWrData[21]), .Y(n1648) );
  CLKINVX1 U2449 ( .A(FIFOWrData[20]), .Y(n1650) );
  CLKINVX1 U2450 ( .A(FIFOWrData[19]), .Y(n1654) );
  CLKINVX1 U2451 ( .A(FIFOWrData[18]), .Y(n1656) );
  CLKINVX1 U2452 ( .A(FIFOWrData[17]), .Y(n1658) );
  CLKINVX1 U2453 ( .A(FIFOWrData[16]), .Y(n1660) );
  CLKINVX1 U2454 ( .A(FIFOWrData[15]), .Y(n1662) );
  CLKINVX1 U2455 ( .A(FIFOWrData[14]), .Y(n1664) );
  CLKINVX1 U2456 ( .A(FIFOWrData[13]), .Y(n1666) );
  CLKINVX1 U2457 ( .A(FIFOWrData[12]), .Y(n1668) );
  CLKINVX1 U2458 ( .A(FIFOWrData[11]), .Y(n1670) );
  CLKINVX1 U2459 ( .A(FIFOWrData[10]), .Y(n1672) );
  CLKINVX1 U2460 ( .A(FIFOWrData[9]), .Y(n1610) );
  CLKINVX1 U2461 ( .A(FIFOWrData[8]), .Y(n1614) );
  CLKINVX1 U2462 ( .A(FIFOWrData[7]), .Y(n1616) );
  CLKINVX1 U2463 ( .A(FIFOWrData[6]), .Y(n1618) );
  CLKINVX1 U2464 ( .A(FIFOWrData[5]), .Y(n1620) );
  CLKINVX1 U2465 ( .A(FIFOWrData[4]), .Y(n1622) );
  CLKINVX1 U2466 ( .A(FIFOWrData[3]), .Y(n1624) );
  CLKINVX1 U2467 ( .A(FIFOWrData[2]), .Y(n1630) );
  CLKINVX1 U2468 ( .A(FIFOWrData[1]), .Y(n1652) );
  CLKINVX1 U2469 ( .A(FIFOWrData[0]), .Y(n1674) );
  DFFX1 FIFO_reg ( .D(FIFO88), .CK(Clk), .QN(n2367) );
  DFFX1 FIFO_reg0 ( .D(FIFO880), .CK(Clk), .QN(n2348) );
  DFFX1 FIFO_reg1 ( .D(FIFO881), .CK(Clk), .QN(n2368) );
  DFFX1 FIFO_reg2 ( .D(FIFO882), .CK(Clk), .QN(n2369) );
  DFFX1 FIFO_reg3 ( .D(FIFO883), .CK(Clk), .QN(n2352) );
  DFFX1 FIFO_reg4 ( .D(FIFO884), .CK(Clk), .QN(n2370) );
  DFFX1 FIFO_reg5 ( .D(FIFO885), .CK(Clk), .QN(n2349) );
  DFFX1 FIFO_reg6 ( .D(FIFO886), .CK(Clk), .QN(n2353) );
  DFFX1 FIFO_reg7 ( .D(FIFO887), .CK(Clk), .QN(n2371) );
  DFFX1 FIFO_reg8 ( .D(FIFO888), .CK(Clk), .QN(n2350) );
  DFFX1 FIFO_reg9 ( .D(FIFO889), .CK(Clk), .QN(n2354) );
  DFFX1 FIFO_reg10 ( .D(FIFO8810), .CK(Clk), .QN(n2372) );
  DFFX1 FIFO_reg11 ( .D(FIFO8811), .CK(Clk), .QN(n2355) );
  DFFX1 FIFO_reg12 ( .D(FIFO8812), .CK(Clk), .QN(n2373) );
  DFFX1 FIFO_reg13 ( .D(FIFO8813), .CK(Clk), .QN(n2363) );
  DFFX1 FIFO_reg14 ( .D(FIFO8814), .CK(Clk), .QN(n2356) );
  DFFX1 FIFO_reg15 ( .D(FIFO8815), .CK(Clk), .QN(n2374) );
  DFFX1 FIFO_reg16 ( .D(FIFO8816), .CK(Clk), .QN(n2364) );
  DFFX1 FIFO_reg17 ( .D(FIFO8817), .CK(Clk), .QN(n2357) );
  DFFX1 FIFO_reg18 ( .D(FIFO8818), .CK(Clk), .QN(n2375) );
  DFFX1 FIFO_reg19 ( .D(FIFO8819), .CK(Clk), .QN(n2365) );
  DFFX1 FIFO_reg20 ( .D(FIFO8820), .CK(Clk), .QN(n2358) );
  DFFX1 FIFO_reg21 ( .D(FIFO8821), .CK(Clk), .QN(n2359) );
  DFFX1 FIFO_reg22 ( .D(FIFO8822), .CK(Clk), .QN(n2376) );
  DFFX1 FIFO_reg23 ( .D(FIFO8823), .CK(Clk), .QN(n2351) );
  DFFX1 FIFO_reg24 ( .D(FIFO8824), .CK(Clk), .QN(n2360) );
  DFFX1 FIFO_reg25 ( .D(FIFO8825), .CK(Clk), .QN(n2377) );
  DFFX1 FIFO_reg26 ( .D(FIFO8826), .CK(Clk), .QN(n2378) );
  DFFX1 FIFO_reg27 ( .D(FIFO8827), .CK(Clk), .QN(n2361) );
  DFFX1 FIFO_reg28 ( .D(FIFO8828), .CK(Clk), .QN(n2362) );
  DFFX1 FIFO_reg29 ( .D(FIFO8829), .CK(Clk), .QN(n2366) );
  DFFX1 FIFO_reg30 ( .D(FIFO8830), .CK(Clk), .QN(n2379) );
  DFFX1 FIFO_reg31 ( .D(FIFO8831), .CK(Clk), .QN(n2271) );
  DFFX1 FIFO_reg32 ( .D(FIFO8832), .CK(Clk), .QN(n2252) );
  DFFX1 FIFO_reg33 ( .D(FIFO8833), .CK(Clk), .QN(n2272) );
  DFFX1 FIFO_reg34 ( .D(FIFO8834), .CK(Clk), .QN(n2273) );
  DFFX1 FIFO_reg35 ( .D(FIFO8835), .CK(Clk), .QN(n2253) );
  DFFX1 FIFO_reg36 ( .D(FIFO8836), .CK(Clk), .QN(n2274) );
  DFFX1 FIFO_reg37 ( .D(FIFO8837), .CK(Clk), .QN(n2254) );
  DFFX1 FIFO_reg38 ( .D(FIFO8838), .CK(Clk), .QN(n2255) );
  DFFX1 FIFO_reg39 ( .D(FIFO8839), .CK(Clk), .QN(n2275) );
  DFFX1 FIFO_reg40 ( .D(FIFO8840), .CK(Clk), .QN(n2256) );
  DFFX1 FIFO_reg41 ( .D(FIFO8841), .CK(Clk), .QN(n2257) );
  DFFX1 FIFO_reg42 ( .D(FIFO8842), .CK(Clk), .QN(n2276) );
  DFFX1 FIFO_reg43 ( .D(FIFO8843), .CK(Clk), .QN(n2258) );
  DFFX1 FIFO_reg44 ( .D(FIFO8844), .CK(Clk), .QN(n2277) );
  DFFX1 FIFO_reg45 ( .D(FIFO8845), .CK(Clk), .QN(n2267) );
  DFFX1 FIFO_reg46 ( .D(FIFO8846), .CK(Clk), .QN(n2259) );
  DFFX1 FIFO_reg47 ( .D(FIFO8847), .CK(Clk), .QN(n2278) );
  DFFX1 FIFO_reg48 ( .D(FIFO8848), .CK(Clk), .QN(n2268) );
  DFFX1 FIFO_reg49 ( .D(FIFO8849), .CK(Clk), .QN(n2260) );
  DFFX1 FIFO_reg50 ( .D(FIFO8850), .CK(Clk), .QN(n2279) );
  DFFX1 FIFO_reg51 ( .D(FIFO8851), .CK(Clk), .QN(n2269) );
  DFFX1 FIFO_reg52 ( .D(FIFO8852), .CK(Clk), .QN(n2261) );
  DFFX1 FIFO_reg53 ( .D(FIFO8853), .CK(Clk), .QN(n2262) );
  DFFX1 FIFO_reg54 ( .D(FIFO8854), .CK(Clk), .QN(n2280) );
  DFFX1 FIFO_reg55 ( .D(FIFO8855), .CK(Clk), .QN(n2263) );
  DFFX1 FIFO_reg56 ( .D(FIFO8856), .CK(Clk), .QN(n2264) );
  DFFX1 FIFO_reg57 ( .D(FIFO8857), .CK(Clk), .QN(n2281) );
  DFFX1 FIFO_reg58 ( .D(FIFO8858), .CK(Clk), .QN(n2282) );
  DFFX1 FIFO_reg59 ( .D(FIFO8859), .CK(Clk), .QN(n2265) );
  DFFX1 FIFO_reg60 ( .D(FIFO8860), .CK(Clk), .QN(n2266) );
  DFFX1 FIFO_reg61 ( .D(FIFO8861), .CK(Clk), .QN(n2270) );
  DFFX1 FIFO_reg62 ( .D(FIFO8862), .CK(Clk), .QN(n2283) );
  DFFX1 FIFO_reg63 ( .D(FIFO8863), .CK(Clk), .QN(n2143) );
  DFFX1 FIFO_reg64 ( .D(FIFO8864), .CK(Clk), .QN(n2124) );
  DFFX1 FIFO_reg65 ( .D(FIFO8865), .CK(Clk), .QN(n2144) );
  DFFX1 FIFO_reg66 ( .D(FIFO8866), .CK(Clk), .QN(n2145) );
  DFFX1 FIFO_reg67 ( .D(FIFO8867), .CK(Clk), .QN(n2125) );
  DFFX1 FIFO_reg68 ( .D(FIFO8868), .CK(Clk), .QN(n2146) );
  DFFX1 FIFO_reg69 ( .D(FIFO8869), .CK(Clk), .QN(n2126) );
  DFFX1 FIFO_reg70 ( .D(FIFO8870), .CK(Clk), .QN(n2127) );
  DFFX1 FIFO_reg71 ( .D(FIFO8871), .CK(Clk), .QN(n2147) );
  DFFX1 FIFO_reg72 ( .D(FIFO8872), .CK(Clk), .QN(n2128) );
  DFFX1 FIFO_reg73 ( .D(FIFO8873), .CK(Clk), .QN(n2129) );
  DFFX1 FIFO_reg74 ( .D(FIFO8874), .CK(Clk), .QN(n2148) );
  DFFX1 FIFO_reg75 ( .D(FIFO8875), .CK(Clk), .QN(n2130) );
  DFFX1 FIFO_reg76 ( .D(FIFO8876), .CK(Clk), .QN(n2149) );
  DFFX1 FIFO_reg77 ( .D(FIFO8877), .CK(Clk), .QN(n2139) );
  DFFX1 FIFO_reg78 ( .D(FIFO8878), .CK(Clk), .QN(n2131) );
  DFFX1 FIFO_reg79 ( .D(FIFO8879), .CK(Clk), .QN(n2150) );
  DFFX1 FIFO_reg80 ( .D(FIFO8880), .CK(Clk), .QN(n2140) );
  DFFX1 FIFO_reg81 ( .D(FIFO8881), .CK(Clk), .QN(n2132) );
  DFFX1 FIFO_reg82 ( .D(FIFO8882), .CK(Clk), .QN(n2151) );
  DFFX1 FIFO_reg83 ( .D(FIFO8883), .CK(Clk), .QN(n2141) );
  DFFX1 FIFO_reg84 ( .D(FIFO8884), .CK(Clk), .QN(n2133) );
  DFFX1 FIFO_reg85 ( .D(FIFO8885), .CK(Clk), .QN(n2134) );
  DFFX1 FIFO_reg86 ( .D(FIFO8886), .CK(Clk), .QN(n2152) );
  DFFX1 FIFO_reg87 ( .D(FIFO8887), .CK(Clk), .QN(n2135) );
  DFFX1 FIFO_reg88 ( .D(FIFO8888), .CK(Clk), .QN(n2136) );
  DFFX1 FIFO_reg89 ( .D(FIFO8889), .CK(Clk), .QN(n2153) );
  DFFX1 FIFO_reg90 ( .D(FIFO8890), .CK(Clk), .QN(n2154) );
  DFFX1 FIFO_reg91 ( .D(FIFO8891), .CK(Clk), .QN(n2137) );
  DFFX1 FIFO_reg92 ( .D(FIFO8892), .CK(Clk), .QN(n2138) );
  DFFX1 FIFO_reg93 ( .D(FIFO8893), .CK(Clk), .QN(n2142) );
  DFFX1 FIFO_reg94 ( .D(FIFO8894), .CK(Clk), .QN(n2155) );
  DFFX1 FIFO_reg95 ( .D(FIFO88223), .CK(Clk), .QN(n2239) );
  DFFX1 FIFO_reg96 ( .D(FIFO88224), .CK(Clk), .QN(n2220) );
  DFFX1 FIFO_reg97 ( .D(FIFO88225), .CK(Clk), .QN(n2240) );
  DFFX1 FIFO_reg98 ( .D(FIFO88226), .CK(Clk), .QN(n2241) );
  DFFX1 FIFO_reg99 ( .D(FIFO88227), .CK(Clk), .QN(n2221) );
  DFFX1 FIFO_reg100 ( .D(FIFO88228), .CK(Clk), .QN(n2242) );
  DFFX1 FIFO_reg101 ( .D(FIFO88229), .CK(Clk), .QN(n2222) );
  DFFX1 FIFO_reg102 ( .D(FIFO88230), .CK(Clk), .QN(n2223) );
  DFFX1 FIFO_reg103 ( .D(FIFO88231), .CK(Clk), .QN(n2243) );
  DFFX1 FIFO_reg104 ( .D(FIFO88232), .CK(Clk), .QN(n2224) );
  DFFX1 FIFO_reg105 ( .D(FIFO88233), .CK(Clk), .QN(n2225) );
  DFFX1 FIFO_reg106 ( .D(FIFO88234), .CK(Clk), .QN(n2244) );
  DFFX1 FIFO_reg107 ( .D(FIFO88235), .CK(Clk), .QN(n2226) );
  DFFX1 FIFO_reg108 ( .D(FIFO88236), .CK(Clk), .QN(n2245) );
  DFFX1 FIFO_reg109 ( .D(FIFO88237), .CK(Clk), .QN(n2235) );
  DFFX1 FIFO_reg110 ( .D(FIFO88238), .CK(Clk), .QN(n2227) );
  DFFX1 FIFO_reg111 ( .D(FIFO88239), .CK(Clk), .QN(n2246) );
  DFFX1 FIFO_reg112 ( .D(FIFO88240), .CK(Clk), .QN(n2236) );
  DFFX1 FIFO_reg113 ( .D(FIFO88241), .CK(Clk), .QN(n2228) );
  DFFX1 FIFO_reg114 ( .D(FIFO88242), .CK(Clk), .QN(n2247) );
  DFFX1 FIFO_reg115 ( .D(FIFO88243), .CK(Clk), .QN(n2237) );
  DFFX1 FIFO_reg116 ( .D(FIFO88244), .CK(Clk), .QN(n2229) );
  DFFX1 FIFO_reg117 ( .D(FIFO88245), .CK(Clk), .QN(n2230) );
  DFFX1 FIFO_reg118 ( .D(FIFO88246), .CK(Clk), .QN(n2248) );
  DFFX1 FIFO_reg119 ( .D(FIFO88247), .CK(Clk), .QN(n2231) );
  DFFX1 FIFO_reg120 ( .D(FIFO88248), .CK(Clk), .QN(n2232) );
  DFFX1 FIFO_reg121 ( .D(FIFO88249), .CK(Clk), .QN(n2249) );
  DFFX1 FIFO_reg122 ( .D(FIFO88250), .CK(Clk), .QN(n2250) );
  DFFX1 FIFO_reg123 ( .D(FIFO88251), .CK(Clk), .QN(n2233) );
  DFFX1 FIFO_reg124 ( .D(FIFO88252), .CK(Clk), .QN(n2234) );
  DFFX1 FIFO_reg125 ( .D(FIFO88253), .CK(Clk), .QN(n2238) );
  DFFX1 FIFO_reg126 ( .D(FIFO88254), .CK(Clk), .QN(n2251) );
  DFFX1 FIFO_reg127 ( .D(FIFO8895), .CK(Clk), .QN(n2298) );
  DFFX1 FIFO_reg128 ( .D(FIFO8896), .CK(Clk), .QN(n2284) );
  DFFX1 FIFO_reg129 ( .D(FIFO8897), .CK(Clk), .QN(n2299) );
  DFFX1 FIFO_reg130 ( .D(FIFO8898), .CK(Clk), .QN(n2300) );
  DFFX1 FIFO_reg131 ( .D(FIFO8899), .CK(Clk), .QN(n2285) );
  DFFX1 FIFO_reg132 ( .D(FIFO88100), .CK(Clk), .QN(n2301) );
  DFFX1 FIFO_reg133 ( .D(FIFO88101), .CK(Clk), .QN(n2286) );
  DFFX1 FIFO_reg134 ( .D(FIFO88102), .CK(Clk), .QN(n2287) );
  DFFX1 FIFO_reg135 ( .D(FIFO88103), .CK(Clk), .QN(n2302) );
  DFFX1 FIFO_reg136 ( .D(FIFO88104), .CK(Clk), .QN(n2303) );
  DFFX1 FIFO_reg137 ( .D(FIFO88105), .CK(Clk), .QN(n2288) );
  DFFX1 FIFO_reg138 ( .D(FIFO88106), .CK(Clk), .QN(n2304) );
  DFFX1 FIFO_reg139 ( .D(FIFO88107), .CK(Clk), .QN(n2289) );
  DFFX1 FIFO_reg140 ( .D(FIFO88108), .CK(Clk), .QN(n2305) );
  DFFX1 FIFO_reg141 ( .D(FIFO88109), .CK(Clk), .QN(n2306) );
  DFFX1 FIFO_reg142 ( .D(FIFO88110), .CK(Clk), .QN(n2290) );
  DFFX1 FIFO_reg143 ( .D(FIFO88111), .CK(Clk), .QN(n2307) );
  DFFX1 FIFO_reg144 ( .D(FIFO88112), .CK(Clk), .QN(n2308) );
  DFFX1 FIFO_reg145 ( .D(FIFO88113), .CK(Clk), .QN(n2291) );
  DFFX1 FIFO_reg146 ( .D(FIFO88114), .CK(Clk), .QN(n2309) );
  DFFX1 FIFO_reg147 ( .D(FIFO88115), .CK(Clk), .QN(n2310) );
  DFFX1 FIFO_reg148 ( .D(FIFO88116), .CK(Clk), .QN(n2292) );
  DFFX1 FIFO_reg149 ( .D(FIFO88117), .CK(Clk), .QN(n2293) );
  DFFX1 FIFO_reg150 ( .D(FIFO88118), .CK(Clk), .QN(n2311) );
  DFFX1 FIFO_reg151 ( .D(FIFO88119), .CK(Clk), .QN(n2294) );
  DFFX1 FIFO_reg152 ( .D(FIFO88120), .CK(Clk), .QN(n2295) );
  DFFX1 FIFO_reg153 ( .D(FIFO88121), .CK(Clk), .QN(n2312) );
  DFFX1 FIFO_reg154 ( .D(FIFO88122), .CK(Clk), .QN(n2313) );
  DFFX1 FIFO_reg155 ( .D(FIFO88123), .CK(Clk), .QN(n2296) );
  DFFX1 FIFO_reg156 ( .D(FIFO88124), .CK(Clk), .QN(n2297) );
  DFFX1 FIFO_reg157 ( .D(FIFO88125), .CK(Clk), .QN(n2314) );
  DFFX1 FIFO_reg158 ( .D(FIFO88126), .CK(Clk), .QN(n2315) );
  DFFX1 FIFO_reg159 ( .D(FIFO88127), .CK(Clk), .QN(n2202) );
  DFFX1 FIFO_reg160 ( .D(FIFO88128), .CK(Clk), .QN(n2188) );
  DFFX1 FIFO_reg161 ( .D(FIFO88129), .CK(Clk), .QN(n2203) );
  DFFX1 FIFO_reg162 ( .D(FIFO88130), .CK(Clk), .QN(n2204) );
  DFFX1 FIFO_reg163 ( .D(FIFO88131), .CK(Clk), .QN(n2189) );
  DFFX1 FIFO_reg164 ( .D(FIFO88132), .CK(Clk), .QN(n2205) );
  DFFX1 FIFO_reg165 ( .D(FIFO88133), .CK(Clk), .QN(n2190) );
  DFFX1 FIFO_reg166 ( .D(FIFO88134), .CK(Clk), .QN(n2191) );
  DFFX1 FIFO_reg167 ( .D(FIFO88135), .CK(Clk), .QN(n2206) );
  DFFX1 FIFO_reg168 ( .D(FIFO88136), .CK(Clk), .QN(n2207) );
  DFFX1 FIFO_reg169 ( .D(FIFO88137), .CK(Clk), .QN(n2192) );
  DFFX1 FIFO_reg170 ( .D(FIFO88138), .CK(Clk), .QN(n2208) );
  DFFX1 FIFO_reg171 ( .D(FIFO88139), .CK(Clk), .QN(n2193) );
  DFFX1 FIFO_reg172 ( .D(FIFO88140), .CK(Clk), .QN(n2209) );
  DFFX1 FIFO_reg173 ( .D(FIFO88141), .CK(Clk), .QN(n2210) );
  DFFX1 FIFO_reg174 ( .D(FIFO88142), .CK(Clk), .QN(n2194) );
  DFFX1 FIFO_reg175 ( .D(FIFO88143), .CK(Clk), .QN(n2211) );
  DFFX1 FIFO_reg176 ( .D(FIFO88144), .CK(Clk), .QN(n2212) );
  DFFX1 FIFO_reg177 ( .D(FIFO88145), .CK(Clk), .QN(n2195) );
  DFFX1 FIFO_reg178 ( .D(FIFO88146), .CK(Clk), .QN(n2213) );
  DFFX1 FIFO_reg179 ( .D(FIFO88147), .CK(Clk), .QN(n2214) );
  DFFX1 FIFO_reg180 ( .D(FIFO88148), .CK(Clk), .QN(n2196) );
  DFFX1 FIFO_reg181 ( .D(FIFO88149), .CK(Clk), .QN(n2197) );
  DFFX1 FIFO_reg182 ( .D(FIFO88150), .CK(Clk), .QN(n2215) );
  DFFX1 FIFO_reg183 ( .D(FIFO88151), .CK(Clk), .QN(n2198) );
  DFFX1 FIFO_reg184 ( .D(FIFO88152), .CK(Clk), .QN(n2199) );
  DFFX1 FIFO_reg185 ( .D(FIFO88153), .CK(Clk), .QN(n2216) );
  DFFX1 FIFO_reg186 ( .D(FIFO88154), .CK(Clk), .QN(n2217) );
  DFFX1 FIFO_reg187 ( .D(FIFO88155), .CK(Clk), .QN(n2200) );
  DFFX1 FIFO_reg188 ( .D(FIFO88156), .CK(Clk), .QN(n2201) );
  DFFX1 FIFO_reg189 ( .D(FIFO88157), .CK(Clk), .QN(n2218) );
  DFFX1 FIFO_reg190 ( .D(FIFO88158), .CK(Clk), .QN(n2219) );
  DFFX1 FIFO_reg191 ( .D(FIFO88159), .CK(Clk), .QN(n2330) );
  DFFX1 FIFO_reg192 ( .D(FIFO88160), .CK(Clk), .QN(n2316) );
  DFFX1 FIFO_reg193 ( .D(FIFO88161), .CK(Clk), .QN(n2331) );
  DFFX1 FIFO_reg194 ( .D(FIFO88162), .CK(Clk), .QN(n2332) );
  DFFX1 FIFO_reg195 ( .D(FIFO88163), .CK(Clk), .QN(n2317) );
  DFFX1 FIFO_reg196 ( .D(FIFO88164), .CK(Clk), .QN(n2333) );
  DFFX1 FIFO_reg197 ( .D(FIFO88165), .CK(Clk), .QN(n2318) );
  DFFX1 FIFO_reg198 ( .D(FIFO88166), .CK(Clk), .QN(n2319) );
  DFFX1 FIFO_reg199 ( .D(FIFO88167), .CK(Clk), .QN(n2334) );
  DFFX1 FIFO_reg200 ( .D(FIFO88168), .CK(Clk), .QN(n2335) );
  DFFX1 FIFO_reg201 ( .D(FIFO88169), .CK(Clk), .QN(n2320) );
  DFFX1 FIFO_reg202 ( .D(FIFO88170), .CK(Clk), .QN(n2336) );
  DFFX1 FIFO_reg203 ( .D(FIFO88171), .CK(Clk), .QN(n2321) );
  DFFX1 FIFO_reg204 ( .D(FIFO88172), .CK(Clk), .QN(n2337) );
  DFFX1 FIFO_reg205 ( .D(FIFO88173), .CK(Clk), .QN(n2338) );
  DFFX1 FIFO_reg206 ( .D(FIFO88174), .CK(Clk), .QN(n2322) );
  DFFX1 FIFO_reg207 ( .D(FIFO88175), .CK(Clk), .QN(n2339) );
  DFFX1 FIFO_reg208 ( .D(FIFO88176), .CK(Clk), .QN(n2340) );
  DFFX1 FIFO_reg209 ( .D(FIFO88177), .CK(Clk), .QN(n2323) );
  DFFX1 FIFO_reg210 ( .D(FIFO88178), .CK(Clk), .QN(n2341) );
  DFFX1 FIFO_reg211 ( .D(FIFO88179), .CK(Clk), .QN(n2342) );
  DFFX1 FIFO_reg212 ( .D(FIFO88180), .CK(Clk), .QN(n2324) );
  DFFX1 FIFO_reg213 ( .D(FIFO88181), .CK(Clk), .QN(n2325) );
  DFFX1 FIFO_reg214 ( .D(FIFO88182), .CK(Clk), .QN(n2343) );
  DFFX1 FIFO_reg215 ( .D(FIFO88183), .CK(Clk), .QN(n2326) );
  DFFX1 FIFO_reg216 ( .D(FIFO88184), .CK(Clk), .QN(n2327) );
  DFFX1 FIFO_reg217 ( .D(FIFO88185), .CK(Clk), .QN(n2344) );
  DFFX1 FIFO_reg218 ( .D(FIFO88186), .CK(Clk), .QN(n2345) );
  DFFX1 FIFO_reg219 ( .D(FIFO88187), .CK(Clk), .QN(n2328) );
  DFFX1 FIFO_reg220 ( .D(FIFO88188), .CK(Clk), .QN(n2329) );
  DFFX1 FIFO_reg221 ( .D(FIFO88189), .CK(Clk), .QN(n2346) );
  DFFX1 FIFO_reg222 ( .D(FIFO88190), .CK(Clk), .QN(n2347) );
  DFFX1 FIFO_reg223 ( .D(FIFO88191), .CK(Clk), .QN(n2170) );
  DFFX1 FIFO_reg224 ( .D(FIFO88192), .CK(Clk), .QN(n2156) );
  DFFX1 FIFO_reg225 ( .D(FIFO88193), .CK(Clk), .QN(n2171) );
  DFFX1 FIFO_reg226 ( .D(FIFO88194), .CK(Clk), .QN(n2172) );
  DFFX1 FIFO_reg227 ( .D(FIFO88195), .CK(Clk), .QN(n2157) );
  DFFX1 FIFO_reg228 ( .D(FIFO88196), .CK(Clk), .QN(n2173) );
  DFFX1 FIFO_reg229 ( .D(FIFO88197), .CK(Clk), .QN(n2158) );
  DFFX1 FIFO_reg230 ( .D(FIFO88198), .CK(Clk), .QN(n2159) );
  DFFX1 FIFO_reg231 ( .D(FIFO88199), .CK(Clk), .QN(n2174) );
  DFFX1 FIFO_reg232 ( .D(FIFO88200), .CK(Clk), .QN(n2175) );
  DFFX1 FIFO_reg233 ( .D(FIFO88201), .CK(Clk), .QN(n2160) );
  DFFX1 FIFO_reg234 ( .D(FIFO88202), .CK(Clk), .QN(n2176) );
  DFFX1 FIFO_reg235 ( .D(FIFO88203), .CK(Clk), .QN(n2161) );
  DFFX1 FIFO_reg236 ( .D(FIFO88204), .CK(Clk), .QN(n2177) );
  DFFX1 FIFO_reg237 ( .D(FIFO88205), .CK(Clk), .QN(n2178) );
  DFFX1 FIFO_reg238 ( .D(FIFO88206), .CK(Clk), .QN(n2162) );
  DFFX1 FIFO_reg239 ( .D(FIFO88207), .CK(Clk), .QN(n2179) );
  DFFX1 FIFO_reg240 ( .D(FIFO88208), .CK(Clk), .QN(n2180) );
  DFFX1 FIFO_reg241 ( .D(FIFO88209), .CK(Clk), .QN(n2163) );
  DFFX1 FIFO_reg242 ( .D(FIFO88210), .CK(Clk), .QN(n2181) );
  DFFX1 FIFO_reg243 ( .D(FIFO88211), .CK(Clk), .QN(n2182) );
  DFFX1 FIFO_reg244 ( .D(FIFO88212), .CK(Clk), .QN(n2164) );
  DFFX1 FIFO_reg245 ( .D(FIFO88213), .CK(Clk), .QN(n2165) );
  DFFX1 FIFO_reg246 ( .D(FIFO88214), .CK(Clk), .QN(n2183) );
  DFFX1 FIFO_reg247 ( .D(FIFO88215), .CK(Clk), .QN(n2166) );
  DFFX1 FIFO_reg248 ( .D(FIFO88216), .CK(Clk), .QN(n2167) );
  DFFX1 FIFO_reg249 ( .D(FIFO88217), .CK(Clk), .QN(n2184) );
  DFFX1 FIFO_reg250 ( .D(FIFO88218), .CK(Clk), .QN(n2185) );
  DFFX1 FIFO_reg251 ( .D(FIFO88219), .CK(Clk), .QN(n2168) );
  DFFX1 FIFO_reg252 ( .D(FIFO88220), .CK(Clk), .QN(n2169) );
  DFFX1 FIFO_reg253 ( .D(FIFO88221), .CK(Clk), .QN(n2186) );
  DFFX1 FIFO_reg254 ( .D(FIFO88222), .CK(Clk), .QN(n2187) );
  DFFQX1 FIFORdData_reg_4_ ( .D(FIFORdData486_4_), .CK(Clk), .Q(FIFORdData[4])
         );
  DFFQX1 FIFORdData_reg_5_ ( .D(FIFORdData486_5_), .CK(Clk), .Q(FIFORdData[5])
         );
  DFFQX1 FIFORdData_reg_6_ ( .D(FIFORdData486_6_), .CK(Clk), .Q(FIFORdData[6])
         );
  DFFQX1 FIFORdData_reg_0_ ( .D(FIFORdData486_0_), .CK(Clk), .Q(FIFORdData[0])
         );
endmodule


module PcmFIFOCtl_AW3_0 ( Clki, ReadEni, WriteEni, nRST, Flushi, DataCnt, 
        Fullo, FIFOHalfFull, AlmostEmptyo, Emptyo, EmptyWrSideo, WriteAddro, 
        ReadAddro, ReadAllowo, WriteAllowo );
  output [2:0] DataCnt;
  output [2:0] WriteAddro;
  output [2:0] ReadAddro;
  input Clki, ReadEni, WriteEni, nRST, Flushi;
  output Fullo, FIFOHalfFull, AlmostEmptyo, Emptyo, EmptyWrSideo, ReadAllowo,
         WriteAllowo;
  wire   EmptyWrSideo0, FIFOHalfFull, n662, n663, n664, n665, n666, n667, n668,
         n669, n670, n671, n672, n673, n674, n675, n676, n677, n678, n679,
         n680, n681, n682, n683, n684, n685, n703, n704, n706, n707, n708,
         n709, n711, n714, n715, n717, n721, n725, n726, n731, n732, n733,
         n734, n736, n737, n738, n739, n740, n741, n743, n744, n746, n747,
         n748, n749, n750, n751, n752, n759, n760, n761, n764, n765, n768,
         n769, n772, n773, n774, n775, n776, n777, n778, n779, n780, n781,
         n782, n783, n784, n785, n786, n787, n788, n789, n790, n791, n792,
         n793, n794, n795, n796, n797, n798;
  wire   [2:0] RdAddr;
  wire   [2:0] RdAddrPlusOne;
  wire   [2:0] WrGreyAddr;
  wire   [2:0] WrGreyNext;
  wire   [2:0] RdGreyNext;
  wire   [2:0] RdGreyAddr;
  assign Emptyo = EmptyWrSideo0;
  assign EmptyWrSideo = EmptyWrSideo0;
  assign DataCnt[0] = FIFOHalfFull;

  DFFRX1 WrAddr_reg_0_ ( .D(n685), .CK(Clki), .RN(nRST), .Q(WriteAddro[0]), 
        .QN(n781) );
  XOR2X1 U414 ( .A(WrGreyNext[1]), .B(RdGreyAddr[1]), .Y(n786) );
  XOR2X1 U415 ( .A(WrGreyAddr[1]), .B(RdGreyAddr[1]), .Y(n787) );
  XOR2X1 U416 ( .A(WrGreyAddr[1]), .B(RdGreyNext[1]), .Y(n797) );
  CLKINVX1 U417 ( .A(n759), .Y(ReadAllowo) );
  NAND2BX4 U418 ( .AN(EmptyWrSideo0), .B(ReadEni), .Y(n759) );
  INVXL U419 ( .A(n711), .Y(n736) );
  INVX1 U420 ( .A(n725), .Y(n717) );
  AOI21XL U421 ( .A0(n717), .A1(n789), .B0(n736), .Y(n798) );
  NAND2BXL U422 ( .AN(n789), .B(n717), .Y(n726) );
  CLKINVX1 U423 ( .A(n703), .Y(WriteAllowo) );
  INVX1 U424 ( .A(n726), .Y(n733) );
  AOI33XL U425 ( .A0(RdAddr[2]), .A1(n784), .A2(n717), .B0(RdAddr[1]), .B1(
        n793), .B2(n717), .Y(n721) );
  AOI33XL U426 ( .A0(RdAddr[1]), .A1(n794), .A2(n717), .B0(RdAddr[0]), .B1(
        n784), .B2(n717), .Y(n715) );
  OA22XL U427 ( .A0(FIFOHalfFull), .A1(n739), .B0(n711), .B1(n788), .Y(n740)
         );
  XNOR2XL U428 ( .A(WriteAllowo), .B(ReadAllowo), .Y(n752) );
  NAND2BXL U429 ( .AN(Flushi), .B(ReadAllowo), .Y(n739) );
  AO22X1 U430 ( .A0(RdAddr[2]), .A1(n759), .B0(ReadAllowo), .B1(
        RdAddrPlusOne[2]), .Y(ReadAddro[2]) );
  AO22X1 U431 ( .A0(RdAddr[1]), .A1(n759), .B0(ReadAllowo), .B1(
        RdAddrPlusOne[1]), .Y(ReadAddro[1]) );
  AOI211XL U432 ( .A0(n711), .A1(n739), .B0(FIFOHalfFull), .C0(n737), .Y(n738)
         );
  OAI31XL U433 ( .A0(n773), .A1(WriteAddro[2]), .A2(n781), .B0(n734), .Y(n706)
         );
  NAND2BX1 U434 ( .AN(ReadAllowo), .B(n714), .Y(n711) );
  OAI222XL U435 ( .A0(n784), .A1(n711), .B0(n773), .B1(n714), .C0(n725), .C1(
        n791), .Y(n675) );
  OAI222XL U436 ( .A0(n772), .A1(n711), .B0(n774), .B1(n714), .C0(n725), .C1(
        n783), .Y(n662) );
  OAI222XL U437 ( .A0(n775), .A1(n711), .B0(n779), .B1(n714), .C0(n725), .C1(
        n792), .Y(n664) );
  OAI222XL U438 ( .A0(n711), .A1(n793), .B0(n777), .B1(n714), .C0(n725), .C1(
        n782), .Y(n674) );
  OAI222XL U439 ( .A0(n711), .A1(n783), .B0(n776), .B1(n714), .C0(n725), .C1(
        n793), .Y(n677) );
  OAI221XL U440 ( .A0(n781), .A1(n714), .B0(n794), .B1(n711), .C0(n726), .Y(
        n676) );
  CLKINVX1 U441 ( .A(n744), .Y(n737) );
  CLKINVX1 U442 ( .A(n739), .Y(n751) );
  XNOR2X1 U443 ( .A(WriteAllowo), .B(n781), .Y(n685) );
  OAI33X1 U444 ( .A0(n768), .A1(n792), .A2(n779), .B0(n768), .B1(WrGreyAddr[0]), .B2(RdGreyNext[0]), .Y(AlmostEmptyo) );
  NAND2BX1 U445 ( .AN(Flushi), .B(n711), .Y(n725) );
  NAND2BX1 U446 ( .AN(Flushi), .B(n752), .Y(n744) );
  OAI221XL U447 ( .A0(FIFOHalfFull), .A1(n711), .B0(n788), .B1(n739), .C0(n744), .Y(n743) );
  AO22X1 U448 ( .A0(RdAddr[0]), .A1(n759), .B0(ReadAllowo), .B1(
        RdAddrPlusOne[0]), .Y(ReadAddro[0]) );
  OAI222XL U449 ( .A0(n711), .A1(n789), .B0(WriteAddro[0]), .B1(n714), .C0(
        RdAddrPlusOne[0]), .C1(n725), .Y(n673) );
  OAI222XL U450 ( .A0(n708), .A1(n714), .B0(RdAddrPlusOne[1]), .B1(n726), .C0(
        n798), .C1(n791), .Y(n672) );
  OAI222XL U451 ( .A0(n795), .A1(n711), .B0(n778), .B1(n714), .C0(n725), .C1(
        n785), .Y(n663) );
  OAI221XL U452 ( .A0(n711), .A1(n792), .B0(n780), .B1(n714), .C0(n715), .Y(
        n679) );
  OAI32X1 U453 ( .A0(n740), .A1(DataCnt[1]), .A2(n737), .B0(n741), .B1(n790), 
        .Y(n669) );
  CLKINVX1 U454 ( .A(n743), .Y(n741) );
  OAI221XL U455 ( .A0(n798), .A1(n782), .B0(n731), .B1(n714), .C0(n732), .Y(
        n671) );
  CLKINVX1 U456 ( .A(n706), .Y(n731) );
  AOI33X1 U457 ( .A0(RdAddrPlusOne[1]), .A1(n782), .A2(n733), .B0(
        RdAddrPlusOne[2]), .B1(n791), .B2(n717), .Y(n732) );
  OAI221XL U458 ( .A0(n711), .A1(n785), .B0(n796), .B1(n714), .C0(n721), .Y(
        n678) );
  AO21X1 U459 ( .A0(FIFOHalfFull), .A1(n737), .B0(n738), .Y(n670) );
  OAI211X1 U460 ( .A0(n746), .A1(n747), .B0(n748), .C0(n749), .Y(n668) );
  NAND3BX1 U461 ( .AN(n788), .B(DataCnt[1]), .C(n736), .Y(n746) );
  NAND2BX1 U462 ( .AN(DataCnt[2]), .B(n744), .Y(n747) );
  AOI33X1 U463 ( .A0(n750), .A1(n744), .A2(n751), .B0(DataCnt[1]), .B1(
        DataCnt[2]), .B2(n751), .Y(n748) );
  AOI32X1 U464 ( .A0(DataCnt[2]), .A1(n790), .A2(n736), .B0(DataCnt[2]), .B1(
        n743), .Y(n749) );
  NAND2BX1 U465 ( .AN(Fullo), .B(WriteEni), .Y(n703) );
  OAI33X1 U466 ( .A0(n760), .A1(n780), .A2(n775), .B0(n760), .B1(WrGreyNext[0]), .B2(RdGreyAddr[0]), .Y(Fullo) );
  CLKINVX1 U467 ( .A(n761), .Y(n760) );
  OAI33X1 U468 ( .A0(n786), .A1(n772), .A2(n776), .B0(n786), .B1(WrGreyNext[2]), .B2(RdGreyAddr[2]), .Y(n761) );
  OAI33X1 U469 ( .A0(n764), .A1(n779), .A2(n775), .B0(n764), .B1(WrGreyAddr[0]), .B2(RdGreyAddr[0]), .Y(EmptyWrSideo0) );
  CLKINVX1 U470 ( .A(n765), .Y(n764) );
  OAI33X1 U471 ( .A0(n787), .A1(n772), .A2(n774), .B0(n787), .B1(WrGreyAddr[2]), .B2(RdGreyAddr[2]), .Y(n765) );
  AO22X1 U472 ( .A0(WrGreyNext[0]), .A1(n703), .B0(WriteAllowo), .B1(n707), 
        .Y(n682) );
  CLKINVX1 U473 ( .A(n708), .Y(n707) );
  AO22X1 U474 ( .A0(WrGreyNext[2]), .A1(n703), .B0(WriteAddro[2]), .B1(
        WriteAllowo), .Y(n680) );
  AO22X1 U475 ( .A0(WriteAddro[2]), .A1(n703), .B0(WriteAllowo), .B1(n706), 
        .Y(n683) );
  AO22X1 U476 ( .A0(WrGreyAddr[2]), .A1(n703), .B0(WriteAllowo), .B1(
        WrGreyNext[2]), .Y(n665) );
  AO22X1 U477 ( .A0(WrGreyAddr[1]), .A1(n703), .B0(WriteAllowo), .B1(
        WrGreyNext[1]), .Y(n666) );
  AO22X1 U478 ( .A0(WrGreyAddr[0]), .A1(n703), .B0(WriteAllowo), .B1(
        WrGreyNext[0]), .Y(n667) );
  OAI31XL U479 ( .A0(n703), .A1(WriteAddro[1]), .A2(n781), .B0(n704), .Y(n684)
         );
  OA22X1 U480 ( .A0(WriteAddro[0]), .A1(n773), .B0(WriteAllowo), .B1(n773), 
        .Y(n704) );
  AO21X1 U481 ( .A0(WrGreyNext[1]), .A1(n703), .B0(n709), .Y(n681) );
  OAI33X1 U482 ( .A0(n703), .A1(WriteAddro[2]), .A2(n773), .B0(n703), .B1(
        WriteAddro[1]), .B2(n777), .Y(n709) );
  XNOR2X1 U483 ( .A(WriteAddro[1]), .B(WriteAddro[0]), .Y(n708) );
  OA22X1 U484 ( .A0(WriteAddro[1]), .A1(n777), .B0(WriteAddro[0]), .B1(n777), 
        .Y(n734) );
  NOR3BXL U485 ( .AN(n788), .B(DataCnt[1]), .C(DataCnt[2]), .Y(n750) );
  CLKINVX1 U486 ( .A(Flushi), .Y(n714) );
  CLKINVX1 U487 ( .A(n769), .Y(n768) );
  OAI33X1 U488 ( .A0(n797), .A1(n774), .A2(n783), .B0(n797), .B1(WrGreyAddr[2]), .B2(RdGreyNext[2]), .Y(n769) );
  DFFRX1 WrGreyAddr_reg_1_ ( .D(n666), .CK(Clki), .RN(nRST), .Q(WrGreyAddr[1]), 
        .QN(n778) );
  DFFRX1 RdGreyAddr_reg_1_ ( .D(n663), .CK(Clki), .RN(nRST), .Q(RdGreyAddr[1]), 
        .QN(n795) );
  DFFRX1 WrGreyNext_reg_1_ ( .D(n681), .CK(Clki), .RN(nRST), .Q(WrGreyNext[1]), 
        .QN(n796) );
  DFFRX1 WrGreyNext_reg_2_ ( .D(n680), .CK(Clki), .RN(nRST), .Q(WrGreyNext[2]), 
        .QN(n776) );
  DFFRX1 RdGreyAddr_reg_2_ ( .D(n662), .CK(Clki), .RN(nRST), .Q(RdGreyAddr[2]), 
        .QN(n772) );
  DFFSX1 WrGreyNext_reg_0_ ( .D(n682), .CK(Clki), .SN(nRST), .Q(WrGreyNext[0]), 
        .QN(n780) );
  DFFRX1 WrGreyAddr_reg_2_ ( .D(n665), .CK(Clki), .RN(nRST), .Q(WrGreyAddr[2]), 
        .QN(n774) );
  DFFRX1 WrGreyAddr_reg_0_ ( .D(n667), .CK(Clki), .RN(nRST), .Q(WrGreyAddr[0]), 
        .QN(n779) );
  DFFRX1 RdGreyAddr_reg_0_ ( .D(n664), .CK(Clki), .RN(nRST), .Q(RdGreyAddr[0]), 
        .QN(n775) );
  DFFSX1 WrAddr_reg_1_ ( .D(n684), .CK(Clki), .SN(nRST), .Q(WriteAddro[1]), 
        .QN(n773) );
  DFFRX1 DataCnt_reg_1_ ( .D(n669), .CK(Clki), .RN(nRST), .Q(DataCnt[1]), .QN(
        n790) );
  DFFRX1 WrAddr_reg_2_ ( .D(n683), .CK(Clki), .RN(nRST), .Q(WriteAddro[2]), 
        .QN(n777) );
  DFFRX1 DataCnt_reg_0_ ( .D(n670), .CK(Clki), .RN(nRST), .Q(FIFOHalfFull), 
        .QN(n788) );
  DFFSX1 RdAddr_reg_1_ ( .D(n675), .CK(Clki), .SN(nRST), .Q(RdAddr[1]), .QN(
        n784) );
  DFFSX1 RdAddrPlusOne_reg_1_ ( .D(n672), .CK(Clki), .SN(nRST), .Q(
        RdAddrPlusOne[1]), .QN(n791) );
  DFFSX1 RdAddrPlusOne_reg_0_ ( .D(n673), .CK(Clki), .SN(nRST), .Q(
        RdAddrPlusOne[0]), .QN(n789) );
  DFFRX1 RdAddr_reg_2_ ( .D(n674), .CK(Clki), .RN(nRST), .Q(RdAddr[2]), .QN(
        n793) );
  DFFRX1 RdAddr_reg_0_ ( .D(n676), .CK(Clki), .RN(nRST), .Q(RdAddr[0]), .QN(
        n794) );
  DFFRX1 RdAddrPlusOne_reg_2_ ( .D(n671), .CK(Clki), .RN(nRST), .Q(
        RdAddrPlusOne[2]), .QN(n782) );
  DFFRX1 DataCnt_reg_2_ ( .D(n668), .CK(Clki), .RN(nRST), .Q(DataCnt[2]) );
  DFFRX1 RdGreyNext_reg_1_ ( .D(n678), .CK(Clki), .RN(nRST), .Q(RdGreyNext[1]), 
        .QN(n785) );
  DFFSX1 RdGreyNext_reg_0_ ( .D(n679), .CK(Clki), .SN(nRST), .Q(RdGreyNext[0]), 
        .QN(n792) );
  DFFRX1 RdGreyNext_reg_2_ ( .D(n677), .CK(Clki), .RN(nRST), .Q(RdGreyNext[2]), 
        .QN(n783) );
endmodule


module PcmFIFO_FIFO_AW3_FIFO_DW32 ( Clk, nRST, FIFOWrite, FIFOWrData, FIFORead, 
        FIFORdData, FIFOFlush, FIFOFull, FIFOHalfFull, FIFOAlmostEmpty, 
        FIFOEmpty, FIFOEmptyWr, FIFODataCnt );
  input [31:0] FIFOWrData;
  output [31:0] FIFORdData;
  output [2:0] FIFODataCnt;
  input Clk, nRST, FIFOWrite, FIFORead, FIFOFlush;
  output FIFOFull, FIFOHalfFull, FIFOAlmostEmpty, FIFOEmpty, FIFOEmptyWr;
  wire   WriteAllow, FIFO88, FIFO880, FIFO881, FIFO882, FIFO883, FIFO884,
         FIFO885, FIFO886, FIFO887, FIFO888, FIFO889, FIFO8810, FIFO8811,
         FIFO8812, FIFO8813, FIFO8814, FIFO8815, FIFO8816, FIFO8817, FIFO8818,
         FIFO8819, FIFO8820, FIFO8821, FIFO8822, FIFO8823, FIFO8824, FIFO8825,
         FIFO8826, FIFO8827, FIFO8828, FIFO8829, FIFO8830, FIFO8831, FIFO8832,
         FIFO8833, FIFO8834, FIFO8835, FIFO8836, FIFO8837, FIFO8838, FIFO8839,
         FIFO8840, FIFO8841, FIFO8842, FIFO8843, FIFO8844, FIFO8845, FIFO8846,
         FIFO8847, FIFO8848, FIFO8849, FIFO8850, FIFO8851, FIFO8852, FIFO8853,
         FIFO8854, FIFO8855, FIFO8856, FIFO8857, FIFO8858, FIFO8859, FIFO8860,
         FIFO8861, FIFO8862, FIFO8863, FIFO8864, FIFO8865, FIFO8866, FIFO8867,
         FIFO8868, FIFO8869, FIFO8870, FIFO8871, FIFO8872, FIFO8873, FIFO8874,
         FIFO8875, FIFO8876, FIFO8877, FIFO8878, FIFO8879, FIFO8880, FIFO8881,
         FIFO8882, FIFO8883, FIFO8884, FIFO8885, FIFO8886, FIFO8887, FIFO8888,
         FIFO8889, FIFO8890, FIFO8891, FIFO8892, FIFO8893, FIFO8894, FIFO8895,
         FIFO8896, FIFO8897, FIFO8898, FIFO8899, FIFO88100, FIFO88101,
         FIFO88102, FIFO88103, FIFO88104, FIFO88105, FIFO88106, FIFO88107,
         FIFO88108, FIFO88109, FIFO88110, FIFO88111, FIFO88112, FIFO88113,
         FIFO88114, FIFO88115, FIFO88116, FIFO88117, FIFO88118, FIFO88119,
         FIFO88120, FIFO88121, FIFO88122, FIFO88123, FIFO88124, FIFO88125,
         FIFO88126, FIFO88127, FIFO88128, FIFO88129, FIFO88130, FIFO88131,
         FIFO88132, FIFO88133, FIFO88134, FIFO88135, FIFO88136, FIFO88137,
         FIFO88138, FIFO88139, FIFO88140, FIFO88141, FIFO88142, FIFO88143,
         FIFO88144, FIFO88145, FIFO88146, FIFO88147, FIFO88148, FIFO88149,
         FIFO88150, FIFO88151, FIFO88152, FIFO88153, FIFO88154, FIFO88155,
         FIFO88156, FIFO88157, FIFO88158, FIFO88159, FIFO88160, FIFO88161,
         FIFO88162, FIFO88163, FIFO88164, FIFO88165, FIFO88166, FIFO88167,
         FIFO88168, FIFO88169, FIFO88170, FIFO88171, FIFO88172, FIFO88173,
         FIFO88174, FIFO88175, FIFO88176, FIFO88177, FIFO88178, FIFO88179,
         FIFO88180, FIFO88181, FIFO88182, FIFO88183, FIFO88184, FIFO88185,
         FIFO88186, FIFO88187, FIFO88188, FIFO88189, FIFO88190, FIFO88191,
         FIFO88192, FIFO88193, FIFO88194, FIFO88195, FIFO88196, FIFO88197,
         FIFO88198, FIFO88199, FIFO88200, FIFO88201, FIFO88202, FIFO88203,
         FIFO88204, FIFO88205, FIFO88206, FIFO88207, FIFO88208, FIFO88209,
         FIFO88210, FIFO88211, FIFO88212, FIFO88213, FIFO88214, FIFO88215,
         FIFO88216, FIFO88217, FIFO88218, FIFO88219, FIFO88220, FIFO88221,
         FIFO88222, FIFO88223, FIFO88224, FIFO88225, FIFO88226, FIFO88227,
         FIFO88228, FIFO88229, FIFO88230, FIFO88231, FIFO88232, FIFO88233,
         FIFO88234, FIFO88235, FIFO88236, FIFO88237, FIFO88238, FIFO88239,
         FIFO88240, FIFO88241, FIFO88242, FIFO88243, FIFO88244, FIFO88245,
         FIFO88246, FIFO88247, FIFO88248, FIFO88249, FIFO88250, FIFO88251,
         FIFO88252, FIFO88253, FIFO88254, FIFORdData486_31_, FIFORdData486_30_,
         FIFORdData486_29_, FIFORdData486_28_, FIFORdData486_27_,
         FIFORdData486_26_, FIFORdData486_25_, FIFORdData486_24_,
         FIFORdData486_23_, FIFORdData486_22_, FIFORdData486_21_,
         FIFORdData486_20_, FIFORdData486_19_, FIFORdData486_18_,
         FIFORdData486_17_, FIFORdData486_16_, FIFORdData486_15_,
         FIFORdData486_14_, FIFORdData486_13_, FIFORdData486_12_,
         FIFORdData486_11_, FIFORdData486_10_, FIFORdData486_9_,
         FIFORdData486_8_, FIFORdData486_7_, FIFORdData486_6_,
         FIFORdData486_5_, FIFORdData486_4_, FIFORdData486_3_,
         FIFORdData486_2_, FIFORdData486_1_, FIFORdData486_0_, n1215, n1216,
         n1217, n1218, n1220, n1222, n1224, n1226, n1228, n1230, n1231, n1233,
         n1235, n1236, n1237, n1244, n1247, n1248, n1249, n1256, n1259, n1260,
         n1261, n1268, n1271, n1272, n1273, n1280, n1283, n1284, n1285, n1292,
         n1295, n1296, n1297, n1304, n1307, n1308, n1309, n1316, n1319, n1320,
         n1321, n1328, n1331, n1332, n1333, n1340, n1343, n1344, n1345, n1352,
         n1355, n1356, n1357, n1364, n1367, n1368, n1369, n1376, n1379, n1380,
         n1381, n1388, n1391, n1392, n1393, n1400, n1403, n1404, n1405, n1412,
         n1415, n1416, n1417, n1424, n1427, n1428, n1429, n1436, n1439, n1440,
         n1441, n1448, n1451, n1452, n1453, n1460, n1463, n1464, n1465, n1472,
         n1475, n1476, n1477, n1484, n1487, n1488, n1489, n1496, n1499, n1500,
         n1501, n1508, n1511, n1512, n1513, n1520, n1523, n1524, n1525, n1532,
         n1535, n1536, n1537, n1544, n1547, n1548, n1549, n1556, n1559, n1560,
         n1561, n1568, n1571, n1572, n1573, n1580, n1583, n1584, n1585, n1592,
         n1595, n1596, n1597, n1600, n1605, n1608, n1609, n1610, n1611, n1613,
         n1614, n1616, n1618, n1620, n1622, n1624, n1626, n1628, n1630, n1632,
         n1634, n1636, n1638, n1640, n1642, n1644, n1646, n1648, n1650, n1652,
         n1654, n1656, n1658, n1660, n1662, n1664, n1666, n1668, n1670, n1672,
         n1674, n1676, n1677, n1678, n1679, n1680, n1681, n1682, n1683, n1684,
         n1685, n1686, n1687, n1688, n1689, n1690, n1691, n1692, n1693, n1694,
         n1695, n1696, n1697, n1698, n1699, n1700, n1701, n1702, n1703, n1704,
         n1706, n1709, n1710, n1712, n1715, n1717, n1720, n1722, n1725, n1727,
         n1730, n1732, n1735, n1737, n1740, n1742, n1745, n1747, n1750, n1752,
         n1755, n1757, n1760, n1762, n1765, n1767, n1770, n1772, n1775, n1777,
         n1780, n1782, n1785, n1787, n1790, n1792, n1795, n1797, n1800, n1802,
         n1805, n1807, n1810, n1812, n1815, n1817, n1820, n1822, n1825, n1827,
         n1830, n1832, n1835, n1837, n1840, n1842, n1845, n1847, n1850, n1852,
         n1855, n1857, n1860, n1862, n1865, n1866, n1867, n2124, n2125, n2126,
         n2127, n2128, n2129, n2130, n2131, n2132, n2133, n2134, n2135, n2136,
         n2137, n2138, n2139, n2140, n2141, n2142, n2143, n2144, n2145, n2146,
         n2147, n2148, n2149, n2150, n2151, n2152, n2153, n2154, n2155, n2156,
         n2157, n2158, n2159, n2160, n2161, n2162, n2163, n2164, n2165, n2166,
         n2167, n2168, n2169, n2170, n2171, n2172, n2173, n2174, n2175, n2176,
         n2177, n2178, n2179, n2180, n2181, n2182, n2183, n2184, n2185, n2186,
         n2187, n2188, n2189, n2190, n2191, n2192, n2193, n2194, n2195, n2196,
         n2197, n2198, n2199, n2200, n2201, n2202, n2203, n2204, n2205, n2206,
         n2207, n2208, n2209, n2210, n2211, n2212, n2213, n2214, n2215, n2216,
         n2217, n2218, n2219, n2220, n2221, n2222, n2223, n2224, n2225, n2226,
         n2227, n2228, n2229, n2230, n2231, n2232, n2233, n2234, n2235, n2236,
         n2237, n2238, n2239, n2240, n2241, n2242, n2243, n2244, n2245, n2246,
         n2247, n2248, n2249, n2250, n2251, n2252, n2253, n2254, n2255, n2256,
         n2257, n2258, n2259, n2260, n2261, n2262, n2263, n2264, n2265, n2266,
         n2267, n2268, n2269, n2270, n2271, n2272, n2273, n2274, n2275, n2276,
         n2277, n2278, n2279, n2280, n2281, n2282, n2283, n2284, n2285, n2286,
         n2287, n2288, n2289, n2290, n2291, n2292, n2293, n2294, n2295, n2296,
         n2297, n2298, n2299, n2300, n2301, n2302, n2303, n2304, n2305, n2306,
         n2307, n2308, n2309, n2310, n2311, n2312, n2313, n2314, n2315, n2316,
         n2317, n2318, n2319, n2320, n2321, n2322, n2323, n2324, n2325, n2326,
         n2327, n2328, n2329, n2330, n2331, n2332, n2333, n2334, n2335, n2336,
         n2337, n2338, n2339, n2340, n2341, n2342, n2343, n2344, n2345, n2346,
         n2347, n2348, n2349, n2350, n2351, n2352, n2353, n2354, n2355, n2356,
         n2357, n2358, n2359, n2360, n2361, n2362, n2363, n2364, n2365, n2366,
         n2367, n2368, n2369, n2370, n2371, n2372, n2373, n2374, n2375, n2376,
         n2377, n2378, n2379, n2380, n2381, n2382, n2383, n2384, n2385, n2386,
         n2387, n2388, n2389, n2390, n2391, n2392, n2393, n2394, n2395, n2396,
         n2397, n2398, n2399, n2400, n2401, n2402, n2403, n2404, n2405, n2406,
         n2407, n2408, n2409, n2410, n2411, n2412, n2413, n2414, n2415, n2416,
         n2417, n2418, n2419, n2420, n2421, n2422, n2423, n2424, n2425, n2426,
         n2427, n2428, n2429, n2430, n2431, n2432, n2433, n2434, n2435, n2436,
         n2437, n2438, n2439, n2440, n2441, n2442, n2443, n2444, n2445, n2446,
         n2447, n2448, n2449, n2450, n2451, n2452, n2453, n2454, n2455, n2456,
         n2457, n2458, n2459, n2460, n2461, n2462, n2463, n2464, n2465, n2466,
         n2467, n2468, n2469, n2470, n2471, n2472, n2473, n2474, n2475, n2476,
         n2477, n2478, n2479, n2480, n2481, n2482, n2483, n2484, n2485, n2486,
         n2487, n2488, n2489, n2490, n2491, n2492, n2493, n2494, n2495, n2496,
         n2497, n2498, n2499, n2500, n2501, n2502, n2503, n2504, n2505, n2506,
         n2507, n2508, n2509, n2510, n2511, n2512, n2513, n2514, n2515, n2516,
         n2517, n2518, n2519, n2520, n2521, n2522, n2523, n2524, n2525, n2526,
         n2527, n2528, n2529, n2530, n2531, n2532, n2533, n2534, n2535, n2536,
         n2537, n2538, n2539, n2540, n2541, n2542, n2543, n2544;
  wire   [2:0] ReadAddr;
  wire   [2:0] WriteAddr;

  PcmFIFOCtl_AW3 FIFOCtl ( .Clki(Clk), .ReadEni(FIFORead), .WriteEni(FIFOWrite), .nRST(nRST), .Flushi(FIFOFlush), .DataCnt(FIFODataCnt), .Fullo(FIFOFull), 
        .FIFOHalfFull(FIFOHalfFull), .AlmostEmptyo(FIFOAlmostEmpty), .Emptyo(
        FIFOEmpty), .EmptyWrSideo(FIFOEmptyWr), .WriteAddro(WriteAddr), 
        .ReadAddro(ReadAddr), .WriteAllowo(WriteAllow) );
  CLKINVX1 U1755 ( .A(n1689), .Y(n1687) );
  CLKINVX1 U1756 ( .A(WriteAllow), .Y(n1676) );
  CLKINVX1 U1757 ( .A(n1677), .Y(n1611) );
  CLKINVX1 U1758 ( .A(n1710), .Y(n1702) );
  CLKINVX1 U1759 ( .A(n2476), .Y(n1600) );
  CLKINVX1 U1760 ( .A(n1681), .Y(n1679) );
  CLKINVX1 U1761 ( .A(n1693), .Y(n1691) );
  CLKINVX1 U1762 ( .A(n1685), .Y(n1683) );
  CLKINVX1 U1763 ( .A(n1697), .Y(n1695) );
  CLKINVX1 U1764 ( .A(n1701), .Y(n1699) );
  CLKINVX1 U1765 ( .A(WriteAddr[0]), .Y(n1865) );
  NAND2BX1 U1766 ( .AN(n1676), .B(n1702), .Y(n2483) );
  NAND2BX1 U1767 ( .AN(n1676), .B(n1702), .Y(n2484) );
  NAND2BX1 U1768 ( .AN(n1676), .B(n1687), .Y(n2513) );
  NAND2BX1 U1769 ( .AN(n1676), .B(n1687), .Y(n2514) );
  NAND2BX1 U1770 ( .AN(n1676), .B(n1702), .Y(n1703) );
  NAND2BX1 U1771 ( .AN(n1676), .B(n1611), .Y(n2525) );
  NAND2BX1 U1772 ( .AN(n1676), .B(n1611), .Y(n2526) );
  NAND2BX1 U1773 ( .AN(n1676), .B(n1687), .Y(n1686) );
  NAND2BX1 U1774 ( .AN(n1676), .B(n1611), .Y(n1609) );
  NAND2BX1 U1775 ( .AN(WriteAllow), .B(n1687), .Y(n2515) );
  NAND2BX1 U1776 ( .AN(WriteAllow), .B(n1687), .Y(n2516) );
  NAND2BX1 U1777 ( .AN(WriteAllow), .B(n1679), .Y(n2523) );
  NAND2BX1 U1778 ( .AN(WriteAllow), .B(n1679), .Y(n2524) );
  NAND2BX1 U1779 ( .AN(WriteAllow), .B(n1702), .Y(n2499) );
  NAND2BX1 U1780 ( .AN(WriteAllow), .B(n1702), .Y(n2500) );
  NAND2BX1 U1781 ( .AN(WriteAllow), .B(n1691), .Y(n2511) );
  NAND2BX1 U1782 ( .AN(WriteAllow), .B(n1691), .Y(n2512) );
  NAND2BX1 U1783 ( .AN(WriteAllow), .B(n1683), .Y(n2519) );
  NAND2BX1 U1784 ( .AN(WriteAllow), .B(n1683), .Y(n2520) );
  NAND2BX1 U1785 ( .AN(WriteAllow), .B(n1611), .Y(n2527) );
  NAND2BX1 U1786 ( .AN(WriteAllow), .B(n1611), .Y(n2528) );
  NAND2BX1 U1787 ( .AN(WriteAllow), .B(n1695), .Y(n2507) );
  NAND2BX1 U1788 ( .AN(WriteAllow), .B(n1695), .Y(n2508) );
  NAND2BX1 U1789 ( .AN(n1676), .B(n1679), .Y(n2521) );
  NAND2BX1 U1790 ( .AN(n1676), .B(n1679), .Y(n2522) );
  NAND2BX1 U1791 ( .AN(n1676), .B(n1691), .Y(n2509) );
  NAND2BX1 U1792 ( .AN(n1676), .B(n1691), .Y(n2510) );
  NAND2BX1 U1793 ( .AN(n1676), .B(n1683), .Y(n2517) );
  NAND2BX1 U1794 ( .AN(n1676), .B(n1683), .Y(n2518) );
  NAND2BX1 U1795 ( .AN(n1676), .B(n1695), .Y(n2505) );
  NAND2BX1 U1796 ( .AN(n1676), .B(n1695), .Y(n2506) );
  NAND2BX1 U1797 ( .AN(WriteAllow), .B(n1687), .Y(n1688) );
  NAND2BX1 U1798 ( .AN(WriteAllow), .B(n1679), .Y(n1680) );
  NAND2BX1 U1799 ( .AN(WriteAllow), .B(n1702), .Y(n1704) );
  NAND2BX1 U1800 ( .AN(WriteAllow), .B(n1691), .Y(n1692) );
  NAND2BX1 U1801 ( .AN(WriteAllow), .B(n1683), .Y(n1684) );
  NAND2BX1 U1802 ( .AN(WriteAllow), .B(n1611), .Y(n1613) );
  NAND2BX1 U1803 ( .AN(WriteAllow), .B(n1695), .Y(n1696) );
  NAND2BX1 U1804 ( .AN(n1676), .B(n1679), .Y(n1678) );
  NAND2BX1 U1805 ( .AN(n1676), .B(n1691), .Y(n1690) );
  NAND2BX1 U1806 ( .AN(n1676), .B(n1683), .Y(n1682) );
  NAND2BX1 U1807 ( .AN(n1676), .B(n1695), .Y(n1694) );
  NAND3BX1 U1808 ( .AN(n2478), .B(n1608), .C(n1600), .Y(n2533) );
  NAND3BX1 U1809 ( .AN(n2478), .B(n1608), .C(n1600), .Y(n2534) );
  NAND3BX1 U1810 ( .AN(n2477), .B(n1600), .C(n2478), .Y(n2541) );
  NAND3BX1 U1811 ( .AN(n2477), .B(n1600), .C(n2478), .Y(n2542) );
  NAND3BX1 U1812 ( .AN(n2478), .B(n1608), .C(n2476), .Y(n2535) );
  NAND3BX1 U1813 ( .AN(n2478), .B(n1608), .C(n2476), .Y(n2536) );
  NAND3BX1 U1814 ( .AN(n2477), .B(n2476), .C(n2478), .Y(n2543) );
  NAND3BX1 U1815 ( .AN(n1600), .B(n2477), .C(n2478), .Y(n2539) );
  NAND3BX1 U1816 ( .AN(n2477), .B(n2476), .C(n2478), .Y(n2544) );
  NAND3BX1 U1817 ( .AN(n1600), .B(n2477), .C(n2478), .Y(n2540) );
  NAND3BX1 U1818 ( .AN(n2478), .B(n1608), .C(n1600), .Y(n1231) );
  NAND3BX1 U1819 ( .AN(n2477), .B(n1600), .C(n2478), .Y(n1218) );
  NAND3BX1 U1820 ( .AN(n2478), .B(n1608), .C(n2476), .Y(n1233) );
  NAND3BX1 U1821 ( .AN(n2477), .B(n2476), .C(n2478), .Y(n1220) );
  NAND3BX1 U1822 ( .AN(n1600), .B(n2477), .C(n2478), .Y(n1224) );
  NAND3BX1 U1823 ( .AN(n2478), .B(n2476), .C(n2477), .Y(n2531) );
  NAND3BX1 U1824 ( .AN(n2478), .B(n2476), .C(n2477), .Y(n2532) );
  NAND3BX1 U1825 ( .AN(n2478), .B(n1600), .C(n2477), .Y(n2529) );
  NAND3BX1 U1826 ( .AN(n2478), .B(n1600), .C(n2477), .Y(n2530) );
  NAND3BX1 U1827 ( .AN(n2478), .B(n2476), .C(n2477), .Y(n1228) );
  NAND3BX1 U1828 ( .AN(n2478), .B(n1600), .C(n2477), .Y(n1226) );
  CLKINVX1 U1829 ( .A(n2477), .Y(n1608) );
  OA22X1 U1830 ( .A0(n2534), .A1(n2379), .B0(n2536), .B1(n2251), .Y(n1605) );
  OA22X1 U1831 ( .A0(n1231), .A1(n2366), .B0(n1233), .B1(n2238), .Y(n1472) );
  OA22X1 U1832 ( .A0(n2533), .A1(n2362), .B0(n2535), .B1(n2234), .Y(n1340) );
  OA22X1 U1833 ( .A0(n2533), .A1(n2361), .B0(n2535), .B1(n2233), .Y(n1304) );
  OA22X1 U1834 ( .A0(n1231), .A1(n2378), .B0(n1233), .B1(n2250), .Y(n1292) );
  OA22X1 U1835 ( .A0(n2534), .A1(n2377), .B0(n2536), .B1(n2249), .Y(n1280) );
  OA22X1 U1836 ( .A0(n2533), .A1(n2360), .B0(n2535), .B1(n2232), .Y(n1268) );
  OA22X1 U1837 ( .A0(n1231), .A1(n2351), .B0(n1233), .B1(n2231), .Y(n1256) );
  OA22X1 U1838 ( .A0(n2534), .A1(n2376), .B0(n2536), .B1(n2248), .Y(n1244) );
  OA22X1 U1839 ( .A0(n2533), .A1(n2359), .B0(n2535), .B1(n2230), .Y(n1230) );
  OA22X1 U1840 ( .A0(n2533), .A1(n2358), .B0(n2535), .B1(n2229), .Y(n1592) );
  OA22X1 U1841 ( .A0(n1231), .A1(n2365), .B0(n1233), .B1(n2237), .Y(n1580) );
  OA22X1 U1842 ( .A0(n2534), .A1(n2375), .B0(n2536), .B1(n2247), .Y(n1568) );
  OA22X1 U1843 ( .A0(n2533), .A1(n2357), .B0(n2535), .B1(n2228), .Y(n1556) );
  OA22X1 U1844 ( .A0(n1231), .A1(n2364), .B0(n1233), .B1(n2236), .Y(n1544) );
  OA22X1 U1845 ( .A0(n2534), .A1(n2374), .B0(n2536), .B1(n2246), .Y(n1532) );
  OA22X1 U1846 ( .A0(n2533), .A1(n2356), .B0(n2535), .B1(n2227), .Y(n1520) );
  OA22X1 U1847 ( .A0(n1231), .A1(n2363), .B0(n1233), .B1(n2235), .Y(n1508) );
  OA22X1 U1848 ( .A0(n2534), .A1(n2373), .B0(n2536), .B1(n2245), .Y(n1496) );
  OA22X1 U1849 ( .A0(n2533), .A1(n2355), .B0(n2535), .B1(n2226), .Y(n1484) );
  OA22X1 U1850 ( .A0(n2534), .A1(n2372), .B0(n2536), .B1(n2244), .Y(n1460) );
  OA22X1 U1851 ( .A0(n2533), .A1(n2354), .B0(n2535), .B1(n2225), .Y(n1448) );
  OA22X1 U1852 ( .A0(n1231), .A1(n2350), .B0(n1233), .B1(n2224), .Y(n1436) );
  OA22X1 U1853 ( .A0(n2534), .A1(n2371), .B0(n2536), .B1(n2243), .Y(n1424) );
  OA22X1 U1854 ( .A0(n2533), .A1(n2353), .B0(n2535), .B1(n2223), .Y(n1412) );
  OA22X1 U1855 ( .A0(n1231), .A1(n2349), .B0(n1233), .B1(n2222), .Y(n1400) );
  OA22X1 U1856 ( .A0(n2534), .A1(n2370), .B0(n2536), .B1(n2242), .Y(n1388) );
  OA22X1 U1857 ( .A0(n2533), .A1(n2352), .B0(n2535), .B1(n2221), .Y(n1376) );
  OA22X1 U1858 ( .A0(n1231), .A1(n2369), .B0(n1233), .B1(n2241), .Y(n1364) );
  OA22X1 U1859 ( .A0(n2534), .A1(n2368), .B0(n2536), .B1(n2240), .Y(n1352) );
  OA22X1 U1860 ( .A0(n1231), .A1(n2348), .B0(n1233), .B1(n2220), .Y(n1328) );
  OA22X1 U1861 ( .A0(n2534), .A1(n2367), .B0(n2536), .B1(n2239), .Y(n1316) );
  NAND3BX1 U1862 ( .AN(n1595), .B(n1596), .C(n1597), .Y(FIFORdData486_0_) );
  OA22X1 U1863 ( .A0(n2538), .A1(n2187), .B0(n2540), .B1(n2283), .Y(n1596) );
  OA22X1 U1864 ( .A0(n2542), .A1(n2219), .B0(n2544), .B1(n2347), .Y(n1597) );
  OAI221XL U1865 ( .A0(n2530), .A1(n2155), .B0(n2532), .B1(n2315), .C0(n1605), 
        .Y(n1595) );
  NAND3BX1 U1866 ( .AN(n1463), .B(n1464), .C(n1465), .Y(FIFORdData486_1_) );
  OA22X1 U1867 ( .A0(n1222), .A1(n2186), .B0(n1224), .B1(n2270), .Y(n1464) );
  OA22X1 U1868 ( .A0(n1218), .A1(n2218), .B0(n1220), .B1(n2346), .Y(n1465) );
  OAI221XL U1869 ( .A0(n1226), .A1(n2142), .B0(n1228), .B1(n2314), .C0(n1472), 
        .Y(n1463) );
  NAND3BX1 U1870 ( .AN(n1331), .B(n1332), .C(n1333), .Y(FIFORdData486_2_) );
  OA22X1 U1871 ( .A0(n2537), .A1(n2169), .B0(n2539), .B1(n2266), .Y(n1332) );
  OA22X1 U1872 ( .A0(n2541), .A1(n2201), .B0(n2543), .B1(n2329), .Y(n1333) );
  OAI221XL U1873 ( .A0(n2529), .A1(n2138), .B0(n2531), .B1(n2297), .C0(n1340), 
        .Y(n1331) );
  NAND3BX1 U1874 ( .AN(n1295), .B(n1296), .C(n1297), .Y(FIFORdData486_3_) );
  OA22X1 U1875 ( .A0(n2537), .A1(n2168), .B0(n2539), .B1(n2265), .Y(n1296) );
  OA22X1 U1876 ( .A0(n2541), .A1(n2200), .B0(n2543), .B1(n2328), .Y(n1297) );
  OAI221XL U1877 ( .A0(n2529), .A1(n2137), .B0(n2531), .B1(n2296), .C0(n1304), 
        .Y(n1295) );
  NAND3BX1 U1878 ( .AN(n1283), .B(n1284), .C(n1285), .Y(FIFORdData486_4_) );
  OA22X1 U1879 ( .A0(n1222), .A1(n2185), .B0(n1224), .B1(n2282), .Y(n1284) );
  OA22X1 U1880 ( .A0(n1218), .A1(n2217), .B0(n1220), .B1(n2345), .Y(n1285) );
  OAI221XL U1881 ( .A0(n1226), .A1(n2154), .B0(n1228), .B1(n2313), .C0(n1292), 
        .Y(n1283) );
  NAND3BX1 U1882 ( .AN(n1271), .B(n1272), .C(n1273), .Y(FIFORdData486_5_) );
  OA22X1 U1883 ( .A0(n2538), .A1(n2184), .B0(n2540), .B1(n2281), .Y(n1272) );
  OA22X1 U1884 ( .A0(n2542), .A1(n2216), .B0(n2544), .B1(n2344), .Y(n1273) );
  OAI221XL U1885 ( .A0(n2530), .A1(n2153), .B0(n2532), .B1(n2312), .C0(n1280), 
        .Y(n1271) );
  NAND3BX1 U1886 ( .AN(n1259), .B(n1260), .C(n1261), .Y(FIFORdData486_6_) );
  OA22X1 U1887 ( .A0(n2537), .A1(n2167), .B0(n2539), .B1(n2264), .Y(n1260) );
  OA22X1 U1888 ( .A0(n2541), .A1(n2199), .B0(n2543), .B1(n2327), .Y(n1261) );
  OAI221XL U1889 ( .A0(n2529), .A1(n2136), .B0(n2531), .B1(n2295), .C0(n1268), 
        .Y(n1259) );
  NAND3BX1 U1890 ( .AN(n1247), .B(n1248), .C(n1249), .Y(FIFORdData486_7_) );
  OA22X1 U1891 ( .A0(n1222), .A1(n2166), .B0(n1224), .B1(n2263), .Y(n1248) );
  OA22X1 U1892 ( .A0(n1218), .A1(n2198), .B0(n1220), .B1(n2326), .Y(n1249) );
  OAI221XL U1893 ( .A0(n1226), .A1(n2135), .B0(n1228), .B1(n2294), .C0(n1256), 
        .Y(n1247) );
  NAND3BX1 U1894 ( .AN(n1235), .B(n1236), .C(n1237), .Y(FIFORdData486_8_) );
  OA22X1 U1895 ( .A0(n2538), .A1(n2183), .B0(n2540), .B1(n2280), .Y(n1236) );
  OA22X1 U1896 ( .A0(n2542), .A1(n2215), .B0(n2544), .B1(n2343), .Y(n1237) );
  OAI221XL U1897 ( .A0(n2530), .A1(n2152), .B0(n2532), .B1(n2311), .C0(n1244), 
        .Y(n1235) );
  NAND3BX1 U1898 ( .AN(n1215), .B(n1216), .C(n1217), .Y(FIFORdData486_9_) );
  OA22X1 U1899 ( .A0(n2537), .A1(n2165), .B0(n2539), .B1(n2262), .Y(n1216) );
  OA22X1 U1900 ( .A0(n2541), .A1(n2197), .B0(n2543), .B1(n2325), .Y(n1217) );
  OAI221XL U1901 ( .A0(n2529), .A1(n2134), .B0(n2531), .B1(n2293), .C0(n1230), 
        .Y(n1215) );
  NAND3BX1 U1902 ( .AN(n1583), .B(n1584), .C(n1585), .Y(FIFORdData486_10_) );
  OA22X1 U1903 ( .A0(n2537), .A1(n2164), .B0(n2539), .B1(n2261), .Y(n1584) );
  OA22X1 U1904 ( .A0(n2541), .A1(n2196), .B0(n2543), .B1(n2324), .Y(n1585) );
  OAI221XL U1905 ( .A0(n2529), .A1(n2133), .B0(n2531), .B1(n2292), .C0(n1592), 
        .Y(n1583) );
  NAND3BX1 U1906 ( .AN(n1571), .B(n1572), .C(n1573), .Y(FIFORdData486_11_) );
  OA22X1 U1907 ( .A0(n1222), .A1(n2182), .B0(n1224), .B1(n2269), .Y(n1572) );
  OA22X1 U1908 ( .A0(n1218), .A1(n2214), .B0(n1220), .B1(n2342), .Y(n1573) );
  OAI221XL U1909 ( .A0(n1226), .A1(n2141), .B0(n1228), .B1(n2310), .C0(n1580), 
        .Y(n1571) );
  NAND3BX1 U1910 ( .AN(n1559), .B(n1560), .C(n1561), .Y(FIFORdData486_12_) );
  OA22X1 U1911 ( .A0(n2538), .A1(n2181), .B0(n2540), .B1(n2279), .Y(n1560) );
  OA22X1 U1912 ( .A0(n2542), .A1(n2213), .B0(n2544), .B1(n2341), .Y(n1561) );
  OAI221XL U1913 ( .A0(n2530), .A1(n2151), .B0(n2532), .B1(n2309), .C0(n1568), 
        .Y(n1559) );
  NAND3BX1 U1914 ( .AN(n1547), .B(n1548), .C(n1549), .Y(FIFORdData486_13_) );
  OA22X1 U1915 ( .A0(n2537), .A1(n2163), .B0(n2539), .B1(n2260), .Y(n1548) );
  OA22X1 U1916 ( .A0(n2541), .A1(n2195), .B0(n2543), .B1(n2323), .Y(n1549) );
  OAI221XL U1917 ( .A0(n2529), .A1(n2132), .B0(n2531), .B1(n2291), .C0(n1556), 
        .Y(n1547) );
  NAND3BX1 U1918 ( .AN(n1535), .B(n1536), .C(n1537), .Y(FIFORdData486_14_) );
  OA22X1 U1919 ( .A0(n1222), .A1(n2180), .B0(n1224), .B1(n2268), .Y(n1536) );
  OA22X1 U1920 ( .A0(n1218), .A1(n2212), .B0(n1220), .B1(n2340), .Y(n1537) );
  OAI221XL U1921 ( .A0(n1226), .A1(n2140), .B0(n1228), .B1(n2308), .C0(n1544), 
        .Y(n1535) );
  NAND3BX1 U1922 ( .AN(n1523), .B(n1524), .C(n1525), .Y(FIFORdData486_15_) );
  OA22X1 U1923 ( .A0(n2538), .A1(n2179), .B0(n2540), .B1(n2278), .Y(n1524) );
  OA22X1 U1924 ( .A0(n2542), .A1(n2211), .B0(n2544), .B1(n2339), .Y(n1525) );
  OAI221XL U1925 ( .A0(n2530), .A1(n2150), .B0(n2532), .B1(n2307), .C0(n1532), 
        .Y(n1523) );
  NAND3BX1 U1926 ( .AN(n1511), .B(n1512), .C(n1513), .Y(FIFORdData486_16_) );
  OA22X1 U1927 ( .A0(n2537), .A1(n2162), .B0(n2539), .B1(n2259), .Y(n1512) );
  OA22X1 U1928 ( .A0(n2541), .A1(n2194), .B0(n2543), .B1(n2322), .Y(n1513) );
  OAI221XL U1929 ( .A0(n2529), .A1(n2131), .B0(n2531), .B1(n2290), .C0(n1520), 
        .Y(n1511) );
  NAND3BX1 U1930 ( .AN(n1499), .B(n1500), .C(n1501), .Y(FIFORdData486_17_) );
  OA22X1 U1931 ( .A0(n1222), .A1(n2178), .B0(n1224), .B1(n2267), .Y(n1500) );
  OA22X1 U1932 ( .A0(n1218), .A1(n2210), .B0(n1220), .B1(n2338), .Y(n1501) );
  OAI221XL U1933 ( .A0(n1226), .A1(n2139), .B0(n1228), .B1(n2306), .C0(n1508), 
        .Y(n1499) );
  NAND3BX1 U1934 ( .AN(n1487), .B(n1488), .C(n1489), .Y(FIFORdData486_18_) );
  OA22X1 U1935 ( .A0(n2538), .A1(n2177), .B0(n2540), .B1(n2277), .Y(n1488) );
  OA22X1 U1936 ( .A0(n2542), .A1(n2209), .B0(n2544), .B1(n2337), .Y(n1489) );
  OAI221XL U1937 ( .A0(n2530), .A1(n2149), .B0(n2532), .B1(n2305), .C0(n1496), 
        .Y(n1487) );
  NAND3BX1 U1938 ( .AN(n1475), .B(n1476), .C(n1477), .Y(FIFORdData486_19_) );
  OA22X1 U1939 ( .A0(n2537), .A1(n2161), .B0(n2539), .B1(n2258), .Y(n1476) );
  OA22X1 U1940 ( .A0(n2541), .A1(n2193), .B0(n2543), .B1(n2321), .Y(n1477) );
  OAI221XL U1941 ( .A0(n2529), .A1(n2130), .B0(n2531), .B1(n2289), .C0(n1484), 
        .Y(n1475) );
  NAND3BX1 U1942 ( .AN(n1451), .B(n1452), .C(n1453), .Y(FIFORdData486_20_) );
  OA22X1 U1943 ( .A0(n2538), .A1(n2176), .B0(n2540), .B1(n2276), .Y(n1452) );
  OA22X1 U1944 ( .A0(n2542), .A1(n2208), .B0(n2544), .B1(n2336), .Y(n1453) );
  OAI221XL U1945 ( .A0(n2530), .A1(n2148), .B0(n2532), .B1(n2304), .C0(n1460), 
        .Y(n1451) );
  NAND3BX1 U1946 ( .AN(n1439), .B(n1440), .C(n1441), .Y(FIFORdData486_21_) );
  OA22X1 U1947 ( .A0(n2537), .A1(n2160), .B0(n2539), .B1(n2257), .Y(n1440) );
  OA22X1 U1948 ( .A0(n2541), .A1(n2192), .B0(n2543), .B1(n2320), .Y(n1441) );
  OAI221XL U1949 ( .A0(n2529), .A1(n2129), .B0(n2531), .B1(n2288), .C0(n1448), 
        .Y(n1439) );
  NAND3BX1 U1950 ( .AN(n1427), .B(n1428), .C(n1429), .Y(FIFORdData486_22_) );
  OA22X1 U1951 ( .A0(n1222), .A1(n2175), .B0(n1224), .B1(n2256), .Y(n1428) );
  OA22X1 U1952 ( .A0(n1218), .A1(n2207), .B0(n1220), .B1(n2335), .Y(n1429) );
  OAI221XL U1953 ( .A0(n1226), .A1(n2128), .B0(n1228), .B1(n2303), .C0(n1436), 
        .Y(n1427) );
  NAND3BX1 U1954 ( .AN(n1415), .B(n1416), .C(n1417), .Y(FIFORdData486_23_) );
  OA22X1 U1955 ( .A0(n2538), .A1(n2174), .B0(n2540), .B1(n2275), .Y(n1416) );
  OA22X1 U1956 ( .A0(n2542), .A1(n2206), .B0(n2544), .B1(n2334), .Y(n1417) );
  OAI221XL U1957 ( .A0(n2530), .A1(n2147), .B0(n2532), .B1(n2302), .C0(n1424), 
        .Y(n1415) );
  NAND3BX1 U1958 ( .AN(n1403), .B(n1404), .C(n1405), .Y(FIFORdData486_24_) );
  OA22X1 U1959 ( .A0(n2537), .A1(n2159), .B0(n2539), .B1(n2255), .Y(n1404) );
  OA22X1 U1960 ( .A0(n2541), .A1(n2191), .B0(n2543), .B1(n2319), .Y(n1405) );
  OAI221XL U1961 ( .A0(n2529), .A1(n2127), .B0(n2531), .B1(n2287), .C0(n1412), 
        .Y(n1403) );
  NAND3BX1 U1962 ( .AN(n1391), .B(n1392), .C(n1393), .Y(FIFORdData486_25_) );
  OA22X1 U1963 ( .A0(n1222), .A1(n2158), .B0(n1224), .B1(n2254), .Y(n1392) );
  OA22X1 U1964 ( .A0(n1218), .A1(n2190), .B0(n1220), .B1(n2318), .Y(n1393) );
  OAI221XL U1965 ( .A0(n1226), .A1(n2126), .B0(n1228), .B1(n2286), .C0(n1400), 
        .Y(n1391) );
  NAND3BX1 U1966 ( .AN(n1379), .B(n1380), .C(n1381), .Y(FIFORdData486_26_) );
  OA22X1 U1967 ( .A0(n2538), .A1(n2173), .B0(n2540), .B1(n2274), .Y(n1380) );
  OA22X1 U1968 ( .A0(n2542), .A1(n2205), .B0(n2544), .B1(n2333), .Y(n1381) );
  OAI221XL U1969 ( .A0(n2530), .A1(n2146), .B0(n2532), .B1(n2301), .C0(n1388), 
        .Y(n1379) );
  NAND3BX1 U1970 ( .AN(n1367), .B(n1368), .C(n1369), .Y(FIFORdData486_27_) );
  OA22X1 U1971 ( .A0(n2537), .A1(n2157), .B0(n2539), .B1(n2253), .Y(n1368) );
  OA22X1 U1972 ( .A0(n2541), .A1(n2189), .B0(n2543), .B1(n2317), .Y(n1369) );
  OAI221XL U1973 ( .A0(n2529), .A1(n2125), .B0(n2531), .B1(n2285), .C0(n1376), 
        .Y(n1367) );
  NAND3BX1 U1974 ( .AN(n1355), .B(n1356), .C(n1357), .Y(FIFORdData486_28_) );
  OA22X1 U1975 ( .A0(n1222), .A1(n2172), .B0(n1224), .B1(n2273), .Y(n1356) );
  OA22X1 U1976 ( .A0(n1218), .A1(n2204), .B0(n1220), .B1(n2332), .Y(n1357) );
  OAI221XL U1977 ( .A0(n1226), .A1(n2145), .B0(n1228), .B1(n2300), .C0(n1364), 
        .Y(n1355) );
  NAND3BX1 U1978 ( .AN(n1343), .B(n1344), .C(n1345), .Y(FIFORdData486_29_) );
  OA22X1 U1979 ( .A0(n2538), .A1(n2171), .B0(n2540), .B1(n2272), .Y(n1344) );
  OA22X1 U1980 ( .A0(n2542), .A1(n2203), .B0(n2544), .B1(n2331), .Y(n1345) );
  OAI221XL U1981 ( .A0(n2530), .A1(n2144), .B0(n2532), .B1(n2299), .C0(n1352), 
        .Y(n1343) );
  NAND3BX1 U1982 ( .AN(n1319), .B(n1320), .C(n1321), .Y(FIFORdData486_30_) );
  OA22X1 U1983 ( .A0(n1222), .A1(n2156), .B0(n1224), .B1(n2252), .Y(n1320) );
  OA22X1 U1984 ( .A0(n1218), .A1(n2188), .B0(n1220), .B1(n2316), .Y(n1321) );
  OAI221XL U1985 ( .A0(n1226), .A1(n2124), .B0(n1228), .B1(n2284), .C0(n1328), 
        .Y(n1319) );
  NAND3BX1 U1986 ( .AN(n1307), .B(n1308), .C(n1309), .Y(FIFORdData486_31_) );
  OA22X1 U1987 ( .A0(n2538), .A1(n2170), .B0(n2540), .B1(n2271), .Y(n1308) );
  OA22X1 U1988 ( .A0(n2542), .A1(n2202), .B0(n2544), .B1(n2330), .Y(n1309) );
  OAI221XL U1989 ( .A0(n2530), .A1(n2143), .B0(n2532), .B1(n2298), .C0(n1316), 
        .Y(n1307) );
  NAND3BX1 U1990 ( .AN(n2480), .B(n1867), .C(n1865), .Y(n2481) );
  NAND3BX1 U1991 ( .AN(n2480), .B(n1867), .C(n1865), .Y(n1710) );
  NAND3BX1 U1992 ( .AN(n2476), .B(n2477), .C(n2478), .Y(n2537) );
  NAND3BX1 U1993 ( .AN(n2476), .B(n2477), .C(n2478), .Y(n2538) );
  NAND3BX1 U1994 ( .AN(n2476), .B(n2477), .C(n2478), .Y(n1222) );
  NAND2BX1 U1995 ( .AN(WriteAllow), .B(n1699), .Y(n2503) );
  NAND2BX1 U1996 ( .AN(WriteAllow), .B(n1699), .Y(n2504) );
  NAND2BX1 U1997 ( .AN(n1676), .B(n1699), .Y(n2501) );
  NAND2BX1 U1998 ( .AN(n1676), .B(n1699), .Y(n2502) );
  NAND2BX1 U1999 ( .AN(WriteAllow), .B(n1699), .Y(n1700) );
  NAND2BX1 U2000 ( .AN(n1676), .B(n1699), .Y(n1698) );
  OAI221XL U2001 ( .A0(n2220), .A1(n2485), .B0(n2124), .B1(n2487), .C0(n1750), 
        .Y(n1747) );
  OA22X1 U2002 ( .A0(n2252), .A1(n2489), .B0(n2348), .B1(n2481), .Y(n1750) );
  OAI221XL U2003 ( .A0(n2221), .A1(n2485), .B0(n2125), .B1(n2487), .C0(n1770), 
        .Y(n1767) );
  OA22X1 U2004 ( .A0(n2253), .A1(n2489), .B0(n2352), .B1(n2481), .Y(n1770) );
  OAI221XL U2005 ( .A0(n2222), .A1(n2485), .B0(n2126), .B1(n2487), .C0(n1780), 
        .Y(n1777) );
  OA22X1 U2006 ( .A0(n2254), .A1(n2489), .B0(n2349), .B1(n2481), .Y(n1780) );
  OAI221XL U2007 ( .A0(n2223), .A1(n2485), .B0(n2127), .B1(n2487), .C0(n1785), 
        .Y(n1782) );
  OA22X1 U2008 ( .A0(n2255), .A1(n2489), .B0(n2353), .B1(n2481), .Y(n1785) );
  OAI221XL U2009 ( .A0(n2225), .A1(n2485), .B0(n2129), .B1(n2487), .C0(n1800), 
        .Y(n1797) );
  OA22X1 U2010 ( .A0(n2257), .A1(n2489), .B0(n2354), .B1(n2481), .Y(n1800) );
  OAI221XL U2011 ( .A0(n2226), .A1(n2485), .B0(n2130), .B1(n2487), .C0(n1815), 
        .Y(n1812) );
  OA22X1 U2012 ( .A0(n2258), .A1(n2489), .B0(n2355), .B1(n2481), .Y(n1815) );
  OAI221XL U2013 ( .A0(n2227), .A1(n2485), .B0(n2131), .B1(n2487), .C0(n1830), 
        .Y(n1827) );
  OA22X1 U2014 ( .A0(n2259), .A1(n2489), .B0(n2356), .B1(n2481), .Y(n1830) );
  OAI221XL U2015 ( .A0(n2228), .A1(n2485), .B0(n2132), .B1(n2487), .C0(n1845), 
        .Y(n1842) );
  OA22X1 U2016 ( .A0(n2260), .A1(n2489), .B0(n2357), .B1(n2481), .Y(n1845) );
  OAI221XL U2017 ( .A0(n2229), .A1(n2485), .B0(n2133), .B1(n2487), .C0(n1860), 
        .Y(n1857) );
  OA22X1 U2018 ( .A0(n2261), .A1(n2489), .B0(n2358), .B1(n2481), .Y(n1860) );
  OAI221XL U2019 ( .A0(n2230), .A1(n2485), .B0(n2134), .B1(n2487), .C0(n1709), 
        .Y(n1706) );
  OA22X1 U2020 ( .A0(n2262), .A1(n2489), .B0(n2359), .B1(n2481), .Y(n1709) );
  OAI221XL U2021 ( .A0(n2231), .A1(n2485), .B0(n2135), .B1(n2487), .C0(n1720), 
        .Y(n1717) );
  OA22X1 U2022 ( .A0(n2263), .A1(n2489), .B0(n2351), .B1(n2481), .Y(n1720) );
  OAI221XL U2023 ( .A0(n2232), .A1(n2485), .B0(n2136), .B1(n2487), .C0(n1725), 
        .Y(n1722) );
  OA22X1 U2024 ( .A0(n2264), .A1(n2489), .B0(n2360), .B1(n2481), .Y(n1725) );
  OAI221XL U2025 ( .A0(n2233), .A1(n2485), .B0(n2137), .B1(n2487), .C0(n1740), 
        .Y(n1737) );
  OA22X1 U2026 ( .A0(n2265), .A1(n2489), .B0(n2361), .B1(n2481), .Y(n1740) );
  OAI221XL U2027 ( .A0(n2234), .A1(n2485), .B0(n2138), .B1(n2487), .C0(n1755), 
        .Y(n1752) );
  OA22X1 U2028 ( .A0(n2266), .A1(n2489), .B0(n2362), .B1(n2481), .Y(n1755) );
  OAI221XL U2029 ( .A0(n2224), .A1(n2486), .B0(n2128), .B1(n2488), .C0(n1795), 
        .Y(n1792) );
  OA22X1 U2030 ( .A0(n2256), .A1(n2490), .B0(n2350), .B1(n1710), .Y(n1795) );
  NOR3X1 U2031 ( .A(n1747), .B(n2381), .C(n2382), .Y(n2380) );
  OAI22XL U2032 ( .A0(n2316), .A1(n2491), .B0(n2156), .B1(n2493), .Y(n2381) );
  OAI22XL U2033 ( .A0(n2284), .A1(n2495), .B0(n2188), .B1(n2497), .Y(n2382) );
  NOR3X1 U2034 ( .A(n1767), .B(n2384), .C(n2385), .Y(n2383) );
  OAI22XL U2035 ( .A0(n2317), .A1(n2491), .B0(n2157), .B1(n2493), .Y(n2384) );
  OAI22XL U2036 ( .A0(n2285), .A1(n2495), .B0(n2189), .B1(n2497), .Y(n2385) );
  NOR3X1 U2037 ( .A(n1777), .B(n2387), .C(n2388), .Y(n2386) );
  OAI22XL U2038 ( .A0(n2318), .A1(n2491), .B0(n2158), .B1(n2493), .Y(n2387) );
  OAI22XL U2039 ( .A0(n2286), .A1(n2495), .B0(n2190), .B1(n2497), .Y(n2388) );
  NOR3X1 U2040 ( .A(n1782), .B(n2390), .C(n2391), .Y(n2389) );
  OAI22XL U2041 ( .A0(n2319), .A1(n2491), .B0(n2159), .B1(n2493), .Y(n2390) );
  OAI22XL U2042 ( .A0(n2287), .A1(n2495), .B0(n2191), .B1(n2497), .Y(n2391) );
  NOR3X1 U2043 ( .A(n1797), .B(n2393), .C(n2394), .Y(n2392) );
  OAI22XL U2044 ( .A0(n2320), .A1(n2491), .B0(n2160), .B1(n2493), .Y(n2393) );
  OAI22XL U2045 ( .A0(n2288), .A1(n2495), .B0(n2192), .B1(n2497), .Y(n2394) );
  NOR3X1 U2046 ( .A(n1812), .B(n2396), .C(n2397), .Y(n2395) );
  OAI22XL U2047 ( .A0(n2321), .A1(n2491), .B0(n2161), .B1(n2493), .Y(n2396) );
  OAI22XL U2048 ( .A0(n2289), .A1(n2495), .B0(n2193), .B1(n2497), .Y(n2397) );
  NOR3X1 U2049 ( .A(n1827), .B(n2399), .C(n2400), .Y(n2398) );
  OAI22XL U2050 ( .A0(n2322), .A1(n2491), .B0(n2162), .B1(n2493), .Y(n2399) );
  OAI22XL U2051 ( .A0(n2290), .A1(n2495), .B0(n2194), .B1(n2497), .Y(n2400) );
  NOR3X1 U2052 ( .A(n1842), .B(n2402), .C(n2403), .Y(n2401) );
  OAI22XL U2053 ( .A0(n2323), .A1(n2491), .B0(n2163), .B1(n2493), .Y(n2402) );
  OAI22XL U2054 ( .A0(n2291), .A1(n2495), .B0(n2195), .B1(n2497), .Y(n2403) );
  NOR3X1 U2055 ( .A(n1857), .B(n2405), .C(n2406), .Y(n2404) );
  OAI22XL U2056 ( .A0(n2324), .A1(n2491), .B0(n2164), .B1(n2493), .Y(n2405) );
  OAI22XL U2057 ( .A0(n2292), .A1(n2495), .B0(n2196), .B1(n2497), .Y(n2406) );
  NOR3X1 U2058 ( .A(n1706), .B(n2408), .C(n2409), .Y(n2407) );
  OAI22XL U2059 ( .A0(n2325), .A1(n2491), .B0(n2165), .B1(n2493), .Y(n2408) );
  OAI22XL U2060 ( .A0(n2293), .A1(n2495), .B0(n2197), .B1(n2497), .Y(n2409) );
  NOR3X1 U2061 ( .A(n1717), .B(n2411), .C(n2412), .Y(n2410) );
  OAI22XL U2062 ( .A0(n2326), .A1(n2491), .B0(n2166), .B1(n2493), .Y(n2411) );
  OAI22XL U2063 ( .A0(n2294), .A1(n2495), .B0(n2198), .B1(n2497), .Y(n2412) );
  NOR3X1 U2064 ( .A(n1722), .B(n2414), .C(n2415), .Y(n2413) );
  OAI22XL U2065 ( .A0(n2327), .A1(n2491), .B0(n2167), .B1(n2493), .Y(n2414) );
  OAI22XL U2066 ( .A0(n2295), .A1(n2495), .B0(n2199), .B1(n2497), .Y(n2415) );
  NOR3X1 U2067 ( .A(n1737), .B(n2417), .C(n2418), .Y(n2416) );
  OAI22XL U2068 ( .A0(n2328), .A1(n2491), .B0(n2168), .B1(n2493), .Y(n2417) );
  OAI22XL U2069 ( .A0(n2296), .A1(n2495), .B0(n2200), .B1(n2497), .Y(n2418) );
  NOR3X1 U2070 ( .A(n1752), .B(n2420), .C(n2421), .Y(n2419) );
  OAI22XL U2071 ( .A0(n2329), .A1(n2491), .B0(n2169), .B1(n2493), .Y(n2420) );
  OAI22XL U2072 ( .A0(n2297), .A1(n2495), .B0(n2201), .B1(n2497), .Y(n2421) );
  OAI222XL U2073 ( .A0(n1702), .A1(n2348), .B0(n1628), .B1(n1703), .C0(n2380), 
        .C1(n1704), .Y(FIFO880) );
  OAI222XL U2074 ( .A0(n1702), .A1(n2369), .B0(n1634), .B1(n1703), .C0(n2428), 
        .C1(n1704), .Y(FIFO882) );
  OAI222XL U2075 ( .A0(n1702), .A1(n2349), .B0(n1640), .B1(n1703), .C0(n2386), 
        .C1(n1704), .Y(FIFO885) );
  OAI222XL U2076 ( .A0(n1702), .A1(n2350), .B0(n1646), .B1(n1703), .C0(n2437), 
        .C1(n1704), .Y(FIFO888) );
  OAI222XL U2077 ( .A0(n1702), .A1(n2363), .B0(n1658), .B1(n1703), .C0(n2446), 
        .C1(n1704), .Y(FIFO8813) );
  OAI222XL U2078 ( .A0(n1702), .A1(n2364), .B0(n1664), .B1(n1703), .C0(n2452), 
        .C1(n1704), .Y(FIFO8816) );
  OAI222XL U2079 ( .A0(n1702), .A1(n2365), .B0(n1670), .B1(n1703), .C0(n2458), 
        .C1(n1704), .Y(FIFO8819) );
  OAI222XL U2080 ( .A0(n1702), .A1(n2351), .B0(n1616), .B1(n1703), .C0(n2410), 
        .C1(n1704), .Y(FIFO8823) );
  OAI222XL U2081 ( .A0(n1702), .A1(n2378), .B0(n1622), .B1(n1703), .C0(n2467), 
        .C1(n1704), .Y(FIFO8826) );
  OAI222XL U2082 ( .A0(n1702), .A1(n2366), .B0(n1652), .B1(n1703), .C0(n2470), 
        .C1(n1704), .Y(FIFO8829) );
  OAI222XL U2083 ( .A0(n1702), .A1(n2367), .B0(n1626), .B1(n2484), .C0(n2422), 
        .C1(n2500), .Y(FIFO88) );
  OAI222XL U2084 ( .A0(n1702), .A1(n2368), .B0(n1632), .B1(n2484), .C0(n2425), 
        .C1(n2500), .Y(FIFO881) );
  OAI222XL U2085 ( .A0(n1702), .A1(n2352), .B0(n1636), .B1(n2483), .C0(n2383), 
        .C1(n2499), .Y(FIFO883) );
  OAI222XL U2086 ( .A0(n1702), .A1(n2370), .B0(n1638), .B1(n2484), .C0(n2431), 
        .C1(n2500), .Y(FIFO884) );
  OAI222XL U2087 ( .A0(n1702), .A1(n2353), .B0(n1642), .B1(n2483), .C0(n2389), 
        .C1(n2499), .Y(FIFO886) );
  OAI222XL U2088 ( .A0(n1702), .A1(n2371), .B0(n1644), .B1(n2484), .C0(n2434), 
        .C1(n2500), .Y(FIFO887) );
  OAI222XL U2089 ( .A0(n1702), .A1(n2354), .B0(n1648), .B1(n2483), .C0(n2392), 
        .C1(n2499), .Y(FIFO889) );
  OAI222XL U2090 ( .A0(n1702), .A1(n2372), .B0(n1650), .B1(n2484), .C0(n2440), 
        .C1(n2500), .Y(FIFO8810) );
  OAI222XL U2091 ( .A0(n1702), .A1(n2355), .B0(n1654), .B1(n2483), .C0(n2395), 
        .C1(n2499), .Y(FIFO8811) );
  OAI222XL U2092 ( .A0(n1702), .A1(n2373), .B0(n1656), .B1(n2484), .C0(n2443), 
        .C1(n2500), .Y(FIFO8812) );
  OAI222XL U2093 ( .A0(n1702), .A1(n2356), .B0(n1660), .B1(n2483), .C0(n2398), 
        .C1(n2499), .Y(FIFO8814) );
  OAI222XL U2094 ( .A0(n1702), .A1(n2374), .B0(n1662), .B1(n2484), .C0(n2449), 
        .C1(n2500), .Y(FIFO8815) );
  OAI222XL U2095 ( .A0(n1702), .A1(n2357), .B0(n1666), .B1(n2483), .C0(n2401), 
        .C1(n2499), .Y(FIFO8817) );
  OAI222XL U2096 ( .A0(n1702), .A1(n2375), .B0(n1668), .B1(n2484), .C0(n2455), 
        .C1(n2500), .Y(FIFO8818) );
  OAI222XL U2097 ( .A0(n1702), .A1(n2358), .B0(n1672), .B1(n2483), .C0(n2404), 
        .C1(n2499), .Y(FIFO8820) );
  OAI222XL U2098 ( .A0(n1702), .A1(n2359), .B0(n1610), .B1(n2483), .C0(n2407), 
        .C1(n2499), .Y(FIFO8821) );
  OAI222XL U2099 ( .A0(n1702), .A1(n2376), .B0(n1614), .B1(n2484), .C0(n2461), 
        .C1(n2500), .Y(FIFO8822) );
  OAI222XL U2100 ( .A0(n1702), .A1(n2360), .B0(n1618), .B1(n2483), .C0(n2413), 
        .C1(n2499), .Y(FIFO8824) );
  OAI222XL U2101 ( .A0(n1702), .A1(n2377), .B0(n1620), .B1(n2484), .C0(n2464), 
        .C1(n2500), .Y(FIFO8825) );
  OAI222XL U2102 ( .A0(n1702), .A1(n2361), .B0(n1624), .B1(n2483), .C0(n2416), 
        .C1(n2499), .Y(FIFO8827) );
  OAI222XL U2103 ( .A0(n1702), .A1(n2362), .B0(n1630), .B1(n2483), .C0(n2419), 
        .C1(n2499), .Y(FIFO8828) );
  OAI222XL U2104 ( .A0(n1702), .A1(n2379), .B0(n1674), .B1(n2484), .C0(n2473), 
        .C1(n2500), .Y(FIFO8830) );
  OAI222XL U2105 ( .A0(n1626), .A1(n2514), .B0(n1687), .B1(n2202), .C0(n2422), 
        .C1(n2516), .Y(FIFO88127) );
  OAI222XL U2106 ( .A0(n1628), .A1(n1686), .B0(n1687), .B1(n2188), .C0(n2380), 
        .C1(n1688), .Y(FIFO88128) );
  OAI222XL U2107 ( .A0(n1632), .A1(n2514), .B0(n1687), .B1(n2203), .C0(n2425), 
        .C1(n2516), .Y(FIFO88129) );
  OAI222XL U2108 ( .A0(n1634), .A1(n1686), .B0(n1687), .B1(n2204), .C0(n2428), 
        .C1(n1688), .Y(FIFO88130) );
  OAI222XL U2109 ( .A0(n1636), .A1(n2513), .B0(n1687), .B1(n2189), .C0(n2383), 
        .C1(n2515), .Y(FIFO88131) );
  OAI222XL U2110 ( .A0(n1638), .A1(n2514), .B0(n1687), .B1(n2205), .C0(n2431), 
        .C1(n2516), .Y(FIFO88132) );
  OAI222XL U2111 ( .A0(n1640), .A1(n1686), .B0(n1687), .B1(n2190), .C0(n2386), 
        .C1(n1688), .Y(FIFO88133) );
  OAI222XL U2112 ( .A0(n1642), .A1(n2513), .B0(n1687), .B1(n2191), .C0(n2389), 
        .C1(n2515), .Y(FIFO88134) );
  OAI222XL U2113 ( .A0(n1644), .A1(n2514), .B0(n1687), .B1(n2206), .C0(n2434), 
        .C1(n2516), .Y(FIFO88135) );
  OAI222XL U2114 ( .A0(n1646), .A1(n1686), .B0(n1687), .B1(n2207), .C0(n2437), 
        .C1(n1688), .Y(FIFO88136) );
  OAI222XL U2115 ( .A0(n1648), .A1(n2513), .B0(n1687), .B1(n2192), .C0(n2392), 
        .C1(n2515), .Y(FIFO88137) );
  OAI222XL U2116 ( .A0(n1650), .A1(n2514), .B0(n1687), .B1(n2208), .C0(n2440), 
        .C1(n2516), .Y(FIFO88138) );
  OAI222XL U2117 ( .A0(n1654), .A1(n2513), .B0(n1687), .B1(n2193), .C0(n2395), 
        .C1(n2515), .Y(FIFO88139) );
  OAI222XL U2118 ( .A0(n1656), .A1(n2514), .B0(n1687), .B1(n2209), .C0(n2443), 
        .C1(n2516), .Y(FIFO88140) );
  OAI222XL U2119 ( .A0(n1658), .A1(n1686), .B0(n1687), .B1(n2210), .C0(n2446), 
        .C1(n1688), .Y(FIFO88141) );
  OAI222XL U2120 ( .A0(n1660), .A1(n2513), .B0(n1687), .B1(n2194), .C0(n2398), 
        .C1(n2515), .Y(FIFO88142) );
  OAI222XL U2121 ( .A0(n1662), .A1(n2514), .B0(n1687), .B1(n2211), .C0(n2449), 
        .C1(n2516), .Y(FIFO88143) );
  OAI222XL U2122 ( .A0(n1664), .A1(n1686), .B0(n1687), .B1(n2212), .C0(n2452), 
        .C1(n1688), .Y(FIFO88144) );
  OAI222XL U2123 ( .A0(n1666), .A1(n2513), .B0(n1687), .B1(n2195), .C0(n2401), 
        .C1(n2515), .Y(FIFO88145) );
  OAI222XL U2124 ( .A0(n1668), .A1(n2514), .B0(n1687), .B1(n2213), .C0(n2455), 
        .C1(n2516), .Y(FIFO88146) );
  OAI222XL U2125 ( .A0(n1670), .A1(n1686), .B0(n1687), .B1(n2214), .C0(n2458), 
        .C1(n1688), .Y(FIFO88147) );
  OAI222XL U2126 ( .A0(n1672), .A1(n2513), .B0(n1687), .B1(n2196), .C0(n2404), 
        .C1(n2515), .Y(FIFO88148) );
  OAI222XL U2127 ( .A0(n1610), .A1(n2513), .B0(n1687), .B1(n2197), .C0(n2407), 
        .C1(n2515), .Y(FIFO88149) );
  OAI222XL U2128 ( .A0(n1614), .A1(n2514), .B0(n1687), .B1(n2215), .C0(n2461), 
        .C1(n2516), .Y(FIFO88150) );
  OAI222XL U2129 ( .A0(n1616), .A1(n1686), .B0(n1687), .B1(n2198), .C0(n2410), 
        .C1(n1688), .Y(FIFO88151) );
  OAI222XL U2130 ( .A0(n1618), .A1(n2513), .B0(n1687), .B1(n2199), .C0(n2413), 
        .C1(n2515), .Y(FIFO88152) );
  OAI222XL U2131 ( .A0(n1620), .A1(n2514), .B0(n1687), .B1(n2216), .C0(n2464), 
        .C1(n2516), .Y(FIFO88153) );
  OAI222XL U2132 ( .A0(n1622), .A1(n1686), .B0(n1687), .B1(n2217), .C0(n2467), 
        .C1(n1688), .Y(FIFO88154) );
  OAI222XL U2133 ( .A0(n1624), .A1(n2513), .B0(n1687), .B1(n2200), .C0(n2416), 
        .C1(n2515), .Y(FIFO88155) );
  OAI222XL U2134 ( .A0(n1630), .A1(n2513), .B0(n1687), .B1(n2201), .C0(n2419), 
        .C1(n2515), .Y(FIFO88156) );
  OAI222XL U2135 ( .A0(n1652), .A1(n1686), .B0(n1687), .B1(n2218), .C0(n2470), 
        .C1(n1688), .Y(FIFO88157) );
  OAI222XL U2136 ( .A0(n1674), .A1(n2514), .B0(n1687), .B1(n2219), .C0(n2473), 
        .C1(n2516), .Y(FIFO88158) );
  OAI222XL U2137 ( .A0(n1626), .A1(n2518), .B0(n1683), .B1(n2330), .C0(n2422), 
        .C1(n2520), .Y(FIFO88159) );
  OAI222XL U2138 ( .A0(n1628), .A1(n1682), .B0(n1683), .B1(n2316), .C0(n2380), 
        .C1(n1684), .Y(FIFO88160) );
  OAI222XL U2139 ( .A0(n1632), .A1(n2518), .B0(n1683), .B1(n2331), .C0(n2425), 
        .C1(n2520), .Y(FIFO88161) );
  OAI222XL U2140 ( .A0(n1634), .A1(n1682), .B0(n1683), .B1(n2332), .C0(n2428), 
        .C1(n1684), .Y(FIFO88162) );
  OAI222XL U2141 ( .A0(n1636), .A1(n2517), .B0(n1683), .B1(n2317), .C0(n2383), 
        .C1(n2519), .Y(FIFO88163) );
  OAI222XL U2142 ( .A0(n1638), .A1(n2518), .B0(n1683), .B1(n2333), .C0(n2431), 
        .C1(n2520), .Y(FIFO88164) );
  OAI222XL U2143 ( .A0(n1640), .A1(n1682), .B0(n1683), .B1(n2318), .C0(n2386), 
        .C1(n1684), .Y(FIFO88165) );
  OAI222XL U2144 ( .A0(n1642), .A1(n2517), .B0(n1683), .B1(n2319), .C0(n2389), 
        .C1(n2519), .Y(FIFO88166) );
  OAI222XL U2145 ( .A0(n1644), .A1(n2518), .B0(n1683), .B1(n2334), .C0(n2434), 
        .C1(n2520), .Y(FIFO88167) );
  OAI222XL U2146 ( .A0(n1646), .A1(n1682), .B0(n1683), .B1(n2335), .C0(n2437), 
        .C1(n1684), .Y(FIFO88168) );
  OAI222XL U2147 ( .A0(n1648), .A1(n2517), .B0(n1683), .B1(n2320), .C0(n2392), 
        .C1(n2519), .Y(FIFO88169) );
  OAI222XL U2148 ( .A0(n1650), .A1(n2518), .B0(n1683), .B1(n2336), .C0(n2440), 
        .C1(n2520), .Y(FIFO88170) );
  OAI222XL U2149 ( .A0(n1654), .A1(n2517), .B0(n1683), .B1(n2321), .C0(n2395), 
        .C1(n2519), .Y(FIFO88171) );
  OAI222XL U2150 ( .A0(n1656), .A1(n2518), .B0(n1683), .B1(n2337), .C0(n2443), 
        .C1(n2520), .Y(FIFO88172) );
  OAI222XL U2151 ( .A0(n1658), .A1(n1682), .B0(n1683), .B1(n2338), .C0(n2446), 
        .C1(n1684), .Y(FIFO88173) );
  OAI222XL U2152 ( .A0(n1660), .A1(n2517), .B0(n1683), .B1(n2322), .C0(n2398), 
        .C1(n2519), .Y(FIFO88174) );
  OAI222XL U2153 ( .A0(n1662), .A1(n2518), .B0(n1683), .B1(n2339), .C0(n2449), 
        .C1(n2520), .Y(FIFO88175) );
  OAI222XL U2154 ( .A0(n1664), .A1(n1682), .B0(n1683), .B1(n2340), .C0(n2452), 
        .C1(n1684), .Y(FIFO88176) );
  OAI222XL U2155 ( .A0(n1666), .A1(n2517), .B0(n1683), .B1(n2323), .C0(n2401), 
        .C1(n2519), .Y(FIFO88177) );
  OAI222XL U2156 ( .A0(n1668), .A1(n2518), .B0(n1683), .B1(n2341), .C0(n2455), 
        .C1(n2520), .Y(FIFO88178) );
  OAI222XL U2157 ( .A0(n1670), .A1(n1682), .B0(n1683), .B1(n2342), .C0(n2458), 
        .C1(n1684), .Y(FIFO88179) );
  OAI222XL U2158 ( .A0(n1672), .A1(n2517), .B0(n1683), .B1(n2324), .C0(n2404), 
        .C1(n2519), .Y(FIFO88180) );
  OAI222XL U2159 ( .A0(n1610), .A1(n2517), .B0(n1683), .B1(n2325), .C0(n2407), 
        .C1(n2519), .Y(FIFO88181) );
  OAI222XL U2160 ( .A0(n1614), .A1(n2518), .B0(n1683), .B1(n2343), .C0(n2461), 
        .C1(n2520), .Y(FIFO88182) );
  OAI222XL U2161 ( .A0(n1616), .A1(n1682), .B0(n1683), .B1(n2326), .C0(n2410), 
        .C1(n1684), .Y(FIFO88183) );
  OAI222XL U2162 ( .A0(n1618), .A1(n2517), .B0(n1683), .B1(n2327), .C0(n2413), 
        .C1(n2519), .Y(FIFO88184) );
  OAI222XL U2163 ( .A0(n1620), .A1(n2518), .B0(n1683), .B1(n2344), .C0(n2464), 
        .C1(n2520), .Y(FIFO88185) );
  OAI222XL U2164 ( .A0(n1622), .A1(n1682), .B0(n1683), .B1(n2345), .C0(n2467), 
        .C1(n1684), .Y(FIFO88186) );
  OAI222XL U2165 ( .A0(n1624), .A1(n2517), .B0(n1683), .B1(n2328), .C0(n2416), 
        .C1(n2519), .Y(FIFO88187) );
  OAI222XL U2166 ( .A0(n1630), .A1(n2517), .B0(n1683), .B1(n2329), .C0(n2419), 
        .C1(n2519), .Y(FIFO88188) );
  OAI222XL U2167 ( .A0(n1652), .A1(n1682), .B0(n1683), .B1(n2346), .C0(n2470), 
        .C1(n1684), .Y(FIFO88189) );
  OAI222XL U2168 ( .A0(n1674), .A1(n2518), .B0(n1683), .B1(n2347), .C0(n2473), 
        .C1(n2520), .Y(FIFO88190) );
  OAI222XL U2169 ( .A0(n1626), .A1(n2522), .B0(n1679), .B1(n2170), .C0(n2422), 
        .C1(n2524), .Y(FIFO88191) );
  OAI222XL U2170 ( .A0(n1628), .A1(n1678), .B0(n1679), .B1(n2156), .C0(n2380), 
        .C1(n1680), .Y(FIFO88192) );
  OAI222XL U2171 ( .A0(n1632), .A1(n2522), .B0(n1679), .B1(n2171), .C0(n2425), 
        .C1(n2524), .Y(FIFO88193) );
  OAI222XL U2172 ( .A0(n1634), .A1(n1678), .B0(n1679), .B1(n2172), .C0(n2428), 
        .C1(n1680), .Y(FIFO88194) );
  OAI222XL U2173 ( .A0(n1636), .A1(n2521), .B0(n1679), .B1(n2157), .C0(n2383), 
        .C1(n2523), .Y(FIFO88195) );
  OAI222XL U2174 ( .A0(n1638), .A1(n2522), .B0(n1679), .B1(n2173), .C0(n2431), 
        .C1(n2524), .Y(FIFO88196) );
  OAI222XL U2175 ( .A0(n1640), .A1(n1678), .B0(n1679), .B1(n2158), .C0(n2386), 
        .C1(n1680), .Y(FIFO88197) );
  OAI222XL U2176 ( .A0(n1642), .A1(n2521), .B0(n1679), .B1(n2159), .C0(n2389), 
        .C1(n2523), .Y(FIFO88198) );
  OAI222XL U2177 ( .A0(n1644), .A1(n2522), .B0(n1679), .B1(n2174), .C0(n2434), 
        .C1(n2524), .Y(FIFO88199) );
  OAI222XL U2178 ( .A0(n1646), .A1(n1678), .B0(n1679), .B1(n2175), .C0(n2437), 
        .C1(n1680), .Y(FIFO88200) );
  OAI222XL U2179 ( .A0(n1648), .A1(n2521), .B0(n1679), .B1(n2160), .C0(n2392), 
        .C1(n2523), .Y(FIFO88201) );
  OAI222XL U2180 ( .A0(n1650), .A1(n2522), .B0(n1679), .B1(n2176), .C0(n2440), 
        .C1(n2524), .Y(FIFO88202) );
  OAI222XL U2181 ( .A0(n1654), .A1(n2521), .B0(n1679), .B1(n2161), .C0(n2395), 
        .C1(n2523), .Y(FIFO88203) );
  OAI222XL U2182 ( .A0(n1656), .A1(n2522), .B0(n1679), .B1(n2177), .C0(n2443), 
        .C1(n2524), .Y(FIFO88204) );
  OAI222XL U2183 ( .A0(n1658), .A1(n1678), .B0(n1679), .B1(n2178), .C0(n2446), 
        .C1(n1680), .Y(FIFO88205) );
  OAI222XL U2184 ( .A0(n1660), .A1(n2521), .B0(n1679), .B1(n2162), .C0(n2398), 
        .C1(n2523), .Y(FIFO88206) );
  OAI222XL U2185 ( .A0(n1662), .A1(n2522), .B0(n1679), .B1(n2179), .C0(n2449), 
        .C1(n2524), .Y(FIFO88207) );
  OAI222XL U2186 ( .A0(n1664), .A1(n1678), .B0(n1679), .B1(n2180), .C0(n2452), 
        .C1(n1680), .Y(FIFO88208) );
  OAI222XL U2187 ( .A0(n1666), .A1(n2521), .B0(n1679), .B1(n2163), .C0(n2401), 
        .C1(n2523), .Y(FIFO88209) );
  OAI222XL U2188 ( .A0(n1668), .A1(n2522), .B0(n1679), .B1(n2181), .C0(n2455), 
        .C1(n2524), .Y(FIFO88210) );
  OAI222XL U2189 ( .A0(n1670), .A1(n1678), .B0(n1679), .B1(n2182), .C0(n2458), 
        .C1(n1680), .Y(FIFO88211) );
  OAI222XL U2190 ( .A0(n1672), .A1(n2521), .B0(n1679), .B1(n2164), .C0(n2404), 
        .C1(n2523), .Y(FIFO88212) );
  OAI222XL U2191 ( .A0(n1610), .A1(n2521), .B0(n1679), .B1(n2165), .C0(n2407), 
        .C1(n2523), .Y(FIFO88213) );
  OAI222XL U2192 ( .A0(n1614), .A1(n2522), .B0(n1679), .B1(n2183), .C0(n2461), 
        .C1(n2524), .Y(FIFO88214) );
  OAI222XL U2193 ( .A0(n1616), .A1(n1678), .B0(n1679), .B1(n2166), .C0(n2410), 
        .C1(n1680), .Y(FIFO88215) );
  OAI222XL U2194 ( .A0(n1618), .A1(n2521), .B0(n1679), .B1(n2167), .C0(n2413), 
        .C1(n2523), .Y(FIFO88216) );
  OAI222XL U2195 ( .A0(n1620), .A1(n2522), .B0(n1679), .B1(n2184), .C0(n2464), 
        .C1(n2524), .Y(FIFO88217) );
  OAI222XL U2196 ( .A0(n1622), .A1(n1678), .B0(n1679), .B1(n2185), .C0(n2467), 
        .C1(n1680), .Y(FIFO88218) );
  OAI222XL U2197 ( .A0(n1624), .A1(n2521), .B0(n1679), .B1(n2168), .C0(n2416), 
        .C1(n2523), .Y(FIFO88219) );
  OAI222XL U2198 ( .A0(n1630), .A1(n2521), .B0(n1679), .B1(n2169), .C0(n2419), 
        .C1(n2523), .Y(FIFO88220) );
  OAI222XL U2199 ( .A0(n1652), .A1(n1678), .B0(n1679), .B1(n2186), .C0(n2470), 
        .C1(n1680), .Y(FIFO88221) );
  OAI222XL U2200 ( .A0(n1674), .A1(n2522), .B0(n1679), .B1(n2187), .C0(n2473), 
        .C1(n2524), .Y(FIFO88222) );
  OAI222XL U2201 ( .A0(n2526), .A1(n1626), .B0(n1611), .B1(n2271), .C0(n2422), 
        .C1(n2528), .Y(FIFO88223) );
  OAI222XL U2202 ( .A0(n1609), .A1(n1628), .B0(n1611), .B1(n2252), .C0(n2380), 
        .C1(n1613), .Y(FIFO88224) );
  OAI222XL U2203 ( .A0(n2526), .A1(n1632), .B0(n1611), .B1(n2272), .C0(n2425), 
        .C1(n2528), .Y(FIFO88225) );
  OAI222XL U2204 ( .A0(n1609), .A1(n1634), .B0(n1611), .B1(n2273), .C0(n2428), 
        .C1(n1613), .Y(FIFO88226) );
  OAI222XL U2205 ( .A0(n2525), .A1(n1636), .B0(n1611), .B1(n2253), .C0(n2383), 
        .C1(n2527), .Y(FIFO88227) );
  OAI222XL U2206 ( .A0(n2526), .A1(n1638), .B0(n1611), .B1(n2274), .C0(n2431), 
        .C1(n2528), .Y(FIFO88228) );
  OAI222XL U2207 ( .A0(n1609), .A1(n1640), .B0(n1611), .B1(n2254), .C0(n2386), 
        .C1(n1613), .Y(FIFO88229) );
  OAI222XL U2208 ( .A0(n2525), .A1(n1642), .B0(n1611), .B1(n2255), .C0(n2389), 
        .C1(n2527), .Y(FIFO88230) );
  OAI222XL U2209 ( .A0(n2526), .A1(n1644), .B0(n1611), .B1(n2275), .C0(n2434), 
        .C1(n2528), .Y(FIFO88231) );
  OAI222XL U2210 ( .A0(n1609), .A1(n1646), .B0(n1611), .B1(n2256), .C0(n2437), 
        .C1(n1613), .Y(FIFO88232) );
  OAI222XL U2211 ( .A0(n2525), .A1(n1648), .B0(n1611), .B1(n2257), .C0(n2392), 
        .C1(n2527), .Y(FIFO88233) );
  OAI222XL U2212 ( .A0(n2526), .A1(n1650), .B0(n1611), .B1(n2276), .C0(n2440), 
        .C1(n2528), .Y(FIFO88234) );
  OAI222XL U2213 ( .A0(n2525), .A1(n1654), .B0(n1611), .B1(n2258), .C0(n2395), 
        .C1(n2527), .Y(FIFO88235) );
  OAI222XL U2214 ( .A0(n2526), .A1(n1656), .B0(n1611), .B1(n2277), .C0(n2443), 
        .C1(n2528), .Y(FIFO88236) );
  OAI222XL U2215 ( .A0(n1609), .A1(n1658), .B0(n1611), .B1(n2267), .C0(n2446), 
        .C1(n1613), .Y(FIFO88237) );
  OAI222XL U2216 ( .A0(n2525), .A1(n1660), .B0(n1611), .B1(n2259), .C0(n2398), 
        .C1(n2527), .Y(FIFO88238) );
  OAI222XL U2217 ( .A0(n2526), .A1(n1662), .B0(n1611), .B1(n2278), .C0(n2449), 
        .C1(n2528), .Y(FIFO88239) );
  OAI222XL U2218 ( .A0(n1609), .A1(n1664), .B0(n1611), .B1(n2268), .C0(n2452), 
        .C1(n1613), .Y(FIFO88240) );
  OAI222XL U2219 ( .A0(n2525), .A1(n1666), .B0(n1611), .B1(n2260), .C0(n2401), 
        .C1(n2527), .Y(FIFO88241) );
  OAI222XL U2220 ( .A0(n2526), .A1(n1668), .B0(n1611), .B1(n2279), .C0(n2455), 
        .C1(n2528), .Y(FIFO88242) );
  OAI222XL U2221 ( .A0(n1609), .A1(n1670), .B0(n1611), .B1(n2269), .C0(n2458), 
        .C1(n1613), .Y(FIFO88243) );
  OAI222XL U2222 ( .A0(n2525), .A1(n1672), .B0(n1611), .B1(n2261), .C0(n2404), 
        .C1(n2527), .Y(FIFO88244) );
  OAI222XL U2223 ( .A0(n2525), .A1(n1610), .B0(n1611), .B1(n2262), .C0(n2407), 
        .C1(n2527), .Y(FIFO88245) );
  OAI222XL U2224 ( .A0(n2526), .A1(n1614), .B0(n1611), .B1(n2280), .C0(n2461), 
        .C1(n2528), .Y(FIFO88246) );
  OAI222XL U2225 ( .A0(n1609), .A1(n1616), .B0(n1611), .B1(n2263), .C0(n2410), 
        .C1(n1613), .Y(FIFO88247) );
  OAI222XL U2226 ( .A0(n2525), .A1(n1618), .B0(n1611), .B1(n2264), .C0(n2413), 
        .C1(n2527), .Y(FIFO88248) );
  OAI222XL U2227 ( .A0(n2526), .A1(n1620), .B0(n1611), .B1(n2281), .C0(n2464), 
        .C1(n2528), .Y(FIFO88249) );
  OAI222XL U2228 ( .A0(n1609), .A1(n1622), .B0(n1611), .B1(n2282), .C0(n2467), 
        .C1(n1613), .Y(FIFO88250) );
  OAI222XL U2229 ( .A0(n2525), .A1(n1624), .B0(n1611), .B1(n2265), .C0(n2416), 
        .C1(n2527), .Y(FIFO88251) );
  OAI222XL U2230 ( .A0(n2525), .A1(n1630), .B0(n1611), .B1(n2266), .C0(n2419), 
        .C1(n2527), .Y(FIFO88252) );
  OAI222XL U2231 ( .A0(n1609), .A1(n1652), .B0(n1611), .B1(n2270), .C0(n2470), 
        .C1(n1613), .Y(FIFO88253) );
  OAI222XL U2232 ( .A0(n2526), .A1(n1674), .B0(n1611), .B1(n2283), .C0(n2473), 
        .C1(n2528), .Y(FIFO88254) );
  OAI222XL U2233 ( .A0(n1626), .A1(n2502), .B0(n1699), .B1(n2239), .C0(n2422), 
        .C1(n2504), .Y(FIFO8831) );
  OAI222XL U2234 ( .A0(n1628), .A1(n1698), .B0(n1699), .B1(n2220), .C0(n2380), 
        .C1(n1700), .Y(FIFO8832) );
  OAI222XL U2235 ( .A0(n1632), .A1(n2502), .B0(n1699), .B1(n2240), .C0(n2425), 
        .C1(n2504), .Y(FIFO8833) );
  OAI222XL U2236 ( .A0(n1634), .A1(n1698), .B0(n1699), .B1(n2241), .C0(n2428), 
        .C1(n1700), .Y(FIFO8834) );
  OAI222XL U2237 ( .A0(n1636), .A1(n2501), .B0(n1699), .B1(n2221), .C0(n2383), 
        .C1(n2503), .Y(FIFO8835) );
  OAI222XL U2238 ( .A0(n1638), .A1(n2502), .B0(n1699), .B1(n2242), .C0(n2431), 
        .C1(n2504), .Y(FIFO8836) );
  OAI222XL U2239 ( .A0(n1640), .A1(n1698), .B0(n1699), .B1(n2222), .C0(n2386), 
        .C1(n1700), .Y(FIFO8837) );
  OAI222XL U2240 ( .A0(n1642), .A1(n2501), .B0(n1699), .B1(n2223), .C0(n2389), 
        .C1(n2503), .Y(FIFO8838) );
  OAI222XL U2241 ( .A0(n1644), .A1(n2502), .B0(n1699), .B1(n2243), .C0(n2434), 
        .C1(n2504), .Y(FIFO8839) );
  OAI222XL U2242 ( .A0(n1646), .A1(n1698), .B0(n1699), .B1(n2224), .C0(n2437), 
        .C1(n1700), .Y(FIFO8840) );
  OAI222XL U2243 ( .A0(n1648), .A1(n2501), .B0(n1699), .B1(n2225), .C0(n2392), 
        .C1(n2503), .Y(FIFO8841) );
  OAI222XL U2244 ( .A0(n1650), .A1(n2502), .B0(n1699), .B1(n2244), .C0(n2440), 
        .C1(n2504), .Y(FIFO8842) );
  OAI222XL U2245 ( .A0(n1654), .A1(n2501), .B0(n1699), .B1(n2226), .C0(n2395), 
        .C1(n2503), .Y(FIFO8843) );
  OAI222XL U2246 ( .A0(n1656), .A1(n2502), .B0(n1699), .B1(n2245), .C0(n2443), 
        .C1(n2504), .Y(FIFO8844) );
  OAI222XL U2247 ( .A0(n1658), .A1(n1698), .B0(n1699), .B1(n2235), .C0(n2446), 
        .C1(n1700), .Y(FIFO8845) );
  OAI222XL U2248 ( .A0(n1660), .A1(n2501), .B0(n1699), .B1(n2227), .C0(n2398), 
        .C1(n2503), .Y(FIFO8846) );
  OAI222XL U2249 ( .A0(n1662), .A1(n2502), .B0(n1699), .B1(n2246), .C0(n2449), 
        .C1(n2504), .Y(FIFO8847) );
  OAI222XL U2250 ( .A0(n1664), .A1(n1698), .B0(n1699), .B1(n2236), .C0(n2452), 
        .C1(n1700), .Y(FIFO8848) );
  OAI222XL U2251 ( .A0(n1666), .A1(n2501), .B0(n1699), .B1(n2228), .C0(n2401), 
        .C1(n2503), .Y(FIFO8849) );
  OAI222XL U2252 ( .A0(n1668), .A1(n2502), .B0(n1699), .B1(n2247), .C0(n2455), 
        .C1(n2504), .Y(FIFO8850) );
  OAI222XL U2253 ( .A0(n1670), .A1(n1698), .B0(n1699), .B1(n2237), .C0(n2458), 
        .C1(n1700), .Y(FIFO8851) );
  OAI222XL U2254 ( .A0(n1672), .A1(n2501), .B0(n1699), .B1(n2229), .C0(n2404), 
        .C1(n2503), .Y(FIFO8852) );
  OAI222XL U2255 ( .A0(n1610), .A1(n2501), .B0(n1699), .B1(n2230), .C0(n2407), 
        .C1(n2503), .Y(FIFO8853) );
  OAI222XL U2256 ( .A0(n1614), .A1(n2502), .B0(n1699), .B1(n2248), .C0(n2461), 
        .C1(n2504), .Y(FIFO8854) );
  OAI222XL U2257 ( .A0(n1616), .A1(n1698), .B0(n1699), .B1(n2231), .C0(n2410), 
        .C1(n1700), .Y(FIFO8855) );
  OAI222XL U2258 ( .A0(n1618), .A1(n2501), .B0(n1699), .B1(n2232), .C0(n2413), 
        .C1(n2503), .Y(FIFO8856) );
  OAI222XL U2259 ( .A0(n1620), .A1(n2502), .B0(n1699), .B1(n2249), .C0(n2464), 
        .C1(n2504), .Y(FIFO8857) );
  OAI222XL U2260 ( .A0(n1622), .A1(n1698), .B0(n1699), .B1(n2250), .C0(n2467), 
        .C1(n1700), .Y(FIFO8858) );
  OAI222XL U2261 ( .A0(n1624), .A1(n2501), .B0(n1699), .B1(n2233), .C0(n2416), 
        .C1(n2503), .Y(FIFO8859) );
  OAI222XL U2262 ( .A0(n1630), .A1(n2501), .B0(n1699), .B1(n2234), .C0(n2419), 
        .C1(n2503), .Y(FIFO8860) );
  OAI222XL U2263 ( .A0(n1652), .A1(n1698), .B0(n1699), .B1(n2238), .C0(n2470), 
        .C1(n1700), .Y(FIFO8861) );
  OAI222XL U2264 ( .A0(n1674), .A1(n2502), .B0(n1699), .B1(n2251), .C0(n2473), 
        .C1(n2504), .Y(FIFO8862) );
  OAI222XL U2265 ( .A0(n1626), .A1(n2510), .B0(n1691), .B1(n2298), .C0(n2422), 
        .C1(n2512), .Y(FIFO8895) );
  OAI222XL U2266 ( .A0(n1628), .A1(n1690), .B0(n1691), .B1(n2284), .C0(n2380), 
        .C1(n1692), .Y(FIFO8896) );
  OAI222XL U2267 ( .A0(n1632), .A1(n2510), .B0(n1691), .B1(n2299), .C0(n2425), 
        .C1(n2512), .Y(FIFO8897) );
  OAI222XL U2268 ( .A0(n1634), .A1(n1690), .B0(n1691), .B1(n2300), .C0(n2428), 
        .C1(n1692), .Y(FIFO8898) );
  OAI222XL U2269 ( .A0(n1636), .A1(n2509), .B0(n1691), .B1(n2285), .C0(n2383), 
        .C1(n2511), .Y(FIFO8899) );
  OAI222XL U2270 ( .A0(n1638), .A1(n2510), .B0(n1691), .B1(n2301), .C0(n2431), 
        .C1(n2512), .Y(FIFO88100) );
  OAI222XL U2271 ( .A0(n1640), .A1(n1690), .B0(n1691), .B1(n2286), .C0(n2386), 
        .C1(n1692), .Y(FIFO88101) );
  OAI222XL U2272 ( .A0(n1642), .A1(n2509), .B0(n1691), .B1(n2287), .C0(n2389), 
        .C1(n2511), .Y(FIFO88102) );
  OAI222XL U2273 ( .A0(n1644), .A1(n2510), .B0(n1691), .B1(n2302), .C0(n2434), 
        .C1(n2512), .Y(FIFO88103) );
  OAI222XL U2274 ( .A0(n1646), .A1(n1690), .B0(n1691), .B1(n2303), .C0(n2437), 
        .C1(n1692), .Y(FIFO88104) );
  OAI222XL U2275 ( .A0(n1648), .A1(n2509), .B0(n1691), .B1(n2288), .C0(n2392), 
        .C1(n2511), .Y(FIFO88105) );
  OAI222XL U2276 ( .A0(n1650), .A1(n2510), .B0(n1691), .B1(n2304), .C0(n2440), 
        .C1(n2512), .Y(FIFO88106) );
  OAI222XL U2277 ( .A0(n1654), .A1(n2509), .B0(n1691), .B1(n2289), .C0(n2395), 
        .C1(n2511), .Y(FIFO88107) );
  OAI222XL U2278 ( .A0(n1656), .A1(n2510), .B0(n1691), .B1(n2305), .C0(n2443), 
        .C1(n2512), .Y(FIFO88108) );
  OAI222XL U2279 ( .A0(n1658), .A1(n1690), .B0(n1691), .B1(n2306), .C0(n2446), 
        .C1(n1692), .Y(FIFO88109) );
  OAI222XL U2280 ( .A0(n1660), .A1(n2509), .B0(n1691), .B1(n2290), .C0(n2398), 
        .C1(n2511), .Y(FIFO88110) );
  OAI222XL U2281 ( .A0(n1662), .A1(n2510), .B0(n1691), .B1(n2307), .C0(n2449), 
        .C1(n2512), .Y(FIFO88111) );
  OAI222XL U2282 ( .A0(n1664), .A1(n1690), .B0(n1691), .B1(n2308), .C0(n2452), 
        .C1(n1692), .Y(FIFO88112) );
  OAI222XL U2283 ( .A0(n1666), .A1(n2509), .B0(n1691), .B1(n2291), .C0(n2401), 
        .C1(n2511), .Y(FIFO88113) );
  OAI222XL U2284 ( .A0(n1668), .A1(n2510), .B0(n1691), .B1(n2309), .C0(n2455), 
        .C1(n2512), .Y(FIFO88114) );
  OAI222XL U2285 ( .A0(n1670), .A1(n1690), .B0(n1691), .B1(n2310), .C0(n2458), 
        .C1(n1692), .Y(FIFO88115) );
  OAI222XL U2286 ( .A0(n1672), .A1(n2509), .B0(n1691), .B1(n2292), .C0(n2404), 
        .C1(n2511), .Y(FIFO88116) );
  OAI222XL U2287 ( .A0(n1610), .A1(n2509), .B0(n1691), .B1(n2293), .C0(n2407), 
        .C1(n2511), .Y(FIFO88117) );
  OAI222XL U2288 ( .A0(n1614), .A1(n2510), .B0(n1691), .B1(n2311), .C0(n2461), 
        .C1(n2512), .Y(FIFO88118) );
  OAI222XL U2289 ( .A0(n1616), .A1(n1690), .B0(n1691), .B1(n2294), .C0(n2410), 
        .C1(n1692), .Y(FIFO88119) );
  OAI222XL U2290 ( .A0(n1618), .A1(n2509), .B0(n1691), .B1(n2295), .C0(n2413), 
        .C1(n2511), .Y(FIFO88120) );
  OAI222XL U2291 ( .A0(n1620), .A1(n2510), .B0(n1691), .B1(n2312), .C0(n2464), 
        .C1(n2512), .Y(FIFO88121) );
  OAI222XL U2292 ( .A0(n1622), .A1(n1690), .B0(n1691), .B1(n2313), .C0(n2467), 
        .C1(n1692), .Y(FIFO88122) );
  OAI222XL U2293 ( .A0(n1624), .A1(n2509), .B0(n1691), .B1(n2296), .C0(n2416), 
        .C1(n2511), .Y(FIFO88123) );
  OAI222XL U2294 ( .A0(n1630), .A1(n2509), .B0(n1691), .B1(n2297), .C0(n2419), 
        .C1(n2511), .Y(FIFO88124) );
  OAI222XL U2295 ( .A0(n1652), .A1(n1690), .B0(n1691), .B1(n2314), .C0(n2470), 
        .C1(n1692), .Y(FIFO88125) );
  OAI222XL U2296 ( .A0(n1674), .A1(n2510), .B0(n1691), .B1(n2315), .C0(n2473), 
        .C1(n2512), .Y(FIFO88126) );
  OAI222XL U2297 ( .A0(n1626), .A1(n2506), .B0(n1695), .B1(n2143), .C0(n2422), 
        .C1(n2508), .Y(FIFO8863) );
  OAI222XL U2298 ( .A0(n1628), .A1(n1694), .B0(n1695), .B1(n2124), .C0(n2380), 
        .C1(n1696), .Y(FIFO8864) );
  OAI222XL U2299 ( .A0(n1632), .A1(n2506), .B0(n1695), .B1(n2144), .C0(n2425), 
        .C1(n2508), .Y(FIFO8865) );
  OAI222XL U2300 ( .A0(n1634), .A1(n1694), .B0(n1695), .B1(n2145), .C0(n2428), 
        .C1(n1696), .Y(FIFO8866) );
  OAI222XL U2301 ( .A0(n1636), .A1(n2505), .B0(n1695), .B1(n2125), .C0(n2383), 
        .C1(n2507), .Y(FIFO8867) );
  OAI222XL U2302 ( .A0(n1638), .A1(n2506), .B0(n1695), .B1(n2146), .C0(n2431), 
        .C1(n2508), .Y(FIFO8868) );
  OAI222XL U2303 ( .A0(n1640), .A1(n1694), .B0(n1695), .B1(n2126), .C0(n2386), 
        .C1(n1696), .Y(FIFO8869) );
  OAI222XL U2304 ( .A0(n1642), .A1(n2505), .B0(n1695), .B1(n2127), .C0(n2389), 
        .C1(n2507), .Y(FIFO8870) );
  OAI222XL U2305 ( .A0(n1644), .A1(n2506), .B0(n1695), .B1(n2147), .C0(n2434), 
        .C1(n2508), .Y(FIFO8871) );
  OAI222XL U2306 ( .A0(n1646), .A1(n1694), .B0(n1695), .B1(n2128), .C0(n2437), 
        .C1(n1696), .Y(FIFO8872) );
  OAI222XL U2307 ( .A0(n1648), .A1(n2505), .B0(n1695), .B1(n2129), .C0(n2392), 
        .C1(n2507), .Y(FIFO8873) );
  OAI222XL U2308 ( .A0(n1650), .A1(n2506), .B0(n1695), .B1(n2148), .C0(n2440), 
        .C1(n2508), .Y(FIFO8874) );
  OAI222XL U2309 ( .A0(n1654), .A1(n2505), .B0(n1695), .B1(n2130), .C0(n2395), 
        .C1(n2507), .Y(FIFO8875) );
  OAI222XL U2310 ( .A0(n1656), .A1(n2506), .B0(n1695), .B1(n2149), .C0(n2443), 
        .C1(n2508), .Y(FIFO8876) );
  OAI222XL U2311 ( .A0(n1658), .A1(n1694), .B0(n1695), .B1(n2139), .C0(n2446), 
        .C1(n1696), .Y(FIFO8877) );
  OAI222XL U2312 ( .A0(n1660), .A1(n2505), .B0(n1695), .B1(n2131), .C0(n2398), 
        .C1(n2507), .Y(FIFO8878) );
  OAI222XL U2313 ( .A0(n1662), .A1(n2506), .B0(n1695), .B1(n2150), .C0(n2449), 
        .C1(n2508), .Y(FIFO8879) );
  OAI222XL U2314 ( .A0(n1664), .A1(n1694), .B0(n1695), .B1(n2140), .C0(n2452), 
        .C1(n1696), .Y(FIFO8880) );
  OAI222XL U2315 ( .A0(n1666), .A1(n2505), .B0(n1695), .B1(n2132), .C0(n2401), 
        .C1(n2507), .Y(FIFO8881) );
  OAI222XL U2316 ( .A0(n1668), .A1(n2506), .B0(n1695), .B1(n2151), .C0(n2455), 
        .C1(n2508), .Y(FIFO8882) );
  OAI222XL U2317 ( .A0(n1670), .A1(n1694), .B0(n1695), .B1(n2141), .C0(n2458), 
        .C1(n1696), .Y(FIFO8883) );
  OAI222XL U2318 ( .A0(n1672), .A1(n2505), .B0(n1695), .B1(n2133), .C0(n2404), 
        .C1(n2507), .Y(FIFO8884) );
  OAI222XL U2319 ( .A0(n1610), .A1(n2505), .B0(n1695), .B1(n2134), .C0(n2407), 
        .C1(n2507), .Y(FIFO8885) );
  OAI222XL U2320 ( .A0(n1614), .A1(n2506), .B0(n1695), .B1(n2152), .C0(n2461), 
        .C1(n2508), .Y(FIFO8886) );
  OAI222XL U2321 ( .A0(n1616), .A1(n1694), .B0(n1695), .B1(n2135), .C0(n2410), 
        .C1(n1696), .Y(FIFO8887) );
  OAI222XL U2322 ( .A0(n1618), .A1(n2505), .B0(n1695), .B1(n2136), .C0(n2413), 
        .C1(n2507), .Y(FIFO8888) );
  OAI222XL U2323 ( .A0(n1620), .A1(n2506), .B0(n1695), .B1(n2153), .C0(n2464), 
        .C1(n2508), .Y(FIFO8889) );
  OAI222XL U2324 ( .A0(n1622), .A1(n1694), .B0(n1695), .B1(n2154), .C0(n2467), 
        .C1(n1696), .Y(FIFO8890) );
  OAI222XL U2325 ( .A0(n1624), .A1(n2505), .B0(n1695), .B1(n2137), .C0(n2416), 
        .C1(n2507), .Y(FIFO8891) );
  OAI222XL U2326 ( .A0(n1630), .A1(n2505), .B0(n1695), .B1(n2138), .C0(n2419), 
        .C1(n2507), .Y(FIFO8892) );
  OAI222XL U2327 ( .A0(n1652), .A1(n1694), .B0(n1695), .B1(n2142), .C0(n2470), 
        .C1(n1696), .Y(FIFO8893) );
  OAI222XL U2328 ( .A0(n1674), .A1(n2506), .B0(n1695), .B1(n2155), .C0(n2473), 
        .C1(n2508), .Y(FIFO8894) );
  NAND3BX1 U2329 ( .AN(n2479), .B(n1865), .C(n2480), .Y(n2497) );
  NAND3BX1 U2330 ( .AN(n2479), .B(n1865), .C(n2480), .Y(n1689) );
  NAND3BX1 U2331 ( .AN(n1865), .B(n2479), .C(n2480), .Y(n2489) );
  NAND3BX1 U2332 ( .AN(n1865), .B(n2479), .C(n2480), .Y(n2490) );
  NAND3BX1 U2333 ( .AN(n2479), .B(n1865), .C(n2480), .Y(n2498) );
  NAND3BX1 U2334 ( .AN(n2480), .B(n1867), .C(n1865), .Y(n2482) );
  NAND3BX1 U2335 ( .AN(n1865), .B(n2479), .C(n2480), .Y(n1677) );
  NAND3BX1 U2336 ( .AN(n2480), .B(n1865), .C(n2479), .Y(n2487) );
  NAND3BX1 U2337 ( .AN(n2480), .B(n1865), .C(n2479), .Y(n2488) );
  NAND3BX1 U2338 ( .AN(n2480), .B(n1865), .C(n2479), .Y(n1697) );
  CLKINVX1 U2339 ( .A(n2479), .Y(n1867) );
  OAI221XL U2340 ( .A0(n2235), .A1(n2486), .B0(n2139), .B1(n2488), .C0(n1825), 
        .Y(n1822) );
  OA22X1 U2341 ( .A0(n2267), .A1(n1677), .B0(n2363), .B1(n1710), .Y(n1825) );
  OAI221XL U2342 ( .A0(n2236), .A1(n2485), .B0(n2140), .B1(n2487), .C0(n1840), 
        .Y(n1837) );
  OA22X1 U2343 ( .A0(n2268), .A1(n1677), .B0(n2364), .B1(n1710), .Y(n1840) );
  OAI221XL U2344 ( .A0(n2237), .A1(n2486), .B0(n2141), .B1(n2488), .C0(n1855), 
        .Y(n1852) );
  OA22X1 U2345 ( .A0(n2269), .A1(n1677), .B0(n2365), .B1(n1710), .Y(n1855) );
  OAI221XL U2346 ( .A0(n2238), .A1(n2485), .B0(n2142), .B1(n2487), .C0(n1810), 
        .Y(n1807) );
  OA22X1 U2347 ( .A0(n2270), .A1(n1677), .B0(n2366), .B1(n1710), .Y(n1810) );
  OAI221XL U2348 ( .A0(n2239), .A1(n2486), .B0(n2143), .B1(n2488), .C0(n1745), 
        .Y(n1742) );
  OA22X1 U2349 ( .A0(n2271), .A1(n2490), .B0(n2367), .B1(n2482), .Y(n1745) );
  OAI221XL U2350 ( .A0(n2240), .A1(n2486), .B0(n2144), .B1(n2488), .C0(n1760), 
        .Y(n1757) );
  OA22X1 U2351 ( .A0(n2272), .A1(n2490), .B0(n2368), .B1(n2482), .Y(n1760) );
  OAI221XL U2352 ( .A0(n2241), .A1(n2486), .B0(n2145), .B1(n2488), .C0(n1765), 
        .Y(n1762) );
  OA22X1 U2353 ( .A0(n2273), .A1(n2490), .B0(n2369), .B1(n2482), .Y(n1765) );
  OAI221XL U2354 ( .A0(n2242), .A1(n2486), .B0(n2146), .B1(n2488), .C0(n1775), 
        .Y(n1772) );
  OA22X1 U2355 ( .A0(n2274), .A1(n2490), .B0(n2370), .B1(n2482), .Y(n1775) );
  OAI221XL U2356 ( .A0(n2243), .A1(n2486), .B0(n2147), .B1(n2488), .C0(n1790), 
        .Y(n1787) );
  OA22X1 U2357 ( .A0(n2275), .A1(n2490), .B0(n2371), .B1(n2482), .Y(n1790) );
  OAI221XL U2358 ( .A0(n2244), .A1(n2486), .B0(n2148), .B1(n2488), .C0(n1805), 
        .Y(n1802) );
  OA22X1 U2359 ( .A0(n2276), .A1(n2490), .B0(n2372), .B1(n2482), .Y(n1805) );
  OAI221XL U2360 ( .A0(n2245), .A1(n2486), .B0(n2149), .B1(n2488), .C0(n1820), 
        .Y(n1817) );
  OA22X1 U2361 ( .A0(n2277), .A1(n2490), .B0(n2373), .B1(n2482), .Y(n1820) );
  OAI221XL U2362 ( .A0(n2246), .A1(n2486), .B0(n2150), .B1(n2488), .C0(n1835), 
        .Y(n1832) );
  OA22X1 U2363 ( .A0(n2278), .A1(n2490), .B0(n2374), .B1(n2482), .Y(n1835) );
  OAI221XL U2364 ( .A0(n2247), .A1(n2486), .B0(n2151), .B1(n2488), .C0(n1850), 
        .Y(n1847) );
  OA22X1 U2365 ( .A0(n2279), .A1(n2490), .B0(n2375), .B1(n2482), .Y(n1850) );
  OAI221XL U2366 ( .A0(n2248), .A1(n2486), .B0(n2152), .B1(n2488), .C0(n1715), 
        .Y(n1712) );
  OA22X1 U2367 ( .A0(n2280), .A1(n2490), .B0(n2376), .B1(n2482), .Y(n1715) );
  OAI221XL U2368 ( .A0(n2249), .A1(n2486), .B0(n2153), .B1(n2488), .C0(n1730), 
        .Y(n1727) );
  OA22X1 U2369 ( .A0(n2281), .A1(n2490), .B0(n2377), .B1(n2482), .Y(n1730) );
  OAI221XL U2370 ( .A0(n2250), .A1(n2486), .B0(n2154), .B1(n2488), .C0(n1735), 
        .Y(n1732) );
  OA22X1 U2371 ( .A0(n2282), .A1(n2490), .B0(n2378), .B1(n2482), .Y(n1735) );
  OAI221XL U2372 ( .A0(n2251), .A1(n2486), .B0(n2155), .B1(n2488), .C0(n1866), 
        .Y(n1862) );
  OA22X1 U2373 ( .A0(n2283), .A1(n2490), .B0(n2379), .B1(n2482), .Y(n1866) );
  NOR3X1 U2374 ( .A(n1742), .B(n2423), .C(n2424), .Y(n2422) );
  OAI22XL U2375 ( .A0(n2330), .A1(n2492), .B0(n2170), .B1(n2494), .Y(n2423) );
  OAI22XL U2376 ( .A0(n2298), .A1(n2496), .B0(n2202), .B1(n2498), .Y(n2424) );
  NOR3X1 U2377 ( .A(n1757), .B(n2426), .C(n2427), .Y(n2425) );
  OAI22XL U2378 ( .A0(n2331), .A1(n2492), .B0(n2171), .B1(n2494), .Y(n2426) );
  OAI22XL U2379 ( .A0(n2299), .A1(n2496), .B0(n2203), .B1(n2498), .Y(n2427) );
  NOR3X1 U2380 ( .A(n1762), .B(n2429), .C(n2430), .Y(n2428) );
  OAI22XL U2381 ( .A0(n2332), .A1(n2492), .B0(n2172), .B1(n2494), .Y(n2429) );
  OAI22XL U2382 ( .A0(n2300), .A1(n2496), .B0(n2204), .B1(n2498), .Y(n2430) );
  NOR3X1 U2383 ( .A(n1772), .B(n2432), .C(n2433), .Y(n2431) );
  OAI22XL U2384 ( .A0(n2333), .A1(n2492), .B0(n2173), .B1(n2494), .Y(n2432) );
  OAI22XL U2385 ( .A0(n2301), .A1(n2496), .B0(n2205), .B1(n2498), .Y(n2433) );
  NOR3X1 U2386 ( .A(n1787), .B(n2435), .C(n2436), .Y(n2434) );
  OAI22XL U2387 ( .A0(n2334), .A1(n2492), .B0(n2174), .B1(n2494), .Y(n2435) );
  OAI22XL U2388 ( .A0(n2302), .A1(n2496), .B0(n2206), .B1(n2498), .Y(n2436) );
  NOR3X1 U2389 ( .A(n1792), .B(n2438), .C(n2439), .Y(n2437) );
  OAI22XL U2390 ( .A0(n2335), .A1(n2492), .B0(n2175), .B1(n1681), .Y(n2438) );
  OAI22XL U2391 ( .A0(n2303), .A1(n2496), .B0(n2207), .B1(n1689), .Y(n2439) );
  NOR3X1 U2392 ( .A(n1802), .B(n2441), .C(n2442), .Y(n2440) );
  OAI22XL U2393 ( .A0(n2336), .A1(n2492), .B0(n2176), .B1(n2494), .Y(n2441) );
  OAI22XL U2394 ( .A0(n2304), .A1(n2496), .B0(n2208), .B1(n2498), .Y(n2442) );
  NOR3X1 U2395 ( .A(n1817), .B(n2444), .C(n2445), .Y(n2443) );
  OAI22XL U2396 ( .A0(n2337), .A1(n2492), .B0(n2177), .B1(n2494), .Y(n2444) );
  OAI22XL U2397 ( .A0(n2305), .A1(n2496), .B0(n2209), .B1(n2498), .Y(n2445) );
  NOR3X1 U2398 ( .A(n1822), .B(n2447), .C(n2448), .Y(n2446) );
  OAI22XL U2399 ( .A0(n2338), .A1(n1685), .B0(n2178), .B1(n1681), .Y(n2447) );
  OAI22XL U2400 ( .A0(n2306), .A1(n1693), .B0(n2210), .B1(n1689), .Y(n2448) );
  NOR3X1 U2401 ( .A(n1832), .B(n2450), .C(n2451), .Y(n2449) );
  OAI22XL U2402 ( .A0(n2339), .A1(n2492), .B0(n2179), .B1(n2494), .Y(n2450) );
  OAI22XL U2403 ( .A0(n2307), .A1(n2496), .B0(n2211), .B1(n2498), .Y(n2451) );
  NOR3X1 U2404 ( .A(n1837), .B(n2453), .C(n2454), .Y(n2452) );
  OAI22XL U2405 ( .A0(n2340), .A1(n1685), .B0(n2180), .B1(n1681), .Y(n2453) );
  OAI22XL U2406 ( .A0(n2308), .A1(n1693), .B0(n2212), .B1(n1689), .Y(n2454) );
  NOR3X1 U2407 ( .A(n1847), .B(n2456), .C(n2457), .Y(n2455) );
  OAI22XL U2408 ( .A0(n2341), .A1(n2492), .B0(n2181), .B1(n2494), .Y(n2456) );
  OAI22XL U2409 ( .A0(n2309), .A1(n2496), .B0(n2213), .B1(n2498), .Y(n2457) );
  NOR3X1 U2410 ( .A(n1852), .B(n2459), .C(n2460), .Y(n2458) );
  OAI22XL U2411 ( .A0(n2342), .A1(n1685), .B0(n2182), .B1(n1681), .Y(n2459) );
  OAI22XL U2412 ( .A0(n2310), .A1(n1693), .B0(n2214), .B1(n1689), .Y(n2460) );
  NOR3X1 U2413 ( .A(n1712), .B(n2462), .C(n2463), .Y(n2461) );
  OAI22XL U2414 ( .A0(n2343), .A1(n2492), .B0(n2183), .B1(n2494), .Y(n2462) );
  OAI22XL U2415 ( .A0(n2311), .A1(n2496), .B0(n2215), .B1(n2498), .Y(n2463) );
  NOR3X1 U2416 ( .A(n1727), .B(n2465), .C(n2466), .Y(n2464) );
  OAI22XL U2417 ( .A0(n2344), .A1(n2492), .B0(n2184), .B1(n2494), .Y(n2465) );
  OAI22XL U2418 ( .A0(n2312), .A1(n2496), .B0(n2216), .B1(n2498), .Y(n2466) );
  NOR3X1 U2419 ( .A(n1732), .B(n2468), .C(n2469), .Y(n2467) );
  OAI22XL U2420 ( .A0(n2345), .A1(n2492), .B0(n2185), .B1(n2494), .Y(n2468) );
  OAI22XL U2421 ( .A0(n2313), .A1(n2496), .B0(n2217), .B1(n2498), .Y(n2469) );
  NOR3X1 U2422 ( .A(n1807), .B(n2471), .C(n2472), .Y(n2470) );
  OAI22XL U2423 ( .A0(n2346), .A1(n1685), .B0(n2186), .B1(n1681), .Y(n2471) );
  OAI22XL U2424 ( .A0(n2314), .A1(n1693), .B0(n2218), .B1(n1689), .Y(n2472) );
  NOR3X1 U2425 ( .A(n1862), .B(n2474), .C(n2475), .Y(n2473) );
  OAI22XL U2426 ( .A0(n2347), .A1(n2492), .B0(n2187), .B1(n2494), .Y(n2474) );
  OAI22XL U2427 ( .A0(n2315), .A1(n2496), .B0(n2219), .B1(n2498), .Y(n2475) );
  CLKBUFX3 U2428 ( .A(ReadAddr[1]), .Y(n2477) );
  CLKBUFX3 U2429 ( .A(ReadAddr[2]), .Y(n2478) );
  CLKBUFX3 U2430 ( .A(ReadAddr[0]), .Y(n2476) );
  NAND3BX1 U2431 ( .AN(n2480), .B(WriteAddr[0]), .C(n2479), .Y(n2495) );
  NAND3BX1 U2432 ( .AN(n2479), .B(WriteAddr[0]), .C(n2480), .Y(n2491) );
  NAND3BX1 U2433 ( .AN(n2480), .B(WriteAddr[0]), .C(n2479), .Y(n2496) );
  NAND3BX1 U2434 ( .AN(n2479), .B(WriteAddr[0]), .C(n2480), .Y(n2492) );
  NAND3BX1 U2435 ( .AN(n2480), .B(WriteAddr[0]), .C(n2479), .Y(n1693) );
  NAND3BX1 U2436 ( .AN(n2479), .B(WriteAddr[0]), .C(n2480), .Y(n1685) );
  NAND3BX1 U2437 ( .AN(WriteAddr[0]), .B(n2479), .C(n2480), .Y(n2493) );
  NAND3BX1 U2438 ( .AN(WriteAddr[0]), .B(n2479), .C(n2480), .Y(n1681) );
  NAND3BX1 U2439 ( .AN(WriteAddr[0]), .B(n2479), .C(n2480), .Y(n2494) );
  NAND3BX1 U2440 ( .AN(n2480), .B(n1867), .C(WriteAddr[0]), .Y(n2485) );
  NAND3BX1 U2441 ( .AN(n2480), .B(n1867), .C(WriteAddr[0]), .Y(n2486) );
  NAND3BX1 U2442 ( .AN(n2480), .B(n1867), .C(WriteAddr[0]), .Y(n1701) );
  CLKBUFX3 U2443 ( .A(WriteAddr[1]), .Y(n2479) );
  CLKBUFX3 U2444 ( .A(WriteAddr[2]), .Y(n2480) );
  CLKINVX1 U2445 ( .A(FIFOWrData[31]), .Y(n1626) );
  CLKINVX1 U2446 ( .A(FIFOWrData[30]), .Y(n1628) );
  CLKINVX1 U2447 ( .A(FIFOWrData[29]), .Y(n1632) );
  CLKINVX1 U2448 ( .A(FIFOWrData[28]), .Y(n1634) );
  CLKINVX1 U2449 ( .A(FIFOWrData[27]), .Y(n1636) );
  CLKINVX1 U2450 ( .A(FIFOWrData[26]), .Y(n1638) );
  CLKINVX1 U2451 ( .A(FIFOWrData[25]), .Y(n1640) );
  CLKINVX1 U2452 ( .A(FIFOWrData[24]), .Y(n1642) );
  CLKINVX1 U2453 ( .A(FIFOWrData[23]), .Y(n1644) );
  CLKINVX1 U2454 ( .A(FIFOWrData[22]), .Y(n1646) );
  CLKINVX1 U2455 ( .A(FIFOWrData[21]), .Y(n1648) );
  CLKINVX1 U2456 ( .A(FIFOWrData[20]), .Y(n1650) );
  CLKINVX1 U2457 ( .A(FIFOWrData[19]), .Y(n1654) );
  CLKINVX1 U2458 ( .A(FIFOWrData[18]), .Y(n1656) );
  CLKINVX1 U2459 ( .A(FIFOWrData[17]), .Y(n1658) );
  CLKINVX1 U2460 ( .A(FIFOWrData[16]), .Y(n1660) );
  CLKINVX1 U2461 ( .A(FIFOWrData[15]), .Y(n1662) );
  CLKINVX1 U2462 ( .A(FIFOWrData[14]), .Y(n1664) );
  CLKINVX1 U2463 ( .A(FIFOWrData[13]), .Y(n1666) );
  CLKINVX1 U2464 ( .A(FIFOWrData[12]), .Y(n1668) );
  CLKINVX1 U2465 ( .A(FIFOWrData[11]), .Y(n1670) );
  CLKINVX1 U2466 ( .A(FIFOWrData[10]), .Y(n1672) );
  CLKINVX1 U2467 ( .A(FIFOWrData[9]), .Y(n1610) );
  CLKINVX1 U2468 ( .A(FIFOWrData[8]), .Y(n1614) );
  CLKINVX1 U2469 ( .A(FIFOWrData[7]), .Y(n1616) );
  CLKINVX1 U2470 ( .A(FIFOWrData[6]), .Y(n1618) );
  CLKINVX1 U2471 ( .A(FIFOWrData[5]), .Y(n1620) );
  CLKINVX1 U2472 ( .A(FIFOWrData[4]), .Y(n1622) );
  CLKINVX1 U2473 ( .A(FIFOWrData[3]), .Y(n1624) );
  CLKINVX1 U2474 ( .A(FIFOWrData[2]), .Y(n1630) );
  CLKINVX1 U2475 ( .A(FIFOWrData[1]), .Y(n1652) );
  CLKINVX1 U2476 ( .A(FIFOWrData[0]), .Y(n1674) );
  DFFX1 FIFO_reg ( .D(FIFO88), .CK(Clk), .QN(n2367) );
  DFFX1 FIFO_reg0 ( .D(FIFO880), .CK(Clk), .QN(n2348) );
  DFFX1 FIFO_reg1 ( .D(FIFO881), .CK(Clk), .QN(n2368) );
  DFFX1 FIFO_reg2 ( .D(FIFO882), .CK(Clk), .QN(n2369) );
  DFFX1 FIFO_reg3 ( .D(FIFO883), .CK(Clk), .QN(n2352) );
  DFFX1 FIFO_reg4 ( .D(FIFO884), .CK(Clk), .QN(n2370) );
  DFFX1 FIFO_reg5 ( .D(FIFO885), .CK(Clk), .QN(n2349) );
  DFFX1 FIFO_reg6 ( .D(FIFO886), .CK(Clk), .QN(n2353) );
  DFFX1 FIFO_reg7 ( .D(FIFO887), .CK(Clk), .QN(n2371) );
  DFFX1 FIFO_reg8 ( .D(FIFO888), .CK(Clk), .QN(n2350) );
  DFFX1 FIFO_reg9 ( .D(FIFO889), .CK(Clk), .QN(n2354) );
  DFFX1 FIFO_reg10 ( .D(FIFO8810), .CK(Clk), .QN(n2372) );
  DFFX1 FIFO_reg11 ( .D(FIFO8811), .CK(Clk), .QN(n2355) );
  DFFX1 FIFO_reg12 ( .D(FIFO8812), .CK(Clk), .QN(n2373) );
  DFFX1 FIFO_reg13 ( .D(FIFO8813), .CK(Clk), .QN(n2363) );
  DFFX1 FIFO_reg14 ( .D(FIFO8814), .CK(Clk), .QN(n2356) );
  DFFX1 FIFO_reg15 ( .D(FIFO8815), .CK(Clk), .QN(n2374) );
  DFFX1 FIFO_reg16 ( .D(FIFO8816), .CK(Clk), .QN(n2364) );
  DFFX1 FIFO_reg17 ( .D(FIFO8817), .CK(Clk), .QN(n2357) );
  DFFX1 FIFO_reg18 ( .D(FIFO8818), .CK(Clk), .QN(n2375) );
  DFFX1 FIFO_reg19 ( .D(FIFO8819), .CK(Clk), .QN(n2365) );
  DFFX1 FIFO_reg20 ( .D(FIFO8820), .CK(Clk), .QN(n2358) );
  DFFX1 FIFO_reg21 ( .D(FIFO8821), .CK(Clk), .QN(n2359) );
  DFFX1 FIFO_reg22 ( .D(FIFO8822), .CK(Clk), .QN(n2376) );
  DFFX1 FIFO_reg23 ( .D(FIFO8823), .CK(Clk), .QN(n2351) );
  DFFX1 FIFO_reg24 ( .D(FIFO8824), .CK(Clk), .QN(n2360) );
  DFFX1 FIFO_reg25 ( .D(FIFO8825), .CK(Clk), .QN(n2377) );
  DFFX1 FIFO_reg26 ( .D(FIFO8826), .CK(Clk), .QN(n2378) );
  DFFX1 FIFO_reg27 ( .D(FIFO8827), .CK(Clk), .QN(n2361) );
  DFFX1 FIFO_reg28 ( .D(FIFO8828), .CK(Clk), .QN(n2362) );
  DFFX1 FIFO_reg29 ( .D(FIFO8829), .CK(Clk), .QN(n2366) );
  DFFX1 FIFO_reg30 ( .D(FIFO8830), .CK(Clk), .QN(n2379) );
  DFFX1 FIFO_reg31 ( .D(FIFO8831), .CK(Clk), .QN(n2239) );
  DFFX1 FIFO_reg32 ( .D(FIFO8832), .CK(Clk), .QN(n2220) );
  DFFX1 FIFO_reg33 ( .D(FIFO8833), .CK(Clk), .QN(n2240) );
  DFFX1 FIFO_reg34 ( .D(FIFO8834), .CK(Clk), .QN(n2241) );
  DFFX1 FIFO_reg35 ( .D(FIFO8835), .CK(Clk), .QN(n2221) );
  DFFX1 FIFO_reg36 ( .D(FIFO8836), .CK(Clk), .QN(n2242) );
  DFFX1 FIFO_reg37 ( .D(FIFO8837), .CK(Clk), .QN(n2222) );
  DFFX1 FIFO_reg38 ( .D(FIFO8838), .CK(Clk), .QN(n2223) );
  DFFX1 FIFO_reg39 ( .D(FIFO8839), .CK(Clk), .QN(n2243) );
  DFFX1 FIFO_reg40 ( .D(FIFO8840), .CK(Clk), .QN(n2224) );
  DFFX1 FIFO_reg41 ( .D(FIFO8841), .CK(Clk), .QN(n2225) );
  DFFX1 FIFO_reg42 ( .D(FIFO8842), .CK(Clk), .QN(n2244) );
  DFFX1 FIFO_reg43 ( .D(FIFO8843), .CK(Clk), .QN(n2226) );
  DFFX1 FIFO_reg44 ( .D(FIFO8844), .CK(Clk), .QN(n2245) );
  DFFX1 FIFO_reg45 ( .D(FIFO8845), .CK(Clk), .QN(n2235) );
  DFFX1 FIFO_reg46 ( .D(FIFO8846), .CK(Clk), .QN(n2227) );
  DFFX1 FIFO_reg47 ( .D(FIFO8847), .CK(Clk), .QN(n2246) );
  DFFX1 FIFO_reg48 ( .D(FIFO8848), .CK(Clk), .QN(n2236) );
  DFFX1 FIFO_reg49 ( .D(FIFO8849), .CK(Clk), .QN(n2228) );
  DFFX1 FIFO_reg50 ( .D(FIFO8850), .CK(Clk), .QN(n2247) );
  DFFX1 FIFO_reg51 ( .D(FIFO8851), .CK(Clk), .QN(n2237) );
  DFFX1 FIFO_reg52 ( .D(FIFO8852), .CK(Clk), .QN(n2229) );
  DFFX1 FIFO_reg53 ( .D(FIFO8853), .CK(Clk), .QN(n2230) );
  DFFX1 FIFO_reg54 ( .D(FIFO8854), .CK(Clk), .QN(n2248) );
  DFFX1 FIFO_reg55 ( .D(FIFO8855), .CK(Clk), .QN(n2231) );
  DFFX1 FIFO_reg56 ( .D(FIFO8856), .CK(Clk), .QN(n2232) );
  DFFX1 FIFO_reg57 ( .D(FIFO8857), .CK(Clk), .QN(n2249) );
  DFFX1 FIFO_reg58 ( .D(FIFO8858), .CK(Clk), .QN(n2250) );
  DFFX1 FIFO_reg59 ( .D(FIFO8859), .CK(Clk), .QN(n2233) );
  DFFX1 FIFO_reg60 ( .D(FIFO8860), .CK(Clk), .QN(n2234) );
  DFFX1 FIFO_reg61 ( .D(FIFO8861), .CK(Clk), .QN(n2238) );
  DFFX1 FIFO_reg62 ( .D(FIFO8862), .CK(Clk), .QN(n2251) );
  DFFX1 FIFO_reg63 ( .D(FIFO8863), .CK(Clk), .QN(n2143) );
  DFFX1 FIFO_reg64 ( .D(FIFO8864), .CK(Clk), .QN(n2124) );
  DFFX1 FIFO_reg65 ( .D(FIFO8865), .CK(Clk), .QN(n2144) );
  DFFX1 FIFO_reg66 ( .D(FIFO8866), .CK(Clk), .QN(n2145) );
  DFFX1 FIFO_reg67 ( .D(FIFO8867), .CK(Clk), .QN(n2125) );
  DFFX1 FIFO_reg68 ( .D(FIFO8868), .CK(Clk), .QN(n2146) );
  DFFX1 FIFO_reg69 ( .D(FIFO8869), .CK(Clk), .QN(n2126) );
  DFFX1 FIFO_reg70 ( .D(FIFO8870), .CK(Clk), .QN(n2127) );
  DFFX1 FIFO_reg71 ( .D(FIFO8871), .CK(Clk), .QN(n2147) );
  DFFX1 FIFO_reg72 ( .D(FIFO8872), .CK(Clk), .QN(n2128) );
  DFFX1 FIFO_reg73 ( .D(FIFO8873), .CK(Clk), .QN(n2129) );
  DFFX1 FIFO_reg74 ( .D(FIFO8874), .CK(Clk), .QN(n2148) );
  DFFX1 FIFO_reg75 ( .D(FIFO8875), .CK(Clk), .QN(n2130) );
  DFFX1 FIFO_reg76 ( .D(FIFO8876), .CK(Clk), .QN(n2149) );
  DFFX1 FIFO_reg77 ( .D(FIFO8877), .CK(Clk), .QN(n2139) );
  DFFX1 FIFO_reg78 ( .D(FIFO8878), .CK(Clk), .QN(n2131) );
  DFFX1 FIFO_reg79 ( .D(FIFO8879), .CK(Clk), .QN(n2150) );
  DFFX1 FIFO_reg80 ( .D(FIFO8880), .CK(Clk), .QN(n2140) );
  DFFX1 FIFO_reg81 ( .D(FIFO8881), .CK(Clk), .QN(n2132) );
  DFFX1 FIFO_reg82 ( .D(FIFO8882), .CK(Clk), .QN(n2151) );
  DFFX1 FIFO_reg83 ( .D(FIFO8883), .CK(Clk), .QN(n2141) );
  DFFX1 FIFO_reg84 ( .D(FIFO8884), .CK(Clk), .QN(n2133) );
  DFFX1 FIFO_reg85 ( .D(FIFO8885), .CK(Clk), .QN(n2134) );
  DFFX1 FIFO_reg86 ( .D(FIFO8886), .CK(Clk), .QN(n2152) );
  DFFX1 FIFO_reg87 ( .D(FIFO8887), .CK(Clk), .QN(n2135) );
  DFFX1 FIFO_reg88 ( .D(FIFO8888), .CK(Clk), .QN(n2136) );
  DFFX1 FIFO_reg89 ( .D(FIFO8889), .CK(Clk), .QN(n2153) );
  DFFX1 FIFO_reg90 ( .D(FIFO8890), .CK(Clk), .QN(n2154) );
  DFFX1 FIFO_reg91 ( .D(FIFO8891), .CK(Clk), .QN(n2137) );
  DFFX1 FIFO_reg92 ( .D(FIFO8892), .CK(Clk), .QN(n2138) );
  DFFX1 FIFO_reg93 ( .D(FIFO8893), .CK(Clk), .QN(n2142) );
  DFFX1 FIFO_reg94 ( .D(FIFO8894), .CK(Clk), .QN(n2155) );
  DFFX1 FIFO_reg95 ( .D(FIFO88223), .CK(Clk), .QN(n2271) );
  DFFX1 FIFO_reg96 ( .D(FIFO88224), .CK(Clk), .QN(n2252) );
  DFFX1 FIFO_reg97 ( .D(FIFO88225), .CK(Clk), .QN(n2272) );
  DFFX1 FIFO_reg98 ( .D(FIFO88226), .CK(Clk), .QN(n2273) );
  DFFX1 FIFO_reg99 ( .D(FIFO88227), .CK(Clk), .QN(n2253) );
  DFFX1 FIFO_reg100 ( .D(FIFO88228), .CK(Clk), .QN(n2274) );
  DFFX1 FIFO_reg101 ( .D(FIFO88229), .CK(Clk), .QN(n2254) );
  DFFX1 FIFO_reg102 ( .D(FIFO88230), .CK(Clk), .QN(n2255) );
  DFFX1 FIFO_reg103 ( .D(FIFO88231), .CK(Clk), .QN(n2275) );
  DFFX1 FIFO_reg104 ( .D(FIFO88232), .CK(Clk), .QN(n2256) );
  DFFX1 FIFO_reg105 ( .D(FIFO88233), .CK(Clk), .QN(n2257) );
  DFFX1 FIFO_reg106 ( .D(FIFO88234), .CK(Clk), .QN(n2276) );
  DFFX1 FIFO_reg107 ( .D(FIFO88235), .CK(Clk), .QN(n2258) );
  DFFX1 FIFO_reg108 ( .D(FIFO88236), .CK(Clk), .QN(n2277) );
  DFFX1 FIFO_reg109 ( .D(FIFO88237), .CK(Clk), .QN(n2267) );
  DFFX1 FIFO_reg110 ( .D(FIFO88238), .CK(Clk), .QN(n2259) );
  DFFX1 FIFO_reg111 ( .D(FIFO88239), .CK(Clk), .QN(n2278) );
  DFFX1 FIFO_reg112 ( .D(FIFO88240), .CK(Clk), .QN(n2268) );
  DFFX1 FIFO_reg113 ( .D(FIFO88241), .CK(Clk), .QN(n2260) );
  DFFX1 FIFO_reg114 ( .D(FIFO88242), .CK(Clk), .QN(n2279) );
  DFFX1 FIFO_reg115 ( .D(FIFO88243), .CK(Clk), .QN(n2269) );
  DFFX1 FIFO_reg116 ( .D(FIFO88244), .CK(Clk), .QN(n2261) );
  DFFX1 FIFO_reg117 ( .D(FIFO88245), .CK(Clk), .QN(n2262) );
  DFFX1 FIFO_reg118 ( .D(FIFO88246), .CK(Clk), .QN(n2280) );
  DFFX1 FIFO_reg119 ( .D(FIFO88247), .CK(Clk), .QN(n2263) );
  DFFX1 FIFO_reg120 ( .D(FIFO88248), .CK(Clk), .QN(n2264) );
  DFFX1 FIFO_reg121 ( .D(FIFO88249), .CK(Clk), .QN(n2281) );
  DFFX1 FIFO_reg122 ( .D(FIFO88250), .CK(Clk), .QN(n2282) );
  DFFX1 FIFO_reg123 ( .D(FIFO88251), .CK(Clk), .QN(n2265) );
  DFFX1 FIFO_reg124 ( .D(FIFO88252), .CK(Clk), .QN(n2266) );
  DFFX1 FIFO_reg125 ( .D(FIFO88253), .CK(Clk), .QN(n2270) );
  DFFX1 FIFO_reg126 ( .D(FIFO88254), .CK(Clk), .QN(n2283) );
  DFFX1 FIFO_reg127 ( .D(FIFO8895), .CK(Clk), .QN(n2298) );
  DFFX1 FIFO_reg128 ( .D(FIFO8896), .CK(Clk), .QN(n2284) );
  DFFX1 FIFO_reg129 ( .D(FIFO8897), .CK(Clk), .QN(n2299) );
  DFFX1 FIFO_reg130 ( .D(FIFO8898), .CK(Clk), .QN(n2300) );
  DFFX1 FIFO_reg131 ( .D(FIFO8899), .CK(Clk), .QN(n2285) );
  DFFX1 FIFO_reg132 ( .D(FIFO88100), .CK(Clk), .QN(n2301) );
  DFFX1 FIFO_reg133 ( .D(FIFO88101), .CK(Clk), .QN(n2286) );
  DFFX1 FIFO_reg134 ( .D(FIFO88102), .CK(Clk), .QN(n2287) );
  DFFX1 FIFO_reg135 ( .D(FIFO88103), .CK(Clk), .QN(n2302) );
  DFFX1 FIFO_reg136 ( .D(FIFO88104), .CK(Clk), .QN(n2303) );
  DFFX1 FIFO_reg137 ( .D(FIFO88105), .CK(Clk), .QN(n2288) );
  DFFX1 FIFO_reg138 ( .D(FIFO88106), .CK(Clk), .QN(n2304) );
  DFFX1 FIFO_reg139 ( .D(FIFO88107), .CK(Clk), .QN(n2289) );
  DFFX1 FIFO_reg140 ( .D(FIFO88108), .CK(Clk), .QN(n2305) );
  DFFX1 FIFO_reg141 ( .D(FIFO88109), .CK(Clk), .QN(n2306) );
  DFFX1 FIFO_reg142 ( .D(FIFO88110), .CK(Clk), .QN(n2290) );
  DFFX1 FIFO_reg143 ( .D(FIFO88111), .CK(Clk), .QN(n2307) );
  DFFX1 FIFO_reg144 ( .D(FIFO88112), .CK(Clk), .QN(n2308) );
  DFFX1 FIFO_reg145 ( .D(FIFO88113), .CK(Clk), .QN(n2291) );
  DFFX1 FIFO_reg146 ( .D(FIFO88114), .CK(Clk), .QN(n2309) );
  DFFX1 FIFO_reg147 ( .D(FIFO88115), .CK(Clk), .QN(n2310) );
  DFFX1 FIFO_reg148 ( .D(FIFO88116), .CK(Clk), .QN(n2292) );
  DFFX1 FIFO_reg149 ( .D(FIFO88117), .CK(Clk), .QN(n2293) );
  DFFX1 FIFO_reg150 ( .D(FIFO88118), .CK(Clk), .QN(n2311) );
  DFFX1 FIFO_reg151 ( .D(FIFO88119), .CK(Clk), .QN(n2294) );
  DFFX1 FIFO_reg152 ( .D(FIFO88120), .CK(Clk), .QN(n2295) );
  DFFX1 FIFO_reg153 ( .D(FIFO88121), .CK(Clk), .QN(n2312) );
  DFFX1 FIFO_reg154 ( .D(FIFO88122), .CK(Clk), .QN(n2313) );
  DFFX1 FIFO_reg155 ( .D(FIFO88123), .CK(Clk), .QN(n2296) );
  DFFX1 FIFO_reg156 ( .D(FIFO88124), .CK(Clk), .QN(n2297) );
  DFFX1 FIFO_reg157 ( .D(FIFO88125), .CK(Clk), .QN(n2314) );
  DFFX1 FIFO_reg158 ( .D(FIFO88126), .CK(Clk), .QN(n2315) );
  DFFX1 FIFO_reg159 ( .D(FIFO88127), .CK(Clk), .QN(n2202) );
  DFFX1 FIFO_reg160 ( .D(FIFO88128), .CK(Clk), .QN(n2188) );
  DFFX1 FIFO_reg161 ( .D(FIFO88129), .CK(Clk), .QN(n2203) );
  DFFX1 FIFO_reg162 ( .D(FIFO88130), .CK(Clk), .QN(n2204) );
  DFFX1 FIFO_reg163 ( .D(FIFO88131), .CK(Clk), .QN(n2189) );
  DFFX1 FIFO_reg164 ( .D(FIFO88132), .CK(Clk), .QN(n2205) );
  DFFX1 FIFO_reg165 ( .D(FIFO88133), .CK(Clk), .QN(n2190) );
  DFFX1 FIFO_reg166 ( .D(FIFO88134), .CK(Clk), .QN(n2191) );
  DFFX1 FIFO_reg167 ( .D(FIFO88135), .CK(Clk), .QN(n2206) );
  DFFX1 FIFO_reg168 ( .D(FIFO88136), .CK(Clk), .QN(n2207) );
  DFFX1 FIFO_reg169 ( .D(FIFO88137), .CK(Clk), .QN(n2192) );
  DFFX1 FIFO_reg170 ( .D(FIFO88138), .CK(Clk), .QN(n2208) );
  DFFX1 FIFO_reg171 ( .D(FIFO88139), .CK(Clk), .QN(n2193) );
  DFFX1 FIFO_reg172 ( .D(FIFO88140), .CK(Clk), .QN(n2209) );
  DFFX1 FIFO_reg173 ( .D(FIFO88141), .CK(Clk), .QN(n2210) );
  DFFX1 FIFO_reg174 ( .D(FIFO88142), .CK(Clk), .QN(n2194) );
  DFFX1 FIFO_reg175 ( .D(FIFO88143), .CK(Clk), .QN(n2211) );
  DFFX1 FIFO_reg176 ( .D(FIFO88144), .CK(Clk), .QN(n2212) );
  DFFX1 FIFO_reg177 ( .D(FIFO88145), .CK(Clk), .QN(n2195) );
  DFFX1 FIFO_reg178 ( .D(FIFO88146), .CK(Clk), .QN(n2213) );
  DFFX1 FIFO_reg179 ( .D(FIFO88147), .CK(Clk), .QN(n2214) );
  DFFX1 FIFO_reg180 ( .D(FIFO88148), .CK(Clk), .QN(n2196) );
  DFFX1 FIFO_reg181 ( .D(FIFO88149), .CK(Clk), .QN(n2197) );
  DFFX1 FIFO_reg182 ( .D(FIFO88150), .CK(Clk), .QN(n2215) );
  DFFX1 FIFO_reg183 ( .D(FIFO88151), .CK(Clk), .QN(n2198) );
  DFFX1 FIFO_reg184 ( .D(FIFO88152), .CK(Clk), .QN(n2199) );
  DFFX1 FIFO_reg185 ( .D(FIFO88153), .CK(Clk), .QN(n2216) );
  DFFX1 FIFO_reg186 ( .D(FIFO88154), .CK(Clk), .QN(n2217) );
  DFFX1 FIFO_reg187 ( .D(FIFO88155), .CK(Clk), .QN(n2200) );
  DFFX1 FIFO_reg188 ( .D(FIFO88156), .CK(Clk), .QN(n2201) );
  DFFX1 FIFO_reg189 ( .D(FIFO88157), .CK(Clk), .QN(n2218) );
  DFFX1 FIFO_reg190 ( .D(FIFO88158), .CK(Clk), .QN(n2219) );
  DFFX1 FIFO_reg191 ( .D(FIFO88159), .CK(Clk), .QN(n2330) );
  DFFX1 FIFO_reg192 ( .D(FIFO88160), .CK(Clk), .QN(n2316) );
  DFFX1 FIFO_reg193 ( .D(FIFO88161), .CK(Clk), .QN(n2331) );
  DFFX1 FIFO_reg194 ( .D(FIFO88162), .CK(Clk), .QN(n2332) );
  DFFX1 FIFO_reg195 ( .D(FIFO88163), .CK(Clk), .QN(n2317) );
  DFFX1 FIFO_reg196 ( .D(FIFO88164), .CK(Clk), .QN(n2333) );
  DFFX1 FIFO_reg197 ( .D(FIFO88165), .CK(Clk), .QN(n2318) );
  DFFX1 FIFO_reg198 ( .D(FIFO88166), .CK(Clk), .QN(n2319) );
  DFFX1 FIFO_reg199 ( .D(FIFO88167), .CK(Clk), .QN(n2334) );
  DFFX1 FIFO_reg200 ( .D(FIFO88168), .CK(Clk), .QN(n2335) );
  DFFX1 FIFO_reg201 ( .D(FIFO88169), .CK(Clk), .QN(n2320) );
  DFFX1 FIFO_reg202 ( .D(FIFO88170), .CK(Clk), .QN(n2336) );
  DFFX1 FIFO_reg203 ( .D(FIFO88171), .CK(Clk), .QN(n2321) );
  DFFX1 FIFO_reg204 ( .D(FIFO88172), .CK(Clk), .QN(n2337) );
  DFFX1 FIFO_reg205 ( .D(FIFO88173), .CK(Clk), .QN(n2338) );
  DFFX1 FIFO_reg206 ( .D(FIFO88174), .CK(Clk), .QN(n2322) );
  DFFX1 FIFO_reg207 ( .D(FIFO88175), .CK(Clk), .QN(n2339) );
  DFFX1 FIFO_reg208 ( .D(FIFO88176), .CK(Clk), .QN(n2340) );
  DFFX1 FIFO_reg209 ( .D(FIFO88177), .CK(Clk), .QN(n2323) );
  DFFX1 FIFO_reg210 ( .D(FIFO88178), .CK(Clk), .QN(n2341) );
  DFFX1 FIFO_reg211 ( .D(FIFO88179), .CK(Clk), .QN(n2342) );
  DFFX1 FIFO_reg212 ( .D(FIFO88180), .CK(Clk), .QN(n2324) );
  DFFX1 FIFO_reg213 ( .D(FIFO88181), .CK(Clk), .QN(n2325) );
  DFFX1 FIFO_reg214 ( .D(FIFO88182), .CK(Clk), .QN(n2343) );
  DFFX1 FIFO_reg215 ( .D(FIFO88183), .CK(Clk), .QN(n2326) );
  DFFX1 FIFO_reg216 ( .D(FIFO88184), .CK(Clk), .QN(n2327) );
  DFFX1 FIFO_reg217 ( .D(FIFO88185), .CK(Clk), .QN(n2344) );
  DFFX1 FIFO_reg218 ( .D(FIFO88186), .CK(Clk), .QN(n2345) );
  DFFX1 FIFO_reg219 ( .D(FIFO88187), .CK(Clk), .QN(n2328) );
  DFFX1 FIFO_reg220 ( .D(FIFO88188), .CK(Clk), .QN(n2329) );
  DFFX1 FIFO_reg221 ( .D(FIFO88189), .CK(Clk), .QN(n2346) );
  DFFX1 FIFO_reg222 ( .D(FIFO88190), .CK(Clk), .QN(n2347) );
  DFFX1 FIFO_reg223 ( .D(FIFO88191), .CK(Clk), .QN(n2170) );
  DFFX1 FIFO_reg224 ( .D(FIFO88192), .CK(Clk), .QN(n2156) );
  DFFX1 FIFO_reg225 ( .D(FIFO88193), .CK(Clk), .QN(n2171) );
  DFFX1 FIFO_reg226 ( .D(FIFO88194), .CK(Clk), .QN(n2172) );
  DFFX1 FIFO_reg227 ( .D(FIFO88195), .CK(Clk), .QN(n2157) );
  DFFX1 FIFO_reg228 ( .D(FIFO88196), .CK(Clk), .QN(n2173) );
  DFFX1 FIFO_reg229 ( .D(FIFO88197), .CK(Clk), .QN(n2158) );
  DFFX1 FIFO_reg230 ( .D(FIFO88198), .CK(Clk), .QN(n2159) );
  DFFX1 FIFO_reg231 ( .D(FIFO88199), .CK(Clk), .QN(n2174) );
  DFFX1 FIFO_reg232 ( .D(FIFO88200), .CK(Clk), .QN(n2175) );
  DFFX1 FIFO_reg233 ( .D(FIFO88201), .CK(Clk), .QN(n2160) );
  DFFX1 FIFO_reg234 ( .D(FIFO88202), .CK(Clk), .QN(n2176) );
  DFFX1 FIFO_reg235 ( .D(FIFO88203), .CK(Clk), .QN(n2161) );
  DFFX1 FIFO_reg236 ( .D(FIFO88204), .CK(Clk), .QN(n2177) );
  DFFX1 FIFO_reg237 ( .D(FIFO88205), .CK(Clk), .QN(n2178) );
  DFFX1 FIFO_reg238 ( .D(FIFO88206), .CK(Clk), .QN(n2162) );
  DFFX1 FIFO_reg239 ( .D(FIFO88207), .CK(Clk), .QN(n2179) );
  DFFX1 FIFO_reg240 ( .D(FIFO88208), .CK(Clk), .QN(n2180) );
  DFFX1 FIFO_reg241 ( .D(FIFO88209), .CK(Clk), .QN(n2163) );
  DFFX1 FIFO_reg242 ( .D(FIFO88210), .CK(Clk), .QN(n2181) );
  DFFX1 FIFO_reg243 ( .D(FIFO88211), .CK(Clk), .QN(n2182) );
  DFFX1 FIFO_reg244 ( .D(FIFO88212), .CK(Clk), .QN(n2164) );
  DFFX1 FIFO_reg245 ( .D(FIFO88213), .CK(Clk), .QN(n2165) );
  DFFX1 FIFO_reg246 ( .D(FIFO88214), .CK(Clk), .QN(n2183) );
  DFFX1 FIFO_reg247 ( .D(FIFO88215), .CK(Clk), .QN(n2166) );
  DFFX1 FIFO_reg248 ( .D(FIFO88216), .CK(Clk), .QN(n2167) );
  DFFX1 FIFO_reg249 ( .D(FIFO88217), .CK(Clk), .QN(n2184) );
  DFFX1 FIFO_reg250 ( .D(FIFO88218), .CK(Clk), .QN(n2185) );
  DFFX1 FIFO_reg251 ( .D(FIFO88219), .CK(Clk), .QN(n2168) );
  DFFX1 FIFO_reg252 ( .D(FIFO88220), .CK(Clk), .QN(n2169) );
  DFFX1 FIFO_reg253 ( .D(FIFO88221), .CK(Clk), .QN(n2186) );
  DFFX1 FIFO_reg254 ( .D(FIFO88222), .CK(Clk), .QN(n2187) );
  DFFQX1 FIFORdData_reg_2_ ( .D(FIFORdData486_2_), .CK(Clk), .Q(FIFORdData[2])
         );
  DFFQX1 FIFORdData_reg_4_ ( .D(FIFORdData486_4_), .CK(Clk), .Q(FIFORdData[4])
         );
  DFFQX1 FIFORdData_reg_5_ ( .D(FIFORdData486_5_), .CK(Clk), .Q(FIFORdData[5])
         );
  DFFQX1 FIFORdData_reg_6_ ( .D(FIFORdData486_6_), .CK(Clk), .Q(FIFORdData[6])
         );
  DFFQX1 FIFORdData_reg_3_ ( .D(FIFORdData486_3_), .CK(Clk), .Q(FIFORdData[3])
         );
  DFFQX1 FIFORdData_reg_7_ ( .D(FIFORdData486_7_), .CK(Clk), .Q(FIFORdData[7])
         );
  DFFQX1 FIFORdData_reg_8_ ( .D(FIFORdData486_8_), .CK(Clk), .Q(FIFORdData[8])
         );
  DFFQX1 FIFORdData_reg_9_ ( .D(FIFORdData486_9_), .CK(Clk), .Q(FIFORdData[9])
         );
  DFFQX1 FIFORdData_reg_10_ ( .D(FIFORdData486_10_), .CK(Clk), .Q(
        FIFORdData[10]) );
  DFFQX1 FIFORdData_reg_11_ ( .D(FIFORdData486_11_), .CK(Clk), .Q(
        FIFORdData[11]) );
  DFFQX1 FIFORdData_reg_12_ ( .D(FIFORdData486_12_), .CK(Clk), .Q(
        FIFORdData[12]) );
  DFFQX1 FIFORdData_reg_13_ ( .D(FIFORdData486_13_), .CK(Clk), .Q(
        FIFORdData[13]) );
  DFFQX1 FIFORdData_reg_14_ ( .D(FIFORdData486_14_), .CK(Clk), .Q(
        FIFORdData[14]) );
  DFFQX1 FIFORdData_reg_15_ ( .D(FIFORdData486_15_), .CK(Clk), .Q(
        FIFORdData[15]) );
  DFFQX1 FIFORdData_reg_16_ ( .D(FIFORdData486_16_), .CK(Clk), .Q(
        FIFORdData[16]) );
  DFFQX1 FIFORdData_reg_17_ ( .D(FIFORdData486_17_), .CK(Clk), .Q(
        FIFORdData[17]) );
  DFFQX1 FIFORdData_reg_18_ ( .D(FIFORdData486_18_), .CK(Clk), .Q(
        FIFORdData[18]) );
  DFFQX1 FIFORdData_reg_19_ ( .D(FIFORdData486_19_), .CK(Clk), .Q(
        FIFORdData[19]) );
  DFFQX1 FIFORdData_reg_20_ ( .D(FIFORdData486_20_), .CK(Clk), .Q(
        FIFORdData[20]) );
  DFFQX1 FIFORdData_reg_21_ ( .D(FIFORdData486_21_), .CK(Clk), .Q(
        FIFORdData[21]) );
  DFFQX1 FIFORdData_reg_22_ ( .D(FIFORdData486_22_), .CK(Clk), .Q(
        FIFORdData[22]) );
  DFFQX1 FIFORdData_reg_23_ ( .D(FIFORdData486_23_), .CK(Clk), .Q(
        FIFORdData[23]) );
  DFFQX1 FIFORdData_reg_24_ ( .D(FIFORdData486_24_), .CK(Clk), .Q(
        FIFORdData[24]) );
  DFFQX1 FIFORdData_reg_25_ ( .D(FIFORdData486_25_), .CK(Clk), .Q(
        FIFORdData[25]) );
  DFFQX1 FIFORdData_reg_26_ ( .D(FIFORdData486_26_), .CK(Clk), .Q(
        FIFORdData[26]) );
  DFFQX1 FIFORdData_reg_27_ ( .D(FIFORdData486_27_), .CK(Clk), .Q(
        FIFORdData[27]) );
  DFFQX1 FIFORdData_reg_28_ ( .D(FIFORdData486_28_), .CK(Clk), .Q(
        FIFORdData[28]) );
  DFFQX1 FIFORdData_reg_29_ ( .D(FIFORdData486_29_), .CK(Clk), .Q(
        FIFORdData[29]) );
  DFFQX1 FIFORdData_reg_30_ ( .D(FIFORdData486_30_), .CK(Clk), .Q(
        FIFORdData[30]) );
  DFFQX1 FIFORdData_reg_31_ ( .D(FIFORdData486_31_), .CK(Clk), .Q(
        FIFORdData[31]) );
  DFFQX1 FIFORdData_reg_0_ ( .D(FIFORdData486_0_), .CK(Clk), .Q(FIFORdData[0])
         );
  DFFQX1 FIFORdData_reg_1_ ( .D(FIFORdData486_1_), .CK(Clk), .Q(FIFORdData[1])
         );
endmodule


module PcmFIFOCtl_AW3 ( Clki, ReadEni, WriteEni, nRST, Flushi, DataCnt, Fullo, 
        FIFOHalfFull, AlmostEmptyo, Emptyo, EmptyWrSideo, WriteAddro, 
        ReadAddro, ReadAllowo, WriteAllowo );
  output [2:0] DataCnt;
  output [2:0] WriteAddro;
  output [2:0] ReadAddro;
  input Clki, ReadEni, WriteEni, nRST, Flushi;
  output Fullo, FIFOHalfFull, AlmostEmptyo, Emptyo, EmptyWrSideo, ReadAllowo,
         WriteAllowo;
  wire   EmptyWrSideo0, FIFOHalfFull, n662, n663, n664, n665, n666, n667, n668,
         n669, n670, n671, n672, n673, n674, n675, n676, n677, n678, n679,
         n680, n681, n682, n683, n684, n685, n705, n706, n708, n709, n710,
         n711, n713, n716, n717, n719, n723, n727, n728, n733, n734, n735,
         n736, n738, n739, n740, n741, n742, n743, n745, n746, n748, n749,
         n750, n751, n752, n753, n754, n761, n762, n763, n766, n767, n770,
         n771, n774, n775, n776, n777, n778, n779, n780, n781, n782, n783,
         n784, n785, n786, n787, n788, n789, n790, n791, n792, n793, n794,
         n795, n796, n797, n798, n799, n800;
  wire   [2:0] RdAddr;
  wire   [2:0] RdAddrPlusOne;
  wire   [2:0] WrGreyAddr;
  wire   [2:0] WrGreyNext;
  wire   [2:0] RdGreyNext;
  wire   [2:0] RdGreyAddr;
  assign Emptyo = EmptyWrSideo0;
  assign EmptyWrSideo = EmptyWrSideo0;
  assign DataCnt[0] = FIFOHalfFull;

  DFFRX1 WrAddr_reg_0_ ( .D(n685), .CK(Clki), .RN(nRST), .Q(WriteAddro[0]), 
        .QN(n783) );
  XOR2X1 U416 ( .A(WrGreyAddr[1]), .B(RdGreyAddr[1]), .Y(n788) );
  XOR2X1 U417 ( .A(WrGreyNext[1]), .B(RdGreyAddr[1]), .Y(n789) );
  XOR2X1 U418 ( .A(WrGreyAddr[1]), .B(RdGreyNext[1]), .Y(n799) );
  CLKINVX1 U419 ( .A(n705), .Y(WriteAllowo) );
  OAI31XL U420 ( .A0(n775), .A1(WriteAddro[2]), .A2(n783), .B0(n736), .Y(n708)
         );
  CLKINVX1 U421 ( .A(n713), .Y(n738) );
  NAND2BX1 U422 ( .AN(ReadAllowo), .B(n716), .Y(n713) );
  NAND2BX1 U423 ( .AN(n791), .B(n719), .Y(n728) );
  CLKINVX1 U424 ( .A(n761), .Y(ReadAllowo) );
  CLKINVX1 U425 ( .A(n727), .Y(n719) );
  XNOR2X1 U426 ( .A(WriteAllowo), .B(n783), .Y(n685) );
  OAI222XL U427 ( .A0(n784), .A1(n713), .B0(n775), .B1(n716), .C0(n727), .C1(
        n793), .Y(n675) );
  OAI222XL U428 ( .A0(n774), .A1(n713), .B0(n776), .B1(n716), .C0(n727), .C1(
        n786), .Y(n662) );
  OAI222XL U429 ( .A0(n777), .A1(n713), .B0(n781), .B1(n716), .C0(n727), .C1(
        n795), .Y(n664) );
  OAI222XL U430 ( .A0(n713), .A1(n794), .B0(n779), .B1(n716), .C0(n727), .C1(
        n785), .Y(n674) );
  OAI222XL U431 ( .A0(n713), .A1(n786), .B0(n778), .B1(n716), .C0(n727), .C1(
        n794), .Y(n677) );
  OAI221XL U432 ( .A0(n783), .A1(n716), .B0(n796), .B1(n713), .C0(n728), .Y(
        n676) );
  CLKINVX1 U433 ( .A(n746), .Y(n739) );
  CLKINVX1 U434 ( .A(n741), .Y(n753) );
  AOI21X1 U435 ( .A0(n719), .A1(n791), .B0(n738), .Y(n800) );
  DFFRX1 DataCnt_reg_1_ ( .D(n669), .CK(Clki), .RN(nRST), .Q(DataCnt[1]), .QN(
        n792) );
  DFFRX1 DataCnt_reg_0_ ( .D(n670), .CK(Clki), .RN(nRST), .Q(FIFOHalfFull), 
        .QN(n790) );
  OAI33X1 U436 ( .A0(n770), .A1(n795), .A2(n781), .B0(n770), .B1(WrGreyAddr[0]), .B2(RdGreyNext[0]), .Y(AlmostEmptyo) );
  NAND2BX1 U437 ( .AN(Fullo), .B(WriteEni), .Y(n705) );
  NAND2BX1 U438 ( .AN(Flushi), .B(n713), .Y(n727) );
  NAND2BX1 U439 ( .AN(EmptyWrSideo0), .B(ReadEni), .Y(n761) );
  NAND2BX1 U440 ( .AN(Flushi), .B(n754), .Y(n746) );
  XNOR2X1 U441 ( .A(WriteAllowo), .B(ReadAllowo), .Y(n754) );
  NAND2BX1 U442 ( .AN(Flushi), .B(ReadAllowo), .Y(n741) );
  OAI33X1 U443 ( .A0(n766), .A1(n781), .A2(n777), .B0(n766), .B1(WrGreyAddr[0]), .B2(RdGreyAddr[0]), .Y(EmptyWrSideo0) );
  CLKINVX1 U444 ( .A(n767), .Y(n766) );
  OAI33X1 U445 ( .A0(n788), .A1(n774), .A2(n776), .B0(n788), .B1(WrGreyAddr[2]), .B2(RdGreyAddr[2]), .Y(n767) );
  OAI221XL U446 ( .A0(FIFOHalfFull), .A1(n713), .B0(n790), .B1(n741), .C0(n746), .Y(n745) );
  AO22X1 U447 ( .A0(RdAddr[1]), .A1(n761), .B0(ReadAllowo), .B1(
        RdAddrPlusOne[1]), .Y(ReadAddro[1]) );
  AO22X1 U448 ( .A0(RdAddr[2]), .A1(n761), .B0(ReadAllowo), .B1(
        RdAddrPlusOne[2]), .Y(ReadAddro[2]) );
  AO22X1 U449 ( .A0(RdAddr[0]), .A1(n761), .B0(ReadAllowo), .B1(
        RdAddrPlusOne[0]), .Y(ReadAddro[0]) );
  OAI33X1 U450 ( .A0(n762), .A1(n782), .A2(n777), .B0(n762), .B1(WrGreyNext[0]), .B2(RdGreyAddr[0]), .Y(Fullo) );
  CLKINVX1 U451 ( .A(n763), .Y(n762) );
  OAI33X1 U452 ( .A0(n789), .A1(n774), .A2(n778), .B0(n789), .B1(WrGreyNext[2]), .B2(RdGreyAddr[2]), .Y(n763) );
  OAI221XL U453 ( .A0(n713), .A1(n795), .B0(n782), .B1(n716), .C0(n717), .Y(
        n679) );
  AOI33X1 U454 ( .A0(RdAddr[1]), .A1(n796), .A2(n719), .B0(RdAddr[0]), .B1(
        n784), .B2(n719), .Y(n717) );
  OAI32X1 U455 ( .A0(n742), .A1(DataCnt[1]), .A2(n739), .B0(n743), .B1(n792), 
        .Y(n669) );
  OA22X1 U456 ( .A0(FIFOHalfFull), .A1(n741), .B0(n713), .B1(n790), .Y(n742)
         );
  CLKINVX1 U457 ( .A(n745), .Y(n743) );
  OAI221XL U458 ( .A0(n800), .A1(n785), .B0(n733), .B1(n716), .C0(n734), .Y(
        n671) );
  CLKINVX1 U459 ( .A(n708), .Y(n733) );
  AOI33X1 U460 ( .A0(RdAddrPlusOne[1]), .A1(n785), .A2(n735), .B0(
        RdAddrPlusOne[2]), .B1(n793), .B2(n719), .Y(n734) );
  CLKINVX1 U461 ( .A(n728), .Y(n735) );
  OAI221XL U462 ( .A0(n713), .A1(n787), .B0(n798), .B1(n716), .C0(n723), .Y(
        n678) );
  AOI33X1 U463 ( .A0(RdAddr[2]), .A1(n784), .A2(n719), .B0(RdAddr[1]), .B1(
        n794), .B2(n719), .Y(n723) );
  OAI211X1 U464 ( .A0(n748), .A1(n749), .B0(n750), .C0(n751), .Y(n668) );
  NAND3BX1 U465 ( .AN(n790), .B(DataCnt[1]), .C(n738), .Y(n748) );
  NAND2BX1 U466 ( .AN(DataCnt[2]), .B(n746), .Y(n749) );
  AOI33X1 U467 ( .A0(n752), .A1(n746), .A2(n753), .B0(DataCnt[1]), .B1(
        DataCnt[2]), .B2(n753), .Y(n750) );
  AOI32X1 U468 ( .A0(DataCnt[2]), .A1(n792), .A2(n738), .B0(DataCnt[2]), .B1(
        n745), .Y(n751) );
  OAI31XL U469 ( .A0(n705), .A1(WriteAddro[1]), .A2(n783), .B0(n706), .Y(n684)
         );
  OA22X1 U470 ( .A0(WriteAddro[0]), .A1(n775), .B0(WriteAllowo), .B1(n775), 
        .Y(n706) );
  OAI222XL U471 ( .A0(n713), .A1(n791), .B0(WriteAddro[0]), .B1(n716), .C0(
        RdAddrPlusOne[0]), .C1(n727), .Y(n673) );
  OAI222XL U472 ( .A0(n710), .A1(n716), .B0(RdAddrPlusOne[1]), .B1(n728), .C0(
        n800), .C1(n793), .Y(n672) );
  AO22X1 U473 ( .A0(WrGreyNext[0]), .A1(n705), .B0(WriteAllowo), .B1(n709), 
        .Y(n682) );
  CLKINVX1 U474 ( .A(n710), .Y(n709) );
  OAI222XL U475 ( .A0(n797), .A1(n713), .B0(n780), .B1(n716), .C0(n727), .C1(
        n787), .Y(n663) );
  AO22X1 U476 ( .A0(WrGreyNext[2]), .A1(n705), .B0(WriteAddro[2]), .B1(
        WriteAllowo), .Y(n680) );
  AO22X1 U477 ( .A0(WriteAddro[2]), .A1(n705), .B0(WriteAllowo), .B1(n708), 
        .Y(n683) );
  AO22X1 U478 ( .A0(WrGreyAddr[2]), .A1(n705), .B0(WriteAllowo), .B1(
        WrGreyNext[2]), .Y(n665) );
  AO22X1 U479 ( .A0(WrGreyAddr[1]), .A1(n705), .B0(WriteAllowo), .B1(
        WrGreyNext[1]), .Y(n666) );
  AO22X1 U480 ( .A0(WrGreyAddr[0]), .A1(n705), .B0(WriteAllowo), .B1(
        WrGreyNext[0]), .Y(n667) );
  AO21X1 U481 ( .A0(WrGreyNext[1]), .A1(n705), .B0(n711), .Y(n681) );
  OAI33X1 U482 ( .A0(n705), .A1(WriteAddro[2]), .A2(n775), .B0(n705), .B1(
        WriteAddro[1]), .B2(n779), .Y(n711) );
  AO21X1 U483 ( .A0(FIFOHalfFull), .A1(n739), .B0(n740), .Y(n670) );
  AOI211X1 U484 ( .A0(n713), .A1(n741), .B0(FIFOHalfFull), .C0(n739), .Y(n740)
         );
  XNOR2X1 U485 ( .A(WriteAddro[1]), .B(WriteAddro[0]), .Y(n710) );
  OA22X1 U486 ( .A0(WriteAddro[1]), .A1(n779), .B0(WriteAddro[0]), .B1(n779), 
        .Y(n736) );
  NOR3BXL U487 ( .AN(n790), .B(DataCnt[1]), .C(DataCnt[2]), .Y(n752) );
  CLKINVX1 U488 ( .A(Flushi), .Y(n716) );
  CLKINVX1 U489 ( .A(n771), .Y(n770) );
  OAI33X1 U490 ( .A0(n799), .A1(n776), .A2(n786), .B0(n799), .B1(WrGreyAddr[2]), .B2(RdGreyNext[2]), .Y(n771) );
  DFFRX1 WrGreyAddr_reg_1_ ( .D(n666), .CK(Clki), .RN(nRST), .Q(WrGreyAddr[1]), 
        .QN(n780) );
  DFFRX1 RdGreyAddr_reg_1_ ( .D(n663), .CK(Clki), .RN(nRST), .Q(RdGreyAddr[1]), 
        .QN(n797) );
  DFFRX1 WrGreyNext_reg_1_ ( .D(n681), .CK(Clki), .RN(nRST), .Q(WrGreyNext[1]), 
        .QN(n798) );
  DFFRX1 WrGreyNext_reg_2_ ( .D(n680), .CK(Clki), .RN(nRST), .Q(WrGreyNext[2]), 
        .QN(n778) );
  DFFRX1 WrGreyAddr_reg_2_ ( .D(n665), .CK(Clki), .RN(nRST), .Q(WrGreyAddr[2]), 
        .QN(n776) );
  DFFRX1 RdGreyAddr_reg_2_ ( .D(n662), .CK(Clki), .RN(nRST), .Q(RdGreyAddr[2]), 
        .QN(n774) );
  DFFSX1 WrGreyNext_reg_0_ ( .D(n682), .CK(Clki), .SN(nRST), .Q(WrGreyNext[0]), 
        .QN(n782) );
  DFFRX1 WrGreyAddr_reg_0_ ( .D(n667), .CK(Clki), .RN(nRST), .Q(WrGreyAddr[0]), 
        .QN(n781) );
  DFFRX1 RdGreyAddr_reg_0_ ( .D(n664), .CK(Clki), .RN(nRST), .Q(RdGreyAddr[0]), 
        .QN(n777) );
  DFFSX1 WrAddr_reg_1_ ( .D(n684), .CK(Clki), .SN(nRST), .Q(WriteAddro[1]), 
        .QN(n775) );
  DFFRX1 WrAddr_reg_2_ ( .D(n683), .CK(Clki), .RN(nRST), .Q(WriteAddro[2]), 
        .QN(n779) );
  DFFSX1 RdAddr_reg_1_ ( .D(n675), .CK(Clki), .SN(nRST), .Q(RdAddr[1]), .QN(
        n784) );
  DFFSX1 RdAddrPlusOne_reg_1_ ( .D(n672), .CK(Clki), .SN(nRST), .Q(
        RdAddrPlusOne[1]), .QN(n793) );
  DFFSX1 RdAddrPlusOne_reg_0_ ( .D(n673), .CK(Clki), .SN(nRST), .Q(
        RdAddrPlusOne[0]), .QN(n791) );
  DFFRX1 RdAddr_reg_2_ ( .D(n674), .CK(Clki), .RN(nRST), .Q(RdAddr[2]), .QN(
        n794) );
  DFFRX1 RdAddr_reg_0_ ( .D(n676), .CK(Clki), .RN(nRST), .Q(RdAddr[0]), .QN(
        n796) );
  DFFRX1 RdAddrPlusOne_reg_2_ ( .D(n671), .CK(Clki), .RN(nRST), .Q(
        RdAddrPlusOne[2]), .QN(n785) );
  DFFRX1 DataCnt_reg_2_ ( .D(n668), .CK(Clki), .RN(nRST), .Q(DataCnt[2]) );
  DFFRX1 RdGreyNext_reg_1_ ( .D(n678), .CK(Clki), .RN(nRST), .Q(RdGreyNext[1]), 
        .QN(n787) );
  DFFSX1 RdGreyNext_reg_0_ ( .D(n679), .CK(Clki), .SN(nRST), .Q(RdGreyNext[0]), 
        .QN(n795) );
  DFFRX1 RdGreyNext_reg_2_ ( .D(n677), .CK(Clki), .RN(nRST), .Q(RdGreyNext[2]), 
        .QN(n786) );
endmodule


module SEIPApbIf ( PIA, PIDI, XPOE, XPWE, PIDO, PRDY, PCLK, PRESETB, PSEL, 
        PENABLE, PADDR, PWRITE, PWDATA, PRDATA, PREADY, RxDmaErr, TxDmaErr, 
        RxDmaReq, TxDmaReq, SEIPInt, RxFIFOWrite, RxFIFOWrData, RxFIFOReadCpu, 
        RxFIFORdDataCpu, RxFIFOFlush, RxFIFODataCnt, RxFIFOEmpty, RxFIFOFull, 
        RxDmaEn, RxDmaSize, RxDmaReset, TxFIFORead, TxFIFORdData, 
        TxFIFOWriteCpu, TxFIFOWrDataCpu, TxFIFOFlush, TxFIFODataCnt, 
        TxFIFOEmpty, TxFIFOFull, TxDmaEn, TxDmaSize, TxDmaReset );
  output [10:0] PIA;
  output [15:0] PIDI;
  input [15:0] PIDO;
  input [13:2] PADDR;
  input [31:0] PWDATA;
  output [31:0] PRDATA;
  output [31:0] RxFIFOWrData;
  input [31:0] RxFIFORdDataCpu;
  input [2:0] RxFIFODataCnt;
  output [2:0] RxDmaSize;
  input [31:0] TxFIFORdData;
  output [31:0] TxFIFOWrDataCpu;
  input [2:0] TxFIFODataCnt;
  output [2:0] TxDmaSize;
  input PRDY, PCLK, PRESETB, PSEL, PENABLE, PWRITE, RxDmaErr, TxDmaErr,
         RxDmaReq, TxDmaReq, RxFIFOEmpty, RxFIFOFull, TxFIFOEmpty, TxFIFOFull;
  output XPOE, XPWE, PREADY, SEIPInt, RxFIFOWrite, RxFIFOReadCpu, RxFIFOFlush,
         RxDmaEn, RxDmaReset, TxFIFORead, TxFIFOWriteCpu, TxFIFOFlush, TxDmaEn,
         TxDmaReset;
  wire   tPIdle, tPRead0, tPRead1, tPWrite, rRXDATWr, rTXDATWr, rRXDATRd,
         n_694, n_1350, RxDmaReqIntEn, TxDmaReqIntEn, RxDmaErrIntEn,
         TxDmaErrIntEn, SEIPInt1041, PRDATADma1079_31_, PRDATADma1079_30_,
         PRDATADma1079_29_, PRDATADma1079_28_, PRDATADma1079_27_,
         PRDATADma1079_26_, PRDATADma1079_25_, PRDATADma1079_24_,
         PRDATADma1079_23_, PRDATADma1079_22_, PRDATADma1079_21_,
         PRDATADma1079_20_, PRDATADma1079_19_, PRDATADma1079_18_,
         PRDATADma1079_17_, PRDATADma1079_16_, PRDATADma1079_15_,
         PRDATADma1079_14_, PRDATADma1079_13_, PRDATADma1079_12_,
         PRDATADma1079_11_, PRDATADma1079_10_, PRDATADma1079_9_,
         PRDATADma1079_8_, PRDATADma1079_7_, PRDATADma1079_6_,
         PRDATADma1079_5_, PRDATADma1079_4_, PRDATADma1079_3_,
         PRDATADma1079_2_, PRDATADma1079_1_, PRDATADma1079_0_, n1469, n1470,
         n1471, n1472, n1473, n1474, n1475, n1476, n1477, n1478, n1479, n1480,
         n1481, n1482, n1483, n1484, n1566, n1567, n1568, n1569, n1570, n1571,
         n1572, n1573, n1574, n1575, n1576, n1577, n1578, n1579, n1580, n1581,
         n1582, n1583, n1584, n1585, n1586, n1587, n1588, n1589, n1590, n1591,
         n1592, n1593, n1594, n1595, n1596, n1597, n1598, n1599, n1600, n1601,
         n1602, n1603, n1604, n1605, n1606, n1607, n1608, n1609, n1610, n1611,
         n1612, n1613, n1614, n1615, n1616, n1617, n1618, n1619, n1620, n1621,
         n1622, n1623, n1624, n1625, n1626, n1627, n1628, n1629, n1630, n1631,
         n1632, n1633, n1634, n1635, n1636, n1637, n1638, n1639, n1640, n1641,
         n1642, n1643, n1644, n1645, n1646, n1647, n1648, n1649, n1650, n1651,
         n1652, n1653, n1654, n1655, n1656, n1657, n1658, n1659, n1660, n1661,
         n1662, n1663, n1664, n1665, n1666, n1667, n1668, n1669, n1670, n1671,
         n1672, n1750, n1752, n1754, n1755, n1756, n1757, n1759, n1761, n1762,
         n1763, n1765, n1767, n1768, n1769, n1773, n1779, n1780, n1781, n1782,
         n1784, n1785, n1787, n1788, n1791, n1792, n1793, n1794, n1795, n1796,
         n1797, n1798, n1800, n1801, n1802, n1803, n1805, n1806, n1807, n1808,
         n1812, n1813, n1814, n1815, n1816, n1820, n1821, n1824, n1825, n1826,
         n1827, n1845, n1846, n1847, n1848, n1849, n1850, n1851, n1852, n1853,
         n1854, n1855, n1856, n1857, n1858, n1859, n1860, n1861, n1862, n1863,
         n1864, n1865, n1866, n1867, n1868, n1869, n1870, n1871, net6071,
         n1872, net6012, n1873, net6044, n1874, net6085, n1876, n1877, n1878,
         net6102, net6096, net6089, net6090, net6086, net6082, net6076,
         net6077, net6070, net6057, net6052, net6048, net6043, net6040,
         net6035, net6036, net6031, net6027, net6028, net6013, net6014, n1879,
         n1880, n1881, n1882, n1883, n1884, n1885, n1886, n1887, n1888, n1889,
         n1890, n1891, n1892, n1893, n1894, n1895, n1896, n1897, n1898, n1899,
         n1900, n1901, n1902, n1903, n1904, n1905, n1906, n1907, net5655,
         net5649, net5643, net5638, n1908, n1909, n1910;
  wire   [3:0] NxtStP;

  NOR2X6 U1235 ( .A(net6027), .B(n1469), .Y(PRDATA[16]) );
  NOR2X6 U1236 ( .A(net6090), .B(n1470), .Y(PRDATA[17]) );
  NOR2X6 U1237 ( .A(n1866), .B(n1471), .Y(PRDATA[18]) );
  NOR2X6 U1238 ( .A(n1863), .B(n1472), .Y(PRDATA[19]) );
  NOR2X6 U1239 ( .A(n1867), .B(n1473), .Y(PRDATA[20]) );
  NOR2X6 U1240 ( .A(net6040), .B(n1477), .Y(PRDATA[24]) );
  NOR2X6 U1241 ( .A(n1868), .B(n1479), .Y(PRDATA[26]) );
  INVX20 U1242 ( .A(PADDR[13]), .Y(n1862) );
  NOR2X6 U1243 ( .A(n1862), .B(n1478), .Y(PRDATA[25]) );
  INVX20 U1244 ( .A(PADDR[13]), .Y(n1863) );
  NOR2X6 U1245 ( .A(net6013), .B(n1480), .Y(PRDATA[27]) );
  INVX20 U1246 ( .A(PADDR[13]), .Y(n1864) );
  NOR2X6 U1247 ( .A(n1864), .B(n1482), .Y(PRDATA[29]) );
  INVX20 U1248 ( .A(PADDR[13]), .Y(n1865) );
  NOR2X6 U1249 ( .A(n1865), .B(n1483), .Y(PRDATA[30]) );
  INVX20 U1250 ( .A(PADDR[13]), .Y(n1866) );
  NOR2X6 U1251 ( .A(net6028), .B(n1484), .Y(PRDATA[31]) );
  INVX20 U1252 ( .A(PADDR[13]), .Y(n1867) );
  NOR2X6 U1253 ( .A(net6082), .B(n1476), .Y(PRDATA[23]) );
  INVX20 U1254 ( .A(PADDR[13]), .Y(n1868) );
  OAI2BB1X4 U1255 ( .A0N(n1869), .A1N(PRDY), .B0(net6052), .Y(PREADY) );
  INVX20 U1256 ( .A(PADDR[13]), .Y(n1870) );
  NOR2X6 U1257 ( .A(n1870), .B(n1481), .Y(PRDATA[28]) );
  MXI2X4 U1258 ( .S0(net6071), .B(n1871), .A(net5655), .Y(PRDATA[12]) );
  CLKINVX20 U1259 ( .A(PADDR[13]), .Y(net6071) );
  CLKINVX3 U1260 ( .A(PIDO[12]), .Y(n1871) );
  MXI2X4 U1261 ( .S0(net6012), .B(n1872), .A(net5649), .Y(PRDATA[13]) );
  CLKINVX20 U1262 ( .A(PADDR[13]), .Y(net6012) );
  CLKINVX3 U1263 ( .A(PIDO[13]), .Y(n1872) );
  MXI2X4 U1264 ( .S0(net6044), .B(n1873), .A(net5643), .Y(PRDATA[14]) );
  CLKINVX20 U1265 ( .A(PADDR[13]), .Y(net6044) );
  CLKINVX3 U1266 ( .A(PIDO[14]), .Y(n1873) );
  MXI2X4 U1267 ( .S0(net6085), .B(n1874), .A(net5638), .Y(PRDATA[15]) );
  CLKINVX20 U1268 ( .A(PADDR[13]), .Y(net6085) );
  CLKINVX3 U1269 ( .A(PIDO[15]), .Y(n1874) );
  AND3X1 U1270 ( .A(PSEL), .B(n1883), .C(net6035), .Y(n1876) );
  INVX20 U1271 ( .A(PADDR[13]), .Y(net6052) );
  NOR2X6 U1272 ( .A(net6035), .B(n1474), .Y(PRDATA[21]) );
  NOR2X6 U1273 ( .A(net6057), .B(n1475), .Y(PRDATA[22]) );
  INVX20 U1274 ( .A(PADDR[13]), .Y(net6057) );
  INVX20 U1275 ( .A(PADDR[13]), .Y(net6035) );
  INVX20 U1276 ( .A(PADDR[13]), .Y(net6028) );
  INVX20 U1277 ( .A(PADDR[13]), .Y(net6013) );
  INVX20 U1278 ( .A(PADDR[13]), .Y(net6040) );
  INVX20 U1279 ( .A(PADDR[13]), .Y(net6090) );
  INVX20 U1280 ( .A(PADDR[13]), .Y(net6027) );
  CLKINVX20 U1281 ( .A(PADDR[13]), .Y(net6077) );
  CLKINVX20 U1282 ( .A(PADDR[13]), .Y(net6048) );
  CLKINVX20 U1283 ( .A(PADDR[13]), .Y(net6031) );
  CLKINVX20 U1284 ( .A(PADDR[13]), .Y(net6086) );
  CLKINVX20 U1285 ( .A(PADDR[13]), .Y(net6043) );
  CLKINVX20 U1286 ( .A(PADDR[13]), .Y(net6076) );
  CLKINVX20 U1287 ( .A(PADDR[13]), .Y(net6102) );
  CLKINVX20 U1288 ( .A(PADDR[13]), .Y(net6070) );
  CLKINVX20 U1289 ( .A(PADDR[13]), .Y(net6014) );
  CLKINVX20 U1290 ( .A(PADDR[13]), .Y(net6036) );
  CLKINVX20 U1291 ( .A(PADDR[13]), .Y(net6089) );
  CLKINVX20 U1292 ( .A(PADDR[13]), .Y(net6096) );
  INVX20 U1293 ( .A(PADDR[13]), .Y(net6082) );
  CLKINVX1 U1294 ( .A(n1807), .Y(n1803) );
  AND3X4 U1295 ( .A(PADDR[3]), .B(PADDR[4]), .C(n1803), .Y(TxFIFORead) );
  OR3X2 U1296 ( .A(PENABLE), .B(PADDR[9]), .C(PADDR[8]), .Y(n1813) );
  CLKINVX3 U1297 ( .A(PIDO[11]), .Y(n1893) );
  NAND3BX1 U1298 ( .AN(PADDR[2]), .B(PWRITE), .C(n1768), .Y(n1767) );
  NAND3BX1 U1299 ( .AN(PWRITE), .B(n1808), .C(n1768), .Y(n1807) );
  CLKINVX1 U1300 ( .A(PADDR[7]), .Y(n1814) );
  CLKINVX1 U1301 ( .A(PADDR[10]), .Y(n1820) );
  OR2XL U1302 ( .A(tPRead1), .B(tPRead0), .Y(n1825) );
  CLKINVX3 U1303 ( .A(PIDO[8]), .Y(n1885) );
  CLKINVX3 U1304 ( .A(PIDO[9]), .Y(n1884) );
  CLKINVX3 U1305 ( .A(PIDO[10]), .Y(n1894) );
  OAI211XL U1306 ( .A0(n1859), .A1(n1795), .B0(n1800), .C0(n1801), .Y(
        PRDATADma1079_0_) );
  OAI211XL U1307 ( .A0(n1846), .A1(n1795), .B0(n1796), .C0(n1797), .Y(
        PRDATADma1079_1_) );
  NAND3BX1 U1308 ( .AN(PADDR[11]), .B(PSEL), .C(n1820), .Y(n1880) );
  INVX1 U1309 ( .A(PADDR[12]), .Y(n1881) );
  NAND3BXL U1310 ( .AN(PADDR[3]), .B(PADDR[4]), .C(n1803), .Y(n1795) );
  NAND3BXL U1311 ( .AN(PADDR[4]), .B(n1763), .C(n1803), .Y(n1779) );
  MXI2XL U1312 ( .S0(n1876), .B(n1814), .A(n1850), .Y(n1571) );
  MXI2XL U1313 ( .S0(n1876), .B(n1820), .A(n1860), .Y(n1568) );
  OAI211XL U1314 ( .A0(n1851), .A1(n1779), .B0(n1791), .C0(n1792), .Y(
        PRDATADma1079_2_) );
  AOI22XL U1315 ( .A0(TxFIFORdData[2]), .A1(TxFIFORead), .B0(
        RxFIFORdDataCpu[2]), .B1(rRXDATRd), .Y(n1791) );
  OAI211XL U1316 ( .A0(n1853), .A1(n1779), .B0(n1787), .C0(n1788), .Y(
        PRDATADma1079_4_) );
  AOI22XL U1317 ( .A0(TxFIFORdData[4]), .A1(TxFIFORead), .B0(
        RxFIFORdDataCpu[4]), .B1(rRXDATRd), .Y(n1787) );
  OAI211XL U1318 ( .A0(n1854), .A1(n1779), .B0(n1784), .C0(n1785), .Y(
        PRDATADma1079_5_) );
  AOI22XL U1319 ( .A0(TxFIFORdData[5]), .A1(TxFIFORead), .B0(
        RxFIFORdDataCpu[5]), .B1(rRXDATRd), .Y(n1784) );
  OAI211XL U1320 ( .A0(n1852), .A1(n1779), .B0(n1780), .C0(n1781), .Y(
        PRDATADma1079_6_) );
  AOI22XL U1321 ( .A0(TxFIFORdData[6]), .A1(TxFIFORead), .B0(
        RxFIFORdDataCpu[6]), .B1(rRXDATRd), .Y(n1780) );
  NAND4BXL U1322 ( .AN(PWRITE), .B(n1763), .C(PADDR[2]), .D(n1768), .Y(n1806)
         );
  AO22XL U1323 ( .A0(PIA[0]), .A1(n1908), .B0(n1876), .B1(PADDR[2]), .Y(n1576)
         );
  AO22XL U1324 ( .A0(PIA[4]), .A1(n1769), .B0(PADDR[6]), .B1(n1876), .Y(n1572)
         );
  AO22XL U1325 ( .A0(RxFIFORdDataCpu[7]), .A1(rRXDATRd), .B0(TxFIFORdData[7]), 
        .B1(TxFIFORead), .Y(PRDATADma1079_7_) );
  AO22XL U1326 ( .A0(RxFIFORdDataCpu[8]), .A1(rRXDATRd), .B0(TxFIFORdData[8]), 
        .B1(TxFIFORead), .Y(PRDATADma1079_8_) );
  AO22XL U1327 ( .A0(RxFIFORdDataCpu[9]), .A1(rRXDATRd), .B0(TxFIFORdData[9]), 
        .B1(TxFIFORead), .Y(PRDATADma1079_9_) );
  AO22XL U1328 ( .A0(RxFIFORdDataCpu[10]), .A1(rRXDATRd), .B0(TxFIFORdData[10]), .B1(TxFIFORead), .Y(PRDATADma1079_10_) );
  AO22XL U1329 ( .A0(RxFIFORdDataCpu[11]), .A1(rRXDATRd), .B0(TxFIFORdData[11]), .B1(TxFIFORead), .Y(PRDATADma1079_11_) );
  AO22XL U1330 ( .A0(RxFIFORdDataCpu[12]), .A1(rRXDATRd), .B0(TxFIFORdData[12]), .B1(TxFIFORead), .Y(PRDATADma1079_12_) );
  AO22XL U1331 ( .A0(RxFIFORdDataCpu[13]), .A1(rRXDATRd), .B0(TxFIFORdData[13]), .B1(TxFIFORead), .Y(PRDATADma1079_13_) );
  AO22XL U1332 ( .A0(RxFIFORdDataCpu[14]), .A1(rRXDATRd), .B0(TxFIFORdData[14]), .B1(TxFIFORead), .Y(PRDATADma1079_14_) );
  AO22XL U1333 ( .A0(RxFIFORdDataCpu[15]), .A1(rRXDATRd), .B0(TxFIFORdData[15]), .B1(TxFIFORead), .Y(PRDATADma1079_15_) );
  AO22XL U1334 ( .A0(RxFIFORdDataCpu[16]), .A1(rRXDATRd), .B0(TxFIFORdData[16]), .B1(TxFIFORead), .Y(PRDATADma1079_16_) );
  AO22XL U1335 ( .A0(RxFIFORdDataCpu[17]), .A1(rRXDATRd), .B0(TxFIFORdData[17]), .B1(TxFIFORead), .Y(PRDATADma1079_17_) );
  AO22XL U1336 ( .A0(RxFIFORdDataCpu[18]), .A1(rRXDATRd), .B0(TxFIFORdData[18]), .B1(TxFIFORead), .Y(PRDATADma1079_18_) );
  AO22XL U1337 ( .A0(RxFIFORdDataCpu[19]), .A1(rRXDATRd), .B0(TxFIFORdData[19]), .B1(TxFIFORead), .Y(PRDATADma1079_19_) );
  AO22XL U1338 ( .A0(RxFIFORdDataCpu[20]), .A1(rRXDATRd), .B0(TxFIFORdData[20]), .B1(TxFIFORead), .Y(PRDATADma1079_20_) );
  AO22XL U1339 ( .A0(RxFIFORdDataCpu[21]), .A1(rRXDATRd), .B0(TxFIFORdData[21]), .B1(TxFIFORead), .Y(PRDATADma1079_21_) );
  AO22XL U1340 ( .A0(RxFIFORdDataCpu[22]), .A1(rRXDATRd), .B0(TxFIFORdData[22]), .B1(TxFIFORead), .Y(PRDATADma1079_22_) );
  AO22XL U1341 ( .A0(RxFIFORdDataCpu[23]), .A1(rRXDATRd), .B0(TxFIFORdData[23]), .B1(TxFIFORead), .Y(PRDATADma1079_23_) );
  AO22XL U1342 ( .A0(RxFIFORdDataCpu[24]), .A1(rRXDATRd), .B0(TxFIFORdData[24]), .B1(TxFIFORead), .Y(PRDATADma1079_24_) );
  AO22XL U1343 ( .A0(RxFIFORdDataCpu[25]), .A1(rRXDATRd), .B0(TxFIFORdData[25]), .B1(TxFIFORead), .Y(PRDATADma1079_25_) );
  AO22XL U1344 ( .A0(RxFIFORdDataCpu[26]), .A1(rRXDATRd), .B0(TxFIFORdData[26]), .B1(TxFIFORead), .Y(PRDATADma1079_26_) );
  AO22XL U1345 ( .A0(RxFIFORdDataCpu[27]), .A1(rRXDATRd), .B0(TxFIFORdData[27]), .B1(TxFIFORead), .Y(PRDATADma1079_27_) );
  AO22XL U1346 ( .A0(RxFIFORdDataCpu[28]), .A1(rRXDATRd), .B0(TxFIFORdData[28]), .B1(TxFIFORead), .Y(PRDATADma1079_28_) );
  AO22XL U1347 ( .A0(RxFIFORdDataCpu[29]), .A1(rRXDATRd), .B0(TxFIFORdData[29]), .B1(TxFIFORead), .Y(PRDATADma1079_29_) );
  AO22XL U1348 ( .A0(RxFIFORdDataCpu[30]), .A1(rRXDATRd), .B0(TxFIFORdData[30]), .B1(TxFIFORead), .Y(PRDATADma1079_30_) );
  AO22XL U1349 ( .A0(RxFIFORdDataCpu[31]), .A1(rRXDATRd), .B0(TxFIFORdData[31]), .B1(TxFIFORead), .Y(PRDATADma1079_31_) );
  AOI22XL U1350 ( .A0(RxFIFORdDataCpu[3]), .A1(rRXDATRd), .B0(TxFIFORdData[3]), 
        .B1(TxFIFORead), .Y(n1878) );
  CLKINVX1 U1351 ( .A(n1794), .Y(n1750) );
  CLKINVX1 U1352 ( .A(n1825), .Y(XPOE) );
  NAND2BX1 U1353 ( .AN(n1765), .B(n1805), .Y(n1794) );
  OAI22XL U1354 ( .A0(n1757), .A1(n1855), .B0(n1757), .B1(n1761), .Y(n1663) );
  OAI22XL U1355 ( .A0(n1757), .A1(n1856), .B0(n1757), .B1(n1759), .Y(n1664) );
  OAI22XL U1356 ( .A0(n1750), .A1(n1847), .B0(n1750), .B1(n1754), .Y(n1671) );
  OAI22XL U1357 ( .A0(n1750), .A1(n1848), .B0(n1750), .B1(n1752), .Y(n1672) );
  CLKINVX1 U1358 ( .A(n1909), .Y(rRXDATWr) );
  CLKINVX1 U1359 ( .A(n1910), .Y(rTXDATWr) );
  CLKINVX1 U1360 ( .A(n1755), .Y(n_1350) );
  CLKINVX1 U1361 ( .A(n1762), .Y(n_694) );
  CLKINVX1 U1362 ( .A(n1793), .Y(n1757) );
  CLKINVX1 U1363 ( .A(n1795), .Y(n1782) );
  CLKINVX1 U1364 ( .A(n1779), .Y(n1798) );
  CLKINVX1 U1365 ( .A(RxDmaErr), .Y(n1759) );
  CLKINVX1 U1366 ( .A(TxDmaErr), .Y(n1752) );
  CLKINVX1 U1367 ( .A(RxDmaReq), .Y(n1761) );
  CLKINVX1 U1368 ( .A(TxDmaReq), .Y(n1754) );
  DFFRX1 SEIPInt_reg ( .D(SEIPInt1041), .CK(PCLK), .RN(PRESETB), .Q(SEIPInt)
         );
  CLKINVX2 U1369 ( .A(PIDO[5]), .Y(n1888) );
  CLKINVX2 U1370 ( .A(PIDO[6]), .Y(n1887) );
  CLKINVX2 U1371 ( .A(PIDO[7]), .Y(n1886) );
  CLKINVX2 U1372 ( .A(PIDO[0]), .Y(n1895) );
  CLKINVX2 U1373 ( .A(PIDO[1]), .Y(n1892) );
  CLKINVX2 U1374 ( .A(PIDO[2]), .Y(n1891) );
  CLKINVX2 U1375 ( .A(PIDO[3]), .Y(n1890) );
  CLKINVX2 U1376 ( .A(PIDO[4]), .Y(n1889) );
  NOR2X1 U1377 ( .A(n1879), .B(n1880), .Y(n1768) );
  NAND3X1 U1378 ( .A(n1881), .B(PADDR[13]), .C(n1882), .Y(n1879) );
  CLKINVX1 U1379 ( .A(PADDR[2]), .Y(n1808) );
  CLKINVX1 U1380 ( .A(n1812), .Y(n1882) );
  NAND4BX1 U1381 ( .AN(n1813), .B(n1814), .C(n1815), .D(n1816), .Y(n1812) );
  CLKINVX1 U1382 ( .A(PADDR[5]), .Y(n1815) );
  CLKINVX1 U1383 ( .A(PADDR[6]), .Y(n1816) );
  NAND3BX1 U1384 ( .AN(PADDR[3]), .B(PADDR[4]), .C(n1756), .Y(n1755) );
  NAND3BX1 U1385 ( .AN(PADDR[4]), .B(PADDR[3]), .C(n1756), .Y(n1909) );
  NAND3BX1 U1386 ( .AN(n1765), .B(PADDR[3]), .C(n1756), .Y(n1910) );
  NAND3BX1 U1387 ( .AN(PADDR[4]), .B(n1763), .C(n1756), .Y(n1762) );
  NAND2BX1 U1388 ( .AN(PADDR[4]), .B(n1805), .Y(n1793) );
  CLKINVX1 U1389 ( .A(PADDR[4]), .Y(n1765) );
  CLKINVX1 U1390 ( .A(PADDR[3]), .Y(n1763) );
  CLKINVX1 U1391 ( .A(n1802), .Y(rRXDATRd) );
  NAND3BX1 U1392 ( .AN(PADDR[4]), .B(PADDR[3]), .C(n1803), .Y(n1802) );
  CLKINVX1 U1393 ( .A(n1767), .Y(n1756) );
  AO22X1 U1394 ( .A0(TxDmaSize[1]), .A1(n1755), .B0(PWDATA[5]), .B1(n_1350), 
        .Y(n1669) );
  AO22X1 U1395 ( .A0(TxDmaSize[0]), .A1(n1755), .B0(PWDATA[4]), .B1(n_1350), 
        .Y(n1670) );
  CLKINVX1 U1396 ( .A(n1806), .Y(n1805) );
  AO22X1 U1397 ( .A0(PIA[10]), .A1(n1769), .B0(PADDR[12]), .B1(n1876), .Y(
        n1566) );
  AO22X1 U1398 ( .A0(PIA[7]), .A1(n1769), .B0(PADDR[9]), .B1(n1876), .Y(n1569)
         );
  AO22X1 U1399 ( .A0(TxFIFOWrDataCpu[31]), .A1(n1910), .B0(PWDATA[31]), .B1(
        rTXDATWr), .Y(n1625) );
  AO22X1 U1400 ( .A0(TxFIFOWrDataCpu[30]), .A1(n1910), .B0(PWDATA[30]), .B1(
        rTXDATWr), .Y(n1626) );
  AO22X1 U1401 ( .A0(TxFIFOWrDataCpu[29]), .A1(n1910), .B0(PWDATA[29]), .B1(
        rTXDATWr), .Y(n1627) );
  AO22X1 U1402 ( .A0(TxFIFOWrDataCpu[28]), .A1(n1910), .B0(PWDATA[28]), .B1(
        rTXDATWr), .Y(n1628) );
  AO22X1 U1403 ( .A0(TxFIFOWrDataCpu[27]), .A1(n1910), .B0(PWDATA[27]), .B1(
        rTXDATWr), .Y(n1629) );
  AO22X1 U1404 ( .A0(TxFIFOWrDataCpu[26]), .A1(n1910), .B0(PWDATA[26]), .B1(
        rTXDATWr), .Y(n1630) );
  AO22X1 U1405 ( .A0(TxFIFOWrDataCpu[25]), .A1(n1910), .B0(PWDATA[25]), .B1(
        rTXDATWr), .Y(n1631) );
  AO22X1 U1406 ( .A0(TxFIFOWrDataCpu[24]), .A1(n1910), .B0(PWDATA[24]), .B1(
        rTXDATWr), .Y(n1632) );
  AO22X1 U1407 ( .A0(TxFIFOWrDataCpu[23]), .A1(n1910), .B0(PWDATA[23]), .B1(
        rTXDATWr), .Y(n1633) );
  AO22X1 U1408 ( .A0(TxFIFOWrDataCpu[22]), .A1(n1910), .B0(PWDATA[22]), .B1(
        rTXDATWr), .Y(n1634) );
  AO22X1 U1409 ( .A0(TxFIFOWrDataCpu[21]), .A1(n1910), .B0(PWDATA[21]), .B1(
        rTXDATWr), .Y(n1635) );
  AO22X1 U1410 ( .A0(TxFIFOWrDataCpu[20]), .A1(n1910), .B0(PWDATA[20]), .B1(
        rTXDATWr), .Y(n1636) );
  AO22X1 U1411 ( .A0(TxFIFOWrDataCpu[19]), .A1(n1910), .B0(PWDATA[19]), .B1(
        rTXDATWr), .Y(n1637) );
  AO22X1 U1412 ( .A0(TxFIFOWrDataCpu[18]), .A1(n1910), .B0(PWDATA[18]), .B1(
        rTXDATWr), .Y(n1638) );
  AO22X1 U1413 ( .A0(TxFIFOWrDataCpu[17]), .A1(n1910), .B0(PWDATA[17]), .B1(
        rTXDATWr), .Y(n1639) );
  AO22X1 U1414 ( .A0(TxFIFOWrDataCpu[16]), .A1(n1910), .B0(PWDATA[16]), .B1(
        rTXDATWr), .Y(n1640) );
  AO22X1 U1415 ( .A0(TxFIFOWrDataCpu[15]), .A1(n1910), .B0(PWDATA[15]), .B1(
        rTXDATWr), .Y(n1641) );
  AO22X1 U1416 ( .A0(TxFIFOWrDataCpu[14]), .A1(n1910), .B0(PWDATA[14]), .B1(
        rTXDATWr), .Y(n1642) );
  AO22X1 U1417 ( .A0(TxFIFOWrDataCpu[13]), .A1(n1910), .B0(PWDATA[13]), .B1(
        rTXDATWr), .Y(n1643) );
  AO22X1 U1418 ( .A0(TxFIFOWrDataCpu[12]), .A1(n1910), .B0(PWDATA[12]), .B1(
        rTXDATWr), .Y(n1644) );
  AO22X1 U1419 ( .A0(TxFIFOWrDataCpu[11]), .A1(n1910), .B0(PWDATA[11]), .B1(
        rTXDATWr), .Y(n1645) );
  AO22X1 U1420 ( .A0(TxFIFOWrDataCpu[10]), .A1(n1910), .B0(PWDATA[10]), .B1(
        rTXDATWr), .Y(n1646) );
  AO22X1 U1421 ( .A0(TxFIFOWrDataCpu[9]), .A1(n1910), .B0(PWDATA[9]), .B1(
        rTXDATWr), .Y(n1647) );
  AO22X1 U1422 ( .A0(TxFIFOWrDataCpu[8]), .A1(n1910), .B0(PWDATA[8]), .B1(
        rTXDATWr), .Y(n1648) );
  AO22X1 U1423 ( .A0(TxFIFOWrDataCpu[7]), .A1(n1910), .B0(PWDATA[7]), .B1(
        rTXDATWr), .Y(n1649) );
  AO22X1 U1424 ( .A0(TxFIFOWrDataCpu[3]), .A1(n1910), .B0(PWDATA[3]), .B1(
        rTXDATWr), .Y(n1653) );
  AO22X1 U1425 ( .A0(TxDmaEn), .A1(n1755), .B0(PWDATA[0]), .B1(n_1350), .Y(
        n1665) );
  AO22X1 U1426 ( .A0(TxDmaReqIntEn), .A1(n1755), .B0(PWDATA[1]), .B1(n_1350), 
        .Y(n1666) );
  AO22X1 U1427 ( .A0(TxDmaErrIntEn), .A1(n1755), .B0(PWDATA[2]), .B1(n_1350), 
        .Y(n1667) );
  AO22X1 U1428 ( .A0(TxDmaSize[2]), .A1(n1755), .B0(PWDATA[6]), .B1(n_1350), 
        .Y(n1668) );
  AO22X1 U1429 ( .A0(PIA[1]), .A1(n1769), .B0(n1876), .B1(PADDR[3]), .Y(n1575)
         );
  AO22X1 U1430 ( .A0(PIDI[14]), .A1(n1769), .B0(n1876), .B1(PWDATA[14]), .Y(
        n1578) );
  AO22X1 U1431 ( .A0(PIDI[12]), .A1(n1769), .B0(n1876), .B1(PWDATA[12]), .Y(
        n1580) );
  AO22X1 U1432 ( .A0(PIDI[11]), .A1(n1769), .B0(n1876), .B1(PWDATA[11]), .Y(
        n1581) );
  AO22X1 U1433 ( .A0(PIDI[8]), .A1(n1769), .B0(n1876), .B1(PWDATA[8]), .Y(
        n1584) );
  AO22X1 U1434 ( .A0(PIDI[6]), .A1(n1769), .B0(n1876), .B1(PWDATA[6]), .Y(
        n1586) );
  AO22X1 U1435 ( .A0(PIDI[5]), .A1(n1769), .B0(n1876), .B1(PWDATA[5]), .Y(
        n1587) );
  AO22X1 U1436 ( .A0(PIDI[2]), .A1(n1769), .B0(n1876), .B1(PWDATA[2]), .Y(
        n1590) );
  AO22X1 U1437 ( .A0(PIDI[0]), .A1(n1769), .B0(n1876), .B1(PWDATA[0]), .Y(
        n1592) );
  AO22X1 U1438 ( .A0(RxDmaSize[1]), .A1(n1762), .B0(n_694), .B1(PWDATA[5]), 
        .Y(n1661) );
  AO22X1 U1439 ( .A0(RxDmaSize[0]), .A1(n1762), .B0(n_694), .B1(PWDATA[4]), 
        .Y(n1662) );
  AO22X1 U1440 ( .A0(RxFIFOWrData[31]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[31]), .Y(n1593) );
  AO22X1 U1441 ( .A0(RxFIFOWrData[30]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[30]), .Y(n1594) );
  AO22X1 U1442 ( .A0(RxFIFOWrData[29]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[29]), .Y(n1595) );
  AO22X1 U1443 ( .A0(RxFIFOWrData[28]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[28]), .Y(n1596) );
  AO22X1 U1444 ( .A0(RxFIFOWrData[27]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[27]), .Y(n1597) );
  AO22X1 U1445 ( .A0(RxFIFOWrData[26]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[26]), .Y(n1598) );
  AO22X1 U1446 ( .A0(RxFIFOWrData[25]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[25]), .Y(n1599) );
  AO22X1 U1447 ( .A0(RxFIFOWrData[24]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[24]), .Y(n1600) );
  AO22X1 U1448 ( .A0(RxFIFOWrData[23]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[23]), .Y(n1601) );
  AO22X1 U1449 ( .A0(RxFIFOWrData[22]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[22]), .Y(n1602) );
  AO22X1 U1450 ( .A0(RxFIFOWrData[21]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[21]), .Y(n1603) );
  AO22X1 U1451 ( .A0(RxFIFOWrData[20]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[20]), .Y(n1604) );
  AO22X1 U1452 ( .A0(RxFIFOWrData[19]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[19]), .Y(n1605) );
  AO22X1 U1453 ( .A0(RxFIFOWrData[18]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[18]), .Y(n1606) );
  AO22X1 U1454 ( .A0(RxFIFOWrData[17]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[17]), .Y(n1607) );
  AO22X1 U1455 ( .A0(RxFIFOWrData[16]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[16]), .Y(n1608) );
  AO22X1 U1456 ( .A0(RxFIFOWrData[15]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[15]), .Y(n1609) );
  AO22X1 U1457 ( .A0(RxFIFOWrData[14]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[14]), .Y(n1610) );
  AO22X1 U1458 ( .A0(RxFIFOWrData[13]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[13]), .Y(n1611) );
  AO22X1 U1459 ( .A0(RxFIFOWrData[12]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[12]), .Y(n1612) );
  AO22X1 U1460 ( .A0(RxFIFOWrData[11]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[11]), .Y(n1613) );
  AO22X1 U1461 ( .A0(RxFIFOWrData[10]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[10]), .Y(n1614) );
  AO22X1 U1462 ( .A0(RxFIFOWrData[9]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[9]), .Y(n1615) );
  AO22X1 U1463 ( .A0(RxFIFOWrData[8]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[8]), .Y(n1616) );
  AO22X1 U1464 ( .A0(RxFIFOWrData[7]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[7]), .Y(n1617) );
  AO22X1 U1465 ( .A0(RxFIFOWrData[6]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[6]), .Y(n1618) );
  AO22X1 U1466 ( .A0(RxFIFOWrData[5]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[5]), .Y(n1619) );
  AO22X1 U1467 ( .A0(RxFIFOWrData[4]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[4]), .Y(n1620) );
  AO22X1 U1468 ( .A0(RxFIFOWrData[3]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[3]), .Y(n1621) );
  AO22X1 U1469 ( .A0(RxFIFOWrData[2]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[2]), .Y(n1622) );
  AO22X1 U1470 ( .A0(RxFIFOWrData[1]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[1]), .Y(n1623) );
  AO22X1 U1471 ( .A0(RxFIFOWrData[0]), .A1(n1909), .B0(rRXDATWr), .B1(
        PWDATA[0]), .Y(n1624) );
  AO22X1 U1472 ( .A0(TxFIFOWrDataCpu[6]), .A1(n1910), .B0(rTXDATWr), .B1(
        PWDATA[6]), .Y(n1650) );
  AO22X1 U1473 ( .A0(TxFIFOWrDataCpu[5]), .A1(n1910), .B0(rTXDATWr), .B1(
        PWDATA[5]), .Y(n1651) );
  AO22X1 U1474 ( .A0(TxFIFOWrDataCpu[4]), .A1(n1910), .B0(rTXDATWr), .B1(
        PWDATA[4]), .Y(n1652) );
  AO22X1 U1475 ( .A0(TxFIFOWrDataCpu[2]), .A1(n1910), .B0(rTXDATWr), .B1(
        PWDATA[2]), .Y(n1654) );
  AO22X1 U1476 ( .A0(TxFIFOWrDataCpu[1]), .A1(n1910), .B0(rTXDATWr), .B1(
        PWDATA[1]), .Y(n1655) );
  AO22X1 U1477 ( .A0(TxFIFOWrDataCpu[0]), .A1(n1910), .B0(rTXDATWr), .B1(
        PWDATA[0]), .Y(n1656) );
  AO22X1 U1478 ( .A0(RxDmaEn), .A1(n1762), .B0(n_694), .B1(PWDATA[0]), .Y(
        n1657) );
  AO22X1 U1479 ( .A0(RxDmaReqIntEn), .A1(n1762), .B0(n_694), .B1(PWDATA[1]), 
        .Y(n1658) );
  AO22X1 U1480 ( .A0(RxDmaErrIntEn), .A1(n1762), .B0(n_694), .B1(PWDATA[2]), 
        .Y(n1659) );
  AO22X1 U1481 ( .A0(RxDmaSize[2]), .A1(n1762), .B0(n_694), .B1(PWDATA[6]), 
        .Y(n1660) );
  OAI32X1 U1482 ( .A0(n1769), .A1(PWRITE), .A2(n1849), .B0(PRDY), .B1(XPOE), 
        .Y(NxtStP[1]) );
  OA22X1 U1483 ( .A0(n1847), .A1(n1794), .B0(n1855), .B1(n1793), .Y(n1796) );
  AOI222XL U1484 ( .A0(n1798), .A1(RxDmaReqIntEn), .B0(TxFIFORdData[1]), .B1(
        TxFIFORead), .C0(RxFIFORdDataCpu[1]), .C1(rRXDATRd), .Y(n1797) );
  AOI222XL U1485 ( .A0(n1782), .A1(TxDmaErrIntEn), .B0(TxFIFODataCnt[0]), .B1(
        n1750), .C0(RxFIFODataCnt[0]), .C1(n1757), .Y(n1792) );
  AOI222XL U1486 ( .A0(n1782), .A1(TxDmaSize[0]), .B0(TxFIFODataCnt[2]), .B1(
        n1750), .C0(RxFIFODataCnt[2]), .C1(n1757), .Y(n1788) );
  AOI222XL U1487 ( .A0(n1782), .A1(TxDmaSize[1]), .B0(TxFIFOEmpty), .B1(n1750), 
        .C0(RxFIFOEmpty), .C1(n1757), .Y(n1785) );
  AOI222XL U1488 ( .A0(n1782), .A1(TxDmaSize[2]), .B0(TxFIFOFull), .B1(n1750), 
        .C0(RxFIFOFull), .C1(n1757), .Y(n1781) );
  OA22X1 U1489 ( .A0(n1848), .A1(n1794), .B0(n1856), .B1(n1793), .Y(n1800) );
  AOI222XL U1490 ( .A0(n1798), .A1(RxDmaEn), .B0(TxFIFORdData[0]), .B1(
        TxFIFORead), .C0(RxFIFORdDataCpu[0]), .C1(rRXDATRd), .Y(n1801) );
  NAND2X1 U1491 ( .A(n1877), .B(n1878), .Y(PRDATADma1079_3_) );
  AOI22X1 U1492 ( .A0(RxFIFODataCnt[1]), .A1(n1757), .B0(TxFIFODataCnt[1]), 
        .B1(n1750), .Y(n1877) );
  NAND3BX1 U1493 ( .AN(PENABLE), .B(PSEL), .C(net6057), .Y(n1908) );
  CLKINVX1 U1494 ( .A(PENABLE), .Y(n1883) );
  MXI2X1 U1495 ( .S0(n1876), .B(n1765), .A(n1858), .Y(n1574) );
  CLKMX2X2 U1496 ( .S0(n1876), .B(PWDATA[15]), .A(PIDI[15]), .Y(n1577) );
  AO22X1 U1497 ( .A0(PIA[9]), .A1(n1908), .B0(PADDR[11]), .B1(n1876), .Y(n1567) );
  AO22X1 U1498 ( .A0(PIA[6]), .A1(n1908), .B0(PADDR[8]), .B1(n1876), .Y(n1570)
         );
  AO22X1 U1499 ( .A0(PIA[3]), .A1(n1908), .B0(PADDR[5]), .B1(n1876), .Y(n1573)
         );
  AO22X1 U1500 ( .A0(PIDI[13]), .A1(n1908), .B0(n1876), .B1(PWDATA[13]), .Y(
        n1579) );
  AO22X1 U1501 ( .A0(PIDI[10]), .A1(n1908), .B0(n1876), .B1(PWDATA[10]), .Y(
        n1582) );
  AO22X1 U1502 ( .A0(PIDI[9]), .A1(n1908), .B0(n1876), .B1(PWDATA[9]), .Y(
        n1583) );
  AO22X1 U1503 ( .A0(PIDI[7]), .A1(n1908), .B0(n1876), .B1(PWDATA[7]), .Y(
        n1585) );
  AO22X1 U1504 ( .A0(PIDI[4]), .A1(n1908), .B0(n1876), .B1(PWDATA[4]), .Y(
        n1588) );
  AO22X1 U1505 ( .A0(PIDI[3]), .A1(n1908), .B0(n1876), .B1(PWDATA[3]), .Y(
        n1589) );
  AO22X1 U1506 ( .A0(PIDI[1]), .A1(n1908), .B0(n1876), .B1(PWDATA[1]), .Y(
        n1591) );
  OAI32X1 U1507 ( .A0(n1908), .A1(n1821), .A2(n1849), .B0(PRDY), .B1(XPWE), 
        .Y(NxtStP[3]) );
  CLKINVX1 U1508 ( .A(PWRITE), .Y(n1821) );
  AO21X1 U1509 ( .A0(tPIdle), .A1(n1908), .B0(n1826), .Y(NxtStP[0]) );
  OAI31XL U1510 ( .A0(n1825), .A1(tPWrite), .A2(tPIdle), .B0(n1827), .Y(n1826)
         );
  OA22X1 U1511 ( .A0(n1824), .A1(n1861), .B0(n1824), .B1(XPWE), .Y(n1827) );
  OAI221XL U1512 ( .A0(n1752), .A1(n1857), .B0(n1754), .B1(n1846), .C0(n1773), 
        .Y(SEIPInt1041) );
  OA22X1 U1513 ( .A0(n1759), .A1(n1851), .B0(n1761), .B1(n1845), .Y(n1773) );
  CLKINVX1 U1514 ( .A(PRDY), .Y(n1824) );
  NOR2BX1 U1515 ( .AN(tPRead0), .B(n1824), .Y(NxtStP[2]) );
  DFFRX1 CurStP_reg_1_ ( .D(NxtStP[1]), .CK(PCLK), .RN(PRESETB), .Q(tPRead0), 
        .QN(n1869) );
  DFFRX1 CurStP_reg_2_ ( .D(NxtStP[2]), .CK(PCLK), .RN(PRESETB), .Q(tPRead1), 
        .QN(n1861) );
  DFFRX1 PIA_reg_2_ ( .D(n1574), .CK(PCLK), .RN(PRESETB), .Q(PIA[2]), .QN(
        n1858) );
  DFFRX1 PIA_reg_5_ ( .D(n1571), .CK(PCLK), .RN(PRESETB), .Q(PIA[5]), .QN(
        n1850) );
  DFFRX1 PIA_reg_8_ ( .D(n1568), .CK(PCLK), .RN(PRESETB), .Q(PIA[8]), .QN(
        n1860) );
  DFFRX1 PIA_reg_10_ ( .D(n1566), .CK(PCLK), .RN(PRESETB), .Q(PIA[10]) );
  DFFRX1 PIA_reg_9_ ( .D(n1567), .CK(PCLK), .RN(PRESETB), .Q(PIA[9]) );
  DFFRX1 PIA_reg_7_ ( .D(n1569), .CK(PCLK), .RN(PRESETB), .Q(PIA[7]) );
  DFFRX1 PIA_reg_6_ ( .D(n1570), .CK(PCLK), .RN(PRESETB), .Q(PIA[6]) );
  DFFRX1 PIA_reg_3_ ( .D(n1573), .CK(PCLK), .RN(PRESETB), .Q(PIA[3]) );
  DFFRX1 PIA_reg_1_ ( .D(n1575), .CK(PCLK), .RN(PRESETB), .Q(PIA[1]) );
  DFFRX1 PIA_reg_0_ ( .D(n1576), .CK(PCLK), .RN(PRESETB), .Q(PIA[0]) );
  DFFRX1 PIA_reg_4_ ( .D(n1572), .CK(PCLK), .RN(PRESETB), .Q(PIA[4]) );
  DFFRX1 PRDATADma_reg_18_ ( .D(PRDATADma1079_18_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1471) );
  DFFRX1 PRDATADma_reg_19_ ( .D(PRDATADma1079_19_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1472) );
  DFFRX1 PRDATADma_reg_20_ ( .D(PRDATADma1079_20_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1473) );
  DFFRX1 PRDATADma_reg_21_ ( .D(PRDATADma1079_21_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1474) );
  DFFRX1 PRDATADma_reg_22_ ( .D(PRDATADma1079_22_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1475) );
  DFFRX1 PRDATADma_reg_23_ ( .D(PRDATADma1079_23_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1476) );
  DFFRX1 PRDATADma_reg_25_ ( .D(PRDATADma1079_25_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1478) );
  DFFRX1 PRDATADma_reg_26_ ( .D(PRDATADma1079_26_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1479) );
  DFFRX1 PRDATADma_reg_28_ ( .D(PRDATADma1079_28_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1481) );
  DFFRX1 PRDATADma_reg_29_ ( .D(PRDATADma1079_29_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1482) );
  DFFRX1 PRDATADma_reg_30_ ( .D(PRDATADma1079_30_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1483) );
  DFFRX1 PRDATADma_reg_16_ ( .D(PRDATADma1079_16_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1469) );
  DFFRX1 PRDATADma_reg_17_ ( .D(PRDATADma1079_17_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1470) );
  DFFRX1 PRDATADma_reg_24_ ( .D(PRDATADma1079_24_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1477) );
  DFFRX1 PRDATADma_reg_27_ ( .D(PRDATADma1079_27_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1480) );
  DFFRX1 PRDATADma_reg_31_ ( .D(PRDATADma1079_31_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1484) );
  DFFRX1 TxFIFOWriteCpu_reg ( .D(rTXDATWr), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWriteCpu) );
  DFFSX1 RxDmaSize_reg_1_ ( .D(n1661), .CK(PCLK), .SN(PRESETB), .Q(
        RxDmaSize[1]), .QN(n1854) );
  DFFSX1 RxDmaSize_reg_0_ ( .D(n1662), .CK(PCLK), .SN(PRESETB), .Q(
        RxDmaSize[0]), .QN(n1853) );
  DFFRX1 RxDmaSize_reg_2_ ( .D(n1660), .CK(PCLK), .RN(PRESETB), .Q(
        RxDmaSize[2]), .QN(n1852) );
  SDFFRX1 TxFIFOFlush_reg ( .SI(n_1350), .SE(PWDATA[30]), .D(1'b0), .CK(PCLK), 
        .RN(PRESETB), .Q(TxFIFOFlush) );
  SDFFRX1 RxFIFOFlush_reg ( .SI(n_694), .SE(PWDATA[30]), .D(1'b0), .CK(PCLK), 
        .RN(PRESETB), .Q(RxFIFOFlush) );
  DFFSX1 TxDmaSize_reg_1_ ( .D(n1669), .CK(PCLK), .SN(PRESETB), .Q(
        TxDmaSize[1]) );
  DFFRX1 RxDmaReqIntEn_reg ( .D(n1658), .CK(PCLK), .RN(PRESETB), .Q(
        RxDmaReqIntEn), .QN(n1845) );
  DFFRX1 TxDmaErrIntEn_reg ( .D(n1667), .CK(PCLK), .RN(PRESETB), .Q(
        TxDmaErrIntEn), .QN(n1857) );
  DFFRX1 TxDmaSize_reg_2_ ( .D(n1668), .CK(PCLK), .RN(PRESETB), .Q(
        TxDmaSize[2]) );
  DFFRX1 RxDmaEn_reg ( .D(n1657), .CK(PCLK), .RN(PRESETB), .Q(RxDmaEn) );
  DFFSX1 TxDmaSize_reg_0_ ( .D(n1670), .CK(PCLK), .SN(PRESETB), .Q(
        TxDmaSize[0]) );
  DFFRX1 RxFIFOWrite_reg ( .D(rRXDATWr), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrite) );
  DFFRX1 TxFIFOWrDataCpu_reg_9_ ( .D(n1647), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[9]) );
  DFFRX1 TxFIFOWrDataCpu_reg_31_ ( .D(n1625), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[31]) );
  DFFRX1 TxFIFOWrDataCpu_reg_30_ ( .D(n1626), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[30]) );
  DFFRX1 TxFIFOWrDataCpu_reg_29_ ( .D(n1627), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[29]) );
  DFFRX1 TxFIFOWrDataCpu_reg_28_ ( .D(n1628), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[28]) );
  DFFRX1 TxFIFOWrDataCpu_reg_27_ ( .D(n1629), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[27]) );
  DFFRX1 TxFIFOWrDataCpu_reg_26_ ( .D(n1630), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[26]) );
  DFFRX1 TxFIFOWrDataCpu_reg_25_ ( .D(n1631), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[25]) );
  DFFRX1 TxFIFOWrDataCpu_reg_24_ ( .D(n1632), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[24]) );
  DFFRX1 TxFIFOWrDataCpu_reg_23_ ( .D(n1633), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[23]) );
  DFFRX1 TxFIFOWrDataCpu_reg_22_ ( .D(n1634), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[22]) );
  DFFRX1 TxFIFOWrDataCpu_reg_21_ ( .D(n1635), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[21]) );
  DFFRX1 TxFIFOWrDataCpu_reg_20_ ( .D(n1636), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[20]) );
  DFFRX1 TxFIFOWrDataCpu_reg_19_ ( .D(n1637), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[19]) );
  DFFRX1 TxFIFOWrDataCpu_reg_18_ ( .D(n1638), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[18]) );
  DFFRX1 TxFIFOWrDataCpu_reg_17_ ( .D(n1639), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[17]) );
  DFFRX1 TxFIFOWrDataCpu_reg_16_ ( .D(n1640), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[16]) );
  DFFRX1 TxFIFOWrDataCpu_reg_15_ ( .D(n1641), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[15]) );
  DFFRX1 TxFIFOWrDataCpu_reg_14_ ( .D(n1642), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[14]) );
  DFFRX1 TxFIFOWrDataCpu_reg_13_ ( .D(n1643), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[13]) );
  DFFRX1 TxFIFOWrDataCpu_reg_12_ ( .D(n1644), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[12]) );
  DFFRX1 TxFIFOWrDataCpu_reg_11_ ( .D(n1645), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[11]) );
  DFFRX1 TxFIFOWrDataCpu_reg_10_ ( .D(n1646), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[10]) );
  DFFRX1 TxFIFOWrDataCpu_reg_8_ ( .D(n1648), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[8]) );
  DFFRX1 TxFIFOWrDataCpu_reg_7_ ( .D(n1649), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[7]) );
  DFFRX1 TxFIFOWrDataCpu_reg_6_ ( .D(n1650), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[6]) );
  DFFRX1 TxFIFOWrDataCpu_reg_5_ ( .D(n1651), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[5]) );
  DFFRX1 TxFIFOWrDataCpu_reg_4_ ( .D(n1652), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[4]) );
  DFFRX1 TxFIFOWrDataCpu_reg_3_ ( .D(n1653), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[3]) );
  DFFRX1 TxFIFOWrDataCpu_reg_2_ ( .D(n1654), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[2]) );
  DFFRX1 TxFIFOWrDataCpu_reg_1_ ( .D(n1655), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[1]) );
  DFFRX1 TxFIFOWrDataCpu_reg_0_ ( .D(n1656), .CK(PCLK), .RN(PRESETB), .Q(
        TxFIFOWrDataCpu[0]) );
  DFFRX1 CurStP_reg_3_ ( .D(NxtStP[3]), .CK(PCLK), .RN(PRESETB), .Q(tPWrite), 
        .QN(XPWE) );
  DFFRX1 RxFIFOReadCpu_reg ( .D(rRXDATRd), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOReadCpu) );
  DFFSX1 CurStP_reg_0_ ( .D(NxtStP[0]), .CK(PCLK), .SN(PRESETB), .Q(tPIdle), 
        .QN(n1849) );
  DFFRX1 TxDmaEn_reg ( .D(n1665), .CK(PCLK), .RN(PRESETB), .Q(TxDmaEn), .QN(
        n1859) );
  DFFRX1 RxFIFOWrData_reg_31_ ( .D(n1593), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[31]) );
  DFFRX1 RxFIFOWrData_reg_30_ ( .D(n1594), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[30]) );
  DFFRX1 RxFIFOWrData_reg_29_ ( .D(n1595), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[29]) );
  DFFRX1 RxFIFOWrData_reg_28_ ( .D(n1596), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[28]) );
  DFFRX1 RxFIFOWrData_reg_27_ ( .D(n1597), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[27]) );
  DFFRX1 RxFIFOWrData_reg_26_ ( .D(n1598), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[26]) );
  DFFRX1 RxFIFOWrData_reg_25_ ( .D(n1599), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[25]) );
  DFFRX1 RxFIFOWrData_reg_24_ ( .D(n1600), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[24]) );
  DFFRX1 RxFIFOWrData_reg_23_ ( .D(n1601), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[23]) );
  DFFRX1 RxFIFOWrData_reg_22_ ( .D(n1602), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[22]) );
  DFFRX1 RxFIFOWrData_reg_21_ ( .D(n1603), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[21]) );
  DFFRX1 RxFIFOWrData_reg_20_ ( .D(n1604), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[20]) );
  DFFRX1 RxFIFOWrData_reg_19_ ( .D(n1605), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[19]) );
  DFFRX1 RxFIFOWrData_reg_18_ ( .D(n1606), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[18]) );
  DFFRX1 RxFIFOWrData_reg_17_ ( .D(n1607), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[17]) );
  DFFRX1 RxFIFOWrData_reg_16_ ( .D(n1608), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[16]) );
  DFFRX1 RxFIFOWrData_reg_15_ ( .D(n1609), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[15]) );
  DFFRX1 RxFIFOWrData_reg_14_ ( .D(n1610), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[14]) );
  DFFRX1 RxFIFOWrData_reg_13_ ( .D(n1611), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[13]) );
  DFFRX1 RxFIFOWrData_reg_12_ ( .D(n1612), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[12]) );
  DFFRX1 RxFIFOWrData_reg_11_ ( .D(n1613), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[11]) );
  DFFRX1 RxFIFOWrData_reg_10_ ( .D(n1614), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[10]) );
  DFFRX1 RxFIFOWrData_reg_9_ ( .D(n1615), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[9]) );
  DFFRX1 RxFIFOWrData_reg_8_ ( .D(n1616), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[8]) );
  DFFRX1 RxFIFOWrData_reg_7_ ( .D(n1617), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[7]) );
  DFFRX1 RxFIFOWrData_reg_6_ ( .D(n1618), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[6]) );
  DFFRX1 RxFIFOWrData_reg_5_ ( .D(n1619), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[5]) );
  DFFRX1 RxFIFOWrData_reg_4_ ( .D(n1620), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[4]) );
  DFFRX1 RxFIFOWrData_reg_3_ ( .D(n1621), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[3]) );
  DFFRX1 RxFIFOWrData_reg_2_ ( .D(n1622), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[2]) );
  DFFRX1 RxFIFOWrData_reg_1_ ( .D(n1623), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[1]) );
  DFFRX1 RxFIFOWrData_reg_0_ ( .D(n1624), .CK(PCLK), .RN(PRESETB), .Q(
        RxFIFOWrData[0]) );
  DFFRX1 RxDmaErrIntEn_reg ( .D(n1659), .CK(PCLK), .RN(PRESETB), .Q(
        RxDmaErrIntEn), .QN(n1851) );
  DFFRX1 TxDmaReqIntEn_reg ( .D(n1666), .CK(PCLK), .RN(PRESETB), .Q(
        TxDmaReqIntEn), .QN(n1846) );
  DFFRX1 PIDI_reg_15_ ( .D(n1577), .CK(PCLK), .RN(PRESETB), .Q(PIDI[15]) );
  DFFRX1 RxDmaReqSts_reg ( .D(n1663), .CK(PCLK), .RN(PRESETB), .QN(n1855) );
  DFFRX1 RxDmaErrSts_reg ( .D(n1664), .CK(PCLK), .RN(PRESETB), .QN(n1856) );
  DFFRX1 TxDmaReqSts_reg ( .D(n1671), .CK(PCLK), .RN(PRESETB), .QN(n1847) );
  DFFRX1 TxDmaErrSts_reg ( .D(n1672), .CK(PCLK), .RN(PRESETB), .QN(n1848) );
  SDFFRX1 TxDmaReset_reg ( .SI(n_1350), .SE(PWDATA[31]), .D(1'b0), .CK(PCLK), 
        .RN(PRESETB), .Q(TxDmaReset) );
  SDFFRX1 RxDmaReset_reg ( .SI(n_694), .SE(PWDATA[31]), .D(1'b0), .CK(PCLK), 
        .RN(PRESETB), .Q(RxDmaReset) );
  DFFRX1 PIDI_reg_14_ ( .D(n1578), .CK(PCLK), .RN(PRESETB), .Q(PIDI[14]) );
  DFFRX1 PIDI_reg_13_ ( .D(n1579), .CK(PCLK), .RN(PRESETB), .Q(PIDI[13]) );
  DFFRX1 PIDI_reg_12_ ( .D(n1580), .CK(PCLK), .RN(PRESETB), .Q(PIDI[12]) );
  DFFRX1 PIDI_reg_11_ ( .D(n1581), .CK(PCLK), .RN(PRESETB), .Q(PIDI[11]) );
  DFFRX1 PIDI_reg_10_ ( .D(n1582), .CK(PCLK), .RN(PRESETB), .Q(PIDI[10]) );
  DFFRX1 PIDI_reg_9_ ( .D(n1583), .CK(PCLK), .RN(PRESETB), .Q(PIDI[9]) );
  DFFRX1 PIDI_reg_8_ ( .D(n1584), .CK(PCLK), .RN(PRESETB), .Q(PIDI[8]) );
  DFFRX1 PIDI_reg_7_ ( .D(n1585), .CK(PCLK), .RN(PRESETB), .Q(PIDI[7]) );
  DFFRX1 PIDI_reg_6_ ( .D(n1586), .CK(PCLK), .RN(PRESETB), .Q(PIDI[6]) );
  DFFRX1 PIDI_reg_5_ ( .D(n1587), .CK(PCLK), .RN(PRESETB), .Q(PIDI[5]) );
  DFFRX1 PIDI_reg_4_ ( .D(n1588), .CK(PCLK), .RN(PRESETB), .Q(PIDI[4]) );
  DFFRX1 PIDI_reg_3_ ( .D(n1589), .CK(PCLK), .RN(PRESETB), .Q(PIDI[3]) );
  DFFRX1 PIDI_reg_2_ ( .D(n1590), .CK(PCLK), .RN(PRESETB), .Q(PIDI[2]) );
  DFFRX1 PIDI_reg_1_ ( .D(n1591), .CK(PCLK), .RN(PRESETB), .Q(PIDI[1]) );
  DFFRX1 PIDI_reg_0_ ( .D(n1592), .CK(PCLK), .RN(PRESETB), .Q(PIDI[0]) );
  MXI2X4 U1516 ( .S0(net6077), .B(n1895), .A(n1896), .Y(PRDATA[0]) );
  MXI2X4 U1517 ( .S0(net6048), .B(n1892), .A(n1897), .Y(PRDATA[1]) );
  MXI2X4 U1518 ( .S0(net6031), .B(n1891), .A(n1898), .Y(PRDATA[2]) );
  MXI2X4 U1519 ( .S0(net6086), .B(n1890), .A(n1899), .Y(PRDATA[3]) );
  MXI2X4 U1520 ( .S0(net6043), .B(n1889), .A(n1900), .Y(PRDATA[4]) );
  MXI2X4 U1521 ( .S0(net6076), .B(n1888), .A(n1901), .Y(PRDATA[5]) );
  MXI2X4 U1522 ( .S0(net6102), .B(n1887), .A(n1902), .Y(PRDATA[6]) );
  MXI2X4 U1523 ( .S0(net6014), .B(n1885), .A(n1904), .Y(PRDATA[8]) );
  MXI2X4 U1524 ( .S0(net6036), .B(n1884), .A(n1905), .Y(PRDATA[9]) );
  MXI2X4 U1525 ( .S0(net6070), .B(n1886), .A(n1903), .Y(PRDATA[7]) );
  MXI2X4 U1526 ( .S0(net6089), .B(n1894), .A(n1906), .Y(PRDATA[10]) );
  MXI2X4 U1527 ( .S0(net6096), .B(n1893), .A(n1907), .Y(PRDATA[11]) );
  NAND3BX1 U1528 ( .AN(PENABLE), .B(PSEL), .C(net6057), .Y(n1769) );
  DFFRX1 PRDATADma_reg_0_ ( .D(PRDATADma1079_0_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1896) );
  DFFRX1 PRDATADma_reg_1_ ( .D(PRDATADma1079_1_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1897) );
  DFFRX1 PRDATADma_reg_2_ ( .D(PRDATADma1079_2_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1898) );
  DFFRX1 PRDATADma_reg_3_ ( .D(PRDATADma1079_3_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1899) );
  DFFRX1 PRDATADma_reg_4_ ( .D(PRDATADma1079_4_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1900) );
  DFFRX1 PRDATADma_reg_5_ ( .D(PRDATADma1079_5_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1901) );
  DFFRX1 PRDATADma_reg_6_ ( .D(PRDATADma1079_6_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1902) );
  DFFRX1 PRDATADma_reg_7_ ( .D(PRDATADma1079_7_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1903) );
  DFFRX1 PRDATADma_reg_8_ ( .D(PRDATADma1079_8_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1904) );
  DFFRX1 PRDATADma_reg_9_ ( .D(PRDATADma1079_9_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1905) );
  DFFRX1 PRDATADma_reg_10_ ( .D(PRDATADma1079_10_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1906) );
  DFFRX1 PRDATADma_reg_11_ ( .D(PRDATADma1079_11_), .CK(PCLK), .RN(PRESETB), 
        .QN(n1907) );
  DFFRX1 PRDATADma_reg_12_ ( .D(PRDATADma1079_12_), .CK(PCLK), .RN(PRESETB), 
        .QN(net5655) );
  DFFRX1 PRDATADma_reg_13_ ( .D(PRDATADma1079_13_), .CK(PCLK), .RN(PRESETB), 
        .QN(net5649) );
  DFFRX1 PRDATADma_reg_14_ ( .D(PRDATADma1079_14_), .CK(PCLK), .RN(PRESETB), 
        .QN(net5643) );
  DFFRX1 PRDATADma_reg_15_ ( .D(PRDATADma1079_15_), .CK(PCLK), .RN(PRESETB), 
        .QN(net5638) );
endmodule

