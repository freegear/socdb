library verilog;
use verilog.vl_types.all;
entity rf2sh32x32 is
    generic(
        bits            : integer := 32;
        word_depth      : integer := 32;
        addr_width      : integer := 5
    );
    port(
        qa              : out    vl_logic_vector(31 downto 0);
        aa              : in     vl_logic_vector(4 downto 0);
        clka            : in     vl_logic;
        cena            : in     vl_logic;
        ab              : in     vl_logic_vector(4 downto 0);
        db              : in     vl_logic_vector(31 downto 0);
        clkb            : in     vl_logic;
        cenb            : in     vl_logic
    );
end rf2sh32x32;
