library verilog;
use verilog.vl_types.all;
entity TDBMX is
    port(
        WEO             : in     vl_logic_vector(19 downto 0);
        TSO             : in     vl_logic_vector(19 downto 0);
        TIMO            : in     vl_logic_vector(23 downto 0);
        TACO            : in     vl_logic_vector(19 downto 0);
        TIMEXEN         : in     vl_logic;
        TACEN           : in     vl_logic;
        TCSEL           : in     vl_logic;
        XRST            : in     vl_logic;
        TE              : in     vl_logic;
        TC2LE           : in     vl_logic;
        TC1LE           : in     vl_logic;
        TIMLLEN         : in     vl_logic;
        TI              : in     vl_logic;
        TIMLLLE         : in     vl_logic;
        MCK             : in     vl_logic;
        TIMHLEN         : in     vl_logic;
        TSOEN           : in     vl_logic;
        WEOEN           : in     vl_logic;
        TCO             : out    vl_logic_vector(19 downto 0);
        TDB             : out    vl_logic_vector(23 downto 0);
        \TO\            : out    vl_logic
    );
end TDBMX;
