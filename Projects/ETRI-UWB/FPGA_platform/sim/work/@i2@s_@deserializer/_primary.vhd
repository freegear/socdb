library verilog;
use verilog.vl_types.all;
entity I2S_Deserializer is
    port(
        CLK             : in     vl_logic;
        RESETn          : in     vl_logic;
        Enabled         : in     vl_logic;
        SyncReset       : in     vl_logic;
        WordLength      : in     vl_logic_vector(1 downto 0);
        LeftJust        : in     vl_logic;
        FifoOverRun     : out    vl_logic;
        LRCLK           : in     vl_logic;
        BCLKRise        : in     vl_logic;
        SDIN            : in     vl_logic;
        FifoWData       : out    vl_logic_vector(31 downto 0);
        FifoAfford2Write: in     vl_logic;
        FifoFull        : in     vl_logic;
        nFifoWriteEn    : out    vl_logic
    );
end I2S_Deserializer;
