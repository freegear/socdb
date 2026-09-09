library verilog;
use verilog.vl_types.all;
entity mdffhqx1 is
    port(
        q               : out    vl_logic;
        d0              : in     vl_logic;
        d1              : in     vl_logic;
        s0              : in     vl_logic;
        ck              : in     vl_logic
    );
end mdffhqx1;
