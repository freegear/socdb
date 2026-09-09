//===========================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2001 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//  
//
//-----------------------------------------------------------------------------
//  Version and Release Control Information:
//  
//  File Name           : BusMatrix.v,v
//  File Revision       : 1.2
//  
//  Release Information : BusMatrix-REL1v0
//  
//-----------------------------------------------------------------------------
//  Purpose             : BusMatrix is the top-level which connects together
//                        the required Input Stages, MatrixDecodes, Output Stages
//                        and Output Arbitration blocks.
//                        
//===========================================================================--
`timescale 1ns/1ps

module BusMatrix (

    // Common AHB signals    
    HCLK,
    HRESETn,

    // Input Port 0
    HSELS0,
    HADDRS0,
    HTRANSS0,
    HWRITES0,
    HSIZES0,
    HBURSTS0,
    HPROTS0,
    HWDATAS0,
    HMASTLOCKS0,
    HREADYS0,
    HRDATAS0,
    HREADYOUTS0,
    HRESPS0,
// busswitch input0
                  
    // Input Port 1
    HSELS1,
    HADDRS1,
    HTRANSS1,
    HWRITES1,
    HSIZES1,
    HBURSTS1,
    HPROTS1,
    HWDATAS1,
    HMASTLOCKS1,
    HREADYS1,
    HRDATAS1,
    HREADYOUTS1,
    HRESPS1,
// busswitch input1
                  
    // Input Port 2
    HSELS2,
    HADDRS2,
    HTRANSS2,
    HWRITES2,
    HSIZES2,
    HBURSTS2,
    HPROTS2,
    HWDATAS2,
    HMASTLOCKS2,
    HREADYS2,
    HRDATAS2,
    HREADYOUTS2,
    HRESPS2,
// busswitch input2
                  
    // Input Port 3
    HSELS3,
    HADDRS3,
    HTRANSS3,
    HWRITES3,
    HSIZES3,
    HBURSTS3,
    HPROTS3,
    HWDATAS3,
    HMASTLOCKS3,
    HREADYS3,
    HRDATAS3,
    HREADYOUTS3,
    HRESPS3,
// busswitch input3
                  
    // Input Port 4
    HSELS4,
    HADDRS4,
    HTRANSS4,
    HWRITES4,
    HSIZES4,
    HBURSTS4,
    HPROTS4,
    HWDATAS4,
    HMASTLOCKS4,
    HREADYS4,
    HRDATAS4,
    HREADYOUTS4,
    HRESPS4,
// busswitch input4
                  
    // Input Port 5
    HSELS5,
    HADDRS5,
    HTRANSS5,
    HWRITES5,
    HSIZES5,
    HBURSTS5,
    HPROTS5,
    HWDATAS5,
    HMASTLOCKS5,
    HREADYS5,
    HRDATAS5,
    HREADYOUTS5,
    HRESPS5,
// busswitch input5
                  
    // Input Port 6
    HSELS6,
    HADDRS6,
    HTRANSS6,
    HWRITES6,
    HSIZES6,
    HBURSTS6,
    HPROTS6,
    HWDATAS6,
    HMASTLOCKS6,
    HREADYS6,
    HRDATAS6,
    HREADYOUTS6,
    HRESPS6,
// busswitch input6
                  
    // Input Port 7
    HSELS7,
    HADDRS7,
    HTRANSS7,
    HWRITES7,
    HSIZES7,
    HBURSTS7,
    HPROTS7,
    HWDATAS7,
    HMASTLOCKS7,
    HREADYS7,
    HRDATAS7,
    HREADYOUTS7,
    HRESPS7,
// busswitch input7
                  
    // Output Port 0
    HSELM0,
    HADDRM0,
    HTRANSM0,
    HWRITEM0,
    HSIZEM0,
    HBURSTM0,
    HPROTM0,
    HWDATAM0,
    HMASTLOCKM0,
    HREADYM0,
    HRDATAM0,
    HREADYOUTM0,
    HRESPM0,
// busswitch output0
                  
    // Output Port 1
    HSELM1,
    HADDRM1,
    HTRANSM1,
    HWRITEM1,
    HSIZEM1,
    HBURSTM1,
    HPROTM1,
    HWDATAM1,
    HMASTLOCKM1,
    HREADYM1,
    HRDATAM1,
    HREADYOUTM1,
    HRESPM1,
// busswitch output1
                  
    // Output Port 2
    HSELM2,
    HADDRM2,
    HTRANSM2,
    HWRITEM2,
    HSIZEM2,
    HBURSTM2,
    HPROTM2,
    HWDATAM2,
    HMASTLOCKM2,
    HREADYM2,
    HRDATAM2,
    HREADYOUTM2,
    HRESPM2,
// busswitch output2
                  
    // Output Port 3
    HSELM3,
    HADDRM3,
    HTRANSM3,
    HWRITEM3,
    HSIZEM3,
    HBURSTM3,
    HPROTM3,
    HWDATAM3,
    HMASTLOCKM3,
    HREADYM3,
    HRDATAM3,
    HREADYOUTM3,
    HRESPM3,
// busswitch output3
                  
    // Output Port 4
    HSELM4,
    HADDRM4,
    HTRANSM4,
    HWRITEM4,
    HSIZEM4,
    HBURSTM4,
    HPROTM4,
    HWDATAM4,
    HMASTLOCKM4,
    HREADYM4,
    HRDATAM4,
    HREADYOUTM4,
    HRESPM4,
// busswitch output4
                  
    // Output Port 5
    HSELM5,
    HADDRM5,
    HTRANSM5,
    HWRITEM5,
    HSIZEM5,
    HBURSTM5,
    HPROTM5,
    HWDATAM5,
    HMASTLOCKM5,
    HREADYM5,
    HRDATAM5,
    HREADYOUTM5,
    HRESPM5,
// busswitch output5
                  
    // Output Port 6
    HSELM6,
    HADDRM6,
    HTRANSM6,
    HWRITEM6,
    HSIZEM6,
    HBURSTM6,
    HPROTM6,
    HWDATAM6,
    HMASTLOCKM6,
    HREADYM6,
    HRDATAM6,
    HREADYOUTM6,
    HRESPM6,
// busswitch output6
                  
    // Output Port 7
    HSELM7,
    HADDRM7,
    HTRANSM7,
    HWRITEM7,
    HSIZEM7,
    HBURSTM7,
    HPROTM7,
    HWDATAM7,
    HMASTLOCKM7,
    HREADYM7,
    HRDATAM7,
    HREADYOUTM7,
    HRESPM7,
// busswitch output7
                  
    // Scan test dummy signals; not connected until scan insertion 
    SCANENABLE,   // Scan Test Mode Enbl
    SCANINHCLK,   // Scan Chain Input   
    SCANOUTHCLK   // Scan Chain Output     
    );
  

    input         HCLK;
    input         HRESETn;

    input         HSELS0;
    input  [31:0] HADDRS0;
    input   [1:0] HTRANSS0;
    input         HWRITES0;
    input   [2:0] HSIZES0;
    input   [2:0] HBURSTS0;
    input   [3:0] HPROTS0;
    input  [31:0] HWDATAS0;
    input         HMASTLOCKS0;
    input         HREADYS0;
// busswitch input0

    input         HSELS1;
    input  [31:0] HADDRS1;
    input   [1:0] HTRANSS1;
    input         HWRITES1;
    input   [2:0] HSIZES1;
    input   [2:0] HBURSTS1;
    input   [3:0] HPROTS1;
    input  [31:0] HWDATAS1;
    input         HMASTLOCKS1;
    input         HREADYS1;
// busswitch input1

    input         HSELS2;
    input  [31:0] HADDRS2;
    input   [1:0] HTRANSS2;
    input         HWRITES2;
    input   [2:0] HSIZES2;
    input   [2:0] HBURSTS2;
    input   [3:0] HPROTS2;
    input  [31:0] HWDATAS2;
    input         HMASTLOCKS2;
    input         HREADYS2;
// busswitch input2

    input         HSELS3;
    input  [31:0] HADDRS3;
    input   [1:0] HTRANSS3;
    input         HWRITES3;
    input   [2:0] HSIZES3;
    input   [2:0] HBURSTS3;
    input   [3:0] HPROTS3;
    input  [31:0] HWDATAS3;
    input         HMASTLOCKS3;
    input         HREADYS3;
// busswitch input3

    input         HSELS4;
    input  [31:0] HADDRS4;
    input   [1:0] HTRANSS4;
    input         HWRITES4;
    input   [2:0] HSIZES4;
    input   [2:0] HBURSTS4;
    input   [3:0] HPROTS4;
    input  [31:0] HWDATAS4;
    input         HMASTLOCKS4;
    input         HREADYS4;
// busswitch input4

    input         HSELS5;
    input  [31:0] HADDRS5;
    input   [1:0] HTRANSS5;
    input         HWRITES5;
    input   [2:0] HSIZES5;
    input   [2:0] HBURSTS5;
    input   [3:0] HPROTS5;
    input  [31:0] HWDATAS5;
    input         HMASTLOCKS5;
    input         HREADYS5;
// busswitch input5

    input         HSELS6;
    input  [31:0] HADDRS6;
    input   [1:0] HTRANSS6;
    input         HWRITES6;
    input   [2:0] HSIZES6;
    input   [2:0] HBURSTS6;
    input   [3:0] HPROTS6;
    input  [31:0] HWDATAS6;
    input         HMASTLOCKS6;
    input         HREADYS6;
// busswitch input6

    input         HSELS7;
    input  [31:0] HADDRS7;
    input   [1:0] HTRANSS7;
    input         HWRITES7;
    input   [2:0] HSIZES7;
    input   [2:0] HBURSTS7;
    input   [3:0] HPROTS7;
    input  [31:0] HWDATAS7;
    input         HMASTLOCKS7;
    input         HREADYS7;
// busswitch input7
  
    input  [31:0] HRDATAM0;
    input         HREADYOUTM0;
    input   [1:0] HRESPM0;
// busswitch output0

    input  [31:0] HRDATAM1;
    input         HREADYOUTM1;
    input   [1:0] HRESPM1;
// busswitch output1

    input  [31:0] HRDATAM2;
    input         HREADYOUTM2;
    input   [1:0] HRESPM2;
// busswitch output2
    input  [31:0] HRDATAM3;
    input         HREADYOUTM3;
    input   [1:0] HRESPM3;
// busswitch output3

    input  [31:0] HRDATAM4;
    input         HREADYOUTM4;
    input   [1:0] HRESPM4;
// busswitch output4

    input  [31:0] HRDATAM5;
    input         HREADYOUTM5;
    input   [1:0] HRESPM5;
// busswitch output5

    input  [31:0] HRDATAM6;
    input         HREADYOUTM6;
    input   [1:0] HRESPM6;
// busswitch output6

    input  [31:0] HRDATAM7;
    input         HREADYOUTM7;
    input   [1:0] HRESPM7;
// busswitch output7

    input         SCANENABLE;
    input         SCANINHCLK;


    output [31:0] HRDATAS0;
    output        HREADYOUTS0;
    output  [1:0] HRESPS0;
// busswitch input0

    output [31:0] HRDATAS1;
    output        HREADYOUTS1;
    output  [1:0] HRESPS1;
// busswitch input1

    output [31:0] HRDATAS2;
    output        HREADYOUTS2;
    output  [1:0] HRESPS2;
// busswitch input2

    output [31:0] HRDATAS3;
    output        HREADYOUTS3;
    output  [1:0] HRESPS3;
// busswitch input3

    output [31:0] HRDATAS4;
    output        HREADYOUTS4;
    output  [1:0] HRESPS4;
// busswitch input4

    output [31:0] HRDATAS5;
    output        HREADYOUTS5;
    output  [1:0] HRESPS5;
// busswitch input5 

    output [31:0] HRDATAS6;
    output        HREADYOUTS6;
    output  [1:0] HRESPS6;
// busswitch input6

    output [31:0] HRDATAS7;
    output        HREADYOUTS7;
    output  [1:0] HRESPS7;
// busswitch input7
  
    output        HSELM0;
    output [31:0] HADDRM0;
    output  [1:0] HTRANSM0;
    output        HWRITEM0;
    output  [2:0] HSIZEM0;
    output  [2:0] HBURSTM0;
    output  [3:0] HPROTM0;
    output [31:0] HWDATAM0;
    output        HMASTLOCKM0;
    output        HREADYM0;
// busswitch output0

    output        HSELM1;
    output [31:0] HADDRM1;
    output  [1:0] HTRANSM1;
    output        HWRITEM1;
    output  [2:0] HSIZEM1;
    output  [2:0] HBURSTM1;
    output  [3:0] HPROTM1;
    output [31:0] HWDATAM1;
    output        HMASTLOCKM1;
    output        HREADYM1;
// busswitch output1

    output        HSELM2;
    output [31:0] HADDRM2;
    output  [1:0] HTRANSM2;
    output        HWRITEM2;
    output  [2:0] HSIZEM2;
    output  [2:0] HBURSTM2;
    output  [3:0] HPROTM2;
    output [31:0] HWDATAM2;
    output        HMASTLOCKM2;
    output        HREADYM2;
// busswitch output2

    output        HSELM3;
    output [31:0] HADDRM3;
    output  [1:0] HTRANSM3;
    output        HWRITEM3;
    output  [2:0] HSIZEM3;
    output  [2:0] HBURSTM3;
    output  [3:0] HPROTM3;
    output [31:0] HWDATAM3;
    output        HMASTLOCKM3;
    output        HREADYM3;
// busswitch output3

    output        HSELM4;
    output [31:0] HADDRM4;
    output  [1:0] HTRANSM4;
    output        HWRITEM4;
    output  [2:0] HSIZEM4;
    output  [2:0] HBURSTM4;
    output  [3:0] HPROTM4;
    output [31:0] HWDATAM4;
    output        HMASTLOCKM4;
    output        HREADYM4;
// busswitch output4

    output        HSELM5;
    output [31:0] HADDRM5;
    output  [1:0] HTRANSM5;
    output        HWRITEM5;
    output  [2:0] HSIZEM5;
    output  [2:0] HBURSTM5;
    output  [3:0] HPROTM5;
    output [31:0] HWDATAM5;
    output        HMASTLOCKM5;
    output        HREADYM5;
// busswitch output5

    output        HSELM6;
    output [31:0] HADDRM6;
    output  [1:0] HTRANSM6;
    output        HWRITEM6;
    output  [2:0] HSIZEM6;
    output  [2:0] HBURSTM6;
    output  [3:0] HPROTM6;
    output [31:0] HWDATAM6;
    output        HMASTLOCKM6;
    output        HREADYM6;
// busswitch output6  

    output        HSELM7;
    output [31:0] HADDRM7;
    output  [1:0] HTRANSM7;
    output        HWRITEM7;
    output  [2:0] HSIZEM7;
    output  [2:0] HBURSTM7;
    output  [3:0] HPROTM7;
    output [31:0] HWDATAM7;
    output        HMASTLOCKM7;
    output        HREADYM7;
// busswitch output7

    output        SCANOUTHCLK;


    wire        HCLK;
    wire        HRESETn;

    wire        HSELS0;
    wire [31:0] HADDRS0;
    wire  [1:0] HTRANSS0;
    wire        HWRITES0;
    wire  [2:0] HSIZES0;
    wire  [2:0] HBURSTS0;
    wire  [3:0] HPROTS0;
    wire [31:0] HWDATAS0;
    wire        HMASTLOCKS0;
    wire        HREADYS0;
    wire [31:0] HRDATAS0;
    wire        HREADYOUTS0;
    wire  [1:0] HRESPS0;
// busswitch input0

    wire        HSELS1;
    wire [31:0] HADDRS1;
    wire  [1:0] HTRANSS1;
    wire        HWRITES1;
    wire  [2:0] HSIZES1;
    wire  [2:0] HBURSTS1;
    wire  [3:0] HPROTS1;
    wire [31:0] HWDATAS1;
    wire        HMASTLOCKS1;
    wire        HREADYS1;
    wire [31:0] HRDATAS1;
    wire        HREADYOUTS1;
    wire  [1:0] HRESPS1;
// busswitch input1

    wire        HSELS2;
    wire [31:0] HADDRS2;
    wire  [1:0] HTRANSS2;
    wire        HWRITES2;
    wire  [2:0] HSIZES2;
    wire  [2:0] HBURSTS2;
    wire  [3:0] HPROTS2;
    wire [31:0] HWDATAS2;
    wire        HMASTLOCKS2;
    wire        HREADYS2;
    wire [31:0] HRDATAS2;
    wire        HREADYOUTS2;
    wire  [1:0] HRESPS2;
// busswitch input2

    wire        HSELS3;
    wire [31:0] HADDRS3;
    wire  [1:0] HTRANSS3;
    wire        HWRITES3;
    wire  [2:0] HSIZES3;
    wire  [2:0] HBURSTS3;
    wire  [3:0] HPROTS3;
    wire [31:0] HWDATAS3;
    wire        HMASTLOCKS3;
    wire        HREADYS3;
    wire [31:0] HRDATAS3;
    wire        HREADYOUTS3;
    wire  [1:0] HRESPS3;
// busswitch input3

    wire        HSELS4;
    wire [31:0] HADDRS4;
    wire  [1:0] HTRANSS4;
    wire        HWRITES4;
    wire  [2:0] HSIZES4;
    wire  [2:0] HBURSTS4;
    wire  [3:0] HPROTS4;
    wire [31:0] HWDATAS4;
    wire        HMASTLOCKS4;
    wire        HREADYS4;
    wire [31:0] HRDATAS4;
    wire        HREADYOUTS4;
    wire  [1:0] HRESPS4;
// busswitch input4

    wire        HSELS5;
    wire [31:0] HADDRS5;
    wire  [1:0] HTRANSS5;
    wire        HWRITES5;
    wire  [2:0] HSIZES5;
    wire  [2:0] HBURSTS5;
    wire  [3:0] HPROTS5;
    wire [31:0] HWDATAS5;
    wire        HMASTLOCKS5;
    wire        HREADYS5;
    wire [31:0] HRDATAS5;
    wire        HREADYOUTS5;
    wire  [1:0] HRESPS5;
// busswitch input5

    wire        HSELS6;
    wire [31:0] HADDRS6;
    wire  [1:0] HTRANSS6;
    wire        HWRITES6;
    wire  [2:0] HSIZES6;
    wire  [2:0] HBURSTS6;
    wire  [3:0] HPROTS6;
    wire [31:0] HWDATAS6;
    wire        HMASTLOCKS6;
    wire        HREADYS6;
    wire [31:0] HRDATAS6;
    wire        HREADYOUTS6;
    wire  [1:0] HRESPS6;
// busswitch input6

    wire        HSELS7;
    wire [31:0] HADDRS7;
    wire  [1:0] HTRANSS7;
    wire        HWRITES7;
    wire  [2:0] HSIZES7;
    wire  [2:0] HBURSTS7;
    wire  [3:0] HPROTS7;
    wire [31:0] HWDATAS7;
    wire        HMASTLOCKS7;
    wire        HREADYS7;
    wire [31:0] HRDATAS7;
    wire        HREADYOUTS7;
    wire  [1:0] HRESPS7;
// busswitch input7

    wire        HSELM0;
    wire [31:0] HADDRM0;
    wire  [1:0] HTRANSM0;
    wire        HWRITEM0;
    wire  [2:0] HSIZEM0;
    wire  [2:0] HBURSTM0;
    wire  [3:0] HPROTM0;
    wire [31:0] HWDATAM0;
    wire        HMASTLOCKM0;
    wire        HREADYM0;
    wire [31:0] HRDATAM0;
    wire        HREADYOUTM0;
    wire  [1:0] HRESPM0;
// busswitch output0

    wire        HSELM1;
    wire [31:0] HADDRM1;
    wire  [1:0] HTRANSM1;
    wire        HWRITEM1;
    wire  [2:0] HSIZEM1;
    wire  [2:0] HBURSTM1;
    wire  [3:0] HPROTM1;
    wire [31:0] HWDATAM1;
    wire        HMASTLOCKM1;
    wire        HREADYM1;
    wire [31:0] HRDATAM1;
    wire        HREADYOUTM1;
    wire  [1:0] HRESPM1;
// busswitch output1

    wire        HSELM2;
    wire [31:0] HADDRM2;
    wire  [1:0] HTRANSM2;
    wire        HWRITEM2;
    wire  [2:0] HSIZEM2;
    wire  [2:0] HBURSTM2;
    wire  [3:0] HPROTM2;
    wire [31:0] HWDATAM2;
    wire        HMASTLOCKM2;
    wire        HREADYM2;
    wire [31:0] HRDATAM2;
    wire        HREADYOUTM2;
    wire  [1:0] HRESPM2;
// busswitch output2

    wire        HSELM3;
    wire [31:0] HADDRM3;
    wire  [1:0] HTRANSM3;
    wire        HWRITEM3;
    wire  [2:0] HSIZEM3;
    wire  [2:0] HBURSTM3;
    wire  [3:0] HPROTM3;
    wire [31:0] HWDATAM3;
    wire        HMASTLOCKM3;
    wire        HREADYM3;
    wire [31:0] HRDATAM3;
    wire        HREADYOUTM3;
    wire  [1:0] HRESPM3;
// busswitch output3

    wire        HSELM4;
    wire [31:0] HADDRM4;
    wire  [1:0] HTRANSM4;
    wire        HWRITEM4;
    wire  [2:0] HSIZEM4;
    wire  [2:0] HBURSTM4;
    wire  [3:0] HPROTM4;
    wire [31:0] HWDATAM4;
    wire        HMASTLOCKM4;
    wire        HREADYM4;
    wire [31:0] HRDATAM4;
    wire        HREADYOUTM4;
    wire  [1:0] HRESPM4;
// busswitch output4

    wire        HSELM5;
    wire [31:0] HADDRM5;
    wire  [1:0] HTRANSM5;
    wire        HWRITEM5;
    wire  [2:0] HSIZEM5;
    wire  [2:0] HBURSTM5;
    wire  [3:0] HPROTM5;
    wire [31:0] HWDATAM5;
    wire        HMASTLOCKM5;
    wire        HREADYM5;
    wire [31:0] HRDATAM5;
    wire        HREADYOUTM5;
    wire  [1:0] HRESPM5;
// busswitch output5 

    wire        HSELM6;
    wire [31:0] HADDRM6;
    wire  [1:0] HTRANSM6;
    wire        HWRITEM6;
    wire  [2:0] HSIZEM6;
    wire  [2:0] HBURSTM6;
    wire  [3:0] HPROTM6;
    wire [31:0] HWDATAM6;
    wire        HMASTLOCKM6;
    wire        HREADYM6;
    wire [31:0] HRDATAM6;
    wire        HREADYOUTM6;
    wire  [1:0] HRESPM6;
// busswitch output6

    wire        HSELM7;
    wire [31:0] HADDRM7;
    wire  [1:0] HTRANSM7;
    wire        HWRITEM7;
    wire  [2:0] HSIZEM7;
    wire  [2:0] HBURSTM7;
    wire  [3:0] HPROTM7;
    wire [31:0] HWDATAM7;
    wire        HMASTLOCKM7;
    wire        HREADYM7;
    wire [31:0] HRDATAM7;
    wire        HREADYOUTM7;
    wire  [1:0] HRESPM7;
// busswitch output7

  
//------------------------------------------------------------------------------
// Signal declaration
//------------------------------------------------------------------------------
    wire        Sel0;
    wire [31:0] Addr0;
    wire  [1:0] Trans0;
    wire        Write0;
    wire  [2:0] Size0;
    wire  [2:0] Burst0;
    wire  [3:0] Prot0;
    wire        Mastlock0;
    wire        Active0;
    wire        HeldTran0;
    wire        Readyout0;
    wire  [1:0] Resp0;
// busswitch input0

    wire        Sel1;
    wire [31:0] Addr1;
    wire  [1:0] Trans1;
    wire        Write1;
    wire  [2:0] Size1;
    wire  [2:0] Burst1;
    wire  [3:0] Prot1;
    wire        Mastlock1;
    wire        Active1;
    wire        HeldTran1;
    wire        Readyout1;
    wire  [1:0] Resp1;
// busswitch input1

    wire        Sel2;
    wire [31:0] Addr2;
    wire  [1:0] Trans2;
    wire        Write2;
    wire  [2:0] Size2;
    wire  [2:0] Burst2;
    wire  [3:0] Prot2;
    wire        Mastlock2;
    wire        Active2;
    wire        HeldTran2;
    wire        Readyout2;
    wire  [1:0] Resp2;
// busswitch input2

    wire        Sel3;
    wire [31:0] Addr3;
    wire  [1:0] Trans3;
    wire        Write3;
    wire  [2:0] Size3;
    wire  [2:0] Burst3;
    wire  [3:0] Prot3;
    wire        Mastlock3;
    wire        Active3;
    wire        HeldTran3;
    wire        Readyout3;
    wire  [1:0] Resp3;
// busswitch input3

    wire        Sel4;
    wire [31:0] Addr4;
    wire  [1:0] Trans4;
    wire        Write4;
    wire  [2:0] Size4;
    wire  [2:0] Burst4;
    wire  [3:0] Prot4;
    wire        Mastlock4;
    wire        Active4;
    wire        HeldTran4;
    wire        Readyout4;
    wire  [1:0] Resp4;
// busswitch input4

    wire        Sel5;
    wire [31:0] Addr5;
    wire  [1:0] Trans5;
    wire        Write5;
    wire  [2:0] Size5;
    wire  [2:0] Burst5;
    wire  [3:0] Prot5;
    wire        Mastlock5;
    wire        Active5;
    wire        HeldTran5;
    wire        Readyout5;
    wire  [1:0] Resp5;
// busswitch input5

    wire        Sel6;
    wire [31:0] Addr6;
    wire  [1:0] Trans6;
    wire        Write6;
    wire  [2:0] Size6;
    wire  [2:0] Burst6;
    wire  [3:0] Prot6;
    wire        Mastlock6;
    wire        Active6;
    wire        HeldTran6;
    wire        Readyout6;
    wire  [1:0] Resp6;
// busswitch input6

    wire        Sel7;
    wire [31:0] Addr7;
    wire  [1:0] Trans7;
    wire        Write7;
    wire  [2:0] Size7;
    wire  [2:0] Burst7;
    wire  [3:0] Prot7;
    wire        Mastlock7;
    wire        Active7;
    wire        HeldTran7;
    wire        Readyout7;
    wire  [1:0] Resp7;
// busswitch input7
  
    wire        Sel0to0;
    wire        Active0to0;
// busswitch input0
    wire        Sel1to0;
    wire        Active1to0;
// busswitch input1
    wire        Sel2to0;
    wire        Active2to0;
// busswitch input2
    wire        Sel3to0;
    wire        Active3to0;
// busswitch input3
    wire        Sel4to0;
    wire        Active4to0;
// busswitch input4
    wire        Sel5to0;
    wire        Active5to0;
// busswitch input5
    wire        Sel6to0;
    wire        Active6to0;
// busswitch input6
    wire        Sel7to0;
    wire        Active7to0;
// busswitch input7
// busswitch output0
  
    wire        Sel0to1;
    wire        Active0to1;
// busswitch input0
    wire        Sel1to1;
    wire        Active1to1;
// busswitch input1
    wire        Sel2to1;
    wire        Active2to1;
// busswitch input2
    wire        Sel3to1;
    wire        Active3to1;
// busswitch input3
    wire        Sel4to1;
    wire        Active4to1;
// busswitch input4
    wire        Sel5to1;
    wire        Active5to1;
// busswitch input5
    wire        Sel6to1;
    wire        Active6to1;
// busswitch input6
    wire        Sel7to1;
    wire        Active7to1;
// busswitch input7
// busswitch output1
  
    wire        Sel0to2;
    wire        Active0to2;
// busswitch input0
    wire        Sel1to2;
    wire        Active1to2;
// busswitch input1
    wire        Sel2to2;
    wire        Active2to2;
// busswitch input2
    wire        Sel3to2;
    wire        Active3to2;
// busswitch input3
    wire        Sel4to2;
    wire        Active4to2;
// busswitch input4
    wire        Sel5to2;
    wire        Active5to2;
// busswitch input5
    wire        Sel6to2;
    wire        Active6to2;
// busswitch input6
    wire        Sel7to2;
    wire        Active7to2;
// busswitch input7
// busswitch output2
  
    wire        Sel0to3;
    wire        Active0to3;
// busswitch input0
    wire        Sel1to3;
    wire        Active1to3;
// busswitch input1
    wire        Sel2to3;
    wire        Active2to3;
// busswitch input2
    wire        Sel3to3;
    wire        Active3to3;
// busswitch input3
    wire        Sel4to3;
    wire        Active4to3;
// busswitch input4
    wire        Sel5to3;
    wire        Active5to3;
// busswitch input5
    wire        Sel6to3;
    wire        Active6to3;
// busswitch input6
    wire        Sel7to3;
    wire        Active7to3;
// busswitch input7
// busswitch output3
  
    wire        Sel0to4;
    wire        Active0to4;
// busswitch input0
    wire        Sel1to4;
    wire        Active1to4;
// busswitch input1
    wire        Sel2to4;
    wire        Active2to4;
// busswitch input2
    wire        Sel3to4;
    wire        Active3to4;
// busswitch input3
    wire        Sel4to4;
    wire        Active4to4;
// busswitch input4
    wire        Sel5to4;
    wire        Active5to4;
// busswitch input5
    wire        Sel6to4;
    wire        Active6to4;
// busswitch input6
    wire        Sel7to4;
    wire        Active7to4;
// busswitch input7
// busswitch output4
  
    wire        Sel0to5;
    wire        Active0to5;
// busswitch input0
    wire        Sel1to5;
    wire        Active1to5;
// busswitch input1
    wire        Sel2to5;
    wire        Active2to5;
// busswitch input2
    wire        Sel3to5;
    wire        Active3to5;
// busswitch input3
    wire        Sel4to5;
    wire        Active4to5;
// busswitch input4
    wire        Sel5to5;
    wire        Active5to5;
// busswitch input5
    wire        Sel6to5;
    wire        Active6to5;
// busswitch input6
    wire        Sel7to5;
    wire        Active7to5;
// busswitch input7
// busswitch output5
  
    wire        Sel0to6;
    wire        Active0to6;
// busswitch input0
    wire        Sel1to6;
    wire        Active1to6;
// busswitch input1
    wire        Sel2to6;
    wire        Active2to6;
// busswitch input2
    wire        Sel3to6;
    wire        Active3to6;
// busswitch input3
    wire        Sel4to6;
    wire        Active4to6;
// busswitch input4
    wire        Sel5to6;
    wire        Active5to6;
// busswitch input5
    wire        Sel6to6;
    wire        Active6to6;
// busswitch input6
    wire        Sel7to6;
    wire        Active7to6;
// busswitch input7
// busswitch output6
  
    wire        Sel0to7;
    wire        Active0to7;
// busswitch input0
    wire        Sel1to7;
    wire        Active1to7;
// busswitch input1
    wire        Sel2to7;
    wire        Active2to7;
// busswitch input2
    wire        Sel3to7;
    wire        Active3to7;
// busswitch input3
    wire        Sel4to7;
    wire        Active4to7;
// busswitch input4
    wire        Sel5to7;
    wire        Active5to7;
// busswitch input5
    wire        Sel6to7;
    wire        Active6to7;
// busswitch input6
    wire        Sel7to7;
    wire        Active7to7;
// busswitch input7
// busswitch output7
  
  
//------------------------------------------------------------------------------
// Constant declarations
//------------------------------------------------------------------------------
`define RSP_OKAY 2'b00

  
//------------------------------------------------------------------------------
// Beginning of main code
//------------------------------------------------------------------------------
  
  InputStage uInputStage0 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELS0),
    .HADDRS     (HADDRS0),
    .HTRANSS    (HTRANSS0),
    .HWRITES    (HWRITES0),
    .HSIZES     (HSIZES0),
    .HBURSTS    (HBURSTS0),
    .HPROTS     (HPROTS0),
    .HMASTLOCKS (HMASTLOCKS0),
    .HREADYS    (HREADYS0),

    // Input Port Response
    .HREADYOUTS (HREADYOUTS0),
    .HRESPS     (HRESPS0),

    // Internal Address/Control Signals
    .Sel        (Sel0),
    .Addr       (Addr0),
    .Trans      (Trans0),
    .Write      (Write0),
    .Size       (Size0),
    .Burst      (Burst0),
    .Prot       (Prot0),
    .Mastlock   (Mastlock0),
    .HeldTran   (HeldTran0),

    // Internal Response
    .Active     (Active0),
    .Readyout   (Readyout0),
    .Resp       (Resp0)
    );
