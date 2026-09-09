library verilog;
use verilog.vl_types.all;
entity RA1SH16384x32 is
    generic(
        aw              : integer := 14;
        dw              : integer := 32
    );
    port(
        CLK             : in     vl_logic;
        nRST            : in     vl_logic;
        CEN             : in     vl_logic;
        WEN             : in     vl_logic_vector(3 downto 0);
        A               : in     vl_logic_vector;
        D               : in     vl_logic_vector;
        Q               : out    vl_logic_vector
    );
end RA1SH16384x32;
