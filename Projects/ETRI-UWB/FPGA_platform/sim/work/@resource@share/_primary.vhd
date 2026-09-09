library verilog;
use verilog.vl_types.all;
entity ResourceShare is
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(4 downto 2);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        DMAMux          : out    vl_logic_vector(31 downto 0);
        I2SInputMux     : out    vl_logic_vector(1 downto 0);
        WaveROMHAddr    : out    vl_logic_vector(2 downto 0);
        WaveROMOwner    : out    vl_logic;
        SRAMOwner       : out    vl_logic
    );
end ResourceShare;
