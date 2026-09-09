//============================================================================--
//  This confidential and proprietary software may be used only as
//  authorised by a licensing agreement from ARM Limited
//    (C) COPYRIGHT 2003-2005 ARM Limited
//        ALL RIGHTS RESERVED
//  The entire notice above must be reproduced on all authorised
//  copies and copies may only be made to the extent permitted
//  by a licensing agreement from ARM Limited.
//
//
//------------------------------------------------------------------------------
//  Version and Release Control Information:
//
//  File Name           : AxiPC.sv,v
//  File Revision       : 1.2
//
//  Release Information : BP062-VL-70004-r0p0-00dev0
//
//------------------------------------------------------------------------------
//  Purpose             : This is the AXI Protocol Checker using SVA
//
//                        Supports bus widths of 32, 64, 128, 256, 512, 1024 bit
//                        Parameterisable write interleave depth
//                        Supports a single outstanding exclusive read per ID
//============================================================================--

//----------------------------------------------------------------------------
// CONTENTS
// ========
//  275.  Module: AxiPC
//  342.    1) Parameters
//  346.         - Configurable (user can set)
//  394.         - Calculated (user should not override)
//  458.    2) Inputs (no outputs)
//  462.         - Global Signals
//  468.         - Write Address Channel
//  483.         - Write Data Channel
//  494.         - Write Response Channel
//  503.         - Read Address Channel
//  518.         - Read Data Channel
//  528.         - Low Power Interface
//  536.    3) Wire and Reg Declarations
//  635.    4) Verilog Defines
//  656.    5) Format for time reporting
//  663. 
//  664.  AXI Rules: Write Address Channel (*_AW*)
//  669.    1) Functional Rules
//  673.         - AXI_ERRM_AWADDR_BOUNDARY
//  697.         - AXI_ERRM_AWADDR_WRAP_ALIGN
//  709.         - AXI_ERRM_AWBURST
//  721.         - AXI_ERRM_AWCACHE
//  733.         - AXI_ERRM_AWLEN_WRAP
//  748.         - AXI_ERRM_AWLOCK
//  760.         - AXI_ERRM_AWLOCK_END
//  776.         - AXI_ERRM_AWLOCK_ID
//  790.         - AXI_ERRM_AWLOCK_LAST
//  804.         - AXI_ERRM_AWLOCK_START
//  820.         - AXI_ERRM_AWSIZE
//  834.         - AXI_ERRM_AWVALID_RESET
//  846.         - AXI_RECM_AWLOCK_BOUNDARY
//  862.         - AXI_RECM_AWLOCK_CTRL 
//  877.         - AXI_RECM_AWLOCK_NUM
//  893.    2) Handshake Rules
//  897.         - AXI_ERRM_AWADDR_STABLE
//  910.         - AXI_ERRM_AWBURST_STABLE
//  923.         - AXI_ERRM_AWCACHE_STABLE
//  936.         - AXI_ERRM_AWID_STABLE
//  949.         - AXI_ERRM_AWLEN_STABLE
//  962.         - AXI_ERRM_AWLOCK_STABLE
//  975.         - AXI_ERRM_AWPROT_STABLE
//  988.         - AXI_ERRM_AWSIZE_STABLE
// 1001.         - AXI_ERRM_AWVALID_STABLE
// 1013.         - AXI_RECS_AWREADY_MAX_WAIT
// 1027.    3) X-Propagation Rules
// 1033.         - AXI_ERRM_AWADDR_X
// 1044.         - AXI_ERRM_AWBURST_X
// 1055.         - AXI_ERRM_AWCACHE_X
// 1066.         - AXI_ERRM_AWID_X
// 1077.         - AXI_ERRM_AWLEN_X
// 1088.         - AXI_ERRM_AWLOCK_X
// 1099.         - AXI_ERRM_AWPROT_X
// 1110.         - AXI_ERRM_AWSIZE_X
// 1121.         - AXI_ERRM_AWVALID_X
// 1132.         - AXI_ERRS_AWREADY_X
// 1146. 
// 1147.  AXI Rules: Write Data Channel (*_W*)
// 1152.    1) Functional Rules
// 1156.         - AXI_ERRM_WDATA_NUM
// 1171.         - AXI_ERRM_WDATA_ORDER
// 1182.         - AXI_ERRM_WDEPTH
// 1194.         - AXI_ERRM_WSTRB
// 1205.         - AXI_ERRM_WVALID_RESET
// 1218.    2) Handshake Rules
// 1222.         - AXI_ERRM_WDATA_STABLE
// 1235.         - AXI_ERRM_WID_STABLE
// 1248.         - AXI_ERRM_WLAST_STABLE
// 1261.         - AXI_ERRM_WSTRB_STABLE
// 1274.         - AXI_ERRM_WVALID_STABLE
// 1286.         - AXI_RECS_WREADY_MAX_WAIT 
// 1300.    3) X-Propagation Rules
// 1306.         - AXI_ERRM_WDATA_X
// 1317.         - AXI_ERRM_WID_X
// 1328.         - AXI_ERRM_WLAST_X
// 1339.         - AXI_ERRM_WSTRB_X
// 1350.         - AXI_ERRM_WVALID_X
// 1361.         - AXI_ERRS_WREADY_X
// 1375. 
// 1376.  AXI Rules: Write Response Channel (*_B*)
// 1381.    1) Functional Rules
// 1385.         - AXI_ERRS_BRESP
// 1396.         - AXI_ERRS_BRESP_ALL_DONE_EOS
// 1413.         - AXI_ERRS_BRESP_EXOKAY
// 1424.         - AXI_ERRS_BVALID_RESET
// 1437.    2) Handshake Rules
// 1441.         - AXI_ERRS_BID_STABLE
// 1454.         - AXI_ERRS_BRESP_STABLE
// 1467.         - AXI_ERRS_BVALID_STABLE
// 1479.         - AXI_RECM_BREADY_MAX_WAIT 
// 1493.    3) X-Propagation Rules
// 1499.         - AXI_ERRM_BREADY_X
// 1510.         - AXI_ERRS_BID_X
// 1521.         - AXI_ERRS_BRESP_X
// 1532.         - AXI_ERRS_BVALID_X
// 1546. 
// 1547.  AXI Rules: Read Address Channel (*_AR*)
// 1552.    1) Functional Rules
// 1556.         - AXI_ERRM_ARADDR_BOUNDARY
// 1580.         - AXI_ERRM_ARADDR_WRAP_ALIGN
// 1592.         - AXI_ERRM_ARBURST
// 1604.         - AXI_ERRM_ARCACHE
// 1616.         - AXI_ERRM_ARLEN_WRAP
// 1631.         - AXI_ERRM_ARLOCK
// 1643.         - AXI_ERRM_ARLOCK_END
// 1659.         - AXI_ERRM_ARLOCK_ID
// 1673.         - AXI_ERRM_ARLOCK_LAST
// 1687.         - AXI_ERRM_ARLOCK_START
// 1703.         - AXI_ERRM_ARSIZE
// 1715.         - AXI_ERRM_ARVALID_RESET
// 1727.         - AXI_RECM_ARLOCK_BOUNDARY
// 1743.         - AXI_RECM_ARLOCK_CTRL
// 1758.         - AXI_RECM_ARLOCK_NUM
// 1774.    2) Handshake Rules
// 1778.         - AXI_ERRM_ARADDR_STABLE
// 1791.         - AXI_ERRM_ARBURST_STABLE
// 1804.         - AXI_ERRM_ARCACHE_STABLE
// 1817.         - AXI_ERRM_ARID_STABLE
// 1830.         - AXI_ERRM_ARLEN_STABLE
// 1843.         - AXI_ERRM_ARLOCK_STABLE
// 1856.         - AXI_ERRM_ARPROT_STABLE
// 1869.         - AXI_ERRM_ARSIZE_STABLE
// 1882.         - AXI_ERRM_ARVALID_STABLE
// 1894.         - AXI_RECS_ARREADY_MAX_WAIT 
// 1908.    3) X-Propagation Rules
// 1914.         - AXI_ERRM_ARADDR_X
// 1925.         - AXI_ERRM_ARBURST_X
// 1936.         - AXI_ERRM_ARCACHE_X
// 1947.         - AXI_ERRM_ARID_X
// 1958.         - AXI_ERRM_ARLEN_X
// 1969.         - AXI_ERRM_ARLOCK_X
// 1980.         - AXI_ERRM_ARPROT_X
// 1991.         - AXI_ERRM_ARSIZE_X
// 2002.         - AXI_ERRM_ARVALID_X
// 2013.         - AXI_ERRS_ARREADY_X
// 2027. 
// 2028.  AXI Rules: Read Data Channel (*_R*)
// 2033.    1) Functional Rules
// 2037.         - AXI_ERRS_RDATA_NUM
// 2051.         - AXI_ERRS_RLAST_ALL_DONE_EOS
// 2068.         - AXI_ERRS_RID
// 2081.         - AXI_ERRS_RRESP_EXOKAY
// 2093.         - AXI_ERRS_RVALID_RESET
// 2106.    2) Handshake Rules
// 2110.         - AXI_ERRS_RDATA_STABLE
// 2123.         - AXI_ERRS_RID_STABLE
// 2136.         - AXI_ERRS_RLAST_STABLE
// 2149.         - AXI_ERRS_RRESP_STABLE
// 2162.         - AXI_ERRS_RVALID_STABLE
// 2174.         - AXI_RECM_RREADY_MAX_WAIT 
// 2188.    3) X-Propagation Rules
// 2194.         - AXI_ERRM_RREADY_X
// 2205.         - AXI_ERRS_RID_X
// 2216.         - AXI_ERRS_RLAST_X
// 2227.         - AXI_ERRS_RRESP_X
// 2238.         - AXI_ERRS_RVALID_X
// 2252. 
// 2253.  AXI Rules: Low Power Interface (*_C*)
// 2258.    1) Functional Rules (none for Low Power signals)
// 2263.    2) Handshake Rules (asynchronous to ACLK)
// 2270.         - AXI_ERRL_CSYSACK_FALL
// 2281.         - AXI_ERRL_CSYSACK_RISE
// 2292.         - AXI_ERRL_CSYSREQ_FALL
// 2303.         - AXI_ERRL_CSYSREQ_RISE
// 2315.    3) X-Propagation Rules
// 2321.         - AXI_ERRL_CACTIVE_X
// 2332.         - AXI_ERRL_CSYSACK_X
// 2343.         - AXI_ERRL_CSYSREQ_X
// 2357. 
// 2358.  AXI Rules: Exclusive Access
// 2366.    1) Functional Rules
// 2368.         -
// 2371.         - AXI_ERRM_EXCL_ALIGN
// 2392.         - AXI_ERRM_EXCL_LEN
// 2410.         - AXI_ERRM_EXCL_MATCH
// 2430.         - AXI_ERRM_EXCL_MAX
// 2451.         - AXI_ERRM_EXCL_PAIR
// 2464. 
// 2465.  AXI Rules: USER_* Rules (extension to AXI)
// 2473.    1) Functional Rules (none for USER signals)
// 2478.    2) Handshake Rules
// 2482.         - AXI_ERRM_AWUSER_STABLE
// 2495.         - AXI_ERRM_WUSER_STABLE
// 2508.         - AXI_ERRS_BUSER_STABLE
// 2521.         - AXI_ERRM_ARUSER_STABLE
// 2534.         - AXI_ERRS_RUSER_STABLE
// 2548.    3) X-Propagation Rules
// 2554.         - AXI_ERRM_AWUSER_X
// 2565.         - AXI_ERRM_WUSER_X
// 2576.         - AXI_ERRS_BUSER_X
// 2587.         - AXI_ERRM_ARUSER_X
// 2598.         - AXI_ERRS_RUSER_X
// 2612. 
// 2613.  Auxiliary Logic
// 2618.    1) Rules for Auxiliary Logic
// 2623.       a) Master (AUXM*)
// 2627.         - AXI_AUXM_DATA_WIDTH
// 2642.         - AXI_AUXM_RCAM_OVERFLOW
// 2653.         - AXI_AUXM_RCAM_UNDERFLOW
// 2664.         - AXI_AUXM_WCAM_OVERFLOW
// 2675.         - AXI_AUXM_WCAM_UNDERFLOW
// 2687.    2) Combinatorial Logic
// 2692.       a) Masks
// 2696.            - AlignMaskR
// 2718.            - AlignMaskW
// 2740.            - ExclMask
// 2748.            - WdataMask
// 2762.       b) Increments
// 2766.            - ArAddrIncr
// 2774.            - AwAddrIncr
// 2783.       c) Conversions
// 2787.            - ArLenInBytes
// 2795.            - ArSizeInBits
// 2803.            - AwSizeInBits
// 2812.       d) Other
// 2816.            - ArExclPending
// 2822.            - ArLenPending
// 2829.    3) EXCL & LOCK Accesses
// 2833.         - Exclusive Access Storage
// 2881.         - Lock State Machine
// 2924.         - Lock Storage
// 2947.         - Lock Arrays
// 3015.    4) Content addressable memories (CAMs)
// 3019.         - Read CAMSs (CAM+Shift)
// 3126.         - Write CAMs (CAM+Shift)
// 3422.         - Write Depth array
// 3461.    5) Verilog Functions
// 3465.         - CheckBurst
// 3564.         - CheckStrb
// 3602.         - CheckXorZ
// 3619.         - CheckXorZifValid
// 3641. 
// 3642.  End of File
// 3647.    1) Clear Verilog Defines
// 3668.    2) End of module
//----------------------------------------------------------------------------

`timescale 1ns/1ns

//------------------------------------------------------------------------------
// AXI Standard Defines
//------------------------------------------------------------------------------
`include "Axi.v"


//------------------------------------------------------------------------------
// INDEX: Module: AxiPC
//------------------------------------------------------------------------------
module AxiPC
  (
   // Global Signals
   ACLK,
   ARESETn,

   // Write Address Channel
   AWID,
   AWADDR,
   AWLEN,
   AWSIZE,
   AWBURST,
   AWLOCK,
   AWCACHE,
   AWPROT,
   AWUSER,
   AWVALID,
   AWREADY,

   // Write Channel
   WID,
   WLAST,
   WDATA,
   WSTRB,
   WUSER,
   WVALID,
   WREADY,

   // Write Response Channel
   BID,
   BRESP,
   BUSER,
   BVALID,
   BREADY,

   // Read Address Channel
   ARID,
   ARADDR,
   ARLEN,
   ARSIZE,
   ARBURST,
   ARLOCK,
   ARCACHE,
   ARPROT,
   ARUSER,
   ARVALID,
   ARREADY,

   // Read Channel
   RID,
   RLAST,
   RDATA,
   RRESP,
   RUSER,
   RVALID,
   RREADY,

   // Low power interface
   CACTIVE,
   CSYSREQ,
   CSYSACK
   );


