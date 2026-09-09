library verilog;
use verilog.vl_types.all;
entity TROMIF is
    port(
        PLACB           : in     vl_logic_vector(8 downto 0);
        EROMA           : in     vl_logic_vector(8 downto 0);
        EROMAS          : in     vl_logic;
        TROMA           : out    vl_logic_vector(8 downto 0)
    );
end TROMIF;
