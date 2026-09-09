library verilog;
use verilog.vl_types.all;
entity vic_slave_arbiter_8to1_mux is
    port(
        SEL             : in     vl_logic_vector(2 downto 0);
        INPUT           : in     vl_logic_vector(7 downto 0);
        OUTPUT          : out    vl_logic
    );
end vic_slave_arbiter_8to1_mux;
