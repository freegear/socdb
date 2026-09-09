library verilog;
use verilog.vl_types.all;
entity f2sslice_simple is
    generic(
        width           : integer := 15
    );
    port(
        aclk_fast       : in     vl_logic;
        aresetn         : in     vl_logic;
        slowclocken     : in     vl_logic;
        information_f   : in     vl_logic_vector;
        valid_f         : in     vl_logic;
        ready_f         : out    vl_logic;
        information_s   : out    vl_logic_vector;
        valid_s         : out    vl_logic;
        ready_s         : in     vl_logic
    );
end f2sslice_simple;
