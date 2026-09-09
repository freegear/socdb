// Verilog pattern output written by  TetraMAX (TM)  V-2004.06-SP2-i040821_000133 
// Date: Fri Jul  1 13:54:30 2005
// Module tested: rc8051RtlTop

//     Uncollapsed Stuck Fault Summary Report
// -----------------------------------------------
// fault class                     code   #faults
// ------------------------------  ----  ---------
// Detected                         DT      39172
// Possibly detected                PT        108
// Undetectable                     UD       1239
// ATPG untestable                  AU       2216
// Not detected                     ND        207
// -----------------------------------------------
// total faults                             42942
// test coverage                            94.06%
// -----------------------------------------------
// 
//            Pattern Summary Report
// -----------------------------------------------
// #internal patterns                         942
//     #basic_scan patterns                   942
// -----------------------------------------------
// 
// rule  severity  #fails  description
// ----  --------  ------  ---------------------------------
// N2    warning      132  unsupported construct
// N23   warning        2  inconsistent UDP
// B7    warning       24  undriven module output pin
// B8    warning       81  unconnected module input pin
// B10   warning       69  unconnected module internal net
// B22   warning       19  dropped design view
// C5    warning       11  LS port captured data affected by new capture  (nomask)
// C6    warning        2  TE port captured data affected by new capture  (nomask)
// C8    warning       11  LS port clock path affected by new capture  (nomask)
// C11   warning       11  LS port captured data affected by clock  (nomask)
// C17   warning        1  clock connected to PO
// C26   warning      221  clock as data different from capture clock for stable cell
// V12   warning        4  unexpected item
// Z9    warning        8  bidi bus driver enable affected by scan cell
// 
// clock_name        off  usage
// ----------------  ---  --------------------------
// clk                0   PO master shift nonscan_DFF 
// rst_p              1   master set reset nonscan_DLAT nonscan_DFF 
// 
// port_name         constraint_value
// ----------------  ---------------
// test_mode           1
// BistMode            0
// 
// There are no equivalent pins
// There are no net connections

`timescale 1 ns / 1 ns

//
// --- NOTE: Remove the comment to define 'tmax_iddq' to activate processing of IDDQ events
//     Or use '+define+tmax_iddq' on the verilog compile line
//
//`define tmax_iddq

//
// --- User adjustable extension to state sequencer table for debug purposes.
//     Adjusts oversizing of 'memdrv[]' to make room for manually inserted values.
//
`ifdef tmax_state_dbg
   /* user has used compile time overide of form:  +define+tmax_state_dbg=10 */
`else
   /* default to 5 */
   `define tmax_state_dbg 5
`endif

