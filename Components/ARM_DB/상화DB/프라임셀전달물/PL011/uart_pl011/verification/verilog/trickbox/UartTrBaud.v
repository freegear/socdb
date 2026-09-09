// ========================================================================== --
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  ----------------------------------------------------------------------------
//  
//  Version and Release Control Information:
//  
//  File Name              : UartTrBaud.v.rca
//  File Revision          : 1.2
//  
//  Release Information    : PrimeCell(TM)-PL011-REL1v3
//  
//  ----------------------------------------------------------------------------
// Purpose     : This block checks the baud width in different modes 
//
// ========================================================================== --
  
`timescale 1ns/1ps

//  ----------------------------------------------------------------------------
module UartTrBaud (
// Inputs
                   UARTCLK,
                   Mode,
                   RXD,
                   SIRIN,
                   CLKPERIOD,
                   Divisor,
                   FracDiv,
                   IRLPDivisor,
                   FRENABLE,
// Outputs
                   FREQERR
                  );

// Inputs
input         UARTCLK;          // APB Clock
input   [1:0] Mode;             // Operation Mode
input         RXD;              // Receive Data line
input         SIRIN;            // Receive data line in Irda mode
input   [7:0] CLKPERIOD;        // Uart Clk Period
input  [15:0] Divisor;          // Uart Baud rate
input   [5:0] FracDiv;          // Fractional baud rate 
input   [7:0] IRLPDivisor;      // Irda Baud Rate
input         FRENABLE;         // Freq Measure Enable 

// Outputs
output        FREQERR;          // Baud  Width in Error

// Inputs
wire          UARTCLK;          // APB Clock
wire    [1:0] Mode;             // Operation Mode
wire          RXD;              // Receive Data line
wire          SIRIN;            // Receive data line in Irda mode
wire    [7:0] CLKPERIOD;        // Uart Clk Period
wire   [15:0] Divisor;          // Uart Baud rate
wire    [5:0] FracDiv;          // Fractional baud rate 
wire    [7:0] IRLPDivisor;      // Irda Baud Rate
wire          FRENABLE;         // Freq Measure Enable 

// Outputs
reg           FREQERR;          // Baud  Width in Error

//------------------------------------------------------------------------------
//
//                                  UartTrBaud
//                                  ==========
//
//------------------------------------------------------------------------------
//
// Overview
// ========
//
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
`define JITTER    2
// Allowable jitter in bitwidth

`define CON16     5'b10000
// Multiplication Factor for 16 pulses

`define IRDACON3  2'b11
// Multiplication Factor fot Irda bitwidth

`define IRDACON13 4'hD
// Miltiplication Factor for remaining bit width

`define CON64     7'b1000000

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------
time Bitwidth;
// Acyual Uart bit width

time TNegEdge;
// Negedge of Data

time TPosEdge;
// Posedge of Data
   
time LowPulsewidth;
// Negedge of Data

time HighPulsewidth;  
// Pulsewidth of higher level

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------
//function to_integer;
//input val;
//integer x := 0;
//integer return_int;
//integer x_tmp;
//integer i;
//begin
//  return_int <= 0;
//  x_tmp <= 0;
//  if (x != 0)
//    x_tmp <= 1;
//
//  for (i in val'range)
//    begin
//      return_int := return_int + return_int;
//      case (val[i])
//        1'b0 : null;
//        1'b1 : return_int <= return_int + 1;
//        default : return_int <= return_int + x_tmp;
//      endcase
//    end
//  to_integer = return_int;
//endfunction
// 
//------------------------------------------------------------------------------
//
// Main body of code
// =================
//
//------------------------------------------------------------------------------
initial
begin
  TNegEdge = 0;
  TPosEdge = 0;
  LowPulsewidth = 0;
  HighPulsewidth = 0;
  Bitwidth = 0;
end

