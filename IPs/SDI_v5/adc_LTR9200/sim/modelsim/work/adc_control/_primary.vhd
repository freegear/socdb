library verilog;
use verilog.vl_types.all;
entity adc_control is
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
        SOC             : out    vl_logic;
        SEL             : out    vl_logic_vector(2 downto 0);
        SHDN            : out    vl_logic;
        EOC             : in     vl_logic;
        DOUT            : in     vl_logic_vector(9 downto 0);
        SCANENABLE      : in     vl_logic;
        SCANINPCLK      : in     vl_logic;
        SCANOUTPCLK     : in     vl_logic
    );
end adc_control;
