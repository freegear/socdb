library verilog;
use verilog.vl_types.all;
entity I2S_Control is
    generic(
        I2S_RFIFO_DEPTH : integer := 6;
        I2S_TFIFO_DEPTH : integer := 6;
        CLKCTRL_ADDR    : integer := 0;
        CTRL_ADDR       : integer := 1;
        STATUS_ADDR     : integer := 2;
        DATA_ADDR       : integer := 3
    );
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PADDR           : in     vl_logic_vector(3 downto 2);
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        Interrupt       : out    vl_logic;
        TxDMAReq        : out    vl_logic;
        RxDMAReq        : out    vl_logic;
        ClkMS           : out    vl_logic;
        LRClkInv        : out    vl_logic;
        MClkOn          : out    vl_logic;
        MClkOE          : out    vl_logic;
        DTORatio        : out    vl_logic_vector(17 downto 0);
        TxEnabled       : out    vl_logic;
        TxReset         : out    vl_logic;
        TxWordLength    : out    vl_logic_vector(1 downto 0);
        TxLeftJust      : out    vl_logic;
        TxFifoUnderRun  : in     vl_logic;
        RxEnabled       : out    vl_logic;
        RxReset         : out    vl_logic;
        RxWordLength    : out    vl_logic_vector(1 downto 0);
        RxLeftJust      : out    vl_logic;
        RxFifoOverRun   : in     vl_logic;
        TxFifoWData     : out    vl_logic_vector(31 downto 0);
        nTxFifoWriteEn  : out    vl_logic;
        TxFifoFull      : in     vl_logic;
        TxFifoEmpty     : in     vl_logic;
        TxFifoLevel     : in     vl_logic_vector;
        TxFifoAfford2Read: in     vl_logic;
        RxFifoData      : in     vl_logic_vector(31 downto 0);
        nRxFifoReadEn   : out    vl_logic;
        RxFifoFull      : in     vl_logic;
        RxFifoEmpty     : in     vl_logic;
        RxFifoLevel     : in     vl_logic_vector;
        RxFifoAfford2Write: in     vl_logic
    );
end I2S_Control;
