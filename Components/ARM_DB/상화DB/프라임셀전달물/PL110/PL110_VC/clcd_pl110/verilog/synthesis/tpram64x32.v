//----------------------Revision History-------------------------------------------
// 02-Sep-99, 1.0, Sergey Roudnik,  Copy from tp4 and update for new
//                                  functionnality
// 21-Feb-00, 1.1, Sergey Roudnik,  Fix for D/E 15681 : verilog-XL compilation
//                                  fails for new tsmc18 two port rams.
//---------------------------------------------------------------------------------

`timescale 1ns/100fs


`define numAddr 6
`define numOut 32
`define wordDepth 64

`define ovi
`ifdef notovi
`undef ovi
`endif

`define verbose 3
`ifdef verbose_0
`undef verbose
`define verbose 0
`endif
`ifdef verbose_1
`undef verbose
`define  verbose 1
`endif
`ifdef verbose_2
`undef verbose
`define verbose 2
`endif
`ifdef verbose_3
`undef verbose
`define verbose 3
`endif

`celldefine
module tpram64x32(RCSB, WCSB, WA, RA, WEB, REB, OEB, DO, DI);

`ifdef nobanner

`else
initial
begin
  $display("        TWO PORT RAM VERILOG BEHAVIOURAL MODEL	 		");
  $display("									");
  $display("                  Avant! Corporation				");
  $display("                  46871 Bayside Parkway				");
  $display("                  Fremont CA 94538					");
  $display("							 		");
  $display("                  Rev 1.1 21-Feb-2000       		 		");
  $display("							 		");
  $display(" Polaris INFO : Reccommending to use with +ieee +defparam +pulse_x/0");
  $display("                +pulse_r/0 +pathpulse +define+verbose_<X> options   ");
  $display("									");
  $display(" Error filtering options description : 			 	");
  $display(" +define+verbose_0 : X transitions filtered; no messages printed    ");
  $display(" +define+verbose_1 : X transitions filtered; error messages printed	");
  $display(" +define+verbose_2 : no X transtions filtering; no messages printed	");
  $display(" +define+verbose_3 : default : no X filtering; err messages printed ");
  $display("									");
  $display(" Add +define+nobanner in order not to display these header messages ");
  $display("									");
  $display(" Negative timings option description : 			        ");
  $display("  no negative timings allowed : default. 			        ");
  $display("     negative timings allowed : add +neg_tchk +define+notovi options");
  $display("								 	");
if (`verbose == 0 || `verbose == 1)
begin
  $display("								 	");
  $display(" THIS VERBOSE LEVEL MAY PRODUCE MIS-USAGE OF THE MEMORY BECAUSE :   ");
  $display(" - A TIMING ERROR DOES NOT INVALIDATE THE READ/WRITE OPEARTION AND 	");
  $display("   MAY KEEP THE ALREADY AVAILABLE DATA.				");
  $display(" - TRANSITION TO/FROM HIGH-Z/LOW-Z MAY SHOW DIFFERENT TIMINGS AS	");
  $display("   COMPARED TO AN HIGHER VERBOSE LEVEL			 	");
  $display("								 	");
end
`ifdef POLARIS_CBS
  $display("								 	");
  $display(" Polaris-CBS has been released using pin WEB as clock. It does NOT  ");
  $display(" perform any check about Address changing during a write cycle.     ");
  $display("								 	");
`endif
end
`endif

input WEB, REB, OEB, RCSB, WCSB;
buf (reb_state, REB),
    (oeb_state, OEB),
    (web_state, WEB),
    (rcsb_state, RCSB),
    (wcsb_state, WCSB);



input [`numAddr-1:0] RA;
wire  [`numAddr-1:0] ra_state,RA;
buf (ra_state[5], RA[5]),
    (ra_state[4], RA[4]),
    (ra_state[3], RA[3]),
    (ra_state[2], RA[2]),
    (ra_state[1], RA[1]),
    (ra_state[0], RA[0]);
    
input [`numAddr-1:0] WA;
wire  [`numAddr-1:0] wa_state,WA;
buf (wa_state[5], WA[5]),
    (wa_state[4], WA[4]),
    (wa_state[3], WA[3]),
    (wa_state[2], WA[2]),
    (wa_state[1], WA[1]),
    (wa_state[0], WA[0]);

input [`numOut-1:0] DI;
wire  [`numOut-1:0] di_state,DI;
buf (di_state[31], DI[31]),
    (di_state[30], DI[30]),
    (di_state[29], DI[29]),
    (di_state[28], DI[28]),
    (di_state[27], DI[27]),
    (di_state[26], DI[26]),
    (di_state[25], DI[25]),
    (di_state[24], DI[24]),
    (di_state[23], DI[23]),
    (di_state[22], DI[22]),
    (di_state[21], DI[21]),
    (di_state[20], DI[20]),
    (di_state[19], DI[19]),
    (di_state[18], DI[18]),
    (di_state[17], DI[17]),
    (di_state[16], DI[16]),
    (di_state[15], DI[15]),
    (di_state[14], DI[14]),
    (di_state[13], DI[13]),
    (di_state[12], DI[12]),
    (di_state[11], DI[11]),
    (di_state[10], DI[10]),
    (di_state[9], DI[9]),
    (di_state[8], DI[8]),
    (di_state[7], DI[7]),
    (di_state[6], DI[6]),
    (di_state[5], DI[5]),
    (di_state[4], DI[4]),
    (di_state[3], DI[3]),
    (di_state[2], DI[2]),
    (di_state[1], DI[1]),
    (di_state[0], DI[0]);
    
output [`numOut-1:0] DO;
wire   [`numOut-1:0] DO,do_state;
bufif0 (DO[31], do_state[31], enable),
       (DO[30], do_state[30], enable),
       (DO[29], do_state[29], enable),
       (DO[28], do_state[28], enable),
       (DO[27], do_state[27], enable),
       (DO[26], do_state[26], enable),
       (DO[25], do_state[25], enable),
       (DO[24], do_state[24], enable),
       (DO[23], do_state[23], enable),
       (DO[22], do_state[22], enable),
       (DO[21], do_state[21], enable),
       (DO[20], do_state[20], enable),
       (DO[19], do_state[19], enable),
       (DO[18], do_state[18], enable),
       (DO[17], do_state[17], enable),
       (DO[16], do_state[16], enable),
       (DO[15], do_state[15], enable),
       (DO[14], do_state[14], enable),
       (DO[13], do_state[13], enable),
       (DO[12], do_state[12], enable),
       (DO[11], do_state[11], enable),
       (DO[10], do_state[10], enable),
       (DO[9], do_state[9], enable),
       (DO[8], do_state[8], enable),
       (DO[7], do_state[7], enable),
       (DO[6], do_state[6], enable),
       (DO[5], do_state[5], enable),
       (DO[4], do_state[4], enable),
       (DO[3], do_state[3], enable),
       (DO[2], do_state[2], enable),
       (DO[1], do_state[1], enable),
       (DO[0], do_state[0], enable);

wire read_in_error;
wire write_full_in_error;
wire write_located_in_error;
wire [`numAddr-1:0] wa_del;
wire wa_d5;
wire wa_d4;
wire wa_d3;
wire wa_d2;
wire wa_d1;
wire wa_d0;
`ifdef ovi
buf (wa_del[5], WA[5]),
    (wa_del[4], WA[4]),
    (wa_del[3], WA[3]),
    (wa_del[2], WA[2]),
    (wa_del[1], WA[1]),
    (wa_del[0], WA[0]);
`else
buf (wa_del[5], wa_d5),
    (wa_del[4], wa_d4),
    (wa_del[3], wa_d3),
    (wa_del[2], wa_d2),
    (wa_del[1], wa_d1),
    (wa_del[0], wa_d0);
