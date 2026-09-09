library verilog;
use verilog.vl_types.all;
entity RF2SH8x32 is
    generic(
        BITS            : integer := 32;
        word_depth      : integer := 8;
        addr_width      : integer := 3
    );
    port(
        QA              : out    vl_logic_vector(31 downto 0);
        AA              : in     vl_logic_vector(2 downto 0);
        CLKA            : in     vl_logic;
        CENA            : in     vl_logic;
        AB              : in     vl_logic_vector(2 downto 0);
        DB              : in     vl_logic_vector(31 downto 0);
        CLKB            : in     vl_logic;
        CENB            : in     vl_logic
    );
end RF2SH8x32;
