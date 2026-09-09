library verilog;
use verilog.vl_types.all;
entity FE21R is
    port(
        D               : in     vl_logic_vector(19 downto 0);
        D20             : in     vl_logic;
        TI              : in     vl_logic;
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        CK              : in     vl_logic;
        EN              : in     vl_logic;
        Q               : out    vl_logic_vector(19 downto 0);
        Q20             : out    vl_logic;
        \TO\            : out    vl_logic
    );
end FE21R;
