library verilog;
use verilog.vl_types.all;
entity APB_PowerManager is
    port(
        Int_Clrn        : out    vl_logic;
        OSC_CLK         : in     vl_logic;
        EINT            : in     vl_logic_vector(7 downto 0);
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(7 downto 2);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        Sys_CLK_O       : out    vl_logic;
        UART_CLK_O      : out    vl_logic;
        GIE_O           : out    vl_logic;
        UART_INT_SEL    : out    vl_logic;
        AD_CLK_O        : out    vl_logic;
        SCANENABLE      : in     vl_logic;
        SCANINPCLK      : in     vl_logic;
        SCANOUTPCLK     : out    vl_logic
    );
end APB_PowerManager;
