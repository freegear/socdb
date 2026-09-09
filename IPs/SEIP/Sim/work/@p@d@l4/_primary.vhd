library verilog;
use verilog.vl_types.all;
entity PDL4 is
    port(
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        ENP             : in     vl_logic;
        SS4             : in     vl_logic;
        SS3             : in     vl_logic;
        SS2             : in     vl_logic;
        TI              : in     vl_logic;
        SS1             : in     vl_logic;
        CK              : in     vl_logic;
        \TO\            : out    vl_logic;
        P4              : out    vl_logic;
        P3              : out    vl_logic;
        P2              : out    vl_logic;
        P1              : out    vl_logic
    );
end PDL4;
