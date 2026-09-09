library verilog;
use verilog.vl_types.all;
entity irom is
    generic(
        size            : integer := 16383
    );
    port(
        clk             : in     vl_logic;
        addr            : in     vl_logic_vector(13 downto 0);
        oeb             : in     vl_logic;
        csb             : in     vl_logic;
        romdata         : out    vl_logic_vector(7 downto 0)
    );
end irom;
