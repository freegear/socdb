//-------------------------------------------------------------------------
//
//                    Chipidea Microelectronica S.A.
//                               TagusPark
//                       Avenida Dr. Mario Soares, 33
//                      2740-119 Porto Salvo, Portugal
//               Tel: +351 210336300    Fax: +351 210336396
//       Mail: chipidea@chipidea.com    URL: http://www.chipidea.com
//
//-------------------------------------------------------------------------
//
// Author        : Rui Rodrigues 
// Contact       : rmrodrig@chipidea.com 
//
//-------------------------------------------------------------------------
//
// Cell/Project  : ci8718tl_10b200vdac
// Simulator     : Modelsim 6.2d
// Language      : Verilog
// Related files : None
// Description   : Model of the Single 10bit, 27Mhz 3.3V/1.2V Video DAC
// Special notes :
//
//  * Test modes are not implemented: enctr1..0 = 1'b0 for normal
//    operation.
//
//  * Analog signals are represented by 64 bit buses. They are converted
//    to real and from real representation using PLI functions
//    $bitstoreal and $realtobits respectively
//    ex:
//      reg[63:0] a;
//      reg[63:0] b;
//      real rl_a;
//      real rl_b;
//      (...)
//      rl_a = $bitstoreal(a);
//      (...)
//      b = $realtobits(rl_b);
//
//-------------------------------------------------------------------------
//
// History:
// Date       Who      Description
// 2007/02/13 rmrodrig Created this file.
//
//-------------------------------------------------------------------------
`timescale 1ns/10ps

module ci8718tl_10b200vdac (
    agnd,       // Analog ground.
    agnd1,      // Analog ground reference.
    avdd0,      // Analog supply.
    avdd1,      // Analog supply.
    dgnd,       // Digital ground.
    dvdd,       // Digital power supply.
    iref,       // Reference current.
    ireffb,     // Sensing pin for iref.
    bypidac,    // External reference current enable (active high).
    clk,        // Clock signal for DAC.
    dacb0,      // Input bit for DAC.
    dacb1,      // Input bit for DAC.
    dacb2,      // Input bit for DAC.
    dacb3,      // Input bit for DAC.
    dacb4,      // Input bit for DAC.
    dacb5,      // Input bit for DAC.
    dacb6,      // Input bit for DAC.
    dacb7,      // Input bit for DAC.
    dacb8,      // Input bit for DAC.
    dacb9,      // Input bit for DAC.
    en34,       // 34 mA output full-scale enabled (active high).
    enctr0,     // Enable control pin for analog biasing test.
    enctr1,     // Enable control pin for analog biasing test.
    endac,      // Enable control pin to power up the DAC.
    vdref,      // Reference voltage supply.
    ioutn,      // Negative output current for the DAC.
    ioutp       // Positive output current for the DAC.
);

//rtl_synthesis off
//ambit synthesis off
//ambit translate off
//synopsys translate_off
//surelint translate_off

    //-- Parameters -------------------------------------------------------
    //--
    parameter REFRES    = 1150.0;       // (ohm) Reference current resistor.
    parameter KIFS      = 32.0;         // Iref to Ifs conversion factor.
    parameter AVDDMIN   = 2.43;         // (V) Minimum avdd voltage.
    parameter AVDDMAX   = 3.6;          // (V) Maximum avdd voltage.
    parameter DVDDMIN   = 1.08;         // (V) Minimum dvdd voltage.
    parameter DVDDMAX   = 1.32;         // (V) Maximum dvdd voltage.
    parameter TPD       = 0.5;          // (ns) Analog output delay.
    parameter TSETTLE   = 4.0;          // (ns) Analog output settling time.
    parameter WAKEUPSHT = 3_000;        // (ns) Wake up time from shutdown.
    parameter VBG       = 1.221875;     // (V) Bandgap voltage.
    parameter IBIASMAX  = 1.0e-3*1.3;   // (A) Maximum ibias current.
    parameter IBIASMIN  = 1.0e-3*0.7;   // (A) Minimum ibias current.
    parameter NBITS     = 10;           // (bits) DAC resolution;
    //--
    //-- Parameters -------------------------------------------------------

//rtl_synthesis on
//ambit synthesis on
//ambit translate on
//synopsys translate_on
//surelint translate_on

    //-- Ports ------------------------------------------------------------
    //--

    input   [63:0]     agnd;
    input   [63:0]     agnd1;
    input   [63:0]     avdd0;
    input   [63:0]     avdd1;
    input   [63:0]     dgnd;
    input   [63:0]     dvdd;
    input   [63:0]     iref;
    input   [63:0]     ireffb; 

    input        bypidac;
    input        clk;
    input        dacb0;
    input        dacb1;
    input        dacb2;
    input        dacb3;
    input        dacb4;
    input        dacb5;
    input        dacb6;
    input        dacb7;
    input        dacb8;
    input        dacb9;
    input        en34;
    input        enctr0;
    input        enctr1;
    input        endac;
    //input    [63:0]    vdref;
    output   [63:0]    vdref;
    output   [63:0]    ioutn;
    output   [63:0]    ioutp;


    /*
    inout        agnd;
    inout        agnd1;
    inout        avdd0;
    inout        avdd1;
    inout        dgnd;
    inout        dvdd;
    inout        iref;
    inout        ireffb; 
    input        bypidac;
    input        clk;
    input        dacb0;
    input        dacb1;
    input        dacb2;
    input        dacb3;
    input        dacb4;
    input        dacb5;
    input        dacb6;
    input        dacb7;
    input        dacb8;
    input        dacb9;
    input        en34;
    input        enctr0;
    input        enctr1;
    input        endac;
    input        vdref;
    output       ioutn;
    output       ioutp;
    */
    //--
    //-- Ports ------------------------------------------------------------

//rtl_synthesis off
//ambit synthesis off
//ambit translate off
//synopsys translate_off
//surelint translate_off

    //-- Variables --------------------------------------------------------
    //--
    wire [63:0] agnd;           real rl_agnd;
    wire [63:0] agnd1;          real rl_agnd1;
    wire [63:0] avdd0;          real rl_avdd0;
    wire [63:0] avdd1;          real rl_avdd1;
    wire [63:0] dgnd;           real rl_dgnd;
    wire [63:0] dvdd;           real rl_dvdd;
    wire [63:0] iref;           real rl_iref;
    wire [63:0] ireffb;         real rl_ireffb;
    wire        bypidac;
    wire        clk;
    wire        dacb0;
    wire        dacb1;
    wire        dacb2;
    wire        dacb3;
    wire        dacb4;
    wire        dacb5;
    wire        dacb6;
    wire        dacb7;
    wire        dacb8;
    wire        dacb9;
    wire        en34;
    wire        enctr0;
    wire        enctr1;
    wire        endac;
    wire [63:0] vdref;          real rl_vdref;
    wire [63:0] ioutn;          real rl_ioutn;
    wire [63:0] ioutp;          real rl_ioutp;

    wire        powerOk;
    wire        powerOn;
    wire [63:0] ifs;            real rl_ifs;
    //--
    //-- Variables --------------------------------------------------------

    //-- Instances --------------------------------------------------------
    //--
    ci8718tl_10b200vdac_pwrctrl
    #(0.0, WAKEUPSHT)
    POWERUP (
        .enpd(~endac | ~powerOk),
        .enstb(1'b0),
        .enable(1'b1),
        .pdz(),
        .stbz(),
        .on(powerOn)
    );

    // DAC 
    ci8718tl_10b200vdac_dac
    #(1.0, TPD, TSETTLE, NBITS)
    DAC (
        .clk(clk),
        .dacb({dacb9,dacb8,dacb7,dacb6,dacb5,dacb4,dacb3,dacb2,dacb1,dacb0}),
        .endac(powerOn & endac),
        .iref(ifs),
        .ioutn(ioutn),
        .ioutp(ioutp)
    );
    //--
    //-- Instances --------------------------------------------------------

    //-- Behaviour --------------------------------------------------------
    //--
    //-- Full scale output current
    assign iref = (bypidac === 1'b1) ? {64{1'bz}} : $realtobits(VBG / REFRES);
    initial assign rl_ifs = 2.0 * rl_iref * KIFS / (2.0 - en34);
    assign ifs = $realtobits(rl_ifs);

    //-- vdref
    assign vdref = powerOn === 1'b1 ? $realtobits(VBG) : {64{1'bz}};

    //-- Reference current feedback check
    always @(iref or ireffb)
    begin
        #(1);
        if (iref !== ireffb)
            $display("-W- ci8718tl_10b200vdac @%0d ireffb: feedback current is incorrect.", $time);
    end

    //-- Verification of power Up conditions
    assign powerOk = (
        rl_avdd0 - rl_agnd  <= AVDDMAX &&
        rl_avdd0 - rl_agnd  >= AVDDMIN &&
        rl_avdd1 - rl_agnd  <= AVDDMAX &&
        rl_avdd1 - rl_agnd  >= AVDDMIN &&
        rl_dvdd  - rl_dgnd  <= DVDDMAX &&
        rl_dvdd  - rl_dgnd  >= DVDDMIN &&
        enctr0 | enctr1 === 1'b0 &&
        (bypidac === 1'b0        ||
            rl_iref  > IBIASMIN  &&
            rl_iref  < IBIASMAX
        )
    );

    //-- Converting analog signals to their real equivalent
    initial assign rl_agnd   = $bitstoreal(agnd  );
    initial assign rl_agnd1  = $bitstoreal(agnd1 );
    initial assign rl_avdd0  = $bitstoreal(avdd0 );
    initial assign rl_avdd1  = $bitstoreal(avdd1 );
    initial assign rl_dgnd   = $bitstoreal(dgnd  );
    initial assign rl_dvdd   = $bitstoreal(dvdd  );
    initial assign rl_iref   = $bitstoreal(iref  );
    initial assign rl_vdref  = $bitstoreal(vdref );
    initial assign rl_ioutn  = $bitstoreal(ioutn );
    initial assign rl_ioutp  = $bitstoreal(ioutp );
    initial assign rl_ireffb = $bitstoreal(ireffb);
    //--
    //-- Behaviour --------------------------------------------------------

//rtl_synthesis on
//ambit synthesis on
//ambit translate on
//synopsys translate_on
//surelint translate_on

endmodule // ci8718tl_10b200vdac

//rtl_synthesis off
//ambit synthesis off
//ambit translate off
//synopsys translate_off
//surelint translate_off

//----------------------------------------------------------------------
//  Module       : ci8718tl_10b200vdac_pwrctrl
//  Contact      : modeling@chipidea.com
//  Description  : Power up control module
//----------------------------------------------------------------------
module ci8718tl_10b200vdac_pwrctrl(
    enpd,       // Enable power down mode
    enstb,      // Enable standby mode
    enable,     // Enable power on control module
    pdz,        // Power down
    stbz,       // Standby
    on          // Power on
);

    //-- Parameters  ------------------------------------------------------
    //--
    parameter WAKEUPSTB = 0.0;  // (ns) Wake up time from standby
    parameter WAKEUPSHT = 0.0;  // (ns) Wake up time from shutdown
    //--
    //-- Parameters  ------------------------------------------------------

    //-- Ports  -----------------------------------------------------------
    //--
    input       enpd;
    input       enstb;
    input       enable;
    output      pdz;
    output      stbz;
    output      on;
    //--
    //-- Ports  -----------------------------------------------------------

    //-- Variables --------------------------------------------------------
    //--
    wire        enpd;
    wire        enstb;
    wire        enable;
    wire        pdz;
    wire        stbz;
    wire        on;

    wire        pdz_t;
    wire        stbz_t;
    reg         enstb_int;
    reg         enpd_int;
    //--
    //-- Variables --------------------------------------------------------

    //-- Behaviour --------------------------------------------------------
    //--
    initial
    begin
        enstb_int = 1'b0;
        enpd_int = 1'b0;
    end
    always @(enstb) #(0) enstb_int = enstb;
    always @(enpd) #(0) enpd_int = enpd;
    buf #(WAKEUPSTB, 0.0) (stbz_t , ~enstb_int);
    buf #(WAKEUPSHT, 0.0) (pdz_t  , ~enpd_int);

    assign stbz = enable ? (stbz_t === 1'bx ? 1'b0 : stbz_t) : ~enstb;
    assign pdz  = enable ? ( pdz_t === 1'bx ? 1'b0 :  pdz_t) : ~enpd;
    assign on   = enable & stbz & pdz;
    //--
    //-- Behaviour --------------------------------------------------------

endmodule // ci8718tl_10b200vdac_pwrctrl

//----------------------------------------------------------------------
//  Module       : ci8718tl_10b200vdac_dac
//  Contact      : modeling@chipidea.com
//  Description  : Implements a 10bit dac with current output
//----------------------------------------------------------------------

module ci8718tl_10b200vdac_dac(
    clk,        // clock signal
    dacb,       // input bits for dac
    endac,      // enable control for dac
    iref,       // reference current
    ioutp,      // positive output current
    ioutn       // negative output current
);

    //-- Parameters  ---------------------------------------------------
    //--
    parameter IGAIN    = 1.0;   // (A/A) Gain applied to reference 
                                // current to achieve full scale.
    parameter TDELAY   = 0.0;   // (ns) Time propagation delay after clk 
                                // negedge.
    parameter TSETTLE  = 0.0;   // (ns) Output settling time.
    parameter NBITS    = 10;    // (bits) DAC resolution.
    //--
    //-- Parameters  ---------------------------------------------------

    //-- Ports  --------------------------------------------------------
    //--
    input clk;
    input [NBITS-1:0] dacb;
    input endac;
    input iref;
    output ioutp;
    output ioutn;
    //--
    //-- Ports  --------------------------------------------------------

    //-- Variables -----------------------------------------------------
    //--
    wire clk;
    wire [NBITS-1:0] dacb;
    wire endac;
    wire [63:0] iref;       real rl_iref;
    wire [63:0] ioutp;      real rl_ioutp;
    wire [63:0] ioutn;      real rl_ioutn;

    real rl_ifs;
    reg [NBITS-1:0] bin;

    real rl_frac_iout;
    wire endac_int;
    real rl_iout_int;
    wire [63:0] ioutp_int;
    wire [63:0] ioutn_int;
    //--
    //-- Variables -----------------------------------------------------

    //-- Specify -------------------------------------------------------
    //--
    specify
        specparam tsetup_clk_b = 0.3;    // (ns) Input word setup time
        specparam thold_clk_b  = 0.8;    // (ns) Input word hold time

        $setup(dacb[9], negedge clk &&& endac, tsetup_clk_b);
        $setup(dacb[8], negedge clk &&& endac, tsetup_clk_b);
        $setup(dacb[7], negedge clk &&& endac, tsetup_clk_b);
        $setup(dacb[6], negedge clk &&& endac, tsetup_clk_b);
        $setup(dacb[5], negedge clk &&& endac, tsetup_clk_b);
        $setup(dacb[4], negedge clk &&& endac, tsetup_clk_b);
        $setup(dacb[3], negedge clk &&& endac, tsetup_clk_b);
        $setup(dacb[2], negedge clk &&& endac, tsetup_clk_b);
        $setup(dacb[1], negedge clk &&& endac, tsetup_clk_b);
        $setup(dacb[0], negedge clk &&& endac, tsetup_clk_b);

        $hold(negedge clk &&& endac,  dacb[9], thold_clk_b);
        $hold(negedge clk &&& endac,  dacb[8], thold_clk_b);
        $hold(negedge clk &&& endac,  dacb[7], thold_clk_b);
        $hold(negedge clk &&& endac,  dacb[6], thold_clk_b);
        $hold(negedge clk &&& endac,  dacb[5], thold_clk_b);
        $hold(negedge clk &&& endac,  dacb[4], thold_clk_b);
        $hold(negedge clk &&& endac,  dacb[3], thold_clk_b);
        $hold(negedge clk &&& endac,  dacb[2], thold_clk_b);
        $hold(negedge clk &&& endac,  dacb[1], thold_clk_b);
        $hold(negedge clk &&& endac,  dacb[0], thold_clk_b);
    endspecify
    //--
    //-- Specify -------------------------------------------------------

    //-- Behaviour -----------------------------------------------------
    //--
    //-- Converting input ports to it's real equivalent
    initial assign rl_iref = $bitstoreal(iref);

    // full scale current
    initial assign rl_ifs = IGAIN*rl_iref;

    // scaled current
    initial rl_frac_iout = 0.0;
    initial assign rl_iout_int = rl_frac_iout*rl_ifs;

    // input word latching and output update
    always @(negedge clk)
    begin
        if (endac)
        begin
            bin = dacb;
            rl_frac_iout <= @(posedge clk) $itor(bin)/{NBITS{1'b1}};
        end
    end

    // DAC power down
    always @(negedge endac)
    begin
        rl_frac_iout = 0.0;
        bin = 0;
    end

    // Output signal conversion
    assign ioutp_int = endac ? $realtobits(rl_iout_int*0.5) : $realtobits(0.0);
    assign ioutn_int = endac ? $realtobits(rl_ifs*0.5-rl_iout_int*0.5) : $realtobits(0.0);

    //-- Output buffers
    bufif1 #(TDELAY+TSETTLE, TDELAY+TSETTLE, 0) IP [63:0] (ioutp,ioutp_int,endac);
    bufif1 #(TDELAY+TSETTLE, TDELAY+TSETTLE, 0) IN [63:0] (ioutn,ioutn_int,endac);
    //--
    //-- Behaviour -----------------------------------------------------

endmodule // ci8718tl_10b200vdac_dac

//rtl_synthesis on
//ambit synthesis on
//ambit translate on
//synopsys translate_on
//surelint translate_on
