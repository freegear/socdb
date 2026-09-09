library verilog;
use verilog.vl_types.all;
entity ifmc_rd is
    generic(
        ADDR_WIDTH      : integer := 18;
        DATA_WIDTH      : integer := 32;
        RD_SM_WIDTH     : integer := 4;
        IDLE            : integer := 0;
        WAIT_ED_WR      : integer := 1;
        \FMR_RD\        : integer := 2;
        END_RD          : integer := 3
    );
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        ahb_sel         : in     vl_logic;
        ahb_readyin     : in     vl_logic;
        ahb_trans       : in     vl_logic_vector(1 downto 0);
        ahb_addr        : in     vl_logic_vector;
        ahb_write       : in     vl_logic;
        ahb_size        : in     vl_logic_vector(2 downto 0);
        ahb_rdata       : out    vl_logic_vector;
        ahb_ready       : out    vl_logic;
        ahb_resp        : out    vl_logic_vector(1 downto 0);
        fm_wrmode       : in     vl_logic;
        fm_rdmode       : out    vl_logic;
        fmr_adr         : out    vl_logic_vector(15 downto 0);
        fmr_rd          : out    vl_logic;
        fmr_rdata       : in     vl_logic_vector;
        fmb_ready       : in     vl_logic;
        fmb_ready_1cb   : in     vl_logic
    );
end ifmc_rd;
