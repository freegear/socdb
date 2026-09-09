// Verilog STILDPV testbench written by  TetraMAX (TM)  V-2004.06-SP2-i040821_000133 
// Date: Fri Jul  1 13:54:27 2005
// Module tested: rc8051RtlTop

`timescale 1 ns / 10 ps

//
// --- NOTE: Remove the comment to define 'tmax_iddq' to activate processing of IDDQ events
//     Or use '+define+tmax_iddq' on the verilog compile line
//
//`define tmax_iddq

module rc8051RtlTop_test;
   integer verbose;      // message verbosity level
   parameter NINPUTS = 34, NOUTPUTS = 56;

   wire scan_en;  reg scan_en_REG ;
   wire test_mode;  reg test_mode_REG ;
   wire clk;  reg clk_REG ;
   wire rst_p;  reg rst_p_REG ;
   wire int0_i;  reg int0_i_REG ;
   wire int1_i;  reg int1_i_REG ;
   wire all_t0_i;  reg all_t0_i_REG ;
   wire all_t1_i;  reg all_t1_i_REG ;
   wire all_rxd_i;  reg all_rxd_i_REG ;
   wire all_txd_o;
   wire clkb;
   wire en_xdat;
   wire wr_xdat_d1;
   wire rd_xdat;
   wire BistMode;  reg BistMode_REG ;
   wire BistFail;
   wire Finish;
   wire ErrMap;
   wire [15:0] rom_adr_o;
//   reg [15:0] rom_adr_o_REG;
   reg \rom_adr_o_REG[0] ;
   reg \rom_adr_o_REG[1] ;
   reg \rom_adr_o_REG[2] ;
   reg \rom_adr_o_REG[3] ;
   reg \rom_adr_o_REG[4] ;
   reg \rom_adr_o_REG[5] ;
   reg \rom_adr_o_REG[6] ;
   reg \rom_adr_o_REG[7] ;
   reg \rom_adr_o_REG[8] ;
   reg \rom_adr_o_REG[9] ;
   reg \rom_adr_o_REG[10] ;
   reg \rom_adr_o_REG[11] ;
   reg \rom_adr_o_REG[12] ;
   reg \rom_adr_o_REG[13] ;
   reg \rom_adr_o_REG[14] ;
   reg \rom_adr_o_REG[15] ;
   wire [7:0] rom_data_i;
//   reg [7:0] rom_data_i_REG;
   reg \rom_data_i_REG[0] ;
   reg \rom_data_i_REG[1] ;
   reg \rom_data_i_REG[2] ;
   reg \rom_data_i_REG[3] ;
   reg \rom_data_i_REG[4] ;
   reg \rom_data_i_REG[5] ;
   reg \rom_data_i_REG[6] ;
   reg \rom_data_i_REG[7] ;
   wire [15:0] addr_xdat;
//   reg [15:0] addr_xdat_REG;
   reg \addr_xdat_REG[0] ;
   reg \addr_xdat_REG[1] ;
   reg \addr_xdat_REG[2] ;
   reg \addr_xdat_REG[3] ;
   reg \addr_xdat_REG[4] ;
   reg \addr_xdat_REG[5] ;
   reg \addr_xdat_REG[6] ;
   reg \addr_xdat_REG[7] ;
   reg \addr_xdat_REG[8] ;
   reg \addr_xdat_REG[9] ;
   reg \addr_xdat_REG[10] ;
   reg \addr_xdat_REG[11] ;
   reg \addr_xdat_REG[12] ;
   reg \addr_xdat_REG[13] ;
   reg \addr_xdat_REG[14] ;
   reg \addr_xdat_REG[15] ;
   wire [7:0] out_xdat;
//   reg [7:0] out_xdat_REG;
   reg \out_xdat_REG[0] ;
   reg \out_xdat_REG[1] ;
   reg \out_xdat_REG[2] ;
   reg \out_xdat_REG[3] ;
   reg \out_xdat_REG[4] ;
   reg \out_xdat_REG[5] ;
   reg \out_xdat_REG[6] ;
   reg \out_xdat_REG[7] ;
   wire [7:0] in_xdat_a;
//   reg [7:0] in_xdat_a_REG;
   reg \in_xdat_a_REG[0] ;
   reg \in_xdat_a_REG[1] ;
   reg \in_xdat_a_REG[2] ;
   reg \in_xdat_a_REG[3] ;
   reg \in_xdat_a_REG[4] ;
   reg \in_xdat_a_REG[5] ;
   reg \in_xdat_a_REG[6] ;
   reg \in_xdat_a_REG[7] ;
   wire [7:0] p1_io;
