library verilog;
use verilog.vl_types.all;
entity RA1SH512x16 is
    generic(
        aw              : integer := 9;
        dw              : integer := 16
    );
    port(
        CLK             : in     vl_logic;
        CEN             : in     vl_logic;
        WEN             : in     vl_logic;
        A               : in     vl_logic_vector;
        D               : in     vl_logic_vector;
        Q               : out    vl_logic_vector
    );
end RA1SH512x16;
