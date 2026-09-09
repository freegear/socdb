library verilog;
use verilog.vl_types.all;
entity ifmc_top is
    port(
        clk             : in     vl_logic;
        apb_clk         : in     vl_logic;
        rstb            : in     vl_logic;
        ahb_sel         : in     vl_logic;
        ahb_readyin     : in     vl_logic;
        ahb_trans       : in     vl_logic_vector(1 downto 0);
        ahb_addr        : in     vl_logic_vector(17 downto 2);
        ahb_write       : in     vl_logic;
        ahb_size        : in     vl_logic_vector(2 downto 0);
        ahb_rdata       : out    vl_logic_vector(31 downto 0);
        ahb_ready       : out    vl_logic;
        ahb_resp        : out    vl_logic_vector(1 downto 0);
        apb_enable      : in     vl_logic;
        apb_sel         : in     vl_logic;
        apb_addr        : in     vl_logic_vector(5 downto 2);
        apb_write       : in     vl_logic;
        apb_wdata       : in     vl_logic_vector(31 downto 0);
        apb_rdata       : out    vl_logic_vector(31 downto 0);
        fmt_en          : in     vl_logic;
        fmt_tmr         : in     vl_logic;
        fmt_vpp         : inout  vl_logic;
        fmt_tm          : inout  vl_logic_vector(2 downto 0);
        fmt_nvstr       : in     vl_logic;
        fmt_se          : in     vl_logic;
        fmt_mas1        : in     vl_logic;
        fmt_ifren       : in     vl_logic;
        fmt_xe          : in     vl_logic;
        fmt_ye          : in     vl_logic;
        fmt_erase       : in     vl_logic
    );
end ifmc_top;
