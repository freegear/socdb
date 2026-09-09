// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 1999 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
// -----------------------------------------------------------------------------
// 
// Version and Release Control Information:
// 
// File Name           : Dcdc.v,v
// File Revision       : 1.2
// 
// Release Information : PL160-REL1v1
// 
// -----------------------------------------------------------------------------
// Purpose             : This block is the top-level block which instantiates
//                       the functional sub-blocks.
//
// --=========================================================================--

// -----------------------------------------------------------------------------
// Overview
// The DC-DC Converter Interface Module (Dcdc) interfaces to the AMBA
// APB bus architecture and provides control and status for dual DC-DC
// convertors external to this chip. This includes independent output
// frequency, duty cycle, drive polarity, external feedback and mode
// control for each convertor.
// -----------------------------------------------------------------------------

module Dcdc(
          // Inputs
            DCDCCLK,
            PCLK, 
            BnRES, 
            nDCDCRST, 
            SCANMODE, 
            PSEL, 
            PENABLE, 
            PWRITE,
            PADDR, 
            PWDATA, 
            DCDCDRIVE1IN, 
            DCDCDRIVE0IN, 
            DCDCFB1, 
            DCDCFB0,
            DCDCDR1SEL, 
            DCDCDR0SEL, 
          
          // Outputs
            PRDATA, 
            DCDCDRIVEOE, 
            DCDCDRIVE1OUT,
            DCDCDRIVE0OUT
           );


// -----------------------------------------------------------------------------
//     AMBA/APB Inputs
// -----------------------------------------------------------------------------
input   DCDCCLK;            // Base Clock Frequency for Drive Outputs
input   PCLK;               // APB Bus Clock
input   BnRES;              // AMBA Bus reset
input   nDCDCRST;           // DCDC clock domain reset
input   SCANMODE;           // Scan Mode Reset Select
input   PSEL;               // APB Peripheral select
input   PENABLE;            // APB Peripheral enable
input   PWRITE;             // APB Peripheral write
input   [7:2] PADDR;        // APB Address bus
input   [7:0] PWDATA;       // APB write databus


// -----------------------------------------------------------------------------
//     External Inputs
// -----------------------------------------------------------------------------
input   DCDCDRIVE1IN;       // External Drive 1 Polarity Sample Input
input   DCDCDRIVE0IN;       // External Drive 0 Polarity Sample Input
input   DCDCFB1;            // External Feed Back 1
input   DCDCFB0;            // External Feed Back 0
input   DCDCDR1SEL;         // External Drive 1 Duty Cycle Select
input   DCDCDR0SEL;         // External Drive 0 Duty Cycle Select


// -----------------------------------------------------------------------------
//     AMBA/ABP Outputs
// -----------------------------------------------------------------------------
output  [7:0] PRDATA;       // APB read databus


// -----------------------------------------------------------------------------
//     External Outputs
// -----------------------------------------------------------------------------
output  DCDCDRIVEOE;        // External Drive Output Enable
output  DCDCDRIVE1OUT;      // External Drive 1 Output
output  DCDCDRIVE0OUT;      // External Drive 0 Output


