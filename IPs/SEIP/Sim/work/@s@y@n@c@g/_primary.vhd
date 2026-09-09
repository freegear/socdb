library verilog;
use verilog.vl_types.all;
entity SYNCG is
    port(
        TE              : in     vl_logic;
        XRST            : in     vl_logic;
        TI              : in     vl_logic;
        MCK             : in     vl_logic;
        ADMCK           : out    vl_logic;
        \TO\            : out    vl_logic;
        FSYNC           : out    vl_logic;
        ENP             : out    vl_logic
    );
end SYNCG;
