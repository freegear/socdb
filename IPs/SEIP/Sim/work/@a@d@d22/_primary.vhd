library verilog;
use verilog.vl_types.all;
entity ADD22 is
    port(
        A               : in     vl_logic_vector(21 downto 0);
        B               : in     vl_logic_vector(21 downto 0);
        S               : out    vl_logic_vector(21 downto 0);
        CO              : out    vl_logic
    );
end ADD22;
