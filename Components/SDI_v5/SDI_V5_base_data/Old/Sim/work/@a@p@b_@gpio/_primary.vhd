library verilog;
use verilog.vl_types.all;
entity APB_Gpio is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(11 downto 2);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        Gpio_IN0        : in     vl_logic_vector(7 downto 0);
        Gpio_IN1        : in     vl_logic_vector(7 downto 0);
        Gpio_IN2        : in     vl_logic_vector(7 downto 0);
        Gpio_IN3        : in     vl_logic_vector(7 downto 0);
        Tout            : in     vl_logic_vector(7 downto 0);
        MEM_ADR         : in     vl_logic_vector(19 downto 17);
        MEM_BE          : in     vl_logic_vector(1 downto 0);
        POUT            : in     vl_logic_vector(7 downto 0);
        UART_RXD        : in     vl_logic;
        UART_TXD        : in     vl_logic;
        IrDA_RXD        : in     vl_logic;
        IrDA_TXD        : in     vl_logic;
        MEM_WBE         : in     vl_logic_vector(1 downto 0);
        MEM_CS          : in     vl_logic_vector(2 downto 1);
        GPIO_En0        : out    vl_logic_vector(7 downto 0);
        GPIO_En1        : out    vl_logic_vector(7 downto 0);
        GPIO_En2        : out    vl_logic_vector(7 downto 0);
        GPIO_En3        : out    vl_logic_vector(7 downto 0);
        Mux_Out0        : out    vl_logic_vector(7 downto 0);
        Mux_Out1        : out    vl_logic_vector(7 downto 0);
        Mux_Out2        : out    vl_logic_vector(7 downto 0);
        Mux_Out3        : out    vl_logic_vector(7 downto 0);
        SCANENABLE      : in     vl_logic;
        SCANINPCLK      : in     vl_logic;
        SCANOUTPCLK     : out    vl_logic
    );
end APB_Gpio;
