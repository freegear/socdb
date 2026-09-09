// --=========================================================================--
// This confidential and proprietary software may be used only as
// authorised by a licensing agreement from ARM Limited
//   (C) COPYRIGHT 2001-2002 ARM Limited
//       ALL RIGHTS RESERVED
// The entire notice above must be reproduced on all authorised
// copies and copies may only be made to the extent permitted
// by a licensing agreement from ARM Limited.
//
// -----------------------------------------------------------------------------
// Version and Release Control Information:
//
// File Name              : MpmcParams.v.rca
// File Revision          : 1.32
//
// Release Information    : PrimeCell(TM)-PL172-r2p3-00rel0
//
// -----------------------------------------------------------------------------
// Purpose :
//           Multiport Memory Controller Parameter definitions and functions
//
// --=========================================================================--

// -----------------------------------------------------------------------------
//
//                             MpmcParams 
//                             ==========
//
// -----------------------------------------------------------------------------
//
// Overview
// ========
//   This file contains the parameters and constants definitions for the
// submodules and some common functions used in the Mpmc.
//
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Constant declarations
// -----------------------------------------------------------------------------

// -----------------------------------------------------------------------------
// Flag to disable the protocol checker during register test.
// -----------------------------------------------------------------------------
`define REGTEST_RUNNING 1'b0

// -----------------------------------------------------------------------------
// Tie-Off values for Revision number to be driven on the inputs of MpmcRevAnd
// -----------------------------------------------------------------------------
`define REVNUMBER 4'b0010

// -----------------------------------------------------------------------------
// The Address offsets for the different register blocks in the MPMC
// -----------------------------------------------------------------------------
`define HADDR_MPMCCOMCNTREG   4'h0
// MPMCControl at offset 0x000

`define HADDR_MPMCDYBLKREG    4'h1
// MPMC Dynamic memory register blocks at offset 0x200

`define HADDR_MPMCSTBLKREG    4'h2
// MPMC Static memory register blocks at offset 0x100

`define HADDR_MPMCCOMTSTIDREG 4'hF
// MPMC Test register at offset 0xF00

`define HADDR_MPMCSTBLK0REG   3'b000
// MPMC Static memory register block for CS0 at offset 0x00

`define HADDR_MPMCSTBLK1REG   3'b001
// MPMC Static memory register block for CS1 at offset 0x20

`define HADDR_MPMCSTBLK2REG   3'b010
// MPMC Static memory register block for CS2 at offset 0x40

`define HADDR_MPMCSTBLK3REG   3'b011
// MPMC Static memory register block for CS3 at offset 0x60

`define HADDR_MPMCDYBLK0REG   3'b000
// MPMC Dynamic memory register block for CS0 at offset 0x00

`define HADDR_MPMCDYBLK1REG   3'b001
// MPMC Dynamic memory register block for CS1 at offset 0x20

`define HADDR_MPMCDYBLK2REG   3'b010
// MPMC Dynamic memory register block for CS2 at offset 0x40

`define HADDR_MPMCDYBLK3REG   3'b011
// MPMC Dynamic memory register block for CS3 at offset 0x60

// -----------------------------------------------------------------------------
// The Address offsets for the MPMC's common registers
// -----------------------------------------------------------------------------
`define HADDR_MPMCCONTROL     6'b000000
// MPMCControl at offset 0x000

`define HADDR_MPMCCONFIG      6'b000010
// MPMCTConfig offset 0x008

`define HADDR_MPMCDYCNTL      6'b001000
// MPMCDyCntl at offset 0x020

`define HADDR_MPMCDYREF       6'b001001
// MPMCDyRef at offset 0x024

`define HADDR_MPMCDYRDCFG     6'b001010
// MPMCDyRdConfig at offset 0x028

`define HADDR_MPMCDYTRP       6'b001100
// MPMCDytRP at offset 0x030

`define HADDR_MPMCDYTRAS      6'b001101
// MPMCDytRAS at offset 0x034

`define HADDR_MPMCDYTSREX     6'b001110
// MPMCDytSREX at offset 0x038

`define HADDR_MPMCDYTAPR      6'b001111
// MPMCDytAPR at offset 0x03C

`define HADDR_MPMCDYTDAL      6'b010000
// MPMCDytDAL at offset 0x040

