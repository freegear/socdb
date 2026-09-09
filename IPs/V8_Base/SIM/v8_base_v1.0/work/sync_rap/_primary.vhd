library verilog;
use verilog.vl_types.all;
entity sync_rap is
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
        sl_cs           : out    vl_logic;
        sl_addr         : out    vl_logic_vector;
        sl_read         : out    vl_logic;
        sl_write        : out    vl_logic;
        sl_dataout      : out    vl_logic_vector;
        sl_datain       : in     vl_logic_vector;
        sl_ready        : in     vl_logic
    );
end sync_rap;
