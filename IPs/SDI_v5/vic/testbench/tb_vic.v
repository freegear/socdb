/*****************************************************************
		         APB_vic testbench
*****************************************************************/
`timescale 1 ns/ 100ps
module tb_vic;

parameter CLK_HALFPERIOD=15;
parameter VICDELAY=180;
parameter APBDELAY=120;

reg         PCLK        ;     // APB system clock
reg         PRESETn     ;     // APB system reset
reg         PENABLE     ;     // Data valid strobe 
reg         PSEL        ;     // Module select signal
reg         PWRITE      ;     // Write/nRead signal
reg  [31:0] PADDR       ;     // Address (used bits only)
reg  [31:0] PWDATA      ;     // Read data
wire [31:0] PRDATA      ;     // Write data

reg  [31:0] READ_DATA;

reg  [31:0] INTERRUPT_SRC;
wire        nFIQ;
wire        nIRQ;
wire [7:0]  LEVEL_PM;
wire [7:0]  POLARITY_PM;
wire [7:0]  INTMSK_PM;

integer loop_count;
reg  [31:0] loop_mask;
reg  [31:0] loop_mask2;
reg  [31:0] inverted_loop_mask;
reg  [31:0] loop_vecaddr;
reg  [31:0] loop_vecaddr2;

`define ADDR_INTCON    32'h00000000	// INTCON(R/W)   @ 0x00
`define ADDR_INTPND    32'h00000004	// INTPND(R/W)   @ 0x04
`define ADDR_INTMOD    32'h00000008	// INTMOD(R/W)   @ 0x08
`define ADDR_INTMSK    32'h0000000C	// INTMSK(R/W)   @ 0x0C
`define ADDR_LEVEL     32'h00000010	// LEVEL(R/W)    @ 0x10
`define ADDR_I_PSLV0   32'h00000014	// I_PSLV0(R/W)  @ 0x14
`define ADDR_I_PSLV1   32'h00000018	// I_PSLV1(R/W)  @ 0x18
`define ADDR_I_PSLV2   32'h0000001C	// I_PSLV2(R/W)  @ 0x1C
`define ADDR_I_PSLV3   32'h00000020	// I_PSLV2(R/W)  @ 0x20
`define ADDR_I_PMST    32'h00000024	// I_PMST(R/W)   @ 0x24
`define ADDR_I_CSLV0   32'h00000028	// I_CSLV0(R)    @ 0x28
`define ADDR_I_CSLV1   32'h0000002C	// I_CSLV0(R)    @ 0x2C
`define ADDR_I_CSLV2   32'h00000030	// I_CSLV0(R)    @ 0x30
`define ADDR_I_CSLV3   32'h00000034	// I_CSLV0(R)    @ 0x34
`define ADDR_I_CMST    32'h00000038	// I_CMST(R)     @ 0x38
`define ADDR_I_ISPR    32'h0000003C	// I_ISPR(R)     @ 0x3C
`define ADDR_I_ISPC    32'h00000040	// I_ISPC(W)     @ 0x40
`define ADDR_F_PSLV0   32'h00000044	// F_PSLV0(R/W)  @ 0x44
`define ADDR_F_PSLV1   32'h00000048	// F_PSLV1(R/W)  @ 0x48
`define ADDR_F_PSLV2   32'h0000004C	// F_PSLV2(R/W)  @ 0x4C
`define ADDR_F_PSLV3   32'h00000050	// F_PSLV2(R/W)  @ 0x50
`define ADDR_F_PMST    32'h00000054	// F_PMST(R/W)   @ 0x54
`define ADDR_F_CSLV0   32'h00000058	// F_CSLV0(R)    @ 0x58
`define ADDR_F_CSLV1   32'h0000005C	// F_CSLV1(R)    @ 0x5C
`define ADDR_F_CSLV2   32'h00000060	// F_CSLV2(R)    @ 0x60
`define ADDR_F_CSLV3   32'h00000064	// F_CSLV3(R)    @ 0x64
`define ADDR_F_CMST    32'h00000068	// F_CMST(R)     @ 0x68
`define ADDR_F_ISPR    32'h0000006C	// F_ISPR(R)     @ 0x6C
`define ADDR_F_ISPC    32'h00000070	// F_ISPC(W)     @ 0x70
`define ADDR_POLARITY  32'h00000074	// POLARITY(R/W) @ 0x74
`define ADDR_I_VECADDR 32'h00000078	// I_VECADDR(R)  @ 0x78
`define ADDR_F_VECADDR 32'h0000007C	// F_VECADDR(R)  @ 0x7C

always #CLK_HALFPERIOD	PCLK = ~PCLK;

initial
begin
	
  PCLK 		= 0;     // APB system clock
  PRESETn 	= 0;     // APB system reset
  PENABLE 	= 0;     // Data valid strobe 
  PSEL   	= 0;     // Module select signal
  PWRITE  	= 0;     // Write/nRead signal
  PADDR  	= 0;     // Address (used bits only)
  PWDATA  	= 0;     // Read data

  INTERRUPT_SRC = 32'h00000000;

  #APBDELAY PRESETn	= 1;

$display("****************************************************");
$display("APB VIC simulation                                  ");
$display("****************************************************");

$display("*** Reset Value Check");
#APBDELAY	apb_read_check(`ADDR_INTCON, 32'h0000000B);
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_INTMOD, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_INTMSK, 32'hFFFFFFFF);
#APBDELAY	apb_read_check(`ADDR_LEVEL, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_PSLV0, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_I_PSLV1, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_I_PSLV2, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_I_PSLV3, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_I_PMST, 32'h00001FE4);
#APBDELAY	apb_read_check(`ADDR_I_CSLV0, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_I_CSLV1, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_I_CSLV2, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_I_CSLV3, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_I_CMST, 32'h00001FE4);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000000);

