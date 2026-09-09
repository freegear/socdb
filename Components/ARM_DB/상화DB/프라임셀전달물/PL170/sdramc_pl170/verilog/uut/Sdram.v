// --=================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1999, 2000 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
// ---------------------------------------------------------------------
//
//  Version and Release Control Information:
//
//  File Name              : Sdram.v,v
//  File Revision          : 1.14
//
//  Release Information    : PrimeCell(TM)-PL170-REL2v2
//
// ---------------------------------------------------------------------
//  Purpose       : This block is the top-level block and instantiates
//                  all the functional sub-modules.
// --=================================================================--

`timescale 1ns/1ps

module Sdram (
              // Inputs
               HCLK,
               CLKIn,
               HRESETn,
               nPOR,
               BIGENDIAN,
               SREFReq,
               ExtBusGnt,
               ExtCtlGnt,
               DataIn,

               HSIZE0,
               HWRITE0,
               HTRANS0,
               HBURST0,
               HREADYin0,
               HSELram0,
               HADDR0,
               HWDATA0,

               HSIZE1,
               HWRITE1,
               HTRANS1,
               HBURST1,
               HREADYin1,
               HSELram1,
               HADDR1,
               HWDATA1,

               HSIZE2,
               HWRITE2,
               HTRANS2,
               HBURST2,
               HREADYin2,
               HSELram2,
               HADDR2,
               HWDATA2,

               HSIZE3,
               HWRITE3,
               HTRANS3,
               HBURST3,
               HREADYin3,
               HSELram3,
               HSELreg3,
               HADDR3,
               HWDATA3,

              // Scan Ports
               SCANIN,
               SCANENABLE,

              // Outputs
               HRDATA0,
               HRESP0,
               HREADYout0,

               HRDATA1,
               HRESP1,
               HREADYout1,

               HRDATA2,
               HRESP2,
               HREADYout2,

               HRDATA3,
               HRESP3,
               HREADYout3,

               SREFAck,
               DataOut,
               DQMOut,
               nCSOut,
               AddrOut,
               CKEOut,
               nRASOut,
               nCASOut,
               nWEOut,
               DataEn,
               CLKOut,
               ExtBusReq,
               ExtCtlReq,

              // Scan Ports
               SCANOUT
              );

//include file
`include "SdramDefs.v"

input                 HCLK;      // AHB Bus clock
input                 CLKIn;     // External SDRAM clock
input                 HRESETn;   // AHB Reset
input                 nPOR;      // Power-on-reset

input           [1:0] HSIZE0;    // AHB transfer size
input                 HWRITE0;   // AHB transfer direction
input           [1:0] HTRANS0;   // AHB transfer type
input           [2:0] HBURST0;   // AHB burst type
input                 HREADYin0; // AHB transfer done
input                 HSELram0;  // Slave select for memory accesses

input           [1:0] HSIZE1;    // AHB transfer size
input                 HWRITE1;   // AHB transfer direction
input           [1:0] HTRANS1;   // AHB transfer type
input           [2:0] HBURST1;   // AHB burst type
input                 HREADYin1; // AHB transfer done
input                 HSELram1;  // Slave select for memory accesses

input           [1:0] HSIZE2;    // AHB transfer size
input                 HWRITE2;   // AHB transfer direction
input           [1:0] HTRANS2;   // AHB transfer type
input           [2:0] HBURST2;   // AHB burst type
input                 HREADYin2; // AHB transfer done
input                 HSELram2;  // Slave select for memory accesses

input           [1:0] HSIZE3;    // AHB transfer size
input                 HWRITE3;   // AHB transfer direction
input           [1:0] HTRANS3;   // AHB transfer type
input           [2:0] HBURST3;   // AHB burst type
input                 HREADYin3; // AHB transfer done
input                 HSELram3;  // Slave select for memory accesses
input                 HSELreg3;  // Slave select for register accesses

input                 SREFReq;  // Self-refresh request
input [`BUSWIDTH-1:0] DataIn;   // Read data from the SDRAMs

input          [28:0] HADDR0;   // AHB address
input [`BUSWIDTH-1:0] HWDATA0;  // AHB write data

