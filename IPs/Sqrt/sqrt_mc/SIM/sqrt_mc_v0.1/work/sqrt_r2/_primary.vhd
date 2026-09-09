library verilog;
use verilog.vl_types.all;
entity sqrt_r2 is
    generic(
        WIDTH_RAD_ORG   : integer := 28;
        WIDTH_RAD       : integer := 14;
        WIDTH_Q         : integer := 14
    );
    port(
        quot_bfr        : in     vl_logic_vector;
        rad_bfr         : in     vl_logic_vector;
        r_org_bfr       : in     vl_logic_vector;
        quotient        : out    vl_logic_vector;
        radicad         : out    vl_logic_vector;
        r_org           : out    vl_logic_vector
    );
end sqrt_r2;
