// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2000-2004 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : DmacParams.v.rca
// File Revision          : 1.7
//
// Release Information    : PrimeCell(TM)-PL080-r1p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           DMA controller Parameter definitions
//
// --=========================================================================--

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Peripheral Identification register values
// -----------------------------------------------------------------------------
`define PERIPHID0        8'b10000000
// Peripheral identification register 0

`define PERIPHID1        8'b00010000
// Peripheral identification register 1

`define PERIPHID2        4'b0100
// LS 4 bits of Peripheral identification register 2 indicates the designer code

`define PERIPHID3        8'b00001010
// Peripheral identification register 3

// -----------------------------------------------------------------------------
// PrimeCell Identification register values
// -----------------------------------------------------------------------------
`define PCELLID0         8'b00001101
// PrimeCell identification register 0

`define PCELLID1         8'b11110000
// PrimeCell identification register 1

`define PCELLID2         8'b00000101
// PrimeCell identification register 2

`define PCELLID3         8'b10110001
// PrimeCell identification register 3

// -----------------------------------------------------------------------------
// The ZEROFILL constant is used for concatenating ZEROs to a vector.
// -----------------------------------------------------------------------------
`define ZEROFILL         32'b00000000000000000000000000000000

// -----------------------------------------------------------------------------
// The ONEFILL constant is used for concatenating ONEs to a vector.
// -----------------------------------------------------------------------------
`define ONEFILL          32'b11111111111111111111111111111111

// -----------------------------------------------------------------------------
// Definitions for different AHB HTRANS transactions
// -----------------------------------------------------------------------------
`define HTRANSM_IDLE     2'b00
// Idle transfers on the AHB

`define HTRANSM_BUSY     2'b01
// Busy transfers on the AHB from the master

`define HTRANSM_NSEQ     2'b10
// NSEQ transfer on the AHB

`define HTRANSM_SEQ      2'b11
// SEQ transfer on AHB

// -----------------------------------------------------------------------------
// Definitions for different AHB HBURST from the AHB Master Interface
// -----------------------------------------------------------------------------
`define HBURSTM_SNGLE    3'b000
// Single transfer

`define HBURSTM_UINCR    3'b001
// Undefined incrementing burst

`define HBURSTM_INCR4    3'b011
// Commited burst of 4 with incrementing transfers

`define HBURSTM_INCR8    3'b101
// Commited burst of 8 with incrementing transfers

`define HBURSTM_INCR16   3'b111
// Commited burst of 16 with incrementing transfers

// -----------------------------------------------------------------------------
// Definitions for HPROT[0] line for master
// This line is continuously high as every transfer to/from the master
// is the data transfer and not the opcode.
// -----------------------------------------------------------------------------
`define DATAOROPCODE     1'b1

// -----------------------------------------------------------------------------
// Definitions for HLOCK line for master
// -----------------------------------------------------------------------------
`define UNLOCK           1'b0

// -----------------------------------------------------------------------------
// Definitions for AHB slave responses
// -----------------------------------------------------------------------------
`define HRESP_OKAY       2'b00
// Okay response from the AHB Slave

`define HRESP_ERROR      2'b01
// Error response from the AHB Slave

`define HRESP_RETRY      2'b10
// Retry response from the AHB Slave

`define HRESP_SPLIT      2'b11
// Split response from the AHB Slave

// -----------------------------------------------------------------------------
// State definitions for the AHB Master Interface
// -----------------------------------------------------------------------------
`define ST_MASTER_INITIAL      4'b0001
// Initial state of the Master Interface

`define ST_MASTER_ADDRPHASE    4'b0010
// Address Phase of the data transfer to/from Master Interface

`define ST_MASTER_DATAPHASE    4'b0100
// Data Phase of the data transfer to/from Master Interface

