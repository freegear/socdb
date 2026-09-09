library verilog;
use verilog.vl_types.all;
entity I2S_FIFO_RAM is
    generic(
        DEPTH           : integer := 6;
        DATA_WIDTH      : integer := 32
    );
    port(
        CLK             : in     vl_logic;
        WE              : in     vl_logic;
        WData           : in     vl_logic_vector;
        WA              : in     vl_logic_vector;
        RE              : in     vl_logic;
        RData           : out    vl_logic_vector;
        RA              : in     vl_logic_vector
    );
end I2S_FIFO_RAM;
