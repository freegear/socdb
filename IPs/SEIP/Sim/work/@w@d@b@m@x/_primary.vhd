library verilog;
use verilog.vl_types.all;
entity WDBMX is
    port(
        WR1O            : in     vl_logic_vector(6 downto 0);
        WSO             : in     vl_logic_vector(15 downto 0);
        WIMO            : in     vl_logic_vector(15 downto 0);
        WIMOEN          : in     vl_logic;
        WSOEN           : in     vl_logic;
        WR1OEN          : in     vl_logic;
        WDB             : out    vl_logic_vector(15 downto 0)
    );
end WDBMX;
