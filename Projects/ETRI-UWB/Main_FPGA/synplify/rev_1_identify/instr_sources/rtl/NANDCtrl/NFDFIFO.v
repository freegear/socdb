// ==============================================================================
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from SANGHWA MICRO Technology
// ALL RIGHTS RESERVED SANGHWA MICRO Technology      
// ------------------------------------------------------------------------------
// Version and Release information:
// 
// File Name           : NFDFIFO.v
// File Revision       : 0.1
// ------------------------------------------------------------------------------
//  Purpose            : Nand Flash controller Data FIFO
// ==============================================================================
`timescale 1ns/10ps
//`define CHIP

module NFDFIFO(
    Clk             ,
    nRst            ,
    

    FIFOFlushIn     ,
    FIFOLevelIn     ,
    FIFOWrEnIn      ,
    FIFORdEnIn      ,
    FIFOWrDataIn    ,
    FIFORdDataOut   ,

    FIFOCnt1        ,
    FIFOCnt0        ,
    WrRdyOut        ,
    RdRdyOut        ,

    BeforeFullOut   ,
    FIFOFullOut     ,
    FIFOHalfFullOut ,
    FIFORdReadyOut  ,
//    FIFOFull1Out    ,
//    FIFOFull0Out    ,
    FIFOEmpty1Out   ,
    FIFOEmpty0Out   );

input           Clk;
input           nRst;

input           FIFOFlushIn;
input [ 2:0]    FIFOLevelIn;
input           FIFOWrEnIn;
input           FIFORdEnIn;
input [31:0]    FIFOWrDataIn;
output[31:0]    FIFORdDataOut;

output[ 3:0]    FIFOCnt1;
output[ 3:0]    FIFOCnt0;
output          WrRdyOut;
output          RdRdyOut;

output          BeforeFullOut;
output          FIFOFullOut;
output          FIFOHalfFullOut;
output          FIFORdReadyOut;
//output          FIFOFull1Out;
//output          FIFOFull0Out;
output          FIFOEmpty1Out;
output          FIFOEmpty0Out;



parameter       FIFOSIZE = 8;


reg [ 2:0]  WrPtr0;
reg [ 2:0]  WrPtr1;
reg [ 2:0]  RdPtr0;
reg [ 2:0]  RdPtr1;

reg [ 3:0]  FIFOCnt0;
reg [ 3:0]  FIFOCnt1;
wire[ 3:0]  Level;
reg         FIFOSelRd;
reg         FIFOSelWr;

reg FIFOFull0;
reg FIFOFull1;

wire FIFOEmpty0;
wire FIFOEmpty1;

assign Level = FIFOLevelIn+1;

