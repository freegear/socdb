library verilog;
use verilog.vl_types.all;
entity vic_master_arbiter is
    port(
        FIXED_MODE      : in     vl_logic;
        INTPEND         : in     vl_logic_vector(3 downto 0);
        ISPR_OUT        : out    vl_logic_vector(3 downto 0);
        INTERRUPT_OUT   : out    vl_logic;
        PMST            : in     vl_logic_vector(7 downto 0);
        CMST            : in     vl_logic_vector(7 downto 0);
        NEXTCMST        : out    vl_logic_vector(7 downto 0)
    );
end vic_master_arbiter;
