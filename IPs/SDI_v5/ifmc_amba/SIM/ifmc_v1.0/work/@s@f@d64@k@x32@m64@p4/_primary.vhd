library verilog;
use verilog.vl_types.all;
entity SFD64KX32M64P4 is
    generic(
        numAddrX        : integer := 10;
        numAddrY        : integer := 6;
        numTM           : integer := 3;
        numOut          : integer := 32
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
end SFD64KX32M64P4;
