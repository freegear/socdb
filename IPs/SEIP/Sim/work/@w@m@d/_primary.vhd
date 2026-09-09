library verilog;
use verilog.vl_types.all;
entity WMD is
    port(
        WEMDO           : in     vl_logic_vector(7 downto 0);
        CDI             : in     vl_logic_vector(3 downto 0);
        WEMRE           : in     vl_logic;
        MCK             : in     vl_logic;
        WST1            : in     vl_logic;
        WST0            : in     vl_logic;
        W0LE            : in     vl_logic;
        W1LE            : in     vl_logic;
        W2LE            : in     vl_logic;
        W3LE            : in     vl_logic;
        TE              : in     vl_logic;
        XRST            : in     vl_logic;
        TI              : in     vl_logic;
        WMDILE          : in     vl_logic;
        SLWD            : out    vl_logic_vector(19 downto 0);
        WMRD            : out    vl_logic_vector(7 downto 0);
        WCCD            : out    vl_logic;
        \TO\            : out    vl_logic
    );
end WMD;
