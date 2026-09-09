library verilog;
use verilog.vl_types.all;
entity mxi4x1 is
    port(
        y               : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        c               : in     vl_logic;
        d               : in     vl_logic;
        s0              : in     vl_logic;
        s1              : in     vl_logic
    );
end mxi4x1;
