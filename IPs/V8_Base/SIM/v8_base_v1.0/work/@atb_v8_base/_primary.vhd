library verilog;
use verilog.vl_types.all;
entity Atb_v8_base is
    generic(
        ADDRWIDTH       : integer := 16;
        CDATAWIDTH      : integer := 8;
        PDATAWIDTH      : integer := 32
    );
end Atb_v8_base;
