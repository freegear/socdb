library verilog;
use verilog.vl_types.all;
entity mmc_dbg is
    port(
        mresetn         : in     vl_logic;
        hclk            : in     vl_logic;
        hsel            : in     vl_logic;
        haddr           : in     vl_logic_vector(31 downto 0);
        htrans          : in     vl_logic_vector(1 downto 0);
        hsize           : in     vl_logic_vector(2 downto 0);
        hwrite          : in     vl_logic;
        hready          : in     vl_logic;
        hrdata          : out    vl_logic_vector(31 downto 0);
        hresp           : out    vl_logic_vector(1 downto 0);
        hreadyout       : out    vl_logic;
        hdecode         : in     vl_logic_vector(15 downto 0);
        hcstate         : in     vl_logic_vector(4 downto 0);
        hcmdfield       : in     vl_logic_vector(3 downto 0);
        hrespfield      : in     vl_logic_vector(3 downto 0);
        hwrfield        : in     vl_logic_vector(3 downto 0);
        hrdfield        : in     vl_logic_vector(3 downto 0)
    );
end mmc_dbg;
