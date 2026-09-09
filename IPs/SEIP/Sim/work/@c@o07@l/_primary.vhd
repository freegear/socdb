library verilog;
use verilog.vl_types.all;
entity CO07L is
    port(
        D               : in     vl_logic_vector(6 downto 0);
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        CK              : in     vl_logic;
        SCL             : in     vl_logic;
        LE              : in     vl_logic;
        CE              : in     vl_logic;
        Q               : out    vl_logic_vector(6 downto 0);
        \TO\            : out    vl_logic
    );
end CO07L;
