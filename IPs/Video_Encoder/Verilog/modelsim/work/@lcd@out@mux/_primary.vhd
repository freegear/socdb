library verilog;
use verilog.vl_types.all;
entity LcdOutMux is
    port(
        LCDCLK          : in     vl_logic;
        nRST            : in     vl_logic;
        LcdBPP          : in     vl_logic_vector(1 downto 0);
        LcdBGR          : in     vl_logic;
        CLPOWERint      : in     vl_logic;
        PixelRed        : in     vl_logic_vector(7 downto 0);
        PixelGreen      : in     vl_logic_vector(7 downto 0);
        PixelBlue       : in     vl_logic_vector(7 downto 0);
        LCDLDint        : out    vl_logic_vector(23 downto 0)
    );
end LcdOutMux;
