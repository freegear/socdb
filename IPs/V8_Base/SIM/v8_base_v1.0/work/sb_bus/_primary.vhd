library verilog;
use verilog.vl_types.all;
entity sb_bus is
    generic(
        ADDRWIDTH       : integer := 16;
        CDATAWIDTH      : integer := 8;
        PDATAWIDTH      : integer := 32;
        PBE             : integer := 4
    );
    port(
        cpu_addr        : in     vl_logic_vector;
        cpu_datain      : out    vl_logic_vector;
        cpu_dataout     : in     vl_logic_vector;
        cpu_ready       : out    vl_logic;
        pctrl_ready     : in     vl_logic;
        mem_cs          : out    vl_logic;
        mem_dataout     : in     vl_logic_vector;
        mem_ready       : in     vl_logic;
        p_be            : out    vl_logic_vector;
        p_datain        : out    vl_logic_vector;
        p0_cs           : out    vl_logic;
        p0_dataout      : in     vl_logic_vector;
        p0_ready        : in     vl_logic;
        p1_cs           : out    vl_logic;
        p1_dataout      : in     vl_logic_vector;
        p1_ready        : in     vl_logic;
        p2_cs           : out    vl_logic;
        p2_dataout      : in     vl_logic_vector;
        p2_ready        : in     vl_logic;
        p3_cs           : out    vl_logic;
        p3_dataout      : in     vl_logic_vector;
        p3_ready        : in     vl_logic;
        p4_cs           : out    vl_logic;
        p4_dataout      : in     vl_logic_vector;
        p4_ready        : in     vl_logic;
        p5_cs           : out    vl_logic;
        p5_dataout      : in     vl_logic_vector;
        p5_ready        : in     vl_logic;
        p6_cs           : out    vl_logic;
        p6_dataout      : in     vl_logic_vector;
        p6_ready        : in     vl_logic;
        p7_cs           : out    vl_logic;
        p7_dataout      : in     vl_logic_vector;
        p7_ready        : in     vl_logic
    );
end sb_bus;
