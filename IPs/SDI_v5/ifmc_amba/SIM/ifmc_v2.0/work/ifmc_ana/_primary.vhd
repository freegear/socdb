library verilog;
use verilog.vl_types.all;
entity ifmc_ana is
    generic(
        ISCLEDGE_DLY    : integer := 8;
        OSCLEDGE_DLY    : integer := 4
    );
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        tool_mode       : in     vl_logic;
        scl_lpf         : in     vl_logic;
        sda_lpf         : in     vl_logic;
        sst_start       : out    vl_logic;
        sst_stop        : out    vl_logic;
        sst_ishift      : out    vl_logic;
        sst_oshift      : out    vl_logic;
        end_sclh        : out    vl_logic
    );
end ifmc_ana;