//------------------------------------------------------------------------------
// This process measures the baud widths in all the modes and sets the  
// frequency baud error bit. 
//------------------------------------------------------------------------------
// always @(RXD or SIRIN or Mode)
always @(RXD or SIRIN)
begin : p_ChkComb
  // Calculating Uart bit width 
  if (Divisor !== 16'hXXXX)
    begin
//      Bitwidth <= (CON16) * (Divisor) 
//                             * (CLKPERIOD) * 1;
       
      Bitwidth <= (((`CON16) * (((Divisor) *
                   (`CON64)) + ((FracDiv))) * (CLKPERIOD)) * 1)/64;
    end
  // Checking for baud measure enable
  if (FRENABLE == 1'b1)

    // Compare with Uart baud if Trickbox is in normal mode
    // Checking width of data bit '1' 
    if (Mode == 2'b00)
    //  if (negedge RXD)
      if (RXD == 1'b0)
        begin
          TNegEdge = $time;

          // Checking whether bitwidth is within the limits allowed 
          // from actual Uart bitwidth
          if ((TNegEdge > 0) && ( TPosEdge > 0) &&
             ((Bitwidth - `JITTER) < ( TNegEdge - TPosEdge )) && 
             ((TNegEdge - TPosEdge ) > ( Bitwidth + `JITTER)))
            FREQERR <= 1'b1;
          else
            FREQERR <= 1'b0;

        end
      // Checking width of data bit '0'
      else if (RXD == 1'b1)
    //  else if (posedge RXD)
        begin
          TPosEdge = $time;

          // Checking whether bitwidth is within the limits allowed 
          // from actual Uart bitwidth
          if ((TNegEdge > 0) && (TPosEdge> 0) &&
             ((Bitwidth - `JITTER) < (TPosEdge - TNegEdge )) && 
             ((TPosEdge - TNegEdge) > (Bitwidth + `JITTER)))
            FREQERR <= 1'b1;
          else
            FREQERR <= 1'b0;
        end

    // Compare with Irda baud if Trickbox is in Irda mode 
    if (Mode == 2'b01 || (Mode == 2'b10))
      begin
        if (Mode == 2'b01)
          begin
            LowPulsewidth = ((`IRDACON13) * 
//                          ((Divisor) + 1) * (CLKPERIOD)) * 1;
                          ((Divisor)) * (CLKPERIOD)) * 1;
            HighPulsewidth = ((`IRDACON3) * 
//                           ((Divisor) + 1) * (CLKPERIOD)) * 1 ns;
                          ((Divisor)) * (CLKPERIOD)) * 1;
          end
        else
          begin
            LowPulsewidth = Bitwidth -( (`IRDACON3) 
//                   * ((IRLPDivisor) + 1) * (CLKPERIOD)) * 1;
                  * ((IRLPDivisor)) * (CLKPERIOD)) * 1;
            HighPulsewidth = ( (`IRDACON3) * 
//                     ((IRLPDivisor) + 1) * (CLKPERIOD)) * 1;
                    ((IRLPDivisor)) * (CLKPERIOD)) * 1;
          end
        
       // Checking width of positive pulse 
       // if (negedge SIRIN)
        if (SIRIN == 1'b0)
          begin
            TNegEdge = $time;
            if ((TNegEdge > 0) && (TPosEdge > 0) &&
               ((HighPulsewidth - `JITTER) < (TNegEdge - TPosEdge)) && 
               ((TNegEdge - TPosEdge) > (HighPulsewidth + `JITTER)))
              FREQERR <= 1'b1;
            else
              FREQERR <= 1'b0;
          end

      // Checking width of negative pulse 
       // else if (posedge SIRIN)
        else if (SIRIN == 1'b1)
          begin
            TPosEdge = $time;
            if ((TNegEdge > 0) && ( TPosEdge> 0) &&
               ((LowPulsewidth - `JITTER) < (TPosEdge - TNegEdge)) && 
               ((TPosEdge - TNegEdge) > (LowPulsewidth + `JITTER)))
              FREQERR <= 1'b1;
            else
              FREQERR <= 1'b0;
          end
      end
  else 
    begin
      TNegEdge = 0;
      TPosEdge = 0;
    end 

end // p_ChkComb         

endmodule

//========================== End of UartTrBaud  ================================