input          [28:0] HADDR1;   // AHB address
input [`BUSWIDTH-1:0] HWDATA1;  // AHB write data

input          [28:0] HADDR2;   // AHB address
input [`BUSWIDTH-1:0] HWDATA2;  // AHB write data

input          [28:0] HADDR3;   // AHB address
input [`BUSWIDTH-1:0] HWDATA3;  // AHB write data

input                 ExtBusGnt;  // External Bus grant
input                 ExtCtlGnt;  // Grant for the external Control bus

input                 SCANIN;     // Scan Input
input                 SCANENABLE; // Scan Enable

input                 BIGENDIAN;  // change byte order to bigendian,
                                  // affects all four AHB ports

output  [`BUSWIDTH-1:0] HRDATA0;     // Read data to AHB
output            [1:0] HRESP0;      // AHB transfer response
output                  HREADYout0;  // AHB transfer done

output  [`BUSWIDTH-1:0] HRDATA1;     // Read data to AHB
output            [1:0] HRESP1;      // AHB transfer response
output                  HREADYout1;  // AHB transfer done

output  [`BUSWIDTH-1:0] HRDATA2;     // Read data to AHB
output            [1:0] HRESP2;      // AHB transfer response
output                  HREADYout2;  // AHB transfer done

output  [`BUSWIDTH-1:0] HRDATA3;     // Read data to AHB
output            [1:0] HRESP3;      // AHB transfer response
output                  HREADYout3;  // AHB transfer done

output                   SREFAck;    // Self Refresh Acknowledgement
output   [`BUSWIDTH-1:0] DataOut;    // Data output to SDRAMs
output [`BUSWIDTH/8-1:0] DQMOut;     // Data mask output to SDRAMs
output             [3:0] nCSOut;     // SDRAM Chip selects
output            [14:0] AddrOut;    // Address output for SDRAMs
output             [3:0] CKEOut;     // SDRAM Clock enables
output                   nRASOut;    // Row Address Strobe
output                   nCASOut;    // Column Address Strobe
output                   nWEOut;     // Write Enable
output                   DataEn;     // Data Enable for write transfers
output                   CLKOut;     // External clock for SDRAMs
output                   ExtBusReq;  // External Bus Request
output                   ExtCtlReq;  // External Control Bus Request

output                   SCANOUT;    // Scan Output
// ---------------------------------------------------------------------
//
//                             Sdram
//                             ======
//
// ---------------------------------------------------------------------
//
// Overview
// ========
// The Sdram block is a structural block that instantiates the following
// functional blocks :
//  * SdramBigEndian - LSB address control for BigEndian byte order
//  * SdramAhbif     - AHB interface
//  * SdramRegBlk    - Register block
//  * SdramEngine    - Main SDRAM controller
//  * SdramPins      - Synchronisers for signals feeding the SDRAMs
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Wire declarations
// ---------------------------------------------------------------------
wire                     HCLK;
// AHB Bus clock                                        (Module input)

wire                     CLKIn;
// Fed-back external clock on which the SDRAMs operate  (Module input)

wire                     HRESETn;
// AHB Reset                                            (Module input)

wire                     nPOR;
// Power-on-reset                                       (Module input)

wire               [1:0] HSIZE0;
// AHB Transfer size                                    (Module input)

wire               [1:0] HSIZE1;
// AHB Transfer size                                    (Module input)

wire               [1:0] HSIZE2;
// AHB Transfer size                                    (Module input)

wire               [1:0] HSIZE3;
// AHB Transfer size                                    (Module input)

wire                     HWRITE0;
// AHB Write                                            (Module input)

wire                     HWRITE1;
// AHB Write                                            (Module input)

wire                     HWRITE2;
// AHB Write                                            (Module input)

wire                     HWRITE3;
// AHB Write                                            (Module input)

wire               [1:0] HTRANS0;
// AHB transfer type                                    (Module input)

wire               [1:0] HTRANS1;
// AHB transfer type                                    (Module input)

wire               [1:0] HTRANS2;
// AHB transfer type                                    (Module input)

wire               [1:0] HTRANS3;
// AHB transfer type                                    (Module input)

wire               [2:0] HBURST0;
// AHB burst type                                       (Module input)

wire               [2:0] HBURST1;
// AHB burst type                                       (Module input)

wire               [2:0] HBURST2;
// AHB burst type                                       (Module input)

wire               [2:0] HBURST3;
// AHB burst type                                       (Module input)

wire                     HREADYin0;
// AHB transfer done                                    (Module input)

wire                     HREADYin1;
// AHB transfer done                                    (Module input)

wire                     HREADYin2;
// AHB transfer done                                    (Module input)

wire                     HREADYin3;
// AHB transfer done                                    (Module input)

wire                     HSELram0;
// Device select for Memory accesses                    (Module input)

wire                     HSELram1;
// Device select for Memory accesses                    (Module input)

wire                     HSELram2;
// Device select for Memory accesses                    (Module input)

wire                     HSELram3;
// Device select for Memory accesses                    (Module input)

wire                     HSELreg3;
// Device select for Register accesses                  (Module input)

wire                     SREFReq;
// Self-refresh request                                 (Module input)

wire     [`BUSWIDTH-1:0] DataIn;
// Read Data from SDRAMs                                (Module input)

