library verilog;
use verilog.vl_types.all;
entity I2S_DAC is
    port(
        MASTER          : in     vl_logic;
        WORD_LEN        : in     vl_logic_vector(1 downto 0);
        LJUST           : in     vl_logic;
        MCLK            : in     vl_logic;
        BCLK            : inout  vl_logic;
        LRCLK           : inout  vl_logic;
        SDIN            : in     vl_logic
    );
end I2S_DAC;
