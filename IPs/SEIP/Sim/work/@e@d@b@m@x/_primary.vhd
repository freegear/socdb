library verilog;
use verilog.vl_types.all;
entity EDBMX is
    port(
        EPSO            : in     vl_logic_vector(19 downto 0);
        EIMO            : in     vl_logic_vector(15 downto 0);
        ETO             : in     vl_logic_vector(19 downto 0);
        EQO             : in     vl_logic_vector(19 downto 0);
        EOO             : in     vl_logic_vector(19 downto 0);
        ERO             : in     vl_logic_vector(19 downto 0);
        ESSD            : in     vl_logic_vector(19 downto 0);
        EXTI            : in     vl_logic_vector(19 downto 0);
        EDBRS           : in     vl_logic_vector(1 downto 0);
        LFACD           : in     vl_logic_vector(3 downto 0);
        EMSFEN          : in     vl_logic;
        LFACLS          : in     vl_logic;
        ESSDEN          : in     vl_logic;
        EROEN           : in     vl_logic;
        EXTIEN          : in     vl_logic;
        EOOEN           : in     vl_logic;
        EQOEN           : in     vl_logic;
        ETOEN           : in     vl_logic;
        EIMOEN          : in     vl_logic;
        EPSOEN          : in     vl_logic;
        EDB             : out    vl_logic_vector(19 downto 0);
        EDBR            : out    vl_logic_vector(15 downto 0)
    );
end EDBMX;
