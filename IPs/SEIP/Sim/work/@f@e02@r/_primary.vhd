library verilog;
use verilog.vl_types.all;
entity FE02R is
    port(
        D               : in     vl_logic_vector(1 downto 0);
        EN              : in     vl_logic;
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        CK              : in     vl_logic;
        Q               : out    vl_logic_vector(1 downto 0);
        \TO\            : out    vl_logic
    );
end FE02R;
