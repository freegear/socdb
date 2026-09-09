library verilog;
use verilog.vl_types.all;
entity jtag_sync is
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        etrstb          : in     vl_logic;
        etclk           : in     vl_logic;
        ertclk          : out    vl_logic;
        etms            : in     vl_logic;
        etdi            : in     vl_logic;
        etdo            : out    vl_logic;
        DBGnTRST        : out    vl_logic;
        DBGTCKEN        : out    vl_logic;
        DBGTDI          : out    vl_logic;
        DBGTMS          : out    vl_logic;
        DBGTDO          : in     vl_logic
    );
end jtag_sync;
