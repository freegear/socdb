// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2003 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : SmcEIB.v.rca
// File Revision          : 1.20
//
// Release Information    : PrimeCell(TM)-PL092-r1p3-01ltd0
//
// -----------------------------------------------------------------------------
// Purpose :
//           The function of this module is to provide interface with the
//           external memory devices for facilitating the read and write
//           transactions. The device control signals along with the address
//           and data paths are generated.
//
// --=========================================================================--

`timescale 1ns/1ps

//Include Parameters File
`include "SmcParams.v"

// -----------------------------------------------------------------------------

module SmcEIB (
// Inputs
               HCLK,
               HRESETn,
               HWDATA,
               HSizeRegCo,
               MSize08,
               MSize16,
               MSize32,
               BIGENDIAN,
               RemapReg,
               RBLE,
               BM,
               CSPol,
               SMCsEnCo,
               SMCDATAIN,
               SmcState,
               CntEnd,
               HAddrCrnt,
               HAddrWtdCo,
               BnkAddStrCo,
               AddrIncCo,
               MemWrReq,
               MemRdReq,
               WtdWrReq,
               WtdRdReq,
               MwPgm,
               BufWrOver,
               ExtWrEnCo,
               ExtWrDisCo,
               RdCntLdCo,
               XoutEnCo,
               XoutDisCo,
               XdatDisCo,
               RdXdatEnCo,
               WrXdatEnCo,
               BufByPassCo,
               BrstAddIncCo,
               BMRdTrans,
               HBurstRegCo,
               CntEZEnd,
               MW,
               HTransRegCo,
               FastRdOp,
               WaitToutErr,

// Outputs
               PosSMWEN,
               PosSMBLS,
               SMCS,
               SMCDATAOUT,
               SMCADDR,
               nSMOEN,
               nSMCDATAEN,
               MemWrOver,
               MemWrOverCo,
               MemRdOver,
               MemRdOverCo,
               BMlenEnd,
               RdWrBuf,
               AhbRdEn,
               SmcAddrReg
              );

// Inputs
input         HCLK;            // Bus Clock
input         HRESETn;         // Module Reset
input  [31:0] HWDATA;          // Write data input bus from AHB
input   [1:0] HSizeRegCo;      // Registered AHB Transfer Size
input         MSize08;         // Signal indicating 8-bit Memory width
input         MSize16;         // Signal indicating 16-bit Memory width
input         MSize32;         // Signal indicating 32-bit Memory width
input         BIGENDIAN;       // This input determines the endianness of the
                               // system
input         RemapReg;        // The memory map is determined by this input
input         RBLE;            // Byte lane enabled device
input         BM;              // Burst ROM device indication
input   [7:0] CSPol;           // Chip Select polarity
input         SMCsEnCo;        // Chip Select enable
input  [31:0] SMCDATAIN;       // External memory input data bus
input   [3:0] SmcState;        // The state machine's current state value
input         CntEnd;          // Access timer counter termination signal
input  [25:0] HAddrCrnt;       // Registered HADDR for a new transfer
input  [25:0] HAddrWtdCo;      // Registered HADDR for a waited transfer
input   [2:0] BnkAddStrCo;     // Stored value of the current Bank Address
input         AddrIncCo;       // Address increment signal from TSM
input         MemWrReq;        // Signal indicating the write transfer
                               // being initiated
input         MemRdReq;        // Signal indicating the read transfer
                               // being initiated
input         WtdWrReq;        // Signal indicating that write transfer is
                               // pending on the AHB
input         WtdRdReq;        // Signal indicating that read transfer
                               // is pending on the AHB
input         MwPgm;           // Indicates that the Waited Read or
                               // Write Request is due to MW programming
input         BufWrOver;       // Buffer storage completion signal during write
                               // transfers
input         ExtWrEnCo;       // Signal to enable the output write control and
                               // data signals of the memory device during WR
input         ExtWrDisCo;      // Disabling signal for the write enable and
                               // bytelane selects
input         RdCntLdCo;       // Load Count value in Timer counter
                               // for normal Read Access
input         XoutEnCo;        // Enable signal for the nSMOEN
input         XoutDisCo;       // Disable signal for the nSMOEN
input         XdatDisCo;       // Signal to de-assert the SMCDATAEN output lines
input         RdXdatEnCo;      // Signal to assert the proper byte lanes of
                               // external data bus depending on memory width
                               // during reads
input         WrXdatEnCo;      // Signal to assert all the byte lanes of
                               // external data bus during a write transfer and
                               // during Idle cycles
input         BufByPassCo;     // This signal is used to indicate that the
                               // HSIZE = MSIZE and the RdWrBuf can be
                               // bypassed during transfers
input         BrstAddIncCo;    // Signal for incrementing the SMADDR in advance
                               // during burst reads
input         BMRdTrans;       // This signal indicates that
                               // current transfer status is burst mode reads
input   [2:0] HBurstRegCo;     // Registered HBURST signal from AHB interface
                               // block
input         CntEZEnd;        // Timer counter expiry signal
                               // when count values are zero
input   [1:0] MW;              // The memory width bits selection
                               // from one of the bank registers
input   [1:0] HTransRegCo;     // Registered HTRANS signal from
                               // AHB interface block
input         FastRdOp;        // In case of Burst reads when the buffer has
                               // more data than required by current
                               // AHB transfer, it is possible to provide
                               // the subsequent data from the internal buffer
                               // if the next sequential addresses are
                               // in the same field in zero cycles.
                               // So speculative advance reads are not done
input         WaitToutErr;     // Wait Timeout Error signal

// Outputs
output        PosSMWEN;        // Positive edge (HCLK) triggered Write Enable,
                               // SMWEN
output  [3:0] PosSMBLS;        // Positive edge (HCLK) triggered byte lane
                               // select, SMBLS
output  [7:0] SMCS;            // Chip Selects of the external memory devices
output [31:0] SMCDATAOUT;      // External data output bus to the memory
output [25:0] SMCADDR;         // External memory address bus
output        nSMOEN;          // Output enable signal to the external device
                               // during reads
output  [3:0] nSMCDATAEN;      // Tristate I/O pad enables for the byte lanes
                               // of the external memory data bus
output        MemWrOver;       // Write completion signal to indicate
                               // that all data packets have been flushed to the
                               // device
output        MemWrOverCo;     // This signal is the combinational
                               // version of the MemWrOver
output        MemRdOver;       // This signal indicates that the all data
                               // packets are read from the memory device at
                               // the end of read access time
output        MemRdOverCo;     // Combinational version of the MemRdOver
output        BMlenEnd;        // Burst length termination signal during burst
                               // reads
output [31:0] RdWrBuf;         // Read data path from the EIB block to the
                               // HRDATA lines in the AHB interface block
output        AhbRdEn;         // Enabling signal to route data to HRDATA bus
                               // on read completion
output  [3:1] SmcAddrReg;      // Registered version of SMCADDR

