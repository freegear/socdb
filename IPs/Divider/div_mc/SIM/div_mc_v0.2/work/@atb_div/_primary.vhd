library verilog;
use verilog.vl_types.all;
entity Atb_div is
    generic(
        WIDTH_DIVD      : integer := 24;
        WIDTH_DIVS      : integer := 24;
        STAGES          : integer := 11
    );
end Atb_div;
