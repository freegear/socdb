library verilog;
use verilog.vl_types.all;
entity SspTxFCntl is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        TXIM            : in     vl_logic;
        SSPDRWr         : in     vl_logic;
        TxFRdPtrIncSync : in     vl_logic;
        TxRxBSYSync     : in     vl_logic;
        TxDMALevel      : in     vl_logic_vector(3 downto 0);
        TNF             : out    vl_logic;
        TFE             : out    vl_logic;
        BSY             : out    vl_logic;
        TXRIS           : out    vl_logic;
        TXMIS           : out    vl_logic;
        FIFOLTE7Full    : out    vl_logic;
        RegFileWrEn     : out    vl_logic;
        TxDataAvlbl     : out    vl_logic;
        WrPtr           : out    vl_logic_vector(2 downto 0);
        RdPtr           : out    vl_logic_vector(2 downto 0);
        TxFFillLevel    : out    vl_logic_vector(3 downto 0)
    );
end SspTxFCntl;
