// ************************************************************************
// USB device TX line controller
//
// start: 2003. 05. 30
// by jeonghe
//
// ************************************************************************

module txline_ctrl (
  clk_usb,        // USB clock
  rst_usb,        // Main reset

  tx_ready,       // TX data ready
  tx_valid,       // TX valid
  txvalid_h,      // TX valid high
  tx_data,        // TX data

  pseq_bit,       // Endpoint sequence bit
  pwait_status,   // Wait status transaction
  psend_nack,     // Send NACK
  psend_ack,      // Send ACK
  psend_stall,    // Send STALL
  psend_nyet,     // Send NYET
  psend_data,     // Send data
  pdrive_chirp,   // Drive chirp in high speed mode

  endp,           // Current enpoint
  pe1_valid,      // Endpoint1 valid
  pe0_txlen,      // Endpoint0 TX data length
  pe1_txlen,      // Endpoint1 TX data length
  pe2_txlen,      // Endpoint2 TX data length
  crc_result,     // CRC result
  ptx_word,       // Word to send
  txpid_field,    // TX pid
  txcrc_field,    // TX CRC
  ptx_read,       // TX data read request
  tx_bcnt,        // TX byte count
  txcrc_in,       // TX CRC input
  txcrc_hvalid,   // TX CRC high byte valid

  dbus16          // 1: 16bytes bus for data
);

input          clk_usb;
input          rst_usb;

input          tx_ready;
output         tx_valid;
output         txvalid_h;
output [15:0]  tx_data;

input          pseq_bit;
input          pwait_status;
input          psend_nack;
input          psend_ack;
input          psend_stall;
input          psend_nyet;
input          psend_data;
input          pdrive_chirp;

input   [3:0]  endp;
input          pe1_valid;
input   [6:0]  pe0_txlen;
input   [6:0]  pe1_txlen;
input   [9:0]  pe2_txlen;
input  [15:0]  crc_result;
input  [31:0]  ptx_word;
output         txpid_field;
output         txcrc_field;
output         ptx_read;
output  [9:0]  tx_bcnt;
output [15:0]  txcrc_in;
output         txcrc_hvalid;

input          dbus16;


wire tx_end;
reg  txpid_field;

reg[9:0] txdata_len;
wire[9:0] p1_txdata_len = txdata_len + 1;
always @(endp or pwait_status or pe0_txlen or pe1_txlen or pe2_txlen) 
  case (endp)          // synopsys full_case parallel_case
    0: txdata_len = pwait_status ? 10'h000 : pe0_txlen;
    1: txdata_len = pe1_txlen;
    default: txdata_len = pe2_txlen;
  endcase
wire txzero_len = txdata_len == 10'h000;

// TX field
reg[2:0] tx_field;
always @(posedge clk_usb or posedge rst_usb)
  if (rst_usb) tx_field <= 3'h0;
  else if (tx_end) tx_field <= 3'h0;
  else begin
    if (psend_ack) tx_field <= 3'h1;
    if (psend_stall) tx_field <= 3'h2;
    if (psend_data) tx_field <= 3'h3;
    if (psend_nack) tx_field <= 3'h4;
    if (psend_nyet) tx_field <= 3'h5;
  end

wire tx_start = (psend_nack | psend_ack | psend_stall |
                 psend_data | psend_nyet);

reg dtx_start;
always @(posedge clk_usb) dtx_start <= tx_start;