#APBDELAY	apb_read_check(`ADDR_F_PSLV0, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_F_PSLV1, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_F_PSLV2, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_F_PSLV3, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_F_PMST, 32'h00001FE4);
#APBDELAY	apb_read_check(`ADDR_F_CSLV0, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_F_CSLV1, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_F_CSLV2, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_F_CSLV3, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_F_CMST, 32'h00001FE4);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);

#APBDELAY	apb_read_check(`ADDR_POLARITY, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000000);
		check(nIRQ==1);
		check(nFIQ==1);

$display("*** Register Read/Write Test");
#APBDELAY	apb_write(`ADDR_INTCON, 32'hAAAAAAAA);
#APBDELAY	apb_read_check(`ADDR_INTCON, 32'h0000000A);
#APBDELAY	apb_write(`ADDR_INTCON, 32'h55555555);
#APBDELAY	apb_read_check(`ADDR_INTCON, 32'h00000005);
#APBDELAY	apb_write(`ADDR_INTCON, 32'h00000003);
#APBDELAY	apb_read_check(`ADDR_INTCON, 32'h00000003);

#APBDELAY	apb_write(`ADDR_INTPND, 32'hAAAAAAAA);
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'hAAAAAAAA);
#APBDELAY	apb_write(`ADDR_INTPND, 32'h55555555);
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'h55555555);
#APBDELAY	apb_write(`ADDR_INTPND, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'h00000000);

#APBDELAY	apb_write(`ADDR_INTCON, 32'h0000000B);

#APBDELAY	apb_write(`ADDR_INTMOD, 32'hAAAAAAAA);
#APBDELAY	apb_read_check(`ADDR_INTMOD, 32'hAAAAAAAA);
#APBDELAY	apb_write(`ADDR_INTMOD, 32'h55555555);
#APBDELAY	apb_read_check(`ADDR_INTMOD, 32'h55555555);
#APBDELAY	apb_write(`ADDR_INTMOD, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_INTMOD, 32'h00000000);

#APBDELAY	apb_write(`ADDR_INTMSK, 32'hAAAAAAAA);
#APBDELAY	apb_read_check(`ADDR_INTMSK, 32'hAAAAAAAA);
#APBDELAY	apb_write(`ADDR_INTMSK, 32'h55555555);
#APBDELAY	apb_read_check(`ADDR_INTMSK, 32'h55555555);
#APBDELAY	apb_write(`ADDR_INTMSK, 32'hFFFFFFFF);
#APBDELAY	apb_read_check(`ADDR_INTMSK, 32'hFFFFFFFF);

#APBDELAY	apb_write(`ADDR_LEVEL, 32'hAAAAAAAA);
#APBDELAY	apb_read_check(`ADDR_LEVEL, 32'hAAAAAAAA);
#APBDELAY	apb_write(`ADDR_LEVEL, 32'h55555555);
#APBDELAY	apb_read_check(`ADDR_LEVEL, 32'h55555555);
#APBDELAY	apb_write(`ADDR_LEVEL, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_LEVEL, 32'h00000000);

#APBDELAY	apb_read_check(`ADDR_I_PSLV0, 32'h00FAC688);
#APBDELAY	apb_write(`ADDR_I_PSLV0, 32'hAAAAAAAA);
#APBDELAY	apb_read_check(`ADDR_I_PSLV0, 32'h00AAAAAA);
#APBDELAY	apb_read_check(`ADDR_I_CSLV0, 32'h00AAAAAA);
#APBDELAY	apb_write(`ADDR_I_PSLV0, 32'h55555555);
#APBDELAY	apb_read_check(`ADDR_I_PSLV0, 32'h00555555);
#APBDELAY	apb_read_check(`ADDR_I_CSLV0, 32'h00555555);
#APBDELAY	apb_write(`ADDR_I_PSLV0, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_I_PSLV0, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_I_CSLV0, 32'h00FAC688);

