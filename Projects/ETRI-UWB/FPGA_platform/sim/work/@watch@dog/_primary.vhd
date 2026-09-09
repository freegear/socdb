library verilog;
use verilog.vl_types.all;
entity WatchDog is
    generic(
        ADDRREG0        : integer := 0;
        ADDRREG1        : integer := 1;
        ADDRREG2        : integer := 2;
        ADDRREG3        : integer := 3;
        ADDRREGA        : integer := 4
    );
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector(7 downto 2);
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        WDOGRESn        : in     vl_logic;
        WDOGINT         : out    vl_logic;
        WDOGRES         : out    vl_logic
    );
end WatchDog;
