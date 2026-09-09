library verilog;
use verilog.vl_types.all;
entity WEMIF is
    port(
        WEMAR           : in     vl_logic_vector(19 downto 0);
        WEMAH           : in     vl_logic_vector(3 downto 0);
        GPD             : in     vl_logic_vector(15 downto 0);
        GPA             : in     vl_logic_vector(3 downto 0);
        MCK             : in     vl_logic;
        WMDRE           : in     vl_logic;
        WMDWE           : in     vl_logic;
        WEMLE           : in     vl_logic;
        XRST            : in     vl_logic;
        ENP             : in     vl_logic;
        TE              : in     vl_logic;
        WSCST           : in     vl_logic;
        TI              : in     vl_logic;
        WEMA            : out    vl_logic_vector(23 downto 0);
        WEMDI           : out    vl_logic_vector(7 downto 0);
        \TO\            : out    vl_logic;
        WEMRE           : out    vl_logic;
        XWEMOC          : out    vl_logic;
        XWEMWE          : out    vl_logic
    );
end WEMIF;
