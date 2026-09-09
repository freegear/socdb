library verilog;
use verilog.vl_types.all;
entity TestMaster is
    generic(
        DATA_WIDTH      : integer := 32;
        WID_WIDTH       : integer := 4;
        RID_WIDTH       : integer := 4;
        RANDOMIZE       : integer := 1;
        MAXIMUM_IDLE_CNT: integer := 100000;
        AWQ_WIDTH       : integer := 4;
        WDQ_WIDTH       : integer := 8;
        ARQ_WIDTH       : integer := 4;
        RDQ_WIDTH       : integer := 8;
        CNT_WIDTH       : integer := 32;
        TADDR_WIDTH     : integer := 10
    );
    port(
        MASTER_ID       : in     vl_logic_vector(1 downto 0);
        ACLK            : in     vl_logic;
        ARESETn         : in     vl_logic;
        AWID            : out    vl_logic_vector;
        AWADDR          : out    vl_logic_vector(31 downto 0);
        AWLEN           : out    vl_logic_vector(3 downto 0);
        AWSIZE          : out    vl_logic_vector(2 downto 0);
        AWBURST         : out    vl_logic_vector(1 downto 0);
        AWLOCK          : out    vl_logic_vector(1 downto 0);
        AWCACHE         : out    vl_logic_vector(3 downto 0);
        AWPROT          : out    vl_logic_vector(2 downto 0);
        AWVALID         : out    vl_logic;
        AWREADY         : in     vl_logic;
        WID             : out    vl_logic_vector;
        WDATA           : out    vl_logic_vector;
        WSTRB           : out    vl_logic_vector;
        WLAST           : out    vl_logic;
        WVALID          : out    vl_logic;
        WREADY          : in     vl_logic;
        BID             : in     vl_logic_vector;
        BRESP           : in     vl_logic_vector(1 downto 0);
        BVALID          : in     vl_logic;
        BREADY          : out    vl_logic;
        ARID            : out    vl_logic_vector;
        ARADDR          : out    vl_logic_vector(31 downto 0);
        ARLEN           : out    vl_logic_vector(3 downto 0);
        ARSIZE          : out    vl_logic_vector(2 downto 0);
        ARBURST         : out    vl_logic_vector(1 downto 0);
        ARLOCK          : out    vl_logic_vector(1 downto 0);
        ARCACHE         : out    vl_logic_vector(3 downto 0);
        ARPROT          : out    vl_logic_vector(2 downto 0);
        ARVALID         : out    vl_logic;
        ARREADY         : in     vl_logic;
        RID             : in     vl_logic_vector;
        RDATA           : in     vl_logic_vector;
        RRESP           : in     vl_logic_vector(1 downto 0);
        RLAST           : in     vl_logic;
        RVALID          : in     vl_logic;
        RREADY          : out    vl_logic
    );
end TestMaster;
