library verilog;
use verilog.vl_types.all;
entity gang is
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        tmode           : out    vl_logic;
        scl             : out    vl_logic;
        sda_in          : out    vl_logic;
        sda_out         : in     vl_logic;
        tstart          : in     vl_logic
    );
end gang;