// busswitch input0
  
  InputStage uInputStage1 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELS1),
    .HADDRS     (HADDRS1),
    .HTRANSS    (HTRANSS1),
    .HWRITES    (HWRITES1),
    .HSIZES     (HSIZES1),
    .HBURSTS    (HBURSTS1),
    .HPROTS     (HPROTS1),
    .HMASTLOCKS (HMASTLOCKS1),
    .HREADYS    (HREADYS1),

    // Input Port Response
    .HREADYOUTS (HREADYOUTS1),
    .HRESPS     (HRESPS1),

    // Internal Address/Control Signals
    .Sel        (Sel1),
    .Addr       (Addr1),
    .Trans      (Trans1),
    .Write      (Write1),
    .Size       (Size1),
    .Burst      (Burst1),
    .Prot       (Prot1),
    .Mastlock   (Mastlock1),
    .HeldTran   (HeldTran1),

    // Internal Response
    .Active     (Active1),
    .Readyout   (Readyout1),
    .Resp       (Resp1)
    );
// busswitch input1
  
  InputStage uInputStage2 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELS2),
    .HADDRS     (HADDRS2),
    .HTRANSS    (HTRANSS2),
    .HWRITES    (HWRITES2),
    .HSIZES     (HSIZES2),
    .HBURSTS    (HBURSTS2),
    .HPROTS     (HPROTS2),
    .HMASTLOCKS (HMASTLOCKS2),
    .HREADYS    (HREADYS2),

    // Input Port Response
    .HREADYOUTS (HREADYOUTS2),
    .HRESPS     (HRESPS2),

    // Internal Address/Control Signals
    .Sel        (Sel2),
    .Addr       (Addr2),
    .Trans      (Trans2),
    .Write      (Write2),
    .Size       (Size2),
    .Burst      (Burst2),
    .Prot       (Prot2),
    .Mastlock   (Mastlock2),
    .HeldTran   (HeldTran2),

    // Internal Response
    .Active     (Active2),
    .Readyout   (Readyout2),
    .Resp       (Resp2)
    );
