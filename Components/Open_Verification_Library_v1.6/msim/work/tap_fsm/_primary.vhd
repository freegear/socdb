library verilog;
use verilog.vl_types.all;
entity tap_fsm is
    port(
        tck             : in     vl_logic;
        trst_n          : in     vl_logic;
        tms             : in     vl_logic;
        state           : out    vl_logic_vector(3 downto 0)
    );
end tap_fsm;
