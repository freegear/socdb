library verilog;
use verilog.vl_types.all;
entity TbSEIP is
    generic(
        RXAW            : integer := 3;
        TXAW            : integer := 3;
        RXCON           : integer := 2048;
        RXSTS           : integer := 2049;
        RXDAT           : integer := 2050;
        TXCON           : integer := 2052;
        TXSTS           : integer := 2053;
        TXDAT           : integer := 2054;
        CKP1            : integer := 5;
        DLY             : integer := 2
    );
end TbSEIP;
