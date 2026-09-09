/*
   display module for debugging using GPIO
 
   Project : CT-500
 
   Created date : 2007.2.28
 
   Created by gtlee
 
 
   note :
     8bit data와 1bit write signal을 받아 display할 char를 받음.
     '\n'문자가 올때까지 buffer에 저장했다가 한꺼번에 출력함.
 
     write signal은 active low이며 falling edge에서 유효한 값을 추출.
   
  
 */


module display_MD
  (
   clk       ,
   rstb      ,
   write     ,
   wdata
   );

   input            clk;
   input 			rstb;
   input 			write;
   input [7:0] 		wdata;

   

   reg [8*256-1:0] 	strbuff;
   integer          strsize;

   reg [7:0] 		wdata_dly;
   reg 				write_dly;
 			
   integer          LOGFILE;


   initial begin
	  LOGFILE = $fopen("sim_out.log");

   end
   
      
   always@(posedge clk or negedge rstb) begin
	  if(!rstb) begin
		 wdata_dly <= 8'h00;
		 write_dly <= 1'b0;
	  end
	  else begin
		 wdata_dly <= wdata;
		 write_dly <= write;
	  end
   end // always wdata, writeb delay
   
   always@(posedge clk or negedge rstb) begin
	  if(!rstb)  begin
		 strbuff <= {(8*256){1'b0}};
		 strsize <= 0;
	  end
	  else if(write == 1'b0 && write_dly == 1'b1) begin
		 if(wdata_dly != 8'h0d && wdata_dly != 8'h0a) begin
			// skip new line
			strbuff <= {strbuff , wdata_dly};
			strsize <= strsize + 1;
		 end
	  end
	  else if (|strbuff[7:0] == 1'b0  && |strbuff == 1'b1) begin
		 strbuff <= {(8*256){1'b0}};
		 strsize <= 0;
	  end
   end // always strbuff
   
   // display string
   integer     i;
   
   always@(posedge clk) begin
	  if(|strbuff[7:0] == 1'b0  && |strbuff == 1'b1) begin
		 //$display("%s",strbuff);
		 //$display("%d",strsize);
		 
		 for(i=strsize;i<256;i=i+1) begin
			strbuff = {strbuff , 8'h00};
		 end
		 $display("%s",strbuff);
		 $fdisplay(LOGFILE,"%s",strbuff);
	  end // if
   end // always
   

endmodule // display_MD
