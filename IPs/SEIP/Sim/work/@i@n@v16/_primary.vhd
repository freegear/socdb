library verilog;
use verilog.vl_types.all;
entity INV16 is
    port(
        A               : in     vl_logic_vector(15 downto 0);
        INV             : in     vl_logic;
        Y               : out    vl_logic_vector(15 downto 0)
    );
end INV16;
