library verilog;
use verilog.vl_types.all;
entity NFTop is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        EXT_SFR_ADDR    : in     vl_logic_vector(7 downto 0);
        EXT_SFR_WR      : in     vl_logic;
        EXT_SFR_DOUT    : in     vl_logic_vector(7 downto 0);
        EXT_SFR_DIN     : out    vl_logic_vector(7 downto 0);
        CS              : in     vl_logic;
        WDATA           : in     vl_logic_vector(7 downto 0);
        RDATA           : out    vl_logic_vector(7 downto 0);
        We              : in     vl_logic;
        Oe              : in     vl_logic;
        NFDMAReqOut     : out    vl_logic;
        NFINTOut        : out    vl_logic;
        NFDataIn        : in     vl_logic_vector(15 downto 0);
        NFDataOut       : out    vl_logic_vector(15 downto 0);
        NFDataOutEn     : out    vl_logic;
        CLE             : out    vl_logic;
        ALE             : out    vl_logic;
        nNFCE3          : out    vl_logic;
        nNFCE2          : out    vl_logic;
        nNFCE1          : out    vl_logic;
        nNFCE0          : out    vl_logic;
        nNFRE           : out    vl_logic;
        nNFWE           : out    vl_logic;
        RnB3            : in     vl_logic;
        RnB2            : in     vl_logic;
        RnB1            : in     vl_logic;
        RnB0            : in     vl_logic
    );
end NFTop;
