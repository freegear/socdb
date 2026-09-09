library verilog;
use verilog.vl_types.all;
entity CODD4 is
    port(
        GHN             : in     vl_logic;
        GLN             : in     vl_logic;
        PLN             : in     vl_logic;
        PHN             : in     vl_logic;
        GO              : out    vl_logic;
        PO              : out    vl_logic
    );
end CODD4;