`endif
reg write_full_error;
reg write_located_error;
assign write_full_in_error = write_full_error;
assign write_located_in_error = write_located_error;

tpram64x32_behave u1 (rcsb_state,wcsb_state,wba_wcsb_enable,wba_enable,
                 wa_state,ra_state,web_state,reb_state,oeb_state,
                 di_state,do_state,enable,
                 write_located_in_error,write_full_in_error,wa_del);

initial
begin
  write_full_error = 1'b0;
  write_located_error = 1'b0;
end

`ifdef POLARIS_CBS

`else
always @(posedge write_full_error)    write_full_error <= 1'b0;
always @(posedge write_located_error) write_located_error <= 1'b0;
`endif

specify
  specparam DF        = 1.0,
            tAC       = 1.93*DF, // access time from address
            tCSRE     = 2.03*DF, // max access time (for pin RCSB)
            tCSOE     = 1.98*DF, // max read enable time (for pin RCSB)
            tARE      = 2.03*DF, // REB access time
            tAOE      = 0.9*DF, // OEB access time
            tWP       = 0.94*DF, // min WEB pulse width
            tWPC      = 0.75*DF, // min precharge time
            tWDO      = 2.21*DF, // access time with a write first
            tCSWP     = 1.0*DF, // min WCSB pulse width (for WCSB write)
            tCSWPC    = 0.74*DF, // min precharge time (for WCSB write)
            tCSWDO    = 2.08*DF, // access time with a write first
            tDIDO     = 1.91*DF, // access time with write of a new data
            tDS       = 0.179257*DF, // Data setup time
            tDH       = 0.575914*DF, // Data hold time
            tWAS      = 0.0*DF, // Address setup time (for pin WEB)
            tCSWAS    = 0.0*DF, // Address setup time (for pin WCSB)
            tCSHZ     = 0.56*DF, // RCSB disable time
            tCSLZ     = 1.55*DF, // RCSB output enable time
            tHZ       = 0.54*DF, // OEB disable time
            tLZ       = 0.82*DF, // OEB enable time 

`ifdef ovi
	    tWAH      = 0.245029*DF, // Address hold time (for pin WEB)
	    tCSWAH    = 0.284571*DF,  // Address hold time (for pin WCSB)
`else
            tWAH      = 0.245029*DF, // Address hold time (for pin WEB)
            tCSWAH    = 0.284571*DF,  // Address hold time (for pin WCSB)
