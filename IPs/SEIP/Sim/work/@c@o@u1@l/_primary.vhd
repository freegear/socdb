library verilog;
use verilog.vl_types.all;
entity COU1L is
    port(
        LE              : in     vl_logic;
        D               : in     vl_logic;
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        CK              : in     vl_logic;
        SCL             : in     vl_logic;
        CE              : in     vl_logic;
        Q               : out    vl_logic
    );
end COU1L;
