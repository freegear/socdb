library verilog;
use verilog.vl_types.all;
entity dmacrqstsync is
    port(
        hclk            : in     vl_logic;
        hresetn         : in     vl_logic;
        mskddmacbreq    : in     vl_logic_vector(15 downto 0);
        mskddmaclbreq   : in     vl_logic_vector(15 downto 0);
        mskddmacsreq    : in     vl_logic_vector(15 downto 0);
        mskddmaclsreq   : in     vl_logic_vector(15 downto 0);
        dmacbreqsync    : out    vl_logic_vector(15 downto 0);
        dmaclbreqsync   : out    vl_logic_vector(15 downto 0);
        dmacsreqsync    : out    vl_logic_vector(15 downto 0);
        dmaclsreqsync   : out    vl_logic_vector(15 downto 0)
    );
end dmacrqstsync;
