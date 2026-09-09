library verilog;
use verilog.vl_types.all;
entity FE02RC is
    port(
        D1              : in     vl_logic;
        D0              : in     vl_logic;
        EN              : in     vl_logic;
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        CK              : in     vl_logic;
        Q1              : out    vl_logic;
        Q0              : out    vl_logic;
        \TO\            : out    vl_logic
    );
end FE02RC;
