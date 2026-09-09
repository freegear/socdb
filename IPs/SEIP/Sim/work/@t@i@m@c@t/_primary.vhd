library verilog;
use verilog.vl_types.all;
entity TIMCT is
    port(
        TDB             : in     vl_logic_vector(23 downto 0);
        PMD             : in     vl_logic_vector(11 downto 0);
        TIMO            : in     vl_logic_vector(23 downto 0);
        TIMEA           : in     vl_logic_vector(8 downto 0);
        PMA             : in     vl_logic_vector(8 downto 0);
        MCK             : in     vl_logic;
        TSCST           : in     vl_logic;
        TI              : in     vl_logic;
        XRST            : in     vl_logic;
        TE              : in     vl_logic;
        TIMLIS          : in     vl_logic;
        TIMLWE          : in     vl_logic;
        TLWREQ          : in     vl_logic;
        TIMHWE          : in     vl_logic;
        THWREQ          : in     vl_logic;
        TPWEN           : in     vl_logic;
        ENP             : in     vl_logic;
        TIMI            : out    vl_logic_vector(23 downto 0);
        TIMA            : out    vl_logic_vector(8 downto 0);
        \TO\            : out    vl_logic;
        TLWRDY          : out    vl_logic;
        THWRDY          : out    vl_logic;
        XTIMWE          : out    vl_logic
    );
end TIMCT;
