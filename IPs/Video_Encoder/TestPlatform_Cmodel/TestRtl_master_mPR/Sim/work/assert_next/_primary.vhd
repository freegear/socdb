library verilog;
use verilog.vl_types.all;
entity assert_next is
    generic(
        severity_level  : integer := 1;
        num_cks         : integer := 1;
        check_overlapping: integer := 1;
        check_missing_start: integer := 0;
        property_type   : integer := 0;
        msg             : string  := "VIOLATION";
        assert_name     : string  := "ASSERT_NEXT"
    );
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        start_event     : in     vl_logic;
        test_expr       : in     vl_logic
    );
end assert_next;