// busswitch input2
  
  InputStage uInputStage3 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELS3),
    .HADDRS     (HADDRS3),
    .HTRANSS    (HTRANSS3),
    .HWRITES    (HWRITES3),
    .HSIZES     (HSIZES3),
    .HBURSTS    (HBURSTS3),
    .HPROTS     (HPROTS3),
    .HMASTLOCKS (HMASTLOCKS3),
    .HREADYS    (HREADYS3),

    // Input Port Response
    .HREADYOUTS (HREADYOUTS3),
    .HRESPS     (HRESPS3),

    // Internal Address/Control Signals
    .Sel        (Sel3),
    .Addr       (Addr3),
    .Trans      (Trans3),
    .Write      (Write3),
    .Size       (Size3),
    .Burst      (Burst3),
    .Prot       (Prot3),
    .Mastlock   (Mastlock3),
    .HeldTran   (HeldTran3),

    // Internal Response
    .Active     (Active3),
    .Readyout   (Readyout3),
    .Resp       (Resp3)
    );
// busswitch input3
  
  InputStage uInputStage4 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELS4),
    .HADDRS     (HADDRS4),
    .HTRANSS    (HTRANSS4),
    .HWRITES    (HWRITES4),
    .HSIZES     (HSIZES4),
    .HBURSTS    (HBURSTS4),
    .HPROTS     (HPROTS4),
    .HMASTLOCKS (HMASTLOCKS4),
    .HREADYS    (HREADYS4),

    // Input Port Response
    .HREADYOUTS (HREADYOUTS4),
    .HRESPS     (HRESPS4),

    // Internal Address/Control Signals
    .Sel        (Sel4),
    .Addr       (Addr4),
    .Trans      (Trans4),
    .Write      (Write4),
    .Size       (Size4),
    .Burst      (Burst4),
    .Prot       (Prot4),
    .Mastlock   (Mastlock4),
    .HeldTran   (HeldTran4),

    // Internal Response
    .Active     (Active4),
    .Readyout   (Readyout4),
    .Resp       (Resp4)
    );
