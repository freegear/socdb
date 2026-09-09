library verilog;
use verilog.vl_types.all;
entity FS1R is
    port(
        EN              : in     vl_logic;
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        CK              : in     vl_logic;
        SR              : in     vl_logic;
        SS              : in     vl_logic;
        Q               : out    vl_logic
    );
end FS1R;
