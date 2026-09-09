library verilog;
use verilog.vl_types.all;
entity SspMTxRxCntl is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        DSS             : in     vl_logic_vector(3 downto 0);
        FRF             : in     vl_logic_vector(1 downto 0);
        SCR             : in     vl_logic_vector(7 downto 0);
        SPO             : in     vl_logic;
        SPH             : in     vl_logic;
        SSESync         : in     vl_logic;
        SSPCLKDIV       : in     vl_logic;
        TxDataAvlblSync : in     vl_logic;
        TxFRdDataIn     : in     vl_logic_vector(15 downto 0);
        IntSSPRXD       : in     vl_logic;
        MSSync          : in     vl_logic;
        NextnSOE        : in     vl_logic;
        NextSTXD        : in     vl_logic;
        NextSRxFWr      : in     vl_logic;
        NxtSTxFRdPtrInc : in     vl_logic;
        NextSTxRxBSY    : in     vl_logic;
        RNESync         : in     vl_logic;
        CLKOUT          : out    vl_logic;
        FSSOUT          : out    vl_logic;
        TXD             : out    vl_logic;
        nCTLOE          : out    vl_logic;
        nOE             : out    vl_logic;
        TxFRdPtrInc     : out    vl_logic;
        RxFWr           : out    vl_logic;
        MRxFWrData      : out    vl_logic_vector(15 downto 0);
        TxRxBSY         : out    vl_logic;
        MRxRT           : out    vl_logic;
        IncRxTimeOut    : out    vl_logic
    );
end SspMTxRxCntl;
