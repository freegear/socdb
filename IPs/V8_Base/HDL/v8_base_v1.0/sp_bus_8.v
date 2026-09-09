/************************************************************
   Sub Processor Bus.
  
   file name : sp_bus.v
 
   created by gtlee
 
   date : 2006.6.19
 
   note :
        in/out naming¿∫ device ¿ß¡÷.
   history :
 
 ************************************************************/
`timescale 1ns/10ps

 
module  sb_bus
  (
   cpu_addr          ,
   cpu_datain        ,
   cpu_ready         ,

   pctrl_ready       ,

   mem_cs            ,
   mem_dataout       ,
   mem_ready         ,

   p0_cs             ,
   p0_dataout        ,
   p0_ready          ,

   p1_cs             ,
   p1_dataout        ,
   p1_ready          ,

   p2_cs             ,
   p2_dataout        ,
   p2_ready          ,

   p3_cs             ,
   p3_dataout        ,
   p3_ready          ,

   p4_cs             ,
   p4_dataout        ,
   p4_ready          ,

   p5_cs             ,
   p5_dataout        ,
   p5_ready          ,

   p6_cs             ,
   p6_dataout        ,
   p6_ready          ,

   p7_cs             ,
   p7_dataout        ,
   p7_ready          
   );

   parameter                ADDRWIDTH = 16;
   parameter 				DATAWIDTH = 8;

   
   // with processor
   input [ADDRWIDTH-1:0]    cpu_addr;
//   input 					cpu_read;
//   input 					cpu_write;
//   input [DATAWIDTH-1:0] 	cpu_dataout;
   output [DATAWIDTH-1:0] 	cpu_datain;
   output 					cpu_ready;

   // processor control
   input 					pctrl_ready;
      
   // with system memory
   output 					mem_cs;
   input [DATAWIDTH-1:0] 	mem_dataout;
   input 					mem_ready;

   // with Peri 0
   output 					p0_cs;
   input [DATAWIDTH-1:0] 	p0_dataout;
   input 					p0_ready;

   // with Peri 1
   output 					p1_cs;
   input [DATAWIDTH-1:0] 	p1_dataout;
   input 					p1_ready;

   // with Peri 2
   output 					p2_cs;
   input [DATAWIDTH-1:0] 	p2_dataout;
   input 					p2_ready;

   // with Peri 3
   output 					p3_cs;
   input [DATAWIDTH-1:0] 	p3_dataout;
   input 					p3_ready;

   // with Peri 4
   output 					p4_cs;
   input [DATAWIDTH-1:0] 	p4_dataout;
   input 					p4_ready;

   // with Peri 5
   output 					p5_cs;
   input [DATAWIDTH-1:0] 	p5_dataout;
   input 					p5_ready;

   // with Peri 6
   output 					p6_cs;
   input [DATAWIDTH-1:0] 	p6_dataout;
   input 					p6_ready;
   
   // with Peri 7
   output 					p7_cs;
   input [DATAWIDTH-1:0] 	p7_dataout;
   input 					p7_ready;

   //-------------------------

   reg [DATAWIDTH-1:0] 		cpu_datain;
   reg 						cpu_ready;

   // address decoder
   reg 						mem_cs;
   reg [7:0] 				peri_cs;
   
   wire 					p0_cs;
   wire 					p1_cs;
   wire 					p2_cs;
   wire 					p3_cs;
   wire 					p4_cs;
   wire 					p5_cs;
   wire 					p6_cs;
   wire 					p7_cs;

   //=======================================================

   always@(cpu_addr) begin
	  if(cpu_addr[ADDRWIDTH-1] == 1'b0) begin
		 mem_cs <= 1'b1;
		 peri_cs <= {8{1'b0}};
	  end
	  else begin
		 mem_cs <= 1'b0;
		 
		 case(cpu_addr[ADDRWIDTH-2:ADDRWIDTH-4]) // synopsys parallel_case
		   3'h0 : peri_cs = 8'b0000_0001;
		   3'h1 : peri_cs = 8'b0000_0010;
		   3'h2 : peri_cs = 8'b0000_0100;
		   3'h3 : peri_cs = 8'b0000_1000;
		   3'h4 : peri_cs = 8'b0001_0000;
		   3'h5 : peri_cs = 8'b0010_0000;
		   3'h6 : peri_cs = 8'b0100_0000;
		   default : p7_cs = 8'b1000_0000;
		 endcase // case(cpu_addr[ADDRWIDTH-2:ADDRWIDTH-4])
	  end // else: !if(cpu_addr[ADDRWIDTH-1] == 1'b0)
   end // always@ (cpu_addr or cpu_read or cpu_write)
   
   assign p0_cs = peri_cs[0];
   assign p1_cs = peri_cs[1];
   assign p2_cs = peri_cs[2];
   assign p3_cs = peri_cs[3];
   assign p4_cs = peri_cs[4];
   assign p5_cs = peri_cs[5];
   assign p6_cs = peri_cs[6];
   assign p7_cs = peri_cs[7];
   
   // ready muxing
   always@(mem_cs or peri_cs or pctrl_ready or mem_ready or p0_ready or
		   p1_ready or p2_ready or p3_ready or p4_ready or p5_ready or
		   p6_ready or p7_ready) begin
	  if(pctrl_ready == 1'b0)
		cpu_ready <= 1'b0;
	  else begin
		 case(1'b1)  // synopsys parallel_case
		   mem_cs : cpu_ready <= mem_ready;
		   peri_cs[0] : cpu_ready <= p0_ready;
		   peri_cs[1] : cpu_ready <= p1_ready;
		   peri_cs[2] : cpu_ready <= p2_ready;
		   peri_cs[3] : cpu_ready <= p3_ready;
		   peri_cs[4] : cpu_ready <= p4_ready;
		   peri_cs[5] : cpu_ready <= p5_ready;
		   peri_cs[6] : cpu_ready <= p6_ready;
		   peri_cs[7] : cpu_ready <= p7_ready;
		   default : cpu_ready <= 1'b1;
		 endcase // case(1'b1)
	  end // else: !if(pctrl_ready == 1'b0)
   end // always@ (mem_cs or peri_cs or pctrl_ready or mem_ready or p0_ready or...

   // dataout muxing
   always@(mem_cs or peri_cs or mem_dataout or p0_dataout or p1_dataout or
		   p2_dataout or p3_dataout or p4_dataout or p5_dataout or 
		   p6_dataout or p7_dataout) begin
	  case(1'b1)  // synopsys parallel_case
		mem_cs : cpu_datain <= mem_dataout;
		peri_cs[0] : cpu_datain <= p0_dataout;
		peri_cs[1] : cpu_datain <= p1_dataout;
		peri_cs[2] : cpu_datain <= p2_dataout;
		peri_cs[3] : cpu_datain <= p3_dataout;
		peri_cs[4] : cpu_datain <= p4_dataout;
		peri_cs[5] : cpu_datain <= p5_dataout;
		peri_cs[6] : cpu_datain <= p6_dataout;
		peri_cs[7] : cpu_datain <= p7_dataout;
		default : cpu_datain <= 1'b1;
	  endcase // case(1'b1)
   end // always@ (mem_cs or peri_cs or mem_dataout or p0_dataout or p1_dataout or...
   
endmodule // sb_bus
