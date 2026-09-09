library verilog;
use verilog.vl_types.all;
entity DS32 is
    port(
        S               : in     vl_logic;
        B2              : in     vl_logic;
        A2              : in     vl_logic;
        B1              : in     vl_logic;
        A1              : in     vl_logic;
        B0              : in     vl_logic;
        A0              : in     vl_logic;
        Y2              : out    vl_logic;
        Y1              : out    vl_logic;
        Y0              : out    vl_logic
    );
end DS32;