// Inputs
wire          HCLK;            // Bus Clock
wire          HRESETn;         // Module Reset
wire   [31:0] HWDATA;          // Write data input bus from AHB
wire    [1:0] HSizeRegCo;      // Registered AHB Transfer Size
wire          MSize08;         // Signal indicating 8-bit Memory width
wire          MSize16;         // Signal indicating 16-bit Memory width
wire          MSize32;         // Signal indicating 32-bit Memory width
wire          BIGENDIAN;       // This input determines the endianness of the
                               // system
wire          RemapReg;        // The memory map is determined by this input
wire          RBLE;            // Byte lane enabled device
wire          BM;              // Burst ROM device indication
wire    [7:0] CSPol;           // Chip Select polarity
wire          SMCsEnCo;        // Chip Select enable
wire   [31:0] SMCDATAIN;       // External memory input data bus
wire    [3:0] SmcState;        // The state machine's current state value
wire          CntEnd;          // Access timer counter termination signal
wire   [25:0] HAddrCrnt;       // Registered HADDR for a new transfer
wire   [25:0] HAddrWtdCo;      // Registered HADDR for a waited transfer
wire    [2:0] BnkAddStrCo;     // Stored value of the current Bank Address
wire          AddrIncCo;       // Address increment signal from TSM
wire          MemWrReq;        // Signal indicating the write transfer
                               // being initiated
wire          MemRdReq;        // Signal indicating the read transfer being
                               // initiated
wire          WtdWrReq;        // Signal indicating that write transfer is
                               // pending on the AHB
wire          WtdRdReq;        // Signal indicating that read transfer
                               // is pending on the AHB
wire          MwPgm;           // Indicates that the Waited Read or Write
                               // Request is due to MW programming
wire          BufWrOver;       // Buffer storage completion signal during write
                               // transfers
wire          ExtWrEnCo;       // Signal to enable the output write control and
                               // data signals of the memory device during WR
wire          ExtWrDisCo;      // Disabling signal for the write enable and
                               // bytelane selects
wire          RdCntLdCo;       // Load Count value in Timer counter for normal
                               // Read Access
wire          XoutEnCo;        // Enable signal for the nSMOEN
wire          XoutDisCo;       // Disable signal for the nSMOEN
wire          XdatDisCo;       // Signal to de-assert the SMCDATAEN output lines
wire          RdXdatEnCo;      // Signal to assert the proper byte
                               // lanes of external data bus depending
                               // on memory width during reads
wire          WrXdatEnCo;      // Signal to assert all the byte lanes
                               // of external data bus during a write
                               // transfer and during Idle cycles
wire          BufByPassCo;     // This signal is used to indicate that the
                               // HSIZE = MSIZE and the RdWrBuf can be
                               // bypassed during transfers
wire          BrstAddIncCo;    // Signal for incrementing the SMADDR in advance
                               // during burst reads
wire          BMRdTrans;       // This signal indicates that current transfer
                               // status is burst mode reads
wire    [2:0] HBurstRegCo;     // Registered HBURST signal from AHB interface
                               // block
wire          CntEZEnd;        // Timer counter expiry signal when count
                               // values are zero
wire    [1:0] MW;              // The memory width bits selection
                               // from one of the bank registers
wire    [1:0] HTransRegCo;     // Registered HTRANS signal from
                               // AHB interface block
wire          FastRdOp;        // In case of Burst reads when the buffer has
                               // more data than required by current
                               // AHB transfer, it is possible to provide
                               // the subsequent data from the internal buffer
                               // if the next sequential addresses are
                               // in the same field in zero cycles.
                               // So speculative advance reads are not done
wire          WaitToutErr;     // Wait Timeout Error signal


// Outputs
wire          PosSMWEN;        // Positive edge (HCLK) triggered Write Enable,
                               // SMWEN
wire    [3:0] PosSMBLS;        // Positive edge (HCLK) triggered byte lane
                               // select, SMBLS
wire    [7:0] SMCS;            // Chip Selects of the external memory devices
wire   [31:0] SMCDATAOUT;      // External data output bus to the memory
wire   [25:0] SMCADDR;         // External memory address bus
wire          nSMOEN;          // Output enable signal to the external device
                               // during reads
wire    [3:0] nSMCDATAEN;      // Tristate I/O pad enables for the
                               // byte lanes of the external memory data bus
wire          MemWrOver;       // Write completion signal to indicate
                               // that all data packets have been flushed to the
                               // device
wire          MemWrOverCo;     // This signal is the combinational version of
                               // the MemWrOver
wire          MemRdOver;       // This signal indicates that the all data
                               // packets are read from the memory device at
                               // the end of read access time
wire          MemRdOverCo;     // Combinational version of the MemRdOver
wire          BMlenEnd;        // Burst length termination signal during burst
                               // reads
wire   [31:0] RdWrBuf;         // Read data path from the EIB block to the
                               // HRDATA lines in the AHB interface block
wire          AhbRdEn;         // Enabling signal to route data to
                               // HRDATA bus on read completion
reg     [3:1] SmcAddrReg;      // Registered version of SMCADDR

// -----------------------------------------------------------------------------
//
//                                   SmcEIB
//                                   ======
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
wire [31:0] NextRdWrBuf;
// D-input of the RdWrBuf buffer

wire        NextBufWrOvStrE;
// D-input of BufWrOvStrE

// -----------------------------------------------------------------------------
// Register declarations
// -----------------------------------------------------------------------------
reg   [7:0] iSMCS;
// Internal copy of the chip select signals SMCS

reg   [7:0] NextSMCS;
// D-input of the SMCS signal

reg         inSMOEN;
// Internal copy of nSMOEN

reg         NextnSMOEN;
// D-input of nSMOEN

reg   [3:0] inSMCDATAEN;
// Internal copy of nSMCDATAEN

reg   [3:0] NextnSMCDATAEN;
// D-input of nSMCDATAEN

reg  [25:0] iSMCADDR;
// Internal copy of the SMCADDR bus

reg  [25:0] NextSMCADDR;
// D-input of SMCADDR

reg   [1:0] HAddrSel;
// The lower order of registered address selected, depending on whether transfer
// is a new transfer or a waited transfer

reg   [3:0] WrBufWrEnCo;
// Combinational version of the WrBufWrEn

reg   [3:0] WrBufWrEn;
// Internal copy of the WrBufWrEn

reg   [3:0] NextWrBufWrEn;
// D-input of WrBufWrEn

reg   [3:0] RdBufWrEn;
// The temporary Buf write enables generated for storing the read data

reg  [31:0] TmpBufDat;
// Multiplexed output to the RdWrBuf which selects between the write data path
// and read data path

reg  [31:0] TmpRdDat;
// Temporary read data multiplexed output to the RdWrBuf during read transfers
// which takes care of the endianness, HSIZE and MSize

reg  [31:0] iRdWrBuf;
// The internal read-write buffer to store the intermediate data packets during
// a read or a write transfer

reg         iMemWrOver;
// Internal copy of MemWrOver

