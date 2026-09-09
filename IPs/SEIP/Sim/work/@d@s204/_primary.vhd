library verilog;
use verilog.vl_types.all;
entity DS204 is
    port(
        A               : in     vl_logic_vector(19 downto 0);
        B               : in     vl_logic_vector(19 downto 0);
        C               : in     vl_logic_vector(19 downto 0);
        D               : in     vl_logic_vector(19 downto 0);
        S1              : in     vl_logic;
        S0              : in     vl_logic;
        Y               : out    vl_logic_vector(19 downto 0)
    );
end DS204;
