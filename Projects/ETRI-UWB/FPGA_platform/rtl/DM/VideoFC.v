/*-------------------------------------------------------------------
Comment          : format converter 422 to 444
-------------------------------------------------------------------*/

`timescale 1ns / 1ns

module VideoFC (
			Clk,
			nRST,
			ValidIn,
			Yin,
			Cin,
			ValidOut,
			Yout,
			CbOut,
			CrOut 
);

//------------------------------------------------------------------
//INPUT DECLARATION
//------------------------------------------------------------------
input         Clk;
input         nRST;
input         ValidIn;
input  [ 7:0] Yin;
input  [ 7:0] Cin;

//------------------------------------------------------------------
//OUTPUT DECLARATION
//------------------------------------------------------------------
output        ValidOut;
output [ 7:0] Yout;
output [ 7:0] CbOut;
output [ 7:0] CrOut;

//------------------------------------------------------------------
//REGISTER & WIRE DECLARATION
//------------------------------------------------------------------
reg         ValidD1;
reg         ValidOut;
reg         ColorSel;
reg  [ 7:0] YinD1;
reg  [ 7:0] Yout;
reg  [ 7:0] CbBuf;
reg  [ 7:0] CbOut;
reg  [ 7:0] CrBuf;
reg  [ 7:0] CrOut;

//------------------------------------------------------------------
//FUNCTION DESCRIPTION
//------------------------------------------------------------------

//ValidIn delay adjust
always@(negedge nRST or posedge Clk)
	if (!nRST) begin
	   ValidD1  <= 1'b0;
	   ValidOut <= 1'b0;
	end
	else begin
	   ValidD1  <= ValidIn;
	   ValidOut <= ValidD1;
	end

//ColorSel gen
always@(negedge nRST or posedge Clk)
	if (!nRST)
	   ColorSel <= 1'b0;
	else if (ValidIn)
	   ColorSel <= ~ColorSel;
	else
	   ColorSel <= 1'b0;

//Yin delay adjust
always@(negedge nRST or posedge Clk)
	if (!nRST) begin
	   YinD1 <= 8'd0;
	   Yout  <= 8'd0;
	end
	else begin
	   YinD1 <= Yin;
	   Yout  <= YinD1;
	end

//Cb Buf
always@(negedge nRST or posedge Clk)
	if (!nRST)
	   CbBuf <= 8'd0;
	else if (!ColorSel)
	   CbBuf <= Cin;
	else
	   CbBuf <= CbBuf;

//Cr Buf
always@(negedge nRST or posedge Clk)
	if (!nRST)
	   CrBuf <= 8'd0;
	else if (ColorSel)
	   CrBuf <= Cin;
	else
	   CrBuf <= CrBuf;

//CbOut
always@(negedge nRST or posedge Clk)
	if (!nRST)
	   CbOut <= 8'd0;
	else
	   CbOut <= CbBuf;

//CrOut
always@(negedge nRST or posedge Clk)
	if (!nRST)
	   CrOut <= 8'd0;
	else if (ColorSel)
	   CrOut <= Cin;
	else
	   CrOut <= CrBuf;

endmodule