library verilog;
use verilog.vl_types.all;
entity NFTop is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PADDR           : in     vl_logic_vector(6 downto 2);
        PSEL            : in     vl_logic;
        PENABLE         : in     vl_logic;
        PWRITE          : in     vl_logic;
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        NFDMAReqOut     : out    vl_logic;
        NFINTOut        : out    vl_logic;
        NFBootPinIn     : in     vl_logic;
        IOWidthPinIn    : in     vl_logic;
        NandWidthPinIn  : in     vl_logic;
        BootCfgPinIn    : in     vl_logic_vector(1 downto 0);
        OutDtmnPinIn    : in     vl_logic;
        AddrCnt         : out    vl_logic_vector(11 downto 0);
        NFDataIn        : in     vl_logic_vector(15 downto 0);
        NFDataOut       : out    vl_logic_vector(15 downto 0);
        NFDataOutEn     : out    vl_logic;
        CLE             : out    vl_logic;
        ALE             : out    vl_logic;
        nNFCE1          : out    vl_logic;
        nNFCE0          : out    vl_logic;
        nNFRE           : out    vl_logic;
        nNFWE           : out    vl_logic;
        RnB1            : in     vl_logic;
        RnB0            : in     vl_logic
    );
end NFTop;
