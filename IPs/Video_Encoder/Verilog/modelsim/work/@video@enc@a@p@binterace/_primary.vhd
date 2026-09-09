library verilog;
use verilog.vl_types.all;
entity VideoEncAPBinterace is
    generic(
        StepNTSC        : integer := 569408543;
        StepPALM        : integer := 568782819;
        StepNTSC4       : integer := 705268427;
        StepPALNc       : integer := 569807942;
        NTSCM           : integer := 0;
        NTSCJ           : integer := 1;
        NTSC4           : integer := 2;
        PALM            : integer := 3;
        PAL             : integer := 4;
        PALNc           : integer := 5;
        PALN            : integer := 6
    );
    port(
        ACLK            : in     vl_logic;
        ARESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(5 downto 2);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        CLK             : in     vl_logic;
        FIELD_CNT       : in     vl_logic_vector(7 downto 0);
        H_CNT           : in     vl_logic_vector(10 downto 0);
        V_CNT           : in     vl_logic_vector(9 downto 0);
        ENABLE          : out    vl_logic;
        EN_DAC0         : out    vl_logic;
        EN_DAC1         : out    vl_logic;
        EN_DAC2         : out    vl_logic;
        EN_SQPIXEL      : out    vl_logic;
        EN_NONINTERLACE : out    vl_logic;
        EN_RESET_SCH    : out    vl_logic;
        EN_INTERNAL_PATTERN: out    vl_logic;
        EN_COLOR_KILL   : out    vl_logic;
        OUT_MODE        : out    vl_logic_vector(2 downto 0);
        COLOR_PATTERN_MODE: out    vl_logic_vector(1 downto 0);
        LUMA_FILTER_SEL : out    vl_logic_vector(1 downto 0);
        CHRO_FILTER_SEL : out    vl_logic_vector(1 downto 0);
        CHRO_DELAY      : out    vl_logic_vector(2 downto 0);
        LUMA_DELAY      : out    vl_logic_vector(2 downto 0);
        BURST_WID       : out    vl_logic_vector(1 downto 0);
        HSYNC_WID       : out    vl_logic_vector(2 downto 0);
        SUB_PHASE       : out    vl_logic_vector(15 downto 0);
        SUB_REQ         : out    vl_logic_vector(31 downto 0)
    );
end VideoEncAPBinterace;