//------------------------------------------------------------------------------
// INDEX:   1) Parameters
//------------------------------------------------------------------------------


  // INDEX:        - Configurable (user can set)
  // =====
  // Parameters below can be set by the user.

  // Set DATA_WIDTH to the data-bus width required
  parameter DATA_WIDTH = 64;         // data bus width, default = 64-bit

  // Select the number of channel ID bits required
  parameter ID_WIDTH = 4;          // (A|W|R|B)ID width

  // Select the size of the USER buses, default = 32-bit
  parameter AWUSER_WIDTH = 32; // width of the user AW sideband field
  parameter WUSER_WIDTH  = 32; // width of the user W  sideband field
  parameter BUSER_WIDTH  = 32; // width of the user B  sideband field
  parameter ARUSER_WIDTH = 32; // width of the user AR sideband field
  parameter RUSER_WIDTH  = 32; // width of the user R  sideband field

  // Write-interleave Depth of monitored slave interface
  parameter WDEPTH = 1;

  // Size of CAMs for storing outstanding read bursts, this should match or
  // exceed the number of outstanding read addresses accepted into the slave
  // interface
  parameter MAXRBURSTS = 16;

  // Size of CAMs for storing outstanding write bursts, this should match or
  // exceed the number of outstanding write bursts into the slave  interface
  parameter MAXWBURSTS = 16;

  // Maximum number of cycles between VALID -> READY high before a warning is
  // generated
  parameter MAXWAITS = 16;

  // Formal Verification (0=prove, 1=assume, 2=cover, 3=ignore).
  parameter AXI_ERRM_ProofOptions = 0; // default: prove Master is AXI compliant
  parameter AXI_RECM_ProofOptions = 0; // default: prove Master is AXI compliant
  parameter AXI_AUXM_ProofOptions = 0; // default: prove Master auxiliary logic checks
  //
  parameter AXI_ERRS_ProofOptions = 0; // default: prove Slave is AXI compliant
  parameter AXI_RECS_ProofOptions = 0; // default: prove Slave is AXI compliant
  parameter AXI_AUXS_ProofOptions = 0; // default: prove Slave auxiliary logic checks
  //
  parameter AXI_ERRL_ProofOptions = 0; // default: prove LP Int is AXI compliant

  // Recommended Rules Enable
  parameter RecommendOn   = 1'b1;   // enable/disable reporting of REC* rules


  // INDEX:        - Calculated (user should not override)
  // =====
  // Do not override the following parameters: they must be calculated exactly
  // as shown below
  parameter DATA_MAX   = DATA_WIDTH-1; // data max index
  parameter STRB_WIDTH = DATA_WIDTH/8; // WSTRB width
  parameter STRB_MAX   = STRB_WIDTH-1; // WSTRB max index
  parameter STRB_1     = {{STRB_MAX{1'b0}}, 1'b1};  // value 1 in strobe width
  parameter ID_MAX     = ID_WIDTH-1;   // ID max index
  parameter ID_HI      = (1 << ID_WIDTH) - 1; // ID max value

  parameter AWUSER_MAX = AWUSER_WIDTH-1; // AWUSER max index
  parameter  WUSER_MAX =  WUSER_WIDTH-1; // WUSER  max index
  parameter  BUSER_MAX =  BUSER_WIDTH-1; // BUSER  max index
  parameter ARUSER_MAX = ARUSER_WIDTH-1; // ARUSER max index
  parameter  RUSER_MAX =  RUSER_WIDTH-1; // RUSER  max index

  // WSTRB16...WSTRB1 ID BURST[1:0] ASIZE[2:0] ALEN[3:0] LAST ADDR[3:0]
  parameter ADDRLO   = 0;                 // ADDRLO   =   0
  parameter ADDRHI   = 6;                 // ADDRHI   =   6
  parameter EXCL     = ADDRHI + 1;        // EXCL     =   7 if ADDRHI=6 (ADDRHI+1)
  parameter ALENLO   = EXCL + 1;          // ALENLO   =   8 if ADDRHI=6 (ADDRHI+2)
  parameter ALENHI   = ALENLO + 3;        // ALENHI   =  11 if ADDRHI=6 (ADDRHI+5)
  parameter ASIZELO  = ALENHI + 1;        // ASIZELO  =  12 if ADDRHI=6 (ADDRHI+6)
  parameter ASIZEHI  = ASIZELO + 2;       // ASIZEHI  =  14 if ADDRHI=6 (ADDRHI+8)
  parameter BURSTLO  = ASIZEHI + 1;       // BURSTLO  =  15 if ADDRHI=6 (ADDRHI+9)
  parameter BURSTHI  = BURSTLO + 1;       // BURSTHI  =  16 if ADDRHI=6 (ADDRHI+10)
  parameter IDLO     = BURSTHI + 1;       // IDLO     =  17 if ADDRHI=6 (ADDRHI+11)
  parameter IDHI     = IDLO+ID_MAX;       // IDHI     =  20 if ADDRHI=6 & ID_WIDTH=4
  parameter STRB1LO  = IDHI+1;            // STRB1LO  =  21 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB1HI  = STRB1LO+STRB_MAX;  // STRB1HI  =  28 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB2LO  = STRB1HI+1;         // STRB2LO  =  29 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB2HI  = STRB2LO+STRB_MAX;  // STRB2HI  =  36 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB3LO  = STRB2HI+1;         // STRB3LO  =  37 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB3HI  = STRB3LO+STRB_MAX;  // STRB3HI  =  44 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB4LO  = STRB3HI+1;         // STRB4LO  =  45 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB4HI  = STRB4LO+STRB_MAX;  // STRB4HI  =  52 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB5LO  = STRB4HI+1;         // STRB5LO  =  53 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB5HI  = STRB5LO+STRB_MAX;  // STRB5HI  =  60 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB6LO  = STRB5HI+1;         // STRB6LO  =  61 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB6HI  = STRB6LO+STRB_MAX;  // STRB6HI  =  68 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB7LO  = STRB6HI+1;         // STRB7LO  =  69 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB7HI  = STRB7LO+STRB_MAX;  // STRB7HI  =  76 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB8LO  = STRB7HI+1;         // STRB8LO  =  77 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB8HI  = STRB8LO+STRB_MAX;  // STRB8HI  =  84 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB9LO  = STRB8HI+1;         // STRB9LO  =  85 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB9HI  = STRB9LO+STRB_MAX;  // STRB9HI  =  92 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB10LO = STRB9HI+1;         // STRB10LO =  93 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB10HI = STRB10LO+STRB_MAX; // STRB10HI = 100 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB11LO = STRB10HI+1;        // STRB11LO = 101 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB11HI = STRB11LO+STRB_MAX; // STRB11HI = 108 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB12LO = STRB11HI+1;        // STRB12LO = 109 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB12HI = STRB12LO+STRB_MAX; // STRB12HI = 116 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB13LO = STRB12HI+1;        // STRB13LO = 117 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB13HI = STRB13LO+STRB_MAX; // STRB13HI = 124 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB14LO = STRB13HI+1;        // STRB14LO = 125 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB14HI = STRB14LO+STRB_MAX; // STRB14HI = 132 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB15LO = STRB14HI+1;        // STRB15LO = 133 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB15HI = STRB15LO+STRB_MAX; // STRB15HI = 140 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB16LO = STRB15HI+1;        // STRB16LO = 141 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7
  parameter STRB16HI = STRB16LO+STRB_MAX; // STRB16HI = 148 if ADDRHI=6 & ID_WIDTH=4 & STRB_MAX=7


//------------------------------------------------------------------------------
// INDEX:   2) Inputs (no outputs)
//------------------------------------------------------------------------------


  // INDEX:        - Global Signals
  // =====
  input                ACLK;        // AXI Clock
  input                ARESETn;     // AXI Reset


  // INDEX:        - Write Address Channel
  // =====
  input     [ID_MAX:0] AWID;
  input         [31:0] AWADDR;
  input          [3:0] AWLEN;
  input          [2:0] AWSIZE;
  input          [1:0] AWBURST;
  input          [3:0] AWCACHE;
  input          [2:0] AWPROT;
  input          [1:0] AWLOCK;
  input [AWUSER_MAX:0] AWUSER;
  input                AWVALID;
  input                AWREADY;


  // INDEX:        - Write Data Channel
  // =====
  input     [ID_MAX:0] WID;
  input   [DATA_MAX:0] WDATA;
  input   [STRB_MAX:0] WSTRB;
  input  [WUSER_MAX:0] WUSER;
  input                WLAST;
  input                WVALID;
  input                WREADY;


  // INDEX:        - Write Response Channel
  // =====
  input     [ID_MAX:0] BID;
  input          [1:0] BRESP;
  input  [BUSER_MAX:0] BUSER;
  input                BVALID;
  input                BREADY;


  // INDEX:        - Read Address Channel
  // =====
  input     [ID_MAX:0] ARID;
  input         [31:0] ARADDR;
  input          [3:0] ARLEN;
  input          [2:0] ARSIZE;
  input          [1:0] ARBURST;
  input          [3:0] ARCACHE;
  input          [2:0] ARPROT;
  input          [1:0] ARLOCK;
  input [ARUSER_MAX:0] ARUSER;
  input                ARVALID;
  input                ARREADY;


  // INDEX:        - Read Data Channel
  // =====
  input     [ID_MAX:0] RID;
  input   [DATA_MAX:0] RDATA;
  input          [1:0] RRESP;
  input  [RUSER_MAX:0] RUSER;
  input                RLAST;
  input                RVALID;
  input                RREADY;

  // INDEX:        - Low Power Interface
  // =====
  input                CACTIVE;
  input                CSYSREQ;
  input                CSYSACK;


//------------------------------------------------------------------------------
// INDEX:   3) Wire and Reg Declarations
//------------------------------------------------------------------------------

  // User signal definitions are defined as weak pull-down in the case
  // that they are unconnected.
  tri0 [AWUSER_MAX:0] AWUSER;
  tri0  [WUSER_MAX:0] WUSER;
  tri0  [BUSER_MAX:0] BUSER;
  tri0 [ARUSER_MAX:0] ARUSER;
  tri0  [RUSER_MAX:0] RUSER;

  // Low power interface signals are defined as weak pull-up in the case
  // that they are unconnected.
  tri1                CACTIVE;
  tri1                CSYSREQ;
  tri1                CSYSACK;

  // Write CAMs
  integer            WIndex;
  reg [STRB16HI:0]   WBurstCam[1:MAXWBURSTS]; // store outstanding write bursts
  reg [4:0]          WCountCam[1:MAXWBURSTS]; // number of write data stored
  reg                WLastCam[1:MAXWBURSTS];  // WLAST for outstanding writes
  reg                WAddrCam[1:MAXWBURSTS];  // flag for valid write addr
  reg                BRespCam[1:MAXWBURSTS];  // flag for valid write resp
  wire               nWOutstanding;       // flag for no write bursts oustanding
                                          // except for current valid write id

  // WDepth array
  reg [ID_HI:0]      WidInUse;     // WIDs in use for write depth check
  reg [ID_HI:0]      WidInUseNext; // Next value of WidInUse
  integer            WidDepth;

  // Read CAMs
  reg [3:0]          RLenCam[1:MAXRBURSTS];
  reg [ID_MAX:0]     RIdCam[1:MAXRBURSTS];
  reg                RExclCam[1:MAXRBURSTS];
  integer            RIndex;
  integer            RIndexNext;
  wire               RPop;
  wire               RPush;
  wire               nROutstanding; // flag for no read bursts oustanding
  reg                RIdCamDelta;   // flag indicates that RidCam has changed

  // Protocol error flags
  reg                WDataNumError;   // flag for AXI_ERRM_WDATA_NUM rule
  reg                WDataOrderError; // flag for AXI_ERRM_WDATA_ORDER rule
  reg                BrespError;      // flag for AXI_ERRS_BRESP rule
  reg                BrespExokError;  // flag for AXI_ERRS_BRESP_EXOKAY rule
  reg                StrbError;       // flag for AXI_ERRM_WSTRB rule

  // signals for checking for match in ID CAMs
  integer            AidMatch;
  integer            WidMatch;
  integer            RidMatch;
  integer            BidMatch;

  reg          [6:0] AlignMaskR; // mask for checking read address alignment
  reg          [6:0] AlignMaskW; // mask for checking write address alignment

  // signals for Address Checking
  reg         [31:0] ArAddrIncr;
  reg         [31:0] AwAddrIncr;

  // signals for Data Checking
  reg   [DATA_MAX:0] WdataMask;
  reg         [10:0] ArSizeInBits;
  reg         [10:0] AwSizeInBits;
  reg         [11:0] ArLenInBytes;
  wire         [3:0] ArLenPending;
  wire               ArExclPending;

  // Lock signals
  wire               AWLockNew; // New locked write address valid
  wire               ARLockNew; // New locked read address valid
  reg          [1:0] LockState;
  reg          [1:0] LockStateNext;
  reg     [ID_MAX:0] LockIdNext;
  reg     [ID_MAX:0] LockId;
  reg          [3:0] LockCacheNext;
  reg          [3:0] LockCache;
  reg          [2:0] LockProtNext;
  reg          [2:0] LockProt;
  reg         [31:0] LockAddrNext;
  reg         [31:0] LockAddr;

  // arrays to store exclusive access control info
  reg                ExclReadAddr[ID_HI:0]; // tracks excl read addr
  reg                ExclReadData[ID_HI:0]; // tracks excl read data
  reg         [31:0] ExclAddr[ID_HI:0];
  reg          [2:0] ExclSize[ID_HI:0];
  reg          [3:0] ExclLen[ID_HI:0];
  reg          [1:0] ExclBurst[ID_HI:0];
  reg          [3:0] ExclCache[ID_HI:0];
  reg          [2:0] ExclProt[ID_HI:0];
  reg [AWUSER_MAX:0] ExclUser[ID_HI:0];
  reg         [10:0] ExclMask; // mask to check alignment of exclusive address


//------------------------------------------------------------------------------
// INDEX:   4) Verilog Defines
//------------------------------------------------------------------------------

  // Lock FSM States (3-state FSM, so one state encoding is not used)
  `define AUX_ST_UNLOCKED  2'b00
  `define AUX_ST_LOCKED    2'b01
  `define AUX_ST_LOCK_LAST 2'b10
  `define AUX_ST_NOT_USED  2'b11

  // OVL Severity levels
  `define OVL_SimFatal   0 // Simulation error + stop
  `define OVL_SimError   1 // Simulation error (non-fatal)
  `define OVL_SimWarning 2 // Simulation warning
  `define OVL_SimCover   3 // Simulation coverage-point
  `define OVL_SimInfo    4 // Simulation info

  // OVL Proof Options (all others set via parameters)
  `define OVL_SkipFormalProof 3 // Don't formally verify (ignore)


//------------------------------------------------------------------------------
// INDEX:   5) Format for time reporting
//------------------------------------------------------------------------------
  initial
    $timeformat(-9, 0, " ns", 0);


//------------------------------------------------------------------------------
// INDEX:
// INDEX: AXI Rules: Write Address Channel (*_AW*)
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   1) Functional Rules
//------------------------------------------------------------------------------


  // INDEX:        - AXI_ERRM_AWADDR_BOUNDARY
  // =====
  // 4kbyte boundary: only bottom twelve bits (11 to 0) can change
  //
  // Only need to check INCR bursts since:
  //
  //   a) FIXED bursts cannot violate the 4kB boundary by definition
  //
  //   b) WRAP bursts always stay within a <4kB region because of the wrap
  //      address boundary.  The biggest WRAP burst possible has length 16,
  //      size 128 bytes (1024 bits), so it can transfer 2048 bytes. The
  //      individual transfer addresses wrap at a 2048 byte address boundary,
  //      and the max data transferred in also 2048 bytes, so a 4kB boundary
  //      can never be broken.
  axi_errm_awaddr_boundary: assert property (AXI_ERRM_AWADDR_BOUNDARY) else
   $error("AXI_ERRM_AWADDR_BOUNDARY. A write burst cannot cross a 4kbyte boundary. Spec: section 4.1 on page 4-2.");
  property AXI_ERRM_AWADDR_BOUNDARY;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWBURST,AWADDR})) &
          AWVALID & (AWBURST == `AXI_ABURST_INCR)
      |-> (AwAddrIncr[31:12] == AWADDR[31:12]);
  endproperty


  // INDEX:        - AXI_ERRM_AWADDR_WRAP_ALIGN
  // =====
  axi_errm_awadrr_wrap_align: assert property (AXI_ERRM_AWADRR_WRAP_ALIGN) else
   $error("AXI_ERRM_AWADDR_WRAP_ALIGN. A write transaction with burst type WRAP must have an aligned address. Spec: section 4.4.3 on page 4-6.");
  property AXI_ERRM_AWADRR_WRAP_ALIGN;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWBURST,AWADDR})) &
          AWVALID & (AWBURST == `AXI_ABURST_WRAP)
      |-> ((AWADDR[6:0] & AlignMaskW) == AWADDR[6:0]);
  endproperty


  // INDEX:        - AXI_ERRM_AWBURST
  // =====
  axi_errm_awburst: assert property (AXI_ERRM_AWBURST) else
   $error("AXI_ERRM_AWBURST. When AWVALID is high, a value of 2'b11 on AWBURST is not permitted. Spec: table 4-3 on page 4-5.");
  property AXI_ERRM_AWBURST;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWBURST})) &
          AWVALID
      |-> (AWBURST != 2'b11);
  endproperty


  // INDEX:        - AXI_ERRM_AWCACHE
  // =====
  axi_errm_awcache: assert property (AXI_ERRM_AWCACHE) else
   $error("AXI_ERRM_AWCACHE. When AWVALID is high, if AWCACHE[1] is low then AWCACHE[3] and AWCACHE[2] must also be low. Spec: table 5-1 on page 5-3.");
  property AXI_ERRM_AWCACHE;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWCACHE})) &
          AWVALID & ~AWCACHE[1]
      |-> (AWCACHE[3:2] == 2'b00);
  endproperty


  // INDEX:        - AXI_ERRM_AWLEN_WRAP
  // =====
  axi_errm_awlen_wrap: assert property (AXI_ERRM_AWLEN_WRAP) else
   $error("AXI_ERRM_AWLEN_WRAP. A write transaction with burst type WRAP must have length 2, 4, 8 or 16. Spec: section 4.4.3 on page 4-6.");
  property AXI_ERRM_AWLEN_WRAP;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWBURST,AWLEN})) &
          AWVALID & (AWBURST == `AXI_ABURST_WRAP)
      |-> (AWLEN == `AXI_ALEN_2 ||
           AWLEN == `AXI_ALEN_4 ||
           AWLEN == `AXI_ALEN_8 ||
           AWLEN == `AXI_ALEN_16);
  endproperty


  // INDEX:        - AXI_ERRM_AWLOCK
  // =====
  axi_errm_awlock: assert property (AXI_ERRM_AWLOCK) else
   $error("AXI_ERRM_AWLOCK. When AWVALID is high, a value of 2'b11 on AWLOCK is not permitted. Spec: table 6-1 on page 6-2.");
  property AXI_ERRM_AWLOCK;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWLOCK})) &
          AWVALID
      |-> (AWLOCK != 2'b11);
  endproperty


  // INDEX:        - AXI_ERRM_AWLOCK_END
  // =====
  axi_errm_awlock_end: assert property (AXI_ERRM_AWLOCK_END) else
   $error("AXI_ERRM_AWLOCK_END. A master must wait for an unlocked transaction at the end of a locked sequence to complete before issuing another write address. Spec: section 6.3 on page 6-7.");
  property AXI_ERRM_AWLOCK_END;
    @(posedge ACLK)
          !($isunknown({AWVALID,ARVALID,ARLOCK,AWLOCK})) &
          ((LockState == `AUX_ST_LOCK_LAST) & // waiting for unlocking transfer to complete
           AWVALID                            // new valid write address
          )
      |-> ((nROutstanding & nWOutstanding) &  // no other burst outstanding
           ~(ARVALID & (ARLOCK != AWLOCK))    // no new address valid, unless of same LOCK type
          );
  endproperty


  // INDEX:        - AXI_ERRM_AWLOCK_ID
  // =====
  axi_errm_awlock_id: assert property (AXI_ERRM_AWLOCK_ID) else
   $error("AXI_ERRM_AWLOCK_ID. A sequence of locked transactions must use a single ID. Spec: section 6.3 on page 6-7.");
  property AXI_ERRM_AWLOCK_ID;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWID})) &
          ((LockState == `AUX_ST_LOCKED) & // in locked sequence
           AWVALID                         // valid write address
          )
      |-> (AWID == LockId);
  endproperty


  // INDEX:        - AXI_ERRM_AWLOCK_LAST
  // =====
  axi_errm_awlock_last: assert property (AXI_ERRM_AWLOCK_LAST) else
   $error("AXI_ERRM_AWLOCK_LAST. A master must wait for all locked transactions to complete before issuing an unlocked write address. Spec: section 6.3 on page 6-7.");
  property AXI_ERRM_AWLOCK_LAST;
    @(posedge ACLK)
          !($isunknown({AWVALID,ARVALID,AWLOCK})) &
          ((LockState == `AUX_ST_LOCKED) &            // in locked sequence
           (AWVALID & (AWLOCK != `AXI_ALOCK_LOCKED))  // valid unlocked write address
          )
      |-> (nROutstanding & nWOutstanding & ~ARVALID); // no other burst outstanding
  endproperty


  // INDEX:        - AXI_ERRM_AWLOCK_START
  // =====
  axi_errm_awlock_start: assert property (AXI_ERRM_AWLOCK_START) else
   $error("AXI_ERRM_AWLOCK_START. A master must wait for all outstanding transactions to complete before issuing a write address which is the first in a locked sequence. Spec: section 6.3 on page 6-7.");
  property AXI_ERRM_AWLOCK_START;
    @(posedge ACLK)
          !($isunknown({AWVALID,ARVALID,AWLOCK,ARLOCK})) &
          ((LockState == `AUX_ST_UNLOCKED) &          // in unlocked sequence
           (AWVALID & (AWLOCK == `AXI_ALOCK_LOCKED))  // valid locked write address
          )
      |-> ((nROutstanding & nWOutstanding) &          // no other burst outstanding
           ~(ARVALID & (ARLOCK != `AXI_ALOCK_LOCKED)) // no new address valid, unless also locked
          );
  endproperty


  // INDEX:        - AXI_ERRM_AWSIZE
  // =====
  // Deliberately keeping AwSizeInBits logic outside of OVL instance, to
  // simplify formal-proofs flow.
  axi_errm_awsize: assert property (AXI_ERRM_AWSIZE) else
   $error("AXI_ERRM_AWSIZE. The size of a write transfer must not exceed the width of the data port. Spec: section 4.3 on page 4-4.");
  property AXI_ERRM_AWSIZE;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWSIZE})) &
          AWVALID
      |-> (AwSizeInBits <= DATA_WIDTH);
  endproperty


  // INDEX:        - AXI_ERRM_AWVALID_RESET
  // =====
  axi_errm_awvalid_reset: assert property (AXI_ERRM_AWVALID_RESET) else
   $error("AXI_ERRM_AWVALID_RESET. AWVALID must be low in the cycle when ARESETn first goes high. Spec: section 11.1.2 on page 11-2.");
  property AXI_ERRM_AWVALID_RESET;
    @(posedge ACLK)
          !ARESETn & !($isunknown(ARESETn))
      |-> 
      ##1 !AWVALID;
  endproperty


  // INDEX:        - AXI_RECM_AWLOCK_BOUNDARY
  // =====
  // 4kbyte boundary: only bottom twelve bits (11 to 0) can change
  axi_recm_awlock_boundary: assert property (AXI_RECM_AWLOCK_BOUNDARY) else
   $error("AXI_RECM_AWLOCK_BOUNDARY. It is recommended that all locked transaction sequences are kept within the same 4KB address region. Spec: section 6.3 on page 6-7.");
  property AXI_RECM_AWLOCK_BOUNDARY;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWADDR})) &
          (RecommendOn &
           (LockState == `AUX_ST_LOCKED) & // locked sequence
           AWVALID                         // valid write address
          )
      |-> ((AWADDR[31:12] == LockAddr[31:12]));
  endproperty


  // INDEX:        - AXI_RECM_AWLOCK_CTRL 
  // =====
  axi_recm_awlock_ctrl: assert property (AXI_RECM_AWLOCK_CTRL) else
   $error("AXI_RECM_AWLOCK_CTRL. It is recommended that a master should not change AxPROT or AxCACHE during a sequence of locked accesses. Spec: section 6.3 on page 6-7.");
  property AXI_RECM_AWLOCK_CTRL;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWPROT,AWCACHE})) &
          (RecommendOn &
           (LockState == `AUX_ST_LOCKED) & // locked sequence
           AWVALID                         // valid write address
          )
      |-> ((AWPROT == LockProt) & (AWCACHE == LockCache));
  endproperty


  // INDEX:        - AXI_RECM_AWLOCK_NUM
  // =====
  axi_recm_awlock_num: assert property (AXI_RECM_AWLOCK_NUM) else
   $error("AXI_RECM_AWLOCK_NUM. It is recommended that locked transaction sequences are limited to two transactions. Spec: section 6.3 on page 6-7.");
  property AXI_RECM_AWLOCK_NUM;
    @(posedge ACLK)
           !($isunknown({AWVALID,AWLOCK})) &
          (RecommendOn &
           (LockState == `AUX_ST_LOCKED) & // locked sequence
           AWVALID                         // write address
          )
      |-> (AWLOCK != `AXI_ALOCK_LOCKED);   // not starting another locked write transaction
  endproperty


//------------------------------------------------------------------------------
// INDEX:   2) Handshake Rules
//------------------------------------------------------------------------------


  // INDEX:        - AXI_ERRM_AWADDR_STABLE
  // =====
  axi_errm_awaddr_stable: assert property (AXI_ERRM_AWADDR_STABLE) else
   $error("AXI_ERRM_AWADDR_STABLE. AWADDR must remain stable when AWVALID is asserted and AWREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_AWADDR_STABLE;
    @(posedge ACLK)
         !($isunknown({AWVALID,AWREADY,AWADDR})) &
          ARESETn & AWVALID & !AWREADY
      ##1 ARESETn
      |-> $stable(AWADDR);
  endproperty


  // INDEX:        - AXI_ERRM_AWBURST_STABLE
  // =====
  axi_errm_awburst_stable: assert property (AXI_ERRM_AWBURST_STABLE) else
   $error("AXI_ERRM_AWBURST_STABLE. AWBURST must remain stable when AWVALID is asserted and AWREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_AWBURST_STABLE;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWREADY,AWBURST})) &
          ARESETn & AWVALID & !AWREADY
      ##1 ARESETn
      |-> $stable(AWBURST);
  endproperty


  // INDEX:        - AXI_ERRM_AWCACHE_STABLE
  // =====
  axi_errm_awcache_stable: assert property (AXI_ERRM_AWCACHE_STABLE) else
   $error("AXI_ERRM_AWCACHE_STABLE. AWCACHE must remain stable when AWVALID is asserted and AWREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_AWCACHE_STABLE;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWREADY,AWCACHE})) &
          ARESETn & AWVALID & !AWREADY
      ##1 ARESETn
      |-> $stable(AWCACHE);
  endproperty


  // INDEX:        - AXI_ERRM_AWID_STABLE
  // =====
  axi_errm_awid_stable: assert property (AXI_ERRM_AWID_STABLE) else
   $error("AXI_ERRM_AWID_STABLE. AWID must remain stable when AWVALID is asserted and AWREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_AWID_STABLE;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWREADY,AWID})) &
          ARESETn & AWVALID & !AWREADY
      ##1 ARESETn
      |-> $stable(AWID);
  endproperty


  // INDEX:        - AXI_ERRM_AWLEN_STABLE
  // =====
  axi_errm_awlen_stable: assert property (AXI_ERRM_AWLEN_STABLE) else
   $error("AXI_ERRM_AWLEN_STABLE. AWLEN must remain stable when AWVALID is asserted and AWREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_AWLEN_STABLE;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWREADY,AWLEN})) &
          ARESETn & AWVALID & !AWREADY
      ##1 ARESETn
      |-> $stable(AWLEN);
  endproperty


  // INDEX:        - AXI_ERRM_AWLOCK_STABLE
  // =====
  axi_errm_awlock_stable: assert property (AXI_ERRM_AWLOCK_STABLE) else
   $error("AXI_ERRM_AWLOCK_STABLE. AWLOCK must remain stable when AWVALID is asserted and AWREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_AWLOCK_STABLE;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWREADY,AWLOCK})) &
          ARESETn & AWVALID & !AWREADY
      ##1 ARESETn
      |-> $stable(AWLOCK);
  endproperty


  // INDEX:        - AXI_ERRM_AWPROT_STABLE
  // =====
  axi_errm_awprot_stable: assert property (AXI_ERRM_AWPROT_STABLE) else
   $error("AXI_ERRM_AWPROT_STABLE. AWPROT must remain stable when AWVALID is asserted and AWREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_AWPROT_STABLE;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWREADY,AWPROT})) &
          ARESETn & AWVALID & !AWREADY
      ##1 ARESETn
      |-> $stable(AWPROT);
  endproperty


  // INDEX:        - AXI_ERRM_AWSIZE_STABLE
  // =====
  axi_errm_awsize_stable: assert property (AXI_ERRM_AWSIZE_STABLE) else
   $error("AXI_ERRM_AWSIZE_STABLE. AWSIZE must remain stable when AWVALID is asserted and AWREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_AWSIZE_STABLE;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWREADY,AWSIZE})) &
          ARESETn & AWVALID & !AWREADY
      ##1 ARESETn
      |-> $stable(AWSIZE);
  endproperty


  // INDEX:        - AXI_ERRM_AWVALID_STABLE
  // =====
  axi_errm_awvalid_stable: assert property (AXI_ERRM_AWVALID_STABLE) else
   $error("AXI_ERRM_AWVALID_STABLE. Once AWVALID is asserted, it must remain asserted until AWREADY is high. Spec: section 3.1.1 on page 3-2.");
  property AXI_ERRM_AWVALID_STABLE;
    @(posedge ACLK)
          ARESETn & AWVALID & !AWREADY & !($isunknown({AWVALID,AWREADY}))
      ##1 ARESETn
      |-> AWVALID;
  endproperty


  // INDEX:        - AXI_RECS_AWREADY_MAX_WAIT
  // =====
  // Note: this rule does not error if VALID goes low (breaking VALID_STABLE rule)
  axi_recs_awready_max_wait: assert property (AXI_RECS_AWREADY_MAX_WAIT) else
   $warning("AXI_RECS_AWREADY_MAX_WAIT. AWREADY should be asserted within MAXWAITS cycles of AWVALID being asserted.");  
  property   AXI_RECS_AWREADY_MAX_WAIT;
    @(posedge ACLK)
      ARESETn & !($isunknown({AWVALID,AWREADY})) &
      RecommendOn &      ( AWVALID & !AWREADY) 
      |-> ##[1:MAXWAITS] (!AWVALID |  AWREADY);  // READY=1 within MAXWAITS cycles (or VALID=0)
  endproperty


//------------------------------------------------------------------------------
// INDEX:   3) X-Propagation Rules
//------------------------------------------------------------------------------
`ifdef OVL_XCHECK_OFF
`else  // X-Checking on by default


  // INDEX:        - AXI_ERRM_AWADDR_X
  // =====
  axi_errm_awaddr_x: assert property (AXI_ERRM_AWADDR_X) else
   $error("AXI_ERRM_AWADDR_X. When AWVALID is high, a value of X on AWADDR is not permitted. Spec: section 3.1.1 on page 3-3.");
  property AXI_ERRM_AWADDR_X;
    @(posedge ACLK)
        ARESETn & AWVALID
        |-> ! $isunknown(AWADDR);
  endproperty


  // INDEX:        - AXI_ERRM_AWBURST_X
  // =====
  axi_errm_awburst_x: assert property (AXI_ERRM_AWBURST_X) else
   $error("AXI_ERRM_AWBURST_X. When AWVALID is high, a value of X on AWBURST is not permitted. Spec: section 3.1.1 on page 3-3.");
  property AXI_ERRM_AWBURST_X;
    @(posedge ACLK)
        ARESETn & AWVALID
        |-> ! $isunknown(AWBURST);
  endproperty


  // INDEX:        - AXI_ERRM_AWCACHE_X
  // =====
  axi_errm_awcache_x: assert property (AXI_ERRM_AWCACHE_X) else
   $error("AXI_ERRM_AWCACHE_X. When AWVALID is high, a value of X on AWCACHE is not permitted. Spec: section 3.1.1 on page 3-3.");
  property AXI_ERRM_AWCACHE_X;
    @(posedge ACLK)
        ARESETn & AWVALID
        |-> ! $isunknown(AWCACHE);
  endproperty


  // INDEX:        - AXI_ERRM_AWID_X
  // =====
  axi_errm_awid_x: assert property (AXI_ERRM_AWID_X) else
   $error("AXI_ERRM_AWID_X. When AWVALID is high, a value of X on AWID is not permitted. Spec: section 3.1.1 on page 3-3.");
  property AXI_ERRM_AWID_X;
    @(posedge ACLK)
        ARESETn & AWVALID
        |-> ! $isunknown(AWID);
  endproperty


  // INDEX:        - AXI_ERRM_AWLEN_X
  // =====
  axi_errm_awlen_x: assert property (AXI_ERRM_AWLEN_X) else
   $error("AXI_ERRM_AWLEN_X. When AWVALID is high, a value of X on AWLEN is not permitted. Spec: section 3.1.1 on page 3-3.");
  property AXI_ERRM_AWLEN_X;
    @(posedge ACLK)
        ARESETn & AWVALID
        |-> ! $isunknown(AWLEN);
  endproperty


  // INDEX:        - AXI_ERRM_AWLOCK_X
  // =====
  axi_errm_awlock_x: assert property (AXI_ERRM_AWLOCK_X) else
   $error("AXI_ERRM_AWLOCK_X. When AWVALID is high, a value of X on AWLOCK is not permitted. Spec: section 3.1.1 on page 3-3.");
  property AXI_ERRM_AWLOCK_X;
    @(posedge ACLK)
        ARESETn & AWVALID
        |-> ! $isunknown(AWLOCK);
  endproperty


  // INDEX:        - AXI_ERRM_AWPROT_X
  // =====
  axi_errm_awprot_x: assert property (AXI_ERRM_AWPROT_X) else
   $error("AXI_ERRM_AWPROT_X. When AWVALID is high, a value of X on AWPROT is not permitted. Spec: section 3.1.1 on page 3-3.");
  property AXI_ERRM_AWPROT_X;
    @(posedge ACLK)
        ARESETn & AWVALID
        |-> ! $isunknown(AWPROT);
  endproperty


  // INDEX:        - AXI_ERRM_AWSIZE_X
  // =====
  axi_errm_awsize_x: assert property (AXI_ERRM_AWSIZE_X) else
   $error("AXI_ERRM_AWSIZE_X. When AWVALID is high, a value of X on AWSIZE is not permitted. Spec: section 3.1.1 on page 3-3.");
  property AXI_ERRM_AWSIZE_X;
    @(posedge ACLK)
        ARESETn & AWVALID
        |-> ! $isunknown(AWSIZE);
  endproperty


  // INDEX:        - AXI_ERRM_AWVALID_X
  // =====
  axi_errm_awvalid_x: assert property (AXI_ERRM_AWVALID_X) else
   $error("AXI_ERRM_AWVALID_X. When not in reset, a value of X on AWVALID is not permitted.");
  property AXI_ERRM_AWVALID_X;
    @(posedge ACLK)
        ARESETn
        |-> ! $isunknown(AWVALID);
  endproperty


  // INDEX:        - AXI_ERRS_AWREADY_X
  // =====
  axi_errs_awready_x: assert property (AXI_ERRS_AWREADY_X) else
   $error("AXI_ERRS_AWREADY_X. When not in reset, a value of X on AWREADY is not permitted.");
  property AXI_ERRS_AWREADY_X;
    @(posedge ACLK)
        ARESETn
        |-> ! $isunknown(AWREADY);
  endproperty

`endif // OVL_XCHECK_OFF


//------------------------------------------------------------------------------
// INDEX:
// INDEX: AXI Rules: Write Data Channel (*_W*)
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   1) Functional Rules
//------------------------------------------------------------------------------


  // INDEX:        - AXI_ERRM_WDATA_NUM
  // =====
  // This will fire in one of the following situations:
  // 1) Write data arrives and WLAST set and WDATA count is not equal to AWLEN
  // 2) Write data arrives and WLAST not set and WDATA count is equal to AWLEN
  // 3) ADDR arrives, WLAST already received and WDATA count not equal to AWLEN
  axi_errm_wdata_num: assert property (AXI_ERRM_WDATA_NUM) else
   $error("AXI_ERRM_WDATA_NUM. The number of write data items must match AWLEN for the corresponding address. Spec: table 4-1 on page 4-3.");
  property AXI_ERRM_WDATA_NUM;
    @(posedge ACLK)
      ARESETn & !($isunknown(WDataNumError))
      |-> ~WDataNumError;
  endproperty


  // INDEX:        - AXI_ERRM_WDATA_ORDER
  // =====
  axi_errm_wdata_order: assert property (AXI_ERRM_WDATA_ORDER) else
   $error("AXI_ERRM_WDATA_ORDER. The order in which addresses and the first write data item are produced must match. Spec: section 8.5 on page 8-6.");
  property AXI_ERRM_WDATA_ORDER;
    @(posedge ACLK)
      ARESETn & !($isunknown(WDataOrderError))
      |-> ~WDataOrderError;
  endproperty


  // INDEX:        - AXI_ERRM_WDEPTH
  // =====
  axi_errm_wdepth: assert property (AXI_ERRM_WDEPTH) else
   $error("AXI_ERRM_WDEPTH. A master can interleave a maximum of WDEPTH write data bursts. Spec: section 8.5 on page 8-6.");
  property AXI_ERRM_WDEPTH;
    @(posedge ACLK)
          !($isunknown({WVALID,WREADY,WidDepth})) &
          WVALID & WREADY
      |-> (WidDepth <= WDEPTH);
  endproperty


  // INDEX:        - AXI_ERRM_WSTRB
  // =====
  axi_errm_wstrb: assert property (AXI_ERRM_WSTRB) else
   $error("AXI_ERRM_WSTRB. Write strobes must only be asserted for the correct byte lanes as determined from start address, transfer size and beat number. Spec: section 9.2 on page 9-3.");
  property AXI_ERRM_WSTRB;
    @(posedge ACLK)
      ARESETn & !($isunknown(StrbError))
      |-> ~StrbError;
  endproperty


  // INDEX:        - AXI_ERRM_WVALID_RESET
  // =====
  axi_errm_wvalid_reset: assert property (AXI_ERRM_WVALID_RESET) else
   $error("AXI_ERRM_WVALID_RESET. WVALID must be low in the cycle when ARESETn first goes high. Spec: section 11.1.2 on page 11-2.");
  property AXI_ERRM_WVALID_RESET;
    @(posedge ACLK)
          !ARESETn & !($isunknown(ARESETn))
      |->
      ##1 !WVALID;
  endproperty


//------------------------------------------------------------------------------
// INDEX:   2) Handshake Rules
//------------------------------------------------------------------------------


  // INDEX:        - AXI_ERRM_WDATA_STABLE
  // =====
  axi_errm_wdata_stable: assert property (AXI_ERRM_WDATA_STABLE) else
   $error("AXI_ERRM_WDATA_STABLE. WDATA must remain stable when WVALID is asserted and WREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_WDATA_STABLE;
    @(posedge ACLK)
          !($isunknown({WVALID,WREADY,WDATA})) &
          ARESETn & WVALID & !WREADY
      ##1 ARESETn
      |-> $stable(WDATA);
  endproperty


  // INDEX:        - AXI_ERRM_WID_STABLE
  // =====
  axi_errm_wid_stable: assert property (AXI_ERRM_WID_STABLE) else
   $error("AXI_ERRM_WID_STABLE. WID must remain stable when WVALID is asserted and WREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_WID_STABLE;
    @(posedge ACLK)
          !($isunknown({WVALID,WREADY,WID})) &
          ARESETn & WVALID & !WREADY
      ##1 ARESETn
      |-> $stable(WID);
  endproperty


  // INDEX:        - AXI_ERRM_WLAST_STABLE
  // =====
  axi_errm_wlast_stable: assert property (AXI_ERRM_WLAST_STABLE) else
   $error("AXI_ERRM_WLAST_STABLE. WLAST must remain stable when WVALID is asserted and WREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_WLAST_STABLE;
    @(posedge ACLK)
          !($isunknown({WVALID,WREADY,WLAST})) &
          ARESETn & WVALID & !WREADY
      ##1 ARESETn
      |-> $stable(WLAST);
  endproperty


  // INDEX:        - AXI_ERRM_WSTRB_STABLE
  // =====
  axi_errm_wstrb_stable: assert property (AXI_ERRM_WSTRB_STABLE) else
   $error("AXI_ERRM_WSTRB_STABLE. WSTRB must remain stable when WVALID is asserted and WREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_WSTRB_STABLE;
    @(posedge ACLK)
          !($isunknown({WVALID,WREADY,WSTRB})) &
          ARESETn & WVALID & !WREADY
      ##1 ARESETn
      |-> $stable(WSTRB);
  endproperty


  // INDEX:        - AXI_ERRM_WVALID_STABLE
  // =====
  axi_errm_wvalid_stable: assert property (AXI_ERRM_WVALID_STABLE) else
   $error("AXI_ERRM_WVALID_STABLE. Once WVALID is asserted, it must remain asserted until WREADY is high. Spec: section 3.1.2 on page 3-4.");
  property AXI_ERRM_WVALID_STABLE;
    @(posedge ACLK)
          ARESETn & WVALID & !WREADY & !($isunknown({WVALID,WREADY}))
      ##1 ARESETn
      |-> WVALID;
  endproperty


  // INDEX:        - AXI_RECS_WREADY_MAX_WAIT 
  // =====
  // Note: this rule does not error if VALID goes low (breaking VALID_STABLE rule)
  axi_recs_wready_max_wait: assert property (AXI_RECS_WREADY_MAX_WAIT) else
   $warning("AXI_RECS_WREADY_MAX_WAIT. WREADY should be asserted within MAXWAITS cycles of WVALID being asserted.");  
  property   AXI_RECS_WREADY_MAX_WAIT;
    @(posedge ACLK)
      ARESETn & !($isunknown({WVALID,WREADY})) &
      RecommendOn &      ( WVALID & !WREADY) 
      |-> ##[1:MAXWAITS] (!WVALID |  WREADY);  // READY=1 within MAXWAITS cycles (or VALID=0)
  endproperty


//------------------------------------------------------------------------------
// INDEX:   3) X-Propagation Rules
//------------------------------------------------------------------------------
`ifdef OVL_XCHECK_OFF
`else  // X-Checking on by default


  // INDEX:        - AXI_ERRM_WDATA_X
  // =====
  axi_errm_wdata_x: assert property (AXI_ERRM_WDATA_X) else
   $error("AXI_ERRM_WDATA_X. When WVALID is high, a value of X on active byte lanes of WDATA is not permitted.");
  property AXI_ERRM_WDATA_X;
    @(posedge ACLK)
        ARESETn & WVALID & !($isunknown(WdataMask))
        |-> ! $isunknown(WDATA & WdataMask);
  endproperty


  // INDEX:        - AXI_ERRM_WID_X
  // =====
  axi_errm_wid_x: assert property (AXI_ERRM_WID_X) else
   $error("AXI_ERRM_WID_X. When WVALID is high, a value of X on WID is not permitted. Spec: section 3.1.2 on page 3-4.");
  property AXI_ERRM_WID_X;
    @(posedge ACLK)
        ARESETn & WVALID
        |-> ! $isunknown(WID);
  endproperty


  // INDEX:        - AXI_ERRM_WLAST_X
  // =====
  axi_errm_wlast_x: assert property (AXI_ERRM_WLAST_X) else
   $error("AXI_ERRM_WLAST_X. When WVALID is high, a value of X on WLAST is not permitted.");
  property AXI_ERRM_WLAST_X;
    @(posedge ACLK)
        ARESETn & WVALID
        |-> ! $isunknown(WLAST);
  endproperty


  // INDEX:        - AXI_ERRM_WSTRB_X
  // =====
  axi_errm_wstrb_x: assert property (AXI_ERRM_WSTRB_X) else
   $error("AXI_ERRM_WSTRB_X. When WVALID is high, a value of X on WSTRB is not permitted.");
  property AXI_ERRM_WSTRB_X;
    @(posedge ACLK)
        ARESETn & WVALID
        |-> ! $isunknown(WSTRB);
  endproperty


  // INDEX:        - AXI_ERRM_WVALID_X
  // =====
  axi_errm_wvalid_x: assert property (AXI_ERRM_WVALID_X) else
   $error("AXI_ERRM_WVALID_X. When not in reset, a value of X on WVALID is not permitted.");
  property AXI_ERRM_WVALID_X;
    @(posedge ACLK)
        ARESETn
        |-> ! $isunknown(WVALID);
  endproperty


  // INDEX:        - AXI_ERRS_WREADY_X
  // =====
  axi_errs_wready_x: assert property (AXI_ERRS_WREADY_X) else
   $error("AXI_ERRS_WREADY_X. When not in reset, a value of X on WREADY is not permitted.");
  property AXI_ERRS_WREADY_X;
    @(posedge ACLK)
        ARESETn
        |-> ! $isunknown(WREADY);
  endproperty

`endif // OVL_XCHECK_OFF


//------------------------------------------------------------------------------
// INDEX:
// INDEX: AXI Rules: Write Response Channel (*_B*)
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   1) Functional Rules
//------------------------------------------------------------------------------


  // INDEX:        - AXI_ERRS_BRESP
  // =====
  axi_errs_bresp: assert property (AXI_ERRS_BRESP) else
   $error("AXI_ERRS_BRESP. A slave must only give a write response after the last write data item is transferred. Spec: section 3.3 on page 3-7, and figure 3-5 on page 3-8.");
  property AXI_ERRS_BRESP;
    @(posedge ACLK)
      ARESETn & !($isunknown(BrespError))
      |-> ~BrespError;
  endproperty


  // INDEX:        - AXI_ERRS_BRESP_ALL_DONE_EOS
  // =====
  // EOS: End-Of-Simulation check (not suitable for formal proofs).
  // Use +define+ASSERT_END_OF_SIMULATION=tb.EOS_signal when compiling.
`ifdef ASSERT_END_OF_SIMULATION
  axi_errs_bresp_all_done_eos: assert property (AXI_ERRS_BRESP_ALL_DONE_EOS) else
   $error("AXI_ERRS_BRESP_ALL_DONE_EOS. All write transaction addresses must have been matched with corresponding write response.");
  property AXI_ERRS_BRESP_ALL_DONE_EOS;
    @(posedge ACLK)
          !($isunknown(`ASSERT_END_OF_SIMULATION)) &
          ARESETn
      ##1 ARESETn & $rose(`ASSERT_END_OF_SIMULATION)
      |-> (WIndex == 1);
  endproperty
`endif


  // INDEX:        - AXI_ERRS_BRESP_EXOKAY
  // =====
  axi_errs_bresp_exokay: assert property (AXI_ERRS_BRESP_EXOKAY) else
   $error("AXI_ERRS_BRESP_EXOKAY. An EXOKAY write response can only be given to an exclusive write access. Spec: section 6.2.3 on page 6-4.");
  property AXI_ERRS_BRESP_EXOKAY;
    @(posedge ACLK)
      ARESETn & !($isunknown(BrespExokError))
      |-> ~BrespExokError;
  endproperty


  // INDEX:        - AXI_ERRS_BVALID_RESET
  // =====
  axi_errs_bvalid_reset: assert property (AXI_ERRS_BVALID_RESET) else
   $error("AXI_ERRS_BVALID_RESET. BVALID must be low in the cycle when ARESETn first goes high. Spec: section 11.1.2 on page 11-2.");
  property AXI_ERRS_BVALID_RESET;
    @(posedge ACLK)
          !ARESETn & !($isunknown(ARESETn))
      |->
      ##1 !BVALID;
  endproperty


//------------------------------------------------------------------------------
// INDEX:   2) Handshake Rules
//------------------------------------------------------------------------------


  // INDEX:        - AXI_ERRS_BID_STABLE
  // =====
  axi_errs_bid_stable: assert property (AXI_ERRS_BID_STABLE) else
   $error("AXI_ERRS_BID_STABLE. BID must remain stable when BVALID is asserted and BREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRS_BID_STABLE;
    @(posedge ACLK)
          !($isunknown({BVALID,BREADY,BID})) &
          ARESETn & BVALID & !BREADY
      ##1 ARESETn
      |-> $stable(BID);
  endproperty


  // INDEX:        - AXI_ERRS_BRESP_STABLE
  // =====
  axi_errs_bresp_stable: assert property (AXI_ERRS_BRESP_STABLE) else
   $error("AXI_ERRS_BRESP_STABLE. BRESP must remain stable when BVALID is asserted and BREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRS_BRESP_STABLE;
    @(posedge ACLK)
          !($isunknown({BVALID,BREADY,BRESP})) &
          ARESETn & BVALID & !BREADY
      ##1 ARESETn
      |-> $stable(BRESP);
  endproperty


  // INDEX:        - AXI_ERRS_BVALID_STABLE
  // =====
  axi_errs_bvalid_stable: assert property (AXI_ERRS_BVALID_STABLE) else
   $error("AXI_ERRS_BVALID_STABLE. Once BVALID is asserted, it must remain asserted until BREADY is high. Spec: section 3.1.3 on page 3-4.");
  property AXI_ERRS_BVALID_STABLE;
    @(posedge ACLK)
          ARESETn & BVALID & !BREADY & !($isunknown({BVALID,BREADY}))
      ##1 ARESETn
      |-> BVALID;
  endproperty


  // INDEX:        - AXI_RECM_BREADY_MAX_WAIT 
  // =====
  // Note: this rule does not error if VALID goes low (breaking VALID_STABLE rule)
  axi_recm_bready_max_wait: assert property (AXI_RECM_BREADY_MAX_WAIT) else
   $warning("AXI_RECM_BREADY_MAX_WAIT. BREADY should be asserted within MAXWAITS cycles of BVALID being asserted.");
  property   AXI_RECM_BREADY_MAX_WAIT;
    @(posedge ACLK)
      ARESETn & !($isunknown({BVALID,BREADY})) &
      RecommendOn &      ( BVALID & !BREADY) 
      |-> ##[1:MAXWAITS] (!BVALID |  BREADY);  // READY=1 within MAXWAITS cycles (or VALID=0)
  endproperty


//------------------------------------------------------------------------------
// INDEX:   3) X-Propagation Rules
//------------------------------------------------------------------------------
`ifdef OVL_XCHECK_OFF
`else  // X-Checking on by default


  // INDEX:        - AXI_ERRM_BREADY_X
  // =====
  axi_errm_bready_x: assert property (AXI_ERRM_BREADY_X) else
   $error("AXI_ERRM_BREADY_X. When not in reset, a value of X on BREADY is not permitted.");
  property AXI_ERRM_BREADY_X;
    @(posedge ACLK)
        ARESETn
        |-> ! $isunknown(BREADY);
  endproperty


  // INDEX:        - AXI_ERRS_BID_X
  // =====
  axi_errs_bid_x: assert property (AXI_ERRS_BID_X) else
   $error("AXI_ERRS_BID_X. When BVALID is high, a value of X on BID is not permitted.");
  property AXI_ERRS_BID_X;
    @(posedge ACLK)
        ARESETn & BVALID
        |-> ! $isunknown(BID);
  endproperty


  // INDEX:        - AXI_ERRS_BRESP_X
  // =====
  axi_errs_bresp_x: assert property (AXI_ERRS_BRESP_X) else
   $error("AXI_ERRS_BRESP_X. When BVALID is high, a value of X on BRESP is not permitted.  Spec: section 3.1.3 on page 3-4.");
  property AXI_ERRS_BRESP_X;
    @(posedge ACLK)
        ARESETn & BVALID
        |-> ! $isunknown(BRESP);
  endproperty


  // INDEX:        - AXI_ERRS_BVALID_X
  // =====
  axi_errs_bvalid_x: assert property (AXI_ERRS_BVALID_X) else
   $error("AXI_ERRS_BVALID_X. When not in reset, a value of X on BVALID is not permitted.");
  property AXI_ERRS_BVALID_X;
    @(posedge ACLK)
        ARESETn
        |-> ! $isunknown(BVALID);
  endproperty

`endif // OVL_XCHECK_OFF


//------------------------------------------------------------------------------
// INDEX:
// INDEX: AXI Rules: Read Address Channel (*_AR*)
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   1) Functional Rules
//------------------------------------------------------------------------------


  // INDEX:        - AXI_ERRM_ARADDR_BOUNDARY
  // =====
  // 4kbyte boundary: only bottom twelve bits (11 to 0) can change
  //
  // Only need to check INCR bursts since:
  //
  //   a) FIXED bursts cannot violate the 4kB boundary by definition
  //
  //   b) WRAP bursts always stay within a <4kB region because of the wrap
  //      address boundary.  The biggest WRAP burst possible has length 16,
  //      size 128 bytes (1024 bits), so it can transfer 2048 bytes. The
  //      individual transfer addresses wrap at a 2048 byte address boundary,
  //      and the max data transferred in also 2048 bytes, so a 4kB boundary
  //      can never be broken.
  axi_errm_araddr_boundary: assert property (AXI_ERRM_ARADDR_BOUNDARY) else
   $error("AXI_ERRM_ARADDR_BOUNDARY. A read burst cannot cross a 4kbyte boundary. Spec: section 4.1 on page 4-2.");
  property AXI_ERRM_ARADDR_BOUNDARY;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARBURST,ARADDR})) &
          ARVALID & (ARBURST == `AXI_ABURST_INCR)
      |-> (ArAddrIncr[31:12] == ARADDR[31:12]);
  endproperty


  // INDEX:        - AXI_ERRM_ARADDR_WRAP_ALIGN
  // =====
  axi_errm_araddr_wrap_align: assert property (AXI_ERRM_ARADDR_WRAP_ALIGN) else
   $error("AXI_ERRM_ARADDR_WRAP_ALIGN. A read transaction with burst type WRAP must have an aligned address. Spec: section 4.4.3 on page 4-6.");
  property AXI_ERRM_ARADDR_WRAP_ALIGN;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARBURST,ARADDR})) &
          ARVALID & (ARBURST == `AXI_ABURST_WRAP)
      |-> ((ARADDR[6:0] & AlignMaskR) == ARADDR[6:0]);
  endproperty


  // INDEX:        - AXI_ERRM_ARBURST
  // =====
  axi_errm_arburst: assert property (AXI_ERRM_ARBURST) else
   $error("AXI_ERRM_ARBURST. When ARVALID is high, a value of 2'b11 on ARBURST is not permitted. Spec: table 4-3 on page 4-5.");
  property AXI_ERRM_ARBURST;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARBURST})) &
          ARVALID
      |-> (ARBURST != 2'b11);
  endproperty


  // INDEX:        - AXI_ERRM_ARCACHE
  // =====
  axi_errm_arcache: assert property (AXI_ERRM_ARCACHE) else
   $error("AXI_ERRM_ARCACHE. When ARVALID is high, if ARCACHE[1] is low then ARCACHE[3] and ARCACHE[2] must also be low. Spec: table 5-1 on page 5-3.");
  property AXI_ERRM_ARCACHE;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARCACHE})) &
          ARVALID & ~ARCACHE[1]
      |-> (ARCACHE[3:2] == 2'b00);
  endproperty


  // INDEX:        - AXI_ERRM_ARLEN_WRAP
  // =====
  axi_errm_arlen_wrap: assert property (AXI_ERRM_ARLEN_WRAP) else
   $error("AXI_ERRM_ARLEN_WRAP. A read transaction with burst type WRAP must have length 2, 4, 8 or 16. Spec: section 4.4.3 on page 4-6.");
  property AXI_ERRM_ARLEN_WRAP;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARBURST,ARLEN})) &
          ARVALID & (ARBURST == `AXI_ABURST_WRAP)
      |-> (ARLEN == `AXI_ALEN_2 ||
           ARLEN == `AXI_ALEN_4 ||
           ARLEN == `AXI_ALEN_8 ||
           ARLEN == `AXI_ALEN_16);
  endproperty


  // INDEX:        - AXI_ERRM_ARLOCK
  // =====
  axi_errm_arlock: assert property (AXI_ERRM_ARLOCK) else
   $error("AXI_ERRM_ARLOCK. When ARVALID is high, a value of 2'b11 on ARLOCK is not permitted. Spec: table 6-1 on page 6-2.");
  property AXI_ERRM_ARLOCK;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARLOCK})) &
          ARVALID
      |-> (ARLOCK != 2'b11);
  endproperty


  // INDEX:        - AXI_ERRM_ARLOCK_END
  // =====
  axi_errm_arlock_end: assert property (AXI_ERRM_ARLOCK_END) else
   $error("AXI_ERRM_ARLOCK_END. A master must wait for an unlocked transaction at the end of a locked sequence to complete before issuing another read address. Spec: section 6.3 on page 6-7.");
  property AXI_ERRM_ARLOCK_END;
    @(posedge ACLK)
          !($isunknown({ARVALID,AWVALID,ARLOCK,AWLOCK})) &
          ((LockState == `AUX_ST_LOCK_LAST) & // waiting for unlocking transfer to complete
           ARVALID                            // new valid read address
          )
      |-> (nROutstanding & nWOutstanding &    // no other burst outstanding
           ~(AWVALID & (AWLOCK != ARLOCK))    // no new address valid, unless of same LOCK type
          );
  endproperty


  // INDEX:        - AXI_ERRM_ARLOCK_ID
  // =====
  axi_errm_arlock_id: assert property (AXI_ERRM_ARLOCK_ID) else
   $error("AXI_ERRM_ARLOCK_ID. A sequence of locked transactions must use a single ID. Spec: section 6.3 on page 6-7.");
  property AXI_ERRM_ARLOCK_ID;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARID})) &
          ((LockState == `AUX_ST_LOCKED) & // in locked sequence
           ARVALID                         // valid read address
          )
      |-> (ARID == LockId);
  endproperty


  // INDEX:        - AXI_ERRM_ARLOCK_LAST
  // =====
  axi_errm_arlock_last: assert property (AXI_ERRM_ARLOCK_LAST) else
   $error("AXI_ERRM_ARLOCK_LAST. A master must wait for all locked transactions to complete before issuing an unlocked read address. Spec: section 6.3 on page 6-7.");
  property AXI_ERRM_ARLOCK_LAST;
    @(posedge ACLK)
          !($isunknown({ARVALID,AWVALID,ARLOCK})) &
          ((LockState == `AUX_ST_LOCKED) &            // in locked sequence
           (ARVALID & (ARLOCK != `AXI_ALOCK_LOCKED))  // valid unlocked read address
          )
      |-> (nROutstanding & nWOutstanding & ~AWVALID); // no other burst outstanding
  endproperty


  // INDEX:        - AXI_ERRM_ARLOCK_START
  // =====
  axi_errm_arlock_start: assert property (AXI_ERRM_ARLOCK_START) else
   $error("AXI_ERRM_ARLOCK_START. A master must wait for all outstanding transactions to complete before issuing a read address which is the first in a locked sequence. Spec: section 6.3 on page 6-7.");
  property AXI_ERRM_ARLOCK_START;
    @(posedge ACLK)
          !($isunknown({ARVALID,AWVALID,ARLOCK,AWLOCK})) &
          ((LockState == `AUX_ST_UNLOCKED) &         // in unlocked sequence
           (ARVALID & (ARLOCK == `AXI_ALOCK_LOCKED)) // valid locked read address
          )
      |-> (nROutstanding & nWOutstanding &           // no other burst outstanding
          ~(AWVALID & (AWLOCK != `AXI_ALOCK_LOCKED)) // no new address valid, unless also locked
          );
  endproperty


  // INDEX:        - AXI_ERRM_ARSIZE
  // =====
  axi_errm_arsize: assert property (AXI_ERRM_ARSIZE) else
   $error("AXI_ERRM_ARSIZE. The size of a read transfer must not exceed the width of the data port. Spec: section 4.3 on page 4-4.");
  property AXI_ERRM_ARSIZE;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARSIZE})) &
          ARVALID
      |-> (ArSizeInBits <= DATA_WIDTH);
  endproperty


  // INDEX:        - AXI_ERRM_ARVALID_RESET
  // =====
  axi_errm_arvalid_reset: assert property (AXI_ERRM_ARVALID_RESET) else
   $error("AXI_ERRM_ARVALID_RESET. ARVALID must be low in the cycle when ARESETn first goes high. Spec: section 11.1.2 on page 11-2.");
  property AXI_ERRM_ARVALID_RESET;
    @(posedge ACLK)
          !ARESETn & !($isunknown(ARESETn))
      |->
      ##1 !ARVALID;
  endproperty


  // INDEX:        - AXI_RECM_ARLOCK_BOUNDARY
  // =====
  // 4kbyte boundary: only bottom twelve bits (11 to 0) can change
  axi_recm_arlock_boundary: assert property (AXI_RECM_ARLOCK_BOUNDARY) else
   $error("AXI_RECM_ARLOCK_BOUNDARY. It is recommended that all locked transaction sequences are kept within the same 4KB address region. Spec: section 6.3 on page 6-7.");
  property AXI_RECM_ARLOCK_BOUNDARY;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARADDR})) &
          (RecommendOn &
           (LockState == `AUX_ST_LOCKED) & // locked sequence
           ARVALID                         // valid read address
          )
      |-> (ARADDR[31:12] == LockAddr[31:12]);
  endproperty


  // INDEX:        - AXI_RECM_ARLOCK_CTRL
  // =====
  axi_recm_arlock_ctrl: assert property (AXI_RECM_ARLOCK_CTRL) else
   $error("AXI_RECM_ARLOCK_CTRL. It is recommended that a master should not change AxPROT or AxCACHE during a sequence of locked accesses. Spec: section 6.3 on page 6-7.");
  property AXI_RECM_ARLOCK_CTRL;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARPROT,ARCACHE})) &
          (RecommendOn &
           (LockState == `AUX_ST_LOCKED) & // locked sequence
           ARVALID                         // valid read address
          )
      |-> ((ARPROT == LockProt) & (ARCACHE == LockCache));
  endproperty


  // INDEX:        - AXI_RECM_ARLOCK_NUM
  // =====
  axi_recm_arlock_num: assert property (AXI_RECM_ARLOCK_NUM) else
   $error("AXI_RECM_ARLOCK_NUM. It is recommended that locked transaction sequences are limited to two transactions. Spec: section 6.3 on page 6-7.");
  property AXI_RECM_ARLOCK_NUM;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARLOCK})) &
          (RecommendOn &
           (LockState == `AUX_ST_LOCKED) & // locked sequence
           ARVALID                         // read address
          )
      |-> (ARLOCK != `AXI_ALOCK_LOCKED);   // not starting another locked read transaction
  endproperty


//------------------------------------------------------------------------------
// INDEX:   2) Handshake Rules
//------------------------------------------------------------------------------


  // INDEX:        - AXI_ERRM_ARADDR_STABLE
  // =====
  axi_errm_araddr_stable: assert property (AXI_ERRM_ARADDR_STABLE) else
   $error("AXI_ERRM_ARADDR_STABLE. ARADDR must remain stable when ARVALID is asserted and ARREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_ARADDR_STABLE;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARREADY,ARADDR})) &
          ARESETn & ARVALID & !ARREADY
      ##1 ARESETn
      |-> $stable(ARADDR);
  endproperty


  // INDEX:        - AXI_ERRM_ARBURST_STABLE
  // =====
  axi_errm_arburst_stable: assert property (AXI_ERRM_ARBURST_STABLE) else
   $error("AXI_ERRM_ARBURST_STABLE. ARBURST must remain stable when ARVALID is asserted and ARREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_ARBURST_STABLE;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARREADY,ARBURST})) &
          ARESETn & ARVALID & !ARREADY
      ##1 ARESETn
      |-> $stable(ARBURST);
  endproperty


  // INDEX:        - AXI_ERRM_ARCACHE_STABLE
  // =====
  axi_errm_arcache_stable: assert property (AXI_ERRM_ARCACHE_STABLE) else
   $error("AXI_ERRM_ARCACHE_STABLE. ARCACHE must remain stable when ARVALID is asserted and ARREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_ARCACHE_STABLE;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARREADY,ARCACHE})) &
          ARESETn & ARVALID & !ARREADY
      ##1 ARESETn
      |-> $stable(ARCACHE);
  endproperty


  // INDEX:        - AXI_ERRM_ARID_STABLE
  // =====
  axi_errm_arid_stable: assert property (AXI_ERRM_ARID_STABLE) else
   $error("AXI_ERRM_ARID_STABLE. ARID must remain stable when ARVALID is asserted and ARREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_ARID_STABLE;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARREADY,ARID})) &
          ARESETn & ARVALID & !ARREADY
      ##1 ARESETn
      |-> $stable(ARID);
  endproperty


  // INDEX:        - AXI_ERRM_ARLEN_STABLE
  // =====
  axi_errm_arlen_stable: assert property (AXI_ERRM_ARLEN_STABLE) else
   $error("AXI_ERRM_ARLEN_STABLE. ARLEN must remain stable when ARVALID is asserted and ARREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_ARLEN_STABLE;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARREADY,ARLEN})) &
          ARESETn & ARVALID & !ARREADY
      ##1 ARESETn
      |-> $stable(ARLEN);
  endproperty


  // INDEX:        - AXI_ERRM_ARLOCK_STABLE
  // =====
  axi_errm_arlock_stable: assert property (AXI_ERRM_ARLOCK_STABLE) else
   $error("AXI_ERRM_ARLOCK_STABLE. ARLOCK must remain stable when ARVALID is asserted and ARREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_ARLOCK_STABLE;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARREADY,ARLOCK})) &
          ARESETn & ARVALID & !ARREADY
      ##1 ARESETn
      |-> $stable(ARLOCK);
  endproperty


  // INDEX:        - AXI_ERRM_ARPROT_STABLE
  // =====
  axi_errm_arprot_stable: assert property (AXI_ERRM_ARPROT_STABLE) else
   $error("AXI_ERRM_ARPROT_STABLE. ARPROT must remain stable when ARVALID is asserted and ARREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_ARPROT_STABLE;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARREADY,ARPROT})) &
          ARESETn & ARVALID & !ARREADY
      ##1 ARESETn
      |-> $stable(ARPROT);
  endproperty


  // INDEX:        - AXI_ERRM_ARSIZE_STABLE
  // =====
  axi_errm_arsize_stable: assert property (AXI_ERRM_ARSIZE_STABLE) else
   $error("AXI_ERRM_ARSIZE_STABLE. ARSIZE must remain stable when ARVALID is asserted and ARREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_ARSIZE_STABLE;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARREADY,ARSIZE})) &
          ARESETn & ARVALID & !ARREADY
      ##1 ARESETn
      |-> $stable(ARSIZE);
  endproperty


  // INDEX:        - AXI_ERRM_ARVALID_STABLE
  // =====
  axi_errm_arvalid_stable: assert property (AXI_ERRM_ARVALID_STABLE) else
   $error("AXI_ERRM_ARVALID_STABLE. Once ARVALID is asserted, it must remain asserted until ARREADY is high. Spec: section 3.1.4 on page 3-4.");
  property AXI_ERRM_ARVALID_STABLE;
    @(posedge ACLK)
          ARESETn & ARVALID & !ARREADY & !($isunknown({ARVALID,ARREADY}))
      ##1 ARESETn
      |-> ARVALID;
  endproperty


  // INDEX:        - AXI_RECS_ARREADY_MAX_WAIT 
  // =====
  // Note: this rule does not error if VALID goes low (breaking VALID_STABLE rule)
  axi_recs_arready_max_wait: assert property (AXI_RECS_ARREADY_MAX_WAIT) else
   $warning("AXI_RECS_ARREADY_MAX_WAIT. ARREADY should be asserted within MAXWAITS cycles of ARVALID being asserted.");  
  property   AXI_RECS_ARREADY_MAX_WAIT;
    @(posedge ACLK)
      ARESETn & !($isunknown({ARVALID,ARREADY})) &
      RecommendOn &      ( ARVALID & !ARREADY) 
      |-> ##[1:MAXWAITS] (!ARVALID |  ARREADY);  // READY=1 within MAXWAITS cycles (or VALID=0)
  endproperty


//------------------------------------------------------------------------------
// INDEX:   3) X-Propagation Rules
//------------------------------------------------------------------------------
`ifdef OVL_XCHECK_OFF
`else  // X-Checking on by default


  // INDEX:        - AXI_ERRM_ARADDR_X
  // =====
  axi_errm_araddr_x: assert property (AXI_ERRM_ARADDR_X) else
   $error("AXI_ERRM_ARADDR_X. When ARVALID is high, a value of X on ARADDR is not permitted. Spec: section 3.1.4 on page 3-4.");
  property AXI_ERRM_ARADDR_X;
    @(posedge ACLK)
        ARESETn & ARVALID
        |-> ! $isunknown(ARADDR);
  endproperty


  // INDEX:        - AXI_ERRM_ARBURST_X
  // =====
  axi_errm_arburst_x: assert property (AXI_ERRM_ARBURST_X) else
   $error("AXI_ERRM_ARBURST_X. When ARVALID is high, a value of X on ARBURST is not permitted. Spec: section 3.1.4 on page 3-4.");
  property AXI_ERRM_ARBURST_X;
    @(posedge ACLK)
        ARESETn & ARVALID
        |-> ! $isunknown(ARBURST);
  endproperty


  // INDEX:        - AXI_ERRM_ARCACHE_X
  // =====
  axi_errm_arcache_x: assert property (AXI_ERRM_ARCACHE_X) else
   $error("AXI_ERRM_ARCACHE_X. When ARVALID is high, a value of X on ARCACHE is not permitted. Spec: section 3.1.4 on page 3-4.");
  property AXI_ERRM_ARCACHE_X;
    @(posedge ACLK)
        ARESETn & ARVALID
        |-> ! $isunknown(ARCACHE);
  endproperty


  // INDEX:        - AXI_ERRM_ARID_X
  // =====
  axi_errm_arid_x: assert property (AXI_ERRM_ARID_X) else
   $error("AXI_ERRM_ARID_X. When ARVALID is high, a value of X on ARID is not permitted. Spec: section 3.1.4 on page 3-4.");
  property AXI_ERRM_ARID_X;
    @(posedge ACLK)
        ARESETn & ARVALID
        |-> ! $isunknown(ARID);
  endproperty


  // INDEX:        - AXI_ERRM_ARLEN_X
  // =====
  axi_errm_arlen_x: assert property (AXI_ERRM_ARLEN_X) else
   $error("AXI_ERRM_ARLEN_X. When ARVALID is high, a value of X on ARLEN is not permitted. Spec: section 3.1.4 on page 3-4.");
  property AXI_ERRM_ARLEN_X;
    @(posedge ACLK)
        ARESETn & ARVALID
        |-> ! $isunknown(ARLEN);
  endproperty


  // INDEX:        - AXI_ERRM_ARLOCK_X
  // =====
  axi_errm_arlock_x: assert property (AXI_ERRM_ARLOCK_X) else
   $error("AXI_ERRM_ARLOCK_X. When ARVALID is high, a value of X on ARLOCK is not permitted. Spec: section 3.1.4 on page 3-4.");
  property AXI_ERRM_ARLOCK_X;
    @(posedge ACLK)
        ARESETn & ARVALID
        |-> ! $isunknown(ARLOCK);
  endproperty


  // INDEX:        - AXI_ERRM_ARPROT_X
  // =====
  axi_errm_arprot_x: assert property (AXI_ERRM_ARPROT_X) else
   $error("AXI_ERRM_ARPROT_X. When ARVALID is high, a value of X on ARPROT is not permitted. Spec: section 3.1.4 on page 3-4.");
  property AXI_ERRM_ARPROT_X;
    @(posedge ACLK)
        ARESETn & ARVALID
        |-> ! $isunknown(ARPROT);
  endproperty


  // INDEX:        - AXI_ERRM_ARSIZE_X
  // =====
  axi_errm_arsize_x: assert property (AXI_ERRM_ARSIZE_X) else
   $error("AXI_ERRM_ARSIZE_X. When ARVALID is high, a value of X on ARSIZE is not permitted. Spec: section 3.1.4 on page 3-4.");
  property AXI_ERRM_ARSIZE_X;
    @(posedge ACLK)
        ARESETn & ARVALID
        |-> ! $isunknown(ARSIZE);
  endproperty


  // INDEX:        - AXI_ERRM_ARVALID_X
  // =====
  axi_errm_arvalid_x: assert property (AXI_ERRM_ARVALID_X) else
   $error("AXI_ERRM_ARVALID_X. When not in reset, a value of X on ARVALID is not permitted.");
  property AXI_ERRM_ARVALID_X;
    @(posedge ACLK)
        ARESETn
        |-> ! $isunknown(ARVALID);
  endproperty


  // INDEX:        - AXI_ERRS_ARREADY_X
  // =====
  axi_errs_arready_x: assert property (AXI_ERRS_ARREADY_X) else
   $error("AXI_ERRS_ARREADY_X. When not in reset, a value of X on ARREADY is not permitted.");
  property AXI_ERRS_ARREADY_X;
    @(posedge ACLK)
        ARESETn
        |-> ! $isunknown(ARREADY);
  endproperty

`endif // OVL_XCHECK_OFF


//------------------------------------------------------------------------------
// INDEX:
// INDEX: AXI Rules: Read Data Channel (*_R*)
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   1) Functional Rules
//------------------------------------------------------------------------------


  // INDEX:        - AXI_ERRS_RDATA_NUM
  // =====
  axi_errs_rdata_num: assert property (AXI_ERRS_RDATA_NUM) else
   $error("AXI_ERRS_RDATA_NUM. The number of read data items must match the corresponding ARLEN. Spec: table 4-1 on page 4-3.");
  property AXI_ERRS_RDATA_NUM;
    @(posedge ACLK)
          !($isunknown({RVALID,RREADY,RLAST,ArLenPending})) &
          RVALID & RREADY
      |-> ( ((ArLenPending == 4'h0) &  RLAST) //     Last RDATA and RLAST is     asserted
           |((ArLenPending != 4'h0) & ~RLAST) // Not last RDATA and RLAST is not asserted
          );
  endproperty


  // INDEX:        - AXI_ERRS_RLAST_ALL_DONE_EOS
  // =====
  // EOS: End-Of-Simulation check (not suitable for formal proofs).
  // Use +define+ASSERT_END_OF_SIMULATION=tb.EOS_signal when compiling.
`ifdef ASSERT_END_OF_SIMULATION
  axi_errs_rlast_all_done_eos: assert property (AXI_ERRS_RLAST_ALL_DONE_EOS) else
   $error("AXI_ERRS_RLAST_ALL_DONE_EOS. All outstanding read bursts must have completed.");
  property AXI_ERRS_RLAST_ALL_DONE_EOS;
    @(posedge ACLK)
          !($isunknown({`ASSERT_END_OF_SIMULATION,nROutstanding})) &
          ARESETn
      ##1 ARESETn & $rose(`ASSERT_END_OF_SIMULATION)
      |-> (nROutstanding == 1'b1);
  endproperty
`endif


  // INDEX:        - AXI_ERRS_RID
  // =====
  // Read data must always follow the address that it relates to.
  axi_errs_rid: assert property (AXI_ERRS_RID) else
   $error("AXI_ERRS_RID. A slave can only give read data with an ID to match an outstanding read transaction. Spec: section 8.3 on page 8-4.");
  property AXI_ERRS_RID;
    @(posedge ACLK)
          !($isunknown(RVALID)) &
          RVALID
      |-> (RidMatch > 0);
  endproperty


  // INDEX:        - AXI_ERRS_RRESP_EXOKAY
  // =====
  axi_errs_rresp_exokay: assert property (AXI_ERRS_RRESP_EXOKAY) else
   $error("AXI_ERRS_RRESP_EXOKAY. An EXOKAY read response can only be given to an exclusive read access. Spec: section 6.2.3 on page 6-4.");
  property AXI_ERRS_RRESP_EXOKAY;
    @(posedge ACLK)
          !($isunknown({RVALID,RREADY,RRESP})) &
          RVALID & RREADY & (RRESP == `AXI_RESP_EXOKAY)
      |-> (ArExclPending);
  endproperty


  // INDEX:        - AXI_ERRS_RVALID_RESET
  // =====
   axi_errs_rvalid_reset: assert property (AXI_ERRS_RVALID_RESET) else
   $error("AXI_ERRS_RVALID_RESET. RVALID must be low in the cycle when ARESETn first goes high. Spec: section 11.1.2 on page 11-2.");
  property AXI_ERRS_RVALID_RESET;
    @(posedge ACLK)
          !ARESETn & !($isunknown(ARESETn))
      |-> 
      ##1 !RVALID;
  endproperty


//------------------------------------------------------------------------------
// INDEX:   2) Handshake Rules
//------------------------------------------------------------------------------


  // INDEX:        - AXI_ERRS_RDATA_STABLE
  // =====
  axi_errs_rdata_stable: assert property (AXI_ERRS_RDATA_STABLE) else
   $error("AXI_ERRS_RDATA_STABLE. RDATA must remain stable when RVALID is asserted and RREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRS_RDATA_STABLE;
    @(posedge ACLK)
          !($isunknown({RVALID,RREADY,RDATA})) &
          ARESETn & RVALID & !RREADY
      ##1 ARESETn
      |-> $stable(RDATA);
  endproperty


  // INDEX:        - AXI_ERRS_RID_STABLE
  // =====
  axi_errs_rid_stable: assert property (AXI_ERRS_RID_STABLE) else
   $error("AXI_ERRS_RID_STABLE. RID must remain stable when RVALID is asserted and RREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRS_RID_STABLE;
    @(posedge ACLK)
          !($isunknown({RVALID,RREADY,RID})) &
          ARESETn & RVALID & !RREADY
      ##1 ARESETn
      |-> $stable(RID);
  endproperty


  // INDEX:        - AXI_ERRS_RLAST_STABLE
  // =====
  axi_errs_rlast_stable: assert property (AXI_ERRS_RLAST_STABLE) else
   $error("AXI_ERRS_RLAST_STABLE. RLAST must remain stable when RVALID is asserted and RREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRS_RLAST_STABLE;
    @(posedge ACLK)
          !($isunknown({RVALID,RREADY,RLAST})) &
          ARESETn & RVALID & !RREADY
      ##1 ARESETn
      |-> $stable(RLAST);
  endproperty


  // INDEX:        - AXI_ERRS_RRESP_STABLE
  // =====
  axi_errs_rresp_stable: assert property (AXI_ERRS_RRESP_STABLE) else
   $error("AXI_ERRS_RRESP_STABLE. RRESP must remain stable when RVALID is asserted and RREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRS_RRESP_STABLE;
    @(posedge ACLK)
          !($isunknown({RVALID,RREADY,RRESP})) &
          ARESETn & RVALID & !RREADY
      ##1 ARESETn
      |-> $stable(RRESP);
  endproperty


  // INDEX:        - AXI_ERRS_RVALID_STABLE
  // =====
  axi_errs_rvalid_stable: assert property (AXI_ERRS_RVALID_STABLE) else
   $error("AXI_ERRS_RVALID_STABLE. Once RVALID is asserted, it must remain asserted until RREADY is high. Spec: section 3.1.5 on page 3-5.");
  property AXI_ERRS_RVALID_STABLE;
    @(posedge ACLK)
          ARESETn & RVALID & !RREADY & !($isunknown({RVALID,RREADY}))
      ##1 ARESETn
      |-> RVALID;
  endproperty


  // INDEX:        - AXI_RECM_RREADY_MAX_WAIT 
  // =====
  // Note: this rule does not error if VALID goes low (breaking VALID_STABLE rule)
  axi_recm_rready_max_wait: assert property (AXI_RECM_RREADY_MAX_WAIT) else
   $warning("AXI_RECM_RREADY_MAX_WAIT. RREADY should be asserted within MAXWAITS cycles of RVALID being asserted.");  
  property   AXI_RECM_RREADY_MAX_WAIT;
    @(posedge ACLK)
      ARESETn & !($isunknown({RVALID,RREADY})) &
      RecommendOn &      ( RVALID & !RREADY) 
      |-> ##[1:MAXWAITS] (!RVALID |  RREADY);  // READY=1 within MAXWAITS cycles (or VALID=0)
  endproperty


//------------------------------------------------------------------------------
// INDEX:   3) X-Propagation Rules
//------------------------------------------------------------------------------
`ifdef OVL_XCHECK_OFF
`else  // X-Checking on by default


  // INDEX:        - AXI_ERRM_RREADY_X
  // =====
  axi_errm_rready_x: assert property (AXI_ERRM_RREADY_X) else
   $error("AXI_ERRM_RREADY_X. When not in reset, a value of X on RREADY is not permitted.");
  property AXI_ERRM_RREADY_X;
    @(posedge ACLK)
        ARESETn
        |-> ! $isunknown(RREADY);
  endproperty


  // INDEX:        - AXI_ERRS_RID_X
  // =====
  axi_errs_rid_x: assert property (AXI_ERRS_RID_X) else
    $error("AXI_ERRS_RID_X. When RVALID is high, a value of X on RID is not permitted.");
  property AXI_ERRS_RID_X;
    @(posedge ACLK)
        ARESETn & RVALID
        |-> ! $isunknown(RID);
  endproperty


  // INDEX:        - AXI_ERRS_RLAST_X
  // =====
  axi_errs_rlast_x: assert property (AXI_ERRS_RLAST_X) else
   $error("AXI_ERRS_RLAST_X. When RVALID is high, a value of X on RLAST is not permitted.");
  property AXI_ERRS_RLAST_X;
    @(posedge ACLK)
        ARESETn & RVALID
        |-> ! $isunknown(RLAST);
  endproperty


  // INDEX:        - AXI_ERRS_RRESP_X
  // =====
  axi_errs_rresp_x: assert property (AXI_ERRS_RRESP_X) else
   $error("AXI_ERRS_RRESP_X. When RVALID is high, a value of X on RRESP is not permitted.");
  property AXI_ERRS_RRESP_X;
    @(posedge ACLK)
        ARESETn & RVALID
        |-> ! $isunknown(RRESP);
  endproperty


  // INDEX:        - AXI_ERRS_RVALID_X
  // =====
  axi_errs_rvalid_x: assert property (AXI_ERRS_RVALID_X) else
   $error("AXI_ERRS_RVALID_X. When not in reset, a value of X on RVALID is not permitted.");
  property AXI_ERRS_RVALID_X;
    @(posedge ACLK)
        ARESETn
        |-> ! $isunknown(RVALID);
  endproperty

`endif // OVL_XCHECK_OFF


//------------------------------------------------------------------------------
// INDEX:
// INDEX: AXI Rules: Low Power Interface (*_C*)
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   1) Functional Rules (none for Low Power signals)
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   2) Handshake Rules (asynchronous to ACLK)
// =====
// The low-power handshake rules below use rising/falling edges on REQ and ACK,
// in order to detect changes within ACLK cycles (including low power state).
//------------------------------------------------------------------------------


  // INDEX:        - AXI_ERRL_CSYSACK_FALL
  // =====
  axi_errl_csysack_fall: assert property (AXI_ERRL_CSYSACK_FALL) else
   $error("AXI_ERRL_CSYSACK_FALL. When CSYSACK transitions from high to low, CSYSREQ must be low. Spec: figure 12-1 on page 12-3.");
  property AXI_ERRL_CSYSACK_FALL;
    @(negedge CSYSACK)                  // falling edge of CSYSACK
      ARESETn & !($isunknown(CSYSREQ))
      |-> ~CSYSREQ;                     // CSYSREQ low
  endproperty


  // INDEX:        - AXI_ERRL_CSYSACK_RISE
  // =====
  axi_errl_csysack_rise: assert property (AXI_ERRL_CSYSACK_RISE) else
   $error("AXI_ERRL_CSYSACK_RISE. When CSYSACK transitions from low to high, CSYSREQ must be high. Spec: figure 12-1 on page 12-3.");
  property AXI_ERRL_CSYSACK_RISE;
    @(posedge CSYSACK)                  // rising edge of CSYSACK
      ARESETn & !($isunknown(CSYSREQ))
      |-> CSYSREQ;                      // CSYSREQ high
  endproperty


  // INDEX:        - AXI_ERRL_CSYSREQ_FALL
  // =====
  axi_errl_csysreq_fall: assert property (AXI_ERRL_CSYSREQ_FALL) else
   $error("AXI_ERRL_CSYSREQ_FALL. When CSYSREQ transitions from high to low, CSYSACK must be high. Spec: figure 12-1 on page 12-3.");
  property AXI_ERRL_CSYSREQ_FALL;
    @(negedge CSYSREQ)                  // falling edge of CSYSREQ
      ARESETn & !($isunknown(CSYSACK))
      |-> CSYSACK;                      // CSYSACK high
  endproperty


  // INDEX:        - AXI_ERRL_CSYSREQ_RISE
  // =====
  axi_errl_csysreq_rise: assert property (AXI_ERRL_CSYSREQ_RISE) else
   $error("AXI_ERRL_CSYSREQ_RISE. When CSYSREQ transitions from low to high, CSYSACK must be low. Spec: figure 12-1 on page 12-3.");
  property AXI_ERRL_CSYSREQ_RISE;
    @(posedge CSYSREQ)                  // rising edge of CSYSREQ
      ARESETn & !($isunknown(CSYSACK))
      |-> ~CSYSACK;                     // CSYSACK low
  endproperty


//------------------------------------------------------------------------------
// INDEX:   3) X-Propagation Rules
//------------------------------------------------------------------------------
`ifdef OVL_XCHECK_OFF
`else  // X-Checking on by default


  // INDEX:        - AXI_ERRL_CACTIVE_X
  // =====
  axi_errl_cactive_x: assert property (AXI_ERRL_CACTIVE_X) else
   $error("AXI_ERRL_CACTIVE_X. When not in reset, a value of X on CACTIVE is not permitted.");
  property AXI_ERRL_CACTIVE_X;
    @(posedge ACLK)
        ARESETn
        |-> ! $isunknown(CACTIVE);
  endproperty


  // INDEX:        - AXI_ERRL_CSYSACK_X
  // =====
  axi_errl_csysack_x: assert property (AXI_ERRL_CSYSACK_X) else
   $error("AXI_ERRL_CSYSACK_X. When not in reset, a value of X on CSYSACK is not permitted.");
  property AXI_ERRL_CSYSACK_X;
    @(posedge ACLK)
        ARESETn
        |-> ! $isunknown(CSYSACK);
  endproperty


  // INDEX:        - AXI_ERRL_CSYSREQ_X
  // =====
  axi_errl_csysreq_x: assert property (AXI_ERRL_CSYSREQ_X) else
   $error("AXI_ERRL_CSYSREQ_X. When not in reset, a value of X on CSYSREQ is not permitted.");
  property AXI_ERRL_CSYSREQ_X;
    @(posedge ACLK)
        ARESETn
        |-> ! $isunknown(CSYSREQ);
  endproperty

`endif // OVL_XCHECK_OFF


//------------------------------------------------------------------------------
// INDEX:
// INDEX: AXI Rules: Exclusive Access
// =====
// These are inter-channel rules.
// Supports one outstanding exclusive access per ID
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   1) Functional Rules
//------------------------------------------------------------------------------
// INDEX:        -


  // INDEX:        - AXI_ERRM_EXCL_ALIGN
  // =====
  // Burst lengths that are not a power of two are not checked here, because
  // these will violate EXCLLEN. Checked for excl reads only as AXI_ERRM_EXCL_PAIR
  // or AXI_ERRM_EXCL_MATCH will fire if an excl write violates.
  axi_errm_excl_align: assert property (AXI_ERRM_EXCL_ALIGN) else
   $error("AXI_ERRM_EXCL_ALIGN. The address of an exclusive access must be aligned to the total number of bytes in the transaction. Spec: section 6.2.4 on page 6-5.");
  property AXI_ERRM_EXCL_ALIGN;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARLOCK,ARLEN,ARADDR})) &
          (ARVALID &                       // valid address
           (ARLOCK == `AXI_ALOCK_EXCL) &   // exclusive transaction
           (ARLEN == `AXI_ALEN_1 ||        // length is power of 2
            ARLEN == `AXI_ALEN_2 ||
            ARLEN == `AXI_ALEN_4 ||
            ARLEN == `AXI_ALEN_8 ||
            ARLEN == `AXI_ALEN_16))
      |-> ((ARADDR[10:0] & ExclMask) == ARADDR[10:0]); // address aligned
  endproperty


  // INDEX:        - AXI_ERRM_EXCL_LEN
  // =====
  // Checked for excl reads only as AXI_ERRM_EXCL_PAIR or AXI_ERRM_EXCL_MATCH will
  // fire if an excl write violates.
  axi_errm_excl_len: assert property (AXI_ERRM_EXCL_LEN) else
   $error("AXI_ERRM_EXCL_LEN. The number of bytes to be transferred in an exclusive access burst must be a power of 2. Spec: section 6.2.4 on page 6-5.");
  property AXI_ERRM_EXCL_LEN;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARLOCK,ARLEN})) &
          ARVALID & (ARLOCK == `AXI_ALOCK_EXCL)
      |-> ((ARLEN == `AXI_ALEN_1)  ||
           (ARLEN == `AXI_ALEN_2)  ||
           (ARLEN == `AXI_ALEN_4)  ||
           (ARLEN == `AXI_ALEN_8)  ||
           (ARLEN == `AXI_ALEN_16));
  endproperty


  // INDEX:        - AXI_ERRM_EXCL_MATCH
  // =====
  axi_errm_excl_match: assert property (AXI_ERRM_EXCL_MATCH) else
   $error("AXI_ERRM_EXCL_MATCH. The address, size and length of an exclusive write must be the same as the preceding exclusive read with the same ID. Spec: section 6.2.4 on page 6-5.");
  property AXI_ERRM_EXCL_MATCH;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWREADY,AWVALID,AWADDR,AWSIZE,AWLEN,AWBURST,AWCACHE,AWPROT,AWUSER})) &
          (AWVALID & AWREADY &
          (AWLOCK == `AXI_ALOCK_EXCL) & ExclReadAddr[AWID]) // excl write & excl read outstanding
      |-> ((ExclAddr[AWID] == AWADDR) &
           (ExclSize[AWID] == AWSIZE) &
           (ExclLen[AWID]  == AWLEN)  &
           (ExclBurst[AWID]== AWBURST)&
           (ExclCache[AWID]== AWCACHE)&
           (ExclProt[AWID] == AWPROT) &
           (ExclUser[AWID] == AWUSER)
          );
  endproperty


  // INDEX:        - AXI_ERRM_EXCL_MAX
  // =====
  // Burst lengths that are not a power of two are not checked here, because
  // these will violate EXCLLEN. Bursts of length 1 can never violate this
  // rule. Checked for excl reads only as AXI_ERRM_EXCL_PAIR or AXI_ERRM_EXCL_MATCH will
  // fire if an excl write violates.
  axi_errm_excl_max: assert property (AXI_ERRM_EXCL_MAX) else
   $error("AXI_ERRM_EXCL_MAX. The maximum number of bytes that can be transferred in an exclusive burst is 128. Spec: section 6.2.4 on page 6-5.");
  property AXI_ERRM_EXCL_MAX;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARLOCK,ARLEN})) &
          (ARVALID &                      // valid address
           (ARLOCK == `AXI_ALOCK_EXCL) &  // exclusive transaction
           (ARLEN == `AXI_ALEN_2 ||       // length is power of 2
            ARLEN == `AXI_ALEN_4 ||
            ARLEN == `AXI_ALEN_8 ||
            ARLEN == `AXI_ALEN_16))
      |-> (ArLenInBytes <= 128 ); // max 128 bytes transferred
  endproperty


  // INDEX:        - AXI_ERRM_EXCL_PAIR
  // =====
  axi_errm_excl_pair: assert property (AXI_ERRM_EXCL_PAIR) else
   $error("AXI_ERRM_EXCL_PAIR. An exclusive write must have an earlier outstanding completed exclusive read with the same ID. Spec: section 6.2.2 on page 6-4.");
  property AXI_ERRM_EXCL_PAIR;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWREADY,AWLOCK,AWID})) &
          AWVALID & AWREADY & (AWLOCK == `AXI_ALOCK_EXCL) // excl write
      |-> (ExclReadData[AWID]);                           // excl read with same ID complete
  endproperty


//------------------------------------------------------------------------------
// INDEX:
// INDEX: AXI Rules: USER_* Rules (extension to AXI)
// =====
// The USER signals are user-defined extensions to the AXI spec, so have been
// located separately from the channel-specific rules.
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   1) Functional Rules (none for USER signals)
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   2) Handshake Rules
//------------------------------------------------------------------------------


  // INDEX:        - AXI_ERRM_AWUSER_STABLE
  // =====
  axi_errm_awuser_stable: assert property (AXI_ERRM_AWUSER_STABLE) else
   $error("AXI_ERRM_AWUSER_STABLE. AWUSER must remain stable when AWVALID is asserted and AWREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_AWUSER_STABLE;
    @(posedge ACLK)
          !($isunknown({AWVALID,AWREADY,AWUSER})) &
          ARESETn & AWVALID & !AWREADY
      ##1 ARESETn
      |-> $stable(AWUSER);
  endproperty


  // INDEX:        - AXI_ERRM_WUSER_STABLE
  // =====
  axi_errm_wuser_stable: assert property (AXI_ERRM_WUSER_STABLE) else
   $error("AXI_ERRM_WUSER_STABLE. WUSER must remain stable when WVALID is asserted and WREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_WUSER_STABLE;
    @(posedge ACLK)
          !($isunknown({WVALID,WREADY,WUSER})) &
          ARESETn & WVALID & !WREADY
      ##1 ARESETn
      |-> $stable(WUSER);
  endproperty


  // INDEX:        - AXI_ERRS_BUSER_STABLE
  // =====
  axi_errs_buser_stable: assert property (AXI_ERRS_BUSER_STABLE) else
   $error("AXI_ERRS_BUSER_STABLE. BUSER must remain stable when BVALID is asserted and BREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRS_BUSER_STABLE;
    @(posedge ACLK)
          !($isunknown({BVALID,BREADY,BUSER})) &
          ARESETn & BVALID & !BREADY
      ##1 ARESETn
      |-> $stable(BUSER);
  endproperty


  // INDEX:        - AXI_ERRM_ARUSER_STABLE
  // =====
  axi_errm_aruser_stable: assert property (AXI_ERRM_ARUSER_STABLE) else
   $error("AXI_ERRM_ARUSER_STABLE. ARUSER must remain stable when ARVALID is asserted and ARREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRM_ARUSER_STABLE;
    @(posedge ACLK)
          !($isunknown({ARVALID,ARREADY,ARUSER})) &
          ARESETn & ARVALID & !ARREADY
      ##1 ARESETn
      |-> $stable(ARUSER);
  endproperty


  // INDEX:        - AXI_ERRS_RUSER_STABLE
  // =====
  axi_errs_ruser_stable: assert property (AXI_ERRS_RUSER_STABLE) else
   $error("AXI_ERRS_RUSER_STABLE. RUSER must remain stable when RVALID is asserted and RREADY low. Spec: section 3.1, and figure 3-1, on page 3-2.");
  property AXI_ERRS_RUSER_STABLE;
    @(posedge ACLK)
          !($isunknown({RVALID,RREADY,RUSER})) &
          ARESETn & RVALID & !RREADY
      ##1 ARESETn
      |-> $stable(RUSER);
  endproperty


//------------------------------------------------------------------------------
// INDEX:   3) X-Propagation Rules
//------------------------------------------------------------------------------
`ifdef OVL_XCHECK_OFF
`else  // X-Checking on by default


  // INDEX:        - AXI_ERRM_AWUSER_X
  // =====
  axi_errm_awuser_x: assert property (AXI_ERRM_AWUSER_X) else
   $error("AXI_ERRM_AWUSER_X. When AWVALID is high, a value of X on AWUSER is not permitted. Spec: section 3.1.1 on page 3-3.");
  property AXI_ERRM_AWUSER_X;
    @(posedge ACLK)
        ARESETn & AWVALID
        |-> ! $isunknown(AWUSER);
  endproperty


  // INDEX:        - AXI_ERRM_WUSER_X
  // =====
  axi_errm_wuser_x: assert property (AXI_ERRM_WUSER_X) else
   $error("AXI_ERRM_WUSER_X. When WVALID is high, a value of X on WUSER is not permitted.");
  property AXI_ERRM_WUSER_X;
    @(posedge ACLK)
        ARESETn & WVALID
        |-> ! $isunknown(WUSER);
  endproperty


  // INDEX:        - AXI_ERRS_BUSER_X
  // =====
  axi_errs_buser_x: assert property (AXI_ERRS_BUSER_X) else
   $error("AXI_ERRS_BUSER_X. When BVALID is high, a value of X on BUSER is not permitted.");
  property AXI_ERRS_BUSER_X;
    @(posedge ACLK)
        ARESETn & BVALID
        |-> ! $isunknown(BUSER);
  endproperty


  // INDEX:        - AXI_ERRM_ARUSER_X
  // =====
  axi_errm_aruser_x: assert property (AXI_ERRM_ARUSER_X) else
   $error("AXI_ERRM_ARUSER_X. When ARVALID is high, a value of X on ARUSER is not permitted. Spec: section 3.1.4 on page 3-4.");
  property AXI_ERRM_ARUSER_X;
    @(posedge ACLK)
        ARESETn & ARVALID
        |-> ! $isunknown(ARUSER);
  endproperty


  // INDEX:        - AXI_ERRS_RUSER_X
  // =====
  axi_errs_ruser_x: assert property (AXI_ERRS_RUSER_X) else
   $error("AXI_ERRS_RUSER_X. When RVALID is high, a value of X on RUSER is not permitted.");
  property AXI_ERRS_RUSER_X;
    @(posedge ACLK)
        ARESETn & RVALID
        |-> ! $isunknown(RUSER);
  endproperty

`endif // OVL_XCHECK_OFF


//------------------------------------------------------------------------------
// INDEX:
// INDEX: Auxiliary Logic
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   1) Rules for Auxiliary Logic
//------------------------------------------------------------------------------


  //----------------------------------------------------------------------------
  // INDEX:      a) Master (AUXM*)
  //----------------------------------------------------------------------------


  // INDEX:        - AXI_AUXM_DATA_WIDTH
  // =====
  axi_auxm_data_width: assert property (AXI_AUXM_DATA_WIDTH) else
   $error("AXI_AUXM_DATA_WIDTH. Parameter DATA_WIDTH must be 32, 64, 128, 256, 512 or 1024");
  property AXI_AUXM_DATA_WIDTH;
    @(posedge ACLK)
      (DATA_WIDTH ==   32 ||
       DATA_WIDTH ==   64 ||
       DATA_WIDTH ==  128 ||
       DATA_WIDTH ==  256 ||
       DATA_WIDTH ==  512 ||
       DATA_WIDTH == 1024);
  endproperty


  // INDEX:        - AXI_AUXM_RCAM_OVERFLOW
  // =====
  axi_auxm_rcam_overflow: assert property (AXI_AUXM_RCAM_OVERFLOW) else
    $error("AXI_AUXM_RCAM_OVERFLOW. Read CAM overflow, increase MAXRBURSTS parameter.");
  property AXI_AUXM_RCAM_OVERFLOW;
    @(posedge ACLK)
      ARESETn & !($isunknown(RIndex))
      |-> (RIndex <= (MAXRBURSTS+1));
  endproperty


  // INDEX:        - AXI_AUXM_RCAM_UNDERFLOW
  // =====
  axi_auxm_rcam_underflow: assert property (AXI_AUXM_RCAM_UNDERFLOW) else
   $error("AXI_AUXM_RCAM_UNDERFLOW. Read CAM underflow.");
  property AXI_AUXM_RCAM_UNDERFLOW;
    @(posedge ACLK)
      ARESETn & !($isunknown(RIndex))
      |-> (RIndex > 0);
  endproperty


  // INDEX:        - AXI_AUXM_WCAM_OVERFLOW
  // =====
  axi_auxm_wcam_overflow: assert property (AXI_AUXM_WCAM_OVERFLOW) else
   $error("AXI_AUXM_WCAM_OVERFLOW. Write CAM overflow, increase MAXWBURSTS parameter.");
  property AXI_AUXM_WCAM_OVERFLOW;
    @(posedge ACLK)
      ARESETn & !($isunknown(WIndex))
      |-> (WIndex <= MAXWBURSTS);
  endproperty


  // INDEX:        - AXI_AUXM_WCAM_UNDERFLOW
  // =====
  axi_auxm_wcam_underflow: assert property (AXI_AUXM_WCAM_UNDERFLOW) else
   $error("AXI_AUXM_WCAM_UNDERFLOW. Write CAM underflow");
  property AXI_AUXM_WCAM_UNDERFLOW;
    @(posedge ACLK)
      ARESETn & !($isunknown(WIndex))
      |-> (WIndex > 0);
  endproperty


//------------------------------------------------------------------------------
// INDEX:   2) Combinatorial Logic
//------------------------------------------------------------------------------


  //----------------------------------------------------------------------------
  // INDEX:      a) Masks
  //----------------------------------------------------------------------------


  // INDEX:           - AlignMaskR
  // =====
  // Calculate wrap mask for read address
  always @(ARSIZE or ARVALID)
  begin
    if (ARVALID)
      case (ARSIZE)
        `AXI_ASIZE_1024:  AlignMaskR = 7'b0000000;
        `AXI_ASIZE_512:   AlignMaskR = 7'b1000000;
        `AXI_ASIZE_256:   AlignMaskR = 7'b1100000;
        `AXI_ASIZE_128:   AlignMaskR = 7'b1110000;
        `AXI_ASIZE_64:    AlignMaskR = 7'b1111000;
        `AXI_ASIZE_32:    AlignMaskR = 7'b1111100;
        `AXI_ASIZE_16:    AlignMaskR = 7'b1111110;
        `AXI_ASIZE_8:     AlignMaskR = 7'b1111111;
        default:          AlignMaskR = 7'b1111111;
      endcase
    else
      AlignMaskR = 7'b1111111;
  end


  // INDEX:           - AlignMaskW
  // =====
  // Calculate wrap mask for write address
  always @(AWSIZE or AWVALID)
  begin
    if (AWVALID)
      case (AWSIZE)
        `AXI_ASIZE_1024:  AlignMaskW = 7'b0000000;
        `AXI_ASIZE_512:   AlignMaskW = 7'b1000000;
        `AXI_ASIZE_256:   AlignMaskW = 7'b1100000;
        `AXI_ASIZE_128:   AlignMaskW = 7'b1110000;
        `AXI_ASIZE_64:    AlignMaskW = 7'b1111000;
        `AXI_ASIZE_32:    AlignMaskW = 7'b1111100;
        `AXI_ASIZE_16:    AlignMaskW = 7'b1111110;
        `AXI_ASIZE_8:     AlignMaskW = 7'b1111111;
        default:          AlignMaskW = 7'b1111111;
      endcase // case(AWSIZE)
    else
      AlignMaskW = 7'b1111111;
  end


  // INDEX:           - ExclMask
  // =====
  always @(ARLEN or ARSIZE)
  begin : p_ExclMaskComb
    ExclMask = ~((({7'b000_0000, ARLEN} + 11'b000_0000_0001) << ARSIZE) - 11'b000_0000_0001);
  end // block: p_ExclMaskComb


  // INDEX:           - WdataMask
  // =====
  always @(WSTRB)
  begin : p_WdataMaskComb
    integer i;  // data byte loop counter
    integer j;  // data bit loop counter

    for (i = 0; i < STRB_WIDTH; i = i + 1)
      for (j = i * 8; j <= (i * 8) + 7; j = j + 1)
        WdataMask[j] = WSTRB[i];
  end


  //----------------------------------------------------------------------------
  // INDEX:      b) Increments
  //----------------------------------------------------------------------------


  // INDEX:           - ArAddrIncr
  // =====
  always @(ARSIZE or ARLEN or ARADDR)
  begin : p_RAddrIncrComb
    ArAddrIncr = ARADDR + (ARLEN << ARSIZE);  // The final address of the burst
  end


  // INDEX:           - AwAddrIncr
  // =====
  always @(AWSIZE or AWLEN or AWADDR)
  begin : p_WAddrIncrComb
    AwAddrIncr = AWADDR + (AWLEN << AWSIZE);  // The final address of the burst
  end


  //----------------------------------------------------------------------------
  // INDEX:      c) Conversions
  //----------------------------------------------------------------------------


  // INDEX:           - ArLenInBytes
  // =====
  always @(ARSIZE or ARLEN)
  begin : p_ArLenInBytes
    ArLenInBytes = (({8'h00, ARLEN} + 12'h001) << ARSIZE); // bytes = (ARLEN+1) data transfers x ARSIZE bytes
  end


  // INDEX:           - ArSizeInBits
  // =====
  always @(ARSIZE)
  begin : p_ArSizeInBits
    ArSizeInBits = (11'b000_0000_1000 << ARSIZE); // bits = 8 x ARSIZE bytes
  end


  // INDEX:           - AwSizeInBits
  // =====
  always @(AWSIZE)
  begin : p_AwSizeInBits
    AwSizeInBits = (11'b000_0000_1000 << AWSIZE); // bits = 8 x AWSIZE bytes
  end


  //----------------------------------------------------------------------------
  // INDEX:      d) Other
  //----------------------------------------------------------------------------


  // INDEX:           - ArExclPending
  // =====
  // Avoid putting on OVL port directly as index is an integer
  assign ArExclPending = RExclCam[RidMatch];


  // INDEX:           - ArLenPending
  // =====
  // Avoid putting on OVL port directly as index is an integer
  assign ArLenPending = RLenCam[RidMatch];


//------------------------------------------------------------------------------
// INDEX:   3) EXCL & LOCK Accesses
//------------------------------------------------------------------------------


  // INDEX:        - Exclusive Access Storage
  // =====
  // Store exclusive control info on each read for checking against write
  always @(negedge ARESETn or posedge ACLK)
  begin : p_ExclCtrlSeq
    integer i;  // loop counter

    if (!ARESETn)
      for (i = 0; i <= ID_HI; i = i + 1)
      begin
        ExclReadAddr[i] <= 1'b0;
        ExclReadData[i] <= 1'b0;
        ExclAddr[i]     <= {32{1'b0}};
        ExclSize[i]     <= 3'b000;
        ExclLen[i]      <= 4'h0;
        ExclBurst[i]    <= 2'b00;
        ExclCache[i]    <= 4'h0;
        ExclProt[i]     <= 3'b000;
        ExclUser[i]     <= {ARUSER_WIDTH{1'b0}};
      end
    else // clk edge
    begin
      // exclusive read address transfer
      if (ARVALID && ARREADY && (ARLOCK == `AXI_ALOCK_EXCL))
      begin
        ExclReadAddr[ARID] <= 1'b1; // set exclusive read addr flag for ARID
        ExclReadData[ARID] <= 1'b0; // reset exclusive read data flag for ARID
        ExclAddr[ARID]     <= ARADDR;
        ExclSize[ARID]     <= ARSIZE;
        ExclLen[ARID]      <= ARLEN;
        ExclBurst[ARID]    <= ARBURST;
        ExclCache[ARID]    <= ARCACHE;
        ExclProt[ARID]     <= ARPROT;
        ExclUser[ARID]     <= ARUSER;
      end
      // exclusive write
      if (AWVALID && AWREADY && (AWLOCK == `AXI_ALOCK_EXCL))
      begin
        ExclReadAddr[AWID] <= 1'b0; // reset exclusive address flag for AWID
        ExclReadData[AWID] <= 1'b0; // reset exclusive read data flag for AWID
      end
      // completion of exclusive read data transaction
      if (RVALID && RREADY && RLAST && ExclReadAddr[RID])
        ExclReadData[RID]  <= 1'b1; // set exclusive read data flag for RID
    end // else: !if(!ARESETn)
  end // block: p_ExclCtrlSeq


  // INDEX:        - Lock State Machine
  // =====
  // The state machine transitions when address handshakes take place
  always @( ARLOCK or ARVALID or ARREADY or
            AWLOCK or AWVALID or AWREADY or
            LockState)
  begin : p_LockStateNextComb
    case (LockState)
      `AUX_ST_UNLOCKED :
        if ((ARVALID & ARREADY & (ARLOCK == `AXI_ALOCK_LOCKED)) ||
            (AWVALID & AWREADY & (AWLOCK == `AXI_ALOCK_LOCKED)))
          LockStateNext = `AUX_ST_LOCKED;
        else
          LockStateNext = `AUX_ST_UNLOCKED;

      `AUX_ST_LOCKED :
        if ((ARVALID & ARREADY & (ARLOCK != `AXI_ALOCK_LOCKED)) ||
            (AWVALID & AWREADY & (AWLOCK != `AXI_ALOCK_LOCKED)))
          LockStateNext = `AUX_ST_LOCK_LAST;
        else
          LockStateNext = `AUX_ST_LOCKED;

      `AUX_ST_LOCK_LAST :
        if ((ARVALID & ARREADY & (ARLOCK == `AXI_ALOCK_LOCKED)) ||
            (AWVALID & AWREADY & (AWLOCK == `AXI_ALOCK_LOCKED)))
          LockStateNext = `AUX_ST_LOCKED;

        else if ((ARVALID & ARREADY & (ARLOCK != `AXI_ALOCK_LOCKED)) ||
                 (AWVALID & AWREADY & (AWLOCK != `AXI_ALOCK_LOCKED)))
          LockStateNext = `AUX_ST_UNLOCKED;
        else
          LockStateNext = `AUX_ST_LOCK_LAST;

      `AUX_ST_NOT_USED : LockStateNext = 2'bXX;
                // Unreachable encoding, so X assigned for synthesis don't-care

      default            : LockStateNext = 2'bXX; // X-propagation
    endcase // case(LockState)
  end // always p_LockStateNextComb
  //
  // Lock State Register


  // INDEX:        - Lock Storage
  // =====
  always @(negedge ARESETn or posedge ACLK)
  begin : p_LockStateSeq
    if (!ARESETn)
    begin
      LockState <= `AUX_ST_UNLOCKED;
      LockId    <= {ID_WIDTH{1'b0}};
      LockCache <= 4'b0000;
      LockProt  <= 3'b000;
      LockAddr  <= 32'h00000000;
    end
    else
    begin
      LockState <= LockStateNext;
      LockId    <= LockIdNext;
      LockCache <= LockCacheNext;
      LockProt  <= LockProtNext;
      LockAddr  <= LockAddrNext;
    end
  end


  // INDEX:        - Lock Arrays
  // =====
  assign AWLockNew  = (
                        (LockState == `AUX_ST_UNLOCKED) ||
                        (LockState == `AUX_ST_LOCK_LAST)
                      ) & AWVALID & (AWLOCK == `AXI_ALOCK_LOCKED);

  assign ARLockNew  = (
                        (LockState == `AUX_ST_UNLOCKED) ||
                        (LockState == `AUX_ST_LOCK_LAST)
                      ) & ARVALID & (ARLOCK == `AXI_ALOCK_LOCKED);


  // Store the ID of the first locked transfer
  always @(AWLockNew or ARLockNew or AWLOCK or AWVALID or
            LockId or AWID or ARID)
  begin : p_LockIdNextComb
    case ({ARLockNew,AWLockNew})
      2'b00 : LockIdNext = LockId;      // No new locked burst
      2'b01 : LockIdNext = AWID;        // New locked write burst
      2'b10 : LockIdNext = ARID;        // New locked read burst
      2'b11 : LockIdNext = AWID;        // Both new locked write and read bursts
      default : LockIdNext = {ID_WIDTH{1'bx}};  // X propagation
    endcase
  end // p_LockIdNextComb

  // Store the AxCACHE of the first locked transfer
  always @(AWLockNew or ARLockNew or AWLOCK or AWVALID or
            LockCache or AWCACHE or ARCACHE)
  begin : p_LockCacheNextComb
    case ({ARLockNew,AWLockNew})
      2'b00 : LockCacheNext = LockCache;// No new locked burst
      2'b01 : LockCacheNext = AWCACHE;  // New locked write burst
      2'b10 : LockCacheNext = ARCACHE;  // New locked read burst
      2'b11 : LockCacheNext = AWCACHE;  // Both new locked write and read bursts
      default : LockCacheNext = 4'bxxxx;  // X propagation
    endcase
  end // p_LockCacheNextComb


  // Store the AxPROT of the first locked transfer
  always @(AWLockNew or ARLockNew or AWLOCK or AWVALID or
            LockProt or AWPROT or ARPROT)
  begin : p_LockProtNextComb
    case ({ARLockNew,AWLockNew})
      2'b00 : LockProtNext = LockProt;  // No new locked burst
      2'b01 : LockProtNext = AWPROT;    // New locked write burst
      2'b10 : LockProtNext = ARPROT;    // New locked read burst
      2'b11 : LockProtNext = AWPROT;    // Both new locked write and read bursts
      default : LockProtNext = 3'bxxx;    // X propagation
    endcase
  end // p_LockProtNextComb

  // Store the AxADDR of the first locked transfer
  always @(AWLockNew or ARLockNew or AWLOCK or AWVALID or
            LockAddr or AWADDR or ARADDR)
  begin : p_LockAddrNextComb
    case ({ARLockNew,AWLockNew})
      2'b00 : LockAddrNext = LockAddr;  // No new locked burst
      2'b01 : LockAddrNext = AWADDR;    // New locked write burst
      2'b10 : LockAddrNext = ARADDR;    // New locked read burst
      2'b11 : LockAddrNext = AWADDR;    // Both new locked write and read bursts
      default : LockAddrNext = 32'hXXXXXXXX;  // X propagation
    endcase
  end // p_LockAddrNextComb


//------------------------------------------------------------------------------
// INDEX:   4) Content addressable memories (CAMs)
//------------------------------------------------------------------------------


  // INDEX:        - Read CAMSs (CAM+Shift)
  // =====
  // New entries are added at the end of the CAM.
  // Elements may be removed from any location in the CAM, determined by the
  // first matching RID. When an element is removed, remaining elements
  // with a higher index are shifted down to fill the empty space.

  // Read CAMs store all outstanding addresses for read transactions
  assign RPush  = ARVALID & ARREADY;        // Push on address handshake
  assign RPop   = RVALID & RREADY & RLAST;  // Pop on last handshake

  // Detect when there are no outstanding read transactions
  assign nROutstanding = (RIndex == 1);

  // Find the index of the first item in the CAM that matches the current RID
  // (Note that RIdCamDelta is used to determine when RIdCam has changed)
  always @(RID or RIndex or RIdCamDelta)
  begin : p_RidMatch
    integer i;  // loop counter
    RidMatch = 0;
    for (i=MAXRBURSTS; i>0; i=i-1)
      if ((i < RIndex) && (RID == RIdCam[i]))
        RidMatch = i;
  end

  // Calculate the index of the next free element in the CAM
  always @(RIndex or RPop or RPush)
  begin : p_RIndexNextComb
    case ({RPush,RPop})
      2'b00   : RIndexNext = RIndex;      // no push, no pop
      2'b01   : RIndexNext = RIndex - 1;  // pop, no push
      2'b10   : RIndexNext = RIndex + 1;  // push, no pop
      2'b11   : RIndexNext = RIndex;      // push and pop
      default : RIndexNext = 'bX;         // X-propagation
    endcase
  end
  //
  // RIndex Register
  always @(negedge ARESETn or posedge ACLK)
  begin : p_RIndexSeq
    if (!ARESETn)
      RIndex <= 1;
    else
      RIndex <= RIndexNext;
  end
  //
  // CAM Implementation
  always @(negedge ARESETn or posedge ACLK)
  begin : p_ReadCam
    if (!ARESETn)
    begin : p_ReadCamReset
      integer i;  // loop counter
      // Reset all the entries in the CAM
      for (i=1; i<=MAXRBURSTS; i=i+1)
      begin
        RLenCam[i]  <= 4'h0;
        RIdCam[i]   <= {ID_WIDTH{1'b0}};
        RExclCam[i] <= 1'b0;
        RIdCamDelta <= 1'b0;
      end
    end
    else

    begin

      // Pop item from the CAM, at location determined by RidMatch
      if (RPop)
      begin : p_ReadCamPop
        integer i;  // loop counter
        // Delete item by shifting remaining items
        for (i=1; i<MAXRBURSTS; i=i+1)
          if (i >= RidMatch)
          begin
            RLenCam[i]  <= RLenCam[i+1];
            RIdCam[i]   <= RIdCam[i+1];
            RExclCam[i] <= RExclCam[i+1];
            RIdCamDelta <= ~RIdCamDelta;
          end
      end
      else
        // if not last data item, decrement RLen
        if (RVALID & RREADY)
          RLenCam[RidMatch] <= RLenCam[RidMatch] - 4'h1;

      // Push item at end of the CAM
      // Note that the value of the final index in the CAM is depends on
      // whether another item has been popped
      if (RPush)
      begin
        if (RPop)
        begin
          RLenCam[RIndex-1]   <= ARLEN;
          RIdCam[RIndex-1]    <= ARID;
          RExclCam[RIndex-1]  <= (ARLOCK === `AXI_ALOCK_EXCL);
        end
        else
        begin
          RLenCam[RIndex]     <= ARLEN;
          RIdCam[RIndex]      <= ARID;
          RExclCam[RIndex]    <= (ARLOCK === `AXI_ALOCK_EXCL);
        end // else: !if(RPop)
        RIdCamDelta <= ~RIdCamDelta;
      end // if (RPush)
    end // else: if(!ARESETn)
  end // always @(negedge ARESETn or posedge ACLK)


  // INDEX:        - Write CAMs (CAM+Shift)
  // =====
  // New entries are added at the end of the CAM.
  // Elements may be removed from any location in the CAM, determined by the
  // first matching WID and/or BID. When an element is removed, remaining
  // elements with a higher index are shifted down to fill the empty space.

  // Detect when there are no outstanding write transactions
  assign nWOutstanding =  ~WAddrCam[1];
      // no write transaction in progress has completed address handshake


  // Write bursts stored in single structure for checking when complete.
  // This avoids the problem of early write data.
  always @(negedge ARESETn or posedge ACLK)
  begin : p_WriteCam
    reg [STRB16HI:0] Burst; // temporary store for burst data structure
    if (!ARESETn)
    begin : p_WriteCamReset
      integer i;  // loop counter
      for (i=1; i<=MAXWBURSTS; i=i+1)
      begin
        WBurstCam[i]  = {STRB16HI+1{1'b0}}; // initialise to zero on reset
        WCountCam[i]  = 5'b0; // initialise beat counters to zero
        WLastCam[i]   = 1'b0;
        WAddrCam[i]   = 1'b0;
        BRespCam[i]   = 1'b0;
      end
      WIndex   = 1;
      AidMatch = 1;
      BidMatch = 1;
      WidMatch = 1;
      Burst    = {STRB16HI+1{1'b0}};
      WDataNumError   <= 1'b0;
      WDataOrderError <= 1'b0;
      BrespError      <= 1'b0;
      BrespExokError  <= 1'b0;
      StrbError       <= 1'b0;
   end
    else
    begin
      // default is no errors
      WDataNumError   <= 1'b0;
      WDataOrderError <= 1'b0;
      BrespError      <= 1'b0;
      BrespExokError  <= 1'b0;
      StrbError       <= 1'b0;

      // -----------------------------------------------------------------------
      // Valid write response
      if (BVALID)
      begin

        // Find matching burst
        begin : p_WriteCamMatchB
          integer i;  // loop counter

          BidMatch = WIndex; // default is no match
          for (i=MAXWBURSTS; i>0; i=i-1)
            if (i < WIndex) // only consider valid entries in WBurstCam
            begin
              Burst = WBurstCam[i];
              if (BID == Burst[IDHI:IDLO] && // BID matches, and
                  ~BRespCam[i]) // write response not already transferred
                BidMatch = i;
            end
        end // p_WriteCamMatchB

        Burst = WBurstCam[BidMatch];  // set temporary burst signal

        BRespCam[BidMatch] = BREADY;  // record if write response completed


        // Check that BID matches outstanding WID or AWID
        if (~(BidMatch < WIndex))
          BrespError <= 1'b1;         // trigger AXI_ERRS_BRESP

        // The following checks are only performed if the write response matches
        // an existing burst
        else begin

          // Check all write data in burst is complete
          // Note: this test must occur before the WLastCam is updated
          if (~WLastCam[BidMatch]) // last data not received
            BrespError <= 1'b1;         // trigger AXI_ERRS_BRESP

          // Check for EXOKAY response to non-exclusive transaction
          if (Burst[EXCL] == 1'b0 && BRESP == `AXI_RESP_EXOKAY)
            BrespExokError <= 1'b1;

          // Write response handshake completes burst when write address has
          // already been received, and triggers protocol checking
          if (BREADY & WAddrCam[BidMatch])
          begin : p_WriteCamPopB
            integer i;  // loop counter
            // Check WSTRB
            StrbError <= CheckBurst(WBurstCam[BidMatch], WCountCam[BidMatch]);

            // pop completed burst from CAM
            for (i = 1; i < MAXWBURSTS; i = i+1)
            begin
              if (i >= BidMatch) // only shift items after popped burst
              begin
                WBurstCam[i]   = WBurstCam[i+1];
                WCountCam[i]   = WCountCam[i+1];
                WLastCam[i]    = WLastCam[i+1];
                WAddrCam[i]    = WAddrCam[i+1];
                BRespCam[i]    = BRespCam[i+1];
              end
            end

            // Reset flags on new empty element
            WBurstCam[WIndex]  = {STRB16HI+1{1'b0}};
            WCountCam[WIndex]  = 5'b0;
            WLastCam[WIndex]   = 1'b0;
            WAddrCam[WIndex]   = 1'b0;
            BRespCam[WIndex]   = 1'b0;

            WIndex = WIndex - 1; // decrement index

          end // if (BREADY & WAddrCam[BidMatch])
        end // else !(~(BidMatch < WIndex))
      end // if (BVALID)

      // -----------------------------------------------------------------------
      // Valid write data
      if (WVALID)
      begin : p_WriteCamWValid
        integer i;  // loop counter

        // find matching burst in progress
        WidMatch = WIndex; // default - no match
        for (i = MAXWBURSTS; i > 0; i = i-1)
          if (i < WIndex) // only consider valid entries in WBurstCam
          begin
            Burst = WBurstCam[i];
            if (WID == Burst[IDHI:IDLO] &&  // ID matches
                ~WLastCam[i])             // not already received last data item
              WidMatch = i;
          end

        Burst = WBurstCam[WidMatch]; // temp store for 2-D burst lookup

        // if last data item or correct number of data items received already,
        // check number of data items and WLAST against AWLEN.
        // WCountCam hasn't yet incremented so can be compared with AWLEN
        if  ( WAddrCam[WidMatch] & // Only perform test if address is known
              ( (WLAST & (WCountCam[WidMatch] != {1'b0,Burst[ALENHI:ALENLO]})) |
                (~WLAST & (WCountCam[WidMatch] == {1'b0,Burst[ALENHI:ALENLO]}))
              )
            )
          WDataNumError <= 1'b1;

        // if 1st data item, check that earlier bursts have all got 1st data
        // item to enforce the AXI_ERRM_WDATA_ORDER protocol rule
        if (WCountCam[WidMatch] == 5'b0)
        begin
          for (i = 1; i <= MAXWBURSTS; i = i+1)
            if (i < WidMatch)
              if (WCountCam[i] == 0)
                WDataOrderError <= 1'b1;
        end

        // need to use full case statement to occupy WSTRB as in Verilog the
        // bit slice range must be bounded by constant expressions
        case (WCountCam[WidMatch])
          5'h0 : Burst[STRB1HI:STRB1LO]   = WSTRB;
          5'h1 : Burst[STRB2HI:STRB2LO]   = WSTRB;
          5'h2 : Burst[STRB3HI:STRB3LO]   = WSTRB;
          5'h3 : Burst[STRB4HI:STRB4LO]   = WSTRB;
          5'h4 : Burst[STRB5HI:STRB5LO]   = WSTRB;
          5'h5 : Burst[STRB6HI:STRB6LO]   = WSTRB;
          5'h6 : Burst[STRB7HI:STRB7LO]   = WSTRB;
          5'h7 : Burst[STRB8HI:STRB8LO]   = WSTRB;
          5'h8 : Burst[STRB9HI:STRB9LO]   = WSTRB;
          5'h9 : Burst[STRB10HI:STRB10LO] = WSTRB;
          5'hA : Burst[STRB11HI:STRB11LO] = WSTRB;
          5'hB : Burst[STRB12HI:STRB12LO] = WSTRB;
          5'hC : Burst[STRB13HI:STRB13LO] = WSTRB;
          5'hD : Burst[STRB14HI:STRB14LO] = WSTRB;
          5'hE : Burst[STRB15HI:STRB15LO] = WSTRB;
          5'hF : Burst[STRB16HI:STRB16LO] = WSTRB;
          default : Burst[STRB16HI:STRB16LO] = {STRB_WIDTH{1'bx}};
        endcase

        // Store the WID in the CAM
        Burst[IDHI:IDLO] = WID; // record ID in case address not yet received
        WBurstCam[WidMatch] = Burst; // copy back from temp store

        // when write data transfer completes, determine if last
        WLastCam[WidMatch] = WLAST & WREADY; // record whether last data completed

        // When transfer completes, increment the count
        WCountCam[WidMatch] =
          WREADY ? WCountCam[WidMatch] + 5'b00001:    // inc count
                   WCountCam[WidMatch];


        if (WidMatch == WIndex) // if new burst, increment CAM index
          WIndex = WIndex + 1;

      end // if (WVALID)

      // -----------------------------------------------------------------------
      // Valid write address
      if (AWVALID)
      begin

        // find matching burst in progress
        begin : p_WriteCamMatchAw
          integer i;  // loop counter

          AidMatch = WIndex; // assume no match

          for (i = MAXWBURSTS; i > 0; i = i-1)
            if (i < WIndex) // only consider valid entries in WBurstCam
            begin
              Burst = WBurstCam[i];
              if (AWID == Burst[IDHI:IDLO] &&  // AWID matches, and
                  ~WAddrCam[i]) // write address not already transferred
                AidMatch = i;
            end
        end // p_WriteCamMatchAw

        Burst = WBurstCam[AidMatch];

        Burst[ADDRHI:ADDRLO]   = AWADDR[ADDRHI:ADDRLO];
        Burst[EXCL]            = AWLOCK[0];
        Burst[BURSTHI:BURSTLO] = AWBURST;
        Burst[ALENHI:ALENLO]   = AWLEN;
        Burst[ASIZEHI:ASIZELO] = AWSIZE;
        Burst[IDHI:IDLO]       = AWID;

        WBurstCam[AidMatch] = Burst;  // copy back from temp store

        WAddrCam[AidMatch] = AWREADY; // record if write address completed

        // assert protocol error flag if address received after last data item
        // and data count does not match ALEN
        if (WLastCam[AidMatch] &  // perform test only if last data received
            ({1'b0, Burst[ALENHI:ALENLO]} + 5'b00001 != WCountCam[AidMatch]))
          WDataNumError <= 1'b1;

        // Check that earlier bursts have all got address to enforce the
        // AXI_ERRM_WDATA_ORDER protocol rule
        begin : p_WriteCamWdataOrder
          integer i;  // loop counter

          for (i = 1; i <= MAXWBURSTS; i=i+1)
            begin
              if (i < AidMatch)             // check all earlier bursts
                if (WAddrCam[i] != 1'b1)    // address not yet received
                  WDataOrderError <= 1'b1;  // trigger assertion
            end
        end // p_WriteCamWdataOrder

        // If new burst, increment CAM index
        if (AidMatch == WIndex)
          WIndex = WIndex + 1;

        // Write address handshake completes burst when write response has
        // already been received, and triggers protocol checking
        else if (AWREADY & BRespCam[AidMatch])
        begin : p_WriteCamPopAw
          integer i;  // loop counter
          // Check WSTRB
          StrbError <= CheckBurst(WBurstCam[BidMatch], WCountCam[BidMatch]);

          // pop completed burst from CAM
          for (i = 1; i < MAXWBURSTS; i = i+1)
            if (i >= AidMatch) // only shift items after popped burst
            begin
              WBurstCam[i]    = WBurstCam[i+1];
              WCountCam[i]    = WCountCam[i+1];
              WLastCam[i]     = WLastCam[i+1];
              WAddrCam[i]     = WAddrCam[i+1];
              BRespCam[i]     = BRespCam[i+1];
            end

          // Reset flags on new empty element
          WBurstCam[WIndex]  = {STRB16HI+1{1'b0}};
          WCountCam[WIndex]  = 5'b0;
          WLastCam[WIndex]   = 1'b0;
          WAddrCam[WIndex]   = 1'b0;
          BRespCam[WIndex]   = 1'b0;

          WIndex = WIndex - 1; // decrement index

        end // if (AWREADY & BRespCam[AidMatch])

      end // new write address

    end // else: !if(!ARESETn)
  end // always @(negedge ARESETn or posedge ACLK)


  // INDEX:        - Write Depth array
  // =====
  // Array monitors interleaved write data

  // Next WIDs in use for register
  always @(WidInUse or WVALID or WREADY or WID or WLAST)
  begin : p_WidInUseNextComb
    WidInUseNext = WidInUse;    // Default
    if (WVALID &                // If valid...
           WREADY)
          // WREADY term is included so that AXI_ERRM_WDEPTH rule does not error if
          // WID changes when WVALID is asserted (breaking WID_STABLE rule)
      WidInUseNext[WID] = ~WLAST; //  Clear flag on WLAST, else set for WID
  end  // p_WidInUseNextComb

  // Register the WIDs in use
  always @(negedge ARESETn or posedge ACLK)
  begin : p_WidInUseSeq
    integer id; // loop counter
    if (!ARESETn)
      WidInUse <= {ID_HI+1{1'b0}};  // No WIDs in use at reset
    else
      WidInUse <= WidInUseNext;
  end // p_WidInUseSeq

  // Sum the bits from the WidInUse register to give the current write depth
  always @(WidInUse or WID or WVALID)
  begin : p_WidDepthComb
    integer id; // loop counter
    WidDepth = 0;
    for (id = 0; id <= ID_HI; id = id + 1)
      if (WidInUse[id] == 1'b1)
        WidDepth = 1 + WidDepth;
    // Add one if a new WID is in use
    WidDepth = WidDepth + (~WidInUse[WID] & WVALID);
  end // p_WidDepthComb


//------------------------------------------------------------------------------
// INDEX:   5) Verilog Functions
//------------------------------------------------------------------------------


  // INDEX:        - CheckBurst
  // =====
  // Inputs: Burst (burst data structure)
  //         Count (number of data items)
  // Returns: High is any of the write strobes are illegal
  // Calls CheckStrb to test each WSTRB value.
  //------------------------------------------------------------------------------
  function CheckBurst;
    input [STRB16HI:0] Burst;         // burst vector
    input [5:0]        Count;         // number of beats in the burst
    integer            loop;          // general loop counter
    integer            NumBytes;      // number of bytes in the burst
    reg          [6:0] StartAddr;     // start address of burst
    reg          [6:0] StrbAddr;      // address used to check WSTRB
    reg          [2:0] StrbSize;      // size used to check WSTRB
    reg          [3:0] StrbLen;       // length used to check WSTRB
    reg   [STRB_MAX:0] Strb;          // WSTRB to be checked
    reg          [9:0] WrapMaskWide;  // address mask for wrapping bursts
    reg          [6:0] WrapMask;      // relevant bits WrapMaskWide
  begin

    StartAddr   = Burst[ADDRHI:ADDRLO];
    StrbAddr    = StartAddr; // incrementing address initialises to start addr
    StrbSize    = Burst[ASIZEHI:ASIZELO];
    StrbLen     = Burst[ALENHI:ALENLO];
    CheckBurst  = 1'b0;

    // Initialize to avoid latch warnings (not really latches as they are set in loop)
    Strb         = {STRB_WIDTH{1'bX}};
    WrapMask     =          {7{1'bX}};
    WrapMaskWide =         {10{1'bX}};

    // determine the number of bytes in the burst for wrapping purposes
    NumBytes = (StrbLen + 1) << StrbSize;

    // Check the strobe for each write data transfer
    for (loop=1; loop<=16; loop=loop+1)
    begin
      if (loop <= Count) // Only consider entries up to burst length
      begin

        // Need to use full case statement to index WSTRB as in Verilog the
        // bit slice range must be bounded by constant expressions
        case (loop)
          1  : Strb = Burst[STRB1HI:STRB1LO];
          2  : Strb = Burst[STRB2HI:STRB2LO];
          3  : Strb = Burst[STRB3HI:STRB3LO];
          4  : Strb = Burst[STRB4HI:STRB4LO];
          5  : Strb = Burst[STRB5HI:STRB5LO];
          6  : Strb = Burst[STRB6HI:STRB6LO];
          7  : Strb = Burst[STRB7HI:STRB7LO];
          8  : Strb = Burst[STRB8HI:STRB8LO];
          9  : Strb = Burst[STRB9HI:STRB9LO];
          10 : Strb = Burst[STRB10HI:STRB10LO];
          11 : Strb = Burst[STRB11HI:STRB11LO];
          12 : Strb = Burst[STRB12HI:STRB12LO];
          13 : Strb = Burst[STRB13HI:STRB13LO];
          14 : Strb = Burst[STRB14HI:STRB14LO];
          15 : Strb = Burst[STRB15HI:STRB15LO];
          16 : Strb = Burst[STRB16HI:STRB16LO];
          default : Strb = {STRB_WIDTH{1'bx}};
        endcase

        // returns high if any strobes are illegal
        if (CheckStrb(StrbAddr, StrbSize, Strb))
        begin
          CheckBurst = 1'b1;
        end

        // -----------------------------------------------------------------------
        // Increment aligned StrbAddr
        if (Burst[BURSTHI:BURSTLO] != `AXI_ABURST_FIXED)
          // fixed bursts don't increment or align the address
        begin
          // align and increment address,
          // Address is incremented from an aligned version
          StrbAddr = StrbAddr &
            (7'b111_1111 - (7'b000_0001 << StrbSize) + 7'b000_0001);
                                                                // align to size
          StrbAddr = StrbAddr + (7'b000_0001 << StrbSize);      // increment
        end // if (Burst[BURSTHI:BURSTLO] != `AXI_ABURST_FIXED)

        // for wrapping bursts the top bits of the strobe address remain fixed
        if (Burst[BURSTHI:BURSTLO] == `AXI_ABURST_WRAP)
        begin
          WrapMaskWide = (10'b11_1111_1111 - NumBytes + 10'b00_0000_0001);
                                            // To wrap the address, need 10 bits
          WrapMask = WrapMaskWide[6:0];
                    // Only 7 bits of address are necessary to calculate strobe
          StrbAddr = (StartAddr & WrapMask) | (StrbAddr & ~WrapMask);
                // upper bits remain stable for wrapping bursts depending on the
                // number of bytes in the burst
        end
      end // if (loop < Count)
    end // for (loop=1; loop<=WDEPTH; loop=loop+1)
  end
  endfunction // CheckBurst


  // INDEX:        - CheckStrb
  // =====
  function CheckStrb;
    input        [6:0] StrbAddr;
    input        [2:0] StrbSize;
    input [STRB_MAX:0] Strb;
    reg   [STRB_MAX:0] StrbMask;
  begin

    // The basic strobe for an aligned address
    StrbMask = (STRB_1 << (STRB_1 << StrbSize)) - STRB_1;

    // Zero the unaligned byte lanes
    // Note: the number of unaligned byte lanes is given by:
    // (StrbAddr & ((1 << StrbSize) - 1)), i.e. the unaligned part of the
    // address with respect to the transfer size
    //
    // Note! {{STRB_MAX{1'b0}}, 1'b1} gives 1 in the correct vector length

    StrbMask = StrbMask &                   // Mask off unaligned byte lanes
      (StrbMask <<                          // shift the strb mask left by
        (StrbAddr & ((STRB_1 << StrbSize) -  STRB_1))
                                            // the number of unaligned byte lanes
      );

    // Shift mask into correct byte lanes
    // Note: (STRB_MAX << StrbSize) & STRB_MAX is used as a mask on the address
    // to pick out the bits significant bits, with respect to the bus width and
    // transfer size, for shifting the mask to the correct byte lanes.
    StrbMask = StrbMask << (StrbAddr & ((STRB_MAX << StrbSize) & STRB_MAX));

    // check for strobe error
    CheckStrb = (|(Strb & ~StrbMask));

  end
  endfunction // CheckStrb


  // INDEX:        - CheckXorZ
  // =====
  // Inputs: Control signal (to check for X or Z)
  // Returns: 1'b0 or 1'bX (if any X/Z at any clock cycle)
  //
  // Note: Not using a "width" parameter, as verilog does not allow overloading
  //       of functions (different parameters) in the same calling module! Ensure
  //       width is sufficient for all control signals (zero-extending is OK).
  //------------------------------------------------------------------------------
  function CheckXorZ;
     input [31:0] control_signal; // will zero-extend smaller bit-widths
     begin
        CheckXorZ = |(control_signal ^ control_signal); // can only be 1'b0 or 1'bX
     end
  endfunction // CheckXorZ


  // INDEX:        - CheckXorZifValid
  // =====
  // Inputs: VALID + Control signal (to check for X or Z at any time)
  // Returns: 1'b0 or 1'bX (if any X/Z when VALID is 1'b1)
  //
  // Note: Not using a "width" parameter, as verilog does not allow overloading
  //       of functions (different parameters) in the same calling module! Ensure
  //       width is sufficient for all control signals (zero-extending is OK).
  //------------------------------------------------------------------------------
  function CheckXorZifValid;
     input        valid_enable;
     input [31:0] control_signal;
     begin
        if (valid_enable)
           CheckXorZifValid = |(control_signal ^ control_signal); // can only be 1'b0 or 1'bX
         else
           CheckXorZifValid = 1'b0; // don't check if enable is 1'b0 or 1'bX
     end
  endfunction // CheckXorZifValid


//------------------------------------------------------------------------------
// INDEX:
// INDEX: End of File
//------------------------------------------------------------------------------


//------------------------------------------------------------------------------
// INDEX:   1) Clear Verilog Defines
//------------------------------------------------------------------------------

  // Lock FSM States (3-state FSM, so one state encoding is not used)
  `undef AUX_ST_UNLOCKED
  `undef AUX_ST_LOCKED
  `undef AUX_ST_LOCK_LAST
  `undef AUX_ST_NOT_USED

  // OVL Severity levels
  `undef OVL_SimFatal
  `undef OVL_SimError
  `undef OVL_SimWarning
  `undef OVL_SimCover
  `undef OVL_SimInfo

  // OVL Proof Options (all others set via parameters)
  `undef OVL_SkipFormalProof


//------------------------------------------------------------------------------
// INDEX:   2) End of module
//------------------------------------------------------------------------------

endmodule // AxiPC
