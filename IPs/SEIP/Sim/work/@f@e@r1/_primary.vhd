library verilog;
use verilog.vl_types.all;
entity FER1 is
    port(
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        CK              : in     vl_logic;
        DE              : in     vl_logic;
        D               : in     vl_logic;
        SR              : in     vl_logic;
        Q               : out    vl_logic
    );
end FER1;