// busswitch input4
  
  InputStage uInputStage5 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELS5),
    .HADDRS     (HADDRS5),
    .HTRANSS    (HTRANSS5),
    .HWRITES    (HWRITES5),
    .HSIZES     (HSIZES5),
    .HBURSTS    (HBURSTS5),
    .HPROTS     (HPROTS5),
    .HMASTLOCKS (HMASTLOCKS5),
    .HREADYS    (HREADYS5),

    // Input Port Response
    .HREADYOUTS (HREADYOUTS5),
    .HRESPS     (HRESPS5),

    // Internal Address/Control Signals
    .Sel        (Sel5),
    .Addr       (Addr5),
    .Trans      (Trans5),
    .Write      (Write5),
    .Size       (Size5),
    .Burst      (Burst5),
    .Prot       (Prot5),
    .Mastlock   (Mastlock5),
    .HeldTran   (HeldTran5),

    // Internal Response
    .Active     (Active5),
    .Readyout   (Readyout5),
    .Resp       (Resp5)
    );
// busswitch input5
  
  InputStage uInputStage6 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELS6),
    .HADDRS     (HADDRS6),
    .HTRANSS    (HTRANSS6),
    .HWRITES    (HWRITES6),
    .HSIZES     (HSIZES6),
    .HBURSTS    (HBURSTS6),
    .HPROTS     (HPROTS6),
    .HMASTLOCKS (HMASTLOCKS6),
    .HREADYS    (HREADYS6),

    // Input Port Response
    .HREADYOUTS (HREADYOUTS6),
    .HRESPS     (HRESPS6),

    // Internal Address/Control Signals
    .Sel        (Sel6),
    .Addr       (Addr6),
    .Trans      (Trans6),
    .Write      (Write6),
    .Size       (Size6),
    .Burst      (Burst6),
    .Prot       (Prot6),
    .Mastlock   (Mastlock6),
    .HeldTran   (HeldTran6),

    // Internal Response
    .Active     (Active6),
    .Readyout   (Readyout6),
    .Resp       (Resp6)
    );
// busswitch input6
  
  InputStage uInputStage7 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Input Port Address/Control Signals
    .HSELS      (HSELS7),
    .HADDRS     (HADDRS7),
    .HTRANSS    (HTRANSS7),
    .HWRITES    (HWRITES7),
    .HSIZES     (HSIZES7),
    .HBURSTS    (HBURSTS7),
    .HPROTS     (HPROTS7),
    .HMASTLOCKS (HMASTLOCKS7),
    .HREADYS    (HREADYS7),

    // Input Port Response
    .HREADYOUTS (HREADYOUTS7),
    .HRESPS     (HRESPS7),

    // Internal Address/Control Signals
    .Sel        (Sel7),
    .Addr       (Addr7),
    .Trans      (Trans7),
    .Write      (Write7),
    .Size       (Size7),
    .Burst      (Burst7),
    .Prot       (Prot7),
    .Mastlock   (Mastlock7),
    .HeldTran   (HeldTran7),

    // Internal Response
    .Active     (Active7),
    .Readyout   (Readyout7),
    .Resp       (Resp7)
    );
// busswitch input7


  MatrixDecode uMatrixDecode0 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .HREADYS    (HREADYS0),
    .Sel        (Sel0),
    .Addr       (Addr0),
    .Sel0       (Sel0to0),
    .Active0    (Active0to0),
    .Readyout0  (HREADYOUTM0),
    .Resp0      (HRESPM0),
    .Rdata0     (HRDATAM0),
// busswitch output0
    .Sel1       (Sel0to1),
    .Active1    (Active0to1),
    .Readyout1  (HREADYOUTM1),
    .Resp1      (HRESPM1),
    .Rdata1     (HRDATAM1),
// busswitch output1
    .Sel2       (Sel0to2),
    .Active2    (Active0to2),
    .Readyout2  (HREADYOUTM2),
    .Resp2      (HRESPM2),
    .Rdata2     (HRDATAM2),
// busswitch output2
    .Sel3       (Sel0to3),
    .Active3    (Active0to3),
    .Readyout3  (HREADYOUTM3),
    .Resp3      (HRESPM3),
    .Rdata3     (HRDATAM3),
// busswitch output3
    .Sel4       (Sel0to4),
    .Active4    (Active0to4),
    .Readyout4  (HREADYOUTM4),
    .Resp4      (HRESPM4),
    .Rdata4     (HRDATAM4),
// busswitch output4
    .Sel5       (Sel0to5),
    .Active5    (Active0to5),
    .Readyout5  (HREADYOUTM5),
    .Resp5      (HRESPM5),
    .Rdata5     (HRDATAM5),
// busswitch output5
    .Sel6       (Sel0to6),
    .Active6    (Active0to6),
    .Readyout6  (HREADYOUTM6),
    .Resp6      (HRESPM6),
    .Rdata6     (HRDATAM6),
// busswitch output6
    .Sel7       (Sel0to7),
    .Active7    (Active0to7),
    .Readyout7  (HREADYOUTM7),
    .Resp7      (HRESPM7),
    .Rdata7     (HRDATAM7),
// busswitch output7
    .Active     (Active0),
    .HREADYOUTS (Readyout0),
    .HRESPS     (Resp0),
    .HRDATAS    (HRDATAS0)
    );
// busswitch input0
  
  MatrixDecode uMatrixDecode1 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .HREADYS    (HREADYS1),
    .Sel        (Sel1),
    .Addr       (Addr1),
    .Sel0       (Sel1to0),
    .Active0    (Active1to0),
    .Readyout0  (HREADYOUTM0),
    .Resp0      (HRESPM0),
    .Rdata0     (HRDATAM0),
// busswitch output0
    .Sel1       (Sel1to1),
    .Active1    (Active1to1),
    .Readyout1  (HREADYOUTM1),
    .Resp1      (HRESPM1),
    .Rdata1     (HRDATAM1),
// busswitch output1
    .Sel2       (Sel1to2),
    .Active2    (Active1to2),
    .Readyout2  (HREADYOUTM2),
    .Resp2      (HRESPM2),
    .Rdata2     (HRDATAM2),
// busswitch output2
    .Sel3       (Sel1to3),
    .Active3    (Active1to3),
    .Readyout3  (HREADYOUTM3),
    .Resp3      (HRESPM3),
    .Rdata3     (HRDATAM3),
// busswitch output3
    .Sel4       (Sel1to4),
    .Active4    (Active1to4),
    .Readyout4  (HREADYOUTM4),
    .Resp4      (HRESPM4),
    .Rdata4     (HRDATAM4),
// busswitch output4
    .Sel5       (Sel1to5),
    .Active5    (Active1to5),
    .Readyout5  (HREADYOUTM5),
    .Resp5      (HRESPM5),
    .Rdata5     (HRDATAM5),
// busswitch output5
    .Sel6       (Sel1to6),
    .Active6    (Active1to6),
    .Readyout6  (HREADYOUTM6),
    .Resp6      (HRESPM6),
    .Rdata6     (HRDATAM6),
// busswitch output6
    .Sel7       (Sel1to7),
    .Active7    (Active1to7),
    .Readyout7  (HREADYOUTM7),
    .Resp7      (HRESPM7),
    .Rdata7     (HRDATAM7),
// busswitch output7
    .Active     (Active1),
    .HREADYOUTS (Readyout1),
    .HRESPS     (Resp1),
    .HRDATAS    (HRDATAS1)
    );
// busswitch input1
  
  MatrixDecode uMatrixDecode2 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .HREADYS    (HREADYS2),
    .Sel        (Sel2),
    .Addr       (Addr2),
    .Sel0       (Sel2to0),
    .Active0    (Active2to0),
    .Readyout0  (HREADYOUTM0),
    .Resp0      (HRESPM0),
    .Rdata0     (HRDATAM0),
// busswitch output0
    .Sel1       (Sel2to1),
    .Active1    (Active2to1),
    .Readyout1  (HREADYOUTM1),
    .Resp1      (HRESPM1),
    .Rdata1     (HRDATAM1),
// busswitch output1
    .Sel2       (Sel2to2),
    .Active2    (Active2to2),
    .Readyout2  (HREADYOUTM2),
    .Resp2      (HRESPM2),
    .Rdata2     (HRDATAM2),
// busswitch output2
    .Sel3       (Sel2to3),
    .Active3    (Active2to3),
    .Readyout3  (HREADYOUTM3),
    .Resp3      (HRESPM3),
    .Rdata3     (HRDATAM3),
// busswitch output3
    .Sel4       (Sel2to4),
    .Active4    (Active2to4),
    .Readyout4  (HREADYOUTM4),
    .Resp4      (HRESPM4),
    .Rdata4     (HRDATAM4),
