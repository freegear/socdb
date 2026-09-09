library verilog;
use verilog.vl_types.all;
entity INC16 is
    port(
        D               : in     vl_logic_vector(15 downto 0);
        CI              : in     vl_logic;
        S               : out    vl_logic_vector(15 downto 0)
    );
end INC16;
