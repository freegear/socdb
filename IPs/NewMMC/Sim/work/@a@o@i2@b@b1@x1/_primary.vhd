library verilog;
use verilog.vl_types.all;
entity aoi2bb1x1 is
    port(
        y               : out    vl_logic;
        a0n             : in     vl_logic;
        a1n             : in     vl_logic;
        b0              : in     vl_logic
    );
end aoi2bb1x1;
