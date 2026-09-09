library verilog;
use verilog.vl_types.all;
entity assert_quiescent_state is
    generic(
        severity_level  : integer := 1;
        width           : integer := 1;
        property_type   : integer := 0;
        msg             : string  := "VIOLATION";
        assert_name     : string  := "ASSERT_QUIESCENT_STATE"
    );
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        state_expr      : in     vl_logic_vector;
        check_value     : in     vl_logic_vector;
        sample_event    : in     vl_logic
    );
end assert_quiescent_state;
