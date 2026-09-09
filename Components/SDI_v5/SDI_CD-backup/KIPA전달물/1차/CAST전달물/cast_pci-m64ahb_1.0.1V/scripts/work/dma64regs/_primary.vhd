library verilog;
use verilog.vl_types.all;
entity dma64regs is
    generic(
        cmdinit         : integer := 6
    );
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        rstpci          : in     vl_logic;
        clkpci          : in     vl_logic;
        t_addr          : in     vl_logic_vector(15 downto 0);
        t_ben           : in     vl_logic_vector(7 downto 0);
        t_width64       : in     vl_logic;
        t_hit           : in     vl_logic;
        t_we            : in     vl_logic;
        din             : in     vl_logic_vector(63 downto 0);
        ahbaddr         : in     vl_logic_vector(5 downto 0);
        dout_ahb        : out    vl_logic_vector(31 downto 0);
        txsucc32        : in     vl_logic;
        txsucc64        : in     vl_logic;
        inc_ahbaddr     : in     vl_logic;
        tx_pcierrset    : in     vl_logic;
        tx_ahberrset    : in     vl_logic;
        tx_doneset      : in     vl_logic;
        tx_64fset       : in     vl_logic;
        m_otcmd         : in     vl_logic;
        t_drdy          : out    vl_logic;
        txcnt_0         : out    vl_logic;
        dma_txena       : out    vl_logic;
        dma_flsh        : out    vl_logic;
        dma_tx64        : out    vl_logic;
        dma_txdone      : out    vl_logic;
        dma_pcierr      : out    vl_logic;
        dma_ahberr      : out    vl_logic;
        dma_tx64fail    : out    vl_logic;
        dma_cmderror    : in     vl_logic;
        dout            : out    vl_logic_vector(63 downto 0);
        dma_cbe         : out    vl_logic_vector(7 downto 0);
        dma_txcnt       : out    vl_logic_vector(23 downto 0);
        dma_pcicmd      : out    vl_logic_vector(3 downto 0);
        dma_pciaddr     : out    vl_logic_vector(31 downto 0);
        dma_ahbaddr     : out    vl_logic_vector(31 downto 0)
    );
end dma64regs;