module AAA_tmax_testbench_1_16 ;
   parameter NAMELENGTH = 200; // max length of names reported in fails
   parameter LENMAX = 37, NSHIFTS = 37; // LENMAX for serial
   parameter LENSERIAL = 37, NCHAINS = 16;
   parameter SHBEG = 0, SHEND = 0;
   integer nofails, bit, cbit, pattern, lastpattern, chain, idx;
   integer error_banner; // flag for tracking displayed error banner
   integer loads;        // number of load_unloads for current pattern
   integer patm1;        // pattern - 1
   integer patp1;        // pattern + lastpattern
   integer prev_pat;     // previous pattern number
   integer report_interval; // report pattern progress every Nth pattern
   integer verbose;      // message verbosity level
   parameter NINPUTS = 34, NOUTPUTS = 56;
   wire [0:NOUTPUTS-1] PO; reg [0:NOUTPUTS-1] ALLPOS, XPCT, MASK;
   reg [0:NINPUTS-1] PI, ALLPIS;
   integer scn, pis, pos, drv, mbyte;
   reg [0:NINPUTS-1] mempis [1:942];
   reg [0:NOUTPUTS-1] mempos [1:1884];
   reg [7:0] drval, memdrv [1:10262+`tmax_state_dbg];
   reg [0:LENSERIAL-1] memscn [1:45232];
   reg [0:8*(NAMELENGTH-1)] POnames [0:NOUTPUTS-1];
   reg [0:8*(NAMELENGTH-1)] CHAINnames [0:NCHAINS-1];
   reg [0:8*(NAMELENGTH-1)] CHAINpins [0:NCHAINS-1];
   reg [0:LENSERIAL-1] LOAD0, LOADSH0, LOAD1, LOADSH1, LOAD2, LOADSH2, LOAD3,
   LOADSH3, LOAD4, LOADSH4, LOAD5, LOADSH5, LOAD6, LOADSH6, LOAD7, LOADSH7, LOAD8,
   LOADSH8, LOAD9, LOADSH9, LOAD10, LOADSH10, LOAD11, LOADSH11, LOAD12, LOADSH12,
   LOAD13, LOADSH13, LOAD14, LOADSH14, LOAD15, LOADSH15;
   reg [0:LENMAX-1] UNL, UNLOAD[0:NCHAINS-1];
   reg [0:LENMAX-1] UNLM, UNLMSK[0:NCHAINS-1], SHBEGM[0:NCHAINS-1];
   reg [0:LENMAX-1] SERIALM;
   reg [0:LENMAX-1] INPINV[0:NCHAINS-1], OUTINV[0:NCHAINS-1];
   wire [0:NCHAINS-1] SCANOUT;
   event IDDQ;

   wire scan_en;
   wire test_mode;
   wire clk;
   wire rst_p;
   wire int0_i;
   wire int1_i;
   wire all_t0_i;
   wire all_t1_i;
   wire all_rxd_i;
   wire all_txd_o;
   wire clkb;
   wire en_xdat;
   wire wr_xdat_d1;
   wire rd_xdat;
   wire BistMode;
   wire BistFail;
   wire Finish;
   wire ErrMap;
   wire [15:0] rom_adr_o;
   wire [7:0] rom_data_i;
   wire [15:0] addr_xdat;
   wire [7:0] out_xdat;
   wire [7:0] in_xdat_a;
   wire [7:0] p1_io;

   // map PI[] vector to DUT inputs and bidis
   assign scan_en = PI[0];
   assign test_mode = PI[1];
   assign clk = PI[2];
   assign rst_p = PI[3];
   assign int0_i = PI[4];
   assign int1_i = PI[5];
   assign all_t0_i = PI[6];
   assign all_t1_i = PI[7];
   assign all_rxd_i = PI[8];
   assign rom_data_i = PI[9:16];
   assign in_xdat_a = PI[17:24];
   assign p1_io = PI[25:32];
   assign BistMode = PI[33];

   // map DUT outputs and bidis to PO[] vector
   assign
      PO[0] = all_txd_o ,
      PO[1] = clkb ,
      PO[2] = rom_adr_o[15] ,
      PO[3] = rom_adr_o[14] ,
      PO[4] = rom_adr_o[13] ,
      PO[5] = rom_adr_o[12] ,
      PO[6] = rom_adr_o[11] ,
      PO[7] = rom_adr_o[10] ,
      PO[8] = rom_adr_o[9] ,
      PO[9] = rom_adr_o[8] ,
      PO[10] = rom_adr_o[7] ,
      PO[11] = rom_adr_o[6] ,
      PO[12] = rom_adr_o[5] ,
      PO[13] = rom_adr_o[4] ,
      PO[14] = rom_adr_o[3] ,
      PO[15] = rom_adr_o[2] ,
      PO[16] = rom_adr_o[1] ,
      PO[17] = rom_adr_o[0] ,
      PO[18] = addr_xdat[15] ,
      PO[19] = addr_xdat[14] ,
      PO[20] = addr_xdat[13] ,
      PO[21] = addr_xdat[12] ,
      PO[22] = addr_xdat[11] ,
      PO[23] = addr_xdat[10] ,
      PO[24] = addr_xdat[9] ,
      PO[25] = addr_xdat[8] ,
      PO[26] = addr_xdat[7] ,
      PO[27] = addr_xdat[6] ,
      PO[28] = addr_xdat[5] ,
      PO[29] = addr_xdat[4] ,
      PO[30] = addr_xdat[3] ,
      PO[31] = addr_xdat[2] ;
   assign
      PO[32] = addr_xdat[1] ,
      PO[33] = addr_xdat[0] ,
      PO[34] = out_xdat[7] ,
      PO[35] = out_xdat[6] ,
      PO[36] = out_xdat[5] ,
      PO[37] = out_xdat[4] ,
      PO[38] = out_xdat[3] ,
      PO[39] = out_xdat[2] ,
      PO[40] = out_xdat[1] ,
      PO[41] = out_xdat[0] ,
      PO[42] = en_xdat ,
      PO[43] = wr_xdat_d1 ,
      PO[44] = rd_xdat ,
      PO[45] = p1_io[7] ,
      PO[46] = p1_io[6] ,
      PO[47] = p1_io[5] ,
      PO[48] = p1_io[4] ,
      PO[49] = p1_io[3] ,
      PO[50] = p1_io[2] ,
      PO[51] = p1_io[1] ,
      PO[52] = p1_io[0] ,
      PO[53] = BistFail ,
      PO[54] = Finish ,
      PO[55] = ErrMap ;

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
      .rom_adr_o(rom_adr_o),
      .rom_data_i(rom_data_i),
      .addr_xdat(addr_xdat),
      .out_xdat(out_xdat),
      .in_xdat_a(in_xdat_a),
      .en_xdat(en_xdat),
      .wr_xdat_d1(wr_xdat_d1),
      .rd_xdat(rd_xdat),
      .p1_io(p1_io),
      .BistMode(BistMode),
      .BistFail(BistFail),
      .Finish(Finish),
      .ErrMap(ErrMap)   );

   event pulse_clk;
   always @ pulse_clk begin
      #45 PI[2] = 1; #10 PI[2] = 0;   // clk
   end

   event pulse_rst_p;
   always @ pulse_rst_p begin
      #45 PI[3] = 0; #10 PI[3] = 1;   // rst_p
   end


   integer errshown;
   event measurePO;
   always @ measurePO begin
      if (((XPCT&MASK) !== (ALLPOS&MASK)) || (XPCT !== (~(~XPCT)))) begin
         errshown = 0;
         for (bit = 0; bit < NOUTPUTS; bit=bit + 1) begin
            if (MASK[bit]==1'b1) begin
               if (XPCT[bit] !== ALLPOS[bit]) begin
                  if (errshown==0) $display("\n// *** ERROR during capture pattern %0d, T=%t", pattern, $time);
                  $display("  %0d %0s (exp=%b, got=%b)", pattern, POnames[bit], XPCT[bit], ALLPOS[bit]);
                  nofails = nofails + 1; errshown = 1;
               end
            end
         end
      end
   end

   event forcePI_default_WFT;
   always @ forcePI_default_WFT begin
      PI = ALLPIS;
   end
   event measurePO_default_WFT;
   always @ measurePO_default_WFT begin
      #80;
      ALLPOS = PO;
      #0; #0 -> measurePO;
      `ifdef tmax_iddq
         #0; ->IDDQ;
      `endif
   end

   event force_scanin;
   always @ force_scanin begin
      PI[16] <= LOAD0[bit];
      PI[15] <= LOAD1[bit];
      PI[14] <= LOAD2[bit];
      PI[13] <= LOAD3[bit];
      PI[12] <= LOAD4[bit];
      PI[11] <= LOAD5[bit];
      PI[10] <= LOAD6[bit];
      PI[9] <= LOAD7[bit];
      PI[24] <= LOAD8[bit];
      PI[23] <= LOAD9[bit];
      PI[22] <= LOAD10[bit];
      PI[21] <= LOAD11[bit];
      PI[20] <= LOAD12[bit];
      PI[19] <= LOAD13[bit];
      PI[18] <= LOAD14[bit];
      PI[17] <= LOAD15[bit];
   end

   assign SCANOUT[0] = rom_adr_o[0],  SCANOUT[1] = rom_adr_o[1],  SCANOUT[2] = rom_adr_o[2],
           SCANOUT[3] = rom_adr_o[3],  SCANOUT[4] = rom_adr_o[4],  SCANOUT[5] = rom_adr_o[5],
           SCANOUT[6] = rom_adr_o[6],  SCANOUT[7] = rom_adr_o[7],  SCANOUT[8] = rom_adr_o[8],
           SCANOUT[9] = rom_adr_o[9],  SCANOUT[10] = rom_adr_o[10],  SCANOUT[11]
          = rom_adr_o[11],  SCANOUT[12] = rom_adr_o[12],  SCANOUT[13] = rom_adr_o[13],
           SCANOUT[14] = rom_adr_o[14],  SCANOUT[15] = rom_adr_o[15];

   event measure_scanout;
   always @ measure_scanout begin
    if (bit < LENMAX-1) begin // pre_shift_measure_sco
      if ((NSHIFTS < LENMAX) && (bit >= SHBEG)) cbit = bit - LENMAX + NSHIFTS + 1 + SHBEG;
      else cbit = bit; // because parallel does NSHIFTS + 1 shifts
      cbit=cbit+1; // pre_shift_measure_sco
      idx = cbit + 0;
      for (chain = 0; chain < 16; chain=chain + 1) begin
         UNL = UNLOAD[chain]; UNLM = UNLMSK[chain];
         if ((UNL[idx]&UNLM[idx]) !== (SCANOUT[chain]&UNLM[idx])) begin
            patp1 = pattern + lastpattern;  patm1 = patp1 - 1;
            if (error_banner != pattern) begin
               if (lastpattern == 0) $display("\n// *** ERROR during scan pattern %0d (detected during load of pattern %0d)", patm1, patp1);
               else $display("\n// *** ERROR during scan pattern %0d (detected during final pattern unload)", patm1);
               error_banner = pattern;
            end
            $display("  %0d %0s %0d (exp=%b, got=%b)  // pin %0s, scan cell %0d, T=%t",
               patm1, CHAINnames[chain], cbit, UNL[idx], SCANOUT[chain], CHAINpins[chain], cbit, $time);
            nofails = nofails + 1;
         end
      end
    end // pre_shift_measure_sco
   end


   always @ IDDQ begin
   `ifdef tmax_iddq
      $ssi_iddq("strobe_try");
      $ssi_iddq("status drivers leaky AAA_tmax_testbench_1_16.leaky");
   `endif
   end

   task shift;
   begin
      if (verbose >= 4) $display("// %t :    shift %0d", $time, bit);
      #0 PI[33] = 0; // BistMode
      #0 PI[3] = 1; // rst_p
      #0 PI[0] = 1; // scan_en
      #0 PI[1] = 1; // test_mode
      ->force_scanin;
      #45 PI[2] = 1; // clk
      #10 PI[2] = 0; // clk
      #25; ->measure_scanout;
      #20;
   end
   endtask

   event capture;
   always @ capture begin
      ->forcePI_default_WFT;
      ->measurePO_default_WFT;
   end

   event capture_clk;
   always @ capture_clk begin
      ->forcePI_default_WFT;
      #100; ->measurePO_default_WFT;
      #145 PI[2] = 1; // clk
      #10 PI[2] = 0; // clk
   end

   event capture_rst_p;
   always @ capture_rst_p begin
      ->forcePI_default_WFT;
      #100; ->measurePO_default_WFT;
      #145 PI[3] = 0; // rst_p
      #10 PI[3] = 1; // rst_p
   end

   event test_setup;
   always @ test_setup begin
      #0 PI[33] = 0; // BistMode
      #0 PI[2] = 0; // clk
      #0 PI[3] = 1; // rst_p
      #0 PI[1] = 1; // test_mode
      #0 PI[32] = 1'bZ; // p1_io[0]
      #0 PI[31] = 1'bZ; // p1_io[1]
      #0 PI[30] = 1'bZ; // p1_io[2]
      #0 PI[29] = 1'bZ; // p1_io[3]
      #0 PI[28] = 1'bZ; // p1_io[4]
      #0 PI[27] = 1'bZ; // p1_io[5]
      #0 PI[26] = 1'bZ; // p1_io[6]
      #0 PI[25] = 1'bZ; // p1_io[7]
   end


   task multiple_shift;
   begin
      bit = bit-1;
      error_banner = -2;
      while (bit+1 < LENMAX-SHEND) begin
         bit = bit+1;
         shift;
      end
   end
   endtask

   event load_unload;
   always @ load_unload begin
      if (pattern != prev_pat) begin
         loads = 1;
         prev_pat = pattern;
         if ((verbose >= 2) && (pattern % report_interval == 0))
            $display("// %t : ...begin scan load for pattern %0d", $time, pattern);
         end
      else begin
         loads = loads + 1;
         if ((verbose >= 2) && (pattern % report_interval == 0))
            $display("// %t : ...begin scan load for pattern %0d, load %0d", $time, pattern, loads);
      end

      #0 PI[33] = 0; // BistMode
      #0 PI[2] = 0; // clk
      #0 PI[3] = 1; // rst_p
      #0 PI[0] = 1; // scan_en
      #0 PI[1] = 1; // test_mode
      #0 PI[32] = 1'bZ; // p1_io[0]
      #0 PI[31] = 1'bZ; // p1_io[1]
      #0 PI[30] = 1'bZ; // p1_io[2]
      #0 PI[29] = 1'bZ; // p1_io[3]
      #0 PI[28] = 1'bZ; // p1_io[4]
      #0 PI[27] = 1'bZ; // p1_io[5]
      #0 PI[26] = 1'bZ; // p1_io[6]
      #0 PI[25] = 1'bZ; // p1_io[7]
      #80; bit = -1; ->measure_scanout;
      #20;
      // end of load_unload preamble
      bit = SHBEG; multiple_shift;
   end


   task mbyte_task;
      reg[7:0] mc, mb;
      begin
         mc = memdrv[drv]; drv = drv + 1;
         mbyte = 0;
         repeat (mc) begin
            mb = memdrv[drv]; drv = drv + 1;
            mbyte = (mbyte << 8) + mb;
         end
      end
   endtask

   initial begin

      //
      // --- establish a default time format for %t
      //
      $timeformat(-9,2," ns",18);

      //
      // --- default verbosity to 2 but also allow user override by
      //     using '+define+tmax_msg=N' on verilog compile line.
      //
      `ifdef tmax_msg
         verbose = `tmax_msg ;
      `else
         verbose = 2 ;
      `endif

      //
      // --- default pattern reporting interval to 5 but also allow user
      //     override by using '+define+tmax_rpt=N' on verilog compile line.
      //
      `ifdef tmax_rpt
         report_interval = `tmax_rpt ;
      `else
         report_interval = 5 ;
      `endif

      //
      // --- support generating Extened VCD output by using
      //     '+define+tmax_vcde' on verilog compile line.
      //
      `ifdef tmax_vcde
         // extended VCD, see IEEE Verilog P1364.1-1999 Draft 2
         if (verbose >= 2) $display("// %t : opening Extended VCD output file", $time);
         $dumpports( dut, "sim_vcde.out");
      `endif

      //
      // --- IDDQ PLI initialization
      //     User may activite by using '+define+tmax_iddq' on verilog compile line.
      //     Or by defining `tmax_iddq in this file.
      //
      `ifdef tmax_iddq
         if (verbose >= 3) $display("// %t : Initializing IDDQ PLI", $time);
         $ssi_iddq("dut AAA_tmax_testbench_1_16.dut");
         $ssi_iddq("verb on");
         $ssi_iddq("cycle 0");
         //
         // --- User may select one of the following two methods for fault seeding:
         //     #1 faults seeded by PLI (default)
         //     #2 faults supplied in a file
         //     Comment out the unused lines as needed (precede with '//').
         //     Replace the 'FAULTLIST_FILE' string with the actual file pathname.
         //
         $ssi_iddq("seed SA AAA_tmax_testbench_1_16.dut");   // no file, faults seeded by PLI
         //
         // $ssi_iddq("scope AAA_tmax_testbench_1_16.dut");   // set scope for faults from a file
         // $ssi_iddq("read_tmax FAULTLIST_FILE"); // read faults from a file
         //
      `endif

      POnames[0] = "all_txd_o";
      POnames[1] = "clkb";
      POnames[2] = "rom_adr_o[15]";
      POnames[3] = "rom_adr_o[14]";
      POnames[4] = "rom_adr_o[13]";
      POnames[5] = "rom_adr_o[12]";
      POnames[6] = "rom_adr_o[11]";
      POnames[7] = "rom_adr_o[10]";
      POnames[8] = "rom_adr_o[9]";
      POnames[9] = "rom_adr_o[8]";
      POnames[10] = "rom_adr_o[7]";
      POnames[11] = "rom_adr_o[6]";
      POnames[12] = "rom_adr_o[5]";
      POnames[13] = "rom_adr_o[4]";
      POnames[14] = "rom_adr_o[3]";
      POnames[15] = "rom_adr_o[2]";
      POnames[16] = "rom_adr_o[1]";
      POnames[17] = "rom_adr_o[0]";
      POnames[18] = "addr_xdat[15]";
      POnames[19] = "addr_xdat[14]";
      POnames[20] = "addr_xdat[13]";
      POnames[21] = "addr_xdat[12]";
      POnames[22] = "addr_xdat[11]";
      POnames[23] = "addr_xdat[10]";
      POnames[24] = "addr_xdat[9]";
      POnames[25] = "addr_xdat[8]";
      POnames[26] = "addr_xdat[7]";
      POnames[27] = "addr_xdat[6]";
      POnames[28] = "addr_xdat[5]";
      POnames[29] = "addr_xdat[4]";
      POnames[30] = "addr_xdat[3]";
      POnames[31] = "addr_xdat[2]";
      POnames[32] = "addr_xdat[1]";
      POnames[33] = "addr_xdat[0]";
      POnames[34] = "out_xdat[7]";
      POnames[35] = "out_xdat[6]";
      POnames[36] = "out_xdat[5]";
      POnames[37] = "out_xdat[4]";
      POnames[38] = "out_xdat[3]";
      POnames[39] = "out_xdat[2]";
      POnames[40] = "out_xdat[1]";
      POnames[41] = "out_xdat[0]";
      POnames[42] = "en_xdat";
      POnames[43] = "wr_xdat_d1";
      POnames[44] = "rd_xdat";
      POnames[45] = "p1_io[7]";
      POnames[46] = "p1_io[6]";
      POnames[47] = "p1_io[5]";
      POnames[48] = "p1_io[4]";
      POnames[49] = "p1_io[3]";
      POnames[50] = "p1_io[2]";
      POnames[51] = "p1_io[1]";
      POnames[52] = "p1_io[0]";
      POnames[53] = "BistFail";
      POnames[54] = "Finish";
      POnames[55] = "ErrMap";
      CHAINnames[0] = "c0";
      CHAINnames[1] = "c1";
      CHAINnames[2] = "c2";
      CHAINnames[3] = "c3";
      CHAINnames[4] = "c4";
      CHAINnames[5] = "c5";
      CHAINnames[6] = "c6";
      CHAINnames[7] = "c7";
      CHAINnames[8] = "c8";
      CHAINnames[9] = "c9";
      CHAINnames[10] = "c10";
      CHAINnames[11] = "c11";
      CHAINnames[12] = "c12";
      CHAINnames[13] = "c13";
      CHAINnames[14] = "c14";
      CHAINnames[15] = "c15";
      CHAINpins[0] = "rom_adr_o[0]";
      CHAINpins[1] = "rom_adr_o[1]";
      CHAINpins[2] = "rom_adr_o[2]";
      CHAINpins[3] = "rom_adr_o[3]";
      CHAINpins[4] = "rom_adr_o[4]";
      CHAINpins[5] = "rom_adr_o[5]";
      CHAINpins[6] = "rom_adr_o[6]";
      CHAINpins[7] = "rom_adr_o[7]";
      CHAINpins[8] = "rom_adr_o[8]";
      CHAINpins[9] = "rom_adr_o[9]";
      CHAINpins[10] = "rom_adr_o[10]";
      CHAINpins[11] = "rom_adr_o[11]";
      CHAINpins[12] = "rom_adr_o[12]";
      CHAINpins[13] = "rom_adr_o[13]";
      CHAINpins[14] = "rom_adr_o[14]";
      CHAINpins[15] = "rom_adr_o[15]";
      SERIALM = 37'b0000000000000000000000000000000000000;
      nofails = 0; pattern = -1; lastpattern = 0;
      prev_pat = -2; error_banner = -2;

      if (verbose >=1) $display("// %t : Begin test_setup", $time);
      ->test_setup;
      #200; // 200

      if (verbose >= 3) $display("// %t : reading pattern scan data file", $time);
      $readmemh("rc8051RtlTop_serial.scn", memscn);
      if (verbose >= 3) $display("// %t : reading pattern PI data file", $time);
      $readmemb("rc8051RtlTop_serial.pis", mempis);
      if (verbose >= 3) $display("// %t : reading pattern PO data file", $time);
      $readmemb("rc8051RtlTop_serial.pos", mempos);
      if (verbose >= 3) $display("// %t : reading pattern sequencer file", $time);
      $readmemh("rc8051RtlTop_serial.seq", memdrv);
      scn = 1; pis = 1; pos = 1; drv = 1;

      /*** Scan test ***/

      if (verbose >= 1) $display("// %t : Begin patterns, first pattern = 0", $time);
      pattern = -1; lastpattern = 0;
      while (lastpattern >=0) begin
         drval = memdrv[drv];
         if (verbose >= 5) $display("// %t : 0x%0h is %0d sequencer value",$time,drval,drv);
         drv = drv + 1;
         case (drval)
            'h0: pattern = pattern + 1;
            'h1: lastpattern = 1;
            'h2: lastpattern = -1; // break
            'h3: begin #0 PI = mempis[pis]; pis = pis + 1; end
            'h4: begin ALLPIS = mempis[pis]; pis = pis + 1; end
            'h5: begin XPCT = mempos[pos]; pos = pos + 1; MASK = mempos[pos]; pos = pos + 1; end
            'h6: MASK = 56'b0;
            'h7: begin
               LOAD0 = memscn[scn]; scn = scn + 1;
               LOAD1 = memscn[scn]; scn = scn + 1;
               LOAD2 = memscn[scn]; scn = scn + 1;
               LOAD3 = memscn[scn]; scn = scn + 1;
               LOAD4 = memscn[scn]; scn = scn + 1;
               LOAD5 = memscn[scn]; scn = scn + 1;
               LOAD6 = memscn[scn]; scn = scn + 1;
               LOAD7 = memscn[scn]; scn = scn + 1;
               LOAD8 = memscn[scn]; scn = scn + 1;
               LOAD9 = memscn[scn]; scn = scn + 1;
               LOAD10 = memscn[scn]; scn = scn + 1;
               LOAD11 = memscn[scn]; scn = scn + 1;
               LOAD12 = memscn[scn]; scn = scn + 1;
               LOAD13 = memscn[scn]; scn = scn + 1;
               LOAD14 = memscn[scn]; scn = scn + 1;
               LOAD15 = memscn[scn]; scn = scn + 1;
                 end
            'h8: begin
               UNLOAD[0] = memscn[scn]; scn = scn + 1;
               UNLMSK[0] = memscn[scn]; scn = scn + 1;
               UNLOAD[1] = memscn[scn]; scn = scn + 1;
               UNLMSK[1] = memscn[scn]; scn = scn + 1;
               UNLOAD[2] = memscn[scn]; scn = scn + 1;
               UNLMSK[2] = memscn[scn]; scn = scn + 1;
               UNLOAD[3] = memscn[scn]; scn = scn + 1;
               UNLMSK[3] = memscn[scn]; scn = scn + 1;
               UNLOAD[4] = memscn[scn]; scn = scn + 1;
               UNLMSK[4] = memscn[scn]; scn = scn + 1;
               UNLOAD[5] = memscn[scn]; scn = scn + 1;
               UNLMSK[5] = memscn[scn]; scn = scn + 1;
               UNLOAD[6] = memscn[scn]; scn = scn + 1;
               UNLMSK[6] = memscn[scn]; scn = scn + 1;
               UNLOAD[7] = memscn[scn]; scn = scn + 1;
               UNLMSK[7] = memscn[scn]; scn = scn + 1;
               UNLOAD[8] = memscn[scn]; scn = scn + 1;
               UNLMSK[8] = memscn[scn]; scn = scn + 1;
               UNLOAD[9] = memscn[scn]; scn = scn + 1;
               UNLMSK[9] = memscn[scn]; scn = scn + 1;
               UNLOAD[10] = memscn[scn]; scn = scn + 1;
               UNLMSK[10] = memscn[scn]; scn = scn + 1;
               UNLOAD[11] = memscn[scn]; scn = scn + 1;
               UNLMSK[11] = memscn[scn]; scn = scn + 1;
               UNLOAD[12] = memscn[scn]; scn = scn + 1;
               UNLMSK[12] = memscn[scn]; scn = scn + 1;
               UNLOAD[13] = memscn[scn]; scn = scn + 1;
               UNLMSK[13] = memscn[scn]; scn = scn + 1;
               UNLOAD[14] = memscn[scn]; scn = scn + 1;
               UNLMSK[14] = memscn[scn]; scn = scn + 1;
               UNLOAD[15] = memscn[scn]; scn = scn + 1;
               UNLMSK[15] = memscn[scn]; scn = scn + 1;
                 end
            'h9: begin
               UNLMSK[0] = 37'b0;
               UNLMSK[1] = 37'b0;
               UNLMSK[2] = 37'b0;
               UNLMSK[3] = 37'b0;
               UNLMSK[4] = 37'b0;
               UNLMSK[5] = 37'b0;
               UNLMSK[6] = 37'b0;
               UNLMSK[7] = 37'b0;
               UNLMSK[8] = 37'b0;
               UNLMSK[9] = 37'b0;
               UNLMSK[10] = 37'b0;
               UNLMSK[11] = 37'b0;
               UNLMSK[12] = 37'b0;
               UNLMSK[13] = 37'b0;
               UNLMSK[14] = 37'b0;
               UNLMSK[15] = 37'b0;
                 end
            'hA: #100;
            'hB: #20;
            'hF: begin #0; ->pulse_clk; end
            'h10: begin #0; ->pulse_rst_p; end
            'h11: begin #0; ->measurePO; #0; end
            'h12: begin #0; ->forcePI_default_WFT; #0; end
            'h13: begin #0; ->measurePO_default_WFT; #0; end
            'h14: begin #0; ->force_scanin; #0; end
            'h15: begin #0; ->measure_scanout; #0; end
            'h16: begin #0; ->IDDQ; #0; end
            'h17: begin #0; shift; #0; end
            'h18: begin #0; ->capture; #100; end
            'h19: begin #0; ->capture_clk; #300; end
            'h1A: begin #0; ->capture_rst_p; #300; end
            'h1B: begin #0; ->test_setup; #200; end
            'h1C: begin #0; multiple_shift; #0; end
            'h1D: begin #0; ->load_unload; #3800; end
            'hF0: begin verbose = 0; $display("// %t : verbosity = %0d", $time, verbose); end
            'hF1: begin verbose = 1; $display("// %t : verbosity = %0d", $time, verbose); end
            'hF2: begin verbose = 2; $display("// %t : verbosity = %0d", $time, verbose); end
            'hF3: begin verbose = 3; $display("// %t : verbosity = %0d", $time, verbose); end
            'hF4: begin verbose = 4; $display("// %t : verbosity = %0d", $time, verbose); end
            'hF5: begin verbose = 5; $display("// %t : verbosity = %0d", $time, verbose); end
            default: begin $display($time, " Unrecognized code %0h", drval); $finish; end
         endcase
      end /* while */
      $display("// %t : Simulation of %0d patterns completed with %0d errors\n", $time, pattern+1, nofails);
      if (verbose >=2) $finish(2);
      /* else */ $finish(0);
   end
endmodule