`define ST_MASTER_LOWPRIO_IDLE 4'b1000
// 2nd phase of the data phase in case of the Error response from the AHB Slave

// -----------------------------------------------------------------------------
// State definitions for the Channel State Machines.
// -----------------------------------------------------------------------------
`define ST_SRC_IDLE      5'b00001
// Idle state for the source/destination state machine.

`define ST_SRC_SELECTED  5'b00010
// State indicating that the source transfer is scheduled on AHB

`define ST_SRC_ONBUS     5'b00100
// State indicating that the address corresponding to the transfer is on AHB

`define ST_SRC_DATAXFER  5'b01000
// A correct transition from this state indicates data transfer on AHB

`define ST_SRC_WT4REQLOW 5'b10000
// In this state, the machine waits for request to go low for completing
// handshake

`define ST_DST_IDLE      5'b00001
// Idle state for the source/destination state machine.

`define ST_DST_SELECTED  5'b00010
// State indicating that the destination transfer is scheduled on AHB

`define ST_DST_ONBUS     5'b00100
// State indicating that the address corresponding to the transfer is on AHB

`define ST_DST_DATAXFER  5'b01000
// A correct transition from this state indicates data transfer on AHB

`define ST_DST_WT4REQLOW 5'b10000
// In this state, the machine waits for request to go low for completing
// handshake

`define ST_LLI_IDLE      4'b0001
// Idle state for the LLI-load state machine.

`define ST_LLI_SELECTED  4'b0010
// State indicating that the LLI transfer is scheduled on AHB

`define ST_LLI_ONBUS     4'b0100
// State indicating that the address corresponding to the transfer is on AHB

`define ST_LLI_DATAXFER  4'b1000
// A correct transition from this state indicates data transfer on AHB

// -----------------------------------------------------------------------------
// State definitions for the AHB Slave Interface
// -----------------------------------------------------------------------------
`define ST_SLAVE_SELECTED    1'b1
// DMAC Slave is selected

`define ST_SLAVE_NOTSELECTED 1'b0
// DMAC Slave is not selected

// -----------------------------------------------------------------------------
// Definitions for different size AHB accesses on HSIZE line
// -----------------------------------------------------------------------------
`define BYTE_ACCESS  3'b000
// Byte access on the AHB

`define HWORD_ACCESS 3'b001
// Half-Word access on the AHB

`define WORD_ACCESS  3'b010
// Word access on the AHB

// -----------------------------------------------------------------------------
// The Address defintnitions for the registers in the DMA controller
// -----------------------------------------------------------------------------
`define HADDR_DMACINT         10'b0000000000
// DMACIntStat at offset 0x000

`define HADDR_DMACINTTC       10'b0000000001
// DMACTCIntStat at offset 0x004

`define HADDR_DMACTCCLR       10'b0000000010
// DMACTCIntStat offset 0x008

`define HADDR_DMACINTERR      10'b0000000011
// DMACErrIntStat at offset 0x00C

`define HADDR_DMACERRCLR      10'b0000000100
// DMACErrIntStat at offset 0x010

`define HADDR_DMACRAWINTTC    10'b0000000101
// DMACRawTCInt at offset 0x014

`define HADDR_DMACRAWINTERR   10'b0000000110
// DMACRawErrInt at offset 0x018

`define HADDR_DMACENABLEDCHNS 10'b0000000111
// DMACEnbldChns at offset 0x01C

`define HADDR_DMACSOFTBREQ    10'b0000001000
// DMACSoftBReq at offset 0x020

`define HADDR_DMACSOFTSREQ    10'b0000001001
// DMACSoftSReq at offset 0x024

`define HADDR_DMACSOFTLBREQ   10'b0000001010
// DMACSoftBreq at offset 0x028

`define HADDR_DMACSOFTLSREQ   10'b0000001011
// DMACSoftSReq at offset 0x02C

`define HADDR_DMACCONFIG      10'b0000001100
// DMACConfig at offset 0x030

`define HADDR_DMACSYNC        10'b0000001101
// DMACSync at offset 0x034

