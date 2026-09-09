library verilog;
use verilog.vl_types.all;
entity fully_registered is
    generic(
        width           : integer := 15
    );
    port(
        aclk            : in     vl_logic;
        aresetn         : in     vl_logic;
        information_s   : in     vl_logic_vector;
        valid_s         : in     vl_logic;
        ready_s         : out    vl_logic;
        information_r   : out    vl_logic_vector;
        valid_r         : out    vl_logic;
        ready_r         : in     vl_logic
    );
end fully_registered;
