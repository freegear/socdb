library verilog;
use verilog.vl_types.all;
entity LM20 is
    port(
        A               : in     vl_logic_vector(19 downto 0);
        S               : in     vl_logic;
        SG              : in     vl_logic;
        Y               : out    vl_logic_vector(19 downto 0)
    );
end LM20;
