library verilog;
use verilog.vl_types.all;
entity SMC_REG is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PADDR           : in     vl_logic_vector(3 downto 2);
        PSEL            : in     vl_logic;
        PENABLE         : in     vl_logic;
        PWRITE          : in     vl_logic;
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        SRAM_START      : in     vl_logic;
        BANK_SEL        : in     vl_logic_vector(3 downto 0);
        ADDR_SETUP      : out    vl_logic_vector(2 downto 0);
        ADDR_HOLD       : out    vl_logic_vector(2 downto 0);
        CS_SETUP        : out    vl_logic_vector(2 downto 0);
        CS_HOLD         : out    vl_logic_vector(2 downto 0);
        ACC_CYCLE       : out    vl_logic_vector(3 downto 0);
        BUS_WIDTH       : out    vl_logic_vector(1 downto 0);
        ADDR_SHIFT      : out    vl_logic_vector(1 downto 0)
    );
end SMC_REG;
