library verilog;
use verilog.vl_types.all;
entity assert_implication is
    generic(
        severity_level  : integer := 1;
        property_type   : integer := 0;
        msg             : string  := "VIOLATION";
        assert_name     : string  := "ASSERT_IMPLICATION"
    );
    port(
        clk             : in     vl_logic;
        reset_n         : in     vl_logic;
        antecedent_expr : in     vl_logic;
        consequent_expr : in     vl_logic
    );
end assert_implication;