#APBDELAY	apb_read_check(`ADDR_I_PSLV1, 32'h00FAC688);
#APBDELAY	apb_write(`ADDR_I_PSLV1, 32'hAAAAAAAA);
#APBDELAY	apb_read_check(`ADDR_I_PSLV1, 32'h00AAAAAA);
#APBDELAY	apb_read_check(`ADDR_I_CSLV1, 32'h00AAAAAA);
#APBDELAY	apb_write(`ADDR_I_PSLV1, 32'h55555555);
#APBDELAY	apb_read_check(`ADDR_I_PSLV1, 32'h00555555);
#APBDELAY	apb_read_check(`ADDR_I_CSLV1, 32'h00555555);
#APBDELAY	apb_write(`ADDR_I_PSLV1, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_I_PSLV1, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_I_CSLV1, 32'h00FAC688);

#APBDELAY	apb_read_check(`ADDR_I_PSLV2, 32'h00FAC688);
#APBDELAY	apb_write(`ADDR_I_PSLV2, 32'hAAAAAAAA);
#APBDELAY	apb_read_check(`ADDR_I_PSLV2, 32'h00AAAAAA);
#APBDELAY	apb_read_check(`ADDR_I_CSLV2, 32'h00AAAAAA);
#APBDELAY	apb_write(`ADDR_I_PSLV2, 32'h55555555);
#APBDELAY	apb_read_check(`ADDR_I_PSLV2, 32'h00555555);
#APBDELAY	apb_read_check(`ADDR_I_CSLV2, 32'h00555555);
#APBDELAY	apb_write(`ADDR_I_PSLV2, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_I_PSLV2, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_I_CSLV2, 32'h00FAC688);

#APBDELAY	apb_read_check(`ADDR_I_PSLV3, 32'h00FAC688);
#APBDELAY	apb_write(`ADDR_I_PSLV3, 32'hAAAAAAAA);
#APBDELAY	apb_read_check(`ADDR_I_PSLV3, 32'h00AAAAAA);
#APBDELAY	apb_read_check(`ADDR_I_CSLV3, 32'h00AAAAAA);
#APBDELAY	apb_write(`ADDR_I_PSLV3, 32'h55555555);
#APBDELAY	apb_read_check(`ADDR_I_PSLV3, 32'h00555555);
#APBDELAY	apb_read_check(`ADDR_I_CSLV3, 32'h00555555);
#APBDELAY	apb_write(`ADDR_I_PSLV3, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_I_PSLV3, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_I_CSLV3, 32'h00FAC688);

#APBDELAY	apb_write(`ADDR_I_PMST, 32'hAAAAAAAA);
#APBDELAY	apb_read_check(`ADDR_I_PMST, 32'h00000AAA);
#APBDELAY	apb_read_check(`ADDR_I_CMST, 32'h00000AAA);
#APBDELAY	apb_write(`ADDR_I_PMST, 32'h55555555);
#APBDELAY	apb_read_check(`ADDR_I_PMST, 32'h00001555);
#APBDELAY	apb_read_check(`ADDR_I_CMST, 32'h00001555);
#APBDELAY	apb_write(`ADDR_I_PMST, 32'h00001FE4);
#APBDELAY	apb_read_check(`ADDR_I_PMST, 32'h00001FE4);
#APBDELAY	apb_read_check(`ADDR_I_CMST, 32'h00001FE4);

#APBDELAY	apb_read_check(`ADDR_F_PSLV0, 32'h00FAC688);
#APBDELAY	apb_write(`ADDR_F_PSLV0, 32'hAAAAAAAA);
#APBDELAY	apb_read_check(`ADDR_F_PSLV0, 32'h00AAAAAA);
#APBDELAY	apb_read_check(`ADDR_F_CSLV0, 32'h00AAAAAA);
#APBDELAY	apb_write(`ADDR_F_PSLV0, 32'h55555555);
#APBDELAY	apb_read_check(`ADDR_F_PSLV0, 32'h00555555);
#APBDELAY	apb_read_check(`ADDR_F_CSLV0, 32'h00555555);
#APBDELAY	apb_write(`ADDR_F_PSLV0, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_F_PSLV0, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_F_CSLV0, 32'h00FAC688);

#APBDELAY	apb_read_check(`ADDR_F_PSLV1, 32'h00FAC688);
#APBDELAY	apb_write(`ADDR_F_PSLV1, 32'hAAAAAAAA);
#APBDELAY	apb_read_check(`ADDR_F_PSLV1, 32'h00AAAAAA);
#APBDELAY	apb_read_check(`ADDR_F_CSLV1, 32'h00AAAAAA);
#APBDELAY	apb_write(`ADDR_F_PSLV1, 32'h55555555);
#APBDELAY	apb_read_check(`ADDR_F_PSLV1, 32'h00555555);
#APBDELAY	apb_read_check(`ADDR_F_CSLV1, 32'h00555555);
#APBDELAY	apb_write(`ADDR_F_PSLV1, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_F_PSLV1, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_F_CSLV1, 32'h00FAC688);

