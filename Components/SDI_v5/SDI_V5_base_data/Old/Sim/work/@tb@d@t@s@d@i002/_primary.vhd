library verilog;
use verilog.vl_types.all;
entity TbDTSDI002 is
    generic(
        ExtInt          : integer := 8;
        AI_Bit          : integer := 8;
        Data_Width      : integer := 8
    );
end TbDTSDI002;
