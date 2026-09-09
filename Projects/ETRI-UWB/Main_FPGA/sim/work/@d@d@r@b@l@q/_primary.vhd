library verilog;
use verilog.vl_types.all;
entity DDRBLQ is
    generic(
        BLQCD           : integer := 0;
        BLQD            : integer := 1;
        BLQW            : integer := 9
    );
    port(
        nRST            : in     vl_logic;
        Clk             : in     vl_logic;
        WriteEn         : in     vl_logic;
        ReadEn          : in     vl_logic;
        WrData          : in     vl_logic_vector;
        RdData          : out    vl_logic_vector;
        HFullFlag       : out    vl_logic;
        FullFlag        : out    vl_logic;
        EmptyFlag       : out    vl_logic
    );
end DDRBLQ;
