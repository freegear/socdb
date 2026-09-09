library verilog;
use verilog.vl_types.all;
entity vic_master_arbiter_priority_decode is
    port(
        PRI             : in     vl_logic_vector(1 downto 0);
        INT             : in     vl_logic;
        INT_OUT         : out    vl_logic_vector(3 downto 0)
    );
end vic_master_arbiter_priority_decode;
