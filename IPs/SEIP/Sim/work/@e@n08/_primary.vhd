library verilog;
use verilog.vl_types.all;
entity EN08 is
    port(
        A               : in     vl_logic_vector(7 downto 0);
        EN              : in     vl_logic;
        Y               : out    vl_logic_vector(7 downto 0)
    );
end EN08;
