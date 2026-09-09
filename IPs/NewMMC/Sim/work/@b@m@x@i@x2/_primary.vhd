library verilog;
use verilog.vl_types.all;
entity bmxix2 is
    port(
        ppn             : out    vl_logic;
        x2              : in     vl_logic;
        a               : in     vl_logic;
        s               : in     vl_logic;
        m1              : in     vl_logic;
        m0              : in     vl_logic
    );
end bmxix2;
