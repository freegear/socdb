`timescale 1ns / 1ps

module SDRAM (HCLK, HRESETn, HADDR, HTRANS, HWRITE, HSIZE, HSELMEM, HWDATA, HRDATA,
              HREADYin, HREADYout, HRESP,
              RetryAddr);

  input          HCLK;
  input          HRESETn;
  input   [31:0] HADDR;
  input   [1:0]  HTRANS;
  input          HWRITE;
  input   [2:0]  HSIZE;
  input          HSELMEM;
  input   [31:0] HWDATA;
  input          HREADYin;

  output  [31:0] HRDATA;
  output         HREADYout;
  output  [1:0]  HRESP;

  input   [31:0] RetryAddr;

//------------------------------------------------------------------------------
//  Constant declarations
//------------------------------------------------------------------------------
// HTRANS transfer type signal encoding
  `define TRN_IDLE   2'b00
  `define TRN_BUSY   2'b01
  `define TRN_NONSEQ 2'b10
  `define TRN_SEQ    2'b11

// HSIZE transfer type signal encoding
  `define SZ_BYTE 3'b000
  `define SZ_HALF 3'b001
  `define SZ_WORD 3'b010

// HRESP transfer response signal encoding
  `define RSP_OKAY   2'b00
  `define RSP_ERROR  2'b01
  `define RSP_RETRY  2'b10
  `define RSP_SPLIT  2'b11

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

  wire         ACRegEn;  // Enable for address and control registers
  wire         CSN;
  wire         WEN;
  wire [3:0]   BWEN;
  reg          HselReg;  // HSELMEM register
  reg          RegValid;
  reg  [31:0]  HaddrReg;
  reg  [1:0]   HtransReg;
  reg  [2:0]   HsizeReg;
  wire [31:2]  HaddrRam;

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Valid transfer detection
//------------------------------------------------------------------------------
// The slave must only respond to a valid transfer, so this must be detected.
 
  always @(negedge (HRESETn) or posedge (HCLK))
  begin
    if (!HRESETn)
      HselReg <= #2 1'b0;
    else
    begin
      if (HREADYin)
        HselReg <= #2 HSELMEM;
    end
  end
 
