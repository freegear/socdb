library verilog;
use verilog.vl_types.all;
entity SPC24 is
    port(
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        EN              : in     vl_logic;
        D               : in     vl_logic;
        CK              : in     vl_logic;
        Q               : out    vl_logic_vector(19 downto 0);
        \TO\            : out    vl_logic
    );
end SPC24;
