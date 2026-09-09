//  --========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 1998-2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//  ----------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           : Memory.v,v
//  File Revision       : 1.5
//
//  Release Information : ADK_REL1v1
//
//  ----------------------------------------------------------------------------
//  Purpose             : Static Memory Interface system memory
//                        An off-chip environment which incorporates a static
//                        memory and a BOOT ROM.
//  --========================================================================--
`timescale 1ns/1ps

module Memory (XA, XCSN, XWEN, XOEN, XD);

  input [30:0] XA;   // External address bus
  inout [31:0] XD;   // External data bus
  input  [3:0] XCSN; // External chip enable
  input  [3:0] XWEN; // External write enable
  input        XOEN; // External output enable


//------------------------------------------------------------------------------
// Signal declarations
//------------------------------------------------------------------------------

// Input/Output Signals
  wire [30:0] XA;   // External address bus
  wire [31:0] XD;   // External data bus
  wire  [3:0] XCSN; // External chip enable
  wire  [3:0] XWEN; // External write enable
  wire        XOEN; // External output enable

//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------

//------------------------------------------------------------------------------
// CSN0 - Word-wide Static RAM 1
//------------------------------------------------------------------------------
// This bank of memory mapped at 0x00000000 is loaded with the contents of the
//  specified '.dat' files. The boot code will normally be copied into this RAM
//  as a function of the boot-loader software, prior to the remap process. It
//  is therefore a valid shortcut to specify the ROM initialisation data here.
// Note that in the example system the first 1K of this 128K SRAM bank is 
//  masked by the internal memory in the EASY chip (only after remap).

  ExtRAM uRAM0a (
    .A   (XA[16:2]),
    .DQ  (XD[7:0]),
    .CSn (XCSN[0]),
    .WEn (XWEN[0]),
    .OEn (XOEN)
    );

  ExtRAM uRAM0b (
    .A   (XA[16:2]),
    .DQ  (XD[15:8]),
    .CSn (XCSN[0]),
    .WEn (XWEN[1]),
    .OEn (XOEN)
    );

  ExtRAM uRAM0c (
    .A   (XA[16:2]),
    .DQ  (XD[23:16]),
    .CSn (XCSN[0]),
    .WEn (XWEN[2]),
    .OEn (XOEN)
    );

  ExtRAM uRAM0d (
    .A   (XA[16:2]),
    .DQ  (XD[31:24]),
    .CSn (XCSN[0]),
    .WEn (XWEN[3]),
    .OEn (XOEN)
    );

//------------------------------------------------------------------------------
// CSN1 - Word-wide Static RAM 2
//------------------------------------------------------------------------------
// This bank of RAM is loaded with the contents of the specified '.dat' files.
  
  ExtRAM uRAM1a (
    .A   (XA[16:2]),
    .DQ  (XD[7:0]),
    .CSn (XCSN[1]),
    .WEn (XWEN[0]),
    .OEn (XOEN)
    );

 ExtRAM uRAM1b (
    .A   (XA[16:2]),
    .DQ  (XD[15:8]),
    .CSn (XCSN[1]),
    .WEn (XWEN[1]),
    .OEn (XOEN)
    );

  ExtRAM uRAM1c (
    .A   (XA[16:2]),
    .DQ  (XD[23:16]),
    .CSn (XCSN[1]),
    .WEn (XWEN[2]),
    .OEn (XOEN)
    );

  ExtRAM uRAM1d (
    .A   (XA[16:2]),
    .DQ  (XD[31:24]),
    .CSn (XCSN[1]),
    .WEn (XWEN[3]),
    .OEn (XOEN)
    );

//------------------------------------------------------------------------------
// CSN3 - Word-wide Boot ROM
//------------------------------------------------------------------------------

  ExtROM uBootROM0 (
    .A   (XA[15:2]),
    .Q   (XD[7:0]),
    .CEn (XCSN[3]),
    .OEn (XOEN)
    );

  ExtROM uBootROM1 (
    .A   (XA[15:2]),
    .Q   (XD[15:8]),
    .CEn (XCSN[3]),
    .OEn (XOEN)
    );

  ExtROM uBootROM2 (
    .A   (XA[15:2]),
    .Q   (XD[23:16]),
    .CEn (XCSN[3]),
    .OEn (XOEN)
    );

  ExtROM uBootROM3 (
    .A   (XA[15:2]),
    .Q   (XD[31:24]),
    .CEn (XCSN[3]),
    .OEn (XOEN)
    );
 
//------------------------------------------------------------------------------
// Initialise Boot ROM and RAM with specified hex data files
//------------------------------------------------------------------------------

  initial
  begin
    $readmemh("extram10.dat",uRAM0a.Ram);
    $readmemh("extram11.dat",uRAM0b.Ram);
    $readmemh("extram12.dat",uRAM0c.Ram);
    $readmemh("extram13.dat",uRAM0d.Ram);

    $readmemh("extram20.dat",uRAM1a.Ram);
    $readmemh("extram21.dat",uRAM1b.Ram);
    $readmemh("extram22.dat",uRAM1c.Ram);
    $readmemh("extram23.dat",uRAM1d.Ram);

    $readmemh("rom0.dat",uBootROM0.Rom);
    $readmemh("rom1.dat",uBootROM1.Rom);
    $readmemh("rom2.dat",uBootROM2.Rom);
    $readmemh("rom3.dat",uBootROM3.Rom);
  end


endmodule

// --================================= End ===================================--

