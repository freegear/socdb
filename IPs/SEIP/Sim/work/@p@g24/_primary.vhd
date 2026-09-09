library verilog;
use verilog.vl_types.all;
entity PG24 is
    port(
        A               : in     vl_logic_vector(23 downto 0);
        B               : in     vl_logic_vector(23 downto 0);
        GN              : out    vl_logic_vector(23 downto 0);
        PN              : out    vl_logic_vector(23 downto 0)
    );
end PG24;
