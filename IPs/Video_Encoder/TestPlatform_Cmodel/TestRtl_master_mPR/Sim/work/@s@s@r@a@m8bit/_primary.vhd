library verilog;
use verilog.vl_types.all;
entity SSRAM8bit is
    generic(
        ADDR_WIDTH      : integer := 12
    );
    port(
        CLK             : in     vl_logic;
        ADDR            : in     vl_logic_vector;
        CEn             : in     vl_logic;
        WEn             : in     vl_logic;
        RDATA           : out    vl_logic_vector(7 downto 0);
        WDATA           : in     vl_logic_vector(7 downto 0)
    );
end SSRAM8bit;
