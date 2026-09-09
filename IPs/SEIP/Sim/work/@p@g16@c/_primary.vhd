library verilog;
use verilog.vl_types.all;
entity PG16C is
    port(
        A               : in     vl_logic_vector(15 downto 0);
        B               : in     vl_logic_vector(15 downto 0);
        CI              : in     vl_logic;
        GN              : out    vl_logic_vector(15 downto 0);
        PN              : out    vl_logic_vector(15 downto 0)
    );
end PG16C;
