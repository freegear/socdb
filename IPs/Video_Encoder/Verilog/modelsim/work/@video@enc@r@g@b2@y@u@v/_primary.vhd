library verilog;
use verilog.vl_types.all;
entity VideoEncRGB2YUV is
    generic(
        R_YPARA_NTSC    : integer := 155;
        G_YPARA_NTSC    : integer := 304;
        B_YPARA_NTSC    : integer := 59;
        R_UPARA_NTSC    : integer := 76;
        G_UPARA_NTSC    : integer := 150;
        B_UPARA_NTSC    : integer := 226;
        R_VPARA_NTSC    : integer := 319;
        G_VPARA_NTSC    : integer := 267;
        B_VPARA_NTSC    : integer := 52;
        R_YPARA_NTSCJ   : integer := 168;
        G_YPARA_NTSCJ   : integer := 329;
        B_YPARA_NTSCJ   : integer := 63;
        R_UPARA_NTSCJ   : integer := 82;
        G_UPARA_NTSCJ   : integer := 163;
        B_UPARA_NTSCJ   : integer := 245;
        R_VPARA_NTSCJ   : integer := 345;
        G_VPARA_NTSCJ   : integer := 289;
        B_VPARA_NTSCJ   : integer := 56;
        R_YPARA_PAL     : integer := 164;
        G_YPARA_PAL     : integer := 322;
        B_YPARA_PAL     : integer := 62;
        R_UPARA_PAL     : integer := 81;
        G_UPARA_PAL     : integer := 159;
        B_UPARA_PAL     : integer := 240;
        R_VPARA_PAL     : integer := 337;
        G_VPARA_PAL     : integer := 282;
        B_VPARA_PAL     : integer := 55;
        NTSCM           : integer := 0;
        NTSCJ           : integer := 1;
        NTSC4           : integer := 2;
        PALM            : integer := 3;
        PAL             : integer := 4;
        PALNc           : integer := 5;
        PALN            : integer := 6
    );
    port(
        CLK             : in     vl_logic;
        RESETn          : in     vl_logic;
        EN_INTERNAL_PATTERN: in     vl_logic;
        Rin             : in     vl_logic_vector(7 downto 0);
        Gin             : in     vl_logic_vector(7 downto 0);
        Bin             : in     vl_logic_vector(7 downto 0);
        Rgen            : in     vl_logic_vector(7 downto 0);
        Ggen            : in     vl_logic_vector(7 downto 0);
        Bgen            : in     vl_logic_vector(7 downto 0);
        OUT_MODE        : in     vl_logic_vector(2 downto 0);
        Y               : out    vl_logic_vector(9 downto 0);
        U               : out    vl_logic_vector(9 downto 0);
        V               : out    vl_logic_vector(9 downto 0)
    );
end VideoEncRGB2YUV;
