library verilog;
use verilog.vl_types.all;
entity ifmc_wr is
    generic(
        WR_SM_WIDTH     : integer := 17;
        IDLE            : integer := 0;
        START_OP        : integer := 1;
        PRE_TNVS        : integer := 2;
        \TNVS\          : integer := 3;
        PRE_TPGS        : integer := 4;
        \TPGS\          : integer := 5;
        PRE_TPROG       : integer := 6;
        \TPROG\         : integer := 7;
        PRE_TPGH        : integer := 8;
        \TPGH\          : integer := 9;
        PRE_ERASE       : integer := 10;
        ERASE           : integer := 11;
        PRE_TNVH        : integer := 12;
        \TNVH\          : integer := 13;
        PRE_TRCV        : integer := 14;
        \TRCV\          : integer := 15;
        CLR_REG         : integer := 16
    );
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        fm_rdmode       : in     vl_logic;
        key_hit         : in     vl_logic;
        fmaddr          : in     vl_logic_vector(31 downto 0);
        fmdata          : in     vl_logic_vector(31 downto 0);
        fmucon          : in     vl_logic_vector(7 downto 0);
        hdp             : in     vl_logic;
        smart           : in     vl_logic_vector(15 downto 0);
        tnvs            : in     vl_logic_vector(15 downto 0);
        tnvh            : in     vl_logic_vector(15 downto 0);
        tpgs            : in     vl_logic_vector(15 downto 0);
        tpgh            : in     vl_logic_vector(15 downto 0);
        trcv            : in     vl_logic_vector(15 downto 0);
        tnvh1           : in     vl_logic_vector(15 downto 0);
        tprog           : in     vl_logic_vector(15 downto 0);
        terase          : in     vl_logic_vector(31 downto 0);
        tme             : in     vl_logic_vector(31 downto 0);
        pscal_value     : in     vl_logic_vector(6 downto 0);
        fm_wrmode       : out    vl_logic;
        mx_sel_wr       : out    vl_logic;
        clr_fmreg       : out    vl_logic;
        fmw_adr         : out    vl_logic_vector(15 downto 0);
        fmw_xe          : out    vl_logic;
        fmw_ye          : out    vl_logic;
        fmw_se          : out    vl_logic;
        fmw_erase       : out    vl_logic;
        fmw_mas1        : out    vl_logic;
        fmw_prog        : out    vl_logic;
        fmw_nvstr       : out    vl_logic;
        fmw_ifren       : out    vl_logic;
        fmw_din         : out    vl_logic_vector(31 downto 0)
    );
end ifmc_wr;
