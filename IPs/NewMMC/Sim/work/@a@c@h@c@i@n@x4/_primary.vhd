library verilog;
use verilog.vl_types.all;
entity achcinx4 is
    port(
        co              : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        cin             : in     vl_logic
    );
end achcinx4;
