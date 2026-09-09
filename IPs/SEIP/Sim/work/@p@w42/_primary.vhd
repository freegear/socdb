library verilog;
use verilog.vl_types.all;
entity PW42 is
    port(
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        SS              : in     vl_logic;
        CK              : in     vl_logic;
        EN8             : in     vl_logic;
        EN              : in     vl_logic;
        \TO\            : out    vl_logic;
        P2              : out    vl_logic;
        P4              : out    vl_logic
    );
end PW42;
