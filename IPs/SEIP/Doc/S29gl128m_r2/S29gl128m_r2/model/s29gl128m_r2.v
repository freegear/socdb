//////////////////////////////////////////////////////////////////////////////
//  File name : s29gl128m_r2.v
//////////////////////////////////////////////////////////////////////////////
//  Copyright (C) 2004-2006 Spansion, LLC.
//
//  MODIFICATION HISTORY :
//
//  version: | author:      |  date:    | changes made:
//    V1.0    M.Radmanovic   04 Jun 15    Initial
//    V1.1    D.Randjelovic  06 Feb 27    Implemented SPEEDSIM option
//                                        Fixed bug in status query
//                                        PATTERN_1 generation is moved
//                                        in process StateGen_1
//
//////////////////////////////////////////////////////////////////////////////
//  PART DESCRIPTION:
//
//  Library:        FLASH
//  Technology:     Flash Memory
//  Part:           S29GL128M_R2
//
//  Description:    128Mbit (x8/x16) Uniform Sector Flash Memory
//                  Lowest address sector protected
//
//////////////////////////////////////////////////////////////////////////////
//  Known Bugs:
//
//////////////////////////////////////////////////////////////////////////////

//////////////////////////////////////////////////////////////////////////////
// MODULE DECLARATION                                                       //
//////////////////////////////////////////////////////////////////////////////
`timescale 1 ns/1 ns

module s29gl128m_r2
(
    A22      ,
    A21      ,
    A20      ,
    A19      ,
    A18      ,
    A17      ,
    A16      ,
    A15      ,
    A14      ,
    A13      ,
    A12      ,
    A11      ,
    A10      ,
    A9       ,
    A8       ,
    A7       ,
    A6       ,
    A5       ,
    A4       ,
    A3       ,
    A2       ,
    A1       ,
    A0       ,

    DQ15     ,
    DQ14     ,
    DQ13     ,
    DQ12     ,
    DQ11     ,
    DQ10     ,
    DQ9      ,
    DQ8      ,
    DQ7      ,
    DQ6      ,
    DQ5      ,
    DQ4      ,
    DQ3      ,
    DQ2      ,
    DQ1      ,
    DQ0      ,

    CENeg    ,
    OENeg    ,
    WENeg    ,
    RESETNeg ,
    WPNeg    ,
    BYTENeg  ,
    RY

);

////////////////////////////////////////////////////////////////////////
// Port / Part Pin Declarations
////////////////////////////////////////////////////////////////////////
    input  A22  ;
    input  A21  ;
    input  A20  ;
    input  A19  ;
    input  A18  ;
    input  A17  ;
    input  A16  ;
    input  A15  ;
    input  A14  ;
    input  A13  ;
    input  A12  ;
    input  A11  ;
    input  A10  ;
    input  A9   ;
    input  A8   ;
    input  A7   ;
    input  A6   ;
    input  A5   ;
    input  A4   ;
    input  A3   ;
    input  A2   ;
    input  A1   ;
    input  A0   ;

    inout  DQ15  ;
    inout  DQ14  ;
    inout  DQ13  ;
    inout  DQ12  ;
    inout  DQ11  ;
    inout  DQ10  ;
    inout  DQ9   ;
    inout  DQ8   ;
    inout  DQ7   ;
    inout  DQ6   ;
    inout  DQ5   ;
    inout  DQ4   ;
    inout  DQ3   ;
    inout  DQ2   ;
    inout  DQ1   ;
    inout  DQ0   ;

    input  CENeg    ;
    input  OENeg    ;
    input  WENeg    ;
    input  RESETNeg ;
    input  WPNeg    ;
    input  BYTENeg  ;
    output RY       ;

// interconnect path delay signals
    wire  A22_ipd  ;
    wire  A21_ipd  ;
    wire  A20_ipd  ;
    wire  A19_ipd  ;
    wire  A18_ipd  ;
    wire  A17_ipd  ;
    wire  A16_ipd  ;
    wire  A15_ipd  ;
    wire  A14_ipd  ;
    wire  A13_ipd  ;
    wire  A12_ipd  ;
    wire  A11_ipd  ;
    wire  A10_ipd  ;
    wire  A9_ipd   ;
    wire  A8_ipd   ;
    wire  A7_ipd   ;
    wire  A6_ipd   ;
    wire  A5_ipd   ;
    wire  A4_ipd   ;
    wire  A3_ipd   ;
    wire  A2_ipd   ;
    wire  A1_ipd   ;
    wire  A0_ipd   ;

    wire [22 : 0] A;
    assign A = {A22_ipd,
                A21_ipd,
                A20_ipd,
                A19_ipd,
                A18_ipd,
                A17_ipd,
                A16_ipd,
                A15_ipd,
                A14_ipd,
                A13_ipd,
                A12_ipd,
                A11_ipd,
                A10_ipd,
                A9_ipd,
                A8_ipd,
                A7_ipd,
                A6_ipd,
                A5_ipd,
                A4_ipd,
                A3_ipd,
                A2_ipd,
                A1_ipd,
                A0_ipd };

    wire  DQ15_ipd  ;
    wire  DQ14_ipd  ;
    wire  DQ13_ipd  ;
    wire  DQ12_ipd  ;
    wire  DQ11_ipd  ;
    wire  DQ10_ipd  ;
    wire  DQ9_ipd   ;
    wire  DQ8_ipd   ;
    wire  DQ7_ipd   ;
    wire  DQ6_ipd   ;
    wire  DQ5_ipd   ;
    wire  DQ4_ipd   ;
    wire  DQ3_ipd   ;
    wire  DQ2_ipd   ;
    wire  DQ1_ipd   ;
    wire  DQ0_ipd   ;

    wire [15 : 0 ] DIn;
    assign DIn = {DQ15_ipd,
                  DQ14_ipd,
                  DQ13_ipd,
                  DQ12_ipd,
                  DQ11_ipd,
                  DQ10_ipd,
                  DQ9_ipd,
                  DQ8_ipd,
                  DQ7_ipd,
                  DQ6_ipd,
                  DQ5_ipd,
                  DQ4_ipd,
                  DQ3_ipd,
                  DQ2_ipd,
                  DQ1_ipd,
                  DQ0_ipd };

    wire [15 : 0 ] DOut;
    assign DOut = {DQ15,
                  DQ14,
                  DQ13,
                  DQ12,
                  DQ11,
                  DQ10,
                  DQ9,
                  DQ8,
                  DQ7,
                  DQ6,
                  DQ5,
                  DQ4,
                  DQ3,
                  DQ2,
                  DQ1,
                  DQ0 };

    wire  CENeg_ipd    ;
    wire  OENeg_ipd    ;
    wire  WENeg_ipd    ;
    wire  RESETNeg_ipd ;
    wire  WPNeg_ipd    ;
    wire  BYTENeg_ipd  ;

//  internal delays

    reg HANG_out    ; // Program/Erase Timing Limit
    reg HANG_in     ;
    reg START_T1    ; // Start TimeOut
    reg START_T1_in ;
    reg CTMOUT      ; // Sector Erase TimeOut
    reg CTMOUT_in   ;
    reg READY_in    ;
    reg READY       ; // Device ready after reset

    wire  DQ15_Pass  ;
    wire  DQ14_Pass  ;
    wire  DQ13_Pass  ;
    wire  DQ12_Pass  ;
    wire  DQ11_Pass  ;
    wire  DQ10_Pass  ;
    wire  DQ9_Pass   ;
    wire  DQ8_Pass   ;
    wire  DQ7_Pass   ;
    wire  DQ6_Pass   ;
    wire  DQ5_Pass   ;
    wire  DQ4_Pass   ;
    wire  DQ3_Pass   ;
    wire  DQ2_Pass   ;
    wire  DQ1_Pass   ;
    wire  DQ0_Pass   ;

    reg [15 : 0] DOut_zd;
    reg [15 : 0] DOut_Pass;
    assign {DQ15_Pass,
            DQ14_Pass,
            DQ13_Pass,
            DQ12_Pass,
            DQ11_Pass,
            DQ10_Pass,
            DQ9_Pass,
            DQ8_Pass,
            DQ7_Pass,
            DQ6_Pass,
            DQ5_Pass,
            DQ4_Pass,
            DQ3_Pass,
            DQ2_Pass,
            DQ1_Pass,
            DQ0_Pass  } = DOut_Pass;

    reg RY_zd;

    parameter UserPreload     = 1'b0;
    parameter mem_file_name   = "none";//"s29gl128m_r2.mem";
    parameter prot_file_name  = "none";//"s29gl128m_r2_prot.mem";
    parameter secsi_file_name = "none";//"s29gl128m_r2_secsi.mem";

    parameter TimingModel = "DefaultTimingModel";

    parameter PartID = "S29GL128M_R2";
    parameter MaxData = 255;
    parameter SecSize = 65535;
    parameter SecSiSize = 255;
    parameter SecNum = 255;
    parameter HiAddrBit = 22;

    // If speedsimulation is needed uncomment following line

    //`define SPEEDSIM;

    //Address of the Protected Sector
    integer  ProtSecNum = 0;

    // powerup
    reg PoweredUp;

    //FSM control signals
    reg ULBYPASS ; ////Unlock Bypass Active
    reg OTP_ACT  ; ////SecSi access
    reg PSP_ACT  ; ////Program Suspend
    reg ESP_ACT  ; ////Erase Suspend
    integer LCNT ; ////Load Counter  0-31

    ////number of location to be writen in Write Buffer: 0-31 bytes.
    ////if 32 word/byte programming
    integer PCNT  ;  //0-32

    reg PDONE    ; ////Prog. Done
    reg PSTART   ; ////Start Programming
    reg PSUSP    ; ////Suspend programming
    reg PRES     ; ////Resume Programming
    //Program location is in protected sector
    reg PERR     ;

    reg EDONE    ; ////Ers. Done
    reg ESTART   ; ////Start Erase
    reg ESUSP    ; ////Suspend Erase
    reg ERES     ; ////Resume Erase
    //All sectors selected for erasure are protected
    reg EERR     ;
    //Sectors selected for erasure
    reg [SecNum:0] Ers_queue;

    //Command Register
    reg write ;
    reg read  ;

    //Sector Address
    integer SecAddr = 0;         // 0 - SecNum

    integer SA      = 0;         // 0 TO SecNum
    integer WBPage  = 0;
    //Address within sector
    integer Address = 0;         // 0 - SecSize

    integer D_tmp0; //0 TO MaxData;
    integer D_tmp1; //0 TO MaxData;

    //A22:A11 Don't Care
    integer Addr ;         //0 TO 16'h7FF#

    integer WPage;         //0 TO 16'h7FF#
    integer RPage;         //0 TO 16'h2000#
    reg RPchange ;

    //glitch protection
    wire gWE_n ;
    wire gCE_n ;
    wire gOE_n ;

    reg RST ;
    reg reseted ;
    //Sector Protection Status
    reg [SecNum:0] Sec_Prot;
    //SecSi ProtectionStatus
    reg FactoryProt;

    // timing check violation
    reg Viol = 1'b0;

    integer Mem[0:((SecNum+1)*(SecSize+1) -1) ];
    integer CFI_array[16:90];
    integer SecSi[0:SecSiSize];

    integer WBData[0:31];
    integer WBAddr[0:31];

    integer BaseLoc = 0;

    integer cnt = 0;

    reg Sec_Prot_reg  = 1'b0;

    //Status reg.
    reg[7:0] Status = 8'b0;

    reg[7:0]  old_bit, new_bit;
    integer old_int, new_int;
    integer wr_cnt;

    reg[7:0] temp;

    reg oe = 1'b0;
    event oe_event;

    //TPD_XX_DATA
    time OEDQ_t;
    time CEDQ_t;
    time ADDRDQ_t;
    time OENeg_event;
    time CENeg_event;
    time ADDR_event;
    reg FROMOE;
    reg FROMCE;
    reg FROMBYTE;
    reg FROMADDR;
    integer   OEDQ_01;
    integer   CEDQ_01;
    integer   ADDRDQ_01_SHORT;
    integer   ADDRDQ_01_LONG;
    reg[15:0] TempData;

///////////////////////////////////////////////////////////////////////////////
//Interconnect Path Delay Section
///////////////////////////////////////////////////////////////////////////////

    buf   (A22_ipd, A22);
    buf   (A21_ipd, A21);
    buf   (A20_ipd, A20);
    buf   (A19_ipd, A19);
    buf   (A18_ipd, A18);
    buf   (A17_ipd, A17);
    buf   (A16_ipd, A16);
    buf   (A15_ipd, A15);
    buf   (A14_ipd, A14);
    buf   (A13_ipd, A13);
    buf   (A12_ipd, A12);
    buf   (A11_ipd, A11);
    buf   (A10_ipd, A10);
    buf   (A9_ipd , A9 );
    buf   (A8_ipd , A8 );
    buf   (A7_ipd , A7 );
    buf   (A6_ipd , A6 );
    buf   (A5_ipd , A5 );
    buf   (A4_ipd , A4 );
    buf   (A3_ipd , A3 );
    buf   (A2_ipd , A2 );
    buf   (A1_ipd , A1 );
    buf   (A0_ipd , A0 );

    buf   (DQ15_ipd, DQ15);
    buf   (DQ14_ipd, DQ14);
    buf   (DQ13_ipd, DQ13);
    buf   (DQ12_ipd, DQ12);
    buf   (DQ11_ipd, DQ11);
    buf   (DQ10_ipd, DQ10);
    buf   (DQ9_ipd , DQ9 );
    buf   (DQ8_ipd , DQ8 );
    buf   (DQ7_ipd , DQ7 );
    buf   (DQ6_ipd , DQ6 );
    buf   (DQ5_ipd , DQ5 );
    buf   (DQ4_ipd , DQ4 );
    buf   (DQ3_ipd , DQ3 );
    buf   (DQ2_ipd , DQ2 );
    buf   (DQ1_ipd , DQ1 );
    buf   (DQ0_ipd , DQ0 );

    buf   (CENeg_ipd    , CENeg    );
    buf   (OENeg_ipd    , OENeg    );
    buf   (WENeg_ipd    , WENeg    );
    buf   (RESETNeg_ipd , RESETNeg );
    buf   (WPNeg_ipd    , WPNeg    );
    buf   (BYTENeg_ipd  , BYTENeg  );

