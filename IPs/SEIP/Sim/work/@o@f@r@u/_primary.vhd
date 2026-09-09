library verilog;
use verilog.vl_types.all;
entity OFRU is
    port(
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        CK              : in     vl_logic;
        CHS             : in     vl_logic;
        OFDT            : in     vl_logic;
        DE2             : in     vl_logic;
        DE4             : in     vl_logic;
        DE3             : in     vl_logic;
        TI              : in     vl_logic;
        DE1             : in     vl_logic;
        D               : in     vl_logic;
        \TO\            : out    vl_logic;
        Q               : out    vl_logic;
        CHQ             : out    vl_logic
    );
end OFRU;
