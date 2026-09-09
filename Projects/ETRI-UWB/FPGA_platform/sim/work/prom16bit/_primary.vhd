library verilog;
use verilog.vl_types.all;
entity prom16bit is
    generic(
        wid             : integer := 16;
        size            : integer := 1048576
    );
    port(
        addr            : in     vl_logic_vector(18 downto 0);
        romdata         : out    vl_logic_vector(15 downto 0);
        oeb             : in     vl_logic;
        csb             : in     vl_logic
    );
end prom16bit;
