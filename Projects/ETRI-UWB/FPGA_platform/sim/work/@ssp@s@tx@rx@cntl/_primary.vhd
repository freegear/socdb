library verilog;
use verilog.vl_types.all;
entity SspSTxRxCntl is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        TXD             : in     vl_logic;
        nOE             : in     vl_logic;
        DSS             : in     vl_logic_vector(3 downto 0);
        FRF             : in     vl_logic_vector(1 downto 0);
        SCR             : in     vl_logic_vector(7 downto 0);
        SPO             : in     vl_logic;
        SPH             : in     vl_logic;
        SSPCLKDIV       : in     vl_logic;
        CLKINSync       : in     vl_logic;
        FSSINSync       : in     vl_logic;
        SSESync         : in     vl_logic;
        MSSync          : in     vl_logic;
        SODSync         : in     vl_logic;
        TxFRdDataIn     : in     vl_logic_vector(15 downto 0);
        TxFRdPtrInc     : in     vl_logic;
        RxFWr           : in     vl_logic;
        TxRxBSY         : in     vl_logic;
        IntSSPRXD       : in     vl_logic;
        NxtSTxFRdPtrInc : out    vl_logic;
        NextSTxRxBSY    : out    vl_logic;
        NextSRxFWr      : out    vl_logic;
        NextnSOE        : out    vl_logic;
        NextSTXD        : out    vl_logic;
        SRxFWrData      : out    vl_logic_vector(15 downto 0);
        SRxRT           : out    vl_logic
    );
end SspSTxRxCntl;