`define HADDR_MPMCDYTWR       6'b010001
// MPMCDytWR at offset 0x044

`define HADDR_MPMCDYTRC       6'b010010
// MPMCDytRC at offset 0x048

`define HADDR_MPMCDYTRFC      6'b010011
// MPMCDytRFC at offset 0x04C

`define HADDR_MPMCDYTXSR      6'b010100
// MPMCDytXSR at offset 0x050

`define HADDR_MPMCDYTRRD      6'b010101
// MPMCDytRRD at offset 0x054

`define HADDR_MPMCDYTMRD      6'b010110
// MPMCDytMRD at offset 0x058

`define HADDR_MPMCSTEXWT      6'b100000
// MPMCStExWt at offset 0x080

// -----------------------------------------------------------------------------
// The Address offsets for the test registers in the MPMC
// -----------------------------------------------------------------------------
`define HADDR_MPMCTCR         6'b000000
// MPMCITCR at offset 0xF00

`define HADDR_MPMCITIP        6'b001000
// MPMCITIP at offset 0xF20

`define HADDR_MPMCITOP        6'b010000
// MPMCITOP at offset 0xF40

// -----------------------------------------------------------------------------
// The Address offsets for the peripheral id registers in the MPMC
// -----------------------------------------------------------------------------
`define HADDR_MPMCPERIPHID0   6'b111000
// MPMCPERIPHID0 at offset 0xFE0

`define HADDR_MPMCPERIPHID1   6'b111001
// MPMCPeriphId1 at offset 0xFE4

`define HADDR_MPMCPERIPHID2   6'b111010
// MPMCPeriphId2 at offset 0xFE8

`define HADDR_MPMCPERIPHID3   6'b111011
// MPMCPeriphId3 at offset 0xFEC

`define HADDR_MPMCPERIPHID4   6'b110100
// MPMCPERIPHID4 at offset 0xFD0

`define HADDR_MPMCPERIPHID5   6'b110101
// MPMCPeriphId5 at offset 0xFD4

`define HADDR_MPMCPERIPHID6   6'b110110
// MPMCPeriphId6 at offset 0xFD8

`define HADDR_MPMCPERIPHID7   6'b110111
// MPMCPeriphId7 at offset 0xFDC

// -----------------------------------------------------------------------------
// The Address offsets for the primecell id registers in the MPMC
// -----------------------------------------------------------------------------
`define HADDR_MPMCPCELLID0    6'b111100
// MPMCPCellId0 at offset 0xFF0

`define HADDR_MPMCPCELLID1    6'b111101
// MPMCPCellId1 at offset 0xFF4

`define HADDR_MPMCPCELLID2    6'b111110
// MPMCPCellId2 at offset 0xFF8

`define HADDR_MPMCPCELLID3    6'b111111
// MPMCPCellId3 at offset 0xFFC

// -----------------------------------------------------------------------------
// The Address offsets for the registers in the MPMC's Dynamic Memory controller
// -----------------------------------------------------------------------------
`define HADDR_MPMCDYCONFIG    1'b0
// MPMCDyConfig at offset 0x0

`define HADDR_MPMCDYRASCAS    1'b1
// MPMCDyRasCas at offset 0x4

// -----------------------------------------------------------------------------
// The Address offsets for the registers in the MPMC's Static Memory controller
// -----------------------------------------------------------------------------
`define HADDR_MPMCSTCONFIG    3'b000
// MPMCStConfig at offset 0x00

`define HADDR_MPMCSTWTWEN     3'b001
// MPMCStWtWen at offset 0x04

`define HADDR_MPMCSTWTOEN     3'b010
// MPMCStWrOen at offset 0x08

`define HADDR_MPMCSTWTRD      3'b011
// MPMCStWtRd at offset 0x0C

`define HADDR_MPMCSTWTPG      3'b100
// MPMCStWtPg at offset 0x10

`define HADDR_MPMCSTWTWR      3'b101
// MPMCStWtWr at offset 0x14

`define HADDR_MPMCSTWTTURN    3'b110
// MPMCStWtTurn at offset 0x18

// -----------------------------------------------------------------------------
// Peripheral Identification register values
// -----------------------------------------------------------------------------
`define PERIPHID0             8'h72
// Peripheral identification register 0

