library verilog;
use verilog.vl_types.all;
entity regfile is
    port(
        reset           : in     vl_logic;
        clock           : in     vl_logic;
        write           : in     vl_logic;
        clock_enb       : in     vl_logic;
        address         : in     vl_logic_vector(2 downto 0);
        read_data       : out    vl_logic_vector(31 downto 0);
        operand1        : out    vl_logic_vector(31 downto 0);
        operand2        : out    vl_logic_vector(31 downto 0);
        operation       : out    vl_logic_vector(31 downto 0);
        result_low      : in     vl_logic_vector(31 downto 0);
        result_high     : in     vl_logic_vector(31 downto 0);
        write_data      : in     vl_logic_vector(31 downto 0)
    );
end regfile;
