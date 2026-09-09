//************************************************
// Project     : NAND FLASH CONTROLLER 
// Date        : 2006/10/23
// author      : 
// Description : APB interface
// module name : NFAPBif.v
// history     :
//
//************************************************
`timescale 1ns/10ps
module NFAPBIF(
	PCLK		    ,
	PRESETn 	    ,
	PADDR   	    ,
	PSEL    	    ,
	PENABLE 	    ,
	PWRITE  	    ,
	PWDATA  	    ,
	PRDATA  	    ,
    
    //External Configuration Pin input
    NFBootPinIn    ,
    IOWidthPinIn    ,
    NandWidthPinIn  ,
    BootCfgPinIn    ,
    OutDtmnPinIn    ,

    IntReqOut       ,
    //ECC
    ECCSECTOR0      , 
    ECCSECTOR1      , 
    ECCSECTOR2      , 
    ECCSECTOR3      , 
    ECCSECTOR4      , 
    ECCSECTOR5      , 
    ECCSECTOR6      , 
    ECCSECTOR7      , 
    ECCSECTOR8      , 
    ECCSECTOR9      , 
    ECCSECTOR10     , 
    ECCSECTOR11     , 
    ECCSECTOR12     , 
    ECCSECTOR13     , 
    ECCSECTOR14     , 
    ECCSECTOR15     , 
                
    SECCSECTOR0     ,
    SECCSECTOR1     ,
    SECCSECTOR2     ,
    SECCSECTOR3     ,
    SECCSECTOR4     ,
    SECCSECTOR5     ,
    SECCSECTOR6     ,
    SECCSECTOR7     ,
     
    
    // Status input
    NFCtrlBusyIn    ,
    NFStatValidIn   ,
    NFStatusIn      ,
    WrEndIn         , 
    RdEndIn         ,   
    RdFIFOReadyIn   ,   
    WrFIFOReadyIn   ,
    FiltRnB1In      ,
    FiltRnB0In      ,

    // Data FIFO R/W
    FIFOFlushIn     ,
    FIFORdDataOut   ,
    FIFORdDataEnIn  ,
    FIFOWrDataIn    ,
    FIFOWrDataEnIn  ,

    BeforeFullOut   ,
    FIFORdReadyOut  ,
    FIFOFullOut     ,
    FIFOHalfFullOut ,
    FIFOEmpty1Out   ,
    FIFOEmpty0Out   ,
    WrRdyOut        ,
    RdRdyOut        ,

    //Operation Read
    NFOpRdEnIn      ,
    NFOpOut         ,
    QLevelOut       ,
       
    //NFCTRL,NFCONF out
    ControlOut      ,
    ConfigOut       );

// APB interface   
input           PCLK;
input           PRESETn;
input [ 6:2]    PADDR;
input           PSEL;
input           PENABLE;
input           PWRITE;
input [31:0]    PWDATA;
output[31:0]    PRDATA;
//

input           NFBootPinIn;
input           IOWidthPinIn;
input           NandWidthPinIn;
input [1:0]     BootCfgPinIn;
input           OutDtmnPinIn;

output          IntReqOut;

input[23:0]     ECCSECTOR0;  //offset 0x14
input[23:0]     ECCSECTOR1;  //offset 0x18
input[23:0]     ECCSECTOR2;  //offset 0x1c
input[23:0]     ECCSECTOR3;  //offset 0x20
input[23:0]     ECCSECTOR4;  //offset 0x24
input[23:0]     ECCSECTOR5;  //offset 0x28
input[23:0]     ECCSECTOR6;  //offset 0x2c
input[23:0]     ECCSECTOR7;  //offset 0x30
input[23:0]     ECCSECTOR8;  //offset 0x34
input[23:0]     ECCSECTOR9;  //offset 0x38
input[23:0]     ECCSECTOR10; //offset 0x3c
input[23:0]     ECCSECTOR11; //offset 0x40
input[23:0]     ECCSECTOR12; //offset 0x44
input[23:0]     ECCSECTOR13; //offset 0x48
input[23:0]     ECCSECTOR14; //offset 0x4c
input[23:0]     ECCSECTOR15; //offset 0x50

input[15:0]     SECCSECTOR0; //offset 0x54
input[15:0]     SECCSECTOR1; //offset 0x58
input[15:0]     SECCSECTOR2; //offset 0x5c
input[15:0]     SECCSECTOR3; //offset 0x60
input[15:0]     SECCSECTOR4; //offset 0x64
input[15:0]     SECCSECTOR5; //offset 0x68
input[15:0]     SECCSECTOR6; //offset 0x6c
input[15:0]     SECCSECTOR7; //offset 0x70



    // Status input
input           NFCtrlBusyIn ;
input           NFStatValidIn;
input [15:0]    NFStatusIn   ;
input           WrEndIn      ;
input           RdEndIn      ;  
input           RdFIFOReadyIn;  
input           WrFIFOReadyIn;  
input           FiltRnB1In   ;
input           FiltRnB0In   ;

    // Data FIFO R/W
input           FIFOFlushIn    ; 
output[31:0]    FIFORdDataOut  ; 
input           FIFORdDataEnIn ; 
input [31:0]    FIFOWrDataIn   ; 
input           FIFOWrDataEnIn ; 

output          BeforeFullOut  ;
output          FIFORdReadyOut ;
output          FIFOFullOut    ; 
output          FIFOHalfFullOut;
output          FIFOEmpty0Out  ; 
output          FIFOEmpty1Out  ; 
output          WrRdyOut       ;
output          RdRdyOut       ;

    //Operation Read
input           NFOpRdEnIn ;    
output[31:0]    NFOpOut    ; 
output[ 3:0]    QLevelOut  ;


output[13:0]    ControlOut  ;
output[18:0]    ConfigOut  ;

parameter       QSIZE=8;


reg [31:0]      PRDATA;
// NAND Flash ctrl reg
//reg [31:0]      NFOPER;      //offset 0x00
//reg [31:0]      NFDATA;      //offset 0x04
wire[31:0]      NFCONF;      //offset 0x08
wire[31:0]      NFCTRL;      //offset 0x0c
wire[31:0]      NFSTAT;      //offset 0x10
wire[11:0]      NFFIFOSTAT;  //offset 0x14
//*********************************************
//
//
//*********************************************


wire[ 3:0] QLevel;

reg[12:0]       Timing; //NFCONF
reg[12:0]       Ctrl  ; //NFCTRL

//status reg
reg             NFStatValid;   
reg             WrEnd      ;    
reg             RdEnd      ;      
reg             RnBDetect1 ;   
reg             RnBDetect0 ;   
reg             RnB1       ;   
reg             RnB0       ;
wire[ 2:0]      FIFOLevel ;
wire            FIFOWrEn  ;
wire            FIFORdEn  ;
wire[31:0]      FIFOWrData;
wire[31:0]      FIFORdData;

reg             NFCtrlRst;

assign ConfigOut = NFCONF[18:0];
assign ControlOut = {NFCtrlRst,Ctrl};

assign QLevelOut = QLevel;

wire APBWriteEn;
wire APBReadEn;
assign APBWriteEn = PSEL & PENABLE &  PWRITE;
assign APBReadEn  = PSEL & ~PENABLE & ~PWRITE;

wire QWrEn;
assign QWrEn = (APBWriteEn==1'b1 && PADDR[6:2]==5'd0) ? 1'b1 : 1'b0;
wire FIFORst;
assign FIFORst = FIFOFlushIn | NFCtrlRst;

wire[3:0] FIFOCnt1;
wire[3:0] FIFOCnt0;
// NFOER Reg control
// Command Queue FIFO control
NFCmdQ uNFCmdQ(
    .Clk          (PCLK       ),
    .nRst         (PRESETn    ),
    .NFCtrlRstIn  (NFCtrlRst  ),
    .QWrEnIn      (QWrEn      ),
    .QRdEnIn      (NFOpRdEnIn ),
    .QWrDataIn    (PWDATA     ),
    .QRdDataOut   (NFOpOut    ),
    .QLevelOut    (QLevel     ));

// NFDATA Reg Control
// DATA FIFO
NFDFIFO uNFDFIFO(    
    .Clk            (PCLK           ), 
    .nRst           (PRESETn        ), 
  
    .FIFOFlushIn    (FIFORst        ),
    .FIFOLevelIn    (FIFOLevel      ),
    .FIFOWrEnIn     (FIFOWrEn       ),
    .FIFORdEnIn     (FIFORdEn       ),
    .FIFOWrDataIn   (FIFOWrData     ),
    .FIFORdDataOut  (FIFORdData     ),
    
    .FIFOCnt1       (FIFOCnt1       ),
    .FIFOCnt0       (FIFOCnt0       ),
    .WrRdyOut       (WrRdyOut       ),
    .RdRdyOut       (RdRdyOut       ),

    .BeforeFullOut  (BeforeFullOut  ),
    .FIFORdReadyOut (FIFORdReadyOut ),
    .FIFOFullOut    (FIFOFullOut    ),
    .FIFOHalfFullOut(FIFOHalfFullOut),
    .FIFOEmpty1Out  (FIFOEmpty1Out  ),
    .FIFOEmpty0Out  (FIFOEmpty0Out  ));
//NFData FIFO Control
//reg     FIFOFull0;
//reg     FIFOFull1;

assign FIFOWrEn   = ((APBWriteEn && PADDR[6:2]==5'd1) || FIFOWrDataEnIn == 1'b1) ? 1'b1 : 1'b0;

assign FIFOWrData = (APBWriteEn && PADDR[6:2]==5'd1) ? PWDATA : FIFOWrDataIn;

assign FIFORdEn  = ((APBReadEn && PADDR[6:2]==5'd1) || FIFORdDataEnIn == 1'b1) ? 1'b1 : 1'b0;

assign FIFORdDataOut = FIFORdData;
assign FIFOLevel  = Ctrl[12:10];


// INTERRUPT Req
reg IntReqOut;
//reg IntEn;
//reg IntEnDly;

reg WrEnd_Dly;
reg RdEnd_Dly;
reg WrFIFOReady_Dly;
reg RdFIFOReady_Dly;
reg RnB1_Dly;
reg RnB0_Dly;


always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn) begin
        WrEnd_Dly<=0;
        RdEnd_Dly<=0;
        WrFIFOReady_Dly<=0;
        RdFIFOReady_Dly<=0;
    end
    else begin
        WrEnd_Dly<=WrEndIn;
        RdEnd_Dly<=RdEndIn;
        WrFIFOReady_Dly<=WrFIFOReadyIn;
        RdFIFOReady_Dly<=RdFIFOReadyIn;
    end
end

// rising edge 
always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn) begin
        IntReqOut<=0;
    end
    else begin
        if( (Ctrl[5] && WrEndIn==1'b1 && WrEnd_Dly==1'b0) || 
            (Ctrl[4] && RdEndIn==1'b1 && RdEnd_Dly==1'b0) ||
            (Ctrl[2] && ( (WrFIFOReadyIn==1'b1 && WrFIFOReady_Dly==1'b0) || 
                          (RdFIFOReadyIn==1'b1 && RdFIFOReady_Dly==1'b0) )) ||
            (Ctrl[1] && FiltRnB1In==1'b1 && RnB1_Dly==1'b0) || 
            (Ctrl[0] && FiltRnB0In==1'b1 && RnB0_Dly==1'b0) )
            IntReqOut<=1'b1;
        else IntReqOut<=1'b0;
    end
end


//******************************************
//          NFSTAT Reg Control
//******************************************

//-------------- NFStatValid
always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn) begin
        NFStatValid<=0;
    end
    else begin
        if(APBWriteEn && PADDR[6:2]==5'd4 && PWDATA[24]==1'b1) NFStatValid<=1'b0;
        else NFStatValid<= NFStatValid | NFStatValidIn;
    end
end
//-------------- write End status
always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn) begin
        WrEnd<=0;
    end
    else begin
        if(APBWriteEn && PADDR[6:2]==5'd4 && PWDATA[7]==1'b1) WrEnd<=1'b0;
        else WrEnd <= WrEnd | WrEndIn ;
    end
end
//-------------- read End status
always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn) begin
        RdEnd<=0;
    end
    else begin
        if(APBWriteEn && PADDR[6:2]==5'd4 && PWDATA[6]==1'b1) RdEnd<=1'b0;
        else RdEnd <= RdEnd | RdEndIn ;
    end
end
//-------------- RnB Detect1 Status
always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn) begin
        RnB1_Dly   <=1;
        RnBDetect1 <=0;
    end
    else begin
        RnB1_Dly<=FiltRnB1In;
        if(APBWriteEn && PADDR[6:2]==5'd4 && PWDATA[3]==1'b1) RnBDetect1<=1'b0;
        else if(FiltRnB1In==1'b1 && RnB1_Dly==1'b0)  RnBDetect1<=1'b1;
    end
end
//-------------- RnB Detect0 Status
always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn) begin
        RnB0_Dly   <=1;
        RnBDetect0 <=0;
    end
    else begin
        RnB0_Dly<=FiltRnB0In;
        if(APBWriteEn && PADDR[6:2]==5'd4 && PWDATA[2]==1'b1) RnBDetect0<=1'b0;
        else if(FiltRnB0In==1'b1 && RnB0_Dly==1'b0)  RnBDetect0<=1'b1;
    end
end
//-------------- ready & busy status
always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn) begin
        RnB1<=0;
        RnB0<=0;
    end
    else begin
        RnB1 <= FiltRnB1In;
        RnB0 <= FiltRnB0In;
    end
end
//**************** NFSTAT Reg Control End ****************.



assign NFCONF = {13'd0,NFBootPinIn,IOWidthPinIn,NandWidthPinIn,BootCfgPinIn,OutDtmnPinIn,Timing};
assign NFCTRL = {17'd0,NFCtrlRst,Ctrl};
assign NFSTAT = {6'd0,NFCtrlBusyIn,NFStatValid,NFStatusIn,WrEnd,RdEnd,
                 WrFIFOReadyIn,RdFIFOReadyIn,RnBDetect1,RnBDetect0,RnB1,RnB0};
assign NFFIFOSTAT ={QLevel,FIFOCnt1,FIFOCnt0};

// NFCTRL
// {NFCtrlRst[10],NFIDByte[9:8],AutoEccWr[7],DMAEn[6],WrEndIntEn[5],RdEndIntEn[4],EccErrIntEn[3],FIFOIntEn[2],RnBIntEn1[1],RnBIntEn0[0]}

// Timing
// {TADLTWB,TACLS,TRWLP,TRWHP}

// NAND FLASH Memory Reg control

//******************************************
//              NFCTRL,NFCONF Control
//******************************************

reg[12:0]   Timing_conf;
reg[12:0]   Control;
always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn) begin
//        NFDATA<=32'd0;
        Timing_conf<={4'd15,3'd2,3'd2,3'd2};//TADLTWB,TACLS,TRWLP,TRWHP;
        //FIFOLEVEL,reserved,Ecc512ByteEn,AutoEccWr,DmaEn,WrEndIntEn,RdEndIntEn,Reserved,FIFOIntEn,ReServed,RnbInt0
        Control<={3'b111,1'b0,1'b0,1'b0,1'b1,6'd0};
        NFCtrlRst<=1'b0;
    end
    else begin
        if(APBWriteEn) begin
//            if(PADDR[6:2]==5'd1) NFDATA<=PWDATA;
            if(PADDR[6:2]==5'd2) Timing_conf<=PWDATA[12:0];
            else if(PADDR[6:2]==5'd3) begin 
                Control    <=PWDATA[12:0];
                NFCtrlRst  <=PWDATA[13];
            end
        end
        else NFCtrlRst<=0;
    end
end

always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn) begin
        Timing<={4'd15,3'd2,3'd2,3'd2};//TADLTWB,TACLS,TRWLP,TRWHP
        Ctrl  <={3'b111,1'b0,1'b0,1'b0,1'b1,6'd0};//DMA enable
    end
    else begin
        if(NFCtrlBusyIn!=1'b1) begin //NFCtrl == IDLE state
            Timing<=Timing_conf;
            Ctrl  <=Control;
        end
    end
end

//******************************************
//              Register Read
//******************************************
always @(posedge PCLK or negedge PRESETn)
begin
    if(!PRESETn) begin
        PRDATA<=0;
    end
    else begin
        if(APBReadEn)begin
            case(PADDR[6:2]) // synopsys parallel_case
                5'd0 :PRDATA<=0;
                5'd1 :PRDATA<=FIFORdData;
                5'd2 :PRDATA<=NFCONF;
                5'd3 :PRDATA<=NFCTRL;
                5'd4 :PRDATA<=NFSTAT;
                5'd5 :PRDATA<={20'd0,NFFIFOSTAT};
                5'd6 :PRDATA<=ECCSECTOR0; 
                5'd7 :PRDATA<=ECCSECTOR1;
                5'd8 :PRDATA<=ECCSECTOR2;
                5'd9 :PRDATA<=ECCSECTOR3;
                5'd10:PRDATA<=ECCSECTOR4;
                5'd11:PRDATA<=ECCSECTOR5;
                5'd12:PRDATA<=ECCSECTOR6;
                5'd13:PRDATA<=ECCSECTOR7;
                5'd14:PRDATA<=ECCSECTOR8; 
                5'd15:PRDATA<=ECCSECTOR9;
                5'd16:PRDATA<=ECCSECTOR10;
                5'd17:PRDATA<=ECCSECTOR11;
                5'd18:PRDATA<=ECCSECTOR12;
                5'd19:PRDATA<=ECCSECTOR13;
                5'd20:PRDATA<=ECCSECTOR14;
                5'd21:PRDATA<=ECCSECTOR15;
                
                5'd22:PRDATA<={16'd0,SECCSECTOR0};
                5'd23:PRDATA<={16'd0,SECCSECTOR1};
                5'd24:PRDATA<={16'd0,SECCSECTOR2};
                5'd25:PRDATA<={16'd0,SECCSECTOR3};
                5'd26:PRDATA<={16'd0,SECCSECTOR4};
                5'd27:PRDATA<={16'd0,SECCSECTOR5};
                5'd28:PRDATA<={16'd0,SECCSECTOR6};
                5'd29:PRDATA<={16'd0,SECCSECTOR7};
                
                default:PRDATA<=32'hxxxx_xxxx;
            endcase
        end
    end
end
endmodule
