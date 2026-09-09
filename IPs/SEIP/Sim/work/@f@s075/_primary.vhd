library verilog;
use verilog.vl_types.all;
entity FS075 is
    port(
        D               : in     vl_logic_vector(6 downto 0);
        CK              : in     vl_logic;
        EN              : in     vl_logic;
        TI              : in     vl_logic;
        TE              : in     vl_logic;
        RN              : in     vl_logic;
        Q               : out    vl_logic_vector(6 downto 0);
        \TO\            : out    vl_logic
    );
end FS075;
