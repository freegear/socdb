library verilog;
use verilog.vl_types.all;
entity OAI21X2 is
    port(
        A0              : in     vl_logic;
        A1              : in     vl_logic;
        B0              : in     vl_logic;
        Y               : out    vl_logic
    );
end OAI21X2;
