library verilog;
use verilog.vl_types.all;
entity DCO04 is
    port(
        QS              : in     vl_logic;
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        CE2             : in     vl_logic;
        TI              : in     vl_logic;
        SCL             : in     vl_logic;
        CE1             : in     vl_logic;
        CK              : in     vl_logic;
        \TO\            : out    vl_logic;
        Q3              : out    vl_logic;
        Q2              : out    vl_logic;
        Q1              : out    vl_logic;
        Q0              : out    vl_logic
    );
end DCO04;
