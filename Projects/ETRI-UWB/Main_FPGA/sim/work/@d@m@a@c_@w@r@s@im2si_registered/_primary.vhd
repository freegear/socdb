library verilog;
use verilog.vl_types.all;
entity DMAC_WRSIm2si_registered is
    generic(
        WIDTH           : integer := 3
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
end DMAC_WRSIm2si_registered;
