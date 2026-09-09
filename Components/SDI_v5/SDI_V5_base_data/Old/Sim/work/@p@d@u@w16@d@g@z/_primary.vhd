library verilog;
use verilog.vl_types.all;
entity PDUW16DGZ is
    generic(
        PullTime        : integer := 100000
    );
    port(
        I               : in     vl_logic;
        OEN             : in     vl_logic;
        REN             : in     vl_logic;
        PAD             : inout  vl_logic;
        C               : out    vl_logic
    );
end PDUW16DGZ;
