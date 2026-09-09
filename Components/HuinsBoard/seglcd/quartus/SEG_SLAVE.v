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

module SEG_SLAVE(
	HSEL,
	HWRITE,
	HRESETn,
	HCLOCK,
	HADDRESS,
	HBURST,
	HSIZE,
	HTRANS,
	HWDATA,
	HREADY,
	lcd_en,
	phase,
	cnt3,
	data_out,
	HRESP,
	mode,
	rd_address,
	read_reg,
	seg_data,
	seg_gnd1,
	seg_gnd2,
	seg_out1,
	seg_out2
);

input	HSEL;
input	HWRITE;
input	HRESETn;
input	HCLOCK;
input	[31:0] HADDRESS;
input	[2:0] HBURST;
input	[1:0] HSIZE;
input	[1:0] HTRANS;
input	[31:0] HWDATA;
output	HREADY;
output	lcd_en;
output	phase;
output	[1:0] cnt3;
output	[7:0] data_out;
output	[1:0] HRESP;
output	[1:0] mode;
output	[4:0] rd_address;
output	[31:0] read_reg;
output	[31:0] seg_data;
output	[2:0] seg_gnd1;
output	[2:0] seg_gnd2;
output	[7:0] seg_out1;
output	[7:0] seg_out2;

wire	SYNTHESIZED_WIRE_9;
wire	SYNTHESIZED_WIRE_1;
wire	[9:2] SYNTHESIZED_WIRE_10;
wire	[31:0] SYNTHESIZED_WIRE_11;
wire	SYNTHESIZED_WIRE_5;
wire	SYNTHESIZED_WIRE_6;

assign	SYNTHESIZED_WIRE_1 = 0;
assign	SYNTHESIZED_WIRE_6 = 1;


ahb_slave_sm	b2v_inst(.HSEL(HSEL),.HWRITE(HWRITE),.HRESETn(HRESETn),.HCLOCK(HCLOCK),.HADDRESS(HADDRESS),.HBURST(HBURST),.HSIZE(HSIZE),.HTRANS(HTRANS),.HWDATA(HWDATA),.HREADY(HREADY),.clk(SYNTHESIZED_WIRE_9),.write(SYNTHESIZED_WIRE_5),.data(SYNTHESIZED_WIRE_11),.HRESP(HRESP),.slave_address(SYNTHESIZED_WIRE_10));
defparam	b2v_inst.ADDRESS_PHASE = 'b00;
defparam	b2v_inst.DATA_PHASE = 'b10;
defparam	b2v_inst.ERROR_PHASE = 'b01;
defparam	b2v_inst.READ_WAIT_PHASE = 'b11;

seven_seg	b2v_inst1(.clk(SYNTHESIZED_WIRE_9),.reset_n(HRESETn),.enable_n(SYNTHESIZED_WIRE_1),.address(SYNTHESIZED_WIRE_10),.data(SYNTHESIZED_WIRE_11),.cnt3(cnt3),.seg_data(seg_data),.seg_gnd1(seg_gnd1),.seg_gnd2(seg_gnd2),.seg_out1(seg_out1),.seg_out2(seg_out2));

LCD_TOP	b2v_inst2(.clk(SYNTHESIZED_WIRE_9),.reset(HRESETn),.write(SYNTHESIZED_WIRE_5),.enable(SYNTHESIZED_WIRE_6),.address(SYNTHESIZED_WIRE_10),.data_in(SYNTHESIZED_WIRE_11),.lcd_en(lcd_en),.phase(phase),.data_out(data_out),.mode(mode),.rd_address(rd_address),.read_reg(read_reg));
defparam	b2v_inst2.DATA_PHASE = 'b1;
defparam	b2v_inst2.INIT_PHASE = 'b0;




endmodule
