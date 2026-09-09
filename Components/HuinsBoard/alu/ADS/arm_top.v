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
	npor,
	clk_ref,
	HCLOCK,
	intextpin,
	ebiack,
	uartrxd,
	uartdsrn,
	uartctsn,
	HRESET,
	uarttxd,
	uartrtsn,
	uartdtrn,
	ebiwen,
	ebioen,
	ebiclk,
	nreset,
	uartdcdn,
	uartrin,
	ebiaddr,
	ebibe,
	ebicsn,
	ebidq
);

input	npor;
input	clk_ref;
input	HCLOCK;
input	intextpin;
input	ebiack;
input	uartrxd;
input	uartdsrn;
input	uartctsn;
input	HRESET;
output	uarttxd;
output	uartrtsn;
output	uartdtrn;
output	ebiwen;
output	ebioen;
output	ebiclk;
inout	nreset;
inout	uartdcdn;
inout	uartrin;
output	[24:0] ebiaddr;
output	[1:0] ebibe;
output	[3:0] ebicsn;
inout	[15:0] ebidq;

wire	SYNTHESIZED_WIRE_0;
wire	SYNTHESIZED_WIRE_12;
wire	[31:0] SYNTHESIZED_WIRE_2;
wire	[1:0] SYNTHESIZED_WIRE_3;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;
wire	[31:0] SYNTHESIZED_WIRE_7;
wire	[2:0] SYNTHESIZED_WIRE_8;
wire	[1:0] SYNTHESIZED_WIRE_9;
wire	[1:0] SYNTHESIZED_WIRE_10;
wire	[31:0] SYNTHESIZED_WIRE_11;

assign	SYNTHESIZED_WIRE_12 = 1;



assign	SYNTHESIZED_WIRE_5 =  ~HRESET;

stripe	b2v_inst2(.clk_ref(clk_ref),.npor(npor),.uartrxd(uartrxd),.uartdsrn(uartdsrn),.uartctsn(uartctsn),.intextpin(intextpin),.ebiack(ebiack),.masterhclk(HCLOCK),.masterhready(SYNTHESIZED_WIRE_0),.masterhgrant(SYNTHESIZED_WIRE_12),.nreset(nreset),.uartrin(uartrin),.uartdcdn(uartdcdn),.ebidq(ebidq),.masterhrdata(SYNTHESIZED_WIRE_2),.masterhresp(SYNTHESIZED_WIRE_3),.uarttxd(uarttxd),.uartrtsn(uartrtsn),.uartdtrn(uartdtrn),.ebiclk(ebiclk),.ebiwen(ebiwen),.ebioen(ebioen),.masterhwrite(SYNTHESIZED_WIRE_6),.ebiaddr(ebiaddr),.ebibe(ebibe),.ebicsn(ebicsn),.masterhaddr(SYNTHESIZED_WIRE_7),.masterhburst(SYNTHESIZED_WIRE_8),.masterhsize(SYNTHESIZED_WIRE_9),.masterhtrans(SYNTHESIZED_WIRE_10),.masterhwdata(SYNTHESIZED_WIRE_11));

pld_slave	b2v_pld_slave(.HCLOCK(HCLOCK),.HSEL(SYNTHESIZED_WIRE_12),.HRESETn(SYNTHESIZED_WIRE_5),.HWRITE(SYNTHESIZED_WIRE_6),.HADDRESS(SYNTHESIZED_WIRE_7),.HBURST(SYNTHESIZED_WIRE_8),.HSIZE(SYNTHESIZED_WIRE_9),.HTRANS(SYNTHESIZED_WIRE_10),.HWDATA(SYNTHESIZED_WIRE_11),.HREADY(SYNTHESIZED_WIRE_0),.HRDATA(SYNTHESIZED_WIRE_2),.HRESP(SYNTHESIZED_WIRE_3));


endmodule
