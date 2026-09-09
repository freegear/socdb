library verilog;
use verilog.vl_types.all;
entity DS202 is
    port(
        A               : in     vl_logic_vector(19 downto 0);
        B               : in     vl_logic_vector(19 downto 0);
        S               : in     vl_logic;
        Y               : out    vl_logic_vector(19 downto 0)
    );
end DS202;
