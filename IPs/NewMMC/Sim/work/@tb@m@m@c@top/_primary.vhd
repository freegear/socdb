library verilog;
use verilog.vl_types.all;
entity tbmmctop is
    generic(
        halfcycle       : integer := 5;
        dly             : integer := 1
    );
end tbmmctop;