// busswitch output4
    .Sel5       (Sel2to5),
    .Active5    (Active2to5),
    .Readyout5  (HREADYOUTM5),
    .Resp5      (HRESPM5),
    .Rdata5     (HRDATAM5),
// busswitch output5
    .Sel6       (Sel2to6),
    .Active6    (Active2to6),
    .Readyout6  (HREADYOUTM6),
    .Resp6      (HRESPM6),
    .Rdata6     (HRDATAM6),
// busswitch output6
    .Sel7       (Sel2to7),
    .Active7    (Active2to7),
    .Readyout7  (HREADYOUTM7),
    .Resp7      (HRESPM7),
    .Rdata7     (HRDATAM7),
// busswitch output7
    .Active     (Active2),
    .HREADYOUTS (Readyout2),
    .HRESPS     (Resp2),
    .HRDATAS    (HRDATAS2)
    );
// busswitch input2
  
  MatrixDecode uMatrixDecode3 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .HREADYS    (HREADYS3),
    .Sel        (Sel3),
    .Addr       (Addr3),
    .Sel0       (Sel3to0),
    .Active0    (Active3to0),
    .Readyout0  (HREADYOUTM0),
    .Resp0      (HRESPM0),
    .Rdata0     (HRDATAM0),
// busswitch output0
    .Sel1       (Sel3to1),
    .Active1    (Active3to1),
    .Readyout1  (HREADYOUTM1),
    .Resp1      (HRESPM1),
    .Rdata1     (HRDATAM1),
// busswitch output1
    .Sel2       (Sel3to2),
    .Active2    (Active3to2),
    .Readyout2  (HREADYOUTM2),
    .Resp2      (HRESPM2),
    .Rdata2     (HRDATAM2),
// busswitch output2
    .Sel3       (Sel3to3),
    .Active3    (Active3to3),
    .Readyout3  (HREADYOUTM3),
    .Resp3      (HRESPM3),
    .Rdata3     (HRDATAM3),
// busswitch output3
    .Sel4       (Sel3to4),
    .Active4    (Active3to4),
    .Readyout4  (HREADYOUTM4),
    .Resp4      (HRESPM4),
    .Rdata4     (HRDATAM4),
// busswitch output4
    .Sel5       (Sel3to5),
    .Active5    (Active3to5),
    .Readyout5  (HREADYOUTM5),
    .Resp5      (HRESPM5),
    .Rdata5     (HRDATAM5),
// busswitch output5
    .Sel6       (Sel3to6),
    .Active6    (Active3to6),
    .Readyout6  (HREADYOUTM6),
    .Resp6      (HRESPM6),
    .Rdata6     (HRDATAM6),
// busswitch output6
    .Sel7       (Sel3to7),
    .Active7    (Active3to7),
    .Readyout7  (HREADYOUTM7),
    .Resp7      (HRESPM7),
    .Rdata7     (HRDATAM7),
// busswitch output7
    .Active     (Active3),
    .HREADYOUTS (Readyout3),
    .HRESPS     (Resp3),
    .HRDATAS    (HRDATAS3)
    );
// busswitch input3
  
  MatrixDecode uMatrixDecode4 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .HREADYS    (HREADYS4),
    .Sel        (Sel4),
    .Addr       (Addr4),
    .Sel0       (Sel4to0),
    .Active0    (Active4to0),
    .Readyout0  (HREADYOUTM0),
    .Resp0      (HRESPM0),
    .Rdata0     (HRDATAM0),
// busswitch output0
    .Sel1       (Sel4to1),
    .Active1    (Active4to1),
    .Readyout1  (HREADYOUTM1),
    .Resp1      (HRESPM1),
    .Rdata1     (HRDATAM1),
// busswitch output1
    .Sel2       (Sel4to2),
    .Active2    (Active4to2),
    .Readyout2  (HREADYOUTM2),
    .Resp2      (HRESPM2),
    .Rdata2     (HRDATAM2),
// busswitch output2
    .Sel3       (Sel4to3),
    .Active3    (Active4to3),
    .Readyout3  (HREADYOUTM3),
    .Resp3      (HRESPM3),
    .Rdata3     (HRDATAM3),
// busswitch output3
    .Sel4       (Sel4to4),
    .Active4    (Active4to4),
    .Readyout4  (HREADYOUTM4),
    .Resp4      (HRESPM4),
    .Rdata4     (HRDATAM4),
// busswitch output4
    .Sel5       (Sel4to5),
    .Active5    (Active4to5),
    .Readyout5  (HREADYOUTM5),
    .Resp5      (HRESPM5),
    .Rdata5     (HRDATAM5),
// busswitch output5
    .Sel6       (Sel4to6),
    .Active6    (Active4to6),
    .Readyout6  (HREADYOUTM6),
    .Resp6      (HRESPM6),
    .Rdata6     (HRDATAM6),
// busswitch output6
    .Sel7       (Sel4to7),
    .Active7    (Active4to7),
    .Readyout7  (HREADYOUTM7),
    .Resp7      (HRESPM7),
    .Rdata7     (HRDATAM7),
// busswitch output7
    .Active     (Active4),
    .HREADYOUTS (Readyout4),
    .HRESPS     (Resp4),
    .HRDATAS    (HRDATAS4)
    );
// busswitch input4
  
  MatrixDecode uMatrixDecode5 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .HREADYS    (HREADYS5),
    .Sel        (Sel5),
    .Addr       (Addr5),
    .Sel0       (Sel5to0),
    .Active0    (Active5to0),
    .Readyout0  (HREADYOUTM0),
    .Resp0      (HRESPM0),
    .Rdata0     (HRDATAM0),
// busswitch output0
    .Sel1       (Sel5to1),
    .Active1    (Active5to1),
    .Readyout1  (HREADYOUTM1),
    .Resp1      (HRESPM1),
    .Rdata1     (HRDATAM1),
// busswitch output1
    .Sel2       (Sel5to2),
    .Active2    (Active5to2),
    .Readyout2  (HREADYOUTM2),
    .Resp2      (HRESPM2),
    .Rdata2     (HRDATAM2),
// busswitch output2
    .Sel3       (Sel5to3),
    .Active3    (Active5to3),
    .Readyout3  (HREADYOUTM3),
    .Resp3      (HRESPM3),
    .Rdata3     (HRDATAM3),
// busswitch output3
    .Sel4       (Sel5to4),
    .Active4    (Active5to4),
    .Readyout4  (HREADYOUTM4),
    .Resp4      (HRESPM4),
    .Rdata4     (HRDATAM4),
// busswitch output4
    .Sel5       (Sel5to5),
    .Active5    (Active5to5),
    .Readyout5  (HREADYOUTM5),
    .Resp5      (HRESPM5),
    .Rdata5     (HRDATAM5),
// busswitch output5
    .Sel6       (Sel5to6),
    .Active6    (Active5to6),
    .Readyout6  (HREADYOUTM6),
    .Resp6      (HRESPM6),
    .Rdata6     (HRDATAM6),
// busswitch output6
    .Sel7       (Sel5to7),
    .Active7    (Active5to7),
    .Readyout7  (HREADYOUTM7),
    .Resp7      (HRESPM7),
    .Rdata7     (HRDATAM7),
// busswitch output7
    .Active     (Active5),
    .HREADYOUTS (Readyout5),
    .HRESPS     (Resp5),
    .HRDATAS    (HRDATAS5)
    );
// busswitch input5
  
  MatrixDecode uMatrixDecode6 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .HREADYS    (HREADYS6),
    .Sel        (Sel6),
    .Addr       (Addr6),
    .Sel0       (Sel6to0),
    .Active0    (Active6to0),
    .Readyout0  (HREADYOUTM0),
    .Resp0      (HRESPM0),
    .Rdata0     (HRDATAM0),
// busswitch output0
    .Sel1       (Sel6to1),
    .Active1    (Active6to1),
    .Readyout1  (HREADYOUTM1),
    .Resp1      (HRESPM1),
    .Rdata1     (HRDATAM1),
// busswitch output1
    .Sel2       (Sel6to2),
    .Active2    (Active6to2),
    .Readyout2  (HREADYOUTM2),
    .Resp2      (HRESPM2),
    .Rdata2     (HRDATAM2),
// busswitch output2
    .Sel3       (Sel6to3),
    .Active3    (Active6to3),
    .Readyout3  (HREADYOUTM3),
    .Resp3      (HRESPM3),
    .Rdata3     (HRDATAM3),
// busswitch output3
    .Sel4       (Sel6to4),
    .Active4    (Active6to4),
    .Readyout4  (HREADYOUTM4),
    .Resp4      (HRESPM4),
    .Rdata4     (HRDATAM4),
// busswitch output4
    .Sel5       (Sel6to5),
    .Active5    (Active6to5),
    .Readyout5  (HREADYOUTM5),
    .Resp5      (HRESPM5),
    .Rdata5     (HRDATAM5),
// busswitch output5
    .Sel6       (Sel6to6),
    .Active6    (Active6to6),
    .Readyout6  (HREADYOUTM6),
    .Resp6      (HRESPM6),
    .Rdata6     (HRDATAM6),
// busswitch output6
    .Sel7       (Sel6to7),
    .Active7    (Active6to7),
    .Readyout7  (HREADYOUTM7),
    .Resp7      (HRESPM7),
    .Rdata7     (HRDATAM7),
// busswitch output7
    .Active     (Active6),
    .HREADYOUTS (Readyout6),
    .HRESPS     (Resp6),
    .HRDATAS    (HRDATAS6)
    );
// busswitch input6
  
  MatrixDecode uMatrixDecode7 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),
    .HREADYS    (HREADYS7),
    .Sel        (Sel7),
    .Addr       (Addr7),
    .Sel0       (Sel7to0),
    .Active0    (Active7to0),
    .Readyout0  (HREADYOUTM0),
    .Resp0      (HRESPM0),
    .Rdata0     (HRDATAM0),
// busswitch output0
    .Sel1       (Sel7to1),
    .Active1    (Active7to1),
    .Readyout1  (HREADYOUTM1),
    .Resp1      (HRESPM1),
    .Rdata1     (HRDATAM1),
// busswitch output1
    .Sel2       (Sel7to2),
    .Active2    (Active7to2),
    .Readyout2  (HREADYOUTM2),
    .Resp2      (HRESPM2),
    .Rdata2     (HRDATAM2),
// busswitch output2
    .Sel3       (Sel7to3),
    .Active3    (Active7to3),
    .Readyout3  (HREADYOUTM3),
    .Resp3      (HRESPM3),
    .Rdata3     (HRDATAM3),
// busswitch output3
    .Sel4       (Sel7to4),
    .Active4    (Active7to4),
    .Readyout4  (HREADYOUTM4),
    .Resp4      (HRESPM4),
    .Rdata4     (HRDATAM4),
// busswitch output4
    .Sel5       (Sel7to5),
    .Active5    (Active7to5),
    .Readyout5  (HREADYOUTM5),
    .Resp5      (HRESPM5),
    .Rdata5     (HRDATAM5),
// busswitch output5
    .Sel6       (Sel7to6),
    .Active6    (Active7to6),
    .Readyout6  (HREADYOUTM6),
    .Resp6      (HRESPM6),
    .Rdata6     (HRDATAM6),
// busswitch output6
    .Sel7       (Sel7to7),
    .Active7    (Active7to7),
    .Readyout7  (HREADYOUTM7),
    .Resp7      (HRESPM7),
    .Rdata7     (HRDATAM7),