//   reg [7:0] p1_io_REG;
   reg \p1_io_REG[0] ;
   reg \p1_io_REG[1] ;
   reg \p1_io_REG[2] ;
   reg \p1_io_REG[3] ;
   reg \p1_io_REG[4] ;
   reg \p1_io_REG[5] ;
   reg \p1_io_REG[6] ;
   reg \p1_io_REG[7] ;

   // map register to wire for DUT inputs and bidis
   assign scan_en = scan_en_REG ;
   assign test_mode = test_mode_REG ;
   assign clk = clk_REG ;
   assign rst_p = rst_p_REG ;
   assign int0_i = int0_i_REG ;
   assign int1_i = int1_i_REG ;
   assign all_t0_i = all_t0_i_REG ;
   assign all_t1_i = all_t1_i_REG ;
   assign all_rxd_i = all_rxd_i_REG ;
   assign rom_data_i = { \rom_data_i_REG[7] , \rom_data_i_REG[6] , \rom_data_i_REG[5]
          , \rom_data_i_REG[4] , \rom_data_i_REG[3] , \rom_data_i_REG[2] , \rom_data_i_REG[1]
          , \rom_data_i_REG[0]  };
   assign in_xdat_a = { \in_xdat_a_REG[7] , \in_xdat_a_REG[6] , \in_xdat_a_REG[5]
          , \in_xdat_a_REG[4] , \in_xdat_a_REG[3] , \in_xdat_a_REG[2] , \in_xdat_a_REG[1]
          , \in_xdat_a_REG[0]  };
   assign p1_io = { \p1_io_REG[7] , \p1_io_REG[6] , \p1_io_REG[5] , \p1_io_REG[4]
          , \p1_io_REG[3] , \p1_io_REG[2] , \p1_io_REG[1] , \p1_io_REG[0]  };
   assign BistMode = BistMode_REG ;

   // instantiate the design into the testbench
   rc8051RtlTop dut (
      .scan_en(scan_en),
      .test_mode(test_mode),
      .clk(clk),
      .rst_p(rst_p),
      .int0_i(int0_i),
      .int1_i(int1_i),
      .all_t0_i(all_t0_i),
      .all_t1_i(all_t1_i),
      .all_rxd_i(all_rxd_i),
      .all_txd_o(all_txd_o),
      .clkb(clkb),
      .rom_adr_o({ rom_adr_o[15], rom_adr_o[14], rom_adr_o[13],
          rom_adr_o[12], rom_adr_o[11], rom_adr_o[10], rom_adr_o[9], rom_adr_o[8],
          rom_adr_o[7], rom_adr_o[6], rom_adr_o[5], rom_adr_o[4], rom_adr_o[3], rom_adr_o[2],
          rom_adr_o[1], rom_adr_o[0] }),
      .rom_data_i({ rom_data_i[7], rom_data_i[6], rom_data_i[5],
          rom_data_i[4], rom_data_i[3], rom_data_i[2], rom_data_i[1], rom_data_i[0]
          }),
      .addr_xdat({ addr_xdat[15], addr_xdat[14], addr_xdat[13], addr_xdat[12], addr_xdat[11],
          addr_xdat[10], addr_xdat[9], addr_xdat[8], addr_xdat[7], addr_xdat[6],
          addr_xdat[5], addr_xdat[4], addr_xdat[3], addr_xdat[2], addr_xdat[1], addr_xdat[0]
          }),
      .out_xdat({ out_xdat[7], out_xdat[6], out_xdat[5], out_xdat[4], out_xdat[3], out_xdat[2],
          out_xdat[1], out_xdat[0] }),
      .in_xdat_a({ in_xdat_a[7], in_xdat_a[6], in_xdat_a[5],
          in_xdat_a[4], in_xdat_a[3], in_xdat_a[2], in_xdat_a[1], in_xdat_a[0] }),
      .en_xdat(en_xdat),
      .wr_xdat_d1(wr_xdat_d1),
      .rd_xdat(rd_xdat),
      .p1_io({
          p1_io[7], p1_io[6], p1_io[5], p1_io[4], p1_io[3], p1_io[2], p1_io[1], p1_io[0]
          }),
      .BistMode(BistMode),
      .BistFail(BistFail),
      .Finish(Finish),
      .ErrMap(ErrMap)   );

   // STIL Direct Pattern Validate Access
   initial begin
      //
      // --- establish a default time format for %t
      //
      $timeformat(-9,2," ns",18);

      // TetraMAX serial-mode simulation requested by default
      // +define+tmax_parallel=N on the command line will override default serial simulation,
      // with N serial vectors at the end of each Shift
      `ifdef tmax_parallel
          $STILDPV_parallel(`tmax_parallel,0);
      `endif

      $STILDPV_setup( "rc8051RtlTop.stil",,,"rc8051RtlTop_test.dut" );
      while ( !$STILDPV_done()) #($STILDPV_run());
      $display("Time %t: STIL simulation data completed.",$time);
   end

   // STIL Direct Pattern Validate Trace Options (uncomment to use)
   // The STILDPV_trace() function takes '1' to enable a trace and '0' to disable.
   // Unspecified arguments maintain their current state. Tracing may be changed at any time.
   // The following arguments control tracing of:
   // 1st argument: enable or disable tracing of all STIL labels
   // 2nd argument: enable or disable tracing of each STIL Vector and current Vector count
   // 3rd argument: enable or disable tracing of each additional Thread (new Pattern)
   // 4th argument: enable or disable tracing of each WaveformTable change
   // 5th argument: enable or disable tracing of each Procedure or Macro entry
   // initial begin
   //    #800000 $STILDPV_trace(1,1);
   //    #600000 $STILDPV_trace(,0);
   // Additional calls to $STILDPV_parallel() may be defined to change parallel/serial
   // operation during simulation. Any additional calls need a # time value.
   // First value is number of serial (flat) cycles to simulate at end of each shift
   // Second value is TetraMAX pattern number (starting at zero) to start parallel load
   // For example, #8000 $STILDPV_parallel( 2,10 );
   // end
endmodule
