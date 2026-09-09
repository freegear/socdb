library verilog;
use verilog.vl_types.all;
entity laclq2 is
    port(
        en              : in     vl_logic;
        d               : in     vl_logic;
        cdn             : in     vl_logic;
        q               : out    vl_logic
    );
end laclq2;
