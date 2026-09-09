library verilog;
use verilog.vl_types.all;
entity SRAM_CTRL is
    generic(
        IDLE            : integer := 1;
        TAS             : integer := 2;
        TCSS            : integer := 4;
        TACC            : integer := 8;
        TCSH            : integer := 16;
        TAH             : integer := 32;
        CONT            : integer := 64
    );
    port(
        CLK             : in     vl_logic;
        RSTb            : in     vl_logic;
        ADDR            : in     vl_logic_vector(19 downto 0);
        WRITE           : in     vl_logic;
        READ            : in     vl_logic;
        WDATA           : in     vl_logic_vector(31 downto 0);
        TRANS_SIZE      : in     vl_logic_vector(2 downto 0);
        BANK_SEL        : in     vl_logic_vector(3 downto 0);
        SRAM_START      : in     vl_logic;
        ADDR_SETUP      : in     vl_logic_vector(2 downto 0);
        ADDR_HOLD       : in     vl_logic_vector(2 downto 0);
        CS_SETUP        : in     vl_logic_vector(2 downto 0);
        CS_HOLD         : in     vl_logic_vector(2 downto 0);
        ACC_CYCLE       : in     vl_logic_vector(3 downto 0);
        BUS_WIDTH       : in     vl_logic_vector(1 downto 0);
        ADDR_SHIFT      : in     vl_logic_vector(1 downto 0);
        READY           : out    vl_logic;
        RDATA           : out    vl_logic_vector(31 downto 0);
        EXT_ADDR        : out    vl_logic_vector(19 downto 0);
        EXT_WDATA       : out    vl_logic_vector(31 downto 0);
        EXT_RDATA       : in     vl_logic_vector(31 downto 0);
        EXT_CSb         : out    vl_logic_vector(3 downto 0);
        EXT_WEb         : out    vl_logic;
        EXT_OEb         : out    vl_logic;
        EXT_BEb         : out    vl_logic_vector(3 downto 0);
        EXT_WBEb        : out    vl_logic_vector(3 downto 0);
        EXT_BIDEN       : out    vl_logic
    );
end SRAM_CTRL;
