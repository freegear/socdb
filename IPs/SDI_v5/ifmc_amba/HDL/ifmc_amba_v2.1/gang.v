/*
   SDI Gang Simulation Model
 
   filename : gang.v
 
   created by : gtlee
 
   creaded data : 2006.3.10
 
 
 
 */
`timescale 1ns/10ps

`ifdef   GANG

 `define     CKP1         `PERIOD
 `define     DLY          3

`else

`define     CKP1         7
`define     DLY          3

`endif

//--------------------------------------------------
//`define    GANG_DN_EN       1



//--------------------------------------------------
// Timing

`define     SRD_HCLK     (`CKP1 * 37 / 2)
`define     SWR_HCLK     (`CKP1 * 217 /2) //need 3.4us


`define     MEM          3'b011
`define     PROT_ERASE   3'b111

`define     RD           1
`define     WR           0

`define     CHIP_ERASE   20'b0000_0001_0101_0000_0000;
`define     SMART        20'b0000_0000_1110_0011_1000;
`define     PROTECT      20'b0000_0000_1110_0011_1100;

`define     SMART_MSK    32'hFFFF0000   // Smart 값과 OR한다.
`define     SET_HDP      32'hfffDffff
`define     SET_RDP      32'hf7ffffff


module   gang
  (
   clk        ,
   rstb       ,

   tmode      ,
   scl        ,
   sda_in     ,
   sda_out    ,

   tstart      
   );

   parameter         rom_size = (256*1024/4);
   
		     
   input             clk;
   input 	     rstb;
   
   output 	     tmode;
   output 	     scl;
   output 	     sda_in;
   input 	     sda_out;
   
   input 	     tstart;
   
   //------------------------------------------
   //
   wire 	     clki;
   
   reg 		     tmode;
   reg 		     scl;
   reg 		     sda_in;  // SDI v5의 입장에서 입력.
   
   reg [31:0] 	     rd_data;
   reg 		     rd_end;
   
   reg 		     ReadOp;
   reg 		     WriteOp;
   
   reg [7:0] 	     addr0;
   reg [7:0] 	     addr1;
   reg [7:0] 	     addr2;
   
   integer 	     gang_logfile;
   
   // for gang down load
   reg 		     dn_en;
   
   reg [31:0] 	     rom[0:rom_size-1]; // 64kbyte

   integer           i;
   reg [17:0] 	     tadr;
   

   assign           clki = ~clk;
   

  
   initial begin
      tmode = 0;
      scl = 0;
      sda_in = 1;
      rd_data = 0;
      rd_end = 0;
      
      ReadOp = 0;
      WriteOp = 0;
      
      addr0 = 0;
      addr1 = 0;
      addr2 = 0;

      tadr = 0;
      dn_en = 1'b0;
      
      wait(tstart);
      gang_logfile = $fopen("gang.log");

      
