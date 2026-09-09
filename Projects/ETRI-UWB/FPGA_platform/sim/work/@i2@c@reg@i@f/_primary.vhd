library verilog;
use verilog.vl_types.all;
entity I2CRegIF is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(1 downto 0);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        BusyDet         : in     vl_logic;
        StartDet        : in     vl_logic;
        StopDet         : in     vl_logic;
        ArbitLostDet    : in     vl_logic;
        TxCompInt       : in     vl_logic;
        AckValue        : in     vl_logic;
        AckEn           : out    vl_logic;
        IntPendFlag     : out    vl_logic;
        IntPendClr      : out    vl_logic;
        TxClkVal        : out    vl_logic_vector(11 downto 0);
        OpMode          : out    vl_logic;
        Start           : out    vl_logic;
        Stop            : out    vl_logic;
        StartClr        : in     vl_logic;
        StopClr         : in     vl_logic;
        IDSRo           : out    vl_logic_vector(7 downto 0);
        ReadData        : in     vl_logic_vector(7 downto 0);
        SW_RST          : out    vl_logic;
        int             : out    vl_logic
    );
end I2CRegIF;
