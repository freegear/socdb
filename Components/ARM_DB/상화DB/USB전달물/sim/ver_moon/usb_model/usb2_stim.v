///////////////////////////////////////////////////////////////////////////
// USB2 host model
///////////////////////////////////////////////////////////////////////////
`define TOKEN_SETUP        8'h2d
`define TOKEN_SOF          8'ha5
`define TOKEN_IN           8'h69
`define TOKEN_OUT          8'he1
`define TOKEN_PING         8'hb4

integer     proc_num;
integer     dchirp_cnt;
integer     loop_cnt;
integer     tloop_cnt;
integer     rand_seed;
reg [10:0]  frame_num;
reg  [7:0]  usb_rxdata[2000:0];
reg  [7:0]  usb_txdata[2000:0];
reg         e0_seqbit;
reg         e1_seqbit;
reg         e2_seqbit;
reg         e3_seqbit;
reg  [6:0]  device_addr;
reg  [7:0]  rx_hands;
reg         rx_nack;
reg [15:0]  rx_length;
reg [15:0]  tx_length;
reg [15:0]  tx_tlength;

initial begin
  proc_num = 0;
  frame_num = 0;
  rand_seed = 100;
end

`include "./usb_model/usb2_task.v"

always begin

  if (proc_num == 0) begin
    if (hspeed) begin
      line_state1 = 1'b0;
      line_state0 = 1'b0;
    end
    else begin
      line_state1 = 1'b0;
      line_state0 = 1'b1;
    end

    #1000;
    
    @(posedge clk_usb);
    proc_num = 1;
  end

  if (proc_num == 1) begin
    @(posedge clk_usb);
    if (rst_utm) proc_num = 1;
    else proc_num = 2;
  end

  if (proc_num == 2) begin
    @(posedge clk_usb);
    if (ext_utm) begin
      if (xcvr_select & term_select) proc_num = 4;
      else proc_num = 2;
    end
    else proc_num = 200;
  end

  // Wait stable clock in high speed mode
  if (proc_num == 4) begin
    @(posedge clk_usb);
    line_state1 = 1'b0;
    line_state0 = 1'b1;
    repeat (61000) @(posedge clk_usb);
    @(posedge clk_usb);
    proc_num = 5;
  end

  // Device reset
  if (proc_num == 5) begin
    @(posedge clk_usb);
    line_state1 = 1'b0;
    line_state0 = 1'b0;
    @(posedge clk_usb);
    proc_num = 6;
  end

  if (proc_num == 6) begin
    @(posedge clk_usb);
    if (xcvr_select) proc_num = 6;
    else begin
      if (op_mode1 & !op_mode0) proc_num = 7;
      else begin
        $display ("ERROR OP_MODE !!!");
        $stop;
      end
    end
  end

  if (proc_num == 7) begin
    @(posedge clk_usb);
    if (tx_valid) begin
      dchirp_cnt = 0;
      proc_num = 8;
    end
    else proc_num = 7;
  end

  if (proc_num == 8) begin
    @(posedge clk_usb);
    if (tx_valid) begin
      if (valid_h) begin
        if (usb_hdata == 8'h00 && usb_ldata == 8'h00)
          dchirp_cnt = dchirp_cnt + 1;
      end
      else begin
        if (usb_ldata == 8'h00) dchirp_cnt = dchirp_cnt + 1; 
      end
    end
    else begin
      if (dchirp_cnt > 1000) proc_num = 9;
      else begin
        $display ("ERROR DEVICE CHIRP !!!");
        $stop;
      end
    end
  end

  if (proc_num == 9) begin
    @(posedge clk_usb);
    if (hspeed) begin
      $display ("HIGH SPEED RESET !!!");
      proc_num = 10;
    end
    else begin
      $display ("FULL SPEED RESET !!!");
      proc_num = 110;
    end
  end

  // Device chirp 'K'
  if (proc_num == 10) begin
    @(posedge clk_usb);
    dchirp_cnt = 0;
    line_state1 = 1;
    line_state0 = 0;
    proc_num = 11;
  end

  if (proc_num == 11) begin
    @(posedge clk_usb);
    if (dbus16) begin
      if (dchirp_cnt == 700) proc_num = 12;
      else proc_num = 11;
    end
    else begin
      if (dchirp_cnt == 350) proc_num = 12;
      else proc_num = 11;
    end
    dchirp_cnt = dchirp_cnt + 1;
  end

  // Device chirp 'J'
  if (proc_num == 12) begin
    @(posedge clk_usb);
    dchirp_cnt = 0;
    line_state1 = 0;
    line_state0 = 1;
    proc_num = 13;
  end

  if (proc_num == 13) begin
    @(posedge clk_usb);
    if (dbus16) begin
      if (dchirp_cnt == 700) proc_num = 14;
      else proc_num = 13;
    end
    else begin
      if (dchirp_cnt == 350) proc_num = 14;
      else proc_num = 13;
    end
    dchirp_cnt = dchirp_cnt + 1;
  end

  // Device chirp 'K'
  if (proc_num == 14) begin
    @(posedge clk_usb);
    dchirp_cnt = 0;
    line_state1 = 1;
    line_state0 = 0;
    proc_num = 15;
  end

  if (proc_num == 15) begin
    @(posedge clk_usb);
    if (dbus16) begin
      if (dchirp_cnt == 700) proc_num = 16;
      else proc_num = 15;
    end
    else begin
      if (dchirp_cnt == 350) proc_num = 16;
      else proc_num = 15;
    end
    dchirp_cnt = dchirp_cnt + 1;
  end

  // Device chirp 'J'
  if (proc_num == 16) begin
    @(posedge clk_usb);
    dchirp_cnt = 0;
    line_state1 = 0;
    line_state0 = 1;
    proc_num = 17;
  end

  if (proc_num == 17) begin
    @(posedge clk_usb);
    if (dbus16) begin
      if (dchirp_cnt == 700) proc_num = 18;
      else proc_num = 17;
    end
    else begin
      if (dchirp_cnt == 350) proc_num = 18;
      else proc_num = 17;
    end
    dchirp_cnt = dchirp_cnt + 1;
  end

  // Device chirp 'K'
  if (proc_num == 18) begin
    @(posedge clk_usb);
    dchirp_cnt = 0;
    line_state1 = 1;
    line_state0 = 0;
    proc_num = 19;
  end

  if (proc_num == 19) begin
    @(posedge clk_usb);
    if (dbus16) begin
      if (dchirp_cnt == 700) proc_num = 20;
      else proc_num = 19;
    end
    else begin
      if (dchirp_cnt == 350) proc_num = 20;
      else proc_num = 19;
    end
    dchirp_cnt = dchirp_cnt + 1;
  end

  // Device chirp 'J'
  if (proc_num == 20) begin
    @(posedge clk_usb);
    dchirp_cnt = 0;
    line_state1 = 0;
    line_state0 = 1;
    proc_num = 21;
  end

  if (proc_num == 21) begin
    @(posedge clk_usb);
    if (dbus16) begin
      if (dchirp_cnt == 700) proc_num = 22;
      else proc_num = 21;
    end
    else begin
      if (dchirp_cnt == 350) proc_num = 22;
      else proc_num = 21;
    end
    dchirp_cnt = dchirp_cnt + 1;
  end

  if (proc_num == 22) begin
    @(posedge clk_usb);
    if (term_select) proc_num = 22;
    else begin
      $display ("HIGH SPEED RESET END !!!");
      proc_num = 1000;
    end
  end

  // Bus reset
  if (proc_num == 110) begin
    repeat (10000) @(posedge clk_usb);
    @(posedge clk_usb);
    proc_num = 111;
  end

  if (proc_num == 111) begin
    @(posedge clk_usb);
    if (xcvr_select & term_select) begin
      $display ("FULL SPEED RESET SUCCESS !!!");
      proc_num = 1000;
    end
    else begin
      $display ("FULL SPEED RESET FAIL !!!");
      $stop;
    end
  end

  // Wait stable clock in full speed mode
  if (proc_num == 200) begin
    repeat (1000) @(posedge clk_usb);
    @(posedge clk_usb);
    proc_num = 201;
  end

  if (proc_num == 201) begin
    @(posedge clk_usb);
    $stop;
  end

  if (proc_num == 1000) begin
    @(posedge clk_usb);
    $display ("SEND SOF");
    usb2_send_sof (frame_num);

    @(posedge clk_usb);
    frame_num = frame_num + 1;
    proc_num = 1001;
  end

  if (proc_num == 1001) begin
    @(posedge clk_usb);
    e0_seqbit = 0;
    device_addr = 0;
    rx_length = 8;

    usb2_setup_tran (8'h80,8'h06,16'h0100,16'h0000,16'h0012,rx_length);

    @(posedge clk_usb);
    if (rx_hands == 8'hd2) begin
      e0_seqbit = 1;
      $display ("GET DESCRIPTOR DEVICE, SETUP");
      proc_num = 1002;
    end
    else proc_num = 1001;
  end

  if (proc_num == 1002) begin
    @(posedge clk_usb);

    usb2_din_tran (e0_seqbit,4'h0);

    @(posedge clk_usb);
    if (rx_nack) begin
      $display ("GET DESCRIPTOR DEVICE, DATA NACK");
      proc_num = 1002;
    end
    else begin
      $display ("GET DESCRIPTOR DEVICE, DATA");
      e0_seqbit = 1;
      proc_num = 1003;
    end
  end

  if (proc_num == 1003) begin
    @(posedge clk_usb);
    rx_length = 0;
    tloop_cnt = 0;

    usb2_dout_tran (e0_seqbit,4'h0,rx_length,tloop_cnt);

    @(posedge clk_usb);
    if (rx_hands == 8'hd2) begin
      $display ("GET DESCRIPTOR DEVICE, STATUS");
      proc_num = 1010;
    end
    else proc_num = 1000;
  end

  if (proc_num == 1010) begin
    @(posedge clk_usb);
    $display ("SEND SOF");
    usb2_send_sof (frame_num);

    @(posedge clk_usb);
    frame_num = frame_num + 1;
    proc_num = 1030;
  end

  if (proc_num == 1030) begin
    @(posedge clk_usb);
    $display ("SEND SOF");
    usb2_send_sof (frame_num);

    @(posedge clk_usb);
    frame_num = frame_num + 1;
    proc_num = 1031;
  end

  if (proc_num == 1031) begin
    @(posedge clk_usb);
    e0_seqbit = 0;
    rx_length = 8;

    usb2_setup_tran (8'h80,8'h06,16'h0200,16'h0000,16'h0009,rx_length);

    @(posedge clk_usb);
    if (rx_hands == 8'hd2) begin
      e0_seqbit = 1;
      $display ("GET DESCRIPTOR CONFIGURATION, SETUP");
      proc_num = 1032;
    end
    else proc_num = 1031;
  end

  if (proc_num == 1032) begin
    @(posedge clk_usb);

    usb2_din_tran (e0_seqbit,4'h0);

    @(posedge clk_usb);
    if (rx_nack) begin
      $display ("GET DESCRIPTOR CONFIGURATION, DATA NACK");
      proc_num = 1032;
    end
    else begin
      $display ("GET DESCRIPTOR CONFIGURATION, DATA");
      e0_seqbit = 1;
      proc_num = 1033;
    end
  end

  if (proc_num == 1033) begin
    @(posedge clk_usb);
    rx_length = 0;
    tloop_cnt = 0;

    usb2_dout_tran (e0_seqbit,4'h0,rx_length,tloop_cnt);

    @(posedge clk_usb);
    if (rx_hands == 8'hd2) begin
      $display ("GET DESCRIPTOR CONFIGURATION, STATUS");
      proc_num = 1040;
    end
    else proc_num = 1030;
  end

  if (proc_num == 1040) begin
    @(posedge clk_usb);
    $display ("SEND SOF");
    usb2_send_sof (frame_num);

    @(posedge clk_usb);
    frame_num = frame_num + 1;
    proc_num = 1041;
  end

  if (proc_num == 1041) begin
    @(posedge clk_usb);
    e0_seqbit = 0;
    device_addr = 0;
    rx_length = 8;

    usb2_setup_tran (8'h00,8'h05,16'h0064,16'h0000,16'h0000,rx_length);

    @(posedge clk_usb);
    if (rx_hands == 8'hd2) begin
      e0_seqbit = 1;
      $display ("SET DEVICE ADDRESS 0x%x, SETUP", device_addr);
      proc_num = 1042;
    end
    else proc_num = 1041;
  end

  if (proc_num == 1042) begin
    @(posedge clk_usb);

    usb2_din_tran (e0_seqbit,4'h0);

    @(posedge clk_usb);
    device_addr = 100;
    if (rx_nack) begin
      $display ("SET DEVICE ADDRESS 0x%x, STATUS NACK", device_addr);
      proc_num = 1042;
    end
    else begin
      $display ("SET DEVICE ADDRESS 0x%x, STATUS", device_addr);
      proc_num = 1050;
    end
  end

  if (proc_num == 1050) begin
    @(posedge clk_usb);
    $display ("SEND SOF");
    usb2_send_sof (frame_num);

    @(posedge clk_usb);
    frame_num = frame_num + 1;
    proc_num = 2000;
  end

  if (proc_num == 2000) begin
    @(posedge clk_usb);
    $display ("SEND SOF");
    usb2_send_sof (frame_num);

    @(posedge clk_usb);
    frame_num = frame_num + 1;
    e1_seqbit = 0;
    e2_seqbit = 0;
    e3_seqbit = 0;
    if (hspeed) begin
      rx_length = 512;
      proc_num = 2001;
    end
    else begin
      rx_length = 64;
      proc_num = 2011;
    end
  end

  if (proc_num == 2001) begin
    @(posedge clk_usb);

    usb2_ping (4'h3);
    while (rx_hands != 8'hd2) usb2_ping (4'h3);

    tloop_cnt = 0;
    for (loop_cnt = 0; loop_cnt < rx_length; loop_cnt = loop_cnt + 1)
      usb_rxdata[loop_cnt] = rx_length + loop_cnt;

    while (loop_cnt > 512) begin
      usb2_dout_tran (e3_seqbit,4'h3,512,tloop_cnt);

      if (rx_hands == 8'h96) begin
        e3_seqbit = ~e3_seqbit;
        loop_cnt = loop_cnt - 512;

        usb2_ping (4'h3);
        while (rx_hands != 8'hd2) usb2_ping (4'h3);
      end
      else if (rx_hands != 8'h5a) begin
        e3_seqbit = ~e3_seqbit;
        loop_cnt = loop_cnt - 512;
      end
      tloop_cnt = tloop_cnt + 1;
    end

    usb2_dout_tran (e3_seqbit,4'h3,loop_cnt,tloop_cnt);
    while (rx_hands == 8'h5a)
      usb2_dout_tran (e3_seqbit,4'h3,loop_cnt,tloop_cnt);
    e3_seqbit = ~e3_seqbit;
    if (rx_hands == 8'h96) begin
      while (rx_hands != 8'hd2) usb2_ping (4'h3);
    end

    if (loop_cnt == 512) begin
      usb2_dout_tran (e3_seqbit,4'h3,0,tloop_cnt);
      while (rx_hands == 8'h5a) usb2_dout_tran (e3_seqbit,4'h3,0,tloop_cnt);
      e3_seqbit = ~e3_seqbit;
      if (rx_hands == 8'h96) begin
        while (rx_hands != 8'hd2) usb2_ping (4'h3);
      end
    end

    @(posedge clk_usb);
    if (rx_hands == 8'hd2) begin
      $display ("BULK TRANSACTION, DATA OUT: %dBYTES", rx_length);
      proc_num = 2002;
    end
    else proc_num = 2001;
  end

  if (proc_num == 2002) begin
    @(posedge clk_usb);
    tx_tlength = 0;
    tx_length = 512;

    @(posedge clk_usb);
    while (tx_length == 512) begin
      usb2_din_tran (e2_seqbit,4'h2);

      if (rx_nack) begin
        repeat (1000) @(posedge clk_usb);
      end
      else begin
        e2_seqbit = ~e2_seqbit;
        tx_tlength = tx_tlength + tx_length;
      end
    end

    @(posedge clk_usb);
    $display ("BULK TRANSACTION, DATA IN: %dBYTES", tx_tlength);
    proc_num = 2010;
  end

  if (proc_num == 2010) begin
    @(posedge clk_usb);
    $display ("SEND SOF");
    usb2_send_sof (frame_num);

    @(posedge clk_usb);
    frame_num = frame_num + 1;

    if (frame_num == 2000) proc_num = 3000;
    else begin
      rx_length = $random (rand_seed);
      rx_length = (rx_length % 1500) + 1;
      proc_num = 2001;
    end
  end

  if (proc_num == 2011) begin
    @(posedge clk_usb);

    tloop_cnt = 0;
    for (loop_cnt = 0; loop_cnt < rx_length; loop_cnt = loop_cnt + 1)
      usb_rxdata[loop_cnt] = rx_length + loop_cnt;

    while (loop_cnt > 64) begin
      usb2_dout_tran (e3_seqbit,4'h3,64,tloop_cnt);

      if (rx_hands != 8'h5a) begin
        e3_seqbit = ~e3_seqbit;
        loop_cnt = loop_cnt - 64;
      end
      tloop_cnt = tloop_cnt + 1;
    end

    usb2_dout_tran (e3_seqbit,4'h3,loop_cnt,tloop_cnt);
    while (rx_hands == 8'h5a)
      usb2_dout_tran (e3_seqbit,4'h3,loop_cnt,tloop_cnt);
    e3_seqbit = ~e3_seqbit;

    if (loop_cnt == 64) begin
      usb2_dout_tran (e3_seqbit,4'h3,0,tloop_cnt);
      while (rx_hands == 8'h5a) usb2_dout_tran (e3_seqbit,4'h3,0,tloop_cnt);
      e3_seqbit = ~e3_seqbit;
    end

    @(posedge clk_usb);
    if (rx_hands == 8'hd2) begin
      $display ("BULK TRANSACTION, DATA OUT: %dBYTES", rx_length);
      proc_num = 2012;
    end
    else proc_num = 2011;
  end

  if (proc_num == 2012) begin
    @(posedge clk_usb);
    tx_tlength = 0;
    tx_length = 64;

    @(posedge clk_usb);
    while (tx_length == 64) begin
      usb2_din_tran (e2_seqbit,4'h2);

      if (rx_nack) begin
        repeat (1000) @(posedge clk_usb);
      end
      else begin
        e2_seqbit = ~e2_seqbit;
        tx_tlength = tx_tlength + tx_length;
      end
    end

    @(posedge clk_usb);
    $display ("BULK TRANSACTION, DATA IN: %dBYTES", tx_tlength);
    proc_num = 2020;
  end

  if (proc_num == 2020) begin
    @(posedge clk_usb);
    $display ("SEND SOF");
    usb2_send_sof (frame_num);

    @(posedge clk_usb);
    frame_num = frame_num + 1;

    if (frame_num == 2000) proc_num = 3000;
    else begin
      rx_length = $random (rand_seed);
      rx_length = (rx_length % 1500) + 1;
      proc_num = 2011;
    end
  end

  if (proc_num == 3000) begin
    @(posedge clk_usb);
    $display ("USB SIMULATION END");
    $stop;
  end


end
