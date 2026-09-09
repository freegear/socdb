library verilog;
use verilog.vl_types.all;
entity RDLGC is
    port(
        D19             : in     vl_logic;
        D18             : in     vl_logic;
        D17             : in     vl_logic;
        D16             : in     vl_logic;
        D1              : in     vl_logic;
        D2              : in     vl_logic;
        D3              : in     vl_logic;
        S1              : in     vl_logic;
        S0              : in     vl_logic;
        Y               : out    vl_logic
    );
end RDLGC;
