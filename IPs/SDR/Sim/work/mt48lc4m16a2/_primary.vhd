library verilog;
use verilog.vl_types.all;
entity mt48lc4m16a2 is
    generic(
        addr_bits       : integer := 12;
        data_bits       : integer := 16;
        col_bits        : integer := 8;
        mem_sizes       : integer := 1048575;
        tAC             : real    := 5.400000;
        tHZ             : real    := 5.400000;
        tOH             : real    := 3.000000;
        tMRD            : real    := 2.000000;
        tRAS            : real    := 37.000000;
        tRC             : real    := 60.000000;
        tRCD            : real    := 15.000000;
        tRFC            : real    := 66.000000;
        tRP             : real    := 15.000000;
        tRRD            : real    := 14.000000;
        tWRa            : real    := 7.000000;
        tWRm            : real    := 14.000000
    );
    port(
        Dq              : inout  vl_logic_vector;
        Addr            : in     vl_logic_vector;
        Ba              : in     vl_logic_vector(1 downto 0);
        Clk             : in     vl_logic;
        Cke             : in     vl_logic;
        Cs_n            : in     vl_logic;
        Ras_n           : in     vl_logic;
        Cas_n           : in     vl_logic;
        We_n            : in     vl_logic;
        Dqm             : in     vl_logic_vector(1 downto 0)
    );
end mt48lc4m16a2;
