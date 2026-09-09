library verilog;
use verilog.vl_types.all;
entity BS203 is
    port(
        SFT             : in     vl_logic_vector(2 downto 0);
        D               : in     vl_logic_vector(19 downto 0);
        Y               : out    vl_logic_vector(19 downto 0)
    );
end BS203;
