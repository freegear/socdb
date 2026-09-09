library verilog;
use verilog.vl_types.all;
entity EWADEC is
    port(
        A               : in     vl_logic_vector(3 downto 0);
        Y               : out    vl_logic
    );
end EWADEC;
