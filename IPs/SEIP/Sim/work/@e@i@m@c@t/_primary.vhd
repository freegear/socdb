library verilog;
use verilog.vl_types.all;
entity EIMCT is
    port(
        EDBR            : in     vl_logic_vector(15 downto 0);
        EEMDO           : in     vl_logic_vector(15 downto 0);
        PMD             : in     vl_logic_vector(15 downto 0);
        EMCL            : in     vl_logic;
        EEMDS           : in     vl_logic;
        ENP             : in     vl_logic;
        EWREQ           : in     vl_logic;
        EPWEN           : in     vl_logic;
        EIMWE           : in     vl_logic;
        ESCST           : in     vl_logic;
        EIMDI           : out    vl_logic_vector(15 downto 0);
        EWRDY           : out    vl_logic;
        XEIMWE          : out    vl_logic
    );
end EIMCT;