wire tx_valid = pdrive_chirp | (~dtx_start & tx_field != 3'h0);

// TX byte counter
reg[9:0] tx_bcnt;
wire[9:0] p1_tx_bcnt = tx_bcnt + 1;
wire[9:0] p2_tx_bcnt = p1_tx_bcnt + 1;
always @(posedge clk_usb or posedge rst_usb)
  if (rst_usb) tx_bcnt <= 10'h000;
  else if (tx_start) tx_bcnt <= 10'h000;
  else if (tx_ready) begin
    if (txvalid_h) begin
      if (txpid_field) tx_bcnt <= p1_tx_bcnt;
      else tx_bcnt <= p2_tx_bcnt;
    end
    else if (!txpid_field) tx_bcnt <= p1_tx_bcnt;
  end

wire t_ptx_read = tx_ready &
                  (txvalid_h ? tx_bcnt[1:0] == 1 : tx_bcnt[1:0] == 2);
wire ptx_read = dtx_start | t_ptx_read;

reg dtx_read;
always @(posedge clk_usb) dtx_read <= ptx_read;

wire data_field  = psend_data  | tx_field == 3'h3;

wire[9:0] t_ptx_bcnt = dbus16 ? p1_tx_bcnt : tx_bcnt;
wire ptx_end = data_field ?
               (~txpid_field & (t_ptx_bcnt > txdata_len)) : tx_ready;
assign tx_end = tx_ready & ptx_end;

assign txvalid_h = dbus16 & tx_valid & 
                   (pdrive_chirp | (data_field & (tx_bcnt < p1_txdata_len)));

// PID field
always @(posedge clk_usb or posedge rst_usb)
  if (rst_usb) txpid_field <= 1'b1;
  else if (tx_end) txpid_field <= 1'b1;
  else if (tx_ready) txpid_field <= 1'b0;

// TX CRC
wire txcrc_field = dbus16 ?
                   txzero_len | (~txpid_field & (p2_tx_bcnt > txdata_len)) :
                   ~txpid_field & (p1_tx_bcnt > txdata_len);

reg[31:0] tx_word;

reg txcrc_cnt;
always @(posedge clk_usb)
  if (tx_ready) begin
    if (txcrc_field) txcrc_cnt <= 1'b1;
    else txcrc_cnt <= 1'b0;
  end

reg[7:0] tx_pid;
always @(posedge clk_usb) begin
  if (psend_ack) tx_pid <= 8'hd2;
  if (psend_stall) tx_pid <= 8'h1e;
  if (psend_nack) tx_pid <= 8'h5a;
  if (psend_nyet) tx_pid <= 8'h96;
  if (psend_data) begin
    if (pseq_bit) tx_pid <= 8'h4b;
    else tx_pid <= 8'hc3;
  end
end

wire[15:0] pcrc_out = {~crc_result[0], ~crc_result[1],
                       ~crc_result[2], ~crc_result[3],
                       ~crc_result[4], ~crc_result[5],
                       ~crc_result[6], ~crc_result[7],
                       ~crc_result[8], ~crc_result[9],
                       ~crc_result[10],~crc_result[11],
                       ~crc_result[12],~crc_result[13],
                       ~crc_result[14],~crc_result[15]};

// TX data
always @(posedge clk_usb)
  if (endp == 1) begin
    if (pe1_valid) tx_word <= 32'haaaa_5555;
    else tx_word <= 32'h5555_aaaa;
  end
  else if (dtx_read) tx_word <= ptx_word;

reg[7:0] dtx_data;
always @(posedge clk_usb)
  if (dtx_read) dtx_data <= tx_word[31:24];

reg[15:0] tx_data;
always @(pdrive_chirp or txpid_field or tx_pid or tx_bcnt or
  tx_word or ptx_word or txcrc_field or txcrc_cnt or pcrc_out or
  dtx_data or dtx_read or ptx_end or dbus16)
  if (pdrive_chirp) tx_data = 16'h0000;
  else if (txpid_field) begin
    if (txcrc_field) tx_data = {pcrc_out[7:0],tx_pid};
    else tx_data = {tx_word[7:0],tx_pid};
  end
  else if (txcrc_field) begin
    if (txcrc_cnt) tx_data = {pcrc_out[7:0],pcrc_out[15:8]};
    else if (ptx_end | !dbus16) tx_data = pcrc_out;
    else begin
      case (tx_bcnt[1:0])         // synopsys full_case parallel_case
        0: tx_data = {pcrc_out[7:0],tx_word[7:0]};
        1: tx_data = {pcrc_out[7:0],tx_word[15:8]};
        2: tx_data = {pcrc_out[7:0],tx_word[23:16]};
        default: tx_data = dtx_read ? {pcrc_out[7:0],tx_word[31:24]} :
                                      {pcrc_out[7:0],dtx_data};
      endcase
    end
  end
  else begin
    case (tx_bcnt[1:0])         // synopsys full_case parallel_case
      0: tx_data = tx_word[15:0];
      1: tx_data = tx_word[23:8];
      2: tx_data = tx_word[31:16];
      default: tx_data = dtx_read ? {ptx_word[7:0],tx_word[31:24]} :
                                    {tx_word[7:0],dtx_data};
    endcase
  end

reg[15:0] txcrc_in;
always @(dbus16 or txpid_field or tx_bcnt or dtx_read or ptx_word or tx_word or tx_data)
  if (dbus16) begin
    if (txpid_field) txcrc_in = tx_word[15:0];
    else if (tx_bcnt[1:0] == 1) txcrc_in = tx_word[31:16];
    else txcrc_in = dtx_read ? ptx_word[15:0] : tx_word[15:0];
  end
  else txcrc_in = tx_data;

wire[9:0] ptxcrc_bcnt = txpid_field ? p1_tx_bcnt : p2_tx_bcnt;
wire txcrc_hvalid = dbus16 & (ptxcrc_bcnt < txdata_len);



endmodule
