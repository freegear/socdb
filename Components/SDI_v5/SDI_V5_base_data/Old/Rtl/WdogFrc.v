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
//  File Name          : WdogFrc.v,v
//  File Revision      : 1.12
//  
//  Release Information : ADK_REL1v1
//  
//  ----------------------------------------------------------------------------
//  Purpose            : Free Running Counter (WdogFrc) module used in ADK. 
//                       Runs from WDOGCLK which has edges synchronous to PCLK.
//                       Can be used to generate an interrupt.
//  --========================================================================--

`timescale 1ns/1ps

module WdogFrc
  (PCLK,
   PRESETn,
   PADDR,
   PWRITE,
   PWDATA,
   PENABLE,
   FrcSel,    // Frc register select 
   WdogLock,  // Lock register value 
   WDOGCLK,   // Watchdog clock      
   WDOGCLKEN, // Watchdog clock      
   WDOGRESn,  // Watchdog clock reset
   WDOGINT,   // FRC interrupt       
   WDOGRES,   // FRC reset           
   FrcData);  // Read data output    

`include "WdogPackage.v"

  input         PCLK;
  input         PRESETn;
  input [4:2]   PADDR;
  input         PWRITE;
  input [31:0]  PWDATA;
  input         PENABLE;
  input         FrcSel;
  input         WdogLock;
  input         WDOGCLK;
  input         WDOGCLKEN;
  input         WDOGRESn;
  output        WDOGINT;
  output        WDOGRES;
  output [31:0] FrcData;

  //----------------------------------------------------------------------------
  // Signal declarations
  //----------------------------------------------------------------------------

  // Input/Output Signals
  wire          PCLK;
  wire          PRESETn;
  wire [4:2]    PADDR;
  wire          PWRITE;
  wire [31:0]   PWDATA;
  wire          PENABLE;
  wire          FrcSel;
  wire          WdogLock;
  wire          WDOGCLK;
  wire          WDOGCLKEN;
  wire          WDOGRESn;
  wire          WDOGINT;
  wire          WDOGRES;
  
  reg [31:0]    FrcData;        //  Read data output 

  // Internal Signals
  wire          WdogCtrlEn;     //  Ctrl write enable 
  reg [1:0]     WdogControl;    //  Control register 
  wire          LoadEn;         //  Load write enable
  reg [31:0]    WdogLoad;       //  WdogLoad regiser 

  wire          LoadTogEn;
  reg           LoadReqTogP;
  reg           LoadReqTogW;
  wire          LoadReqW;

  wire          CountEn;        //  Enable for counter 
  wire          CountStop;      //  Halt counter
  reg           CountStopReg;   //  Registered CountStop
  
  reg [31:0]    NxtCount;       //  Count - 1 
  reg [1:0]     Carry;          //  Decrement carry in 
  wire          CarryMSB;       //  Multiplexed carry for 16/32-bit count 
  wire [31:0]   CountMux;       //  Count mux value 
  reg [31:0]    Count;          //  Current count 

  wire          WdogIntEn;      //  Interrupt enable 
  reg           WdogIntEnReg;   //  Registered interrupt enable
  wire          WdogIntEnRise;  //  Rising edge on interrupt enable
  wire          WdogResEn;      //  Reset enable 
  reg           iWdogRes;       //  Registered internal counter reset 
  wire          NxtWdogRes;     //  Next iWdogRes value
  
  wire          IntClrEn;       //  Interrupt clear enable
  reg           IntClrTogP;     //  Int Clear toggle in PCLK domain
  reg           IntClrTogW;     //  Int Clear toggle in WDOGCLK domain
  wire          IntClrPulse;    //  Int Clear pulse
  wire          IntClrW;        //  Int Clear signal in WDOGCLK domain
  reg           IntClrRegW;     //  Registered Int Clear signal, WDOGCLK domain
  
  wire          NxtWdogRIS ;    //  Next WdogRIS value 
  reg           WdogRIS;        //  Registered raw counter interrupt 
  wire          WdogMIS;        //  Masked counter interrupt

  //----------------------------------------------------------------------------
  // Beginning of main code
  //----------------------------------------------------------------------------
  
  //----------------------------------------------------------------------------
  // Control Register
  //----------------------------------------------------------------------------
  // Contains values of Control register:
  //   1 - Watchdog Reset Enable
  //   0 - Watchdog Counter and Interrupt Enable
  assign WdogCtrlEn = (PADDR == `WDOGCONTROLA) ?
                        (PWRITE & FrcSel & ~PENABLE & ~WdogLock) : 1'b0;

  always @ (negedge PRESETn or posedge PCLK)
    begin : p_CtrlSeq
      if (!PRESETn)
        WdogControl[1:0] <= 2'b00;
      else
        if (WdogCtrlEn)
          WdogControl[1:0] <= PWDATA[1:0];
    end 

  assign WdogResEn = WdogControl[1];
  assign WdogIntEn = WdogControl[0];

  // The counter (in the WDOGCLK domain) needs to be reset to WdogLoad
  // when the interrupt is re-enabled.  WdogIntEnRise will assert for
  // one WDOGCLK cycle after a rising edge on WdogIntEn and is
  // factored into the counter reset

  always @ (negedge WDOGRESn or posedge WDOGCLK)
    begin : p_WdogIntEnRegSeq
      if (!WDOGRESn)
        WdogIntEnReg <= 1'b0;
      else
        if (WDOGCLKEN)
          WdogIntEnReg <= WdogIntEn;
    end

  assign WdogIntEnRise = WdogIntEn & (~WdogIntEnReg);

//----------------------------------------------------------------------------
// WdogLoad Register
//----------------------------------------------------------------------------
// WdogLoad value for Watchdog - when this register is written to,
// the counter will be loaded with this value before carrying on
// counting.
//0x00
 assign LoadEn = (PADDR == `WDOGLOADA) ?
                 (PWRITE & FrcSel & ~PENABLE & ~WdogLock) : 1'b0;

 
 always @ (negedge PRESETn or posedge PCLK)
    begin : p_LoadSeq
      if (!PRESETn)
        WdogLoad <= {32{1'b1}};
      else
        if (LoadEn)
          WdogLoad <= PWDATA;
    end 

//----------------------------------------------------------------------------
// Load enable register
//----------------------------------------------------------------------------
// The LoadEn pulse needs to be sampled into the WDOGCLK domain even if PCLK 
// is subsequently disabled.
  
// NOTE There is a limitation of this logic: if more than one load is 
//  performed in one WDOGCLK pulse and the last LoadEn is sampled on the 
//  WDOGCLK edge, then the value will not be loaded until the Watchdog timer
//  next wraps.
  
// LoadReqTogP is toggled if a new load request is received and there are no
//  pending load requests. This prevents multiple toggles before the next
//  WDOGCLK edge.

  assign LoadTogEn = (LoadEn & ~LoadReqW) ? 1'b1 : 1'b0;
  
  // LoadTogEn high toggles LoadReqTog on next PCLK
  always @ (negedge PRESETn or posedge PCLK)
    begin : p_LoadReqTogPSeq
      if (!PRESETn)
        LoadReqTogP <= 1'b0;
      else
        if (LoadTogEn)
          LoadReqTogP <= (~LoadReqTogP);
    end 

  // Register LoadReqTog into WDOGCLK domain
  always @(negedge WDOGRESn or posedge WDOGCLK)
  begin : p_LoadReqTogWSeq
    if (!WDOGRESn)
      LoadReqTogW <= 1'b0;
    else 
      if (WDOGCLKEN)
        LoadReqTogW <= LoadReqTogP;
  end
 
  // LoadReqW goes high on the PCLK edge after LoadTogEn and low on the next
  //  valid WDOGCLK edge
  assign LoadReqW = (LoadReqTogP ^ LoadReqTogW);

//----------------------------------------------------------------------------
// 32-bit count down with load.
//----------------------------------------------------------------------------
// NxtCount is set to Count when Carry = 0 so that loads also change the 
//  value of NxtCount.
// 32 bit counter is implemented as two 16 bit counters to improve FPGA
//  synthesis.

  // Halfword 0, bits 15:0
  always @ (Count)
    begin : p_Dec0Comb
      NxtCount[15:0] = (Count[15:0] - 1'b1);
    end 

  always @ (Count)
    begin : p_Carry0Comb
      if (Count[15:0] == 16'h0000)
        Carry[0] = 1'b1;
      else
        Carry[0] = 1'b0;
    end 

  // Halfword 1, bits 31:16
  always @ (Count or Carry)
    begin : p_Dec1Comb
      if (Carry[0])
        NxtCount[31:16] = (Count[31:16] - 1'b1);
      else
        NxtCount[31:16] = Count[31:16];
    end 

  always @ (Count or Carry)
    begin : p_Carry1Comb
      if ((Count[31:16] == 16'h0000) && Carry[0])
        Carry[1] = 1'b1;
      else
        Carry[1] = 1'b0;
    end 

  // The most significant carry bit changes when in 16 or 32-bit counter modes.
  assign CarryMSB = Carry[1];

  //----------------------------------------------------------------------------
  // Counter register
  //----------------------------------------------------------------------------
  // Reloads from Load when CarryMSB is set.

  // Load the counter with the value from WdogLoad when:
  //   - a new value has been written (re-setting the Watchdog)
  //   - the count reaches zero
  //   - the interrupt output is enabled
  //   - the interrupt output is cleared
  assign CountMux = (LoadReqW ||           // new value written
                     CarryMSB ||           // count reaches zero
                     WdogIntEnRise ||      // IRQ output enabled
                     IntClrW ? WdogLoad :  // IRQ output cleared

                     NxtCount); // otherwise decrement the counter
  
  // The counter needs to be disabled after the Watchdog has generated a reset.
  // It is re-enabled when a new value is written to the Load register.
  assign CountStop = (iWdogRes ? 1'b1 :
                      
                      LoadReqW ? 1'b0 :
                      
                      CountStopReg);

  always @ (negedge WDOGRESn or posedge WDOGCLK)
    begin : p_CountStopSeq
      if (!WDOGRESn)
        CountStopReg <= 1'b0;
      else
        if (WDOGCLKEN)
          CountStopReg <= CountStop;
    end 

  // Enable to counter registers, including the count disable, the interrupt 
  //  enable and the load command.
  assign CountEn = (WDOGCLKEN & WdogIntEn & ~CountStop) | LoadReqW;

  // Counter registers using rising edge of WDOGCLK.
  // CountEn is used to enable the counter.
  // Reset sets all outputs HIGH to avoid interrupt generation at
  //  start.
  always @ (negedge WDOGRESn or posedge WDOGCLK)
    begin : p_CountSeq
      if (!WDOGRESn)
        Count <= {32{1'b1}};
      else
        if (CountEn)
          Count <= CountMux;
    end 

  //----------------------------------------------------------------------------
  // Interrupt clear
  //----------------------------------------------------------------------------
  // CarryMSB can be valid for multiple clock cycles, and may not have cleared 
  //  until after an interrupt clear has been asserted, allowing the interrupt
  //  to be entered again. The interrupt clear is extended to ensure that it
  //  remains valid until the interrupt is actually cleared in the WDOGCLK
  //  domain. A toggle based handshake is used in case PCLK is removed before
  //  the interrupt clear operation is complete.

  assign IntClrEn = (!IntClrW &&                  // no pending IntClr operation
                     PWRITE && FrcSel && !PENABLE && !WdogLock && 
                     (PADDR == `WDOGCLEARA) ? 1'b1 : // IntClr transaction

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

  // Register IntClrTogP into WDOGCLK domain
  always @(negedge WDOGRESn or posedge WDOGCLK)
  begin : p_IntClrTogWSeq
    if (!WDOGRESn)
      IntClrTogW <= 1'b0;
    else 
      if (WDOGCLKEN)
        IntClrTogW <= IntClrTogP;
  end

  // IntClrPulse is high on PCLK edge, low on WDOGCLK edge
  assign IntClrPulse = (IntClrTogP ^ IntClrTogW);

  // IntClrW is used to clear the interrupt. It is asserted when the APB IntClr
  //  transaction is detected and de-asserted when the counter is no longer zero
  //  (to prevent multiple interrupts from one counter event).
  assign IntClrW = (IntClrPulse ? 1'b1 : // IntClr transaction sampled into 
                                         //  WDOGCLK domain

                    !CarryMSB ? 1'b0 :   // counter no longer zero

                    IntClrRegW);

  // Register IntClrW to hold it until counter is non-zero.
  always @(negedge WDOGRESn or posedge WDOGCLK)
  begin : p_IntClrRegSeq
    if (!WDOGRESn)
      IntClrRegW <= 1'b0;
    else
      if (WDOGCLKEN)
        IntClrRegW <= IntClrW;
  end
                  
  //----------------------------------------------------------------------------
  // Interrupt generation
  //----------------------------------------------------------------------------

  // The interrupt is generated (HIGH) when the counter reaches zero.
  // The interrupt is cleared (LOW) when the WdogIntClr address is written to.
  assign NxtWdogRIS = ((CarryMSB | WdogRIS) & ~IntClrW);

  // Register and hold interrupt until cleared.  WDOGCLK is used to ensure that
  //  an interrupt is still generated even if PCLK is disabled.
  always @ (negedge WDOGRESn or posedge WDOGCLK)
    begin : p_IntSeq
      if (!WDOGRESn)
        WdogRIS <= 1'b0;
      else
        if (WDOGCLKEN)
          WdogRIS <= NxtWdogRIS;
    end 

  // Gate raw interrupt with enable bit
  assign WdogMIS = (WdogRIS & WdogIntEn);
  
  // Drive output with internal signal
  assign WDOGINT = WdogMIS;

  //----------------------------------------------------------------------------
  // Reset generation
  //----------------------------------------------------------------------------
  // The reset output is activated when the counter reaches zero and the 
  //  interrupt output is active, indicating that the counter has previously
  //  reached zero but not been serviced.
  assign NxtWdogRes = (!WdogResEn ? 1'b0 :            // Watchdog reset disabled

                       (WdogMIS && CarryMSB) ? 1'b1 : // masked IRQ asserted and 
                                                      // counter is zero

                       iWdogRes);


  // WdogRes register                       
  always @ (negedge WDOGRESn or posedge WDOGCLK)
    begin : p_ResSeq
      if (!WDOGRESn)
        iWdogRes <= 1'b0;
      else
        if (WDOGCLKEN)
          iWdogRes <= NxtWdogRes;
    end 

  // Drive reset output
  assign WDOGRES = iWdogRes;

  //----------------------------------------------------------------------------
  // Output data generation
  //----------------------------------------------------------------------------

  // Zero data is used as padding for other register reads
  always @ (PWRITE or FrcSel or PADDR or WdogLoad or Count or WdogControl
            or WdogRIS or WdogMIS)
    begin : p_FrcDataComb
      
      FrcData = {32{1'b0}}; // Drive zeros by default
      
      if (!PWRITE && FrcSel)
        case (PADDR)
          `WDOGLOADA :
            // WdogLoad address
            FrcData = WdogLoad;

          `WDOGVALUEA : 
            // WdogValue address
            FrcData = Count;

          `WDOGCONTROLA : 
            // WdogControl address
            FrcData[1:0] = WdogControl[1:0];
          
          `WDOGINTRAWA : 
            // WdogRIS address
            FrcData[0] = WdogRIS;

          `WDOGINTA : 
            // WdogMIS address
            FrcData[0] = WdogMIS;

          default: 
            FrcData = {32{1'b0}};

        endcase
      else
        FrcData = {32{1'b0}};
    end

endmodule

// --============================ End ========================================--
