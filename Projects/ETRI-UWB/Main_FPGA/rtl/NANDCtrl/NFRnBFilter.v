//************************************************
// Project     : NAND FLASH CONTROLLER 
// Date        : 2006/10/23
// author      : 
// Description : RnB signal filtering
// module name : NFRnBFilter.v
// history     :
//
//************************************************
`timescale 1ns/10ps

module NFRnBFilter(
    Clk,
    nRst,
    RnB1In,
    RnB0In,
    FiltRnB1Out,
    FiltRnB0Out);

input  Clk;
input  nRst;
input  RnB1In;
input  RnB0In;
output FiltRnB1Out;
output FiltRnB0Out;

parameter FILTER=3;

reg [FILTER-1:0]    Dly0;
reg [FILTER-1:0]    Dly1;

reg FiltRnB0Out;
reg FiltRnB1Out;



always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        Dly0<=0;
        Dly1<=0;
    end
    else begin
        Dly0<={Dly0[FILTER-2:0],RnB0In};
        Dly1<={Dly1[FILTER-2:0],RnB1In};
    end
end


always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        FiltRnB0Out<=1;
    end
    else begin
        if(&{Dly0,RnB0In}==1'b1)      FiltRnB0Out<=1'b1;
        else if(|{Dly0,RnB0In}==1'b0) FiltRnB0Out<=1'b0;
    end
end

always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        FiltRnB1Out<=1;
    end
    else begin
        if(&{Dly1,RnB1In}==1'b1)      FiltRnB1Out<=1'b1;
        else if(|{Dly1,RnB1In}==1'b0) FiltRnB1Out<=1'b0;
    end
end
endmodule





