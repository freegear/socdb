library verilog;
use verilog.vl_types.all;
entity Arbiter3 is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HBURST          : in     vl_logic_vector(2 downto 0);
        HREADY          : in     vl_logic;
        HRESP           : in     vl_logic_vector(1 downto 0);
        HBUSREQM3       : in     vl_logic;
        HBUSREQM2       : in     vl_logic;
        HBUSREQM1       : in     vl_logic;
        HBUSREQM0       : in     vl_logic;
        HLOCKM3         : in     vl_logic;
        HLOCKM2         : in     vl_logic;
        HLOCKM1         : in     vl_logic;
        HLOCKM0         : in     vl_logic;
        HSPLIT          : in     vl_logic_vector(3 downto 0);
        HGRANTM3        : out    vl_logic;
        HGRANTM2        : out    vl_logic;
        HGRANTM1        : out    vl_logic;
        HGRANTM0        : out    vl_logic;
        HMASTER         : out    vl_logic_vector(3 downto 0);
        HMASTERD        : out    vl_logic_vector(3 downto 0);
        HMASTLOCK       : out    vl_logic;
        SCANENABLE      : in     vl_logic;
        SCANINHCLK      : in     vl_logic;
        SCANOUTHCLK     : out    vl_logic
    );
end Arbiter3;
