// --=================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// ---------------------------------------------------------------------
// Version and Release Control Information:
// 
// File Name              : AaciTrMainCntl.v.rca
// File Revision          : 1.3
//
// Release Information    : PrimeCell(TM)-PL041-REL1v0
//
// ---------------------------------------------------------------------
// Purpose :
//           This block consists of the main Transmit/Receive control 
//           Logic and the main state machine which tracks the different
//           slot data's.
//
// --=================================================================--

`timescale 1ns/1ps

`include   "AaciTrPackage.v"
 
// ---------------------------------------------------------------------
 
module AaciTrMainCntl ( 
// Inputs
                       BITCLKIn,
                       nAACIBITCLKRST,
                       AACITrEnBSync,
                       TxEnSync,
                       RxEnSync,
                       BtClkESync,
                       WintGenSync,
                       AACISYNC,
                       AACISDATAIN,
                       TxFRdDataIn,
                       AACITrBtClkPrd,
// Outputs
                       TxFRdPtrInc,
                       RxFWr,
                       AACISDATAOUT,
                       RxFWrData,
                       SlotState     
                      );

// Inputs
input         nAACIBITCLKRST;   // APB Reset
input         BITCLKIn;         // Serial bit clock
input         AACITrEnBSync;    // AACI trickbox enable syns to
                                // BITCLKIn
input         TxEnSync;         // Transmit Enable
input         RxEnSync;         // Receive Enable
input         BtClkESync;       // Serial bit clock enable
input         WintGenSync;      // Serial data bit for wake up Intr
input         AACISYNC;         // Serial synchronising clock
input         AACISDATAIN;      // Serial transmit input
input  [19:0] TxFRdDataIn;      // Transmitter data to transmit
input  [15:0] AACITrBtClkPrd;   // Period of the clock generated
                                // in the trickbox
// Outputs
output        TxFRdPtrInc;      // Tx FIFO read ptr incr.
output        RxFWr;            // Rx FIFO write enable
output        AACISDATAOUT;     // Serial transmit output
output [19:0] RxFWrData;        // Rx FIFO write data
output  [3:0] SlotState;        // Slot number state

// Inputs
wire          nAACIBITCLKRST;   // APB Reset
wire          BITCLKIn;         // Serial bit clock
wire          AACITrEnBSync;    // AACI trickbox enable syns to BITCLKIn
wire          TxEnSync;         // Transmit Enable
wire          RxEnSync;         // Receive Enable
wire          BtClkESync;       // Serial bit clock enable
wire          WintGenSync;      // Serial data bit for wake up Intr
wire          AACISYNC;         // Serial synchronising clock
wire          AACISDATAIN;      // Serial transmit input
wire   [19:0] TxFRdDataIn;      // Transmitter data to transmit
wire   [15:0] AACITrBtClkPrd;   // Period of the clock generated
 
// Outputs
wire          TxFRdPtrInc;      // Tx FIFO read ptr incr
wire          RxFWr;            // Rx FIFO write enable
wire          AACISDATAOUT;     // Serial transmit output
wire   [19:0] RxFWrData;        // Rx FIFO write data
wire    [3:0] SlotState;        // Slot number state

// ---------------------------------------------------------------------
//
//                           AaciTrMainCntl
//                           ==============
//
// ---------------------------------------------------------------------
// Overview
// ========
//
//  This block constitutes the main transmit / receive control logic in
// the AACITrickbox.
//   Transmit data is first loaded into a 20-bit temporary transmit
// register. Depending on the state machine state this is loaded in to
// the Transmit Shift Register at the start of the slot and bits are
// shifted out onto the AACISDATAOUT o/p line (MSBit first). The
// shifting is done on every positive edge of the BITCLK.
// Each entry into the FIFO is slot data. As the slot data maximum width
// is 20 bits, the FIFO data width size is the 20 bit. The test code has
// to left justify the data for the tag slot by four bits. Similarly
// for the different TSIZE in the AACI TXCR registers test code has to
// ensure that the data is left justified correctly according to TSIZE
// given below
//    T S I Z E      L E F T J U S T I F I C A T I O N
//     18 bits              2 bits
//     16 bits              4 bits
//     12 bits              8 bits
//     20 bits              0 bits
//   Receive data sampled on the AACISDATAIN input is shifted into an
// internal shift register and when a complete slot is received,
// received data is loaded in to the the receive buffer before being
// loaded to the FIFO. The FIFO data width for the recieve FIFO is also
// 20 bits as the every slot data is 20 bits except the tag slot
// data(which is 16 bit). For the tag slot the 16 bit data is appended
// with 4 zeros to make it valid 20 bit data. So the software should
// look into the only lower 16 bits for the tag slot.
//
// The description of the Main state machine is given at the begining of
// the state machine
//
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
//  Constant declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
//  Wire declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
// Register declarations
// ---------------------------------------------------------------------
reg  [3:0] iSlotState;
// Main State machine states. These changes through different states
// as the AC link slot states from slot 0 to slot 12 

