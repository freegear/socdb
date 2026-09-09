library verilog;
use verilog.vl_types.all;
entity ClockResetGen is
    generic(
        CPU2BUSClockRatio: integer := 1;
        BUS2APBClockRatio: integer := 2;
        ClockDelay      : real    := 0.500000;
        CombDelay       : integer := 1
    );
    port(
        Clock_i         : in     vl_logic;
        Reset_i         : in     vl_logic;
        DDRClk          : out    vl_logic;
        nDDRClk         : out    vl_logic;
        CPUClk          : out    vl_logic;
        BUSClk          : out    vl_logic;
        nBUSClk         : out    vl_logic;
        APBClk          : out    vl_logic;
        BUSClkEn        : out    vl_logic;
        PCLKEn          : out    vl_logic;
        RESET_o         : out    vl_logic
    );
end ClockResetGen;
