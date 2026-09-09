library verilog;
use verilog.vl_types.all;
entity SspRxFIFO is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        RXIM            : in     vl_logic;
        RORIM           : in     vl_logic;
        RORIC           : in     vl_logic;
        RxFWrSync       : in     vl_logic;
        RxFRdPtrInc     : in     vl_logic;
        MS              : in     vl_logic;
        SRxFWrData      : in     vl_logic_vector(15 downto 0);
        MRxFWrData      : in     vl_logic_vector(15 downto 0);
        RxDMALevel      : in     vl_logic_vector(3 downto 0);
        RNE             : out    vl_logic;
        RFF             : out    vl_logic;
        RXRIS           : out    vl_logic;
        RORRIS          : out    vl_logic;
        RXMIS           : out    vl_logic;
        RORMIS          : out    vl_logic;
        RxFRdData       : out    vl_logic_vector(15 downto 0);
        RxFFillLevel    : out    vl_logic_vector(3 downto 0)
    );
end SspRxFIFO;
