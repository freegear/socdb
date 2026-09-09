library verilog;
use verilog.vl_types.all;
entity PDXO03DG is
    port(
        XIN             : in     vl_logic;
        XOUT            : out    vl_logic;
        XC              : out    vl_logic
    );
end PDXO03DG;
