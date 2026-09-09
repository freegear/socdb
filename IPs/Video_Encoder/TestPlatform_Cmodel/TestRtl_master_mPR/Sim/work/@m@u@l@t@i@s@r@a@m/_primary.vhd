library verilog;
use verilog.vl_types.all;
entity MULTISRAM is
    generic(
        d_width         : integer := 32;
        addr_width      : integer := 5;
        mem_depth       : integer := 32
    );
    port(
        data0           : in     vl_logic_vector;
        data1           : in     vl_logic_vector;
        waddr0          : in     vl_logic_vector;
        waddr1          : in     vl_logic_vector;
        raddr           : in     vl_logic_vector;
        we0             : in     vl_logic;
        we1             : in     vl_logic;
        clk0            : in     vl_logic;
        clk1            : in     vl_logic;
        q1              : out    vl_logic_vector
    );
end MULTISRAM;
