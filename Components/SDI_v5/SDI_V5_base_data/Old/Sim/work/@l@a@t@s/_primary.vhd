library verilog;
use verilog.vl_types.all;
entity LATS is
    port(
        CLOCK           : in     vl_logic;
        DATAIN          : in     vl_logic;
        ASETn           : in     vl_logic;
        DATAOUT         : out    vl_logic
    );
end LATS;