// busswitch output7
    .Active     (Active7),
    .HREADYOUTS (Readyout7),
    .HRESPS     (Resp7),
    .HRDATAS    (HRDATAS7)
    );
// busswitch input7

  
  OutputStage uOutputstage0 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .Sel0       (Sel0to0),
    .Addr0      (Addr0),
    .Trans0     (Trans0),
    .Write0     (Write0),
    .Size0      (Size0),
    .Burst0     (Burst0),
    .Prot0      (Prot0),
    .Mastlock0  (Mastlock0),
    .Wdata0     (HWDATAS0),
    .HeldTran0  (HeldTran0),
    .Active0    (Active0to0),
// busswitch input0
         
    // Port 1 Signals
    .Sel1       (Sel1to0),
    .Addr1      (Addr1),
    .Trans1     (Trans1),
    .Write1     (Write1),
    .Size1      (Size1),
    .Burst1     (Burst1),
    .Prot1      (Prot1),
    .Mastlock1  (Mastlock1),
    .Wdata1     (HWDATAS1),
    .HeldTran1  (HeldTran1),
    .Active1    (Active1to0),
// busswitch input1
         
    // Port 2 Signals
    .Sel2       (Sel2to0),
    .Addr2      (Addr2),
    .Trans2     (Trans2),
    .Write2     (Write2),
    .Size2      (Size2),
    .Burst2     (Burst2),
    .Prot2      (Prot2),
    .Mastlock2  (Mastlock2),
    .Wdata2     (HWDATAS2),
    .HeldTran2  (HeldTran2),
    .Active2    (Active2to0),
// busswitch input2
         
    // Port 3 Signals
    .Sel3       (Sel3to0),
    .Addr3      (Addr3),
    .Trans3     (Trans3),
    .Write3     (Write3),
    .Size3      (Size3),
    .Burst3     (Burst3),
    .Prot3      (Prot3),
    .Mastlock3  (Mastlock3),
    .Wdata3     (HWDATAS3),
    .HeldTran3  (HeldTran3),
    .Active3    (Active3to0),
// busswitch input3
         
    // Port 4 Signals
    .Sel4       (Sel4to0),
    .Addr4      (Addr4),
    .Trans4     (Trans4),
    .Write4     (Write4),
    .Size4      (Size4),
    .Burst4     (Burst4),
    .Prot4      (Prot4),
    .Mastlock4  (Mastlock4),
    .Wdata4     (HWDATAS4),
    .HeldTran4  (HeldTran4),
    .Active4    (Active4to0),
// busswitch input4
         
    // Port 5 Signals
    .Sel5       (Sel5to0),
    .Addr5      (Addr5),
    .Trans5     (Trans5),
    .Write5     (Write5),
    .Size5      (Size5),
    .Burst5     (Burst5),
    .Prot5      (Prot5),
    .Mastlock5  (Mastlock5),
    .Wdata5     (HWDATAS5),
    .HeldTran5  (HeldTran5),
    .Active5    (Active5to0),
// busswitch input5
         
    // Port 6 Signals
    .Sel6       (Sel6to0),
    .Addr6      (Addr6),
    .Trans6     (Trans6),
    .Write6     (Write6),
    .Size6      (Size6),
    .Burst6     (Burst6),
    .Prot6      (Prot6),
    .Mastlock6  (Mastlock6),
    .Wdata6     (HWDATAS6),
    .HeldTran6  (HeldTran6),
    .Active6    (Active6to0),
// busswitch input6
         
    // Port 7 Signals
    .Sel7       (Sel7to0),
    .Addr7      (Addr7),
    .Trans7     (Trans7),
    .Write7     (Write7),
    .Size7      (Size7),
    .Burst7     (Burst7),
    .Prot7      (Prot7),
    .Mastlock7  (Mastlock7),
    .Wdata7     (HWDATAS7),
    .HeldTran7  (HeldTran7),
    .Active7    (Active7to0),
// busswitch input7
         
    // Slave Address/Control Signals
    .HSELM      (HSELM0),
    .HADDRM     (HADDRM0),
    .HTRANSM    (HTRANSM0),
    .HWRITEM    (HWRITEM0),
    .HSIZEM     (HSIZEM0),
    .HBURSTM    (HBURSTM0),
    .HPROTM     (HPROTM0),
    .HMASTLOCKM (HMASTLOCKM0),
    .HREADYM    (HREADYM0),
    .HWDATAM    (HWDATAM0),
         
    // Slave read data and response
    .HREADYOUTM (HREADYOUTM0)
    );
// busswitch output0
  
  OutputStage uOutputstage1 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .Sel0       (Sel0to1),
    .Addr0      (Addr0),
    .Trans0     (Trans0),
    .Write0     (Write0),
    .Size0      (Size0),
    .Burst0     (Burst0),
    .Prot0      (Prot0),
    .Mastlock0  (Mastlock0),
    .Wdata0     (HWDATAS0),
    .HeldTran0  (HeldTran0),
    .Active0    (Active0to1),
// busswitch input0
         
    // Port 1 Signals
    .Sel1       (Sel1to1),
    .Addr1      (Addr1),
    .Trans1     (Trans1),
    .Write1     (Write1),
    .Size1      (Size1),
    .Burst1     (Burst1),
    .Prot1      (Prot1),
    .Mastlock1  (Mastlock1),
    .Wdata1     (HWDATAS1),
    .HeldTran1  (HeldTran1),
    .Active1    (Active1to1),
// busswitch input1
         
    // Port 2 Signals
    .Sel2       (Sel2to1),
    .Addr2      (Addr2),
    .Trans2     (Trans2),
    .Write2     (Write2),
    .Size2      (Size2),
    .Burst2     (Burst2),
    .Prot2      (Prot2),
    .Mastlock2  (Mastlock2),
    .Wdata2     (HWDATAS2),
    .HeldTran2  (HeldTran2),
    .Active2    (Active2to1),
// busswitch input2
         
    // Port 3 Signals
    .Sel3       (Sel3to1),
    .Addr3      (Addr3),
    .Trans3     (Trans3),
    .Write3     (Write3),
    .Size3      (Size3),
    .Burst3     (Burst3),
    .Prot3      (Prot3),
    .Mastlock3  (Mastlock3),
    .Wdata3     (HWDATAS3),
    .HeldTran3  (HeldTran3),
    .Active3    (Active3to1),
// busswitch input3
         
    // Port 4 Signals
    .Sel4       (Sel4to1),
    .Addr4      (Addr4),
    .Trans4     (Trans4),
    .Write4     (Write4),
    .Size4      (Size4),
    .Burst4     (Burst4),
    .Prot4      (Prot4),
    .Mastlock4  (Mastlock4),
    .Wdata4     (HWDATAS4),
    .HeldTran4  (HeldTran4),
    .Active4    (Active4to1),
// busswitch input4
         
    // Port 5 Signals
    .Sel5       (Sel5to1),
    .Addr5      (Addr5),
    .Trans5     (Trans5),
    .Write5     (Write5),
    .Size5      (Size5),
    .Burst5     (Burst5),
    .Prot5      (Prot5),
    .Mastlock5  (Mastlock5),
    .Wdata5     (HWDATAS5),
    .HeldTran5  (HeldTran5),
    .Active5    (Active5to1),
// busswitch input5
         
    // Port 6 Signals
    .Sel6       (Sel6to1),
    .Addr6      (Addr6),
    .Trans6     (Trans6),
    .Write6     (Write6),
    .Size6      (Size6),
    .Burst6     (Burst6),
    .Prot6      (Prot6),
    .Mastlock6  (Mastlock6),
    .Wdata6     (HWDATAS6),
    .HeldTran6  (HeldTran6),
    .Active6    (Active6to1),
// busswitch input6
         
    // Port 7 Signals
    .Sel7       (Sel7to1),
    .Addr7      (Addr7),
    .Trans7     (Trans7),
    .Write7     (Write7),
    .Size7      (Size7),
    .Burst7     (Burst7),
    .Prot7      (Prot7),
    .Mastlock7  (Mastlock7),
    .Wdata7     (HWDATAS7),
    .HeldTran7  (HeldTran7),
    .Active7    (Active7to1),
// busswitch input7
         
    // Slave Address/Control Signals
    .HSELM      (HSELM1),
    .HADDRM     (HADDRM1),
    .HTRANSM    (HTRANSM1),
    .HWRITEM    (HWRITEM1),
    .HSIZEM     (HSIZEM1),
    .HBURSTM    (HBURSTM1),
    .HPROTM     (HPROTM1),
    .HMASTLOCKM (HMASTLOCKM1),
    .HREADYM    (HREADYM1),
    .HWDATAM    (HWDATAM1),
         
    // Slave read data and response
    .HREADYOUTM (HREADYOUTM1)
    );
// busswitch output1
  
  OutputStage uOutputstage2 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .Sel0       (Sel0to2),
    .Addr0      (Addr0),
    .Trans0     (Trans0),
    .Write0     (Write0),
    .Size0      (Size0),
    .Burst0     (Burst0),
    .Prot0      (Prot0),
    .Mastlock0  (Mastlock0),
    .Wdata0     (HWDATAS0),
    .HeldTran0  (HeldTran0),
    .Active0    (Active0to2),
// busswitch input0
         
    // Port 1 Signals
    .Sel1       (Sel1to2),
    .Addr1      (Addr1),
    .Trans1     (Trans1),
    .Write1     (Write1),
    .Size1      (Size1),
    .Burst1     (Burst1),
    .Prot1      (Prot1),
    .Mastlock1  (Mastlock1),
    .Wdata1     (HWDATAS1),
    .HeldTran1  (HeldTran1),
    .Active1    (Active1to2),
// busswitch input1
         
    // Port 2 Signals
    .Sel2       (Sel2to2),
    .Addr2      (Addr2),
    .Trans2     (Trans2),
    .Write2     (Write2),
    .Size2      (Size2),
    .Burst2     (Burst2),
    .Prot2      (Prot2),
    .Mastlock2  (Mastlock2),
    .Wdata2     (HWDATAS2),
    .HeldTran2  (HeldTran2),
    .Active2    (Active2to2),
// busswitch input2
         
    // Port 3 Signals
    .Sel3       (Sel3to2),
    .Addr3      (Addr3),
    .Trans3     (Trans3),
    .Write3     (Write3),
    .Size3      (Size3),
    .Burst3     (Burst3),
    .Prot3      (Prot3),
    .Mastlock3  (Mastlock3),
    .Wdata3     (HWDATAS3),
    .HeldTran3  (HeldTran3),
    .Active3    (Active3to2),
// busswitch input3
         
    // Port 4 Signals
    .Sel4       (Sel4to2),
    .Addr4      (Addr4),
    .Trans4     (Trans4),
    .Write4     (Write4),
    .Size4      (Size4),
    .Burst4     (Burst4),
    .Prot4      (Prot4),
    .Mastlock4  (Mastlock4),
    .Wdata4     (HWDATAS4),
    .HeldTran4  (HeldTran4),
    .Active4    (Active4to2),
// busswitch input4
         
    // Port 5 Signals
    .Sel5       (Sel5to2),
    .Addr5      (Addr5),
    .Trans5     (Trans5),
    .Write5     (Write5),
    .Size5      (Size5),
    .Burst5     (Burst5),
    .Prot5      (Prot5),
    .Mastlock5  (Mastlock5),
    .Wdata5     (HWDATAS5),
    .HeldTran5  (HeldTran5),
    .Active5    (Active5to2),
