library verilog;
use verilog.vl_types.all;
entity ESOPU is
    port(
        EDB             : in     vl_logic_vector(19 downto 0);
        EPSFT2          : in     vl_logic;
        DTLE            : in     vl_logic;
        EPBSD4          : in     vl_logic;
        EYLE            : in     vl_logic;
        MCK             : in     vl_logic;
        TI              : in     vl_logic;
        TE              : in     vl_logic;
        EXHEN           : in     vl_logic;
        DTEN            : in     vl_logic;
        EXEXEN          : in     vl_logic;
        EXLE            : in     vl_logic;
        EPBSU           : in     vl_logic;
        XRST            : in     vl_logic;
        LFACLLE         : in     vl_logic;
        EROALE          : in     vl_logic;
        EPOEN           : in     vl_logic;
        SFTEN           : in     vl_logic;
        SAWPHEN         : in     vl_logic;
        ABSEN           : in     vl_logic;
        REPHEN          : in     vl_logic;
        ESLMTEN         : in     vl_logic;
        EBLE            : in     vl_logic;
        EALE            : in     vl_logic;
        EAIVEN          : in     vl_logic;
        INC16           : in     vl_logic;
        EPAEN           : in     vl_logic;
        ESPO            : out    vl_logic_vector(19 downto 0);
        EROMA           : out    vl_logic_vector(8 downto 0);
        LFACD           : out    vl_logic_vector(3 downto 0);
        \TO\            : out    vl_logic
    );
end ESOPU;
