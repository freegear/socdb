library verilog;
use verilog.vl_types.all;
entity PlaneGamma is
    port(
        Clk             : in     vl_logic;
        nRST            : in     vl_logic;
        GammaEn         : in     vl_logic;
        RegGamma10      : in     vl_logic_vector(23 downto 0);
        RegGamma0F      : in     vl_logic_vector(23 downto 0);
        RegGamma0E      : in     vl_logic_vector(23 downto 0);
        RegGamma0D      : in     vl_logic_vector(23 downto 0);
        RegGamma0C      : in     vl_logic_vector(23 downto 0);
        RegGamma0B      : in     vl_logic_vector(23 downto 0);
        RegGamma0A      : in     vl_logic_vector(23 downto 0);
        RegGamma09      : in     vl_logic_vector(23 downto 0);
        RegGamma08      : in     vl_logic_vector(23 downto 0);
        RegGamma07      : in     vl_logic_vector(23 downto 0);
        RegGamma06      : in     vl_logic_vector(23 downto 0);
        RegGamma05      : in     vl_logic_vector(23 downto 0);
        RegGamma04      : in     vl_logic_vector(23 downto 0);
        RegGamma03      : in     vl_logic_vector(23 downto 0);
        RegGamma02      : in     vl_logic_vector(23 downto 0);
        RegGamma01      : in     vl_logic_vector(23 downto 0);
        RegGamma00      : in     vl_logic_vector(23 downto 0);
        GammaValidIn    : in     vl_logic;
        RGammaIn        : in     vl_logic_vector(7 downto 0);
        GGammaIn        : in     vl_logic_vector(7 downto 0);
        BGammaIn        : in     vl_logic_vector(7 downto 0);
        GammaValidOut   : out    vl_logic;
        RGammaOut       : out    vl_logic_vector(7 downto 0);
        GGammaOut       : out    vl_logic_vector(7 downto 0);
        BGammaOut       : out    vl_logic_vector(7 downto 0)
    );
end PlaneGamma;
