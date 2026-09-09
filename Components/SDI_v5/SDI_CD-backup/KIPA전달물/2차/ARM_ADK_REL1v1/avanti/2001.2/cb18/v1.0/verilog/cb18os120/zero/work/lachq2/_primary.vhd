library verilog;
use verilog.vl_types.all;
entity lachq2 is
    port(
        e               : in     vl_logic;
        d               : in     vl_logic;
        cdn             : in     vl_logic;
        q               : out    vl_logic
    );
end lachq2;
