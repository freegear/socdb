//************************************************
// Project     : NAND FLASH CONTROLLER 
// Date        : 2006/10/23
// author      : 
// Description : Nand flash control
// module name : NFCtrl.v
// history     :
//
//************************************************
`timescale 1ns/10ps

module NFCtrl(
    Clk             ,
    nRst            ,
    
    DMAReqOut       ,

    // nand boot module I/F
    BootOpRdEnOut   ,
    BootOpReadyIn   ,
    BootOpIn        ,
    BootEndIn       ,
    
    //Status output
    NFCtrlBusyOut   ,
    NFStatValidOut  ,
    NFStatusOut     ,
    WrEndOut        , 
    RdEndOut        ,   
    WrFIFOReadyOut  ,   
    RdFIFOReadyOut  ,   

    // Data FIFO R/W
    FIFOFlushOut    ,
    FIFORdDataIn    ,
    FIFORdDataEnOut ,
    FIFOWrDataOut   ,
    FIFOWrDataEnOut ,

    BeforeFullIn    ,
    FIFORdReadyIn   ,
    FIFOFullIn      ,
    FIFOHalfFullIn  ,
    FIFOEmpty1In    ,
    FIFOEmpty0In    ,
    WrRdyIn         ,
    RdRdyIn         ,

    //Operation Read
    NFOpRdEnOut     ,
    NFOpIn          ,
    QLevelIn        ,

    //NFCTRL,NFCONF In
    NFCTRLIn        ,
    NFCONFIn        ,

    //Ecc
    EccIn           ,
    AutoEccWrEnIn   ,
    BoundaryIn      ,
    NST_RdataOut    ,
    CST_RdataOut    ,
    CST_WdataOut    ,
    EccDataOut      ,
    EccDataEnOut    ,
    AddrValidOut    ,
    ColumnAddrOut   ,    

    // nand flash I/F
    NFDataIn        ,
    NFDataOut       ,
    NFDataOutEnOut  ,
    CLEOut          ,
    ALEOut          ,
    nNFCE1Out       ,
    nNFCE0Out       ,
    nNFREOut        ,
    nNFWEOut        ,
    FiltRnB1In      ,
    FiltRnB0In      );

input           Clk ;
input           nRst;

output          DMAReqOut;

    // nand boot module I/F
output          BootOpRdEnOut   ;
input           BootOpReadyIn   ;
input [31:0]    BootOpIn        ;
input           BootEndIn       ;

    
    //Status output
output          NFCtrlBusyOut   ;
output          NFStatValidOut  ;
output[15:0]    NFStatusOut     ;
output          WrEndOut        ; 
output          RdEndOut        ;   
output          WrFIFOReadyOut  ;   
output          RdFIFOReadyOut  ;   

    // Data FIFO R/W
output          FIFOFlushOut    ;
input [31:0]    FIFORdDataIn    ;
output          FIFORdDataEnOut ;
output[31:0]    FIFOWrDataOut   ;
output          FIFOWrDataEnOut ;

input           BeforeFullIn    ;
input           FIFORdReadyIn   ;
input           FIFOFullIn      ;
input           FIFOHalfFullIn  ;
input           FIFOEmpty1In    ;
input           FIFOEmpty0In    ;
input           WrRdyIn         ;
input           RdRdyIn         ;

    //Operation Read
output          NFOpRdEnOut     ;
input [31:0]    NFOpIn          ;
input [ 3:0]    QLevelIn        ;

    //NFCTRL,NFCONF In
input [13:0]    NFCTRLIn        ;
input [18:0]    NFCONFIn        ;

//  to Ecc
input [15:0]    EccIn           ;
input           AutoEccWrEnIn   ;
input           BoundaryIn      ;
output          NST_RdataOut    ;
output          CST_RdataOut    ;
output          CST_WdataOut    ;
output[15:0]    EccDataOut      ;
output          EccDataEnOut    ;
output          AddrValidOut    ;
output[11:0]    ColumnAddrOut   ;
 



// Nand Flash interface
input [15:0]    NFDataIn        ;
output[15:0]    NFDataOut       ; 
output          NFDataOutEnOut  ;  
output          CLEOut          ;
output          ALEOut          ;
output          nNFCE1Out       ;
output          nNFCE0Out       ;
output          nNFREOut        ;
output          nNFWEOut        ;
input           FiltRnB1In      ;
input           FiltRnB0In      ;

// main state machine
parameter   ST_IDLE     = 8'b00000001;
parameter   ST_LOAD     = 8'b00000010;
parameter   ST_CMD      = 8'b00000100;
parameter   ST_ADDR     = 8'b00001000;
parameter   ST_RNBCHECK = 8'b00010000;
parameter   ST_WAIT2CLK = 8'b00100000;
parameter   ST_WDATA    = 8'b01000000;
parameter   ST_RDATA    = 8'b10000000;

// main state machine
reg [ 7:0]  CurrentState;
reg [ 7:0]  NextState;

// timing state machine
parameter   TST_IDLE    = 5'b00001;
parameter   TST_TADLTWB = 5'b00010;
parameter   TST_TCALS   = 5'b00100;
parameter   TST_TRWLP   = 5'b01000;
parameter   TST_TRWHP   = 5'b10000;

// timing state machine
reg [4:0]   TNextSt;
reg [4:0]   TCurrentSt;

//Control reg
wire        NFCtrlRst   = NFCTRLIn[13];   

//wire[1:0]   NFIDByte    = NFCTRLIn[9:8];
wire        Ecc512En    = NFCTRLIn[8];
wire        AutoEccWr   = NFCTRLIn[7];
wire        DMAEn       = NFCTRLIn[6];
wire        WrEndIntEn  = NFCTRLIn[5];
wire        RdEndINTEn  = NFCTRLIn[4];
//wire        EccErrIntEn = NFCTRLIn[3]; //2.9
wire        FIFOintEn   = NFCTRLIn[2];
wire        RnBIntEn1   = NFCTRLIn[1];
wire        RnBIntEn0   = NFCTRLIn[0];

//configuration reg
wire        NFBootEn = NFCONFIn[18];
wire        IOWidth  = NFCONFIn[17];
wire        NandWidth= NFCONFIn[16];
wire[ 1:0]  BootCfg  = NFCONFIn[15:14];
wire        OutDtmn  = NFCONFIn[13];
wire[ 3:0]  TADLTWB  = NFCONFIn[12:9];
wire[ 2:0]  TCALS    = NFCONFIn[ 8:6];
wire[ 2:0]  TRWLP    = NFCONFIn[ 5:3];
wire[ 2:0]  TRWHP    = NFCONFIn[ 2:0];

wire        Two8BitNand;
assign Two8BitNand = (NandWidth==1'b0 && IOWidth==1'b1) ? 1'b1 : 1'b0;

// NFOPER
reg [31:0]  FirstOper;
//reg [11:0]  DataSize;
reg [31:0]  CmdAddr1;
reg [31:0]  CmdAddr2;

wire        ChipSel          = FirstOper[31];

wire        RnBWait          = (FirstOper[30:29]==2'b01) ? 1'b1 : 1'b0;
wire        AutoRdStat       = (FirstOper[30:29]==2'b10) ? 1'b1 : 1'b0;
wire        Continue         = (FirstOper[30:29]==2'b11) ? 1'b1 : 1'b0;

wire[11:0]  DataSize         = FirstOper[28:17];
//wire[ 2:0]  FIFOLevelSet     = FirstOper[18:16];   
//wire[ 2:0]  OpMode           = FirstOper[15:13];
wire[ 1:0]  TransSize        = FirstOper[13:12]; // byte,halfword,word select
wire[ 3:0]  CmdAddrTransByte = FirstOper[11:8];
wire[ 7:0]  CmdAddrFlag      = FirstOper[ 7:0];

wire        ReadData   = (FirstOper[16:14]==3'b000) ? 1'b1 : 1'b0;
wire        ReadStatus = (FirstOper[16:14]==3'b001) ? 1'b1 : 1'b0;
wire        ReadID     = (FirstOper[16:14]==3'b010) ? 1'b1 : 1'b0;
wire        WriteData  = (FirstOper[16:14]==3'b011) ? 1'b1 : 1'b0;
//wire        CellWrite  = (FirstOper[16:14]==3'b100) ? 1'b1 : 1'b0;
//wire        Continue   = (FirstOper[16:14]==3'b101) ? 1'b1 : 1'b0;
wire        NOP        = (FirstOper[16:14]==3'b111) ? 1'b1 : 1'b0;

//wire        RdDataEnd;
wire        LoadEnd;

reg [ 7:0]  NextCmd;
reg [ 3:0]  CmdAddrTransCnt;
reg [11:0]  DataSizeCnt;


wire        TadlTwbEnd;
wire        TrwhpEnd;
wire        TrwlpEnd;
wire        TcalsEnd;

wire CST_Idle    ;
wire CST_Load    ;
wire CST_Cmd     ;
wire CST_Addr    ;
wire CST_RnBCheck;
wire CST_Wait2Clk;
wire CST_Wdata   ;
wire CST_Rdata   ;

wire NST_Idle    ;
wire NST_Load    ;
wire NST_Cmd     ;
wire NST_Addr    ;
wire NST_RnBCheck;
wire NST_Wait2Clk;
wire NST_Wdata   ;
wire NST_Rdata   ;

wire CTST_Idle   ;
wire CTST_TadlTwb;
wire CTST_Tcals  ;
wire CTST_Trwlp  ;
wire CTST_Trwhp  ;

wire NTST_Idle   ;
wire NTST_TadlTwb;
wire NTST_Tcals  ;
wire NTST_Trwlp  ;
wire NTST_Trwhp  ;

assign CST_Idle     = (CurrentState==ST_IDLE    ) ? 1'b1 : 1'b0;
assign CST_Load     = (CurrentState==ST_LOAD    ) ? 1'b1 : 1'b0;
assign CST_Cmd      = (CurrentState==ST_CMD     ) ? 1'b1 : 1'b0;
assign CST_Addr     = (CurrentState==ST_ADDR    ) ? 1'b1 : 1'b0;
assign CST_RnBCheck = (CurrentState==ST_RNBCHECK) ? 1'b1 : 1'b0;
assign CST_Wait2Clk = (CurrentState==ST_WAIT2CLK) ? 1'b1 : 1'b0;
assign CST_Wdata    = (CurrentState==ST_WDATA   ) ? 1'b1 : 1'b0;
assign CST_Rdata    = (CurrentState==ST_RDATA   ) ? 1'b1 : 1'b0;

assign NST_Idle     = (NextState==ST_IDLE       ) ? 1'b1 : 1'b0;
assign NST_Load     = (NextState==ST_LOAD       ) ? 1'b1 : 1'b0;
assign NST_Cmd      = (NextState==ST_CMD        ) ? 1'b1 : 1'b0;
assign NST_Addr     = (NextState==ST_ADDR       ) ? 1'b1 : 1'b0;
assign NST_RnBCheck = (NextState==ST_RNBCHECK   ) ? 1'b1 : 1'b0;
assign NST_Wait2Clk = (NextState==ST_WAIT2CLK   ) ? 1'b1 : 1'b0;
assign NST_Wdata    = (NextState==ST_WDATA      ) ? 1'b1 : 1'b0;
assign NST_Rdata    = (NextState==ST_RDATA      ) ? 1'b1 : 1'b0;

assign CTST_Idle    = (TCurrentSt==TST_IDLE     ) ? 1'b1 : 1'b0;
assign CTST_TadlTwb = (TCurrentSt==TST_TADLTWB  ) ? 1'b1 : 1'b0;
assign CTST_Tcals   = (TCurrentSt==TST_TCALS    ) ? 1'b1 : 1'b0;
assign CTST_Trwlp   = (TCurrentSt==TST_TRWLP    ) ? 1'b1 : 1'b0;
assign CTST_Trwhp   = (TCurrentSt==TST_TRWHP    ) ? 1'b1 : 1'b0;

assign NTST_Idle    = (TNextSt==TST_IDLE        ) ? 1'b1 : 1'b0;
assign NTST_TadlTwb = (TNextSt==TST_TADLTWB     ) ? 1'b1 : 1'b0;
assign NTST_Tcals   = (TNextSt==TST_TCALS       ) ? 1'b1 : 1'b0;
assign NTST_Trwlp   = (TNextSt==TST_TRWLP       ) ? 1'b1 : 1'b0;
assign NTST_Trwhp   = (TNextSt==TST_TRWHP       ) ? 1'b1 : 1'b0;



reg [31:0]  FIFOWrDataOut;
reg [15:0]  NFOutData;

reg [1:0]   PackingCnt;
reg [1:0]   ParsingCnt;
//reg         FIFORdDataEnOut;
//reg         FIFORdDataEnOutDly;
//reg         FIFOEmptyInDly;

// timing cnt
reg[3:0]    TCALSCnt;
reg[3:0]    TRWLPCnt;
reg[3:0]    TRWHPCnt;
reg[5:0]    TADLTWBCnt;

wire DataEnd;
assign DataEnd = (DataSizeCnt==DataSize && DataSize!=0) ? 1'b1 : 1'b0;

/// DMAReqOut
reg DMAReqOut;

always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        DMAReqOut<=1'b0;   
    end
    else begin
        if(DMAEn==1'b1) begin
            if(ReadData) begin
                DMAReqOut<=FIFOHalfFullIn | FIFOFullIn | DataEnd;
            end
            else if(WriteData) begin
                DMAReqOut<=FIFOEmpty0In | FIFOEmpty1In;
            end
        end
        else 
            DMAReqOut<=1'b0;
    end
end




//    TransSize       |   8bit bus (IOWidth==1'b0)                            |   
//                    | bit[31:24]  | bit[23:16]  | bit[15:8]   | bit[7:0]    | 
// (2'b10)      word  | 4nd IO[7:0] | 3rd IO[7:0] | 2nd IO[7:0] | 1st IO[7:0] |
// (2'b01) half word  |   Invalid   |   Invalid   | 2nd IO[7:0] | 1st IO[7:0] |
// (2'b01)      byte  |   Invalid   |   Invalid   |   Invalid   | 1st IO[7:0] |

//    TransSize       |   16bit bus(IOWidth==1'b1)                            |   
//                    | bit[31:24]  | bit[23:16]  |bit[15:8]    | bit[7:0]    | 
// (2'b10)      word  | 2nd IO[15:8]| 2nd IO[7:0] |1st IO[15:8] | 1st IO[7:0] |
// (2'b01) half word  |   Invalid   |   Invalid   |1st IO[15:8] | 1st IO[7:0] |
//





//**************************************************************
// Ecc control ouput
/*
output          RWStateOut      ;
output[15:0]    EccDataOut      ;
output          EccDataEnOut    ;
output          AddrValidOut    ;
output[11:0]    ColumnAddrOut   ;  
*/
wire PageSize;
assign PageSize = BootCfg[1]; //1'b1 = 2048 :: 1'b0 = 512

assign NST_RdataOut = NST_Rdata;
assign CST_RdataOut = CST_Rdata;
assign CST_WdataOut = CST_Wdata;

//assign EccDataOut = (WriteData) ? NFOutData : NFDataIn;
assign EccDataOut = (WriteData) ? NFDataOut : NFDataIn;

assign EccDataEnOut = ( ( (CST_Rdata==1'b1 && ReadData==1'b1) || 
                          (CST_Wdata==1'b1 && WriteData==1'b1) 
                        )  && CTST_Trwlp==1'b1 && NTST_Trwlp!=1'b1   
                      ) ? 1'b1 : 1'b0;

assign AddrValidOut = (CST_Addr==1'b1 && NST_Addr==1'b0) ? 1'b1 : 1'b0;

/*
assign ErrDetectEnOut = (   CST_Rdata==1'b1 && 
                            (DataSize==12'd2112 && PageSize==1'b1 && NandWidth==1'b0) ||
                            (DataSize==12'd528  && PageSize==1'b0 && NandWidth==1'b0) ||
                            (DataSize==12'd1056 && PageSize==1'b1 && NandWidth==1'b1) ||
                            (DataSize==12'd264  && PageSize==1'b1 && NandWidth==1'b1)
                        ) ? 1'b1 : 1'b0;
*///2.9

reg [11:0]  ColumnAddrOut;
reg [ 2:0]  AddrCycleCnt;
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        AddrCycleCnt<=0;
        ColumnAddrOut<=0;
    end
    else begin
        if(NST_Addr==1'b1 && CTST_Trwlp==1'b1 && NTST_Trwlp!=1'b1) begin
            AddrCycleCnt<=AddrCycleCnt+1;
            if(PageSize==1'b1) begin
                if(AddrCycleCnt==0) ColumnAddrOut[7:0]<=NFDataOut[7:0];
                else if(AddrCycleCnt==1) ColumnAddrOut[11:8]<=NFDataOut[3:0];
            end
            else begin
                if(AddrCycleCnt==0) ColumnAddrOut<={4'd0,NFDataOut[7:0]};
            end
        end
        if(NST_Addr!=1'b1) AddrCycleCnt<=0;
    end
end


//**************************************************************
// NF Status ouput
/*
    NFCtrlBusyOut   ,
    NFStatValidOut  ,
    NFStatusOut     ,
    WrEndOut        , 
    RdEndOut        ,   
    FIFOReadyOut    ,   
*/

reg[15:0]    NFStatusOut;
reg         NFStatValidOut;
reg         WrEndOut;
reg         RdEndOut;

assign NFCtrlBusyOut = ~CST_Idle;
/*                      
assign WrFIFOReadyOut = ( CST_Idle==1'b0 && CST_RnBCheck==1'b0 && CST_Rdata==1'b0 && WriteData==1'b1 && 
                          (FIFOEmpty0In==1'b1 || FIFOEmpty1In==1'b1)) ? 1'b1 : 1'b0;
assign RdFIFOReadyOut = ( CST_Rdata==1'b1 && ReadData==1'b1 && 
                          (FIFOHalfFullIn==1'b1 || FIFOFullIn || ((DataSizeCnt==DataSize) && DataSizeCnt!=0)) 
                        ) ? 1'b1 : 1'b0 ;
*/ //2.8 revise
/*
assign WrFIFOReadyOut = ( CST_Idle==1'b0 && CST_RnBCheck==1'b0 && CST_Rdata==1'b0 && WriteData==1'b1 && 
                          WrRdyIn) ? 1'b1 : 1'b0;

assign RdFIFOReadyOut = ( CST_Rdata==1'b1 && (ReadData==1'b1 || ReadID==1'b1) && 
                           (RdRdyIn==1'b1 || ((DataSizeCnt==DataSize) && DataSizeCnt!=0)) 
                        ) ? 1'b1 : 1'b0 ;
*/
reg RdRdy_Dly;
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        RdRdy_Dly<=1'b0;   
    end
    else begin
        RdRdy_Dly<=RdRdyIn;
    end
end

assign WrFIFOReadyOut = ( CST_Wdata==1'b1 && WrRdyIn) ? 1'b1 : 1'b0;
assign RdFIFOReadyOut = ( CST_Rdata==1'b1 && 
                          ( (ReadData==1'b1 && (RdRdyIn==1'b1 || ((DataSizeCnt==DataSize) && DataSizeCnt!=0 && RdRdy_Dly==1'b0))) ||
                            (ReadID==1'b1 && (RdRdyIn==1'b1 || ((DataSizeCnt==DataSize) && DataSizeCnt!=0)))
                          )
                        ) ? 1'b1 : 1'b0 ;

                        
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        NFStatusOut<=0;
        NFStatValidOut<=0;
    end
    else begin
        if(CST_Rdata==1'b1 && (ReadStatus==1'b1 || AutoRdStat==1'b1) && CTST_Trwlp==1'b1 && NTST_Trwlp!=1'b1) begin
            NFStatusOut<=(Two8BitNand==1'b1) ? NFDataIn[15:0] : {8'd0,NFDataIn[7:0]};
            NFStatValidOut<=1'b1;
        end
        else begin
            NFStatusOut<=NFStatusOut;
            NFStatValidOut<=1'b0;
        end
    end
end


// Write End signal 
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        WrEndOut<=0;   
    end
    else begin
        if(AutoRdStat==1'b1) begin
            if(WriteData==1'b1 && CST_Rdata==1'b1 && AutoRdStat==1'b1 && CTST_Trwlp==1'b1 && NTST_Trwlp!=1'b1) 
                WrEndOut<=1'b1;
            else WrEndOut<=1'b0;
        end
        else begin
            if(WriteData==1'b1 && CST_Wdata==1'b1 && (DataSizeCnt==DataSize)) 
                WrEndOut<=1'b1;
            else WrEndOut<=0;
        end 
    end
end

// Read End signal
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        RdEndOut<=0;
    end
    else begin
        if(CST_Rdata==1'b1 && NST_Rdata==1'b0 && ReadData==1'b1) begin
            RdEndOut<=1'b1; 
        end
        else begin
            RdEndOut<=0;
        end
    end
end


//**************************************************************






////////////////////////////////////////////////////////////////
// DATA FIFO Control
////////////////////////////////////////////////////////////////

//reg     Flush;
//assign FIFOFlushOut =Flush; //2.8
assign FIFOFlushOut = (NST_Load==1'b1 && CST_Load==1'b0) ? 1'b1 : 1'b0;
/*
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        Flush<=0;   
    end
    else begin
        if(CST_Load) Flush<=1'b1; 
        else Flush<=1'b0;
    end
end
*/
//**************************************************************
// DATA FIFO read part
// FIFO Read Enable generate
reg [31:0]  FIFORdData;
reg         RdDataEn;
reg         RdDataEnDly;
reg         WrReady;
reg         NFWrDataReady;
//reg         WrDataValid;
//reg [ 1:0]  ForByte_16bitBusCnt;

reg         FIFOWrDataEnOut;

wire FIFOWrEn;
assign FIFOWrEn = ((CST_Rdata==1'b1 && CTST_Trwlp==1'b1 && NTST_Trwlp!=1'b1 && (PackingCnt==2'b11 || DataSizeCnt==(DataSize-1)) && FIFOFullIn!=1'b1)) ? 1'b1 : 1'b0;

always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        FIFOWrDataEnOut<=1'b0;  
    end
    else begin
//        if(FIFOWrEn) FIFOWrDataEnOut<=1'b1 ;//2.12
//        else FIFOWrDataEnOut<=1'b0;
        if(NST_Rdata) FIFOWrDataEnOut<=FIFOWrEn;
    end
end

wire NFWrEnd;
wire NFWrDataLoad;
wire Byte_8bitBus      ;   
wire Byte_16bitBus     ;
wire HalfWord_8bitBus  ;
wire HalfWord_16bitBus ;
wire Word_8bitBus      ;
wire Word_16bitBus     ;




//assign NFWrEnd = ((FIFOFullIn==1'b1 || FIFOHalfFullIn==1'b1) && ParsingCnt==2'b11 && CTST_Trwlp!=1'b1 && NTST_Trwlp==1'b1 ) ? 1'b1 : 1'b0;
assign NFWrEnd = (FIFORdReadyIn==1'b1 && ParsingCnt==2'b11 && CTST_Trwlp!=1'b1 && NTST_Trwlp==1'b1 ) ? 1'b1 : 1'b0;
//assign NFWrDataLoad    = (CST_Wdata==1'b1 && (FIFOFullIn==1'b1 || FIFOHalfFullIn==1'b1) && WrReady==1'b0) ? 1'b1 : 1'b0;              
assign NFWrDataLoad    = (CST_Wdata==1'b1 && FIFORdReadyIn==1'b1 && WrReady==1'b0) ? 1'b1 : 1'b0;//12.18              
assign FIFORdDataEnOut = (RdDataEn==1'b1 && RdDataEnDly!=1'b1) ? 1'b1 : 1'b0;

assign Byte_8bitBus      = (TransSize==2'b00 && IOWidth==1'b0) ? 1'b1 : 1'b0;
assign Byte_16bitBus     = (TransSize==2'b00 && IOWidth==1'b1) ? 1'b1 : 1'b0;
assign HalfWord_8bitBus  = (TransSize==2'b01 && IOWidth==1'b0) ? 1'b1 : 1'b0;
assign HalfWord_16bitBus = (TransSize==2'b01 && IOWidth==1'b1) ? 1'b1 : 1'b0;
assign Word_8bitBus      = (TransSize==2'b10 && IOWidth==1'b0) ? 1'b1 : 1'b0;
assign Word_16bitBus     = (TransSize==2'b10 && IOWidth==1'b1) ? 1'b1 : 1'b0;


// packing Cnt
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        PackingCnt<=2'b00;   
    end
    else begin
        if(NST_Rdata==1'b1 && ReadID==1'b1 && (Byte_8bitBus==1'b1 || HalfWord_16bitBus==1'b1)) 
            PackingCnt<=2'b11;
        /* 3.5  ******************
        else if(CST_Rdata==1'b1 && ReadData==1'b1 && (CTST_TadlTwb==1'b1 || (CTST_Idle==1'b1 && NTST_Idle!=1'b1))) begin
            if(Byte_8bitBus==1'b1 || HalfWord_16bitBus==1'b1) PackingCnt<=2'b11;
        end*/
        else if(CST_Rdata==1'b1 && ReadData==1'b1 && (CTST_TadlTwb==1'b1 || (CTST_Idle==1'b1 && NTST_Idle!=1'b1)) &&
                (Byte_8bitBus==1'b1 || HalfWord_16bitBus==1'b1) )
            PackingCnt<=2'b11;
        else if(CST_Rdata==1'b1 && (ReadData==1'b1 || ReadID==1'b1) && 
                CTST_TadlTwb!=1'b1 && CTST_Idle!=1'b1 && CTST_Trwlp!=1'b1 && NTST_Trwlp==1'b1) begin
            if(Byte_16bitBus || HalfWord_8bitBus || Word_16bitBus) begin
                if(PackingCnt==2'b11) PackingCnt<=2'b00;
                else PackingCnt<=2'b11;
            end
            else if(Word_8bitBus) begin 
                if(PackingCnt==2'b11) PackingCnt<=2'b00;
                else PackingCnt<=PackingCnt+1;
            end
        end
        else if(CST_Rdata!=1'b1 || CTST_Idle==1'b1) PackingCnt<=0;
    end
end

// parsing Cnt
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        ParsingCnt<=2'b00;   
    end
    else begin
        /* 3.5 ******************
        if(CST_Wdata==1'b1 && (CTST_TadlTwb==1'b1 || (CTST_Idle==1'b1 && NTST_Idle!=1'b1))) begin
            if(Byte_8bitBus==1'b1 || Byte_16bitBus || HalfWord_16bitBus==1'b1) ParsingCnt<=2'b11;
        end*/
        if(CST_Wdata==1'b1 && (CTST_TadlTwb==1'b1 || (CTST_Idle==1'b1 && NTST_Idle!=1'b1)) &&
           (Byte_8bitBus==1'b1 || Byte_16bitBus || HalfWord_16bitBus==1'b1) ) begin
            ParsingCnt<=2'b11;
        end
        else if(CST_Wdata==1'b1 && CTST_TadlTwb!=1'b1 && CTST_Idle!=1'b1 && TRWHPCnt==TRWHP) begin
            if(HalfWord_8bitBus || Word_16bitBus) begin
                if(ParsingCnt==2'b11) ParsingCnt<=2'b00;
                else ParsingCnt<=2'b11;
            end
            else if(Word_8bitBus) begin 
                if(ParsingCnt==2'b11) ParsingCnt<=2'b00;
                else ParsingCnt<=ParsingCnt+1;
            end
        end 
        else if(CST_Wdata!=1'b1) ParsingCnt<=0;
    end
end

// Data latch from FIFO
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        FIFORdData <=0;
        WrReady <=0;
        NFWrDataReady<=0;
    end
    else begin
        NFWrDataReady<=WrReady;
        if(CST_Wdata==1'b1) begin
            if(FIFORdDataEnOut==1'b1) begin
                FIFORdData<=FIFORdDataIn;
                WrReady<=1'b1;
            end
            //else if(FIFOEmpty0In==1'b1 && FIFOEmpty1In==1'b1 && ParsingCnt==2'b11 && CTST_Trwhp==1'b1 && NTST_Trwhp!=1'b1 )
//           else if(FIFOFullIn!=1'b1 && FIFOHalfFullIn!=1'b1 && ParsingCnt==2'b11 && CTST_Trwhp==1'b1 && NTST_Trwhp!=1'b1 )
//            else if(FIFORdReadyIn!=1'b1 && ParsingCnt==2'b11 && CTST_Trwhp==1'b1 && NTST_Trwhp!=1'b1 )
            else if(FIFORdReadyIn!=1'b1 && ParsingCnt==2'b11 && CTST_Trwlp!=1'b1 && NTST_Trwlp==1'b1 )
                WrReady<=1'b0;
        end
        else begin
            WrReady<=1'b0;
        end
    end
end

// FIFO read enable generate
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        RdDataEn<=0;
        RdDataEnDly<=0;
    end
    else begin
//        RdDataEnDly<=RdDataEn;//2.12
        if(NST_Wdata) RdDataEnDly<=RdDataEn;        
        if(NFWrDataLoad==1'b1 || NFWrEnd==1'b1) begin
            RdDataEn<=1'b1;
        end
        else RdDataEn<=0;
    end
end
//**************************************************************

// NAND Flash Write data Generate
always @(TransSize or IOWidth or FIFORdData or OutDtmn or ParsingCnt)
begin
    case({TransSize,IOWidth})
        3'b000: //byte 8bit
            NFOutData<={8'd0,FIFORdData[7:0]};
        3'b001: //byte 16bit
            NFOutData<=FIFORdData;
        3'b010: //halfword 8bit
            NFOutData<=(ParsingCnt==2'b00) ? {8'd0,FIFORdData[7:0]} : {8'd0,FIFORdData[15:8]};
        3'b011: //halfoword 16bit
            NFOutData<=FIFORdData[15:0];
        3'b100: begin //word 8bit
            NFOutData<=(ParsingCnt==2'b00) ? {8'd0,FIFORdData[ 7:0 ]} :
                       (ParsingCnt==2'b01) ? {8'd0,FIFORdData[15:8 ]} :
                       (ParsingCnt==2'b10) ? {8'd0,FIFORdData[23:16]} : {8'd0,FIFORdData[31:24]};
        end
        3'b101: //word 16bit
                NFOutData<=(ParsingCnt==2'b00) ? FIFORdData[15:0 ] : FIFORdData[31:16] ;
        default:NFOutData<=0;
    endcase
end



always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        FIFOWrDataOut<=0;
    end
    else begin
 //       if((CST_Rdata==1'b1 || CST_Wdata==1'b1) && CTST_Trwhp==1'b1 && NTST_Trwhp==1'b0) begin
        if(CST_Rdata==1'b1 && (ReadData==1'b1 || ReadID==1'b1) && CTST_Trwlp==1'b1 && NTST_Trwlp!=1'b1) begin
            case({TransSize,IOWidth})
                3'b000:  //byte 8bit
                    FIFOWrDataOut<={24'd0,NFDataIn[7:0]};
                3'b010: begin  //halfword 8bit
                    if(PackingCnt==2'b00)      FIFOWrDataOut[ 7:0]<=NFDataIn[7:0];
                    else if(PackingCnt==2'b11) FIFOWrDataOut[15:8]<=NFDataIn[7:0];
                end
                3'b011:  //halfoword 16bit
                    FIFOWrDataOut[15:0]<=NFDataIn;
                3'b100: begin //word 8bit
                    if(PackingCnt==2'b00)      FIFOWrDataOut[ 7:0 ]<=NFDataIn[7:0];
                    else if(PackingCnt==2'b01) FIFOWrDataOut[15:8 ]<=NFDataIn[7:0];
                    else if(PackingCnt==2'b10) FIFOWrDataOut[23:16]<=NFDataIn[7:0];
                    else                       FIFOWrDataOut[31:24]<=NFDataIn[7:0];
                end
                3'b101: begin  //word 16bit
                    if(PackingCnt==2'b00)      FIFOWrDataOut[15:0 ]<=NFDataIn[15:0];
                    else if(PackingCnt==2'b11) FIFOWrDataOut[31:16]<=NFDataIn[15:0];
                end
                default:FIFOWrDataOut<=0;
            endcase
        end
    end
end
//**************************************************************



//**************************************************************
// main state machine part
reg [2:0]   WaitCnt;
wire        CmdTimingEnd;
wire        AddrTimingEnd;
wire        WrDataEnd;
wire        CmdAddrTransEnd;
wire        RnBHigh;
wire        RdStatusEnd;
wire        WaitEnd;
wire        RnBCheckBeforeNextCmd;
wire        BootStart;

//wire[3:0]   IDByte;
//assign IDByte           = (NFIDByte+2);
//assign CmdTimingEnd     = (CST_Cmd && CTST_Trwhp && TrwhpEnd && NextCmd[7]==1'b0) ? 1'b1 : 1'b0;
assign CmdTimingEnd     = (CST_Cmd==1'b1 && CTST_Trwhp==1'b1 && TrwhpEnd==1'b1) ? 1'b1 : 1'b0;
//assign AddrTimingEnd    = (CST_Addr==1'b1 && CTST_Trwhp==1'b1 && TrwhpEnd==1'b1 && NextCmd[7]==1'b1) ? 1'b1 : 1'b0;
assign AddrTimingEnd    = (CST_Addr==1'b1 && CTST_Trwhp==1'b1 && TrwhpEnd==1'b1 && NextCmd[0]==1'b1) ? 1'b1 : 1'b0;//12.18
assign WrDataEnd        = (CST_Wdata==1'b1 && DataSizeCnt!=0 && DataSizeCnt==DataSize && TrwhpEnd==1'b1) ? 1'b1 : 1'b0;


assign CmdAddrTransEnd  = ((CmdAddrTransCnt==CmdAddrTransByte) && TrwhpEnd==1'b1) ? 1'b1 : 1'b0;
assign RnBHigh          = (ChipSel==1'b1) ? FiltRnB1In : FiltRnB0In;
assign RdStatusEnd      = ((AutoRdStat==1'b1 || ReadStatus==1'b1) && TrwhpEnd==1'b1 ) ? 1'b1 : 1'b0;
assign WaitEnd          = (WaitCnt==2'b10) ? 1'b1 : 1'b0;
assign RnBCheckBeforeNextCmd = (CmdTimingEnd==1'b1 && AutoRdStat==1'b1 && CmdAddrTransCnt==(CmdAddrTransByte-1) &&
                                CTST_Trwhp==1'b1 && TrwhpEnd==1'b1) ? 1'b1 : 1'b0;

assign BootStart = (BootOpReadyIn==1'b1 && NFBootEn==1'b1 && BootEndIn==1'b0) ? 1'b1 : 1'b0;

//assign RdDataEnd        = (CST_Rdata==1'b1 && DataSizeCnt!=0 && DataSizeCnt==DataSize && TrwhpEnd==1'b1) ? 1'b1 : 1'b0;

reg     RdDataEnd;
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        RdDataEnd<=1'b0;   
    end
    else begin
//        if(ReadData==1'b1 && DataSizeCnt==DataSize && FIFOEmpty0In==1'b1 && FIFOEmpty1In==1'b1)//2.8
        if((ReadData==1'b1 || ReadID==1'b1)&& DataSizeCnt==DataSize && FIFOEmpty0In==1'b1 && FIFOEmpty1In==1'b1)
            RdDataEnd<=1'b1;
        else RdDataEnd<=1'b0;
    end
end

// CurrentState
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        CurrentState<=ST_IDLE;
    end
    else begin
        CurrentState<=NextState;
    end
end

// NextState
always @(CurrentState or QLevelIn or RnBWait or AutoRdStat or CmdAddrTransByte or 
         CmdAddrFlag or CmdTimingEnd or AddrTimingEnd or ReadData or WriteData or
         RnBHigh or WrDataEnd or RdDataEnd or NOP or LoadEnd or CmdAddrTransByte or
         CmdAddrTransCnt or CTST_TadlTwb or RdStatusEnd or WaitEnd or
         CmdAddrTransEnd or /*CellWrite or*/ WriteData or NextCmd or Byte_16bitBus or
         RnBCheckBeforeNextCmd or BootStart or ReadStatus or ReadID or NFCtrlRst)
begin
    case(CurrentState) // synopsys parallel_case
        ST_IDLE     :
            if(QLevelIn!=0 || BootStart) NextState<=ST_LOAD;
            else NextState<=ST_IDLE;
        ST_LOAD     :
            if(NFCtrlRst==1'b1) NextState<=ST_IDLE;
            else if(LoadEnd==1'b1 && CmdAddrTransByte !=0 && CmdAddrFlag[0]==1'b1) NextState<=ST_CMD;//12.18
            else if(LoadEnd==1'b1 && CmdAddrTransByte !=0 && CmdAddrFlag[0]==1'b0) NextState<=ST_ADDR;//12.18
            else if(LoadEnd==1'b1 && ReadData) NextState<=ST_RDATA;
            else if(LoadEnd==1'b1 && WriteData) NextState<=ST_WDATA;//1.4
            else NextState<=ST_LOAD;
        ST_CMD      :
            if( NFCtrlRst==1'b1 || 
                (CmdAddrTransEnd==1'b1 && RnBWait!=1'b1 && AutoRdStat!=1'b1 && ReadData!=1'b1 && ReadStatus!=1'b1) ) NextState<=ST_IDLE;
            else if(CmdAddrTransEnd==1'b1 && (AutoRdStat==1'b1 || ReadStatus==1'b1)) NextState<=ST_RDATA; 
            else if( (CmdAddrTransEnd==1'b1 && (RnBWait==1'b1 || ReadData==1'b1)) || 
                     (CmdTimingEnd==1'b1 && RnBCheckBeforeNextCmd==1'b1) ) NextState<=ST_RNBCHECK;
            else if(!CmdAddrTransEnd==1'b1 && CmdTimingEnd==1'b1 && NextCmd[0]==1'b0) NextState<=ST_ADDR;
            else NextState<=ST_CMD;
        ST_ADDR     :
            if(NFCtrlRst==1'b1) NextState<=ST_IDLE;
            else if(AddrTimingEnd==1'b1 && CmdAddrTransEnd!=1'b1 && NextCmd[0]==1'b1 && WriteData!=1'b1) NextState<=ST_CMD;//12.18
            else if((CmdAddrTransEnd==1'b1 || AddrTimingEnd==1'b1) && (RnBWait==1'b1 || ReadData==1'b1)) NextState<=ST_RNBCHECK;
            else if((CmdAddrTransEnd==1'b1 || AddrTimingEnd==1'b1) && WriteData==1'b1) NextState<=ST_WDATA;
            else if((CmdAddrTransEnd==1'b1 || AddrTimingEnd==1'b1) && (ReadData==1'b1 || ReadID==1'b1)) NextState<=ST_RDATA;
            else if(CmdAddrTransEnd==1'b1) NextState<=ST_IDLE;
            else NextState<=ST_ADDR;
        ST_RNBCHECK :
            if(NFCtrlRst==1'b1) NextState<=ST_IDLE;
            else if(CTST_TadlTwb!=1'b1 && RnBHigh==1'b1 && (ReadData==1'b1 || AutoRdStat==1'b1)) NextState<=ST_WAIT2CLK;
            else if(CTST_TadlTwb!=1'b1 && RnBHigh==1'b1) NextState<=ST_IDLE;
            else NextState<=ST_RNBCHECK;
        ST_WAIT2CLK :
            if(NFCtrlRst==1'b1) NextState<=ST_IDLE;
            else if(WaitEnd==1'b1 && AutoRdStat==1'b1) NextState<=ST_CMD;
            else if(WaitEnd==1'b1 && ReadData==1'b1) NextState<=ST_RDATA;
            else NextState<=ST_WAIT2CLK;
        ST_WDATA    :
            if(NFCtrlRst==1'b1) NextState<=ST_IDLE;
            else if(WrDataEnd==1'b1) begin
                if(NextCmd[0]==1'b1 && CmdAddrTransEnd!=1'b1) NextState<=ST_CMD;//12.18
                else if(CmdAddrTransEnd==1'b1 && RnBWait==1'b1) NextState<=ST_RNBCHECK;
                else NextState<=ST_IDLE;
            end
            else NextState<=ST_WDATA;
        ST_RDATA    :
            if( NFCtrlRst==1'b1 || (RdDataEnd==1'b1 || RdStatusEnd==1'b1) )NextState<=ST_IDLE;
            else NextState<=ST_RDATA;
        default     : NextState<=ST_IDLE;
    endcase
end
//**************************************************************



// 2clk wait cnt
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        WaitCnt<=0;   
    end
    else begin
        if(NST_Wait2Clk==1'b1) WaitCnt<=WaitCnt+1;
        else WaitCnt<=0;
    
    end
end

// RE ready counter
/*
reg [ 1:0]  REnReadyCnt;
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        REnReadyCnt<=2'b00;    
    end
    else begin
        if(NST_Rdata==1'b1 && CTST_Idle==1'b1) begin
            if(REnReadyCnt==2'b11) REnReadyCnt<=0;
            else REnReadyCnt<=REnReadyCnt+1'b1;
        end
    end
end
*/
//data size Counter
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        DataSizeCnt<=0;   
    end
    else begin
        if((NST_Wdata==1'b1 || NST_Rdata==1'b1) && CTST_Trwlp==1'b1 && NTST_Trwhp==1'b1) begin
            DataSizeCnt<=DataSizeCnt+1;
        end
        else if(!NST_Wdata==1'b1 && NST_Rdata!=1'b1)
            DataSizeCnt<=0;
    end
end


//command address trasnfer counter
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        CmdAddrTransCnt<=0;
    end
    else begin
        if(CST_Idle==1'b1 || CST_Load==1'b1) CmdAddrTransCnt<=0;
        else if((CST_Cmd==1'b1 || CST_Addr==1'b1) && NTST_Trwlp==1'b1 && CTST_Trwlp!=1'b1) begin
            if(CmdAddrTransByte==CmdAddrTransCnt) 
                CmdAddrTransCnt<=0;
            else CmdAddrTransCnt<=CmdAddrTransCnt+1'b1;
        end
    end
end



//**************************************************************
// Operation Load Part
reg[2:0]    LoadCnt;
reg         OperRdEn;
reg         OperRdEnDly;
//reg[2:0]    NFOpWordNum; //1.5
wire[2:0]   NFOpWordNum;

assign  LoadEnd = (NFOpWordNum==LoadCnt) ? 1'b1 : 1'b0; 

assign NFOpWordNum = (CmdAddrTransByte==0) ? 3'd1 :
                     (CmdAddrTransByte<=4) ? 3'd2 : 3'd3;
/* 1.5
always @(posedge Clk or negedge nRst) 
begin
    if(!nRst) begin
        NFOpWordNum<=3'd3;
    end
    else begin
        if(CmdAddrTransByte==0)      NFOpWordNum<=3'd1;
        else if(CmdAddrTransByte<=4) NFOpWordNum<=3'd2;
        else if(CmdAddrTransByte>4)  NFOpWordNum<=3'd3;
    end
end
*/

// Operation Read 
wire OpRdEnd;
assign  NFOpRdEnOut   = ( ((NFBootEn==1'b1 && BootEndIn==1'b1)|| NFBootEn==1'b0) && OperRdEn==1 && OperRdEnDly==0) ? 1'b1 : 1'b0;
assign  BootOpRdEnOut = (NFBootEn==1'b1 && BootEndIn==1'b0 && OperRdEn==1 && OperRdEnDly==0) ? 1'b1 : 1'b0;

assign  OpRdEnd = (LoadCnt==2 && OperRdEn==1'b0) ? 1'b1 : 1'b0;

always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        OperRdEn<=0;
        OperRdEnDly<=0;
    end
    else begin
        OperRdEnDly<=OperRdEn;
//        if(NST_Load==1'b1 && ( ((QLevelIn!=0) && NFOpWordNum!=LoadCnt) || BootOpReadyIn==1'b1)) begin //1.5
        if(NST_Load==1'b1 && 
            ( ((QLevelIn!=0) && NFOpWordNum!=LoadCnt && OperRdEnDly!=1'b1) || 
              (BootOpReadyIn==1'b1 && OpRdEnd==1'b0) ) 
          ) begin
            OperRdEn<=~OperRdEn;    
        end
        else OperRdEn<=1'b0;
    end
end

// Operation Load Counter
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        LoadCnt<=0;
    end
    else begin
        if(NST_Load==1'b1 && NFOpWordNum!=LoadCnt) begin
//            if(OperRdEn==1'b1) LoadCnt<=LoadCnt+1; //1.5
            if(OperRdEnDly==1'b1) LoadCnt<=LoadCnt+1;
        end
        else if(NST_Load!=1'b1) LoadCnt<=0;
    end
end

// Operation Load
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        FirstOper <=0;
        CmdAddr1  <=0;
        CmdAddr2  <=0;
    end
    else begin
//        if(NST_Load && (QLevelIn!=0 || BootOpReadyIn==1'b1 )) begin //1.5
//        if((NST_Load && QLevelIn!=0 && NFOpRdEnOut==1'b1) || (NST_Load && BootOpReadyIn==1'b1 )) begin//1.15
        if((NST_Load && QLevelIn!=0 && NFOpRdEnOut==1'b1) || (NST_Load && BootOpRdEnOut==1'b1 )) begin
            if(LoadCnt==0) FirstOper<=(NFBootEn==1'b1 && BootEndIn==1'b0) ? BootOpIn : NFOpIn;
            else if(LoadCnt==1) CmdAddr1<=(NFBootEn==1'b1 && BootEndIn==1'b0) ? BootOpIn : NFOpIn;
            else if(LoadCnt==2) CmdAddr2<=(NFBootEn==1'b1 && BootEndIn==1'b0) ? BootOpIn : NFOpIn;
        end
    end
end
//**************************************************************

//2007.4.20 added 
reg tAREn;
reg tAREnDly;
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        tAREn<=1'b0;   
        tAREnDly<=1'b0;
    end
    else begin
        tAREnDly<=tAREn;
        if((CST_Addr || CST_Cmd) && NST_Rdata) tAREn<=1'b1;
        else if(tAREnDly==1'b1) tAREn<=1'b0;
    end
end
// 2007.4.20


//**************************************************************
// Timing state machine part
wire        GoTcals;
//wire        GoTrwlp;
wire        GoTrwhp;
wire        GoIdle;
wire        BFull;
wire        GoTadl;
wire        GoTrwlp;
wire        GoTrwlp0;
wire        GoTrwlp1;
wire        GoTrwlp2;
wire        GoTrwlp3; //2007.4.24

assign TadlTwbEnd = (TADLTWBCnt==(TADLTWB+20)) ? 1'b1 : 1'b0;
assign TcalsEnd   = (TCALSCnt==(TCALS+1)) ? 1'b1 : 1'b0;
assign TrwlpEnd   = (TRWLPCnt==(TRWLP+1)) ? 1'b1 : 1'b0;
assign TrwhpEnd   = (TRWHPCnt==(TRWHP+1)) ? 1'b1 : 1'b0;

assign BFull = BeforeFullIn & FIFOWrDataEnOut;
//assign ReadReady = (CST_Rdata==1'b1 && REnReadyCnt==2'b11) ? 1'b1 : 1'b0;

assign GoTcals = ((CST_Cmd!=1'b1 && NST_Cmd==1'b1) || (CST_Addr!=1'b1 && NST_Addr==1'b1)) ? 1'b1 : 1'b0;


//assign GoIdle  = (NST_Idle==1'b1 || CST_Idle==1'b1 || CST_RnBCheck==1'b1 || (NST_Rdata==1'b1 && CST_Rdata!=1'b1) ) ? 1'b1 : 1'b0; 
assign GoIdle  = (NST_Idle==1'b1 || CST_Idle==1'b1 || CST_RnBCheck==1'b1 || (NST_Rdata==1'b1 && CST_Rdata!=1'b1) ||
                  ((CST_Addr==1'b1 || CST_Cmd==1'b1) && NST_Rdata==1'b1) ) ? 1'b1 : 1'b0; //2007.4.20
assign GoTrwhp = (TRWLPCnt==(TRWLP+1'b1)) ? 1'b1 : 1'b0;
assign GoTadl  = (NextState==ST_WDATA && CurrentState!=ST_WDATA) ? 1'b1 : 1'b0;

assign GoTrwlp0 = ((CST_Addr==1'b1 || CST_Cmd==1'b1) && (TcalsEnd==1'b1 || TrwhpEnd)) ? 1'b1 : 1'b0;

assign GoTrwlp1 = (CST_Wdata==1'b1 && NFWrDataReady==1'b1) ? 1'b1 : 1'b0;
//assign GoTrwlp2 = (CST_Rdata==1'b1 && FIFOFullIn!=1'b1 && BFull==1'b0) ? 1'b1 : 1'b0;
assign GoTrwlp2 = (CST_Rdata==1'b1 && FIFOFullIn!=1'b1 && BFull==1'b0 && DataSize!=0 && DataSizeCnt!=DataSize) ? 1'b1 : 1'b0;//12.19

assign GoTrwlp3 = (CST_Rdata==1'b1 && tAREn==1'b0 && tAREnDly==1'b1);//2007.4.24

//assign GoTrwlp  = GoTrwlp0 | GoTrwlp1 | GoTrwlp2 ;
assign GoTrwlp  = GoTrwlp0 | GoTrwlp1 | GoTrwlp2 | GoTrwlp3;//2007.4.24

// current state
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) TCurrentSt<=TST_IDLE;
    else TCurrentSt<=TNextSt;
end

// next state
always @(TCurrentSt or GoTcals or GoTrwlp or GoTrwhp or GoIdle or GoTadl or TadlTwbEnd or 
//         NFWrDataReady or TrwhpEnd or TcalsEnd or NST_RnBCheck /*or ReadReady*/)
         NFWrDataReady or TrwhpEnd or TcalsEnd or NST_RnBCheck or tAREn) //2007.4.20
begin   
    case(TCurrentSt) // synopsys parallel_case
        TST_IDLE  :
            if(GoTcals==1'b1) TNextSt<=TST_TCALS;
//            else if(GoTrwlp==1'b1) TNextSt<=TST_TRWLP;
            else if(GoTrwlp==1'b1 && tAREn!=1'b1) TNextSt<=TST_TRWLP;
            else TNextSt<=TST_IDLE;
        TST_TADLTWB  :
            if(TadlTwbEnd==1'b1) begin
                if(NFWrDataReady==1'b1) TNextSt<=TST_TRWLP;
                else TNextSt<=TST_IDLE;
            end
            else TNextSt<=TST_TADLTWB;
        TST_TCALS :
            if(GoTrwlp==1'b1 && TcalsEnd==1'b1) TNextSt<=TST_TRWLP;
            else TNextSt<=TST_TCALS;
        TST_TRWLP :
            if(GoIdle==1'b1) TNextSt<=TST_IDLE;
            else if(NST_RnBCheck==1'b1) TNextSt<=TST_TADLTWB;
            else if(GoTrwhp==1'b1) TNextSt<=TST_TRWHP;
            else TNextSt<=TST_TRWLP;
        TST_TRWHP :
            if(GoIdle==1'b1) TNextSt<=TST_IDLE; //2007.4.20
            else // 
                if(NST_RnBCheck==1'b1) TNextSt<=TST_TADLTWB;
            else if(TrwhpEnd==1'b1) begin
                if(GoTadl==1'b1)  TNextSt<=TST_TADLTWB;
                else if(GoTcals==1'b1) TNextSt<=TST_TCALS;
                else if(GoTrwlp==1'b1) TNextSt<=TST_TRWLP;
                else TNextSt<=TST_IDLE;
            end
            else TNextSt<=TST_TRWHP;
        default : TNextSt<=TST_IDLE;
    endcase
end
//**************************************************************

//**************************************************************
//Timing Counter
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        TCALSCnt<=0;
        TRWLPCnt<=0;
        TRWHPCnt<=0;
        TADLTWBCnt <=0;
    end
    else begin
        case(TNextSt) // synopsys parallel_case
            TST_IDLE  : begin
                TCALSCnt<=0;
                TRWLPCnt<=0;
                TRWHPCnt<=0;
                TADLTWBCnt <=0;
            end
            TST_TADLTWB : begin
                TADLTWBCnt<=TADLTWBCnt+1;
                TCALSCnt<=0;
                TRWLPCnt<=0;
                TRWHPCnt<=0;
            end
            TST_TCALS : begin
                TCALSCnt<=TCALSCnt+1;
                TRWLPCnt<=0;
                TRWHPCnt<=0;
                TADLTWBCnt <=0;
            end
            TST_TRWLP : begin
                TRWLPCnt<=TRWLPCnt+1;
                TCALSCnt<=0;
                TRWHPCnt<=0;
                TADLTWBCnt <=0;
            end
            TST_TRWHP : begin
                TRWHPCnt<=TRWHPCnt+1;
                TCALSCnt<=0;
                TRWLPCnt<=0;
                TADLTWBCnt <=0;
            end
            default   : begin
                TCALSCnt<=0;
                TRWLPCnt<=0;
                TRWHPCnt<=0;
                TADLTWBCnt <=0;
            end
        endcase
    end
end

//**************************************************************
// CLE,ALE,nREn,nWEn Generation 
reg         nNFREOut;
reg         nNFWEOut;
reg         CLEOut;
reg         ALEOut;
reg         nNFCE0Out;       
reg         nNFCE1Out;       
reg [15:0]  NFDataOut;
//reg [ 7:0]  Command,Address;
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        CLEOut   <=1'b0;
        ALEOut   <=1'b0;
        nNFREOut <=1'b1;
        nNFWEOut <=1'b1;
        nNFCE0Out<=1'b1;      
        nNFCE1Out<=1'b1;       
    end
    else begin
        if(NST_Idle==1'b1) begin
            CLEOut   <=1'b0;
            ALEOut   <=1'b0;
            nNFREOut <=1'b1;
            nNFWEOut <=1'b1;
        end
        else if(NST_Load==1'b1) begin
            CLEOut   <=1'b0;
            ALEOut   <=1'b0;
            nNFREOut <=1'b1;
            nNFWEOut <=1'b1;
        end
        else if(NST_Cmd==1'b1)   begin
            CLEOut<=1'b1;
        end
        else CLEOut<=1'b0;

        if(NST_Addr==1'b1) begin
            ALEOut<=1'b1;
        end
        else ALEOut<=1'b0;
        
        // Chip Enable
        if(NST_Idle==1'b1) begin
            if(Continue==1'b1 || RnBWait==1'b1) begin
                nNFCE0Out<=nNFCE0Out;      
                nNFCE1Out<=nNFCE1Out;       
            end
            else begin
                nNFCE0Out<=1'b1;      
                nNFCE1Out<=1'b1;       
            end
        end
        else if(NST_Cmd==1'b1 || NST_Addr==1'b1 || NST_Wdata==1'b1 || NST_Rdata==1'b1 || 
                NST_Load==1'b1 || NST_Wait2Clk || NST_RnBCheck) begin
            if(ChipSel==1'b0) begin
                nNFCE0Out<=1'b0;
                nNFCE1Out<=1'b1;            
            end
            else begin
                nNFCE0Out<=1'b1;
                nNFCE1Out<=1'b0;
            end
        end
/*        else if(NST_Wait2Clk) begin
            if(ChipSel==1'b0) begin
                nNFCE0Out<=1'b0;
                nNFCE1Out<=1'b1;            

            end
            else begin
                nNFCE0Out<=1'b1;
                nNFCE1Out<=1'b0;
            end
        end
*/
        // Read Enable
        if(NTST_Trwlp==1'b1) begin
            if(NST_Cmd==1'b1 || NST_Addr==1'b1 || NST_Wdata==1'b1) 
                nNFWEOut<=1'b0;
            else if(NST_Rdata==1'b1)
                nNFREOut<=1'b0;
        end
        else if(NTST_Trwhp==1'b1)begin
            nNFWEOut<=1'b1;
            nNFREOut<=1'b1;
        end
    end
end
//**************************************************************


//**************************************************************
// NAND Flash Write data generation
reg [63:0]  ByteShift;
//reg [15:0]  EccData;
reg         NFDataOutEnOut;
//assign NFDataOutEnOut = (CST_Wdata || CST_Cmd || CST_Addr) ? 1'b : 1'b0;

always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        NFDataOutEnOut<=1'b1;   
    end
    else begin
        if(NST_Wdata || NST_Cmd || NST_Addr) NFDataOutEnOut<=1'b0;
        else NFDataOutEnOut<=1'b1;
    end
end



always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        NFDataOut<=0;
        ByteShift<=0;
        NextCmd<=0;
    end
    else begin
        if( TRWLPCnt==(TRWLP+1) && (NST_Cmd==1'b1 || NST_Addr==1'b1) ) begin
//            NextCmd<=NextCmd<<1; 
            NextCmd<=NextCmd>>1;//12.18
//            ByteShift<=ByteShift<<8;            
            ByteShift<=ByteShift>>8;//12.18            
        end

//        if(NST_Load==1'b1) begin //1.5
        if(NST_Load==1'b1) begin
//            ByteShift<={CmdAddr1,CmdAddr2};
            ByteShift<={CmdAddr2,CmdAddr1};
            NextCmd<=CmdAddrFlag;
        end
        else if((NTST_Tcals==1'b1 || TrwhpEnd==1'b1) && NST_Cmd==1'b1) begin
//            if(OutDtmn==1'b1) NFDataOut<={ByteShift[63:56],ByteShift[63:56]};
//            else              NFDataOut<={8'h00,ByteShift[63:56]};
            if(OutDtmn==1'b1) NFDataOut<={ByteShift[7:0],ByteShift[7:0]};//12.18
            else              NFDataOut<={8'h00,ByteShift[7:0]};//12.18
        end
        else if(TrwhpEnd==1'b1 && NST_Addr==1'b1) begin
//            if(OutDtmn==1'b1) NFDataOut<={ByteShift[63:56],ByteShift[63:56]};
//            else              NFDataOut<={8'h00,ByteShift[63:56]};
            if(OutDtmn==1'b1) NFDataOut<={ByteShift[7:0],ByteShift[7:0]};//12.18
            else              NFDataOut<={8'h00,ByteShift[7:0]};//12.18
        end
        //else if(TrwhpEnd==1'b1 && NST_Wdata==1'b1) begin
        else if(CTST_Trwlp!=1'b1 && NTST_Trwlp==1'b1 && NST_Wdata==1'b1) begin
/*            if(IOWidth==1'b0) begin
                NFDataOut[7:0]<=NFOutData[7:0];
            end
            else begin
                NFDataOut<=NFOutData;
            end*/
            if(AutoEccWrEnIn==1'b1) begin
                if(BoundaryIn==1'b1) NFDataOut<={NFOutData[15:8],EccIn[7:0]};
                else NFDataOut<=EccIn;
            end
            else NFDataOut<=NFOutData;
        end
    end
end


//**************************************************************

// synopsys translate_off
reg [8*10 : 1] NState;
always @(NextState)
begin 
    case(NextState) 
        ST_IDLE     : NState = "ST_IDLE      ";
        ST_LOAD     : NState = "ST_LOAD      ";
        ST_CMD      : NState = "ST_CMD       ";
        ST_ADDR     : NState = "ST_ADDR      ";
        ST_RNBCHECK : NState = "ST_RNBCHECK  ";
        ST_WAIT2CLK : NState = "ST_WAIT2CLk  ";
        ST_WDATA    : NState = "ST_WDATA     ";
        ST_RDATA    : NState = "ST_RDATA     ";
    endcase
end

reg [8*10 : 1] CState;
always @(CurrentState)
begin  
    case(CurrentState) 
        ST_IDLE     : CState = "ST_IDLE      ";
        ST_LOAD     : CState = "ST_LOAD      ";
        ST_CMD      : CState = "ST_CMD       ";
        ST_ADDR     : CState = "ST_ADDR      ";
        ST_RNBCHECK : CState = "ST_RNBCHECK  ";
        ST_WAIT2CLK : CState = "ST_WAIT2CLk  ";
        ST_WDATA    : CState = "ST_WDATA     ";
        ST_RDATA    : CState = "ST_RDATA     ";
    endcase
end


reg [8*10 : 1] TNState;
always @(TNextSt)
begin 
    case(TNextSt) 
        TST_IDLE    : TNState = "IDLE "; 
        TST_TADLTWB : TNState = "TADLTWB ";
        TST_TCALS   : TNState = "TCALS";
        TST_TRWLP   : TNState = "TRWLP";
        TST_TRWHP   : TNState = "TRWHP";
    endcase
end

reg [8*10 : 1] TCState;
always @(TCurrentSt)
begin  
    case(TCurrentSt) 
        TST_IDLE    : TCState = "IDLE "; 
        TST_TADLTWB : TCState = "TADLTWB ";
        TST_TCALS   : TCState = "TCALS";
        TST_TRWLP   : TCState = "TRWLP";
        TST_TRWHP   : TCState = "TRWHP";
    endcase
end

// synopsys translate_on
   


endmodule





