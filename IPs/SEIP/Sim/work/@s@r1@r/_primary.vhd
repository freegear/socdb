library verilog;
use verilog.vl_types.all;
entity SR1R is
    port(
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        CK              : in     vl_logic;
        SR              : in     vl_logic;
        SS              : in     vl_logic;
        Q               : out    vl_logic
    );
end SR1R;
