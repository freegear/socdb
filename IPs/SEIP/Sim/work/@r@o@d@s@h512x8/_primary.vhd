library verilog;
use verilog.vl_types.all;
entity RODSH512x8 is
    port(
        CLK             : in     vl_logic;
        CEN             : in     vl_logic;
        A               : in     vl_logic_vector(8 downto 0);
        Q               : out    vl_logic_vector(7 downto 0)
    );
end RODSH512x8;
