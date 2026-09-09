library verilog;
use verilog.vl_types.all;
entity AXI2AHBBridge is
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
        HADDR           : out    vl_logic_vector(31 downto 0);
        HTRANS          : out    vl_logic_vector(1 downto 0);
        HWRITE          : out    vl_logic;
        HSIZE           : out    vl_logic_vector(2 downto 0);
        HBURST          : out    vl_logic_vector(2 downto 0);
        HWDATA          : out    vl_logic_vector(31 downto 0);
        HRDATA          : in     vl_logic_vector(31 downto 0);
        HREADY_IN       : in     vl_logic;
        HREADY_OUT      : out    vl_logic;
        HRESP           : in     vl_logic_vector(1 downto 0);
        HSEL            : out    vl_logic
    );
end AXI2AHBBridge;
