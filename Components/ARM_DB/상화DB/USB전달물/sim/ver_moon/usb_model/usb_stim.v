`define OUT         8'he1
`define IN          8'h69
`define SOF         8'h2d
`define SETUP       8'h2d
`define DATA0       8'hc3
`define DATA1       8'h4b
`define ACK         8'hd2
`define NAK         8'h5a
`define STALL       8'h1e

`define USBR        3'h0
`define USBW        3'h1
`define CONR        3'h2
`define CONW        3'h3
`define PCONR       3'h4
`define PCONW       3'h5
`define INTRW       3'h6
`define DEFAULT     3'h7


//********************************************************************
// USB HOST MODELING
//********************************************************************
reg hclk;
reg hreset;
reg hureset;
reg tx_start;
reg[6:0] tx_data_len;
reg[7:0] tx_pid;
reg[7:0] tx_byte;
reg token_flag;
reg hands_flag;
reg rcv;
reg pseq;
reg[7:0] host_mem[0:63];
reg ddrx_valid;
reg ruto_on;
reg[7:0] rutoh_mem[3:0];
integer rutoi;
integer rutoii;
wire phuclk;
integer rand_seed;

initial begin
 rutoi = 0;
 rutoii = 0;
 rand_seed = 10;
 hclk = 0;
 hreset = 0;

 forever #10 hclk = ~hclk;
end

always @(posedge hclk or posedge hreset)
 if (hreset) hureset <= 1'b0;

wire[7:0] host_rx_byte;
wire[1:0] line_state;

 host_top host_top (DP, DM,
    dtx_ready, drx_valid, host_rx_byte, line_state, packet_error, phuclk,
    hclk, hreset, hureset,
    tx_start, tx_data_len, tx_pid, token_flag, hands_flag, tx_byte, rcv
 );

always @(posedge hclk) ddrx_valid <= drx_valid;


//*********************************************************************
// USB TEST STIMULUS
//*********************************************************************
integer m;
integer mm;
reg e0_seq;
reg e1_seq;
reg e2_seq;
reg e3_seq;
reg[6:0] device_addr;
integer dcount;
reg[7:0] data_mem[2047:0];
reg[7:0] header_mem[3:0];
reg[7:0] last_header_mem[3:0];
reg[6:0] rx_byte_count;
reg[7:0] intr_type;
reg[31:0] intr_timer;
reg dintr;
reg pdintr;
reg do_in_tran;
integer loop;
reg[1:0] control_count;
reg[7:0] host_data[1024:0];
reg[7:0] data_in[1024:0];
reg[7:0] table_data[80:0];
integer data_cnt;
reg[7:0] usb_rx_sdata0[64000:0];
reg[7:0] usb_rx_sdata1[64000:0];
reg utx_start;
integer ud_data_len;
reg[10:0] us_data_len;
reg[31:0] usb_reg_rdata;
reg[31:0] usb_reg_wdata;
reg[31:0] utx_addr[2000:0];
reg[31:0] utx_data_len[2000:0];

`include "./usb_model/usb_task.v"

initial begin
 m = 0;
 mm = 5;
 rcv = 1'b0;
 intr_timer = 32'h00000000;
 dintr = 1'b0;
 pdintr = 1'b0;
 intr_type = 8'h00;
 do_in_tran = 1'b0;
 loop = 0;
 dcount = 0;
 control_count = 2'h0;
 utx_start = 0;
end

