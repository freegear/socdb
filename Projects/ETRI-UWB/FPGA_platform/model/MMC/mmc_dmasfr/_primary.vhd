library verilog;
use verilog.vl_types.all;
entity mmc_dmasfr is
    port(
        mresetn         : in     vl_logic;
        hclk            : in     vl_logic;
        hsfr00wr        : in     vl_logic;
        hsfr01wr        : in     vl_logic;
        hwdata          : in     vl_logic_vector(31 downto 0);
        hiaddr          : out    vl_logic_vector(29 downto 0);
        hdst            : out    vl_logic_vector(1 downto 0);
        hicnt           : out    vl_logic_vector(19 downto 0);
        hccnt_clr       : out    vl_logic;
        hirbcnt         : out    vl_logic_vector(2 downto 0);
        hirbsz          : out    vl_logic_vector(4 downto 0);
        hxenable        : out    vl_logic;
        hxmode          : out    vl_logic;
        har             : out    vl_logic;
        hdae            : out    vl_logic
    );
end mmc_dmasfr;
