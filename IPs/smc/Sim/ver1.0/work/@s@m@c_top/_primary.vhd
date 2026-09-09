library verilog;
use verilog.vl_types.all;
entity smc_top is
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        haddr           : in     vl_logic_vector(19 downto 0);
        htrans          : in     vl_logic_vector(1 downto 0);
        hwrite          : in     vl_logic;
        hsize           : in     vl_logic_vector(2 downto 0);
        hwdata          : in     vl_logic_vector(31 downto 0);
        hsel0           : in     vl_logic;
        hsel1           : in     vl_logic;
        hsel2           : in     vl_logic;
        hsel3           : in     vl_logic;
        hready_in       : in     vl_logic;
        hready_out      : out    vl_logic;
        hresp           : out    vl_logic_vector(1 downto 0);
        hrdata          : out    vl_logic_vector(31 downto 0);
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
        ext_rdata       : out    vl_logic_vector(31 downto 0);
        ext_csb         : out    vl_logic_vector(3 downto 0);
        ext_oeb         : out    vl_logic;
        ext_web         : out    vl_logic;
        ext_beb         : out    vl_logic_vector(3 downto 0);
        ext_wbeb        : out    vl_logic_vector(3 downto 0);
        ext_biden       : out    vl_logic
    );
end smc_top;
