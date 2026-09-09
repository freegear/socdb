library verilog;
use verilog.vl_types.all;
entity FE1R is
    port(
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        CK              : in     vl_logic;
        EN              : in     vl_logic;
        D               : in     vl_logic;
        Q               : out    vl_logic
    );
end FE1R;
