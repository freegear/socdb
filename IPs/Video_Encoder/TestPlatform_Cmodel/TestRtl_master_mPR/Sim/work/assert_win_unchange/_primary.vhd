library verilog;
use verilog.vl_types.all;
entity assert_win_unchange is
    generic(
        severity_level  : integer := 1;
        width           : integer := 1;
        property_type   : integer := 0;
        msg             : string  := "VIOLATION";
        WIN_UNCHANGE_START: integer := 0;
        WIN_UNCHANGE_CHECK: integer := 1;
        assert_name     : string  := "ASSERT_WIN_UNCHANGE"
    );
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        start_event     : in     vl_logic;
        test_expr       : in     vl_logic_vector;
        end_event       : in     vl_logic
    );
end assert_win_unchange;
