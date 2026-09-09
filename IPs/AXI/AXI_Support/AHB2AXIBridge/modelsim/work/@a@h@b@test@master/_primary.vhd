library verilog;
use verilog.vl_types.all;
entity ahbtestmaster is
    generic(
        randomize       : integer := 1;
        addr_width      : integer := 10
    );
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        haddr           : out    vl_logic_vector(31 downto 0);
        htrans          : out    vl_logic_vector(1 downto 0);
        hwrite          : out    vl_logic;
        hsize           : out    vl_logic_vector(2 downto 0);
        hburst          : out    vl_logic_vector(2 downto 0);
        hprot           : out    vl_logic_vector(3 downto 0);
        hlock           : out    vl_logic;
        hwdata          : out    vl_logic_vector(31 downto 0);
        hrdata          : in     vl_logic_vector(31 downto 0);
        hready          : in     vl_logic;
        hresp           : in     vl_logic_vector(1 downto 0)
    );
end ahbtestmaster;
