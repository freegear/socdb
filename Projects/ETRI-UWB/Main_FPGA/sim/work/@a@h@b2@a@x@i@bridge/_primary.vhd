library verilog;
use verilog.vl_types.all;
entity AHB2AXIBridge is
    generic(
        S_IDLE          : integer := 0;
        S_READ          : integer := 1;
        S_WRITE         : integer := 2;
        S_WRITE_RESP    : integer := 3
    );
    port(
        CLK             : in     vl_logic;
        RESETn          : in     vl_logic;
        HADDR           : in     vl_logic_vector(31 downto 0);
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HWRITE          : in     vl_logic;
        HSIZE           : in     vl_logic_vector(2 downto 0);
        HBL             : in     vl_logic_vector(3 downto 0);
        HBURST          : in     vl_logic_vector(2 downto 0);
        HPROT           : in     vl_logic_vector(3 downto 0);
        HWDATA          : in     vl_logic_vector(31 downto 0);
        HRDATA          : out    vl_logic_vector(31 downto 0);
        HREADY_IN       : in     vl_logic;
        HREADY_OUT      : out    vl_logic;
        HRESP           : out    vl_logic_vector(1 downto 0);
        HSEL            : in     vl_logic;
        HMASTLOCK       : in     vl_logic;
        AWADDR          : out    vl_logic_vector(31 downto 0);
        AWLEN           : out    vl_logic_vector(3 downto 0);
        AWSIZE          : out    vl_logic_vector(2 downto 0);
        AWBURST         : out    vl_logic_vector(1 downto 0);
        AWLOCK          : out    vl_logic_vector(1 downto 0);
        AWCACHE         : out    vl_logic_vector(3 downto 0);
        AWPROT          : out    vl_logic_vector(2 downto 0);
        AWVALID         : out    vl_logic;
        AWREADY         : in     vl_logic;
        WDATA           : out    vl_logic_vector(31 downto 0);
        WSTRB           : out    vl_logic_vector(3 downto 0);
        WLAST           : out    vl_logic;
        WVALID          : out    vl_logic;
        WREADY          : in     vl_logic;
        BRESP           : in     vl_logic_vector(1 downto 0);
        BVALID          : in     vl_logic;
        BREADY          : out    vl_logic;
        ARADDR          : out    vl_logic_vector(31 downto 0);
        ARLEN           : out    vl_logic_vector(3 downto 0);
        ARSIZE          : out    vl_logic_vector(2 downto 0);
        ARBURST         : out    vl_logic_vector(1 downto 0);
        ARLOCK          : out    vl_logic_vector(1 downto 0);
        ARCACHE         : out    vl_logic_vector(3 downto 0);
        ARPROT          : out    vl_logic_vector(2 downto 0);
        ARVALID         : out    vl_logic;
        ARREADY         : in     vl_logic;
        RDATA           : in     vl_logic_vector(31 downto 0);
        RRESP           : in     vl_logic_vector(1 downto 0);
        RLAST           : in     vl_logic;
        RVALID          : in     vl_logic;
        RREADY          : out    vl_logic
    );
end AHB2AXIBridge;
