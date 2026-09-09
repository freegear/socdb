library verilog;
use verilog.vl_types.all;
entity dmacrevand is
    port(
        tieoff1         : in     vl_logic;
        tieoff2         : in     vl_logic;
        revision        : out    vl_logic
    );
end dmacrevand;
