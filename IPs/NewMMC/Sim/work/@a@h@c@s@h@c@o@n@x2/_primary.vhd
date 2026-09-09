library verilog;
use verilog.vl_types.all;
entity ahcshconx2 is
    port(
        s               : out    vl_logic;
        con             : out    vl_logic;
        a               : in     vl_logic;
        ci              : in     vl_logic;
        cs              : in     vl_logic
    );
end ahcshconx2;
