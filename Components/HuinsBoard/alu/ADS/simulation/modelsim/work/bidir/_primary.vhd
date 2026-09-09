library verilog;
use verilog.vl_types.all;
entity bidir is
    port(
        datain          : in     vl_logic;
        dataout         : out    vl_logic;
        oe              : in     vl_logic;
        dataio          : inout  vl_logic
    );
end bidir;
