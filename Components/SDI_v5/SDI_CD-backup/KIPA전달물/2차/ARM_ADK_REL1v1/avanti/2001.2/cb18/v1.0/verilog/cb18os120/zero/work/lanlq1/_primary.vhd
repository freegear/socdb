library verilog;
use verilog.vl_types.all;
entity lanlq1 is
    port(
        en              : in     vl_logic;
        d               : in     vl_logic;
        q               : out    vl_logic
    );
end lanlq1;
