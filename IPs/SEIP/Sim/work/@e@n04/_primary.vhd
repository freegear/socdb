library verilog;
use verilog.vl_types.all;
entity EN04 is
    port(
        EN              : in     vl_logic;
        A3              : in     vl_logic;
        A2              : in     vl_logic;
        A1              : in     vl_logic;
        A0              : in     vl_logic;
        Y3              : out    vl_logic;
        Y2              : out    vl_logic;
        Y1              : out    vl_logic;
        Y0              : out    vl_logic
    );
end EN04;
