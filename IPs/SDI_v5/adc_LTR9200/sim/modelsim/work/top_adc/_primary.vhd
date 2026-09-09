library verilog;
use verilog.vl_types.all;
entity top_adc is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(3 downto 2);
        PWDATA          : in     vl_logic_vector(15 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        INT_ADC         : out    vl_logic;
        CLK_ADCCLK      : in     vl_logic;
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
        DVSS            : in     vl_logic;
        SCANENABLE      : in     vl_logic;
        SCANINPCLK      : in     vl_logic;
        SCANOUTPCLK     : in     vl_logic
    );
end top_adc;