reg         NextMemWrOver;
// D-input of MemWrOver

reg  [31:0] iSMCDATAOUT;
// Internal copy of SMCDATAOUT data bus

reg  [31:0] NextSMCDATAOUT;
// D-input of SMCDATAOUT

reg         iMemRdOver;
// Internal copy of MemRdOver

reg         NextMemRdOver;
// D-input of MemRdOver

reg         iBMlenEnd;
// Internal copy of BMlenEnd

reg         NextBMlenEnd;
// D-input of BMlenEnd

reg         iPosSMWEN;
// Local copy of PosSMWEN

reg         NextPosSMWEN;
// D-input of PosSMWEN

reg   [3:0] iPosSMBLS;
// Local copy of PosSMBLS

reg   [3:0] NextPosSMBLS;
// D-input of PosSMBLS

reg         BufWrOvStrE;
// The buffer WR completion signal is stored till the MemWrOver is asserted

reg   [9:0] BurstAddr;
// During burst reads, the HADDR is updated in advance using the HBURST and
// HSIZE information

reg   [9:0] NextBurstAddr;
// D-input of BurstAddr

reg         iAhbRdEn;
// Enabling signal to route data to HRDATA bus on read completion

wire        NextAhbRdEn;
// D-input of AhbRdEn


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
// Advance address generation during burst reads depending on the value of
// HBURST. This is the advance evaluation of the next HADDR depending
// on the HSIZE and HBURST values
// -----------------------------------------------------------------------------
always @(BurstAddr or BMRdTrans or BrstAddIncCo or HBurstRegCo or
         HSizeRegCo or MemRdReq or HAddrCrnt or WtdRdReq or
         iMemWrOver or MwPgm or HAddrWtdCo or HTransRegCo or FastRdOp)
