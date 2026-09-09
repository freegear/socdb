/****************************************************
 
    JTAG Sync. for ARM926
 
    file name : jtag_sync.v
 
    created by gtlee
 
    version :
              2.00
 
    data : 2006.11.15
 
    note :
         Tap conroller의 clock과 jtag의 clock이 다를 경우
         이를 중재해줌.
    history : 
 
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
   reg [2:0] 		  tclk_sync;
   wire 			  tclk_en;
   

   //================================================
   assign 			  etdo = DBGTDO;
   assign 			  DBGnTRST = etrstb;
   
   always@(posedge clk or negedge rstb) begin
	  if(!rstb) begin
		 tclk_sync <= 3'h0;
	  end // if
	  else begin
		 tclk_sync <= {tclk_sync[1:0],etclk};
	  end // else
   end // always

   
   assign tclk_en = (tclk_sync[2:1] == 2'b01)? 1'b1 : 1'b0;
   assign DBGTCKEN = (tclk_sync[2:1] == 2'b10)? 1'b1 : 1'b0;
   assign ertclk = tclk_sync[2];
   
   always@(posedge clk or negedge rstb) begin
	  if(!rstb) begin
		 DBGTDI <= 1'b0;
		 DBGTMS <= 1'b0;
	  end // if
	  else if(tclk_en == 1'b1) begin
		 DBGTDI <= etdi;
		 DBGTMS <= etms;
	  end // else
   end // always
   
endmodule // jtag_sync
