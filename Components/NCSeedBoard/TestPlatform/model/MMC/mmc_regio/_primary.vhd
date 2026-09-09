library verilog;
use verilog.vl_types.all;
entity mmc_regio is
    port(
        mresetn         : in     vl_logic;
        mclk            : in     vl_logic;
        hsel            : in     vl_logic;
        haddr           : in     vl_logic_vector(31 downto 0);
        htrans          : in     vl_logic_vector(1 downto 0);
        hsize           : in     vl_logic_vector(2 downto 0);
        hwrite          : in     vl_logic;
        hready          : in     vl_logic;
        hmmcxwr         : out    vl_logic_vector(24 downto 0);
        hmmcxrd         : out    vl_logic_vector(24 downto 0);
        hsfrxwr         : out    vl_logic_vector(18 downto 0);
        hsfrxrd         : out    vl_logic_vector(18 downto 0)
    );
end mmc_regio;