#APBDELAY	apb_read_check(`ADDR_F_PSLV2, 32'h00FAC688);
#APBDELAY	apb_write(`ADDR_F_PSLV2, 32'hAAAAAAAA);
#APBDELAY	apb_read_check(`ADDR_F_PSLV2, 32'h00AAAAAA);
#APBDELAY	apb_read_check(`ADDR_F_CSLV2, 32'h00AAAAAA);
#APBDELAY	apb_write(`ADDR_F_PSLV2, 32'h55555555);
#APBDELAY	apb_read_check(`ADDR_F_PSLV2, 32'h00555555);
#APBDELAY	apb_read_check(`ADDR_F_CSLV2, 32'h00555555);
#APBDELAY	apb_write(`ADDR_F_PSLV2, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_F_PSLV2, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_F_CSLV2, 32'h00FAC688);

#APBDELAY	apb_read_check(`ADDR_F_PSLV3, 32'h00FAC688);
#APBDELAY	apb_write(`ADDR_F_PSLV3, 32'hAAAAAAAA);
#APBDELAY	apb_read_check(`ADDR_F_PSLV3, 32'h00AAAAAA);
#APBDELAY	apb_read_check(`ADDR_F_CSLV3, 32'h00AAAAAA);
#APBDELAY	apb_write(`ADDR_F_PSLV3, 32'h55555555);
#APBDELAY	apb_read_check(`ADDR_F_PSLV3, 32'h00555555);
#APBDELAY	apb_read_check(`ADDR_F_CSLV3, 32'h00555555);
#APBDELAY	apb_write(`ADDR_F_PSLV3, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_F_PSLV3, 32'h00FAC688);
#APBDELAY	apb_read_check(`ADDR_F_CSLV3, 32'h00FAC688);

#APBDELAY	apb_write(`ADDR_F_PMST, 32'hAAAAAAAA);
#APBDELAY	apb_read_check(`ADDR_F_PMST, 32'h00000AAA);
#APBDELAY	apb_read_check(`ADDR_F_CMST, 32'h00000AAA);
#APBDELAY	apb_write(`ADDR_F_PMST, 32'h55555555);
#APBDELAY	apb_read_check(`ADDR_F_PMST, 32'h00001555);
#APBDELAY	apb_read_check(`ADDR_F_CMST, 32'h00001555);
#APBDELAY	apb_write(`ADDR_F_PMST, 32'h00001FE4);
#APBDELAY	apb_read_check(`ADDR_F_PMST, 32'h00001FE4);
#APBDELAY	apb_read_check(`ADDR_F_CMST, 32'h00001FE4);

#APBDELAY	apb_write(`ADDR_POLARITY, 32'hAAAAAAAA);
#APBDELAY	apb_read_check(`ADDR_POLARITY, 32'hAAAAAAAA);
#APBDELAY	apb_write(`ADDR_POLARITY, 32'h55555555);
#APBDELAY	apb_read_check(`ADDR_POLARITY, 32'h55555555);
#APBDELAY	apb_write(`ADDR_POLARITY, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_POLARITY, 32'h00000000);

$display("*** Each Interrupt Line Test");
// enable IRQ&FIQ
#APBDELAY	apb_write(`ADDR_INTCON, 32'h00000000);

loop_count = 0;
loop_mask = 32'h00000001;
loop_vecaddr = 32'h00000000;
repeat (32)
begin
inverted_loop_mask = ~loop_mask;
$display("    IRQ%d", loop_count);
// IRQ0
#APBDELAY	apb_write(`ADDR_INTMSK, inverted_loop_mask);

// active high edge trigger mode
INTERRUPT_SRC[loop_count] = 1'b1;

#VICDELAY	check(nIRQ==0);
			check(nFIQ==1);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, loop_mask);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, loop_vecaddr);
#APBDELAY	apb_read_check(`ADDR_INTPND, loop_mask);
#APBDELAY	apb_read(`ADDR_I_ISPR);
#APBDELAY	apb_write(`ADDR_I_ISPC, READ_DATA);
#VICDELAY	check(nIRQ==1);
			check(nFIQ==1);
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, 32'h00000000);

// active low edge trigger mode
#APBDELAY	apb_write(`ADDR_POLARITY, loop_mask);
#APBDELAY	INTERRUPT_SRC[loop_count] = 1'b0;

#VICDELAY	check(nIRQ==0);
			check(nFIQ==1);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, loop_mask);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, loop_vecaddr);
#APBDELAY	apb_read_check(`ADDR_INTPND, loop_mask);
#APBDELAY	apb_read(`ADDR_I_ISPR);
#APBDELAY	apb_write(`ADDR_I_ISPC, READ_DATA);
#VICDELAY	check(nIRQ==1);
			check(nFIQ==1);
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, 32'h00000000);

// active low level trigger mode
#APBDELAY	apb_write(`ADDR_LEVEL, loop_mask);

#VICDELAY	check(nIRQ==0);
			check(nFIQ==1);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, loop_mask);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, loop_vecaddr);
