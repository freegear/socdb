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
//  File Name          : MuxS2M16slot.v,v
//  File Revision      : 1.2
// 
//  Release Information : ADK_REL1v1
// 
//  ----------------------------------------------------------------
//  Purpose  : Central multiplexer - signals from slaves to masters.
//             Stand-alone module to allow ease of removal if an
//             alternative interconnection scheme is to be used.
//             Supports 16 slaves.
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
   HSELS8, 
   HSELS9, 
   HSELS10,
   HSELS11,
   HSELS12, 
   HSELS13, 
   HSELS14, 
   HSELS15,

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

   // Read-data and Control signals from Slave 8
   HRDATAS8, 
   HREADYS8, 
   HRESPS8,

   // Read-data and Control signals from Slave 9
   HRDATAS9, 
   HREADYS9, 
   HRESPS9,

   // Read-data and Control signals from Slave 10
   HRDATAS10, 
   HREADYS10, 
   HRESPS10,

   // Read-data and Control signals from Slave 11
   HRDATAS11, 
   HREADYS11, 
   HRESPS11,

   // Read-data and Control signals from Slave 12
   HRDATAS12, 
   HREADYS12, 
   HRESPS12,

   // Read-data and Control signals from Slave 13
   HRDATAS13, 
   HREADYS13, 
   HRESPS13,

   // Read-data and Control signals from Slave 14
   HRDATAS14, 
   HREADYS14, 
   HRESPS14,

   // Read-data and Control signals from Slave 15
   HRDATAS15, 
   HREADYS15, 
   HRESPS15,

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
  input          HSELS8;
  input          HSELS9;
  input          HSELS10;
  input          HSELS11;
  input          HSELS12;
  input          HSELS13;
  input          HSELS14;
  input          HSELS15;
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
  input [31:0]   HRDATAS8;
  input          HREADYS8;
  input [1:0]    HRESPS8;
  input [31:0]   HRDATAS9;
  input          HREADYS9;
  input [1:0]    HRESPS9;
  input [31:0]   HRDATAS10;
  input          HREADYS10;
  input [1:0]    HRESPS10;
  input [31:0]   HRDATAS11;
  input          HREADYS11;
  input [1:0]    HRESPS11;
  input [31:0]   HRDATAS12;
  input          HREADYS12;
  input [1:0]    HRESPS12;
  input [31:0]   HRDATAS13;
  input          HREADYS13;
  input [1:0]    HRESPS13;
  input [31:0]   HRDATAS14;
  input          HREADYS14;
  input [1:0]    HRESPS14;
  input [31:0]   HRDATAS15;
  input          HREADYS15;
  input [1:0]    HRESPS15;
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
// HselReg encoding. This must be extended if more than sixteen AHB
//  peripherals are used in the system.
`define HSEL_S0  4'b0000
`define HSEL_S1  4'b0001
`define HSEL_S2  4'b0010
`define HSEL_S3  4'b0011
`define HSEL_S4  4'b0100
`define HSEL_S5  4'b0101
`define HSEL_S6  4'b0110
`define HSEL_S7  4'b0111
`define HSEL_S8  4'b1000
`define HSEL_S9  4'b1001
`define HSEL_S10 4'b1010
`define HSEL_S11 4'b1011
`define HSEL_S12 4'b1100
`define HSEL_S13 4'b1101
`define HSEL_S14 4'b1110
`define HSEL_S15 4'b1111

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
  wire         HSELS8;
  wire         HSELS9;
  wire         HSELS10;
  wire         HSELS11;
  wire         HSELS12;
  wire         HSELS13;
  wire         HSELS14;
  wire         HSELS15;
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
  wire [31:0]  HRDATAS8;
  wire         HREADYS8;
  wire [1:0]   HRESPS8;
  wire [31:0]  HRDATAS9;
  wire         HREADYS9;
  wire [1:0]   HRESPS9;
  wire [31:0]  HRDATAS10;
  wire         HREADYS10;
  wire [1:0]   HRESPS10;
  wire [31:0]  HRDATAS11;
  wire         HREADYS11;
  wire [1:0]   HRESPS11;
  wire [31:0]  HRDATAS12;
  wire         HREADYS12;
  wire [1:0]   HRESPS12;
  wire [31:0]  HRDATAS13;
  wire         HREADYS13;
  wire [1:0]   HRESPS13;
  wire [31:0]  HRDATAS14;
  wire         HREADYS14;
  wire [1:0]   HRESPS14;
  wire [31:0]  HRDATAS15;
  wire         HREADYS15;
  wire [1:0]   HRESPS15;
  wire         HREADYDefault;
  wire [1:0]   HRESPDefault;
  wire         SCANENABLE;
  wire         SCANINHCLK;
  wire         HREADY;
  wire         SCANOUTHCLK;

  reg [31:0]   HRDATA;
  reg [1:0]    HRESP;

  // Internal Signals
  wire [3:0]   HselNext;   //  HSEL input bus 
  reg  [3:0]   HselReg;    //  HSEL input register 
  reg          HselDefReg; //  HSELDefault register 
  reg          iHREADY;    //  Internal HREADY used as HSEL register enable 

