library verilog;
use verilog.vl_types.all;
entity EN02N is
    port(
        EN              : in     vl_logic;
        A1              : in     vl_logic;
        A0              : in     vl_logic;
        Y1              : out    vl_logic;
        Y0              : out    vl_logic
    );
end EN02N;