#APBDELAY	apb_read_check(`ADDR_INTPND, loop_mask);
INTERRUPT_SRC[loop_count] = 1'b1;
#VICDELAY	;	// more delay for I_ISPR update
#VICDELAY	check(nIRQ==1);
			check(nFIQ==1);
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, 32'h00000000);

// active high level trigger mode
#APBDELAY	apb_write(`ADDR_POLARITY, 32'h00000000);

#VICDELAY	check(nIRQ==0);
			check(nFIQ==1);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, loop_mask);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, loop_vecaddr);
#APBDELAY	apb_read_check(`ADDR_INTPND, loop_mask);
INTERRUPT_SRC[loop_count] = 1'b0;
#VICDELAY	;	// more delay for I_ISPR update
#VICDELAY	check(nIRQ==1);
			check(nFIQ==1);
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, 32'h00000000);
loop_count   = loop_count + 1;
loop_mask    = loop_mask << 1;
loop_vecaddr = loop_vecaddr + 32'h00000004;
end

// FIQ Test
#APBDELAY	apb_write(`ADDR_INTMOD, 32'hFFFFFFFF);

loop_count = 0;
loop_mask = 32'h00000001;
loop_vecaddr = 32'h00000000;
repeat (32)
begin
inverted_loop_mask = ~loop_mask;
$display("    FIQ%d", loop_count);
// IRQ0
#APBDELAY	apb_write(`ADDR_INTMSK, inverted_loop_mask);

// active high edge trigger mode
INTERRUPT_SRC[loop_count] = 1'b1;

#VICDELAY	check(nIRQ==1);
			check(nFIQ==0);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, loop_mask);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, loop_vecaddr);
#APBDELAY	apb_read_check(`ADDR_INTPND, loop_mask);
#APBDELAY	apb_read(`ADDR_F_ISPR);
#APBDELAY	apb_write(`ADDR_F_ISPC, READ_DATA);
#VICDELAY	check(nIRQ==1);
			check(nFIQ==1);
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000000);

// active low edge trigger mode
#APBDELAY	apb_write(`ADDR_POLARITY, loop_mask);
#APBDELAY	INTERRUPT_SRC[loop_count] = 1'b0;

#VICDELAY	check(nIRQ==1);
			check(nFIQ==0);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, loop_mask);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, loop_vecaddr);
#APBDELAY	apb_read_check(`ADDR_INTPND, loop_mask);
#APBDELAY	apb_read(`ADDR_F_ISPR);
#APBDELAY	apb_write(`ADDR_F_ISPC, READ_DATA);
#VICDELAY	check(nIRQ==1);
			check(nFIQ==1);
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000000);

// active low level trigger mode
#APBDELAY	apb_write(`ADDR_LEVEL, loop_mask);

#VICDELAY	check(nIRQ==1);
			check(nFIQ==0);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, loop_mask);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, loop_vecaddr);
#APBDELAY	apb_read_check(`ADDR_INTPND, loop_mask);
INTERRUPT_SRC[loop_count] = 1'b1;
#VICDELAY	;	// more delay for I_ISPR update
#VICDELAY	check(nIRQ==1);
			check(nFIQ==1);
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000000);

// active high level trigger mode
#APBDELAY	apb_write(`ADDR_POLARITY, 32'h00000000);

#VICDELAY	check(nIRQ==1);
			check(nFIQ==0);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, loop_mask);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, loop_vecaddr);
#APBDELAY	apb_read_check(`ADDR_INTPND, loop_mask);
INTERRUPT_SRC[loop_count] = 1'b0;
#VICDELAY	;	// more delay for I_ISPR update
#VICDELAY	check(nIRQ==1);
			check(nFIQ==1);
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000000);
loop_count   = loop_count + 1;
loop_mask    = loop_mask << 1;
loop_vecaddr = loop_vecaddr + 32'h00000004;
end

$display("*** Multi Interrupt Test");
#APBDELAY	apb_write(`ADDR_INTMOD, 32'h00000000);
#APBDELAY	apb_write(`ADDR_LEVEL, 32'h00000000);
#APBDELAY	apb_write(`ADDR_POLARITY, 32'h00000000);
#APBDELAY	apb_write(`ADDR_POLARITY, 32'h00000000);
#APBDELAY	apb_write(`ADDR_INTMSK, 32'h00000000);
INTERRUPT_SRC[31:0] = 32'hFFFFFFFF;	// all interrupt triggering

$display("    IRQ");
loop_count = 0;
loop_mask = 32'h00000001;
loop_vecaddr = 32'h00000000;
repeat (32)
begin
#VICDELAY	check(nIRQ==0);
			check(nFIQ==1);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, loop_mask);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, loop_vecaddr);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000000);
#APBDELAY	apb_read(`ADDR_I_ISPR);
#APBDELAY	apb_write(`ADDR_I_ISPC, READ_DATA);

loop_count   = loop_count + 1;
loop_mask    = loop_mask << 1;
loop_vecaddr = loop_vecaddr + 32'h00000004;
end

