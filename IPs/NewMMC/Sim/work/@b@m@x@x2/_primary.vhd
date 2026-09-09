library verilog;
use verilog.vl_types.all;
entity bmxx2 is
    port(
        pp              : out    vl_logic;
        x2              : in     vl_logic;
        a               : in     vl_logic;
        s               : in     vl_logic;
        m1              : in     vl_logic;
        m0              : in     vl_logic
    );
end bmxx2;
