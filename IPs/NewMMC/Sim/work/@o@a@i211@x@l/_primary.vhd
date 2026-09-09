library verilog;
use verilog.vl_types.all;
entity oai211xl is
    port(
        y               : out    vl_logic;
        a0              : in     vl_logic;
        a1              : in     vl_logic;
        b0              : in     vl_logic;
        c0              : in     vl_logic
    );
end oai211xl;
