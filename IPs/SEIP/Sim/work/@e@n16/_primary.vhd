library verilog;
use verilog.vl_types.all;
entity EN16 is
    port(
        A               : in     vl_logic_vector(15 downto 0);
        EN              : in     vl_logic;
        Y               : out    vl_logic_vector(15 downto 0)
    );
end EN16;
