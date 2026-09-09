library verilog;
use verilog.vl_types.all;
entity sqrt_top is
    generic(
        WIDTH_RAD_ORG   : integer := 28;
        SM_WIDTH        : integer := 3;
        IDLE            : integer := 0;
        SQRT            : integer := 1;
        POSTS           : integer := 2
    );
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        sqrten          : in     vl_logic;
        radicad         : in     vl_logic_vector;
        q               : out    vl_logic_vector;
        sqrtend         : out    vl_logic
    );
end sqrt_top;
