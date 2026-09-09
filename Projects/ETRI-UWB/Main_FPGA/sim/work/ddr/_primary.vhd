library verilog;
use verilog.vl_types.all;
entity ddr is
    generic(
        tCK             : real    := 7.500000;
        tDQSQ           : real    := 0.500000;
        tMRD            : real    := 15.000000;
        tRAP            : real    := 15.000000;
        tRAS            : real    := 40.000000;
        tRC             : real    := 60.000000;
        tRFC            : real    := 75.000000;
        tRCD            : real    := 15.000000;
        tRP             : real    := 15.000000;
        tRRD            : real    := 15.000000;
        tWR             : real    := 15.000000;
        ADDR_BITS       : integer := 13;
        DQ_BITS         : integer := 16;
        DQS_BITS        : integer := 2;
        DM_BITS         : integer := 2;
        COL_BITS        : integer := 10;
        part_mem_bits   : integer := 10;
        no_halt         : integer := 1;
        Debug           : integer := 0
    );
    port(
        Dq              : inout  vl_logic_vector;
        Dqs             : inout  vl_logic_vector;
        Addr            : in     vl_logic_vector;
        Ba              : in     vl_logic_vector(1 downto 0);
        Clk             : in     vl_logic;
        Clk_n           : in     vl_logic;
        Cke             : in     vl_logic;
        Cs_n            : in     vl_logic;
        Ras_n           : in     vl_logic;
        Cas_n           : in     vl_logic;
        We_n            : in     vl_logic;
        Dm              : in     vl_logic_vector
    );
end ddr;
