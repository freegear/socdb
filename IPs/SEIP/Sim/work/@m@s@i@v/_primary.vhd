library verilog;
use verilog.vl_types.all;
entity MSIV is
    port(
        A               : in     vl_logic_vector(3 downto 0);
        Y               : out    vl_logic_vector(3 downto 0)
    );
end MSIV;
