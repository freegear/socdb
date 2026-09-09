library verilog;
use verilog.vl_types.all;
entity BS20U2 is
    port(
        D               : in     vl_logic_vector(21 downto 0);
        SFT2            : in     vl_logic;
        Y               : out    vl_logic_vector(19 downto 0)
    );
end BS20U2;
