library verilog;
use verilog.vl_types.all;
entity ahb_slave_sm is
    generic(
        address_phase   : integer := 0;
        data_phase      : integer := 2;
        read_wait_phase : integer := 3;
        error_phase     : integer := 1
    );
    port(
        hsel            : in     vl_logic;
        hclock          : in     vl_logic;
        haddress        : in     vl_logic_vector(31 downto 0);
        hwrite          : in     vl_logic;
        htrans          : in     vl_logic_vector(1 downto 0);
        hsize           : in     vl_logic_vector(1 downto 0);
        hburst          : in     vl_logic_vector(2 downto 0);
        hresetn         : in     vl_logic;
        hwdata          : in     vl_logic_vector(31 downto 0);
        hrdata          : out    vl_logic_vector(31 downto 0);
        hresp           : out    vl_logic_vector(1 downto 0);
        hready          : out    vl_logic;
        reg_write       : out    vl_logic;
        reg_address     : out    vl_logic_vector(31 downto 0);
        reg_wdata       : out    vl_logic_vector(31 downto 0);
        latch_bus       : out    vl_logic;
        reg_rdata       : in     vl_logic_vector(31 downto 0)
    );
end ahb_slave_sm;
