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
	ebiack,
	intextpin,
	uartrxd,
	uartdsrn,
	uartctsn,
	DATA_A,
	DATA_B,
	DATA_C,
	DATA_D,
	DATA_AVAIL,
	HCLOCK,
	HRESET,
	uartdtrn,
	uarttxd,
	uartrtsn,
	ebiwen,
	ebioen,
	Mwrite,
	hready,
	nreset,
	uartrin,
	uartdcdn,
	burst,
	ebiaddr,
	ebicsn,
	ebidq,
	hresp,
	masterhaddr,
	masterhrdata,
	masterhwdata,
	size,
	trans
);

input	clk_ref;
input	npor;
input	ebiack;
input	intextpin;
input	uartrxd;
input	uartdsrn;
input	uartctsn;
input	DATA_A;
input	DATA_B;
input	DATA_C;
input	DATA_D;
input	DATA_AVAIL;
input	HCLOCK;
input	HRESET;
output	uartdtrn;
output	uarttxd;
output	uartrtsn;
output	ebiwen;
output	ebioen;
output	Mwrite;
output	hready;
inout	nreset;
inout	uartrin;
inout	uartdcdn;
output	[2:0] burst;
output	[24:0] ebiaddr;
output	[3:0] ebicsn;
inout	[15:0] ebidq;
output	[1:0] hresp;
output	[31:0] masterhaddr;
output	[31:0] masterhrdata;
output	[31:0] masterhwdata;
output	[1:0] size;
output	[1:0] trans;

wire	[2:0] burst_ALTERA_SYNTHESIZED;
wire	hready_ALTERA_SYNTHESIZED;
wire	HRESETn;
wire	[1:0] hresp_ALTERA_SYNTHESIZED;
wire	[5:0] intpld;
wire	[31:0] masterhaddr_ALTERA_SYNTHESIZED;
wire	[31:0] masterhrdata_ALTERA_SYNTHESIZED;
wire	[31:0] masterhwdata_ALTERA_SYNTHESIZED;
wire	Mwrite_ALTERA_SYNTHESIZED;
wire	[1:0] size_ALTERA_SYNTHESIZED;
wire	[7:0] soft_led;
wire	[1:0] trans_ALTERA_SYNTHESIZED;
wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_5;
wire	[0:15] SYNTHESIZED_WIRE_3;
wire	[0:7] SYNTHESIZED_WIRE_4;

assign	SYNTHESIZED_WIRE_0 = 1;
assign	SYNTHESIZED_WIRE_5 = 1;
assign	SYNTHESIZED_WIRE_3 = 0;
assign	SYNTHESIZED_WIRE_4 = 0;




alu_slave4	b2v_inst(.HCLOCK(HCLOCK),.HSEL(SYNTHESIZED_WIRE_0),.HRESETn(HRESETn),.HWRITE(Mwrite_ALTERA_SYNTHESIZED),.DATA_AVAIL(DATA_AVAIL),.DATA_A(DATA_A),.DATA_B(DATA_B),.DATA_C(DATA_C),.DATA_D(DATA_D),.HADDRESS(masterhaddr_ALTERA_SYNTHESIZED),.HBURST(burst_ALTERA_SYNTHESIZED),.HSIZE(size_ALTERA_SYNTHESIZED),.HTRANS(trans_ALTERA_SYNTHESIZED),.HWDATA(masterhwdata_ALTERA_SYNTHESIZED),.HREADY(hready_ALTERA_SYNTHESIZED),.Int_PLD(intpld[1]),.HRDATA(masterhrdata_ALTERA_SYNTHESIZED),.HRESP(hresp_ALTERA_SYNTHESIZED));

stripe	b2v_inst5(.clk_ref(clk_ref),.npor(npor),.uartrxd(uartrxd),.uartdsrn(uartdsrn),.uartctsn(uartctsn),.intextpin(intextpin),.ebiack(ebiack),.masterhclk(HCLOCK),.masterhready(hready_ALTERA_SYNTHESIZED),.masterhgrant(SYNTHESIZED_WIRE_5),.dp0_2_portaclk(SYNTHESIZED_WIRE_5),.dp0_portawe(HCLOCK),.nreset(nreset),.uartrin(uartrin),.uartdcdn(uartdcdn),.dp0_portaaddr(SYNTHESIZED_WIRE_3),.dp0_portadatain(SYNTHESIZED_WIRE_4),.ebidq(ebidq),.intpld(intpld),.masterhrdata(masterhrdata_ALTERA_SYNTHESIZED),.masterhresp(hresp_ALTERA_SYNTHESIZED),.uarttxd(uarttxd),.uartrtsn(uartrtsn),.uartdtrn(uartdtrn),.ebiwen(ebiwen),.ebioen(ebioen),.masterhwrite(Mwrite_ALTERA_SYNTHESIZED),.ebiaddr(ebiaddr),.ebicsn(ebicsn),.masterhaddr(masterhaddr_ALTERA_SYNTHESIZED),.masterhburst(burst_ALTERA_SYNTHESIZED),.masterhsize(size_ALTERA_SYNTHESIZED),.masterhtrans(trans_ALTERA_SYNTHESIZED),.masterhwdata(masterhwdata_ALTERA_SYNTHESIZED));
assign	HRESETn =  ~HRESET;
assign	Mwrite = Mwrite_ALTERA_SYNTHESIZED;
assign	hready = hready_ALTERA_SYNTHESIZED;
assign	burst = burst_ALTERA_SYNTHESIZED;
assign	hresp = hresp_ALTERA_SYNTHESIZED;
assign	masterhaddr = masterhaddr_ALTERA_SYNTHESIZED;
assign	masterhrdata = masterhrdata_ALTERA_SYNTHESIZED;
assign	masterhwdata = masterhwdata_ALTERA_SYNTHESIZED;
assign	size = size_ALTERA_SYNTHESIZED;
assign	trans = trans_ALTERA_SYNTHESIZED;

assign	intpld[3] = 0;
assign	intpld[2] = 0;
assign	intpld[0] = 0;
assign	intpld[5] = 0;
assign	intpld[4] = 0;

endmodule
