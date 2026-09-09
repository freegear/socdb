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
	CLK		    ,
	RESETn 	    ,
	EXT_SFR_ADDR   	,
	EXT_SFR_WR  	,
	EXT_SFR_DOUT    ,
	EXT_SFR_DIN     ,

    CS              ,

    WDATA           ,
    RDATA           ,
    We              ,
    Oe              ,
    
    //External Configuration Pin input
	/*
    NFBootPinIn    ,
    IOWidthPinIn    ,
    NandWidthPinIn  ,
    BootCfgPinIn    ,
    OutDtmnPinIn    ,
	*/
    IntReqOut       ,
    
    // Status input
    NFCtrlBusyIn    ,
    NFStatValidIn   ,
    NFStatusIn      ,
    WrEndIn         , 
    RdEndIn         ,   
    RdFIFOReadyIn   ,   
    WrFIFOReadyIn   ,


    FiltRnB3In      ,       //07_06_19 : Register Revision
    FiltRnB2In      ,

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
    ControlOut0     ,
    ControlOut1     ,

    ConfigOut0      ,
    ConfigOut1      ,
    ConfigOut2      ,
    TransSize       );

// APB interface   
input           CLK;
input           RESETn;
input [ 3:0]    EXT_SFR_ADDR;
input           EXT_SFR_WR;
input [7:0]     EXT_SFR_DOUT;
output[7:0]     EXT_SFR_DIN;

input           CS;

input [7:0]     WDATA;
output[7:0]     RDATA;
input           We;
input           Oe;

//
/*
input           NFBootPinIn;
input           IOWidthPinIn;
input           NandWidthPinIn;
input [1:0]     BootCfgPinIn;
input           OutDtmnPinIn;*/
output          IntReqOut;

    // Status input
input           NFCtrlBusyIn ;
input           NFStatValidIn;
input [15:0]    NFStatusIn   ;
input           WrEndIn      ;
input           RdEndIn      ;  
input           RdFIFOReadyIn;  
input           WrFIFOReadyIn;


input           FiltRnB3In   ;         //07_06_19 : Register Revision 
input           FiltRnB2In   ;

input           FiltRnB1In   ;
input           FiltRnB0In   ;

    // Data FIFO R/W
input           FIFOFlushIn    ; 
output[15:0]    FIFORdDataOut  ; 
input           FIFORdDataEnIn ; 
input [15:0]    FIFOWrDataIn   ; 
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


output[7:0]    ControlOut0 ;
output[7:0]    ControlOut1 ;

output[7:0]    ConfigOut0 ;
output[7:0]    ConfigOut1 ;
output[7:0]    ConfigOut2 ;

input          TransSize;

wire[7:0]       EXT_SFR_DOUT;
reg [7:0]       EXT_SFR_DIN;
wire[7:0]       WDATA;
wire[7:0]       RDATA;

parameter       QSIZE=8;

reg [7:0] NFOPER0;
reg [7:0] NFOPER1;
reg [7:0] NFOPER2;
reg [7:0] NFOPER3;

wire[7:0]      NFCONF0;      //offset 0x08
wire[7:0]      NFCONF1;
wire[7:0]      NFCONF2;

wire[7:0]      NFCTRL0;      //offset 0x0c
wire[7:0]      NFCTRL1; 


wire[7:0]      NFSTAT0;      //offset 0x10
wire[7:0]      NFSTAT1;
wire[7:0]      NFSTAT2;
wire[7:0]      NFSTAT3;

wire[7:0]      NFFIFOSTAT0;  //offset 0x14
wire[7:0]      NFFIFOSTAT1;
//*********************************************
//
//
//*********************************************


wire[ 3:0] QLevel;

reg[7:0]       Timing0; //NFCONF
reg[4:0]       Timing1;

reg[7:0]       Ctrl0  ; //NFCTRL
reg[7:0]       Ctrl1  ;

//status reg
reg             NFStatValid;   
reg             WrEnd      ;    
reg             RdEnd      ;  

reg             RnBDetect3 ;                //07_06_19 : Register Revision 
reg             RnBDetect2 ;

reg             RnBDetect1 ;   
reg             RnBDetect0 ; 

reg             RnB3       ;                //07_06_19 : Register Revision 
reg             RnB2       ;

reg             RnB1       ;   
reg             RnB0       ;

wire[ 2:0]      FIFOLevel ;
wire            FIFOWrEn  ;
wire            FIFORdEn  ;
wire[15:0]      FIFOWrData;
wire[15:0]      FIFORdData;


wire [31:0] QWrData;

