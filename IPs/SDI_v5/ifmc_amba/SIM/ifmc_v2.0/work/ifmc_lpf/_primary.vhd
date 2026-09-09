library verilog;
use verilog.vl_types.all;
entity ifmc_lpf is
    generic(
        DELAY_TAPS      : integer := 3
    );
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        \in\            : in     vl_logic;
        \out\           : out    vl_logic
    );
end ifmc_lpf;
