library verilog;
use verilog.vl_types.all;
entity vic_master_arbiter_4to1_mux is
    port(
        SEL             : in     vl_logic_vector(1 downto 0);
        INPUT           : in     vl_logic_vector(3 downto 0);
        OUTPUT          : out    vl_logic
    );
end vic_master_arbiter_4to1_mux;
