library verilog;
use verilog.vl_types.all;
entity ScFIFO16x32 is
    generic(
        FIFO_AW         : integer := 4;
        FIFO_ML         : integer := 4;
        FIFO_DW         : integer := 32
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
        FIFOEmptyWr     : out    vl_logic
    );
end ScFIFO16x32;