wire pintr = (intr_timer == 32'h0000bb80);

always @(posedge hclk) begin
	if (pintr) intr_timer <= 32'h0;
	else intr_timer <= intr_timer + 1;
end

always @(posedge hclk)
 if (pintr) dintr <= 1'b1;
 else if (pdintr) dintr <= 1'b0;

reg[7:0] temp_host_mem;
reg[7:0] temp_data_in;

reg usb_start;
initial begin
 usb_start = 0;
 #3000000;
 usb_start = 1;
end

always begin

 if (m == 0) begin
	usb_host_reset(32'h00000500);
	@(posedge hclk);
	if (usb_start) m = 1;
	else m = 0; 
 end

 if (m == 1) begin		//SYSTEM RESET
	usb_host_reset(32'h00004000);

	m = 3;
	$display($time,,"HOST RESET");
 end

 if (m == 3) begin		//BUS RESET
	usb_bus_reset(32'h00010000);

	m = 4;
	$display($time,,"USB BUS RESET");
 end

 if (m == 4) begin		//Get_Descriptor Device
	$readmemh ("./usb_model/usb_table/initial_device_descriptor.hex", host_data, 0);

	control_tran(8'h80, 8'h06, 16'h0100, 16'h0000, 16'h0040);

	for (data_cnt = 0; data_cnt < 18; data_cnt = data_cnt + 1)
	 if (data_in[data_cnt] !== host_data[data_cnt]) begin
		$display($time,,"ERROR !!! %x %x %d", data_in[data_cnt], host_data[data_cnt], data_cnt);
		$stop;
	 end

	m = 5;
	$display($time,,"GET DESCRIPTOR DEVICE CONTROL TRANSACTION");
 end

 if (m == 5) begin		//BUS RESET
	if ($test$plusargs("TEST_DUMP")) usb_bus_reset(32'h00078000);
	else usb_bus_reset(32'h00002000);

	m = 6;
	$display($time,,"USB BUS RESET");
 end

 if (m == 6) begin		//Get_Descriptor Device
	$readmemh ("./usb_model/usb_table/initial_device_descriptor.hex", host_data);

	control_tran(8'h80, 8'h06, 16'h0100, 16'h0000, 16'h0012);

	for (data_cnt = 0; data_cnt < 18; data_cnt = data_cnt + 1)
 	 if (data_in[data_cnt] !== host_data[data_cnt]) begin
		$display($time,,"ERROR !!! %x %x %d", data_in[data_cnt], host_data[data_cnt], data_cnt);
		$stop;
	 end

	m = 10;
	$display($time,,"GET DESCRIPTOR DEVICE CONTROL TRANSACTION");
 end

 if (m == 10) begin
	control_tran(8'h00, 8'h05, 16'h0005, 16'h0000, 16'h0000);

	m = 11;
	@(posedge hclk) device_addr <= 7'h05;
	$display($time,,"SET ADDRESS CONTROL TRANSACTION");
 end

 if (m == 11) begin
	$readmemh ("./usb_model/usb_table/set_device_descriptor.hex", host_mem);
	$readmemh ("./usb_model/usb_table/set_device_descriptor.hex", host_data);

	control_tran(8'h00, 8'h07, 16'h0100, 16'h0000, 16'h0012);

	m = 12;
	$display($time,,"SET DESCRIPTOR DEVICE CONTROL TRANSACTION");
 end

 if (m == 12) begin
	control_tran(8'h80, 8'h06, 16'h0100, 16'h0000, 16'h0012);

	for (data_cnt = 0; data_cnt < 18; data_cnt = data_cnt + 1)
 	 if (data_in[data_cnt] != host_data[data_cnt]) begin
		$display($time,,"ERROR !!!");
		$stop;
	 end

	m = 13;
	$display($time,,"GET DESCRIPTOR DEVICE CONTROL TRANSACTION");
 end

 if (m == 13) begin
	$readmemh ("./usb_model/usb_table/get_config_descriptor.hex", host_data);

	control_tran(8'h80, 8'h06, 16'h0200, 16'h0000, 16'h003c);

	for (data_cnt = 0; data_cnt < 40; data_cnt = data_cnt + 1)
 	 if (data_in[data_cnt] != host_data[data_cnt]) begin
		$display($time,,"ERROR !!! %x %x %d", data_in[data_cnt], host_data[data_cnt], data_cnt);
		$stop;
	 end

	m = 14;
	$display($time,,"GET DESCRIPTOR CONFIGURATION CONTROL TRANSACTION");
 end

 if (m == 14) begin
	control_tran(8'h00, 8'h09, 16'h0001, 16'h0000, 16'h0000);

	m = 20;
	$display($time,,"SET CONFIGURATION CONTROL TRANSACTION");
 end

 if (m == 20) begin
	$readmemh ("./usb_model/usb_table/get_status_device.hex", host_data);

	control_tran(8'h80, 8'h00, 16'h0000, 16'h0000, 16'h0002);

	for (data_cnt = 0; data_cnt < 2; data_cnt = data_cnt + 1)
 	 if (data_in[data_cnt] != host_data[data_cnt]) begin
		$display($time,,"ERROR !!!");
		$stop;
	 end

	m = 21;
	$display($time,,"GET STATUS DEVICE CONTROL TRANSACTION");
 end

 if (m == 21) begin
	$readmemh ("./usb_model/usb_table/get_status_interface.hex", host_data);

	control_tran(8'h81, 8'h00, 16'h0000, 16'h0000, 16'h0002);

	for (data_cnt = 0; data_cnt < 2; data_cnt = data_cnt + 1)
 	 if (data_in[data_cnt] != host_data[data_cnt]) begin
		$display($time,,"ERROR !!!");
		$stop;
	 end

	m = 22;
	$display($time,,"GET STATUS INTERFACE CONTROL TRANSACTION");
 end

 if (m == 22) begin
	$readmemh ("./usb_model/usb_table/get_status_interface.hex", host_data);

	control_tran(8'h81, 8'h00, 16'h0000, 16'h0000, 16'h0002);

	for (data_cnt = 0; data_cnt < 2; data_cnt = data_cnt + 1)
 	 if (data_in[data_cnt] != host_data[data_cnt]) begin
		$display($time,,"ERROR !!!");
		$stop;
	 end

	m = 24;
	$display($time,,"GET STATUS INTERFACE CONTROL TRANSACTION");
 end

 if (m == 23) begin
	$readmemh ("./usb_model/usb_table/get_status_interface.hex", host_data);

	control_tran(8'h81, 8'h00, 16'h0000, 16'h0002, 16'h0002);

	for (data_cnt = 0; data_cnt < 2; data_cnt = data_cnt + 1)
 	 if (data_in[data_cnt] != host_data[data_cnt]) begin
		$display($time,,"ERROR !!!");
		$stop;
	 end

	m = 24;
	$display($time,,"GET STATUS INTERFACE CONTROL TRANSACTION");
 end

 if (m == 24) begin
	$readmemh ("./usb_model/usb_table/get_status_endp2.hex", host_data);

	control_tran(8'h82, 8'h00, 16'h0000, 16'h0002, 16'h0002);

	for (data_cnt = 0; data_cnt < 2; data_cnt = data_cnt + 1)
 	 if (data_in[data_cnt] != host_data[data_cnt]) begin
		$display($time,,"ERROR !!!");
		$stop;
	 end

	m = 30;
	$display($time,,"GET STATUS ENDPOINT2 CONTROL TRANSACTION");
 end

 if (m == 30) begin
	$readmemh ("./usb_model/usb_table/get_configuration.hex", host_data);

	control_tran(8'h80, 8'h08, 16'h0000, 16'h0000, 16'h0001);

	for (data_cnt = 0; data_cnt < 1; data_cnt = data_cnt + 1)
 	 if (data_in[data_cnt] != host_data[data_cnt]) begin
		$display($time,,"ERROR !!!");
		$stop;
	 end

	m = 5000;
	$display($time,,"GET CONFIGURATION CONTROL TRANSACTION");
 end

	if (m == 51) begin
		control_tran(8'h81, 8'h0a, 16'h0000, 16'h0000, 16'h0001);

		m = 52;
		$display($time,,"GET INTERFACE0 CONTROL TRANSACTION");
	end

	if (m == 52) begin
		control_tran(8'h81, 8'h0a, 16'h0000, 16'h0001, 16'h0001);

		m = 53;
		$display($time,,"GET INTERFACE1 CONTROL TRANSACTION");
	end

	if (m == 53) begin
		control_tran(8'h01, 8'h0b, 16'h0001, 16'h0001, 16'h0000);

		m = 54;
		$display($time,,"SET INTERFACE1 CONTROL TRANSACTION");
	end

	if (m == 54) begin
		control_tran(8'h81, 8'h0a, 16'h0000, 16'h0001, 16'h0001);

		if (mm == 5) m = 5000;
		else m = 400;
		$display($time,,"GET INTERFACE1 CONTROL TRANSACTION");
	end

	if (m == 5000) begin

		m = 5001;
	end

	if (m == 5001) begin
		@(posedge hclk) utx_start = 1;

		us_data_len = 60;
		ud_data_len = 60;

		m = 5002;
	end

	if (m == 5002) begin
		for(dcount = 0; dcount < us_data_len; dcount = dcount + 1) begin
		  data_mem[dcount] = us_data_len + dcount;
		end

		data_out_tran (us_data_len);

		m = 5003;
		$display($time,,"%d DATA OUT TRANSACTION", us_data_len);
	end

	if (m == 5003) begin
		@(posedge hclk);
		if (utx_start) m = 5010;
		else m = 5004;
	end

	if (m == 5004) begin
        us_data_len = ($random (rand_seed) % 1514) + 1;

        @(posedge hclk);
		if (us_data_len % 64 == 0) m = 5005;
		else m = 5002;
	end

	if (m == 5005) begin
		for(dcount = 0; dcount < us_data_len; dcount = dcount + 1) begin
	      data_mem[dcount] = us_data_len + dcount;
		end

		data_out_tran (us_data_len);

		@(posedge hclk);
		m = 5006;
	end

	if (m == 5006) begin
		data_out_tran (0);

		@(posedge hclk);
		m = 5007;
		$display($time,,"%d DATA OUT TRANSACTION", us_data_len);
	end

	if (m == 5007) begin
		intr_tran (intr_type);

		m = 5004;
		$display($time,,"INTURRUPT TRANSACTION");
	end

	if (m == 5010) begin

		m = 5011;
	end

	if (m == 5011) begin

		data_in_tran;

		m = 5004;
		$display($time,,"DATA IN TRANSACTION");
	end

end
