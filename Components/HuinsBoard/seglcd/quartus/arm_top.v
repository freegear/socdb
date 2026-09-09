// Copyright (C) 1991-2004 Altera Corporation
// Any  megafunction  design,  and related netlist (encrypted  or  decrypted),
// support information,  device programming or simulation file,  and any other
// associated  documentation or information  provided by  Altera  or a partner
// under  Altera's   Megafunction   Partnership   Program  may  be  used  only
// to program  PLD  devices (but not masked  PLD  devices) from  Altera.   Any
// other  use  of such  megafunction  design,  netlist,  support  information,
// device programming or simulation file,  or any other  related documentation
// or information  is prohibited  for  any  other purpose,  including, but not
// limited to  modification,  reverse engineering,  de-compiling, or use  with
// any other  silicon devices,  unless such use is  explicitly  licensed under
// a separate agreement with  Altera  or a megafunction partner.  Title to the
// intellectual property,  including patents,  copyrights,  trademarks,  trade
// secrets,  or maskworks,  embodied in any such megafunction design, netlist,
// support  information,  device programming or simulation file,  or any other
// related documentation or information provided by  Altera  or a megafunction
// partner, remains with Altera, the megafunction partner, or their respective
// licensors. No other licenses, including any licenses needed under any third
// party's intellectual property, are provided herein.

module arm_top(
	clk_ref,
	npor,
	intextpin,
	ebiack,
	uartrxd,
	uartdsrn,
	uartctsn,
	pld_clk,
	reset_slave,
	uarttxd,
	uartrtsn,
	uartdtrn,
	ebiwen,
	ebioen,
	ebiclk,
	sdramrasn,
	sdramcasn,
	sdramwen,
	sdramclke,
	sdramclkn,
	sdramclk,
	lcd_en,
	nreset,
	uartdcdn,
	uartrin,
	ebiaddr,
	ebibe,
	ebicsn,
	ebidq,
	lcd_data,
	mode,
	sdramaddr,
	sdramcsn,
	sdramdq,
	sdramdqm,
	sdramdqs,
	seg_gnd1,
	seg_gnd2,
	seg_out1,
	seg_out2
);

input	clk_ref;
input	npor;
input	intextpin;
input	ebiack;
input	uartrxd;
input	uartdsrn;
input	uartctsn;
input	pld_clk;
input	reset_slave;
output	uarttxd;
output	uartrtsn;
output	uartdtrn;
output	ebiwen;
output	ebioen;
output	ebiclk;
output	sdramrasn;
output	sdramcasn;
output	sdramwen;
output	sdramclke;
output	sdramclkn;
output	sdramclk;
output	lcd_en;
inout	nreset;
inout	uartdcdn;
inout	uartrin;
output	[24:0] ebiaddr;
output	[1:0] ebibe;
output	[3:0] ebicsn;
inout	[15:0] ebidq;
output	[7:0] lcd_data;
output	[1:0] mode;
output	[14:0] sdramaddr;
output	[1:0] sdramcsn;
inout	[31:0] sdramdq;
output	[3:0] sdramdqm;
output	[3:0] sdramdqs;
output	[2:0] seg_gnd1;
output	[2:0] seg_gnd2;
output	[7:0] seg_out1;
output	[7:0] seg_out2;

wire	[31:0] HADDR;
wire	[2:0] HBURST;
wire	HCLOCK;
wire	[31:0] HRDATA;
wire	HREADY;
wire	[1:0] HRESP;
wire	[1:0] HSIZE;
wire	[1:0] HTRANS;
wire	[31:0] HWDATA;
wire	HWRITE;
wire	RESETN;
wire	SYNTHESIZED_WIRE_2;

assign	SYNTHESIZED_WIRE_2 = 1;




stripe	b2v_inst(.clk_ref(clk_ref),.npor(npor),.uartrxd(uartrxd),.uartdsrn(uartdsrn),.uartctsn(uartctsn),.intextpin(intextpin),.ebiack(ebiack),.masterhclk(HCLOCK),.masterhready(HREADY),.masterhgrant(SYNTHESIZED_WIRE_2),.nreset(nreset),.uartrin(uartrin),.uartdcdn(uartdcdn),.ebidq(ebidq),.masterhrdata(HRDATA),.masterhresp(HRESP),.sdramdq(sdramdq),.sdramdqs(),.uarttxd(uarttxd),.uartrtsn(uartrtsn),.uartdtrn(uartdtrn),.ebiclk(ebiclk),.ebiwen(ebiwen),.ebioen(ebioen),.sdramclk(sdramclk),.sdramclkn(sdramclkn),.sdramclke(sdramclke),.sdramwen(sdramwen),.sdramcasn(sdramcasn),.sdramrasn(sdramrasn),.masterhwrite(HWRITE),.ebiaddr(ebiaddr),.ebibe(ebibe),.ebicsn(ebicsn),.masterhaddr(HADDR),.masterhburst(HBURST),.masterhsize(HSIZE),.masterhtrans(HTRANS),.masterhwdata(HWDATA),.sdramaddr(sdramaddr),.sdramcsn(sdramcsn),.sdramdqm(sdramdqm));

SEG_SLAVE	b2v_inst1(.HSEL(SYNTHESIZED_WIRE_2),.HWRITE(HWRITE),.HRESETn(RESETN),.HCLOCK(HCLOCK),.HADDRESS(HADDR),.HBURST(HBURST),.HSIZE(HSIZE),.HTRANS(HTRANS),.HWDATA(HWDATA),.HREADY(HREADY),.lcd_en(lcd_en),.data_out(lcd_data),.HRESP(HRESP),.mode(mode),.read_reg(HRDATA),.seg_gnd1(seg_gnd1),.seg_gnd2(seg_gnd2),.seg_out1(seg_out1),.seg_out2(seg_out2));
assign	RESETN =  ~reset_slave;
assign	HCLOCK = pld_clk;


endmodule
