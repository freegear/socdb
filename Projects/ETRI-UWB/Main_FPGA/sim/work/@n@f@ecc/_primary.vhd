library verilog;
use verilog.vl_types.all;
entity NFEcc is
    generic(
        ST_IDLE         : integer := 1;
        ST_LSN          : integer := 2;
        ST_ECCA         : integer := 4;
        ST_SECC         : integer := 8;
        ST_ECCB         : integer := 16;
        ST_WAIT         : integer := 32
    );
    port(
        Clk             : in     vl_logic;
        nRst            : in     vl_logic;
        AddrIn          : in     vl_logic_vector(11 downto 0);
        AddrLoadEnIn    : in     vl_logic;
        IOWidthIn       : in     vl_logic;
        NandWidthIn     : in     vl_logic;
        PageSizeIn      : in     vl_logic;
        EccRstIn        : in     vl_logic;
        Ecc512EnIn      : in     vl_logic;
        AutoEccWr       : in     vl_logic;
        AutoEccWrEnOut  : out    vl_logic;
        EccOut          : out    vl_logic_vector(15 downto 0);
        AddrCntOut      : out    vl_logic_vector(11 downto 0);
        BoundaryOut     : out    vl_logic;
        CST_RdataIn     : in     vl_logic;
        CST_WdataIn     : in     vl_logic;
        EccDataIn       : in     vl_logic_vector(15 downto 0);
        EccDataEnIn     : in     vl_logic;
        ECCSECTOR0      : out    vl_logic_vector(23 downto 0);
        ECCSECTOR1      : out    vl_logic_vector(23 downto 0);
        ECCSECTOR2      : out    vl_logic_vector(23 downto 0);
        ECCSECTOR3      : out    vl_logic_vector(23 downto 0);
        ECCSECTOR4      : out    vl_logic_vector(23 downto 0);
        ECCSECTOR5      : out    vl_logic_vector(23 downto 0);
        ECCSECTOR6      : out    vl_logic_vector(23 downto 0);
        ECCSECTOR7      : out    vl_logic_vector(23 downto 0);
        ECCSECTOR8      : out    vl_logic_vector(23 downto 0);
        ECCSECTOR9      : out    vl_logic_vector(23 downto 0);
        ECCSECTOR10     : out    vl_logic_vector(23 downto 0);
        ECCSECTOR11     : out    vl_logic_vector(23 downto 0);
        ECCSECTOR12     : out    vl_logic_vector(23 downto 0);
        ECCSECTOR13     : out    vl_logic_vector(23 downto 0);
        ECCSECTOR14     : out    vl_logic_vector(23 downto 0);
        ECCSECTOR15     : out    vl_logic_vector(23 downto 0);
        SECCSECTOR0     : out    vl_logic_vector(15 downto 0);
        SECCSECTOR1     : out    vl_logic_vector(15 downto 0);
        SECCSECTOR2     : out    vl_logic_vector(15 downto 0);
        SECCSECTOR3     : out    vl_logic_vector(15 downto 0);
        SECCSECTOR4     : out    vl_logic_vector(15 downto 0);
        SECCSECTOR5     : out    vl_logic_vector(15 downto 0);
        SECCSECTOR6     : out    vl_logic_vector(15 downto 0);
        SECCSECTOR7     : out    vl_logic_vector(15 downto 0)
    );
end NFEcc;
