library verilog;
use verilog.vl_types.all;
entity ahb2axibridge is
    generic(
        s_idle          : integer := 0;
        s_read          : integer := 1;
        s_write         : integer := 2;
        s_write_resp    : integer := 3
    );
    port(
        clk             : in     vl_logic;
        resetn          : in     vl_logic;
        haddr           : in     vl_logic_vector(31 downto 0);
        htrans          : in     vl_logic_vector(1 downto 0);
        hwrite          : in     vl_logic;
        hsize           : in     vl_logic_vector(2 downto 0);
        hburst          : in     vl_logic_vector(2 downto 0);
        hprot           : in     vl_logic_vector(3 downto 0);
        hwdata          : in     vl_logic_vector(31 downto 0);
        hrdata          : out    vl_logic_vector(31 downto 0);
        hready_in       : in     vl_logic;
        hready_out      : out    vl_logic;
        hresp           : out    vl_logic_vector(1 downto 0);
        hsel            : in     vl_logic;
        hmastlock       : in     vl_logic;
        awaddr          : out    vl_logic_vector(31 downto 0);
        awlen           : out    vl_logic_vector(3 downto 0);
        awsize          : out    vl_logic_vector(2 downto 0);
        awburst         : out    vl_logic_vector(1 downto 0);
        awlock          : out    vl_logic_vector(1 downto 0);
        awcache         : out    vl_logic_vector(3 downto 0);
        awprot          : out    vl_logic_vector(2 downto 0);
        awvalid         : out    vl_logic;
        awready         : in     vl_logic;
        wdata           : out    vl_logic_vector(31 downto 0);
        wstrb           : out    vl_logic_vector(3 downto 0);
        wlast           : out    vl_logic;
        wvalid          : out    vl_logic;
        wready          : in     vl_logic;
        bresp           : in     vl_logic_vector(1 downto 0);
        bvalid          : in     vl_logic;
        bready          : out    vl_logic;
        araddr          : out    vl_logic_vector(31 downto 0);
        arlen           : out    vl_logic_vector(3 downto 0);
        arsize          : out    vl_logic_vector(2 downto 0);
        arburst         : out    vl_logic_vector(1 downto 0);
        arlock          : out    vl_logic_vector(1 downto 0);
        arcache         : out    vl_logic_vector(3 downto 0);
        arprot          : out    vl_logic_vector(2 downto 0);
        arvalid         : out    vl_logic;
        arready         : in     vl_logic;
        rdata           : in     vl_logic_vector(31 downto 0);
        rresp           : in     vl_logic_vector(1 downto 0);
        rlast           : in     vl_logic;
        rvalid          : in     vl_logic;
        rready          : out    vl_logic
    );
end ahb2axibridge;
