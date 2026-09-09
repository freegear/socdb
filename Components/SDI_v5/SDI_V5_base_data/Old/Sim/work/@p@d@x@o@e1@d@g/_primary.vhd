library verilog;
use verilog.vl_types.all;
entity PDXOE1DG is
    port(
        XC              : out    vl_logic;
        XOUT            : out    vl_logic;
        XIN             : in     vl_logic;
        E               : in     vl_logic
    );
end PDXOE1DG;
