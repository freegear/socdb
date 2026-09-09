library verilog;
use verilog.vl_types.all;
entity tb_IntSRAMController is
    generic(
        CLK_HALFPERIOD  : integer := 5;
        DATA_WIDTH      : integer := 32;
        WID_WIDTH       : integer := 4;
        RID_WIDTH       : integer := 4;
        CNT_WIDTH       : integer := 32
    );
end tb_IntSRAMController;
