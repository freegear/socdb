library verilog;
use verilog.vl_types.all;
entity EQACC is
    port(
        EDB             : in     vl_logic_vector(19 downto 0);
        EQACS0          : in     vl_logic;
        XRST            : in     vl_logic;
        EQACLE          : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        EQACCL          : in     vl_logic;
        EQACCE          : in     vl_logic;
        MCK             : in     vl_logic;
        EQO             : out    vl_logic_vector(19 downto 0);
        \TO\            : out    vl_logic
    );
end EQACC;
