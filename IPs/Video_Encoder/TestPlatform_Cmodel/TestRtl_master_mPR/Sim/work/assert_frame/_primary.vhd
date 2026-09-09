library verilog;
use verilog.vl_types.all;
entity assert_frame is
    generic(
        severity_level  : integer := 1;
        min_cks         : integer := 0;
        max_cks         : integer := 0;
        action_on_new_start: integer := 0;
        property_type   : integer := 0;
        msg             : string  := "VIOLATION";
        assert_name     : string  := "ASSERT_FRAME";
        FRAME_START     : integer := 0;
        FRAME_CHECK     : integer := 1
    );
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        start_event     : in     vl_logic;
        test_expr       : in     vl_logic
    );
end assert_frame;
