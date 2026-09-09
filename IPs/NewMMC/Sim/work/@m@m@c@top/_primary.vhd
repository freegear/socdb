library verilog;
use verilog.vl_types.all;
entity mmctop is
    port(
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        psel            : in     vl_logic;
        penable         : in     vl_logic;
        pwrite          : in     vl_logic;
        paddr           : in     vl_logic_vector(6 downto 2);
        pwdata          : in     vl_logic_vector(31 downto 0);
        prdata          : out    vl_logic_vector(31 downto 0);
        mmc_fbclk       : in     vl_logic;
        mmc_cmdin       : in     vl_logic;
        mmc_datin       : in     vl_logic_vector(7 downto 0);
        testmode        : in     vl_logic;
        mmc_int         : out    vl_logic;
        mmc_dmareq      : out    vl_logic;
        mmc_clkout      : out    vl_logic;
        mmc_cmdout      : out    vl_logic;
        mmc_datout      : out    vl_logic_vector(7 downto 0);
        mmc_ncmden      : out    vl_logic;
        mmc_ndaten      : out    vl_logic
    );
end mmctop;
