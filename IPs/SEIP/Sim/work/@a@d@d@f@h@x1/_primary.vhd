library verilog;
use verilog.vl_types.all;
entity ADDFHX1 is
    port(
        A               : in     vl_logic;
        B               : in     vl_logic;
        CI              : in     vl_logic;
        S               : out    vl_logic;
        CO              : out    vl_logic
    );
end ADDFHX1;
