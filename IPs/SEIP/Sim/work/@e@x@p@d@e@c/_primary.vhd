library verilog;
use verilog.vl_types.all;
entity EXPDEC is
    port(
        A0              : in     vl_logic;
        A1              : in     vl_logic;
        Y               : out    vl_logic_vector(5 downto 0);
        INV             : out    vl_logic;
        SFT             : out    vl_logic
    );
end EXPDEC;
