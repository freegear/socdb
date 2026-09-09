library verilog;
use verilog.vl_types.all;
entity PcmFIFOCtl is
    generic(
        AW              : integer := 3
    );
    port(
        Clki            : in     vl_logic;
        ReadEni         : in     vl_logic;
        WriteEni        : in     vl_logic;
        nRST            : in     vl_logic;
        Flushi          : in     vl_logic;
        DataCnt         : out    vl_logic_vector;
        Fullo           : out    vl_logic;
        FIFOHalfFull    : out    vl_logic;
        AlmostEmptyo    : out    vl_logic;
        Emptyo          : out    vl_logic;
        EmptyWrSideo    : out    vl_logic;
        WriteAddro      : out    vl_logic_vector;
        ReadAddro       : out    vl_logic_vector;
        ReadAllowo      : out    vl_logic;
        WriteAllowo     : out    vl_logic
    );
end PcmFIFOCtl;
