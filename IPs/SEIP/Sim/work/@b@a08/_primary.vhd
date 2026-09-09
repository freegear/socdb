library verilog;
use verilog.vl_types.all;
entity BA08 is
    port(
        D               : in     vl_logic_vector(7 downto 0);
        EN              : in     vl_logic;
        Y               : out    vl_logic_vector(7 downto 0);
        SF              : out    vl_logic_vector(2 downto 0)
    );
end BA08;
