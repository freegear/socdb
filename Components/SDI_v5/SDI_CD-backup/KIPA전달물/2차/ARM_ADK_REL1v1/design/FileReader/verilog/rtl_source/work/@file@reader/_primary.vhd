library verilog;
use verilog.vl_types.all;
entity filereader is
    generic(
        inputfilename   : string  := "filestim.frd"
    );
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        hgrant          : in     vl_logic;
        hready          : in     vl_logic;
        hresp           : in     vl_logic_vector(1 downto 0);
        hrdata          : in     vl_logic_vector(31 downto 0);
        hbusreq         : out    vl_logic;
        htrans          : out    vl_logic_vector(1 downto 0);
        hburst          : out    vl_logic_vector(2 downto 0);
        hprot           : out    vl_logic_vector(3 downto 0);
        hsize           : out    vl_logic_vector(2 downto 0);
        hwrite          : out    vl_logic;
        hlock           : out    vl_logic;
        haddr           : out    vl_logic_vector(31 downto 0);
        hwdata          : out    vl_logic_vector(31 downto 0)
    );
end filereader;
