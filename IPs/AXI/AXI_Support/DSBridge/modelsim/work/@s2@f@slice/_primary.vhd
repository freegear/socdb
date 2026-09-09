library verilog;
use verilog.vl_types.all;
entity s2fslice is
    generic(
        width           : integer := 15
    );
    port(
        aclk_fast       : in     vl_logic;
        aresetn         : in     vl_logic;
        slowclocken     : in     vl_logic;
        information_f   : out    vl_logic_vector;
        valid_f         : out    vl_logic;
        ready_f         : in     vl_logic;
        information_s   : in     vl_logic_vector;
        valid_s         : in     vl_logic;
        ready_s         : out    vl_logic
    );
end s2fslice;
