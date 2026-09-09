library verilog;
use verilog.vl_types.all;
entity CS24D is
    port(
        PN              : in     vl_logic_vector(23 downto 0);
        GN              : in     vl_logic_vector(23 downto 0);
        S               : out    vl_logic_vector(23 downto 0);
        CO              : out    vl_logic
    );
end CS24D;
