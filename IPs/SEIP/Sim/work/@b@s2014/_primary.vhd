library verilog;
use verilog.vl_types.all;
entity BS2014 is
    port(
        D               : in     vl_logic_vector(19 downto 0);
        SFT             : in     vl_logic;
        Y               : out    vl_logic_vector(19 downto 0)
    );
end BS2014;
