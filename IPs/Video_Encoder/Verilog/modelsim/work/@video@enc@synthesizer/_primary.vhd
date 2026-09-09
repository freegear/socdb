library verilog;
use verilog.vl_types.all;
entity VideoEncSynthesizer is
    generic(
        NTSCM           : integer := 0;
        NTSCJ           : integer := 1;
        NTSC4           : integer := 2;
        PALM            : integer := 3;
        PAL             : integer := 4;
        PALNc           : integer := 5;
        PALN            : integer := 6;
        BLACK_VALUE_75  : integer := 282;
        BLACK_VALUE_NORMAL: integer := 252;
        BLANK_VALUE_NTSC: integer := 240;
        BLANK_VALUE_PAL : integer := 252;
        HSYNC_SLOPE_NTSC: integer := 4;
        HSYNC_SLOPE_PAL : integer := 7;
        BURST_MAX_NTSC  : integer := 112;
        BURST_MAX_PAL   : integer := 117;
        HSYNC_STEP_NTSC3: integer := 16;
        HSYNC_STEP_PAL6 : integer := 16
    );
    port(
        CLK             : in     vl_logic;
        RESETn          : in     vl_logic;
        HSYNC_ENABLE    : in     vl_logic;
        BURST_ENABLE    : in     vl_logic;
        ACT_DISPLAY_SYN : in     vl_logic;
        EN_COLOR_KILL   : in     vl_logic;
        Filtered_Y      : in     vl_logic_vector(9 downto 0);
        Filtered_U      : in     vl_logic_vector(9 downto 0);
        Filtered_V      : in     vl_logic_vector(9 downto 0);
        CHRO_DELAY      : in     vl_logic_vector(2 downto 0);
        LUMA_DELAY      : in     vl_logic_vector(2 downto 0);
        NTSC_PAL        : in     vl_logic;
        BURST_NTSC_PAL  : in     vl_logic;
        OUT_MODE        : in     vl_logic_vector(2 downto 0);
        BURST_ID        : in     vl_logic;
        SIN             : in     vl_logic_vector(10 downto 0);
        COS             : in     vl_logic_vector(10 downto 0);
        Composite2DAC0  : out    vl_logic_vector(9 downto 0);
        Y2DAC1          : out    vl_logic_vector(9 downto 0);
        C2DAC2          : out    vl_logic_vector(9 downto 0)
    );
end VideoEncSynthesizer;
