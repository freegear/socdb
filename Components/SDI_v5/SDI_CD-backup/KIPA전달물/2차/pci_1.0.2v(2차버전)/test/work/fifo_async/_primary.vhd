library verilog;
use verilog.vl_types.all;
entity fifo_async is
    generic(
        data_width      : integer := 32;
        addr_width      : integer := 4;
        mem_elements    : integer := 16
    );
    port(
        rst             : in     vl_logic;
        clkrd           : in     vl_logic;
        clkwr           : in     vl_logic;
        rd              : in     vl_logic;
        we              : in     vl_logic;
        flush           : in     vl_logic;
        din             : in     vl_logic_vector;
        full            : out    vl_logic;
        empty           : out    vl_logic;
        middle          : out    vl_logic;
        dout            : out    vl_logic_vector
    );
end fifo_async;
