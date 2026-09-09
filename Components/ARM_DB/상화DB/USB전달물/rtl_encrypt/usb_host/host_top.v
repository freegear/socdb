module host_top (dp, dm,
	dtx_ready, drx_valid, rx_byte, line_state, packet_error, phuclk,
	hclk, hreset, hureset,
	tx_start, tx_data_len, tx_pid, token_flag, hands_flag, tx_byte, rcv);

inout dp;
inout dm;

output dtx_ready;
output drx_valid;
output[7:0] rx_byte;
output[1:0] line_state;
output packet_error;
output phuclk;

input hclk;
input hreset;
input hureset;
input tx_start;
input[6:0] tx_data_len;
input[7:0] tx_pid;
input token_flag;
input hands_flag;
input[7:0] tx_byte;
input rcv;

wire[7:0] tx_data;
wire[7:0] rx_data;

host_usb_pad host_usb_pad (dp, dm, poeb, txdp, txdm, rxd, rxdp, rxdm);

host_sie host_sie (tx_data, tx_valid, dtx_ready, drx_valid, rx_byte,
	packet_error,
	hclk, hreset, rx_data, rx_active, rx_valid, rx_error,
	tx_ready, tx_data_len, tx_start, tx_pid, token_flag, hands_flag, tx_byte);

host_tranceiver host_tranceiver (txdp, txdm, poeb,
	rx_active, rx_valid, rx_data, rx_error, line_state, tx_ready, phuclk,
	hclk, hreset, hureset, tx_data, tx_valid,
	rxd, rxdp, rxdm);

endmodule
