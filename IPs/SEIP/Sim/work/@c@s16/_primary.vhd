library verilog;
use verilog.vl_types.all;
entity CS16 is
    port(
        PN              : in     vl_logic_vector(15 downto 0);
        GN              : in     vl_logic_vector(15 downto 0);
        S               : out    vl_logic_vector(15 downto 0);
        CO              : out    vl_logic
    );
end CS16;
