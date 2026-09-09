library verilog;
use verilog.vl_types.all;
entity PRDW12DGZ is
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
end PRDW12DGZ;
