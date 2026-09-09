library verilog;
use verilog.vl_types.all;
entity tb is
    generic(
        clk_halfperiod  : integer := 5;
        wid_width       : integer := 4;
        rid_width       : integer := 4;
        data_width      : integer := 32
    );
end tb;
