library verilog;
use verilog.vl_types.all;
entity I2CDetect is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        ArbitCheck      : in     vl_logic;
        SCL_i           : in     vl_logic;
        SDA_i           : in     vl_logic;
        SCL_o           : in     vl_logic;
        SDA_o           : in     vl_logic;
        DSCL            : out    vl_logic;
        DDSCL           : out    vl_logic;
        DSCL_o          : out    vl_logic;
        ReadData        : in     vl_logic_vector(7 downto 0);
        ClkEn           : in     vl_logic;
        BusyDet         : out    vl_logic;
        StartDet        : out    vl_logic;
        StopDet         : out    vl_logic;
        ArbitLostDet    : out    vl_logic
    );
end I2CDetect;
