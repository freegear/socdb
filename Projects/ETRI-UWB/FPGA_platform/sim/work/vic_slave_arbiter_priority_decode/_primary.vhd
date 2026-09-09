library verilog;
use verilog.vl_types.all;
entity vic_slave_arbiter_priority_decode is
    port(
        PRI             : in     vl_logic_vector(2 downto 0);
        INT             : in     vl_logic;
        INT_OUT         : out    vl_logic_vector(7 downto 0)
    );
end vic_slave_arbiter_priority_decode;
