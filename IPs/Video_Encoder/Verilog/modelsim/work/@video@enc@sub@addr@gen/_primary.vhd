library verilog;
use verilog.vl_types.all;
entity VideoEncSubAddrGen is
    generic(
        PHASE_0         : integer := 0;
        PHASE_135       : integer := 1610612736;
        PHASE_1         : integer := 11930464;
        PHASE0_175      : integer := 2097151;
        NTSCM           : integer := 0;
        NTSCJ           : integer := 1;
        NTSC4           : integer := 2;
        PALM            : integer := 3;
        PAL             : integer := 4;
        PALNc           : integer := 5;
        PALN            : integer := 6
    );
    port(
        CLK             : in     vl_logic;
        RESETn          : in     vl_logic;
        SUB_REQ         : in     vl_logic_vector(31 downto 0);
        SUB_PHASE       : in     vl_logic_vector(15 downto 0);
        OUT_MODE        : in     vl_logic_vector(2 downto 0);
        EN_RESET_SCH    : in     vl_logic;
        ACT_DISPLAY_SYN : in     vl_logic;
        BURST_ENABLE    : in     vl_logic;
        RESET_ADDR      : in     vl_logic;
        BURST_ID        : in     vl_logic;
        COS             : out    vl_logic_vector(10 downto 0);
        SIN             : out    vl_logic_vector(10 downto 0)
    );
end VideoEncSubAddrGen;