// -----------------------------------------------------------------------------
//     Internal Wire Declarations
// -----------------------------------------------------------------------------
wire PMPCON0WrEn;           // Configuration Reg 0 Write Enable
wire PMPCON1WrEn;           // Configuration Reg 1 Write Enable
wire PMPFREQWrEn;           // Frequency Configuration Reg Write Enable
wire PMPTCERWrEn;           // Test Clock Enable Reg Write Enable
wire PMPTCERrd;             // Test Clock Enable Reg Read
wire PMPTCRWrEn;            // Test Control Reg Write Enable
wire PMPTMRWrEn;            // Test Mode Reg Write Enable
wire PMPTISRWrEn;           // Test Input Stimulus Reg  Write Enable
wire nRES;                  // Dcdc System Reset
wire nDCDCRES;              // DCDC clock domain  Reset
wire ClkEn;                 // Clock Enable for Clock Enabled Test Mode
wire [4:0]FreqCnt0;         // Frequency Counter 0 Status
wire [4:0]FreqCnt1;         // Frequency Counter 1 Status
wire [3:0]Drv0Cnt;          // Drive 0 Counter Status
wire [3:0]Drv1Cnt;          // Drive 1 Counter Status
wire DCDCDRIVEOEPSync;      // Drive  Output Enable Synced to PCLK
wire DCDCDRIVE0OUTPSync;    // Drive 0 Output Synced to PCLK
wire DCDCDRIVE1OUTPSync;    // Drive 1 Output Synced to PCLK
wire Fb0Sync;               // Drive 0 Feedback Synced to DCDCCLK
wire Fb1Sync;               // Drive 1 Feedback Synced to DCDCCLK
wire Drv0SelSync;           // Drive 0 Select Synced to DCDCCLK
wire Drv1SelSync;           // Drive 1 Select Synced to DCDCCLK
wire Fb0;                   // Drive 0 Feedback
wire Fb1;                   // Drive 1 Feedback 
wire Drv0Sel;               // Drive 0 Select
wire Drv1Sel;               // Drive 1 Select
wire FREQUpdate;            // Update DCDCFREQ
wire CON0Update;            // Update DCDCCON0
wire CON1Update;            // Update DCDCCON1
wire FREQUpdateSync;        // Update DCDCFREQ Synced to DCDCCLK
wire CON0UpdateSync;        // Update DCDCCON0 Synced to DCDCCLK
wire CON1UpdateSync;        // Update DCDCCON1 Synced to DCDCCLK
wire [7:0]PWDATAIn;         // Gated Write Data In
wire [7:0]PMPCON0;          // Drive 0 Dty Cycle 
wire [7:0]PMPCON1;          // Drive 1 Dty Cycle 
wire [7:0]PMPFREQ;          // Drives 0 and 1 Frequencies 
wire [4:0]PMPTCR;           // Test Control Register
wire [1:0]PMPTMR;           // Test Mode Register
wire [5:0]PMPTISR;          // Test Input Stimulus Register


// -----------------------------------------------------------------------------
// This block provides the Dcdc interface to the APB bus
// -----------------------------------------------------------------------------
 DcdcApbif uDcdcApbif       ( .PCLK(PCLK),
                              .BnRES(BnRES),
                              .PSEL(PSEL),
                              .PENABLE(PENABLE),
                              .PWRITE(PWRITE),
                              .PADDR(PADDR),
                              .PWDATA(PWDATA),
                              .PMPFREQ(PMPFREQ),
                              .PMPCON0(PMPCON0),
                              .PMPCON1(PMPCON1),
                              .PMPTCR(PMPTCR),
                              .PMPTMR(PMPTMR),
                              .PMPTISR(PMPTISR),
                              .FreqCnt0(FreqCnt0),
                              .FreqCnt1(FreqCnt1),
                              .Drv0Cnt(Drv0Cnt),
                              .Drv1Cnt(Drv1Cnt),
                              .DCDCDRIVEOEPSync(DCDCDRIVEOEPSync),
                              .DCDCDRIVE1OUTPSync(DCDCDRIVE1OUTPSync),
                              .DCDCDRIVE0OUTPSync(DCDCDRIVE0OUTPSync),
                              .PWDATAIn(PWDATAIn),
                              .PRDATA(PRDATA),
                              .PMPCON0WrEn(PMPCON0WrEn),
                              .PMPCON1WrEn(PMPCON1WrEn),
                              .PMPFREQWrEn(PMPFREQWrEn),
                              .PMPTCERWrEn(PMPTCERWrEn),
                              .PMPTCERrd(PMPTCERrd),
                              .PMPTCRWrEn(PMPTCRWrEn),
                              .PMPTMRWrEn(PMPTMRWrEn),
                              .PMPTISRWrEn(PMPTISRWrEn)
                             );


// -----------------------------------------------------------------------------
// This block provides Control and Test functionality
// -----------------------------------------------------------------------------
 DcdcCntl uDcdcCntl         (  .PCLK(PCLK),
                               .BnRES(BnRES),
                               .nDCDCRST(nDCDCRST),
                               .SCANMODE(SCANMODE),
                               .PSEL(PSEL),
                               .PENABLE(PENABLE),
                               .PWDATAIn(PWDATAIn),
                               .PMPCON0WrEn(PMPCON0WrEn),
                               .PMPCON1WrEn(PMPCON1WrEn),
                               .PMPFREQWrEn(PMPFREQWrEn),
                               .PMPTCERWrEn(PMPTCERWrEn),
                               .PMPTCERrd(PMPTCERrd),
                               .PMPTCRWrEn(PMPTCRWrEn),
                               .PMPTMRWrEn(PMPTMRWrEn),
                               .PMPTISRWrEn(PMPTISRWrEn),
                               .nRES(nRES),
                               .nDCDCRES(nDCDCRES),
                               .ClkEn(ClkEn),
                               .PMPFREQ(PMPFREQ),
                               .PMPCON0(PMPCON0),
                               .PMPCON1(PMPCON1),
                               .PMPTCR(PMPTCR),
                               .PMPTMR(PMPTMR),
                               .PMPTISR(PMPTISR),
                               .FREQUpdate(FREQUpdate),
                               .CON0Update(CON0Update),
                               .CON1Update(CON1Update)
                              );


