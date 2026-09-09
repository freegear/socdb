library verilog;
use verilog.vl_types.all;
entity Atb_ismc is
    generic(
        ADDR_WIDTH      : integer := 15;
        DATA_WIDTH      : integer := 32
    );
end Atb_ismc;
