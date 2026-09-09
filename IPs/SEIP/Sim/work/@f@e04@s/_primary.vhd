library verilog;
use verilog.vl_types.all;
entity FE04S is
    port(
        D               : in     vl_logic_vector(3 downto 0);
        SN              : in     vl_logic;
        TE              : in     vl_logic;
        CK              : in     vl_logic;
        EN              : in     vl_logic;
        TI              : in     vl_logic;
        Q               : out    vl_logic_vector(3 downto 0);
        \TO\            : out    vl_logic
    );
end FE04S;
