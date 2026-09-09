/*`timescale 1ns/10ps

`include "../../STI/SimDefine/SimDuty_define.v"
`include "../../STI/SimDefine/Command_define.v"

module test;

//---- signal definition & top module map ------------------------------------------
`include "../../STI/TopDefine/toptosimmap.v"

//---- task process  ------------------------------------------
`include "../../STI/TaskDefine/task.v"
`include "../../STI/TaskDefine/45_mem_write"
`include "../../STI/TaskDefine/46_mem_write"

initial begin
//---- stimulus process  ------------------------------------------
`include "../../STI/PatnDefine/short_dot_test.pat"

//---- stimulus end  ------------------------------------------
//`include "../../STI/SimDefine/finish.v"
`include "../../STI/SimDefine/stop.v"

//---- Sdf include  ------------------------------------------
//`include "../../STI/SdfDefine/sdf.v"
`include "../../STI/SdfDefine/sdf_m.v"

//---- result process  ------------------------------------------
`include "../../STI/DumpDefine/dump.v"

endmodule
*/

`timescale 1ns/10ps
`define	onestep	10
`include "../../STI/SimDefine/Command_define.v"

module test;

	reg		RSTB	;	// 
	reg		PS	;	// H(P)/L(S)
	reg		CSB	;	// H(disable)/L(chip select)
	reg		C80	;	// H(68)/L(80)
	reg		A0	;	// 68(H(disable)/L(enable))/80(H(disable)/L(read))
	reg		WRB_RW	;	// 68(H(Write)/L(Read))/80(H(disable)/L(write))
	reg		RDB_E	;	// H(Parameter/data)/L(command)
	reg		d_en	;	// H(datain)/L(dataout)
	reg	[15:0]	datain	;	// d[15:8]: in 16 bit data write upper side
					// d[7:0] : always use

	reg	[7:0]	instruction	;	// instruction address
	reg		p16En		;	// parallel 16bit data interface enable(1:enable)

	integer		i	;

	tri	[15:0]	i_Dio	;	//

assign i_Dio = PS ? (~d_en ? datain : 16'hZZZZ) : (~d_en ? {14'hZZZZ,datain[1:0]} : 16'hZZZZ)  ;

//---- top process  ------------------------------------------
	wire [95:0] OUTR ;
	wire [95:0] OUTG ;
	wire [95:0] OUTB ;
	wire [95:0] OUT_SCAN ;
	wire [49:0] DOUT_ICON ;
	wire [3:0]  SOUT_ICON ;

hapo500 dut (
//dummy pad
	.C1P(1'b0),
	.C1N(1'b0),
	.VPREB(1'b0),
	.VPREG(1'b0),
	.VPRER(1'b0),
	.OSCA1(1'b0),
	.OSCA2(1'b0),
	.IREF(1'b0),

//test pad
	.IC_TEST(1'b0),
//real pad
	.RSTB(RSTB),
	.PS(PS),
	.C80(C80),
	.CSB(CSB),
	.A0(A0),
	.WRB_RW(WRB_RW),
	.RDB_E(RDB_E),
	.DIO(i_Dio),

	.OUTR(OUTR),
	.OUTG(OUTG),
	.OUTB(OUTB),
	.OUT_SCAN(OUT_SCAN),

	.DOUT_ICON(DOUT_ICON),
	.SOUT_ICON(SOUT_ICON)
	);

`include "../../STI/TaskDefine/task.v"
`include "../../STI/TaskDefine/45_mem_write"
`include "../../STI/TaskDefine/46_mem_write"
`include "../../STI/PatnDefine/short_dot_test.pat"

