library verilog;
use verilog.vl_types.all;
entity Gpio is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(4 downto 2);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        Interrupt       : out    vl_logic;
        GpioIn          : in     vl_logic_vector(31 downto 0);
        GpioOutEn       : out    vl_logic_vector(31 downto 0);
        GpioOut         : out    vl_logic_vector(31 downto 0)
    );
end Gpio;
