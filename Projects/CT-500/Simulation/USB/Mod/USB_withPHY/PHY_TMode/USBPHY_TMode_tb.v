
`timescale 1 ns / 1 ps

module USBPHY_TMode_tb
  (
   clk         ,
   rstb         ,
   rst_o       ,
   
   start       ,

   xcvrsel     ,
   termsel     ,
   vcontrol    ,
   vload       ,
   onbist      ,
   suspend     ,
   opmode      ,
   datain      ,
   txvalid     ,
   
   vstatus     ,

   linestate   ,
   USB_DP      ,
   USB_DN      
   );

   parameter     LOOPBACK = 4'h1;
   parameter 	 RXCHAIN = 4'h2;
   parameter 	 TXCHAIN = 4'h3;
   parameter 	 HSCDR = 4'h4;
   parameter 	 RESCAL = 4'h5;
   parameter 	 HSREC = 4'h6;
   parameter 	 LFSREC = 4'h7;
   parameter 	 HSDRIVER = 4'h8;
   parameter 	 FSDRIVER = 4'h9;
   parameter 	 LSDRIVER = 4'ha;
   parameter 	 PLL = 4'hc;
   parameter 	 LOCKCTRL = 4'he;

   //----------------------------------------------------
   input         clk;
   input 		 rstb;
   output        rst_o;
   
   input         start;

   output [1:0]  xcvrsel;   // pinmuxed to GPIO1_IN[7:6]
   output 		 termsel;   // pinmuxed to GPIO1_IN[16]
   output [3:0]  vcontrol;  // pinmuxed to WAVE_DIN_SEIP[3:0]
   output 		 vload;     // pinmuxed to WAVE_DIN_SEIP[7]
   output 		 onbist;    // pinmuxed to SEIO_SDI1o
   output 		 suspend;   // pinmuxed to GPIO1_IN[20]
   output [1:0]  opmode;    // pinmuxed to GPIO1_IN[5:4]
   output [7:0]  datain;    // pinmuxed to GPIO1_IN[15:8]
   output 		 txvalid;   // pinmuxed to GPIO1_IN[19]
      
   input [7:0] 	 vstatus;   // pinmuxed to WAVE_ADDRp[23]

   input [1:0] 	 linestate; // pinmuxed to SEIP_SD2O, SEIP_SD1O
   
   inout         USB_DP;
   inout 		 USB_DN;
   
   //-----------------------------------
   reg 			 rst_o;
   
   reg [1:0] 	 xcvrsel;
   reg 			 termsel;
   reg [3:0] 	 vcontrol;
   reg 			 vload;
   reg 			 onbist;
   reg 			 suspend;
   reg [1:0] 	 opmode;
   reg [7:0] 	 datain;
   reg 			 txvalid;
   
   wire 		 USB_DP;
   wire 		 USB_DN;

   reg 			 dpdown;
   reg 			 dndown;
   wire 		 dp_pulldown;
   wire 		 dn_pulldown;
   reg           dp_set;
   reg           dn_set;
  
   integer       tmode_logfile; 

   // Pull down the DP, DN
   pulldown (dp_pulldown);
   pulldown (dn_pulldown);

   initial begin
	  tmode_logfile = $fopen("PHY_TMode.log");
	  dpdown = 1'b0;
	  dndown = 1'b0;
	  dp_set = 1'bz;
	  dn_set = 1'bz;
	  xcvrsel = 2'b00;
	  termsel = 1'b0;
	  vcontrol = 4'b0000;
	  vload = 1'b1;
	  onbist = 1'b0;
	  suspend = 1'b0;
 	  opmode = 2'b00;
 	  datain = 8'h00;
 	  txvalid = 1'b0;
   end // initial
   
//   assign USB_DP = (dpdown)? dp_pulldown : 1'bz;
//   assign USB_DN = (dndown)? dn_pulldown : 1'bz;
   assign USB_DP = (dpdown)? dp_pulldown : dp_set;
   assign USB_DN = (dndown)? dn_pulldown : dn_set;
//   assign USB_DN = USB_DP;
   

   initial begin
	  rst_o = 1'b1;
	  wait(rstb);
	  repeat(50) @(negedge clk);
	  // release PHY reset
	  #50000 rst_o = 1'b0;
   end // initial
   
   reg     start_fg;
   
   always@(negedge clk ) begin
	  if(~rst_o & rstb) begin // & start
		 start_fg = 1;
		 xcvrsel = 2'b00;
		 termsel = 1'b0;
		 vcontrol = 4'b0000;
		 vload = 1'b1;
		 onbist = 1'b0;
	  
		 repeat(100) @(negedge clk);
		 production_test();

		 $stop;
		 
	  end // if not rst
	  else start_fg = 0;
	  
   end   // always

   //====================================================================
   task production_test;
	  begin
		 xcvrsel = 2'b00;

		 // suspend에 의해서 pll lock time이 달라짐.
		 suspend = 1'b1; 
		 // wait initial. 5000cycle
		 repeat(5010) @(negedge clk);

		 // init signals
		 $display("1-1) Start HS mode Bist test =================================");
		 $fdisplay(tmode_logfile,"1-1) Start HS mode Bist test =================================");
		 termsel = 1'b0;		 
		 set_bist_mode(4'b0001);
		 @(negedge clk);
//		 vcontrol = 4'b0000;

		 // check result
		 if(vstatus == 8'h10) begin
		   $display("HS mode Bist Test OK");
		   $fdisplay(tmode_logfile,"HS mode Bist Test OK");
		 end
		 else begin
			$display("HS mode Bist Test Fail");
			$fdisplay(tmode_logfile,"HS mode Bist Test Fail");
         end
		 
		 //--------------------------------------------------------------
		 //xcvrsel = 2'b01;
		 //vcontrol = 4'b0010;
		 repeat(10) @(negedge clk);
		 rst_o = 1'b1;
		 repeat(10) @(negedge clk);
		 rst_o = 1'b0;

		 repeat(10) @(negedge clk);
		 
		 $display("1-2)Start FS mode Bist test =================================");	
		 $fdisplay(tmode_logfile,"1-2)Start FS mode Bist test =================================");	
		 set_bist_mode(4'b0010);
		 
		 repeat(10) @(negedge clk);

		 // check result
		 if(vstatus == 8'h10) begin
		   $display("FS mode Bist Test OK");
		   $fdisplay(tmode_logfile,"FS mode Bist Test OK");
         end
		 else begin
			$display("FS mode Bist Test Fail");
			$fdisplay(tmode_logfile,"FS mode Bist Test Fail");
         end


		 //------------------------------------------------------------
		 xcvrsel = 2'b00;
		 repeat(10) @(negedge clk);
		 rst_o = 1'b1;
		 repeat(10) @(negedge clk);
		 rst_o = 1'b0;

		 repeat(30) @(negedge clk);

		 @(negedge clk);
		 vcontrol = 0;
		 repeat(5) @(negedge clk);
		 onbist = 1'b1;
		 repeat(8) @(negedge clk);
		 onbist = 1'b0;
		 @(negedge clk);

	 
		 //========================================================
		 // Full Speed output test
		 full_speed_output_test;

		 //========================================================
		 // High speed output test
		 high_speed_output_test;

		 //========================================================
		 // Linestate test
		 linestate_test;

		 //========================================================
		 // Full Speed/Low Speed Idle test
		 FS_LS_idle_test;
		 		 
	  end
   endtask // production_test

   
   //---------------------------------------------------------------
   // PHY Bist test
   reg         start_bist;
   reg [15:0]  bist_time;
   
   
   task set_bist_mode;
	  input [3:0]  mode;
	  begin
		 repeat(2) @(negedge clk);
		 onbist = 1'b0;

		 dpdown = 1'b0;
		 dndown = 1'b0;

		 
		 @(negedge clk);
		 vcontrol = mode;
		 repeat(5) @(negedge clk);
		 onbist = 1'b1;
		 repeat(8) @(negedge clk);
		 onbist = 1'b0;
		 @(negedge clk);

		 start_bist = 1'b1;
		 bist_time = {16{1'b0}};
		 
		 // Wait the end of the bist test
		 //wait(bist_time>16'd1800);
		 wait(vstatus[4]==1'b1 || bist_time>16'd1300);
		 start_bist = 1'b0;
		 
		 @(negedge clk);
		 
	  end
   endtask // wr_cmd


   always@(negedge clk or posedge rst_o) begin
	  if(rst_o) begin
		 bist_time = {16{1'b0}};
	  end
	  else if(start_fg == 1'b0 || start_bist == 1'b0)
		bist_time = {16{1'b0}};
	  else begin
		 bist_time = bist_time + 1;
		 if(bist_time == 16'd1300) begin
			$display("Bist Time Over!!!!!!");
			$fdisplay(tmode_logfile,"Bist Time Over!!!!!!");
			//$stop;
		 end // if time over
	  end // else
   end // always
   


   //--------------------------------------------------------------
   // Full speed output test
   task full_speed_output_test;
	  begin
		 repeat(100) @(negedge clk);
		 $display("2) Start FS output test =================================");	
		 $fdisplay(tmode_logfile,"2) Start FS output test =================================");	
		 onbist = 1'b0;
		 dpdown = 1'b0;
		 dndown = 1'b0;
		 
		 xcvrsel = 2'b01;
		 termsel = 1'b1;
		 opmode = 2'b10;
		 datain = 'hff;
		 txvalid = 1'b1;
		 repeat(20) @(negedge clk);
		 if(USB_DP == 1'b1 && USB_DN == 1'b0) begin
		   $display("%t Full speed J state OK",$time);
		   $fdisplay(tmode_logfile,"%t Full speed J state OK",$time);
         end
		 else begin
			$display("%t Full speed J state FAIL!!!",$time);
			$fdisplay(tmode_logfile,"%t Full speed J state FAIL!!!",$time);
         end
		 
		 datain = 'h00;
		 repeat(20) @(negedge clk);
		 if(USB_DP == 1'b0 && USB_DN == 1'b1) begin
		   $display("%t Full speed K state OK",$time);
		   $fdisplay(tmode_logfile,"%t Full speed K state OK",$time);
         end
		 else begin
           $display("%t Full speed K state FAIL!!!",$time);
           $fdisplay(tmode_logfile,"%t Full speed K state FAIL!!!",$time);
         end
		 txvalid = 1'b0;
	  end
   endtask // full_speed_output_test

   
   //--------------------------------------------------------------
   // High speed output test
   
   task high_speed_output_test;
	  begin
		 repeat(100) @(negedge clk);
		 $display("3) Start HS output test =================================");	
		 $fdisplay(tmode_logfile,"3) Start HS output test =================================");	
		 xcvrsel = 2'b00;
		 termsel = 1'b0;
		 repeat(100) @(negedge clk);
		 if(USB_DP == 1'b0 && USB_DN == 1'b0) begin
		   $display("SE0 state OK");
		   $fdisplay(tmode_logfile,"SE0 state OK");
         end
		 else begin
			$display("SE0 state FAIL!!!");
			$fdisplay(tmode_logfile,"SE0 state FAIL!!!");
         end
		 
		 datain = 'hFF;
		 txvalid = 1'b1;
		 repeat(20) @(negedge clk);
		 if(USB_DP == 1'b1 && USB_DN == 1'b0) begin
		   $display("High speed J state OK");
		   $fdisplay(tmode_logfile,"High speed J state OK");
         end
		 else begin
			$display("High speed J state FAIL!!!");
			$fdisplay(tmode_logfile,"High speed J state FAIL!!!");
         end

		 datain = 'h00;
		 repeat(20) @(negedge clk);
		 if(USB_DP == 1'b0 && USB_DN == 1'b1) begin
		   $display("Full speed K state OK");
		   $fdisplay(tmode_logfile,"Full speed K state OK");
         end
		 else begin
	       $display("Full speed K state FAIL!!!");
	       $fdisplay(tmode_logfile,"Full speed K state FAIL!!!");
         end
		 txvalid = 1'b0;
	  end
   endtask // high_speed_output_test
   
   
   //--------------------------------------------------------------
   // Linestate test
   
   task linestate_test;
	  begin
		 repeat(100) @(negedge clk);
		 $display("4) Linestate test =================================");	
		 $fdisplay(tmode_logfile,"4) Linestate test =================================");	
		 
		 dpdown = 1'b0;
		 dndown = 1'b0;
		 dp_set = 1'bz;
		 dn_set = 1'bz;

		 xcvrsel = 2'b00;
		 termsel = 1'b0;
		 opmode = 2'b00;
		 repeat(20) @(negedge clk);
		 // voltage check

		 if(linestate == 2'b00) begin
		   $display("Linestate Ready SE0 OK");
		   $fdisplay(tmode_logfile,"Linestate Ready SE0 OK");
         end
		 else begin
		   $display("Linestate Ready SE0 FAIL!!!");
		   $fdisplay(tmode_logfile,"Linestate Ready SE0 FAIL!!!");
		 end 
		 // check the linestate detect
		 dp_set = 1;
		 dn_set = 0;

		 repeat(2) @(negedge clk);
		 if(linestate == 2'b01) begin
		   $display("Linestate Change OK");
		   $fdisplay(tmode_logfile,"Linestate Change OK");
         end
		 else begin
		   $display("Linestate Change FAIL!!!");
		   $fdisplay(tmode_logfile,"Linestate Change FAIL!!!");
         end

		 repeat(2) @(negedge clk);

		 dp_set = 1'bz;
		 dn_set = 1'bz;
		 
		 xcvrsel = 2'b01;
		 termsel = 1'b1;
		 
		 repeat(100) @(negedge clk);
		 /*
		 if(linestate == 2'b00)
		   $display("Linestate Change SE0 OK");
		 else $display("Linestate Change SE0 FAIL!!!");
		 */
		 dp_set = 1'b1;
		 dn_set = 1'b0;

		 repeat(3) @(negedge clk);		 
		 if(linestate == 2'b01) begin
		   $display("Linestate Change FS J OK");
		   $fdisplay(tmode_logfile,"Linestate Change FS J OK");
         end
		 else begin
		   $display("Linestate Change FS J FAIL!!!");
		   $fdisplay(tmode_logfile,"Linestate Change FS J FAIL!!!");
         end
		 
		 dp_set = 1'b0;
		 dn_set = 1'b1;

		 repeat(2) @(negedge clk);		 
		 if(linestate == 2'b10) begin
		   $display("Linestate Change FS K OK");
		   $fdisplay(tmode_logfile,"Linestate Change FS K OK");
         end
		 else begin
		   $display("Linestate Change FS K FAIL!!!");
		   $fdisplay(tmode_logfile,"Linestate Change FS K FAIL!!!");
         end

		 dp_set = 1'bz;
		 dn_set = 1'bz;
	  end
   endtask // linestate_test
   

   //--------------------------------------------------------------
   // Full Speed/Low Speed Idle test

   task FS_LS_idle_test;
	  begin
		 repeat(100) @(negedge clk);
		 $display("5) Full Speed/Low Speed Idle test ======================");	
		 $fdisplay(tmode_logfile,"5) Full Speed/Low Speed Idle test ======================");	
		 
		 xcvrsel = 2'b01;
		 termsel = 1'b1;
		 opmode = 2'b00;
		 txvalid = 1'b0;

		 repeat(20) @(negedge clk);

		 // check the voltage of the DP
		 if(USB_DP == 1'b1) begin
		   $display("D+  OK");
		   $fdisplay(tmode_logfile,"D+  OK");
         end
		 else begin
		   $display("D+  FAIL!!!");
		   $fdisplay(tmode_logfile,"D+  FAIL!!!");
         end

		 xcvrsel = 2'b10;
		 
		 repeat(20) @(negedge clk);

		 // check the voltage of the DN
		 if(USB_DN == 1'b1) begin
		   $display("D-  OK");
		   $fdisplay(tmode_logfile,"D-  OK");
         end
		 else begin
			$display("D-  FAIL!!!");
			$fdisplay(tmode_logfile,"D-  FAIL!!!");
         end
	  end
   endtask // FS_LS_idle_test
   




   
   //====================================================================
   integer       c_num;

   // probing GPANAIO
   task loopback_mode;
	  begin
		 xcvrsel = 2'b00;
		 termsel = 1'b0;
		 @(negedge clk);
		 
		 suspend = 1'b1;
		 @(negedge clk);

		 wr_cmd(4'b0001);

		 suspend = 1'b0;
		 @(negedge clk);

		 vcontrol = 4'b0001;
		 repeat(20) @(negedge clk);

		 for(c_num=3;c_num<11;c_num=c_num+1) begin
			vcontrol = c_num[3:0];
			repeat(20) @(negedge clk);
		 end // for
			 
	  end
   endtask // loopback_mode
   
  
			 
   // vstatus[4:0] 변화를 check.
   task rescal_mode;
	  begin
		 suspend = 1'b1;
		 @(negedge clk);

		 wr_cmd(4'b0101);

		 suspend = 1'b0;
		 @(negedge clk);

		 // Nmos increament
		 for(c_num=0;c_num<32;c_num=c_num+1) begin
			vcontrol = {1'b0,1'b1,1'b0,1'b0};
			@(negedge clk);
			vcontrol = {1'b0,1'b1,1'b0,1'b1};
			@(negedge clk);
		 end

		 // Pmos increament
		 for(c_num=0;c_num<32;c_num=c_num+1) begin
			vcontrol = {1'b1,1'b1,1'b0,1'b0};
			@(negedge clk);
			vcontrol = {1'b1,1'b1,1'b1,1'b0};
			@(negedge clk);
		 end
		 
		 // Nmos decreament
		 for(c_num=0;c_num<32;c_num=c_num+1) begin
			vcontrol = {1'b0,1'b0,1'b0,1'b0};
			@(negedge clk);
			vcontrol = {1'b0,1'b0,1'b0,1'b1};
			@(negedge clk);
		 end

		 // Pmos decreament
		 for(c_num=0;c_num<32;c_num=c_num+1) begin
			vcontrol = {1'b1,1'b0,1'b0,1'b0};
			@(negedge clk);
			vcontrol = {1'b1,1'b0,1'b1,1'b0};
			@(negedge clk);
		 end
	  end
   endtask // rescal_mode

   
   task hsrec;
	  begin
		 suspend = 1'b1;
		 @(negedge clk);

		 wr_cmd(4'b0110);

		 suspend = 1'b0;
		 @(negedge clk);

		 vcontrol = 4'b1111;
		 repeat(10) @(negedge clk);

		 repeat(100) begin
			dp_set = 1'b1;
			dn_set = 1'b0;
			#2;
			dp_set = 1'b0;
			dn_set = 1'b1;
			#2;
		 end // repeat (20)
		 
		 dp_set = 1'b1;
		 dn_set = 1'b0;
		 #2
		 dp_set = 1'b1;
		 dn_set = 1'b0;
		 #2
		 dp_set = 1'b0;
		 dn_set = 1'b1;
		 #2
		 dp_set = 1'b0;
		 dn_set = 1'b1;
		 repeat(10) @(negedge clk);
	  end
   endtask // hsrec
   

   task lfsrec;
	  begin
		 suspend = 1'b1;
		 @(negedge clk);

		 wr_cmd(4'b0111);

		 suspend = 1'b0;
		 @(negedge clk);

		 vcontrol = 4'b0011;
		 repeat(10) @(negedge clk);
		 
		 repeat(100) begin
			dp_set = 1'b1;
			dn_set = 1'b0;
			#71;
			dp_set = 1'b0;
			dn_set = 1'b1;
			#72;
		 end // repeat (20)
		 
		 dp_set = 1'b1;
		 dn_set = 1'b0;
		 #2
		 dp_set = 1'b1;
		 dn_set = 1'b0;
		 #2
		 dp_set = 1'b1;
		 dn_set = 1'b0;
		 #2
		 dp_set = 1'b0;
		 dn_set = 1'b1;
		 #2
		 dp_set = 1'b0;
		 dn_set = 1'b1;
		 repeat(10) @(negedge clk);
	  end
   endtask // hsrec
   


   

   //--------------------------------------------------------------
   task wr_cmd;
	  input [3:0]  mode;
	  begin
		 repeat(2) @(negedge clk);
		 vload = 1'b0;
		 @(negedge clk);
		 vcontrol = mode;
		 @(negedge clk);
		 vload = 1'b1;
		 repeat(2) @(negedge clk);
		 vload = 1'b0;
		 @(negedge clk);
	  end
   endtask // wr_cmd


   initial begin
	  c_num = 0;
	  start_bist = 0;
	  bist_time = 0;
   end // initial
   
endmodule // USBPHY_tb
