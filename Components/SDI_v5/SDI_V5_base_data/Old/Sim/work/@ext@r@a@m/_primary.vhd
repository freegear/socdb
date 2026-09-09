library verilog;
use verilog.vl_types.all;
entity ExtRAM is
    port(
        A               : in     vl_logic_vector(14 downto 0);
        CSn             : in     vl_logic;
        WEn             : in     vl_logic;
        OEn             : in     vl_logic;
        DQ              : inout  vl_logic_vector(7 downto 0)
    );
end ExtRAM;
