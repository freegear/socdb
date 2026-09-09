library verilog;
use verilog.vl_types.all;
entity DS43 is
    port(
        A0              : in     vl_logic;
        B0              : in     vl_logic;
        C0              : in     vl_logic;
        B3              : in     vl_logic;
        A3              : in     vl_logic;
        C2              : in     vl_logic;
        A2              : in     vl_logic;
        C1              : in     vl_logic;
        B1              : in     vl_logic;
        S0              : in     vl_logic;
        S1              : in     vl_logic;
        C3              : in     vl_logic;
        B2              : in     vl_logic;
        A1              : in     vl_logic;
        Y3              : out    vl_logic;
        Y2              : out    vl_logic;
        Y1              : out    vl_logic;
        Y0              : out    vl_logic
    );
end DS43;
