library verilog;
use verilog.vl_types.all;
entity BS205L is
    port(
        D               : in     vl_logic_vector(22 downto 0);
        SFT             : in     vl_logic_vector(3 downto 0);
        U4SFT           : in     vl_logic;
        Y               : out    vl_logic_vector(19 downto 0)
    );
end BS205L;
