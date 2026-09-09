// Copyright (C) 1991-2002 Altera Corporation
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

module pld_slave(
	HCLOCK,
	HSEL,
	HRESETn,
	HWRITE,
	HADDRESS,
	HBURST,
	HSIZE,
	HTRANS,
	HWDATA,
	HREADY,
	HRDATA,
	HRESP
);

input	HCLOCK;
input	HSEL;
input	HRESETn;
input	HWRITE;
input	[31:0] HADDRESS;
input	[2:0] HBURST;
input	[1:0] HSIZE;
input	[1:0] HTRANS;
input	[31:0] HWDATA;
output	HREADY;
output	[31:0] HRDATA;
output	[1:0] HRESP;

wire	latch_bus;
wire	[31:0] operation;
wire	[31:0] reg_address;
wire	[31:0] SYNTHESIZED_WIRE_0;
wire	[31:0] SYNTHESIZED_WIRE_1;
wire	[31:0] SYNTHESIZED_WIRE_2;
wire	SYNTHESIZED_WIRE_3;
wire	[31:0] SYNTHESIZED_WIRE_4;
wire	[31:0] SYNTHESIZED_WIRE_5;
wire	[31:0] SYNTHESIZED_WIRE_6;



alu	b2v_ALU(.operand1(SYNTHESIZED_WIRE_0),.operand2(SYNTHESIZED_WIRE_1),.operation(operation[1:0]),.result_high(SYNTHESIZED_WIRE_4),.result_low(SYNTHESIZED_WIRE_5));

ahb_slave_sm	b2v_Control_Unit(.HSEL(HSEL),.HWRITE(HWRITE),.HRESETn(HRESETn),.HCLOCK(HCLOCK),.HADDRESS(HADDRESS),.HBURST(HBURST),.HSIZE(HSIZE),.HTRANS(HTRANS),.HWDATA(HWDATA),.reg_rdata(SYNTHESIZED_WIRE_2),.reg_write(SYNTHESIZED_WIRE_3),.HREADY(HREADY),.latch_bus(latch_bus),.HRDATA(HRDATA),.HRESP(HRESP),.reg_address(reg_address),.reg_wdata(SYNTHESIZED_WIRE_6));
defparam	b2v_Control_Unit.ADDRESS_PHASE = 'b00;
defparam	b2v_Control_Unit.DATA_PHASE = 'b10;
defparam	b2v_Control_Unit.ERROR_PHASE = 'b01;
defparam	b2v_Control_Unit.READ_WAIT_PHASE = 'b11;

regfile	b2v_Register_File(.reset(HRESETn),.clock(HCLOCK),.write(SYNTHESIZED_WIRE_3),.clock_enb(latch_bus),.address(reg_address[4:2]),.result_high(SYNTHESIZED_WIRE_4),.result_low(SYNTHESIZED_WIRE_5),.write_data(SYNTHESIZED_WIRE_6),.operand1(SYNTHESIZED_WIRE_0),.operand2(SYNTHESIZED_WIRE_1),.operation(operation),.read_data(SYNTHESIZED_WIRE_2));




endmodule
