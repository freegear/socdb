library verilog;
use verilog.vl_types.all;
entity CS22 is
    port(
        PN              : in     vl_logic_vector(21 downto 0);
        GN              : in     vl_logic_vector(21 downto 0);
        S               : out    vl_logic_vector(21 downto 0);
        CO              : out    vl_logic
    );
end CS22;
