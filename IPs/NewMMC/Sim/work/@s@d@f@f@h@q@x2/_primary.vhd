library verilog;
use verilog.vl_types.all;
entity sdffhqx2 is
    port(
        q               : out    vl_logic;
        d               : in     vl_logic;
        si              : in     vl_logic;
        se              : in     vl_logic;
        ck              : in     vl_logic
    );
end sdffhqx2;
