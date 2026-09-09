library verilog;
use verilog.vl_types.all;
entity ssram32bit is
    generic(
        addr_width      : integer := 12
    );
    port(
        clk             : in     vl_logic;
        addr            : in     vl_logic_vector;
        cen             : in     vl_logic;
        wen             : in     vl_logic_vector(3 downto 0);
        rdata           : out    vl_logic_vector(31 downto 0);
        wdata           : in     vl_logic_vector(31 downto 0)
    );
end ssram32bit;
