library verilog;
use verilog.vl_types.all;
entity buftd2 is
    port(
        en              : in     vl_logic;
        i               : in     vl_logic;
        z               : out    vl_logic
    );
end buftd2;