//------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------

//------------------------------------------------------------------
// HSEL bus and registers
//------------------------------------------------------------------

  // The internal HselNext bus is a binary representation of the number of the
  // selected slave, e.g. if HSELS9 is active then HselNext takes the value 
  // "1001". This is done to reduce the number of registers required, and to
  // simplify the synthesis of the case statements which form the body of the 
  // multiplexor. Note that HSELS0 is not used in this encoding as HselNext
  // is "0000" in this case, but the signal remains present on the port 
  // interface for reserved future-use and compatability reasons.

  assign HselNext[3] = HSELS15 | HSELS14 | HSELS13 | HSELS12 |
	 HSELS11 | HSELS10 | HSELS9 | HSELS8;

  assign HselNext[2] = HSELS15 | HSELS14 | HSELS13 | HSELS12 |
	 HSELS7 | HSELS6 | HSELS5 | HSELS4;

  assign HselNext[1] = HSELS15 | HSELS14 | HSELS11 | HSELS10 |
	 HSELS7 | HSELS6 | HSELS3 | HSELS2;

  assign HselNext[0] = HSELS15 | HSELS13 | HSELS11 | HSELS9 |
	 HSELS7 | HSELS5 | HSELS3 | HSELS1;

  // Registered HSEL outputs are needed to control the slave output 
  //  multiplexers, as the multiplexers must be switched in the cycle after 
  //  the HSEL signals have been driven.
  always @ (negedge HRESETn or posedge HCLK)
    begin : p_HselSeq
      if ((!HRESETn))
        begin 
          HselReg <= {4{1'b0}};
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
            HRDATAS4 or HRDATAS5 or HRDATAS6 or HRDATAS7 or HRDATAS8 or
            HRDATAS9 or HRDATAS10 or HRDATAS11 or HRDATAS12 or HRDATAS13 or
            HRDATAS14 or HRDATAS15)
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
        `HSEL_S8  : HRDATA = HRDATAS8;
        `HSEL_S9  : HRDATA = HRDATAS9;
        `HSEL_S10 : HRDATA = HRDATAS10;
        `HSEL_S11 : HRDATA = HRDATAS11;
        `HSEL_S12 : HRDATA = HRDATAS12;
        `HSEL_S13 : HRDATA = HRDATAS13;
        `HSEL_S14 : HRDATA = HRDATAS14;
        `HSEL_S15 : HRDATA = HRDATAS15;
        default   : HRDATA = {32{1'b0}};
      endcase
    end 

  always @ (HselDefReg or HselReg or HREADYS0 or HREADYS1 or HREADYS2 or
            HREADYS3 or HREADYS4 or HREADYS5 or HREADYS6 or
            HREADYS7 or HREADYS8 or HREADYS9 or HREADYS10 or HREADYS11 or
            HREADYS12 or HREADYS13 or HREADYS14 or HREADYS15 or
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
            `HSEL_S8  : iHREADY = HREADYS8;
            `HSEL_S9  : iHREADY = HREADYS9;
            `HSEL_S10 : iHREADY = HREADYS10;
            `HSEL_S11 : iHREADY = HREADYS11;
            `HSEL_S12 : iHREADY = HREADYS12;
            `HSEL_S13 : iHREADY = HREADYS13;
            `HSEL_S14 : iHREADY = HREADYS14;
            `HSEL_S15 : iHREADY = HREADYS15;
            default   : iHREADY = HREADYDefault;
          endcase
        end 
    end 

  assign HREADY = iHREADY;

  always @ (HselDefReg or HselReg or HRESPS0 or HRESPS1 or HRESPS2 or
            HRESPS3 or HRESPS4 or HRESPS5 or HRESPS6 or HRESPS7 or
            HRESPS8 or HRESPS9 or HRESPS10 or HRESPS11 or HRESPS12 or
            HRESPS13 or HRESPS14 or HRESPS15 or HRESPDefault)
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
            `HSEL_S8  : HRESP = HRESPS8;
            `HSEL_S9  : HRESP = HRESPS9;
            `HSEL_S10 : HRESP = HRESPS10;
            `HSEL_S11 : HRESP = HRESPS11;
            `HSEL_S12 : HRESP = HRESPS12;
            `HSEL_S13 : HRESP = HRESPS13;
            `HSEL_S14 : HRESP = HRESPS14;
            `HSEL_S15 : HRESP = HRESPS15;
            default   : HRESP = HRESPDefault;
          endcase
        end 
    end 

  
endmodule