`define PERIPHID1             8'h11
// Peripheral identification register 1

`define PERIPHID2             4'h4
// LS 4 bits of Peripheral identification register 2 indicate the designer code

`define PERIPHID3             8'h07
// Peripheral identification register 3

`define PERIPHID4             8'h33
// Peripheral identification register 4

`define PERIPHID5             8'h00
// Peripheral identification register 5

`define PERIPHID6             8'h00
// Peripheral identification register 6

`define PERIPHID7             8'h00
// Peripheral identification register 7

// -----------------------------------------------------------------------------
// PrimeCell Identification register values
// -----------------------------------------------------------------------------
`define PCELLID0              8'h0D
// PrimeCell identification register 0

`define PCELLID1              8'hF0
// PrimeCell identification register 1

`define PCELLID2              8'h05
// PrimeCell identification register 2

`define PCELLID3              8'hB1
// PrimeCell identification register 3

// -----------------------------------------------------------------------------
// Definitions for different AHB HTRANS transactions
// -----------------------------------------------------------------------------
`define HTRANS_IDLE           2'b00
// Idle transfers on the AHB

`define HTRANS_NSEQ           2'b10
// NSEQ transfer on the AHB

`define HTRANS_SEQ            2'b11
// SEQ transfer on AHB

// -----------------------------------------------------------------------------
// Definitions for different AHB HBURST transactions
// -----------------------------------------------------------------------------
`define HBURST_SNGLE          3'b000
// Single transfer

`define HBURST_INCR           3'b001
// Undefined incrementing burst

`define HBURST_WRAP4          3'b010
// Commited burst of 4 with wrap transfers

`define HBURST_INCR4          3'b011
// Commited burst of 4 with incrementing transfers

`define HBURST_WRAP8          3'b100
// Commited burst of 8 with wrap transfers

`define HBURST_INCR8          3'b101
// Commited burst of 8 with incrementing ransfers

`define HBURST_WRAP16         3'b110
// Commited burst of 16 with wrap transfers

`define HBURST_INCR16         3'b111
// Commited burst of 16 with incrementing transfers

// -----------------------------------------------------------------------------
// Definitions for different AHB HSIZE transactions
// -----------------------------------------------------------------------------
`define HSIZE_BYTE            2'b00
// Byte size

`define HSIZE_HALF            2'b01
// Halfword size

`define HSIZE_WORD            2'b10
// Word size

// -----------------------------------------------------------------------------
// Definitions for different AHB HRESP responses
// -----------------------------------------------------------------------------
`define HRESP_OKAY             2'b00
// Okay response

`define HRESP_ERROR            2'b01
// Error response

`define HRESP_RETRY            2'b10
// Retry response

`define HRESP_SPLIT            2'b11
// Split response

// -----------------------------------------------------------------------------
// Static Memory Transfer Control State machine's state definition constants.
// -----------------------------------------------------------------------------
`define ST_TSM_IDLE           9'b000000001
// Idle State

`define ST_TSM_BUFWR          9'b000000010
// Internal Buffer Write State

`define ST_TSM_WENCNT         9'b000000100
// Write Enable Count State

`define ST_TSM_MEMWR          9'b000001000
// Memory Write State

`define ST_TSM_SEQWR          9'b000010000
// Sequential Write State

`define ST_TSM_TURNARND       9'b000100000
// Turn Around State

`define ST_TSM_OENCNT         9'b001000000
// Output Enable Count State

`define ST_TSM_MEMRD          9'b010000000
// Memory Read State

`define ST_TSM_AHBRD          9'b100000000
// AHB Bus Read State

// -----------------------------------------------------------------------------
// State machine indexes for Static Memory Transfer Control State machine.
// -----------------------------------------------------------------------------
`define STIDLE                0
// Index for Idle state

`define STBUFWR               1
// Index for Internal Buffer Write State

`define STWENCNT              2
// Index for Write Enable Count State

`define STMEMWR               3
// Index for Memory Write State

`define STSEQWR               4
// Index for Sequential Write State

`define STTURNARND            5
// Index for Turn Around State

`define STOENCNT              6
// Index for Output Enable Count State

`define STMEMRD               7
// Index for Memory Read State

