library verilog;
use verilog.vl_types.all;
entity ifmc_reg is
    generic(
        KEY_VALUE       : integer := 1515870810;
        TNVS_US         : integer := 63;
        TNVH_US         : integer := 63;
        TPGS_US         : integer := 126;
        TPGH_NS         : integer := 3;
        TRCV_US         : integer := 14;
        TNVH1_US        : integer := 1258;
        TPROG_US        : integer := 251;
        TERASE_US       : integer := 250000;
        TME_US          : integer := 250000;
        PSCALE_NS       : integer := 5
    );
    port(
        apb_clk         : in     vl_logic;
        apb_rstb        : in     vl_logic;
        apb_enable      : in     vl_logic;
        apb_sel         : in     vl_logic;
        apb_addr        : in     vl_logic_vector(5 downto 2);
        apb_write       : in     vl_logic;
        apb_wdata       : in     vl_logic_vector(31 downto 0);
        apb_rdata       : out    vl_logic_vector(31 downto 0);
        fm_wrmode       : in     vl_logic;
        clr_fmreg       : in     vl_logic;
        hdp             : in     vl_logic;
        rdp             : in     vl_logic;
        smart           : in     vl_logic_vector(15 downto 0);
        key_hit         : out    vl_logic;
        fmaddr          : out    vl_logic_vector(31 downto 0);
        fmdata          : out    vl_logic_vector(31 downto 0);
        fmucon          : out    vl_logic_vector(7 downto 0);
        rdwaitcycle     : out    vl_logic_vector(1 downto 0);
        info_rd         : out    vl_logic;
        tnvs            : out    vl_logic_vector(15 downto 0);
        tnvh            : out    vl_logic_vector(15 downto 0);
        tpgs            : out    vl_logic_vector(15 downto 0);
        tpgh            : out    vl_logic_vector(15 downto 0);
        trcv            : out    vl_logic_vector(15 downto 0);
        tnvh1           : out    vl_logic_vector(15 downto 0);
        tprog           : out    vl_logic_vector(15 downto 0);
        terase          : out    vl_logic_vector(31 downto 0);
        tme             : out    vl_logic_vector(31 downto 0);
        pscal_value     : out    vl_logic_vector(6 downto 0)
    );
end ifmc_reg;