// busswitch input5
         
    // Port 6 Signals
    .Sel6       (Sel6to2),
    .Addr6      (Addr6),
    .Trans6     (Trans6),
    .Write6     (Write6),
    .Size6      (Size6),
    .Burst6     (Burst6),
    .Prot6      (Prot6),
    .Mastlock6  (Mastlock6),
    .Wdata6     (HWDATAS6),
    .HeldTran6  (HeldTran6),
    .Active6    (Active6to2),
// busswitch input6
         
    // Port 7 Signals
    .Sel7       (Sel7to2),
    .Addr7      (Addr7),
    .Trans7     (Trans7),
    .Write7     (Write7),
    .Size7      (Size7),
    .Burst7     (Burst7),
    .Prot7      (Prot7),
    .Mastlock7  (Mastlock7),
    .Wdata7     (HWDATAS7),
    .HeldTran7  (HeldTran7),
    .Active7    (Active7to2),
// busswitch input7
         
    // Slave Address/Control Signals
    .HSELM      (HSELM2),
    .HADDRM     (HADDRM2),
    .HTRANSM    (HTRANSM2),
    .HWRITEM    (HWRITEM2),
    .HSIZEM     (HSIZEM2),
    .HBURSTM    (HBURSTM2),
    .HPROTM     (HPROTM2),
    .HMASTLOCKM (HMASTLOCKM2),
    .HREADYM    (HREADYM2),
    .HWDATAM    (HWDATAM2),
         
    // Slave read data and response
    .HREADYOUTM (HREADYOUTM2)
    );
// busswitch output2
  
  OutputStage uOutputstage3 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .Sel0       (Sel0to3),
    .Addr0      (Addr0),
    .Trans0     (Trans0),
    .Write0     (Write0),
    .Size0      (Size0),
    .Burst0     (Burst0),
    .Prot0      (Prot0),
    .Mastlock0  (Mastlock0),
    .Wdata0     (HWDATAS0),
    .HeldTran0  (HeldTran0),
    .Active0    (Active0to3),
// busswitch input0
         
    // Port 1 Signals
    .Sel1       (Sel1to3),
    .Addr1      (Addr1),
    .Trans1     (Trans1),
    .Write1     (Write1),
    .Size1      (Size1),
    .Burst1     (Burst1),
    .Prot1      (Prot1),
    .Mastlock1  (Mastlock1),
    .Wdata1     (HWDATAS1),
    .HeldTran1  (HeldTran1),
    .Active1    (Active1to3),
// busswitch input1
         
    // Port 2 Signals
    .Sel2       (Sel2to3),
    .Addr2      (Addr2),
    .Trans2     (Trans2),
    .Write2     (Write2),
    .Size2      (Size2),
    .Burst2     (Burst2),
    .Prot2      (Prot2),
    .Mastlock2  (Mastlock2),
    .Wdata2     (HWDATAS2),
    .HeldTran2  (HeldTran2),
    .Active2    (Active2to3),
// busswitch input2
         
    // Port 3 Signals
    .Sel3       (Sel3to3),
    .Addr3      (Addr3),
    .Trans3     (Trans3),
    .Write3     (Write3),
    .Size3      (Size3),
    .Burst3     (Burst3),
    .Prot3      (Prot3),
    .Mastlock3  (Mastlock3),
    .Wdata3     (HWDATAS3),
    .HeldTran3  (HeldTran3),
    .Active3    (Active3to3),
// busswitch input3
         
    // Port 4 Signals
    .Sel4       (Sel4to3),
    .Addr4      (Addr4),
    .Trans4     (Trans4),
    .Write4     (Write4),
    .Size4      (Size4),
    .Burst4     (Burst4),
    .Prot4      (Prot4),
    .Mastlock4  (Mastlock4),
    .Wdata4     (HWDATAS4),
    .HeldTran4  (HeldTran4),
    .Active4    (Active4to3),
// busswitch input4
         
    // Port 5 Signals
    .Sel5       (Sel5to3),
    .Addr5      (Addr5),
    .Trans5     (Trans5),
    .Write5     (Write5),
    .Size5      (Size5),
    .Burst5     (Burst5),
    .Prot5      (Prot5),
    .Mastlock5  (Mastlock5),
    .Wdata5     (HWDATAS5),
    .HeldTran5  (HeldTran5),
    .Active5    (Active5to3),
// busswitch input5
         
    // Port 6 Signals
    .Sel6       (Sel6to3),
    .Addr6      (Addr6),
    .Trans6     (Trans6),
    .Write6     (Write6),
    .Size6      (Size6),
    .Burst6     (Burst6),
    .Prot6      (Prot6),
    .Mastlock6  (Mastlock6),
    .Wdata6     (HWDATAS6),
    .HeldTran6  (HeldTran6),
    .Active6    (Active6to3),
// busswitch input6
         
    // Port 7 Signals
    .Sel7       (Sel7to3),
    .Addr7      (Addr7),
    .Trans7     (Trans7),
    .Write7     (Write7),
    .Size7      (Size7),
    .Burst7     (Burst7),
    .Prot7      (Prot7),
    .Mastlock7  (Mastlock7),
    .Wdata7     (HWDATAS7),
    .HeldTran7  (HeldTran7),
    .Active7    (Active7to3),
// busswitch input7
         
    // Slave Address/Control Signals
    .HSELM      (HSELM3),
    .HADDRM     (HADDRM3),
    .HTRANSM    (HTRANSM3),
    .HWRITEM    (HWRITEM3),
    .HSIZEM     (HSIZEM3),
    .HBURSTM    (HBURSTM3),
    .HPROTM     (HPROTM3),
    .HMASTLOCKM (HMASTLOCKM3),
    .HREADYM    (HREADYM3),
    .HWDATAM    (HWDATAM3),
         
    // Slave read data and response
    .HREADYOUTM (HREADYOUTM3)
    );
// busswitch output3
  
  OutputStage uOutputstage4 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .Sel0       (Sel0to4),
    .Addr0      (Addr0),
    .Trans0     (Trans0),
    .Write0     (Write0),
    .Size0      (Size0),
    .Burst0     (Burst0),
    .Prot0      (Prot0),
    .Mastlock0  (Mastlock0),
    .Wdata0     (HWDATAS0),
    .HeldTran0  (HeldTran0),
    .Active0    (Active0to4),
// busswitch input0
         
    // Port 1 Signals
    .Sel1       (Sel1to4),
    .Addr1      (Addr1),
    .Trans1     (Trans1),
    .Write1     (Write1),
    .Size1      (Size1),
    .Burst1     (Burst1),
    .Prot1      (Prot1),
    .Mastlock1  (Mastlock1),
    .Wdata1     (HWDATAS1),
    .HeldTran1  (HeldTran1),
    .Active1    (Active1to4),
// busswitch input1
         
    // Port 2 Signals
    .Sel2       (Sel2to4),
    .Addr2      (Addr2),
    .Trans2     (Trans2),
    .Write2     (Write2),
    .Size2      (Size2),
    .Burst2     (Burst2),
    .Prot2      (Prot2),
    .Mastlock2  (Mastlock2),
    .Wdata2     (HWDATAS2),
    .HeldTran2  (HeldTran2),
    .Active2    (Active2to4),
// busswitch input2
         
    // Port 3 Signals
    .Sel3       (Sel3to4),
    .Addr3      (Addr3),
    .Trans3     (Trans3),
    .Write3     (Write3),
    .Size3      (Size3),
    .Burst3     (Burst3),
    .Prot3      (Prot3),
    .Mastlock3  (Mastlock3),
    .Wdata3     (HWDATAS3),
    .HeldTran3  (HeldTran3),
    .Active3    (Active3to4),
// busswitch input3
         
    // Port 4 Signals
    .Sel4       (Sel4to4),
    .Addr4      (Addr4),
    .Trans4     (Trans4),
    .Write4     (Write4),
    .Size4      (Size4),
    .Burst4     (Burst4),
    .Prot4      (Prot4),
    .Mastlock4  (Mastlock4),
    .Wdata4     (HWDATAS4),
    .HeldTran4  (HeldTran4),
    .Active4    (Active4to4),
// busswitch input4
         
    // Port 5 Signals
    .Sel5       (Sel5to4),
    .Addr5      (Addr5),
    .Trans5     (Trans5),
    .Write5     (Write5),
    .Size5      (Size5),
    .Burst5     (Burst5),
    .Prot5      (Prot5),
    .Mastlock5  (Mastlock5),
    .Wdata5     (HWDATAS5),
    .HeldTran5  (HeldTran5),
    .Active5    (Active5to4),
// busswitch input5
         
    // Port 6 Signals
    .Sel6       (Sel6to4),
    .Addr6      (Addr6),
    .Trans6     (Trans6),
    .Write6     (Write6),
    .Size6      (Size6),
    .Burst6     (Burst6),
    .Prot6      (Prot6),
    .Mastlock6  (Mastlock6),
    .Wdata6     (HWDATAS6),
    .HeldTran6  (HeldTran6),
    .Active6    (Active6to4),
// busswitch input6
         
    // Port 7 Signals
    .Sel7       (Sel7to4),
    .Addr7      (Addr7),
    .Trans7     (Trans7),
    .Write7     (Write7),
    .Size7      (Size7),
    .Burst7     (Burst7),
    .Prot7      (Prot7),
    .Mastlock7  (Mastlock7),
    .Wdata7     (HWDATAS7),
    .HeldTran7  (HeldTran7),
    .Active7    (Active7to4),
// busswitch input7
         
    // Slave Address/Control Signals
    .HSELM      (HSELM4),
    .HADDRM     (HADDRM4),
    .HTRANSM    (HTRANSM4),
    .HWRITEM    (HWRITEM4),
    .HSIZEM     (HSIZEM4),
    .HBURSTM    (HBURSTM4),
    .HPROTM     (HPROTM4),
    .HMASTLOCKM (HMASTLOCKM4),
    .HREADYM    (HREADYM4),
    .HWDATAM    (HWDATAM4),
         
    // Slave read data and response
    .HREADYOUTM (HREADYOUTM4)
    );
// busswitch output4
  
  OutputStage uOutputstage5 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .Sel0       (Sel0to5),
    .Addr0      (Addr0),
    .Trans0     (Trans0),
    .Write0     (Write0),
    .Size0      (Size0),
    .Burst0     (Burst0),
    .Prot0      (Prot0),
    .Mastlock0  (Mastlock0),
    .Wdata0     (HWDATAS0),
    .HeldTran0  (HeldTran0),
    .Active0    (Active0to5),
// busswitch input0
         
    // Port 1 Signals
    .Sel1       (Sel1to5),
    .Addr1      (Addr1),
    .Trans1     (Trans1),
    .Write1     (Write1),
    .Size1      (Size1),
    .Burst1     (Burst1),
    .Prot1      (Prot1),
    .Mastlock1  (Mastlock1),
    .Wdata1     (HWDATAS1),
    .HeldTran1  (HeldTran1),
    .Active1    (Active1to5),
// busswitch input1
         
    // Port 2 Signals
    .Sel2       (Sel2to5),
    .Addr2      (Addr2),
    .Trans2     (Trans2),
    .Write2     (Write2),
    .Size2      (Size2),
    .Burst2     (Burst2),
    .Prot2      (Prot2),
    .Mastlock2  (Mastlock2),
    .Wdata2     (HWDATAS2),
    .HeldTran2  (HeldTran2),
    .Active2    (Active2to5),
