library verilog;
use verilog.vl_types.all;
entity DefaultSlave is
    generic(
        DATA_WIDTH      : integer := 32;
        WID_WIDTH       : integer := 4;
        RID_WIDTH       : integer := 4;
        ADDR_WIDTH      : integer := 32;
        S_READ_IDLE     : integer := 0;
        S_READ_DOING    : integer := 1;
        S_WRITE_IDLE    : integer := 0;
        S_WRITE_DOING   : integer := 1;
        S_WRITE_RESP    : integer := 2
    );
    port(
        ACLK            : in     vl_logic;
        ARESETn         : in     vl_logic;
        AWID            : in     vl_logic_vector;
        AWADDR          : in     vl_logic_vector;
        AWLEN           : in     vl_logic_vector(3 downto 0);
        AWSIZE          : in     vl_logic_vector(2 downto 0);
        AWBURST         : in     vl_logic_vector(1 downto 0);
        AWVALID         : in     vl_logic;
        AWREADY         : out    vl_logic;
        WID             : in     vl_logic_vector;
        WDATA           : in     vl_logic_vector;
        WSTRB           : in     vl_logic_vector;
        WLAST           : in     vl_logic;
        WVALID          : in     vl_logic;
        WREADY          : out    vl_logic;
        BID             : out    vl_logic_vector;
        BRESP           : out    vl_logic_vector(1 downto 0);
        BVALID          : out    vl_logic;
        BREADY          : in     vl_logic;
        ARID            : in     vl_logic_vector;
        ARADDR          : in     vl_logic_vector;
        ARLEN           : in     vl_logic_vector(3 downto 0);
        ARSIZE          : in     vl_logic_vector(2 downto 0);
        ARBURST         : in     vl_logic_vector(1 downto 0);
        ARVALID         : in     vl_logic;
        ARREADY         : out    vl_logic;
        RID             : out    vl_logic_vector;
        RDATA           : out    vl_logic_vector;
        RRESP           : out    vl_logic_vector(1 downto 0);
        RLAST           : out    vl_logic;
        RVALID          : out    vl_logic;
        RREADY          : in     vl_logic
    );
end DefaultSlave;
