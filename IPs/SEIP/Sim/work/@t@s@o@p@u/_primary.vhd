library verilog;
use verilog.vl_types.all;
entity TSOPU is
    port(
        CHLV            : in     vl_logic_vector(2 downto 0);
        TROMO           : in     vl_logic_vector(7 downto 0);
        TDB             : in     vl_logic_vector(23 downto 0);
        ITPD            : in     vl_logic_vector(7 downto 0);
        TIMEXEN         : in     vl_logic;
        ITPEN           : in     vl_logic;
        TIMLEN          : in     vl_logic;
        TE              : in     vl_logic;
        MCK             : in     vl_logic;
        TSYEN           : in     vl_logic;
        TPYEN           : in     vl_logic;
        TYLE            : in     vl_logic;
        TXLE            : in     vl_logic;
        TI              : in     vl_logic;
        TROMEN          : in     vl_logic;
        TXEXEN          : in     vl_logic;
        CHLVEN          : in     vl_logic;
        TBS2EN          : in     vl_logic;
        XRST            : in     vl_logic;
        TCO             : in     vl_logic_vector(19 downto 0);
        TBCL            : in     vl_logic;
        TSBEN           : in     vl_logic;
        TPAEN           : in     vl_logic;
        TALE            : in     vl_logic;
        TAIVEN          : in     vl_logic;
        TBLE            : in     vl_logic;
        TCBEN           : in     vl_logic;
        TTLE            : in     vl_logic;
        TTSEN           : in     vl_logic;
        TSO             : out    vl_logic_vector(19 downto 0);
        \TO\            : out    vl_logic
    );
end TSOPU;
