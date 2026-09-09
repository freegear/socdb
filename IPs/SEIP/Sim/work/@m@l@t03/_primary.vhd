library verilog;
use verilog.vl_types.all;
entity MLT03 is
    port(
        A               : in     vl_logic_vector(19 downto 0);
        B               : in     vl_logic_vector(7 downto 0);
        P               : out    vl_logic_vector(21 downto 1);
        P00             : out    vl_logic;
        P22             : out    vl_logic;
        P23             : out    vl_logic
    );
end MLT03;
