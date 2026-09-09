library verilog;
use verilog.vl_types.all;
entity DC08B is
    port(
        A               : in     vl_logic_vector(2 downto 0);
        Y               : out    vl_logic_vector(7 downto 0)
    );
end DC08B;