`endif

            PATHPULSE$RCSB$DO = 0,
            PATHPULSE$WCSB$DO = 0,
            PATHPULSE$OEB$DO = 0,
            PATHPULSE$RA$DO  = 0,
            PATHPULSE$DI$DO  = 0,
            PATHPULSE$REB$DO = 0,
            PATHPULSE$WEB$DO = 0;

  (RCSB => DO[0]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[1]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[2]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[3]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[4]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[5]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[6]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[7]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[8]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[9]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[10]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[11]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[12]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[13]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[14]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[15]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[16]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[17]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[18]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[19]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[20]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[21]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[22]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[23]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[24]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[25]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[26]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[27]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[28]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[29]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[30]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);
  (RCSB => DO[31]) = (tCSRE,tCSRE,tCSHZ,tCSOE,tCSHZ,tCSOE);

  (negedge WEB => (DO[0] : DI[0])) = (tWDO,tWDO);
  (negedge WEB => (DO[1] : DI[1])) = (tWDO,tWDO);
  (negedge WEB => (DO[2] : DI[2])) = (tWDO,tWDO);
  (negedge WEB => (DO[3] : DI[3])) = (tWDO,tWDO);
  (negedge WEB => (DO[4] : DI[4])) = (tWDO,tWDO);
  (negedge WEB => (DO[5] : DI[5])) = (tWDO,tWDO);
  (negedge WEB => (DO[6] : DI[6])) = (tWDO,tWDO);
  (negedge WEB => (DO[7] : DI[7])) = (tWDO,tWDO);
  (negedge WEB => (DO[8] : DI[8])) = (tWDO,tWDO);
  (negedge WEB => (DO[9] : DI[9])) = (tWDO,tWDO);
  (negedge WEB => (DO[10] : DI[10])) = (tWDO,tWDO);
  (negedge WEB => (DO[11] : DI[11])) = (tWDO,tWDO);
  (negedge WEB => (DO[12] : DI[12])) = (tWDO,tWDO);
  (negedge WEB => (DO[13] : DI[13])) = (tWDO,tWDO);
  (negedge WEB => (DO[14] : DI[14])) = (tWDO,tWDO);
  (negedge WEB => (DO[15] : DI[15])) = (tWDO,tWDO);
  (negedge WEB => (DO[16] : DI[16])) = (tWDO,tWDO);
  (negedge WEB => (DO[17] : DI[17])) = (tWDO,tWDO);
  (negedge WEB => (DO[18] : DI[18])) = (tWDO,tWDO);
  (negedge WEB => (DO[19] : DI[19])) = (tWDO,tWDO);
  (negedge WEB => (DO[20] : DI[20])) = (tWDO,tWDO);
  (negedge WEB => (DO[21] : DI[21])) = (tWDO,tWDO);
  (negedge WEB => (DO[22] : DI[22])) = (tWDO,tWDO);
  (negedge WEB => (DO[23] : DI[23])) = (tWDO,tWDO);
  (negedge WEB => (DO[24] : DI[24])) = (tWDO,tWDO);
  (negedge WEB => (DO[25] : DI[25])) = (tWDO,tWDO);
  (negedge WEB => (DO[26] : DI[26])) = (tWDO,tWDO);
  (negedge WEB => (DO[27] : DI[27])) = (tWDO,tWDO);
  (negedge WEB => (DO[28] : DI[28])) = (tWDO,tWDO);
  (negedge WEB => (DO[29] : DI[29])) = (tWDO,tWDO);
  (negedge WEB => (DO[30] : DI[30])) = (tWDO,tWDO);
  (negedge WEB => (DO[31] : DI[31])) = (tWDO,tWDO);


  (negedge WCSB => (DO[0] : DI[0])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[1] : DI[1])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[2] : DI[2])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[3] : DI[3])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[4] : DI[4])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[5] : DI[5])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[6] : DI[6])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[7] : DI[7])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[8] : DI[8])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[9] : DI[9])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[10] : DI[10])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[11] : DI[11])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[12] : DI[12])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[13] : DI[13])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[14] : DI[14])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[15] : DI[15])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[16] : DI[16])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[17] : DI[17])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[18] : DI[18])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[19] : DI[19])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[20] : DI[20])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[21] : DI[21])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[22] : DI[22])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[23] : DI[23])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[24] : DI[24])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[25] : DI[25])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[26] : DI[26])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[27] : DI[27])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[28] : DI[28])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[29] : DI[29])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[30] : DI[30])) = (tCSWDO,tCSWDO);
  (negedge WCSB => (DO[31] : DI[31])) = (tCSWDO,tCSWDO);

  (DI[0] => DO[0]) = (tDIDO,tDIDO);
  (DI[1] => DO[1]) = (tDIDO,tDIDO);
  (DI[2] => DO[2]) = (tDIDO,tDIDO);
  (DI[3] => DO[3]) = (tDIDO,tDIDO);
  (DI[4] => DO[4]) = (tDIDO,tDIDO);
  (DI[5] => DO[5]) = (tDIDO,tDIDO);
  (DI[6] => DO[6]) = (tDIDO,tDIDO);
  (DI[7] => DO[7]) = (tDIDO,tDIDO);
  (DI[8] => DO[8]) = (tDIDO,tDIDO);
  (DI[9] => DO[9]) = (tDIDO,tDIDO);
  (DI[10] => DO[10]) = (tDIDO,tDIDO);
  (DI[11] => DO[11]) = (tDIDO,tDIDO);
  (DI[12] => DO[12]) = (tDIDO,tDIDO);
  (DI[13] => DO[13]) = (tDIDO,tDIDO);
  (DI[14] => DO[14]) = (tDIDO,tDIDO);
  (DI[15] => DO[15]) = (tDIDO,tDIDO);
  (DI[16] => DO[16]) = (tDIDO,tDIDO);
  (DI[17] => DO[17]) = (tDIDO,tDIDO);
  (DI[18] => DO[18]) = (tDIDO,tDIDO);
  (DI[19] => DO[19]) = (tDIDO,tDIDO);
  (DI[20] => DO[20]) = (tDIDO,tDIDO);
  (DI[21] => DO[21]) = (tDIDO,tDIDO);
  (DI[22] => DO[22]) = (tDIDO,tDIDO);
  (DI[23] => DO[23]) = (tDIDO,tDIDO);
  (DI[24] => DO[24]) = (tDIDO,tDIDO);
  (DI[25] => DO[25]) = (tDIDO,tDIDO);
  (DI[26] => DO[26]) = (tDIDO,tDIDO);
  (DI[27] => DO[27]) = (tDIDO,tDIDO);
  (DI[28] => DO[28]) = (tDIDO,tDIDO);
  (DI[29] => DO[29]) = (tDIDO,tDIDO);
  (DI[30] => DO[30]) = (tDIDO,tDIDO);
  (DI[31] => DO[31]) = (tDIDO,tDIDO);

  (negedge REB => (DO[0] : DI[0])) = (tARE,tARE);
  (negedge REB => (DO[1] : DI[1])) = (tARE,tARE);
  (negedge REB => (DO[2] : DI[2])) = (tARE,tARE);
  (negedge REB => (DO[3] : DI[3])) = (tARE,tARE);
  (negedge REB => (DO[4] : DI[4])) = (tARE,tARE);
  (negedge REB => (DO[5] : DI[5])) = (tARE,tARE);
  (negedge REB => (DO[6] : DI[6])) = (tARE,tARE);
  (negedge REB => (DO[7] : DI[7])) = (tARE,tARE);
  (negedge REB => (DO[8] : DI[8])) = (tARE,tARE);
  (negedge REB => (DO[9] : DI[9])) = (tARE,tARE);
  (negedge REB => (DO[10] : DI[10])) = (tARE,tARE);
  (negedge REB => (DO[11] : DI[11])) = (tARE,tARE);
  (negedge REB => (DO[12] : DI[12])) = (tARE,tARE);
  (negedge REB => (DO[13] : DI[13])) = (tARE,tARE);
  (negedge REB => (DO[14] : DI[14])) = (tARE,tARE);
  (negedge REB => (DO[15] : DI[15])) = (tARE,tARE);
  (negedge REB => (DO[16] : DI[16])) = (tARE,tARE);
  (negedge REB => (DO[17] : DI[17])) = (tARE,tARE);
  (negedge REB => (DO[18] : DI[18])) = (tARE,tARE);
  (negedge REB => (DO[19] : DI[19])) = (tARE,tARE);
  (negedge REB => (DO[20] : DI[20])) = (tARE,tARE);
  (negedge REB => (DO[21] : DI[21])) = (tARE,tARE);
  (negedge REB => (DO[22] : DI[22])) = (tARE,tARE);
  (negedge REB => (DO[23] : DI[23])) = (tARE,tARE);
  (negedge REB => (DO[24] : DI[24])) = (tARE,tARE);
  (negedge REB => (DO[25] : DI[25])) = (tARE,tARE);
  (negedge REB => (DO[26] : DI[26])) = (tARE,tARE);
  (negedge REB => (DO[27] : DI[27])) = (tARE,tARE);
  (negedge REB => (DO[28] : DI[28])) = (tARE,tARE);
  (negedge REB => (DO[29] : DI[29])) = (tARE,tARE);
  (negedge REB => (DO[30] : DI[30])) = (tARE,tARE);
  (negedge REB => (DO[31] : DI[31])) = (tARE,tARE);


  (RA[0] => DO[0]) = (tAC,tAC);
  (RA[0] => DO[1]) = (tAC,tAC);
  (RA[0] => DO[2]) = (tAC,tAC);
  (RA[0] => DO[3]) = (tAC,tAC);
  (RA[0] => DO[4]) = (tAC,tAC);
  (RA[0] => DO[5]) = (tAC,tAC);
  (RA[0] => DO[6]) = (tAC,tAC);
  (RA[0] => DO[7]) = (tAC,tAC);
  (RA[0] => DO[8]) = (tAC,tAC);
  (RA[0] => DO[9]) = (tAC,tAC);
  (RA[0] => DO[10]) = (tAC,tAC);
  (RA[0] => DO[11]) = (tAC,tAC);
  (RA[0] => DO[12]) = (tAC,tAC);
  (RA[0] => DO[13]) = (tAC,tAC);
  (RA[0] => DO[14]) = (tAC,tAC);
  (RA[0] => DO[15]) = (tAC,tAC);
  (RA[0] => DO[16]) = (tAC,tAC);
  (RA[0] => DO[17]) = (tAC,tAC);
  (RA[0] => DO[18]) = (tAC,tAC);
  (RA[0] => DO[19]) = (tAC,tAC);
  (RA[0] => DO[20]) = (tAC,tAC);
  (RA[0] => DO[21]) = (tAC,tAC);
  (RA[0] => DO[22]) = (tAC,tAC);
  (RA[0] => DO[23]) = (tAC,tAC);
  (RA[0] => DO[24]) = (tAC,tAC);
  (RA[0] => DO[25]) = (tAC,tAC);
  (RA[0] => DO[26]) = (tAC,tAC);
  (RA[0] => DO[27]) = (tAC,tAC);
  (RA[0] => DO[28]) = (tAC,tAC);
  (RA[0] => DO[29]) = (tAC,tAC);
  (RA[0] => DO[30]) = (tAC,tAC);
  (RA[0] => DO[31]) = (tAC,tAC);
  (RA[1] => DO[0]) = (tAC,tAC);
  (RA[1] => DO[1]) = (tAC,tAC);
  (RA[1] => DO[2]) = (tAC,tAC);
  (RA[1] => DO[3]) = (tAC,tAC);
  (RA[1] => DO[4]) = (tAC,tAC);
  (RA[1] => DO[5]) = (tAC,tAC);
  (RA[1] => DO[6]) = (tAC,tAC);
  (RA[1] => DO[7]) = (tAC,tAC);
  (RA[1] => DO[8]) = (tAC,tAC);
  (RA[1] => DO[9]) = (tAC,tAC);
  (RA[1] => DO[10]) = (tAC,tAC);
  (RA[1] => DO[11]) = (tAC,tAC);
  (RA[1] => DO[12]) = (tAC,tAC);
  (RA[1] => DO[13]) = (tAC,tAC);
  (RA[1] => DO[14]) = (tAC,tAC);
  (RA[1] => DO[15]) = (tAC,tAC);
  (RA[1] => DO[16]) = (tAC,tAC);
  (RA[1] => DO[17]) = (tAC,tAC);
  (RA[1] => DO[18]) = (tAC,tAC);
  (RA[1] => DO[19]) = (tAC,tAC);
  (RA[1] => DO[20]) = (tAC,tAC);
  (RA[1] => DO[21]) = (tAC,tAC);
  (RA[1] => DO[22]) = (tAC,tAC);
  (RA[1] => DO[23]) = (tAC,tAC);
  (RA[1] => DO[24]) = (tAC,tAC);
  (RA[1] => DO[25]) = (tAC,tAC);
  (RA[1] => DO[26]) = (tAC,tAC);
  (RA[1] => DO[27]) = (tAC,tAC);
  (RA[1] => DO[28]) = (tAC,tAC);
  (RA[1] => DO[29]) = (tAC,tAC);
  (RA[1] => DO[30]) = (tAC,tAC);
  (RA[1] => DO[31]) = (tAC,tAC);
  (RA[2] => DO[0]) = (tAC,tAC);
  (RA[2] => DO[1]) = (tAC,tAC);
  (RA[2] => DO[2]) = (tAC,tAC);
  (RA[2] => DO[3]) = (tAC,tAC);
  (RA[2] => DO[4]) = (tAC,tAC);
  (RA[2] => DO[5]) = (tAC,tAC);
  (RA[2] => DO[6]) = (tAC,tAC);
  (RA[2] => DO[7]) = (tAC,tAC);
  (RA[2] => DO[8]) = (tAC,tAC);
  (RA[2] => DO[9]) = (tAC,tAC);
  (RA[2] => DO[10]) = (tAC,tAC);
  (RA[2] => DO[11]) = (tAC,tAC);
  (RA[2] => DO[12]) = (tAC,tAC);
  (RA[2] => DO[13]) = (tAC,tAC);
  (RA[2] => DO[14]) = (tAC,tAC);
  (RA[2] => DO[15]) = (tAC,tAC);
  (RA[2] => DO[16]) = (tAC,tAC);
  (RA[2] => DO[17]) = (tAC,tAC);
  (RA[2] => DO[18]) = (tAC,tAC);
  (RA[2] => DO[19]) = (tAC,tAC);
  (RA[2] => DO[20]) = (tAC,tAC);
  (RA[2] => DO[21]) = (tAC,tAC);
  (RA[2] => DO[22]) = (tAC,tAC);
  (RA[2] => DO[23]) = (tAC,tAC);
  (RA[2] => DO[24]) = (tAC,tAC);
  (RA[2] => DO[25]) = (tAC,tAC);
  (RA[2] => DO[26]) = (tAC,tAC);
  (RA[2] => DO[27]) = (tAC,tAC);
  (RA[2] => DO[28]) = (tAC,tAC);
  (RA[2] => DO[29]) = (tAC,tAC);
  (RA[2] => DO[30]) = (tAC,tAC);
  (RA[2] => DO[31]) = (tAC,tAC);
  (RA[3] => DO[0]) = (tAC,tAC);
  (RA[3] => DO[1]) = (tAC,tAC);
  (RA[3] => DO[2]) = (tAC,tAC);
  (RA[3] => DO[3]) = (tAC,tAC);
  (RA[3] => DO[4]) = (tAC,tAC);
  (RA[3] => DO[5]) = (tAC,tAC);
  (RA[3] => DO[6]) = (tAC,tAC);
  (RA[3] => DO[7]) = (tAC,tAC);
  (RA[3] => DO[8]) = (tAC,tAC);
  (RA[3] => DO[9]) = (tAC,tAC);
  (RA[3] => DO[10]) = (tAC,tAC);
  (RA[3] => DO[11]) = (tAC,tAC);
  (RA[3] => DO[12]) = (tAC,tAC);
  (RA[3] => DO[13]) = (tAC,tAC);
  (RA[3] => DO[14]) = (tAC,tAC);
  (RA[3] => DO[15]) = (tAC,tAC);
  (RA[3] => DO[16]) = (tAC,tAC);
  (RA[3] => DO[17]) = (tAC,tAC);
  (RA[3] => DO[18]) = (tAC,tAC);
  (RA[3] => DO[19]) = (tAC,tAC);
  (RA[3] => DO[20]) = (tAC,tAC);
  (RA[3] => DO[21]) = (tAC,tAC);
  (RA[3] => DO[22]) = (tAC,tAC);
  (RA[3] => DO[23]) = (tAC,tAC);
  (RA[3] => DO[24]) = (tAC,tAC);
  (RA[3] => DO[25]) = (tAC,tAC);
  (RA[3] => DO[26]) = (tAC,tAC);
  (RA[3] => DO[27]) = (tAC,tAC);
  (RA[3] => DO[28]) = (tAC,tAC);
  (RA[3] => DO[29]) = (tAC,tAC);
  (RA[3] => DO[30]) = (tAC,tAC);
  (RA[3] => DO[31]) = (tAC,tAC);
  (RA[4] => DO[0]) = (tAC,tAC);
  (RA[4] => DO[1]) = (tAC,tAC);
  (RA[4] => DO[2]) = (tAC,tAC);
  (RA[4] => DO[3]) = (tAC,tAC);
  (RA[4] => DO[4]) = (tAC,tAC);
  (RA[4] => DO[5]) = (tAC,tAC);
  (RA[4] => DO[6]) = (tAC,tAC);
  (RA[4] => DO[7]) = (tAC,tAC);
  (RA[4] => DO[8]) = (tAC,tAC);
  (RA[4] => DO[9]) = (tAC,tAC);
  (RA[4] => DO[10]) = (tAC,tAC);
  (RA[4] => DO[11]) = (tAC,tAC);
  (RA[4] => DO[12]) = (tAC,tAC);
  (RA[4] => DO[13]) = (tAC,tAC);
  (RA[4] => DO[14]) = (tAC,tAC);
  (RA[4] => DO[15]) = (tAC,tAC);
  (RA[4] => DO[16]) = (tAC,tAC);
  (RA[4] => DO[17]) = (tAC,tAC);
  (RA[4] => DO[18]) = (tAC,tAC);
  (RA[4] => DO[19]) = (tAC,tAC);
  (RA[4] => DO[20]) = (tAC,tAC);
  (RA[4] => DO[21]) = (tAC,tAC);
  (RA[4] => DO[22]) = (tAC,tAC);
  (RA[4] => DO[23]) = (tAC,tAC);
  (RA[4] => DO[24]) = (tAC,tAC);
  (RA[4] => DO[25]) = (tAC,tAC);
  (RA[4] => DO[26]) = (tAC,tAC);
  (RA[4] => DO[27]) = (tAC,tAC);
  (RA[4] => DO[28]) = (tAC,tAC);
  (RA[4] => DO[29]) = (tAC,tAC);
  (RA[4] => DO[30]) = (tAC,tAC);
  (RA[4] => DO[31]) = (tAC,tAC);
  (RA[5] => DO[0]) = (tAC,tAC);
  (RA[5] => DO[1]) = (tAC,tAC);
  (RA[5] => DO[2]) = (tAC,tAC);
  (RA[5] => DO[3]) = (tAC,tAC);
  (RA[5] => DO[4]) = (tAC,tAC);
  (RA[5] => DO[5]) = (tAC,tAC);
  (RA[5] => DO[6]) = (tAC,tAC);
  (RA[5] => DO[7]) = (tAC,tAC);
  (RA[5] => DO[8]) = (tAC,tAC);
  (RA[5] => DO[9]) = (tAC,tAC);
  (RA[5] => DO[10]) = (tAC,tAC);
  (RA[5] => DO[11]) = (tAC,tAC);
  (RA[5] => DO[12]) = (tAC,tAC);
  (RA[5] => DO[13]) = (tAC,tAC);
  (RA[5] => DO[14]) = (tAC,tAC);
  (RA[5] => DO[15]) = (tAC,tAC);
  (RA[5] => DO[16]) = (tAC,tAC);
  (RA[5] => DO[17]) = (tAC,tAC);
  (RA[5] => DO[18]) = (tAC,tAC);
  (RA[5] => DO[19]) = (tAC,tAC);
  (RA[5] => DO[20]) = (tAC,tAC);
  (RA[5] => DO[21]) = (tAC,tAC);
  (RA[5] => DO[22]) = (tAC,tAC);
  (RA[5] => DO[23]) = (tAC,tAC);
  (RA[5] => DO[24]) = (tAC,tAC);
  (RA[5] => DO[25]) = (tAC,tAC);
  (RA[5] => DO[26]) = (tAC,tAC);
  (RA[5] => DO[27]) = (tAC,tAC);
  (RA[5] => DO[28]) = (tAC,tAC);
  (RA[5] => DO[29]) = (tAC,tAC);
  (RA[5] => DO[30]) = (tAC,tAC);
  (RA[5] => DO[31]) = (tAC,tAC);

  (OEB => DO[0]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[1]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[2]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[3]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[4]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[5]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[6]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[7]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[8]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[9]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[10]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[11]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[12]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[13]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[14]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[15]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[16]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[17]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[18]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[19]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[20]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[21]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[22]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[23]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[24]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[25]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[26]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[27]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[28]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[29]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[30]) = (0,0,tHZ,tAOE,tHZ,tAOE);
  (OEB => DO[31]) = (0,0,tHZ,tAOE,tHZ,tAOE);

  // Error Checking Routines Have Been Commented Out               //
  // as zero delay rtl simulations are only performed              //

  /*--------------- Error checks ----------------------------------

  $setup(negedge WA[0],negedge WEB &&& wba_wcsb_enable,tWAS,write_full_error);
  $setup(negedge WA[0],negedge WCSB &&& wba_enable,tCSWAS,write_full_error);
  $setup(posedge WA[0],negedge WEB &&& wba_wcsb_enable,tWAS,write_full_error);
  $setup(posedge WA[0],negedge WCSB &&& wba_enable,tCSWAS,write_full_error);
  $setup(negedge WA[1],negedge WEB &&& wba_wcsb_enable,tWAS,write_full_error);
  $setup(negedge WA[1],negedge WCSB &&& wba_enable,tCSWAS,write_full_error);
  $setup(posedge WA[1],negedge WEB &&& wba_wcsb_enable,tWAS,write_full_error);
  $setup(posedge WA[1],negedge WCSB &&& wba_enable,tCSWAS,write_full_error);
  $setup(negedge WA[2],negedge WEB &&& wba_wcsb_enable,tWAS,write_full_error);
  $setup(negedge WA[2],negedge WCSB &&& wba_enable,tCSWAS,write_full_error);
  $setup(posedge WA[2],negedge WEB &&& wba_wcsb_enable,tWAS,write_full_error);
  $setup(posedge WA[2],negedge WCSB &&& wba_enable,tCSWAS,write_full_error);
  $setup(negedge WA[3],negedge WEB &&& wba_wcsb_enable,tWAS,write_full_error);
  $setup(negedge WA[3],negedge WCSB &&& wba_enable,tCSWAS,write_full_error);
  $setup(posedge WA[3],negedge WEB &&& wba_wcsb_enable,tWAS,write_full_error);
  $setup(posedge WA[3],negedge WCSB &&& wba_enable,tCSWAS,write_full_error);
  $setup(negedge WA[4],negedge WEB &&& wba_wcsb_enable,tWAS,write_full_error);
  $setup(negedge WA[4],negedge WCSB &&& wba_enable,tCSWAS,write_full_error);
  $setup(posedge WA[4],negedge WEB &&& wba_wcsb_enable,tWAS,write_full_error);
  $setup(posedge WA[4],negedge WCSB &&& wba_enable,tCSWAS,write_full_error);
  $setup(negedge WA[5],negedge WEB &&& wba_wcsb_enable,tWAS,write_full_error);
  $setup(negedge WA[5],negedge WCSB &&& wba_enable,tCSWAS,write_full_error);
  $setup(posedge WA[5],negedge WEB &&& wba_wcsb_enable,tWAS,write_full_error);
  $setup(posedge WA[5],negedge WCSB &&& wba_enable,tCSWAS,write_full_error);
`ifdef ovi
  $hold(posedge WEB &&& wba_wcsb_enable,negedge WA[0],tWAH,write_full_error);
  $hold(posedge WCSB &&& wba_enable,negedge WA[0],tCSWAH,write_full_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge WA[0],tWAH,write_full_error);
  $hold(posedge WCSB &&& wba_enable,posedge WA[0],tCSWAH,write_full_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge WA[1],tWAH,write_full_error);
  $hold(posedge WCSB &&& wba_enable,negedge WA[1],tCSWAH,write_full_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge WA[1],tWAH,write_full_error);
  $hold(posedge WCSB &&& wba_enable,posedge WA[1],tCSWAH,write_full_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge WA[2],tWAH,write_full_error);
  $hold(posedge WCSB &&& wba_enable,negedge WA[2],tCSWAH,write_full_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge WA[2],tWAH,write_full_error);
  $hold(posedge WCSB &&& wba_enable,posedge WA[2],tCSWAH,write_full_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge WA[3],tWAH,write_full_error);
  $hold(posedge WCSB &&& wba_enable,negedge WA[3],tCSWAH,write_full_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge WA[3],tWAH,write_full_error);
  $hold(posedge WCSB &&& wba_enable,posedge WA[3],tCSWAH,write_full_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge WA[4],tWAH,write_full_error);
  $hold(posedge WCSB &&& wba_enable,negedge WA[4],tCSWAH,write_full_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge WA[4],tWAH,write_full_error);
  $hold(posedge WCSB &&& wba_enable,posedge WA[4],tCSWAH,write_full_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge WA[5],tWAH,write_full_error);
  $hold(posedge WCSB &&& wba_enable,negedge WA[5],tCSWAH,write_full_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge WA[5],tWAH,write_full_error);
  $hold(posedge WCSB &&& wba_enable,posedge WA[5],tCSWAH,write_full_error);
