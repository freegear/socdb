library verilog;
use verilog.vl_types.all;
entity INV49 is
    port(
        A               : in     vl_logic_vector(3 downto 0);
        INV             : in     vl_logic;
        Y               : out    vl_logic_vector(8 downto 0)
    );
end INV49;
