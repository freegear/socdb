library verilog;
use verilog.vl_types.all;
entity mem_rap is
    generic(
        ADDRWIDTH       : integer := 16;
        DATAWIDTH       : integer := 8
    );
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        bus_cs          : in     vl_logic;
        bus_addr        : in     vl_logic_vector;
        bus_read        : in     vl_logic;
        bus_write       : in     vl_logic;
        bus_datain      : in     vl_logic_vector;
        bus_dataout     : out    vl_logic_vector;
        bus_ready       : out    vl_logic;
        spc_cs          : in     vl_logic;
        spc_addr        : in     vl_logic_vector;
        spc_read        : in     vl_logic;
        spc_write       : in     vl_logic;
        spc_datain      : in     vl_logic_vector;
        spc_dataout     : out    vl_logic_vector;
        sl_csb          : out    vl_logic;
        sl_addr         : out    vl_logic_vector;
        sl_writeb       : out    vl_logic;
        sl_outenb       : out    vl_logic;
        sl_dataout      : out    vl_logic_vector;
        sl_datain       : in     vl_logic_vector;
        sl_ready        : in     vl_logic
    );
end mem_rap;
