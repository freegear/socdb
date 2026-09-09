library verilog;
use verilog.vl_types.all;
entity mmc_dmaio is
    port(
        mresetn         : in     vl_logic;
        hclk            : in     vl_logic;
        hsel            : in     vl_logic;
        haddr           : in     vl_logic_vector(31 downto 0);
        htrans          : in     vl_logic_vector(1 downto 0);
        hsize           : in     vl_logic_vector(2 downto 0);
        hwrite          : in     vl_logic;
        hready          : in     vl_logic;
        hsfr00wr        : out    vl_logic;
        hsfr01wr        : out    vl_logic;
        hsfr00rd        : out    vl_logic;
        hsfr01rd        : out    vl_logic;
        hsfr02rd        : out    vl_logic;
        hsfr03rd        : out    vl_logic
    );
end mmc_dmaio;
