library verilog;
use verilog.vl_types.all;
entity sram16bit is
    port(
        data            : inout  vl_logic_vector(15 downto 0);
        addr            : in     vl_logic_vector(17 downto 0);
        wrb_0           : in     vl_logic;
        wrb_1           : in     vl_logic;
        rdb             : in     vl_logic;
        csb             : in     vl_logic
    );
end sram16bit;
