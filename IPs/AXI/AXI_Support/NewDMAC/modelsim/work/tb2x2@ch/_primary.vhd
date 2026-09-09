library verilog;
use verilog.vl_types.all;
entity tb2x2ch is
    generic(
        clk_halfperiod  : integer := 5;
        data_width      : integer := 32;
        id_width        : integer := 4;
        sid_width       : integer := 6
    );
end tb2x2ch;
