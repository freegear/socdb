library verilog;
use verilog.vl_types.all;
entity PSCKG is
    port(
        SBW             : in     vl_logic_vector(1 downto 0);
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        SYNC            : in     vl_logic;
        TI              : in     vl_logic;
        EN              : in     vl_logic;
        CK              : in     vl_logic;
        SO              : out    vl_logic_vector(4 downto 0);
        SCK             : out    vl_logic;
        \TO\            : out    vl_logic;
        LRCK            : out    vl_logic
    );
end PSCKG;
