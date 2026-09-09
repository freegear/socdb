library verilog;
use verilog.vl_types.all;
entity fifosram is
    generic(
        data_width      : integer := 32;
        addr_width      : integer := 4;
        mem_elements    : integer := 16
    );
    port(
        clkwr           : in     vl_logic;
        we              : in     vl_logic;
        addrrd          : in     vl_logic_vector;
        addrwr          : in     vl_logic_vector;
        din             : in     vl_logic_vector;
        dout            : out    vl_logic_vector
    );
end fifosram;
