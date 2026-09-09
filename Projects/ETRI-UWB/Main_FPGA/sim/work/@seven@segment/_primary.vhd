library verilog;
use verilog.vl_types.all;
entity SevenSegment is
    port(
        Clock           : in     vl_logic;
        nReset          : in     vl_logic;
        DataIn          : in     vl_logic_vector(15 downto 0);
        DotIn           : in     vl_logic_vector(3 downto 0);
        ControlOut      : out    vl_logic_vector(7 downto 0);
        CommonOut       : out    vl_logic_vector(3 downto 0)
    );
end SevenSegment;
