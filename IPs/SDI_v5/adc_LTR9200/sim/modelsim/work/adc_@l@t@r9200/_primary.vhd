library verilog;
use verilog.vl_types.all;
entity adc_LTR9200 is
    generic(
        Cycle_Time      : integer := 16;
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
        SHDN            : in     vl_logic;
        AD_CLK          : in     vl_logic;
        RST             : in     vl_logic;
        ASEL            : in     vl_logic_vector;
        SOC             : in     vl_logic;
        EOC             : out    vl_logic;
        DOUT            : out    vl_logic_vector;
        AVDD            : in     vl_logic;
        DVDD            : in     vl_logic;
        CH0             : in     vl_logic;
        CH1             : in     vl_logic;
        CH2             : in     vl_logic;
        CH3             : in     vl_logic;
        CH4             : in     vl_logic;
        CH5             : in     vl_logic;
        CH6             : in     vl_logic;
        CH7             : in     vl_logic;
        DIFF            : in     vl_logic;
        AVSS            : in     vl_logic;
        DVSS            : in     vl_logic
    );
end adc_LTR9200;
