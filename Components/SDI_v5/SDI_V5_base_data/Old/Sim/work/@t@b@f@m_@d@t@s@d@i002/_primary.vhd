library verilog;
use verilog.vl_types.all;
entity TBFM_DTSDI002 is
    generic(
        ExtInt          : integer := 8;
        AI_Bit          : integer := 8;
        Data_Width      : integer := 8
    );
end TBFM_DTSDI002;
