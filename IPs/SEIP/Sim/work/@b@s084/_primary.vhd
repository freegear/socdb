library verilog;
use verilog.vl_types.all;
entity BS084 is
    port(
        A               : in     vl_logic_vector(7 downto 0);
        SFT             : in     vl_logic_vector(3 downto 0);
        Y               : out    vl_logic_vector(19 downto 0)
    );
end BS084;
