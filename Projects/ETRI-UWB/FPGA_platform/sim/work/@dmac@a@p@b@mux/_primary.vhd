library verilog;
use verilog.vl_types.all;
entity DmacAPBMux is
    generic(
        PADDR_MAX       : integer := 6
    );
    port(
        PCLK            : in     vl_logic;
        PRESETn         : in     vl_logic;
        PENABLE         : in     vl_logic;
        PSEL            : in     vl_logic;
        PWRITE          : in     vl_logic;
        PADDR           : in     vl_logic_vector;
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        PCLK0           : out    vl_logic;
        PENABLE0        : out    vl_logic;
        PSEL0           : out    vl_logic;
        PWRITE0         : out    vl_logic;
        PADDR0          : out    vl_logic_vector;
        PWDATA0         : out    vl_logic_vector(31 downto 0);
        PRDATA0         : in     vl_logic_vector(31 downto 0);
        PCLK1           : out    vl_logic;
        PENABLE1        : out    vl_logic;
        PSEL1           : out    vl_logic;
        PWRITE1         : out    vl_logic;
        PADDR1          : out    vl_logic_vector;
        PWDATA1         : out    vl_logic_vector(31 downto 0);
        PRDATA1         : in     vl_logic_vector(31 downto 0)
    );
end DmacAPBMux;
