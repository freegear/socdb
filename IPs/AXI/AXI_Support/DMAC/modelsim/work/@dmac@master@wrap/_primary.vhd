library verilog;
use verilog.vl_types.all;
entity dmacmasterwrap is
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        hrdata          : in     vl_logic_vector(31 downto 0);
        hready          : in     vl_logic;
        hresp           : in     vl_logic_vector(1 downto 0);
        hgrant          : in     vl_logic;
        haddr           : out    vl_logic_vector(31 downto 0);
        htrans          : out    vl_logic_vector(1 downto 0);
        hwrite          : out    vl_logic;
        hsize           : out    vl_logic_vector(2 downto 0);
        hburst          : out    vl_logic_vector(2 downto 0);
        hprot           : out    vl_logic_vector(3 downto 0);
        hwdata          : out    vl_logic_vector(31 downto 0);
        hbusreq         : out    vl_logic;
        hlock           : out    vl_logic;
        maddr           : in     vl_logic_vector(31 downto 0);
        mtrans          : in     vl_logic_vector(1 downto 0);
        mwrite          : in     vl_logic;
        msize           : in     vl_logic_vector(2 downto 0);
        mburst          : in     vl_logic_vector(2 downto 0);
        mprot           : in     vl_logic_vector(3 downto 0);
        mmastlock       : in     vl_logic;
        mwdata          : in     vl_logic_vector(31 downto 0);
        mrdata          : out    vl_logic_vector(31 downto 0);
        mready          : out    vl_logic;
        merror          : out    vl_logic
    );
end dmacmasterwrap;
