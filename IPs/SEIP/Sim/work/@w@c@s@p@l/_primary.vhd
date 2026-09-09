library verilog;
use verilog.vl_types.all;
entity WCSPL is
    port(
        A               : in     vl_logic_vector(7 downto 0);
        Y               : out    vl_logic_vector(7 downto 0);
        CT              : out    vl_logic
    );
end WCSPL;
