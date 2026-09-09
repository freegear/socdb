library verilog;
use verilog.vl_types.all;
entity ScFIFOCtl2048x16 is
    generic(
        AW              : integer := 11;
        ML              : integer := 2040
    );
    port(
        Clki            : in     vl_logic;
        ReadEni         : in     vl_logic;
        WriteEni        : in     vl_logic;
        nRST            : in     vl_logic;
        Flushi          : in     vl_logic;
        Fullo           : out    vl_logic;
        FIFOHalfFull    : out    vl_logic;
        AlmostEmptyo    : out    vl_logic;
        AlmostFullo     : out    vl_logic;
        Emptyo          : out    vl_logic;
        EmptyWrSideo    : out    vl_logic;
        WriteAddro      : out    vl_logic_vector;
        ReadAddro       : out    vl_logic_vector;
        ReadAllowo      : out    vl_logic;
        WriteAllowo     : out    vl_logic
    );
end ScFIFOCtl2048x16;
