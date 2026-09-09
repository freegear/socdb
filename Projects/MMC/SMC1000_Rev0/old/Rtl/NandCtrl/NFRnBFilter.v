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
    
    RnB3In,                 //07_06_19 : Register Revision
    RnB2In, 
    
    RnB1In,
    RnB0In,
    
    FiltRnB3Out,            //07_06_19 : Register Revision
    FiltRnB2Out,
    
    FiltRnB1Out,
    FiltRnB0Out);

input  Clk;
input  nRst;

input  RnB3In;              //07_06_19 : Register Revision
input  RnB2In;

input  RnB1In;
input  RnB0In;

output FiltRnB3Out;         //07_06_19 : Register Revision
output FiltRnB2Out;

output FiltRnB1Out;
output FiltRnB0Out;

parameter FILTER=3;

reg [FILTER-1:0]    Dly0;
reg [FILTER-1:0]    Dly1;

reg [FILTER-1:0]    Dly2;       //07_06_19 : Register Revision
reg [FILTER-1:0]    Dly3;


reg FiltRnB0Out;
reg FiltRnB1Out;

reg FiltRnB2Out;                //07_06_19 : Register Revision
reg FiltRnB3Out;


always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        Dly0<=0;
        Dly1<=0;
        
        Dly2<=0;                //07_06_19 : Register Revision
        Dly3<=0;
        
    end
    else begin
        Dly0<={Dly0[FILTER-2:0],RnB0In};
        Dly1<={Dly1[FILTER-2:0],RnB1In};
        
        Dly2<={Dly2[FILTER-2:0],RnB2In};        //07_06_19 : Register Revision
        Dly3<={Dly3[FILTER-2:0],RnB3In};
        
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

//07_06_19 : Register Revision

always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        FiltRnB2Out<=1;
    end
    else begin
        if(&{Dly2,RnB2In}==1'b1)      FiltRnB2Out<=1'b1;
        else if(|{Dly2,RnB2In}==1'b0) FiltRnB2Out<=1'b0;
    end
end

always @(posedge Clk or negedge nRst)
begin
    if(!nRst) begin
        FiltRnB3Out<=1;
    end
    else begin
        if(&{Dly3,RnB3In}==1'b1)      FiltRnB3Out<=1'b1;
        else if(|{Dly3,RnB3In}==1'b0) FiltRnB3Out<=1'b0;
    end
end

endmodule





