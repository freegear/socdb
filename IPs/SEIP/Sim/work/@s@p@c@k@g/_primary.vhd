library verilog;
use verilog.vl_types.all;
entity SPCKG is
    port(
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        SYNC            : in     vl_logic;
        EN              : in     vl_logic;
        CK              : in     vl_logic;
        SCK             : out    vl_logic;
        LRCK            : out    vl_logic;
        \TO\            : out    vl_logic
    );
end SPCKG;
