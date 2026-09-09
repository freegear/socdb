library verilog;
use verilog.vl_types.all;
entity I2cReg is
    port(
        Clk             : in     vl_logic;
        nRst            : in     vl_logic;
        PSEL            : in     vl_logic;
        PENABLE         : in     vl_logic;
        PADDR           : in     vl_logic_vector(4 downto 2);
        PWRITE          : in     vl_logic;
        PWDATA          : in     vl_logic_vector(15 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        RStatus         : in     vl_logic_vector(4 downto 0);
        RSetIFlg        : in     vl_logic;
        RClearSTA       : in     vl_logic;
        RClearSTP       : in     vl_logic;
        RrData          : in     vl_logic_vector(7 downto 0);
        REnab           : out    vl_logic;
        RGCEnab         : out    vl_logic;
        RSTA            : out    vl_logic;
        RSTP            : out    vl_logic;
        RIFlg           : out    vl_logic;
        RAAK            : out    vl_logic;
        I2cInt          : out    vl_logic;
        I2cSRst         : out    vl_logic;
        RCCR            : out    vl_logic_vector(6 downto 0);
        RSlavAddr       : out    vl_logic_vector(6 downto 0);
        RExtendAddr     : out    vl_logic_vector(7 downto 0);
        RwData          : out    vl_logic_vector(7 downto 0)
    );
end I2cReg;
