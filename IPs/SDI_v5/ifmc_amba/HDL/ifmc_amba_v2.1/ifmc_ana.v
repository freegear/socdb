/*

    Serial analyzer for external input signal

    file name : ifmc_ana.v
 
    create by gtlee
 
    create date : 2006.3.7
 
    history :
 
    note :
 
 
 */

module      ifmc_ana
  (
   clk                   ,
   rstb                  ,

   tool_mode             ,
   scl_lpf               ,
   sda_lpf               ,
   
   sst_start             ,
   sst_stop              ,
   sst_ishift            ,
   sst_oshift            ,
   end_sclh             
   );
   parameter              ISCLEDGE_DLY = 8;
   parameter              OSCLEDGE_DLY = 4;
   
   input                  clk;
   input 				  rstb;

   input 				  tool_mode;
   input 				  scl_lpf;
   input 				  sda_lpf;   // LPFed sda input

   output 				  sst_start;
   output 				  sst_stop;
   output 				  sst_ishift; // input latch and shift 
   output 				  sst_oshift; // output shift
   output 				  end_sclh;
   
   //------------------------------------------------------
   // internal signals
   reg 					  sda_dly;
   reg 					  scl_dly;

   wire 				  start_edge;
   wire 				  stop_edge;

   reg 					  sst_start;
   reg 					  sst_stop;
   
   reg 					  set_start;
   reg 					  set_stop;

   wire 				  scl_pos; // scl positive edge
   reg [ISCLEDGE_DLY-1:0] scl_pos_dly;

   wire 				  scl_neg;
   reg [OSCLEDGE_DLY-1:0] scl_neg_dly;
   
   wire 				  sst_ishift;
   wire 				  sst_oshift;

   wire 				  end_sclh; // end of SCL high

       
   //------------------------------------------------------
   // input dealy
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 sda_dly <= 1'b1;
		 scl_dly <= 1'b0;
	  end
	  else begin
		 sda_dly <= sda_lpf;
		 scl_dly <= scl_lpf;
	  end
   end
   
   assign   scl_pos = (scl_dly == 1'b0 && scl_lpf == 1'b1)? 1'b1 : 1'b0;
   assign   scl_neg = (scl_dly == 1'b1 && scl_lpf == 1'b0)? 1'b1 : 1'b0;

   
   //----------------------------------------------
   // check start bit
   assign   start_edge = (scl_lpf == 1'b1 && sda_dly == 1'b0 && sda_lpf == 1'b1)?
					   1'b1 : 1'b0;
   assign   stop_edge = (scl_lpf == 1'b1 && sda_dly == 1'b1 && sda_lpf == 1'b0)?
						 1'b1 : 1'b0;

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) sst_start <= 1'b0;
	  else if(~tool_mode) sst_start <= 1'b0;
	  else if(set_stop == 1'b0 && start_edge == 1'b1)
		sst_start <= 1'b1;
	  else sst_start <= 1'b0;
   end
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) set_start <= 1'b0;
	  else if(~tool_mode)  set_start <= 1'b0;
	  else if(scl_lpf == 1'b0) set_start <= 1'b0;
	  else if(start_edge) set_start <= 1'b1;
   end

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) sst_stop <= 1'b0;
	  else if(~tool_mode) sst_stop <= 1'b0;
	  else if(set_start == 1'b0 && stop_edge == 1'b1)
		sst_stop <= 1'b1;
	  else sst_stop <= 1'b0;
   end

   always@(posedge clk or negedge rstb) begin
	  if(~rstb) set_stop <= 1'b0;
	  else if(~tool_mode) set_stop <= 1'b0;
	  else if(scl_lpf == 1'b0) set_stop <= 1'b0;
	  else if(stop_edge == 1'b1) set_stop <= 1'b1;
   end
   

   
   //----------------------------------------------
   // in/out shifter control
   
   always@(posedge clk or negedge rstb) begin
	  if(~rstb) begin
		 scl_pos_dly <= {ISCLEDGE_DLY{1'b0}};
		 scl_neg_dly <= {OSCLEDGE_DLY{1'b0}};
	  end
	  else if(~tool_mode) begin
		 scl_pos_dly <= {ISCLEDGE_DLY{1'b0}};
		 scl_neg_dly <= {OSCLEDGE_DLY{1'b0}};
	  end
	  else begin
		 scl_pos_dly <= {scl_pos_dly[ISCLEDGE_DLY-2:0],scl_pos};
		 scl_neg_dly <= {scl_neg_dly[OSCLEDGE_DLY-2:0],scl_neg};
	  end
   end
   

   assign    sst_ishift = scl_pos_dly[ISCLEDGE_DLY-1];
   assign    sst_oshift = scl_neg_dly[OSCLEDGE_DLY-1];
   
   assign    end_sclh = scl_neg;
   

endmodule // ifmc_ana
