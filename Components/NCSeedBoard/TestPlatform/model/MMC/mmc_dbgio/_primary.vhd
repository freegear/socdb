library verilog;
use verilog.vl_types.all;
entity mmc_dbgio is
    port(
        mresetn         : in     vl_logic;
        hclk            : in     vl_logic;
        hsel            : in     vl_logic;
        haddr           : in     vl_logic_vector(31 downto 0);
        htrans          : in     vl_logic_vector(1 downto 0);
        hsize           : in     vl_logic_vector(2 downto 0);
        hwrite          : in     vl_logic;
        hready          : in     vl_logic;
        hsfrxrd         : out    vl_logic_vector(1 downto 0)
    );
end mmc_dbgio;
