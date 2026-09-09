library verilog;
use verilog.vl_types.all;
entity smc_top is
    generic(
        wid_width       : integer := 4;
        rid_width       : integer := 4
    );
    port(
        aclk            : in     vl_logic;
        aresetn         : in     vl_logic;
        awid            : in     vl_logic_vector;
        awaddr          : in     vl_logic_vector(31 downto 0);
        awlen           : in     vl_logic_vector(3 downto 0);
        awsize          : in     vl_logic_vector(2 downto 0);
        awburst         : in     vl_logic_vector(1 downto 0);
        awvalid         : in     vl_logic;
        awready         : out    vl_logic;
        wid             : in     vl_logic_vector;
        wdata           : in     vl_logic_vector(31 downto 0);
        wstrb           : in     vl_logic_vector(3 downto 0);
        wlast           : in     vl_logic;
        wvalid          : in     vl_logic;
        wready          : out    vl_logic;
        bid             : out    vl_logic_vector;
        bresp           : out    vl_logic_vector(1 downto 0);
        bvalid          : out    vl_logic;
        bready          : in     vl_logic;
        arid            : in     vl_logic_vector;
        araddr          : in     vl_logic_vector(31 downto 0);
        arlen           : in     vl_logic_vector(3 downto 0);
        arsize          : in     vl_logic_vector(2 downto 0);
        arburst         : in     vl_logic_vector(1 downto 0);
        arvalid         : in     vl_logic;
        arready         : out    vl_logic;
        rid             : out    vl_logic_vector;
        rdata           : out    vl_logic_vector(31 downto 0);
        rresp           : out    vl_logic_vector(1 downto 0);
        rlast           : out    vl_logic;
        rvalid          : out    vl_logic;
        rready          : in     vl_logic;
        pclk            : in     vl_logic;
        presetn         : in     vl_logic;
        paddr           : in     vl_logic_vector(2 to 3);
        psel            : in     vl_logic;
        penable         : in     vl_logic;
        pwrite          : in     vl_logic;
        pwdata          : in     vl_logic_vector(31 downto 0);
        prdata          : out    vl_logic_vector(31 downto 0);
        ext_addr        : out    vl_logic_vector(19 downto 0);
        ext_wdata       : out    vl_logic_vector(31 downto 0);
        ext_rdata       : in     vl_logic_vector(31 downto 0);
        ext_csb         : out    vl_logic_vector(3 downto 0);
        ext_oeb         : out    vl_logic;
        ext_web         : out    vl_logic;
        ext_beb         : out    vl_logic_vector(3 downto 0);
        ext_wbeb        : out    vl_logic_vector(3 downto 0);
        ext_biden       : out    vl_logic
    );
end smc_top;
