library verilog;
use verilog.vl_types.all;
entity RevAnd is
    port(
        TieOff1         : in     vl_logic;
        TieOff2         : in     vl_logic;
        Revision        : out    vl_logic
    );
end RevAnd;
