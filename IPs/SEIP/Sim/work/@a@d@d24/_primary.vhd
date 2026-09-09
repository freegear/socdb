library verilog;
use verilog.vl_types.all;
entity ADD24 is
    port(
        A               : in     vl_logic_vector(23 downto 0);
        B               : in     vl_logic_vector(23 downto 0);
        S               : out    vl_logic_vector(23 downto 0)
    );
end ADD24;