wire              [28:0] HADDR0;
// AHB Address bus                                      (Module input)

wire              [28:0] HADDR1;
// AHB Address bus                                      (Module input)

wire              [28:0] HADDR2;
// AHB Address bus                                      (Module input)

wire              [28:0] HADDR3;
// AHB Address bus                                      (Module input)

wire     [`BUSWIDTH-1:0] HWDATA0;
// Write data to AHB interface                          (Module input)

wire     [`BUSWIDTH-1:0] HWDATA1;
// Write data to AHB interface                          (Module input)

wire     [`BUSWIDTH-1:0] HWDATA2;
// Write data to AHB interface                          (Module input)

wire                     SCANIN;
// Scan input                                           (Module input)

wire                     SCANENABLE;
// Scan Enable                                          (Module input)

wire     [`BUSWIDTH-1:0] HWDATA3;
// Write data to AHB interface                          (Module input)

wire                     ExtBusGnt;
// External Bus grant                                   (Module input)

wire                     ExtCtlGnt;
// Grant for the external Control bus                   (Module input)

wire                     BIGENDIAN;
// Select port big endian byte order                    (Module input)

wire     [`BUSWIDTH-1:0] HRDATA0;
// Read data to AHB                                     (Module output)

wire     [`BUSWIDTH-1:0] HRDATA1;
// Read data to AHB                                     (Module output)

wire     [`BUSWIDTH-1:0] HRDATA2;
// Read data to AHB                                     (Module output)

wire     [`BUSWIDTH-1:0] HRDATA3;
// Read data to AHB                                     (Module output)

wire               [1:0] HRESP0;
// AHB transfer response                                (Module output)

wire               [1:0] HRESP1;
// AHB transfer response                                (Module output)

wire               [1:0] HRESP2;
// AHB transfer response                                (Module output)

wire               [1:0] HRESP3;
// AHB transfer response                                (Module output)

wire                     HREADYout0;
// AHB transfer done                                    (Module output)

wire                     HREADYout1;
// AHB transfer done                                    (Module output)

wire                     HREADYout2;
// AHB transfer done                                    (Module output)

wire                     HREADYout3;
// AHB transfer done                                    (Module output)

wire                     SREFAck;
// Self Refresh Acknowledgement                         (Module output)

wire     [`BUSWIDTH-1:0] DataOut;
// Data output to SDRAMs                                (Module output)

wire   [`BUSWIDTH/8-1:0] DQMOut;
// Data mask outputs to SDRAMs                          (Module output)

wire               [3:0] nCSOut;
// SDRAM Chip selects                                   (Module output)

wire              [14:0] AddrOut;
// Address output for SDRAMs                            (Module output)

wire               [3:0] CKEOut;
// SDRAM Clock enables                                  (Module output)

wire                     nRASOut;
// Row Address Strobe                                   (Module output)

wire                     nCASOut;
// Column Address Strobe                                (Module output)

wire                     nWEOut;
// Write Enable                                         (Module output)

wire                     DataEn;
// Data Enable for write transfers                      (Module output)

wire                     CLKOut;
// External clock for SDRAMs                            (Module output)

wire                     ExtBusReq;
// External bus request                                 (Module output)

wire                     ExtCtlReq;
// External Control Bus Request                         (Module output)

