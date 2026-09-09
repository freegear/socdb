library verilog;
use verilog.vl_types.all;
entity Gpio2Ch is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(5 downto 2);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        Gpio0In         : in     vl_logic_vector(31 downto 0);
        Gpio0OutEn      : out    vl_logic_vector(31 downto 0);
        Gpio0Out        : out    vl_logic_vector(31 downto 0);
        Gpio1In         : in     vl_logic_vector(31 downto 0);
        Gpio1OutEn      : out    vl_logic_vector(31 downto 0);
        Gpio1Out        : out    vl_logic_vector(31 downto 0);
        Interrupt       : out    vl_logic_vector(1 downto 0)
    );
end Gpio2Ch;
