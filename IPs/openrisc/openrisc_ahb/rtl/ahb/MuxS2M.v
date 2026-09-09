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
//             Supports 4 slaves.
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
   //  Note: HSEL0 is not used but is included for compatibility with
   //  other muxes
   HSELS0, 
   HSELS1, 
   HSELS2, 
   HSELS3, 

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

   // Control signals from the Default Slave
   HREADYDefault, 
   HRESPDefault,

   // Outputs of this multiplexor to the AHB
   HRDATA, 
   HREADY, 
   HRESP
   );

  input          HCLK;
  input          HRESETn;

  input          HSELS0;
  input          HSELS1;
  input          HSELS2;
  input          HSELS3;
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

  input          HREADYDefault;
  input [1:0]    HRESPDefault;

  output [31:0]  HRDATA;
  output         HREADY;
  output [1:0]   HRESP;


//------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------
// HselReg encoding. This must be extended if more than four AHB
//  peripherals are used in the system.
`define HSEL_S0  2'b00
`define HSEL_S1  2'b01
`define HSEL_S2  2'b10
`define HSEL_S3  2'b11

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
  wire         HREADYDefault;
  wire [1:0]   HRESPDefault;
  wire         HREADY;

  reg [31:0]   HRDATA;
  reg [1:0]    HRESP;

// Internal Signals
  wire [1:0]   HselNext;   //  HSEL input bus 
  reg  [1:0]   HselReg;    //  HSEL input register 
  reg          HselDefReg; //  HSELDefault register 
  reg          iHREADY;    //  Internal HREADY used as HSEL register enable 

//------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------

//------------------------------------------------------------------
// HSEL bus and registers
//------------------------------------------------------------------

  // The internal HselNext bus is a binary representation of the number of the
  // selected slave, e.g. if HSELS3 is active then HselNext takes the value 
  // "11". This is done to reduce the number of registers required, and to
  // simplify the synthesis of the case statements which form the body of the 
  // multiplexor. Note that HSELS0 is not used in this encoding as HselNext
  // is "00" in this case, but the signal remains present on the port 
  // interface for reserved future-use and compatability reasons.

  assign HselNext[1] = HSELS3 | HSELS2;

  assign HselNext[0] = HSELS3 | HSELS1;

  // Registered HSEL outputs are needed to control the slave output 
  //  multiplexers, as the multiplexers must be switched in the cycle after 
  //  the HSEL signals have been driven.

  always @ (negedge HRESETn or posedge HCLK)
    begin : p_HselSeq
      if ((!HRESETn))
        begin 
          HselReg <= {2{1'b0}};
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

  always @ (HselReg or HRDATAS0 or HRDATAS1 or HRDATAS2 or HRDATAS3)
    begin : p_HRDATAComb
      case (HselReg)
        `HSEL_S0  : HRDATA = HRDATAS0;
        `HSEL_S1  : HRDATA = HRDATAS1;
        `HSEL_S2  : HRDATA = HRDATAS2;
        `HSEL_S3  : HRDATA = HRDATAS3;
        default   : HRDATA = {32{1'b0}};
      endcase
    end 

  always @ (HselDefReg or HselReg or
            HREADYS0 or HREADYS1 or HREADYS2 or HREADYS3 or HREADYDefault)
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
            default   : iHREADY = HREADYDefault;
          endcase
        end 
    end 

  assign HREADY = iHREADY;

  always @ (HselDefReg or HselReg or
            HRESPS0 or HRESPS1 or HRESPS2 or HRESPS3 or HRESPDefault)
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
            default   : HRESP = HRESPDefault;
          endcase
        end 
    end 

  
endmodule

// --============================ End ==============================--