assign WrRdyOut = ( (FIFOSelWr==1'b0 && FIFOCnt0==0 && WrPtr0==0) ||
                    (FIFOSelWr==1'b1 && FIFOCnt1==0 && WrPtr1==0)
                  ) ? 1'b1 : 1'b0;

assign RdRdyOut = ( (FIFOSelRd==1'b0 && Level==FIFOCnt0) ||
                    (FIFOSelRd==1'b1 && Level==FIFOCnt1)
                  ) ? 1'b1 : 1'b0;



assign BeforeFullOut = ( (WrPtr0==FIFOLevelIn && FIFOFull1==1'b1) || (WrPtr1==FIFOLevelIn && FIFOFull0==1'b1) ) ? 1'b1 : 1'b0;

//assign FIFOEmpty0 = (WrPtr0==0 && FIFOFull0==1'b0) ? 1'b1 : 1'b0; //2.5
//assign FIFOEmpty1 = (WrPtr1==0 && FIFOFull1==1'b0) ? 1'b1 : 1'b0; //2.5

assign FIFOEmpty0 = (FIFOCnt0==0 && FIFOFull0==1'b0) ? 1'b1 : 1'b0; //2.5
assign FIFOEmpty1 = (FIFOCnt1==0 && FIFOFull1==1'b0) ? 1'b1 : 1'b0; //2.5

assign FIFOEmpty0Out = FIFOEmpty0;
assign FIFOEmpty1Out = FIFOEmpty1;
//assign FIFOFull0Out  = FIFOFull0;
//assign FIFOFull1Out  = FIFOFull1;

assign FIFOHalfFullOut = FIFOFull0 ^ FIFOFull1 ;
assign FIFOFullOut = FIFOFull0 & FIFOFull1;

assign FIFORdReadyOut = ( (FIFOSelRd==1'b0 && FIFOCnt0!=0) || (FIFOSelRd==1'b1 && FIFOCnt1!=0) )? 1'b1 : 1'b0;

`ifdef CHIP
wire[31:0]  RdData0;
wire[31:0]  RdData1;
wire WrEn0;
wire WrEn1;

RF2SH8x32 DFIFO0(
    .QA  (RdData0),   
    .AA  (RdPtr0),
    .CLKA(Clk),
    .CENA(1'b0),
    .AB  (WrPtr0),   
    .DB  (FIFOWrDataIn),   
    .CLKB(Clk),
    .CENB(~WrEn0));

RF2SH8x32 DFIFO1(
    .QA  (RdData1),   
    .AA  (RdPtr1),
    .CLKA(Clk),
    .CENA(1'b0),
    .AB  (WrPtr1),   
    .DB  (FIFOWrDataIn),   
    .CLKB(Clk),
    .CENB(~WrEn1));

assign FIFORdDataOut = (!FIFOSelRd) ? RdData0 : RdData1;
assign WrEn0 = ((~FIFOSelWr) & FIFOWrEnIn);  
assign WrEn1 = (FIFOSelWr & FIFOWrEnIn);

`else
    
integer i;
reg[31:0]       DFIFO0[0:FIFOSIZE-1];
reg[31:0]       DFIFO1[0:FIFOSIZE-1];

always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        for(i=0;i<FIFOSIZE;i=i+1) begin
            DFIFO0[i]<=0;
            DFIFO1[i]<=0;
        end
    end
    else begin
        if(FIFOWrEnIn) begin
            if(!FIFOSelWr && !FIFOFull0) begin
                DFIFO0[WrPtr0]<=FIFOWrDataIn;
            end
            else if(FIFOSelWr && !FIFOFull1) begin
                DFIFO1[WrPtr1]<=FIFOWrDataIn;
            end
        end
    end
end

assign FIFORdDataOut = (!FIFOSelRd) ? DFIFO0[RdPtr0] : DFIFO1[RdPtr1];

`endif

always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        FIFOFull0<=0;
        FIFOFull1<=0;
    end
    else begin
        if(FIFOFlushIn) FIFOFull0<=1'b0;
        else if(FIFOSelWr==1'b0 && WrPtr0==FIFOLevelIn && FIFOWrEnIn) FIFOFull0<=1'b1;
        else if(FIFOSelRd==1'b0 && RdPtr0==FIFOLevelIn && FIFORdEnIn) FIFOFull0<=1'b0;
//        else if(WrPtr0==FIFOLevelIn && FIFOWrEnIn) FIFOFull0<=1'b1;
//        else if(RdPtr0==FIFOLevelIn && FIFORdEnIn) FIFOFull0<=1'b0;

        if(FIFOFlushIn) FIFOFull1<=1'b0;
        else if(FIFOSelWr==1'b1 && WrPtr1==FIFOLevelIn && FIFOWrEnIn) FIFOFull1<=1'b1;
        else if(FIFOSelRd==1'b1 && RdPtr1==FIFOLevelIn && FIFORdEnIn) FIFOFull1<=1'b0;
//        else if(WrPtr1==FIFOLevelIn && FIFOWrEnIn) FIFOFull1<=1'b1;
//        else if(RdPtr1==FIFOLevelIn && FIFORdEnIn) FIFOFull1<=1'b0;
    end
end

// FIFO Selection
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        FIFOSelRd<=0;
        FIFOSelWr<=0;
    end
    else begin
        if(FIFOFlushIn) FIFOSelWr<=0;
        else begin
//            if(FIFOLevelIn==0 && FIFOWrEnIn) FIFOSelWr<=~FIFOSelWr;
            if(FIFOLevelIn==0) begin 
                if(WrPtr0==1 || WrPtr1==1) FIFOSelWr<=~FIFOSelWr;
            end
            else begin
                if(WrPtr0==FIFOLevelIn && FIFOWrEnIn) FIFOSelWr<=1'b1;
                else if(WrPtr1==FIFOLevelIn && FIFOWrEnIn) FIFOSelWr<=1'b0;
            end
        end

        if(FIFOFlushIn) FIFOSelRd<=0;
        else begin
//            if(FIFOLevelIn==0 && FIFORdEnIn) FIFOSelRd<=~FIFOSelRd;
            if(FIFOLevelIn==0) begin
                if(RdPtr0==1 || RdPtr1==1) FIFOSelRd<=~FIFOSelRd;
            end 
            else begin
                if(RdPtr0==FIFOLevelIn && FIFORdEnIn) FIFOSelRd<=1'b1;
                else if(RdPtr1==FIFOLevelIn && FIFORdEnIn) FIFOSelRd<=1'b0;
            end
        end
    end
end

// Write Pointer
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        WrPtr0<=3'd0;
        WrPtr1<=3'd0;
    end
    else begin
        if(FIFOFlushIn) begin
            WrPtr0<=0;
            WrPtr1<=0;
        end
        else if(FIFOWrEnIn) begin
            if(!FIFOSelWr && !FIFOFull0) begin
                WrPtr0<=WrPtr0+1;
            end
            else if(FIFOSelWr && !FIFOFull1) begin
                WrPtr1<=WrPtr1+1;
            end
        end
        else begin
            if(WrPtr0==Level) WrPtr0<=0;
            else if(WrPtr1==Level) WrPtr1<=0;
        end
    end
end

// Read Pointer
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        RdPtr0<=3'd0;
        RdPtr1<=3'd0;
    end
    else begin
        if(FIFOFlushIn) begin
            RdPtr0<=3'd0;
            RdPtr1<=3'd0;
        end
        else if(FIFORdEnIn) begin
            if(!FIFOSelRd && FIFORdEnIn && !FIFOEmpty0) RdPtr0<=RdPtr0+1;
            else if(FIFOSelRd && FIFORdEnIn && !FIFOEmpty1) RdPtr1<=RdPtr1+1;
        end
        else begin
            if(Level==RdPtr0) RdPtr0<=0;
            else if(Level==RdPtr1) RdPtr1<=0;
        end
    
    end
end


// FIFO Level cnt0
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        FIFOCnt0<=0;
    end
    else begin
        if(FIFOFlushIn) FIFOCnt0<=0;
        else if(FIFOSelWr==1'b0 && FIFOWrEnIn==1'b1 && FIFOSelRd==1'b0 && FIFORdEnIn==1'b1)
            FIFOCnt0<=FIFOCnt0;
        else if(FIFOSelWr==1'b0 && FIFOWrEnIn==1'b1 && FIFOCnt0!=Level)
            FIFOCnt0<=FIFOCnt0+1;
        else if(FIFOSelRd==1'b0 && FIFORdEnIn==1'b1 && FIFOEmpty0==1'b0)
            FIFOCnt0<=FIFOCnt0-1;
    end
end


// FIFO Level cnt1
always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        FIFOCnt1<=0;
    end
    else begin
        if(FIFOFlushIn) FIFOCnt1<=0;
        else if(FIFOSelWr==1'b1 && FIFOWrEnIn==1'b1 && FIFOSelRd==1'b1 && FIFORdEnIn==1'b1)
            FIFOCnt1<=FIFOCnt1;
        else if(FIFOSelWr==1'b1 && FIFOWrEnIn==1'b1 && FIFOCnt1!=Level)
            FIFOCnt1<=FIFOCnt1+1;
        else if(FIFOSelRd==1'b1 && FIFORdEnIn==1'b1 && FIFOEmpty1==1'b0)
            FIFOCnt1<=FIFOCnt1-1;
    end
end


endmodule




