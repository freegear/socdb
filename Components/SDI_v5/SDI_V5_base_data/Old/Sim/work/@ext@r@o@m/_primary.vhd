library verilog;
use verilog.vl_types.all;
entity ExtROM is
    port(
        A               : in     vl_logic_vector(13 downto 0);
        CEn             : in     vl_logic;
        OEn             : in     vl_logic;
        Q               : out    vl_logic_vector(7 downto 0)
    );
end ExtROM;
