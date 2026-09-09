library verilog;
use verilog.vl_types.all;
entity PDXO02DG is
    port(
        XIN             : in     vl_logic;
        XOUT            : out    vl_logic;
        XC              : out    vl_logic
    );
end PDXO02DG;
