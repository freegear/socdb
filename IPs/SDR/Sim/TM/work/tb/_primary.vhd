library verilog;
use verilog.vl_types.all;
entity tb is
    generic(
        CLK_HALFPERIOD  : real    := 3.750000;
        DATA_WIDTH      : integer := 32;
        WID_WIDTH       : integer := 4;
        RID_WIDTH       : integer := 4;
        CNT_WIDTH       : integer := 32
    );
end tb;