reg  [4:0] BitCount;
// The counter to count the number of the bit in the slot in the frame
// This is to keep the track of the activity on the AC link

reg        iTxFRdPtrInc;
// Internal TxFIFO read Pointer increment signal 
// This signal communicate with the transmit FIFO control logic

reg        iRxFWr;
// Internal RxFIFO Write wire 

reg [19:0] TxShft;
// Transmit Shift register 

reg [19:0] RxShft;
// receive Shift register 

reg [19:0] TempRxReg;
// Temporary receive Shift register to store the intermediate receive 
// shift register data

reg        IntSYNC;
// Internal version of AACISYNC signal sampled on the falling edge of
// BITCLK

reg        IntRxEnSync;
// Internal version of RxEn signal sampled on the falling edge of BITCLK
// at the start of the frame

reg        IntTxEnSync;
// Internal version of TxEn signal sampled on the falling edge of BITCLK
// at the start of the frame

reg        SDATAToggle;
// Toggling signal for SDATOUT for set up and hold time checking

wire       IntAACISDATAIN;
// Internal AACISDATAIN used as the serial input of the Rx shift reg

// ---------------------------------------------------------------------
// Parameter declarations
// ---------------------------------------------------------------------

// ---------------------------------------------------------------------
//
// Main body of code
// =================
//
// ---------------------------------------------------------------------

// --------------------------------------------------------------------
// Local signal assignments
// ---------------------------------------------------------------------
assign TxFRdPtrInc      = iTxFRdPtrInc;
assign RxFWr            = iRxFWr;
assign RxFWrData        = TempRxReg;
assign SlotState        = iSlotState;

// ---------------------------------------------------------------------
// When AACI is disabled , drives zero on IntAACISDATAIN , otherwise 
// drives AACISDATAIN on IntAACISDATAIN
// ---------------------------------------------------------------------
assign IntAACISDATAIN   = (AACITrEnBSync == 1'b1
                        && IntRxEnSync == 1'b1) ? AACISDATAIN : 1'b0;

// -------------------------------------------------------------------- 
// Assignment of the AACISDATAOUT from the last bit of the transmit
// shift register which is controlled by the main transmit/receive
// control state machine. but in the absense of the BITCLK the 
// AACISDATAIN can be made high by the bit WintGen in the control 
// register of the trickbox.
// --------------------------------------------------------------------
assign AACISDATAOUT     = (AACITrEnBSync === 1'b1
                        & IntTxEnSync === 1'b1) ? ((TxShft[19]
                        & SDATAToggle) | WintGenSync) : 1'b0;

