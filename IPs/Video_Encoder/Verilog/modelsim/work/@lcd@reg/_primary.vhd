library verilog;
use verilog.vl_types.all;
entity LcdReg is
    port(
        LCDCLK          : in     vl_logic;
        nRST            : in     vl_logic;
        VIDControlPCLK  : in     vl_logic_vector(31 downto 0);
        LCDTiming0PCLK  : in     vl_logic_vector(31 downto 0);
        LCDTiming1PCLK  : in     vl_logic_vector(31 downto 0);
        LCDTiming2PCLK  : in     vl_logic_vector(31 downto 0);
        LCDTiming3PCLK  : in     vl_logic_vector(31 downto 0);
        LCDControlPCLK  : in     vl_logic_vector(31 downto 0);
        LcdEn           : out    vl_logic;
        LcdBPP          : out    vl_logic_vector(1 downto 0);
        BGR             : out    vl_logic;
        LcdPwrEn        : out    vl_logic;
        HSW             : out    vl_logic_vector(8 downto 0);
        HFP             : out    vl_logic_vector(7 downto 0);
        HBP             : out    vl_logic_vector(7 downto 0);
        LPS             : out    vl_logic_vector(10 downto 0);
        VSW             : out    vl_logic_vector(5 downto 0);
        VFP             : out    vl_logic_vector(7 downto 0);
        VBP             : out    vl_logic_vector(7 downto 0);
        IVS             : out    vl_logic;
        IHS             : out    vl_logic;
        IEO             : out    vl_logic;
        CPL             : out    vl_logic_vector(10 downto 0)
    );
end LcdReg;
