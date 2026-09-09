library verilog;
use verilog.vl_types.all;
entity OFD04 is
    port(
        D3              : in     vl_logic;
        D2              : in     vl_logic;
        EN              : in     vl_logic;
        D1              : in     vl_logic;
        D0              : in     vl_logic;
        PD              : in     vl_logic;
        \OF\            : out    vl_logic
    );
end OFD04;
