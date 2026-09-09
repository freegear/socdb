library verilog;
use verilog.vl_types.all;
entity ClockOr is
    port(
        InClock         : in     vl_logic;
        Enable          : in     vl_logic;
        OutClock        : out    vl_logic
    );
end ClockOr;
