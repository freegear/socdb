library verilog;
use verilog.vl_types.all;
entity APB_ADC_Ctrl is
    generic(
        Cycle_Count     : integer := 5;
        ADCDAT_Bit      : integer := 10
    );
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(11 downto 2);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        ADC_Flag        : in     vl_logic;
        STBY            : out    vl_logic;
        AD_Data         : in     vl_logic_vector;
        ADC_CKIN        : in     vl_logic;
        AIN_SEL         : out    vl_logic_vector(2 downto 0);
        STC_O           : out    vl_logic;
        SCANENABLE      : in     vl_logic;
        SCANINPCLK      : in     vl_logic;
        SCANOUTPCLK     : out    vl_logic
    );
end APB_ADC_Ctrl;
