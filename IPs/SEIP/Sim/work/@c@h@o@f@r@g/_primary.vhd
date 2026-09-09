library verilog;
use verilog.vl_types.all;
entity CHOFRG is
    port(
        GPWD            : in     vl_logic_vector(15 downto 0);
        GPA             : in     vl_logic_vector(3 downto 0);
        CHS             : in     vl_logic_vector(5 downto 0);
        TI              : in     vl_logic;
        CHORE           : in     vl_logic;
        XRST            : in     vl_logic;
        TE              : in     vl_logic;
        FSYNC           : in     vl_logic;
        CHONLE          : in     vl_logic;
        CHOWE           : in     vl_logic;
        MCK             : in     vl_logic;
        CHOFDT          : in     vl_logic;
        CHORD           : out    vl_logic_vector(15 downto 0);
        CHOSLD          : out    vl_logic;
        \TO\            : out    vl_logic
    );
end CHOFRG;
