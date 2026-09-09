library verilog;
use verilog.vl_types.all;
entity ScFIFO2048x16 is
    generic(
        FIFO_AW         : integer := 11;
        FIFO_ML         : integer := 2040;
        FIFO_DW         : integer := 16
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
        FIFOAlmostFull  : out    vl_logic;
        FIFOEmpty       : out    vl_logic;
        FIFOEmptyWr     : out    vl_logic
    );
end ScFIFO2048x16;
