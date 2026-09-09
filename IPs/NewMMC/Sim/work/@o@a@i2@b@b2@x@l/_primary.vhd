library verilog;
use verilog.vl_types.all;
entity oai2bb2xl is
    port(
        y               : out    vl_logic;
        a0n             : in     vl_logic;
        a1n             : in     vl_logic;
        b0              : in     vl_logic;
        b1              : in     vl_logic
    );
end oai2bb2xl;
