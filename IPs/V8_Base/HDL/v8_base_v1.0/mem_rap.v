/************************************************************
   the rapper for a sync memory.
  
   file name : mem_rap.v
 
   created by gtlee
 
   date : 2006.6.19
 
   note :
        
   history :
 
 ************************************************************/
`timescale 1ns/10ps


module    mem_rap
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

   spc_cs            ,
   spc_addr          ,
   spc_read          ,
   spc_write         ,
   spc_datain        ,
   spc_dataout       ,
   
   sl_csb            ,
   sl_addr           ,
   sl_writeb         ,
   sl_outenb         ,
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

   // from sub processor controller
   
   input 					spc_cs;
   input [ADDRWIDTH-1:0]    spc_addr;
   input 					spc_read;
   input 					spc_write;
   input [DATAWIDTH-1:0] 	spc_datain;
   output [DATAWIDTH-1:0] 	spc_dataout;

   // To slave device
   output 					sl_csb;
   output [ADDRWIDTH-1:0] 	sl_addr;
   output 					sl_writeb;
   output                   sl_outenb;
   output [DATAWIDTH-1:0] 	sl_dataout;
   input [DATAWIDTH-1:0] 	sl_datain;   // read command ¼ö¿¡ µé¾î¿È.
   input 					sl_ready;
   
   //========================================================
   wire [DATAWIDTH-1:0] 	bus_dataout;
   reg 						bus_ready;
   
   wire [DATAWIDTH-1:0] 	spc_dataout;

   wire 					bus_acc;
   wire 					spc_acc;
   
   
   // To slave device
   wire 					sl_csb;
   wire [ADDRWIDTH-1:0] 	sl_addr;
   wire 					sl_writeb;
   wire 					sl_outenb;
   wire [DATAWIDTH-1:0] 	sl_dataout;
   
   reg 						rd_st; // read state. if 0, idle. if 1, reading.

   //======================================================

   assign 					bus_dataout = sl_datain;
   assign 					spc_dataout = sl_datain;
   assign 					sl_writeb = ~((spc_cs)? spc_write:bus_write);
   assign 					sl_dataout = (spc_cs)? spc_datain : bus_datain;
   assign 					sl_outenb = ((spc_cs)? 1'b0:~bus_cs);

   assign 					bus_acc = bus_read | bus_write;
   assign 					spc_acc = spc_read | spc_write;
   
   assign              #2     sl_csb = ~((bus_cs & bus_acc) | (spc_cs & spc_acc));
   assign              #2     sl_addr = (spc_cs)? spc_addr:bus_addr;
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) rd_st <= 1'b0;
	  else if(bus_write == 1'b1) rd_st <= 1'b0;
	  else if(~bus_cs)  rd_st <= 1'b0;
	  else if(spc_cs == 1'b0 && bus_read == 1'b1 && sl_ready == 1'b1) begin
		 rd_st <= ~rd_st;
	  end
   end

   always@(sl_ready or rd_st or bus_read or spc_cs) begin
	  if((rd_st == 1'b0 && bus_read == 1'b1) || spc_cs == 1'b1)
		bus_ready <= 1'b0;
	  else 	bus_ready <= sl_ready;
   end
   

endmodule // sync_rap

