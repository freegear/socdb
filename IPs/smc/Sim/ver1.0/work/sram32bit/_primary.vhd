library verilog;
use verilog.vl_types.all;
entity sram32bit is
    port(
        data            : inout  vl_logic_vector(31 downto 0);
        addr            : in     vl_logic_vector(17 downto 0);
        we_n            : in     vl_logic;
        oe_n            : in     vl_logic;
        cs_n            : in     vl_logic;
        be0_n           : in     vl_logic;
        be1_n           : in     vl_logic;
        be2_n           : in     vl_logic;
        be3_n           : in     vl_logic
    );
end sram32bit;
