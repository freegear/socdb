library verilog;
use verilog.vl_types.all;
entity Tb_NFTop is
    generic(
        byte            : integer := 0;
        halfword        : integer := 1;
        cycle2          : integer := 0;
        cycle3          : integer := 1;
        cycle4          : integer := 2;
        cycle5          : integer := 3;
        NoOption        : integer := 0;
        RnBWait         : integer := 1;
        AutoRdStat      : integer := 2;
        Continue        : integer := 3;
        FIFOLEVEL       : integer := 0
    );
end Tb_NFTop;
