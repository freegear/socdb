library verilog;
use verilog.vl_types.all;
entity SEIPTop is
    generic(
        RXAW            : integer := 3;
        TXAW            : integer := 3;
        RXCON           : integer := 2048;
        RXSTS           : integer := 2049;
        RXDAT           : integer := 2050;
        TXCON           : integer := 2052;
        TXSTS           : integer := 2053;
        TXDAT           : integer := 2054
    );
    port(
        MCK             : in     vl_logic;
        XRST            : in     vl_logic;
        TE              : in     vl_logic;
        TI0             : in     vl_logic;
        TI1             : in     vl_logic;
        TI2             : in     vl_logic;
        TI3             : in     vl_logic;
        TI4             : in     vl_logic;
        TO0             : out    vl_logic;
        TO1             : out    vl_logic;
        TO2             : out    vl_logic;
        TO3             : out    vl_logic;
        TO4             : out    vl_logic;
        PSEL            : in     vl_logic;
        PENABLE         : in     vl_logic;
        PADDR           : in     vl_logic_vector(13 downto 2);
        PWRITE          : in     vl_logic;
        PWDATA          : in     vl_logic_vector(31 downto 0);
        PRDATA          : out    vl_logic_vector(31 downto 0);
        PREADY          : out    vl_logic;
        EEMA_M          : out    vl_logic_vector(15 downto 0);
        EEMDI_M         : out    vl_logic_vector(31 downto 0);
        EEMDO_M         : in     vl_logic_vector(31 downto 0);
        XEEMWE_M        : out    vl_logic_vector(3 downto 0);
        RxDmaRequest    : out    vl_logic;
        TxDmaRequest    : out    vl_logic;
        SEIPInt         : out    vl_logic;
        EXMBIH          : out    vl_logic;
        WEMDI           : out    vl_logic_vector(7 downto 0);
        WEMDO           : in     vl_logic_vector(7 downto 0);
        WEMA            : out    vl_logic_vector(23 downto 0);
        XWEMOC          : out    vl_logic;
        XWEMWE          : out    vl_logic;
        SDI1            : in     vl_logic;
        SDI2            : in     vl_logic;
        SCKO            : out    vl_logic;
        ADMCK           : out    vl_logic;
        LRCKO           : out    vl_logic;
        SD2O            : out    vl_logic;
        SD1O            : out    vl_logic;
        MLRCK           : out    vl_logic;
        MSCK            : out    vl_logic
    );
end SEIPTop;
