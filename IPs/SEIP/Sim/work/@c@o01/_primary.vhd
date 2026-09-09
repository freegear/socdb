library verilog;
use verilog.vl_types.all;
entity CO01 is
    port(
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        CK              : in     vl_logic;
        Q               : out    vl_logic
    );
end CO01;