`define HADDR_DMACCHANNEL0    7'b0001000
// DMAC Channel 0 at offset 0x100 to 0x11C

`define HADDR_DMACCHANNEL1    7'b0001001
// DMAC Channel 1 at offset 0x120 to 0x13C

`define HADDR_DMACCHANNEL2    7'b0001010
// DMAC Channel 2 at offset 0x140 to 0x15C

`define HADDR_DMACCHANNEL3    7'b0001011
// DMAC Channel 3 at offset 0x160 to 0x17C

`define HADDR_DMACCHANNEL4    7'b0001100
// DMAC Channel 4 at offset 0x180 to 0x19C

`define HADDR_DMACCHANNEL5    7'b0001101
// DMAC Channel 5 at offset 0x1A0 to 0x1BC

`define HADDR_DMACCHANNEL6    7'b0001110
// DMAC Channel 6 at offset 0x1C0 to 0x1DC

`define HADDR_DMACCHANNEL7    7'b0001111
// DMAC Channel 7 at offset 0x1E0 to 0x1FC

`define HADDR_DMACCHSRCADDR   3'b000
// DMACCxSrcAddr [x = Channel Number, 0 to 7] at offset 0x0

`define HADDR_DMACCHDESTADDR  3'b001
// DMACChxDstAddr [x = Channel Number, 0 to 7] at offset 0x1

`define HADDR_DMACCHLLIREG    3'b010
// DMACCxLLIReg [x = Channel Number, 0 to 7] offset 0x2

`define HADDR_DMACCHCONTROL   3'b011
// DMACCxControl [x = Channel Number, 0 to 7] at offset 0x3

`define HADDR_DMACCHCONFIG    3'b100
// DMACCxConfig [x = Channel Number, 0 to 7]HCONFIG at offset 0x4

`define HADDR_DMACTCR         10'b0101000000
// DMATCR at offset 0x500

`define HADDR_DMACITOP1       10'b0101000001
// DMAITOP1 at offset 0x504

`define HADDR_DMACITOP2       10'b0101000010
// DMAITOP2 at offset 0x508

`define HADDR_DMACITOP3       10'b0101000011
// DMAITOP3 at offset 0x50C

`define HADDR_DMACPERIPHID0   10'b1111111000
// DMACPeriphId0 at offset 0xFE4

`define HADDR_DMACPERIPHID1   10'b1111111001
// DMACPeriphId1 at offset 0xFE4

`define HADDR_DMACPERIPHID2   10'b1111111010
// DMACPeriphId2 at offset 0xFE8

`define HADDR_DMACPERIPHID3   10'b1111111011
// DMACPeriphId3 at offset 0xFEC

`define HADDR_DMACPCELLID0    10'b1111111100
// DMACPCellId0 at offset 0xFF0

`define HADDR_DMACPCELLID1    10'b1111111101
// DMACPCellId1 at offset 0xFF4

`define HADDR_DMACPCELLID2    10'b1111111110
// DMACPCellId2 at offset 0xFF8

`define HADDR_DMACPCELLID3    10'b1111111111
// DMACPCellId3 at offset 0xFFC

// -----------------------------------------------------------------------------
// Peripheral burst sizes
// -----------------------------------------------------------------------------
`define BURST1     3'b000
// The burst size of 1 beat

`define BURST4     3'b001
// The burst size of 4 beats

`define BURST8     3'b010
// The burst size of 8 beats

`define BURST16    3'b011
// The burst size of 16 beats

`define BURST32    3'b100
// The burst size of 32 beats

`define BURST64    3'b101
// The burst size of 64 beats

`define BURST128   3'b110
// The burst size of 128 beats

`define BURST256   3'b111
// The burst size of 256 beats

// -----------------------------------------------------------------------------
// Endianness
// -----------------------------------------------------------------------------
`define LITTLE_ENDIAN 1'b0
// Little endian

