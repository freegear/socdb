library verilog;
use verilog.vl_types.all;
entity I2S_FIFO is
    generic(
        FIFO_DEPTH      : integer := 5;
        DATA_WIDTH      : integer := 32
    );
    port(
        CLK             : in     vl_logic;
        RESETn          : in     vl_logic;
        nReadEnable     : in     vl_logic;
        ReadData        : out    vl_logic_vector;
        nWriteEnable    : in     vl_logic;
        WriteData       : in     vl_logic_vector;
        SyncReset       : in     vl_logic;
        Full            : out    vl_logic;
        Empty           : out    vl_logic;
        Afford2Write    : out    vl_logic;
        Afford2Read     : out    vl_logic;
        FillLevel       : out    vl_logic_vector
    );
end I2S_FIFO;
