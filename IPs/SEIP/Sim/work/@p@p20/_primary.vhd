library verilog;
use verilog.vl_types.all;
entity PP20 is
    port(
        AN              : in     vl_logic_vector(19 downto 0);
        B1N             : in     vl_logic;
        B0N             : in     vl_logic;
        B_1N            : in     vl_logic;
        PP              : out    vl_logic_vector(20 downto 0);
        AD1             : out    vl_logic
    );
end PP20;
