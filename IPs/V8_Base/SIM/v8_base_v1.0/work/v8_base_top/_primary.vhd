library verilog;
use verilog.vl_types.all;
entity v8_base_top is
    generic(
        ADDRWIDTH       : integer := 16;
        CDATAWIDTH      : integer := 8;
        PDATAWIDTH      : integer := 32;
        PBE             : integer := 4
    );
    port(
        clk             : in     vl_logic;
        rstb            : in     vl_logic;
        set_addr        : in     vl_logic;
        acc_addr        : in     vl_logic_vector;
        write           : in     vl_logic;
        wdata           : in     vl_logic_vector;
        read            : in     vl_logic;
        rdata           : out    vl_logic_vector;
        run             : in     vl_logic
    );
end v8_base_top;
