library verilog;
use verilog.vl_types.all;
entity CL07 is
    port(
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        SCL             : in     vl_logic;
        CE              : in     vl_logic;
        LE              : in     vl_logic;
        CK              : in     vl_logic;
        SE              : in     vl_logic;
        Q               : out    vl_logic_vector(6 downto 0);
        \TO\            : out    vl_logic
    );
end CL07;
