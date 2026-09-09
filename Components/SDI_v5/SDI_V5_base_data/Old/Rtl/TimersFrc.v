//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           : TimersFrc.v,v
//  File Revision       : 1.27
//
//  Release Information : ADK_REL1v1
//
//  ----------------------------------------------------------------------------
//  Purpose             : Free Running Counter (FRC) module used in Timers.
//                        Runs from TIMCLK which has edges synchronous to PCLK.
//                        Can be used to generate an interrupt.
//  --========================================================================--

//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

`timescale 1ns/1ps

module TimersFrc 
  (
   // Inputs
   PCLK, 
   PRESETn, 
   PENABLE, 
   PADDR, 
   PWRITE, 
   PWDATA,
   FrcSel, 
   TIMCLK,               
   TIMCLKEN, 
   IntFrc,

   // Outputs
   DataOut);

`include "TimersPackage.v"

// -----------------------------------------------------------------------------
// Pin Declarations
// -----------------------------------------------------------------------------
  input          PCLK;
  input          PRESETn;
  input          PENABLE;
  input    [4:2] PADDR;
  input          PWRITE;
  input   [31:0] PWDATA;
  input          FrcSel;       // Frc register select

  input          TIMCLK;       // Timer clock
  input          TIMCLKEN;     // Timer clock enable
  output         IntFrc;       // FRC interrupt
  output  [31:0] DataOut;      // Timer read data output

// -----------------------------------------------------------------------------
// Signal Declarations
// -----------------------------------------------------------------------------

// Input/Output Signals
  wire         PCLK;
  wire         PRESETn;
  wire         PENABLE;
  wire   [4:2] PADDR;
  wire         PWRITE;
  wire  [31:0] PWDATA;
  wire         FrcSel;
  wire         TIMCLK;
  wire         TIMCLKEN;
  wire         IntFrc;
  
  reg   [31:0] DataOut;

