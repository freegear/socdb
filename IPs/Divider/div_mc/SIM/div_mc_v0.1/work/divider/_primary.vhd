library verilog;
use verilog.vl_types.all;
entity divider is
    generic(
        WIDTH_DIVD      : integer := 16;
        WIDTH_DIVS      : integer := 16;
        WIDTH_RSLT      : integer := 16;
        SM_WIDTH        : integer := 5;
        IDLE            : integer := 0;
        PRE             : integer := 1;
        PRES            : integer := 2;
        DIV             : integer := 3;
        POSTS           : integer := 4
    );
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        diven           : in     vl_logic;
        dividend        : in     vl_logic_vector;
        divisor         : in     vl_logic_vector;
        divend          : out    vl_logic;
        q               : out    vl_logic_vector;
        r               : out    vl_logic_vector
    );
end divider;