//------------------------------------------------------------------------------
// Address and control registers
//------------------------------------------------------------------------------
// Registers are used to store the address and control signals from the address
//  phase for use in the data phase of the transfer.
// Only enabled when the HREADYin input is HIGH and the module is addressed.

  assign ACRegEn = HSELMEM & HREADYin;
  
  always @(HselReg or HtransReg) begin
    // synopsys translate_off
    `ifdef RTL_SIM
      RegValid = #2 (HselReg == 1'b1 && (HtransReg == `TRN_NONSEQ ||
                                         HtransReg == `TRN_SEQ)) ? 1'b1 : 1'b0;
    `else
    // synopsys translate_on
      RegValid = (HselReg == 1'b1 && (HtransReg == `TRN_NONSEQ ||
                                         HtransReg == `TRN_SEQ)) ? 1'b1 : 1'b0;
    // synopsys translate_off
    `endif
    // synopsys translate_on
  end

  always @(negedge (HRESETn) or posedge (HCLK))
  begin
    if (!HRESETn)
    begin
      HaddrReg  <= 32'h0000_0000;
      HtransReg <= 2'b00;
      HsizeReg  <= 3'b000;
    end
    else
    begin
      if (ACRegEn)
      begin
        HaddrReg  <= HADDR[31:0];
        HtransReg <= HTRANS;
        HsizeReg  <= HSIZE;
      end
    end
  end

reg   HREADY_reg;
always @(negedge HRESETn or posedge HCLK) begin
  if (!HRESETn) begin
    HREADY_reg <= 1'b1;
  end
  else if(ACRegEn & HWRITE & HTRANS[1]) begin
    HREADY_reg <= 1'b0;
  end
  else begin
    HREADY_reg <= 1'b1;
  end
end

reg  [1:0]  HRESPRetry;
reg         HREADYRetry;
reg         RetryOn;

always @(negedge HRESETn or posedge HCLK) begin
  if (~HRESETn) RetryOn <= 1'b0;
  else if (HADDR == RetryAddr) RetryOn <= 1'b1;
end

reg  [2:0]  RetryState, nRetryState;

always @(posedge HCLK or negedge HRESETn) begin
  if (~HRESETn) RetryState <= 0;
  else RetryState <= nRetryState;
end

always @(RetryState or RetryOn) begin

  nRetryState = RetryState;
  HRESPRetry = 2'b00;
  HREADYRetry = 1'b1;
 
  case (RetryState) 
    3'b000 : begin
      if(RetryOn) nRetryState = 3'b001;
    end
    3'b001 : begin
      HRESPRetry = 2'b00;
      HREADYRetry = 1'b1;
      nRetryState = 3'b010;
    end
    3'b010 : begin
      HRESPRetry = 2'b10;
      HREADYRetry = 1'b0;
      nRetryState = 3'b011;
    end
    3'b011 : begin
      HRESPRetry = 2'b10;
      HREADYRetry = 1'b1;
      nRetryState = 3'b100;
    end
    3'b100 : begin
      HRESPRetry = 2'b10;
      HREADYRetry = 1'b0;
      nRetryState = 3'b101;
    end
    3'b101 : begin
      HRESPRetry = 2'b10;
      HREADYRetry = 1'b1;
      nRetryState = 3'b110;
    end
    3'b110 : begin
      HRESPRetry = 2'b00;
      HREADYRetry = 1'b1;
//      nRetryState = 3'b111;
      nRetryState = 3'b001;
    end
//    3'b111 : begin
//      HRESPRetry = 2'b00;
//      HREADYRetry = 1'b1;
//      nRetryState = 3'b001;
//    end
  endcase
end


//------------------------------------------------------------------------------
//  Memory read and write
//------------------------------------------------------------------------------

assign #2 HaddrRam = (~HREADY_reg) ? HaddrReg[31:2] : HADDR[31:2];
assign WEN = ~(~HREADY_reg & RegValid);
assign BWEN = (HsizeReg[1:0] == 2'b10) ? 4'h0 :
            (HsizeReg[1:0] == 2'b01 && HaddrReg[1]) ? 4'h3 :
            (HsizeReg[1:0] == 2'b01 && ~HaddrReg[1]) ? 4'hc :
            (HsizeReg[1:0] == 2'b00 && HaddrReg[1:0] == 2'b11) ? 4'h7 :
            (HsizeReg[1:0] == 2'b00 && HaddrReg[1:0] == 2'b10) ? 4'hb :
            (HsizeReg[1:0] == 2'b00 && HaddrReg[1:0] == 2'b01) ? 4'hd :
            (HsizeReg[1:0] == 2'b00 && HaddrReg[1:0] == 2'b00) ? 4'he :
            4'hf;
assign #2 CSN = ~(HselReg | HSELMEM);

// assign HREADYout = HREADY_reg;
assign HREADYout = (RetryOn) ? HREADYRetry : HREADY_reg;

// The response will always be OKAY to show that the transfer has been performed
//  successfully.

//  assign HRESP = `RSP_OKAY;
  assign HRESP = (RetryOn) ? HRESPRetry : `RSP_OKAY;

// CSN, WEN, BWEN, HaddrRam

reg [31:0] MEM[30'h20000000:30'h21400000];

always @(posedge HCLK) begin
 if(~CSN & ~WEN) MEM[HaddrRam] <= HWDATA;
end

reg  [31:0] HRDATA;
always @(posedge HCLK) begin
 if(~CSN & WEN) HRDATA <= MEM[HaddrRam];
end

endmodule

// --================================= End ===================================--
