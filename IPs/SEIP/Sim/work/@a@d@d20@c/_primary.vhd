library verilog;
use verilog.vl_types.all;
entity ADD20C is
    port(
        A               : in     vl_logic_vector(19 downto 0);
        B               : in     vl_logic_vector(19 downto 0);
        CI              : in     vl_logic;
        S               : out    vl_logic_vector(19 downto 0);
        CO              : out    vl_logic
    );
end ADD20C;
