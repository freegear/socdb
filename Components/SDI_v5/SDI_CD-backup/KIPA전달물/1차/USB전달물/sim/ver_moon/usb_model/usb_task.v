task usb_host_reset;
input[31:0] time_len;
begin

 @(posedge hclk)
	hreset <= 1'b1;
	tx_data_len <= 7'h00;
 #time_len;

 @(posedge hclk) hreset <= 1'b0;

end
endtask


task usb_bus_reset;
input[31:0] time_len;
begin

 @(posedge hclk)
 @(posedge hclk)
 @(posedge hclk)
 @(posedge hclk)
 @(posedge hclk)
	hureset <= 1'b1;
	device_addr <= 7'h00;
	e0_seq <= 1'b0;
	e1_seq <= 1'b0;
	e2_seq <= 1'b0;
	e3_seq <= 1'b0;
 #time_len;

 @(posedge hclk)
 @(posedge hclk)
 @(posedge hclk)
	hureset <= 1'b0;

end
endtask

task control_tran;
input[7:0] bmRequestType;
input[7:0] bRequest;
input[15:0] wValue;
input[15:0] wIndex;
input[15:0] wLength;
integer i;
integer j;
integer k;
integer setup_loop;
begin

 i = 0; j = 0;
 setup_loop = 0;
 @(posedge hclk);

 while (i == 0) begin

	if (j == 0) begin
		Send_Token(`SETUP, device_addr, 4'h0);
		j = 1;
		$display($time,,"SETUP TRANSACTION TOKEN");
		@(posedge hclk);
	end

	if (j == 1) begin
		Send_Setup_Data(bmRequestType, bRequest, wValue, wIndex, wLength);
		j = 2;
		$display($time,,"SETUP TRANSACTION DATA");	
		@(posedge hclk);
	end	

	if (j == 2) begin
		Wait_Hands(k);

		if (k == 0) begin
			j = 0;
			$display($time,,"SETUP TRANSACTION FAIL");
		end
		else if (k == 1) begin
			if (wLength == 16'h0000) j = 10;
			else if (bmRequestType[7]) j = 20;
			else begin
				j = 30;

				if (bmRequestType[6:5] == 2'b01 & bRequest == 8'h00) begin
					for(k = 0; k < wLength; k = k + 1) host_mem[k] = data_mem[k];
				end
			end

			e0_seq = 1'b1;
			$display($time,,"SETUP TRANSACTION ACK HANDS");
		end	
		@(posedge hclk);
	end

	if (j == 10) begin
		Send_Token(`IN, device_addr, 4'h0);

		j = 11;
		e0_seq = 1'b1;
		$display($time,,"STATUS TRANSACTION IN TOKEN");
		@(posedge hclk);
	end

	if (j == 11) begin
		Wait_Data(k, e0_seq);

		if (k == 0) begin
			j = 10;
			$display($time,,"STATUS TRANSACTION FAIL");
		end
		else if (k == 1) begin
			j = 12;
			$display($time,,"STATUS TRANSACTION DATA");
		end
		@(posedge hclk);
	end

	if (j == 12) begin
		Send_Hands(`ACK);

		i = 1;
		$display($time,,"STATUS TRANSACTION HANDS");
		@(posedge hclk);
	end

	if (j == 20) begin
		Send_Token(`IN, device_addr, 4'h0);
		j = 21;
		$display($time,,"DATA TRANSACTION TOKEN");
		@(posedge hclk);
	end

	if (j == 21) begin
		Wait_Data(k, e0_seq);

		if (k == 0) begin
			j = 20;
			$display($time,,"DATA TRANSACTION FAIL");
		end
		else if (k == 1) begin
			j = 22;
			$display($time,,"DATA TRANSACTION DATA");
		end
		@(posedge hclk);
	end

	if (j == 22) begin
		Send_Hands(`ACK);

		if (rx_byte_count < 7'h40) j = 23;
		else j = 20;

		setup_loop = setup_loop + 1;
		e0_seq = ~e0_seq;
		$display($time,,"DATA TRANSACTION HANDS");
		@(posedge hclk);
	end
	
	if (j == 23) begin
		Send_Token(`OUT, device_addr, 4'h0);
		j = 24;
		$display($time,,"STATUS TRANSACTION TOKEN");
		@(posedge hclk) begin
			for(k = 0; k < 64; k = k + 1) host_mem[k] = 8'h00;
			e0_seq <= 1'b1;
		end
	end

	if (j == 24) begin
		Send_Data(`DATA1, 0);
		j = 25;
		$display($time,,"STATUS TRANSACTION DATA");	
		@(posedge hclk);
	end	

	if (j == 25) begin
		Wait_Hands(k);

		if (k == 0) begin
			j = 23;
			$display($time,,"STATUS TRANSACTION FAIL");
		end
		else if (k == 1) begin
			i = 1;
			$display($time,,"STATUS TRANSACTION SUCCESS");
		end	
		@(posedge hclk);
	end

	if (j == 30) begin
		Send_Token(`OUT, device_addr, 4'h0);
		j = 31;
		$display($time,,"DATA TRANSACTION OUT TOKEN");
		@(posedge hclk) e0_seq <= 1'b1;
	end

	if (j == 31) begin
		if (e0_seq) Send_Data(`DATA1, wLength - 64 * setup_loop);
		else Send_Data(`DATA0, wLength - 64 * setup_loop);
		j = 32;
		$display($time,,"DATA TRANSACTION DATA");	
		@(posedge hclk);
	end	

	if (j == 32) begin
		Wait_Hands(k);

		if (k == 0) begin
			j = 30;
			$display($time,,"DATA TRANSACTION FAIL");
		end
		else if (k == 1) begin
			setup_loop = setup_loop + 1;
			j = 10;
			$display($time,,"DATA TRANSACTION SUCCESS");
		end	
		@(posedge hclk);
	end
 end

end
endtask

task Send_Token;
input[7:0] pid;
input[6:0] addr;
input[3:0] endp;
begin

 @(posedge hclk) begin
	tx_pid <= pid;
	tx_start <= 1'b1;
 end
 @(posedge hclk) begin
	tx_start <= 1'b0;
	token_flag <= 1'b1;
	tx_data_len <= 7'h02;
 	tx_byte <= {endp[0], addr};
 end

 while (~dtx_ready) @(posedge hclk);
 tx_byte[2:0] <= endp[3:1];
 @(posedge hclk);

 while (~dtx_ready) @(posedge hclk);
 @(posedge hclk);

 while (~dtx_ready) @(posedge hclk);
 @(posedge hclk) token_flag <= 1'b0;

 while (line_state != 2'b00) @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);

end
endtask

task Send_Setup_Data;
input[7:0] bmRequestType;
input[7:0] bRequest;
input[15:0] wValue;
input[15:0] wIndex;
input[15:0] wLength;
begin

 @(posedge hclk) begin
	tx_pid <= `DATA0;
	tx_start <= 1'b1;
 end
 @(posedge hclk) begin
	tx_data_len <= 7'h08;
 	tx_byte <= bmRequestType;		//bmRequestType
	tx_start <= 1'b0;
 end

 while (~dtx_ready) @(posedge hclk);
 tx_byte <= bRequest;			//bRequest
 @(posedge hclk);

 while (~dtx_ready) @(posedge hclk);
 tx_byte <= wValue[7:0];		//wValue[7:0]
 @(posedge hclk);

 while (~dtx_ready) @(posedge hclk);
 tx_byte <= wValue[15:8];		//wValue[15:8]
 @(posedge hclk);

 while (~dtx_ready) @(posedge hclk);
 tx_byte <= wIndex[7:0];		//wIndex[7:0]
 @(posedge hclk);

 while (~dtx_ready) @(posedge hclk);
 tx_byte <= wIndex[15:8];		//wIndex[15:8]
 @(posedge hclk);

 while (~dtx_ready) @(posedge hclk);
 tx_byte <= wLength[7:0];		//wLength[7:0]
 @(posedge hclk);

 while (~dtx_ready) @(posedge hclk);
 tx_byte <= wLength[15:8];		//wLength[15:8]
 @(posedge hclk);

 while (line_state != 2'b00) @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);

end
endtask

task Wait_Hands;
output result;
reg escape;
integer eoi_count;
begin

 @(posedge hclk)
	escape <= 1'b0;
	eoi_count <= 0;
 @(posedge hclk);

 while (escape == 1'b0 & line_state != 2'b10)
	@(posedge hclk) begin
		if (eoi_count == 100) escape <= 1'b1;
		else eoi_count <= eoi_count + 1;
	end
 @(posedge hclk) rcv <= 1'b1;

 while(escape == 1'b0 & ~drx_valid) @(posedge hclk);
 @(posedge hclk) $write ("\t%h\n", host_rx_byte);

 @(posedge hclk)
 if (escape == 1'b1) result = 0;
 else if (host_rx_byte == 8'hd2) result = 1;
 else result = 0;

 @(posedge hclk) rcv <= 1'b0;
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);

end
endtask

task Wait_Data;
output result;
input seqbit;
integer temp;
reg escape;
integer eoi_count;
integer ii;
integer iii;
reg eop_state;
begin

 @(posedge hclk) begin
	escape <= 1'b0;
	eoi_count <= 0;
 	rx_byte_count = 0;
	ii <= 0;
	iii <= 0;
	eop_state <= 1'b0;
 end
 @(posedge hclk);

 while (escape == 1'b0 & line_state != 2'b10)
	@(posedge hclk) begin
		if (eoi_count == 100) escape <= 1'b1;
		else eoi_count <= eoi_count + 1;
	end
 @(posedge hclk) rcv <= 1'b1;

 while(escape == 1'b0 & ~drx_valid) @(posedge hclk);
 @(posedge hclk) $write ("\t%h\n", host_rx_byte);

 @(posedge hclk)
 if (host_rx_byte == 8'hc3) temp <= 0;
 else if (host_rx_byte == 8'h4b) temp <= 1;
 else if (host_rx_byte == 8'h5a) temp <= 2;
 @(posedge hclk);

 while (temp != 2 & (escape == 1'b0 & (~eop_state | line_state != 2'b00)) ) begin
	@(posedge hclk) begin
		if (line_state == 2'b00) eop_state <= 1'b1;
		else eop_state <= 1'b0;
		if (ddrx_valid) begin
			$write ("%d %h\n", rx_byte_count, host_rx_byte);
			rx_byte_count <= rx_byte_count + 1;
			data_in[ii] <= host_rx_byte;
			ii <= ii + 1;
		end
	end
 end

 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk) begin
	if (packet_error | (temp != seqbit)) result = 0;
	else result = 1;
 end

 if (~result) begin
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 end

 $write ("/***** Display *****/\n");
 for (iii = 0; iii < ii; iii = iii + 1) begin
	if (iii % 16 == 0) $write ("Display\t%h ", data_in[iii]);
	else if (iii % 16 == 15) $write ("%h\n", data_in[iii]);
	else $write ("%h ", data_in[iii]);	
 end
 $write ("\n");

 @(posedge hclk) rcv <= 1'b0;
 @(posedge hclk);
 @(posedge hclk);

end
endtask

task Wait_in_Data;
output result;
input seqbit;
input[15:0] r_data_cnt;
integer temp;
reg escape;
integer eoi_count;
integer ii;
integer iii;
reg eop_state;
begin

 @(posedge hclk) begin
	escape <= 1'b0;
	eoi_count <= 0;
 	rx_byte_count = 0;
	ii <= r_data_cnt;
	iii <= 0;
	eop_state <= 1'b0;
 end
 @(posedge hclk);

 while (escape == 1'b0 & line_state != 2'b10)
	@(posedge hclk) begin
		if (eoi_count == 100) escape <= 1'b1;
		else eoi_count <= eoi_count + 1;
	end
 @(posedge hclk) rcv <= 1'b1;

 while(escape == 1'b0 & ~drx_valid) @(posedge hclk);
 @(posedge hclk) $write ("\t%h\n", host_rx_byte);

 @(posedge hclk)
 if (host_rx_byte == 8'hc3) temp <= 0;
 else if (host_rx_byte == 8'h4b) temp <= 1;
 else if (host_rx_byte == 8'h5a) temp <= 2;
 @(posedge hclk);

 while (temp != 2 & (escape == 1'b0 & (~eop_state | line_state != 2'b00)) ) begin
	@(posedge hclk) begin
		if (line_state == 2'b00) eop_state <= 1'b1;
		else eop_state <= 1'b0;
		if (ddrx_valid) begin
			$write ("%d %h\n", rx_byte_count, host_rx_byte);
			rx_byte_count <= rx_byte_count + 1;
			data_in[ii] <= host_rx_byte;
			ii <= ii + 1;
		end
	end
 end

 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk) begin
	if (packet_error | (temp != seqbit)) result = 0;
	else result = 1;
 end

 if (~result) begin
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 end

 $write ("/***** Display *****/\n");
 for (iii = 0; iii < ii; iii = iii + 1) begin
	if (iii % 16 == 0) $write ("Display\t%h ", data_in[iii]);
	else if (iii % 16 == 15) $write ("%h\n", data_in[iii]);
	else $write ("%h ", data_in[iii]);	
 end
 $write ("\n");

 @(posedge hclk) rcv <= 1'b0;
 @(posedge hclk);
 @(posedge hclk);

end
endtask

task Wait_Intr_Data;
output result;
output[7:0] in_type;
input seqbit;
reg[7:0] in_type;
integer temp;
reg escape;
integer eoi_count;
reg eop_state;
begin

 @(posedge hclk) begin
	escape <= 1'b0;
	eoi_count <= 0;
 	rx_byte_count = 0;
	eop_state <= 1'b0;
 end
 @(posedge hclk);

 while (escape == 1'b0 & line_state != 2'b10)
	@(posedge hclk) begin
		if (eoi_count == 100) escape <= 1'b1;
		else eoi_count <= eoi_count + 1;
	end
 @(posedge hclk) rcv <= 1'b1;

 while(escape == 1'b0 & ~drx_valid) @(posedge hclk);
 @(posedge hclk) $write ("\t%h\n", host_rx_byte);

 @(posedge hclk)
 if (host_rx_byte == 8'hc3) temp <= 0;
 else if (host_rx_byte == 8'h4b) temp <= 1;
 else if (host_rx_byte == 8'h5a) temp <= 2;

 while (escape == 1'b0 & (~eop_state | line_state != 2'b00) ) begin
	@(posedge hclk) begin
		if (line_state == 2'b00) eop_state <= 1'b1;
		else eop_state <= 1'b0;
		if (ddrx_valid) begin
			$write ("%d %h\n", rx_byte_count, host_rx_byte);
			rx_byte_count <= rx_byte_count + 1;
			if (rx_byte_count == 7'h01) in_type <= host_rx_byte;
		end
	end
 end
 @(posedge hclk) begin
	if (packet_error | (temp != seqbit)) result = 0;
	else result = 1;
 end

 @(posedge hclk) rcv <= 1'b0;
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);

end
endtask

task Send_Hands;
input[7:0] pid;
begin

 @(posedge hclk) begin
	tx_pid <= pid;
	tx_start <= 1'b1;
 end
 @(posedge hclk) begin
	tx_start <= 1'b0;
	hands_flag <= 1'b1;
 end

 while (~dtx_ready) @(posedge hclk);
 @(posedge hclk) hands_flag <= 1'b0;

 while (line_state != 2'b00) @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);

end
endtask

task Send_Data;
input[7:0] pid;
input[6:0] data_len;
reg[6:0] data_count;
integer finish;
begin

 @(posedge hclk) begin
	tx_pid <= pid;
	tx_start <= 1'b1;
	data_count <= 7'h00;
 end
 @(posedge hclk) begin
	tx_data_len <= data_len;
	tx_start <= 1'b0;
	finish <= 0;
	tx_byte <= host_mem[data_count];
 end
 @(posedge hclk)
 if (data_count == data_len) finish <= 1;

 @(posedge hclk) data_count <= data_count + 1;

 while (finish != 1) begin
	@(posedge hclk)
	if (data_count == data_len) finish = 1;
	else if (dtx_ready) begin
		tx_byte <= host_mem[data_count];
		data_count <= data_count + 1;
	end
 end
 @(posedge hclk);

 while (line_state != 2'b00) @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);

end
endtask

task data_out_tran;
input dlength;
integer dlength;
reg complete;
integer dlen;
integer data_loop;
reg hands_result;
integer di;
begin
 @(posedge hclk)
	complete <= 1'b0;
	data_loop <= 0;
 @(posedge hclk);

 while (complete == 0) begin

	Send_Token (`OUT, device_addr, 4'h3);
	$display($time,,"BULK OUT TOKEN TRANSACTION");

	@(posedge hclk)
		if (dlength > (data_loop + 1) * 64) dlen = 64;
		else dlen = dlength - data_loop * 64;
	@(posedge hclk)
		for (di = 0; di < dlen; di = di + 1)
			host_mem[di] = data_mem[data_loop * 64 + di];
	@(posedge hclk);

	if (e3_seq) Send_Data(`DATA1, dlen);
	else Send_Data(`DATA0, dlen);
	$display($time,,"BULK OUT DATA TRANSACTION");
	@(posedge hclk);

	Wait_Hands(hands_result);

	if (hands_result == 0) begin
		$display($time,,"BULK OUT DATA TRANSACTION FAIL");
	end
	else if (hands_result == 1) begin
		data_loop = data_loop + 1;
		e3_seq <= ~e3_seq;
		$display($time,,"BULK OUT DATA ACK TRANSATION");
	end	

	@(posedge hclk)
		if (hands_result & (dlength <= data_loop * 64)) complete <= 1;
	@(posedge hclk);
	@(posedge hclk);

 end

end
endtask

task intr_tran;
output result;
reg[7:0] result;
integer k;
reg hands_result;
integer di;
begin
 @(posedge hclk);

 Send_Token (`IN, device_addr, 4'h1);
 $display($time,,"INTRRUPT IN TOKEN TRANSACTION");

 @(posedge hclk);
 @(posedge hclk);
 Wait_Intr_Data(k, result, e1_seq);
 $display($time,,"INTRRUPT IN TRANSACTION DATA");
 @(posedge hclk);
 @(posedge hclk);

 if (k == 0) $display($time,,"INTRRUPT IN TRANSACTION FAIL");
 else if (k == 1) begin
 	Send_Hands(`ACK);

 	@(posedge hclk) e1_seq <= ~e1_seq;
	$display($time,,"INTRRUPT IN TRANSACTION HANDS");
 end

 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);

end
endtask

task data_in_tran;
reg complete;
reg hands_result;
reg k;
reg dk;
integer num_packet;
reg[15:0] r_data_cnt;
begin
 @(posedge hclk) complete <= 1'b0;
	num_packet = 0;
	dk <= 0;
	r_data_cnt = 0;
 @(posedge hclk);

 while (complete == 0) begin

	Send_Token (`IN, device_addr, 4'h2);
	$display($time,,"BULK IN TOKEN TRANSACTION");

	@(posedge hclk);
	Wait_in_Data(k, e2_seq, r_data_cnt);
	$display($time,,"BULK IN DATA TRANSACTION");
	@(posedge hclk);
	@(posedge hclk);
	
	if (k == 1) begin
		Send_Hands(`ACK);

		e2_seq <= ~e2_seq;
		$display($time,,"BULK IN DATA ACK TRANACTION");
	end
	else begin
		$display($time,,"BULK IN DATA TRANSACTION FAIL");
	end

	@(posedge hclk) if (k == 1) begin
						dk <= 0;
						num_packet <= num_packet + 1;
						r_data_cnt[15:6] <= r_data_cnt[15:6] + 1;
					end
	@(posedge hclk)
		if (k == 0) begin
			if (dk == 0) dk <= 1;
			else complete <= 1;
		end
		else if (rx_byte_count < 7'h41 | num_packet == 14) complete <= 1;
	@(posedge hclk);
	@(posedge hclk);
	@(posedge hclk);

 end

end
endtask

task sof_tran;
begin

 @(posedge hclk) begin
	tx_pid <= 8'ha5;
	tx_start <= 1'b1;
 end
 @(posedge hclk) begin
	tx_start <= 1'b0;
	token_flag <= 1'b1;
	tx_data_len <= 7'h02;
 	tx_byte <= 8'hff;
 end

 while (~dtx_ready) @(posedge hclk);
 tx_byte[2:0] <= 3'h5;
 @(posedge hclk);

 while (~dtx_ready) @(posedge hclk);
 @(posedge hclk);

 while (~dtx_ready) @(posedge hclk);
 @(posedge hclk) token_flag <= 1'b0;

 while (line_state != 2'b00) @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);
 @(posedge hclk);

end
endtask
