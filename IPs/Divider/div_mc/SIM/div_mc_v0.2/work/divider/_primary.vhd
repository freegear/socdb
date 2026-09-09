library verilog;
use verilog.vl_types.all;
entity divider is
    generic(
        WIDTH_DIVD      : integer := 24;
        WIDTH_DIVS      : integer := 24;
        WIDTH_RSLT      : integer := 24;
        \LOOP\          : integer := 4;
        SM_WIDTH        : integer := 4;
        IDLE            : integer := 0;
        PRES            : integer := 1;
        DIV             : integer := 2;
        POSTS           : integer := 3
    );
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        diven           : in     vl_logic;
        dividend        : in     vl_logic_vector;
        divisor         : in     vl_logic_vector;
        q_hbit          : in     vl_logic_vector(3 downto 0);
        divend          : out    vl_logic;
        q               : out    vl_logic_vector;
        r               : out    vl_logic_vector
    );
end divider;