$display("    FIQ");
INTERRUPT_SRC[31:0] = 32'h00000000;
#APBDELAY	apb_write(`ADDR_INTMOD, 32'hFFFFFFFF);	// FIQ
INTERRUPT_SRC[31:0] = 32'hFFFFFFFF;	// all interrupt triggering
loop_mask = 32'h00000001;
loop_vecaddr = 32'h00000000;
repeat (32)
begin
#VICDELAY	check(nFIQ==0);
			check(nIRQ==1);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, loop_mask);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, loop_vecaddr);
#APBDELAY	apb_read(`ADDR_F_ISPR);
#APBDELAY	apb_write(`ADDR_F_ISPC, READ_DATA);

loop_mask    = loop_mask << 1;
loop_vecaddr = loop_vecaddr + 32'h00000004;
end

$display("    IRQ&FIQ");
INTERRUPT_SRC[31:0] = 32'h00000000;
#APBDELAY	apb_write(`ADDR_INTMOD, 32'hAAAAAAAA);	// even IRQ, odd FIQ
INTERRUPT_SRC[31:0] = 32'hFFFFFFFF;	// all interrupt triggering
loop_mask = 32'h00000001;
loop_mask2 = 32'h00000002;
loop_vecaddr = 32'h00000000;
loop_vecaddr2 = 32'h00000004;
repeat (16)
begin
#VICDELAY	check(nFIQ==0);
			check(nIRQ==0);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, loop_mask);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, loop_mask2);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, loop_vecaddr);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, loop_vecaddr2);
#APBDELAY	apb_read(`ADDR_I_ISPR);
#APBDELAY	apb_write(`ADDR_I_ISPC, READ_DATA);
#APBDELAY	apb_read(`ADDR_F_ISPR);
#APBDELAY	apb_write(`ADDR_F_ISPC, READ_DATA);

loop_mask    = loop_mask << 2;
loop_mask2    = loop_mask2 << 2;
loop_vecaddr = loop_vecaddr + 32'h00000008;
loop_vecaddr2 = loop_vecaddr2 + 32'h00000008;
end

$display("*** Interrupt Mask Test");
$display("    even IRQ");
INTERRUPT_SRC[31:0] = 32'h00000000;
#APBDELAY	apb_write(`ADDR_INTMOD, 32'h00000000);	// IRQ mode
#APBDELAY	apb_write(`ADDR_INTMSK, 32'hAAAAAAAA);	// masking odd
INTERRUPT_SRC[31:0] = 32'hFFFFFFFF;	// all interrupt triggering
loop_mask = 32'h00000001;
loop_vecaddr = 32'h00000000;
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'hFFFFFFFF);
repeat (16)
begin
#VICDELAY	check(nFIQ==1);
			check(nIRQ==0);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, loop_mask);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, loop_vecaddr);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000000);
#APBDELAY	apb_read(`ADDR_I_ISPR);
#APBDELAY	apb_write(`ADDR_I_ISPC, READ_DATA);

loop_mask    = loop_mask << 2;
loop_vecaddr = loop_vecaddr + 32'h00000008;
end

$display("    odd IRQ");
INTERRUPT_SRC[31:0] = 32'h00000000;
#APBDELAY	apb_write(`ADDR_INTMOD, 32'h00000000);	// IRQ mode
#APBDELAY	apb_write(`ADDR_INTMSK, 32'h55555555);	// masking even
INTERRUPT_SRC[31:0] = 32'hFFFFFFFF;	// all interrupt triggering
loop_mask = 32'h00000002;
loop_vecaddr = 32'h00000004;
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'hFFFFFFFF);
repeat (16)
begin
#VICDELAY	check(nFIQ==1);
			check(nIRQ==0);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, loop_mask);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, loop_vecaddr);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000000);
#APBDELAY	apb_read(`ADDR_I_ISPR);
#APBDELAY	apb_write(`ADDR_I_ISPC, READ_DATA);

loop_mask    = loop_mask << 2;
loop_vecaddr = loop_vecaddr + 32'h00000008;
end

$display("    lower16");
INTERRUPT_SRC[31:0] = 32'h00000000;
#APBDELAY	apb_write(`ADDR_INTMOD, 32'h00000000);	// IRQ mode
#APBDELAY	apb_write(`ADDR_INTMSK, 32'hFFFF0000);	// masking higher 16bit
INTERRUPT_SRC[31:0] = 32'hFFFFFFFF;	// all interrupt triggering
loop_mask = 32'h00000001;
loop_vecaddr = 32'h00000000;
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'hFFFFFFFF);
repeat (16)
begin
#VICDELAY	check(nFIQ==1);
			check(nIRQ==0);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, loop_mask);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, loop_vecaddr);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000000);
#APBDELAY	apb_read(`ADDR_I_ISPR);
#APBDELAY	apb_write(`ADDR_I_ISPC, READ_DATA);