// ---------------------------------------------------------------------
// AACISDATAOUT Toggling signal generation
// ---------------------------------------------------------------------
always @(BITCLKIn)
begin : p_SdataOutTogSeq
  if (BITCLKIn == 1'b1)
    # (AACITrBtClkPrd/2  - (AACITrBtClkPrd * 0.15))
    SDATAToggle <= BITCLKIn;
  else if (BITCLKIn == 1'b0)
    # (AACITrBtClkPrd * 0)
    SDATAToggle <= 1'b0;
end // process p_SdataOutTogSeq;

// -------------------------------------------------------------------- 
// Main Transmission/Reception State machine :
// This state machineoperates on the BITCLK. This block contains the
// main transmission and reception control depending upon the slot state
// at the AC link.
// The machine has 14 states First on reset it goes to the INITIAL
// state. Then it wait for the AACISYNC port of AACI to go high to go to
// SYNC state. This is nothing but the tag slot data transfer phase.
// This is 16 BITCLK wide and then the machine moves through different
// states corresponding to the diffferent slots on the AC link. And at
// the end of the every slot the The data received in the receive shift
// register is loaded in to the Rx FIFO and at the start of the every
// slot the data from the Tx FIFO is loaded in to the Tx shift register.
// The communication between this state machine and the Tx and Rx FIFO
// is through the RxFWr for writing into the Rx FIFO and TxFRdPtrInc for
// reading from the Tx FIFO.
// The RxFWr is asserted at the end of the every slot and TxFRdPtrInc
// is asserted before the start of the slot when the BitCount for the
// previous slot has gone to 9. This ensures that the Tx FIFO data is
// taken in to the buffer before being it is written to the shift Tx
// shift register at the start of the slot.
// The protocol check is also there for the AACISYNC port in the normal
// transmission and reception. This checks for the AACISYNC port to be
// high for 16 BITCLK periods and to be low for 240 clock periods. If 
// not it flags the error messege.
//
// --------------------------------------------------------------------
always @(posedge BITCLKIn or negedge nAACIBITCLKRST
         or negedge AACITrEnBSync or negedge BtClkESync)
begin : p_MainCntrlSeq
  if (nAACIBITCLKRST == 1'b0)
    begin
      BitCount      <= 5'b00000;
      iSlotState    <= `ST_INITIAL;
      iTxFRdPtrInc  <= 1'b0;
      iRxFWr        <= 1'b0;
      TxShft        <= 20'b00000000000000000000;
      TempRxReg     <= 20'b00000000000000000000;
    end
  else if(AACITrEnBSync == 1'b0 | BtClkESync == 1'b0)
    begin
      BitCount      <= 5'b00000;
      iSlotState    <= `ST_INITIAL;
      TxShft        <= 20'b00000000000000000000;
      TempRxReg     <= 20'b00000000000000000000;
    end
  else
    begin
      case (iSlotState)
        `ST_INITIAL :   // Waiting for AACISYNC to go high
          begin
            if (IntSYNC == 1'b1)
              begin
                IntTxEnSync  <= TxEnSync;
                IntRxEnSync  <= RxEnSync;
                BitCount     <= 5'b00000;
                iSlotState   <= `ST_SYNC;
                if (TxEnSync == 1'b1)
                  begin
                    TxShft       <= TxFRdDataIn;
                    iTxFRdPtrInc <= !iTxFRdPtrInc;
                  end
              end
          end

        `ST_SYNC :   // Slot0 data
          begin
            if (IntSYNC == 1'b1 && BitCount != 5'b01111)
              begin
                TxShft[19:1] <= TxShft[18:0]; 
                TxShft[0]    <= 1'b0;
                BitCount     <= BitCount + 1'b1;
              end
            else if (IntSYNC == 1'b0)
              if (BitCount != 5'b01111)
                $display($time,"Error : AACITB1 : The AACISYNC is not",
                                   " high for 16 BITCLK periods \n"); 
              else
                begin
                  iSlotState   <= `ST_SLOT1;
                  BitCount     <= 5'b00000;
                  if (IntTxEnSync == 1'b1)
                    begin
                      TxShft       <= TxFRdDataIn;
                      iTxFRdPtrInc <= !iTxFRdPtrInc;
                    end
                  if (IntRxEnSync == 1'b1)
                    begin
                      TempRxReg    <= {4'b0000, RxShft[15:0]};
                      iRxFWr       <= !iRxFWr;
                    end
                end
          end

        `ST_SLOT1, `ST_SLOT2, `ST_SLOT3, `ST_SLOT4, 
        `ST_SLOT5, `ST_SLOT6, `ST_SLOT7, `ST_SLOT8, 
        `ST_SLOT9, `ST_SLOT10, `ST_SLOT11 :                    
          begin
            if (IntSYNC == 1'b1)
              $display($time,"Error : AACITB2 : The AACISYNC is HIGH ",
                              " for NON-SYNC Region \n");
            else if (BitCount == 5'b10011)
              begin
                BitCount      <= 5'b00000;
                if (IntTxEnSync == 1'b1)
                  begin
                    TxShft        <= TxFRdDataIn;
                    iTxFRdPtrInc  <= !iTxFRdPtrInc;
                  end
                if (IntRxEnSync == 1'b1)
                  begin
                    TempRxReg     <= RxShft;
                    iRxFWr        <= !iRxFWr;
                  end
                case (iSlotState)
                  `ST_SLOT1  :  
                                  iSlotState <= `ST_SLOT2;
                  `ST_SLOT2  : 
                                  iSlotState <= `ST_SLOT3;
                  `ST_SLOT3  : 
                                  iSlotState <= `ST_SLOT4;
                  `ST_SLOT4  : 
                                  iSlotState <= `ST_SLOT5;
                  `ST_SLOT5  : 
                                  iSlotState <= `ST_SLOT6;
                  `ST_SLOT6  : 
                                  iSlotState <= `ST_SLOT7;
                  `ST_SLOT7  : 
                                  iSlotState <= `ST_SLOT8;
                  `ST_SLOT8  : 
                                  iSlotState <= `ST_SLOT9;
                  `ST_SLOT9  : 
                                  iSlotState <= `ST_SLOT10;
                  `ST_SLOT10 : 
                                  iSlotState <= `ST_SLOT11;
                  `ST_SLOT11 : 
                                  iSlotState <= `ST_SLOT12;
                  default    :    ;
                endcase
              end
            else
              begin
                TxShft[19:1] <= TxShft[18:0];
                BitCount     <= BitCount + 1'b1;
                TxShft[0]    <= 1'b0;
              end
          end

        `ST_SLOT12     :  // Slot12 data
          begin
            if (IntSYNC == 1'b1 && BitCount != 5'b10011)
              $display($time,"Error : AACITB3 : The AACISYNC is HIGH ",
                                          " for NON-SYNC Region\n ");
            else if (IntSYNC == 1'b1 && BitCount == 5'b10011)
              begin
                IntTxEnSync  <= TxEnSync;
                IntRxEnSync  <= RxEnSync;
                iSlotState   <= `ST_SYNC;
                BitCount     <= 5'b00000;
                if (TxEnSync == 1'b1)
                  begin
                    TxShft       <= TxFRdDataIn;
                    iTxFRdPtrInc <= !iTxFRdPtrInc;
                  end
                if (IntRxEnSync == 1'b1)
                  begin
                    TempRxReg    <= RxShft;
                    iRxFWr       <= !iRxFWr;
                  end
              end
            else
              begin
                TxShft[19:1] <= TxShft[18:0];
                BitCount     <= BitCount + 1'b1;
                TxShft[0]    <= 1'b0;
              end
          end

        default  : 
          // Error condition
            $display($time,"Error : AACITB4 : Invalid state of the",
                                  " Tx and Rx FIFO Control machine \n");
      endcase
    end
end // process p_MainCntrlSeq;

// ---------------------------------------------------------------------
// Receive Logic capturing the AACISDATAIN on every falling edge of
// AACIBITCLK
// ---------------------------------------------------------------------
always @ (negedge BITCLKIn or negedge nAACIBITCLKRST or
          negedge AACITrEnBSync)
begin : p_RxLogicSeq
  if (nAACIBITCLKRST == 1'b0 | AACITrEnBSync == 1'b0 )
    RxShft <= 20'b0;
  else
    begin 
      RxShft[19:1] <= RxShft[18:0];
      RxShft[0]    <= IntAACISDATAIN;
    end
end // process p_RxLogicSeq;

// ---------------------------------------------------------------------
// To sample the AACISYNC on every falling edge of AACIBITCLK
// ---------------------------------------------------------------------
always @ (negedge BITCLKIn)
begin : p_SyncSampSeq
      IntSYNC    <= AACISYNC;
end // process p_SyncSampSeq;

endmodule

// ============================== End ================================--
