library verilog;
use verilog.vl_types.all;
entity AHB1_ARMImi2s_registered is
    generic(
        WIDTH           : integer := 43
    );
    port(
        ACLK            : in     vl_logic;
        ARESETn         : in     vl_logic;
        INFORMATION_S   : in     vl_logic_vector;
        VALID_S         : in     vl_logic;
        READY_S         : out    vl_logic;
        INFORMATION_R   : out    vl_logic_vector;
        VALID_R         : out    vl_logic;
        READY_R         : in     vl_logic
    );
end AHB1_ARMImi2s_registered;