wire                     SCANOUT;
// Scan Output                                          (Module output)

wire              [28:2] AddrIn0;
// Access Address from Port 0

wire                     Read0;
// Read request from Port 0

wire                     Write0;
// Write request from Port 0

wire     [`BUSWIDTH-1:0] DataIn0;
// Write Data from Port 0

wire   [`BUSWIDTH/8-1:0] DQM0;
// Data Mask for accesses from Port 0

wire                     SplitProceed0;
// Response from Port 0 indicating that the
// access to the SDRAMs can proceed

wire               [2:0] ReqNumCmd0;
// Number of times the command has to be repeated from
// Port0

wire              [28:2] AddrIn1;
// Access Address from Port 1

wire                     Read1;
// Read request from Port 1

wire                     Write1;
// Write request from Port 1

wire     [`BUSWIDTH-1:0] DataIn1;
// Write Data from Port 1

wire   [`BUSWIDTH/8-1:0] DQM1;
// Data Mask for accesses from Port 1

wire                     SplitProceed1;
// Response from Port 1 indicating that the
// access to the SDRAMs can proceed

wire               [2:0] ReqNumCmd1;
// Number of times the command has to be repeated from
// Port1

wire              [28:2] AddrIn2;
// Access Address from Port 2

wire                     Read2;
// Read request from Port 2

wire                     Write2;
// Write request from Port 2

wire     [`BUSWIDTH-1:0] DataIn2;
// Write Data from Port 2

wire   [`BUSWIDTH/8-1:0] DQM2;
// Data Mask for accesses from Port 2

wire                     SplitProceed2;
// Response from Port 2 indicating that
// the access to the SDRAMs can proceed

wire               [2:0] ReqNumCmd2;
// Number of times the command has to be repeated from
// Port2

wire     [`BUSWIDTH-1:0] RdData;
// Read data from SdramEngine

wire                     XferOut0;
// Data phase on for accesses from Port 0

wire                     EndOfXfer0;
// Last beat of data transfer to Port 0

wire                     SplitEn0;
// Split indication for accesses from Port 0

wire                     SplitWait0;
// Split Wait for accesses from Port 0

wire                     XferOut1;
// Data phase on for accesses from Port 1

wire                     EndOfXfer1;
// Last beat of data transfer to Port 1

wire                     SplitEn1;
// Split indication for accesses from Port 1

wire                     SplitWait1;
// Split Wait for accesses from Port 1

wire                     XferOut2;
// Data phase on for accesses from Port 2

wire                     EndOfXfer2;
// Last beat of data transfer to Port 2

wire                     SplitEn2;
// Split indication for accesses from Port 2

wire                     SplitWait2;
// Split Wait for accesses from Port 2

wire                     XferOut3;
// Data phase on for accesses from Port 3

wire                     EndOfXfer3;
// Last beat of data transfer to Port 3

wire                     SplitEn3;
// Split indication for accesses from Port 3

wire                     SplitWait3;
// Split Wait indication for accesses from Port 3. This signal
// indicates that the data phase for an access is about to start.

wire                     Done;
// Refresh Complete

wire                     EngineBusy;
// Indication to the bus interface that the SdramEngine block is busy.
// Used to indicate whether the contents of the config register 0 can
// be safely  changed

wire                     Write3;
// Write request from Port 3

wire                     Read3;
// Read request from Port 3

wire              [28:2] AddrIn3;
// Address from Port 3

wire     [`BUSWIDTH-1:0] DataIn3;
// Write Data associated with Port 3

wire   [`BUSWIDTH/8-1:0] DQM3;
// Data Mask for accesses from Port 3

wire                     SplitProceed3;
// Response from Port 3 indicating that the Pot is ready for the data
// phase of the access.

wire               [2:0] ReqNumCmd3;
// Number of times the command has to be repeated from Port3

wire               [3:0] B;
// Bank information : 1 - 4-bank device; 0 - 2-bank device

wire               [3:0] T;
// Device Type : 1 - 8-bit data bus; 0 - 16-bit data bus

wire               [3:0] F;
// Size information : 1 - 256 Mbit device;

wire                     Initialise;
// Initialise bit in the Configuration register 1

wire                     CKEEn;
// Clock Enable control for SDRAMs

wire                     Mode;
// Mode bit in the Configuration register 1. When set, all reads are
// interpreted as mode register accesses

wire               [1:0] CASDelay;
// CAS latency for SDRAMs

wire               [1:0] RASDelay;
// RAS to CAS delay

wire                     Refresh;
// Refresh request from the AHB interface to the Sdram Engine

wire     [`BUSWIDTH-1:0] VcRdData;
// Read data from SDRAMs clocked in on external clock