`ifdef  GANG_DN_EN
      $readmemh("./rom/SDI_V5.flash",rom);

      dn_en = 1'b1;
`endif      

      $display("dnen = %x",dn_en);
      
   end // initial
      
   
   // Test Serial Down Load
   // Enter to tool mode
   task set_tool_mode;
	  begin
		 @(posedge clki) #`DLY
		   tmode = 1;
		 
		 repeat(10) @(posedge clki);
		 scl = 1;

		 repeat(50) @(posedge clki);
		 scl = 0;

		 $fdisplay(gang_logfile,"Enter Tool Mode");
		 $display("Enter Tool Mode");
		 
	  end
   endtask // set_tool_mode

   // exit from test mode
   task exit_tool_mode;
	  begin
		 @(posedge clki) #`DLY
		   scl = 0;
		 repeat(20) @(posedge clki);		 
		 tmode = 0;
		 
		 $fdisplay(gang_logfile,"Exit Tool Mode");
		 $display("Exit Tool Mode");
	  end
   endtask // exit_tool_mode

   // Serial communication
   // Command와 address를 보내는 task와 data를 주고 받는 task를 분리.
   task addr_phase;
	  input [2:0]  mode;
	  input        rd_wr;
	  input [17:0] addr;
	  begin
		 @(posedge clki) #`DLY  scl = 1'b0;

		 if(rd_wr == 1 ) begin
			
			// start signal
			#(`SRD_HCLK/2) sda_in = 0;
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK/2) sda_in = 1;
			#(`SRD_HCLK/2) scl = 1'b0;
			
			// reg/mem
			#(`SRD_HCLK/2) sda_in = mode[2]; // reg/mem
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			// Mode
			#(`SRD_HCLK/2) sda_in = mode[1]; // M1
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in = mode[0]; // M0
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			// Address 0
			#(`SRD_HCLK/2) sda_in =        0; // A19
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in =        0; // A18
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in = addr[17]; // A17
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in = addr[16]; // A16
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			// R/W
			#(`SRD_HCLK/2) sda_in = 1; // Read
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in =        1; // dummy
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;

			addr0 = {mode,2'b00,addr[17:16],1'b1};
			
			// Address 1
			#(`SRD_HCLK/2) sda_in = addr[15]; // A15
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in = addr[14]; // A14
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in = addr[13]; // A13
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in = addr[12]; // A12
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in = addr[11]; // A11
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in = addr[10]; // A10
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in = addr[ 9]; // A 9
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in = addr[ 8]; // A 8
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in =        1; // dummy
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;

			addr1 = {addr[15:8]};
			
			// Address 2
			#(`SRD_HCLK/2) sda_in = addr[ 7]; // A 7
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in = addr[ 6]; // A 6
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in = addr[ 5]; // A 5
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in = addr[ 4]; // A 4
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in = addr[ 3]; // A 3
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in = addr[ 2]; // A 2
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;

			#(`SRD_HCLK/2) sda_in =        0; // A 1
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in =        0; // A 0
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;
			
			#(`SRD_HCLK/2) sda_in =        1; // dummy
			#(`SRD_HCLK/2) scl = 1'b1;
			#(`SRD_HCLK)   scl = 1'b0;

			addr2 = {addr[7:0],2'b00};

			if(mode[2] == 1) begin // protection read
			   //$fdisplay(gang_logfile,"Protection Read : ");
			   if(addr[12:0] == 13'h0E38) begin
				 $fdisplay(gang_logfile,"Protection Read : Smart Option");
				 $display("Protection Read : Smart Option");
			   end
			   else if(addr[12:0] == 13'h0E3C) begin
				 $fdisplay(gang_logfile,"Protection Read : Prot. Option");
				 $display("Protection Read : Prot. Option");
			   end
			   else begin
				  $fdisplay(gang_logfile,"Protection Read : Wrong Addr");
				  $display("Protection Read : Wrong Addr");
			   end
			end
			else begin
			   $fdisplay(gang_logfile,"Flash Memory Read : 0x%X",addr);
			   $display("Flash Memory Read : 0x%X",addr);
			end
			   
		 end // if (rd_wr == 1 )
		 else begin // at writing

			// start signal
			#(`SWR_HCLK/2) sda_in = 0;
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK/2) sda_in = 1;
			#(`SWR_HCLK/2) scl = 1'b0;
			
			// reg/mem
			#(`SWR_HCLK/2) sda_in = mode[2]; // reg/mem
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			// Mode
			#(`SWR_HCLK/2) sda_in = mode[1]; // M1
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = mode[0]; // M0
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			// Address 0
			#(`SWR_HCLK/2) sda_in =        0; // A19
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        0; // A18
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = addr[17]; // A17
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = addr[16]; // A16
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			// R/W
			#(`SWR_HCLK/2) sda_in = 0; // write
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        1; // dummy
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;

			addr0 = {mode,2'b00,addr[17:16],1'b0};

			// Address 1
			#(`SWR_HCLK/2) sda_in = addr[15]; // A15
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = addr[14]; // A14
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = addr[13]; // A13
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = addr[12]; // A12
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = addr[11]; // A11
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = addr[10]; // A10
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = addr[ 9]; // A 9
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = addr[ 8]; // A 8
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        1; // dummy
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;

			addr1 = {addr[15:8]};
			
			// Address 2
			#(`SWR_HCLK/2) sda_in = addr[ 7]; // A 7
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = addr[ 6]; // A 6
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = addr[ 5]; // A 5
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = addr[ 4]; // A 4
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = addr[ 3]; // A 3
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = addr[ 2]; // A 2
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;

			#(`SWR_HCLK/2) sda_in =        0; // A 1
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        0; // A 0
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        1; // dummy
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;

			addr2 = {addr[7:2],2'b00};

			if(mode[2] == 1) begin // protection read
			   //$fdisplay(gang_logfile,"Protection Write : ");
			   if(addr[12:0] == 13'h0E38) begin
				 $fdisplay(gang_logfile,"Protection Write : Smart Option");
				 $display("Protection Write : Smart Option");
			   end
			   else if(addr[12:0] == 13'h0E3C) begin
				 $fdisplay(gang_logfile,"Protection Write : Prot. Option");
				 $display("Protection Write : Prot. Option");
			   end
			   else begin
				  $fdisplay(gang_logfile,"Protection Write : Wrong Addr");
				  $display("Protection Write : Wrong Addr");
			   end
			end
			else begin
			   $fdisplay(gang_logfile,"Flash Memory Write : 0x%X",addr);
			   $display("Flash Memory Write : 0x%X",addr);
			end
			   
		 end // else: !if(rd_wr == 1 )
	  end
   endtask // addr_phase
   

   task data_phase_wr;
	  input [31:0] data;
	  begin
		 #(`SWR_HCLK) scl = 1'b0;
		 // data 0
		 #(`SWR_HCLK/2) sda_in = data[ 7]; // D7
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[ 6]; // D6
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;
		 
		 #(`SWR_HCLK/2) sda_in = data[ 5]; // D5 
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[ 4]; // D4
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[ 3]; // D3
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[ 2]; // D2
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[ 1]; // D1
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[ 0]; // D0
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in =        1; // dummy
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 // data 1
		 #(`SWR_HCLK/2) sda_in = data[15]; // D15
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[14]; // D14
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;
		 
		 #(`SWR_HCLK/2) sda_in = data[13]; // D13
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[12]; // D12
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[11]; // D11
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[10]; // D10
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[ 9]; // D 9
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[ 8]; // D 8
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in =        1; // dummy
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;
		 
		 // data 2
		 #(`SWR_HCLK/2) sda_in = data[23]; // D23
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[22]; // D22
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;
		 
		 #(`SWR_HCLK/2) sda_in = data[21]; // D21
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[20]; // D20
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[19]; // D19
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[18]; // D18
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[17]; // D17
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[16]; // D16
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in =        1; // dummy
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 // data 3
		 #(`SWR_HCLK/2) sda_in = data[31]; // D31
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[30]; // D30
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;
		 
		 #(`SWR_HCLK/2) sda_in = data[29]; // D29
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[28]; // D28
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[27]; // D27
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[26]; // D26
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[25]; // D25
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = data[24]; // D24
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in =        1; // dummy
		 #(`SWR_HCLK/2) scl = 1'b1;
		 //#(`SWR_HCLK)   scl = 1'b0;

		 $fdisplay(gang_logfile," Write : 0x%X",data);
		 $display(" Write : 0x%X",data);

	  end
   endtask // data_phase_wr

   task wr_dummy;
	  begin
		 #(`SWR_HCLK) scl = 1'b0;
		 // data 3
		 #(`SWR_HCLK/2) sda_in = 1; // D31
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D30
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;
		 
		 #(`SWR_HCLK/2) sda_in = 1; // D29
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D28
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D27
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D26
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D25
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D24
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // dummy
		 #(`SWR_HCLK/2) scl = 1'b1;
		 //#(`SWR_HCLK)   scl = 1'b0;
	  end
   endtask
      
   task data_phase_rd;
	  begin
		 #(`SRD_HCLK) scl = 1'b0;
		 rd_end = 1;
		 
		 // data 0
		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[ 7] = sda_out; // D7
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[ 6] = sda_out; // D6
		 #(`SRD_HCLK/2)   scl = 1'b0;
		 
		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[ 5] = sda_out; // D5 
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[ 4] = sda_out; // D4
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[ 3] = sda_out; // D3
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[ 2] = sda_out; // D2
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[ 1] = sda_out; // D1
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[ 0] = sda_out; // D0
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 // dummy
		 #(`SRD_HCLK)   scl = 1'b1;
		 #(`SRD_HCLK)   scl = 1'b0;

		 // data 1
		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[15] = sda_out; // D15
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK)   scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[14] = sda_out; // D14
		 #(`SRD_HCLK/2) scl = 1'b0;
		 
		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[13] = sda_out; // D13
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[12] = sda_out; // D12
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[11] = sda_out; // D11
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[10] = sda_out; // D10
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[ 9] = sda_out; // D 9
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[ 8] = sda_out; // D 8
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 // dummy
		 #(`SRD_HCLK)   scl = 1'b1;
		 #(`SRD_HCLK)   scl = 1'b0;
		 
		 // data 2
		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[23] = sda_out; // D23
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[22] = sda_out; // D22
		 #(`SRD_HCLK/2)   scl = 1'b0;
		 
		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[21] = sda_out; // D21
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[20] = sda_out; // D20
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[19] = sda_out; // D19
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[18] = sda_out; // D18
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[17] = sda_out; // D17
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[16] = sda_out; // D16
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 // dummy
		 #(`SRD_HCLK)   scl = 1'b1;
		 #(`SRD_HCLK)   scl = 1'b0;

		 // data 3
		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[31] = sda_out; // D31
		 #(`SRD_HCLK)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[30] = sda_out; // D30
		 #(`SRD_HCLK/2)   scl = 1'b0;
		 
		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[29] = sda_out; // D29
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[28] = sda_out; // D28
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[27] = sda_out; // D27
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[26] = sda_out; // D26
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[25] = sda_out; // D25
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 #(`SRD_HCLK) scl = 1'b1;
		 #(`SRD_HCLK/2) rd_data[24] = sda_out; // D24
		 #(`SRD_HCLK/2)   scl = 1'b0;

		 // dummy
		 #(`SRD_HCLK)   scl = 1'b1;
		 //#(`SRD_HCLK)   scl = 1'b0;

		 $fdisplay(gang_logfile," Read : 0x%X",rd_data);
		 $display(" Read : 0x%X",rd_data);
		 
		 @(posedge clki) #`DLY
		   rd_end = 1;
		 repeat(2) @(posedge clki);
		 rd_end = 0;
		 
	  end
   endtask // sda_out_phase_rd
      
   task stop_op;
	  begin
		 //#(`SWR_HCLK)   scl = 1'b0;
		 #(`SWR_HCLK/2) sda_in = 1'b1;
		 
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK/2) sda_in = 1'b0;
		 #(`SWR_HCLK*4) sda_in = 1'b1;  // 8us delay
		 #(`SWR_HCLK/4) scl = 1'b0;
		 #(`SWR_HCLK/2) sda_in = 1'b0;
	  end
   endtask // stop_op
   

   task chip_erase;
	  begin
			// start signal
			#(`SWR_HCLK/2) sda_in =        0;
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK/2) sda_in =        1;
			#(`SWR_HCLK/2) scl = 1'b0;
			
			// reg/mem
			#(`SWR_HCLK/2) sda_in =        1; // reg/mem
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			// Mode
			#(`SWR_HCLK/2) sda_in =        1; // M1
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        1; // M0
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			// Address 0
			#(`SWR_HCLK/2) sda_in =        0; // A19
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        0; // A18
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        0; // A17
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        0; // A16
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			// R/W
			#(`SWR_HCLK/2) sda_in =        0; // write
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        1; // dummy
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;

			addr0 = {3'b111,4'h0,1'b0};

			// Address 1
			#(`SWR_HCLK/2) sda_in =        0; // A15
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        0; // A14
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        0; // A13
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        1; // A12
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        0; // A11
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        1; // A10
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        0; // A 9
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        1; // A 8
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        1; // dummy
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;

			addr1 = {8'b00010101};
			
			// Address 2
			#(`SWR_HCLK/2) sda_in = 0; // A 7
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = 0; // A 6
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = 0; // A 5
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = 0; // A 4
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = 0; // A 3
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in = 0; // A 2
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;

			#(`SWR_HCLK/2) sda_in =        0; // A 1
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        0; // A 0
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;
			
			#(`SWR_HCLK/2) sda_in =        1; // dummy
			#(`SWR_HCLK/2) scl = 1'b1;
			#(`SWR_HCLK)   scl = 1'b0;

		 addr2 = {8'h00};
		 
		 // data 0
		 #(`SWR_HCLK/2) sda_in = 1; // D7
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D6
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;
		 
		 #(`SWR_HCLK/2) sda_in = 1; // D5 
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D4
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D3
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D2
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D1
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D0
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 // dummy
		 #(`SWR_HCLK)   scl = 1'b1;
		 # 20000000   ; // 20ms
		 #(`SWR_HCLK)   scl = 1'b0;

		 // data 1
		 #(`SWR_HCLK/2) sda_in = 1; // D15
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D14
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;
		 
		 #(`SWR_HCLK/2) sda_in = 1; // D13
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D12
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D11
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D10
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D 9
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 #(`SWR_HCLK/2) sda_in = 1; // D 8
		 #(`SWR_HCLK/2) scl = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 // dummy
		 #(`SWR_HCLK)   scl = 1'b1;
		 #100000 ;   // 100us
 
		 // Stop_op Condition
		 #(`SWR_HCLK/2) sda_in = 1'b0;
		 #(`SWR_HCLK/2) sda_in = 1'b1;
		 #(`SWR_HCLK)   scl = 1'b0;

		 $fdisplay(gang_logfile,"Chip Erase");
		 $display("Chip Erase");

	  end
   endtask // chip_erase
   

   //----------------------------------------------------
   // Test sequence
   always@(posedge clki) begin
      if(rstb & tstart ) begin
	 if( ~dn_en) begin
	    // Enter Tool Mode
	    set_tool_mode;
	    
	    //----------------------------------------
	    // Chip Erase
	    $fdisplay(gang_logfile,"\n");
	    chip_erase;
	    
	    repeat(2) @(posedge clki);
	    
	    //----------------------------------------
	    // flash programming at page 00h
	    $fdisplay(gang_logfile,"\n");
	    
	    $fdisplay(gang_logfile,"Data is Written");
	    $display("Data is Written");
	    ReadOp = 0;
	    WriteOp = 1;
	    
	    addr_phase(`MEM,`WR,18'h00004/* address */ );		 
	    data_phase_wr(32'h12345678); //18'h00004
	    data_phase_wr(32'h9abcdef0); //18'h00008
	    wr_dummy;
	    stop_op;
	    
	    ReadOp = 0;
	    WriteOp = 0;
	    repeat(2) @(posedge clki);
	    
	    // read test
	    ReadOp = 1;
	    WriteOp = 0;
	    
	    addr_phase(`MEM,`RD,18'h00004/* address */ );
	    data_phase_rd;
	    data_phase_rd;
	    stop_op;
	    
	    ReadOp = 0;
	    WriteOp = 0;
	    repeat(2) @(posedge clki);
	    
	    // flash programming page 28h
	    $fdisplay(gang_logfile,"Data is Written");
	    $display("Data is Written");
	    ReadOp = 0;
	    WriteOp = 1;
	    
	    addr_phase(`MEM,`WR,18'h0A00C/* address */ );		 
	    data_phase_wr(32'h5a7510ff); //18'h00004
	    data_phase_wr(32'h019a5567); //18'h00008
	    wr_dummy;
	    stop_op;
	    
	    ReadOp = 0;
	    WriteOp = 0;
	    repeat(2) @(posedge clki);
	    
	    // read test
	    ReadOp = 1;
	    WriteOp = 0;
	    
	    addr_phase(`MEM,`RD,18'h0A00C/* address */ );
	    data_phase_rd;
	    data_phase_rd;
	    stop_op;
	    
	    ReadOp = 0;
	    WriteOp = 0;
	    repeat(2) @(posedge clki);
	    
	    //--------------------------------
	    // HDP test
	    $fdisplay(gang_logfile,"\n");
	    
	    // Set Smart Option
	    $fdisplay(gang_logfile,"Smart Option is Written");
	    $display("Smart Option is Written");
	    ReadOp = 0;
	    WriteOp = 1;
	    
	    addr_phase(`PROT_ERASE,`WR,18'b00_0000_1110_0011_1000);
	    data_phase_wr(32'hfffffffe);
	    wr_dummy;
	    stop_op;
	    
	    ReadOp = 0;
	    WriteOp = 0;
	    
	    repeat(2) @(posedge clki);
	    
	    //     read smart option
	    ReadOp = 1;
	    WriteOp = 0;
	    
	    addr_phase(`PROT_ERASE,`RD,18'b00_0000_1110_0011_1000);
	    data_phase_rd;
	    stop_op;
	    
	    ReadOp = 0;
	    WriteOp = 0;
	    repeat(2) @(posedge clki);
	    
	    // set HDP
	    $fdisplay(gang_logfile,"HDP is set");
	    $display("HDP is set");
	    ReadOp = 0;
	    WriteOp = 1;
	    
	    addr_phase(`PROT_ERASE,`WR,18'b00_0000_1110_0011_1100);
	    data_phase_wr(32'hfffdffff);
	    wr_dummy;
	    stop_op;
	    
	    ReadOp = 0;
	    WriteOp = 0;
	    repeat(2) @(posedge clki);
	    
	    //    read HDP
	    ReadOp = 1;
	    WriteOp = 0;
	    
	    addr_phase(`PROT_ERASE,`RD,18'b00_0000_1110_0011_1100);
	    data_phase_rd;
	    stop_op;
	    
	    ReadOp = 0;
	    WriteOp = 0;
	    repeat(2) @(posedge clki);
	    
	    //--------------------------------------------------
	    // flash programming at page 0
	    $fdisplay(gang_logfile,"\n");
	    
	    $fdisplay(gang_logfile,"Data is not changged");
	    $display("Data is not changged");
	    ReadOp = 0;
	    WriteOp = 1;
	    
	    addr_phase(`MEM,`WR, 18'h00014/* address */ );		 
	    data_phase_wr(32'h00f0f000);
	    data_phase_wr(32'h035ac350);
	    wr_dummy;
	    stop_op;
	    
	    ReadOp = 0;
	    WriteOp = 0;
	    repeat(2) @(posedge clki);
	    
	    // read Flash memory
	    ReadOp = 1;
	    WriteOp = 0;
	    
	    addr_phase(`MEM,`RD, 18'h00014/* address */ );
	    data_phase_rd;
	    data_phase_rd;
	    stop_op;
	    
	    ReadOp = 0;
	    WriteOp = 0;
	    repeat(2) @(posedge clki);
	    
	    // flash programming at page 28h
	    $fdisplay(gang_logfile,"Data is Written");
	    $display("Data is Written");
	    ReadOp = 0;
	    WriteOp = 1;
	    
	    addr_phase(`MEM,`WR,18'h0A02C/* address */ );		 
	    data_phase_wr(32'h11a590f1);
	    data_phase_wr(32'hfcd08329);
	    wr_dummy;
	    stop_op;
	    
	    ReadOp = 0;
	    WriteOp = 0;
	    repeat(2) @(posedge clki);
	    
	    // read Flash memory
	    ReadOp = 1;
	    WriteOp = 0;
	    
	    addr_phase(`MEM,`RD, 18'h0A02C/* address */ );
	    data_phase_rd;
	    data_phase_rd;
	    stop_op;
	    
	    ReadOp = 0;
	    WriteOp = 0;
	    repeat(2) @(posedge clki);
	    
	    //--------------------------------------
	    // RDP test
	    // set HDP
	    $fdisplay(gang_logfile,"\n");
	    
	    $fdisplay(gang_logfile,"Set Read Protection");
	    $display("Set Read Protection");
	    ReadOp = 0;
	    WriteOp = 1;
	    addr_phase(`PROT_ERASE,`WR,18'b00_0000_1110_0011_1100);
	    data_phase_wr(32'hf7ffffff);
	    wr_dummy;
	    stop_op;
	    ReadOp = 0;
	    WriteOp = 0;
	    repeat(2) @(posedge clki);
	    
	    // Read Protection Information
	    ReadOp = 1;
	    WriteOp = 0;
	    
	    addr_phase(`PROT_ERASE,`RD,18'b00_0000_1110_0011_1100);
	    data_phase_rd;
	    stop_op;
	    
	    // smart option
	    $fdisplay(gang_logfile,"Read Smart Option");
	    $display("Read Smart Option");
	    addr_phase(`PROT_ERASE,`RD,18'b00_0000_1110_0011_1000);
	    data_phase_rd;
	    stop_op;
	    
	    ReadOp = 0;
	    WriteOp = 0;
	    repeat(2) @(posedge clki);
	    
	    // read Flash memory
	    $fdisplay(gang_logfile,"Read Data must be 0.");
	    $display("Read Data must be 0.");
	    ReadOp = 1;
	    WriteOp = 0;
	    
	    addr_phase(`MEM,`RD, 18'h00004/* address */ );
	    data_phase_rd;
	    data_phase_rd;
	    stop_op;
	    
	    addr_phase(`MEM,`RD, 18'h0A00C/* address */ );
	    data_phase_rd;
	    data_phase_rd;
	    stop_op;
	    
	    ReadOp = 0;
	    WriteOp = 0;
	    repeat(2) @(posedge clki);
	    
	    //----------------------------------------
	    // Chip Erase
	    $fdisplay(gang_logfile,"\n");
	    
	    chip_erase;
	    
	    repeat(2) @(posedge clki);
	    
	    // Read Protection Information
	    $fdisplay(gang_logfile,"\n");
	    
	    ReadOp = 1;
	    WriteOp = 0;
	    // smart option
	    $fdisplay(gang_logfile,"Read Smart Option");
	    $display("Read Smart Option");
	    
	    addr_phase(`PROT_ERASE,`RD,18'b00_0000_1110_0011_1000);
	    data_phase_rd;
	    stop_op;
	    repeat(2) @(posedge clki);
	    
	    $fdisplay(gang_logfile,"Read Protection Option");
	    $display("Read Protection Option");
	    addr_phase(`PROT_ERASE,`RD,18'b00_0000_1110_0011_1100);
	    data_phase_rd;
	    stop_op;
	    
	    ReadOp = 0;
	    WriteOp = 0;
	    repeat(2) @(posedge clki);
	    
	    // read Flash memory
	    $fdisplay(gang_logfile,"\n");
	    
	    $fdisplay(gang_logfile,"Read Data must be 0.");
	    $display("Read Data must be 0.");
	    ReadOp = 1;
	    WriteOp = 0;
	    
	    addr_phase(`MEM,`RD, 18'h00004/* address */ );
	    data_phase_rd;
	    data_phase_rd;
	    stop_op;
	    
	    addr_phase(`MEM,`RD, 18'h0A00C/* address */ );
	    data_phase_rd;
	    data_phase_rd;
	    stop_op;
	    
	    ReadOp = 0;
	    WriteOp = 0;
	    repeat(2) @(posedge clki);
	    
	    exit_tool_mode;
	    repeat(40) @(posedge clki);
	    
	    wait(~tstart);
	    
	 end  // if
	 else begin
	    // Gang Down load a file
	    $fdisplay(gang_logfile,"File Download with the Gang interface");
	    $display("File Download with the Gang interface");

	    wr_dummy;
	    stop_op;
	    
	 end // else: !if( ~dn_en)
      end // if (rstb & tstart )
      
   end // always
   
   
endmodule // gang

