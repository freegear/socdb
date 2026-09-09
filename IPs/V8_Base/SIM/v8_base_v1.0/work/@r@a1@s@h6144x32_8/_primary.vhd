library verilog;
use verilog.vl_types.all;
entity RA1SH6144x32_8 is
    generic(
        BITS            : integer := 32;
        word_depth      : integer := 6144;
        addr_width      : integer := 13;
        mask_width      : integer := 4;
        wp_size         : integer := 8
    );
    port(
        Q               : out    vl_logic_vector(31 downto 0);
        CLK             : in     vl_logic;
        CEN             : in     vl_logic;
        WEN             : in     vl_logic_vector(3 downto 0);
        A               : in     vl_logic_vector(12 downto 0);
        D               : in     vl_logic_vector(31 downto 0);
        OEN             : in     vl_logic
    );
end RA1SH6144x32_8;
