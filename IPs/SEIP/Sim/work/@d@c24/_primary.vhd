library verilog;
use verilog.vl_types.all;
entity DC24 is
    port(
        A               : in     vl_logic_vector(4 downto 0);
        EN              : in     vl_logic;
        Y               : out    vl_logic_vector(23 downto 0)
    );
end DC24;
