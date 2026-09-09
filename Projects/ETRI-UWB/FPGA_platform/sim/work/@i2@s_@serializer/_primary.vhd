library verilog;
use verilog.vl_types.all;
entity I2S_Serializer is
    port(
        CLK             : in     vl_logic;
        RESETn          : in     vl_logic;
        Enabled         : in     vl_logic;
        SyncReset       : in     vl_logic;
        WordLength      : in     vl_logic_vector(1 downto 0);
        LeftJust        : in     vl_logic;
        FifoUnderRun    : out    vl_logic;
        FrameStart      : in     vl_logic;
        RightStart      : in     vl_logic;
        BCLKFall        : in     vl_logic;
        SDOUT           : out    vl_logic;
        FifoData        : in     vl_logic_vector(31 downto 0);
        FifoAfford2Read : in     vl_logic;
        FifoEmpty       : in     vl_logic;
        nFifoReadEn     : out    vl_logic
    );
end I2S_Serializer;
