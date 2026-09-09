//************************************************
// Project     : NAND FLASH CONTROLLER 
// Date        : 2006/10/23
// author      : 
// Description : Nand flash booting
// module name : NFBoot.v
// history     :
//
//************************************************
`timescale 1ns/10ps

module NFBoot(
    Clk,
    nRst,

    NFBootIn,
    IOWidthIn,
    NandWidthIn,
    BootCfgIn,
    
    BootOpRdEnIn,
    BootOpReadyOut,
    BootOpOut,
    BootEndOut
);

input           Clk;
input           nRst;
input           NFBootIn;
input           IOWidthIn;
input           NandWidthIn;
input [ 1:0]    BootCfgIn;

input           BootOpRdEnIn;
output          BootOpReadyOut;
output[31:0]    BootOpOut;
output          BootEndOut;
//output[12:0]    TransSizeOut;
//output[31:0]    CmdorAddOut;
//***********************************
//NAND FLASH Boot size total 8KByte
//***********************************
//
//    CE0에 붙은 nand flash의 first block 8kbyte를 Read한다.
//
// one chip interface
//  * bus width 8bit
//      page size 512   : iteration value = 16
//      page size 2048  : iteration value = 4
//  * bus width 16bit
//      page size 512(256word)   : iteration value = 16
//      page size 2048(1024word) : iteration vaule = 4
//
// Two chip interface
//  * bus width 16bit
//      page size 512   : iteration vaule = 8
//      page size 2048  : iteration vaule = 2

// NFBootIn
// 1: nand boot enable 0: nomal mode

// IOWidthIn
// 0: 8bit bus width   1: 16bit bus width

// NFWidthPinIn
// 0: 8bit nand  1: 16bit nand

// BootCfgIn
//  00: 3 addr cycle => 1column+2row (512page)
//  01: 4 addr cycle => 1column+3row (512page)
//  10: 4 addr cycle => 2column+2row (2048page)
//  11: 5 addr cycle => 2column+3row (2048page)

// OutDtmnPinIn
// 0: higher 8bit == 0 1: higher 8bit == lower 8bit

// first NFOPER
// NFOPER[21]/NFOPER[20]/NFOPER[19]/NFOPER[18:16]/NFOPER[15:13]/NFOPER[12:11]/NFOPER[10:8]/NFOPER[7:0] 
// CE        /RnbWait   /AutoRdStat/FIFOLevel    /OpMode       /TransferSize /TransferByte/CmdAddrFlag
// 0         /0         /0         /111          /000(RdData)  /10(WORD size)/            /
//
// BootCfgIn :: TransferByte                                               :: CmdAddrFlag(0:Addr 1:CMD)
// 00           :: 011 4byte(CMD(00h)+CAddr+RAddr+RAddr)                      :: 4'b1000
// 01           :: 100 5byte(CMD(00h)+CAddr+RAddr+RAddr+RAddr)                :: 8'b10000xxx
// 10           :: 101 6byte(CMD(00h)+CAddr+CAddr+RAddr+RAddr+CMD(30h))       :: 8'b100001xx
// 11           :: 110 7byte(CMD(00h)+CAddr+CAddr+RAddr+RAddr+RAddr+CMD(30h)) :: 8'b10000001x

// second NFOPER
// DataSize[12:0]
// NandWidthIn   :: BootCfgIn[1]    :: IOWidthIn    :: DataSize
// 0(8bit  nand) :: 0( 512 page)    :: 0( 8bit)     :: 512  byte
// 0(8bit  nand) :: 0( 512 page)    :: 1(16bit)     :: 512  byte
// 0(8bit  nand) :: 1(2048 page)    :: 0( 8bit)     :: 2048 byte
// 0(8bit  nand) :: 1(2048 page)    :: 1(16bit)     :: 2048 byte
// 1(16bit nand) :: 0( 512 page)    :: 0( 8bit)     :: ----Prohibit----
// 1(16bit nand) :: 0( 512 page)    :: 1(16bit)     :: 256  half word
// 1(16bit nand) :: 1(2048 page)    :: 0( 8bit)     :: ----Prohibit----
// 1(16bit nand) :: 1(2048 page)    :: 1(16bit)     :: 1024 half word

parameter   RDCMD1=8'h00;
parameter   RDCMD2=8'h30;

reg         NFBootEnd;

reg [ 2:0]  SendCnt;
reg [ 4:0]  IterationCnt;
reg [ 4:0]  IterationSize;

reg [11:0]  DataSize;

wire[63:0]  CmdorAddr;
wire[ 2:0]  Analyze;
wire[ 7:0]  CAddr1,CAddr2;
wire[ 7:0]  RAddr1,RAddr2,RAddr3;

wire[ 2:0]  SendWord;

assign Analyze  = {NandWidthIn,BootCfgIn[1],IOWidthIn};
assign SendWord = (BootCfgIn==00) ? 3'd3 : 3'd4;

assign CAddr1 = 8'h00;
assign CAddr2 = 8'h00;

assign RAddr1 = {4'b0000,IterationCnt[3:0]};
assign RAddr2 = 8'h00;
assign RAddr3 = 8'h00;

//TransferByte;
wire[ 3:0]  TransferByte;
wire[ 7:0]  CmdAddrFlag;


assign BootOpReadyOut = (NFBootIn & ~NFBootEnd) ? 1'b1 : 1'b0; 
assign BootEndOut = NFBootEnd;

assign TransferByte = (BootCfgIn==2'b00) ? 4'b0100 :
                      (BootCfgIn==2'b01) ? 4'b0101 :
                      (BootCfgIn==2'b10) ? 4'b0110 : 
                                           4'b0111 ;
/*
assign CmdAddrFlag  = (BootCfgIn==2'b00) ? 8'b1000_0000 :
                      (BootCfgIn==2'b01) ? 8'b1000_0000 :
                      (BootCfgIn==2'b10) ? 8'b1000_0100 : 
                                           8'b1000_0010 ;
*/                                       
/*
assign CmdorAddr    = (BootCfgIn==2'b00) ? {RDCMD1,CAddr1,RAddr1,RAddr2,32'd0} :
                      (BootCfgIn==2'b01) ? {RDCMD1,CAddr1,RAddr1,RAddr2,RAddr3,32'd0} :
                      (BootCfgIn==2'b10) ? {RDCMD1,CAddr1,CAddr2,RAddr1,RAddr2,RDCMD2,16'd0} :
                                           {RDCMD1,CAddr1,CAddr2,RAddr1,RAddr2,RAddr3,RDCMD2,8'd0} ;
*/                                       
assign CmdAddrFlag  = (BootCfgIn==2'b00) ? 8'b0000_0001 :
                      (BootCfgIn==2'b01) ? 8'b0000_0001 :
                      (BootCfgIn==2'b10) ? 8'b0010_0001 : 
                                           8'b0100_0001 ;

assign CmdorAddr    = (BootCfgIn==2'b00) ? {32'd0,RAddr2,RAddr1,CAddr1,RDCMD1} :
                      (BootCfgIn==2'b01) ? {24'd0,RAddr3,RAddr2,RAddr1,CAddr1,RDCMD1} :
                      (BootCfgIn==2'b10) ? {16'd0,RDCMD2,RAddr2,RAddr1,CAddr2,CAddr1,RDCMD1} :
                                           {8'd0 ,RDCMD2,RAddr3,RAddr2,RAddr1,CAddr2,CAddr1,RDCMD1} ;

//IterationSize ,DataSize calc
always @(NandWidthIn or BootCfgIn or IOWidthIn)
begin
    case({NandWidthIn,BootCfgIn[1],IOWidthIn}) // synopsys parallel_case
        3'b000: begin // 8bit nand,512page ,8bit  width
            IterationSize <=5'd15;
            DataSize      <=12'd512;
        end
        3'b001: begin // 8bit nand,512page ,16bit width
            IterationSize <=5'd7;
            DataSize      <=12'd512;
        end
        3'b010: begin // 8bit nand,2048page,8bit  width
            IterationSize <=5'd3; 
            DataSize      <=12'd2048;
        end
        3'b011: begin // 8bit nand,2048page,16bit width
            IterationSize <=5'd1; 
            DataSize      <=12'd2048;
        end
//            3'b100: begin // 16bit nand,256page ,8bit  width ===> prohibit
//                IterationSize<=0;
//                DataSize<=0;
//            end
        3'b101: begin // 16bit nand,256page ,16bit width
            IterationSize <=5'd15; 
            DataSize      <=12'd256;
        end
//            3'b110: begin // 16bit nand,1024page,8bit  width ===> prohibit
//                IterationSize<=0;
//                DataSize<=0;
//            end
        3'b111: begin // 16bit nand,1024page,16bit width
            IterationSize <=5'd3; 
            DataSize      <=12'd1024;
        end
        default : begin
            IterationSize<=0;
            DataSize<=0;
        end
    endcase
end

// First NFOPER
// NFOPER[31]/NFOPER[30]/NFOPER[29]/NFOPER[28:17]/NFOPER[16:14]/NFOPER[13:12]/NFOPER[11:8]/NFOPER[7:0] 
// CE        /RnbWait   /AutoRdStat/DataSize     /OpMode       /TransferSize /TransferByte/CmdAddrFlag
// 0         /0         /0         /PageSize만큼 /000(RdData)  /10(WORD size)/            /

//Operation data calculation
wire[31:0]  WhatOper;
                   //CE /RnBWait/AutoRdStat/DataSize/OpMode/TransSize/TransferByte/CmdAddrFlag 
assign WhatOper  = {1'b0,1'b0   ,1'b0      ,DataSize,3'b000,2'b10    ,TransferByte,CmdAddrFlag};

/*
assign BootOpOut = (SendCnt==2'b00) ? {10'd0,WhatOper} :
                   (SendCnt==2'b01) ? CmdorAddr[63:32] : CmdorAddr[31:0 ] ;
*/               
assign BootOpOut = (SendCnt==2'b00) ? {10'd0,WhatOper} :
                   (SendCnt==2'b01) ? CmdorAddr[31:0] : CmdorAddr[63:32] ;

always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        SendCnt<=0;
        IterationCnt<=0;
        NFBootEnd<=0;
    end
    else begin
        if(BootOpRdEnIn) begin
            if(SendCnt!=2) begin
                SendCnt<=SendCnt+1;
            end
            else begin
                SendCnt<=0;
                if(IterationCnt != IterationSize) begin
                    IterationCnt<=IterationCnt+1;
                    NFBootEnd<=1'b0;
                end
                else 
                    NFBootEnd<=1'b1;
            end
        end
    end
end

endmodule
