library verilog;
use verilog.vl_types.all;
entity FE04RC is
    port(
        D3              : in     vl_logic;
        D2              : in     vl_logic;
        D1              : in     vl_logic;
        D0              : in     vl_logic;
        CK              : in     vl_logic;
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        EN              : in     vl_logic;
        TI              : in     vl_logic;
        Q0              : out    vl_logic;
        Q1              : out    vl_logic;
        Q2              : out    vl_logic;
        Q3              : out    vl_logic;
        \TO\            : out    vl_logic
    );
end FE04RC;
