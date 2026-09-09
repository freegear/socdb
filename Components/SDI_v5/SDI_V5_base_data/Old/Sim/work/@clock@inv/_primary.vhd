library verilog;
use verilog.vl_types.all;
entity ClockInv is
    port(
        InClock         : in     vl_logic;
        OutClock        : out    vl_logic
    );
end ClockInv;
