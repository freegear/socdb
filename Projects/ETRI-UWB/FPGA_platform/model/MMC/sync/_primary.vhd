library verilog;
use verilog.vl_types.all;
entity sync is
    port(
        resetn          : in     vl_logic;
        clk1            : in     vl_logic;
        stb1            : in     vl_logic;
        clk2            : in     vl_logic;
        stb2            : out    vl_logic
    );
end sync;
