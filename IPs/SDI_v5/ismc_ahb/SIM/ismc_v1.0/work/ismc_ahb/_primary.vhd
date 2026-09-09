library verilog;
use verilog.vl_types.all;
entity ismc_ahb is
    generic(
        ADDR_WIDTH      : integer := 15;
        DATA_WIDTH      : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        ahb_sel         : in     vl_logic;
        ahb_readyin     : in     vl_logic;
        ahb_htrans      : in     vl_logic_vector(1 downto 0);
        ahb_addr        : in     vl_logic_vector;
        ahb_write       : in     vl_logic;
        ahb_size        : in     vl_logic_vector(2 downto 0);
        ahb_wdata       : in     vl_logic_vector;
        ahb_rdata       : out    vl_logic_vector;
        ahb_ready       : out    vl_logic;
        ahb_resp        : out    vl_logic_vector(1 downto 0);
        sram_csb        : out    vl_logic;
        sram_addr       : out    vl_logic_vector;
        sram_wrb        : out    vl_logic_vector(3 downto 0);
        sram_oeb        : out    vl_logic;
        sram_dout       : in     vl_logic_vector;
        sram_din        : out    vl_logic_vector
    );
end ismc_ahb;