wire                     VcDataEn;
// Data Enable for driving data on to the external memory databus. This
// signal is from the Command sequencer to the SdramPins module

wire               [3:0] VcnCSOut;
// SDRAM Chip selects, from Command sequencer to the SdramPins block

wire                     VcnWEOut;
// SDRAM Write enable, from Command sequencer to the SdramPins module

wire               [3:0] VcCKEOut;
// SDRAM Clock enable, from Command sequencer to the SdramPins module

wire              [14:0] VcAddrOut;
// SDRAM Address, output from Command sequencer to the SdramPins module

wire   [`BUSWIDTH/8-1:0] VcDQMOut;
// Data Mask for SDRAMs, from Command sequencer to the SdramPins module

wire                     VcnRASOut;
// RAS for SDRAMs

wire                     VcnCASOut;
// CAS for SDRAMs

wire     [`BUSWIDTH-1:0] VcWrData;
// Write Data, from Command sequencer to the SdramPins module

wire     [`BUSWIDTH-1:0] RegData;
// Read data from the register block

wire                     RegWrEn;
// Write enable to the register block

wire                     WrBufEn;
// Write buffer enable from the configuration register to AHB interface

wire                     RdBufEn;
// Read buffer enable from the configuration register to AHB interface

wire                     ClkDis;
// Disable External clock to SDRAMs

wire                     E;
// Enable Dynamic shutdown of External clock

wire                     ExtBusWidth;
// Width of external memory databus

wire                     AutoPre3;
// Auto PreCharge all accesses from Port 3

wire              [15:0] WTORegister;
// Write time-out count value from the register.

wire              [1:0]  ENDADDR3;
// Endian converted port LSB address bits

wire              [1:0]  ENDADDR2;
// Endian converted port LSB address bits

wire              [1:0]  ENDADDR1;
// Endian converted port LSB address bits

wire              [1:0]  ENDADDR0;
// Endian converted port LSB address bits

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------
// Byte lane endian conversion logic
// ---------------------------------------------------------------------

SdramBigEndian u3SdramBigEndian (
                  .HADDR          (HADDR3[1:0]),
                  .ENDADDR        (ENDADDR3[1:0]),
                  .BIGENDIAN      (BIGENDIAN)

                   );

SdramBigEndian u2SdramBigEndian (
                  .HADDR          (HADDR2[1:0]),
                  .ENDADDR        (ENDADDR2[1:0]),
                  .BIGENDIAN      (BIGENDIAN)

                   );

SdramBigEndian u1SdramBigEndian (
                  .HADDR          (HADDR1[1:0]),
                  .ENDADDR        (ENDADDR1[1:0]),
                  .BIGENDIAN      (BIGENDIAN)

                   );

SdramBigEndian u0SdramBigEndian (
                  .HADDR          (HADDR0[1:0]),
                  .ENDADDR        (ENDADDR0[1:0]),
                  .BIGENDIAN      (BIGENDIAN)

                   );

// ---------------------------------------------------------------------
// AHB Interface connecting to Port 3 of the main SDRAM controller
// ---------------------------------------------------------------------
SdramAhbif #(`NO_OF_WRITE_BUFFERS, `NO_OF_READ_BUFFERS) u3SdramAhbif (
                  .HCLK           (HCLK),
                  .HRESETn        (HRESETn),
                  .nPOR           (nPOR),
                  .HSELram        (HSELram3),
                  .HSELreg        (HSELreg3),
                  .HADDR          ({HADDR3[28:2],ENDADDR3[1:0]}),
                  .HWRITE         (HWRITE3),
                  .HSIZE          (HSIZE3),
                  .HTRANS         (HTRANS3),
                  .HBURST         (HBURST3),
                  .HREADYin       (HREADYin3),
                  .HWDATA         (HWDATA3),
                  .XferOut3       (XferOut3),
                  .SplitWait3     (SplitWait3),
                  .EndOfXfer3     (EndOfXfer3),
                  .DataOut3       (RdData),
                  .RegData        (RegData),
                  .Mode           (Mode),
                  .WrBufEn        (WrBufEn),
                  .RdBufEn        (RdBufEn),
                  .B              (B),
                  .T              (T),
                  .F              (F),
                  .ExtBusWidth    (ExtBusWidth),
                  .WTORegister    (WTORegister),

                  .HRDATA         (HRDATA3),
                  .HRESP          (HRESP3),
                  .HREADYout      (HREADYout3),
                  .AddrIn3        (AddrIn3),
                  .Read3          (Read3),
                  .Write3         (Write3),
                  .DataIn3        (DataIn3),
                  .DQM3           (DQM3),
                  .SplitProceed3  (SplitProceed3),
                  .ReqNumCmd3     (ReqNumCmd3),
                  .RegWrEn        (RegWrEn)

                  );

SdramAhbif #(`NO_OF_WRITE_BUFFERS, `NO_OF_READ_BUFFERS) u2SdramAhbif (
                  .HCLK           (HCLK),
                  .HRESETn        (HRESETn),
                  .nPOR           (nPOR),
                  .HSELram        (HSELram2),
                  .HSELreg        (1'b0),
                  .HADDR          ({HADDR2[28:2],ENDADDR2[1:0]}),
                  .HWRITE         (HWRITE2),
                  .HSIZE          (HSIZE2),
                  .HTRANS         (HTRANS2),
                  .HBURST         (HBURST2),
                  .HREADYin       (HREADYin2),
                  .HWDATA         (HWDATA2),
                  .XferOut3       (XferOut2),
                  .SplitWait3     (SplitWait2),
                  .EndOfXfer3     (EndOfXfer2),
                  .DataOut3       (RdData),
                  .RegData        (32'h00000000),
                  .Mode           (1'b0),
                  .WrBufEn        (WrBufEn),
                  .RdBufEn        (RdBufEn),
                  .B              (B),
                  .T              (T),
                  .F              (F),
                  .ExtBusWidth    (ExtBusWidth),
                  .WTORegister    (WTORegister),

                  .HRDATA         (HRDATA2),
                  .HRESP          (HRESP2),
                  .HREADYout      (HREADYout2),
                  .AddrIn3        (AddrIn2),
                  .Read3          (Read2),
                  .Write3         (Write2),
                  .DataIn3        (DataIn2),
                  .DQM3           (DQM2),
                  .SplitProceed3  (SplitProceed2),
                  .ReqNumCmd3     (ReqNumCmd2),
                  .RegWrEn        ()

                  );

SdramAhbif #(`NO_OF_WRITE_BUFFERS, `NO_OF_READ_BUFFERS) u1SdramAhbif (
                  .HCLK           (HCLK),
                  .HRESETn        (HRESETn),
                  .nPOR           (nPOR),
                  .HSELram        (HSELram1),
                  .HSELreg        (1'b0),
                  .HADDR          ({HADDR1[28:2],ENDADDR1[1:0]}),
                  .HWRITE         (HWRITE1),
                  .HSIZE          (HSIZE1),
                  .HTRANS         (HTRANS1),
                  .HBURST         (HBURST1),
                  .HREADYin       (HREADYin1),
                  .HWDATA         (HWDATA1),
                  .XferOut3       (XferOut1),
                  .SplitWait3     (SplitWait1),
                  .EndOfXfer3     (EndOfXfer1),
                  .DataOut3       (RdData),
                  .RegData        (32'h00000000),
                  .Mode           (1'b0),
                  .WrBufEn        (WrBufEn),
                  .RdBufEn        (RdBufEn),
                  .B              (B),
                  .T              (T),
                  .F              (F),
                  .ExtBusWidth    (ExtBusWidth),
                  .WTORegister    (WTORegister),

                  .HRDATA         (HRDATA1),
                  .HRESP          (HRESP1),
                  .HREADYout      (HREADYout1),
                  .AddrIn3        (AddrIn1),
                  .Read3          (Read1),
                  .Write3         (Write1),
                  .DataIn3        (DataIn1),
                  .DQM3           (DQM1),
                  .SplitProceed3  (SplitProceed1),
                  .ReqNumCmd3     (ReqNumCmd1),
                  .RegWrEn        ()

                  );

SdramAhbif #(`NO_OF_WRITE_BUFFERS, `NO_OF_READ_BUFFERS) u0SdramAhbif (
                  .HCLK           (HCLK),
                  .HRESETn        (HRESETn),
                  .nPOR           (nPOR),
                  .HSELram        (HSELram0),
                  .HSELreg        (1'b0),
                  .HADDR          ({HADDR0[28:2],ENDADDR0[1:0]}),
                  .HWRITE         (HWRITE0),
                  .HSIZE          (HSIZE0),
                  .HTRANS         (HTRANS0),
                  .HBURST         (HBURST0),
                  .HREADYin       (HREADYin0),
                  .HWDATA         (HWDATA0),
                  .XferOut3       (XferOut0),
                  .SplitWait3     (SplitWait0),
                  .EndOfXfer3     (EndOfXfer0),
                  .DataOut3       (RdData),
                  .RegData        (32'h00000000),
                  .Mode           (1'b0),
                  .WrBufEn        (WrBufEn),
                  .RdBufEn        (RdBufEn),
                  .B              (B),
                  .T              (T),
                  .F              (F),
                  .ExtBusWidth    (ExtBusWidth),
                  .WTORegister    (WTORegister),

                  .HRDATA         (HRDATA0),
                  .HRESP          (HRESP0),
                  .HREADYout      (HREADYout0),
                  .AddrIn3        (AddrIn0),
                  .Read3          (Read0),
                  .Write3         (Write0),
                  .DataIn3        (DataIn0),
                  .DQM3           (DQM0),
                  .SplitProceed3  (SplitProceed0),
                  .ReqNumCmd3     (ReqNumCmd0),
                  .RegWrEn        ()

                  );

// ---------------------------------------------------------------------
// SDRAMC Register Block
// ---------------------------------------------------------------------
SdramAhbRegBlk uSdramAhbRegBlk      (
                  .HCLK         (HCLK),
                  .nPOR         (nPOR),
                  .HSELreg      (HSELreg3),
                  .HADDR        (HADDR3[`MSBADDR:0]),
                  .HSIZE        (HSIZE3[1:0]),
                  .HWDATA       (HWDATA3[24:0]),
                  .HREADYin     (HREADYin3),
                  .EngineBusy   (EngineBusy),
                  .Done         (Done),
                  .RegWrEn      (RegWrEn),

                  .RegData      (RegData[`BUSWIDTH-1:0]),
                  .WrBufEn      (WrBufEn),
                  .RdBufEn      (RdBufEn),
                  .WTORegister  (WTORegister),

                  .Refresh      (Refresh),

                  .B            (B),
                  .T            (T),
                  .F            (F),
                  .Initialise   (Initialise),
                  .CKEEn        (CKEEn),
                  .Mode         (Mode),
                  .CASDelay     (CASDelay[1:0]),
                  .RASDelay     (RASDelay[1:0]),
                  .AutoPre3     (AutoPre3),
                  .ExtBusWidth  (ExtBusWidth),
                  .E            (E)

                  );

// ---------------------------------------------------------------------
// SDRAM Control Engine
// ---------------------------------------------------------------------
SdramEngine uSdramEngine       (
                  .HCLK          (HCLK),
                  .nPOR          (nPOR),
                  .AddrIn0       (AddrIn0),
                  .Read0         (Read0),
                  .Write0        (Write0),
                  .AutoPre0      (AutoPre3),
                  .DataIn0       (DataIn0),
                  .DQM0          (DQM0),
                  .SplitProceed0 (SplitProceed0),
                  .ReqNumCmd0    (ReqNumCmd0),
                  .AddrIn1       (AddrIn1),
                  .Read1         (Read1),
                  .Write1        (Write1),
                  .AutoPre1      (AutoPre3),
                  .DataIn1       (DataIn1),
                  .DQM1          (DQM1),
                  .SplitProceed1 (SplitProceed1),
                  .ReqNumCmd1    (ReqNumCmd1),
                  .AddrIn2       (AddrIn2),
                  .Read2         (Read2),
                  .Write2        (Write2),
                  .AutoPre2      (AutoPre3),
                  .DataIn2       (DataIn2),
                  .DQM2          (DQM2),
                  .SplitProceed2 (SplitProceed2),
                  .ReqNumCmd2    (ReqNumCmd2),
                  .AddrIn3       (AddrIn3),
                  .Read3         (Read3),
                  .Write3        (Write3),
                  .AutoPre3      (AutoPre3),
                  .DataIn3       (DataIn3),
                  .DQM3          (DQM3),
                  .SplitProceed3 (SplitProceed3),
                  .ReqNumCmd3    (ReqNumCmd3),
                  .SREFReq       (SREFReq),
                  .CASDelay      (CASDelay),
                  .RASDelay      (RASDelay),
                  .Refresh       (Refresh),
                  .Mode          (Mode),
                  .Initialise    (Initialise),
                  .CKEEn         (CKEEn),
                  .E             (E),
                  .VcRdData      (VcRdData),
                  .ExtBusGnt     (ExtBusGnt),
                  .ExtBusWidth   (ExtBusWidth),
                  .ExtCtlGnt     (ExtCtlGnt),
                  .SREFAck       (SREFAck),
                  .XferOut0      (XferOut0),
                  .SplitEn0      (SplitEn0),
                  .SplitWait0    (SplitWait0),
                  .EndOfXfer0    (EndOfXfer0),
                  .XferOut1      (XferOut1),
                  .SplitEn1      (SplitEn1),
                  .SplitWait1    (SplitWait1),
                  .EndOfXfer1    (EndOfXfer1),
                  .XferOut2      (XferOut2),
                  .SplitEn2      (SplitEn2),
                  .SplitWait2    (SplitWait2),
                  .EndOfXfer2    (EndOfXfer2),
                  .XferOut3      (XferOut3),
                  .SplitEn3      (SplitEn3),
                  .SplitWait3    (SplitWait3),
                  .EndOfXfer3    (EndOfXfer3),
                  .Done          (Done),
                  .EngineBusy    (EngineBusy),
                  .RdData        (RdData),
                  .ClkDis        (ClkDis),
                  .VcDataEn      (VcDataEn),
                  .VcnCSOut      (VcnCSOut),
                  .VcnRASOut     (VcnRASOut),
                  .VcnCASOut     (VcnCASOut),
                  .VcnWEOut      (VcnWEOut),
                  .VcCKEOut      (VcCKEOut),
                  .VcAddrOut     (VcAddrOut),
                  .VcDQMOut      (VcDQMOut),
                  .ExtBusReq     (ExtBusReq),
                  .ExtCtlReq     (ExtCtlReq),
                  .VcWrData      (VcWrData)
                  );

// ---------------------------------------------------------------------
// Synchronisers for signals to / from SDRAMs
// ---------------------------------------------------------------------
SdramPins uSdramPins           (
                  .HCLK          (HCLK),
                  .nPOR          (nPOR),
                  .ClkDis        (ClkDis),
                  .VcDataEn      (VcDataEn),
                  .VcnCSOut      (VcnCSOut),
                  .VcnRASOut     (VcnRASOut),
                  .VcnCASOut     (VcnCASOut),
                  .VcnWEOut      (VcnWEOut),
                  .VcCKEOut      (VcCKEOut),
                  .VcAddrOut     (VcAddrOut),
                  .VcWrData      (VcWrData),
                  .VcDQMOut      (VcDQMOut),
                  .DataIn        (DataIn),
                  .CLKIn         (CLKIn),
                  .ExtCtlGnt     (ExtCtlGnt),
                  .VcRdData      (VcRdData),
                  .DataEn        (DataEn),
                  .nCSOut        (nCSOut),
                  .nRASOut       (nRASOut),
                  .nCASOut       (nCASOut),
                  .nWEOut        (nWEOut),
                  .CKEOut        (CKEOut),
                  .AddrOut       (AddrOut),
                  .DataOut       (DataOut),
                  .DQMOut        (DQMOut),
                  .CLKOut        (CLKOut)
                  );

endmodule

// --========================== End of Sdram =========================--
