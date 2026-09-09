library verilog;
use verilog.vl_types.all;
entity tb is
    generic(
        CLK_PERIOD      : real    := 5.000000;
        SDLY            : integer := 2;
        CLK27M_PERIOD   : real    := 18.520000
    );
end tb;