// Internal Signals
  wire         CtrlEn;         // Ctrl write enable
  reg    [3:0] Ctrl30;         // Control register
  reg    [7:5] Ctrl75;         // Control register
  
  wire         LoadEn;         // Load write enable
  reg   [31:0] Load;           // Stores the load value
  wire         LoadBgEn;       // Load background enable
  wire         LoadPeriodEn;   // Last load reg enable
  reg   [31:0] LoadPeriod;     // Stores last load data

  wire         LoadTogEn;      // Enable for load request toggle
  reg          LoadReqTogP;    // Load request toggle, PCLK domain
  reg          LoadReqTogT;    // Load request toggle, TIMCLK domain
  wire         LoadReqT;       // Load request pulse, TIMCLK domain
  
  wire         TimerEn;        // Timer enable
  wire         TimerMode;      // Timer mode
  wire   [3:2] TimerPre;       // Timer pre-scale
  wire         TimerSize;      // Timer size
  wire         OneShot;        // One-shot count enable
  
  wire   [7:0] NxtPreScale;    // Prescale reg input
  reg    [7:0] PreScale;       // Prescale counter
  wire         Enable16;       // Prescale 16 enable
  wire         Enable256;      // Prescale 256 enable
  
  wire         Stop;           // Stop at end of one-shot count
  reg          StopReg;        // Registered Stop
  
  reg          PreEnable;      // Selected Enable16/256 signal
  wire         CountEn;        // Enable for counter
  
  reg   [31:0] NxtCount;       // Count - 1
  reg    [1:0] Carry;          // Decrement carry in
  wire         CarryMSB;       // Multiplexed carry for 16/32-bit count
  reg   [31:0] CountMux;       // Count mux value
  reg   [31:0] Count;          // Current count
  
  wire         IntClrEn;       // Interrupt Clear enable
  reg          IntClrTogP;     // Int Clear toggle in PCLK domain
  reg          IntClrTogT;     // Int Clear toggle in TIMCLK domain
  wire         IntClrPulseT;   // Int Clear pulse in TIMCLK domain
  wire         IntClrT;        // Int Clear signal, TIMCLK domain
  reg          IntClrRegT;     // Registered IntClr signal, TIMCLK domain
  
  wire         IntEnable;      // Interrupt enable control bit
  wire         NxtRawIntFrc;   // iIntFrc next value
  reg          RawIntFrc;      // Registered internal counter interrupt
  wire         iIntFrc;        // Registered internal counter interrupt

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// Control Register
//------------------------------------------------------------------------------
// Contains values of Control register:
//   7 - Timer Enable
//   6 - Timer Mode
//   5 - Interrupt Enable
// 3:2 - Prescale
//   1 - Timer Size
//   0 - One Shot Count

  // Control write enable
  assign CtrlEn = ((PADDR == `TIMERCONTROLA) ? 
                   ((PWRITE & FrcSel) & (~PENABLE)) : 1'b0);

  // Control register implementation
  always @(negedge PRESETn or posedge PCLK)
  begin : p_CtrlSeq
    if (!PRESETn)
      begin
        Ctrl75 [7:5] <= 3'b001;
        Ctrl30 [3:0] <= 4'b0000;
      end
    else
      if (CtrlEn)
        begin
          Ctrl75 [7:5] <= PWDATA [7:5];
          Ctrl30 [3:0] <= PWDATA [3:0];
        end
  end // block: p_CtrlSeq

  // Assign control information
  assign TimerEn   = Ctrl75 [7];
  assign TimerMode = Ctrl75 [6];
  assign IntEnable = Ctrl75 [5];
  assign TimerPre  = Ctrl30 [3:2];
  assign TimerSize = Ctrl30 [1];
  assign OneShot   = Ctrl30 [0];

//------------------------------------------------------------------------------
// Load Register
//------------------------------------------------------------------------------
// Stores the load value for use on the next enabled TIMCLK edge.
  
  // Decode a TimerLoad write transaction
  assign LoadEn = ((PADDR == `TIMERLOADA) ? (PWRITE & FrcSel & (~PENABLE)) :
                   1'b0);
  
  // Register implementation
  always @(negedge PRESETn or posedge PCLK)
  begin : p_LoadSeq
    if (!PRESETn)
      Load <= {32{1'b0}};
    else
      if (LoadEn)
        Load <= PWDATA;
  end

// Background load value for timer - when this register is written to, the
//  counter will keep on counting using the current value and will only be
//  loaded with the new value after it has wrapped past zero.
  
  assign LoadBgEn = ((PADDR == `TIMERLOADBGA) ?
                    (PWRITE & FrcSel & (~PENABLE)) : 
                     1'b0);

//------------------------------------------------------------------------------
// Load Period Register
//------------------------------------------------------------------------------
// Stores last load or loadbg request which is read from the TimerLoad address.
// This value indicates the period of the count i.e. the next start value when
// the counter wraps.
  
  // Update the load register on a load or background load request
  assign LoadPeriodEn = (LoadEn | LoadBgEn);

  
  // Register implementation
  always @(negedge PRESETn or posedge PCLK)
  begin : p_LoadPeriodSeq
    if (!PRESETn)
      LoadPeriod <= {32{1'b0}};
    else
      if (LoadPeriodEn)
        LoadPeriod <= PWDATA;
  end

//------------------------------------------------------------------------------
// Clock prescaler (PreScale registers with decrementer)
//------------------------------------------------------------------------------
  
  // Select next PreScale value.  Set to 0 when a Load is performed,
  // to ensure that the first count period is not reduced. Otherwise decremented
  // only if the timer is enabled.
  assign NxtPreScale = (LoadReqT ? 1'b0 :
                        
                        TimerEn ? (PreScale - 1'b1) :
                        
                        PreScale);
  
  // PreScaler runs in TIMCLK domain
  always @(negedge PRESETn or posedge TIMCLK)
  begin : p_PrescalerSeq
    if (!PRESETn)
      PreScale <= {8{1'b0}};
    else
      if (TIMCLKEN)
        PreScale <= NxtPreScale;
  end

//------------------------------------------------------------------------------
// PreScale enable generation
//------------------------------------------------------------------------------
  
  // High round every 16th rising TIMCLK and TIMCLKEN is high.
  assign Enable16 = ((PreScale [3:0] == 4'b0001) ? 1'b1 : 1'b0);

  // High round every 256th rising TIMCLK and TIMCLKEN is high,
  //  equivalent to every 16th Enable1 pulse.
  assign Enable256 = ((PreScale == 8'h01) ? 1'b1 : 1'b0);

  // Selects the enable line depending on the prescale selected with control
  //  register bits 3:2.
  always @(Enable16 or Enable256 or TimerPre)
  begin : p_PreEnableComb
    case (TimerPre)
      2'b00:   PreEnable = 1'b1;
      2'b01:   PreEnable = Enable16;
      2'b10:   PreEnable = Enable256;
      2'b11:   PreEnable = Enable256; // unspecified PreScale value
      default: PreEnable = 1'b0;
    endcase
  end

//------------------------------------------------------------------------------
// Load enable logic
//------------------------------------------------------------------------------
// The LoadEn pulse needs to be sampled into TIMCLK domain even if PCLK is
// subsequently disabled.

// NOTE: there is a limitation of this logic: if more than one load is performed
//  in one TIMCLK pulse and the last LoadEn is sampled on the TIMCLK edge, then
//  the value will not be loaded until the Timer next wraps.

  assign LoadTogEn = (LoadEn & ~LoadReqT); // new load request with none pending
  
  // LoadTogEn high toggles LoadReqTog on next PCLK
  always @(negedge PRESETn or posedge PCLK)
  begin : p_LoadReqTogPSeq
    if (!PRESETn)
      LoadReqTogP <= 1'b0;
    else
      if (LoadTogEn)
        LoadReqTogP <= (~LoadReqTogP);
  end

  // Register LoadReqTog into TIMCLK domain
  always @(negedge PRESETn or posedge TIMCLK)
  begin : p_LoadReqTogTSeq
    if (!PRESETn)
      LoadReqTogT <= 1'b0;
    else 
      if (TIMCLKEN)
        LoadReqTogT <= LoadReqTogP;
  end
  
  // LoadReqT is high for one valid TIMCLK period
  assign LoadReqT = (LoadReqTogP ^ LoadReqTogT);
  

//------------------------------------------------------------------------------
// Stop generation
//------------------------------------------------------------------------------
// The Stop signal is used to halt the counters immediately after zero is
//  reached when in one-shot count mode. The counting is started again when
//  the Load register is written to or one-shot mode is exited.
  
  assign Stop = (LoadReqT || !OneShot) // new load value or not in OneShot mode
                  ? 1'b0 :

                CarryMSB ? 1'b1 :      // counter is zero in OneShot mode

                StopReg;

  always @(negedge PRESETn or posedge TIMCLK)
  begin : p_StopRegSeq
    if (!PRESETn)
      StopReg <= 1'b0;
    else
      if (TIMCLKEN)
        StopReg <= Stop;
  end

//------------------------------------------------------------------------------
// 32-bit count down with load.
//------------------------------------------------------------------------------
// NxtCount is set to Count when Carry = 0 so that loads also change the
//  value of NxtCount.
// Top halfword is only enabled when in 32-bit counter mode.

  // Halfword 0, bits 15:0
  always @(Count)
  begin : p_Dec0Comb
    NxtCount [15:0] = (Count [15:0] - 1'b1);
  end

  always @(Count)
  begin : p_Carry0Comb
    if (Count [15:0] == 16'h0000)
      Carry [0] = 1'b1;
    else
      Carry [0] = 1'b0;
  end
  
  // Halfword 1, bits 31:16.
  always @(TimerSize or Carry or Count)
  begin : p_Dec1Comb
    if (TimerSize  && Carry [0])
      NxtCount [31:16] = (Count [31:16] - 1'b1);
    else
      NxtCount [31:16] = Count [31:16];
  end

  always @(TimerSize or Count or Carry)
  begin : p_Carry1Comb
    if (TimerSize && Carry [0] && (Count [31:16] == 16'h0000))
      Carry [1] = 1'b1;
    else
      Carry [1] = 1'b0;
  end
  
  // The most significant carry bit changes when in 16 or 32-bit counter modes.
  assign CarryMSB = (TimerSize ? Carry [1] : Carry [0]);

//------------------------------------------------------------------------------
// Counter register
//------------------------------------------------------------------------------
  
  // If periodic mode is set, reloads from Load when CarryMSB is set.
  always @(CarryMSB or Load or LoadPeriod or LoadReqT or NxtCount or TimerMode)
  begin : p_CountMuxComb
    if (LoadReqT)                    // load request is highest priority
      CountMux = Load;
    else                             // no load request
      begin
        if ((CarryMSB && TimerMode)) // counter wrapping in periodic mode
          CountMux = LoadPeriod;
        else
          CountMux = NxtCount;      // normal counter decrement
      end
  end

  // The counter only changes on a valid TIMCLKEN, when a new value is loaded
  //  or when the timer is enabled, in a valid PreScale cycle and the counter is
  //  not stopped in one-shot mode.
  assign CountEn = (TIMCLKEN & 
                    ((TimerEn & PreEnable & (~Stop)) | LoadReqT));

  // Counter registers (all nibbles clocked on each cycle) using rising edge
  //  of TIMCLK. CountEn is used to enable the counter. Reset sets all outputs
  //  HIGH to avoid interrupt generation at start.
  always @(negedge PRESETn or posedge TIMCLK)
  begin : p_CountSeq
    if (!PRESETn)
      Count <= {32{1'b1}};
    else
      if (CountEn)
        Count <= CountMux;
  end

//------------------------------------------------------------------------------
// Interrupt clear
//------------------------------------------------------------------------------
// CarryMSB can be valid for multiple clock cycles, and may not have cleared
//  until after an interrupt clear has been asserted, allowing the interrupt
//  to be entered again. The interrupt clear is extended to ensure that it
//  remains valid until the interrupt is actually cleared in the TIMCLK domain.
// A toggle based handshake is used in case PCLK is removed before the interrupt
//  clear operation is complete.

  assign IntClrEn = (!IntClrT &&                  // no pending IntClr operation
                     PWRITE && FrcSel && !PENABLE && (PADDR == `TIMERCLEARA)
                     ? 1'b1 :                          // new IntClr transaction

                     1'b0);

  // IntClr high toggles IntClrTogP on next PCLK
  always @(negedge PRESETn or posedge PCLK)
  begin : p_IntClrTogPSeq
    if (!PRESETn)
      IntClrTogP <= 1'b0;
    else
      if (IntClrEn)
        IntClrTogP <= (~IntClrTogP);
  end

  // Register IntClrTogP into TIMCLK domain
  always @(negedge PRESETn or posedge TIMCLK)
  begin : p_IntClrTogTSeq
    if (!PRESETn)
      IntClrTogT <= 1'b0;
    else 
      if (TIMCLKEN)
        IntClrTogT <= IntClrTogP;
  end

  // IntClrPulseT is high for one valid TIMCLK edge
  assign IntClrPulseT = IntClrTogP ^ IntClrTogT;

  // IntClrT is used to clear the interrupt. It is asserted when the APB IntClr
  //  transaction is detected and de-asserted when the counter is no longer zero
  //  (to prevent multiple interrupts from one counter event).
  assign IntClrT = (IntClrPulseT ? 1'b1 :

                    !CarryMSB ? 1'b0 :

                    IntClrRegT);
                    
  always @(negedge PRESETn or posedge TIMCLK)
  begin : p_IntClrRegSeq
    if (!PRESETn)
      IntClrRegT <= 1'b0;
    else
      if (TIMCLKEN)
        IntClrRegT <= IntClrT;
  end

//------------------------------------------------------------------------------
// Interrupt generation
//------------------------------------------------------------------------------
// The interrupt is generated (set HIGH) when the counter reaches zero.
// The interrupt is cleared (set LOW) when the TimerClear address is
//  written to.

  assign NxtRawIntFrc = ((CarryMSB | RawIntFrc) & (~IntClrT));

  // Register and hold interrupt until cleared.  TIMCLK is used to
  // ensure that an interrupt is still generated even if PCLK is disabled.
  always @(negedge PRESETn or posedge TIMCLK)
  begin : p_IntSeq
    if (!PRESETn)
      RawIntFrc <= 1'b0;
    else
      if (TIMCLKEN)
        RawIntFrc <= NxtRawIntFrc;
  end
  
  // Gate raw interrupt with enable bit
  assign iIntFrc = (RawIntFrc & IntEnable);
  
  // Drive output with internal signal
  assign IntFrc = iIntFrc;

//------------------------------------------------------------------------------
// Output data generation
//------------------------------------------------------------------------------
// The current count value is driven out to the Timer which is then used
//  to generate the read data.
// Zero data is used as padding for register reads

  always @(Count or Ctrl30 or Ctrl75 or FrcSel or LoadPeriod or PADDR or 
           PWRITE or RawIntFrc or iIntFrc)
    begin : p_DataOutComb

      DataOut = {32{1'b0}}; // Drive zeros by default
      
      if (!PWRITE && FrcSel)
        case (PADDR)
          `TIMERLOADA :
            // TimerLoad address (returns next wrapping value)
            DataOut = LoadPeriod;
          
          `TIMERVALUEA : 
            // TimerValue address
            DataOut = Count;
          
          `TIMERCONTROLA : begin 
            // TimerControl address
            DataOut [7:5] = Ctrl75 [7:5];
            DataOut [3:0] = Ctrl30 [3:0];
          end
          
          `TIMERINTRAWA : 
            // TimerIntRaw address
            DataOut [0] = RawIntFrc;
          
          `TIMERINTA : 
            // TimerInt address
            DataOut [0] = iIntFrc;
          
          `TIMERLOADBGA : 
            // TimerLoadBg address (returns next wrapping value)
            DataOut = LoadPeriod;
          
          default: 
            DataOut = {32{1'b0}};
          
        endcase // case(PADDR)
      else
        DataOut = {32{1'b0}};
    end

endmodule

// --================================= End ===================================--
