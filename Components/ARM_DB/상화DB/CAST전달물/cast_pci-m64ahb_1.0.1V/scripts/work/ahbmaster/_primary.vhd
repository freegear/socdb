library verilog;
use verilog.vl_types.all;
entity ahbmaster is
    generic(
        addr_width      : integer := 32
    );
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        mhaddr          : out    vl_logic_vector;
        mhbusreq        : out    vl_logic;
        mhlock          : out    vl_logic;
        mhgrant         : in     vl_logic;
        mhwrite         : out    vl_logic;
        mhtrans         : out    vl_logic_vector(1 downto 0);
        mhsize          : out    vl_logic_vector(2 downto 0);
        mhprot          : out    vl_logic_vector(3 downto 0);
        mhburst         : out    vl_logic_vector(2 downto 0);
        mhready         : in     vl_logic;
        mhresp          : in     vl_logic_vector(1 downto 0);
        iaddr           : in     vl_logic_vector;
        iben            : in     vl_logic_vector(3 downto 0);
        itxinit         : in     vl_logic;
        iwr             : in     vl_logic;
        iburst          : in     vl_logic;
        iprefetch       : in     vl_logic_vector(3 downto 0);
        idrdy           : out    vl_logic;
        itxerr          : out    vl_logic;
        itxidle         : out    vl_logic;
        wbae            : in     vl_logic;
        wbte            : in     vl_logic;
        wbrd            : out    vl_logic;
        rbaf            : in     vl_logic;
        rbtf            : in     vl_logic;
        rbwr            : out    vl_logic
    );
end ahbmaster;
