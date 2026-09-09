library verilog;
use verilog.vl_types.all;
entity WMATG is
    port(
        D               : in     vl_logic_vector(4 downto 0);
        EN              : in     vl_logic;
        Y2              : out    vl_logic;
        Y14             : out    vl_logic;
        Y18             : out    vl_logic;
        Y23             : out    vl_logic
    );
end WMATG;
