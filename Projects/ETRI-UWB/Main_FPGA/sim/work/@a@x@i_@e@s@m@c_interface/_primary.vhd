library verilog;
use verilog.vl_types.all;
entity AXI_ESMC_interface is
    generic(
        WID_WIDTH       : integer := 4;
        RID_WIDTH       : integer := 4;
        S_IDLE          : integer := 0;
        S_READ          : integer := 1;
        S_WRITE         : integer := 2;
        S_WRITE_RESP    : integer := 3;
        S_WAIT_WRITE    : integer := 4
    );
    port(
        ACLK            : in     vl_logic;
        ARESETn         : in     vl_logic;
        AWID            : in     vl_logic_vector;
        AWADDR          : in     vl_logic_vector(31 downto 0);
        AWLEN           : in     vl_logic_vector(3 downto 0);
        AWSIZE          : in     vl_logic_vector(2 downto 0);
        AWBURST         : in     vl_logic_vector(1 downto 0);
        AWVALID         : in     vl_logic;
        AWREADY         : out    vl_logic;
        WID             : in     vl_logic_vector;
        WDATA           : in     vl_logic_vector(31 downto 0);
        WSTRB           : in     vl_logic_vector(3 downto 0);
        WLAST           : in     vl_logic;
        WVALID          : in     vl_logic;
        WREADY          : out    vl_logic;
        BID             : out    vl_logic_vector;
        BRESP           : out    vl_logic_vector(1 downto 0);
        BVALID          : out    vl_logic;
        BREADY          : in     vl_logic;
        ARID            : in     vl_logic_vector;
        ARADDR          : in     vl_logic_vector(31 downto 0);
        ARLEN           : in     vl_logic_vector(3 downto 0);
        ARSIZE          : in     vl_logic_vector(2 downto 0);
        ARBURST         : in     vl_logic_vector(1 downto 0);
        ARVALID         : in     vl_logic;
        ARREADY         : out    vl_logic;
        RID             : out    vl_logic_vector;
        RDATA           : out    vl_logic_vector(31 downto 0);
        RRESP           : out    vl_logic_vector(1 downto 0);
        RLAST           : out    vl_logic;
        RVALID          : out    vl_logic;
        RREADY          : in     vl_logic;
        SMC_READY       : in     vl_logic;
        SMC_RDATA       : in     vl_logic_vector(31 downto 0);
        SMC_ADDR        : out    vl_logic_vector(26 downto 0);
        SMC_WDATA       : out    vl_logic_vector(31 downto 0);
        SMC_WBEB        : out    vl_logic_vector(3 downto 0);
        SMC_WRITE       : out    vl_logic;
        SMC_READ        : out    vl_logic;
        SMC_BANK_SEL    : out    vl_logic_vector(8 downto 0);
        SMC_SRAM_START  : out    vl_logic;
        SMC_TRANS_SIZE  : out    vl_logic_vector(1 downto 0)
    );
end AXI_ESMC_interface;
