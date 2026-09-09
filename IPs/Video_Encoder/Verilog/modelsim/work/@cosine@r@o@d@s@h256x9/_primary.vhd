library verilog;
use verilog.vl_types.all;
entity CosineRODSH256x9 is
    generic(
        BITS            : integer := 9;
        word_depth      : integer := 256;
        addr_width      : integer := 8
    );
    port(
        Q               : out    vl_logic_vector(8 downto 0);
        CLK             : in     vl_logic;
        CEN             : in     vl_logic;
        A               : in     vl_logic_vector(7 downto 0)
    );
end CosineRODSH256x9;
