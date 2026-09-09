library verilog;
use verilog.vl_types.all;
entity axi_esmc_interface is
    generic(
        wid_width       : integer := 4;
        rid_width       : integer := 4;
        s_idle          : integer := 0;
        s_read          : integer := 1;
        s_write         : integer := 2;
        s_write_resp    : integer := 3;
        s_wait_write    : integer := 4
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
        smc_ready       : in     vl_logic;
        smc_rdata       : in     vl_logic_vector(31 downto 0);
        smc_addr        : out    vl_logic_vector(19 downto 0);
        smc_wdata       : out    vl_logic_vector(31 downto 0);
        smc_wbeb        : out    vl_logic_vector(3 downto 0);
        smc_write       : out    vl_logic;
        smc_read        : out    vl_logic;
        smc_bank_sel    : out    vl_logic_vector(3 downto 0);
        smc_sram_start  : out    vl_logic;
        smc_trans_size  : out    vl_logic_vector(1 downto 0)
    );
end axi_esmc_interface;
