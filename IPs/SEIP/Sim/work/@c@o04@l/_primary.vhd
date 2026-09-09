library verilog;
use verilog.vl_types.all;
entity CO04L is
    port(
        D               : in     vl_logic_vector(3 downto 0);
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        CK              : in     vl_logic;
        SCL             : in     vl_logic;
        LE              : in     vl_logic;
        CE              : in     vl_logic;
        Q3              : out    vl_logic;
        Q2              : out    vl_logic;
        Q1              : out    vl_logic;
        Q0              : out    vl_logic;
        \TO\            : out    vl_logic
    );
end CO04L;
