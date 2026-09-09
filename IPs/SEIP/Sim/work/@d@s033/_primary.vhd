library verilog;
use verilog.vl_types.all;
entity DS033 is
    port(
        A               : in     vl_logic_vector(2 downto 0);
        B               : in     vl_logic_vector(2 downto 0);
        C               : in     vl_logic_vector(2 downto 0);
        S1              : in     vl_logic;
        S0              : in     vl_logic;
        Y               : out    vl_logic_vector(2 downto 0)
    );
end DS033;
