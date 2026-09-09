library verilog;
use verilog.vl_types.all;
entity ifmc_ptsm is
    generic(
        PT_SM_WIDTH     : integer := 8;
        IDLE            : integer := 0;
        INITIALIZE      : integer := 1;
        GET_ADDR        : integer := 2;
        ADDR_DUMMY      : integer := 3;
        CLR_COUNTER     : integer := 4;
        GET_DATA        : integer := 5;
        DATA_DUMMY      : integer := 6;
        STOP            : integer := 7
    );
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        scl_lpf         : in     vl_logic;
        sda_lpf         : in     vl_logic;
        sda_out         : out    vl_logic;
        sda_oeb         : out    vl_logic;
        sst_start       : in     vl_logic;
        sst_stop        : in     vl_logic;
        sst_ishift      : in     vl_logic;
        sst_oshift      : in     vl_logic;
        end_sclh        : in     vl_logic;
        fmr_adr         : out    vl_logic_vector(15 downto 0);
        fmr_rd          : out    vl_logic;
        fmr_rdata       : in     vl_logic_vector(31 downto 0);
        fmb_ready       : in     vl_logic;
        fm_wrmode       : out    vl_logic;
        fmw_adr         : out    vl_logic_vector(15 downto 0);
        fmw_xe          : out    vl_logic;
        fmw_ye          : out    vl_logic;
        fmw_se          : out    vl_logic;
        fmw_erase       : out    vl_logic;
        fmw_mas1        : out    vl_logic;
        fmw_prog        : out    vl_logic;
        fmw_nvstr       : out    vl_logic;
        fmw_ifren       : out    vl_logic;
        fmw_din         : out    vl_logic_vector(31 downto 0);
        hdp             : in     vl_logic;
        rdp             : in     vl_logic;
        smart           : in     vl_logic_vector(15 downto 0)
    );
end ifmc_ptsm;
