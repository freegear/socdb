library verilog;
use verilog.vl_types.all;
entity DS103 is
    port(
        B               : in     vl_logic_vector(9 downto 0);
        A               : in     vl_logic_vector(9 downto 0);
        C               : in     vl_logic_vector(9 downto 0);
        S2              : in     vl_logic;
        S1              : in     vl_logic;
        Y               : out    vl_logic_vector(9 downto 0)
    );
end DS103;
