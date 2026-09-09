library verilog;
use verilog.vl_types.all;
entity I2cCore is
    port(
        CLK             : in     vl_logic;
        NRST            : in     vl_logic;
        ISCL            : in     vl_logic;
        ISDA            : in     vl_logic;
        CCR             : in     vl_logic_vector(6 downto 0);
        SlaveAddr       : in     vl_logic_vector(6 downto 0);
        ExtSlaveAddr    : in     vl_logic_vector(7 downto 0);
        WriteData       : in     vl_logic_vector(7 downto 0);
        Enab            : in     vl_logic;
        GCEnab          : in     vl_logic;
        STA             : in     vl_logic;
        STP             : in     vl_logic;
        IFLG            : in     vl_logic;
        AAK             : in     vl_logic;
        SoftReset       : in     vl_logic;
        Status          : out    vl_logic_vector(7 downto 3);
        ReadData        : out    vl_logic_vector(7 downto 0);
        SetIFLG         : out    vl_logic;
        ClearSTA        : out    vl_logic;
        ClearSTP        : out    vl_logic;
        OSCL            : out    vl_logic;
        OSDA            : out    vl_logic
    );
end I2cCore;
