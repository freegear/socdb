library verilog;
use verilog.vl_types.all;
entity Top_DTSDI002 is
    generic(
        PWCLK           : integer := 0
    );
    port(
        SMDATAIN        : in     vl_logic_vector(31 downto 0);
        SMDATAOUT       : out    vl_logic_vector(31 downto 0);
        nSMDATAEN       : out    vl_logic_vector(3 downto 0);
        SMADDR          : out    vl_logic_vector(25 downto 0);
        SMCS            : out    vl_logic_vector(7 downto 0);
        nSMBLS          : out    vl_logic_vector(3 downto 0);
        nSMOEN          : out    vl_logic;
        TESTREQA        : in     vl_logic;
        TESTREQB        : in     vl_logic;
        TESTACK         : out    vl_logic;
        GPIN            : in     vl_logic_vector(7 downto 0);
        GPOUT           : out    vl_logic_vector(7 downto 0);
        nGPEN           : out    vl_logic_vector(7 downto 0);
        nGPAFEN         : in     vl_logic_vector(7 downto 0);
        GPAFOUT         : in     vl_logic_vector(7 downto 0);
        GPAFIN          : out    vl_logic_vector(7 downto 0);
        ARM_RESETi      : in     vl_logic;
        ARM_OSCi        : in     vl_logic;
        BOOT_MODE       : in     vl_logic;
        EINT            : in     vl_logic_vector(7 downto 0);
        AIN             : in     vl_logic_vector(7 downto 0);
        TCLK0           : in     vl_logic;
        TCLK1           : in     vl_logic;
        TCLK2           : in     vl_logic;
        TCLK3           : in     vl_logic;
        TCLK4           : in     vl_logic;
        TCLK5           : in     vl_logic;
        TCLK6           : in     vl_logic;
        TCLK7           : in     vl_logic;
        TCAP            : in     vl_logic_vector(7 downto 0);
        I2C0_SCL        : inout  vl_logic_vector(1 downto 0);
        I2C0_SDA        : inout  vl_logic_vector(1 downto 0);
        EINT_Gpio0      : inout  vl_logic_vector(7 downto 0);
        TCAP_Gpio1      : inout  vl_logic_vector(7 downto 0);
        PWM_Gpio2       : inout  vl_logic_vector(7 downto 0);
        UART_Gpio3      : inout  vl_logic_vector(7 downto 0);
        ARM_TRST        : in     vl_logic;
        ARM_TCK         : in     vl_logic;
        ARM_TDI         : in     vl_logic;
        ARM_TMS         : in     vl_logic;
        ARM_TDO         : out    vl_logic;
        COMMRX          : out    vl_logic;
        COMMTX          : out    vl_logic;
        TEST_MODE       : in     vl_logic;
        SCANENABLE      : in     vl_logic;
        SCANINHCLK      : in     vl_logic;
        SCANOUTHCLK     : out    vl_logic;
        SCANINPCLK      : in     vl_logic;
        SCANOUTPCLK     : out    vl_logic
    );
end Top_DTSDI002;
