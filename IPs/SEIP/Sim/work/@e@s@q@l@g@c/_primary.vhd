library verilog;
use verilog.vl_types.all;
entity ESQLGC is
    port(
        A               : in     vl_logic_vector(23 downto 0);
        B5              : in     vl_logic;
        EN              : in     vl_logic;
        B7              : in     vl_logic;
        B3              : in     vl_logic;
        B2              : in     vl_logic;
        B1              : in     vl_logic;
        FLEND           : out    vl_logic;
        EMST            : out    vl_logic;
        SE              : out    vl_logic;
        Y               : out    vl_logic
    );
end ESQLGC;
