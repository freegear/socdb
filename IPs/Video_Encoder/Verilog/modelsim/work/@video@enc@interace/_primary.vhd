library verilog;
use verilog.vl_types.all;
entity VideoEncInterace is
    port(
        HSYNCn          : in     vl_logic;
        VSYNCn          : in     vl_logic;
        BLANKn          : in     vl_logic;
        Rin             : in     vl_logic_vector(7 downto 0);
        Gin             : in     vl_logic_vector(7 downto 0);
        Bin             : in     vl_logic_vector(7 downto 0);
        ENABLE_PIXEL    : out    vl_logic;
        ACT_DISPLAY_INTER: in     vl_logic;
        Rout            : out    vl_logic_vector(7 downto 0);
        Gout            : out    vl_logic_vector(7 downto 0);
        Bout            : out    vl_logic_vector(7 downto 0)
    );
end VideoEncInterace;
