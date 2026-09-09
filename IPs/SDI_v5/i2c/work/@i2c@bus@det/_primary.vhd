library verilog;
use verilog.vl_types.all;
entity I2cBusDet is
    port(
        CLK             : in     vl_logic;
        NRST            : in     vl_logic;
        ClkEnab         : in     vl_logic;
        IntSCL          : in     vl_logic;
        IntSDA          : in     vl_logic;
        ReadData        : in     vl_logic_vector(7 downto 0);
        Ack             : in     vl_logic;
        SlaveAddr       : in     vl_logic_vector(6 downto 0);
        ExtSlaveAddr    : in     vl_logic_vector(7 downto 0);
        GCEnab          : in     vl_logic;
        Enab            : in     vl_logic;
        AAK             : in     vl_logic;
        SampAddr        : in     vl_logic;
        ArbDataEnab     : in     vl_logic;
        ArbAckEnab      : in     vl_logic;
        SRClkEnab       : in     vl_logic;
        BusBusy         : out    vl_logic;
        StartDet        : out    vl_logic;
        StopDet         : out    vl_logic;
        ArbLost         : out    vl_logic;
        Slave7Det       : out    vl_logic;
        Slave101Det     : out    vl_logic;
        Slave102Det     : out    vl_logic;
        GenCallDet      : out    vl_logic;
        ExtAddrDet      : out    vl_logic
    );
end I2cBusDet;
