library verilog;
use verilog.vl_types.all;
entity PPLSB is
    port(
        AN              : in     vl_logic_vector(15 downto 0);
        B1N             : in     vl_logic;
        B0N             : in     vl_logic;
        PP              : out    vl_logic_vector(16 downto 0)
    );
end PPLSB;
