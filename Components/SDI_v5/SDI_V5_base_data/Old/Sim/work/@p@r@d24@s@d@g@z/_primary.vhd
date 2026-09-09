library verilog;
use verilog.vl_types.all;
entity PRD24SDGZ is
    generic(
        PullTime        : integer := 100000
    );
    port(
        I               : in     vl_logic;
        OEN             : in     vl_logic;
        PAD             : inout  vl_logic;
        C               : out    vl_logic
    );
end PRD24SDGZ;
