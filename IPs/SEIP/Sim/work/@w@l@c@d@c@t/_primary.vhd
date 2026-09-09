library verilog;
use verilog.vl_types.all;
entity WLCDCT is
    port(
        PLCD            : in     vl_logic_vector(6 downto 0);
        XRST            : in     vl_logic;
        NLCDLE          : in     vl_logic;
        TE              : in     vl_logic;
        PLCCLE          : in     vl_logic;
        WNDIRC          : in     vl_logic;
        PLCCEN          : in     vl_logic;
        WMAQ0           : in     vl_logic;
        WNLE            : in     vl_logic;
        WCCD            : in     vl_logic;
        TI              : in     vl_logic;
        MCK             : in     vl_logic;
        CDI             : out    vl_logic_vector(3 downto 0);
        WR1O            : out    vl_logic_vector(5 downto 0);
        \TO\            : out    vl_logic
    );
end WLCDCT;
