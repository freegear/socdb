// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : Vic.v.rca
// File Revision          : 1.16
//
// Release Information    : PrimeCell(TM)-PL192-r0p0-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           This block is the top level of the VIC.
//
// --=========================================================================--

`timescale 1ns/1ps

// -----------------------------------------------------------------------------
module Vic (
            HCLK,
            HRESETn,
            HSELVIC,
            HADDR,
            HWRITE,
            HREADYIN,
            HPROT,
            HTRANS,
            HSIZE,
            HWDATA,
            VICINTSOURCE,
            nVICSYNCEN,
            VICIRQACK,
            nVICFIQIN,
            nVICIRQIN,
            VICVECTADDRIN,
            VICFIQINREG,
            VICIRQINREG,
            SCANENABLE,
            SCANINHCLK,

            HREADYOUT,
            HRESP,
            HRDATA,
            nVICFIQ,
            nVICIRQ,
            VICVECTADDROUT,
            VICVECTADDRV,
            VICIRQACKOUT,
            SCANOUTHCLK
           );
// Input
input         HCLK;            // AHB Clock
input         HRESETn;         // AHB reset
input         HSELVIC;         // VIC slave select
input  [11:2] HADDR;           // AHB address bus
input         HWRITE;          // AHB operation select
input         HREADYIN;        // Transfer done response on AHB from
                               // previous Slave
input   [3:0] HPROT;           // AHB protection mode
input   [1:0] HTRANS;          // AHB transfer type
input   [2:0] HSIZE;           // AHB transfer size
input  [31:0] HWDATA;          // AHB write data
input  [31:0] VICINTSOURCE;    // Peripheral interrupt source input
input         nVICSYNCEN;      // Synchronous enable signal for the VIC port
                               // signals
input         VICIRQACK;       // Acknowledge signal from the CPU
input         nVICFIQIN;       // FIQ interrupt from the daisy chain VIC
input         nVICIRQIN;       // IRQ interrupt from the daisy chain VIC
input  [31:0] VICVECTADDRIN;   // Vector address from the daisy chain VIC
input         VICFIQINREG;     // Register enable signal for VICFIQIN
input         VICIRQINREG;     // Register enable signal for VICIRQIN
input         SCANENABLE;      // Scan enable
input         SCANINHCLK;      // Scan input for HCLK domain

// Outputs
output        HREADYOUT;       // Transfer done response for AHB
output  [1:0] HRESP;           // Transfer response to AHB
output [31:0] HRDATA;          // Read data to AHB
output        nVICFIQ;         // FIQ to the CPU
output        nVICIRQ;         // IRQ to the CPU
output [31:0] VICVECTADDROUT;  // ISR address to the CPU
output        VICVECTADDRV;    // Address valid signal
output        VICIRQACKOUT;    // ACKOUT signal to the daisy chain VIC
output        SCANOUTHCLK;     // Scan output for HCLK domain

wire          HCLK;            // AHB Clock
wire          HRESETn;         // AHB Reset
wire          HSELVIC;         // VIC select
wire   [11:2] HADDR;           // AHB address bus
wire          HWRITE;          // AHB Write
wire          HREADYIN;        // Shared HREADY line
wire    [3:0] HPROT;           // Protection mode
wire    [1:0] HTRANS;          // AHB transfer type
wire    [2:0] HSIZE;           // AHB transfer size
wire   [31:0] HWDATA;          // Write data bus
wire   [31:0] VICINTSOURCE;    // Peripheral interrupt source input
wire          nVICSYNCEN;      // synchronization setting
wire          VICIRQACK;       // IRQ acknowledge from CPU
wire          nVICFIQIN;       // Fast interrupt input from the daisy chain VIC
wire          nVICIRQIN;       // Normal interrupt input from daisy chain VIC
wire   [31:0] VICVECTADDRIN;   // Vector address from the daisy chain VIC
wire          VICFIQINREG;     // Register enable signal for VICFIQIN
wire          VICIRQINREG;     // Register enable signal for VICIRQIN
wire          SCANENABLE;      // Scan Enable
wire          SCANINHCLK;      // HCLK domain Scan input
wire          HREADYOUT;       // VIC ready signal
wire    [1:0] HRESP;           // transfer response
wire   [31:0] HRDATA;          // Read data bus
wire          nVICFIQ;         // Fast Interrupt request
wire          nVICIRQ;         // Normal Interrupt request
wire   [31:0] VICVECTADDROUT;  // Vector
wire          VICVECTADDRV;    // Address valid signal
wire          VICIRQACKOUT;    // ACKOUT signal to the daisy chain VIC
wire          SCANOUTHCLK;     // HCLK domain Scan output
wire   [31:0] VICFIQStatus;    // Status of the FIQ after disabling
                               // the interrupt
wire   [31:0] VICIRQStatus;    // Status of the IRQ after disabling
                               // the interrupt
wire   [31:0] VICRawIntr;      // RAW interrupt status before masking interrupt
wire   [31:0] VICSoftInt;      // Software interrupt
wire   [31:0] VICIntEnable;    // Interrupt enable
wire   [31:0] VICIntSelect;    // Interrupt type select
wire   [15:0] SWPriorityMask;  // Software Priority

wire   [31:0] VectAddr0;       // Vector address for 0th interrupt source
wire   [31:0] VectAddr1;       // Vector address for 1st interrupt source
wire   [31:0] VectAddr2;       // Vector address for 2nd interrupt source
wire   [31:0] VectAddr3;       // Vector address for 3rd interrupt source
wire   [31:0] VectAddr4;       // Vector address for 4th interrupt source
wire   [31:0] VectAddr5;       // Vector address for 5th interrupt source
wire   [31:0] VectAddr6;       // Vector address for 6th interrupt source
wire   [31:0] VectAddr7;       // Vector address for 7th interrupt source
wire   [31:0] VectAddr8;       // Vector address for 8th interrupt source
wire   [31:0] VectAddr9;       // Vector address for 9th interrupt source
wire   [31:0] VectAddr10;      // Vector address for 10th interrupt source
wire   [31:0] VectAddr11;      // Vector address for 11th interrupt source
wire   [31:0] VectAddr12;      // Vector address for 12th interrupt source
wire   [31:0] VectAddr13;      // Vector address for 13th interrupt source
wire   [31:0] VectAddr14;      // Vector address for 14th interrupt source
wire   [31:0] VectAddr15;      // Vector address for 15th interrupt source
wire   [31:0] VectAddr16;      // Vector address for 16th interrupt source
wire   [31:0] VectAddr17;      // Vector address for 17th interrupt source
wire   [31:0] VectAddr18;      // Vector address for 18th interrupt source
wire   [31:0] VectAddr19;      // Vector address for 19th interrupt source
wire   [31:0] VectAddr20;      // Vector address for 20th interrupt source
wire   [31:0] VectAddr21;      // Vector address for 21st interrupt source
wire   [31:0] VectAddr22;      // Vector address for 22nd interrupt source
wire   [31:0] VectAddr23;      // Vector address for 23rd interrupt source
wire   [31:0] VectAddr24;      // Vector address for 24th interrupt source
wire   [31:0] VectAddr25;      // Vector address for 25th interrupt source
wire   [31:0] VectAddr26;      // Vector address for 26th interrupt source
wire   [31:0] VectAddr27;      // Vector address for 27th interrupt source
wire   [31:0] VectAddr28;      // Vector address for 28th interrupt source
wire   [31:0] VectAddr29;      // Vector address for 29th interrupt source
wire   [31:0] VectAddr30;      // Vector address for 30th interrupt source
wire   [31:0] VectAddr31;      // Vector address for 31st interrupt source
wire   [3:0] VectPriority0;    // Vector priority for 0th interrupt source
wire   [3:0] VectPriority1;    // Vector priority for 1st interrupt source
wire   [3:0] VectPriority2;    // Vector priority for 2nd interrupt source
wire   [3:0] VectPriority3;    // Vector priority for 3rd interrupt source
wire   [3:0] VectPriority4;    // Vector priority for 4th interrupt source
wire   [3:0] VectPriority5;    // Vector priority for 5th interrupt source
wire   [3:0] VectPriority6;    // Vector priority for 6th interrupt source
wire   [3:0] VectPriority7;    // Vector priority for 7th interrupt source
wire   [3:0] VectPriority8;    // Vector priority for 8th interrupt source
wire   [3:0] VectPriority9;    // Vector priority for 9th interrupt source
wire   [3:0] VectPriority10;   // Vector priority for 10th interrupt source
wire   [3:0] VectPriority11;   // Vector priority for 11th interrupt source
wire   [3:0] VectPriority12;   // Vector priority for 12th interrupt source
wire   [3:0] VectPriority13;   // Vector priority for 13th interrupt source
wire   [3:0] VectPriority14;   // Vector priority for 14th interrupt source
wire   [3:0] VectPriority15;   // Vector priority for 15th interrupt source
wire   [3:0] VectPriority16;   // Vector priority for 16th interrupt source
wire   [3:0] VectPriority17;   // Vector priority for 17th interrupt source
wire   [3:0] VectPriority18;   // Vector priority for 18th interrupt source
wire   [3:0] VectPriority19;   // Vector priority for 19th interrupt source
wire   [3:0] VectPriority20;   // Vector priority for 20th interrupt source
wire   [3:0] VectPriority21;   // Vector priority for 21st interrupt source
wire   [3:0] VectPriority22;   // Vector priority for 22nd interrupt source
wire   [3:0] VectPriority23;   // Vector priority for 23rd interrupt source
wire   [3:0] VectPriority24;   // Vector priority for 24th interrupt source
wire   [3:0] VectPriority25;   // Vector priority for 25th interrupt source
wire   [3:0] VectPriority26;   // Vector priority for 26th interrupt source
wire   [3:0] VectPriority27;   // Vector priority for 27th interrupt source
wire   [3:0] VectPriority28;   // Vector priority for 28th interrupt source
wire   [3:0] VectPriority29;   // Vector priority for 29th interrupt source
wire   [3:0] VectPriority30;   // Vector priority for 30th interrupt source
wire   [3:0] VectPriority31;   // Vector priority for 31st interrupt source
wire   [3:0] VectPriority32;   // Vector priority daisy chain interrupt

// -----------------------------------------------------------------------------
//
//                                    Vic
//                                    ===
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Wire declarations
// -----------------------------------------------------------------------------
wire   [31:0] VICVectAddrVal;  // VIC vector address of the ISR
wire          IRQSWAck;        // Stack push control
wire          IRQSWClear;      // Stack pop control
wire   [15:0] CurrentPriority; // Current interrupt priority
wire          IRQRequest;      // IRQ request is active
wire    [5:0] IRQPort;         // Port number of the interrupt serviced
wire    [3:0] IRQReqLevel;     // Priority level of the interrupt serviced
wire          ITEN;            // Integration Test enable
wire          nVICIRQINFrcVal; // Force value for nVICIRQIN
wire          nVICFIQINFrcVal; // Force value for nVICFIQIN
wire          VICIRQACKFrcVal; // Force value for VICIRQACK i/p
wire   [31:0] VECTADDRINFrcVal;// Force value for VECTADDRIN
wire          VECTADDRVFrcVal; // Force value for VICVECTADDRV o/p
wire          VICIRQForceVal;  // Force value for nVICFIQ o/p
wire          VICFIQForceVal;  // Force value for nVICIRQ o/p
wire          IRQACKOUTFrcVal; // Force value for IRQACKOUT o/p
wire   [31:0] VECTADDRFrcVal;  // Force value for VICVectAddr
wire          nVICIRQINTestVal;// Integration test value of nVICIRQIN
wire          nVICFIQINTestVal;// Integration test value of nVICFIQIN
wire          VICIRQACKTestVal;// Integration test value of VICIRQACK
wire   [31:0] VECTADDRINTstVal;// Integration test value of VICVECTADDRIN
wire          VECTADDRVTestVal;// Integration test value of VICVECTADDRV
wire          VICIRQTestVal;   // Integration test value of VICIRQ
wire          VICFIQTestVal;   // Integration test value of VICFIQ
wire          IRQACKOUTTestVal;// Integration test value for VICIRQACKOUT
wire   [31:0] VECTADDRTestVal; // Integration test for VECTADDR
wire    [3:0] Revision;        // Revision number for VIC
wire    [3:0] TieOff1;         // Tie off1
wire    [3:0] TieOff2;         // Tie off2

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
//
// Main body of code
// =================
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Instantiation of the VicInterrupt
// -----------------------------------------------------------------------------
VicInterrupt  uVicInterrupt (
// Inputs

// AHB signals
        .HCLK             (HCLK),
        .HRESETn          (HRESETn),

// Interrupt signals
        .VICINTSOURCE     (VICINTSOURCE),
        .VICSoftInt       (VICSoftInt),
        .nVICIRQIN        (nVICIRQIN),
        .nVICFIQIN        (nVICFIQIN),
        .VICFIQINREG      (VICFIQINREG),
        .VICIRQINREG      (VICIRQINREG),
        .VICIntEnable     (VICIntEnable),
        .VICIntSelect     (VICIntSelect),
        .SWPriorityMask   (SWPriorityMask),
        .PLevel0          (VectPriority0),
        .PLevel1          (VectPriority1),
        .PLevel2          (VectPriority2),
        .PLevel3          (VectPriority3),
        .PLevel4          (VectPriority4),
        .PLevel5          (VectPriority5),
        .PLevel6          (VectPriority6),
        .PLevel7          (VectPriority7),
        .PLevel8          (VectPriority8),
        .PLevel9          (VectPriority9),
        .PLevel10         (VectPriority10),
        .PLevel11         (VectPriority11),
        .PLevel12         (VectPriority12),
        .PLevel13         (VectPriority13),
        .PLevel14         (VectPriority14),
        .PLevel15         (VectPriority15),
        .PLevel16         (VectPriority16),
        .PLevel17         (VectPriority17),
        .PLevel18         (VectPriority18),
        .PLevel19         (VectPriority19),
        .PLevel20         (VectPriority20),
        .PLevel21         (VectPriority21),
        .PLevel22         (VectPriority22),
        .PLevel23         (VectPriority23),
        .PLevel24         (VectPriority24),
        .PLevel25         (VectPriority25),
        .PLevel26         (VectPriority26),
        .PLevel27         (VectPriority27),
        .PLevel28         (VectPriority28),
        .PLevel29         (VectPriority29),
        .PLevel30         (VectPriority30),
        .PLevel31         (VectPriority31),
        .PLevel32         (VectPriority32),
        .CurrentPriority  (CurrentPriority),

// Test signals
        .ITEN             (ITEN),
        .nIRQINForceVal   (nVICIRQINFrcVal),
        .nFIQINForceVal   (nVICFIQINFrcVal),
        .IRQForceVal      (VICIRQForceVal),
        .FIQForceVal      (VICFIQForceVal),

// Outputs

// Test outputs
        .nIRQINTestVal    (nVICIRQINTestVal),
        .nFIQINTestVal    (nVICFIQINTestVal),
        .IRQTestVal       (VICIRQTestVal),
        .FIQTestVal       (VICFIQTestVal),

// Interrupt status to VicCpuif
        .IRQRequestRes    (IRQRequest),
        .IRQReqLevelRes   (IRQReqLevel),
        .IRQPortRes       (IRQPort),

// Interrupt outputs
        .nVICFIQ          (nVICFIQ),
        .nVICIRQ          (nVICIRQ),

// Interrupt status to VicAHBif
        .VICRawIntr       (VICRawIntr),
        .VICFIQStatus     (VICFIQStatus),
        .VICIRQStatus     (VICIRQStatus)
       );

// -----------------------------------------------------------------------------
// Instantiation of the VicAhbif
// -----------------------------------------------------------------------------
VicAhbif  uVicAhbif (
// Inputs

// AHB signals
        .HCLK             (HCLK),
        .HRESETn          (HRESETn),
        .HSELVIC          (HSELVIC),
        .HADDR            (HADDR[11:2]),
        .HTRANS1          (HTRANS[1]),
        .HWRITE           (HWRITE),
        .HREADYIN         (HREADYIN),
        .HPROT1           (HPROT[1]),
        .HSIZE            (HSIZE[2:0]),
        .HWDATA           (HWDATA),

// Revision of the module
        .Revision         (Revision),

// Interrupt related signals
        .VICFIQStatus     (VICFIQStatus),
        .VICIRQStatus     (VICIRQStatus),
        .VICRawIntr       (VICRawIntr),
        .VICINTSOURCE     (VICINTSOURCE),
        .VICVectAddrVal   (VICVectAddrVal),

// Test interface inputs
        .IRQACKTestVal    (VICIRQACKTestVal),
        .nIRQINTestVal    (nVICIRQINTestVal),
        .nFIQINTestVal    (nVICFIQINTestVal),
        .VADDRINTestVal   (VECTADDRINTstVal),
        .VADDRVTestVal    (VECTADDRVTestVal),
        .IRQTestVal       (VICIRQTestVal),
        .FIQTestVal       (VICFIQTestVal),
        .ACKOUTTestVal    (IRQACKOUTTestVal),
        .VADDRTestVal     (VECTADDRTestVal),

// Daisy chain input register configuration for read back in test register
        .VICFIQINREG      (VICFIQINREG),
        .VICIRQINREG      (VICIRQINREG),

// Outputs
// AHB signals
        .HRESP            (HRESP),
        .HREADYOUT        (HREADYOUT),
        .HRDATA           (HRDATA),

// Interrupt controls
        .VICSoftInt       (VICSoftInt),
        .VICIntEnable     (VICIntEnable),
        .VICIntSelect     (VICIntSelect),
        .SWPriorityMask   (SWPriorityMask),
        .VectAddr0        (VectAddr0),
        .VectAddr1        (VectAddr1),
        .VectAddr2        (VectAddr2),
        .VectAddr3        (VectAddr3),
        .VectAddr4        (VectAddr4),
        .VectAddr5        (VectAddr5),
        .VectAddr6        (VectAddr6),
        .VectAddr7        (VectAddr7),
        .VectAddr8        (VectAddr8),
        .VectAddr9        (VectAddr9),
        .VectAddr10       (VectAddr10),
        .VectAddr11       (VectAddr11),
        .VectAddr12       (VectAddr12),
        .VectAddr13       (VectAddr13),
        .VectAddr14       (VectAddr14),
        .VectAddr15       (VectAddr15),
        .VectAddr16       (VectAddr16),
        .VectAddr17       (VectAddr17),
        .VectAddr18       (VectAddr18),
        .VectAddr19       (VectAddr19),
        .VectAddr20       (VectAddr20),
        .VectAddr21       (VectAddr21),
        .VectAddr22       (VectAddr22),
        .VectAddr23       (VectAddr23),
        .VectAddr24       (VectAddr24),
        .VectAddr25       (VectAddr25),
        .VectAddr26       (VectAddr26),
        .VectAddr27       (VectAddr27),
        .VectAddr28       (VectAddr28),
        .VectAddr29       (VectAddr29),
        .VectAddr30       (VectAddr30),
        .VectAddr31       (VectAddr31),
        .VectPriority0    (VectPriority0),
        .VectPriority1    (VectPriority1),
        .VectPriority2    (VectPriority2),
        .VectPriority3    (VectPriority3),
        .VectPriority4    (VectPriority4),
        .VectPriority5    (VectPriority5),
        .VectPriority6    (VectPriority6),
        .VectPriority7    (VectPriority7),
        .VectPriority8    (VectPriority8),
        .VectPriority9    (VectPriority9),
        .VectPriority10   (VectPriority10),
        .VectPriority11   (VectPriority11),
        .VectPriority12   (VectPriority12),
        .VectPriority13   (VectPriority13),
        .VectPriority14   (VectPriority14),
        .VectPriority15   (VectPriority15),
        .VectPriority16   (VectPriority16),
        .VectPriority17   (VectPriority17),
        .VectPriority18   (VectPriority18),
        .VectPriority19   (VectPriority19),
        .VectPriority20   (VectPriority20),
        .VectPriority21   (VectPriority21),
        .VectPriority22   (VectPriority22),
        .VectPriority23   (VectPriority23),
        .VectPriority24   (VectPriority24),
        .VectPriority25   (VectPriority25),
        .VectPriority26   (VectPriority26),
        .VectPriority27   (VectPriority27),
        .VectPriority28   (VectPriority28),
        .VectPriority29   (VectPriority29),
        .VectPriority30   (VectPriority30),
        .VectPriority31   (VectPriority31),
        .VectPriority32   (VectPriority32),

// VIC priority stack controls
        .IRQSWAck         (IRQSWAck),
        .IRQSWClear       (IRQSWClear),

// Integration Test interface
        .ITEN             (ITEN),
        .IRQACKForceVal   (VICIRQACKFrcVal),
        .nIRQINForceVal   (nVICIRQINFrcVal),
        .nFIQINForceVal   (nVICFIQINFrcVal),
        .VECTADDRINFrcVal (VECTADDRINFrcVal),
        .VECTADDRVFrcVal  (VECTADDRVFrcVal),
        .IRQForceVal      (VICIRQForceVal),
        .FIQForceVal      (VICFIQForceVal),
        .IRQACKOUTFrcVal  (IRQACKOUTFrcVal),
        .VECTADDRFrcVal   (VECTADDRFrcVal)
        );

// -----------------------------------------------------------------------------
// Instantiation of the VicCpuif
// -----------------------------------------------------------------------------
VicCpuif  uVicCpuif (
// Inputs

// AHB signals
        .HCLK             (HCLK),
        .HRESETn          (HRESETn),

// Vector address from VicAHBif
        .VectAddr0        (VectAddr0),
        .VectAddr1        (VectAddr1),
        .VectAddr2        (VectAddr2),
        .VectAddr3        (VectAddr3),
        .VectAddr4        (VectAddr4),
        .VectAddr5        (VectAddr5),
        .VectAddr6        (VectAddr6),
        .VectAddr7        (VectAddr7),
        .VectAddr8        (VectAddr8),
        .VectAddr9        (VectAddr9),
        .VectAddr10       (VectAddr10),
        .VectAddr11       (VectAddr11),
        .VectAddr12       (VectAddr12),
        .VectAddr13       (VectAddr13),
        .VectAddr14       (VectAddr14),
        .VectAddr15       (VectAddr15),
        .VectAddr16       (VectAddr16),
        .VectAddr17       (VectAddr17),
        .VectAddr18       (VectAddr18),
        .VectAddr19       (VectAddr19),
        .VectAddr20       (VectAddr20),
        .VectAddr21       (VectAddr21),
        .VectAddr22       (VectAddr22),
        .VectAddr23       (VectAddr23),
        .VectAddr24       (VectAddr24),
        .VectAddr25       (VectAddr25),
        .VectAddr26       (VectAddr26),
        .VectAddr27       (VectAddr27),
        .VectAddr28       (VectAddr28),
        .VectAddr29       (VectAddr29),
        .VectAddr30       (VectAddr30),
        .VectAddr31       (VectAddr31),
        .VICVECTADDRIN    (VICVECTADDRIN),

// Interrupt related signals from VicInterrupt
        .IRQRequest       (IRQRequest),
        .IRQReqLevel      (IRQReqLevel),
        .IRQPort          (IRQPort),

// Interrupt handling control from AHB interface
        .IRQSWAck         (IRQSWAck),
        .IRQSWClear       (IRQSWClear),

// Vic handshaking inputs
        .nVICSYNCEN       (nVICSYNCEN),
        .VICIRQACK        (VICIRQACK),

// Test logic control
        .ITEN             (ITEN),

// Force signal values when ITEN is high
        .IRQACKForceVal   (VICIRQACKFrcVal),
        .VADDRINForceVal  (VECTADDRINFrcVal),
        .VADDRVForceVal   (VECTADDRVFrcVal),
        .ACKOUTForceVal   (IRQACKOUTFrcVal),
        .VADDRForceVal    (VECTADDRFrcVal),

// Outputs

// Acknowledgement to cascaded interrupt
        .VICIRQACKOUT     (VICIRQACKOUT),

// Priority status and address
        .CurrentPriority  (CurrentPriority),
        .VICVectAddrVal   (VICVectAddrVal),

// Vic handshaking outputs
        .VICVECTADDRV     (VICVECTADDRV),
        .VICVECTADDROUT   (VICVECTADDROUT),

// Read back value for integration test
        .IRQACKTestVal    (VICIRQACKTestVal),
        .VADDRINTestVal   (VECTADDRINTstVal),
        .VADDRVTestVal    (VECTADDRVTestVal),
        .ACKOUTTestVal    (IRQACKOUTTestVal),
        .VADDRTestVal     (VECTADDRTestVal)
       );

// -----------------------------------------------------------------------------
// Instantiation of VicRevAnd for bit 0 of Revision
// -----------------------------------------------------------------------------
VicRevAnd  u0VicRevAnd (
// Inputs

        .TieOff1          (TieOff1[0]),
        .TieOff2          (TieOff2[0]),

// Outputs
        .Revision         (Revision[0])
       );

// -----------------------------------------------------------------------------
// Instantiation of VicRevAnd for bit 1 of Revision
// -----------------------------------------------------------------------------
VicRevAnd  u1VicRevAnd (
// Inputs

        .TieOff1          (TieOff1[1]),
        .TieOff2          (TieOff2[1]),

// Outputs
        .Revision         (Revision[1])
       );

// -----------------------------------------------------------------------------
// Instantiation of VicRevAnd for bit 2 of Revision
// -----------------------------------------------------------------------------
VicRevAnd  u2VicRevAnd (
// Inputs

        .TieOff1          (TieOff1[2]),
        .TieOff2          (TieOff2[2]),

// Outputs
        .Revision         (Revision[2])
       );

// -----------------------------------------------------------------------------
// Instantiation of VicRevAnd for bit 3 of Revision
// -----------------------------------------------------------------------------
VicRevAnd  u3VicRevAnd (
// Inputs

        .TieOff1          (TieOff1[3]),
        .TieOff2          (TieOff2[3]),

// Outputs
        .Revision         (Revision[3])
       );

// -----------------------------------------------------------------------------
// Assign the Revision Number
//
// The Revision Number of the VIC is determined by the values assigned
// to the TieOff1 and TieOff2 signals. A TieOff1 = TieOff2 = 0000 value
// will set the Revision field of the VIC Peripheral ID to 0000. This
// is the default.
//
// If a different Revision number is to be used, change the values
// assigned to the TieOff1 and TieOff2 signals. For example, to
// use a Revision Number of 0001, change TieOff1 and TieOff2 to 0001.
// -----------------------------------------------------------------------------
assign  TieOff1  = 4'b0000;
assign  TieOff2  = 4'b0000;

// synopsys translate_off
// -----------------------------------------------------------------------------
// START OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// END OF PROTOCOL CHECKERS
// -----------------------------------------------------------------------------
// synopsys translate_on

endmodule
// --================================== End ==================================--
