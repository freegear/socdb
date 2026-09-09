library verilog;
use verilog.vl_types.all;
entity AD_Conv10 is
    generic(
        Cycle_Time      : integer := 5;
        AIN_Bit         : integer := 8;
        DOU_Bit         : integer := 10;
        Ch_Sel          : integer := 3;
        A0              : integer := 0;
        A1              : integer := 1;
        A2              : integer := 2;
        A3              : integer := 3;
        A4              : integer := 4;
        A5              : integer := 5;
        A6              : integer := 6;
        A7              : integer := 7
    );
    port(
        STBY            : in     vl_logic;
        AIN             : in     vl_logic_vector;
        AD_CLK          : in     vl_logic;
        ASEL            : in     vl_logic_vector;
        STC             : in     vl_logic;
        EOC             : out    vl_logic;
        AD_OUT          : out    vl_logic_vector
    );
end AD_Conv10;
