library verilog;
use verilog.vl_types.all;
entity NOR2BX2 is
    port(
        AN              : in     vl_logic;
        B               : in     vl_logic;
        Y               : out    vl_logic
    );
end NOR2BX2;
