library verilog;
use verilog.vl_types.all;
entity DS203 is
    port(
        B               : in     vl_logic_vector(19 downto 0);
        A               : in     vl_logic_vector(19 downto 0);
        C               : in     vl_logic_vector(19 downto 0);
        S2              : in     vl_logic;
        S1              : in     vl_logic;
        Y               : out    vl_logic_vector(19 downto 0)
    );
end DS203;
