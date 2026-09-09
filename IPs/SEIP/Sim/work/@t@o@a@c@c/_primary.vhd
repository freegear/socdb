library verilog;
use verilog.vl_types.all;
entity TOACC is
    port(
        TSO             : in     vl_logic_vector(19 downto 0);
        TROMO           : in     vl_logic_vector(7 downto 0);
        ACCL            : in     vl_logic;
        XRST            : in     vl_logic;
        DYACLE          : in     vl_logic;
        CHACLE          : in     vl_logic;
        RVACLE          : in     vl_logic;
        DRACLE          : in     vl_logic;
        ESSCL           : in     vl_logic;
        ESSCE           : in     vl_logic;
        DYACEN          : in     vl_logic;
        CHACEN          : in     vl_logic;
        REACEN          : in     vl_logic;
        DLACEN          : in     vl_logic;
        DRACEN          : in     vl_logic;
        TE              : in     vl_logic;
        MCK             : in     vl_logic;
        DLACLE          : in     vl_logic;
        TI              : in     vl_logic;
        ESSD            : out    vl_logic_vector(19 downto 0);
        TACO            : out    vl_logic_vector(19 downto 0);
        \TO\            : out    vl_logic
    );
end TOACC;
