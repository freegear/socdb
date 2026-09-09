library verilog;
use verilog.vl_types.all;
entity ADD08 is
    port(
        A               : in     vl_logic_vector(7 downto 0);
        B               : in     vl_logic_vector(7 downto 0);
        S               : out    vl_logic_vector(7 downto 0);
        CO              : out    vl_logic
    );
end ADD08;
