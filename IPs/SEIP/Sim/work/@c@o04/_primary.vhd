library verilog;
use verilog.vl_types.all;
entity CO04 is
    port(
        RN              : in     vl_logic;
        TE              : in     vl_logic;
        CK              : in     vl_logic;
        SCL             : in     vl_logic;
        TI              : in     vl_logic;
        EN              : in     vl_logic;
        Q3              : out    vl_logic;
        Q2              : out    vl_logic;
        Q1              : out    vl_logic;
        Q0              : out    vl_logic
    );
end CO04;