`define BIG_ENDIAN    1'b1
// Big endian

// -----------------------------------------------------------------------------
// Flow control information.
// -----------------------------------------------------------------------------
`define M2M_DMA          3'b000
`define M2P_DMA          3'b001
`define P2M_DMA          3'b010
`define P2P_DMA          3'b011
`define P2P_DST          3'b100
`define M2P_DST          3'b101
`define P2M_SRC          3'b110
`define P2P_SRC          3'b111

// -----------------------------------------------------------------------------
// Function declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// DecodeBSize function decodes the value of Burst-Size programmed in the SBSize
// or DBSize field of Channel Control Register to its binary value.
// -----------------------------------------------------------------------------
function  [8:0] DecodeBSize;
input [2:0] Code;
begin
  case (Code)
    3'b000 : DecodeBSize = 9'b000000001;
    3'b001 : DecodeBSize = 9'b000000100;
    3'b010 : DecodeBSize = 9'b000001000;
    3'b011 : DecodeBSize = 9'b000010000;
    3'b100 : DecodeBSize = 9'b000100000;
    3'b101 : DecodeBSize = 9'b001000000;
    3'b110 : DecodeBSize = 9'b010000000;
    3'b111 : DecodeBSize = 9'b100000000;
    // Invalid condition
    default : DecodeBSize = 9'b000000000;
  endcase
end
endfunction

// -----------------------------------------------------------------------------
// This function returns the minimum of the two parameters, passed to it as
// argument. It compares between two 14 bit vectors and returns the minimum of
// the two.
// -----------------------------------------------------------------------------
function  [13:0] Minimum14;
input  [13:0] Item1;
input  [13:0] Item2;
begin
 if (Item1 <= Item2)
   Minimum14        = Item1;
 else
   Minimum14        = Item2;
end
endfunction

// -----------------------------------------------------------------------------
// This function returns the minimum of the two parameters, passed to it as
// argument. It compares between two 12 bit vectors and returns the minimum of
// the two.
// -----------------------------------------------------------------------------
function  [11:0] Minimum12;
input  [11:0] Item1;
input  [11:0] Item2;
begin
 if (Item1 <= Item2)
   Minimum12        = Item1;
 else
   Minimum12        = Item2;
end
endfunction

// -----------------------------------------------------------------------------
// This function returns the minimum of the two parameters, passed to it as
// argument. It compares between two 11 bit vectors and returns the minimum of
// the two.
// -----------------------------------------------------------------------------
function  [10:0] Minimum11;
input  [10:0] Item1;
input  [10:0] Item2;
begin
 if (Item1 <= Item2)
   Minimum11        = Item1;
 else
   Minimum11        = Item2;
end
endfunction

// -----------------------------------------------------------------------------
// This function returns the minimum of the two parameters, passed to it as
// argument. It compares between two 9 bit vectors and returns the minimum of
// the two.
// -----------------------------------------------------------------------------
function  [8:0] Minimum9;
input  [8:0] Item1;
input  [8:0] Item2;
begin
 if (Item1 <= Item2)
   Minimum9        = Item1;
 else
   Minimum9        = Item2;
end
endfunction

// -----------------------------------------------------------------------------
// The function does the follwing arithmetic operation :-
// Operand * (DWidth/SWidth).
// For example when DWidth/SWidth = 1/2 and Operand = 6 then Result = 3.
// If (DWidth < SWidth) and (DWidth/SWidth) turns out to be a fraction, then
// one is added to the final result. For example when
// DWidth/SWidth = 1/4 and Operand = 6
// Result = 2 [1 for the quotient and 1 for the remainder].
// The parameter TrgtWidth is the width of the vector to which the result of the
// function will be assigned.
// The restriction on the function is that the width of Operand should be
// greater than the target by 2.
// -----------------------------------------------------------------------------
// function [(TrgtWidth - 1) : 0] DivideFactor;
// input  [2:0] SWidth;
// input  [2:0] DWidth;
// integer      TrgtWidth; 
// input [13:0] Operand;
// endfunction
function [13:0] DivideFactor;
input [2:0] SWidth;
input [2:0] DWidth;
input [13:0] Operand;

reg [5:0] SWidthDWidth;

begin
  SWidthDWidth = {SWidth, DWidth};
  case (SWidthDWidth)
    // if DWidth = SWidth * 2
    6'b000001 :
      // return (2 * Operand) as the Result value
      DivideFactor = {Operand[12 : 0], 1'b0};
    6'b001010 :
      // return (2 * Operand) as the Result value
      DivideFactor = {Operand[12 : 0], 1'b0};
    // if DWidth = SWidth * 4
    6'b000010 :
      // return (4 * Operand) as the Result value
      DivideFactor = {Operand[11 : 0], 2'b00};
    // when DWidth = SWidth / 2
    6'b001000 :
      // Result = Operand/2 + 1 (if remainder is non zero)
      DivideFactor = {1'b0, (Operand[13:1] + Operand[0])};
    6'b010001 :
      // Result = Operand/2 + 1 (if remainder is non zero)
      DivideFactor = {1'b0, (Operand[13:1] + Operand[0])};
    // when DWidth = SWidth / 4
    6'b010000 :
      // Result = Operand/4 + 1 (if remainder is non zero)
      DivideFactor = {2'b0, (Operand[13 : 2] + (Operand[0] | Operand[1]))};
    default :
      DivideFactor = Operand;
  endcase
end
endfunction

// -----------------------------------------------------------------------------
// This function takes the flow-control information as argument and returns
// TRUE if the source is a memory. Otherwise it returns a FALSE indicating that
// source is a peripheral.
// -----------------------------------------------------------------------------
function IsSrcMemory;
input  [2:0] FlowCntl;
begin
  if ((FlowCntl == `M2M_DMA) || (FlowCntl == `M2P_DST) ||
      (FlowCntl == `M2P_DMA))
    IsSrcMemory = 1'b1;
  // the default is considered as peripheral
  else
    IsSrcMemory = 1'b0;
