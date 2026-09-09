library verilog;
use verilog.vl_types.all;
entity ODD8 is
    port(
        G2N             : in     vl_logic;
        G1N             : in     vl_logic;
        G4N             : in     vl_logic;
        G3N             : in     vl_logic;
        P1N             : in     vl_logic;
        P2N             : in     vl_logic;
        P3N             : in     vl_logic;
        P4N             : in     vl_logic;
        YG2             : out    vl_logic;
        YG4N            : out    vl_logic;
        YP2             : out    vl_logic;
        YP4N            : out    vl_logic
    );
end ODD8;
