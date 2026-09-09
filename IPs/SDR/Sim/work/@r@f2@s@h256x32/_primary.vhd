library verilog;
use verilog.vl_types.all;
entity RF2SH256x32 is
    generic(
        BITS            : integer := 32;
        word_depth      : integer := 256;
        addr_width      : integer := 8
    );
    port(
        QA              : out    vl_logic_vector(31 downto 0);
        AA              : in     vl_logic_vector(7 downto 0);
        CLKA            : in     vl_logic;
        CENA            : in     vl_logic;
        AB              : in     vl_logic_vector(7 downto 0);
        DB              : in     vl_logic_vector(31 downto 0);
        CLKB            : in     vl_logic;
        CENB            : in     vl_logic
    );
end RF2SH256x32;
