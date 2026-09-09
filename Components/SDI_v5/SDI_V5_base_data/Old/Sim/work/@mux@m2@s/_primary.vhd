library verilog;
use verilog.vl_types.all;
entity MuxM2S is
    port(
        HMASTER         : in     vl_logic_vector(3 downto 0);
        HMASTERD        : in     vl_logic_vector(3 downto 0);
        HADDRM1         : in     vl_logic_vector(31 downto 0);
        HTRANSM1        : in     vl_logic_vector(1 downto 0);
        HWRITEM1        : in     vl_logic;
        HSIZEM1         : in     vl_logic_vector(2 downto 0);
        HBURSTM1        : in     vl_logic_vector(2 downto 0);
        HPROTM1         : in     vl_logic_vector(3 downto 0);
        HWDATAM1        : in     vl_logic_vector(31 downto 0);
        HADDRM2         : in     vl_logic_vector(31 downto 0);
        HTRANSM2        : in     vl_logic_vector(1 downto 0);
        HWRITEM2        : in     vl_logic;
        HSIZEM2         : in     vl_logic_vector(2 downto 0);
        HBURSTM2        : in     vl_logic_vector(2 downto 0);
        HPROTM2         : in     vl_logic_vector(3 downto 0);
        HWDATAM2        : in     vl_logic_vector(31 downto 0);
        HADDRM3         : in     vl_logic_vector(31 downto 0);
        HTRANSM3        : in     vl_logic_vector(1 downto 0);
        HWRITEM3        : in     vl_logic;
        HSIZEM3         : in     vl_logic_vector(2 downto 0);
        HBURSTM3        : in     vl_logic_vector(2 downto 0);
        HPROTM3         : in     vl_logic_vector(3 downto 0);
        HWDATAM3        : in     vl_logic_vector(31 downto 0);
        HADDR           : out    vl_logic_vector(31 downto 0);
        HTRANS          : out    vl_logic_vector(1 downto 0);
        HWRITE          : out    vl_logic;
        HSIZE           : out    vl_logic_vector(2 downto 0);
        HBURST          : out    vl_logic_vector(2 downto 0);
        HPROT           : out    vl_logic_vector(3 downto 0);
        HWDATA          : out    vl_logic_vector(31 downto 0)
    );
end MuxM2S;
