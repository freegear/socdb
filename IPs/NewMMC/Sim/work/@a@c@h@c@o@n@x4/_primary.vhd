library verilog;
use verilog.vl_types.all;
entity achconx4 is
    port(
        con             : out    vl_logic;
        a               : in     vl_logic;
        b               : in     vl_logic;
        ci              : in     vl_logic
    );
end achconx4;
