library verilog;
use verilog.vl_types.all;
entity VIDEOEnC_SSRAM32bit is
    generic(
        ADDR_WIDTH      : integer := 30
    );
    port(
        CLK             : in     vl_logic;
        ADDR            : in     vl_logic_vector;
        CEn             : in     vl_logic;
        WEn             : in     vl_logic_vector(3 downto 0);
        RDATA           : out    vl_logic_vector(31 downto 0);
        WDATA           : in     vl_logic_vector(31 downto 0)
    );
end VIDEOEnC_SSRAM32bit;
