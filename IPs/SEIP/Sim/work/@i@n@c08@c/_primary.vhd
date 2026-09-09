library verilog;
use verilog.vl_types.all;
entity INC08C is
    port(
        D               : in     vl_logic_vector(7 downto 0);
        CI              : in     vl_logic;
        S               : out    vl_logic_vector(7 downto 0);
        CO              : out    vl_logic
    );
end INC08C;
