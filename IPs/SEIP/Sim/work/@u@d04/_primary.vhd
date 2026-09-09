library verilog;
use verilog.vl_types.all;
entity UD04 is
    port(
        LD              : in     vl_logic_vector(3 downto 0);
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        EN              : in     vl_logic;
        CK              : in     vl_logic;
        LE              : in     vl_logic;
        UE              : in     vl_logic;
        DE              : in     vl_logic;
        S               : out    vl_logic_vector(3 downto 0);
        \TO\            : out    vl_logic
    );
end UD04;
