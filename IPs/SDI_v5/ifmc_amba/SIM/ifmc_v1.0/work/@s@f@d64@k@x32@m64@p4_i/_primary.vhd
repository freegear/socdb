library verilog;
use verilog.vl_types.all;
entity SFD64KX32M64P4_i is
    generic(
        numAddrX        : integer := 10;
        numAddrXif      : integer := 3;
        numAddrY        : integer := 6;
        numTM           : integer := 3;
        numOut          : integer := 32;
        wordDepth       : integer := 65536;
        numRow          : integer := 1024;
        numErasePage    : integer := 2;
        numRow1         : integer := 8;
        wordDepth1      : integer := 512;
        numErasePage1   : integer := 2;
        Txa             : real    := 35.000000;
        Tya             : real    := 35.000000;
        Tnvs            : real    := 5000.000000;
        Tnvh            : real    := 5000.000000;
        Tnvh1           : real    := 100000.000000;
        Tpgs            : real    := 10000.000000;
        Tpgh            : real    := 20.000000;
        Tprog           : real    := 20000.000000;
        Tprogmax        : real    := 40000.000000;
        Tads            : real    := 20.000000;
        Tadh            : real    := 20.000000;
        Trcv            : real    := 1000.000000;
        Thv             : real    := 8000000.000000;
        Terase          : real    := 20000000.000000;
        Terasemax       : real    := 40000000.000000;
        Tme             : real    := 20000000.000000;
        Tmemax          : real    := 40000000.000000;
        Ttmr            : real    := 20.000000;
        Trses           : real    := 10.000000;
        Tseds           : real    := 10.000000;
        Tlds            : real    := 10.000000;
        Tlpw            : real    := 20.000000;
        Tldh            : real    := 10.000000;
        Tdseh           : real    := 10.000000;
        Tdh             : real    := 0.000000
    );
    port(
        XADR            : in     vl_logic_vector;
        YADR            : in     vl_logic_vector;
        DIN             : in     vl_logic_vector;
        DOUT            : out    vl_logic_vector;
        XE              : in     vl_logic;
        YE              : in     vl_logic;
        SE              : in     vl_logic;
        ERASE           : in     vl_logic;
        MAS1            : in     vl_logic;
        PROG            : in     vl_logic;
        NVSTR           : in     vl_logic;
        IFREN           : in     vl_logic;
        TMR             : in     vl_logic;
        VPP             : inout  vl_logic;
        TM              : inout  vl_logic_vector
    );
end SFD64KX32M64P4_i;
