///////////////////////////////////////////////////////////////////////////
// TASKS for USB2.0
///////////////////////////////////////////////////////////////////////////

task usb2_send_token;
input   [7:0]  token;
input   [6:0]  addr;
input   [3:0]  endp;
reg            crc_bit;
reg     [3:0]  crc_cnt;
reg     [4:0]  crc5;
begin

  crc5 = 5'h1f;
  for (crc_cnt = 0; crc_cnt < 11; crc_cnt = crc_cnt + 1) begin
    if (crc_cnt < 7) crc_bit = crc5[4] ^ addr[crc_cnt];
    else crc_bit = crc5[4] ^ endp[crc_cnt-7];

    if (crc_bit) crc5 = {crc5[3:0],1'b0} ^ 5'b0_0101;
    else crc5 = {crc5[3:0],1'b0};
  end
  crc5 = {~crc5[0],~crc5[1],~crc5[2],~crc5[3],~crc5[4]};

  @(posedge clk_usb);
  @(posedge clk_usb);
  @(posedge clk_usb);
  @(posedge clk_usb);
  @(posedge clk_usb);
  rx_active = 1;

  @(posedge clk_usb);
  if (dbus16) begin
    @(posedge clk_usb);
    rx_valid = 1;
    rxvalid_h = 1;
    rx_ldata = token;
    rx_hdata = {endp[0],addr};

    @(posedge clk_usb);
    rxvalid_h = 0;
    rx_ldata = {crc5,endp[3:1]};
  end
  else begin
    @(posedge clk_usb);
    rx_valid = 1;
    rx_ldata = token;

    @(posedge clk_usb);
    rx_ldata = {endp[0],addr};

    @(posedge clk_usb);
    rx_ldata = {crc5,endp[3:1]};
  end

  @(posedge clk_usb);
  rx_active = 0;
  rx_valid = 0;

end
endtask


task usb2_send_data;
input          seq_bit;
input  [15:0]  length;
input  [15:0]  total_loop;
reg     [7:0]  cur_byte;
reg            crc_bit;
reg     [3:0]  bit_cnt;
reg    [15:0]  byte_cnt;
reg    [15:0]  crc16;
begin

  crc16 = 16'hffff;
  for (byte_cnt = 0; byte_cnt < length; byte_cnt = byte_cnt + 1) begin
    cur_byte = usb_rxdata[512*total_loop + byte_cnt];

    for (bit_cnt = 0; bit_cnt < 8; bit_cnt = bit_cnt + 1) begin
      crc_bit = crc16[15] ^ cur_byte[bit_cnt];

      if (crc_bit) crc16 = {crc16[14:0],1'b0} ^ 16'b1000_0000_0000_0101;
      else crc16 = {crc16[14:0],1'b0};
    end
  end
  crc16 = { ~crc16[0], ~crc16[1], ~crc16[2], ~crc16[3],
            ~crc16[4], ~crc16[5], ~crc16[6], ~crc16[7],
            ~crc16[8], ~crc16[9],~crc16[10],~crc16[11],
           ~crc16[12],~crc16[13],~crc16[14],~crc16[15]};

  @(posedge clk_usb);
  @(posedge clk_usb);
  @(posedge clk_usb);
  @(posedge clk_usb);
  @(posedge clk_usb);
  rx_active = 1;

  @(posedge clk_usb);
  if (dbus16) begin
    @(posedge clk_usb);
    rx_valid = 1;
    rxvalid_h = 1;
    if (seq_bit) rx_ldata = 8'h4b;
    else rx_ldata = 8'hc3;
    if (length == 0) rx_hdata = crc16[7:0];
    else rx_hdata = usb_rxdata[512*total_loop + 0];

    for (byte_cnt = 1; byte_cnt < length; byte_cnt = byte_cnt + 2) begin
      @(posedge clk_usb);
      rx_ldata = usb_rxdata[512*total_loop + byte_cnt];
      if (byte_cnt+1 == length) rx_hdata = crc16[7:0];
      else rx_hdata = usb_rxdata[512*total_loop + byte_cnt+1];
    end

    @(posedge clk_usb);
    if (byte_cnt == length) begin
      rx_ldata = crc16[7:0];
      rx_hdata = crc16[15:8];
    end
    else begin
      rxvalid_h = 0;
      rx_ldata = crc16[15:8];
    end

  end
  else begin
    @(posedge clk_usb);
    rx_valid = 1;
    if (seq_bit) rx_ldata = 8'h4b;
    else rx_ldata = 8'hc3;

    for (byte_cnt = 0; byte_cnt < length; byte_cnt = byte_cnt + 1) begin
      @(posedge clk_usb);
      rx_ldata = usb_rxdata[512*total_loop + byte_cnt];
    end

    @(posedge clk_usb);
    rx_ldata = crc16[7:0];

    @(posedge clk_usb);
    rx_ldata = crc16[15:8];

  end

  @(posedge clk_usb);
  rx_active = 0;
  rx_valid = 0;

end
endtask


task usb2_wait_hands;
reg     [6:0]  eoi_cnt;
reg     [7:0]  received_hands;
begin

  eoi_cnt = 0;

  while (!tx_valid) begin
    @(posedge clk_usb)
    eoi_cnt = eoi_cnt + 1;

    if ((dbus16 & eoi_cnt > 48) | (!dbus16 & eoi_cnt > 96)) begin
      $display ("BUS TURN AROUND TIME OUT !!!");
      $stop;
    end

  end

  @(posedge clk_usb);
  if (tx_valid) begin
    tx_ready = 1;
    rx_hands = usb_ldata;
  end

  @(posedge clk_usb);
  tx_ready = 0;

end
endtask

task usb2_wait_data;
input          seq_bit;
reg     [4:0]  eoi_cnt;
reg     [7:0]  cur_byte;
reg            crc_bit;
reg     [3:0]  bit_cnt;
reg    [15:0]  byte_cnt;
reg    [15:0]  crc_cnt;
reg    [15:0]  crc16;
begin

  eoi_cnt = 0;
  rx_nack = 0;

  while (!tx_valid) begin
    @(posedge clk_usb)
    eoi_cnt = eoi_cnt + 1;

    if (eoi_cnt > 16) begin
      $display ("BUS TURN AROUND TIME OUT !!!");
      $stop;
    end

  end

  @(posedge clk_usb);
  tx_ready = 1;

  @(posedge clk_usb);
  tx_ready = 1;
  if (usb_ldata == 8'h5a) begin
    rx_nack = 1;
    $display ("RECEIVED NACK");
  end
  else begin
    if (seq_bit & usb_ldata !== 8'h4b) begin
      $display ("DATA SEQUENCE BIT ERROR !!!");
      $stop;
    end
    if (!seq_bit & usb_ldata !== 8'hc3) begin
      $display ("DATA SEQUENCE BIT ERROR !!!");
      $stop;
    end
    if (dbus16 & valid_h) begin
      byte_cnt = 1;
      usb_txdata[0] = usb_hdata;
    end
    else byte_cnt = 0;
  end

  while (!rx_nack && tx_valid) begin
    @(posedge clk_usb);
    tx_ready = 1;
    if (dbus16 & valid_h) begin
      usb_txdata[byte_cnt] = usb_ldata;
      byte_cnt = byte_cnt + 1;
      usb_txdata[byte_cnt] = usb_hdata;
    end
    else usb_txdata[byte_cnt] = usb_ldata;
    byte_cnt = byte_cnt + 1;
  end
  tx_ready = 0;
  byte_cnt = byte_cnt - 1;

  @(posedge clk_usb);
  crc16 = 16'hffff;
  for (crc_cnt = 0; crc_cnt < byte_cnt; crc_cnt = crc_cnt + 1) begin
    cur_byte = usb_txdata[crc_cnt];

    for (bit_cnt = 0; bit_cnt < 8; bit_cnt = bit_cnt + 1) begin
      crc_bit = crc16[15] ^ cur_byte[bit_cnt];

      if (crc_bit) crc16 = {crc16[14:0],1'b0} ^ 16'b1000_0000_0000_0101;
      else crc16 = {crc16[14:0],1'b0};
    end
  end

  if (!rx_nack) begin
    if (crc16 !== 16'h800d) begin
      $display ("DATA CRC ERROR !!!");
      $stop;
    end
    tx_length = byte_cnt - 2;

    $display ("USB IN DATA LENGTH: %d", tx_length);
    if (tx_length < 64) begin
    for (crc_cnt = 0; crc_cnt < tx_length; crc_cnt = crc_cnt + 4) begin
      $display ("\t0x%x\t0x%x\t0x%x\t0x%x",
                 usb_txdata[crc_cnt+3],usb_txdata[crc_cnt+2],
                 usb_txdata[crc_cnt+1],usb_txdata[crc_cnt]);
    end
    end
  end
  
end
endtask


task usb2_send_hands;
begin

  @(posedge clk_usb);
  @(posedge clk_usb);
  @(posedge clk_usb);
  @(posedge clk_usb);
  @(posedge clk_usb);
  rx_active = 1;

  @(posedge clk_usb);
  rx_valid = 1;
  rx_ldata = 8'hd2;

  @(posedge clk_usb);
  rx_active = 0;
  rx_valid = 0;
  
end
endtask


task usb2_send_sof;
input[10:0] frame_num;
begin

  if (hspeed) begin

    usb2_send_token (`TOKEN_SOF,frame_num[6:0],frame_num[10:7]);

  end
  else begin

    usb2f_send_token (`TOKEN_SOF,frame_num[6:0],frame_num[10:7]);

  end

end
endtask


task usb2_setup_tran;
input   [7:0]  bm_reqtype;
input   [7:0]  b_request;
input  [15:0]  w_value;
input  [15:0]  w_index;
input  [15:0]  w_length;
input  [15:0]  length;
begin

  usb_rxdata[0] = bm_reqtype;
  usb_rxdata[1] = b_request;
  usb_rxdata[2] = w_value[7:0];
  usb_rxdata[3] = w_value[15:8];
  usb_rxdata[4] = w_index[7:0];
  usb_rxdata[5] = w_index[15:8];
  usb_rxdata[6] = w_length[7:0];
  usb_rxdata[7] = w_length[15:8];

  if (hspeed) begin
    usb2_send_token (`TOKEN_SETUP,device_addr,4'h0);
    usb2_send_data (e0_seqbit,length,16'h0);
    usb2_wait_hands;
  end
  else begin
    usb2f_send_token (`TOKEN_SETUP,device_addr,4'h0);
    usb2f_send_data (e0_seqbit,length,16'h0);
    usb2f_wait_hands;
  end

end
endtask


task usb2_din_tran;
input          seq_bit;
input   [3:0]  endp;
begin

  if (hspeed) begin
    usb2_send_token (`TOKEN_IN,device_addr,endp);
    usb2_wait_data (seq_bit);
  end
  else begin
    usb2f_send_token (`TOKEN_IN,device_addr,endp);
    usb2f_wait_data (seq_bit);
  end

  if (!rx_nack) usb2_send_hands;

end
endtask


task usb2_dout_tran;
input          seq_bit;
input   [3:0]  endp;
input  [15:0]  length;
input  [15:0]  total_loop;
begin

  if (hspeed) begin
    usb2_send_token (`TOKEN_OUT,device_addr,endp);
    usb2_send_data (seq_bit,length,total_loop);
    usb2_wait_hands;
  end
  else begin
    usb2f_send_token (`TOKEN_OUT,device_addr,endp);
    usb2f_send_data (seq_bit,length,total_loop);
    usb2f_wait_hands;
  end

end
endtask

task usb2_ping;
input   [3:0]  endp;
begin

  if (hspeed) begin
    usb2_send_token (`TOKEN_PING,device_addr,endp);
    usb2_wait_hands;
  end
  else begin
    rx_hands = 8'hd2;
  end

end
endtask

task usb2f_send_token;
input   [7:0]  token;
input   [6:0]  addr;
input   [3:0]  endp;
reg            crc_bit;
reg     [3:0]  crc_cnt;
reg     [4:0]  crc5;
reg     [2:0]  bit_cnt;
begin

  crc5 = 5'h1f;
  for (crc_cnt = 0; crc_cnt < 11; crc_cnt = crc_cnt + 1) begin
    if (crc_cnt < 7) crc_bit = crc5[4] ^ addr[crc_cnt];
    else crc_bit = crc5[4] ^ endp[crc_cnt-7];

    if (crc_bit) crc5 = {crc5[3:0],1'b0} ^ 5'b0_0101;
    else crc5 = {crc5[3:0],1'b0};
  end
  crc5 = {~crc5[0],~crc5[1],~crc5[2],~crc5[3],~crc5[4]};

  @(posedge clk_usb);
  @(posedge clk_usb);
  @(posedge clk_usb);
  @(posedge clk_usb);
  @(posedge clk_usb);
  rx_active = 1;
  line_state1 = 1'b1;
  line_state0 = 1'b0;

  @(posedge clk_usb);
  if (dbus16) begin
    @(posedge clk_usb);
    rx_valid = 1;
    rxvalid_h = 1;
    rx_ldata = token;
    rx_hdata = {endp[0],addr};

    @(posedge clk_usb);
    rx_valid = 0;
    rxvalid_h = 0;
    repeat (6) @(posedge clk_usb);

    @(posedge clk_usb);
    rx_valid = 1;
    rxvalid_h = 0;
    rx_ldata = {crc5,endp[3:1]};
    @(posedge clk_usb);
    rx_valid = 0;
    repeat (6) @(posedge clk_usb);
  end
  else begin
    @(posedge clk_usb);
    rx_valid = 1;
    rx_ldata = token;
    @(posedge clk_usb);
    rx_valid = 0;
    repeat (6) @(posedge clk_usb);

    @(posedge clk_usb);
    rx_valid = 1;
    rx_ldata = {endp[0],addr};
    @(posedge clk_usb);
    rx_valid = 0;
    repeat (6) @(posedge clk_usb);

    @(posedge clk_usb);
    rx_valid = 1;
    rx_ldata = {crc5,endp[3:1]};
    @(posedge clk_usb);
    rx_valid = 0;
    repeat (6) @(posedge clk_usb);
  end

  @(posedge clk_usb);
  rx_active = 0;
  rx_valid = 0;
  line_state1 = 1'b0;
  line_state0 = 1'b1;

end
endtask

task usb2f_send_data;
input          seq_bit;
input  [15:0]  length;
input  [15:0]  total_loop;
reg     [7:0]  cur_byte;
reg            crc_bit;
reg     [3:0]  bit_cnt;
reg    [15:0]  byte_cnt;
reg    [15:0]  crc16;
begin

  crc16 = 16'hffff;
  for (byte_cnt = 0; byte_cnt < length; byte_cnt = byte_cnt + 1) begin
    cur_byte = usb_rxdata[64*total_loop + byte_cnt];

    for (bit_cnt = 0; bit_cnt < 8; bit_cnt = bit_cnt + 1) begin
      crc_bit = crc16[15] ^ cur_byte[bit_cnt];

      if (crc_bit) crc16 = {crc16[14:0],1'b0} ^ 16'b1000_0000_0000_0101;
      else crc16 = {crc16[14:0],1'b0};
    end
  end
  crc16 = { ~crc16[0], ~crc16[1], ~crc16[2], ~crc16[3],
            ~crc16[4], ~crc16[5], ~crc16[6], ~crc16[7],
            ~crc16[8], ~crc16[9],~crc16[10],~crc16[11],
           ~crc16[12],~crc16[13],~crc16[14],~crc16[15]};

  @(posedge clk_usb);
  @(posedge clk_usb);
  @(posedge clk_usb);
  @(posedge clk_usb);
  @(posedge clk_usb);
  rx_active = 1;

  @(posedge clk_usb);
  if (dbus16) begin
    @(posedge clk_usb);
    rx_valid = 1;
    rxvalid_h = 1;
    if (seq_bit) rx_ldata = 8'h4b;
    else rx_ldata = 8'hc3;
    if (length == 0) rx_hdata = crc16[7:0];
    else rx_hdata = usb_rxdata[64*total_loop + 0];
    @(posedge clk_usb);
    rx_valid = 0;
    rxvalid_h = 0;
    repeat (6) @(posedge clk_usb);

    for (byte_cnt = 1; byte_cnt < length; byte_cnt = byte_cnt + 2) begin
      @(posedge clk_usb);
      rx_valid = 1;
      rxvalid_h = 1;
      rx_ldata = usb_rxdata[64*total_loop + byte_cnt];
      if (byte_cnt+1 == length) rx_hdata = crc16[7:0];
      else rx_hdata = usb_rxdata[64*total_loop + byte_cnt+1];
      @(posedge clk_usb);
      rx_valid = 0;
      rxvalid_h = 0;
      repeat (6) @(posedge clk_usb);
    end

    @(posedge clk_usb);
    rx_valid = 1;
    if (byte_cnt == length) begin
      rxvalid_h = 1;
      rx_ldata = crc16[7:0];
      rx_hdata = crc16[15:8];
    end
    else begin
      rxvalid_h = 0;
      rx_ldata = crc16[15:8];
    end
    @(posedge clk_usb);
    rx_valid = 0;
    rxvalid_h = 0;
    repeat (6) @(posedge clk_usb);
  end
  else begin
    @(posedge clk_usb);
    rx_valid = 1;
    if (seq_bit) rx_ldata = 8'h4b;
    else rx_ldata = 8'hc3;
    @(posedge clk_usb);
    rx_valid = 0;
    repeat (6) @(posedge clk_usb);

    for (byte_cnt = 0; byte_cnt < length; byte_cnt = byte_cnt + 1) begin
      @(posedge clk_usb);
      rx_valid = 1;
      rx_ldata = usb_rxdata[64*total_loop + byte_cnt];
      @(posedge clk_usb);
      rx_valid = 0;
      repeat (6) @(posedge clk_usb);
    end

    @(posedge clk_usb);
    rx_valid = 1;
    rx_ldata = crc16[7:0];
    @(posedge clk_usb);
    rx_valid = 0;
    repeat (6) @(posedge clk_usb);

    @(posedge clk_usb);
    rx_valid = 1;
    rx_ldata = crc16[15:8];
    @(posedge clk_usb);
    rx_valid = 0;
    repeat (6) @(posedge clk_usb);
  end

  @(posedge clk_usb);
  rx_active = 0;
  rx_valid = 0;

end
endtask


task usb2f_wait_hands;
reg     [9:0]  eoi_cnt;
reg     [7:0]  received_hands;
begin

  eoi_cnt = 0;

  while (!tx_valid) begin
    @(posedge clk_usb)
    eoi_cnt = eoi_cnt + 1;

    if ((dbus16 & eoi_cnt > 384) | (!dbus16 & eoi_cnt > 768)) begin
      $display ("BUS TURN AROUND TIME OUT !!!");
      $stop;
    end

  end

  @(posedge clk_usb);
  if (tx_valid) begin
    tx_ready = 1;
    rx_hands = usb_ldata;
  end

  @(posedge clk_usb);
  tx_ready = 0;

end
endtask

task usb2f_wait_data;
input          seq_bit;
reg     [4:0]  eoi_cnt;
reg     [7:0]  cur_byte;
reg            crc_bit;
reg     [3:0]  bit_cnt;
reg    [15:0]  byte_cnt;
reg    [15:0]  crc_cnt;
reg    [15:0]  crc16;
begin

  eoi_cnt = 0;
  rx_nack = 0;

  while (!tx_valid) begin
    @(posedge clk_usb)
    eoi_cnt = eoi_cnt + 1;

    if (eoi_cnt > 16) begin
      $display ("BUS TURN AROUND TIME OUT !!!");
      $stop;
    end

  end

  @(posedge clk_usb);
  tx_ready = 1;

  @(posedge clk_usb);
  if (usb_ldata == 8'h5a) begin
    rx_nack = 1;
    $display ("RECEIVED NACK");
  end
  else begin
    if (seq_bit & usb_ldata !== 8'h4b) begin
      $display ("DATA SEQUENCE BIT ERROR !!!");
      $stop;
    end
    if (!seq_bit & usb_ldata !== 8'hc3) begin
      $display ("DATA SEQUENCE BIT ERROR !!!");
      $stop;
    end
    if (dbus16 & valid_h) begin
      byte_cnt = 1;
      usb_txdata[0] = usb_hdata;
    end
    else byte_cnt = 0;
  end
  tx_ready = 0;
  repeat (7) @(posedge clk_usb);
  tx_ready = 1;

  while (!rx_nack && tx_valid) begin
    @(posedge clk_usb);
    if (dbus16 & valid_h) begin
      usb_txdata[byte_cnt] = usb_ldata;
      byte_cnt = byte_cnt + 1;
      usb_txdata[byte_cnt] = usb_hdata;
    end
    else usb_txdata[byte_cnt] = usb_ldata;
    byte_cnt = byte_cnt + 1;
    tx_ready = 0;
    repeat (7) @(posedge clk_usb);
    tx_ready = 1;
  end
  tx_ready = 0;

  @(posedge clk_usb);
  crc16 = 16'hffff;
  for (crc_cnt = 0; crc_cnt < byte_cnt; crc_cnt = crc_cnt + 1) begin
    cur_byte = usb_txdata[crc_cnt];

    for (bit_cnt = 0; bit_cnt < 8; bit_cnt = bit_cnt + 1) begin
      crc_bit = crc16[15] ^ cur_byte[bit_cnt];

      if (crc_bit) crc16 = {crc16[14:0],1'b0} ^ 16'b1000_0000_0000_0101;
      else crc16 = {crc16[14:0],1'b0};
    end
  end

  if (!rx_nack) begin
    if (crc16 !== 16'h800d) begin
      $display ("DATA CRC ERROR !!!");
      $stop;
    end
    tx_length = byte_cnt - 2;

    $display ("USB IN DATA LENGTH: %d", tx_length);
    if (tx_length < 64) begin
    for (crc_cnt = 0; crc_cnt < tx_length; crc_cnt = crc_cnt + 4) begin
      $display ("\t0x%x\t0x%x\t0x%x\t0x%x",
                 usb_txdata[crc_cnt+3],usb_txdata[crc_cnt+2],
                 usb_txdata[crc_cnt+1],usb_txdata[crc_cnt]);
    end
    end
  end
  
end
endtask
