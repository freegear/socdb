library verilog;
use verilog.vl_types.all;
entity Lite2AHB is
    port(
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HRDATA          : in     vl_logic_vector(31 downto 0);
        HREADY          : in     vl_logic;
        HRESP           : in     vl_logic_vector(1 downto 0);
        HGRANT          : in     vl_logic;
        HADDR           : out    vl_logic_vector(31 downto 0);
        HTRANS          : out    vl_logic_vector(1 downto 0);
        HWRITE          : out    vl_logic;
        HSIZE           : out    vl_logic_vector(2 downto 0);
        HBURST          : out    vl_logic_vector(2 downto 0);
        HPROT           : out    vl_logic_vector(3 downto 0);
        HWDATA          : out    vl_logic_vector(31 downto 0);
        HBUSREQ         : out    vl_logic;
        HLOCK           : out    vl_logic;
        MADDR           : in     vl_logic_vector(31 downto 0);
        MTRANS          : in     vl_logic_vector(1 downto 0);
        MWRITE          : in     vl_logic;
        MSIZE           : in     vl_logic_vector(2 downto 0);
        MBURST          : in     vl_logic_vector(2 downto 0);
        MPROT           : in     vl_logic_vector(3 downto 0);
        MMASTLOCK       : in     vl_logic;
        MWDATA          : in     vl_logic_vector(31 downto 0);
        MRDATA          : out    vl_logic_vector(31 downto 0);
        MREADY          : out    vl_logic;
        MERROR          : out    vl_logic;
        SCANENABLE      : in     vl_logic;
        SCANINHCLK      : in     vl_logic;
        SCANOUTHCLK     : out    vl_logic
    );
end Lite2AHB;
