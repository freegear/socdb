//  --============================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ----------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name          : MuxS2M.v,v
//  File Revision      : 1.13
// 
//  Release Information : ADK_REL1v1
// 
//  ----------------------------------------------------------------
//  Purpose  : Central multiplexer - signals from slaves to masters.
//             Stand-alone module to allow ease of removal if an
//             alternative interconnection scheme is to be used.
//             Supports 8 slaves.
//  --============================================================--

`timescale 1ns/1ps

module MuxS2M 
  (
   // Common AHB signals
   HCLK, 
   HRESETn,

   // Individual select lines from the Decoder to the AHB slaves, also
   //  required by this multiplexor to select the appropriate signals 
   //  from the currently active slave
   // Note: HSEL0 is not used but is included for compatibility with
   //  other muxes
   HSELS0, 
   HSELS1, 
   HSELS2, 
   HSELS3, 
   HSELS4, 
   HSELS5, 
   HSELS6, 
   HSELS7,

   // Select line for the Default Slave only 
   HSELDefault,

   // Read-data and Control signals from Slave 0
   HRDATAS0, 
   HREADYS0, 
   HRESPS0,

   // Read-data and Control signals from Slave 1
   HRDATAS1, 
   HREADYS1, 
   HRESPS1,

   // Read-data and Control signals from Slave 2
   HRDATAS2, 
   HREADYS2, 
   HRESPS2,

   // Read-data and Control signals from Slave 3
   HRDATAS3, 
   HREADYS3, 
   HRESPS3,

   // Read-data and Control signals from Slave 4
   HRDATAS4, 
   HREADYS4, 
   HRESPS4,

   // Read-data and Control signals from Slave 5
   HRDATAS5, 
   HREADYS5, 
   HRESPS5,

   // Read-data and Control signals from Slave 6
   HRDATAS6, 
   HREADYS6, 
   HRESPS6,

   // Read-data and Control signals from Slave 7
   HRDATAS7, 
   HREADYS7, 
   HRESPS7,

   // Control signals from the Default Slave
   HREADYDefault, 
   HRESPDefault,

   // Outputs of this multiplexor to the AHB
   HRDATA, 
   HREADY, 
   HRESP,
   
   // Scan test dummy signals; not connected until scan insertion
   SCANENABLE,   // Scan Test Mode Enbl
   SCANINHCLK,   // Scan Chain Input   
   SCANOUTHCLK); // Scan Chain Output  

  input          HCLK;
  input          HRESETn;

  input          HSELS0;
  input          HSELS1;
  input          HSELS2;
  input          HSELS3;
  input          HSELS4;
  input          HSELS5;
  input          HSELS6;
  input          HSELS7;
  input          HSELDefault;

  input [31:0]   HRDATAS0;
  input          HREADYS0;
  input [1:0]    HRESPS0;

  input [31:0]   HRDATAS1;
  input          HREADYS1;
  input [1:0]    HRESPS1;

  input [31:0]   HRDATAS2;
  input          HREADYS2;
  input [1:0]    HRESPS2;

  input [31:0]   HRDATAS3;
  input          HREADYS3;
  input [1:0]    HRESPS3;

  input [31:0]   HRDATAS4;
  input          HREADYS4;
  input [1:0]    HRESPS4;

  input [31:0]   HRDATAS5;
  input          HREADYS5;
  input [1:0]    HRESPS5;

  input [31:0]   HRDATAS6;
  input          HREADYS6;
  input [1:0]    HRESPS6;

  input [31:0]   HRDATAS7;
  input          HREADYS7;
  input [1:0]    HRESPS7;

  input          HREADYDefault;
  input [1:0]    HRESPDefault;

  input          SCANENABLE;
  input          SCANINHCLK;

  output [31:0]  HRDATA;
  output         HREADY;
  output [1:0]   HRESP;

  output         SCANOUTHCLK;


//------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------
// HselReg encoding. This must be extended if more than eight AHB
//  peripherals are used in the system.
`define HSEL_S0  3'b000
`define HSEL_S1  3'b001
`define HSEL_S2  3'b010
`define HSEL_S3  3'b011
`define HSEL_S4  3'b100
`define HSEL_S5  3'b101
`define HSEL_S6  3'b110
`define HSEL_S7  3'b111

//------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------

// Input/Output Signals
  wire         HCLK;
  wire         HRESETn;
  wire         HSELS0;
  wire         HSELS1;
  wire         HSELS2;
  wire         HSELS3;
  wire         HSELS4;
  wire         HSELS5;
  wire         HSELS6;
  wire         HSELS7;
  wire         HSELDefault;
  wire [31:0]  HRDATAS0;
  wire         HREADYS0;
  wire [1:0]   HRESPS0;
  wire [31:0]  HRDATAS1;
  wire         HREADYS1;
  wire [1:0]   HRESPS1;
  wire [31:0]  HRDATAS2;
  wire         HREADYS2;
  wire [1:0]   HRESPS2;
  wire [31:0]  HRDATAS3;
  wire         HREADYS3;
  wire [1:0]   HRESPS3;
  wire [31:0]  HRDATAS4;
  wire         HREADYS4;
  wire [1:0]   HRESPS4;
  wire [31:0]  HRDATAS5;
  wire         HREADYS5;
  wire [1:0]   HRESPS5;
  wire [31:0]  HRDATAS6;
  wire         HREADYS6;
  wire [1:0]   HRESPS6;
  wire [31:0]  HRDATAS7;
  wire         HREADYS7;
  wire [1:0]   HRESPS7;
  wire         HREADYDefault;
  wire [1:0]   HRESPDefault;
  wire         SCANENABLE;
  wire         SCANINHCLK;
  wire         HREADY;
  wire         SCANOUTHCLK;

  reg [31:0]   HRDATA;
  reg [1:0]    HRESP;

// Internal Signals
  wire [2:0]   HselNext;   //  HSEL input bus 
  reg  [2:0]   HselReg;    //  HSEL input register 
  reg          HselDefReg; //  HSELDefault register 
  reg          iHREADY;    //  Internal HREADY used as HSEL register enable 

//------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------

//------------------------------------------------------------------
// HSEL bus and registers
//------------------------------------------------------------------

  // The internal HselNext bus is a binary representation of the number of the
  // selected slave, e.g. if HSELS7 is active then HselNext takes the value 
  // "111". This is done to reduce the number of registers required, and to
  // simplify the synthesis of the case statements which form the body of the 
  // multiplexor. Note that HSELS0 is not used in this encoding as HselNext
  // is "000" in this case, but the signal remains present on the port 
  // interface for reserved future-use and compatability reasons.

  assign HselNext[2] = HSELS7 | HSELS6 | HSELS5 | HSELS4;

  assign HselNext[1] = HSELS7 | HSELS6 | HSELS3 | HSELS2;

  assign HselNext[0] = HSELS7 | HSELS5 | HSELS3 | HSELS1;

  // Registered HSEL outputs are needed to control the slave output 
  //  multiplexers, as the multiplexers must be switched in the cycle after 
  //  the HSEL signals have been driven.

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_HselSeq
      if ((!HRESETn))
        begin 
          HselReg <= {3{1'b0}};
        end
      else
        begin
          if (iHREADY)
            begin 
              HselReg <= HselNext;
            end 
        end 
    end

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_HselDefSeq
      if ((!HRESETn))
        begin 
          HselDefReg <= 1'b1;
        end
      else
        begin
          if (iHREADY)
            begin 
              HselDefReg <= HSELDefault;
            end 
        end 
    end 

//------------------------------------------------------------------
// Multiplexers
//------------------------------------------------------------------
// Multiplexers controlling read data and responses from slaves to masters.

// When no slaves are selected by the Decoder, the default outputs are used to
//  generate the response.
// A default read data value is not strictly required as all reads from
//  undefined regions of memory receive an error response, but may aid 
//  debugging by ensuring that the read data bus is zero when no peripherals
//  are being accessed.

  always @ (HselReg or HRDATAS0 or HRDATAS1 or HRDATAS2 or HRDATAS3 or
            HRDATAS4 or HRDATAS5 or HRDATAS6 or HRDATAS7)
    begin : p_HRDATAComb
      case (HselReg)
        `HSEL_S0  : HRDATA = HRDATAS0;
        `HSEL_S1  : HRDATA = HRDATAS1;
        `HSEL_S2  : HRDATA = HRDATAS2;
        `HSEL_S3  : HRDATA = HRDATAS3;
        `HSEL_S4  : HRDATA = HRDATAS4;
        `HSEL_S5  : HRDATA = HRDATAS5;
        `HSEL_S6  : HRDATA = HRDATAS6;
        `HSEL_S7  : HRDATA = HRDATAS7;
        default   : HRDATA = {32{1'b0}};
      endcase
    end 

  always @ (HselDefReg or HselReg or HREADYS0 or HREADYS1 or HREADYS2 or
            HREADYS3 or HREADYS4 or HREADYS5 or HREADYS6 or HREADYS7 or 
            HREADYDefault)
    begin : p_HREADYComb
      if (HselDefReg)
        begin 
          iHREADY = HREADYDefault;
        end
      else
        begin
          case (HselReg)
            `HSEL_S0  : iHREADY = HREADYS0;
            `HSEL_S1  : iHREADY = HREADYS1;
            `HSEL_S2  : iHREADY = HREADYS2;
            `HSEL_S3  : iHREADY = HREADYS3;
            `HSEL_S4  : iHREADY = HREADYS4;
            `HSEL_S5  : iHREADY = HREADYS5;
            `HSEL_S6  : iHREADY = HREADYS6;
            `HSEL_S7  : iHREADY = HREADYS7;
            default   : iHREADY = HREADYDefault;
          endcase
        end 
    end 

  assign HREADY = iHREADY;

  always @ (HselDefReg or HselReg or HRESPS0 or HRESPS1 or HRESPS2 or
            HRESPS3 or HRESPS4 or HRESPS5 or HRESPS6 or HRESPS7 or
            HRESPDefault)
    begin : p_HRESPComb
      if (HselDefReg)
        begin 
          HRESP = HRESPDefault;
        end
      else
        begin
          case (HselReg)
            `HSEL_S0  : HRESP = HRESPS0;
            `HSEL_S1  : HRESP = HRESPS1;
            `HSEL_S2  : HRESP = HRESPS2;
            `HSEL_S3  : HRESP = HRESPS3;
            `HSEL_S4  : HRESP = HRESPS4;
            `HSEL_S5  : HRESP = HRESPS5;
            `HSEL_S6  : HRESP = HRESPS6;
            `HSEL_S7  : HRESP = HRESPS7;
            default   : HRESP = HRESPDefault;
          endcase
        end 
    end 

  
endmodule

// --============================ End ==============================--

