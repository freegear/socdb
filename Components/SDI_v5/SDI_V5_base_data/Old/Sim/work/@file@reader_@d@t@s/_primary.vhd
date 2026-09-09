library verilog;
use verilog.vl_types.all;
entity FileReader_DTS is
    generic(
        InputFileName   : string  := "DTSD_Filestim.frd"
    );
    port(
        PWCLK           : in     vl_logic;
        Int_Clrn        : in     vl_logic;
        HCLK            : in     vl_logic;
        HRESETn         : in     vl_logic;
        HGRANT          : in     vl_logic;
        HREADY          : in     vl_logic;
        HRESP           : in     vl_logic_vector(1 downto 0);
        HRDATA          : in     vl_logic_vector(31 downto 0);
        HBUSREQ         : out    vl_logic;
        HTRANS          : out    vl_logic_vector(1 downto 0);
        HBURST          : out    vl_logic_vector(2 downto 0);
        HPROT           : out    vl_logic_vector(3 downto 0);
        HSIZE           : out    vl_logic_vector(2 downto 0);
        HWRITE          : out    vl_logic;
        HLOCK           : out    vl_logic;
        HADDR           : out    vl_logic_vector(31 downto 0);
        HWDATA          : out    vl_logic_vector(31 downto 0)
    );
end FileReader_DTS;
