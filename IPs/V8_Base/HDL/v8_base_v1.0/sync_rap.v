/************************************************************
   the rapper for a sync memory.
  
   file name : sync_rap.v
 
   created by gtlee
 
   date : 2006.6.19
 
   note :
        
   history :
 
 ************************************************************/
`timescale 1ns/10ps


module    sync_rap
  (
   clk               ,
   rstb              ,

   bus_cs            ,
   bus_addr          ,
   bus_read          ,
   bus_write         ,
   bus_datain        ,
   bus_dataout       ,
   bus_ready         ,

   sl_cs             ,
   sl_addr           ,
   sl_read           ,
   sl_write          ,
   sl_dataout        ,
   sl_datain         ,
   sl_ready          
   );

   parameter                ADDRWIDTH = 16;
   parameter 				DATAWIDTH = 8;

   // To bus
   input 					clk;
   input 					rstb;
   
   input 					bus_cs;
   input [ADDRWIDTH-1:0]    bus_addr;
   input 					bus_read;
   input 					bus_write;
   input [DATAWIDTH-1:0] 	bus_datain;
   output [DATAWIDTH-1:0] 	bus_dataout;
   output 					bus_ready;

   // To slave device
   output 					sl_cs;
   output [ADDRWIDTH-1:0] 	sl_addr;
   output 					sl_read;
   output 					sl_write;
   output [DATAWIDTH-1:0] 	sl_dataout;
   input [DATAWIDTH-1:0] 	sl_datain;   // read command ¼ö¿¡ µé¾î¿È.
   input 					sl_ready;
   
   //========================================================
   wire [DATAWIDTH-1:0] 	bus_dataout;
   reg 						bus_ready;
   
   // To slave device
   wire 					sl_cs;
   wire [ADDRWIDTH-1:0] 	sl_addr;
   wire 					sl_read;
   wire 					sl_write;
   wire [DATAWIDTH-1:0] 	sl_dataout;
   
   reg 						rd_st; // read state. if 0, idle. if 1, reading.

   //======================================================
   assign 					bus_dataout = sl_datain;
   assign 					sl_cs = bus_cs;
   assign 					sl_addr = bus_addr;
   assign 					sl_read = bus_read;
   assign 					sl_write = bus_write;
   assign 					sl_dataout = bus_datain;


   always@(posedge clk or negedge rstb) begin
	  if(~rstb) rd_st <= 1'b0;
	  else if(bus_write == 1'b1) rd_st <= 1'b0;
	  else if(bus_read == 1'b1 && sl_ready == 1'b1) begin
		 rd_st <= ~rd_st;
	  end
   end

   always@(sl_ready or rd_st or bus_read) begin
	  if(rd_st == 1'b0 && bus_read == 1'b1)
		bus_ready <= 1'b0;
	  else 	bus_ready <= sl_ready;
   end
   

endmodule // sync_rap

