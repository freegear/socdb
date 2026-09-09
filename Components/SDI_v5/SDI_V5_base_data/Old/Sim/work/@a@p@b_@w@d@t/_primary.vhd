library verilog;
use verilog.vl_types.all;
entity APB_WDT is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(7 downto 2);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        WDOGRESn        : in     vl_logic;
        WDOGINT         : out    vl_logic;
        WDOGRES         : out    vl_logic;
        SCANENABLE      : in     vl_logic;
        SCANINPCLK      : in     vl_logic;
        SCANOUTPCLK     : out    vl_logic
    );
end APB_WDT;