loop_mask    = loop_mask << 1;
loop_vecaddr = loop_vecaddr + 32'h00000004;
end

$display("    higher16");
INTERRUPT_SRC[31:0] = 32'h00000000;
#APBDELAY	apb_write(`ADDR_INTMOD, 32'h00000000);	// IRQ mode
#APBDELAY	apb_write(`ADDR_INTMSK, 32'h0000FFFF);	// masking lower 16bit
INTERRUPT_SRC[31:0] = 32'hFFFFFFFF;	// all interrupt triggering
loop_mask = 32'h00010000;
loop_vecaddr = 32'h00000040;
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'hFFFFFFFF);
repeat (16)
begin
#VICDELAY	check(nFIQ==1);
			check(nIRQ==0);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, loop_mask);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, loop_vecaddr);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000000);
#APBDELAY	apb_read(`ADDR_I_ISPR);
#APBDELAY	apb_write(`ADDR_I_ISPC, READ_DATA);

loop_mask    = loop_mask << 1;
loop_vecaddr = loop_vecaddr + 32'h00000004;
end

$display("    mask during interrupt handler");
INTERRUPT_SRC[31:0] = 32'h00000000;
#APBDELAY	apb_write(`ADDR_INTMOD, 32'h00000000);	// IRQ mode
#APBDELAY	apb_write(`ADDR_INTMSK, 32'h00000000);	// unmask
INTERRUPT_SRC[31:0] = 32'hFFFFFFFF;	// all interrupt triggering
loop_mask = 32'h00000001;
loop_mask2 = 32'h00000001;
loop_vecaddr = 32'h00000000;
repeat (32)
begin
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'hFFFFFFFF);
#VICDELAY	check(nFIQ==1);
			check(nIRQ==0);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, loop_mask);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, loop_vecaddr);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000000);
#APBDELAY	apb_write(`ADDR_INTMSK, loop_mask2);	// masking lower bits

loop_mask    = loop_mask << 1;
loop_mask2    = {loop_mask2[30:0], loop_mask2[0]};
loop_vecaddr = loop_vecaddr + 32'h00000004;
end

#APBDELAY	apb_write(`ADDR_I_ISPC, 32'hFFFFFFFF);	// clearing all pending interrupts
#VICDELAY	apb_read_check(`ADDR_INTPND, 32'h00000000);

$display("*** INTCON(nENBIRQ & nENBFIQ & GIE) Test");
$display("    GIE");
INTERRUPT_SRC[31:0] = 32'h00000000;
#APBDELAY	apb_write(`ADDR_INTMOD, 32'h00000000);	// IRQ mode
#APBDELAY	apb_write(`ADDR_INTMSK, 32'h00000000);	// unmask all interrupt
INTERRUPT_SRC[31:0] = 32'hFFFFFFFF;	// all interrupt triggering
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'hFFFFFFFF);
#VICDELAY	check(nFIQ==1);
			check(nIRQ==0);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000001);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000000);
#APBDELAY	apb_write(`ADDR_INTCON, 32'h00000008);	// set GIE 1
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000000);

$display("    nENBIRQ&nENBFIQ");
INTERRUPT_SRC[31:0] = 32'h00000000;
#APBDELAY	apb_write(`ADDR_INTMOD, 32'hAAAAAAAA);	// even IRQ, odd FIQ
#APBDELAY	apb_write(`ADDR_INTCON, 32'h00000000);	// set GIE,nENBIRQ,nENBFIQ to zero
INTERRUPT_SRC[31:0] = 32'hFFFFFFFF;	// all interrupt triggering
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'hFFFFFFFF);
#VICDELAY	check(nFIQ==0);
			check(nIRQ==0);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000001);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000002);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000004);
#APBDELAY	apb_write(`ADDR_INTCON, 32'h00000002);	// set nENBIRQ 1
#VICDELAY	check(nFIQ==0);
			check(nIRQ==1);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000001);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000002);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000004);
#APBDELAY	apb_write(`ADDR_INTCON, 32'h00000001);	// set nENBFIQ 1
#VICDELAY	check(nFIQ==1);
			check(nIRQ==0);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000001);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000002);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000004);
#APBDELAY	apb_write(`ADDR_INTCON, 32'h00000003);	// set nENBIRQ&nENBFIQ 1
#VICDELAY	check(nFIQ==1);
			check(nIRQ==1);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000001);
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000002);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000004);
#APBDELAY	apb_write(`ADDR_INTCON, 32'h00000000);	// enable interrupt controller

#APBDELAY	apb_write(`ADDR_I_ISPC, 32'hFFFFFFFF);	// clear INTPND for IRQ
#APBDELAY	apb_write(`ADDR_F_ISPC, 32'hFFFFFFFF);	// clear INTPND for FIQ

