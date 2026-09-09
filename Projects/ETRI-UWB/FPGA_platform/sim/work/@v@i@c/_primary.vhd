library verilog;
use verilog.vl_types.all;
entity VIC is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(6 downto 2);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        INTERRUPT_SRC   : in     vl_logic_vector(31 downto 0);
        nFIQ            : out    vl_logic;
        nIRQ            : out    vl_logic;
        LEVEL_PM        : out    vl_logic_vector(7 downto 0);
        POLARITY_PM     : out    vl_logic_vector(7 downto 0);
        INTMSK_PM       : out    vl_logic_vector(7 downto 0)
    );
end VIC;
