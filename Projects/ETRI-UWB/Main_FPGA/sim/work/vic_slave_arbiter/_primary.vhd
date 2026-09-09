library verilog;
use verilog.vl_types.all;
entity vic_slave_arbiter is
    port(
        FIXED_MODE      : in     vl_logic;
        INTPEND         : in     vl_logic_vector(7 downto 0);
        ISPR_OUT        : out    vl_logic_vector(7 downto 0);
        INTERRUPT_OUT   : out    vl_logic;
        PSLV            : in     vl_logic_vector(23 downto 0);
        CSLV            : in     vl_logic_vector(23 downto 0);
        NEXTCSLV        : out    vl_logic_vector(23 downto 0)
    );
end vic_slave_arbiter;
