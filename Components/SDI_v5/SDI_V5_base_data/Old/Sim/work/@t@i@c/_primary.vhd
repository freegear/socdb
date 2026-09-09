library verilog;
use verilog.vl_types.all;
entity TIC is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HREADY          : in     vl_logic;
        HRESP           : in     vl_logic_vector(1 downto 0);
        HGRANTtic       : in     vl_logic;
        HADDR           : out    vl_logic_vector(31 downto 0);
        HTRANS          : out    vl_logic_vector(1 downto 0);
        HWRITE          : out    vl_logic;
        HSIZE           : out    vl_logic_vector(2 downto 0);
        HBURST          : out    vl_logic_vector(2 downto 0);
        HPROT           : out    vl_logic_vector(3 downto 0);
        HWDATA          : out    vl_logic_vector(31 downto 0);
        HBUSREQtic      : out    vl_logic;
        HLOCKtic        : out    vl_logic;
        TESTBUS         : in     vl_logic_vector(31 downto 0);
        TESTREQA        : in     vl_logic;
        TESTREQB        : in     vl_logic;
        TESTACK         : out    vl_logic;
        TicRead         : out    vl_logic
    );
end TIC;
