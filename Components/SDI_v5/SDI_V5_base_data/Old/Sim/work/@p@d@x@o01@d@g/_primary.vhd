library verilog;
use verilog.vl_types.all;
entity PDXO01DG is
    port(
        XIN             : in     vl_logic;
        XOUT            : out    vl_logic;
        XC              : out    vl_logic
    );
end PDXO01DG;
