library verilog;
use verilog.vl_types.all;
entity SevenSegmentCode is
    port(
        DataIn          : in     vl_logic_vector(3 downto 0);
        DataOut         : out    vl_logic_vector(7 downto 0)
    );
end SevenSegmentCode;
