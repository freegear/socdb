library verilog;
use verilog.vl_types.all;
entity SDFFRHQX2 is
    port(
        D               : in     vl_logic;
        SI              : in     vl_logic;
        SE              : in     vl_logic;
        CK              : in     vl_logic;
        RN              : in     vl_logic;
        Q               : out    vl_logic
    );
end SDFFRHQX2;
