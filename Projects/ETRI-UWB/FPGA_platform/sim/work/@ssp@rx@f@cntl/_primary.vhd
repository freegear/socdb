library verilog;
use verilog.vl_types.all;
entity SspRxFCntl is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        RXIM            : in     vl_logic;
        RORIM           : in     vl_logic;
        RORIC           : in     vl_logic;
        RxFWrSync       : in     vl_logic;
        RxFRdPtrInc     : in     vl_logic;
        RxDMALevel      : in     vl_logic_vector(3 downto 0);
        RNE             : out    vl_logic;
        RFF             : out    vl_logic;
        RXRIS           : out    vl_logic;
        RORRIS          : out    vl_logic;
        RXMIS           : out    vl_logic;
        RORMIS          : out    vl_logic;
        RegFileWrEn     : out    vl_logic;
        WrPtr           : out    vl_logic_vector(2 downto 0);
        RdPtr           : out    vl_logic_vector(2 downto 0);
        RxFFillLevel    : out    vl_logic_vector(3 downto 0)
    );
end SspRxFCntl;
