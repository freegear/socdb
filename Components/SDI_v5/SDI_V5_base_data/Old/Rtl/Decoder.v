//  --==============================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//  ------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name          : Decoder.v,v
//  File Revision      : 1.6
//  
//  Release Information : ADK_REL1v1
//  
//  ------------------------------------------------------------------
//  Purpose            : Provides the HSELx module select outputs to
//                        the AHB system slaves, and controls the read
//                        data multiplexer.
//  --==============================================================--

`timescale 1ns/1ps

module Decoder
  (
   // Upper order bits of the address bus for the decode function
   HADDR,

   // Status of the system re-map
   Remap,

   // Select lines produced by the decode logic
   HSELS0B,   // Boot select for the first 1MB
   HSELS0R,   // Re-map select for the first 1MB
   HSELS0,    // Normal mode select line for Slot 0
   HSELS1,    // Select line for Slot 1
   HSELS2,    // Select line for Slot 2
   HSELS3,    // Select line for Slot 3
   HSELS4,    // Select line for Slot 4
   HSELS5,    // Select line for Slot 5
   HSELS6,    // Select line for Slot 6
   HSELS7,    // Select line for Slot 7
   HSELS8,    // Select line for Slot 8
   HSELS9,    // Select line for Slot 9
   HSELS10,   // Select line for Slot 10
   HSELS11,   // Select line for Slot 11
   HSELS12,   // Select line for Slot 12
   HSELS13,   // Select line for Slot 13
   HSELS14,   // Select line for Slot 14
   HSELS15);  // Select line for Slot 15

  input [31:20]  HADDR;
  input          Remap;
  output         HSELS0B;
  output         HSELS0R;
  output         HSELS0;
  output         HSELS1;
  output         HSELS2;
  output         HSELS3;
  output         HSELS4;
  output         HSELS5;
  output         HSELS6;
  output         HSELS7;
  output         HSELS8;
  output         HSELS9;
  output         HSELS10;
  output         HSELS11;
  output         HSELS12;
  output         HSELS13;
  output         HSELS14;
  output         HSELS15;


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// Input/Output Signals
  wire [31:20] HADDR;
  wire         Remap;

  reg          HSELS0B;
  reg          HSELS0R;
  reg          HSELS0;
  reg          HSELS1;
  reg          HSELS2;
  reg          HSELS3;
  reg          HSELS4;
  reg          HSELS5;
  reg          HSELS6;
  reg          HSELS7;
  reg          HSELS8;
  reg          HSELS9;
  reg          HSELS10;
  reg          HSELS11;
  reg          HSELS12;
  reg          HSELS13;
  reg          HSELS14;
  reg          HSELS15;

//--------------------------------------------------------------------
// Signal declarations
//--------------------------------------------------------------------
// Signal used to determine memory selected at address zero
  reg      LoMem;

//--------------------------------------------------------------------
// Beginning of main code
//--------------------------------------------------------------------

//--------------------------------------------------------------------
// Low memory decoding
//--------------------------------------------------------------------
// Detection of the first 1MB within the region addressed by HSELS0 is
// performed separately in order to reduce the depth of the main case
// statement in p_AddressDecodeComb

  always @ (HADDR)
    begin : p_LoMemDecodeComb
      if (HADDR[27:20]== 8'b00000000)
        begin 
          LoMem = 1'b1;
        end
      else
        begin
          LoMem = 1'b0;
        end 
    end 

//--------------------------------------------------------------------
// AHB address decoding
//--------------------------------------------------------------------
// The address map is split into 256MB sections, based on a decode of
// the top 4 address bits.  The exception is the first 1MB: an ARM
// processor always boots from address 0, and expects the exception
// vectors to be located from here.  HSELS0B and HSELS0R provide
// separate decodes for the first 1MB region at boot-up and after
// remap, respectively.

  always @ (HADDR or LoMem or Remap)
    begin : p_AddressDecodeComb
      // Default values
      HSELS0B = 1'b0;
      HSELS0R = 1'b0;
      HSELS0 = 1'b0;
      HSELS1 = 1'b0;
      HSELS2 = 1'b0;
      HSELS3 = 1'b0;
      HSELS4 = 1'b0;
      HSELS5 = 1'b0;
      HSELS6 = 1'b0;
      HSELS7 = 1'b0;
      HSELS8 = 1'b0;
      HSELS9 = 1'b0;
      HSELS10 = 1'b0;
      HSELS11 = 1'b0;
      HSELS12 = 1'b0;
      HSELS13 = 1'b0;
      HSELS14 = 1'b0;
      HSELS15 = 1'b0;
      
      case (HADDR[31:28])
        4'b0000: begin
          if (LoMem)
            begin 
              case (Remap)
                1'b0 : begin
                  HSELS0B = 1'b1;
                end
                1'b1 : begin
                  HSELS0R = 1'b1;
                end
                default: begin
                  // Null
                end
              endcase
            end
          else
            begin
              HSELS0 = 1'b1;
            end 
        end
        
        4'b0001: begin
          HSELS1 = 1'b1;
        end
        4'b0010: begin
          HSELS2 = 1'b1;
        end
        4'b0011: begin
          HSELS3 = 1'b1;
        end
        4'b0100: begin
          HSELS4 = 1'b1;
        end
        4'b0101: begin
          HSELS5 = 1'b1;
        end
        4'b0110: begin
          HSELS6 = 1'b1;
        end
        4'b0111: begin
          HSELS7 = 1'b1;
        end
        4'b1000: begin
          HSELS8 = 1'b1;
        end
        4'b1001: begin
          HSELS9 = 1'b1;
        end
        4'b1010: begin
          HSELS10 = 1'b1;
        end
        4'b1011: begin
          HSELS11 = 1'b1;
        end
        4'b1100: begin
          HSELS12 = 1'b1;
        end
        4'b1101: begin
          HSELS13 = 1'b1;
        end
        4'b1110: begin
          HSELS14 = 1'b1;
        end
        4'b1111: begin
          HSELS15 = 1'b1;
        end
        default: begin
          // Null
        end
      endcase
    end 

endmodule
