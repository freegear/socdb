library verilog;
use verilog.vl_types.all;
entity ifmc_serial is
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        tmode           : in     vl_logic;
        tool_mode       : out    vl_logic;
        scl             : in     vl_logic;
        sda_in          : in     vl_logic;
        sda_out         : out    vl_logic;
        sda_oeb         : out    vl_logic;
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
end ifmc_serial;