$display("*** Round robin test");
INTERRUPT_SRC[31:0] = 32'h00000000;
#APBDELAY	apb_write(`ADDR_INTMOD, 32'h00000000);	// IRQ mode
#APBDELAY	apb_write(`ADDR_INTMSK, 32'h00000000);	// unmask all interrupt
#APBDELAY	apb_write(`ADDR_I_PMST, 32'h00001EE4);	// slave0 round robin
INTERRUPT_SRC[31:0] = 32'h00000062;	// 1,5,6 interrupt triggering
#VICDELAY	check(nFIQ==1);
			check(nIRQ==0);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000002);	// interrupt 1
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, 32'h00000004);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000000);
#APBDELAY	apb_read(`ADDR_I_ISPR);
#APBDELAY	apb_write(`ADDR_I_ISPC, READ_DATA);			// interrupt 1 serviced
#VICDELAY	check(nFIQ==1);
			check(nIRQ==0);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000020);	// interrupt 5
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, 32'h00000014);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_CSLV0, 32'h00447D63);
#APBDELAY	apb_read(`ADDR_I_ISPR);
#APBDELAY	apb_write(`ADDR_I_ISPC, READ_DATA);			// interrupt 5 serviced
#VICDELAY	check(nFIQ==1);
			check(nIRQ==0);
#APBDELAY	apb_read_check(`ADDR_I_ISPR, 32'h00000040);	// interrupt 6
#APBDELAY	apb_read_check(`ADDR_F_ISPR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_VECADDR, 32'h00000018);
#APBDELAY	apb_read_check(`ADDR_F_VECADDR, 32'h00000000);
#APBDELAY	apb_read_check(`ADDR_I_CSLV0, 32'h0023EB1A);
#APBDELAY	apb_read(`ADDR_I_ISPR);
#APBDELAY	apb_write(`ADDR_I_ISPC, READ_DATA);			// interrupt 6 serviced
#VICDELAY	check(nFIQ==1);
			check(nIRQ==1);
#APBDELAY	apb_read_check(`ADDR_INTPND, 32'h000000);
#APBDELAY	apb_read_check(`ADDR_I_CSLV0, 32'h0023EB1A);

$display("*** End of Simulation");
$finish;

end

task check; // read
		input true;
		begin
			if(!true)
			begin
				$display($time, " Check Failed");
				$stop;
			end
		end
endtask

// TASK for write and read 
task apb_write; // write
	input [31:0] reg_addr;
	input [31:0] reg_write;
		begin
			@(negedge PCLK);
			PENABLE = 1'b0;
			@(posedge PCLK);
			PSEL = 1'b1;
			PWRITE = 1'b1;
			PADDR = reg_addr;
			PWDATA = reg_write;
			@(posedge PCLK)
				PENABLE = 1'b1;
			@(posedge PCLK)
				$display($time, " address [%h]      write data [%h]", reg_addr, reg_write);
			PENABLE = 1'b0;
			PSEL    = 1'b0;
			PWDATA  = 32'dz;
		end
endtask

task apb_read; // read
		input [31:0] reg_addr;
		begin
			@(negedge PCLK);
			PENABLE = 1'b0;
			@(posedge PCLK);
			PSEL = 1'b1;
			PWRITE = 1'b0;
			PADDR = reg_addr;
			@(posedge PCLK)
				PENABLE = 1'b1;
			@(posedge PCLK)
				READ_DATA = PRDATA;
			$display($time, " address [%h]      read  data [%h]", reg_addr, READ_DATA);
			PENABLE = 1'b0;
			PSEL = 1'b0;
		end
endtask

task apb_read_check; // read
		input [31:0] reg_addr;
		input [31:0] reg_data;
		begin
			@(negedge PCLK);
			PENABLE = 1'b0;
			@(posedge PCLK);
			PSEL = 1'b1;
			PWRITE = 1'b0;
			PADDR = reg_addr;
			@(posedge PCLK)
				PENABLE = 1'b1;
			@(posedge PCLK)
				READ_DATA = PRDATA;
			$display($time, " address [%h]      read  data [%h]", reg_addr, READ_DATA);
			if(READ_DATA != reg_data)
			begin
				$display($time, " Read Error : Read %h when %h expected ", READ_DATA, reg_data);
				$stop;
			end
			PENABLE = 1'b0;
			PSEL = 1'b0;
		end
endtask

APB_vic APB_vic_0
(
//APB
	.PCLK(PCLK)         ,
	.PRESETn(PRESETn)   ,
	.PENABLE(PENABLE)   ,
	.PSEL(PSEL)         ,
	.PWRITE(PWRITE)     ,
	.PADDR(PADDR[6:2]) ,
	.PWDATA(PWDATA)     ,
	.PRDATA(PRDATA)     ,

// Interrupt Input
	.INTERRUPT_SRC(INTERRUPT_SRC),
// Interrupt Output to ARM7TDMI
	.nFIQ(nFIQ),
	.nIRQ(nIRQ),

// Power Management Unit Interface
	.LEVEL_PM(LEVEL_PM),
	.POLARITY_PM(POLARITY_PM),
	.INTMSK_PM(INTMSK_PM)
);

endmodule