`define STAHBRD               8
// Index for AHB Bus Read State

// -----------------------------------------------------------------------------
// State encoding of the static memory access time count state machine
// -----------------------------------------------------------------------------
`define ST_TW_IDLE            1'b0
// Idle state

`define ST_TW_CNT             1'b1
// Access time count state

// -----------------------------------------------------------------------------
// State encoding of the static memory output enable / write enable time count
// state machine
// -----------------------------------------------------------------------------
`define ST_OEWE_IDLE          1'b0
// Idle state

`define ST_OEWE_CNT           1'b1
// Output enable / Write enable count state

// -----------------------------------------------------------------------------
// State encoding of the data-access-state-machines.
// -----------------------------------------------------------------------------
`define ST_DY_IDLE            9'b000000001
// Idle state

`define ST_DY_CLKON           9'b000000010
// Clock switch-on state

`define ST_DY_SEL             9'b000000100
// Selected state

`define ST_DY_PRE             9'b000001000
// Precharge state

`define ST_DY_ACT             9'b000010000
// Active state

`define ST_DY_RDISSUE         9'b000100000
// Read-command-issue-state

`define ST_DY_DATAFTCH        9'b001000000
// Read-data-fetch state

`define ST_DY_WR              9'b010000000
// Write state

`define ST_DY_DQMLOW          9'b100000000
// Data-Mask-Low state

// -----------------------------------------------------------------------------
// State machine indexes data-access-state-machines.
// -----------------------------------------------------------------------------
`define IDLEDY                0
// Index for Idle state

`define CLKON                 1
// Index for Clock switch-on state

`define SEL                   2
// Index for Selected state

`define PRE                   3
// Index for Precharge state

`define ACT                   4
// Index for Active state

`define RDISSUE               5
// Index for Read-command-issue-state

`define DATAFTCH              6
// Index for Read-data-fetch state

`define WR                    7
// Index for Write state

`define DQMLOW                8
// Index for DQM low state

// -----------------------------------------------------------------------------
// State encoding of the flash-command executing state-machine.
// -----------------------------------------------------------------------------
`define ST_DYF_IDLE           8'h01
// Idle state

`define ST_DYF_CLKON          8'h02
// Clock On state

`define ST_DYF_SEL            8'h04
// Selected state

`define ST_DYF_LCR            8'h08
// Load-command-register state

`define ST_DYF_ACT            8'h10
// Active state

`define ST_DYF_WR             8'h20
// Write state

`define ST_DYF_RD             8'h40
// Read state

`define ST_DYF_WAIT           8'h80
// Wait state for maintaining separation between DyUseMem and DyBufFull

// -----------------------------------------------------------------------------
// State machine indexes for the flash-command executing state-machine.
// -----------------------------------------------------------------------------
`define FIDLE                 0
// Index for IDLE state

`define FCLKON                1
// Index for CLKOn state

`define FSEL                  2
// Index for selected-state

`define FLCR                  3
// Index for LCR state

`define FACT                  4
// Index for ACT state

`define FWR                   5
// Index for WR state

`define FRD                   6
// Index for RD state

`define FWAIT                 7
// Index for wait state

// -----------------------------------------------------------------------------
// 4-bit SDRAM command signal.
// Bit[3]=nCS Bit[2]=nRAS Bit[1]=nCAS Bit[0]=nWE
// -----------------------------------------------------------------------------
`define CMD_ACTIVE            4'b0011
// Active command

`define CMD_READ              4'b0101
// Read command

`define CMD_WRITE             4'b0100
// Write command

`define CMD_PRECHARGE         4'b0010
// Precharge command

`define CMD_LCR               4'b0001
// Load command register command

// -----------------------------------------------------------------------------
// The 7-bit command lines
// Bits[6:3]=nCS[3:0] Bit[2]=nRAS Bit[1]=nCAS Bit[0]=nWE
// -----------------------------------------------------------------------------
`define CMD_PALL              7'b0000010
// Precharge All command

`define CMD_INHIBIT           7'b1111111
// Inhibit command

`define CMD_NOP               7'b0000111
// NOP command

`define CMD_MRS               3'b000
// Mode Register command

