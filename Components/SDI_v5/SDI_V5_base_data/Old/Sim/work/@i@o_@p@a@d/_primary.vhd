library verilog;
use verilog.vl_types.all;
entity IO_PAD is
    generic(
        Data_Width      : integer := 8
    );
    port(
        Dir_En0         : in     vl_logic_vector;
        Dir_En1         : in     vl_logic_vector;
        Dir_En2         : in     vl_logic_vector;
        Dir_En3         : in     vl_logic_vector;
        Data_Out0       : in     vl_logic_vector;
        Data_Out1       : in     vl_logic_vector;
        Data_Out2       : in     vl_logic_vector;
        Data_Out3       : in     vl_logic_vector;
        Data_In0        : out    vl_logic_vector;
        Data_In1        : out    vl_logic_vector;
        Data_In2        : out    vl_logic_vector;
        Data_In3        : out    vl_logic_vector;
        BI_PAD0         : inout  vl_logic_vector;
        BI_PAD1         : inout  vl_logic_vector;
        BI_PAD2         : inout  vl_logic_vector;
        BI_PAD3         : inout  vl_logic_vector
    );
end IO_PAD;