end
endfunction

// -----------------------------------------------------------------------------
// This function takes the flow-control information as argument and returns
// TRUE if the destination is a memory. Otherwise it returns a FALSE indicating
// that destination is a peripheral.
// -----------------------------------------------------------------------------
function IsDstMemory;
input  [2:0] FlowCntl;
begin
  if ((FlowCntl == `M2M_DMA) || (FlowCntl == `P2M_DMA) ||
      (FlowCntl == `P2M_SRC))
    IsDstMemory = 1'b1;
  // the default is considered as peripheral
  else
    IsDstMemory = 1'b0;
end
endfunction

// -----------------------------------------------------------------------------
// This function takes the flow-control information as argument and returns
// TRUE if DMAC is the flow controller.
// -----------------------------------------------------------------------------
function IsDMAFlowCntl;
input  [1:0] FlowCntl;
begin
  if ((FlowCntl == 2'b00) || (FlowCntl == 2'b01))
    IsDMAFlowCntl = 1'b1;
  else
    IsDMAFlowCntl = 1'b0;
end
endfunction

// -----------------------------------------------------------------------------
// This function takes the flow-control information as argument and returns
// TRUE if source is the flow controller.
// -----------------------------------------------------------------------------
function IsSrcFlowCntl;
input  [1:0] FlowCntl;
begin
  if (FlowCntl == 2'b11)
    IsSrcFlowCntl = 1'b1;
  else
    IsSrcFlowCntl = 1'b0;
end
endfunction

// -----------------------------------------------------------------------------
// This function takes the upper two bits of flow-control information as
// argument and returns TRUE if destination is the flow-controller.
// -----------------------------------------------------------------------------
function IsDstFlowCntl;
input  [1:0] FlowCntl;
begin
  if (FlowCntl == 2'b10)
    IsDstFlowCntl = 1'b1;
  else
    IsDstFlowCntl = 1'b0;
end
endfunction

// --==================================== End ================================--
