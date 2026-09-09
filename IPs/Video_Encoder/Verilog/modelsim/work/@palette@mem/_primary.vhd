library verilog;
use verilog.vl_types.all;
entity PaletteMem is
    generic(
        AW              : integer := 8;
        DW              : integer := 24
    );
    port(
        Clk             : in     vl_logic;
        nRST            : in     vl_logic;
        Csb             : in     vl_logic;
        Web             : in     vl_logic;
        Oeb             : in     vl_logic;
        WAddr           : in     vl_logic_vector;
        RAddr           : in     vl_logic_vector;
        DI              : in     vl_logic_vector;
        DO              : out    vl_logic_vector
    );
end PaletteMem;
