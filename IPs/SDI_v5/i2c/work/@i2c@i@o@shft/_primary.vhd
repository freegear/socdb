library verilog;
use verilog.vl_types.all;
entity I2cIOShft is
    port(
        CLK             : in     vl_logic;
        NRST            : in     vl_logic;
        ClkEnab         : in     vl_logic;
        SoftReset       : in     vl_logic;
        SRClkEnab       : in     vl_logic;
        OpClkEnab       : in     vl_logic;
        IntSDA          : in     vl_logic;
        WriteData       : in     vl_logic_vector(7 downto 0);
        OpEnab          : in     vl_logic;
        SRLoad          : in     vl_logic;
        openab2         : in     vl_logic;
        AAK             : in     vl_logic;
        SendAck         : in     vl_logic;
        AssertDA        : in     vl_logic;
        ShiftReg        : out    vl_logic_vector(7 downto 0);
        Ack             : out    vl_logic;
        OSDA            : out    vl_logic
    );
end I2cIOShft;
