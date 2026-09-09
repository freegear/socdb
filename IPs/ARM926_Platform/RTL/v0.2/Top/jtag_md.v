/*
 JTAG simulation host model
 
 Created date : 2007.1.12
 File Name   : jtag_md.v
 version     : 0.1

 note :
 
 history :
 
 */

`define DLY 2

`define JTAG_IR_LEN      32'd4
`define JTAG_EXTEST	     4'h0
`define JTAG_SCAN_N	     4'h2
`define JTAG_INTEST	     4'hC
`define JTAG_IDCODE	     4'hE
`define JTAG_BYPASS	     4'hF
`define JTAG_CLAMP	     4'h5
`define JTAG_HIGHZ	     4'h7
`define JTAG_CLAMPZ	     4'h9
`define JTAG_SAMPLE	     4'h3
`define JTAG_RESTART	 4'h4


`define DEBUG_SPEED		    32'd0
`define SYSTEM_SPEED		32'd1
`define DEBUG_SPEED_SHORT	32'd2

module jtag_md
  (
   clk               ,
   rstb              ,
   en                ,

   TDMISO            ,
   TDMOSI            ,
   TMS               ,
   TCK               ,
   TRSTb             
   );

   input           clk;
   input 		   rstb;
   input 		   en;
   
   input 		   TDMISO;
   
   output 		   TDMOSI;
   output 		   TMS;
   output 		   TCK;
   output 		   TRSTb;      // TAP controller reset
   
   //---------------------------------------------------------
   reg 			   TDMOSI;
   reg 			   TMS;
   reg 			   TCK;
   reg 			   TRSTb;

   reg [1:0] 	   en_dly;
   wire            enable;
   
   reg [127:0] 	   rd_buff;
   
   integer         i;
   
   initial begin
	  TRSTb <= 1'b0;
	  TMS <= 1'b1;
	  TDMOSI <= 1'b0;
	  TCK <= 1'b0;
	  rd_buff <= {128{1'b0}};
   end // initial

   always@(posedge clk or negedge rstb) begin
	  if(!rstb) en_dly <= 2'b00;
	  else en_dly <= {en_dly[0],en};
   end // always

   assign enable = (en_dly == 2'b01)? 1'b1 : 1'b0;
   
   always@(posedge clk) begin
	  if(rstb && enable) begin
		 TRSTb = 1;
		 repeat(10) @(posedge clk);

		 rd_id_reg;

		 if(rd_buff[31:0] != 32'h17900f0f) begin
			$display("ARM ID is not matched : 0x%X\n",rd_buff[31:0]);
		 end

		 repeat(100) @(posedge clk);

		 
		 halt_arm;
		 rd_cp15c0b; // 먼저 디버그 모드로 진입한 뒤에 사용해야만 한다.

		 //read_cp_reg(4'hf,4'h0,3'h1); // 동작 안 함.
		 //read_cp_reg(4'hf,4'h0,3'h2); // 동작 안 함.
		 
		 repeat(20) @(posedge clk);
		 
		 TRSTb = 0;
	  end // if
   end // always
   
   //---------------------------------------------------
   // task subroutines
   task go_rst2run;
	  begin
		 repeat(10) @(posedge clk);

		 TMS = 1'b0;
		 repeat(10) @(posedge clk);
		 TCK = 1'b1;
		 repeat(10) @(posedge clk);
		 TCK = 1'b0;
		 repeat(10) @(posedge clk);
		 $display("%t JTAG SM is %x",$time,4'hC);		 
		 // SM == 0xC
	  end
   endtask // go_rst2run

   task run2dr;
	  begin
		 repeat(10) @(posedge clk);

		 TMS = 1'b1;
		 repeat(10) @(posedge clk);
		 TCK = 1'b1;
		 repeat(10) @(posedge clk);
		 TCK = 1'b0;
		 repeat(10) @(posedge clk);
		 $display("%t JTAG SM is %x",$time,4'h7);
		 // SM == 0x7
	  end
   endtask // run2dr

   task run2ir;
	  begin
		 repeat(10) @(posedge clk);

		 TMS = 1'b1;
		 repeat(10) @(posedge clk);
		 TCK = 1'b1;
		 repeat(10) @(posedge clk);
		 TCK = 1'b0;
		 repeat(10) @(posedge clk);
		 
		 repeat(10) @(posedge clk);
		 TCK = 1'b1;
		 repeat(10) @(posedge clk);
		 TCK = 1'b0;
		 repeat(10) @(posedge clk);
		 $display("%t JTAG SM is %x",$time,4'h4);
		 // SM == 0x4
	  end
   endtask // run2ir
   
   task rd_reg;
	  input [31:0] bit_cnt;
	  begin
		 repeat(10) @(posedge clk);
		 $display("%t Read register",$time);

		 // capture
		 TMS = 1'b0;
		 repeat(10) @(posedge clk);
		 TCK = 1'b1;
		 repeat(10) @(posedge clk);
		 TCK = 1'b0;
		 repeat(10) @(posedge clk);
		 //      SM == 0x6
		 $display("%t JTAG SM is %x",$time,4'h6);
		 
		 // Shift reg
		 TCK = 1'b1;
		 repeat(10) @(posedge clk);
		 TCK = 1'b0;
		 repeat(10) @(posedge clk);
		 //      SM == 0x2
		 $display("%t JTAG SM is %x",$time,4'h2);

		 // get and set regs
		 repeat(bit_cnt-1) begin
			TCK = 1'b1;
			repeat(10) @(posedge clk);
			rd_buff = {TDMISO,rd_buff[127:1]};
			TDMOSI = TDMISO;
			repeat(10) @(posedge clk);
			TCK = 1'b0;
			repeat(10) @(posedge clk);
			//      SM == 0x2
			$display("%t JTAG SM is %x",$time,4'h2);
		 end // repeat

		 // exit 1
		 TMS = 1'b1;
		 repeat(10) @(posedge clk);
		 TCK = 1'b1;
		 repeat(10) @(posedge clk);
		 rd_buff = {TDMISO,rd_buff[127:1]};
		 TDMOSI = TDMISO;
		 // display rd data
		 $display("%t a Read JTAG data is %x",$time,rd_buff);
		 repeat(128-bit_cnt) begin
			rd_buff = {1'b0,rd_buff[127:1]};
		 end // repeat
		 $display("%t a Read JTAG data is %x",$time,rd_buff);

		 repeat(10) @(posedge clk);
		 TCK = 1'b0;
		 repeat(10) @(posedge clk);
		 //      SM == 0x1
		 $display("%t JTAG SM is %x",$time,4'h1);

		 // update
		 TCK = 1'b1;
		 repeat(10) @(posedge clk);
		 TCK = 1'b0;
		 repeat(10) @(posedge clk);
		 //      SM == 0x5
		 $display("%t JTAG SM is %x",$time,4'h5);

		 // run
		 TMS = 1'b0;
		 repeat(10) @(posedge clk);
		 TCK = 1'b1;
		 repeat(10) @(posedge clk);
		 TCK = 1'b0;
		 repeat(10) @(posedge clk);
		 //      SM == 0xC
		 $display("%t JTAG SM is %x",$time,4'hC);
		 $display("%t End Read register\n",$time);
	  end
   endtask // rd_reg
   

   task wr_reg;
	  input [31:0] bit_cnt;
	  input [127:0] wr_data;
	  begin
		 repeat(10) @(posedge clk);
		 $display("%t Write register 0x%X",$time,wr_data);
		 
		 // capture
		 TMS = 1'b0;
		 repeat(10) @(posedge clk);
		 TCK = 1'b1;
		 repeat(10) @(posedge clk);
		 TCK = 1'b0;
		 repeat(10) @(posedge clk);
		 //      SM == 0x6
		 $display("%t JTAG SM is %x",$time,4'h6);
		 
		 // Shift reg
		 TCK = 1'b1;
		 repeat(10) @(posedge clk);
		 TCK = 1'b0;
		 repeat(10) @(posedge clk);
		 //      SM == 0x2
		 $display("%t JTAG SM is %x",$time,4'h2);

		 // get and set regs
		 repeat(bit_cnt-1) begin
			TDMOSI = wr_data[0];
			repeat(10) @(posedge clk);
			TCK = 1'b1;
			repeat(10) @(posedge clk);
			rd_buff = {TDMISO,rd_buff[127:1]};
			repeat(10) @(posedge clk);
			TCK = 1'b0;
			repeat(10) @(posedge clk);
			wr_data = {wr_data[0],wr_data[127:1]};
			repeat(10) @(posedge clk);
		 //      SM == 0x2
		 $display("%t JTAG SM is %x",$time,4'h2);
		 end // repeat

		 TDMOSI = wr_data[0];
		 
		 // exit 1
		 TMS = 1'b1;
		 repeat(10) @(posedge clk);
		 TCK = 1'b1;
		 repeat(10) @(posedge clk);
		 rd_buff = {TDMISO,rd_buff[127:1]};
		 repeat(10) @(posedge clk);
		 TCK = 1'b0;
		 repeat(10) @(posedge clk);

		 $display("%t a Read JTAG data is %x at wr_reg",$time,rd_buff);
		 
		 // display read data
		 repeat(128-bit_cnt) begin
			rd_buff = {1'b0,rd_buff[127:1]};
		 end // repeat
		 $display("%t a Read JTAG data is %x at wr_reg",$time,rd_buff);

		 //      SM == 0x1
		 $display("%t JTAG SM is %x",$time,4'h1);

		 // update
		 TCK = 1'b1;
		 repeat(10) @(posedge clk);
		 TCK = 1'b0;
		 repeat(10) @(posedge clk);
		 //      SM == 0x5
		 $display("%t JTAG SM is %x",$time,4'h5);

		 // run
		 TMS = 1'b0;
		 repeat(10) @(posedge clk);
		 TCK = 1'b1;
		 repeat(10) @(posedge clk);
		 TCK = 1'b0;
		 repeat(10) @(posedge clk);
		 //      SM == 0xC
		 $display("%t JTAG SM is %x",$time,4'hC);
		 $display("%t End Write register\n",$time);
	  end
   endtask // wr_reg

   
   //----------------------------------------------
   task   rd_id_reg;
	  begin
		 @(posedge clk) #`DLY;
		 
		 go_rst2run;
		 // set IR to IDCODE
		 run2ir;
		 wr_reg(4,{{124{1'b0}},4'b1110});
		 // read DR
		 run2dr;
		 rd_reg(32);
		 
	  end // begin
   endtask // rd_id_reg

   //----------------------------------------------
   integer    rev_bnum;
   reg [127:0] wr_buff;

   initial begin
	  rev_bnum = 0;
	  wr_buff = {128{1'b0}};
   end // initial
   
   
   task   debug_exec;
	  input [127:0] wr_data;
	  input [31:0]  type;
	  
  	  begin
		 //$display("%t System HALTED in.",$time);
		 $display("%t wr_data is 0x%X",$time,wr_data);
		 @(posedge clk) #`DLY;

		 wr_buff = 128'd0;
		 
		 if(type == `DEBUG_SPEED_SHORT) begin
			$display("%t Short access not fully tested.",$time);

			// reverse bit order
			rev_bnum = 0;
			
			repeat(33) begin
			   wr_buff[32-rev_bnum] = wr_data[rev_bnum];
			   rev_bnum = rev_bnum + 1;
			end // repeat

			run2dr; // goto DR
			wr_reg(33,wr_buff);
			
		 end // if
		 else begin
			// do a long (67 bit) access
			wr_buff = {{96{1'b0}},wr_data[63:32]};
			
			if(type == `SYSTEM_SPEED)
			  wr_buff[33] = 1'b1;

			// wr_data[31:0] --> wr_buff[35:66]
			rev_bnum = 0;
			repeat(32) begin
			   wr_buff[66-rev_bnum] = wr_data[rev_bnum];
			   rev_bnum = rev_bnum + 1;
			end // repeat
			
			run2dr; // goto DR
			wr_reg(67,wr_buff);
		 end // else: !if(type == `DEBUG_SPEED_SHORT)
		 
		 rd_buff = {{64{1'b0}},rd_buff[31:0],32'd0};
		 $display( "%t rd data at debug_exe is 0x%x\n",$time,rd_buff);
		 
	  end // begin
   endtask // debug_exec
      

   task   debug_halted;
	  begin
		 $display("%t System HALTED in.",$time);
		 @(posedge clk) #`DLY;
		 
		 // disable interrupts
		 run2dr; // goto DR
		 wr_reg(38,{{90{1'b0}},38'h2000000004});

		 // Check current DEBUG state
		 run2dr; // goto DR
		 wr_reg(38,{{90{1'b0}},38'h0100000000});

		 if((rd_buff & 128'h010) == 128'h010) begin
			$display("%t Thumb State.",$time);
		 end
		 else begin
			$display("%t 32bit State.",$time);
		 end
		 

		 // select Scan Chain 1
		 run2ir; // goto IR
		 //     set IR to 0x02
		 wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_SCAN_N});
		 
		 run2dr; // goto DR
		 wr_reg(5,{{123{1'b0}},5'h01});


		 
		 // select Intest and write command sequence to get PC
		 run2ir; // goto IR
		 //     set IR to 0x0C
		 wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_INTEST});


		 
		 // send 32bit sequence
		 // STR r0, [r0]	- Save R0 before useq
		 debug_exec({{61{1'b0}},67'h000000000e5800000},`DEBUG_SPEED);
		 
		 // MOV r0, PC 	- Copy PC to R0
		 debug_exec({{61{1'b0}},67'h000000000e1a0000f},`DEBUG_SPEED);

		 // STR r0, [r0] - Save PC into R0
		 debug_exec({{61{1'b0}},67'h000000000e5800000},`DEBUG_SPEED);

		 // NOP		- Read out R0
		 debug_exec({{61{1'b0}},67'h000000000e1a00000},`DEBUG_SPEED);

		 $display("%t R0 is 0x%x",$time,rd_buff[63:32]);
		 
		 // NOP
		 debug_exec({{61{1'b0}},67'h000000000e1a00000},`DEBUG_SPEED);
		 
		 // NOP		- Read out PC
		 debug_exec({{61{1'b0}},67'h000000000e1a00000},`DEBUG_SPEED);
		 
		 // Correct for delay
		 $display("%t PC is 0x%x",$time, rd_buff[63:32]-32'h00000018);

		 rd_buff[31:0] = `JTAG_RESTART;
		 $display("%t ARM is Halted\n",$time);
		 
	  end // begin
   endtask // debug_halted

   task    cp_rd_instr;
	  input [3:0] cp_num;
	  input [3:0] reg_num;
	  input [2:0] opcode;
	  begin
		 $display("%t Read CP %d in.",$time,cp_num);
		 
		 // disable interrupts
		 run2dr; // goto DR
		 wr_reg(38,{{90{1'b0}},38'h2000000004});

		 // Check current DEBUG state
		 run2dr; // goto DR
		 wr_reg(38,{{90{1'b0}},38'h0100000000});


		 
		 // select Scan Chain 1
		 run2ir; // goto IR
		 //     set IR to 0x02
		 wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_SCAN_N});
		 
		 run2dr; // goto DR
		 wr_reg(5,{{123{1'b0}},5'h01});


 
		 // select Intest and write command sequence to get PC
		 run2ir; // goto IR
		 //     set IR to 0x0C
		 wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_INTEST});


		 
		 // send 32bit sequence
		 // mrc cpnum,0,r0,cpreg,cpreg,opcode - Read CPm Rn [ABC] to R0
		 debug_exec({{61{1'b0}},{47'h000000000ee1,reg_num,4'h0,cp_num,opcode,1'b1,reg_num}},`DEBUG_SPEED);

		 // NOP		- Read out R0
		 debug_exec({{61{1'b0}},67'h000000000e1a00000},`DEBUG_SPEED);

		 // NOP		- Read out R0
		 debug_exec({{61{1'b0}},67'h000000000e1a00000},`DEBUG_SPEED);

		 // NOP		- Read out R0
		 debug_exec({{61{1'b0}},67'h000000000e1a00000},`DEBUG_SPEED);

		 // NOP		- Read out R0
		 debug_exec({{61{1'b0}},67'h000000000e1a00000},`DEBUG_SPEED);

		 // STR r0, [r0] - Save CPm Rn [ABC] into R0
		 debug_exec({{61{1'b0}},67'h000000000e5800000},`DEBUG_SPEED);

		 // NOP		- Read out R0
		 debug_exec({{61{1'b0}},67'h000000000e1a00000},`DEBUG_SPEED);

		 $display("%t CP%dR%d-%d is 0x%x",$time,cp_num,reg_num,opcode,rd_buff[63:32]);

		 // NOP
		 debug_exec({{61{1'b0}},67'h000000000e1a00000},`DEBUG_SPEED);
		 
		 $display("%t CP%dR%d-%d is 0x%x",$time,cp_num,reg_num,opcode,rd_buff[63:32]);

		 // NOP		- Read out CPm Rn [ABC]
		 debug_exec({{61{1'b0}},67'h000000000e1a00000},`DEBUG_SPEED);

		 $display("%t CP%dR%d-%d is 0x%x",$time,cp_num,reg_num,opcode,rd_buff[63:32]);

		 rd_buff[31:0] = `JTAG_RESTART;
		 $display("%t CP registers are read\n",$time);
		 
	  end // begin
   endtask // cp_rd_instr
   

   //===============================================================
   
   task   halt_arm;
	  begin
		 $display("=================================================");
		 $display("%t Requesting HALT..",$time);
		 // start from run-test state
		 @(posedge clk) #`DLY;
		 
		 // select Scan Chain 2
		 //run2ir; // goto IR
		 //rd_reg(`JTAG_IR_LEN); // read IR for test
		 
		 run2ir; // goto IR
		 //     set IR to 0x02
		 wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_SCAN_N});
		 
		 run2dr; // goto DR
		 wr_reg(5,{{123{1'b0}},5'h02});
		 
		 // select Intest
		 run2ir; // goto IR
		 //     set IR to 0x0C
		 wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_INTEST});
		 
		 // set debug request bit
		 run2dr; // goto DR
		 wr_reg(38,{{90{1'b0}},38'h2000000002});
		 
		 //run2ir; // goto IR
		 //rd_reg(`JTAG_IR_LEN); // read IR for test
		 
		 run2ir; // goto IR
		 //     set IR to 0x0C
		 wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_RESTART});

		 $display("%t Wait success or fail...\n",$time);
		 
		 for(i=0;i<10;i=i+1) begin
			// select Intest
			run2ir; // goto IR
			//     set IR to 0x0C
			wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_INTEST});
			
			// read debug status
			run2dr; // goto DR
			wr_reg(38,{{90{1'b0}},38'h0100000000});
			
			$display("%t Check Read value...%d\n",$time,i);

			$display("%t Read value 0x%X\n",$time,rd_buff);
			
			if((rd_buff & 128'd9) != 128'd9) begin
			   run2dr; // goto DR
			   wr_reg(38,{{90{1'b0}},38'h2000000000});
			   
			   $display("%t Goto debug halt..\n",$time);
			   
			   debug_halted;
			   
			   $display ("%t HALT Success.",$time);
			   i = 12;
			end // if
			else begin
			   run2ir; // goto IR
			   //     set IR to 0x0C
			   wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_RESTART});
			end // else
			
		 end // for
		 
		 if(i < 12) begin
			run2dr; // goto DR
			wr_reg(38,{{90{1'b0}},38'h2000000000});
			
			run2ir; // goto IR
			//     set IR to 0x0C
			wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_RESTART});
			
			$display ("%t HALT Faild.",$time);
		 end // if
		 
	  end // task halt_arm
   endtask // halt_arm


   task rd_cp15c0b;
	  begin
		 $display("=================================================");
		 $display("%t Read CP15..",$time);
		 
		 run2ir; // goto IR
		 //     set IR to 0x02
		 wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_SCAN_N});
		 
		 run2dr; // goto DR
		 wr_reg(5,{{123{1'b0}},5'h0f});

		 // select Intest
		 run2ir; // goto IR
		 //     set IR to 0x0C
		 wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_INTEST});

		 // read cache information
		 // complete access
		 run2dr; // goto DR
		 wr_reg(48,{{113{1'b0}},48'h020100000000});
		 
		 repeat(10) @(posedge clk);
		 // write a read command
		 run2dr; // goto DR
		 wr_reg(48,{{113{1'b0}},48'h020000000000});
		 
		 if(rd_buff[32] == 1) begin
			$display("%t cp15c0b is 0x%X",$time,rd_buff[31:0]);
			if(rd_buff[31:0] != 32'h1d112112) begin
			   $display(" FAIL read CP15C0B");
			   $stop;
			end
		 end // if
		 else begin
			$display("%t cp15c0b read fail",$time);
		 end // else
		 
		 
		 // read mmu information
		 // complete access
		 run2dr; // goto DR
		 wr_reg(48,{{113{1'b0}},48'h040100000000});
		 
		 repeat(10) @(posedge clk);
		 // write a read command
		 run2dr; // goto DR
		 wr_reg(48,{{113{1'b0}},48'h040000000000});

		 if(rd_buff[32] == 1) begin
			$display("%t cp15c0c is 0x%X",$time,rd_buff[31:0]);
			if(rd_buff[31:0] != 32'h00000000) begin
			   $display(" FAIL read CP15C0C");
			   $stop;
			end
		 end // if
		 else begin
			$display("%t cp15c0c read fail",$time);
		 end // else
		 // 		 
	  end
   endtask // rd_cp15c0b
   


   task    read_cp_reg;
	  input [3:0] cp_num;
	  input [3:0] reg_num;
	  input [2:0] opcode;
	  begin
		 $display("=================================================");
		 $display("%t Read CP%d register %d %d..",$time,cp_num,reg_num,opcode);
		 // start from run-test state
		 @(posedge clk) #`DLY;

		 run2ir; // goto IR
		 //     set IR to 0x02
		 wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_SCAN_N});
		 
		 run2dr; // goto DR
		 wr_reg(5,{{123{1'b0}},5'h02});
		 
		 // select Intest
		 run2ir; // goto IR
		 //     set IR to 0x0C
		 wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_INTEST});
		 
		 // set debug request bit
		 run2dr; // goto DR
		 wr_reg(38,{{90{1'b0}},38'h2000000002});

		 run2ir; // goto IR
		 //     set IR to 0x0C
		 wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_RESTART});

		 $display("%t Wait Debug mode...\n",$time);
		 
		 for(i=0;i<10;i=i+1) begin
			// select Intest
			run2ir; // goto IR
			//     set IR to 0x0C
			wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_INTEST});
			
			// read debug status
			run2dr; // goto DR
			wr_reg(38,{{90{1'b0}},38'h0100000000});
			
			$display("%t Check Read value...%d\n",$time,i);

			$display("%t Read value 0x%X\n",$time,rd_buff);
			
			if((rd_buff & 128'd9) != 128'd9) begin
			   $display("%t Reading..\n",$time);

			   cp_rd_instr(cp_num, reg_num, opcode);
			   
			   $display ("%t Read Success.",$time);
			   i = 12;
			end // if
			else begin
			   run2ir; // goto IR
			   //     set IR to 0x0C
			   wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_RESTART});
			end // else
			
		 end // for

		 if(i < 12) begin
			run2dr; // goto DR
			wr_reg(38,{{90{1'b0}},38'h2000000000});
			
			run2ir; // goto IR
			//     set IR to 0x0C
			wr_reg(`JTAG_IR_LEN,{{124{1'b0}},`JTAG_RESTART});
			
			$display ("%t Read CP Faild.",$time);
		 end // if

	  end
   endtask // cp15_rd_instr
   
   
   
endmodule // jtag_md



