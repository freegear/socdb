library verilog;
use verilog.vl_types.all;
entity PcmFIFO is
    generic(
        FIFO_AW         : integer := 3;
        FIFO_DW         : integer := 32;
        RXAW            : integer := 3;
        TXAW            : integer := 3;
        RXCON           : integer := 2048;
        RXSTS           : integer := 2049;
        RXDAT           : integer := 2050;
        TXCON           : integer := 2052;
        TXSTS           : integer := 2053;
        TXDAT           : integer := 2054
    );
    port(
        Clk             : in     vl_logic;
        nRST            : in     vl_logic;
        FIFOWrite       : in     vl_logic;
        FIFOWrData      : in     vl_logic_vector;
        FIFORead        : in     vl_logic;
        FIFORdData      : out    vl_logic_vector;
        FIFOFlush       : in     vl_logic;
        FIFOFull        : out    vl_logic;
        FIFOHalfFull    : out    vl_logic;
        FIFOAlmostEmpty : out    vl_logic;
        FIFOEmpty       : out    vl_logic;
        FIFOEmptyWr     : out    vl_logic;
        FIFODataCnt     : out    vl_logic_vector
    );
end PcmFIFO;
