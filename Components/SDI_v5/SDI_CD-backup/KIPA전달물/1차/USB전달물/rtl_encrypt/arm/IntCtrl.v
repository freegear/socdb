`timescale 1ns / 1ps

module IntCtrl (HCLK, HRESETn, HSEL_IRC,
              HADDR, HTRANS, HWRITE, HSIZE, HWDATA,
              HREADYin, BIGENDIAN, INTSRC,
 
              HRDATA, HREADYout, HRESP, nLMINT
              );

  input          HCLK;
  input          HRESETn;
  input          HSEL_IRC;
  input   [3:0]  HADDR;
  input   [1:0]  HTRANS;
  input          HWRITE;
  input   [2:0]  HSIZE;
  input   [31:0] HWDATA;
  input          HREADYin;
  input          BIGENDIAN;
  input   [2:0]  INTSRC;

  output  [31:0] HRDATA;
  output         HREADYout;
  output  [1:0]  HRESP;
  output         nLMINT;

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

  reg         HselReg;  // HSEL_IRC register
  wire        ACRegEn;  // Enable for address and control registers
  wire        CSN;
  wire        WEN;
  wire  [3:0] BWEN;
  reg         RegValid;
  reg   [3:0] HaddrReg;
  reg   [1:0] HtransReg;
  reg   [2:0] HsizeReg;
  wire  [3:2] HaddrRam;
  wire  [1:0] ENDADDR;  //for BIGENDIAN implementaion
  reg  [31:0] mem_rd;
  reg  [31:0] HRDATA;

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
`define LM_ISTAT         2'b00
`define LM_IRSTAT        2'b01
`define LM_IENSET        2'b10
`define LM_IENCLR        2'b11

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
        HselReg <= #2 HSEL_IRC;
    end
  end
 
//------------------------------------------------------------------------------
// Address and control registers
//------------------------------------------------------------------------------
// Registers are used to store the address and control signals from the address
//  phase for use in the data phase of the transfer.
// Only enabled when the HREADYin input is HIGH and the module is addressed.

  assign ENDADDR = {HADDR[1] ^ BIGENDIAN, HADDR[0] ^ BIGENDIAN};

  assign ACRegEn = HSEL_IRC & HREADYin;
  
  always @(HselReg or HtransReg) begin
    // synopsys translate_off
    `ifdef RTL_SIM
      RegValid = #2 (HselReg == 1'b1 && (HtransReg == 2'b10 ||
                                         HtransReg == 2'b11)) ? 1'b1 : 1'b0;
    `else
    // synopsys translate_on
      RegValid = (HselReg == 1'b1 && (HtransReg == 2'b10 ||
                                         HtransReg == 2'b11)) ? 1'b1 : 1'b0;
    // synopsys translate_off
    `endif
    // synopsys translate_on
  end

  always @(negedge (HRESETn) or posedge (HCLK))
  begin
    if (!HRESETn)
    begin
      HaddrReg  <= 4'b0000;
      HtransReg <= 2'b00;
      HsizeReg  <= 3'b000;
    end
    else
    begin
      if (ACRegEn)
      begin
        HaddrReg  <= {HADDR[3:2],ENDADDR[1:0]};
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
    HREADY_reg <= #2 1'b0;
  end
  else begin
    HREADY_reg <= #2 1'b1;
  end
end

//------------------------------------------------------------------------------
//  Memory read and write
//------------------------------------------------------------------------------

assign #2 HaddrRam = (~HREADY_reg) ? HaddrReg[3:2] : {HADDR[3:2]};
assign WEN = ~(~HREADY_reg & RegValid);
assign BWEN = (HsizeReg[1:0] == 2'b10) ? 4'b0000 :
            (HsizeReg[1:0] == 2'b01 && HaddrReg[1]) ? 4'b0011 :
            (HsizeReg[1:0] == 2'b01 && ~HaddrReg[1]) ? 4'b1100 :
            (HsizeReg[1:0] == 2'b00 && HaddrReg[1:0] == 2'b11) ? 4'b0111 :
            (HsizeReg[1:0] == 2'b00 && HaddrReg[1:0] == 2'b10) ? 4'b1011 :
            (HsizeReg[1:0] == 2'b00 && HaddrReg[1:0] == 2'b01) ? 4'b1101 :
            (HsizeReg[1:0] == 2'b00 && HaddrReg[1:0] == 2'b00) ? 4'b1110 :
            4'b1111;
assign #2 CSN = ~(HselReg | HSEL_IRC);

assign HREADYout = HREADY_reg;

// The response will always be OKAY to show that the transfer has been performed
//  successfully.

  assign HRESP = 2'b00;

// Interrupt Vector Memory
reg   [2:0]    IRSTAT, IRENABLE;

always @(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) IRSTAT <= 3'b000;
  else IRSTAT <= INTSRC;
end

always @(posedge HCLK or negedge HRESETn) begin
  if(~HRESETn) IRENABLE <= 3'b000;
  else if (HaddrRam == `LM_IENSET && ~BWEN[0] && ~WEN) 
    IRENABLE <= IRENABLE | HWDATA[2:0];
  else if (HaddrRam == `LM_IENCLR && ~BWEN[0] && ~WEN)
    IRENABLE <= IRENABLE & ~(HWDATA[2:0]);
end

always @(HaddrRam or IRSTAT or IRENABLE ) begin

  case (HaddrRam)
    `LM_ISTAT  : mem_rd = {29'b0000_0000_0000_0000_0000_0000_0000_0, (IRSTAT & IRENABLE)};
    `LM_IRSTAT : mem_rd = {29'b0000_0000_0000_0000_0000_0000_0000_0, IRSTAT};
    `LM_IENSET : mem_rd = {29'b0000_0000_0000_0000_0000_0000_0000_0, IRENABLE};
    default    : mem_rd = 32'h00000000;
  endcase
end

always @(posedge HCLK) begin
    HRDATA <= mem_rd;
end

assign   nLMINT = ~(|(IRSTAT & IRENABLE));

endmodule

// --================================= End ===================================--
