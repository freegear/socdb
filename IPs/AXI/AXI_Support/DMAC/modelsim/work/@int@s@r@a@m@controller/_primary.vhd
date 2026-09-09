library verilog;
use verilog.vl_types.all;
entity intsramcontroller is
    generic(
        data_width      : integer := 32;
        wid_width       : integer := 4;
        rid_width       : integer := 4;
        addr_width      : integer := 32;
        s_idle          : integer := 0;
        s_read          : integer := 1;
        s_write         : integer := 2;
        s_wait_resp     : integer := 3
    );
    port(
        aclk            : in     vl_logic;
        aresetn         : in     vl_logic;
        awid            : in     vl_logic_vector;
        awaddr          : in     vl_logic_vector;
        awlen           : in     vl_logic_vector(3 downto 0);
        awsize          : in     vl_logic_vector(2 downto 0);
        awburst         : in     vl_logic_vector(1 downto 0);
        awvalid         : in     vl_logic;
        awready         : out    vl_logic;
        wid             : in     vl_logic_vector;
        wdata           : in     vl_logic_vector;
        wstrb           : in     vl_logic_vector;
        wlast           : in     vl_logic;
        wvalid          : in     vl_logic;
        wready          : out    vl_logic;
        bid             : out    vl_logic_vector;
        bresp           : out    vl_logic_vector(1 downto 0);
        bvalid          : out    vl_logic;
        bready          : in     vl_logic;
        arid            : in     vl_logic_vector;
        araddr          : in     vl_logic_vector;
        arlen           : in     vl_logic_vector(3 downto 0);
        arsize          : in     vl_logic_vector(2 downto 0);
        arburst         : in     vl_logic_vector(1 downto 0);
        arvalid         : in     vl_logic;
        arready         : out    vl_logic;
        rid             : out    vl_logic_vector;
        rdata           : out    vl_logic_vector;
        rresp           : out    vl_logic_vector(1 downto 0);
        rlast           : out    vl_logic;
        rvalid          : out    vl_logic;
        rready          : in     vl_logic;
        memaddr         : out    vl_logic_vector;
        memcen          : out    vl_logic;
        memwen          : out    vl_logic_vector;
        memrdata        : in     vl_logic_vector;
        memwdata        : out    vl_logic_vector
    );
end intsramcontroller;
