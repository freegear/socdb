library verilog;
use verilog.vl_types.all;
entity Reset_Controller is
    port(
        HCLK            : in     vl_logic;
        nPOReset        : in     vl_logic;
        WDOGRES         : in     vl_logic;
        HRESETn         : out    vl_logic;
        WDOGRESn        : out    vl_logic
    );
end Reset_Controller;