`else
  $setuphold(posedge WEB &&& wba_wcsb_enable,negedge WA[0],tWAS,tWAH,write_full_error, , , ,wa_d0);
  $setuphold(posedge WCSB &&& wba_enable,negedge WA[0],tCSWAS,tCSWAH,write_full_error, , , ,wa_d0);
  $setuphold(posedge WEB &&& wba_wcsb_enable,posedge WA[0],tWAS,tWAH,write_full_error, , , ,wa_d0);
  $setuphold(posedge WCSB &&& wba_enable,posedge WA[0],tCSWAS,tCSWAH,write_full_error, , , ,wa_d0);
  $setuphold(posedge WEB &&& wba_wcsb_enable,negedge WA[1],tWAS,tWAH,write_full_error, , , ,wa_d1);
  $setuphold(posedge WCSB &&& wba_enable,negedge WA[1],tCSWAS,tCSWAH,write_full_error, , , ,wa_d1);
  $setuphold(posedge WEB &&& wba_wcsb_enable,posedge WA[1],tWAS,tWAH,write_full_error, , , ,wa_d1);
  $setuphold(posedge WCSB &&& wba_enable,posedge WA[1],tCSWAS,tCSWAH,write_full_error, , , ,wa_d1);
  $setuphold(posedge WEB &&& wba_wcsb_enable,negedge WA[2],tWAS,tWAH,write_full_error, , , ,wa_d2);
  $setuphold(posedge WCSB &&& wba_enable,negedge WA[2],tCSWAS,tCSWAH,write_full_error, , , ,wa_d2);
  $setuphold(posedge WEB &&& wba_wcsb_enable,posedge WA[2],tWAS,tWAH,write_full_error, , , ,wa_d2);
  $setuphold(posedge WCSB &&& wba_enable,posedge WA[2],tCSWAS,tCSWAH,write_full_error, , , ,wa_d2);
  $setuphold(posedge WEB &&& wba_wcsb_enable,negedge WA[3],tWAS,tWAH,write_full_error, , , ,wa_d3);
  $setuphold(posedge WCSB &&& wba_enable,negedge WA[3],tCSWAS,tCSWAH,write_full_error, , , ,wa_d3);
  $setuphold(posedge WEB &&& wba_wcsb_enable,posedge WA[3],tWAS,tWAH,write_full_error, , , ,wa_d3);
  $setuphold(posedge WCSB &&& wba_enable,posedge WA[3],tCSWAS,tCSWAH,write_full_error, , , ,wa_d3);
  $setuphold(posedge WEB &&& wba_wcsb_enable,negedge WA[4],tWAS,tWAH,write_full_error, , , ,wa_d4);
  $setuphold(posedge WCSB &&& wba_enable,negedge WA[4],tCSWAS,tCSWAH,write_full_error, , , ,wa_d4);
  $setuphold(posedge WEB &&& wba_wcsb_enable,posedge WA[4],tWAS,tWAH,write_full_error, , , ,wa_d4);
  $setuphold(posedge WCSB &&& wba_enable,posedge WA[4],tCSWAS,tCSWAH,write_full_error, , , ,wa_d4);
  $setuphold(posedge WEB &&& wba_wcsb_enable,negedge WA[5],tWAS,tWAH,write_full_error, , , ,wa_d5);
  $setuphold(posedge WCSB &&& wba_enable,negedge WA[5],tCSWAS,tCSWAH,write_full_error, , , ,wa_d5);
  $setuphold(posedge WEB &&& wba_wcsb_enable,posedge WA[5],tWAS,tWAH,write_full_error, , , ,wa_d5);
  $setuphold(posedge WCSB &&& wba_enable,posedge WA[5],tCSWAS,tCSWAH,write_full_error, , , ,wa_d5);
`endif

  $setup(negedge DI[0],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[0],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[0],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[0],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[1],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[1],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[1],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[1],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[2],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[2],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[2],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[2],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[3],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[3],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[3],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[3],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[4],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[4],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[4],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[4],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[5],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[5],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[5],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[5],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[6],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[6],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[6],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[6],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[7],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[7],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[7],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[7],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[8],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[8],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[8],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[8],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[9],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[9],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[9],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[9],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[10],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[10],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[10],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[10],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[11],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[11],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[11],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[11],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[12],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[12],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[12],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[12],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[13],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[13],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[13],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[13],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[14],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[14],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[14],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[14],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[15],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[15],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[15],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[15],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[16],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[16],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[16],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[16],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[17],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[17],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[17],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[17],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[18],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[18],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[18],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[18],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[19],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[19],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[19],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[19],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[20],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[20],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[20],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[20],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[21],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[21],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[21],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[21],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[22],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[22],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[22],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[22],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[23],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[23],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[23],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[23],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[24],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[24],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[24],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[24],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[25],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[25],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[25],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[25],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[26],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[26],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[26],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[26],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[27],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[27],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[27],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[27],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[28],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[28],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[28],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[28],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[29],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[29],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[29],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[29],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[30],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[30],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[30],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[30],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(negedge DI[31],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(negedge DI[31],posedge WCSB &&& wba_enable,tDS,write_located_error);
  $setup(posedge DI[31],posedge WEB &&& wba_wcsb_enable,tDS,write_located_error);
  $setup(posedge DI[31],posedge WCSB &&& wba_enable,tDS,write_located_error);

  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[0],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[0],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[0],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[0],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[1],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[1],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[1],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[1],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[2],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[2],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[2],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[2],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[3],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[3],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[3],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[3],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[4],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[4],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[4],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[4],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[5],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[5],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[5],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[5],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[6],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[6],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[6],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[6],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[7],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[7],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[7],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[7],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[8],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[8],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[8],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[8],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[9],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[9],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[9],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[9],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[10],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[10],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[10],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[10],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[11],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[11],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[11],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[11],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[12],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[12],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[12],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[12],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[13],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[13],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[13],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[13],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[14],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[14],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[14],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[14],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[15],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[15],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[15],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[15],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[16],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[16],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[16],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[16],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[17],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[17],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[17],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[17],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[18],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[18],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[18],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[18],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[19],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[19],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[19],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[19],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[20],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[20],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[20],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[20],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[21],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[21],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[21],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[21],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[22],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[22],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[22],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[22],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[23],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[23],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[23],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[23],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[24],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[24],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[24],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[24],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[25],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[25],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[25],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[25],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[26],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[26],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[26],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[26],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[27],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[27],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[27],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[27],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[28],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[28],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[28],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[28],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[29],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[29],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[29],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[29],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[30],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[30],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[30],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[30],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,negedge DI[31],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,negedge DI[31],tDH,write_located_error);
  $hold(posedge WEB &&& wba_wcsb_enable,posedge DI[31],tDH,write_located_error);
  $hold(posedge WCSB &&& wba_enable,posedge DI[31],tDH,write_located_error);

  $width(posedge WEB &&& wba_wcsb_enable,tWPC,0,write_located_error);
  $width(posedge WCSB &&& wba_enable,tCSWPC,0,write_located_error);
  $width(negedge WEB &&& wba_wcsb_enable,tWP,0,write_located_error);
  $width(negedge WCSB &&& wba_enable,tCSWP,0,write_located_error);
  ----------------------------------------------------------------------*/
endspecify

endmodule
`endcelldefine

module tpram64x32_behave(rcsb_state,wcsb_state,wba_wcsb_enable,wba_enable,
                    wa_state,ra_state,web_state,reb_state,oeb_state,
                    di_state,do_state,enable,
                    write_located_error,write_full_error,wa_delayed);

reg [`numOut-1:0] memory[`wordDepth-1:0];
reg [`numOut-1:0] int_bus;
input [`numAddr-1:0] ra_state;
wire  [`numAddr-1:0] ra_state;
input [`numAddr-1:0] wa_state;
wire  [`numAddr-1:0] wa_state;
input  [`numOut-1:0] di_state;
wire   [`numOut-1:0] di_state;
output [`numOut-1:0] do_state;
wire   [`numOut-1:0] do_state;
assign do_state = int_bus;
output enable;
input write_full_error;
input write_located_error;
reg enable;
reg write_cycle;
integer write_adr;
input rcsb_state;
input wcsb_state;
input web_state;
input reb_state;
input oeb_state;
output wba_enable, wba_wcsb_enable;
reg rba_enable_int, wba_enable_int, rcsb_enable_int, wcsb_enable_int;
assign wba_enable = wba_enable_int;
assign wba_wcsb_enable = wba_enable_int && wcsb_enable_int;
input [`numAddr-1:0] wa_delayed;
integer n;
event transparent;

initial
begin : initialize
  write_cycle = 1'b0;
begin
  rba_enable_int = 1'b1;
  wba_enable_int = 1'b1;
end
end

task memoryError;
  begin
    if (`verbose == 2 || `verbose == 3)
    begin
      if (^wa_delayed === 1'bx || ^wa_delayed === 1'bz || wa_delayed !== write_adr)
      begin
        for (n=0; n < `wordDepth; n = n + 1)
          memory[n] = `numOut'bx;
      end
      else
      begin
        memory[wa_delayed] = `numOut'bx;
      end
      -> transparent;
    end
 end
