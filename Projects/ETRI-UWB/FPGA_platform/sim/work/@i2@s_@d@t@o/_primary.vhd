library verilog;
use verilog.vl_types.all;
entity I2S_DTO is
    generic(
        WIDTH           : integer := 18
    );
    port(
        SYS_CLK         : in     vl_logic;
        RESETn          : in     vl_logic;
        MCLK            : out    vl_logic;
        BCLK            : out    vl_logic;
        LRCLK           : out    vl_logic;
        Enable          : in     vl_logic;
        LRClkInv        : in     vl_logic;
        ClkMS           : in     vl_logic;
        DTORatio        : in     vl_logic_vector
    );
end I2S_DTO;
