library verilog;
use verilog.vl_types.all;
entity alu is
    port(
        operand1        : in     vl_logic_vector(31 downto 0);
        operand2        : in     vl_logic_vector(31 downto 0);
        operation       : in     vl_logic_vector(1 downto 0);
        result_low      : out    vl_logic_vector(31 downto 0);
        result_high     : out    vl_logic_vector(31 downto 0)
    );
end alu;
