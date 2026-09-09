library verilog;
use verilog.vl_types.all;
entity BS042 is
    port(
        A               : in     vl_logic_vector(3 downto 0);
        SFT             : in     vl_logic;
        Y               : out    vl_logic_vector(3 downto 0)
    );
end BS042;
