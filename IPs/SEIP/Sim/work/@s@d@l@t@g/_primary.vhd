library verilog;
use verilog.vl_types.all;
entity SDLTG is
    port(
        SCK             : in     vl_logic;
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        LRCK            : in     vl_logic;
        ENP             : in     vl_logic;
        CK              : in     vl_logic;
        SDLE            : out    vl_logic;
        \TO\            : out    vl_logic;
        LLE             : out    vl_logic;
        RLE             : out    vl_logic
    );
end SDLTG;