begin : p_BMAddrComb
  NextBurstAddr    = BurstAddr;

  if (BMRdTrans == 1'b1 && BrstAddIncCo == 1'b1)
    begin
      case (HBurstRegCo)
      
        `INCR, `INCR4, `INCR8, `INCR16 :
          begin
            case (HSizeRegCo)
              2'b10 :
                begin
                  NextBurstAddr[1:0] = 2'b00;
                  NextBurstAddr[9:2] = BurstAddr[9:2] + 1;
                end
              2'b01 :
                begin
                  NextBurstAddr[0]   = 1'b0;
                  NextBurstAddr[9:1] = BurstAddr[9:1] + 1;
                end
              2'b00 :
                begin
                  NextBurstAddr[9:0] = BurstAddr[9:0] + 1;
                end
              default : ;
              endcase
          end

        `WRAP4  :
          begin
            case (HSizeRegCo)
              2'b10 :
                begin
                  NextBurstAddr[9:4] = BurstAddr[9:4];
                  NextBurstAddr[3:2] = BurstAddr[3:2] + 1;
                  NextBurstAddr[1:0] = 2'b00;
                end
              2'b01 :
                begin
                  NextBurstAddr[9:3] = BurstAddr[9:3];
                  NextBurstAddr[2:1] = BurstAddr[2:1] + 1;
                  NextBurstAddr[0]   = 1'b0;
                end
              2'b00 :
                begin
                  NextBurstAddr[9:2] = BurstAddr[9:2];
                  NextBurstAddr[1:0] = BurstAddr[1:0] + 1;
                end
              default : ;
              endcase
          end

        `WRAP8  :
          begin
            case (HSizeRegCo)
              2'b10 :
                begin
                  NextBurstAddr[9:5] = BurstAddr[9:5];
                  NextBurstAddr[4:2] = BurstAddr[4:2] + 1;
                  NextBurstAddr[1:0] = 2'b00;
                end
              2'b01 :
                begin
                  NextBurstAddr[9:4] = BurstAddr[9:4];
                  NextBurstAddr[3:1] = BurstAddr[3:1] + 1;
                  NextBurstAddr[0]   = 1'b0;
                end
              2'b00 :
                begin
                  NextBurstAddr[9:3] = BurstAddr[9:3];
                  NextBurstAddr[2:0] = BurstAddr[2:0] + 1;
                end
              default : ;
              endcase
          end

        `WRAP16 :
          begin
            case (HSizeRegCo)
              2'b10 :
                begin
                  NextBurstAddr[9:6] = BurstAddr[9:6];
                  NextBurstAddr[5:2] = BurstAddr[5:2] + 1;
                  NextBurstAddr[1:0] = 2'b00;
                end
              2'b01 :
                begin
                  NextBurstAddr[9:5] = BurstAddr[9:5];
                  NextBurstAddr[4:1] = BurstAddr[4:1] + 1;
                  NextBurstAddr[0]   = 1'b0;
                end
              2'b00 :
                begin
                  NextBurstAddr[9:4] = BurstAddr[9:4];
                  NextBurstAddr[3:0] = BurstAddr[3:0] + 1;
                end
              default : ;
              endcase
          end
        default : ;
        endcase
    end
  // Initialise to the start of the Burst Address for a new Read transaction
  // request with NSEQ. This can be a new Read request after IDLE or on
  // completion of previous Write or Read. It can also be a Read request which
  // is detected at end of a Burst Read transaction. In these cases the current
  // stored bus address must be loaded.
  else if (MemRdReq == 1'b1 &&
           (BMRdTrans == 1'b0 ||
            (BMRdTrans == 1'b1 &&
             (HTransRegCo == `T_NONSEQ || FastRdOp == 1'b1))))
    begin
      NextBurstAddr    = HAddrCrnt[9:0];
    end  
  // Initialise to the start of the Burst Address in the Waited Read Mode
  else if (WtdRdReq == 1'b1 && (iMemWrOver == 1'b1 || MwPgm == 1'b1))
    begin
      NextBurstAddr    = HAddrWtdCo[9:0];
    end

end // p_BMAddrCo;

// -----------------------------------------------------------------------------
// External address [SMCADDR] generation logic
// -----------------------------------------------------------------------------
always @(iSMCADDR or HAddrCrnt or HAddrWtdCo or MemWrReq or MemRdReq or
         AddrIncCo or MSize08 or MSize16 or WtdWrReq or WtdRdReq or
         iMemWrOver or MwPgm or BMRdTrans or NextBurstAddr or
         NextMemRdOver or HTransRegCo or FastRdOp)
begin : p_SmAddrGenComb
  NextSMCADDR      = iSMCADDR;
  HAddrSel         = 2'b00;

  if (AddrIncCo == 1'b1) 
    begin
      NextSMCADDR[25:10] = iSMCADDR[25:10];
      if (MSize08 == 1'b1)
        begin
          NextSMCADDR[9:0] = iSMCADDR[9:0] + 1;
        end
      else if (MSize16 == 1'b1)
        begin
          NextSMCADDR[0]   = 1'b0;
          NextSMCADDR[9:1] = iSMCADDR[9:1] + 1;
        end
    end
  else if (BMRdTrans == 1'b1 && NextMemRdOver == 1'b1)
    begin
      NextSMCADDR[25:10] = iSMCADDR[25:10];
      NextSMCADDR[9:0]   = NextBurstAddr;
    end
  // Initialise to the start of the Address for a new Read or Write transaction
  // request with NSEQ. This can be a new Read or Write request after IDLE or on
  // completion of previous Write or Read. It can also be a Read request which
  // is detected at end of a Burst Read transaction. In these cases the current
  // stored bus address must be loaded.
  else if (MemWrReq == 1'b1 ||
           (BMRdTrans == 1'b0 && MemRdReq == 1'b1) ||
           (BMRdTrans == 1'b1 && MemRdReq == 1'b1 &&
            (HTransRegCo == `T_NONSEQ || FastRdOp == 1'b1)))
    begin
      NextSMCADDR      = HAddrCrnt;
      HAddrSel         = HAddrCrnt[1:0];
    end
  else if ((WtdWrReq == 1'b1 || WtdRdReq == 1'b1) &&
           (iMemWrOver == 1'b1 || MwPgm == 1'b1))
    begin
      NextSMCADDR      = HAddrWtdCo;
      HAddrSel         = HAddrWtdCo[1:0];
    end
end // p_SmAddrGenComb

// -----------------------------------------------------------------------------
// Clocked logic for the SMCADDR address lines
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_SmAddrGenSeq
  if (HRESETn == 1'b0)
    begin
      iSMCADDR         <= {24'h000000, 2'b00};
      BurstAddr        <= {8'h00, 2'b00};
      SmcAddrReg       <= 3'b000;
    end
  else
    begin
      iSMCADDR         <= NextSMCADDR;
      BurstAddr        <= NextBurstAddr;
      SmcAddrReg       <= iSMCADDR[3:1];
    end
end // p_SmAddrGenSeq

// -----------------------------------------------------------------------------
// Logic for generating the Buffer enables for storing the write data
// making these active low for implementation reuse ease. These write enables
// will be used while generating the SMBLS output pins
// -----------------------------------------------------------------------------
always @(BIGENDIAN or HAddrSel or HSizeRegCo or iMemWrOver or MemWrReq or
         WrBufWrEn or WtdWrReq or NextMemWrOver or MwPgm)
begin : p_WrBufWrEnComb
  NextWrBufWrEn    = WrBufWrEn;
  WrBufWrEnCo      = 4'b1111;

  if (MemWrReq == 1'b1 ||
      ((iMemWrOver == 1'b1 || MwPgm == 1'b1) && WtdWrReq == 1'b1))
    begin
      if (HSizeRegCo == 2'b10)
        begin
          NextWrBufWrEn    = 4'b0000;
          WrBufWrEnCo      = 4'b0000;
        end
      else if (HSizeRegCo == 2'b01)
        begin
          case (HAddrSel[1])
            1'b0 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextWrBufWrEn[1:0] = 2'b00;
                    WrBufWrEnCo        = 4'b1100;
                  end
                else
                  begin
                    NextWrBufWrEn[3:2] = 2'b00;
                    WrBufWrEnCo        = 4'b0011;
                  end
              end
   
            1'b1 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextWrBufWrEn[3:2] = 2'b00;
                    WrBufWrEnCo        = 4'b0011;
                  end
                else
                  begin
                    NextWrBufWrEn[1:0] = 2'b00;
                    WrBufWrEnCo        = 4'b1100;
                  end
              end

            default : ;
              
            endcase
        end
      else if (HSizeRegCo == 2'b00)
        begin
          case (HAddrSel)
            2'b00 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextWrBufWrEn[0] = 1'b0;
                    WrBufWrEnCo      = 4'b1110;
                  end
                else
                  begin
                    NextWrBufWrEn[3] = 1'b0;
                    WrBufWrEnCo      = 4'b0111;
                  end
              end
            2'b01 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextWrBufWrEn[1] = 1'b0;
                    WrBufWrEnCo      = 4'b1101;
                  end
                else
                  begin
                    NextWrBufWrEn[2] = 1'b0;
                    WrBufWrEnCo      = 4'b1011;
                  end
              end
            2'b10 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextWrBufWrEn[2] = 1'b0;
                    WrBufWrEnCo      = 4'b1011;
                  end
                else
                  begin
                    NextWrBufWrEn[1] = 1'b0;
                    WrBufWrEnCo      = 4'b1101;
                  end
              end
            2'b11 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextWrBufWrEn[3] = 1'b0;
                    WrBufWrEnCo      = 4'b0111;
                  end
                else
                  begin
                    NextWrBufWrEn[0] = 1'b0;
                    WrBufWrEnCo      = 4'b1110;
                  end
              end
            default : ;
              
            endcase
        end
    end
  else if (NextMemWrOver == 1'b1)
    begin
      NextWrBufWrEn    = 4'b1111;
    end
end // p_WrBufWrEnComb

// -----------------------------------------------------------------------------
// Logic for generating the Buffer enables for storing the read data
// -----------------------------------------------------------------------------
always @(BIGENDIAN or iSMCADDR or MSize08 or MSize16 or MSize32 or
         CntEnd or SmcState or CntEZEnd)
begin : p_RdBufWrEnComb
  RdBufWrEn        = 4'b0000;

  if ((CntEnd == 1'b1 || CntEZEnd == 1'b1) && SmcState == `ST_TSM_MEMRD)
    begin
      if (MSize32 == 1'b1)
        begin
          RdBufWrEn[3:0]   = 4'b1111;
        end
      else if (MSize16 == 1'b1)
        begin
          case (iSMCADDR[1])
            1'b0 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    RdBufWrEn[3:0]   = 4'b0011;
                  end
                else
                  begin
                    RdBufWrEn[3:0]   = 4'b1100;
                  end
              end
            1'b1 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    RdBufWrEn[3:0]   = 4'b1100;
                  end
                else
                  begin
                    RdBufWrEn[3:0]   = 4'b0011;
                  end
              end
            default : ;
              
            endcase
        end
      else if (MSize08 == 1'b1)
        begin
          case (iSMCADDR[1:0])
            2'b00 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    RdBufWrEn[3:0]   = 4'b0001;
                  end
                else
                  begin
                    RdBufWrEn[3:0]   = 4'b1000;
                  end
              end
            2'b01 :
              begin
              if (BIGENDIAN == 1'b0)
                  begin
                    RdBufWrEn[3:0]   = 4'b0010;
                  end
              else
                  begin
                    RdBufWrEn[3:0]   = 4'b0100;
                  end
              end
            2'b10 :
              begin
              if (BIGENDIAN == 1'b0)
                  begin
                    RdBufWrEn[3:0]   = 4'b0100;
                  end
              else
                  begin
                    RdBufWrEn[3:0]   = 4'b0010;
                  end
              end
            2'b11 :
              begin
              if (BIGENDIAN == 1'b0)
                  begin
                    RdBufWrEn[3:0]   = 4'b1000;
                  end
              else
                  begin
                    RdBufWrEn[3:0]   = 4'b0001;
                  end
              end
            default : ;
              
            endcase
        end
    end
end // p_RdBufWrEnComb

// -----------------------------------------------------------------------------
// Combinational logic for multiplexing the read data and write data into a
// temporary data bus before storing into the RdWrBuf
// -----------------------------------------------------------------------------
always @(MemWrReq or iMemWrOver or HWDATA or TmpRdDat or WtdWrReq or MwPgm)
begin : p_TmpBufStrComb

  if (MemWrReq == 1'b1 || ((iMemWrOver == 1'b1 || MwPgm == 1'b1) &&
                           WtdWrReq == 1'b1))
    begin
      TmpBufDat        = HWDATA;
    end
  else
    begin
      TmpBufDat        = TmpRdDat;
    end
end // p_TmpBufStrComb

// -----------------------------------------------------------------------------
// Logic for storing/routing the write data or read data into the RdWr buffer
// -----------------------------------------------------------------------------
assign NextRdWrBuf[7:0] = (WrBufWrEnCo[0] == 1'b0 ||
                           RdBufWrEn[0] == 1'b1) ?
                          TmpBufDat[7:0]          :
                          iRdWrBuf[7:0];

assign NextRdWrBuf[15:8] = (WrBufWrEnCo[1] == 1'b0 ||
                            RdBufWrEn[1] == 1'b1) ?
                           TmpBufDat[15:8]          :
                           iRdWrBuf[15:8];

assign NextRdWrBuf[23:16] = (WrBufWrEnCo[2] == 1'b0 ||
                             RdBufWrEn[2] == 1'b1) ?
                            TmpBufDat[23:16]          :
                            iRdWrBuf[23:16];

assign NextRdWrBuf[31:24] = (WrBufWrEnCo[3] == 1'b0 ||
                             RdBufWrEn[3] == 1'b1) ?
                            TmpBufDat[31:24]          :
                            iRdWrBuf[31:24];

// -----------------------------------------------------------------------------
// Clocked process for the RdWrBuf updation and write control signals
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RdWrBufSeq
  if (HRESETn == 1'b0)
    begin
      iRdWrBuf         <= 32'h00000000;
      iMemWrOver       <= 1'b0;
      WrBufWrEn        <= 4'b1111;
    end
  else
    begin
      iRdWrBuf         <= NextRdWrBuf;
      iMemWrOver       <= NextMemWrOver;
      WrBufWrEn        <= NextWrBufWrEn;
    end
end // p_RdWrBufSeq

// -----------------------------------------------------------------------------
// Logic to determine the completion of writing out to the Memory device
// It depends on the MSIZE value and the number of data packets to be
// written out to device in that many number of access. The SmcCore will be
// the MEM_WR state.
// -----------------------------------------------------------------------------
always @(HSizeRegCo or MW or iSMCADDR or SmcState or CntEnd or CntEZEnd or
         WaitToutErr)
begin : p_MemWrOvrComb
  NextMemWrOver    = ((SmcState == `ST_TSM_MEMWR) && (WaitToutErr == 1'b1))
                         ? 1'b1: 1'b0;

  if ((SmcState == `ST_TSM_MEMWR && (CntEnd == 1'b1 || CntEZEnd == 1'b1))
     &&
      (MW == 2'b10 || HSizeRegCo == 2'b00
      ||
       (HSizeRegCo == 2'b10 &&
        ((MW == 2'b01 && iSMCADDR[1] == 1'b1) ||
         (MW == 2'b00 && iSMCADDR[1:0] == 2'b11)))
      ||
       (HSizeRegCo == 2'b01 &&
        (MW == 2'b01 || (MW == 2'b00 && iSMCADDR[0] == 1'b1)))
      )
     )
    begin
      NextMemWrOver    = 1'b1;
    end
end // p_MemWrOvrComb

// -----------------------------------------------------------------------------
// Logic for storing the BufWrOver signal when the HSIZE > MSize during WR
// -----------------------------------------------------------------------------
assign NextBufWrOvStrE = (BufWrOver == 1'b1) ? 1'b1 :
                         ((NextMemWrOver == 1'b1 || SmcState == `ST_TSM_MEMRD ||
                           SmcState == `ST_TSM_IDLE) ? 1'b0 : BufWrOvStrE);

// -----------------------------------------------------------------------------
// Logic to route the external memory data SMCDATAOUT
// During writes depending on the memory width, the corresponding byte lanes
// are driven.
// During reads, at the end of the read access time the relevant SMCDATAIN
// byte lanes are routed to SMCDATAOUT for recirculation of the data.
// -----------------------------------------------------------------------------
always @(MSize08 or MSize16 or MSize32 or SMCDATAIN or CntEnd or
         SmcState or iSMCDATAOUT or iRdWrBuf or
         BIGENDIAN or BufWrOver or BufWrOvStrE or BufByPassCo or
         TmpBufDat or NextSMCADDR or MemWrReq or iMemWrOver or
         WtdWrReq or MwPgm or CntEZEnd)
begin : p_ExtDatOutComb
  NextSMCDATAOUT   = iSMCDATAOUT;

  if (BufByPassCo == 1'b1 &&
      (MemWrReq == 1'b1 || ((iMemWrOver == 1'b1 || MwPgm == 1'b1) &&
                            WtdWrReq == 1'b1)))
    begin
      if (MSize32 == 1'b1)
        begin
          NextSMCDATAOUT   = TmpBufDat;
        end
      else if (MSize16 == 1'b1)
        begin
          case (NextSMCADDR[1])
            1'b0 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextSMCDATAOUT[15:0] = TmpBufDat[15:0];
                  end
                else
                  begin
                    NextSMCDATAOUT[15:0] = TmpBufDat[31:16];
                  end
              end
            1'b1 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextSMCDATAOUT[15:0] = TmpBufDat[31:16];
                  end
                else
                  begin
                    NextSMCDATAOUT[15:0] = TmpBufDat[15:0];
                  end
              end
            default : ;
              
            endcase
        end
      else if (MSize08 == 1'b1)
        begin
          case (NextSMCADDR[1:0])
            2'b00 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextSMCDATAOUT[7:0] = TmpBufDat[7:0];
                  end
                else
                  begin
                    NextSMCDATAOUT[7:0] = TmpBufDat[31:24];
                  end
              end
            2'b01 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextSMCDATAOUT[7:0] = TmpBufDat[15:8];
                  end
                else
                  begin
                    NextSMCDATAOUT[7:0] = TmpBufDat[23:16];
                  end
              end
            2'b10 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextSMCDATAOUT[7:0] = TmpBufDat[23:16];
                  end
                else
                  begin
                    NextSMCDATAOUT[7:0] = TmpBufDat[15:8];
                  end
              end
            2'b11 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextSMCDATAOUT[7:0] = TmpBufDat[31:24];
                  end
                else
                  begin
                    NextSMCDATAOUT[7:0] = TmpBufDat[7:0];
                  end
              end
            default : ;
              
            endcase
        end
    end
  else if (BufWrOver == 1'b1 || BufWrOvStrE == 1'b1) 
    begin
      if (MSize32 == 1'b1)
        begin
          NextSMCDATAOUT = iRdWrBuf;
        end
      else if (MSize16 == 1'b1)
        begin
          case (NextSMCADDR[1])
            1'b0 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextSMCDATAOUT[15:0] = iRdWrBuf[15:0];
                  end
                else
                  begin
                    NextSMCDATAOUT[15:0] = iRdWrBuf[31:16];
                  end
              end
            1'b1 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextSMCDATAOUT[15:0] = iRdWrBuf[31:16];
                  end
                else
                  begin
                    NextSMCDATAOUT[15:0] = iRdWrBuf[15:0];
                  end
              end
            default : ;
              
            endcase
        end
      else if (MSize08 == 1'b1)
        begin
          case (NextSMCADDR[1:0])
            2'b00 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextSMCDATAOUT[7:0] = iRdWrBuf[7:0];
                  end
                else
                  begin
                    NextSMCDATAOUT[7:0] = iRdWrBuf[31:24];
                  end
              end
            2'b01 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextSMCDATAOUT[7:0] = iRdWrBuf[15:8];
                  end
                else
                  begin
                    NextSMCDATAOUT[7:0] = iRdWrBuf[23:16];
                  end
              end
            2'b10 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextSMCDATAOUT[7:0] = iRdWrBuf[23:16];
                  end
                else
                  begin
                    NextSMCDATAOUT[7:0] = iRdWrBuf[15:8];
                  end
              end
            2'b11 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    NextSMCDATAOUT[7:0] = iRdWrBuf[31:24];
                  end
                else
                  begin
                    NextSMCDATAOUT[7:0] = iRdWrBuf[7:0];
                  end
              end
            default : ;
              
            endcase
        end
    end
  else if ((CntEnd == 1'b1 || CntEZEnd == 1'b1) && SmcState == `ST_TSM_MEMRD)
    begin
      if (MSize32 == 1'b1)
        begin
          NextSMCDATAOUT = SMCDATAIN;
        end
      else if (MSize16 == 1'b1)
        begin
          NextSMCDATAOUT[15:0] = SMCDATAIN[15:0];
        end
      else if (MSize08 == 1'b1)
        begin
          NextSMCDATAOUT[7:0] = SMCDATAIN[7:0];
        end
    end
end // p_ExtDatOutComb

// -----------------------------------------------------------------------------
// Clocked logic for the SMCDATAOUT data lines
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_ExtDatOutSeq
  if (HRESETn == 1'b0)
    begin
      iSMCDATAOUT      <= 32'h00000000;
      BufWrOvStrE      <= 1'b0;
    end
  else
    begin
      iSMCDATAOUT      <= NextSMCDATAOUT;
      BufWrOvStrE      <= NextBufWrOvStrE;
    end
end // p_ExtDatOutSeq

// -----------------------------------------------------------------------------
// Logic to determine the completion of reading in from the Memory device
// It depends on the MSIZE & HSIZE value and the number of data packets
// read in from memory device.
// -----------------------------------------------------------------------------
always @(MW or HSizeRegCo or CntEnd or iSMCADDR or SmcState or CntEZEnd or
         HTransRegCo or BMRdTrans or iAhbRdEn or WaitToutErr)
begin : p_MemRdOvrComb
   NextMemRdOver    = ((SmcState == `ST_TSM_MEMRD) && (WaitToutErr == 1'b1))
                         ? 1'b1: 1'b0;
  if (((CntEnd == 1'b1 || CntEZEnd == 1'b1) && SmcState == `ST_TSM_MEMRD &&
       (!(iAhbRdEn == 1'b1 && BMRdTrans == 1'b1 &&
          (HTransRegCo == `T_NONSEQ || HTransRegCo == `T_IDLE))))
     &&
      ((HSizeRegCo == 2'b10 &&
        (MW == 2'b10 || (MW == 2'b01 && iSMCADDR[1] == 1'b1) ||
         (MW == 2'b00 && iSMCADDR[1:0] == 2'b11)))
      ||
       (HSizeRegCo == 2'b01 &&
        (MW == 2'b10 || MW == 2'b01 || (MW == 2'b00 && iSMCADDR[0] == 1'b1)))
      ||
       (HSizeRegCo == 2'b00)
      )
     )
    begin
      NextMemRdOver    = 1'b1;
    end
end // p_MemRdOvrComb

// -----------------------------------------------------------------------------
// At the completion of the read, enabling signal is generated for routing
// data from internal busffer to the HRDATA bus in the Ahbif module
// -----------------------------------------------------------------------------
assign NextAhbRdEn      = (iMemRdOver == 1'b1) ? 1'b1 : 1'b0;

// -----------------------------------------------------------------------------
// Clocked logic for the intermediate signals
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_RdContSeq
  if (HRESETn == 1'b0)
    begin
      iMemRdOver       <= 1'b0;
      iBMlenEnd        <= 1'b0;
      iAhbRdEn         <= 1'b0;
    end
  else
    begin
      iMemRdOver       <= NextMemRdOver;
      iBMlenEnd        <= NextBMlenEnd;
      iAhbRdEn         <= NextAhbRdEn;
    end
end // p_RdContSeq

// -----------------------------------------------------------------------------
// Logic to determine the end of the Burst length and the crossover of the
// address Quad-boundary. This logic is used for the purpose of introducing
// the burst length restriction.
// -----------------------------------------------------------------------------
always @(iBMlenEnd or BM or MSize08 or MSize16 or MSize32 or NextSMCADDR or
         RdCntLdCo or HBurstRegCo or HSizeRegCo or MW)
begin : p_BMlenComb
  NextBMlenEnd     = iBMlenEnd;

  if (BM == 1'b1)
    begin
      if (RdCntLdCo == 1'b1)
        begin
          NextBMlenEnd     = 1'b0;
        end
      else if (((MSize08 == 1'b1 && NextSMCADDR[1:0] == 2'b11) ||
                (MSize16 == 1'b1 && NextSMCADDR[2:1] == 2'b11) ||
                (MSize32 == 1'b1 && NextSMCADDR[3:2] == 2'b11)) &&
               ((HSizeRegCo > MW) ||
                (HBurstRegCo != `WRAP4 && HSizeRegCo == MW) ||
                (HBurstRegCo != `WRAP8 &&
                 ((HSizeRegCo == 2'b00 && MSize16 == 1'b1) ||
                  (HSizeRegCo == 2'b01 && MSize32 == 1'b1))) ||
                (HBurstRegCo != `WRAP16 && HSizeRegCo == 2'b00 &&
                 MSize32 == 1'b1)))
        begin
          NextBMlenEnd     = 1'b1;
        end
    end
end // p_BMlenComb

// -----------------------------------------------------------------------------
// Chip Select generation logic - combinational process select to activate
// the CS for the appropriate memory bank
// -----------------------------------------------------------------------------
always @(SMCsEnCo or BnkAddStrCo or CSPol or iSMCS or RemapReg)
begin : p_CSgenComb
  NextSMCS         = iSMCS;

  if (SMCsEnCo == 1'b1)
    begin
      case (BnkAddStrCo)
        3'b000 :
          begin
            if (RemapReg == 1'b1)
              begin
                NextSMCS[0]      = CSPol[0];
                NextSMCS[7]      = !(CSPol[7]);
              end
            else
              begin
                NextSMCS[0]      = !(CSPol[0]);
                NextSMCS[7]      = CSPol[7];
              end
            NextSMCS[1]      = !(CSPol[1]);
            NextSMCS[2]      = !(CSPol[2]);
            NextSMCS[3]      = !(CSPol[3]);
            NextSMCS[4]      = !(CSPol[4]);
            NextSMCS[5]      = !(CSPol[5]);
            NextSMCS[6]      = !(CSPol[6]);
          end
        3'b001 :
          begin
            NextSMCS[0]      = !(CSPol[0]);
            NextSMCS[1]      = CSPol[1];
            NextSMCS[2]      = !(CSPol[2]);
            NextSMCS[3]      = !(CSPol[3]);
            NextSMCS[4]      = !(CSPol[4]);
            NextSMCS[5]      = !(CSPol[5]);
            NextSMCS[6]      = !(CSPol[6]);
            NextSMCS[7]      = !(CSPol[7]);
          end
        3'b010 :
            begin
            NextSMCS[0]      = !(CSPol[0]);
            NextSMCS[1]      = !(CSPol[1]);
            NextSMCS[2]      = CSPol[2];
            NextSMCS[3]      = !(CSPol[3]);
            NextSMCS[4]      = !(CSPol[4]);
            NextSMCS[5]      = !(CSPol[5]);
            NextSMCS[6]      = !(CSPol[6]);
            NextSMCS[7]      = !(CSPol[7]);
          end
        3'b011 :
          begin
            NextSMCS[0]      = !(CSPol[0]);
            NextSMCS[1]      = !(CSPol[1]);
            NextSMCS[2]      = !(CSPol[2]);
            NextSMCS[3]      = CSPol[3];
            NextSMCS[4]      = !(CSPol[4]);
            NextSMCS[5]      = !(CSPol[5]);
            NextSMCS[6]      = !(CSPol[6]);
            NextSMCS[7]      = !(CSPol[7]);
          end
        3'b100 :
          begin
            NextSMCS[0]      = !(CSPol[0]);
            NextSMCS[1]      = !(CSPol[1]);
            NextSMCS[2]      = !(CSPol[2]);
            NextSMCS[3]      = !(CSPol[3]);
            NextSMCS[4]      = CSPol[4];
            NextSMCS[5]      = !(CSPol[5]);
            NextSMCS[6]      = !(CSPol[6]);
            NextSMCS[7]      = !(CSPol[7]);
          end
        3'b101 :
          begin
            NextSMCS[0]      = !(CSPol[0]);
            NextSMCS[1]      = !(CSPol[1]);
            NextSMCS[2]      = !(CSPol[2]);
            NextSMCS[3]      = !(CSPol[3]);
            NextSMCS[4]      = !(CSPol[4]);
            NextSMCS[5]      = CSPol[5];
            NextSMCS[6]      = !(CSPol[6]);
            NextSMCS[7]      = !(CSPol[7]);
          end
        3'b110 :
          begin
            NextSMCS[0]      = !(CSPol[0]);
            NextSMCS[1]      = !(CSPol[1]);
            NextSMCS[2]      = !(CSPol[2]);
            NextSMCS[3]      = !(CSPol[3]);
            NextSMCS[4]      = !(CSPol[4]);
            NextSMCS[5]      = !(CSPol[5]);
            NextSMCS[6]      = CSPol[6];
            NextSMCS[7]      = !(CSPol[7]);
          end
        3'b111 :
          begin
            NextSMCS[0]      = !(CSPol[0]);
            NextSMCS[1]      = !(CSPol[1]);
            NextSMCS[2]      = !(CSPol[2]);
            NextSMCS[3]      = !(CSPol[3]);
            NextSMCS[4]      = !(CSPol[4]);
            NextSMCS[5]      = !(CSPol[5]);
            NextSMCS[6]      = !(CSPol[6]);
            NextSMCS[7]      = CSPol[7];
          end
        default : ;
          
        endcase
    end
  else
    begin
      NextSMCS[0]      = !(CSPol[0]);
      NextSMCS[1]      = !(CSPol[1]);
      NextSMCS[2]      = !(CSPol[2]);
      NextSMCS[3]      = !(CSPol[3]);
      NextSMCS[4]      = !(CSPol[4]);
      NextSMCS[5]      = !(CSPol[5]);
      NextSMCS[6]      = !(CSPol[6]);
      NextSMCS[7]      = !(CSPol[7]);
    end

end // p_CSgenComb

// -----------------------------------------------------------------------------
// Generation of the output enable (OEN) signal for the memory devices
//  - combinational logic.
// The SMOEN is enabled or disabled depending on the control signal from
// the TSM module.
// -----------------------------------------------------------------------------
always @(XoutEnCo or XoutDisCo or inSMOEN)
begin : p_OEgenComb
  NextnSMOEN       = inSMOEN;

  if (XoutEnCo == 1'b1)
    begin
      NextnSMOEN       = 1'b0;
    end
  else if (XoutDisCo == 1'b1)
    begin
      NextnSMOEN       = 1'b1;
    end
end // p_OEgenComb

// -----------------------------------------------------------------------------
// Generation of the external data bus byte lane enables SMCDATAEN
//  - combinational logic.
// The SMCDATAEN enables and disables depends on the type of the transfer in
// progress. It is appropriately enabled so as to aid in the re-circulation
// logic.
// -----------------------------------------------------------------------------
always @(inSMCDATAEN or XdatDisCo or RdXdatEnCo or WrXdatEnCo or
         MSize08 or MSize16 or MSize32)
begin : p_DatEnComb
  NextnSMCDATAEN   = inSMCDATAEN;

  if (XdatDisCo == 1'b1)
    begin
      NextnSMCDATAEN   = 4'b1111;
    end
  else if (RdXdatEnCo == 1'b1)
    begin
      if (MSize08 == 1'b1)
        begin
          NextnSMCDATAEN   = 4'b0001;
        end
      else if (MSize16 == 1'b1)
        begin
          NextnSMCDATAEN   = 4'b0011;
        end
      else if (MSize32 == 1'b1)
        begin
          NextnSMCDATAEN   = 4'b1111;
        end
    end
  else if (WrXdatEnCo == 1'b1)
    begin
      NextnSMCDATAEN   = 4'b0000;
    end
end // p_DatEnComb

// -----------------------------------------------------------------------------
// Chip Select, output enables and data enables generation logic
//  - clocked process
// chip select polarities are assumed active low by default.
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_ContgenSeq
  if (HRESETn == 1'b0)
    begin
      iSMCS            <= 8'b11111111;
      inSMOEN          <= 1'b1;
      inSMCDATAEN      <= 4'b1111;
    end
  else
    begin
      iSMCS            <= NextSMCS;
      inSMOEN          <= NextnSMOEN;
      inSMCDATAEN      <= NextnSMCDATAEN;
    end
end // p_ContgenSeq

// -----------------------------------------------------------------------------
// Read in data from the memory device at the end of the read access time. This
// data is then routed to the RdWrBuf
// -----------------------------------------------------------------------------
always @(BIGENDIAN or MSize08 or MSize16 or MSize32 or iSMCADDR or
         CntEnd or SmcState or SMCDATAIN or CntEZEnd)
begin : p_MemRdComb
  TmpRdDat       = 32'h00000000;

  if ((CntEnd == 1'b1 || CntEZEnd == 1'b1) && SmcState == `ST_TSM_MEMRD)
    begin
      if (MSize32 == 1'b1)
        begin
          TmpRdDat[31:0]   = SMCDATAIN[31:0];
        end
      else if (MSize16 == 1'b1)
        begin
          case (iSMCADDR[1])
            1'b1 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    TmpRdDat[31:16]  = SMCDATAIN[15:0];
                  end
                else
                  begin
                    TmpRdDat[15:0]   = SMCDATAIN[15:0];
                  end
              end
            1'b0 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    TmpRdDat[15:0]   = SMCDATAIN[15:0];
                  end
                else
                  begin
                    TmpRdDat[31:16]  = SMCDATAIN[15:0];
                  end
              end
            default : ;
              
            endcase
        end
      else if (MSize08 == 1'b1)
        begin
          case (iSMCADDR[1:0])
            2'b11 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    TmpRdDat[31:24]  = SMCDATAIN[7:0];
                  end
                else
                  begin
                    TmpRdDat[7:0]    = SMCDATAIN[7:0];
                  end
              end
            2'b10 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    TmpRdDat[23:16]  = SMCDATAIN[7:0];
                  end
                else
                  begin
                    TmpRdDat[15:8]   = SMCDATAIN[7:0];
                  end
              end
            2'b01 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    TmpRdDat[15:8]   = SMCDATAIN[7:0];
                  end
                else
                  begin
                    TmpRdDat[23:16]  = SMCDATAIN[7:0];
                  end
              end
            2'b00 :
              begin
                if (BIGENDIAN == 1'b0)
                  begin
                    TmpRdDat[7:0]    = SMCDATAIN[7:0];
                  end
                else
                  begin
                    TmpRdDat[31:24]  = SMCDATAIN[7:0];
                  end
              end
            default : ;
              
            endcase
        end
    end
end // p_MemRdComb

// -----------------------------------------------------------------------------
// Combinational logic for memory write enable and byte lane enables
// -----------------------------------------------------------------------------
always @(ExtWrEnCo or ExtWrDisCo or MSize08 or MSize16 or
         WrBufWrEn or MSize32 or iPosSMWEN or iPosSMBLS or
         RBLE or SMCsEnCo or XoutEnCo or BIGENDIAN or
         iSMCADDR or BufByPassCo)
begin : p_ExtWrGenComb
  NextPosSMWEN     = iPosSMWEN;
  NextPosSMBLS     = iPosSMBLS;

  if (ExtWrDisCo == 1'b1)
    begin
      NextPosSMWEN     = 1'b1;
      if (RBLE == 1'b0)
        begin
          NextPosSMBLS     = 4'b1111;
        end
    end
  else if (ExtWrEnCo == 1'b1)
    begin
      if (RBLE == 1'b1)
        begin
          NextPosSMWEN     = 1'b0;
        end
      else
        begin
          NextPosSMWEN     = 1'b1;
        end
      if (BufByPassCo == 1'b1)
        begin
          if (MSize32 == 1'b1)
            begin
              NextPosSMBLS     = 4'b0000;
            end
          else if (MSize16 == 1'b1)
            begin
              NextPosSMBLS     = 4'b1100;
            end
          else if (MSize08 == 1'b1)
            begin
              NextPosSMBLS     = 4'b1110;
            end
        end
      else
        begin
          if (MSize32 == 1'b1)
            begin
              NextPosSMBLS     = WrBufWrEn;
            end
          else if (MSize16 == 1'b1)
            begin
              case (iSMCADDR[1])
                1'b0 :
                  begin
                    if (BIGENDIAN == 1'b0)
                      begin
                        NextPosSMBLS     = {2'b11, WrBufWrEn[1:0]};
                      end
                    else
                      begin
                        NextPosSMBLS     = {2'b11, WrBufWrEn[3:2]};
                      end
                  end
                1'b1 :
                  begin
                    if (BIGENDIAN == 1'b0)
                      begin
                        NextPosSMBLS     = {2'b11, WrBufWrEn[3:2]};
                      end
                    else
                      begin
                        NextPosSMBLS     = {2'b11, WrBufWrEn[1:0]};
                      end
                  end
                default : ;
                  
                endcase
            end
          else if (MSize08 == 1'b1)
            begin
              NextPosSMBLS     = 4'b1110;
            end
        end
    end
  else if (XoutEnCo == 1'b1 && RBLE == 1'b1)
    begin
      NextPosSMBLS     = 4'b0000;
    end
  else if (SMCsEnCo == 1'b0)
    begin
      NextPosSMBLS     = 4'b1111;
    end

end // p_ExtWrGenComb

// -----------------------------------------------------------------------------
// Sequential/clocked logic for the positive write enable signals
// -----------------------------------------------------------------------------
always @(posedge HCLK or negedge HRESETn)
begin : p_PosWrGenSeq
  if (HRESETn == 1'b0)
    begin
      iPosSMWEN        <= 1'b1;
      iPosSMBLS        <= 4'b1111;
    end
  else
    begin
      iPosSMWEN        <= NextPosSMWEN;
      iPosSMBLS        <= NextPosSMBLS;
  end
end // p_PosWrGenSeq

// -----------------------------------------------------------------------------
// Connecting local copies to the outputs
// -----------------------------------------------------------------------------
assign SMCS             = iSMCS;
assign SMCDATAOUT       = iSMCDATAOUT;
assign MemRdOver        = iMemRdOver;
assign MemRdOverCo      = NextMemRdOver;
assign RdWrBuf          = iRdWrBuf;
assign nSMOEN           = inSMOEN;
assign SMCADDR          = iSMCADDR;
assign nSMCDATAEN       = inSMCDATAEN;
assign BMlenEnd         = iBMlenEnd;
assign MemWrOver        = iMemWrOver;
assign MemWrOverCo      = NextMemWrOver;
assign PosSMWEN         = iPosSMWEN;
assign PosSMBLS         = iPosSMBLS;
assign AhbRdEn          = iAhbRdEn;

endmodule
// --================================== End ==================================--