endtask

task WarningWR;
  input [1024:1] msg;
  begin
    if ((`verbose == 1 || `verbose == 3) && wba_enable_int !== 1'b0 && wcsb_enable_int !== 1'b0)
    begin
      $display("%.1f : %m : %0s",$realtime,msg);
    end
  end
endtask

task WarningRD;
  input [1024:1] msg;
  begin
    if ((`verbose == 1 || `verbose == 3) && rba_enable_int !== 1'b0 && rcsb_enable_int !== 1'b0)
    begin
      $display("%.1f : %m : %0s",$realtime,msg);
    end
  end
endtask

//--------------------- check read chip select signal ------------------
always @(rcsb_state)
begin
  if (rcsb_state === 1'bx || rcsb_state === 1'bz)
  begin
    WarningRD("RCSB is unknown.");
    if (`verbose == 2 || `verbose == 3)
      rcsb_enable_int = 'bx;
    else
      rcsb_enable_int = 'b1;
  end
  else if (rcsb_state === 0)
    rcsb_enable_int = 'b1;
  else
    rcsb_enable_int = 'b0;
end

//--------------------- check write chip select signal ------------------
always @(wcsb_state)
begin
  if (wcsb_state === 1'bx || wcsb_state === 1'bz)
  begin
    WarningWR("WCSB is unknown.");
    if (`verbose == 2 || `verbose == 3)
      wcsb_enable_int = 'bx;
    else
      wcsb_enable_int = 'b1;
  end
  else if (wcsb_state === 0)
    wcsb_enable_int = 'b1;
  else
    wcsb_enable_int = 'b0;
