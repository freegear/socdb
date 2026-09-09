library verilog;
use verilog.vl_types.all;
entity oa21x4 is
    port(
        y               : out    vl_logic;
        a0              : in     vl_logic;
        a1              : in     vl_logic;
        b0              : in     vl_logic
    );
end oa21x4;
