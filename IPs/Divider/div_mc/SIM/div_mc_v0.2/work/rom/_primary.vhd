library verilog;
use verilog.vl_types.all;
entity rom is
    generic(
        size            : integer := 65535
    );
    port(
        addr            : in     vl_logic_vector(15 downto 0);
        romdata         : out    vl_logic_vector(67 downto 0);
        oeb             : in     vl_logic;
        csb             : in     vl_logic
    );
end rom;
