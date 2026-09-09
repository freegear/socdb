/*****************************************************************
		         TestMaster Simple testbench
*****************************************************************/
`timescale 1 ns/ 10ps
module tb;

parameter CLK_HALFPERIOD=5;

parameter DATA_WIDTH = 32;	// only support 32 now

// auto assign from above parameter
parameter NUM_BYTE = DATA_WIDTH/8;

`define BURST_FIXED	2'b00
`define BURST_INCR	2'b01
`define BURST_WRAP	2'b10

reg         ACLK        ;     // APB system clock
reg         ARESETn     ;     // APB system reset

always #CLK_HALFPERIOD	ACLK = ~ACLK;

initial ACLK 		= 0;     // clock
initial
begin
	ARESETn 	= 0;     // reset
	repeat(10) @(posedge ACLK);
	ARESETn	= 1;
end

`include "Def.v"

parameter ID_WIDTH = ID_WID;
// Master 0 : interconnection signals
wire [ID_WIDTH-1:0]   AWIDM0;
wire [31:0]           AWADDRM0;
wire [3:0]            AWLENM0;
wire [2:0]            AWSIZEM0;
wire [1:0]            AWBURSTM0;
wire [1:0]            AWLOCKM0;
wire [3:0]            AWCACHEM0;
wire [2:0]            AWPROTM0;
wire                  AWVALIDM0;
wire                  AWREADYM0;

wire [ID_WIDTH-1:0]   WIDM0;
wire [DATA_WIDTH-1:0] WDATAM0;
wire [NUM_BYTE-1:0]   WSTRBM0;
wire                  WLASTM0;
wire                  WVALIDM0;
wire                  WREADYM0;

wire [ID_WIDTH-1:0]   BIDM0;
wire [1:0]            BRESPM0;
wire                  BVALIDM0;
wire                  BREADYM0;

wire [ID_WIDTH-1:0]   ARIDM0;
wire [31:0]           ARADDRM0;
wire [3:0]            ARLENM0;
wire [2:0]            ARSIZEM0;
wire [1:0]            ARBURSTM0;
wire [1:0]            ARLOCKM0;
wire [3:0]            ARCACHEM0;
wire [2:0]            ARPROTM0;
wire                  ARVALIDM0;
wire                  ARREADYM0;

wire [ID_WIDTH-1:0]   RIDM0;
wire [DATA_WIDTH-1:0] RDATAM0;
wire [1:0]            RRESPM0;
wire                  RLASTM0;
wire                  RVALIDM0;
wire                  RREADYM0;

// Master 1 : interconnection signals
wire [ID_WIDTH-1:0]   AWIDM1;
wire [31:0]           AWADDRM1;
wire [3:0]            AWLENM1;
wire [2:0]            AWSIZEM1;
wire [1:0]            AWBURSTM1;
wire [1:0]            AWLOCKM1;
wire [3:0]            AWCACHEM1;
wire [2:0]            AWPROTM1;
wire                  AWVALIDM1;
wire                  AWREADYM1;

wire [ID_WIDTH-1:0]   WIDM1;
wire [DATA_WIDTH-1:0] WDATAM1;
wire [NUM_BYTE-1:0]   WSTRBM1;
wire                  WLASTM1;
wire                  WVALIDM1;
wire                  WREADYM1;

wire [ID_WIDTH-1:0]   BIDM1;
wire [1:0]            BRESPM1;
wire                  BVALIDM1;
wire                  BREADYM1;

wire [ID_WIDTH-1:0]   ARIDM1;
wire [31:0]           ARADDRM1;
wire [3:0]            ARLENM1;
wire [2:0]            ARSIZEM1;
wire [1:0]            ARBURSTM1;
wire [1:0]            ARLOCKM1;
wire [3:0]            ARCACHEM1;
wire [2:0]            ARPROTM1;
wire                  ARVALIDM1;
wire                  ARREADYM1;

wire [ID_WIDTH-1:0]   RIDM1;
wire [DATA_WIDTH-1:0] RDATAM1;
wire [1:0]            RRESPM1;
wire                  RLASTM1;
wire                  RVALIDM1;
wire                  RREADYM1;

// Master 2 : interconnection signals
wire [ID_WIDTH-1:0]   AWIDM2;
wire [31:0]           AWADDRM2;
wire [3:0]            AWLENM2;
wire [2:0]            AWSIZEM2;
wire [1:0]            AWBURSTM2;
wire [1:0]            AWLOCKM2;
wire [3:0]            AWCACHEM2;
wire [2:0]            AWPROTM2;
wire                  AWVALIDM2;
wire                  AWREADYM2;

wire [ID_WIDTH-1:0]   WIDM2;
wire [DATA_WIDTH-1:0] WDATAM2;
wire [NUM_BYTE-1:0]   WSTRBM2;
wire                  WLASTM2;
wire                  WVALIDM2;
wire                  WREADYM2;

wire [ID_WIDTH-1:0]   BIDM2;
wire [1:0]            BRESPM2;
wire                  BVALIDM2;
wire                  BREADYM2;

wire [ID_WIDTH-1:0]   ARIDM2;
wire [31:0]           ARADDRM2;
wire [3:0]            ARLENM2;
wire [2:0]            ARSIZEM2;
wire [1:0]            ARBURSTM2;
wire [1:0]            ARLOCKM2;
wire [3:0]            ARCACHEM2;
wire [2:0]            ARPROTM2;
wire                  ARVALIDM2;
wire                  ARREADYM2;

wire [ID_WIDTH-1:0]   RIDM2;
wire [DATA_WIDTH-1:0] RDATAM2;
wire [1:0]            RRESPM2;
wire                  RLASTM2;
wire                  RVALIDM2;
wire                  RREADYM2;

// Master 3 : interconnection signals
wire [ID_WIDTH-1:0]   AWIDM3;
wire [31:0]           AWADDRM3;
wire [3:0]            AWLENM3;
wire [2:0]            AWSIZEM3;
wire [1:0]            AWBURSTM3;
wire [1:0]            AWLOCKM3;
wire [3:0]            AWCACHEM3;
wire [2:0]            AWPROTM3;
wire                  AWVALIDM3;
wire                  AWREADYM3;

wire [ID_WIDTH-1:0]   WIDM3;
wire [DATA_WIDTH-1:0] WDATAM3;
wire [NUM_BYTE-1:0]   WSTRBM3;
wire                  WLASTM3;
wire                  WVALIDM3;
wire                  WREADYM3;

wire [ID_WIDTH-1:0]   BIDM3;
wire [1:0]            BRESPM3;
wire                  BVALIDM3;
wire                  BREADYM3;

wire [ID_WIDTH-1:0]   ARIDM3;
wire [31:0]           ARADDRM3;
wire [3:0]            ARLENM3;
wire [2:0]            ARSIZEM3;
wire [1:0]            ARBURSTM3;
wire [1:0]            ARLOCKM3;
wire [3:0]            ARCACHEM3;
wire [2:0]            ARPROTM3;
wire                  ARVALIDM3;
wire                  ARREADYM3;

wire [ID_WIDTH-1:0]   RIDM3;
wire [DATA_WIDTH-1:0] RDATAM3;
wire [1:0]            RRESPM3;
wire                  RLASTM3;
wire                  RVALIDM3;
wire                  RREADYM3;

parameter SID_WIDTH = ID_WID+MASTER_WID;
// Slave 0 : interconnection signals
wire [SID_WIDTH-1:0]  AWIDS0;
wire [31:0]           AWADDRS0;
wire [3:0]            AWLENS0;
wire [2:0]            AWSIZES0;
wire [1:0]            AWBURSTS0;
wire [1:0]            AWLOCKS0;
wire [3:0]            AWCACHES0;
wire [2:0]            AWPROTS0;
wire                  AWVALIDS0;
wire                  AWREADYS0;

wire [SID_WIDTH-1:0]  WIDS0;
wire [DATA_WIDTH-1:0] WDATAS0;
wire [NUM_BYTE-1:0]   WSTRBS0;
wire                  WLASTS0;
wire                  WVALIDS0;
wire                  WREADYS0;

wire [SID_WIDTH-1:0]  BIDS0;
wire [1:0]            BRESPS0;
wire                  BVALIDS0;
wire                  BREADYS0;

wire [SID_WIDTH-1:0]  ARIDS0;
wire [31:0]           ARADDRS0;
wire [3:0]            ARLENS0;
wire [2:0]            ARSIZES0;
wire [1:0]            ARBURSTS0;
wire [1:0]            ARLOCKS0;
wire [3:0]            ARCACHES0;
wire [2:0]            ARPROTS0;
wire                  ARVALIDS0;
wire                  ARREADYS0;

wire [SID_WIDTH-1:0]  RIDS0;
wire [DATA_WIDTH-1:0] RDATAS0;
wire [1:0]            RRESPS0;
wire                  RLASTS0;
wire                  RVALIDS0;
wire                  RREADYS0;

// Slave 1 : interconnection signals
wire [SID_WIDTH-1:0]  AWIDS1;
wire [31:0]           AWADDRS1;
wire [3:0]            AWLENS1;
wire [2:0]            AWSIZES1;
wire [1:0]            AWBURSTS1;
wire [1:0]            AWLOCKS1;
wire [3:0]            AWCACHES1;
wire [2:0]            AWPROTS1;
wire                  AWVALIDS1;
wire                  AWREADYS1;

wire [SID_WIDTH-1:0]  WIDS1;
wire [DATA_WIDTH-1:0] WDATAS1;
wire [NUM_BYTE-1:0]   WSTRBS1;
wire                  WLASTS1;
wire                  WVALIDS1;
wire                  WREADYS1;

wire [SID_WIDTH-1:0]  BIDS1;
wire [1:0]            BRESPS1;
wire                  BVALIDS1;
wire                  BREADYS1;

wire [SID_WIDTH-1:0]  ARIDS1;
wire [31:0]           ARADDRS1;
wire [3:0]            ARLENS1;
wire [2:0]            ARSIZES1;
wire [1:0]            ARBURSTS1;
wire [1:0]            ARLOCKS1;
wire [3:0]            ARCACHES1;
wire [2:0]            ARPROTS1;
wire                  ARVALIDS1;
wire                  ARREADYS1;

wire [SID_WIDTH-1:0]  RIDS1;
wire [DATA_WIDTH-1:0] RDATAS1;
wire [1:0]            RRESPS1;
wire                  RLASTS1;
wire                  RVALIDS1;
wire                  RREADYS1;

// Slave 2 : interconnection signals
wire [SID_WIDTH-1:0]  AWIDS2;
wire [31:0]           AWADDRS2;
wire [3:0]            AWLENS2;
wire [2:0]            AWSIZES2;
wire [1:0]            AWBURSTS2;
wire [1:0]            AWLOCKS2;
wire [3:0]            AWCACHES2;
wire [2:0]            AWPROTS2;
wire                  AWVALIDS2;
wire                  AWREADYS2;

wire [SID_WIDTH-1:0]  WIDS2;
wire [DATA_WIDTH-1:0] WDATAS2;
wire [NUM_BYTE-1:0]   WSTRBS2;
wire                  WLASTS2;
wire                  WVALIDS2;
wire                  WREADYS2;

wire [SID_WIDTH-1:0]  BIDS2;
wire [1:0]            BRESPS2;
wire                  BVALIDS2;
wire                  BREADYS2;

wire [SID_WIDTH-1:0]  ARIDS2;
wire [31:0]           ARADDRS2;
wire [3:0]            ARLENS2;
wire [2:0]            ARSIZES2;
wire [1:0]            ARBURSTS2;
wire [1:0]            ARLOCKS2;
wire [3:0]            ARCACHES2;
wire [2:0]            ARPROTS2;
wire                  ARVALIDS2;
wire                  ARREADYS2;

wire [SID_WIDTH-1:0]  RIDS2;
wire [DATA_WIDTH-1:0] RDATAS2;
wire [1:0]            RRESPS2;
wire                  RLASTS2;
wire                  RVALIDS2;
wire                  RREADYS2;

// Slave 3 : interconnection signals
wire [SID_WIDTH-1:0]  AWIDS3;
wire [31:0]           AWADDRS3;
wire [3:0]            AWLENS3;
wire [2:0]            AWSIZES3;
wire [1:0]            AWBURSTS3;
wire [1:0]            AWLOCKS3;
wire [3:0]            AWCACHES3;
wire [2:0]            AWPROTS3;
wire                  AWVALIDS3;
wire                  AWREADYS3;

wire [SID_WIDTH-1:0]  WIDS3;
wire [DATA_WIDTH-1:0] WDATAS3;
wire [NUM_BYTE-1:0]   WSTRBS3;
wire                  WLASTS3;
wire                  WVALIDS3;
wire                  WREADYS3;

wire [SID_WIDTH-1:0]  BIDS3;
wire [1:0]            BRESPS3;
wire                  BVALIDS3;
wire                  BREADYS3;

wire [SID_WIDTH-1:0]  ARIDS3;
wire [31:0]           ARADDRS3;
wire [3:0]            ARLENS3;
wire [2:0]            ARSIZES3;
wire [1:0]            ARBURSTS3;
wire [1:0]            ARLOCKS3;
wire [3:0]            ARCACHES3;
wire [2:0]            ARPROTS3;
wire                  ARVALIDS3;
wire                  ARREADYS3;

wire [SID_WIDTH-1:0]  RIDS3;
wire [DATA_WIDTH-1:0] RDATAS3;
wire [1:0]            RRESPS3;
wire                  RLASTS3;
wire                  RVALIDS3;
wire                  RREADYS3;

// Slave 4 : interconnection signals
wire [SID_WIDTH-1:0]  AWIDS4;
wire [31:0]           AWADDRS4;
wire [3:0]            AWLENS4;
wire [2:0]            AWSIZES4;
wire [1:0]            AWBURSTS4;
wire [1:0]            AWLOCKS4;
wire [3:0]            AWCACHES4;
wire [2:0]            AWPROTS4;
wire                  AWVALIDS4;
wire                  AWREADYS4;

wire [SID_WIDTH-1:0]  WIDS4;
wire [DATA_WIDTH-1:0] WDATAS4;
wire [NUM_BYTE-1:0]   WSTRBS4;
wire                  WLASTS4;
wire                  WVALIDS4;
wire                  WREADYS4;

wire [SID_WIDTH-1:0]  BIDS4;
wire [1:0]            BRESPS4;
wire                  BVALIDS4;
wire                  BREADYS4;

wire [SID_WIDTH-1:0]  ARIDS4;
wire [31:0]           ARADDRS4;
wire [3:0]            ARLENS4;
wire [2:0]            ARSIZES4;
wire [1:0]            ARBURSTS4;
wire [1:0]            ARLOCKS4;
wire [3:0]            ARCACHES4;
wire [2:0]            ARPROTS4;
wire                  ARVALIDS4;
wire                  ARREADYS4;

wire [SID_WIDTH-1:0]  RIDS4;
wire [DATA_WIDTH-1:0] RDATAS4;
wire [1:0]            RRESPS4;
wire                  RLASTS4;
wire                  RVALIDS4;
wire                  RREADYS4;

// Slave 5 : interconnection signals
wire [SID_WIDTH-1:0]  AWIDS5;
wire [31:0]           AWADDRS5;
wire [3:0]            AWLENS5;
wire [2:0]            AWSIZES5;
wire [1:0]            AWBURSTS5;
wire [1:0]            AWLOCKS5;
wire [3:0]            AWCACHES5;
wire [2:0]            AWPROTS5;
wire                  AWVALIDS5;
wire                  AWREADYS5;

wire [SID_WIDTH-1:0]  WIDS5;
wire [DATA_WIDTH-1:0] WDATAS5;
wire [NUM_BYTE-1:0]   WSTRBS5;
wire                  WLASTS5;
wire                  WVALIDS5;
wire                  WREADYS5;

wire [SID_WIDTH-1:0]  BIDS5;
wire [1:0]            BRESPS5;
wire                  BVALIDS5;
wire                  BREADYS5;

wire [SID_WIDTH-1:0]  ARIDS5;
wire [31:0]           ARADDRS5;
wire [3:0]            ARLENS5;
wire [2:0]            ARSIZES5;
wire [1:0]            ARBURSTS5;
wire [1:0]            ARLOCKS5;
wire [3:0]            ARCACHES5;
wire [2:0]            ARPROTS5;
wire                  ARVALIDS5;
wire                  ARREADYS5;

wire [SID_WIDTH-1:0]  RIDS5;
wire [DATA_WIDTH-1:0] RDATAS5;
wire [1:0]            RRESPS5;
wire                  RLASTS5;
wire                  RVALIDS5;
wire                  RREADYS5;

// APB BUS signals
wire [31:0] PADDR;
wire PWRITE;
wire PSEL1;
wire PSEL2;
wire PSEL3;
wire PSEL4;
wire PSEL5;
wire PSEL6;
wire PSEL7;
wire PSELDMAC;
wire PENABLE;
wire [31:0] PRDATA0;
wire [31:0] PRDATA1;
wire [31:0] PRDATA2;
wire [31:0] PRDATA3;
wire [31:0] PRDATA4;
wire [31:0] PRDATA5;
wire [31:0] PRDATA6;
wire [31:0] PRDATA7;
wire [31:0] PRDATADMAC;
wire [31:0] PWDATA;
wire PREADY0;
wire PREADY1;
wire PREADY2;
wire PREADY3;
wire PREADY4;
wire PREADY5;
wire PREADY6;
wire PREADY7;
wire PREADYDMAC;

// DMA related signals
wire [15:0] DMACBREQ;         // DMA burst transfer request
wire [15:0] DMACLBREQ;        // DMA last burst transfer request
wire [15:0] DMACSREQ;         // DMA single transfer request
wire [15:0] DMACLSREQ;        // DMA last single transfer request
wire [15:0] DMACCLR;          // DMA request clear
wire [15:0] DMACTC;           // DMA terminal count
wire        DMACINTERR;       // DMA error interrupt request
wire        DMACINTTC;        // DMA terminal count interrupt request
wire        DMACINTR;         // DMA combined interrupt request

// AXI BUS
SBUS mainbus (
    .ACLK(ACLK),
    .ARESETn(ARESETn),

    //_______________________________________________________________
    //For Master 0
    //Write address channel
    .AWIDm02si0(AWIDM0),
    .AWADDRm02si0(AWADDRM0),
    .AWLENm02si0(AWLENM0),
    .AWSIZEm02si0(AWSIZEM0),
    .AWBURSTm02si0(AWBURSTM0),
    .AWLOCKm02si0(AWLOCKM0),
    .AWCACHEm02si0(AWCACHEM0),
    .AWPROTm02si0(AWPROTM0),

    .AWVALIDm02si0(AWVALIDM0),
    .AWREADYsi02m0(AWREADYM0),

    //Write data channel
    .WIDm02si0(WIDM0),
    .WDATAm02si0(WDATAM0),
    .WSTRBm02si0(WSTRBM0),
    .WLASTm02si0(WLASTM0),
    .WVALIDm02si0(WVALIDM0),
    .WREADYsi02m0(WREADYM0),

    //Write response channel
    .BIDsi02m0(BIDM0),
    .BRESPsi02m0(BRESPM0),
    .BVALIDsi02m0(BVALIDM0),
    .BREADYm02si0(BREADYM0),

    //_______________________________________________________________
    //For Master 1
    //Write address channel
    .AWIDm12si1(AWIDM1),
    .AWADDRm12si1(AWADDRM1),
    .AWLENm12si1(AWLENM1),
    .AWSIZEm12si1(AWSIZEM1),
    .AWBURSTm12si1(AWBURSTM1),
    .AWLOCKm12si1(AWLOCKM1),
    .AWCACHEm12si1(AWCACHEM1),
    .AWPROTm12si1(AWPROTM1),

    .AWVALIDm12si1(AWVALIDM1),
    .AWREADYsi12m1(AWREADYM1),

    //Write data channel
    .WIDm12si1(WIDM1),
    .WDATAm12si1(WDATAM1),
    .WSTRBm12si1(WSTRBM1),
    .WLASTm12si1(WLASTM1),
    .WVALIDm12si1(WVALIDM1),
    .WREADYsi12m1(WREADYM1),

    //Write response channel
    .BIDsi12m1(BIDM1),
    .BRESPsi12m1(BRESPM1),
    .BVALIDsi12m1(BVALIDM1),
    .BREADYm12si1(BREADYM1),

    //_______________________________________________________________
    //For Master 2
    //Write address channel
    .AWIDm22si2(AWIDM2),
    .AWADDRm22si2(AWADDRM2),
    .AWLENm22si2(AWLENM2),
    .AWSIZEm22si2(AWSIZEM2),
    .AWBURSTm22si2(AWBURSTM2),
    .AWLOCKm22si2(AWLOCKM2),
    .AWCACHEm22si2(AWCACHEM2),
    .AWPROTm22si2(AWPROTM2),

    .AWVALIDm22si2(AWVALIDM2),
    .AWREADYsi22m2(AWREADYM2),

    //Write data channel
    .WIDm22si2(WIDM2),
    .WDATAm22si2(WDATAM2),
    .WSTRBm22si2(WSTRBM2),
    .WLASTm22si2(WLASTM2),
    .WVALIDm22si2(WVALIDM2),
    .WREADYsi22m2(WREADYM2),

    //Write response channel
    .BIDsi22m2(BIDM2),
    .BRESPsi22m2(BRESPM2),
    .BVALIDsi22m2(BVALIDM2),
    .BREADYm22si2(BREADYM2),

    //_______________________________________________________________
    //For Master 3
    //Write address channel
    .AWIDm32si3(AWIDM3),
    .AWADDRm32si3(AWADDRM3),
    .AWLENm32si3(AWLENM3),
    .AWSIZEm32si3(AWSIZEM3),
    .AWBURSTm32si3(AWBURSTM3),
    .AWLOCKm32si3(AWLOCKM3),
    .AWCACHEm32si3(AWCACHEM3),
    .AWPROTm32si3(AWPROTM3),

    .AWVALIDm32si3(AWVALIDM3),
    .AWREADYsi32m3(AWREADYM3),

    //Write data channel
    .WIDm32si3(WIDM3),
    .WDATAm32si3(WDATAM3),
    .WSTRBm32si3(WSTRBM3),
    .WLASTm32si3(WLASTM3),
    .WVALIDm32si3(WVALIDM3),
    .WREADYsi32m3(WREADYM3),

    //Write response channel
    .BIDsi32m3(BIDM3),
    .BRESPsi32m3(BRESPM3),
    .BVALIDsi32m3(BVALIDM3),
    .BREADYm32si3(BREADYM3),

    //_______________________________________________________________
    
    //For Slave 0
    //Write address channel
    .AWIDmi02s0(AWIDS0),
    .AWADDRmi02s0(AWADDRS0),
    .AWLENmi02s0(AWLENS0),
    .AWSIZEmi02s0(AWSIZES0),
    .AWBURSTmi02s0(AWBURSTS0),
    .AWLOCKmi02s0(AWLOCKS0),
    .AWCACHEmi02s0(AWCACHES0),
    .AWPROTmi02s0(AWPROTS0),

    .AWVALIDmi02s0(AWVALIDS0),
    .AWREADYs02mi0(AWREADYS0),

    //Write data channel
    .WIDmi02s0(WIDS0),
    .WDATAmi02s0(WDATAS0),
    .WSTRBmi02s0(WSTRBS0),
    .WLASTmi02s0(WLASTS0),
    .WVALIDmi02s0(WVALIDS0),
    .WREADYs02mi0(WREADYS0),

    //Write response channel
    .BIDs02mi0(BIDS0),
    .BRESPs02mi0(BRESPS0),
    .BVALIDs02mi0(BVALIDS0),
    .BREADYmi02s0(BREADYS0),


    //_______________________________________________________________

    //For Slave 1
    //Write address channel
    .AWIDmi12s1(AWIDS1),
    .AWADDRmi12s1(AWADDRS1),
    .AWLENmi12s1(AWLENS1),
    .AWSIZEmi12s1(AWSIZES1),
    .AWBURSTmi12s1(AWBURSTS1),
    .AWLOCKmi12s1(AWLOCKS1),
    .AWCACHEmi12s1(AWCACHES1),
    .AWPROTmi12s1(AWPROTS1),

    .AWVALIDmi12s1(AWVALIDS1),
    .AWREADYs12mi1(AWREADYS1),

    //Write data channel
    .WIDmi12s1(WIDS1),
    .WDATAmi12s1(WDATAS1),
    .WSTRBmi12s1(WSTRBS1),
    .WLASTmi12s1(WLASTS1),
    .WVALIDmi12s1(WVALIDS1),
    .WREADYs12mi1(WREADYS1),

    //Write response channel
    .BIDs12mi1(BIDS1),
    .BRESPs12mi1(BRESPS1),
    .BVALIDs12mi1(BVALIDS1),
    .BREADYmi12s1(BREADYS1),

    //_______________________________________________________________


    //For Slave 2
    //Write address channel
    .AWIDmi22s2(AWIDS2),
    .AWADDRmi22s2(AWADDRS2),
    .AWLENmi22s2(AWLENS2),
    .AWSIZEmi22s2(AWSIZES2),
    .AWBURSTmi22s2(AWBURSTS2),
    .AWLOCKmi22s2(AWLOCKS2),
    .AWCACHEmi22s2(AWCACHES2),
    .AWPROTmi22s2(AWPROTS2),

    .AWVALIDmi22s2(AWVALIDS2),
    .AWREADYs22mi2(AWREADYS2),

    //Write data channel
    .WIDmi22s2(WIDS2),
    .WDATAmi22s2(WDATAS2),
    .WSTRBmi22s2(WSTRBS2),
    .WLASTmi22s2(WLASTS2),
    .WVALIDmi22s2(WVALIDS2),
    .WREADYs22mi2(WREADYS2),

    //Write response channel
    .BIDs22mi2(BIDS2),
    .BRESPs22mi2(BRESPS2),
    .BVALIDs22mi2(BVALIDS2),
    .BREADYmi22s2(BREADYS2),

    
    //_______________________________________________________________
    
    
    //For Slave 3
    //Write address channel
    .AWIDmi32s3(AWIDS3),
    .AWADDRmi32s3(AWADDRS3),
    .AWLENmi32s3(AWLENS3),
    .AWSIZEmi32s3(AWSIZES3),
    .AWBURSTmi32s3(AWBURSTS3),
    .AWLOCKmi32s3(AWLOCKS3),
    .AWCACHEmi32s3(AWCACHES3),
    .AWPROTmi32s3(AWPROTS3),

    .AWVALIDmi32s3(AWVALIDS3),
    .AWREADYs32mi3(AWREADYS3),

    //Write data channel
    .WIDmi32s3(WIDS3),
    .WDATAmi32s3(WDATAS3),
    .WSTRBmi32s3(WSTRBS3),
    .WLASTmi32s3(WLASTS3),
    .WVALIDmi32s3(WVALIDS3),
    .WREADYs32mi3(WREADYS3),

    //Write response channel
    .BIDs32mi3(BIDS3),
    .BRESPs32mi3(BRESPS3),
    .BVALIDs32mi3(BVALIDS3),
    .BREADYmi32s3(BREADYS3),

    
    //_______________________________________________________________
    
    //For Slave 4
    //Write address channel
    .AWIDmi42s4(AWIDS4),
    .AWADDRmi42s4(AWADDRS4),
    .AWLENmi42s4(AWLENS4),
    .AWSIZEmi42s4(AWSIZES4),
    .AWBURSTmi42s4(AWBURSTS4),
    .AWLOCKmi42s4(AWLOCKS4),
    .AWCACHEmi42s4(AWCACHES4),
    .AWPROTmi42s4(AWPROTS4),

    .AWVALIDmi42s4(AWVALIDS4),
    .AWREADYs42mi4(AWREADYS4),

    //Write data channel
    .WIDmi42s4(WIDS4),
    .WDATAmi42s4(WDATAS4),
    .WSTRBmi42s4(WSTRBS4),
    .WLASTmi42s4(WLASTS4),
    .WVALIDmi42s4(WVALIDS4),
    .WREADYs42mi4(WREADYS4),

    //Write response channel
    .BIDs42mi4(BIDS4),
    .BRESPs42mi4(BRESPS4),
    .BVALIDs42mi4(BVALIDS4),
    .BREADYmi42s4(BREADYS4),

    //_______________________________________________________________
    
    
    //For Slave 5
    //Write address channel
    .AWIDmi52s5(AWIDS5),
    .AWADDRmi52s5(AWADDRS5),
    .AWLENmi52s5(AWLENS5),
    .AWSIZEmi52s5(AWSIZES5),
    .AWBURSTmi52s5(AWBURSTS5),
    .AWLOCKmi52s5(AWLOCKS5),
    .AWCACHEmi52s5(AWCACHES5),
    .AWPROTmi52s5(AWPROTS5),

    .AWVALIDmi52s5(AWVALIDS5),
    .AWREADYs52mi5(AWREADYS5),

    //Write data channel
    .WIDmi52s5(WIDS5),
    .WDATAmi52s5(WDATAS5),
    .WSTRBmi52s5(WSTRBS5),
    .WLASTmi52s5(WLASTS5),
    .WVALIDmi52s5(WVALIDS5),
    .WREADYs52mi5(WREADYS5),

    //Write response channel
    .BIDs52mi5(BIDS5),
    .BRESPs52mi5(BRESPS5),
    .BVALIDs52mi5(BVALIDS5),
    .BREADYmi52s5(BREADYS5),

    //_______________________________________________________________

    //_______________________________________________________________
    //For Master 0
    //Read address channel
    .ARIDm02si0(ARIDM0),
    .ARADDRm02si0(ARADDRM0),
    .ARLENm02si0(ARLENM0),
    .ARSIZEm02si0(ARSIZEM0),
    .ARBURSTm02si0(ARBURSTM0),
    .ARLOCKm02si0(ARLOCKM0),
    .ARCACHEm02si0(ARCACHEM0),
    .ARPROTm02si0(ARPROTM0),

    .ARVALIDm02si0(ARVALIDM0),
    .ARREADYsi02m0(ARREADYM0),

    //Read data channel
    .RIDsi02m0(RIDM0),
    .RRESPsi02m0(RRESPM0),
    .RDATAsi02m0(RDATAM0),
    .RLASTsi02m0(RLASTM0),
    .RVALIDsi02m0(RVALIDM0),
    .RREADYm02si0(RREADYM0),


    //_______________________________________________________________
    //For Master 1
    //Read address channel
    .ARIDm12si1(ARIDM1),
    .ARADDRm12si1(ARADDRM1),
    .ARLENm12si1(ARLENM1),
    .ARSIZEm12si1(ARSIZEM1),
    .ARBURSTm12si1(ARBURSTM1),
    .ARLOCKm12si1(ARLOCKM1),
    .ARCACHEm12si1(ARCACHEM1),
    .ARPROTm12si1(ARPROTM1),

    .ARVALIDm12si1(ARVALIDM1),
    .ARREADYsi12m1(ARREADYM1),

    //Read data channel
    .RIDsi12m1(RIDM1),
    .RRESPsi12m1(RRESPM1),
    .RDATAsi12m1(RDATAM1),
    .RLASTsi12m1(RLASTM1),
    .RVALIDsi12m1(RVALIDM1),
    .RREADYm12si1(RREADYM1),

    //_______________________________________________________________
    //For Master 2
    //Read address channel
    .ARIDm22si2(ARIDM2),
    .ARADDRm22si2(ARADDRM2),
    .ARLENm22si2(ARLENM2),
    .ARSIZEm22si2(ARSIZEM2),
    .ARBURSTm22si2(ARBURSTM2),
    .ARLOCKm22si2(ARLOCKM2),
    .ARCACHEm22si2(ARCACHEM2),
    .ARPROTm22si2(ARPROTM2),

    .ARVALIDm22si2(ARVALIDM2),
    .ARREADYsi22m2(ARREADYM2),

    //Read data channel
    .RIDsi22m2(RIDM2),
    .RRESPsi22m2(RRESPM2),
    .RDATAsi22m2(RDATAM2),
    .RLASTsi22m2(RLASTM2),
    .RVALIDsi22m2(RVALIDM2),
    .RREADYm22si2(RREADYM2),

    //_______________________________________________________________
    //For Master 3
    //Read address channel
    .ARIDm32si3(ARIDM3),
    .ARADDRm32si3(ARADDRM3),
    .ARLENm32si3(ARLENM3),
    .ARSIZEm32si3(ARSIZEM3),
    .ARBURSTm32si3(ARBURSTM3),
    .ARLOCKm32si3(ARLOCKM3),
    .ARCACHEm32si3(ARCACHEM3),
    .ARPROTm32si3(ARPROTM3),

    .ARVALIDm32si3(ARVALIDM3),
    .ARREADYsi32m3(ARREADYM3),

    //Read data channel
    .RIDsi32m3(RIDM3),
    .RRESPsi32m3(RRESPM3),
    .RDATAsi32m3(RDATAM3),
    .RLASTsi32m3(RLASTM3),
    .RVALIDsi32m3(RVALIDM3),
    .RREADYm32si3(RREADYM3),

    //_______________________________________________________________
    //For Slave 0
    //Read address channel
    .ARIDmi02s0(ARIDS0),
    .ARADDRmi02s0(ARADDRS0),
    .ARLENmi02s0(ARLENS0),
    .ARSIZEmi02s0(ARSIZES0),
    .ARBURSTmi02s0(ARBURSTS0),
    .ARLOCKmi02s0(ARLOCKS0),
    .ARCACHEmi02s0(ARCACHES0),
    .ARPROTmi02s0(ARPROTS0),

    .ARVALIDmi02s0(ARVALIDS0),
    .ARREADYs02mi0(ARREADYS0),

    //Read data channel
    .RIDs02mi0(RIDS0),
    .RRESPs02mi0(RRESPS0),
    .RDATAs02mi0(RDATAS0),
    .RLASTs02mi0(RLASTS0),
    .RVALIDs02mi0(RVALIDS0),
    .RREADYmi02s0(RREADYS0),


    //_______________________________________________________________

    //For Slave 1
    //Read address channel
    .ARIDmi12s1(ARIDS1),
    .ARADDRmi12s1(ARADDRS1),
    .ARLENmi12s1(ARLENS1),
    .ARSIZEmi12s1(ARSIZES1),
    .ARBURSTmi12s1(ARBURSTS1),
    .ARLOCKmi12s1(ARLOCKS1),
    .ARCACHEmi12s1(ARCACHES1),
    .ARPROTmi12s1(ARPROTS1),

    .ARVALIDmi12s1(ARVALIDS1),
    .ARREADYs12mi1(ARREADYS1),

    //Read data channel
    .RIDs12mi1(RIDS1),
    .RRESPs12mi1(RRESPS1),
    .RDATAs12mi1(RDATAS1),
    .RLASTs12mi1(RLASTS1),
    .RVALIDs12mi1(RVALIDS1),
    .RREADYmi12s1(RREADYS1),

    //_______________________________________________________________


    //For Slave 2
    //Read address channel
    .ARIDmi22s2(ARIDS2),
    .ARADDRmi22s2(ARADDRS2),
    .ARLENmi22s2(ARLENS2),
    .ARSIZEmi22s2(ARSIZES2),
    .ARBURSTmi22s2(ARBURSTS2),
    .ARLOCKmi22s2(ARLOCKS2),
    .ARCACHEmi22s2(ARCACHES2),
    .ARPROTmi22s2(ARPROTS2),

    .ARVALIDmi22s2(ARVALIDS2),
    .ARREADYs22mi2(ARREADYS2),

    //Read data channel
    .RIDs22mi2(RIDS2),
    .RRESPs22mi2(RRESPS2),
    .RDATAs22mi2(RDATAS2),
    .RLASTs22mi2(RLASTS2),
    .RVALIDs22mi2(RVALIDS2),
    .RREADYmi22s2(RREADYS2),

    //_______________________________________________________________
    
    
    //For Slave 3
    //Read address channel
    .ARIDmi32s3(ARIDS3),
    .ARADDRmi32s3(ARADDRS3),
    .ARLENmi32s3(ARLENS3),
    .ARSIZEmi32s3(ARSIZES3),
    .ARBURSTmi32s3(ARBURSTS3),
    .ARLOCKmi32s3(ARLOCKS3),
    .ARCACHEmi32s3(ARCACHES3),
    .ARPROTmi32s3(ARPROTS3),

    .ARVALIDmi32s3(ARVALIDS3),
    .ARREADYs32mi3(ARREADYS3),

    //Read data channel
    .RIDs32mi3(RIDS3),
    .RRESPs32mi3(RRESPS3),
    .RDATAs32mi3(RDATAS3),
    .RLASTs32mi3(RLASTS3),
    .RVALIDs32mi3(RVALIDS3),
    .RREADYmi32s3(RREADYS3),

    
    //_______________________________________________________________
    
    //For Slave 4
    //Read address channel
    .ARIDmi42s4(ARIDS4),
    .ARADDRmi42s4(ARADDRS4),
    .ARLENmi42s4(ARLENS4),
    .ARSIZEmi42s4(ARSIZES4),
    .ARBURSTmi42s4(ARBURSTS4),
    .ARLOCKmi42s4(ARLOCKS4),
    .ARCACHEmi42s4(ARCACHES4),
    .ARPROTmi42s4(ARPROTS4),

    .ARVALIDmi42s4(ARVALIDS4),
    .ARREADYs42mi4(ARREADYS4),

    //Read data channel
    .RIDs42mi4(RIDS4),
    .RRESPs42mi4(RRESPS4),
    .RDATAs42mi4(RDATAS4),
    .RLASTs42mi4(RLASTS4),
    .RVALIDs42mi4(RVALIDS4),
    .RREADYmi42s4(RREADYS4),

    //_______________________________________________________________
    
    
    //For Slave 5
    //Read address channel
    .ARIDmi52s5(ARIDS5),
    .ARADDRmi52s5(ARADDRS5),
    .ARLENmi52s5(ARLENS5),
    .ARSIZEmi52s5(ARSIZES5),
    .ARBURSTmi52s5(ARBURSTS5),
    .ARLOCKmi52s5(ARLOCKS5),
    .ARCACHEmi52s5(ARCACHES5),
    .ARPROTmi52s5(ARPROTS5),

    .ARVALIDmi52s5(ARVALIDS5),
    .ARREADYs52mi5(ARREADYS5),

    //Read data channel
    .RIDs52mi5(RIDS5),
    .RRESPs52mi5(RRESPS5),
    .RDATAs52mi5(RDATAS5),
    .RLASTs52mi5(RLASTS5),
    .RVALIDs52mi5(RVALIDS5),
    .RREADYmi52s5(RREADYS5)

    //_______________________________________________________________
);

// Master 0 : Test Master
TestMaster TestMaster
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWIDM0),
		.AWADDR(AWADDRM0),
		.AWLEN(AWLENM0),
		.AWSIZE(AWSIZEM0),
		.AWBURST(AWBURSTM0),
		.AWLOCK(AWLOCKM0),
		.AWCACHE(AWCACHEM0),
		.AWPROT(AWPROTM0),
		.AWVALID(AWVALIDM0),
		.AWREADY(AWREADYM0),

		.WID(WIDM0),
		.WDATA(WDATAM0),
		.WSTRB(WSTRBM0),
		.WLAST(WLASTM0),
		.WVALID(WVALIDM0),
		.WREADY(WREADYM0),

		.BID(BIDM0),
		.BRESP(BRESPM0),
		.BVALID(BVALIDM0),
		.BREADY(BREADYM0),

		.ARID(ARIDM0),
		.ARADDR(ARADDRM0),
		.ARLEN(ARLENM0),
		.ARSIZE(ARSIZEM0),
		.ARBURST(ARBURSTM0),
		.ARLOCK(ARLOCKM0),
		.ARCACHE(ARCACHEM0),
		.ARPROT(ARPROTM0),
		.ARVALID(ARVALIDM0),
		.ARREADY(ARREADYM0),

		.RID(RIDM0),
		.RDATA(RDATAM0),
		.RRESP(RRESPM0),
		.RLAST(RLASTM0),
		.RVALID(RVALIDM0),
		.RREADY(RREADYM0)
);

// Master 1 : AXIDMA IF1
// Master 2 : AXIDMA IF2
Dmac1Ch Dmac1(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.PADDR(PADDR[4:2]),
		.PWRITE(PWRITE),
		.PSEL(PSELDMAC),
		.PENABLE(PENABLE),
		.PRDATA(PRDATADMAC),
		.PWDATA(PWDATA),

		.AWADDR(AWADDRM1),
		.AWLEN(AWLENM1),
		.AWSIZE(AWSIZEM1),
		.AWBURST(AWBURSTM1),
//		.AWLOCK(AWLOCKM1),
//		.AWCACHE(AWCACHEM1),
//		.AWPROT(AWPROTM1),
		.AWVALID(AWVALIDM1),
		.AWREADY(AWREADYM1),
	
		.WDATA(WDATAM1),
		.WSTRB(WSTRBM1),
		.WLAST(WLASTM1),
		.WVALID(WVALIDM1),
		.WREADY(WREADYM1),

		.BRESP(BRESPM1),
		.BVALID(BVALIDM1),
		.BREADY(BREADYM1),

		.ARADDR(ARADDRM1),
		.ARLEN(ARLENM1),
		.ARSIZE(ARSIZEM1),
		.ARBURST(ARBURSTM1),
//		.ARLOCK(ARLOCKM1),
//		.ARCACHE(ARCACHEM1),
//		.ARPROT(ARPROTM1),
		.ARVALID(ARVALIDM1),
		.ARREADY(ARREADYM1),

		.RDATA(RDATAM1),
		.RRESP(RRESPM1),
		.RLAST(RLASTM1),
		.RVALID(RVALIDM1),
		.RREADY(RREADYM1),

/*
		.AWADDR2(AWADDRM2),
		.AWLEN2(AWLENM2),
		.AWSIZE2(AWSIZEM2),
		.AWBURST2(AWBURSTM2),
		.AWLOCK2(AWLOCKM2),
		.AWCACHE2(AWCACHEM2),
		.AWPROT2(AWPROTM2),
		.AWVALID2(AWVALIDM2),
		.AWREADY2(AWREADYM2),
	
		.WDATA2(WDATAM2),
		.WSTRB2(WSTRBM2),
		.WLAST2(WLASTM2),
		.WVALID2(WVALIDM2),
		.WREADY2(WREADYM2),

		.BRESP2(BRESPM2),
		.BVALID2(BVALIDM2),
		.BREADY2(BREADYM2),

		.ARADDR2(ARADDRM2),
		.ARLEN2(ARLENM2),
		.ARSIZE2(ARSIZEM2),
		.ARBURST2(ARBURSTM2),
		.ARLOCK2(ARLOCKM2),
		.ARCACHE2(ARCACHEM2),
		.ARPROT2(ARPROTM2),
		.ARVALID2(ARVALIDM2),
		.ARREADY2(ARREADYM2),

		.RDATA2(RDATAM2),
		.RRESP2(RRESPM2),
		.RLAST2(RLASTM2),
		.RVALID2(RVALIDM2),
		.RREADY2(RREADYM2),

		.DMACBREQ(DMACBREQ),
		.DMACLBREQ(DMACLBREQ),
		.DMACSREQ(DMACSREQ),
		.DMACLSREQ(DMACLSREQ),

		.DMACCLR(DMACCLR),
		.DMACTC(DMACTC),
		.DMACINTERR(DMACINTERR),
		.DMACINTTC(DMACINTTC),
		.DMACINTR(DMACINTR)
*/

		.DMAReq(DMACBREQ[0]),
		.DMAAck(DMACCLR[0]),
		.Interrupt(DMACINTR)
);

assign PREADYDMAC = 1;
// unused AXI Signal
assign AWIDM1 = 0;
assign AWLOCKM1 = 0;
assign AWCACHEM1 = 0;
assign AWPROTM1 = 0;
assign ARIDM1 = 0;
assign WIDM1 = 0;
//assign AWIDM2 = 0;
//assign ARIDM2 = 0;
//assign WIDM2 = 0;

// Master 2 : Not connected
assign AWIDM2 = 0;
assign AWADDRM2 = 0;
assign AWLENM2 = 0;
assign AWSIZEM2 = 0;
assign AWBURSTM2 = 0;
assign AWLOCKM2 = 0;
assign AWCACHEM2 = 0;
assign AWPROTM2 = 0;
assign AWVALIDM2 = 0;

assign WIDM2 = 0;
assign WDATAM2 = 0;
assign WSTRBM2 = 0;
assign WLASTM2 = 0;
assign WVALIDM2 = 0;

assign BREADYM2 = 0;
 
assign ARIDM2 = 0;
assign ARADDRM2 = 0;
assign ARLENM2 = 0;
assign ARSIZEM2 = 0;
assign ARBURSTM2 = 0;
assign ARLOCKM2 = 0;
assign ARCACHEM2 = 0;
assign ARPROTM2 = 0;
assign ARVALIDM2 = 0;

assign RREADYM2 = 0;

// Master 3 : Not connected
assign AWIDM3 = 0;
assign AWADDRM3 = 0;
assign AWLENM3 = 0;
assign AWSIZEM3 = 0;
assign AWBURSTM3 = 0;
assign AWLOCKM3 = 0;
assign AWCACHEM3 = 0;
assign AWPROTM3 = 0;
assign AWVALIDM3 = 0;

assign WIDM3 = 0;
assign WDATAM3 = 0;
assign WSTRBM3 = 0;
assign WLASTM3 = 0;
assign WVALIDM3 = 0;

assign BREADYM3 = 0;
 
assign ARIDM3 = 0;
assign ARADDRM3 = 0;
assign ARLENM3 = 0;
assign ARSIZEM3 = 0;
assign ARBURSTM3 = 0;
assign ARLOCKM3 = 0;
assign ARCACHEM3 = 0;
assign ARPROTM3 = 0;
assign ARVALIDM3 = 0;

assign RREADYM3 = 0;


// Slave 0 : Internal SRAM
wire [31:0] MEMADDR;
wire [31:0] MEMRDATA;
wire [31:0] MEMWDATA;
wire        MEMCEn;
wire [3:0]  MEMWEn;
IntSRAMController #(.RID_WIDTH(SID_WIDTH), .WID_WIDTH(SID_WIDTH)) IntSRAMController
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWIDS0),
		.AWADDR(AWADDRS0),
		.AWLEN(AWLENS0),
		.AWSIZE(AWSIZES0),
		.AWBURST(AWBURSTS0),
		.AWVALID(AWVALIDS0),
		.AWREADY(AWREADYS0),

		.WID(WIDS0),
		.WDATA(WDATAS0),
		.WSTRB(WSTRBS0),
		.WLAST(WLASTS0),
		.WVALID(WVALIDS0),
		.WREADY(WREADYS0),

		.BID(BIDS0),
		.BRESP(BRESPS0),
		.BVALID(BVALIDS0),
		.BREADY(BREADYS0),

		.ARID(ARIDS0),
		.ARADDR(ARADDRS0),
		.ARLEN(ARLENS0),
		.ARSIZE(ARSIZES0),
		.ARBURST(ARBURSTS0),
		.ARVALID(ARVALIDS0),
		.ARREADY(ARREADYS0),

		// Read Data Channel
		.RID(RIDS0),
		.RDATA(RDATAS0),
		.RRESP(RRESPS0),
		.RLAST(RLASTS0),
		.RVALID(RVALIDS0),
		.RREADY(RREADYS0),

		.MEMADDR(MEMADDR[29:0]),
		.MEMCEn(MEMCEn),
		.MEMWEn(MEMWEn),
		.MEMRDATA(MEMRDATA),
		.MEMWDATA(MEMWDATA)
);

SSRAM32bit #(12) SRAM
(
		.CLK(ACLK),
		.ADDR(MEMADDR[11:0]),
		.CEn(MEMCEn),
		.WEn(MEMWEn),
		.RDATA(MEMRDATA),
		.WDATA(MEMWDATA)
);

// Slave 1 : AXI2APB Bridge
AXI2APBBridge #(.RID_WIDTH(SID_WIDTH), .WID_WIDTH(SID_WIDTH)) APBIf
(
		.ACLK(ACLK),
		.ARESETn(ARESETn),

		.AWID(AWIDS1),
		.AWADDR(AWADDRS1),
		.AWLEN(AWLENS1),
		.AWSIZE(AWSIZES1),
		.AWBURST(AWBURSTS1),
		.AWVALID(AWVALIDS1),
		.AWREADY(AWREADYS1),

		.WID(WIDS1),
		.WDATA(WDATAS1),
		.WLAST(WLASTS1),
		.WVALID(WVALIDS1),
		.WREADY(WREADYS1),

		.BID(BIDS1),
		.BRESP(BRESPS1),
		.BVALID(BVALIDS1),
		.BREADY(BREADYS1),

		.ARID(ARIDS1),
		.ARADDR(ARADDRS1),
		.ARLEN(ARLENS1),
		.ARSIZE(ARSIZES1),
		.ARBURST(ARBURSTS1),
		.ARVALID(ARVALIDS1),
		.ARREADY(ARREADYS1),

		.RID(RIDS1),
		.RDATA(RDATAS1),
		.RRESP(RRESPS1),
		.RLAST(RLASTS1),
		.RVALID(RVALIDS1),
		.RREADY(RREADYS1),

//	APB Interface
		.PADDR(PADDR),
		.PWRITE(PWRITE),
		.PSEL0(PSEL0),
		.PSEL1(PSEL1),
		.PSEL2(PSEL2),
		.PSEL3(PSEL3),
		.PSEL4(PSEL4),
		.PSEL5(PSEL5),
		.PSEL6(PSEL6),
		.PSEL7(PSEL7),
		.PSEL8(PSELDMAC),
		.PENABLE(PENABLE),
		.PRDATA0(PRDATA0),
		.PRDATA1(PRDATA1),
		.PRDATA2(PRDATA2),
		.PRDATA3(PRDATA3),
		.PRDATA4(PRDATA4),
		.PRDATA5(PRDATA5),
		.PRDATA6(PRDATA6),
		.PRDATA7(PRDATA7),
		.PRDATA8(PRDATADMAC),
		.PREADY0(PREADY0),
		.PREADY1(PREADY1),
		.PREADY2(PREADY2),
		.PREADY3(PREADY3),
		.PREADY4(PREADY4),
		.PREADY5(PREADY5),
		.PREADY6(PREADY6),
		.PREADY7(PREADY7),
		.PREADY8(PREADYDMAC),
		.PWDATA(PWDATA)
);

// Slave 2 : Default Slave
DefaultSlave #(.RID_WIDTH(SID_WIDTH), .WID_WIDTH(SID_WIDTH)) DefaultSlave2
(
		.ACLK     , 
		.ARESETn  , 

		.AWID(AWIDS2),
		.AWADDR(AWADDRS2),
		.AWLEN(AWLENS2),
		.AWSIZE(AWSIZES2),
		.AWBURST(AWBURSTS2),
		.AWVALID(AWVALIDS2),
		.AWREADY(AWREADYS2),

		.WID(WIDS2),
		.WLAST(WLASTS2),
		.WVALID(WVALIDS2),
		.WREADY(WREADYS2),

		.BID(BIDS2),
		.BRESP(BRESPS2),
		.BVALID(BVALIDS2),
		.BREADY(BREADYS2),

		.ARID(ARIDS2),
		.ARADDR(ARADDRS2),
		.ARLEN(ARLENS2),
		.ARSIZE(ARSIZES2),
		.ARBURST(ARBURSTS2),
		.ARVALID(ARVALIDS2),
		.ARREADY(ARREADYS2),

		.RID(RIDS2),
		.RDATA(RDATAS2),
		.RRESP(RRESPS2),
		.RLAST(RLASTS2),
		.RVALID(RVALIDS2),
		.RREADY(RREADYS2)
);

// Slave 3 : Default Slave
DefaultSlave #(.RID_WIDTH(SID_WIDTH), .WID_WIDTH(SID_WIDTH)) DefaultSlave3
(
		.ACLK     , 
		.ARESETn  , 

		.AWID(AWIDS3),
		.AWADDR(AWADDRS3),
		.AWLEN(AWLENS3),
		.AWSIZE(AWSIZES3),
		.AWBURST(AWBURSTS3),
		.AWVALID(AWVALIDS3),
		.AWREADY(AWREADYS3),

		.WID(WIDS3),
		.WLAST(WLASTS3),
		.WVALID(WVALIDS3),
		.WREADY(WREADYS3),

		.BID(BIDS3),
		.BRESP(BRESPS3),
		.BVALID(BVALIDS3),
		.BREADY(BREADYS3),

		.ARID(ARIDS3),
		.ARADDR(ARADDRS3),
		.ARLEN(ARLENS3),
		.ARSIZE(ARSIZES3),
		.ARBURST(ARBURSTS3),
		.ARVALID(ARVALIDS3),
		.ARREADY(ARREADYS3),

		.RID(RIDS3),
		.RDATA(RDATAS3),
		.RRESP(RRESPS3),
		.RLAST(RLASTS3),
		.RVALID(RVALIDS3),
		.RREADY(RREADYS3)
);

// Slave 4 : Default Slave
DefaultSlave #(.RID_WIDTH(SID_WIDTH), .WID_WIDTH(SID_WIDTH)) DefaultSlave4
(
		.ACLK     , 
		.ARESETn  , 

		.AWID(AWIDS4),
		.AWADDR(AWADDRS4),
		.AWLEN(AWLENS4),
		.AWSIZE(AWSIZES4),
		.AWBURST(AWBURSTS4),
		.AWVALID(AWVALIDS4),
		.AWREADY(AWREADYS4),

		.WID(WIDS4),
		.WLAST(WLASTS4),
		.WVALID(WVALIDS4),
		.WREADY(WREADYS4),

		.BID(BIDS4),
		.BRESP(BRESPS4),
		.BVALID(BVALIDS4),
		.BREADY(BREADYS4),

		.ARID(ARIDS4),
		.ARADDR(ARADDRS4),
		.ARLEN(ARLENS4),
		.ARSIZE(ARSIZES4),
		.ARBURST(ARBURSTS4),
		.ARVALID(ARVALIDS4),
		.ARREADY(ARREADYS4),

		.RID(RIDS4),
		.RDATA(RDATAS4),
		.RRESP(RRESPS4),
		.RLAST(RLASTS4),
		.RVALID(RVALIDS4),
		.RREADY(RREADYS4)
);

// Slave 5 : Default Slave
DefaultSlave #(.RID_WIDTH(SID_WIDTH), .WID_WIDTH(SID_WIDTH)) DefaultSlave5
(
		.ACLK     , 
		.ARESETn  , 

		.AWID(AWIDS5),
		.AWADDR(AWADDRS5),
		.AWLEN(AWLENS5),
		.AWSIZE(AWSIZES5),
		.AWBURST(AWBURSTS5),
		.AWVALID(AWVALIDS5),
		.AWREADY(AWREADYS5),

		.WID(WIDS5),
		.WLAST(WLASTS5),
		.WVALID(WVALIDS5),
		.WREADY(WREADYS5),

		.BID(BIDS5),
		.BRESP(BRESPS5),
		.BVALID(BVALIDS5),
		.BREADY(BREADYS5),

		.ARID(ARIDS5),
		.ARADDR(ARADDRS5),
		.ARLEN(ARLENS5),
		.ARSIZE(ARSIZES5),
		.ARBURST(ARBURSTS5),
		.ARVALID(ARVALIDS5),
		.ARREADY(ARREADYS5),

		.RID(RIDS5),
		.RDATA(RDATAS5),
		.RRESP(RRESPS5),
		.RLAST(RLASTS5),
		.RVALID(RVALIDS5),
		.RREADY(RREADYS5)
);

// APB network
// APB Slave 0 : DMAPeri0(SINK)
DMAPeri #(.STREAM_SINK(1), .DATA_SIZE(0/*BYTE*/)) DMAPeri0
(
		.PCLK(ACLK),
		.PRESETn(ARESETn),
		.PADDR(PADDR[2]),
		.PWRITE(PWRITE),
		.PSEL(PSEL0),
		.PENABLE(PENABLE),
		.PRDATA(PRDATA0),
		.PWDATA(PWDATA),

		.DMA_REQ(DMACBREQ[0]),
		.DMA_ACK(DMACCLR[0])
);
assign PREADY0 = 1'b1;

// APB Slave 1 : DMAPeri0(SINK)
DMAPeri #(.STREAM_SINK(1)) DMAPeri1
(
		.PCLK(ACLK),
		.PRESETn(ARESETn),
		.PADDR(PADDR[2]),
		.PWRITE(PWRITE),
		.PSEL(PSEL1),
		.PENABLE(PENABLE),
		.PRDATA(PRDATA1),
		.PWDATA(PWDATA),

		.DMA_REQ(DMACBREQ[1]),
		.DMA_ACK(DMACCLR[1])
);
assign PREADY1 = 1'b1;

// APB Slave 2 : DMAPeri0(SINK)
DMAPeri #(.STREAM_SINK(1)) DMAPeri2
(
		.PCLK(ACLK),
		.PRESETn(ARESETn),
		.PADDR(PADDR[2]),
		.PWRITE(PWRITE),
		.PSEL(PSEL2),
		.PENABLE(PENABLE),
		.PRDATA(PRDATA2),
		.PWDATA(PWDATA),

		.DMA_REQ(DMACBREQ[2]),
		.DMA_ACK(DMACCLR[2])
);
assign PREADY2 = 1'b1;

// APB Slave 3 : DMAPeri0(SINK)
DMAPeri #(.STREAM_SINK(1)) DMAPeri3
(
		.PCLK(ACLK),
		.PRESETn(ARESETn),
		.PADDR(PADDR[2]),
		.PWRITE(PWRITE),
		.PSEL(PSEL3),
		.PENABLE(PENABLE),
		.PRDATA(PRDATA3),
		.PWDATA(PWDATA),

		.DMA_REQ(DMACBREQ[3]),
		.DMA_ACK(DMACCLR[3])
);
assign PREADY3 = 1'b1;

// APB Slave 4 : DMAPeri0(SOURCE)
DMAPeri #(.STREAM_SINK(0)) DMAPeri4
(
		.PCLK(ACLK),
		.PRESETn(ARESETn),
		.PADDR(PADDR[2]),
		.PWRITE(PWRITE),
		.PSEL(PSEL4),
		.PENABLE(PENABLE),
		.PRDATA(PRDATA4),
		.PWDATA(PWDATA),

		.DMA_REQ(DMACBREQ[4]),
		.DMA_ACK(DMACCLR[4])
);
assign PREADY4 = 1'b1;

// APB Slave 5 : DMAPeri0(SOURCE)
DMAPeri #(.STREAM_SINK(0)) DMAPeri5
(
		.PCLK(ACLK),
		.PRESETn(ARESETn),
		.PADDR(PADDR[2]),
		.PWRITE(PWRITE),
		.PSEL(PSEL5),
		.PENABLE(PENABLE),
		.PRDATA(PRDATA5),
		.PWDATA(PWDATA),

		.DMA_REQ(DMACBREQ[5]),
		.DMA_ACK(DMACCLR[5])
);
assign PREADY5 = 1'b1;

// APB Slave 6 : DMAPeri0(SOURCE)
DMAPeri #(.STREAM_SINK(0)) DMAPeri6
(
		.PCLK(ACLK),
		.PRESETn(ARESETn),
		.PADDR(PADDR[2]),
		.PWRITE(PWRITE),
		.PSEL(PSEL6),
		.PENABLE(PENABLE),
		.PRDATA(PRDATA6),
		.PWDATA(PWDATA),

		.DMA_REQ(DMACBREQ[6]),
		.DMA_ACK(DMACCLR[6])
);
assign PREADY6 = 1'b1;

// APB Slave 7 : DMAPeri0(SOURCE)
DMAPeri #(.STREAM_SINK(0)) DMAPeri7
(
		.PCLK(ACLK),
		.PRESETn(ARESETn),
		.PADDR(PADDR[2]),
		.PWRITE(PWRITE),
		.PSEL(PSEL7),
		.PENABLE(PENABLE),
		.PRDATA(PRDATA7),
		.PWDATA(PWDATA),

		.DMA_REQ(DMACBREQ[7]),
		.DMA_ACK(DMACCLR[7])
);
assign PREADY7 = 1'b1;

// APB Slave 8 : AXI DMAC control register(connected above)

// Other DMA related signals
assign DMACBREQ[15:8] = 0;
assign DMACLBREQ = 0;
assign DMACSREQ = 0;
assign DMACLSREQ = 0;

endmodule

