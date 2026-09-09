library verilog;
use verilog.vl_types.all;
entity PRU24DGZ is
    generic(
        PullTime        : integer := 100000
    );
    port(
        I               : in     vl_logic;
        OEN             : in     vl_logic;
        PAD             : inout  vl_logic;
        C               : out    vl_logic
    );
end PRU24DGZ;
