library verilog;
use verilog.vl_types.all;
entity div_cmp is
    generic(
        WIDTH_DIVD      : integer := 16
    );
    port(
        dividend        : in     vl_logic_vector;
        divisor_m1      : in     vl_logic_vector;
        divisor_m2      : in     vl_logic_vector;
        divisor_m3      : in     vl_logic_vector;
        q               : out    vl_logic_vector(1 downto 0);
        r               : out    vl_logic_vector
    );
end div_cmp;
