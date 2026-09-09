library verilog;
use verilog.vl_types.all;
entity arm_top is
    port(
        hclock          : in     vl_logic;
        hresetn         : in     vl_logic;
        hsel            : in     vl_logic;
        hgrant          : in     vl_logic;
        clk_ref         : in     vl_logic;
        npor            : in     vl_logic;
        nreset          : inout  vl_logic
    );
end arm_top;
