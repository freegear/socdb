library verilog;
use verilog.vl_types.all;
entity CL06 is
    port(
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        TI              : in     vl_logic;
        SCL             : in     vl_logic;
        CE              : in     vl_logic;
        LE              : in     vl_logic;
        CK              : in     vl_logic;
        SE              : in     vl_logic;
        Q5              : out    vl_logic;
        Q4              : out    vl_logic;
        Q3              : out    vl_logic;
        Q2              : out    vl_logic;
        Q1              : out    vl_logic;
        Q0              : out    vl_logic;
        \TO\            : out    vl_logic
    );
end CL06;