// -----------------------------------------------------------------------------
// The 3-bit command lines
// Bit[2]=nRAS Bit[1]=nCAS Bit[0]=nWE
// -----------------------------------------------------------------------------
`define CMD_REF               3'b001
// Self or AutoRefresh command

// -----------------------------------------------------------------------------
// Constant for Logic '0'
// -----------------------------------------------------------------------------
`define LOGIC_ZERO            1'b0
// Constant value used in the TIC interface

// -----------------------------------------------------------------------------
// State encoding of the Refresh State Machine
// -----------------------------------------------------------------------------
`define ST_REF_IDLE            9'b000000001
// Idle state

`define ST_REF_REQ             9'b000000010
// Bus Request State

`define ST_REF_CKEON           9'b000000100
// Turn CKEON if not on

`define ST_REF_PALL            9'b000001000
// Precharge ALL state

`define ST_REF_WPALL           9'b000010000
// Wait for PALL to complete  state

`define ST_REF_REFRESH         9'b000100000
// REFRESH command issue

`define ST_REF_WREFRESH        9'b001000000
// Wait for refresh to complete state

`define ST_REF_WSREFLOW        9'b010000000
// Wait for SRefReq to go low

`define ST_REF_WSREFEXIT       9'b100000000
// Wait for refresh timeout to complete

// -----------------------------------------------------------------------------
// State machine indexes for Refresh State Machine
// -----------------------------------------------------------------------------
`define IDLEREF                0
// Index for Idle state

`define REQREF                 1
// Index for Request state

`define CKEONREF               2
// Index for Clock switch-on state

`define PALLREF                3
// Index for Precharge All state

`define WPALLREF               4
// Index for Wait for PALL to complete state

`define REFRESHREF             5
// Index for Refresh-command-issue-state

`define WREFRESHREF            6
// Index for Wait for Refresh to Complete state

`define WSREFLOWREF            7
// Index for Wait for SRefreq to go low

`define WSREFEXITREF           8
// Index for Wait for Refresh timeout to complete

// -----------------------------------------------------------------------------
// State encoding of the MODE State Machine
// -----------------------------------------------------------------------------
`define ST_MOD_IDLE            9'b000000001
// Idle state

`define ST_MOD_NOP             9'b000000010
// Nop state

`define ST_MOD_PALL            9'b000000100
// Precharge ALL state

`define ST_MOD_WPALL           9'b000001000
// Wait for PALL to complete  state

`define ST_MOD_MODE            9'b000010000
// MODE command issue

`define ST_MOD_MRSREADY        9'b000100000
// MRSREADY State

`define ST_MOD_MRS             9'b001000000
// MRS issue state

`define ST_MOD_MRSWAIT         9'b010000000
// MRS wait state

`define ST_MOD_CKECKON         9'b100000000
// MRS wait state

// -----------------------------------------------------------------------------
// State machine indexes for MODE State Machine
// -----------------------------------------------------------------------------
`define IDLEMOD                0
// Index for Idle state

`define NOPMOD                 1
// Index for Idle state

`define PALLMOD                2
// Index for Precharge All state

`define WPALLMOD               3
// Index for Wait for PALL to complete state

`define MODEMOD                4
// Index for MODE-command-issue-state

`define MRSREADYMOD            5
// Index for MRSREADY state

`define MRSMOD                 6
// Index for MRS State

`define MRSWAITMOD             7
// Index for MRS State

`define CKECKONMOD             8
// Index for MRS State

// -----------------------------------------------------------------------------
// Dynamic Control Register Sdram Initialisation bit values
// -----------------------------------------------------------------------------
`define NORMALISSUE            2'b00
// Change to Normal mode

`define MODISSUE               2'b01
// Issue Mode command

`define PALISSUE               2'b10
// Issue Precharge all command

`define NOPISSUE               2'b11
// Issue NOP

// -----------------------------------------------------------------------------
// State encoding for the memory bus granting state machine
// -----------------------------------------------------------------------------
`define ST_GNT_DMC            2'b01
// Grant state for the Dynamic memory controller

`define ST_GNT_SMC            2'b10
// Grant state for the Static memory controller

// -----------------------------------------------------------------------------
// State machine index for the memory bus granting State machine
// -----------------------------------------------------------------------------
`define GNTDMC                0
// Grant state for Dynamic memory controller

`define GNTSMC                1
// Grant state for Static memory controller

