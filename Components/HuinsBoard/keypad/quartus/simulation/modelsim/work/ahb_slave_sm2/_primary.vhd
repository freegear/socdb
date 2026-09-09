library verilog;
use verilog.vl_types.all;
entity ahb_slave_sm2 is
    generic(
        ADDRESS_PHASE   : integer := 0;
        DATA_PHASE      : integer := 2;
        BURST_PHASE     : integer := 3;
        ERROR_PHASE     : integer := 1
    );
    port(
        HSEL            : in     vl_logic;
        HCLOCK          : in     vl_logic;
        HADDRESS        : in     vl_logic_vector(31 downto 0);
        HWRITE          : in     vl_logic;
        HTRANS          : in     vl_logic_vector(1 downto 0);
        HSIZE           : in     vl_logic_vector(1 downto 0);
        HBURST          : in     vl_logic_vector(2 downto 0);
        HRESETn         : in     vl_logic;
        HWDATA          : in     vl_logic_vector(31 downto 0);
        HRDATA          : out    vl_logic_vector(31 downto 0);
        HRESP           : out    vl_logic_vector(1 downto 0);
        HREADY          : out    vl_logic;
        reg_write       : out    vl_logic;
        reg_address     : out    vl_logic_vector(31 downto 0);
        reg_wdata       : out    vl_logic_vector(31 downto 0);
        wait_sig        : in     vl_logic;
        reg_rdata       : in     vl_logic_vector(31 downto 0)
    );
end ahb_slave_sm2;
