library verilog;
use verilog.vl_types.all;
entity MixerFIFO is
    generic(
        AW              : integer := 5;
        DW              : integer := 24
    );
    port(
        RdClk           : in     vl_logic;
        WrClk           : in     vl_logic;
        nRST            : in     vl_logic;
        Flush           : in     vl_logic;
        WrData          : in     vl_logic_vector;
        WriteEn         : in     vl_logic;
        RdData          : out    vl_logic_vector;
        ReadEn          : in     vl_logic;
        Full            : out    vl_logic;
        Empty           : out    vl_logic;
        Level           : out    vl_logic_vector(1 downto 0)
    );
end MixerFIFO;
