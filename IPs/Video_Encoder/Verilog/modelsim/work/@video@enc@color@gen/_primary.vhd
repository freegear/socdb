library verilog;
use verilog.vl_types.all;
entity VideoEncColorGen is
    generic(
        ACTIVE_TOTAL_PIXEL_NTSC: integer := 1440;
        ACTIVE_TOTAL_PIXEL_PAL: integer := 1440;
        ACTIVE_TOTAL_PIXEL_SQ_NTSC: integer := 1280;
        ACTIVE_TOTAL_PIXEL_SQ_PAL: integer := 1536;
        ACTIVE_STEP_NTSC: integer := 205;
        ACTIVE_STEP_PAL : integer := 205;
        ACTIVE_STEP_SQ_NTSC: integer := 182;
        ACTIVE_STEP_SQ_PAL: integer := 219
    );
    port(
        CLK             : in     vl_logic;
        RESETn          : in     vl_logic;
        ACT_DISPLAY_INTER: in     vl_logic;
        COLOR_PATTERN_MODE: in     vl_logic_vector(1 downto 0);
        EN_SQPIXEL      : in     vl_logic;
        NTSC_PAL        : in     vl_logic;
        EN_INTERNAL_PATTERN: in     vl_logic;
        Rgen            : out    vl_logic_vector(7 downto 0);
        Ggen            : out    vl_logic_vector(7 downto 0);
        Bgen            : out    vl_logic_vector(7 downto 0)
    );
end VideoEncColorGen;