// -----------------------------------------------------------------------------
// State encoding of the granted state machine in the MPMC's TIC
// -----------------------------------------------------------------------------
`define ST_G_NOTGRANT         2'b00
// State to indicate that TIC has not been granted the AHB

`define ST_G_GAINGRANT        2'b01
// State to indicate that TIC has just got the AHB grant

`define ST_G_GRANT            2'b11
// State to indicated that TIC has been granted the AHB

`define ST_G_LOSEGRANT        2'b10
// State to indicate that TIC is losing the AHB grant

// -----------------------------------------------------------------------------
// State encoding of the MpmcTIC vector state machine
// -----------------------------------------------------------------------------
`define ST_V_IDLE             3'b000
// Idle state

`define ST_V_START            3'b001
// Start state

`define ST_V_ADDRVEC          3'b010
// Address state

`define ST_V_WRITEVEC         3'b011
// Write state

`define ST_V_READVEC          3'b100
// Read state

`define ST_V_LASTREAD         3'b101
// Last read state

`define ST_V_TURNAROUND       3'b110
// Turnaround state

// -----------------------------------------------------------------------------
// Memory-type `define declarations.
// -----------------------------------------------------------------------------
`define MEMTYPE_SYNCFLASH     2'b10
// Memory-Device bits in MpmcDyConfig[3:0] registers indicating syncflash

`define MEMTYPE_LOWPOWER      2'b01
// Memory-Device bits in MpmcDyConfig[3:0] registers indicating low-power-sdram

// -----------------------------------------------------------------------------
// Command code declarations for the SyncFlash command set.
// These commands are not the normal array read commands, but the special
// operations required for flash programming.
// -----------------------------------------------------------------------------
`define COMCODE_RDC           8'h90
// Read device configuration of SyncFlash device

`define COMCODE_RSR           8'h70
// Read status register of SyncFlash device

`define COMCODE_CSR           8'h50
// Clear status register of SyncFlash device

`define COMCODE_PSP           8'h40
// Program-setup of SyncFlash device

// -----------------------------------------------------------------------------
// Constant describing the clock-scheme
// -----------------------------------------------------------------------------
`define CLKSCHEME_CLKDEL      2'b00
// Clock delayed mode of operation

// -----------------------------------------------------------------------------
// Buffer and buffer control block constants declaration
// -----------------------------------------------------------------------------
`define FRSTWORDACC      2'b00
// Access from AHB with A3A2 00

`define SCNDWORDACC      2'b01
// Access from AHB with A3A2 01

`define THRDWORDACC      2'b10
// Access from AHB with A3A2 10

`define STAGE3LRUINIT    2'b11
// Initialization values for the 3rd stage of LRU Logic

`define STAGE2LRUINIT    2'b10
// Initialization values for the 2nd stage of LRU Logic

`define STAGE1LRUINIT    2'b01
// Initialization values for the 1st stage of LRU Logic

`define STAGE0LRUINIT    2'b00
// Initialization values for the oth stage of LRU Logic

// -----------------------------------------------------------------------------
// Declaration for RAS/CAS address mapping
// E32 - External 32 Bit memory, Bit Position 6 = 1
// E16 - External 16 Bit Memory, Bit Position 6 = 0
// RB  - RBC type Memory Device, Bit Position 5 = 0
// BR  - BRC type Memory Device, Bit Position 5 = 1
// 016 - 16 M capacity  Device, Bit Position(4-2) = 000
// 064 - 64 M capacity  Device, Bit Position(4-2) = 001
// 128 - 128 M capacity Device, Bit Position(4-2) = 010
// 256 - 256 M capacity Device, Bit Position(4-2) = 011
// 512 - 512 M capacity Device, Bit Position(4-2) = 100
// 08Bit-Made up by 8Bit Device, Bit Position(1-0) = 00
// 16Bit-Made up by 8Bit Device, Bit Position(1-0) = 01
// 32Bit-Made up by 8Bit Device, Bit Position(1-0) = 10
// -----------------------------------------------------------------------------
`define E32RB016MB08BIT  7'b1000000

`define E32RB016MB16BIT  7'b1000001

`define E32RB064MB08BIT  7'b1000100

`define E32RB064MB16BIT  7'b1000101

