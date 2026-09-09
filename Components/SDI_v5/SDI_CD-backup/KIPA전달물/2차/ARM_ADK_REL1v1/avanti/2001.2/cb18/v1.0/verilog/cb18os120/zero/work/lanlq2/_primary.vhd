library verilog;
use verilog.vl_types.all;
entity lanlq2 is
    port(
        en              : in     vl_logic;
        d               : in     vl_logic;
        q               : out    vl_logic
    );
end lanlq2;
