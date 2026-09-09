library verilog;
use verilog.vl_types.all;
entity ifmc_tool is
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        tmode           : in     vl_logic;
        scl_lpf         : in     vl_logic;
        tool_mode       : out    vl_logic
    );
end ifmc_tool;
