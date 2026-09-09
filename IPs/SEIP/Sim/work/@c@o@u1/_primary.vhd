library verilog;
use verilog.vl_types.all;
entity COU1 is
    port(
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        CK              : in     vl_logic;
        SCL             : in     vl_logic;
        EN              : in     vl_logic;
        QN              : out    vl_logic;
        Q               : out    vl_logic
    );
end COU1;
