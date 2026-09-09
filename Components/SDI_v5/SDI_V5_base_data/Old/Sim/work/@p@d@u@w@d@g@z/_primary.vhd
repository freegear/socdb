library verilog;
use verilog.vl_types.all;
entity PDUWDGZ is
    generic(
        PullTime        : integer := 100000
    );
    port(
        PAD             : in     vl_logic;
        C               : out    vl_logic;
        REN             : in     vl_logic
    );
end PDUWDGZ;
