library verilog;
use verilog.vl_types.all;
entity tube is
    generic(
        cr              : integer := 13;
        lf              : integer := 10;
        ctrld           : integer := 4
    );
    port(
        xd              : in     vl_logic_vector(31 downto 0);
        xcsn            : in     vl_logic_vector(3 downto 0);
        xwen            : in     vl_logic_vector(3 downto 0)
    );
end tube;
