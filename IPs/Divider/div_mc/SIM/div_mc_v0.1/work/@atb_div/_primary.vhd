library verilog;
use verilog.vl_types.all;
entity Atb_div is
    generic(
        WIDTH_DIVD      : integer := 16;
        WIDTH_DIVS      : integer := 16;
        STAGES          : integer := 11
    );
end Atb_div;
