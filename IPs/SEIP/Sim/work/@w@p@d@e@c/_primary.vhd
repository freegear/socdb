library verilog;
use verilog.vl_types.all;
entity WPDEC is
    port(
        A               : in     vl_logic_vector(3 downto 0);
        Y3              : out    vl_logic;
        Y2              : out    vl_logic;
        Y1              : out    vl_logic
    );
end WPDEC;
