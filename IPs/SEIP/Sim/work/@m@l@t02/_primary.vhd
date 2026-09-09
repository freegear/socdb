library verilog;
use verilog.vl_types.all;
entity MLT02 is
    port(
        A               : in     vl_logic_vector(15 downto 0);
        B               : in     vl_logic_vector(9 downto 0);
        P               : out    vl_logic_vector(23 downto 2);
        P24             : out    vl_logic;
        P25             : out    vl_logic
    );
end MLT02;
