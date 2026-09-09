library verilog;
use verilog.vl_types.all;
entity dffhqx4 is
    port(
        q               : out    vl_logic;
        d               : in     vl_logic;
        ck              : in     vl_logic
    );
end dffhqx4;
