//************************************************
// Project     : NAND FLASH CONTROLLER 
// Date        : 2006/10/23
// author      : 
// Description : Nand flash command queue
// module name : NFCmdQ.v
// history     :
//
//************************************************
`timescale 1ns/10ps
//`define CHIP
module NFCmdQ(
    Clk       ,
    nRst      ,
    NFCtrlRstIn,
    QWrEnIn   ,
    QRdEnIn   ,
    QWrDataIn ,
    QRdDataOut,
    QLevelOut 
);

input           Clk;
input           nRst;
input           NFCtrlRstIn;
input           QWrEnIn;
input           QRdEnIn;
input [31:0]    QWrDataIn;
output[31:0]    QRdDataOut;

output[ 3:0]    QLevelOut;

parameter QSIZE = 8;
parameter DW = 32;



reg[   2:0]     WrPtr;
reg[   2:0]     RdPtr;
wire[  31:0]    QRdDataOut;     

reg[   3:0]     QCnt;

wire QFull;
wire QEmpty;

`ifdef CHIP

RF2SH8x32 CMDQ(
    .QA  (QRdDataOut),   
    .AA  (RdPtr),
    .CLKA(Clk),
    .CENA(1'b0),
    .AB  (WrPtr),   
    .DB  (QWrDataIn),   
    .CLKB(Clk),
    .CENB(~QWrEnIn));


`else

integer i;
reg[DW-1:0]     CMDQ[0:QSIZE-1];

assign QRdDataOut =CMDQ[RdPtr];

always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        for(i=0;i<QSIZE;i=i+1)
            CMDQ[i]<=0;    
    end
    else begin
        if(QWrEnIn && !QFull) begin
            CMDQ[WrPtr]<=QWrDataIn;
        end
    end
end

`endif

assign QFull = (QCnt==QSIZE) ? 1'b1 : 1'b0;
assign QEmpty = (QCnt==0) ? 1'b1 : 1'b0;
assign QLevelOut = QCnt;


always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        WrPtr<=0;
    end
    else begin
        if(NFCtrlRstIn) WrPtr<=0;
        else if(QWrEnIn && !QFull) WrPtr<=WrPtr+1;
    end
end


always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        RdPtr<=0;
    end
    else begin
        if(NFCtrlRstIn) RdPtr<=0;
        else if(QRdEnIn && !QEmpty) RdPtr<=RdPtr+1;
   end
end

always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        QCnt<=0;
    end
    else begin
        if(NFCtrlRstIn) QCnt<=0;
        else if(QWrEnIn==1'b1 && QRdEnIn==1'b0 & QCnt!=4'b1000) 
            QCnt<=QCnt+1;
        else if(QRdEnIn==1'b1 && QWrEnIn==1'b0 && QCnt!=4'b0000)
            QCnt<=QCnt-1;
    end
end

endmodule