reg [1:0] FIFOWrCnt;
reg [1:0] FIFORdCnt;

reg [15:0] FIFOWrCollect;

wire [7:0] FIFOData;

wire      DivRdEn;

reg             NFCtrlRst;

assign ConfigOut0 = {NFCONF0[7:0]};
assign ConfigOut1 = {NFCONF1[7:0]};
assign ConfigOut2 = {5'b00000,NFCONF2[2:0]};

assign ControlOut0 = {Ctrl0[7:0]};
assign ControlOut1 = {1'b0,NFCtrlRst,Ctrl1[5:0]};

assign QLevelOut = QLevel;

wire RegWriteEn;
assign RegWriteEn = EXT_SFR_WR & CS;


reg [2:0] QWrCnt;

wire	NFOPER0_adr 	= (EXT_SFR_ADDR== 4'h0);
wire	NFOPER1_adr 	= (EXT_SFR_ADDR== 4'h1);
wire	NFOPER2_adr 	= (EXT_SFR_ADDR== 4'h2);
wire	NFOPER3_adr 	= (EXT_SFR_ADDR== 4'h3);
wire 	NFCONF0_adr 	= (EXT_SFR_ADDR==4'h5);
wire 	NFCONF1_adr 	= (EXT_SFR_ADDR==4'h6);
wire 	NFCONF2_adr 	= (EXT_SFR_ADDR==4'h7);
wire 	NFCTRL0_adr 	= (EXT_SFR_ADDR==4'h8);
wire 	NFCTRL1_adr 	= (EXT_SFR_ADDR==4'h9);
wire 	NFSTAT0_adr 	= (EXT_SFR_ADDR==4'hA);
wire 	NFSTAT1_adr 	= (EXT_SFR_ADDR==4'hB);
wire 	NFSTAT2_adr 	= (EXT_SFR_ADDR==4'hC);
wire 	NFSTAT3_adr 	= (EXT_SFR_ADDR==4'hD);
wire 	NFFIFOSTAT0_adr = (EXT_SFR_ADDR==4'hE);
wire 	NFFIFOSTAT1_adr = (EXT_SFR_ADDR==4'hF);

always @(posedge CLK or negedge RESETn)
    if(!RESETn)
        QWrCnt <= 0;
    else if(RegWriteEn==1'b1 && (NFOPER0_adr || NFOPER1_adr || NFOPER2_adr || NFOPER3_adr)) 
        QWrCnt <= QWrCnt + 1;
    else if(QWrCnt==4)
        QWrCnt <=0;

assign QWrData = {NFOPER3, NFOPER2, NFOPER1, NFOPER0};


always @(posedge CLK or negedge RESETn)
    if(!RESETn)
    begin
        NFOPER0 <= 8'd0;
        NFOPER1 <= 8'd0;
        NFOPER2 <= 8'd0;
        NFOPER3 <= 8'd0;
    end
    else if(RegWriteEn)
        if     (NFOPER0_adr) NFOPER0 <= EXT_SFR_DOUT;
        else if(NFOPER1_adr) NFOPER1 <= EXT_SFR_DOUT;
        else if(NFOPER2_adr) NFOPER2 <= EXT_SFR_DOUT;
        else if(NFOPER3_adr) NFOPER3 <= EXT_SFR_DOUT;


wire QWrEn;
assign QWrEn = (NFOPER3_adr && QWrCnt==4) ? 1'b1 : 1'b0;
wire FIFORst;
assign FIFORst = FIFOFlushIn | NFCtrlRst;

wire[3:0] FIFOCnt1;
wire[3:0] FIFOCnt0;
// NFOER Reg control
// Command Queue FIFO control
NFCmdQ uNFCmdQ(
    .Clk          (CLK       ),
    .nRst         (RESETn    ),
    .NFCtrlRstIn  (NFCtrlRst  ),
    .QWrEnIn      (QWrEn      ),
    .QRdEnIn      (NFOpRdEnIn ),
    .QWrDataIn    (QWrData    ),
    .QRdDataOut   (NFOpOut    ),
    .QLevelOut    (QLevel     ));

// NFDATA Reg Control
// DATA FIFO
NFDFIFO uNFDFIFO(    
    .Clk            (CLK           ), 
    .nRst           (RESETn        ), 
  
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

assign FIFOWrEn   =((We && TransSize==1'b1 && FIFOWrCnt==3'b001) || 
                    (We && TransSize==1'b0) || FIFOWrDataEnIn == 1'b1) ? 1'b1 : 1'b0;

assign FIFOWrData = (We && TransSize==1'b1) ? {WDATA,FIFOWrCollect[15:8]} : 
                    (We && TransSize==1'b0) ? {8'h00,WDATA} : FIFOWrDataIn;

assign FIFORdEn  = ((Oe && TransSize==1'b1 && FIFORdCnt==1) || 
                    (Oe && TransSize==1'b0) || FIFORdDataEnIn == 1'b1) ? 1'b1 : 1'b0;

assign FIFOData = (Oe && TransSize==1'b1 && FIFORdCnt==0) ? {FIFORdDataOut[7:0]} :
                  (Oe && TransSize==1'b1 && FIFORdCnt==1) ? {FIFORdDataOut[15:8]} : {FIFORdDataOut[7:0]} ;

assign FIFORdDataOut = FIFORdData;

assign FIFOLevel  = Ctrl1[4:2];

assign RDATA     = FIFOData;

always @(posedge CLK or negedge RESETn)
    if(!RESETn)
        FIFOWrCollect <= 16'h00;
    else begin
        if(We && TransSize==1'b1) 
            FIFOWrCollect <= {WDATA,FIFOWrCollect[15:8]};
    end

always @(posedge CLK or negedge RESETn)
    if(!RESETn)
        FIFOWrCnt <= 0;
    else if(FIFOWrCnt==2)
            FIFOWrCnt <= 0;
    else if(We)
            FIFOWrCnt <= FIFOWrCnt + 1;

always @(posedge CLK or negedge RESETn)
    if(!RESETn)
        FIFORdCnt <= 0;
    else if(TransSize==1'b1 && Oe && FIFORdCnt==1)
        FIFORdCnt <= 0;
    else if(TransSize==1'b1 && Oe)
        FIFORdCnt <= FIFORdCnt + 1;
    else if(TransSize==1'b0 && Oe)
        FIFORdCnt <= 0;



// INTERRUPT Req
reg IntReqOut;
//reg IntEn;
//reg IntEnDly;

reg WrEnd_Dly;
reg RdEnd_Dly;
reg WrFIFOReady_Dly;
reg RdFIFOReady_Dly;

reg RnB3_Dly;               //07_06_19 : Register Revision
reg RnB2_Dly;

reg RnB1_Dly;
reg RnB0_Dly;


always @(posedge CLK or negedge RESETn)
begin
    if(!RESETn) begin
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
always @(posedge CLK or negedge RESETn)
begin
    if(!RESETn) begin
        IntReqOut<=0;
    end
    else begin
        if( (Ctrl0[6] && WrEndIn==1'b1 && WrEnd_Dly==1'b0) || 
            (Ctrl0[5] && RdEndIn==1'b1 && RdEnd_Dly==1'b0) ||
            (Ctrl0[4] && ( (WrFIFOReadyIn==1'b1 && WrFIFOReady_Dly==1'b0) || 
                          (RdFIFOReadyIn==1'b1 && RdFIFOReady_Dly==1'b0) )) ||
            (Ctrl0[3] && FiltRnB3In==1'b1 && RnB3_Dly==1'b0) ||                      //07_06_19 : Register Revision
            (Ctrl0[2] && FiltRnB2In==1'b1 && RnB2_Dly==1'b0) ||
            (Ctrl0[1] && FiltRnB1In==1'b1 && RnB1_Dly==1'b0) || 
            (Ctrl0[0] && FiltRnB0In==1'b1 && RnB0_Dly==1'b0) )
            IntReqOut<=1'b1;
        else IntReqOut<=1'b0;
    end
end


//******************************************
//          NFSTAT Reg Control
//******************************************

//-------------- NFStatValid
always @(posedge CLK or negedge RESETn)
begin
    if(!RESETn) begin
        NFStatValid<=0;
    end
    else begin
        if(RegWriteEn && NFSTAT0_adr && EXT_SFR_DOUT[0]==1'b1) NFStatValid<=1'b0;
        else NFStatValid<= NFStatValid | NFStatValidIn;
    end
end
//-------------- write End status
always @(posedge CLK or negedge RESETn)
begin
    if(!RESETn) begin
        WrEnd<=0;
    end
    else begin
        if(RegWriteEn && NFSTAT0_adr && EXT_SFR_DOUT[7]==1'b1) WrEnd<=1'b0;
        else WrEnd <= WrEnd | WrEndIn ;
    end
end
//-------------- read End status
always @(posedge CLK or negedge RESETn)
begin
    if(!RESETn) begin
        RdEnd<=0;
    end
    else begin
        if(RegWriteEn && NFSTAT0 && EXT_SFR_DOUT[6]==1'b1) RdEnd<=1'b0;
        else RdEnd <= RdEnd | RdEndIn ;
    end
end


//-------------- RnB Detect3 Status
always @(posedge CLK or negedge RESETn)
begin
    if(!RESETn) begin
        RnB3_Dly   <=1;
        RnBDetect3 <=0;
    end
    else begin
        RnB3_Dly<=FiltRnB3In;
        if(RegWriteEn && NFSTAT3_adr && EXT_SFR_DOUT[7]==1'b1) RnBDetect3<=1'b0;
        else if(FiltRnB3In==1'b1 && RnB3_Dly==1'b0)  RnBDetect3<=1'b1;
    end
end
//-------------- RnB Detect2 Status
always @(posedge CLK or negedge RESETn)
begin
    if(!RESETn) begin
        RnB2_Dly   <=1;
        RnBDetect2 <=0;
    end
    else begin
        RnB2_Dly<=FiltRnB2In;
        if(RegWriteEn && NFSTAT3_adr && EXT_SFR_DOUT[6]==1'b1) RnBDetect2<=1'b0;
        else if(FiltRnB2In==1'b1 && RnB2_Dly==1'b0)  RnBDetect2<=1'b1;
    end
end


//-------------- RnB Detect1 Status

always @(posedge CLK or negedge RESETn)
begin
    if(!RESETn) begin
        RnB1_Dly   <=1;
        RnBDetect1 <=0;
    end
    else begin
        RnB1_Dly<=FiltRnB1In;
        if(RegWriteEn && NFSTAT3_adr && EXT_SFR_DOUT[5]==1'b1) RnBDetect1<=1'b0;
        else if(FiltRnB1In==1'b1 && RnB1_Dly==1'b0)  RnBDetect1<=1'b1;
    end
end
//-------------- RnB Detect0 Status

always @(posedge CLK or negedge RESETn)
begin
    if(!RESETn) begin
        RnB0_Dly   <=1;
        RnBDetect0 <=0;
    end
    else begin
        RnB0_Dly<=FiltRnB0In;
        if(RegWriteEn && NFSTAT3_adr==5'hD && EXT_SFR_DOUT[4]==1'b1) RnBDetect0<=1'b0;
        else if(FiltRnB0In==1'b1 && RnB0_Dly==1'b0)  RnBDetect0<=1'b1;
    end
end
//-------------- ready & busy status
always @(posedge CLK or negedge RESETn)
begin
    if(!RESETn) begin
        RnB3<=0;                         //07_06_19 : Register Revision 
        RnB2<=0;        

        RnB1<=0;
        RnB0<=0;
    end
    else begin
        RnB3 <= FiltRnB3In;               //07_06_19 : Register Revision 
        RnB2 <= FiltRnB2In;

        RnB1 <= FiltRnB1In;
        RnB0 <= FiltRnB0In;
    end
end
//**************** NFSTAT Reg Control End ****************.


wire	NFBootPinIn = 1'b0;
reg 	IOWidthPinIn;
reg		NandWidthPinIn;
reg [1:0]BootCfgPinIn ;
reg		OutDtmnPinIn ;


assign NFCONF0 = {Timing0[7:0]};
assign NFCONF1 = {BootCfgPinIn,OutDtmnPinIn,Timing1[4:0]};
assign NFCONF2 = {5'b00000,NFBootPinIn,IOWidthPinIn,NandWidthPinIn};

assign NFCTRL0 = {Ctrl0};
assign NFCTRL1 = {2'b0,NFCtrlRst,Ctrl1[4:0]};

assign NFSTAT0 = {WrEnd,RdEnd,WrFIFOReadyIn,RdFIFOReadyIn,2'b00,NFCtrlBusyIn,NFStatValid};
assign NFSTAT1 = {NFStatusIn[7:0]};
assign NFSTAT2 = {NFStatusIn[15:8]};
assign NFSTAT3 = {RnBDetect3,RnBDetect2,RnBDetect1,RnBDetect0,RnB3,RnB2,RnB1,RnB0};

assign NFFIFOSTAT0 ={FIFOCnt1,FIFOCnt0};
assign NFFIFOSTAT1 ={4'd0,QLevel};

// NFCTRL
// {NFCtrlRst[10],NFIDByte[9:8],AutoEccWr[7],DMAEn[6],WrEndIntEn[5],RdEndIntEn[4],EccErrIntEn[3],FIFOIntEn[2],RnBIntEn1[1],RnBIntEn0[0]}

// Timing
// {TADLTWB,TACLS,TRWLP,TRWHP}

// NAND FLASH Memory Reg control

//******************************************
//              NFCTRL,NFCONF Control
//******************************************

reg[7:0]    Timing_conf0;
reg[4:0]    Timing_conf1;

reg[7:0]    Control0;
reg[7:0]    Control1;

always @(posedge CLK or negedge RESETn)
begin
    if(!RESETn) begin
        Timing_conf0<={2'b10,3'b010,3'b010};//TADLTWB,TACLS,TRWLP,TRWHP;
        Timing_conf1<={4'b1111,1'b0};
		BootCfgPinIn <= 0;
		OutDtmnPinIn <= 0;
		IOWidthPinIn <= 0;
		NandWidthPinIn <= 0;
        Control0<={1'b1,7'd0};
        Control1<={2'b0,1'b0,3'b111,2'b00};
    
        NFCtrlRst<=1'b0;
    end
    else begin
        if(RegWriteEn) begin
            if(NFCONF0_adr) Timing_conf0<=EXT_SFR_DOUT;
            else if(NFCONF1_adr) 
					begin
					Timing_conf1<=EXT_SFR_DOUT[4:0];
					BootCfgPinIn <=EXT_SFR_DOUT[7:6];
					OutDtmnPinIn <= EXT_SFR_DOUT[5];
					end
			else if(NFCONF2_adr)	
					begin
					IOWidthPinIn <= EXT_SFR_DOUT[1];
					NandWidthPinIn <= EXT_SFR_DOUT[0];
					end
            else if(NFCTRL0_adr) Control0   <=EXT_SFR_DOUT;
            else if(NFCTRL1_adr) 
                begin
                    Control1   <=EXT_SFR_DOUT[4:0];
                    NFCtrlRst  <=EXT_SFR_DOUT[5];
                end
        end
        else NFCtrlRst<=0;
    end
end

always @(posedge CLK or negedge RESETn)
begin
    if(!RESETn) begin
         Timing0<={2'b10,3'b010,3'b010};//TADLTWB,TACLS,TRWLP,TRWHP
        Timing1<={4'b1111,1'b0};

        Ctrl0  <={1'b1,7'd0};//DMA enable
        Ctrl1  <={2'b0,1'b0,3'b111,1'b0,1'b0};
    end
    else begin
        if(NFCtrlBusyIn!=1'b1) begin //NFCtrl == IDLE state
            Timing0<=Timing_conf0;
            Timing1<=Timing_conf1;

            Ctrl0  <=Control0;
            Ctrl1  <=Control1;
        end
    end
end

//******************************************
//              Register Read
//******************************************


always @(NFOPER0_adr or NFOPER1_adr or NFOPER2_adr or NFOPER3_adr or   
NFCONF0_adr or NFCONF1_adr or NFCONF2_adr or NFCTRL0_adr or
NFCTRL1_adr or NFSTAT0_adr or NFSTAT1_adr or NFSTAT2_adr or
NFSTAT3_adr or NFFIFOSTAT0_adr or NFFIFOSTAT1_adr or
NFCONF0 or NFCONF1 or NFCTRL0 or NFCTRL1 or
NFSTAT0 or NFSTAT1 or NFSTAT2 or NFSTAT3 or NFFIFOSTAT0 or NFFIFOSTAT1)
begin
            case(1'b1) // synopsys parallel_case
			 NFOPER0_adr       	:EXT_SFR_DIN<=0;
             NFOPER1_adr       	:EXT_SFR_DIN<=0;
             NFOPER2_adr       	:EXT_SFR_DIN<=0;
             NFOPER3_adr       	:EXT_SFR_DIN<=0;
             NFCONF0_adr       	:EXT_SFR_DIN<=NFCONF0;
             NFCONF1_adr       	:EXT_SFR_DIN<=NFCONF1;
             NFCONF2_adr       	:EXT_SFR_DIN<=NFCONF2;
             NFCTRL0_adr       	:EXT_SFR_DIN<=NFCTRL0;
             NFCTRL1_adr       	:EXT_SFR_DIN<=NFCTRL1;
             NFSTAT0_adr       	:EXT_SFR_DIN<=NFSTAT0;
             NFSTAT1_adr       	:EXT_SFR_DIN<=NFSTAT1;
             NFSTAT2_adr       	:EXT_SFR_DIN<=NFSTAT2;
             NFSTAT3_adr       	:EXT_SFR_DIN<=NFSTAT3;
             NFFIFOSTAT0_adr 	:EXT_SFR_DIN<=NFFIFOSTAT0;
             NFFIFOSTAT1_adr	:EXT_SFR_DIN<=NFFIFOSTAT1;
                
                default:EXT_SFR_DIN<=8'h00;
            endcase
    end
endmodule

