/****************************************************
 
    JTAG Sync. for ARM926
 
    file name : jtag_sync.v
 
    created by gtlee
 
    data : 2006.11.15
 
    note :
         Tap conroller의 clock과 jtag의 clock이 다를 경우
         이를 중재해줌.
    history : 
       2007.1.11 : remove ensrstb
                   add sync JTAG reset
 
******************************************************/

`timescale 1ns/10ps

module  jtag_sync
  (
   clk             ,
   rstb            ,
   
   // External JTAG signal
   etrstb          ,
   etclk           ,
   ertclk          ,
   etms            ,
   etdi            ,
   etdo            ,
   
   // ARM JTAG signal
   DBGnTRST        ,
   DBGTCKEN        ,
   DBGTDI          ,
   DBGTMS          ,
   DBGTDO            
   );

   input              clk;
   input 			  rstb;
   
   // External JTAG signal
   input              etrstb;
   input 			  etclk;
   output 			  ertclk;
   input 			  etms;
   input 			  etdi;
   output 			  etdo;
   
   // ARM JTAG signal
   output             DBGnTRST;
   output             DBGTCKEN;
   output             DBGTDI;
   output             DBGTMS;
   input 			  DBGTDO;

   //================================================
   wire 			  etdo;
   wire 			  ertclk;
   
   wire 			  DBGnTRST;
   wire 			  DBGTCKEN;
   reg 				  DBGTDI;
   reg 				  DBGTMS;
   
   //------------------------------------------------
   reg 				  trstb_dly1;
   reg 				  trstb_dly2;
   reg [2:0] 		  tclk_sync;
   wire 			  tclk_en;
   

   //================================================
   assign 			  etdo = DBGTDO;
   assign 			  DBGnTRST = etrstb;

   always@(posedge clk or negedge etrstb) begin
	  if(!etrstb) begin
		 trstb_dly1 <= 1'b0;
		 trstb_dly2 <= 1'b0;
	  end // if
	  else begin
		 trstb_dly1 <= etrstb;
		 trstb_dly2 <= trstb_dly1;
	  end // else
   end // always
   
   always@(posedge clk or negedge trstb_dly2) begin
	  if(!trstb_dly2) begin
		 tclk_sync <= 3'h0;
	  end // if
	  else begin
		 tclk_sync <= {tclk_sync[1:0],etclk};
	  end // else
   end // always

   
   assign tclk_en = (tclk_sync[2:1] == 2'b01)? 1'b1 : 1'b0;
   assign DBGTCKEN = (tclk_sync[2:1] == 2'b10)? 1'b1 : 1'b0;
   assign ertclk = tclk_sync[2];
   
   always@(posedge clk or negedge trstb_dly2) begin
	  if(!trstb_dly2) begin
		 DBGTDI <= 1'b1;
		 DBGTMS <= 1'b1;
	  end // if
	  else if(tclk_en == 1'b1) begin
		 #2 DBGTDI <= etdi;
		 #2 DBGTMS <= etms;
	  end // else
   end // always
   
endmodule // jtag_sync
