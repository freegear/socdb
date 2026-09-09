library verilog;
use verilog.vl_types.all;
entity PPU4 is
    port(
        SFT             : in     vl_logic;
        NSFT            : in     vl_logic;
        AN3             : in     vl_logic;
        AN2             : in     vl_logic;
        AN1             : in     vl_logic;
        AN0             : in     vl_logic;
        RI              : in     vl_logic;
        SN              : in     vl_logic;
        LO              : out    vl_logic;
        P3              : out    vl_logic;
        P2              : out    vl_logic;
        P1              : out    vl_logic;
        P0              : out    vl_logic
    );
end PPU4;
