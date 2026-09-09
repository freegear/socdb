library verilog;
use verilog.vl_types.all;
entity TWEXP is
    port(
        TIMO            : in     vl_logic_vector(19 downto 0);
        SLWD            : in     vl_logic_vector(19 downto 0);
        XRST            : in     vl_logic;
        TE              : in     vl_logic;
        WESAEN          : in     vl_logic;
        MCK             : in     vl_logic;
        TI              : in     vl_logic;
        WEABLE          : in     vl_logic;
        WEO             : out    vl_logic_vector(19 downto 0);
        \TO\            : out    vl_logic
    );
end TWEXP;
