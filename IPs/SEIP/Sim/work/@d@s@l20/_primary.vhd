library verilog;
use verilog.vl_types.all;
entity DSL20 is
    port(
        A               : in     vl_logic_vector(19 downto 0);
        S               : in     vl_logic;
        Y               : out    vl_logic_vector(19 downto 0)
    );
end DSL20;