// -----------------------------------------------------------------------------
// This block provides the sync cells for the PCLK Domain
// -----------------------------------------------------------------------------
 DcdcPclkSync uDcdcPclkSync (  .PCLK(PCLK),
                               .nRES(nRES),
                               .DCDCDRIVEOE(DCDCDRIVEOE),
                               .DCDCDRIVE0OUT(DCDCDRIVE0OUT),
                               .DCDCDRIVE1OUT(DCDCDRIVE1OUT),
                               .DCDCDRIVEOEPSync(DCDCDRIVEOEPSync),
                               .DCDCDRIVE0OUTPSync(DCDCDRIVE0OUTPSync),
                               .DCDCDRIVE1OUTPSync(DCDCDRIVE1OUTPSync)
                              );


// -----------------------------------------------------------------------------
// This block provides the Drive Outputs by dividing down the DCDCCLK
// -----------------------------------------------------------------------------
 DcdcDrive uDcdcDrive       (  .DCDCCLK(DCDCCLK),
                               .nDCDCRES(nDCDCRES),
			       .DCDCFB0(DCDCFB0),
			       .DCDCFB1(DCDCFB1),
			       .DCDCDR0SEL(DCDCDR0SEL),
			       .DCDCDR1SEL(DCDCDR1SEL),
			       .DCDCDRIVE0IN(DCDCDRIVE0IN),
			       .DCDCDRIVE1IN(DCDCDRIVE1IN),
                               .PMPCON0(PMPCON0),
                               .PMPCON1(PMPCON1),
                               .PMPFREQ(PMPFREQ),
                               .PMPTCR(PMPTCR[4]),
                               .PMPTMR(PMPTMR),
                               .PMPTISR(PMPTISR),
                               .FREQUpdateSync(FREQUpdateSync),
                               .CON0UpdateSync(CON0UpdateSync),
                               .CON1UpdateSync(CON1UpdateSync),
                               .ClkEn(ClkEn),
			       .Fb0Sync(Fb0Sync),
			       .Fb1Sync(Fb1Sync),
			       .Drv0SelSync(Drv0SelSync),
			       .Drv1SelSync(Drv1SelSync),
                               .DCDCDRIVE0OUT(DCDCDRIVE0OUT),
                               .DCDCDRIVE1OUT(DCDCDRIVE1OUT),
                               .DCDCDRIVEOE(DCDCDRIVEOE),
                               .FreqCnt0(FreqCnt0),
                               .FreqCnt1(FreqCnt1),
                               .Drv0Cnt(Drv0Cnt),
                               .Drv1Cnt(Drv1Cnt),
			       .Fb0(Fb0),
			       .Fb1(Fb1),
			       .Drv0Sel(Drv0Sel),
			       .Drv1Sel(Drv1Sel)
                              );


// -----------------------------------------------------------------------------
// This block provides the sync cells for the DCDCCLK Domain
// -----------------------------------------------------------------------------
 DcdcClkSync uDcdcClkSync   (  .DCDCCLK(DCDCCLK),
                               .nDCDCRES(nDCDCRES),
                               .FREQUpdate(FREQUpdate),
                               .CON0Update(CON0Update),
                               .CON1Update(CON1Update),
			       .Fb0(Fb0),
			       .Fb1(Fb1),
			       .Drv0Sel(Drv0Sel),
			       .Drv1Sel(Drv1Sel),
                               .FREQUpdateSync(FREQUpdateSync),
                               .CON0UpdateSync(CON0UpdateSync),
                               .CON1UpdateSync(CON1UpdateSync),
			       .Fb0Sync(Fb0Sync),
			       .Fb1Sync(Fb1Sync),
			       .Drv0SelSync(Drv0SelSync),
			       .Drv1SelSync(Drv1SelSync)
                            );

endmodule

// --================================= End ===================================--
