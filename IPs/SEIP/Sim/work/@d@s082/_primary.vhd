library verilog;
use verilog.vl_types.all;
entity DS082 is
    port(
        B               : in     vl_logic_vector(7 downto 0);
        A               : in     vl_logic_vector(7 downto 0);
        S               : in     vl_logic;
        Y               : out    vl_logic_vector(7 downto 0)
    );
end DS082;
