// 2004.02.23
// Add BistFail signal to see if BIST be finished.
// Copied from T_BIST1.v by /user/sjseo/scr/mcp on 2004.02.22 
// FILE    : SynTest Verilog driver file
// NAME    : T_BIST.v
// DATE    : Sun Jul  1 11:03:45 2001

`timescale 1ns / 10ps

`define T 1000
`define SDF_FILE "/prj6/sm1806/FE/SDF/POST/epsc_1100_post.sdf"
//`define TIME_SET 2000000 // 2ms
//`define TIME_SET 1064000000 // 1064ms
`define TIME_SET 1500000000// 15ms
`define VCD_FILE "BIST.vcd"

/*
`ifdef FAST
	`define VCD_FILE "wave/BIST_fast.vcd"
//`else
	`define VCD_FILE "wave/BIST_slow.vcd"
`endif
*/

	

module BIST_RC8051;



//-------------------------------------------------------
//-- Declare wires                                     --
//-------------------------------------------------------

reg            clk;
reg            rst_p;
reg            int0_i, int1_i;
reg            all_t0_i, all_t1_i;
reg            all_rxd_i;
reg [7:0]      p1_i;

// Output signal define
wire [7:0]     p1_o;
wire [7:0]     p1_en;
wire           all_txd_o;

// memory interfac
   //sync rom
wire           clkb;
wire  [15:0]   rom_adr_o;
reg   [7:0]    rom_data_i;
  //external data
wire  [15:0]   addr_xdat;
wire  [7:0]    out_xdat;
reg   [7:0]    in_xdat_a;
wire           en_xdat;
wire           wr_xdat_d1;
wire           rd_xdat;

// Bist test
reg            BistMode;

wire           BistFail;
wire           Finish;
wire           ErrMap;




//-------------------------------------------------------
//-- Call module                                       --
//-------------------------------------------------------
rc8051RtlTop BIST_top( 
.BistMode(BistMode), 
.BistFail(BistFail), 
.Finish(Finish),
.ErrMap(ErrMap),
.int0_i(int0_i),
.int1_i(int1_i),
.all_t0_i(all_t0_i),
.all_t1_i(all_t1_i),
.all_rxd_i(all_rxd_i),
.p1_i(p1_i),
.p1_o(p1_o),
.p1_en(p1_en),
.all_txd_o(all_txd_o),
.clkb(clkb),
.clk(clk),
.rom_adr_o(rom_adr_o),
.rom_data_i(rom_data_i),
.addr_xdat(addr_xdat),
.out_xdat(out_xdat),
.in_xdat_a(in_xdat_a),
.en_xdat(en_xdat),
.wr_xdat_d1(wr_xdat_d1),
.rd_xdat(rd_xdat)
);






initial begin
 BistMode = 0;
 clk = 0;
 rst_p = 0;
 int0_i = 0;
 int1_i = 0;
 all_t0_i = 0;
 all_t1_i = 0;
 all_rxd_i = 0;
 p1_i = 0;
 rom_data_i = 0;
 in_xdat_a = 0;


   
end
//-------------------------------------------------------
//-- Clock triggers                                    --
//-------------------------------------------------------

 always #(`T/20.0) clk = ~clk;

//-------------------------------------------------------
//-- Main routine                                      --
//-------------------------------------------------------
//initial $sdf_annotate( `SDF_FILE, BIST_top);

initial begin
//        #(`T*10.23) hrst_n = 1'b1;
//        #(`T*20.12) asic_test = 1'b1;
//        #(`T*50.12) bistmode = 1'b1;
        #5023 rst_p = 1'b1;
//        #130 asic_test = 1'b1;
        #5100 BistMode = 1'b1;
		$display ("BIST Simulation Started.");
end
// ---------------------------------------------
//	BIST Check
// ---------------------------------------------

// always #(`T*1000) $display ("Current Time %t Bist Fail : %d", $time, BistFail);

always @(posedge Finish) #10 $display ("%d : BIST Simulation Finished", $time);

// ---------------------------------------------
//	CASE : BIST Succeed
// ---------------------------------------------
always @(Finish)
	if (Finish == 1'b1) begin
		#100
		$display(" --------------------------------------------- ");
		$display ("%d : BIST Simulation Succeed", $time);
		$display(" --------------------------------------------- ");
		#(`T*20) $finish;
	end
// ---------------------------------------------
//	CASE : BIST Fail
// ---------------------------------------------
always @(BistFail)
	if (BistFail == 1'b1) begin
		#100 
		$display(" --------------------------------------------- ");
		$display ("%d : BIST Failed", $time);
		$display(" --------------------------------------------- ");
		#100 $finish;
	end
/*		
assign a_1 = epsc_blk.bridge_blk.cos_blk.p0size_ram.pm_dpram2048x16.Finish;
always @(a_1)
        if ( a_1 == 1'b1) begin
                #100 
                $display(" --------------------------------------------- ");
                $display ("%d :pm_dpram2048x16 O.K!! ", $time);
                $display(" --------------------------------------------- ");
       end
*/





// ---------------------------------------------
//  Dump VCD File
// ---------------------------------------------

initial	
begin
	#`TIME_SET
	$display(" --------------------------------------------- ");
	$display ("%d : Simulation finished by TIME_SET", $time);
	$display(" --------------------------------------------- ");
	$finish; // 2 ms
end

//`include "dump.v"
// `ifdef DUMP
/*
initial begin
        $dumpfile(`VCD_FILE);
        $dumpvars; 
end
*/
     // $dumpvars(1, U1_SMC_37SD_TOP);
       // $dumpvars; // (1, epsc_top);
//       $dumpvars(0, BIST_top);
//end


// `endif

initial
begin
 $shm_open("./rc8051.shm");
 $shm_probe("AS");
end

endmodule

