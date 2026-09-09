library verilog;
use verilog.vl_types.all;
entity WMOPU is
    port(
        WDB             : in     vl_logic_vector(15 downto 0);
        RLD             : in     vl_logic_vector(2 downto 0);
        RPD             : in     vl_logic_vector(15 downto 0);
        PACH            : in     vl_logic_vector(15 downto 0);
        PITL            : in     vl_logic_vector(15 downto 0);
        PITLEN          : in     vl_logic;
        MSBLE           : in     vl_logic;
        WABINC          : in     vl_logic;
        TE              : in     vl_logic;
        XRST            : in     vl_logic;
        WMADS           : in     vl_logic;
        WRPEN           : in     vl_logic;
        WR0EN           : in     vl_logic;
        WAIVCT          : in     vl_logic;
        TI              : in     vl_logic;
        WRLEN           : in     vl_logic;
        WABLE           : in     vl_logic;
        WCRLE           : in     vl_logic;
        MCK             : in     vl_logic;
        WSO             : out    vl_logic_vector(15 downto 0);
        WADI            : out    vl_logic_vector(15 downto 0);
        CARRY           : out    vl_logic;
        WSMSB           : out    vl_logic;
        \TO\            : out    vl_logic
    );
end WMOPU;
