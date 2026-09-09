
`timescale 1ns/1ps

module PMCKD (
   // Inputs
   Clk, nReset, ScanClock, ScanTestMode,
   // Outputs
   OutClk
   );

   input               Clk;                        // Primary Input Clock
   input               nReset;                     // Primary Reset(Active Low)
   input               ScanClock;                  // Scan Clock
   input               ScanTestMode;               // Scan Test Mode (Active High)
   output              OutClk;                     // Divided Clock
   
   // ------------------------------------------
   // Module parameters
   // ------------------------------------------
   parameter           Div      = 3;               // Default division : 2
   parameter           SizeCnt  = 4;               // Default size of division counter
   parameter           OddDiv   = 1;               // Default division number is even.

   // ------------------------------------------
   // Internal parameters
   // ------------------------------------------
   // Parameters for even division
   parameter           EHalfDiv  = (Div / 2);      // Half value of even division number
   parameter           EInitCnt  = EHalfDiv - 1;   // Initial value of even division counter

   // Parameters for odd division
   parameter           OInitCnt  = Div - 1;        // Initial value of odd division counter
   parameter           OHalfDiv  = (OInitCnt / 2); // Half value of odd division number


   // ------------------------------------------
   // Signal declarations
   // ------------------------------------------
   wire                InClk;                      // Division counter clock
   wire                NegInClk;                   // Negative edge active clock of division counter
   wire                OutClk;                     // Divided clock

   // ------------------------------------------
   // Register declarations
   // ------------------------------------------
   reg                 NextIntOutClk;              // Next state of internal divided clock
   reg                 IntOutClk;                  // Internal divided clock
   reg                 NegOutClk;                  // Negative internal divided clock
   reg [SizeCnt-1:0]   NextDivCnt;                 // Next state of division counter
   reg [SizeCnt-1:0]   DivCnt;                     // Division counter


   // ------------------------------------------
   // Clock selection stage
   // ------------------------------------------
   // Select of input clock
   assign InClk = ScanTestMode ? ScanClock : Clk;

   // Negative edge active clock
   assign NegInClk = ~InClk;

   // -------------------------------------------------------------------
   // SizeCnt bit division counter
   //
   // Division counter is instantiated only when division number is
   // larger than 1.
   // -------------------------------------------------------------------
   always @(EInitCnt or DivCnt)
     begin
        if((Div != 1) && (Div != 0))
          begin
             // Division counter for odd division number
             if(OddDiv == 1)
               begin  
                  if(DivCnt == {SizeCnt{1'b0}})
                    NextDivCnt = OInitCnt;
                  else
                    NextDivCnt = DivCnt - 1;
               end
             // Division counter for even division number
             else
               begin  
                  if(DivCnt == {SizeCnt{1'b0}})
                    NextDivCnt = EInitCnt;
                  else
                    NextDivCnt = DivCnt - 1;
               end
          end
     end
               
   always @(posedge InClk or negedge nReset) 
       if (!nReset) 
         DivCnt <= EInitCnt;
       else if ((Div != 1) && (Div != 0))
         DivCnt <= NextDivCnt;

   // -------------------------------------------------------------------
   // Internal divided clock
   //
   // 1. Odd division
   //
   //    When the next of division counter is a initial value or 
   //    initial minus 1, internal divided clock is inverted.
   //    High level of IntOutClk clock always shapes half cycle shorter
   //    than 50% duty clock.
   //
   //                .---.   .---.   .---.   .---.   .---.   .---.   .---
   //                |   |   |   |   |   |   |   |   |   |   |   |   |
   //    Clk      ---*   *---*   *---*   *---*   *---*   *---*   *---*
   //
   //                .-------.               .-------.               .---
   //                |       |               |       |               |
   //    Div = 3  ---*       *---------------*       *---------------*
   //                |<--------->|
   //                     50%
   //
   //                .---------------.                       .-----------
   //                |               |                       |
   //    Div = 5  ---*               *-----------------------*
   //                |<----------------->|
   //                       50%
   //
   //
   // 2. Even division
   //
   //    When the next of division counter is a initial value,
   //    internal divided clock is inverted.
   //    IntOutClk clock always shapes 50% duty clock.
   //
   //                .---.   .---.   .---.   .---.   .---.   .---.   .---
   //                |   |   |   |   |   |   |   |   |   |   |   |   |
   //    Clk      ---*   *---*   *---*   *---*   *---*   *---*   *---*
   //
   //                .-------.       .-------.       .-------.       .---
   //                |       |       |       |       |       |       |
   //    Div = 2  ---*       *-------*       *-------*       *-------*
   //
   //                .---------------.               .---------------.
   //                |               |               |               |
   //    Div = 4  ---*               *---------------*               *---
   //
   // -------------------------------------------------------------------
   always @(EInitCnt or DivCnt or IntOutClk or NextDivCnt)
     begin
        if((Div != 1) && (Div != 0))
          begin
             // Odd divider
             if(OddDiv == 1)
               begin
                  if((DivCnt == OInitCnt) || ( DivCnt == OHalfDiv))
                    NextIntOutClk = ~IntOutClk;
                  else
                    NextIntOutClk = IntOutClk;
               end
             // Even divider
             else
               begin
                  if(NextDivCnt == EInitCnt)
                    NextIntOutClk = ~IntOutClk;
                  else
                    NextIntOutClk = IntOutClk;
               end
          end
     end
                  
   always @(posedge InClk or negedge nReset) 
     begin
         if (!nReset) 
           IntOutClk <= 1'b0;
         else if ((Div != 1) && (Div != 0))
           IntOutClk <= NextIntOutClk;
     end

   // -------------------------------------------------------------------
   // Current stat of internal divided clock for only odd division number
   //
   // This sequential circuit is instantiated only when division number
   // is odd.
   //
   // e.g) When Div is 3.
   //
   //                 .---.   .---.   .---.   .---.   .---.   .---.   .--
   //                 |   |   |   |   |   |   |   |   |   |   |   |   |
   //    Clk       ---*   *---*   *---*   *---*   *---*   *---*   *---*
   //
   //                 .-------.               .-------.               .--
   //                 |       |               |       |               |
   //    IntOutClk ---*       *---------------*       *---------------*
   //             
   //                     .-------.               .-------.               
   //                     |       |               |       |               
   //    NegOutClk -------*       *---------------*       *---------------
   //             
   // -------------------------------------------------------------------
   always @(posedge NegInClk or negedge nReset) 
     begin
         if (!nReset) 
           NegOutClk <= 1'b0;
         else if ((Div != 1) && (Div != 0) && OddDiv == 1)
           NegOutClk <= IntOutClk;
     end
   

   // -------------------------------------------------------------------
   // Divided clock
   //
   // when division number is smaller than 2,
   //      the frequency of divided clock is same to input clock.
   // when division number is larger than 1 and even,
   //      divided clock is driven by IntOutClk.
   // when division number is larger than 1 and odd,
   //      divided clock is driven by ORing of IntOutClk and NegOutClk.
   // -------------------------------------------------------------------
   assign OutClk = ((Div == 0) || (Div == 1)) ? Clk : 
                   ((OddDiv == 1) ? (IntOutClk | NegOutClk) : IntOutClk);

endmodule