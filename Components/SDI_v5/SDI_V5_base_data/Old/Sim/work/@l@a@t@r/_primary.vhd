library verilog;
use verilog.vl_types.all;
entity LATR is
    port(
        CLOCK           : in     vl_logic;
        DATAIN          : in     vl_logic;
        ARESETn         : in     vl_logic;
        DATAOUT         : out    vl_logic
    );
end LATR;
