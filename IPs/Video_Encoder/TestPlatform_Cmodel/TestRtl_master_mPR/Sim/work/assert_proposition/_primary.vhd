library verilog;
use verilog.vl_types.all;
entity assert_proposition is
    generic(
        severity_level  : integer := 1;
        property_type   : integer := 0;
        msg             : string  := "VIOLATION";
        assert_name     : string  := "ASSERT_PROPOSITION"
    );
    port(
        reset_n         : in     vl_logic;
        test_expr       : in     vl_logic
    );
end assert_proposition;