// busswitch input2
         
    // Port 3 Signals
    .Sel3       (Sel3to5),
    .Addr3      (Addr3),
    .Trans3     (Trans3),
    .Write3     (Write3),
    .Size3      (Size3),
    .Burst3     (Burst3),
    .Prot3      (Prot3),
    .Mastlock3  (Mastlock3),
    .Wdata3     (HWDATAS3),
    .HeldTran3  (HeldTran3),
    .Active3    (Active3to5),
// busswitch input3
         
    // Port 4 Signals
    .Sel4       (Sel4to5),
    .Addr4      (Addr4),
    .Trans4     (Trans4),
    .Write4     (Write4),
    .Size4      (Size4),
    .Burst4     (Burst4),
    .Prot4      (Prot4),
    .Mastlock4  (Mastlock4),
    .Wdata4     (HWDATAS4),
    .HeldTran4  (HeldTran4),
    .Active4    (Active4to5),
// busswitch input4
         
    // Port 5 Signals
    .Sel5       (Sel5to5),
    .Addr5      (Addr5),
    .Trans5     (Trans5),
    .Write5     (Write5),
    .Size5      (Size5),
    .Burst5     (Burst5),
    .Prot5      (Prot5),
    .Mastlock5  (Mastlock5),
    .Wdata5     (HWDATAS5),
    .HeldTran5  (HeldTran5),
    .Active5    (Active5to5),
// busswitch input5
         
    // Port 6 Signals
    .Sel6       (Sel6to5),
    .Addr6      (Addr6),
    .Trans6     (Trans6),
    .Write6     (Write6),
    .Size6      (Size6),
    .Burst6     (Burst6),
    .Prot6      (Prot6),
    .Mastlock6  (Mastlock6),
    .Wdata6     (HWDATAS6),
    .HeldTran6  (HeldTran6),
    .Active6    (Active6to5),
// busswitch input6
         
    // Port 7 Signals
    .Sel7       (Sel7to5),
    .Addr7      (Addr7),
    .Trans7     (Trans7),
    .Write7     (Write7),
    .Size7      (Size7),
    .Burst7     (Burst7),
    .Prot7      (Prot7),
    .Mastlock7  (Mastlock7),
    .Wdata7     (HWDATAS7),
    .HeldTran7  (HeldTran7),
    .Active7    (Active7to5),
// busswitch input7
         
    // Slave Address/Control Signals
    .HSELM      (HSELM5),
    .HADDRM     (HADDRM5),
    .HTRANSM    (HTRANSM5),
    .HWRITEM    (HWRITEM5),
    .HSIZEM     (HSIZEM5),
    .HBURSTM    (HBURSTM5),
    .HPROTM     (HPROTM5),
    .HMASTLOCKM (HMASTLOCKM5),
    .HREADYM    (HREADYM5),
    .HWDATAM    (HWDATAM5),
         
    // Slave read data and response
    .HREADYOUTM (HREADYOUTM5)
    );
// busswitch output5
  
  OutputStage uOutputstage6 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .Sel0       (Sel0to6),
    .Addr0      (Addr0),
    .Trans0     (Trans0),
    .Write0     (Write0),
    .Size0      (Size0),
    .Burst0     (Burst0),
    .Prot0      (Prot0),
    .Mastlock0  (Mastlock0),
    .Wdata0     (HWDATAS0),
    .HeldTran0  (HeldTran0),
    .Active0    (Active0to6),
// busswitch input0
         
    // Port 1 Signals
    .Sel1       (Sel1to6),
    .Addr1      (Addr1),
    .Trans1     (Trans1),
    .Write1     (Write1),
    .Size1      (Size1),
    .Burst1     (Burst1),
    .Prot1      (Prot1),
    .Mastlock1  (Mastlock1),
    .Wdata1     (HWDATAS1),
    .HeldTran1  (HeldTran1),
    .Active1    (Active1to6),
// busswitch input1
         
    // Port 2 Signals
    .Sel2       (Sel2to6),
    .Addr2      (Addr2),
    .Trans2     (Trans2),
    .Write2     (Write2),
    .Size2      (Size2),
    .Burst2     (Burst2),
    .Prot2      (Prot2),
    .Mastlock2  (Mastlock2),
    .Wdata2     (HWDATAS2),
    .HeldTran2  (HeldTran2),
    .Active2    (Active2to6),
// busswitch input2
         
    // Port 3 Signals
    .Sel3       (Sel3to6),
    .Addr3      (Addr3),
    .Trans3     (Trans3),
    .Write3     (Write3),
    .Size3      (Size3),
    .Burst3     (Burst3),
    .Prot3      (Prot3),
    .Mastlock3  (Mastlock3),
    .Wdata3     (HWDATAS3),
    .HeldTran3  (HeldTran3),
    .Active3    (Active3to6),
// busswitch input3
         
    // Port 4 Signals
    .Sel4       (Sel4to6),
    .Addr4      (Addr4),
    .Trans4     (Trans4),
    .Write4     (Write4),
    .Size4      (Size4),
    .Burst4     (Burst4),
    .Prot4      (Prot4),
    .Mastlock4  (Mastlock4),
    .Wdata4     (HWDATAS4),
    .HeldTran4  (HeldTran4),
    .Active4    (Active4to6),
// busswitch input4
         
    // Port 5 Signals
    .Sel5       (Sel5to6),
    .Addr5      (Addr5),
    .Trans5     (Trans5),
    .Write5     (Write5),
    .Size5      (Size5),
    .Burst5     (Burst5),
    .Prot5      (Prot5),
    .Mastlock5  (Mastlock5),
    .Wdata5     (HWDATAS5),
    .HeldTran5  (HeldTran5),
    .Active5    (Active5to6),
// busswitch input5
         
    // Port 6 Signals
    .Sel6       (Sel6to6),
    .Addr6      (Addr6),
    .Trans6     (Trans6),
    .Write6     (Write6),
    .Size6      (Size6),
    .Burst6     (Burst6),
    .Prot6      (Prot6),
    .Mastlock6  (Mastlock6),
    .Wdata6     (HWDATAS6),
    .HeldTran6  (HeldTran6),
    .Active6    (Active6to6),
// busswitch input6
         
    // Port 7 Signals
    .Sel7       (Sel7to6),
    .Addr7      (Addr7),
    .Trans7     (Trans7),
    .Write7     (Write7),
    .Size7      (Size7),
    .Burst7     (Burst7),
    .Prot7      (Prot7),
    .Mastlock7  (Mastlock7),
    .Wdata7     (HWDATAS7),
    .HeldTran7  (HeldTran7),
    .Active7    (Active7to6),
// busswitch input7
         
    // Slave Address/Control Signals
    .HSELM      (HSELM6),
    .HADDRM     (HADDRM6),
    .HTRANSM    (HTRANSM6),
    .HWRITEM    (HWRITEM6),
    .HSIZEM     (HSIZEM6),
    .HBURSTM    (HBURSTM6),
    .HPROTM     (HPROTM6),
    .HMASTLOCKM (HMASTLOCKM6),
    .HREADYM    (HREADYM6),
    .HWDATAM    (HWDATAM6),
         
    // Slave read data and response
    .HREADYOUTM (HREADYOUTM6)
    );
// busswitch output6
  
  OutputStage uOutputstage7 
    (
    .HCLK       (HCLK),
    .HRESETn    (HRESETn),

    // Port 0 Signals
    .Sel0       (Sel0to7),
    .Addr0      (Addr0),
    .Trans0     (Trans0),
    .Write0     (Write0),
    .Size0      (Size0),
    .Burst0     (Burst0),
    .Prot0      (Prot0),
    .Mastlock0  (Mastlock0),
    .Wdata0     (HWDATAS0),
    .HeldTran0  (HeldTran0),
    .Active0    (Active0to7),
// busswitch input0
         
    // Port 1 Signals
    .Sel1       (Sel1to7),
    .Addr1      (Addr1),
    .Trans1     (Trans1),
    .Write1     (Write1),
    .Size1      (Size1),
    .Burst1     (Burst1),
    .Prot1      (Prot1),
    .Mastlock1  (Mastlock1),
    .Wdata1     (HWDATAS1),
    .HeldTran1  (HeldTran1),
    .Active1    (Active1to7),
// busswitch input1
         
    // Port 2 Signals
    .Sel2       (Sel2to7),
    .Addr2      (Addr2),
    .Trans2     (Trans2),
    .Write2     (Write2),
    .Size2      (Size2),
    .Burst2     (Burst2),
    .Prot2      (Prot2),
    .Mastlock2  (Mastlock2),
    .Wdata2     (HWDATAS2),
    .HeldTran2  (HeldTran2),
    .Active2    (Active2to7),
// busswitch input2
         
    // Port 3 Signals
    .Sel3       (Sel3to7),
    .Addr3      (Addr3),
    .Trans3     (Trans3),
    .Write3     (Write3),
    .Size3      (Size3),
    .Burst3     (Burst3),
    .Prot3      (Prot3),
    .Mastlock3  (Mastlock3),
    .Wdata3     (HWDATAS3),
    .HeldTran3  (HeldTran3),
    .Active3    (Active3to7),
// busswitch input3
         
    // Port 4 Signals
    .Sel4       (Sel4to7),
    .Addr4      (Addr4),
    .Trans4     (Trans4),
    .Write4     (Write4),
    .Size4      (Size4),
    .Burst4     (Burst4),
    .Prot4      (Prot4),
    .Mastlock4  (Mastlock4),
    .Wdata4     (HWDATAS4),
    .HeldTran4  (HeldTran4),
    .Active4    (Active4to7),
// busswitch input4
         
    // Port 5 Signals
    .Sel5       (Sel5to7),
    .Addr5      (Addr5),
    .Trans5     (Trans5),
    .Write5     (Write5),
    .Size5      (Size5),
    .Burst5     (Burst5),
    .Prot5      (Prot5),
    .Mastlock5  (Mastlock5),
    .Wdata5     (HWDATAS5),
    .HeldTran5  (HeldTran5),
    .Active5    (Active5to7),
// busswitch input5
         
    // Port 6 Signals
    .Sel6       (Sel6to7),
    .Addr6      (Addr6),
    .Trans6     (Trans6),
    .Write6     (Write6),
    .Size6      (Size6),
    .Burst6     (Burst6),
    .Prot6      (Prot6),
    .Mastlock6  (Mastlock6),
    .Wdata6     (HWDATAS6),
    .HeldTran6  (HeldTran6),
    .Active6    (Active6to7),
// busswitch input6
         
    // Port 7 Signals
    .Sel7       (Sel7to7),
    .Addr7      (Addr7),
    .Trans7     (Trans7),
    .Write7     (Write7),
    .Size7      (Size7),
    .Burst7     (Burst7),
    .Prot7      (Prot7),
    .Mastlock7  (Mastlock7),
    .Wdata7     (HWDATAS7),
    .HeldTran7  (HeldTran7),
    .Active7    (Active7to7),
// busswitch input7
         
    // Slave Address/Control Signals
    .HSELM      (HSELM7),
    .HADDRM     (HADDRM7),
    .HTRANSM    (HTRANSM7),
    .HWRITEM    (HWRITEM7),
    .HSIZEM     (HSIZEM7),
    .HBURSTM    (HBURSTM7),
    .HPROTM     (HPROTM7),
    .HMASTLOCKM (HMASTLOCKM7),
    .HREADYM    (HREADYM7),
    .HWDATAM    (HWDATAM7),
         
    // Slave read data and response
    .HREADYOUTM (HREADYOUTM7)
    );
// busswitch output7

  
endmodule


