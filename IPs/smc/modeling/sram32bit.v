module sram32bit(
	 data ,
	 addr ,
	 we_n ,
	 oe_n ,
	 cs_n ,
	 be0_n,
	 be1_n,
	 be2_n,
	 be3_n);
	 
inout[31:0] data;
input[17:0] addr;
input		we_n;
input		oe_n;
input		cs_n;
input		be0_n;
input       be1_n;
input       be2_n;
input       be3_n;


sram16bit l_sram16bit(
		.data  		(data[15:0]	),
		.addr  		(addr[17:0]	),
		.we_n  		(we_n		),
		.oe_n  		(oe_n		),
		.cs_n  		(cs_n 		),
		.ble_n 		(be0_n		),
		.bhe_n 		(be1_n		));

sram16bit h_usram16bit(
		.data  		(data[31:16]),
		.addr  		(addr[17:0]	),
		.we_n  		(we_n		),
		.oe_n  		(oe_n		),
		.cs_n  		(cs_n 		),
		.ble_n 		(be2_n		),
		.bhe_n 		(be3_n		));

endmodule



		