end


//-------------------- check enable signal ------------------
always @(oeb_state or rba_enable_int or rcsb_enable_int) 
begin : gen_enable
  if (oeb_state === 1'bx || oeb_state === 1'bz)
  begin
    WarningRD("OEB is unknown.");
    if (`verbose == 2 || `verbose == 3)
      enable = oeb_state || ~(rba_enable_int && rcsb_enable_int);
    else
      enable = ~(rba_enable_int && rcsb_enable_int);
  end
  else
    enable = oeb_state || ~(rba_enable_int && rcsb_enable_int);
end

//----------------------------- READ CYCLE ------------------
always @(reb_state or ra_state or transparent or rba_enable_int or rcsb_enable_int)
begin : read_cycle
  if (rba_enable_int === 1'b1 && rcsb_enable_int === 1'b1)
  begin
    if (reb_state === 1'bx || reb_state === 1'bz)
    begin
      WarningRD("REB is unknown Ignoring current data.");
      if (`verbose == 2 || `verbose == 3)
        int_bus = `numOut'bx;
    end
    if (reb_state === 1'b0)
    begin : raddress_check
      if (^ra_state === 1'bx || ^ra_state === 1'bz)
      begin
        WarningRD("Read address is unknown - cannot access memory.");
        if (`verbose == 2 || `verbose == 3)
          int_bus = `numOut'bx;
      end
      else if (ra_state >= `wordDepth)
      begin
        WarningRD("Read address is out of range - cannot access memory.");
        if (`verbose == 2 || `verbose == 3)
          int_bus = `numOut'bx;
      end
      else
        int_bus = memory[ra_state];
    end    
  end
end

//----------------------------- WRITE CYCLE ------------------
always @(web_state or di_state or wba_enable_int or wcsb_enable_int or wa_delayed or write_adr or write_cycle)
begin : write_cyc
  if (wba_enable_int === 1'bx && wcsb_enable_int !== 1'b0 && web_state !== 1'b1)
    memoryError;
  else if (wba_enable_int === 1'b1)
  begin : wcsb_check
    if (wcsb_enable_int === 1'bx && web_state !== 1'b1)
    begin
      memoryError;
    end
    else if (wcsb_enable_int === 1'b1)
    begin : web_check
      if (web_state === 1'bx || web_state === 1'bz)
      begin
        WarningWR("WEB is unknown Ignoring current data.");
        memoryError;
      end
      if (web_state === 1'b0)
      begin : waddress_check
        if (write_cycle === 1'b0)
        begin
          write_cycle = 1'b1;
          write_adr = wa_delayed;
        end
        if (^di_state === 1'bx || ^di_state === 1'bz)
        begin
//          WarningWR("Data Input unknown during write");
        end
        if (^wa_delayed === 1'bx || ^wa_delayed === 1'bz)
        begin
          WarningWR("Write address is unknown - cannot access memory.");
          memoryError;
        end
        else if (wa_delayed >= `wordDepth)
          WarningWR("Write address is out of range - cannot access memory.");
        else
        begin
          memory[wa_delayed] = di_state;
          -> transparent;         
        end
      end
      if (web_state === 1'b1)
      begin
`ifdef POLARIS_CBS

`else
        if (write_cycle === 1'b1 && wa_delayed !== write_adr)
        begin
          WarningWR("Write address changing during write cycle.");
          memoryError;
        end
`endif
        write_cycle = 1'b0;
      end
    end
    else 
    begin
`ifdef POLARIS_CBS

`else
      if (write_cycle === 1'b1 && wa_delayed !== write_adr)
      begin
        WarningWR("Write address changing during write cycle ended by Write Chip Select de-asserted.");
        memoryError;
      end
`endif
      write_cycle = 1'b0;
    end
  end
  else 
  begin
`ifdef POLARIS_CBS

`else
  if (write_cycle === 1'b1 && wa_delayed !== write_adr)
    begin
      WarningWR("Write address changing during write cycle ended by Bank Address de-asserted.");
      memoryError;
    end
`endif
  write_cycle = 1'b0;
  end
end

`ifdef POLARIS_CBS

`else
always @(write_located_error)
begin : set_write_error
  memoryError;
end

always @(write_full_error)
begin : set_write_ferror
  write_adr = wa_delayed + 1;
  memoryError;
end
`endif

endmodule

`undef numAddr
`undef numOut
`undef wordDepth
`undef verbose
`undef ovi
