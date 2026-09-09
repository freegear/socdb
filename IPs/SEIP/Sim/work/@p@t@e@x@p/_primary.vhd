library verilog;
use verilog.vl_types.all;
entity PTEXP is
    port(
        P               : in     vl_logic_vector(15 downto 0);
        PH              : out    vl_logic_vector(1 downto 0);
        PL              : out    vl_logic_vector(15 downto 0)
    );
end PTEXP;
