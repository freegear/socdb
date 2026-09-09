// -------------------------------------------------------------------------
// This confidential and proprietary software may be used only as authorised
// by a licensing agreement from ARM Limited
//                (c) COPYRIGHT 2003 ARM Limited
//                ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised copies and
// copies may only be made to the extent permitted by a licensing agreement
// from ARM Limited.
// -------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name           : a926ejsSysDebug.v,v
// File Revision       : 1.9
//
// Release Information : ARM926EJS_r0p5-00rel0
// -------------------------------------------------------------------------

`timescale 1 ns / 10 ps

`include "smt_debug.vh"

`undef MEM_NSEQ
`undef MEM_SEQ
`undef MEM_IDLE
`undef MEM_KILLED

`define MEM_NSEQ    2'b00
`define MEM_SEQ     2'b01
`define MEM_IDLE    2'b10
`define MEM_KILLED  2'b11

`undef CP_WAIT
`undef CP_ABSENT
`undef CP_GO
`undef CP_LAST

`define CP_WAIT     2'b00
`define CP_ABSENT   2'b10
`define CP_GO       2'b01
`define CP_LAST     2'b11

module a926ejsSysDebug(
  // Inputs
  CLK, CLKEN, HRESETn, InMREQ, ISEQ, IKILL, ITBIT, IJBIT, IA, INSTR, 
  CPINSTR, ICRD, ITCMRD, IEXTRD, IBIURD, CHSD, CHSE, CHSDE, CHSEX, 
  IEXTBIUReady, IEXTBlocked, DEXTBIUReady, DEXTBlocked, ITCMReady, 
  DTCMReady, IRCS, IRSEQ, IRnRW, IRADDR, IRIDLE, IRWBL, IRWD, IRRD, 
  IRWAIT, IRDMAEN, IRDMAADDR, IRDMACS, DRCS, DRSEQ, DRnRW, DRADDR, 
  DRIDLE, DRWBL, DRWD, DRRD, DRWAIT, DRDMAEN, DRDMAADDR, DRDMACS
  );
  input CLK;
  input CLKEN;
  input HRESETn;

  // Instruction side signals
  
  input InMREQ;
  input ISEQ;
  input IKILL;

  input ITBIT;
  input IJBIT;
  
  input [31:0] IA;
   
  input [31:0] INSTR;

  input [31:0] CPINSTR;
  input [31:0] ICRD;
  input [31:0] ITCMRD;
  input [31:0] IEXTRD;
  input [31:0] IBIURD;

  input [1:0]  CHSD;
  input [1:0]  CHSE;
  input [1:0]  CHSDE;
  input [1:0]  CHSEX;

  input IEXTBIUReady;
  input IEXTBlocked; 
  input DEXTBIUReady;
  input DEXTBlocked;

  input ITCMReady;
  input DTCMReady;

  input IRCS;
  input IRSEQ;
  input IRnRW;
  input [17:0] IRADDR;
  input IRIDLE;
  input [3:0]  IRWBL;
  input [31:0] IRWD;
  input [31:0] IRRD;
  input        IRWAIT;
  input        IRDMAEN;
  input [17:0] IRDMAADDR;
  input        IRDMACS;


  input DRCS;
  input DRSEQ;
  input DRnRW;
  input [17:0] DRADDR;
  input DRIDLE;
  input [3:0]  DRWBL;
  input [31:0] DRWD;
  input [31:0] DRRD;
  input        DRWAIT;
  input        DRDMAEN;
  input [17:0] DRDMAADDR;
  input        DRDMACS;
  
  
  
  reg [1:0] IFnext;
  wire [1:0] InstructionFetch;

  reg [5*8:1] decode_InstructionFetch;

  wire [256*8:1] instr_FE;
  wire [256*8:1] instr_DE;
  wire [256*8:1] instr_EX;
  reg  [256*8:1] instr_ME;
  reg  [256*8:1] instr_WB;

  wire [6*8:1] 	 CHSD_s;
  wire [6*8:1] 	 CHSE_s;

  wire [6*8:1] 	 CHSDE_s;
  wire [6*8:1] 	 CHSEX_s;
  
  
  reg [31:0]  IAFE;
  reg [31:0]  IADE;
  reg [31:0]  IAEX;
  reg [31:0]  IAME;
  reg [31:0]  IAWB;
  reg [31:0]  IAFeold;
  reg [31:0]  IADeold;
  reg [31:0]  IAExold;
  reg [31:0]  IAMeold;
  reg [31:0]  IAWbold;
  reg [31:0]  IAFenew;

  reg 	      ITBITFE;
  reg 	      ITBITDE;
  reg 	      ITBITEX;
  reg 	      ITBITME;
  reg 	      ITBITWB;

  wire [31:0]  InstFE;
  wire [31:0]  InstDE; 
  wire [31:0]  InstEX;
  reg [31:0]  InstME;
  reg [31:0]  InstWB;
  reg [31:0]  InstFEold;
  reg [31:0]  InstDEold;
  reg [31:0]  InstEXold;
  reg [31:0]  InstMEold;
  reg [31:0]  InstWBold;
  reg [31:0]  InstFEdebug;

  wire [31:0]  InstDEdebug;
  wire [31:0]  InstEXdebug;


  reg 	      IJBITFE;
  reg 	      IJBITDE;
  reg 	      IJBITEX;
  reg 	      IJBITME;
  reg 	      IJBITWB;
  

  wire        CoreClk;
  reg         CLKENT2;
  
  wire        IMREQFE;
  reg         IMREQFENoKill;
  reg [31:0]  InstDENoKill;
  reg [31:0]  InstEXNoKill;

  reg [17:0]  pIRADDR;
  reg [17:0]  pDRADDR;
  wire [17:0] pIADDRinc;
  wire [17:0] pDADDRinc;
  
  reg 	      pIRWAIT;
  reg 	      pIRCS; 	
  reg 	      pIRSEQ;
  reg 	      pIRDMAEN;
  wire 	      IRCSSEQ;
  reg 	      pIWaitState;
  wire        IWaitState;  
  

  reg 	      pDRWAIT;
  reg 	      pDRCS; 	
  reg 	      pDRSEQ;
  reg 	      pDRDMAEN;
  reg 	      pDWaitState;
  wire        DWaitState;  

  assign IRCSSEQ = IRCS & IRSEQ;
  
  always @(posedge CLK) begin
    if (IRCS) begin
      pIRADDR <= IRADDR;
      pIRSEQ  <= IRSEQ;
    end
    if (DRCS) begin
      pDRADDR <= DRADDR;
      pDRSEQ  <= DRSEQ;
    end
  end // always @ (posedge CLK)

  always @(posedge CLK) begin
    pIRCS <= IRCS;
    pIRWAIT <= IRWAIT;
    pIRDMAEN <= IRDMAEN;    
    pDRCS <= DRCS;
    pDRWAIT <= DRWAIT;
    pDRDMAEN <= DRDMAEN;
  end
 
  assign pIADDRinc = pIRADDR + 1'b1;

  assign pDADDRinc = pDRADDR + 1'b1;

 

  assign DWaitState = (pDRCS & pDRWAIT & ~pDRDMAEN) | (pDWaitState & pDRWAIT);

  always @(posedge CLK) begin
    pDWaitState <= DWaitState;
  end

  assign IWaitState = (pIRCS & pIRWAIT & ~pIRDMAEN) | (pIWaitState & pIRWAIT);

  always @(posedge CLK) begin
    pIWaitState <= IWaitState;
  end


  // check addresses are actually sequential if I/DRSEQ asserted  
			 
  always @(negedge CLK) begin
    if (IRCS & ~IRDMAEN & IRSEQ & ~IWaitState) begin
      if (pIADDRinc != IRADDR) begin
	fatal("IRSEQ asserted, and IRADDR not sequential");
      end 
    end 
  end 

  
  always @(negedge CLK) begin
    if (DRCS & ~DRDMAEN & DRSEQ & ~DWaitState) begin
      if (pDADDRinc != DRADDR) begin
	fatal("DRSEQ asserted, and DRADDR not sequential");
      end 
    end 
  end 


  reg IRDMALastAccess;

  always @(posedge CLK or negedge HRESETn ) begin
    if (!HRESETn) 
      IRDMALastAccess <= 1'b0;
    else if (IRDMAEN)
      IRDMALastAccess <= 1'b1;
    else if (IRCS & ~IWaitState)
      IRDMALastAccess <= 1'b0;
    else
      IRDMALastAccess <= IRDMALastAccess;
  end 
      
  always @(negedge CLK) begin
    if (IRCS & ~IRDMAEN & IRSEQ & ~IWaitState) begin
      if (IRDMALastAccess) begin
	fatal("IRSEQ asserted after IRDMAEN");
      end 
    end 
  end 

  reg DRDMALastAccess;

  always @(posedge CLK or negedge HRESETn ) begin
    if (!HRESETn) 
      DRDMALastAccess <= 1'b0;
    else if (DRDMAEN)
      DRDMALastAccess <= 1'b1;
    else if (DRCS & ~DWaitState)
      DRDMALastAccess <= 1'b0;
    else
      DRDMALastAccess <= DRDMALastAccess;
  end 

    
  always @(negedge CLK) begin
    if (DRCS & ~DRDMAEN & DRSEQ & ~DWaitState) begin
      if (DRDMALastAccess) begin
	fatal("DRSEQ asserted after DRDMAEN");
      end 
    end 
  end 

  


  // check RSEQ always asserted for wait-states
  
  always @(negedge CLK) begin
    if (IWaitState) begin
      if (~IRSEQ) begin
 	fatal("IRSEQ de-asserted during waited cycle");
      end 
    end 
  end

  
  always @(negedge CLK) begin
    if (DWaitState) begin
      if (~DRSEQ) begin
 	fatal("DRSEQ de-asserted during waited cycle");
      end 
    end 
  end 


  // check no core CS when idle

  always @(negedge CLK) begin
    if (IRCS & IRIDLE & ~IRDMAEN) begin
      fatal("IRCS and IRIDLE both 1");
    end
    if (DRCS & DRIDLE & ~DRDMAEN) begin
      fatal("DRCS and DRIDLE both 1");
    end 
  end
  

  // check that DMA inputs propagate correctly to TCM outputs if D/IRDMAEN asserted
  // note that the MACS/RCS connection is OR rather than mux
  //
  

  always @(negedge CLK) begin
    if (IRDMAEN) begin
      if (IRADDR != IRDMAADDR) begin
	fatal("IRADDR != IRDMAADDR for DMA access");
      end 
      if (~IRCS & IRDMACS) begin
	fatal("IRCS incorrect for DMA access");
      end 
    end 
  end 

  always @(negedge CLK) begin
    if (DRDMAEN) begin
      if (DRADDR != DRDMAADDR) begin
	fatal("DRADDR != DRDMAADDR for DMA access");
      end 
      if (~DRCS & DRDMACS) begin
	fatal("DRCS incorrect for DMA access");
      end 
    end 
  end 
  
	

  always @(negedge CLK) begin
    CLKENT2 <= CLKEN;
  end

  assign CoreClk = CLK & CLKENT2;


  always @(posedge CLK) begin
    IMREQFENoKill <= ~InMREQ;
    IAFE          <= IA;
    ITBITFE       <= ITBIT;
    IJBITFE       <= IJBIT;
  end

  assign IMREQFE = IMREQFENoKill & ~IKILL;

  always @(posedge CoreClk) begin
      InstFEold <= InstFE;
  end

  assign InstFE = IMREQFE ? INSTR : InstFEold;

  always @(InstFE)
  begin
    if (^(InstFE) !== 1'bx)
      InstFEdebug = InstFE;
    else
      InstFEdebug = 32'h0000_0000;
  end



  always @(posedge CoreClk) begin
    InstDEold <= InstDE;
    if (~InMREQ) begin
      InstDENoKill <= InstFE;
      IADE <= IAFE;
      ITBITDE <= ITBITFE;
      IJBITDE <= IJBITFE;
    end
  end

  assign InstDE = IKILL ? InstDEold : InstDENoKill;

  assign InstDEdebug = HRESETn ? InstDE : 32'h0000_0000;


  always @(posedge CoreClk) begin
    InstEXold <= InstEX;
    if (~InMREQ) begin
      InstEXNoKill <= InstDE;
      IAEX <= IADE;
      ITBITEX <= ITBITDE;
      IJBITEX <= IJBITDE;
    end
  end

  assign InstEX = IKILL ? InstEXold : InstEXNoKill;

  assign InstEXdebug = HRESETn ? InstEX : 32'h0000_0000;

  always @(posedge CoreClk) begin
    InstME <= InstEX; IAME <= IAEX; ITBITME <= ITBITEX ;IJBITME <= IJBITEX; instr_ME <= instr_EX;
    InstWB <= InstME; IAWB <= IAME; ITBITWB <= ITBITME; IJBITWB <= IJBITME; instr_WB <= instr_ME;
  end


  a926ejsSysDebugDisass uDisassFe (
				   .A(IAFE),
				   .I(InstFEdebug),
				   .TBIT(ITBITFE),
				   .JBIT(IJBITFE),
				   .decode_instr(instr_FE)
				   );

  a926ejsSysDebugDisass uDisassDe (
				   .A(IADE),
				   .I(InstDEdebug),
				   .TBIT(ITBITDE),
				   .JBIT(IJBITDE),
				   .decode_instr(instr_DE)
				   );
  
  a926ejsSysDebugDisass uDisassEx (
				   .A(IAEX),
				   .I(InstEXdebug),
				   .TBIT(ITBITEX),
				   .JBIT(IJBITEX),
				   .decode_instr(instr_EX)
				   );

  
  function [6*8:1] decode_coproc;
    input [1:0] CHS;

    begin
      if ((CHS[1] === 1'bx) | (CHS[0] === 1'bx))
        decode_coproc = "XXXXXX";
      else begin
        case (CHS)
	  `CP_WAIT     : decode_coproc = "WAIT  ";
	  `CP_ABSENT   : decode_coproc = "ABSENT";
	  `CP_GO       : decode_coproc = "GO    ";
	  `CP_LAST     : decode_coproc = "LAST  ";
	  default      : decode_coproc = "XXXXXX";
        endcase // case(CHS)
      end
    end
  endfunction // decode_copro
  
  assign CHSD_s = decode_coproc(CHSD);
  assign CHSE_s = decode_coproc(CHSE);

  assign CHSDE_s = decode_coproc(CHSDE);
  assign CHSEX_s = decode_coproc(CHSEX);

// checks for block-level clock gating

task fatal;
input [42*8:1] msg;
begin    
  $display("%d fatal error - %s\n",$time,msg);
`ifndef __NO_STOP__
  $stop;
`endif //__NO_STOP__
end

endtask

always @(posedge CLK) begin

  if (IEXTBlocked & IEXTBIUReady) begin
    fatal("IEXTBIUBlocked/IEXTBIUReady both 1");
  end

  if (DEXTBlocked & DEXTBIUReady) begin
    fatal("DEXTBlocked/DEXTBIUReady both 1");
  end

end




  
endmodule // a926ejsSysDebug

module a926ejsSysDebugDisass (/*AUTOARG*/
  // Outputs
  decode_instr, 
  // Inputs
  A, I, TBIT, JBIT
  );

  input [31:0] A;
  input [31:0] I;
  input        TBIT;
  input        JBIT;

  output [2048:1] decode_instr;

  wire [2048:1]   disass_instr;
  
// verilint translate off
  disass uDisass 
    (
     .data2 (I),
     .data (I),
     .addr (A),
     .tbit (TBIT),
     .disass (disass_instr)
     );
// verilint translate on

  assign decode_instr = (JBIT ? "JAVA" :
			 TBIT ? "THUMB" :
			 disass_instr
			 );

endmodule // a926ejsSysDebugDisass

