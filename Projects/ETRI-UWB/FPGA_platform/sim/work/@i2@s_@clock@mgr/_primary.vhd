library verilog;
use verilog.vl_types.all;
entity I2S_ClockMgr is
    port(
        CLK             : in     vl_logic;
        RESETn          : in     vl_logic;
        LRCLK_I         : in     vl_logic;
        BCLK_I          : in     vl_logic;
        SDIN            : in     vl_logic;
        LeftStart       : out    vl_logic;
        RightStart      : out    vl_logic;
        BCLKRise        : out    vl_logic;
        BCLKFall        : out    vl_logic;
        SDInput         : out    vl_logic;
        LRCLK           : out    vl_logic;
        Master          : in     vl_logic;
        LRCLKInvert     : in     vl_logic
    );
end I2S_ClockMgr;