///////////////////////////////////////////////////////////////////////////////
// Propagation  delay Section
///////////////////////////////////////////////////////////////////////////////
    nmos   (DQ15,   DQ15_Pass , 1);
    nmos   (DQ14,   DQ14_Pass , 1);
    nmos   (DQ13,   DQ13_Pass , 1);
    nmos   (DQ12,   DQ12_Pass , 1);
    nmos   (DQ11,   DQ11_Pass , 1);
    nmos   (DQ10,   DQ10_Pass , 1);
    nmos   (DQ9 ,   DQ9_Pass  , 1);
    nmos   (DQ8 ,   DQ8_Pass  , 1);
    nmos   (DQ7 ,   DQ7_Pass  , 1);
    nmos   (DQ6 ,   DQ6_Pass  , 1);
    nmos   (DQ5 ,   DQ5_Pass  , 1);
    nmos   (DQ4 ,   DQ4_Pass  , 1);
    nmos   (DQ3 ,   DQ3_Pass  , 1);
    nmos   (DQ2 ,   DQ2_Pass  , 1);
    nmos   (DQ1 ,   DQ1_Pass  , 1);
    nmos   (DQ0 ,   DQ0_Pass  , 1);
    nmos   (RY ,   1'b0      ,  ~RY_zd);

    wire deg;

    specify

        // tipd delays: interconnect path delays , mapped to input port delays.
        // In Verilog is not necessary to declare any tipd_ delay variables,
        // they can be taken from SDF file
        // With all the other delays real delays would be taken from SDF file

        // tpd delays
    specparam           tpd_A0_DQ0              =1;
    specparam           tpd_A0_DQ1              =1;   //tPACC
    specparam           tpd_CENeg_DQ0           =1;
        //(tCE,tCE,tDF,-,tDF,-)
    specparam           tpd_OENeg_DQ0           =1;
        //(tOE,tOE,tDF,-,tDF,-)
    specparam           tpd_RESETNeg_DQ0        =1;
        //(-,-,0,-,0,-)
    specparam           tpd_CENeg_RY            =1;    //tBUSY
    specparam           tpd_WENeg_RY            =1;    //tBUSY

        // tsetup values: setup time
    specparam           tsetup_A0_CENeg         =1;   //tAS edge \
    specparam           tsetup_A0_OENeg         =1;   //tASO edge \
    specparam           tsetup_DQ0_CENeg        =1;   //tDS edge /

        // thold values: hold times
    specparam           thold_CENeg_RESETNeg    =1; //tRH  edge /
    specparam           thold_OENeg_WENeg       =1; //tOEH edge /
    specparam           thold_A0_CENeg          =1; //tAH  edge \
    specparam           thold_A0_OENeg          =1; //tAHT edge \
    specparam           thold_DQ0_CENeg         =1; //tDH edge /
    specparam           thold_WENeg_OENeg       =1; //tGHVL edge /

        // tpw values: pulse width
    specparam           tpw_RESETNeg_negedge    =1; //tRP
    specparam           tpw_OENeg_posedge       =1; //tOEPH
    specparam           tpw_WENeg_negedge       =1; //tWP
    specparam           tpw_WENeg_posedge       =1; //tWPH
    specparam           tpw_CENeg_negedge       =1; //tCP
    specparam           tpw_CENeg_posedge       =1; //tCEPH
    specparam           tpw_A0_negedge          =1; //tWC tRC

        // tdevice values: values for internal delays
    `ifdef SPEEDSIM
            //Effective Write Buffer Program Operation  tWHWH1
         specparam   tdevice_WBPB                    = 1500; //ns;
            //Program Operation
         specparam   tdevice_POB                     = 3000; //3 us per byte;
            //Sector Erase Operation    tWHWH2
         specparam   tdevice_SEO                     = 500000;
            //Timing Limit Exceeded
         specparam   tdevice_HANG                    = 400000000;
            //program/erase suspend timeout
         specparam   tdevice_START_T1                = 5000; //5 us;
            //sector erase command sequence timeout
         specparam   tdevice_CTMOUT                  = 10000; //10 us;
            //device ready after Hardware reset(during embeded algorithm)
         specparam   tdevice_READY                   = 2000;
    `else
            //Effective Write Buffer Program Operation  tWHWH1
         specparam   tdevice_WBPB                    = 7500; //ns;
            //Program Operation
         specparam   tdevice_POB                     = 30000; //30 us per byte;
            //Sector Erase Operation    tWHWH2
         specparam   tdevice_SEO                     = 500000000;
            //Timing Limit Exceeded
         specparam   tdevice_HANG                    = 400000000;
            //program/erase suspend timeout
         specparam   tdevice_START_T1                = 5000; //5 us;
            //sector erase command sequence timeout
         specparam   tdevice_CTMOUT                  = 50000; //50 us;
            //device ready after Hardware reset(during embeded algorithm)
         specparam   tdevice_READY                   = 20000;
    `endif //SPEEDSIM

///////////////////////////////////////////////////////////////////////////////
// Input Port  Delays  don't require Verilog description
///////////////////////////////////////////////////////////////////////////////
// Path delays                                                               //
///////////////////////////////////////////////////////////////////////////////
    (CENeg => RY) = tpd_CENeg_RY;
    (WENeg => RY) = tpd_WENeg_RY;

    if (FROMCE) (CENeg *> DQ0) = tpd_CENeg_DQ0;
    if (FROMCE) (CENeg *> DQ1) = tpd_CENeg_DQ0;
    if (FROMCE) (CENeg *> DQ2) = tpd_CENeg_DQ0;
    if (FROMCE) (CENeg *> DQ3) = tpd_CENeg_DQ0;
    if (FROMCE) (CENeg *> DQ4) = tpd_CENeg_DQ0;
    if (FROMCE) (CENeg *> DQ5) = tpd_CENeg_DQ0;
    if (FROMCE) (CENeg *> DQ6) = tpd_CENeg_DQ0;
    if (FROMCE) (CENeg *> DQ7) = tpd_CENeg_DQ0;
    if (FROMCE) (CENeg *> DQ8) = tpd_CENeg_DQ0;
    if (FROMCE) (CENeg *> DQ9) = tpd_CENeg_DQ0;
    if (FROMCE) (CENeg *> DQ10) = tpd_CENeg_DQ0;
    if (FROMCE) (CENeg *> DQ11) = tpd_CENeg_DQ0;
    if (FROMCE) (CENeg *> DQ12) = tpd_CENeg_DQ0;
    if (FROMCE) (CENeg *> DQ13) = tpd_CENeg_DQ0;
    if (FROMCE) (CENeg *> DQ14) = tpd_CENeg_DQ0;
    if (FROMCE) (CENeg *> DQ15) = tpd_CENeg_DQ0;
    if (FROMOE) (OENeg *> DQ0) = tpd_OENeg_DQ0;
    if (FROMOE) (OENeg *> DQ1) = tpd_OENeg_DQ0;
    if (FROMOE) (OENeg *> DQ2) = tpd_OENeg_DQ0;
    if (FROMOE) (OENeg *> DQ3) = tpd_OENeg_DQ0;
    if (FROMOE) (OENeg *> DQ4) = tpd_OENeg_DQ0;
    if (FROMOE) (OENeg *> DQ5) = tpd_OENeg_DQ0;
    if (FROMOE) (OENeg *> DQ6) = tpd_OENeg_DQ0;
    if (FROMOE) (OENeg *> DQ7) = tpd_OENeg_DQ0;
    if (FROMOE) (OENeg *> DQ8) = tpd_OENeg_DQ0;
    if (FROMOE) (OENeg *> DQ9) = tpd_OENeg_DQ0;
    if (FROMOE) (OENeg *> DQ10) = tpd_OENeg_DQ0;
    if (FROMOE) (OENeg *> DQ11) = tpd_OENeg_DQ0;
    if (FROMOE) (OENeg *> DQ12) = tpd_OENeg_DQ0;
    if (FROMOE) (OENeg *> DQ13) = tpd_OENeg_DQ0;
    if (FROMOE) (OENeg *> DQ14) = tpd_OENeg_DQ0;
    if (FROMOE) (OENeg *> DQ15) = tpd_OENeg_DQ0;
    if (~RESETNeg) (RESETNeg *> DQ0) = tpd_RESETNeg_DQ0;
    if (~RESETNeg) (RESETNeg *> DQ1) = tpd_RESETNeg_DQ0;
    if (~RESETNeg) (RESETNeg *> DQ2) = tpd_RESETNeg_DQ0;
    if (~RESETNeg) (RESETNeg *> DQ3) = tpd_RESETNeg_DQ0;
    if (~RESETNeg) (RESETNeg *> DQ4) = tpd_RESETNeg_DQ0;
    if (~RESETNeg) (RESETNeg *> DQ5) = tpd_RESETNeg_DQ0;
    if (~RESETNeg) (RESETNeg *> DQ6) = tpd_RESETNeg_DQ0;
    if (~RESETNeg) (RESETNeg *> DQ7) = tpd_RESETNeg_DQ0;
    if (~RESETNeg) (RESETNeg *> DQ8) = tpd_RESETNeg_DQ0;
    if (~RESETNeg) (RESETNeg *> DQ9) = tpd_RESETNeg_DQ0;
    if (~RESETNeg) (RESETNeg *> DQ10) = tpd_RESETNeg_DQ0;
    if (~RESETNeg) (RESETNeg *> DQ11) = tpd_RESETNeg_DQ0;
    if (~RESETNeg) (RESETNeg *> DQ12) = tpd_RESETNeg_DQ0;
    if (~RESETNeg) (RESETNeg *> DQ13) = tpd_RESETNeg_DQ0;
    if (~RESETNeg) (RESETNeg *> DQ14) = tpd_RESETNeg_DQ0;
    if (~RESETNeg) (RESETNeg *> DQ15) = tpd_RESETNeg_DQ0;
    if (~BYTENeg && ~RPchange && FROMADDR) (DQ15 *> DQ0) = tpd_A0_DQ1;
    if (~BYTENeg && ~RPchange && FROMADDR) (DQ15 *> DQ1) = tpd_A0_DQ1;
    if (~BYTENeg && ~RPchange && FROMADDR) (DQ15 *> DQ2) = tpd_A0_DQ1;
    if (~BYTENeg && ~RPchange && FROMADDR) (DQ15 *> DQ3) = tpd_A0_DQ1;
    if (~BYTENeg && ~RPchange && FROMADDR) (DQ15 *> DQ4) = tpd_A0_DQ1;
    if (~BYTENeg && ~RPchange && FROMADDR) (DQ15 *> DQ5) = tpd_A0_DQ1;
    if (~BYTENeg && ~RPchange && FROMADDR) (DQ15 *> DQ6) = tpd_A0_DQ1;
    if (~BYTENeg && ~RPchange && FROMADDR) (DQ15 *> DQ7) = tpd_A0_DQ1;
    if (~BYTENeg && ~RPchange && FROMADDR) (DQ15 *> DQ8) = tpd_A0_DQ1;
    if (~BYTENeg && ~RPchange && FROMADDR) (DQ15 *> DQ9) = tpd_A0_DQ1;
    if (~BYTENeg && ~RPchange && FROMADDR) (DQ15 *> DQ10) = tpd_A0_DQ1;
    if (~BYTENeg && ~RPchange && FROMADDR) (DQ15 *> DQ11) = tpd_A0_DQ1;
    if (~BYTENeg && ~RPchange && FROMADDR) (DQ15 *> DQ12) = tpd_A0_DQ1;
    if (~BYTENeg && ~RPchange && FROMADDR) (DQ15 *> DQ13) = tpd_A0_DQ1;
    if (~BYTENeg && ~RPchange && FROMADDR) (DQ15 *> DQ14) = tpd_A0_DQ1;
    if (~BYTENeg && ~RPchange && FROMADDR) (DQ15 *> DQ15) = tpd_A0_DQ1;
    if (RPchange && FROMADDR) (A0 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A0 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A0 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A0 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A0 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A0 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A0 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A0 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A0 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A0 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A0 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A0 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A0 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A0 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A0 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A0 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A1 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A1 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A1 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A1 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A1 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A1 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A1 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A1 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A1 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A1 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A1 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A1 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A1 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A1 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A1 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A1 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A2 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A2 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A2 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A2 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A2 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A2 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A2 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A2 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A2 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A2 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A2 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A2 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A2 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A2 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A2 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A2 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A3 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A3 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A3 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A3 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A3 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A3 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A3 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A3 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A3 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A3 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A3 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A3 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A3 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A3 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A3 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A3 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A4 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A4 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A4 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A4 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A4 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A4 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A4 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A4 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A4 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A4 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A4 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A4 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A4 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A4 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A4 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A4 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A5 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A5 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A5 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A5 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A5 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A5 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A5 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A5 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A5 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A5 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A5 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A5 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A5 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A5 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A5 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A5 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A6 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A6 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A6 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A6 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A6 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A6 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A6 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A6 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A6 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A6 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A6 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A6 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A6 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A6 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A6 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A6 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A7 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A7 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A7 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A7 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A7 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A7 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A7 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A7 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A7 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A7 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A7 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A7 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A7 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A7 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A7 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A7 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A8 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A8 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A8 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A8 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A8 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A8 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A8 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A8 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A8 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A8 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A8 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A8 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A8 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A8 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A8 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A8 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A9 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A9 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A9 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A9 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A9 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A9 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A9 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A9 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A9 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A9 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A9 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A9 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A9 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A9 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A9 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A9 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A10 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A10 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A10 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A10 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A10 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A10 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A10 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A10 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A10 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A10 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A10 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A10 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A10 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A10 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A10 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A10 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A11 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A11 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A11 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A11 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A11 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A11 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A11 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A11 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A11 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A11 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A11 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A11 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A11 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A11 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A11 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A11 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A12 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A12 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A12 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A12 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A12 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A12 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A12 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A12 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A12 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A12 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A12 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A12 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A12 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A12 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A12 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A12 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A13 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A13 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A13 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A13 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A13 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A13 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A13 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A13 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A13 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A13 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A13 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A13 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A13 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A13 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A13 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A13 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A14 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A14 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A14 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A14 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A14 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A14 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A14 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A14 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A14 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A14 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A14 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A14 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A14 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A14 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A14 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A14 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A15 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A15 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A15 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A15 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A15 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A15 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A15 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A15 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A15 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A15 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A15 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A15 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A15 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A15 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A15 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A15 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A16 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A16 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A16 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A16 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A16 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A16 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A16 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A16 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A16 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A16 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A16 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A16 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A16 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A16 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A16 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A16 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A17 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A17 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A17 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A17 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A17 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A17 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A17 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A17 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A17 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A17 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A17 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A17 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A17 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A17 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A17 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A17 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A18 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A18 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A18 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A18 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A18 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A18 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A18 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A18 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A18 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A18 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A18 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A18 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A18 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A18 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A18 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A18 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A19 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A19 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A19 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A19 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A19 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A19 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A19 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A19 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A19 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A19 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A19 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A19 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A19 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A19 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A19 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A19 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A20 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A20 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A20 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A20 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A20 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A20 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A20 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A20 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A20 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A20 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A20 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A20 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A20 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A20 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A20 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A20 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A21 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A21 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A21 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A21 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A21 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A21 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A21 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A21 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A21 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A21 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A21 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A21 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A21 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A21 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A21 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A21 *> DQ15) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A22 *> DQ0) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A22 *> DQ1) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A22 *> DQ2) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A22 *> DQ3) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A22 *> DQ4) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A22 *> DQ5) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A22 *> DQ6) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A22 *> DQ7) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A22 *> DQ8) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A22 *> DQ9) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A22 *> DQ10) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A22 *> DQ11) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A22 *> DQ12) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A22 *> DQ13) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A22 *> DQ14) = tpd_A0_DQ0;
    if (RPchange && FROMADDR) (A22 *> DQ15) = tpd_A0_DQ0;
    if (~RPchange && FROMADDR) (A0 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A0 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A0 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A0 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A0 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A0 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A0 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A0 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A0 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A0 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A0 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A0 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A0 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A0 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A0 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A0 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A1 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A1 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A1 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A1 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A1 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A1 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A1 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A1 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A1 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A1 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A1 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A1 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A1 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A1 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A1 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A1 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A2 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A2 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A2 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A2 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A2 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A2 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A2 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A2 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A2 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A2 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A2 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A2 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A2 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A2 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A2 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A2 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A3 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A3 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A3 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A3 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A3 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A3 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A3 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A3 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A3 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A3 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A3 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A3 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A3 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A3 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A3 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A3 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A4 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A4 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A4 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A4 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A4 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A4 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A4 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A4 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A4 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A4 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A4 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A4 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A4 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A4 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A4 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A4 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A5 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A5 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A5 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A5 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A5 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A5 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A5 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A5 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A5 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A5 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A5 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A5 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A5 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A5 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A5 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A5 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A6 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A6 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A6 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A6 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A6 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A6 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A6 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A6 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A6 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A6 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A6 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A6 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A6 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A6 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A6 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A6 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A7 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A7 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A7 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A7 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A7 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A7 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A7 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A7 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A7 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A7 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A7 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A7 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A7 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A7 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A7 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A7 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A8 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A8 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A8 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A8 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A8 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A8 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A8 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A8 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A8 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A8 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A8 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A8 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A8 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A8 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A8 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A8 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A9 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A9 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A9 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A9 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A9 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A9 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A9 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A9 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A9 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A9 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A9 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A9 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A9 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A9 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A9 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A9 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A10 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A10 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A10 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A10 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A10 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A10 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A10 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A10 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A10 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A10 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A10 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A10 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A10 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A10 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A10 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A10 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A11 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A11 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A11 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A11 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A11 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A11 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A11 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A11 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A11 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A11 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A11 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A11 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A11 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A11 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A11 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A11 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A12 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A12 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A12 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A12 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A12 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A12 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A12 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A12 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A12 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A12 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A12 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A12 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A12 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A12 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A12 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A12 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A13 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A13 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A13 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A13 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A13 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A13 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A13 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A13 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A13 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A13 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A13 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A13 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A13 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A13 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A13 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A13 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A14 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A14 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A14 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A14 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A14 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A14 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A14 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A14 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A14 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A14 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A14 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A14 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A14 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A14 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A14 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A14 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A15 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A15 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A15 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A15 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A15 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A15 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A15 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A15 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A15 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A15 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A15 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A15 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A15 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A15 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A15 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A15 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A16 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A16 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A16 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A16 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A16 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A16 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A16 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A16 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A16 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A16 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A16 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A16 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A16 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A16 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A16 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A16 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A17 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A17 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A17 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A17 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A17 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A17 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A17 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A17 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A17 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A17 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A17 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A17 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A17 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A17 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A17 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A17 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A18 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A18 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A18 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A18 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A18 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A18 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A18 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A18 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A18 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A18 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A18 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A18 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A18 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A18 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A18 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A18 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A19 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A19 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A19 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A19 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A19 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A19 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A19 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A19 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A19 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A19 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A19 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A19 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A19 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A19 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A19 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A19 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A20 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A20 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A20 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A20 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A20 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A20 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A20 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A20 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A20 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A20 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A20 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A20 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A20 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A20 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A20 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A20 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A21 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A21 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A21 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A21 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A21 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A21 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A21 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A21 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A21 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A21 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A21 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A21 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A21 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A21 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A21 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A21 *> DQ15) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A22 *> DQ0) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A22 *> DQ1) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A22 *> DQ2) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A22 *> DQ3) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A22 *> DQ4) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A22 *> DQ5) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A22 *> DQ6) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A22 *> DQ7) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A22 *> DQ8) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A22 *> DQ9) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A22 *> DQ10) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A22 *> DQ11) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A22 *> DQ12) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A22 *> DQ13) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A22 *> DQ14) = tpd_A0_DQ1;
    if (~RPchange && FROMADDR) (A22 *> DQ15) = tpd_A0_DQ1;

////////////////////////////////////////////////////////////////////////////////
// Timing Violation                                                           //
////////////////////////////////////////////////////////////////////////////////
    $setup ( A0 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A1 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A2 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A3 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A4 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A5 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A6 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A7 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A8 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A9 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A10 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A11 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A12 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A13 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A14 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A15 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A16 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A17 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A18 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A19 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A20 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A21 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A22 , negedge CENeg, tsetup_A0_CENeg, Viol);
    $setup ( A0 , negedge WENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A1 , negedge WENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A2 , negedge WENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A3 , negedge WENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A4 , negedge WENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A5 , negedge WENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A6 , negedge WENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A7 , negedge WENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A8 , negedge WENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A9 , negedge WENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A10 , negedge WENeg, tsetup_A0_CENeg, Viol);
    $setup ( A11 , negedge WENeg, tsetup_A0_CENeg, Viol);
    $setup ( A12 , negedge WENeg, tsetup_A0_CENeg, Viol);
    $setup ( A13 , negedge WENeg, tsetup_A0_CENeg, Viol);
    $setup ( A14 , negedge WENeg, tsetup_A0_CENeg, Viol);
    $setup ( A15 , negedge WENeg, tsetup_A0_CENeg, Viol);
    $setup ( A16 , negedge WENeg, tsetup_A0_CENeg, Viol);
    $setup ( A17 , negedge WENeg, tsetup_A0_CENeg, Viol);
    $setup ( A18 , negedge WENeg, tsetup_A0_CENeg, Viol);
    $setup ( A19 , negedge WENeg, tsetup_A0_CENeg, Viol);
    $setup ( A20 , negedge WENeg, tsetup_A0_CENeg, Viol);
    $setup ( A21 , negedge WENeg, tsetup_A0_CENeg, Viol);
    $setup ( A22 , negedge WENeg, tsetup_A0_CENeg, Viol);
    $setup ( A0 , negedge OENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A1 , negedge OENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A2 , negedge OENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A3 , negedge OENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A4 , negedge OENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A5 , negedge OENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A6 , negedge OENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A7 , negedge OENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A8 , negedge OENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A9 , negedge OENeg,  tsetup_A0_CENeg, Viol);
    $setup ( A10 , negedge OENeg, tsetup_A0_CENeg, Viol);
    $setup ( A11 , negedge OENeg, tsetup_A0_CENeg, Viol);
    $setup ( A12 , negedge OENeg, tsetup_A0_CENeg, Viol);
    $setup ( A13 , negedge OENeg, tsetup_A0_CENeg, Viol);
    $setup ( A14 , negedge OENeg, tsetup_A0_CENeg, Viol);
    $setup ( A15 , negedge OENeg, tsetup_A0_CENeg, Viol);
    $setup ( A16 , negedge OENeg, tsetup_A0_CENeg, Viol);
    $setup ( A17 , negedge OENeg, tsetup_A0_CENeg, Viol);
    $setup ( A18 , negedge OENeg, tsetup_A0_CENeg, Viol);
    $setup ( A19 , negedge OENeg, tsetup_A0_CENeg, Viol);
    $setup ( A20 , negedge OENeg, tsetup_A0_CENeg, Viol);
    $setup ( A21 , negedge OENeg, tsetup_A0_CENeg, Viol);
    $setup ( A22 , negedge OENeg, tsetup_A0_CENeg, Viol);

    $setup ( DQ0 , posedge CENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ1 , posedge CENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ2 , posedge CENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ3 , posedge CENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ4 , posedge CENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ5 , posedge CENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ6 , posedge CENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ7 , posedge CENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ8 , posedge CENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ9 , posedge CENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ10 , posedge CENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ11 , posedge CENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ12 , posedge CENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ13 , posedge CENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ14 , posedge CENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ15 , posedge CENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ0 , posedge WENeg &&& deg,  tsetup_DQ0_CENeg, Viol);
    $setup ( DQ1 , posedge WENeg &&& deg,  tsetup_DQ0_CENeg, Viol);
    $setup ( DQ2 , posedge WENeg &&& deg,  tsetup_DQ0_CENeg, Viol);
    $setup ( DQ3 , posedge WENeg &&& deg,  tsetup_DQ0_CENeg, Viol);
    $setup ( DQ4 , posedge WENeg &&& deg,  tsetup_DQ0_CENeg, Viol);
    $setup ( DQ5 , posedge WENeg &&& deg,  tsetup_DQ0_CENeg, Viol);
    $setup ( DQ6 , posedge WENeg &&& deg,  tsetup_DQ0_CENeg, Viol);
    $setup ( DQ7 , posedge WENeg &&& deg,  tsetup_DQ0_CENeg, Viol);
    $setup ( DQ8 , posedge WENeg &&& deg,  tsetup_DQ0_CENeg, Viol);
    $setup ( DQ9 , posedge WENeg &&& deg,  tsetup_DQ0_CENeg, Viol);
    $setup ( DQ10 , posedge WENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ11 , posedge WENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ12 , posedge WENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ13 , posedge WENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ14 , posedge WENeg &&& deg, tsetup_DQ0_CENeg, Viol);
    $setup ( DQ15 , posedge WENeg &&& deg, tsetup_DQ0_CENeg, Viol);

    $hold ( posedge RESETNeg &&& (CENeg===1), CENeg ,
                                         thold_CENeg_RESETNeg, Viol);
    $hold ( posedge RESETNeg &&& (OENeg===1), OENeg ,
                                         thold_CENeg_RESETNeg, Viol);

    $hold ( negedge CENeg, A0 ,  thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A1 ,  thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A2 ,  thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A3 ,  thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A4 ,  thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A5 ,  thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A6 ,  thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A7 ,  thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A8 ,  thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A9 ,  thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A10 , thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A11 , thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A12 , thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A13 , thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A14 , thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A15 , thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A16 , thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A17 , thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A18 , thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A19 , thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A20 , thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A21 , thold_A0_CENeg, Viol);
    $hold ( negedge CENeg, A22 , thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A0 ,  thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A1 ,  thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A2 ,  thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A3 ,  thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A4 ,  thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A5 ,  thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A6 ,  thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A7 ,  thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A8 ,  thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A9 ,  thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A10 , thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A11 , thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A12 , thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A13 , thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A14 , thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A15 , thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A16 , thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A17 , thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A18 , thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A19 , thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A20 , thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A21 , thold_A0_CENeg, Viol);
    $hold ( negedge WENeg, A22 , thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A0 ,  thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A1 ,  thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A2 ,  thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A3 ,  thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A4 ,  thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A5 ,  thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A6 ,  thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A7 ,  thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A8 ,  thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A9 ,  thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A10 , thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A11 , thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A12 , thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A13 , thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A14 , thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A15 , thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A16 , thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A17 , thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A18 , thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A19 , thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A20 , thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A21 , thold_A0_CENeg, Viol);
    $hold ( negedge OENeg, A22 , thold_A0_CENeg, Viol);

    $hold ( negedge CENeg, DQ0 ,  thold_DQ0_CENeg, Viol);
    $hold ( negedge CENeg, DQ1 ,  thold_DQ0_CENeg, Viol);
    $hold ( negedge CENeg, DQ2 ,  thold_DQ0_CENeg, Viol);
    $hold ( negedge CENeg, DQ3 ,  thold_DQ0_CENeg, Viol);
    $hold ( negedge CENeg, DQ4 ,  thold_DQ0_CENeg, Viol);
    $hold ( negedge CENeg, DQ5 ,  thold_DQ0_CENeg, Viol);
    $hold ( negedge CENeg, DQ6 ,  thold_DQ0_CENeg, Viol);
    $hold ( negedge CENeg, DQ7 ,  thold_DQ0_CENeg, Viol);
    $hold ( negedge CENeg, DQ8 ,  thold_DQ0_CENeg, Viol);
    $hold ( negedge CENeg, DQ9 ,  thold_DQ0_CENeg, Viol);
    $hold ( negedge CENeg, DQ10 , thold_DQ0_CENeg, Viol);
    $hold ( negedge CENeg, DQ11 , thold_DQ0_CENeg, Viol);
    $hold ( negedge CENeg, DQ12 , thold_DQ0_CENeg, Viol);
    $hold ( negedge CENeg, DQ13 , thold_DQ0_CENeg, Viol);
    $hold ( negedge CENeg, DQ14 , thold_DQ0_CENeg, Viol);
    $hold ( negedge CENeg, DQ15 , thold_DQ0_CENeg, Viol);
    $hold ( negedge WENeg, DQ0  , thold_DQ0_CENeg, Viol);
    $hold ( negedge WENeg, DQ1  , thold_DQ0_CENeg, Viol);
    $hold ( negedge WENeg, DQ2  , thold_DQ0_CENeg, Viol);
    $hold ( negedge WENeg, DQ3  , thold_DQ0_CENeg, Viol);
    $hold ( negedge WENeg, DQ4  , thold_DQ0_CENeg, Viol);
    $hold ( negedge WENeg, DQ5  , thold_DQ0_CENeg, Viol);
    $hold ( negedge WENeg, DQ6  , thold_DQ0_CENeg, Viol);
    $hold ( negedge WENeg, DQ7  , thold_DQ0_CENeg, Viol);
    $hold ( negedge WENeg, DQ8  , thold_DQ0_CENeg, Viol);
    $hold ( negedge WENeg, DQ9  , thold_DQ0_CENeg, Viol);
    $hold ( negedge WENeg, DQ10 , thold_DQ0_CENeg, Viol);
    $hold ( negedge WENeg, DQ11 , thold_DQ0_CENeg, Viol);
    $hold ( negedge WENeg, DQ12 , thold_DQ0_CENeg, Viol);
    $hold ( negedge WENeg, DQ13 , thold_DQ0_CENeg, Viol);
    $hold ( negedge WENeg, DQ14 , thold_DQ0_CENeg, Viol);
    $hold ( negedge WENeg, DQ15 , thold_DQ0_CENeg, Viol);

    $hold ( posedge WENeg, OENeg , thold_OENeg_WENeg, Viol);
    $hold ( posedge OENeg, WENeg , thold_WENeg_OENeg, Viol);

    $width (negedge RESETNeg, tpw_RESETNeg_negedge);

    $width (posedge OENeg, tpw_OENeg_posedge);
    $width (posedge WENeg, tpw_WENeg_posedge);
    $width (negedge WENeg, tpw_WENeg_negedge);
    $width (posedge CENeg, tpw_CENeg_posedge);
    $width (negedge CENeg, tpw_CENeg_negedge);

    $width (posedge A0, tpw_A0_negedge);
    $width (negedge A0, tpw_A0_negedge);

    endspecify

////////////////////////////////////////////////////////////////////////////////
// Main Behavior Block                                                        //
////////////////////////////////////////////////////////////////////////////////

// FSM states
    parameter RESET           =6'd0;
    parameter Z001            =6'd1;
    parameter PREL_SETBWB     =6'd2;
    parameter PREL_ULBYPASS   =6'd3;
    parameter CFI_U           =6'd4;
    parameter CFI             =6'd5;
    parameter AS              =6'd6;
    parameter A0SEEN          =6'd7;
    parameter OTP             =6'd8;
    parameter OTP_Z001        =6'd9;
    parameter OTP_PREL        =6'd10;
    parameter OTP_AS          =6'd11;
    parameter OTP_A0SEEN      =6'd12;
    parameter C8              =6'd13;
    parameter C8_Z001         =6'd14;
    parameter C8_PREL         =6'd15;
    parameter ERS             =6'd16;
    parameter SERS            =6'd17;
    parameter ESPS            =6'd18;
    parameter WBPGMS_WBCNT    =6'd19;
    parameter WBPGMS_WBLSTA   =6'd20;
    parameter WBPGMS_WBLOAD   =6'd21;
    parameter WBPGMS_CONFB    =6'd22;
    parameter WBPGMS_WBABORT  =6'd23;
    parameter WBPGMS_Z001     =6'd24;
    parameter WBPGMS_PREL     =6'd25;
    parameter SERS_EXEC       =6'd26;
    parameter ESP             =6'd27;
    parameter ESP_Z001        =6'd28;
    parameter ESP_PREL        =6'd29;
    parameter ESP_CFI_U       =6'd30;
    parameter ESP_CFI         =6'd31;
    parameter ESP_A0SEEN      =6'd32;
    parameter ESP_AS          =6'd33;
    parameter PGMS            =6'd34;
    parameter PSPS            =6'd35;
    parameter PSP             =6'd36;
    parameter PSP_CFI_U       =6'd37;
    parameter PSP_CFI         =6'd38;
    parameter PSP_Z001        =6'd39;
    parameter PSP_PREL        =6'd40;
    parameter PSP_AS          =6'd41;

    reg [5:0] current_state;
    reg [5:0] next_state;

    reg deq;
    always @(DIn, DOut)
    begin
        if (DIn==DOut)
            deq=1'b1;
        else
            deq=1'b0;
    end
    // check when data is generated from model to avoid setuphold check in
    // those occasions
    assign deg=deq;

    // initialize memory and load preoload files if any
    initial
    begin: InitMemory
    integer i,j;
    reg     sector_prot[0:256];
    integer secure_silicon[0:SecSiSize];

        for (i=0;i<(SecSize+1)*(SecNum+1);i=i+1)
        begin
           Mem[i]=MaxData;
        end
        for (i=0;i<=256;i=i+1)
        begin
           sector_prot[i]=0;
        end
        for (i=0;i<=SecSiSize;i=i+1)
        begin
           secure_silicon[i]=MaxData;
        end

        if ((UserPreload) && !(prot_file_name == "none"))
        begin
           //- Sector protection preload
           //s29gl128m_r2_prot  sector protect file
           //   //      - comment
           //   @aaa    - <aaa> stands for sector address
           //   (aaa is incremented at every load)
           //   b       - <b> is 1 for protected sector <aaa>, 0 for unprotect.
           //   If <aaa> > SecNum SecSi
           //   is protected/unprotected
           $readmemb(prot_file_name,sector_prot);
        end
        if ((UserPreload) && !(secsi_file_name == "none"))
        begin
           // Secure Silicon Sector Region preload
           // s29gl128m_r2_secsi memory file
           //   //       - comment
           //   @aa     - <aa> stands for address within SecSi sector
           //   dd      - <dd> is byte to be written at SecSi(aa++)
           //  (aa is incremented at every load)
           $readmemh(secsi_file_name,secure_silicon);
        end
        if ((UserPreload) && !(mem_file_name == "none"))
        begin
           // Memory Preload
           //s29gl128m_r2.mem, memory preload file
           //  @aaaaaa - <aaaaaa> stands for address within last defined sector
           //  dd      - <dd> is byte to be written at Mem(nn)(aaaaaa++)
           // (aaaaaa is incremented at every load)
           $readmemh(mem_file_name,Mem);
        end

        for (i=0;i<=SecNum;i=i+1)
        begin
            Ers_queue[i] = 0;
            Sec_Prot[i] = sector_prot[i];
        end

        for (i=0;i<=SecSiSize;i=i+1)
        begin
            SecSi[i] = secure_silicon[i];
        end

        FactoryProt = sector_prot[256];
        for (i=0;i<=31;i=i+1)
        begin
            WBData[i] = 0;
            WBAddr[i] = -1;
        end
    end

    //Power Up time 100 ns;
    initial
    begin
        PoweredUp = 1'b0;
        #100 PoweredUp = 1'b1;
    end
    always @(RESETNeg)
    begin
        RST <= #499 RESETNeg;
    end

    initial
    begin

        write    = 1'b0;
        read     = 1'b0;
        Addr   = 0;

        WPage  = 0;
        RPage  = 0;
        RPchange  = 1'b1;

        ULBYPASS = 1'b0;
        OTP_ACT  = 1'b0 ;
        PSP_ACT  = 1'b0 ;
        ESP_ACT  = 1'b0 ;
        LCNT  = 0 ;

        PCNT  = 0;

        PDONE    = 1'b1;
        PSTART   = 1'b0;
        PSUSP    = 1'b0;
        PRES     = 1'b0;

        PERR     = 1'b0;

        EDONE    = 1'b1;
        ESTART   = 1'b0;
        ESUSP    = 1'b0;
        ERES     = 1'b0;

        EERR     = 1'b0;
        READY_in = 1'b0;
        READY    = 1'b0;

    end

    always @(posedge START_T1_in)
    begin:TSTARTT1r
        #tdevice_START_T1 START_T1 = START_T1_in;
    end
    always @(negedge START_T1_in)
    begin:TSTARTT1f
        #1 START_T1 = START_T1_in;
    end

    always @(posedge CTMOUT_in)
    begin:TCTMOUTr
        #(tdevice_CTMOUT - 1) CTMOUT = CTMOUT_in;
    end
    always @(negedge CTMOUT_in)
    begin:TCTMOUTf
        #1 CTMOUT = CTMOUT_in;
    end

    always @(posedge READY_in)
    begin:TREADYr
        #tdevice_READY READY = READY_in;
    end
    always @(negedge READY_in)
    begin:TREADYf
        #1 READY = READY_in;
    end
    ////////////////////////////////////////////////////////////////////////////
    ////     obtain 'LAST_EVENT information
    ////////////////////////////////////////////////////////////////////////////
    always @(negedge OENeg)
    begin
        OENeg_event = $time;
    end
    always @(negedge CENeg)
    begin
        CENeg_event = $time;
    end
    always @(A)
    begin
        ADDR_event = $time;
    end
    always @(DIn[15])
    begin
        if (~BYTENeg)
            ADDR_event = $time;
    end

    ////////////////////////////////////////////////////////////////////////////
    //// sequential process for reset control and FSM state transition
    ////////////////////////////////////////////////////////////////////////////
    reg R;
    reg E;
    always @(RESETNeg)
    begin
        if (PoweredUp)
        begin
        //Hardware reset timing control
            if (~RESETNeg)
            begin
                E = 1'b0;
                if (~PDONE || ~EDONE)
                begin
                    //if program or erase in progress
                    READY_in = 1'b1;
                    R = 1'b1;
                end
                else
                begin
                    READY_in = 1'b0;
                    R = 1'b0;         //prog or erase not in progress
                end
            end
            else if (RESETNeg && RST)
            begin
                //RESET# pulse < tRP
                READY_in = 1'b0;
                R = 1'b0;
                E = 1'b1;
            end
         end
    end

    always @(next_state or RESETNeg or CENeg or RST or READY or PoweredUp)
    begin: StateTransition

        if (PoweredUp)
        begin

            if (RESETNeg && (~R || (R && READY)))
            begin
                current_state = next_state;
                READY_in = 1'b0;
                E = 1'b0;
                R = 1'b0;
                reseted = 1'b1;
            end
            else if ((~R && ~RESETNeg && ~RST) ||
                  (R && ~RESETNeg && ~RST && ~READY) ||
                  (R && RESETNeg && ~RST && ~READY)) // ||
            begin
                //no state transition while RESET# low
                current_state = RESET; //reset start
                reseted       = 1'b0;
            end
        end
        else
        begin
            current_state = RESET;      // reset
            reseted       = 1'b0;
            E = 1'b0;
            R = 1'b0;
        end

end

    ///////////////////////////////////////////////////////////////////////////
    //Glitch Protection: Inertial Delay does not propagate pulses <5ns
    ///////////////////////////////////////////////////////////////////////////
    assign #5 gWE_n = WENeg_ipd;
    assign #5 gCE_n = CENeg_ipd;
    assign #5 gOE_n = OENeg_ipd;

    //latch address on rising edge and data on falling edge  of write
    always @(gWE_n or  gCE_n or  gOE_n or RESETNeg)
    begin: write_dc
        if (RESETNeg!=1'b0)
        begin
            if (~gWE_n && ~gCE_n && gOE_n)
                write = 1'b1;
            else
                write = 1'b0;
        end

        if (gWE_n && ~gCE_n && ~gOE_n)
            read = 1'b1;
        else
            read = 1'b0;

    end

    ///////////////////////////////////////////////////////////////////////////
    //Process that reports warning when changes on signals WE#, CE#, OE# are
    //discarded
    ///////////////////////////////////////////////////////////////////////////
    always @(WENeg)
    begin: PulseWatch1
        if (gWE_n == WENeg) $display("Glitch on WE#");
    end
    always @(CENeg)
    begin: PulseWatch
        if (gCE_n == CENeg) $display("Glitch on CE#");
    end
    always @(OENeg)
    begin: PulseWatch3
        if (gOE_n == OENeg) $display("Glitch on OE#");
    end

    ///////////////////////////////////////////////////////////////////////////
    //Latch address on falling edge of WE# or CE# what ever comes later
    //Latches data on rising edge of WE# or CE# what ever comes first
    // also Write cycle decode
    ///////////////////////////////////////////////////////////////////////////
    integer A_tmp  ;
    integer SA_tmp ;
    integer A_tmp1 ;

    reg CE;

    always @(WENeg_ipd)
    begin
        if (reseted)
        begin
            if (~WENeg_ipd && ~CENeg_ipd && OENeg_ipd )
            begin
                A_tmp  =  A[10:0];
                SA_tmp =  A[HiAddrBit:15];

                if (~BYTENeg)
                    A_tmp1 = { A[14:0],DIn[15] };
                else
                    A_tmp1 = { A[14:0],1'b0};
            end
        end
    end

    always @(CENeg_ipd)
    begin
        if (reseted)
        begin
            if (~CENeg_ipd && (WENeg_ipd != OENeg_ipd) )
            begin
                A_tmp  =  A[10:0];
                SA_tmp =  A[HiAddrBit:15];

                if (~BYTENeg)
                    A_tmp1 = { A[14:0],DIn[15] };
                else
                    A_tmp1 = { A[14:0],1'b0};
            end
        end
    end

    always @(negedge OENeg_ipd )
    begin
        if (reseted)
        begin
            if (~OENeg_ipd && WENeg_ipd && ~CENeg_ipd)
            begin
                A_tmp  =  A[10:0];
                SA_tmp =  A[HiAddrBit:15];

                if (~BYTENeg)
                    A_tmp1 = { A[14:0],DIn[15] };
                else
                    A_tmp1 = { A[14:0],1'b0};
            end
            if (~OENeg_ipd)
            begin
                SecAddr = SA_tmp;
                Address = A_tmp1;
                WPage   = A_tmp1 / 32;
                if ((RPage  != (A_tmp1/8)) || (CENeg!=CE))
                    RPchange = 1'b1;
                else
                    RPchange = 1'b0;
                RPage  = A_tmp1 / 8;
                CE = CENeg;
                Addr   = A_tmp;
            end
        end
    end

    always @(A or BYTENeg)
    begin
        if (reseted)
        begin
            if (WENeg_ipd && ~CENeg_ipd && ~OENeg_ipd)
            begin
                A_tmp  =  A[10:0];
                SA_tmp =  A[HiAddrBit:15];

                if (~BYTENeg)
                    A_tmp1 = { A[14:0],DIn[15] };
                else
                    A_tmp1 = { A[14:0],1'b0};

                SecAddr = SA_tmp;
                Address = A_tmp1;
                WPage   = A_tmp1 / 32;
                if ((RPage  != (A_tmp1/8)) || (CENeg!=CE))
                    RPchange = 1'b1;
                else
                    RPchange = 1'b0;
                RPage  = A_tmp1 / 8;
                CE = CENeg;
                Addr   = A_tmp;
            end
        end
    end

    always @(DIn)
    begin
        if (reseted)
        begin
            if (~BYTENeg && WENeg_ipd && ~CENeg_ipd && ~OENeg_ipd)
            begin
                A_tmp  =  A[10:0];
                SA_tmp =  A[HiAddrBit:15];

                if (~BYTENeg)
                    A_tmp1 = { A[14:0],DIn[15] };
                else
                    A_tmp1 = { A[14:0],1'b0};

                SecAddr = SA_tmp;
                Address = A_tmp1;
                WPage   = A_tmp1 / 32;
                if ((RPage  != (A_tmp1/8)) || (CENeg!=CE))
                    RPchange = 1'b1;
                else
                    RPchange = 1'b0;
                RPage  = A_tmp1 / 8;
                CE = CENeg;
                Addr   = A_tmp;
            end
        end
    end

    always @(posedge write)
    begin
            SecAddr = SA_tmp;
            Address = A_tmp1;
            WPage   = A_tmp1 / 32;
            if ((RPage  != (A_tmp1/8)) || (CENeg!=CE))
                RPchange = 1'b1;
            else
                RPchange = 1'b0;
            RPage  = A_tmp1 / 8;
            CE = CENeg;
            Addr   = A_tmp;
    end

    ///////////////////////////////////////////////////////////////////////////
    // Timing control for the Program/ Write Buffer Program Operations
    // start/ suspend/ resume
    ///////////////////////////////////////////////////////////////////////////

    integer cnt_write = 0;
    time elapsed_write  ;
    time duration_write ;
    time start_write    ;
    event pdone_event;

    always @(posedge reseted)
    begin
        disable pdone_process;
        PDONE = 1'b1;
    end

    always @(reseted or PSTART)
    begin
        if (reseted)
        begin
            if (PSTART && PDONE)
            begin
                if (~(Sec_Prot[SA] ||
                       (Ers_queue[SA] && ESP_ACT) ||
                       (FactoryProt && OTP_ACT) ))
                begin
                    if (PCNT<32)  //buffer
                    begin
                        if (BYTENeg) cnt_write = PCNT+2;
                        else cnt_write = PCNT+1;
                        duration_write = cnt_write* tdevice_WBPB;
                    end
                    else   //Word/Byte program
                    begin
                        if (BYTENeg) cnt_write = 2;
                        else cnt_write = 1;
                        duration_write = cnt_write* tdevice_POB;
                    end

                    elapsed_write = 0;
                    PDONE = 1'b0;
                    ->pdone_event;
                    start_write   = $time;
                end
                else
                begin
                    PERR = 1'b1;
                    PERR <= #1000 1'b0;
                end
            end
        end
    end

    always @(reseted or PSUSP)
    begin
        if (reseted)
        begin
            if (PSUSP & ~PDONE)
            begin
                disable pdone_process;
                elapsed_write  = $time - start_write;
                duration_write = duration_write - elapsed_write;
                PDONE = 1'b0;
            end
        end
    end
    always @(reseted or PRES)
    begin
        if (reseted)
        begin
            if (PRES & ~PDONE)
            begin
                start_write = $time;
                ->pdone_event;
            end
        end
    end

    always @(pdone_event)
    begin:pdone_process
        PDONE = 1'b0;
        #duration_write PDONE = 1'b1;
    end

    ///////////////////////////////////////////////////////////////////////////
    // Timing control for the Erase Operations
    ///////////////////////////////////////////////////////////////////////////
    integer cnt_erase = 0;
    time elapsed_erase;
    time duration_erase;
    time start_erase;

    always @(posedge reseted)
    begin
        disable edone_process;
        EDONE = 1'b1;
    end
    event edone_event;
    always @(reseted or ESTART)
    begin: erase
    integer i;
        if (reseted)
        begin
            if (ESTART && EDONE)
            begin
                cnt_erase = 0;
                for (i=0;i<=SecNum;i=i+1)
                    if (Ers_queue[i] && Sec_Prot[i]!=1'b1)
                        cnt_erase = cnt_erase + 1;
                if (cnt_erase>0)
                begin
                    elapsed_erase = 0;
                    duration_erase = cnt_erase* tdevice_SEO;
                    ->edone_event;
                    start_erase = $time;
                end
                else
                begin
                    EERR = 1'b1;
                    EERR <= #100000  1'b0;
                end
            end
        end
    end

    always @(edone_event)
    begin : edone_process
        EDONE = 1'b0;
        #duration_erase EDONE = 1'b1;
    end

    always @(reseted or ESUSP)
    begin
        if (reseted)
            if (ESUSP && ~EDONE)
            begin
                disable edone_process;
                elapsed_erase = $time - start_erase;
                duration_erase = duration_erase - elapsed_erase;
                EDONE = 1'b0;
            end
    end
    always @(reseted or ERES)
    begin
        if (reseted)
            if (ERES && ~EDONE)
            begin
                start_erase = $time;
                EDONE = 1'b0;
                ->edone_event;
            end
    end

    ///////////////////////////////////////////////////////////////////////////
    // Main Behavior Process
    // combinational process for next state generation
    ///////////////////////////////////////////////////////////////////////////
    reg PATTERN_1  = 1'b0;
    reg PATTERN_2  = 1'b0;
    reg A_PAT_1  = 1'b0;

    //DATA  High Byte
    integer DataHi   ;
    //DATA Low Byte
    integer DataLo   ;

    always @(negedge write or reseted)
    begin: StateGen1

        if (~write)
        begin
            DataLo = DIn[7:0];
            if (BYTENeg)
                DataHi = DIn[15:8];
            PATTERN_1 = (Addr==16'h555) && (DataLo==8'hAA) ;
            PATTERN_2 = (Addr==16'h2AA) && (DataLo==8'h55) ;
            A_PAT_1   = ((Addr==16'h555) && ~ULBYPASS) || ULBYPASS;
        end

        if (reseted!=1'b1)
            next_state = current_state;
        else
        case (current_state)
            RESET :
            begin
                if (~write)
                begin
                    if (PATTERN_1)
                        next_state = Z001;
                    else if ((Addr==8'h55) && (DataLo==8'h98))
                        next_state = CFI;
                    else
                        next_state = RESET;
                end
            end

            Z001 :
            begin
                if (~write)
                begin
                    if (PATTERN_2)
                        next_state = PREL_SETBWB;
                    else
                        next_state = RESET;
                end
            end

            PREL_SETBWB :
            begin
                if (~write)
                begin
                    if (A_PAT_1 && (DataLo==16'h20))
                        next_state = PREL_ULBYPASS;
                    else if  (A_PAT_1 && (DataLo==16'h90))
                        next_state = AS;
                    else if (A_PAT_1 && (DataLo==16'hA0))
                        next_state = A0SEEN;
                    else if (A_PAT_1 && (DataLo==16'h88))
                        next_state = OTP;
                    else if (A_PAT_1 && (DataLo==16'h80))
                    begin
                        if (ULBYPASS)
                            next_state = C8_PREL;
                        else
                            next_state = C8;
                    end
                    else if (DataLo==16'h25)
                        //fix Sector Address SA
                        next_state = WBPGMS_WBCNT;
                    else if (ULBYPASS)
                        next_state = PREL_ULBYPASS;
                    else
                        next_state = RESET;
                end
            end

            PREL_ULBYPASS :
            begin
                if (~write)
                begin
                    if (DataLo==16'h20)
                        next_state = PREL_ULBYPASS;
                    else if (DataLo==16'h98)
                        next_state = CFI_U;
                    else if (A_PAT_1 && (DataLo==16'h90))
                        next_state = AS;
                    else if (A_PAT_1 && (DataLo==16'hA0))
                        next_state = A0SEEN;
                    else if (A_PAT_1 && (DataLo==16'h88))
                        next_state = OTP;
                    else if (A_PAT_1 && (DataLo==16'h80))
                        next_state = C8_PREL;
                    else if (DataLo==16'h25)
                        //fix Sector Address  SA
                        next_state = WBPGMS_WBCNT;
                    else
                        next_state = PREL_ULBYPASS;
                end
            end

            CFI_U :
            begin
                if (~write)
                begin
                    if (DataLo==16'hF0)
                        next_state = RESET;
                    else
                        next_state =  CFI_U;
                end
            end

            CFI :
            begin
                if (~write)
                begin
                    if ((Addr==16'h55) && (DataLo==16'h98))
                        next_state = CFI;
                    else if (DataLo==16'hF0)
                        next_state = RESET;
                    else
                        next_state =  CFI;
                end
            end

            AS :
            begin
                if (~write)
                 begin
                      if (DataLo==16'hF0)
                          next_state = RESET;
                  else
                      next_state = AS;
                end
            end

            A0SEEN :
            begin
                if (~write)
                    next_state = PGMS;
                else
                    next_state = A0SEEN;
            end

            OTP :
            begin
                if (~write)
                begin
                    if (PATTERN_1)
                        next_state = OTP_Z001;
                        else
                            next_state = OTP;
                end
            end

            OTP_Z001 :
            begin
                if (~write)
                begin
                    if (PATTERN_2)
                        next_state = OTP_PREL;
                    else
                        next_state = OTP_Z001;
                end
            end

            OTP_PREL :
            begin
                if (~write)
                begin
                    if (A_PAT_1 && (DataLo == 16'h90))
                        next_state = OTP_AS;
                    else if (DataLo == 16'h25)
                        //fix Sector Address  SA
                        next_state = WBPGMS_WBCNT;
                    else if (A_PAT_1 && (DataLo == 16'hA0))
                        next_state = OTP_A0SEEN;
                    else
                        next_state = OTP;
                end
            end

            OTP_AS :
            begin
                if (~write)
                begin
                    if (DataLo==16'hF0)
                        if (PSP_ACT)
                            next_state = PSP;
                        else if (ESP_ACT)
                            next_state = ESP;
                        else
                            next_state = RESET;
                    else
                        next_state = OTP;
                end
            end

            OTP_A0SEEN :
            begin
                if (~write)
                    next_state = PGMS; //set OTP
                else
                    next_state = OTP_A0SEEN;
            end

            C8 :
            begin
                if (~write)
                begin
                    if (PATTERN_1)
                        next_state = C8_Z001;
                    else if (DataLo==16'h25)
                        //fix Sector Address  SA
                        next_state = WBPGMS_WBCNT;
                    else if (ULBYPASS)
                        next_state = PREL_ULBYPASS;
                    else
                        next_state = RESET;
                end
            end

            C8_Z001 :
            begin
                if (~write)
                begin
                    if (PATTERN_2)
                        next_state = C8_PREL;
                    else if (DataLo==16'h25)
                        //fix Sector Address  SA
                        next_state = WBPGMS_WBCNT;
                    else if (ULBYPASS)
                        next_state = PREL_ULBYPASS;
                    else
                        next_state = RESET;
                end
            end

            C8_PREL :
            begin
                if (~write)
                begin
                    if (A_PAT_1 && (DataLo==16'h10))
                        next_state = ERS;
                    else if (DataLo==16'h30)
                        next_state = SERS;
                    else if (ULBYPASS)
                        next_state = PREL_ULBYPASS;
                    else
                        next_state = RESET;
                end
            end

            ERS :
            begin
            end

            SERS :
            begin
                if (~write)
                    if (~CTMOUT)
                        if (DataLo == 16'hB0)
                            next_state = ESP; // ESP according to datasheet
                        else if (DataLo==16'h30)
                            next_state = SERS;
                        else if (ULBYPASS)
                            next_state = PREL_ULBYPASS;
                        else
                            next_state = RESET;
            end

            WBPGMS_WBCNT :
            begin
                if (~write)
                begin
                    if ((SecAddr == SA) &&
                       ((~BYTENeg && DataLo<32) ||
                        (BYTENeg && DataLo<16)))
                        next_state = WBPGMS_WBLSTA;
                    else
                        next_state = WBPGMS_WBABORT;
                end
            end

            WBPGMS_WBLSTA :
            begin
                if (~write)
                begin
                    if (SecAddr == SA)   // fix WriteBufferPage  WBPage
                        if (LCNT>0)
                            next_state = WBPGMS_WBLOAD;
                        else
                            next_state = WBPGMS_CONFB;

                    else
                        next_state = WBPGMS_WBABORT;
                end
            end

            WBPGMS_WBLOAD :
            begin
                if (~write)
                    if (WPage==WBPage)
                        if (LCNT>0)
                            next_state = WBPGMS_WBLOAD;
                        else
                            next_state = WBPGMS_CONFB;

                    else
                        next_state = WBPGMS_WBABORT;
            end

            WBPGMS_CONFB :
            begin
                if (~write)
                    if ((SecAddr == SA) && (DataLo == 16'h29))
                        next_state = PGMS; //WBPGMS
                    else
                        next_state = WBPGMS_WBABORT;
            end

            WBPGMS_WBABORT :
            begin
                if (~write)
                    if (PATTERN_1)
                        next_state = WBPGMS_Z001;
            end

            WBPGMS_Z001 :
            begin
                if (~write)
                    if (PATTERN_2)
                        next_state = WBPGMS_PREL;
                    else
                        next_state = WBPGMS_WBABORT;
            end

            WBPGMS_PREL :
            begin
                if (~write)
                begin
                    if (DataLo == 16'hF0)
                    begin
                        if (ESP_ACT)
                            next_state = ESP;
                        else if (ULBYPASS)
                            next_state = PREL_ULBYPASS;
                        else if (OTP_ACT)
                            next_state = OTP;
                        else
                            next_state = RESET;
                    end
                    else
                        next_state = WBPGMS_WBABORT;
                end
            end

            SERS_EXEC :
            begin
            end

            ESP :
            begin
                if (~write)
                begin
                    if (DataLo == 16'h30)
                        next_state = SERS_EXEC;
                    else if (ULBYPASS)
                    begin
                        if (DataLo == 16'h98)
                            next_state = ESP_CFI_U;
                        else if (DataLo == 16'h25)
                            //fix SA
                            next_state = WBPGMS_WBCNT; //set ESP
                        else if (A_PAT_1 && (DataLo == 16'hA0))
                            next_state = ESP_A0SEEN;
                        else if (A_PAT_1 && (DataLo == 16'h88))
                            next_state = OTP; //set ESP
                        else if (A_PAT_1 && (DataLo == 16'h90))
                            next_state = ESP_AS;
                    end
                    else
                    begin
                        if ((Addr == 16'h55) && (DataLo == 16'h98))
                            next_state = ESP_CFI;
                        else if (PATTERN_1)
                            next_state = ESP_Z001;
                    end
                end
            end

            ESP_Z001 :
            begin
                if (~write)
                    if (PATTERN_2)
                        next_state = ESP_PREL;
                    else
                        next_state = ESP;
            end

            ESP_PREL :
            begin
                if (~write)
                    if (A_PAT_1 && (DataLo == 16'h20))
                        next_state = ESP; //set ULBYPASS
                    else if (DataLo == 16'h25)
                        //fix SA
                        next_state = WBPGMS_WBCNT; //set ESP
                    else if (A_PAT_1 && DataLo == 16'hA0)
                        next_state = ESP_A0SEEN;
                    else if (A_PAT_1 && DataLo == 16'h88)
                        next_state = OTP; //set ESP
                    else if (A_PAT_1 && DataLo == 16'h90)
                        next_state = ESP_AS;
                    else
                        next_state = ESP;
            end

            ESP_CFI_U :
            begin
                //reset ULBYPASS
                if (~write)
                    if (DataLo == 16'h98)
                    begin
                    end
                    else if (DataLo == 16'hF0)
                        next_state = ESP;
            end

            ESP_CFI :
            begin
                if (~write)
                    if ((Addr == 16'h55) && (DataLo == 16'h98))
                    begin
                    end
                    else if (DataLo == 16'hF0)
                        next_state = ESP;
                    else if (DataLo == 16'h30)
                        next_state = SERS_EXEC;
                    else
                        next_state = ESP;
            end

            ESP_A0SEEN :
            begin
                if (~write)
                    next_state = PGMS; //set ESP
            end

            ESP_AS :
            begin
                if (~write)
                    if (DataLo == 16'hF0)
                        // reset ULBYPASS
                        next_state = ESP;
            end

            PGMS :
            begin
                if (~write && PERR!=1'b1)
                    if (DataLo==16'hB0)
                    begin
                        next_state = PSPS;
                        PSUSP = 1'b1;
                    end
            end

            PSPS :
            begin
            end

            PSP :
            begin
                if (~write)
                    if (DataLo == 16'h30)
                        next_state = PGMS;
                    else if (ULBYPASS)
                        if (DataLo == 16'h98)
                            next_state = PSP_CFI_U;
                        else
                            next_state = PSP_PREL;

                    else if ((Addr == 16'h55) && (DataLo == 16'h98))
                        next_state = PSP_CFI;
                    else if (PATTERN_1)
                        next_state = PSP_Z001;
            end

            PSP_CFI_U :
            begin
                //reset ULBYPASS
                if (~write)
                    if (DataLo == 16'h98)
                    begin
                    end
                    else if (DataLo == 16'hF0)
                        next_state = PSP;
            end

            PSP_CFI :
            begin
                if (~write)
                    if ((Addr == 16'h55) && (DataLo == 16'h98))
                    begin
                    end
                    else if (DataLo == 16'hF0)
                        next_state = PSP;
            end

            PSP_Z001 :
            begin
                if (~write)
                    if (PATTERN_2)
                        next_state = PSP_PREL;
                    else
                        next_state = PSP;
            end

            PSP_PREL :
            begin
                if (~write)
                    if (A_PAT_1 && (DataLo == 16'h90))
                        next_state = PSP_AS;
                    else if (A_PAT_1 && (DataLo ==16'h88))
                        next_state = OTP; //set PSP
                    else
                        next_state = PSP;
            end

            PSP_AS :
            begin
                if (~write)
                    if (DataLo == 16'hF0)
                        // reset ULBYPASS
                        next_state = PSP;
            end

        endcase

    end

    always @(posedge PDONE or negedge PERR)
    begin: StateGen6
        if (reseted!=1'b1)
            next_state = current_state;
        else
        begin
            if (current_state==PGMS)
            begin
                if (ESP_ACT)
                    next_state = ESP;
                else if (ULBYPASS)
                    next_state = PREL_ULBYPASS;
                else if (OTP_ACT)
                    next_state = OTP;
                else
                    next_state = RESET;
            end
        end
    end

    always @(posedge EDONE or negedge EERR)
    begin: StateGen2
        if (reseted!=1'b1)
            next_state = current_state;
        else
        begin
            if ((current_state==ERS) || (current_state==SERS_EXEC))
            begin
                if (EDONE)
                    if (ULBYPASS)
                        next_state = PREL_ULBYPASS;
                    else
                        next_state = RESET;
            end
        end
    end

    always @(negedge EERR or reseted)
    begin: StateGen3
        if (reseted!=1'b1)
            next_state = current_state;
        else
        begin
        if ((current_state==ERS) || (current_state==SERS_EXEC)||
            (current_state==PGMS))
            if (~EERR)
                if (~(EERR!=1'b1))
                    if (ULBYPASS)
                        next_state = PREL_ULBYPASS;
                    else
                        next_state = RESET;
        end
    end

    always @(CTMOUT or reseted)
    begin: StateGen4
        if (reseted!=1'b1)
            next_state = current_state;
        else
        begin
        if (current_state==SERS)
            if (CTMOUT)  next_state = SERS_EXEC;
        end
    end

    always @(posedge START_T1 or reseted)
    begin: StateGen5
        if (reseted!=1'b1)
            next_state = current_state;
        else
        if (current_state==ESPS)
            if (START_T1) next_state = ESP;
    end

    always @(negedge write or reseted)
    begin: StateGen7
        if (reseted!=1'b1)
            next_state = current_state;
        else
        begin
        if (current_state==SERS_EXEC)
            if ((write==1'b0) && (EERR!=1'b1))
                if (DataLo==16'hB0)
                    next_state = ESPS;
        end
    end

    always @(posedge START_T1 or reseted)
    begin: StateGen8
        if (reseted!=1'b1)
            next_state = current_state;
        else
        begin
        if (current_state==PSPS)
                if (START_T1)
                begin
                    next_state = PSP;
                    PSUSP = 1'b0;
                end
        end
    end

    ///////////////////////////////////////////////////////////////////////////
    //FSM Output generation and general functionality
    ///////////////////////////////////////////////////////////////////////////

    always @(posedge read)
    begin
        ->oe_event;
    end
    always @(Address)
    begin
        if (read)
            ->oe_event;
    end

    always @(oe_event)
    begin
        oe = 1'b1;
        #1 oe = 1'b0;
    end

    always @(oe or reseted or current_state)
    begin
        if (reseted)
        begin
        case (current_state)
            RESET :
            begin
                if (oe)
                begin
                    DOut_zd[7:0] = READMEM(SecAddr, Address);

                    if (BYTENeg)
                        DOut_zd[15:8] = READMEM(SecAddr, Address+1);
                end
            end
            CFI_U :
            begin

                if (oe)
                begin
                    DOut_zd[15:0] = 16'b0;
                    //CFI read using 16bit address
                    if ((Addr>16'h10)&&(Addr<16'h50))
                    begin
                        if (~BYTENeg)
                            DOut_zd[15:8] = 8'bZ;
                        DOut_zd[7:0] = CFI_array[Addr];
                    end
                    else
                        $display("Invalid CFI query address");
                end
            end

            CFI :
            begin
                 if (oe)
                 begin
                    DOut_zd[15:0] = 16'b0;
                    if ((Addr>16'h10)&&(Addr<16'h50))
                    begin
                          if (~BYTENeg)
                            DOut_zd[15:8] = 8'bZ;
                          DOut_zd[7:0] = CFI_array[Addr];
                    end
                    else
                        $display ("Invalid CFI query address");
                 end
            end

            AS :
            begin
                if (oe)
                begin
                    if (BYTENeg)
                        if (Address == 0)
                            DOut_zd[15:8] = 0;
                        else
                            DOut_zd[15:8] = 8'h22;
                    else
                        DOut_zd[15:8] = 8'bZ;

                    if (Addr == 0)
                        DOut_zd[7:0] = 1;
                    else if (Addr == 1)
                        DOut_zd[7:0] = 8'h7E;
                    else if (Addr == 2)
                    begin
                        DOut_zd[7:1] = 7'b0;
                        DOut_zd[0] = Sec_Prot[SecAddr];
                    end
                    else if (Addr == 3)
                    begin
                        DOut_zd[7:0] = 8;

                        if (FactoryProt)
                            DOut_zd[7] = 1'b1;
                    end
                    else if (Addr == 16'hE)
                        DOut_zd[7:0] = 8'h12;
                    else if (Addr == 16'hF)
                        DOut_zd[7:0] = 8'b00;
                end
            end

            OTP :
            begin
                if (oe)
                begin
                    //read SecSi Sector Region
                    if (SecSi[Address]==-1)
                        DOut_zd[7:0] = 8'bx;
                    else
                        DOut_zd[7:0] = SecSi[Address];

                    if (BYTENeg)
                        if (SecSi[Address+1]==-1)
                            DOut_zd[15:8]= 8'bx;
                        else
                            DOut_zd[15:8] = SecSi[Address+1];
                end
            end

            OTP_AS :
            begin
                if (oe)
                begin
                    if (BYTENeg)
                        if (Address == 0)
                            DOut_zd[15:8] = 0;
                        else
                            DOut_zd[15:8] = 16'h22;
                    else
                        DOut_zd[15:8] = 8'bZ;

                    if (Addr == 0)
                        DOut_zd[7:0] = 1;
                    else if (Addr == 1)
                        DOut_zd[7:0] = 16'h7E;
                    else if (Addr == 2)
                    begin
                        DOut_zd[7:1] = 0;
                        DOut_zd[0] = Sec_Prot[SecAddr];
                    end
                    else if (Addr == 3)
                    begin
                        DOut_zd[7:0] = 8;

                        if (FactoryProt)
                            DOut_zd[7] = 1'b1;
                    end
                    else if (Addr == 16'hE)
                        DOut_zd[7:0] = 16'h12;
                    else if (Addr == 16'hF)
                        DOut_zd[7:0] = 8'b00;
                end
            end

            ERS :
            begin
                if (oe)
                begin
                    ///////////////////////////////////////////////////////////
                    // read status / embeded erase algorithm - Chip Erase
                    ///////////////////////////////////////////////////////////
                    Status[7] = 1'b0;
                    Status[6] = ~Status[6]; //toggle
                    Status[5] = 1'b0;
                    Status[3] = 1'b1;
                    Status[2] = ~Status[2]; //toggle

                    DOut_zd[7:0] = Status;
                    if (BYTENeg)
                        DOut_zd[15:8] = 8'b0;
                end
            end

            SERS :
            begin
                if (oe)
                begin
                    ///////////////////////////////////////////////////////////
                    //read status - sector erase timeout
                    ///////////////////////////////////////////////////////////
                    Status[3] = 1'b0;

                    DOut_zd[7:0] = Status;
                    if (BYTENeg)
                        DOut_zd[15:8] = 8'b0;
                end
            end

            ESPS :
            begin
                if (oe)
                begin
                    ///////////////////////////////////////////////////////////
                    //read status / erase suspend timeout - stil erasing
                    ///////////////////////////////////////////////////////////
                    Status[7] = 1'b0;
                    Status[6] = ~Status[6]; //toggle
                    Status[5] = 1'b0;
                    Status[3] = 1'b1;
                    if ( Ers_queue[SecAddr] == 1'b1 )
                        Status[2] = ~Status[2]; //toggle

                    DOut_zd[7:0] = Status;
                    if (BYTENeg)
                        DOut_zd[15:8] = 8'b0;
                end
            end

            WBPGMS_WBABORT :
            begin
                if (oe)
                begin
                    ///////////////////////////////////////////////////////////
                    //read status / write buffer abort
                    ///////////////////////////////////////////////////////////
                    Status[6] = ~Status[6]; //toggle
                    Status[5] = 1'b0;
                    Status[1] = 1'b1;

                    DOut_zd[7:0] = Status;
                    if (BYTENeg)
                        DOut_zd[15:8] = 8'b0;
                end
            end

            SERS_EXEC:
            begin
                if (oe)
                begin
                    ///////////////////////////////////////////////////
                    //read status erase HANG
                    ///////////////////////////////////////////////////
                    //model should never hang
                    Status[7] = 1'b0;
                    Status[6] = ~Status[6]; //toggle
                    Status[5] = 1'b0;
                    Status[3] = 1'b1;
                    if ( Ers_queue[SecAddr] == 1'b1 )
                        Status[2] = ~Status[2]; //toggle

                    DOut_zd[7:0] = Status;
                    if (BYTENeg)
                        DOut_zd[15:8] = 8'b0;
                end
            end

            ESP :
            begin
                if (oe)
                begin
                    ///////////////////////////////////////////////////////////
                    //read
                    ///////////////////////////////////////////////////////////
                    if (Ers_queue[SecAddr]!=1'b1)
                    begin
                        DOut_zd[7:0] = READMEM(SecAddr, Address);

                        if (BYTENeg)
                            DOut_zd[15:8] = READMEM(SecAddr, Address+1);
                    end
                    else
                    begin
                        ///////////////////////////////////////////////////////
                        //read status
                        ///////////////////////////////////////////////////////
                        Status[7] = 1'b1;
                        // Status[6) No toggle
                        Status[5] = 1'b0;
                        Status[2] = ~Status[2]; //toggle

                        DOut_zd[7:0] = Status;
                        if (BYTENeg)
                            DOut_zd[15:8] = 8'b0;
                    end
                end
            end

            ESP_CFI_U:
            begin
                if (oe)
                begin
                    DOut_zd[15:0] = 16'b0;
                    if ((Addr>16'h10)&&(Addr<16'h50))
                    begin
                        if (~BYTENeg)
                            DOut_zd[15:8] = 8'bZ;
                        DOut_zd[7:0] = CFI_array[Addr];
                    end
                    else
                        $display("Invalid CFI query address");
                end
            end

            ESP_CFI :
            begin
                if (oe)
                begin
                    DOut_zd[15:0] = 16'b0;
                    if ((Addr>16'h10)&&(Addr<16'h50))
                    begin
                        if (~BYTENeg)
                            DOut_zd[15:8] = 8'bZ;
                        DOut_zd[7:0] = CFI_array[Addr];
                    end
                    else
                        $display("Invalid CFI query address");
                end
            end

            ESP_AS :
            begin
                if (oe)
                begin
                    if (BYTENeg)
                        if (Address == 0)
                            DOut_zd[15:8] = 0;
                        else
                            DOut_zd[15:8] = 16'h22;
                    else
                        DOut_zd[15:8] = 8'bZ;

                    if (Addr == 0)
                        DOut_zd[7:0] = 1;
                    else if (Addr == 1)
                        DOut_zd[7:0] = 16'h7E;
                    else if (Addr == 2)
                    begin
                        DOut_zd[7:1] = 0;
                        DOut_zd[0] = Sec_Prot[SecAddr];
                    end
                    else if (Addr == 3)
                    begin
                        DOut_zd[7:0] = 8;

                        if (FactoryProt)
                            DOut_zd[7] = 1'b1;
                    end
                    else if (Addr == 16'hE)
                        DOut_zd[7:0] = 16'h12;
                    else if (Addr == 16'hF)
                        DOut_zd[7:0] = 16'h00;
                end
            end

            PGMS :
            begin
                if (oe)
                begin
                    ///////////////////////////////////////////////////////////
                    //read status
                    ///////////////////////////////////////////////////////////
                    Status[6] = ~Status[6]; //toggle
                    Status[5] = 1'b0;
                    //Status[2) no toggle
                    Status[1] = 1'b0;
                    DOut_zd[7:0] = Status;
                    if (BYTENeg)
                        DOut_zd[15:8] = 8'b0;
                end
            end

            PSPS:
            begin
                if (oe)
                begin
                    ///////////////////////////////////////////////////////////
                    //read status / stil programming
                    ///////////////////////////////////////////////////////////
                    Status[6] = ~Status[6]; //toggle
                    Status[5] = 1'b0;
                    //Status[2) no toggle
                    Status[1] = 1'b0;

                    DOut_zd[7:0] = Status;
                    if (BYTENeg)
                        DOut_zd[15:8] = 8'b0;
                 end
            end

            PSP:
            begin
                if (oe)
                begin
                    ///////////////////////////////////////////////////////////
                    //read  - program suspend
                    ///////////////////////////////////////////////////////////
                    if (SecAddr == SA)
                        //read program suspended sector
                        //Invalid (not allowed)

                  $display("Read from program suspended sector is NOT allowed");

                    else if (ESP_ACT && Ers_queue[SecAddr])
                    begin
                        Status[7] = 1'b1;
                        // Status[6) No toggle
                        Status[5] = 1'b0;
                        Status[2] = ~Status[2]; //toggle

                        DOut_zd[7:0] = Status;
                        if (BYTENeg)
                            DOut_zd[15:8] = 8'b0;
                    end
                    else
                    begin
                        //read sector other than program suspended one
                        DOut_zd[7:0] = READMEM(SecAddr, Address);

                        if (BYTENeg)
                            DOut_zd[15:8] = READMEM(SecAddr, Address+1);

                    end
                end
            end

            PSP_CFI_U:
            begin
                if (oe)
                begin
                    DOut_zd[15:0] = 16'b0;
                    if ((Addr>16'h10)&&(Addr<16'h50))
                    begin
                        if (~BYTENeg)
                            DOut_zd[15:8] = 8'bZ;
                        DOut_zd[7:0] = CFI_array[Addr];
                    end
                    else
                        $display("Invalid CFI query address");
                end
            end

            PSP_CFI:
            begin
                if (oe)
                begin
                    DOut_zd[15:0] = 16'b0;
                    if ((Addr>16'h10)&&(Addr<16'h50))
                    begin
                        if (~BYTENeg)
                            DOut_zd[15:8] = 8'bZ;
                        DOut_zd[7:0] = CFI_array[Addr];
                    end
                    else
                        $display("Invalid CFI query address");
                end
            end

            PSP_AS:
            begin
                if (oe)
                begin
                    if (BYTENeg)
                        if (Addr == 0)
                            DOut_zd[15:8] = 0;
                        else
                            DOut_zd[15:8] = 16'h22;
                    else
                        DOut_zd[15:8] = 8'bZ;

                    if (Addr == 0)
                        DOut_zd[7:0] = 1;
                    else if (Addr == 1)
                        DOut_zd[7:0] = 16'h7E;
                    else if (Addr == 2)
                    begin
                        DOut_zd[7:1] = 0;
                        DOut_zd[0] = Sec_Prot[SecAddr];
                    end
                    else if (Addr == 3)
                    begin
                        DOut_zd[7:0] = 8;

                        if (FactoryProt)
                            DOut_zd[7] = 1'b1;
                    end
                    else if (Addr == 16'hE)
                        DOut_zd[7:0] = 16'h12;
                    else if (Addr == 16'hF)
                        DOut_zd[7:0] = 16'h00;
                end
            end
        endcase
        end
    end

    always @(negedge write or reseted)
    begin : Output_generation

        if (reseted)
        begin
        case (current_state)
            RESET :
            begin
                OTP_ACT   = 1'b0;
                PSP_ACT   = 1'b0;
                ESP_ACT   = 1'b0;

                if (~write)
                begin
                    if (PATTERN_1)
                    begin
                    end
                    else if ((Addr==16'h55) && (DataLo==16'h98))
                        ULBYPASS = 1'b0;
                end
                //ready signal active
                RY_zd = 1'b1;
            end

            Z001 :
            begin
            end

            PREL_SETBWB :
            begin
                if (~write)
                begin
                    if (A_PAT_1 && (DataLo==16'h20))
                        ULBYPASS = 1'b1;
                    else if (A_PAT_1 && (DataLo==16'h90))
                        ULBYPASS = 1'b0;
                    else if (A_PAT_1 && (DataLo==16'h88))
                    begin
                        ULBYPASS = 1'b0;
                        OTP_ACT  = 1'b1;
                    end
                    else if (DataLo==16'h25)
                        //fix Sector Address SA
                        SA = SecAddr;
                end
            end

            PREL_ULBYPASS :
            begin
                if (~write)
                begin
                    if (DataLo==16'h20)
                        ULBYPASS = 1'b1;
                    else if (DataLo==16'h98)
                        ULBYPASS = 1'b0;
                    else if (A_PAT_1 && (DataLo==16'h90))
                        ULBYPASS = 1'b0;
                    else if (A_PAT_1 && (DataLo==16'h88))
                    begin
                        ULBYPASS = 1'b0;
                        OTP_ACT  = 1'b1;
                    end
                    else if (DataLo==16'h25)
                        //fix Sector Address  SA
                        SA = SecAddr;
                end

                //ready signal active
                RY_zd = 1'b1;
            end

            CFI_U :
            begin
                if (~write)
                begin
                    if (DataLo==16'h98)
                    begin
                    end
                    else if (DataLo==16'hF0)
                    begin
                        ULBYPASS = 1'b0;
                        OTP_ACT  = 1'b0;
                        PSP_ACT  = 1'b0;
                        ESP_ACT  = 1'b0;
                    end
                end
            end

            CFI :
            begin
                if (~write)
                    if ((Addr==16'h55) && (DataLo==16'h98))
                    begin
                    end
                    else if (DataLo==16'hF0)
                        ULBYPASS  = 1'b0;
            end

            AS :
            begin
                if (~write)
                    if (DataLo==16'hF0)
                        ULBYPASS  = 1'b0;
            end

            A0SEEN :
            begin
                if (~write)
                begin
                    PSTART = 1'b1;
                    PSTART <= #1 1'b0;
                    PSUSP  = 1'b0;
                    PRES   = 1'b0;
                    PCNT   = 32;

                    WBData[0] = -1;
                    WBData[1] = -1;

                    if (~Viol)
                    begin
                        WBData[0] = DataLo;
                        WBData[1] = DataHi;
                    end
                    WBAddr[0] = Address % 32;
                    WBPage = WPage;
                    SA = SecAddr;
                    temp = DataLo;
                    Status[7] = ~temp[7];

                    if (BYTENeg)
                        WBAddr[1] = WBAddr[0] +1;
                    else
                        WBAddr[1] = -1;
                end
            end

            OTP :
            begin
                OTP_ACT = 1'b1;
                //ready signal active
                RY_zd = 1'b1;
            end

            OTP_Z001 :
            begin
            end

            OTP_PREL :
            begin
                if (~write)
                begin
                    if (A_PAT_1 && (DataLo == 16'h90))
                        ULBYPASS = 1'b0;
                    else if (DataLo == 16'h25)
                    begin
                        //fix Sector Address  SA
                        SA = 0;
                        if (SecAddr!=0)
                            $display("Invalid sector address in SecSi mode");
                        //activate OTP
                        OTP_ACT = 1'b1;
                    end
                end
            end

            OTP_AS :
            begin
                if (~write)
                begin
                    if (DataLo==16'hF0)
                    begin
                        OTP_ACT =1'b0;
                        if (PSP_ACT)
                        begin
                        end
                        else
                            ULBYPASS  = 1'b0;
                    end
                end
            end

            OTP_A0SEEN :
            begin
                if (~write)
                begin
                    OTP_ACT = 1'b1;
                    ///////////////////////////////////////////////////////////
                    //SecSi programming: TBD
                    ///////////////////////////////////////////////////////////
                    PSTART = 1'b1;
                    PSTART <= #1 1'b0;

                    PSUSP  = 1'b0;
                    PRES   = 1'b0;
                    PCNT   = 32;
                    WBData[0] = -1;
                    WBData[1] = -1;

                    if (~Viol)
                    begin
                        WBData[0] = DataLo;
                        WBData[1] = DataHi;
                    end
                    WBAddr[0] = Address % 32;
                    WBPage = WPage % 8;

                    SA = 0;
                    if (SecAddr != 0)
                        $display("Invalid sector Address in SecSi");

                    if (Address >= 256)
                    begin
                        $display("Invalid program address in SecSi region. ");
                        $display("Adress= %d", Address);
                    end
                    temp = DataLo;
                    Status[7] = ~temp[7];

                    if (BYTENeg)
                        WBAddr[1] = WBAddr[0] +1;
                    else
                        WBAddr[1] = -1;
                end
            end

            C8 :
            begin
                if (~write)
                    if (PATTERN_1)
                    begin
                    end
                    else if (DataLo==16'h25)
                        //fix Sector Address  SA
                        SA = SecAddr;
                    else
                        ULBYPASS  = 1'b0;
            end

            C8_Z001 :
            begin
                if (~write)
                    if (PATTERN_2)
                    begin
                    end
                    else if (DataLo==16'h25)
                        //fix Sector Address  SA
                        SA = SecAddr;
            end

            C8_PREL :
            begin
                if (~write)
                    if (A_PAT_1 && (DataLo==16'h10))
                    begin
                        //Start Chip Erase
                        ESTART = 1'b1;
                        ESTART <= #1 1'b0;
                        ESUSP  = 1'b0;
                        ERES   = 1'b0;
                        Ers_queue = ~(0);
                        Status = 8'b00001000;
                    end
                    else if (DataLo==16'h30)
                    begin
                        //put selected sector to sec. ers. queue
                        //start timeout
                        Ers_queue = 0;
                        Ers_queue[SecAddr] = 1'b1;
                        disable TCTMOUTr;
                        CTMOUT_in = 1'b0;
                        #1 CTMOUT_in <= 1'b1;
                    end
            end

            ERS :
            begin
            end

            SERS :
            begin
            if (~write)
            begin
                if (~CTMOUT)
                begin
                    if (DataLo == 16'hB0)
                    begin
                        //need to start erase process prior to suspend
                        ESTART = 1'b1;
                        ESTART <= #1 1'b0;
                        ESUSP = 1'b1;
                        ESUSP <= #1 1'b0;
                        ERES   = 1'b0;
                    end
                    else if (DataLo==16'h30)
                    begin
                        disable TCTMOUTr;
                        CTMOUT_in = 1'b0;
                        #1 CTMOUT_in <= 1'b1;
                        Ers_queue[SecAddr] = 1'b1;
                    end
                end
            end
                //ready signal active
                RY_zd = 1'b1;
            end

            SERS_EXEC :
            begin
                if (~write)
                    if (~EDONE && (EERR!=1'b1))
                        if (DataLo==16'hB0)
                        begin
                            START_T1_in = 1'b1;
                            ESUSP = 1'b1;
                            RY_zd = 1'b0;
                        end
            end

            WBPGMS_WBCNT :
            begin
                if (~write)
                    if ((SecAddr == SA) &&
                       ((~BYTENeg && DataLo<32) ||
                        (BYTENeg && DataLo<16)))
                    begin
                        cnt = DataLo;
                        if (BYTENeg)
                            cnt = cnt *2;
                        PCNT = cnt;
                        LCNT = cnt;
                    end
            end

            WBPGMS_WBLSTA :
            begin
                if (~write)
                begin
                    if(SecAddr == SA)   // fix WriteBufferPage  WBPage
                    begin

                        WBData[cnt] = -1;
                        if (~Viol)
                            WBData[cnt] = DataLo;

                        WBAddr[cnt] = Address % 32;
                        if (BYTENeg)
                        begin

                            WBData[cnt+1] = -1;
                            if (~Viol)
                                WBData[cnt+1] = DataHi;

                            WBAddr[cnt+1] = (Address % 32) +1;
                            if (cnt>0)
                                cnt = cnt -1;
                        end

                        if (cnt>0)
                            cnt = cnt -1;
                        //save last loaded data for data polling
                        temp = DataLo;
                        Status[7] = ~temp[7];

                        if (OTP_ACT)
                        begin
                            WBPage = WPage % 8;
                            if (WPage>=8)
                            begin
                                $display("Invalid Write Buffer Page ");
                                $display("selected in SecSi");
                            end
                        end
                        else
                            WBPage = WPage;
                    end

                    LCNT = cnt;
                end
            end

            WBPGMS_WBLOAD :
            begin
                if (~write)
                begin
                    if (WPage == WBPage)
                    begin

                        WBData[cnt] = -1;
                        if (~Viol)
                            WBData[cnt] = DataLo;

                        WBAddr[cnt] = Address % 32;
                        if (BYTENeg)
                        begin

                            WBData[cnt+1] = -1;
                            if (~Viol)
                                WBData[cnt+1] = DataHi;

                            WBAddr[cnt+1] = (Address % 32) +1;
                            if (cnt>0)
                                cnt = cnt -1;
                        end

                        if (cnt>0)
                            cnt = cnt -1;
                        //save last loaded data for data polling
                        temp = DataLo;
                        Status[7] = ~temp[7];
                    end

                    LCNT = cnt;
                end
            end

            WBPGMS_CONFB :
            begin
                if (~write)
                    if ((SecAddr == SA) && (DataLo == 16'h29))
                    begin
                        PSTART = 1'b1;
                        PSTART <= #1 1'b0;

                        PSUSP  = 1'b0;
                        PRES   = 1'b0;
                    end
            end

            WBPGMS_WBABORT :
            begin
                //busy signal active
                RY_zd = 1'b0;
            end

            WBPGMS_Z001 :
            begin
            end

            WBPGMS_PREL :
            begin
                if (~write)
                    if (DataLo == 16'hF0)
                    begin
                        PSP_ACT = 1'b0;
                    end
            end

            ESP :
            begin
                if (~write)
                begin
                    if (DataLo == 16'h30)
                    begin
                        //resume erase
                        ERES = 1'b1;
                        ERES <= #1 1'b0;
                    end
                    else if (ULBYPASS)
                    begin
                        if (DataLo == 16'h20)
                        begin
                        end
                        else if (DataLo == 16'h25)
                        begin
                            //fix SA
                            SA = SecAddr;
                            ESP_ACT = 1'b1;
                        end
                        else if (A_PAT_1 && (DataLo == 16'h88))
                            ESP_ACT = 1'b1;
                    end
                end
                //ready signal active
                RY_zd = 1'b1;
            end

            ESP_Z001 :
            begin
            end

            ESP_PREL :
            begin
                if (~write)
                begin
                    if (A_PAT_1 && (DataLo == 16'h20))
                        ULBYPASS = 1'b1;
                    else if (DataLo == 16'h25)
                    begin
                        //fix SA
                        SA = SecAddr;
                        ESP_ACT = 1'b1;
                    end
                    else if (A_PAT_1 && (DataLo == 16'h88))
                        ESP_ACT = 1'b1;
                end
            end

            ESP_CFI_U :
            begin
                //reset ULBYPASS
                if (~write)
                    if (DataLo == 16'h98)
                    begin
                    end
                    else if (DataLo == 16'hF0)
                        ESP_ACT = 1'b1;
            end

            ESP_CFI :
            begin
                if (~write)
                begin
                    if ((Addr == 16'h55) && (DataLo == 16'h98))
                    begin
                    end
                    else if (DataLo == 16'hF0)
                        ESP_ACT = 1'b1;
                    else if (DataLo == 16'h30)
                    begin
                        ERES = 1'b1;
                        ERES <= #1 1'b0;
                    end
                    else
                        ESP_ACT = 1'b1;
                end
            end

            ESP_A0SEEN :
            begin
                if (~write)
                begin
                    ESP_ACT = 1'b1;

                    PSTART = 1'b1;
                    PSTART <= #1 1'b0;

                    PRES   = 1'b0;
                    PSUSP  = 1'b0;
                    PCNT   = 32;

                    WBData[0] = -1;
                    WBData[1] = -1;

                    if (~Viol)
                    begin
                        WBData[0] = DataLo;
                        WBData[1] = DataHi;
                    end
                    WBData[0] = DataLo;
                    WBData[1] = DataHi;
                    WBAddr[0] = Address % 32;
                    WBPage = WPage;
                    SA = SecAddr;

                    temp = DataLo;
                    Status[7] = ~temp[7];

                    if (BYTENeg)
                        WBAddr[1] = WBAddr[0] +1;
                    else
                        WBAddr[1] = -1;
                end
            end

            ESP_AS :
            begin
                if (~write)
                    if (DataLo == 16'hF0)
                        // reset ULBYPASS
                        ULBYPASS = 1'b0;
            end

            PGMS :
            begin
                if (~write)
                    if (~PDONE)
                        if (DataLo == 16'hB0)
                        begin
                        START_T1_in = 1'b1;
                        end
                //busy signal active
                RY_zd = 1'b0;
            end

            PSPS:
            begin
            end

            PSP :
            begin
                if (~write)
                    if (DataLo == 16'h30)
                    begin
                        PRES = 1'b1;
                        PRES <= #1 1'b0;
                    end
                //ready signal active
                RY_zd = 1'b1;
            end

            PSP_CFI_U :
            begin
                //reset ULBYPASS
                ULBYPASS = 1'b0;
            end

            PSP_CFI :
            begin
            end

            PSP_Z001 :
            begin
            end

            PSP_PREL :
            begin
                if (~write)
                    if (A_PAT_1 && (DataLo == 16'h90))
                    begin
                    end
                    else if (A_PAT_1 && (DataLo == 16'h88))
                        PSP_ACT = 1'b1;
            end

            PSP_AS :
            begin
                if (~write)
                    if (DataLo == 16'hF0)
                        // reset ULBYPASS
                        ULBYPASS = 1'b0;
            end

        endcase
        end
    end

    always @(current_state or reseted)
    begin
        if (reseted)
            if (current_state==RESET) RY_zd = 1'b1;
            if (current_state==PREL_ULBYPASS) RY_zd = 1'b1;
            if (current_state==WBPGMS_WBABORT) RY_zd = 1'b0;
            if (current_state==ESP) RY_zd = 1'b1;
            if (current_state==ESP_CFI_U)  ULBYPASS = 1'b0;
            if (current_state==SERS_EXEC) RY_zd = 1'b0;
            if (current_state==PSP) RY_zd = 1'b1;
            if (current_state==PGMS) RY_zd = 1'b0;
            if (current_state==PSPS) RY_zd = 1'b0;
            if (current_state==OTP) RY_zd = 1'b1;
            if (current_state==ESPS) RY_zd = 1'b0;
    end

    always @(EERR or EDONE or current_state)
    begin : ERS2
    integer i;
    integer j;
        if (current_state==ERS)
        begin
            if (EERR!=1'b1)
                for (i=0;i<=SecNum;i=i+1)
                begin
                    if (Sec_Prot[i]!=1'b1)
                        for (j=0;j<=SecSize;j=j+1)
                            Mem[i*(SecSize+1)+j] = -1;
                end
                if (EDONE)
                for (i=0;i<=SecNum;i=i+1)
                begin
                    if (Sec_Prot[i]!=1'b1)
                        for (j=0;j<=SecSize;j=j+1)
                            Mem[i*(SecSize+1)+j] = MaxData;
                end
           // busy signal active
           RY_zd = 1'b0;
        end
    end

    always @(CTMOUT or current_state)
    begin : SERS2
        if (current_state==SERS)
            if (CTMOUT)
            begin
                CTMOUT_in = 1'b0;
                START_T1_in = 1'b0;
                ESTART = 1'b1;
                ESTART <= #1 1'b0;
                ESUSP  = 1'b0;
                ERES   = 1'b0;
                //ready signal active
                RY_zd = 1'b1;
            end
    end

    always @(START_T1 or current_state)
    begin : ESPS2
        if (current_state==ESPS)
            if (START_T1)
            begin
                ESP_ACT = 1'b1;
                START_T1_in = 1'b0;
                ESUSP = 1'b0;
                RY_zd = 1'b0;
            end
    end

    always @(current_state or EERR or EDONE)
    begin: SERS_EXEC2
    integer i,j;
        if (current_state==SERS_EXEC)
            if (EERR!=1'b1)
            begin
                for (i=0;i<=SecNum;i=i+1)
                    if (Ers_queue[i] && (Sec_Prot[i]!=1'b1))
                        for (j=0;j<=SecSize;j=j+1)
                            Mem[i*(SecSize+1)+j] = -1;
                if (EDONE)
                    for (i=0;i<=SecNum;i=i+1)
                        if (Ers_queue[i] && (Sec_Prot[i]!=1'b1))
                            for (j=0;j<=SecSize;j=j+1)
                                Mem[i*(SecSize+1)+j] = MaxData;
                //busy signal active
                RY_zd = 1'b0;
           end
    end

    always @(current_state or posedge PDONE)
    begin: PGMS2
    integer i,j;
        if (current_state==PGMS)
        begin
           //busy signal active
            RY_zd = 1'b0;
            if (PERR!=1'b1)
            begin
                BaseLoc = WBPage * 32;

                if (PCNT < 32)   //buffer
                begin
                    wr_cnt = PCNT;
                    if (BYTENeg)
                        wr_cnt= wr_cnt+1;
                end
                else   //Word/Byte program
                begin
                    if (WBAddr[1] < 0 )
                        wr_cnt = 0;
                    else
                        wr_cnt = 1;
                end
                for (i=wr_cnt;i>=0;i=i-1)
                begin
                    new_int= WBData[i];
                    if (OTP_ACT!=1'b1)   //mem write
                        old_int=Mem[SA*(SecSize+1)+BaseLoc+WBAddr[i]];
                    else
                        old_int=SecSi[BaseLoc+WBAddr[i]];

                    if (new_int>-1)
                    begin
                        new_bit = new_int;
                        if (old_int>-1)
                        begin
                            old_bit = old_int;
                            for(j=0;j<=7;j=j+1)
                                if (~old_bit[j])
                                    new_bit[j]=1'b0;
                            new_int=new_bit;
                        end

                        WBData[i]= new_int;
                    end
                    else
                        WBData[i]= -1;
                end
                for (i=wr_cnt;i>=0;i=i-1)
                begin
                    if (OTP_ACT!=1'b1)   //mem write
                        Mem[SA*(SecSize+1)+BaseLoc+WBAddr[i]] = -1;
                    else
                        SecSi[BaseLoc+WBAddr[i]]   = -1;

                end

                if (PDONE && ~PSTART)
                for (i=wr_cnt;i>=0;i=i-1)
                    begin
                        if (WBAddr[i]> -1)
                            if (OTP_ACT!=1'b1)   //mem write
                              Mem[SA*(SecSize+1)+BaseLoc+WBAddr[i]] = WBData[i];
                            else //SecSi write
                              SecSi[BaseLoc+WBAddr[i]]   = WBData[i];
                        else                                      //
                            $display("WriteBuffer Address error");
                        WBData[i]= -1;
                    end
            end
        end
    end

    always @(current_state or START_T1)
    begin: PSPS2
        if (current_state==PSPS)
        begin
            if (START_T1)
            begin
                START_T1_in = 1'b0;
                PSUSP = 1'b0;
            end
            //busy signal active
            RY_zd = 1'b0;
        end
    end

    //Output timing control
    always @(DOut_zd)
    begin : OutputGen
        if (DOut_zd[0] !== 1'bz)
        begin
            CEDQ_t = CENeg_event  + CEDQ_01;
            OEDQ_t = OENeg_event  + OEDQ_01;
            if (RPchange)
                ADDRDQ_t = ADDR_event + ADDRDQ_01_LONG;
            else
                ADDRDQ_t = ADDR_event + ADDRDQ_01_SHORT;
            FROMCE = ((CEDQ_t >= OEDQ_t) && ( CEDQ_t >= $time));
            FROMOE = ((OEDQ_t >= CEDQ_t) && ( OEDQ_t >= $time));
            FROMADDR = 1'b1;
            if ((ADDRDQ_t > $time )&&
             (((ADDRDQ_t>OEDQ_t)&&FROMOE) ||
              ((ADDRDQ_t>CEDQ_t)&&FROMCE)))
            begin
                TempData = DOut_zd;
                FROMADDR = 1'b0;
                if (~BYTENeg)
                    DOut_Pass[15:8] = 8'bz;
                else
                    DOut_Pass[15:8] = 8'bx;
                DOut_Pass[7:0] = 8'bx;
                DOut_Pass <= #( ADDRDQ_t - $time ) TempData;
            end
            else
            begin
                DOut_Pass = DOut_zd;
            end
        end
    end

    always @(DOut_zd)
    begin
        if (DOut_zd[0] === 1'bz)
        begin
            disable OutputGen;
            FROMCE = 1'b1;
            FROMOE = 1'b1;
            FROMADDR = 1'b0;
            DOut_Pass = DOut_zd;
        end
    end

    always @(gOE_n or RESETNeg or RST or BYTENeg or gCE_n)
    begin
        //Output Disable Control
        if (gOE_n || gCE_n || (~RESETNeg && ~RST))
            DOut_zd = 16'bZ;
        else
            if (~BYTENeg)
                DOut_zd[15:8] = 8'bZ;
    end

    always @(WPNeg)
    begin
        //Hardware Write Protection
        if (~WPNeg)
        begin
            Sec_Prot_reg = Sec_Prot[ProtSecNum];
            Sec_Prot[ProtSecNum] = 1'b1;
        end
        else
            Sec_Prot[ProtSecNum] = Sec_Prot_reg;
    end

    initial
    begin : InitCFI
        ///////////////////////////////////////////////////////////////////////
        //CFI array data
        ///////////////////////////////////////////////////////////////////////

        //CFI query identification string
        CFI_array[16'h10] = 16'h51;
        CFI_array[16'h11] = 16'h52;
        CFI_array[16'h12] = 16'h59;
        CFI_array[16'h13] = 16'h02;
        CFI_array[16'h14] = 16'h00;
        CFI_array[16'h15] = 16'h40;
        CFI_array[16'h16] = 16'h00;
        CFI_array[16'h17] = 16'h00;
        CFI_array[16'h18] = 16'h00;
        CFI_array[16'h19] = 16'h00;
        CFI_array[16'h1A] = 16'h00;
        //system interface string
        CFI_array[16'h1B] = 16'h27;
        CFI_array[16'h1C] = 16'h36;
        CFI_array[16'h1D] = 16'h00;
        CFI_array[16'h1E] = 16'h00;
        CFI_array[16'h1F] = 16'h07;
        CFI_array[16'h20] = 16'h07;
        CFI_array[16'h21] = 16'h0A;
        CFI_array[16'h22] = 16'h00;
        CFI_array[16'h23] = 16'h01;
        CFI_array[16'h24] = 16'h05;
        CFI_array[16'h25] = 16'h04;
        CFI_array[16'h26] = 16'h00;
        //device geometry definition
        CFI_array[16'h27] = 16'h17;
        CFI_array[16'h28] = 16'h02;
        CFI_array[16'h29] = 16'h00;
        CFI_array[16'h2A] = 16'h05;
        CFI_array[16'h2B] = 16'h00;
        CFI_array[16'h2C] = 16'h01;
        CFI_array[16'h2D] = 16'hFF;
        CFI_array[16'h2E] = 16'h00;
        CFI_array[16'h2F] = 16'h00;
        CFI_array[16'h30] = 16'h01;
        CFI_array[16'h31] = 16'h00;
        CFI_array[16'h32] = 16'h00;
        CFI_array[16'h33] = 16'h00;
        CFI_array[16'h34] = 16'h00;
        CFI_array[16'h35] = 16'h00;
        CFI_array[16'h36] = 16'h00;
        CFI_array[16'h37] = 16'h00;
        CFI_array[16'h38] = 16'h00;
        CFI_array[16'h39] = 16'h00;
        CFI_array[16'h3A] = 16'h00;
        CFI_array[16'h3B] = 16'h00;
        CFI_array[16'h3C] = 16'h00;
        //primary vendor-specific extended query
        CFI_array[16'h40] = 16'h50;
        CFI_array[16'h41] = 16'h52;
        CFI_array[16'h42] = 16'h49;
        CFI_array[16'h43] = 16'h31;
        CFI_array[16'h44] = 16'h33;
        CFI_array[16'h45] = 16'h08;
        CFI_array[16'h46] = 16'h02;
        CFI_array[16'h47] = 16'h01;
        CFI_array[16'h48] = 16'h01;
        CFI_array[16'h49] = 16'h04;
        CFI_array[16'h4A] = 16'h00;
        CFI_array[16'h4B] = 16'h00;
        CFI_array[16'h4C] = 16'h01;
        CFI_array[16'h4D] = 16'hB5;
        CFI_array[16'h4E] = 16'hC5;
        CFI_array[16'h4F] = 16'h04; //uniform sectors bottom protect
        CFI_array[16'h50] = 16'h01;

    end

    function[7:0] READMEM;
    input sector;
    input Address;
    integer sector;
    integer Address;
    integer AddrBASE;
    integer Data;
    begin

        AddrBASE  = sector * 20'h10000;

        Data = Mem[AddrBASE + Address];

        if ( Data == -1 )
            READMEM = 8'bx;
        else
            READMEM = Data;
    end
    endfunction

    reg  BuffInOE, BuffInCE, BuffInADDR_S, BuffInADDR_L;
    wire BuffOutOE, BuffOutCE, BuffOutADDR_S, BuffOutADDR_L;

    BUFFER    BUFOE   (BuffOutOE, BuffInOE);
    BUFFER    BUFCE   (BuffOutCE, BuffInCE);
    BUFFER    BUFADDR_SHORT (BuffOutADDR_S, BuffInADDR_S);
    BUFFER    BUFADDR_LONG  (BuffOutADDR_L, BuffInADDR_L);
    initial
    begin
        BuffInOE   = 1'b1;
        BuffInCE   = 1'b1;
        BuffInADDR_S = 1'b1;
        BuffInADDR_L = 1'b1;
    end

    always @(posedge BuffOutOE)
    begin
        OEDQ_01 = $time;
    end
    always @(posedge BuffOutCE)
    begin
        CEDQ_01 = $time;
    end
    always @(posedge BuffOutADDR_S)
    begin
        ADDRDQ_01_SHORT = $time;
    end
    always @(posedge BuffOutADDR_L)
    begin
        ADDRDQ_01_LONG = $time;
    end
endmodule

module BUFFER (OUT,IN);
    input IN;
    output OUT;
    buf   ( OUT, IN);
endmodule
