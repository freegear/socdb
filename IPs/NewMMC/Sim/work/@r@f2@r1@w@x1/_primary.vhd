library verilog;
use verilog.vl_types.all;
entity rf2r1wx1 is
    port(
        r1b             : out    vl_logic;
        r2b             : out    vl_logic;
        wb              : in     vl_logic;
        ww              : in     vl_logic;
        r1w             : in     vl_logic;
        r2w             : in     vl_logic
    );
end rf2r1wx1;
