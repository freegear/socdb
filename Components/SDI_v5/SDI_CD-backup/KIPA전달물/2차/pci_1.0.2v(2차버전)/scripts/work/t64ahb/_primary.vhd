library verilog;
use verilog.vl_types.all;
entity t64ahb is
    generic(
        bar_dwidth      : integer := 8;
        addr_width      : integer := 32;
        mrl_prefetch    : integer := 15;
        mrm_prefetch    : integer := 15
    );
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        iaddr           : out    vl_logic_vector;
        iben            : out    vl_logic_vector(3 downto 0);
        itxinit         : out    vl_logic;
        iwr             : out    vl_logic;
        iburst          : out    vl_logic;
        iprefetch       : out    vl_logic_vector(3 downto 0);
        idrdy           : in     vl_logic;
        itxerr          : in     vl_logic;
        itxidle         : in     vl_logic;
        wbae            : out    vl_logic;
        wbte            : out    vl_logic;
        wbrd            : in     vl_logic;
        rbaf            : out    vl_logic;
        rbtf            : out    vl_logic;
        rbwr            : in     vl_logic;
        rbdin           : in     vl_logic_vector(31 downto 0);
        wbdout          : out    vl_logic_vector(31 downto 0);
        rstpci          : in     vl_logic;
        clkpci          : in     vl_logic;
        t_addr          : in     vl_logic_vector(31 downto 0);
        t_din           : in     vl_logic_vector(63 downto 0);
        t_adr_valid     : in     vl_logic;
        t_width64       : in     vl_logic;
        t_hit           : in     vl_logic;
        t_ben           : in     vl_logic_vector(7 downto 0);
        t_cmd           : in     vl_logic_vector(3 downto 0);
        t_rd            : in     vl_logic;
        t_wr            : in     vl_logic;
        t_we            : in     vl_logic;
        t_nextd         : in     vl_logic;
        t_drdy          : out    vl_logic;
        t_abort         : out    vl_logic;
        t_term          : out    vl_logic;
        t_dout          : out    vl_logic_vector(63 downto 0);
        pciahb_offset   : in     vl_logic_vector(31 downto 0);
        pciahb_discardto: in     vl_logic_vector(7 downto 0);
        pciahb_pfena    : in     vl_logic;
        setposterr      : out    vl_logic;
        setfetcherr     : out    vl_logic;
        setdiscarderr   : out    vl_logic
    );
end t64ahb;
