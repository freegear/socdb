library verilog;
use verilog.vl_types.all;
entity WMREG is
    port(
        WIMO            : in     vl_logic_vector(15 downto 0);
        WR6LE           : in     vl_logic;
        WR0LE           : in     vl_logic;
        MCK             : in     vl_logic;
        XRST            : in     vl_logic;
        WR1LE           : in     vl_logic;
        TE              : in     vl_logic;
        WR7LE           : in     vl_logic;
        WR2LE           : in     vl_logic;
        WR5LE           : in     vl_logic;
        TI              : in     vl_logic;
        WR4LE           : in     vl_logic;
        RPDSEN          : in     vl_logic;
        WSMSB           : in     vl_logic;
        PITCH           : out    vl_logic_vector(17 downto 0);
        PLACA           : out    vl_logic_vector(6 downto 0);
        RPD             : out    vl_logic_vector(15 downto 0);
        FMODE           : out    vl_logic_vector(1 downto 0);
        WEMAH           : out    vl_logic_vector(3 downto 0);
        PLCD            : out    vl_logic_vector(6 downto 0);
        PACH            : out    vl_logic_vector(15 downto 0);
        LDIRC           : out    vl_logic;
        \TO\            : out    vl_logic;
        WMODE1          : out    vl_logic;
        WMODE0          : out    vl_logic
    );
end WMREG;