`define E32RB064MB32BIT  7'b1000110

`define E32RB128MB08BIT  7'b1001000

`define E32RB128MB16BIT  7'b1001001

`define E32RB128MB32BIT  7'b1001010

`define E32RB256MB08BIT  7'b1001100

`define E32RB256MB16BIT  7'b1001101

`define E32RB256MB32BIT  7'b1001110

`define E32RB512MB08BIT  7'b1010000

`define E32RB512MB16BIT  7'b1010001

`define E32BR016MB08BIT  7'b1100000

`define E32BR016MB16BIT  7'b1100001

`define E32BR064MB08BIT  7'b1100100

`define E32BR064MB16BIT  7'b1100101

`define E32BR064MB32BIT  7'b1100110

`define E32BR128MB08BIT  7'b1101000

`define E32BR128MB16BIT  7'b1101001

`define E32BR128MB32BIT  7'b1101010

`define E32BR256MB08BIT  7'b1101100

`define E32BR256MB16BIT  7'b1101101

`define E32BR256MB32BIT  7'b1101110

`define E32BR512MB08BIT  7'b1110000

`define E32BR512MB16BIT  7'b1110001

`define E16RB016MB08BIT  7'b0000000

`define E16RB016MB16BIT  7'b0000001

`define E16RB064MB08BIT  7'b0000100

`define E16RB064MB16BIT  7'b0000101

`define E16RB128MB08BIT  7'b0001000

`define E16RB128MB16BIT  7'b0001001

`define E16RB256MB08BIT  7'b0001100

`define E16RB256MB16BIT  7'b0001101

`define E16RB512MB08BIT  7'b0010000

`define E16RB512MB16BIT  7'b0010001

`define E16BR016MB08BIT  7'b0100000

`define E16BR016MB16BIT  7'b0100001

`define E16BR064MB08BIT  7'b0100100

`define E16BR064MB16BIT  7'b0100101

`define E16BR128MB08BIT  7'b0101000

`define E16BR128MB16BIT  7'b0101001

`define E16BR256MB08BIT  7'b0101100

`define E16BR256MB16BIT  7'b0101101

`define E16BR512MB08BIT  7'b0110000

`define E16BR512MB16BIT  7'b0110001

// -----------------------------------------------------------------------------
// Chip Select Identification
// -----------------------------------------------------------------------------
`define CHIPSELECT0      8'b00000001

`define CHIPSELECT1      8'b00000010

`define CHIPSELECT2      8'b00000100

`define CHIPSELECT3      8'b00001000

`define CHIPSELECT4      8'b00010000

`define CHIPSELECT5      8'b00100000

`define CHIPSELECT6      8'b01000000

`define CHIPSELECT7      8'b10000000

// -----------------------------------------------------------------------------
// Boolean constants
// -----------------------------------------------------------------------------
`define TRUE             1'b1
`define FALSE            1'b0

// --================================ BODY ===================================--

// -----------------------------------------------------------------------------
// The IfEqual function gets the number of bits to be compared from NumOfRowBits
// field and compares the lower order bits of the Operands. The output is a
// boolean value indicating whether the operators are equal or not.
// In PL172, this function is used for finding the equality between the address
// of the current row accessed and the last active row accessed in the bank
// -----------------------------------------------------------------------------
 function IfEqual;
   input [12:0]    LHSOp;
   input [12:0]    RHSOp;
   input [1:0]     NumOfRowBits;
 begin
   case (NumOfRowBits)
     // A value of "00" indicates that the row address is 11 bit wide.
     2'b00 :
       if (LHSOp[10:0] == RHSOp[10:0])
         begin
           IfEqual = `TRUE;
         end
       else
         begin
           IfEqual = `FALSE;
         end
     // A value of "01" indicates that the row address is 12 bit wide.
     2'b01 :
       if (LHSOp[11:0] == RHSOp[11:0])
         begin
           IfEqual = `TRUE;
         end
       else
         begin
           IfEqual = `FALSE;
         end
     // A value of "10" indicates that the row address is 13 bit wide.
     default :
       if (LHSOp[12:0] == RHSOp[12:0])
         begin
           IfEqual = `TRUE;
         end
       else
         begin
           IfEqual = `FALSE;
         end
   endcase
 end
 endfunction

// --================================== End ==================================--
