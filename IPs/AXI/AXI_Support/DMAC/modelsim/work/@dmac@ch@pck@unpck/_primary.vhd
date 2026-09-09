library verilog;
use verilog.vl_types.all;
entity dmacchpckunpck is
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        chwrdatam1      : in     vl_logic_vector(31 downto 0);
        chwrdatam2      : in     vl_logic_vector(31 downto 0);
        busavlblm1      : in     vl_logic;
        busavlblm2      : in     vl_logic;
        swidth          : in     vl_logic_vector(2 downto 0);
        dwidth          : in     vl_logic_vector(2 downto 0);
        srcselect       : in     vl_logic;
        dstselect       : in     vl_logic;
        fifoptrreset    : in     vl_logic;
        fiforddata      : in     vl_logic_vector(31 downto 0);
        srcdmacstate    : in     vl_logic_vector(4 downto 0);
        fifowren        : in     vl_logic;
        srcfactor       : in     vl_logic_vector(3 downto 0);
        dstfactor       : in     vl_logic_vector(2 downto 0);
        dstdmacstate    : in     vl_logic_vector(4 downto 0);
        axscntdst       : in     vl_logic_vector(4 downto 0);
        rdptrinc        : in     vl_logic;
        chhwdatam1      : out    vl_logic_vector(31 downto 0);
        chhwdatam2      : out    vl_logic_vector(31 downto 0);
        fifowrptr       : out    vl_logic_vector(1 downto 0);
        fifowrdata      : out    vl_logic_vector(31 downto 0);
        fifowrmask      : out    vl_logic_vector(31 downto 0);
        fifordptr       : out    vl_logic_vector(1 downto 0);
        actemptylevel   : out    vl_logic_vector(4 downto 0);
        actfilllevel    : out    vl_logic_vector(4 downto 0);
        fifoemptylevel  : out    vl_logic_vector(4 downto 0);
        fifofilllevel   : out    vl_logic_vector(4 downto 0);
        fifononempty    : out    vl_logic
    );
end dmacchpckunpck;
