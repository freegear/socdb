library verilog;
use verilog.vl_types.all;
entity MPX24 is
    port(
        S               : in     vl_logic_vector(4 downto 0);
        A               : in     vl_logic_vector(23 downto 0);
        Y               : out    vl_logic
    );
end MPX24;
