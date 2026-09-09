library verilog;
use verilog.vl_types.all;
entity NFDFIFO is
    generic(
        FIFOSIZE        : integer := 32
    );
    port(
        Clk             : in     vl_logic;
        nRst            : in     vl_logic;
        FIFOFlushIn     : in     vl_logic;
        FIFOLevelIn     : in     vl_logic_vector(2 downto 0);
        FIFOWrEnIn      : in     vl_logic;
        FIFORdEnIn      : in     vl_logic;
        FIFOWrDataIn    : in     vl_logic_vector(15 downto 0);
        FIFORdDataOut   : out    vl_logic_vector(15 downto 0);
        FIFOCnt1        : out    vl_logic_vector(3 downto 0);
        FIFOCnt0        : out    vl_logic_vector(3 downto 0);
        WrRdyOut        : out    vl_logic;
        RdRdyOut        : out    vl_logic;
        BeforeFullOut   : out    vl_logic;
        FIFOFullOut     : out    vl_logic;
        FIFOHalfFullOut : out    vl_logic;
        FIFORdReadyOut  : out    vl_logic;
        FIFOEmpty1Out   : out    vl_logic;
        FIFOEmpty0Out   : out    vl_logic
    );
end NFDFIFO;
