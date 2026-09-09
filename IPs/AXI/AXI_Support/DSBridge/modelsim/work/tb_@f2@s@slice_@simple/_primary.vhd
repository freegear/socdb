library verilog;
use verilog.vl_types.all;
entity tb_f2sslice_simple is
    generic(
        fast_clk_hperiod: integer := 5;
        slow_clk_multiplier: integer := 2;
        comb_delay      : integer := 1;
        randomize       : integer := 0
    );
end tb_f2sslice_simple;
