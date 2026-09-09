library verilog;
use verilog.vl_types.all;
entity intctrl is
    port(
        rstpci          : in     vl_logic;
        clkpci          : in     vl_logic;
        t_addr          : in     vl_logic_vector(5 downto 0);
        t_ben           : in     vl_logic_vector(7 downto 0);
        t_width64       : in     vl_logic;
        t_hit           : in     vl_logic;
        t_we            : in     vl_logic;
        t_drdy          : out    vl_logic;
        din             : in     vl_logic_vector(63 downto 0);
        dout            : out    vl_logic_vector(63 downto 0);
        ahbaddr         : in     vl_logic_vector(5 downto 0);
        dout_ahb        : out    vl_logic_vector(31 downto 0);
        dma_txdone      : in     vl_logic;
        dma_pcierr      : in     vl_logic;
        dma_ahberr      : in     vl_logic;
        t64_posterr     : in     vl_logic;
        t64_fetcherr    : in     vl_logic;
        t64_discarderr  : in     vl_logic;
        mbox_full       : in     vl_logic_vector(7 downto 0);
        pci_intan       : out    vl_logic;
        ahbint          : out    vl_logic
    );
end intctrl;
